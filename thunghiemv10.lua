--[[
========================================
 VIP CYBER + SMART AUTO ESCAPE TELEPORT
 Combined Edition v1.0
 By Em 💕
========================================
]]

--========================================
-- SERVICES
--========================================
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

--========================================
-- CLEANUP
--========================================
if _G.__COMBINED_CLEANUP then pcall(_G.__COMBINED_CLEANUP) end
local conns = {}
local function track(c) table.insert(conns, c); return c end
_G.__COMBINED_CLEANUP = function()
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    conns = {}
    local old = pg:FindFirstChild("VipMenu")
    if old then old:Destroy() end
end
local oldMenu = pg:FindFirstChild("VipMenu")
if oldMenu then oldMenu:Destroy() end

--========================================
-- CONFIG
--========================================
local Config = {
    -- Movement
    Lock = false,
    Fly = false,
    Fast = false,
    Noclip = false,
    ESP = false,
    -- Speeds
    RunSpeed = 50,
    FlySpeed = 60,
    -- Auto Escape
    AutoEscapeEnabled = true,
    SmartModeEnabled = true,
    SmartThreshold = 0.01,
    PredictiveEnabled = true,
    PredictiveRange = 30,
    TeleportDistance = 50,
    SoundEnabled = true,
}

--========================================
-- VARIABLES
--========================================
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

--========================================
-- SOUND IDS
--========================================
local SOUND_RIFT  = "rbxassetid://1838218402"
local SOUND_GLASS = "rbxassetid://5152763850"
local SOUND_TELE  = "rbxassetid://6042053626"

local function playSoundAt(soundId, position, volume, pitch)
    if not Config.SoundEnabled then return end
    pcall(function()
        local sp = Instance.new("Part")
        sp.Anchored = true
        sp.CanCollide = false
        sp.Transparency = 1
        sp.Size = Vector3.new(1,1,1)
        sp.CFrame = CFrame.new(position)
        sp.Parent = workspace

        local s = Instance.new("Sound")
        s.SoundId = soundId
        s.Volume = volume or 1
        s.PlaybackSpeed = pitch or 1
        s.RollOffMaxDistance = 300
        s.RollOffMinDistance = 5
        s.Parent = sp
        s:Play()
        Debris:AddItem(sp, 8)
    end)
end

local function playSoundLocal(soundId, volume, pitch)
    if not Config.SoundEnabled then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = soundId
        s.Volume = volume or 1
        s.PlaybackSpeed = pitch or 1
        s.Parent = SoundService
        s:Play()
        Debris:AddItem(s, 8)
    end)
end

--========================================
-- SPACE TEAR EFFECTS
--========================================
local function createStars(position, radius)
    for i = 1, 30 do
        local star = Instance.new("Part")
        star.Shape = Enum.PartType.Ball
        star.Size = Vector3.new(0.6, 0.6, 0.6)
        star.Anchored = true
        star.CanCollide = false
        star.CanTouch = false
        star.CanQuery = false
        star.Material = Enum.Material.Neon
        star.Color = Color3.fromRGB(255, 255, 255)
        star.CFrame = CFrame.new(position + Vector3.new(
            math.random(-radius, radius),
            math.random(-radius, radius),
            math.random(-radius, radius)
        ))
        star.Parent = workspace

        local light = Instance.new("PointLight", star)
        light.Color = Color3.fromRGB(255, 220, 150)
        light.Range = 6
        light.Brightness = 5

        TweenService:Create(star, TweenInfo.new(1.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = star.Position + Vector3.new(math.random(-15,15), math.random(10,22), math.random(-15,15)),
            Transparency = 1,
            Size = Vector3.new(0,0,0)
        }):Play()
        Debris:AddItem(star, 1.5)
    end
end

