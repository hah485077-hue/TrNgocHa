--[[
====================================================
 👑 VIP CYBER + SMART AUTO ESCAPE TELEPORT [ULTIMATE]
 Premium Paid Edition v3.5 | Cyberpunk Obsidian UI
 Created & Redesigned by Em 💕
====================================================
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")

local p = Players.LocalPlayer
local pg = p:WaitForChild("PlayerGui")
local cam = workspace.CurrentCamera

-- CLEANUP OLD INSTANCES
if _G.__COMBINED_CLEANUP then pcall(_G.__COMBINED_CLEANUP) end
local conns = {}
local function track(c) table.insert(conns, c); return c end
_G.__COMBINED_CLEANUP = function()
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    conns = {}
    local old = pg:FindFirstChild("VipCyberPremiumUI")
    if old then old:Destroy() end
end
local oldMenu = pg:FindFirstChild("VipCyberPremiumUI")
if oldMenu then oldMenu:Destroy() end

-- CONFIGURATION
local Config = {
    Lock = false, Fly = false, Fast = false, Noclip = false, ESP = false,
    RunSpeed = 50, FlySpeed = 60,
    AutoEscapeEnabled = true, SmartModeEnabled = true, SmartThreshold = 0.01,
    PredictiveEnabled = true, PredictiveRange = 30,
    TeleportDistance = 50, SoundEnabled = true,
}

local Character, Humanoid, Root
local HealthConn, PredictiveConn
local isEscaping = false
local tgt = nil
local flyBV, flyBG = nil, nil
local upS, dnS = 0, 0
local lastTp = 0
local goodCam = nil
local savedPos = nil
local diedConn = nil
local espGuis = {}

-- AUDIO ASSETS
local SOUND_RIFT  = "rbxassetid://1838218402"
local SOUND_GLASS = "rbxassetid://5152763850"
local SOUND_TELE  = "rbxassetid://6042053626"

local function playSoundAt(soundId, position, volume, pitch)
    if not Config.SoundEnabled then return end
    pcall(function()
        local sp = Instance.new("Part")
        sp.Anchored = true; sp.CanCollide = false; sp.Transparency = 1
        sp.Size = Vector3.new(1,1,1); sp.CFrame = CFrame.new(position); sp.Parent = workspace
        local s = Instance.new("Sound")
        s.SoundId = soundId; s.Volume = volume or 1; s.PlaybackSpeed = pitch or 1
        s.RollOffMaxDistance = 300; s.RollOffMinDistance = 5
        s.Parent = sp; s:Play()
        Debris:AddItem(sp, 8)
    end)
end

local function playSoundLocal(soundId, volume, pitch)
    if not Config.SoundEnabled then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = soundId; s.Volume = volume or 1; s.PlaybackSpeed = pitch or 1
        s.Parent = SoundService; s:Play()
        Debris:AddItem(s, 8)
    end)
end

-- VISUAL EFFECTS (SPACE TEAR & PARTICLES)
local function createStars(position, radius)
    for i = 1, 30 do
        local star = Instance.new("Part")
        star.Shape = Enum.PartType.Ball
        star.Size = Vector3.new(0.6, 0.6, 0.6)
        star.Anchored = true; star.CanCollide = false
        star.CanTouch = false; star.CanQuery = false
        star.Material = Enum.Material.Neon
        star.Color = Color3.fromRGB(0, 230, 255)
        star.CFrame = CFrame.new(position + Vector3.new(
            math.random(-radius, radius), math.random(-radius, radius), math.random(-radius, radius)
        ))
        star.Parent = workspace
        local light = Instance.new("PointLight", star)
        light.Color = Color3.fromRGB(150, 0, 255)
        light.Range = 6; light.Brightness = 5
        TweenService:Create(star, TweenInfo.new(1.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = star.Position + Vector3.new(math.random(-15,15), math.random(10,22), math.random(-15,15)),
            Transparency = 1, Size = Vector3.new(0,0,0)
        }):Play()
        Debris:AddItem(star, 1.5)
    end
end

local function createGlassBreak(position)
    playSoundAt(SOUND_GLASS, position, 1, 1)
    for i = 1, 60 do
        local shard = Instance.new("Part")
        shard.Size = Vector3.new(math.random(2,9), math.random(2,9), math.random(2,9))
        shard.Anchored = true; shard.CanCollide = false
        shard.CanTouch = false; shard.CanQuery = false
        shard.Material = Enum.Material.Glass
        local colors = {
            Color3.fromRGB(0, 225, 255),
            Color3.fromRGB(140, 0, 255),
            Color3.fromRGB(220, 240, 255),
        }
        shard.Color = colors[math.random(1, #colors)]
        shard.Transparency = 0.1; shard.Reflectance = 0.4
        shard.CFrame = CFrame.new(position) * CFrame.Angles(
            math.random(0,360), math.random(0,360), math.random(0,360)
        )
        shard.Parent = workspace
        local dir = Vector3.new(math.random(-55,55), math.random(-30,55), math.random(-55,55))
        TweenService:Create(shard, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = position + dir, Transparency = 1, Size = Vector3.new(0.1, 0.1, 0.1)
        }):Play()
        TweenService:Create(shard, TweenInfo.new(1, Enum.EasingStyle.Linear), {
            CFrame = shard.CFrame * CFrame.Angles(math.random(-360, 360), math.random(-360, 360), math.random(-360, 360))
        }):Play()
        Debris:AddItem(shard, 1.6)
    end
end

local function createSpaceTear(position, lookVector)
    playSoundAt(SOUND_RIFT, position, 1, 0.9)
    local cf = CFrame.new(position, position + lookVector)
    local rot90 = CFrame.Angles(0, 0, math.rad(90))

    local voidCore = Instance.new("Part")
    voidCore.Shape = Enum.PartType.Cylinder
    voidCore.Size = Vector3.new(0.6, 11, 11)
    voidCore.Anchored = true; voidCore.CanCollide = false
    voidCore.CanTouch = false; voidCore.CanQuery = false
    voidCore.Material = Enum.Material.Neon
    voidCore.Color = Color3.fromRGB(2, 0, 8)
    voidCore.CFrame = cf * rot90
    voidCore.Parent = workspace

    local voidLight = Instance.new("PointLight", voidCore)
    voidLight.Color = Color3.fromRGB(0, 200, 255)
    voidLight.Range = 35; voidLight.Brightness = 12

    local purpleCore = Instance.new("Part")
    purpleCore.Shape = Enum.PartType.Cylinder
    purpleCore.Size = Vector3.new(0.9, 12.5, 12.5)
    purpleCore.Anchored = true; purpleCore.CanCollide = false
    purpleCore.Material = Enum.Material.Neon
    purpleCore.Color = Color3.fromRGB(130, 0, 255)
    purpleCore.Transparency = 0.3
    purpleCore.CFrame = cf * rot90
    purpleCore.Parent = workspace

    local outline = Instance.new("Part")
    outline.Shape = Enum.PartType.Cylinder
    outline.Size = Vector3.new(1.1, 14, 14)
    outline.Anchored = true; outline.CanCollide = false
    outline.Material = Enum.Material.SmoothPlastic
    outline.Color = Color3.fromRGB(200, 240, 255)
    outline.Transparency = 0.1
    outline.CFrame = cf * rot90
    outline.Parent = workspace

    for i = 1, 14 do
        local bolt = Instance.new("Part")
        bolt.Shape = Enum.PartType.Cylinder
        bolt.Size = Vector3.new(0.25, math.random(8, 18), 0.25)
        bolt.Anchored = true; bolt.CanCollide = false
        bolt.Material = Enum.Material.Neon
        bolt.Color = Color3.fromRGB(0, 230, 255)
        bolt.Transparency = 0.05
        bolt.CFrame = cf * rot90 * CFrame.Angles(
            math.random(-45, 45), math.random(-45, 45), math.random(-45, 45)
        )
        bolt.Parent = workspace
        Debris:AddItem(bolt, 1.5)
        TweenService:Create(bolt, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(0.1, math.random(18, 28), 0.1), Transparency = 1
        }):Play()
    end

    local shockwave = Instance.new("Part")
    shockwave.Shape = Enum.PartType.Cylinder
    shockwave.Size = Vector3.new(0.3, 2, 2)
    shockwave.Anchored = true; shockwave.CanCollide = false
    shockwave.Material = Enum.Material.Neon
    shockwave.Color = Color3.fromRGB(255, 255, 255)
    shockwave.Transparency = 0.1
    shockwave.CFrame = cf * rot90
    shockwave.Parent = workspace
    TweenService:Create(shockwave, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.3, 40, 40), Transparency = 1
    }):Play()
    Debris:AddItem(shockwave, 1)

    task.delay(0.08, function() createGlassBreak(position) end)
    task.delay(0.55, function()
        TweenService:Create(voidCore, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = Vector3.new(0, 0, 0), Transparency = 1
        }):Play()
        TweenService:Create(purpleCore, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = Vector3.new(0, 0, 0), Transparency = 1
        }):Play()
        TweenService:Create(outline, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = Vector3.new(0, 0, 0), Transparency = 1
        }):Play()
        Debris:AddItem(voidCore, 0.8)
        Debris:AddItem(purpleCore, 0.8)
        Debris:AddItem(outline, 0.8)
    end)
