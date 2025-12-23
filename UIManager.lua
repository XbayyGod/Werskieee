-- [[ Filename: UIManager.lua ]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.RegisteredElements = {}
Library.ThemeCallbacks = {}

-- =========================
-- THEME
-- =========================
Library.Themes = {
    Midnight = {
        Main = Color3.fromRGB(20,20,20),
        Header = Color3.fromRGB(25,25,25),
        Sidebar = Color3.fromRGB(25,25,25),
        Content = Color3.fromRGB(30,30,30),
        SectionBg = Color3.fromRGB(38,38,38),
        Text = Color3.fromRGB(255,255,255),
        SubText = Color3.fromRGB(170,170,170),
        Accent = Color3.fromRGB(115,100,255),
        Outline = Color3.fromRGB(60,60,60),
        Hover = Color3.fromRGB(50,50,50),
    }
}

Library.CurrentTheme = Library.Themes.Midnight

-- =========================
-- HELPERS
-- =========================
local function Create(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props) do
        obj[k] = v
    end
    return obj
end

local function ApplyTheme(obj, prop, key)
    table.insert(Library.RegisteredElements, {
        Obj = obj,
        Prop = prop,
        Key = key
    })
    obj[prop] = Library.CurrentTheme[key]
end

local function toHex(c)
    return string.format("#%02X%02X%02X", c.R*255, c.G*255, c.B*255)
end

function Library:SetTheme(name)
    if not Library.Themes[name] then return end
    Library.CurrentTheme = Library.Themes[name]

    for _,v in ipairs(Library.RegisteredElements) do
        if v.Obj then
            TweenService:Create(v.Obj, TweenInfo.new(0.25), {
                [v.Prop] = Library.CurrentTheme[v.Key]
            }):Play()
        end
    end

    for _,cb in ipairs(Library.ThemeCallbacks) do
        task.spawn(cb)
    end
end

-- =========================
-- WINDOW
-- =========================
function Library:CreateWindow()
    if CoreGui:FindFirstChild("WerskieeeHub") then
        CoreGui.WerskieeeHub:Destroy()
    end

    local parent = (pcall(gethui) and gethui()) or game.Players.LocalPlayer.PlayerGui
    local Gui = Create("ScreenGui", {
        Name = "WerskieeeHub",
        Parent = parent,
        ResetOnSpawn = false
    })

    local Main = Create("Frame", {
        Parent = Gui,
        Size = UDim2.fromOffset(600,400),
        Position = UDim2.fromScale(0.5,0.5),
        AnchorPoint = Vector2.new(0.5,0.5),
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0,12)})
    Create("UIStroke", {Parent = Main, Thickness = 1})
    ApplyTheme(Main, "BackgroundColor3", "Main")
    ApplyTheme(Main.UIStroke, "Color", "Outline")

    -- HEADER
    local Header = Create("Frame", {
        Parent = Main,
        Size = UDim2.new(1,0,0,40),
        BackgroundTransparency = 1
    })

    local Title = Create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,-20,1,0),
        Position = UDim2.new(0,20,0,0),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true
    })

    local function UpdateTitle()
        Title.Text = string.format(
            '<font color="%s">Werskieee HUB</font> <font color="%s">| Stable</font>',
            toHex(Library.CurrentTheme.Accent),
            toHex(Library.CurrentTheme.SubText)
        )
    end
    table.insert(Library.ThemeCallbacks, UpdateTitle)
    UpdateTitle()

    -- CONTENT
    local Content = Create("ScrollingFrame", {
        Parent = Main,
        Size = UDim2.new(1,-30,1,-60),
        Position = UDim2.new(0,15,0,50),
        ScrollBarThickness = 2,
        BackgroundTransparency = 1
    })
    local Layout = Create("UIListLayout", {
        Parent = Content,
        Padding = UDim.new(0,12)
    })
    Create("UIPadding", {
        Parent = Content,
        PaddingTop = UDim.new(0,12),
        PaddingBottom = UDim.new(0,12),
        PaddingLeft = UDim.new(0,12),
        PaddingRight = UDim.new(0,12)
    })

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Content.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 20)
    end)

    -- =========================
    -- ELEMENT BUILDER
    -- =========================
    local function Elements(parent)
        local E = {}

        -- ===== GROUP (BUGFIX ONLY)
        function E:Group(text)
            local isOpened = true
            local resizing = false

            local Section = Create("Frame", {
                Parent = parent,
                Size = UDim2.new(1,0,0,36),
                BackgroundTransparency = 1,
                ClipsDescendants = true
            })

            local HeaderBtn = Create("TextButton", {
                Parent = Section,
                Size = UDim2.new(1,0,0,36),
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = HeaderBtn, CornerRadius = UDim.new(0,8)})
            ApplyTheme(HeaderBtn, "BackgroundColor3", "SectionBg")

            local Label = Create("TextLabel", {
                Parent = HeaderBtn,
                BackgroundTransparency = 1,
                Size = UDim2.new(1,-40,1,0),
                Position = UDim2.new(0,12,0,0),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = text
            })
            ApplyTheme(Label, "TextColor3", "Accent")

            local Arrow = Create("ImageLabel", {
                Parent = HeaderBtn,
                Image = "rbxassetid://6034818372",
                Size = UDim2.fromOffset(18,18),
                Position = UDim2.new(1,-28,0.5,-9),
                BackgroundTransparency = 1,
                Rotation = 180
            })
            ApplyTheme(Arrow, "ImageColor3", "SubText")

            local Container = Create("Frame", {
                Parent = Section,
                Position = UDim2.new(0,0,0,36),
                BackgroundTransparency = 1
            })

            local ContainerLayout = Create("UIListLayout", {
                Parent = Container,
                Padding = UDim.new(0,8)
            })

            Create("UIPadding", {
                Parent = Container,
                PaddingTop = UDim.new(0,12),
                PaddingBottom = UDim.new(0,12),
                PaddingLeft = UDim.new(0,8),
                PaddingRight = UDim.new(0,8)
            })

            -- 🔒 BUGFIX: anti race condition
            local function UpdateSize()
                if resizing then return end
                resizing = true

                task.defer(function()
                    local contentHeight = ContainerLayout.AbsoluteContentSize.Y
                    local targetHeight = isOpened and (36 + contentHeight + 24) or 36

                    TweenService:Create(Section, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                        Size = UDim2.new(1,0,0,targetHeight)
                    }):Play()

                    TweenService:Create(Arrow, TweenInfo.new(0.25), {
                        Rotation = isOpened and 180 or 0
                    }):Play()

                    task.delay(0.26, function()
                        resizing = false
                    end)
                end)
            end

            ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpened and not resizing then
                    UpdateSize()
                end
            end)

            HeaderBtn.MouseButton1Click:Connect(function()
                if resizing then return end
                isOpened = not isOpened
                UpdateSize()
            end)

            UpdateSize()
            return Elements(Container)
        end

        -- ===== BUTTON (HOVER BUGFIX)
        function E:Button(text, callback)
            local Btn = Create("TextButton", {
                Parent = parent,
                Size = UDim2.new(1,0,0,34),
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0,6)})
            Create("UIStroke", {Parent = Btn, Thickness = 1})
            ApplyTheme(Btn, "BackgroundColor3", "Main")
            ApplyTheme(Btn.UIStroke, "Color", "Outline")

            local Label = Create("TextLabel", {
                Parent = Btn,
                Size = UDim2.fromScale(1,1),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                Text = text
            })
            ApplyTheme(Label, "TextColor3", "Text")

            -- 🔧 BUGFIX: hover tidak register theme
            Btn.MouseEnter:Connect(function()
                Label.TextColor3 = Library.CurrentTheme.Accent
            end)
            Btn.MouseLeave:Connect(function()
                Label.TextColor3 = Library.CurrentTheme.Text
            end)

            Btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
        end

        return E
    end

    return Elements(Content)
end

return Library
