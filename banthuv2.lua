--========================================
-- PURPLE MAGNETIC FIELD - TSB EDITION
-- Barrier Style (No Damage)
-- v2.3 | By Em 💕
--========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--========================================
-- CẤU HÌNH
--========================================
local Config = {
    FieldRadius         = 15,
    FieldTransparency   = 0.75,
    KnockbackForce      = 250,
    KnockbackEnabled    = true,
    ReflectionEnabled   = true,
    SoundEnabled        = true,
    ScreenShakeEnabled  = true,
    Active              = false
}

--========================================
-- BIẾN
--========================================
local Character, Humanoid, Root
local FieldSphere, FieldInnerSphere
local ReflectionRing, ReflectionInner, ReflectionOuter
local FieldLight, FieldAttachment
local PushConn, PulseConn, RotateConn, PositionConn
local knockbackCooldown = {}
local EnemyCount = 0

--========================================
-- ÂM THANH
--========================================
local SOUNDS = {
    On  = "rbxassetid://1838218402",
    Off = "rbxassetid://6042053626",
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
-- SCREEN SHAKE
--========================================
local shaking = false
local function shakeScreen(intensity, duration)
    if not Config.ScreenShakeEnabled then return end
    if shaking then return end
    shaking = true
    local startTime = tick()
    local originalCFrame = Camera.CFrame

    local conn
    conn = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        if elapsed >= duration then
            conn:Disconnect()
            shaking = false
            Camera.CFrame = originalCFrame
            return
        end
        local x = math.sin(elapsed * 60) * intensity
        local y = math.cos(elapsed * 70) * intensity
        Camera.CFrame = originalCFrame * CFrame.new(x / 100, y / 100, 0)
    end)
end

--========================================
-- TIA SÉT TÍM
--========================================
local function createLightning()
    if not Root or not Root.Parent then return nil end
    local attach = Instance.new("Attachment", Root)

    local p1 = Instance.new("ParticleEmitter", attach)
    p1.Texture = "rbxassetid://243660364"
    p1.Color = ColorSequence.new(Color3.fromRGB(180, 60, 255))
    p1.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(0.5, 2.5),
        NumberSequenceKeypoint.new(1, 0)
    })
    p1.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    p1.Lifetime = NumberRange.new(0.3, 0.7)
    p1.Rate = 30
    p1.Speed = NumberRange.new(15, 30)
    p1.SpreadAngle = Vector2.new(180, 180)
    p1.LightEmission = 1
    p1.LightInfluence = 0

    local p2 = Instance.new("ParticleEmitter", attach)
    p2.Texture = "rbxassetid://296874871"
    p2.Color = ColorSequence.new(Color3.fromRGB(220, 150, 255))
    p2.Size = NumberSequence.new(1.5)
    p2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(1, 1)
    })
    p2.Lifetime = NumberRange.new(0.8, 1.5)
    p2.Rate = 40
    p2.Speed = NumberRange.new(5, 12)
    p2.SpreadAngle = Vector2.new(180, 180)
    p2.LightEmission = 1

    return attach
end

