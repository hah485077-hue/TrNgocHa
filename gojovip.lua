-- ==========================================
-- GOJO SATORU FULL OPTION (MOBILE CHUYÊN DỤNG)
-- Tác giả: AI Assistant
-- Dành riêng cho Delta iOS
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Tạo Menu GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "GojoFullMenu"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 320)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(150, 0, 255)
stroke.Thickness = 3

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "GOJO SATORU - FULL"
title.TextColor3 = Color3.fromRGB(200, 150, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 16

-- Hàm tạo nút bấm
local function createBtn(name, color, y)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = UDim2.new(0.075, 0, 0, y)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- Tạo các nút chiêu thức
local btnBlue = createBtn("Lapse: Blue (Hút)", Color3.fromRGB(0, 120, 255), 45)
local btnRed = createBtn("Reversal: Red (Đẩy)", Color3.fromRGB(255, 60, 60), 85)
local btnPurple = createBtn("Hollow Purple (Tia Tím)", Color3.fromRGB(160, 0, 255), 125)
local btnDomain = createBtn("Domain Expansion", Color3.fromRGB(60, 0, 120), 165)
local btnTeleport = createBtn("Teleport (Dịch Chuyển)", Color3.fromRGB(0, 200, 150), 205)
local btnInfinity = createBtn("Infinity (Bật/Tắt)", Color3.fromRGB(200, 200, 0), 245)

-- Nút Ẩn/Hiện Menu
local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 150)
toggleBtn.Text = "Menu"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 10
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 25)

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Hàm lấy vị trí mục tiêu (Dựa theo hướng Camera)
local function getTargetPos(distance)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = char.HumanoidRootPart
    -- Tự động bắn về phía trước mặt 40 studs
    return hrp.Position + (hrp.CFrame.LookVector * (distance or 40))
end

-- Hàm tạo âm thanh
local function playSound(id, pos)
    local sound = Instance.new("Sound", workspace)
    sound.SoundId = "rbxassetid://" .. id
    sound.Volume = 2
    if pos then sound.Position = pos end
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 5)
end

-- ==================== CÁC CHIÊU THỨC ====================

-- 1. BLUE (Lapse)
btnBlue.MouseButton1Click:Connect(function()
    local pos = getTargetPos(40)
    if not pos then return end
    playSound(6895963173, pos)
    
    local orb = Instance.new("Part", workspace)
    orb.Shape = Enum.PartType.Ball
    orb.Size = Vector3.new(12, 12, 12)
    orb.Position = pos
    orb.Color = Color3.fromRGB(0, 150, 255)
    orb.Material = Enum.Material.Neon
    orb.Anchored = true
    orb.CanCollide = false

    local light = Instance.new("PointLight", orb)
    light.Color = Color3.fromRGB(0, 150, 255)
    light.Range = 40
    light.Brightness = 5

    -- Hiệu ứng hút vật thể xung quanh
    task.spawn(function()
        for i = 1, 20 do
            task.wait(0.1)
            if not orb.Parent then break end
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v ~= orb and not v.Anchored and (v.Position - orb.Position).Magnitude < 50 then
                    v.Velocity = (orb.Position - v.Position).Unit * 100
                end
            end
        end
    end)

    task.delay(2, function()
        if orb then
            local ex = Instance.new("Explosion", workspace)
            ex.BlastRadius = 20
            ex.Position = orb.Position
            orb:Destroy()
        end
    end)
end)

