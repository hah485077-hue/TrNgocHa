-- language: Lua, target: Roblox (Delta iOS / Mobile / PC Executor)
-- Gojo Satoru V12: GODLY ANIME ACCURATE (Epic Blue/Red Orbs & Black Hole Void)

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

local cc = Lighting:FindFirstChild("Gojo_CC_V12") or Instance.new("ColorCorrectionEffect", Lighting)
cc.Name = "Gojo_CC_V12"

local function playSound(id, pos, vol, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(id)
    sound.Volume = vol or 5
    sound.PlaybackSpeed = pitch or 1
    if pos then
        local att = Instance.new("Attachment", workspace.Terrain)
        att.WorldPosition = pos
        sound.Parent = att
        Debris:AddItem(att, 8)
    else
        sound.Parent = workspace
    end
    sound:Play()
    Debris:AddItem(sound, 8)
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

local function createLightning(centerPos, color, radius)
    local p = Instance.new("Part", workspace)
    p.Size = Vector3.new(1.2, math.random(25, 60), 1.2)
    p.Position = centerPos + Vector3.new(math.random(-radius, radius), math.random(-radius, radius), math.random(-radius, radius))
    p.Orientation = Vector3.new(math.random(0,360), math.random(0,360), math.random(0,360))
    p.Material = Enum.Material.Neon
    p.Color = color
    p.Anchored = true
    p.CanCollide = false
    TweenService:Create(p, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1, Size = Vector3.new(0, p.Size.Y * 2, 0)}):Play()
    Debris:AddItem(p, 0.15)
end

-- ================= GIAO DIỆN MENU V12 =================
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "Gojo_V12_Gui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 340, 0, 440)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -220)
mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(220, 0, 255)
mainFrame.BorderSizePixel = 0

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "GOJO SATORU - PHIÊN BẢN V12"
title.TextColor3 = Color3.fromRGB(240, 210, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 15

local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 55, 0, 55)
openBtn.Position = UDim2.new(0, 20, 0.5, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
openBtn.Text = "V12"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 15
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 28)
openBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

local function createBtn(name, color, y)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local btnBlue = createBtn("1. Thương (Blue) - Siêu Hút Đẹp", Color3.fromRGB(0, 110, 255), 55)
local btnRed = createBtn("2. Hách (Red) - Sóng Xung Kích Đẹp", Color3.fromRGB(255, 30, 50), 105)
local btnPurple = createBtn("3. Hư Thức Tử V12 (Cầu Xanh/Đỏ Cực Phê)", Color3.fromRGB(150, 0, 255), 155)
local btnDomain = createBtn("4. Vô Lượng Không Sứ V12 (Chuẩn Ảnh Hố Đen)", Color3.fromRGB(30, 0, 60), 205)
local btnOutfit = createBtn("5. Mod Trang Phục Gojo Chuẩn", Color3.fromRGB(200, 70, 160), 255)

