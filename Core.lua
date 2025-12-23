-- [[ Filename: Core.lua ]]
local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

-- 1. Load Custom UI Engine Kita
local UI = loadstring(game:HttpGet(GetUrl("UIManager.lua")))()

-- 2. Buat Window
local Window = UI:CreateWindow("Werskieee Hub")

-- ===================================
-- TAB: MAIN (FITUR UTAMA)
-- ===================================
local MainTab = Window:Tab("Main")

MainTab:Button("Print Halo", function()
    print("Halo Bang!")
end)

MainTab:Toggle("Auto Farm", false, function(state)
    print("Auto Farm is:", state)
end)

-- ===================================
-- TAB: SETTINGS (GANTI TEMA DISINI)
-- ===================================
local SettingsTab = Window:Tab("Settings")

-- Ini dia fitur custom yang kamu minta:
-- Tombol-tombol untuk ganti tema secara langsung
SettingsTab:ThemeSelector()

SettingsTab:Button("Unload UI", function()
    game.CoreGui:FindFirstChild("CustomUI"):Destroy()
end)