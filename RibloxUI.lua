--[[
    Riblox Professional UI Script
    A modern and professional GUI for Roblox
    Created with advanced features and smooth animations
]]--

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Settings
local Settings = {
    Speed = 16,
    JumpPower = 50,
    Flying = false,
    Noclip = false,
    ESP = false,
    FullBright = false,
    InfiniteJump = false,
    AutoFarm = false
}

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RibloxUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Check if running in Studio or game
if RunService:IsStudio() then
    ScreenGui.Parent = Player.PlayerGui
else
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if ScreenGui.Parent ~= CoreGui then
        ScreenGui.Parent = Player.PlayerGui
    end
end

-- Loading Screen
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.Position = UDim2.new(0, 0, 0, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = ScreenGui

-- Loading Title
local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Name = "Title"
LoadingTitle.Size = UDim2.new(0, 400, 0, 60)
LoadingTitle.Position = UDim2.new(0.5, -200, 0.4, -30)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "RIBLOX"
LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingTitle.TextSize = 48
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.Parent = LoadingFrame

-- Loading Bar Background
local LoadingBarBG = Instance.new("Frame")
LoadingBarBG.Name = "LoadingBarBG"
LoadingBarBG.Size = UDim2.new(0, 400, 0, 6)
LoadingBarBG.Position = UDim2.new(0.5, -200, 0.55, 0)
LoadingBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
LoadingBarBG.BorderSizePixel = 0
LoadingBarBG.Parent = LoadingFrame

local LoadingBarBGCorner = Instance.new("UICorner")
LoadingBarBGCorner.CornerRadius = UDim.new(0, 3)
LoadingBarBGCorner.Parent = LoadingBarBG

-- Loading Bar
local LoadingBar = Instance.new("Frame")
LoadingBar.Name = "LoadingBar"
LoadingBar.Size = UDim2.new(0, 0, 1, 0)
LoadingBar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
LoadingBar.BorderSizePixel = 0
LoadingBar.Parent = LoadingBarBG

local LoadingBarCorner = Instance.new("UICorner")
LoadingBarCorner.CornerRadius = UDim.new(0, 3)
LoadingBarCorner.Parent = LoadingBar

-- Loading Status
local LoadingStatus = Instance.new("TextLabel")
LoadingStatus.Name = "Status"
LoadingStatus.Size = UDim2.new(0, 400, 0, 30)
LoadingStatus.Position = UDim2.new(0.5, -200, 0.6, 0)
LoadingStatus.BackgroundTransparency = 1
LoadingStatus.Text = "Initializing..."
LoadingStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
LoadingStatus.TextSize = 16
LoadingStatus.Font = Enum.Font.Gotham
LoadingStatus.Parent = LoadingFrame

-- Loading Animation
local function AnimateLoading()
    local stages = {
        {text = "Initializing...", progress = 0.2},
        {text = "Loading UI Components...", progress = 0.4},
        {text = "Setting up Features...", progress = 0.6},
        {text = "Applying Configurations...", progress = 0.8},
        {text = "Finalizing...", progress = 1.0}
    }
    
    for _, stage in ipairs(stages) do
        LoadingStatus.Text = stage.text
        TweenService:Create(LoadingBar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(stage.progress, 0, 1, 0)
        }):Play()
        task.wait(0.6)
    end
    
    task.wait(0.3)
    TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play()
    
    for _, child in ipairs(LoadingFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            TweenService:Create(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1,
                BackgroundTransparency = 1
            }):Play()
        end
    end
    
    task.wait(0.5)
    LoadingFrame:Destroy()
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.CornerRadius = UDim.new(0, 12)
MainFrameCorner.Parent = MainFrame

-- Shadow effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://5554236805"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

