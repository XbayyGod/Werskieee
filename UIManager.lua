-- [[ Filename: UIManager.lua ]]
-- VERSION: CLEAN SLATE (With Fixed Group Spacing & Divider)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.RegisteredElements = {}
Library.ThemeCallbacks = {}
Library.ToggleKey = Enum.KeyCode.RightControl

-- [[ 1. THEME PRESETS ]]
Library.Themes = {
    Midnight = {
        Main        = Color3.fromRGB(20, 20, 20),
        Header      = Color3.fromRGB(25, 25, 25),
        Sidebar     = Color3.fromRGB(25, 25, 25),
        CardBg      = Color3.fromRGB(32, 32, 32),
        Text        = Color3.fromRGB(255, 255, 255),
        SubText     = Color3.fromRGB(160, 160, 160),
        Accent      = Color3.fromRGB(115, 100, 255),
        Outline     = Color3.fromRGB(60, 60, 60),
        Hover       = Color3.fromRGB(50, 50, 50),
        Dropdown    = Color3.fromRGB(45, 45, 45),
        ControlIcon = Color3.fromRGB(200, 200, 200),
        ControlHover= Color3.fromRGB(70, 70, 70),
        ControlBg   = Color3.fromRGB(45, 45, 45)
    }
}
Library.CurrentTheme = Library.Themes.Midnight

-- [[ 2. HELPERS ]]
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function ApplyTheme(obj, prop, key)
    table.insert(Library.RegisteredElements, {Obj = obj, Prop = prop, Key = key})
    obj[prop] = Library.CurrentTheme[key]
end

local function toHex(color)
    return string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255)
end

function Library:SetTheme(name)
    if not Library.Themes[name] then return end
    Library.CurrentTheme = Library.Themes[name]
    for _, v in ipairs(Library.RegisteredElements) do
        if v.Obj then TweenService:Create(v.Obj, TweenInfo.new(0.3), {[v.Prop] = Library.CurrentTheme[v.Key]}):Play() end
    end
    for _, cb in ipairs(Library.ThemeCallbacks) do task.spawn(cb) end
end

