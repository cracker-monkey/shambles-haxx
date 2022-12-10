local shambles = {
    workspace = "shambles haxx",
    game = "Site Delta",
    version = "0.0.1a",
    username = getgenv().username,
}

local PLRDS = {}
local DWPS = {}
local FCS = {}
local load1 = tick()

local fovcircles = {}
local Ut = {}

Ut.AutoDo = {
	Line = {
		Thickness = 1,
		Color = Color3.fromRGB(0, 255, 0),
        Transparency = 1,
	},
	Text = {
		Size = 13,
		Center = true,
		Outline = true,
		Font = 2,
		Color = Color3.fromRGB(255, 255, 255),
        Transparency = 1,
	},
	Square = {
		Thickness = 1,
		Color = Color3.fromRGB(255, 255, 255),
		Filled = false,
        Transparency = 1,
	},
	Circle = {
		Filled = false,
		NumSides = 30,
		Thickness = 0,
        Transparency = 1,
	},
	Triangle = {
		Color = Color3.fromRGB(255, 255, 255),
		Filled = true,
		Visible = false,
		Thickness = 1,
        Transparency = 1,
	},
    Image = {
        Transparency = 1,
        Visible = true,
        Data = game:HttpGet("https://i.imgur.com/2KZqAOV.png"),
    },
}

function Ut.New(data)
	local drawing = Drawing.new(data.type)

	for i, v in pairs(Ut.AutoDo[data.type]) do
		drawing[i] = v
	end

	if data.type == "Square" then
		if not data.filled then
			drawing.Filled = false
		elseif data.filled then
			drawing.Filled = true
		end
	end

    drawing.ZIndex = -1

	if data.out then
		drawing.Color = Color3.new(0,0,0)
		drawing.Thickness = 3
	end
	return drawing
end

function Ut.AddToPlayer(Player)
	if not PLRDS[Player] then
		PLRDS[Player] = {
			Offscreen = Ut.New({type = "Triangle"}),
			Name = Ut.New({type = "Text"}),
			Distance = Ut.New({type = "Text"}),
			BoxOutline = Ut.New({type = "Square", out = true}),
			Box = Ut.New({type = "Square"}),
			HealthNumber = Ut.New({type = "Text"}),
			HealthOutline = Ut.New({type = "Line", out = true}),
			Health = Ut.New({type = "Line"}),
			Weapon = Ut.New({type = "Text"}),
			Team = Ut.New({type = "Text"}),
		}
	end
end

local Watermark = {
    Border = Ut.New({type = "Square"}),
    Background = Ut.New({type = "Square"}),
    Accent = Ut.New({type = "Square"}),
    Accent2 = Ut.New({type = "Square"}),
    BorderLine = Ut.New({type = "Square"}),
    Gradient = Ut.New({type = "Image"}),
    Text = Ut.New({type = "Text"}),
    Icon = Ut.New({type = "Image"}),
}

local FCS = {
    AimAssistBorder = Ut.New({type = "Circle"}),
    AimAssist = Ut.New({type = "Circle"}),
}

local Crosshair = {
    LeftBorder = Ut.New({type = "Line"}),
    RightBorder = Ut.New({type = "Line"}),
    TopBorder = Ut.New({type = "Line"}),
    BottomBorder = Ut.New({type = "Line"}),

    Left = Ut.New({type = "Line"}),
    Right = Ut.New({type = "Line"}),
    Top = Ut.New({type = "Line"}),
    Bottom = Ut.New({type = "Line"}),
}

local Library                   = loadstring(game:HttpGet('https://raw.githubusercontent.com/senpaioffice132/Shambles-Haxx/main/Library.lua'))()

local INST                      = Instance.new
local V2                        = Vector2.new
local V3                        = Vector3.new
local C3                        = Color3.fromRGB
local ColorCorrection           = INST("ColorCorrectionEffect", workspace.CurrentCamera)
local Players                   = game:GetService('Players')
local Http                      = game:GetService('HttpService')
local RunService                = game:GetService('RunService')
local UserInputService          = game:GetService('UserInputService')
local TweenService              = game:GetService('TweenService')
local Stats                     = game:GetService('Stats')
local Actionservice             = game:GetService('ContextActionService')
local ReplicatedStorage 		= game:GetService('ReplicatedStorage')
local Lighting 					= game:GetService("Lighting")
local rs                        = game:GetService("RunService")
local Tween                     = game:GetService("TweenService")
local Debris                    = game:GetService("Debris")
local LocalPlayer               = Players.LocalPlayer
local LocalMouse                = LocalPlayer:GetMouse()
local GameSettings              = UserSettings():GetService("UserGameSettings")
local Camera                    = workspace.CurrentCamera
local ScreenSize                = Camera.ViewportSize
local Ping 						= game.Stats.PerformanceStats.Ping:GetValue() 
local saturationEffect 			= INST("ColorCorrectionEffect", Lighting)
local PerformanceStats 			= game.Stats.PerformanceStats
local MousePos 					= Vector3.new(UserInputService:GetMouseLocation().x, UserInputService:GetMouseLocation().y, 0)
local PingPerformance			= PerformanceStats.Ping:GetValue()
local CrosshairPos 				= ScreenSize / 2
local CrosshairLeft             = Crosshair.Left
local CrosshairRight            = Crosshair.Right
local CrosshairTop              = Crosshair.Top
local CrosshairBottom           = Crosshair.Bottom
local CrosshairLeftBorder       = Crosshair.LeftBorder
local CrosshairRightBorder      = Crosshair.RightBorder
local CrosshairTopBorder        = Crosshair.TopBorder
local CrosshairBottomBorder     = Crosshair.BottomBorder
local RPar                      = RaycastParams.new()        	
RPar.IgnoreWater                = true 
RPar.FilterType                 = Enum.RaycastFilterType.Blacklist
RPar.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
local organizedPlayers          = {}
local currentAngle              = 0
local fps                       = 0
local emojis = {
    "😎😎😎😎😎😎😎😎😎😎",
    "🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣",
    "👀👀👀👀👀👀👀👀👀👀",
    "🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄",
    "🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥",
    "😅😅😅😅😅😅😅😅😅😅",
    "😂😂😂😂😂😂😂😂😂😂",
    "😹😹😹😹😹😹😹😹😹😹",
    "😛😛😛😛😛😛😛😛😛😛",
    "🤩🤩🤩🤩🤩🤩🤩🤩🤩🤩",
    "🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈",
    "😎😎😎😎😎😎😎😎😎😎",
    "🤠🤠🤠🤠🤠🤠🤠🤠🤠🤠",
    "😔😔😔😔😔😔😔😔😔😔",
    "🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡",
    "💤💤💤💤💤💤💤💤💤💤",
    "🚶‍♂️🚶‍♀️🚶‍♂️🚶‍‍🚶‍♀️🚶‍♂️🚶‍♀️🚶‍♂️🚶🚶‍♀️🚶‍♂️🚶🚶‍♀️🚶‍♂️🚶‍",
    "🙀🙀🙀🙀🙀🙀🙀🙀🙀🙀",
    "😂😂😂😂😂😂😂😂😂😂",
    "📈📈📈📈📈📈📈📈📈📈",
    "🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏",
}
    
local symbols = {
    "~~~~~~~~~~",
    "!!!!!!!!!!",
    "@@@@@@@@@@",
    "##########",
    "$$$$$$$$$$",
    "%%%%%%%%%%",
    "^^^^^^^^^^",
    "&&&&&&&&&&",
    "**********",
    "((((((((((",
    "))))))))))",
    "__________",
    "++++++++++",
    "{{{{{{{{{{",
    "}}}}}}}}}}",
    "||||||||||",
    "::::::::::",
    '""""""""""',
    "<<<<<<<<<<",
    ">>>>>>>>>>",
    "??????????",
    "..........",
    ",,,,,,,,,,",
    "//////////",
    "''''''''''",
}

local phrases = {
    "how many bites are in a d-word?",
    "i think your bad.",
    "*TOT*",
    "d(-_-)b",
    "keep crying :C",
    "how much is a gigabyte?",
    "i have 10tb of cp (club pengiun)",
    "hi hi hi hi hi hi",
    "AAAAAAAAAAAAAAAAAAAA",
    "SET UPVALUES (CONSTANT)",
    "brb taking a nap",
    "gonna go take a walk",
    "low orbit ion cannon booting up",
    "im a firing my laza!",
    "GAMING CHAIR",
    "can't hear you over these kill sounds",
    "i'm just built different yo",
    "OFF THE CHART ",
    "KICK HIM",
    "SORRY I HURT YOUR ROBLOX EGO",
    "FULCRUM COME IN YUUHH YODIE GANG",
    "Shall we? cheers my friends.",
    "Cheers my friends.",
    "Let's take a blinker, shall we?",
    "Shall we go to penjamin city?",
    "PLUG PLUG P-P-PLUG.",
    "Im completely obliterated",
    "i am a person.",	
    "cl_junkcode 1",
    "moment - Vierre Cloud",
    "IT BASICALLY WIPES EVERY LOBBY",
    "THERE IS NO CHEAT AND I WILL- I WILL STAND ON THIS UNTIL IM DIS-PROVEN WRONG",
    "BUT THERE IS NO CHEAT THAT CAN COMPETE WITH EXODUS",
    "THAT LIKE-LIKE KILLS IT",
    "LIKE IM TELLING YOU BRO",
    "I-I GOT VOTEKICKED FROM AN AECH VEE AECH LOBBY",
    "FROM AN AECH VEE AECH LOBBY.",
}