local TitleBarBottom = Instance.new("Frame")
TitleBarBottom.Size = UDim2.new(1, 0, 0, 12)
TitleBarBottom.Position = UDim2.new(0, 0, 1, -12)
TitleBarBottom.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TitleBarBottom.BorderSizePixel = 0
TitleBarBottom.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "Title"
TitleText.Size = UDim2.new(0, 200, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "RIBLOX UI"
TitleText.TextColor3 = Color3.fromRGB(100, 200, 255)
TitleText.TextSize = 20
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 28
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
MinimizeButton.Position = UDim2.new(1, -80, 0, 0)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "─"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Tab System
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 150, 1, -40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabContainer

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.PaddingLeft = UDim.new(0, 10)
TabPadding.PaddingRight = UDim.new(0, 10)
TabPadding.Parent = TabContainer

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -150, 1, -40)
ContentFrame.Position = UDim2.new(0, 150, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Function to create tabs
local CurrentTab = nil

local function CreateTab(name, icon, order)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TabButton.BorderSizePixel = 0
    TabButton.Text = "  " .. icon .. "  " .. name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 16
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.LayoutOrder = order
    TabButton.Parent = TabContainer
    
    local TabButtonCorner = Instance.new("UICorner")
    TabButtonCorner.CornerRadius = UDim.new(0, 8)
    TabButtonCorner.Parent = TabButton
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 255)
    TabContent.Visible = false
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Parent = ContentFrame
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = TabContent
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 15)
    ContentPadding.PaddingLeft = UDim.new(0, 15)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.PaddingBottom = UDim.new(0, 15)
    ContentPadding.Parent = TabContent
    
    TabButton.MouseButton1Click:Connect(function()
        if CurrentTab then
            CurrentTab.Visible = false
            local currentButton = TabContainer:FindFirstChild(CurrentTab.Name:gsub("Content", "Tab"))
            if currentButton then
                currentButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                currentButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        
        TabContent.Visible = true
        CurrentTab = TabContent
        TabButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    return TabContent
end

-- Function to create buttons
local function CreateButton(parent, text, callback, order)
    local Button = Instance.new("TextButton")
    Button.Name = text .. "Button"
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16
    Button.Font = Enum.Font.Gotham
    Button.LayoutOrder = order or 0
    Button.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        }):Play()
    end)
    
    Button.MouseButton1Click:Connect(callback)
    
    return Button
end

-- Function to create toggle buttons
local function CreateToggle(parent, text, default, callback, order)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text .. "Toggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.LayoutOrder = order or 0
    ToggleFrame.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 16
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 45, 0, 25)
    ToggleButton.Position = UDim2.new(1, -55, 0.5, -12.5)
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(60, 60, 80)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
    ToggleButtonCorner.Parent = ToggleButton
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Size = UDim2.new(0, 21, 0, 21)
    ToggleIndicator.Position = default and UDim2.new(0, 22, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Parent = ToggleButton
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = ToggleIndicator
    
    local toggled = default
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = toggled and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(60, 60, 80)
        }):Play()
        
        TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {
            Position = toggled and UDim2.new(0, 22, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        }):Play()
        
        callback(toggled)
    end)
    
    return ToggleFrame
end

-- Function to create sliders
local function CreateSlider(parent, text, min, max, default, callback, order)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = text .. "Slider"
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.LayoutOrder = order or 0
    SliderFrame.Parent = parent
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -30, 0, 20)
    SliderLabel.Position = UDim2.new(0, 15, 0, 8)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = text
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 16
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderValue = Instance.new("TextLabel")
    SliderValue.Size = UDim2.new(0, 50, 0, 20)
    SliderValue.Position = UDim2.new(1, -65, 0, 8)
    SliderValue.BackgroundTransparency = 1
    SliderValue.Text = tostring(default)
    SliderValue.TextColor3 = Color3.fromRGB(100, 200, 255)
    SliderValue.TextSize = 16
    SliderValue.Font = Enum.Font.GothamBold
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    SliderValue.Parent = SliderFrame
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Size = UDim2.new(1, -30, 0, 6)
    SliderTrack.Position = UDim2.new(0, 15, 1, -18)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = SliderFrame
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = SliderTrack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Text = ""
    SliderButton.Parent = SliderTrack
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local relativePos = mousePos.X - SliderTrack.AbsolutePosition.X
            local percentage = math.clamp(relativePos / SliderTrack.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * percentage)
            
            SliderValue.Text = tostring(value)
            SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            callback(value)
        end
    end)
    
    return SliderFrame
end

