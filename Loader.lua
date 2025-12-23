-- [[ Loader.lua ]]
local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

-- Load script utama dari GitHub
loadstring(game:HttpGet(GetUrl("Core.lua")))()