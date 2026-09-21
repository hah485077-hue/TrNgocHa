--========================================
-- PURPLE MAGNETIC FIELD - TSB
-- Cosmic Garou Radiation Style
-- v1.0 | By Em 💕
--========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer

--========================================
-- CẤU HÌNH
--========================================
local Config = {
    FieldRadius = 15,
    FieldTransparency = 0.6,
    KnockbackForce = 180,
    RadiationDamage = 10,
    DamageInterval = 0.5,
    KnockbackEnabled = true,
    RadiationEnabled = true,
    SoundEnabled = true,
    Active = false
}

--========================================
-- BIẾN
--========================================
local Character, Humanoid, Root
local FieldSphere, ReflectionRing, ReflectionInner, FieldLight, FieldAttachment
local DamageConn, PulseConn
local knockbackCooldown = {}
local damageCooldown = {}

--========================================
-- ÂM THANH
--========================================
local SOUNDS = {
    On = "rbxassetid://1838218402",
    Hit = "rbxassetid://4612375231"
}

local function playSound(id, vol, pitch)
    if not Config.SoundEnabled then return end
    if not Root or not Root.Parent then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = vol or 1
        s.PlaybackSpeed = pitch or 1
        s.Parent = Root
        s:Play()
        Debris:AddItem(s, 5)
    end)
end

--========================================
-- TIA SÉT TÍM
--========================================
local function createLightning()
    if not Root or not Root.Parent then return end
    local attach = Instance.new("Attachment", Root)

    local p1 = Instance.new("ParticleEmitter", attach)
    p1.Texture = "rbxassetid://243660364"
    p1.Color = ColorSequence.new(Color3.fromRGB(180, 60, 255))
    p1.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(0.5, 2),
        NumberSequenceKeypoint.new(1, 0)
    })
    p1.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    p1.Lifetime = NumberRange.new(0.3, 0.6)
    p1.Rate = 25
    p1.Speed = NumberRange.new(15, 25)
    p1.SpreadAngle = Vector2.new(180, 180)
    p1.LightEmission = 1
    p1.LightInfluence = 0

    local p2 = Instance.new("ParticleEmitter", attach)
    p2.Texture = "rbxassetid://296874871"
    p2.Color = ColorSequence.new(Color3.fromRGB(220, 150, 255))
    p2.Size = NumberSequence.new(1.5)
    p2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
    p2.Lifetime = NumberRange.new(0.8, 1.5)
    p2.Rate = 40
    p2.Speed = NumberRange.new(5, 10)
    p2.SpreadAngle = Vector2.new(180, 180)
    p2.LightEmission = 1

    return attach
end

--========================================
-- KNOCKBACK
--========================================
local function knockbackPlayer(otherRoot)
    if not Config.KnockbackEnabled then return end
    if not Root or not Root.Parent then return end

    local otherPlayer = Players:GetPlayerFromCharacter(otherRoot.Parent)
    local key = otherPlayer and otherPlayer.UserId or otherRoot
    local now = tick()

    if knockbackCooldown[key] and now - knockbackCooldown[key] < 0.6 then return end
    knockbackCooldown[key] = now

    local dir = (otherRoot.Position - Root.Position)
    if dir.Magnitude < 0.1 then
        dir = Vector3.new(math.random(-1,1), 0.5, math.random(-1,1))
    end
    dir = Vector3.new(dir.X, 1, dir.Z).Unit

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = dir * Config.KnockbackForce
    bv.Parent = otherRoot
    Debris:AddItem(bv, 0.2)

    local fx = Instance.new("Part", workspace)
    fx.Shape = Enum.PartType.Ball
    fx.Size = Vector3.new(3, 3, 3)
    fx.Anchored = true
    fx.CanCollide = false
    fx.Material = Enum.Material.Neon
    fx.Color = Color3.fromRGB(180, 60, 255)
    fx.Transparency = 0.2
    fx.CFrame = CFrame.new(otherRoot.Position)
    TweenService:Create(fx, TweenInfo.new(0.4), {
        Size = Vector3.new(18, 18, 18),
        Transparency = 1
    }):Play()
    Debris:AddItem(fx, 0.5)

    playSound(SOUNDS.Hit, 0.6, 1.2)
end

