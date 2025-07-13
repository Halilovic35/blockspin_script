-- Missaky Panel (advanced version, fallback logic for all variable names)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- BOJE
local theme = {
    bg = Color3.fromRGB(30,30,30),
    panel = Color3.fromRGB(40,40,40),
    tab = Color3.fromRGB(50,50,50),
    accent = Color3.fromRGB(255, 0, 128), -- roze
    text = Color3.fromRGB(255,255,255),
    inactive = Color3.fromRGB(80,80,80)
}

-- Fallback lists
local staminaNames = {"Stamina", "stamina", "Endurance", "endurance", "Energy", "energy", "Sprint", "sprint"}
local healthNames = {"Humanoid", "Health", "health", "HP", "hp", "Life", "life"}
local moneyNames = {"Money", "money", "Cash", "cash", "Coins", "coins", "Bucks", "bucks", "Gold", "gold"}

local function getStaminaVar(char)
    for _,name in ipairs(staminaNames) do
        local v = char:FindFirstChild(name)
        if v and v:IsA("NumberValue") then
            return v
        end
    end
    return nil
end

local function getHealthVar(char)
    -- Prefer Humanoid.Health, fallback to other NumberValues
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then return hum end
    for _,name in ipairs(healthNames) do
        local v = char:FindFirstChild(name)
        if v and v:IsA("NumberValue") then
            return v
        end
    end
    return nil
end

local function getMoneyVar()
    -- Try leaderstats, Player, Character
    local plr = LocalPlayer
    if plr:FindFirstChild("leaderstats") then
        for _,name in ipairs(moneyNames) do
            local v = plr.leaderstats:FindFirstChild(name)
            if v and v:IsA("NumberValue") then return v end
        end
    end
    for _,name in ipairs(moneyNames) do
        local v = plr:FindFirstChild(name)
        if v and v:IsA("NumberValue") then return v end
    end
    if plr.Character then
        for _,name in ipairs(moneyNames) do
            local v = plr.Character:FindFirstChild(name)
            if v and v:IsA("NumberValue") then return v end
        end
    end
    return nil
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MissakyPanel"
gui.Parent = game:GetService("CoreGui")
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 480, 0, 400)
main.Position = UDim2.new(0.5, -240, 0.5, -200)
main.BackgroundColor3 = theme.bg
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,36)
title.BackgroundTransparency = 1
title.Text = "Missaky Panel"
title.TextColor3 = theme.text
title.Font = Enum.Font.GothamBold
title.TextSize = 24

-- Tabovi
local tabs = {"Combat", "ESP", "Utility"}
local tabFrames, tabButtons = {}, {}
local selectedTab = 1

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0, 140, 0, 32)
    btn.Position = UDim2.new(0, 10 + (i-1)*150, 0, 40)
    btn.BackgroundColor3 = (i==1) and theme.accent or theme.tab
    btn.TextColor3 = theme.text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Text = name
    btn.AutoButtonColor = false
    tabButtons[i] = btn

    local frame = Instance.new("Frame", main)
    frame.Size = UDim2.new(1, -20, 1, -110)
    frame.Position = UDim2.new(0, 10, 0, 80)
    frame.BackgroundTransparency = 1
    frame.Visible = (i==1)
    tabFrames[i] = frame

    btn.MouseButton1Click:Connect(function()
        for j=1,#tabs do
            tabFrames[j].Visible = (i==j)
            tabButtons[j].BackgroundColor3 = (i==j) and theme.accent or theme.tab
        end
        selectedTab = i
    end)
end

-- COMBAT TAB
local combat = tabFrames[1]
local y = 0
local function nextY() y = y + 40; return y-40 end

local hitboxToggle = Instance.new("TextButton", combat)
hitboxToggle.Size = UDim2.new(0, 200, 0, 32)
hitboxToggle.Position = UDim2.new(0, 0, 0, nextY())
hitboxToggle.BackgroundColor3 = theme.inactive
hitboxToggle.Text = "Hitbox [OFF]"
hitboxToggle.TextColor3 = theme.text
hitboxToggle.Font = Enum.Font.Gotham
hitboxToggle.TextSize = 18

local hitboxOn = false
local hitboxSize = 8
local hitboxColor = Color3.fromRGB(255,0,0)
local hitboxes = {}

