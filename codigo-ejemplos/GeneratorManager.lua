-- GeneratorManager.lua
-- Controla los generadores que los supervivientes deben activar
-- TIPO: ModuleScript
-- UBICACIÓN: ServerScriptService

local Players = game:GetService("Players")
local Workspace = game.Workspace
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configuración
local TIEMPO_ACTIVACION = 5  -- Segundos que tarda en activarse

-- Referencias
local generators = Workspace.GameMap.Generators:GetChildren()

-- FUNCIÓN: Configurar un generador
local function configurarGenerador(generador)
	local clickDetector = generador:FindFirstChild("ClickDetector")
	local activado = generador:FindFirstChild("Activado")

	if clickDetector and activado then
		-- Cuando alguien hace clic
		clickDetector.MouseClick:Connect(function(jugador)
			-- Solo supervivientes pueden activar
			if jugador:FindFirstChild("Rol") and jugador.Rol.Value == "Superviviente" then
				if not activado.Value then
					-- Iniciar activación
					print(jugador.Name .. " está activando " .. generador.Name)

					-- Mensaje al jugador
					if jugador:FindFirstChild("PlayerGui") then
						local screenGui = jugador.PlayerGui:FindFirstChild("MensajeGui")
						if screenGui and screenGui:FindFirstChild("Mensaje") then
							screenGui.Mensaje.Text = "Activando generador... (" .. TIEMPO_ACTIVACION .. "s)"
						end
					end

					-- Esperar tiempo de activación
					wait(TIEMPO_ACTIVACION)

					-- Activar generador
					activado.Value = true
					generador.Color = Color3.new(0, 1, 0)  -- Verde = activado
					generador.Material = Enum.Material.Neon

					print(generador.Name .. " activado!")

					-- Verificar si todos están activados
					verificarVictoria()
				end
			else
				print(jugador.Name .. " no puede activar generadores (es cazador o no tiene rol)")
			end
		end)
	end
end

-- FUNCIÓN: Verificar si todos los generadores están activados
function verificarVictoria()
	local todosActivados = true

	for _, gen in pairs(generators) do
		local activado = gen:FindFirstChild("Activado")
		if activado and not activado.Value then
			todosActivados = false
			break
		end
	end

	if todosActivados then
		print("¡Todos los generadores activados! Supervivientes ganan")

		-- Obtener el GameManager para llamar victoria
		local victoriaEvent = game.ReplicatedStorage:FindFirstChild("VictoriaSupervivientes")
		if victoriaEvent then
			victoriaEvent:Fire()
		end
	end
end

-- FUNCIÓN: Reiniciar generadores
local function reiniciarGeneradores()
	for _, gen in pairs(generators) do
		local activado = gen:FindFirstChild("Activado")
		if activado then
			activado.Value = false
			gen.Color = Color3.new(0.3, 0.3, 0.3)  -- Gris
			gen.Material = Enum.Material.Metal
		end
	end
end

-- Configurar todos los generadores
for _, gen in pairs(generators) do
	configurarGenerador(gen)
end

-- Exponer función para reiniciar (usaremos esto desde GameManager)
local GeneratorService = {}
GeneratorService.Reiniciar = reiniciarGeneradores
GeneratorService.Verificar = verificarVictoria

return GeneratorService
