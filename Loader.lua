local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    -- Tambahin ?t=os.time() biar linknya selalu unik (Anti-Cache)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s?t=%s", Owner, Repo, Branch, scriptName, tostring(os.time()))
end

loadstring(game:HttpGet(GetUrl("Core.lua")))()