-- [[ Filename: Core.lua ]]
local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

local UI = loadstring(game:HttpGet(GetUrl("UIManager.lua")))()
local Window = UI:CreateWindow("###") 

-- =============================================
-- TAB 1: MAIN
-- =============================================
local MainTab = Window:Tab("Main")

-- Group 1
local CombatGroup = MainTab:Group("Combat Features")

CombatGroup:Toggle("Auto Aimbot", false, function(Value)
    print("Aimbot:", Value)
end)

CombatGroup:Toggle("Silent Aim", true, function(Value)
    print("Silent Aim:", Value)
end)

-- Group 2
local PlayerGroup = MainTab:Group("Player Stats")

PlayerGroup:Slider("WalkSpeed", 16, 250, 16, function(Value)
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
end)

PlayerGroup:Slider("JumpPower", 50, 400, 50, function(Value)
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
end)

PlayerGroup:Button("Reset Character", function()
    game.Players.LocalPlayer.Character:BreakJoints()
end)

-- =============================================
-- TAB 2: SETTINGS
-- =============================================
local SettingsTab = Window:Tab("Settings")

local AppearanceGroup = SettingsTab:Group("Interface")

AppearanceGroup:Dropdown("Select Theme", {"Midnight", "Ocean", "Blood"}, function(Option)
    UI:SetTheme(Option)
end)

local SystemGroup = SettingsTab:Group("System")

SystemGroup:Button("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end)

SystemGroup:Button("Unload Script", function()
    if game.CoreGui:FindFirstChild("WerskieeeHubV8") then
        game.CoreGui.WerskieeeHubV8:Destroy()
    end
end)