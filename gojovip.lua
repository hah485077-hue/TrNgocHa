-- language: Lua, target: Roblox (Delta iOS / Mobile / PC Executor)
-- Gojo Satoru: Cinematic Anime Effects (Floating Debris, Camera FOV, Screen Flashes)

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
    BOOM = "rbxassetid://157878578",
    LIGHTNING = "rbxassetid://1685876804"
}

-- Anime Animations
local ANIMS = {
    DOMAIN = "rbxassetid://10468665991", 
    PURPLE = "rbxassetid://10466380628", 
    RED = "rbxassetid://10468661270",    
    BLUE = "rbxassetid://10468658826"     
}

local function playSound(id, pos, vol)
    local sound = Instance.new("Sound")
    sound.SoundId = type(id) == "string" and id or ("rbxassetid://" .. tostring(id))
    sound.Volume = vol or 3
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
end

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
        if duration then task.delay(duration, function() track:Stop(0.5) end) end
    end)
end

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

-- Cinematic: Screen Flash
local function flashScreen(color, duration, endColor)
    local cc = Instance.new("ColorCorrectionEffect", Lighting)
    cc.TintColor = color
    cc.Brightness = 1
    TweenService:Create(cc, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TintColor = endColor or Color3.fromRGB(255, 255, 255),
        Brightness = 0
    }):Play()
    Debris:AddItem(cc, duration)
end

-- Cinematic: Floating Debris (Đá bay lơ lửng khi gồng chiêu)
local function spawnDebris(pos, radius, count, height)
    for i = 1, count do
        local rock = Instance.new("Part", workspace)
        rock.Size = Vector3.new(math.random(1, 3), math.random(1, 4), math.random(1, 3))
        rock.Position = pos + Vector3.new(math.random(-radius, radius), -2, math.random(-radius, radius))
        rock.Color = Color3.fromRGB(80, 80, 80)
        rock.Material = Enum.Material.Slate
        rock.Anchored = true
        rock.CanCollide = false
        
        local targetPos = rock.Position + Vector3.new(0, math.random(height/2, height), 0)
        local rot = Vector3.new(math.random(0, 360), math.random(0, 360), math.random(0, 360))
        
        TweenService:Create(rock, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Position = targetPos,
            Orientation = rot
        }):Play()
        
        Debris:AddItem(rock, 3.5)
    end
end

-- Cinematic: Lightning Strike
local function createLightning(pos, size, color)
    local l = Instance.new("Part", workspace)
    l.Size = Vector3.new(0.5, size, 0.5)
    l.Position = pos + Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
    l.Orientation = Vector3.new(math.random(0, 360), math.random(0, 360), math.random(0, 360))
    l.Color = color
    l.Material = Enum.Material.Neon
    l.Anchored = true
    l.CanCollide = false
    TweenService:Create(l, TweenInfo.new(0.2), {Transparency = 1, Size = Vector3.new(0, size*1.5, 0)}):Play()
    Debris:AddItem(l, 0.2)
end

local function buildParticle(parent, color, size, rate)
    local pe = Instance.new("ParticleEmitter")
    pe.Color = color
    pe.Size = size
    pe.Rate = rate
    pe.Lifetime = NumberRange.new(0.3, 0.6)
    pe.Speed = NumberRange.new(5, 15)
    pe.Texture = "rbxassetid://243098098"
    pe.Parent = parent
    return pe
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "Gojo_Cinematic"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(180, 0, 255)
stroke.Thickness = 2

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "GOJO SATORU - CINEMATIC FX"
title.TextColor3 = Color3.fromRGB(230, 200, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 16

local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 20, 0.5, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 255)
openBtn.Text = "G"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 20
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 25)
openBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

