-- [[ Filename: UIManager.lua ]]
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.ThemeObjects = {} -- Tempat nyimpen object yang warnanya bisa berubah

-- [[ 1. THEME PRESETS ]] --
Library.Themes = {
    Dark = {
        Main = Color3.fromRGB(25, 25, 25),
        Sidebar = Color3.fromRGB(30, 30, 30),
        Element = Color3.fromRGB(35, 35, 35),
        Text = Color3.fromRGB(240, 240, 240),
        Accent = Color3.fromRGB(0, 170, 255), -- Biru
        Stroke = Color3.fromRGB(60, 60, 60)
    },
    Red = {
        Main = Color3.fromRGB(20, 20, 20),
        Sidebar = Color3.fromRGB(25, 25, 25),
        Element = Color3.fromRGB(30, 30, 30),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 50, 50), -- Merah
        Stroke = Color3.fromRGB(80, 40, 40)
    },
    Purple = {
        Main = Color3.fromRGB(20, 20, 25),
        Sidebar = Color3.fromRGB(25, 25, 30),
        Element = Color3.fromRGB(35, 35, 40),
        Text = Color3.fromRGB(240, 230, 255),
        Accent = Color3.fromRGB(170, 0, 255), -- Ungu
        Stroke = Color3.fromRGB(70, 50, 90)
    }
}

-- Set Default Theme
Library.CurrentTheme = Library.Themes.Dark

-- [[ 2. HELPER FUNCTIONS ]] --
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

-- Fungsi Ajaib buat Ganti Tema Real-time
function Library:RegisterTheme(instance, property, themeKey)
    table.insert(Library.ThemeObjects, {Object = instance, Property = property, ThemeKey = themeKey})
    instance[property] = Library.CurrentTheme[themeKey] -- Set warna awal
end

function Library:SetTheme(themeName)
    if Library.Themes[themeName] then
        Library.CurrentTheme = Library.Themes[themeName]
        -- Update semua object yang terdaftar
        for _, data in pairs(Library.ThemeObjects) do
            if data.Object then
                TweenService:Create(data.Object, TweenInfo.new(0.3), {[data.Property] = Library.CurrentTheme[data.ThemeKey]}):Play()
            end
        end
    end
end

local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ 3. CORE UI ]] --
function Library:CreateWindow(name)
    if CoreGui:FindFirstChild("CustomUI") then CoreGui.CustomUI:Destroy() end

    local ScreenGui = Create("ScreenGui", {Name = "CustomUI", Parent = CoreGui})
    
    local MainFrame = Create("Frame", {
        Parent = ScreenGui, Size = UDim2.fromOffset(550, 350), 
        Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 8)})
    Library:RegisterTheme(MainFrame, "BackgroundColor3", "Main")
    
    local Stroke = Create("UIStroke", {Parent = MainFrame, Thickness = 1})
    Library:RegisterTheme(Stroke, "Color", "Stroke")

    -- Sidebar
    local Sidebar = Create("Frame", {
        Parent = MainFrame, Size = UDim2.new(0, 140, 1, 0),
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 8)})
    Library:RegisterTheme(Sidebar, "BackgroundColor3", "Sidebar")

    -- Title
    local Title = Create("TextLabel", {
        Parent = Sidebar, Text = name, Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 18
    })
    Library:RegisterTheme(Title, "TextColor3", "Accent")

    -- Container Tabs
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar, Size = UDim2.new(1, -10, 1, -50), Position = UDim2.new(0, 5, 0, 50),
        BackgroundTransparency = 1, ScrollBarThickness = 0
    })
    Create("UIListLayout", {Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})

    -- Container Pages
    local PageContainer = Create("Frame", {
        Parent = MainFrame, Size = UDim2.new(1, -150, 1, -20), Position = UDim2.new(0, 150, 0, 10),
        BackgroundTransparency = 1, ClipsDescendants = true
    })

    MakeDraggable(Sidebar, MainFrame)

    local WindowFunctions = {}
    local FirstTab = true

    function WindowFunctions:Tab(text)
        local TabBtn = Create("TextButton", {
            Parent = TabContainer, Text = text, Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, TextSize = 14
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 6)})
        Library:RegisterTheme(TabBtn, "TextColor3", "Text")

        local Page = Create("ScrollingFrame", {
            Parent = PageContainer, Size = UDim2.fromScale(1, 1), Visible = false,
            BackgroundTransparency = 1, ScrollBarThickness = 2
        })
        Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)})

        if FirstTab then 
            FirstTab = false; Page.Visible = true 
            TabBtn.BackgroundTransparency = 0
            Library:RegisterTheme(TabBtn, "BackgroundColor3", "Element")
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then 
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() 
                end
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            Library:RegisterTheme(TabBtn, "BackgroundColor3", "Element")
        end)

        local Elements = {}

        -- [[ BUTTON ]]
        function Elements:Button(text, callback)
            local Btn = Create("TextButton", {
                Parent = Page, Text = text, Size = UDim2.new(1, 0, 0, 35),
                Font = Enum.Font.Gotham, TextSize = 14, AutoButtonColor = false
            })
            Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 6)})
            Library:RegisterTheme(Btn, "BackgroundColor3", "Element")
            Library:RegisterTheme(Btn, "TextColor3", "Text")
            
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Library.CurrentTheme.Accent}):Play()
                wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Library.CurrentTheme.Element}):Play()
                if callback then callback() end
            end)
        end

        -- [[ TOGGLE ]]
        function Elements:Toggle(text, default, callback)
            local toggled = default
            local Frame = Create("TextButton", {
                Parent = Page, Text = "", Size = UDim2.new(1, 0, 0, 35),
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
            Library:RegisterTheme(Frame, "BackgroundColor3", "Element")

            local Label = Create("TextLabel", {
                Parent = Frame, Text = text, Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextSize = 14
            })
            Library:RegisterTheme(Label, "TextColor3", "Text")

            local Indicator = Create("Frame", {
                Parent = Frame, Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -30, 0.5, -10)
            })
            Create("UICorner", {Parent = Indicator, CornerRadius = UDim.new(0, 4)})
            
            local function Update()
                local color = toggled and Library.CurrentTheme.Accent or Color3.fromRGB(60,60,60)
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
            end
            Update()

            Frame.MouseButton1Click:Connect(function()
                toggled = not toggled
                Update()
                if callback then callback(toggled) end
            end)
        end

        -- [[ THEME SELECTOR (CUSTOM DROPDOWN) ]]
        function Elements:ThemeSelector()
            local Frame = Create("Frame", {
                Parent = Page, Size = UDim2.new(1, 0, 0, 80), BackgroundTransparency = 1
            })
            
            local Label = Create("TextLabel", {
                Parent = Frame, Text = "Select Theme:", Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, TextSize = 14
            })
            Library:RegisterTheme(Label, "TextColor3", "Accent")
            
            local Container = Create("Frame", {
                Parent = Frame, Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 25),
                BackgroundTransparency = 1
            })
            Create("UIListLayout", {Parent = Container, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5)})
            
            for themeName, _ in pairs(Library.Themes) do
                local Btn = Create("TextButton", {
                    Parent = Container, Text = themeName, Size = UDim2.new(0, 80, 1, 0),
                    Font = Enum.Font.Gotham, TextSize = 12
                })
                Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 6)})
                Library:RegisterTheme(Btn, "BackgroundColor3", "Element")
                Library:RegisterTheme(Btn, "TextColor3", "Text")
                
                Btn.MouseButton1Click:Connect(function()
                    Library:SetTheme(themeName)
                end)
            end
        end

        return Elements
    end

    return WindowFunctions
end

return Library