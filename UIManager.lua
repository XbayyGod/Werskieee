-- [[ Filename: UIManager.lua ]]
local UIManager = {}

-- =================================================================
-- BAGIAN 1: ENGINE UI (KODE PANJANG FLUENT)
-- =================================================================
-- Kita masukkan kode panjang tadi ke dalam variabel 'Fluent'
local Fluent = (function()
    
    -- >> PASTE SEMUA KODE PANJANG YANG KAMU KIRIM TADI DI BAWAH SINI <<
    -- (Dari 'local a,b' sampai 'return J(M) end')
    -- Pastikan tidak ada yang ketinggalan satu huruf pun!
    
    -- ... [TEMPAT PASTE KODE PANJANG] ...
    
    -- Contoh isi dikit biar paham (JANGAN COPY INI, PASTE YG PUNYA KAMU):
    -- local a,b={{1,'ModuleScript',{'MainModule'}... dst
    
end)() -- <--- JANGAN HAPUS TANDA KURUNG '()' INI. Ini buat jalanin kodenya.

-- Load Module Tambahan (Save Manager & Interface)
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- =================================================================
-- BAGIAN 2: CUSTOM THEME (WARNA KAMU SENDIRI)
-- =================================================================
-- Disini kita bikin tema baru bernama 'IqbalTheme'.
-- Ganti kode warna (RGB) sesuai selera kamu.

Fluent.Themes["IqbalTheme"] = {
    Name = "IqbalTheme",
    Accent = Color3.fromRGB(255, 0, 0), -- [PENTING] Warna Utama (Merah). Ganti ini kalau mau warna lain.
    
    -- Warna Background (Acrylic/Kaca)
    AcrylicMain = Color3.fromRGB(15, 15, 15), -- Hitam Pekat
    AcrylicBorder = Color3.fromRGB(255, 0, 0), -- Garis pinggir window (Ikut warna Accent)
    AcrylicGradient = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(50, 0, 0)),
    AcrylicNoise = 0.95,
    
    -- Warna Judul & Tab
    TitleBarLine = Color3.fromRGB(255, 50, 50),
    Tab = Color3.fromRGB(200, 200, 200), -- Warna teks tab tidak aktif
    
    -- Warna Elemen (Tombol, Input, dll)
    Element = Color3.fromRGB(25, 25, 25), -- Warna dasar tombol
    ElementBorder = Color3.fromRGB(60, 60, 60),
    InElementBorder = Color3.fromRGB(255, 0, 0), -- Garis pinggir tombol saat aktif
    ElementTransparency = 0.9,
    
    -- Toggle & Slider
    ToggleSlider = Color3.fromRGB(255, 0, 0), -- Warna bulat toggle
    ToggleToggled = Color3.fromRGB(255, 255, 255),
    SliderRail = Color3.fromRGB(255, 0, 0), -- Garis slider
    
    -- Dropdown
    DropdownFrame = Color3.fromRGB(30, 30, 30),
    DropdownHolder = Color3.fromRGB(25, 25, 25),
    DropdownBorder = Color3.fromRGB(60, 60, 60),
    DropdownOption = Color3.fromRGB(255, 255, 255),
    
    -- Teks
    Text = Color3.fromRGB(255, 255, 255), -- Warna tulisan utama (Putih)
    SubText = Color3.fromRGB(170, 170, 170), -- Tulisan kecil (Abu-abu)
    Hover = Color3.fromRGB(40, 40, 40), -- Warna saat mouse di atas tombol
    HoverChange = 0.1
}


-- =================================================================
-- BAGIAN 3: FUNGSI PEMANGGIL WINDOW
-- =================================================================
function UIManager.LoadWindow(title, subtitle)
    local Window = Fluent:CreateWindow({
        Title = title,
        SubTitle = subtitle,
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true, 
        Theme = "IqbalTheme", -- <--- KITA PANGGIL TEMA CUSTOM TADI DISINI
        MinimizeKey = Enum.KeyCode.LeftControl
    })
    
    return Window, Fluent, SaveManager, InterfaceManager
end

return UIManager