-- ==========================================
-- GOJO SATORU V6 - BẢN CÓ TIẾNG NÓI (VOICE LINES)
-- Dành riêng cho anh iu của em trên Delta iOS
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- Biến lưu nhân vật
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Hàm cập nhật nhân vật khi chết/hồi sinh
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = newChar:WaitForChild("HumanoidRootPart")
end)

-- Tạo Menu GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "GojoV6Menu"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 280, 0, 400)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(180, 0, 255)
stroke.Thickness = 3

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "GOJO SATORU V6 - VOICE"
title.TextColor3 = Color3.fromRGB(220, 160, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 16

-- Nút Đóng (X) ở góc phải
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 15)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Nút Mở Menu (khi bị ẩn)
local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 10, 0.5, -25)
openBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
openBtn.Text = "Menu"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 10
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 25)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Hàm tạo nút bấm
local function createBtn(name, color, y)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.85, 0, 0, 38)
    btn.Position = UDim2.new(0.075, 0, 0, y)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

-- 6 CHỨC NĂNG CHÍNH
local btn1 = createBtn("Lapse: Blue (Hút)", Color3.fromRGB(0, 100, 255), 55)
local btn2 = createBtn("Reversal: Red (Đẩy)", Color3.fromRGB(255, 50, 50), 98)
local btn3 = createBtn("Hư Thức Tử (Có Tiếng)", Color3.fromRGB(160, 0, 255), 141)
local btn4 = createBtn("Vô Lượng Không Sứ (Có Tiếng)", Color3.fromRGB(60, 0, 120), 184)
local btn5 = createBtn("Mod Gojo Outfit", Color3.fromRGB(255, 105, 180), 227)
local btn6 = createBtn("Tắt/Bật Hào Quang", Color3.fromRGB(0, 200, 100), 270)

-- Hàm lấy hướng camera
local function getTargetPos(dist)
    if not hrp or not hrp.Parent then return nil end
    return hrp.Position + (hrp.CFrame.LookVector * (dist or 50))
end

-- Hàm phát âm thanh (Dùng pcall để chống lỗi trên đt)
local function playSound(id, pos, vol)
    pcall(function()
        local sound = Instance.new("Sound", workspace)
        sound.SoundId = "rbxassetid://" .. id
        sound.Volume = vol or 3
        if pos then sound.Position = pos end
        sound:Play()
        Debris:AddItem(sound, 6)
    end)
end

-- ==================== CÁC CHỨC NĂNG ====================

-- 1. LAPSE BLUE (HÚT + CAMERA RUNG)
btn1.MouseButton1Click:Connect(function()
    local pos = getTargetPos(40)
    if not pos then return end
    playSound(6895963173, pos, 2) -- Tiếng ù ù
    
    local orb = Instance.new("Part", workspace)
    orb.Shape = Enum.PartType.Ball
    orb.Size = Vector3.new(15, 15, 15)
    orb.Position = pos
    orb.Color = Color3.fromRGB(0, 150, 255)
    orb.Material = Enum.Material.Neon
    orb.Anchored = true
    orb.CanCollide = false
    orb.Transparency = 0.2

    local light = Instance.new("PointLight", orb)
    light.Color = Color3.fromRGB(0, 150, 255)
    light.Range = 50
    light.Brightness = 8

    local particles = Instance.new("ParticleEmitter", orb)
    particles.Texture = "rbxassetid://243098098"
    particles.Color = ColorSequence.new(Color3.fromRGB(0, 150, 255))
    particles.Rate = 200
    particles.Speed = NumberRange.new(10, 20)
    particles.Size = NumberSequence.new(2)

    task.spawn(function()
        for i = 1, 20 do
            task.wait(0.1)
            if not orb.Parent then break end
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v ~= orb and not v.Anchored and (v.Position - orb.Position).Magnitude < 70 then
                    v.Velocity = (orb.Position - v.Position).Unit * 150
                end
            end
        end
    end)

    local cam = workspace.CurrentCamera
    local orig = cam.CFrame
    local t = 0
    local conn
    conn = RunService.RenderStepped:Connect(function()
        t = t + 0.1
        if t > 2 then conn:Disconnect() return end
        cam.CFrame = orig * CFrame.new(math.random(-1,1), math.random(-1,1), 0)
    end)

    task.delay(2, function()
        if orb then
            local ex = Instance.new("Explosion", workspace)
            ex.BlastRadius = 25
            ex.Position = orb.Position
            orb:Destroy()
        end
    end)
end)