-- [[ 3. MAIN UI GENERATOR ]]
function Library:CreateWindow(title_ignored)
    if CoreGui:FindFirstChild("WerskieeeHubClean") then CoreGui.WerskieeeHubClean:Destroy() end
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("WerskieeeHubClean") then 
        game.Players.LocalPlayer.PlayerGui.WerskieeeHubClean:Destroy() 
    end

    local TargetParent = nil
    local s, r = pcall(function() return gethui() end)
    if s and r then TargetParent = r else TargetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    local Gui = Create("ScreenGui", {Name = "WerskieeeHubClean", Parent = TargetParent, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false})
    
    local Main = Create("Frame", {
        Parent = Gui, Size = UDim2.fromOffset(600, 400), Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = Main, Thickness = 1})
    ApplyTheme(Main, "BackgroundColor3", "Main")
    ApplyTheme(Main.UIStroke, "Color", "Outline")

    -- HEADER
    local Header = Create("Frame", {
        Parent = Main, Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundTransparency = 1
    })
    
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = i.Position; startPos = Main.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            TweenService:Create(Main, TweenInfo.new(0.05), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)

    local TitleLbl = Create("TextLabel", {
        Parent = Header, Text = "", RichText = true, Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 20, 0, 0),
        Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
    })
    local function UpdateTitle()
        TitleLbl.Text = string.format('<font color="%s">Werskieee HUB</font> <font color="%s">| Version Code</font>', toHex(Library.CurrentTheme.Accent), toHex(Library.CurrentTheme.SubText))
    end
    table.insert(Library.ThemeCallbacks, UpdateTitle)
    UpdateTitle()

    -- CONTROLS
    local ControlHolder = Create("Frame", {
        Parent = Header, Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(1, -100, 0, 0), BackgroundTransparency = 1
    })
    Create("UIListLayout", {Parent = ControlHolder, FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
    Create("UIPadding", {Parent = ControlHolder, PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6)})

    -- SIDEBAR & CONTENT
    local Sidebar = Create("Frame", {
        Parent = Main, Size = UDim2.new(0, 160, 1, -40), Position = UDim2.new(0, 0, 0, 40), BorderSizePixel = 0, BackgroundTransparency = 1
    })
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1, ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)
    })
    Create("UIListLayout", {Parent = TabContainer, Padding = UDim.new(0, 5)})
    Create("UIPadding", {Parent = TabContainer, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 5)})

    local Content = Create("Frame", {
        Parent = Main, Size = UDim2.new(1, -170, 1, -50), Position = UDim2.new(0, 165, 0, 45), 
        BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true
    })

    -- BUTTONS CREATOR
    local function CreateBtn(order, iconID, isClose, callback)
        local Btn = Create("TextButton", {
            Parent = ControlHolder, Text = "", Size = UDim2.new(0, 28, 0, 28), AutoButtonColor = false, 
            BackgroundTransparency = 1, LayoutOrder = order
        })
        Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 6)})
        local iconSize = isClose and 20 or 14 
        local Icon = Create("ImageLabel", {
            Parent = Btn, Image = iconID, Size = UDim2.new(0, iconSize, 0, iconSize),
            Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1
        })
        if isClose then
            Icon.ImageColor3 = Color3.fromRGB(200, 200, 200)
            Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(232, 17, 35)}):Play(); Icon.ImageColor3 = Color3.new(1,1,1) end)
            Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play(); Icon.ImageColor3 = Color3.fromRGB(200, 200, 200) end)
        else
            ApplyTheme(Icon, "ImageColor3", "ControlIcon")
            Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Library.CurrentTheme.ControlHover}):Play() end)
            Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end)
        end
        Btn.MouseButton1Click:Connect(callback)
    end

    CreateBtn(2, "rbxassetid://10734896206", false, function() Main.Visible = false end)
    CreateBtn(3, "rbxassetid://6031094678", true, function() Gui:Destroy() end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Library.ToggleKey then Main.Visible = not Main.Visible end
    end)

    -- [[ ELEMENT BUILDER ]]
    local function CreateElements(ParentFrame)
        local Elements = {}

        -- >> GROUP (INI YANG GUA UBAH TOTAL: HEADER -> GARIS -> JARAK -> KONTEN)
        -- [[ GANTI FUNGSI Elements:Group (VERSI JARAK JAUH) ]]
        function Elements:Group(text)
            local isOpened = true
            
            -- 1. CARD BACKGROUND
            local GroupCard = Create("Frame", {
                Parent = ParentFrame, 
                Size = UDim2.new(1, 0, 0, 44), 
                BackgroundTransparency = 0,
                ClipsDescendants = true,
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = GroupCard, CornerRadius = UDim.new(0, 8)})
            ApplyTheme(GroupCard, "BackgroundColor3", "CardBg")

            local GroupLayout = Create("UIListLayout", {
                Parent = GroupCard, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 0)
            })

            -- 2. HEADER
            local HeaderFrame = Create("TextButton", {
                Parent = GroupCard, Text = "", Size = UDim2.new(1, 0, 0, 44),
                AutoButtonColor = false, LayoutOrder = 0, BorderSizePixel = 0,
                BackgroundTransparency = 1
            })
            
            local Label = Create("TextLabel", {
                Parent = HeaderFrame, Text = text, Size = UDim2.new(1, -35, 1, 0), Position = UDim2.new(0, 15, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, 
                TextSize = 14, BackgroundTransparency = 1
            })
            ApplyTheme(Label, "TextColor3", "Accent")

            local Arrow = Create("ImageLabel", {
                Parent = HeaderFrame, Image = "rbxassetid://6034818372", Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0.5, -10), BackgroundTransparency = 1, Rotation = 180
            })
            ApplyTheme(Arrow, "ImageColor3", "SubText")

            -- 3. DIVIDER
            local Divider = Create("Frame", {
                Parent = GroupCard, Size = UDim2.new(1, 0, 0, 1), LayoutOrder = 1, BorderSizePixel = 0,
                BackgroundTransparency = 0 
            })
            ApplyTheme(Divider, "BackgroundColor3", "Outline")
            
            -- 4. CONTAINER KONTEN
            local Container = Create("Frame", {
                Parent = GroupCard, Size = UDim2.new(1, 0, 0, 0), LayoutOrder = 2,
                BackgroundTransparency = 1, Visible = true 
            })
            local ContainerLayout = Create("UIListLayout", {
                Parent = Container, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)
            })
            
            -- [[ BAGIAN INI YANG GUA UBAH BIAR MAKIN KE BAWAH ]]
            Create("UIPadding", {
                Parent = Container, 
                PaddingTop = UDim.new(0, 30),    -- INI GUA GEDEIN JADI 30 (BIAR TURUN JAUH)
                PaddingBottom = UDim.new(0, 15),
                PaddingLeft = UDim.new(0, 10), 
                PaddingRight = UDim.new(0, 10)
            })

            local function UpdateSize()
                local contentHeight = ContainerLayout.AbsoluteContentSize.Y
                local headerHeight = 44
                
                -- Itungan padding: 30 (atas) + 15 (bawah) = 45 total padding
                local fullHeight = headerHeight + contentHeight + 45 + 1 
                local targetHeight = isOpened and fullHeight or headerHeight
                
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = isOpened and 180 or 0}):Play()
                
                if isOpened then
                    Container.Visible = true
                    TweenService:Create(Divider, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
                    TweenService:Create(GroupCard, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, targetHeight)
                    }):Play()
                else
                    TweenService:Create(GroupCard, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, targetHeight)
                    }):Play()
                    TweenService:Create(Divider, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                    
                    task.delay(0.3, function()
                        if not isOpened then Container.Visible = false end
                    end)
                end
            end
            
            ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() if isOpened then UpdateSize() end end)
            HeaderFrame.MouseButton1Click:Connect(function() isOpened = not isOpened; UpdateSize() end)

            return CreateElements(Container)
        end
        
        function Elements:Section(text)
             local F = Create("Frame", {Parent = ParentFrame, Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1})
            local L = Create("TextLabel", {
                Parent = F, Text = text, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.GothamBold,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(L, "TextColor3", "SubText")
        end

        function Elements:Button(text, callback)
            local B = Create("TextButton", {
                Parent = ParentFrame, Text = "", Size = UDim2.new(1, 0, 0, 32), AutoButtonColor = false, 
                BackgroundTransparency = 1 
            })
            
            local L = Create("TextLabel", {
                Parent = B, Text = text, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
            })
            ApplyTheme(L, "TextColor3", "Text")
            
            B.MouseEnter:Connect(function() ApplyTheme(L, "TextColor3", "Accent") end)
            B.MouseLeave:Connect(function() ApplyTheme(L, "TextColor3", "Text") end)

            B.MouseButton1Click:Connect(function()
                TweenService:Create(L, TweenInfo.new(0.1), {TextSize = 12}):Play()
                wait(0.1)
                TweenService:Create(L, TweenInfo.new(0.1), {TextSize = 13}):Play()
                if callback then callback() end
            end)
        end

        function Elements:Toggle(text, default, callback)
            local tog = default or false
            local B = Create("TextButton", {
                Parent = ParentFrame, Text = "", Size = UDim2.new(1, 0, 0, 32), AutoButtonColor = false,
                BackgroundTransparency = 1
            })
            
            local L = Create("TextLabel", {
                Parent = B, Text = text, Size = UDim2.new(1, -45, 1, 0), Position = UDim2.new(0, 0, 0, 0),
                Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(L, "TextColor3", "Text")
            
            local Switch = Create("Frame", {Parent = B, Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -34, 0.5, -9)})
            Create("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 10)})
            ApplyTheme(Switch, "BackgroundColor3", "ControlBg")

            local Knob = Create("Frame", {Parent = Switch, Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.new(1,1,1)})
            Create("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 10)})
            
            local function Update()
                if tog then
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Library.CurrentTheme.Accent}):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -16, 0.5, -7)}):Play()
                else
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Library.CurrentTheme.ControlBg}):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -7)}):Play()
                end
            end
            table.insert(Library.ThemeCallbacks, Update)
            Update()
            B.MouseButton1Click:Connect(function() tog = not tog; Update(); if callback then callback(tog) end end)
        end

        function Elements:Slider(text, min, max, default, callback)
            local val = default or min
            local F = Create("Frame", {Parent = ParentFrame, Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1})
            
            local C = Create("Frame", {Parent = F, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1})

            local L = Create("TextLabel", {
                Parent = C, Text = text, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 0),
                Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(L, "TextColor3", "Text")
            
            local V = Create("TextLabel", {
                Parent = C, Text = tostring(val), Size = UDim2.new(0, 50, 0, 20), Position = UDim2.new(1, 0, 0, 0),
                Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1
            })
            ApplyTheme(V, "TextColor3", "Accent")
            
            local Rail = Create("TextButton", {
                Parent = C, Text = "", Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, 25),
                AutoButtonColor = false, BorderSizePixel = 0
            })
            Create("UICorner", {Parent = Rail, CornerRadius = UDim.new(1, 10)})
            ApplyTheme(Rail, "BackgroundColor3", "ControlBg")

            local Fill = Create("Frame", {Parent = Rail, Size = UDim2.new((val-min)/(max-min), 0, 1, 0), BorderSizePixel = 0})
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 10)})
            ApplyTheme(Fill, "BackgroundColor3", "Accent")
            table.insert(Library.ThemeCallbacks, function() Fill.BackgroundColor3 = Library.CurrentTheme.Accent; V.TextColor3 = Library.CurrentTheme.Accent end)
            
            local dragging = false
            local function Update(input)
                local sizeX = math.clamp((input.Position.X - Rail.AbsolutePosition.X) / Rail.AbsoluteSize.X, 0, 1)
                local newVal = math.floor(min + ((max - min) * sizeX))
                TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(sizeX, 0, 1, 0)}):Play()
                V.Text = tostring(newVal)
                if callback then callback(newVal) end
            end
            Rail.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true Update(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
        end

        function Elements:Dropdown(text, options, callback)
            local dropped = false
            local Container = Create("Frame", {
                Parent = ParentFrame, Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, ClipsDescendants = false, ZIndex = 10
            })
            
            local MainBtn = Create("TextButton", {
                Parent = Container, Text = "", Size = UDim2.new(1, 0, 0, 32), AutoButtonColor = false, ZIndex = 11,
                BackgroundTransparency = 1, BorderSizePixel = 0
            })
            
            local Label = Create("TextLabel", {
                Parent = MainBtn, Text = text .. "...", Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 0, 0, 0),
                Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(Label, "TextColor3", "Text")
            
            local Arrow = Create("ImageLabel", {
                Parent = MainBtn, Image = "rbxassetid://6034818372", Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(1, -18, 0.5, -9), BackgroundTransparency = 1
            })
            ApplyTheme(Arrow, "ImageColor3", "SubText")
            
            local List = Create("ScrollingFrame", {
                Parent = Container, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 5),
                BackgroundTransparency = 0, ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0), ZIndex = 15,
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = List, CornerRadius = UDim.new(0, 6)})
            ApplyTheme(List, "BackgroundColor3", "CardBg")
            local ListStroke = Create("UIStroke", {Parent = List, Thickness = 1})
            ApplyTheme(ListStroke, "Color", "Outline")

            local ListLayout = Create("UIListLayout", {Parent = List, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
            Create("UIPadding", {Parent = List, PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})

            for _, opt in ipairs(options) do
                local OptBtn = Create("TextButton", {
                    Parent = List, Text = opt, Size = UDim2.new(1, 0, 0, 28), Font = Enum.Font.GothamMedium,
                    TextSize = 12, AutoButtonColor = false, ZIndex = 16, BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0
                })
                local OptL = Create("TextLabel",{Parent=OptBtn, Text=opt, Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Font=Enum.Font.GothamMedium, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left})
                ApplyTheme(OptL, "TextColor3", "SubText")
                OptBtn.MouseEnter:Connect(function() ApplyTheme(OptL, "TextColor3", "Accent") end)
                OptBtn.MouseLeave:Connect(function() ApplyTheme(OptL, "TextColor3", "SubText") end)

                OptBtn.MouseButton1Click:Connect(function()
                    Label.Text = text .. ": " .. opt
                    dropped = false
                    TweenService:Create(Container, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 32)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    if callback then callback(opt) end
                end)
            end
            ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() List.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10) end)
            MainBtn.MouseButton1Click:Connect(function()
                dropped = not dropped
                local targetHeight = dropped and (35 + math.min(ListLayout.AbsoluteContentSize.Y + 10, 150)) or 32
                List.Size = UDim2.new(1, 0, 0, math.min(ListLayout.AbsoluteContentSize.Y + 10, 150))
                TweenService:Create(Container, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = dropped and 180 or 0}):Play()
            end)
        end

        return Elements
    end

    local Window = {}
    local FirstTab = true

    function Window:Tab(name)
        local TabBtn = Create("TextButton", {
            Parent = TabContainer, Text = name, Size = UDim2.new(1, 0, 0, 38),
            Font = Enum.Font.GothamMedium, TextSize = 14, AutoButtonColor = false, BackgroundTransparency = 1
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 8)})
        ApplyTheme(TabBtn, "TextColor3", "SubText")

        local Indicator = Create("Frame", {
            Parent = TabBtn, Size = UDim2.new(0, 3, 0.6, 0), Position = UDim2.new(0, 0, 0.2, 0), BackgroundTransparency = 1
        })
        Create("UICorner", {Parent = Indicator, CornerRadius = UDim.new(1, 0)})
        ApplyTheme(Indicator, "BackgroundColor3", "Accent")

        local Page = Create("ScrollingFrame", {
            Parent = Content, Size = UDim2.fromScale(1, 1), Visible = false, BackgroundTransparency = 1,
            ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0), ScrollBarImageColor3 = Color3.fromRGB(60,60,60)
        })
        local Layout = Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12)})
        Create("UIPadding", {Parent = Page, PaddingTop = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingBottom = UDim.new(0, 20)})

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 40)
        end)

        local function Activate()
            for _,v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible=false end end
            for _,v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then 
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play()
                    ApplyTheme(v, "TextColor3", "SubText")
                    if v:FindFirstChild("Frame") then TweenService:Create(v.Frame, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play() end
                end
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency=0}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundTransparency=0}):Play()
            ApplyTheme(TabBtn, "BackgroundColor3", "Sidebar")
            ApplyTheme(TabBtn, "TextColor3", "Accent")
        end
        TabBtn.MouseButton1Click:Connect(Activate)
        if FirstTab then FirstTab=false; Activate() end

        return CreateElements(Page)
    end
    return Window
end

return Library