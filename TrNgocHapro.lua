-- VIP CYBER AI EDITION v5.8 (Siêu Mượt - Fix Lỗi Executor Mobile)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")

local p = Players.LocalPlayer
local pg = p:WaitForChild("PlayerGui")
local cam = workspace.CurrentCamera

if _G.__COMBINED_CLEANUP then pcall(_G.__COMBINED_CLEANUP) end
local conns = {}
local function track(c) table.insert(conns, c); return c end
_G.__COMBINED_CLEANUP = function()
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    conns = {}
    local old = pg:FindFirstChild("VipMenu")
    if old then old:Destroy() end
end
local oldMenu = pg:FindFirstChild("VipMenu")
if oldMenu then oldMenu:Destroy() end

local Config = {
    Lock = false, Fly = false, Fast = false, Noclip = false, ESP = false,
    RunSpeed = 50, FlySpeed = 60,
    AutoRetreat = true,        
    PredictiveRange = 60,      
    SafeDistance = 30,        
    RetreatDistance = 40,     
    TeleportDistance = 50,
    SoundEnabled = true,
}

local Character, Humanoid, Root
local HealthConn, HeartbeatConn, RenderConn
local lastRetreatTime = 0
local lastDamageTime = 0
local lastMoveTime = 0 
local tgt = nil
local flyBV, flyBG = nil, nil
local upS, dnS = 0, 0
local lastTp = 0
local savedPos = nil
local diedConn = nil
local espGuis = {}

local SOUND_RIFT  = "rbxassetid://1838218402"
local SOUND_GLASS = "rbxassetid://5152763850"
local SOUND_TELE  = "rbxassetid://6042053626"

local function playSoundLocal(soundId, volume, pitch)
    if not Config.SoundEnabled then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = soundId; s.Volume = volume or 1; s.PlaybackSpeed = pitch or 1
        s.Parent = SoundService; s:Play()
        Debris:AddItem(s, 8)
    end)
end

local function createSpaceTear(position, lookVector)
    playSoundLocal(SOUND_TELE, 1, 1.15)
    local cf = CFrame.new(position, position + lookVector)
    local rot90 = CFrame.Angles(0, 0, math.rad(90))
    
    local voidCore = Instance.new("Part")
    voidCore.Shape = Enum.PartType.Cylinder
    voidCore.Size = Vector3.new(0.6, 11, 11)
    voidCore.Anchored = true; voidCore.CanCollide = false
    voidCore.CanTouch = false; voidCore.CanQuery = false
    voidCore.Material = Enum.Material.Neon
    voidCore.Color = Color3.fromRGB(2, 0, 5)
    voidCore.CFrame = cf * rot90
    voidCore.Parent = workspace

    local outline = Instance.new("Part")
    outline.Shape = Enum.PartType.Cylinder
    outline.Size = Vector3.new(1.1, 14, 14)
    outline.Anchored = true; outline.CanCollide = false
    outline.Material = Enum.Material.SmoothPlastic
    outline.Color = Color3.fromRGB(240, 240, 255)
    outline.Transparency = 0.1
    outline.CFrame = cf * rot90
    outline.Parent = workspace

    task.delay(0.2, function()
        TweenService:Create(voidCore, TweenInfo.new(0.3), {Size = Vector3.new(0,0,0), Transparency = 1}):Play()
        TweenService:Create(outline, TweenInfo.new(0.3), {Size = Vector3.new(0,0,0), Transparency = 1}):Play()
        Debris:AddItem(voidCore, 0.4)
        Debris:AddItem(outline, 0.4)
    end)
end

-- ============ AI HELPERS ============
local currentAIState = "SAFE"

local function getNearestThreat()
    if not Root or not Root.Parent then return nil, math.huge end
    local nearest, nearestDist = nil, math.huge
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= p and otherPlayer.Character then
            local oRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            local oHum  = otherPlayer.Character:FindFirstChildOfClass("Humanoid")
            if oRoot and oHum and oHum.Health > 0 then
                local d = (oRoot.Position - Root.Position).Magnitude
                if d < nearestDist then nearest, nearestDist = oRoot, d end
            end
        end
    end
    return nearest, nearestDist
