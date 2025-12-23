-- [[ Filename: UIManager.lua ]]
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.RegisteredElements = {} -- Database elemen untuk ganti warna live

-- [[ 1. THEME PRESETS ]]
Library.Themes = {
    ["Midnight"] = {
        Main        = Color3.fromRGB(20, 20, 20),
        Sidebar     = Color3.fromRGB(25, 25, 25),
        Content     = Color3.fromRGB(30, 30, 30), -- Warna container
        Text        = Color3.fromRGB(240, 240, 240),
        SubText     = Color3.fromRGB(150, 150, 150),
        Accent      = Color3.fromRGB(90, 100, 240), -- Ungu/Biru Elegan
        Outline     = Color3.fromRGB(45, 45, 45),
        Hover       = Color3.fromRGB(40, 40, 40)
    },
    ["Ocean"] = {
        Main        = Color3.fromRGB(15, 25, 30),
        Sidebar     = Color3.fromRGB(20, 30, 35),
        Content     = Color3.fromRGB(25, 35, 40),
        Text        = Color3.fromRGB(230, 255, 255),
        SubText     = Color3.fromRGB(140, 170, 170),
        Accent      = Color3.fromRGB(0, 190, 255), -- Biru Laut
        Outline     = Color3.fromRGB(40, 60, 70),
        Hover       = Color3.fromRGB(30, 50, 60)
    },
    ["Blood"] = {
        Main        = Color3.fromRGB(20, 15, 15),
        Sidebar     = Color3.fromRGB(25, 18, 18),
        Content     = Color3.fromRGB(30, 20, 20),
        Text        = Color3.fromRGB(255, 230, 230),
        SubText     = Color3.fromRGB(170, 140, 140),
        Accent      = Color3.fromRGB(220, 50, 50), -- Merah Darah
        Outline     = Color3.fromRGB(60, 30, 30),
        Hover       = Color3.fromRGB(45, 25, 25)
    }
}
Library.CurrentTheme = Library.Themes["Midnight"] -- Default

-- [[ 2. HELPER FUNCTIONS ]]
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local function ApplyTheme(instance, property, themeKey)
    -- Daftarkan elemen ke database agar bisa diupdate nanti
    table.insert(Library.RegisteredElements, {Obj = instance, Prop = property, Key = themeKey})
    instance[property] = Library.CurrentTheme[themeKey]
end

function Library:SetTheme(themeName)
    if Library.Themes[themeName] then
        Library.CurrentTheme = Library.Themes[themeName]
        for _, data in ipairs(Library.RegisteredElements) do
            if data.Obj then
                -- Animasi transisi warna halus
                TweenService:Create(data.Obj, TweenInfo.new(0.4), {[data.Prop] = Library.CurrentTheme[data.Key]}):Play()
            end
        end
    end
end

-- Dragging Logic (Smooth)
local function MakeDraggable(trigger, frame)
    local dragging, dragInput, dragStart, startPos
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    trigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            -- Gunakan Tween agar drag terasa "berat" dan premium, bukan kaku
            TweenService:Create(frame, TweenInfo.new(0.05), {Position = targetPos}):Play()
        end
    end)
end

