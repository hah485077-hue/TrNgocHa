--========================================================--
-- 💎 VIP CYBER — PREMIUM PAID UI v4.0
-- GIAO DIỆN MỚI HOÀN TOÀN
-- Giữ nguyên hệ thống chức năng của bản cũ
--========================================================--
-- THAY TOÀN BỘ PHẦN UI CŨ:
-- từ:
-- --========================================
-- -- MENU UI với UIScale
-- cho đến hết phần NOTIFICATION của UI cũ.
--
-- Phần logic Lock / Fly / ESP / Teleport / Auto Escape
-- vẫn sử dụng các biến + function của script gốc.
local BASE_W = 365
local BASE_H = 430
local g = Instance.new("ScreenGui")
g.Name = "VipMenu"
g.ResetOnSpawn = false
g.IgnoreGuiInset = true
g.Parent = pg
--========================================================--
-- PALETTE
--========================================================--
local C = {
    Background = Color3.fromRGB(8, 8, 15),
    Panel = Color3.fromRGB(15, 15, 25),
    Panel2 = Color3.fromRGB(20, 20, 32),
    White = Color3.fromRGB(245, 245, 255),
    Gray = Color3.fromRGB(145, 145, 165),
    Purple = Color3.fromRGB(160, 70, 255),
    Purple2 = Color3.fromRGB(95, 30, 180),
    Gold = Color3.fromRGB(255, 190, 60),
    Gold2 = Color3.fromRGB(255, 120, 20),
    Green = Color3.fromRGB(40, 220, 125),
    Red = Color3.fromRGB(255, 70, 90),
    Cyan = Color3.fromRGB(60, 220, 255),
}
--========================================================--
-- MAIN WINDOW
--========================================================--
local f = Instance.new("Frame")
f.Name = "PremiumWindow"
f.Size = UDim2.fromOffset(BASE_W, BASE_H)
f.Position = UDim2.new(0, 18, 0.5, -BASE_H/2)
f.BackgroundColor3 = C.Background
f.BorderSizePixel = 0
f.Active = true
f.Parent = g
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 18)
local uiscale = Instance.new("UIScale")
uiscale.Scale = 0.92
uiscale.Parent = f
-- Shadow
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 18, 1, 18)
shadow.Position = UDim2.fromOffset(-9, 9)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.45
shadow.BorderSizePixel = 0
shadow.ZIndex = -5
shadow.Parent = f
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 22)
-- Outer premium border
local border = Instance.new("UIStroke")
border.Thickness = 2
border.Transparency = 0.05
border.Color = C.Purple
border.Parent = f
-- Background gradient
local bg = Instance.new("UIGradient")
bg.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 14, 34)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(10, 10, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 10))
})
bg.Rotation = 135
bg.Parent = f
--========================================================--
-- HEADER
--========================================================--
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 76)
header.BackgroundColor3 = Color3.fromRGB(18, 15, 30)
header.BorderSizePixel = 0
header.Parent = f
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 18)
local headerBottom = Instance.new("Frame")
headerBottom.Size = UDim2.new(1, 0, 0, 18)
headerBottom.Position = UDim2.new(0, 0, 1, -18)
headerBottom.BackgroundColor3 = Color3.fromRGB(18, 15, 30)
headerBottom.BorderSizePixel = 0
headerBottom.Parent = header
-- VIP diamond
local diamond = Instance.new("Frame")
diamond.Size = UDim2.fromOffset(42, 42)
diamond.Position = UDim2.fromOffset(17, 17)
diamond.Rotation = 45
diamond.BackgroundColor3 = C.Purple
diamond.BorderSizePixel = 0
diamond.Parent = header
Instance.new("UICorner", diamond).CornerRadius = UDim.new(0, 8)
local diamondText = Instance.new("TextLabel")
diamondText.Size = UDim2.fromScale(1, 1)
diamondText.Rotation = -45
diamondText.BackgroundTransparency = 1
diamondText.Text = "V"
diamondText.TextColor3 = C.White
diamondText.Font = Enum.Font.GothamBlack
diamondText.TextSize = 21
diamondText.Parent = diamond
-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -125, 0, 25)
title.Position = UDim2.fromOffset(75, 13)
title.BackgroundTransparency = 1
title.Text = "VIP CYBER"
title.TextColor3 = C.White
title.Font = Enum.Font.GothamBlack
title.TextSize = 19
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -125, 0, 18)
subtitle.Position = UDim2.fromOffset(76, 38)
subtitle.BackgroundTransparency = 1
subtitle.Text = "PREMIUM EDITION  •  v4.0"
subtitle.TextColor3 = C.Gold
subtitle.Font = Enum.Font.GothamBold
subtitle.TextSize = 9
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header
-- Online indicator
local online = Instance.new("Frame")
online.Size = UDim2.fromOffset(74, 24)
online.Position = UDim2.new(1, -112, 0, 12)
online.BackgroundColor3 = Color3.fromRGB(25, 45, 35)
online.BorderSizePixel = 0
online.Parent = header
Instance.new("UICorner", online).CornerRadius = UDim.new(1, 0)
local dot = Instance.new("Frame")
dot.Size = UDim2.fromOffset(7, 7)
dot.Position = UDim2.fromOffset(9, 8)
dot.BackgroundColor3 = C.Green
dot.BorderSizePixel = 0
dot.Parent = online
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
local onlineText = Instance.new("TextLabel")
onlineText.Size = UDim2.new(1, -22, 1, 0)
onlineText.Position = UDim2.fromOffset(21, 0)
onlineText.BackgroundTransparency = 1
onlineText.Text = "VIP"
onlineText.TextColor3 = C.Green
onlineText.Font = Enum.Font.GothamBold
onlineText.TextSize = 9
onlineText.Parent = online
-- Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(28, 28)
closeBtn.Position = UDim2.new(1, -40, 0, 43)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 25, 45)
closeBtn.Text = "×"
closeBtn.TextColor3 = C.White
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 19
closeBtn.AutoButtonColor = false
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
--========================================================--
-- NAVIGATION
--========================================================--
local nav = Instance.new("Frame")
nav.Size = UDim2.new(1, -24, 0, 42)
nav.Position = UDim2.fromOffset(12, 86)
nav.BackgroundColor3 = Color3.fromRGB(12, 11, 20)
nav.BorderSizePixel = 0
nav.Parent = f
Instance.new("UICorner", nav).CornerRadius = UDim.new(0, 10)
local navLayout = Instance.new("UIListLayout")
navLayout.FillDirection = Enum.FillDirection.Horizontal
navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
navLayout.VerticalAlignment = Enum.VerticalAlignment.Center
navLayout.Padding = UDim.new(0, 5)
navLayout.Parent = nav
local function createTab(text, icon)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(105, 32)
    b.BackgroundColor3 = Color3.fromRGB(25, 23, 38)
    b.Text = icon .. "  " .. text
    b.TextColor3 = C.Gray
    b.Font = Enum.Font.GothamBold
    b.TextSize = 9
    b.AutoButtonColor = false
    b.Parent = nav
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end
local tabCombat = createTab("COMBAT", "⚔")
local tabMovement = createTab("MOVE", "◆")
local tabUtility = createTab("UTILITY", "✦")
--========================================================--
-- CONTENT
--========================================================--
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -24, 1, -140)
content.Position = UDim2.fromOffset(12, 136)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = C.Purple
content.CanvasSize = UDim2.new(0, 0, 0, 600)
content.Parent = f
local function sectionTitle(text, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 20)
    lbl.Position = UDim2.fromOffset(5, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = C.Gold
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = content
    return lbl
end
local function createCard(text, desc, x, y, w, callback)
    local card = Instance.new("TextButton")
    card.Size = UDim2.fromOffset(w, 61)
    card.Position = UDim2.fromOffset(x, y)
    card.BackgroundColor3 = Color3.fromRGB(19, 18, 30)
    card.BorderSizePixel = 0
    card.Text = ""
    card.AutoButtonColor = false
    card.Parent = content
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 11)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Transparency = 0.55
    stroke.Color = Color3.fromRGB(100, 80, 140)
    stroke.Parent = card
    local icon = Instance.new("Frame")
    icon.Size = UDim2.fromOffset(36, 36)
    icon.Position = UDim2.fromOffset(10, 12)
    icon.BackgroundColor3 = Color3.fromRGB(35, 28, 55)
    icon.BorderSizePixel = 0
    icon.Parent = card
    Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 9)
    local iconText = Instance.new("TextLabel")
    iconText.Size = UDim2.fromScale(1, 1)
    iconText.BackgroundTransparency = 1
    iconText.Text = "✦"
    iconText.TextColor3 = C.Purple
    iconText.Font = Enum.Font.GothamBlack
    iconText.TextSize = 15
    iconText.Parent = icon
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, -100, 0, 21)
    name.Position = UDim2.fromOffset(55, 10)
    name.BackgroundTransparency = 1
    name.Text = text
    name.TextColor3 = C.White
    name.Font = Enum.Font.GothamBold
    name.TextSize = 10
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.Parent = card
    local description = Instance.new("TextLabel")
    description.Size = UDim2.new(1, -100, 0, 17)
    description.Position = UDim2.fromOffset(55, 31)
    description.BackgroundTransparency = 1
    description.Text = desc
    description.TextColor3 = C.Gray
    description.Font = Enum.Font.Gotham
    description.TextSize = 8
    description.TextXAlignment = Enum.TextXAlignment.Left
    description.Parent = card
    local status = Instance.new("TextLabel")
    status.Size = UDim2.fromOffset(48, 22)
    status.Position = UDim2.new(1, -58, 0.5, -11)
    status.BackgroundColor3 = Color3.fromRGB(35, 32, 45)
    status.Text = "OFF"
    status.TextColor3 = C.Gray
    status.Font = Enum.Font.GothamBlack
    status.TextSize = 8
    status.Parent = card
    Instance.new("UICorner", status).CornerRadius = UDim.new(1, 0)
    local enabled = false
    local function update()
        if enabled then
            status.Text = "ON"
            status.TextColor3 = C.Green
            status.BackgroundColor3 = Color3.fromRGB(22, 65, 45)
            stroke.Color = C.Purple
            stroke.Transparency = 0.1
        else
            status.Text = "OFF"
            status.TextColor3 = C.Gray
            status.BackgroundColor3 = Color3.fromRGB(35, 32, 45)
            stroke.Color = Color3.fromRGB(100, 80, 140)
            stroke.Transparency = 0.55
        end
    end
    card.MouseButton1Click:Connect(function()
        enabled = not enabled
        update()
        if callback then
            callback(enabled)
        end
    end)
    return card, function(v)
        enabled = v
        update()
    end
