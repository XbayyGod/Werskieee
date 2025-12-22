--!strict
-- Filename: UIManager.lua
-- Version: 2.0 (Premium Layout with Tabs & Inputs)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local UIManager = {}
UIManager.__index = UIManager

-- Palette Warna (Dark Modern)
local Theme = {
    Main = Color3.fromRGB(25, 25, 25),
    Sidebar = Color3.fromRGB(35, 35, 35),
    Item = Color3.fromRGB(45, 45, 45),
    Text = Color3.fromRGB(240, 240, 240),
    Accent = Color3.fromRGB(0, 170, 255), -- Biru Neon
    Outline = Color3.fromRGB(60, 60, 60)
}

function UIManager.new()
    local self = setmetatable({}, UIManager)
    return self
end

function UIManager:MakeWindow(config: {Name: string, Size: UDim2?})
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WerskieeeHub_V2"
    
    -- Handle Parent (CoreGui vs PlayerGui)
    local success, core = pcall(function() return game:GetService("CoreGui") end)
    ScreenGui.Parent = success and core or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = config.Size or UDim2.new(0, 550, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.BackgroundColor3 = Theme.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = MainFrame
    
    -- Drag Logic
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
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

    -- Sidebar (Tempat Tab)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 130, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 6)
    SideCorner.Parent = Sidebar
    
    -- Judul Script
    local Title = Instance.new("TextLabel")
    Title.Text = config.Name
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Theme.Accent
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Parent = Sidebar

    local TabContainer = Instance.new("UIListLayout")
    TabContainer.Parent = Sidebar
    TabContainer.Padding = UDim.new(0, 5)
    TabContainer.SortOrder = Enum.SortOrder.LayoutOrder
    TabContainer.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Padding buat list tab
    local SidePadding = Instance.new("UIPadding")
    SidePadding.PaddingTop = UDim.new(0, 50)
    SidePadding.Parent = Sidebar

    -- Container Halaman (Kanan)
    local Pages = Instance.new("Frame")
    Pages.Name = "Pages"
    Pages.Size = UDim2.new(1, -140, 1, -20)
    Pages.Position = UDim2.new(0, 135, 0, 10)
    Pages.BackgroundTransparency = 1
    Pages.Parent = MainFrame
    
    local WindowObj = {Tabs = {}}
    local FirstTab = true

    function WindowObj:MakeTab(config: {Name: string, Icon: string?})
        -- 1. Buat Tombol Tab di Kiri
        local TabButton = Instance.new("TextButton")
        TabButton.Text = config.Name
        TabButton.Size = UDim2.new(0, 110, 0, 30)
        TabButton.BackgroundColor3 = Theme.Main
        TabButton.TextColor3 = Theme.Text
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextSize = 12
        TabButton.AutoButtonColor = false
        TabButton.Parent = Sidebar
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabButton

        -- 2. Buat Halaman Konten di Kanan
        local Page = Instance.new("ScrollingFrame")
        Page.Name = config.Name .. "_Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = false -- Default sembunyi
        Page.Parent = Pages
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        -- Logic Ganti Tab
        TabButton.MouseButton1Click:Connect(function()
            -- Reset semua tab
            for _, t in pairs(Sidebar:GetChildren()) do
                if t:IsA("TextButton") then 
                    TweenService:Create(t, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Main, TextColor3 = Theme.Text}):Play()
                end
            end
            for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
            
            -- Aktifkan tab ini
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent, TextColor3 = Color3.new(1,1,1)}):Play()
            Page.Visible = true
        end)

        -- Auto Select Tab Pertama
        if FirstTab then
            FirstTab = false
            TabButton.BackgroundColor3 = Theme.Accent
            Page.Visible = true
        end

        local TabObj = {}

        -- [ELEMENT: BUTTON]
        function TabObj:AddButton(text: string, callback: () -> ())
            local Btn = Instance.new("TextButton")
            Btn.Text = text
            Btn.Size = UDim2.new(1, -10, 0, 35)
            Btn.BackgroundColor3 = Theme.Item
            Btn.TextColor3 = Theme.Text
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.Parent = Page
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
            
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Outline}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Item}):Play()
                callback()
            end)
        end

        -- [ELEMENT: INPUT BOX] (Penting buat Scanner)
        function TabObj:AddInput(text: string, placeholder: string, callback: (text: string) -> ())
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, -10, 0, 40)
            Container.BackgroundColor3 = Theme.Item
            Container.Parent = Page
            Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 4)

            local Label = Instance.new("TextLabel")
            Label.Text = text
            Label.Size = UDim2.new(0, 100, 1, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Container

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(0, 150, 0, 30)
            TextBox.Position = UDim2.new(1, -160, 0, 5)
            TextBox.BackgroundColor3 = Theme.Main
            TextBox.TextColor3 = Theme.Text
            TextBox.PlaceholderText = placeholder
            TextBox.Text = ""
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 13
            TextBox.Parent = Container
            Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

            TextBox.FocusLost:Connect(function(enter)
                if enter then callback(TextBox.Text) end
            end)
        end
        
        -- [ELEMENT: LABEL / CONSOLE]
        function TabObj:AddLabel(text: string)
            local Label = Instance.new("TextLabel")
            Label.Text = text
            Label.Size = UDim2.new(1, -10, 0, 25)
            Label.BackgroundColor3 = Color3.fromRGB(30,30,30)
            Label.TextColor3 = Color3.fromRGB(150,150,150)
            Label.Font = Enum.Font.Code
            Label.TextSize = 12
            Label.Parent = Page
            Instance.new("UICorner", Label).CornerRadius = UDim.new(0, 4)
            return Label -- Return biar bisa diubah text-nya nanti
        end

        return TabObj
    end

    return WindowObj
end

return UIManager