local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local function rand(n)
    return HttpService:GenerateGUID(false):gsub("-", ""):sub(1, n or 12)
end

local protectgui = syn and syn.protect_gui or function(g) g.Parent = CoreGui end

local WindUI = {}
WindUI.__index = WindUI

local WinProto = {}
WinProto.__index = WinProto
local TabProto = {}
TabProto.__index = TabProto

function WindUI:CreateWindow(opts)
    local sz = opts.Size or UDim2.new(0, 500, 0, 350)
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = rand()
    mainGui.Parent = CoreGui
    protectgui(mainGui)
    mainGui.IgnoreGuiInset = true
    mainGui.ResetOnSpawn = false

    local win = Instance.new("Frame")
    win.Name = rand()
    win.Size = sz
    win.Position = UDim2.new(0.5, -sz.X.Offset / 2, 0.5, -sz.Y.Offset / 2)
    win.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    win.AnchorPoint = Vector2.new(0, 0)
    win.BorderSizePixel = 0
    win.Parent = mainGui

    local winCorner = Instance.new("UICorner")
    winCorner.CornerRadius = UDim.new(0, 14)
    winCorner.Parent = win

    local top = Instance.new("Frame")
    top.Name = rand()
    top.Size = UDim2.new(1, 0, 0, 46)
    top.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    top.BorderSizePixel = 0
    top.Parent = win

    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 14)
    topCorner.Parent = top

    local iconDrag = Instance.new("ImageLabel")
    iconDrag.Name = rand()
    iconDrag.Image = "rbxassetid://120973619002380"
    iconDrag.Size = UDim2.new(0, 28, 0, 28)
    iconDrag.Position = UDim2.new(0, 12, 0, 9)
    iconDrag.BackgroundTransparency = 1
    iconDrag.Parent = top

    local iconHand = Instance.new("ImageLabel")
    iconHand.Name = rand()
    iconHand.Image = "rbxassetid://120973619002379"
    iconHand.Size = UDim2.new(0, 28, 0, 28)
    iconHand.Position = UDim2.new(0, 44, 0, 9)
    iconHand.BackgroundTransparency = 1
    iconHand.Parent = top

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = rand()
    titleLabel.Text = opts.Title or "WindUI"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -120, 1, 0)
    titleLabel.Position = UDim2.new(0, 80, 0, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = top

    local openBtn = Instance.new("TextButton")
    openBtn.Name = rand()
    openBtn.Text = ""
    openBtn.BackgroundTransparency = 1
    openBtn.Size = UDim2.new(1, 0, 1, 0)
    openBtn.Position = UDim2.new(0, 0, 0, 0)
    openBtn.Parent = top

    local openBtnOutline = Instance.new("Frame")
    openBtnOutline.Name = rand()
    openBtnOutline.BackgroundTransparency = 1
    openBtnOutline.Size = UDim2.new(1, 0, 1, 0)
    openBtnOutline.Position = UDim2.new(0, 0, 0, 0)
    openBtnOutline.Parent = top

    local openBtnUICorner = Instance.new("UICorner")
    openBtnUICorner.CornerRadius = UDim.new(0, 14)
    openBtnUICorner.Parent = openBtnOutline

    local openBtnUIStroke = Instance.new("UIStroke")
    openBtnUIStroke.Color = Color3.fromRGB(180, 60, 255)
    openBtnUIStroke.Thickness = 3
    openBtnUIStroke.Parent = openBtnOutline

    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Name = rand()
    sidebar.Size = UDim2.new(0, 130, 1, -58)
    sidebar.Position = UDim2.new(0, 0, 0, 46)
    sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    sidebar.BorderSizePixel = 0
    sidebar.CanvasSize = UDim2.new(0, 0, 1, 0)
    sidebar.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    sidebar.ScrollBarThickness = 0
    sidebar.Parent = win

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 12)
    sidebarCorner.Parent = sidebar

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.FillDirection = Enum.FillDirection.Vertical
    sidebarLayout.Padding = UDim.new(0, 10)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = sidebar

    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Name = rand()
    contentScroll.Size = UDim2.new(1, -144, 1, -58)
    contentScroll.Position = UDim2.new(0, 140, 0, 46)
    contentScroll.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    contentScroll.BorderSizePixel = 0
    contentScroll.CanvasSize = UDim2.new(0, 0, 1, 0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    contentScroll.ScrollBarThickness = 8
    contentScroll.Parent = win

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 12)
    contentCorner.Parent = contentScroll

    local tabs = {}
    local selectedTab = nil

    local dragging, dragInput, dragStart, startPos
    openBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = win.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    openBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    openBtn.MouseButton1Click:Connect(function()
        win.Visible = not win.Visible
    end)

    return setmetatable({
        mainGui = mainGui,
        win = win,
        sidebar = sidebar,
        contentScroll = contentScroll,
        tabs = tabs,
        selectedTab = selectedTab,
        selectTab = function(self, tab)
            for _, v in pairs(self.tabs) do
                v.btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                v.page.Visible = false
            end
            tab.btn.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            tab.page.Visible = true
            selectedTab = tab
        end
    }, WinProto)
