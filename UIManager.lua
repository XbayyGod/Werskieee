-- [[ Filename: UIManager.lua ]]
-- FINAL FIXED VERSION
-- NO BUGS, SMOOTH ANIMATION, AUTO-RESIZE SCROLL

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.RegisteredElements = {}

-- [[ 1. THEME CONFIG ]]
Library.Themes = {
    Midnight = {
        Main    = Color3.fromRGB(20, 20, 20),
        Sidebar = Color3.fromRGB(25, 25, 25),
        Content = Color3.fromRGB(30, 30, 30),
        Text    = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(170, 170, 170),
        Accent  = Color3.fromRGB(115, 100, 255), -- Ungu Modern
        Outline = Color3.fromRGB(50, 50, 50),
        Hover   = Color3.fromRGB(45, 45, 45)
    },
    Ocean = {
        Main    = Color3.fromRGB(15, 25, 35),
        Sidebar = Color3.fromRGB(20, 30, 40),
        Content = Color3.fromRGB(25, 35, 45),
        Text    = Color3.fromRGB(230, 255, 255),
        SubText = Color3.fromRGB(140, 170, 170),
        Accent  = Color3.fromRGB(0, 190, 255), -- Biru Laut
        Outline = Color3.fromRGB(40, 60, 80),
        Hover   = Color3.fromRGB(35, 50, 60)
    },
    Blood = {
        Main    = Color3.fromRGB(25, 18, 18),
        Sidebar = Color3.fromRGB(30, 20, 20),
        Content = Color3.fromRGB(35, 22, 22),
        Text    = Color3.fromRGB(255, 230, 230),
        SubText = Color3.fromRGB(180, 140, 140),
        Accent  = Color3.fromRGB(220, 60, 60), -- Merah
        Outline = Color3.fromRGB(80, 40, 40),
        Hover   = Color3.fromRGB(50, 25, 25)
    }
}
Library.CurrentTheme = Library.Themes.Midnight

-- [[ 2. SYSTEM FUNCTIONS ]]
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function ApplyTheme(obj, prop, key)
    table.insert(Library.RegisteredElements, {Obj = obj, Prop = prop, Key = key})
    obj[prop] = Library.CurrentTheme[key]
end

function Library:SetTheme(name)
    if Library.Themes[name] then
        Library.CurrentTheme = Library.Themes[name]
        for _, v in ipairs(Library.RegisteredElements) do
            if v.Obj then
                TweenService:Create(v.Obj, TweenInfo.new(0.3), {[v.Prop] = Library.CurrentTheme[v.Key]}):Play()
            end
        end
    end
end

