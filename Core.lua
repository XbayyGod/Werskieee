--[[ 
    FILENAME: Core.lua
    Deskripsi: Controller Logika Game
]]

-- Config Repository Lu
local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

-- Function buat bikin Link otomatis
local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

-- Load UIManager otomatis dari Repo yang sama
-- (Gak perlu copy-paste link manual lagi)
local Library = loadstring(game:HttpGet(GetUrl("UIManager.lua")))()

-- Mulai buat Window
local Window = Library:CreateWindow("SansMobaHub | V2 Remake")

-- --- [ SERVICES & VARIABLES ] ---
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

-- Remote Events
local rodRemote = net:WaitForChild("RF/ChargeFishingRod")
local miniGameRemote = net:WaitForChild("RF/RequestFishingMinigameStarted")
local finishRemote = net:WaitForChild("RE/FishingCompleted")
local equipRemote = net:WaitForChild("RE/EquipToolFromHotbar")

-- --- [ TAB 1: FISHING ] ---
local TabFish = Window:AddTab("Fishing")

TabFish:AddSection("Main Features")

local isAutoFishing = false
local function StartAutoFish()
    equipRemote:FireServer(1) -- Equip Rod
    isAutoFishing = true
    
    task.spawn(function()
        while isAutoFishing do
            -- Pake pcall biar script ga putus kalau server ngelag
            local success, err = pcall(function()
                
                -- 1. Lempar Joran (Wajib tunggu server respon/Invoke)
                rodRemote:InvokeServer(workspace:GetServerTimeNow())
                
                -- 2. Jeda Lempar -> Minigame (0.5 detik cukup)
                -- Kalau kekecilan, minigame belum spawn di server
                task.wait(0.6) 
                
                -- 3. Main Minigame (Auto Perfect)
                miniGameRemote:InvokeServer(-1.25, 1.0, workspace:GetServerTimeNow())
                
                -- 4. Jeda "Narik" (KRUSIAL)
                -- Kalau ini 0, server nolak. Kita kasih 1.5 detik (Masih ngebut dibanding normal 5-8 detik)
                task.wait(1.5)
                
                -- 5. Klaim Ikan
                finishRemote:FireServer()
            end)

            if not success then
                warn("Fishing Error (Lag/Cooldown):", err)
                task.wait(1) -- Kalau error, istirahat sedetik biar ga kick
            end
            
            -- Reset Loop
            task.wait(0.1)
        end
    end)
end

TabFish:AddToggle("Enable Auto Fish 5X", false, function(val)
    if val then
        StartAutoFish()
    else
        isAutoFishing = false
        -- Optional: Cancel fishing remote
        local cancel = net:FindFirstChild("RF/CancelFishingInputs")
        if cancel then cancel:InvokeServer() end
    end
end)

TabFish:AddButton("Sell All Fish", function()
    local sell = net:FindFirstChild("RF/SellAllItems")
    if sell then 
        sell:InvokeServer() 
        print("Sold all fish!")
    end
end)

-- --- [ TAB 2: TELEPORTS ] ---
local TabTP = Window:AddTab("Teleport")
TabTP:AddSection("Island Teleport")

local Islands = {
    ["Crater Island"] = Vector3.new(968, 1, 4854),
    ["Coral Reefs"] = Vector3.new(-3095, 1, 2177),
    ["Tropical Grove"] = Vector3.new(-2038, 3, 3650),
    ["Vulcano"] = Vector3.new(-701, 48, 93),
    ["Winter"] = Vector3.new(2036, 6, 3381)
}

-- Bikin list nama buat dropdown
local islandNames = {}
for name, _ in pairs(Islands) do table.insert(islandNames, name) end

TabTP:AddDropdown("Select Island", islandNames, function(selected)
    local pos = Islands[selected]
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and pos then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,5,0))
    end
end)

-- --- [ TAB 3: PLAYER ] ---
local TabPlayer = Window:AddTab("Player")

TabPlayer:AddInput("Set WalkSpeed", "Default: 16", function(text)
    local num = tonumber(text)
    if num and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = num
    end
end)

TabPlayer:AddInput("Set JumpPower", "Default: 50", function(text)
    local num = tonumber(text)
    if num and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = num
    end
end)

TabPlayer:AddToggle("Infinity Jump", false, function(val)
    _G.InfJump = val
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- --- [ TAB 4: MISC ] ---
local TabMisc = Window:AddTab("Misc")

TabMisc:AddButton("FPS Boost (Low GFX)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        end
    end
end)

TabMisc:AddButton("Fullbright", function()
    local L = game:GetService("Lighting")
    L.Brightness = 2
    L.ClockTime = 14
    L.GlobalShadows = false
    L.FogEnd = 9e9
end)

print(":: SansMobaHub Loaded ::")