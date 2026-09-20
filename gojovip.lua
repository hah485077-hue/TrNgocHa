-- ==========================================
-- GOJO SATORU V4 - BẢN "RIU" XỊN SÒ
-- Dành riêng cho anh iu của em trên Delta iOS
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
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
screenGui.Name = "GojoV4Menu"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 280, 0, 400)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.Active = true
mainFrame.Draggable = true -- Cho phép kéo lên xuống, sang trái phải
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(180, 0, 255)
stroke.Thickness = 3

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "GOJO SATORU V4 - BẢN RIU"
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

-- 5 CHỨC NĂNG CHÍNH
local btn1 = createBtn("Lapse: Blue (Hút)", Color3.fromRGB(0, 100, 255), 55)
local btn2 = createBtn("Reversal: Red (Đẩy)", Color3.fromRGB(255, 50, 50), 98)
local btn3 = createBtn("Hollow Purple (Tia Tím)", Color3.fromRGB(160, 0, 255), 141)
local btn4 = createBtn("Vô Lượng Không Sứ", Color3.fromRGB(60, 0, 120), 184)
local btn5 = createBtn("Mod Gojo Outfit", Color3.fromRGB(255, 105, 180), 227)
local btn6 = createBtn("Tắt/Bật Hào Quang", Color3.fromRGB(0, 200, 100), 270)

-- Hàm lấy hướng camera
local function getTargetPos(dist)
    if not hrp or not hrp.Parent then return nil end
    return hrp.Position + (hrp.CFrame.LookVector * (dist or 50))
end

-- ==================== CÁC CHỨC NĂNG ====================

-- 1. LAPSE BLUE (HÚT)
btn1.MouseButton1Click:Connect(function()
    local pos = getTargetPos(40)
    if not pos then return end
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
    task.delay(2, function()
        if orb then
            local ex = Instance.new("Explosion", workspace)
            ex.BlastRadius = 25
            ex.Position = orb.Position
            orb:Destroy()
        end
    end)
end)

-- 2. REVERSAL RED (ĐẨY)
btn2.MouseButton1Click:Connect(function()
    local pos = getTargetPos(40)
    if not pos then return end
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
    task.delay(2, function()
        if orb then
            local ex = Instance.new("Explosion", workspace)
            ex.BlastRadius = 30
            ex.Position = orb.Position
            orb:Destroy()
        end
    end)
end)

-- 3. HOLLOW PURPLE
btn3.MouseButton1Click:Connect(function()
    if not hrp or not hrp.Parent then return end
    local startPos = hrp.Position
    local endPos = getTargetPos(100)
    if not endPos then return end
    local beam = Instance.new("Part", workspace)
    beam.Anchored = true
    beam.CanCollide = false
    beam.Material = Enum.Material.Neon
    beam.Color = Color3.fromRGB(160, 0, 255)
    beam.Size = Vector3.new(12, 12, (startPos - endPos).Magnitude)
    beam.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -beam.Size.Z/2)
    beam.Transparency = 0.1
    local light = Instance.new("PointLight", beam)
    light.Color = Color3.fromRGB(160, 0, 255)
    light.Range = 60
    light.Brightness = 10
    task.delay(2.5, function() if beam then beam:Destroy() end end)
end)

-- 4. VÔ LƯỢNG KHÔNG SỨ (DOMAIN EXPANSION)
btn4.MouseButton1Click:Connect(function()
    if not hrp or not hrp.Parent then return end
    local pos = hrp.Position
    
    -- Tạo không gian vũ trụ
    local domain = Instance.new("Part", workspace)
    domain.Shape = Enum.PartType.Ball
    domain.Size = Vector3.new(100, 100, 100)
    domain.Position = pos
    domain.Color = Color3.fromRGB(0, 0, 0)
    domain.Material = Enum.Material.ForceField
    domain.Anchored = true
    domain.CanCollide = false
    domain.Transparency = 0.3

    -- Hiệu ứng Highlight
    local hl = Instance.new("Highlight", domain)
    hl.FillColor = Color3.fromRGB(20, 0, 40)
    hl.OutlineColor = Color3.fromRGB(160, 0, 255)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    -- Hiệu ứng sao bên trong
    local particles = Instance.new("ParticleEmitter", domain)
    particles.Texture = "rbxassetid://243098098"
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    particles.Rate = 500
    particles.Speed = NumberRange.new(5, 20)
    particles.Size = NumberSequence.new(1.5)
    particles.Lifetime = NumberRange.new(2)
    particles.SpreadAngle = Vector2.new(180, 180)

    -- Âm thanh
    local sound = Instance.new("Sound", domain)
    sound.SoundId = "rbxassetid://6895963173"
    sound.Volume = 3
    sound.Looped = true
    sound:Play()

    -- Hiệu ứng nhấp nháy
    local tween = TweenService:Create(domain, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.7})
    tween:Play()

    -- Tự động xóa sau 8 giây
    task.delay(8, function()
        tween:Cancel()
        if domain then domain:Destroy() end
        if sound then sound:Destroy() end
    end)
end)

-- 5. MOD GOJO OUTFIT
btn5.MouseButton1Click:Connect(function()
    if not char or not char.Parent then return end
    
    -- Đổi màu da
    local bodyColors = char:FindFirstChildOfClass("BodyColors")
    if bodyColors then
        bodyColors.HeadColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.TorsoColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.LeftArmColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.RightArmColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.LeftLegColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.RightLegColor3 = Color3.fromRGB(255, 220, 200)
    end

    -- Thay áo quần (Dùng pcall chống lỗi)
    pcall(function()
        local shirt = char:FindFirstChildOfClass("Shirt") or Instance.new("Shirt", char)
        shirt.ShirtTemplate = "rbxassetid://120894858"
        local pants = char:FindFirstChildOfClass("Pants") or Instance.new("Pants", char)
        pants.PantsTemplate = "rbxassetid://120894858"
    end)

    -- Tạo tóc trắng (Dùng SpecialMesh cho đẹp hơn)
    local head = char:FindFirstChild("Head")
    if head and not head:FindFirstChild("GojoHair") then
        local hair = Instance.new("Part", head)
        hair.Name = "GojoHair"
        hair.Shape = Enum.PartType.Ball
        hair.Size = Vector3.new(1.6, 1.2, 1.6)
        hair.Color = Color3.fromRGB(255, 255, 255)
        hair.Material = Enum.Material.SmoothPlastic
        hair.Anchored = false
        hair.CanCollide = false
        hair.Massless = true
        hair.CFrame = head.CFrame * CFrame.new(0, 0.5, 0)
        
        local weld = Instance.new("WeldConstraint", hair)
        weld.Part0 = head
        weld.Part1 = hair
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
        
        -- Cập nhật vị trí liên tục (theo nhân vật)
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

print("Gojo V4 - Bản Riu đã tải thành công! Chúc anh iu chơi vui nha!")