--========================================
-- SÁT THƯƠNG PHÓNG XẠ (COSMIC GAROU)
--========================================
local function applyRadiation(otherHum)
    if not Config.RadiationEnabled then return end

    local char = otherHum.Parent
    local otherPlayer = Players:GetPlayerFromCharacter(char)
    local key = otherPlayer and otherPlayer.UserId or char
    local now = tick()

    if damageCooldown[key] and now - damageCooldown[key] < Config.DamageInterval then return end
    damageCooldown[key] = now

    pcall(function()
        otherHum:TakeDamage(Config.RadiationDamage)
    end)

    local otherRoot = char and char:FindFirstChild("HumanoidRootPart")
    if otherRoot then
        local attach = Instance.new("Attachment", otherRoot)
        local radP = Instance.new("ParticleEmitter", attach)
        radP.Texture = "rbxassetid://243660364"
        radP.Color = ColorSequence.new(Color3.fromRGB(120, 255, 120))
        radP.Size = NumberSequence.new(1.8)
        radP.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        radP.Lifetime = NumberRange.new(0.5, 1)
        radP.Rate = 40
        radP.Speed = NumberRange.new(5, 10)
        radP.SpreadAngle = Vector2.new(180, 180)
        radP.LightEmission = 1
        Debris:AddItem(attach, 0.6)
    end
end

--========================================
-- CẬP NHẬT VỊ TRÍ TỪ TRƯỜNG
--========================================
local function updateFieldPosition()
    if not Config.Active then return end
    if not Root or not Root.Parent then return end

    if FieldSphere and FieldSphere.Parent then
        FieldSphere.CFrame = Root.CFrame
    end
    if ReflectionRing and ReflectionRing.Parent then
        ReflectionRing.CFrame = CFrame.new(Root.Position.X, Root.Position.Y - 3, Root.Position.Z) * CFrame.Angles(0, 0, math.rad(90))
    end
    if ReflectionInner and ReflectionInner.Parent then
        ReflectionInner.CFrame = CFrame.new(Root.Position.X, Root.Position.Y - 3.1, Root.Position.Z) * CFrame.Angles(0, 0, math.rad(90))
    end
end

--========================================
-- TẠO TỪ TRƯỜNG
--========================================
local function createField()
    if Config.Active then return end
    if not Root or not Root.Parent then return end

    Config.Active = true
    playSound(SOUNDS.On, 0.9, 1)

    FieldSphere = Instance.new("Part")
    FieldSphere.Name = "PurpleField"
    FieldSphere.Shape = Enum.PartType.Ball
    FieldSphere.Size = Vector3.new(Config.FieldRadius * 2, Config.FieldRadius * 2, Config.FieldRadius * 2)
    FieldSphere.Anchored = true
    FieldSphere.CanCollide = false
    FieldSphere.CanTouch = false
    FieldSphere.CanQuery = false
    FieldSphere.Material = Enum.Material.ForceField
    FieldSphere.Color = Color3.fromRGB(180, 60, 255)
    FieldSphere.Transparency = Config.FieldTransparency
    FieldSphere.CFrame = Root.CFrame
    FieldSphere.Parent = workspace

    FieldLight = Instance.new("PointLight", FieldSphere)
    FieldLight.Color = Color3.fromRGB(180, 60, 255)
    FieldLight.Range = Config.FieldRadius * 2
    FieldLight.Brightness = 4

    ReflectionRing = Instance.new("Part", workspace)
    ReflectionRing.Name = "PurpleReflection"
    ReflectionRing.Shape = Enum.PartType.Cylinder
    ReflectionRing.Size = Vector3.new(0.2, Config.FieldRadius * 2, Config.FieldRadius * 2)
    ReflectionRing.Anchored = true
    ReflectionRing.CanCollide = false
    ReflectionRing.CanTouch = false
    ReflectionRing.CanQuery = false
    ReflectionRing.Material = Enum.Material.Neon
    ReflectionRing.Color = Color3.fromRGB(180, 60, 255)
    ReflectionRing.Transparency = 0.65
    ReflectionRing.CFrame = CFrame.new(Root.Position.X, Root.Position.Y - 3, Root.Position.Z) * CFrame.Angles(0, 0, math.rad(90))

    ReflectionInner = Instance.new("Part", workspace)
    ReflectionInner.Name = "PurpleReflectionInner"
    ReflectionInner.Shape = Enum.PartType.Cylinder
    ReflectionInner.Size = Vector3.new(0.3, Config.FieldRadius * 1.2, Config.FieldRadius * 1.2)
    ReflectionInner.Anchored = true
    ReflectionInner.CanCollide = false
    ReflectionInner.CanTouch = false
    ReflectionInner.CanQuery = false
    ReflectionInner.Material = Enum.Material.Neon
    ReflectionInner.Color = Color3.fromRGB(220, 150, 255)
    ReflectionInner.Transparency = 0.5
    ReflectionInner.CFrame = CFrame.new(Root.Position.X, Root.Position.Y - 3.1, Root.Position.Z) * CFrame.Angles(0, 0, math.rad(90))

    FieldAttachment = createLightning()

    PulseConn = RunService.Heartbeat:Connect(function()
        if not Config.Active or not FieldSphere or not FieldSphere.Parent then return end
        local pulse = 1 + math.sin(tick() * 3) * 0.02
        FieldSphere.Size = Vector3.new(
            Config.FieldRadius * 2 * pulse,
            Config.FieldRadius * 2 * pulse,
            Config.FieldRadius * 2 * pulse
        )
    end)

    DamageConn = RunService.Heartbeat:Connect(function()
        if not Config.Active or not Root or not Root.Parent then return end
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= Player then
                local otherChar = otherPlayer.Character
                if otherChar then
                    local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")
                    local otherHum = otherChar:FindFirstChild("Humanoid")
                    if otherRoot and otherHum and otherHum.Health > 0 then
                        local dist = (otherRoot.Position - Root.Position).Magnitude
                        if dist <= Config.FieldRadius then
                            knockbackPlayer(otherRoot)
                            applyRadiation(otherHum)
                        end
                    end
                end
            end
        end
    end)

    updateFieldPosition()