-- ================= 3. HƯ THỨC TỬ V12 (QUẢ CẦU XANH & ĐỎ ĐẸP LUNG LINH) =================
btnPurple.MouseButton1Click:Connect(function()
    if not hrp then return end
    hrp.Anchored = true 
    
    local cam = workspace.CurrentCamera
    TweenService:Create(cam, TweenInfo.new(1.5), {FieldOfView = 35}):Play()
    playSound(7435165623, hrp.Position, 9) 
    
    local leftPos = hrp.Position + (hrp.CFrame.RightVector * -7) + Vector3.new(0, 2, 0)
    local rightPos = hrp.Position + (hrp.CFrame.RightVector * 7) + Vector3.new(0, 2, 0)
    
    -- QUẢ CẦU XANH (BLUE) ĐƯỢC NÂNG CẤP ĐẸP NHƯ ANIME (ĐA TẦNG + VÒNG QUAY)
    local blue = Instance.new("Part", workspace)
    blue.Shape = Enum.PartType.Ball; blue.Size = Vector3.new(0.5, 0.5, 0.5); blue.Position = leftPos
    blue.Color = Color3.fromRGB(0, 200, 255); blue.Material = Enum.Material.Neon; blue.Anchored = true; blue.CanCollide = false
    
    local blueRing = Instance.new("Part", workspace)
    blueRing.Shape = Enum.PartType.Ball; blueRing.Size = Vector3.new(0.6, 0.6, 0.6); blueRing.Position = leftPos
    blueRing.Color = Color3.fromRGB(0, 80, 255); blueRing.Material = Enum.Material.ForceField; blueRing.Anchored = true; blueRing.CanCollide = false

    -- QUẢ CẦU ĐỎ (RED) ĐƯỢC NÂNG CẤP RỰC RỠ KHÔNG KÉM
    local red = Instance.new("Part", workspace)
    red.Shape = Enum.PartType.Ball; red.Size = Vector3.new(0.5, 0.5, 0.5); red.Position = rightPos
    red.Color = Color3.fromRGB(255, 50, 50); red.Material = Enum.Material.Neon; red.Anchored = true; red.CanCollide = false
    
    local redRing = Instance.new("Part", workspace)
    redRing.Shape = Enum.PartType.Ball; redRing.Size = Vector3.new(0.6, 0.6, 0.6); redRing.Position = rightPos
    redRing.Color = Color3.fromRGB(255, 150, 0); redRing.Material = Enum.Material.ForceField; redRing.Anchored = true; redRing.CanCollide = false

    TweenService:Create(blue, TweenInfo.new(1.8), {Size = Vector3.new(16, 16, 16)}):Play()
    TweenService:Create(blueRing, TweenInfo.new(1.8), {Size = Vector3.new(18, 18, 18)}):Play()
    TweenService:Create(red, TweenInfo.new(1.8), {Size = Vector3.new(16, 16, 16)}):Play()
    TweenService:Create(redRing, TweenInfo.new(1.8), {Size = Vector3.new(18, 18, 18)}):Play()
    cameraShake(2, 1.2)
    
    for i = 1, 15 do
        task.wait(0.1)
        createLightning(blue.Position, Color3.fromRGB(0, 200, 255), 8)
        createLightning(red.Position, Color3.fromRGB(255, 80, 80), 8)
    end
    
    local combinePos = hrp.Position + (hrp.CFrame.LookVector * 5) + Vector3.new(0, 1.5, 0)
    TweenService:Create(blue, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = combinePos, Size = Vector3.new(5, 5, 5)}):Play()
    TweenService:Create(blueRing, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = combinePos, Size = Vector3.new(6, 6, 6)}):Play()
    TweenService:Create(red, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = combinePos, Size = Vector3.new(5, 5, 5)}):Play()
    TweenService:Create(redRing, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = combinePos, Size = Vector3.new(6, 6, 6)}):Play()
    
    task.wait(0.25)
    blue:Destroy(); blueRing:Destroy(); red:Destroy(); redRing:Destroy()
    
    cc.Brightness = 2.5; cc.TintColor = Color3.fromRGB(255, 255, 255)
    TweenService:Create(cc, TweenInfo.new(0.8), {Brightness = 0, TintColor = Color3.fromRGB(130, 0, 255)}):Play()
    playSound(9114223403, combinePos, 10, 0.75) 
    cameraShake(3.5, 6)
    TweenService:Create(cam, TweenInfo.new(0.15), {FieldOfView = 110}):Play()
    task.wait(0.15)
    TweenService:Create(cam, TweenInfo.new(1.2), {FieldOfView = 70}):Play()
    
    local purpleCore = Instance.new("Part", workspace)
    purpleCore.Shape = Enum.PartType.Ball; purpleCore.Size = Vector3.new(45, 45, 45); purpleCore.Position = combinePos
    purpleCore.Color = Color3.fromRGB(130, 0, 255); purpleCore.Material = Enum.Material.Neon; purpleCore.Anchored = true; purpleCore.CanCollide = false
    
    local blackHoleRing = Instance.new("Part", workspace)
    blackHoleRing.Shape = Enum.PartType.Ball; blackHoleRing.Size = Vector3.new(55, 55, 55); blackHoleRing.Position = combinePos
    blackHoleRing.Color = Color3.fromRGB(0, 0, 0); blackHoleRing.Material = Enum.Material.Glass; blackHoleRing.Anchored = true; blackHoleRing.CanCollide = false
    
    local endPos = combinePos + (hrp.CFrame.LookVector * 550)
    local stepConn; local startT = os.clock()
    
    stepConn = RunService.Heartbeat:Connect(function()
        local alpha = (os.clock() - startT) / 1.5
        if alpha >= 1 then
            stepConn:Disconnect()
            playSound(157878578, purpleCore.Position, 10)
            local finalExp = Instance.new("Part", workspace)
            finalExp.Shape = Enum.PartType.Ball; finalExp.Size = Vector3.new(200, 200, 200); finalExp.Position = purpleCore.Position
            finalExp.Color = Color3.fromRGB(180, 80, 255); finalExp.Material = Enum.Material.Neon; finalExp.Anchored = true; finalExp.CanCollide = false
            TweenService:Create(finalExp, TweenInfo.new(1.2), {Size = Vector3.new(450, 450, 450), Transparency = 1}):Play()
            Debris:AddItem(finalExp, 1.2)
            purpleCore:Destroy()
            blackHoleRing:Destroy()
            TweenService:Create(cc, TweenInfo.new(1), {Brightness = 0, Contrast = 0, TintColor = Color3.fromRGB(255, 255, 255)}):Play()
            hrp.Anchored = false
            return
        end
        
        local currentPos = combinePos:Lerp(endPos, alpha)
        purpleCore.Position = currentPos
        blackHoleRing.Position = currentPos
        createLightning(currentPos, Color3.fromRGB(180, 50, 255), 45)
        
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Anchored and v ~= purpleCore and v ~= blackHoleRing then
                local dist = (v.Position - currentPos).Magnitude
                if dist < 100 then
                    v.Velocity = (currentPos - v.Position).Unit * 600 + Vector3.new(math.random(-50,50), math.random(100,300), math.random(-50,50))
                    if dist < 40 and v.Size.Magnitude > 3 then
                        v.Size = v.Size * 0.95
                    end
                end
            end
        end
    end)