end

-- Hàm nhận diện Di Chuyển hoặc Dùng Skill siêu chuẩn (Fix cho cả Mobile)
local function isUserMovingOrAttacking()
    if not Humanoid or not Humanoid.Parent then return false end
    
    -- 1. Check bàn phím (PC)
    if UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.A) or 
       UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.D) or
       UIS:IsKeyDown(Enum.KeyCode.Up) or UIS:IsKeyDown(Enum.KeyCode.Down) or
       UIS:IsKeyDown(Enum.KeyCode.Left) or UIS:IsKeyDown(Enum.KeyCode.Right) then
        return true
    end
    
    -- 2. Check cần gạt (Mobile) hoặc Tốc độ di chuyển
    if Humanoid.MoveDirection.Magnitude > 0.1 then return true end
    if Root and Root.Parent then
        local vel = Root.AssemblyLinearVelocity
        if Vector3.new(vel.X, 0, vel.Z).Magnitude > 2 then return true end
    end
    
    -- 3. Check xem có đang vung đòn/dùng skill không
    local animator = Humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
            local an = string.lower(tr.Animation.Name)
            if string.find(an, "attack") or string.find(an, "punch") or string.find(an, "kick") 
            or string.find(an, "combo") or string.find(an, "skill") or string.find(an, "heavy") 
            or string.find(an, "m1") or string.find(an, "m2") then
                if not string.find(an, "idle") and not string.find(an, "walk") and not string.find(an, "run") then
                    return true
                end
            end
        end
    end
    
    return false
end

local function doRetreat(isContinuous)
    if not Config.AutoRetreat then return end
    if not Root or not Root.Parent then return end
    
    -- Nếu KHÔNG phải bị đánh (địch lại gần)
    if not isContinuous then
        -- Nếu đang di chuyển/đánh -> KHÔNG TELE
        if isUserMovingOrAttacking() then return end
        -- Nếu mới bỏ tay ra chưa đủ 3 giây -> KHÔNG TELE (Ý tưởng của anh)
        if (os.clock() - lastMoveTime) < 3.0 then return end
    end
    
    local threat = getNearestThreat()
    if not threat then return end
    
    local now = os.clock()
    local cooldown = isContinuous and 0.05 or 0.3
    if now - lastRetreatTime < cooldown then return end
    lastRetreatTime = now
    
    local oldPos = Root.Position
    local awayDir = oldPos - threat.Position
    awayDir = Vector3.new(awayDir.X, 0, awayDir.Z)
    if awayDir.Magnitude < 0.1 then
        awayDir = -Vector3.new(Root.CFrame.LookVector.X, 0, Root.CFrame.LookVector.Z)
    end
    awayDir = awayDir.Unit

    if not isContinuous then
        createSpaceTear(oldPos, awayDir)
    end

    local dist = isContinuous and 15 or Config.RetreatDistance
    local endPos = oldPos + awayDir * dist
    
    if isContinuous then
        Root.CFrame = CFrame.new(endPos, endPos + awayDir)
        Root.AssemblyLinearVelocity = Vector3.new(0,0,0)
    else
        TweenService:Create(Root, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {CFrame = CFrame.new(endPos, endPos + awayDir)}):Play()
    end
end

local function setupAI()
    if not Humanoid or not Root then return end
    if HealthConn then HealthConn:Disconnect() end
    
    local lastHealth = Humanoid.Health
    HealthConn = Humanoid.HealthChanged:Connect(function(newHealth)
        if not Config.AutoRetreat then return end 
        
        local damage = lastHealth - newHealth
        lastHealth = newHealth
        if damage > 0 then
            lastDamageTime = os.clock()
            task.spawn(function()
                doRetreat(true) 
            end)
        end
    end)
end