end

local function doTeleport(reason)
    if isEscaping then return end
    if not Root or not Root.Parent then return end
    isEscaping = true
    local oldPosition = Root.Position
    local oldLook = Root.CFrame.LookVector
    playSoundLocal(SOUND_TELE, 1, 1.2)
    createSpaceTear(oldPosition, oldLook)
    local escapeCFrame = Root.CFrame * CFrame.new(0, 0, Config.TeleportDistance)
    pcall(function() Root.CFrame = escapeCFrame end)
    task.delay(0.1, function()
        if Root and Root.Parent then createStars(Root.Position, 10) end
    end)
    task.wait(0.2)
    isEscaping = false
end

-- AUTO ESCAPE & PREDICTIVE SYSTEM
local function setupAutoEscape()
    if not Humanoid or not Root then return end
    if HealthConn then HealthConn:Disconnect() end
    local lastHealth = Humanoid.Health
    HealthConn = Humanoid.HealthChanged:Connect(function(newHealth)
        if not Config.AutoEscapeEnabled or isEscaping then return end
        local oldHealth = lastHealth
        lastHealth = newHealth
        local damage = oldHealth - newHealth
        local shouldTeleport = true
        if Config.SmartModeEnabled then
            shouldTeleport = (damage >= Config.SmartThreshold)
        end
        if damage > 0 and shouldTeleport then doTeleport("Damage") end
    end)
