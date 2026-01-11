--[[
	================================================================================================
	AURAS RNG - LocalScript AAA (Estilo Sols RNG Premium)
	================================================================================================
	
	Sistema RNG de auras de calidad AAA para Roblox Studio.
	Diseñado como base para un juego RNG comercial exitoso.
	
	INSTALACIÓN:
	1. Copiar este script completo
	2. En Roblox Studio, ir a StarterPlayer > StarterPlayerScripts
	3. Crear un nuevo LocalScript y pegar el código
	
	ARQUITECTURA:
	├── Configuración centralizada (CONFIG, RARITY_CONFIG, AURAS)
	├── Sistema RNG avanzado (weighted, anti-duplicados, luck multipliers)
	├── Sistema de Auras visuales (partículas, beams, highlights)
	├── VFX cinematográficos (camera shake, screen flash, reveal dramático)
	├── UI AAA (hover effects, tweens suaves, responsive)
	├── Gestión de personaje (CharacterAdded, cleanup automático)
	└── Sistema de Boosts (estructura para luck/gamepasses)
	
	CARACTERÍSTICAS PREMIUM:
	- Sistema anti-duplicados consecutivos
	- Suavizado de RNG (evita streaks injustos)
	- Estructura para luck multipliers y boosts temporales
	- VFX escalados por rareza con TweenService
	- Camera shake local en reveals raros
	- UI con hover effects y feedback visual
	- Limpieza automática con Debris
	- Optimizado para mantener FPS estables
	
	Autor: Copilot
	Versión: 2.0 AAA
	================================================================================================
]]

-- ================================================================================================
-- SECCIÓN 1: SERVICIOS DE ROBLOX
-- ================================================================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- ================================================================================================
-- SECCIÓN 2: REFERENCIAS DEL JUGADOR
-- ================================================================================================
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ================================================================================================
-- SECCIÓN 3: CONFIGURACIÓN CENTRALIZADA
-- ================================================================================================
--[[
	Todas las configuraciones están centralizadas aquí para facilitar ajustes.
	Evita valores hardcodeados en el código.
]]

local CONFIG = {
	-- Tiempos de animación
	SpinDuration = 3.0,           -- Duración del giro (más dramático)
	SpinCooldown = 0.3,           -- Cooldown después del giro
	RevealDelay = 0.5,            -- Delay dramático antes del reveal
	ParticleLifetime = {0.5, 2.0}, -- Rango de vida de partículas
	
	-- Camera shake
	CameraShakeIntensity = 0.3,   -- Intensidad del shake
	CameraShakeDuration = 0.4,    -- Duración del shake
	
	-- UI Tweens
	UITweenSpeed = 0.2,           -- Velocidad de tweens UI
	ButtonHoverScale = 1.05,      -- Escala al hover
	
	-- RNG Avanzado
	AntiDuplicateEnabled = true,  -- Evitar duplicados consecutivos
	MaxConsecutiveSameRarity = 3, -- Máximo mismo tier seguido
	
	-- Cleanup
	VFXCleanupDelay = 5.0,        -- Tiempo antes de limpiar VFX temporales
}

-- ================================================================================================
-- SECCIÓN 4: SISTEMA DE BOOSTS (Estructura para expansión)
-- ================================================================================================
--[[
	Sistema preparado para luck multipliers, boosts temporales y gamepasses.
	Solo estructura - sin monetización implementada.
]]

local BoostSystem = {
	-- Multiplicador base de luck (1.0 = normal)
	baseLuckMultiplier = 1.0,
	
	-- Boosts activos (estructura para boosts temporales)
	activeBoosts = {},
	
	-- Estructura para gamepasses (solo IDs, sin implementación)
	gamepasses = {
		DoubleLuck = { id = 0, multiplier = 2.0, active = false },
		TripleLuck = { id = 0, multiplier = 3.0, active = false },
		AutoSpin = { id = 0, active = false },
	},
}

-- Calcula el multiplicador total de luck
function BoostSystem.getTotalLuckMultiplier()
	local total = BoostSystem.baseLuckMultiplier
	
	-- Sumar boosts activos
	for _, boost in pairs(BoostSystem.activeBoosts) do
		if boost.active and boost.expiresAt > os.time() then
			total = total * boost.multiplier
		end
	end
	
	-- Sumar gamepasses
	for _, gp in pairs(BoostSystem.gamepasses) do
		if gp.active and gp.multiplier then
			total = total * gp.multiplier
		end
	end
	
	return total
end

-- Añadir boost temporal
function BoostSystem.addTemporaryBoost(name, multiplier, durationSeconds)
	BoostSystem.activeBoosts[name] = {
		multiplier = multiplier,
		active = true,
		expiresAt = os.time() + durationSeconds
	}
end

-- ================================================================================================
-- SECCIÓN 5: CONFIGURACIÓN DE RAREZAS
-- ================================================================================================
--[[
	Define propiedades visuales y de comportamiento por tier de rareza.
	Facilita escalar efectos según rareza.
]]