local function createGlassBreak(position)
    playSoundAt(SOUND_GLASS, position, 1, 1)

    for i = 1, 60 do
        local shard = Instance.new("Part")
        shard.Size = Vector3.new(math.random(2,9), math.random(2,9), math.random(2,9))
        shard.Anchored = true
        shard.CanCollide = false
        shard.CanTouch = false
        shard.CanQuery = false
        shard.Material = Enum.Material.Glass
        local colors = {
            Color3.fromRGB(230, 240, 255),
            Color3.fromRGB(200, 180, 255),
            Color3.fromRGB(180, 220, 255),
        }
        shard.Color = colors[math.random(1, #colors)]
        shard.Transparency = 0.1
        shard.Reflectance = 0.4
        shard.CFrame = CFrame.new(position) * CFrame.Angles(
            math.random(0,360), math.random(0,360), math.random(0,360)
        )
        shard.Parent = workspace

        local dir = Vector3.new(math.random(-55,55), math.random(-30,55), math.random(-55,55))
        TweenService:Create(shard, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = position + dir,
            Transparency = 1,
            Size = Vector3.new(0.1, 0.1, 0.1)
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

    -- Lõi đen
    local voidCore = Instance.new("Part")
    voidCore.Name = "VoidCore"
    voidCore.Shape = Enum.PartType.Cylinder
    voidCore.Size = Vector3.new(0.6, 11, 11)
    voidCore.Anchored = true
    voidCore.CanCollide = false
    voidCore.CanTouch = false
    voidCore.CanQuery = false
    voidCore.Material = Enum.Material.Neon
    voidCore.Color = Color3.fromRGB(2, 0, 5)
    voidCore.CFrame = cf * rot90
    voidCore.Parent = workspace

    local voidLight = Instance.new("PointLight", voidCore)
    voidLight.Color = Color3.fromRGB(150, 0, 255)
    voidLight.Range = 35
    voidLight.Brightness = 12

    -- Lõi tím
    local purpleCore = Instance.new("Part")
    purpleCore.Shape = Enum.PartType.Cylinder
    purpleCore.Size = Vector3.new(0.9, 12.5, 12.5)
    purpleCore.Anchored = true
    purpleCore.CanCollide = false
    purpleCore.CanTouch = false
    purpleCore.CanQuery = false
    purpleCore.Material = Enum.Material.Neon
    purpleCore.Color = Color3.fromRGB(120, 30, 200)
    purpleCore.Transparency = 0.3
    purpleCore.CFrame = cf * rot90
    purpleCore.Parent = workspace

    -- Viền trắng
    local outline = Instance.new("Part")
    outline.Shape = Enum.PartType.Cylinder
    outline.Size = Vector3.new(1.1, 14, 14)
    outline.Anchored = true
    outline.CanCollide = false
    outline.CanTouch = false
    outline.CanQuery = false
    outline.Material = Enum.Material.SmoothPlastic
    outline.Color = Color3.fromRGB(240, 240, 255)
    outline.Transparency = 0.1
    outline.CFrame = cf * rot90
    outline.Parent = workspace

    -- Tia sét tím
    for i = 1, 14 do
        local bolt = Instance.new("Part")
        bolt.Shape = Enum.PartType.Cylinder
        bolt.Size = Vector3.new(0.25, math.random(8, 18), 0.25)
        bolt.Anchored = true
        bolt.CanCollide = false
        bolt.CanTouch = false
        bolt.Material = Enum.Material.Neon
        bolt.Color = Color3.fromRGB(200, 100, 255)
        bolt.Transparency = 0.05
        bolt.CFrame = cf * rot90 * CFrame.Angles(
            math.random(-45, 45), math.random(-45, 45), math.random(-45, 45)
        )
        bolt.Parent = workspace
        Debris:AddItem(bolt, 1.5)

        TweenService:Create(bolt, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(0.1, math.random(18, 28), 0.1),
            Transparency = 1
        }):Play()
    end

    -- Tia sét đỏ
    for i = 1, 8 do
        local redBolt = Instance.new("Part")
        redBolt.Shape = Enum.PartType.Cylinder
        redBolt.Size = Vector3.new(0.2, math.random(6, 12), 0.2)
        redBolt.Anchored = true
        redBolt.CanCollide = false
        redBolt.CanTouch = false
        redBolt.Material = Enum.Material.Neon
        redBolt.Color = Color3.fromRGB(255, 40, 40)
        redBolt.Transparency = 0.1
        redBolt.CFrame = cf * rot90 * CFrame.Angles(
            math.random(-60, 60), math.random(-60, 60), math.random(-60, 60)
        )
        redBolt.Parent = workspace
        Debris:AddItem(redBolt, 1.2)

        TweenService:Create(redBolt, TweenInfo.new(0.6), {
            Size = Vector3.new(0, 0, 0),
            Transparency = 1
        }):Play()
    end

    -- Vòng xoáy
    for i = 1, 2 do
        local ring = Instance.new("Part")
        ring.Shape = Enum.PartType.Cylinder
        ring.Size = Vector3.new(0.15, 8, 8)
        ring.Anchored = true
        ring.CanCollide = false
        ring.CanTouch = false
        ring.Material = Enum.Material.Neon
        ring.Color = i == 1 and Color3.fromRGB(180, 60, 255) or Color3.fromRGB(255, 100, 200)
        ring.Transparency = 0.2
        ring.CFrame = cf * rot90 * CFrame.Angles(0, 0, math.rad(i * 45))
        ring.Parent = workspace
        Debris:AddItem(ring, 1.5)

        TweenService:Create(ring, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(0.15, 30, 30),
            Transparency = 1
        }):Play()
    end

    -- Sóng xung kích
    local shockwave = Instance.new("Part")
    shockwave.Shape = Enum.PartType.Cylinder
    shockwave.Size = Vector3.new(0.3, 2, 2)
    shockwave.Anchored = true
    shockwave.CanCollide = false
    shockwave.CanTouch = false
    shockwave.Material = Enum.Material.Neon
    shockwave.Color = Color3.fromRGB(255, 255, 255)
    shockwave.Transparency = 0.1
    shockwave.CFrame = cf * rot90
    shockwave.Parent = workspace
    TweenService:Create(shockwave, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.3, 40, 40),
        Transparency = 1
    }):Play()
    Debris:AddItem(shockwave, 1)

    -- Hạt sáng
    local dustAttach = Instance.new("Attachment", voidCore)
    local dust = Instance.new("ParticleEmitter", dustAttach)
    dust.Texture = "rbxassetid://243660364"
    dust.Color = ColorSequence.new(Color3.fromRGB(180, 60, 255))
    dust.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 4),
        NumberSequenceKeypoint.new(0.5, 2),
        NumberSequenceKeypoint.new(1, 0)
    })
    dust.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 0.8)
    })
    dust.Lifetime = NumberRange.new(0.6, 1.2)
    dust.Rate = 200
    dust.Speed = NumberRange.new(25, 40)
    dust.SpreadAngle = Vector2.new(180, 180)
    dust.LightEmission = 1
    dust.Acceleration = Vector3.new(0, -50, 0)

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
        dust.Enabled = false
        Debris:AddItem(voidCore, 0.8)
        Debris:AddItem(purpleCore, 0.8)
        Debris:AddItem(outline, 0.8)
    end)