end

local function setupPredictive()
    if not Root then return end
    if PredictiveConn then PredictiveConn:Disconnect() end
    PredictiveConn = RunService.Heartbeat:Connect(function()
        if not Config.AutoEscapeEnabled or not Config.PredictiveEnabled or isEscaping or not Root or not Root.Parent then return end
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= p and otherPlayer.Character then
                local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                local otherHum = otherPlayer.Character:FindFirstChildOfClass("Humanoid")
                if otherRoot and otherHum and otherHum.Health > 0 then
                    local dist = (otherRoot.Position - Root.Position).Magnitude
                    if dist <= Config.PredictiveRange then
                        local animator = otherHum:FindFirstChildOfClass("Animator")
                        if animator then
                            for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
                                local animName = ""
                                pcall(function() animName = string.lower(tr.Animation.Name) end)
                                if string.find(animName, "skill") or string.find(animName, "combo")
                                or string.find(animName, "ultimate") or string.find(animName, "special")
                                or string.find(animName, "attack") or string.find(animName, "punch")
                                or string.find(animName, "kick") or string.find(animName, "smash") then
                                    if not (string.find(animName, "idle") or string.find(animName, "walk") or string.find(animName, "run")) then
                                        doTeleport("Predictive")
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function setupCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    Root = char:WaitForChild("HumanoidRootPart")
    if HealthConn then HealthConn:Disconnect() end
    setupAutoEscape()
    setupPredictive()
end

if p.Character then setupCharacter(p.Character) end
p.CharacterAdded:Connect(setupCharacter)

-- ESP SYSTEM
local function createESP(pl)
    local char = pl.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not head or not humanoid then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_"..pl.Name
    billboard.Size = UDim2.new(0, 130, 0, 48)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = head
    billboard.Parent = head
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0,16)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = pl.Name
    nameLabel.TextColor3 = Color3.fromRGB(0, 229, 255)
    nameLabel.TextStrokeTransparency = 0.2
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 11
    nameLabel.Parent = billboard

    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(1, -20, 0, 6)
    healthBg.Position = UDim2.new(0, 10, 0, 20)
    healthBg.BackgroundColor3 = Color3.fromRGB(20,20,30)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = billboard
    Instance.new("UICorner", healthBg).CornerRadius = UDim.new(1, 0)

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1,0,1,0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 230, 118)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg
    Instance.new("UICorner", healthFill).CornerRadius = UDim.new(1, 0)

    local healthText = Instance.new("TextLabel")
    healthText.Size = UDim2.new(1,0,0,12)
    healthText.Position = UDim2.new(0,0,0,30)
    healthText.BackgroundTransparency = 1
    healthText.TextColor3 = Color3.fromRGB(200, 200, 220)
    healthText.Font = Enum.Font.GothamMedium
    healthText.TextSize = 10
    healthText.Parent = billboard

    espGuis[pl] = {Gui = billboard, Char = char, HealthFill = healthFill, HealthText = healthText}
