-- ==========================================
-- GOJO SATORU V3.5 - FULL EFFECTS + MOD ĐỒ
-- Dành riêng cho anh iu của em trên Delta iOS
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Đợi nhân vật load xong mới chạy (tránh lỗi trên đt)
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Tạo Menu GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "GojoV35Menu"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 270, 0, 390)
mainFrame.Position = UDim2.new(0.5, -135, 0.5, -195)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(180, 0, 255)
stroke.Thickness = 3

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "GOJO SATORU V3.5 - ULTIMATE"
title.TextColor3 = Color3.fromRGB(220, 160, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 16

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

-- 6 CHỨC NĂNG TỪ TRÊN XUỐNG
local btn1 = createBtn("Lapse: Blue (Hút Cực Mạnh)", Color3.fromRGB(0, 100, 255), 50)
local btn2 = createBtn("Reversal: Red (Đẩy Bay Màu)", Color3.fromRGB(255, 50, 50), 92)
local btn3 = createBtn("Hollow Purple (Tia Sét Tím)", Color3.fromRGB(160, 0, 255), 134)
local btn4 = createBtn("Domain Expansion (Vô Hạn)", Color3.fromRGB(60, 0, 120), 176)
local btn5 = createBtn("Gojo Aura (Hào Quang)", Color3.fromRGB(0, 200, 100), 218)
local btn6 = createBtn("Mod Gojo Outfit (Tóc Trắng)", Color3.fromRGB(255, 105, 180), 260)

-- Nút Ẩn/Hiện
local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 45, 0, 45)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -22)
toggleBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
toggleBtn.Text = "Ẩn"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 10
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 22)
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Hàm lấy hướng camera
local function getTargetPos(dist)
    if not hrp or not hrp.Parent then return nil end
    return hrp.Position + (hrp.CFrame.LookVector * (dist or 50))
end

-- ==================== CÁC CHỨC NĂNG ====================

-- 1. LAPSE BLUE
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

-- 2. REVERSAL RED
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
    beam.Size = Vector3.new(10, 10, (startPos - endPos).Magnitude)
    beam.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -beam.Size.Z/2)
    beam.Transparency = 0.1
    local light = Instance.new("PointLight", beam)
    light.Color = Color3.fromRGB(160, 0, 255)
    light.Range = 60
    light.Brightness = 8
    task.delay(2.5, function() if beam then beam:Destroy() end end)
end)

-- 4. DOMAIN EXPANSION
btn4.MouseButton1Click:Connect(function()
    if not hrp or not hrp.Parent then return end
    local pos = hrp.Position
    local domain = Instance.new("Part", workspace)
    domain.Shape = Enum.PartType.Ball
    domain.Size = Vector3.new(80, 80, 80)
    domain.Position = pos
    domain.Color = Color3.fromRGB(0, 0, 0)
    domain.Material = Enum.Material.ForceField
    domain.Anchored = true
    domain.CanCollide = false
    domain.Transparency = 0.4
    local hl = Instance.new("Highlight", domain)
    hl.FillColor = Color3.fromRGB(30, 0, 60)
    hl.OutlineColor = Color3.fromRGB(180, 0, 255)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    local tween = TweenService:Create(domain, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.7})
    tween:Play()
    task.delay(6, function()
        tween:Cancel()
        if domain then domain:Destroy() end
    end)
end)

-- 5. GOJO AURA
local auraOn = false
local auraPart = nil
local auraConn = nil
btn5.MouseButton1Click:Connect(function()
    if not hrp or not hrp.Parent then return end
    auraOn = not auraOn
    if auraOn then
        btn5.Text = "Gojo Aura: BẬT"
        btn5.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
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
        btn5.Text = "Gojo Aura (Hào Quang)"
        btn5.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        if auraConn then auraConn:Disconnect() end
        if auraPart then auraPart:Destroy() end
    end
end)

-- 6. MOD GOJO OUTFIT (FIXED)
btn6.MouseButton1Click:Connect(function()
    if not char or not char.Parent then return end
    
    -- Đổi màu da (BodyColors)
    local bodyColors = char:FindFirstChildOfClass("BodyColors")
    if bodyColors then
        bodyColors.HeadColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.TorsoColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.LeftArmColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.RightArmColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.LeftLegColor3 = Color3.fromRGB(255, 220, 200)
        bodyColors.RightLegColor3 = Color3.fromRGB(255, 220, 200)
    end

    -- Thay áo và quần (Dùng pcall để chống lỗi trên đt)
    pcall(function()
        local shirt = char:FindFirstChildOfClass("Shirt") or Instance.new("Shirt", char)
        shirt.ShirtTemplate = "rbxassetid://120894858" -- Áo đen
        local pants = char:FindFirstChildOfClass("Pants") or Instance.new("Pants", char)
        pants.PantsTemplate = "rbxassetid://120894858" -- Quần đen
    end)

    -- Tạo tóc trắng
    local head = char:FindFirstChild("Head")
    if head and not head:FindFirstChild("GojoHair") then
        local hair = Instance.new("Part", head)
        hair.Name = "GojoHair"
        hair.Shape = Enum.PartType.Ball
        hair.Size = Vector3.new(1.5, 1, 1.5)
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
    
    btn6.Text = "Đã Mod Đồ Gojo!"
    task.delay(2, function()
        btn6.Text = "Mod Gojo Outfit (Tóc Trắng)"
    end)
end)

print("Gojo V3.5 Ultimate đã tải thành công! Chúc anh iu chơi vui nha!")
