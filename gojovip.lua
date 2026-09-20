-- language: Lua, target: Roblox (Delta iOS / Mobile / PC Executor)
-- Gojo Satoru Script (Full Animation, Voice, and Visual Effects)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = newChar:WaitForChild("HumanoidRootPart")
end)

-- Sound Assets
local SOUNDS = {
    BLUE = "rbxassetid://9114223179",
    RED = "rbxassetid://9114222986",
    PURPLE_VOICE = "rbxassetid://7435165623",
    PURPLE_IMPACT = "rbxassetid://9114223403",
    DOMAIN_VOICE = "rbxassetid://6542823628",
    DOMAIN_EXPAND = "rbxassetid://9114223635",
    BOOM = "rbxassetid://157878578"
}

-- Character Animation Assets (Gojo Pose / Hand Signs)
local ANIMS = {
    DOMAIN = "rbxassetid://10468665991", -- Kết ấn Vô Lượng Không Sứ
    PURPLE = "rbxassetid://10466380628", -- Tư thế gồng / đẩy Hư Thức Tử
    RED = "rbxassetid://10468661270",    -- Bắn Hách (Chỉ tay)
    BLUE = "rbxassetid://10468658826"     -- Bắn Thương (Xòe tay)
}

-- Play Sound Engine
local function playSound(id, pos, vol, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = type(id) == "string" and id or ("rbxassetid://" .. tostring(id))
    sound.Volume = vol or 3
    sound.PlaybackSpeed = pitch or 1
    
    if pos then
        local att = Instance.new("Attachment", workspace.Terrain)
        att.WorldPosition = pos
        sound.Parent = att
        Debris:AddItem(att, 7)
    else
        sound.Parent = workspace
    end
    
    sound:Play()
    Debris:AddItem(sound, 7)
    return sound
end

-- Play Character Body Animation
local function playAnimation(animId, duration)
    pcall(function()
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
        
        local anim = Instance.new("Animation")
        anim.AnimationId = type(animId) == "string" and animId or ("rbxassetid://" .. tostring(animId))
        
        local track = animator:LoadAnimation(anim)
        track.Priority = Enum.AnimationPriority.Action
        track:Play()
        
        if duration then
            task.delay(duration, function()
                track:Stop(0.3)
            end)
        end
    end)
end

-- Camera Shake Effect
local function cameraShake(duration, intensity)
    task.spawn(function()
        local cam = workspace.CurrentCamera
        local start = os.clock()
        while os.clock() - start < duration do
            local dx = (math.random() - 0.5) * intensity
            local dy = (math.random() - 0.5) * intensity
            cam.CFrame = cam.CFrame * CFrame.Angles(math.rad(dx), math.rad(dy), 0)
            RunService.RenderStepped:Wait()
        end
    end)
end

-- Particle Generator Helper
local function buildParticle(parent, colorSequence, sizeSequence, rate, lifetime, speed)
    local pe = Instance.new("ParticleEmitter")
    pe.Color = colorSequence
    pe.Size = sizeSequence
    pe.Rate = rate
    pe.Lifetime = lifetime
    pe.Speed = speed
    pe.Texture = "rbxassetid://243098098"
    pe.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    pe.Parent = parent
    return pe
end

-- GUI Interface Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GojoV6_FullAnime"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 420)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(170, 50, 255)
stroke.Thickness = 2.5

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "GOJO SATORU — FULL ANIME"
title.TextColor3 = Color3.fromRGB(230, 180, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 15

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 14)
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 55, 0, 55)
openBtn.Position = UDim2.new(0, 15, 0.5, -27)
openBtn.BackgroundColor3 = Color3.fromRGB(140, 20, 240)
openBtn.Text = "GOJO"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 12
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 28)
openBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

local function createBtn(name, color, y)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.88, 0, 0, 40)
    btn.Position = UDim2.new(0.06, 0, 0, y)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local btn1 = createBtn("Lapse: Blue (Hút + Anim)", Color3.fromRGB(0, 110, 240), 55)