end

--========================================
-- DO TELEPORT (LÙI)
--========================================
local function doTeleport(reason)
    if isEscaping then return end
    if not Root or not Root.Parent then return end

    isEscaping = true

    local oldPosition = Root.Position
    local oldLook = Root.CFrame.LookVector

    playSoundLocal(SOUND_TELE, 1, 1.2)
    createSpaceTear(oldPosition, oldLook)

    local escapeCFrame = Root.CFrame * CFrame.new(0, 0, Config.TeleportDistance)
    local newPosition = escapeCFrame.Position

    pcall(function()
        Root.CFrame = escapeCFrame
    end)

    task.delay(0.1, function()
        if Root and Root.Parent then
            createStars(Root.Position, 10)
        end
    end)

    task.wait(0.2)
    isEscaping = false
end

--========================================
-- AUTO ESCAPE (HEALTH)
--========================================
local function setupAutoEscape()
    if not Humanoid or not Root then return end
    if HealthConn then HealthConn:Disconnect() end

    local lastHealth = Humanoid.Health

    HealthConn = Humanoid.HealthChanged:Connect(function(newHealth)
        if not Config.AutoEscapeEnabled then return end
        if isEscaping then return end

        local oldHealth = lastHealth
        lastHealth = newHealth
        local damage = oldHealth - newHealth

        local shouldTeleport = true
        if Config.SmartModeEnabled then
            shouldTeleport = (damage >= Config.SmartThreshold)
        end

        if damage > 0 and shouldTeleport then
            doTeleport("Damage")
        end
    end)
