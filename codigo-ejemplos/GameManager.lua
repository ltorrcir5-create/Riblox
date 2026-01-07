-- GameManager.lua
-- Este script controla el flujo del juego
-- UBICACIÓN: ServerScriptService

-- CONFIGURACIÓN
local TIEMPO_INTERMISION = 10  -- Segundos en el lobby antes de empezar
local TIEMPO_JUEGO = 180       -- Segundos de duración de cada ronda (3 minutos)
local MIN_JUGADORES = 2        -- Mínimo de jugadores para empezar

-- REFERENCIAS a objetos del juego
local Players = game:GetService("Players")  -- Servicio que maneja jugadores
local ReplicatedStorage = game:GetService("ReplicatedStorage")  -- Para compartir información
local Workspace = game.Workspace  -- El mundo del juego

-- Módulo de generadores
local GeneratorManager = require(script.Parent.GeneratorManager)

-- Evento de victoria
local victoriaEvent = ReplicatedStorage:FindFirstChild("VictoriaSupervivientes")
if victoriaEvent then
	victoriaEvent.Event:Connect(function()
		victoriaSupervivientes()
	end)
end

-- VARIABLES GLOBALES
local estadoJuego = "Intermision"  -- Estado actual: Intermision, Playing, Ending
local tiempoRestante = TIEMPO_INTERMISION

-- FUNCIÓN: Obtener todos los jugadores activos
local function obtenerJugadores()
	local jugadores = {}
	for _, jugador in pairs(Players:GetPlayers()) do
		if jugador.Character and jugador.Character:FindFirstChild("Humanoid") then
			if jugador.Character.Humanoid.Health > 0 then
				table.insert(jugadores, jugador)
			end
		end
	end
	return jugadores
end

-- FUNCIÓN: Teletransportar jugador al lobby
local function teletransportarLobby(jugador)
	local spawnLobby = Workspace.Lobby:FindFirstChild("SpawnLobby")
	if spawnLobby and jugador.Character and jugador.Character:FindFirstChild("HumanoidRootPart") then
		-- Posición aleatoria en el spawn del lobby
		local randomX = math.random(-20, 20)
		local randomZ = math.random(-20, 20)
		local posicion = spawnLobby.Position + Vector3.new(randomX, 5, randomZ)
		jugador.Character.HumanoidRootPart.CFrame = CFrame.new(posicion)
	end
end

-- FUNCIÓN: Mensaje a todos los jugadores
local function enviarMensaje(mensaje)
	for _, jugador in pairs(Players:GetPlayers()) do
		if jugador:FindFirstChild("PlayerGui") then
			-- Crear mensaje en pantalla
			local screenGui = jugador.PlayerGui:FindFirstChild("MensajeGui")
			if not screenGui then
				screenGui = Instance.new("ScreenGui")
				screenGui.Name = "MensajeGui"
				screenGui.Parent = jugador.PlayerGui
			end

			local textLabel = screenGui:FindFirstChild("Mensaje")
			if not textLabel then
				textLabel = Instance.new("TextLabel")
				textLabel.Name = "Mensaje"
				textLabel.Size = UDim2.new(1, 0, 0.1, 0)
				textLabel.Position = UDim2.new(0, 0, 0.05, 0)
				textLabel.BackgroundTransparency = 0.5
				textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
				textLabel.TextColor3 = Color3.new(1, 1, 1)
				textLabel.TextScaled = true
				textLabel.Font = Enum.Font.SourceSansBold
				textLabel.Parent = screenGui
			end

			textLabel.Text = mensaje
		end
	end
end

-- FUNCIÓN: Configurar características del personaje según rol
local function configurarPersonaje(jugador)
	if jugador.Character and jugador:FindFirstChild("Rol") then
		local humanoid = jugador.Character:FindFirstChild("Humanoid")
		if humanoid then
			if jugador.Rol.Value == "Cazador" then
				-- Cazador: más rápido
				humanoid.WalkSpeed = 20  -- Velocidad normal es 16

				-- Cambiar color para identificar (opcional)
				for _, parte in pairs(jugador.Character:GetChildren()) do
					if parte:IsA("BasePart") then
						parte.Color = Color3.new(0.8, 0, 0)  -- Rojo oscuro
					end
				end
			else
				-- Superviviente: velocidad normal
				humanoid.WalkSpeed = 16
			end
		end
	end
