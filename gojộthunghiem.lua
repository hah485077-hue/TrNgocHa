--[[
================================================================================
    ██████╗  ██████╗      ██╗ ██████╗     ███╗   ███╗ ██████╗ ██████╗ 
   ██╔════╝ ██╔═══██╗     ██║██╔═══██╗    ████╗ ████║██╔═══██╗██╔══██╗
   ██║  ███╗██║   ██║     ██║██║   ██║    ██╔████╔██║██║   ██║██║  ██║
   ██║   ██║██║   ██║██   ██║██║   ██║    ██║╚██╔╝██║██║   ██║██║  ██║
   ╚██████╔╝╚██████╔╝╚█████╔╝╚██████╔╝    ██║ ╚═╝ ██║╚██████╔╝██████╔╝
    ╚═════╝  ╚═════╝  ╚════╝  ╚═════╝     ╚═╝     ╚═╝ ╚═════╝ ╚═════╝ 
================================================================================
                        GOJO EFFECTS FOR SAITAMA
                            [ TSB MOD v2.0 ]
================================================================================
    - Hiệu ứng Gojo khi Saitama dùng chiêu
    - Giọng Gojo nói khi dùng chiêu
    - Rung màn hình + Camera Zoom
    - Hào quang + Trail + Impact Ring
    - Hiệu ứng Bật Nộ (Domain Expansion)
    - Chạy bằng Delta Executor / Fluxus / Codex
    - Tác giả: Em 💕
================================================================================
--]]

--========================================
-- SERVICES
--========================================
local Players              = game:GetService("Players")
local RunService           = game:GetService("RunService")
local UserInputService     = game:GetService("UserInputService")
local TweenService         = game:GetService("TweenService")
local Debris               = game:GetService("Debris")
local StarterGui           = game:GetService("StarterGui")
local Lighting             = game:GetService("Lighting")
local SoundService         = game:GetService("SoundService")
local ReplicatedStorage    = game:GetService("ReplicatedStorage")

--========================================
-- BIẾN TOÀN CỤC
--========================================
local Player     = Players.LocalPlayer
local Camera     = workspace.CurrentCamera

local Character  = nil
local Humanoid   = nil
local Root       = nil

local lastEffectTime = 0
local rageActive     = false
local rageConnection = nil
local hudVisible     = true

--========================================
-- THÔNG TIN MOD
--========================================
local MOD_INFO = {
    Name    = "GOJO EFFECTS",
    Version = "v2.0",
    Author  = "Em 💕",
    Status  = "ONLINE"
}

--========================================
-- CẤU HÌNH
--========================================
local CONFIG = {
    ScreenShake    = true,
    Sounds         = true,
    VoiceLines     = true,
    Aura           = true,
    Trail          = true,
    ImpactRing     = true,
    CameraZoom     = true,
    Bloom          = true,
    ShowHUD        = true,
    EffectCooldown = 0.4,
    RageDuration   = 10,
    MaxVoiceQueue  = 3
}

--========================================
-- SOUND IDS
--========================================
local SOUND_IDS = {
    -- Hiệu ứng chiêu
    Blue       = "rbxassetid://6042053626",
    Red        = "rbxassetid://6042053379",
    Purple     = "rbxassetid://6667923288",
    Rage       = "rbxassetid://1838218402",
    Impact     = "rbxassetid://4612375231",
    
    -- Giọng Gojo nói (nếu ID còn sống)
    Voice1     = "rbxassetid://6894714352",  -- "Nah, I'd win"
    Voice2     = "rbxassetid://6894714687",  -- "Throughout heaven and earth"
    Voice3     = "rbxassetid://6894715013",  -- "Domain Expansion"
    Voice4     = "rbxassetid://6894715345",  -- "Are you the strongest?"
    Voice5     = "rbxassetid://6894715687",  -- "Cursed Technique Lapse"
    Voice6     = "rbxassetid://6894715901",  -- "Hollow Purple"
    Voice7     = "rbxassetid://6894716123",  -- "Infinity"
    Voice8     = "rbxassetid://6894716345",  -- "Unlimited Void"
}

