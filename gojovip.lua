-- language: Lua, target: Roblox (Delta iOS / Mobile / PC Executor)
-- Gojo Satoru V9: TIKTOK CINEMATIC EDITION (True Unlimited Void & Hollow Purple)

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

local cc = Lighting:FindFirstChild("Gojo_CC_TikTok") or Instance.new("ColorCorrectionEffect", Lighting)
cc.Name = "Gojo_CC_TikTok"

local function playSound(id, pos, vol, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(id)
    sound.Volume = vol or 4
    sound.PlaybackSpeed = pitch or 1
    if pos then
        local att = Instance.new("Attachment", workspace.Terrain)
        att.WorldPosition = pos
        sound.Parent = att
        Debris:AddItem(att, 6)
    else
        sound.Parent = workspace
    end
    sound:Play()
    Debris:AddItem(sound, 6)
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

-- ================= GUI SETUP =================
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "Gojo_V9"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(150, 0, 255)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "GOJO V9 - TIKTOK CINEMATIC"
title.TextColor3 = Color3.fromRGB(230, 200, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 14

local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 20, 0.5, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
openBtn.Text = "V9"
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
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local btnBlue = createBtn("1. Thương (Blue)", Color3.fromRGB(0, 120, 255), 50)
local btnRed = createBtn("2. Hách (Red)", Color3.fromRGB(255, 40, 60), 100)
local btnPurple = createBtn("3. Hư Thức Tử (Hoạt ảnh vỗ tay)", Color3.fromRGB(160, 0, 255), 150)
local btnDomain = createBtn("4. Vô Lượng (Vũ Trụ 3D + Nước)", Color3.fromRGB(20, 0, 40), 200)
local btnOutfit = createBtn("5. Mod Trang Phục Gojo", Color3.fromRGB(200, 80, 150), 250)

-- ================= 3. HƯ THỨC TỬ (HOẠT ẢNH ÉP TAY + BASS DROP) =================
btnPurple.MouseButton1Click:Connect(function()
    if not hrp then return end
    hrp.Anchored = true 
    
    local cam = workspace.CurrentCamera
    TweenService:Create(cam, TweenInfo.new(1.5), {FieldOfView = 40}):Play()
    playSound(7435165623, hrp.Position, 8) -- Đọc chú "Kyoshiki..."
    
    -- Lấy vị trí hai bên tay (hoặc mô phỏng hai bên vai)
    local leftPos = hrp.Position + (hrp.CFrame.RightVector * -6) + Vector3.new(0, 2, 0)
    local rightPos = hrp.Position + (hrp.CFrame.RightVector * 6) + Vector3.new(0, 2, 0)
    
    local blue = Instance.new("Part", workspace)
    blue.Shape = Enum.PartType.Ball; blue.Size = Vector3.new(0.1, 0.1, 0.1); blue.Position = leftPos
    blue.Color = Color3.fromRGB(0, 150, 255); blue.Material = Enum.Material.Neon; blue.Anchored = true; blue.CanCollide = false
    
    local red = Instance.new("Part", workspace)
    red.Shape = Enum.PartType.Ball; red.Size = Vector3.new(0.1, 0.1, 0.1); red.Position = rightPos
    red.Color = Color3.fromRGB(255, 30, 30); red.Material = Enum.Material.Neon; red.Anchored = true; red.CanCollide = false
    
    -- Gồng to hai quả cầu tại hai tay
    TweenService:Create(blue, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Size = Vector3.new(12,12,12)}):Play()
    TweenService:Create(red, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Size = Vector3.new(12,12,12)}):Play()
    cameraShake(2, 1)
    task.wait(1.5)
    
    -- Ép hai quả cầu vào nhau ngay trước ngực (Hoạt ảnh vỗ tay)
    local combinePos = hrp.Position + (hrp.CFrame.LookVector * 4) + Vector3.new(0, 1.5, 0)
    TweenService:Create(blue, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = combinePos, Size = Vector3.new(4,4,4)}):Play()
    TweenService:Create(red, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = combinePos, Size = Vector3.new(4,4,4)}):Play()
    
    task.wait(0.3)
    blue:Destroy(); red:Destroy()
    
    -- MÀN HÌNH CHỚP LÓA + FOV GIẬT NGƯỢC Y HỆT TIKTOK
    cc.Brightness = 2; cc.TintColor = Color3.fromRGB(255, 255, 255)
    TweenService:Create(cc, TweenInfo.new(0.6), {Brightness = 0, TintColor = Color3.fromRGB(150, 0, 255)}):Play()
    playSound(9114223403, combinePos, 10, 0.7) -- Bass drop cực trầm
    cameraShake(3, 5)
    TweenService:Create(cam, TweenInfo.new(0.2, Enum.EasingStyle.Bounce), {FieldOfView = 100}):Play()
    task.wait(0.2)
    TweenService:Create(cam, TweenInfo.new(1), {FieldOfView = 70}):Play()
    
    -- Bắn quả cầu Tím + Sóng laser vạch đường
    local purpleCore = Instance.new("Part", workspace)
    purpleCore.Shape = Enum.PartType.Ball; purpleCore.Size = Vector3.new(35, 35, 35); purpleCore.Position = combinePos
    purpleCore.Color = Color3.fromRGB(140, 0, 255); purpleCore.Material = Enum.Material.Neon; purpleCore.Anchored = true; purpleCore.CanCollide = false
    
    local endPos = combinePos + (hrp.CFrame.LookVector * 400)
    local stepConn; local startT = os.clock()
    
    stepConn = RunService.Heartbeat:Connect(function()
        local alpha = (os.clock() - startT) / 1.2
        if alpha >= 1 then
            stepConn:Disconnect()
            playSound(157878578, purpleCore.Position, 10)
            local finalExp = Instance.new("Part", workspace)
            finalExp.Shape = Enum.PartType.Ball; finalExp.Size = Vector3.new(150, 150, 150); finalExp.Position = purpleCore.Position
            finalExp.Color = Color3.fromRGB(200, 100, 255); finalExp.Material = Enum.Material.Neon; finalExp.Anchored = true; finalExp.CanCollide = false
            TweenService:Create(finalExp, TweenInfo.new(1), {Size = Vector3.new(300, 300, 300), Transparency = 1}):Play()
            Debris:AddItem(finalExp, 1)
            purpleCore:Destroy()
            TweenService:Create(cc, TweenInfo.new(1), {Brightness = 0, Contrast = 0, TintColor = Color3.fromRGB(255, 255, 255)}):Play()
            hrp.Anchored = false
            return
        end
        
        local currentPos = combinePos:Lerp(endPos, alpha)
        purpleCore.Position = currentPos
        
        -- Cày tung đất đá trên đường bay
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Anchored and v ~= purpleCore then
                if (v.Position - currentPos).Magnitude < 60 then
                    v.Velocity = (v.Position - currentPos).Unit * 500 + Vector3.new(0, 150, 0)
                end
            end
        end
    end)