end

--========================================
-- PREDICTIVE
--========================================
local function setupPredictive()
    if not Root then return end
    if PredictiveConn then PredictiveConn:Disconnect() end

    PredictiveConn = RunService.Heartbeat:Connect(function()
        if not Config.AutoEscapeEnabled then return end
        if not Config.PredictiveEnabled then return end
        if isEscaping then return end
        if not Root or not Root.Parent then return end

        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= p then
                local otherChar = otherPlayer.Character
                if otherChar then
                    local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")
                    local otherHum = otherChar:FindFirstChildOfClass("Humanoid")

                    if otherRoot and otherHum and otherHum.Health > 0 then
                        local dist = (otherRoot.Position - Root.Position).Magnitude

                        if dist <= Config.PredictiveRange then
                            local animator = otherHum:FindFirstChildOfClass("Animator")
                            if animator then
                                for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
                                    local animName = ""
                                    pcall(function()
                                        animName = string.lower(tr.Animation.Name)
                                    end)

                                    if string.find(animName, "skill")
                                    or string.find(animName, "combo")
                                    or string.find(animName, "ultimate")
                                    or string.find(animName, "special")
                                    or string.find(animName, "attack")
                                    or string.find(animName, "punch")
                                    or string.find(animName, "kick")
                                    or string.find(animName, "smash")
                                    or string.find(animName, "serious")
                                    or string.find(animName, "heavy") then

                                        local isIdle = string.find(animName, "idle")
                                            or string.find(animName, "walk")
                                            or string.find(animName, "run")
                                            or string.find(animName, "jump")
                                            or string.find(animName, "fall")

                                        if not isIdle then
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
        end
    end)
end

--========================================
-- SETUP CHARACTER
--========================================
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

--========================================
-- ESP FUNCTIONS
--========================================
local function createESP(pl)
    local char = pl.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not head or not humanoid then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_"..pl.Name
    billboard.Size = UDim2.new(0, 120, 0, 45)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = head
    billboard.Parent = head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0,16)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = pl.Name
    nameLabel.TextColor3 = Color3.fromRGB(0,255,255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 12
    nameLabel.Parent = billboard

    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(1, -20, 0, 8)
    healthBg.Position = UDim2.new(0, 10, 0, 18)
    healthBg.BackgroundColor3 = Color3.fromRGB(30,30,30)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = billboard
    Instance.new("UICorner", healthBg).CornerRadius = UDim.new(0,4)

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1,0,1,0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0,255,0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg
    Instance.new("UICorner", healthFill).CornerRadius = UDim.new(0,4)

    local healthText = Instance.new("TextLabel")
    healthText.Size = UDim2.new(1,0,0,12)
    healthText.Position = UDim2.new(0,0,0,28)
    healthText.BackgroundTransparency = 1
    healthText.TextColor3 = Color3.fromRGB(255,255,255)
    healthText.TextStrokeTransparency = 0
    healthText.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    healthText.Font = Enum.Font.GothamBold
    healthText.TextSize = 10
    healthText.Parent = billboard

    espGuis[pl] = {Gui = billboard, Char = char, NameLabel = nameLabel, HealthFill = healthFill, HealthText = healthText}
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

--========================================
-- FIND TARGET
--========================================
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

--========================================
-- MENU UI (LED RAINBOW)
--========================================
local menuMinY = 10
local menuH = 290
local menuW = 190
local menuOn = true

local g = Instance.new("ScreenGui")
g.Name = "VipMenu"
g.ResetOnSpawn = false
g.Parent = pg

local rainbowSeq = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,0,0)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255,165,0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255,255,0)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,255,0)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,150,255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75,0,180)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,0,150)),
})

local ledElements = {}

-- Khung chính
local f = Instance.new("Frame", g)
f.Size = UDim2.new(0, menuW, 0, menuH)
f.Position = UDim2.new(0, 8, 0, menuMinY)
f.BackgroundColor3 = Color3.fromRGB(12,12,22)
f.BorderSizePixel = 0
f.ZIndex = 1
f.Active = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0,12)