local btn2 = createBtn("Reversal: Red (Đẩy + Anim)", Color3.fromRGB(240, 40, 60), 103)
local btn3 = createBtn("Hư Thức Tử (Anim + Voice + Va Chạm)", Color3.fromRGB(150, 0, 255), 151)
local btn4 = createBtn("Vô Lượng Không Sứ (Kết Ấn + Voice)", Color3.fromRGB(40, 10, 90), 199)
local btn5 = createBtn("Mod Gojo Outfit", Color3.fromRGB(220, 80, 160), 247)
local btn6 = createBtn("Bật/Tắt Hào Quang", Color3.fromRGB(0, 180, 120), 295)

-- 1. LAPSE BLUE
btn1.MouseButton1Click:Connect(function()
    if not hrp then return end
    playAnimation(ANIMS.BLUE, 1.8)
    
    local spawnPos = hrp.Position + (hrp.CFrame.LookVector * 35)
    playSound(SOUNDS.BLUE, spawnPos, 4)
    
    local core = Instance.new("Part", workspace)
    core.Shape = Enum.PartType.Ball
    core.Size = Vector3.new(2, 2, 2)
    core.Position = spawnPos
    core.Color = Color3.fromRGB(10, 10, 10)
    core.Material = Enum.Material.SmoothPlastic
    core.Anchored = true
    core.CanCollide = false

    local outer = Instance.new("Part", workspace)
    outer.Shape = Enum.PartType.Ball
    outer.Size = Vector3.new(12, 12, 12)
    outer.Position = spawnPos
    outer.Color = Color3.fromRGB(0, 140, 255)
    outer.Material = Enum.Material.ForceField
    outer.Anchored = true
    outer.CanCollide = false

    buildParticle(core, ColorSequence.new(Color3.fromRGB(0, 180, 255)), NumberSequence.new(1.5, 0), 300, NumberRange.new(0.3, 0.6), NumberRange.new(-20, -10))

    TweenService:Create(outer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = Vector3.new(18, 18, 18)}):Play()
    cameraShake(1.5, 0.8)

    task.spawn(function()
        for _ = 1, 30 do
            task.wait(0.05)
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v ~= core and v ~= outer and not v.Anchored and (v.Position - spawnPos).Magnitude < 60 then
                    v.Velocity = (spawnPos - v.Position).Unit * 180
                end
            end
        end
    end)

    task.delay(1.8, function()
        playSound(SOUNDS.BOOM, spawnPos, 3)
        core:Destroy()
        outer:Destroy()
    end)
end)

-- 2. REVERSAL RED
btn2.MouseButton1Click:Connect(function()
    if not hrp then return end
    playAnimation(ANIMS.RED, 1.5)
    
    local spawnPos = hrp.Position + (hrp.CFrame.LookVector * 20)
    playSound(SOUNDS.RED, spawnPos, 4)

    local orb = Instance.new("Part", workspace)
    orb.Shape = Enum.PartType.Ball
    orb.Size = Vector3.new(4, 4, 4)
    orb.Position = spawnPos
    orb.Color = Color3.fromRGB(255, 30, 30)
    orb.Material = Enum.Material.Neon
    orb.Anchored = true
    orb.CanCollide = false

    buildParticle(orb, ColorSequence.new(Color3.fromRGB(255, 50, 50)), NumberSequence.new(0.5, 3), 200, NumberRange.new(0.2, 0.5), NumberRange.new(15, 30))

    TweenService:Create(orb, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(14, 14, 14)}):Play()
    
    task.wait(0.4)
    playSound(SOUNDS.BOOM, spawnPos, 5)
    cameraShake(0.8, 2)

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v ~= orb and not v.Anchored and (v.Position - spawnPos).Magnitude < 80 then
            v.Velocity = (v.Position - spawnPos).Unit * 300 + Vector3.new(0, 50, 0)
        end
    end

    local wave = Instance.new("Part", workspace)
    wave.Shape = Enum.PartType.Ball
    wave.Size = Vector3.new(2, 2, 2)
    wave.Position = spawnPos
    wave.Color = Color3.fromRGB(255, 0, 50)
    wave.Material = Enum.Material.ForceField
    wave.Anchored = true
    wave.CanCollide = false

    TweenService:Create(wave, TweenInfo.new(0.5), {Size = Vector3.new(50, 50, 50), Transparency = 1}):Play()
    orb:Destroy()
    Debris:AddItem(wave, 0.5)