end

local function removeESP(pl)
    if espGuis[pl] then
        if espGuis[pl].Gui then espGuis[pl].Gui:Destroy() end
        espGuis[pl] = nil
    end
end

local function clearESP()
    for pl, data in pairs(espGuis) do
        if data.Gui then data.Gui:Destroy() end
    end
    espGuis = {}
end

track(Players.PlayerRemoving:Connect(removeESP))

local function findT()
    local vx, vy = cam.ViewportSize.X, cam.ViewportSize.Y
    if vx == 0 or vy == 0 then vx, vy = 1920, 1080 end
    local c = Vector2.new(vx/2, vy/2)
    local best, bd = nil, math.huge
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= p and pl.Character then
            local rp = pl.Character:FindFirstChild("HumanoidRootPart")
            local h = pl.Character:FindFirstChildOfClass("Humanoid")
            if rp and h and h.Health > 0 then
                local sp, on = cam:WorldToViewportPoint(rp.Position)
                if on then
                    local d = (Vector2.new(sp.X, sp.Y) - c).Magnitude
                    if d < bd then bd = d; best = pl end
                end
            end
        end
    end
    return best
end

--====================================================
-- 🎨 HIGH-END LUXURY PAID UI INTERFACE
--====================================================

local BASE_W = 340
local BASE_H = 310

local g = Instance.new("ScreenGui")
g.Name = "VipCyberPremiumUI"
g.ResetOnSpawn = false
g.Parent = pg

-- Main Window Frame
local mainFrame = Instance.new("Frame", g)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, BASE_W, 0, BASE_H)
mainFrame.Position = UDim2.new(0.5, -BASE_W/2, 0.4, -BASE_H/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(13, 14, 20)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = false
mainFrame.Active = true

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 14)

-- Glow & Stroke Border
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 1.5
mainStroke.Color = Color3.fromRGB(120, 50, 255)
mainStroke.Transparency = 0.2

local uiGradient = Instance.new("UIGradient", mainFrame)
uiGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 20, 32)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 11, 16))
})
uiGradient.Rotation = 135

local uiscale = Instance.new("UIScale", mainFrame)
uiscale.Scale = 1

-- Header Bar
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundColor3 = Color3.fromRGB(20, 22, 34)
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 14)

local headerCover = Instance.new("Frame", header)
headerCover.Size = UDim2.new(1, 0, 0.5, 0)
headerCover.Position = UDim2.new(0, 0, 0.5, 0)
headerCover.BackgroundColor3 = Color3.fromRGB(20, 22, 34)
headerCover.BorderSizePixel = 0

-- Header Title & Paid Badge
local logoTitle = Instance.new("TextLabel", header)
logoTitle.Size = UDim2.new(0, 130, 1, 0)
logoTitle.Position = UDim2.new(0, 12, 0, 0)
logoTitle.BackgroundTransparency = 1
logoTitle.Text = "VIP CYBER"
logoTitle.TextColor3 = Color3.fromRGB(0, 229, 255)
logoTitle.Font = Enum.Font.GothamBold
logoTitle.TextSize = 13
logoTitle.TextXAlignment = Enum.TextXAlignment.Left

local paidBadge = Instance.new("Frame", header)
paidBadge.Size = UDim2.new(0, 70, 0, 18)
paidBadge.Position = UDim2.new(0, 100, 0.5, -9)
paidBadge.BackgroundColor3 = Color3.fromRGB(120, 40, 240)
paidBadge.BorderSizePixel = 0
Instance.new("UICorner", paidBadge).CornerRadius = UDim.new(0, 6)

local badgeGrad = Instance.new("UIGradient", paidBadge)
badgeGrad.Color = ColorSequence.new(Color3.fromRGB(160, 50, 255), Color3.fromRGB(0, 200, 255))

