-- [[ Filename: UIManager.lua ]]
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

-- [[ KONFIGURASI TEMA ]] --
-- Ubah warna di sini biar sesuai selera
local Theme = {
    Background = Color3.fromRGB(25, 25, 25),      -- Warna dasar window
    Sidebar = Color3.fromRGB(30, 30, 30),         -- Warna sidebar kiri
    Element = Color3.fromRGB(40, 40, 40),         -- Warna dasar tombol/input
    Text = Color3.fromRGB(240, 240, 240),         -- Warna teks utama
    Accent = Color3.fromRGB(0, 170, 255),         -- Warna highlight (Biru)
    Stroke = Color3.fromRGB(60, 60, 60)           -- Warna garis pinggir
}

-- [[ HELPER FUNCTIONS ]] --
local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        object.Position = pos
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

-- [[ FUNGSI UTAMA LIBRARY ]] --

function Library:CreateWindow(Config)
    local Name = Config.Name or "Werskieee Hub"
    
    -- Hapus UI lama jika ada biar gak numpuk
    if CoreGui:FindFirstChild("WerskieeeUI") then
        CoreGui:FindFirstChild("WerskieeeUI"):Destroy()
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "WerskieeeUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Main Frame (Window)
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        Position = UDim2.new(0.5, -275, 0.5, -175), -- Tengah layar
        Size = UDim2.new(0, 550, 0, 350),
        BorderSizePixel = 0
    })
    Create("UICorner", { Parent = MainFrame, CornerRadius = UDim.new(0, 8) })
    Create("UIStroke", { Parent = MainFrame, Color = Theme.Stroke, Thickness = 1 })

    -- Sidebar (Kiri)
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(0, 140, 1, 0),
        BorderSizePixel = 0
    })
    Create("UICorner", { Parent = Sidebar, CornerRadius = UDim.new(0, 8) })
    
    -- Title Text
    local TitleLabel = Create("TextLabel", {
        Parent = Sidebar,
        Text = Name,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Theme.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 10)
    })

    -- Container Tombol Tab
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, -60),
        Position = UDim2.new(0, 5, 0, 50),
        ScrollBarThickness = 0
    })
    Create("UIListLayout", { Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) })

    -- Container Halaman (Kanan)
    local PagesContainer = Create("Frame", {
        Name = "Pages",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 150, 0, 10),
        Size = UDim2.new(1, -160, 1, -20),
        ClipsDescendants = true
    })

    MakeDraggable(Sidebar, MainFrame) -- Sidebar jadi pegangan buat drag window

    local WindowFunctions = {}
    local FirstTab = true

    -- Fungsi Tambah Tab
    function WindowFunctions:CreateTab(TabName)
        -- Button di Sidebar
        local TabButton = Create("TextButton", {
            Parent = TabContainer,
            Text = TabName,
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme.Text,
            TextSize = 14,
            BackgroundColor3 = Theme.Background,
            BackgroundTransparency = 1, -- Default transparan
            Size = UDim2.new(1, 0, 0, 35)
        })
        Create("UICorner", { Parent = TabButton, CornerRadius = UDim.new(0, 6) })

        -- Halaman Isi (Page)
        local Page = Create("ScrollingFrame", {
            Parent = PagesContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            Visible = false -- Default sembunyi
        })
        Create("UIListLayout", { Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })

        -- Logika Ganti Tab
        if FirstTab then
            Page.Visible = true
            TabButton.BackgroundTransparency = 0 -- Highlight tab aktif
            TabButton.BackgroundColor3 = Theme.Element
            FirstTab = false
        end

        TabButton.MouseButton1Click:Connect(function()
            -- Sembunyikan semua page
            for _, v in pairs(PagesContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            -- Reset warna semua tombol tab
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then 
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                end
            end
            -- Munculkan page yang dipilih
            Page.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = Theme.Element}):Play()
        end)

        -- Fungsi Elemen (Button, Toggle, Slider)
        local PageFunctions = {}

        -- >> SECTION (LABEL)
        function PageFunctions:CreateSection(Text)
            local SectionLabel = Create("TextLabel", {
                Parent = Page,
                Text = Text,
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Accent,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25)
            })
            Create("UIPadding", { Parent = SectionLabel, PaddingLeft = UDim.new(0, 5) })
        end

        -- >> BUTTON
        function PageFunctions:CreateButton(Text, Callback)
            Callback = Callback or function() end
            
            local Button = Create("TextButton", {
                Parent = Page,
                Text = Text,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.Text,
                TextSize = 14,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 35),
                AutoButtonColor = false
            })
            Create("UICorner", { Parent = Button, CornerRadius = UDim.new(0, 6) })
            
            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
                wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Element}):Play()
                Callback()
            end)
        end

        -- >> TOGGLE
        function PageFunctions:CreateToggle(Text, Default, Callback)
            Default = Default or false
            Callback = Callback or function() end
            local Toggled = Default

            local ToggleFrame = Create("TextButton", {
                Parent = Page,
                Text = "",
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 35),
                AutoButtonColor = false
            })
            Create("UICorner", { Parent = ToggleFrame, CornerRadius = UDim.new(0, 6) })

            local Title = Create("TextLabel", {
                Parent = ToggleFrame,
                Text = Text,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 10, 0, 0)
            })

            local Indicator = Create("Frame", {
                Parent = ToggleFrame,
                BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(80,80,80),
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0.5, -10)
            })
            Create("UICorner", { Parent = Indicator, CornerRadius = UDim.new(0, 4) })

            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                local TargetColor = Toggled and Theme.Accent or Color3.fromRGB(80,80,80)
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor}):Play()
                Callback(Toggled)
            end)
        end

        -- >> SLIDER
        function PageFunctions:CreateSlider(Text, Min, Max, Default, Callback)
            Default = Default or Min
            local Value = Default
            
            local SliderFrame = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 50)
            })
            Create("UICorner", { Parent = SliderFrame, CornerRadius = UDim.new(0, 6) })

            local Title = Create("TextLabel", {
                Parent = SliderFrame,
                Text = Text,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(1, -20, 0, 20)
            })

            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame,
                Text = tostring(Value),
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 5),
                Size = UDim2.new(1, -10, 0, 20)
            })

            local Bar = Create("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, 30)
            })
            Create("UICorner", { Parent = Bar, CornerRadius = UDim.new(0, 3) })

            local Fill = Create("Frame", {
                Parent = Bar,
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            })
            Create("UICorner", { Parent = Fill, CornerRadius = UDim.new(0, 3) })

            -- Logic Drag Slider
            local Dragging = false
            local function UpdateSlider(Input)
                local SizeX = math.clamp((Input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local NewValue = math.floor(Min + ((Max - Min) * SizeX))
                
                TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(SizeX, 0, 1, 0)}):Play()
                ValueLabel.Text = tostring(NewValue)
                Callback(NewValue)
            end

            SliderFrame.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    UpdateSlider(Input)
                end
            end)

            UserInputService.InputChanged:Connect(function(Input)
                if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(Input)
                end
            end)

            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
        end

        return PageFunctions
    end

    return WindowFunctions
end

return Library