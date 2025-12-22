--!strict
-- Filename: Core.lua

local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

-- Load Custom UI Manager V2
local UIManager = loadstring(game:HttpGet(GetUrl("UIManager.lua")))()
local UI = UIManager.new()

-- --- [ SETUP WINDOW ] ---
local Window = UI:MakeWindow({
    Name = "Werskieee Hub | PREMIUM V2",
    Size = UDim2.new(0, 600, 0, 450)
})

-- --- [ TAB 1: PLAYER ] ---
local MainTab = Window:MakeTab({Name = "Player"})

MainTab:AddButton("Set WalkSpeed (50)", function()
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    end
end)

MainTab:AddButton("Set JumpPower (100)", function()
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 100
    end
end)

MainTab:AddInput("Custom Speed", "Masukkan angka...", function(text)
    local num = tonumber(text)
    if num and game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = num
    end
end)

-- --- [ TAB 2: SUPER SCANNER ] ---
local ScannerTab = Window:MakeTab({Name = "Scanner"})
local OutputLabel = ScannerTab:AddLabel("Status: Idle")

-- Config Scanner
local targetPath = game.Workspace
local searchName = ""     -- Nama object yg dicari
local modValue = 0        -- Nilai baru yg mau disuntik

ScannerTab:AddInput("Target Path (Default: Workspace)", "workspace/players/replicated", function(text)
    local t = text:lower()
    if t == "players" then targetPath = game.Players 
    elseif t == "replicated" then targetPath = game.ReplicatedStorage
    elseif t == "lighting" then targetPath = game.Lighting
    else targetPath = game.Workspace end
    
    OutputLabel.Text = "Target: " .. targetPath.Name
end)

ScannerTab:AddLabel("--- [ MODIFIKASI VALUE ] ---")

ScannerTab:AddInput("Cari Nama Value (cth: Price)", "Nama Object Value...", function(text)
    searchName = text
end)

ScannerTab:AddInput("Ubah Jadi Angka (cth: 0)", "Angka Baru...", function(text)
    modValue = tonumber(text) or 0 -- Kalau bukan angka, jadi 0
end)

ScannerTab:AddButton("SCAN & MODIF (EXECUTE)", function()
    if searchName == "" then 
        OutputLabel.Text = "Error: Nama Value kosong!"
        return 
    end

    OutputLabel.Text = "Scanning Deep & Modifying..."
    local count = 0
    
    -- Pakai GetDescendants biar nembus sampai ke dalam folder terdalam
    for _, v in pairs(targetPath:GetDescendants()) do
        -- Cek apakah dia object Value (Int/Number/String)
        if v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("StringValue") then
            
            -- Cek apakah namanya cocok (case insensitive)
            if string.find(v.Name:lower(), searchName:lower()) then
                local old = v.Value
                v.Value = modValue -- UBAH VALUE DISINI
                
                count = count + 1
                print("MODIFIED:", v:GetFullName(), old, "->", modValue)
                
                -- Tampilin di UI (Limit 5 biar ga lag ui nya)
                if count <= 5 then
                    ScannerTab:AddLabel("[MOD] " .. v.Name .. " -> " .. modValue)
                end
            end
        end
    end
    
    OutputLabel.Text = "Selesai. " .. count .. " Value diubah."
end)

-- --- [ TAB 3: CREDITS ] ---
local CreditTab = Window:MakeTab({Name = "Credits"})
CreditTab:AddLabel("Created by " .. Owner)
CreditTab:AddLabel("UI Library: Custom V2")

print(":: Werskieee Hub Loaded ::")