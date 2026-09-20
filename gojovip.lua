-- ==========================================
-- HƯ THỨC TỬ (HOLLOW PURPLE) - BẢN FULL HIỆU ỨNG
-- Dành riêng cho anh iu của em nè
-- ==========================================

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local player = game.Players.LocalPlayer

-- Hàm tạo quả cầu
local function createOrb(color, size, parent)
    local orb = Instance.new("Part")
    orb.Shape = Enum.PartType.Ball
    orb.Size = Vector3.new(size, size, size)
    orb.Color = color
    orb.Material = Enum.Material.Neon
    orb.Anchored = true
    orb.CanCollide = false
    orb.Parent = parent or workspace
    
    local light = Instance.new("PointLight", orb)
    light.Color = color
    light.Range = 30
    light.Brightness = 5
    
    return orb
end

-- Hàm tạo hiệu ứng đất bay
local function createDirtEffect(position, direction)
    for i = 1, 5 do
        local dirt = Instance.new("Part")
        dirt.Size = Vector3.new(math.random(1,3), math.random(1,3), math.random(1,3))
        dirt.Position = position + Vector3.new(math.random(-5,5), math.random(-2,2), math.random(-5,5))
        dirt.Color = Color3.fromRGB(100, 70, 50) -- Màu đất
        dirt.Material = Enum.Material.Ground
        dirt.Anchored = false
        dirt.CanCollide = false
        dirt.Parent = workspace
        
        -- Tạo vận tốc bay ngược ra sau
        dirt.Velocity = (direction * -1) * math.random(20, 50) + Vector3.new(math.random(-10,10), math.random(10,30), math.random(-10,10))
        
        -- Tự động xóa sau 2 giây
        Debris:AddItem(dirt, 2)
    end
end

-- Hàm kích hoạt chiêu Hư Thức Tử
local function castHollowPurple()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    -- Vị trí xuất phát (trước mặt nhân vật 5 studs)
    local centerPos = hrp.Position + (hrp.CFrame.LookVector * 5)
    
    -- Tạo 2 quả cầu Xanh và Đỏ ở 2 bên
    local blueOrb = createOrb(Color3.fromRGB(0, 150, 255), 8)
    blueOrb.Position = centerPos + (hrp.CFrame.RightVector * -10)
    
    local redOrb = createOrb(Color3.fromRGB(255, 50, 50), 8)
    redOrb.Position = centerPos + (hrp.CFrame.RightVector * 10)
    
    -- Âm thanh Gojo nói (Hollow Purple)
    local voiceSound = Instance.new("Sound", workspace)
    voiceSound.SoundId = "rbxassetid://1837879086" -- ID giọng Gojo nói "Hollow Purple"
    voiceSound.Volume = 5
    voiceSound.Position = centerPos
    voiceSound:Play()
    Debris:AddItem(voiceSound, 5)
    
    -- Cho 2 quả cầu bay vào nhau (1.5 giây)
    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local tweenBlue = TweenService:Create(blueOrb, tweenInfo, {Position = centerPos})
    local tweenRed = TweenService:Create(redOrb, tweenInfo, {Position = centerPos})
    
    tweenBlue:Play()
    tweenRed:Play()
    
    -- Đợi 1.5 giây cho nó va chạm
    task.wait(1.5)
    
    -- Xóa 2 quả cầu cũ
    blueOrb:Destroy()
    redOrb:Destroy()
    
    -- Tạo quả cầu Tím khổng lồ
    local purpleOrb = createOrb(Color3.fromRGB(160, 0, 255), 25)
    purpleOrb.Position = centerPos
    purpleOrb.Transparency = 0.2
    
    -- Âm thanh nổ khi quả cầu Tím xuất hiện
    local explosionSound = Instance.new("Sound", purpleOrb)
    explosionSound.SoundId = "rbxassetid://131961136" -- Tiếng nổ
    explosionSound.Volume = 5
    explosionSound:Play()
    
    -- Hiệu ứng rung camera
    local cam = workspace.CurrentCamera
    local orig = cam.CFrame
    local t = 0
    local conn
    conn = RunService.RenderStepped:Connect(function()
        t = t + 0.1
        if t > 1.5 then conn:Disconnect() return end
        cam.CFrame = orig * CFrame.new(math.random(-2,2), math.random(-2,2), 0)
    end)
    
    -- Cho quả cầu Tím lao về phía trước (100 studs) + Hiệu ứng đất bay
    local direction = hrp.CFrame.LookVector
    local targetPos = centerPos + (direction * 100)
    
    local tweenPurple = TweenService:Create(purpleOrb, TweenInfo.new(1, Enum.EasingStyle.Linear), {Position = targetPos})
    tweenPurple:Play()
    
    -- Tạo hiệu ứng đất bay liên tục khi quả cầu lao đi
    local dirtConn
    dirtConn = RunService.RenderStepped:Connect(function()
        if purpleOrb and purpleOrb.Parent then
            createDirtEffect(purpleOrb.Position, direction)
        else
            dirtConn:Disconnect()
        end
    end)
    
    -- Xóa quả cầu Tím sau 1 giây
    task.delay(1, function()
        if dirtConn then dirtConn:Disconnect() end
        if purpleOrb then
            purpleOrb:Destroy()
        end
    end)
end

-- Gán phím Q để kích hoạt
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        castHollowPurple()
    end
end)

-- Tạo nút bấm trên màn hình cho anh iu dễ bấm nè
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "HollowPurpleGui"

local btn = Instance.new("TextButton", screenGui)
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0.5, -75, 0.8, 0)
btn.BackgroundColor3 = Color3.fromRGB(160, 0, 255)
btn.Text = "HƯ THỨC TỬ (Q)"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

btn.MouseButton1Click:Connect(function()
    castHollowPurple()
end)

print("Hư Thức Tử đã sẵn sàng! Bấm phím Q hoặc nút trên màn hình để dùng nha anh iu!")
