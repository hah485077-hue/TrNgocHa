-- ==========================================
-- GOJO SATORU FULL EFFECTS (MOBILE VERSION)
-- ==========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Hàm tự động tìm mục tiêu (Dùng cho cả PC và Điện thoại)
local function getTargetPosition()
    local rayOrigin = camera.CFrame.Position
    local rayDirection = camera.CFrame.LookVector * 150 -- Tầm xa 150 studs
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if result then
        return result.Position
    else
        return rayOrigin + rayDirection
    end
end

-- Tạo GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GojoFullEffectGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 260) -- Thu nhỏ lại một chút cho vừa màn hình đt
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(120, 0, 255)
stroke.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "GOJO SATORU (MOBILE)"
title.TextColor3 = Color3.fromRGB(180, 130, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 16
title.Parent = mainFrame

local function createBtn(text, color, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.Position = UDim2.new(0.075, 0, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = mainFrame
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = btn
    return btn
end

local btnBlue = createBtn("Lapse: Blue", Color3.fromRGB(0, 120, 255), 50)
local btnRed = createBtn("Reversal: Red", Color3.fromRGB(255, 60, 60), 100)
local btnPurple = createBtn("Hollow Purple", Color3.fromRGB(160, 0, 255), 150)
local btnDomain = createBtn("Domain Expansion", Color3.fromRGB(80, 0, 150), 200)

-- Hàm tạo âm thanh
local function playSound(id, pos)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. id
    sound.Volume = 2
    sound.Parent = workspace
    if pos then sound.Position = pos end
    sound:Play()
    Debris:AddItem(sound, 5)
end

-- 1. BLUE (Lapse: Blue)
btnBlue.MouseButton1Click:Connect(function()
    local pos = getTargetPosition() -- Tự động lấy vị trí camera
    playSound(6895963173, pos)
    
    local orb = Instance.new("Part")
    orb.Shape = Enum.PartType.Ball
    orb.Size = Vector3.new(10, 10, 10)
    orb.Color = Color3.fromRGB(0, 150, 255)
    orb.Material = Enum.Material.Neon
    orb.Anchored = true
    orb.CanCollide = false
    orb.Position = pos
    orb.Parent = workspace

    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(0, 150, 255)
    light.Range = 40
    light.Brightness = 5
    light.Parent = orb

    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxassetid://243098098"
    particles.Color = ColorSequence.new(Color3.fromRGB(0, 150, 255))
    particles.Rate = 100
    particles.Speed = NumberRange.new(5, 10)
    particles.Parent = orb

    task.spawn(function()
        for i = 1, 30 do
            task.wait(0.05)
            if not orb.Parent then break end
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v ~= orb and not v.Anchored and (v.Position - orb.Position).Magnitude < 60 then
                    v.Velocity = (orb.Position - v.Position).Unit * 120
                end
            end
        end
    end)

    task.delay(2, function()
        local explode = Instance.new("Explosion")
        explode.BlastRadius = 20
        explode.Position = orb.Position
        explode.Parent = workspace
        orb:Destroy()
    end)
end)

-- 2. RED (Reversal: Red)
btnRed.MouseButton1Click:Connect(function()
    local pos = getTargetPosition()
    playSound(6895963173, pos)
    
    local orb = Instance.new("Part")
    orb.Shape = Enum.PartType.Ball
    orb.Size = Vector3.new(10, 10, 10)
    orb.Color = Color3.fromRGB(255, 50, 50)
    orb.Material = Enum.Material.Neon
    orb.Anchored = true
    orb.CanCollide = false
    orb.Position = pos
    orb.Parent = workspace

    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 50, 50)
    light.Range = 40
    light.Brightness = 5
    light.Parent = orb

    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxassetid://243098098"
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 50, 50))
    particles.Rate = domain 100
    particles.Speed = NumberRange.new(5.P, 10)
    particles.Parent = orb

osition    task.spawn(function()
        for i =  =1, 30 do
            task.wait( hr0.05)
            if not orb.Parent then break end
p            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v ~= orb and not v.Anchored and (v.Position - orb.Position).Magnitude < 60 then
                    v.Velocity = (v.Position - orb.Position).Unit * 150
                end
            end
        end
    end)

    task.delay(2, function()
        local explode = Instance.new("Explosion")
        explode.BlastRadius = 25
        explode.Position = orb.Position
        explode.Parent = workspace
        orb:Destroy()
    end)
end)

-- 3. HOLLOW PURPLE
btnPurple.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    local startPos = hrp.Position
    local endPos = getTargetPosition() -- Tự động lấy vị trí camera
    
    playSound(6895963173, startPos)
    
    local beam = Instance.new("Part")
    beam.Anchored = true
    beam.CanCollide = false
    beam.Material = Enum.Material.Neon
    beam.Color = Color3.fromRGB(160, 0, 255)
    beam.Size = Vector3.new(8, 8, (startPos - endPos).Magnitude)
    beam.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -beam.Size.Z/2)
    beam.Parent = workspace

    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(160, 0, 255)
    light.Range = 60
    light.Brightness = 8
    light.Parent = beam

    local originalCFrame = camera.CFrame
    local shakeTime = 2
    local shakeConn
    shakeConn = RunService.RenderStepped:Connect(function()
        shakeTime = shakeTime - 0.05
        if shakeTime <= 0 then shakeConn:Disconnect() return end
        camera.CFrame = originalCFrame * CFrame.new(math.random(-1,1), math.random(-1,1), 0)
    end)

    task.delay(3, function()
        beam:Destroy()
    end)
end)

-- 4. DOMAIN EXPANSION
btnDomain.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    playSound(6895963173, hrp.Position)
    
    local domain = Instance.new("Part")
    domain.Shape = Enum.PartType.Ball
    domain.Size = Vector3.new(80, 80, 80)
    domain.Color = Color3.fromRGB(0, 0, 0)
    domain.Material = Enum.Material.ForceField
    domain.Anchored = true
    domain.CanCollide = false
   .Position
    domain.Parent = workspace

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(40, 0, 80)
    highlight.OutlineColor = Color3.fromRGB(160, 0, 255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = domain

    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxassetid://243098098"
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    particles.Rate = 200
    particles.Speed = NumberRange.new(1, 5)
    particles.Size = NumberSequence.new(1)
    particles.Parent = domain

    local tween = TweenService:Create(domain, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.5})
    tween:Play()

    task.delay(6, function()
        tween:Cancel()
        domain:Destroy()
    end)
end)

print("Gojo Mobile Mod loaded!")