end

function WinProto:Tab(tabOpts)
    local btn = Instance.new("TextButton")
    btn.Name = rand()
    btn.Text = tabOpts.Title
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    btn.Size = UDim2.new(1, -14, 0, 44)
    btn.Parent = self.sidebar
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    if tabOpts.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Name = rand()
        icon.Image = typeof(tabOpts.Icon) == "string" and tabOpts.Icon or "rbxassetid://" .. tabOpts.Icon
        icon.Size = UDim2.new(0, 22, 0, 22)
        icon.Position = UDim2.new(0, 16, 0, 11)
        icon.BackgroundTransparency = 1
        icon.Parent = btn
        btn.Text = "   " .. tabOpts.Title
    end

    local page = Instance.new("Frame")
    page.Name = rand()
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = self.contentScroll

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.FillDirection = Enum.FillDirection.Vertical
    pageLayout.Parent = page

    local tabObj = setmetatable({
        btn = btn,
        page = page,
        parentWin = self
    }, TabProto)

    table.insert(self.tabs, tabObj)
    btn.MouseButton1Click:Connect(function() self:selectTab(tabObj) end)
    if #self.tabs == 1 then self:selectTab(tabObj) end
    return tabObj
end

function TabProto:Section(opts)
    local sec = Instance.new("Frame")
    sec.Name = rand()
    sec.Size = UDim2.new(1, 0, 0, 36)
    sec.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    sec.Parent = self.page
    local secCorner = Instance.new("UICorner")
    secCorner.CornerRadius = UDim.new(1, 0)
    secCorner.Parent = sec
    local lbl = Instance.new("TextLabel")
    lbl.Name = rand()
    lbl.Text = opts.Title
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 16
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -18, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = sec
    return sec
end

function TabProto:Divider()
    local line = Instance.new("Frame")
    line.Name = rand()
    line.Size = UDim2.new(1, 0, 0, 2)
    line.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    line.BorderSizePixel = 0
    line.Parent = self.page
    return line
end

function TabProto:Button(opts)
    local b = Instance.new("TextButton")
    b.Name = rand()
    b.Text = opts.Title
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 16
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    b.Size = UDim2.new(1, 0, 0, 44)
    b.Parent = self.page
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = b
    if opts.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Name = rand()
        icon.Image = typeof(opts.Icon) == "string" and opts.Icon or "rbxassetid://" .. opts.Icon
        icon.Size = UDim2.new(0, 22, 0, 22)
        icon.Position = UDim2.new(1, -35, 0.5, -11)
        icon.AnchorPoint = Vector2.new(1, 0.5)
        icon.BackgroundTransparency = 1
        icon.Parent = b
    end
    b.MouseButton1Click:Connect(function() pcall(opts.Callback) end)
    return b
end

function TabProto:Toggle(opts)
    local f = Instance.new("Frame")
    f.Name = rand()
    f.Size = UDim2.new(1, 0, 0, 44)
    f.BackgroundTransparency = 1
    f.Parent = self.page
    local bg = Instance.new("Frame")
    bg.Name = rand()
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    bg.Parent = f
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = bg
    local label = Instance.new("TextLabel")
    label.Name = rand()
    label.Text = opts.Title
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 18, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg
    local pill = Instance.new("Frame")
    pill.Name = rand()
    pill.Size = UDim2.new(0, 44, 0, 22)
    pill.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    pill.Position = UDim2.new(1, -60, 0.5, -11)
    pill.AnchorPoint = Vector2.new(0, 0.5)
    pill.Parent = bg
    local pillCorner = Instance.new("UICorner")
    pillCorner.CornerRadius = UDim.new(1, 0)
    pillCorner.Parent = pill
    local dot = Instance.new("Frame")
    dot.Name = rand()
    dot.Size = UDim2.new(0, 18, 0, 18)
    dot.Position = opts.Default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    dot.BackgroundColor3 = opts.Default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    dot.Parent = pill
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    local value = opts.Default
    pill.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            value = not value
            if value then
                dot.Position = UDim2.new(1, -20, 0.5, -9)
                dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                pill.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
            else
                dot.Position = UDim2.new(0, 2, 0.5, -9)
                dot.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
                pill.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            end
            pcall(opts.Callback, value)
        end
    end)
    return f
end