-- 2. REVERSAL RED (ĐẨY + CAMERA RUNG)
btn2.MouseButton1Click:Connect(function()
    local pos = getTargetPos(40)
    if not pos then return end
    playSound(6895963173, pos, 2)
    
    local orb = Instance.new("Part", workspace)
    orb.Shape = Enum.PartType.Ball
    orb.Size = Vector3.new(15, 15, 15)
    orb.Position = pos
    orb.Color = Color3.fromRGB(255, 50, 50)
    orb.Material = Enum.Material.Neon
    orb.Anchored = true
    orb.CanCollide = false
    orb.Transparency = 0.2

    local light = Instance.new("PointLight", orb)
    light.Color = Color3.fromRGB(255, 50, 50)
    light.Range = 50
    light.Brightness = 8

    local particles = Instance.new("ParticleEmitter", orb)
    particles.Texture = "rbxassetid://243098098"
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 50, 50))
    particles.Rate = 200
    particles.Speed = NumberRange.new(10, 20)
    particles.Size = NumberSequence.new(2)

    task.spawn(function()
        for i = 1, 20 do
            task.wait(0.1)
            if not orb.Parent then break end
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v ~= orb and not v.Anchored and (v.Position - orb.Position).Magnitude < 70 then
                    v.Velocity = (v.Position - orb.Position).Unit * 200
                end
            end
        end
    end)

    local cam = workspace.CurrentCamera
    local orig = cam.CFrame
    local t = 0
    local conn
    conn = RunService.RenderStepped:Connect(function()
        t = t + 0.1
        if t > 2 then conn:Disconnect() return end
        cam.CFrame = orig * CFrame.new(math.random(-1,1), math.random(-1,1), 0)
    end)

    task.delay(2, function()
        if orb then
            local ex = Instance.new("Explosion", workspace)
            ex.BlastRadius = 30
            ex.Position = orb.Position
            orb:Destroy()
        end
    end)
end)

-- 3. HƯ THỨC TỬ (HOLLOW PURPLE - 2 QUẢ CẦU VA CHẠM + TIẾNG NÓI)
btn3.MouseButton1Click:Connect(function()
    if not hrp or not hrp.Parent then return end
    
    -- Phát âm thanh Gojo nói "Hollow Purple"
    playSound(1837879086, hrp.Position, 5) 
    
    -- Tạo 2 quả cầu Đỏ và Xanh
    local blueOrb = Instance.new("Part", workspace)
    blueOrb.Shape = Enum.PartType.Ball
    blueOrb.Size = Vector3.new(8, 8, 8)
    blueOrb.Color = Color3.fromRGB(0, 150, 255)
    blueOrb.Material = Enum.Material.Neon
    blueOrb.Anchored = true
    blueOrb.CanCollide = false
    blueOrb.Position = hrp.Position + (hrp.CFrame.RightVector * -10) + (hrp.CFrame.LookVector * 10)

    local redOrb = Instance.new("Part", workspace)
    redOrb.Shape = Enum.PartType.Ball
    redOrb.Size = Vector3.new(8, 8, 8)
    redOrb.Color = Color3.fromRGB(255, 50, 50)
    redOrb.Material = Enum.Material.Neon
    redOrb.Anchored = true
    redOrb.CanCollide = false
    redOrb.Position = hrp.Position + (hrp.CFrame.RightVector * 10) + (hrp.CFrame.LookVector * 10)

    local l1 = Instance.new("PointLight", blueOrb); l1.Color = blueOrb.Color; l1.Range = 20; l1.Brightness = 5
    local l2 = Instance.new("PointLight", redOrb); l2.Color = redOrb.Color; l2.Range = 20; l2.Brightness = 5

    -- Tween 2 quả cầu bay vào nhau
    local centerPos = hrp.Position + (hrp.CFrame.LookVector * 5)
    local tween1 = TweenService:Create(blueOrb, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = centerPos})
    local tween2 = TweenService:Create(redOrb, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = centerPos})
    
    tween1:Play()
    tween2:Play()

    task.delay(1.5, function()
        if blueOrb then blueOrb:Destroy() end
        if redOrb then redOrb:Destroy() end
        
        -- Tạo quả cầu Tím khổng lồ
        local purpleOrb = Instance.new("Part", workspace)
        purpleOrb.Shape = Enum.PartType.Ball
        purpleOrb.Size = Vector3.new(25, 25, 25)
        purpleOrb.Color = Color3.fromRGB(160, 0, 255)
        purpleOrb.Material = Enum.Material.Neon
        purpleOrb.Anchored = true
        purpleOrb.CanCollide = false
        purpleOrb.Position = centerPos
        purpleOrb.Transparency = 0.2

        local light = Instance.new("PointLight", purpleOrb)
        light.Color = Color3.fromRGB(160, 0, 255)
        light.Range = 60
        light.Brightness = 10

        -- Bắn tia sáng
        local endPos = getTargetPos(100)
        if endPos then
            local beam = Instance.new("Part", workspace)
            beam.Anchored = true
            beam.CanCollide = false
            beam.Material = Enum.Material.Neon
            beam.Color = Color3.fromRGB(160, 0, 255)
            beam.Size = Vector3.new(15, 15, (centerPos - endPos).Magnitude)
            beam.CFrame = CFrame.new(centerPos, endPos) * CFrame.new(0, 0, -beam.Size.Z/2)
            beam.Transparency = 0.1
            
            local bl = Instance.new("PointLight", beam)
            bl.Color = Color3.fromRGB(160, 0, 255)
            bl.Range = 80
            bl.Brightness = 10

            task.delay(2, function() if beam then beam:Destroy() end end)
        end

        -- Camera rung mạnh
        local cam = workspace.CurrentCamera
        local orig = cam.CFrame
        local t = 0
        local conn
        conn = RunService.RenderStepped:Connect(function()
            t = t + 0.1
            if t > 2 then conn:Disconnect() return end
            cam.CFrame = orig * CFrame.new(math.random(-3,3), math.random(-3,3), 0)
        end)

        task.delay(3, function()
            if purpleOrb then purpleOrb:Destroy() end
        end)
    end)