end
--========================================================--
-- COMBAT TAB
--========================================================--
local combatObjects = {}
sectionTitle("COMBAT SYSTEM", 5)
local lockCard, setLockUI = createCard(
    "LOCK ON",
    "Khóa camera vào mục tiêu gần tâm màn hình",
    5, 30, 168,
    function()
        bLock:Activate()
    end
)
local autoCard, setAutoUI = createCard(
    "SMART TELEPORT",
    "Tự động né khi nhận sát thương",
    181, 30, 168,
    function()
        bAutoEsc:Activate()
    end
)
local espCard, setESPUI = createCard(
    "ENEMY ESP",
    "Hiển thị tên và HP của đối thủ",
    5, 99, 168,
    function()
        bESP:Activate()
    end
)
local predictiveCard, setPredictiveUI = createCard(
    "PREDICTIVE",
    "Phát hiện animation tấn công",
    181, 99, 168,
    function()
        Config.PredictiveEnabled = not Config.PredictiveEnabled
    end
)
table.insert(combatObjects, lockCard)
table.insert(combatObjects, autoCard)
table.insert(combatObjects, espCard)
table.insert(combatObjects, predictiveCard)
--========================================================--
-- MOVEMENT TAB
--========================================================--
sectionTitle("MOVEMENT SYSTEM", 175)
local flyCard, setFlyUI = createCard(
    "FLY MODE",
    "Bay tự do bằng joystick / phím",
    5, 200, 168,
    function()
        bFly:Activate()
    end
)
local speedCard, setSpeedUI = createCard(
    "SPEED BOOST",
    "Tăng tốc độ di chuyển",
    181, 200, 168,
    function()
        bFast:Activate()
    end
)
local noclipCard, setNoclipUI = createCard(
    "NOCLIP",
    "Đi xuyên vật thể",
    5, 269, 168,
    function()
        bNoclip:Activate()
    end
)
local teleportCard, setTeleportUI = createCard(
    "TELEPORT",
    "Dịch chuyển tới vị trí đang nhìn",
    181, 269, 168,
    function()
        bTp:Activate()
    end
)
--========================================================--
-- UTILITY
--========================================================--
sectionTitle("UTILITY", 344)
local saveCard = createCard(
    "SAVE POSITION",
    "Lưu vị trí hiện tại",
    5, 369, 168,
    function()
        bSave:Activate()
    end
)
local backCard = createCard(
    "RETURN",
    "Quay lại vị trí đã lưu",
    181, 369, 168,
    function()
        bBack:Activate()
    end
)
--========================================================--
-- SLIDERS
--========================================================--
local function premiumSlider(text, y, min, max, value, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -10, 0, 55)
    holder.Position = UDim2.fromOffset(5, y)
    holder.BackgroundColor3 = Color3.fromRGB(16, 15, 25)
    holder.BorderSizePixel = 0
    holder.Parent = content
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 10)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 0, 20)
    label.Position = UDim2.fromOffset(15, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. "    " .. value
    label.TextColor3 = C.White
    label.Font = Enum.Font.GothamBold
    label.TextSize = 9
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -30, 0, 7)
    bar.Position = UDim2.fromOffset(15, 34)
    bar.BackgroundColor3 = Color3.fromRGB(38, 35, 50)
    bar.BorderSizePixel = 0
    bar.Active = true
    bar.Parent = holder
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = C.Purple
    fill.BorderSizePixel = 0
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(15, 15)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((value-min)/(max-min), 0, 0.5, 0)
    knob.BackgroundColor3 = C.White
    knob.BorderSizePixel = 0
    knob.Parent = bar
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local draggingSlider = false
    local function update(x)
        local r = math.clamp(
            (x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
            0, 1
        )
        local v = math.floor(min + r * (max-min))
        fill.Size = UDim2.new(r, 0, 1, 0)
        knob.Position = UDim2.new(r, 0, 0.5, 0)
        label.Text = text .. "    " .. v
        callback(v)
    end
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            update(input.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if draggingSlider then
            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
                update(input.Position.X)
            end
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
end
premiumSlider(
    "FLY SPEED",
    438,
    20,
    300,
    Config.FlySpeed,
    function(v)
        Config.FlySpeed = v
    end
)
premiumSlider(
    "RUN SPEED",
    500,
    16,
    200,
    Config.RunSpeed,
    function(v)
        Config.RunSpeed = v
    end
)
--========================================================--
-- FOOTER
--========================================================--
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -24, 0, 20)
footer.Position = UDim2.new(0, 12, 1, -25)
footer.BackgroundTransparency = 1
footer.Text = "VIP CYBER  •  PREMIUM ACCESS  •  PRIVATE EDITION"
footer.TextColor3 = Color3.fromRGB(100, 95, 120)
footer.Font = Enum.Font.GothamBold
footer.TextSize = 7
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Parent = f
--========================================================--
-- VIP OPEN BUTTON
--========================================================--
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.fromOffset(58, 58)
openBtn.Position = UDim2.fromOffset(15, 15)
openBtn.BackgroundColor3 = Color3.fromRGB(15, 12, 25)
openBtn.Text = "VIP"
openBtn.TextColor3 = C.Gold
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 13
openBtn.Visible = false
openBtn.AutoButtonColor = false
openBtn.Parent = g
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
local openStroke = Instance.new("UIStroke")
openStroke.Thickness = 2
openStroke.Color = C.Purple
openStroke.Parent = openBtn
--========================================================--
-- FLY BUTTONS
--========================================================--
local function makeFlyButton(text, pos, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(56, 56)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(15, 14, 24)
    b.Text = text
    b.TextColor3 = color
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 24
    b.Visible = false
    b.AutoButtonColor = false
    b.Parent = g
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    local s = Instance.new("UIStroke")
    s.Thickness = 2
    s.Color = color
    s.Parent = b
    return b
end
local upBtn = makeFlyButton(
    "▲",
    UDim2.new(1, -78, 0.5, 5),
    C.Green
)
local dnBtn = makeFlyButton(
    "▼",
    UDim2.new(1, -78, 0.5, 70),
    C.Red
)
--========================================================--
-- DRAG
--========================================================--
local dragging = false
local dragStart
local startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = f.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        f.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
--========================================================--
-- CLOSE / OPEN
--========================================================--
closeBtn.MouseButton1Click:Connect(function()
    f.Visible = false
    openBtn.Visible = true
end)
openBtn.MouseButton1Click:Connect(function()
    f.Visible = true
    openBtn.Visible = false
end)
--========================================================--
-- TAB EFFECT
--========================================================--
local function selectTab(active)
    for _, tab in ipairs({tabCombat, tabMovement, tabUtility}) do
        tab.BackgroundColor3 = Color3.fromRGB(25, 23, 38)
        tab.TextColor3 = C.Gray
    end
    active.BackgroundColor3 = Color3.fromRGB(55, 30, 85)
    active.TextColor3 = C.Gold
end
selectTab(tabCombat)
tabCombat.MouseButton1Click:Connect(function()
    selectTab(tabCombat)
    content.CanvasPosition = Vector2.new(0, 0)
end)
tabMovement.MouseButton1Click:Connect(function()
    selectTab(tabMovement)
    content.CanvasPosition = Vector2.new(0, 175)
end)
tabUtility.MouseButton1Click:Connect(function()
    selectTab(tabUtility)
    content.CanvasPosition = Vector2.new(0, 344)
end)
--========================================================--
-- RAINBOW / PREMIUM ANIMATION
--========================================================--
local hue = 0
track(RunService.RenderStepped:Connect(function(dt)
    if not g.Parent then return end
    hue = (hue + dt * 0.08) % 1
    local rgb = Color3.fromHSV(hue, 0.7, 1)
    border.Color = rgb
    openStroke.Color = rgb
end))
--========================================================--
-- RESIZE
--========================================================--
local resize = Instance.new("TextButton")
resize.Size = UDim2.fromOffset(22, 22)
resize.Position = UDim2.new(1, -25, 1, -25)
resize.BackgroundColor3 = C.Purple
resize.Text = "◢"
resize.TextColor3 = C.White
resize.Font = Enum.Font.GothamBold
resize.TextSize = 12
resize.ZIndex = 20
resize.Parent = f
Instance.new("UICorner", resize).CornerRadius = UDim.new(0, 6)
local resizing = false
local resizeStart
local resizeScale = uiscale.Scale
resize.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        resizeScale = uiscale.Scale
    end
end)
UIS.InputChanged:Connect(function(input)
    if not resizing then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - resizeStart
        local amount = (delta.X + delta.Y) / 400
        uiscale.Scale = math.clamp(
            resizeScale + amount,
            0.65,
            1.35
        )
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)
--========================================================--
-- NOTIFICATION
--========================================================--
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "💎 VIP CYBER",
        Text = "PREMIUM INTERFACE LOADED",
        Duration = 4
    })
end)
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("💎 VIP CYBER PREMIUM UI v4.0")
print("◆ Premium Interface Loaded")
print("◆ Combat / Movement / Utility")
print("◆ Glass Dark + Purple/Gold Theme")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