--========================================
-- ĐẨY KẺ ĐỊCH RA (TƯỜNG BẤT TỬ - KHÔNG DAMAGE)
--========================================
local function pushEnemyOut(otherRoot)
    if not Config.KnockbackEnabled then return end
    if not Root or not Root.Parent then return end
    if not otherRoot or not otherRoot.Parent then return end

    -- Tính hướng đẩy (CHỈ ĐẨY NGANG, KHÔNG ĐẨY LÊN TRỜI)
    local dir = (otherRoot.Position - Root.Position)
    if dir.Magnitude < 0.1 then
        dir = Vector3.new(1, 0, 1)
    end
    dir = Vector3.new(dir.X, 0, dir.Z).Unit

    -- Tạo BodyVelocity liên tục để đẩy ra
    local existingBV = otherRoot:FindFirstChild("PurpleFieldPush")
    if existingBV then
        existingBV.Velocity = dir * Config.KnockbackForce
        return
    end

    local bv = Instance.new("BodyVelocity")
    bv.Name = "PurpleFieldPush"
    -- MaxForce chỉ ở trục X và Z, để trục Y = 0 (không bay lên trời)
    bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
    bv.Velocity = dir * Config.KnockbackForce
    bv.Parent = otherRoot
    Debris:AddItem(bv, 0.15)

    -- Hiệu ứng nổ tím khi chạm tường
    local otherPlayer = Players:GetPlayerFromCharacter(otherRoot.Parent)
    local key = otherPlayer and otherPlayer.UserId or otherRoot
    local now = tick()
    if knockbackCooldown[key] and now - knockbackCooldown[key] < 0.4 then return end
    knockbackCooldown[key] = now

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
        Size = Vector3.new(15, 15, 15),
        Transparency = 1
    }):Play()
    Debris:AddItem(fx, 0.5)

    playSound(SOUNDS.Hit, 0.5, 1.2)
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
    if FieldInnerSphere and FieldInnerSphere.Parent then
        FieldInnerSphere.CFrame = Root.CFrame
    end
    if ReflectionRing and ReflectionRing.Parent then
        ReflectionRing.CFrame = CFrame.new(Root.Position.X, Root.Position.Y - 3, Root.Position.Z) * CFrame.Angles(0, 0, math.rad(90))
    end
    if ReflectionInner and ReflectionInner.Parent then
        ReflectionInner.CFrame = CFrame.new(Root.Position.X, Root.Position.Y - 3.1, Root.Position.Z) * CFrame.Angles(0, 0, math.rad(90))
    end
    if ReflectionOuter and ReflectionOuter.Parent then
        ReflectionOuter.CFrame = CFrame.new(Root.Position.X, Root.Position.Y - 3.2, Root.Position.Z) * CFrame.Angles(0, 0, math.rad(90))
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

    -- Quả cầu từ trường chính
    FieldSphere = Instance.new("Part")
    FieldSphere.Name = "PurpleFieldMain"
    FieldSphere.Shape = Enum.PartType.Ball
    FieldSphere.Size = Vector3.new(Config.FieldRadius * 2, Config.FieldRadius * 2, Config.FieldRadius * 2)
    FieldSphere.Anchored = true
    FieldSphere.CanCollide = false
    FieldSphere.CanTouch = false
    FieldSphere.CanQuery = false
    FieldSphere.Material = Enum.Material.Glass
    FieldSphere.Color = Color3.fromRGB(180, 60, 255)
    FieldSphere.Transparency = Config.FieldTransparency
    FieldSphere.CFrame = Root.CFrame
    FieldSphere.Parent = workspace

    -- Lớp 2
    FieldInnerSphere = Instance.new("Part")
    FieldInnerSphere.Name = "PurpleFieldInner"
    FieldInnerSphere.Shape = Enum.PartType.Ball
    FieldInnerSphere.Size = Vector3.new(Config.FieldRadius * 1.85, Config.FieldRadius * 1.85, Config.FieldRadius * 1.85)
    FieldInnerSphere.Anchored = true
    FieldInnerSphere.CanCollide = false
    FieldInnerSphere.CanTouch = false
    FieldInnerSphere.CanQuery = false
    FieldInnerSphere.Material = Enum.Material.ForceField
    FieldInnerSphere.Color = Color3.fromRGB(220, 150, 255)
    FieldInnerSphere.Transparency = Config.FieldTransparency + 0.05
    FieldInnerSphere.CFrame = Root.CFrame
    FieldInnerSphere.Parent = workspace

    -- Ánh sáng tím
    FieldLight = Instance.new("PointLight", FieldSphere)
    FieldLight.Color = Color3.fromRGB(180, 60, 255)
    FieldLight.Range = Config.FieldRadius * 2
    FieldLight.Brightness = 2

    -- Vòng phản chiếu
    if Config.ReflectionEnabled then
        ReflectionRing = Instance.new("Part", workspace)
        ReflectionRing.Name = "PurpleReflectionOuter"
        ReflectionRing.Shape = Enum.PartType.Cylinder
        ReflectionRing.Size = Vector3.new(0.2, Config.FieldRadius * 2, Config.FieldRadius * 2)
        ReflectionRing.Anchored = true
        ReflectionRing.CanCollide = false
        ReflectionRing.CanTouch = false
        ReflectionRing.CanQuery = false
        ReflectionRing.Material = Enum.Material.Neon
        ReflectionRing.Color = Color3.fromRGB(180, 60, 255)
        ReflectionRing.Transparency = 0.7
        ReflectionRing.CFrame = CFrame.new(Root.Position.X, Root.Position.Y - 3, Root.Position.Z) * CFrame.Angles(0, 0, math.rad(90))

        ReflectionInner = Instance.new("Part", workspace)
        ReflectionInner.Name = "PurpleReflectionInner"
        ReflectionInner.Shape = Enum.PartType.Cylinder
        ReflectionInner.Size = Vector3.new(0.3, Config.FieldRadius * 1.3, Config.FieldRadius * 1.3)
        ReflectionInner.Anchored = true
        ReflectionInner.CanCollide = false
        ReflectionInner.CanTouch = false
        ReflectionInner.CanQuery = false
        ReflectionInner.Material = Enum.Material.Neon
        ReflectionInner.Color = Color3.fromRGB(220, 150, 255)
        ReflectionInner.Transparency = 0.55
        ReflectionInner.CFrame = CFrame.new(Root.Position.X, Root.Position.Y - 3.1, Root.Position.Z) * CFrame.Angles(0, 0, math.rad(90))

        ReflectionOuter = Instance.new("Part", workspace)
        ReflectionOuter.Name = "PurpleReflectionCore"
        ReflectionOuter.Shape = Enum.PartType.Cylinder
        ReflectionOuter.Size = Vector3.new(0.4, Config.FieldRadius * 0.5, Config.FieldRadius * 0.5)
        ReflectionOuter.Anchored = true
        ReflectionOuter.CanCollide = false
        ReflectionOuter.CanTouch = false
        ReflectionOuter.CanQuery = false
        ReflectionOuter.Material = Enum.Material.Neon
        ReflectionOuter.Color = Color3.fromRGB(255, 200, 255)
        ReflectionOuter.Transparency = 0.4
        ReflectionOuter.CFrame = CFrame.new(Root.Position.X, Root.Position.Y - 3.2, Root.Position.Z) * CFrame.Angles(0, 0, math.rad(90))
    end

    FieldAttachment = createLightning()

    -- Pulse
    PulseConn = RunService.Heartbeat:Connect(function()
        if not Config.Active then return end
        if not FieldSphere or not FieldSphere.Parent then return end
        if not FieldInnerSphere or not FieldInnerSphere.Parent then return end

        local pulse = 1 + math.sin(tick() * 3) * 0.02
        FieldSphere.Size = Vector3.new(
            Config.FieldRadius * 2 * pulse,
            Config.FieldRadius * 2 * pulse,
            Config.FieldRadius * 2 * pulse
        )
        FieldInnerSphere.Size = Vector3.new(
            Config.FieldRadius * 1.85 * pulse,
            Config.FieldRadius * 1.85 * pulse,
            Config.FieldRadius * 1.85 * pulse
        )
    end)

    -- Rotate
    RotateConn = RunService.Heartbeat:Connect(function()
        if not Config.Active then return end
        if ReflectionInner and ReflectionInner.Parent then
            ReflectionInner.CFrame = ReflectionInner.CFrame * CFrame.Angles(0, math.rad(2), 0)
        end
        if ReflectionOuter and ReflectionOuter.Parent then
            ReflectionOuter.CFrame = ReflectionOuter.CFrame * CFrame.Angles(0, math.rad(-3), 0)
        end
    end)

    -- Đẩy kẻ địch ra (Barrier - NO DAMAGE)
    PushConn = RunService.Heartbeat:Connect(function()
        if not Config.Active then return end
        if not Root or not Root.Parent then return end

        EnemyCount = 0

        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= Player then
                local otherChar = otherPlayer.Character
                if otherChar then
                    local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")
                    local otherHum = otherChar:FindFirstChild("Humanoid")

                    if otherRoot and otherHum and otherHum.Health > 0 then
                        local dist = (otherRoot.Position - Root.Position).Magnitude

                        -- CHỈ ĐẨY RA - KHÔNG GÂY DAMAGE
                        if dist <= Config.FieldRadius + 3 then
                            EnemyCount = EnemyCount + 1
                            pushEnemyOut(otherRoot)
                        end
                    end
                end
            end
        end
    end)

    PositionConn = RunService.RenderStepped:Connect(function()
        updateFieldPosition()
    end)
