-- [[ Filename: Core.lua ]]
local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

local UI = loadstring(game:HttpGet(GetUrl("UIManager.lua")))()
local Window = UI:CreateWindow("###") -- Judul diisi RichText di UIManager

-- =============================================
-- TAB 1: MAIN
-- =============================================
local MainTab = Window:Tab("Main")

-- 1. GROUP COMBAT (Bisa di-minimize)
local CombatGroup = MainTab:Group("Combat Features")

CombatGroup:Toggle("Auto Aimbot", false, function(Value)
    print("Aimbot Active:", Value)
end)

CombatGroup:Toggle("Silent Aim", true, function(Value)
    print("Silent Aim Active:", Value)
end)

-- 2. GROUP PLAYER (Terpisah)
local PlayerGroup = MainTab:Group("Player Stats")

PlayerGroup:Slider("WalkSpeed", 16, 250, 16, function(Value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
end)

PlayerGroup:Slider("JumpPower", 50, 400, 50, function(Value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
end)

PlayerGroup:Button("Reset Character", function()
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character:BreakJoints()
    end
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
    if game.CoreGui:FindFirstChild("WerskieeeHubV6") then
        game.CoreGui.WerskieeeHubV6:Destroy()
    end
end)