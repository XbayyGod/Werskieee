-- [[ Filename: Core.lua ]]
local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

local UI = loadstring(game:HttpGet(GetUrl("UIManager.lua")))()

-- Title Font size sudah diperbaiki di UIManager agar tidak kegedean
local Window = UI:CreateWindow("Werskieee Hub Premium")

-- [[ TAB MAIN ]]
local Main = Window:Tab("Main")

Main:Section("Combat Features")
Main:Toggle("Auto Aimbot", false, function(v)
    print("Aimbot:", v)
end)
Main:Toggle("Silent Aim", true, function(v)
    print("Silent Aim:", v)
end)

Main:Section("Local Player")
Main:Slider("WalkSpeed", 16, 250, 16, function(v)
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

-- [[ TAB SETTINGS ]]
local Settings = Window:Tab("Settings")

Settings:Section("Theme")

-- Nah ini dia Dropdown untuk ganti tema (bukan tombol berjejer lagi)
Settings:Dropdown("Select Interface Theme", {"Midnight", "Ocean", "Blood"}, function(selected)
    UI:SetTheme(selected)
end)

Settings:Section("Other")
Settings:Button("Unload Script", function()
    game.CoreGui:FindFirstChild("WerskieeeHubFinal"):Destroy()
end)