--========================================
-- DANH SÁCH CÂU NÓI GOJO
--========================================
local VOICE_LINES = {
    -- Câu nói cho chiêu xanh (M1, đấm thường)
    Blue = {
        SOUND_IDS.Voice1,
        SOUND_IDS.Voice5,
        SOUND_IDS.Voice7,
    },
    -- Câu nói cho chiêu đỏ (Skill mạnh)
    Red = {
        SOUND_IDS.Voice2,
        SOUND_IDS.Voice4,
        SOUND_IDS.Voice6,
    },
    -- Câu nói cho chiêu tím (Ultimate)
    Purple = {
        SOUND_IDS.Voice3,
        SOUND_IDS.Voice8,
        SOUND_IDS.Voice2,
    },
    -- Câu nói khi Bật Nộ
    Rage = {
        SOUND_IDS.Voice3,
        SOUND_IDS.Voice8,
        SOUND_IDS.Voice1,
    }
}

--========================================
-- KHAI BÁO HÀM TRƯỚC
--========================================
local effectBlue, effectRed, effectPurple, effectRage
local shakeScreen, playSound, playVoiceLine
local createAura, createFFTrail, createImpactRing
local punchFOV, createBeam, createFlash
local setupCharacter, onAnimationPlayed, createHUD
local showNotification, cleanupEffects

--========================================
-- HÀNG ĐỢI ÂM THANH (TRÁNH CHỒNG CHÉO)
--========================================
local voiceQueue = {}
local voicePlaying = false

local function processVoiceQueue()
    if voicePlaying then return end
    if #voiceQueue == 0 then return end
    
    voicePlaying = true
    local soundId = table.remove(voiceQueue, 1)
    
    local s = Instance.new("Sound")
    s.SoundId = soundId
    s.Volume = 1
    s.PlaybackSpeed = 1
    s.Parent = Root or SoundService
    s:Play()
    
    s.Ended:Connect(function()
        voicePlaying = false
        s:Destroy()
        task.wait(0.3)
        processVoiceQueue()
    end)
    
    task.delay(5, function()
        if s and s.Parent then
            voicePlaying = false
            s:Destroy()
        end
    end)
end

--========================================
-- HÀM PHÁT ÂM THANH
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
-- HÀM PHÁT GIỌNG GOJO
--========================================
playVoiceLine = function(effectType)
    if not CONFIG.VoiceLines then return end
    
    local lines = VOICE_LINES[effectType]
    if not lines then return end
    
    -- Giới hạn hàng đợi
    if #voiceQueue >= CONFIG.MaxVoiceQueue then
        table.remove(voiceQueue, 1)
    end
    
    local randomLine = lines[math.random(1, #lines)]
    table.insert(voiceQueue, randomLine)
    processVoiceQueue()
end

--========================================
-- HÀM RUNG MÀN HÌNH
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
        
        -- Rung theo nhịp sin/cos cho mượt
        local x = math.sin(elapsed * 50) * intensity
        local y = math.cos(elapsed * 60) * intensity
        local z = math.sin(elapsed * 70) * intensity * 0.5
        
        Camera.CFrame = originalCFrame * CFrame.new(x/100, y/100, z/100)
    end)
end

--========================================
-- HÀM CAMERA ZOOM (FOV)
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
-- HÀM TẠO HÀO QUANG (AURA)
--========================================
createAura = function(color, size, duration)
    if not CONFIG.Aura then return end
    if not Root or not Root.Parent then return end
    
    local attach = Instance.new("Attachment", Root)
    
    -- Lớp 1: Sao sáng bay lên
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
    p1.Rate = 180
    p1.Speed = NumberRange.new(10, 20)
    p1.SpreadAngle = Vector2.new(180, 180)
    p1.LightEmission = 1
    p1.LightInfluence = 0
    
    -- Lớp 2: Tia sáng mảnh
    local p2 = Instance.new("ParticleEmitter", attach)
    p2.Texture = "rbxassetid://296874871"
    p2.Color = ColorSequence.new(color)
    p2.Size = NumberSequence.new(size * 0.4)
    p2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    p2.Lifetime = NumberRange.new(0.4, 0.8)
    p2.Rate = 60
    p2.Speed = NumberRange.new(15, 25)
    p2.SpreadAngle = Vector2.new(180, 180)
    p2.LightEmission = 1
    
    -- Ánh sáng Neon
    local light = Instance.new("PointLight", attach)
    light.Color = color
    light.Range = 22
    light.Brightness = 6
    
    -- Vòng tròn dưới chân
    local ring = Instance.new("Part")
    ring.Shape = Enum.PartType.Cylinder
    ring.Size = Vector3.new(0.2, 5, 5)
    ring.Anchored = true
    ring.CanCollide = false
    ring.Material = Enum.Material.Neon
    ring.Color = color
    ring.Transparency = 0.15
    ring.CFrame = Root.CFrame * CFrame.Angles(0, 0, math.rad(90))
    ring.Parent = workspace
    
    TweenService:Create(ring, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.2, 28, 28),
        Transparency = 1
    }):Play()
    Debris:AddItem(ring, 1.5)
    
    task.delay(duration, function()
        if p1 and p1.Parent then p1.Enabled = false end
        if p2 and p2.Parent then p2.Enabled = false end
        task.wait(1.5)
        if attach and attach.Parent then attach:Destroy() end
    end)
