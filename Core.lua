--!strict
-- Filename: Core.lua

local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

-- Load Custom UI Manager kita
local UIManager = loadstring(game:HttpGet(GetUrl("UIManager.lua")))()

-- Inisialisasi Library
local UI = UIManager.new()

-- Buat Window Baru
local MainWindow = UI:MakeWindow("Werskieee Hub | Custom UI")

-- --- [ FITUR-FITUR ] ---

-- Fitur 1: Tes Print
MainWindow:AddButton("Tes Console Print", function()
    print("Tombol berhasil diklik! Custom UI berjalan lancar.")
end)

-- Fitur 2: Speed Hack
MainWindow:AddButton("Set WalkSpeed 100", function()
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = 100
    end
end)

-- Fitur 3: Reset Speed
MainWindow:AddButton("Reset WalkSpeed", function()
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = 16
    end
end)

print("Script Loaded!")