-- UIManager.lua
-- Crea una interfaz mejorada para cada jugador
-- TIPO: Script
-- UBICACIÓN: ServerScriptService

local Players = game:GetService("Players")

-- FUNCIÓN: Crear UI para un jugador
local function crearUI(jugador)
	jugador.CharacterAdded:Connect(function(character)
		wait(1)  -- Esperar a que cargue

		if jugador:FindFirstChild("PlayerGui") then
			local playerGui = jugador.PlayerGui

			-- Limpiar UI anterior si existe
			if playerGui:FindFirstChild("GameUI") then
				playerGui.GameUI:Destroy()
			end

			-- Crear ScreenGui principal
			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "GameUI"
			screenGui.ResetOnSpawn = false
			screenGui.Parent = playerGui

			-- Panel de información superior
			local infoPanel = Instance.new("Frame")
			infoPanel.Name = "InfoPanel"
			infoPanel.Size = UDim2.new(1, 0, 0.08, 0)
			infoPanel.Position = UDim2.new(0, 0, 0, 0)
			infoPanel.BackgroundColor3 = Color3.new(0, 0, 0)
			infoPanel.BackgroundTransparency = 0.3
			infoPanel.BorderSizePixel = 0
			infoPanel.Parent = screenGui

			-- Label del rol
			local rolLabel = Instance.new("TextLabel")
			rolLabel.Name = "RolLabel"
			rolLabel.Size = UDim2.new(0.25, 0, 1, 0)
			rolLabel.Position = UDim2.new(0.75, 0, 0, 0)
			rolLabel.BackgroundTransparency = 1
			rolLabel.TextColor3 = Color3.new(1, 1, 1)
			rolLabel.TextScaled = true
			rolLabel.Font = Enum.Font.SourceSansBold
			rolLabel.Text = "Esperando rol..."
			rolLabel.Parent = infoPanel

			-- Label de tiempo
			local tiempoLabel = Instance.new("TextLabel")
			tiempoLabel.Name = "TiempoLabel"
			tiempoLabel.Size = UDim2.new(0.25, 0, 1, 0)
			tiempoLabel.Position = UDim2.new(0, 0, 0, 0)
			tiempoLabel.BackgroundTransparency = 1
			tiempoLabel.TextColor3 = Color3.new(1, 1, 1)
			tiempoLabel.TextScaled = true
			tiempoLabel.Font = Enum.Font.SourceSansBold
			tiempoLabel.Text = "⏱️ --:--"
			tiempoLabel.Parent = infoPanel

			-- Label de mensaje central
			local mensajeLabel = Instance.new("TextLabel")
			mensajeLabel.Name = "MensajeLabel"
			mensajeLabel.Size = UDim2.new(0.5, 0, 0.15, 0)
			mensajeLabel.Position = UDim2.new(0.25, 0, 0.4, 0)
			mensajeLabel.BackgroundTransparency = 0.5
			mensajeLabel.BackgroundColor3 = Color3.new(0, 0, 0)
			mensajeLabel.TextColor3 = Color3.new(1, 1, 1)
			mensajeLabel.TextScaled = true
			mensajeLabel.Font = Enum.Font.SourceSansBold
			mensajeLabel.Text = ""
			mensajeLabel.Visible = false
			mensajeLabel.Parent = screenGui

			-- Indicador de generadores (solo para supervivientes)
			local generadoresFrame = Instance.new("Frame")
			generadoresFrame.Name = "GeneradoresFrame"
			generadoresFrame.Size = UDim2.new(0.3, 0, 0.1, 0)
			generadoresFrame.Position = UDim2.new(0.35, 0, 0.15, 0)
			generadoresFrame.BackgroundColor3 = Color3.new(0, 0, 0)
			generadoresFrame.BackgroundTransparency = 0.5
			generadoresFrame.Visible = false
			generadoresFrame.Parent = screenGui

			local generadoresLabel = Instance.new("TextLabel")
			generadoresLabel.Name = "GeneradoresLabel"
			generadoresLabel.Size = UDim2.new(1, 0, 1, 0)
			generadoresLabel.BackgroundTransparency = 1
			generadoresLabel.TextColor3 = Color3.new(1, 1, 1)
			generadoresLabel.TextScaled = true
			generadoresLabel.Font = Enum.Font.SourceSansBold
			generadoresLabel.Text = "⚡ Generadores: 0/4"
			generadoresLabel.Parent = generadoresFrame
		end
	end)
end

-- Crear UI para jugadores existentes
for _, jugador in pairs(Players:GetPlayers()) do
	crearUI(jugador)
end

-- Crear UI para nuevos jugadores
Players.PlayerAdded:Connect(crearUI)