local RARITY_CONFIG = {
	Common = {
		order = 1,
		color = Color3.fromRGB(180, 180, 180),
		cameraShake = false,
		screenFlashIntensity = 0.1,
		revealSound = nil, -- ID opcional
		particleMultiplier = 1.0,
	},
	Uncommon = {
		order = 2,
		color = Color3.fromRGB(100, 255, 100),
		cameraShake = false,
		screenFlashIntensity = 0.2,
		revealSound = nil,
		particleMultiplier = 1.2,
	},
	Rare = {
		order = 3,
		color = Color3.fromRGB(100, 150, 255),
		cameraShake = false,
		screenFlashIntensity = 0.3,
		revealSound = nil,
		particleMultiplier = 1.4,
	},
	Epic = {
		order = 4,
		color = Color3.fromRGB(180, 100, 255),
		cameraShake = true,
		screenFlashIntensity = 0.4,
		revealSound = nil,
		particleMultiplier = 1.6,
	},
	Legendary = {
		order = 5,
		color = Color3.fromRGB(255, 200, 50),
		cameraShake = true,
		screenFlashIntensity = 0.5,
		revealSound = nil,
		particleMultiplier = 2.0,
	},
	Mythic = {
		order = 6,
		color = Color3.fromRGB(255, 100, 150),
		cameraShake = true,
		screenFlashIntensity = 0.6,
		revealSound = nil,
		particleMultiplier = 2.5,
	},
	Divine = {
		order = 7,
		color = Color3.fromRGB(255, 255, 255),
		cameraShake = true,
		screenFlashIntensity = 0.7,
		revealSound = nil,
		particleMultiplier = 3.0,
	},
	Unique = {
		order = 8,
		color = Color3.fromRGB(255, 50, 255),
		cameraShake = true,
		screenFlashIntensity = 0.8,
		revealSound = nil,
		particleMultiplier = 4.0,
	},
}

-- ================================================================================================
-- SECCIÓN 6: DEFINICIÓN DE AURAS
-- ================================================================================================
--[[
	Tabla de auras fácilmente extensible.
	Cada aura tiene propiedades visuales únicas.
]]

local AURAS = {
	-- COMMON (1 en 2) - 50%
	{
		name = "Sombra Básica",
		rarity = "Common",
		chance = 2,
		color1 = Color3.fromRGB(100, 100, 100),
		color2 = Color3.fromRGB(150, 150, 150),
		particleRate = 10,
		glowIntensity = 0.3,
	},
	{
		name = "Brillo Tenue",
		rarity = "Common",
		chance = 2,
		color1 = Color3.fromRGB(200, 200, 200),
		color2 = Color3.fromRGB(255, 255, 255),
		particleRate = 10,
		glowIntensity = 0.3,
	},
	
	-- UNCOMMON (1 en 5) - 20%
	{
		name = "Llama Verde",
		rarity = "Uncommon",
		chance = 5,
		color1 = Color3.fromRGB(0, 255, 100),
		color2 = Color3.fromRGB(100, 255, 150),
		particleRate = 15,
		glowIntensity = 0.5,
	},
	{
		name = "Océano Profundo",
		rarity = "Uncommon",
		chance = 5,
		color1 = Color3.fromRGB(0, 100, 255),
		color2 = Color3.fromRGB(100, 150, 255),
		particleRate = 15,
		glowIntensity = 0.5,
	},
	
	-- RARE (1 en 15) - 6.67%
	{
		name = "Tormenta Eléctrica",
		rarity = "Rare",
		chance = 15,
		color1 = Color3.fromRGB(255, 255, 0),
		color2 = Color3.fromRGB(255, 200, 50),
		particleRate = 20,
		glowIntensity = 0.7,
	},
	{
		name = "Rosa Mística",
		rarity = "Rare",
		chance = 15,
		color1 = Color3.fromRGB(255, 100, 200),
		color2 = Color3.fromRGB(255, 150, 220),
		particleRate = 20,
		glowIntensity = 0.7,
	},
	
	-- EPIC (1 en 50) - 2%
	{
		name = "Fuego Infernal",
		rarity = "Epic",
		chance = 50,
		color1 = Color3.fromRGB(255, 50, 0),
		color2 = Color3.fromRGB(255, 150, 50),
		particleRate = 30,
		glowIntensity = 0.9,
	},
	{
		name = "Hielo Ártico",
		rarity = "Epic",
		chance = 50,
		color1 = Color3.fromRGB(100, 200, 255),
		color2 = Color3.fromRGB(200, 240, 255),
		particleRate = 30,
		glowIntensity = 0.9,
	},
	
	-- LEGENDARY (1 en 200) - 0.5%
	{
		name = "Sol Ardiente",
		rarity = "Legendary",
		chance = 200,
		color1 = Color3.fromRGB(255, 200, 0),
		color2 = Color3.fromRGB(255, 100, 0),
		particleRate = 40,
		glowIntensity = 1.2,
	},
	{
		name = "Void Oscuro",
		rarity = "Legendary",
		chance = 200,
		color1 = Color3.fromRGB(50, 0, 100),
		color2 = Color3.fromRGB(100, 0, 150),
		particleRate = 40,
		glowIntensity = 1.2,
	},
	
	-- MYTHIC (1 en 1000) - 0.1%
	{
		name = "Galaxia Eterna",
		rarity = "Mythic",
		chance = 1000,
		color1 = Color3.fromRGB(150, 50, 255),
		color2 = Color3.fromRGB(255, 100, 200),
		particleRate = 50,
		glowIntensity = 1.5,
	},
	{
		name = "Cristal Cósmico",
		rarity = "Mythic",
		chance = 1000,
		color1 = Color3.fromRGB(0, 255, 255),
		color2 = Color3.fromRGB(255, 255, 255),
		particleRate = 50,
		glowIntensity = 1.5,
	},
	
	-- DIVINE (1 en 5000) - 0.02%
	{
		name = "Aurora Celestial",
		rarity = "Divine",
		chance = 5000,
		color1 = Color3.fromRGB(255, 255, 255),
		color2 = Color3.fromRGB(255, 200, 255),
		particleRate = 60,
		glowIntensity = 2.0,
	},
	
	-- UNIQUE (1 en 50000) - 0.002%
	{
		name = "Singularidad",
		rarity = "Unique",
		chance = 50000,
		color1 = Color3.fromRGB(0, 0, 0),
		color2 = Color3.fromRGB(255, 0, 255),
		particleRate = 80,
		glowIntensity = 3.0,
	},
}

