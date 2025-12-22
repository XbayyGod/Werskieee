--!strict
-- Filename: Core.lua

local Owner = "XbayyGod"
local Repo = "Werskieee"
local Branch = "main"

local function GetUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", Owner, Repo, Branch, scriptName)
end

local UIManager = loadstring(game:HttpGet(GetUrl("UIManager.lua")))()
local UI = UIManager.new()

-- --- [ SETUP WINDOW ] ---
local Window = UI:MakeWindow({
    Name = "Werskieee Hub | PREMIUM V2",
    Size = UDim2.new(0, 600, 0, 500) -- Agak gedean dikit biar muat list
})

-- --- [ TAB SCANNER (LOGIC BARU) ] ---
local ScannerTab = Window:MakeTab({Name = "Scanner"})

local targetName = ""
local targetPath = workspace

ScannerTab:AddLabel("--- CONFIG SCANNER ---")

-- 1. Input Nama yang mau dicari
ScannerTab:AddInput("Cari Nama Value", "cth: Cash/Price/Speed...", function(text)
    targetName = text
end)

-- 2. Tombol Eksekusi
ScannerTab:AddButton("SCAN SEKARANG", function()
    -- Hapus hasil scan lama (Perlu update UIManager step 1 tadi)
    if ScannerTab.Clear then
        ScannerTab:Clear()
    else
        -- Fallback kalau lupa update UIManager
        ScannerTab:AddLabel("⚠️ WARNING: Fitur Clear belum dipasang di UIManager!")
        ScannerTab:AddLabel("--- SCAN BARU ---")
    end

    -- Balikin Config UI (Karena kehapus pas Clear)
    ScannerTab:AddLabel("Hasil Scan untuk: " .. targetName)
    
    local foundCount = 0

    -- Mulai Deep Scan
    for _, v in pairs(targetPath:GetDescendants()) do
        -- Cek apakah dia tipe Value (Angka/Text) DAN namanya cocok
        if (v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("StringValue")) 
           and string.find(v.Name:lower(), targetName:lower()) then
            
            foundCount = foundCount + 1
            
            -- [LOGIC UTAMA] 
            -- Bikin Input Box KHUSUS buat item ini doang
            -- Label: Nama Item + Value Asli
            -- Action: Ubah Value item INI SAJA
            
            local labelInfo = v.Name .. " (" .. tostring(v.Value) .. ")"
            
            ScannerTab:AddInput(labelInfo, "Isi value baru...", function(newValue)
                -- Cek tipe data biar gak error
                if v:IsA("IntValue") or v:IsA("NumberValue") then
                    local num = tonumber(newValue)
                    if num then
                        v.Value = num
                        print("✅ Berhasil ubah " .. v.Name .. " jadi " .. num)
                    end
                else
                    -- Kalau StringValue
                    v.Value = newValue
                    print("✅ Berhasil ubah text " .. v.Name)
                end
            end)
        end
    end

    if foundCount == 0 then
        ScannerTab:AddLabel("❌ Tidak ditemukan object bernama: " .. targetName)
    else
        ScannerTab:AddLabel("✅ Ditemukan: " .. foundCount .. " items.")
        ScannerTab:AddLabel("Ketik angka di kotak & Enter utk ubah.")
    end
    
    -- Tombol Reset biar user bisa scan lagi tanpa restart script
    ScannerTab:AddButton("Reset / Scan Lagi", function()
        -- Ini trik visual doang, aslinya cuma manggil function scan lagi ntar
        -- Tapi user biasanya klik tombol scan yg di atas lagi
    end)
end)

print(":: Werskieee Scanner Loaded ::")