end

-- FUNCIÓN: Dar herramientas según rol
local function darHerramientas(jugador)
	if jugador:FindFirstChild("Rol") and jugador.Character then
		-- Limpiar herramientas anteriores
		if jugador:FindFirstChild("Backpack") then
			jugador.Backpack:ClearAllChildren()
		end
		if jugador.Character:FindFirstChild("CuchilloCazador") then
			jugador.Character.CuchilloCazador:Destroy()
		end

		if jugador.Rol.Value == "Cazador" then
			-- Dar cuchillo al cazador
			local cuchillo = game.ReplicatedStorage:FindFirstChild("CuchilloCazador")
			if cuchillo then
				local cuchilloCopia = cuchillo:Clone()
				cuchilloCopia.Parent = jugador.Backpack
			end
		end
	end
end

-- FUNCIÓN: Asignar roles a jugadores
local function asignarRoles()
	local jugadores = obtenerJugadores()

	-- Limpiar roles anteriores
	for _, jugador in pairs(jugadores) do
		if jugador:FindFirstChild("Rol") then
			jugador.Rol:Destroy()
		end
	end

	-- Elegir cazador aleatorio
	local cazador = jugadores[math.random(1, #jugadores)]

	-- Asignar rol de cazador
	local rolCazador = Instance.new("StringValue")
	rolCazador.Name = "Rol"
	rolCazador.Value = "Cazador"
	rolCazador.Parent = cazador

	-- Asignar rol de superviviente a los demás
	for _, jugador in pairs(jugadores) do
		if jugador ~= cazador then
			local rolSuperviviente = Instance.new("StringValue")
			rolSuperviviente.Name = "Rol"
			rolSuperviviente.Value = "Superviviente"
			rolSuperviviente.Parent = jugador
		end
	end

	-- Avisar a cada jugador su rol
	for _, jugador in pairs(jugadores) do
		if jugador:FindFirstChild("Rol") then
			local rol = jugador.Rol.Value
			if jugador:FindFirstChild("PlayerGui") then
				local screenGui = jugador.PlayerGui:FindFirstChild("MensajeGui")
				if screenGui then
					local rolLabel = screenGui:FindFirstChild("RolLabel")
					if not rolLabel then
						rolLabel = Instance.new("TextLabel")
						rolLabel.Name = "RolLabel"
						rolLabel.Size = UDim2.new(0.3, 0, 0.08, 0)
						rolLabel.Position = UDim2.new(0.7, 0, 0.02, 0)
						rolLabel.BackgroundTransparency = 0.3
						rolLabel.TextScaled = true
						rolLabel.Font = Enum.Font.SourceSansBold
						rolLabel.Parent = screenGui
					end

					if rol == "Cazador" then
						rolLabel.Text = "🔪 CAZADOR"
						rolLabel.BackgroundColor3 = Color3.new(1, 0, 0)
						rolLabel.TextColor3 = Color3.new(1, 1, 1)
					else
						rolLabel.Text = "🏃 SUPERVIVIENTE"
						rolLabel.BackgroundColor3 = Color3.new(0, 0.5, 1)
						rolLabel.TextColor3 = Color3.new(1, 1, 1)
					end
				end
			end
		end
	end

	-- Configurar personajes
	for _, jugador in pairs(jugadores) do
		configurarPersonaje(jugador)
		darHerramientas(jugador)
	end

	return cazador
end

-- FUNCIÓN: Teletransportar jugadores al mapa
local function teletransportarMapa()
	local jugadores = obtenerJugadores()
	local survivorSpawns = Workspace.GameMap.SurvivorSpawns:GetChildren()
	local hunterSpawn = Workspace.GameMap:FindFirstChild("HunterSpawn")

	local spawnIndex = 1

	for _, jugador in pairs(jugadores) do
		if jugador:FindFirstChild("Rol") and jugador.Character and jugador.Character:FindFirstChild("HumanoidRootPart") then
			if jugador.Rol.Value == "Cazador" then
				-- Teletransportar cazador
				if hunterSpawn then
					jugador.Character.HumanoidRootPart.CFrame = CFrame.new(hunterSpawn.Position + Vector3.new(0, 3, 0))
				end
			else
				-- Teletransportar superviviente
				if survivorSpawns[spawnIndex] then
					jugador.Character.HumanoidRootPart.CFrame = CFrame.new(survivorSpawns[spawnIndex].Position + Vector3.new(0, 3, 0))
					spawnIndex = spawnIndex + 1
					if spawnIndex > #survivorSpawns then
						spawnIndex = 1
					end
				end
			end
		end
	end
end

-- FUNCIÓN: Verificar si quedan supervivientes vivos
local function verificarSupervivientes()
	local jugadores = obtenerJugadores()
	local supervivientesVivos = 0

	for _, jugador in pairs(jugadores) do
		if jugador:FindFirstChild("Rol") and jugador.Rol.Value == "Superviviente" then
			supervivientesVivos = supervivientesVivos + 1
		end
	end

	return supervivientesVivos
end

-- FUNCIÓN: Detectar victoria de supervivientes
function victoriaSupervivientes()
	if estadoJuego ~= "Playing" then return end

	terminarRonda("🎉 ¡LOS SUPERVIVIENTES GANARON! Todos los generadores activados.")
end

-- FUNCIÓN: Detectar victoria del cazador
local function victoriaCazador()
	if estadoJuego ~= "Playing" then return end

	terminarRonda("💀 ¡EL CAZADOR GANÓ! Todos los supervivientes eliminados.")
end

-- FUNCIÓN: Monitorear estado del juego
local function monitorearJuego()
	while estadoJuego == "Playing" do
		wait(1)

		-- Verificar si quedan supervivientes
		local supervivientes = verificarSupervivientes()
		if supervivientes == 0 then
			victoriaCazador()
			break
		end
	end
end

-- FUNCIÓN: Intermisión (espera en lobby)
local function intermision()
	estadoJuego = "Intermision"
	tiempoRestante = TIEMPO_INTERMISION

	-- Teletransportar todos al lobby
	for _, jugador in pairs(Players:GetPlayers()) do
		teletransportarLobby(jugador)
	end
	
	-- Reiniciar generadores
	if GeneratorManager then
		GeneratorManager.Reiniciar()
	end

	-- Cuenta regresiva
	while tiempoRestante > 0 do
		local jugadores = obtenerJugadores()

		if #jugadores >= MIN_JUGADORES then
			enviarMensaje("Juego comenzando en " .. tiempoRestante .. " segundos...")
		else
			enviarMensaje("Esperando jugadores... (" .. #jugadores .. "/" .. MIN_JUGADORES .. ")")
			tiempoRestante = TIEMPO_INTERMISION  -- Reiniciar si no hay suficientes
		end

		wait(1)
		tiempoRestante = tiempoRestante - 1
	end
end

-- FUNCIÓN: Iniciar ronda de juego
local function iniciarRonda()
	estadoJuego = "Playing"
	tiempoRestante = TIEMPO_JUEGO

	enviarMensaje("¡La ronda ha comenzado!")
	wait(2)

	-- Asignar roles
	local cazador = asignarRoles()
	enviarMensaje("¡Los roles han sido asignados!")
	wait(2)

	-- Teletransportar jugadores
	teletransportarMapa()
	enviarMensaje("¡A jugar!")
	wait(2)
	
	-- Iniciar monitoreo del juego
	spawn(monitorearJuego)

	-- Cuenta regresiva del juego
	while tiempoRestante > 0 and estadoJuego == "Playing" do
		enviarMensaje("Tiempo restante: " .. tiempoRestante .. " segundos")
		wait(1)
		tiempoRestante = tiempoRestante - 1
	end

	if estadoJuego == "Playing" then
		terminarRonda("¡Se acabó el tiempo!")
	end
end

-- FUNCIÓN: Terminar ronda
function terminarRonda(razon)
	estadoJuego = "Ending"
	enviarMensaje(razon)
	wait(5)
end

-- FUNCIÓN: Bucle principal del juego
local function buclePrincipal()
	while true do
		intermision()
		iniciarRonda()
	end
end

-- INICIAR el juego
print("GameManager iniciado correctamente")
buclePrincipal()