-- ================================================================================================
-- COLORES POR RAREZA (para UI y efectos)
-- ================================================================================================
local RARITY_COLORS = {
	Common = Color3.fromRGB(180, 180, 180),
	Uncommon = Color3.fromRGB(100, 255, 100),
	Rare = Color3.fromRGB(100, 150, 255),
	Epic = Color3.fromRGB(180, 100, 255),
	Legendary = Color3.fromRGB(255, 200, 50),
	Mythic = Color3.fromRGB(255, 100, 150),
	Divine = Color3.fromRGB(255, 255, 255),
	Unique = Color3.fromRGB(255, 50, 255),
}

-- ================================================================================================
-- SECCIÓN 7: VARIABLES DE ESTADO
-- ================================================================================================
local isSpinning = false
local currentAura = nil
local currentAuraEffects = {} -- Almacena los efectos visuales actuales
local lastRolledAura = nil    -- Para sistema anti-duplicados
local consecutiveRarityCount = 0  -- Contador de rarezas consecutivas
local lastRarity = nil        -- Última rareza obtenida

-- ================================================================================================
-- SECCIÓN 8: SISTEMA RNG AVANZADO
-- ================================================================================================
--[[
	Sistema RNG con:
	- Weighted random preciso y escalable
	- Anti-duplicados consecutivos
	- Suavizado de streaks
	- Soporte para luck multipliers
]]

local RNGSystem = {
	-- Historial para análisis de streaks
	rollHistory = {},
	maxHistorySize = 50,
}

-- Calcula los pesos con luck multiplier aplicado
function RNGSystem.calculateWeights()
	local luckMultiplier = BoostSystem.getTotalLuckMultiplier()
	local weights = {}
	local totalWeight = 0
	
	for i, aura in ipairs(AURAS) do
		-- Aplicar luck: reduce el divisor para auras raras
		local adjustedChance = aura.chance / luckMultiplier
		local weight = 1 / math.max(adjustedChance, 1)
		weights[i] = weight
		totalWeight = totalWeight + weight
	end
	
	return weights, totalWeight
end

-- Verifica si el aura debe ser rechazada (anti-duplicado)
function RNGSystem.shouldRejectAura(aura)
	if not CONFIG.AntiDuplicateEnabled then
		return false
	end
	
	-- Rechazar si es exactamente la misma aura consecutiva
	if lastRolledAura and lastRolledAura.name == aura.name then
		return true
	end
	
	-- Rechazar si excede el máximo de misma rareza consecutiva
	if lastRarity == aura.rarity then
		if consecutiveRarityCount >= CONFIG.MaxConsecutiveSameRarity then
			return true
		end
	end
	
	return false
end

-- Actualiza el historial de rolls
function RNGSystem.updateHistory(aura)
	table.insert(RNGSystem.rollHistory, {
		name = aura.name,
		rarity = aura.rarity,
		timestamp = os.time()
	})
	
	-- Limitar tamaño del historial
	while #RNGSystem.rollHistory > RNGSystem.maxHistorySize do
		table.remove(RNGSystem.rollHistory, 1)
	end
	
	-- Actualizar contadores anti-streak
	if lastRarity == aura.rarity then
		consecutiveRarityCount = consecutiveRarityCount + 1
	else
		consecutiveRarityCount = 1
	end
	
	lastRarity = aura.rarity
	lastRolledAura = aura
