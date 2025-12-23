-- [[ Filename: UIManager.lua ]]
local UIManager = {}

-- Load Library Fluent dari Sumber Asli
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

function UIManager.LoadWindow(title, subtitle, customColor)
    -- 1. Setup Window Dasar
    local Window = Fluent:CreateWindow({
        Title = title,
        SubTitle = subtitle,
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true, 
        Theme = "Dark", -- Kita mulai dari Dark, nanti kita timpa warnanya
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    -- 2. CUSTOM WARNA (Biar gak pasaran)
    -- Kita gunakan spawn function biar dia jalan setelah UI jadi
    task.spawn(function()
        -- Tunggu sebentar sampai UI loading selesai
        repeat task.wait() until Fluent.GUI
        
        -- Contoh Custom: Ubah warna Accent (Highlight utama)
        -- Kalau customColor tidak diisi, pakai Biru standar
        local Accent = customColor or Color3.fromRGB(0, 255, 128) -- Default: Spring Green
        
        -- Kita paksa ubah property warna di librarynya
        -- Sayangnya Fluent agak kaku, cara terbaik adalah lewat Options jika sudah di-build,
        -- atau kita ubah global theme-nya.
        
        -- UPDATE: Cara paling ampuh di Fluent adalah memodifikasi tabel warnanya langsung
        -- Ini mengubah warna Outline dan Accent
        local Gui = Fluent.GUI
        if Gui then
            -- Ubah garis pinggir biar sesuai tema
            for _, v in pairs(Gui:GetDescendants()) do
                if v.Name == "Accent" or v.Name == "Title" then
                    if v:IsA("TextLabel") then v.TextColor3 = Accent end
                    if v:IsA("Frame") then v.BackgroundColor3 = Accent end
                end
            end
        end
        
        -- Notifikasi Custom bahwa ini script punya kamu
        Fluent:Notify({
            Title = "System",
            Content = "UI Custom Colors Loaded",
            SubContent = "By " .. game.Players.LocalPlayer.Name, -- Nama kamu otomatis muncul
            Duration = 5
        })
    end)
    
    return Window, Fluent, SaveManager, InterfaceManager
end

return UIManager