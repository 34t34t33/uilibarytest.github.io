local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local function rand(n) return HttpService:GenerateGUID(false):gsub("-", ""):sub(1, n or 12) end
local protectgui = (syn and syn.protect_gui) or function(g) g.Parent = CoreGui end

local WindUI = {}
WindUI.__index = WindUI

local WinProto = {}
WinProto.__index = WinProto
local TabProto = {}
TabProto.__index = TabProto

function WindUI:CreateWindow(opts)
    local sz = opts.Size or UDim2.new(0,500,0,350)
    local winName = rand()
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = winName
    protectgui(mainGui)
    mainGui.IgnoreGuiInset = true
    mainGui.ResetOnSpawn = false
    mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local win = Instance.new("Frame")
    win.Name = rand()
    win.Size = sz
    win.Position = UDim2.new(0.5, -sz.X.Offset/2, 0.5, -sz.Y.Offset/2)
    win.BackgroundColor3 = Color3.fromRGB(24,24,24)
    win.AnchorPoint = Vector2.new(0,0)
    win.BorderSizePixel = 0
    win.Parent = mainGui
    win.ClipsDescendants = true
    local winCorner = Instance.new("UICorner")
    winCorner.CornerRadius = UDim.new(0,18)
    winCorner.Parent = win

    local top = Instance.new("Frame")
    top.Name = rand()
    top.Size = UDim2.new(1,0,0,44)
    top.BackgroundColor3 = Color3.fromRGB(32,32,32)
    top.BorderSizePixel = 0
    top.Parent = win
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0,18)
    topCorner.Parent = top
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = rand()
    titleLabel.Text = opts.Title or "WindUI"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1,-32,1,0)
    titleLabel.Position = UDim2.new(0,16,0,0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = top

    local minBtn = Instance.new("TextButton")
    minBtn.Name = rand()
    minBtn.Text = "-"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 20
    minBtn.TextColor3 = Color3.fromRGB(200,200,200)
    minBtn.BackgroundColor3 = Color3.fromRGB(44,44,44)
    minBtn.Size = UDim2.new(0,36,0,36)
    minBtn.Position = UDim2.new(1,-44,0.5,-18)
    minBtn.AnchorPoint = Vector2.new(0,0)
    minBtn.Parent = top
    local minBtnCorner = Instance.new("UICorner")
    minBtnCorner.CornerRadius = UDim.new(1,0)
    minBtnCorner.Parent = minBtn

    local openBtn = Instance.new("TextButton")
    openBtn.Name = rand()
    openBtn.Text = "Open "..(opts.Title or "WindUI")
    openBtn.Font = Enum.Font.GothamBold
    openBtn.TextSize = 18
    openBtn.TextColor3 = Color3.fromRGB(255,255,255)
    openBtn.BackgroundColor3 = Color3.fromRGB(44,44,44)
    openBtn.Size = UDim2.new(0,220,0,44)
    openBtn.Position = UDim2.new(0.5,-110,0,12)
    openBtn.Visible = false
    openBtn.Parent = mainGui
    local openBtnCorner = Instance.new("UICorner")
    openBtnCorner.CornerRadius = UDim.new(1,0)
    openBtnCorner.Parent = openBtn

    local sidebar = Instance.new("Frame")
    sidebar.Name = rand()
    sidebar.Size = UDim2.new(0,128,1,-44)
    sidebar.Position = UDim2.new(0,0,0,44)
    sidebar.BackgroundColor3 = Color3.fromRGB(28,28,28)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = win
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0,12)
    sidebarCorner.Parent = sidebar
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.FillDirection = Enum.FillDirection.Vertical
    sidebarLayout.Padding = UDim.new(0,7)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = sidebar

    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Name = rand()
    contentScroll.Size = UDim2.new(1,-140,1,-44)
    contentScroll.Position = UDim2.new(0,136,0,44)
    contentScroll.BackgroundColor3 = Color3.fromRGB(32,32,32)
    contentScroll.BorderSizePixel = 0
    contentScroll.Parent = win
    contentScroll.CanvasSize = UDim2.new(0,0,0,0)
    contentScroll.ScrollBarThickness = 7
    contentScroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0,12)
    contentCorner.Parent = contentScroll
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 12)
    contentPadding.PaddingLeft = UDim.new(0, 12)
    contentPadding.PaddingRight = UDim.new(0, 12)
    contentPadding.Parent = contentScroll

    local tabs = {}
    local selectedTab = nil

    local dragging, dragInput, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = win.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)

    minBtn.MouseButton1Click:Connect(function()
        win.Visible = false
        openBtn.Visible = true
    end)
    openBtn.MouseButton1Click:Connect(function()
        win.Visible = true
        openBtn.Visible = false
    end)
    local draggingOpen, dragInputOpen, dragStartOpen, startPosOpen
    openBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingOpen = true
            dragStartOpen = input.Position
            startPosOpen = openBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then draggingOpen = false end
            end)
        end
    end)
    openBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInputOpen = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInputOpen and draggingOpen then
            local delta = input.Position - dragStartOpen
            openBtn.Position = UDim2.new(startPosOpen.X.Scale, startPosOpen.X.Offset+delta.X, startPosOpen.Y.Scale, 12)
        end
    end)

    return setmetatable({
        mainGui = mainGui,
        win = win,
        sidebar = sidebar,
        contentScroll = contentScroll,
        tabs = tabs,
        selectedTab = selectedTab,
        selectTab = function(self,tab)
            for _,v in pairs(self.tabs) do
                v.btn.BackgroundColor3 = Color3.fromRGB(36,36,36)
                v.page.Visible = false
            end
            tab.btn.BackgroundColor3 = Color3.fromRGB(54,54,54)
            tab.page.Visible = true
            self.contentScroll.CanvasPosition = Vector2.new(0,0)
            selectedTab = tab
            if tab._resize then tab:_resize() end
        end
    }, WinProto)
