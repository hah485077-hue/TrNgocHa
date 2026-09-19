-- VIP CYBER - BAN NGAN GON (2 COT) - LED 7 MAU
print("=== VIP CYBER ===")
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

local g=Instance.new("ScreenGui")
g.Name="VipMenu"
g.ResetOnSpawn=false
g.Parent=pg

local f=Instance.new("Frame",g)
f.Size=UDim2.new(0,170,0,190)
f.Position=UDim2.new(0,10,0,10)
f.BackgroundColor3=Color3.fromRGB(15,15,25)
f.BorderSizePixel=0
Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)

-- VIEN LED 7 MAU (DAY HON)
local ms=Instance.new("UIStroke",f)
ms.Thickness=5 -- Do day cua vien
ms.Color=Color3.fromRGB(0,200,255)

-- Hieu ung LED 7 mau chay
local hue = 0
RS.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.5) % 1 -- Toc do chay cua mau
    ms.Color = Color3.fromHSV(hue, 1, 1)
end)

local hd=Instance.new("Frame",f)
hd.Size=UDim2.new(1,0,0,24)
hd.BackgroundColor3=Color3.fromRGB(30,30,50)
hd.BorderSizePixel=0
hd.ZIndex=2
hd.Parent=f
Instance.new("UICorner",hd).CornerRadius=UDim.new(0,10)

local title=Instance.new("TextLabel",hd)
title.Size=UDim2.new(1,-52,1,0)
title.BackgroundTransparency=1
title.Text="VIP CYBER"
title.TextColor3=Color3.fromRGB(0,255,255)
title.Font=Enum.Font.GothamBold
title.TextSize=11
title.ZIndex=3
title.Parent=hd

local colBtn=Instance.new("TextButton",hd)
colBtn.Size=UDim2.new(0,20,0,20)
colBtn.Position=UDim2.new(1,-46,0,2)
colBtn.BackgroundColor3=Color3.fromRGB(40,45,60)
colBtn.Text="-"
colBtn.TextColor3=Color3.fromRGB(255,255,255)
colBtn.Font=Enum.Font.GothamBold
colBtn.TextSize=12
colBtn.ZIndex=3
Instance.new("UICorner",colBtn).CornerRadius=UDim.new(1,0)

local closeBtn=Instance.new("TextButton",hd)
closeBtn.Size=UDim2.new(0,20,0,20)
closeBtn.Position=UDim2.new(1,-24,0,2)
closeBtn.BackgroundColor3=Color3.fromRGB(150,40,40)
closeBtn.Text="X"
closeBtn.TextColor3=Color3.fromRGB(255,255,255)
closeBtn.Font=Enum.Font.GothamBold
closeBtn.TextSize=11
closeBtn.ZIndex=3
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(1,0)

local cont=Instance.new("Frame",f)
cont.Size=UDim2.new(1,0,1,-24)
cont.Position=UDim2.new(0,0,0,24)
cont.BackgroundTransparency=1
cont.Parent=f

local hide={}

local function mk(txt,x,y,w)
    local b=Instance.new("TextButton",cont)
    b.Size=UDim2.new(0,w,0,20)
    b.Position=UDim2.new(0,x,0,y)
    b.BackgroundColor3=Color3.fromRGB(45,45,65)
    b.Text=txt
    b.TextColor3=Color3.fromRGB(255,255,255)
    b.Font=Enum.Font.GothamBold
    b.TextSize=9
    b.Parent=cont
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
    table.insert(hide,b)
    return b
end

local bLock=mk("Lock On: TAT", 6, 4, 75)
local bFly=mk("Bay: TAT", 6, 26, 75)
local bFast=mk("Chay Nhanh: TAT", 6, 48, 75)
local bNoclip=mk("Xuyen Map: TAT", 6, 70, 75)

local bSave=mk("Luu Diem", 87, 4, 75)
local bBack=mk("Ve Diem", 87, 26, 75)
local bTp=mk("Dich Chuyen", 87, 48, 75)

local function set(b,on,onT,offT)
    b.Text=on and onT or offT
    b.BackgroundColor3=on and Color3.fromRGB(0,140,0) or Color3.fromRGB(45,45,65)
end

