-- VIP CYBER V7 - LED 7 MAU + ESP + KEO MENU FIX
print("=== VIP CYBER V7 ===")
local P=game:GetService("Players")
local RS=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local p=P.LocalPlayer
local pg=p:WaitForChild("PlayerGui")
local cam=workspace.CurrentCamera

local old=pg:FindFirstChild("VipMenu")
if old then old:Destroy() end

local lock,fly,fast,noclip=false,false,false,false
local tgt,flyBV,flyBG,fs,rs2=nil,nil,nil,60,50
local upS,dnS=0,0
local lastTp,goodCam=0,nil
local savedPos=nil
local menuOn=true
local espEnabled=false

local g=Instance.new("ScreenGui")
g.Name="VipMenu"
g.ResetOnSpawn=false
g.Parent=pg

local rainbowSeq = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,0,0)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255,165,0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255,255,0)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,255,0)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,150,255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75,0,180)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,0,150)),
})

local ledElements = {}

local f=Instance.new("Frame",g)
f.Size=UDim2.new(0,180,0,215)
f.Position=UDim2.new(0, 10, 0, 10)
f.BackgroundColor3=Color3.fromRGB(12,12,22)
f.BorderSizePixel=0
f.ZIndex=1
Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)

local borderFrame = Instance.new("Frame", f)
borderFrame.Size = UDim2.new(1, 10, 1, 10)
borderFrame.Position = UDim2.new(0, -5, 0, -5)
borderFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
borderFrame.BorderSizePixel = 0
borderFrame.ZIndex = 0
Instance.new("UICorner", borderFrame).CornerRadius = UDim.new(0, 16)
local borderGrad = Instance.new("UIGradient", borderFrame)
borderGrad.Color = rainbowSeq

local borderAngle = 0
RS.RenderStepped:Connect(function(dt)
    borderAngle = (borderAngle + dt * 90) % 360
    borderGrad.Rotation = borderAngle
end)

local bgGrad = Instance.new("UIGradient", f)
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8,8,15)),
})
bgGrad.Rotation = 45

local hd=Instance.new("Frame",f)
hd.Size=UDim2.new(1,0,0,28)
hd.BackgroundColor3=Color3.fromRGB(20,20,40)
hd.BorderSizePixel=0
hd.ZIndex=2
hd.Active = true
hd.Parent=f
Instance.new("UICorner",hd).CornerRadius=UDim.new(0,12)
local hdCover=Instance.new("Frame",hd)
hdCover.Size=UDim2.new(1,0,0.5,0)
hdCover.Position=UDim2.new(0,0,0.5,0)
hdCover.BackgroundColor3=Color3.fromRGB(20,20,40)
hdCover.BorderSizePixel=0
hdCover.ZIndex=2
hdCover.Parent=hd

local title=Instance.new("TextLabel",hd)
title.Size=UDim2.new(1,-56,1,0)
title.BackgroundTransparency=1
title.Text="VIP CYBER"
title.TextColor3=Color3.fromRGB(0,255,255)
title.Font=Enum.Font.GothamBold
title.TextSize=12
title.ZIndex=3
title.Parent=hd
table.insert(ledElements, title)

local colBtn=Instance.new("TextButton",hd)
colBtn.Size=UDim2.new(0,22,0,22)
colBtn.Position=UDim2.new(1,-52,0,3)
colBtn.BackgroundColor3=Color3.fromRGB(35,40,60)
colBtn.Text="-"
colBtn.TextColor3=Color3.fromRGB(255,255,255)
colBtn.Font=Enum.Font.GothamBold
colBtn.TextSize=14
colBtn.ZIndex=3
Instance.new("UICorner",colBtn).CornerRadius=UDim.new(1,0)
table.insert(ledElements, colBtn)

local closeBtn=Instance.new("TextButton",hd)
closeBtn.Size=UDim2.new(0,22,0,22)
closeBtn.Position=UDim2.new(1,-27,0,3)
closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40)
closeBtn.Text="X"
closeBtn.TextColor3=Color3.fromRGB(255,255,255)
closeBtn.Font=Enum.Font.GothamBold
closeBtn.TextSize=12
closeBtn.ZIndex=3
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(1,0)