-- Create Notification System
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "Notifications"
NotificationContainer.Size = UDim2.new(0, 300, 1, -10)
NotificationContainer.Position = UDim2.new(1, -310, 0, 10)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.Padding = UDim.new(0, 10)
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationLayout.Parent = NotificationContainer

local function SendNotification(title, message, duration)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(1, 0, 0, 80)
    Notification.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Notification.BorderSizePixel = 0
    Notification.Parent = NotificationContainer
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = Notification
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -20, 0, 25)
    NotifTitle.Position = UDim2.new(0, 10, 0, 8)
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Text = title
    NotifTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
    NotifTitle.TextSize = 16
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.Parent = Notification
    
    local NotifMessage = Instance.new("TextLabel")
    NotifMessage.Size = UDim2.new(1, -20, 0, 40)
    NotifMessage.Position = UDim2.new(0, 10, 0, 33)
    NotifMessage.BackgroundTransparency = 1
    NotifMessage.Text = message
    NotifMessage.TextColor3 = Color3.fromRGB(200, 200, 200)
    NotifMessage.TextSize = 14
    NotifMessage.Font = Enum.Font.Gotham
    NotifMessage.TextXAlignment = Enum.TextXAlignment.Left
    NotifMessage.TextYAlignment = Enum.TextYAlignment.Top
    NotifMessage.TextWrapped = true
    NotifMessage.Parent = Notification
    
    Notification.Position = UDim2.new(1, 50, 1, 0)
    TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 1, 0)
    }):Play()
    
    task.delay(duration or 3, function()
        TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 50, 1, 0)
        }):Play()
        task.wait(0.5)
        Notification:Destroy()
    end)
end

-- Create Tabs
local PlayerTab = CreateTab("Player", "👤", 1)
local GameTab = CreateTab("Game", "🎮", 2)
local VisualsTab = CreateTab("Visuals", "👁️", 3)
local SettingsTab = CreateTab("Settings", "⚙️", 4)

-- Player Tab Content
CreateSlider(PlayerTab, "Walk Speed", 16, 200, 16, function(value)
    Settings.Speed = value
    if Character and Humanoid then
        Humanoid.WalkSpeed = value
    end
end, 1)

CreateSlider(PlayerTab, "Jump Power", 50, 200, 50, function(value)
    Settings.JumpPower = value
    if Character and Humanoid then
        Humanoid.JumpPower = value
    end
end, 2)

CreateToggle(PlayerTab, "Infinite Jump", false, function(enabled)
    Settings.InfiniteJump = enabled
    SendNotification("Infinite Jump", enabled and "Enabled" or "Disabled", 2)
end, 3)

local FlyConnection = nil
local FlySpeed = 50

CreateToggle(PlayerTab, "Flight", false, function(enabled)
    Settings.Flying = enabled
    
    if enabled then
        SendNotification("Flight", "Enabled - Use Space/Shift to fly", 3)
        
        local BV = Instance.new("BodyVelocity")
        BV.MaxForce = Vector3.new(0, 0, 0)
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.Parent = HumanoidRootPart
        
        local BG = Instance.new("BodyGyro")
        BG.MaxTorque = Vector3.new(0, 0, 0)
        BG.Parent = HumanoidRootPart
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not Settings.Flying then return end
            
            local camera = workspace.CurrentCamera
            local direction = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            if direction.Magnitude > 0 then
                direction = direction.Unit
                BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                BV.Velocity = direction * FlySpeed
                BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                BG.CFrame = camera.CFrame
            else
                BV.MaxForce = Vector3.new(0, 0, 0)
                BG.MaxTorque = Vector3.new(0, 0, 0)
            end
        end)
    else
        SendNotification("Flight", "Disabled", 2)
        if FlyConnection then
            FlyConnection:Disconnect()
        end
        
        for _, v in pairs(HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end
    end
end, 4)

CreateSlider(PlayerTab, "Fly Speed", 10, 150, 50, function(value)
    FlySpeed = value
end, 5)

local NoclipConnection = nil