end

function WinProto:Tab(tabOpts)
    local btn = Instance.new("TextButton")
    btn.Name = rand()
    btn.Text = (tabOpts.Icon and "   " or "")..tabOpts.Title
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(36,36,36)
    btn.Size = UDim2.new(1,-14,0,38)
    btn.Parent = self.sidebar
    btn.AutoButtonColor = false
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,10)
    btnCorner.Parent = btn
    if tabOpts.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Name = rand()
        icon.Image = typeof(tabOpts.Icon)=="string" and tabOpts.Icon or "rbxassetid://"..tabOpts.Icon
        icon.Size = UDim2.new(0,20,0,20)
        icon.Position = UDim2.new(0,10,0,9)
        icon.BackgroundTransparency = 1
        icon.Parent = btn
    end
    local page = Instance.new("Frame")
    page.Name = rand()
    page.Size = UDim2.new(1,0,0,0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = self.contentScroll
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0,18)
    pageLayout.FillDirection = Enum.FillDirection.Vertical
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Parent = page

    local function resize()
        page.Size = UDim2.new(1,0,0,pageLayout.AbsoluteContentSize.Y)
        self.contentScroll.CanvasSize = UDim2.new(0,0,0,pageLayout.AbsoluteContentSize.Y+24)
    end
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resize)
    resize()

    local tabObj = setmetatable({
        btn=btn,
        page=page,
        parentWin=self,
        _resize=resize
    }, TabProto)
    table.insert(self.tabs, tabObj)
    btn.MouseButton1Click:Connect(function() self:selectTab(tabObj) end)
    if #self.tabs == 1 then self:selectTab(tabObj) end
    return tabObj
end

function TabProto:Section(opts)
    local sec = Instance.new("Frame")
    sec.Name = rand()
    sec.Size = UDim2.new(1,0,0,44)
    sec.BackgroundColor3 = Color3.fromRGB(40,40,40)
    sec.BorderSizePixel = 0
    sec.Parent = self.page
    local secCorner = Instance.new("UICorner")
    secCorner.CornerRadius = UDim.new(1,0)
    secCorner.Parent = sec
    local lbl = Instance.new("TextLabel")
    lbl.Name = rand()
    lbl.Text = opts.Title
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 18
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1,-18,1,0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = sec
    return sec