local cont=Instance.new("Frame",f)
cont.Size=UDim2.new(1,0,1,-28)
cont.Position=UDim2.new(0,0,0,28)
cont.BackgroundTransparency=1
cont.Parent=f

local hide={}

local function mk(txt,x,y,w)
    local b=Instance.new("TextButton",cont)
    b.Size=UDim2.new(0,w,0,22)
    b.Position=UDim2.new(0,x,0,y)
    b.BackgroundColor3=Color3.fromRGB(35,35,55)
    b.Text=txt
    b.TextColor3=Color3.fromRGB(0,255,255)
    b.Font=Enum.Font.GothamBold
    b.TextSize=9
    b.TextWrapped=true
    b.Parent=cont
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    local bStroke = Instance.new("UIStroke", b)
    bStroke.Thickness = 1.5
    bStroke.Color = Color3.fromRGB(0,200,255)
    bStroke.Transparency = 0.4
    table.insert(ledElements, b)
    table.insert(ledElements, bStroke)
    table.insert(hide,b)
    return b
end

local bLock=mk("Lock On: TAT", 6, 4, 82)
local bFly=mk("Bay: TAT", 6, 30, 82)
local bFast=mk("Chay Nhanh: TAT", 6, 56, 82)
local bNoclip=mk("Xuyen Map: TAT", 6, 82, 82)

local bSave=mk("Luu Diem", 92, 4, 82)
local bBack=mk("Ve Diem", 92, 30, 82)
local bTp=mk("Dich Chuyen", 92, 56, 82)
local bESP=mk("ESP: TAT", 92, 82, 82)

local function set(b,on,onT,offT)
    b.Text=on and onT or offT
    b.BackgroundColor3=on and Color3.fromRGB(0,150,60) or Color3.fromRGB(35,35,55)
end

local function slider(label,y,min,max,init,cb)
    local lbl=Instance.new("TextLabel",cont)
    lbl.Size=UDim2.new(1,-12,0,14)
    lbl.Position=UDim2.new(0,6,0,y)
    lbl.BackgroundTransparency=1
    lbl.Text=label..": "..init
    lbl.TextColor3=Color3.fromRGB(0,255,255)
    lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=9
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    table.insert(ledElements, lbl)
    table.insert(hide,lbl)

    local tr=Instance.new("Frame",cont)
    tr.Size=UDim2.new(1,-12,0,12)
    tr.Position=UDim2.new(0,6,0,y+16)
    tr.BackgroundColor3=Color3.fromRGB(30,30,45)
    tr.BorderSizePixel=0
    tr.Name = "SliderTrack"
    Instance.new("UICorner",tr).CornerRadius=UDim.new(0,6)
    
    local trStroke = Instance.new("UIStroke", tr)
    trStroke.Thickness = 2
    trStroke.Color = Color3.fromRGB(0,200,255)
    trStroke.Transparency = 0.2
    table.insert(ledElements, trStroke)
    table.insert(hide,tr)

    local fill=Instance.new("Frame",tr)
    fill.Size=UDim2.new((init-min)/(max-min),0,1,0)
    fill.BackgroundColor3=Color3.fromRGB(0,200,255)
    fill.BorderSizePixel=0
    Instance.new("UICorner",fill).CornerRadius=UDim.new(0,6)
    table.insert(ledElements, fill)

    local hd2=Instance.new("TextButton",tr)
    hd2.Size=UDim2.new(0,16,0,16)
    hd2.Position=UDim2.new((init-min)/(max-min),-8,0.5,-8)
    hd2.BackgroundColor3=Color3.fromRGB(255,255,255)
    hd2.Text=""
    Instance.new("UICorner",hd2).CornerRadius=UDim.new(1,0)
    
    local hdStroke = Instance.new("UIStroke", hd2)
    hdStroke.Thickness = 2
    hdStroke.Color = Color3.fromRGB(0,255,255)
    table.insert(ledElements, hdStroke)

    local isDragging = false

    local function updateFromInput(inputX)
        local ta=tr.AbsolutePosition.X
        local tw=tr.AbsoluteSize.X
        local r=math.clamp((inputX-ta)/tw,0,1)
        local v=math.floor(min+r*(max-min))
        fill.Size=UDim2.new(r,0,1,0)
        hd2.Position=UDim2.new(r,-8,0.5,-8)
        lbl.Text=label..": "..v
        cb(v)
    end

    hd2.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            isDragging = true
        end
    end)

    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            if isDragging then isDragging = false end
        end
    end)

    RS.RenderStepped:Connect(function()
        if isDragging then
            local mousePos = UIS:GetMouseLocation()
            updateFromInput(mousePos.X)
        end
    end)

    tr.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            updateFromInput(inp.Position.X)
            isDragging = true
        end
    end)