end)

-- 3. HOLLOW PURPLE (ANIM + VOICE + VA CHẠM TÍM)
btn3.MouseButton1Click:Connect(function()
    if not hrp then return end
    
    -- Chạy Hoạt Ảnh Gồng Chiêu của Gojo
    playAnimation(ANIMS.PURPLE, 3.5)
    
    playSound(SOUNDS.PURPLE_VOICE, hrp.Position, 6)

    local startPos = hrp.Position + (hrp.CFrame.LookVector * 4) + Vector3.new(0, 2, 0)
    local leftPos = startPos + (hrp.CFrame.RightVector * -8)
    local rightPos = startPos + (hrp.CFrame.RightVector * 8)

    local blue = Instance.new("Part", workspace)
    blue.Shape = Enum.PartType.Ball
    blue.Size = Vector3.new(5, 5, 5)
    blue.Position = leftPos
    blue.Color = Color3.fromRGB(0, 150, 255)
    blue.Material = Enum.Material.Neon
    blue.Anchored = true
    blue.CanCollide = false

    local red = Instance.new("Part", workspace)
    red.Shape = Enum.PartType.Ball
    red.Size = Vector3.new(5, 5, 5)
    red.Position = rightPos
    red.Color = Color3.fromRGB(255, 30, 30)
    red.Material = Enum.Material.Neon
    red.Anchored = true
    red.CanCollide = false

    buildParticle(blue, ColorSequence.new(Color3.fromRGB(0, 180, 255)), NumberSequence.new(1, 0), 150, NumberRange.new(0.2, 0.4), NumberRange.new(5, 10))
    buildParticle(red, ColorSequence.new(Color3.fromRGB(255, 50, 50)), NumberSequence.new(1, 0), 150, NumberRange.new(0.2, 0.4), NumberRange.new(5, 10))

    cameraShake(1.2, 0.5)

    local combinePos = startPos + (hrp.CFrame.LookVector * 2)
    TweenService:Create(blue, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = combinePos, Size = Vector3.new(2,2,2)}):Play()
    TweenService:Create(red, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = combinePos, Size = Vector3.new(2,2,2)}):Play()

    task.wait(1.1)

    blue:Destroy()
    red:Destroy()

    playSound(SOUNDS.PURPLE_IMPACT, combinePos, 6)
    cameraShake(1.5, 2.5)

    local purpleCore = Instance.new("Part", workspace)
    purpleCore.Shape = Enum.PartType.Ball
    purpleCore.Size = Vector3.new(4, 4, 4)
    purpleCore.Position = combinePos
    purpleCore.Color = Color3.fromRGB(150, 0, 255)
    purpleCore.Material = Enum.Material.Neon
    purpleCore.Anchored = true
    purpleCore.CanCollide = false

    local innerVoid = Instance.new("Part", workspace)
    innerVoid.Shape = Enum.PartType.Ball
    innerVoid.Size = Vector3.new(2, 2, 2)
    innerVoid.Position = combinePos
    innerVoid.Color = Color3.fromRGB(0, 0, 0)
    innerVoid.Material = Enum.Material.SmoothPlastic
    innerVoid.Anchored = true
    innerVoid.CanCollide = false

    local aura = Instance.new("Part", workspace)
    aura.Shape = Enum.PartType.Ball
    aura.Size = Vector3.new(6, 6, 6)
    aura.Position = combinePos
    aura.Color = Color3.fromRGB(180, 50, 255)
    aura.Material = Enum.Material.ForceField
    aura.Anchored = true
    aura.CanCollide = false

    buildParticle(purpleCore, ColorSequence.new(Color3.fromRGB(190, 60, 255)), NumberSequence.new(2, 0), 400, NumberRange.new(0.3, 0.8), NumberRange.new(10, 25))

    TweenService:Create(purpleCore, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = Vector3.new(18, 18, 18)}):Play()
    TweenService:Create(innerVoid, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = Vector3.new(12, 12, 12)}):Play()
    TweenService:Create(aura, TweenInfo.new(0.6), {Size = Vector3.new(24, 24, 24)}):Play()

    task.wait(0.6)

    local targetDirection = hrp.CFrame.LookVector
    local distance = 180
    local travelTime = 1.8
    local endPos = combinePos + (targetDirection * distance)

    cameraShake(travelTime, 1.8)

    local stepConn
    local startTime = os.clock()

    stepConn = RunService.Heartbeat:Connect(function()
        local elapsed = os.clock() - startTime
        local alpha = math.clamp(elapsed / travelTime, 0, 1)
        local currentPos = combinePos:Lerp(endPos, alpha)

        purpleCore.Position = currentPos
        innerVoid.Position = currentPos
        aura.Position = currentPos

        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v ~= purpleCore and v ~= innerVoid and v ~= aura and not v.Anchored and (v.Position - currentPos).Magnitude < 35 then
                v.Velocity = (v.Position - currentPos).Unit * 250 + Vector3.new(0, 40, 0)
            end
        end

        if alpha >= 1 then
            stepConn:Disconnect()
            playSound(SOUNDS.BOOM, endPos, 6)

            local exp = Instance.new("Explosion", workspace)
            exp.Position = endPos
            exp.BlastRadius = 45

            purpleCore:Destroy()
            innerVoid:Destroy()
            aura:Destroy()
        end
    end)