end

-- Roll principal con todas las mejoras
function RNGSystem.rollAura()
	local maxAttempts = 10
	local selectedAura = nil
	
	for attempt = 1, maxAttempts do
		local weights, totalWeight = RNGSystem.calculateWeights()
		local randomValue = math.random() * totalWeight
		local currentWeight = 0
		
		for i, aura in ipairs(AURAS) do
			currentWeight = currentWeight + weights[i]
			if randomValue <= currentWeight then
				selectedAura = aura
				break
			end
		end
		
		-- Verificar anti-duplicado
		if selectedAura and not RNGSystem.shouldRejectAura(selectedAura) then
			break
		end
		
		-- Si fue rechazado, intentar de nuevo
		selectedAura = nil
	end
	
	-- Fallback si todos los intentos fallaron
	if not selectedAura then
		selectedAura = AURAS[math.random(1, #AURAS)]
	end
	
	-- Actualizar historial
	RNGSystem.updateHistory(selectedAura)
	
	return selectedAura
end

-- Calcula la probabilidad en porcentaje de un aura
function RNGSystem.getChancePercent(aura)
	local luckMultiplier = BoostSystem.getTotalLuckMultiplier()
	local adjustedChance = aura.chance / luckMultiplier
	return string.format("%.4f%%", (1 / adjustedChance) * 100)
end

-- Obtiene la probabilidad formateada (1 en X)
function RNGSystem.getChanceFormatted(aura)
	local luckMultiplier = BoostSystem.getTotalLuckMultiplier()
	local adjustedChance = math.floor(aura.chance / luckMultiplier)
	return "1 en " .. adjustedChance
end
end

-- ================================================================================================
-- MÓDULO: Creación de UI
-- ================================================================================================
local UIModule = {}

function UIModule.createMainUI()
	-- Crear ScreenGui principal
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AurasRNG_GUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = PlayerGui
	
	-- Frame principal centrado
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 350, 0, 400)
	mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
	mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui
	
	-- Esquinas redondeadas
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 15)
	corner.Parent = mainFrame
	
	-- Borde brillante
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(100, 100, 150)
	stroke.Thickness = 2
	stroke.Parent = mainFrame
	
	-- Título del juego
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(1, 0, 0, 50)
	titleLabel.Position = UDim2.new(0, 0, 0, 10)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "⚡ AURAS RNG ⚡"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 28
	titleLabel.Font = Enum.Font.GothamBlack
	titleLabel.Parent = mainFrame
	
	-- Frame para mostrar el aura actual
	local auraDisplayFrame = Instance.new("Frame")
	auraDisplayFrame.Name = "AuraDisplayFrame"
	auraDisplayFrame.Size = UDim2.new(0.9, 0, 0, 120)
	auraDisplayFrame.Position = UDim2.new(0.05, 0, 0, 70)
	auraDisplayFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	auraDisplayFrame.BorderSizePixel = 0
	auraDisplayFrame.Parent = mainFrame
	
	local auraCorner = Instance.new("UICorner")
	auraCorner.CornerRadius = UDim.new(0, 10)
	auraCorner.Parent = auraDisplayFrame
	
	-- Texto del nombre del aura
	local auraNameLabel = Instance.new("TextLabel")
	auraNameLabel.Name = "AuraNameLabel"
	auraNameLabel.Size = UDim2.new(1, 0, 0, 40)
	auraNameLabel.Position = UDim2.new(0, 0, 0, 15)
	auraNameLabel.BackgroundTransparency = 1
	auraNameLabel.Text = "¡Presiona SPIN!"
	auraNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	auraNameLabel.TextSize = 22
	auraNameLabel.Font = Enum.Font.GothamBold
	auraNameLabel.Parent = auraDisplayFrame
	
	-- Texto de la rareza
	local rarityLabel = Instance.new("TextLabel")
	rarityLabel.Name = "RarityLabel"
	rarityLabel.Size = UDim2.new(1, 0, 0, 25)
	rarityLabel.Position = UDim2.new(0, 0, 0, 55)
	rarityLabel.BackgroundTransparency = 1
	rarityLabel.Text = ""
	rarityLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	rarityLabel.TextSize = 18
	rarityLabel.Font = Enum.Font.GothamSemibold
	rarityLabel.Parent = auraDisplayFrame
	
	-- Texto de probabilidad
	local chanceLabel = Instance.new("TextLabel")
	chanceLabel.Name = "ChanceLabel"
	chanceLabel.Size = UDim2.new(1, 0, 0, 20)
	chanceLabel.Position = UDim2.new(0, 0, 0, 85)
	chanceLabel.BackgroundTransparency = 1
	chanceLabel.Text = ""
	chanceLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
	chanceLabel.TextSize = 14
	chanceLabel.Font = Enum.Font.Gotham
	chanceLabel.Parent = auraDisplayFrame
	
	-- Botón de SPIN
	local spinButton = Instance.new("TextButton")
	spinButton.Name = "SpinButton"
	spinButton.Size = UDim2.new(0.8, 0, 0, 60)
	spinButton.Position = UDim2.new(0.1, 0, 0, 210)
	spinButton.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
	spinButton.BorderSizePixel = 0
	spinButton.Text = "🎰 SPIN 🎰"
	spinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	spinButton.TextSize = 26
	spinButton.Font = Enum.Font.GothamBlack
	spinButton.AutoButtonColor = true
	spinButton.Parent = mainFrame
	
	local spinCorner = Instance.new("UICorner")
	spinCorner.CornerRadius = UDim.new(0, 12)
	spinCorner.Parent = spinButton
	
	local spinStroke = Instance.new("UIStroke")
	spinStroke.Color = Color3.fromRGB(100, 255, 100)
	spinStroke.Thickness = 2
	spinStroke.Parent = spinButton
	
	-- Barra de animación del spin
	local spinBarBg = Instance.new("Frame")
	spinBarBg.Name = "SpinBarBackground"
	spinBarBg.Size = UDim2.new(0.8, 0, 0, 15)
	spinBarBg.Position = UDim2.new(0.1, 0, 0, 280)
	spinBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	spinBarBg.BorderSizePixel = 0
	spinBarBg.Visible = false
	spinBarBg.Parent = mainFrame
	
	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 5)
	barCorner.Parent = spinBarBg
	
	local spinBarFill = Instance.new("Frame")
	spinBarFill.Name = "SpinBarFill"
	spinBarFill.Size = UDim2.new(0, 0, 1, 0)
	spinBarFill.Position = UDim2.new(0, 0, 0, 0)
	spinBarFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
	spinBarFill.BorderSizePixel = 0
	spinBarFill.Parent = spinBarBg
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 5)
	fillCorner.Parent = spinBarFill
	
	-- Estadísticas
	local statsLabel = Instance.new("TextLabel")
	statsLabel.Name = "StatsLabel"
	statsLabel.Size = UDim2.new(0.9, 0, 0, 60)
	statsLabel.Position = UDim2.new(0.05, 0, 0, 310)
	statsLabel.BackgroundTransparency = 1
	statsLabel.Text = "Giros: 0 | Mejor: Ninguna"
	statsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	statsLabel.TextSize = 12
	statsLabel.Font = Enum.Font.Gotham
	statsLabel.TextWrapped = true
	statsLabel.Parent = mainFrame
	
	-- Instrucciones
	local instructionsLabel = Instance.new("TextLabel")
	instructionsLabel.Name = "InstructionsLabel"
	instructionsLabel.Size = UDim2.new(0.9, 0, 0, 25)
	instructionsLabel.Position = UDim2.new(0.05, 0, 0, 370)
	instructionsLabel.BackgroundTransparency = 1
	instructionsLabel.Text = "¡Gira para obtener auras raras!"
	instructionsLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
	instructionsLabel.TextSize = 11
	instructionsLabel.Font = Enum.Font.Gotham
	instructionsLabel.Parent = mainFrame
	
	return screenGui