end

slider("Toc do bay", 110, 20, 300, 60, function(v) fs=v end)
slider("Toc do chay", 142, 16, 200, 50, function(v) rs2=v end)

local openBtn=Instance.new("TextButton",g)
openBtn.Size=UDim2.new(0,44,0,44)
openBtn.Position=UDim2.new(0,10,0,10)
openBtn.BackgroundColor3=Color3.fromRGB(20,20,40)
openBtn.Text="VIP"
openBtn.TextColor3=Color3.fromRGB(0,255,255)
openBtn.Font=Enum.Font.GothamBold
openBtn.TextSize=11
openBtn.Visible=false
Instance.new("UICorner",openBtn).CornerRadius=UDim.new(1,0)
local obStroke=Instance.new("UIStroke",openBtn)
obStroke.Thickness=2
obStroke.Color=Color3.fromRGB(0,255,255)
table.insert(ledElements, openBtn)
table.insert(ledElements, obStroke)

local upBtn=Instance.new("TextButton",g)
upBtn.Size=UDim2.new(0,44,0,44)
upBtn.Position=UDim2.new(1,-64,0.5,30)
upBtn.BackgroundColor3=Color3.fromRGB(0,150,0)
upBtn.Text="^"
upBtn.TextColor3=Color3.fromRGB(255,255,255)
upBtn.Font=Enum.Font.GothamBold
upBtn.TextSize=20
upBtn.Visible=false
Instance.new("UICorner",upBtn).CornerRadius=UDim.new(1,0)

local dnBtn=Instance.new("TextButton",g)
dnBtn.Size=UDim2.new(0,44,0,44)
dnBtn.Position=UDim2.new(1,-64,0.5,84)
dnBtn.BackgroundColor3=Color3.fromRGB(150,0,0)
dnBtn.Text="v"
dnBtn.TextColor3=Color3.fromRGB(255,255,255)
dnBtn.Font=Enum.Font.GothamBold
dnBtn.TextSize=20
dnBtn.Visible=false
Instance.new("UICorner",dnBtn).CornerRadius=UDim.new(1,0)

upBtn.MouseButton1Down:Connect(function() upS=1 end)
upBtn.MouseButton1Up:Connect(function() upS=0 end)
upBtn.MouseLeave:Connect(function() upS=0 end)
dnBtn.MouseButton1Down:Connect(function() dnS=1 end)
dnBtn.MouseButton1Up:Connect(function() dnS=0 end)
dnBtn.MouseLeave:Connect(function() dnS=0 end)

local dragging = false
local dragStart = nil
local startPos = nil

local function isButton(obj)
    while obj do
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then return true end
        obj = obj.Parent
    end
    return false
end

hd.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not isButton(input.Target) then
            dragging = true
            dragStart = input.Position
            startPos = f.Position
        end
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        f.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local textHue = 0
RS.RenderStepped:Connect(function(dt)
    textHue = (textHue + dt * 0.3) % 1
    local c = Color3.fromHSV(textHue, 0.8, 1)
    for _, obj in ipairs(ledElements) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            obj.TextColor3 = c
        elseif obj:IsA("UIStroke") then
            obj.Color = c
        elseif obj:IsA("Frame") then
            obj.BackgroundColor3 = c
        end
    end
end)

local espGuis = {}

