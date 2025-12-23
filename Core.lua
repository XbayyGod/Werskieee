-- [[ Filename: Core.lua ]]
local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

-- Pastikan link ini mengarah ke file UIManager.lua yang baru lu update
local UI = loadstring(game:HttpGet(GetUrl("UIManager.lua")))() 
local Window = UI:CreateWindow("###") 

-- =============================================
-- TAB 1: MAIN (CLEAN SLATE)
-- =============================================
local MainTab = Window:Tab("Main")

-- Group: Fishing (Sesuai request)
local FishGroup = MainTab:Group("Fishing")

-- Dummy Button untuk ngetes fungsi
FishGroup:Toggle("Auto Fish", false, function(Value)
    print("Auto Fish:", Value)
end)

FishGroup:Slider("Reel Speed", 1, 100, 50, function(Value)
    print("Speed:", Value)
end)