end

--========================================
-- HÀM TẠO VỆT SÁNG (TRAIL)
--========================================
createFFTrail = function(color, duration)
    if not CONFIG.Trail then return end
    if not Character then return end
    
    local rightHand = Character:FindFirstChild("RightHand") or Character:FindFirstChild("Right Arm")
    local leftHand  = Character:FindFirstChild("LeftHand")  or Character:FindFirstChild("Left Arm")
    
    if not (rightHand and leftHand) then return end
    
    local att0 = Instance.new("Attachment", rightHand)
    local att1 = Instance.new("Attachment", leftHand)
    
    local trail = Instance.new("Trail", Character)
    trail.Attachment0 = att0
    trail.Attachment1 = att1
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
    Debris:AddItem(att0, duration)
    Debris:AddItem(att1, duration)
end

--========================================
-- HÀM TẠO VÒNG NỔ (IMPACT RING)
--========================================
createImpactRing = function(color, position, size)
    if not CONFIG.ImpactRing then return end
    
    -- Vòng nổ chính
    local ring = Instance.new("Part")
    ring.Shape = Enum.PartType.Cylinder
    ring.Size = Vector3.new(0.2, 2, 2)
    ring.Anchored = true
    ring.CanCollide = false
    ring.Material = Enum.Material.Neon
    ring.Color = color
    ring.Transparency = 0
    ring.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
    ring.Parent = workspace
    
    TweenService:Create(ring, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.2, size, size),
        Transparency = 1
    }):Play()
    Debris:AddItem(ring, 0.5)
    
    -- Vòng nổ thứ 2 (trắng sáng)
    local ring2 = Instance.new("Part")
    ring2.Shape = Enum.PartType.Cylinder
    ring2.Size = Vector3.new(0.3, 1, 1)
    ring2.Anchored = true
    ring2.CanCollide = false
    ring2.Material = Enum.Material.Neon
    ring2.Color = Color3.fromRGB(255, 255, 255)
    ring2.Transparency = 0
    ring2.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
    ring2.Parent = workspace
    
    TweenService:Create(ring2, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.3, size * 0.7, size * 0.7),
        Transparency = 1
    }):Play()
    Debris:AddItem(ring2, 0.4)
    
    -- Ánh sáng
    local light = Instance.new("PointLight", ring)
    light.Color = color
    light.Range = size * 2
    light.Brightness = 10
    Debris:AddItem(light, 0.4)
end