local function setupHeartbeatAI()
    if HeartbeatConn then HeartbeatConn:Disconnect() end
    local lastCheck = 0
    
    HeartbeatConn = RunService.Heartbeat:Connect(function()
        if not Root or not Root.Parent then return end
        if not Config.AutoRetreat then 
            currentAIState = "SAFE"
            return 
        end

        local now = os.clock()
        
        if now - lastDamageTime < 0.4 then
            currentAIState = "DANGER"
            return
        end

        if now - lastCheck < 0.1 then return end
        lastCheck = now

        local threat, dist = getNearestThreat()
        if not threat or dist > Config.PredictiveRange then
            currentAIState = "SAFE"
            return
        end

        -- Nếu đang di chuyển HOẶC mới bỏ nút chưa đủ 3s -> Hiện mặt CHIẾN
        if isUserMovingOrAttacking() or (os.clock() - lastMoveTime) < 3.0 then
            currentAIState = "FIGHT"
            return
        end

        if dist < Config.SafeDistance then
            currentAIState = "WARNING"
            doRetreat(false)
        else
            currentAIState = "WARNING"
        end
    end)
end

local function setupCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    Root = char:WaitForChild("HumanoidRootPart")
    
    if RenderConn then RenderConn:Disconnect() end
    RenderConn = RunService.RenderStepped:Connect(function()
        if Humanoid and Humanoid.Parent then
            local vel = Root and Root.Parent and Vector3.new(Root.AssemblyLinearVelocity.X, 0, Root.AssemblyLinearVelocity.Z).Magnitude or 0
            if Humanoid.MoveDirection.Magnitude > 0.1 or vel > 2 then
                lastMoveTime = os.clock()
            end
        end
    end)

    setupAI()
    setupHeartbeatAI()
end

if p.Character then setupCharacter(p.Character) end
p.CharacterAdded:Connect(setupCharacter)

-- ESP & TARGET
local function createESP(pl)
    local char = pl.Character; if not char then return end
    local head = char:FindFirstChild("Head"); local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not head or not humanoid then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_"..pl.Name; billboard.Size = UDim2.new(0, 120, 0, 45)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0); billboard.AlwaysOnTop = true; billboard.Adornee = head; billboard.Parent = head
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0,16); nameLabel.BackgroundTransparency = 1
    nameLabel.Text = pl.Name; nameLabel.TextColor3 = Color3.fromRGB(0,255,255); nameLabel.Font = Enum.Font.GothamBold; nameLabel.TextSize = 12; nameLabel.Parent = billboard
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(1, -20, 0, 8); healthBg.Position = UDim2.new(0, 10, 0, 18)
    healthBg.BackgroundColor3 = Color3.fromRGB(30,30,30); healthBg.BorderSizePixel = 0; healthBg.Parent = billboard
    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1,0,1,0); healthFill.BackgroundColor3 = Color3.fromRGB(0,255,0); healthFill.Parent = healthBg
    local healthText = Instance.new("TextLabel")
    healthText.Size = UDim2.new(1,0,0,12); healthText.Position = UDim2.new(0,0,0,28); healthText.BackgroundTransparency = 1
    healthText.TextColor3 = Color3.fromRGB(255,255,255); healthText.Font = Enum.Font.GothamBold; healthText.TextSize = 10; healthText.Parent = billboard
    espGuis[pl] = {Gui = billboard, Char = char, HealthFill = healthFill, HealthText = healthText}
end

local function removeESP(pl)
    if espGuis[pl] then if espGuis[pl].Gui then espGuis[pl].Gui:Destroy() end; espGuis[pl] = nil end
end
track(Players.PlayerRemoving:Connect(removeESP))
local function clearESP() for pl, data in pairs(espGuis) do if data.Gui then data.Gui:Destroy() end end; espGuis = {} end