CreateToggle(PlayerTab, "Noclip", false, function(enabled)
    Settings.Noclip = enabled
    
    if enabled then
        SendNotification("Noclip", "Enabled", 2)
        NoclipConnection = RunService.Stepped:Connect(function()
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        SendNotification("Noclip", "Disabled", 2)
        if NoclipConnection then
            NoclipConnection:Disconnect()
        end
        
        if Character then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end, 6)

CreateButton(PlayerTab, "Reset Character", function()
    if Character and Humanoid then
        Humanoid.Health = 0
        SendNotification("Reset", "Character reset", 2)
    end
end, 7)

-- Game Tab Content
CreateButton(GameTab, "Teleport to Spawn", function()
    if Character and HumanoidRootPart then
        local spawnLocation = workspace:FindFirstChild("SpawnLocation")
        if spawnLocation then
            HumanoidRootPart.CFrame = spawnLocation.CFrame + Vector3.new(0, 5, 0)
            SendNotification("Teleport", "Teleported to spawn", 2)
        else
            SendNotification("Error", "Spawn location not found", 2)
        end
    end
end, 1)

CreateToggle(GameTab, "Auto Farm (Demo)", false, function(enabled)
    Settings.AutoFarm = enabled
    if enabled then
        SendNotification("Auto Farm", "Demo mode - Not implemented", 3)
    end
end, 2)

CreateButton(GameTab, "Collect All Nearby Items", function()
    local collected = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj:FindFirstChild("Touched") and (obj.Position - HumanoidRootPart.Position).Magnitude < 50 then
            collected = collected + 1
        end
    end
    SendNotification("Collect", "Attempted to collect " .. collected .. " items", 2)
end, 3)

CreateButton(GameTab, "Show Players List", function()
    local playerList = ""
    for _, player in pairs(Players:GetPlayers()) do
        playerList = playerList .. player.Name .. "\n"
    end
    SendNotification("Players", #Players:GetPlayers() .. " players online", 3)
end, 4)

-- Visuals Tab Content
CreateToggle(VisualsTab, "Full Bright", false, function(enabled)
    Settings.FullBright = enabled
    
    if enabled then
        SendNotification("Full Bright", "Enabled", 2)
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").FogEnd = 100000
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        SendNotification("Full Bright", "Disabled", 2)
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").ClockTime = 12
        game:GetService("Lighting").FogEnd = 100000
        game:GetService("Lighting").GlobalShadows = true
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    end
end, 1)

local ESPConnections = {}

CreateToggle(VisualsTab, "Player ESP", false, function(enabled)
    Settings.ESP = enabled
    
    if enabled then
        SendNotification("ESP", "Enabled", 2)
        
        local function addESP(player)
            if player == Player then return end
            
            local function createESP(character)
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP"
                highlight.FillColor = Color3.fromRGB(100, 200, 255)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = character
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "NameESP"
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.Parent = character:WaitForChild("Head")
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 1, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = player.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextSize = 16
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextStrokeTransparency = 0
                nameLabel.Parent = billboard
                
                local distanceLabel = Instance.new("TextLabel")
                distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
                distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
                distanceLabel.BackgroundTransparency = 1
                distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                distanceLabel.TextSize = 14
                distanceLabel.Font = Enum.Font.Gotham
                distanceLabel.TextStrokeTransparency = 0
                distanceLabel.Parent = billboard
                
                local conn = RunService.Heartbeat:Connect(function()
                    if character and character.Parent and HumanoidRootPart then
                        local distance = (character.PrimaryPart.Position - HumanoidRootPart.Position).Magnitude
                        distanceLabel.Text = math.floor(distance) .. " studs"
                    end
                end)
                
                table.insert(ESPConnections, conn)
            end
            
            if player.Character then
                createESP(player.Character)
            end
            
            player.CharacterAdded:Connect(function(character)
                if Settings.ESP then
                    createESP(character)
                end
            end)
        end
        
        for _, player in pairs(Players:GetPlayers()) do
            addESP(player)
        end
        
        local conn = Players.PlayerAdded:Connect(function(player)
            if Settings.ESP then
                addESP(player)
            end
        end)
        table.insert(ESPConnections, conn)
    else
        SendNotification("ESP", "Disabled", 2)
        
        for _, conn in pairs(ESPConnections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        ESPConnections = {}
        
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local esp = player.Character:FindFirstChild("ESP")
                if esp then esp:Destroy() end
                local nameESP = player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("NameESP")
                if nameESP then nameESP:Destroy() end
            end
        end
    end
end, 2)

CreateToggle(VisualsTab, "Show FPS Counter", false, function(enabled)
    local FPSCounter = ScreenGui:FindFirstChild("FPSCounter")
    
    if enabled then
        if not FPSCounter then
            FPSCounter = Instance.new("TextLabel")
            FPSCounter.Name = "FPSCounter"
            FPSCounter.Size = UDim2.new(0, 100, 0, 30)
            FPSCounter.Position = UDim2.new(0, 10, 0, 10)
            FPSCounter.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            FPSCounter.BorderSizePixel = 0
            FPSCounter.TextColor3 = Color3.fromRGB(100, 200, 255)
            FPSCounter.TextSize = 18
            FPSCounter.Font = Enum.Font.GothamBold
            FPSCounter.Parent = ScreenGui
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = FPSCounter
            
            local lastTime = tick()
            local fps = 60
            
            RunService.RenderStepped:Connect(function()
                if FPSCounter and FPSCounter.Parent then
                    local currentTime = tick()
                    local delta = currentTime - lastTime
                    lastTime = currentTime
                    
                    fps = math.floor(1 / delta)
                    FPSCounter.Text = "FPS: " .. fps
                end
            end)
        end
        SendNotification("FPS Counter", "Enabled", 2)
    else
        if FPSCounter then
            FPSCounter:Destroy()
        end
        SendNotification("FPS Counter", "Disabled", 2)
    end
end, 3)

-- Settings Tab Content
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 100)
InfoLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
InfoLabel.BorderSizePixel = 0
InfoLabel.Text = "RIBLOX UI v1.0\n\nCreated for Roblox\nModern & Professional Interface"
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.TextSize = 16
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextWrapped = true
InfoLabel.LayoutOrder = 1
InfoLabel.Parent = SettingsTab

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 8)
InfoCorner.Parent = InfoLabel

CreateButton(SettingsTab, "Rejoin Server", function()
    SendNotification("Rejoin", "Rejoining server...", 2)
    task.wait(1)
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
end, 2)

CreateButton(SettingsTab, "Server Hop", function()
    SendNotification("Server Hop", "Finding new server...", 2)
    task.wait(1)
    game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
end, 3)

CreateButton(SettingsTab, "Copy Game ID", function()
    setclipboard(tostring(game.PlaceId))
    SendNotification("Copied", "Game ID copied to clipboard", 2)
end, 4)

CreateButton(SettingsTab, "Destroy GUI", function()
    SendNotification("Goodbye", "Destroying GUI...", 2)
    task.wait(1)
    ScreenGui:Destroy()
end, 5)

-- Toggle GUI with key
local function ToggleGUI()
    MainFrame.Visible = not MainFrame.Visible
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        ToggleGUI()
    end
end)

