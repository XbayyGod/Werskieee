-- [[ UIManager.lua | Professional UX Refactor ]]
-- API COMPATIBLE VERSION (NO CORE CHANGE REQUIRED)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.RegisteredElements = {}

-- =========================
-- THEME PRESETS
-- =========================
Library.Themes = {
    Midnight = {
        Main    = Color3.fromRGB(18,18,18),
        Sidebar = Color3.fromRGB(22,22,22),
        Content = Color3.fromRGB(28,28,28),
        Text    = Color3.fromRGB(240,240,240),
        SubText = Color3.fromRGB(150,150,150),
        Accent  = Color3.fromRGB(120,110,255),
        Outline = Color3.fromRGB(45,45,45),
        Hover   = Color3.fromRGB(38,38,38)
    },
    Ocean = {
        Main    = Color3.fromRGB(15,25,30),
        Sidebar = Color3.fromRGB(18,32,38),
        Content = Color3.fromRGB(24,38,44),
        Text    = Color3.fromRGB(230,255,255),
        SubText = Color3.fromRGB(140,170,170),
        Accent  = Color3.fromRGB(0,190,255),
        Outline = Color3.fromRGB(40,60,70),
        Hover   = Color3.fromRGB(30,50,60)
    },
    Blood = {
        Main    = Color3.fromRGB(22,16,16),
        Sidebar = Color3.fromRGB(26,18,18),
        Content = Color3.fromRGB(32,22,22),
        Text    = Color3.fromRGB(255,230,230),
        SubText = Color3.fromRGB(170,140,140),
        Accent  = Color3.fromRGB(220,60,60),
        Outline = Color3.fromRGB(60,30,30),
        Hover   = Color3.fromRGB(45,25,25)
    }
}

Library.CurrentTheme = Library.Themes.Midnight

-- =========================
-- HELPERS
-- =========================
local function Create(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k] = v end
    return obj
end

local function ApplyTheme(obj, prop, key)
    table.insert(Library.RegisteredElements, {Obj=obj, Prop=prop, Key=key})
    obj[prop] = Library.CurrentTheme[key]
end

function Library:SetTheme(name)
    if not Library.Themes[name] then return end
    Library.CurrentTheme = Library.Themes[name]

    for _,v in ipairs(Library.RegisteredElements) do
        if v.Obj then
            TweenService:Create(
                v.Obj,
                TweenInfo.new(0.35, Enum.EasingStyle.Quad),
                {[v.Prop] = Library.CurrentTheme[v.Key]}
            ):Play()
        end
    end
end

-- =========================
-- DRAG WINDOW
-- =========================
local function MakeDraggable(trigger, frame)
    local drag, startPos, startInput

    trigger.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            startInput = i.Position
            startPos = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    drag = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - startInput
            TweenService:Create(frame, TweenInfo.new(0.05), {
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }):Play()
        end
    end)
end