end)

-- 4. UNLIMITED VOID (KẾT ẤN + VOICE + BẢO VỆ MIỀN)
btn4.MouseButton1Click:Connect(function()
    if not hrp then return end
    local pos = hrp.Position

    -- Chạy Hoạt Ảnh Kết Ấn Của Gojo
    playAnimation(ANIMS.DOMAIN, 5.0)

    playSound(SOUNDS.DOMAIN_VOICE, pos, 6)
    task.wait(0.8)
    playSound(SOUNDS.DOMAIN_EXPAND, pos, 6)

    local cc = Instance.new("ColorCorrectionEffect", Lighting)
    cc.Brightness = -0.3
    cc.Contrast = 0.8
    cc.TintColor = Color3.fromRGB(130, 100, 255)
    Debris:AddItem(cc, 9)

    local domain = Instance.new("Part", workspace)
    domain.Shape = Enum.PartType.Ball
    domain.Size = Vector3.new(4, 4, 4)
    domain.Position = pos
    domain.Color = Color3.fromRGB(5, 5, 12)
    domain.Material = Enum.Material.ForceField
    domain.Anchored = true
    domain.CanCollide = false
    domain.Transparency = 0.1

    local outerShell = Instance.new("Part", workspace)
    outerShell.Shape = Enum.PartType.Ball
    outerShell.Size = Vector3.new(4, 4, 4)
    outerShell.Position = pos
    outerShell.Color = Color3.fromRGB(120, 0, 255)
    outerShell.Material = Enum.Material.Neon
    outerShell.Anchored = true
    outerShell.CanCollide = false
    outerShell.Transparency = 0.8

    buildParticle(domain, ColorSequence.new(Color3.fromRGB(255, 255, 255)), NumberSequence.new(0.8, 0.2), 600, NumberRange.new(3, 6), NumberRange.new(0, 5))

    TweenService:Create(domain, TweenInfo.new(1.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Vector3.new(140, 140, 140)}):Play()
    TweenService:Create(outerShell, TweenInfo.new(1.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Vector3.new(144, 144, 144)}):Play()

    cameraShake(1.5, 2)

    local freezeConn
    freezeConn = RunService.Heartbeat:Connect(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Humanoid") and v.Parent ~= char then
                local targetHrp = v.Parent:FindFirstChild("HumanoidRootPart")
                if targetHrp and (targetHrp.Position - pos).Magnitude < 65 then
                    targetHrp.Velocity = Vector3.new(0, 0, 0)
                    targetHrp.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)

    task.delay(8, function()
        freezeConn:Disconnect()
        TweenService:Create(domain, TweenInfo.new(1), {Size = Vector3.new(1, 1, 1), Transparency = 1}):Play()
        TweenService:Create(outerShell, TweenInfo.new(1), {Size = Vector3.new(1, 1, 1), Transparency = 1}):Play()
        task.wait(1)
        domain:Destroy()
        outerShell:Destroy()
    end)
end)