local function findT()
    local vx, vy = cam.ViewportSize.X, cam.ViewportSize.Y
    if vx == 0 or vy == 0 then vx, vy = 1920, 1080 end
    local c = Vector2.new(vx/2, vy/2); local best, bd = nil, math.huge
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= p and pl.Character then
            local rp = pl.Character:FindFirstChild("HumanoidRootPart"); local h = pl.Character:FindFirstChildOfClass("Humanoid")
            if rp and h and h.Health > 0 then
                local sp, on = cam:WorldToViewportPoint(rp.Position)
                if on then local d = (Vector2.new(sp.X, sp.Y) - c).Magnitude; if d < bd then bd = d; best = pl end end
            end
        end
    end
    return best
end

--========================================
-- UI
--========================================
local BASE_W = 290; local BASE_H = 215
local g = Instance.new("ScreenGui")
g.Name = "VipMenu"; g.ResetOnSpawn = false; g.Parent = pg

local rainbowSeq = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,0,0)), ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255,165,0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255,255,0)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,255,0)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,150,255)), ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75,0,180)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,0,150)),
})
local ledElements = {}

local f = Instance.new("Frame", g)
f.Size = UDim2.new(0, BASE_W, 0, BASE_H); f.Position = UDim2.new(0, 8, 0, 10)
f.BackgroundColor3 = Color3.fromRGB(12,12,22); f.BorderSizePixel = 0; f.ZIndex = 1; f.Active = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0,12)
local uiscale = Instance.new("UIScale", f); uiscale.Scale = 1

local borderFrame = Instance.new("Frame", f)
borderFrame.Size = UDim2.new(1, 10, 1, 10); borderFrame.Position = UDim2.new(0, -5, 0, -5)
borderFrame.BackgroundColor3 = Color3.fromRGB(255,255,255); borderFrame.BorderSizePixel = 0; borderFrame.ZIndex = 0
Instance.new("UICorner", borderFrame).CornerRadius = UDim.new(0, 16)
local borderGrad = Instance.new("UIGradient", borderFrame); borderGrad.Color = rainbowSeq
track(RunService.RenderStepped:Connect(function(dt) borderGrad.Rotation = (borderGrad.Rotation + dt * 90) % 360 end))

local bgGrad = Instance.new("UIGradient", f)
bgGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,40)), ColorSequenceKeypoint.new(1, Color3.fromRGB(8,8,15))}); bgGrad.Rotation = 45

local hd = Instance.new("Frame", f)
hd.Size = UDim2.new(1, 0, 0, 28); hd.BackgroundColor3 = Color3.fromRGB(20,20,40); hd.BorderSizePixel = 0; hd.ZIndex = 2
Instance.new("UICorner", hd).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", hd)
title.Size = UDim2.new(1, -40, 1, 0); title.Position = UDim2.new(0, 8, 0, 0); title.BackgroundTransparency = 1
title.Text = "🤖 AI: (^_^) AN TOÀN"
title.TextColor3 = Color3.fromRGB(0, 255, 100); title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.ZIndex = 3
title.TextXAlignment = Enum.TextXAlignment.Left
table.insert(ledElements, title)

local closeBtn = Instance.new("TextButton", hd)
closeBtn.Size = UDim2.new(0, 22, 0, 22); closeBtn.Position = UDim2.new(1, -27, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40); closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 10
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

local cont = Instance.new("Frame", f)
cont.Size = UDim2.new(1, 0, 1, -28); cont.Position = UDim2.new(0, 0, 0, 28); cont.BackgroundTransparency = 1

local function mk(txt, x, y, w)
    local b = Instance.new("TextButton", cont)
    b.Size = UDim2.new(0, w, 0, 22); b.Position = UDim2.new(0, x, 0, y); b.BackgroundColor3 = Color3.fromRGB(35,35,55)
    b.Text = txt; b.TextColor3 = Color3.fromRGB(0,255,255); b.Font = Enum.Font.GothamBold; b.TextSize = 9; b.ZIndex = 2
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    local bStroke = Instance.new("UIStroke", b); bStroke.Thickness = 1.5; bStroke.Color = Color3.fromRGB(0,200,255)
    table.insert(ledElements, b); table.insert(ledElements, bStroke)
    return b
end

local activeSlider = nil
UIS.InputChanged:Connect(function(inp) if activeSlider then activeSlider(inp.Position.X) end end)
UIS.InputEnded:Connect(function(inp) activeSlider = nil end)