end

--========================================
-- XÓA TỪ TRƯỜNG
--========================================
local function destroyField()
    if not Config.Active then return end
    Config.Active = false
    playSound(SOUNDS.Off, 0.7, 1)

    if FieldSphere then FieldSphere:Destroy() FieldSphere = nil end
    if FieldInnerSphere then FieldInnerSphere:Destroy() FieldInnerSphere = nil end
    if ReflectionRing then ReflectionRing:Destroy() ReflectionRing = nil end
    if ReflectionInner then ReflectionInner:Destroy() ReflectionInner = nil end
    if ReflectionOuter then ReflectionOuter:Destroy() ReflectionOuter = nil end
    if FieldLight then FieldLight:Destroy() FieldLight = nil end
    if FieldAttachment then FieldAttachment:Destroy() FieldAttachment = nil end

    if PushConn then PushConn:Disconnect() PushConn = nil end
    if PulseConn then PulseConn:Disconnect() PulseConn = nil end
    if RotateConn then RotateConn:Disconnect() RotateConn = nil end
    if PositionConn then PositionConn:Disconnect() PositionConn = nil end
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
        bloom.Intensity = 0.6
        bloom.Size = 16
        bloom.Threshold = 1.5
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
    main.Size = UDim2.new(0, 280, 0, 330)
    main.Position = UDim2.new(0.5, -140, 0.5, -165)
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

    -- Nút bật/tắt
    local toggleBtn = Instance.new("TextButton", main)
    toggleBtn.Name = "ToggleBtn"
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
                FieldSphere.Size = Vector3.new(Config.FieldRadius * 2, Config.FieldRadius * 2, Config.FieldRadius * 2)
            end
            if FieldInnerSphere then
                FieldInnerSphere.Size = Vector3.new(Config.FieldRadius * 1.85, Config.FieldRadius * 1.85, Config.FieldRadius * 1.85)
            end
        end
    end)

    -- Nút Knockback
    local kbBtn = Instance.new("TextButton", main)
    kbBtn.Size = UDim2.new(1, -20, 0, 35)
    kbBtn.Position = UDim2.new(0, 10, 0, 160)
    kbBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 150)
    kbBtn.Text = "💥 Đẩy kẻ địch ra: ON"
    kbBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    kbBtn.TextSize = 12
    kbBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 6)
    kbBtn.MouseButton1Click:Connect(function()
        Config.KnockbackEnabled = not Config.KnockbackEnabled
        kbBtn.Text = Config.KnockbackEnabled and "💥 Đẩy kẻ địch ra: ON" or "💥 Đẩy kẻ địch ra: OFF"
        kbBtn.BackgroundColor3 = Config.KnockbackEnabled and Color3.fromRGB(100, 30, 150) or Color3.fromRGB(60, 60, 60)
    end)

    -- Enemy counter
    local enemyLabel = Instance.new("TextLabel", main)
    enemyLabel.Name = "EnemyLabel"
    enemyLabel.Size = UDim2.new(1, -20, 0, 20)
    enemyLabel.Position = UDim2.new(0, 10, 0, 205)
    enemyLabel.BackgroundTransparency = 1
    enemyLabel.Text = "👥 Kẻ địch trong vùng: 0"
    enemyLabel.TextColor3 = Color3.fromRGB(255, 150, 200)
    enemyLabel.TextSize = 12
    enemyLabel.Font = Enum.Font.GothamBold
    enemyLabel.TextXAlignment = Enum.TextXAlignment.Left

    local info = Instance.new("TextLabel", main)
    info.Size = UDim2.new(1, -20, 0, 20)
    info.Position = UDim2.new(0, 10, 0, 230)
    info.BackgroundTransparency = 1
    info.Text = "⌨️ T = Bật/tắt | H = Ẩn menu"
    info.TextColor3 = Color3.fromRGB(150, 130, 180)
    info.TextSize = 10
    info.Font = Enum.Font.Gotham
    info.TextXAlignment = Enum.TextXAlignment.Left

    -- Nút Reset
    local resetBtn = Instance.new("TextButton", main)
    resetBtn.Size = UDim2.new(1, -20, 0, 30)
    resetBtn.Position = UDim2.new(0, 10, 0, 255)
    resetBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    resetBtn.Text = "🔄 RESET"
    resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetBtn.TextSize = 12
    resetBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)
    resetBtn.MouseButton1Click:Connect(function()
        Config.FieldRadius = 15
        Config.KnockbackEnabled = true

        radiusLabel.Text = "📏 Bán kính: 15"
        radiusFill.Size = UDim2.new(15 / 30, 0, 1, 0)
        radiusKnob.Position = UDim2.new(15 / 30, -9, 0.5, -9)

        kbBtn.Text = "💥 Đẩy kẻ địch ra: ON"
        kbBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 150)

        if FieldSphere then
            FieldSphere.Size = Vector3.new(30, 30, 30)
        end
    end)

    local author = Instance.new("TextLabel", main)
    author.Size = UDim2.new(1, -20, 0, 20)
    author.Position = UDim2.new(0, 10, 0, 295)
    author.BackgroundTransparency = 1
    author.Text = "💕 Made by Em | v2.3"
    author.TextColor3 = Color3.fromRGB(255, 180, 220)
    author.TextSize = 10
    author.Font = Enum.Font.GothamMedium
    author.TextXAlignment = Enum.TextXAlignment.Left

    main.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 280, 0, 330)
    }):Play()

    -- Cập nhật enemy count
    RunService.Heartbeat:Connect(function()
        if enemyLabel and enemyLabel.Parent then
            enemyLabel.Text = "👥 Kẻ địch trong vùng: " .. tostring(EnemyCount)
        end
    end)
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
        local hud = Player.PlayerGui:FindFirstChild("PurpleFieldMenu")
        if hud and hud:FindFirstChild("Main") then
            local toggleBtn = hud.Main:FindFirstChild("ToggleBtn")
            if toggleBtn then
                if Config.Active then
                    toggleBtn.Text = "🟢 TỪ TRƯỜNG: BẬT"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 150)
                else
                    toggleBtn.Text = "🔴 TỪ TRƯỜNG: TẮT"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 100)
                end
            end
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
        Title = "💜 PURPLE FIELD v2.3",
        Text = "Từ trường bất tử - Nhấn T để bật/tắt nha anh~",
        Duration = 5
    })
end)

print("═══════════════════════════════════════════")
print("💜 PURPLE MAGNETIC FIELD v2.3 - LOADED!")
print("🛡️ Chỉ đẩy kẻ địch ra - KHÔNG gây damage")
print("⌨️  T = Bật/tắt | H = Ẩn menu")
print("═══════════════════════════════════════════")