end)

-- ================= 4. VÔ LƯỢNG KHÔNG SỨ V12 (CHUẨN ẢNH HỐ ĐEN ANIME) =================
btnDomain.MouseButton1Click:Connect(function()
    if not hrp then return end
    hrp.Anchored = true
    local centerPos = hrp.Position
    
    cc.Brightness = 1.2; cc.Contrast = 2.5
    playSound(6542823628, centerPos, 9) 
    TweenService:Create(cc, TweenInfo.new(1.5), {Brightness = 0, Contrast = 0}):Play()
    task.wait(1.2)
    
    playSound(9114223635, centerPos, 10) 
    cameraShake(2.5, 3.5)
    
    local domainFloor = Instance.new("Part", workspace)
    domainFloor.Size = Vector3.new(0, 1, 0)
    domainFloor.Position = centerPos - Vector3.new(0, 4, 0)
    domainFloor.Color = Color3.fromRGB(130, 190, 255)
    domainFloor.Material = Enum.Material.Glass 
    domainFloor.Anchored = true; domainFloor.CanCollide = true
    
    local domainShell = Instance.new("Part", workspace)
    domainShell.Shape = Enum.PartType.Ball
    domainShell.Size = Vector3.new(0, 0, 0)
    domainShell.Position = centerPos
    domainShell.Color = Color3.fromRGB(20, 2, 45)
    domainShell.Material = Enum.Material.ForceField 
    domainShell.Anchored = true; domainShell.CanCollide = false
    
    -- HỐ ĐEN TRUNG TÂM CHUẨN NHƯ TRONG ẢNH BẠN GỬI
    local blackHoleCore = Instance.new("Part", workspace)
    blackHoleCore.Shape = Enum.PartType.Ball
    blackHoleCore.Size = Vector3.new(0, 0, 0)
    blackHoleCore.Position = centerPos + Vector3.new(0, 35, 0)
    blackHoleCore.Color = Color3.fromRGB(0, 0, 0)
    blackHoleCore.Material = Enum.Material.Glass
    blackHoleCore.Anchored = true; blackHoleCore.CanCollide = false

    local blackHoleRingGlow = Instance.new("Part", workspace)
    blackHoleRingGlow.Shape = Enum.PartType.Ball
    blackHoleRingGlow.Size = Vector3.new(0, 0, 0)
    blackHoleRingGlow.Position = centerPos + Vector3.new(0, 35, 0)
    blackHoleRingGlow.Color = Color3.fromRGB(150, 100, 255)
    blackHoleRingGlow.Material = Enum.Material.Neon
    blackHoleRingGlow.Anchored = true; blackHoleRingGlow.CanCollide = false

    TweenService:Create(domainFloor, TweenInfo.new(1.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Vector3.new(400, 1, 400)}):Play()
    TweenService:Create(domainShell, TweenInfo.new(1.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Vector3.new(400, 400, 400)}):Play()
    TweenService:Create(blackHoleCore, TweenInfo.new(1.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Vector3.new(45, 45, 45)}):Play()
    TweenService:Create(blackHoleRingGlow, TweenInfo.new(1.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Vector3.new(50, 50, 50), Transparency = 0.5}):Play()
    
    local stars = {}
    for i = 1, 300 do
        local star = Instance.new("Part", workspace)
        star.Shape = Enum.PartType.Ball
        star.Size = Vector3.new(1, 1, 1)
        local randomDir = Vector3.new(math.random(-150, 150), math.random(2, 180), math.random(-150, 150))
        star.Position = centerPos + randomDir
        star.Color = math.random(1, 3) == 1 and Color3.fromRGB(200, 150, 255) or Color3.new(1, 1, 1)
        star.Material = Enum.Material.Neon
        star.Anchored = true; star.CanCollide = false
        star.Transparency = 1
        table.insert(stars, star)
        TweenService:Create(star, TweenInfo.new(math.random(1, 2)), {Transparency = 0}):Play()
    end

    local freezeConn = RunService.Heartbeat:Connect(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Humanoid") and v.Parent ~= char then
                local targetHrp = v.Parent:FindFirstChild("HumanoidRootPart")
                if targetHrp and (targetHrp.Position - centerPos).Magnitude < 200 then
                    targetHrp.Anchored = true 
                end
            end
        end
    end)

    task.delay(10, function()
        freezeConn:Disconnect()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Humanoid") and v.Parent ~= char then
                local targetHrp = v.Parent:FindFirstChild("HumanoidRootPart")
                if targetHrp then targetHrp.Anchored = false end
            end
        end
        
        TweenService:Create(domainFloor, TweenInfo.new(1), {Size = Vector3.new(0, 0, 0)}):Play()
        TweenService:Create(domainShell, TweenInfo.new(1), {Size = Vector3.new(0, 0, 0), Transparency = 1}):Play()
        TweenService:Create(blackHoleCore, TweenInfo.new(1), {Size = Vector3.new(0, 0, 0), Transparency = 1}):Play()
        TweenService:Create(blackHoleRingGlow, TweenInfo.new(1), {Size = Vector3.new(0, 0, 0), Transparency = 1}):Play()
        
        for _, star in pairs(stars) do
            TweenService:Create(star, TweenInfo.new(0.4), {Transparency = 1}):Play()
            Debris:AddItem(star, 0.4)
        end
        
        task.wait(1)
        domainFloor:Destroy()
        domainShell:Destroy()
        blackHoleCore:Destroy()
        blackHoleRingGlow:Destroy()
        hrp.Anchored = false
    end)
end)

