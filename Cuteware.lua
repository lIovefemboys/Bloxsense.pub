--[[
    NAME: Peronahax
    FOR: All
    
    BASE: 
    AUTO UPDATE PARENT COLORPICKER WITH REPARENTING FUCN
    ADD A LISTENER FUNCTION FOR AUTO THEMING TWEENING ACCENT ITEMS <-- AUTOMATE
    AUTOMATE CLAMPING ON FOR SETVISIBLE NEW UIS 

]]

-- Variables
    local ServiceCache = {};     -- Cloneref bypass
    getgenv().Services = setmetatable({}, {
        __index = function(Self, Index)
            if not ServiceCache[Index] then
                ServiceCache[Index] = cloneref(game:GetService(Index));
            end;

            return ServiceCache[Index];
        end
    });
    
    local Keys = {
        [Enum.KeyCode.LeftShift] = "Left Shift",
        [Enum.KeyCode.RightShift] = "Right Shift",
        [Enum.KeyCode.LeftControl] = "Left Ctrl",
        [Enum.KeyCode.RightControl] = "Right Ctrl",
        [Enum.KeyCode.Insert] = "Insert",
        [Enum.KeyCode.Backspace] = "Backspace",
        [Enum.KeyCode.Return] = "Return",
        [Enum.KeyCode.LeftAlt] = "Left Alt",
        [Enum.KeyCode.RightAlt] = "Right Alt",
        [Enum.KeyCode.CapsLock] = "Capslock",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "Num1",
        [Enum.KeyCode.KeypadTwo] = "Num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4",
        [Enum.KeyCode.KeypadFive] = "Num5",
        [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7",
        [Enum.KeyCode.KeypadEight] = "Num8",
        [Enum.KeyCode.KeypadNine] = "Num9",
        [Enum.KeyCode.KeypadZero] = "Num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ",",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "MouseButton1",
        [Enum.UserInputType.MouseButton2] = "MouseButton2",
        [Enum.UserInputType.MouseButton3] = "MouseButton3",
        [Enum.KeyCode.Escape] = "Escape",
        [Enum.KeyCode.Space] = "Space",
    }

    local Camera = workspace.CurrentCamera
    local LocalPlayer = Services.Players.LocalPlayer
    local GuiInset = Services.GuiService:GetGuiInset().Y
    local Mouse = LocalPlayer:GetMouse()

    local NumSeq = NumberSequence.new
    local ColorSeq = ColorSequence.new

    local NumKey = NumberSequenceKeypoint.new
    local ColorKey = ColorSequenceKeypoint.new

    local function Color3ToRGB(color3)
        local r = math.round(color3.R * 255)
        local g = math.round(color3.G * 255)
        local b = math.round(color3.B * 255)
        return r, g, b
    end
--

if getgenv().Library and getgenv().Library.Unload then
    getgenv().Library:Unload()
end

local Library; do
    Library = {	
        Directory = "Atlanta",
        Folders = {
            "/Fonts",
            "/Configs",
            "/Themes",
        },

        Flags = {},
        ConfigFlags = {},
        FlagCount = 0;
        Connections = {},
        Threads = {},
        Blurs = {},
        Elements = {},
        Notifications = {},

        OpenElement = {},
        Moderators = {},
        Keybinds = {},
        Guis = {},
        Glows = {}, 

        EasingDirection = Enum.EasingDirection.InOut,
        EasingStyle = Enum.EasingStyle.Quint,
        TweeningSpeed = .3,
        DraggingSpeed = .05,
        Tweening = false,
    };  
    
    Library.__index = Library;
    getgenv().Library = Library

    for _, path in Library.Folders do
        makefolder(Library.Directory .. path)
    end

    if not isfile(Library.Directory .. "/Autoload.txt") then
        writefile(Library.Directory .. "/Autoload.txt", "")
    end

    local Flags = Library.Flags
    local ConfigFlags = Library.ConfigFlags
    local Notifications = Library.Notifications
    local Elements = Library.Elements

    local Themes = {
       Preset = {
            ["High Contrast"] = Color3.fromRGB(38, 38, 38),
            ["Low Contrast"] = Color3.fromRGB(25, 25, 25),
            ["TabButtonUnselected"] = Color3.fromRGB(17, 17, 17),

            ["Outline"] = Color3.fromRGB(1, 1, 1),
            ["Inline"] = Color3.fromRGB(54, 54, 54),

            ["MenuBackground"] = Color3.fromRGB(29, 29, 29),
            ["PageBackground"] = Color3.fromRGB(24, 24, 24),
            ["SectionBackground"] = Color3.fromRGB(19, 19, 19),

            ["TextMisc"] = Color3.fromRGB(134, 134, 134),
            ["TextMain"] = Color3.fromRGB(160, 160, 160),

            ["Accent"] = Color3.fromRGB(245, 20, 136),
        },
        Utility = {},
        GradientsThemes = {}, 
    }; do
        for Theme, Color in Themes.Preset do
            Themes.Utility[Theme] = {
                BackgroundColor3 = {},
                TextColor3 = {},
                ImageColor3 = {},
                ScrollBarImageColor3 = {},
                Color = {},
                PlaceholderColor3 = {},
            }
        end

        Library.Themify = function(self, Theme, Property)
            table.insert(Themes.Utility[Theme][Property], self.Instance)
            
            return self 
        end

        Library.GradientCheck = function(self, Keypoint, NewColor, Theme)
            if Color3ToRGB(Keypoint.Value) == Color3ToRGB(Themes.Preset[Theme]) then 
                return {Time = Keypoint.Time, Value = NewColor}    
            end
        end

        Library.ConstructGradient = function(self, Constructor)
            local Returner = {} 
            
            for Index, Value in Constructor do
                Returner[Index] = ColorSequenceKeypoint.new(Value.Time, Value.Value)
            end

            return ColorSequence.new(Returner)
        end 

        Library.SameColor = function(self, Color, CheckedTheme)
            for Name,Theme in Themes.Preset do 
                if Name == CheckedTheme then 
                    continue 
                end 

                if Color3ToRGB(Color) == Color3ToRGB(Theme) then 
                    return true
                end 
            end

            return false
        end

        Library.Refresh = function(self, Theme, Color)
            if self:SameColor(Color, Theme) then 
                return 
            end 

            for Property, Data in Themes.Utility[Theme] do
                for _, Object in Data do
                    if (property == "Transparency") and not (Object:IsA("UIStroke")) then
                        continue
                    end

                    if Object:IsA("UIGradient") then
                        local Constructor = {}

                        for Index,Keypoint in Object.Color.Keypoints do 
                            local Return = self:GradientCheck(Keypoint, Color, Theme)

                            if Return then 
                                Constructor[Index] = Return
                            else 
                                Constructor[Index] = {Time = Keypoint.Time, Value = Keypoint.Value} 
                            end 
                        end

                        local NewColor = self:ConstructGradient(Constructor)
                        Object.Color = NewColor
                    else 
                        if (Object[Property] == Themes.Preset[Theme]) then
                            Object[Property] = Color
                        end
                    end 
                end
            end

            Themes.Preset[Theme] = Color
        end

        Library.ThemeListener = function(self, Theme, Statement, Property, Dumper)
            local Instance = self.Instance 

            Dumper = Dumper or "BackgroundColor3"
            Property = Property or "TextColor3"
            Theme = Theme or "Accent"

            Instance[Dumper] = Themes.Preset[Theme]   
            self:Themify(Theme, Dumper)
            
            Instance:GetPropertyChangedSignal(Dumper):Connect(function()
                if Statement() then 
                    Instance[Property] = Themes.Preset[Theme]
                end 
            end)

            return self
        end

        Library.GetTheme = function(self)
            local Config = {}

            for Idx, Value in Themes.Preset do
                if Idx == "Font" then
                    continue
                end

                Config[Idx] = { Transparency = 1, Color = Value:ToHex() }
            end

            for Idx, Value in { "Blur Intensity", "Misc Transparency", "Main Transparency" } do
                Config[Value] = Library.Flags[Value]
            end

            return Services.HttpService:JSONEncode(Config)
        end

        Library.SaveTheme = function(self, Config)
            if Config == "" then
                return
            end

            local Path = string.format("%s/%s/%s.Cfg", Library.Directory, "Themes", Config)
            writefile(Path, self:GetTheme())
        end

        Library.DeleteTheme = function(self, Config)
            local Path = string.format("%s/%s/%s.Cfg", Library.Directory, "Themes", Config)

            if isfile(Path) then
                delfile(Path)
            end
        end

        Library.UpdateThemingList = function(self)
            local List = {}

            for _, File in listfiles(Library.Directory .. "/Themes") do
                local Name = File:gsub(Library.Directory .. "/Themes\\", ""):gsub(".Cfg", ""):gsub(
                Library.Directory .. "\\Themes\\", "")
                List[#List + 1] = Name
            end

            self:RefreshDropdown(List)
        end
    end Library.Themes = Themes

    local Fonts = {}; do
        function Fonts:New(Name, Weight, Style, Data)
            if not isfile(Library.Directory .. "/Fonts/" .. Data.Id) then
                writefile(Library.Directory .. "/Fonts/" .. Data.Id, game:HttpGet(Data.Url))
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Library.Directory .. "/Fonts/" .. Data.Id)
                    }
                }
            }

            writefile(Library.Directory .. "/Fonts/" .. Name .. ".font", Services.HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(Library.Directory .. "/Fonts/" .. Name .. ".font"))
        end

        Fonts.Main = Fonts:New("ProggyClean", 400, "Regular", {
            Id = "ProggyClean",
            Url = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf" -- // Main font
        })
    end

    local EasingStyles = {
        [Enum.EasingStyle.Linear] = {
            [Enum.EasingDirection.In] = function(Delta)
                return Delta
            end,
            [Enum.EasingDirection.Out] = function(Delta)
                return Delta
            end,
            [Enum.EasingDirection.InOut] = function(Delta)
                return Delta
            end
        },
        [Enum.EasingStyle.Cubic] = {
            [Enum.EasingDirection.In] = function(Delta)
                return Delta ^ 3
            end,
            [Enum.EasingDirection.Out] = function(Delta)
                return ((Delta - 1) ^ 3) + 1
            end,
            [Enum.EasingDirection.InOut] = function(Delta)
                if 0 <= Delta and Delta <= 0.5 then
                    return (4 * Delta ^ 3)
                elseif 0.5 <= Delta and Delta <= 1 then
                    return (4 * (Delta - 1) ^ 3) + 1
                end
            end
        },
        [Enum.EasingStyle.Quad] = {
            [Enum.EasingDirection.In] = function(Delta)
                return Delta ^ 2
            end,
            [Enum.EasingDirection.Out] = function(Delta)
                return (-(Delta - 1) ^ 2) + 1
            end,
            [Enum.EasingDirection.InOut] = function(Delta)
                if 0 <= Delta and Delta <= 0.5 then
                    return (2 * Delta ^ 2)
                elseif 0.5 <= Delta and Delta <= 1 then
                    return -(2 * (Delta - 1) ^ 2) + 1
                end
            end
        },
        [Enum.EasingStyle.Quart] = {
            [Enum.EasingDirection.In] = function(Delta)
                return Delta ^ 4
            end,
            [Enum.EasingDirection.Out] = function(Delta)
                return (-(Delta - 1) ^ 4) + 1
            end,
            [Enum.EasingDirection.InOut] = function(Delta)
                if 0 <= Delta and Delta <= 0.5 then
                    return (8 * Delta ^ 4)
                elseif 0.5 <= Delta and Delta <= 1 then
                    return -(8 * (Delta - 1) ^ 4) + 1
                end
            end
        },
        [Enum.EasingStyle.Quint] = {
            [Enum.EasingDirection.In] = function(Delta)
                return Delta ^ 5
            end,
            [Enum.EasingDirection.Out] = function(Delta)
                return ((Delta - 1) ^ 5) + 1
            end,
            [Enum.EasingDirection.InOut] = function(Delta)
                if 0 <= Delta and Delta <= 0.5 then
                    return (16 * Delta ^ 5)
                elseif 0.5 <= Delta and Delta <= 1 then
                    return (16 * (Delta - 1) ^ 5) + 1
                end
            end
        },
        [Enum.EasingStyle.Sine] = {
            [Enum.EasingDirection.In] = function(Delta)
                return math.sin(((math.pi / 2) * Delta) - (math.pi / 2)) + 1
            end,
            [Enum.EasingDirection.Out] = function(Delta)
                return math.sin((math.pi / 2) * Delta)
            end,
            [Enum.EasingDirection.InOut] = function(Delta)
                return (0.5 * math.sin((math.pi * Delta) - (math.pi / 2))) + 0.5
            end
        },
        [Enum.EasingStyle.Exponential] = {
            [Enum.EasingDirection.In] = function(Delta)
                return (2 ^ ((10 * Delta) - 10)) - 0.001
            end,
            [Enum.EasingDirection.Out] = function(Delta)
                return 1.001 * (-2 ^ -(10 * Delta)) + 1
            end,
            [Enum.EasingDirection.InOut] = function(Delta)
                if 0 <= Delta and Delta <= 0.5 then
                    return 0.5 * (2 ^ ((20 * Delta) - 10)) - 0.0005
                elseif 0.5 <= Delta and Delta <= 1 then
                    return 0.50025 * (-2 ^ (-(20 * Delta) + 10)) + 1
                end
            end
        },
        [Enum.EasingStyle.Back] = {
            [Enum.EasingDirection.In] = function(Delta)
                return (Delta * Delta) * (Delta * (1.70158 + 1) - 1.70158)
            end,
            [Enum.EasingDirection.Out] = function(Delta)
                return ((Delta - 1) ^ 2) * ((Delta - 1) * (1.70158 + 1) + 1.70158) + 1
            end,
            [Enum.EasingDirection.InOut] = function(Delta)
                if 0 <= Delta and Delta <= 0.5 then
                    return (2 * (Delta * Delta)) * ((2 * Delta) * (2.5949095 + 1) - 2.5949095)
                elseif 0.5 <= Delta and Delta <= 1 then
                    return (0.5 * ((2 * Delta) - 2) ^ 2) * (((2 * Delta) - 2) * (2.5949095 + 1) + 2.5949095) + 1
                end
            end
        },
        [Enum.EasingStyle.Bounce] = {
            [Enum.EasingDirection.In] = function(Delta)
                if 0 <= Delta and Delta <= (1 / 2.75) then
                    return 7.5625 * (Delta * Delta)
                elseif (1 / 2.75) <= Delta and Delta <= (2 / 2.75) then
                    return 7.5625 * (Delta - (1.5 / 2.75)) ^ 2 + 0.75
                elseif (2 / 2.75) <= Delta and Delta <= (2.5 / 2.75) then
                    return 7.5625 * (Delta - (2.25 / 2.75)) ^ 2 + 0.9375
                elseif (2.5 / 2.75) <= Delta and Delta <= 1 then
                    return 7.5625 * (Delta - (2.625 / 2.75)) ^ 2 + 0.984375
                end
            end,
            [Enum.EasingDirection.Out] = function(Delta)
                if 0 <= Delta and Delta <= (0.25 / 2.75) then
                    return -7.5625 * (1 - Delta - (2.625 / 2.75)) ^ 2 + 0.015625
                elseif (0.25 / 2.75) <= Delta and Delta <= (0.75 / 2.75) then
                    return -7.5625 * (1 - Delta - (2.25 / 2.75)) ^ 2 + 0.0625
                elseif (0.75 / 2.75) <= Delta and Delta <= (1.75 / 2.75) then
                    return -7.5625 * (1 - Delta - (1.5 / 2.75)) ^ 2 + 0.25
                elseif (1.75 / 2.75) <= Delta and Delta <= 1 then
                    return 1 - 7.5625 * (1 - Delta) ^ 2
                end
            end,
            [Enum.EasingDirection.InOut] = function(Delta)
                if 0 <= Delta and Delta <= (0.125 / 2.75) then
                    return 0.5 * (-7.5625 * (1 - (2 * Delta) - (2.625 / 2.75)) ^ 2 + 0.015625)
                elseif (0.125 / 2.75) <= Delta and Delta <= (0.375 / 2.75) then
                    return 0.5 * (-7.5625 * (1 - (2 * Delta) - (2.25 / 2.75)) ^ 2 + 0.0625)
                elseif (0.375 / 2.75) <= Delta and Delta <= (0.875 / 2.75) then
                    return 0.5 * (-7.5625 * (1 - (2 * Delta) - (1.5 / 2.75)) ^ 2 + 0.25)
                elseif (0.875 / 2.75) <= Delta and Delta <= 0.5 then
                    return 0.5 * (1 - 7.5625 * (1 - (2 * Delta)) ^ 2)
                elseif 0.5 <= Delta and Delta <= (1.875 / 2.75) then
                    return 0.5 + 3.78125 * ((2 * Delta) - 1) ^ 2
                elseif (1.875 / 2.75) <= Delta and Delta <= (2.375 / 2.75) then
                    return 3.78125 * ((2 * Delta) - (4.25 / 2.75)) ^ 2 + 0.875
                elseif (2.375 / 2.75) <= Delta and Delta <= (2.625 / 2.75) then
                    return 3.78125 * ((2 * Delta) - (5 / 2.75)) ^ 2 + 0.96875
                elseif (2.625 / 2.75) <= Delta and Delta <= 1 then
                    return 3.78125 * ((2 * Delta) - (5.375 / 2.75)) ^ 2 + 0.9921875
                end
            end
        },
        [Enum.EasingStyle.Elastic] = {
            [Enum.EasingDirection.In] = function(Delta)
                return (-2 ^ (10 * (Delta - 1))) * math.sin(((2 * math.pi) * (Delta - 1 - (0.3 / 4))) / 0.3)
            end,
            [Enum.EasingDirection.Out] = function(Delta)
                return (2 ^ (-10 * Delta)) * math.sin(((2 * math.pi) * (Delta - (0.3 / 4))) / 0.3) + 1
            end,
            [Enum.EasingDirection.InOut] = function(Delta)
                if 0 <= Delta and Delta <= 0.5 then
                    return -0.5 * (2 ^ ((20 * Delta) - 10)) * math.sin(((2 * math.pi) * ((2 * Delta) - 1.1125)) / 0.45)
                elseif 0.5 <= Delta and Delta <= 1 then
                    return 0.5 * (2 ^ ((-20 * Delta) + 10)) * math.sin(((2 * math.pi) * ((2 * Delta) - 1.1125)) / 0.45) + 1
                end
            end
        },
        [Enum.EasingStyle.Circular] = {
            [Enum.EasingDirection.In] = function(Delta)
                return -math.sqrt(1 - Delta ^ 2) + 1
            end,
            [Enum.EasingDirection.Out] = function(Delta)
                return math.sqrt(-(Delta - 1) ^ 2 + 1)
            end,
            [Enum.EasingDirection.InOut] = function(Delta)
                if 0 <= Delta and Delta <= 0.5 then
                    return -math.sqrt(-Delta ^ 2 + 0.25) + 0.5
                elseif 0.5 <= Delta and Delta <= 1 then
                    return math.sqrt(-(Delta - 1) ^ 2 + 0.25) + 0.5
                end
            end
        }
    }

    local EasingStyleNames = {"Linear", "Cubic", "Quad", "Quart", "Quint", "Sine", "Exponential", "Back", "Bounce", "Elastic", "Circular"}

    -- // Element Side functions
    do
        -- // Window    
        Library.SetMenuVisible = function(self, Bool)
            if self.Tweening then
                return  
            end

            Library.Items:TweenDescendants(Bool, self)

            Library.Elements.Instance.Enabled = Bool
            self.Open = Bool  
        end

        -- // Page
        Library.CheckPriority = function(self)
            -- // Checking if the lines should be visible or not based on order of arrival 
            -- // Yes this was too complex todo in studio easier to code lol. 
            local Order = self.PageCount 
            local Max = self.Window.PageCount 

            if Order == 1 then 
                self.Items.Left.Instance.Visible = false;
                self.Items.Right.Instance.Visible = true;       
            elseif Order == Max then 
                self.Items.Left.Instance.Visible = true;
                self.Items.Right.Instance.Visible = false;
            else 
                self.Items.Left.Instance.Visible = true;
                self.Items.Right.Instance.Visible = true;
            end 
        end 

        Library.OpenPage = function(self)
            if self.Tweening then return end 

            local Window = self.Window
            local OldTab = Window.TabInfo

            local Items = self.Items

            if OldTab == self or (self.Tweening or (OldTab and OldTab.Tweening)) then
                return
            end

            if OldTab then
                local OldItems = OldTab.Items

                OldItems.Filler:Tween({BackgroundTransparency = 1})
                OldItems.Button:Tween({BackgroundTransparency = 1})
                OldItems.Left:Tween({BackgroundTransparency = 1})
                OldItems.Right:Tween({BackgroundTransparency = 1})
                OldItems.Stroke:Tween({Transparency = 1})
                OldItems.Title:Tween({TextColor3 = Themes.Preset.TextMain})

                OldItems.Page:TweenDescendants(false, OldTab)
                OldItems.Page.Parent = Library.Other.Instance
            end

            Items.Button:Tween({BackgroundTransparency = 0})
            Items.Filler:Tween({BackgroundTransparency = 0})
            Items.Left:Tween({BackgroundTransparency = 0})
            Items.Right:Tween({BackgroundTransparency = 0})
            Items.Stroke:Tween({Transparency = 0})
            Items.Title:Tween({TextColor3 = Themes.Preset.Accent})

            Items.Page:TweenDescendants(true, self)
            Items.Page.Parent = self.Parent;
            self:CheckPriority()

            Window.TabInfo = self
        end

        Library.OpenMultiPage = function(self)
            
        end

        Library.CreateMultiPage = function(self, Data)
            Data = Data or {} 
            
            local Cfg = {
                Items = {}
            }

            local Items = Cfg.Items; do  
                Items.Icon = Library:Create("ImageLabel",{ImageColor3 = Themes.Preset.UnselectedMultiPage; ScaleType = Enum.ScaleType.Fit; Parent = Items.IconHolder.Instance; Image = Cfg.Icon; Image = "rbxassetid://83328191811567"; BackgroundTransparency = 1; Size = UDim2.new(0, 37, 0, 37); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Themify("UnselectedMultiPage", "ImageColor3"):Themify("Accent", "ImageColor3")
                Items.Seperator = Library:Create("Frame",{Parent = Items.Icon.Instance; Position = UDim2.new(1, 0, 0, 0); Size = UDim2.new(0, 1, 1, 0); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(54, 54, 54)})

                -- // Page
                Items.Page = Library:Create("Frame",{Visible = false; Parent = self.Items.BackgroundInner.Instance; BackgroundTransparency = 1; Size = UDim2.new(1, 0, 1, 0); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Reparent(self.Items.BackgroundInner.Instance)
                Items.UIListLayout = Library:Create("UIListLayout",{FillDirection = Enum.FillDirection.Horizontal; HorizontalFlex = Enum.UIFlexAlignment.Fill; Parent = Items.Page.Instance; Padding = UDim.new(0, 4); SortOrder = Enum.SortOrder.LayoutOrder; VerticalFlex = Enum.UIFlexAlignment.Fill})

                -- // Columns
                for Index = 1, Cfg.Columns do
                    Items[tostring(Index)] = Library:Create("ScrollingFrame",{ScrollBarImageColor3 = Themes.Preset["Outline"]; Active = true; AutomaticCanvasSize = Enum.AutomaticSize.Y; ScrollBarThickness = 0; Parent = Items.Page.Instance; BackgroundTransparency = 1; BackgroundColor3 = Color3.fromRGB(255, 255, 255); BorderSizePixel = 0; CanvasSize = UDim2.new(0, 0, 0, 0)}):Themify("Outline", "ScrollBarImageColor3")
                    Items.UIListLayout = Library:Create("UIListLayout",{Parent = Items[tostring(Index)].Instance; Padding = UDim.new(0, 4); SortOrder = Enum.SortOrder.LayoutOrder; HorizontalFlex = Enum.UIFlexAlignment.Fill});
                end
            end 

            local MultiPage = setmetatable(Cfg, Library)
            
            return MultiPage
        end
        
        -- // Section
        Library.CreateElements = function(self, Data)
            Data = Data or {}

            local Cfg = {
                Parent = Data.Parent or self.Items.Section or self.Instance,
                Position = Data.Position or UDim2.new(0, 4, 0, 25),
                Size = Data.Size or UDim2.new(1, -8, 0, 0),

                Items = {},
                DataElements = {},
            }

            local Items = Cfg.Items; do
                Items.Elements = Library:Create( "Frame", {
                    Parent = Cfg.Parent,
                    BackgroundTransparency = 1;
                    Position = Cfg.Position;
                    Size = Cfg.Size;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })

                Library:Create( "UIListLayout", {
                    Parent = Items.Elements.Instance;
                    Padding = UDim.new(0, 4);
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create( "UIPadding", {
                    PaddingBottom = UDim.new(0, 2);
                    Parent = Items.Elements.Instance
                })
            end

            Cfg.SetVisible = function(Bool)
                Items.Elements.Instance.Visible = Bool
            end

            return setmetatable(Cfg, Library)
        end

        Library.CheckMultiPriority = function(self)
            -- // CLONED
            -- // Checking if the lines should be visible or not based on order of arrival 
            -- // Yes this was too complex todo in studio easier to code lol. 
            local Order = self.Count 
            local Max = self.Old.Count 
            
            if Order == 1 then 
                self.Items.Left.Instance.Visible = false;
                self.Items.Right.Instance.Visible = true;       
            elseif Order == Max then 
                self.Items.Left.Instance.Visible = true;
                self.Items.Right.Instance.Visible = false;
            else 
                self.Items.Left.Instance.Visible = true;
                self.Items.Right.Instance.Visible = true;
            end 
        end
        
        Library.CreateMultiSection = function(self, Data)
            self.Count += 1
            Data = Data or {} 

            local Cfg = {
                Text = Data.Name or Data.Text or Data.Title or "Section";
                Items = {};
                Count = self.Count;
                Old = self;
            }
            
            local Elements;
            local Items = Cfg.Items; do 
                -- // Elements 
                Elements = Library:CreateElements({
                    Parent = self.Items.Background.Instance;
                    Position = UDim2.new(0, 4, 0, 29)
                })

                Items.Elements = Elements.Items.Elements
                Elements.SetVisible(false)
                
                -- // Button
                Items.Button = Library:Create("TextButton",{Active = false; Parent = self.Items.TabButtonHolder.Instance; BackgroundTransparency = 1; Selectable = false; TextTransparency = 1; BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.Text = Library:Create("TextLabel",{BackgroundColor3 = Themes.Preset.Accent; TextColor3 = Themes.Preset.TextMain; Text = Cfg.Text; Parent = Items.Button.Instance; BackgroundTransparency = 1; Size = UDim2.new(1, 0, 1, 0); BackgroundColor3 = Themes.Preset.Accent; BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.XY}):Themify("Accent", "BackgroundColor3")
                Items.Stroke = Library:Create("UIStroke",{Transparency = 1; Parent = Items.Button.Instance; ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
                Items.UIStroke = Library:Create("UIStroke",{Parent = Items.Text.Instance; LineJoinMode = Enum.LineJoinMode.Miter})
                Items.UIGradient = Library:Create("UIGradient",{Rotation = 90; Parent = Items.Button.Instance; Color = ColorSeq{ColorKey(0, Color3.fromRGB(38, 38, 38)), ColorKey(1, Themes.Preset.SectionBackground)}})
                Items.Filler = Library:Create("Frame",{Parent = Items.Button.Instance; BackgroundTransparency = 1; Position = UDim2.new(0, 0, 1, 0); Size = UDim2.new(1, 0, 0, 2); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset.SectionBackground})
                Items.Right = Library:Create("Frame",{Parent = Items.Button.Instance; BackgroundTransparency = 1; Position = UDim2.new(1, -1, 0, 0); Size = UDim2.new(0, 1, 1, 2); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(54, 54, 54)})
                Items.Left = Library:Create("Frame",{Parent = Items.Button.Instance; BackgroundTransparency = 1; Size = UDim2.new(0, 1, 1, 2); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(54, 54, 54)})

                Items.Text:ThemeListener("Accent", function() 
                    return Cfg == self.OldSection;
                end, "TextColor3", "BackgroundColor3")
            end     

            local Multi = setmetatable(Cfg, Library)

            function Cfg.SetVisible(Bool)
                Items.Button:Tween({BackgroundTransparency = Bool and 0 or 1})
                Items.Filler:Tween({BackgroundTransparency = Bool and 0 or 1})
                Items.Left:Tween({BackgroundTransparency = Bool and 0 or 1})
                Items.Right:Tween({BackgroundTransparency = Bool and 0 or 1})
                Items.Stroke:Tween({Transparency = Bool and 0 or 1})
                Items.Text:Tween({TextColor3 = Bool and Themes.Preset.Accent or Themes.Preset.TextMain})
                Multi:CheckMultiPriority() 

                Elements.SetVisible(Bool)
            end

            Items.Button:OnClick(function()
                if self.OldSection == Cfg then 
                    return 
                end 

                if self.OldSection then 
                    self.OldSection.SetVisible(false)
                end 

                Cfg.SetVisible(true)

                self.OldSection = Cfg;
            end)

            return Multi
        end

        -- // Elements
        Library.SetupElement = function(self, Default, Extra)
            if self.Set and self.Flag then
                ConfigFlags[self.Flag] = self.Set
                self.Set(Default)
            end

            if self.Items.Object and self.Names and self.Elements then
                table.insert(self.Names, self.Text)
                table.insert(self.Elements, self.Items.Object)
            end

            if self.Hovering and self.Type ~= "Label" and self.DataElements and self.IsHovering then
                table.insert(self.DataElements, self.IsHovering)
            end
        end

        -- // Slider
        Library.UpdateSlider = function(self, Input)
            local Items = self.Items

            local Size = (Input.Position.X - Items.Outline.Instance.AbsolutePosition.X) / Items.Outline.Instance.AbsoluteSize.X
            local Value = ((self.Max - self.Min) * Size) + self.Min

            self.Set(Value)
        end

        Library.UpdateRangeSlider = function(self, Input)
            local Items = self.Items 

            local MouseX = Input.Position.X
            local BarX = Items.Holder.Instance.AbsolutePosition.X
            local BarW = Items.Holder.Instance.AbsoluteSize.X

            local Scale = math.clamp((MouseX - BarX) / BarW, 0, 1)
            local Value = Library:Round((Scale * (self.Max - self.Min)) + self.Min, self.Intervals)

            if self.SlidingHandle == Items.Min then
                self.Set(Value, self.Value[2])
            else
                self.Set(self.Value[1], Value)
            end
        end

        Library.UpdateSliderPosition = function(self, Bool, Debounce)
            local Items = self.Items
                
            local YOffset = 81 - 5
            local Position = Debounce and Items.Settings.Instance.AbsolutePosition or Vector2.new(Mouse.X, Mouse.Y)
            local Width = Library:Round(Position.X, 0.5)
            local FrameWidth = Library:Round(Items.Value.Instance.AbsoluteSize.X, 0.5)

            if Debounce then
                return
            end

            if Bool then
                Items.Settings.Instance.Position = UDim2.fromOffset(Width, math.floor(Position.Y + (YOffset - 15)))
                Items.Settings:Tween({ Position = UDim2.fromOffset(Width, math.floor(Position.Y + YOffset)) })
            else
                Items.Settings:Tween({ Position = UDim2.fromOffset(Width, math.floor(Position.Y + (YOffset - 15))) })
            end
        end

        -- // Lists / Dropdowns
        Library.RenderDropdownOption = function(self, Text)
            local Items = self.Items
            local Items = {}    
            
            Items.Value = Library:Create("TextButton",{BackgroundColor3 = Themes.Preset.Accent; Parent = self.Items.OptionsHolder.Instance; TextColor3 = Themes.Preset.Accent; Text = Text; Size = UDim2.new(1, 0, 0, 0); ClipsDescendants = true; BorderSizePixel = 0; BackgroundTransparency = 1; TextXAlignment = Enum.TextXAlignment.Left; RichText = true; AutomaticSize = Enum.AutomaticSize.Y; BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Themify("TextMisc", "TextColor3"):Themify("Accent", "BackgroundColor3")
            Items.UIStroke = Library:Create("UIStroke",{Parent = Items.Value.Instance; LineJoinMode = Enum.LineJoinMode.Miter, ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual})
            Items.UIPadding = Library:Create("UIPadding",{PaddingTop = UDim.new(0, 4); PaddingBottom = UDim.new(0, 4); Parent = Items.Value.Instance; PaddingRight = UDim.new(0, 4); PaddingLeft = UDim.new(0, 5)})

            Items.Value.Instance.Text = Text

            Items.Value:ThemeListener("Accent", function() 
                local Value = Flags[self.Flag]
                local Text = Items.Value.Instance.Text
                local IsTable = type(Value) == "table"
                
                return (Text == Value or (IsTable and table.find(Value, Text)))
            end, "TextColor3", "BackgroundColor3")

            local Hover = function()
                local Value = Flags[self.Flag]
                local Text = Items.Value.Instance.Text
                local IsTable = type(Value) == "table"

                if not (Text == Value or (IsTable and table.find(Value, Text))) then 
                    Items.Value:Tween({TextColor3 = Themes.Preset.TextMain})
                end 
            end 

            local NoHover = function()
                local Value = Flags[self.Flag]
                local Text = Items.Value.Instance.Text
                local IsTable = type(Value) == "table"

                if not (Text == Value or (IsTable and table.find(Value, Text))) then 
                    Items.Value:Tween({TextColor3 = Themes.Preset.TextMisc})
                end 
            end 

            Items.Value:OnHover(Hover, NoHover)

            table.insert(self.OptionInstances, Items)

            return Items
        end 

        Library.RefreshDropdown = function(self, Options)
            local Items = self.Items

            for _, Option in self.OptionInstances do
                Option.Value.Instance:Destroy()
            end

            self.OptionInstances = {}

            for _, Option in Options do
                local Object = self:RenderDropdownOption(Option)
                local Button = Object.Value
                local Text = Object.Value.Instance.Text
                
                Button:OnClick(function()
                    if self.Multi then
                        local Selected = table.find(self.MultiItems, Text)

                        if Selected then
                            table.remove(self.MultiItems, Selected)
                        else
                            table.insert(self.MultiItems, Text)
                        end

                        self.Set(self.MultiItems)
                    else
                        self.Set(Text)
                    end
                end)
            end

            if #self.OptionInstances >= 10 or self.Scrolling then
                Items.OptionsHolder.Instance.Size = UDim2.new(1, 0, 0, 100)
                Items.OptionsHolder.Instance.AutomaticSize = Enum.AutomaticSize.None
            else
                Items.OptionsHolder.Instance.Size = UDim2.new(1, 0, 0, 0)
                Items.OptionsHolder.Instance.AutomaticSize = Enum.AutomaticSize.Y
            end
        end

        Library.RenderListOption = function(self, Text)
            local Items = {}    

            Items.Value = Library:Create("TextLabel",{BackgroundColor3 = Themes.Preset.Accent; Parent = self.Items.Holder.Instance; TextColor3 = Themes.Preset.TextMisc; Text = Text; Size = UDim2.new(1, 0, 0, 0); ClipsDescendants = true; BorderSizePixel = 0; BackgroundTransparency = 1; TextXAlignment = Enum.TextXAlignment.Left; RichText = true; AutomaticSize = Enum.AutomaticSize.Y}):Themify("Accent", "BackgroundColor3"):Themify("TextMisc", "TextColor3")
            Items.UIStroke = Library:Create("UIStroke",{Parent = Items.Value.Instance; LineJoinMode = Enum.LineJoinMode.Miter})
            Items.UIPadding = Library:Create("UIPadding",{PaddingTop = UDim.new(0, 4); PaddingBottom = UDim.new(0, 4); Parent = Items.Value.Instance; PaddingRight = UDim.new(0, 4); PaddingLeft = UDim.new(0, 4)})

            Items.Value.Instance.TextTransparency = 0

            Items.Value.Instance:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
                local Value = Flags[self.Flag]
                local Text = Items.Value.Instance.Text
                local IsTable = type(Value) == "table"

                if (Text == Value or (IsTable and table.find(Value, Text))) then 
                    Items.Value.Instance.TextColor3 = Themes.Preset.Accent
                end  
            end)

            local Hover = function()
                local Value = Flags[self.Flag]
                local Text = Items.Value.Instance.Text
                local IsTable = type(Value) == "table"

                if not (Text == Value or (IsTable and table.find(Value, Text))) then 
                    Items.Value:Tween({TextColor3 = Themes.Preset.TextMain})
                end 
            end 

            local NoHover = function()
                local Value = Flags[self.Flag]
                local Text = Items.Value.Instance.Text
                local IsTable = type(Value) == "table"

                if not (Text == Value or (IsTable and table.find(Value, Text))) then 
                    Items.Value:Tween({TextColor3 = Themes.Preset.TextMisc})
                end 
            end 

            Items.Value:OnHover(Hover, NoHover)

            table.insert(self.OptionInstances, Items)

            return Items
        end 

        Library.RefreshList = function(self, Options)
            local Items = self.Items

            for _, Option in self.OptionInstances do
                Option.Value.Instance:Destroy()
            end
            
            self.OptionInstances = {}

            for _, Option in Options do
                local Object = self:RenderListOption(Option)
                local Button = Object.Value
                local Text = Object.Value.Instance.Text
                    
                Button:OnClick(function()
                    if self.Multi then
                        local Selected = table.find(self.MultiItems, Text)

                        if Selected then
                            table.remove(self.MultiItems, Selected)
                        else
                            table.insert(self.MultiItems, Text)
                        end

                        self.Set(self.MultiItems)
                    else
                        self.Set(Text)
                    end
                end)
            end
        end

        Library.UpdateDropdownPosition = function(self, Bool, Debounce)
            local Items = self.Items

            local YOffset = 82
            local Position = Items.Outline.Instance.AbsolutePosition
            local Width = Library:Round(Position.X, 0.5)
            local FrameWidth = Library:Round(Items.Outline.Instance.AbsoluteSize.X, 0.5)

            Items.DropdownHolder.Instance.Size = UDim2.fromOffset(FrameWidth,
            Items.DropdownHolder.Instance.AbsoluteSize.Y)

            if Debounce then
                Items.DropdownHolder.Instance.Position = UDim2.fromOffset(Width, math.floor(Position.Y + YOffset))

                return
            end

            if Bool then
                Items.DropdownHolder.Instance.Position = UDim2.fromOffset(Width, math.floor(Position.Y + (YOffset - 15)))
                Items.DropdownHolder:Tween({ Position = UDim2.fromOffset(Width, math.floor(Position.Y + YOffset)) })
            else
                Items.DropdownHolder:Tween({ Position = UDim2.fromOffset(Width, math.floor(Position.Y + (YOffset - 15))) })
            end
        end

        -- // Keybind 
        Library.SetMode = function(self, Mode)
            local Items = self.Items;
            self.Mode = Mode

            if Mode == "Always" then
                self.Set(true)
            elseif Mode == "Hold" then
                self.Set(false)
            end

            Flags[self.Flag].Mode = Mode
        end

        Library.NewKey = function(self)
            if self.Binding then
                return
            end

            task.wait()

            local Items = self.Items

            Items.Value.Instance.Text = "Selecting"

            self.Binding = Library:Connect(Services.UserInputService.InputBegan, function(Input, GameProcessedEvent)
                if GameProcessedEvent then -- // Stops stuff like chatting clicking other buttons etc.
                    return
                end

                self.Set(Input.KeyCode ~= Enum.KeyCode.Unknown and Input.KeyCode or Input.UserInputType)

                self.Binding.Connection:Disconnect()
                self.Binding = nil
            end)
        end

        Library.UpdateKeyPickerPosition = function(self, Bool, Debounce)
            local Items = self.Items
                
            local YOffset = 81 - 5
            local Position = Items.Value.Instance.AbsolutePosition
            local Width = Library:Round(Position.X, 0.5)
            local FrameWidth = Library:Round(Items.Value.Instance.AbsoluteSize.X, 0.5)

            if Debounce then
                Items.Settings.Instance.Position = UDim2.fromOffset(Width, math.floor(Position.Y + YOffset))

                return
            end

            if Bool then
                Items.Settings.Instance.Position = UDim2.fromOffset(Width, math.floor(Position.Y + (YOffset - 15)))
                Items.Settings:Tween({ Position = UDim2.fromOffset(Width, math.floor(Position.Y + YOffset)) })
            else
                Items.Settings:Tween({ Position = UDim2.fromOffset(Width, math.floor(Position.Y + (YOffset - 15))) })
            end
        end

        -- // Colorpicker
        Library.Colorpicker = function(self, properties)
            local Cfg = {
                Text = properties.Text or properties.Name or properties.Title or "Color",
                Flag = properties.Flag or properties.Name or properties.Title or properties.Text or Library:NextFlag(),
                Callback = properties.Callback or function() end,

                Color = properties.Color or Color3.fromRGB(1, 1, 1),
                Alpha = properties.Alpha or properties.Transparency or 0,
                Colors = properties.Colors or {},

                Open = false,
                PageCount = 0;
                Items = {},
                OldTab; 
                Tweening = false,

                Type = properties.Type or "Animation", -- // Terminating condition
                Colorpickers = {},
                ColorpickerMetadata = {},

                DataElements = self.DataElements,
            }   

            local DraggingSat = false
            local DraggingHue = false
            local DraggingAlpha = false

            local h, s, v = Cfg.Color:ToHSV()
            local a = Cfg.Alpha

            local OldHue = h;
            local OldAlpha = a;

            local Colorpicker = setmetatable(Cfg, Library)

            local Items = Cfg.Items; do
                -- // Label
                Items.ComponentsHolder = self.Items.ComponentsHolder

                if not self.Items.ComponentsHolder then
                    local Label = self:AddLabel({ Text = Cfg.Text })
                    Items.ComponentsHolder = Label.Items.ComponentsHolder
                    
                    Label.Items.Label.Instance.Position = UDim2.new(0, 0, 0, 3)
                end

                -- // Button 
                Items.Object = Library:Create("TextButton",{Parent = Items.ComponentsHolder.Instance; Size = UDim2.new(0, 24, 0, 12); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["Outline"]}):Themify("Outline", "BackgroundColor3")
                Items.Object = Library:Create("Frame",{Parent = Items.Object.Instance; Position = UDim2.new(0, 1, 0, 1); Size = UDim2.new(1, -2, 1, -2); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.UIGradient = Library:Create("UIGradient",{Rotation = 90; Parent = Items.Object.Instance; Color = ColorSeq{ColorKey(0, Color3.fromRGB(255, 255, 255)), ColorKey(1, Color3.fromRGB(148, 148, 148))}})

                -- // Object
                Items.Outline = Library:Create("TextButton",{Visible = false; Parent = Library.Other.Instance; Size = UDim2.new(0, 218, 0, 248); Position = UDim2.new(0, 281, 0, 575); BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.Y; BackgroundColor3 = Themes.Preset["Outline"]}):Themify("Outline", "BackgroundColor3"):Reparent(Library.Items.Instance):Resizify()
                Items.UIPadding = Library:Create("UIPadding",{PaddingBottom = UDim.new(0, 2); Parent = Items.Outline.Instance})
                Items.Inline = Library:Create("Frame",{Parent = Items.Outline.Instance; Position = UDim2.new(0, 1, 0, 1); Size = UDim2.new(1, -2, 1, 0); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["Inline"]}):Themify("Inline", "BackgroundColor3")
                Items.UIPadding = Library:Create("UIPadding",{PaddingBottom = UDim.new(0, 2); Parent = Items.Inline.Instance})
                Items.Colorpicker = Library:Create("Frame",{Parent = Items.Outline.Instance; Size = UDim2.new(1, -2, 1, -2); Position = UDim2.new(0, 1, 0, 1); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["Inline"]}):Themify("Inline", "BackgroundColor3")
                Items.Background = Library:Create("Frame",{Parent = Items.Colorpicker.Instance; Position = UDim2.new(0, 1, 0, 1); Size = UDim2.new(1, -2, 1, -2); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["SectionBackground"]}):Themify("SectionBackground", "BackgroundColor3")
                Items.TabButtonOutline = Library:Create("Frame",{ClipsDescendants = true; Parent = Items.Colorpicker.Instance; Position = UDim2.new(0, 1, 0, 1); Size = UDim2.new(1, -2, 0, 25); ZIndex = 2; BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["TabButtonUnselected"]}):Themify("TabButtonUnselected", "BackgroundColor3")
                Items.InlineLine = Library:Create("Frame",{Parent = Items.TabButtonOutline.Instance; Position = UDim2.new(0, 0, 1, -1); Size = UDim2.new(1, 0, 0, 1); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["Inline"]}):Themify("Inline", "BackgroundColor3")
                Items.OutlineLine = Library:Create("Frame",{Parent = Items.TabButtonOutline.Instance; Position = UDim2.new(0, 0, 1, -2); Size = UDim2.new(1, 0, 0, 1); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["Outline"]}):Themify("Outline", "BackgroundColor3")
                Items.TabButtonHolder = Library:Create("Frame",{Parent = Items.TabButtonOutline.Instance; BackgroundTransparency = 1; Size = UDim2.new(1, 0, 1, -2); ZIndex = 2; BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.UIListLayout = Library:Create("UIListLayout",{FillDirection = Enum.FillDirection.Horizontal; HorizontalFlex = Enum.UIFlexAlignment.Fill; Parent = Items.TabButtonHolder.Instance; Padding = UDim.new(0, 1); SortOrder = Enum.SortOrder.LayoutOrder; VerticalFlex = Enum.UIFlexAlignment.Fill})
                Items.UIPadding = Library:Create("UIPadding",{PaddingBottom = UDim.new(0, -2); Parent = Items.Colorpicker.Instance})
                -- Items.UIStroke = Library:Create("UIStroke",{Parent = Items.Outline.Instance; LineJoinMode = Enum.LineJoinMode.Miter}):Themify("Outline", "Color")
            end

            local Page2 = Colorpicker:CreateColorpickerPage({Name = "Color"}); do 
                Page2.Items.Page.Instance.Size = UDim2.new(1, -8, 1, -29)
                Page2.Items.Page.Instance.Position = UDim2.new(0, 4, 0, 29)
                
                Items.Elements = Page2.Items.Page
                Items.Elements.Instance.AutomaticSize = Enum.AutomaticSize.None 

                Items.SatValBackground = Library:Create("Frame",{AnchorPoint = Vector2.new(0, 1); Parent = Items.Elements.Instance; Position = UDim2.new(0, 0, 1, -48); Size = UDim2.new(1, -44, 1, -48); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["Outline"]}):Themify("Outline", "BackgroundColor3")
                Items.Inline = Library:Create("Frame",{Parent = Items.SatValBackground.Instance; Position = UDim2.new(0, 1, 0, 1); Size = UDim2.new(1, -2, 1, -2); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["Inline"]}):Themify("Inline", "BackgroundColor3")
                Items.ColorpickerBackground = Library:Create("Frame",{Parent = Items.Inline.Instance; Position = UDim2.new(0, 1, 0, 1); Size = UDim2.new(1, -2, 1, -2); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(0, 208, 255)})
                Items.SatValPickerHolder = Library:Create("Frame",{Parent = Items.ColorpickerBackground.Instance; BackgroundTransparency = 1; Position = UDim2.new(0, 2, 0, 2); Size = UDim2.new(1, -4, 1, -4); ZIndex = 100; BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.SatValPicker = Library:Create("Frame",{AnchorPoint = Vector2.new(0.5, 0.5); Parent = Items.SatValPickerHolder.Instance; Position = UDim2.new(0.5, 0, 0.5, 0); Size = UDim2.new(0, 2, 0, 2); ZIndex = 100; BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.HueOutlinePicker = Library:Create("UIStroke",{Color = Color3.fromRGB(52, 52, 52); LineJoinMode = Enum.LineJoinMode.Miter; Parent = Items.SatValPicker.Instance})
                Items.Saturation = Library:Create("Frame",{Parent = Items.ColorpickerBackground.Instance; Size = UDim2.new(1, 0, 1, 0); ZIndex = 2; BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.UIGradient = Library:Create("UIGradient",{Rotation = 270; Transparency = NumSeq{NumKey(0, 0), NumKey(1, 1)}; Parent = Items.Saturation.Instance; Color = ColorSeq{ColorKey(0, Color3.fromRGB(0, 0, 0)), ColorKey(1, Color3.fromRGB(0, 0, 0))}})
                Items.Value = Library:Create("Frame",{Parent = Items.ColorpickerBackground.Instance; Size = UDim2.new(1, 0, 1, 0); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.UIGradient = Library:Create("UIGradient",{Parent = Items.Value.Instance; Transparency = NumSeq{NumKey(0, 0), NumKey(1, 1)}})
                Items.Hue = Library:Create("Frame",{AnchorPoint = Vector2.new(1, 0); Parent = Items.Elements.Instance; Position = UDim2.new(1, 0, 0, 0); Size = UDim2.new(0, 18, 1, -48); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["Outline"]}):Themify("Outline", "BackgroundColor3")
                Items.Inline = Library:Create("Frame",{AnchorPoint = Vector2.new(0, 1); Parent = Items.Hue.Instance; Position = UDim2.new(0, 1, 1, -1); Size = UDim2.new(1, -2, 1, -2); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["Inline"]}):Themify("Inline", "BackgroundColor3")
                Items.GradientHolder = Library:Create("Frame",{Parent = Items.Inline.Instance; Position = UDim2.new(0, 1, 0, 1); Size = UDim2.new(1, -2, 1, -2); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.UIGradient = Library:Create("UIGradient",{Rotation = 90; Parent = Items.GradientHolder.Instance; Color = ColorSeq{ColorKey(0, Color3.fromRGB(255, 0, 0)), ColorKey(0.17, Color3.fromRGB(255, 255, 0)), ColorKey(0.33, Color3.fromRGB(0, 255, 0)), ColorKey(0.5, Color3.fromRGB(0, 255, 255)), ColorKey(0.67, Color3.fromRGB(0, 0, 255)), ColorKey(0.83, Color3.fromRGB(255, 0, 255)), ColorKey(1, Color3.fromRGB(255, 0, 0))}})
                Items.Holder = Library:Create("Frame",{Parent = Items.GradientHolder.Instance; BackgroundTransparency = 1; Position = UDim2.new(0, 0, 0, 2); Size = UDim2.new(1, 0, 1, -4); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.HuePicker = Library:Create("Frame",{AnchorPoint = Vector2.new(0.5, 0.5); Parent = Items.Holder.Instance; Position = UDim2.new(0.5, 0, 0.5, 0); Size = UDim2.new(1, 0, 0, 1); ZIndex = 100; BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.UIStroke = Library:Create("UIStroke",{Parent = Items.HuePicker.Instance; LineJoinMode = Enum.LineJoinMode.Miter})
                Items.Alpha = Library:Create("Frame",{AnchorPoint = Vector2.new(1, 0); Parent = Items.Elements.Instance; Position = UDim2.new(1, -22, 0, 0); Size = UDim2.new(0, 18, 1, -48); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["Outline"]}):Themify("Outline", "BackgroundColor3")
                Items.Inline = Library:Create("Frame",{AnchorPoint = Vector2.new(0, 1); Parent = Items.Alpha.Instance; Position = UDim2.new(0, 1, 1, -1); Size = UDim2.new(1, -2, 1, -2); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["Inline"]}):Themify("Inline", "BackgroundColor3")
                Items.GradientHolder = Library:Create("Frame",{Parent = Items.Inline.Instance; Position = UDim2.new(0, 1, 0, 1); Size = UDim2.new(1, -2, 1, -2); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(0, 255, 204)})
                Items.Holder = Library:Create("Frame",{Parent = Items.GradientHolder.Instance; BackgroundTransparency = 1; Position = UDim2.new(0, 0, 0, 0); Size = UDim2.new(1, 0, 1, 0); ZIndex = 2; BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.AlphaPicker = Library:Create("Frame",{AnchorPoint = Vector2.new(0.5, 0.5); Parent = Items.Holder.Instance; Position = UDim2.new(0.5, 0, 0.5, 0); Size = UDim2.new(1, 0, 0, 1); ZIndex = 100; BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.UIStroke = Library:Create("UIStroke",{Parent = Items.AlphaPicker.Instance; LineJoinMode = Enum.LineJoinMode.Miter})
                Items.Gradient = Library:Create("ImageLabel",{ScaleType = Enum.ScaleType.Tile; Parent = Items.GradientHolder.Instance; Image = "rbxassetid://18274452449"; BackgroundTransparency = 1; Size = UDim2.new(1, 0, 1, 0); TileSize = UDim2.new(0, 4, 0, 4); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.UIGradient = Library:Create("UIGradient",{Rotation = -90; Transparency = NumSeq{NumKey(0, 0), NumKey(0.5, 0.7437499761581421), NumKey(1, 1)}; Parent = Items.Gradient.Instance})

                local Color = Cfg.Color
                local Elements = Items.Elements.Instance

                Items.Elements = Library:Create("Frame",{Parent = Elements; AnchorPoint = Vector2.new(0, 1); BackgroundTransparency = 1; Position = UDim2.new(0, 0, 1, -24); Size = UDim2.new(1, 0, 0, 0); BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.Y; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                local Section = setmetatable(Cfg, Library)
                Items.RgbInput = Section:AddInput({FocusLost = true, Flag = Cfg.Flag .. "_RGB", Placeholder = "", Default = string.format("%s, %s, %s", Library:Round(Color.R * 255), Library:Round(Color.G * 255), Library:Round(Color.B * 255)), Callback = function(Text)
                    if not (Text and Cfg.Set) then 
                        return 
                    end 

                    local r, g, b = Library:GroupRGB(Text)

                    if r and g and b then 
                        Cfg.Set(Color3.fromRGB(r, g, b), Cfg.Alpha)
                    else 
                        Cfg.Set(Cfg.Color, Cfg.Alpha)
                    end 
                end})

                Items.Elements = Library:Create("Frame",{Parent = Elements; AnchorPoint = Vector2.new(0, 1); BackgroundTransparency = 1; Position = UDim2.new(0, 0, 1, 0); Size = UDim2.new(1, 0, 0, 0); BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.Y; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                local Section = setmetatable(Cfg, Library)
                Items.HexInput = Section:AddInput({FocusLost = true, Placeholder = "", Default = Library:ConvertToHex(Color), Flag = Cfg.Flag .. "_ALPHA", Callback = function(Text)
                    if not (Text and Cfg.Set) then 
                        return
                    end 

                    local r, g, b = Library:ConvertFromHex(Text)

                    if r and g and b and Cfg.Set then 
                        Cfg.Set(Color3.new(r, g, b), Cfg.Alpha)
                    else 
                        Cfg.Set(Cfg.Color, Cfg.Alpha)
                    end 
                end})
            end 

            if Cfg.Type == "Animation" then 
                local Page = Colorpicker:CreateColorpickerPage({Name = "Settings"}); do 
                    local Section = Page.Items.Page:CreateElements({Size = UDim2.new(1, 0, 0, 0); Position = UDim2.new(0, 0, 0, -2)})
                    Section:AddDropdown({Name = "Mode", Options = {"Rainbow", "Fading", "Solid"}, Flag = Cfg.Flag.."_Animation", Default = "Solid"}) 

                    Section:AddColorPicker({Type = "Default", Flag = Cfg.Flag.."1", Default = Color3.fromRGB(255, 0, 0)})
                    Section:AddColorPicker({Type = "Default", Flag = Cfg.Flag.."2", Default = Color3.fromRGB(255, 255, 255)})

                    Section:AddSlider({Name = "Speed", Min = 0, Max = 100, Default = 50, Suffix = "%", Flag = Cfg.Flag.."_AnimationSpeed"})

                    table.insert(Section.DataElements, function()
                        if Page.Tweening or Page2.Tweening then
                            return true;  
                        end
                    end)

                    Items.Outline:OutsideClick(Cfg, Section.DataElements)
                end 

                local fps, acc = 60, 0
                Library:Connect(Services.RunService.RenderStepped, function(dt)
                    if Type == "Solid" then 
                        return 
                    end 
                    
                    acc += dt 
                    if not (acc >= 1/fps) then 
                        return 
                    end 

                    acc -= dt           

                    local Type = Flags[Cfg.Flag.."_Animation"]

                    local Speed = math.abs(math.sin(tick() * (Flags[Cfg.Flag .. "_AnimationSpeed"] / 25)))
                    
                    if Type == "Rainbow" then 
                        Cfg.Set(Color3.fromHSV(Speed, s, v), a)
                    elseif Type == "Fading" then 
                        local Color = Flags[Cfg.Flag.."1"].Color:Lerp(Flags[Cfg.Flag.."2"].Color, Speed)

                        Cfg.Set(
                            Color, 
                            Library:Lerp(
                                Flags[Cfg.Flag.."1"].Transparency, 
                                Flags[Cfg.Flag.."2"].Transparency, 
                                Speed
                            )
                        )
                    end 
                end)
            else 
                Items.Colorpicker:OutsideClick(Cfg)
                
                task.spawn(function()
                    repeat task.wait() until Cfg.OldTab 

                    Cfg.OldTab.Items.Right.Instance.Visible = false
                end)
            end 

            Cfg.SetVisible = function(Bool)
                if Cfg.Tweening then
                    return
                end

                Cfg.Open = Bool

                if (Cfg.Open == true) and Items.Outline.Instance.Visible then 
                    return
                end 

                local ColorpickerObject = Items.Object.Instance
                Items.Outline.Instance.Position = UDim2.new(0, ColorpickerObject.AbsolutePosition.X, 0, ColorpickerObject.AbsolutePosition.Y + (Cfg.Open and 64 or 79))
                Items.Outline:Tween({ Position = UDim2.new(0, ColorpickerObject.AbsolutePosition.X, 0, ColorpickerObject.AbsolutePosition.Y + (Cfg.Open and 79 or 64))})
                Items.Outline:TweenDescendants(Cfg.Open, Cfg)
                Items.Outline:ClampToScreen()
            end

            Cfg.UpdateColor = function()
                local Mouse = Services.UserInputService:GetMouseLocation()
                local Offset = Vector2.new(Mouse.X, Mouse.Y - GuiInset)

                if DraggingSat then
                    s = math.clamp((Offset - Items.Saturation.Instance.AbsolutePosition).X / Items.Saturation.Instance.AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp((Offset - Items.Saturation.Instance.AbsolutePosition).Y / Items.Saturation.Instance.AbsoluteSize.Y, 0, 1)
                elseif DraggingHue then
                    h = math.clamp((Offset - Items.Hue.Instance.AbsolutePosition).Y / Items.Hue.Instance.AbsoluteSize.Y, 0, 1)
                elseif DraggingAlpha then
                    a = 1 - math.clamp((Offset - Items.Alpha.Instance.AbsolutePosition).Y / Items.Alpha.Instance.AbsoluteSize.Y, 0, 1)
                end

                Cfg.Set()
            end

            Cfg.Set = function(Color, Alpha, Colors)
                if Color then
                    h, s, v = Color:ToHSV()
                end 

                if Alpha then
                    a = Alpha
                end

                local TweenInformation = TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
                local Flag = Flags[Cfg.Flag]

                Items.Object.Instance.BackgroundColor3 = Color3.fromHSV(h, s, v)
                Items.ColorpickerBackground.Instance.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                Items.GradientHolder.Instance.BackgroundColor3 = Color3.fromHSV(h, 1, 1)

                Items.SatValPicker:Tween({ Position = UDim2.new(s, 0, 1 - v, 0) }, TweenInformation)
                Items.AlphaPicker:Tween({ Position = UDim2.new(0.5, 0, 1 - a, 0) }, TweenInformation)
                Items.HuePicker:Tween({ Position = UDim2.new(0.5, 0, h, 0) }, TweenInformation)

                Color = Items.Object.Instance.BackgroundColor3

                Items.RgbInput.Items.Input.Instance.Text = string.format("%s, %s, %s", Library:Round(Color.R * 255), Library:Round(Color.G * 255), Library:Round(Color.B * 255))
                Items.HexInput.Items.Input.Instance.Text = Library:ConvertToHex(Color)

                Cfg.Color = Color 
                Cfg.Alpha = a

                Flags[Cfg.Flag] = {
                    Color = Color,
                    Transparency = a,
                    Colors = Cfg.Colors
                }

                Cfg.Callback(Color, a)
            end

            Cfg.DisableDragging = function()
                DraggingSat = false
                DraggingHue = false
                DraggingAlpha = false
            end

            Cfg.IsHovering = function()
                return Items.Outline:Hovering()
            end

            Items.Alpha:OnDrag(Cfg.UpdateColor, function(Dragging)
                if Dragging then
                    DraggingAlpha = true
                else
                    Cfg.DisableDragging()
                end
            end)

            Items.Hue:OnDrag(Cfg.UpdateColor, function(Dragging)
                if Dragging then
                    DraggingHue = true
                else
                    Cfg.DisableDragging()
                end
            end)

            Items.Saturation:OnDrag(Cfg.UpdateColor, function(Dragging)
                if Dragging then
                    DraggingSat = true
                else
                    Cfg.DisableDragging()
                end
            end)

            Items.Object:OnClick(function()
                Cfg.Open = not Cfg.Open

                Cfg.SetVisible(Cfg.Open)
            end)

            Colorpicker:SetupElement(Cfg.Color, Cfg.Alpha)

            return setmetatable(Cfg, Library)
        end

        Library.CreateColorpickerPage = function(self, Data)
            Data = Data or {}

            self.PageCount += 1

            local Cfg = {
                Text = Data.Name or Data.Text or Data.Title or "Tab"; 
                Tweeming = false;
                Colorpicker = self;
                Items = {};
                PageCount = self.PageCount;
            }

            local Items = Cfg.Items; do 
                -- // Button
                Items.Button = Library:Create("TextButton",{Active = false; Parent = self.Items.TabButtonHolder.Instance; BackgroundTransparency = 1; Selectable = false; TextTransparency = 1; BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.Text = Library:Create("TextLabel",{TextColor3 = Themes.Preset.TextMain; Text = Cfg.Text; Parent = Items.Button.Instance; BackgroundTransparency = 1; Size = UDim2.new(1, 0, 1, 0); BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.XY; BackgroundColor3 = Themes.Preset.Accent}):Themify("Accent", "BackgroundColor3")
                Items.Stroke = Library:Create("UIStroke",{Transparency = 1; Parent = Items.Button.Instance; ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
                Items.UIStroke = Library:Create("UIStroke",{Parent = Items.Text.Instance; LineJoinMode = Enum.LineJoinMode.Miter})
                Items.UIGradient = Library:Create("UIGradient",{Rotation = 90; Parent = Items.Button.Instance; Color = ColorSeq{ColorKey(0, Color3.fromRGB(38, 38, 38)), ColorKey(1, Themes.Preset.SectionBackground)}})
                Items.Filler = Library:Create("Frame",{Parent = Items.Button.Instance; BackgroundTransparency = 1; Position = UDim2.new(0, 0, 1, 0); Size = UDim2.new(1, 0, 0, 2); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset.SectionBackground})
                Items.Right = Library:Create("Frame",{Visible = false; Parent = Items.Button.Instance; BackgroundTransparency = 1; Position = UDim2.new(1, -1, 0, 0); Size = UDim2.new(0, 1, 1, 2); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(54, 54, 54)})
                Items.Left = Library:Create("Frame",{Visible = false; Parent = Items.Button.Instance; BackgroundTransparency = 1; Size = UDim2.new(0, 1, 1, 2); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(54, 54, 54)})
                
                -- // Page
                Items.Page = Library:Create("Frame",{Visible = false; Parent = self.Items.Background.Instance; BackgroundTransparency = 1; Position = UDim2.new(0, 4, 0, 29); Size = UDim2.new(1, -8, 0, 0); BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.Y; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                -- Items.UIListLayout = Library:Create("UIListLayout",{Parent = Items.Page.Instance; Padding = UDim.new(0, 4); SortOrder = Enum.SortOrder.LayoutOrder})
                Items.UIPadding = Library:Create("UIPadding",{PaddingBottom = UDim.new(0, 4); Parent = Items.Page.Instance})

                Items.Text.Instance:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
                    if self.OldTab == Cfg then 
                        Items.Text.Instance.TextColor3 = Themes.Preset.Accent
                    end 
                end)
            end 

            local Page = setmetatable(Cfg, Library)

            Items.Button:OnClick(function()
                Page:OpenColorpickerPage()
            end)

            if not self.OldTab then 
                Page:OpenColorpickerPage()
            end
            
            return Page
        end

        Library.OpenColorpickerPage = function(self, Data)
            if self.Tweening or self.Colorpicker.Tweening then 
                return 
            end 

            local OldTab = self.Colorpicker and self.Colorpicker.OldTab or nil

            local Items = self.Items

            if OldTab == self or (self.Tweening or (OldTab and OldTab.Tweening)) then
                return
            end

            if OldTab then
                local OldItems = OldTab.Items

                OldItems.Filler:Tween({BackgroundTransparency = 1})
                OldItems.Button:Tween({BackgroundTransparency = 1})
                OldItems.Left:Tween({BackgroundTransparency = 1})
                OldItems.Right:Tween({BackgroundTransparency = 1})
                OldItems.Stroke:Tween({Transparency = 1})
                OldItems.Text:Tween({TextColor3 = Themes.Preset.TextMain})

                OldItems.Page:TweenDescendants(false, OldTab)
            end

            Items.Button:Tween({BackgroundTransparency = 0})
            Items.Filler:Tween({BackgroundTransparency = 0})
            Items.Left:Tween({BackgroundTransparency = 0})
            Items.Right:Tween({BackgroundTransparency = 0})
            Items.Stroke:Tween({Transparency = 0})
            Items.Text:Tween({TextColor3 = Themes.Preset.Accent})

            Items.Page:TweenDescendants(true, self)
            
            local Order = self.PageCount 
            local Max = self.Colorpicker.PageCount 

            if Order == 1 then 
                Items.Left.Instance.Visible = false;
                Items.Right.Instance.Visible = true;       
            elseif Order == Max then 
                Items.Left.Instance.Visible = true;
                Items.Right.Instance.Visible = false;
            else 
                Items.Left.Instance.Visible = true;
                Items.Right.Instance.Visible = true;
            end 

            self.Colorpicker.OldTab = self
        end 

        -- // Tooltip
        Library.Tooltip = function(self, Data)
            Data = Data or {} 

            local Cfg = {
                Text = Data.Text or Data.Title or Data.Name; 
                MultiLine = Data.MultiLine or false;
                
                Items = {};
                Open = false;
            }

            local Items = Cfg.Items; do 
                Items.Outline = Library:Create("CanvasGroup",{GroupTransparency = 1; Parent = Library.Items.Instance; Size = UDim2.new(0, Data.MultiLine and 200 or 0, 0, 0); Position = UDim2.new(0, 30, 0, 0); BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.XY; BackgroundColor3 = Themes.Preset["Outline"]}):Themify("Outline", "BackgroundColor3")
                Items.Inline = Library:Create("Frame",{Parent = Items.Outline.Instance; Position = UDim2.new(0, 1, 0, 1); Size = UDim2.new(1, -2, 1, 0); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["Inline"]}):Themify("Inline", "BackgroundColor3")
                Items.Background = Library:Create("Frame",{Parent = Items.Inline.Instance; Position = UDim2.new(0, 1, 0, 1); Size = UDim2.new(1, -2, 1, 0); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.UIGradient = Library:Create("UIGradient",{Rotation = 90; Parent = Items.Background.Instance; Color = ColorSeq{ColorKey(0, Color3.fromRGB(38, 38, 38)), ColorKey(1, Color3.fromRGB(25, 25, 25))}})
                Items.Text = Library:Create("TextLabel",{TextColor3 = Themes.Preset.TextMain; Text = Cfg.Text; Parent = Items.Background.Instance; Position = UDim2.new(0, 4, 0, 4); BorderSizePixel = 0; BackgroundTransparency = 1; TextXAlignment = Enum.TextXAlignment.Left; RichText = true; AutomaticSize = Enum.AutomaticSize.XY; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                Items.UIStroke = Library:Create("UIStroke",{Parent = Items.Text.Instance; LineJoinMode = Enum.LineJoinMode.Miter})
                Items.UIPadding = Library:Create("UIPadding",{PaddingBottom = UDim.new(0, 3); PaddingTop = UDim.new(0, 1); PaddingRight = UDim.new(0, 7); Parent = Items.Text.Instance})
                Items.UIPadding = Library:Create("UIPadding",{PaddingBottom = UDim.new(0, 2); Parent = Items.Inline.Instance})
                Items.UIPadding = Library:Create("UIPadding",{PaddingBottom = UDim.new(0, 2); Parent = Items.Outline.Instance})
            end 

            self.Items.Object.Instance.MouseEnter:Connect(function()
                Items.Outline:Tween({GroupTransparency = 0})
                Cfg.Open = true
            end)
                
            self.Items.Object.Instance.MouseLeave:Connect(function()
                Items.Outline:Tween({GroupTransparency = 1})
                Cfg.Open = false 
            end)

            Library:Connect(Services.UserInputService.InputChanged, function(Input, game_event)
                if Cfg.Open and Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    Items.Outline:Tween({Position = UDim2.fromOffset(Input.Position.X + 5, Input.Position.Y + 80)})
                end
            end)

            return setmetatable(Cfg, Library)
        end

        -- // Playerlist
        local Colors = {
            ["Neutral"] = Color3.fromRGB(171, 168, 168),
            ["Enemy"] = Color3.fromRGB(255, 0, 0),
            ["LocalPlayer"] = Themes.Preset.Accent
        }

        Library.AddPlayer = function(self, Player)
            local Cfg = {Items = {}, Player = Player}

            local Items = Cfg.Items; do 
                Items.Holder = Library:Create( "TextButton", {
                    Parent = self.Items.Holder.Instance;
                    BackgroundTransparency = 1;
                    Size = UDim2.new(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })

                Items.Player = Library:Create( "TextLabel", {
                    Parent = Items.Holder.Instance;
                    TextColor3 = Themes.Preset.TextColor;
                    Text = string.format("%s (@%s)", Player.DisplayName, Player.Name);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    Size = UDim2.new(1, 0, 0, 0);
                    ClipsDescendants = true;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):Themify("Accent", "TextColor3")

                table.insert(self.Labels, Items.Player)

                Items.Seperator = Library:Create( "Frame", {
                    Parent = Items.Holder.Instance;
                    Size = UDim2.new(0, 3, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                })

                Items.Priority = Library:Create( "TextLabel", {
                    TextColor3 = Color3.fromRGB(171, 168, 168);
                    Text = "Neutral";
                    Parent = Items.Holder.Instance;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    Size = UDim2.new(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):Themify("Accent", "TextColor3")

                Library:Create( "UIPadding", {
                    PaddingRight = UDim.new(0, 8);
                    Parent = Items.Priority.Instance
                })

                Library:Create( "UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                    Parent = Items.Holder.Instance;
                    Padding = UDim.new(0, 8);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })
            end 

            local PlayerData = setmetatable(Cfg, Library)

            self.Data[Player.Name] = PlayerData

            Items.Holder:OnClick(function()
                Cfg.Switch()
            end)

            Cfg.Filter = function(Text)
                if string.find(string.lower(Items.Player.Instance.Text .. " " .. Items.Priority.Instance.Text), string.lower(Text)) then 
                    Items.Holder.Instance.Visible = true 
                else 
                    Items.Holder.Instance.Visible = false
                end 
            end 

            Cfg.Switch = function()
                if self.Selected == PlayerData then 
                    return 
                end 
                
                if self.Selected then 
                    self.Selected.Items.Player.Instance.TextColor3 = Themes.Preset.TextColor
                end 

                self.ImageBox:SetImage(Services.Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48))
                self.Name.ChangeText("Name: "..Player.Name)
                self.DisplayName.ChangeText("DisplayName: "..Player.DisplayName)
                self.UserId.ChangeText("UserId: "..Player.UserId)
                Items.Player.Instance.TextColor3 = Themes.Preset.Accent

                self.Selected = PlayerData
            end 

            return PlayerData
        end 

        Library.RemovePlayer = function(self, Player)
            self.Data[Player.Name].Items.Holder.Instance:Destroy()
        end

        Library.GetPriority = function(self, Player)
            if not self.Data[Player.Name] then 
                return 
            end 

            return self.Data[Player.Name].Items.Priority.Instance.Text -- Holy string
        end 

        Library.SetPriority = function(self, Priority)
            if self.Player.Name == Services.Players.LocalPlayer.Name then 
                self.Items.Priority.Instance.Text = "LocalPlayer"
                self.Items.Priority:Tween({TextColor3 = Themes.Preset.Accent})

                return
            end 
            
            self.Items.Priority.Instance.Text = Priority
            self.Items.Priority:Tween({TextColor3 = Colors[Priority]})
        end 

        do -- // Notification Library
            local YOffset = 0 
            local BiggestX = 0 

            Library.Notify = function(self, Data)
                Data = Data or {} 

                local Cfg = {
                    Text = Data.Title or Data.Name or Data.Text or "Title";
                    Lifetime = Data.Lifetime or 5; 
                    
                    Items = {};
                    Status = true;
                    Fade = 2;
                    Tick = tick();
                    Index = #self.Notifications + 1
                }
                
                local Items = Cfg.Items; do 
                    Items.Notification = Library:Create("CanvasGroup",{GroupTransparency = 1; Parent = Library.Items.Instance; Size = UDim2.new(0, 0, 0, 0); Position = UDim2.new(0, 30, 0, 435); BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.XY; BackgroundColor3 = Themes.Preset["Outline"]}):Themify("Outline", "BackgroundColor3")
                    Items.Inline = Library:Create("Frame",{Parent = Items.Notification.Instance; Position = UDim2.new(0, 1, 0, 1); Size = UDim2.new(1, -2, 1, 0); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["Inline"]}):Themify("Inline", "BackgroundColor3")
                    Items.Background = Library:Create("Frame",{Parent = Items.Inline.Instance; Position = UDim2.new(0, 1, 0, 1); Size = UDim2.new(1, -2, 1, 0); BorderSizePixel = 0; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                    Items.UIGradient = Library:Create("UIGradient",{Rotation = 90; Parent = Items.Background.Instance; Color = ColorSeq{ColorKey(0, Themes.Preset["High Contrast"]), ColorKey(1, Themes.Preset["Low Contrast"])}})
                    Items.Title = Library:Create("TextLabel",{TextColor3 = Themes.Preset.TextMain; Text = Cfg.Text; Parent = Items.Background.Instance; BorderSizePixel = 0; BackgroundTransparency = 1; Position = UDim2.new(0, 4, 0, 4); RichText = true; AutomaticSize = Enum.AutomaticSize.XY; BackgroundColor3 = Color3.fromRGB(255, 255, 255), TextColor3 = Themes.Preset.TextMain})
                    Items.UIStroke = Library:Create("UIStroke",{Parent = Items.Title.Instance; LineJoinMode = Enum.LineJoinMode.Miter})
                    Items.UIPadding = Library:Create("UIPadding",{PaddingBottom = UDim.new(0, 3); PaddingRight = UDim.new(0, 7); Parent = Items.Title.Instance})
                    Items.UIPadding = Library:Create("UIPadding",{PaddingBottom = UDim.new(0, 2); Parent = Items.Inline.Instance})
                    Items.UIPadding = Library:Create("UIPadding",{PaddingBottom = UDim.new(0, 2); Parent = Items.Notification.Instance})
                    Items.Accent = Library:Create("Frame",{Parent = Items.Notification.Instance; Position = UDim2.new(0, 2, 1, -1); Size = UDim2.new(0, 0, 0, 1); BorderSizePixel = 0; BackgroundColor3 = Themes.Preset["Accent"]}):Themify("Accent", "BackgroundColor3")
                end     

                self.Notifications[Cfg.Index] = Cfg 
                Items.Accent:Tween({Size = UDim2.new(0, Items.Notification.Instance.AbsoluteSize.X - 4, 0, 1)}, TweenInfo.new(Cfg.Lifetime, Library.EasingStyle, Library.EasingDirection, 0, false, 0))

                task.delay(Cfg.Lifetime + 1, function()
                    Items.Notification.Instance:Destroy() 
                    self.Notifications[Cfg.Index] = nil 
                end)

                return setmetatable(Cfg, Library)
            end 

            Library.LerpObjects = function(self)
                YOffset = 0
                BiggestX = 0

                local Tick = tick()
                for _,Object in self.Notifications do
                    Object.Fade = Library:Lerp(Object.Fade, Object.Status and 255 or 0, 0.02)
                        
                    if Tick - Object.Tick >= Object.Lifetime then 
                        Object.Status = false 
                    end     

                    local Instance = Object.Items.Notification.Instance

                    local Offset = UDim2.new(0, 30, 0, 80) 
                    local Transparency = 1 - (1 * (Object.Fade / 255))

                    Instance.Position = Offset + UDim2.new(0, -(Instance.AbsoluteSize.X - (Instance.AbsoluteSize.X * (Object.Fade / 255))), 0, YOffset)
                    Object:SetTransparency(Transparency)

                    if Object.Status and BiggestX < Instance.AbsoluteSize.X then
                        BiggestX = math.max(BiggestX, Instance.AbsoluteSize.X)
                    end

                    YOffset += (Instance.AbsoluteSize.Y + 6) * (Object.Fade / 255)
                end     
            end

            Library.SetTransparency = function(self, Num) 
                self.Items.Notification.Instance.GroupTransparency = Num
            end 
        end 

        do -- // Keybind List Library 
            local YOffset = 0 
            local BiggestX = 0 
            local KeybindListTransparency = 0 

            Library.AddHotKey = function(self, Data)
                Data = Data or {} 
                
                local Cfg = {
                    Lifetime = Data.Lifetime or 5; 

                    Items = {};
                    Status = true;
                    Fade = 2;
                    Tick = tick();
                    Index = #self.Keybinds + 1
                }   
                
                local Items = Cfg.Items; do 
                    Items.Keybind = Library:Create("CanvasGroup",{Parent = self.Window.Items.Elements.Instance; BackgroundTransparency = 1; BorderSizePixel = 0; AutomaticSize = Enum.AutomaticSize.XY; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                    Items.Title = Library:Create("TextLabel",{TextColor3 = Themes.Preset.TextMain; Text = Cfg.Text; Parent = Items.Keybind.Instance; BackgroundTransparency = 1; BorderSizePixel = 0; RichText = true; AutomaticSize = Enum.AutomaticSize.XY; BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                    Items.UIStroke = Library:Create("UIStroke",{Parent = Items.Title.Instance; LineJoinMode = Enum.LineJoinMode.Miter})
                    Items.UIPadding = Library:Create("UIPadding",{PaddingTop = UDim.new(0, 3); PaddingBottom = UDim.new(0, 3); Parent = Items.Keybind.Instance})
                end     

                function Cfg:ChangeText(Key, Name, Mode)
                    Items.Title.Instance.Text = string.format("[%s] %s (%s)", Key, Name, Mode)
                end 

                function Cfg:SetEnabled(Bool)
                    Cfg.Status = Bool
                end

                self.Keybinds[Cfg.Index] = Cfg 

                return setmetatable(Cfg, Library)
            end 

            Library.LerpKeybinds = function(self)
                YOffset = 0
                BiggestX = 0

                if not self.Window.KeybindListVisible then 
                    return 
                end 

                local Tick = tick()
                for _,Object in self.Keybinds do
                    Object.Fade = Library:Lerp(Object.Fade, Object.Status and 255 or 0, 0.02)  
                    local Instance = Object.Items.Keybind.Instance

                    local Offset = UDim2.new(0, 1, 0, 0) -- great pasting skills
                    local Transparency = 1 - (1 * (Object.Fade / 255))
                    
                    Instance.Position = Offset + UDim2.new(0, -(Instance.AbsoluteSize.X - (Instance.AbsoluteSize.X * (Object.Fade / 255))), 0, YOffset)
                    Object:SetKeypickerTransparency(Transparency)
                    
                    if Object.Status and BiggestX < Instance.AbsoluteSize.X then
                        BiggestX = math.max(BiggestX, Instance.AbsoluteSize.X * (Object.Fade / 255))
                    end

                    YOffset += (Instance.AbsoluteSize.Y + 5) * (Object.Fade / 255)
                end     

                local KbList = self.Window.Items.KeybindList.Instance 
                local Shown = BiggestX == 0
                KeybindListTransparency = Library:Lerp(KeybindListTransparency, Shown and 255 or 0, 0.05)

                if not Shown then                    
                    self.Window.Items.Elements.Instance.Size = UDim2.new(1, -8, 0, YOffset)
                    self.Window.Items.KeybindList.Instance.Size = UDim2.new(0, BiggestX + 17, 0, YOffset + 29)
                end

                KbList.GroupTransparency = KeybindListTransparency / 255
            end

            Library.SetKeypickerTransparency = function(self, Num) 
                self.Items.Keybind.Instance.GroupTransparency = Num
            end 
        end 
    end

    -- // Library Functions
    do
        -- // Data Library
        do
            Library.ConvertToHex = function(self, Color)
                local r = math.floor(Color.R * 255)
                local g = math.floor(Color.G * 255)
                local b = math.floor(Color.B * 255)
                return string.format("#%02X%02X%02X", r, g, b)
            end 

            Library.ConvertFromHex = function(self, Color)
                Color = Color:gsub("#", "")
                local r = tonumber(Color:sub(1, 2), 16) / 255
                local g = tonumber(Color:sub(3, 4), 16) / 255
                local b = tonumber(Color:sub(5, 6), 16) / 255
                return r, g, b
            end

            Library.GroupRGB = function(self, String)
                local Values = {}

                for Value in string.gmatch(String, "[^,]+") do
                    table.insert(Values, tonumber(Value))
                end

                if #Values == 3 then
                    return unpack(Values)
                else
                    return
                end
            end

            Library.ConvertEnum = function(self, enum)
                local EnumParts = {}

                for _, part in string.gmatch(tostring(enum), "[%w_]+") do
                    table.insert(EnumParts, part)
                end

                local EnumTable = tostring(enum)

                for i = 2, #EnumParts do
                    local EnumItem = EnumTable[EnumParts[i]]

                    EnumTable = EnumItem
                end

                return EnumTable
            end

            Library.Lerp = function(self, start, finish, t)
                t = t or 1 / 8

                return start * (1 - t) + finish * t
            end

            Library.Round = function(self, num, float)
                local Multiplier = 1 / (float or 1)
                return math.floor(num * Multiplier + 0.5) / Multiplier
            end

            Library.IsDecimal = function(self, Num)
                return math.floor(Num) ~= Num
            end

            Library.GetCalculatePosition = function(self, Position, Normal, Origin, Direction)
                local n = Normal;
                local d = Direction;
                local v = Origin - Position;

                local num = (n.x * v.x) + (n.y * v.y) + (n.z * v.z); -- Dot exists for vector3.new i think? idk im not good with math
                local den = (n.x * d.x) + (n.y * d.y) + (n.z * d.z);
                local a = -num / den;

                return Origin + (a * Direction);
            end
        end

        -- // Instance Library
        do
            Library.Create = function(self, Class, Options)
                local Info = {
                    Instance = Instance.new(Class),
                    Properties = Options,
                    Tweening = false,
                    Blur,
                }

                local Instance = Info.Instance
                local Mt = setmetatable(Info, Library)

                for Property, Value in Info.Properties do
                    if Property == "ScrollingBarImageColor3" then 
                        continue 
                    end 

                    Instance[Property] = Value
                end

                if Class == "TextButton" then
                    Instance.AutoButtonColor = false
                    Instance.Text = ""
                end

                if Class == "ScrollingFrame" then 
                    Instance.ScrollBarImageColor3 = Themes.Preset.Accent
                    Mt:Themify("Accent", "ScrollBarImageColor3")
                end 

                if Class == "TextLabel" or Class == "TextBox" or Class == "TextButton" then
                    Instance.FontFace = Fonts.Main
                    Instance.TextSize = 12
                    
                    if (not Info.Properties["TextColor3"]) then 
                        Instance.TextColor3 = Themes.Preset.TextMain
                    end
                end

                if Class == "ScreenGui" then
                    table.insert(self.Guis, Instance)
                end

                if Class == "UIGradient" then 
                    local KeyPoints = Instance.Color.Keypoints

                    for _,KeyPoint in KeyPoints do 
                        local Color = Color3ToRGB(KeyPoint.Value)

                        if #KeyPoints > 2 then 
                            break
                        end 

                        for Name,Value in Themes.Preset do 
                            if Color3ToRGB(Value) == Color then 
                                if not table.find(Themes.GradientsThemes, Name) then 
                                    table.insert(Themes.GradientsThemes, Name)
                                end

                                Mt:Themify(Name, "Color")
                            end 
                        end
                    end 
                end 

                local ColorProperties = Library:GetColors(Instance)

                if ColorProperties then 
                    for _,Property in ColorProperties do 
                        local Color = Color3ToRGB(Instance[Property])

                        for Name,Value in Themes.Preset do 
                            if Color3ToRGB(Value) == Color then 
                                Mt:Themify(Name, Property)
                            end 
                        end
                    end 
                end 

                Instance.Name = "\0"

                return Mt
            end

            Library.AddGlow = function(self, Options)
                Options = Options or {} 

                local Cfg = {
                    Amount = Options.Amount or 5;
                    DampingFactor = Options.DampingFactor or 0.4;
                    Parent = self.Instance;
                    Items = {};
                }   

                local Items = Cfg.Items; 

                for Outline = 0, Cfg.Amount do  
                    Items[tostring(Outline)] = Library:Create( "UIStroke", {
                        Parent = self.Instance;
                        Color = Color3.fromRGB(255, 255, 255);
                        LineJoinMode = Enum.LineJoinMode.Round;
                        BorderOffset = UDim.new(0, Outline);
                        Transparency = (Outline / (Cfg.Amount + Cfg.DampingFactor))
                    })

                    Library:Create( "UIGradient", {
                        Parent = Items[tostring(Outline)].Instance;
                        Transparency = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, Cfg.DampingFactor),
                            NumberSequenceKeypoint.new(1, Cfg.DampingFactor)
                        }
                    })
                end

                table.insert(Library.Glows, Cfg)

                return self
            end

            Library.Resizify = function(self)
                local Instance = self.Instance

                local Resizing = Library:Create("TextButton", {
                    Position = UDim2.new(1, -10, 1, -10),
                    Size = UDim2.new(0, 10, 0, 10),
                    BorderSizePixel = 0,
                    Parent = Instance,
                    BackgroundTransparency = 1,
                    ZIndex = 9e9,
                    Text = ""
                })

                local IsResizing = false
                local Size;
                local InputLost;
                local ParentSize = Instance.Size

                Resizing.Instance.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        IsResizing = true
                        InputLost = Input.Position
                        Size = Instance.Size
                    end
                end)

                Resizing.Instance.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        IsResizing = false
                    end
                end)

                Library:Connect(Services.UserInputService.InputChanged, function(Input, game_event)
                    if IsResizing and Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                        self:Tween({
                            Size = UDim2.new(
                                Size.X.Scale,
                                math.clamp(Size.X.Offset + (Input.Position.X - InputLost.X), ParentSize.X.Offset,
                                    Camera.ViewportSize.X),
                                Size.Y.Scale,
                                math.clamp(Size.Y.Offset + (Input.Position.Y - InputLost.Y), ParentSize.Y.Offset,
                                    Camera.ViewportSize.Y)
                            )
                        }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))
                    end
                end)

                return self
            end

            Library.Hovering = function(self) -- Kinda old
                if self == nil then
                    return
                end

                local y_cond = self.Instance.AbsolutePosition.Y <= Mouse.Y and
                Mouse.Y <= self.Instance.AbsolutePosition.Y + self.Instance.AbsoluteSize.Y
                local x_cond = self.Instance.AbsolutePosition.X <= Mouse.X and
                Mouse.X <= self.Instance.AbsolutePosition.X + self.Instance.AbsoluteSize.X

                return (y_cond and x_cond)
            end

            Library.CheckHoveredItems = function(self, Cfg, Items)
                local Connection = Library:Connect(Services.UserInputService.InputBegan, function(Input)
                    if self.Instance.Visible == false or Cfg.Open == false then
                        return
                    end

                    local InputType = Input.UserInputType

                    if not (InputType == Enum.UserInputType.MouseButton1 or InputType == Enum.UserInputType.Touch) then
                        return
                    end

                    local Objects = Library.Items.Instance:GetGuiObjectsAtPosition(Mouse.X, Mouse.Y + GuiInset)

                    if not Items then
                        if not table.find(Objects, self.Instance) then
                            Cfg.SetVisible(false)
                        end
                    else
                        local Pass = true

                        for _, Item in Items do
                            if not table.find(Objects, Item.Instance) then
                                Pass = false
                            end
                        end
                    end

                    Cfg.SetVisible(Pass)
                end)

                return self
            end

            Library.Draggify = function(self)
                local Instance = self.Instance

                local Dragging = false
                local IntialSize = Instance.Position
                local InitialPosition
                Library.Dragging = false

                Instance.InputBegan:Connect(function(Input)
                    if not Library.Dragging and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
                        Dragging = true
                        Library.Dragging = true
                        InitialPosition = Input.Position
                        InitialSize = Instance.Position
                    end
                end)

                Instance.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                        Library.Dragging = false
                    end
                end)

                Library:Connect(Services.UserInputService.InputChanged, function(Input, GameEvent)
                    if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                        local Horizontal = Camera.ViewportSize.X
                        local Vertical = Camera.ViewportSize.Y

                        local NewPosition = UDim2.new(
                            0,
                            InitialSize.X.Offset + (Input.Position.X - InitialPosition.X),
                            0,
                            InitialSize.Y.Offset + (Input.Position.Y - InitialPosition.Y)
                        )

                        self:Tween({ Position = NewPosition },
                            TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0,
                                false, 0))
                    end
                end)

                return self
            end 

            Library.ClampToScreen = function(self)
                local Parent = self
                local Horizontal = Camera.ViewportSize.X
                local Vertical = Camera.ViewportSize.Y

                local ClampedPosition = UDim2.new(
                    0,
                    math.clamp(
                        Parent.Instance.Position.X.Offset,
                        0,
                        Horizontal - Parent.Instance.Size.X.Offset
                    ),
                    0,
                    math.clamp(
                        Parent.Instance.Position.Y.Offset,
                        0,
                        Vertical - Parent.Instance.Size.Y.Offset
                    )
                )

                if Parent.Instance.Position ~= ClampedPosition then
                    Parent:Tween({Position = ClampedPosition}, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))
                end
            end

            Library.OnClick = function(self, Callback)
                local Connection = Library:Connect(self.Instance.InputBegan, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Callback()
                    end
                end)

                return Connection
            end

            Library.OnRightClick = function(self, Callback)
                local Connection = Library:Connect(self.Instance.InputBegan, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton2 or Input.UserInputType == Enum.UserInputType.Touch then
                        Callback()
                    end
                end)

                return self
            end

            Library.OnHover = function(self, Callback1, Callback2)
                Callback2 = Callback2 or function() end

                Library:Connect(self.Instance.MouseEnter, function()
                    Callback1()
                end)

                Library:Connect(self.Instance.MouseLeave, function()
                    Callback2()
                end)

                return self
            end

            Library.OnDrag = function(self, Callback1, Callback2)
                local Dragging = false
                Callback2 = Callback2 or function() end

                self.Instance.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        Callback2(Dragging)
                    end
                end)

                Library:Connect(Services.UserInputService.InputEnded, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                        Callback2(Dragging)
                    end
                end)

                Library:Connect(Services.UserInputService.InputChanged, function(Input)
                    if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                        Callback1(Input)
                    end
                end)

                return self
            end

            Library.Reparent = function(self, Parent)
                Parent = Parent or self.Instance.Parent

                local Connection = Library:Connect(self.Instance:GetPropertyChangedSignal("Visible"), function()
                    local Visible = self.Instance.Visible

                    self.Instance.Parent = Visible and Parent or Library.Other.Instance
                end)

                return self
            end

            Library.OutsideClick = function(self, Cfg, Functions)
                local Connection = Library:Connect(Services.UserInputService.InputBegan, function(Input)
                    if self.Instance.Visible == false or Cfg.Open == false then
                        return
                    end
                    
                    local InputType = Input.UserInputType

                    if not (InputType == Enum.UserInputType.MouseButton1 or InputType == Enum.UserInputType.Touch) then
                        return
                    end

                    if Functions then
                        local Pass = false

                        if self:Hovering() then
                            Pass = true
                        end

                        for _, IsHovering in Functions do
                            if IsHovering() then
                                Pass = true
                            end
                        end

                        Cfg.SetVisible(Pass, true)

                        return
                    end

                    if not self:Hovering() then
                        
                        Cfg.SetVisible(false)
                    end
                end)

                return self
            end

            Library.Blurify = function(self, Strength)
                Strength = Strength or 0.90

                local Instance = self.Instance
                self.Strength = Strength

                local Part = Library:Create("Part", {
                    Material = Enum.Material.Glass,
                    Transparency = Strength,
                    Reflectance = 1,
                    CastShadow = false,
                    Anchored = true,
                    CanCollide = false,
                    CanQuery = false,
                    CollisionGroup = " ",
                    Size = Vector3.new(1, 1, 1) * 0.01,
                    Color = Color3.fromRGB(0, 0, 0),
                    Parent = Camera,
                });

                local BlockMesh = Library:Create("BlockMesh", {
                    Parent = Part.Instance,
                })

                local DepthOfField = Library:Create("DepthOfFieldEffect", {
                    Parent = Services.Lighting,
                    Enabled = true,
                    FarIntensity = 0,
                    FocusDistance = 0,
                    InFocusRadius = 1000,
                    NearIntensity = 1,
                    Name = ""
                })

                Library:Connect(Services.RunService.RenderStepped, function()
                    if not self.Instance.Visible then 
                        Part.Transparency = 1
                        Part.Instance.CFrame = CFrame.new(0/0, 9e9, 9e9)
                        return 
                    end    

                    local Corner0 = Instance.AbsolutePosition;
                    local Corner1 = Corner0 + Instance.AbsoluteSize;
                    
                    local Ray0 = Workspace.CurrentCamera.ScreenPointToRay(Workspace.CurrentCamera,Corner0.X, Corner0.Y, 1);
                    local Ray1 = Workspace.CurrentCamera.ScreenPointToRay(Workspace.CurrentCamera,Corner1.X, Corner1.Y, 1);

                    local Origin = Workspace.CurrentCamera.CFrame.Position + Workspace.CurrentCamera.CFrame.LookVector * (0.05 - Workspace.CurrentCamera.NearPlaneZ);

                    local Normal = Workspace.CurrentCamera.CFrame.LookVector;

                    local Pos0 = Library:GetCalculatePosition(Origin, Normal, Ray0.Origin, Ray0.Direction);
                    local Pos1 = Library:GetCalculatePosition(Origin, Normal, Ray1.Origin, Ray1.Direction);

                    Pos0 = Workspace.CurrentCamera.CFrame:PointToObjectSpace(Pos0);
                    Pos1 = Workspace.CurrentCamera.CFrame:PointToObjectSpace(Pos1);

                    local Size = Pos1 - Pos0;
                    local Center = (Pos0 + Pos1) / 2;

                    BlockMesh.Instance.Offset = Center
                    BlockMesh.Instance.Scale  = Size / 0.0101;

                    Part.Instance.CFrame = Workspace.CurrentCamera.CFrame;
                    Part.Instance.Transparency = self.Strength
                end)

                return self
            end
        end

        -- // Tween Library
        do
            Library.GetTransparency = function(self, obj)
                local Instance = obj

                if Instance:IsA("Frame") or Instance:IsA("CanvasGroup") then
                    return { "BackgroundTransparency" }
                elseif Instance:IsA("TextLabel") or Instance:IsA("TextButton") then
                    return { "TextTransparency", "BackgroundTransparency" }
                elseif Instance:IsA("ImageLabel") or Instance:IsA("ImageButton") then
                    return { "BackgroundTransparency", "ImageTransparency" }
                elseif Instance:IsA("ScrollingFrame") then
                    return { "BackgroundTransparency", "ScrollBarImageTransparency" }
                elseif Instance:IsA("TextBox") then
                    return { "TextTransparency", "BackgroundTransparency" }
                elseif Instance:IsA("UIStroke") then
                    return { "Transparency" }
                elseif Instance:IsA("BasePart") then
                    return { "Transparency" }
                end

                return nil
            end

            Library.GetColors = function(self, obj)
                local Instance = obj
                
                if Instance:IsA("Frame") or Instance:IsA("CanvasGroup") then
                    return { "BackgroundColor3" }
                elseif Instance:IsA("TextLabel") or Instance:IsA("TextButton") then
                    return { "TextColor3", "BackgroundColor3" }
                elseif Instance:IsA("ImageLabel") or Instance:IsA("ImageButton") then
                    return { "BackgroundColor3", "ImageColor3" }
                elseif Instance:IsA("ScrollingFrame") then
                    return { "BackgroundColor3", "ScrollBarImageColor3" }
                elseif Instance:IsA("TextBox") then
                    return { "TextColor3", "BackgroundColor3" }
                elseif Instance:IsA("UIStroke") then
                    return { "Color" }
                elseif Instance:IsA("BasePart") then
                    return { "Color" }
                end

                return nil
            end

            Library.Tween = function(self, Properties, Info, Obj)
                local Instance = self.Instance or Obj

                local Tween = Services.TweenService:Create(Instance,
                    Info or
                    TweenInfo.new(Library.TweeningSpeed, Library.EasingStyle, Enum.EasingDirection.Out, 0, false, 0),
                    Properties)
                Tween:Play()    

                if table.find(Properties, "TextColor3") then 
                    Tween.Completed:Connect(function()
                        print("Nigga")
                        self.Instance.TextColor3 = Properties.TextColor3
                    end)
                end

                return Tween
            end

            Library.Fade = function(self, obj, prop, vis)
                if not (prop and obj) then
                    return
                end

                local OldTransparency = obj[prop]
                obj[prop] = vis and 1 or OldTransparency

                local Animation = Library:Tween({ [prop] = vis and OldTransparency or 1 }, nil, obj)
                Library:Connect(Animation.Completed, function()
                    if not vis then
                        obj[prop] = OldTransparency
                    end
                end)

                return Animation
            end

            Library.TweenDescendants = function(self, Bool, Path)
                Path = Path or { Tweening = false }

                if Path.Tweening == true then
                    return
                end

                local Instance = self.Instance
                Path.Tweening = true

                if Bool then
                    if Instance:IsA("ScreenGui") then 
                        Instance.Enabled = true
                    else 
                        Instance.Visible = true
                    end 
                end

                local Children = Instance:GetDescendants()
                table.insert(Children, Instance)

                if self.Blur then
                    table.insert(Children, self.Blur)
                end

                local FadingAnimation;
                for _, obj in Children do
                    local Index = Library:GetTransparency(obj)

                    if not Index then
                        continue
                    end

                    if type(Index) == "table" then
                        for _, prop in Index do
                            FadingAnimation = Library:Fade(obj, prop, Bool)
                        end
                    else
                        FadingAnimation = Library:Fade(obj, Index, Bool)
                    end
                end

                Library:Connect(FadingAnimation.Completed, function()
                    Path.Tweening = false
                    if Instance:IsA("ScreenGui") then 
                        Instance.Enabled = Bool
                    else 
                        Instance.Visible = Bool
                    end 
                end)
            end
        end

        -- // Config
        do
            Library.CreateConfigButton = function(self, Data)
                Data = Data or {} 

                local Cfg = {
                    Name = Data.Name or Data.Text or "Config";
                    MakeConfig = Data.MakeConfig or true;
                    Selected = false;
                    Items = {};
                    Configs = self.Configs;
                } 

                local Items = Cfg.Items; do 
                    Items.NewConfig = Library:Create( "TextButton", {
                        TextColor3 = Color3.fromRGB(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        Parent = self.Items.Content.Instance;
                        Size = UDim2.new(1, 0, 0, 30);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Themes.Preset["ElementBackground"]
                    }):Themify("ElementBackground", "BackgroundColor3")

                    Library:Create( "UICorner", {
                        Parent = Items.NewConfig.Instance
                    })

                    Items.Stroke = Library:Create( "UIStroke", {
                        Color = Themes.Preset.ConfigOutline;
                        Parent = Items.NewConfig.Instance;
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }):Themify("ConfigOutline", "Color"):Themify("Accent", "Color")

                    Items.LoadButton = Library:Create( "ImageButton", {
                      ImageColor3 = Color3.fromRGB(200, 200, 207);
                        Parent = Items.NewConfig.Instance;
                        AutoButtonColor = false;
                        AnchorPoint = Vector2.new(1, 0.5);
                        Image = "rbxassetid://126165013650337";
                        BackgroundTransparency = 1;
                        Position = UDim2.new(1, -8, 0.5, -1);
                        Size = UDim2.new(0, 20, 0, 20);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    })

                    Items.OverwriteButton = Library:Create( "ImageButton", {
                        ImageColor3 = Color3.fromRGB(200, 200, 207);
                        Parent = Items.NewConfig.Instance;
                        AutoButtonColor = false;
                        AnchorPoint = Vector2.new(1, 0.5);
                        Image = "rbxassetid://77237686348397";
                        BackgroundTransparency = 1;
                        Position = UDim2.new(1, -34, 0.5, -1);
                        Size = UDim2.new(0, 20, 0, 20);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    })

                    Items.DeleteIcon = Library:Create( "ImageButton", {
                        ImageColor3 = Color3.fromRGB(200, 200, 207);
                        Parent = Items.NewConfig.Instance;
                        AutoButtonColor = false;
                        AnchorPoint = Vector2.new(1, 0.5);
                        Image = "rbxassetid://106573800301941";
                        BackgroundTransparency = 1;
                        Position = UDim2.new(1, -59, 0.5, -1);
                        Size = UDim2.new(0, 18, 0, 18);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    })

                    Items.ConfigName = Library:Create( "TextBox", {
                        Active = false;
                        Interactable = true;
                        AnchorPoint = Vector2.new(0, 0.5);
                        Size = UDim2.new(1, -90, 1, 0);
                        Parent = Items.NewConfig.Instance;
                        ClipsDescendants = true;
                        Text = Cfg.Name;
                        Selectable = true;
                        Position = UDim2.new(0, 10, 0.5, -1);
                        TextColor3 = Color3.fromRGB(200, 200, 207);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        ClearTextOnFocus = false;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    })
                end 

                local Button = setmetatable(Cfg, Library)
                
                function Cfg:SetVisible(Bool)
                    Items.NewConfig.Instance.Visible = Bool
                end 
                
                function Cfg:SetName(Text)
                    if Text == Cfg.Name then
                        return 
                    end 

                    local OldName = Cfg.Name

                    Cfg.Name = Text
                    Items.ConfigName.Instance.Text = Text

                    Library:ResaveConfig(Text, OldName);

                    Library:DeleteConfig(OldName)
                end

                Cfg.DestroyButton = function(Config) 
                    if Config then
                        Library:DeleteConfig(Cfg.Name)
                    end

                    Items.NewConfig.Instance:Destroy()

                    table.remove(Cfg.Configs, Cfg.Index)
                end

                Items.DeleteIcon:OnClick(function()
                    Cfg.DestroyButton(true)
                end)

                Items.LoadButton:OnClick(function()
                    if self.OldConfig then 
                        local OldItems = self.OldConfig.Items
                        OldItems.Stroke:Tween({Color = Themes.Preset.ConfigOutline})
                    end

                    Library:LoadConfig(Cfg.Name);
                    Items.Stroke:Tween({Color = Themes.Preset.Accent})

                    self.OldConfig = Button;
                end)
                
                Items.OverwriteButton:OnClick(function()
                    writefile(string.format("%s/%s/%s.Cfg", Library.Directory, "Configs", Cfg.Name), Returner or Library:GetConfig())
                end)

                Items.ConfigName.Instance.FocusLost:Connect(function()
                    Cfg:SetName(Items.ConfigName.Instance.Text)
                end)

                if Cfg.MakeConfig then 
                    Library:ResaveConfig(Cfg.Name, Cfg.Name);
                end 

                Cfg.Index = table.insert(self.Configs, Button)

                return Button
            end 

            Library.GetConfig = function(self)
                local Config = {}

                for Idx, Value in Flags do
                    if type(Value) == "table" and Value.Key then
                        Config[Idx] = {Active = Value.Active, Mode = Value.Mode, Key = tostring(Value.Key)}
                    elseif type(Value) == "table" and Value["Transparency"] and Value["Color"] then
                        Config[Idx] = {Transparency = Value["Transparency"], Color = Value["Color"]:ToHex()}
                    else
                        Config[Idx] = Value
                    end
                end 

                return Services.HttpService:JSONEncode(Config)
            end

            Library.LoadConfig = function(self, JSON) 
                local Config = Services.HttpService:JSONDecode(JSON)

                for Idx, Value in Config do  
                    local Function = ConfigFlags[Idx]

                    if string.find(Idx, "_RGB") or string.find(Idx, "_ALPHA") then 
                        continue 
                    end 

                    if Function then 
                        if type(Value) == "table" and Value["Transparency"] and Value["Color"] then
                            Function(Color3.fromHex(Value["Color"]), Value["Transparency"])
                        else 
                            Function(Value)
                        end
                    end 
                end 
            end 

            Library.DeleteConfig = function(self, Config)
                local Path = string.format("%s/%s/%s.Cfg", Library.Directory, "Configs", Config)
                if isfile(Path) then 
                    delfile(Path)
                end
            end

            Library.SaveConfig = function(self, Config)
                if Config == "" then 
                    return 
                end 

                local Path = string.format("%s/%s/%s.Cfg", Library.Directory, "Configs", Config)
                writefile(Path, self:GetConfig())
            end

            Library.AutoLoad = function(self)
                self.Window.Tweening = true 
                local Name = readfile(self.Directory.."/Autoload.txt")
                
                if Name ~= "" then 
                    for i = 1, 2 do 
                        self:LoadConfig(readfile(self.Directory .. "/Configs/" .. Name .. ".Cfg"))
                    end 
                end 
                self.Window.Tweening = false 
            end 

            Library.UpdateConfigList = function(self) 
                local List = {}
                
                for _, File in listfiles(Library.Directory .. "/Configs") do
                    local Name = File:gsub(Library.Directory .. "/Configs\\", ""):gsub(".Cfg", ""):gsub(Library.Directory .. "\\Configs\\", "")
                    List[#List + 1] = Name
                end

                self:RefreshList(List)
            end 

            Library.NextFlag = function(self)
                self.FlagCount += 1
                local String = "Flag "..tostring(self.FlagCount)
                
                return String
            end 
        end

        -- // Connections / Utility Library
        do
            Library.Thread = function(self, Function)
                local Thread = coroutine.create(Function)

                coroutine.wrap(function()
                    coroutine.resume(Thread)
                end)()

                table.insert(self.Threads, Thread)

                return Thread
            end

            Library.SafeCall = function(self, Function, ...)
                local Arguments = { ... }
                local Success, Result = pcall(Function, table.unpack(Arguments))

                if not Success then
                    warn(Result)
                    return false
                end

                return Success
            end

            Library.Connect = function(self, Signal, Callback)
                local ConnectionInfo = {
                    Event = Signal,
                    Callback = Callback,
                    Connection,
                }

                Library:Thread(function()
                    ConnectionInfo.Connection = Signal:Connect(Callback)
                end)

                table.insert(self.Connections, ConnectionInfo)

                return ConnectionInfo
            end

            Library.Delay = function(self)
                task.spawn(function()
                    self.Tweening = true
                    task.wait()
                    self.Tweening = false
                end)

                return self
            end

            Library.Unload = function(self)
                repeat task.wait() until #self.Notifications == 0

                for Index, Value in self.Connections do
                    if Value.Connection then
                        Value.Connection:Disconnect()
                    end
                end

                for Index, Value in self.Threads do
                    coroutine.close(Value)
                end

                for _, Item in self.Guis do
                    if Item then
                        Item:Destroy()
                        Item = nil
                    end
                end

                for _,Instance in self.Blurs do 
                    Instance:Destroy()
                end         

                Library = nil
                getgenv().Library = nil
            end
        end
    end
return getgenv().Library          
