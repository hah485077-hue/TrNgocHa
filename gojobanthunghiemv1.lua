--========================================
-- GOJO EFFECTS FOR SAITAMA - TSB MOD (v3.0 FINAL)
-- Chạy bằng Delta Executor - Đã fix lỗi 2026
--========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local MOD_INFO = {
    Name = "GOJO EFFECTS",
    Version = "v3.0",
    Author = "Em 💕",
    Status = "ONLINE"
}

local CONFIG = {
    ScreenShake = true,
    Sounds = true,
    Aura = true,
    Trail = true,
    ImpactRing = true,
    CameraZoom = true,
    Bloom = true,
    ShowHUD = true,
    EffectCooldown = 0.35,
}

local SOUND_IDS = {
    Blue   = "rbxassetid://6042053626",
    Red    = "rbxassetid://6042053379",
    Purple = "rbxassetid://6667923288",
    Rage   = "rbxassetid://1838218402",
}

local Character, Humanoid, Root
local lastEffectTime = 0
local rageActive = false
local rageConnection = nil
local hudVisible = true

--========================================
-- KHAI BÁO HÀM TRƯỚC
--========================================
local effectBlue, effectRed, effectPurple, effectRage
local shakeScreen, playSound, createAura
local createFFTrail, createImpactRing
local punchFOV, createFlash
local setupCharacter, createHUD, showNotification

--========================================
-- ÂM THANH
--========================================
playSound = function(soundId, volume, pitch)
    if not CONFIG.Sounds then return end
    if not Root or not Root.Parent then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = soundId
        s.Volume = volume or 1
        s.PlaybackSpeed = pitch or 1
        s.Parent = Root
        s:Play()
        Debris:AddItem(s, 5)
    end)
end

--========================================
-- RUNG MÀN HÌNH
--========================================
local shaking = false
shakeScreen = function(intensity, duration)
    if not CONFIG.ScreenShake then return end
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
        local x = math.sin(elapsed * 50) * intensity
        local y = math.cos(elapsed * 60) * intensity
        Camera.CFrame = originalCFrame * CFrame.new(x / 100, y / 100, 0)
    end)
end

--========================================
-- CAMERA ZOOM
--========================================
punchFOV = function(intensity)
    if not CONFIG.CameraZoom then return end
    local originalFOV = Camera.FieldOfView
    local tweenIn = TweenService:Create(Camera, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        FieldOfView = originalFOV + intensity
    })
    tweenIn:Play()
    tweenIn.Completed:Connect(function()
        TweenService:Create(Camera, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            FieldOfView = originalFOV
        }):Play()
    end)
end

--========================================
-- HÀO QUANG
--========================================
createAura = function(color, size, duration)
    if not CONFIG.Aura then return end
    if not Root or not Root.Parent then return end

    local attach = Instance.new("Attachment", Root)

    local p1 = Instance.new("ParticleEmitter", attach)
    p1.Texture = "rbxassetid://243660364"
    p1.Color = ColorSequence.new(color)
    p1.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, size * 1.2),
        NumberSequenceKeypoint.new(1, 0)
    })
    p1.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.3, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    p1.Lifetime = NumberRange.new(0.6, 1.2)
    p1.Rate = 150
    p1.Speed = NumberRange.new(10, 20)
    p1.SpreadAngle = Vector2.new(180, 180)
    p1.LightEmission = 1
    p1.LightInfluence = 0

    local light = Instance.new("PointLight", attach)
    light.Color = color
    light.Range = 22
    light.Brightness = 6

    local ring = Instance.new("Part", workspace)
    ring.Shape = Enum.PartType.Cylinder
    ring.Size = Vector3.new(0.2, 5, 5)
    ring.Anchored = true
    ring.CanCollide = false
    ring.Material = Enum.Material.Neon
    ring.Color = color
    ring.Transparency = 0.15
    ring.CFrame = Root.CFrame * CFrame.Angles(0, 0, math.rad(90))

    TweenService:Create(ring, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.2, 25, 25),
        Transparency = 1
    }):Play()
    Debris:AddItem(ring, 1.5)

    task.delay(duration, function()
        if p1 and p1.Parent then p1.Enabled = false end
        task.wait(1.5)
        if attach and attach.Parent then attach:Destroy() end
    end)
end

--========================================
-- TRAIL
--========================================
createFFTrail = function(color, duration)
    if not CONFIG.Trail then return end
    if not Character then return end
    local rh = Character:FindFirstChild("RightHand") or Character:FindFirstChild("Right Arm")
    local lh = Character:FindFirstChild("LeftHand") or Character:FindFirstChild("Left Arm")
    if not (rh and lh) then return end

    local a0 = Instance.new("Attachment", rh)
    local a1 = Instance.new("Attachment", lh)

    local trail = Instance.new("Trail", Character)
    trail.Attachment0 = a0
    trail.Attachment1 = a1
    trail.Color = ColorSequence.new(color)
    trail.Lifetime = 0.7
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    trail.LightEmission = 1
    trail.LightInfluence = 0
    trail.WidthScale = NumberSequence.new(2.5)
    trail.FaceCamera = true

    Debris:AddItem(trail, duration)
    Debris:AddItem(a0, duration)
    Debris:AddItem(a1, duration)