--========================================
-- HÀM TẠO TIA SÁNG (BEAM)
--========================================
createBeam = function(color, size)
    if not Root or not Root.Parent then return end
    
    local beam = Instance.new("Part")
    beam.Size = Vector3.new(size, size, size * 10)
    beam.Anchored = true
    beam.CanCollide = false
    beam.Material = Enum.Material.Neon
    beam.Color = color
    beam.Transparency = 0.2
    beam.CFrame = Root.CFrame * CFrame.new(0, 0, -size * 5)
    beam.Parent = workspace
    
    TweenService:Create(beam, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0, 0, 0),
        Transparency = 1
    }):Play()
    Debris:AddItem(beam, 0.5)
end

--========================================
-- HÀM TẠO FLASH (LÓE SÁNG)
--========================================
createFlash = function(color)
    local flash = Instance.new("ColorCorrectionEffect", Lighting)
    flash.TintColor = color
    flash.Saturation = 0.5
    flash.Contrast = 0.2
    
    TweenService:Create(flash, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Contrast = 0,
        Saturation = 0,
        TintColor = Color3.fromRGB(255, 255, 255)
    }):Play()
    
    Debris:AddItem(flash, 0.6)
end

--========================================
-- HIỆU ỨNG CHIÊU XANH (M1)
--========================================
effectBlue = function()
    local color = Color3.fromRGB(80, 130, 255)
    createAura(color, 6, 1)
    createFFTrail(color, 1.5)
    createBeam(color, 1.5)
    if Root then
        createImpactRing(color, Root.Position + Root.CFrame.LookVector * 3, 15)
    end
    playSound(SOUND_IDS.Blue, 0.8, 1)
    playVoiceLine("Blue")
    shakeScreen(5, 0.3)
    punchFOV(6)
    createFlash(color)
end

--========================================
-- HIỆU ỨNG CHIÊU ĐỎ (SKILL MẠNH)
--========================================
effectRed = function()
    local color = Color3.fromRGB(255, 60, 60)
    createAura(color, 7, 1.2)
    createFFTrail(color, 1.5)
    createBeam(color, 2)
    if Root then
        createImpactRing(color, Root.Position + Root.CFrame.LookVector * 3, 20)
    end
    playSound(SOUND_IDS.Red, 0.9, 1)
    playVoiceLine("Red")
    shakeScreen(8, 0.4)
    punchFOV(10)
    createFlash(color)
end

--========================================
-- HIỆU ỨNG CHIÊU TÍM (ULTIMATE)
--========================================
effectPurple = function()
    local color = Color3.fromRGB(180, 60, 255)
    createAura(color, 9, 1.5)
    createFFTrail(color, 2)
    createBeam(color, 2.5)
    if Root then
        createImpactRing(color, Root.Position + Root.CFrame.LookVector * 3, 25)
    end
    playSound(SOUND_IDS.Purple, 1, 1)
    playVoiceLine("Purple")
    shakeScreen(12, 0.6)
    punchFOV(15)
    createFlash(color)
end

--========================================
-- HIỆU ỨNG BẬT NỘ (DOMAIN EXPANSION)
--========================================
effectRage = function()
    if not Root or not Root.Parent then return end
    
    rageActive = true
    playSound(SOUND_IDS.Rage, 1, 0.8)
    playVoiceLine("Rage")
    shakeScreen(30, 2)
    punchFOV(25)
    createFlash(Color3.fromRGB(255, 100, 255))
    
    -- Quả cầu Domain Expansion
    local sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = Vector3.new(5, 5, 5)
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.Material = Enum.Material.ForceField
    sphere.Color = Color3.fromRGB(180, 60, 255)
    sphere.Transparency = 0.2
    sphere.CFrame = Root.CFrame
    sphere.Parent = workspace
    
    TweenService:Create(sphere, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(100, 100, 100),
        Transparency = 1
    }):Play()
    Debris:AddItem(sphere, 2.5)
    
    -- Quả cầu thứ 2 (trắng)
    local sphere2 = Instance.new("Part")
    sphere2.Shape = Enum.PartType.Ball
    sphere2.Size = Vector3.new(3, 3, 3)
    sphere2.Anchored = true
    sphere2.CanCollide = false
    sphere2.Material = Enum.Material.Neon
    sphere2.Color = Color3.fromRGB(255, 255, 255)
    sphere2.Transparency = 0.3
    sphere2.CFrame = Root.CFrame
    sphere2.Parent = workspace
    
    TweenService:Create(sphere2, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(80, 80, 80),
        Transparency = 1
    }):Play()
    Debris:AddItem(sphere2, 2)
    
    -- Đổi màu màn hình
    local cc = Instance.new("ColorCorrectionEffect", Lighting)
    cc.TintColor = Color3.fromRGB(255, 200, 255)
    cc.Contrast = 0.3
    cc.Saturation = 0.5
    Debris:AddItem(cc, 3)
    
    createAura(Color3.fromRGB(255, 0, 100), 15, 3)
    
    -- Hào quang liên tục khi Nộ
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
                NumberSequenceKeypoint.new(1, 1)
            })
            p.Lifetime = NumberRange.new(0.3, 0.5)
            p.Rate = 50
            p.Speed = NumberRange.new(10, 20)
            p.SpreadAngle = Vector2.new(180, 180)
            p.LightEmission = 1
            Debris:AddItem(attach, 0.6)
        end
    end)
    
    -- Tự tắt Rage sau N giây
    task.delay(CONFIG.RageDuration, function()
        rageActive = false
        if rageConnection then rageConnection:Disconnect() end
    end)