function TabProto:Slider(opts)
    local f = Instance.new("Frame")
    f.Name = rand()
    f.Size = UDim2.new(1, 0, 0, 44)
    f.BackgroundTransparency = 1
    f.Parent = self.page
    local bg = Instance.new("Frame")
    bg.Name = rand()
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    bg.Parent = f
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = bg
    local label = Instance.new("TextLabel")
    label.Name = rand()
    label.Text = opts.Title
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -130, 1, 0)
    label.Position = UDim2.new(0, 18, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg
    local valueLbl = Instance.new("TextLabel")
    valueLbl.Name = rand()
    valueLbl.Text = tostring(opts.Default)
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.TextSize = 15
    valueLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Size = UDim2.new(0, 54, 0, 22)
    valueLbl.Position = UDim2.new(1, -110, 0.5, -11)
    valueLbl.Parent = bg
    local sliderBack = Instance.new("Frame")
    sliderBack.Name = rand()
    sliderBack.Size = UDim2.new(0, 80, 0, 7)
    sliderBack.Position = UDim2.new(1, -70, 0.5, -3)
    sliderBack.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
    sliderBack.BorderSizePixel = 0
    sliderBack.Parent = bg
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBack
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = rand()
    sliderFill.Size = UDim2.new((opts.Default - opts.Min) / (opts.Max - opts.Min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBack
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    local thumb = Instance.new("Frame")
    thumb.Name = rand()
    thumb.Size = UDim2.new(0, 13, 0, 13)
    thumb.Position = UDim2.new((opts.Default - opts.Min) / (opts.Max - opts.Min), -7, 0.5, -6)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.Parent = sliderBack
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    local dragging = false
    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local function setValue(x)
                local rel = math.clamp((x - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
                local val = math.floor((opts.Min + rel * (opts.Max - opts.Min)) * 100) / 100
                sliderFill.Size = UDim2.new(rel, 0, 1, 0)
                thumb.Position = UDim2.new(rel, -7, 0.5, -6)
                valueLbl.Text = tostring(val)
                pcall(opts.Callback, val)
            end
            setValue(UserInputService:GetMouseLocation().X)
            local move, up
            move = UserInputService.InputChanged:Connect(function(input2)
                if input2.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                    setValue(input2.Position.X)
                end
            end)
            up = UserInputService.InputEnded:Connect(function(input2)
                if input2.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    move:Disconnect()
                    up:Disconnect()
                end
            end)
        end
    end)
    return f
end

function TabProto:Dropdown(opts)
    local f = Instance.new("Frame")
    f.Name = rand()
    f.Size = UDim2.new(1, 0, 0, 44)
    f.BackgroundTransparency = 1
    f.Parent = self.page
    local bg = Instance.new("Frame")
    bg.Name = rand()
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    bg.Parent = f
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = bg
    local label = Instance.new("TextLabel")
    label.Name = rand()
    label.Text = opts.Title
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -130, 1, 0)
    label.Position = UDim2.new(0, 18, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg
    local selLbl = Instance.new("TextLabel")
    selLbl.Name = rand()
    selLbl.Text = tostring(opts.Values[1])
    selLbl.Font = Enum.Font.GothamBold
    selLbl.TextSize = 15
    selLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    selLbl.BackgroundTransparency = 1
    selLbl.Size = UDim2.new(0, 80, 0, 22)
    selLbl.Position = UDim2.new(1, -90, 0.5, -11)
    selLbl.Parent = bg
    local dropBtn = Instance.new("TextButton")
    dropBtn.Name = rand()
    dropBtn.Text = "▼"
    dropBtn.Font = Enum.Font.GothamBold
    dropBtn.TextSize = 18
    dropBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    dropBtn.BackgroundColor3 = Color3.fromRGB(54, 54, 54)
    dropBtn.Size = UDim2.new(0, 28, 0, 22)
    dropBtn.Position = UDim2.new(1, -42, 0.5, -11)
    dropBtn.Parent = bg
    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(1, 0)
    dropCorner.Parent = dropBtn
    local ddOpen = false
    local ddFrame = nil
    dropBtn.MouseButton1Click:Connect(function()
        if ddOpen then if ddFrame then ddFrame:Destroy() end ddOpen = false return end
        ddOpen = true
        ddFrame = Instance.new("Frame")
        ddFrame.Name = rand()
        ddFrame.Size = UDim2.new(0, 130, 0, #opts.Values * 30)
        ddFrame.Position = UDim2.new(1, -130, 1, 0)
        ddFrame.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
        ddFrame.Parent = bg
        local ddCorner = Instance.new("UICorner")
        ddCorner.CornerRadius = UDim.new(0, 12)
        ddCorner.Parent = ddFrame
        local ddLayout = Instance.new("UIListLayout")
        ddLayout.FillDirection = Enum.FillDirection.Vertical
        ddLayout.Padding = UDim.new(0, 3)
        ddLayout.Parent = ddFrame
        for _, v in ipairs(opts.Values) do
            local optBtn = Instance.new("TextButton")
            optBtn.Name = rand()
            optBtn.Text = tostring(v)
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextSize = 15
            optBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
            optBtn.BackgroundColor3 = Color3.fromRGB(54, 54, 54)
            optBtn.Size = UDim2.new(1, 0, 0, 26)
            optBtn.Parent = ddFrame
            local ocorner = Instance.new("UICorner")
            ocorner.CornerRadius = UDim.new(0, 8)
            ocorner.Parent = optBtn
            optBtn.MouseButton1Click:Connect(function()
                selLbl.Text = tostring(v)
                pcall(opts.Callback, v)
                ddFrame:Destroy()
                ddOpen = false
            end)
        end
    end)
    return f
end

function TabProto:Paragraph(opts)
    local lbl = Instance.new("TextLabel")
    lbl.Name = rand()
    lbl.Text = opts.Title
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 15
    lbl.TextWrapped = true
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 30)
    lbl.Parent = self.page
    return lbl
end

return setmetatable({}, WindUI)