local badgeText = Instance.new("TextLabel", paidBadge)
badgeText.Size = UDim2.new(1, 0, 1, 0)
badgeText.BackgroundTransparency = 1
badgeText.Text = "PAID PRO"
badgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
badgeText.Font = Enum.Font.GothamBold
badgeText.TextSize = 9

-- Close Button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -32, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
closeBtn.BackgroundTransparency = 0.8
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 120)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundTransparency = 0 end)
closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundTransparency = 0.8 end)

-- Content Scroll Container
local scrollContainer = Instance.new("ScrollingFrame", mainFrame)
scrollContainer.Size = UDim2.new(1, -16, 1, -48)
scrollContainer.Position = UDim2.new(0, 8, 0, 42)
scrollContainer.BackgroundTransparency = 1
scrollContainer.BorderSizePixel = 0
scrollContainer.ScrollBarThickness = 3
scrollContainer.ScrollBarImageColor3 = Color3.fromRGB(120, 50, 255)
scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 360)

local layout = Instance.new("UIListLayout", scrollContainer)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)

-- UI CONTROLS BUILDERS (TOGGLES, BUTTONS, SLIDERS)
local function createSectionHeader(title)
    local secFrame = Instance.new("Frame", scrollContainer)
    secFrame.Size = UDim2.new(1, 0, 0, 18)
    secFrame.BackgroundTransparency = 1

    local secText = Instance.new("TextLabel", secFrame)
    secText.Size = UDim2.new(1, 0, 1, 0)
    secText.BackgroundTransparency = 1
    secText.Text = string.upper(title)
    secText.TextColor3 = Color3.fromRGB(120, 130, 160)
    secText.Font = Enum.Font.GothamBold
    secText.TextSize = 9
    secText.TextXAlignment = Enum.TextXAlignment.Left
end

local function createToggleRow(title, defaultState, callback)
    local row = Instance.new("Frame", scrollContainer)
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundColor3 = Color3.fromRGB(20, 22, 34)
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", row)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(40, 45, 65)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.65, -10, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = Color3.fromRGB(220, 225, 240)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", row)
    toggleBtn.Size = UDim2.new(0, 44, 0, 20)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
    toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 229, 255) or Color3.fromRGB(35, 40, 55)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", toggleBtn)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = defaultState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local state = defaultState
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(0, 229, 255) or Color3.fromRGB(35, 40, 55)
        }):Play()
        TweenService:Create(dot, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        }):Play()
        callback(state)
    end)
    return toggleBtn
end

local function createGridButtons(btnData)
    local row = Instance.new("Frame", scrollContainer)
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundTransparency = 1

    local count = #btnData
    local widthScale = (1 - (0.02 * (count - 1))) / count

    for i, data in ipairs(btnData) do
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(widthScale, 0, 1, 0)
        btn.Position = UDim2.new((i - 1) * (widthScale + 0.02), 0, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(25, 28, 45)
        btn.Text = data.Text
        btn.TextColor3 = Color3.fromRGB(0, 229, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Thickness = 1
        stroke.Color = Color3.fromRGB(60, 70, 100)

        btn.MouseButton1Click:Connect(function()
            data.Callback(btn)
        end)
    end
end

local activeSlider = nil
track(UIS.InputChanged:Connect(function(inp)
    if activeSlider and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        activeSlider(inp.Position.X)
    end
end))
track(UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        activeSlider = nil
    end
end))

local function createSliderRow(title, min, max, default, callback)
    local row = Instance.new("Frame", scrollContainer)
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(20, 22, 34)
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", row)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(40, 45, 65)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -16, 0, 16)
    lbl.Position = UDim2.new(0, 10, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = title .. ": " .. default
    lbl.TextColor3 = Color3.fromRGB(200, 205, 225)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local tr = Instance.new("Frame", row)
    tr.Size = UDim2.new(1, -20, 0, 6)
    tr.Position = UDim2.new(0, 10, 0, 24)
    tr.BackgroundColor3 = Color3.fromRGB(35, 40, 58)
    tr.BorderSizePixel = 0
    Instance.new("UICorner", tr).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", tr)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(140, 50, 255)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", tr)
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(0, 229, 255)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local function updateInput(inputX)
        local ta = tr.AbsolutePosition.X
        local tw = tr.AbsoluteSize.X
        if tw <= 0 then return end
        local r = math.clamp((inputX - ta) / tw, 0, 1)
        local v = math.floor(min + r * (max - min))
        fill.Size = UDim2.new(r, 0, 1, 0)
        knob.Position = UDim2.new(r, -6, 0.5, -6)
        lbl.Text = title .. ": " .. v
        callback(v)
    end

    tr.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            updateInput(inp.Position.X)
            activeSlider = updateInput
        end
    end)