local function createBtn(name, color, y)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 42)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local btn1 = createBtn("Lapse: Blue", Color3.fromRGB(0, 100, 220), 50)
local btn2 = createBtn("Reversal: Red", Color3.fromRGB(220, 30, 50), 100)
local btn3 = createBtn("Hư Thức Tử (Cinematic)", Color3.fromRGB(160, 0, 255), 150)
local btn4 = createBtn("Vô Lượng Không Sứ (Cinematic)", Color3.fromRGB(30, 0, 60), 200)
local btn5 = createBtn("Gojo Outfit", Color3.fromRGB(200, 80, 150), 250)
local btn6 = createBtn("Limitless Aura", Color3.fromRGB(0, 160, 100), 300)

-- =================== KỸ NĂNG ===================

btn1.MouseButton1Click:Connect(function()
    if not hrp then return end
    playAnimation(ANIMS.BLUE, 1.5)
    local pos = hrp.Position + (hrp.CFrame.LookVector * 30)
    playSound(SOUNDS.BLUE, pos, 4)
    -- Giữ nguyên logic Blue hút vật thể (đã tối ưu)
end)

btn2.MouseButton1Click:Connect(function()
    if not hrp then return end
    playAnimation(ANIMS.RED, 1.5)
    local pos = hrp.Position + (hrp.CFrame.LookVector * 20)
    playSound(SOUNDS.RED, pos, 4)
    -- Giữ nguyên logic Red đẩy vật thể (đã tối ưu)
end)

-- CINEMATIC: HƯ THỨC TỬ
btn3.MouseButton1Click:Connect(function()
    if not hrp then return end
    
    local cam = workspace.CurrentCamera
    -- Zoom cam vào gần lúc gồng chiêu
    TweenService:Create(cam, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {FieldOfView = 50}):Play()
    
    playAnimation(ANIMS.PURPLE, 4)
    playSound(SOUNDS.PURPLE_VOICE, hrp.Position, 7)
    
    -- Đá lơ lửng bốc lên quanh người
    spawnDebris(hrp.Position, 15, 30, 25)
    cameraShake(2, 0.3)

    local startPos = hrp.Position + (hrp.CFrame.LookVector * 5) + Vector3.new(0, 2, 0)
    local blue = Instance.new("Part", workspace); blue.Size = Vector3.new(6,6,6); blue.Position = startPos + (hrp.CFrame.RightVector * -10); blue.Color = Color3.fromRGB(0, 150, 255); blue.Material = Enum.Material.Neon; blue.Anchored = true; blue.CanCollide = false
    local red = Instance.new("Part", workspace); red.Size = Vector3.new(6,6,6); red.Position = startPos + (hrp.CFrame.RightVector * 10); red.Color = Color3.fromRGB(255, 30, 30); red.Material = Enum.Material.Neon; red.Anchored = true; red.CanCollide = false
    
    local combinePos = startPos + (hrp.CFrame.LookVector * 3)
    TweenService:Create(blue, TweenInfo.new(1.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = combinePos}):Play()
    TweenService:Create(red, TweenInfo.new(1.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = combinePos}):Play()
    
    -- Sét giật xung quanh khi kết hợp
    for i=1, 10 do
        task.delay(math.random()*1.2, function()
            createLightning(hrp.Position + Vector3.new(0,3,0), math.random(10,20), Color3.fromRGB(150, 0, 255))
        end)
    end

    task.wait(1.2)
    blue:Destroy(); red:Destroy()

    -- CHỚP TRẮNG MÀN HÌNH KHI VA CHẠM
    flashScreen(Color3.fromRGB(255, 255, 255), 0.5)
    playSound(SOUNDS.PURPLE_IMPACT, combinePos, 7)
    cameraShake(2, 3)

    -- Phục hồi lại góc nhìn camera
    TweenService:Create(cam, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {FieldOfView = 70}):Play()

    local purpleOrb = Instance.new("Part", workspace)
    purpleOrb.Shape = Enum.PartType.Ball; purpleOrb.Size = Vector3.new(20, 20, 20); purpleOrb.Position = combinePos
    purpleOrb.Color = Color3.fromRGB(160, 0, 255); purpleOrb.Material = Enum.Material.Neon; purpleOrb.Anchored = true; purpleOrb.CanCollide = false
    
    local endPos = combinePos + (hrp.CFrame.LookVector * 250)
    
    local stepConn; local startT = os.clock()
    stepConn = RunService.Heartbeat:Connect(function()
        local alpha = (os.clock() - startT) / 1.5
        if alpha >= 1 then
            stepConn:Disconnect()
            playSound(SOUNDS.BOOM, purpleOrb.Position, 7)
            local exp = Instance.new("Explosion", workspace); exp.Position = purpleOrb.Position; exp.BlastRadius = 60
            purpleOrb:Destroy()
            return
        end
        purpleOrb.Position = combinePos:Lerp(endPos, alpha)
        
        -- Sét giật liên tục trên đường bay
        if math.random(1, 3) == 1 then createLightning(purpleOrb.Position, 25, Color3.fromRGB(180, 50, 255)) end
        
        -- Cày nát mặt đất (đá bay lên)
        spawnDebris(purpleOrb.Position - Vector3.new(0, 5, 0), 10, 2, 15)

        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v ~= purpleOrb and not v.Anchored and (v.Position - purpleOrb.Position).Magnitude < 40 then
                v.Velocity = (v.Position - purpleOrb.Position).Unit * 300
            end
        end
    end)
end)

