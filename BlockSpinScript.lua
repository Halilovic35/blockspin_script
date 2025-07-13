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

-- AIMBOT
local aimbotToggle = Instance.new("TextButton", combat)
aimbotToggle.Size = UDim2.new(0, 200, 0, 32)
aimbotToggle.Position = UDim2.new(0, 0, 0, nextY())
aimbotToggle.BackgroundColor3 = theme.inactive
aimbotToggle.Text = "Aimbot [OFF]"
aimbotToggle.TextColor3 = theme.text
aimbotToggle.Font = Enum.Font.Gotham
aimbotToggle.TextSize = 18

local aimbotOn = false
local aimbotBind = Enum.KeyCode.R -- default bind na R
local aimbotTargetPart = "Head" -- ili "HumanoidRootPart"

-- Dropdown za biranje cilja (glava/tijelo)
local partDropdown = Instance.new("TextButton", combat)
partDropdown.Size = UDim2.new(0, 200, 0, 32)
partDropdown.Position = UDim2.new(0, 0, 0, nextY())
partDropdown.BackgroundColor3 = theme.tab
partDropdown.Text = "Cilj: Glava"
partDropdown.TextColor3 = theme.text
partDropdown.Font = Enum.Font.Gotham
partDropdown.TextSize = 16
partDropdown.AutoButtonColor = false
partDropdown.MouseButton1Click:Connect(function()
    if aimbotTargetPart == "Head" then
        aimbotTargetPart = "HumanoidRootPart"
        partDropdown.Text = "Cilj: Tijelo"
    else
        aimbotTargetPart = "Head"
        partDropdown.Text = "Cilj: Glava"
    end
end)

-- Bind info i promjena binda
local bindLabel = Instance.new("TextButton", combat)
bindLabel.Size = UDim2.new(0, 200, 0, 24)
bindLabel.Position = UDim2.new(0, 0, 0, nextY())
bindLabel.BackgroundTransparency = 1
bindLabel.Text = "Bind: R (klikni za promjenu)"
bindLabel.TextColor3 = theme.text
bindLabel.Font = Enum.Font.Gotham
bindLabel.TextSize = 14
bindLabel.AutoButtonColor = true
local waitingForBind = false
bindLabel.MouseButton1Click:Connect(function()
    bindLabel.Text = "Pritisni tipku..."
    waitingForBind = true
end)
UserInputService.InputBegan:Connect(function(input, processed)
    if waitingForBind and input.UserInputType == Enum.UserInputType.Keyboard then
        aimbotBind = input.KeyCode
        bindLabel.Text = "Bind: "..tostring(aimbotBind.Name)
        waitingForBind = false
    end
end)

-- Auto-Attack toggle
local autoAttackToggle = Instance.new("TextButton", combat)
autoAttackToggle.Size = UDim2.new(0, 200, 0, 32)
autoAttackToggle.Position = UDim2.new(0, 0, 0, nextY())
autoAttackToggle.BackgroundColor3 = theme.inactive
autoAttackToggle.Text = "Auto-Attack [OFF]"
autoAttackToggle.TextColor3 = theme.text
autoAttackToggle.Font = Enum.Font.Gotham
autoAttackToggle.TextSize = 18
local autoAttackOn = false
autoAttackToggle.MouseButton1Click:Connect(function()
    autoAttackOn = not autoAttackOn
    autoAttackToggle.BackgroundColor3 = autoAttackOn and theme.accent or theme.inactive
    autoAttackToggle.Text = autoAttackOn and "Auto-Attack [ON]" or "Auto-Attack [OFF]"
end)

-- Aimbot logika
local aiming = false
local lockedTarget = nil
UserInputService.InputBegan:Connect(function(input, processed)
    if not waitingForBind and input.KeyCode == aimbotBind and not processed then
        aimbotOn = not aimbotOn
        aimbotToggle.BackgroundColor3 = aimbotOn and theme.accent or theme.inactive
        aimbotToggle.Text = aimbotOn and "Aimbot [ON]" or "Aimbot [OFF]"
        if not aimbotOn then lockedTarget = nil end
    end
end)

local function getClosestTarget()
    local closest, dist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(aimbotTargetPart) then
            local part = player.Character[aimbotTargetPart]
            local d = (part.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
            if d < dist then
                dist = d
                closest = part
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if aimbotOn then
        if not lockedTarget or not lockedTarget.Parent or not lockedTarget:IsDescendantOf(workspace) then
            lockedTarget = getClosestTarget()
        end
        if lockedTarget then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, lockedTarget.Position)
        end
    else
        lockedTarget = nil
    end
end)

-- Auto-Attack logika
spawn(function()
    while true do
        if aimbotOn and autoAttackOn and lockedTarget then
            mouse1press()
            wait()
            mouse1release()
        else
            wait(0.05)
        end
    end
end)