-- Slider za hitbox veličinu
local sliderFrame = Instance.new("Frame", combat)
sliderFrame.Size = UDim2.new(0, 200, 0, 32)
sliderFrame.Position = UDim2.new(0, 0, 0, nextY())
sliderFrame.BackgroundTransparency = 1
local sliderLabel = Instance.new("TextLabel", sliderFrame)
sliderLabel.Size = UDim2.new(0, 80, 1, 0)
sliderLabel.Position = UDim2.new(0,0,0,0)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Hitbox size: "
sliderLabel.TextColor3 = theme.text
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 16
local slider = Instance.new("TextButton", sliderFrame)
slider.Size = UDim2.new(0, 100, 0, 24)
slider.Position = UDim2.new(0, 90, 0, 4)
slider.BackgroundColor3 = theme.tab
slider.Text = tostring(hitboxSize)
slider.TextColor3 = theme.text
slider.Font = Enum.Font.Gotham
slider.TextSize = 16
slider.AutoButtonColor = false
slider.MouseButton1Click:Connect(function()
    hitboxSize = hitboxSize + 2
    if hitboxSize > 20 then hitboxSize = 4 end
    slider.Text = tostring(hitboxSize)
end)

-- Color picker za hitbox
local colorFrame = Instance.new("Frame", combat)
colorFrame.Size = UDim2.new(0, 200, 0, 32)
colorFrame.Position = UDim2.new(0, 0, 0, nextY())
colorFrame.BackgroundTransparency = 1
local colorLabel = Instance.new("TextLabel", colorFrame)
colorLabel.Size = UDim2.new(0, 80, 1, 0)
colorLabel.Position = UDim2.new(0,0,0,0)
colorLabel.BackgroundTransparency = 1
colorLabel.Text = "Hitbox color: "
colorLabel.TextColor3 = theme.text
colorLabel.Font = Enum.Font.Gotham
colorLabel.TextSize = 16
local colorBtn = Instance.new("TextButton", colorFrame)
colorBtn.Size = UDim2.new(0, 24, 0, 24)
colorBtn.Position = UDim2.new(0, 90, 0, 4)
colorBtn.BackgroundColor3 = hitboxColor
colorBtn.Text = ""
colorBtn.AutoButtonColor = false
colorBtn.MouseButton1Click:Connect(function()
    if hitboxColor == Color3.fromRGB(255,0,0) then
        hitboxColor = Color3.fromRGB(0,255,0)
    elseif hitboxColor == Color3.fromRGB(0,255,0) then
        hitboxColor = Color3.fromRGB(0,0,255)
    else
        hitboxColor = Color3.fromRGB(255,0,0)
    end
    colorBtn.BackgroundColor3 = hitboxColor
end)

local function updateHitboxes()
    for _,v in pairs(hitboxes) do if v and v.Parent then v:Destroy() end end
    table.clear(hitboxes)
    if not hitboxOn then return end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local part = Instance.new("Part")
            part.Anchored = true
            part.CanCollide = false
            part.Transparency = 0.7
            part.Color = hitboxColor
            part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
            part.CFrame = plr.Character.HumanoidRootPart.CFrame
            part.Parent = workspace
            table.insert(hitboxes, part)
        end
    end
end

hitboxToggle.MouseButton1Click:Connect(function()
    hitboxOn = not hitboxOn
    hitboxToggle.BackgroundColor3 = hitboxOn and theme.accent or theme.inactive
    hitboxToggle.Text = hitboxOn and "Hitbox [ON]" or "Hitbox [OFF]"
    updateHitboxes()
end)

-- DMGER (100 DMG svaki udarac)
local dmgerToggle = Instance.new("TextButton", combat)
dmgerToggle.Size = UDim2.new(0, 200, 0, 32)
dmgerToggle.Position = UDim2.new(0, 0, 0, nextY())
dmgerToggle.BackgroundColor3 = theme.inactive
dmgerToggle.Text = "100 DMG [OFF]"
dmgerToggle.TextColor3 = theme.text
dmgerToggle.Font = Enum.Font.Gotham
dmgerToggle.TextSize = 18
local dmgerOn = false
dmgerToggle.MouseButton1Click:Connect(function()
    dmgerOn = not dmgerOn
    dmgerToggle.BackgroundColor3 = dmgerOn and theme.accent or theme.inactive
    dmgerToggle.Text = dmgerOn and "100 DMG [ON]" or "100 DMG [OFF]"
end)