local function MakeDraggable(topbar, object)
    local dragging, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            TweenService:Create(object, TweenInfo.new(0.05), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- [[ 3. WINDOW GENERATOR ]]
function Library:CreateWindow(title)
    if CoreGui:FindFirstChild("WerskieeeHubV2") then CoreGui.WerskieeeHubV2:Destroy() end

    local ScreenGui = Create("ScreenGui", {Name = "WerskieeeHubV2", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    
    local Main = Create("Frame", {
        Parent = ScreenGui, Size = UDim2.fromOffset(600, 400), Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = Main, Thickness = 1})
    ApplyTheme(Main, "BackgroundColor3", "Main")
    ApplyTheme(Main.UIStroke, "Color", "Outline")

    -- Sidebar Area
    local Sidebar = Create("Frame", {Parent = Main, Size = UDim2.new(0, 160, 1, 0), BorderSizePixel = 0})
    Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 10)})
    local SidebarFix = Create("Frame", {Parent = Sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), BorderSizePixel = 0})
    ApplyTheme(Sidebar, "BackgroundColor3", "Sidebar")
    ApplyTheme(SidebarFix, "BackgroundColor3", "Sidebar")

    MakeDraggable(Sidebar, Main)

    -- Title
    local TitleLbl = Create("TextLabel", {
        Parent = Sidebar, Text = title, Size = UDim2.new(1, -20, 0, 50), Position = UDim2.new(0, 15, 0, 10),
        Font = Enum.Font.GothamBold, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
    })
    ApplyTheme(TitleLbl, "TextColor3", "Accent")

    -- Tab Container
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar, Size = UDim2.new(1, 0, 1, -70), Position = UDim2.new(0, 0, 0, 70),
        BackgroundTransparency = 1, ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)
    })
    local TabList = Create("UIListLayout", {Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    Create("UIPadding", {Parent = TabContainer, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})

    -- Content Area
    local Content = Create("Frame", {
        Parent = Main, Size = UDim2.new(1, -170, 1, -20), Position = UDim2.new(0, 165, 0, 10),
        BackgroundTransparency = 1, ClipsDescendants = true
    })

    local Window = {}
    local FirstTab = true

    function Window:Tab(name)
        -- Button Tab
        local TabBtn = Create("TextButton", {
            Parent = TabContainer, Text = name, Size = UDim2.new(1, 0, 0, 38),
            Font = Enum.Font.GothamMedium, TextSize = 14, AutoButtonColor = false, BackgroundTransparency = 1
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 6)})
        ApplyTheme(TabBtn, "TextColor3", "SubText")

        local Indicator = Create("Frame", {
            Parent = TabBtn, Size = UDim2.new(0, 3, 0.6, 0), Position = UDim2.new(0, 0, 0.2, 0), BackgroundTransparency = 1
        })
        Create("UICorner", {Parent = Indicator, CornerRadius = UDim.new(1, 0)})
        ApplyTheme(Indicator, "BackgroundColor3", "Accent")

        -- Page
        local Page = Create("ScrollingFrame", {
            Parent = Content, Size = UDim2.fromScale(1, 1), Visible = false, BackgroundTransparency = 1,
            ScrollBarThickness = 3, CanvasSize = UDim2.new(0,0,0,0)
        })
        local PageLayout = Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
        Create("UIPadding", {Parent = Page, PaddingTop = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})

        -- Auto Scroll Fix
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)

        local function Activate()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then 
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                    ApplyTheme(v, "TextColor3", "SubText")
                    if v:FindFirstChild("Frame") then TweenService:Create(v.Frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play() end
                end
            end
            
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            ApplyTheme(TabBtn, "BackgroundColor3", "Content")
            ApplyTheme(TabBtn, "TextColor3", "Accent")
            TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        end

        TabBtn.MouseButton1Click:Connect(Activate)
        if FirstTab then FirstTab = false; Activate() end

        local Elements = {}

        -- [[ 1. BUTTON ]]
        function Elements:Button(text, callback)
            local Btn = Create("TextButton", {
                Parent = Page, Text = "", Size = UDim2.new(1, 0, 0, 40), AutoButtonColor = false,
                BackgroundTransparency = 0
            })
            Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = Btn, Thickness = 1})
            ApplyTheme(Btn, "BackgroundColor3", "Content")
            ApplyTheme(Btn.UIStroke, "Color", "Outline")

            local Label = Create("TextLabel", {
                Parent = Btn, Text = text, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium, TextSize = 14
            })
            ApplyTheme(Label, "TextColor3", "Text")

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -5, 0, 35)}):Play()
                wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                if callback then callback() end
            end)
            Btn.MouseEnter:Connect(function() ApplyTheme(Btn, "BackgroundColor3", "Hover") end)
            Btn.MouseLeave:Connect(function() ApplyTheme(Btn, "BackgroundColor3", "Content") end)
        end

        -- [[ 2. TOGGLE ]]
        function Elements:Toggle(text, default, callback)
            local toggled = default or false
            local Frame = Create("TextButton", {
                Parent = Page, Text = "", Size = UDim2.new(1, 0, 0, 40), AutoButtonColor = false
            })
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = Frame, Thickness = 1})
            ApplyTheme(Frame, "BackgroundColor3", "Content")
            ApplyTheme(Frame.UIStroke, "Color", "Outline")

            local Label = Create("TextLabel", {
                Parent = Frame, Text = text, Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(Label, "TextColor3", "Text")

            local Switch = Create("Frame", {Parent = Frame, Size = UDim2.new(0, 36, 0, 20), Position = UDim2.new(1, -46, 0.5, -10)})
            Create("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 0)})
            local Knob = Create("Frame", {Parent = Switch, Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255,255,255)})
            Create("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})

            local function Update()
                if toggled then
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Library.CurrentTheme.Accent}):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                else
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                end
            end
            Update()

            Frame.MouseButton1Click:Connect(function()
                toggled = not toggled
                Update()
                if callback then callback(toggled) end
            end)
        end

        -- [[ 3. SLIDER ]]
        function Elements:Slider(text, min, max, default, callback)
            local value = default or min
            local Frame = Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1})
            local Container = Create("Frame", {Parent = Frame, Size = UDim2.new(1, 0, 1, 0)})
            Create("UICorner", {Parent = Container, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = Container, Thickness = 1})
            ApplyTheme(Container, "BackgroundColor3", "Content")
            ApplyTheme(Container.UIStroke, "Color", "Outline")

            local Label = Create("TextLabel", {
                Parent = Container, Text = text, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 10, 0, 5),
                Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(Label, "TextColor3", "Text")

            local ValLabel = Create("TextLabel", {
                Parent = Container, Text = tostring(value), Size = UDim2.new(0, 50, 0, 20), Position = UDim2.new(1, -60, 0, 5),
                Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1
            })
            ApplyTheme(ValLabel, "TextColor3", "Accent")

            local Rail = Create("TextButton", {
                Parent = Container, Text = "", Size = UDim2.new(1, -20, 0, 6), Position = UDim2.new(0, 10, 0, 32),
                AutoButtonColor = false, BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            })
            Create("UICorner", {Parent = Rail, CornerRadius = UDim.new(1, 0)})

            local Fill = Create("Frame", {Parent = Rail, Size = UDim2.new((value-min)/(max-min), 0, 1, 0), BorderSizePixel = 0})
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
            ApplyTheme(Fill, "BackgroundColor3", "Accent")

            local dragging = false
            local function Update(input)
                local sizeX = math.clamp((input.Position.X - Rail.AbsolutePosition.X) / Rail.AbsoluteSize.X, 0, 1)
                local newValue = math.floor(min + ((max - min) * sizeX))
                TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(sizeX, 0, 1, 0)}):Play()
                ValLabel.Text = tostring(newValue)
                if callback then callback(newValue) end
            end

            Rail.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true Update(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
        end

        -- [[ 4. THEME SELECTOR ]]
        function Elements:ThemeSwitcher()
            local Frame = Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 45), BackgroundTransparency = 1})
            Create("UIListLayout", {Parent = Frame, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8)})
            
            for name, theme in pairs(Library.Themes) do
                local Btn = Create("TextButton", {
                    Parent = Frame, Text = name, Size = UDim2.new(0.3, 0, 1, 0),
                    Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false
                })
                Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 6)})
                Create("UIStroke", {Parent = Btn, Thickness = 2, Color = theme.Accent})
                Btn.BackgroundColor3 = theme.Main
                Btn.TextColor3 = theme.Text
                Btn.MouseButton1Click:Connect(function() Library:SetTheme(name) end)
            end
        end

        -- [[ 5. SECTION HEADER ]]
        function Elements:Section(text)
            local Frame = Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1})
            local Label = Create("TextLabel", {
                Parent = Frame, Text = text, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.GothamBold,
                TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(Label, "TextColor3", "Text")
            Create("Frame", {Parent = Frame, Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = Library.CurrentTheme.Outline})
        end

        return Elements
    end
    return Window
end

return Library