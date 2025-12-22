--!strict
-- Filename: UIManager.lua
-- Deskripsi: Custom UI Library buatan sendiri (Native Luau)

local UIManager = {}
UIManager.__index = UIManager

-- Konfigurasi Warna (Bisa kamu ubah sesuka hati)
local Colors = {
    Background = Color3.fromRGB(30, 30, 30), -- Abu gelap
    Header = Color3.fromRGB(45, 45, 45),     -- Sedikit lebih terang
    Button = Color3.fromRGB(60, 60, 60),     -- Warna tombol
    Text = Color3.fromRGB(255, 255, 255)     -- Warna teks putih
}

-- Fungsi untuk mendapatkan tempat menaruh GUI (CoreGui untuk exploit, PlayerGui untuk studio)
local function getParent()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success then 
        return coreGui 
    else 
        return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") 
    end
end

function UIManager.new()
    local self = setmetatable({}, UIManager)
    return self
end

-- Fungsi Membuat Jendela Utama (Window)
function UIManager:MakeWindow(titleText: string)
    -- 1. Buat ScreenGui Utama
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WerskieeeHub_UI"
    ScreenGui.Parent = getParent()
    ScreenGui.ResetOnSpawn = false

    -- 2. Buat Frame Utama (Kotak Window)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150) -- Di tengah layar
    MainFrame.Size = UDim2.new(0, 400, 0, 300) -- Ukuran 400x300 pixel
    MainFrame.BorderSizePixel = 0
    
    -- Kasih sudut melengkung dikit biar cakep
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    -- 3. Buat Header (Judul)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = MainFrame
    Header.BackgroundColor3 = Colors.Header
    Header.Size = UDim2.new(1, 0, 0, 40) -- Tinggi header 40px
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header

    -- Teks Judul
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = Header
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = titleText
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextSize = 18

    -- Container buat naruh tombol-tombol
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Parent = MainFrame
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 10, 0, 50)
    Container.Size = UDim2.new(1, -20, 1, -60)
    Container.ScrollBarThickness = 4
    
    -- Auto Layout (Biar tombol rapi otomatis ke bawah)
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Container
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Agar MainFrame bisa digeser (Draggable)
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Return objek window biar bisa ditambahin tombol nanti
    local WindowObj = {}
    
    -- Fungsi tambah tombol di dalam Window ini
    function WindowObj:AddButton(text: string, callback: () -> ())
        local Button = Instance.new("TextButton")
        Button.Name = text
        Button.Parent = Container
        Button.BackgroundColor3 = Colors.Button
        Button.Size = UDim2.new(1, 0, 0, 35) -- Tinggi tombol 35px
        Button.Font = Enum.Font.Gotham
        Button.Text = text
        Button.TextColor3 = Colors.Text
        Button.TextSize = 14
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Button

        -- Event Klik
        Button.MouseButton1Click:Connect(function()
            callback() -- Panggil fungsi logika
        end)
    end

    return WindowObj
end

return UIManager