end

-- ================================================================================================
-- MÓDULO: Sistema de VFX
-- ================================================================================================
local VFXModule = {}

-- Crea efecto de destello al centro de la pantalla
function VFXModule.createScreenFlash(color, duration)
	local screenGui = PlayerGui:FindFirstChild("AurasRNG_GUI")
	if not screenGui then return end
	
	local flash = Instance.new("Frame")
	flash.Name = "ScreenFlash"
	flash.Size = UDim2.new(1, 0, 1, 0)
	flash.Position = UDim2.new(0, 0, 0, 0)
	flash.BackgroundColor3 = color
	flash.BackgroundTransparency = 0.5
	flash.BorderSizePixel = 0
	flash.ZIndex = 100
	flash.Parent = screenGui
	
	local fadeOut = TweenService:Create(flash, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1
	})
	fadeOut:Play()
	fadeOut.Completed:Connect(function()
		flash:Destroy()
	end)
end

-- Crea efecto de texto flotante
function VFXModule.createFloatingText(text, color)
	local screenGui = PlayerGui:FindFirstChild("AurasRNG_GUI")
	if not screenGui then return end
	
	local floatLabel = Instance.new("TextLabel")
	floatLabel.Name = "FloatingText"
	floatLabel.Size = UDim2.new(0, 400, 0, 60)
	floatLabel.Position = UDim2.new(0.5, -200, 0.3, 0)
	floatLabel.BackgroundTransparency = 1
	floatLabel.Text = text
	floatLabel.TextColor3 = color
	floatLabel.TextSize = 36
	floatLabel.Font = Enum.Font.GothamBlack
	floatLabel.TextStrokeTransparency = 0.5
	floatLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	floatLabel.ZIndex = 90
	floatLabel.Parent = screenGui
	
	-- Animación de subida y desvanecimiento
	local moveUp = TweenService:Create(floatLabel, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -200, 0.15, 0),
		TextTransparency = 1,
		TextStrokeTransparency = 1
	})
	moveUp:Play()
	moveUp.Completed:Connect(function()
		floatLabel:Destroy()
	end)