end

function TabProto:Divider()
    local line = Instance.new("Frame")
    line.Name = rand()
    line.Size = UDim2.new(1,0,0,2)
    line.BackgroundColor3 = Color3.fromRGB(80,80,80)
    line.BorderSizePixel = 0
    line.Parent = self.page
    return line
end

function TabProto:Button(opts)
    local b = Instance.new("TextButton")
    b.Name = rand()
    b.Text = opts.Title
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 18
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.BackgroundColor3 = Color3.fromRGB(54,54,54)
    b.Size = UDim2.new(1,0,0,46)
    b.AnchorPoint = Vector2.new(0,0)
    b.Parent = self.page
    b.AutoButtonColor = false
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1,0)
    c.Parent = b
    if opts.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Name = rand()
        icon.Image = typeof(opts.Icon)=="string" and opts.Icon or "rbxassetid://"..opts.Icon
        icon.Size = UDim2.new(0,22,0,22)
        icon.Position = UDim2.new(1,-35,0.5,-11)
        icon.AnchorPoint = Vector2.new(1,0.5)
        icon.BackgroundTransparency = 1
        icon.Parent = b
    end
    b.MouseButton1Click:Connect(function() pcall(opts.Callback) end)
    return b
end

function TabProto:Toggle(opts)
    local f = Instance.new("Frame")
    f.Name = rand()
    f.Size = UDim2.new(1,0,0,46)
    f.BackgroundTransparency = 1
    f.Parent = self.page
    local bg = Instance.new("Frame")
    bg.Name = rand()
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.fromRGB(54,54,54)
    bg.Parent = f
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1,0)
    bgCorner.Parent = bg
    local label = Instance.new("TextLabel")
    label.Name = rand()
    label.Text = opts.Title
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 17
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1,-78,1,0)
    label.Position = UDim2.new(0,18,0,0)
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg
    local pill = Instance.new("TextButton")
    pill.Name = rand()
    pill.Size = UDim2.new(0,44,0,24)
    pill.BackgroundColor3 = Color3.fromRGB(90,90,90)
    pill.Position = UDim2.new(1,-62,0.5,0)
    pill.AnchorPoint = Vector2.new(0,0.5)
    pill.Parent = bg
    pill.AutoButtonColor = false
    local pillCorner = Instance.new("UICorner")
    pillCorner.CornerRadius = UDim.new(1,0)
    pillCorner.Parent = pill
    local dot = Instance.new("Frame")
    dot.Name = rand()
    dot.Size = UDim2.new(0,18,0,18)
    dot.Position = opts.Default and UDim2.new(1,-20,0.5,0) or UDim2.new(0,2,0.5,0)
    dot.AnchorPoint = Vector2.new(0.5,0.5)
    dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
    dot.Parent = pill
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1,0)
    dotCorner.Parent = dot
    local value = opts.Default
    pill.LayoutOrder = 100
    local function set(val,invoke)
        value = val
        if value then
            dot.Position = UDim2.new(1,-20,0.5,0)
            pill.BackgroundColor3 = Color3.fromRGB(32,160,80)
        else
            dot.Position = UDim2.new(0,2,0.5,0)
            pill.BackgroundColor3 = Color3.fromRGB(90,90,90)
        end
        if invoke then pcall(opts.Callback, value) end
    end
    set(value, false)
    pill.MouseButton1Click:Connect(function()
        set(not value, true)
    end)
    return f
end

