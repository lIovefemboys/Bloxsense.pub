local Library; do
	local cloneref = (typeof(cloneref) == "function" and cloneref) or function(Object) return Object end
	local function Service(Name) return cloneref(game:GetService(Name)) end

	local Players = Service("Players")
	local UserInputService = Service("UserInputService")
	local RunService = Service("RunService")
	local TweenService = Service("TweenService")
	local HttpService = Service("HttpService")
	local Lighting = Service("Lighting")
	local Workspace = Service("Workspace")
	local GuiService = Service("GuiService")
	local Stats = Service("Stats")

	local LocalPlayer = Players.LocalPlayer

	local Env = (typeof(getgenv) == "function" and getgenv()) or _G
	if type(Env.SwiftLibrary) == "table" and type(Env.SwiftLibrary.Unload) == "function" then
		pcall(Env.SwiftLibrary.Unload, Env.SwiftLibrary)
	end

	Library = {
		Version = "1.0.0",
		Folder = "Swift",

		Flags = {},
		Elements = {},
		Keybinds = {},
		Connections = {},
		Threads = {},
		Windows = {},
		SearchIndex = {},
		PopupStack = {},
		AnimatedPickers = {},
		Notifications = {},

		Casing = "Normal",
		ThemeName = "Swift",
		TweenTime = 0.25,
		EasingStyle = Enum.EasingStyle.Quart,
		Unloaded = false,
		Listening = nil,
		MenuKeybind = Enum.KeyCode.RightShift,
		Font = "Inter",
	}
	Library.__index = Library
	Env.SwiftLibrary = Library

	local FS = {}; do
		local MemoryFiles = {}
		local function Has(Name) return typeof(Env[Name]) == "function" or typeof(getfenv()[Name]) == "function" end
		local function Get(Name) return Env[Name] or getfenv()[Name] end
		local Native = Has("writefile") and Has("readfile") and Has("isfile")

		FS.Native = Native
		function FS.MakeFolder(Path)
			if Native and Has("makefolder") then
				if not (Has("isfolder") and Get("isfolder")(Path)) then pcall(Get("makefolder"), Path) end
			end
		end
		function FS.Write(Path, Content)
			if Native then return pcall(Get("writefile"), Path, Content) end
			MemoryFiles[Path] = Content
			return true
		end
		function FS.Read(Path)
			if Native then
				local Ok, Result = pcall(Get("readfile"), Path)
				return Ok and Result or nil
			end
			return MemoryFiles[Path]
		end
		function FS.Exists(Path)
			if Native then
				local Ok, Result = pcall(Get("isfile"), Path)
				return Ok and Result
			end
			return MemoryFiles[Path] ~= nil
		end
		function FS.Delete(Path)
			if Native and Has("delfile") then pcall(Get("delfile"), Path) else MemoryFiles[Path] = nil end
		end
		function FS.List(Folder)
			local Out = {}
			if Native and Has("listfiles") then
				local Ok, Files = pcall(Get("listfiles"), Folder)
				if Ok then
					for _, File in Files do
						local Name = tostring(File):gsub("\\", "/"):match("([^/]+)$")
						table.insert(Out, Name)
					end
				end
			else
				for Path in MemoryFiles do
					local Dir, Name = Path:match("^(.*)/([^/]+)$")
					if Dir == Folder then table.insert(Out, Name) end
				end
			end
			table.sort(Out)
			return Out
		end
		Library.FS = FS
		FS.MakeFolder(Library.Folder)
		FS.MakeFolder(Library.Folder .. "/configs")
		FS.MakeFolder(Library.Folder .. "/fonts")
	end

	local Fonts = {
		Families = {
			["Inter"] = "rbxassetid://12187365364",
			["Gotham"] = "rbxasset://fonts/families/GothamSSm.json",
			["Montserrat"] = "rbxasset://fonts/families/Montserrat.json",
			["Roboto"] = "rbxasset://fonts/families/Roboto.json",
			["Source Sans"] = "rbxasset://fonts/families/SourceSansPro.json",
			["Builder Sans"] = "rbxasset://fonts/families/BuilderSans.json",
			["Ubuntu"] = "rbxasset://fonts/families/Ubuntu.json",
		},
		Order = { "Inter", "Gotham", "Montserrat", "Roboto", "Source Sans", "Builder Sans", "Ubuntu" },
		Registry = setmetatable({}, { __mode = "k" }),
		ESP = {
			Pixel = Font.fromEnum(Enum.Font.Code), Code = Font.fromEnum(Enum.Font.Code),
			Gotham = Font.fromEnum(Enum.Font.Gotham), Arial = Font.fromEnum(Enum.Font.Arial),
		},
	}
	Library.Fonts = Fonts

	function Fonts:Face(Weight)
		return Font.new(self.Families[Library.Font] or self.Families.Inter, Weight or Enum.FontWeight.Bold)
	end

	function Fonts:Refresh()
		self.Regular = self:Face(Enum.FontWeight.Regular)
		self.Medium = self:Face(Enum.FontWeight.Medium)
		self.SemiBold = self:Face(Enum.FontWeight.SemiBold)
		self.Bold = self:Face(Enum.FontWeight.Bold)
	end

	function Fonts:Apply(Object, Weight)
		self.Registry[Object] = Weight or Enum.FontWeight.Bold
		Object.FontFace = self:Face(self.Registry[Object])
	end

	function Fonts:Download(Name, Url)
		local Environment = getfenv()
		local GetAsset = Env.getcustomasset or Env.getsynasset or Environment.getcustomasset or Environment.getsynasset
		if not FS.Native or typeof(GetAsset) ~= "function" then return nil end
		local Base = Library.Folder .. "/fonts/" .. Name:gsub("%s", "")
		if not FS.Exists(Base .. ".ttf") then
			local Ok, Data = pcall(function() return game:HttpGet(Url) end)
			if not Ok or type(Data) ~= "string" or Data == "" then return nil end
			if not FS.Write(Base .. ".ttf", Data) then return nil end
		end
		if not FS.Write(Base .. ".json", HttpService:JSONEncode({ name = Name, faces = { { name = "Regular", weight = 400, style = "normal", assetId = GetAsset(Base .. ".ttf") } } })) then return nil end
		return GetAsset(Base .. ".json")
	end

	function Fonts:ESPFace(Name)
		if not self.ESP[Name] then Name = "Pixel" end
		if Name == "Pixel" and not self.PixelAttempted then
			self.PixelAttempted = true
			local Okay, Face = pcall(function()
				local Family = self:Download("Minecraftia-Regular", "https://github.com/gut7899/Storage/raw/refs/heads/main/Minecraftia-Regular.ttf")
				if type(Family) == "string" and Family ~= "" then return Font.new(Family, Enum.FontWeight.Regular) end
			end)
			if Okay and Face then self.ESP.Pixel = Face end
		end
		return self.ESP[Name]
	end

	function Library:AddFont(Name, Source)
		local Family = Source
		if type(Source) == "number" then
			Family = "rbxassetid://" .. Source
		elseif type(Source) == "table" then
			Family = Fonts:Download(Name, Source.Url)
		end
		if not Family then return false end
		Fonts.Families[Name] = Family
		if not table.find(Fonts.Order, Name) then table.insert(Fonts.Order, Name) end
		local Dropdown = Library.Elements.Font
		if Dropdown then Dropdown:SetOptions(Fonts.Order, true) end
		return true
	end

	function Library:SetFont(Name)
		if not Fonts.Families[Name] then return end
		Library.Font = Name
		Fonts:Refresh()
		for Object, Weight in Fonts.Registry do
			Object.FontFace = Fonts:Face(Weight)
		end
	end

	Fonts:Refresh()

	local Icons; do
		local function Thumb(Id) return "rbxthumb://type=Asset&id=" .. Id .. "&w=150&h=150" end
		Icons = {
			Logo = { Image = "rbxassetid://83222639901823", Logo = true },
			Bullseye = "rbxassetid://88639165254091",
			Smile = { Image = Thumb(11955884989), RectOffset = Vector2.new(20, 20), RectSize = Vector2.new(110, 110) },
			Globe = "rbxassetid://11887653877",
			Bomb = Thumb(13424571238),
			Gear = "rbxassetid://9753762469",
			Robot = Thumb(78007610361363),
			HeartCrack = Thumb(15331784488),
			Wrench = Thumb(11435662333),
			Cube = Thumb(9802015008),
			Search = { Image = Thumb(85365761530931), RectOffset = Vector2.new(14, 14), RectSize = Vector2.new(122, 122) },
			Check = "rbxassetid://18856185133",
			User = "rbxassetid://18854794412",
			Users = "rbxassetid://6479819618",
			Plus = "rbxassetid://139167062679792",
			Trash = "rbxassetid://88050953687180",
			Checker = "rbxassetid://18274452449",
			Warning = "rbxassetid://11745872910",
			Error = "rbxassetid://5419926701",
			Info = "rbxassetid://7634887649",
			Arrow = "rbxassetid://153287088",
			Brush = "rbxassetid://10910211661",
			Eye = "rbxassetid://6473251976",
			Key = "rbxassetid://18854840832",
			Gun = "rbxassetid://3189074890",
			Knife = "rbxassetid://2992801749",
			Crown = "rbxassetid://6458974334",
			Lock = "rbxassetid://15117261700",
			Circle = "rbxassetid://9208578430",
		}
		Library.Icons = Icons
	end

	local Rgb = Color3.fromRGB
	local ThemeKeys = { "Background", "Tab", "Outline", "Inline", "Text", "Inactive Text", "Accent", "Element", "Gradient", "Shadow", "Hovered Element" }
	local Themes = {
		["Swift"] = {
			Background = Rgb(28, 28, 28), Tab = Rgb(37, 37, 37), Outline = Rgb(45, 45, 45), Inline = Rgb(28, 28, 28),
			Text = Rgb(230, 230, 230), ["Inactive Text"] = Rgb(148, 148, 148), Accent = Rgb(168, 234, 181),
			Element = Rgb(54, 54, 54), Gradient = Rgb(240, 240, 240), Shadow = Rgb(0, 0, 0), ["Hovered Element"] = Rgb(61, 61, 61),
			Popup = Rgb(37, 37, 37), ToggleFill = Rgb(69, 141, 84), Knob = Rgb(235, 253, 238), KnobOff = Rgb(134, 134, 134),
		},
		["Blossom"] = {
			Background = Rgb(40, 40, 40), Tab = Rgb(43, 47, 48), Outline = Rgb(56, 60, 61), Inline = Rgb(31, 30, 28),
			Text = Rgb(220, 222, 235), ["Inactive Text"] = Rgb(125, 128, 135), Accent = Rgb(86, 137, 200),
			Element = Rgb(40, 44, 43), Gradient = Rgb(187, 191, 191), Shadow = Rgb(0, 0, 0), ["Hovered Element"] = Rgb(65, 70, 73),
		},
		["Afterglow"] = {
			Background = Rgb(28, 24, 21), Tab = Rgb(37, 31, 28), Outline = Rgb(51, 46, 42), Inline = Rgb(34, 29, 25),
			Text = Rgb(255, 248, 240), ["Inactive Text"] = Rgb(148, 139, 130), Accent = Rgb(250, 140, 70),
			Element = Rgb(40, 33, 27), Gradient = Rgb(253, 184, 117), Shadow = Rgb(0, 0, 0), ["Hovered Element"] = Rgb(56, 45, 35),
		},
		["Frostbite"] = {
			Background = Rgb(16, 25, 28), Tab = Rgb(24, 34, 41), Outline = Rgb(44, 55, 61), Inline = Rgb(22, 31, 38),
			Text = Rgb(245, 254, 255), ["Inactive Text"] = Rgb(138, 154, 164), Accent = Rgb(100, 200, 245),
			Element = Rgb(25, 38, 47), Gradient = Rgb(160, 211, 240), Shadow = Rgb(0, 0, 0), ["Hovered Element"] = Rgb(36, 53, 62),
		},
		["Volt"] = {
			Background = Rgb(14, 19, 13), Tab = Rgb(21, 28, 21), Outline = Rgb(42, 47, 40), Inline = Rgb(17, 24, 16),
			Text = Rgb(250, 255, 242), ["Inactive Text"] = Rgb(135, 147, 131), Accent = Rgb(185, 245, 90),
			Element = Rgb(24, 35, 19), Gradient = Rgb(186, 240, 101), Shadow = Rgb(0, 0, 0), ["Hovered Element"] = Rgb(38, 51, 32),
		},
		["Obsidian"] = {
			Background = Rgb(11, 12, 16), Tab = Rgb(19, 20, 24), Outline = Rgb(36, 37, 39), Inline = Rgb(15, 16, 18),
			Text = Rgb(250, 251, 254), ["Inactive Text"] = Rgb(121, 122, 126), Accent = Rgb(150, 122, 245),
			Element = Rgb(21, 22, 26), Gradient = Rgb(179, 167, 212), Shadow = Rgb(0, 0, 0), ["Hovered Element"] = Rgb(32, 36, 39),
		},
		["Sakura Drift"] = {
			Background = Rgb(28, 23, 27), Tab = Rgb(41, 30, 36), Outline = Rgb(54, 45, 50), Inline = Rgb(35, 26, 31),
			Text = Rgb(255, 249, 254), ["Inactive Text"] = Rgb(158, 142, 152), Accent = Rgb(245, 135, 180),
			Element = Rgb(46, 31, 38), Gradient = Rgb(252, 178, 212), Shadow = Rgb(0, 0, 0), ["Hovered Element"] = Rgb(56, 41, 48),
		},
		["Neon Mirage"] = {
			Background = Rgb(14, 17, 26), Tab = Rgb(22, 26, 44), Outline = Rgb(42, 45, 60), Inline = Rgb(17, 20, 35),
			Text = Rgb(243, 246, 255), ["Inactive Text"] = Rgb(134, 139, 166), Accent = Rgb(40, 230, 210),
			Element = Rgb(23, 30, 49), Gradient = Rgb(107, 216, 254), Shadow = Rgb(0, 0, 0), ["Hovered Element"] = Rgb(35, 42, 68),
		},
		["Copper Dust"] = {
			Background = Rgb(30, 27, 22), Tab = Rgb(42, 34, 25), Outline = Rgb(61, 54, 46), Inline = Rgb(38, 31, 25),
			Text = Rgb(250, 240, 231), ["Inactive Text"] = Rgb(150, 138, 126), Accent = Rgb(200, 135, 70),
			Element = Rgb(45, 33, 24), Gradient = Rgb(196, 181, 139), Shadow = Rgb(0, 0, 0), ["Hovered Element"] = Rgb(53, 45, 43),
		},
		["Abyss"] = {
			Background = Rgb(7, 14, 16), Tab = Rgb(13, 24, 29), Outline = Rgb(30, 40, 42), Inline = Rgb(9, 19, 21),
			Text = Rgb(225, 241, 247), ["Inactive Text"] = Rgb(112, 128, 134), Accent = Rgb(30, 185, 165),
			Element = Rgb(12, 25, 31), Gradient = Rgb(78, 181, 174), Shadow = Rgb(0, 0, 0), ["Hovered Element"] = Rgb(21, 39, 43),
		},
		["Porcelain"] = {
			Background = Rgb(233, 232, 227), Tab = Rgb(246, 245, 240), Outline = Rgb(204, 203, 197), Inline = Rgb(251, 250, 245),
			Text = Rgb(48, 49, 54), ["Inactive Text"] = Rgb(121, 121, 113), Accent = Rgb(72, 112, 197),
			Element = Rgb(236, 237, 241), Gradient = Rgb(160, 171, 193), Shadow = Rgb(84, 82, 83), ["Hovered Element"] = Rgb(225, 225, 217),
		},
	}
	local ThemeOrder = { "Swift", "Blossom", "Afterglow", "Frostbite", "Volt", "Obsidian", "Sakura Drift", "Neon Mirage", "Copper Dust", "Abyss", "Porcelain" }
	Library.Themes = Themes
	Library.ThemeOrder = ThemeOrder
	Library.ThemeKeys = ThemeKeys

	local Theme = {}
	local DerivedKeys = { Popup = "Inline", ToggleFill = "Accent", Knob = "Text", KnobOff = "Inactive Text" }
	local ExplicitDerived = {}
	local function LoadPreset(Preset)
		for Key, Value in Preset do Theme[Key] = Value end
		for Derived, Base in DerivedKeys do
			ExplicitDerived[Derived] = Preset[Derived] ~= nil
			Theme[Derived] = Preset[Derived] or Preset[Base]
		end
	end
	LoadPreset(Themes.Swift)
	Library.Theme = Theme

	local ThemeRegistry = setmetatable({}, { __mode = "k" })
	local GradientRegistry = setmetatable({}, { __mode = "k" })
	local ThemeCallbacks = {}

	local function GradientSequence()
		return ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1):Lerp(Theme.Gradient, 0.68))
	end

	function Library:Theme(Object, Property, Key)
		local Entry = ThemeRegistry[Object]
		if not Entry then
			Entry = {}
			ThemeRegistry[Object] = Entry
		end
		Entry[Property] = Key
		if Theme[Key] then Object[Property] = Theme[Key] end
		return Object
	end

	function Library:Unthemed(Object, Property)
		local Entry = ThemeRegistry[Object]
		if Entry then Entry[Property] = nil end
	end

	function Library:OnThemeChanged(Callback)
		table.insert(ThemeCallbacks, Callback)
	end

	function Library:SetThemeColor(Key, Color)
		if Theme[Key] == nil then return end
		Theme[Key] = Color
		for Object, Entry in ThemeRegistry do
			for Property, ThemeKey in Entry do
				if ThemeKey == Key then
					pcall(function() Object[Property] = Color end)
				end
			end
		end
		if Key == "Gradient" then
			local Sequence = GradientSequence()
			for Gradient in GradientRegistry do Gradient.Color = Sequence end
		end
		for Derived, Base in DerivedKeys do
			if Base == Key and not ExplicitDerived[Derived] then Library:SetThemeColor(Derived, Color) end
		end
		for _, Callback in ThemeCallbacks do task.spawn(Callback, Key, Color) end
	end

	function Library:SetTheme(Name)
		local Preset = Themes[Name]
		if not Preset then return end
		Library.ThemeName = Name
		Library.ApplyingTheme = true
		for Derived in DerivedKeys do ExplicitDerived[Derived] = Preset[Derived] ~= nil end
		for _, Key in ThemeKeys do
			Library:SetThemeColor(Key, Preset[Key])
			local Element = Library.Elements["Theme_" .. Key]
			if Element then Element:Set({ Color = Preset[Key], Alpha = 0 }, true) end
		end
		for Derived in DerivedKeys do
			if Preset[Derived] then Library:SetThemeColor(Derived, Preset[Derived]) end
		end
		Library.ApplyingTheme = false
	end

	function Library:AddTheme(Name, Colors)
		local Preset = {}
		for _, Key in ThemeKeys do Preset[Key] = Colors[Key] or Themes.Swift[Key] end
		for Derived in DerivedKeys do Preset[Derived] = Colors[Derived] end
		Themes[Name] = Preset
		if not table.find(ThemeOrder, Name) then table.insert(ThemeOrder, Name) end
		local Dropdown = Library.Elements.__ThemeName
		if Dropdown then Dropdown:SetOptions(ThemeOrder, true) end
	end

	local CasingOrder; do
		local TextRegistry = setmetatable({}, { __mode = "k" })
		CasingOrder = { "Normal", "lower case", "Upper Case", "BOLD CASE" }
		Library.CasingOrder = CasingOrder

		local function ApplyCase(Raw)
			Raw = tostring(Raw or "")
			local Mode = Library.Casing
			if Mode == "lower case" then
				return Raw:lower()
			elseif Mode == "Upper Case" then
				return (Raw:gsub("(%a)([%w_']*)", function(First, Rest) return First:upper() .. Rest:lower() end))
			elseif Mode == "BOLD CASE" then
				return Raw:upper()
			end
			return Raw
		end
		Library.ApplyCase = ApplyCase

		function Library:SetText(Object, Raw)
			TextRegistry[Object] = tostring(Raw or "")
			Object.Text = ApplyCase(Raw)
		end

		function Library:GetRawText(Object)
			return TextRegistry[Object] or Object.Text
		end

		function Library:SetCasing(Mode)
			if not table.find(CasingOrder, Mode) then return end
			Library.Casing = Mode
			for Object, Raw in TextRegistry do
				Object.Text = ApplyCase(Raw)
			end
		end
	end

	local function Connect(Signal, Callback)
		local Connection = Signal:Connect(Callback)
		table.insert(Library.Connections, Connection)
		return Connection
	end
	Library.Connect = function(_, Signal, Callback) return Connect(Signal, Callback) end

	local Layout = {}; do
		local Entries, Snapshot, LastSaved = {}, { Version = 1, Items = {} }, nil
		local Path = Library.Folder .. "/layout.json"
		local function Finite(Value)
			return type(Value) == "number" and Value == Value and math.abs(Value) < 10000000
		end
		local function Record(Value)
			if type(Value) ~= "table" then return nil end
			if (Value.Kind == "Position" or Value.Kind == "Offset") and Finite(Value.X) and Finite(Value.Y) then
				local Min, Max = Value.Kind == "Position" and 0 or -2, Value.Kind == "Position" and 1 or 2
				return { Kind = Value.Kind, X = math.clamp(Value.X, Min, Max), Y = math.clamp(Value.Y, Min, Max) }
			end
			if Value.Kind == "Section" and type(Value.Floating) == "boolean" and (Value.Side == 1 or Value.Side == 2) and Finite(Value.Order) then
				local Source = Value.Position
				local Position = type(Source) == "table" and Source.Kind == "Position" and Finite(Source.X) and Finite(Source.Y) and { Kind = "Position", X = math.clamp(Source.X, 0, 1), Y = math.clamp(Source.Y, 0, 1) } or nil
				if Value.Floating and (not Position or Position.Kind ~= "Position") then return nil end
				return { Kind = "Section", Floating = Value.Floating, Side = Value.Side, Order = math.clamp(math.floor(Value.Order), 0, 10000), Position = Position }
			end
			return nil
		end
		function Layout.Viewport(Target)
			local Size = Target.Parent and Target.Parent.AbsoluteSize
			if not Size or Size.X <= 0 or Size.Y <= 0 then
				local Camera = Workspace.CurrentCamera
				Size = Camera and Camera.ViewportSize
			end
			return Size and Size.X > 0 and Size.Y > 0 and Size or nil
		end
		function Layout.ReadPosition(Target)
			local Viewport = Layout.Viewport(Target)
			if not Viewport then return nil end
			local Position = Target.Position
			return { Kind = "Position", X = Position.X.Scale + Position.X.Offset / Viewport.X, Y = Position.Y.Scale + Position.Y.Offset / Viewport.Y }
		end
		function Layout.SetPosition(Target, Value)
			if not Target.Parent or Value.Kind ~= "Position" then return end
			local Viewport = Layout.Viewport(Target)
			if not Viewport then return end
			local Size, Anchor = Target.AbsoluteSize, Target.AnchorPoint
			local Width = math.min(math.max(Size.X, Target.Size.X.Offset, 0), math.max(Viewport.X - 12, 0))
			local Height = math.min(math.max(Size.Y, Target.Size.Y.Offset, 0), math.max(Viewport.Y - 12, 0))
			local MinX, MaxX = 6 + Width * Anchor.X, Viewport.X - 6 - Width * (1 - Anchor.X)
			local MinY, MaxY = 6 + Height * Anchor.Y, Viewport.Y - 6 - Height * (1 - Anchor.Y)
			Target.Position = UDim2.fromScale(math.clamp(Value.X * Viewport.X, MinX, math.max(MinX, MaxX)) / Viewport.X, math.clamp(Value.Y * Viewport.Y, MinY, math.max(MinY, MaxY)) / Viewport.Y)
		end
		function Layout.Register(Key, Save, Load)
			local Entry = { Save = Save, Load = Load }
			Entries[Key] = Entry
			local function Restore()
				local Value = Snapshot.Items[Key]
				if not Library.Unloaded and Entries[Key] == Entry and Value then pcall(Load, Value) end
			end
			Restore()
			task.defer(Restore)
		end
		function Layout.TrackPosition(Key, Target)
			Layout.Register(Key, function() return Layout.ReadPosition(Target) end, function(Value) Layout.SetPosition(Target, Value) end)
			local function ClampPosition()
				local Value = Snapshot.Items[Key] or Layout.ReadPosition(Target)
				if Value then pcall(Layout.SetPosition, Target, Value) end
			end
			Connect(Target:GetPropertyChangedSignal("AbsoluteSize"), ClampPosition)
			if Target.Parent then
				Connect(Target.Parent:GetPropertyChangedSignal("AbsoluteSize"), ClampPosition)
			end
		end
		function Library:GetLayout()
			local Items = {}
			for Key, Value in Snapshot.Items do Items[Key] = Record(Value) end
			for Key, Entry in Entries do
				local Okay, Value = pcall(Entry.Save)
				if Okay then Items[Key] = Record(Value) or Items[Key] end
			end
			Snapshot = { Version = 1, Items = Items }
			return { Version = 1, Items = table.clone(Items) }
		end
		function Library:SaveLayout()
			local Data = Library:GetLayout()
			Env.SwiftLayout = Data
			local Okay, Json = pcall(HttpService.JSONEncode, HttpService, Data)
			if not Okay or type(Json) ~= "string" then return false end
			if Json == LastSaved then return true end
			local Written, Result = pcall(FS.Write, Path, Json)
			if Written and Result ~= false then LastSaved = Json return true end
			return false
		end
		function Library:LoadLayout(Data)
			if Data == nil then Data = FS.Read(Path) or Env.SwiftLayout end
			if type(Data) == "string" then
				local Okay, Decoded = pcall(HttpService.JSONDecode, HttpService, Data)
				if not Okay then return false end
				Data = Decoded
			end
			if type(Data) ~= "table" or Data.Version ~= 1 or type(Data.Items) ~= "table" then return false end
			local Items = {}
			for Key, Value in Data.Items do
				if type(Key) == "string" and #Key <= 256 then Items[Key] = Record(Value) end
			end
			Snapshot = { Version = 1, Items = Items }
			for Key, Entry in Entries do if Items[Key] then pcall(Entry.Load, Items[Key]) end end
			return true
		end
		Library:LoadLayout()
	end

	local function Tween(Object, Properties, Time, Style, Direction)
		local Info = TweenInfo.new(Time or Library.TweenTime, Style or Library.EasingStyle, Direction or Enum.EasingDirection.Out)
		local Created = TweenService:Create(Object, Info, Properties)
		Created:Play()
		return Created
	end
	Library.Tween = function(_, ...) return Tween(...) end

	local function Create(Class, Properties, Children)
		local Object = Instance.new(Class)
		local IsText = Class == "TextLabel" or Class == "TextButton" or Class == "TextBox"
		local Parent, RawText

		if Object:IsA("GuiObject") then
			Object.BorderSizePixel = 0
		end
		if IsText then
			Fonts:Apply(Object, Enum.FontWeight.Bold)
			Object.TextSize = 13
			if Class ~= "TextButton" then Object.BackgroundTransparency = 1 end
			Object.TextColor3 = Theme.Text
			Object.Text = ""
		end
		if Class == "TextButton" or Class == "ImageButton" then
			Object.AutoButtonColor = false
		end
		if Class == "ImageLabel" or Class == "ImageButton" then
			Object.BackgroundTransparency = 1
		end
		if Class == "ScrollingFrame" then
			Object.BackgroundTransparency = 1
			Object.ScrollBarThickness = 0
			Object.CanvasSize = UDim2.new()
			Object.AutomaticCanvasSize = Enum.AutomaticSize.Y
			Object.ScrollingDirection = Enum.ScrollingDirection.Y
			Object.ElasticBehavior = Enum.ElasticBehavior.Never
			Object.ScrollBarImageColor3 = Theme.Accent
		end

		for Key, Value in Properties or {} do
			if Key == "Parent" then
				Parent = Value
			elseif Key == "Theme" then
				for Property, ThemeKey in Value do Library:Theme(Object, Property, ThemeKey) end
			elseif Key == "Text" and IsText and Class ~= "TextBox" and not (Properties.NoCase) then
				RawText = Value
			elseif Key ~= "NoCase" and Key ~= "Weight" then
				Object[Key] = Value
			end
		end

		if IsText and Properties and Properties.Weight then
			Fonts:Apply(Object, typeof(Properties.Weight) == "EnumItem" and Properties.Weight or Enum.FontWeight[Properties.Weight])
		end

		if RawText ~= nil then
			Library:SetText(Object, RawText)
		elseif IsText and Properties and Properties.NoCase and Properties.Text then
			Object.Text = Properties.Text
		end

		for _, Child in Children or {} do
			Child.Parent = Object
		end
		if Parent then Object.Parent = Parent end
		return Object
	end
	Library.Create = function(_, ...) return Create(...) end

	local function Corner(Parent, Radius)
		return Create("UICorner", { CornerRadius = UDim.new(0, Radius or 5), Parent = Parent })
	end

	local function Stroke(Parent, Key, Inner, Thickness)
		local Object = Create("UIStroke", {
			Thickness = Thickness or 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Round,
			Theme = { Color = Key or "Outline" },
			Parent = Parent,
		})
		if Inner ~= false then
			pcall(function() Object.BorderStrokePosition = Enum.BorderStrokePosition.Inner end)
		end
		return Object
	end

	local function Padding(Parent, Top, Bottom, Left, Right)
		return Create("UIPadding", {
			PaddingTop = UDim.new(0, Top or 0),
			PaddingBottom = UDim.new(0, Bottom or Top or 0),
			PaddingLeft = UDim.new(0, Left or Top or 0),
			PaddingRight = UDim.new(0, Right or Left or Top or 0),
			Parent = Parent,
		})
	end

	local function ListLayout(Parent, Pad, Direction, HAlign, VAlign)
		return Create("UIListLayout", {
			Padding = UDim.new(0, Pad or 0),
			FillDirection = Direction or Enum.FillDirection.Vertical,
			HorizontalAlignment = HAlign or Enum.HorizontalAlignment.Left,
			VerticalAlignment = VAlign or Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = Parent,
		})
	end

	local function Shade(Parent)
		local Gradient = Create("UIGradient", { Rotation = 90, Color = GradientSequence(), Parent = Parent })
		GradientRegistry[Gradient] = true
		return Gradient
	end

	local function Shadow(Parent, Transparency, Blur)
		local Ok, Object = pcall(Instance.new, "UIShadow")
		if not Ok then return nil end
		pcall(function()
			Object.BlurRadius = UDim.new(0, Blur or 20)
			Object.Transparency = Transparency or 0.5
		end)
		Library:Theme(Object, "Color", "Shadow")
		Object.Parent = Parent
		return Object
	end

	local DrawnIcons = {
		Bullet = function(Holder)
			local Parts = {
				{ Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(0.17, 0, 0.56, 0), Radius = 1 },
				{ Position = UDim2.new(0.27, 0, 0.5, 0), Size = UDim2.new(0.42, 0, 0.56, 0), Radius = 1 },
				{ Position = UDim2.new(0.44, 0, 0.5, 0), Size = UDim2.new(0.56, 0, 0.56, 0), Radius = 99 },
			}
			local Frames = {}
			for _, Spec in Parts do
				local Frame = Instance.new("Frame")
				Frame.Name = "Glyph"
				Frame.AnchorPoint = Vector2.new(0, 0.5)
				Frame.Position, Frame.Size = Spec.Position, Spec.Size
				Frame.BorderSizePixel = 0
				local Round = Instance.new("UICorner")
				Round.CornerRadius = UDim.new(0, Spec.Radius)
				Round.Parent = Frame
				Frame.Parent = Holder
				table.insert(Frames, Frame)
			end
			return Frames
		end,
		Cross = function(Holder)
			local Frames = {}
			for _, Size in { UDim2.new(1, 0, 0, 2), UDim2.new(0, 2, 1, 0) } do
				local Frame = Instance.new("Frame")
				Frame.Name = "Glyph"
				Frame.AnchorPoint = Vector2.new(0.5, 0.5)
				Frame.Position, Frame.Size = UDim2.fromScale(0.5, 0.5), Size
				Frame.BorderSizePixel = 0
				local Round = Instance.new("UICorner")
				Round.CornerRadius = UDim.new(0, 1)
				Round.Parent = Frame
				Frame.Parent = Holder
				table.insert(Frames, Frame)
			end
			return Frames
		end,
	}

	local function SetIcon(Image, Icon)
		for _, Child in Image:GetChildren() do
			if Child.Name == "Glyph" then Child:Destroy() end
		end
		if Image:GetAttribute("GlyphConnection") then Image:SetAttribute("GlyphConnection", nil) end
		if type(Icon) == "string" and Icons[Icon] then Icon = Icons[Icon] end
		Image.ImageRectOffset, Image.ImageRectSize = Vector2.zero, Vector2.zero
		Image.Rotation = 0
		if type(Icon) == "string" and DrawnIcons[Icon] then
			Image.Image = ""
			local Frames = DrawnIcons[Icon](Image)
			local function Sync()
				for _, Frame in Frames do
					Frame.BackgroundColor3 = Image.ImageColor3
					Frame.BackgroundTransparency = Image.ImageTransparency
				end
			end
			Sync()
			Image:GetPropertyChangedSignal("ImageColor3"):Connect(Sync)
			Image:GetPropertyChangedSignal("ImageTransparency"):Connect(Sync)
		elseif type(Icon) == "table" then
			Image.Image = Icon.Image or ""
			Image.Rotation = Icon.Rotation or 0
			if Icon.RectOffset then Image.ImageRectOffset = Icon.RectOffset end
			if Icon.RectSize then Image.ImageRectSize = Icon.RectSize end
		elseif type(Icon) == "string" then
			Image.Image = Icon
		else
			Image.Image = ""
		end
	end
	Icons.Bullet = "Bullet"
	Icons.Cross = "Cross"
	Library.SetIcon = function(_, ...) return SetIcon(...) end

	local function MousePosition()
		return UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
	end

	local function IsMouseOver(Object, Margin)
		if not Object or not Object.Parent then return false end
		Margin = Margin or 0
		local Position, Size = Object.AbsolutePosition, Object.AbsoluteSize
		local Point = MousePosition()
		return Point.X >= Position.X - Margin and Point.X <= Position.X + Size.X + Margin
			and Point.Y >= Position.Y - Margin and Point.Y <= Position.Y + Size.Y + Margin
	end
	Library.IsMouseOver = function(_, ...) return IsMouseOver(...) end

	local function IsVisibleOnScreen(Object)
		local Current = Object
		while Current and Current:IsA("GuiObject") do
			if not Current.Visible then return false end
			Current = Current.Parent
		end
		if Current and Current:IsA("LayerCollector") then
			return Current.Enabled
		end
		return Current ~= nil
	end

	local function Round(Number, Increment)
		Increment = Increment or 1
		return math.floor(Number / Increment + 0.5) * Increment
	end

	local function Clamp(Number, Min, Max)
		return math.max(Min, math.min(Max, Number))
	end

	local function KeyName(Key)
		if Key == nil or Key == "None" then return "NONE" end
		if typeof(Key) == "EnumItem" then return Key.Name:upper() end
		return tostring(Key):upper()
	end

	local function KeyFromName(Name)
		if Name == nil or Name == "None" or Name == "NONE" then return nil end
		if typeof(Name) == "EnumItem" then return Name end
		local Ok, Key = pcall(function() return Enum.KeyCode[Name] end)
		if Ok and Key then return Key end
		Ok, Key = pcall(function() return Enum.UserInputType[Name] end)
		if Ok and Key then return Key end
		return nil
	end

	local function InputMatches(Input, Key)
		if Key == nil then return false end
		if Key.EnumType == Enum.KeyCode then
			return Input.KeyCode == Key
		end
		return Input.UserInputType == Key
	end

	local function GetGuiParent()
		local Ok, Hui = pcall(function()
			return (typeof(gethui) == "function" and gethui()) or (typeof(Env.gethui) == "function" and Env.gethui()) or nil
		end)
		if Ok and Hui then return Hui end
		local CoreOk, CoreGui = pcall(function()
			local Gui = Service("CoreGui")
			local _ = Gui:GetChildren()
			local Test = Instance.new("ScreenGui")
			Test.Parent = Gui
			Test:Destroy()
			return Gui
		end)
		if CoreOk and CoreGui then return CoreGui end
		return LocalPlayer:WaitForChild("PlayerGui")
	end

	local function ProtectGui(Gui)
		if typeof(Env.syn) == "table" and typeof(Env.syn.protect_gui) == "function" then
			pcall(Env.syn.protect_gui, Gui)
		end
	end

	local FlagCounter = 0
	local function NextFlag(Hint)
		FlagCounter += 1
		return (Hint and tostring(Hint):gsub("%s+", "_") or "Flag") .. "_" .. FlagCounter
	end

	local function SafeCall(Callback, ...)
		if type(Callback) ~= "function" then return end
		local Ok, Error = pcall(Callback, ...)
		if not Ok then warn("[Swift] callback error: " .. tostring(Error)) end
	end

	local ThemeTween; do
		local GuiParent = GetGuiParent()
		local function Layer(Name, Order)
			local Gui = Instance.new("ScreenGui")
			Gui.Name = FS.Native and HttpService:GenerateGUID(false) or Name
			Gui.DisplayOrder = Order
			Gui.IgnoreGuiInset = true
			Gui.ResetOnSpawn = false
			Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			ProtectGui(Gui)
			Gui.Parent = GuiParent
			return Gui
		end
		Library.HudGui = Layer("SwiftHud", 9000)
		Library.MenuGui = Layer("SwiftMenu", 9001)
		Library.OverlayGui = Layer("SwiftOverlay", 9002)

		function ThemeTween(Object, Property, Key, Time)
			local Entry = ThemeRegistry[Object]
			if not Entry then
				Entry = {}
				ThemeRegistry[Object] = Entry
			end
			Entry[Property] = Key
			return Tween(Object, { [Property] = Theme[Key] }, Time)
		end
	end

	local Privacy = {}; do
		local Widgets, Roots, Connections = {}, {}, {}
		local TextOwners, ImageOwners = setmetatable({}, { __mode = "k" }), setmetatable({}, { __mode = "k" })
		local OwnImages, Names = {}, {}
		local Black, White = Color3.new(0, 0, 0), Color3.new(1, 1, 1)
		local Generation, AvatarRequest = 0, 0
		Library.AnonymousMode, Library.AnonymousName, Library.AnonymousGame = false, "...", false
		if LocalPlayer then
			for _, Name in { LocalPlayer.Name, LocalPlayer.DisplayName } do
				if Name ~= "" and not table.find(Names, Name) then table.insert(Names, Name) end
			end
		end

		local function Escape(Text)
			return Text:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
		end
		local function Replace(Text, Rich)
			local Alias = Rich and Escape(Library.AnonymousName) or Library.AnonymousName
			local Parts, Cursor = {}, 1
			while Cursor <= #Text do
				local First, Last
				for _, Name in Names do
					local Start, Finish = Text:find(Name, Cursor, true)
					while Start and (Text:sub(Start - 1, Start - 1):match("[%w_]") or Text:sub(Finish + 1, Finish + 1):match("[%w_]")) do
						Start, Finish = Text:find(Name, Finish + 1, true)
					end
					if Start and (not First or Start < First or Start == First and Finish > Last) then First, Last = Start, Finish end
				end
				if not First then table.insert(Parts, Text:sub(Cursor)); break end
				table.insert(Parts, Text:sub(Cursor, First - 1))
				table.insert(Parts, Alias)
				Cursor = Last + 1
			end
			return table.concat(Parts)
		end
		local function Mask(Text, Rich)
			if not Rich then return Replace(Text, false) end
			local Parts, Cursor = {}, 1
			while Cursor <= #Text do
				local First, Last = Text:find("<[^>]*>", Cursor)
				if not First then table.insert(Parts, Replace(Text:sub(Cursor), true)); break end
				table.insert(Parts, Replace(Text:sub(Cursor, First - 1), true))
				table.insert(Parts, Text:sub(First, Last))
				Cursor = Last + 1
			end
			return table.concat(Parts)
		end
		local function LibraryWidget(Widget)
			for _, Root in { Library.MenuGui, Library.HudGui, Library.OverlayGui } do
				if Root and (Widget == Root or Widget:IsDescendantOf(Root)) then return true end
			end
			return false
		end
		local function Included(Widget)
			if LibraryWidget(Widget) then return true end
			for Root, Entry in Roots do
				if Entry.Game and Root.Parent == LocalPlayer and Widget:IsDescendantOf(Root) then return true end
			end
			return false
		end
		local function Disconnect(List)
			for _, Connection in List do pcall(Connection.Disconnect, Connection) end
			table.clear(List)
		end
		local function Forget(Widget, Restore)
			local Record = Widgets[Widget]
			if not Record then return end
			Widgets[Widget] = nil
			Record.Active = false
			Disconnect(Record.Connections)
			if Restore then
				for Key, Value in Record.Values do pcall(function() Widget[Key] = Value end) end
			end
		end
		local function Apply(Widget, Record)
			if not Privacy.Active or Library.Unloaded or not Record.Active or not Widget.Parent then return end
			Record.Writing = true
			pcall(function()
				if Record.Values.Text ~= nil then
					local Text = TextOwners[Widget] and (Widget.RichText and Escape(Library.AnonymousName) or Library.AnonymousName) or Mask(Record.Values.Text, Widget.RichText)
					Record.Applied.Text = Text
					Widget.Text = Text
				else
					local Image = Record.Values.Image
					local Own = ImageOwners[Widget] == true or Image ~= "" and OwnImages[Image] == true
						or LocalPlayer and Image:find("rbxthumb://", 1, true) and Image:match("[?&]id=(%d+)") == tostring(LocalPlayer.UserId)
					for Key, Value in Record.Values do
						if Own then
							if Key == "Image" then Value = Library.AnonymousImage or ""
							elseif Key == "ImageColor3" then Value = Library.AnonymousImage and White or Black
							elseif Key == "BackgroundColor3" then Value = Black
							elseif Key == "BackgroundTransparency" and not Library.AnonymousImage then Value = 0 end
						end
						Record.Applied[Key] = Value
						Widget[Key] = Value
					end
				end
			end)
			Record.Writing = false
		end
		local function Add(Widget)
			if not Privacy.Active or Widgets[Widget] or not Included(Widget) then return end
			local Text = Widget:IsA("TextLabel") or Widget:IsA("TextButton")
			if not Text and not Widget:IsA("ImageLabel") and not Widget:IsA("ImageButton") then return end
			local Record = { Active = true, Values = {}, Applied = {}, Connections = {} }
			Widgets[Widget] = Record
			for _, Key in Text and { "Text" } or { "Image", "ImageColor3", "BackgroundColor3", "BackgroundTransparency" } do
				Record.Values[Key] = Widget[Key]
				table.insert(Record.Connections, Widget:GetPropertyChangedSignal(Key):Connect(function()
					if not Record.Active or Record.Writing then return end
					local Value = Widget[Key]
					if Value == Record.Applied[Key] then return end
					Record.Values[Key] = Value
					Apply(Widget, Record)
				end))
			end
			if Text then table.insert(Record.Connections, Widget:GetPropertyChangedSignal("RichText"):Connect(function() Apply(Widget, Record) end)) end
			table.insert(Record.Connections, Widget.Destroying:Connect(function() Forget(Widget, false) end))
			Apply(Widget, Record)
		end
		local function Watch(Root, Game)
			if not Root or Roots[Root] then return end
			local Entry, Token = { Game = Game, Connections = {} }, Generation
			Roots[Root] = Entry
			table.insert(Entry.Connections, Root.DescendantAdded:Connect(Add))
			table.insert(Entry.Connections, Root.DescendantRemoving:Connect(function(Widget)
				task.defer(function()
					if Privacy.Active and Generation == Token and not Included(Widget) then Forget(Widget, true) end
				end)
			end))
			for _, Widget in Root:GetDescendants() do Add(Widget) end
		end
		function Privacy:Stop()
			self.Active = false
			Generation += 1
			Disconnect(Connections)
			for _, Entry in Roots do Disconnect(Entry.Connections) end
			table.clear(Roots)
			local Pending = {}
			for Widget in Widgets do table.insert(Pending, Widget) end
			for _, Widget in Pending do Forget(Widget, true) end
		end
		function Privacy:Start()
			self.Active, self.Game = true, Library.AnonymousGame
			for _, Root in { Library.MenuGui, Library.HudGui, Library.OverlayGui } do Watch(Root, false) end
			if self.Game and LocalPlayer then
				Watch(LocalPlayer:FindFirstChildOfClass("PlayerGui"), true)
				table.insert(Connections, LocalPlayer.ChildAdded:Connect(function(Child)
					if self.Active and Child:IsA("PlayerGui") then Watch(Child, true) end
				end))
				table.insert(Connections, LocalPlayer.ChildRemoved:Connect(function(Child)
					local Entry = Roots[Child]
					if not Entry or not Entry.Game then return end
					Disconnect(Entry.Connections)
					Roots[Child] = nil
					local Pending = {}
					for Widget in Widgets do if not Included(Widget) then table.insert(Pending, Widget) end end
					for _, Widget in Pending do Forget(Widget, true) end
				end))
			end
		end
		function Privacy:Refresh()
			for Widget, Record in Widgets do Apply(Widget, Record) end
		end
		function Library:GetAnonymousText(Text, Rich)
			Text = tostring(Text or "")
			return self.AnonymousMode and Mask(Text, Rich) or Text
		end
		function Library:SetPlayerText(Widget, Player, Text)
			TextOwners[Widget] = Player == LocalPlayer and LocalPlayer ~= nil or nil
			self:SetText(Widget, Text)
			if Widgets[Widget] then Apply(Widget, Widgets[Widget]) end
		end
		function Library:SetPlayerAvatar(Widget, Player, Image)
			Image = tostring(Image or "")
			ImageOwners[Widget] = Player == LocalPlayer and LocalPlayer ~= nil or nil
			if ImageOwners[Widget] and Image ~= "" then OwnImages[Image] = true end
			Widget.Image = Image
			if Widgets[Widget] then Apply(Widget, Widgets[Widget]) end
		end
		function Library:SetAnonymous(Value)
			if self.Unloaded then return self end
			self.AnonymousMode = Value == true
			if self.AnonymousMode then
				if not Privacy.Active or Privacy.Game ~= self.AnonymousGame then Privacy:Stop(); Privacy:Start() end
				Privacy:Refresh()
			else Privacy:Stop() end
			if self.Watermark then self.Watermark:_Render() end
			return self
		end
		function Library:SetAnonymousName(Value)
			local Name = tostring(Value or ""):gsub("[%c]", ""):match("^%s*(.-)%s*$")
			self.AnonymousName = Name ~= "" and Name:sub(1, 40) or "..."
			return self:SetAnonymous(self.AnonymousMode)
		end
		function Library:SetAnonymousGame(Value)
			self.AnonymousGame = Value == true
			return self:SetAnonymous(self.AnonymousMode)
		end
		function Library:SetAnonymousAvatar(Value)
			AvatarRequest += 1
			local Request = AvatarRequest
			local Input = tostring(Value or ""):match("^%s*(.-)%s*$")
			if self.Unloaded then return false end
			if Input == "" then self.AnonymousImage = nil; self:SetAnonymous(self.AnonymousMode); return true end
			local UserId = tonumber(Input)
			local function Notify(Text)
				if type(self.Notify) == "function" then pcall(self.Notify, self, { Title = "Anonymous Mode", Text = Text, Type = "Warning" }) end
			end
			if not UserId or UserId ~= UserId or UserId < 1 or UserId > 9007199254740991 or UserId % 1 ~= 0 then Notify("Enter a valid avatar user ID."); return false end
			task.spawn(function()
				if self.Unloaded or Request ~= AvatarRequest then return end
				local Okay = pcall(Players.GetNameFromUserIdAsync, Players, UserId)
				if self.Unloaded or Request ~= AvatarRequest then return end
				if not Okay then Notify("Avatar user ID was not found."); return end
				local Loaded, Image = pcall(Players.GetUserThumbnailAsync, Players, UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
				if self.Unloaded or Request ~= AvatarRequest then return end
				self.AnonymousImage = Loaded and type(Image) == "string" and Image ~= "" and Image or "rbxthumb://type=AvatarHeadShot&id=" .. UserId .. "&w=150&h=150"
				self:SetAnonymous(self.AnonymousMode)
			end)
			return true
		end
	end

	local PlacePopup, PopupPanel, FadePopup; do
		local Popups = Library.PopupStack

		local function IsPopupAncestor(Ancestor, Popup)
			local Current = Popup.ParentPopup
			while Current do
				if Current == Ancestor then return true end
				Current = Current.ParentPopup
			end
			return false
		end

		function Library:ClosePopup(Popup)
			local Index = table.find(Popups, Popup)
			if not Index then return end
			for Position = #Popups, Index, -1 do
				local Closing = table.remove(Popups, Position)
				Closing.Open = false
				SafeCall(Closing.OnClose, Closing)
			end
		end

		function Library:CloseAllPopups()
			for Position = #Popups, 1, -1 do
				if Popups[Position] then Library:ClosePopup(Popups[Position]) end
			end
		end

		function Library:OpenPopup(Popup)
			for Position = #Popups, 1, -1 do
				local Other = Popups[Position]
				if Other ~= Popup.ParentPopup and not IsPopupAncestor(Other, Popup) then
					Library:ClosePopup(Other)
				else
					break
				end
			end
			Popup.Open = true
			table.insert(Popups, Popup)
			SafeCall(Popup.Update, Popup)
		end

		Connect(UserInputService.InputBegan, function(Input)
			if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end
			for Position = #Popups, 1, -1 do
				local Popup = Popups[Position]
				if not Popup then continue end
				if IsMouseOver(Popup.Frame) or (Popup.Owner and IsMouseOver(Popup.Owner)) then break end
				Library:ClosePopup(Popup)
			end
		end)

		Connect(RunService.RenderStepped, function()
			for Position = #Popups, 1, -1 do
				local Popup = Popups[Position]
				if not Popup then continue end
				local Watched = Popup.Owner or Popup.Anchor
				if Watched and not IsVisibleOnScreen(Watched) then
					Library:ClosePopup(Popup)
				else
					SafeCall(Popup.Update, Popup)
				end
			end
		end)

		local PopupTargets = setmetatable({}, { __mode = "k" })
		function PlacePopup(Frame, Owner, OffsetX, OffsetY, AlignRight)
			local Gui = Library.OverlayGui
			local Origin, Viewport = Gui.AbsolutePosition, Gui.AbsoluteSize
			local Position, Size = Owner.AbsolutePosition, Owner.AbsoluteSize
			local Width, Height = Frame.AbsoluteSize.X, Frame.AbsoluteSize.Y
			local X = AlignRight and (Position.X + Size.X - Width + (OffsetX or 0)) or (Position.X + (OffsetX or 0))
			local Y = Position.Y + Size.Y + (OffsetY or 0)
			if Y + Height > Origin.Y + Viewport.Y - 6 then
				Y = math.max(Origin.Y + 6, Position.Y - Height - (OffsetY or 0))
			end
			X = Clamp(X, Origin.X + 6, math.max(Origin.X + 6, Origin.X + Viewport.X - Width - 6))
			local Target = Vector2.new(math.floor(X - Origin.X + 0.5), math.floor(Y - Origin.Y + 0.5))
			if PopupTargets[Frame] ~= Target or not Frame.Visible then
				PopupTargets[Frame] = Target
				Frame.Position = UDim2.fromOffset(Target.X, Target.Y)
			end
		end

		function PopupPanel(Size, Name, Radius)
			local Frame = Create("CanvasGroup", {
				Name = Name or "Popup",
				Size = Size,
				Theme = { BackgroundColor3 = "Popup" },
				GroupTransparency = 1,
				Active = true,
				Visible = false,
				ZIndex = 10,
				Parent = Library.OverlayGui,
			})
			Corner(Frame, Radius or 6)
			Stroke(Frame, "Outline")
			return Frame
		end

		local FadeTokens = setmetatable({}, { __mode = "k" })
		local FadeBases = setmetatable({}, { __mode = "k" })
		function FadePopup(Frame, Open, OffsetY)
			local Token = {}
			FadeTokens[Frame] = Token
			local Target = PopupTargets[Frame]
			local Base = FadeBases[Frame] or (Target and UDim2.fromOffset(Target.X, Target.Y)) or Frame.Position
			if Open then
				FadeBases[Frame] = nil
				Frame.Visible = true
				Frame.GroupTransparency = 1
				Frame.Position = Base - UDim2.fromOffset(0, OffsetY or 5)
				Tween(Frame, { Position = Base, GroupTransparency = 0 }, 0.15, Enum.EasingStyle.Quad)
			else
				FadeBases[Frame] = Base
				Tween(Frame, { Position = Base - UDim2.fromOffset(0, 14) }, 0.2, Enum.EasingStyle.Quad)
				Tween(Frame, { GroupTransparency = 1 }, 0.18, Enum.EasingStyle.Sine).Completed:Connect(function()
					if FadeTokens[Frame] ~= Token then return end
					FadeBases[Frame] = nil
					Frame.Visible = false
					Frame.Position = Base
				end)
			end
		end
	end

	do
		local LOGO_SCALE = 420 / 231
		local LOGO_SHIFT = Vector2.new(2 / 420, -8 / 420)

		function Library:Logo(Parent, Size, Icon)
			Size = Size or 20
			local Holder = Create("Frame", { Name = "Logo", Size = UDim2.fromOffset(Size, Size), BackgroundTransparency = 1, Parent = Parent })
			local ImageSize = Size * LOGO_SCALE
			local IsLogo = Icon == nil or Icon == "Logo"
			local Image = Create("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = IsLogo and UDim2.new(0.5, ImageSize * LOGO_SHIFT.X, 0.5, ImageSize * LOGO_SHIFT.Y) or UDim2.fromScale(0.5, 0.5),
				Size = IsLogo and UDim2.fromOffset(ImageSize, ImageSize) or UDim2.fromOffset(Size, Size),
				Theme = { ImageColor3 = "Text" },
				Parent = Holder,
			})
			SetIcon(Image, Icon or "Logo")
			Holder:SetAttribute("Logo", true)
			return Holder, Image
		end
	end

	local Window, Tab, Section; do
		Window = {}
		Window.__index = Window
		Tab = {}
		Tab.__index = Tab
		Section = {}
		Section.__index = Section
		Library.Classes = { Window = Window, Tab = Tab, Section = Section }

		local MENU_SIZE = Vector2.new(600, 570)
		local MENU_RADIUS = 8
		local SIDEBAR_WIDTH = 141

		function Library:CreateWindow(Config)
			Config = Config or {}
			local Self = setmetatable({
				Title = Config.Title or "Swift",
				Tabs = {},
				Sections = {},
				Floating = {},
				Categories = {},
				Open = true,
				LayoutCounter = 0,
				ZCounter = 10,
			}, Window)
			table.insert(Library.Windows, Self)
			Library.Window = Self

			local Holder = Create("Frame", {
				Name = "Menu",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = Config.Position or UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset((Config.Size or MENU_SIZE).X, (Config.Size or MENU_SIZE).Y),
				BackgroundTransparency = 1,
				ZIndex = 5,
				Parent = Library.MenuGui,
			})
			Self.Holder = Holder
			Self.LayoutKey = "Window/" .. tostring(Config.LayoutId or #Library.Windows)
			Layout.TrackPosition(Self.LayoutKey, Holder)

			local ShadowFrame = Create("Frame", { Size = UDim2.fromScale(1, 1), Theme = { BackgroundColor3 = "Background" }, Parent = Holder })
			Corner(ShadowFrame, MENU_RADIUS)
			Self.ShadowFrame = ShadowFrame
			Self.Shadow = Shadow(ShadowFrame, 0.35, 32)

			local Canvas = Create("CanvasGroup", { Size = UDim2.fromScale(1, 1), Theme = { BackgroundColor3 = "Background" }, ZIndex = 2, Parent = Holder })
			Corner(Canvas, MENU_RADIUS)
			Self.Canvas = Canvas

			local Sidebar = Create("Frame", { Name = "Sidebar", Size = UDim2.new(0, SIDEBAR_WIDTH, 1, 0), Theme = { BackgroundColor3 = "Inline" }, Parent = Canvas })
			Self.Sidebar = Sidebar
			Create("Frame", { Name = "Divider", Position = UDim2.fromOffset(SIDEBAR_WIDTH, 0), Size = UDim2.new(0, 1, 1, 0), Theme = { BackgroundColor3 = "Outline" }, Parent = Canvas })

			local Content = Create("Frame", {
				Name = "Content",
				Position = UDim2.fromOffset(SIDEBAR_WIDTH + 1, 0),
				Size = UDim2.new(1, -(SIDEBAR_WIDTH + 1), 1, 0),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Parent = Canvas,
			})
			Self.Content = Content

			local OutlineFrame = Create("Frame", { Name = "Outline", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 80, Parent = Canvas })
			Corner(OutlineFrame, MENU_RADIUS)
			Stroke(OutlineFrame, "Outline")

			local HEADER_HEIGHT = 64
			local Header = Create("Frame", { Name = "Header", Size = UDim2.new(1, 0, 0, HEADER_HEIGHT), BackgroundTransparency = 1, Parent = Sidebar })
			ListLayout(Header, 9, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)
			local Logo = Library:Logo(Header, 24, Config.Logo)
			Logo.LayoutOrder = 1
			local TitleLabel = Create("TextLabel", {
				Name = "Title",
				Size = UDim2.fromOffset(0, 28),
				AutomaticSize = Enum.AutomaticSize.X,
				Text = Self.Title,
				TextSize = 21,
				LayoutOrder = 2,
				Theme = { TextColor3 = "Text" },
				Parent = Header,
			})
			Self.Logo, Self.TitleLabel = Logo, TitleLabel

			local TabList = Create("ScrollingFrame", {
				Name = "Tabs",
				Position = UDim2.fromOffset(10, HEADER_HEIGHT),
				Size = UDim2.new(0, 121, 1, -(HEADER_HEIGHT + 46)),
				BackgroundTransparency = 1,
				Parent = Sidebar,
			})
			ListLayout(TabList, 6)
			Self.TabList = TabList

			local SearchButton = Create("TextButton", {
				Name = "Search",
				Position = UDim2.new(0, 10, 1, -38),
				Size = UDim2.fromOffset(121, 28),
				Theme = { BackgroundColor3 = "Tab" },
				Parent = Sidebar,
			})
			Corner(SearchButton, 6)
			Stroke(SearchButton, "Outline")
			local SearchIcon = Create("ImageLabel", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), Size = UDim2.fromOffset(16, 16), Theme = { ImageColor3 = "Inactive Text" }, Parent = SearchButton })
			SetIcon(SearchIcon, "Search")
			local SearchText = Create("TextLabel", {
				Position = UDim2.fromOffset(32, 0),
				Size = UDim2.new(1, -36, 1, 0),
				Text = "Search...",
				NoCase = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Theme = { TextColor3 = "Inactive Text" },
				Parent = SearchButton,
			})
			Self.SearchButton, Self.SearchText = SearchButton, SearchText

			do
				local Dragging, StartMouse, StartPosition = false, nil, nil
				local function Begin(Input)
					if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end
					Dragging = true
					StartMouse = MousePosition()
					StartPosition = Holder.Position
				end
				Connect(Sidebar.InputBegan, Begin)
				Connect(UserInputService.InputChanged, function(Input)
					if not Dragging then return end
					if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end
					local Delta = MousePosition() - StartMouse
					Holder.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
				end)
				Connect(UserInputService.InputEnded, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						if Dragging then Library:SaveLayout() end
						Dragging = false
					end
				end)
			end

			Self:_BuildSearch()

			Connect(SearchButton.MouseButton1Click, function() Self:OpenSearch() end)

			return Self
		end

		function Window:AddCategory(Name)
			self.LayoutCounter += 1
			local Label = Create("TextLabel", {
				Name = "Category",
				Size = UDim2.new(1, 0, 0, 12),
				Text = Name,
				TextSize = 10,
				TextXAlignment = Enum.TextXAlignment.Left,
				Theme = { TextColor3 = "Inactive Text" },
				LayoutOrder = self.LayoutCounter,
				Parent = self.TabList,
			})
			Padding(Label, 0, 0, 2, 0)
			table.insert(self.Categories, Label)
			return Label
		end

		function Window:SetTitle(Title)
			self.Title = Title
			Library:SetText(self.TitleLabel, Title)
		end

		function Window:SetLogo(Icon)
			SetIcon(self.Logo:FindFirstChildOfClass("ImageLabel"), Icon)
		end

		function Window:SetOpen(Open)
			if Open == nil then Open = not self.Open end
			self.Open = Open
			local Holder = self.Holder
			if Open then Holder.Visible = true end
			Tween(self.Canvas, { GroupTransparency = Open and 0 or 1 }, 0.16)
			Tween(self.ShadowFrame, { BackgroundTransparency = Open and 0 or 1 }, 0.16)
			if self.Shadow then Tween(self.Shadow, { Transparency = Open and 0.35 or 1 }, 0.16) end
			for _, Floating in self.Floating do
				if Open then Floating.Visible = true end
				Tween(Floating, { GroupTransparency = Open and 0 or 1 }, 0.16)
			end
			for _, Extra in self.Extras or {} do
				SafeCall(Extra, Open)
			end
			if not Open then
				Library:CloseAllPopups()
				self:CloseSearch()
				task.delay(0.17, function()
					if self.Open then return end
					Holder.Visible = false
					for _, Floating in self.Floating do Floating.Visible = false end
				end)
			end
			Library:_UpdateBlur()
		end

		function Window:Toggle() self:SetOpen(not self.Open) end

		function Window:OnOpenChanged(Callback)
			self.Extras = self.Extras or {}
			table.insert(self.Extras, Callback)
		end
	end

	do
		function Window:AddTab(Config)
			if type(Config) == "string" then Config = { Title = Config } end
			Config = Config or {}
			if Config.Category then
				if self._LastCategory ~= Config.Category then
					self:AddCategory(Config.Category)
					self._LastCategory = Config.Category
				end
			end
			self.LayoutCounter += 1

			local Self = setmetatable({
				Title = Config.Title or "Tab",
				Window = self,
				Sections = {},
				Active = false,
				SectionCounter = 0,
			}, Tab)

			local Button = Create("TextButton", {
				Name = "Tab",
				Size = UDim2.new(1, 0, 0, 26),
				BackgroundTransparency = 1,
				Theme = { BackgroundColor3 = "Tab" },
				LayoutOrder = self.LayoutCounter,
				Parent = self.TabList,
			})
			Corner(Button, 5)
			local ButtonStroke = Stroke(Button, "Outline")
			ButtonStroke.Transparency = 1
			local Icon = Create("ImageLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 7, 0.5, 0),
				Size = UDim2.fromOffset(16, 16),
				Theme = { ImageColor3 = "Inactive Text" },
				Parent = Button,
			})
			SetIcon(Icon, Config.Icon)
			local Label = Create("TextLabel", {
				Weight = "SemiBold",
				Position = UDim2.fromOffset(33, 0),
				Size = UDim2.new(1, -33, 1, 0),
				Text = Self.Title,
				TextXAlignment = Enum.TextXAlignment.Left,
				Theme = { TextColor3 = "Inactive Text" },
				Parent = Button,
			})
			Self.Button, Self.ButtonStroke, Self.Icon, Self.Label = Button, ButtonStroke, Icon, Label

			local Page = Create("CanvasGroup", {
				Name = "Page",
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				GroupTransparency = 1,
				Visible = false,
				Parent = self.Content,
			})
			Self.Page = Page

			local function Column(Position)
				local Frame = Create("ScrollingFrame", {
					Position = Position,
					Size = UDim2.new(0.5, -15, 1, 0),
					Parent = Page,
				})
				Padding(Frame, 10, 10, 0, 0)
				ListLayout(Frame, 10)
				return Frame
			end
			Self.Left = Column(UDim2.fromOffset(10, 0))
			Self.Right = Column(UDim2.new(0.5, 5, 0, 0))
			Self.Columns = { Self.Left, Self.Right }

			Connect(Button.MouseEnter, function()
				Self.Hovered = true
				if Self.Active then return end
				Tween(Button, { BackgroundTransparency = 0 }, 0.12)
				Tween(ButtonStroke, { Transparency = 0 }, 0.12)
			end)
			Connect(Button.MouseLeave, function()
				Self.Hovered = false
				if Self.Active then return end
				Tween(Button, { BackgroundTransparency = 1 }, 0.15)
				Tween(ButtonStroke, { Transparency = 1 }, 0.15)
			end)
			Connect(Button.MouseButton1Click, function() Self:Select() end)

			table.insert(self.Tabs, Self)
			if not self.ActiveTab then Self:Select(true) end
			return Self
		end

		local PAGE_SLIDE = 10

		function Tab:_SetActive(Active, Instant)
			self.Active = Active
			local ButtonTime = Instant and 0 or (Active and 0.08 or 0.18)
			Tween(self.Button, { BackgroundTransparency = (Active or self.Hovered) and 0 or 1 }, ButtonTime)
			Tween(self.ButtonStroke, { Transparency = (Active or self.Hovered) and 0 or 1 }, ButtonTime)
			ThemeTween(self.Label, "TextColor3", Active and "Text" or "Inactive Text", Instant and 0 or 0.1)
			ThemeTween(self.Icon, "ImageColor3", Active and "Text" or "Inactive Text", Instant and 0 or 0.1)
			local Page = self.Page
			if Active then
				Page.Visible = true
				Page.ZIndex = 2
				Page.Position = UDim2.fromOffset(0, Instant and 0 or PAGE_SLIDE)
				Tween(Page, { Position = UDim2.fromOffset(0, 0) }, Instant and 0 or 0.3, Enum.EasingStyle.Quad)
				Tween(Page, { GroupTransparency = 0 }, Instant and 0 or 0.15, Enum.EasingStyle.Quad)
			else
				Page.ZIndex = 1
				Tween(Page, { Position = UDim2.fromOffset(0, Instant and 0 or -PAGE_SLIDE) }, Instant and 0 or 0.3, Enum.EasingStyle.Quad)
				Tween(Page, { GroupTransparency = 1 }, Instant and 0 or 0.2, Enum.EasingStyle.Quad).Completed:Connect(function()
					if not self.Active then
						Page.Visible = false
						Page.Position = UDim2.fromOffset(0, 0)
					end
				end)
			end
		end

		function Tab:Select(Instant)
			local Window_ = self.Window
			local Old = Window_.ActiveTab
			if Old == self then return end
			Window_.ActiveTab = self
			Library:CloseAllPopups()
			if Old then Old:_SetActive(false, Instant) end
			self:_SetActive(true, Instant)
			for _, Callback in self.SelectCallbacks or {} do SafeCall(Callback) end
		end

		function Tab:OnSelected(Callback)
			self.SelectCallbacks = self.SelectCallbacks or {}
			table.insert(self.SelectCallbacks, Callback)
		end
	end

	local Container = {}
	Container.__index = Container
	Library.Classes.Container = Container

	local function NewContainer(Holder, Owner)
		return setmetatable({
			Holder = Holder,
			Section = Owner.Section,
			Tab = Owner.Tab,
			Window = Owner.Window,
			Path = Owner.Path,
			Counter = 0,
			Elements = {},
		}, Container)
	end

	local function SectionBox(Parent, Owner, Pad)
		local Box = Create("Frame", {
			Name = "Box",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Theme = { BackgroundColor3 = "Tab" },
			Parent = Parent,
		})
		Corner(Box, 5)
		Stroke(Box, "Outline")
		local Items = Create("Frame", {
			Name = "Items",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = Box,
		})
		Padding(Items, Pad or 11, Pad or 11, Pad or 11, Pad or 11)
		ListLayout(Items, 6)
		return Box, NewContainer(Items, Owner)
	end

	function Tab:AddSection(Config)
		if type(Config) == "string" then Config = { Title = Config } end
		Config = Config or {}
		local Side = Config.Side
		if Side == "Right" or Side == 2 then Side = 2 elseif Side == "Left" or Side == 1 then Side = 1 else
			Side = (#self.Left:GetChildren() <= #self.Right:GetChildren()) and 1 or 2
		end
		self.SectionCounter += 1

		local Self = setmetatable({
			Title = Config.Title or "Section",
			Tab = self,
			Window = self.Window,
			Side = Side,
			Order = self.SectionCounter,
		}, Section)
		Self.Section = Self
		Self.Path = self.Title .. " / " .. Self.Title
		Self.LayoutKey = self.Window.LayoutKey .. "/Section/" .. Self.Path .. "/" .. tostring(self.SectionCounter)

		local Frame = Create("Frame", {
			Name = "Section",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = self.SectionCounter,
			Parent = self.Columns[Side],
		})
		ListLayout(Frame, 8)
		local Header = Create("TextButton", { Name = "Header", Size = UDim2.new(1, 0, 0, 19), BackgroundTransparency = 1, LayoutOrder = 0, Parent = Frame })
		local HeaderIcon = Create("ImageLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 1, 0.5, 0),
			Size = UDim2.fromOffset(15, 15),
			Theme = { ImageColor3 = "Inactive Text" },
			Parent = Header,
		})
		SetIcon(HeaderIcon, Config.Icon or "Cube")
		local HeaderTitle = Create("TextLabel", {
			Position = UDim2.fromOffset(27, 0),
			Size = UDim2.new(1, -27, 1, 0),
			Text = Self.Title,
			TextXAlignment = Enum.TextXAlignment.Left,
			Theme = { TextColor3 = "Inactive Text" },
			Parent = Header,
		})
		local Box, Items = SectionBox(Frame, Self)
		Box.LayoutOrder = 1

		Self.Frame, Self.Header, Self.HeaderIcon, Self.HeaderTitle, Self.Box, Self.Container = Frame, Header, HeaderIcon, HeaderTitle, Box, Items
		setmetatable(Self, {
			__index = function(_, Key)
				local Value = rawget(Section, Key)
				if Value ~= nil then return Value end
				local Method = Container[Key]
				if type(Method) == "function" then
					local Callback = function(_, ...) return Method(Items, ...) end; return Callback
				end
				return nil
			end,
		})

		table.insert(self.Sections, Self)
		table.insert(self.Window.Sections, Self)
		Library:_Index({ Title = Self.Title, Path = Self.Path, Type = "Section", Tab = self, Target = Frame, Section = Self })

		if Config.Detachable ~= false then Self:_MakeDetachable() end
		return Self
	end

	function Section:SetTitle(Title)
		self.Title = Title
		Library:SetText(self.HeaderTitle, Title)
	end

	function Section:SetVisible(Visible)
		self.Frame.Visible = Visible
	end

	function Section:_MakeDetachable()
		local Window_ = self.Window
		local Frame, Header = self.Frame, self.Header
		local Pressing, Moved, StartMouse, GrabOffset = false, false, nil, nil

		local function BringToFront()
			if self.FloatWindow then
				Window_.ZCounter += 1
				self.FloatWindow.ZIndex = Window_.ZCounter
			end
		end

		local function Detach()
			if self.Floating then return end
			local Position, Size = Frame.AbsolutePosition - Library.MenuGui.AbsolutePosition, Frame.AbsoluteSize
			local Width = Size.X > 0 and Size.X or math.max(120, (Window_.Holder.Size.X.Offset - 142) * 0.5 - 15)
			local Float = Create("CanvasGroup", {
				Name = "FloatingSection",
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(Width, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.fromOffset(Position.X, Position.Y),
				Parent = Library.MenuGui,
			})
			self.FloatWindow = Float
			self.Floating = true
			Frame.Parent = Float
			table.insert(Window_.Floating, Float)
			BringToFront()
			Library:CloseAllPopups()
		end

		local function Dock()
			local Content = Window_.Content
			local Mouse_ = MousePosition()
			local Middle = Content.AbsolutePosition.X + Content.AbsoluteSize.X / 2
			local Side = Mouse_.X < Middle and 1 or 2
			local Columns = self.Tab.Columns
			local Order = self.Order
			local Best
			for _, Other in self.Tab.Sections do
				if Other ~= self and not Other.Floating and Other.Frame.Parent == Columns[Side] then
					local Top = Other.Frame.AbsolutePosition.Y + Other.Frame.AbsoluteSize.Y / 2
					if Mouse_.Y < Top and (not Best or Other.Frame.LayoutOrder < Best) then
						Best = Other.Frame.LayoutOrder
					end
				end
			end
			if Best then
				for _, Other in self.Tab.Sections do
					if Other ~= self and Other.Frame.Parent == Columns[Side] and Other.Frame.LayoutOrder >= Best then
						Other.Frame.LayoutOrder += 1
					end
				end
				Order = Best
			else
				Order = 0
				for _, Other in self.Tab.Sections do
					if Other.Frame.Parent == Columns[Side] then Order = math.max(Order, Other.Frame.LayoutOrder) end
				end
				Order += 1
			end
			Frame.LayoutOrder = Order
			Frame.Parent = Columns[Side]
			self.Side = Side
			local Float = self.FloatWindow
			self.FloatWindow = nil
			self.Floating = false
			local Index = table.find(Window_.Floating, Float)
			if Index then table.remove(Window_.Floating, Index) end
			if Float then Float:Destroy() end
		end
		self.Dock = Dock
		self.Detach = Detach

		Connect(Header.InputBegan, function(Input)
			if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end
			Pressing, Moved = true, false
			StartMouse = MousePosition()
			GrabOffset = StartMouse - Frame.AbsolutePosition
			BringToFront()
		end)
		Connect(UserInputService.InputChanged, function(Input)
			if not Pressing then return end
			if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end
			local Mouse_ = MousePosition()
			if not Moved and (Mouse_ - StartMouse).Magnitude > 8 then
				Moved = true
				if not self.Floating then Detach() end
			end
			if Moved and self.FloatWindow then
				local Target = Mouse_ - GrabOffset - Library.MenuGui.AbsolutePosition
				self.FloatWindow.Position = UDim2.fromOffset(Target.X, Target.Y)
			end
		end)
		Connect(UserInputService.InputEnded, function(Input)
			if not Pressing then return end
			if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end
			Pressing = false
			if Moved and self.Floating and Window_.Open and self.Tab.Active and IsMouseOver(Window_.Content) then
				Dock()
			end
			if Moved then Library:SaveLayout() end
		end)
		Layout.Register(self.LayoutKey, function()
			return { Kind = "Section", Floating = self.Floating == true, Side = self.Side, Order = Frame.LayoutOrder, Position = self.FloatWindow and Layout.ReadPosition(self.FloatWindow) }
		end, function(Value)
			if Value.Kind ~= "Section" then return end
			self.Side = Value.Side
			Frame.LayoutOrder = Value.Order
			if Value.Floating then
				Detach()
				Layout.SetPosition(self.FloatWindow, Value.Position)
			else
				self:Redock(true)
				Frame.Parent = self.Tab.Columns[Value.Side]
				Frame.LayoutOrder = Value.Order
			end
		end)
	end

	function Section:Redock(Silent)
		if self.Floating and self.Dock then
			local Columns = self.Tab.Columns
			self.Frame.Parent = Columns[self.Side]
			self.Frame.LayoutOrder = self.Order
			local Float = self.FloatWindow
			self.FloatWindow, self.Floating = nil, false
			local Index = table.find(self.Window.Floating, Float)
			if Index then table.remove(self.Window.Floating, Index) end
			if Float then Float:Destroy() end
			if not Silent then Library:SaveLayout() end
		end
	end

	function Window:ResetLayout()
		for _, Section_ in self.Sections do Section_:Redock(true) end
		Library:SaveLayout()
	end

	local Class, RegisterFlag, LayoutGlyph, ResetGlyph; do
		local ElementBase = {}
		ElementBase.__index = ElementBase
		Library.Classes.ElementBase = ElementBase

		function Class(Name)
			local Object = {}
			Object.__index = function(_, Key)
				local Value = rawget(Object, Key)
				if Value ~= nil then return Value end
				return ElementBase[Key]
			end
			Library.Classes[Name] = Object
			return Object
		end

		function ElementBase:Get() return self.Value end
		function ElementBase:OnChanged(Callback)
			self.ChangedCallbacks = self.ChangedCallbacks or {}
			table.insert(self.ChangedCallbacks, Callback)
			return self
		end
		function ElementBase:SetVisible(Visible)
			if self.Row then self.Row.Visible = Visible end
		end
		function ElementBase:_Fire(...)
			SafeCall(self.Callback, ...)
			for _, Callback in self.ChangedCallbacks or {} do SafeCall(Callback, ...) end
		end
		function ElementBase:Serialize() return self.Value end
		function ElementBase:Deserialize(Value) self:Set(Value) end

		function RegisterFlag(Element)
			if Element.Flag then
				Library.Flags[Element.Flag] = Element.Value
				Library.Elements[Element.Flag] = Element
			end
		end

		function Container:_Row(Height, Class_)
			self.Counter += 1
			return Create(Class_ or "Frame", {
				Name = "Element",
				Size = UDim2.new(1, 0, 0, Height),
				BackgroundTransparency = 1,
				LayoutOrder = self.Counter,
				Parent = self.Holder,
			})
		end

		function Container:_Index(Title, Type, Row)
			if not self.Tab or self.NoIndex then return end
			Library:_Index({ Title = Title, Path = self.Path or self.Tab.Title, Type = Type, Tab = self.Tab, Target = Row, Section = self.Section })
		end

		function LayoutGlyph(Parent)
			local Glyph = Create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -7, 0.5, 0), Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1, Parent = Parent })
			for _, Rect in { { 0, 0, 12, 4 }, { 0, 5, 5, 7 }, { 7, 5, 5, 7 } } do
				local Part = Create("Frame", { Position = UDim2.fromOffset(Rect[1], Rect[2]), Size = UDim2.fromOffset(Rect[3], Rect[4]), Theme = { BackgroundColor3 = "Inactive Text" }, Parent = Glyph })
				Corner(Part, 1)
			end
			return Glyph
		end

		function ResetGlyph(Parent, Size)
			Size = Size or 12
			local Glyph = Create("Frame", { Size = UDim2.fromOffset(Size, Size), BackgroundTransparency = 1, Parent = Parent })
			local Ring = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = Glyph })
			Corner(Ring, Size)
			local RingStroke = Create("UIStroke", { Thickness = 1.4, Theme = { Color = "Text" }, Parent = Ring })
			Create("UIGradient", {
				Rotation = -135,
				Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.12, 1), NumberSequenceKeypoint.new(0.13, 0), NumberSequenceKeypoint.new(1, 0) }),
				Parent = RingStroke,
			})
			local Arrow = Create("ImageLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 1, 0.78, 0), Size = UDim2.fromOffset(6, 6), Rotation = 90, Theme = { ImageColor3 = "Text" }, Parent = Glyph })
			SetIcon(Arrow, "Arrow")
			return Glyph
		end
	end

	local ToggleClass = Class("Toggle")

	function Container:AddToggle(Config)
		Config = Config or {}
		local Self = setmetatable({
			Type = "Toggle",
			Text = Config.Text or Config.Title or Config.Name or "Toggle",
			Value = Config.Default == true or Config.Value == true,
			Callback = Config.Callback,
			Container = self,
			Risky = Config.Risky,
			ExtraCount = 0,
		}, ToggleClass)
		Self.Flag = Config.Flag or NextFlag((self.Path or "") .. "/" .. Self.Text)

		local Row = self:_Row(16, "TextButton")
		local Label = Create("TextLabel", {
			Weight = "SemiBold",
			Size = UDim2.new(1, -40, 1, 0),
			Text = Self.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Theme = { TextColor3 = Self.Value and "Text" or "Inactive Text" },
			Parent = Row,
		})
		local Extras = Create("Frame", {
			Name = "Extras",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Parent = Row,
		})
		ListLayout(Extras, 8, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)

		local Track = Create("Frame", { Name = "Track", Size = UDim2.fromOffset(28, 16), Theme = { BackgroundColor3 = "Element" }, LayoutOrder = 1000, Parent = Extras })
		Corner(Track, 8)
		Shade(Track)
		Stroke(Track, "Outline")
		local Fill = Create("Frame", { Size = UDim2.fromScale(1, 1), Theme = { BackgroundColor3 = "ToggleFill" }, BackgroundTransparency = Self.Value and 0 or 1, Parent = Track })
		Corner(Fill, 8)
		Shade(Fill)
		local Knob = Create("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, Self.Value and 16 or 2, 0.5, 0),
			Size = UDim2.fromOffset(10, 10),
			Theme = { BackgroundColor3 = Self.Value and "Knob" or "KnobOff" },
			ZIndex = 2,
			Parent = Track,
		})
		Corner(Knob, 5)

		Self.Row, Self.Label, Self.Extras, Self.Track, Self.Fill, Self.Knob = Row, Label, Extras, Track, Fill, Knob

		Connect(Extras:GetPropertyChangedSignal("AbsoluteSize"), function()
			Label.Size = UDim2.new(1, -(Extras.AbsoluteSize.X + 8), 1, 0)
		end)
		Connect(Row.MouseButton1Click, function() Self:Set(not Self.Value) end)

		RegisterFlag(Self)
		if Config.Keybind ~= false then Self:AddKeybind() end
		self:_Index(Self.Text, "Toggle", Row)
		if Self.Value then task.defer(Self._Fire, Self, true) end
		return Self
	end

	function ToggleClass:Set(Value, Silent)
		Value = Value == true
		local Changed = Value ~= self.Value
		self.Value = Value
		if self.Flag then Library.Flags[self.Flag] = Value end
		Tween(self.Fill, { BackgroundTransparency = Value and 0 or 1 }, 0.2)
		Tween(self.Knob, { Position = UDim2.new(0, Value and 16 or 2, 0.5, 0) }, 0.25)
		ThemeTween(self.Knob, "BackgroundColor3", Value and "Knob" or "KnobOff", 0.2)
		ThemeTween(self.Label, "TextColor3", Value and "Text" or "Inactive Text", 0.2)
		Library:_RefreshHotkeys()
		if Changed and not Silent then self:_Fire(Value) end
	end

	function ToggleClass:SetText(Text)
		self.Text = Text
		Library:SetText(self.Label, Text)
	end

	function ToggleClass:_ExtraOrder()
		self.ExtraCount += 1
		return 900 - self.ExtraCount
	end

	do
		local KeybindClass = Class("Keybind")

		local function CreateKeybox(Parent, LayoutOrder)
			local Box = Create("TextButton", {
				Name = "Keybind",
				Size = UDim2.fromOffset(0, 16),
				AutomaticSize = Enum.AutomaticSize.X,
				TextSize = 10,
				NoCase = true,
				Text = "",
				BackgroundTransparency = 0,
				Theme = { BackgroundColor3 = "Element", TextColor3 = "Inactive Text" },
				LayoutOrder = LayoutOrder or 0,
				Parent = Parent,
			})
			Corner(Box, 4)
			Shade(Box)
			Stroke(Box, "Outline")
			Padding(Box, 0, 0, 5, 5)
			Create("UISizeConstraint", { MinSize = Vector2.new(18, 16), Parent = Box })
			return Box, Box
		end

		local function NewKeybind(Config, Container_, Toggle)
			local Default = KeyFromName(Config.Default or Config.Key)
			local Self = setmetatable({
				Type = "Keybind",
				Text = Config.Text or Config.Name or (Toggle and Toggle.Text) or "Keybind",
				Name = Config.Name,
				Value = { Key = Default, Mode = Config.Mode or "Toggle" },
				Default = { Key = Default, Mode = Config.Mode or "Toggle" },
				Callback = Config.Callback,
				Toggle = Toggle,
				Container = Container_,
				Displays = {},
				Active = false,
				NoList = Config.NoList,
				OnPress = Config.OnPress,
			}, KeybindClass)
			Self.Flag = Config.Flag or NextFlag(((Container_ and Container_.Path) or "") .. "/" .. Self.Text .. "_Key")
			table.insert(Library.Keybinds, Self)
			RegisterFlag(Self)
			return Self
		end

		function KeybindClass:_AddDisplay(Box, Label, OpenEditor)
			table.insert(self.Displays, { Box = Box, Label = Label })
			Connect(Box.MouseButton1Click, function()
				if Library.Listening ~= self then self:Listen() end
			end)
			if OpenEditor then
				Connect(Box.MouseButton2Click, function()
					if Library.Listening == self then self:StopListening() end
					self:OpenEditor(Box)
				end)
			end
			Connect(Box.MouseEnter, function()
				if Library.Listening ~= self then ThemeTween(Label, "TextColor3", "Text", 0.12) end
			end)
			Connect(Box.MouseLeave, function()
				if Library.Listening ~= self then ThemeTween(Label, "TextColor3", "Inactive Text", 0.12) end
			end)
			self:_Draw()
		end

		function KeybindClass:_IsOverDisplay()
			for _, Display in self.Displays do
				if Display.Box.Visible and IsMouseOver(Display.Box) then return true end
			end
			return false
		end

		function KeybindClass:Listen()
			if Library.Listening then Library.Listening:StopListening() end
			Library.Listening = self
			for _, Display in self.Displays do
				Display.Label.Text = "..."
				ThemeTween(Display.Label, "TextColor3", "Accent", 0.12)
			end
		end

		function KeybindClass:StopListening()
			if Library.Listening == self then Library.Listening = nil end
			self:_Draw()
		end

		function KeybindClass:_Draw()
			local Name = KeyName(self.Value.Key)
			for _, Display in self.Displays do
				Display.Label.Text = Name == "NONE" and (Display.Editor and "None" or "-") or Name
				ThemeTween(Display.Label, "TextColor3", IsMouseOver(Display.Box) and "Text" or "Inactive Text", 0.12)
			end
		end

		function KeybindClass:Set(Value, Silent)
			if type(Value) ~= "table" then Value = { Key = Value, Mode = self.Value.Mode } end
			self.Value = { Key = KeyFromName(Value.Key), Mode = Value.Mode or self.Value.Mode or "Toggle" }
			if self.Flag then Library.Flags[self.Flag] = self.Value end
			self:_Draw()
			if self.Editor then self:_DrawModes() end
			Library:_RefreshHotkeys()
			if not Silent then
				for _, Callback in self.ChangedCallbacks or {} do SafeCall(Callback, self.Value) end
			end
		end

		function KeybindClass:SetMode(Mode)
			self.Value.Mode = Mode
			if self.Flag then Library.Flags[self.Flag] = self.Value end
			if self.Editor then self:_DrawModes() end
			Library:_RefreshHotkeys()
		end

		function KeybindClass:Serialize()
			return { Key = self.Value.Key and self.Value.Key.Name or "None", Mode = self.Value.Mode }
		end

		function KeybindClass:Deserialize(Value)
			if type(Value) == "table" then self:Set({ Key = Value.Key, Mode = Value.Mode }) end
		end

		function KeybindClass:IsActive()
			if self.Toggle then return self.Toggle.Value end
			return self.Active
		end

		function KeybindClass:_Pressed(Down)
			if self.OnPress then
				if Down then SafeCall(self.OnPress) end
				return
			end
			local Mode = self.Value.Mode
			if self.Toggle then
				if Mode == "Hold" then
					self.Toggle:Set(Down)
				elseif Down then
					self.Toggle:Set(not self.Toggle.Value)
				end
			else
				if Mode == "Hold" then
					self.Active = Down
					self:_Fire(Down)
				elseif Down then
					self.Active = not self.Active
					self:_Fire(self.Active)
				end
			end
			Library:_RefreshHotkeys()
		end

		function KeybindClass:_DrawModes(Instant)
			local Editor = self.Editor
			local Time = Instant and 0 or 0.22
			Tween(Editor.Pill, { Position = UDim2.fromScale(self.Value.Mode == "Hold" and 0.5 or 0, 0) }, Time)
			for Mode, Label in Editor.ModeLabels do
				ThemeTween(Label, "TextColor3", Mode == self.Value.Mode and "Text" or "Inactive Text", Time)
			end
		end

		local EDITOR_WIDTH = 190

		function KeybindClass:_BuildEditor()
			local Frame = PopupPanel(UDim2.fromOffset(EDITOR_WIDTH, 107), "KeybindEditor")
			Create("TextLabel", { Weight = "SemiBold", Position = UDim2.fromOffset(11, 10), Size = UDim2.new(1, -100, 0, 22), Text = self.Toggle and self.Toggle.Text or self.Text, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text" }, Parent = Frame })
			local KeyButton = Create("TextButton", {
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -11, 0, 10),
				Size = UDim2.fromOffset(76, 22),
				TextSize = 11,
				NoCase = true,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Theme = { BackgroundColor3 = "Element", TextColor3 = "Inactive Text" },
				Parent = Frame,
			})
			Corner(KeyButton, 5)
			Shade(KeyButton)
			Stroke(KeyButton, "Outline")

			local Switch = Create("Frame", { Position = UDim2.fromOffset(11, 40), Size = UDim2.new(1, -22, 0, 25), Theme = { BackgroundColor3 = "Element" }, Parent = Frame })
			Corner(Switch, 5)
			Shade(Switch)
			Stroke(Switch, "Outline")
			local Pill = Create("Frame", { Size = UDim2.fromScale(0.5, 1), Theme = { BackgroundColor3 = "ToggleFill" }, Parent = Switch })
			Corner(Pill, 5)
			Shade(Pill)
			local ModeLabels = {}
			for Index, Mode in { "Toggle", "Hold" } do
				local Button = Create("TextButton", { Position = UDim2.fromScale((Index - 1) * 0.5, 0), Size = UDim2.fromScale(0.5, 1), BackgroundTransparency = 1, ZIndex = 2, Parent = Switch })
				ModeLabels[Mode] = Create("TextLabel", { Weight = "SemiBold", Size = UDim2.fromScale(1, 1), Text = "On " .. Mode, TextSize = 12, Theme = { TextColor3 = "Inactive Text" }, ZIndex = 2, Parent = Button })
				Connect(Button.MouseButton1Click, function()
					if self.Toggle and self.Value.Mode == "Hold" and Mode ~= "Hold" then self.Toggle:Set(false) end
					self:SetMode(Mode)
				end)
			end

			local Buttons = Create("Frame", { Position = UDim2.fromOffset(11, 73), Size = UDim2.new(1, -22, 0, 24), BackgroundTransparency = 1, Parent = Frame })
			local function EditorButton(Text, Order, Glyph)
				local Button = Create("TextButton", { Position = UDim2.new((Order - 1) * 0.5, Order == 1 and 0 or 3, 0, 0), Size = UDim2.new(0.5, -3, 1, 0), Theme = { BackgroundColor3 = "Element" }, Parent = Buttons })
				Corner(Button, 5)
				Shade(Button)
				Stroke(Button, "Outline")
				local Inner = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(0, 14), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = Button })
				ListLayout(Inner, 5, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)
				if Glyph then ResetGlyph(Inner, 10) end
				Create("TextLabel", { Weight = "SemiBold", Size = UDim2.fromOffset(0, 14), AutomaticSize = Enum.AutomaticSize.X, Text = Text, TextSize = 12, LayoutOrder = 2, Theme = { TextColor3 = "Text" }, Parent = Inner })
				Connect(Button.MouseEnter, function() ThemeTween(Button, "BackgroundColor3", "Hovered Element", 0.12) end)
				Connect(Button.MouseLeave, function() ThemeTween(Button, "BackgroundColor3", "Element", 0.12) end)
				return Button
			end
			local Clear = EditorButton("Clear", 1)
			local Reset = EditorButton("Reset", 2, true)
			Connect(Clear.MouseButton1Click, function()
				if Library.Listening == self then Library.Listening = nil end
				if self.Toggle and self.Value.Mode == "Hold" then self.Toggle:Set(false) end
				self:Set({ Key = nil })
			end)
			Connect(Reset.MouseButton1Click, function()
				if Library.Listening == self then Library.Listening = nil end
				local WasHold = self.Value.Mode == "Hold"
				self:Set({ Key = self.Default.Key, Mode = self.Default.Mode })
				if self.Toggle and WasHold and self.Default.Mode ~= "Hold" then self.Toggle:Set(false) end
			end)

			self.Editor = {
				Frame = Frame,
				Pill = Pill,
				ModeLabels = ModeLabels,
				Update = function(Popup) PlacePopup(Frame, Popup.Anchor, self.EditorOffset or 0, 6) end,
				OnClose = function()
					if Library.Listening == self then self:StopListening() end
					FadePopup(Frame, false)
				end,
			}
			self:_AddDisplay(KeyButton, KeyButton)
			self.Displays[#self.Displays].Editor = true
		end

		function KeybindClass:OpenEditor(Anchor, OffsetX)
			if not self.Editor then self:_BuildEditor() end
			local Editor = self.Editor
			if Editor.Open then
				Library:ClosePopup(Editor)
				if Editor.Anchor == Anchor then return end
			end
			Editor.Anchor = Anchor
			self.EditorOffset = OffsetX or 0
			self:_Draw()
			self:_DrawModes(true)
			Editor.ParentPopup = self.Container and self.Container.ParentPopup
			Library:OpenPopup(Editor)
			FadePopup(Editor.Frame, true)
			if not self.Value.Key then self:Listen() end
		end
		KeybindClass.OpenModes = KeybindClass.OpenEditor

		function ToggleClass:AddKeybind(Config)
			Config = Config or {}
			local Keybind = self.Keybind
			if not Keybind then
				Keybind = NewKeybind(Config, self.Container, self)
				self.Keybind = Keybind
				if Config.Flag == nil then
					Library.Elements[Keybind.Flag], Library.Flags[Keybind.Flag] = nil, nil
					Keybind.Flag = self.Flag .. "_Key"
					RegisterFlag(Keybind)
				end
				Connect(self.Row.MouseButton2Click, function()
					local OffsetX = math.floor(MousePosition().X - self.Row.AbsolutePosition.X - 12)
					Keybind:OpenEditor(self.Row, Clamp(OffsetX, 0, math.max(0, self.Row.AbsoluteSize.X - EDITOR_WIDTH)))
				end)
				return self
			end
			local Default = KeyFromName(Config.Default or Config.Key)
			Keybind.Default = { Key = Default, Mode = Config.Mode or "Toggle" }
			Keybind.Name = Config.Name or Keybind.Name
			Keybind.Callback = Config.Callback or Keybind.Callback
			if Config.NoList ~= nil then Keybind.NoList = Config.NoList end
			if Config.Flag and Config.Flag ~= Keybind.Flag then
				Library.Elements[Keybind.Flag], Library.Flags[Keybind.Flag] = nil, nil
				Keybind.Flag = Config.Flag
				RegisterFlag(Keybind)
			end
			Keybind:Set({ Key = Default, Mode = Keybind.Default.Mode }, true)
			return self
		end
		ToggleClass.AddKeyPicker = ToggleClass.AddKeybind
		ToggleClass.AddBind = ToggleClass.AddKeybind

		function ToggleClass:GetKeybind() return self.Keybind end

		function Container:AddKeybind(Config)
			Config = Config or {}
			local Row = self:_Row(16)
			local Label = Create("TextLabel", {
				Weight = "SemiBold",
				Size = UDim2.new(1, -60, 1, 0),
				Text = Config.Text or Config.Title or "Keybind",
				TextXAlignment = Enum.TextXAlignment.Left,
				Theme = { TextColor3 = "Text" },
				Parent = Row,
			})
			local Holder = Create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = Row })
			ListLayout(Holder, 0, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
			local Box, Text = CreateKeybox(Holder, 1)
			local Keybind = NewKeybind(Config, self, nil)
			Keybind.Box, Keybind.Label = Box, Text
			Keybind:_AddDisplay(Box, Text, true)
			Keybind.Row, Keybind.TextLabel = Row, Label
			self:_Index(Keybind.Text, "Keybind", Row)
			return Keybind
		end
		Container.AddKeyPicker = Container.AddKeybind
		Container.AddBind = Container.AddKeybind

		Connect(UserInputService.InputBegan, function(Input, Processed)
			local Listening = Library.Listening
			if Listening then
				local Type = Input.UserInputType
				if Type == Enum.UserInputType.Keyboard then
					if Input.KeyCode == Enum.KeyCode.Escape then
						Listening:StopListening()
					elseif Input.KeyCode == Enum.KeyCode.Backspace or Input.KeyCode == Enum.KeyCode.Delete then
						Library.Listening = nil
						Listening:Set({ Key = nil })
					else
						Library.Listening = nil
						Listening:Set({ Key = Input.KeyCode })
					end
				elseif Type == Enum.UserInputType.MouseButton1 or Type == Enum.UserInputType.Touch then
					if not Listening:_IsOverDisplay() then Listening:StopListening() end
				elseif Type == Enum.UserInputType.MouseButton2 or Type == Enum.UserInputType.MouseButton3 then
					if not Listening:_IsOverDisplay() then
						Library.Listening = nil
						Listening:Set({ Key = Type })
					end
				end
				return
			end
			if UserInputService:GetFocusedTextBox() then return end
			for _, Keybind in Library.Keybinds do
				if Keybind.Value.Key and InputMatches(Input, Keybind.Value.Key) then
					Keybind:_Pressed(true)
				end
			end
		end)

		Connect(UserInputService.InputEnded, function(Input)
			for _, Keybind in Library.Keybinds do
				if Keybind.Value.Key and Keybind.Value.Mode == "Hold" and InputMatches(Input, Keybind.Value.Key) then
					Keybind:_Pressed(false)
				end
			end
		end)
	end

	do
		local PickerClass = Class("ColorPicker")
		local AnimationModes = { "None", "Rainbow", "Fade", "Fade Alpha" }

		local function NewPicker(Config, Swatch, Container_, Owner)
			local Default = Config.Default or Config.Color or Color3.new(1, 1, 1)
			local H, S, V = Default:ToHSV()
			local Self = setmetatable({
				Type = "ColorPicker",
				Text = Config.Text or Config.Title or "Color",
				Value = { Color = Default, Alpha = Config.Alpha or Config.Transparency or 0, Animation = Config.Animation or "None" },
				Hue = H, Sat = S, Val = V,
				Callback = Config.Callback,
				Container = Container_,
				Swatch = Swatch,
				Owner = Owner,
				Current = Default,
				CurrentAlpha = Config.Alpha or 0,
			}, PickerClass)
			Self.Flag = Config.Flag or NextFlag(((Container_ and Container_.Path) or "") .. "/" .. Self.Text .. "_Color")
			Self:_Draw()
			Connect(Swatch.MouseButton1Click, function() Self:Open() end)
			RegisterFlag(Self)
			if Self.Value.Animation ~= "None" then Library.AnimatedPickers[Self] = true end
			return Self
		end

		local function CreateSwatch(Parent, LayoutOrder)
			local Swatch = Create("TextButton", { Name = "Swatch", Size = UDim2.fromOffset(13, 13), BackgroundColor3 = Color3.new(1, 1, 1), LayoutOrder = LayoutOrder or 0, Parent = Parent })
			Corner(Swatch, 4)
			local SwatchStroke = Stroke(Swatch, "Outline")
			SwatchStroke.Transparency = 0.4
			return Swatch
		end

		function PickerClass:_Draw()
			local Color = Color3.fromHSV(self.Hue, self.Sat, self.Val)
			self.Value.Color = Color
			if not Library.AnimatedPickers[self] then
				self.Current = Color
				self.CurrentAlpha = self.Value.Alpha
				self.Swatch.BackgroundColor3 = Color
				self.Swatch.BackgroundTransparency = math.min(self.Value.Alpha, 0.85)
			end
			if not Library.AnimatedPickers[self] then self:_DrawKnobs(self.Hue, self.Sat, self.Val, self.Value.Alpha) end
		end

		function PickerClass:_DrawKnobs(H, S, V, Alpha, Instant)
			if not self.Popup then return end
			local P = self.Parts
			local Color = Color3.fromHSV(H, S, V)
			P.SV.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
			P.SVKnob.BackgroundColor3 = Color
			P.HueKnob.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
			P.AlphaColor.BackgroundColor3 = Color
			P.AlphaKnob.BackgroundColor3 = Color
			local Positions = {
				[P.SVKnob] = UDim2.fromScale(S, 1 - V),
				[P.HueKnob] = UDim2.new(0.5, 0, H, 0),
				[P.AlphaKnob] = UDim2.new(Alpha, 0, 0.5, 0),
			}
			for Knob, Position in Positions do
				if Instant then Knob.Position = Position else Tween(Knob, { Position = Position }, 0.08) end
			end
		end

		function PickerClass:Set(Value, Silent, Alpha)
			if typeof(Value) == "Color3" then
				Value = { Color = Value, Alpha = Alpha or self.Value.Alpha, Animation = self.Value.Animation }
			end
			if type(Value) ~= "table" then return end
			local Color = Value.Color
			if type(Color) == "string" then Color = Color3.fromHex(Color) end
			if typeof(Color) == "Color3" then
				self.Hue, self.Sat, self.Val = Color:ToHSV()
			end
			if Value.Alpha ~= nil then self.Value.Alpha = Clamp(tonumber(Value.Alpha) or 0, 0, 1) end
			if Value.Animation ~= nil then self:SetAnimation(Value.Animation, true) end
			self:_Draw()
			if self.Flag then Library.Flags[self.Flag] = self.Value end
			if not Silent then self:_Fire(self.Value.Color, self.Value.Alpha) end
		end

		function PickerClass:SetAnimation(Mode, Silent)
			if not table.find(AnimationModes, Mode) then Mode = "None" end
			self.Value.Animation = Mode
			Library.AnimatedPickers[self] = Mode ~= "None" or nil
			if Mode == "None" then self:_Draw() end
			if self.AnimationDropdown and not Silent then self.AnimationDropdown:Set(Mode, true) end
		end

		function PickerClass:GetColor() return self.Current, self.CurrentAlpha end

		function PickerClass:Serialize()
			return { Color = self.Value.Color:ToHex(), Alpha = self.Value.Alpha, Animation = self.Value.Animation }
		end

		function PickerClass:Deserialize(Value)
			if type(Value) == "table" then
				self:Set({ Color = Value.Color and Color3.fromHex(Value.Color), Alpha = Value.Alpha, Animation = Value.Animation })
			end
		end

		function PickerClass:_Build()
			local Frame = PopupPanel(UDim2.fromOffset(215, 269), "ColorPicker")
			local Parts = {}

			local SV = Create("TextButton", { Position = UDim2.fromOffset(11, 11), Size = UDim2.fromOffset(171, 167), BackgroundColor3 = Color3.new(1, 0, 0), Parent = Frame })
			Corner(SV, 4)
			local White = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), Parent = SV })
			Corner(White, 4)
			Create("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = White })
			local Black = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), Parent = SV })
			Corner(Black, 4)
			Create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0), Parent = Black })
			local SVKnob = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12), ZIndex = 3, Parent = SV })
			Corner(SVKnob, 6)
			Create("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 2, Parent = SVKnob })

			local Hue = Create("TextButton", { Position = UDim2.fromOffset(191, 11), Size = UDim2.fromOffset(13, 167), BackgroundColor3 = Color3.new(1, 1, 1), Parent = Frame })
			Corner(Hue, 6)
			local Keypoints = {}
			for Index = 0, 6 do
				table.insert(Keypoints, ColorSequenceKeypoint.new(Index / 6, Color3.fromHSV((Index / 6) % 1, 1, 1)))
			end
			Keypoints[7] = ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 1, 1))
			Create("UIGradient", { Rotation = 90, Color = ColorSequence.new(Keypoints), Parent = Hue })
			local HueKnob = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12), ZIndex = 3, Parent = Hue })
			Corner(HueKnob, 6)
			Create("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 2, Parent = HueKnob })

			local Alpha = Create("TextButton", { Position = UDim2.fromOffset(11, 188), Size = UDim2.fromOffset(193, 12), BackgroundTransparency = 1, Parent = Frame })
			local Checker = Create("ImageLabel", { Size = UDim2.fromScale(1, 1), Image = Icons.Checker, ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.fromOffset(12, 12), Parent = Alpha })
			Corner(Checker, 6)
			local AlphaColor = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), Parent = Alpha })
			Corner(AlphaColor, 6)
			Create("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = AlphaColor })
			local AlphaKnob = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12), ZIndex = 3, Parent = Alpha })
			Corner(AlphaKnob, 6)
			Create("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 2, Parent = AlphaKnob })

			local DropHolder = Create("Frame", { Position = UDim2.fromOffset(11, 213), Size = UDim2.fromOffset(193, 47), BackgroundTransparency = 1, Parent = Frame })
			ListLayout(DropHolder, 0)
			local Mini = NewContainer(DropHolder, { Path = "" })
			Mini.NoIndex = true
			self.Popup = {
				Frame = Frame,
				Owner = self.Swatch,
				Update = function() PlacePopup(Frame, self.Swatch, -8, 9) end,
				OnClose = function() FadePopup(Frame, false) end,
			}
			Mini.ParentPopup = self.Popup
			self.AnimationDropdown = Mini:AddDropdown({
				Text = "Animations",
				Options = AnimationModes,
				Default = self.Value.Animation,
				Flag = self.Flag .. "_Animation",
				Callback = function(Mode)
					self:SetAnimation(Mode, true)
					if self.Flag then Library.Flags[self.Flag] = self.Value end
				end,
			})
			Library.Elements[self.Flag .. "_Animation"] = nil

			Parts.SV, Parts.SVKnob, Parts.HueKnob, Parts.AlphaColor, Parts.AlphaKnob = SV, SVKnob, HueKnob, AlphaColor, AlphaKnob
			self.Parts = Parts

			local Dragging
			local function Update()
				local Point = MousePosition()
				if Dragging == SV then
					self.Sat = Clamp((Point.X - SV.AbsolutePosition.X) / SV.AbsoluteSize.X, 0, 1)
					self.Val = 1 - Clamp((Point.Y - SV.AbsolutePosition.Y) / SV.AbsoluteSize.Y, 0, 1)
				elseif Dragging == Hue then
					self.Hue = Clamp((Point.Y - Hue.AbsolutePosition.Y) / Hue.AbsoluteSize.Y, 0, 0.999)
				elseif Dragging == Alpha then
					self.Value.Alpha = Round(Clamp((Point.X - Alpha.AbsolutePosition.X) / Alpha.AbsoluteSize.X, 0, 1), 0.01)
				end
				self:_Draw()
				if self.Flag then Library.Flags[self.Flag] = self.Value end
				self:_Fire(self.Value.Color, self.Value.Alpha)
			end
			for _, Area in { SV, Hue, Alpha } do
				Connect(Area.InputBegan, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						Dragging = Area
						Update()
					end
				end)
			end
			Connect(UserInputService.InputChanged, function(Input)
				if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then Update() end
			end)
			Connect(UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then Dragging = nil end
			end)
		end

		function PickerClass:Open()
			if not self.Popup then self:_Build() end
			if self.Popup.Open then
				Library:ClosePopup(self.Popup)
				return
			end
			self.Popup.ParentPopup = self.Container and self.Container.ParentPopup
			self:_Draw()
			Library:OpenPopup(self.Popup)
			FadePopup(self.Popup.Frame, true)
		end

		function ToggleClass:AddColorPicker(Config)
			Config = Config or {}
			local Swatch = CreateSwatch(self.Extras, self:_ExtraOrder())
			local Picker = NewPicker(Config, Swatch, self.Container, self)
			self.ColorPickers = self.ColorPickers or {}
			table.insert(self.ColorPickers, Picker)
			return self
		end
		ToggleClass.AddColorpicker = ToggleClass.AddColorPicker

		function Container:AddColorPicker(Config)
			Config = Config or {}
			local Row = self:_Row(16)
			local Label = Create("TextLabel", {
				Weight = "SemiBold",
				Size = UDim2.new(1, -24, 1, 0),
				Text = Config.Text or Config.Title or "Color",
				TextXAlignment = Enum.TextXAlignment.Left,
				Theme = { TextColor3 = "Text" },
				Parent = Row,
			})
			local Holder = Create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = Row })
			ListLayout(Holder, 8, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
			local Swatch = CreateSwatch(Holder, 100)
			local Picker = NewPicker(Config, Swatch, self, nil)
			Picker.Row, Picker.Label = Row, Label
			self:_Index(Picker.Text, "Colorpicker", Row)
			return Picker
		end
		Container.AddColorpicker = Container.AddColorPicker

		Connect(RunService.Heartbeat, function()
			local Now = os.clock()
			for Picker in Library.AnimatedPickers do
				local Mode = Picker.Value.Animation
				local Wave = 0.5 + 0.5 * math.sin(Now * 3)
				local H, S, V, Alpha = Picker.Hue, Picker.Sat, Picker.Val, Picker.Value.Alpha
				if Mode == "Rainbow" then
					H, S, V = (Now * 0.12) % 1, math.max(S, 0.6), math.max(V, 0.6)
				elseif Mode == "Fade" then
					V = V * (0.25 + 0.75 * Wave)
				elseif Mode == "Fade Alpha" then
					Alpha = Alpha + (1 - Alpha) * Wave
				end
				local Color = Color3.fromHSV(H, S, V)
				Picker.Current, Picker.CurrentAlpha = Color, Alpha
				if Picker.Popup and Picker.Popup.Open then Picker:_DrawKnobs(H, S, V, Alpha, true) end
				Picker.Swatch.BackgroundColor3 = Color
				Picker.Swatch.BackgroundTransparency = math.min(Alpha, 0.85)
				if Picker.Callback then SafeCall(Picker.Callback, Color, Alpha) end
			end
		end)
	end

	do
		function ToggleClass:AddSettings(Config)
			if self.SettingsContainer then return self.SettingsContainer end
			Config = Config or {}
			local Gear = Create("ImageButton", {
				Name = "Settings",
				Size = UDim2.fromOffset(13, 13),
				Theme = { ImageColor3 = "Inactive Text" },
				LayoutOrder = self:_ExtraOrder() - 100,
				Parent = self.Extras,
			})
			SetIcon(Gear, "Gear")
			local Frame = PopupPanel(UDim2.fromOffset(Config.Width or 206, 0), "ToggleSettings")
			Frame.AutomaticSize = Enum.AutomaticSize.Y
			local Items = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = Frame })
			Padding(Items, 11, 11, 11, 11)
			ListLayout(Items, 6)
			local Settings = NewContainer(Items, { Section = self.Container.Section, Tab = self.Container.Tab, Window = self.Container.Window, Path = (self.Container.Path or "") .. " / " .. self.Text })
			if Config.Title ~= false then
				Settings.Counter += 1
				local Title = Create("Frame", { Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, LayoutOrder = Settings.Counter, Parent = Items })
				local TitleIcon = Create("ImageLabel", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(12, 12), Theme = { ImageColor3 = "Inactive Text" }, Parent = Title })
				SetIcon(TitleIcon, "Gear")
				Create("TextLabel", { Weight = "SemiBold", Position = UDim2.fromOffset(19, 0), Size = UDim2.new(1, -19, 1, 0), Text = Config.Title or (self.Text .. " Settings"), TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Inactive Text" }, Parent = Title })
			end
			local Popup = {
				Frame = Frame,
				Owner = Gear,
				Update = function() PlacePopup(Frame, Gear, -8, 9) end,
				OnClose = function()
					FadePopup(Frame, false)
					ThemeTween(Gear, "ImageColor3", "Inactive Text", 0.15)
				end,
			}
			Settings.ParentPopup = Popup
			Connect(Gear.MouseEnter, function() ThemeTween(Gear, "ImageColor3", "Text", 0.15) end)
			Connect(Gear.MouseLeave, function() if not Popup.Open then ThemeTween(Gear, "ImageColor3", "Inactive Text", 0.15) end end)
			Connect(Gear.MouseButton1Click, function()
				if Popup.Open then Library:ClosePopup(Popup) return end
				Popup.ParentPopup = self.Container.ParentPopup
				Library:OpenPopup(Popup)
				FadePopup(Frame, true)
				ThemeTween(Gear, "ImageColor3", "Accent", 0.15)
			end)
			self.SettingsContainer = Settings
			return Settings
		end
		ToggleClass.Settings = ToggleClass.AddSettings
		ToggleClass.AddSetting = ToggleClass.AddSettings
	end

	do
		function Container:AddSeparator()
			local Row = self:_Row(15)
			local Line = Create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 8), BackgroundTransparency = 1, Parent = Row })
			Corner(Line, 4)
			Stroke(Line, "Outline")
			return { Row = Row, SetVisible = function(_, Visible) Row.Visible = Visible end }
		end
		Container.AddDivider = Container.AddSeparator
	end

	do
		local SliderClass = Class("Slider")

		function Container:AddSlider(Config)
			Config = Config or {}
			local Min, Max = Config.Min or 0, Config.Max or 100
			local Increment = Config.Increment or Config.Rounding or (Config.Decimals and 10 ^ -Config.Decimals) or Config.Decimal or 1
			local Self = setmetatable({
				Type = "Slider",
				Text = Config.Text or Config.Title or "Slider",
				Min = Min, Max = Max, Increment = Increment,
				Suffix = Config.Suffix or "",
				Prefix = Config.Prefix or "",
				Value = Clamp(Config.Default or Config.Value or Min, Min, Max),
				Callback = Config.Callback,
				Format = Config.Format,
				Container = self,
			}, SliderClass)
			Self.Flag = Config.Flag or NextFlag((self.Path or "") .. "/" .. Self.Text)

			local Row = self:_Row(32)
			local Label = Create("TextLabel", { Weight = "SemiBold", Size = UDim2.new(1, -60, 0, 14), Text = Self.Text, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Row })
			local ValueBox = Create("TextBox", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0, 7),
				Size = UDim2.fromOffset(0, 17),
				AutomaticSize = Enum.AutomaticSize.X,
				TextSize = 10,
				ClearTextOnFocus = false,
				Theme = { BackgroundColor3 = "Element", TextColor3 = "Inactive Text" },
				BackgroundTransparency = 0,
				Parent = Row,
			})
			Corner(ValueBox, 4)
			Shade(ValueBox)
			Stroke(ValueBox, "Outline")
			Padding(ValueBox, 0, 0, 5, 5)
			Create("UISizeConstraint", { MinSize = Vector2.new(22, 17), Parent = ValueBox })
			local Track = Create("TextButton", { Position = UDim2.fromOffset(0, 21), Size = UDim2.new(1, 0, 0, 10), Theme = { BackgroundColor3 = "Element" }, Parent = Row })
			Corner(Track, 5)
			Shade(Track)
			Stroke(Track, "Outline")
			local Fill = Create("Frame", { Size = UDim2.new(0, 10, 1, 0), Theme = { BackgroundColor3 = "ToggleFill" }, Parent = Track })
			Corner(Fill, 5)
			Shade(Fill)
			local Knob = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(10, 10), Theme = { BackgroundColor3 = "Knob" }, ZIndex = 2, Parent = Track })
			Corner(Knob, 5)

			Self.Row, Self.Label, Self.ValueBox, Self.Track, Self.Fill, Self.Knob = Row, Label, ValueBox, Track, Fill, Knob
			Self:_Draw(true)

			local Dragging = false
			local function UpdateFromMouse()
				local Percent = Clamp((MousePosition().X - Track.AbsolutePosition.X - 5) / math.max(1, Track.AbsoluteSize.X - 10), 0, 1)
				Self:Set(Min + (Max - Min) * Percent)
			end
			Connect(Track.InputBegan, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true
					UpdateFromMouse()
				end
			end)
			Connect(UserInputService.InputChanged, function(Input)
				if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then UpdateFromMouse() end
			end)
			Connect(UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
			end)
			Connect(ValueBox.FocusLost, function()
				local Number = tonumber((ValueBox.Text:gsub("[^%d%.%-]", "")))
				if Number then Self:Set(Number) else Self:_Draw() end
			end)

			RegisterFlag(Self)
			self:_Index(Self.Text, "Slider", Row)
			task.defer(Self._Fire, Self, Self.Value)
			return Self
		end

		function SliderClass:_Text()
			if self.Format then return self.Format(self.Value) end
			local Value = self.Value
			local Text
			if self.Increment >= 1 then
				Text = tostring(math.floor(Value + 0.5))
			else
				local Decimals = math.max(0, math.ceil(-math.log10(self.Increment) - 1e-9))
				Text = string.format("%." .. Decimals .. "f", Value)
			end
			return self.Prefix .. Text .. self.Suffix
		end

		function SliderClass:_Draw(Instant)
			local Percent = (self.Value - self.Min) / math.max(1e-9, self.Max - self.Min)
			local Time = Instant and 0 or 0.12
			Tween(self.Fill, { Size = UDim2.new(Percent, 10 - 10 * Percent, 1, 0) }, Time)
			Tween(self.Knob, { Position = UDim2.new(Percent, 5 - 10 * Percent, 0.5, 0) }, Time)
			self.ValueBox.Text = self:_Text()
		end

		function SliderClass:Set(Value, Silent)
			Value = tonumber(Value) or self.Value
			Value = Clamp(Round(Value, self.Increment), self.Min, self.Max)
			Value = tonumber(string.format("%.6f", Value))
			local Changed = Value ~= self.Value
			self.Value = Value
			if self.Flag then Library.Flags[self.Flag] = Value end
			self:_Draw()
			if Changed and not Silent then self:_Fire(Value) end
		end

		function SliderClass:SetMax(Max) self.Max = Max; self:Set(self.Value) end
		function SliderClass:SetMin(Min) self.Min = Min; self:Set(self.Value) end
	end

	do
		local RangeClass = Class("RangeSlider")

		function Container:AddRangeSlider(Config)
			Config = Config or {}
			local Min, Max = Config.Min or 0, Config.Max or 100
			local Default = Config.Default or { Min, Max }
			local Self = setmetatable({
				Type = "RangeSlider",
				Text = Config.Text or Config.Title or "Range",
				Min = Min, Max = Max,
				Increment = Config.Increment or Config.Rounding or 1,
				Suffix = Config.Suffix or "",
				Value = { Clamp(Default[1] or Default.Min or Min, Min, Max), Clamp(Default[2] or Default.Max or Max, Min, Max) },
				Callback = Config.Callback,
				Container = self,
			}, RangeClass)
			Self.Flag = Config.Flag or NextFlag((self.Path or "") .. "/" .. Self.Text)

			local Row = self:_Row(32)
			Create("TextLabel", { Weight = "SemiBold", Size = UDim2.new(1, -90, 0, 14), Text = Self.Text, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Row })
			local ValueBox = Create("TextLabel", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0, 7),
				Size = UDim2.fromOffset(0, 17),
				AutomaticSize = Enum.AutomaticSize.X,
				TextSize = 10,
				NoCase = true,
				BackgroundTransparency = 0,
				Theme = { BackgroundColor3 = "Element", TextColor3 = "Inactive Text" },
				Parent = Row,
			})
			Corner(ValueBox, 4)
			Shade(ValueBox)
			Stroke(ValueBox, "Outline")
			Padding(ValueBox, 0, 0, 5, 5)
			local Track = Create("TextButton", { Position = UDim2.fromOffset(0, 21), Size = UDim2.new(1, 0, 0, 10), Theme = { BackgroundColor3 = "Element" }, Parent = Row })
			Corner(Track, 5)
			Shade(Track)
			Stroke(Track, "Outline")
			local Fill = Create("Frame", { Theme = { BackgroundColor3 = "ToggleFill" }, Parent = Track })
			Corner(Fill, 5)
			Shade(Fill)
			local Knobs = {}
			for Index = 1, 2 do
				Knobs[Index] = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(10, 10), Theme = { BackgroundColor3 = "Knob" }, ZIndex = 2, Parent = Track })
				Corner(Knobs[Index], 5)
			end
			Self.Row, Self.ValueBox, Self.Track, Self.Fill, Self.Knobs = Row, ValueBox, Track, Fill, Knobs
			Self:_Draw(true)

			local Dragging
			local function Percent()
				return Clamp((MousePosition().X - Track.AbsolutePosition.X - 5) / math.max(1, Track.AbsoluteSize.X - 10), 0, 1)
			end
			local function Update()
				local Value = Min + (Max - Min) * Percent()
				local New = table.clone(Self.Value)
				New[Dragging] = Value
				if New[1] > New[2] then
					New[1], New[2] = New[2], New[1]
					Dragging = 3 - Dragging
				end
				Self:Set(New)
			end
			Connect(Track.InputBegan, function(Input)
				if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end
				local Value = Min + (Max - Min) * Percent()
				Dragging = math.abs(Value - Self.Value[1]) <= math.abs(Value - Self.Value[2]) and 1 or 2
				Update()
			end)
			Connect(UserInputService.InputChanged, function(Input)
				if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then Update() end
			end)
			Connect(UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then Dragging = nil end
			end)
			RegisterFlag(Self)
			self:_Index(Self.Text, "Range slider", Row)
			task.defer(Self._Fire, Self, Self.Value)
			return Self
		end

		function RangeClass:_Format(Value)
			if self.Increment >= 1 then return tostring(math.floor(Value + 0.5)) end
			local Decimals = math.max(0, math.ceil(-math.log10(self.Increment) - 1e-9))
			return string.format("%." .. Decimals .. "f", Value)
		end

		function RangeClass:_Draw(Instant)
			local Span = math.max(1e-9, self.Max - self.Min)
			local A, B = (self.Value[1] - self.Min) / Span, (self.Value[2] - self.Min) / Span
			local Time = Instant and 0 or 0.12
			Tween(self.Knobs[1], { Position = UDim2.new(A, 5 - 10 * A, 0.5, 0) }, Time)
			Tween(self.Knobs[2], { Position = UDim2.new(B, 5 - 10 * B, 0.5, 0) }, Time)
			Tween(self.Fill, { Position = UDim2.new(A, -10 * A, 0, 0), Size = UDim2.new(B - A, 10 + 10 * A - 10 * B, 1, 0) }, Time)
			self.ValueBox.Text = self:_Format(self.Value[1]) .. self.Suffix .. " - " .. self:_Format(self.Value[2]) .. self.Suffix
		end

		function RangeClass:Set(Value, Silent)
			if type(Value) ~= "table" then return end
			local A = Clamp(Round(tonumber(Value[1] or Value.Min) or self.Value[1], self.Increment), self.Min, self.Max)
			local B = Clamp(Round(tonumber(Value[2] or Value.Max) or self.Value[2], self.Increment), self.Min, self.Max)
			if A > B then A, B = B, A end
			A, B = tonumber(string.format("%.6f", A)), tonumber(string.format("%.6f", B))
			local Changed = A ~= self.Value[1] or B ~= self.Value[2]
			self.Value = { A, B }
			if self.Flag then Library.Flags[self.Flag] = self.Value end
			self:_Draw()
			if Changed and not Silent then self:_Fire(self.Value) end
		end
	end

	local OptionRow; do
		local DropdownClass = Class("Dropdown")

		function OptionRow(Parent, Text, Order)
			local Option = Create("TextButton", {
				Name = "Option",
				Size = UDim2.new(1, 0, 0, 24),
				BackgroundTransparency = 1,
				Theme = { BackgroundColor3 = "Tab" },
				LayoutOrder = Order or 0,
				Parent = Parent,
			})
			local Bar = Create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 7, 0.5, 0), Size = UDim2.fromOffset(3, 12), Theme = { BackgroundColor3 = "Accent" }, BackgroundTransparency = 1, Parent = Option })
			Corner(Bar, 1)
			local Label = Create("TextLabel", {
				Weight = "SemiBold",
				Position = UDim2.fromOffset(8, 0),
				Size = UDim2.new(1, -16, 1, 0),
				Text = Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Theme = { TextColor3 = "Inactive Text" },
				Parent = Option,
			})
			local Self = { Button = Option, Bar = Bar, Label = Label, Value = Text, Selected = false }
			function Self.SetSelected(_, Selected, Instant)
				Self.Selected = Selected
				local Time = Instant and 0 or 0.18
				Tween(Option, { BackgroundTransparency = Selected and 0 or 1 }, Time)
				Tween(Bar, { BackgroundTransparency = Selected and 0 or 1 }, Time)
				Tween(Label, { Position = UDim2.fromOffset(Selected and 18 or 8, 0) }, Time)
				ThemeTween(Label, "TextColor3", Selected and "Text" or "Inactive Text", Time)
			end
			Connect(Option.MouseEnter, function()
				if not Self.Selected then Tween(Option, { BackgroundTransparency = 0.6 }, 0.15) end
			end)
			Connect(Option.MouseLeave, function()
				if not Self.Selected then Tween(Option, { BackgroundTransparency = 1 }, 0.15) end
			end)
			return Self
		end

		local function NormalizeOptions(Options)
			local Values, Names = {}, {}
			for _, Option in Options or {} do
				local Value, Name = Option, tostring(Option)
				if type(Option) == "table" then
					Value = Option.Value ~= nil and Option.Value or Option.Name
					Name = tostring(Option.Name or Option.Value)
				end
				table.insert(Values, Value)
				Names[Value] = Name
			end
			return Values, Names
		end

		function Container:AddDropdown(Config)
			Config = Config or {}
			local Multi = Config.Multi == true
			local Values, Names = NormalizeOptions(Config.Options or Config.Values)
			local Default = Config.Default
			if Multi then
				Default = type(Default) == "table" and table.clone(Default) or (Default ~= nil and { Default } or {})
			elseif Default == nil and not Config.AllowNone then
				Default = Values[1]
			end
			local Self = setmetatable({
				Type = "Dropdown",
				Text = Config.Text or Config.Title or Config.Name,
				Options = Values,
				Names = Names,
				Multi = Multi,
				Value = Default,
				Callback = Config.Callback,
				Searchable = Config.Search or Config.Searchable,
				MaxVisible = Config.MaxVisible or 8,
				Container = self,
				OptionRows = {},
			}, DropdownClass)
			Self.Flag = Config.Flag or NextFlag((self.Path or "") .. "/" .. (Self.Text or "Dropdown"))

			local HasLabel = Self.Text ~= nil and Self.Text ~= ""
			local Row = self:_Row(HasLabel and 47 or 25)
			if HasLabel then
				Self.Label = Create("TextLabel", { Weight = "SemiBold", Size = UDim2.new(1, 0, 0, 14), Text = Self.Text, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Row })
			end
			local Box = Create("TextButton", {
				Position = UDim2.fromOffset(0, HasLabel and 21 or 0),
				Size = UDim2.new(1, 0, 0, 25),
				Theme = { BackgroundColor3 = "Element" },
				Parent = Row,
			})
			Corner(Box, 5)
			Shade(Box)
			Stroke(Box, "Outline")
			local ValueLabel = Create("TextLabel", {
				Weight = "SemiBold",
				Position = UDim2.fromOffset(8, 0),
				Size = UDim2.new(1, -30, 1, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Theme = { TextColor3 = "Inactive Text" },
				Parent = Box,
			})
			LayoutGlyph(Box)
			Self.Row, Self.Box, Self.ValueLabel = Row, Box, ValueLabel

			Self:_DrawValue()
			Connect(Box.MouseEnter, function() ThemeTween(ValueLabel, "TextColor3", "Text", 0.12) end)
			Connect(Box.MouseLeave, function() ThemeTween(ValueLabel, "TextColor3", "Inactive Text", 0.12) end)
			Connect(Box.MouseButton1Click, function() Self:Toggle() end)
			RegisterFlag(Self)
			if Self.Text then self:_Index(Self.Text, "Dropdown", Row) end
			task.defer(function() if Self.Value ~= nil then Self:_Fire(Self.Value) end end)
			return Self
		end

		function Container:AddMultiDropdown(Config)
			Config = Config or {}
			Config.Multi = true
			return self:AddDropdown(Config)
		end

		function DropdownClass:_Name(Value)
			return self.Names[Value] or tostring(Value)
		end

		function DropdownClass:_DrawValue()
			local Text
			if self.Multi then
				local Shown = {}
				for _, Value in self.Value do table.insert(Shown, self:_Name(Value)) end
				Text = #Shown > 0 and table.concat(Shown, ", ") or "None"
			else
				Text = self.Value ~= nil and self:_Name(self.Value) or "None"
			end
			Library:SetText(self.ValueLabel, Text)
		end

		function DropdownClass:IsSelected(Option)
			if self.Multi then return table.find(self.Value, Option) ~= nil end
			return self.Value == Option
		end

		function DropdownClass:_BuildList()
			if self.Popup then self.Popup.Frame:Destroy() end
			local Frame = PopupPanel(UDim2.fromOffset(100, 100), "DropdownList", 5)
			local Search
			local Top = 1
			if self.Searchable then
				Search = Create("TextBox", {
					Weight = "SemiBold",
					Position = UDim2.fromOffset(6, 6),
					Size = UDim2.new(1, -12, 0, 22),
					PlaceholderText = "Search...",
					Text = "",
					ClearTextOnFocus = false,
					TextXAlignment = Enum.TextXAlignment.Left,
					Theme = { BackgroundColor3 = "Element", TextColor3 = "Text", PlaceholderColor3 = "Inactive Text" },
					BackgroundTransparency = 0,
					Parent = Frame,
				})
				Corner(Search, 4)
				Stroke(Search, "Outline")
				Padding(Search, 0, 0, 7, 7)
				Top = 32
			end
			local List = Create("ScrollingFrame", {
				Position = UDim2.fromOffset(1, Top),
				Size = UDim2.new(1, -2, 1, -(Top + 1)),
				ScrollBarThickness = 2,
				ScrollBarImageTransparency = 0,
				Theme = { ScrollBarImageColor3 = "Accent" },
				Parent = Frame,
			})
			ListLayout(List, 0)
			self.OptionRows = {}
			for Index, Option in self.Options do
				local Option_ = OptionRow(List, self:_Name(Option), Index)
				Option_.Value = Option
				Option_:SetSelected(self:IsSelected(Option), true)
				Connect(Option_.Button.MouseButton1Click, function() self:_Choose(Option) end)
				table.insert(self.OptionRows, Option_)
			end
			if Search then
				Connect(Search:GetPropertyChangedSignal("Text"), function()
					local Query = Search.Text:lower()
					local Count = 0
					for _, Option_ in self.OptionRows do
						local Match = Query == "" or self:_Name(Option_.Value):lower():find(Query, 1, true) ~= nil
						Option_.Button.Visible = Match
						if Match then Count += 1 end
					end
					self:_ResizeList(Count)
				end)
			end
			self.ListFrame, self.ListScroll, self.ListTop, self.SearchBox = Frame, List, Top, Search
			self.Popup = {
				Frame = Frame,
				Owner = self.Box,
				Update = function()
					Frame.Size = UDim2.fromOffset(self.Box.AbsoluteSize.X, Frame.Size.Y.Offset)
					PlacePopup(Frame, self.Box, 0, 8)
				end,
				OnClose = function() FadePopup(Frame, false) end,
			}
			self:_ResizeList(#self.Options)
		end

		function DropdownClass:_ResizeList(Count)
			local Visible = math.min(math.max(Count, 1), self.MaxVisible)
			self.ListFrame.Size = UDim2.fromOffset(self.Box.AbsoluteSize.X, Visible * 24 + 2 + (self.ListTop - 1))
		end

		function DropdownClass:_Choose(Option)
			if self.Multi then
				local Value = table.clone(self.Value)
				local Index = table.find(Value, Option)
				if Index then table.remove(Value, Index) else table.insert(Value, Option) end
				self:Set(Value)
			else
				self:Set(Option)
				if self.Popup then Library:ClosePopup(self.Popup) end
			end
		end

		function DropdownClass:Toggle()
			if not self.Popup or self._Dirty then
				self:_BuildList()
				self._Dirty = false
			end
			if self.Popup.Open then
				Library:ClosePopup(self.Popup)
				return
			end
			for _, Option_ in self.OptionRows do Option_:SetSelected(self:IsSelected(Option_.Value), true) end
			if self.SearchBox then self.SearchBox.Text = "" end
			self.Popup.ParentPopup = self.Container and self.Container.ParentPopup
			Library:OpenPopup(self.Popup)
			FadePopup(self.ListFrame, true, 4)
		end

		function DropdownClass:Set(Value, Silent)
			if self.Multi then
				if type(Value) ~= "table" then Value = Value ~= nil and { Value } or {} end
				local Clean = {}
				for _, Option in Value do
					if table.find(self.Options, Option) and not table.find(Clean, Option) then table.insert(Clean, Option) end
				end
				self.Value = Clean
			else
				if Value ~= nil and not table.find(self.Options, Value) then return end
				self.Value = Value
			end
			if self.Flag then Library.Flags[self.Flag] = self.Value end
			self:_DrawValue()
			for _, Option_ in self.OptionRows do Option_:SetSelected(self:IsSelected(Option_.Value)) end
			if not Silent then self:_Fire(self.Value) end
		end

		function DropdownClass:SetOptions(Options, Keep)
			self.Options, self.Names = NormalizeOptions(Options)
			self._Dirty = true
			if self.Popup and self.Popup.Open then
				Library:ClosePopup(self.Popup)
			end
			if not Keep then
				if self.Multi then self:Set({}, true) else self:Set(self.Options[1], true) end
			else
				self:Set(self.Value, true)
			end
		end
		DropdownClass.Refresh = DropdownClass.SetOptions
	end

	do
		local ButtonClass = Class("Button")

		local function CreateButton(Parent, Config, Container_)
			local Self = setmetatable({ Type = "Button", Text = Config.Text or Config.Title or "Button", Callback = Config.Callback, Container = Container_, Confirm = Config.Confirm or Config.Confirmation }, ButtonClass)
			local Button = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), Theme = { BackgroundColor3 = "Element" }, Parent = Parent })
			Corner(Button, 5)
			Shade(Button)
			Stroke(Button, "Outline")
			local Label = Create("TextLabel", { Weight = "SemiBold", Size = UDim2.fromScale(1, 1), Text = Self.Text, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text" }, Parent = Button })
			Self.Button, Self.Label = Button, Label
			local Pending = false
			Connect(Button.MouseEnter, function() ThemeTween(Button, "BackgroundColor3", "Hovered Element", 0.15) end)
			Connect(Button.MouseLeave, function() ThemeTween(Button, "BackgroundColor3", "Element", 0.15) end)
			Connect(Button.MouseButton1Down, function() Tween(Label, { TextTransparency = 0.35 }, 0.08) end)
			Connect(Button.MouseButton1Up, function() Tween(Label, { TextTransparency = 0 }, 0.15) end)
			Connect(Button.MouseButton1Click, function()
				if Self.Confirm and not Pending then
					Pending = true
					Library:SetText(Label, "Are you sure?")
					ThemeTween(Label, "TextColor3", "Accent", 0.15)
					task.delay(2.5, function()
						if Pending then
							Pending = false
							Library:SetText(Label, Self.Text)
							ThemeTween(Label, "TextColor3", "Text", 0.15)
						end
					end)
					return
				end
				if Pending then
					Pending = false
					Library:SetText(Label, Self.Text)
					ThemeTween(Label, "TextColor3", "Text", 0.15)
				end
				Self:_Fire()
			end)
			return Self
		end

		function Container:AddButton(Config, Callback)
			if type(Config) == "string" then Config = { Text = Config, Callback = Callback } end
			Config = Config or {}
			local Row = self:_Row(28)
			local Layout = ListLayout(Row, 6, Enum.FillDirection.Horizontal)
			pcall(function() Layout.HorizontalFlex = Enum.UIFlexAlignment.Fill end)
			local Self = CreateButton(Row, Config, self)
			Self.Row = Row
			Self.Button.Size = UDim2.new(1, 0, 1, 0)
			self:_Index(Self.Text, "Button", Row)
			return Self
		end

		function ButtonClass:AddButton(Config)
			Config = Config or {}
			local Other = CreateButton(self.Row, Config, self.Container)
			Other.Row = self.Row
			local Count = 0
			for _, Child in self.Row:GetChildren() do if Child:IsA("TextButton") then Count += 1 end end
			for _, Child in self.Row:GetChildren() do
				if Child:IsA("TextButton") then Child.Size = UDim2.new(1 / Count, -6 * (Count - 1) / Count, 1, 0) end
			end
			if self.Container then self.Container:_Index(Other.Text, "Button", self.Row) end
			return Other
		end

		function ButtonClass:SetText(Text)
			self.Text = Text
			Library:SetText(self.Label, Text)
		end
	end

	do
		local InputClass = Class("Input")

		function Container:AddInput(Config)
			Config = Config or {}
			local Self = setmetatable({
				Type = "Input",
				Text = Config.Text or Config.Title,
				Value = tostring(Config.Default or Config.Value or ""),
				Callback = Config.Callback,
				Numeric = Config.Numeric,
				Finished = Config.Finished ~= false and not Config.Live,
				Container = self,
			}, InputClass)
			Self.Flag = Config.Flag or NextFlag((self.Path or "") .. "/" .. (Self.Text or Config.Placeholder or "Input"))
			local HasLabel = Self.Text ~= nil and Self.Text ~= ""
			local Row = self:_Row(HasLabel and 46 or 25)
			if HasLabel then
				Create("TextLabel", { Weight = "SemiBold", Size = UDim2.new(1, 0, 0, 14), Text = Self.Text, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Row })
			end
			local Box = Create("TextBox", {
				Weight = "SemiBold",
				Position = UDim2.fromOffset(0, HasLabel and 21 or 0),
				Size = UDim2.new(1, 0, 0, 25),
				Text = Self.Value,
				PlaceholderText = Config.Placeholder or Config.PlaceHolder or "",
				ClearTextOnFocus = Config.ClearTextOnFocus == true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Theme = { BackgroundColor3 = "Element", TextColor3 = "Text", PlaceholderColor3 = "Inactive Text" },
				BackgroundTransparency = 0,
				Parent = Row,
			})
			Corner(Box, 5)
			Shade(Box)
			Stroke(Box, "Outline")
			Padding(Box, 0, 0, 8, 8)
			Self.Row, Self.Box = Row, Box

			local function Commit()
				local Text = Box.Text
				if Self.Numeric then
					Text = Text:gsub("[^%d%.%-]", "")
					Box.Text = Text
				end
				Self.Value = Text
				if Self.Flag then Library.Flags[Self.Flag] = Text end
				Self:_Fire(Text)
			end
			if Self.Finished then
				Connect(Box.FocusLost, Commit)
			else
				Connect(Box:GetPropertyChangedSignal("Text"), Commit)
			end
			RegisterFlag(Self)
			self:_Index(Self.Text or Config.Placeholder or "Input", "Input", Row)
			return Self
		end
		Container.AddTextbox = Container.AddInput

		function InputClass:Set(Value, Silent)
			Value = tostring(Value or "")
			self.Value = Value
			self.Box.Text = Value
			if self.Flag then Library.Flags[self.Flag] = Value end
			if not Silent then self:_Fire(Value) end
		end
	end

	do
		function Container:AddLabel(Config)
			if type(Config) == "string" then Config = { Text = Config } end
			Config = Config or {}
			self.Counter += 1
			local Label = Create("TextLabel", {
				Weight = "SemiBold",
				Name = "Label",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = Config.Text or "",
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				Theme = { TextColor3 = Config.Color or (Config.Muted == false and "Text" or "Inactive Text") },
				LayoutOrder = self.Counter,
				Parent = self.Holder,
			})
			local Self = { Type = "Label", Row = Label, Label = Label }
			function Self.SetText(_, Text) Library:SetText(Label, Text) end
			function Self.SetVisible(_, Visible) Label.Visible = Visible end
			return Self
		end
		Container.AddParagraph = Container.AddLabel
	end

	do
		local ListClass = Class("List")

		function Container:AddList(Config)
			Config = Config or {}
			local Multi = Config.Multi == true
			local Default = Config.Default
			if Multi then Default = type(Default) == "table" and table.clone(Default) or (Default ~= nil and { Default } or {}) end
			local Self = setmetatable({
				Type = "List",
				Text = Config.Text or Config.Title,
				Options = table.clone(Config.Options or Config.Values or {}),
				Multi = Multi,
				Value = Default,
				Callback = Config.Callback,
				Container = self,
				Rows = {},
				Query = "",
			}, ListClass)
			Self.Flag = Config.Flag or NextFlag((self.Path or "") .. "/" .. (Self.Text or "List"))
			local Height = Config.Height or Config.Size or 178
			local HasLabel = Self.Text ~= nil and Self.Text ~= ""
			local Searchable = Config.Search or Config.Searchable
			local Top = HasLabel and 21 or 0
			local Row = self:_Row(Top + Height + (Searchable and 31 or 0))
			if HasLabel then
				Create("TextLabel", { Weight = "SemiBold", Size = UDim2.new(1, 0, 0, 14), Text = Self.Text, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Row })
			end
			if Searchable then
				local Search = Create("TextBox", {
					Weight = "SemiBold",
					Position = UDim2.fromOffset(0, Top),
					Size = UDim2.new(1, 0, 0, 25),
					PlaceholderText = "Search...",
					Text = "",
					ClearTextOnFocus = false,
					TextXAlignment = Enum.TextXAlignment.Left,
					Theme = { BackgroundColor3 = "Element", TextColor3 = "Text", PlaceholderColor3 = "Inactive Text" },
					BackgroundTransparency = 0,
					Parent = Row,
				})
				Corner(Search, 5)
				Shade(Search)
				Stroke(Search, "Outline")
				Padding(Search, 0, 0, 8, 8)
				Connect(Search:GetPropertyChangedSignal("Text"), function()
					Self.Query = Search.Text:lower()
					Self:_Filter()
				end)
				Top += 31
			end
			local Box = Create("Frame", { Position = UDim2.fromOffset(0, Top), Size = UDim2.new(1, 0, 0, Height), Theme = { BackgroundColor3 = "Element" }, Parent = Row })
			Corner(Box, 5)
			Stroke(Box, "Outline")
			local Scroll = Create("ScrollingFrame", {
				Position = UDim2.fromOffset(1, 1),
				Size = UDim2.new(1, -2, 1, -2),
				ScrollBarThickness = 2,
				Theme = { ScrollBarImageColor3 = "Accent" },
				Parent = Box,
			})
			Padding(Scroll, 8, 8, 9, 9)
			ListLayout(Scroll, 0)
			Self.Row, Self.Box, Self.Scroll = Row, Box, Scroll
			Self:_Build()
			RegisterFlag(Self)
			if Self.Text then self:_Index(Self.Text, "List", Row) end
			return Self
		end
		Container.AddListbox = Container.AddList

		function ListClass:IsSelected(Option)
			if self.Multi then return table.find(self.Value, Option) ~= nil end
			return self.Value == Option
		end

		function ListClass:_Build()
			for _, Row in self.Rows do Row.Button:Destroy() end
			self.Rows = {}
			for Index, Option in self.Options do
				local Row = OptionRow(self.Scroll, tostring(Option), Index)
				Row.Value = Option
				Row:SetSelected(self:IsSelected(Option), true)
				Connect(Row.Button.MouseButton1Click, function()
					if self.Multi then
						local Value = table.clone(self.Value)
						local Found = table.find(Value, Option)
						if Found then table.remove(Value, Found) else table.insert(Value, Option) end
						self:Set(Value)
					else
						self:Set(Option)
					end
				end)
				table.insert(self.Rows, Row)
			end
			self:_Filter()
		end

		function ListClass:_Filter()
			for _, Row in self.Rows do
				Row.Button.Visible = self.Query == "" or tostring(Row.Value):lower():find(self.Query, 1, true) ~= nil
			end
		end

		function ListClass:Set(Value, Silent)
			if self.Multi then
				if type(Value) ~= "table" then Value = Value ~= nil and { Value } or {} end
				self.Value = table.clone(Value)
			else
				self.Value = Value
			end
			if self.Flag then Library.Flags[self.Flag] = self.Value end
			for _, Row in self.Rows do Row:SetSelected(self:IsSelected(Row.Value)) end
			if not Silent then self:_Fire(self.Value) end
		end

		function ListClass:SetOptions(Options)
			self.Options = table.clone(Options or {})
			if self.Multi then
				local Keep = {}
				for _, Option in self.Value do if table.find(self.Options, Option) then table.insert(Keep, Option) end end
				self.Value = Keep
			elseif self.Value ~= nil and not table.find(self.Options, self.Value) then
				self.Value = nil
			end
			self:_Build()
		end
		ListClass.Refresh = ListClass.SetOptions
	end

	do
		local PartPickerClass = Class("PartPicker")

		function Container:AddPartPicker(Config)
			Config = Config or {}
			local Self = setmetatable({ Type = "PartPicker", Text = Config.Text or "Part", Value = nil, Callback = Config.Callback, Container = self, Filter = Config.Filter }, PartPickerClass)
			local Row = self:_Row(47)
			Create("TextLabel", { Weight = "SemiBold", Size = UDim2.new(1, 0, 0, 14), Text = Self.Text, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Row })
			local Box = Create("TextButton", { Position = UDim2.fromOffset(0, 21), Size = UDim2.new(1, 0, 0, 25), Theme = { BackgroundColor3 = "Element" }, Parent = Row })
			Corner(Box, 5)
			Shade(Box)
			Stroke(Box, "Outline")
			local ValueLabel = Create("TextLabel", { Weight = "SemiBold", Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -30, 1, 0), Text = "None", NoCase = true, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Inactive Text" }, Parent = Box })
			local Crosshair = Create("ImageLabel", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -7, 0.5, 0), Size = UDim2.fromOffset(12, 12), Theme = { ImageColor3 = "Inactive Text" }, Parent = Box })
			SetIcon(Crosshair, "Bullseye")
			Self.Row, Self.Box, Self.ValueLabel = Row, Box, ValueLabel

			Connect(Box.MouseButton1Click, function() Self:Pick() end)
			self:_Index(Self.Text, "Part picker", Row)
			return Self
		end

		function PartPickerClass:Pick()
			if Library.Picking then return end
			Library.Picking = self
			self.ValueLabel.Text = "Click a part... (Esc to cancel)"
			ThemeTween(self.ValueLabel, "TextColor3", "Accent", 0.15)
			local Highlight = Instance.new("Highlight")
			Highlight.FillTransparency = 0.6
			Highlight.OutlineTransparency = 0
			Highlight.FillColor = Theme.Accent
			Highlight.OutlineColor = Theme.Accent
			Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			local Camera = Workspace.CurrentCamera
			local Params = RaycastParams.new()
			Params.FilterType = Enum.RaycastFilterType.Exclude
			Params.FilterDescendantsInstances = { LocalPlayer.Character }
			local Hovered
			local Window_ = Library.Window
			local WasOpen = Window_ and Window_.Open
			if Window_ then Window_:SetOpen(false) end
			local Step, Click
			local function Finish(Part)
				if Step then Step:Disconnect() end
				if Click then Click:Disconnect() end
				Highlight:Destroy()
				Library.Picking = nil
				if Window_ and WasOpen then Window_:SetOpen(true) end
				ThemeTween(self.ValueLabel, "TextColor3", "Inactive Text", 0.15)
				if Part then self:Set(Part) else self.ValueLabel.Text = self.Value and self.Value.Name or "None" end
			end
			Step = RunService.RenderStepped:Connect(function()
				local Point = MousePosition()
				local Ray = Camera:ScreenPointToRay(Point.X, Point.Y)
				local Result = Workspace:Raycast(Ray.Origin, Ray.Direction * 5000, Params)
				local Part = Result and Result.Instance
				if Part and self.Filter and not self.Filter(Part) then Part = nil end
				if Part ~= Hovered then
					Hovered = Part
					Highlight.Adornee = Part
					Highlight.Parent = Part and Library.HudGui or nil
				end
			end)
			Click = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Finish(Hovered)
				elseif Input.KeyCode == Enum.KeyCode.Escape then
					Finish(nil)
				end
			end)
		end

		function PartPickerClass:Set(Part, Silent)
			self.Value = Part
			self.ValueLabel.Text = Part and Part:GetFullName():gsub("^Workspace%.", "") or "None"
			if not Silent then self:_Fire(Part) end
		end
	end

	do
		function Library:_Index(Entry)
			table.insert(Library.SearchIndex, Entry)
		end

		function Window:_BuildSearch()
			local Canvas = self.Canvas
			local Dim = Create("TextButton", { Name = "SearchDim", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, Visible = false, ZIndex = 40, Parent = Canvas })
			local Modal = Create("CanvasGroup", {
				Name = "Search",
				Active = true,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 61),
				Size = UDim2.fromOffset(421, 340),
				Theme = { BackgroundColor3 = "Popup" },
				GroupTransparency = 1,
				Visible = false,
				ZIndex = 41,
				Parent = Canvas,
			})
			Corner(Modal, 8)
			Stroke(Modal, "Outline")
			local Title = Create("TextLabel", { Position = UDim2.fromOffset(18, 13), Size = UDim2.new(1, -36, 0, 24), Text = "Search", TextSize = 17, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Modal })
			local InputFrame = Create("Frame", { Position = UDim2.fromOffset(17, 52), Size = UDim2.new(1, -34, 0, 36), Theme = { BackgroundColor3 = "Tab" }, Parent = Modal })
			Corner(InputFrame, 8)
			Stroke(InputFrame, "Outline")
			local Icon = Create("ImageLabel", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0), Size = UDim2.fromOffset(14, 14), Theme = { ImageColor3 = "Inactive Text" }, Parent = InputFrame })
			SetIcon(Icon, "Search")
			local Box = Create("TextBox", {
				Position = UDim2.fromOffset(34, 0),
				Size = UDim2.new(1, -44, 1, 0),
				PlaceholderText = "Type to search...",
				Text = "",
				ClearTextOnFocus = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				Theme = { TextColor3 = "Text", PlaceholderColor3 = "Inactive Text" },
				Parent = InputFrame,
			})
			local Results = Create("ScrollingFrame", {
				Position = UDim2.fromOffset(17, 100),
				Size = UDim2.new(1, -30, 1, -110),
				ScrollBarThickness = 2,
				Theme = { ScrollBarImageColor3 = "Accent" },
				Parent = Modal,
			})
			ListLayout(Results, 6)
			Padding(Results, 0, 6, 0, 6)

			self.SearchParts = { Dim = Dim, Modal = Modal, Title = Title, Box = Box, Results = Results }

			local function Render(Query)
				for _, Child in Results:GetChildren() do
					if Child:IsA("GuiObject") then Child:Destroy() end
				end
				Library:SetText(Title, Query ~= "" and Query or "Search")
				if Query ~= "" then
					self.SearchText.Text = Query
					ThemeTween(self.SearchText, "TextColor3", "Text", 0.1)
				else
					self.SearchText.Text = "Search..."
					ThemeTween(self.SearchText, "TextColor3", "Inactive Text", 0.1)
				end
				if Query == "" then return end
				local Lower = Query:lower()
				local Matches = {}
				for _, Entry in Library.SearchIndex do
					if Entry.Tab and Entry.Tab.Window == self then
						local Title_ = tostring(Entry.Title or ""):lower()
						local Start = Title_:find(Lower, 1, true)
						if Start then table.insert(Matches, { Entry = Entry, Score = Start + (Entry.Type == "Section" and -0.5 or 0) }) end
					end
				end
				table.sort(Matches, function(A, B) return A.Score < B.Score end)
				for Index = 1, math.min(#Matches, 40) do
					local Entry = Matches[Index].Entry
					local Row = Create("CanvasGroup", { Size = UDim2.new(1, 0, 0, 42), Theme = { BackgroundColor3 = "Tab" }, GroupTransparency = 1, LayoutOrder = Index, Parent = Results })
					Corner(Row, 6)
					Stroke(Row, "Outline")
					local Bar = Create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 6, 0.5, 0), Size = UDim2.fromOffset(3, 27), Theme = { BackgroundColor3 = "Accent" }, Parent = Row })
					Corner(Bar, 1)
					Create("TextLabel", { Position = UDim2.fromOffset(17, 6), Size = UDim2.new(1, -24, 0, 16), Text = Entry.Title, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Row })
					Create("TextLabel", { Position = UDim2.fromOffset(17, 21), Size = UDim2.new(1, -24, 0, 14), Text = (Entry.Path or "") .. "  ·  " .. (Entry.Type or ""), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Inactive Text" }, Parent = Row })
					local Click = Create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 3, Parent = Row })
					Connect(Click.MouseEnter, function() ThemeTween(Row, "BackgroundColor3", "Hovered Element", 0.15) end)
					Connect(Click.MouseLeave, function() ThemeTween(Row, "BackgroundColor3", "Tab", 0.15) end)
					Connect(Click.MouseButton1Click, function() self:_GoTo(Entry) end)
					task.delay((Index - 1) * 0.03, function()
						if Row.Parent then Tween(Row, { GroupTransparency = 0 }, 0.25) end
					end)
				end
			end
			Connect(Box:GetPropertyChangedSignal("Text"), function() Render(Box.Text) end)
			Connect(Dim.MouseButton1Click, function() self:CloseSearch() end)
			Connect(UserInputService.InputBegan, function(Input)
				if Input.KeyCode == Enum.KeyCode.Escape and self.SearchOpen then self:CloseSearch() end
			end)
		end

		function Window:OpenSearch()
			local Parts = self.SearchParts
			if self.SearchOpen then return end
			self.SearchOpen = true
			Library:CloseAllPopups()
			Parts.Dim.Visible = true
			Parts.Modal.Visible = true
			Tween(Parts.Dim, { BackgroundTransparency = 0.45 }, 0.2)
			Parts.Modal.Position = UDim2.new(0.5, 0, 0, 69)
			Tween(Parts.Modal, { GroupTransparency = 0, Position = UDim2.new(0.5, 0, 0, 61) }, 0.25)
			task.defer(function() Parts.Box:CaptureFocus() end)
		end

		function Window:CloseSearch()
			local Parts = self.SearchParts
			if not Parts or not self.SearchOpen then return end
			self.SearchOpen = false
			Parts.Box:ReleaseFocus()
			Tween(Parts.Dim, { BackgroundTransparency = 1 }, 0.2)
			local Fade = Tween(Parts.Modal, { GroupTransparency = 1 }, 0.2)
			Fade.Completed:Connect(function()
				if self.SearchOpen then return end
				Parts.Dim.Visible = false
				Parts.Modal.Visible = false
				Parts.Box.Text = ""
			end)
		end

		function Window:_GoTo(Entry)
			self:CloseSearch()
			if Entry.Tab then Entry.Tab:Select() end
			local Target = Entry.Target
			if not Target then return end
			task.delay(0.05, function()
				local Column = Target:FindFirstAncestorWhichIsA("ScrollingFrame")
				if Column and Column.Parent == Entry.Tab.Page then
					local Offset = Target.AbsolutePosition.Y - Column.AbsolutePosition.Y + Column.CanvasPosition.Y - 30
					local MaxY = math.max(0, Column.AbsoluteCanvasSize.Y - Column.AbsoluteWindowSize.Y)
					Tween(Column, { CanvasPosition = Vector2.new(0, Clamp(Offset, 0, MaxY)) }, 0.35)
				end
				task.wait(0.3)
				local Content = Target:IsDescendantOf(self.Content) and self.Content or Target:FindFirstAncestorWhichIsA("LayerCollector")
				if not Content then return end
				local Flash = Create("Frame", { Theme = { BackgroundColor3 = "Accent" }, BackgroundTransparency = 0.82, ZIndex = 50, Parent = Content })
				Corner(Flash, 6)
				local function Follow()
					local Position = Target.AbsolutePosition - Content.AbsolutePosition
					Flash.Position = UDim2.fromOffset(Position.X - 4, Position.Y - 3)
					Flash.Size = UDim2.fromOffset(Target.AbsoluteSize.X + 8, Target.AbsoluteSize.Y + 6)
				end
				Follow()
				local Following = RunService.RenderStepped:Connect(Follow)
				Tween(Flash, { BackgroundTransparency = 1 }, 1.2).Completed:Connect(function()
					Following:Disconnect()
					Flash:Destroy()
				end)
			end)
		end
	end

	local function HudPanel(Properties)
		Properties.Theme = Properties.Theme or { BackgroundColor3 = "Popup" }
		local Frame = Create("Frame", Properties)
		Corner(Frame, 6)
		Stroke(Frame, "Outline")
		return Frame
	end

	do
		local NotifyHolder = Create("Frame", { Name = "Notifications", Position = UDim2.fromOffset(15, 15), Size = UDim2.new(0, 400, 1, -30), BackgroundTransparency = 1, Parent = Library.HudGui })
		ListLayout(NotifyHolder, 6)
		local NotifyCounter = 0
		local NotifyColors = {
			Success = Rgb(76, 214, 128),
			Info = nil,
			Warning = Rgb(242, 188, 72),
			Error = Rgb(240, 84, 84),
		}
		local NotifyIcons = { Success = "Check", Info = "Info", Warning = "Warning", Error = "Error" }

		function Library:Notify(Config, Duration, Kind)
			if type(Config) ~= "table" then Config = { Text = tostring(Config), Duration = Duration, Type = Kind } end
			Kind = Config.Type or Config.Kind or "Success"
			Duration = Config.Duration or Config.Lifetime or Config.Time or 4
			NotifyCounter += 1

			local Holder = Create("Frame", { Size = UDim2.fromOffset(0, 30), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, LayoutOrder = -NotifyCounter, Parent = NotifyHolder })
			local Panel = Create("CanvasGroup", { Position = UDim2.fromOffset(-20, 0), Size = UDim2.fromOffset(0, 30), AutomaticSize = Enum.AutomaticSize.X, Theme = { BackgroundColor3 = "Popup" }, GroupTransparency = 1, Parent = Holder })
			Corner(Panel, 6)
			Stroke(Panel, "Outline")
			local Color = NotifyColors[Kind]
			local Bar = Create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 1, 0.5, 0), Size = UDim2.fromOffset(2, 15), BackgroundColor3 = Color or Theme.Accent, Parent = Panel })
			local Icon = Create("ImageLabel", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0), Size = UDim2.fromOffset(10, 10), ImageColor3 = Color or Theme.Accent, Parent = Panel })
			if not Color then
				Library:Theme(Bar, "BackgroundColor3", "Accent")
				Library:Theme(Icon, "ImageColor3", "Accent")
			end
			SetIcon(Icon, Config.Icon or NotifyIcons[Kind] or "Check")
			local Label = Create("TextLabel", { Position = UDim2.fromOffset(31, 0), Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = Config.Text or Config.Title or "", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Panel })
			Padding(Label, 0, 0, 0, 12)

			Tween(Panel, { Position = UDim2.fromOffset(0, 0), GroupTransparency = 0 }, 0.3)
			local Entry = { Holder = Holder }
			table.insert(Library.Notifications, Entry)
			task.delay(Duration, function()
				if not Holder.Parent then return end
				Tween(Panel, { Position = UDim2.fromOffset(-20, 0), GroupTransparency = 1 }, 0.3).Completed:Wait()
				Tween(Holder, { Size = UDim2.fromOffset(0, 0) }, 0.15).Completed:Wait()
				Holder:Destroy()
				local Index = table.find(Library.Notifications, Entry)
				if Index then table.remove(Library.Notifications, Index) end
			end)
			return Entry
		end
	end

	local HudDraggable; do
		function HudDraggable(Handle, Target, Key)
			Layout.TrackPosition(Key, Target)
			local Dragging, Start, From
			Connect(Handle.InputBegan, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging, Start, From = true, MousePosition(), Target.Position
				end
			end)
			Connect(UserInputService.InputChanged, function(Input)
				if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
					local Delta = MousePosition() - Start
					Target.Position = UDim2.new(From.X.Scale, From.X.Offset + Delta.X, From.Y.Scale, From.Y.Offset + Delta.Y)
				end
			end)
			Connect(UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if Dragging then Library:SaveLayout() end
					Dragging = false
				end
			end)
		end

		local Hotkeys = {
			Visible = true,
			Mode = "Active",
			ShowMode = false,
			Rows = {},
		}
		Library.Hotkeys = Hotkeys

		local HotkeyHolder = Create("Frame", { Name = "Hotkeys", Position = UDim2.new(0, 15, 0.5, -12), Size = UDim2.fromOffset(200, 25), BackgroundTransparency = 1, Parent = Library.HudGui })
		local HotkeyHeader = HudPanel({ Size = UDim2.fromOffset(0, 25), AutomaticSize = Enum.AutomaticSize.X, Active = true, Parent = HotkeyHolder })
		do
			local Glyph = Create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0), Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, Parent = HotkeyHeader })
			local Ball = Create("Frame", { Position = UDim2.fromOffset(0, 6), Size = UDim2.fromOffset(8, 8), Theme = { BackgroundColor3 = "Accent" }, Parent = Glyph })
			Corner(Ball, 4)
			local Stick = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(8.5, 5.5), Size = UDim2.fromOffset(8, 1.6), Rotation = -45, Theme = { BackgroundColor3 = "Accent" }, Parent = Glyph })
			Corner(Stick, 1)
			local Tip = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(11.5, 2.5), Size = UDim2.fromOffset(5, 3), Rotation = -45, Theme = { BackgroundColor3 = "Accent" }, Parent = Glyph })
			Corner(Tip, 2)
			Hotkeys.Title = Create("TextLabel", { Weight = "SemiBold", Position = UDim2.fromOffset(31, 0), Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = "Hotkeys", TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = HotkeyHeader })
			Padding(Hotkeys.Title, 0, 0, 0, 10)
		end
		HudDraggable(HotkeyHeader, HotkeyHolder, "Hotkeys")
		local HotkeyList = Create("Frame", { Position = UDim2.fromOffset(0, 30), Size = UDim2.fromOffset(260, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = HotkeyHolder })
		ListLayout(HotkeyList, 0)
		Hotkeys.Holder, Hotkeys.List = HotkeyHolder, HotkeyList
		Library.HotkeysVisible = true

		function Library:SetHotkeysVisible(Visible)
			Library.HotkeysVisible = Visible
			Hotkeys.Visible = Visible
			HotkeyHolder.Visible = Visible
		end

		function Hotkeys:SetMode(Mode)
			self.Mode = Mode == "All" and "All" or "Active"
			Library:_RefreshHotkeys()
		end

		function Hotkeys:SetShowMode(Show)
			self.ShowMode = Show
			Library:_RefreshHotkeys()
		end

		function Hotkeys:SetTitle(Text)
			Library:SetText(self.Title, Text)
		end

		local function KeybindDisplayName(Keybind)
			local Name = Keybind.Name
			if not Name and Keybind.Toggle then
				local Toggle_ = Keybind.Toggle
				local Section_ = Toggle_.Container and Toggle_.Container.Section
				Name = (Toggle_.Text == "Enabled" and Section_ and Section_.Title) or Toggle_.Text
			end
			return Name or Keybind.Text
		end

		local ROW_HEIGHT, ROW_GAP, ROW_SLIDE = 23, 5, 10

		local function HotkeyRow(Keybind)
			local Row = Hotkeys.Rows[Keybind]
			if Row then return Row end
			local Holder = Create("Frame", { Size = UDim2.fromOffset(0, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Visible = false, Parent = HotkeyList })
			local Panel = Create("Frame", { Position = UDim2.fromOffset(-ROW_SLIDE, 0), Size = UDim2.fromOffset(0, ROW_HEIGHT), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Theme = { BackgroundColor3 = "Popup" }, Parent = Holder })
			Corner(Panel, 6)
			local Outline = Stroke(Panel, "Outline")
			Outline.Transparency = 1
			local Label = Create("TextLabel", { Weight = "SemiBold", Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, Theme = { TextColor3 = "Text" }, Parent = Panel })
			Padding(Label, 0, 0, 9, 9)
			Row = { Holder = Holder, Panel = Panel, Outline = Outline, Label = Label, Shown = false }
			Hotkeys.Rows[Keybind] = Row
			return Row
		end

		local function ShowRow(Row, Show)
			if Row.Shown == Show then return end
			Row.Shown = Show
			Row.Token = (Row.Token or 0) + 1
			local Token = Row.Token
			local Alpha = Show and 0 or 1
			local Time, Style, Direction = Show and 0.22 or 0.16, Enum.EasingStyle.Quint, Show and Enum.EasingDirection.Out or Enum.EasingDirection.In
			if Show then
				Row.Holder.Visible = true
				Row.Panel.Position = UDim2.fromOffset(-ROW_SLIDE, 0)
			end
			Tween(Row.Holder, { Size = UDim2.fromOffset(0, Show and ROW_HEIGHT + ROW_GAP or 0) }, Show and 0.2 or 0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			Tween(Row.Panel, { Position = UDim2.fromOffset(Show and 0 or -ROW_SLIDE, 0), BackgroundTransparency = Alpha }, Time, Style, Direction)
			Tween(Row.Outline, { Transparency = Alpha }, Time, Style, Direction)
			Tween(Row.Label, { TextTransparency = Alpha }, Time, Style, Direction).Completed:Connect(function()
				if not Show and Row.Token == Token then Row.Holder.Visible = false end
			end)
		end

		function Library:_RefreshHotkeys()
			for Index, Keybind in Library.Keybinds do
				local Listed = Keybind.Value.Key and not Keybind.NoList and not Keybind.OnPress
				local Active = Listed and Keybind:IsActive()
				local Show = Listed and (Active or Hotkeys.Mode == "All")
				if Show or Hotkeys.Rows[Keybind] then
					local Row = HotkeyRow(Keybind)
					Row.Holder.LayoutOrder = Index
					if Listed then
						local Key = Keybind.Value.Key
						local KeyText = Key.EnumType == Enum.KeyCode and Key.Name or Key.Name:gsub("MouseButton", "MB")
						local Text = KeybindDisplayName(Keybind) .. " - " .. KeyText
						if Hotkeys.ShowMode then Text ..= " [" .. Keybind.Value.Mode .. "]" end
						Library:SetText(Row.Label, Text)
					end
					ThemeTween(Row.Label, "TextColor3", Active and "Text" or "Inactive Text", 0.15)
					ShowRow(Row, Show)
				end
			end
		end
	end

	local GetPing; do
		local WatermarkHolder = Create("Frame", { Name = "Watermark", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -20), Size = UDim2.fromOffset(0, 27), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = Library.HudGui })
		local WatermarkFrame = HudPanel({ Size = UDim2.fromOffset(0, 27), AutomaticSize = Enum.AutomaticSize.X, Active = true, Parent = WatermarkHolder })
		ListLayout(WatermarkFrame, 7, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)
		Padding(WatermarkFrame, 0, 0, 10, 10)
		HudDraggable(WatermarkFrame, WatermarkHolder, "Watermark")
		Library.WatermarkFrame = WatermarkFrame

		local GameName = "Roblox"
		task.spawn(function()
			pcall(function() GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
		end)

		local FrameRate = 60
		do
			local Frames, Last = 0, os.clock()
			Connect(RunService.RenderStepped, function()
				Frames += 1
				local Now = os.clock()
				if Now - Last >= 0.5 then
					FrameRate = math.floor(Frames / (Now - Last) + 0.5)
					Frames, Last = 0, Now
				end
			end)
		end

		function GetPing()
			local Ok, Value = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
			if Ok and Value then return math.floor(Value + 0.5) end
			Ok, Value = pcall(function() return LocalPlayer:GetNetworkPing() * 1000 end)
			return Ok and math.floor(Value + 0.5) or 0
		end

		local Watermark = {
			Title = "Swift",
			Items = { "GameName", "PlayerName" },
			Providers = {
				FPS = function() return FrameRate .. " fps" end,
				Ping = function() return GetPing() .. " ms" end,
				GameName = function() return GameName end,
				PlayerName = { Icon = "User", IconSize = 12, Text = function() return Library.AnonymousMode and Library.AnonymousName or LocalPlayer and (LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")") or "Player" end },
				Time = function() return os.date("%H:%M:%S") end,
				Date = function() return os.date("%d/%m/%Y") end,
			},
			Labels = {},
		}
		Library.Watermark = Watermark

		function Watermark:_Render()
			for _, Child in WatermarkFrame:GetChildren() do
				if Child:IsA("GuiObject") then Child:Destroy() end
			end
			self.Labels = {}
			local Segments = { { Logo = true, Text = self.Title } }
			for _, Item in self.Items do
				local Provider = type(Item) == "string" and self.Providers[Item] or Item
				if Provider and not (type(Item) == "table" and Item.Visible == false) then table.insert(Segments, Provider) end
			end
			local Order = 0
			for Index, Segment in Segments do
				if type(Segment) == "function" or type(Segment) == "string" then Segment = { Text = Segment } end
				if Index > 1 then
					Order += 1
					Create("Frame", { Size = UDim2.fromOffset(1, 14), Theme = { BackgroundColor3 = "Outline" }, LayoutOrder = Order, Parent = WatermarkFrame })
				end
				Order += 1
				local Group = Create("Frame", { Size = UDim2.fromOffset(0, 27), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, LayoutOrder = Order, Parent = WatermarkFrame })
				ListLayout(Group, 8, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
				if Segment.Logo then
					Library:Logo(Group, 15)
				elseif Segment.Icon then
					local Image = Create("ImageLabel", { Size = UDim2.fromOffset(Segment.IconSize or 14, Segment.IconSize or 14), Theme = { ImageColor3 = Segment.IconColor or "Text" }, Parent = Group })
					SetIcon(Image, Segment.Icon)
				end
				local Label = Create("TextLabel", { Weight = "SemiBold", Size = UDim2.fromOffset(0, 27), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 2, Theme = { TextColor3 = "Text" }, Parent = Group })
				local Text = Segment.Text
				if type(Text) == "function" then
					table.insert(self.Labels, { Label = Label, Get = Text })
					local Ok, Value = pcall(Text)
					Library:SetText(Label, Ok and Value or "")
				else
					Library:SetText(Label, Text or "")
				end
			end
		end

		function Watermark:SetItems(Items)
			self.Items = Items or {}
			self:_Render()
		end

		function Watermark:SetTitle(Title)
			self.Title = Title
			self:_Render()
		end

		function Watermark:AddProvider(Name, Provider)
			self.Providers[Name] = Provider
		end

		task.spawn(function()
			while not Library.Unloaded do
				for _, Entry in Watermark.Labels do
					if Entry.Label.Parent then
						local Ok, Value = pcall(Entry.Get)
						if Ok then Library:SetText(Entry.Label, Value) end
					end
				end
				task.wait(0.5)
			end
		end)
		Watermark:_Render()

		function Library:SetWatermark(Segments)
			local Items = {}
			for Index, Segment in Segments do
				if Index == 1 and type(Segment) == "string" then
					Watermark.Title = Segment
				elseif Index == 1 and type(Segment) == "table" and Segment.Icon == "Logo" then
					Watermark.Title = Segment.Text or Watermark.Title
				else
					table.insert(Items, Segment)
				end
			end
			Watermark:SetItems(Items)
		end

		function Library:SetWatermarkVisible(Visible)
			WatermarkHolder.Visible = Visible
		end
	end

	do
		Library.BlurEnabled = false
		function Library:_UpdateBlur()
			local Open = false
			for _, Window_ in Library.Windows do
				if Window_.Open then Open = true end
			end
			local Wanted = Library.BlurEnabled and Open and 14 or 0
			if not Library.Blur then
				if Wanted == 0 then return end
				Library.Blur = Instance.new("BlurEffect")
				Library.Blur.Name = "SwiftBlur"
				Library.Blur.Size = 0
				Library.Blur.Parent = Workspace.CurrentCamera or Lighting
			end
			Tween(Library.Blur, { Size = Wanted }, 0.25)
		end

		function Library:SetBlur(Enabled)
			Library.BlurEnabled = Enabled
			Library:_UpdateBlur()
		end
	end

	do
		local CONFIG_FOLDER = Library.Folder .. "/configs"

		function Library:GetConfig()
			local Data = {}
			for Flag, Element in Library.Elements do
				if type(Flag) == "string" and Flag:sub(1, 2) ~= "__" and Element.Serialize and not Element.NoSave then
					local Ok, Value = pcall(Element.Serialize, Element)
					if Ok then Data[Flag] = Value end
				end
			end
			for _, Extra in Library.ConfigExtras or {} do
				local Ok, Key, Value = pcall(Extra.Save)
				if Ok and Key then Data[Key] = Value end
			end
			return HttpService:JSONEncode(Data)
		end

		function Library:LoadConfigString(Json)
			local Ok, Data = pcall(HttpService.JSONDecode, HttpService, Json)
			if not Ok or type(Data) ~= "table" then return false end
			if Data.__ThemeName and Themes[Data.__ThemeName] then Library:SetTheme(Data.__ThemeName) end
			for Flag, Value in Data do
				local Element = Library.Elements[Flag]
				if Element and Element.Deserialize then
					pcall(Element.Deserialize, Element, Value)
				end
			end
			for _, Extra in Library.ConfigExtras or {} do
				pcall(Extra.Load, Data)
			end
			return true
		end

		function Library:AddConfigExtra(Save, Load)
			Library.ConfigExtras = Library.ConfigExtras or {}
			table.insert(Library.ConfigExtras, { Save = Save, Load = Load })
		end
		Library:AddConfigExtra(function() return "__Layout", Library:GetLayout() end, function(Data)
			if Data.__Layout and Library:LoadLayout(Data.__Layout) then Library:SaveLayout() end
		end)

		function Library:ListConfigs()
			local Out = {}
			for _, File in FS.List(CONFIG_FOLDER) do
				local Name = File:match("^(.*)%.json$")
				if Name then table.insert(Out, Name) end
			end
			return Out
		end

		function Library:SaveConfig(Name)
			if not Name or Name == "" then return false end
			FS.Write(CONFIG_FOLDER .. "/" .. Name .. ".json", Library:GetConfig())
			return true
		end

		function Library:LoadConfig(Name)
			local Content = Name and FS.Read(CONFIG_FOLDER .. "/" .. Name .. ".json")
			if not Content then return false end
			return Library:LoadConfigString(Content)
		end

		function Library:DeleteConfig(Name)
			if not Name then return false end
			FS.Delete(CONFIG_FOLDER .. "/" .. Name .. ".json")
			return true
		end

		function Library:SetAutoload(Name)
			if Name then FS.Write(Library.Folder .. "/autoload.txt", Name) else FS.Delete(Library.Folder .. "/autoload.txt") end
		end

		function Library:GetAutoload()
			return FS.Read(Library.Folder .. "/autoload.txt")
		end
	end

	do
		function Window:AddSettingsTab(Config)
			Config = Config or {}
			local Settings = self:AddTab({ Title = Config.Title or "Settings", Icon = Config.Icon or "Gear", Category = Config.Category })
			local Window_ = self

			local Profiles = Settings:AddSection({ Title = "Profiles", Icon = "Cube", Side = 1 })
			local NameBox
			local ConfigList = Profiles:AddList({
				Text = "Configs",
				Height = 178,
				Flag = "__ConfigList",
				Options = Library:ListConfigs(),
				Callback = function(Name) if NameBox and Name then NameBox:Set(Name, true) end end,
			})
			NameBox = Profiles:AddInput({ Placeholder = "Config name", Flag = "__ConfigName" })
			local function Refresh() ConfigList:SetOptions(Library:ListConfigs()) end
			local function Selected()
				local Name = NameBox.Value ~= "" and NameBox.Value or ConfigList.Value
				return Name
			end
			Profiles:AddButton({ Text = "Create", Callback = function()
				local Name = NameBox.Value
				if Name == "" then return Library:Notify({ Text = "Enter a config name first.", Type = "Error" }) end
				Library:SaveConfig(Name)
				Refresh()
				ConfigList:Set(Name, true)
				Library:Notify('Created config "' .. Name .. '".')
			end })
			Profiles:AddButton({ Text = "Load", Callback = function()
				local Name = Selected()
				if Name and Library:LoadConfig(Name) then
					Library:Notify('Loaded config "' .. Name .. '".')
				else
					Library:Notify({ Text = "Select a config to load.", Type = "Error" })
				end
			end })
			Profiles:AddButton({ Text = "Delete", Callback = function()
				local Name = Selected()
				if not Name or Name == "" then return end
				Library:DeleteConfig(Name)
				Refresh()
				NameBox:Set("", true)
				Library:Notify('Deleted config "' .. Name .. '".')
			end })
			Profiles:AddButton({ Text = "Overwrite", Callback = function()
				local Name = Selected()
				if not Name or Name == "" then return end
				Library:SaveConfig(Name)
				Refresh()
				Library:Notify('Overwrote config "' .. Name .. '".')
			end })

			local Autoload = Settings:AddSection({ Title = "Autoload", Icon = "Cube", Side = 1 })
			Autoload:AddButton({ Text = "Set selected as autoload", Callback = function()
				local Name = Selected()
				if not Name or Name == "" then return Library:Notify({ Text = "Select a config first.", Type = "Error" }) end
				Library:SetAutoload(Name)
				Library:Notify('Set "' .. Name .. '" as autoload.')
			end })
			Autoload:AddButton({ Text = "Clear autoload", Callback = function()
				Library:SetAutoload(nil)
				Library:Notify("Cleared autoload.")
			end })

			local Theming = Settings:AddSection({ Title = "Theming", Icon = "Cube", Side = 2 })
			Theming:AddDropdown({ Text = "Theme", Options = ThemeOrder, Default = Library.ThemeName, Flag = "__ThemeName", Callback = function(Name)
				if Name == Library.ThemeName and not Window_._ThemeReady then Window_._ThemeReady = true return end
				Window_._ThemeReady = true
				Library:SetTheme(Name)
				Library:Notify('Applied "' .. Name .. '" theme.')
			end })
			Library.Elements.__ThemeName.NoSave = false
			Theming:AddDropdown({ Text = "Casing", Options = CasingOrder, Default = Library.Casing, Flag = "Casing", Callback = function(Mode)
				if Mode == Library.Casing then return end
				Library:SetCasing(Mode)
				Library:Notify('Set casing to "' .. Mode .. '".')
			end })
			Theming:AddDropdown({ Text = "Font", Options = Fonts.Order, Default = Library.Font, Flag = "Font", Callback = function(Name)
				if Name == Library.Font then return end
				Library:SetFont(Name)
				Library:Notify('Set font to "' .. Name .. '".')
			end })
			Theming:AddSeparator()
			for _, Key in ThemeKeys do
				Theming:AddColorPicker({ Text = Key, Default = Theme[Key], Flag = "Theme_" .. Key, Callback = function(Color)
					if Library.ApplyingTheme then return end
					Library:SetThemeColor(Key, Color)
				end })
			end

			local Menu = Settings:AddSection({ Title = "Menu", Icon = "Cube", Side = 2 })
			Menu:AddKeybind({ Text = "Menu Keybind", Default = Config.MenuKeybind or Library.MenuKeybind, Flag = "MenuKeybind", NoList = true, OnPress = function() Window_:Toggle() end })
			local Anonymous = Menu:AddToggle({ Text = "Anonymous Mode", Flag = "AnonymousMode", Default = false, Callback = function(Value) Library:SetAnonymous(Value) end })
			local AnonymousSettings = Anonymous:Settings({ Title = "Anonymous Mode" })
			AnonymousSettings:AddInput({ Text = "Custom Name", Flag = "AnonymousName", Default = "...", Finished = true, Callback = function(Value) Library:SetAnonymousName(Value) end })
			AnonymousSettings:AddToggle({ Text = "Hide Name In Game", Flag = "AnonymousGame", Default = false, Callback = function(Value) Library:SetAnonymousGame(Value) end })
			AnonymousSettings:AddInput({ Text = "Avatar User ID", Flag = "AnonymousAvatar", Default = "", Finished = true, Callback = function(Value) Library:SetAnonymousAvatar(Value) end })
			local WatermarkToggle = Menu:AddToggle({ Text = "Watermark", Default = Config.Watermark ~= false, Flag = "Watermark", Callback = function(Value) Library:SetWatermarkVisible(Value) end })
			local WatermarkSettings = WatermarkToggle:Settings({ Title = "Watermark Settings" })
			WatermarkSettings:AddInput({ Text = "Name", Default = Library.Watermark.Title, Placeholder = "Swift", Flag = "WatermarkName", Callback = function(Text)
				Library.Watermark:SetTitle(Text ~= "" and Text or "Swift")
			end })
			WatermarkSettings:AddMultiDropdown({
				Text = "Items",
				Options = { "FPS", "Ping", { Name = "Game name", Value = "GameName" }, { Name = "Player name", Value = "PlayerName" }, "Time", "Date" },
				Default = Library.Watermark.Items,
				Flag = "WatermarkItems",
				Callback = function(Values)
					local Selected, Present, Items = {}, {}, {}
					for _, Value in Values do Selected[Value] = true end
					for _, Item in Library.Watermark.Items do
						if type(Item) == "string" and Library.Watermark.Providers[Item] then
							if Selected[Item] then table.insert(Items, Item) end
							Present[Item] = true
						else
							table.insert(Items, Item)
						end
					end
					for _, Value in Values do
						if not Present[Value] then table.insert(Items, Value) end
					end
					Library.Watermark:SetItems(Items)
				end,
			})
			local HotkeysToggle = Menu:AddToggle({ Text = "Keybind List", Default = Config.KeybindList ~= false, Flag = "KeybindList", Callback = function(Value) Library:SetHotkeysVisible(Value) end })
			local HotkeySettings = HotkeysToggle:Settings({ Title = "Keybind List Settings" })
			HotkeySettings:AddDropdown({ Text = "Show", Options = { { Name = "Active bindings", Value = "Active" }, { Name = "All bindings", Value = "All" } }, Default = "Active", Flag = "KeybindListMode", Callback = function(Mode)
				Library.Hotkeys:SetMode(Mode)
			end })
			HotkeySettings:AddToggle({ Text = "Show Mode", Flag = "KeybindListShowMode", Callback = function(Value) Library.Hotkeys:SetShowMode(Value) end })
			HotkeySettings:AddInput({ Text = "Title", Default = "Hotkeys", Placeholder = "Hotkeys", Flag = "KeybindListTitle", Callback = function(Text)
				Library.Hotkeys:SetTitle(Text ~= "" and Text or "Hotkeys")
			end })
			Menu:AddToggle({ Text = "Menu Blur", Default = Config.Blur == true, Flag = "MenuBlur", Callback = function(Value) Library:SetBlur(Value) end })
			Menu:AddSeparator()
			Menu:AddButton({ Text = "Unload", Confirm = true, Callback = function() Library:Unload() end })

			Library.Elements.__ThemeName.Serialize = nil
			Library:AddConfigExtra(function() return "__ThemeName", Library.ThemeName end, function() end)

			task.defer(function()
				local Name = Library:GetAutoload()
				if Name and Library:LoadConfig(Name) then
					Library:Notify('Autoloaded config "' .. Name .. '".')
				end
			end)
			self.SettingsTab = Settings
			return Settings
		end
		Window.InitSettings = Window.AddSettingsTab
		Window.InitConfigs = Window.AddSettingsTab
	end

	do
		function Library:Unload()
			if Library.Unloaded then return end
			Library:SaveLayout()
			Library.Unloaded = true
			Privacy:Stop()
			for _, Callback in Library.UnloadCallbacks or {} do SafeCall(Callback) end
			for _, Connection in Library.Connections do
				pcall(function() Connection:Disconnect() end)
			end
			table.clear(Library.AnimatedPickers)
			if Library.Blur then Library.Blur:Destroy() end
			for _, Gui in { Library.HudGui, Library.MenuGui, Library.OverlayGui } do
				pcall(function() Gui:Destroy() end)
			end
			if Env.SwiftLibrary == Library then Env.SwiftLibrary = nil end
		end

		function Library:OnUnload(Callback)
			Library.UnloadCallbacks = Library.UnloadCallbacks or {}
			table.insert(Library.UnloadCallbacks, Callback)
		end
	end

	function Tab:GetCustomPage()
		if self.Custom then return self.Custom end
		for _, Column in self.Columns do Column.Visible = false end
		self.Custom = Create("Frame", { Name = "Custom", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true, Parent = self.Page })
		return self.Custom
	end

	local function Panel(Parent, Properties)
		Properties.Theme = Properties.Theme or { BackgroundColor3 = "Tab" }
		Properties.Parent = Parent
		local Frame = Create("Frame", Properties)
		Corner(Frame, 6)
		Stroke(Frame, "Outline")
		return Frame
	end

	local function SmallButton(Parent, Text, Properties)
		Properties = Properties or {}
		Properties.Theme = Properties.Theme or { BackgroundColor3 = "Element" }
		Properties.Parent = Parent
		local Button = Create("TextButton", Properties)
		Corner(Button, 5)
		Shade(Button)
		Stroke(Button, "Outline")
		local Label = Create("TextLabel", { Size = UDim2.fromScale(1, 1), Text = Text, TextSize = 12, Theme = { TextColor3 = "Text" }, Parent = Button })
		Connect(Button.MouseEnter, function() ThemeTween(Button, "BackgroundColor3", "Hovered Element", 0.12) end)
		Connect(Button.MouseLeave, function() ThemeTween(Button, "BackgroundColor3", "Element", 0.12) end)
		return Button, Label
	end

	local PingColors = { Good = Rgb(110, 210, 130), Okay = Rgb(230, 190, 90), Bad = Rgb(230, 95, 95) }
	local function PingColor(Ping)
		return Ping < 90 and PingColors.Good or Ping < 170 and PingColors.Okay or PingColors.Bad
	end

	local function SegmentSwitch(Parent, Options, Callback)
		local Switch = Create("Frame", { Theme = { BackgroundColor3 = "Element" }, Parent = Parent })
		Corner(Switch, 5)
		Shade(Switch)
		Stroke(Switch, "Outline")
		local Pill = Create("Frame", { Size = UDim2.fromScale(1 / #Options, 1), Theme = { BackgroundColor3 = "ToggleFill" }, Parent = Switch })
		Corner(Pill, 5)
		Shade(Pill)
		local Labels = {}
		local Self = { Frame = Switch }
		function Self.Set(_, Value, Instant)
			for Index, Option in Options do
				if Option.Value == Value then
					Tween(Pill, { Position = UDim2.fromScale((Index - 1) / #Options, 0) }, Instant and 0 or 0.22)
					if Option.Color then
						Library:Unthemed(Pill, "BackgroundColor3")
						Tween(Pill, { BackgroundColor3 = Option.Color:Lerp(Theme.Element, 0.5) }, Instant and 0 or 0.22)
					else
						ThemeTween(Pill, "BackgroundColor3", "ToggleFill", Instant and 0 or 0.22)
					end
				end
				ThemeTween(Labels[Index], "TextColor3", Option.Value == Value and "Text" or "Inactive Text", Instant and 0 or 0.15)
			end
		end
		for Index, Option in Options do
			local Button = Create("TextButton", { Position = UDim2.fromScale((Index - 1) / #Options, 0), Size = UDim2.fromScale(1 / #Options, 1), BackgroundTransparency = 1, ZIndex = 2, Parent = Switch })
			Labels[Index] = Create("TextLabel", { Size = UDim2.fromScale(1, 1), Text = Option.Name, TextSize = 11, ZIndex = 2, Theme = { TextColor3 = "Inactive Text" }, Parent = Button })
			Connect(Button.MouseButton1Click, function() Callback(Option.Value) end)
		end
		return Self
	end

	local CopyText, Avatar; do
		local Playerlist = {}
		Playerlist.__index = Playerlist
		Library.Classes.Playerlist = Playerlist

		Library.PlayerStatuses = { "Neutral", "Friendly", "Enemy", "Priority" }
		Library.StatusColors = {
			Friendly = Rgb(96, 220, 120),
			Enemy = Rgb(240, 84, 84),
			Priority = Rgb(242, 188, 72),
		}
		local StatusOrder = { Client = -1, Priority = 1, Enemy = 2, Friendly = 3, Neutral = 4 }

		local function AccountAge(Player)
			local Days = Player.AccountAge
			if Days >= 365 then return string.format("%.1f years", Days / 365) end
			return Days .. " days"
		end

		function CopyText(Text, What)
			local Copy = Env.setclipboard or Env.toclipboard
			if typeof(Copy) == "function" then
				Copy(Text)
				Library:Notify("Copied " .. What .. ".")
			else
				Library:Notify({ Text = "Clipboard is not available here.", Type = "Warning" })
			end
		end

		function Avatar(Parent, Size, Properties)
			Properties = Properties or {}
			Properties.Size = UDim2.fromOffset(Size, Size)
			Properties.BackgroundTransparency = 0
			Properties.Theme = { BackgroundColor3 = "Element" }
			Properties.Parent = Parent
			local Image = Create("ImageLabel", Properties)
			Corner(Image, Size)
			local Ring = Create("UIStroke", { Thickness = Size > 30 and 2 or 1.5, Theme = { Color = "Outline" }, Parent = Image })
			return Image, Ring
		end

		local function PaintRing(Ring, Color, Time)
			if Color then
				Library:Unthemed(Ring, "Color")
				Tween(Ring, { Color = Color }, Time or 0.15)
			else
				ThemeTween(Ring, "Color", "Outline", Time or 0.15)
			end
		end

		function Window:AddPlayerlist(Config)
			Config = Config or {}
			local TabObject = Config.Tab or self:AddTab({ Title = Config.Title or "Playerlist", Icon = Config.Icon or "Users", Category = Config.Category })
			local Page = TabObject:GetCustomPage()
			local Self = setmetatable({ Tab = TabObject, Window = self, Rows = {}, Statuses = {}, Selected = nil, Callbacks = {}, Filter = "All", Query = "" }, Playerlist)
			Library.Playerlist = Self

			local Header = Create("Frame", { Position = UDim2.fromOffset(10, 10), Size = UDim2.new(1, -20, 0, 22), BackgroundTransparency = 1, Parent = Page })
			local TitleRow = Create("Frame", { Size = UDim2.new(1, -250, 1, 0), BackgroundTransparency = 1, Parent = Header })
			ListLayout(TitleRow, 8, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
			local HeaderIcon = Create("ImageLabel", { Size = UDim2.fromOffset(15, 15), LayoutOrder = 1, Theme = { ImageColor3 = "Inactive Text" }, Parent = TitleRow })
			SetIcon(HeaderIcon, Config.Icon or "Users")
			Create("TextLabel", { Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X, Text = Config.Title or "Players", LayoutOrder = 2, Theme = { TextColor3 = "Inactive Text" }, Parent = TitleRow })
			local Count = Create("TextLabel", { Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X, TextSize = 11, LayoutOrder = 3, Theme = { TextColor3 = "Inactive Text" }, Parent = TitleRow })
			local Filter = SegmentSwitch(Header, {
				{ Name = "All", Value = "All" },
				{ Name = "Friendly", Value = "Friendly", Color = Library.StatusColors.Friendly },
				{ Name = "Enemy", Value = "Enemy", Color = Library.StatusColors.Enemy },
				{ Name = "Priority", Value = "Priority", Color = Library.StatusColors.Priority },
			}, function(Value) Self:SetFilter(Value) end)
			Filter.Frame.AnchorPoint = Vector2.new(1, 0.5)
			Filter.Frame.Position = UDim2.new(1, 0, 0.5, 0)
			Filter.Frame.Size = UDim2.fromOffset(240, 22)

			local ListPanel = Panel(Page, { Position = UDim2.fromOffset(10, 42), Size = UDim2.new(1, -20, 1, -232) })
			local SearchIcon = Create("ImageLabel", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0, 16), Size = UDim2.fromOffset(13, 13), Theme = { ImageColor3 = "Inactive Text" }, Parent = ListPanel })
			SetIcon(SearchIcon, "Search")
			local Search = Create("TextBox", { Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -44, 0, 32), PlaceholderText = "Search players...", Text = "", ClearTextOnFocus = false, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text", PlaceholderColor3 = "Inactive Text" }, Parent = ListPanel })
			Create("Frame", { Position = UDim2.fromOffset(0, 32), Size = UDim2.new(1, 0, 0, 1), Theme = { BackgroundColor3 = "Outline" }, Parent = ListPanel })
			local Scroll = Create("ScrollingFrame", { Position = UDim2.fromOffset(0, 33), Size = UDim2.new(1, 0, 1, -34), ScrollBarThickness = 2, Theme = { ScrollBarImageColor3 = "Accent" }, Parent = ListPanel })
			Padding(Scroll, 4, 4, 4, 6)
			ListLayout(Scroll, 2)
			local Empty = Create("TextLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 16), Size = UDim2.new(1, -40, 0, 16), Text = "No players match.", TextSize = 12, Visible = false, Theme = { TextColor3 = "Inactive Text" }, Parent = ListPanel })
			Self.Scroll, Self.Count, Self.Empty, Self.FilterSwitch = Scroll, Count, Empty, Filter

			local Card = Panel(Page, { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 10, 1, -10), Size = UDim2.new(1, -20, 0, 0), AutomaticSize = Enum.AutomaticSize.Y })
			local CardItems = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = Card })
			Padding(CardItems, 12, 12, 12, 12)
			ListLayout(CardItems, 10)

			local Top = Create("Frame", { Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1, LayoutOrder = 1, Parent = CardItems })
			local BigAvatar, BigRing = Avatar(Top, 44)
			local DisplayName = Create("TextLabel", { Position = UDim2.fromOffset(56, 4), Size = UDim2.new(1, -150, 0, 18), NoCase = true, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text" }, Parent = Top })
			local Username = Create("TextLabel", { Position = UDim2.fromOffset(56, 24), Size = UDim2.new(1, -150, 0, 14), NoCase = true, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Inactive Text" }, Parent = Top })
			local StatusTag = Create("TextLabel", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X, TextSize = 11, BackgroundTransparency = 0.85, Parent = Top })
			Corner(StatusTag, 10)
			Padding(StatusTag, 0, 0, 9, 9)

			local InfoStrip = Create("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = 2, Parent = CardItems })
			local Info = {}
			local InfoKeys = { "User ID", "Team", "Account Age", "Distance", "Health" }
			for Index, Key in InfoKeys do
				local Column = Create("Frame", { Position = UDim2.fromScale((Index - 1) / #InfoKeys, 0), Size = UDim2.fromScale(1 / #InfoKeys, 1), BackgroundTransparency = 1, Parent = InfoStrip })
				Create("TextLabel", { Size = UDim2.new(1, -6, 0, 13), Text = Key, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Inactive Text" }, Parent = Column })
				Info[Key] = Create("TextLabel", { Position = UDim2.fromOffset(0, 15), Size = UDim2.new(1, -6, 0, 15), Text = "-", NoCase = true, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text" }, Parent = Column })
			end

			local StatusRow = Create("Frame", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = 3, Parent = CardItems })
			local StatusOptions = {}
			for _, Status in Library.PlayerStatuses do
				table.insert(StatusOptions, { Name = Status, Value = Status, Color = Library.StatusColors[Status] })
			end
			local StatusSwitch = SegmentSwitch(StatusRow, StatusOptions, function(Status)
				if Self.Selected then Self:SetStatus(Self.Selected, Status) end
			end)
			StatusSwitch.Frame.Size = UDim2.fromScale(1, 1)
			local YouLabel = Create("TextLabel", { Size = UDim2.fromScale(1, 1), Text = "This is you.", TextSize = 12, Visible = false, Theme = { TextColor3 = "Inactive Text" }, Parent = StatusRow })

			local ActionRow = Create("Frame", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = 4, Parent = CardItems })
			local SpectateButton, SpectateLabel = SmallButton(ActionRow, "Spectate", { Size = UDim2.new(1 / 3, -4, 1, 0) })
			local CopyNameButton = SmallButton(ActionRow, "Copy Name", { Position = UDim2.new(1 / 3, 2, 0, 0), Size = UDim2.new(1 / 3, -4, 1, 0) })
			local CopyIdButton = SmallButton(ActionRow, "Copy ID", { Position = UDim2.new(2 / 3, 4, 0, 0), Size = UDim2.new(1 / 3, -4, 1, 0) })
			Connect(SpectateButton.MouseButton1Click, function() Self:Spectate(not Self.Spectating) end)
			Connect(CopyNameButton.MouseButton1Click, function()
				if Self.Selected then CopyText(Self.Selected.Name, '"' .. Self.Selected.Name .. '"') end
			end)
			Connect(CopyIdButton.MouseButton1Click, function()
				if Self.Selected then CopyText(tostring(Self.Selected.UserId), "user id " .. Self.Selected.UserId) end
			end)
			local Custom = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 5, Parent = CardItems })
			ListLayout(Custom, 6)
			local Section = NewContainer(Custom, { Path = "Playerlist" })
			Section.NoIndex = true
			Self.Section = Section
			Connect(Card:GetPropertyChangedSignal("AbsoluteSize"), function()
				ListPanel.Size = UDim2.new(1, -20, 1, -(42 + Card.AbsoluteSize.Y + 20))
			end)

			Self.Parts = {
				Avatar = BigAvatar, Ring = BigRing, DisplayName = DisplayName, Username = Username, StatusTag = StatusTag, Info = Info,
				StatusSwitch = StatusSwitch, YouLabel = YouLabel, SpectateLabel = SpectateLabel,
			}

			Connect(Search:GetPropertyChangedSignal("Text"), function()
				Self.Query = Search.Text:lower()
				Self:_ApplyFilter()
			end)
			for _, Player in Players:GetPlayers() do Self:_Add(Player) end
			Connect(Players.PlayerAdded, function(Player) Self:_Add(Player) end)
			Connect(Players.PlayerRemoving, function(Player) Self:_Remove(Player) end)
			Self:SetFilter("All", true)
			Self:Select(LocalPlayer)

			task.spawn(function()
				while not Library.Unloaded do
					local Player = Self.Selected
					if Player and TabObject.Active then
						local Character, Mine = Player.Character, LocalPlayer.Character
						local Root = Character and Character:FindFirstChild("HumanoidRootPart")
						local MyRoot = Mine and Mine:FindFirstChild("HumanoidRootPart")
						local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
						Info.Distance.Text = (Root and MyRoot) and (math.floor((Root.Position - MyRoot.Position).Magnitude) .. " st") or "-"
						Info.Health.Text = Humanoid and (math.floor(Humanoid.Health) .. " / " .. math.floor(Humanoid.MaxHealth)) or "-"
					end
					task.wait(0.25)
				end
			end)

			Library:AddConfigExtra(function()
				local Out = {}
				for UserId, Status in Self.Statuses do
					if Status ~= "Client" then Out[tostring(UserId)] = Status end
				end
				return "__PlayerStatuses", Out
			end, function(Data)
				if type(Data.__PlayerStatuses) ~= "table" then return end
				for UserId, Status in Data.__PlayerStatuses do
					local Player = Players:GetPlayerByUserId(tonumber(UserId))
					if Player then Self:SetStatus(Player, Status, true) else Self.Statuses[tonumber(UserId)] = Status end
				end
			end)
			return Self
		end

		function Playerlist:_Add(Player)
			if self.Rows[Player] then return end
			local IsClient = Player == LocalPlayer
			local Row = Create("TextButton", { Name = Player.Name, Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Theme = { BackgroundColor3 = "Element" }, Parent = self.Scroll })
			Corner(Row, 5)
			local Bar = Create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(3, 16), Theme = { BackgroundColor3 = "Accent" }, BackgroundTransparency = 1, Parent = Row })
			Corner(Bar, 2)
			local Image, Ring = Avatar(Row, 24, { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0) })
			local Name = Create("TextLabel", { Position = UDim2.fromOffset(44, 0), Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = Player.DisplayName, NoCase = true, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Row })
			Create("UISizeConstraint", { MaxSize = Vector2.new(170, math.huge), Parent = Name })
			Name.TextTruncate = Enum.TextTruncate.AtEnd
			local Sub = Create("TextLabel", { Position = UDim2.fromOffset(44, 0), Size = UDim2.new(1, -150, 1, 0), Text = "@" .. Player.Name, NoCase = true, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Inactive Text" }, Parent = Row })
			Library:SetPlayerText(Name, Player, Player.DisplayName)
			Library:SetPlayerText(Sub, Player, "@" .. Player.Name)
			Library:SetPlayerAvatar(Image, Player, "")
			local function PlaceSub() Sub.Position = UDim2.fromOffset(44 + Name.AbsoluteSize.X + 6, 1) end
			Connect(Name:GetPropertyChangedSignal("AbsoluteSize"), PlaceSub)
			PlaceSub()
			local Tag = Create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = Row })
			ListLayout(Tag, 6, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)
			local Dot = Create("Frame", { Size = UDim2.fromOffset(6, 6), LayoutOrder = 1, Parent = Tag })
			Corner(Dot, 3)
			local TagLabel = Create("TextLabel", { Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X, TextSize = 11, LayoutOrder = 2, Parent = Tag })
			local Entry = { Player = Player, Row = Row, Bar = Bar, Ring = Ring, Name = Name, Sub = Sub, Tag = Tag, Dot = Dot, TagLabel = TagLabel }
			self.Rows[Player] = Entry
			local ThumbnailRequest = {}
			Entry.ThumbnailRequest = ThumbnailRequest
			if IsClient then self.Statuses[Player.UserId] = "Client" end
			self:_DrawStatus(Player)
			task.spawn(function()
				if Library.Unloaded or self.Rows[Player] ~= Entry or Entry.ThumbnailRequest ~= ThumbnailRequest then return end
				local Ok, Thumbnail = pcall(Players.GetUserThumbnailAsync, Players, Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
				if Ok and not Library.Unloaded and Row.Parent and self.Rows[Player] == Entry and Entry.ThumbnailRequest == ThumbnailRequest then Library:SetPlayerAvatar(Image, Player, Thumbnail) end
			end)
			Connect(Player:GetPropertyChangedSignal("Team"), function()
				if self.Selected == Player then self.Parts.Info.Team.Text = Player.Team and Player.Team.Name or "None" end
			end)
			Connect(Row.MouseEnter, function() if self.Selected ~= Player then Tween(Row, { BackgroundTransparency = 0.6 }, 0.12) end end)
			Connect(Row.MouseLeave, function() if self.Selected ~= Player then Tween(Row, { BackgroundTransparency = 1 }, 0.12) end end)
			Connect(Row.MouseButton1Click, function() self:Select(Player) end)
			self:_ApplyFilter()
		end

		function Playerlist:_Remove(Player)
			local Entry = self.Rows[Player]
			if not Entry then return end
			Entry.Row:Destroy()
			self.Rows[Player] = nil
			if self.Selected == Player then self:Select(LocalPlayer) end
			self:_ApplyFilter()
		end

		function Playerlist:_DrawStatus(Player)
			local Entry = self.Rows[Player]
			if not Entry then return end
			local Status = self:GetStatus(Player)
			local Color = Status == "Client" and Theme.Accent or Library.StatusColors[Status]
			Entry.Tag.Visible = Status ~= "Neutral"
			Library:SetText(Entry.TagLabel, Status == "Client" and "You" or Status)
			Entry.TagLabel.TextColor3 = Color or Theme["Inactive Text"]
			Entry.Dot.BackgroundColor3 = Color or Theme["Inactive Text"]
			PaintRing(Entry.Ring, Color, 0)
			Entry.Row.LayoutOrder = (StatusOrder[Status] or 4) * 1000 + (string.byte(Player.Name:lower()) or 0)
		end

		function Playerlist:SetFilter(Filter, Instant)
			self.Filter = Filter
			self.FilterSwitch:Set(Filter, Instant)
			self:_ApplyFilter()
		end

		function Playerlist:_ApplyFilter()
			local Shown = 0
			for Player, Entry in self.Rows do
				local Status = self:GetStatus(Player)
				local MatchesFilter = self.Filter == "All" or Status == self.Filter
				local MatchesQuery = self.Query == "" or (Player.Name .. " " .. Player.DisplayName):lower():find(self.Query, 1, true) ~= nil
				Entry.Row.Visible = MatchesFilter and MatchesQuery
				if Entry.Row.Visible then Shown += 1 end
			end
			self.Count.Text = #Players:GetPlayers() .. " / " .. Players.MaxPlayers
			self.Empty.Visible = Shown == 0
		end

		function Playerlist:Select(Player)
			local Old = self.Selected and self.Rows[self.Selected]
			if Old then
				Tween(Old.Row, { BackgroundTransparency = 1 }, 0.15)
				Tween(Old.Bar, { BackgroundTransparency = 1 }, 0.15)
			end
			if self.Spectating then self:Spectate(false) end
			self.Selected = Player
			local Entry = Player and self.Rows[Player]
			if Entry then
				Tween(Entry.Row, { BackgroundTransparency = 0.35 }, 0.15)
				Tween(Entry.Bar, { BackgroundTransparency = 0 }, 0.15)
			end
			if not Player then return end
			local Parts = self.Parts
			Library:SetPlayerText(Parts.DisplayName, Player, Player.DisplayName)
			Library:SetPlayerText(Parts.Username, Player, "@" .. Player.Name)
			Parts.Info["User ID"].Text = tostring(Player.UserId)
			Parts.Info.Team.Text = Player.Team and Player.Team.Name or "None"
			Parts.Info["Account Age"].Text = AccountAge(Player)
			self:_DrawProfileStatus(true)
			Library:SetPlayerAvatar(Parts.Avatar, Player, "")
			self.AvatarRequest = (self.AvatarRequest or 0) + 1
			local AvatarRequest = self.AvatarRequest
			task.spawn(function()
				if Library.Unloaded or self.AvatarRequest ~= AvatarRequest then return end
				local Ok, Image = pcall(Players.GetUserThumbnailAsync, Players, Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
				if Ok and not Library.Unloaded and Parts.Avatar.Parent and self.Selected == Player and self.AvatarRequest == AvatarRequest then Library:SetPlayerAvatar(Parts.Avatar, Player, Image) end
			end)
			for _, Callback in self.Callbacks.Selected or {} do SafeCall(Callback, Player) end
		end

		function Playerlist:_DrawProfileStatus(Instant)
			local Player = self.Selected
			if not Player then return end
			local Parts = self.Parts
			local Status = self:GetStatus(Player)
			local IsClient = Player == LocalPlayer
			local Color = IsClient and Theme.Accent or Library.StatusColors[Status]
			Parts.StatusSwitch.Frame.Visible = not IsClient
			Parts.YouLabel.Visible = IsClient
			if not IsClient then Parts.StatusSwitch:Set(Status, Instant) end
			PaintRing(Parts.Ring, Color)
			Parts.StatusTag.Visible = Status ~= "Neutral"
			Library:SetText(Parts.StatusTag, IsClient and "You" or Status)
			Parts.StatusTag.TextColor3 = Color or Theme["Inactive Text"]
			Parts.StatusTag.BackgroundColor3 = Color or Theme.Element
		end

		function Playerlist:Spectate(Enabled)
			local Camera = Workspace.CurrentCamera
			local Target = self.Selected and self.Selected.Character and self.Selected.Character:FindFirstChildOfClass("Humanoid")
			if Enabled and Target and self.Selected ~= LocalPlayer then
				Camera.CameraSubject = Target
				self.Spectating = true
			else
				if LocalPlayer.Character then Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end
				self.Spectating = false
			end
			Library:SetText(self.Parts.SpectateLabel, self.Spectating and "Stop Spectating" or "Spectate")
			ThemeTween(self.Parts.SpectateLabel, "TextColor3", self.Spectating and "Accent" or "Text", 0.15)
		end

		function Playerlist:GetStatus(Player)
			return self.Statuses[Player.UserId] or "Neutral"
		end

		function Playerlist:SetStatus(Player, Status, Silent)
			if Player == LocalPlayer then return end
			self.Statuses[Player.UserId] = Status
			self:_DrawStatus(Player)
			if self.Selected == Player then self:_DrawProfileStatus() end
			self:_ApplyFilter()
			if not Silent then
				for _, Callback in self.Callbacks.Status or {} do SafeCall(Callback, Player, Status) end
			end
		end

		function Playerlist:GetPlayersWithStatus(Status)
			local Out = {}
			for _, Player in Players:GetPlayers() do
				if self:GetStatus(Player) == Status then table.insert(Out, Player) end
			end
			return Out
		end

		function Playerlist:OnStatusChanged(Callback)
			self.Callbacks.Status = self.Callbacks.Status or {}
			table.insert(self.Callbacks.Status, Callback)
		end

		function Playerlist:OnSelected(Callback)
			self.Callbacks.Selected = self.Callbacks.Selected or {}
			table.insert(self.Callbacks.Selected, Callback)
		end
	end

	do
		local ServerList = {}
		ServerList.__index = ServerList
		Library.Classes.ServerList = ServerList

		local function HttpGet(Url)
			local Ok, Result = pcall(function() return game:HttpGet(Url) end)
			if Ok and type(Result) == "string" then return Result end
			if Library.Unloaded then return nil end
			local RequestFunction = Env.request or Env.http_request or (type(Env.syn) == "table" and Env.syn.request) or (type(Env.http) == "table" and Env.http.request)
			if typeof(RequestFunction) == "function" then
				local Ok2, Response = pcall(RequestFunction, { Url = Url, Method = "GET" })
				if Ok2 and type(Response) == "table" and Response.Body then return Response.Body end
			end
			return nil
		end

		local function FormatTime(Seconds)
			Seconds = math.floor(Seconds)
			local Hours, Minutes = math.floor(Seconds / 3600), math.floor(Seconds % 3600 / 60)
			if Hours > 0 then return string.format("%dh %02dm", Hours, Minutes) end
			return string.format("%dm %02ds", Minutes, Seconds % 60)
		end

		function Window:AddServerList(Config)
			Config = Config or {}
			local TabObject = Config.Tab or self:AddTab({ Title = Config.Title or "Servers", Icon = Config.Icon or "Globe", Category = Config.Category })
			local Page = TabObject:GetCustomPage()
			local Self = setmetatable({ Tab = TabObject, Servers = {}, Sort = "Players", Rows = {} }, ServerList)
			Library.ServerList = Self
			local TeleportService = Service("TeleportService")
			local CURRENT_HEIGHT = 92

			local Header = Create("Frame", { Position = UDim2.fromOffset(10, 10), Size = UDim2.new(1, -20, 0, 22), BackgroundTransparency = 1, Parent = Page })
			local TitleRow = Create("Frame", { Size = UDim2.new(1, -300, 1, 0), BackgroundTransparency = 1, Parent = Header })
			ListLayout(TitleRow, 8, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
			local HeaderIcon = Create("ImageLabel", { Size = UDim2.fromOffset(15, 15), LayoutOrder = 1, Theme = { ImageColor3 = "Inactive Text" }, Parent = TitleRow })
			SetIcon(HeaderIcon, Config.Icon or "Globe")
			Create("TextLabel", { Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X, Text = Config.Title or "Servers", LayoutOrder = 2, Theme = { TextColor3 = "Inactive Text" }, Parent = TitleRow })
			local CountLabel = Create("TextLabel", { Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X, Text = "", TextSize = 11, LayoutOrder = 3, Theme = { TextColor3 = "Inactive Text" }, Parent = TitleRow })
			local Sorter = SegmentSwitch(Header, {
				{ Name = "Most players", Value = "Players" },
				{ Name = "Least players", Value = "Empty" },
				{ Name = "Best ping", Value = "Ping" },
			}, function(Sort) Self:SetSort(Sort) end)
			Sorter.Frame.AnchorPoint = Vector2.new(1, 0.5)
			Sorter.Frame.Position = UDim2.new(1, 0, 0.5, 0)
			Sorter.Frame.Size = UDim2.fromOffset(222, 22)
			local RefreshButton, RefreshLabel = SmallButton(Header, "Refresh", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -228, 0.5, 0), Size = UDim2.fromOffset(64, 22) })
			RefreshLabel.TextSize = 11
			Self.Sorter, Self.CountLabel, Self.RefreshLabel, Self.RefreshButton = Sorter, CountLabel, RefreshLabel, RefreshButton

			local ListPanel = Panel(Page, { Position = UDim2.fromOffset(10, 42), Size = UDim2.new(1, -20, 1, -(42 + 10 + CURRENT_HEIGHT + 10)) })
			local Columns = { { "#", 12 }, { "Players", 44 }, { "Ping", 214 }, { "FPS", 272 } }
			for _, Column in Columns do
				Create("TextLabel", { Position = UDim2.fromOffset(Column[2], 0), Size = UDim2.fromOffset(60, 28), Text = Column[1], TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Inactive Text" }, Parent = ListPanel })
			end
			Create("Frame", { Position = UDim2.fromOffset(0, 28), Size = UDim2.new(1, 0, 0, 1), Theme = { BackgroundColor3 = "Outline" }, Parent = ListPanel })
			local Scroll = Create("ScrollingFrame", { Position = UDim2.fromOffset(0, 29), Size = UDim2.new(1, 0, 1, -30), ScrollBarThickness = 2, Theme = { ScrollBarImageColor3 = "Accent" }, Parent = ListPanel })
			ListLayout(Scroll, 0)
			local Notice = Create("TextLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 14), Size = UDim2.new(1, -60, 0, 40), Text = "", TextWrapped = true, TextSize = 12, Visible = false, Theme = { TextColor3 = "Inactive Text" }, Parent = ListPanel })
			Self.Scroll, Self.Notice = Scroll, Notice

			local Current = Panel(Page, { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 10, 1, -10), Size = UDim2.new(1, -20, 0, CURRENT_HEIGHT) })
			local Dot = Create("Frame", { Position = UDim2.fromOffset(12, 16), Size = UDim2.fromOffset(7, 7), BackgroundColor3 = PingColors.Good, Parent = Current })
			Corner(Dot, 4)
			Create("TextLabel", { Position = UDim2.fromOffset(26, 10), Size = UDim2.fromOffset(160, 18), Text = "Current server", TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Current })
			local StatsLabel = Create("TextLabel", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 10), Size = UDim2.new(1, -200, 0, 18), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, Theme = { TextColor3 = "Inactive Text" }, Parent = Current })
			local JobLabel = Create("TextLabel", { Position = UDim2.fromOffset(12, 30), Size = UDim2.new(1, -24, 0, 14), NoCase = true, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Inactive Text" }, Parent = Current })
			local Buttons = Create("Frame", { Position = UDim2.new(0, 12, 1, -36), Size = UDim2.new(1, -24, 0, 24), BackgroundTransparency = 1, Parent = Current })
			local RejoinButton = SmallButton(Buttons, "Rejoin", { Size = UDim2.new(1 / 3, -4, 1, 0) })
			local HopButton = SmallButton(Buttons, "Server Hop", { Position = UDim2.new(1 / 3, 2, 0, 0), Size = UDim2.new(1 / 3, -4, 1, 0) })
			local CopyButton = SmallButton(Buttons, "Copy Job ID", { Position = UDim2.new(2 / 3, 4, 0, 0), Size = UDim2.new(1 / 3, -4, 1, 0) })

			local function Teleport(JobId)
				local Ok, Error = pcall(function()
					if JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, JobId, LocalPlayer)
					else TeleportService:Teleport(game.PlaceId, LocalPlayer) end
				end)
				if Ok then Library:Notify("Teleporting...") else Library:Notify({ Text = "Teleport failed: " .. tostring(Error), Type = "Error" }) end
			end
			Self.Teleport = Teleport
			Connect(RejoinButton.MouseButton1Click, function()
				if #Players:GetPlayers() <= 1 then Teleport(nil) else Teleport(game.JobId) end
			end)
			Connect(HopButton.MouseButton1Click, function() Self:Hop() end)
			Connect(CopyButton.MouseButton1Click, function() CopyText(game.JobId, "job id") end)
			Connect(RefreshButton.MouseButton1Click, function() Self:Refresh() end)

			task.spawn(function()
				while not Library.Unloaded do
					if TabObject.Active then
						local Ping = GetPing()
						JobLabel.Text = "Job ID  " .. (game.JobId ~= "" and game.JobId or "studio")
						Library:SetText(StatsLabel, string.format("%d / %d players  ·  %d ms  ·  up %s", #Players:GetPlayers(), Players.MaxPlayers, Ping, FormatTime(Workspace.DistributedGameTime)))
						Dot.BackgroundColor3 = PingColor(Ping)
					end
					task.wait(1)
				end
			end)
			Self:SetSort("Players", true)
			TabObject:OnSelected(function()
				if not Self.Loaded then Self:Refresh() end
			end)
			return Self
		end

		function ServerList:SetSort(Sort, Instant)
			self.Sort = Sort
			self.Sorter:Set(Sort, Instant)
			self:_Render()
		end

		function ServerList:Refresh()
			if Library.Unloaded or self.Refreshing then return end
			self.Loaded = true
			self.Refreshing = true
			self.RenderRequest = (self.RenderRequest or 0) + 1
			self.Notice.Visible = true
			Library:SetText(self.Notice, "Loading servers...")
			Library:SetText(self.RefreshLabel, "Loading...")
			self.RefreshButton.Active = false
			task.defer(function()
				if Library.Unloaded then return end
				local Ok, Servers = pcall(function()
					local Body = HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=false")
					if Library.Unloaded or not Body then return nil end
					local Data = HttpService:JSONDecode(Body)
					if type(Data) ~= "table" or type(Data.data) ~= "table" then return nil end
					local Result = {}
					for Index = 1, math.min(#Data.data, 100) do
						local Server = Data.data[Index]
						if type(Server) == "table" then
							table.insert(Result, { Id = Server.id, Playing = Server.playing or 0, Max = Server.maxPlayers or Players.MaxPlayers, Ping = Server.ping or 0, Fps = Server.fps or 0 })
						end
					end
					return Result
				end)
				if Library.Unloaded then return end
				self.Refreshing = false
				self.RefreshButton.Active = true
				Library:SetText(self.RefreshLabel, "Refresh")
				self.Servers = Ok and Servers or {}
				if not Ok or not Servers then
					Library:SetText(self.Notice, "Could not load the server list. It needs HttpGet (executor) and does not work inside Studio.")
					self:_Render()
					return
				end
				self.Notice.Visible = #self.Servers == 0
				Library:SetText(self.Notice, "No public servers found.")
				self:_Render()
			end)
		end

		function ServerList:_Render()
			if Library.Unloaded then return end
			self.RenderRequest = (self.RenderRequest or 0) + 1
			local Request = self.RenderRequest
			local Sorted = table.clone(self.Servers)
			local Sort = self.Sort
			task.defer(function()
				local function Current() return not Library.Unloaded and self.RenderRequest == Request end
				if not Current() then return end
				for Index = #self.Rows, 1, -1 do
					self.Rows[Index]:Destroy()
					self.Rows[Index] = nil
					if Index % 5 == 0 then
						task.wait()
						if not Current() then return end
					end
				end
				local Connections, Next = Library.Connections, 1
				for Index = 1, #Connections do
					local Connection = Connections[Index]
					if Connection.Connected ~= false then
						Connections[Next] = Connection
						Next += 1
					end
				end
				for Index = #Connections, Next, -1 do Connections[Index] = nil end
				table.sort(Sorted, function(A, B)
					if Sort == "Empty" then return A.Playing < B.Playing end
					if Sort == "Ping" then return A.Ping < B.Ping end
					return A.Playing > B.Playing
				end)
				local Count = #Sorted
				Library:SetText(self.CountLabel, Count > 0 and (Count == 1 and "1 server" or (Count .. " servers")) or "")
				for Index, Server in Sorted do
					local IsCurrent = Server.Id == game.JobId
					local Row = Create("TextButton", { Size = UDim2.new(1, 0, 0, 34), Theme = { BackgroundColor3 = "Element" }, BackgroundTransparency = IsCurrent and 0.5 or 1, LayoutOrder = Index, Parent = self.Scroll })
					if Index < Count then
						Create("Frame", { Position = UDim2.new(0, 10, 1, -1), Size = UDim2.new(1, -20, 0, 1), Theme = { BackgroundColor3 = "Outline" }, BackgroundTransparency = 0.4, Parent = Row })
					end
					Create("TextLabel", { Position = UDim2.fromOffset(12, 0), Size = UDim2.fromOffset(30, 34), Text = tostring(Index), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Inactive Text" }, Parent = Row })
					local BarBack = Create("Frame", { Position = UDim2.fromOffset(44, 15), Size = UDim2.fromOffset(100, 5), Theme = { BackgroundColor3 = "Inline" }, Parent = Row })
					Corner(BarBack, 3)
					local Fill = Create("Frame", { Size = UDim2.fromScale(math.clamp(Server.Playing / math.max(Server.Max, 1), 0.04, 1), 1), Theme = { BackgroundColor3 = "ToggleFill" }, Parent = BarBack })
					Corner(Fill, 3)
					Create("TextLabel", { Position = UDim2.fromOffset(152, 0), Size = UDim2.fromOffset(56, 34), Text = Server.Playing .. "/" .. Server.Max, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Row })
					Create("TextLabel", { Position = UDim2.fromOffset(214, 0), Size = UDim2.fromOffset(54, 34), Text = math.floor(Server.Ping) .. " ms", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = PingColor(Server.Ping), Parent = Row })
					Create("TextLabel", { Position = UDim2.fromOffset(272, 0), Size = UDim2.fromOffset(54, 34), Text = tostring(math.floor(Server.Fps)), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Inactive Text" }, Parent = Row })
					local Join, JoinLabel = SmallButton(Row, IsCurrent and "You're here" or "Join", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(IsCurrent and 76 or 56, 22) })
					if IsCurrent then
						ThemeTween(JoinLabel, "TextColor3", "Accent", 0)
					else
						Connect(Join.MouseButton1Click, function() self.Teleport(Server.Id) end)
					end
					Connect(Row.MouseEnter, function() Tween(Row, { BackgroundTransparency = IsCurrent and 0.3 or 0.6 }, 0.12) end)
					Connect(Row.MouseLeave, function() Tween(Row, { BackgroundTransparency = IsCurrent and 0.5 or 1 }, 0.12) end)
					table.insert(self.Rows, Row)
					if Index % 5 == 0 and Index < Count then
						task.wait()
						if not Current() then return end
					end
				end
			end)
		end

		function ServerList:Hop()
			local Options = {}
			for _, Server in self.Servers do
				if Server.Id ~= game.JobId and Server.Playing < Server.Max then table.insert(Options, Server) end
			end
			if #Options == 0 then
				Library:Notify({ Text = "No other servers available (refresh first).", Type = "Warning" })
				return
			end
			self.Teleport(Options[math.random(1, #Options)].Id)
		end
	end

	do
		local SkinChanger = {}
		SkinChanger.__index = SkinChanger
		local SkinCategory = {}
		SkinCategory.__index = SkinCategory
		local SkinWeapon = {}
		SkinWeapon.__index = SkinWeapon
		Library.Classes.SkinChanger = SkinChanger

		Library.Rarities = {
			Default = Rgb(148, 148, 148),
			Consumer = Rgb(176, 195, 217),
			Industrial = Rgb(94, 152, 217),
			["Mil-Spec"] = Rgb(75, 105, 255),
			Restricted = Rgb(136, 71, 255),
			Classified = Rgb(211, 44, 230),
			Covert = Rgb(235, 75, 75),
			Contraband = Rgb(228, 174, 57),
		}

		local function RarityColor(Rarity)
			return Library.Rarities[Rarity or "Default"] or Library.Rarities.Default
		end

		local function EqualGrid(Parent, Columns, Height, Gap)
			Gap = Gap or 8
			local Layout = Create("UIGridLayout", { CellPadding = UDim2.fromOffset(Gap, Gap), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Parent })
			local Inset = Create("UIPadding", { Parent = Parent })
			local function Fit()
				local Width = Parent.AbsoluteSize.X
				local Cell = math.max(1, math.floor((Width - Gap * (Columns - 1)) / Columns))
				Layout.CellSize = UDim2.fromOffset(Cell, Height)
				Inset.PaddingLeft = UDim.new(0, math.max(0, math.floor((Width - Cell * Columns - Gap * (Columns - 1)) / 2)))
			end
			Connect(Parent:GetPropertyChangedSignal("AbsoluteSize"), Fit)
			Fit()
			return Layout
		end

		local function SkinCard(Parent, Data)
			local StageHeight = Data.StageHeight or 72
			local Card = Create("TextButton", { LayoutOrder = Data.Order or 0, Theme = { BackgroundColor3 = "Tab" }, Parent = Parent })
			Corner(Card, 6)
			local CardStroke = Stroke(Card, "Outline")
			local Stage = Create("Frame", { Position = UDim2.fromOffset(5, 5), Size = UDim2.new(1, -10, 0, StageHeight), Theme = { BackgroundColor3 = "Background" }, Parent = Card })
			Corner(Stage, 5)
			local Glow = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = RarityColor(Data.Rarity), BackgroundTransparency = Data.Rarity and 0 or 1, Parent = Stage })
			Corner(Glow, 5)
			Create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.4, 1), NumberSequenceKeypoint.new(1, 0.78) }), Parent = Glow })
			local Inset = Data.ImageInset or 12
			local Image = Create("ImageLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, -Inset * 2, 1, -Inset * 2), ScaleType = Enum.ScaleType.Fit, ImageColor3 = Data.ImageColor or Color3.new(1, 1, 1), ZIndex = 2, Parent = Stage })
			SetIcon(Image, Data.Image)
			local Title = Create("TextLabel", { Position = UDim2.fromOffset(9, StageHeight + 11), Size = UDim2.new(1, -18, 0, 14), Text = Data.Title or "", TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text" }, Parent = Card })
			local Subtitle = Create("TextLabel", { Position = UDim2.fromOffset(9, StageHeight + 27), Size = UDim2.new(1, -18, 0, 12), Text = Data.Subtitle or "", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = Card })
			local Self = { Card = Card, Stroke = CardStroke, Stage = Stage, Glow = Glow, Image = Image, Title = Title, Subtitle = Subtitle, Selected = false, Corners = {} }
			function Self.SetRarity(_, Rarity)
				Glow.BackgroundColor3 = RarityColor(Rarity)
				Glow.BackgroundTransparency = Rarity and 0 or 1
				if Rarity then
					Library:Unthemed(Subtitle, "TextColor3")
					Subtitle.TextColor3 = RarityColor(Rarity)
				else
					Library:Theme(Subtitle, "TextColor3", "Inactive Text")
				end
			end
			function Self.SetSelected(_, Selected)
				Self.Selected = Selected
				ThemeTween(CardStroke, "Color", Selected and "Accent" or "Outline", 0.15)
			end
			Self:SetRarity(Data.Rarity)
			local Grow = UDim2.new(1, -Inset * 2 + 8, 1, -Inset * 2 + 8)
			Connect(Card.MouseEnter, function()
				ThemeTween(Card, "BackgroundColor3", "Hovered Element", 0.12)
				Tween(Image, { Size = Grow }, 0.2)
				for _, Icon in Self.Corners do Tween(Icon, { ImageTransparency = 0 }, 0.12) end
			end)
			Connect(Card.MouseLeave, function()
				ThemeTween(Card, "BackgroundColor3", "Tab", 0.12)
				Tween(Image, { Size = UDim2.new(1, -Inset * 2, 1, -Inset * 2) }, 0.2)
				for Button, Icon in Self.Corners do
					if not Button:GetAttribute("On") then Tween(Icon, { ImageTransparency = 0.5 }, 0.12) end
				end
			end)
			return Self
		end

		local function CornerIcon(Card, Icon, Position, Anchor)
			local Button = Create("ImageButton", { AnchorPoint = Anchor, Position = Position, Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1, ImageTransparency = 1, ZIndex = 5, Parent = Card.Stage })
			local Image = Create("ImageLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(12, 12), ImageTransparency = 0.5, Theme = { ImageColor3 = "Inactive Text" }, ZIndex = 6, Parent = Button })
			SetIcon(Image, Icon)
			Card.Corners[Button] = Image
			Connect(Button.MouseEnter, function() ThemeTween(Image, "ImageColor3", "Text", 0.12) end)
			Connect(Button.MouseLeave, function() if not Button:GetAttribute("On") then ThemeTween(Image, "ImageColor3", "Inactive Text", 0.12) end end)
			return Button, Image
		end

		function Window:AddSkinChanger(Config)
			Config = Config or {}
			local TabObject = Config.Tab or self:AddTab({ Title = Config.Title or "Skins", Icon = Config.Icon or "Brush", Category = Config.Category })
			local Page = TabObject:GetCustomPage()
			local Self = setmetatable({ Tab = TabObject, Window = self, Categories = {}, Weapons = {}, Saved = {}, Callbacks = {}, Counter = 0 }, SkinChanger)
			Library.SkinChanger = Self
			local Base = UDim2.fromOffset(10, 42)

			local Header = Create("Frame", { Position = UDim2.fromOffset(10, 10), Size = UDim2.new(1, -20, 0, 22), BackgroundTransparency = 1, Parent = Page })
			local Crumbs = Create("Frame", { Size = UDim2.new(1, -150, 1, 0), BackgroundTransparency = 1, Parent = Header })
			ListLayout(Crumbs, 6, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
			local HeaderIcon = Create("ImageLabel", { Size = UDim2.fromOffset(15, 15), LayoutOrder = 0, Theme = { ImageColor3 = "Inactive Text" }, Parent = Crumbs })
			SetIcon(HeaderIcon, Config.Icon or "Brush")
			local Counter = Create("TextLabel", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(140, 22), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Theme = { TextColor3 = "Inactive Text" }, Parent = Header })
			local SearchFrame = Create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(140, 22), Theme = { BackgroundColor3 = "Element" }, Visible = false, Parent = Header })
			Corner(SearchFrame, 5)
			Stroke(SearchFrame, "Outline")
			local SearchIcon = Create("ImageLabel", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), Size = UDim2.fromOffset(11, 11), Theme = { ImageColor3 = "Inactive Text" }, Parent = SearchFrame })
			SetIcon(SearchIcon, "Search")
			local SearchBox = Create("TextBox", { Position = UDim2.fromOffset(25, 0), Size = UDim2.new(1, -31, 1, 0), Text = "", PlaceholderText = "Search weapons...", TextSize = 12, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text", PlaceholderColor3 = "Inactive Text" }, Parent = SearchFrame })

			local function View(Name)
				return Create("CanvasGroup", { Name = Name, Position = Base, Size = UDim2.new(1, -12, 1, -(Base.Y.Offset + 10)), BackgroundTransparency = 1, GroupTransparency = 1, Visible = false, Parent = Page })
			end
			local function Scroll(Parent, Position, Size)
				local Frame = Create("ScrollingFrame", { Position = Position, Size = Size, ScrollBarThickness = 2, Theme = { ScrollBarImageColor3 = "Accent" }, Parent = Parent })
				local Body = Create("Frame", { Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = Frame })
				Padding(Body, 1, 10, 0, 0)
				return Frame, Body
			end

			local Main = View("Saved")
			local _, MainBody = Scroll(Main, UDim2.new(), UDim2.fromScale(1, 1))
			local MainGrid = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = MainBody })
			EqualGrid(MainGrid, 3, 128)
			local CreateCard = Create("TextButton", { LayoutOrder = -1000, Theme = { BackgroundColor3 = "Tab" }, BackgroundTransparency = 0.6, Parent = MainGrid })
			Corner(CreateCard, 6)
			local CreateStroke = Stroke(CreateCard, "Outline")
			local PlusRing = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, -10), Size = UDim2.fromOffset(32, 32), Theme = { BackgroundColor3 = "Element" }, Parent = CreateCard })
			Corner(PlusRing, 16)
			local PlusStroke = Stroke(PlusRing, "Outline")
			local PlusIcon = Create("ImageLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(12, 12), Theme = { ImageColor3 = "Inactive Text" }, Parent = PlusRing })
			SetIcon(PlusIcon, "Cross")
			local CreateText = Create("TextLabel", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0.5, 14), Size = UDim2.new(1, -12, 0, 14), Text = "New skin", TextSize = 12, Theme = { TextColor3 = "Inactive Text" }, Parent = CreateCard })
			Connect(CreateCard.MouseEnter, function()
				for Object, Property in { [CreateText] = "TextColor3", [PlusIcon] = "ImageColor3", [PlusStroke] = "Color", [CreateStroke] = "Color" } do ThemeTween(Object, Property, "Accent", 0.15) end
			end)
			Connect(CreateCard.MouseLeave, function()
				ThemeTween(CreateText, "TextColor3", "Inactive Text", 0.15)
				ThemeTween(PlusIcon, "ImageColor3", "Inactive Text", 0.15)
				ThemeTween(PlusStroke, "Color", "Outline", 0.15)
				ThemeTween(CreateStroke, "Color", "Outline", 0.15)
			end)

			local Picker = View("Picker")
			local _, PickerBody = Scroll(Picker, UDim2.new(), UDim2.fromScale(1, 1))
			ListLayout(PickerBody, 14)
			local NoResults = Create("TextLabel", { Size = UDim2.new(1, 0, 0, 40), Text = "No weapons found.", TextSize = 12, Visible = false, LayoutOrder = 100000, Theme = { TextColor3 = "Inactive Text" }, Parent = PickerBody })

			local Gallery = View("Gallery")
			local Banner = Panel(Gallery, { Size = UDim2.new(1, -8, 0, 132) })
			local Stage = Create("Frame", { Position = UDim2.fromOffset(8, 8), Size = UDim2.new(0, 200, 1, -16), Theme = { BackgroundColor3 = "Background" }, Parent = Banner })
			Corner(Stage, 5)
			local StageGlow = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Library.Rarities.Default, Parent = Stage })
			Corner(StageGlow, 5)
			Create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.35, 1), NumberSequenceKeypoint.new(1, 0.72) }), Parent = StageGlow })
			local Preview = Create("ImageLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, -28, 1, -24), ScaleType = Enum.ScaleType.Fit, ZIndex = 2, Parent = Stage })
			local Info = Create("Frame", { Position = UDim2.fromOffset(222, 12), Size = UDim2.new(1, -234, 1, -24), BackgroundTransparency = 1, Parent = Banner })
			local SkinName = Create("TextLabel", { Size = UDim2.new(1, 0, 0, 18), TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text" }, Parent = Info })
			local WeaponName = Create("TextLabel", { Position = UDim2.fromOffset(0, 21), Size = UDim2.new(1, 0, 0, 14), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Inactive Text" }, Parent = Info })
			local RarityPill = Create("Frame", { Position = UDim2.fromOffset(0, 43), Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = Library.Rarities.Default, BackgroundTransparency = 0.85, Parent = Info })
			Corner(RarityPill, 9)
			local RarityLabel = Create("TextLabel", { Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, TextSize = 11, Parent = RarityPill })
			Padding(RarityLabel, 0, 0, 8, 8)
			local BannerButtons = Create("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Parent = Info })
			local ApplyButton, ApplyLabel = SmallButton(BannerButtons, "Apply", { Size = UDim2.new(0.5, -3, 1, 0) })
			local CustomizeButton = SmallButton(BannerButtons, "Customize", { Position = UDim2.new(0.5, 3, 0, 0), Size = UDim2.new(0.5, -3, 1, 0) })
			local _, SkinBody = Scroll(Gallery, UDim2.fromOffset(0, 142), UDim2.new(1, 0, 1, -142))
			local SkinGrid = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = SkinBody })
			EqualGrid(SkinGrid, 3, 114)

			local Dim = Create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, Visible = false, ZIndex = 20, Parent = Page })
			local Popup = Create("CanvasGroup", { Active = true, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(300, 0), AutomaticSize = Enum.AutomaticSize.Y, Theme = { BackgroundColor3 = "Popup" }, GroupTransparency = 1, Visible = false, ZIndex = 21, Parent = Page })
			Corner(Popup, 8)
			Stroke(Popup, "Outline")
			local PopupItems = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = Popup })
			Padding(PopupItems, 12, 12, 12, 12)
			ListLayout(PopupItems, 8)
			local PopupTitle = Create("TextLabel", { Size = UDim2.new(1, 0, 0, 18), Text = "Customize", TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 0, Theme = { TextColor3 = "Text" }, Parent = PopupItems })
			local PopupBody = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 1, Parent = PopupItems })
			local Done = Create("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, LayoutOrder = 2, Parent = PopupItems })
			ListLayout(Done, 0)
			local DoneContainer = NewContainer(Done, { Path = "" })
			DoneContainer.NoIndex = true
			DoneContainer:AddButton({ Text = "Done", Callback = function() Self:ClosePopup() end })

			Self.Parts = {
				Page = Page, Crumbs = Crumbs, Counter = Counter, SearchFrame = SearchFrame, SearchBox = SearchBox, NoResults = NoResults,
				Main = Main, MainGrid = MainGrid, Picker = Picker, PickerBody = PickerBody, Gallery = Gallery, Base = Base,
				StageGlow = StageGlow, Preview = Preview, SkinName = SkinName, WeaponName = WeaponName, RarityPill = RarityPill, RarityLabel = RarityLabel,
				ApplyLabel = ApplyLabel, SkinGrid = SkinGrid, Dim = Dim, Popup = Popup, PopupTitle = PopupTitle, PopupBody = PopupBody,
			}
			Self.View = nil

			Connect(CreateCard.MouseButton1Click, function() Self:ShowView("Picker") end)
			Connect(ApplyButton.MouseButton1Click, function() Self:Apply() end)
			Connect(CustomizeButton.MouseButton1Click, function() Self:OpenPopup() end)
			Connect(Dim.MouseButton1Click, function() Self:ClosePopup() end)
			Connect(SearchBox:GetPropertyChangedSignal("Text"), function() Self:_Filter(SearchBox.Text) end)

			Library:AddConfigExtra(function()
				local Out = {}
				for Name, Entry in Self.Saved do
					table.insert(Out, { Weapon = Name, Skin = Entry.Skin and Entry.Skin.Name, Settings = Entry.Settings, Pinned = Entry.Pinned })
				end
				return "__Skins", Out
			end, function(Data)
				if type(Data.__Skins) ~= "table" then return end
				Self:ClearSkins()
				for _, Saved in Data.__Skins do
					local Weapon = Self.Weapons[Saved.Weapon]
					if Weapon then Self:SetSkin(Weapon, Weapon:GetSkin(Saved.Skin), Saved.Settings, Saved.Pinned) end
				end
			end)
			Self:ShowView("Main", true)
			return Self
		end

		function SkinChanger:_SetCrumbs(List)
			local Crumbs = self.Parts.Crumbs
			for _, Child in Crumbs:GetChildren() do
				if Child:GetAttribute("Crumb") then Child:Destroy() end
			end
			for Index, Entry in List do
				if type(Entry) == "string" then Entry = { Entry } end
				local Last = Index == #List
				if Index > 1 then
					local Slash = Create("TextLabel", { Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X, Text = "/", LayoutOrder = Index * 2 - 1, Theme = { TextColor3 = "Outline" }, Parent = Crumbs })
					Slash:SetAttribute("Crumb", true)
				end
				local Button = Create("TextButton", { Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Text = Entry[1], LayoutOrder = Index * 2, Theme = { TextColor3 = Last and "Text" or "Inactive Text" }, Parent = Crumbs })
				Button:SetAttribute("Crumb", true)
				if not Last and Entry[2] then
					Connect(Button.MouseEnter, function() ThemeTween(Button, "TextColor3", "Text", 0.12) end)
					Connect(Button.MouseLeave, function() ThemeTween(Button, "TextColor3", "Inactive Text", 0.12) end)
					Connect(Button.MouseButton1Click, Entry[2])
				end
			end
		end

		function SkinChanger:_Count()
			local Count = 0
			for _ in self.Saved do Count += 1 end
			return Count
		end

		function SkinChanger:ShowView(View, Instant)
			local Parts = self.Parts
			local Previous = self.View
			self.View = View
			local Views = { Main = Parts.Main, Picker = Parts.Picker, Gallery = Parts.Gallery }
			for Name, Frame in Views do
				if Name == View then
					Frame.Visible = true
					Frame.ZIndex = 2
					Frame.Position = Parts.Base + UDim2.fromOffset(0, (Instant or Previous == View) and 0 or 10)
					Tween(Frame, { Position = Parts.Base }, Instant and 0 or 0.3, Enum.EasingStyle.Quad)
					Tween(Frame, { GroupTransparency = 0 }, Instant and 0 or 0.15, Enum.EasingStyle.Quad)
				elseif Frame.Visible then
					Frame.ZIndex = 1
					Tween(Frame, { Position = Parts.Base - UDim2.fromOffset(0, 10) }, Instant and 0 or 0.3, Enum.EasingStyle.Quad)
					Tween(Frame, { GroupTransparency = 1 }, Instant and 0 or 0.2, Enum.EasingStyle.Quad).Completed:Connect(function()
						if self.View ~= Name then Frame.Visible = false end
					end)
				end
			end
			Parts.SearchFrame.Visible = View == "Picker"
			Parts.Counter.Visible = View ~= "Picker"
			if View == "Main" then
				self.EditingSaved = false
				self:_SetCrumbs({ "Skins" })
				local Count = self:_Count()
				Library:SetText(Parts.Counter, Count == 1 and "1 saved skin" or (Count .. " saved skins"))
			elseif View == "Picker" then
				self.EditingSaved = false
				Parts.SearchBox.Text = ""
				self:_SetCrumbs({ { "Skins", function() self:ShowView("Main") end }, "Choose a weapon" })
			end
		end

		function SkinChanger:_Filter(Query)
			Query = Query:lower()
			local Any = false
			for _, Category in self.Categories do
				local Shown = 0
				for _, Weapon in Category.Weapons do
					local Match = Query == "" or Weapon.Name:lower():find(Query, 1, true) ~= nil
					Weapon.Tile.Card.Visible = Match
					if Match then Shown += 1 end
				end
				Category.Holder.Visible = Shown > 0
				Any = Any or Shown > 0
			end
			self.Parts.NoResults.Visible = not Any
		end

		function SkinChanger:AddCategory(Config)
			if type(Config) == "string" then Config = { Name = Config } end
			Config = Config or {}
			self.Counter += 1
			local Holder = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = self.Counter, Parent = self.Parts.PickerBody })
			ListLayout(Holder, 8)
			Create("TextLabel", { Size = UDim2.new(1, 0, 0, 14), Text = Config.Name or "Category", TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Inactive Text" }, LayoutOrder = 0, Parent = Holder })
			local GridHolder = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 1, Parent = Holder })
			EqualGrid(GridHolder, 4, 104)
			local Category = setmetatable({ Name = Config.Name, SkinChanger = self, Holder = Holder, Grid = GridHolder, Weapons = {}, Counter = 0 }, SkinCategory)
			table.insert(self.Categories, Category)
			return Category
		end

		function SkinCategory:AddWeapon(Config)
			Config = Config or {}
			self.Counter += 1
			local Changer = self.SkinChanger
			local Weapon = setmetatable({
				Name = Config.Name or "Weapon",
				Icon = Config.Icon,
				Category = self,
				SkinChanger = Changer,
				Skins = { { Name = "Default", Rarity = "Default" } },
				Elements = {},
			}, SkinWeapon)
			for _, Skin in Config.Skins or {} do table.insert(Weapon.Skins, Skin) end

			local Count = #Weapon.Skins - 1
			local Tile = SkinCard(self.Grid, { Title = Weapon.Name, Subtitle = Count == 1 and "1 skin" or (Count .. " skins"), Image = Weapon.Icon, StageHeight = 56, ImageInset = 6, Order = self.Counter })
			Weapon.Tile = Tile
			Connect(Tile.Card.MouseButton1Click, function() Changer:OpenWeapon(Weapon) end)

			local Body = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = false, Parent = Changer.Parts.PopupBody })
			local _, Items = SectionBox(Body, { Path = "Skins / " .. Weapon.Name })
			Items.NoIndex = true
			Weapon.Body = Body
			local Before = {}
			for Flag in Library.Elements do Before[Flag] = true end
			SafeCall(Config.Elements or Config.Settings, Items, Weapon)
			for Flag, Element in Library.Elements do
				if not Before[Flag] then
					Weapon.Elements[Flag] = Element
					Element.NoSave = true
				end
			end
			Changer.Weapons[Weapon.Name] = Weapon
			table.insert(self.Weapons, Weapon)
			return Weapon
		end

		function SkinWeapon:GetSkin(Name)
			for _, Skin in self.Skins do
				if Skin.Name == Name then return Skin end
			end
			return self.Skins[1]
		end

		function SkinWeapon:ReadSettings()
			local Settings = {}
			for Flag, Element in self.Elements do
				local Ok, Value = pcall(Element.Serialize, Element)
				if Ok then Settings[Flag] = Value end
			end
			return Settings
		end

		function SkinWeapon:WriteSettings(Settings)
			for Flag, Value in Settings or {} do
				local Element = self.Elements[Flag]
				if Element then pcall(Element.Deserialize, Element, Value) end
			end
		end

		local function SkinImage(Weapon, Skin)
			return Skin.Image or Weapon.Icon, Skin.Image and Color3.new(1, 1, 1) or (Skin.Color or Color3.new(1, 1, 1))
		end

		function SkinChanger:OpenWeapon(Weapon, FromSaved)
			local Parts = self.Parts
			self.Weapon = Weapon
			for _, Child in Parts.SkinGrid:GetChildren() do
				if Child:IsA("GuiObject") then Child:Destroy() end
			end
			self.SkinCards = {}
			local Saved = self.Saved[Weapon.Name]
			for Index, Skin in Weapon.Skins do
				local Image, Color = SkinImage(Weapon, Skin)
				local Card = SkinCard(Parts.SkinGrid, { Title = Skin.Name, Subtitle = Skin.Rarity or "Default", Image = Image, ImageColor = Color, Rarity = Skin.Rarity or "Default", StageHeight = 60, Order = Index })
				self.SkinCards[Skin] = Card
				Connect(Card.Card.MouseButton1Click, function() self:SelectSkin(Skin) end)
			end
			if Saved then Weapon:WriteSettings(Saved.Settings) end
			self:ShowView("Gallery")
			self.EditingSaved = FromSaved == true
			local Count = #Weapon.Skins
			Library:SetText(Parts.Counter, Count == 1 and "1 skin" or (Count .. " skins"))
			local Crumbs = { { "Skins", function() self:ShowView("Main") end } }
			if not self.EditingSaved then table.insert(Crumbs, { Weapon.Category.Name or "Weapons", function() self:ShowView("Picker") end }) end
			table.insert(Crumbs, Weapon.Name)
			self:_SetCrumbs(Crumbs)
			self:SelectSkin(Saved and Saved.Skin or Weapon.Skins[math.min(2, #Weapon.Skins)])
		end

		function SkinChanger:SelectSkin(Skin)
			local Parts, Weapon = self.Parts, self.Weapon
			if not Weapon or not Skin then return end
			self.SelectedSkin = Skin
			for Other, Card in self.SkinCards do Card:SetSelected(Other == Skin) end
			local Image, Color = SkinImage(Weapon, Skin)
			local Rarity = RarityColor(Skin.Rarity)
			SetIcon(Parts.Preview, Image)
			Parts.Preview.ImageColor3 = Color
			Parts.Preview.Position = UDim2.fromScale(0.5, 0.56)
			Parts.Preview.ImageTransparency = 0.6
			Tween(Parts.Preview, { Position = UDim2.fromScale(0.5, 0.5), ImageTransparency = 0 }, 0.25)
			Library:SetText(Parts.SkinName, Skin.Name)
			Library:SetText(Parts.WeaponName, Weapon.Name .. "  ·  " .. (Weapon.Category.Name or ""))
			Library:SetText(Parts.RarityLabel, Skin.Rarity or "Default")
			Parts.RarityLabel.TextColor3 = Rarity
			Tween(Parts.RarityPill, { BackgroundColor3 = Rarity }, 0.25)
			Tween(Parts.StageGlow, { BackgroundColor3 = Rarity }, 0.25)
			local Saved = self.Saved[Weapon.Name]
			local Applied = Saved and Saved.Skin == Skin
			Library:SetText(Parts.ApplyLabel, Applied and "Applied" or "Apply")
			ThemeTween(Parts.ApplyLabel, "TextColor3", Applied and "Accent" or "Text", 0.15)
		end

		function SkinChanger:Apply()
			local Weapon, Skin = self.Weapon, self.SelectedSkin
			if not Weapon or not Skin then return end
			self:SetSkin(Weapon, Skin, Weapon:ReadSettings())
			Library:Notify("Applied " .. Skin.Name .. " to " .. Weapon.Name .. ".")
			self:ShowView("Main")
		end

		function SkinChanger:SetSkin(Weapon, Skin, Settings, Pinned)
			if type(Weapon) == "string" then Weapon = self.Weapons[Weapon] end
			if not Weapon then return end
			if type(Skin) == "string" then Skin = Weapon:GetSkin(Skin) end
			local Entry = self.Saved[Weapon.Name]
			if not Entry then
				Entry = { Weapon = Weapon, Pinned = false }
				self.Saved[Weapon.Name] = Entry
				local Card = SkinCard(self.Parts.MainGrid, { Title = Weapon.Name, Image = Weapon.Icon })
				Entry.Card = Card
				local Trash = CornerIcon(Card, "Trash", UDim2.fromOffset(2, 2), Vector2.new(0, 0))
				local Pin, PinImage = CornerIcon(Card, "Lock", UDim2.new(1, -2, 0, 2), Vector2.new(1, 0))
				Entry.PinImage, Entry.PinButton = PinImage, Pin
				Connect(Trash.MouseButton1Click, function() self:RemoveSkin(Weapon.Name) end)
				Connect(Pin.MouseButton1Click, function()
					Entry.Pinned = not Entry.Pinned
					self:_DrawEntry(Entry)
				end)
				Connect(Card.Card.MouseButton1Click, function() self:OpenWeapon(Weapon, true) end)
			end
			Entry.Skin, Entry.Settings = Skin or Weapon.Skins[1], Settings or {}
			if Pinned ~= nil then Entry.Pinned = Pinned end
			self:_DrawEntry(Entry)
			if self.View == "Main" then self:ShowView("Main", true) end
			self:_Fire("Changed", Entry)
			return Entry
		end

		function SkinChanger:_DrawEntry(Entry)
			local Card, Skin = Entry.Card, Entry.Skin
			local Image, Color = SkinImage(Entry.Weapon, Skin)
			SetIcon(Card.Image, Image)
			Card.Image.ImageColor3 = Color
			Library:SetText(Card.Subtitle, Skin.Name)
			Card:SetRarity(Skin.Rarity or "Default")
			Card.Card.LayoutOrder = Entry.Pinned and -100 or 0
			Entry.PinButton:SetAttribute("On", Entry.Pinned)
			ThemeTween(Entry.PinImage, "ImageColor3", Entry.Pinned and "Accent" or "Inactive Text", 0.15)
			Tween(Entry.PinImage, { ImageTransparency = Entry.Pinned and 0 or 0.5 }, 0.15)
		end

		function SkinChanger:RemoveSkin(Name)
			local Entry = self.Saved[Name]
			if not Entry then return end
			self.Saved[Name] = nil
			Entry.Card.Card:Destroy()
			if self.View == "Main" then self:ShowView("Main", true) end
			self:_Fire("Removed", Entry)
		end

		function SkinChanger:ClearSkins()
			for Name in table.clone(self.Saved) do self:RemoveSkin(Name) end
		end

		function SkinChanger:GetSkin(Name)
			return self.Saved[Name]
		end

		function SkinChanger:GetAllWeapons()
			local Out = {}
			for _, Category in self.Categories do
				for _, Weapon in Category.Weapons do table.insert(Out, Weapon) end
			end
			return Out
		end

		function SkinChanger:OpenPopup()
			local Parts, Weapon = self.Parts, self.Weapon
			if not Weapon then return end
			for _, Other in self.Weapons do Other.Body.Visible = Other == Weapon end
			Library:SetText(Parts.PopupTitle, "Customize " .. Weapon.Name)
			Parts.Dim.Visible = true
			Parts.Popup.Visible = true
			Tween(Parts.Dim, { BackgroundTransparency = 0.45 }, 0.18)
			Parts.Popup.Position = UDim2.new(0.5, 0, 0.5, 8)
			Tween(Parts.Popup, { GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5) }, 0.2)
		end

		function SkinChanger:ClosePopup()
			local Parts = self.Parts
			Library:CloseAllPopups()
			Tween(Parts.Dim, { BackgroundTransparency = 1 }, 0.15)
			Tween(Parts.Popup, { GroupTransparency = 1 }, 0.15).Completed:Connect(function()
				if Parts.Popup.GroupTransparency > 0.99 then
					Parts.Dim.Visible = false
					Parts.Popup.Visible = false
				end
			end)
		end

		function SkinChanger:OnChanged(Callback)
			table.insert(self.Callbacks, Callback)
		end

		function SkinChanger:_Fire(Action, Entry)
			for _, Callback in self.Callbacks do SafeCall(Callback, Action, Entry) end
		end
	end

	do
		local Preview = {}
		Preview.__index = Preview
		Library.Classes.Preview = Preview

		local function DummyCharacter()
			local Model = Instance.new("Model")
			Model.Name = "Dummy"
			local function Part(Name, Size, CF, Color)
				local P = Instance.new("Part")
				P.Name, P.Size, P.CFrame, P.Color = Name, Size, CF, Color
				P.Anchored, P.CanCollide = true, false
				P.TopSurface, P.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
				P.Parent = Model
				return P
			end
			local Skin, Shirt, Pants = Rgb(234, 184, 146), Rgb(52, 92, 156), Rgb(40, 44, 52)
			local Root = Part("HumanoidRootPart", Vector3.new(2, 2, 1), CFrame.new(0, 3, 0), Shirt)
			Root.Transparency = 1
			Part("Torso", Vector3.new(2, 2, 1), CFrame.new(0, 3, 0), Shirt)
			local Head = Part("Head", Vector3.new(1.2, 1.2, 1.2), CFrame.new(0, 4.6, 0), Skin)
			local Mesh = Instance.new("SpecialMesh")
			Mesh.MeshType = Enum.MeshType.Head
			Mesh.Scale = Vector3.new(1.25, 1.25, 1.25)
			Mesh.Parent = Head
			Part("Left Arm", Vector3.new(1, 2, 1), CFrame.new(-1.5, 3, 0), Skin)
			Part("Right Arm", Vector3.new(1, 2, 1), CFrame.new(1.5, 3, 0), Skin)
			Part("Left Leg", Vector3.new(1, 2, 1), CFrame.new(-0.5, 1, 0), Pants)
			Part("Right Leg", Vector3.new(1, 2, 1), CFrame.new(0.5, 1, 0), Pants)
			Model.PrimaryPart = Root
			return Model
		end

		local function CloneCharacter()
			local Character = LocalPlayer and LocalPlayer.Character
			if not Character then return nil end
			local Old = Character.Archivable
			Character.Archivable = true
			local Ok, Clone = pcall(Character.Clone, Character)
			Character.Archivable = Old
			if not Ok or not Clone then return nil end
			for _, Child in Clone:GetDescendants() do
				if Child:IsA("LuaSourceContainer") or Child:IsA("Sound") or Child:IsA("ForceField") then
					Child:Destroy()
				elseif Child:IsA("BasePart") then
					Child.Anchored = true
				end
			end
			local Humanoid = Clone:FindFirstChildOfClass("Humanoid")
			if Humanoid then Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
			return Clone
		end

		local PREVIEW_ZOOM = 1.8
		local PreviewWhite, PreviewBlack = Color3.new(1, 1, 1), Color3.new(0, 0, 0)
		local R15Bones = {
			{ "Head", "UpperTorso" }, { "UpperTorso", "LowerTorso" },
			{ "UpperTorso", "LeftUpperArm" }, { "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" },
			{ "UpperTorso", "RightUpperArm" }, { "RightUpperArm", "RightLowerArm" }, { "RightLowerArm", "RightHand" },
			{ "LowerTorso", "LeftUpperLeg" }, { "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" },
			{ "LowerTorso", "RightUpperLeg" }, { "RightUpperLeg", "RightLowerLeg" }, { "RightLowerLeg", "RightFoot" },
		}
		local R6Bones = { { "Head", "Torso" }, { "Torso", "Left Arm" }, { "Torso", "Right Arm" }, { "Torso", "Left Leg" }, { "Torso", "Right Leg" } }

		local function PreviewNumber(State, Key, Default, Minimum, Maximum)
			local Value = tonumber(State[Key])
			if not Value or Value ~= Value or math.abs(Value) == math.huge then Value = Default end
			return math.clamp(Value, Minimum, Maximum)
		end

		local function PreviewAlpha(State, Key)
			return PreviewNumber(State, Key, 0, 0, 1)
		end

		local function PreviewGradient(Object, Enabled, First, Last, Rotation, FirstTransparency, LastTransparency)
			Object.Enabled = Enabled == true
			Object.Color = ColorSequence.new(First or PreviewWhite, Last or PreviewWhite)
			Object.Transparency = NumberSequence.new(FirstTransparency or 0, LastTransparency or 0)
			Object.Rotation = Rotation or 0
		end

		local function PreviewProject(Camera, Size, Position)
			local Point = Camera.CFrame:PointToObjectSpace(Position)
			local Depth = -Point.Z
			if Depth <= 0.05 then return nil end
			local Scale = Size.Y * 0.5 / math.tan(math.rad(Camera.FieldOfView * 0.5))
			return Vector2.new(Size.X * 0.5 + Point.X * Scale / Depth, Size.Y * 0.5 - Point.Y * Scale / Depth)
		end

		local function PreviewLine(Object, First, Last, Thickness)
			local Delta = Last - First
			Object.AnchorPoint = Vector2.new(0.5, 0.5)
			Object.Position = UDim2.fromOffset((First.X + Last.X) * 0.5, (First.Y + Last.Y) * 0.5)
			Object.Size = UDim2.fromOffset(Delta.Magnitude, Thickness)
			Object.Rotation = math.deg(math.atan2(Delta.Y, Delta.X))
			Object.Visible = true
		end

		local function PreviewChamsModel(Model, Parent)
			local Okay, Clone = pcall(Model.Clone, Model)
			if not Okay or not Clone then return nil, {} end
			local Parts = {}
			for _, Object in Clone:GetDescendants() do
				if Object:IsA("BasePart") then
					Object.Material = Enum.Material.Neon
					if Object:IsA("MeshPart") then Object.TextureID = "" end
					table.insert(Parts, { Object, Object.Transparency })
				elseif Object:IsA("SpecialMesh") then
					Object.TextureId = ""
				elseif Object:IsA("Decal") or Object:IsA("Texture") or Object:IsA("SurfaceAppearance") or Object:IsA("Clothing") or Object:IsA("ShirtGraphic") then
					Object:Destroy()
				end
			end
			Clone.Parent = Parent
			return Clone, Parts
		end

		function Window:AddPreview(Config)
			Config = Config or {}
			local Window_ = self
			local Self = setmetatable({
				Window = self,
				Tab = Config.Tab,
				State = {
					Box = true, BoxStyle = "Corner", BoxColor = PreviewWhite, BoxThickness = 1, CornerLength = 0.25,
					Fill = false, FillColor = Theme.Accent, FillTransparency = 0.7, Name = true, NameColor = PreviewWhite,
					HealthBar = true, Health = 0.82, HealthWidth = 4, Distance = true, Weapon = true,
					ArmorValue = 0.65, Ammo = 18, AmmoCapacity = 30, WeaponName = "AK-47", Chams = false,
					ChamsColor = Theme.Accent, ChamsOpacity = 0.35, TextSize = 11, Font = "Pixel",
				},
				Angle = 0.6,
				Visible = true,
			}, Preview)
			Library.Preview = Self
			self.PreviewOffset = Vector2.new(10, 0)

			local PanelFrame = Create("CanvasGroup", { Name = "Preview", Size = UDim2.fromOffset(Config.Width or 220, self.Holder.Size.Y.Offset), Theme = { BackgroundColor3 = "Background" }, Parent = Library.MenuGui })
			Layout.Register(self.LayoutKey .. "/Preview", function()
				local Viewport = Layout.Viewport(PanelFrame)
				return Viewport and { Kind = "Offset", X = Window_.PreviewOffset.X / Viewport.X, Y = Window_.PreviewOffset.Y / Viewport.Y }
			end, function(Value)
				local Viewport = Layout.Viewport(PanelFrame)
				if Value.Kind == "Offset" and Viewport then Window_.PreviewOffset = Vector2.new(Value.X * Viewport.X, Value.Y * Viewport.Y) end
			end)
			Corner(PanelFrame, 8)
			local PanelOutline = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 50, Parent = PanelFrame })
			Corner(PanelOutline, 8)
			Stroke(PanelOutline, "Outline")
			local Header = Create("Frame", { Size = UDim2.new(1, 0, 0, 40), Theme = { BackgroundColor3 = "Inline" }, Active = true, Parent = PanelFrame })
			Create("Frame", { Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1), Theme = { BackgroundColor3 = "Outline" }, Parent = Header })
			local HeaderIcon = Create("ImageLabel", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0), Size = UDim2.fromOffset(15, 15), Theme = { ImageColor3 = "Inactive Text" }, Parent = Header })
			SetIcon(HeaderIcon, "Eye")
			Create("TextLabel", { Position = UDim2.fromOffset(36, 0), Size = UDim2.new(1, -40, 1, 0), Text = Config.Title or "ESP Preview", TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Header })

			local Stage = Create("Frame", { Position = UDim2.fromOffset(10, 50), Size = UDim2.new(1, -20, 1, -60), Theme = { BackgroundColor3 = "Tab" }, Active = true, ClipsDescendants = true, Parent = PanelFrame })
			Corner(Stage, 6)
			Stroke(Stage, "Outline")
			local function ModelViewport(ZIndex)
				local Frame = Create("ViewportFrame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Ambient = Rgb(170, 170, 170), LightColor = PreviewWhite, LightDirection = Vector3.new(-1, -1, -1), ZIndex = ZIndex, Parent = Stage })
				local ModelWorld = Instance.new("WorldModel")
				ModelWorld.Parent = Frame
				return Frame, ModelWorld
			end
			local ChamsOutlineViewport, ChamsOutlineWorld = ModelViewport(1)
			ChamsOutlineViewport.Position = UDim2.fromOffset(-1.5, -1.5)
			ChamsOutlineViewport.Size = UDim2.new(1, 3, 1, 3)
			local Viewport, World = ModelViewport(2)
			local ChamsViewport, ChamsWorld = ModelViewport(3)
			local Camera = Instance.new("Camera")
			Camera.FieldOfView = 40
			Camera.Parent = Viewport
			Viewport.CurrentCamera, ChamsViewport.CurrentCamera, ChamsOutlineViewport.CurrentCamera = Camera, Camera, Camera
			Create("TextLabel", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -6), Size = UDim2.new(1, 0, 0, 12), Text = "drag to rotate", TextSize = 10, Theme = { TextColor3 = "Inactive Text" }, ZIndex = 8, Parent = Stage })

			local Overlay = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 4, Parent = Stage })
			local BoxFrame = Create("Frame", { BackgroundTransparency = 1, ZIndex = 5, Parent = Overlay })
			local Glow = Create("ImageLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://5028857084", ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(24, 24, 276, 276), ZIndex = 4, Parent = BoxFrame })
			local GlowGradient = Create("UIGradient", { Parent = Glow })
			local FillFrame = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 5, Parent = BoxFrame })
			local FillGradient = Create("UIGradient", { Parent = FillFrame })
			local OutlineFrame = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 6, Parent = BoxFrame })
			local FullOutline = Create("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = PreviewBlack, Parent = OutlineFrame })
			local BorderFrame = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 7, Parent = BoxFrame })
			local FullStroke = Create("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Thickness = 1, Parent = BorderFrame })
			local StrokeGradient = Create("UIGradient", { Parent = FullStroke })
			local Corners, CornerOutlines, CornerGradients = {}, {}, {}
			for Index = 1, 8 do
				Corners[Index] = Create("Frame", { AnchorPoint = Vector2.new(0, 0.5), ZIndex = 7, Parent = BoxFrame })
				CornerOutlines[Index] = Create("Frame", { AnchorPoint = Vector2.new(0, 0.5), ZIndex = 6, Parent = BoxFrame })
				CornerGradients[Index] = Create("UIGradient", { Parent = Corners[Index] })
			end
			local function Bar(Anchor, Position)
				local Back = Create("Frame", { AnchorPoint = Anchor, Position = Position, BackgroundColor3 = PreviewBlack, BackgroundTransparency = 0.3, ZIndex = 7, Parent = BoxFrame })
				local Fill = Create("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), BackgroundColor3 = PreviewWhite, ZIndex = 8, Parent = Back })
				return Back, Fill
			end
			local HealthBack, HealthFill = Bar(Vector2.new(1, 0), UDim2.new(0, -4, 0, 0))
			local HealthGradient = Create("UIGradient", { Rotation = 90, Parent = HealthFill })
			local ArmorBack, ArmorFill = Bar(Vector2.new(0, 0), UDim2.new(1, 4, 0, 0))
			local AmmoBack, AmmoFill = Bar(Vector2.new(0, 0), UDim2.new(0, 0, 1, 2))
			local function OverlayText(Anchor, Position, Text)
				local Label = Create("TextLabel", { AnchorPoint = Anchor, Position = Position, Size = UDim2.fromOffset(160, 14), Text = Text, NoCase = true, TextSize = 11, TextColor3 = PreviewWhite, ZIndex = 9, Parent = BoxFrame })
				Fonts.Registry[Label] = nil
				return Label
			end
			local NameLabel = OverlayText(Vector2.new(0.5, 1), UDim2.new(0.5, 0, 0, -3), LocalPlayer and LocalPlayer.DisplayName or "Player")
			local DistanceLabel = OverlayText(Vector2.new(0.5, 0), UDim2.new(0.5, 0, 1, 3), "24st")
			local WeaponLabel = OverlayText(Vector2.new(0.5, 0), UDim2.new(0.5, 0, 1, 16), "")
			local HealthText = OverlayText(Vector2.new(1, 0.5), UDim2.new(0, -10, 0.18, 0), "82")
			local AmmoText = OverlayText(Vector2.new(0, 1), UDim2.new(1, 8, 1, 0), "18")
			AmmoText.TextXAlignment = Enum.TextXAlignment.Left
			local FlagsLabel = OverlayText(Vector2.new(0, 0), UDim2.new(1, 8, 0, 0), "KIT\nBOMB\nZOOM")
			FlagsLabel.TextXAlignment, FlagsLabel.TextYAlignment = Enum.TextXAlignment.Left, Enum.TextYAlignment.Top
			local Icon = Create("ImageLabel", { AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit, ZIndex = 9, Parent = BoxFrame })
			local Head = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = 8, Parent = Overlay })
			Corner(Head, 100)
			local SkeletonLines, SkeletonOutlines = {}, {}
			for Index = 1, #R15Bones do
				SkeletonLines[Index] = Create("Frame", { AnchorPoint = Vector2.new(0, 0.5), ZIndex = 8, Parent = Overlay })
				SkeletonOutlines[Index] = Create("Frame", { AnchorPoint = Vector2.new(0, 0.5), ZIndex = 7, Parent = Overlay })
			end

			Self.Parts = {
				Panel = PanelFrame, Stage = Stage, Viewport = Viewport, Camera = Camera, World = World, Overlay = Overlay, Box = BoxFrame,
				Fill = FillFrame, FillGradient = FillGradient, FullStroke = FullStroke, FullOutline = FullOutline, StrokeGradient = StrokeGradient,
				Corners = Corners, CornerOutlines = CornerOutlines, CornerGradients = CornerGradients, Glow = Glow, GlowGradient = GlowGradient,
				HealthBack = HealthBack, HealthFill = HealthFill, HealthGradient = HealthGradient, HealthText = HealthText, ArmorBack = ArmorBack, ArmorFill = ArmorFill,
				AmmoBack = AmmoBack, AmmoFill = AmmoFill, AmmoText = AmmoText, Name = NameLabel, Distance = DistanceLabel, Weapon = WeaponLabel,
				Flags = FlagsLabel, Icon = Icon, Head = Head, SkeletonLines = SkeletonLines, SkeletonOutlines = SkeletonOutlines,
				ChamsViewport = ChamsViewport, ChamsWorld = ChamsWorld, ChamsOutlineViewport = ChamsOutlineViewport, ChamsOutlineWorld = ChamsOutlineWorld,
			}
			Self.Labels = { { NameLabel, "Name" }, { DistanceLabel, "Distance" }, { WeaponLabel, "Weapon" }, { FlagsLabel, "Flags" }, { HealthText, "HealthText" }, { AmmoText, "Ammo" } }

			function Self:LoadModel()
				if Library.Unloaded or not World.Parent or not PanelFrame.Parent then return end
				if self.Model then self.Model:Destroy() end
				if self.ChamsModel then self.ChamsModel:Destroy() end
				if self.ChamsOutlineModel then self.ChamsOutlineModel:Destroy() end
				local Model = CloneCharacter() or DummyCharacter()
				Model.Parent = World
				self.Model = Model
				self.OriginalColors, self.ModelParts, self.Bones = {}, {}, {}
				for _, Part in Model:GetDescendants() do
					if Part:IsA("BasePart") then
						self.OriginalColors[Part] = { Part.Color, Part.Material, Part.Transparency }
						if Part.Transparency < 1 and Part.Name ~= "HumanoidRootPart" and Part.Name ~= "CollisionBox" then table.insert(self.ModelParts, Part) end
					end
				end
				self.Head = Model:FindFirstChild("Head", true)
				if self.Head and not self.Head:IsA("BasePart") then self.Head = nil end
				for _, Pair in Model:FindFirstChild("UpperTorso", true) and R15Bones or R6Bones do
					local First, Last = Model:FindFirstChild(Pair[1], true), Model:FindFirstChild(Pair[2], true)
					if First and Last and First:IsA("BasePart") and Last:IsA("BasePart") then table.insert(self.Bones, { First, Last }) end
				end
				local CF, Size = Model:GetBoundingBox()
				self.ModelCenter, self.ModelSize = CF.Position, Size
				self.ChamsModel, self.ChamsParts = PreviewChamsModel(Model, ChamsWorld)
				self.ChamsOutlineModel, self.ChamsOutlineParts = PreviewChamsModel(Model, ChamsOutlineWorld)
				self:Update()
			end

			local Dragging, DragStart, PanelStart
			Connect(Header.InputBegan, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging, DragStart, PanelStart = true, MousePosition(), Window_.PreviewOffset
				end
			end)
			Connect(UserInputService.InputChanged, function(Input)
				if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
					Window_.PreviewOffset = PanelStart + (MousePosition() - DragStart)
				end
			end)
			Connect(UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if Dragging then Library:SaveLayout() end
					Dragging = false
				end
			end)
			local Rotating, RotateStart, AngleStart
			Connect(Stage.InputBegan, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then Rotating, RotateStart, AngleStart = true, MousePosition().X, Self.Angle end
			end)
			Connect(UserInputService.InputChanged, function(Input)
				if Rotating and Input.UserInputType == Enum.UserInputType.MouseMovement then Self.Angle = AngleStart + (MousePosition().X - RotateStart) * 0.012 end
			end)
			Connect(UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then Rotating = false end
			end)

			Connect(RunService.RenderStepped, function(Delta)
				if Library.Unloaded or not PanelFrame.Parent or not World.Parent then return end
				local Holder = Window_.Holder
				local Shown = Window_.Open and (not Self.Tab or Self.Tab.Active) and Self.Visible
				if Shown ~= Self._Shown then
					Self._Shown = Shown
					if Shown then PanelFrame.Visible = true end
					Tween(PanelFrame, { GroupTransparency = Shown and 0 or 1 }, 0.16).Completed:Connect(function()
						if not Self._Shown then PanelFrame.Visible = false end
					end)
				end
				if not PanelFrame.Visible then return end
				local MenuPosition = Holder.AbsolutePosition - Library.MenuGui.AbsolutePosition
				local Offset = Window_.PreviewOffset
				PanelFrame.Position = UDim2.fromOffset(MenuPosition.X + Holder.AbsoluteSize.X + Offset.X, MenuPosition.Y + Offset.Y)
				local Position = Layout.ReadPosition(PanelFrame)
				if Position then
					Layout.SetPosition(PanelFrame, Position)
					local Viewport = Layout.Viewport(PanelFrame)
					Window_.PreviewOffset = Vector2.new(PanelFrame.Position.X.Scale * Viewport.X - MenuPosition.X - Holder.AbsoluteSize.X, PanelFrame.Position.Y.Scale * Viewport.Y - MenuPosition.Y)
				end
				if not Rotating and Self.State.AutoRotate ~= false then Self.Angle += Delta * 0.5 end
				if not Shown or not Self:RefreshState() then Self:Render() end
			end)

			task.defer(function() Self:LoadModel() end)
			if LocalPlayer then
				Connect(LocalPlayer.CharacterAdded, function(Character)
					task.wait(1)
					if Library.Unloaded or LocalPlayer.Character ~= Character then return end
					Self:LoadModel()
				end)
			end
			return Self
		end

		function Preview:SetStateProvider(Callback)
			self.StateProvider = type(Callback) == "function" and Callback or nil
			return self
		end

		function Preview:RefreshState()
			if not self.StateProvider then return false end
			local Okay, Values = pcall(self.StateProvider)
			if not Okay or type(Values) ~= "table" then return false end
			for Key, Value in Values do
				if self.State[Key] ~= Value then
					self:Update(Values)
					return true
				end
			end
			return false
		end

		function Preview:Update(State)
			if State then for Key, Value in State do self.State[Key] = Value end end
			local S, P = self.State, self.Parts
			local CornerStyle = S.BoxStyle == "Corner"
			local BoxGradient, FillGradient, GlowGradient = S.BoxGradient == true, S.FillGradient == true, S.GlowGradient == true
			P.FullStroke.Enabled = S.Box == true and not CornerStyle
			P.FullStroke.Color = BoxGradient and PreviewWhite or S.BoxColor or PreviewWhite
			P.FullStroke.Thickness = PreviewNumber(S, "BoxThickness", 1, 1, 10)
			P.FullStroke.Transparency = BoxGradient and 0 or PreviewAlpha(S, "BoxTransparency")
			P.FullOutline.Enabled = P.FullStroke.Enabled and S.BoxOutline == true
			P.FullOutline.Color = S.BoxOutlineColor or PreviewBlack
			P.FullOutline.Thickness = PreviewNumber(S, "BoxOutlineThickness", 3, 1, 12)
			P.FullOutline.Transparency = PreviewAlpha(S, "BoxOutlineTransparency")
			PreviewGradient(P.StrokeGradient, BoxGradient, S.BoxGradientStart, S.BoxGradientEnd, S.BoxGradientRotation, PreviewAlpha(S, "BoxGradientStartTransparency"), PreviewAlpha(S, "BoxGradientEndTransparency"))
			for Index, Line in P.Corners do
				Line.Visible = S.Box == true and CornerStyle
				Line.BackgroundColor3 = P.FullStroke.Color
				Line.BackgroundTransparency = P.FullStroke.Transparency
				local Outline = P.CornerOutlines[Index]
				Outline.Visible = Line.Visible and S.BoxOutline == true
				Outline.BackgroundColor3 = S.BoxOutlineColor or PreviewBlack
				Outline.BackgroundTransparency = PreviewAlpha(S, "BoxOutlineTransparency")
				PreviewGradient(P.CornerGradients[Index], BoxGradient, S.BoxGradientStart, S.BoxGradientEnd, S.BoxGradientRotation, PreviewAlpha(S, "BoxGradientStartTransparency"), PreviewAlpha(S, "BoxGradientEndTransparency"))
			end
			P.Fill.Visible = S.Box == true and S.Fill == true
			P.Fill.BackgroundTransparency = FillGradient and 0 or PreviewAlpha(S, "FillTransparency")
			P.Fill.BackgroundColor3 = FillGradient and PreviewWhite or S.FillColor or Theme.Accent
			PreviewGradient(P.FillGradient, FillGradient, S.FillGradientStart, S.FillGradientEnd, S.FillGradientRotation, PreviewAlpha(S, "FillGradientStartTransparency"), PreviewAlpha(S, "FillGradientEndTransparency"))
			P.Glow.Visible = S.Box == true and S.Glow == true
			P.Glow.ImageColor3 = GlowGradient and PreviewWhite or S.GlowColor or PreviewWhite
			P.Glow.ImageTransparency = 1 - (GlowGradient and 1 or 1 - PreviewAlpha(S, "GlowTransparency")) * PreviewNumber(S, "GlowOpacity", 0.2, 0, 1)
			local GlowSize = PreviewNumber(S, "GlowSize", 45, 0, 200)
			P.Glow.Size = UDim2.new(1, GlowSize, 1, GlowSize)
			PreviewGradient(P.GlowGradient, GlowGradient, S.GlowGradientStart, S.GlowGradientEnd, S.GlowGradientRotation, PreviewAlpha(S, "GlowGradientStartTransparency"), PreviewAlpha(S, "GlowGradientEndTransparency"))

			local Health = PreviewNumber(S, "Health", 0.82, 0, 1)
			local HealthColor = S.HealthColor or Rgb(96, 220, 120)
			local HealthTransparency = PreviewAlpha(S, "HealthTransparency")
			P.HealthGradient.Enabled = S.HealthGradient == true
			if P.HealthGradient.Enabled then
				local Low, Mid, High = S.HealthLow or Rgb(240, 84, 84), S.HealthMid or Rgb(242, 188, 72), S.HealthHigh or Rgb(96, 220, 120)
				local LowTransparency, MidTransparency, HighTransparency = PreviewAlpha(S, "HealthLowTransparency"), PreviewAlpha(S, "HealthMidTransparency"), PreviewAlpha(S, "HealthHighTransparency")
				P.HealthGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, High), ColorSequenceKeypoint.new(0.5, Mid), ColorSequenceKeypoint.new(1, Low) })
				P.HealthGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, HighTransparency), NumberSequenceKeypoint.new(0.5, MidTransparency), NumberSequenceKeypoint.new(1, LowTransparency) })
				HealthColor = Health < 0.5 and Low:Lerp(Mid, Health * 2) or Mid:Lerp(High, Health * 2 - 1)
				HealthTransparency = Health < 0.5 and LowTransparency + (MidTransparency - LowTransparency) * Health * 2 or MidTransparency + (HighTransparency - MidTransparency) * (Health * 2 - 1)
			end
			P.HealthBack.Visible = S.HealthBar == true
			P.HealthBack.Size = UDim2.new(0, PreviewNumber(S, "HealthWidth", 4, 1, 20), 1, 0)
			P.HealthFill.Size = UDim2.fromScale(1, Health)
			P.HealthFill.BackgroundColor3 = P.HealthGradient.Enabled and PreviewWhite or HealthColor
			P.HealthFill.BackgroundTransparency = P.HealthGradient.Enabled and 0 or HealthTransparency
			P.HealthText.Visible = P.HealthBack.Visible and S.HealthText == true
			P.HealthText.Text = tostring(math.floor(Health * 100 + 0.5))
			P.HealthText.Position = UDim2.new(0, -PreviewNumber(S, "HealthWidth", 4, 1, 20) - 6, 1 - Health, 0)
			P.ArmorBack.Visible = S.Armor == true
			P.ArmorBack.Size = UDim2.new(0, PreviewNumber(S, "ArmorWidth", 4, 1, 20), 1, 0)
			P.ArmorFill.Size = UDim2.fromScale(1, PreviewNumber(S, "ArmorValue", 0.65, 0, 1))
			P.ArmorFill.BackgroundColor3 = S.ArmorColor or Rgb(90, 150, 255)
			P.ArmorFill.BackgroundTransparency = PreviewAlpha(S, "ArmorTransparency")
			P.AmmoBack.Visible = S.AmmoBar == true
			P.AmmoBack.Size = UDim2.new(1, 0, 0, PreviewNumber(S, "AmmoBarHeight", 4, 1, 20))
			local Capacity = PreviewNumber(S, "AmmoCapacity", 30, 1, 1000)
			local Ammo = PreviewNumber(S, "Ammo", 18, 0, Capacity)
			P.AmmoFill.Size = UDim2.fromScale(Ammo / Capacity, 1)
			P.AmmoFill.BackgroundColor3 = S.AmmoColor or PreviewWhite
			P.AmmoFill.BackgroundTransparency = PreviewAlpha(S, "AmmoTransparency")
			P.AmmoText.Visible = S.AmmoText == true
			P.AmmoText.Text = tostring(math.floor(Ammo))
			P.AmmoText.Position = UDim2.new(1, S.Armor and PreviewNumber(S, "ArmorWidth", 4, 1, 20) + 8 or 4, 1, 0)

			P.Name.Visible = S.Name == true
			P.Name.Text = S.NameText or (LocalPlayer and LocalPlayer.DisplayName or "Player")
			P.Distance.Visible = S.Distance == true
			P.Distance.Text = S.DistanceText or "24st"
			P.Weapon.Visible = S.Weapon == true
			P.Weapon.Text = S.WeaponName or ""
			P.Flags.Visible = S.Flags == true and tostring(S.FlagsText or "") ~= ""
			P.Flags.Text = S.FlagsText or ""
			P.Flags.Position = UDim2.new(1, S.Armor and PreviewNumber(S, "ArmorWidth", 4, 1, 20) + 8 or 4, 0, 0)
			P.Icon.Visible = S.Icon == true and tostring(S.IconImage or "") ~= ""
			local Image = tostring(S.IconImage or "")
			P.Icon.Image = Image:match("^%d+$") and "rbxassetid://" .. Image or Image
			P.Icon.ImageColor3 = S.IconColor or PreviewWhite
			P.Icon.ImageTransparency = PreviewAlpha(S, "IconTransparency")
			P.Icon.Size = UDim2.new(1, 10, 0, PreviewNumber(S, "IconSize", 20, 1, 100))
			P.Head.BackgroundColor3 = S.HeadDotColor or PreviewWhite
			P.Head.BackgroundTransparency = PreviewAlpha(S, "HeadDotTransparency")
			local HeadSize = PreviewNumber(S, "HeadDotSize", 5, 1, 50)
			P.Head.Size = UDim2.fromOffset(HeadSize, HeadSize)

			local TextSize = PreviewNumber(S, "TextSize", 11, 6, 40)
			local TextHeight = TextSize + 4
			local Bottom = P.AmmoBack.Visible and PreviewNumber(S, "AmmoBarHeight", 4, 1, 20) + 5 or 3
			P.Distance.Position = UDim2.new(0.5, 0, 1, Bottom)
			if P.Distance.Visible then Bottom += TextHeight end
			P.Weapon.Position = UDim2.new(0.5, 0, 1, Bottom)
			if P.Weapon.Visible then Bottom += TextHeight end
			P.Icon.Position = UDim2.new(0.5, 0, 1, Bottom)
			local TextFont = Fonts:ESPFace(S.Font or "Pixel")
			for _, Entry in self.Labels do
				local Label, Key = Entry[1], Entry[2]
				Label.FontFace = TextFont
				Label.TextSize = TextSize
				Label.Size = UDim2.fromOffset(160, Key == "Flags" and TextHeight * (select(2, Label.Text:gsub("\n", "")) + 1) or TextHeight)
				Label.TextColor3 = Key == "HealthText" and S.HealthTextColorMode ~= "Custom" and HealthColor or S[Key .. "Color"] or PreviewWhite
				Label.TextTransparency = Key == "HealthText" and S.HealthTextColorMode ~= "Custom" and HealthTransparency or PreviewAlpha(S, Key .. "Transparency")
				Label.TextStrokeColor3 = S.TextOutlineColor or PreviewBlack
				Label.TextStrokeTransparency = S.TextOutline == true and 1 - (1 - PreviewAlpha(S, "TextOutlineTransparency")) * (1 - Label.TextTransparency) or 1
			end
			for Index, Line in P.SkeletonLines do
				Line.BackgroundColor3 = S.SkeletonColor or PreviewWhite
				Line.BackgroundTransparency = PreviewAlpha(S, "SkeletonTransparency")
				P.SkeletonOutlines[Index].BackgroundColor3 = S.SkeletonOutlineColor or PreviewBlack
				P.SkeletonOutlines[Index].BackgroundTransparency = PreviewAlpha(S, "SkeletonOutlineTransparency")
			end

			local FillOpacity = (1 - PreviewAlpha(S, "ChamsTransparency")) * PreviewNumber(S, "ChamsOpacity", 0.35, 0, 1)
			local OutlineOpacity = 1 - PreviewAlpha(S, "ChamsOutlineTransparency")
			P.ChamsViewport.Visible = S.Chams == true and FillOpacity > 0 and self.ChamsModel ~= nil
			P.ChamsOutlineViewport.Visible = S.Chams == true and OutlineOpacity > 0 and self.ChamsOutlineModel ~= nil
			for _, Entry in self.ChamsParts or {} do
				Entry[1].Color = S.ChamsColor or Theme.Accent
				Entry[1].Transparency = 1 - (1 - Entry[2]) * FillOpacity
			end
			for _, Entry in self.ChamsOutlineParts or {} do
				Entry[1].Color = S.ChamsOutlineColor or PreviewBlack
				Entry[1].Transparency = 1 - (1 - Entry[2]) * OutlineOpacity
			end
			self:Render()
		end

		function Preview:Render()
			local S, P = self.State, self.Parts
			local Size, Camera = P.Stage.AbsoluteSize, P.Camera
			P.Overlay.Visible = false
			P.Head.Visible = false
			for Index, Line in P.SkeletonLines do Line.Visible, P.SkeletonOutlines[Index].Visible = false, false end
			if not self.ModelCenter or not self.ModelSize or not self.ModelParts or #self.ModelParts == 0 or Size.X < 1 or Size.Y < 1 then return end
			local Width = math.sqrt(self.ModelSize.X * self.ModelSize.X + self.ModelSize.Z * self.ModelSize.Z)
			local Distance = math.max(self.ModelSize.Y, Width * Size.Y / Size.X) / (2 * math.tan(math.rad(Camera.FieldOfView * 0.5))) * PREVIEW_ZOOM
			local Center = self.ModelCenter
			Camera.CFrame = CFrame.new(Center + Vector3.new(math.sin(self.Angle) * Distance, 0, math.cos(self.Angle) * Distance), Center)
			local Low, High = Vector2.new(math.huge, math.huge), Vector2.new(-math.huge, -math.huge)
			for _, Part in self.ModelParts or {} do
				if not Part.Parent then continue end
				for X = -1, 1, 2 do for Y = -1, 1, 2 do for Z = -1, 1, 2 do
					local Point = PreviewProject(Camera, Size, Part.CFrame * Vector3.new(Part.Size.X * X * 0.5, Part.Size.Y * Y * 0.5, Part.Size.Z * Z * 0.5))
					if Point then
						Low = Vector2.new(math.min(Low.X, Point.X), math.min(Low.Y, Point.Y))
						High = Vector2.new(math.max(High.X, Point.X), math.max(High.Y, Point.Y))
					end
				end end end
			end
			if Low.X == math.huge then return end
			local X, Y = math.floor(Low.X), math.floor(Low.Y)
			local BoxWidth, BoxHeight = math.max(2, math.ceil(High.X) - X), math.max(2, math.ceil(High.Y) - Y)
			P.Box.Position, P.Box.Size = UDim2.fromOffset(X, Y), UDim2.fromOffset(BoxWidth, BoxHeight)
			P.Overlay.Visible = true
			local Ratio = PreviewNumber(S, "CornerLength", 0.25, 0.1, 0.5)
			local A, B = BoxWidth * Ratio, BoxHeight * Ratio
			local Segments = {
				{ 0, 0, A, 0 }, { 0, 0, 0, B }, { BoxWidth - A, 0, BoxWidth, 0 }, { BoxWidth, 0, BoxWidth, B },
				{ 0, BoxHeight, A, BoxHeight }, { 0, BoxHeight - B, 0, BoxHeight }, { BoxWidth - A, BoxHeight, BoxWidth, BoxHeight }, { BoxWidth, BoxHeight - B, BoxWidth, BoxHeight },
			}
			for Index, Segment in Segments do
				local First, Last = Vector2.new(Segment[1], Segment[2]), Vector2.new(Segment[3], Segment[4])
				local Line, Outline = P.Corners[Index], P.CornerOutlines[Index]
				PreviewLine(Line, First, Last, PreviewNumber(S, "BoxThickness", 1, 1, 10))
				PreviewLine(Outline, First, Last, PreviewNumber(S, "BoxOutlineThickness", 3, 1, 12))
				Line.Visible = S.Box == true and S.BoxStyle == "Corner"
				Outline.Visible = Line.Visible and S.BoxOutline == true
				P.CornerGradients[Index].Rotation = (S.BoxGradientRotation or 0) - Line.Rotation
			end
			if S.HeadDot == true and self.Head and self.Head.Parent then
				local Point = PreviewProject(Camera, Size, self.Head.Position)
				if Point then P.Head.Position, P.Head.Visible = UDim2.fromOffset(Point.X, Point.Y), true end
			end
			if S.Skeleton ~= true then return end
			for Index, Pair in self.Bones or {} do
				if not Pair[1].Parent or not Pair[2].Parent then continue end
				local First, Last = PreviewProject(Camera, Size, Pair[1].Position), PreviewProject(Camera, Size, Pair[2].Position)
				if First and Last then
					PreviewLine(P.SkeletonLines[Index], First, Last, PreviewNumber(S, "SkeletonThickness", 1, 1, 10))
					if S.SkeletonOutline == true then PreviewLine(P.SkeletonOutlines[Index], First, Last, PreviewNumber(S, "SkeletonOutlineThickness", 3, 1, 12)) end
				end
			end
		end

		function Preview:SetVisible(Visible) self.Visible = Visible end
	end

	do
		local Loader = {}
		Loader.__index = Loader
		Library.Classes.Loader = Loader

		local LoaderStatusColors = { Undetected = Rgb(96, 220, 120), Updating = Rgb(242, 188, 72), Detected = Rgb(240, 84, 84) }

		local function Spinner(Parent, Size)
			local Holder = Create("Frame", { Size = UDim2.fromOffset(Size, Size), BackgroundTransparency = 1, Parent = Parent })
			local TrackFrame = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = Holder })
			Corner(TrackFrame, Size)
			Create("UIStroke", { Thickness = 3, Transparency = 0.6, Theme = { Color = "Outline" }, Parent = TrackFrame })
			local Ring = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = Holder })
			Corner(Ring, Size)
			local RingStroke = Create("UIStroke", { Thickness = 3, Theme = { Color = "Accent" }, Parent = Ring })
			local Gradient = Create("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.6, 0.2), NumberSequenceKeypoint.new(0.75, 1), NumberSequenceKeypoint.new(1, 1) }), Parent = RingStroke })
			local Connection = RunService.RenderStepped:Connect(function(Delta)
				Gradient.Rotation = (Gradient.Rotation + Delta * 360) % 360
			end)
			Holder.Destroying:Connect(function() Connection:Disconnect() end)
			return Holder
		end

		function Library:CreateLoader(Config)
			Config = Config or {}
			local Self = setmetatable({ Games = {}, Selected = nil, Done = false, Callback = Config.Callback }, Loader)
			local Frame = Create("CanvasGroup", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(540, 330), Theme = { BackgroundColor3 = "Background" }, GroupTransparency = 1, Parent = Library.MenuGui })
			Corner(Frame, 10)
			local Scale = Create("UIScale", { Scale = 0.94, Parent = Frame })
			local Outline = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 50, Parent = Frame })
			Corner(Outline, 10)
			Stroke(Outline, "Outline")

			local Side = Create("Frame", { Size = UDim2.new(0, 176, 1, 0), Theme = { BackgroundColor3 = "Inline" }, Parent = Frame })
			Create("Frame", { Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 1, 1, 0), Theme = { BackgroundColor3 = "Outline" }, Parent = Side })
			local Logo = Library:Logo(Side, 26)
			Logo.Position = UDim2.fromOffset(18, 20)
			Create("TextLabel", { Position = UDim2.fromOffset(54, 18), Size = UDim2.new(1, -60, 0, 20), Text = Config.Title or "Swift", TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Side })
			Create("TextLabel", { Position = UDim2.fromOffset(54, 37), Size = UDim2.new(1, -60, 0, 13), Text = Config.Version or ("v" .. Library.Version), NoCase = true, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Inactive Text" }, Parent = Side })
			Create("TextLabel", { Position = UDim2.fromOffset(18, 76), Size = UDim2.new(1, -36, 0, 120), Text = Config.Description or "Pick a game on the right and press Launch. Your settings and configs load automatically.", TextWrapped = true, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, Theme = { TextColor3 = "Inactive Text" }, Parent = Side })
			local UserCard = Create("Frame", { Position = UDim2.new(0, 12, 1, -62), Size = UDim2.new(1, -24, 0, 50), Theme = { BackgroundColor3 = "Tab" }, Parent = Side })
			Corner(UserCard, 6)
			Stroke(UserCard, "Outline")
			local Avatar = Create("ImageLabel", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), Size = UDim2.fromOffset(32, 32), Theme = { BackgroundColor3 = "Element" }, BackgroundTransparency = 0, Parent = UserCard })
			Corner(Avatar, 16)
			local UserName = Create("TextLabel", { Position = UDim2.fromOffset(48, 9), Size = UDim2.new(1, -54, 0, 15), Text = LocalPlayer and LocalPlayer.DisplayName or "User", NoCase = true, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text" }, Parent = UserCard })
			Library:SetPlayerText(UserName, LocalPlayer, LocalPlayer and LocalPlayer.DisplayName or "User")
			Library:SetPlayerAvatar(Avatar, LocalPlayer, "")
			Create("TextLabel", { Position = UDim2.fromOffset(60, 25), Size = UDim2.new(1, -66, 0, 14), Text = "Online", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = LoaderStatusColors.Undetected, Parent = UserCard })
			local Dot = Create("Frame", { Position = UDim2.fromOffset(48, 29), Size = UDim2.fromOffset(7, 7), BackgroundColor3 = LoaderStatusColors.Undetected, Parent = UserCard })
			Corner(Dot, 4)
			local AvatarRequest = {}
			Self.AvatarRequest = AvatarRequest
			if LocalPlayer then task.spawn(function()
				if Library.Unloaded or Self.AvatarRequest ~= AvatarRequest then return end
				local Ok, Image = pcall(Players.GetUserThumbnailAsync, Players, LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
				if Ok and not Library.Unloaded and Avatar.Parent and Self.AvatarRequest == AvatarRequest then Library:SetPlayerAvatar(Avatar, LocalPlayer, Image) end
			end) end

			local Picker = Create("CanvasGroup", { Position = UDim2.fromOffset(177, 0), Size = UDim2.new(1, -177, 1, 0), BackgroundTransparency = 1, Parent = Frame })
			Create("TextLabel", { Position = UDim2.fromOffset(18, 16), Size = UDim2.new(1, -36, 0, 18), Text = "Select a game", TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Text" }, Parent = Picker })
			local Subtitle = Create("TextLabel", { Position = UDim2.fromOffset(18, 35), Size = UDim2.new(1, -36, 0, 14), Text = "", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Inactive Text" }, Parent = Picker })
			local List = Create("ScrollingFrame", { Position = UDim2.fromOffset(14, 58), Size = UDim2.new(1, -24, 1, -112), ScrollBarThickness = 2, Theme = { ScrollBarImageColor3 = "Accent" }, Parent = Picker })
			ListLayout(List, 6)
			Padding(List, 1, 1, 1, 6)
			local LaunchButton = Create("TextButton", { Position = UDim2.new(0, 14, 1, -44), Size = UDim2.new(1, -28, 0, 30), Theme = { BackgroundColor3 = "Element" }, Parent = Picker })
			Corner(LaunchButton, 6)
			Shade(LaunchButton)
			local LaunchStroke = Stroke(LaunchButton, "Outline")
			local LaunchText = Create("TextLabel", { Size = UDim2.fromScale(1, 1), Text = "Select a game", Theme = { TextColor3 = "Inactive Text" }, Parent = LaunchButton })

			local Loading = Create("CanvasGroup", { Position = UDim2.fromOffset(177, 0), Size = UDim2.new(1, -177, 1, 0), BackgroundTransparency = 1, GroupTransparency = 1, Visible = false, Parent = Frame })
			local SpinnerHolder = Spinner(Loading, 44)
			SpinnerHolder.AnchorPoint = Vector2.new(0.5, 0)
			SpinnerHolder.Position = UDim2.new(0.5, 0, 0, 58)
			local LoadingTitle = Create("TextLabel", { Position = UDim2.fromOffset(0, 116), Size = UDim2.new(1, 0, 0, 18), Text = "Launching", TextSize = 15, Theme = { TextColor3 = "Text" }, Parent = Loading })
			local Steps = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 148), Size = UDim2.fromOffset(200, 80), BackgroundTransparency = 1, Parent = Loading })
			ListLayout(Steps, 6)
			local Progress = Create("Frame", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -26), Size = UDim2.new(1, -60, 0, 6), Theme = { BackgroundColor3 = "Element" }, Parent = Loading })
			Corner(Progress, 3)
			Stroke(Progress, "Outline")
			local ProgressFill = Create("Frame", { Size = UDim2.fromScale(0, 1), Theme = { BackgroundColor3 = "Accent" }, Parent = Progress })
			Corner(ProgressFill, 3)

			Self.Parts = { Frame = Frame, Scale = Scale, Picker = Picker, List = List, Subtitle = Subtitle, LaunchButton = LaunchButton, LaunchStroke = LaunchStroke, LaunchText = LaunchText, Loading = Loading, LoadingTitle = LoadingTitle, Steps = Steps, ProgressFill = ProgressFill }

			Connect(LaunchButton.MouseEnter, function() if Self.Selected then ThemeTween(LaunchButton, "BackgroundColor3", "Hovered Element", 0.15) end end)
			Connect(LaunchButton.MouseLeave, function() ThemeTween(LaunchButton, "BackgroundColor3", "Element", 0.15) end)
			Connect(LaunchButton.MouseButton1Click, function() Self:Load() end)

			Tween(Frame, { GroupTransparency = 0 }, 0.35)
			Tween(Scale, { Scale = 1 }, 0.35, Enum.EasingStyle.Back)
			for _, Game in Config.Games or {} do Self:AddGame(Game) end
			Self:_UpdateSubtitle()
			return Self
		end

		function Loader:_UpdateSubtitle()
			self.Parts.Subtitle.Text = #self.Games .. (#self.Games == 1 and " game available" or " games available")
		end

		function Loader:AddGame(Config)
			Config = Config or {}
			local Row = Create("TextButton", { Size = UDim2.new(1, 0, 0, 54), Theme = { BackgroundColor3 = "Tab" }, LayoutOrder = #self.Games + 1, Parent = self.Parts.List })
			Corner(Row, 6)
			local RowStroke = Stroke(Row, "Outline")
			local Icon = Create("ImageLabel", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 9, 0.5, 0), Size = UDim2.fromOffset(36, 36), ScaleType = Enum.ScaleType.Crop, Theme = { BackgroundColor3 = "Element" }, BackgroundTransparency = 0, Parent = Row })
			Corner(Icon, 6)
			if Config.PlaceId then
				Icon.Image = "rbxthumb://type=GameIcon&id=" .. Config.PlaceId .. "&w=150&h=150"
			elseif Config.Icon then
				local Glyph = Create("ImageLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(20, 20), Theme = { ImageColor3 = "Accent" }, Parent = Icon })
				SetIcon(Glyph, Config.Icon)
			end
			Create("TextLabel", { Position = UDim2.fromOffset(55, 10), Size = UDim2.new(1, -150, 0, 16), Text = Config.Name or Config.Text or "Game", NoCase = true, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Text" }, Parent = Row })
			Create("TextLabel", { Position = UDim2.fromOffset(55, 28), Size = UDim2.new(1, -150, 0, 14), Text = Config.Description or "", NoCase = true, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Theme = { TextColor3 = "Inactive Text" }, Parent = Row })
			local Status = Config.Status or "Undetected"
			local Color = LoaderStatusColors[Status] or Theme.Accent
			local Pill = Create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X, Theme = { BackgroundColor3 = "Element" }, Parent = Row })
			Corner(Pill, 10)
			Padding(Pill, 0, 0, 8, 8)
			ListLayout(Pill, 5, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
			local PillDot = Create("Frame", { Size = UDim2.fromOffset(6, 6), BackgroundColor3 = Color, Parent = Pill })
			Corner(PillDot, 3)
			Create("TextLabel", { Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X, Text = Status, TextSize = 10, TextColor3 = Color, LayoutOrder = 2, Parent = Pill })
			local Game = { Config = Config, Row = Row, Stroke = RowStroke }
			Connect(Row.MouseEnter, function() if self.Selected ~= Game then ThemeTween(Row, "BackgroundColor3", "Hovered Element", 0.15) end end)
			Connect(Row.MouseLeave, function() if self.Selected ~= Game then ThemeTween(Row, "BackgroundColor3", "Tab", 0.15) end end)
			Connect(Row.MouseButton1Click, function() self:Select(Game) end)
			table.insert(self.Games, Game)
			self:_UpdateSubtitle()
			if Config.PlaceId and Config.PlaceId == game.PlaceId and not self.Selected then self:Select(Game) end
			return Game
		end
		Loader.CreateGame = Loader.AddGame

		function Loader:Select(Game)
			if self.Loading then return end
			if self.Selected then
				ThemeTween(self.Selected.Row, "BackgroundColor3", "Tab", 0.15)
				ThemeTween(self.Selected.Stroke, "Color", "Outline", 0.15)
			end
			self.Selected = Game
			ThemeTween(Game.Row, "BackgroundColor3", "Hovered Element", 0.15)
			ThemeTween(Game.Stroke, "Color", "Accent", 0.15)
			Library:SetText(self.Parts.LaunchText, "Launch " .. (Game.Config.Name or Game.Config.Text or "game"))
			ThemeTween(self.Parts.LaunchText, "TextColor3", "Accent", 0.15)
			ThemeTween(self.Parts.LaunchStroke, "Color", "Accent", 0.15)
		end

		function Loader:Load()
			if self.Loading or not self.Selected then return end
			self.Loading = true
			local Parts = self.Parts
			Library:SetText(Parts.LoadingTitle, "Launching " .. (self.Selected.Config.Name or "game"))
			Tween(Parts.Picker, { GroupTransparency = 1 }, 0.2)
			Parts.Loading.Visible = true
			Tween(Parts.Loading, { GroupTransparency = 0 }, 0.25)
			local StepNames = self.Selected.Config.Steps or { "Authenticating", "Downloading script", "Building interface" }
			local Rows = {}
			for Index, Name in StepNames do
				local Row = Create("Frame", { Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, LayoutOrder = Index, Parent = Parts.Steps })
				local Mark = Create("ImageLabel", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(11, 11), ImageTransparency = 1, Theme = { ImageColor3 = "Accent" }, Parent = Row })
				SetIcon(Mark, "Check")
				local Label = Create("TextLabel", { Position = UDim2.fromOffset(18, 0), Size = UDim2.new(1, -18, 1, 0), Text = Name, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Theme = { TextColor3 = "Inactive Text" }, Parent = Row })
				Rows[Index] = { Mark = Mark, Label = Label }
			end
			task.spawn(function()
				for Index, Row in Rows do
					ThemeTween(Row.Label, "TextColor3", "Text", 0.2)
					Tween(Parts.ProgressFill, { Size = UDim2.fromScale(Index / #Rows, 1) }, 0.55, Enum.EasingStyle.Quad)
					task.wait(0.6)
					Tween(Row.Mark, { ImageTransparency = 0 }, 0.2)
					ThemeTween(Row.Label, "TextColor3", "Inactive Text", 0.2)
				end
				task.wait(0.25)
				Tween(Parts.Scale, { Scale = 0.96 }, 0.25)
				Tween(Parts.Frame, { GroupTransparency = 1 }, 0.25).Completed:Wait()
				Parts.Frame:Destroy()
				self.Done = true
				SafeCall(self.Selected.Config.Callback)
				SafeCall(self.Callback, self.Selected.Config)
			end)
		end

		function Loader:Wait()
			repeat task.wait() until self.Done
			return self.Selected and self.Selected.Config
		end
	end

	do
		function Library:SetScale(Scale)
			for _, Gui in { Library.MenuGui, Library.OverlayGui, Library.HudGui } do
				local Object = Gui:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
				Object.Scale = Scale
				Object.Parent = Gui
			end
		end

		Library.CreateMenu = Library.CreateWindow
	end
end

return getgenv and getgenv().Library or Library