end)

-- 4. VÔ LƯỢNG KHÔNG SỨ (DOMAIN EXPANSION - CÓ TIẾNG NÓI)
btn4.MouseButton1Click:Connect(function()
    if not hrp or not hrp.Parent then return end
    local pos = hrp.Position
    
    -- Phát âm thanh Gojo nói "Domain Expansion"
    playSound(1837878937, pos, 5)

    local domain = Instance.new("Part", workspace)
    domain.Shape = Enum.PartType.Ball
    domain.Size = Vector3.new(150, 150, 150)
    domain.Position = pos
    domain.Color = Color3.fromRGB(0, 0, 0)
    domain.Material = Enum.Material.ForceField
    domain.Anchored = true
    domain.CanCollide = false
    domain.Transparency = 0.4

    local blackHole = Instance.new("Part", workspace)
    blackHole.Shape = Enum.PartType.Ball
    blackHole.Size = Vector3.new(30, 30, 30)
    blackHole.Position = pos
    blackHole.Color = Color3.fromRGB(0, 0, 0)
    blackHole.Material = Enum.Material.SmoothPlastic
    blackHole.Anchored = true
    blackHole.CanCollide = false

    local ring = Instance.new("Part", workspace)
    ring.Shape = Enum.PartType.Cylinder
    ring.Size = Vector3.new(2, 80, 80)
    ring.Position = pos
    ring.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
    ring.Color = Color3.fromRGB(200, 100, 255)
    ring.Material = Enum.Material.Neon
    ring.Anchored = true
    ring.CanCollide = false
    ring.Transparency = 0.2

    local hl = Instance.new("Highlight", domain)
    hl.FillColor = Color3.fromRGB(20, 0, 40)
    hl.OutlineColor = Color3.fromRGB(160, 0, 255)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local particles = Instance.new("ParticleEmitter", domain)
    particles.Texture = "rbxassetid://243098098"
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    particles.Rate = 500
    particles.Speed = NumberRange.new(5, 20)
    particles.Size = NumberSequence.new(1.5)
    particles.Lifetime = NumberRange.new(2)
    particles.SpreadAngle = Vector2.new(180, 180)

    local cc = Instance.new("ColorCorrectionEffect", Lighting)
    cc.Brightness = -0.5
    cc.Contrast = 0.5
    cc.TintColor = Color3.fromRGB(150, 0, 255)

    local tween = TweenService:Create(domain, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.7})
    tween:Play()

    local rotConn
    rotConn = RunService.RenderStepped:Connect(function()
        if ring and ring.Parent then
            ring.CFrame = ring.CFrame * CFrame.Angles(0.05, 0, 0)
        end
    end)

    task.delay(8, function()
        tween:Cancel()
        if rotConn then rotConn:Disconnect() end
        if domain then domain:Destroy() end
        if blackHole then blackHole:Destroy() end
        if ring then ring:Destroy() end
        if cc then cc:Destroy() end
    end)