end

--========================================
-- VÒNG NỔ
--========================================
createImpactRing = function(color, position, size)
    if not CONFIG.ImpactRing then return end
    local ring = Instance.new("Part", workspace)
    ring.Shape = Enum.PartType.Cylinder
    ring.Size = Vector3.new(0.2, 2, 2)
    ring.Anchored = true
    ring.CanCollide = false
    ring.Material = Enum.Material.Neon
    ring.Color = color
    ring.Transparency = 0
    ring.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))

    TweenService:Create(ring, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.2, size, size),
        Transparency = 1
    }):Play()
    Debris:AddItem(ring, 0.5)

    local light = Instance.new("PointLight", ring)
    light.Color = color
    light.Range = size * 2
    light.Brightness = 10
    Debris:AddItem(light, 0.4)
end

--========================================
-- FLASH
--========================================
createFlash = function(color)
    local flash = Instance.new("ColorCorrectionEffect", Lighting)
    flash.TintColor = color
    flash.Saturation = 0.5
    flash.Contrast = 0.2
    TweenService:Create(flash, TweenInfo.new(0.5), {
        Contrast = 0,
        Saturation = 0,
        TintColor = Color3.fromRGB(255, 255, 255)
    }):Play()
    Debris:AddItem(flash, 0.6)
end

--========================================
-- HIỆU ỨNG CHIÊU
--========================================
effectBlue = function()
    local color = Color3.fromRGB(80, 130, 255)
    createAura(color, 5, 1)
    createFFTrail(color, 1.5)
    if Root then createImpactRing(color, Root.Position + Root.CFrame.LookVector * 3, 15) end
    playSound(SOUND_IDS.Blue, 0.8, 1)
    shakeScreen(5, 0.3)
    punchFOV(6)
    createFlash(color)
end

effectRed = function()
    local color = Color3.fromRGB(255, 60, 60)
    createAura(color, 6, 1.2)
    createFFTrail(color, 1.5)
    if Root then createImpactRing(color, Root.Position + Root.CFrame.LookVector * 3, 20) end
    playSound(SOUND_IDS.Red, 0.9, 1)
    shakeScreen(8, 0.4)
    punchFOV(10)
    createFlash(color)
end

effectPurple = function()
    local color = Color3.fromRGB(180, 60, 255)
    createAura(color, 7, 1.5)
    createFFTrail(color, 2)
    if Root then createImpactRing(color, Root.Position + Root.CFrame.LookVector * 3, 25) end
    playSound(SOUND_IDS.Purple, 1, 1)
    shakeScreen(12, 0.6)
    punchFOV(15)
    createFlash(color)
end

effectRage = function()
    if not Root or not Root.Parent then return end
    rageActive = true
    playSound(SOUND_IDS.Rage, 1, 0.8)
    shakeScreen(30, 2)
    punchFOV(25)
    createFlash(Color3.fromRGB(255, 100, 255))

    local sphere = Instance.new("Part", workspace)
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = Vector3.new(5, 5, 5)
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.Material = Enum.Material.ForceField
    sphere.Color = Color3.fromRGB(180, 60, 255)
    sphere.Transparency = 0.2
    sphere.CFrame = Root.CFrame
    TweenService:Create(sphere, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(100, 100, 100),
        Transparency = 1
    }):Play()
    Debris:AddItem(sphere, 2.5)

    local cc = Instance.new("ColorCorrectionEffect", Lighting)
    cc.TintColor = Color3.fromRGB(255, 200, 255)
    cc.Contrast = 0.3
    cc.Saturation = 0.5
    Debris:AddItem(cc, 3)

    createAura(Color3.fromRGB(255, 0, 100), 12, 3)

    if rageConnection then rageConnection:Disconnect() end
    rageConnection = RunService.Heartbeat:Connect(function()
        if not rageActive then return end
        if Root and Root.Parent then
            local attach = Instance.new("Attachment", Root)
            local p = Instance.new("ParticleEmitter", attach)
            p.Texture = "rbxassetid://243660364"
            p.Color = ColorSequence.new(Color3.fromRGB(255, 0, 100))
            p.Size = NumberSequence.new(8)
            p.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                Number keysSequenceKeypoint.new(1, 1)
            })
            p.L.Sizeifetime = NumberRange.new(0.3, 0.5)
            p.Rate = 50
            p.Speed = NumberRange.new(10, 20)
            p.SpreadAngle = Vector2.new(180, 180)
            p.LightEmission = 1
            Debris:AddItem(attach, 0.6)
        end
    end)

    task.delay(10, function()
        rageActive = false
        if rageConnection then rageConnection:Disconnect() end
    end)
end

--========================================
-- HÀM BẮ =T CHIÊU (M1 & SKILL)
 U--========================================
local function onM1Pressed()
    if tick() - lastEffectTime < CONFIG.EffectCooldown then return end
    lastEffectTime = tick()
    local rand = math.random(1, 3)
    if rand == 1 then effectBlue()
    elseif rand == 2 then effectRed()
    else effectPurple() end
