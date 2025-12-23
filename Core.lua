-- [[ DEBUG LOADER ]] --
local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

-- Cek apakah Core.lua bisa diambil
print("Mencoba mengambil Core.lua...")
local success, result = pcall(function()
    return game:HttpGet(GetUrl("Core.lua"))
end)

if not success then
    warn("GAGAL MENGAMBIL SCRIPT! Error HTTP/Internet.")
    warn("Detail Error:", result)
elseif string.find(result, "404: Not Found") then
    warn("GITHUB ERROR: File tidak ditemukan (404).")
    warn("Pastikan nama file di GitHub: Core.lua (perhatikan huruf besar/kecil)")
    warn("Pastikan Repository PUBLIC.")
else
    print("Core.lua ditemukan! Menjalankan...")
    -- Coba load
    local loadFunc, err = loadstring(result)
    if not loadFunc then
        warn("SYNTAX ERROR di dalam Core.lua GitHub:")
        warn(err)
    else
        loadFunc()
    end
end