end

--========================================
-- HÀM BẮT ANIMATION
--========================================
onAnimationPlayed = function(animTrack)
    local animName = ""
    pcall(function()
        animName = string.lower(animTrack.Animation.Name)
    end)
    
    -- Bỏ qua animation đi bộ, đứng yên
    local ignoreList = {
        "idle", "walk", "run", "jump", "fall", "climb",
        "swim", "sit", "toolnone", "toolslash", "tooll.Nameunge"
    }
    for _, ig in ipairs(ignoreList) do
        if animName == ig then return end
    end
    
    -- Cooldown
    if tick() - lastEffectTime < CONFIG.EffectCooldown then return end
    
    -- Bắt Bật Nộ trước
    if string.find(animName, "rage")
    or string.find(animName, = "Go "joawaken")
H    or string.findUD(animName,"
 "mode")
       or string.find( guanimName, "iform") then
.        lastEffectTime = tick()
        effectRage()
        return
    end
    
    -- Bắt tất cả chiêu
    lastEffectTime = tick()
    local rand = math.random(1, 3)
    if rand == 1 then
        effectBlue()
    elseif rand == 2 then
        effectRed()
    else
        effectPurple()
    end
end

--========================================
-- HÀM KHỞI TẠO NHÂN VẬT
--========================================
setupCharacter = function(char)
    Character = char
    Humanoid  = char:WaitForChild("Humanoid")
    Root      = char:WaitForChild("HumanoidRootPart")
    
    Humanoid.AnimationPlayed:Connect(onAnimationPlayed)
end

--========================================
-- HÀM DỌN DẸP HIỆU ỨNG
--========================================
cleanupEffects = function()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Part") and obj.Material == Enum.Material.Neon then
            if obj.Name == "" or obj.Name == "Part" then
                -- Chỉ xóa nếu là part tạm
            end
        end
    end
end

--========================================
-- HÀM TẠO HUD
--========================================
createHUD = function()
    if not CONFIG.ShowHUD then return end
    
    if Player.PlayerGui:FindFirstChild("GojoHUD") then
        Player.PlayerGui.GojoHUD:Destroy()
    end
    
    local gui = Instance.new("ScreenGui")
    guiResetOnSpawn = false
    gui.Parent = Player.PlayerGui
    
    -- Khung chính
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 165, 0, 80)
    main.Position = UDim2.new(0, 10, 0, 10)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    main.BackgroundTransparency = 0.15
    main.BorderSizePixel = 0
    main.Parent = gui
    
    local corner = Instance.new("UICorner", main)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(120, 160, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2
    
    -- Nút tắt HUD
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
    
    -- Tiêu đề
    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, -25, 0, 16)
    title.Position = UDim2.new(0, 5, 0, 4)
    title.BackgroundTransparency = 1
    title.Text = "✨ " .. MOD_INFO.Name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 10
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Version
    local version = Instance.new("TextLabel", main)
    version.Size = UDim2.new(1, -10, 0, 14)
    version.Position = UDim2.new(0, 5, 0, 22)
    version.BackgroundTransparency = 1
    version.Text = "📦 " .. MOD_INFO.Version .. " | ✍️ " .. MOD_INFO.Author
    version.TextColor3 = Color3.fromRGB(180, 200, 255)
    version.TextSize = 9
    version.Font = Enum.Font.Gotham
    version.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Status
    local status = Instance.new("TextLabel", main)
    status.Size = UDim2.new(1, -10, 0, 14)
    status.Position = UDim2.new(0, 5, 0, 36)
    status.BackgroundTransparency = 1
    status.Text = "🟢 " .. MOD_INFO.Status
    status.TextColor3 = Color3.fromRGB(100, 255, 150)
    status.TextSize = 9
    status.Font = Enum.Font.GothamMedium
    status.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Phím tắt
    local keys = Instance.new("TextLabel", main)
    keys.Size = UDim2.new(1, -10, 0, 14)
    keys.Position = UDim2.new(0, 5, 0, 50)
    keys.BackgroundTransparency = 1
    keys.Text = "Q💙 E❤️ R❤️ F💜 G🔥 H ẩn"
    keys.TextColor3 = Color3.fromRGB(255, 220, 150)
    keys.TextSize = 9
    keys.Font = Enum.Font.Gotham
    keys.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Hiệu ứng xuất hiện
    main.Position = UDim2.new(0, -200, 0, 10)
    TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 10, 0, 10)
    }):Play()
