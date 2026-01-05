--!strict
-- Single LocalScript that builds a full RNG Aura game experience from scratch.
-- Place this script in StarterPlayerScripts or StarterGui to run.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

type Aura = {
	Name: string,
	Rarity: string,
	Chance: number,
	Color: Color3,
	AnimationId: string,
	Particles: { [string]: any }?
}

local state = "Loading" -- Loading, Menu, Rolling, Result
local auraInventory: { Aura } = {}
local currentAuraEffect: Instance? = nil
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

local rarityStyle = {
	Common = {Color = Color3.fromRGB(170, 170, 170), EmitRate = 8, AnimationId = "rbxassetid://507766388"},
	Rare = {Color = Color3.fromRGB(66, 134, 244), EmitRate = 12, AnimationId = "rbxassetid://507766666"},
	Epic = {Color = Color3.fromRGB(159, 72, 255), EmitRate = 18, AnimationId = "rbxassetid://507777268"},
	Legendary = {Color = Color3.fromRGB(255, 199, 34), EmitRate = 26, AnimationId = "rbxassetid://2510196951"},
	Mythic = {Color = Color3.fromRGB(255, 84, 107), EmitRate = 35, AnimationId = "rbxassetid://507771019"},
	Celestial = {Color = Color3.fromRGB(255, 255, 255), EmitRate = 45, AnimationId = "rbxassetid://507772104"}
}

local auras: { Aura } = {
	{Name = "Breeze", Rarity = "Common", Chance = 46, Color = rarityStyle.Common.Color, AnimationId = rarityStyle.Common.AnimationId},
	{Name = "Spark", Rarity = "Common", Chance = 25, Color = rarityStyle.Common.Color, AnimationId = rarityStyle.Common.AnimationId},
	{Name = "Ocean Pulse", Rarity = "Rare", Chance = 12, Color = rarityStyle.Rare.Color, AnimationId = rarityStyle.Rare.AnimationId},
	{Name = "Crystal Bloom", Rarity = "Rare", Chance = 7, Color = rarityStyle.Rare.Color, AnimationId = rarityStyle.Rare.AnimationId},
	{Name = "Eclipse", Rarity = "Epic", Chance = 5, Color = rarityStyle.Epic.Color, AnimationId = rarityStyle.Epic.AnimationId},
	{Name = "Phoenix Fire", Rarity = "Legendary", Chance = 2.5, Color = rarityStyle.Legendary.Color, AnimationId = rarityStyle.Legendary.AnimationId},
	{Name = "Void Emperor", Rarity = "Mythic", Chance = 1.3, Color = rarityStyle.Mythic.Color, AnimationId = rarityStyle.Mythic.AnimationId},
	{Name = "Celestial Nova", Rarity = "Celestial", Chance = 0.2, Color = rarityStyle.Celestial.Color, AnimationId = rarityStyle.Celestial.AnimationId}
}

local function sumChances(): number
	local total = 0
	for _, aura in ipairs(auras) do
		total += aura.Chance
	end
	return total
end

local totalWeight = sumChances()