-- Viền LED rainbow
local borderFrame = Instance.new("Frame", f)
borderFrame.Size = UDim2.new(1, 10, 1, 10)
borderFrame.Position = UDim2.new(0, -5, 0, -5)
borderFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
borderFrame.BorderSizePixel = 0
borderFrame.ZIndex = 0
borderFrame.Active = false
Instance.new("UICorner", borderFrame).CornerRadius = UDim.new(0, 16)
local borderGrad = Instance.new("UIGradient", borderFrame)
borderGrad.Color = rainbowSeq

local borderAngle = 0
track(RunService.RenderStepped:Connect(function(dt)
    borderAngle = (borderAngle + dt * 90) % 360
    borderGrad.Rotation = borderAngle
end))

local bgGrad = Instance.new("UIGradient", f)
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8,8,15)),
})
bgGrad.Rotation = 45

-- Header
local hd = Instance.new("Frame", f)
hd.Size = UDim2.new(1, 0, 0, 28)
hd.BackgroundColor3 = Color3.fromRGB(20,20,40)
hd.BorderSizePixel = 0
hd.ZIndex = 2
hd.Active = true
Instance.new("UICorner", hd).CornerRadius = UDim.new(0,12)
local hdCover = Instance.new("Frame", hd)
hdCover.Size = UDim2.new(1, 0, 0.5, 0)
hdCover.Position = UDim2.new(0, 0, 0.5, 0)
hdCover.BackgroundColor3 = Color3.fromRGB(20,20,40)
hdCover.BorderSizePixel = 0
hdCover.ZIndex = 2
hdCover.Active = false

local title = Instance.new("TextLabel", hd)
title.Size = UDim2.new(1, -56, 1, 0)
title.BackgroundTransparency = 1
title.Text = "VIP CYBER"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.ZIndex = 3
title.Active = false
table.insert(ledElements, title)

local colBtn = Instance.new("TextButton", hd)
colBtn.Size = UDim2.new(0, 22, 0, 22)
colBtn.Position = UDim2.new(1, -52, 0, 3)
colBtn.BackgroundColor3 = Color3.fromRGB(35,40,60)
colBtn.Text = "-"
colBtn.TextColor3 = Color3.fromRGB(255,255,255)
colBtn.Font = Enum.Font.GothamBold
colBtn.TextSize = 14
colBtn.ZIndex = 3
colBtn.Active = true
Instance.new("UICorner", colBtn).CornerRadius = UDim.new(1,0)
table.insert(ledElements, colBtn)

local closeBtn = Instance.new("TextButton", hd)
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -27, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.ZIndex = 10
closeBtn.Active = true
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

local cont = Instance.new("Frame", f)
cont.Size = UDim2.new(1, 0, 1, -28)
cont.Position = UDim2.new(0, 0, 0, 28)
cont.BackgroundTransparency = 1
cont.Active = false

local hide = {}