local function createESP(pl)
    local char = pl.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not head or not humanoid then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_"..pl.Name
    billboard.Size = UDim2.new(0, 120, 0, 45)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = head
    billboard.Parent = head
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0,16)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = pl.Name
    nameLabel.TextColor3 = Color3.fromRGB(0,255,255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 12
    nameLabel.Parent = billboard
    
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(1, -20, 0, 8)
    healthBg.Position = UDim2.new(0, 10, 0, 18)
    healthBg.BackgroundColor3 = Color3.fromRGB(30,30,30)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = billboard
    Instance.new("UICorner", healthBg).CornerRadius = UDim.new(0,4)
    
    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1,0,1,0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0,255,0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg
    Instance.new("UICorner", healthFill).CornerRadius = UDim.new(0,4)
    
    local healthText = Instance.new("TextLabel")
    healthText.Size = UDim2.new(1,0,0,12)
    healthText.Position = UDim2.new(0,0,0,28)
    healthText.BackgroundTransparency = 1
    healthText.Text = ""
    healthText.TextColor3 = Color3.fromRGB(255,255,255)
    healthText.TextStrokeTransparency = 0
    healthText.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    healthText.Font = Enum.Font.GothamBold
    healthText.TextSize = 10
    healthText.Parent = billboard
    
    espGuis[pl] = {Gui = billboard, Char = char, NameLabel = nameLabel, HealthFill = healthFill, HealthText = healthText}
end

local function removeESP(pl)
    if espGuis[pl] then
        if espGuis[pl].Gui then
            espGuis[pl].Gui:Destroy()
        end
        espGuis[pl] = nil
    end
end

local function clearESP()
    for pl, data in pairs(espGuis) do
        if data.Gui then data.Gui:Destroy() end
    end
    espGuis = {}
end

P.PlayerRemoving:Connect(removeESP)

bESP.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    set(bESP, espEnabled, "ESP: BAT", "ESP: TAT")
    if not espEnabled then
        clearESP()
    end
end)

local function findT()
    local vx,vy=cam.ViewportSize.X,cam.ViewportSize.Y
    if vx==0 or vy==0 then vx,vy=1920,1080 end
    local c=Vector2.new(vx/2,vy/2)
    local best,bd=nil,math.huge
    for _,pl in pairs(P:GetPlayers()) do
        if pl~=p and pl.Character then
            local rp=pl.Character:FindFirstChild("HumanoidRootPart")
            local h=pl.Character:FindFirstChildOfClass("Humanoid")
            if rp and h and h.Health>0 then
                local sp,on=cam:WorldToViewportPoint(rp.Position)
                if on then
                    local d=(Vector2.new(sp.X,sp.Y)-c).Magnitude
                    if d<bd then bd=d;best=pl end
                end
            end
        end
    end
    return best
end

local diedConn=nil
bLock.MouseButton1Click:Connect(function()
    lock=not lock
    if lock then
        local t=findT()
        if t and t.Character then
            local rp=t.Character:FindFirstChild("HumanoidRootPart")
            local h=t.Character:FindFirstChildOfClass("Humanoid")
            if rp and h then
                if diedConn then diedConn:Disconnect() end
                tgt={Root=rp,Humanoid=h,Char=t.Character}
                diedConn=h.Died:Connect(function()
                    lock=false
                    set(bLock,false,"Lock On: BAT","Lock On: TAT")
                    cam.CameraType=Enum.CameraType.Custom
                    local mh=p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                    if mh then cam.CameraSubject=mh end
                    tgt=nil
                end)
                set(bLock,true,"Lock On: BAT","Lock On: TAT")
                cam.CameraType=Enum.CameraType.Scriptable
            end
        else
            lock=false
            set(bLock,false,"Lock On: BAT","Lock On: TAT")
        end
    else
        set(bLock,false,"Lock On: BAT","Lock On: TAT")
        if diedConn then diedConn:Disconnect() diedConn=nil end
        tgt=nil
        cam.CameraType=Enum.CameraType.Custom
        local mh=p.Character and p.Character:FindFirstChildOfClass("Humanoid")
        if mh then cam.CameraSubject=mh end
    end
end)