local function slider(label, y, min, max, init, cb)
    local lbl = Instance.new("TextLabel", cont)
    lbl.Size = UDim2.new(1, -12, 0, 14); lbl.Position = UDim2.new(0, 6, 0, y); lbl.BackgroundTransparency = 1
    lbl.Text = label .. ": " .. init; lbl.TextColor3 = Color3.fromRGB(0,255,255); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 9
    lbl.TextXAlignment = Enum.TextXAlignment.Left; table.insert(ledElements, lbl)

    local tr = Instance.new("Frame", cont)
    tr.Size = UDim2.new(1, -12, 0, 12); tr.Position = UDim2.new(0, 6, 0, y + 16); tr.BackgroundColor3 = Color3.fromRGB(30,30,45); tr.ZIndex = 2
    Instance.new("UICorner", tr).CornerRadius = UDim.new(0,6)
    local trStroke = Instance.new("UIStroke", tr); trStroke.Thickness = 2; trStroke.Color = Color3.fromRGB(0,200,255); table.insert(ledElements, trStroke)

    local fill = Instance.new("Frame", tr)
    fill.Size = UDim2.new((init-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0,200,255)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,6); table.insert(ledElements, fill)

    local hd2 = Instance.new("TextButton", tr)
    hd2.Size = UDim2.new(0, 16, 0, 16); hd2.Position = UDim2.new((init-min)/(max-min), -8, 0.5, -8)
    hd2.BackgroundColor3 = Color3.fromRGB(255,255,255); hd2.ZIndex = 3
    Instance.new("UICorner", hd2).CornerRadius = UDim.new(1,0)
    
    hd2.MouseButton1Down:Connect(function() activeSlider = function(x) 
        local r = math.clamp((x - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + r * (max - min))
        fill.Size = UDim2.new(r, 0, 1, 0); hd2.Position = UDim2.new(r, -8, 0.5, -8)
        lbl.Text = label .. ": " .. v; cb(v)
    end end)
end

local bLock  = mk("Lock On",      6,   4, 90)
local bSave  = mk("Lưu Điểm",   100,   4, 90)
local bAutoRetreat = mk("🛡️ Tự Lùi", 194, 4, 90) 

local bFast  = mk("Chạy Nhanh",   6,  30, 90)
local bBack  = mk("Về Điểm",    100,  30, 90)

local lblR = Instance.new("TextLabel", cont)
lblR.Size = UDim2.new(0, 90, 0, 12); lblR.Position = UDim2.new(0, 194, 0, 30); lblR.BackgroundTransparency = 1
lblR.Text = "Phạm vi: 30"; lblR.TextColor3 = Color3.fromRGB(0,255,255); lblR.Font = Enum.Font.GothamBold; lblR.TextSize = 8
lblR.TextXAlignment = Enum.TextXAlignment.Left; lblR.Active = true

local trR = Instance.new("TextButton", cont) 
trR.Size = UDim2.new(0, 90, 0, 10); trR.Position = UDim2.new(0, 194, 0, 43); trR.BackgroundColor3 = Color3.fromRGB(30,30,45)
trR.Text = ""; trR.AutoButtonColor = false; trR.ZIndex = 2
Instance.new("UICorner", trR).CornerRadius = UDim.new(0,5)

local fillR = Instance.new("Frame", trR)
fillR.Size = UDim2.new(0.333, 0, 1, 0); fillR.BackgroundColor3 = Color3.fromRGB(0,200,255)
Instance.new("UICorner", fillR).CornerRadius = UDim.new(0,5)

trR.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local function updateRange(x)
            local r = math.clamp((x - trR.AbsolutePosition.X) / trR.AbsoluteSize.X, 0, 1)
            local v = math.floor(15 + r * 45) 
            fillR.Size = UDim2.new(r, 0, 1, 0)
            lblR.Text = "Phạm vi: " .. v
            Config.SafeDistance = v
        end
        updateRange(input.Position.X)
        activeSlider = updateRange
    end
end)

