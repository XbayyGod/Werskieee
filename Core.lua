-- [[ Filename: Core.lua ]]
local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

-- 1. Load UIManager (Library Custom Kita)
local UI = loadstring(game:HttpGet(GetUrl("UIManager.lua")))()

-- 2. Buat Window
local Window = UI:CreateWindow({
    Name = "Werskieee Hub"
})

-- 3. Buat Tab: MAIN
local MainTab = Window:CreateTab("Main")

MainTab:CreateSection("Character Info")

MainTab:CreateButton("Print Hello", function()
    print("Hello from custom UI!")
end)

MainTab:CreateToggle("Auto Jump", false, function(State)
    print("Auto Jump is now:", State)
end)

MainTab:CreateSection("Movement Settings")

MainTab:CreateSlider("WalkSpeed", 16, 200, 16, function(Value)
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
end)

-- 4. Buat Tab: COMBAT
local CombatTab = Window:CreateTab("Combat")

CombatTab:CreateSection("Aimbot Settings")
CombatTab:CreateToggle("Enable Aimbot", false, function(State)
    print("Aimbot:", State)
end)