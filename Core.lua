-- [[ Filename: Core.lua ]]
local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

-- 1. Panggil UIManager yang sudah kita buat
local UIManager = loadstring(game:HttpGet(GetUrl("UIManager.lua")))()

-- 2. Buat Window (Warna otomatis Merah sesuai settingan di UIManager)
local Window, Fluent, SaveManager, InterfaceManager = UIManager.LoadWindow("Werskieee Hub", "Premium Script")

-- ==========================
-- CONTOH ISI MENU (TABS)
-- ==========================

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Contoh Tombol
Tabs.Main:AddButton({
    Title = "Test Button",
    Description = "Coba klik ini",
    Callback = function()
        print("Tombol berhasil diklik!")
    end
})

-- Contoh Toggle
Tabs.Main:AddToggle("MyToggle", {
    Title = "Auto Farm",
    Default = false,
    Callback = function(Value)
        print("Auto Farm:", Value)
    end
})

-- Contoh Slider
Tabs.Main:AddSlider("Slider", {
    Title = "WalkSpeed",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Finalisasi
Window:SelectTab(1)
Fluent:Notify({
    Title = "Werskieee Hub",
    Content = "Script Loaded Successfully",
    Duration = 5
})