slider("Tốc độ bay", 60, 20, 300, 60, function(v) Config.FlySpeed = v end)
slider("Tốc độ chạy", 96, 16, 200, 50, function(v) Config.RunSpeed = v end)

local bFly    = mk("Bay",          6, 132, 90)
local bNoclip = mk("Xuyên Map",  100, 132, 90)
local bTp     = mk("Dịch Chuyển",  6, 158, 90)
local bESP    = mk("ESP Kẻ Địch",100, 158, 90)

local resizeHandle = Instance.new("TextButton", f)
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundColor3 = Color3.fromRGB(100, 30, 150)
resizeHandle.Text = "◢"
resizeHandle.TextColor3 = Color3.fromRGB(255, 255, 255)
resizeHandle.TextSize = 14
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.ZIndex = 20
resizeHandle.Active = true
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 6)

local resizing = false
local resizeStart = nil
local startScale = 1

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true; resizeStart = input.Position; startScale = uiscale.Scale
    end
end)
track(UIS.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStart
        local deltaAvg = (delta.X + delta.Y) / 2
        uiscale.Scale = math.clamp(startScale + deltaAvg / 300, 0.4, 2.0)
    end
end))
track(UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end
end))

RunService.RenderStepped:Connect(function()
    if currentAIState == "SAFE" then
        title.Text = "🤖 AI: (^_^) AN TOÀN"; title.TextColor3 = Color3.fromRGB(0, 255, 100)
    elseif currentAIState == "WARNING" then
        title.Text = "🤖 AI: (O_O) NGUY HIỂM"; title.TextColor3 = Color3.fromRGB(255, 200, 0)
    elseif currentAIState == "DANGER" then
        title.Text = "🤖 AI: (>_<) NÉ ĐÂY!"; title.TextColor3 = Color3.fromRGB(255, 50, 50)
    elseif currentAIState == "FIGHT" then
        title.Text = "🤖 AI: (ง'̀-'́)ง CHIẾN"; title.TextColor3 = Color3.fromRGB(0, 255, 255)
    end
end)

local openBtn = Instance.new("TextButton", g)
openBtn.Size = UDim2.new(0, 44, 0, 44); openBtn.Position = UDim2.new(0, 8, 0, 10)
openBtn.BackgroundColor3 = Color3.fromRGB(20,20,40); openBtn.Text = "VIP"; openBtn.TextColor3 = Color3.fromRGB(0,255,255)
openBtn.Font = Enum.Font.GothamBold; openBtn.TextSize = 11; openBtn.Visible = false; openBtn.ZIndex = 10
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

local upBtn = Instance.new("TextButton", g)
upBtn.Size = UDim2.new(0, 50, 0, 50); upBtn.Position = UDim2.new(1, -70, 0.5, 20)
upBtn.BackgroundColor3 = Color3.fromRGB(0,180,0); upBtn.Text = "▲"; upBtn.TextColor3 = Color3.fromRGB(255,255,255)
upBtn.Font = Enum.Font.GothamBold; upBtn.TextSize = 24; upBtn.Visible = false; upBtn.ZIndex = 10
Instance.new("UICorner", upBtn).CornerRadius = UDim.new(1,0)

local dnBtn = Instance.new("TextButton", g)
dnBtn.Size = UDim2.new(0, 50, 0, 50); dnBtn.Position = UDim2.new(1, -70, 0.5, 80)
dnBtn.BackgroundColor3 = Color3.fromRGB(180,0,0); dnBtn.Text = "▼"; dnBtn.TextColor3 = Color3.fromRGB(255,255,255)
dnBtn.Font = Enum.Font.GothamBold; dnBtn.TextSize = 24; dnBtn.Visible = false; dnBtn.ZIndex = 10
Instance.new("UICorner", dnBtn).CornerRadius = UDim.new(1,0)