local function pickAura(): Aura
	local roll = math.random() * totalWeight
	local cursor = 0
	for _, aura in ipairs(auras) do
		cursor += aura.Chance
		if roll <= cursor then
			return aura
		end
	end
	return auras[#auras]
end

local playerModule: any
local controls: any
do
	local ok, module = pcall(function()
		return require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
	end)
	if ok and module then
		playerModule = module
		local success, controlModule = pcall(function()
			return playerModule:GetControls()
		end)
		if success then
			controls = controlModule
		end
	end
end

local function disableInput()
	if controls then
		controls:Disable()
	end
	ContextActionService:BindAction("BlockInput", function()
		return Enum.ContextActionResult.Sink
	end, false, unpack(Enum.PlayerActions:GetEnumItems()))
	UserInputService.ModalEnabled = true
end

local function enableInput()
	ContextActionService:UnbindAction("BlockInput")
	if controls then
		controls:Enable()
	end
	UserInputService.ModalEnabled = false
end

local originalCameraType = camera.CameraType
local originalCameraSubject = camera.CameraSubject
local originalCFrame = camera.CFrame

local function setMenuCamera()
	if not camera then
		return
	end
	camera.CameraType = Enum.CameraType.Scriptable
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if root then
		camera.CFrame = root.CFrame * CFrame.new(0, 4, 12) * CFrame.Angles(0, math.rad(180), 0)
	else
		camera.CFrame = CFrame.new(Vector3.new(0, 5, 12), Vector3.new(0, 3, 0))
	end
end

local function restoreCamera()
	if not camera then
		return
	end
	camera.CameraType = originalCameraType
	camera.CameraSubject = originalCameraSubject
	camera.CFrame = originalCFrame
end

local function tween(instance: Instance, props: {[string]: any}, time: number, style: Enum.EasingStyle?, direction: Enum.EasingDirection?)
	local info = TweenInfo.new(time, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
	local tweenObj = TweenService:Create(instance, info, props)
	tweenObj:Play()
	return tweenObj
end

local function applyGradient(ui: UIGradient)
	local rotation = 0
	RunService.RenderStepped:Connect(function(dt)
		rotation += dt * 10
		ui.Rotation = rotation % 360
	end)
end

local function clearAuraEffects()
	if currentAuraEffect then
		currentAuraEffect:Destroy()
		currentAuraEffect = nil
	end
end

local function applyAuraEffect(aura: Aura)
	clearAuraEffects()
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	local attachment = Instance.new("Attachment")
	attachment.Name = "AuraAttachment"
	attachment.Parent = hrp

	local particles = Instance.new("ParticleEmitter")
	particles.Name = "AuraEmitter"
	particles.Color = ColorSequence.new(aura.Color)
	particles.LightEmission = 0.4
	particles.Rate = rarityStyle[aura.Rarity] and rarityStyle[aura.Rarity].EmitRate or 10
	particles.Speed = NumberRange.new(2, 5)
	particles.Lifetime = NumberRange.new(1.2, 1.8)
	particles.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.6),
		NumberSequenceKeypoint.new(1, 0)
	})
	particles.Texture = "rbxassetid://6516649271"
	particles.Transparency = NumberSequence.new(0.2, 1)
	particles.Rotation = NumberRange.new(0, 360)
	particles.SpreadAngle = Vector2.new(15, 15)
	particles.Parent = attachment

	local auraBillboard = Instance.new("BillboardGui")
	auraBillboard.Name = "AuraBillboard"
	auraBillboard.Adornee = hrp
	auraBillboard.Size = UDim2.new(0, 200, 0, 50)
	auraBillboard.StudsOffset = Vector3.new(0, 3, 0)
	auraBillboard.AlwaysOnTop = true
	auraBillboard.Parent = hrp

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, 0, 1, 0)
	title.Text = aura.Name .. " [" .. aura.Rarity .. "]"
	title.Font = Enum.Font.GothamBold
	title.TextScaled = true
	title.TextColor3 = aura.Color
	title.TextStrokeTransparency = 0.1
	title.Parent = auraBillboard

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		local anim = Instance.new("Animation")
		anim.AnimationId = aura.AnimationId
		local track = humanoid:LoadAnimation(anim)
		track:Play()
		if aura.Rarity == "Legendary" or aura.Rarity == "Mythic" or aura.Rarity == "Celestial" then
			track:AdjustSpeed(0.9)
			track:AdjustWeight(1)
		end
	end

	local folder = Instance.new("Folder")
	folder.Name = "AuraEffectContainer"
	attachment.Parent = folder
	auraBillboard.Parent = folder
	folder.Parent = hrp
	currentAuraEffect = folder
end

local ui = {}

