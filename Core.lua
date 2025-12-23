-- [[ Filename: Core.lua ]]
local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

-- 1. Load Engine V2
local UI = loadstring(game:HttpGet(GetUrl("UIManager.lua")))()

-- 2. Buat Window
local Window = UI:CreateWindow("Werskieee Hub Premium")

-- =============================================
-- TAB: COMBAT
-- =============================================
local Combat = Window:Tab("Combat")

Combat:Section("Aimbot Settings")

Combat:Toggle("Enable Aimbot", false, function(state)
    print("Aimbot Status:", state)
end)

Combat:Slider("FOV Radius", 10, 500, 100, function(val)
    print("FOV:", val)
end)

Combat:Button("Silent Aim (Risk)", function()
    print("Silent aim enabled")
end)

-- =============================================
-- TAB: PLAYER
-- =============================================
local PlayerTab = Window:Tab("Player")

PlayerTab:Section("Movement")

PlayerTab:Slider("WalkSpeed", 16, 250, 16, function(val)
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

PlayerTab:Slider("JumpPower", 50, 300, 50, function(val)
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

PlayerTab:Toggle("Infinite Jump", false, function(s)
    print("Inf jump:", s)
end)

-- =============================================
-- TAB: SETTINGS (Theme Changer)
-- =============================================
local Settings = Window:Tab("Settings")

Settings:Section("Interface Theme")
-- Ini tombol warna-warni buat ganti tema
Settings:ThemeSwitcher()

Settings:Section("Other")
Settings:Button("Unload Script", function()
    game.CoreGui:FindFirstChild("WerskieeeHubV2"):Destroy()
end)