end

-- POPULATE MENU SECTIONS
createSectionHeader("Đảo Tải & Phòng Thủ")
createToggleRow("Tự Động Né Chiêu (Auto Escape)", Config.AutoEscapeEnabled, function(v)
    Config.AutoEscapeEnabled = v
end)
createSliderRow("Phạm Vi Dịch Chuyển", 10, 200, Config.TeleportDistance, function(v)
    Config.TeleportDistance = v
end)

createSectionHeader("Di Chuyển VIP")
createToggleRow("Chạy Nhanh (Fast Run)", Config.Fast, function(v)
    Config.Fast = v
end)
createToggleRow("Chế Độ Bay (Fly)", Config.Fly, function(v)
    Config.Fly = v
    local ch = p.Character
    local h = ch and ch:FindFirstChildOfClass("Humanoid")
    if Config.Fly then
        if h then h.PlatformStand = true end
        local rp = ch and ch:FindFirstChild("HumanoidRootPart")
        if rp then
            flyBV = Instance.new("BodyVelocity", rp)
            flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            flyBG = Instance.new("BodyGyro", rp)
            flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            flyBG.P = 10000
        end
        upBtn.Visible = true
        dnBtn.Visible = true
    else
        if h then h.PlatformStand = false end
        if flyBV then flyBV:Destroy() flyBV = nil end
        if flyBG then flyBG:Destroy() flyBG = nil end
        upBtn.Visible = false
        dnBtn.Visible = false
    end
end)
createToggleRow("Xuyên Bản Đồ (Noclip)", Config.Noclip, function(v)
    Config.Noclip = v
end)

createSliderRow("Tốc Độ Bay", 20, 300, Config.FlySpeed, function(v) Config.FlySpeed = v end)
createSliderRow("Tốc Độ Chạy", 16, 200, Config.RunSpeed, function(v) Config.RunSpeed = v end)

createSectionHeader("Hỗ Trợ Chiến Đấu & ESP")
createToggleRow("Khóa Mục Tiêu (Lock Target)", Config.Lock, function(v)
    Config.Lock = v
    if Config.Lock then
        local t = findT()
        if t and t.Character then
            local rp = t.Character:FindFirstChild("HumanoidRootPart")
            local h = t.Character:FindFirstChildOfClass("Humanoid")
            if rp and h then
                if diedConn then diedConn:Disconnect() end
                tgt = {Root = rp, Humanoid = h, Char = t.Character}
                diedConn = h.Died:Connect(function()
                    Config.Lock = false
                    cam.CameraType = Enum.CameraType.Custom
                    local mh = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                    if mh then cam.CameraSubject = mh end
                    tgt = nil
                end)
                cam.CameraType = Enum.CameraType.Scriptable
            end
        else
            Config.Lock = false
        end
    else
        if diedConn then diedConn:Disconnect() diedConn = nil end
        tgt = nil
        cam.CameraType = Enum.CameraType.Custom
        local mh = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
        if mh then cam.CameraSubject = mh end
    end
end)

createToggleRow("Hiển Thị Kẻ Địch (ESP)", Config.ESP, function(v)
    Config.ESP = v
    if not Config.ESP then clearESP() end
end)

createGridButtons({
    {
        Text = "Lưu Vị Trí",
        Callback = function(btn)
            local rp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if rp then
                savedPos = rp.Position
                btn.Text = "Đã Lưu!"
                task.wait(1.2)
                btn.Text = "Lưu Vị Trí"
            end
        end
    },
    {
        Text = "Về Vị Trí Saved",
        Callback = function(btn)
            if not savedPos then
                btn.Text = "Chưa Lưu!"
                task.wait(1.2)
                btn.Text = "Về Vị Trí Saved"
                return
            end
            local rp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if rp then
                rp.CFrame = CFrame.new(savedPos + Vector3.new(0, 3, 0))
            end
        end
    },
    {
        Text = "Tele Chỉ Tay",
        Callback = function()
            local ch = p.Character
            local rp = ch and ch:FindFirstChild("HumanoidRootPart")
            if not rp then return end
            local c = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
            local ray = cam:ViewportPointToRay(c.X, c.Y)
            local rp2 = RaycastParams.new()
            rp2.FilterDescendantsInstances = {ch}
            rp2.FilterType = Enum.RaycastFilterType.Exclude
            local res = workspace:Raycast(ray.Origin, ray.Direction * 1000, rp2)
            if res then rp.CFrame = CFrame.new(res.Position + Vector3.new(0, 3, 0)) end
        end
    }
})