local function mk(txt, x, y, w)
    local b = Instance.new("TextButton", cont)
    b.Size = UDim2.new(0, w, 0, 22)
    b.Position = UDim2.new(0, x, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(35,35,55)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(0,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 9
    b.TextWrapped = true
    b.Active = true
    b.ZIndex = 2
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    local bStroke = Instance.new("UIStroke", b)
    bStroke.Thickness = 1.5
    bStroke.Color = Color3.fromRGB(0,200,255)
    bStroke.Transparency = 0.4
    table.insert(ledElements, b)
    table.insert(ledElements, bStroke)
    table.insert(hide, b)
    return b
end

-- LAYOUT MỚI THEO YÊU CẦU ANH:
-- Hàng 1: Lock On | Lưu Điểm
local bLock = mk("Lock On: TAT", 6, 4, 87)
local bSave = mk("Luu Diem", 97, 4, 87)

-- Hàng 2: Chạy Nhanh | Về Điểm
local bFast = mk("Chay Nhanh: TAT", 6, 30, 87)
local bBack = mk("Ve Diem", 97, 30, 87)

-- Hàng 3: Bay | Xuyên Map
local bFly = mk("Bay: TAT", 6, 56, 87)
local bNoclip = mk("Xuyen Map: TAT", 97, 56, 87)

-- Hàng 4: Dịch Chuyển | ESP
local bTp = mk("Dich Chuyen", 6, 82, 87)
local bESP = mk("ESP: TAT", 97, 82, 87)

-- Hàng 5: Toggle Auto Escape
local bAutoEsc = mk("Auto Tele: BAT", 6, 108, 178)

local function set(b, on, onT, offT)
    b.Text = on and onT or offT
    b.BackgroundColor3 = on and Color3.fromRGB(0,150,60) or Color3.fromRGB(35,35,55)
end

-- Slider system
local activeSlider = nil
track(UIS.InputChanged:Connect(function(inp)
    if activeSlider and (inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch) then
        activeSlider(inp.Position.X)
    end
end))
track(UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
        activeSlider = nil
    end
end))

local function slider(label, y, min, max, init, cb)
    local lbl = Instance.new("TextLabel", cont)
    lbl.Size = UDim2.new(1, -12, 0, 14)
    lbl.Position = UDim2.new(0, 6, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = label .. ": " .. init
    lbl.TextColor3 = Color3.fromRGB(0,255,255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Active = false
    table.insert(ledElements, lbl)
    table.insert(hide, lbl)

    local tr = Instance.new("Frame", cont)
    tr.Size = UDim2.new(1, -12, 0, 12)
    tr.Position = UDim2.new(0, 6, 0, y + 16)
    tr.BackgroundColor3 = Color3.fromRGB(30,30,45)
    tr.BorderSizePixel = 0
    tr.Active = true
    tr.ZIndex = 2
    Instance.new("UICorner", tr).CornerRadius = UDim.new(0,6)

    local trStroke = Instance.new("UIStroke", tr)
    trStroke.Thickness = 2
    trStroke.Color = Color3.fromRGB(0,200,255)
    trStroke.Transparency = 0.2
    table.insert(ledElements, trStroke)
    table.insert(hide, tr)

    local fill = Instance.new("Frame", tr)
    fill.Size = UDim2.new((init-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0,200,255)
    fill.BorderSizePixel = 0
    fill.Active = false
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,6)
    table.insert(ledElements, fill)

    local hd2 = Instance.new("TextButton", tr)
    hd2.Size = UDim2.new(0, 16, 0, 16)
    hd2.Position = UDim2.new((init-min)/(max-min), -8, 0.5, -8)
    hd2.BackgroundColor3 = Color3.fromRGB(255,255,255)
    hd2.Text = ""
    hd2.Active = true
    hd2.ZIndex = 3
    Instance.new("UICorner", hd2).CornerRadius = UDim.new(1,0)

    local hdStroke = Instance.new("UIStroke", hd2)
    hdStroke.Thickness = 2
    hdStroke.Color = Color3.fromRGB(0,255,255)
    table.insert(ledElements, hdStroke)

    local function updateFromInput(inputX)
        local ta = tr.AbsolutePosition.X
        local tw = tr.AbsoluteSize.X
        if tw <= 0 then return end
        local r = math.clamp((inputX - ta) / tw, 0, 1)
        local v = math.floor(min + r * (max - min))
        fill.Size = UDim2.new(r, 0, 1, 0)
        hd2.Position = UDim2.new(r, -8, 0.5, -8)
        lbl.Text = label .. ": " .. v
        cb(v)
    end

    hd2.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            activeSlider = updateFromInput
        end
    end)
    tr.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            updateFromInput(inp.Position.X)
            activeSlider = updateFromInput
        end
    end)
end

-- SLIDERS
slider("Toc do chay", 136, 16, 200, 50, function(v) Config.RunSpeed = v end)
slider("Toc do bay", 172, 20, 300, 60, function(v) Config.FlySpeed = v end)
slider("Pham vi tele", 208, 10, 200, 50, function(v) Config.TeleportDistance = v end)

-- Open button (khi minimize)
local openBtn = Instance.new("TextButton", g)
openBtn.Size = UDim2.new(0, 44, 0, 44)
openBtn.Position = UDim2.new(0, 8, 0, menuMinY)
openBtn.BackgroundColor3 = Color3.fromRGB(20,20,40)
openBtn.Text = "VIP"
openBtn.TextColor3 = Color3.fromRGB(0,255,255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 11
openBtn.Visible = false
openBtn.Active = true
openBtn.ZIndex = 10
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)
local obStroke = Instance.new("UIStroke", openBtn)
obStroke.Thickness = 2
obStroke.Color = Color3.fromRGB(0,255,255)
table.insert(ledElements, openBtn)
table.insert(ledElements, obStroke)

-- Fly buttons
local upBtn = Instance.new("TextButton", g)
upBtn.Size = UDim2.new(0, 44, 0, 44)
upBtn.Position = UDim2.new(1, -64, 0.5, 30)
upBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
upBtn.Text = "^"
upBtn.TextColor3 = Color3.fromRGB(255,255,255)
upBtn.Font = Enum.Font.GothamBold
upBtn.TextSize = 20
upBtn.Visible = false
upBtn.Active = true
Instance.new("UICorner", upBtn).CornerRadius = UDim.new(1,0)

local dnBtn = Instance.new("TextButton", g)
dnBtn.Size = UDim2.new(0, 44, 0, 44)
dnBtn.Position = UDim2.new(1, -64, 0.5, 84)
dnBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
dnBtn.Text = "v"
dnBtn.TextColor3 = Color3.fromRGB(255,255,255)
dnBtn.Font = Enum.Font.GothamBold
dnBtn.TextSize = 20
dnBtn.Visible = false
dnBtn.Active = true
Instance.new("UICorner", dnBtn).CornerRadius = UDim.new(1,0)

upBtn.MouseButton1Down:Connect(function() upS = 1 end)
upBtn.MouseButton1Up:Connect(function() upS = 0 end)
upBtn.MouseLeave:Connect(function() upS = 0 end)
dnBtn.MouseButton1Down:Connect(function() dnS = 1 end)
dnBtn.MouseButton1Up:Connect(function() dnS = 0 end)
dnBtn.MouseLeave:Connect(function() dnS = 0 end)

-- Drag menu
local dragging = false
local dragStart = nil
local startPos = nil

local function isButton(obj)
    while obj do
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then return true end
        obj = obj.Parent
    end
    return false
end

hd.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not isButton(input.Target) then
            dragging = true
            dragStart = input.Position
            startPos = f.Position
        end
    end
end)
track(UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        f.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end))
track(UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end))