-- Thanh truot (Slider) DA FIX LOI
local function slider(label,y,min,max,init,cb)
    local lbl=Instance.new("TextLabel",cont)
    lbl.Size=UDim2.new(1,-12,0,12)
    lbl.Position=UDim2.new(0,6,0,y)
    lbl.BackgroundTransparency=1
    lbl.Text=label..": "..init
    lbl.TextColor3=Color3.fromRGB(200,200,200)
    lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=8
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    table.insert(hide,lbl)

    local tr=Instance.new("Frame",cont)
    tr.Size=UDim2.new(1,-12,0,12)
    tr.Position=UDim2.new(0,6,0,y+14)
    tr.BackgroundColor3=Color3.fromRGB(40,40,55)
    tr.BorderSizePixel=0
    Instance.new("UICorner",tr).CornerRadius=UDim.new(0,6)
    table.insert(hide,tr)

    local fill=Instance.new("Frame",tr)
    fill.Size=UDim2.new((init-min)/(max-min),0,1,0)
    fill.BackgroundColor3=Color3.fromRGB(0,200,255)
    fill.BorderSizePixel=0
    Instance.new("UICorner",fill).CornerRadius=UDim.new(0,6)

    local hd2=Instance.new("TextButton",tr)
    hd2.Size=UDim2.new(0,16,0,16)
    hd2.Position=UDim2.new((init-min)/(max-min),-8,0.5,-8)
    hd2.BackgroundColor3=Color3.fromRGB(255,255,255)
    hd2.Text=""
    Instance.new("UICorner",hd2).CornerRadius=UDim.new(1,0)

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
            if isDragging then
                isDragging = false
            end
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

slider("Toc do bay", 96, 20, 300, 60, function(v) fs=v end)
slider("Toc do chay", 122, 16, 200, 50, function(v) rs2=v end)

local openBtn=Instance.new("TextButton",g)
openBtn.Size=UDim2.new(0,40,0,40)
openBtn.Position=UDim2.new(0,10,0,10)
openBtn.BackgroundColor3=Color3.fromRGB(30,30,50)
openBtn.Text="VIP"
openBtn.TextColor3=Color3.fromRGB(0,255,255)
openBtn.Font=Enum.Font.GothamBold
openBtn.TextSize=11
openBtn.Visible=false
Instance.new("UICorner",openBtn).CornerRadius=UDim.new(1,0)
local obStroke=Instance.new("UIStroke",openBtn)
obStroke.Thickness=2
obStroke.Color=Color3.fromRGB(0,255,255)

local upBtn=Instance.new("TextButton",g)
upBtn.Size=UDim2.new(0,40,0,40)
upBtn.Position=UDim2.new(1,-60,0.5,30)
upBtn.BackgroundColor3=Color3.fromRGB(0,150,0)
upBtn.Text="^"
upBtn.TextColor3=Color3.fromRGB(255,255,255)
upBtn.Font=Enum.Font.GothamBold
upBtn.TextSize=18
upBtn.Visible=false
Instance.new("UICorner",upBtn).CornerRadius=UDim.new(1,0)

local dnBtn=Instance.new("TextButton",g)
dnBtn.Size=UDim2.new(0,40,0,40)
dnBtn.Position=UDim2.new(1,-60,0.5,80)
dnBtn.BackgroundColor3=Color3.fromRGB(150,0,0)
dnBtn.Text="v"
dnBtn.TextColor3=Color3.fromRGB(255,255,255)
dnBtn.Font=Enum.Font.GothamBold
dnBtn.TextSize=18
dnBtn.Visible=false
Instance.new("UICorner",dnBtn).CornerRadius=UDim.new(1,0)

upBtn.MouseButton1Down:Connect(function() upS=1 end)
upBtn.MouseButton1Up:Connect(function() upS=0 end)
upBtn.MouseLeave:Connect(function() upS=0 end)
dnBtn.MouseButton1Down:Connect(function() dnS=1 end)
dnBtn.MouseButton1Up:Connect(function() dnS=0 end)
dnBtn.MouseLeave:Connect(function() dnS=0 end)

colBtn.MouseButton1Click:Connect(function()
    if f.Size.Y.Offset>24 then
        f.Size=UDim2.new(0,170,0,24)
        for _,e in pairs(hide) do e.Visible=false end
        colBtn.Text="+"
    else
        f.Size=UDim2.new(0,170,0,190)
        for _,e in pairs(hide) do e.Visible=true end
        colBtn.Text="-"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    menuOn=false
    f.Visible=false
    openBtn.Visible=true
end)

openBtn.MouseButton1Click:Connect(function()
    menuOn=true
    f.Visible=true
    openBtn.Visible=false
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

print("=== OK ===")