local stringsub_table = {
    [1] = 4,
    [2] = 8,
    [3] = 12,
    [4] = 16,
    [5] = 20,
    [6] = 24,
    [7] = 28,
    [8] = 32,
    [9] = 36,
    [10] = 40
}

local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/addons/SaveManager.lua'))()

local Window = Library:CreateWindow({ Title = 'Shambles Haxx', Center = true, AutoShow = true })

local Tabs = { Legit = Window:AddTab('Legit'), Visuals = Window:AddTab('Visuals'), Misc = Window:AddTab('Misc'), ['Settings'] = Window:AddTab('Settings') }

local AimAssist = Tabs.Legit:AddLeftGroupbox('Aim Assist')
AimAssist:AddToggle('AimEnabled', {Text = 'Enabled'}):AddKeyPicker('AimKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Aim Assist', NoUI = false})
AimAssist:AddSlider('AimFov', {Text = 'Field Of View', Default = 30, Min = 1, Max = 360, Rounding = 0})
AimAssist:AddSlider('AimHorizontal', {Text = 'Horizontal Smoothing', Default = 20, Min = 1, Max = 100, Rounding = 0})
AimAssist:AddSlider('AimVertical', {Text = 'Vertical Smoothing', Default = 20, Min = 1, Max = 100, Rounding = 0})
AimAssist:AddToggle('AimVisCheck', {Text = 'Visible Check'})
AimAssist:AddToggle('AimTeam', {Text = 'Target Teammates'})
AimAssist:AddDropdown('AimHitscan', {Values = { "Head", "HumanoidRootPart", "Closest" }, Default = 1, Multi = false, Text = 'Hitscan Priority'})
AimAssist:AddLabel("If your using high sensitivity make your smoothing higher!", true)

local EnemyEspBox = Tabs.Visuals:AddLeftTabbox()
local EnemyEsp = EnemyEspBox:AddTab('Enemy ESP')
local TeamEsp = EnemyEspBox:AddTab('Team ESP')
local SettingsEsp = EnemyEspBox:AddTab('Settings')

EnemyEsp:AddToggle('EnemyEspEnabled', {Text = 'Enabled'})
EnemyEsp:AddToggle('EnemyEspBox', {Text = 'Box'}):AddColorPicker('EnemyColorBox', {Default = Color3.fromRGB(255, 255, 255), Title = 'Box Color'})
EnemyEsp:AddToggle('EnemyEspName', {Text = 'Name'}):AddColorPicker('EnemyColorName', {Default = Color3.fromRGB(255, 255, 255), Title = 'Name Color'})
EnemyEsp:AddToggle('EnemyEspHealthBar', {Text = 'Health Bar'}):AddColorPicker('EnemyColorHealthBar', {Default = Color3.fromRGB(255, 255, 0), Title = 'Health Bar Color'})
EnemyEsp:AddToggle('EnemyEspHealthNumber', {Text = 'Health Number'}):AddColorPicker('EnemyColorHealthNumber', {Default = Color3.fromRGB(255, 255, 255), Title = 'Health Number Color'})
EnemyEsp:AddToggle('EnemyEspWeapon', {Text = 'Weapon'}):AddColorPicker('EnemyColorWeapon', {Default = Color3.fromRGB(255, 255, 255), Title = 'Weapon Color'})
EnemyEsp:AddToggle('EnemyEspDistance', {Text = 'Distance'}):AddColorPicker('EnemyColorDistance', {Default = Color3.fromRGB(255, 255, 255), Title = 'Distance Color'})
EnemyEsp:AddToggle('EnemyEspOutOfView', {Text = 'Out Of View'}):AddColorPicker('EnemyColorOutOfView', {Default = Color3.fromRGB(255, 255, 255), Title = 'Out Of View Color'})
EnemyEsp:AddToggle('EnemyEspOutOfViewSine', {Text = 'Pulse'})
EnemyEsp:AddSlider('EnemyEspOutOfViewDistance', {Text = 'Distance', Default = 20, Min = 0, Max = 100, Rounding = 1})
EnemyEsp:AddSlider('EnemyEspOutOfViewSize', {Text = 'Size', Default = 12, Min = 0, Max = 30, Rounding = 1})
EnemyEsp:AddDivider()
EnemyEsp:AddToggle('EnemyEspChams', {Text = 'Chams'}):AddColorPicker('EnemyColorChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Chams Color'}):AddColorPicker('EnemyColorChamsOutline', {Default = Color3.fromRGB(255, 255, 255), Title = 'Chams Outline Color'})
EnemyEsp:AddToggle('EnemyEspChamsSine', {Text = 'Pulse'})
EnemyEsp:AddSlider('EnemyEspChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0})
EnemyEsp:AddSlider('EnemyEspOutlineChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0})

TeamEsp:AddToggle('TeamEspEnabled', {Text = 'Enabled'})
TeamEsp:AddToggle('TeamEspBox', {Text = 'Box'}):AddColorPicker('TeamColorBox', {Default = Color3.fromRGB(255, 255, 255), Title = 'Box Color'})
TeamEsp:AddToggle('TeamEspName', {Text = 'Name'}):AddColorPicker('TeamColorName', {Default = Color3.fromRGB(255, 255, 255), Title = 'Name Color'})
TeamEsp:AddToggle('TeamEspHealthBar', {Text = 'Health Bar'}):AddColorPicker('TeamColorHealthBar', {Default = Color3.fromRGB(255, 255, 0), Title = 'Health Bar Color'})
TeamEsp:AddToggle('TeamEspHealthNumber', {Text = 'Health Number'}):AddColorPicker('TeamColorHealthNumber', {Default = Color3.fromRGB(255, 255, 255), Title = 'Health Number Color'})
TeamEsp:AddToggle('TeamEspWeapon', {Text = 'Weapon'}):AddColorPicker('TeamColorWeapon', {Default = Color3.fromRGB(255, 255, 255), Title = 'Weapon Color'})
TeamEsp:AddToggle('TeamEspDistance', {Text = 'Distance'}):AddColorPicker('TeamColorDistance', {Default = Color3.fromRGB(255, 255, 255), Title = 'Distance Color'})
TeamEsp:AddToggle('TeamEspOutOfView', {Text = 'Out Of View'}):AddColorPicker('TeamColorOutOfView', {Default = Color3.fromRGB(255, 255, 255), Title = 'Out Of View Color'})
TeamEsp:AddToggle('TeamEspOutOfViewSine', {Text = 'Pulse'})
TeamEsp:AddSlider('TeamEspOutOfViewDistance', {Text = 'Distance', Default = 20, Min = 0, Max = 100, Rounding = 1})
TeamEsp:AddSlider('TeamEspOutOfViewSize', {Text = 'Size', Default = 12, Min = 0, Max = 30, Rounding = 1})
TeamEsp:AddDivider()
TeamEsp:AddToggle('TeamEspChams', {Text = 'Chams'}):AddColorPicker('TeamColorChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Chams Color'}):AddColorPicker('TeamColorChamsOutline', {Default = Color3.fromRGB(255, 255, 255), Title = 'Chams Outline Color'})
TeamEsp:AddToggle('TeamEspChamsSine', {Text = 'Pulse'})
TeamEsp:AddSlider('TeamEspChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0})
TeamEsp:AddSlider('TeamEspOutlineChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0})

SettingsEsp:AddToggle('EspTarget', {Text = 'Display Target'}):AddColorPicker('ColorTarget', {Default = Color3.fromRGB(255, 0, 0), Title = 'Distance Color'})
SettingsEsp:AddDropdown('TextFont', {Values = { "UI", "System", "Plex", "Monospace" }, Default = 3, Multi = false, Text = 'Text Font'})
SettingsEsp:AddDropdown('TextCase', {Values = { "lowercase", "Normal", "UPPERCASE" }, Default = 2, Multi = false, Text = 'Text Case'})
SettingsEsp:AddSlider('TextSize', {Text = 'Text Size', Default = 13, Min = 1, Max = 34, Rounding = 0})
SettingsEsp:AddSlider('HpVis', {Text = 'Max HP Visibility Cap', Default = 90, Min = 0, Max = 100, Rounding = 0})

local CursorEsp = Tabs.Visuals:AddRightGroupbox('Cursor')

CursorEsp:AddToggle('CursorEnabled', {Text = 'Enabled'}):AddColorPicker('ColorCursor', {Default = Color3.fromRGB(255, 255, 0), Title = 'Cursor Color'}):AddColorPicker('ColorCursorBorder', {Default = Color3.fromRGB(0, 0, 0), Title = 'Cursor Border Color'})
CursorEsp:AddSlider('CursorSize', {Text = 'Size', Default = 13, Min = 1, Max = 100, Rounding = 0})
CursorEsp:AddSlider('CursorThickness', {Text = 'Thickness', Default = 2, Min = 1, Max = 50, Rounding = 0})
CursorEsp:AddSlider('CursorGap', {Text = 'Gap', Default = 5, Min = 1, Max = 100, Rounding = 0})
CursorEsp:AddToggle('CursorBorder', {Text = 'Border'})
CursorEsp:AddToggle('CursorMouse', {Text = 'Follow Mouse'})
CursorEsp:AddToggle('CursorSpin', {Text = 'Spin'})
CursorEsp:AddSlider('CursorSpinSpeed', {Text = 'Spin Speed', Default = 5, Min = 1, Max = 50, Rounding = 0})

local FovEsp = Tabs.Visuals:AddRightGroupbox('Field Of View')
FovEsp:AddToggle('FovAimAssist', {Text = 'Aim Assist'}):AddColorPicker('ColorFovAimAssist', {Default = Color3.fromRGB(255, 255, 255), Title = 'Aim Assist Color'}):AddColorPicker('ColorFovAimAssistBorder', {Default = Color3.fromRGB(0, 0, 0), Title = 'Aim Assist Border Color'})
FovEsp:AddToggle('FovMouse', {Text = 'Follow Mouse'})
FovEsp:AddToggle('FovFilled', {Text = 'Filled'})
FovEsp:AddToggle('FovBorder', {Text = 'Border'})
FovEsp:AddSlider('FovNumSides', {Text = 'Num Sides', Default = 50, Min = 1, Max = 180, Rounding = 0})
FovEsp:AddSlider('FovThick', {Text = 'Thickness', Default = 1, Min = 1, Max = 50, Rounding = 0})
FovEsp:AddSlider('FovTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0})


local WorldEsp = Tabs.Visuals:AddRightGroupbox('World Visuals')

WorldEsp:AddToggle('WorldAmbience', {Text = 'Ambience'}):AddColorPicker('ColorInsideAmbience', {Default = Color3.fromRGB(255, 255, 255), Title = 'Inside Ambience Color'}):AddColorPicker('ColorOutsideAmbience', {Default = Color3.fromRGB(255, 255, 255), Title = 'Outside Ambience Color'})
WorldEsp:AddToggle('WorldTime', {Text = 'Force Time'})
WorldEsp:AddSlider('WorldTimeAmount', {Text = 'Custom Time', Default = 12, Min = 0, Max = 24, Rounding = 0})
WorldEsp:AddToggle('WorldSaturation', {Text = 'Custom Saturation'}):AddColorPicker('ColorSaturation', {Default = Color3.fromRGB(255, 255, 255), Title = 'Saturation Color'})
WorldEsp:AddSlider('WorldSaturationAmount', {Text = 'Saturation Density', Default = 2, Min = 0, Max = 100, Rounding = 0})

local Movement = Tabs.Misc:AddLeftGroupbox('Movement')
Movement:AddToggle('MovementSpeed', {Text = 'Speed'}):AddKeyPicker('MovementSpeedKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Speed', NoUI = false})
Movement:AddSlider('MovementSpeedAmount', {Text = 'Speed Amount', Default = 60, Min = 1, Max = 500, Rounding = 0})
Movement:AddToggle('MovementFly', {Text = 'Fly'}):AddKeyPicker('MovementFlyKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Fly', NoUI = false})
Movement:AddSlider('MovementFlyAmount', {Text = 'Fly Amount', Default = 60, Min = 1, Max = 500, Rounding = 0})
Movement:AddToggle('MovementAutoJump', {Text = 'Auto Jump'})

local Extra = Tabs.Misc:AddRightGroupbox('Extra')
Extra:AddToggle('ChatSpam', {Text = 'Chat Spam'})
Extra:AddToggle('ChatSpamEmojis', {Text = 'Emojis'})
Extra:AddToggle('ChatSpamSymbols', {Text = 'Symbols'})
Extra:AddSlider('ChatSpamDelay', {Text = 'Delay', Default = 3, Min = 1, Max = 20, Rounding = 0})
Extra:AddButton('Join New Game', function()
    Library:Notify("Joining a new "..shambles.game.." server!", 5)

    local Servers = game.HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)))

    for Index, Value in pairs(Servers.data) do
        if Value.playing ~= Value.maxPlayers and Value.playing > 20 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Value.id)
        end
    end