upBtn.MouseButton1Down:Connect(function() upS = 1 end); upBtn.MouseButton1Up:Connect(function() upS = 0 end)
dnBtn.MouseButton1Down:Connect(function() dnS = 1 end); dnBtn.MouseButton1Up:Connect(function() dnS = 0 end)

closeBtn.MouseButton1Click:Connect(function() f.Visible = false; openBtn.Visible = true end)
openBtn.MouseButton1Click:Connect(function() f.Visible = true; openBtn.Visible = false end)

local function set(b, on, onT, offT) b.Text = on and onT or offT; b.BackgroundColor3 = on and Color3.fromRGB(0,150,60) or Color3.fromRGB(35,35,55) end

bLock.MouseButton1Click:Connect(function()
    Config.Lock = not Config.Lock
    if Config.Lock then
        local t = findT()
        if t and t.Character then
            local rp = t.Character:FindFirstChild("HumanoidRootPart"); local h = t.Character:FindFirstChildOfClass("Humanoid")
            if rp and h then
                if diedConn then diedConn:Disconnect() end
                tgt = {Root = rp, Humanoid = h, Char = t.Character}
                diedConn = h.Died:Connect(function() Config.Lock = false; set(bLock, false, "Lock On: BAT", "Lock On: TAT"); cam.CameraType = Enum.CameraType.Custom; tgt = nil end)
                set(bLock, true, "Lock On: BAT", "Lock On: TAT"); cam.CameraType = Enum.CameraType.Scriptable
            end
        else Config.Lock = false end
    else
        set(bLock, false, "Lock On: BAT", "Lock On: TAT"); if diedConn then diedConn:Disconnect() diedConn = nil end
        tgt = nil; cam.CameraType = Enum.CameraType.Custom
    end
end)

bFly.MouseButton1Click:Connect(function()
    Config.Fly = not Config.Fly; local ch = p.Character; local h = ch and ch:FindFirstChildOfClass("Humanoid")
    if Config.Fly then
        set(bFly, true, "Bay: BAT", "Bay: TAT"); if h then h.PlatformStand = true end
        local rp = ch and ch:FindFirstChild("HumanoidRootPart")
        if rp then
            flyBV = Instance.new("BodyVelocity", rp); flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            flyBG = Instance.new("BodyGyro", rp); flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9); flyBG.P = 10000
        end
        upBtn.Visible = true; dnBtn.Visible = true
    else
        set(bFly, false, "Bay: BAT", "Bay: TAT"); if h then h.PlatformStand = false end
        if flyBV then flyBV:Destroy() flyBV = nil end; if flyBG then flyBG:Destroy() flyBG = nil end
        upBtn.Visible = false; dnBtn.Visible = false
    end
end)

bFast.MouseButton1Click:Connect(function() Config.Fast = not Config.Fast; set(bFast, Config.Fast, "Chạy Nhanh: BAT", "Chạy Nhanh: TAT") end)
bNoclip.MouseButton1Click:Connect(function() Config.Noclip = not Config.Noclip; set(bNoclip, Config.Noclip, "Xuyên Map: BAT", "Xuyên Map: TAT") end)