-- Rainbow text
local textHue = 0
track(RunService.RenderStepped:Connect(function(dt)
    textHue = (textHue + dt * 0.3) % 1
    local c = Color3.fromHSV(textHue, 0.8, 1)
    for _, obj in ipairs(ledElements) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            obj.TextColor3 = c
        elseif obj:IsA("UIStroke") then
            obj.Color = c
        elseif obj:IsA("Frame") then
            obj.BackgroundColor3 = c
        end
    end
end))

closeBtn.MouseButton1Click:Connect(function()
    menuOn = false
    f.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    menuOn = true
    f.Visible = true
    openBtn.Visible = false
end)

local collapsed = false
colBtn.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    if collapsed then
        f.Size = UDim2.new(0, menuW, 0, 28)
        colBtn.Text = "+"
        for _, obj in ipairs(hide) do
            if obj:IsA("GuiObject") then obj.Visible = false end
        end
    else
        f.Size = UDim2.new(0, menuW, 0, menuH)
        colBtn.Text = "-"
        for _, obj in ipairs(hide) do
            if obj:IsA("GuiObject") then obj.Visible = true end
        end
    end
end)

--========================================
-- BUTTON EVENTS
--========================================
bLock.MouseButton1Click:Connect(function()
    Config.Lock = not Config.Lock
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
                    set(bLock, false, "Lock On: BAT", "Lock On: TAT")
                    cam.CameraType = Enum.CameraType.Custom
                    local mh = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                    if mh then cam.CameraSubject = mh end
                    tgt = nil
                end)
                set(bLock, true, "Lock On: BAT", "Lock On: TAT")
                cam.CameraType = Enum.CameraType.Scriptable
            end
        else
            Config.Lock = false
            set(bLock, false, "Lock On: BAT", "Lock On: TAT")
        end
    else
        set(bLock, false, "Lock On: BAT", "Lock On: TAT")
        if diedConn then diedConn:Disconnect() diedConn = nil end
        tgt = nil
        cam.CameraType = Enum.CameraType.Custom
        local mh = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
        if mh then cam.CameraSubject = mh end
    end
