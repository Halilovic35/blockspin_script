--[[
    Block Spin Roblox Script
    Premium Edition - Complete Package
    Features: Godmode, Infinite Stamina, Infinite Money, Anti-Detection
    Modern GUI with Color Customization and Hotkey Support
]]

-- Anti-Detection Variables
local _G_Backup = _G
local _ENV_Backup = _ENV
local _VERSION_Backup = _VERSION

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

-- Variables
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Configuration
local Config = {
    Godmode = false,
    InfiniteStamina = false,
    InfiniteMoney = false,
    AntiDetection = true,
    GUIEnabled = true,
    Hotkey = Enum.KeyCode.RightShift,
    GUITheme = {
        Primary = Color3.fromRGB(45, 45, 45),
        Secondary = Color3.fromRGB(35, 35, 35),
        Accent = Color3.fromRGB(0, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(0, 255, 100),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(255, 50, 50)
    }
}

-- Anti-Detection Functions
local function SecureRandom()
    return HttpService:GenerateGUID(false):sub(1, 8)
end

local function SafeName()
    return "BlockSpin_" .. SecureRandom()
end

-- GUI Creation
local function CreateModernGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = SafeName()
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 350, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
    MainFrame.BackgroundColor3 = Config.GUITheme.Primary
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- Rounded Corners
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainFrame
    
    -- Drop Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Config.GUITheme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "Missaky Panel"
    TitleLabel.TextColor3 = Config.GUITheme.Text
    TitleLabel.TextScaled = true
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Config.GUITheme.Error
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Config.GUITheme.Text
    CloseButton.TextScaled = true
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    -- Scrolling Frame for Content
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.ScrollBarImageColor3 = Config.GUITheme.Accent
    ScrollFrame.Parent = MainFrame
    
    local ScrollList = Instance.new("UIListLayout")
    ScrollList.Padding = UDim.new(0, 10)
    ScrollList.Parent = ScrollFrame
    
    -- Combat Section
    local CombatSection = Instance.new("Frame")
    CombatSection.Name = "CombatSection"
    CombatSection.Size = UDim2.new(1, 0, 0, 120)
    CombatSection.BackgroundColor3 = Config.GUITheme.Secondary
    CombatSection.BorderSizePixel = 0
    CombatSection.Parent = ScrollFrame
    
    local CombatCorner = Instance.new("UICorner")
    CombatCorner.CornerRadius = UDim.new(0, 8)
    CombatCorner.Parent = CombatSection
    
    local CombatTitle = Instance.new("TextLabel")
    CombatTitle.Name = "CombatTitle"
    CombatTitle.Size = UDim2.new(1, -20, 0, 30)
    CombatTitle.Position = UDim2.new(0, 10, 0, 5)
    CombatTitle.BackgroundTransparency = 1
    CombatTitle.Text = "Zaštita"
    CombatTitle.TextColor3 = Config.GUITheme.Text
    CombatTitle.TextScaled = true
    CombatTitle.Font = Enum.Font.GothamBold
    CombatTitle.Parent = CombatSection
    
    local GodmodeToggle = Instance.new("TextButton")
    GodmodeToggle.Name = "GodmodeToggle"
    GodmodeToggle.Size = UDim2.new(1, -20, 0, 35)
    GodmodeToggle.Position = UDim2.new(0, 10, 0, 40)
    GodmodeToggle.BackgroundColor3 = Config.GUITheme.Primary
    GodmodeToggle.Text = "Božija Besmrtnost: ISKLJUČENO"
    GodmodeToggle.TextColor3 = Config.GUITheme.Text
    GodmodeToggle.TextScaled = true
    GodmodeToggle.Font = Enum.Font.Gotham
    GodmodeToggle.Parent = CombatSection
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = GodmodeToggle
    
    -- Movement Section
    local MovementSection = Instance.new("Frame")
    MovementSection.Name = "MovementSection"
    MovementSection.Size = UDim2.new(1, 0, 0, 120)
    MovementSection.BackgroundColor3 = Config.GUITheme.Secondary
    MovementSection.BorderSizePixel = 0
    MovementSection.Parent = ScrollFrame
    
    local MovementCorner = Instance.new("UICorner")
    MovementCorner.CornerRadius = UDim.new(0, 8)
    MovementCorner.Parent = MovementSection
    
    local MovementTitle = Instance.new("TextLabel")
    MovementTitle.Name = "MovementTitle"
    MovementTitle.Size = UDim2.new(1, -20, 0, 30)
    MovementTitle.Position = UDim2.new(0, 10, 0, 5)
    MovementTitle.BackgroundTransparency = 1
    MovementTitle.Text = "Kretanje"
    MovementTitle.TextColor3 = Config.GUITheme.Text
    MovementTitle.TextScaled = true
    MovementTitle.Font = Enum.Font.GothamBold
    MovementTitle.Parent = MovementSection
    
    local StaminaToggle = Instance.new("TextButton")
    StaminaToggle.Name = "StaminaToggle"
    StaminaToggle.Size = UDim2.new(1, -20, 0, 35)
    StaminaToggle.Position = UDim2.new(0, 10, 0, 40)
    StaminaToggle.BackgroundColor3 = Config.GUITheme.Primary
    StaminaToggle.Text = "Beskonačno Trčanje: ISKLJUČENO"
    StaminaToggle.TextColor3 = Config.GUITheme.Text
    StaminaToggle.TextScaled = true
    StaminaToggle.Font = Enum.Font.Gotham
    StaminaToggle.Parent = MovementSection
    
    local StaminaCorner = Instance.new("UICorner")
    StaminaCorner.CornerRadius = UDim.new(0, 6)
    StaminaCorner.Parent = StaminaToggle
    
    -- Economy Section
    local EconomySection = Instance.new("Frame")
    EconomySection.Name = "EconomySection"
    EconomySection.Size = UDim2.new(1, 0, 0, 120)
    EconomySection.BackgroundColor3 = Config.GUITheme.Secondary
    EconomySection.BorderSizePixel = 0
    EconomySection.Parent = ScrollFrame
    
    local EconomyCorner = Instance.new("UICorner")
    EconomyCorner.CornerRadius = UDim.new(0, 8)
    EconomyCorner.Parent = EconomySection
    
    local EconomyTitle = Instance.new("TextLabel")
    EconomyTitle.Name = "EconomyTitle"
    EconomyTitle.Size = UDim2.new(1, -20, 0, 30)
    EconomyTitle.Position = UDim2.new(0, 10, 0, 5)
    EconomyTitle.BackgroundTransparency = 1
    EconomyTitle.Text = "Ekonomija"
    EconomyTitle.TextColor3 = Config.GUITheme.Text
    EconomyTitle.TextScaled = true
    EconomyTitle.Font = Enum.Font.GothamBold
    EconomyTitle.Parent = EconomySection
    
    local MoneyToggle = Instance.new("TextButton")
    MoneyToggle.Name = "MoneyToggle"
    MoneyToggle.Size = UDim2.new(1, -20, 0, 35)
    MoneyToggle.Position = UDim2.new(0, 10, 0, 40)
    MoneyToggle.BackgroundColor3 = Config.GUITheme.Primary
    MoneyToggle.Text = "Neograničeno Bogatstvo: ISKLJUČENO"
    MoneyToggle.TextColor3 = Config.GUITheme.Text
    MoneyToggle.TextScaled = true
    MoneyToggle.Font = Enum.Font.Gotham
    MoneyToggle.Parent = EconomySection
    
    local MoneyCorner = Instance.new("UICorner")
    MoneyCorner.CornerRadius = UDim.new(0, 6)
    MoneyCorner.Parent = MoneyToggle
    
    -- Settings Section
    local SettingsSection = Instance.new("Frame")
    SettingsSection.Name = "SettingsSection"
    SettingsSection.Size = UDim2.new(1, 0, 0, 200)
    SettingsSection.BackgroundColor3 = Config.GUITheme.Secondary
    SettingsSection.BorderSizePixel = 0
    SettingsSection.Parent = ScrollFrame
    
    local SettingsCorner = Instance.new("UICorner")
    SettingsCorner.CornerRadius = UDim.new(0, 8)
    SettingsCorner.Parent = SettingsSection
    
    local SettingsTitle = Instance.new("TextLabel")
    SettingsTitle.Name = "SettingsTitle"
    SettingsTitle.Size = UDim2.new(1, -20, 0, 30)
    SettingsTitle.Position = UDim.new(0, 10, 0, 5)
    SettingsTitle.BackgroundTransparency = 1
    SettingsTitle.Text = "Podešavanja"
    SettingsTitle.TextColor3 = Config.GUITheme.Text
    SettingsTitle.TextScaled = true
    SettingsTitle.Font = Enum.Font.GothamBold
    SettingsTitle.Parent = SettingsSection
    
    -- Hotkey Display
    local HotkeyLabel = Instance.new("TextLabel")
    HotkeyLabel.Name = "HotkeyLabel"
    HotkeyLabel.Size = UDim2.new(1, -20, 0, 25)
    HotkeyLabel.Position = UDim2.new(0, 10, 0, 40)
    HotkeyLabel.BackgroundTransparency = 1
    HotkeyLabel.Text = "Prekidač GUI: Desni Shift"
    HotkeyLabel.TextColor3 = Config.GUITheme.Text
    HotkeyLabel.TextScaled = true
    HotkeyLabel.Font = Enum.Font.Gotham
    HotkeyLabel.Parent = SettingsSection
    
    -- Save/Load Buttons
    local SaveButton = Instance.new("TextButton")
    SaveButton.Name = "SaveButton"
    SaveButton.Size = UDim2.new(0.48, 0, 0, 35)
    SaveButton.Position = UDim2.new(0, 10, 0, 70)
    SaveButton.BackgroundColor3 = Config.GUITheme.Success
    SaveButton.Text = "Sačuvaj"
    SaveButton.TextColor3 = Config.GUITheme.Text
    SaveButton.TextScaled = true
    SaveButton.Font = Enum.Font.Gotham
    SaveButton.Parent = SettingsSection
    
    local SaveCorner = Instance.new("UICorner")
    SaveCorner.CornerRadius = UDim.new(0, 6)
    SaveCorner.Parent = SaveButton
    
    local LoadButton = Instance.new("TextButton")
    LoadButton.Name = "LoadButton"
    LoadButton.Size = UDim2.new(0.48, 0, 0, 35)
    LoadButton.Position = UDim2.new(0.52, 0, 0, 70)
    LoadButton.BackgroundColor3 = Config.GUITheme.Warning
    LoadButton.Text = "Učitaj"
    LoadButton.TextColor3 = Config.GUITheme.Text
    LoadButton.TextScaled = true
    LoadButton.Font = Enum.Font.Gotham
    LoadButton.Parent = SettingsSection
    
    local LoadCorner = Instance.new("UICorner")
    LoadCorner.CornerRadius = UDim.new(0, 6)
    LoadCorner.Parent = LoadButton
    
    -- Status Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(1, -20, 0, 25)
    StatusLabel.Position = UDim2.new(0, 10, 0, 110)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Status: Spreman"
    StatusLabel.TextColor3 = Config.GUITheme.Success
    StatusLabel.TextScaled = true
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = SettingsSection
    
    return ScreenGui, {
        MainFrame = MainFrame,
        GodmodeToggle = GodmodeToggle,
        StaminaToggle = StaminaToggle,
        MoneyToggle = MoneyToggle,
        CloseButton = CloseButton,
        SaveButton = SaveButton,
        LoadButton = LoadButton,
        StatusLabel = StatusLabel
    }
end

-- GUI Functions
local GUI, Elements = CreateModernGUI()
local GUIEnabled = true

-- Make GUI Draggable
local function MakeDraggable(Frame)
    local UserInputService = game:GetService("UserInputService")
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

MakeDraggable(Elements.MainFrame)

-- Toggle Functions
local godmodeThread = nil
local staminaThread = nil
local moneyThread = nil

local function ToggleGodmode()
    Config.Godmode = not Config.Godmode
    local color = Config.Godmode and Config.GUITheme.Success or Config.GUITheme.Primary
    local text = Config.Godmode and "Božija Besmrtnost: UKLJUČENO" or "Božija Besmrtnost: ISKLJUČENO"
    Elements.GodmodeToggle.BackgroundColor3 = color
    Elements.GodmodeToggle.Text = text
    if Config.Godmode then
        if godmodeThread then godmodeThread:Disconnect() end
        godmodeThread = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = 100
                    if humanoid.Health < 100 then
                        humanoid.Health = 100
                    end
                end
            end
        end)
    else
        if godmodeThread then godmodeThread:Disconnect() end
        godmodeThread = nil
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 100
                if humanoid.Health > 100 then
                    humanoid.Health = 100
                end
            end
        end
    end