bTp.MouseButton1Click:Connect(function()
    if os.clock() - lastTp < 0.1 then return end; lastTp = os.clock()
    local rp = p.Character and p.Character:FindFirstChild("HumanoidRootPart"); if not rp then return end
    local ray = cam:ViewportPointToRay(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    local res = workspace:Raycast(ray.Origin, ray.Direction * 1000, RaycastParams.new())
    if res then rp.CFrame = CFrame.new(res.Position + Vector3.new(0, 3, 0)) end
end)

bSave.MouseButton1Click:Connect(function()
    local rp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    if rp then savedPos = rp.Position; bSave.Text = "Da luu!"; task.wait(1.5); bSave.Text = "Lưu Điểm" end
end)

bBack.MouseButton1Click:Connect(function()
    if not savedPos then return end
    local rp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    if rp then rp.CFrame = CFrame.new(savedPos + Vector3.new(0, 3, 0)); bBack.Text = "Da ve!"; task.wait(1); bBack.Text = "Về Điểm" end
end)

bESP.MouseButton1Click:Connect(function() Config.ESP = not Config.ESP; set(bESP, Config.ESP, "ESP: BAT", "ESP: TAT"); if not Config.ESP then clearESP() end end)

bAutoRetreat.MouseButton1Click:Connect(function() 
    Config.AutoRetreat = not Config.AutoRetreat
    set(bAutoRetreat, Config.AutoRetreat, "🛡️ BẬT", "🛡️ TẮT") 
end)

-- LOOPS
RunService.RenderStepped:Connect(function()
    local ch = p.Character; if not ch then return end
    local h = ch:FindFirstChildOfClass("Humanoid"); local rp = ch:FindFirstChild("HumanoidRootPart")
    if not h or not rp then return end
    if Config.Noclip then for _, pt in pairs(ch:GetDescendants()) do if pt:IsA("BasePart") then pt.CanCollide = false end end end
    if rp.Position.Y < -50 then rp.CFrame = CFrame.new(0, 50, 0); rp.AssemblyLinearVelocity = Vector3.new(0,0,0) end
    if Config.Lock and tgt and tgt.Root and tgt.Root.Parent then
        local targetPos = tgt.Root.Position; local hd2 = Vector3.new(targetPos.X - rp.Position.X, 0, targetPos.Z - rp.Position.Z)
        if hd2.Magnitude > 1 then hd2 = hd2.Unit; cam.CFrame = cam.CFrame:Lerp(CFrame.new(rp.Position - hd2 * 12 + Vector3.new(0, 4, 0), targetPos), 0.35) end
    end
    if Config.ESP then
        for _, pl in pairs(Players:GetPlayers()) do
            if pl ~= p and pl.Character then
                if not espGuis[pl] or espGuis[pl].Char ~= pl.Character then removeESP(pl); createESP(pl) end
                local data = espGuis[pl]
                if data then
                    local hum = pl.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local ratio = hum.MaxHealth > 0 and (hum.Health / hum.MaxHealth) or 0
                        data.HealthFill.Size = UDim2.new(ratio, 0, 1, 0); data.HealthText.Text = math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth)
                    end
                end
            else removeESP(pl) end
        end
    else if next(espGuis) then clearESP() end end
end)

RunService.Heartbeat:Connect(function()
    local ch = p.Character; if not ch then return end
    local h = ch:FindFirstChildOfClass("Humanoid"); local rp = ch:FindFirstChild("HumanoidRootPart")
    if not h or not rp then return end
    if Config.Fly and flyBV and flyBG then
        if not h.PlatformStand then h.PlatformStand = true end
        local md = h.MoveDirection; local hm = Vector3.new(md.X, 0, md.Z)
        if hm.Magnitude > 0 then hm = hm.Unit * Config.FlySpeed end
        local u = (upS == 1 or UIS:IsKeyDown(Enum.KeyCode.Space)) and Config.FlySpeed or 0
        local d = (dnS == 1 or UIS:IsKeyDown(Enum.KeyCode.LeftControl)) and Config.FlySpeed or 0
        flyBV.Velocity = hm + Vector3.new(0, u - d, 0)
        if hm.Magnitude > 0 then flyBG.CFrame = CFrame.new(rp.Position, rp.Position + hm) end
    end
    if Config.Fast then h.WalkSpeed = Config.RunSpeed
    else if h.WalkSpeed == Config.RunSpeed then h.WalkSpeed = 16 end end
end)

p.CharacterAdded:Connect(function()
    Config.Lock, Config.Fly, Config.Fast, Config.Noclip = false, false, false, false
    set(bLock, false, "Lock On: BAT", "Lock On: TAT"); set(bFly, false, "Bay: BAT", "Bay: TAT")
    set(bFast, false, "Chạy Nhanh: BAT", "Chạy Nhanh: TAT"); set(bNoclip, false, "Xuyên Map: BAT", "Xuyên Map: TAT")
    flyBV, flyBG, tgt = nil, nil, nil; upBtn.Visible, dnBtn.Visible = false, false
end)