end)

local MenuGroup = Tabs['Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' }) 

Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings() 
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 
ThemeManager:SetFolder(shambles.workspace)
SaveManager:SetFolder(shambles.workspace .."/"..shambles.game)
SaveManager:BuildConfigSection(Tabs['Settings']) 
ThemeManager:ApplyToTab(Tabs['Settings'])

local Friend = {}

local Interface = Tabs.Settings:AddRightGroupbox("Interface")
Interface:AddToggle('InterfaceKeybinds', {Text = 'Keybinds'})
Interface:AddToggle('InterfaceWatermark', {Text = 'Watermark', Default = true}):AddColorPicker('ColorWatermark', {Default = Color3.fromRGB(0, 140, 255), Title = 'Watermark Color'})
Interface:AddInput('WatermarkText', {Default = 'Shambles Haxx / {user} {fps} fps {ping} ms {version}', Numeric = false, Finished = false, Text = 'Watermark Text', Placeholder = 'Watermark Text', Tooltip = "{user}, {hour}, {minute}, {second}\n{ap}, {month}, {day}, {year}\n{version}, {fps}, {ping}, {game}"})
Interface:AddInput('WatermarkIcon', {Default = 'Watermark Icon', Numeric = false, Finished = false, Text = 'Watermark Icon', Placeholder = 'Watermark Icon'})
Interface:AddToggle('RainbowAccent', {Text = 'Rainbow Accent'})
Interface:AddSlider('RainbowSpeed', {Text = 'Rainbow Speed', Default = 40, Min = 1, Max = 50, Rounding = 0})
Interface:AddDivider()
Interface:AddDropdown('PlayerList', {Values = {}, Default = 1, Multi = false, Text = 'Player List'})
Interface:AddButton('Refresh', function()
    for i,v in pairs(Players:GetPlayers()) do   
        if not table.find(Options.PlayerList.Values, v.Name) then
            table.insert(Options.PlayerList.Values, v.Name)
            Options.PlayerList:SetValues()
            Options.PlayerList:SetValue(nil)
        end
    end
end)

Interface:AddButton('Friend', function()
    if not table.find(Friend, Options.PlayerList.Value) then
        table.insert(Friend, Options.PlayerList.Value)
        Library:Notify("Friended player " ..Options.PlayerList.Value.. ".", 2.5)
    elseif table.find(Friend, Options.PlayerList.Value) then
        table.remove(Friend, Options.PlayerList.Value)
        Library:Notify("Un-Friended player " ..Options.PlayerList.Value.. ".", 2.5)
    end

    table.foreach(Friend, print)
end)

SaveManager:LoadAutoloadConfig()

if isfile(Options.WatermarkIcon.Value) then
    Watermark.Icon.Data = readfile(Options.WatermarkIcon.Value)
else
    Watermark.Icon.Data = game:HttpGet("https://i.imgur.com/vmCJh3v.png")
end

Options.WatermarkIcon:OnChanged(function()
    if isfile(Options.WatermarkIcon.Value) then
        Watermark.Icon.Data = readfile(Options.WatermarkIcon.Value)
    end
end)

Library:SetWatermarkVisibility(false)
Library.KeybindFrame.Visible = Toggles.InterfaceKeybinds.Value

Toggles.InterfaceKeybinds:OnChanged(function()
    Library.KeybindFrame.Visible = Toggles.InterfaceKeybinds.Value
end)   

load1 = tick()

Library:OnUnload(function()
    for i,v in pairs (Players:GetPlayers()) do
        if PLRDS[v] then
            for i, v in pairs(PLRDS[v]) do
                v:Remove()
            end
        end
    end

    for i,v in pairs(Crosshair) do
        if v ~= nil then
            v:Remove()
        end
    end

    for i,v in pairs(FCS) do
        v:Remove()
    end

    for i,v in pairs(Watermark) do
        v:Remove()
    end

    Library.Unloaded = true
end)

wait(0.4)