end

--========================================
-- XÓA TỪ TRƯỜNG
--========================================
local function destroyField()
    if not Config.Active then return end
    Config.Active = false

    if FieldSphere then FieldSphere:Destroy() FieldSphere = nil end
    if ReflectionRing then ReflectionRing:Destroy() ReflectionRing = nil end
    if ReflectionInner then ReflectionInner:Destroy() ReflectionInner = nil end
    if FieldLight then FieldLight:Destroy() FieldLight = nil end
    if FieldAttachment then FieldAttachment:Destroy() FieldAttachment = nil end
    if DamageConn then DamageConn:Disconnect() DamageConn = nil end
    if PulseConn then PulseConn:Disconnect() PulseConn = nil end
end

--========================================
-- SETUP NHÂN VẬT
--========================================
local function setupCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    Root = char:WaitForChild("HumanoidRootPart")
    if Config.Active then
        destroyField()
        task.wait(0.2)
        createField()
    end
end

if Player.Character then setupCharacter(Player.Character) end
Player.CharacterAdded:Connect(setupCharacter)

--========================================
-- BLOOM
--========================================
pcall(function()
    local bloom = Lighting:FindFirstChild("PurpleBloom")
    if not bloom then
        bloom = Instance.new("BloomEffect", Lighting)
        bloom.Name = "PurpleBloom"
        bloom.Intensity = 1.2
        bloom.Size = 20
        bloom.Threshold = 1
    end
end)