local function createGui()
	if playerGui:FindFirstChild("RNG_UI") then
		playerGui.RNG_UI:Destroy()
	end
	local gui = Instance.new("ScreenGui")
	gui.Name = "RNG_UI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = playerGui

	-- Loading Screen
	local loadingFrame = Instance.new("Frame")
	loadingFrame.Name = "LoadingFrame"
	loadingFrame.Size = UDim2.new(1, 0, 1, 0)
	loadingFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
	loadingFrame.Parent = gui

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(48, 79, 254)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 232, 255)),
	}
	gradient.Rotation = 0
	gradient.Parent = loadingFrame
	applyGradient(gradient)

	local center = Instance.new("Frame")
	center.Name = "Center"
	center.AnchorPoint = Vector2.new(0.5, 0.5)
	center.Position = UDim2.new(0.5, 0, 0.5, 0)
	center.Size = UDim2.new(0.6, 0, 0.3, 0)
	center.BackgroundTransparency = 1
	center.Parent = loadingFrame

	local loadingText = Instance.new("TextLabel")
	loadingText.Name = "LoadingText"
	loadingText.BackgroundTransparency = 1
	loadingText.Size = UDim2.new(1, 0, 0.35, 0)
	loadingText.Font = Enum.Font.GothamBold
	loadingText.TextScaled = true
	loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
	loadingText.Text = "Cargando sistema RNG..."
	loadingText.Parent = center

	local progressBack = Instance.new("Frame")
	progressBack.Name = "ProgressBack"
	progressBack.AnchorPoint = Vector2.new(0.5, 0.5)
	progressBack.Position = UDim2.new(0.5, 0, 0.75, 0)
	progressBack.Size = UDim2.new(1, 0, 0.18, 0)
	progressBack.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	progressBack.BorderSizePixel = 0
	progressBack.Parent = center

	local progressFill = Instance.new("Frame")
	progressFill.Name = "ProgressFill"
	progressFill.Size = UDim2.new(0, 0, 1, 0)
	progressFill.BackgroundColor3 = Color3.fromRGB(0, 232, 255)
	progressFill.BorderSizePixel = 0
	progressFill.Parent = progressBack

	local progressCorner = Instance.new("UICorner")
	progressCorner.CornerRadius = UDim.new(0, 10)
	progressCorner.Parent = progressBack
	local progressCorner2 = Instance.new("UICorner")
	progressCorner2.CornerRadius = UDim.new(0, 10)
	progressCorner2.Parent = progressFill

	-- Main menu
	local menuFrame = Instance.new("Frame")
	menuFrame.Name = "MenuFrame"
	menuFrame.Visible = false
	menuFrame.Size = UDim2.new(1, 0, 1, 0)
	menuFrame.BackgroundTransparency = 1
	menuFrame.Parent = gui

	local menuContainer = Instance.new("Frame")
	menuContainer.Name = "MenuContainer"
	menuContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	menuContainer.Position = UDim2.new(0.5, 0, 0.55, 0)
	menuContainer.Size = UDim2.new(0.34, 0, 0.5, 0)
	menuContainer.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
	menuContainer.BackgroundTransparency = 0.05
	menuContainer.BorderSizePixel = 0
	menuContainer.Visible = false
	menuContainer.Parent = menuFrame
	local menuCorner = Instance.new("UICorner")
	menuCorner.CornerRadius = UDim.new(0, 12)
	menuCorner.Parent = menuContainer

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 0, 0, 0)
	title.Size = UDim2.new(1, 0, 0.2, 0)
	title.Text = "Auras RNG"
	title.Font = Enum.Font.GothamBlack
	title.TextScaled = true
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Parent = menuContainer

	local function createButton(name: string, text: string, order: number)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.AnchorPoint = Vector2.new(0.5, 0)
		btn.Position = UDim2.new(0.5, 0, 0.2 + (order * 0.22), 0)
		btn.Size = UDim2.new(0.8, 0, 0.18, 0)
		btn.Text = text
		btn.Font = Enum.Font.GothamSemibold
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.TextScaled = true
		btn.BackgroundColor3 = Color3.fromRGB(35, 37, 55)
		btn.BorderSizePixel = 0
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 10)
		corner.Parent = btn

		local function onHover(hovering: boolean)
			if hovering then
				tween(btn, {BackgroundColor3 = Color3.fromRGB(70, 120, 255), Size = UDim2.new(0.83, 0, 0.19, 0)}, 0.15)
			else
				tween(btn, {BackgroundColor3 = Color3.fromRGB(35, 37, 55), Size = UDim2.new(0.8, 0, 0.18, 0)}, 0.15)
			end
		end
		btn.MouseEnter:Connect(function()
			onHover(true)
		end)
		btn.MouseLeave:Connect(function()
			onHover(false)
		end)
		btn.Parent = menuContainer
		return btn
	end

	local rollButton = createButton("RollButton", "Roll Aura", 0)
	local invButton = createButton("InventoryButton", "Inventario", 1)
	local settingsButton = createButton("SettingsButton", "Ajustes", 2)

	-- Result Overlay
	local resultFrame = Instance.new("Frame")
	resultFrame.Name = "ResultFrame"
	resultFrame.Visible = false
	resultFrame.BackgroundTransparency = 1
	resultFrame.Size = UDim2.new(1, 0, 1, 0)
	resultFrame.Parent = gui

	local resultCard = Instance.new("Frame")
	resultCard.Name = "ResultCard"
	resultCard.AnchorPoint = Vector2.new(0.5, 0.5)
	resultCard.Position = UDim2.new(0.5, 0, 0.5, 0)
	resultCard.Size = UDim2.new(0.4, 0, 0.32, 0)
	resultCard.BackgroundColor3 = Color3.fromRGB(14, 17, 27)
	resultCard.BackgroundTransparency = 0.05
	resultCard.Visible = false
	resultCard.Parent = resultFrame
	local resultCorner = Instance.new("UICorner")
	resultCorner.CornerRadius = UDim.new(0, 12)
	resultCorner.Parent = resultCard

	local resultTitle = Instance.new("TextLabel")
	resultTitle.Name = "ResultTitle"
	resultTitle.BackgroundTransparency = 1
	resultTitle.Position = UDim2.new(0, 0, 0.1, 0)
	resultTitle.Size = UDim2.new(1, 0, 0.25, 0)
	resultTitle.Text = "¡Aura Obtenida!"
	resultTitle.Font = Enum.Font.GothamBlack
	resultTitle.TextScaled = true
	resultTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	resultTitle.Parent = resultCard

	local resultName = Instance.new("TextLabel")
	resultName.Name = "ResultName"
	resultName.BackgroundTransparency = 1
	resultName.Position = UDim2.new(0, 0, 0.38, 0)
	resultName.Size = UDim2.new(1, 0, 0.2, 0)
	resultName.Font = Enum.Font.GothamBold
	resultName.TextScaled = true
	resultName.Text = ""
	resultName.TextColor3 = Color3.fromRGB(255, 255, 255)
	resultName.Parent = resultCard

	local resultRarity = Instance.new("TextLabel")
	resultRarity.Name = "ResultRarity"
	resultRarity.BackgroundTransparency = 1
	resultRarity.Position = UDim2.new(0, 0, 0.55, 0)
	resultRarity.Size = UDim2.new(1, 0, 0.15, 0)
	resultRarity.Font = Enum.Font.GothamSemibold
	resultRarity.TextScaled = true
	resultRarity.Text = ""
	resultRarity.TextColor3 = Color3.fromRGB(255, 255, 255)
	resultRarity.Parent = resultCard

	local resultButton = Instance.new("TextButton")
	resultButton.Name = "ResultButton"
	resultButton.AnchorPoint = Vector2.new(0.5, 0)
	resultButton.Position = UDim2.new(0.5, 0, 0.75, 0)
	resultButton.Size = UDim2.new(0.6, 0, 0.18, 0)
	resultButton.Text = "Continuar"
	resultButton.Font = Enum.Font.GothamSemibold
	resultButton.TextScaled = true
	resultButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	resultButton.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
	resultButton.BorderSizePixel = 0
	local resultBtnCorner = Instance.new("UICorner")
	resultBtnCorner.CornerRadius = UDim.new(0, 10)
	resultBtnCorner.Parent = resultButton
	resultButton.Parent = resultCard

	-- Inventory panel
	local invFrame = Instance.new("Frame")
	invFrame.Name = "InventoryFrame"
	invFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	invFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	invFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
	invFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
	invFrame.Visible = false
	invFrame.Parent = gui
	local invCorner = Instance.new("UICorner")
	invCorner.CornerRadius = UDim.new(0, 12)
	invCorner.Parent = invFrame

	local invTitle = Instance.new("TextLabel")
	invTitle.BackgroundTransparency = 1
	invTitle.Size = UDim2.new(1, 0, 0.12, 0)
	invTitle.Text = "Inventario de Auras"
	invTitle.Font = Enum.Font.GothamBlack
	invTitle.TextScaled = true
	invTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	invTitle.Parent = invFrame

	local invScrolling = Instance.new("ScrollingFrame")
	invScrolling.Name = "List"
	invScrolling.Position = UDim2.new(0.05, 0, 0.14, 0)
	invScrolling.Size = UDim2.new(0.9, 0, 0.76, 0)
	invScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
	invScrolling.ScrollBarThickness = 6
	invScrolling.BackgroundColor3 = Color3.fromRGB(12, 13, 18)
	invScrolling.BorderSizePixel = 0
	local invListCorner = Instance.new("UICorner")
	invListCorner.CornerRadius = UDim.new(0, 8)
	invListCorner.Parent = invScrolling
	invScrolling.Parent = invFrame

	local uiList = Instance.new("UIListLayout")
	uiList.Padding = UDim.new(0, 6)
	uiList.SortOrder = Enum.SortOrder.LayoutOrder
	uiList.Parent = invScrolling

	local closeInv = Instance.new("TextButton")
	closeInv.Name = "Close"
	closeInv.AnchorPoint = Vector2.new(0.5, 1)
	closeInv.Position = UDim2.new(0.5, 0, 1, -10)
	closeInv.Size = UDim2.new(0.3, 0, 0.1, 0)
	closeInv.Text = "Cerrar"
	closeInv.Font = Enum.Font.GothamSemibold
	closeInv.TextScaled = true
	closeInv.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeInv.BackgroundColor3 = Color3.fromRGB(50, 120, 255)
	closeInv.BorderSizePixel = 0
	local closeInvCorner = Instance.new("UICorner")
	closeInvCorner.CornerRadius = UDim.new(0, 8)
	closeInvCorner.Parent = closeInv
	closeInv.Parent = invFrame

	-- Settings panel (simple toggles)
	local settingsFrame = Instance.new("Frame")
	settingsFrame.Name = "SettingsFrame"
	settingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	settingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	settingsFrame.Size = UDim2.new(0.38, 0, 0.42, 0)
	settingsFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
	settingsFrame.Visible = false
	settingsFrame.Parent = gui
	local settingsCorner = Instance.new("UICorner")
	settingsCorner.CornerRadius = UDim.new(0, 12)
	settingsCorner.Parent = settingsFrame

	local settingsTitle = Instance.new("TextLabel")
	settingsTitle.BackgroundTransparency = 1
	settingsTitle.Size = UDim2.new(1, 0, 0.18, 0)
	settingsTitle.Text = "Ajustes"
	settingsTitle.Font = Enum.Font.GothamBlack
	settingsTitle.TextScaled = true
	settingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	settingsTitle.Parent = settingsFrame

	local blurToggle = Instance.new("TextButton")
	blurToggle.Name = "BlurToggle"
	blurToggle.AnchorPoint = Vector2.new(0.5, 0)
	blurToggle.Position = UDim2.new(0.5, 0, 0.25, 0)
	blurToggle.Size = UDim2.new(0.7, 0, 0.18, 0)
	blurToggle.Text = "Blur: Activado"
	blurToggle.Font = Enum.Font.GothamSemibold
	blurToggle.TextScaled = true
	blurToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	blurToggle.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
	blurToggle.BorderSizePixel = 0
	local blurToggleCorner = Instance.new("UICorner")
	blurToggleCorner.CornerRadius = UDim.new(0, 10)
	blurToggleCorner.Parent = blurToggle
	blurToggle.Parent = settingsFrame

	local musicToggle = Instance.new("TextButton")
	musicToggle.Name = "MusicToggle"
	musicToggle.AnchorPoint = Vector2.new(0.5, 0)
	musicToggle.Position = UDim2.new(0.5, 0, 0.47, 0)
	musicToggle.Size = UDim2.new(0.7, 0, 0.18, 0)
	musicToggle.Text = "Música: Placeholder"
	musicToggle.Font = Enum.Font.GothamSemibold
	musicToggle.TextScaled = true
	musicToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	musicToggle.BackgroundColor3 = Color3.fromRGB(35, 37, 55)
	musicToggle.BorderSizePixel = 0
	local musicToggleCorner = Instance.new("UICorner")
	musicToggleCorner.CornerRadius = UDim.new(0, 10)
	musicToggleCorner.Parent = musicToggle
	musicToggle.Parent = settingsFrame

	local closeSettings = Instance.new("TextButton")
	closeSettings.Name = "CloseSettings"
	closeSettings.AnchorPoint = Vector2.new(0.5, 1)
	closeSettings.Position = UDim2.new(0.5, 0, 0.95, 0)
	closeSettings.Size = UDim2.new(0.4, 0, 0.15, 0)
	closeSettings.Text = "Cerrar"
	closeSettings.Font = Enum.Font.GothamSemibold
	closeSettings.TextScaled = true
	closeSettings.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeSettings.BackgroundColor3 = Color3.fromRGB(50, 120, 255)
	closeSettings.BorderSizePixel = 0
	local closeSettingsCorner = Instance.new("UICorner")
	closeSettingsCorner.CornerRadius = UDim.new(0, 10)
	closeSettingsCorner.Parent = closeSettings
	closeSettings.Parent = settingsFrame

	-- Rolling overlay
	local rollingFrame = Instance.new("Frame")
	rollingFrame.Name = "RollingFrame"
	rollingFrame.Visible = false
	rollingFrame.Size = UDim2.new(1, 0, 1, 0)
	rollingFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
	rollingFrame.BackgroundTransparency = 0.2
	rollingFrame.Parent = gui

	local spinner = Instance.new("Frame")
	spinner.Name = "Spinner"
	spinner.AnchorPoint = Vector2.new(0.5, 0.5)
	spinner.Position = UDim2.new(0.5, 0, 0.5, 0)
	spinner.Size = UDim2.new(0.16, 0, 0.16, 0)
	spinner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	spinner.BackgroundTransparency = 1
	spinner.Parent = rollingFrame

	local spinnerCorner = Instance.new("UICorner")
	spinnerCorner.CornerRadius = UDim.new(1, 0)
	spinnerCorner.Parent = spinner

	local spinnerUIStroke = Instance.new("UIStroke")
	spinnerUIStroke.Color = Color3.fromRGB(0, 232, 255)
	spinnerUIStroke.Thickness = 6
	spinnerUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	spinnerUIStroke.Parent = spinner

	local spinnerInner = Instance.new("Frame")
	spinnerInner.AnchorPoint = Vector2.new(0.5, 0.5)
	spinnerInner.Position = UDim2.new(0.5, 0, 0.5, 0)
	spinnerInner.Size = UDim2.new(0.7, 0, 0.7, 0)
	spinnerInner.BackgroundTransparency = 1
	spinnerInner.Parent = spinner

	local spinnerStroke = Instance.new("UIStroke")
	spinnerStroke.Thickness = 4
	spinnerStroke.Color = Color3.fromRGB(255, 255, 255)
	spinnerStroke.Parent = spinnerInner

	ui.LoadingFrame = loadingFrame
	ui.LoadingText = loadingText
	ui.ProgressFill = progressFill
	ui.MenuFrame = menuFrame
	ui.MenuContainer = menuContainer
	ui.RollButton = rollButton
	ui.InvButton = invButton
	ui.SettingsButton = settingsButton
	ui.ResultFrame = resultFrame
	ui.ResultCard = resultCard
	ui.ResultName = resultName
	ui.ResultRarity = resultRarity
	ui.ResultButton = resultButton
	ui.InventoryFrame = invFrame
	ui.InventoryList = invScrolling
	ui.CloseInventory = closeInv
	ui.SettingsFrame = settingsFrame
	ui.BlurToggle = blurToggle
	ui.MusicToggle = musicToggle
	ui.CloseSettings = closeSettings
	ui.RollingFrame = rollingFrame
	ui.Spinner = spinner
	return gui