end)

-- ================= 4. VÔ LƯỢNG KHÔNG SỨ (VŨ TRỤ 3D + SÀN NƯỚC BĂNG) =================
btnDomain.MouseButton1Click:Connect(function()
    if not hrp then return end
    hrp.Anchored = true
    local centerPos = hrp.Position
    local cam = workspace.CurrentCamera
    
    -- Chớp nháy vỡ không gian lúc bắt đầu kết ấn
    cc.Brightness = 1; cc.Contrast = 2
    playSound(6542823628, centerPos, 8) -- Voice Ryouiki Tenkai
    TweenService:Create(cc, TweenInfo.new(1.5), {Brightness = 0, Contrast = 0}):Play()
    task.wait(1.2)
    
    playSound(9114223635, centerPos, 10) -- Tiếng bung domain
    cameraShake(2, 3)
    
    -- TẠO MẶT SÀN NƯỚC BĂNG (Như Anime)
    local domainFloor = Instance.new("Part", workspace)
    domainFloor.Size = Vector3.new(0, 1, 0)
    domainFloor.Position = centerPos - Vector3.new(0, 3, 0)
    domainFloor.Color = Color3.fromRGB(150, 200, 255)
    domainFloor.Material = Enum.Material.Glass -- Tạo độ bóng phản chiếu
    domainFloor.Anchored = true; domainFloor.CanCollide = true
    
    -- TẠO VỎ DOMAIN VŨ TRỤ (Màu xanh cosmos sáng lấp lánh, không phải đen kịt)
    local domainShell = Instance.new("Part", workspace)
    domainShell.Shape = Enum.PartType.Ball
    domainShell.Size = Vector3.new(0, 0, 0)
    domainShell.Position = centerPos
    domainShell.Color = Color3.fromRGB(50, 10, 100)
    domainShell.Material = Enum.Material.ForceField -- Tạo hiệu ứng nhiễu từ trường không gian
    domainShell.Anchored = true; domainShell.CanCollide = false
    
    -- Bung rộng không gian
    TweenService:Create(domainFloor, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Vector3.new(300, 1, 300)}):Play()
    TweenService:Create(domainShell, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Vector3.new(300, 300, 300)}):Play()
    
    -- SINH RA HÀNG TRĂM VÌ SAO 3D BÊN TRONG DOMAIN
    local stars = {}
    for i = 1, 150 do
        local star = Instance.new("Part", workspace)
        star.Shape = Enum.PartType.Ball
        star.Size = Vector3.new(0.8, 0.8, 0.8)
        
        -- Sinh ngẫu nhiên xung quanh người chơi
        local randomDir = Vector3.new(math.random(-100, 100), math.random(5, 100), math.random(-100, 100))
        star.Position = centerPos + randomDir
        
        -- Trộn màu Trắng lóa và Tím vũ trụ
        star.Color = math.random(1, 2) == 1 and Color3.new(1, 1, 1) or Color3.fromRGB(150, 100, 255)
        star.Material = Enum.Material.Neon
        star.Anchored = true; star.CanCollide = false
        star.Transparency = 1
        table.insert(stars, star)
        
        -- Hạt sao sáng dần lên
        TweenService:Create(star, TweenInfo.new(math.random(1, 3)), {Transparency = 0}):Play()
    end

    -- Đóng băng não kẻ địch
    local freezeConn = RunService.Heartbeat:Connect(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Humanoid") and v.Parent ~= char then
                local targetHrp = v.Parent:FindFirstChild("HumanoidRootPart")
                if targetHrp and (targetHrp.Position - centerPos).Magnitude < 150 then
                    targetHrp.Anchored = true 
                end
            end
        end
    end)

    -- Phá Domain sau 9 giây
    task.delay(9, function()
        freezeConn:Disconnect()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Humanoid") and v.Parent ~= char then
                local targetHrp = v.Parent:FindFirstChild("HumanoidRootPart")
                if targetHrp then targetHrp.Anchored = false end
            end
        end
        
        TweenService:Create(domainFloor, TweenInfo.new(1), {Size = Vector3.new(0, 0, 0)}):Play()
        TweenService:Create(domainShell, TweenInfo.new(1), {Size = Vector3.new(0, 0, 0), Transparency = 1}):Play()
        
        for _, star in pairs(stars) do
            TweenService:Create(star, TweenInfo.new(0.5), {Transparency = 1}):Play()
            Debris:AddItem(star, 0.5)
        end
        
        task.wait(1)
        domainFloor:Destroy()
        domainShell:Destroy()
        hrp.Anchored = false
    end)