bFly.MouseButton1Click:Connect(function()
    fly=not fly
    local ch=p.Character
    local h=ch and ch:FindFirstChildOfClass("Humanoid")
    if fly then
        set(bFly,true,"Bay: BAT","Bay: TAT")
        if h then h.PlatformStand=true end
        local rp=ch and ch:FindFirstChild("HumanoidRootPart")
        if rp then
            flyBV=Instance.new("BodyVelocity",rp)
            flyBV.MaxForce=Vector3.new(9e9,9e9,9e9)
            flyBG=Instance.new("BodyGyro",rp)
            flyBG.MaxTorque=Vector3.new(9e9,9e9,9e9)
            flyBG.P=10000
        end
        upBtn.Visible=true
        dnBtn.Visible=true
    else
        set(bFly,false,"Bay: BAT","Bay: TAT")
        if h then h.PlatformStand=false end
        if flyBV then flyBV:Destroy() flyBV=nil end
        if flyBG then flyBG:Destroy() flyBG=nil end
        upBtn.Visible=false
        dnBtn.Visible=false
    end
end)

bFast.MouseButton1Click:Connect(function()
    fast=not fast
    set(bFast,fast,"Chay Nhanh: BAT","Chay Nhanh: TAT")
end)

bNoclip.MouseButton1Click:Connect(function()
    noclip=not noclip
    set(bNoclip,noclip,"Xuyen Map: BAT","Xuyen Map: TAT")
end)

bTp.MouseButton1Click:Connect(function()
    if tick()-lastTp<0.1 then return end
    lastTp=tick()
    local ch=p.Character
    local rp=ch and ch:FindFirstChild("HumanoidRootPart")
    if not rp then return end
    local c=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)
    local ray=cam:ViewportPointToRay(c.X,c.Y)
    local rp2=RaycastParams.new()
    rp2.FilterDescendantsInstances={ch}
    rp2.FilterType=Enum.RaycastFilterType.Exclude
    local res=workspace:Raycast(ray.Origin,ray.Direction*1000,rp2)
    if res then rp.CFrame=CFrame.new(res.Position+Vector3.new(0,3,0)) end
end)

bSave.MouseButton1Click:Connect(function()
    local ch=p.Character
    local rp=ch and ch:FindFirstChild("HumanoidRootPart")
    if not rp then return end
    savedPos=rp.Position
    bSave.Text="Da luu!"
    task.wait(1.5)
    bSave.Text="Luu Diem"
end)

bBack.MouseButton1Click:Connect(function()
    if not savedPos then
        bBack.Text="Chua luu!"
        task.wait(1.5)
        bBack.Text="Ve Diem"
        return
    end
    local ch=p.Character
    local rp=ch and ch:FindFirstChild("HumanoidRootPart")
    if not rp then return end
    rp.CFrame=CFrame.new(savedPos+Vector3.new(0,3,0))
    bBack.Text="Da ve!"
    task.wait(1)
    bBack.Text="Ve Diem"
end)

