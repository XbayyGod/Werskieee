-- [[ Filename: Core.lua ]]
local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

local UIManager = loadstring(game:HttpGet(GetUrl("UIManager.lua")))()

-- ===========================================
-- SETTING WARNA CUSTOM DISINI
-- ===========================================
-- Coba ganti kode warna RGB di bawah ini:
-- Merah: Color3.fromRGB(255, 50, 50)
-- Ungu: Color3.fromRGB(170, 0, 255)
-- Emas: Color3.fromRGB(255, 215, 0)
local MyThemeColor = Color3.fromRGB(255, 0, 0) -- Saya set Merah Menyala

local Window, Fluent, SaveManager, InterfaceManager = UIManager.LoadWindow(
    "Werskieee Hub", 
    "Private Version", 
    MyThemeColor
)

-- Tambahkan Tab dan Fitur seperti biasa...
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
}

Tabs.Main:AddParagraph({
    Title = "Welcome",
    Content = "Script ini menggunakan tema warna custom merah!"
})

Window:SelectTab(1)