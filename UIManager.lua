-- [[ Filename: UIManager.lua ]]
-- VERSION: V5.5 (FINAL POLISH: RichText Header with Version Code)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.RegisteredElements = {}
Library.ThemeCallbacks = {}
Library.ToggleKey = Enum.KeyCode.RightControl

-- [[ 1. THEME PRESETS ]]
Library.Themes = {
    Midnight = {
        Main        = Color3.fromRGB(20, 20, 20),
        Header      = Color3.fromRGB(25, 25, 25),
        Sidebar     = Color3.fromRGB(25, 25, 25),
        Content     = Color3.fromRGB(32, 32, 32),
        Text        = Color3.fromRGB(255, 255, 255),
        SubText     = Color3.fromRGB(150, 150, 150), -- Sedikit lebih gelap untuk efek opacity
        Accent      = Color3.fromRGB(115, 100, 255),
        Outline     = Color3.fromRGB(50, 50, 50),
        Hover       = Color3.fromRGB(45, 45, 45),
        Dropdown    = Color3.fromRGB(35, 35, 35),
        ControlIcon = Color3.fromRGB(200, 200, 200),
        ControlHover= Color3.fromRGB(60, 60, 60)
    },
    Ocean = {
        Main        = Color3.fromRGB(15, 25, 35),
        Header      = Color3.fromRGB(20, 30, 40),
        Sidebar     = Color3.fromRGB(20, 30, 40),
        Content     = Color3.fromRGB(28, 38, 48),
        Text        = Color3.fromRGB(230, 255, 255),
        SubText     = Color3.fromRGB(130, 160, 160),
        Accent      = Color3.fromRGB(0, 190, 255),
        Outline     = Color3.fromRGB(40, 60, 80),
        Hover       = Color3.fromRGB(35, 50, 60),
        Dropdown    = Color3.fromRGB(30, 40, 50),
        ControlIcon = Color3.fromRGB(180, 220, 255),
        ControlHover= Color3.fromRGB(50, 70, 90)
    },
    Blood = {
        Main        = Color3.fromRGB(25, 18, 18),
        Header      = Color3.fromRGB(30, 20, 20),
        Sidebar     = Color3.fromRGB(30, 20, 20),
        Content     = Color3.fromRGB(38, 24, 24),
        Text        = Color3.fromRGB(255, 230, 230),
        SubText     = Color3.fromRGB(170, 130, 130),
        Accent      = Color3.fromRGB(220, 60, 60),
        Outline     = Color3.fromRGB(80, 40, 40),
        Hover       = Color3.fromRGB(50, 25, 25),
        Dropdown    = Color3.fromRGB(40, 25, 25),
        ControlIcon = Color3.fromRGB(255, 200, 200),
        ControlHover= Color3.fromRGB(100, 50, 50)
    }
}
Library.CurrentTheme = Library.Themes.Midnight

-- [[ 2. HELPERS ]]
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function ApplyTheme(obj, prop, key)
    table.insert(Library.RegisteredElements, {Obj = obj, Prop = prop, Key = key})
    obj[prop] = Library.CurrentTheme[key]
end

-- Helper baru untuk RichText
local function toHex(color)
    return string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255)
end

function Library:SetTheme(name)
    if not Library.Themes[name] then return end
    Library.CurrentTheme = Library.Themes[name]
    for _, v in ipairs(Library.RegisteredElements) do
        if v.Obj then TweenService:Create(v.Obj, TweenInfo.new(0.3), {[v.Prop] = Library.CurrentTheme[v.Key]}):Play() end
    end
    for _, cb in ipairs(Library.ThemeCallbacks) do task.spawn(cb) end
end