RS.RenderStepped:Connect(function()
    local ch=p.Character
    if not ch then return end
    local h=ch:FindFirstChildOfClass("Humanoid")
    local rp=ch:FindFirstChild("HumanoidRootPart")
    if not h or not rp then return end

    if noclip then
        for _,pt in pairs(ch:GetDescendants()) do
            if pt:IsA("BasePart") then pt.CanCollide=false end
        end
    end

    local vel=rp.AssemblyLinearVelocity
    if vel.Y<-60 then rp.AssemblyLinearVelocity=Vector3.new(vel.X,-60,vel.Z) end

    if rp.Position.Y<-5 then
        rp.AssemblyLinearVelocity=Vector3.new(0,0,0)
        rp.AssemblyAngularVelocity=Vector3.new(0,0,0)
        local rp3=RaycastParams.new()
        rp3.FilterDescendantsInstances={ch}
        rp3.FilterType=Enum.RaycastFilterType.Exclude
        local res=workspace:Raycast(Vector3.new(rp.Position.X,500,rp.Position.Z),Vector3.new(0,-2000,0),rp3)
        if res then
            rp.CFrame=CFrame.new(res.Position+Vector3.new(0,6,0))
        elseif goodCam then
            rp.CFrame=CFrame.new(goodCam.Position)+Vector3.new(0,-3,0)
        else
            rp.CFrame=CFrame.new(0,50,0)
        end
        rp.AssemblyLinearVelocity=Vector3.new(0,0,0)
    end

    if rp.Position.Y>-10 then goodCam=cam.CFrame end

    if lock and tgt and tgt.Root and tgt.Root.Parent then
        local myPos=rp.Position
        local targetPos=tgt.Root.Position
        local hd=Vector3.new(targetPos.X-myPos.X,0,targetPos.Z-myPos.Z)
        if hd.Magnitude<1 then
            local lk=rp.CFrame.LookVector
            hd=Vector3.new(lk.X,0,lk.Z)
            if hd.Magnitude<0.1 then hd=Vector3.new(0,0,1) end
        end
        hd=hd.Unit
        local camPos=myPos - hd*12 + Vector3.new(0,4,0)
        local head=tgt.Char and tgt.Char:FindFirstChild("Head")
        local lookAt=head and head.Position or targetPos
        cam.CFrame=cam.CFrame:Lerp(CFrame.new(camPos,lookAt),0.35)
    else
        if rp.Position.Y<-10 and goodCam then cam.CFrame=goodCam end
    end
    
    if espEnabled then
        for _, pl in pairs(P:GetPlayers()) do
            if pl ~= p and pl.Character then
                local char = pl.Character
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local head = char:FindFirstChild("Head")
                if humanoid and head then
                    if not espGuis[pl] or espGuis[pl].Char ~= char then
                        removeESP(pl)
                        createESP(pl)
                    end
                    local data = espGuis[pl]
                    if data then
                        local health = humanoid.Health
                        local maxHealth = humanoid.MaxHealth
                        local ratio = maxHealth > 0 and (health / maxHealth) or 0
                        data.HealthFill.Size = UDim2.new(ratio, 0, 1, 0)
                        local color = Color3.fromHSV(ratio * 0.33, 1, 1)
                        data.HealthFill.BackgroundColor3 = color
                        data.HealthText.Text = math.floor(health) .. " / " .. math.floor(maxHealth)
                    end
                else
                    removeESP(pl)
                end
            else
                removeESP(pl)
            end
        end
    else
        if next(espGuis) then
            clearESP()
        end
    end
end)

RS.Heartbeat:Connect(function()
    local ch=p.Character
    if not ch then return end
    local h=ch:FindFirstChildOfClass("Humanoid")
    local rp=ch:FindFirstChild("HumanoidRootPart")
    if not h or not rp then return end

    if fly and flyBV and flyBG then
        if not h.PlatformStand then h.PlatformStand=true end
        local md=h.MoveDirection
        local hm=Vector3.new(md.X,0,md.Z)
        if hm.Magnitude>0 then hm=hm.Unit*fs end
        local u=(upS==1 or UIS:IsKeyDown(Enum.KeyCode.Space)) and fs or 0
        local d=(dnS==1 or UIS:IsKeyDown(Enum.KeyCode.LeftControl)) and fs or 0
        flyBV.Velocity=hm+Vector3.new(0,u-d,0)
        if hm.Magnitude>0 then flyBG.CFrame=CFrame.new(rp.Position,rp.Position+hm) end
    end

    if fast then h.WalkSpeed=rs2 else if h.WalkSpeed==rs2 then h.WalkSpeed=16 end end
end)

p.CharacterAdded:Connect(function(c)
    c:WaitForChild("Humanoid")
    local h=c:FindFirstChildOfClass("Humanoid")
    if h then h.PlatformStand=false end
    lock,fly,fast,noclip=false,false,false,false
    set(bLock,false,"Lock On: BAT","Lock On: TAT")
    set(bFly,false,"Bay: BAT","Bay: TAT")
    set(bFast,false,"Chay Nhanh: BAT","Chay Nhanh: TAT")
    set(bNoclip,false,"Xuyen Map: BAT","Xuyen Map: TAT")
    flyBV,flyBG,tgt=nil,nil,nil
    goodCam=nil
    upBtn.Visible=false
    dnBtn.Visible=false
end)

print("=== OK V7 ===")