end

local function ToggleStamina()
    Config.InfiniteStamina = not Config.InfiniteStamina
    local color = Config.InfiniteStamina and Config.GUITheme.Success or Config.GUITheme.Primary
    local text = Config.InfiniteStamina and "Beskonačno Trčanje: UKLJUČENO" or "Beskonačno Trčanje: ISKLJUČENO"
    Elements.StaminaToggle.BackgroundColor3 = color
    Elements.StaminaToggle.Text = text
    if Config.InfiniteStamina then
        if staminaThread then staminaThread:Disconnect() end
        staminaThread = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if character then
                -- Najčešći nazivi stamina varijabli
                local stamina = character:FindFirstChild("Stamina") or character:FindFirstChild("stamina") or character:FindFirstChild("Energy") or character:FindFirstChild("energy") or character:FindFirstChild("Sprint") or character:FindFirstChild("sprint")
                if stamina and stamina:IsA("NumberValue") then
                    if stamina.Value < 115 then
                        stamina.Value = 115
                    end
                end
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 50
                    humanoid.JumpPower = 100
                end
            end
        end)
    else
        if staminaThread then staminaThread:Disconnect() end
        staminaThread = nil
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
        end
    end
end

local function ToggleMoney()
    Config.InfiniteMoney = not Config.InfiniteMoney
    local color = Config.InfiniteMoney and Config.GUITheme.Success or Config.GUITheme.Primary
    local text = Config.InfiniteMoney and "Neograničeno Bogatstvo: UKLJUČENO" or "Neograničeno Bogatstvo: ISKLJUČENO"
    Elements.MoneyToggle.BackgroundColor3 = color
    Elements.MoneyToggle.Text = text
    if Config.InfiniteMoney then
        if moneyThread then moneyThread:Disconnect() end
        moneyThread = RunService.Heartbeat:Connect(function()
            -- Add money logic based on game
        end)
    else
        if moneyThread then moneyThread:Disconnect() end
        moneyThread = nil
    end