end

local gui = createGui()

local function updateInventoryUI()
	local list = ui.InventoryList
	list:ClearAllChildren()
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = list
	for index, aura in ipairs(auraInventory) do
		local item = Instance.new("TextLabel")
		item.Name = "Aura_" .. index
		item.Size = UDim2.new(1, 0, 0, 38)
		item.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
		item.Text = aura.Name .. " - " .. aura.Rarity
		item.TextScaled = true
		item.Font = Enum.Font.GothamSemibold
		item.TextColor3 = aura.Color
		item.BorderSizePixel = 0
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = item
		item.Parent = list
	end
	list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

local function fadeLoadingOut()
	state = "Menu"
	tween(ui.LoadingFrame, {BackgroundTransparency = 1}, 0.8)
	tween(ui.LoadingText, {TextTransparency = 1}, 0.6)
	tween(ui.ProgressFill, {BackgroundTransparency = 1}, 0.6)
	task.wait(0.8)
	ui.LoadingFrame.Visible = false
	ui.MenuFrame.Visible = true
	ui.MenuContainer.Visible = true
	ui.MenuContainer.BackgroundTransparency = 1
	ui.MenuContainer.Position = UDim2.new(0.5, 0, 0.6, 0)
	tween(ui.MenuContainer, {BackgroundTransparency = 0.05, Position = UDim2.new(0.5, 0, 0.55, 0)}, 0.6)
	setMenuCamera()
	enableInput()