-- ESP TAB
local esp = tabFrames[2]
local y2 = 0
local function nextY2() y2 = y2 + 40; return y2-40 end
local espToggle = Instance.new("TextButton", esp)
espToggle.Size = UDim2.new(0, 200, 0, 32)
espToggle.Position = UDim2.new(0, 0, 0, nextY2())
espToggle.BackgroundColor3 = theme.inactive
espToggle.Text = "Nametags [OFF]"
espToggle.TextColor3 = theme.text
espToggle.Font = Enum.Font.Gotham
espToggle.TextSize = 18
local espOn = false
local nametags = {}
local function updateNametags()
    for _,v in pairs(nametags) do if v and v.Parent then v:Destroy() end end
    table.clear(nametags)
    if not espOn then return end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local tag = Instance.new("BillboardGui")
            tag.Size = UDim2.new(0, 100, 0, 30)
            tag.Adornee = plr.Character.Head
            tag.AlwaysOnTop = true
            tag.Parent = plr.Character.Head
            local txt = Instance.new("TextLabel", tag)
            txt.Size = UDim2.new(1,0,1,0)
            txt.BackgroundTransparency = 1
            txt.TextColor3 = theme.accent
            txt.Text = plr.Name .. " ["..math.floor((plr.Character.Head.Position-LocalPlayer.Character.Head.Position).Magnitude).."m]"
            txt.Font = Enum.Font.GothamBold
            txt.TextScaled = true
            table.insert(nametags, tag)
        end
    end