-- Infinite Jump Implementation
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump and Character and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Character Update
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Reapply settings
    if Settings.Speed ~= 16 then
        Humanoid.WalkSpeed = Settings.Speed
    end
    if Settings.JumpPower ~= 50 then
        Humanoid.JumpPower = Settings.JumpPower
    end
end)

-- Open Button (floating)
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 60, 0, 60)
OpenButton.Position = UDim2.new(0, 10, 0.5, -30)
OpenButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
OpenButton.BorderSizePixel = 0
OpenButton.Text = "R"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 32
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenButtonCorner = Instance.new("UICorner")
OpenButtonCorner.CornerRadius = UDim.new(1, 0)
OpenButtonCorner.Parent = OpenButton

OpenButton.MouseButton1Click:Connect(function()
    ToggleGUI()
end)

-- Make title bar draggable
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Initialize
task.spawn(function()
    AnimateLoading()
    
    task.wait(0.5)
    MainFrame.Visible = true
    OpenButton.Visible = true
    
    -- Select first tab by default
    if TabContainer:GetChildren()[2] then
        TabContainer:GetChildren()[2]:Activate()
    end
    
    SendNotification("Welcome!", "Press Right Shift to toggle UI", 4)
end)

-- Anti-AFK
task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

print("Riblox UI loaded successfully!")