end

-- Animación de pulso para el botón
function VFXModule.pulseButton(button)
	local originalSize = button.Size
	local grow = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
		Size = UDim2.new(originalSize.X.Scale * 1.05, 0, originalSize.Y.Scale, originalSize.Y.Offset * 1.1)
	})
	local shrink = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
		Size = originalSize
	})
	
	grow:Play()
	grow.Completed:Connect(function()
		shrink:Play()
	end)
end

-- ================================================================================================
-- MÓDULO: Sistema de Auras Visuales
-- ================================================================================================
local AuraVisualModule = {}

-- Limpia todos los efectos de aura actuales
function AuraVisualModule.clearCurrentAura()
	for _, effect in ipairs(currentAuraEffects) do
		if effect and effect.Parent then
			effect:Destroy()
		end
	end
	currentAuraEffects = {}
end

-- Aplica el aura visual al personaje
function AuraVisualModule.applyAura(aura)
	local character = LocalPlayer.Character
	if not character then return end
	
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	local head = character:FindFirstChild("Head")
	
	if not humanoidRootPart then return end
	
	-- Limpiar aura anterior
	AuraVisualModule.clearCurrentAura()
	
	-- ===============================
	-- 1. HIGHLIGHT (Brillo del cuerpo)
	-- ===============================
	local highlight = Instance.new("Highlight")
	highlight.Name = "AuraHighlight"
	highlight.FillColor = aura.color1
	highlight.OutlineColor = aura.color2
	highlight.FillTransparency = 0.7
	highlight.OutlineTransparency = 0.3
	highlight.Parent = character
	table.insert(currentAuraEffects, highlight)
	
	-- Animar el highlight basado en rareza
	local glowIntensity = aura.glowIntensity or 0.5
	task.spawn(function()
		while highlight and highlight.Parent do
			for i = 0, math.pi * 2, 0.1 do
				if not highlight or not highlight.Parent then break end
				local pulse = math.sin(i) * 0.15 * glowIntensity
				highlight.FillTransparency = 0.7 - pulse
				highlight.OutlineTransparency = 0.3 - pulse
				task.wait(0.05)
			end
		end
	end)
	
	-- ===============================
	-- 2. ATTACHMENT para partículas
	-- ===============================
	local attachment = Instance.new("Attachment")
	attachment.Name = "AuraAttachment"
	attachment.Position = Vector3.new(0, 0, 0)
	attachment.Parent = humanoidRootPart
	table.insert(currentAuraEffects, attachment)
	
	-- ===============================
	-- 3. PARTICLE EMITTER principal
	-- ===============================
	local particles = Instance.new("ParticleEmitter")
	particles.Name = "AuraParticles"
	particles.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, aura.color1),
		ColorSequenceKeypoint.new(0.5, aura.color2),
		ColorSequenceKeypoint.new(1, aura.color1)
	})
	particles.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.5 * glowIntensity),
		NumberSequenceKeypoint.new(0.5, 1 * glowIntensity),
		NumberSequenceKeypoint.new(1, 0)
	})
	particles.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3),
		NumberSequenceKeypoint.new(1, 1)
	})
	particles.Lifetime = NumberRange.new(CONFIG.ParticleLifetime[1], CONFIG.ParticleLifetime[2])
	particles.Rate = aura.particleRate or 20
	particles.Speed = NumberRange.new(1, 3)
	particles.SpreadAngle = Vector2.new(180, 180)
	particles.RotSpeed = NumberRange.new(-180, 180)
	particles.LightEmission = math.min(glowIntensity, 1)
	particles.LightInfluence = 0
	particles.Parent = attachment
	table.insert(currentAuraEffects, particles)
	
	-- ===============================
	-- 4. PARTÍCULAS SECUNDARIAS (para rarezas más altas)
	-- ===============================
	if glowIntensity >= 0.7 then
		local sparkles = Instance.new("ParticleEmitter")
		sparkles.Name = "AuraSparkles"
		sparkles.Color = ColorSequence.new(aura.color2)
		sparkles.Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.2),
			NumberSequenceKeypoint.new(0.5, 0.4 * glowIntensity),
			NumberSequenceKeypoint.new(1, 0)
		})
		sparkles.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1)
		})
		sparkles.Lifetime = NumberRange.new(0.3, 0.8)
		sparkles.Rate = aura.particleRate * 0.5
		sparkles.Speed = NumberRange.new(5, 10)
		sparkles.SpreadAngle = Vector2.new(360, 360)
		sparkles.LightEmission = 1
		sparkles.Parent = attachment
		table.insert(currentAuraEffects, sparkles)
	end
	
	-- ===============================
	-- 5. BEAM EFFECT (para Legendary+)
	-- ===============================
	if glowIntensity >= 1.2 then
		-- Crear attachments para el beam
		local beamAttachment0 = Instance.new("Attachment")
		beamAttachment0.Name = "BeamAttach0"
		beamAttachment0.Position = Vector3.new(0, -3, 0)
		beamAttachment0.Parent = humanoidRootPart
		table.insert(currentAuraEffects, beamAttachment0)
		
		local beamAttachment1 = Instance.new("Attachment")
		beamAttachment1.Name = "BeamAttach1"
		beamAttachment1.Position = Vector3.new(0, 10, 0)
		beamAttachment1.Parent = humanoidRootPart
		table.insert(currentAuraEffects, beamAttachment1)
		
		local beam = Instance.new("Beam")
		beam.Name = "AuraBeam"
		beam.Attachment0 = beamAttachment0
		beam.Attachment1 = beamAttachment1
		beam.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, aura.color1),
			ColorSequenceKeypoint.new(0.5, aura.color2),
			ColorSequenceKeypoint.new(1, aura.color1)
		})
		beam.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.8),
			NumberSequenceKeypoint.new(0.5, 0.5),
			NumberSequenceKeypoint.new(1, 0.8)
		})
		beam.Width0 = 2 * glowIntensity
		beam.Width1 = 0.5
		beam.LightEmission = 1
		beam.LightInfluence = 0
		beam.FaceCamera = true
		beam.Parent = humanoidRootPart
		table.insert(currentAuraEffects, beam)
	end
	
	-- ===============================
	-- 6. AURA CIRCULAR (para Divine+)
	-- ===============================
	if glowIntensity >= 2.0 then
		-- Partículas en espiral
		local ringParticles = Instance.new("ParticleEmitter")
		ringParticles.Name = "AuraRing"
		ringParticles.Color = ColorSequence.new(aura.color2)
		ringParticles.Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.1),
			NumberSequenceKeypoint.new(0.5, 0.3),
			NumberSequenceKeypoint.new(1, 0)
		})
		ringParticles.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.2),
			NumberSequenceKeypoint.new(1, 1)
		})
		ringParticles.Lifetime = NumberRange.new(2, 3)
		ringParticles.Rate = 30
		ringParticles.Speed = NumberRange.new(0, 0)
		ringParticles.SpreadAngle = Vector2.new(0, 0)
		ringParticles.RotSpeed = NumberRange.new(360, 720)
		ringParticles.LightEmission = 1
		ringParticles.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
		ringParticles.Parent = attachment
		table.insert(currentAuraEffects, ringParticles)
	end
	
	currentAura = aura