end

local function playLoading()
	state = "Loading"
	disableInput()
	setMenuCamera()
	local steps = {
		{msg = "Cargando sistema RNG…", progress = 0.25},
		{msg = "Inicializando auras…", progress = 0.55},
		{msg = "Preparando animaciones…", progress = 0.8},
		{msg = "Todo listo. ¡Disfruta!", progress = 1}
	}
	for _, step in ipairs(steps) do
		ui.LoadingText.Text = step.msg
		tween(ui.ProgressFill, {Size = UDim2.new(step.progress, 0, 1, 0)}, 0.5)
		tween(blur, {Size = step.progress * 18}, 0.5)
		task.wait(0.6)
	end
	task.wait(0.4)
	fadeLoadingOut()
end

local spinnerConnection: RBXScriptConnection?
local function startSpinner()
	if spinnerConnection then
		spinnerConnection:Disconnect()
	end
	local angle = 0
	spinnerConnection = RunService.RenderStepped:Connect(function(dt)
		angle += dt * 180
		ui.Spinner.Rotation = angle % 360
	end)
end

local function stopSpinner()
	if spinnerConnection then
		spinnerConnection:Disconnect()
		spinnerConnection = nil
	end
end

local function cinematicEffects(aura: Aura, revealTime: number)
	if not blurEnabled then
		blur.Size = 0
	else
		local targetBlur = 10
		if aura.Rarity == "Legendary" then
			targetBlur = 14
		elseif aura.Rarity == "Mythic" or aura.Rarity == "Celestial" then
			targetBlur = 18
		end
		tween(blur, {Size = targetBlur}, 0.4)
	end
	if aura.Rarity == "Epic" or aura.Rarity == "Legendary" or aura.Rarity == "Mythic" or aura.Rarity == "Celestial" then
		camera.CameraType = Enum.CameraType.Scriptable
		local character = player.Character or player.CharacterAdded:Wait()
		local hrp = character:WaitForChild("HumanoidRootPart")
		local startCFrame = hrp.CFrame * CFrame.new(0, 3, 14)
		local endCFrame = hrp.CFrame * CFrame.new(0, 2, 6) * CFrame.Angles(0, math.rad(180), 0)
		camera.CFrame = startCFrame
		tween(camera, {CFrame = endCFrame}, revealTime)
	end