-- [[ 3. MAIN UI CREATION ]]
function Library:CreateWindow(hubName)
    if CoreGui:FindFirstChild("WerskieeeHubV2") then CoreGui.WerskieeeHubV2:Destroy() end

    local ScreenGui = Create("ScreenGui", {Name = "WerskieeeHubV2", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    
    -- Main Container (Rounded & Shadow)
    local Main = Create("Frame", {
        Name = "Main", Parent = ScreenGui, Size = UDim2.fromOffset(600, 400),
        Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0, ClipsDescendants = false
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = Main, Thickness = 1})
    ApplyTheme(Main, "BackgroundColor3", "Main")
    ApplyTheme(Main.UIStroke, "Color", "Outline")

    -- Sidebar (Kiri)
    local Sidebar = Create("Frame", {
        Parent = Main, Size = UDim2.new(0, 160, 1, 0), BackgroundColor3 = Library.CurrentTheme.Sidebar,
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 10)})
    -- Fix corner kiri doang yg bulat (dengan menimpa bagian kanan)
    local FixSide = Create("Frame", {Parent = Sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), BackgroundColor3 = Library.CurrentTheme.Sidebar, BorderSizePixel = 0})
    ApplyTheme(Sidebar, "BackgroundColor3", "Sidebar")
    ApplyTheme(FixSide, "BackgroundColor3", "Sidebar")

    -- Title
    local TitleLabel = Create("TextLabel", {
        Parent = Sidebar, Text = hubName, Size = UDim2.new(1, -20, 0, 50), Position = UDim2.new(0, 15, 0, 10),
        Font = Enum.Font.GothamBold, TextSize = 20, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
    })
    ApplyTheme(TitleLabel, "TextColor3", "Accent")

    -- Tab Container
    local TabHolder = Create("ScrollingFrame", {
        Parent = Sidebar, Size = UDim2.new(1, 0, 1, -70), Position = UDim2.new(0, 0, 0, 70),
        BackgroundTransparency = 1, ScrollBarThickness = 0
    })
    Create("UIListLayout", {Parent = TabHolder, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    Create("UIPadding", {Parent = TabHolder, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})

    -- Content Area (Kanan)
    local ContentArea = Create("Frame", {
        Parent = Main, Size = UDim2.new(1, -170, 1, -20), Position = UDim2.new(0, 165, 0, 10),
        BackgroundTransparency = 1, ClipsDescendants = true
    })

    MakeDraggable(Sidebar, Main) -- Drag area di sidebar

    local WindowFuncs = {}
    local FirstTab = true

    function WindowFuncs:Tab(name)
        -- Tombol Tab
        local TabBtn = Create("TextButton", {
            Parent = TabHolder, Text = name, Size = UDim2.new(1, 0, 0, 38),
            Font = Enum.Font.GothamMedium, TextSize = 14, AutoButtonColor = false,
            BackgroundTransparency = 1
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 6)})
        ApplyTheme(TabBtn, "TextColor3", "SubText")

        -- Halaman Isi
        local Page = Create("ScrollingFrame", {
            Parent = ContentArea, Size = UDim2.fromScale(1, 1), Visible = false,
            BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = Color3.fromRGB(80,80,80)
        })
        Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
        Create("UIPadding", {Parent = Page, PaddingRight = UDim.new(0, 5), PaddingTop = UDim.new(0, 2)})

        -- Logika Klik Tab
        local function Activate()
            for _, v in pairs(ContentArea:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabHolder:GetChildren()) do 
                if v:IsA("TextButton") then 
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                    ApplyTheme(v, "TextColor3", "SubText")
                end 
            end
            
            Page.Visible = true
            -- Animasi Aktif
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            ApplyTheme(TabBtn, "BackgroundColor3", "Content")
            ApplyTheme(TabBtn, "TextColor3", "Accent")
        end

        TabBtn.MouseButton1Click:Connect(Activate)

        if FirstTab then FirstTab = false; Activate() end

        local Elements = {}

        -- [[ SECTION TITLE ]]
        function Elements:Section(text)
            local Sec = Create("TextLabel", {
                Parent = Page, Text = text, Size = UDim2.new(1, 0, 0, 30),
                Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1
            })
            Create("UIPadding", {Parent = Sec, PaddingLeft = UDim.new(0, 2)})
            ApplyTheme(Sec, "TextColor3", "Text")
        end

        -- [[ BUTTON ]]
        function Elements:Button(text, callback)
            local BtnFrame = Create("TextButton", {
                Parent = Page, Text = "", Size = UDim2.new(1, 0, 0, 42),
                AutoButtonColor = false, BackgroundTransparency = 0
            })
            Create("UICorner", {Parent = BtnFrame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = BtnFrame, Thickness = 1})
            ApplyTheme(BtnFrame, "BackgroundColor3", "Content")
            ApplyTheme(BtnFrame.UIStroke, "Color", "Outline")

            local Label = Create("TextLabel", {
                Parent = BtnFrame, Text = text, Size = UDim2.fromScale(1, 1),
                Font = Enum.Font.GothamMedium, TextSize = 14, BackgroundTransparency = 1
            })
            ApplyTheme(Label, "TextColor3", "Text")

            -- Hover Effect
            BtnFrame.MouseEnter:Connect(function()
                ApplyTheme(BtnFrame, "BackgroundColor3", "Hover")
            end)
            BtnFrame.MouseLeave:Connect(function()
                ApplyTheme(BtnFrame, "BackgroundColor3", "Content")
            end)
            BtnFrame.MouseButton1Click:Connect(function()
                -- Click Ripple Effect Simple
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 38)}):Play()
                wait(0.1)
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 42)}):Play()
                if callback then callback() end
            end)
        end

        -- [[ TOGGLE SWITCH (iPhone Style) ]]
        function Elements:Toggle(text, default, callback)
            local toggled = default or false
            local ToggleFrame = Create("TextButton", {
                Parent = Page, Text = "", Size = UDim2.new(1, 0, 0, 42),
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = ToggleFrame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = ToggleFrame, Thickness = 1})
            ApplyTheme(ToggleFrame, "BackgroundColor3", "Content")
            ApplyTheme(ToggleFrame.UIStroke, "Color", "Outline")

            local Label = Create("TextLabel", {
                Parent = ToggleFrame, Text = text, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 15, 0, 0),
                Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(Label, "TextColor3", "Text")

            -- Switch Background
            local SwitchBg = Create("Frame", {
                Parent = ToggleFrame, Size = UDim2.new(0, 40, 0, 22), Position = UDim2.new(1, -55, 0.5, -11)
            })
            Create("UICorner", {Parent = SwitchBg, CornerRadius = UDim.new(1, 0)})
            
            -- Switch Circle
            local Circle = Create("Frame", {
                Parent = SwitchBg, Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 2, 0.5, -9)
            })
            Create("UICorner", {Parent = Circle, CornerRadius = UDim.new(1, 0)})
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

            local function Update()
                if toggled then
                    TweenService:Create(SwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = Library.CurrentTheme.Accent}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.3), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
                else
                    TweenService:Create(SwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.3), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
                end
            end
            Update()

            ToggleFrame.MouseButton1Click:Connect(function()
                toggled = not toggled
                Update()
                if callback then callback(toggled) end
            end)
        end

        -- [[ SLIDER (Smooth Drag) ]]
        function Elements:Slider(text, min, max, default, callback)
            local value = default or min
            local SliderFrame = Create("Frame", {
                Parent = Page, Size = UDim2.new(1, 0, 0, 55), BackgroundTransparency = 1
            })
            
            local Container = Create("Frame", {
                Parent = SliderFrame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0
            })
            Create("UICorner", {Parent = Container, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = Container, Thickness = 1})
            ApplyTheme(Container, "BackgroundColor3", "Content")
            ApplyTheme(Container.UIStroke, "Color", "Outline")

            local Label = Create("TextLabel", {
                Parent = Container, Text = text, Size = UDim2.new(1, -15, 0, 25), Position = UDim2.new(0, 15, 0, 2),
                Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(Label, "TextColor3", "Text")

            local ValueLabel = Create("TextLabel", {
                Parent = Container, Text = tostring(value), Size = UDim2.new(0, 50, 0, 25), Position = UDim2.new(1, -60, 0, 2),
                Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1
            })
            ApplyTheme(ValueLabel, "TextColor3", "Accent")

            -- Slider Bar Base
            local BarBase = Create("TextButton", { -- Pake TextButton biar bisa diklik
                Parent = Container, Text = "", Size = UDim2.new(1, -30, 0, 6), Position = UDim2.new(0, 15, 0, 35),
                AutoButtonColor = false, BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            })
            Create("UICorner", {Parent = BarBase, CornerRadius = UDim.new(1, 0)})

            -- Fill
            local Fill = Create("Frame", {
                Parent = BarBase, Size = UDim2.new((value - min)/(max - min), 0, 1, 0), BorderSizePixel = 0
            })
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
            ApplyTheme(Fill, "BackgroundColor3", "Accent")

            -- Circle Knob
            local Knob = Create("Frame", {
                Parent = Fill, Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -7, 0.5, -7),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            })
            Create("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})

            local dragging = false
            local function Update(input)
                local sizeX = math.clamp((input.Position.X - BarBase.AbsolutePosition.X) / BarBase.AbsoluteSize.X, 0, 1)
                local newValue = math.floor(min + ((max - min) * sizeX))
                
                -- Smooth Tween UI
                TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(sizeX, 0, 1, 0)}):Play()
                ValueLabel.Text = tostring(newValue)
                
                if callback then callback(newValue) end
            end

            BarBase.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    Update(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
        end

        -- [[ THEME CHANGER ]]
        function Elements:ThemeSwitcher()
            local Holder = Create("Frame", {
                Parent = Page, Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1
            })
            Create("UIListLayout", {Parent = Holder, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10)})
            
            for name, colors in pairs(Library.Themes) do
                local Btn = Create("TextButton", {
                    Parent = Holder, Text = name, Size = UDim2.new(0.3, 0, 1, 0),
                    Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = false
                })
                Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 8)})
                Create("UIStroke", {Parent = Btn, Thickness = 2, Color = colors.Accent}) -- Border warna accent tema itu
                
                -- Preview Warna Tema
                Btn.BackgroundColor3 = colors.Main
                Btn.TextColor3 = colors.Text

                Btn.MouseButton1Click:Connect(function()
                    Library:SetTheme(name)
                end)
            end
        end

        return Elements
    end

    return WindowFuncs
end

return Library