end)

bFly.MouseButton1Click:Connect(function()
    Config.Fly = not Config.Fly
    local ch = p.Character
    local h = ch and ch:FindFirstChildOfClass("Humanoid")
    if Config.Fly then
        set(bFly, true, "Bay: BAT", "Bay: TAT")
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
        set(bFly, false, "Bay: BAT", "Bay: TAT")
        if h then h.PlatformStand = false end
        if flyBV then flyBV:Destroy() flyBV = nil end
        if flyBG then flyBG:Destroy() flyBG = nil end
        upBtn.Visible = false
        dnBtn.Visible = false
    end
end)

bFast.MouseButton1Click:Connect(function()
    Config.Fast = not Config.Fast
    set(bFast, Config.Fast, "Chay Nhanh: BAT", "Chay Nhanh: TAT")
end)

bNoclip.MouseButton1Click:Connect(function()
    Config.Noclip = not Config.Noclip
    set(bNoclip, Config.Noclip, "Xuyen Map: BAT", "Xuyen Map: TAT")
end)

bTp.MouseButton1Click:Connect(function()
    local now = os.clock()
    if now - lastTp < 0.1 then return end
    lastTp = now
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
end)

bSave.MouseButton1Click:Connect(function()
    local ch = p.Character
    local rp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not rp then return end
    savedPos = rp.Position
    bSave.Text = "Da luu!"
    task.wait(1.5)
    bSave.Text = "Luu Diem"
end)

bBack.MouseButton1Click:Connect(function()
    if not savedPos then
        bBack.Text = "Chua luu!"
        task.wait(1.5)
        bBack.Text = "Ve Diem"
        return
    end
    local ch = p.Character
    local rp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not rp then return end
    rp.CFrame = CFrame.new(savedPos + Vector3.new(0, 3, 0))
    bBack.Text = "Da ve!"
    task.wait(1)
    bBack.Text = "Ve Diem"
end)

bESP.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    set(bESP, Config.ESP, "ESP: BAT", "ESP: TAT")
    if not Config.ESP then clearESP() end
end)

bAutoEsc.MouseButton1Click:Connect(function()
    Config.AutoEscapeEnabled = not Config.AutoEscapeEnabled
    set(bAutoEsc, Config.AutoEscapeEnabled, "Auto Tele: BAT", "Auto Tele: TAT")
end)

--========================================
-- MAIN LOOP
--========================================
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

    -- Lock on camera
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

    -- ESP update
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

--========================================
-- HEARTBEAT (FLY + SPEED)
--========================================
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

--========================================
-- RESET ON RESPAWN
--========================================
track(p.CharacterAdded:Connect(function(c)
    c:WaitForChild("Humanoid")
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then h.PlatformStand = false end
    Config.Lock, Config.Fly, Config.Fast, Config.Noclip = false, false, false, false
    set(bLock, false, "Lock On: BAT", "Lock On: TAT")
    set(bFly, false, "Bay: BAT", "Bay: TAT")
    set(bFast, false, "Chay Nhanh: BAT", "Chay Nhanh: TAT")
    set(bNoclip, false, "Xuyen Map: BAT", "Xuyen Map: TAT")
    flyBV, flyBG, tgt = nil, nil, nil
    goodCam = nil
    upBtn.Visible = false
    dnBtn.Visible = false
end))

--========================================
-- NOTIFICATION
--========================================
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "💜 VIP CYBER + AUTO TELE",
        Text = "Đã gộp 2 script - Menu LED gọn gàng!",
        Duration = 5
    })
end)

print("═══════════════════════════════════════════")
print("💜 VIP CYBER + SMART TELEPORT - LOADED!")
print("🎨 Giao diện LED rainbow")
print("🌌 Hiệu ứng xé không gian khi tele")
print("⚙️ Layout: Lock On / Lưu Điểm / Chạy Nhanh /")
print("         Về Điểm / Bay / Xuyên Map /")
print("         Dịch Chuyển / ESP / Auto Tele")
print("📏 Slider: Tốc chạy / Tốc bay / Phạm vi tele")
print("═══════════════════════════════════════════")