end

local function showResult(aura: Aura)
	state = "Result"
	ui.ResultFrame.Visible = true
	ui.ResultCard.Visible = true
	ui.ResultCard.BackgroundTransparency = 1
	ui.ResultCard.Size = UDim2.new(0.25, 0, 0.2, 0)
	ui.ResultName.Text = aura.Name
	ui.ResultRarity.Text = aura.Rarity
	ui.ResultName.TextColor3 = aura.Color
	ui.ResultRarity.TextColor3 = aura.Color
	tween(ui.ResultCard, {BackgroundTransparency = 0.05, Size = UDim2.new(0.4, 0, 0.32, 0)}, 0.4)
	tween(blur, {Size = 0}, 0.6)
end

local function rollAuraFlow()
	if state ~= "Menu" then
		return
	end
	state = "Rolling"
	disableInput()
	ui.MenuContainer.Visible = false
	ui.RollingFrame.Visible = true
	startSpinner()
	tween(ui.RollingFrame, {BackgroundTransparency = 0}, 0.3)

	local suspense = 2.4
	local aura = pickAura()
	cinematicEffects(aura, suspense)
	task.wait(suspense)
	stopSpinner()
	ui.RollingFrame.Visible = false

	table.insert(auraInventory, aura)
	updateInventoryUI()
	applyAuraEffect(aura)
	showResult(aura)