end
espToggle.MouseButton1Click:Connect(function()
    espOn = not espOn
    espToggle.BackgroundColor3 = espOn and theme.accent or theme.inactive
    espToggle.Text = espOn and "Nametags [ON]" or "Nametags [OFF]"
    updateNametags()
end)
-- ESP Box
local espBoxToggle = Instance.new("TextButton", esp)
espBoxToggle.Size = UDim2.new(0, 200, 0, 32)
espBoxToggle.Position = UDim2.new(0, 0, 0, nextY2())
espBoxToggle.BackgroundColor3 = theme.inactive
espBoxToggle.Text = "ESP Box [OFF]"
espBoxToggle.TextColor3 = theme.text
espBoxToggle.Font = Enum.Font.Gotham
espBoxToggle.TextSize = 18
local espBoxOn = false
espBoxToggle.MouseButton1Click:Connect(function()
    espBoxOn = not espBoxOn
    espBoxToggle.BackgroundColor3 = espBoxOn and theme.accent or theme.inactive
    espBoxToggle.Text = espBoxOn and "ESP Box [ON]" or "ESP Box [OFF]"
end)
-- ESP Tracer
local espTracerToggle = Instance.new("TextButton", esp)
espTracerToggle.Size = UDim2.new(0, 200, 0, 32)
espTracerToggle.Position = UDim2.new(0, 0, 0, nextY2())
espTracerToggle.BackgroundColor3 = theme.inactive
espTracerToggle.Text = "ESP Tracer [OFF]"
espTracerToggle.TextColor3 = theme.text
espTracerToggle.Font = Enum.Font.Gotham
espTracerToggle.TextSize = 18
local espTracerOn = false
espTracerToggle.MouseButton1Click:Connect(function()
    espTracerOn = not espTracerOn
    espTracerToggle.BackgroundColor3 = espTracerOn and theme.accent or theme.inactive
    espTracerToggle.Text = espTracerOn and "ESP Tracer [ON]" or "ESP Tracer [OFF]"
end)
-- Utility Tab
local utility = tabFrames[3]
local y3 = 0
local function nextY3() y3 = y3 + 40; return y3-40 end
local godmodeToggle = Instance.new("TextButton", utility)
godmodeToggle.Size = UDim2.new(0, 200, 0, 32)
godmodeToggle.Position = UDim2.new(0, 0, 0, nextY3())
godmodeToggle.BackgroundColor3 = theme.inactive
godmodeToggle.Text = "Godmode [OFF]"
godmodeToggle.TextColor3 = theme.text
godmodeToggle.Font = Enum.Font.Gotham
godmodeToggle.TextSize = 18
local staminaToggle = Instance.new("TextButton", utility)
staminaToggle.Size = UDim2.new(0, 200, 0, 32)
staminaToggle.Position = UDim2.new(0, 0, 0, nextY3())
staminaToggle.BackgroundColor3 = theme.inactive
staminaToggle.Text = "Infinite Stamina [OFF]"
staminaToggle.TextColor3 = theme.text
staminaToggle.Font = Enum.Font.Gotham
staminaToggle.TextSize = 18
local godmodeOn, staminaOn = false, false
godmodeToggle.MouseButton1Click:Connect(function()
    godmodeOn = not godmodeOn
    godmodeToggle.BackgroundColor3 = godmodeOn and theme.accent or theme.inactive
    godmodeToggle.Text = godmodeOn and "Godmode [ON]" or "Godmode [OFF]"
end)
staminaToggle.MouseButton1Click:Connect(function()
    staminaOn = not staminaOn
    staminaToggle.BackgroundColor3 = staminaOn and theme.accent or theme.inactive
    staminaToggle.Text = staminaOn and "Infinite Stamina [ON]" or "Infinite Stamina [OFF]"
end)
-- Glavni loop za funkcije
local espBoxes, espTracers = {}, {}
RunService.RenderStepped:Connect(function()
    -- Hitbox
    if hitboxOn then
        updateHitboxes()
    else
        for _,v in pairs(hitboxes) do if v and v.Parent then v:Destroy() end end
        table.clear(hitboxes)
    end
    -- ESP
    if espOn then
        updateNametags()
    else
        for _,v in pairs(nametags) do if v and v.Parent then v:Destroy() end end
        table.clear(nametags)
    end
    -- ESP Box
    for _,v in pairs(espBoxes) do if v and v.Parent then v:Destroy() end end
    table.clear(espBoxes)
    if espBoxOn then
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = plr.Character.HumanoidRootPart
                box.Size = Vector3.new(4,6,2)
                box.Color3 = theme.accent
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Parent = workspace.CurrentCamera
                table.insert(espBoxes, box)
            end
        end
    end
    -- ESP Tracer
    for _,v in pairs(espTracers) do if v and v.Parent then v:Destroy() end end
    table.clear(espTracers)
    if espTracerOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        local from = workspace.CurrentCamera:WorldToViewportPoint(LocalPlayer.Character.Head.Position)
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local to = workspace.CurrentCamera:WorldToViewportPoint(plr.Character.Head.Position)
                local line = Drawing and Drawing.new("Line") or Instance.new("Frame", gui)
                if Drawing and line then
                    line.From = Vector2.new(from.X, from.Y)
                    line.To = Vector2.new(to.X, to.Y)
                    line.Color = theme.accent
                    line.Thickness = 2
                    line.Transparency = 1
                    line.Visible = true
                    table.insert(espTracers, line)
                else
                    -- fallback: simple frame
                    line.Size = UDim2.new(0,2,0,(to.Y-from.Y))
                    line.Position = UDim2.new(0,from.X,0,from.Y)
                    line.BackgroundColor3 = theme.accent
                    line.BorderSizePixel = 0
                    table.insert(espTracers, line)
                end
            end
        end
    end
    -- Godmode
    if godmodeOn and LocalPlayer.Character then
        local h = getHealthVar(LocalPlayer.Character)
        if h then
            if h:IsA("Humanoid") then
                h.Health = h.MaxHealth
            elseif h:IsA("NumberValue") then
                h.Value = 100
            end
        end
    end
    -- Infinite stamina
    if staminaOn and LocalPlayer.Character then
        local s = getStaminaVar(LocalPlayer.Character)
        if s and s.Value < 115 then s.Value = 115 end
    end
    -- DMGER (brute force: smanjuje health protivnicima u hitboxu)
    if dmgerOn and hitboxOn then
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local h = getHealthVar(plr.Character)
                if h then
                    for _,box in ipairs(hitboxes) do
                        if plr.Character:FindFirstChild("HumanoidRootPart") and (plr.Character.HumanoidRootPart.Position - box.Position).Magnitude < (hitboxSize/2) then
                            if h:IsA("Humanoid") then
                                h.Health = math.max(0, h.Health - 100)
                            elseif h:IsA("NumberValue") then
                                h.Value = math.max(0, h.Value - 100)
                            end
                        end
                    end
                end
            end
        end
    end
    -- Infinite money (ako želiš, možeš dodati toggle i koristiti getMoneyVar())
    -- local m = getMoneyVar()
    -- if m and m.Value < 999999 then m.Value = 999999 end
end)
-- Hotkey za sakrivanje/prikaz GUI (Desni Shift)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end) 