-- EXTERNAL CONTROLS (Open VIP Icon & Fly Buttons)
local openBtn = Instance.new("TextButton", g)
openBtn.Size = UDim2.new(0, 48, 0, 48)
openBtn.Position = UDim2.new(0, 16, 0.4, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(18, 20, 32)
openBtn.Text = "👑 VIP"
openBtn.TextColor3 = Color3.fromRGB(0, 229, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 12
openBtn.Visible = false
openBtn.Active = true
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

local openStroke = Instance.new("UIStroke", openBtn)
openStroke.Thickness = 2
openStroke.Color = Color3.fromRGB(120, 50, 255)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

-- Flying Controls Buttons
local upBtn = Instance.new("TextButton", g)
upBtn.Size = UDim2.new(0, 46, 0, 46)
upBtn.Position = UDim2.new(1, -65, 0.5, -50)
upBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
upBtn.Text = "▲"
upBtn.TextColor3 = Color3.fromRGB(0, 229, 255)
upBtn.Font = Enum.Font.GothamBold
upBtn.TextSize = 18
upBtn.Visible = false
Instance.new("UICorner", upBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", upBtn).Color = Color3.fromRGB(0, 229, 255)

local dnBtn = Instance.new("TextButton", g)
dnBtn.Size = UDim2.new(0, 46, 0, 46)
dnBtn.Position = UDim2.new(1, -65, 0.5, 10)
dnBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
dnBtn.Text = "▼"
dnBtn.TextColor3 = Color3.fromRGB(255, 60, 100)
dnBtn.Font = Enum.Font.GothamBold
dnBtn.TextSize = 18
dnBtn.Visible = false
Instance.new("UICorner", dnBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", dnBtn).Color = Color3.fromRGB(255, 60, 100)

upBtn.MouseButton1Down:Connect(function() upS = 1 end)
upBtn.MouseButton1Up:Connect(function() upS = 0 end)
dnBtn.MouseButton1Down:Connect(function() dnS = 1 end)
dnBtn.MouseButton1Up:Connect(function() dnS = 0 end)

-- UI DRAG SYSTEM
local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
track(UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end))
track(UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end))

-- UI RESIZE HANDLE
local resizeHandle = Instance.new("TextButton", mainFrame)
resizeHandle.Size = UDim2.new(0, 16, 0, 16)
resizeHandle.Position = UDim2.new(1, -16, 1, -16)
resizeHandle.BackgroundTransparency = 1
resizeHandle.Text = "◢"
resizeHandle.TextColor3 = Color3.fromRGB(120, 50, 255)
resizeHandle.TextSize = 12
resizeHandle.Font = Enum.Font.GothamBold

local resizing, resizeStart, startScale = false, nil, 1
resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        startScale = uiscale.Scale
    end
end)
track(UIS.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStart
        local deltaAvg = (delta.X + delta.Y) / 2
        uiscale.Scale = math.clamp(startScale + deltaAvg / 300, 0.5, 1.8)
    end
end))
track(UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end))

--====================================================
-- 🔄 MAIN LOOP & EVENT HANDLERS
--====================================================