end

local blurEnabled = true
ui.BlurToggle.MouseButton1Click:Connect(function()
	blurEnabled = not blurEnabled
	if blurEnabled then
		ui.BlurToggle.Text = "Blur: Activado"
		ui.BlurToggle.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
		blur.Size = 0
	else
		ui.BlurToggle.Text = "Blur: Desactivado"
		ui.BlurToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		blur.Size = 0
	end
end)

ui.MusicToggle.MouseButton1Click:Connect(function()
	ui.MusicToggle.Text = "Música: Próximamente"
end)

ui.CloseSettings.MouseButton1Click:Connect(function()
	ui.SettingsFrame.Visible = false
	ui.MenuContainer.Visible = true
end)

ui.RollButton.MouseButton1Click:Connect(function()
	if state == "Menu" then
		rollAuraFlow()
	end
end)

ui.InvButton.MouseButton1Click:Connect(function()
	if state ~= "Menu" then
		return
	end
	updateInventoryUI()
	ui.InventoryFrame.Visible = true
	ui.MenuContainer.Visible = false
end)

ui.SettingsButton.MouseButton1Click:Connect(function()
	if state ~= "Menu" then
		return
	end
	ui.SettingsFrame.Visible = true
	ui.MenuContainer.Visible = false
end)

ui.CloseInventory.MouseButton1Click:Connect(function()
	ui.InventoryFrame.Visible = false
	ui.MenuContainer.Visible = true
end)

ui.ResultButton.MouseButton1Click:Connect(function()
	if state ~= "Result" then
		return
	end
	ui.ResultFrame.Visible = false
	ui.ResultCard.Visible = false
	state = "Menu"
	ui.MenuContainer.Visible = true
	setMenuCamera()
	enableInput()
end)

player.CharacterAdded:Connect(function()
	if state == "Menu" or state == "Rolling" or state == "Loading" then
		setMenuCamera()
	end
end)

-- Fallback safety: restore controls if lost focus
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end
	if input.KeyCode == Enum.KeyCode.F5 then
		restoreCamera()
		enableInput()
	end
end)

playLoading()