-- [[ 3. MAIN UI CREATION ]]
function Library:CreateWindow(title_ignored) -- Parameter title tidak lagi dipakai langsung
    if CoreGui:FindFirstChild("WerskieeeHubV5_5") then CoreGui.WerskieeeHubV5_5:Destroy() end
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("WerskieeeHubV5_5") then 
        game.Players.LocalPlayer.PlayerGui.WerskieeeHubV5_5:Destroy() 
    end

    local TargetParent = nil
    local s, r = pcall(function() return gethui() end)
    if s and r then TargetParent = r else TargetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    local Gui = Create("ScreenGui", {Name = "WerskieeeHubV5_5", Parent = TargetParent, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false})
    
    local Main = Create("Frame", {
        Parent = Gui, Size = UDim2.fromOffset(600, 400), Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = Main, Thickness = 1})
    ApplyTheme(Main, "BackgroundColor3", "Main")
    ApplyTheme(Main.UIStroke, "Color", "Outline")

    -- HEADER
    local Header = Create("Frame", {
        Parent = Main, Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundTransparency = 1
    })
    
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = i.Position; startPos = Main.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            TweenService:Create(Main, TweenInfo.new(0.05), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)

    -- [[ MODIFIED TITLE WITH RICHTEXT ]]
    local TitleLbl = Create("TextLabel", {
        Parent = Header, 
        Text = "", -- Text akan diisi oleh fungsi update di bawah
        RichText = true, -- Aktifkan RichText
        Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 20, 0, 0),
        Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
    })
    
    -- Fungsi untuk update teks judul berdasarkan tema saat ini
    local function UpdateTitle()
        local accentHex = toHex(Library.CurrentTheme.Accent)
        local subTextHex = toHex(Library.CurrentTheme.SubText)
        -- Format: Main Title (Accent Color) | Version Info (SubText Color/Darker)
        TitleLbl.Text = string.format('<font color="%s">Werskieee</font> <font color="%s">| 1.0</font>', accentHex, subTextHex)
    end
    
    -- Daftarkan ke callback agar berubah saat ganti tema, dan jalankan sekali di awal
    table.insert(Library.ThemeCallbacks, UpdateTitle)
    UpdateTitle()

    -- CONTROLS
    local ControlHolder = Create("Frame", {
        Parent = Header, Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(1, -100, 0, 0), BackgroundTransparency = 1
    })
    Create("UIListLayout", {Parent = ControlHolder, FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
    Create("UIPadding", {Parent = ControlHolder, PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6)})

    -- SIDEBAR & CONTENT VARIABLES
    local Sidebar = Create("Frame", {
        Parent = Main, Size = UDim2.new(0, 160, 1, -40), Position = UDim2.new(0, 0, 0, 40), BorderSizePixel = 0, BackgroundTransparency = 1
    })
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1, ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)
    })
    Create("UIListLayout", {Parent = TabContainer, Padding = UDim.new(0, 5)})
    Create("UIPadding", {Parent = TabContainer, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 5)})

    local Content = Create("Frame", {
        Parent = Main, Size = UDim2.new(1, -170, 1, -50), Position = UDim2.new(0, 165, 0, 45), 
        BackgroundTransparency = 0, BorderSizePixel = 0, ClipsDescendants = true
    })
    Create("UICorner", {Parent = Content, CornerRadius = UDim.new(0, 10)})
    local ContentStroke = Create("UIStroke", {Parent = Content, Thickness = 1, Transparency = 0.5})
    ApplyTheme(Content, "BackgroundColor3", "Content")
    ApplyTheme(ContentStroke, "Color", "Outline")

    -- BUTTON CREATOR
    local function CreateBtn(order, iconID, isClose, callback)
        local Btn = Create("TextButton", {
            Parent = ControlHolder, Text = "", Size = UDim2.new(0, 28, 0, 28), AutoButtonColor = false, 
            BackgroundTransparency = 1, LayoutOrder = order
        })
        Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 6)})
        
        local iconSize = isClose and 20 or 14 
        local Icon = Create("ImageLabel", {
            Parent = Btn, Image = iconID, Size = UDim2.new(0, iconSize, 0, iconSize),
            Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1
        })

        if isClose then
            Icon.ImageColor3 = Color3.fromRGB(200, 200, 200)
            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(232, 17, 35)}):Play()
                Icon.ImageColor3 = Color3.new(1,1,1)
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                Icon.ImageColor3 = Color3.fromRGB(200, 200, 200)
            end)
        else
            ApplyTheme(Icon, "ImageColor3", "ControlIcon")
            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Library.CurrentTheme.ControlHover}):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            end)
        end
        Btn.MouseButton1Click:Connect(callback)
    end

    local IconMin   = "rbxassetid://10734896206"
    local IconMax   = "rbxassetid://10734965702"
    local IconClose = "rbxassetid://6031094678"

    -- 1. Minimize
    CreateBtn(1, IconMin, false, function() Main.Visible = false end)

    -- 2. Maximize
    local SidebarOpen = true
    CreateBtn(2, IconMax, false, function()
        SidebarOpen = not SidebarOpen
        if SidebarOpen then
            TweenService:Create(Sidebar, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 160, 1, -40)}):Play()
            TweenService:Create(Content, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -170, 1, -50), Position = UDim2.new(0, 165, 0, 45)}):Play()
        else
            TweenService:Create(Sidebar, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 0, 1, -40)}):Play()
            TweenService:Create(Content, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -20, 1, -50), Position = UDim2.new(0, 10, 0, 45)}):Play()
        end
    end)

    -- 3. Close
    CreateBtn(3, IconClose, true, function() Gui:Destroy() end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Library.ToggleKey then Main.Visible = not Main.Visible end
    end)

    -- TABS
    local Window = {}
    local FirstTab = true

    function Window:Tab(name)
        local TabBtn = Create("TextButton", {
            Parent = TabContainer, Text = name, Size = UDim2.new(1, 0, 0, 38),
            Font = Enum.Font.GothamMedium, TextSize = 14, AutoButtonColor = false, BackgroundTransparency = 1
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 8)})
        ApplyTheme(TabBtn, "TextColor3", "SubText")

        local Indicator = Create("Frame", {
            Parent = TabBtn, Size = UDim2.new(0, 3, 0.6, 0), Position = UDim2.new(0, 0, 0.2, 0), BackgroundTransparency = 1
        })
        Create("UICorner", {Parent = Indicator, CornerRadius = UDim.new(1, 0)})
        ApplyTheme(Indicator, "BackgroundColor3", "Accent")

        local Page = Create("ScrollingFrame", {
            Parent = Content, Size = UDim2.fromScale(1, 1), Visible = false, BackgroundTransparency = 1,
            ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0), ScrollBarImageColor3 = Color3.fromRGB(60,60,60)
        })
        local Layout = Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
        Create("UIPadding", {Parent = Page, PaddingTop = UDim.new(0, 15), PaddingRight = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingBottom = UDim.new(0, 15)})

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 30)
        end)

        local function Activate()
            for _,v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible=false end end
            for _,v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then 
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play()
                    ApplyTheme(v, "TextColor3", "SubText")
                    if v:FindFirstChild("Frame") then TweenService:Create(v.Frame, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play() end
                end
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency=0}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundTransparency=0}):Play()
            ApplyTheme(TabBtn, "BackgroundColor3", "Sidebar")
            ApplyTheme(TabBtn, "TextColor3", "Accent")
        end
        TabBtn.MouseButton1Click:Connect(Activate)
        if FirstTab then FirstTab=false; Activate() end

        local Elements = {}

        function Elements:Section(text)
            local F = Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1})
            local L = Create("TextLabel", {
                Parent = F, Text = text, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.GothamBold,
                TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(L, "TextColor3", "Text")
            Create("Frame", {Parent = F, Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = Library.CurrentTheme.Outline})
        end

        function Elements:Button(text, callback)
            local B = Create("TextButton", {
                Parent = Page, Text = "", Size = UDim2.new(1, 0, 0, 42), AutoButtonColor = false, BackgroundTransparency = 0
            })
            Create("UICorner", {Parent = B, CornerRadius = UDim.new(0, 8)})
            Create("UIStroke", {Parent = B, Thickness = 1})
            ApplyTheme(B, "BackgroundColor3", "Main")
            ApplyTheme(B.UIStroke, "Color", "Outline")
            local L = Create("TextLabel", {
                Parent = B, Text = text, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium, TextSize = 14
            })
            ApplyTheme(L, "TextColor3", "Text")
            B.MouseButton1Click:Connect(function()
                TweenService:Create(B, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 38)}):Play()
                wait(0.1)
                TweenService:Create(B, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 42)}):Play()
                if callback then callback() end
            end)
            B.MouseEnter:Connect(function() ApplyTheme(B, "BackgroundColor3", "Hover") end)
            B.MouseLeave:Connect(function() ApplyTheme(B, "BackgroundColor3", "Main") end)
        end

        function Elements:Toggle(text, default, callback)
            local tog = default or false
            local B = Create("TextButton", {
                Parent = Page, Text = "", Size = UDim2.new(1, 0, 0, 42), AutoButtonColor = false
            })
            Create("UICorner", {Parent = B, CornerRadius = UDim.new(0, 8)})
            Create("UIStroke", {Parent = B, Thickness = 1})
            ApplyTheme(B, "BackgroundColor3", "Main")
            ApplyTheme(B.UIStroke, "Color", "Outline")
            local L = Create("TextLabel", {
                Parent = B, Text = text, Size = UDim2.new(1, -55, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(L, "TextColor3", "Text")
            local Switch = Create("Frame", {Parent = B, Size = UDim2.new(0, 38, 0, 20), Position = UDim2.new(1, -48, 0.5, -10)})
            Create("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 10)})
            local Knob = Create("Frame", {Parent = Switch, Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.new(1,1,1)})
            Create("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 10)})
            local function Update()
                if tog then
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Library.CurrentTheme.Accent}):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                else
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                end
            end
            table.insert(Library.ThemeCallbacks, Update)
            Update()
            B.MouseButton1Click:Connect(function() tog = not tog; Update(); if callback then callback(tog) end end)
        end

        function Elements:Slider(text, min, max, default, callback)
            local val = default or min
            local F = Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1})
            local C = Create("Frame", {Parent = F, Size = UDim2.new(1, 0, 1, 0)})
            Create("UICorner", {Parent = C, CornerRadius = UDim.new(0, 8)})
            Create("UIStroke", {Parent = C, Thickness = 1})
            ApplyTheme(C, "BackgroundColor3", "Main")
            ApplyTheme(C.UIStroke, "Color", "Outline")
            local L = Create("TextLabel", {
                Parent = C, Text = text, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 10, 0, 5),
                Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(L, "TextColor3", "Text")
            local V = Create("TextLabel", {
                Parent = C, Text = tostring(val), Size = UDim2.new(0, 50, 0, 20), Position = UDim2.new(1, -60, 0, 5),
                Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1
            })
            ApplyTheme(V, "TextColor3", "Accent")
            local Rail = Create("TextButton", {
                Parent = C, Text = "", Size = UDim2.new(1, -20, 0, 6), Position = UDim2.new(0, 10, 0, 32),
                AutoButtonColor = false, BackgroundColor3 = Color3.fromRGB(50,50,50)
            })
            Create("UICorner", {Parent = Rail, CornerRadius = UDim.new(1, 10)})
            local Fill = Create("Frame", {Parent = Rail, Size = UDim2.new((val-min)/(max-min), 0, 1, 0), BorderSizePixel = 0})
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 10)})
            ApplyTheme(Fill, "BackgroundColor3", "Accent")
            table.insert(Library.ThemeCallbacks, function() Fill.BackgroundColor3 = Library.CurrentTheme.Accent; V.TextColor3 = Library.CurrentTheme.Accent end)
            local dragging = false
            local function Update(input)
                local sizeX = math.clamp((input.Position.X - Rail.AbsolutePosition.X) / Rail.AbsoluteSize.X, 0, 1)
                local newVal = math.floor(min + ((max - min) * sizeX))
                TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(sizeX, 0, 1, 0)}):Play()
                V.Text = tostring(newVal)
                if callback then callback(newVal) end
            end
            Rail.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true Update(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
        end

        function Elements:Dropdown(text, options, callback)
            local dropped = false
            local Container = Create("Frame", {
                Parent = Page, Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 10
            })
            local MainBtn = Create("TextButton", {
                Parent = Container, Text = "", Size = UDim2.new(1, 0, 0, 42), AutoButtonColor = false, ZIndex = 11
            })
            Create("UICorner", {Parent = MainBtn, CornerRadius = UDim.new(0, 8)})
            Create("UIStroke", {Parent = MainBtn, Thickness = 1})
            ApplyTheme(MainBtn, "BackgroundColor3", "Main")
            ApplyTheme(MainBtn.UIStroke, "Color", "Outline")
            local Label = Create("TextLabel", {
                Parent = MainBtn, Text = text .. "...", Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(Label, "TextColor3", "Text")
            local Arrow = Create("ImageLabel", {
                Parent = MainBtn, Image = "rbxassetid://6034818372", Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0.5, -10), BackgroundTransparency = 1
            })
            ApplyTheme(Arrow, "ImageColor3", "SubText")
            local List = Create("ScrollingFrame", {
                Parent = Container, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 45),
                BackgroundTransparency = 1, ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0), ZIndex = 12
            })
            Create("UICorner", {Parent = List, CornerRadius = UDim.new(0, 8)})
            local ListLayout = Create("UIListLayout", {Parent = List, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)})
            for _, opt in ipairs(options) do
                local OptBtn = Create("TextButton", {
                    Parent = List, Text = opt, Size = UDim2.new(1, 0, 0, 30), Font = Enum.Font.GothamMedium,
                    TextSize = 13, AutoButtonColor = false, ZIndex = 13
                })
                Create("UICorner", {Parent = OptBtn, CornerRadius = UDim.new(0, 6)})
                ApplyTheme(OptBtn, "BackgroundColor3", "Dropdown")
                ApplyTheme(OptBtn, "TextColor3", "SubText")
                OptBtn.MouseButton1Click:Connect(function()
                    Label.Text = text .. ": " .. opt
                    dropped = false
                    TweenService:Create(Container, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 42)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    if callback then callback(opt) end
                end)
            end
            ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() List.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y) end)
            MainBtn.MouseButton1Click:Connect(function()
                dropped = not dropped
                local targetHeight = dropped and (45 + math.min(ListLayout.AbsoluteContentSize.Y, 150)) or 42
                List.Size = UDim2.new(1, 0, 0, math.min(ListLayout.AbsoluteContentSize.Y, 150))
                TweenService:Create(Container, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = dropped and 180 or 0}):Play()
            end)
        end

        return Elements
    end
    return Window
end

return Library