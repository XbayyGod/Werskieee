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
    Name = "Werskieee Hub | PREMIUM",
    Size = UDim2.new(0, 600, 0, 400)
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

-- --- [ TAB 2: INSTANCE SCANNER ] ---
local ScannerTab = Window:MakeTab({Name = "Scanner"})
local OutputLabel = ScannerTab:AddLabel("Status: Idle")

-- Variable buat nyimpen path target
local targetPath = game.Workspace
local targetName = ""

ScannerTab:AddInput("Target Path (cth: Workspace)", "Default: Workspace", function(text)
    -- Logic simple buat ganti path (Hanya support service utama dulu)
    if text:lower() == "players" then targetPath = game.Players 
    elseif text:lower() == "replicated" then targetPath = game.ReplicatedStorage
    elseif text:lower() == "lighting" then targetPath = game.Lighting
    else targetPath = game.Workspace end
    
    OutputLabel.Text = "Target set to: " .. targetPath.Name
end)

ScannerTab:AddInput("Search Object Name", "Nama Objek...", function(text)
    targetName = text
end)

ScannerTab:AddButton("START SCANNING", function()
    OutputLabel.Text = "Scanning " .. targetPath.Name .. "..."
    local foundCount = 0
    
    -- Bersihkan log lama (Sebenarnya butuh fungsi clear UI, tapi kita tumpuk dulu)
    ScannerTab:AddLabel("--- [ HASIL SCAN BARU ] ---")
    
    for _, obj in pairs(targetPath:GetChildren()) do
        -- Kalau targetName kosong, print semua. Kalau ada isinya, filter.
        if targetName == "" or string.find(obj.Name:lower(), targetName:lower()) then
            foundCount = foundCount + 1
            local info = string.format("[%s] %s", obj.ClassName, obj.Name)
            
            -- Print ke Console (F9) biar detail
            print("FOUND:", obj:GetFullName())
            
            -- Tampilkan di UI
            ScannerTab:AddLabel(info)
        end
    end
    
    OutputLabel.Text = "Selesai. Ditemukan: " .. foundCount
end)

-- --- [ TAB 3: CREDITS ] ---
local CreditTab = Window:MakeTab({Name = "Credits"})
CreditTab:AddLabel("Created by XbayyGod")
CreditTab:AddLabel("UI Library: Custom V2")

print(":: Werskieee Hub Loaded ::")