-- ================= KỸ NĂNG KHÁC & OUTFIT =================
btnBlue.MouseButton1Click:Connect(function()
    if not hrp then return end
    local pos = hrp.Position + (hrp.CFrame.LookVector * 25)
    playSound(9114223179, pos, 6) 
    local orb = Instance.new("Part", workspace)
    orb.Shape = Enum.PartType.Ball; orb.Size = Vector3.new(0.5, 0.5, 0.5); orb.Position = pos
    orb.Color = Color3.fromRGB(0, 200, 255); orb.Material = Enum.Material.Neon; orb.Anchored = true; orb.CanCollide = false
    TweenService:Create(orb, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {Size = Vector3.new(20, 20, 20)}):Play()
    cameraShake(1.5, 1)
    for i = 1, 25 do
        createLightning(pos, Color3.fromRGB(0, 200, 255), 18)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Anchored and v ~= orb and (v.Position - pos).Magnitude < 120 then
                v.Velocity = (pos - v.Position).Unit * 250 + Vector3.new(0, 40, 0)
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
    redOrb.Shape = Enum.PartType.Ball; redOrb.Size = Vector3.new(0.5, 0.5, 0.5); redOrb.Position = spawnPos
    redOrb.Color = Color3.fromRGB(255, 50, 50); redOrb.Material = Enum.Material.Neon; redOrb.Anchored = true; redOrb.CanCollide = false
    playSound(9114222986, spawnPos, 7) 
    TweenService:Create(redOrb, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {Size = Vector3.new(10, 10, 10)}):Play()
    for i=1, 10 do task.wait(0.08); createLightning(spawnPos, Color3.fromRGB(255, 80, 80), 12) end
    cc.Brightness = 1; cc.TintColor = Color3.fromRGB(255, 150, 150)
    TweenService:Create(cc, TweenInfo.new(0.5), {Brightness = 0, TintColor = Color3.fromRGB(255, 255, 255)}):Play()
    playSound(157878578, spawnPos, 9) 
    cameraShake(1.5, 4)
    local shockwave = Instance.new("Part", workspace)
    shockwave.Shape = Enum.PartType.Ball; shockwave.Size = Vector3.new(4, 4, 4); shockwave.Position = spawnPos
    shockwave.Color = Color3.fromRGB(255, 30, 30); shockwave.Material = Enum.Material.ForceField; shockwave.Anchored = true; shockwave.CanCollide = false
    TweenService:Create(shockwave, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Vector3.new(200, 200, 200), Transparency = 1}):Play()
    redOrb:Destroy()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Anchored and v ~= shockwave and (v.Position - spawnPos).Magnitude < 150 then
            v.Velocity = (v.Position - spawnPos).Unit * 450 + Vector3.new(0, 150, 0)
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
    btnOutfit.Text = "Đã Mod Gojo V12 Thành Công!"
    task.delay(2, function() btnOutfit.Text = "5. Mod Trang Phục Gojo Chuẩn" end)
end)