-- =========================
-- CREATE WINDOW
-- =========================
function Library:CreateWindow(title)
    if CoreGui:FindFirstChild("WerskieeeHubV2") then
        CoreGui.WerskieeeHubV2:Destroy()
    end

    local Gui = Create("ScreenGui", {
        Name = "WerskieeeHubV2",
        Parent = CoreGui
    })

    local Main = Create("Frame", {
        Parent = Gui,
        Size = UDim2.fromOffset(640,420),
        Position = UDim2.fromScale(0.5,0.5),
        AnchorPoint = Vector2.new(0.5,0.5),
        BorderSizePixel = 0
    })
    Create("UICorner",{Parent=Main,CornerRadius=UDim.new(0,12)})
    Create("UIStroke",{Parent=Main,Thickness=1})

    ApplyTheme(Main,"BackgroundColor3","Main")
    ApplyTheme(Main.UIStroke,"Color","Outline")

    -- SIDEBAR
    local Sidebar = Create("Frame",{
        Parent = Main,
        Size = UDim2.new(0,170,1,0),
        BorderSizePixel = 0
    })
    Create("UICorner",{Parent=Sidebar,CornerRadius=UDim.new(0,12)})
    ApplyTheme(Sidebar,"BackgroundColor3","Sidebar")

    MakeDraggable(Sidebar,Main)

    local Title = Create("TextLabel",{
        Parent = Sidebar,
        Text = title,
        Size = UDim2.new(1,-20,0,50),
        Position = UDim2.new(0,15,0,10),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextXAlignment = Left,
        BackgroundTransparency = 1
    })
    ApplyTheme(Title,"TextColor3","Accent")

    -- TAB LIST
    local Tabs = Create("ScrollingFrame",{
        Parent = Sidebar,
        Size = UDim2.new(1,0,1,-70),
        Position = UDim2.new(0,0,0,70),
        ScrollBarThickness = 0,
        BackgroundTransparency = 1
    })
    Create("UIListLayout",{Parent=Tabs,Padding=UDim.new(0,6)})
    Create("UIPadding",{Parent=Tabs,PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)})

    -- CONTENT
    local Content = Create("Frame",{
        Parent = Main,
        Size = UDim2.new(1,-190,1,-20),
        Position = UDim2.new(0,180,0,10),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })

    local Window = {}
    local FirstTab = true

    -- =========================
    -- TAB
    -- =========================
    function Window:Tab(name)
        local Btn = Create("TextButton",{
            Parent = Tabs,
            Text = name,
            Size = UDim2.new(1,0,0,40),
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            AutoButtonColor = false,
            BackgroundTransparency = 1
        })
        Create("UICorner",{Parent=Btn,CornerRadius=UDim.new(0,8)})
        ApplyTheme(Btn,"TextColor3","SubText")

        local Indicator = Create("Frame",{
            Parent = Btn,
            Size = UDim2.new(0,3,0.6,0),
            Position = UDim2.new(0,0,0.2,0),
            BackgroundTransparency = 1
        })
        Create("UICorner",{Parent=Indicator,CornerRadius=UDim.new(1,0)})
        ApplyTheme(Indicator,"BackgroundColor3","Accent")

        local Page = Create("ScrollingFrame",{
            Parent = Content,
            Size = UDim2.fromScale(1,1),
            CanvasSize = UDim2.new(),
            ScrollBarThickness = 3,
            Visible = false,
            BackgroundTransparency = 1
        })
        Create("UIListLayout",{Parent=Page,Padding=UDim.new(0,10)})
        Create("UIPadding",{Parent=Page,PaddingTop=UDim.new(0,6),PaddingRight=UDim.new(0,6)})

        local function Activate()
            for _,p in pairs(Content:GetChildren()) do
                if p:IsA("ScrollingFrame") then p.Visible = false end
            end
            for _,b in pairs(Tabs:GetChildren()) do
                if b:IsA("TextButton") then
                    TweenService:Create(b,TweenInfo.new(0.25),{BackgroundTransparency=1}):Play()
                    ApplyTheme(b,"TextColor3","SubText")
                    if b:FindFirstChild("Indicator") then
                        TweenService:Create(b.Indicator,TweenInfo.new(0.25),{BackgroundTransparency=1}):Play()
                    end
                end
            end

            Page.Visible = true
            Page.Position = UDim2.new(0,20,0,0)
            TweenService:Create(Page,TweenInfo.new(0.3,Enum.EasingStyle.Quint),{
                Position = UDim2.new(0,0,0,0)
            }):Play()

            TweenService:Create(Btn,TweenInfo.new(0.25),{BackgroundTransparency=0}):Play()
            TweenService:Create(Indicator,TweenInfo.new(0.25),{BackgroundTransparency=0}):Play()
            ApplyTheme(Btn,"BackgroundColor3","Content")
            ApplyTheme(Btn,"TextColor3","Accent")
        end

        Btn.MouseButton1Click:Connect(Activate)
        if FirstTab then FirstTab=false Activate() end

        local Elements = {}

        -- SECTION
        function Elements:Section(text)
            local H = Create("Frame",{Parent=Page,Size=UDim2.new(1,0,0,32),BackgroundTransparency=1})
            local L = Create("TextLabel",{
                Parent=H,Text=text,Size=UDim2.new(1,0,1,0),
                Font=Enum.Font.GothamBold,TextSize=13,
                TextXAlignment=Left,BackgroundTransparency=1
            })
            ApplyTheme(L,"TextColor3","Text")

            local Line = Create("Frame",{Parent=H,Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1)})
            ApplyTheme(Line,"BackgroundColor3","Outline")
        end

        return Elements
    end

    return Window
end

return Library