end)

-- 5. MOD GOJO OUTFIT
btn5.MouseButton1Click:Connect(function()
    if not char or not char.Parent then return end
    
    local bodyColors = char:FindFirstChildOfClass("BodyColors")
    if bodyColors then
        bodyColors.HeadColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.TorsoColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.LeftArmColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.RightArmColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.LeftLegColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.RightLegColor3 = Color3.fromRGB(255, 220, 200)
    end

    pcall(function()
        local shirt = char:FindFirstChildOfClass("Shirt") or Instance.new("Shirt", char)
        shirt.ShirtTemplate = "rbxassetid://120894858" -- Áo đen
        local pants = char:FindFirstChildOfClass("Pants") or Instance.new("Pants", char)
        pants.PantsTemplate = "rbxassetid://120894858" -- Quần đen
    end)

    local head = char:FindFirstChild("Head")
    if head then
        if not head:FindFirstChild("GojoHair") then
            local hair = Instance.new("Part", head)
            hair.Name = "GojoHair"
            hair.Shape = Enum.PartType.Ball
            hair.Size = Vector3.new(1.8, 1.2, 1.8)
            hair.Color = Color3.fromRGB(255, 255, 255)
            hair.Material = Enum.Material.SmoothPlastic
            hair.Anchored = false
            hair.CanCollide = false
            hair.Massless = true
            hair.CFrame = head.CFrame * CFrame.new(0, 0.6, 0)
            local weld = Instance.new("WeldConstraint", hair)
            weld.Part0 = head
            weld.Part1 = hair
        end

        if not head:FindFirstChild("GojoBlindfold") then
            local blindfold = Instance.new("Part", head)
            blindfold.Name = "GojoBlindfold"
            blindfold.Size = Vector3.new(1.6, 0.4, 0.2)
            blindfold.Color = Color3.fromRGB(0, 0, 0)
            blindfold.Material = Enum.Material.SmoothPlastic
            blindfold.Anchored = false
            blindfold.CanCollide = false
            blindfold.Massless = true
            blindfold.CFrame = head.CFrame * CFrame.new(0, 0, -0.5)
            local weld = Instance.new("WeldConstraint", blindfold)
            weld.Part0 = head
            weld.Part1 = blindfold
        end
    end
    
    btn5.Text = "Đã Mod Đồ Gojo!"
    task.delay(2, function()
        btn5.Text = "Mod Gojo Outfit"
    end)
end)

-- 6. HÀO QUANG (AURA)
local auraOn = false
local auraPart = nil
local auraConn = nil

btn6.MouseButton1Click:Connect(function()
    if not hrp or not hrp.Parent then return end
    auraOn = not auraOn
    if auraOn then
        btn6.Text = "Hào Quang: BẬT"
        btn6.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        auraPart = Instance.new("Part", workspace)
        auraPart.Shape = Enum.PartType.Ball
        auraPart.Size = Vector3.new(12, 12, 12)
        auraPart.Color = Color3.fromRGB(120, 0, 255)
        auraPart.Material = Enum.Material.ForceField
        auraPart.Anchored = true
        auraPart.CanCollide = false
        auraPart.Transparency = 0.5
        local light = Instance.new("PointLight", auraPart)
        light.Color = Color3.fromRGB(120, 0, 255)
        light.Range = 20
        light.Brightness = 5
        
        auraConn = RunService.RenderStepped:Connect(function()
            if hrp and hrp.Parent and auraPart then
                auraPart.Position = hrp.Position
                auraPart.CFrame = auraPart.CFrame * CFrame.Angles(0, 0.1, 0)
            end
        end)
    else
        btn6.Text = "Tắt/Bật Hào Quang"
        btn6.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        if auraConn then auraConn:Disconnect() end
        if auraPart then auraPart:Destroy() end
    end
end)

print("Gojo V6 - Bản Voice đã tải thành công! Chúc anh iu chơi vui nha!")