function TabProto:Slider(opts)
    local f = Instance.new("Frame")
    f.Name = rand()
    f.Size = UDim2.new(1,0,0,46)
    f.BackgroundTransparency = 1
    f.Parent = self.page
    local bg = Instance.new("Frame")
    bg.Name = rand()
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.fromRGB(54,54,54)
    bg.Parent = f
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1,0)
    bgCorner.Parent = bg
    local label = Instance.new("TextLabel")
    label.Name = rand()
    label.Text = opts.Title
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 17
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1,-140,1,0)
    label.Position = UDim2.new(0,18,0,0)
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg
    local valueLbl = Instance.new("TextLabel")
    valueLbl.Name = rand()
    valueLbl.Text = tostring(opts.Default)
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.TextSize = 16
    valueLbl.TextColor3 = Color3.fromRGB(190,190,190)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Size = UDim2.new(0,54,0,24)
    valueLbl.Position = UDim2.new(1,-110,0.5,-12)
    valueLbl.TextYAlignment = Enum.TextYAlignment.Center
    valueLbl.Parent = bg
    local sliderBack = Instance.new("Frame")
    sliderBack.Name = rand()
    sliderBack.Size = UDim2.new(0,80,0,8)
    sliderBack.Position = UDim2.new(1,-70,0.5,-4)
    sliderBack.BackgroundColor3 = Color3.fromRGB(32,32,32)
    sliderBack.BorderSizePixel = 0
    sliderBack.Parent = bg
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1,0)
    sliderCorner.Parent = sliderBack
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = rand()
    sliderFill.Size = UDim2.new((opts.Default-opts.Min)/(opts.Max-opts.Min),0,1,0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(32,160,80)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBack
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1,0)
    fillCorner.Parent = sliderFill
    local thumb = Instance.new("Frame")
    thumb.Name = rand()
    thumb.Size = UDim2.new(0,16,0,16)
    thumb.Position = UDim2.new((opts.Default-opts.Min)/(opts.Max-opts.Min),-8,0.5,-8)
    thumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
    thumb.Parent = sliderBack
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1,0)
    thumbCorner.Parent = thumb
    thumb.ZIndex = sliderBack.ZIndex + 1
    local dragging = false
    local value = opts.Default
    local function set(val,invoke)
        val = math.clamp(val, opts.Min, opts.Max)
        local rel = (val-opts.Min)/(opts.Max-opts.Min)
        sliderFill.Size = UDim2.new(rel,0,1,0)
        thumb.Position = UDim2.new(rel,-8,0.5,-8)
        valueLbl.Text = tostring(val)
        value = val
        if invoke then pcall(opts.Callback, val) end
    end
    set(value, false)
    local function getSliderValueFromX(x)
        local absPos = sliderBack.AbsolutePosition.X
        local absSize = sliderBack.AbsoluteSize.X
        local rel = math.clamp((x - absPos)/absSize,0,1)
        local val = math.floor((opts.Min + rel*(opts.Max-opts.Min))*100)/100
        return val
    end
    local function beginDrag(input)
        dragging = true
        set(getSliderValueFromX(input.Position.X), true)
        local move, up
        move = UserInputService.InputChanged:Connect(function(input2)
            if dragging and (input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch) then
                set(getSliderValueFromX(input2.Position.X), true)
            end
        end)
        up = UserInputService.InputEnded:Connect(function(input2)
            if input2.UserInputType == Enum.UserInputType.MouseButton1 or input2.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                move:Disconnect()
                up:Disconnect()
            end
        end)
    end
    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            beginDrag(input)
        end
    end)
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            beginDrag(input)
        end
    end)
    return f
end