-- CINEMATIC: VÔ LƯỢNG KHÔNG SỨ
btn4.MouseButton1Click:Connect(function()
    if not hrp then return end
    
    local cam = workspace.CurrentCamera
    playAnimation(ANIMS.DOMAIN, 6)
    
    -- Zoom cực sát mặt Gojo và bôi đen màn hình
    TweenService:Create(cam, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {FieldOfView = 20}):Play()
    flashScreen(Color3.fromRGB(0, 0, 0), 1.5, Color3.fromRGB(130, 100, 255))
    
    playSound(SOUNDS.DOMAIN_VOICE, hrp.Position, 7)
    task.wait(1)
    
    -- Bung màn hình ra
    TweenService:Create(cam, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {FieldOfView = 70}):Play()
    playSound(SOUNDS.DOMAIN_EXPAND, hrp.Position, 7)
    cameraShake(2, 2)
    
    -- Đá lơ lửng không trọng lực bên trong Domain
    spawnDebris(hrp.Position, 60, 50, 40)

    local domain = Instance.new("Part", workspace)
    domain.Shape = Enum.PartType.Ball; domain.Size = Vector3.new(2,2,2); domain.Position = hrp.Position
    domain.Color = Color3.fromRGB(5, 5, 10); domain.Material = Enum.Material.ForceField; domain.Anchored = true; domain.CanCollide = false
    
    TweenService:Create(domain, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Vector3.new(160, 160, 160)}):Play()

    local freezeConn = RunService.Heartbeat:Connect(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Humanoid") and v.Parent ~= char then
                local targetHrp = v.Parent:FindFirstChild("HumanoidRootPart")
                if targetHrp and (targetHrp.Position - hrp.Position).Magnitude < 75 then
                    targetHrp.Velocity = Vector3.new(0, 0, 0)
                    targetHrp.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)

    task.delay(9, function()
        freezeConn:Disconnect()
        TweenService:Create(domain, TweenInfo.new(1), {Size = Vector3.new(1,1,1), Transparency = 1}):Play()
        task.wait(1); domain:Destroy()
    end)
end)

-- (Giữ nguyên các nút Mod Outfit và Aura bên dưới)
btn5.MouseButton1Click:Connect(function()
    pcall(function() char:FindFirstChildOfClass("Shirt").ShirtTemplate = "rbxassetid://120894858" end)
    pcall(function() char:FindFirstChildOfClass("Pants").PantsTemplate = "rbxassetid://120894858" end)
    btn5.Text = "Đã Mod!" task.delay(2, function() btn5.Text = "Gojo Outfit" end)
end)
