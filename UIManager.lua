-- [[ Filename: UIManager.lua ]]
local UIManager = {}

-- Kita menggunakan "Fluent" library karena sangat ringan, animasinya smooth, dan desainnya profesional.
-- Library ini di-load secara eksternal agar file kamu tetap bersih.
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Fungsi untuk membuat Window Utama
function UIManager.LoadWindow(title, subtitle)
    local Window = Fluent:CreateWindow({
        Title = title,
        SubTitle = subtitle,
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460), -- Ukuran standar profesional
        Acrylic = true, -- Efek blur (matikan jika device kentang banget, tapi biasanya aman)
        Theme = "Dark", -- Pilihan: Dark, Light, Darker, Amethyst, Rose
        MinimizeKey = Enum.KeyCode.LeftControl -- Tombol buat hide UI
    })
    
    return Window, Fluent, SaveManager, InterfaceManager
end

-- Kita return tabel Fluent juga agar bisa akses fungsi AddTab, AddSection, dll di Core.lua
return UIManager