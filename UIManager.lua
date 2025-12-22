--[[ 
    FILENAME: UIManager.lua
    Deskripsi: Library UI Modern Glass/Dark (Standalone)
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {}

-- Config Warna
local UIConfig = {
    Main = Color3.fromRGB(20, 20, 25),
    Sidebar = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(0, 255, 170), -- Cyan Neon
    TextWhite = Color3.fromRGB(240, 240, 240),
    TextGray = Color3.fromRGB(150, 150, 150),
    Font = Enum.Font.GothamBold
}

function Library:CreateWindow(titleText)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SansMobaUI_Modular"
    ScreenGui.ResetOnSpawn = false
    
    pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -210)
    MainFrame.BackgroundColor3 = UIConfig.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    -- Dragging
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(MainFrame, TweenInfo.new(0.1), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = UIConfig.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Text = titleText
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 18
    Title.TextColor3 = UIConfig.Accent
    Title.Size = UDim2.new(1, -20, 0, 50)
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Sidebar

    -- Container Tab
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, -70)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0,5)
    TabList.Parent = TabContainer

    -- Container Pages
    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, -170, 1, -20)
    Pages.Position = UDim2.new(0, 170, 0, 10)
    Pages.BackgroundTransparency = 1
    Pages.Parent = MainFrame

    -- Toggle GUI Keybind
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    local Window = {}
    local firstTab = true

    function Window:AddTab(name)
        -- Button Logic
        local TabBtn = Instance.new("TextButton")
        TabBtn.Text = name
        TabBtn.Size = UDim2.new(0, 140, 0, 35)
        TabBtn.Position = UDim2.new(0, 10, 0, 0)
        TabBtn.BackgroundColor3 = UIConfig.Sidebar
        TabBtn.BackgroundTransparency = 1
        TabBtn.TextColor3 = UIConfig.TextGray
        TabBtn.Font = UIConfig.Font
        TabBtn.TextSize = 14
        TabBtn.Parent = TabContainer
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = false
        Page.Parent = Pages
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page
        
        local PagePad = Instance.new("UIPadding")
        PagePad.PaddingTop = UDim.new(0,5)
        PagePad.Parent = Page

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency=1, TextColor3=UIConfig.TextGray}):Play()
                end
            end
            for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
            
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency=0.8, TextColor3=UIConfig.Accent, BackgroundColor3=UIConfig.Accent}):Play()
            Page.Visible = true
        end)

        if firstTab then
            firstTab = false
            Page.Visible = true
            TabBtn.TextColor3 = UIConfig.Accent
            TabBtn.BackgroundTransparency = 0.8
            TabBtn.BackgroundColor3 = UIConfig.Accent
        end

        local Elements = {}

        function Elements:AddSection(text)
            local Lbl = Instance.new("TextLabel")
            Lbl.Text = text
            Lbl.Size = UDim2.new(1,0,0,25)
            Lbl.BackgroundTransparency = 1
            Lbl.TextColor3 = UIConfig.TextWhite
            Lbl.Font = Enum.Font.GothamBlack
            Lbl.TextSize = 16
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = Page
        end

        function Elements:AddButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Text = text
            Btn.Size = UDim2.new(1, -10, 0, 40)
            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Btn.TextColor3 = UIConfig.TextWhite
            Btn.Font = UIConfig.Font
            Btn.TextSize = 14
            Btn.Parent = Page
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = UIConfig.Accent, TextColor3 = Color3.new(0,0,0)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40,40,45), TextColor3 = UIConfig.TextWhite}):Play()
                callback()
            end)
        end

        function Elements:AddToggle(text, default, callback)
            local toggled = default or false
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 40)
            Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Frame.Parent = Page
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

            local Lbl = Instance.new("TextLabel")
            Lbl.Text = text
            Lbl.Size = UDim2.new(0.7, 0, 1, 0)
            Lbl.Position = UDim2.new(0, 10, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.TextColor3 = UIConfig.TextWhite
            Lbl.Font = UIConfig.Font
            Lbl.TextSize = 14
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = Frame

            local Switch = Instance.new("Frame")
            Switch.Size = UDim2.new(0, 40, 0, 20)
            Switch.Position = UDim2.new(1, -50, 0.5, -10)
            Switch.BackgroundColor3 = toggled and UIConfig.Accent or Color3.fromRGB(60,60,60)
            Switch.Parent = Frame
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
            
            local Dot = Instance.new("Frame")
            Dot.Size = UDim2.new(0, 16, 0, 16)
            Dot.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Dot.BackgroundColor3 = Color3.new(1,1,1)
            Dot.Parent = Switch
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

            local Trigger = Instance.new("TextButton")
            Trigger.Size = UDim2.new(1,0,1,0)
            Trigger.BackgroundTransparency = 1
            Trigger.Text = ""
            Trigger.Parent = Frame
            
            Trigger.MouseButton1Click:Connect(function()
                toggled = not toggled
                callback(toggled)
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = toggled and UIConfig.Accent or Color3.fromRGB(60,60,60)}):Play()
                TweenService:Create(Dot, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
            end)
        end

        function Elements:AddInput(text, placeholder, callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 45)
            Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Frame.Parent = Page
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            
            local Lbl = Instance.new("TextLabel")
            Lbl.Text = text
            Lbl.Size = UDim2.new(1, -10, 0, 20)
            Lbl.Position = UDim2.new(0, 10, 0, 2)
            Lbl.BackgroundTransparency = 1
            Lbl.TextColor3 = UIConfig.TextWhite
            Lbl.Font = UIConfig.Font
            Lbl.TextSize = 13
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = Frame
            
            local Box = Instance.new("TextBox")
            Box.Size = UDim2.new(1, -20, 0, 20)
            Box.Position = UDim2.new(0, 10, 0, 22)
            Box.BackgroundTransparency = 1
            Box.TextColor3 = UIConfig.Accent
            Box.PlaceholderText = placeholder
            Box.Text = ""
            Box.Font = UIConfig.Font
            Box.TextSize = 14
            Box.TextXAlignment = Enum.TextXAlignment.Left
            Box.Parent = Frame
            
            Box.FocusLost:Connect(function(enter)
                if enter then callback(Box.Text) end
            end)
        end

        -- Fitur Dropdown Sederhana
        function Elements:AddDropdown(text, items, callback)
            local isDropped = false
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 40)
            Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Frame.ClipsDescendants = true
            Frame.Parent = Page
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            
            local Lbl = Instance.new("TextLabel")
            Lbl.Text = text
            Lbl.Size = UDim2.new(1, -40, 0, 40)
            Lbl.Position = UDim2.new(0, 10, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.TextColor3 = UIConfig.TextWhite
            Lbl.Font = UIConfig.Font
            Lbl.TextSize = 14
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = Frame
            
            local Arrow = Instance.new("TextLabel")
            Arrow.Text = "v"
            Arrow.Size = UDim2.new(0, 30, 0, 40)
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.TextColor3 = UIConfig.TextGray
            Arrow.Font = Enum.Font.GothamBlack
            Arrow.Parent = Frame

            local Trigger = Instance.new("TextButton")
            Trigger.Size = UDim2.new(1,0,1,0)
            Trigger.BackgroundTransparency = 1
            Trigger.Text = ""
            Trigger.Parent = Frame
            
            -- Wadah Item
            local ItemContainer = Instance.new("Frame")
            ItemContainer.Size = UDim2.new(1, 0, 0, 0)
            ItemContainer.Position = UDim2.new(0, 0, 0, 40)
            ItemContainer.BackgroundTransparency = 1
            ItemContainer.Parent = Frame
            local List = Instance.new("UIListLayout")
            List.SortOrder = Enum.SortOrder.LayoutOrder
            List.Parent = ItemContainer

            for _, item in pairs(items) do
                local ItemBtn = Instance.new("TextButton")
                ItemBtn.Text = item
                ItemBtn.Size = UDim2.new(1, 0, 0, 30)
                ItemBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                ItemBtn.TextColor3 = UIConfig.TextGray
                ItemBtn.Font = UIConfig.Font
                ItemBtn.TextSize = 13
                ItemBtn.Parent = ItemContainer
                
                ItemBtn.MouseButton1Click:Connect(function()
                    callback(item)
                    Lbl.Text = text .. ": " .. item
                    -- Tutup dropdown
                    isDropped = false
                    TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 40)}):Play()
                    Arrow.Rotation = 0
                end)
            end

            Trigger.MouseButton1Click:Connect(function()
                isDropped = not isDropped
                local height = 40 + (isDropped and (#items * 30) or 0)
                TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, height)}):Play()
                Arrow.Rotation = isDropped and 180 or 0
            end)
        end

        return Elements
    end

    return Window
end

return Library