--========================================
-- MENU GUI
--========================================
local function createMenu()
    if Player.PlayerGui:FindFirstChild("PurpleFieldMenu") then
        Player.PlayerGui.PurpleFieldMenu:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "PurpleFieldMenu"
    gui.ResetOnSpawn = false
    gui.Parent = Player.PlayerGui

    local main = Instance.new("Frame", gui)
    main.Name = "Main"
    main.Size = UDim2.new(0, 260, 0, 330)
    main.Position = UDim2.new(0.5, -130, 0.5, -165)
    main.BackgroundColor3 = Color3.fromRGB(15, 5, 25)
    main.BackgroundTransparency = 0.1
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(180, 60, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.2

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(30, 10, 45)
    title.BackgroundTransparency = 0.3
    title.Text = "💜 PURPLE MAGNETIC FIELD"
    title.TextColor3 = Color3.fromRGB(220, 180, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -30, 0, 7)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

    local openBtn = Instance.new("TextButton", gui)
    openBtn.Name = "OpenBtn"
    openBtn.Size = UDim2.new(0, 50, 0, 50)
    openBtn.Position = UDim2.new(0, 15, 0, 200)
    openBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 255)
    openBtn.Text = "💜"
    openBtn.TextSize = 24
    openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    openBtn.Font = Enum.Font.GothamBold
    openBtn.Visible = false
    Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 25)

    closeBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        openBtn.Visible = true
    end)
    openBtn.MouseButton1Click:Connect(function()
        main.Visible = true
        openBtn.Visible = false
    end)

    local toggleBtn = Instance.new("TextButton", main)
    toggleBtn.Size = UDim2.new(1, -20, 0, 45)
    toggleBtn.Position = UDim2.new(0, 10, 0, 50)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 100)
    toggleBtn.Text = "🔴 TỪ TRƯỜNG: TẮT"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 14
    toggleBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

    toggleBtn.MouseButton1Click:Connect(function()
        if Config.Active then
            destroyField()
            toggleBtn.Text = "🔴 TỪ TRƯỜNG: TẮT"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 100)
        else
            createField()
            toggleBtn.Text = "🟢 TỪ TRƯỜNG: BẬT"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 150)
        end
    end)

    -- Slider bán kính
    local radiusLabel = Instance.new("TextLabel", main)
    radiusLabel.Size = UDim2.new(1, -20, 0, 20)
    radiusLabel.Position = UDim2.new(0, 10, 0, 105)
    radiusLabel.BackgroundTransparency = 1
    radiusLabel.Text = "📏 Bán kính: " .. Config.FieldRadius
    radiusLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
    radiusLabel.TextSize = 12
    radiusLabel.Font = Enum.Font.GothamMedium
    radiusLabel.TextXAlignment = Enum.TextXAlignment.Left

    local radiusSlider = Instance.new("Frame", main)
    radiusSlider.Size = UDim2.new(1, -20, 0, 10)
    radiusSlider.Position = UDim2.new(0, 10, 0, 128)
    radiusSlider.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
    radiusSlider.BorderSizePixel = 0
    Instance.new("UICorner", radiusSlider).CornerRadius = UDim.new(0, 5)

    local radiusFill = Instance.new("Frame", radiusSlider)
    radiusFill.Size = UDim2.new(Config.FieldRadius / 30, 0, 1, 0)
    radiusFill.BackgroundColor3 = Color3.fromRGB(180, 60, 255)
    radiusFill.BorderSizePixel = 0
    Instance.new("UICorner", radiusFill).CornerRadius = UDim.new(0, 5)

    local radiusKnob = Instance.new("TextButton", radiusSlider)
    radiusKnob.Size = UDim2.new(0, 18, 0, 18)
    radiusKnob.Position = UDim2.new(Config.FieldRadius / 30, -9, 0.5, -9)
    radiusKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    radiusKnob.Text = ""
    Instance.new("UICorner", radiusKnob).CornerRadius = UDim.new(0, 9)

    local draggingRadius = false
    radiusKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingRadius = true
        end
    end)
    radiusKnob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingRadius = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if draggingRadius and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mouseX = input.Position.X
            local sliderPos = radiusSlider.AbsolutePosition.X
            local sliderWidth = radiusSlider.AbsoluteSize.X
            local percent = math.clamp((mouseX - sliderPos) / sliderWidth, 0, 1)
            radiusFill.Size = UDim2.new(percent, 0, 1, 0)
            radiusKnob.Position = UDim2.new(percent, -9, 0.5, -9)
            Config.FieldRadius = math.floor(5 + percent * 25)
            radiusLabel.Text = "📏 Bán kính: " .. Config.FieldRadius
            if FieldSphere then
                FieldSphere.Size = Vector3.new(Config.FieldRadius*2, Config.FieldRadius*2, Config.FieldRadius*2)
            end
        end
    end)

    -- Slider sát thương
    local dmgLabel = Instance.new("TextLabel", main)
    dmgLabel.Size = UDim2.new(1, -20, 0, 20)
    dmgLabel.Position = UDim2.new(0, 10, 0, 160)
    dmgLabel.BackgroundTransparency = 1
    dmgLabel.Text = "☢️ Sát thương: " .. Config.RadiationDamage
    dmgLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
    dmgLabel.TextSize = 12
    dmgLabel.Font = Enum.Font.GothamMedium
    dmgLabel.TextXAlignment = Enum.TextXAlignment.Left

    local dmgSlider = Instance.new("Frame", main)
    dmgSlider.Size = UDim2.new(1, -20, 0, 10)
    dmgSlider.Position = UDim2.new(0, 10, 0, 183)
    dmgSlider.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
    dmgSlider.BorderSizePixel = 0
    Instance.new("UICorner", dmgSlider).CornerRadius = UDim.new(0, 5)

    local dmgFill = Instance.new("Frame", dmgSlider)
    dmgFill.Size = UDim2.new(Config.RadiationDamage / 50, 0, 1, 0)
    dmgFill.BackgroundColor3 = Color3.fromRGB(255, 80, 150)
    dmgFill.BorderSizePixel = 0
    Instance.new("UICorner", dmgFill).CornerRadius = UDim.new(0, 5)

    local dmgKnob = Instance.new("TextButton", dmgSlider)
    dmgKnob.Size = UDim2.new(0, 18, 0, 18)
    dmgKnob.Position = UDim2.new(Config.RadiationDamage / 50, -9, 0.5, -9)
    dmgKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dmgKnob.Text = ""
    Instance.new("UICorner", dmgKnob).CornerRadius = UDim.new(0, 9)

    local draggingDmg = false
    dmgKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingDmg = true
        end
    end)
    dmgKnob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingDmg = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if draggingDmg and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mouseX = input.Position.X
            local sliderPos = dmgSlider.AbsolutePosition.X
            local sliderWidth = dmgSlider.AbsoluteSize.X
            local percent = math.clamp((mouseX - sliderPos) / sliderWidth, 0, 1)
            dmgFill.Size = UDim2.new(percent, 0, 1, 0)
            dmgKnob.Position = UDim2.new(percent, -9, 0.5, -9)
            Config.RadiationDamage = math.floor(1 + percent * 49)
            dmgLabel.Text = "☢️ Sát thương: " .. Config.RadiationDamage
        end
    end)

    -- Nút bật/tắt
    local kbBtn = Instance.new("TextButton", main)
    kbBtn.Size = UDim2.new(0.48, 0, 0, 35)
    kbBtn.Position = UDim2.new(0, 10, 0, 215)
    kbBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 150)
    kbBtn.Text = "💥 Knockback: ON"
    kbBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    kbBtn.TextSize = 11
    kbBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 6)
    kbBtn.MouseButton1Click:Connect(function()
        Config.KnockbackEnabled = not Config.KnockbackEnabled
        kbBtn.Text = Config.KnockbackEnabled and "💥 Knockback: ON" or "💥 Knockback: OFF"
        kbBtn.BackgroundColor3 = Config.KnockbackEnabled and Color3.fromRGB(100, 30, 150) or Color3.fromRGB(60, 60, 60)
    end)

    local radBtn = Instance.new("TextButton", main)
    radBtn.Size = UDim2.new(0.48, 0, 0, 35)
    radBtn.Position = UDim2.new(0.52, 0, 0, 215)
    radBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 150)
    radBtn.Text = "☢️ Phóng xạ: ON"
    radBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    radBtn.TextSize = 11
    radBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", radBtn).CornerRadius = UDim.new(0, 6)
    radBtn.MouseButton1Click:Connect(function()
        Config.RadiationEnabled = not Config.RadiationEnabled
        radBtn.Text = Config.RadiationEnabled and "☢️ Phóng xạ: ON" or "☢️ Phóng xạ: OFF"
        radBtn.BackgroundColor3 = Config.RadiationEnabled and Color3.fromRGB(100, 30, 150) or Color3.fromRGB(60, 60, 60)
    end)

    local info = Instance.new("TextLabel", main)
    info.Size = UDim2.new(1, -20, 0, 20)
    info.Position = UDim2.new(0, 10, 0, 260)
    info.BackgroundTransparency = 1
    info.Text = "⌨️ T = Bật/tắt nhanh | H = Ẩn menu"
    info.TextColor3 = Color3.fromRGB(150, 130, 180)
    info.TextSize = 10
    info.Font = Enum.Font.Gotham
    info.TextXAlignment = Enum.TextXAlignment.Left

    local author = Instance.new("TextLabel", main)
    author.Size = UDim2.new(1, -20, 0, 20)
    author.Position = UDim2.new(0, 10, 0, 285)
    author.BackgroundTransparency = 1
    author.Text = "💕 Made by Em | v1.0"
    author.TextColor3 = Color3.fromRGB(255, 180, 220)
    author.TextSize = 10
    author.Font = Enum.Font.GothamMedium
    author.TextXAlignment = Enum.TextXAlignment.Left

    main.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 260, 0, 330)
    }):Play()
end

--========================================
-- PHÍM TẮT
--========================================
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end

    if input.KeyCode == Enum.KeyCode.T then
        if Config.Active then
            destroyField()
        else
            createField()
        end
    end

    if input.KeyCode == Enum.KeyCode.H then
        local hud = Player.PlayerGui:FindFirstChild("PurpleFieldMenu")
        if hud and hud:FindFirstChild("Main") then
            hud.Main.Visible = not hud.Main.Visible
            if hud:FindFirstChild("OpenBtn") then
                hud.OpenBtn.Visible = not hud.Main.Visible
            end
        end
    end
end)

--========================================
-- KHỞI TẠO
--========================================
createMenu()

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "💜 PURPLE FIELD v1.0",
        Text = "Nhấn T để bật/tắt từ trường nha anh~",
        Duration = 5
    })
end)

print("═══════════════════════════════════════════")
print("💜 PURPLE MAGNETIC FIELD v1.0 - LOADED!")
print("⌨️  T = Bật/tắt | H = Ẩn menu")
print("═══════════════════════════════════════════")