end

--========================================
-- HÀM GỬI THÔNG BÁO
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
-- BLOOM EFFECT (PHÁT SÁNG)
--========================================
if CONFIG.Bloom then
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
end

--========================================
-- KHỞI TẠO
--========================================
if Player.Character then
    setupCharacter(Player.Character)
end
Player.CharacterAdded:Connect(setupCharacter)

--========================================
-- LẮNG NGHE PHÍM
--========================================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    if input.KeyCode == Enum.KeyCode.Q then
        effectBlue()
    elseif input.KeyCode == Enum.KeyCode.E then
        effectRed()
    elseif input.KeyCode == Enum.KeyCode.R then
        effectRed()
    elseif input.KeyCode == Enum.KeyCode.F then
        effectPurple()
    elseif input.KeyCode == Enum.KeyCode.G then
        effectRage()
    elseif input.KeyCode == Enum.KeyCode.H then
        local hud = Player.PlayerGui:FindFirstChild("GojoHUD")
        if hud and hud:FindFirstChild("Main") then
            hud.Main.Visible = not hud.Main.Visible
            hudVisible = hud.Main.Visible
        end
    end
end)

--========================================
-- TẠO HUD
--========================================
createHUD()

--========================================
-- THÔNG BÁO KHỞI ĐỘNG
--========================================
showNotification(
    "✨ GOJO MOD " .. MOD_INFO.Version .. " ✨",
    "Đã bật hiệu ứng Gojo cho Saitama~",
    4
)

task.delay(5, function()
    showNotification(
        "🎤 Giọng Gojo",
        "Nhấn Q/E/R/F để nghe giọng Gojo nha anh~",
        4
    )
end)

--========================================
-- IN LOG
--========================================
print("═══════════════════════════════════════════")
print("🌸 " .. MOD_INFO.Name .. " " .. MOD_INFO.Version .. " - LOADED! 🌸")
print("📦 Version: " .. MOD_INFO.Version)
print("✍️  Author: " .. MOD_INFO.Author)
print("🟢 Status: " .. MOD_INFO.Status)
print("───────────────────────────────────────────")
print("💙 Q = Blue Effect  (M1)")
print("❤️  E = Red Effect   (Skill)")
print("❤️  R = Red Effect   (Skill)")
print("💜 F = Purple Effect (Ultimate)")
print("🔥 G = Rage Mode    (Domain Expansion)")
print("👁️  H = Bật/tắt HUD")
print("═══════════════════════════════════════════")

--========================================
-- KẾT THÚC
--========================================
