if getgenv().Library and getgenv().Library.Exit then
    getgenv().Library:Exit()
end

cloneref = cloneref or function(Object) return Object end 

--#region Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local CoreGui = cloneref(game:GetService("CoreGui"))
--#endregion

gethui = gethui or function() return CoreGui end

--#region Variables 
local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled or false
local GuiInset = GuiService:GetGuiInset().Y
local Mouse = cloneref(LocalPlayer:GetMouse())
--#endregion

local Library = { 
    Flags = { },
    MenuKeybind = tostring(Enum.KeyCode.X),

    Directory = "cloude",
    Folders = {
        Assets = "/Assets",
        Configs = "/Configs",
        Themes = "/Themes"
    },

    FontSize = 31,

    Animation = {
        Time = 0.3,
        Style = "Quint",
        Direction = "Out"
    },

    ZIndexOrder = {
        ["OptionHolder"] = 4,
        ["KeybindWindow"] = 4, -- burp
        ["ColorpickerWindow"] = 6
    },

    Theme = nil,
    Themes = nil,
    ThemeOrder = nil,
    Notifications = { },

    -- Ignore below
    Threads = { },
    Connections = { },
    SetFlags = { },

    ThemingStuff = { },
    ThemeMap = { },

    OpenFrames = { },
    PreviewDragActive = false,
    PreviewFrames = { },

    Holder = nil,
    UnusedHolder = nil,

    Font = nil,
} do 
    Library.__index = Library

    local Flags = Library.Flags 
    local SetFlags = Library.SetFlags

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    -- Folders
    if not isfolder(Library.Directory) then 
        makefolder(Library.Directory)
    end

    for _, Folder in Library.Folders do 
        if not isfolder(Library.Directory .. Folder) then 
            makefolder(Library.Directory .. Folder)
        end
    end

    if not isfile(Library.Directory .. "/autoload.json") then
        writefile(Library.Directory .. "/autoload.json", "")
    end

    local Themes = {
        ["Default"] = {
            ["Background"] = Color3.fromRGB(11, 13, 13),
            ["Inline"] = Color3.fromRGB(17, 20, 20),
            ["Text"] = Color3.fromRGB(200, 200, 200),
            ["Inactive Text"] = Color3.fromRGB(100, 100, 100),
            ["Element"] = Color3.fromRGB(34, 40, 40),
            ["Accent"] = Color3.fromRGB(133, 135, 255),
            ["Outline"] = Color3.fromRGB(21, 25, 24),
            ["Outline 2"] = Color3.fromRGB(6, 7, 7),
            ["Hovered Element"] = Color3.fromRGB(47, 55, 55),
        },
        ["Graphite"] = {
            ["Background"] = Color3.fromRGB(14, 14, 15),
            ["Inline"] = Color3.fromRGB(20, 20, 22),
            ["Text"] = Color3.fromRGB(220, 220, 225),
            ["Inactive Text"] = Color3.fromRGB(110, 110, 118),
            ["Element"] = Color3.fromRGB(38, 38, 42),
            ["Accent"] = Color3.fromRGB(180, 185, 195),
            ["Outline"] = Color3.fromRGB(28, 28, 30),
            ["Outline 2"] = Color3.fromRGB(7, 7, 8),
            ["Hovered Element"] = Color3.fromRGB(52, 52, 58),
        },
        ["Vapor"] = {
            ["Background"] = Color3.fromRGB(12, 10, 16),
            ["Inline"] = Color3.fromRGB(18, 15, 26),
            ["Text"] = Color3.fromRGB(235, 230, 245),
            ["Inactive Text"] = Color3.fromRGB(130, 115, 155),
            ["Element"] = Color3.fromRGB(36, 30, 52),
            ["Accent"] = Color3.fromRGB(255, 120, 200),
            ["Outline"] = Color3.fromRGB(30, 24, 42),
            ["Outline 2"] = Color3.fromRGB(6, 5, 10),
            ["Hovered Element"] = Color3.fromRGB(50, 42, 72),
        },
        ["Oxide"] = {
            ["Background"] = Color3.fromRGB(15, 12, 10),
            ["Inline"] = Color3.fromRGB(22, 17, 14),
            ["Text"] = Color3.fromRGB(235, 220, 205),
            ["Inactive Text"] = Color3.fromRGB(130, 105, 85),
            ["Element"] = Color3.fromRGB(48, 34, 26),
            ["Accent"] = Color3.fromRGB(210, 105, 55),
            ["Outline"] = Color3.fromRGB(34, 24, 18),
            ["Outline 2"] = Color3.fromRGB(8, 5, 4),
            ["Hovered Element"] = Color3.fromRGB(66, 46, 36),
        },
        ["Glacier"] = {
            ["Background"] = Color3.fromRGB(10, 13, 16),
            ["Inline"] = Color3.fromRGB(14, 19, 24),
            ["Text"] = Color3.fromRGB(220, 235, 245),
            ["Inactive Text"] = Color3.fromRGB(100, 125, 145),
            ["Element"] = Color3.fromRGB(28, 38, 48),
            ["Accent"] = Color3.fromRGB(140, 210, 240),
            ["Outline"] = Color3.fromRGB(20, 28, 36),
            ["Outline 2"] = Color3.fromRGB(5, 7, 9),
            ["Hovered Element"] = Color3.fromRGB(40, 54, 68),
        },
        ["Nectar"] = {
            ["Background"] = Color3.fromRGB(13, 12, 9),
            ["Inline"] = Color3.fromRGB(20, 18, 12),
            ["Text"] = Color3.fromRGB(240, 230, 200),
            ["Inactive Text"] = Color3.fromRGB(135, 120, 80),
            ["Element"] = Color3.fromRGB(42, 36, 22),
            ["Accent"] = Color3.fromRGB(245, 190, 45),
            ["Outline"] = Color3.fromRGB(30, 26, 16),
            ["Outline 2"] = Color3.fromRGB(7, 6, 3),
            ["Hovered Element"] = Color3.fromRGB(58, 50, 30),
        },
        ["Poison"] = {
            ["Background"] = Color3.fromRGB(10, 14, 10),
            ["Inline"] = Color3.fromRGB(14, 22, 14),
            ["Text"] = Color3.fromRGB(210, 245, 210),
            ["Inactive Text"] = Color3.fromRGB(90, 130, 95),
            ["Element"] = Color3.fromRGB(26, 44, 28),
            ["Accent"] = Color3.fromRGB(90, 255, 120),
            ["Outline"] = Color3.fromRGB(18, 32, 20),
            ["Outline 2"] = Color3.fromRGB(4, 8, 5),
            ["Hovered Element"] = Color3.fromRGB(36, 62, 40),
        },
        ["Circuit"] = {
            ["Background"] = Color3.fromRGB(8, 12, 14),
            ["Inline"] = Color3.fromRGB(12, 18, 22),
            ["Text"] = Color3.fromRGB(200, 245, 240),
            ["Inactive Text"] = Color3.fromRGB(80, 130, 125),
            ["Element"] = Color3.fromRGB(22, 40, 44),
            ["Accent"] = Color3.fromRGB(0, 255, 200),
            ["Outline"] = Color3.fromRGB(16, 30, 34),
            ["Outline 2"] = Color3.fromRGB(3, 7, 8),
            ["Hovered Element"] = Color3.fromRGB(32, 56, 62),
        },
    }

    local ThemeOrder = { "Default", "Graphite", "Vapor", "Oxide", "Glacier", "Nectar", "Poison", "Circuit" }

    Library.Themes = Themes
    Library.ThemeOrder = ThemeOrder
    Library.Theme = Themes.Default

    -- Custom Font
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if not isfile(Data.Id) then 
                writefile(Data.Id, game:HttpGet(Data.Url))
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Data.Id)
                    }
                }
            }

            writefile(`{Library.Directory .. Library.Folders.Assets}/{Name}.font`, HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(`{Library.Directory .. Library.Folders.Assets}/{Name}.font`))
        end

        Library.Font = CustomFont:New("basim33", 400, "Regular", {
            Id = "basim33a",
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/basim33.ttf"
        })

        Library.BoldFont = CustomFont:New("basim33BOLD", 400, "Regular", {
            Id = "basim33BOLaD",
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/basim33BOLD.ttf"
        })
    end

    Library.Exit = function(Self)
        for _, Connection in Library.Connections do 
            Connection:Disconnect()
        end

        for _, Thread in Library.Threads do 
            coroutine.close(Thread)
        end

        if Self.Holder then 
            Self.Holder.Instance:Destroy()
        end

        if Self.UnusedHolder then 
            Self.UnusedHolder.Instance:Destroy()
        end

        Library = nil
        getgenv().Library = nil
    end

    Library.Create = function(Self, Class, Properties)
        local Data = {
            Class = Class,
            Properties = Properties,
            Instance = Instance.new(Class)
        }

        for Index, Property in Properties do 
            if Property == "FontFace" then
                Data.Instance[Property] = Library.Font
                continue
            end

            if Property == "TextSize" then 
                Data.Instance[Property] = Library.FontSize
                continue
            end

            if Property == "Name" then 
                Data.Instance[Property] = "\0"
                continue
            end

            if Class == "TextButton" then 
                if Property == "AutoButtonColor" then 
                    Data.Instance[Property] = false
                    continue
                end

                if Property == "Text" then 
                    Data.Instance[Property] = ""
                    continue
                end
            end

            Data.Instance[Index] = Property
        end

        return setmetatable(Data, Library)
    end

    Library.Thread = function(Self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        table.insert(Library.Threads, NewThread)
        return NewThread
    end

    Library.Connect = function(Self, Signal, Callback)
        local Connection

        if Self.Instance then
            if Self.Instance[Signal] then 
                if IsMobile and Signal == "MouseButton1Down" then 
                    Connection = Self.Instance.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Callback(Input)
                        end
                    end)

                    return
                end
                
                Connection = Self.Instance[Signal]:Connect(Callback)
            else
                Connection = Signal:Connect(Callback)
            end
        else
            Connection = Signal:Connect(Callback)
        end

        table.insert(Library.Connections, Connection)
        return Connection
    end

    Library.Tween = function(Self, Properties, Info, IsRawItem)
        local Object = Self.Instance or IsRawItem
        Info = Info or TweenInfo.new(Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style], Enum.EasingDirection[Library.Animation.Direction])

        if not Object then 
            return 
        end

        local NewTween = TweenService:Create(Object, Info, Properties)
        NewTween:Play()

        return NewTween
    end

    Library.GetTweenProperty = function(Self, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then 
            return { }
        end

        if Object:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Object:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Object:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("UIStroke") then 
            return { "Transparency" }
        end
    end

    Library.Fade = function(Self, Property, Visibility, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then 
            return 
        end

        local OrigAttr = "_Orig" .. Property
        local GenAttr = "_FadeGen" .. Property
        local BusyAttr = "_Fading" .. Property

        if not Object:GetAttribute(BusyAttr) or Object:GetAttribute(OrigAttr) == nil then
            Object:SetAttribute(OrigAttr, Object[Property])
        end

        local Original = Object:GetAttribute(OrigAttr)
        local Gen = (Object:GetAttribute(GenAttr) or 0) + 1
        Object:SetAttribute(GenAttr, Gen)
        Object:SetAttribute(BusyAttr, true)

        local NewTween

        if Visibility then
            Object[Property] = 1
            NewTween = Library:Tween({[Property] = Original}, nil, Object)
        else
            NewTween = Library:Tween({[Property] = 1}, nil, Object)
        end

        NewTween.Completed:Once(function()
            if Object:GetAttribute(GenAttr) ~= Gen then
                return
            end

            Object:SetAttribute(BusyAttr, nil)

            if not Visibility and Object.Parent then
                Object[Property] = Original
            end
        end)

        return NewTween
    end

    Library.FadeDescendants = function(Self, Visibility, Callback)
        if Visibility then 
            Self.Instance.Visible = true 
        end

        local NewTween 

        local Children = Self.Instance:GetDescendants()
        table.insert(Children, Self.Instance)

        for _, Child in Children do 
            local TransparencyProperty = Library:GetTweenProperty(Child)

            if not TransparencyProperty then 
                continue 
            end

            if type(TransparencyProperty) == "table" then
                for _, Property in TransparencyProperty do
                    NewTween = Library:Fade(Property, Visibility, Child)
                end
            else
                NewTween = Library:Fade(TransparencyProperty, Visibility, Child)
            end
        end

        if not NewTween then
            if Callback and type(Callback) == "function" then
                Callback()
            end

            Self.Instance.Visible = Visibility
            return
        end

        Library:Connect(NewTween.Completed, function()
            if Callback and type(Callback) == "function" then 
                Callback()
            end

            Self.Instance.Visible = Visibility
        end)
    end

    Library.SetPreviewFramesVisible = function(Self, Parent, Visible)
        if not Parent then
            return
        end

        for _, Frame in Library.PreviewFrames do
            if Frame and Frame.Parent and Frame:IsDescendantOf(Parent) then
                Frame.Visible = Visible
            end
        end
    end

    Library.IsPointerOverPreview = function(Self, Position)
        Position = Position or Vector2.new(Mouse.X, Mouse.Y)

        for _, Frame in Library.PreviewFrames do
            if Frame and Frame.Parent and Frame.Visible then
                local FramePosition = Frame.AbsolutePosition
                local FrameSize = Frame.AbsoluteSize

                if Position.X >= FramePosition.X and Position.X <= FramePosition.X + FrameSize.X
                    and Position.Y >= FramePosition.Y and Position.Y <= FramePosition.Y + FrameSize.Y then
                    return true
                end
            end
        end

        return false
    end

    Library.MakeDraggable = function(Self)
        if not Self.Instance then 
            return
        end
    
        local Gui = Self.Instance
        local Dragging = false 
        local DragStart
        local StartPosition 
    
        local Set = function(Input)
            if Library.PreviewDragActive or Library:IsPointerOverPreview(Input.Position) then
                Dragging = false
                return
            end

            local DragDelta = Input.Position - DragStart
            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize
            local GuiSize = Gui.AbsoluteSize
    
            NewX = math.clamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = math.clamp(NewY, 0, ScreenSize.Y - GuiSize.Y)
    
            Self:Tween({Position = UDim2.new(0, NewX, 0, NewY)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        end
    
        local InputChanged
    
        Self:Connect("InputBegan", function(Input)
            if Library.PreviewDragActive or Library:IsPointerOverPreview(Input.Position) then
                return
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Gui.Position
    
                if InputChanged then 
                    return
                end
    
                InputChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                        InputChanged:Disconnect()
                        InputChanged = nil
                    end
                end)
            end
        end)
    
        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Dragging then
                    Set(Input)
                end
            end
        end)
    
        return Dragging
    end

    Library.MakeResizeable = function(Self, Minimum)
        if not Self.Instance then 
            return
        end

        local Gui = Self.Instance

        local Resizing = false 
        local CurrentSide = nil

        local StartMouse = nil 
        local StartPosition = nil 
        local StartSize = nil
        
        local EdgeThickness = 2

        local MakeEdge = function(Name, Position, Size)
            local Button = Library:Create("TextButton", {
                Name = "\0",
                Size = Size,
                Position = Position,
                BackgroundColor3 = Color3.fromRGB(166, 147, 243),
                BackgroundTransparency = 1,
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = Gui,
                ZIndex = 99999,
            })  Button:AddToTheme({BackgroundColor3 = "Accent"})

            return Button
        end

        local Edges = {
            {Button = MakeEdge(
                "Left", 
                UDim2.new(0, 0, 0, 0), 
                UDim2.new(0, EdgeThickness, 1, 0)), 
                Side = "L"
            },

            {Button = MakeEdge(
                "Right", 
                UDim2.new(1, -EdgeThickness, 0, 0), 
                UDim2.new(0, EdgeThickness, 1, 0)), 
                Side = "R"
            },

            {Button = MakeEdge(
                "Top", UDim2.new(0, 0, 0, 0), 
                UDim2.new(1, 0, 0, EdgeThickness)), 
                Side = "T"
            },

            {Button = MakeEdge(
                "Bottom", 
                UDim2.new(0, 0, 1, -EdgeThickness), 
                UDim2.new(1, 0, 0, EdgeThickness)), 
                Side = "B"
            },
        }

        local BeginResizing = function(Side)
            Resizing = true 
            CurrentSide = Side 

            StartMouse = UserInputService:GetMouseLocation()

            StartPosition = Vector2.new(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2.new(Gui.Size.X.Offset, Gui.Size.Y.Offset)
            
            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
            end
        end

        local EndResizing = function()
            Resizing = false 
            CurrentSide = nil

            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = 1
            end
        end

        for Index, Value in Edges do 
            Value.Button:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    BeginResizing(Value.Side)
                end
            end)
        end

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if Resizing then
                    EndResizing()
                end
            end
        end)

        Library:Connect(RunService.RenderStepped, function()
            if not Resizing or not CurrentSide then 
                return 
            end

            local MouseLocation = UserInputService:GetMouseLocation()
            local dx = MouseLocation.X - StartMouse.X
            local dy = MouseLocation.Y - StartMouse.Y
        
            local x, y = StartPosition.X, StartPosition.Y
            local w, h = StartSize.X, StartSize.Y

            if CurrentSide == "L" then
                x = StartPosition.X + dx
                w = StartSize.X - dx
            elseif CurrentSide == "R" then
                w = StartSize.X + dx
            elseif CurrentSide == "T" then
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            elseif CurrentSide == "B" then
                h = StartSize.Y + dy
            end
        
            if w < Minimum.X then
                if CurrentSide == "L" then
                    x = x - (Minimum.X - w)
                end
                w = Minimum.X
            end
            if h < Minimum.Y then
                if CurrentSide == "T" then
                    y = y - (Minimum.Y - h)
                end
                h = Minimum.Y
            end
        
            Self:Tween({Position = UDim2.fromOffset(x, y)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            Self:Tween({Size = UDim2.fromOffset(w, h)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        end)
    end

    Library.IsMouseOverFrame = function(Self)
        if not Self.Instance then 
            return 
        end

        local Object = Self.Instance

        local MousePosition = Vector2.new(Mouse.X, Mouse.Y)

        return MousePosition.X >= Object.AbsolutePosition.X and MousePosition.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X 
        and MousePosition.Y >= Object.AbsolutePosition.Y and MousePosition.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
    end

    Library.SafeCall = function(Self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, table.unpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success, Result
    end

    Library.Round = function(Self, Number, Decimals)
        local Multiplier = 10 ^ math.max(tonumber(Decimals) or 0, 0)
        local Scaled = Number * Multiplier
        local Rounded = Scaled >= 0 and math.floor(Scaled + 0.5) or math.ceil(Scaled - 0.5)
        return Rounded / Multiplier
    end

    Library.GetConfig = function(Self)
        local Config = { }

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if tostring(Index):sub(1, 5) == "Theme" then
                    continue
                end

                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        if not Success then
            warn("Failed to get config:\n"..Result)
            return
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            local ApplyFlag = function(Index, Value)
                if tostring(Index):sub(1, 5) == "Theme" then
                    return
                end

                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    return
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end

            for Index, Value in Decoded do
                ApplyFlag(Index, Value)
            end
        end)

        return Success, Result
    end

    Library.GetConfigsList = function(Self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Directory .. Library.Folders.Configs)

        for Index = 1, #List do 
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.GetTheme = function(Self)
        local ThemeConfig = { }

        local Success, Result = Library:SafeCall(function()
            for Index, Color in Library.Theme do
                local Flag = Flags["Theme" .. Index]

                if type(Flag) == "table" and Flag.HexValue then
                    ThemeConfig["Theme" .. Index] = {
                        Color = "#" .. Flag.HexValue,
                        Alpha = Flag.Alpha or 0
                    }
                else
                    ThemeConfig["Theme" .. Index] = {
                        Color = "#" .. Color:ToHex(),
                        Alpha = 0
                    }
                end
            end
        end)

        if not Success then
            warn("Failed to get theme:\n" .. Result)
            return
        end

        return HttpService:JSONEncode(ThemeConfig)
    end

    Library.LoadTheme = function(Self, Theme)
        local Decoded = HttpService:JSONDecode(Theme)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    local ThemeKey = tostring(Index):gsub("^Theme", "")
""
                    if Library.Theme[ThemeKey] ~= nil then
                        local Color = Value

                        if type(Value) == "table" and Value.Color then
                            Color = Value.Color
                        end

                        if type(Color) == "string" then
                            Color = Color3.fromHex(Color)
                        end

                        Library:ChangeTheme(ThemeKey, Color)

                        local ThemeSet = SetFlags["Theme" .. ThemeKey]

                        if ThemeSet then
                            ThemeSet(Color, type(Value) == "table" and Value.Alpha or 0)
                        end
                    end

                    continue
                end

                if type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                elseif typeof(Value) == "Color3" or type(Value) == "string" then
                    SetFunction(Value, 0)
                end
            end
        end)

        return Success, Result
    end

    Library.GetThemesList = function(Self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Directory .. Library.Folders.Themes)

        for Index = 1, #List do 
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.AddToTheme = function(Self, Properties)
        local Object = Self.Instance

        local ThemeData = {
            Item = Object,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if not Library.Theme[Value] then
                    Object[Property] = Value 
                end

                Object[Property] = Library.Theme[Value]
            else
                Object[Property] = Value()
            end
        end

        table.insert(Library.ThemingStuff, ThemeData)
        Library.ThemeMap[Object] = ThemeData
        return Self
    end

    Library.ChangeItemTheme = function(Self, Properties)
        local Object = Self.Instance

        if not Library.ThemeMap[Object] then 
            return
        end

        Library.ThemeMap[Object].Properties = Properties
        Library.ThemeMap[Object] = Library.ThemeMap[Object]
    end

    Library.ChangeTheme = function(Self, Theme, Color)
        Library.Theme[Theme] = Color

        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end

        if Theme == "Accent" then
            Library:ChangeRichTextTheme()
        end
    end

    Library.ApplyTheme = function(Self, Name)
        local ThemeData = Themes[Name]

        if not ThemeData then
            return false
        end

        for Index, Color in ThemeData do
            Library:ChangeTheme(Index, Color)

            local SetFunction = SetFlags["Theme" .. Index]

            if SetFunction then
                SetFunction(Color, 0)
            end
        end

        return true
    end

    Library.GetAutoload = function(Self)
        local Path = Library.Directory .. "/autoload.json"

        if not isfile(Path) then
            return ""
        end

        return readfile(Path) or ""
    end

    Library.SetAutoload = function(Self, Name)
        writefile(Library.Directory .. "/autoload.json", tostring(Name or ""))
    end

    Library.LoadAutoload = function(Self)
        local AutoloadName = Library:GetAutoload()

        if not AutoloadName or AutoloadName == "" then
            return false, "none"
        end

        local ConfigPath = Library.Directory .. Library.Folders.Configs .. "/" .. AutoloadName .. ".json"

        if not isfile(ConfigPath) then
            return false, "missing"
        end

        local Success, Error = Library:LoadConfig(readfile(ConfigPath))

        if Success then
            return true, AutoloadName
        end

        return false, Error
    end

    Library.OnHover = function(Self, OnHoverEnter, OnHoverLeave)
        local Object = Self.Instance

        if not Object then 
            return 
        end 

        Library:Connect(Object.MouseEnter, OnHoverEnter)
        Library:Connect(Object.MouseLeave, OnHoverLeave)
    end

    local RichTextMap = { }

    Library.AddToRichTextTheme = function(Self, Theme, OriginalText, RealOriginalText)
        if RichTextMap[Self.Instance] then
            return 
        end

        RichTextMap[Self.Instance] = {Theme, OriginalText, RealOriginalText}
    end

    Library.UpdateRichTextTheme = function(Self, Theme, OriginalText, RealOriginalText)
        if not RichTextMap[Self.Instance] then
            return
        end

        RichTextMap[Self.Instance] = {Theme, OriginalText, RealOriginalText}
    end

    Library.ChangeRichTextTheme = function(Self)
        for Index, Value in RichTextMap do
            local Theme = Value[1]
            local OriginalText = Value[2]

            if not Library.Theme[Theme] then
                continue
            end

            local ThemeColor = Library.Theme[Theme]
            local Red, Green, Blue = math.floor(ThemeColor.R * 255), math.floor(ThemeColor.G * 255), math.floor(ThemeColor.B * 255)

            Index.Text = tostring(Value[3]) .. '<font color="rgb(' .. Red .. ',' .. Green .. ',' .. Blue .. ')">' .. tostring(OriginalText) .. '</font>'
        end
    end

    Library.ExtractRichTextContent = function(Self, Str)
        local Content = string.match(Str, "<font.-%>(.-)</font>")
        return Content
    end

    Library.Holder = Library:Create("ScreenGui", {
        Parent = gethui(),
        IgnoreGuiInset = true,
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        Enabled = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library.NotifHolder = Library:Create("Frame", {
        Name = "\0",
        Parent = Library.Holder.Instance,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0
    })

    Library.NotificationPadding = 10
    Library.NotificationOrigin = Vector2.new(10, 10)
    Library.NotificationSlide = 28
    Library.NotificationStackInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    Library.RefreshNotifications = function(IgnoreNotif)
        local Y = Library.NotificationOrigin.Y

        for _, Notif in Library.Notifications do
            if Notif.Removing then
                continue
            end

            local Height = Notif.Height or 30
            local Target = UDim2.new(1, -Library.NotificationOrigin.X, 1, -Y)
            Notif.TargetPosition = Target

            if Notif ~= IgnoreNotif and Notif.Items and Notif.Items["Notification"] then
                Notif.Items["Notification"]:Tween({Position = Target}, Library.NotificationStackInfo)
            end

            Y += Height + Library.NotificationPadding
        end
    end

    do
        Library.CreateColorpicker = function(Self, Data)
            local Colorpicker = {
                Hue = 0,
                Saturation = 0,
                Value = 0,

                Alpha = 0,

                Color = Color3.fromRGB(255, 255, 255),
                HexValue = "#FFFFFF",

                Flag = Data.Flag,
                IsOpen = false,

                Items = { }
            }

            local Items = { } do 
                Items["ColorpickerButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 15, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(154, 87, 255)
                })
                
                Items["ButtonCheckers"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["ColorpickerButton"].Instance,
                    ScaleType = Enum.ScaleType.Tile,
                    ImageTransparency = 0.6000000238418579,
                    TileSize = UDim2.new(0, 6, 0, 6),
                    Image = "http://www.roblox.com/asset/?id=18274452449",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0
                })
                                
                Items["ColorpickerWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1011, 0, 100),
                    Size = UDim2.new(0, 250, 0, 304),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline 2"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Outline 2'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["CurrentColor"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 8, 1, -8),
                    Size = UDim2.new(0, 18, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(154, 87, 255)
                })
                
                Items["Checkers"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["CurrentColor"].Instance,
                    ScaleType = Enum.ScaleType.Tile,
                    ImageTransparency = 0.6000000238418579,
                    TileSize = UDim2.new(0, 6, 0, 6),
                    Image = "http://www.roblox.com/asset/?id=18274452449",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0
                })
                
                Items["Hue"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 8, 0, 8),
                    Size = UDim2.new(0, 18, 0, 208),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }
                })
                
                Items["HueDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(1, 0, 0, 2),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["HueDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline 2"]
                }):AddToTheme({Color = 'Outline 2'})
                
                Items["Alpha"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 1),
                    Position = UDim2.new(1, -8, 1, -8),
                    Size = UDim2.new(1, -42, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(154, 87, 255)
                })
                
                Items["AlphaCheckers"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2.new(0, 6, 0, 6),
                    Image = "http://www.roblox.com/asset/?id=18274452449",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["AlphaCheckers"].Instance,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Items["AlphaDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    Size = UDim2.new(0, 2, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["AlphaDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline 2"]
                }):AddToTheme({Color = 'Outline 2'})
                
                Items["Palette"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 34, 0, 8),
                    Size = UDim2.new(1, -42, 0, 208),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(154, 87, 255)
                })
                
                Items["Saturation"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Saturation"].Instance,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Items["Value"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    Rotation = 90,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Items["PaletteDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(0, 4, 0, 4),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["PaletteDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline 2"]
                }):AddToTheme({Color = 'Outline 2'})

                Items["RGBOuterOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    Position = UDim2.new(0, 7, 0, 221),
                    Size = UDim2.new(1, -14, 0, 22),
                    BackgroundColor3 = Library.Theme["Outline 2"],
                    BorderSizePixel = 0
                }):AddToTheme({BackgroundColor3 = 'Outline 2'})

                Items["RGBInnerOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    Position = UDim2.new(0, 8, 0, 222),
                    Size = UDim2.new(1, -16, 0, 20),
                    BackgroundColor3 = Library.Theme["Outline"],
                    BorderSizePixel = 0
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["RGBInput"] = Library:Create("TextBox", {
                    Name = "RGBInput",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    ClearTextOnFocus = false,
                    Text = "",
                    PlaceholderText = "255, 255, 255",
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    TextColor3 = Library.Theme["Text"],
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    TextWrapped = false,
                    Position = UDim2.new(0, 9, 0, 223),
                    Size = UDim2.new(1, -18, 0, 18),
                    BackgroundColor3 = Library.Theme["Element"],
                    BorderSizePixel = 0
                }):AddToTheme({BackgroundColor3 = 'Element', TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text'})

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["RGBInput"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145))
                    }
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["RGBInput"].Instance,
                    PaddingLeft = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 5)
                })

                Items["HexOuterOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    Position = UDim2.new(0, 7, 0, 245),
                    Size = UDim2.new(1, -14, 0, 22),
                    BackgroundColor3 = Library.Theme["Outline 2"],
                    BorderSizePixel = 0
                }):AddToTheme({BackgroundColor3 = 'Outline 2'})

                Items["HexInnerOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    Position = UDim2.new(0, 8, 0, 246),
                    Size = UDim2.new(1, -16, 0, 20),
                    BackgroundColor3 = Library.Theme["Outline"],
                    BorderSizePixel = 0
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["HexInput"] = Library:Create("TextBox", {
                    Name = "HexInput",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    ClearTextOnFocus = false,
                    Text = "",
                    PlaceholderText = "#FFFFFF",
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    TextColor3 = Library.Theme["Text"],
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    TextWrapped = false,
                    Position = UDim2.new(0, 9, 0, 247),
                    Size = UDim2.new(1, -18, 0, 18),
                    BackgroundColor3 = Library.Theme["Element"],
                    BorderSizePixel = 0
                }):AddToTheme({BackgroundColor3 = 'Element', TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text'})

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["HexInput"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145))
                    }
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["HexInput"].Instance,
                    PaddingLeft = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 5)
                })

                Colorpicker.Items = Items
            end

            Colorpicker.Holder = Items["ColorpickerWindow"]

            function Colorpicker:SetVisibility(Bool)
                Items["ColorpickerButton"].Instance.Visible = Bool
            end

            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = Color3.fromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()
                local Red = math.floor(Colorpicker.Color.R * 255 + 0.5)
                local Green = math.floor(Colorpicker.Color.G * 255 + 0.5)
                local Blue = math.floor(Colorpicker.Color.B * 255 + 0.5)

                if Items["RGBInput"] then
                    Items["RGBInput"].Instance.Text = string.format("%d, %d, %d", Red, Green, Blue)
                end

                if Items["HexInput"] then
                    Items["HexInput"].Instance.Text = "#" .. Colorpicker.HexValue
                end
        
                Items["ColorpickerButton"]:Tween({BackgroundColor3 = Colorpicker.Color})
                Items["Palette"]:Tween({BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)})
                Items["CurrentColor"]:Tween({BackgroundColor3 = Colorpicker.Color})

                Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue,
                    Transparency = 1 - Colorpicker.Alpha
                }
    
                if not IsFromAlpha then 
                    Items["Alpha"]:Tween({BackgroundColor3 = Colorpicker.Color})
                end
    
                Items["Checkers"]:Tween({ImageTransparency = 1 - Colorpicker.Alpha})
                Items["ButtonCheckers"]:Tween({ImageTransparency = 1 - Colorpicker.Alpha})

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local Debounce = false 
            local ColorpickerWindow = Items["ColorpickerWindow"].Instance
            local ColorpickerButton = Items["ColorpickerButton"].Instance

            local IsSettings = Data.Section and Data.Section.IsSettings

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Colorpicker.IsOpen = Bool

                Debounce = true 
                
                if Colorpicker.IsOpen then 
                    ColorpickerWindow.Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + GuiInset)

                    ColorpickerWindow.Parent = Library.Holder.Instance
                    ColorpickerWindow.Visible = true
                    Items["ColorpickerWindow"]:Tween({Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + 10 + GuiInset)})
                    
                    Items["ColorpickerWindow"]:FadeDescendants(true, function()
                        Debounce = false
                    end)

                    for Index, Value in Library.OpenFrames do
                        if Value ~= IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Colorpicker] = Colorpicker 
                else
                    Items["ColorpickerWindow"]:Tween({Position = UDim2.new(0, ColorpickerButton.AbsolutePosition.X, 0, ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["ColorpickerWindow"]:FadeDescendants(false, function()
                        ColorpickerWindow.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                    end)

                    if Library.OpenFrames[Colorpicker] then 
                        Library.OpenFrames[Colorpicker] = nil
                    end
                end

                local Descendants = ColorpickerWindow:GetDescendants()
                table.insert(Descendants, ColorpickerWindow)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow + 4 or 1
                    else
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow or 1
                    end
                end
            end
    
            local DraggerPlacement = function(X, Y)
                return {
                    AnchorPoint = Vector2.new(X or 0, Y or 0),
                    Position = UDim2.new(X or 0, X and 1 - 2 * X or 0, Y or 0, Y and 1 - 2 * Y or 0)
                }
            end

            local SlidingPalette = false
            local PaletteChanged
            
            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end
    
                local ValueX = math.clamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = math.clamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY
    
                local SlideX = math.clamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local SlideY = math.clamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

                Items["PaletteDragger"]:Tween(DraggerPlacement(SlideX, SlideY), TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end
            
            local SlidingHue = false
            local HueChanged
    
            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end
                
                local ValueY = math.clamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Hue = ValueY
    
                local SlideY = math.clamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

                Items["HueDragger"]:Tween(DraggerPlacement(nil, SlideY), TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end
    
            local SlidingAlpha = false 
            local AlphaChanged
    
            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end
    
                local ValueX = math.clamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)
    
                Colorpicker.Alpha = ValueX
    
                local SlideX = math.clamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)

                Items["AlphaDragger"]:Tween(DraggerPlacement(SlideX, nil), TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update(true)
            end
    
            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "table" then
                    Color = Color3.fromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "string" then
                    Color = Color3.fromHex(Color)
                else
                    Color = Color -- lul
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0  
    
                local PaletteValueX = math.clamp(1 - Colorpicker.Saturation, 0, 1)
                local PaletteValueY = math.clamp(1 - Colorpicker.Value, 0, 1)

                local AlphaPositionX = math.clamp(Colorpicker.Alpha, 0, 1)

                local HuePositionY = math.clamp(Colorpicker.Hue, 0, 1)

                Items["PaletteDragger"]:Tween(DraggerPlacement(PaletteValueX, PaletteValueY), TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["HueDragger"]:Tween(DraggerPlacement(nil, HuePositionY), TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["AlphaDragger"]:Tween(DraggerPlacement(AlphaPositionX, nil), TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end

            local function ApplyRGBInput()
                local Text = Items["RGBInput"].Instance.Text
                local Red, Green, Blue = Text:match("^%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*$")
                Red, Green, Blue = tonumber(Red), tonumber(Green), tonumber(Blue)

                if not Red or not Green or not Blue or Red > 255 or Green > 255 or Blue > 255 then
                    Colorpicker:Update()
                    return
                end

                Colorpicker:Set(Color3.fromRGB(Red, Green, Blue), Colorpicker.Alpha)
            end

            local function ApplyHexInput()
                local Hex = Items["HexInput"].Instance.Text:gsub("^%s*#", ""):gsub("%s*$", "")

                if #Hex ~= 6 or not Hex:match("^%x%x%x%x%x%x$") then
                    Colorpicker:Update()
                    return
                end

                Colorpicker:Set(Color3.fromHex(Hex), Colorpicker.Alpha)
            end

            Items["RGBInput"]:Connect("FocusLost", ApplyRGBInput)
            Items["HexInput"]:Connect("FocusLost", ApplyHexInput)

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()

                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)

            Items["Palette"]:Connect("InputBegan", function(Input)

                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingPalette = true 
    
                    Colorpicker:SlidePalette(Input)
    
                    if PaletteChanged then
                        return
                    end
    
                    PaletteChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingPalette = false
    
                            PaletteChanged:Disconnect()
                            PaletteChanged = nil
                        end
                    end)
                end
            end)
    
            Items["Hue"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingHue = true 
    
                    Colorpicker:SlideHue(Input)
    
                    if HueChanged then
                        return
                    end
    
                    HueChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false
    
                            HueChanged:Disconnect()
                            HueChanged = nil
                        end
                    end)
                end
            end)
    
            Items["Alpha"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingAlpha = true 
    
                    Colorpicker:SlideAlpha(Input)
    
                    if AlphaChanged then
                        return
                    end
    
                    AlphaChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingAlpha = false
    
                            AlphaChanged:Disconnect()
                            AlphaChanged = nil
                        end
                    end)
                end
            end)
    
            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if SlidingPalette then 
                        Colorpicker:SlidePalette(Input)
                    end
    
                    if SlidingHue then
                        Colorpicker:SlideHue(Input)
                    end
    
                    if SlidingAlpha then
                        Colorpicker:SlideAlpha(Input)
                    end
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Colorpicker.IsOpen then
                        if Items["ColorpickerWindow"]:IsMouseOverFrame() then 
                            return 
                        end

                        Colorpicker:SetOpen(false)
                    end
                end
            end)

            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha)
            end
    
            SetFlags[Colorpicker.Flag] = function(Value, Alpha)
                Colorpicker:Set(Value, Alpha)
            end

            return Colorpicker, Items 
        end

        Library.CreateKeybind = function(Self, Data)
            local Keybind = {
                Flag = Data.Flag,
                IsOpen = false,

                Key = "",
                Mode = "",
                Value = "",

                Toggled = false,
                Picking = false,

                Items = { },
            }

            local Items = { } do
                Items["KeyButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.BoldFont,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "Toggle: B",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                                
                Items["KeybindWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 220, 0, 0),
                    Position = UDim2.new(0, 1036, 0, 100),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline 2"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Outline 2'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
                
                Keybind.Items = Items
            end

            Keybind.Holder = Items["KeybindWindow"]

            local Debounce = false
            local KeybindWindow = Items["KeybindWindow"].Instance
            local KeyButton = Items["KeyButton"].Instance

            local IsSettings = Data.Section and Data.Section.IsSettings

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Keybind.IsOpen = Bool

                Debounce = true 
                
                if Keybind.IsOpen then 
                    KeybindWindow.Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + GuiInset)

                    KeybindWindow.Parent = Library.Holder.Instance
                    Items["KeybindWindow"]:Tween({Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + 10 + GuiInset)})
                    
                    Items["KeybindWindow"]:FadeDescendants(true, function()
                        Debounce = false 
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind 
                else
                    Items["KeybindWindow"]:Tween({Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0, KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["KeybindWindow"]:FadeDescendants(false, function()
                        Items["KeybindWindow"].Instance.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                    end)

                    if Library.OpenFrames[Keybind] then 
                        Library.OpenFrames[Keybind] = nil
                    end
                end

                local Descendants = KeybindWindow:GetDescendants()
                table.insert(Descendants, KeybindWindow)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then 
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow or 1
                    else
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow + 1 or 1
                    end
                end
            end
    
            function Keybind:SetMode()
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end

            local KeybindObject

            if Library.KeyList then
                KeybindObject = Library.KeyList:Add("", "")
            end

            local Update = function()
                if KeybindObject then
                    KeybindObject:Set(Data.Name, Keybind.Value, Keybind.Mode)
                    KeybindObject:SetStatus(Keybind.Toggled)
                end
            end

            local ModeDropdown = Library:Dropdown({
                Name = "Mode",
                Flag = Keybind.Flag .. "ModeDropdown",
                Parent = Items["KeybindWindow"],
                Items = { "Toggle", "Hold", "Always" },
                Default = "Toggle",
                Callback = function(Value)
                    Keybind.Mode = Value

                    Keybind:SetMode()

                    if Value == "Always" then 
                        Keybind:Press(true)
                    end

                    Items["KeyButton"].Instance.Text = Keybind.Mode .. ": " .. Keybind.Value
                    Update()
                end
            })

            local ShowInKeybindsList = Library:Toggle({
                Name = "Show In Keybinds List",
                Flag = Keybind.Flag .. "ShowInKeybindsList",
                Parent = Items["KeybindWindow"],
                Default = KeybindObject ~= nil,
                Callback = function(Value)
                    if KeybindObject then
                        KeybindObject:SetVis(Value)
                    end
                end
            })
    
            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then 
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then 
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then 
                    Keybind.Toggled = true
                end
    
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end
    
            function Keybind:Set(Key)
                if string.find(tostring(Key), "Enum") then 
                    Keybind.Key = tostring(Key)
    
                    Key = Key.Name == "Backspace" and "None" or Key.Name
    
                    local KeyString = Keys[Keybind.Key] or string.gsub(Key, "Enum.", "") or "None"
                    local TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"
    
                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = Keybind.Mode .. ": " .. TextToDisplay
    
                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                    Keybind.Key = tostring(Key.Key)
    
                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode(Key.Mode)
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode("Toggle")
                    end
    
                    local KeyString = Keys[Keybind.Key] or string.gsub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"
    
                    TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "")
    
                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = Keybind.Mode .. ": " .. TextToDisplay
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif table.find({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode(Key)
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                end

                Keybind.Picking = false
            end
    
            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind.Picking = true 
    
                Items["KeyButton"].Instance.Text = ". . ."
    
                local InputBegan
                InputBegan = UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Keyboard then 
                        Keybind:Set(Input.KeyCode)
                    else
                        Keybind:Set(Input.UserInputType)
                    end
    
                    InputBegan:Disconnect()
                    InputBegan = nil
                end)
            end)
    
            Library:Connect(UserInputService.InputBegan, function(Input, GPE)
                if Keybind.Value == "None" then
                    return
                end
    
                if not GPE then
                    if tostring(Input.KeyCode) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then 
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then 
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then 
                            Keybind:Press(true)
                        end
                    elseif tostring(Input.UserInputType) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then 
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then 
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then 
                            Keybind:Press(true)
                        end
                    end
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                    if Keybind.IsOpen then 
                        if not Items["KeybindWindow"]:IsMouseOverFrame() and not ModeDropdown.Items.OptionHolder:IsMouseOverFrame() then 
                            Keybind:SetOpen(false)
                        end
                    end
                end
            end)
    
            Library:Connect(UserInputService.InputEnded, function(Input, GPE)
                if GPE then
                    return
                end

                if Keybind.Value == "None" then
                    return
                end
    
                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end
            end)
    
            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)
    
            if Data.Default then 
                Keybind:Set({
                    Mode = Data.Mode or "Toggle",
                    Key = Data.Default,
                })
            end
    
            SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items 
        end

        Library.Watermark = function(Self, Params)
            Params = Params or { }

            local Watermark = {
                Name = Params.Name or Params.name or "Watermark",
                SubName = Params.SubName or Params.subname or "for diddy",

                Items = { }
            }

            local Items = { } do
                Items["Watermark"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -10, 0, 10),
                    Size = UDim2.new(0, 0, 0, 25),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Items["Watermark"]:MakeDraggable()
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline 2"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Outline 2'})
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    PaddingTop = UDim.new(0, 6),
                    PaddingBottom = UDim.new(0, 6),
                    PaddingRight = UDim.new(0, 6),
                    PaddingLeft = UDim.new(0, 6)
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.BoldFont,
                    TextSize = Library.FontSize,
                    Parent = Items["Watermark"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Watermark.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -2, 0, 0),
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["SubText"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Watermark"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Watermark.SubName,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -2, 0, 0),
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})

                Watermark.Items = Items 
            end
            
            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool
            end

            function Watermark:SetText(Text)
                Items["Text"].Instance.Text = Text
            end

            function Watermark:SetSubText(Text)
                Items["SubText"].Instance.Text = Text
            end

            function Watermark:Center()
                local AbsPos = Items["Watermark"].Instance.AbsolutePosition
                task.wait()
                Items["Watermark"].Instance.AnchorPoint = Vector2.new(0, 0)
                Items["Watermark"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            Watermark:Center()

            Library.WatermarkObject = Watermark
            Self.WatermarkObject = Watermark

            return setmetatable(Watermark, Library)
        end

        Library.KeybindList = function(Self, Params)
            Params = Params or { }

            local KeybindList = {
                Name = Params.Name or Params.name or "Keybind List",

                Items = { }
            }

            Library.KeyList = KeybindList

            local Items = { } do 
                Items["KeybindList"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 20, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Size = UDim2.new(0, 120, 0, 0),
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Items["KeybindList"]:MakeDraggable()
                
                Items["UIStroke"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["UIStroke"].Instance,
                    Rotation = 90,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 0.637499988079071)
                }
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline 2"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Outline 2'})
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.BoldFont,
                    TextSize = Library.FontSize,
                    Parent = Items["KeybindList"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = KeybindList.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -2, 0, 0),
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })
                
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 20),
                    Size = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                KeybindList.Items = Items 
                KeybindList.Keys = { }
            end

            local KeybindTweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

            local RowHeight = 15
            local RowGap = 4

            local RowSlot = RowHeight + RowGap
            local SlideOffset = 10
            local ListPaddingX = 20
            
            local MinListWidth = 80

            function KeybindList:RefreshWidth()
                Library:Thread(function()
                    if not Items["KeybindList"] or not Items["KeybindList"].Instance then
                        return
                    end

                    local Width = Items["Text"].Instance.TextBounds.X

                    for _, Entry in KeybindList.Keys do
                        if Entry.Active and Entry.CanBeVisible then
                            Width = math.max(Width, Entry:GetWidth())
                        end
                    end

                    Width = math.max(math.ceil(Width) + ListPaddingX, MinListWidth)
                    Items["KeybindList"]:Tween({Size = UDim2.new(0, Width, 0, 0)}, KeybindTweenInfo)
                end)
            end

            function KeybindList:SetVisibility(Bool)
                Items["KeybindList"].Instance.Visible = Bool
            end

            function KeybindList:SetText(Text)
                Items["Text"].Instance.Text = Text
                KeybindList:RefreshWidth()
            end

            function KeybindList:Center()
                local AbsPos = Items["KeybindList"].Instance.AbsolutePosition
                task.wait()
                Items["KeybindList"].Instance.AnchorPoint = Vector2.new(0, 0)
                Items["KeybindList"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            KeybindList:Center()
            KeybindList:RefreshWidth()

            function KeybindList:Add(Name, Key, Mode)
                local NewKey = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    Size = UDim2.new(1, 0, 0, 0),
                    Visible = false,
                    BorderSizePixel = 0
                })
                
                local NewAccent = Library:Create("Frame", {
                    Name = "\0",
                    Parent = NewKey.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 2, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})

                local FormatKeybindText = function(BindName, BindKey, BindMode)
                    return string.format("%s - %s (%s)", tostring(BindName or ""), tostring(BindKey or "None"), tostring(BindMode or "Toggle"))
                end
                
                local NewText = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = NewKey.Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = FormatKeybindText(Name, Key, Mode),
                    Size = UDim2.new(0, 0, 0, RowHeight),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    Position = UDim2.new(0, 10 - SlideOffset, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})             

                local Entry = {
                    Instance = NewKey.Instance,
                    Active = false,
                    CanBeVisible = true,
                }

                function Entry:GetWidth()
                    return 10 + NewText.Instance.TextBounds.X
                end

                function Entry:SetVis(Bool)
                    Entry.CanBeVisible = Bool

                    if not Bool then
                        Entry:SetStatus(false)
                    end
                end

                function Entry:Set(Name, Key, Mode)
                    NewText.Instance.Text = FormatKeybindText(Name, Key, Mode)
                    KeybindList:RefreshWidth()
                end

                function Entry:SetStatus(Bool)
                    if not Entry.CanBeVisible then
                        Bool = false
                    end

                    if Entry.Active == Bool then
                        return
                    end

                    Entry.Active = Bool
                    
                    if Bool then 
                        NewKey.Instance.Visible = true
                        NewKey:Tween({Size = UDim2.new(1, 0, 0, RowSlot)}, KeybindTweenInfo)
                        NewAccent:Tween({BackgroundTransparency = 0, Size = UDim2.new(0, 2, 0, RowHeight - 4)}, KeybindTweenInfo)
                        NewText:Tween({TextTransparency = 0, Position = UDim2.new(0, 10, 0, 1)}, KeybindTweenInfo)
                    else
                        NewKey:Tween({Size = UDim2.new(1, 0, 0, 0)}, KeybindTweenInfo)
                        NewAccent:Tween({BackgroundTransparency = 1, Size = UDim2.new(0, 2, 0, 0)}, KeybindTweenInfo)
                        NewText:Tween({TextTransparency = 1, Position = UDim2.new(0, 10 - SlideOffset, 0, 1)}, KeybindTweenInfo)

                        task.delay(KeybindTweenInfo.Time, function()
                            if not Entry.Active and NewKey.Instance and NewKey.Instance.Parent then
                                NewKey.Instance.Visible = false
                            end
                        end)
                    end

                    KeybindList:RefreshWidth()
                end

                setmetatable(Entry, {
                    __index = function(_, Key)
                        return NewKey[Key]
                    end
                })

                table.insert(KeybindList.Keys, Entry)
                return Entry 
            end

            return setmetatable(KeybindList, Library)
        end

        local AnimInfo = TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
        local FadeInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

        Library.Notification = function(Self, Name, Duration, Color)
            Name = Name or "Notification"
            Duration = Duration or 3
            Color = Color or Library.Theme.Accent

            local Notification = {
                Removing = false,
                Height = 30,
                Width = 0,
                TargetPosition = UDim2.new(1, -Library.NotificationOrigin.X, 1, -Library.NotificationOrigin.Y),
                Items = { }
            }

            local Slide = Library.NotificationSlide

            local Items = { } do 
                Items["Notification"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.NotifHolder.Instance,
                    AnchorPoint = Vector2.new(1, 1),
                    Position = UDim2.new(1, -Library.NotificationOrigin.X + Slide, 1, -Library.NotificationOrigin.Y),
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = Library.Theme["Inline"],
                    ZIndex = 100
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Items["Stroke2"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["Stroke"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline 2"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Outline 2'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    PaddingTop = UDim.new(0, 6),
                    PaddingBottom = UDim.new(0, 6),
                    PaddingRight = UDim.new(0, 6),
                    PaddingLeft = UDim.new(0, 6)
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Notification"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    ZIndex = 101
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    Position = UDim2.new(1, -1, 0, 25),
                    AnchorPoint = Vector2.new(1, 0),
                    Size = UDim2.new(1, -2, 0, 3),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color,
                    ZIndex = 101
                })         
            end

            Notification.Items = Items

            for _, Value in Items do 
                if Value.Instance:IsA("Frame") then
                    Value.Instance.BackgroundTransparency = 1
                elseif Value.Instance:IsA("TextLabel") then 
                    Value.Instance.TextTransparency = 1
                elseif Value.Instance:IsA("UIStroke") then 
                    Value.Instance.Transparency = 1
                end
            end

            table.insert(Library.Notifications, 1, Notification)
            task.wait()

            local FullSize = Items["Notification"].Instance.AbsoluteSize

            if FullSize.X <= 0 or FullSize.Y <= 0 then
                FullSize = Vector2.new(math.max(FullSize.X, 120), math.max(FullSize.Y, 30))
            end

            Notification.Height = FullSize.Y
            Notification.Width = FullSize.X
            Notification.FullSize = FullSize

            Library:RefreshNotifications(Notification)

            local Target = Notification.TargetPosition
            local Frame = Items["Notification"].Instance

            Frame.AutomaticSize = Enum.AutomaticSize.None
            Frame.Size = UDim2.new(0, FullSize.X, 0, FullSize.Y)
            Frame.Position = UDim2.new(1, Target.X.Offset + Slide, 1, Target.Y.Offset)

            Library:Thread(function()
                for _, Value in Items do 
                    if Value.Instance:IsA("Frame") then
                        Value:Tween({BackgroundTransparency = 0}, FadeInfo)
                    elseif Value.Instance:IsA("TextLabel") then 
                        Value:Tween({TextTransparency = 0}, FadeInfo)
                    elseif Value.Instance:IsA("UIStroke") then 
                        Value:Tween({Transparency = 0}, FadeInfo)
                    end
                end

                Items["Notification"]:Tween({Position = Target}, AnimInfo)
                Items["Liner"].Instance.Size = UDim2.new(1, -2, 0, 3)
                Items["Liner"]:Tween({Size = UDim2.new(0, 0, 0, 3)}, TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out))

                task.delay(Duration + 0.05, function()
                    if Notification.Removing then
                        return
                    end

                    Notification.Removing = true
                    Library:RefreshNotifications()

                    for _, Value in Items do 
                        if not Value.Instance or not Value.Instance.Parent then
                            continue
                        end

                        if Value.Instance:IsA("Frame") then
                            Value:Tween({BackgroundTransparency = 1}, FadeInfo)
                        elseif Value.Instance:IsA("TextLabel") then 
                            Value:Tween({TextTransparency = 1}, FadeInfo)
                        elseif Value.Instance:IsA("UIStroke") then 
                            Value:Tween({Transparency = 1}, FadeInfo)
                        end
                    end

                    local Current = Items["Notification"].Instance.Position
                    Items["Notification"]:Tween({Position = UDim2.new(1, Current.X.Offset + Slide, 1, Current.Y.Offset), Size = UDim2.new(0, FullSize.X, 0, 0)}, AnimInfo)

                    task.wait(AnimInfo.Time)

                    local Index = table.find(Library.Notifications, Notification)

                    if Index then
                        table.remove(Library.Notifications, Index)
                    end

                    if Items["Notification"].Instance then
                        Items["Notification"].Instance:Destroy()
                    end

                    Library:RefreshNotifications()
                end)
            end)

            return Notification
        end

        Library.Tooltip = function(Self, Text)
            local Object = Self.Instance

            if not Object then 
                return 
            end
    
            if Text == "" then 
                return 
            end
    
            if Text == nil then
                return
            end

            local Items = { } do 
                Items["Tooltip"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Size = UDim2.new(0, 0, 0, 22),
                    ClipsDescendants = true,
                    Position = UDim2.new(0, 1009, 0, 234),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Items["Stroke2"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Tooltip"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["Stroke"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Tooltip"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline 2"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Outline 2'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Tooltip"].Instance,
                    PaddingRight = UDim.new(0, 6),
                    PaddingLeft = UDim.new(0, 6)
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Tooltip"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Text,
                    Size = UDim2.new(0, 0, 0, 15),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 4, 0.5, -1),
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Tooltip"].Instance,
                    Position = UDim2.new(0, -6, 0, 0),
                    Size = UDim2.new(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})                
            end

            local GetSize = function()
                local AbsSize = Items["Tooltip"].Instance.AbsoluteSize
                Items["Tooltip"].Instance.AutomaticSize = Enum.AutomaticSize.None
                task.wait()
                Items["Tooltip"].Instance.Size = UDim2.new(0, AbsSize.X, 0, AbsSize.Y)
                return AbsSize
            end
    
            local TweenDescendants = function(Bool)
                for Index, Value in Items do 
                    if Value.Instance:IsA("UIStroke") then
                        Value:Tween({Transparency = Bool and 1 or 0})
                    elseif Value.Instance:IsA("Frame") then
                        Value:Tween({BackgroundTransparency = Bool and 1 or 0})
                    elseif Value.Instance:IsA("TextLabel") then
                        Value:Tween({TextTransparency = Bool and 1 or 0})
                    end
                end
            end
    
            TweenDescendants(true)
    
            local Size = GetSize()
            Items["Tooltip"].Instance.Size = UDim2.new(0, 0, 0, Size.Y)
    
            local RenderStepped 
            
            Self:OnHover(function()
                local MouseLocation = UserInputService:GetMouseLocation()
                Items["Tooltip"].Instance.Position = UDim2.new(0, MouseLocation.X + 20, 0, MouseLocation.Y + 20)
    
                Items["Tooltip"]:Tween({Size = UDim2.new(0, Size.X, 0, Size.Y)})
                TweenDescendants(false)
    
                RenderStepped = RunService.RenderStepped:Connect(function()
                    MouseLocation = UserInputService:GetMouseLocation()
                    Items["Tooltip"].Instance.Position = UDim2.new(0, MouseLocation.X + 20, 0, MouseLocation.Y + 20)
                end)
            end, function()
                Items["Tooltip"]:Tween({Size = UDim2.new(0, 0, 0, Size.Y)})
                TweenDescendants(true)
    
                RenderStepped:Disconnect()
                RenderStepped = nil
            end)
        end

        Library.Window = function(Self, Params)
            Params = Params or { }

            local Window = {
                Name = Params.Name or Params.name or "Window",

                IsOpen = true,
                Pages = { },
                Items = { }
            }

            local Items = { } do 
                if IsMobile then 
                    Library:Create("UIScale", {
                        Parent = Items["MainFrame"],
                        Scale = 0.7
                    })
                end

                Items["MainFrame"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 564, 0, 592),
                    BorderSizePixel = 2,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2.new(Items["MainFrame"].Instance.AbsoluteSize.X, Items["MainFrame"].Instance.AbsoluteSize.Y))
                
                Items["UIStroke"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["UIStroke"].Instance,
                    Rotation = 90,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 0.637499988079071)
                }
                })
                
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Position = UDim2.new(0, 8, 0, 30),
                    Size = UDim2.new(1, -16, 1, -75),
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})  
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline 2"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Outline 2'})
                
                Items["Pages"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 1, -8),
                    Size = UDim2.new(1, -16, 0, 30),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.BoldFont,
                    TextSize = Library.FontSize,
                    Parent = Items["MainFrame"].Instance,
                    TextWrapped = true,
                    TextColor3 = Library.Theme["Text"],
                    Text = Window.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    AnchorPoint = Vector2.new(0.5, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 6),
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})       
                
                Items["CurrentPath"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Content"].Instance,
                    TextWrapped = true,
                    TextColor3 = Library.Theme["Text"],
                    Text = "Legitbot > Globals",
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(1, -8, 0, 6),
                    AnchorPoint = Vector2.new(1, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})      
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline 2"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Outline 2'})                                

                Window.Items = Items
            end

            local Debounce = false

            function Window:ClosePopups()
                for Index, Value in Library.OpenFrames do 
                    if Value and Value.SetOpen then
                        Value:SetOpen(false)
                    end
                end
            end

            function Window:ResetPages()
                for _, Tab in Window.Pages do
                    Tab.Debounce = false

                    if Tab.Pages then
                        for _, Sub in Tab.Pages do
                            Sub.Debounce = false

                            if Tab.Current ~= Sub and Sub.Items and Sub.Items["Page"] then
                                Sub.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                                Sub.Items["Page"].Instance.Visible = false
                                Sub.Items["Page"].Instance.Position = UDim2.new(0, 0, 0, 0)
                            end
                        end
                    end

                    if Window.Current ~= Tab and Tab.Items and Tab.Items["Page"] then
                        Tab.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                        Tab.Items["Page"].Instance.Visible = false
                        Tab.Items["Page"].Instance.Position = UDim2.new(0, 0, 0, 0)
                    end
                end

                local Current = Window.Current

                if Current and Current.Items and Current.Items["Page"] then
                    Current.Items["Page"].Instance.Parent = Items["Content"].Instance
                    Current.Items["Page"].Instance.Visible = true
                    Current.Items["Page"].Instance.Position = UDim2.new(0, 0, 0, 0)

                    local CurrentSub = Current.Current

                    if CurrentSub and CurrentSub.Items and CurrentSub.Items["Page"] then
                        CurrentSub.Items["Page"].Instance.Parent = Current.Items["Columns"].Instance
                        CurrentSub.Items["Page"].Instance.Visible = true
                        CurrentSub.Items["Page"].Instance.Position = UDim2.new(0, 0, 0, 0)
                    end
                end
            end

            function Window:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Debounce = true 

                Window.IsOpen = Bool
                Window:ClosePopups()
                Window:ResetPages()

                Items["MainFrame"]:FadeDescendants(Bool, function()
                    Debounce = false
                end)
            end

            function Window:Center()
                local AbsPos = Items["MainFrame"].Instance.AbsolutePosition
                Items["MainFrame"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["MainFrame"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    if UserInputService:GetFocusedTextBox() then
                        return
                    end

                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:Center()
            Library.WindowObject = Window
            return setmetatable(Window, Library)
        end

        Library.Page = function(Self, Params)
            Params = Params or { }

            local Page = {
                Name = Params.Name or Params.name or "Page",

                Window = Self,
                Pages = { },
                Items = { },
                Current = nil,
                Active = false,
                Debounce = false
            }

            local Items = { } do 
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Page.Window.Items["Pages"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 0.4000000059604645,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Inactive"].Instance,
                    TextWrapped = true,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Page.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, -2),
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                
                Items["Connect"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Visible = false,
                    Size = UDim2.new(1, 0, 0, 5),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Connect"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Connect"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 2),
                    Size = UDim2.new(1, 0, 0, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Connect"].Instance,
                    Position = UDim2.new(0, 0, 0, -2),
                    Size = UDim2.new(1, 0, 0, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Connect"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 2, 0, -2),
                    Size = UDim2.new(0, 2, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Connect"].Instance,
                    Position = UDim2.new(0, -1, 0, -2),
                    Size = UDim2.new(0, 1, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Connect"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, -1, 1, 2),
                    Size = UDim2.new(0, 1, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Connect"].Instance,
                    AnchorPoint = Vector2.new(1, 1),
                    Position = UDim2.new(1, 1, 1, 2),
                    Size = UDim2.new(0, 1, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline 2"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Outline 2'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})          
                
                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    Visible = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Items["SubPages"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["SubPages"].Instance,
                    PaddingTop = UDim.new(0, 12),
                    PaddingBottom = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubPages"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Columns"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 1, -25),
                    BorderSizePixel = 0,
                    ClipsDescendants = true
                })                

                Page.Items = Items
            end

            function Page:Turn()
                local Old = Page.Window.Current 

                if Old == Page then 
                    return 
                end

                if Page.Debounce then 
                    return
                end

                if Old and Old.Debounce then 
                    return 
                end

                Page.Debounce = true
                Page.Window:ClosePopups()

                local TabTween = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                local OldIndex = Old and table.find(Page.Window.Pages, Old) or 0
                local NewIndex = table.find(Page.Window.Pages, Page) or 0
                local SlideDir = NewIndex >= OldIndex and 1 or -1
                
                if Old then 
                    Library:SetPreviewFramesVisible(Old.Items["Page"].Instance, false)
                    Old.Items["Title"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
                    Old.Items["Title"]:Tween({TextColor3 = Library.Theme["Inactive Text"]}, TabTween)
                    Old.Items["Connect"].Instance.Visible = false 
                    Old.Items["Inactive"]:Tween({BackgroundTransparency = 0.4}, TabTween)

                    Old.Items["Page"]:Tween({Position = UDim2.new(0, -14 * SlideDir, 0, 0)}, TabTween)
                    Old.Items["Page"]:FadeDescendants(false, function()
                        if Page.Window.Current ~= Old and Old.Items["Page"].Instance then
                            Old.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                            Old.Items["Page"].Instance.Visible = false
                            Old.Items["Page"].Instance.Position = UDim2.new(0, 0, 0, 0)
                        end
                    end)
                end

                Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
                Items["Page"].Instance.Visible = true
                Library:SetPreviewFramesVisible(Items["Page"].Instance, true)
                Items["Page"].Instance.Position = UDim2.new(0, 18 * SlideDir, 0, 0)
                Items["Page"]:Tween({Position = UDim2.new(0, 0, 0, 0)}, TabTween)
                Items["Page"]:FadeDescendants(true, function()
                    Page.Debounce = false
                end)

                Items["Title"]:ChangeItemTheme({TextColor3 = "Text"})
                Items["Title"]:Tween({TextColor3 = Library.Theme.Text}, TabTween)
                Items["Connect"].Instance.Visible = true 
                Items["Inactive"]:Tween({BackgroundTransparency = 0}, TabTween)

                Page.Window.Current = Page

                if Page.Current then
                    Page.Window.Items["CurrentPath"].Instance.Text = Page.Name .. " > " .. Page.Current.Name

                    if Page.Current.Items and Page.Current.Items["Page"] then
                        Page.Current.Items["Page"].Instance.Parent = Items["Columns"].Instance
                        Page.Current.Items["Page"].Instance.Visible = true
                        Page.Current.Items["Page"].Instance.Position = UDim2.new(0, 0, 0, 0)
                    end
                end
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                Page:Turn()
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn()
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.SubPage = function(Self, Params)
            Params = Params or { }

            local Page = {
                Name = Params.Name or Params.name or "Page",

                Window = Self.Window,
                Page = Self,
                ColumnsData = { },
                Items = { },
                Active = false,
                Debounce = false
            }

            local Items = { } do 
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Page.Page.Items["SubPages"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Page.Name,
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                                
                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Visible = false,
                    BorderSizePixel = 0
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })
                
                Items["LeftColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 0, 100),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    Padding = UDim.new(0, 14),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    PaddingTop = UDim.new(0, 6),
                    PaddingBottom = UDim.new(0, 6),
                    PaddingRight = UDim.new(0, 6),
                    PaddingLeft = UDim.new(0, 6)
                })
                
                Items["RightColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 0, 100),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    PaddingTop = UDim.new(0, 6),
                    PaddingBottom = UDim.new(0, 6),
                    PaddingRight = UDim.new(0, 6),
                    PaddingLeft = UDim.new(0, 6)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    Padding = UDim.new(0, 14),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Page.ColumnsData[1] = Items["LeftColumn"]
                Page.ColumnsData[2] = Items["RightColumn"]

                Page.Items = Items
            end

            function Page:Turn()
                local Old = Page.Page.Current 

                if Old == Page then 
                    return 
                end

                if Page.Debounce then 
                    return
                end

                if Old and Old.Debounce then 
                    return 
                end

                Page.Debounce = true
                Page.Window:ClosePopups()

                local SubTween = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                local OldIndex = Old and table.find(Page.Page.Pages, Old) or 0
                local NewIndex = table.find(Page.Page.Pages, Page) or 0
                local SlideDir = NewIndex >= OldIndex and 1 or -1
                
                if Old then 
                    Library:SetPreviewFramesVisible(Old.Items["Page"].Instance, false)
                    Old.Items["Inactive"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
                    Old.Items["Inactive"]:Tween({TextColor3 = Library.Theme["Inactive Text"]}, SubTween)

                    Old.Items["Page"]:Tween({Position = UDim2.new(0, 0, 0, 10 * SlideDir)}, SubTween)
                    Old.Items["Page"]:FadeDescendants(false, function()
                        if Page.Page.Current ~= Old and Old.Items["Page"].Instance then
                            Old.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                            Old.Items["Page"].Instance.Visible = false
                            Old.Items["Page"].Instance.Position = UDim2.new(0, 0, 0, 0)
                        end
                    end)
                end

                Items["Page"].Instance.Parent = Page.Page.Items["Columns"].Instance
                Items["Page"].Instance.Visible = true
                Library:SetPreviewFramesVisible(Items["Page"].Instance, true)
                Items["Page"].Instance.Position = UDim2.new(0, 0, 0, -12 * SlideDir)
                Items["Page"]:Tween({Position = UDim2.new(0, 0, 0, 0)}, SubTween)
                Items["Page"]:FadeDescendants(true, function()
                    Page.Debounce = false
                end)

                Items["Inactive"]:ChangeItemTheme({TextColor3 = "Text"})
                Items["Inactive"]:Tween({TextColor3 = Library.Theme.Text}, SubTween)

                Page.Page.Current = Page
                Page.Window.Items["CurrentPath"].Instance.Text = Page.Page.Name .. " > " .. Page.Name
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                Page:Turn()
            end)

            if #Page.Page.Pages == 0 then 
                Page:Turn()
            end

            table.insert(Page.Page.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.Section = function(Self, Params)
            Params = Params or { } 

            local Section = {
                Name = Params.Name or Params.name or "Section",
                Side = Params.Side or Params.side or 1,

                Window = Self.Window,
                Page = Self,
                Items = { },
            }

            local Items = { } do 
                Items["Section"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Page.ColumnsData[Section.Side].Instance,
                    Size = UDim2.new(1, 0, 0, 35),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Section"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Section.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    AnchorPoint = Vector2.new(0.5, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    Position = UDim2.new(0.5, 8, 0, 1),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Text"].Instance,
                    PaddingRight = UDim.new(0, 5),
                    PaddingLeft = UDim.new(0, 5)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    PaddingBottom = UDim.new(0, 10)
                })
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    Position = UDim2.new(0, 8, 0, 8),
                    Size = UDim2.new(1, -16, 0, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 18),
                    Size = UDim2.new(1, -16, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Section.Items = Items
            end 

            return setmetatable(Section, Library)
        end

        Library.ESPPreview = function(Self, Params)
            Params = Params or { }

            local Preview = {
                Name = Params.Name or Params.name or "ESP Preview",
                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Zoom = Params.Zoom or 9,
                Rotation = 0,
                AutoRotate = Params.AutoRotate ~= false,
                RotationSpeed = tonumber(Params.RotationSpeed) or 0.8,
                TargetModelSize = math.max(tonumber(Params.TargetModelSize) or 5, 0.1),
                AssetId = nil,
                LoadGeneration = 0,
                Dragging = false,
                Connections = {},
                Items = {}
            }

            local Items = Preview.Items
            local Parent = Self.Items["Content"]

            Items["Container"] = Library:Create("Frame", {
                Name = "\0",
                Parent = Parent.Instance,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, Params.Height or 300),
                BorderSizePixel = 0
            })

            Items["Title"] = Library:Create("TextLabel", {
                Name = "\0",
                FontFace = Library.Font,
                TextSize = Library.FontSize,
                Parent = Items["Container"].Instance,
                TextColor3 = Library.Theme["Text"],
                Text = Preview.Name,
                Size = UDim2.new(1, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0
            }):AddToTheme({TextColor3 = 'Text'})

            Items["Viewport"] = Library:Create("ViewportFrame", {
                Name = "\0",
                Parent = Items["Container"].Instance,
                Position = UDim2.new(0, 0, 0, 19),
                Size = UDim2.new(1, 0, 1, -19),
                BackgroundColor3 = Library.Theme["Inline"],
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Active = true
            }):AddToTheme({BackgroundColor3 = 'Inline'})

            Library:Create("UIStroke", {
                Name = "\0",
                Parent = Items["Viewport"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Color = Library.Theme["Outline"]
            }):AddToTheme({Color = 'Outline'})

            Library:Create("UIStroke", {
                Name = "\0",
                Parent = Items["Viewport"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Color = Library.Theme["Outline 2"],
                BorderOffset = UDim.new(0, 1)
            }):AddToTheme({Color = 'Outline 2'})

            Items["World"] = Library:Create("WorldModel", {
                Name = "\\0",
                Parent = Items["Viewport"].Instance
            })

            Items["Camera"] = Library:Create("Camera", {
                Name = "\0",
                FieldOfView = 35,
                Parent = Items["Viewport"].Instance
            })
            Items["Viewport"].Instance.CurrentCamera = Items["Camera"].Instance
            table.insert(Library.PreviewFrames, Items["Viewport"].Instance)

            local function Bind(Signal, Callback)
                local Connection = Library:Connect(Signal, Callback)
                if Connection then
                    table.insert(Preview.Connections, Connection)
                end
                return Connection
            end

            local function ApplyCamera()
                local Camera = Items["Camera"].Instance
                Camera.CFrame = CFrame.lookAt(Vector3.new(0, 0, Preview.Zoom), Vector3.zero)
            end

            local function SetArchivable(Model, Archivable)
                local Changed = {}
                local Objects = {Model}

                for _, Object in Model:GetDescendants() do
                    table.insert(Objects, Object)
                end

                for _, Object in Objects do
                    Changed[Object] = Object.Archivable
                    Object.Archivable = Archivable
                end

                return Changed
            end

            local function RestoreArchivable(Changed)
                for Object, Archivable in Changed do
                    if Object.Parent then
                        Object.Archivable = Archivable
                    end
                end
            end

            local function ClearCharacter()
                for _, Child in Items["World"].Instance:GetChildren() do
                    Child:Destroy()
                end
                Preview.CharacterModel = nil
                Preview.BasePivot = nil
            end

            local function PrepareModel(Model, Name)
                for _, Object in Model:GetDescendants() do
                    if Object:IsA("Script") or Object:IsA("LocalScript") then
                        Object:Destroy()
                    elseif Object:IsA("BasePart") then
                        Object.Anchored = true
                        Object.CanCollide = false
                    elseif Object:IsA("Humanoid") then
                        Object.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        Object.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                    end
                end

                Model.Name = Name
                Model.Parent = Items["World"].Instance

                local Success, Bounds, Size = pcall(function()
                    local Box, Extents = Model:GetBoundingBox()
                    return Box, Extents
                end)
                if not Success or not Size then
                    return false
                end

                local LargestAxis = math.max(Size.X, Size.Y, Size.Z)
                if LargestAxis <= 0 then
                    return false
                end

                local Scale = Preview.TargetModelSize / LargestAxis
                if math.abs(Scale - 1) > 0.001 then
                    local Scaled = pcall(function()
                        Model:ScaleTo(Scale)
                    end)
                    if not Scaled then
                        return false
                    end
                end

                local BoundsSuccess, Center, ScaledSize = pcall(function()
                    local Box, Extents = Model:GetBoundingBox()
                    return Box, Extents
                end)
                if not BoundsSuccess or not ScaledSize then
                    return false
                end

                local Pivot = Model:GetPivot()
                Preview.BasePivot = CFrame.new(-Center.Position.X, -Center.Position.Y, -Center.Position.Z) * Pivot
                Preview.Zoom = math.clamp(Preview.TargetModelSize / (2 * math.tan(math.rad(Items["Camera"].Instance.FieldOfView / 2))) * 1.25, 4, 14)
                Preview.CharacterModel = Model
                Preview:SetRotation(Preview.Rotation)
                ApplyCamera()
                return true
            end

            function Preview:Refresh(Character)
                if self.Destroyed then
                    return false
                end

                self.LoadGeneration += 1
                ClearCharacter()
                Character = Character or LocalPlayer.Character
                if not Character then
                    return false
                end

                self.AssetId = nil

                local ArchivableStates = SetArchivable(Character, true)
                local Success, Model = pcall(function()
                    return Character:Clone()
                end)
                RestoreArchivable(ArchivableStates)

                if not Success or not Model then
                    warn("ESPPreview could not clone the local character")
                    return false
                end

                if not PrepareModel(Model, "LocalPlayerPreview") then
                    Model:Destroy()
                    warn("ESPPreview could not normalize the local character model")
                    return false
                end

                return true
            end

            function Preview:SetAssetId(AssetId)
                AssetId = tonumber(AssetId)
                if not AssetId or AssetId <= 0 then
                    return false
                end
                if self.Destroyed then
                    return false
                end

                self.LoadGeneration += 1
                local Generation = self.LoadGeneration
                self.AssetId = AssetId
                ClearCharacter()

                task.spawn(function()
                    local Success, Loaded = pcall(function()
                        return game:GetObjects("rbxassetid://" .. tostring(AssetId))
                    end)

                    if self.Destroyed or Generation ~= self.LoadGeneration then
                        if Success and Loaded then
                            for _, Object in Loaded do
                                Object:Destroy()
                            end
                        end
                        return
                    end

                    if not Success or type(Loaded) ~= "table" or not Loaded[1] then
                        warn("ESPPreview failed to load Roblox model asset " .. tostring(AssetId) .. "; check that the asset is public and loadable in this environment")
                        return
                    end

                    local Model
                    for _, Object in Loaded do
                        if Object:IsA("Model") then
                            Model = Object
                            break
                        end
                        Model = Object:FindFirstChildWhichIsA("Model", true)
                        if Model then
                            break
                        end
                    end

                    if not Model then
                        local Wrapper = Instance.new("Model")
                        for _, Object in Loaded do
                            Object.Parent = Wrapper
                        end
                        Model = Wrapper
                    else
                        for _, Object in Loaded do
                            if Object ~= Model and not Model:IsDescendantOf(Object) then
                                Object:Destroy()
                            end
                        end
                    end

                    local HasPart = false
                    for _, Object in Model:GetDescendants() do
                        if Object:IsA("Script") or Object:IsA("LocalScript") then
                            Object:Destroy()
                        elseif Object:IsA("BasePart") then
                            HasPart = true
                        end
                    end

                    if not HasPart then
                        for _, Object in Loaded do
                            if Object.Parent then
                                Object:Destroy()
                            end
                        end
                        warn("ESPPreview asset " .. tostring(AssetId) .. " contains no model parts")
                        return
                    end

                    if not PrepareModel(Model, "AssetPreview_" .. tostring(AssetId)) then
                        Model:Destroy()
                        warn("ESPPreview could not normalize model asset " .. tostring(AssetId))
                        return
                    end
                end)

                return true
            end

            function Preview:SetZoom(Zoom)
                self.Zoom = math.clamp(tonumber(Zoom) or self.Zoom, 4, 14)
                ApplyCamera()
            end

            function Preview:SetRotation(Rotation)
                self.Rotation = tonumber(Rotation) or self.Rotation
                if self.CharacterModel and self.BasePivot then
                    self.CharacterModel:PivotTo(CFrame.Angles(0, math.pi + self.Rotation, 0) * self.BasePivot)
                end
            end

            function Preview:SetVisibility(Visible)
                Items["Container"].Instance.Visible = Visible
            end

            function Preview:SetAutoRotate(Enabled)
                self.AutoRotate = Enabled == true
            end

            function Preview:Destroy()
                if self.Destroyed then
                    return
                end
                self.Destroyed = true
                self.LoadGeneration += 1
                self.Dragging = false
                Library.PreviewDragActive = false
                local PreviewFrameIndex = table.find(Library.PreviewFrames, Items["Viewport"].Instance)
                if PreviewFrameIndex then
                    table.remove(Library.PreviewFrames, PreviewFrameIndex)
                end

                for _, Connection in self.Connections do
                    Connection:Disconnect()
                end
                table.clear(self.Connections)
                ClearCharacter()
                Items["Container"].Instance:Destroy()
            end

            ApplyCamera()
            Preview:Refresh()

            Bind(Items["Viewport"].Instance.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Library.PreviewDragActive = true
                    Preview.Dragging = true
                    Preview.LastDragX = Input.Position.X
                    Preview.DragInputType = Input.UserInputType
                end
            end)

            Bind(UserInputService.InputChanged, function(Input)
                local IsDragMovement = Preview.DragInputType == Enum.UserInputType.Touch
                    and Input.UserInputType == Enum.UserInputType.Touch
                    or Preview.DragInputType == Enum.UserInputType.MouseButton1
                    and Input.UserInputType == Enum.UserInputType.MouseMovement

                if Preview.Dragging and IsDragMovement then
                    local DeltaX = Input.Position.X - Preview.LastDragX
                    Preview.LastDragX = Input.Position.X
                    Preview:SetRotation(Preview.Rotation + DeltaX * 0.01)
                elseif Input.UserInputType == Enum.UserInputType.MouseWheel and Library:IsMouseOverFrame(Items["Viewport"]) then
                    Preview:SetZoom(Preview.Zoom - Input.Position.Z * 0.6)
                end
            end)

            Bind(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Preview.DragInputType then
                    Preview.Dragging = false
                    Preview.DragInputType = nil
                    Library.PreviewDragActive = false
                end
            end)

            Bind(RunService.RenderStepped, function(DeltaTime)
                if Preview.AutoRotate and not Preview.Dragging and Preview.CharacterModel then
                    Preview:SetRotation(Preview.Rotation + DeltaTime * Preview.RotationSpeed)
                end
            end)

            Bind(LocalPlayer.CharacterAdded, function(Character)
                task.defer(function()
                    Character:WaitForChild("HumanoidRootPart", 5)
                    if not Preview.Destroyed and not Preview.AssetId and LocalPlayer.Character == Character then
                        Preview:Refresh(Character)
                    end
                end)
            end)

            return setmetatable(Preview, Library)
        end

        Library.Toggle = function(Self, Params)
            Params = Params or { }

            local Toggle = {
                Name = Params.Name or Params.name or "Toggle",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or false,
                Tooltip = Params.Tooltip or Params.tooltip or "",
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Toggle.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Toggle"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 15),
                    BorderSizePixel = 0
                })

                Items["Toggle"]:Tooltip(Toggle.Tooltip)
                
                Items["Indicator"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 12, 0, 12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145))
                }
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Toggle"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Toggle.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0, 18, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                
                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Items["Toggle"]:OnHover(function()
                    if Toggle.Value then return end 
                    Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()
                    if Toggle.Value then return end 
                    Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                end)
            
                Toggle.Items = Items
            end

            function Toggle:Set(Bool)
                Toggle.Value = Bool 

                if Bool then 
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                    Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme.Accent})

                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Text"]:Tween({TextColor3 = Library.Theme.Text})
                else
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                    Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme.Element})
                    
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
                    Items["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                end

                Flags[Toggle.Flag] = Bool
                Library:SafeCall(Toggle.Callback, Bool)
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            function Toggle:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0,

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Name = Data.Name or Data.name or Toggle.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return setmetatable(Toggle, Library)
        end

        Library.Button = function(Self)
            local Button = {
                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Items = { }
            }

            local Items = { } do 
                Items["Button"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Button.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Button"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 5),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })

                Button.Items = Items
            end

            function Button:Add(Name, Callback)
                local NewButton = { }

                local NewItems = { } do
                    NewItems["Button"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Items["Button"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Element"]
                    }):AddToTheme({BackgroundColor3 = 'Element'})
                    
                    Library:Create("UIStroke", {
                        Name = "\0",
                        Parent = NewItems["Button"].Instance,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        LineJoinMode = Enum.LineJoinMode.Miter,
                        Color = Library.Theme["Outline"]
                    }):AddToTheme({Color = 'Outline'})
                    
                    Library:Create("UIGradient", {
                        Name = "\0",
                        Parent = NewItems["Button"].Instance,
                        Rotation = 90,
                        Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145))
                    }
                    })
                    
                    NewItems["Text"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = NewItems["Button"].Instance,
                        TextColor3 = Library.Theme["Text"],
                        Text = Name,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Size = UDim2.new(0, 0, 0, 15),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.X
                    }):AddToTheme({TextColor3 = 'Text'})    
                    
                    NewItems["Button"]:OnHover(function()
                        NewItems["Button"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                    end, function()
                        NewItems["Button"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                    end)
                end

                function NewButton:Press()
                    NewItems["Button"]:Tween({BackgroundColor3 = Library.Theme.Accent})
                    task.wait(0.1)
                    NewItems["Button"]:Tween({BackgroundColor3 = Library.Theme.Element})
                    
                    Library:SafeCall(Callback)
                end

                function NewButton:SetText(Text)
                    NewItems["Text"].Instance.Text = tostring(Text)
                end

                NewItems["Button"]:Connect("MouseButton1Down", function()
                    NewButton:Press()
                end)

                return Button, NewButton
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            return setmetatable(Button, Library)
        end

        Library.Slider = function(Self, Params)
            Params = Params or { }

            local Slider = {
                Name = Params.Name or Params.name or "Slider",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or 0,
                Min = Params.Min or Params.min or 0,
                Max = Params.Max or Params.max or 100,
                Tooltip = Params.Tooltip or Params.tooltip or "",
                Callback = Params.Callback or Params.callback or function() end,
                Decimals = Params.Decimals or Params.decimals or 0,
                Suffix = Params.Suffix or Params.suffix or "",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = 0,
                Sliding = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Slider.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Slider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0
                })

                Items["Slider"]:Tooltip(Slider.Tooltip)
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Slider.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealSlider"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 8),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145))
                }
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145))
                }
                })
                
                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Accent"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "50%",
                    Size = UDim2.new(0, 0, 0, 15),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 55,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Value"].Instance
                })
                
                Items["RealSlider"]:OnHover(function()
                    Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()
                    Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                end)

                Slider.Items = Items 
            end

            function Slider:Set(Value)
                Value = tonumber(Value)
                if not Value or Value ~= Value or Value == math.huge or Value == -math.huge or Slider.Max <= Slider.Min then
                    return
                end

                Slider.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Decimals)

                local Percent = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)

                Items["Accent"]:Tween({Size = UDim2.new(Percent, 0, 1, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["Value"].Instance.Text = string.format("%s%s", Slider.Value, Slider.Suffix)

                Flags[Slider.Flag] = Slider.Value
                Library:SafeCall(Slider.Callback, Slider.Value)
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:GetSize(Input)
                local Width = Items["RealSlider"].Instance.AbsoluteSize.X
                if Width <= 0 then
                    return Slider.Value
                end

                local SizeX = math.clamp((Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Width, 0, 1)
                return ((Slider.Max - Slider.Min) * SizeX) + Slider.Min
            end

            function Slider:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            local InputChanged 
            
            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local Value = Slider:GetSize(Input)

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local Value = Slider:GetSize(Input)

                        Slider:Set(Value)
                    end
                end
            end)

            Slider:Set(Slider.Default)

            SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return setmetatable(Slider, Library)
        end

        Library.Dropdown = function(Self, Params)
            Params = Params or { }

            local Dropdown = {
                Name = Params.Name or Params.name or "Dropdown",
                OptionItems = Params.Items or Params.items or { },
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Tooltip = Params.Tooltip or Params.tooltip or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = { },
                Options = { },
                IsOpen = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Dropdown.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Dropdown"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 47),
                    BorderSizePixel = 0
                })

                Items["Dropdown"]:Tooltip(Dropdown.Tooltip)
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Dropdown.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealDropdown"] = Library:Create("TextButton", {
                    Name = "\0",
                    Parent = Items["Dropdown"].Instance,
                    Active = false,
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 25),
                    Selectable = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145))
                }
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealDropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "...",
                    Size = UDim2.new(1, -40, 0, 15),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 8, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    TextTruncate = Enum.TextTruncate.AtEnd
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Line"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    Position = UDim2.new(1, -28, 0, 2),
                    Size = UDim2.new(0, 1, 1, -4),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    ImageColor3 = Library.Theme["Text"],
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://88670053799869",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -3, 0.5, 0),
                    Size = UDim2.new(0, 20, 0, 20),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})         
                
                Items["OptionHolder"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 200, 0, 0),
                    Position = UDim2.new(0, 1009, 0, 100),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Visible = false,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 15),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    Padding = UDim.new(0, 5),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline 2"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Outline 2'})             

                Items["RealDropdown"]:OnHover(function()
                    Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end, function()
                    Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme["Element"]})
                end)

                Dropdown.Items = Items 
            end

            Dropdown.Holder = Items["OptionHolder"]

            function Dropdown:Set(Value)
                if Dropdown.Multi then 
                    if type(Value) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Value

                    for Index, Value in Value do
                        local OptionData = Dropdown.Options[Value]
                         
                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true 
                        OptionData:ToggleState("Active")
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = table.concat(Value, ", ")
                else
                    if not Dropdown.Options[Value] then
                        return
                    end

                    local OptionData = Dropdown.Options[Value]

                    Dropdown.Value = Value

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false 
                            Value:ToggleState("Inactive")
                        else
                            Value.IsSelected = true 
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = Value
                end

                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end

            function Dropdown:Add(Value)
                local OptionButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["OptionHolder"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0
                })
                
                local OptionText = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = OptionButton.Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Value,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 5),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})
                
                local OptionLiner = Library:Create("Frame", {
                    Name = "\0",
                    Parent = OptionButton.Instance,
                    BackgroundTransparency = 0,
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(0, 0, 0, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})                

                local OptionData = {
                    Button = OptionButton,
                    Text = OptionText,
                    Liner = OptionLiner,
                    Name = Value,
                    IsSelected = false,
                    IsHovered = false
                }
                
                function OptionData:ToggleState(State)
                    local IsActive = State == "Active"
                    local IsHighlighted = OptionData.IsSelected or OptionData.IsHovered
                    local TextColor = IsHighlighted and Library.Theme["Accent"] or Library.Theme["Text"]

                    OptionData.Text:Tween({TextColor3 = TextColor})
                end

                OptionData.Button:OnHover(function()
                    OptionData.IsHovered = true
                    OptionData:ToggleState(OptionData.IsSelected and "Active" or "Inactive")
                end, function()
                    OptionData.IsHovered = false
                    OptionData:ToggleState(OptionData.IsSelected and "Active" or "Inactive")
                end)

                function OptionData:Set()
                    OptionData.IsSelected = not OptionData.IsSelected

                    if Dropdown.Multi then 
                        local Index = table.find(Dropdown.Value, OptionData.Name)

                        if Index then 
                            table.remove(Dropdown.Value, Index)
                        else
                            table.insert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and table.concat(Dropdown.Value, ", ") or "..."
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.IsSelected then 
                            Dropdown.Value = OptionData.Name
                            Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.IsSelected = false 
                                    Value:ToggleState("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Flags[Dropdown.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")

                            Items["Value"].Instance.Text = "..."
                        end
                    end

                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button.Instance:Destroy()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            function Dropdown:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool 
            end

            local Debounce = false 
            local OptionHolder = Items["OptionHolder"].Instance
            local RealDropdown = Items["RealDropdown"].Instance

            local IsSettings = Dropdown.Section and Dropdown.Section.IsSettings

            function Dropdown:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Dropdown.IsOpen = Bool

                Debounce = true 
                
                if Dropdown.IsOpen then 
                    Items["Icon"]:Tween({Rotation = -90})
                    OptionHolder.Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + GuiInset)
                    OptionHolder.Size = UDim2.new(0, RealDropdown.AbsoluteSize.X, 0, Dropdown.MaxSize)
                    
                    OptionHolder.Parent = Library.Holder.Instance
                    Items["OptionHolder"]:Tween({Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + 10 + GuiInset)})
                    
                    Items["OptionHolder"]:FadeDescendants(true, function()
                        Debounce = false 
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= IsSettings and not Params.Parent then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown 
                else
                    Items["Icon"]:Tween({Rotation = 0})
                    Items["OptionHolder"]:Tween({Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0, RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y - 10 + GuiInset)})
                    Items["OptionHolder"]:FadeDescendants(false, function()
                        OptionHolder.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                    end)

                    if Library.OpenFrames[Dropdown] then 
                        Library.OpenFrames[Dropdown] = nil
                    end
                end

                local Descendants = OptionHolder:GetDescendants()
                table.insert(Descendants, OptionHolder)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if not Params.Parent then
                        Value.ZIndex = Dropdown.IsOpen and Library.ZIndexOrder.OptionHolder or 1
                    else
                        Value.ZIndex = Dropdown.IsOpen and Library.ZIndexOrder.OptionHolder + 3 or 1
                    end
                end
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if Dropdown.IsOpen and not Items["OptionHolder"]:IsMouseOverFrame() then
                        Dropdown:SetOpen(false)
                    end
                end
            end)

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            for Index, Value in Dropdown.OptionItems do 
                Dropdown:Add(Value)
            end

            Dropdown:Set(Dropdown.Default)

            SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return setmetatable(Dropdown, Library)
        end

        Library.Label = function(Self, Params)
            Params = Params or { }

            local Label = {
                Name = Params.Name or Params.name or "Label",
                Tooltip = Params.Tooltip or Params.tooltip or "",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Label.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Label"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 15),
                    BorderSizePixel = 0
                })

                Items["Label"]:Tooltip(Label.Tooltip)
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Label"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Label.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Label"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Label.Items = Items 
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool 
            end

            function Label:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0,

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Name = Data.Name or Data.name or Label.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Label:SetText(Label.Name)

            return setmetatable(Label, Library)
        end

        Library.Paragraph = function(Self, Params)
            Params = Params or { }

            local Paragraph = {
                Name = Params.Name or Params.name or "Paragraph",
                Description = Params.Description or Params.description or "",
                Tooltip = Params.Tooltip or Params.tooltip or "",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Items = { }
            }

            local Items = { } do 
                Items["Paragraph"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Paragraph.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Items["Paragraph"]:Tooltip(Paragraph.Tooltip)
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Paragraph"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Paragraph.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Description"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Paragraph"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Paragraph.Description,
                    Size = UDim2.new(1, 0, 0, 15),
                    Position = UDim2.new(0, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    TextWrapped = true
                }):AddToTheme({TextColor3 = 'Inactive Text'})                

                Paragraph.Items = Items
            end 

            function Paragraph:SetDescription(Text)
                Items["Description"].Instance.Text = Text
            end

            function Paragraph:SetText(Text)
                Items["Text"].Instance.Text = Text
            end

            function Paragraph:SetVisibility(Bool)
                Items["Paragraph"].Instance.Visible = Bool
            end

            return setmetatable(Paragraph, Library)
        end

        Library.Divider = function(Self, Name)
            local Items = { } do
                Items["Divider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Self.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 15),
                    BorderSizePixel = 0
                })
                
                Items["RealDivider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Divider"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(1, 0, 0, 3),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RealDivider"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["RealDivider"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145))
                }
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.BoldFont,
                    TextSize = Library.FontSize,
                    Parent = Items["Divider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Name,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0.5, 0, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Text"].Instance,
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })                
            end

            return Items
        end

        Library.Textbox = function(Self, Params)
            Params = Params or { }

            local Textbox = {
                Name = Params.Name or Params.name or "Textbox",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Finished = Params.Finished or Params.finished or false,
                Placeholder = Params.Placeholder or Params.placeholder or "",
                Tooltip = Params.Tooltip or Params.tooltip or "",
                Numeric = Params.Numeric or Params.numeric or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = "",

                Items = { },
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Textbox.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Textbox"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0
                })

                Items["Textbox"]:Tooltip(Textbox.Tooltip)
                
                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Textbox"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145))
                }
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Background"].Instance,
                    Active = false,
                    Selectable = false,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = Textbox.Placeholder,
                    Size = UDim2.new(1, -40, 0, 15),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 8, 0.5, 0),
                    BorderSizePixel = 0,
                    TextTruncate = Enum.TextTruncate.AtEnd
                }):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text'})
                
                Items["Line"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    Position = UDim2.new(1, -28, 0, 2),
                    Size = UDim2.new(0, 1, 1, -4),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ImageColor3 = Library.Theme["Text"],
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://98091773290646",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -5, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})                

                Textbox.Items = Items
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and string.len(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Flags[Textbox.Flag] = Value

                Library:SafeCall(Textbox.Callback, Value)
            end

            Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                Items["Icon"]:ChangeItemTheme({ImageColor3 = "Text"})
                Items["Icon"]:Tween({ImageColor3 = Library.Theme.Text})

                if PressedEnterQuestionMark and Textbox.Finished then 
                    Textbox:Set(Items["Input"].Instance.Text)
                end
            end)

            Items["Input"]:Connect("Focused", function()
                Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                Items["Icon"]:Tween({ImageColor3 = Library.Theme.Accent})
            end)

            if not Textbox.Finished then 
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            Textbox:Set(Textbox.Default)

            SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end
            
            return setmetatable(Textbox, Library)
        end

        Library.RangeSlider = function(Self, Params)
            Params = Params or { }

            local Slider = {
                Name = Params.Name or Params.name or "Slider",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or {0, 100},
                Min = Params.Min or Params.min or 0,
                Max = Params.Max or Params.max or 100,
                Callback = Params.Callback or Params.callback or function() end,
                Tooltip = Params.Tooltip or Params.tooltip or "",
                Decimals = Params.Decimals or Params.decimals or 0,
                Suffix = Params.Suffix or Params.suffix or "",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = { },
                Sliding = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Slider.Section.Items["Content"]
            end

            local Items = { } do 
                Items["RangeSlider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 35),
                    BorderSizePixel = 0
                })

                Items["RangeSlider"]:Tooltip(Slider.Tooltip)
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RangeSlider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Slider.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealSlider"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RangeSlider"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145))
                }
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    Position = UDim2.new(0, 50, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145))
                }
                })
                
                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealSlider"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "30 - 70",
                    Size = UDim2.new(0, 0, 0, 15),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, -1),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 55,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter
                })
                
                Items["Max"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 2, 0.5, 0),
                    Size = UDim2.new(0, 4, 1, 2),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Max"].Instance,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145))
                }
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Max"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["Min"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, -2, 0.5, 0),
                    Size = UDim2.new(0, 4, 1, 2),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Min"].Instance,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145))
                }
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Min"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})                

                Slider.Items = Items 
            end

            function Slider:Set(MinValue, MaxValue)
                if typeof(MinValue) == "table" then
                    MinValue, MaxValue = MinValue[1], MinValue[2]
                end
            
                MinValue = Library:Round(math.clamp(MinValue, Slider.Min, Slider.Max), Slider.Decimals)
                MaxValue = Library:Round(math.clamp(MaxValue, Slider.Min, Slider.Max), Slider.Decimals)
            
                if MinValue > MaxValue then
                    MinValue, MaxValue = MaxValue, MinValue
                end
            
                MinValue = Library:Round(math.clamp(MinValue, Slider.Min, Slider.Max), Slider.Decimals)
                MaxValue = Library:Round(math.clamp(MaxValue, Slider.Min, Slider.Max), Slider.Decimals)
            
                Slider.Value = { MinValue, MaxValue }
                Flags[Slider.Flag] = Slider.Value
            
                local MinPCT = (MinValue - Slider.Min) / (Slider.Max - Slider.Min)
                local MaxPCT = (MaxValue - Slider.Min) / (Slider.Max - Slider.Min)
            
                Items["Accent"]:Tween({Position = UDim2.fromScale(MinPCT, 0), Size = UDim2.fromScale(MaxPCT - MinPCT, 1)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            
                Items["Min"].Instance.Position = UDim2.fromScale(0, 0.5)
                Items["Max"].Instance.Position = UDim2.fromScale(1, 0.5)

                Items["Value"].Instance.Text = string.format("%s - %s%s", MinValue, MaxValue, Slider.Suffix)
            
                if Slider.Callback then
                    Library:SafeCall(Slider.Callback, Slider.Value)
                end
            end

            function Slider:StartDrag(Handle)
                Slider.SlidingHandle = Handle 
            end

            function Slider:StopDrag()
                Slider.SlidingHandle = nil
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            Items["Min"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider:StartDrag(Items["Min"])
                end
            end)

            Items["Max"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider:StartDrag(Items["Max"])
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.SlidingHandle then
                        Slider:StopDrag()
                    end
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) and Slider.SlidingHandle then
                    local MouseX = Input.Position.X
                    local BarX = Items["RealSlider"].Instance.AbsolutePosition.X
                    local BarW = Items["RealSlider"].Instance.AbsoluteSize.X
            
                    local Scale = math.clamp((MouseX - BarX) / BarW, 0, 1)
                    local Value = Library:Round(
                        (Scale * (Slider.Max - Slider.Min)) + Slider.Min,
                        Slider.Decimals
                    )
            
                    if Slider.SlidingHandle == Items["Min"] then
                        Slider:Set(Value, Slider.Value[2])
                    else
                        Slider:Set(Slider.Value[1], Value)
                    end
                end
            end) 

            Slider:Set(Slider.Default[1], Slider.Default[2])

            SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return setmetatable(Slider, Library)
        end

        Library.InitWindow = function(Self, TargetWindow)
            local Window = TargetWindow or (Self == Library and Library.WindowObject) or Self

            if not Window or not Window.Items or not Window.Items["Pages"] then
                warn("InitWindow requires a window. Use Window:InitWindow() or Library:InitWindow(Window).")
                return
            end

            if Window.SettingsPage then
                return Window.SettingsPage
            end

            local SettingsPage = Window:Page({Name = "Settings"})

            local GeneralSubPage = SettingsPage:SubPage({Name = "General"})

            local ConfigsSection = GeneralSubPage:Section({Name = "configs", Side = 1})
            local UISettingsSection = GeneralSubPage:Section({Name = "ui settings", Side = 1})
            local ThemesSection = GeneralSubPage:Section({Name = "themes", Side = 2})

            local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"
            local ThemesFolder = Library.Directory .. Library.Folders.Themes .. "/"
            local RefreshAutoloadLabel

            do 
                local ConfigName 
                local ConfigSelected 

                local ConfigsDropdown = ConfigsSection:Dropdown({
                    Name = "Configs",
                    Flag = "ConfigsDropdown",
                    Items = { },
                    Multi = false,
                    Callback = function(Value)
                        ConfigSelected = Value 
                    end
                })

                ConfigsSection:Textbox({
                    Name = "Config name",
                    Flag = "ConfigName",
                    Placeholder = "Config name",
                    Callback = function(Value)
                        ConfigName = Value 
                    end
                })

                ConfigsSection:Button():Add("Create", function()
                    if not ConfigName or ConfigName == "" then 
                        Library:Notification("Config name can't be empty", 3, Color3.fromRGB(255, 0, 0))
                        return
                    end

                    writefile(ConfigsFolder .. ConfigName .. ".json", Library:GetConfig())
                    Library:GetConfigsList(ConfigsDropdown)
                    Library:Notification("Succesfully created config", 3, Color3.fromRGB(0, 255, 0))
                end):Add("Delete", function()
                    if not ConfigSelected then 
                        Library:Notification("No config selected", 3, Color3.fromRGB(255, 0, 0))
                        return
                    end

                    if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                        delfile(ConfigsFolder .. ConfigSelected .. ".json")

                        if Library:GetAutoload() == ConfigSelected then
                            Library:SetAutoload("")
                            if RefreshAutoloadLabel then
                                RefreshAutoloadLabel()
                            end
                        end

                        Library:GetConfigsList(ConfigsDropdown)
                        Library:Notification("Succesfully deleted config", 3, Color3.fromRGB(0, 255, 0))
                    end
                end)

                ConfigsSection:Button():Add("Load", function()
                    if not ConfigSelected then 
                        Library:Notification("No config selected", 3, Color3.fromRGB(255, 0, 0))
                        return
                    end

                    if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                        local Success, Error = Library:LoadConfig(readfile(ConfigsFolder .. ConfigSelected .. ".json"))

                        if Success then 
                            Library:Notification("Succesfully loaded config", 3, Color3.fromRGB(0, 255, 0))
                        else
                            Library:Notification("Failed to load config: \n" .. Error, 3, Color3.fromRGB(255, 0, 0))
                        end
                    end
                end):Add("Save", function()
                    if not ConfigSelected then
                        Library:Notification("No config selected", 3, Color3.fromRGB(255, 0, 0))
                        return
                    end

                    if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                        local Success, Error = Library:SafeCall(function()
                            writefile(ConfigsFolder .. ConfigSelected .. ".json", Library:GetConfig())
                        end)

                        if Success then 
                            Library:Notification("Succesfully saved config", 3, Color3.fromRGB(0, 255, 0))
                        else
                            Library:Notification("Failed to save config: \n" .. Error, 3, Color3.fromRGB(255, 0, 0))
                        end
                    end
                end)

                ConfigsSection:Button():Add("Refresh", function()
                    Library:GetConfigsList(ConfigsDropdown)
                end)

                local AutoloadLabel = ConfigsSection:Label({Name = "Autoload: None"})

                RefreshAutoloadLabel = function()
                    local Name = Library:GetAutoload()
                    AutoloadLabel:SetText(Name ~= "" and ("Autoload: " .. Name) or "Autoload: None")
                end

                ConfigsSection:Button():Add("Set Autoload", function()
                    if not ConfigSelected or ConfigSelected == "" then
                        Library:Notification("No config selected", 3, Color3.fromRGB(255, 0, 0))
                        return
                    end

                    if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                        Library:Notification("Config does not exist", 3, Color3.fromRGB(255, 0, 0))
                        return
                    end

                    Library:SetAutoload(ConfigSelected)
                    RefreshAutoloadLabel()
                    Library:Notification('Set "' .. ConfigSelected .. '" as autoload', 3, Color3.fromRGB(0, 255, 0))
                end):Add("Clear Autoload", function()
                    Library:SetAutoload("")
                    RefreshAutoloadLabel()
                    Library:Notification("Cleared autoload", 3, Color3.fromRGB(0, 255, 0))
                end)

                Library:GetConfigsList(ConfigsDropdown)
                RefreshAutoloadLabel()
            end

            do
                UISettingsSection:Label({Name = "Menu Bind"}):Keybind({
                    Flag = "MenuBind",
                    Mode = "Toggle",
                    Default = Enum.KeyCode.RightShift,
                    Callback = function()
                        Library.MenuKeybind = Flags["MenuBind"].Key
                    end
                })

                UISettingsSection:Toggle({
                    Name = "Show Keybind List",
                    Flag = "ShowKeybindList",
                    Default = true,
                    Callback = function(Value)
                        if Library.KeyList then
                            Library.KeyList:SetVisibility(Value)
                        end
                    end
                })

                UISettingsSection:Toggle({
                    Name = "Show Watermark",
                    Flag = "ShowWatermark",
                    Default = true,
                    Callback = function(Value)
                        local WatermarkObject = Self.WatermarkObject or Library.WatermarkObject

                        if WatermarkObject then
                            WatermarkObject:SetVisibility(Value)
                        end
                    end
                })

                UISettingsSection:Button():Add("Unload", function()
                    Library:Exit()
                end)
            end

            do
                local ThemeName
                local ThemeSelected

                ThemesSection:Dropdown({
                    Name = "Preset",
                    Flag = "ThemePreset",
                    Items = Library.ThemeOrder,
                    Default = "Default",
                    Multi = false,
                    Callback = function(Value)
                        if not Library:ApplyTheme(Value) then
                            Library:Notification("Failed to apply theme", 3, Color3.fromRGB(255, 0, 0))
                        end
                    end
                })

                for Index, Value in Library.Theme do 
                    ThemesSection:Label({Name = Index})
                    :Colorpicker({Flag = "Theme" .. Index, Default = Value, Callback = function(Color)
                        Library.Theme[Index] = Color
                        Library:ChangeTheme(Index, Color)
                    end})
                end

                ThemesSection:Divider("saved themes")

                local ThemesDropdown = ThemesSection:Dropdown({
                    Name = "Themes",
                    Flag = "ThemesDropdown",
                    Items = { },
                    Multi = false,
                    Callback = function(Value)
                        ThemeSelected = Value
                    end
                })

                ThemesSection:Textbox({
                    Name = "Theme name",
                    Flag = "ThemeName",
                    Placeholder = "Theme name",
                    Callback = function(Value)
                        ThemeName = Value
                    end
                })

                ThemesSection:Button():Add("Create", function()
                    if not ThemeName or ThemeName == "" then
                        Library:Notification("Theme name can't be empty", 3, Color3.fromRGB(255, 0, 0))
                        return
                    end

                    writefile(ThemesFolder .. ThemeName .. ".json", Library:GetTheme())
                    Library:GetThemesList(ThemesDropdown)
                    Library:Notification("Succesfully created theme", 3, Color3.fromRGB(0, 255, 0))
                end):Add("Delete", function()
                    if not ThemeSelected then
                        Library:Notification("No theme selected", 3, Color3.fromRGB(255, 0, 0))
                        return
                    end

                    if isfile(ThemesFolder .. ThemeSelected .. ".json") then
                        delfile(ThemesFolder .. ThemeSelected .. ".json")
                        Library:GetThemesList(ThemesDropdown)
                        Library:Notification("Succesfully deleted theme", 3, Color3.fromRGB(0, 255, 0))
                    end
                end)

                ThemesSection:Button():Add("Load", function()
                    if not ThemeSelected then
                        Library:Notification("No theme selected", 3, Color3.fromRGB(255, 0, 0))
                        return
                    end

                    if isfile(ThemesFolder .. ThemeSelected .. ".json") then
                        local Success, Error = Library:LoadTheme(readfile(ThemesFolder .. ThemeSelected .. ".json"))

                        if Success then
                            Library:Notification("Succesfully loaded theme", 3, Color3.fromRGB(0, 255, 0))
                        else
                            Library:Notification("Failed to load theme: \n" .. Error, 3, Color3.fromRGB(255, 0, 0))
                        end
                    end
                end):Add("Save", function()
                    if not ThemeSelected then
                        Library:Notification("No theme selected", 3, Color3.fromRGB(255, 0, 0))
                        return
                    end

                    if isfile(ThemesFolder .. ThemeSelected .. ".json") then
                        local Success, Error = Library:SafeCall(function()
                            writefile(ThemesFolder .. ThemeSelected .. ".json", Library:GetTheme())
                        end)

                        if Success then
                            Library:Notification("Succesfully saved theme", 3, Color3.fromRGB(0, 255, 0))
                        else
                            Library:Notification("Failed to save theme: \n" .. Error, 3, Color3.fromRGB(255, 0, 0))
                        end
                    end
                end)

                ThemesSection:Button():Add("Refresh", function()
                    Library:GetThemesList(ThemesDropdown)
                end)

                Library:GetThemesList(ThemesDropdown)
            end

            Window.SettingsPage = SettingsPage

            Library:Thread(function()
                local Success, Result = Library:LoadAutoload()

                if Success then
                    Library:Notification('Autoloaded config "' .. Result .. '"', 3, Color3.fromRGB(0, 255, 0))
                elseif Result == "missing" then
                    Library:Notification('Autoload config is missing', 3, Color3.fromRGB(255, 0, 0))
                elseif Result ~= "none" then
                    Library:Notification("Failed to autoload: \n" .. tostring(Result), 3, Color3.fromRGB(255, 0, 0))
                end
            end)

            return SettingsPage
        end
    end
end

getgenv().Library = Library
return Library
