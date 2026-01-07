-- CuchilloScript.lua
-- Script del arma del cazador
-- TIPO: Script (dentro de la Tool)
-- UBICACIÓN: ReplicatedStorage → CuchilloCazador → CuchilloScript

local tool = script.Parent
local handle = tool:WaitForChild("Handle")

local DAÑO = 100  -- Daño que hace (100 = mata instantáneamente)
local COOLDOWN = 1  -- Segundos entre ataques
local puedeAtacar = true

-- Función para atacar
local function atacar()
	if not puedeAtacar then return end

	puedeAtacar = false

	-- Detectar qué toca el cuchillo
	local conexion
	conexion = handle.Touched:Connect(function(parte)
		if parte.Parent:FindFirstChild("Humanoid") then
			local victima = game.Players:GetPlayerFromCharacter(parte.Parent)
			local atacante = game.Players:GetPlayerFromCharacter(tool.Parent)

			if victima and atacante then
				-- Verificar que el atacante es el cazador
				if atacante:FindFirstChild("Rol") and atacante.Rol.Value == "Cazador" then
					-- Verificar que la víctima es superviviente
					if victima:FindFirstChild("Rol") and victima.Rol.Value == "Superviviente" then
						-- Hacer daño
						parte.Parent.Humanoid:TakeDamage(DAÑO)
						print(atacante.Name .. " atacó a " .. victima.Name)
					end
				end
			end
		end
	end)

	-- Animación simple: mover el cuchillo
	local originalPos = handle.CFrame
	handle.CFrame = handle.CFrame * CFrame.new(0, 0, -2)  -- Mover hacia adelante
	task.wait(0.2)
	handle.CFrame = originalPos

	conexion:Disconnect()

	task.wait(COOLDOWN)
	puedeAtacar = true
end

-- Cuando se activa la herramienta
tool.Activated:Connect(atacar)
