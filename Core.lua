local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local GitHubToken = "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" 

local function GetPrivateScript(scriptName)
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
    -- Pake Request biar bisa input Header Authorization
    local response = request({
        Url = url,
        Method = "GET",
        Headers = {
            ["Authorization"] = "token " .. GitHubToken
        }
    })
    return response.Body
end

-- Load UI Manager dari Repo lu
local UI = loadstring(game:HttpGet(GetUrl("UIManager.lua")))() 
local Window = UI:CreateWindow("Hub") 

-- =============================================
-- HELPER FUNCTION (SMART REMOTE FINDER)
-- =============================================
-- Fungsi ini wajib ada biar lu ga capek ganti path kalau game update
local function getSmartRemote(type, remoteName)
    local rs = game:GetService("ReplicatedStorage")
    if rs:FindFirstChild("Packages") and rs.Packages:FindFirstChild("_Index") then
        local packages = rs.Packages._Index
        local netFolder = nil
        
        -- Cari folder yang namanya ada "sleitnick_net"
        for _, v in pairs(packages:GetChildren()) do
            if v.Name:match("sleitnick_net") then
                netFolder = v
                break
            end
        end

        if netFolder and netFolder:FindFirstChild("net") then
            if type == "Function" then
                return netFolder.net:FindFirstChild("RF/" .. remoteName)
            elseif type == "Event" then
                return netFolder.net:FindFirstChild("RE/" .. remoteName)
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

-- 1. Auto Fish (Update State On/Off)
-- FishGroup:Toggle("Auto Fishing", false, function(Value)
--     -- Logic: Kirim sinyal True/False ke server sekali aja pas tombol ditekan
--     local remote = getSmartRemote("Function", "UpdateAutoFishingState")
--     if remote then
--         remote:InvokeServer(Value)
--         print("Auto Fish set to:", Value)
--     else
--         warn("Remote Auto Fishing tidak ditemukan!")
--     end
-- end)

-- 2. Always Equip Rod (Looping Toggle)
local autoEquipLoop = false
FishGroup:Toggle("Always Equip Rod", false, function(Value)
    autoEquipLoop = Value
    
    if Value then
        -- Jalanin loop di background
        task.spawn(function()
            while autoEquipLoop do
                task.wait(1) -- Cek setiap 1 detik
                
                local player = game.Players.LocalPlayer
                local char = player.Character
                
                -- Kalau karakter ada TAPI gak pegang tool
                if char and not char:FindFirstChildWhichIsA("Tool") then
                    local remote = getSmartRemote("Event", "EquipToolFromHotbar")
                    if remote then
                        remote:FireServer(1) -- Paksa Equip Slot 1
                    end
                end
            end
        end)
    end
end)

-- >> GROUP: TELEPORTS
local TeleportGroup = MainTab:Group("Teleports")

TeleportGroup:Button("Teleport Altar 1", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        
        -- Cek map
        if workspace:FindFirstChild("! ENCHANTING ALTAR !") and workspace["! ENCHANTING ALTAR !"]:FindFirstChild("Stand") then
            local target = workspace["! ENCHANTING ALTAR !"].Stand
            -- Teleport logic (Di atas stand dikit + hadap bener)
            root.CFrame = (target.CFrame * CFrame.Angles(0, math.rad(-90), 0)) + Vector3.new(0, 3, 0)
        else
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
    -- Hapus ScreenGui manual karena UIManager lu belum ada fungsi Destroy window publik
    local core = game:GetService("CoreGui"):FindFirstChild("WerskieeeHubFinalFix")
    if core then core:Destroy() end
    
    local plrGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("WerskieeeHubFinalFix")
    if plrGui then plrGui:Destroy() end
end)


