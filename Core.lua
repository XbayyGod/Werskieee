-- [[ Filename: Core.lua ]]
local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

-- 1. Panggil UIManager
local UIManager = loadstring(game:HttpGet(GetUrl("UIManager.lua")))()

-- 2. Buat Window
local Window, Fluent, SaveManager, InterfaceManager = UIManager.LoadWindow("Werskieee Hub", "v1.0.0 by Iqbal")

-- =============================================
-- MEMBUAT SIDEBAR (TABS)
-- =============================================
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }), -- Icon bisa diganti (lucide icons)
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options -- Untuk mengambil value nanti

-- =============================================
-- ISI MENU (Main Tab)
-- =============================================

-- >> Checkbox & Toggle <<
Tabs.Main:AddToggle("MyToggle", {
    Title = "Auto Farm",
    Description = "Fitur farming otomatis (safe mode)",
    Default = false,
    Callback = function(state)
        print("Auto Farm status:", state)
        -- Masukkan logika script kamu disini
    end
})

-- >> Slider <<
Tabs.Main:AddSlider("WalkSpeedSlider", {
    Title = "Walk Speed",
    Description = "Mengatur kecepatan jalan karakter",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        print("Speed diubah ke:", Value)
        -- game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- >> Menu Collapse (Section/Paragraph) <<
local Section = Tabs.Main:AddSection("Player Stats") -- Ini judul section

Tabs.Main:AddParagraph({
    Title = "Info User",
    Content = "Username: " .. game.Players.LocalPlayer.Name .. "\nRank: Member"
})

-- =============================================
-- ISI MENU (Combat Tab)
-- =============================================
Tabs.Combat:AddToggle("Aimbot", {
    Title = "Aimbot",
    Default = false
})

-- Dropdown
Tabs.Combat:AddDropdown("AimPart", {
    Title = "Aim Part",
    Values = {"Head", "Torso", "Random"},
    Multi = false,
    Default = 1,
})

-- =============================================
-- FINALISASI (Agar smooth)
-- =============================================
Window:SelectTab(1) -- Pilih tab pertama saat dibuka
Fluent:Notify({
    Title = "Werskieee Hub",
    Content = "Script berhasil dimuat!",
    Duration = 5
})

-- Setup Config Manager (Biar user bisa save settingan)
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()