-- 5. MOD GOJO OUTFIT
btn5.MouseButton1Click:Connect(function()
    if not char then return end

    pcall(function()
        local shirt = char:FindFirstChildOfClass("Shirt") or Instance.new("Shirt", char)
        shirt.ShirtTemplate = "rbxassetid://120894858"
        local pants = char:FindFirstChildOfClass("Pants") or Instance.new("Pants", char)
        pants.PantsTemplate = "rbxassetid://120894858"
    end)

    local head = char:FindFirstChild("Head")
    if head then
        if not head:FindFirstChild("GojoHair") then
            local hair = Instance.new("Part", head)
            hair.Name = "GojoHair"
            hair.Size = Vector3.new(1.6, 1.2, 1.6)
            hair.Color = Color3.fromRGB(245, 245, 255)
            hair.Material = Enum.Material.SmoothPlastic
            hair.CanCollide = false
            hair.CFrame = head.CFrame * CFrame.new(0, 0.65, 0)
            
            local weld = Instance.new("WeldConstraint", hair)
            weld.Part0 = head
            weld.Part1 = hair
        end

        if not head:FindFirstChild("Blindfold") then
            local fold = Instance.new("Part", head)
            fold.Name = "Blindfold"
            fold.Size = Vector3.new(1.3, 0.45, 1.2)
            fold.Color = Color3.fromRGB(15, 15, 15)
            fold.Material = Enum.Material.SmoothPlastic
            fold.CanCollide = false
            fold.CFrame = head.CFrame * CFrame.new(0, 0.1, -0.05)

            local weld = Instance.new("WeldConstraint", fold)
            weld.Part0 = head
            weld.Part1 = fold
        end
    end

    btn5.Text = "Đã Trang Bị Đồ Gojo!"
    task.delay(2, function() btn5.Text = "Mod Gojo Outfit" end)
end)

-- 6. LIMITLESS AURA
local auraActive = false
local auraPart = nil
local auraConn = nil

btn6.MouseButton1Click:Connect(function()
    if not hrp then return end
    auraActive = not auraActive

    if auraActive then
        btn6.Text = "Hào Quang: BẬT"
        btn6.BackgroundColor3 = Color3.fromRGB(0, 230, 140)

        auraPart = Instance.new("Part", workspace)
        auraPart.Shape = Enum.PartType.Ball
        auraPart.Size = Vector3.new(10, 10, 10)
        auraPart.Color = Color3.fromRGB(140, 40, 255)
        auraPart.Material = Enum.Material.ForceField
        auraPart.CanCollide = false
        auraPart.Anchored = true

        buildParticle(auraPart, ColorSequence.new(Color3.fromRGB(160, 60, 255)), NumberSequence.new(0.8, 0), 100, NumberRange.new(0.3, 0.6), NumberRange.new(2, 6))

        auraConn = RunService.RenderStepped:Connect(function()
            if hrp and auraPart then
                auraPart.Position = hrp.Position
            end
        end)
    else
        btn6.Text = "Bật/Tắt Hào Quang"
        btn6.BackgroundColor3 = Color3.fromRGB(0, 180, 120)

        if auraConn then auraConn:Disconnect() end
        if auraPart then auraPart:Destroy() end
    end
end)