track(RunService.RenderStepped:Connect(function()
    local ch = p.Character
    if not ch then return end
    local h = ch:FindFirstChildOfClass("Humanoid")
    local rp = ch:FindFirstChild("HumanoidRootPart")
    if not h or not rp then return end

    if Config.Noclip then
        for _, pt in pairs(ch:GetDescendants()) do
            if pt:IsA("BasePart") then pt.CanCollide = false end
        end
    end

    local vel = rp.AssemblyLinearVelocity
    if vel.Y < -60 then rp.AssemblyLinearVelocity = Vector3.new(vel.X, -60, vel.Z) end

    if rp.Position.Y < -5 then
        rp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        rp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        local rp3 = RaycastParams.new()
        rp3.FilterDescendantsInstances = {ch}
        rp3.FilterType = Enum.RaycastFilterType.Exclude
        local res = workspace:Raycast(Vector3.new(rp.Position.X, 500, rp.Position.Z), Vector3.new(0, -2000, 0), rp3)
        if res then
            rp.CFrame = CFrame.new(res.Position + Vector3.new(0, 6, 0))
        elseif goodCam then
            rp.CFrame = CFrame.new(goodCam.Position) + Vector3.new(0, -3, 0)
        else
            rp.CFrame = CFrame.new(0, 50, 0)
        end
        rp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end

    if rp.Position.Y > -10 then goodCam = cam.CFrame end

    if Config.Lock and tgt and tgt.Root and tgt.Root.Parent then
        local myPos = rp.Position
        local targetPos = tgt.Root.Position
        local hd2 = Vector3.new(targetPos.X - myPos.X, 0, targetPos.Z - myPos.Z)
        if hd2.Magnitude < 1 then
            local lk = rp.CFrame.LookVector
            hd2 = Vector3.new(lk.X, 0, lk.Z)
            if hd2.Magnitude < 0.1 then hd2 = Vector3.new(0, 0, 1) end
        end
        hd2 = hd2.Unit
        local camPos = myPos - hd2 * 12 + Vector3.new(0, 4, 0)
        local head = tgt.Char and tgt.Char:FindFirstChild("Head")
        local lookAt = head and head.Position or targetPos
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(camPos, lookAt), 0.35)
    else
        if rp.Position.Y < -10 and goodCam then cam.CFrame = goodCam end
    end

    if Config.ESP then
        for _, pl in pairs(Players:GetPlayers()) do
            if pl ~= p and pl.Character then
                local char = pl.Character
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local head = char:FindFirstChild("Head")
                if humanoid and head then
                    if not espGuis[pl] or espGuis[pl].Char ~= char then
                        removeESP(pl)
                        createESP(pl)
                    end
                    local data = espGuis[pl]
                    if data then
                        local health = humanoid.Health
                        local maxHealth = humanoid.MaxHealth
                        local ratio = maxHealth > 0 and (health / maxHealth) or 0
                        data.HealthFill.Size = UDim2.new(ratio, 0, 1, 0)
                        data.HealthFill.BackgroundColor3 = Color3.fromHSV(ratio * 0.33, 1, 1)
                        data.HealthText.Text = math.floor(health) .. " / " .. math.floor(maxHealth)
                    end
                else
                    removeESP(pl)
                end
            else
                removeESP(pl)
            end
        end
    else
        if next(espGuis) then clearESP() end
    end
end))

track(RunService.Heartbeat:Connect(function()
    local ch = p.Character
    if not ch then return end
    local h = ch:FindFirstChildOfClass("Humanoid")
    local rp = ch:FindFirstChild("HumanoidRootPart")
    if not h or not rp then return end

    if Config.Fly and flyBV and flyBG then
        if not h.PlatformStand then h.PlatformStand = true end
        local md = h.MoveDirection
        local hm = Vector3.new(md.X, 0, md.Z)
        if hm.Magnitude > 0 then hm = hm.Unit * Config.FlySpeed end
        local u = (upS == 1 or UIS:IsKeyDown(Enum.KeyCode.Space)) and Config.FlySpeed or 0
        local d = (dnS == 1 or UIS:IsKeyDown(Enum.KeyCode.LeftControl)) and Config.FlySpeed or 0
        flyBV.Velocity = hm + Vector3.new(0, u - d, 0)
        if hm.Magnitude > 0 then flyBG.CFrame = CFrame.new(rp.Position, rp.Position + hm) end
    end

    if Config.Fast then
        h.WalkSpeed = Config.RunSpeed
    else
        if h.WalkSpeed == Config.RunSpeed then h.WalkSpeed = 16 end
    end
end))

track(p.CharacterAdded:Connect(function(c)
    c:WaitForChild("Humanoid")
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then h.PlatformStand = false end
    Config.Lock, Config.Fly, Config.Fast, Config.Noclip = false, false, false, false
    flyBV, flyBG, tgt = nil, nil, nil
    goodCam = nil
    upBtn.Visible = false
    dnBtn.Visible = false
end))

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "👑 VIP CYBER PAID",
        Text = "Giao diện Premium đã sẵn sàng!",
        Duration = 5
    })
end)