end)

-- (Kỹ năng Blue, Red và Mod Outfit giữ nguyên hiệu năng mượt mà của V8)
btnBlue.MouseButton1Click:Connect(function()
    if not hrp then return end
    local pos = hrp.Position + (hrp.CFrame.LookVector * 25)
    playSound(9114223179, pos, 5) 
    local orb = Instance.new("Part", workspace)
    orb.Shape = Enum.PartType.Ball; orb.Size = Vector3.new(0.1, 0.1, 0.1); orb.Position = pos
    orb.Color = Color3.fromRGB(0, 50, 255); orb.Material = Enum.Material.Neon; orb.Anchored = true; orb.CanCollide = false
    TweenService:Create(orb, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {Size = Vector3.new(12, 12, 12)}):Play()
    cameraShake(1.5, 0.8)
    for i = 1, 20 do
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Anchored and v ~= orb and (v.Position - pos).Magnitude < 100 then
                v.Velocity = (pos - v.Position).Unit * 180 + Vector3.new(0, 20, 0)
            end
        end
        task.wait(0.05)
    end
    TweenService:Create(orb, TweenInfo.new(0.3), {Size = Vector3.new(0, 0, 0)}):Play()
    task.wait(0.3); orb:Destroy()
end)

btnRed.MouseButton1Click:Connect(function()
    if not hrp then return end
    local spawnPos = hrp.Position + (hrp.CFrame.LookVector * 8)
    local redOrb = Instance.new("Part", workspace)
    redOrb.Shape = Enum.PartType.Ball; redOrb.Size = Vector3.new(1, 1, 1); redOrb.Position = spawnPos
    redOrb.Color = Color3.fromRGB(255, 0, 0); redOrb.Material = Enum.Material.Neon; redOrb.Anchored = true; redOrb.CanCollide = false
    playSound(9114222986, spawnPos, 6) 
    TweenService:Create(redOrb, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {Size = Vector3.new(6, 6, 6)}):Play()
    task.wait(0.8)
    cc.Brightness = 0.8; cc.TintColor = Color3.fromRGB(255, 150, 150)
    TweenService:Create(cc, TweenInfo.new(0.5), {Brightness = 0, TintColor = Color3.fromRGB(255, 255, 255)}):Play()
    playSound(157878578, spawnPos, 8) 
    cameraShake(1.5, 3)
    local shockwave = Instance.new("Part", workspace)
    shockwave.Shape = Enum.PartType.Ball; shockwave.Size = Vector3.new(4, 4, 4); shockwave.Position = spawnPos
    shockwave.Color = Color3.fromRGB(255, 30, 30); shockwave.Material = Enum.Material.ForceField; shockwave.Anchored = true; shockwave.CanCollide = false
    TweenService:Create(shockwave, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Vector3.new(150, 150, 150), Transparency = 1}):Play()
    redOrb:Destroy()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Anchored and v ~= shockwave and (v.Position - spawnPos).Magnitude < 120 then
            v.Velocity = (v.Position - spawnPos).Unit * 350 + Vector3.new(0, 100, 0)
        end
    end
    Debris:AddItem(shockwave, 0.4)
end)

btnOutfit.MouseButton1Click:Connect(function()
    if not char then return end
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Clothing") or v:IsA("ShirtGraphic") or v:IsA("Accessory") then v:Destroy() end
    end
    local shirt = Instance.new("Shirt", char); shirt.ShirtTemplate = "rbxassetid://10654067339"
    local pants = Instance.new("Pants", char); pants.PantsTemplate = "rbxassetid://10654068305"
    local head = char:FindFirstChild("Head")
    if head then
        local blindfold = Instance.new("Part", char)
        blindfold.Size = Vector3.new(1.1, 0.45, 1.1)
        blindfold.Color = Color3.fromRGB(10, 10, 10)
        blindfold.Material = Enum.Material.SmoothPlastic
        blindfold.CanCollide = false; blindfold.Massless = true
        local weld = Instance.new("Weld", blindfold)
        weld.Part0 = head; weld.Part1 = blindfold; weld.C0 = CFrame.new(0, 0.15, 0)
    end
    btnOutfit.Text = "Đã Mod Gojo Thành Công!"
    task.delay(2, function() btnOutfit.Text = "5. Mod Trang Phục Gojo" end)
end)