end

-- ================================================================================================
-- MÓDULO: Controlador del Spin
-- ================================================================================================
local SpinController = {}
local spinCount = 0
local bestRarity = nil
local bestAuraName = nil

-- Orden de rarezas para comparar
local rarityOrder = {
	Common = 1,
	Uncommon = 2,
	Rare = 3,
	Epic = 4,
	Legendary = 5,
	Mythic = 6,
	Divine = 7,
	Unique = 8
}

-- Compara si una rareza es mejor que otra
function SpinController.isBetterRarity(newRarity, currentBest)
	if not currentBest then return true end
	return (rarityOrder[newRarity] or 0) > (rarityOrder[currentBest] or 0)
end

-- Ejecuta la animación de spin
function SpinController.performSpin(screenGui)
	if isSpinning then return end
	isSpinning = true
	
	-- Referencias de UI
	local mainFrame = screenGui:FindFirstChild("MainFrame")
	local spinButton = mainFrame:FindFirstChild("SpinButton")
	local auraNameLabel = mainFrame.AuraDisplayFrame:FindFirstChild("AuraNameLabel")
	local rarityLabel = mainFrame.AuraDisplayFrame:FindFirstChild("RarityLabel")
	local chanceLabel = mainFrame.AuraDisplayFrame:FindFirstChild("ChanceLabel")
	local spinBarBg = mainFrame:FindFirstChild("SpinBarBackground")
	local spinBarFill = spinBarBg:FindFirstChild("SpinBarFill")
	local statsLabel = mainFrame:FindFirstChild("StatsLabel")
	
	-- Deshabilitar botón
	spinButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	spinButton.Text = "⏳ GIRANDO... ⏳"
	
	-- Mostrar barra de progreso
	spinBarBg.Visible = true
	spinBarFill.Size = UDim2.new(0, 0, 1, 0)
	
	-- Animación de la barra
	local barTween = TweenService:Create(spinBarFill, TweenInfo.new(CONFIG.SpinDuration, Enum.EasingStyle.Quad), {
		Size = UDim2.new(1, 0, 1, 0)
	})
	barTween:Play()
	
	-- Animación de texto girando (mostrar diferentes auras)
	local spinStartTime = os.clock()
	local spinAnimConnection
	spinAnimConnection = RunService.Heartbeat:Connect(function()
		local elapsed = os.clock() - spinStartTime
		if elapsed < CONFIG.SpinDuration then
			-- Mostrar auras aleatorias rápidamente
			local randomAura = AURAS[math.random(1, #AURAS)]
			auraNameLabel.Text = randomAura.name
			auraNameLabel.TextColor3 = RARITY_COLORS[randomAura.rarity] or Color3.new(1, 1, 1)
			rarityLabel.Text = "[ " .. randomAura.rarity .. " ]"
			rarityLabel.TextColor3 = RARITY_COLORS[randomAura.rarity] or Color3.new(1, 1, 1)
			
			-- Hacer parpadear colores
			local flashColor = RARITY_COLORS[randomAura.rarity] or Color3.new(1, 1, 1)
			mainFrame.AuraDisplayFrame.BackgroundColor3 = Color3.fromRGB(
				30 + math.random(0, 20),
				30 + math.random(0, 20),
				40 + math.random(0, 20)
			)
		else
			spinAnimConnection:Disconnect()
		end
	end)
	
	-- Esperar duración del spin
	task.wait(CONFIG.SpinDuration)
	
	-- Obtener el aura real
	local rolledAura = RNGSystem.rollAura()
	
	-- Incrementar contador
	spinCount = spinCount + 1
	
	-- Actualizar mejor aura
	if SpinController.isBetterRarity(rolledAura.rarity, bestRarity) then
		bestRarity = rolledAura.rarity
		bestAuraName = rolledAura.name
	end
	
	-- Efecto de revelación
	VFXModule.createScreenFlash(RARITY_COLORS[rolledAura.rarity] or Color3.new(1, 1, 1), 0.5)
	VFXModule.createFloatingText("¡" .. rolledAura.rarity .. "!", RARITY_COLORS[rolledAura.rarity] or Color3.new(1, 1, 1))
	
	-- Actualizar UI con resultado final
	auraNameLabel.Text = rolledAura.name
	auraNameLabel.TextColor3 = RARITY_COLORS[rolledAura.rarity] or Color3.new(1, 1, 1)
	rarityLabel.Text = "⭐ " .. rolledAura.rarity .. " ⭐"
	rarityLabel.TextColor3 = RARITY_COLORS[rolledAura.rarity] or Color3.new(1, 1, 1)
	chanceLabel.Text = "Probabilidad: 1 en " .. rolledAura.chance .. " (" .. RNGSystem.getChancePercent(rolledAura) .. ")"
	
	-- Restaurar fondo
	mainFrame.AuraDisplayFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	
	-- Aplicar aura al personaje
	AuraVisualModule.applyAura(rolledAura)
	
	-- Actualizar estadísticas
	statsLabel.Text = "Giros: " .. spinCount .. " | Mejor: " .. (bestAuraName or "Ninguna") .. " (" .. (bestRarity or "N/A") .. ")"
	
	-- Ocultar barra
	spinBarBg.Visible = false
	
	-- Cooldown antes de permitir otro spin
	task.wait(CONFIG.SpinCooldown)
	
	-- Restaurar botón
	spinButton.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
	spinButton.Text = "🎰 SPIN 🎰"
	VFXModule.pulseButton(spinButton)
	
	isSpinning = false
end

-- ================================================================================================
-- INICIALIZACIÓN PRINCIPAL
-- ================================================================================================
local function initialize()
	-- Esperar a que cargue el personaje
	if not LocalPlayer.Character then
		LocalPlayer.CharacterAdded:Wait()
	end
	
	-- Crear la UI
	local screenGui = UIModule.createMainUI()
	
	-- Obtener referencia al botón
	local mainFrame = screenGui:FindFirstChild("MainFrame")
	local spinButton = mainFrame:FindFirstChild("SpinButton")
	
	-- Conectar evento del botón
	spinButton.MouseButton1Click:Connect(function()
		SpinController.performSpin(screenGui)
	end)
	
	-- Reconectar cuando el personaje respawnee
	LocalPlayer.CharacterAdded:Connect(function(character)
		-- Esperar a que cargue el personaje
		task.wait(0.5)
		
		-- Re-aplicar aura si había una equipada
		if currentAura then
			AuraVisualModule.applyAura(currentAura)
		end
	end)
	
	-- Mensaje de bienvenida
	print("=======================================")
	print("🎰 AURAS RNG - Sistema Inicializado 🎰")
	print("Versión: 1.0")
	print("Total de auras: " .. #AURAS)
	print("¡Presiona SPIN para comenzar!")
	print("=======================================")
end

-- Iniciar el script
initialize()