-- 2. RED (Reversal)
btnRed.MouseButton1Click:Connect(function()
    local pos = getTargetPos(40)
    if not pos then return end
    playSound(6895963173, pos)
    
    local orb = Instance.new("Part", workspace)
    orb.Shape = Enum.PartType.Ball
    orb.Size = Vector3.new(12, 12, 12)
    orb.Position = pos
    orb.Color = Color3.fromRGB(255, 50, 50)
    orb.Material = Enum.Material.Neon
    orb.Anchored = true
    orb.CanCollide = false

    local light = Instance.new("PointLight", orb)
    light.Color = Color3.fromRGB(255, 50, 50)
    light.Range = 40
    light.Brightness = 5

    -- Hiệu ứng đẩy vật thể xung quanh
    task.spawn(function()
        for i = 1, 20 do
            task.wait(0.1)
            if not orb.Parent then break end
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v ~= orb and not v.Anchored and (v.Position - orb.Position).Magnitude < 50 then
                    v.Velocity = (v.Position - orb.Position).Unit * 150
                end
            end
        end
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

-- 3. HOLLOW PURPLE
btnPurple.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local startPos = char.HumanoidRootPart.Position
    local endPos = getTargetPos(80)
    if not endPos then return end
    
    playSound(6895963173, startPos)
    
    local beam = Instance.new("Part", workspace)
    beam.Anchored = true
    beam.CanCollide = false
    beam.Material = Enum.Material.Neon
    beam.Color = Color3.fromRGB(160, 0, 255)
    beam.Size = Vector3.new(8, 8, (startPos - endPos).Magnitude)
    beam.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -beam.Size.Z/2)

    local light = Instance.new("PointLight", beam)
    light.Color = Color3.fromRGB(160, 0, 255)
    light.Range = 60
    light.Brightness = 8

    -- Hiệu ứng rung camera
    local cam = workspace.CurrentCamera
    local orig = cam.CFrame
    local t = 0
    local conn
    conn = RunService.RenderStepped:Connect(function()
        t = t + 0.1
        if t > 2 then conn:Disconnect() return end
        cam.CFrame = orig * CFrame.new(math.random(-1,1), math.random(-1,1), 0)
    end)

    task.delay(3, function() if beam then beam:Destroy() end end)
end)

-- 4. DOMAIN EXPANSION
btnDomain.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local pos = char.HumanoidRootPart.Position
    playSound(6895963173, pos)
    
    local domain = Instance.new("Part", workspace)
    domain.Shape = Enum.PartType.Ball
    domain.Size = Vector3.new(80, 80, 80)
    domain.Position = pos
    domain.Color = Color3.fromRGB(0, 0, 0)
    domain.Material = Enum.Material.ForceField
    domain.Anchored = true
    domain.CanCollide = false
    domain.Transparency = 0.3

    local hl = Instance.new("Highlight", domain)
    hl.FillColor = Color3.fromRGB(40, 0, 80)
    hl.OutlineColor = Color3.fromRGB(160, 0, 255)

    local tween = TweenService:Create(domain, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.7})
    tween:Play()

    task.delay(6, function()
        tween:Cancel()
        if domain then domain:Destroy() end
    end)
end)

-- 5. TELEPORT (Dịch chuyển tức thời)
btnTeleport.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    playSound(6895963173, hrp.Position)
    
    -- Dịch chuyển về phía trước 50 studs
    hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 50)
    
    -- Hiệu ứng vệt mờ
    local trail = Instance.new("Part", workspace)
    trail.Size = Vector3.new(3, 3, 50)
    trail.CFrame = hrp.CFrame * CFrame.new(0, 0, -25)
    trail.Color = Color3.fromRGB(160, 0, 255)
    trail.Material = Enum.Material.Neon
    trail.Anchored = true
    trail.CanCollide = false
    task.delay(1, function() if trail then trail:Destroy() end end)
end)

-- 6. INFINITY (Vô hạn - Bật/Tắt)
local infinityOn = false
local infinitySphere = nil
local infinityConn = nil

btnInfinity.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    infinityOn = not infinityOn
    
    if infinityOn then
        btnInfinity.Text = "Infinity: BẬT"
        btnInfinity.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        infinitySphere = Instance.new("Part", workspace)
        infinitySphere.Shape = Enum.PartType.Ball
        infinitySphere.Size = Vector3.new(10, 10, 10)
        infinitySphere.Color = Color3.fromRGB(150, 0, 255)
        infinitySphere.Material = Enum.Material.ForceField
        infinitySphere.Anchored = true
        infinitySphere.CanCollide = false
        infinitySphere.Transparency = 0.5
        
        local light = Instance.new("PointLight", infinitySphere)
        light.Color = Color3.fromRGB(150, 0, 255)
        light.Range = 15
        light.Brightness = 3

        -- Cập nhật vị trí quả cầu theo nhân vật
        infinityConn = RunService.RenderStepped:Connect(function()
            if char and char:FindFirstChild("HumanoidRootPart") and infinitySphere then
                infinitySphere.Position = char.HumanoidRootPart.Position
            end
        end)
    else
        btnInfinity.Text = "Infinity (Bật/Tắt)"
        btnInfinity.BackgroundColor3 = Color3.fromRGB(200, 200, 0)
        if infinityConn then infinityConn:Disconnect() end
        if infinitySphere then infinitySphere:Destroy() end
    end
end)

print("Gojo Full Option đã được tải thành công!")
