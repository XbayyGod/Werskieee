-- [[ Filename: Core.lua ]]
local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

-- 1. Load UIManager dari GitHub
local UI = loadstring(game:HttpGet(GetUrl("UIManager.lua")))()

-- 2. Buat Window Utama
-- Judul di sini akan otomatis ditimpa oleh RichText yang ada di UIManager (Werskieee HUB | Version Code)
local Window = UI:CreateWindow("###")

-- =============================================
-- TAB 1: MAIN (Fitur Utama)
-- =============================================
local MainTab = Window:Tab("Main")

MainTab:Section("Combat Features")

MainTab:Toggle("Auto Aimbot", false, function(Value)
    print("Aimbot Active:", Value)
    -- Masukkan logic aimbot di sini
end)

MainTab:Toggle("Silent Aim", true, function(Value)
    print("Silent Aim Active:", Value)
end)

MainTab:Section("Player Stats")

MainTab:Slider("WalkSpeed", 16, 250, 16, function(Value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
end)

MainTab:Slider("JumpPower", 50, 400, 50, function(Value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
end)

MainTab:Button("Reset Character", function()
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character:BreakJoints()
    end
end)

-- =============================================
-- TAB 2: SETTINGS (Ganti Tema & Lainnya)
-- =============================================
local SettingsTab = Window:Tab("Settings")

SettingsTab:Section("Interface Appearance")

-- [[ DROPDOWN TEMA ]]
-- Ini dropdown untuk ganti warna sesuai UIManager V5.5
SettingsTab:Dropdown("Select Theme", {"Midnight", "Ocean", "Blood"}, function(Option)
    -- Panggil fungsi ganti tema dari Library
    UI:SetTheme(Option)
end)

SettingsTab:Section("System")

SettingsTab:Button("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end)

-- Tombol Unload (Opsional, karena sudah ada tombol X di pojok kanan atas)
SettingsTab:Button("Unload Script", function()
    if game.CoreGui:FindFirstChild("WerskieeeHubV5_5") then
        game.CoreGui.WerskieeeHubV5_5:Destroy()
    end
end)