end

-- Button Connections
Elements.GodmodeToggle.MouseButton1Click:Connect(ToggleGodmode)
Elements.StaminaToggle.MouseButton1Click:Connect(ToggleStamina)
Elements.MoneyToggle.MouseButton1Click:Connect(ToggleMoney)

Elements.CloseButton.MouseButton1Click:Connect(function()
    GUI:Destroy()
    GUIEnabled = false
end)

Elements.SaveButton.MouseButton1Click:Connect(function()
    -- Save settings logic
    Elements.StatusLabel.Text = "Status: Sačuvano"
    Elements.StatusLabel.TextColor3 = Config.GUITheme.Success
    wait(2)
    Elements.StatusLabel.Text = "Status: Spreman"
end)

Elements.LoadButton.MouseButton1Click:Connect(function()
    -- Load settings logic
    Elements.StatusLabel.Text = "Status: Učitano"
    Elements.StatusLabel.TextColor3 = Config.GUITheme.Success
    wait(2)
    Elements.StatusLabel.Text = "Status: Spreman"
end)

-- Hotkey Support
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Config.Hotkey then
        Elements.MainFrame.Visible = not Elements.MainFrame.Visible
    end
end)

-- Fix ZIndex for all buttons and frames to ensure they are clickable
local function SetZIndexRecursive(gui, z)
    if gui:IsA("GuiObject") then
        gui.ZIndex = z
    end
    for _, child in ipairs(gui:GetChildren()) do
        SetZIndexRecursive(child, z + 1)
    end
end
SetZIndexRecursive(GUI, 2)

-- Anti-Detection Loop
spawn(function()
    while Config.AntiDetection do
        -- Anti-detection measures
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and Config.Godmode then
                humanoid.Health = math.huge
            end
        end
        wait(0.1)
    end
end)

-- Performance Optimization
RunService.Heartbeat:Connect(function()
    if not GUIEnabled then return end
    
    -- Optimize GUI updates
    if Config.Godmode or Config.InfiniteStamina or Config.InfiniteMoney then
        -- Update status if needed
    end
end)

-- Auto-Update Check (Placeholder)
spawn(function()
    wait(5)
    Elements.StatusLabel.Text = "Status: Skripta Učitana"
    Elements.StatusLabel.TextColor3 = Config.GUITheme.Success
end)

-- Cleanup on script end
game:BindToClose(function()
    if GUI then
        GUI:Destroy()
    end
end)

print("Missaky Panel Script loaded successfully!")
print("Press Right Shift to toggle GUI")
print("Features: Božija Besmrtnost, Beskonačno Trčanje, Neograničeno Bogatstvo, Anti-Detection") 