end

--========================================
-- KHỞI TẠO NHÂN VẬT
--========================================
setupCharacter = function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    Root = char:WaitForChild("HumanoidRootPart")
end

if Player.Character then setupCharacter(Player.Character) end
Player.CharacterAdded:Connect(setupCharacter)

--========================================
-- HUD
--========================================
createHUD = function()
    if not CONFIG.ShowHUD then return end
    if Player.PlayerGui:FindFirstChild("GojoHUD") then
        Player.PlayerGui.GojoHUD:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "GojoHUD"
    gui.ResetOnSpawn = false
    gui.Parent = Player.PlayerGui

    local main = Instance.new("Frame", gui)
    main.Name = "Main"
    main.Size = UDim2.new(0, 160, 0, 75)
    main.Position = UDim2.new(0, 10, 0, 10)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    main.BackgroundTransparency = 0.15
    main.BorderSizePixel = 0

    local corner = Instance.new("UICorner", main)
    corner.CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(120, 160, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2

    local hideBtn = Instance.new("TextButton", main)
    hideBtn.Size = UDim2.new(0, 18, 0, 18)
    hideBtn.Position = UDim2.new(1, -20, 0, 2)
    hideBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    hideBtn.Text = "X"
    hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hideBtn.TextSize = 11
    hideBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 4)
    hideBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        hudVisible = false
    end)

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, -25, 0, 16)
    title.Position = UDim2.new(0, 5, 0, 4)
    title.BackgroundTransparency = 1
    title.Text = "✨ " .. MOD_INFO.Name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 10
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left

    local version = Instance.new("TextLabel", main)
    version.Size = UDim2.new(1, -10, 0, 14)
    version.Position = UDim2.new(0, 5, 0, 22)
    version.BackgroundTransparency = 1
    version.Text = "📦 " .. MOD_INFO.Version .. " | ✍️ " .. MOD_INFO.Author
    version.TextColor3 = Color3.fromRGB(180, 200, 255)
    version.TextSize = 9
    version.Font = Enum.Font.Gotham
    version.TextXAlignment = Enum.TextXAlignment.Left

    local status = Instance.new("TextLabel", main)
    status.Size = UDim2.new(1, -10, 0, 14)
    status.Position = UDim2.new(0, 5, 0, 36)
    status.BackgroundTransparency = 1
    status.Text = "🟢 " .. MOD_INFO.Status
    status.TextColor3 = Color3.fromRGB(100, 255, 150)
    status.TextSize = 9
    status.Font = Enum.Font.GothamMedium
    status.TextXAlignment = Enum.TextXAlignment.Left

    local keys = Instance.new("TextLabel", main)
   Dim2.new(1, -10, 0, 14)
    keys.Position = UDim2.new(0, 5, 0, 50)
    keys.BackgroundTransparency = 1
    keys.Text = "Q💙 E❤️ R❤️ F💜 G🔥 H ẩn"
    keys.TextColor3 = Color3.fromRGB(255, 220, 150)
    keys.TextSize = 9
    keys.Font = Enum.Font.Gotham
    keys.TextXAlignment = Enum.TextXAlignment.Left

    main.Position = UDim2.new(0, -200, 0, 10)
    TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 10, 0, 10)
    }):Play()
end

--========================================
-- THÔNG BÁO
--========================================
showNotification = function(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 4
        })
    end)
end

--========================================
-- BLOOM
--========================================
pcall(function()
    local bloom = Lighting:FindFirstChild("GojoBloom")
    if not bloom then
        bloom = Instance.new("BloomEffect", Lighting)
        bloom.Name = "GojoBloom"
        bloom.Intensity = 1.5
        bloom.Size = 24
        bloom.Threshold = 1
    end
end)

--========================================
-- LẮNG NGHE PHÍM & M1
--========================================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end

    -- M1 (chuột trái)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        onM1Pressed()
    end

    -- Phím tắt test
    if input.KeyCode == Enum.KeyCode.Q then effectBlue()
    elseif input.KeyCode == Enum.KeyCode.E then effectRed()
    elseif input.KeyCode == Enum.KeyCode.R then effectRed()
    elseif input.KeyCode == Enum.KeyCode.F then effectPurple()
    elseif input.KeyCode == Enum.KeyCode.G then effectRage()
    elseif input.KeyCode == Enum.KeyCode.H then
        local hud = Player.PlayerGui:FindFirstChild("GojoHUD")
        if hud and hud:FindFirstChild("Main") then
            hud.Main.Visible = not hud.Main.Visible
            hudVisible = hud.Main.Visible
        end
    end
end)

--========================================
-- TẠO HUD & THÔNG BÁO
--========================================
createHUD()

showNotification("✨ GOJO MOD " .. MOD_INFO.Version .. " ✨", "Đã bật hiệu ứng Gojo cho Saitama~", 4)
task.delay(5, function()
    showNotification("🔥 Hiệu ứng Gojo", "Đấm thường (M1) hoặc bấm Q/E/R/F để test nha anh~", 4)
end)

print("🌸 " .. MOD_INFO.Name .. " " .. MOD_INFO.Version .. " - LOADED! 🌸")
