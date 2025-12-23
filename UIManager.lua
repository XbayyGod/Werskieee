-- [[ Filename: UIManager.lua ]]
-- REVISION: DROPDOWN THEME FIX, CLEAN UI, NO CLUTTER

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.RegisteredElements = {}
Library.ThemeCallbacks = {}

-- [[ 1. THEME PRESETS ]]
Library.Themes = {
    Midnight = {
        Main    = Color3.fromRGB(20, 20, 20),
        Sidebar = Color3.fromRGB(25, 25, 25),
        Content = Color3.fromRGB(30, 30, 30),
        Text    = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(170, 170, 170),
        Accent  = Color3.fromRGB(115, 100, 255),
        Outline = Color3.fromRGB(50, 50, 50),
        Hover   = Color3.fromRGB(40, 40, 40),
        Dropdown= Color3.fromRGB(35, 35, 35)
    },
    Ocean = {
        Main    = Color3.fromRGB(15, 25, 35),
        Sidebar = Color3.fromRGB(20, 30, 40),
        Content = Color3.fromRGB(25, 35, 45),
        Text    = Color3.fromRGB(230, 255, 255),
        SubText = Color3.fromRGB(140, 170, 170),
        Accent  = Color3.fromRGB(0, 190, 255),
        Outline = Color3.fromRGB(40, 60, 80),
        Hover   = Color3.fromRGB(35, 50, 60),
        Dropdown= Color3.fromRGB(30, 40, 50)
    },
    Blood = {
        Main    = Color3.fromRGB(25, 18, 18),
        Sidebar = Color3.fromRGB(30, 20, 20),
        Content = Color3.fromRGB(35, 22, 22),
        Text    = Color3.fromRGB(255, 230, 230),
        SubText = Color3.fromRGB(180, 140, 140),
        Accent  = Color3.fromRGB(220, 60, 60),
        Outline = Color3.fromRGB(80, 40, 40),
        Hover   = Color3.fromRGB(50, 25, 25),
        Dropdown= Color3.fromRGB(40, 25, 25)
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

function Library:SetTheme(name)
    if not Library.Themes[name] then return end
    Library.CurrentTheme = Library.Themes[name]

    for _, v in ipairs(Library.RegisteredElements) do
        if v.Obj then
            TweenService:Create(v.Obj, TweenInfo.new(0.3), {[v.Prop] = Library.CurrentTheme[v.Key]}):Play()
        end
    end
    
    for _, cb in ipairs(Library.ThemeCallbacks) do
        task.spawn(cb)
    end
end

local function MakeDraggable(trigger, frame)
    local dragging, dragStart, startPos
    trigger.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = i.Position; startPos = frame.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            TweenService:Create(frame, TweenInfo.new(0.05), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- [[ 3. MAIN UI ]]
function Library:CreateWindow(title)
    if CoreGui:FindFirstChild("WerskieeeHubFinal") then CoreGui.WerskieeeHubFinal:Destroy() end

    local Gui = Create("ScreenGui", {Name = "WerskieeeHubFinal", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    
    local Main = Create("Frame", {
        Parent = Gui, Size = UDim2.fromOffset(600, 400), Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = Main, Thickness = 1})
    ApplyTheme(Main, "BackgroundColor3", "Main")
    ApplyTheme(Main.UIStroke, "Color", "Outline")

    local Sidebar = Create("Frame", {Parent = Main, Size = UDim2.new(0, 160, 1, 0), BorderSizePixel = 0})
    Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 10)})
    local Fix = Create("Frame", {Parent = Sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), BorderSizePixel = 0})
    ApplyTheme(Sidebar, "BackgroundColor3", "Sidebar")
    ApplyTheme(Fix, "BackgroundColor3", "Sidebar")
    MakeDraggable(Sidebar, Main)

    local TitleLbl = Create("TextLabel", {
        Parent = Sidebar, Text = title, Size = UDim2.new(1, -20, 0, 50), Position = UDim2.new(0, 15, 0, 10),
        Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, TextWrapped = true
    })
    ApplyTheme(TitleLbl, "TextColor3", "Accent")

    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar, Size = UDim2.new(1, 0, 1, -70), Position = UDim2.new(0, 0, 0, 70),
        BackgroundTransparency = 1, ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)
    })
    Create("UIListLayout", {Parent = TabContainer, Padding = UDim.new(0, 5)})
    Create("UIPadding", {Parent = TabContainer, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})

    local Content = Create("Frame", {
        Parent = Main, Size = UDim2.new(1, -170, 1, -20), Position = UDim2.new(0, 165, 0, 10),
        BackgroundTransparency = 1, ClipsDescendants = true
    })

    local Window = {}
    local FirstTab = true

    function Window:Tab(name)
        local TabBtn = Create("TextButton", {
            Parent = TabContainer, Text = name, Size = UDim2.new(1, 0, 0, 38),
            Font = Enum.Font.GothamMedium, TextSize = 14, AutoButtonColor = false, BackgroundTransparency = 1
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 6)})
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
        local Layout = Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
        Create("UIPadding", {Parent = Page, PaddingTop = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
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
            ApplyTheme(TabBtn, "BackgroundColor3", "Content")
            ApplyTheme(TabBtn, "TextColor3", "Accent")
        end
        TabBtn.MouseButton1Click:Connect(Activate)
        if FirstTab then FirstTab=false; Activate() end

        local Elements = {}

        function Elements:Section(text)
            local F = Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1})
            local L = Create("TextLabel", {
                Parent = F, Text = text, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.GothamBold,
                TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(L, "TextColor3", "Text")
            Create("Frame", {Parent = F, Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = Library.CurrentTheme.Outline})
        end

        function Elements:Button(text, callback)
            local B = Create("TextButton", {
                Parent = Page, Text = "", Size = UDim2.new(1, 0, 0, 42), AutoButtonColor = false, BackgroundTransparency = 0
            })
            Create("UICorner", {Parent = B, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = B, Thickness = 1})
            ApplyTheme(B, "BackgroundColor3", "Content")
            ApplyTheme(B.UIStroke, "Color", "Outline")
            
            local L = Create("TextLabel", {
                Parent = B, Text = text, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium, TextSize = 14
            })
            ApplyTheme(L, "TextColor3", "Text")

            B.MouseButton1Click:Connect(function()
                TweenService:Create(B, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 38)}):Play()
                wait(0.1)
                TweenService:Create(B, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 42)}):Play()
                if callback then callback() end
            end)
            B.MouseEnter:Connect(function() ApplyTheme(B, "BackgroundColor3", "Hover") end)
            B.MouseLeave:Connect(function() ApplyTheme(B, "BackgroundColor3", "Content") end)
        end

        function Elements:Toggle(text, default, callback)
            local tog = default or false
            local B = Create("TextButton", {
                Parent = Page, Text = "", Size = UDim2.new(1, 0, 0, 42), AutoButtonColor = false
            })
            Create("UICorner", {Parent = B, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = B, Thickness = 1})
            ApplyTheme(B, "BackgroundColor3", "Content")
            ApplyTheme(B.UIStroke, "Color", "Outline")

            local L = Create("TextLabel", {
                Parent = B, Text = text, Size = UDim2.new(1, -55, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(L, "TextColor3", "Text")

            local Switch = Create("Frame", {Parent = B, Size = UDim2.new(0, 38, 0, 20), Position = UDim2.new(1, -48, 0.5, -10)})
            Create("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 0)})
            local Knob = Create("Frame", {Parent = Switch, Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.new(1,1,1)})
            Create("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})

            local function Update()
                if tog then
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Library.CurrentTheme.Accent}):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                else
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                end
            end
            
            table.insert(Library.ThemeCallbacks, Update) -- Sync color on theme change
            Update()

            B.MouseButton1Click:Connect(function() tog = not tog; Update(); if callback then callback(tog) end end)
        end

        function Elements:Slider(text, min, max, default, callback)
            local val = default or min
            local F = Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1})
            local C = Create("Frame", {Parent = F, Size = UDim2.new(1, 0, 1, 0)})
            Create("UICorner", {Parent = C, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = C, Thickness = 1})
            ApplyTheme(C, "BackgroundColor3", "Content")
            ApplyTheme(C.UIStroke, "Color", "Outline")

            local L = Create("TextLabel", {
                Parent = C, Text = text, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 10, 0, 5),
                Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(L, "TextColor3", "Text")
            local V = Create("TextLabel", {
                Parent = C, Text = tostring(val), Size = UDim2.new(0, 50, 0, 20), Position = UDim2.new(1, -60, 0, 5),
                Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, BackgroundTransparency = 1
            })
            ApplyTheme(V, "TextColor3", "Accent")

            local Rail = Create("TextButton", {
                Parent = C, Text = "", Size = UDim2.new(1, -20, 0, 6), Position = UDim2.new(0, 10, 0, 32),
                AutoButtonColor = false, BackgroundColor3 = Color3.fromRGB(50,50,50)
            })
            Create("UICorner", {Parent = Rail, CornerRadius = UDim.new(1, 0)})
            local Fill = Create("Frame", {Parent = Rail, Size = UDim2.new((val-min)/(max-min), 0, 1, 0), BorderSizePixel = 0})
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
            ApplyTheme(Fill, "BackgroundColor3", "Accent")

            table.insert(Library.ThemeCallbacks, function()
                Fill.BackgroundColor3 = Library.CurrentTheme.Accent
                V.TextColor3 = Library.CurrentTheme.Accent
            end)

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

        -- [[ DROPDOWN (THE REAL FIX) ]]
        function Elements:Dropdown(text, options, callback)
            local dropped = false
            local Container = Create("Frame", {
                Parent = Page, Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, ClipsDescendants = true
            })
            
            local MainBtn = Create("TextButton", {
                Parent = Container, Text = "", Size = UDim2.new(1, 0, 0, 42), AutoButtonColor = false, ZIndex = 2
            })
            Create("UICorner", {Parent = MainBtn, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = MainBtn, Thickness = 1})
            ApplyTheme(MainBtn, "BackgroundColor3", "Content")
            ApplyTheme(MainBtn.UIStroke, "Color", "Outline")

            local Label = Create("TextLabel", {
                Parent = MainBtn, Text = text .. "...", Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1
            })
            ApplyTheme(Label, "TextColor3", "Text")

            local Arrow = Create("ImageLabel", {
                Parent = MainBtn, Image = "rbxassetid://6034818372", Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0.5, -10), BackgroundTransparency = 1
            })
            ApplyTheme(Arrow, "ImageColor3", "SubText")

            local List = Create("ScrollingFrame", {
                Parent = Container, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 45),
                BackgroundTransparency = 1, ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0)
            })
            local ListLayout = Create("UIListLayout", {Parent = List, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)})
            
            for _, opt in ipairs(options) do
                local OptBtn = Create("TextButton", {
                    Parent = List, Text = opt, Size = UDim2.new(1, 0, 0, 30), Font = Enum.Font.GothamMedium,
                    TextSize = 13, AutoButtonColor = false
                })
                Create("UICorner", {Parent = OptBtn, CornerRadius = UDim.new(0, 6)})
                ApplyTheme(OptBtn, "BackgroundColor3", "Dropdown") -- Different darker color for list
                ApplyTheme(OptBtn, "TextColor3", "SubText")

                OptBtn.MouseButton1Click:Connect(function()
                    Label.Text = text .. ": " .. opt
                    dropped = false
                    TweenService:Create(Container, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 42)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    if callback then callback(opt) end
                end)
            end

            ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                List.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
            end)

            MainBtn.MouseButton1Click:Connect(function()
                dropped = not dropped
                local contentHeight = ListLayout.AbsoluteContentSize.Y
                local targetHeight = dropped and (45 + math.min(contentHeight, 150)) or 42
                
                List.Size = UDim2.new(1, 0, 0, math.min(contentHeight, 150))
                TweenService:Create(Container, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = dropped and 180 or 0}):Play()
            end)
        end

        return Elements
    end
    return Window
end

return Library