do
    for _,Player in pairs(Players:GetPlayers()) do
        Ut.AddToPlayer(Player)
    end
    Players.PlayerAdded:Connect(Ut.AddToPlayer)

    Players.PlayerRemoving:Connect(function(Player)
        if PLRDS[Player] then
            for i,v in pairs(PLRDS[Player]) do
                if v then
                    v:Remove()
                end
            end

            PLRDS[Player] = nil
        end
    end)

    function isAlive(player)
        if not player then player = LocalPlayer end
        return player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Head") and player.Character.Humanoid.Health > 0 and true or false
	end

    local function find_2d_distance( pos1, pos2 )
        local dx = pos1.X - pos2.X
        local dy = pos1.Y - pos2.Y
        return math.sqrt ( dx * dx + dy * dy )
    end

    local function Mouse_Move(pos, smoothx, smoothy)
        local Pos = Camera:WorldToScreenPoint(pos)
        local inc = V2(Pos.X - LocalMouse.X, Pos.Y - LocalMouse.Y)
        mousemoverel(inc.X / smoothx , inc.Y / smoothy)
    end
	
	local function findtextrandom(text)
		if text:find(' @r ') then 
			local b = text:split(' @r ')
			return b[math.random(#b)]
		else 
			return text
		end
	end

	local function textboxtriggers(text)
        local triggers = {
            ['{user}'] = shambles.username,
            ['{hour}'] = os.date("%H"),
            ['{minute}'] = os.date("%M"),
            ['{second}'] = os.date("%S"),
            ['{ap}'] = os.date("%p"),
            ['{month}'] = os.date("%b"),
            ['{day}'] = os.date("%d"),
            ['{year}'] = os.date("%Y"),
            ['{version}'] = shambles.version,
            ['{fps}'] = fps,
            ['{ping}'] = math.floor(game:GetService('Stats').Network.ServerStatsItem["Data Ping"]:GetValue()),
            ['{game}'] = shambles.game,
            ['{time}'] = os.date("%H:%M:%S"),
         }        

		for a,b in next, triggers do 
			text = string.gsub(text, a, b)
		end

		return findtextrandom(text)
	end

    local function rotateVector2(v2, r)
        local c = math.cos(r);
        local s = math.sin(r);
        return Vector2.new(c * v2.X - s*v2.Y, s*v2.X + c*v2.Y)
    end

    function calculate_player_bounding_box(character)
        local cam = workspace.CurrentCamera.CFrame
        local HumanoidRootPart = character.HumanoidRootPart.CFrame
        local head = character.Head.CFrame
        local top, top_isrendered = workspace.CurrentCamera:WorldToViewportPoint(head.Position + (HumanoidRootPart.UpVector * 0.2) + cam.UpVector)
        local bottom, bottom_isrendered = workspace.CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position - (HumanoidRootPart.UpVector * 2.5) - cam.UpVector)

        local minY = math.abs(bottom.y - top.y)
        local sizeX = math.ceil(math.max(math.clamp(math.abs(bottom.x - top.x) * 2.5, 0, minY), minY / 2, 3))
        local sizeY = math.ceil(math.max(minY, sizeX, 3))

        if top_isrendered or bottom_isrendered then
            local boxtop = Vector2.new(math.floor(top.x * 0.5 + bottom.x * 0.5 - sizeX * 0.5), math.floor(math.min(top.y, bottom.y)))
            local boxsize = Vector2.new(sizeX, sizeY)
            return boxtop, boxsize 
        end
    end

    task.spawn(function()
        while task.wait(Options.ChatSpamDelay.Value) do
            if Toggles.ChatSpam.Value and Library.Unloaded ~= false then
                local lol = ""
    
                if Toggles.ChatSpamEmojis.Value and Toggles.ChatSpamSymbols.Value then
                    lol = string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)])
                elseif Toggles.ChatSpamEmojis.Value then
                    lol = string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)])
                elseif Toggles.ChatSpamSymbols.Value then
                    lol = string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10))
                else
                    lol = phrases[math.random(1, #phrases)] .. " " .. phrases[math.random(1, #phrases)] .. " " .. phrases[math.random(1, #phrases)]
                end

                if #lol > 200 then
                    if Toggles.ChatSpamEmojis.Value and Toggles.ChatSpamSymbols.Value then
                        lol = string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)])
                    elseif Toggles.ChatSpamEmojis.Value then
                        lol = string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)])
                    elseif Toggles.ChatSpamSymbols.Value then
                        lol = string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10))
                    else
                        lol = phrases[math.random(1, #phrases)] .. " " .. phrases[math.random(1, #phrases)] .. " " .. phrases[math.random(1, #phrases)]
                    end
                end
    
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(lol, "All") 
            end
        end
    end)

    do -- Cheat Functions
        do -- Aimbot
            Library:GiveSignal(rs.RenderStepped:Connect(function()                
                for i,v in pairs(Players:GetPlayers()) do
                    organizedPlayers = {}

                    if Toggles.AimEnabled.Value and Options.AimKey:GetState() and isAlive(v) and v ~= LocalPlayer then
                        if v.Character ~= nil then
                            local Character = v.Character

                            if Character:FindFirstChild("HumanoidRootPart") then
                                local Pos, OnScreen = Camera:WorldToViewportPoint(Character.HumanoidRootPart.Position)

                                local FieldOfView = Options.AimFov.Value * 2

                                if not Toggles.AimTeam.Value and v.Team and v.Team == LocalPlayer.Team then 
                                    continue 
                                end
                                
                                if FieldOfView ~= 0 and find_2d_distance(Pos, FovPos) > FieldOfView then
                                    continue;
                                end

                                if Toggles.AimVisCheck.Value then
                                    local Dir = Character.HumanoidRootPart.Position - Camera.CFrame.Position
                                    local Res = workspace:Raycast(Camera.CFrame.Position, Dir.Unit * Dir.Magnitude, RPar)
                        
                                    if not Res then continue end
                                    local Hit = Res.Instance
                        
                                    if not Hit:FindFirstAncestor(v.Name) then continue end

                                    table.insert(organizedPlayers, v)
                                else
                                    table.insert(organizedPlayers, v)
                                end
                            end
                        end
                    end

                    for i,v in pairs(organizedPlayers) do
                        if isAlive(v) and v.Character ~= nil then
                            local Character = v.Character

                            local Hitbox = Character:FindFirstChild("Head")

							if Options.AimHitscan.Value == "Head" then
								Hitbox = Character:FindFirstChild("Head")
							elseif Options.AimHitscan.Value == "HumanoidRootPart" then
								Hitbox = Character:FindFirstChild("HumanoidRootPart")
							elseif Options.AimHitscan.Value == "Closest" then
								local HeadPos  = Camera:WorldToViewportPoint(Character:FindFirstChild("Head").Position)
								local TorsoPos = Camera:WorldToViewportPoint(Character:FindFirstChild("HumanoidRootPart").Position)
					
								local HeadDistance  = (Vector2.new(HeadPos.X, HeadPos.Y) - UserInputService:GetMouseLocation()).Magnitude
								local TorsoDistance = (Vector2.new(TorsoPos.X, TorsoPos.Y) - UserInputService:GetMouseLocation()).Magnitude
					
								Hitbox = HeadDistance < TorsoDistance and Character:FindFirstChild("Head") or Character:FindFirstChild("HumanoidRootPart")
							end

                            local Pos, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)

                            if OnScreen then
                                local ps = Vector3.new(Hitbox.Position.X, Hitbox.Position.Y, Hitbox.Position.Z)
                                Mouse_Move(ps, Options.AimHorizontal.Value + 1, Options.AimVertical.Value + 1)
                                return;
                            end
                        end
                    end
                end
            end))
        end

        do -- ESP Players
            Library:GiveSignal(rs.RenderStepped:Connect(function()                
                for i,v in pairs(Players:GetPlayers()) do
                    local Group = "Enemy"

                    if v.Team == LocalPlayer.Team then
                        Group = "Team"
                    end

                    if Toggles[Group.."EspEnabled"].Value and PLRDS[v] and isAlive(v) and v.Character ~= nil and v ~= LocalPlayer then
                        local PLRD = PLRDS[v]
                        for _,v in pairs (PLRD) do
                            if v.Visible ~= false then
                                v.Visible = false
                            end
                        end

                        local Character = v.Character
                        if Character and Character:FindFirstChild("HumanoidRootPart") then
                            local Lol, OnScreen = Camera:WorldToViewportPoint(Character.HumanoidRootPart.Position)
                            if OnScreen then
                                local Pos, Size = calculate_player_bounding_box(Character)
                                if Pos and Size then
                                    local Cur_Health, Max_Health = Character.Humanoid.Health, Character.Humanoid.MaxHealth
                                    local Box = PLRD.Box
                                    local BoxFill = PLRD.BoxFill
                                    local BoxOutline = PLRD.BoxOutline
                                    local Name = PLRD.Name
                                    local Weapon = PLRD.Weapon
                                    local Health = PLRD.Health
                                    local HealthOutline = PLRD.HealthOutline
                                    local HealthNumber = PLRD.HealthNumber
                                    local Distance = PLRD.Distance

                                    if Toggles[Group.."EspChams"].Value then
                                        if not game.CoreGui:FindFirstChild(v.Name) then
                                            local Highlight = Instance.new("Highlight", game.CoreGui)
                                            if Highlight.Name ~= v.Name then
                                                Highlight.Name = v.Name
                                            end
                                        end

                                        if game.CoreGui[v.Name].Adornee ~= Character then
                                            game.CoreGui[v.Name].Adornee = Character
                                        end

                                        if Toggles[Group.."EspChamsSine"].Value then	
                                            game.CoreGui[v.Name].FillTransparency = 1 - (math.sin(tick() * 5) + 1) / 2
                                        else
                                            if game.CoreGui[v.Name].FillTransparency ~= 1 - Options[Group.."EspChamsTrans"].Value / 255 then
                                                game.CoreGui[v.Name].FillTransparency = 1 - Options[Group.."EspChamsTrans"].Value / 255
                                            end
                                        end
                    
                                        if game.CoreGui[v.Name].Adornee ~= Character then
                                            game.CoreGui[v.Name].Adornee = Character
                                        end

                                        if game.CoreGui[v.Name].Enabled ~= false then
                                            game.CoreGui[v.Name].Enabled = false
                                        end

                                        if game.CoreGui[v.Name].OutlineTransparency ~= 1 - Options[Group.."EspOutlineChamsTrans"].Value / 255 then
                                            game.CoreGui[v.Name].OutlineTransparency = 1 - Options[Group.."EspOutlineChamsTrans"].Value / 255
                                        end

                                        if game.CoreGui[v.Name].Enabled ~= true then
                                            game.CoreGui[v.Name].Enabled = true
                                        end
                                        
                                        if Toggles.EspTarget.Value and ragetarget ~= nil and v.Name == ragetarget.Name then
                                            if game.CoreGui[v.Name].FillColor ~= Options.ColorTarget.Value then
                                                game.CoreGui[v.Name].FillColor = Options.ColorTarget.Value
                                            end
                                            
                                            if game.CoreGui[v.Name].OutlineColor ~= Options.ColorTarget.Value then
                                                game.CoreGui[v.Name].OutlineColor = Options.ColorTarget.Value
                                            end
                                        else
                                            if game.CoreGui[v.Name].FillColor ~= Options[Group.."ColorChams"].Value then
                                                game.CoreGui[v.Name].FillColor = Options[Group.."ColorChams"].Value
                                            end
                                            
                                            if game.CoreGui[v.Name].OutlineColor ~= Options[Group.."ColorChamsOutline"].Value then
                                                game.CoreGui[v.Name].OutlineColor = Options[Group.."ColorChamsOutline"].Value
                                            end
                                        end
                                    else
                                        if game.CoreGui:FindFirstChild(v.Name) then
                                            if game.CoreGui[v.Name].Enabled ~= false then
                                                game.CoreGui[v.Name].Enabled = false
                                            end
                                        end
                                    end

                                    if Toggles[Group.."EspBox"].Value then
                                        if Toggles.EspTarget.Value and ragetarget ~= nil and v.Name == ragetarget.Name then
                                            if Box.Color ~= Options.ColorTarget.Value then
                                                Box.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Box.Color ~= Options[Group.."ColorBox"].Value then
                                                Box.Color = Options[Group.."ColorBox"].Value
                                            end
                                        end
                                        Box.Position = Pos
                                        Box.Size = Size
                                        Box.Visible = true

                                        BoxOutline.Position = Pos
                                        BoxOutline.Size = Size
                                        BoxOutline.Visible = true
                                    end

                                    if Toggles[Group.."EspName"].Value then
                                        Name.Position = Vector2.new(Size.X / 2 + Pos.X, Pos.Y - 5 - Name.TextBounds.Y)
                                        if Toggles.EspTarget.Value and ragetarget ~= nil and v.Name == ragetarget.Name then
                                            if Name.Color ~= Options.ColorTarget.Value then
                                                Name.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Name.Color ~= Options[Group.."ColorName"].Value then
                                                Name.Color = Options[Group.."ColorName"].Value
                                            end
                                        end 


                                        if Name.Font ~= Drawing.Fonts[Options.TextFont.Value] then
                                            Name.Font = Drawing.Fonts[Options.TextFont.Value]
                                        end
                                        if Name.Size ~= Options.TextSize.Value then
                                            Name.Size = Options.TextSize.Value
                                        end
                                        Name.Visible = true
                                        if Options.TextCase.Value == "Normal" then
                                            if Name.Text ~= v.Name then
                                                Name.Text = v.Name
                                            end
                                        elseif Options.TextCase.Value == "UPPERCASE" then
                                            if Name.Text ~= string.upper(v.Name) then
                                                Name.Text = string.upper(v.Name)
                                            end
                                        elseif Options.TextCase.Value == "lowercase" then
                                            if Name.Text ~= string.lower(v.Name) then
                                                Name.Text = string.lower(v.Name)
                                            end
                                        end
                                    end

                                    if Toggles[Group.."EspHealthBar"].Value then
                                        Health.From = Vector2.new(Pos.X - 4, Pos.Y + Size.Y)
                                        Health.To = Vector2.new(Pos.X - 4, Health.From.Y - (Cur_Health / Max_Health) * Size.Y)
                                        Health.Visible = true
                                        if Toggles.EspTarget.Value and ragetarget ~= nil and v.Name == ragetarget.Name then
                                            if Health.Color ~= Options.ColorTarget.Value then
                                                Health.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Health.Color ~= Options[Group.."ColorHealthBar"].Value then
                                                Health.Color = Options[Group.."ColorHealthBar"].Value
                                            end
                                        end

                                        HealthOutline.From = Vector2.new(Health.From.X, Pos.Y + Size.Y + 1)
                                        HealthOutline.To = Vector2.new(Health.From.X, (Health.From.Y - 1 * Size.Y) -1)
                                        HealthOutline.Visible = true
                                        if HealthOutline.Thickness ~= 3 then
                                            HealthOutline.Thickness = 3
                                        end
                                    end

                                    if Toggles[Group.."EspHealthNumber"].Value and Cur_Health <= Options.HpVis.Value then
                                        HealthNumber.Visible = true
                                        if HealthNumber.Font ~= Drawing.Fonts[Options.TextFont.Value] then
                                            HealthNumber.Font = Drawing.Fonts[Options.TextFont.Value]
                                        end
                                        if HealthNumber.Size ~= Options.TextSize.Value then
                                            HealthNumber.Size = Options.TextSize.Value
                                        end
                                        if HealthNumber.Text ~= tostring(math.floor(Cur_Health)) then
                                            HealthNumber.Text = tostring(math.floor(Cur_Health))
                                        end
                                        if HealthNumber.Center ~= false then
                                            HealthNumber.Center = false
                                        end
                                        HealthNumber.Position = Vector2.new(Pos.X - 6 - HealthNumber.TextBounds.X, Health.To.Y - 3)

                                        if Toggles.EspTarget.Value and ragetarget ~= nil and v.Name == ragetarget.Name then
                                            if HealthNumber.Color ~= Options.ColorTarget.Value then
                                                HealthNumber.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if HealthNumber.Color ~= Options[Group.."ColorHealthNumber"].Value then
                                                HealthNumber.Color = Options[Group.."ColorHealthNumber"].Value
                                            end
                                        end
                                    end

                                    if Toggles[Group.."EspWeapon"].Value and Character:FindFirstChildWhichIsA("Tool") then
                                        Weapon.Visible = true
                                        if Weapon.Font ~= Drawing.Fonts[Options.TextFont.Value] then
                                            Weapon.Font = Drawing.Fonts[Options.TextFont.Value]
                                        end
                                        if Weapon.Size ~= Options.TextSize.Value then
                                            Weapon.Size = Options.TextSize.Value
                                        end

                                        if Toggles.EspTarget.Value and ragetarget ~= nil and v.Name == ragetarget.Name then
                                            if Weapon.Color ~= Options.ColorTarget.Value then
                                                Weapon.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Weapon.Color ~= Options[Group.."ColorWeapon"].Value then
                                                Weapon.Color = Options[Group.."ColorWeapon"].Value
                                            end
                                        end

                                        Weapon.Position = Vector2.new(Pos.X + (Size.X / 2), Pos.Y + Size.Y + 2)

                                        if Options.TextCase.Value == "Normal" then
                                            if Weapon.Text ~= Character:FindFirstChildWhichIsA("Tool").Name then
                                                Weapon.Text = Character:FindFirstChildWhichIsA("Tool").Name
                                            end
                                        elseif Options.TextCase.Value == "UPPERCASE" then
                                            if Weapon.Text ~= string.upper(Character:FindFirstChildWhichIsA("Tool").Name) then
                                                Weapon.Text = string.upper(Character:FindFirstChildWhichIsA("Tool").Name)
                                            end
                                        elseif Options.TextCase.Value == "lowercase" then
                                            if Weapon.Text ~= string.lower(Character:FindFirstChildWhichIsA("Tool").Name) then
                                                Weapon.Text = string.lower(Character:FindFirstChildWhichIsA("Tool").Name)
                                            end
                                        end
                                    end

                                    if Toggles[Group.."EspDistance"].Value then
                                        Distance.Visible = true
                                        if Distance.Font ~= Drawing.Fonts[Options.TextFont.Value] then
                                            Distance.Font = Drawing.Fonts[Options.TextFont.Value]
                                        end
                                        if Distance.Size ~= Options.TextSize.Value then
                                            Distance.Size = Options.TextSize.Value
                                        end
                                        if Distance.Text ~= tostring(math.ceil(LocalPlayer:DistanceFromCharacter(Character.HumanoidRootPart.Position) / 5)).."M" then
                                            Distance.Text = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(Character.HumanoidRootPart.Position) / 5)).."M"
                                        end
                                        if Toggles.EspTarget.Value and ragetarget ~= nil and v.Name == ragetarget.Name then
                                            if Distance.Color ~= Options.ColorTarget.Value then
                                                Distance.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Distance.Color ~= Options[Group.."ColorDistance"].Value then
                                                Distance.Color = Options[Group.."ColorDistance"].Value
                                            end
                                        end
                                        Distance.Position = Vector2.new(Pos.X + Size.X + 3, Pos.Y - 3)
                                        if Distance.Center ~= false then
                                            Distance.Center = false
                                        end
                                    end
                                end
                            else
                                if Toggles[Group.."EspOutOfView"].Value then
                                    local OutOfView = PLRD.Offscreen

                                    local ptos = Camera.CFrame:PointToObjectSpace(Character.HumanoidRootPart.Position)
                                    local ang = math.atan2(ptos.Z, ptos.X)
                                    local dir = Vector2.new(math.cos(ang), math.sin(ang))
                                    local pos = (dir * Options[Group.."EspOutOfViewDistance"].Value * 10 * .5) + ScreenSize / 2

                                    if Toggles[Group.."EspOutOfViewSine"].Value then
                                        OutOfView.Transparency = (math.sin(tick() * 5) + 1) / 2
                                    else
                                        if OutOfView.Transparency ~= 1 then
                                            OutOfView.Transparency = 1
                                        end
                                    end

                                    OutOfView.PointA = pos
                                    OutOfView.PointB = pos - rotateVector2(dir, math.rad(35)) * Options[Group.."EspOutOfViewSize"].Value
                                    OutOfView.PointC = pos - rotateVector2(dir, -math.rad(35)) * Options[Group.."EspOutOfViewSize"].Value
                                    if Toggles.EspTarget.Value and ragetarget ~= nil and v.Name == ragetarget.Name then
                                        if OutOfView.Color ~= Options.ColorTarget.Value then
                                            OutOfView.Color = Options.ColorTarget.Value
                                        end
                                    else
                                        if OutOfView.Color ~= Options[Group.."ColorOutOfView"].Value then
                                            OutOfView.Color = Options[Group.."ColorOutOfView"].Value
                                        end
                                    end
                                    OutOfView.Visible = true
                                end
                            end
                        else
                            if game.CoreGui:FindFirstChild(v.Name) then
								game.CoreGui[v.Name]:Destroy()
							end

                            if PLRDS[v] then
                                for i, v in pairs(PLRDS[v]) do
                                    if v.Visible ~= false then
                                        v.Visible = false
                                    end
                                end
                            end
                        end
                    else
                        if game.CoreGui:FindFirstChild(v.Name) then
                            game.CoreGui[v.Name]:Destroy()
                        end

                        if PLRDS[v] then
                            for i, v in pairs(PLRDS[v]) do
                                if v.Visible ~= false then
                                    v.Visible = false
                                end
                            end
                        end
                    end
                end
            end))
        end

        do -- Movement
            Library:GiveSignal(rs.RenderStepped:Connect(function()
                if isAlive() then
                    if Toggles.MovementSpeed.Value and Options.MovementSpeedKey:GetState() then
                        local travel = V3()
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            travel += V3(Camera.CFrame.lookVector.x, 0, Camera.CFrame.lookVector.Z)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            travel -= V3(Camera.CFrame.lookVector.x, 0, Camera.CFrame.lookVector.Z)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            travel += V3(-Camera.CFrame.lookVector.Z, 0, Camera.CFrame.lookVector.x)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            travel += V3(Camera.CFrame.lookVector.Z, 0, -Camera.CFrame.lookVector.x)
                        end

                        travel = travel.Unit

                        local newDir = V3(travel.x * Options.MovementSpeedAmount.Value, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.y, travel.Z * Options.MovementSpeedAmount.Value)
        
                        if Toggles.MovementAutoJump.Value and LocalPlayer.Character:FindFirstChild("Humanoid"):GetState() ~= Enum.HumanoidStateType.Freefall then
                            LocalPlayer.Character:FindFirstChild("Humanoid").Jump = true
                        end

                        if travel.Unit.x == travel.Unit.x then
                            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = newDir
                        end
                    end
                end

                if isAlive() then
                    if Toggles.MovementFly.Value and Options.MovementFlyKey:GetState() then
                        local travel = V3()
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            travel += Camera.CFrame.lookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            travel -= Camera.CFrame.lookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            travel += V3(-Camera.CFrame.lookVector.Z, 0, Camera.CFrame.lookVector.x)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            travel += V3(Camera.CFrame.lookVector.Z, 0, -Camera.CFrame.lookVector.x)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            travel += V3(0, 1, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            travel -= V3(0, 1, 0)
                        end

                        if travel.Unit.x == travel.Unit.x then
                            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false
                            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = travel.Unit * Options.MovementFlyAmount.Value
                        else
                            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = V3(0, 0, 0)
                            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true
                        end
                    else
                        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false
                    end
                end
            end))
        end

        do -- Visuals
            Library:GiveSignal(rs.RenderStepped:Connect(function(step)
                fps = math.floor(1/step)
                currentAngle = currentAngle + math.rad((Options.CursorSpinSpeed.Value * 10) * step);
                MousePos = Vector3.new(UserInputService:GetMouseLocation().x, UserInputService:GetMouseLocation().y, 0)

                if Toggles.FovMouse.Value then
                    FovPos = Vector2.new(MousePos.X, MousePos.Y)
                else
                    FovPos = ScreenSize / 2
                end

                if Toggles.CursorMouse.Value then
                    CrosshairPos = Vector2.new(MousePos.X, MousePos.Y)
                else
                    CrosshairPos = ScreenSize / 2
                end

                if Toggles.CursorEnabled.Value then
                    if CrosshairLeft.Color ~= Options.ColorCursor.Value then
                        CrosshairLeft.Color = Options.ColorCursor.Value
                    end
            
                    if CrosshairLeft.Visible ~= true then
                        CrosshairLeft.Visible = true
                    end
            
                    if CrosshairLeft.Thickness ~= Options.CursorThickness.Value then
                        CrosshairLeft.Thickness = Options.CursorThickness.Value
                    end
            
                    if CrosshairLeftBorder.Color ~= Options.ColorCursorBorder.Value then
                        CrosshairLeftBorder.Color = Options.ColorCursorBorder.Value
                    end
            
                    if CrosshairLeftBorder.Thickness ~= Options.CursorThickness.Value + 2 then
                        CrosshairLeftBorder.Thickness = Options.CursorThickness.Value + 2
                    end
            
                    --
            
                    if CrosshairRight.Color ~= Options.ColorCursor.Value then
                        CrosshairRight.Color = Options.ColorCursor.Value
                    end
            
                    if CrosshairRight.Visible ~= true then
                        CrosshairRight.Visible = true
                    end
            
                    if CrosshairRight.Thickness ~= Options.CursorThickness.Value then
                        CrosshairRight.Thickness = Options.CursorThickness.Value
                    end
            
                    if CrosshairRightBorder.Color ~= Options.ColorCursorBorder.Value then
                        CrosshairRightBorder.Color = Options.ColorCursorBorder.Value
                    end
            
                    if CrosshairRightBorder.Thickness ~= Options.CursorThickness.Value + 2 then
                        CrosshairRightBorder.Thickness = Options.CursorThickness.Value + 2
                    end
                    
                    --
            
                    if CrosshairTop.Color ~= Options.ColorCursor.Value then
                        CrosshairTop.Color = Options.ColorCursor.Value
                    end
            
                    if CrosshairTop.Visible ~= true then
                        CrosshairTop.Visible = true
                    end
            
                    if CrosshairTop.Thickness ~= Options.CursorThickness.Value then
                        CrosshairTop.Thickness = Options.CursorThickness.Value
                    end
            
                    if CrosshairTopBorder.Color ~= Options.ColorCursorBorder.Value then
                        CrosshairTopBorder.Color = Options.ColorCursorBorder.Value
                    end
            
                    if CrosshairTopBorder.Thickness ~= Options.CursorThickness.Value + 2 then
                        CrosshairTopBorder.Thickness = Options.CursorThickness.Value + 2
                    end
            
                    --
            
                    if CrosshairBottom.Color ~= Options.ColorCursor.Value then
                        CrosshairBottom.Color = Options.ColorCursor.Value
                    end
            
                    if CrosshairBottom.Visible ~= true then
                        CrosshairBottom.Visible = true
                    end
            
                    if CrosshairBottom.Thickness ~= Options.CursorThickness.Value then
                        CrosshairBottom.Thickness = Options.CursorThickness.Value
                    end
            
                    if CrosshairBottomBorder.Color ~= Options.ColorCursorBorder.Value then
                        CrosshairBottomBorder.Color = Options.ColorCursorBorder.Value
                    end
            
                    if CrosshairBottomBorder.Thickness ~= Options.CursorThickness.Value + 2 then
                        CrosshairBottomBorder.Thickness = Options.CursorThickness.Value + 2
                    end
                    
                    if Toggles.CursorSpin.Value then
                        CrosshairLeft.From = CrosshairPos + (Vector2.new(math.cos(currentAngle), math.sin(currentAngle)) * Options.CursorGap.Value)
                    
                        CrosshairLeft.To = CrosshairLeft.From + (Vector2.new(math.cos(currentAngle), math.sin(currentAngle)) * Options.CursorSize.Value)
            
                        CrosshairLeftBorder.From = CrosshairPos + (Vector2.new(math.cos(currentAngle - 0.01), math.sin(currentAngle - 0.01)) * (Options.CursorGap.Value - 1))
                    
                        CrosshairLeftBorder.To = CrosshairLeftBorder.From + (Vector2.new(math.cos(currentAngle - 0.01), math.sin(currentAngle - 0.01)) * (Options.CursorSize.Value + 2))
            
                        CrosshairRight.From = CrosshairPos + (Vector2.new(math.cos(currentAngle + math.pi / 2), math.sin(currentAngle + math.pi / 2)) * Options.CursorGap.Value)
                    
                        CrosshairRight.To = CrosshairRight.From + (Vector2.new(math.cos(currentAngle + math.pi / 2), math.sin(currentAngle + math.pi / 2)) * Options.CursorSize.Value)
            
                        CrosshairRightBorder.From = CrosshairPos + (Vector2.new(math.cos(((currentAngle) - 0.01) + math.pi / 2), math.sin(((currentAngle) - 0.01) + math.pi / 2)) * (Options.CursorGap.Value - 1))
                    
                        CrosshairRightBorder.To = CrosshairRightBorder.From + (Vector2.new(math.cos(((currentAngle) - 0.01) + math.pi / 2), math.sin(((currentAngle) - 0.01) + math.pi / 2)) * (Options.CursorSize.Value + 2))
            
                        CrosshairTop.From = CrosshairPos + (Vector2.new(math.cos(currentAngle + math.pi), math.sin(currentAngle + math.pi)) * Options.CursorGap.Value)
                    
                        CrosshairTop.To = CrosshairTop.From + (Vector2.new(math.cos(currentAngle + math.pi), math.sin(currentAngle + math.pi)) * Options.CursorSize.Value)
            
                        CrosshairTopBorder.From = CrosshairPos + (Vector2.new(math.cos(((currentAngle) - 0.01) + math.pi), math.sin(((currentAngle) - 0.01) + math.pi)) * (Options.CursorGap.Value - 1))
                    
                        CrosshairTopBorder.To = CrosshairTopBorder.From + (Vector2.new(math.cos(((currentAngle) - 0.01) + math.pi), math.sin(((currentAngle) - 0.01) + math.pi)) * (Options.CursorSize.Value + 2))
            
                        CrosshairBottom.From = CrosshairPos + (Vector2.new(math.cos(currentAngle + math.pi / 2 * 3), math.sin(currentAngle + math.pi / 2 * 3)) * Options.CursorGap.Value)
                    
                        CrosshairBottom.To = CrosshairBottom.From + (Vector2.new(math.cos(currentAngle + math.pi / 2 * 3), math.sin(currentAngle + math.pi / 2 * 3)) * Options.CursorSize.Value)
            
                        CrosshairBottomBorder.From = CrosshairPos + (Vector2.new(math.cos(((currentAngle) - 0.01) + math.pi / 2 * 3), math.sin(((currentAngle) - 0.01) + math.pi / 2 * 3)) * (Options.CursorGap.Value - 1))
                    
                        CrosshairBottomBorder.To = CrosshairBottomBorder.From + (Vector2.new(math.cos(((currentAngle) - 0.01) + math.pi / 2 * 3), math.sin(((currentAngle) - 0.01) + math.pi / 2 * 3)) * (Options.CursorSize.Value + 2))
                    else
                        if CrosshairLeft.From ~= Vector2.new(CrosshairPos.x - Options.CursorGap.Value - Options.CursorSize.Value, CrosshairPos.y) then
                            CrosshairLeft.From = Vector2.new(CrosshairPos.x - Options.CursorGap.Value - Options.CursorSize.Value, CrosshairPos.y)
                        end
                    
                        if CrosshairLeft.To ~= Vector2.new(CrosshairPos.x - Options.CursorGap.Value, CrosshairPos.y) then
                            CrosshairLeft.To = Vector2.new(CrosshairPos.x - Options.CursorGap.Value, CrosshairPos.y)
                        end
                    
                        if CrosshairLeftBorder.From ~= Vector2.new(CrosshairPos.x - Options.CursorGap.Value - Options.CursorSize.Value - 1, CrosshairPos.y) then
                            CrosshairLeftBorder.From = Vector2.new(CrosshairPos.x - Options.CursorGap.Value - Options.CursorSize.Value - 1, CrosshairPos.y)
                        end
                    
                        if CrosshairLeftBorder.To ~= Vector2.new(CrosshairPos.x - Options.CursorGap.Value + 1, CrosshairPos.y) then
                            CrosshairLeftBorder.To = Vector2.new(CrosshairPos.x - Options.CursorGap.Value + 1, CrosshairPos.y)
                        end
                    
                        if CrosshairRight.From ~= Vector2.new(CrosshairPos.x + Options.CursorGap.Value + Options.CursorSize.Value + 1, CrosshairPos.y) then
                            CrosshairRight.From = Vector2.new(CrosshairPos.x + Options.CursorGap.Value + Options.CursorSize.Value + 1, CrosshairPos.y)
                        end
                    
                        if CrosshairRight.To ~= Vector2.new(CrosshairPos.x + Options.CursorGap.Value + 1, CrosshairPos.y) then
                            CrosshairRight.To = Vector2.new(CrosshairPos.x + Options.CursorGap.Value + 1, CrosshairPos.y)
                        end
                    
                        if CrosshairRightBorder.From ~= Vector2.new(CrosshairPos.x + Options.CursorGap.Value + Options.CursorSize.Value + 2, CrosshairPos.y) then
                            CrosshairRightBorder.From = Vector2.new(CrosshairPos.x + Options.CursorGap.Value + Options.CursorSize.Value + 2, CrosshairPos.y)
                        end
                    
                        if CrosshairRightBorder.To ~= Vector2.new(CrosshairPos.x + Options.CursorGap.Value, CrosshairPos.y) then
                            CrosshairRightBorder.To = Vector2.new(CrosshairPos.x + Options.CursorGap.Value, CrosshairPos.y)
                        end
                    
                        if CrosshairTop.From ~= Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value - Options.CursorSize.Value) then
                            CrosshairTop.From = Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value - Options.CursorSize.Value)
                        end
                    
                        if CrosshairTop.To ~= Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value) then
                            CrosshairTop.To = Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value)
                        end
                    
                        if CrosshairTopBorder.From ~= Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value - Options.CursorSize.Value - 1) then
                            CrosshairTopBorder.From = Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value - Options.CursorSize.Value - 1)
                        end
                    
                        if CrosshairTopBorder.To ~= Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value + 1) then
                            CrosshairTopBorder.To = Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value + 1)
                        end
                    
                        if CrosshairBottom.From ~= Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value + Options.CursorSize.Value + 1) then
                            CrosshairBottom.From = Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value + Options.CursorSize.Value + 1)
                        end
                    
                        if CrosshairBottom.To ~= Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value + 1) then
                            CrosshairBottom.To = Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value + 1)
                        end
                    
                        if CrosshairBottomBorder.From ~= Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value + Options.CursorSize.Value + 2) then
                            CrosshairBottomBorder.From = Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value + Options.CursorSize.Value + 2)
                        end
                    
                        if CrosshairBottomBorder.To ~= Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value) then
                            CrosshairBottomBorder.To = Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value)
                        end
                    end
                else
                    for i,v in pairs (Crosshair) do
                        if v.Visible ~= false then
                            v.Visible = false 
                        end
                    end
                end
                
                if Toggles.CursorEnabled.Value and Toggles.CursorBorder.Value then
                    if CrosshairBottomBorder.Visible ~= true then
                        CrosshairBottomBorder.Visible = true
                    end
                    if CrosshairTopBorder.Visible ~= true then
                        CrosshairTopBorder.Visible = true
                    end
                    if CrosshairRightBorder.Visible ~= true then
                        CrosshairRightBorder.Visible = true
                    end
                    if CrosshairLeftBorder.Visible ~= true then
                        CrosshairLeftBorder.Visible = true
                    end
                else
                    if CrosshairBottomBorder.Visible ~= false then
                        CrosshairBottomBorder.Visible = false
                    end
                    if CrosshairTopBorder.Visible ~= false then
                        CrosshairTopBorder.Visible = false
                    end
                    if CrosshairRightBorder.Visible ~= false then
                        CrosshairRightBorder.Visible = false
                    end
                    if CrosshairLeftBorder.Visible ~= false then
                        CrosshairLeftBorder.Visible = false
                    end
                end

                if Toggles.FovAimAssist.Value then
                    FCS.AimAssist.Position = FovPos
                    if FCS.AimAssist.Visible ~= true then
                        FCS.AimAssist.Visible = true
                    end
                    if FCS.AimAssist.Color ~= Options.ColorFovAimAssist.Value then
                        FCS.AimAssist.Color = Options.ColorFovAimAssist.Value
                    end
                    if FCS.AimAssist.Radius ~= Options.AimFov.Value * 2 then
                        FCS.AimAssist.Radius = Options.AimFov.Value * 2
                    end
                    if FCS.AimAssist.NumSides ~= Options.FovNumSides.Value then
                        FCS.AimAssist.NumSides = Options.FovNumSides.Value
                    end
                    if FCS.AimAssist.Thickness ~= Options.FovThick.Value then
                        FCS.AimAssist.Thickness = Options.FovThick.Value
                    end
                    if FCS.AimAssist.Filled ~= Toggles.FovFilled.Value then
                        FCS.AimAssist.Filled = Toggles.FovFilled.Value
                    end
                    if FCS.AimAssist.Transparency ~= Options.FovTrans.Value / 255 then
                        FCS.AimAssist.Transparency = Options.FovTrans.Value / 255
                    end
                    
                    if Toggles.FovBorder.Value then
                        FCS.AimAssistBorder.Position = FovPos
                        if FCS.AimAssistBorder.Visible ~= true then
                            FCS.AimAssistBorder.Visible = true
                        end
                        if FCS.AimAssistBorder.Color ~= Options.ColorFovAimAssistBorder.Value then
                            FCS.AimAssistBorder.Color = Options.ColorFovAimAssistBorder.Value
                        end
                        if FCS.AimAssistBorder.Radius ~= Options.AimFov.Value * 2 then
                            FCS.AimAssistBorder.Radius = Options.AimFov.Value * 2
                        end
                        if FCS.AimAssistBorder.NumSides ~= Options.FovNumSides.Value then
                            FCS.AimAssistBorder.NumSides = Options.FovNumSides.Value
                        end
                        if FCS.AimAssistBorder.Thickness ~= 3 then
                            FCS.AimAssistBorder.Thickness = 3
                        end
                        if FCS.AimAssistBorder.Filled ~= false then
                            FCS.AimAssistBorder.Filled = false
                        end
                        if FCS.AimAssistBorder.Transparency ~= Options.FovTrans.Value / 255 then
                            FCS.AimAssistBorder.Transparency = Options.FovTrans.Value / 255
                        end
                    else
                        if FCS.AimAssistBorder.Visible ~= false then
                            FCS.AimAssistBorder.Visible = false
                        end
                    end
                else
                    if FCS.AimAssist.Visible ~= false then
                        FCS.AimAssist.Visible = false
                    end
                    if FCS.AimAssistBorder.Visible ~= false then
                        FCS.AimAssistBorder.Visible = false
                    end
                end

                Watermark.Text.Text = textboxtriggers(Options.WatermarkText.Value)
            
                if Watermark.Text.Position ~= Vector2.new(143, 17) then
                    Watermark.Text.Position = Vector2.new(143, 17)
                end
            
                if Watermark.Text.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.Text.Visible = Toggles.InterfaceWatermark.Value
                end
                
                if Watermark.Text.Center ~= false then
                    Watermark.Text.Center = false
                end
            
                if Watermark.Border.Color ~= Color3.fromRGB(0, 0, 0) then
                    Watermark.Border.Color = Color3.fromRGB(0, 0, 0)
                end
            
                if Watermark.Border.Position ~= Vector2.new(115, 8) then
                    Watermark.Border.Position = Vector2.new(115, 8)
                end
            
                if Watermark.Border.Filled ~= true then
                    Watermark.Border.Filled = true
                end
            
                if Watermark.Border.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.Border.Visible = Toggles.InterfaceWatermark.Value
                end
                
                Watermark.Border.Size = Vector2.new(Watermark.Text.TextBounds.X + 34, Watermark.Text.TextBounds.Y + 17) 
                
                if Watermark.Gradient.Position ~= Vector2.new(116, 12) then
                    Watermark.Gradient.Position = Vector2.new(116, 12)
                end

                if Watermark.Gradient.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.Gradient.Visible = Toggles.InterfaceWatermark.Value
                end
                
                if Watermark.Gradient.Transparency ~= 0.5 then
                    Watermark.Gradient.Transparency = 0.5
                end

                Watermark.Gradient.Size = Vector2.new(Watermark.Text.TextBounds.X + 32, Watermark.Text.TextBounds.Y + 14)
            
                if Watermark.Background.Color ~= Color3.fromRGB(25, 25, 25) then
                    Watermark.Background.Color = Color3.fromRGB(25, 25, 25)
                end
            
                if Watermark.Background.Position ~= Vector2.new(116, 9) then
                    Watermark.Background.Position = Vector2.new(116, 9)
                end
            
                if Watermark.Background.Filled ~= true then
                    Watermark.Background.Filled = true
                end
            
                if Watermark.Background.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.Background.Visible = Toggles.InterfaceWatermark.Value
                end
            
                Watermark.Background.Size = Vector2.new(Watermark.Text.TextBounds.X + 32, Watermark.Text.TextBounds.Y + 15)
            
                if Watermark.Accent.Color ~= Color3.fromHSV(math.abs(math.sin(tick() / (Options.RainbowSpeed.Value - 51))), 1, 1) and Toggles.RainbowAccent.Value then
                    Watermark.Accent.Color = Color3.fromHSV(math.abs(math.sin(tick() / (Options.RainbowSpeed.Value - 51))), 1, 1)
                elseif Watermark.Accent.Color ~= Color3.new(Options.ColorWatermark.Value.R, Options.ColorWatermark.Value.G, Options.ColorWatermark.Value.B) then
                    Watermark.Accent.Color = Color3.new(Options.ColorWatermark.Value.R, Options.ColorWatermark.Value.G, Options.ColorWatermark.Value.B)
                end
            
                if Watermark.Accent.Position ~= Vector2.new(116, 9) then
                    Watermark.Accent.Position = Vector2.new(116, 9)
                end
            
                if Watermark.Accent.Filled ~= true then
                    Watermark.Accent.Filled = true
                end
            
                if Watermark.Accent.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.Accent.Visible = Toggles.InterfaceWatermark.Value
                end
            
                Watermark.Accent.Size = Vector2.new(Watermark.Text.TextBounds.X + 32, 1)
            
                if Watermark.Accent2.Color ~= Color3.fromHSV(math.abs(math.sin(tick() / (Options.RainbowSpeed.Value - 51))) - 0.04, 1 - 0.04, 1 - 0.04) and Toggles.RainbowAccent.Value then
                    Watermark.Accent2.Color = Color3.fromHSV(math.abs(math.sin(tick() / (Options.RainbowSpeed.Value - 51))) - 0.04, 1 - 0.04, 1 - 0.04)
                elseif Watermark.Accent2.Color ~= Color3.fromRGB((Options.ColorWatermark.Value.R * 255) - 40, (Options.ColorWatermark.Value.G * 255) - 40, (Options.ColorWatermark.Value.B * 255) - 40) then
                    Watermark.Accent2.Color = Color3.fromRGB((Options.ColorWatermark.Value.R * 255) - 40, (Options.ColorWatermark.Value.G * 255) - 40, (Options.ColorWatermark.Value.B * 255) - 40)
                end
            
                if Watermark.Accent2.Position ~= Vector2.new(116, 10) then
                    Watermark.Accent2.Position = Vector2.new(116, 10)
                end
            
                if Watermark.Accent2.Filled ~= true then
                    Watermark.Accent2.Filled = true
                end
            
                if Watermark.Accent2.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.Accent2.Visible = Toggles.InterfaceWatermark.Value
                end
            
                Watermark.Accent2.Size = Vector2.new(Watermark.Text.TextBounds.X + 32, 1)
            
                if Watermark.BorderLine.Color ~= Color3.fromRGB(0, 0, 0) then
                    Watermark.BorderLine.Color = Color3.fromRGB(0, 0, 0)
                end
            
                if Watermark.BorderLine.Position ~= Vector2.new(116, 11) then
                    Watermark.BorderLine.Position = Vector2.new(116, 11)
                end
            
                if Watermark.BorderLine.Filled ~= true then
                    Watermark.BorderLine.Filled = true
                end
            
                if Watermark.BorderLine.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.BorderLine.Visible = Toggles.InterfaceWatermark.Value
                end
            
                Watermark.BorderLine.Size = Vector2.new(Watermark.Text.TextBounds.X + 32, 1)
            
                if Watermark.Icon.Position ~= Vector2.new(116, 12) then
                    Watermark.Icon.Position = Vector2.new(116, 12)
                end
            
                if Watermark.Icon.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.Icon.Visible = Toggles.InterfaceWatermark.Value
                end
            
                if Watermark.Icon.Size ~= Vector2.new(25, 25) then
                    Watermark.Icon.Size = Vector2.new(25, 25)
                end

                if Toggles.WorldAmbience.Value then
                    Lighting.Ambient = Options.ColorInsideAmbience.Value
                    Lighting.OutdoorAmbient = Options.ColorOutsideAmbience.Value
                end

                if Toggles.WorldTime.Value then
                    Lighting.TimeOfDay = Options.WorldTimeAmount.Value
                end

                if Toggles.WorldSaturation.Value then
                    saturationEffect.TintColor = Options.ColorSaturation.Value
                    saturationEffect.Saturation = Options.WorldSaturationAmount.Value / 50
                end
            end))
        end
    end
end

Library:Notify(string.format("Welcome to shambles haxx %s, Version: %s.\nLoaded modules in (%sms.)", shambles.username, shambles.version, math.floor((tick() - load1) * 1000)), 8, true)