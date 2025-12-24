local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local function GetUrl(scriptName)
    -- Tambahin timestamp juga disini biar UI Manager ke-refresh
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s?t=%s", Owner, Repo, Branch, scriptName, tostring(os.time()))
end

-- Load UI Manager
local success, UI = pcall(function()
    return loadstring(game:HttpGet(GetUrl("UIManager.lua")))()
end)

if not success then 
    warn("Gagal load UI Manager!") 
    return 
end

local Window = UI:CreateWindow("Hub") 

-- =============================================
-- HELPER FUNCTION (OPTIMIZED SMART REMOTE)
-- =============================================
local RemoteCache = {} -- Kita simpan remote yang sudah ketemu disini

local function getSmartRemote(type, remoteName)
    -- [OPTIMISASI 2] Cek Cache dulu. Kalau sudah pernah dicari, langsung pakai (Gak perlu looping lagi)
    if RemoteCache[remoteName] then
        return RemoteCache[remoteName]
    end

    if ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("_Index") then
        local packages = ReplicatedStorage.Packages._Index
        local netFolder = nil
        
        -- Cari folder "sleitnick_net"
        for _, v in pairs(packages:GetChildren()) do
            if v.Name:match("sleitnick_net") then
                netFolder = v
                break
            end
        end

        if netFolder and netFolder:FindFirstChild("net") then
            local targetRemote
            if type == "Function" then
                targetRemote = netFolder.net:FindFirstChild("RF/" .. remoteName)
            elseif type == "Event" then
                targetRemote = netFolder.net:FindFirstChild("RE/" .. remoteName)
            end

            -- Simpan ke cache biar besok2 gampang
            if targetRemote then
                RemoteCache[remoteName] = targetRemote
                return targetRemote
            end
        end
    end
    return nil
end

-- =============================================
-- TAB 1: MAIN
-- =============================================
local MainTab = Window:Tab("Main")

-- >> GROUP: FISHING
local FishGroup = MainTab:Group("Fishing")

-- 2. Always Equip Rod (Optimized Loop)
local autoEquipLoop = false
local equipConnection -- Variable buat nyimpen koneksi loop biar bersih

FishGroup:Toggle("Auto Equip Rod", false, function(Value)
    autoEquipLoop = Value
    
    if Value then
        -- [OPTIMISASI 3] Cari remote SEKALI saja di awal, jangan di dalam loop
        local equipRemote = getSmartRemote("Event", "EquipToolFromHotbar")
        
        if not equipRemote then 
            warn("Remote Equip tidak ditemukan!")
            return 
        end

        -- Pakai task.spawn dengan loop yang lebih efisien
        task.spawn(function()
            while autoEquipLoop do
                local player = Players.LocalPlayer
                
                -- Pastikan karakter ada baru cek tool
                if player and player.Character then
                    -- Cek logic tanpa variable berlebihan
                    if not player.Character:FindFirstChildWhichIsA("Tool") then
                        equipRemote:FireServer(1) -- Pakai remote yang sudah dicache
                    end
                end
                
                task.wait(1) -- Delay 1 detik
            end
        end)
    else
        -- Logic stop loop sudah dihandle variable 'autoEquipLoop'
    end
end)

-- >> GROUP: TELEPORTS
local TeleportGroup = MainTab:Group("Teleports")

TeleportGroup:Button("Teleport Altar 1", function()
    local player = Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        
        -- Cek map lebih cepat
        local mapFolder = workspace:FindFirstChild("! ENCHANTING ALTAR !")
        if mapFolder and mapFolder:FindFirstChild("Stand") then
            local target = mapFolder.Stand
            root.CFrame = (target.CFrame * CFrame.Angles(0, math.rad(-90), 0)) + Vector3.new(0, 3, 0)
        else
            -- [Fitur Tambahan] Notifikasi UI kalau gagal (Optional)
            warn("Tempat 'Enchanting Altar' ga ketemu bos!")
        end
    end
end)

-- =============================================
-- TAB 2: UTILITIES (TOOLS)
-- =============================================
local UtilTab = Window:Tab("Utilities")
local ToolsGroup = UtilTab:Group("Debug Tools")

ToolsGroup:Button("Unload UI", function()
    local core = game:GetService("CoreGui"):FindFirstChild("WerskieeeHubFinalFix")
    if core then core:Destroy() end
    
    local plrGui = Players.LocalPlayer.PlayerGui:FindFirstChild("WerskieeeHubFinalFix")
    if plrGui then plrGui:Destroy() end
    
    -- Matikan semua loop
    autoEquipLoop = false
end)