function TabProto:Dropdown(opts)
    local f = Instance.new("Frame")
    f.Name = rand()
    f.Size = UDim2.new(1,0,0,46)
    f.BackgroundTransparency = 1
    f.Parent = self.page
    local bg = Instance.new("Frame")
    bg.Name = rand()
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.fromRGB(54,54,54)
    bg.Parent = f
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1,0)
    bgCorner.Parent = bg
    local label = Instance.new("TextLabel")
    label.Name = rand()
    label.Text = opts.Title
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 17
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1,-134,1,0)
    label.Position = UDim2.new(0,18,0,0)
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg
    local selLbl = Instance.new("TextLabel")
    selLbl.Name = rand()
    selLbl.Text = tostring(opts.Values and opts.Values[1] or "")
    selLbl.Font = Enum.Font.GothamBold
    selLbl.TextSize = 16
    selLbl.TextColor3 = Color3.fromRGB(190,190,190)
    selLbl.BackgroundTransparency = 1
    selLbl.Size = UDim2.new(0,80,0,24)
    selLbl.Position = UDim2.new(1,-90,0.5,-12)
    selLbl.TextYAlignment = Enum.TextYAlignment.Center
    selLbl.TextXAlignment = Enum.TextXAlignment.Right
    selLbl.Parent = bg
    local dropBtn = Instance.new("TextButton")
    dropBtn.Name = rand()
    dropBtn.Text = "▼"
    dropBtn.Font = Enum.Font.GothamBold
    dropBtn.TextSize = 18
    dropBtn.TextColor3 = Color3.fromRGB(220,220,220)
    dropBtn.BackgroundColor3 = Color3.fromRGB(54,54,54)
    dropBtn.Size = UDim2.new(0,28,0,24)
    dropBtn.Position = UDim2.new(1,-42,0.5,-12)
    dropBtn.Parent = bg
    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(1,0)
    dropCorner.Parent = dropBtn
    local ddOpen = false
    local ddFrame = nil
    local mainGui = bg:FindFirstAncestorOfClass("ScreenGui")
    local function closeDropdown()
        if ddOpen and ddFrame then
            ddFrame:Destroy()
            ddOpen = false
            ddFrame = nil
        end
    end
    dropBtn.MouseButton1Click:Connect(function()
        if ddOpen then closeDropdown() return end
        ddOpen = true
        ddFrame = Instance.new("Frame")
        ddFrame.Name = rand()
        local count = #opts.Values
        ddFrame.Size = UDim2.new(0,130,0,count*30)
        ddFrame.Position = UDim2.new(0, dropBtn.AbsolutePosition.X, 0, dropBtn.AbsolutePosition.Y + dropBtn.AbsoluteSize.Y + 4)
        ddFrame.BackgroundColor3 = Color3.fromRGB(44,44,44)
        ddFrame.ZIndex = 1000
        ddFrame.Parent = mainGui
        local ddCorner = Instance.new("UICorner")
        ddCorner.CornerRadius = UDim.new(0,12)
        ddCorner.Parent = ddFrame
        local ddLayout = Instance.new("UIListLayout")
        ddLayout.FillDirection = Enum.FillDirection.Vertical
        ddLayout.Padding = UDim.new(0,3)
        ddLayout.Parent = ddFrame
        for _,v in ipairs(opts.Values) do
            local optBtn = Instance.new("TextButton")
            optBtn.Name = rand()
            optBtn.Text = tostring(v)
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextSize = 15
            optBtn.TextColor3 = Color3.fromRGB(230,230,230)
            optBtn.BackgroundColor3 = Color3.fromRGB(54,54,54)
            optBtn.Size = UDim2.new(1,0,0,26)
            optBtn.ZIndex = 1001
            optBtn.Parent = ddFrame
            local ocorner = Instance.new("UICorner")
            ocorner.CornerRadius = UDim.new(0,8)
            ocorner.Parent = optBtn
            optBtn.MouseButton1Click:Connect(function()
                selLbl.Text = tostring(v)
                pcall(opts.Callback,v)
                closeDropdown()
            end)
        end
        local connection
        connection = UserInputService.InputBegan:Connect(function(input)
            if ddOpen and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                local mouse
                if input.UserInputType == Enum.UserInputType.Touch then
                    mouse = input.Position
                else
                    mouse = UserInputService:GetMouseLocation()
                end
                local abs = ddFrame.AbsolutePosition
                local size = ddFrame.AbsoluteSize
                if not (mouse.X >= abs.X and mouse.X <= abs.X+size.X and mouse.Y >= abs.Y and mouse.Y <= abs.Y+size.Y) then
                    closeDropdown()
                    if connection then connection:Disconnect() end
                end
            end
        end)
    end)
    return f
end

function TabProto:Paragraph(opts)
    local lbl = Instance.new("TextLabel")
    lbl.Name = rand()
    lbl.Text = opts.Title
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 19
    lbl.TextWrapped = true
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1,0,0,38)
    lbl.Parent = self.page
    return lbl
end

return setmetatable({}, WindUI)