-- Hitbox
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

local function createNametag(plr)
    if not plr.Character or not plr.Character:FindFirstChild("Head") then return end
    if nametags[plr] and nametags[plr].Parent then return end
    local tag = Instance.new("BillboardGui")
    tag.Name = "MissakyNametag"
    tag.Size = UDim2.new(0, 100, 0, 30)
    tag.Adornee = plr.Character.Head
    tag.AlwaysOnTop = true
    tag.Parent = plr.Character.Head
    local txt = Instance.new("TextLabel", tag)
    txt.Name = "MissakyNameText"
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = theme.accent
    txt.Text = plr.Name
    txt.Font = Enum.Font.GothamBold
    txt.TextScaled = true
    nametags[plr] = tag
end

local function removeNametag(plr)
    if nametags[plr] then
        nametags[plr]:Destroy()
        nametags[plr] = nil
    end
end

espToggle.MouseButton1Click:Connect(function()
    espOn = not espOn
    espToggle.BackgroundColor3 = espOn and theme.accent or theme.inactive
    espToggle.Text = espOn and "Nametags [ON]" or "Nametags [OFF]"
    if not espOn then
        for _,tag in pairs(nametags) do if tag and tag.Parent then tag:Destroy() end end
        nametags = {}
    end
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
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                createNametag(plr)
                -- Update distance in text
                local tag = nametags[plr]
                if tag and tag:FindFirstChild("MissakyNameText") then
                    local dist = math.floor((plr.Character.Head.Position-LocalPlayer.Character.Head.Position).Magnitude)
                    tag.MissakyNameText.Text = plr.Name .. " ["..dist.."m]"
                end
            else
                removeNametag(plr)
            end
        end
        -- Clean up nametags for players who left
        for plr,tag in pairs(nametags) do
            if not plr.Parent or not plr.Character or not plr.Character:FindFirstChild("Head") then
                removeNametag(plr)
            end
        end
    else
        for _,tag in pairs(nametags) do if tag and tag.Parent then tag:Destroy() end end
        nametags = {}
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
    for _,v in pairs(espTracers) do if v and v.Remove then v:Remove() elseif v and v.Parent then v:Destroy() end end
    table.clear(espTracers)
    if espTracerOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        local from = workspace.CurrentCamera:WorldToViewportPoint(LocalPlayer.Character.Head.Position)
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local to = workspace.CurrentCamera:WorldToViewportPoint(plr.Character.Head.Position)
                if Drawing then
                    local line = Drawing.new("Line")
                    line.From = Vector2.new(from.X, from.Y)
                    line.To = Vector2.new(to.X, to.Y)
                    line.Color = theme.accent
                    line.Thickness = 2
                    line.Transparency = 1
                    line.Visible = true
                    table.insert(espTracers, line)
                else
                    -- fallback: simple frame (draws vertical line only)
                    local frame = Instance.new("Frame", gui)
                    frame.Size = UDim2.new(0,2,0,(to.Y-from.Y))
                    frame.Position = UDim2.new(0,from.X,0,from.Y)
                    frame.BackgroundColor3 = theme.accent
                    frame.BorderSizePixel = 0
                    frame.Visible = true
                    table.insert(espTracers, frame)
                end
            end
        end
    end
    -- Godmode
    -- if godmodeOn and LocalPlayer.Character then
    --     local h = getHealthVar(LocalPlayer.Character)
    --     if h then
    --         if h:IsA("Humanoid") then
    --             h.Health = h.MaxHealth
    --         elseif h:IsA("NumberValue") then
    --             h.Value = 100
    --         end
    --     end
    -- end
    -- Infinite stamina
    -- if staminaOn and LocalPlayer.Character then
    --     local s = getStaminaVar(LocalPlayer.Character)
    --     if s and s.Value < 115 then s.Value = 115 end
    -- end
    -- DMGER (brute force: smanjuje health protivnicima u hitboxu)
    -- if dmgerOn and hitboxOn then
    --     for _,plr in ipairs(Players:GetPlayers()) do
    --         if plr ~= LocalPlayer and plr.Character then
    --             local h = getHealthVar(plr.Character)
    --             if h then
    --                 for _,box in ipairs(hitboxes) do
    --                     if plr.Character:FindFirstChild("HumanoidRootPart") and (plr.Character.HumanoidRootPart.Position - box.Position).Magnitude < (hitboxSize/2) then
    --                         if h:IsA("Humanoid") then
    --                             h.Health = math.max(0, h.Health - 100)
    --                         elseif h:IsA("NumberValue") then
    --                             h.Value = math.max(0, h.Value - 100)
    --                         end
    --                     end
    --                 end
    --             end
    --         end
    --     end
    -- end
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