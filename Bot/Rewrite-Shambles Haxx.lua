local shambles ={
    workspace = "shambles haxx",
    game = "Phantom Forces",
    version = "2.2.1a",
    username = "office",
}

--[[local WebSocket = Krnl and Krnl.WebSocket.connect("ws://localhost:8023") or syn and syn.websocket.connect("ws://localhost:8023") or WebSocket and WebSocket.connect("ws://localhost:8023")
WebSocket:Send("name-request " ..shambles.username)
WebSocket:Send("game-request " ..shambles.game)]]

local PLRDS = {}
local DWPS = {}
local FCS = {}
local load1 = tick()

local executor = ""

if getexecutorname then
	executor = "script"
end

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

function Ut.AddToGun(Gun)
	if not DWPS[Gun] then
		DWPS[Gun] = {
			Name = Ut.New({type = "Text"}),
            Ammo = Ut.New({type = "Text"}),
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

FCS = {
    AimAssist = Ut.New({type = "Circle"}),
    SilentAim = Ut.New({type = "Circle"}),
}

local game_client = {}
do -- Client Collector
    local garbage = getgc(true)
    local loaded_modules = getloadedmodules()

    for i = 1, #garbage do
        local v = garbage[i]
        if typeof(v) == "table" then
            if rawget(v, "send") and rawget(v, "fetch") then -- Networking Module
                game_client.network = v
            elseif rawget(v, 'goingLoud') and rawget(v, 'isInSight') then -- Useful for Radar Hack or Auto Spot
                game_client.spotting_interface = v
            elseif rawget(v, 'bulletAcceleration') then
                    game_client.bulletAccel = v
            elseif rawget(v, 'setMinimapStyle') and rawget(v, 'setRelHeight') then -- Useful for Radar Hack
                game_client.radar_interface = v
            elseif rawget(v, "getCharacterModel") and rawget(v, 'popCharacterModel') then -- Used for Displaying other Characters
                game_client.third_person_object = v
            elseif rawget(v, "getCharacterObject") then -- Used for sending LocalPlayer Character Data to Server
                game_client.character_interface = v
            elseif rawget(v, "isSprinting") and rawget(v, "getArmModels") then -- Used for sending LocalPlayer Character Data to Server
                game_client.character_object = v
            elseif rawget(v, "updateReplication") and rawget(v, "getThirdPersonObject") then -- This represents a "Player" separate from their character
                game_client.replication_object = v
            elseif rawget(v, "setHighMs") and rawget(v, "setLowMs") then -- Same as above
                game_client.replication_interface = v
            elseif rawget(v, 'setSway') and rawget(v, "_applyLookDelta") then -- You can modify camera values with this
                game_client.main_camera_object = v
            elseif rawget(v, 'getActiveCamera') and rawget(v, "getCameraType") then -- You can modify camera values with this
                game_client.camera_interface = v
            elseif rawget(v, 'getFirerate') and rawget(v, "getFiremode") then -- Weapon Stat Hooks
                game_client.firearm_object = v
            elseif rawget(v, 'canMelee') and rawget(v, "_processMeleeStateChange") then -- Melee Stat Hooks
                game_client.melee_object = v
            elseif rawget(v, 'canCancelThrow') and rawget(v, "canThrow") then -- Grenade Stat Hooks
                game_client.grenade_object = v
            elseif rawget(v, "vote") then -- Useful for Auto Vote
                game_client.votekick_interface = v
            elseif rawget(v, "getActiveWeapon") then -- Useful for getting current weapon
                game_client.weapon_controller_object = v
            elseif rawget(v, "getController") then -- Useful for getting your current weapon
                game_client.weapon_controller_interface = v
            elseif rawget(v, "updateVersion") and rawget(v, "inMenu") then -- Useful for chat spam :)
                game_client.chat_interface = v
            elseif rawget(v, "trajectory") and rawget(v, "timehit") then -- Useful for ragebot (Note: This table is frozen, use setreadonly)
                game_client.physics = v
            elseif rawget(v, "slerp") and rawget(v, "toanglesyx") then -- Useful for angles (Note: This table is frozen, use setreadonly)
                game_client.vector = v
            end
        end
    end

    for i = 1, #loaded_modules do
        local v = loaded_modules[i]
        if v.Name == "PlayerSettingsInterface" then -- I use this for dynamic fov
            game_client.player_settings = require(v)
        elseif v.Name == "PublicSettings" then -- Get world data from here
            game_client.PBS = require(v)
        elseif v.Name == "particle" then -- Useful for silent aim
            game_client.particle = require(v)
        elseif v.Name == "CharacterInterface" then
            game_client.LocalPlayer = require(v)
        elseif v.Name == "WeaponControllerInterface" then
            game_client.WCI = require(v)
        elseif v.Name == "ActiveLoadoutUtils" then
            game_client.active_loadout = require(v)
        elseif v.Name == "GameClock" then
            game_client.game_clock = require(v)
        elseif v.Name == "PlayerDataStoreClient" then
            game_client.player_data = require(v)
        elseif v.Name == "ReplicationInterface" then
            game_client.replication = require(v)
        elseif v.Name == "BulletCheck" then -- Wall Penetration for ragebot
            game_client.bullet_check = require(v)
        elseif v.Name == "WeaponObject" then
            game_client.WeaponObject = require(v)
        end
    end
end

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
local currentAngle 				= 0
local pi 						= math.pi
local cos 						= math.cos
local sin 						= math.sin
local floor 					= math.floor
local rad 						= math.rad
local resolveron 				= false
local PerformanceStats 			= game.Stats.PerformanceStats
local MousePos 					= Vector3.new(UserInputService:GetMouseLocation().x, UserInputService:GetMouseLocation().y, 0)
local PingPerformance			= PerformanceStats.Ping:GetValue()
local devmode 					= true
local CrosshairPos 				= ScreenSize / 2
local curgun					= 0
local gaysex 					= 0
local fake_rep_object 			= nil
local CrosshairLeft             = Crosshair.Left
local CrosshairRight            = Crosshair.Right
local CrosshairTop              = Crosshair.Top
local CrosshairBottom           = Crosshair.Bottom
local CrosshairLeftBorder       = Crosshair.LeftBorder
local CrosshairRightBorder      = Crosshair.RightBorder
local CrosshairTopBorder        = Crosshair.TopBorder
local CrosshairBottomBorder     = Crosshair.BottomBorder
local organizedPlayers          = {}
local ragetarget                = nil
local currentAngle              = 0
local fps                       = 0
local cache                     = {setsway = game_client.main_camera_object.setSway, shake = game_client.main_camera_object.shake, wsway = game_client.WeaponObject.walkSway, gsway = game_client.WeaponObject.gunSway}
local ignorething
local BarrelPos
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

local Window = Library:CreateWindow({Title = 'Shambles Haxx', Center = true, AutoShow = true})

local Tabs = {Rage = Window:AddTab('Rage'), Legit = Window:AddTab('Legit'), Visuals = Window:AddTab('Visuals'), Misc = Window:AddTab('Misc'), ['Settings'] = Window:AddTab('Settings')} 

local RageBot = Tabs.Rage:AddLeftGroupbox('Rage Bot')
RageBot:AddToggle('RageEnabled', {Text = 'Enabled'}):AddKeyPicker('RageKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Rage Bot', NoUI = false})
RageBot:AddDropdown('RageHitscan', {Values = { "Head", "Torso" }, Default = 1, Multi = false, Text = 'Hitscan Priority'})

local AntiAim = Tabs.Rage:AddRightGroupbox('Anti Aim')
AntiAim:AddToggle('AntiEnabled', {Text = 'Enabled'}):AddKeyPicker('AntiKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Anti Aim', NoUI = false})
AntiAim:AddDropdown('AntiPitch', {Values = { "Off", "Up", "Down", "Random", "Sine Wave", "Custom" }, Default = 1, Multi = false, Text = 'Pitch'})
AntiAim:AddDropdown('AntiYaw', {Values = { "Off", "Backwards", "Spin", "Random", "Sine Wave", "Custom" }, Default = 1, Multi = false, Text = 'Yaw'})
AntiAim:AddSlider('AntiSineWave', {Text = 'Sine Wave Speed', Default = 4, Min = 0, Max = 20, Rounding = 0})
AntiAim:AddSlider('AntiCustomYaw', {Text = 'Custom Yaw', Default = 0, Min = 0, Max = 360, Rounding = 0})
AntiAim:AddSlider('AntiCustomPitch', {Text = 'Custom Yaw', Default = 0, Min = -4, Max = 4, Rounding = 0})
AntiAim:AddSlider('AntiSpinRate', {Text = 'Spin Rate', Default = 0, Min = -100, Max = 100, Rounding = 0})
AntiAim:AddDropdown('AntiStance', {Values = { "Off", "Stand", "Crouch", "Prone" }, Default = 1, Multi = false, Text = 'Force Stance'})
AntiAim:AddToggle('AntiHide', {Text = 'Hide In Floor'})

local AimAssist = Tabs.Legit:AddLeftGroupbox('Aim Assist')
AimAssist:AddToggle('AimEnabled', {Text = 'Enabled'}):AddKeyPicker('AimKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Aim Assist', NoUI = false})
AimAssist:AddSlider('AimFov', {Text = 'Field Of View', Default = 30, Min = 1, Max = 360, Rounding = 0})
AimAssist:AddSlider('AimHorizontal', {Text = 'Horizontal Smoothing', Default = 20, Min = 1, Max = 100, Rounding = 0})
AimAssist:AddSlider('AimVertical', {Text = 'Vertical Smoothing', Default = 20, Min = 1, Max = 100, Rounding = 0})
AimAssist:AddToggle('AimVisCheck', {Text = 'Visible Check'})
AimAssist:AddToggle('AimTeam', {Text = 'Target Teammates'})
AimAssist:AddDropdown('AimHitscan', {Values = { "Head", "Torso", "Closest" }, Default = 1, Multi = false, Text = 'Hitscan Priority'})
AimAssist:AddLabel("If your using high sensitivity make your smoothing higher!", true)

local SilentAim = Tabs.Legit:AddRightGroupbox('Silent Aim')
SilentAim:AddToggle('SilentEnabled', {Text = 'Enabled'}):AddKeyPicker('SilentKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Silent Aim', NoUI = false})
SilentAim:AddSlider('SilentFov', {Text = 'Field Of View', Default = 30, Min = 1, Max = 360, Rounding = 0})
SilentAim:AddSlider('SilentHitchance', {Text = 'Hit Chance', Default = 80, Min = 1, Max = 100, Rounding = 0})
SilentAim:AddToggle('SilentVisCheck', {Text = 'Visible Check'})
SilentAim:AddToggle('SilentTeam', {Text = 'Target Teammates'})
SilentAim:AddDropdown('SilentHitscan', {Values = { "Head", "Torso", "Closest" }, Default = 1, Multi = false, Text = 'Hitscan Priority'})

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
EnemyEsp:AddSlider('EnemyEspChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
EnemyEsp:AddSlider('EnemyEspOutlineChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})

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
TeamEsp:AddSlider('TeamEspChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
TeamEsp:AddSlider('TeamEspOutlineChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})

SettingsEsp:AddToggle('EspTarget', {Text = 'Display Target'}):AddColorPicker('ColorTarget', {Default = Color3.fromRGB(255, 0, 0), Title = 'Distance Color'})
SettingsEsp:AddDropdown('TextFont', {Values = { "UI", "System", "Plex", "Monospace" }, Default = 3, Multi = false, Text = 'Text Font'})
SettingsEsp:AddDropdown('TextCase', {Values = { "lowercase", "Normal", "UPPERCASE" }, Default = 2, Multi = false, Text = 'Text Case'})
SettingsEsp:AddSlider('TextSize', {Text = 'Text Size', Default = 13, Min = 1, Max = 34, Rounding = 0})
SettingsEsp:AddSlider('HpVis', {Text = 'Max HP Visibility Cap', Default = 90, Min = 0, Max = 100, Rounding = 0})

local WeaponEsp = Tabs.Visuals:AddLeftGroupbox('Dropped ESP')
WeaponEsp:AddToggle('DroppedWeapon', {Text = 'Weapon'}):AddColorPicker('ColorDroppedWeapon', {Default = Color3.fromRGB(255, 255, 255), Title = 'Weapon Color'})
WeaponEsp:AddToggle('DroppedAmmo', {Text = 'Ammo'}):AddColorPicker('ColorDroppedAmmo', {Default = Color3.fromRGB(255, 255, 255), Title = 'Ammo Color'})

local InterfaceBox = Tabs.Visuals:AddRightTabbox()
local CursorEsp = InterfaceBox:AddTab('Cursor')
local FovEsp = InterfaceBox:AddTab('Field Of View')

CursorEsp:AddToggle('CursorEnabled', {Text = 'Enabled'}):AddColorPicker('ColorCursor', {Default = Color3.fromRGB(255, 255, 0), Title = 'Cursor Color'}):AddColorPicker('ColorCursorBorder', {Default = Color3.fromRGB(0, 0, 0), Title = 'Cursor Border Color'})
CursorEsp:AddSlider('CursorSize', {Text = 'Size', Default = 13, Min = 1, Max = 100, Rounding = 0})
CursorEsp:AddSlider('CursorThickness', {Text = 'Thickness', Default = 2, Min = 1, Max = 50, Rounding = 0})
CursorEsp:AddSlider('CursorGap', {Text = 'Gap', Default = 5, Min = 1, Max = 100, Rounding = 0})
CursorEsp:AddToggle('CursorBarrel', {Text = 'Follow Barrel'})
CursorEsp:AddToggle('CursorBorder', {Text = 'Border'})
CursorEsp:AddToggle('CursorSpin', {Text = 'Spin'})
CursorEsp:AddSlider('CursorSpinSpeed', {Text = 'Spin Speed', Default = 5, Min = 1, Max = 50, Rounding = 0})

FovEsp:AddToggle('FovAimAssist', {Text = 'Aim Assist'}):AddColorPicker('ColorFovAimAssist', {Default = Color3.fromRGB(255, 255, 255), Title = 'Aim Assist Color'})
FovEsp:AddToggle('FovSilent', {Text = 'Silent Aim'}):AddColorPicker('ColorSilent', {Default = Color3.fromRGB(255, 255, 255), Title = 'Silent Color'})
FovEsp:AddToggle('FovBarrel', {Text = 'Follow Barrel'})

local OtherEspBox = Tabs.Visuals:AddRightTabbox()
local LocalEsp = OtherEspBox:AddTab('Local Player')
local WorldEsp = OtherEspBox:AddTab('World Visuals')

LocalEsp:AddToggle('ThirdPerson', {Text = 'Third Person'}):AddKeyPicker('ThirdPersonKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Third Person', NoUI = false})
LocalEsp:AddSlider('ThirdPersonX', {Text = 'X Position', Default = 0, Min = -100, Max = 100, Rounding = 1})
LocalEsp:AddSlider('ThirdPersonY', {Text = 'Y Position', Default = 5, Min = 0, Max = 100, Rounding = 1})
LocalEsp:AddSlider('ThirdPersonZ', {Text = 'Z Position', Default = 5, Min = 0, Max = 100, Rounding = 1})
LocalEsp:AddToggle('GunChams', {Text = 'Gun Chams'}):AddColorPicker('ColorGunChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Gun Chams Color'}):AddColorPicker('ColorGunOutlineChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Gun Outline Chams Color'})
LocalEsp:AddSlider('GunChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
LocalEsp:AddSlider('GunOutlineChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
LocalEsp:AddToggle('ArmChams', {Text = 'Arm Chams'}):AddColorPicker('ColorArmChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Arm Chams Color'}):AddColorPicker('ColorArmOutlineChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Arm Outline Chams Color'})
LocalEsp:AddSlider('ArmChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
LocalEsp:AddSlider('ArmOutlineChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
LocalEsp:AddToggle('BulletTracers', {Text = 'Bullet Tracers'}):AddColorPicker('ColorBulletTracers', {Default = Color3.fromRGB(255, 255, 255), Title = 'Bullet Tracers Color'})
LocalEsp:AddSlider('BulletTracersTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
LocalEsp:AddToggle('NoSway', {Text = 'No Sway'}) 
LocalEsp:AddToggle('NoShake', {Text = 'No Shake'}) 

WorldEsp:AddToggle('WorldAmbience', {Text = 'Ambience'}):AddColorPicker('ColorInsideAmbience', {Default = Color3.fromRGB(255, 255, 255), Title = 'Inside Ambience Color'}):AddColorPicker('ColorOutsideAmbience', {Default = Color3.fromRGB(255, 255, 255), Title = 'Outside Ambience Color'})
WorldEsp:AddToggle('WorldTime', {Text = 'Force Time'})
WorldEsp:AddSlider('WorldTimeAmount', {Text = 'Custom Time', Default = 12, Min = 0, Max = 24, Rounding = 0})
WorldEsp:AddToggle('WorldSaturation', {Text = 'Custom Saturation'}):AddColorPicker('ColorSaturation', {Default = Color3.fromRGB(255, 255, 255), Title = 'Saturation Color'})
WorldEsp:AddSlider('WorldSaturationAmount', {Text = 'Saturation Density', Default = 2, Min = 0, Max = 100, Rounding = 0})

local Movement = Tabs.Misc:AddLeftGroupbox('Movement')
Movement:AddToggle('MovementSpeed', {Text = 'Speed'}):AddKeyPicker('MovementSpeedKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Speed', NoUI = false})
Movement:AddSlider('MovementSpeedAmount', {Text = 'Speed Amount', Default = 60, Min = 1, Max = 80, Rounding = 0})
Movement:AddToggle('MovementFly', {Text = 'Fly'}):AddKeyPicker('MovementFlyKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Fly', NoUI = false})
Movement:AddSlider('MovementFlyAmount', {Text = 'Fly Amount', Default = 60, Min = 1, Max = 80, Rounding = 0})
Movement:AddToggle('MovementAutoJump', {Text = 'Auto Jump'})
Movement:AddToggle('MovementFall', {Text = 'No Fall Damage'})

local Exploits = Tabs.Misc:AddLeftGroupbox('Exploits')
Exploits:AddSlider('ExploitsFireRate', {Text = 'Fire Rate', Default = 100, Min = 50, Max = 5000, Rounding = 0})

local Extra = Tabs.Misc:AddRightGroupbox('Extra')
Extra:AddToggle('AutoDeploy', {Text = 'Auto Deploy'})
Extra:AddToggle('ExtraHeadsound', {Text = 'Head Sound'})
Extra:AddSlider('ExtraHeadsoundVolume', {Text = 'Head Sound Volume', Default = 50, Min = 1, Max = 100, Rounding = 0})
Extra:AddInput('ExtraHeadsoundId', {Default = '1289263994', Numeric = false, Finished = false, Text = 'Head Sound Id', Placeholder = 'Head Sound Id'})
Extra:AddToggle('ExtraBodysound', {Text = 'Body Sound'})
Extra:AddSlider('ExtraBodysoundVolume', {Text = 'Body Sound Volume', Default = 50, Min = 1, Max = 100, Rounding = 0})
Extra:AddInput('ExtraBodysoundId', {Default = '1289263994', Numeric = false, Finished = false, Text = 'Head Sound Id', Placeholder = 'Head Sound Id'})
Extra:AddToggle('ExtraGunSound', {Text = 'Gun Sound'})
Extra:AddInput('ExtraGunsoundId', {Default = '1289263994', Numeric = false, Finished = false, Text = 'Gun Sound Id', Placeholder = 'Gun Sound Id'})
Extra:AddSlider('ExtraGunsoundVolume', {Text = 'Gun Sound Volume', Default = 50, Min = 1, Max = 100, Rounding = 0})
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

--Options.PlayerList.Values = game.Players:GetPlayers(

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

    local third_person_object = fake_rep_object:getThirdPersonObject()
    if third_person_object then
        local character_model = third_person_object:popCharacterModel()
        character_model:Destroy()
        fake_rep_object:despawn()
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

    for _,v in pairs(game.Workspace.Ignore.GunDrop:GetChildren()) do
        Ut.AddToGun(v)
    end

    game.Workspace.Ignore.GunDrop.ChildAdded:Connect(Ut.AddToGun)

    game.Workspace.Ignore.GunDrop.ChildRemoved:Connect(function(Gun)
        if DWPS[Gun] then
            for i,v in pairs(DWPS[Gun]) do
                if v then
                    v:Remove()
                end
            end

            DWPS[Gun] = nil
        end
    end)

    local solve = debug.getupvalue(game_client.physics.timehit, 2);
    local beams = {}

    local function isVisible(position, ignore)
        return #Camera:GetPartsObscuringTarget({ position }, ignore) == 0;
    end

    function CreateBeam(origin_att, ending_att, texture)
        local beam = Instance.new("Beam")
        beam.Texture = texture or "http://www.roblox.com/asset/?id=446111271"
        beam.TextureMode = Enum.TextureMode.Wrap
        beam.TextureSpeed = 8
        beam.LightEmission = 1
        beam.LightInfluence = 1
        beam.TextureLength = 12
        beam.FaceCamera = true
        beam.Enabled = true
        beam.ZOffset = -1
        beam.Transparency = NumberSequence.new((1 - Options.BulletTracersTrans.Value / 255),(1 - Options.BulletTracersTrans.Value / 255))
        beam.Color = ColorSequence.new(Options.ColorBulletTracers.Value, Color3.new(0, 0, 0))
        beam.Attachment0 = origin_att
        beam.Attachment1 = ending_att
        Debris:AddItem(beam, 3)
        Debris:AddItem(origin_att, 3)
        Debris:AddItem(ending_att, 3)

        local speedtween = TweenInfo.new(5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
        Tween:Create(beam, speedtween, { TextureSpeed = 2 }):Play()
        beam.Parent = workspace
        table.insert(beams, { beam = beam, time = tick() })
        return beam
    end

    local function find_2d_distance( pos1, pos2 )
        local dx = pos1.X - pos2.X
        local dy = pos1.Y - pos2.Y
        return math.sqrt ( dx * dx + dy * dy )
    end

    local function getClosest(dir, origin, ignore)
        local _position, _entry;

        game_client.replication.operateOnAllEntries(function(player, entry)
            local tpObject = entry and entry._thirdPersonObject;
            local character = tpObject and tpObject._character;
            if character and player.Team ~= LocalPlayer.Team then
                local part = Options.SilentHitscan.Value == "Head" and character["Head"] or Options.SilentHitscan.Value == "Torso" and character["Torso"] or Options.SilentHitscan.Value == "Closest" and character[math.random() > 0.5 and "Head" or "Torso"]
                local _, OnScreen = Camera:WorldToViewportPoint(character.Torso.Position)
                if not (Toggles.SilentVisCheck.Value and not isVisible(part.Position, ignore)) and math.random(1, 100) <= Options.SilentHitchance.Value then
                    if OnScreen then
                        local product = dir.Unit:Dot((part.Position - origin).Unit);
                        local angle = math.deg(math.acos(product));
                        if find_2d_distance(Camera:WorldToViewportPoint(character.Head.Position), FovPos) > Options.SilentFov.Value * 2 then
                        else
                            _position = part.Position;
                            _entry = entry;
                        end
                    end
                end
            end
        end);

        return _position, _entry;
    end

    local function Mouse_Move(pos, smoothx, smoothy)
        local mouse = LocalPlayer:GetMouse()
        local targetPos = Camera:WorldToScreenPoint(pos)
        local mousePos = Camera:WorldToScreenPoint(mouse.Hit.p)
        mousemoverel((targetPos.X - mousePos.X) / smoothx, (targetPos.Y - mousePos.Y) / smoothy)
    end

    local function trajectory(dir, velocity, accel, speed)
        local t1, t2, t3, t4 = solve(
            accel:Dot(accel) * 0.25,
            accel:Dot(velocity),
            accel:Dot(dir) + velocity:Dot(velocity) - speed^2,
            dir:Dot(velocity) * 2,
            dir:Dot(dir));

        local time = (t1>0 and t1) or (t2>0 and t2) or (t3>0 and t3) or t4;
        local bullet = (dir + velocity*time + 0.5*accel*time^2) / time;
        return bullet, time;
    end 

    function get_character(player)
        local entry = game_client.replication_interface.getEntry(player)

        if entry then
            local third_person_object = entry._thirdPersonObject
            if third_person_object then
                return third_person_object._character
            end
        end
    end

    function get_health(player)
        local entry = game_client.replication_interface.getEntry(player)

        if entry then
            return entry:getHealth()
        end
    end

    function get_alive(player)
        local entry = game_client.replication_interface.getEntry(player)

        if entry then
            return entry._alive
        end
    end

    function get_receivedpos(player) 
        local entry = game_client.replication_interface.getEntry(player)

        if entry then
            local third_person_object = entry._thirdPersonObject
            if third_person_object then
                return third_person_object._replicationObject._receivedPosition, third_person_object._replicationObject._receivedFrameTime, third_person_object._replicationObject._velspring._p0
            end
        end
    end

    function get_weapon(player)
        local entry = game_client.replication_interface.getEntry(player)

        if entry then
            local third_person_object = entry._thirdPersonObject
            if third_person_object then
                return third_person_object._weaponname or ""
            end
        end
    end

    function calculate_player_bounding_box(character)
        local cam = workspace.CurrentCamera.CFrame
        local torso = character.PrimaryPart.CFrame
        local head = character.Head.CFrame
        local top, top_isrendered = workspace.CurrentCamera:WorldToViewportPoint(head.Position + (torso.UpVector * 1) + cam.UpVector)
        local bottom, bottom_isrendered = workspace.CurrentCamera:WorldToViewportPoint(torso.Position - (torso.UpVector * 2.5) - cam.UpVector)

        local minY = math.abs(bottom.y - top.y)
        local sizeX = math.ceil(math.max(math.clamp(math.abs(bottom.x - top.x) * 2.5, 0, minY), minY / 2, 3))
        local sizeY = math.ceil(math.max(minY, sizeX * 0.5, 3))

        if top_isrendered or bottom_isrendered then
            local boxtop = Vector2.new(math.floor(top.x * 0.5 + bottom.x * 0.5 - sizeX * 0.5), math.floor(math.min(top.y, bottom.y)))
            local boxsize = Vector2.new(sizeX, sizeY)
            return boxtop, boxsize 
        end
    end

    local send = game_client.network.send

    local tableinfo = {
        firepos = BarrelPos,
        bullets = {},
        camerapos = BarrelPos,
    }

    game_client.network.send = function(self, command, ...)
        local args = { ... }

        --[[if command == "bullethit" or command == "knifehit" then
            if table.find(menu.friends, args[2].Name) then
                return
            end
        end]]

        if command == "newbullets" then
            if Toggles.ExtraGunSound.Value then
                local gun = Instance.new("Sound")
                gun.Looped = false
                gun.SoundId = "rbxassetid://" ..Options.ExtraGunsoundId.Value
                gun.Volume = Options.ExtraGunsoundVolume.Value / 10
                gun.Parent = workspace
                gun:Play()
            end
        end

        if command == "repupdate" then
            if Toggles.AntiHide.Value and game_client.LocalPlayer.isAlive() then
                args[1] = args[1] - Vector3.new(0, 1.2, 0)
            end
        end

        if command == "newbullets" then
            if Toggles.BulletTracers.Value then
                for k = 1, #args[1].bullets do
                    local bullet = args[1].bullets[k]
                    local origin = args[1].firepos
                    local attach_origin = Instance.new("Attachment", workspace.Terrain)
                    attach_origin.Position = origin
                    local ending = origin + (type(bullet[1]) == "table" and bullet[1].unit.Unit or bullet[1].Unit) * 300
                    local attach_ending = Instance.new("Attachment", workspace.Terrain)
                    attach_ending.Position = ending
                    local beam = CreateBeam(attach_origin, attach_ending)
                    beam.Parent = workspace
                end
            end
        end

        if command == "repupdate" then    
            if Toggles.AntiEnabled.Value and Options.AntiKey:GetState() then
                --{ "Off", "Up", "Down", "Random", "Sine Wave" }
                --{Values = { "Off", "Backwards", "Spin", "Random" }

                local AntiAimPitch = args[2].x
                local AntiAimYaw = args[2].y
                local newa

                if Options.AntiPitch.Value == "Up" then
                    AntiAimPitch = 1.5
                elseif Options.AntiPitch.Value == "Down" then
                    AntiAimPitch = -1.5
                elseif Options.AntiPitch.Value == "Random" then
                    AntiAimPitch = math.random(-2, 2)
                elseif Options.AntiPitch.Value == "Sine Wave" then
                    AntiAimPitch = math.sin(tick() * Options.AntiSineWave.Value) * 2
                elseif Options.AntiPitch.Value == "Custom" then
                    AntiAimPitch = Options.AntiCustomPitch.Value / 2
                end

                if Options.AntiYaw.Value == "Backwards" then
                    AntiAimYaw += math.pi
                elseif Options.AntiYaw.Value == "Spin" then
                    AntiAimYaw = (tick() * Options.AntiSpinRate.Value) % 12
                elseif Options.AntiYaw.Value == "Random" then
                    AntiAimYaw = math.random(99999)
                elseif Options.AntiYaw.Value == "Sine Wave" then
                    AntiAimYaw = math.sin(tick() * Options.AntiSineWave.Value) * 4
                elseif Options.AntiYaw.Value == "Custom" then
                    AntiAimYaw = Options.AntiCustomYaw.Value / 50
                end
                
                newa = newa or Vector2.new(AntiAimPitch, AntiAimYaw)

                args[2] = newa
            end
        end

        if command == "bullethit" then
            Library:Notify(string.format("Hit %s in the %s with a %s.", tostring(args[1]), tostring(args[3]), tostring(game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.name)), 2.5)
            if Toggles.ExtraHeadsound.Value and tostring(args[3]) == "Head" then
                local head = Instance.new("Sound")
                head.Looped = false
                head.Parent = workspace
                head.SoundId = "rbxassetid://" ..Options.ExtraHeadsoundId.Value
                head.Volume = Options.ExtraHeadsoundVolume.Value / 10
                head:Play()
            end

            if Toggles.ExtraBodysound.Value and tostring(args[3]) == "Body" then
                local body = Instance.new("Sound")
                body.Looped = false
                body.Parent = workspace
                body.SoundId = "rbxassetid://" ..Options.ExtraBodysoundId.Value
                body.Volume = Options.ExtraBodysoundVolume.Value / 10
                body:Play()
            end
        end

        if command == "falldamage" then
            if Toggles.MovementFall.Value then
                return
            end
        end

        if command == "stance" then
            local third_person_object = fake_rep_object:getThirdPersonObject()
            if third_person_object then
                local stance = args[1]
                third_person_object:setStance(stance)
            end
        end

        if command == "aim" then
            local third_person_object = fake_rep_object:getThirdPersonObject()
            if third_person_object then
                local aim = args[1]
                third_person_object:setAim(aim)
            end
        end

        if command == "equip" then
            local third_person_object = fake_rep_object:getThirdPersonObject()
            if third_person_object then
                local weapon_index = args[1]
                if weapon_index < 3 then
                    third_person_object:equip(weapon_index)
                elseif weapon_index == 3 then
                    third_person_object:equipMelee(weapon_index)
                end
            end
        end

        if command == "sprint" then
            local third_person_object = fake_rep_object:getThirdPersonObject()
            if third_person_object then
                local sprinting = args[1]
                third_person_object:setSprint(sprinting)
            end
        end

        if command == "stab" then
            local third_person_object = fake_rep_object:getThirdPersonObject()
            if third_person_object then
                third_person_object:stab()
            end
        end

        if command == "spawn" then
            local third_person_object = fake_rep_object:getThirdPersonObject()
            if third_person_object then
                local character_model = third_person_object:popCharacterModel()
                character_model:Destroy()
                fake_rep_object:despawn()
            end

            local current_loadout = game_client.active_loadout.getActiveLoadoutData(game_client.player_data.getPlayerData())
            fake_rep_object:spawn(nil, current_loadout)
        end

        if command == "forcereset" then
            local third_person_object = fake_rep_object:getThirdPersonObject()
            if third_person_object then
                local character_model = third_person_object._character
                character_model:Destroy()
                fake_rep_object:despawn()
            end
        end

        if command == "swapweapon" then
            local third_person_object = fake_rep_object:getThirdPersonObject()
            if third_person_object then
                local weapon_index = args[2]
                local weapon_dropped = args[1]

                if weapon_index < 3 then
                    fake_rep_object._activeWeaponRegistry[weapon_index] = {
                        weaponName = weapon_dropped.Gun.Value,
                        weaponData = game_client.content_database.getWeaponData(weapon_dropped.Gun.Value),
                    }
                else
                    fake_rep_object._activeWeaponRegistry[weapon_index] = {
                        weaponName = weapon_dropped.Knife.Value,
                        weaponData = game_client.content_database.getWeaponData(weapon_dropped.Knife.Value),
                    }
                end
            end
        end

        if command == "repupdate" then
            if Toggles.ThirdPerson.Value and Options.ThirdPersonKey:GetState() and game_client.character_interface:isAlive() then
                local third_person_object = fake_rep_object:getThirdPersonObject()
                if not third_person_object then
                    local weapon_controller = game_client.weapon_controller_interface.getController()
                    fake_rep_object._activeWeaponRegistry[1] = {
                        weaponName = weapon_controller._activeWeaponRegistry[1]._weaponName, 
                        weaponData = weapon_controller._activeWeaponRegistry[1]._weaponData, 
                        attachmentData = weapon_controller._activeWeaponRegistry[1]._weaponAttachments, 
                        camoData = weapon_controller._activeWeaponRegistry[1]._camoList
                    }

                    fake_rep_object._activeWeaponRegistry[2] = {
                        weaponName = weapon_controller._activeWeaponRegistry[2]._weaponName, 
                        weaponData = weapon_controller._activeWeaponRegistry[2]._weaponData, 
                        attachmentData = weapon_controller._activeWeaponRegistry[2]._weaponAttachments, 
                        camoData = weapon_controller._activeWeaponRegistry[2]._camoList
                    }

                    fake_rep_object._activeWeaponRegistry[3] = {
                        weaponName = weapon_controller._activeWeaponRegistry[3]._weaponName, 
                        weaponData = weapon_controller._activeWeaponRegistry[3]._weaponData, 
                        camoData = weapon_controller._activeWeaponRegistry[3]._camoData
                    }

                    fake_rep_object._activeWeaponRegistry[4] = {
                        weaponName = weapon_controller._activeWeaponRegistry[4]._weaponName, 
                        weaponData = weapon_controller._activeWeaponRegistry[4]._weaponData
                    }

                    fake_rep_object._thirdPersonObject = game_client.third_person_object.new(fake_rep_object._player, nil, fake_rep_object)
                    fake_rep_object._thirdPersonObject:equip(weapon_controller._activeWeaponIndex, true)
                    fake_rep_object._alive = true
                end
                local clock_time = game_client.game_clock.getTime()
                local tick = tick()
                local velocity = Vector3.zero

                if fake_rep_object._receivedPosition and fake_rep_object._receivedFrameTime then
                    velocity = (args[1] - fake_rep_object._receivedPosition) / (tick - fake_rep_object._receivedFrameTime);
                end
                
                local broken = false
                if fake_rep_object._lastPacketTime and clock_time - fake_rep_object._lastPacketTime > 0.5 then
                    broken = true
                    fake_rep_object._breakcount = fake_rep_object._breakcount + 1
                end

                fake_rep_object._smoothReplication:receive(clock_time, tick, {
                    t = tick, 
                    position = args[1],
                    velocity = velocity, 
                    angles = args[2], 
                    breakcount = fake_rep_object._breakcount
                }, broken);

                fake_rep_object._updaterecieved = true
                fake_rep_object._receivedPosition = args[1]
                fake_rep_object._receivedFrameTime = tick
                fake_rep_object._lastPacketTime = clock_time
                fake_rep_object:step(3, true)
            else
                local third_person_object = fake_rep_object:getThirdPersonObject()
                if third_person_object then
                    local character_model = third_person_object:popCharacterModel()
                    character_model:Destroy()
                    fake_rep_object:despawn()
                end
            end
        end 

        if command == "newbullets" then
            local third_person_object = fake_rep_object:getThirdPersonObject()
            if third_person_object then
                third_person_object:kickWeapon()
            end
        end

        --[[if args[1] == "newbullets" then
            for k = 1, #args[2].bullets do
                if rage.plr ~= nil then
                    local bullet = args[2].bullets[k]
                    bullet[1] = rage.plr
                else
                    print("nil")
                end
            end
            print(rage.plr)
        end]]

        return send(self, command, table.unpack(args))
    end

    local old_new_index

    old_new_index = hookmetamethod(game, "__newindex", function(self, index, value)
        if checkcaller() then
            return old_new_index(self, index, value)
        end

        if Toggles.ThirdPerson.Value and Options.ThirdPersonKey:GetState() and game_client.character_interface:isAlive() then
            if self == Camera and index == "CFrame" then
                value *= CFrame.new(Options.ThirdPersonX.Value / 18, Options.ThirdPersonY.Value / 18, Options.ThirdPersonZ.Value / 18)
            end
        end

        return old_new_index(self, index, value)
    end)
	
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

    --[[local WebSocket2 = Krnl and Krnl.WebSocket.connect("ws://localhost:8022") or syn and syn.websocket.connect("ws://localhost:8022") or WebSocket and WebSocket.connect("ws://localhost:8022")

    WebSocket2.OnMessage:Connect(function(msg)
        if string.find(msg, "saycmd") then
            game_client.network.send(nil, "chatted", string.sub(msg, 8, #msg)) 
            Library:Notify("You got sent a request\nSay (" ..string.sub(msg, 8, #msg).. ").")
            print(msg)
        elseif string.find(msg, "botcount") then
            game_client.network.send(nil, "chatted", "Clients connected: " ..string.sub(msg, 10, #msg)) 
            Library:Notify("You got sent a request\nBot Count (" ..string.sub(msg, 10, #msg).. ").")
            print(msg)
        elseif string.find(msg, "commands") then
            game_client.network.send(nil, "chatted", string.sub(msg, 10, #msg)) 
            Library:Notify("You got sent a request\nCommands (" ..string.sub(msg, 10, #msg).. ").")
            print(msg)
        elseif msg == "fps" then
            game_client.network.send(nil, "chatted", "Current FPS: " ..tostring(fps)) 
            Library:Notify("You got sent a request\nFPS.")
            print(msg)
        elseif string.find(msg, "fpscap") then
            setfpscap(tonumber(string.sub(msg, 7, #msg)))
            Library:Notify("You got sent a request\nSet FPS cap (" ..string.sub(msg, 9, #msg)..").")
            print(msg)
        elseif string.find(msg, "joke") then
            game_client.network.send(nil, "chatted", string.sub(msg, 6, #msg)) 
            Library:Notify("You got sent a request\nJoke (" ..string.sub(msg, 6, #msg)..").")
            print(msg)
        end
    end)]]

    task.spawn(function()
        while task.wait(Options.ChatSpamDelay.Value) do
            if Toggles.ChatSpam.Value and Library.Unloaded ~= false and game_client.LocalPlayer.isAlive() then
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
    
                game_client.network.send(nil, "chatted", lol) 
            end
        end
    end)

    local raycastparameters = RaycastParams.new()
    local function raycast(origin, direction, filterlist, whitelist)
        raycastparameters.FilterDescendantsInstances = filterlist
        raycastparameters.FilterType = Enum.RaycastFilterType[whitelist and "Whitelist" or "Blacklist"]
        local result = workspace:Raycast(origin, direction, raycastparameters)
        return result and result.Instance, result and result.Position, result and result.Normal
    end

    local function bulletcheck(o, t, p)
        if p <= 0 then
            return false
        end
        
        local ve = t - o
        local n = ve.Unit
        local h, po = raycast(o, ve, ignorething)
    
        if h then
            if h.CanCollide or h.Transparency == 0 then
                local e = h.Size.Magnitude * n
                local nh, dp = raycast(po + e, -e, {h}, true)
                local m = (dp - po).Magnitude
    
                if m >= p then
                    return false
                else
                    p = p - m
                end
            end
    
            return bulletcheck(po + n / 100, t, p)
        end
    
        return true
    end

    local lol = 0

    local function fireratecheck(firerate)
        local curTick = tick()
        local future = curTick + (60 / firerate)
        
        local shoot = curTick > lol
        lol = shoot and future or lol

        return shoot
    end

    do -- Cheat Functions
        do -- Rage Bot
            Library:GiveSignal(rs.RenderStepped:Connect(function()  
                for i,v in pairs(Players:GetPlayers()) do
                    if Toggles.RageEnabled.Value and Options.RageKey:GetState() and get_character(v) and get_alive(v) and  v.Team ~= LocalPlayer.Team and v ~= LocalPlayer and game_client.LocalPlayer.isAlive(v) and game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.name ~= "KNIFE" then
                        local traj = game_client.physics.trajectory(game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart.Position, Vector3.new(0, -192.6, 0), get_character(v).Head.Position, game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.bulletspeed)
                        if bulletcheck(game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart.Position, get_character(v).Head.Position, game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.penetrationdepth) and fireratecheck(game_client.WeaponObject.getFirerate(game_client.WCI:getController()._activeWeaponRegistry[curgun])) then
                            game_client.WCI:getController()._activeWeaponRegistry[curgun]._fireCount = game_client.WCI:getController()._activeWeaponRegistry[curgun]._fireCount + 1
                            tableinfo.bullets[1] = {
                                traj.Unit * game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.bulletspeed, 
                                game_client.WCI:getController()._activeWeaponRegistry[curgun]._fireCount
                            }

                            ragetarget = v

                            game_client.network:send("newbullets", tableinfo, game_client.game_clock.getTime())
                            game_client.network:send("bullethit", v, get_character(v)[Options.RageHitscan.Value].Position, "Head", game_client.WCI:getController()._activeWeaponRegistry[curgun]._fireCount)
                        end
                    end
				end
            end))
        end
        
        do -- ESP Players
            Library:GiveSignal(rs.RenderStepped:Connect(function()
                if game_client.LocalPlayer.isAlive() then
                    tableinfo.camerapos = game_client.LocalPlayer.getCharacterObject()._rootPart.Parent.Head.Position
                    tableinfo.firepos = BarrelPos
                end
                
                for i,v in pairs(Players:GetPlayers()) do
                    local Group = "Enemy"

                    if v.Team == LocalPlayer.Team then
                        Group = "Team"
                    end

                    if Toggles[Group.."EspEnabled"].Value and PLRDS[v] and game_client.LocalPlayer.isAlive() then
                        local PLRD = PLRDS[v]
                        for _,v in pairs (PLRD) do
                            if v.Visible ~= false then
                                v.Visible = false
                            end
                        end

                        local Character = get_character(v)
                        local Alive = get_alive(v)
                        if Character and Alive then
                            local _, OnScreen = Camera:WorldToViewportPoint(Character.Torso.Position)
                            if OnScreen then
                                local Pos, Size = calculate_player_bounding_box(Character)
                                if Pos and Size then
                                    local Cur_Health, Max_Health = get_health(v)
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

                                    if Toggles[Group.."EspWeapon"].Value then
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
                                            if Weapon.Text ~= get_weapon(v) then
                                                Weapon.Text = get_weapon(v)
                                            end
                                        elseif Options.TextCase.Value == "UPPERCASE" then
                                            if Weapon.Text ~= string.upper(get_weapon(v)) then
                                                Weapon.Text = string.upper(get_weapon(v))
                                            end
                                        elseif Options.TextCase.Value == "lowercase" then
                                            if Weapon.Text ~= string.lower(get_weapon(v)) then
                                                Weapon.Text = string.lower(get_weapon(v))
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
                                        if Distance.Text ~= tostring(math.ceil(LocalPlayer:DistanceFromCharacter(Character.Torso.Position) / 5)).."M" then
                                            Distance.Text = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(Character.Torso.Position) / 5)).."M"
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

                                    local ptos = Camera.CFrame:PointToObjectSpace(Character.Torso.Position)
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

        do -- ESP Weapons
            Library:GiveSignal(rs.RenderStepped:Connect(function()
                for i,v in pairs(game.Workspace.Ignore.GunDrop:GetChildren()) do
                    if v.Name == "Dropped" and DWPS[v] and v:FindFirstChild("Slot1") and game_client.LocalPlayer.isAlive() then
                        local DWP = DWPS[v]
                        for i1, v1 in pairs (DWP) do
                            if type(v1) ~= "boolean" then
                                v1.Visible = false
                            end
                        end
            
                        local SlotPos = v:FindFirstChild("Slot1").Position
            
                        local Pos, OnScreen = Camera:WorldToScreenPoint(SlotPos)
                        
                        local GunDistance = math.ceil(game.Players.LocalPlayer:DistanceFromCharacter(SlotPos))
                
                        if OnScreen and v:FindFirstChild("Gun") and v:FindFirstChild("Spare") and GunDistance < 90 then
                            local Name = DWP.Name
                            local Ammo = DWP.Ammo
            
                            if Toggles.DroppedWeapon.Value then
                                Name.Visible = true
                                Name.Font = Drawing.Fonts[Options.TextFont.Value]
                                Name.Size = Options.TextSize.Value
                                Name.Color = Options.ColorDroppedWeapon.Value
                                Name.Position = Vector2.new(math.floor(Pos.x), math.floor(Pos.y + 25))
                                Name.Transparency = 1.41177 - ((GunDistance * 4) / 255)
                                Name.Center = true
                                Name.Text = v.Gun.Value
                                Name.Outline = true

                                if Toggles.DroppedAmmo.Value then
                                    Ammo.Visible = true
                                    Ammo.Font = Drawing.Fonts[Options.TextFont.Value]
                                    Ammo.Size = Options.TextSize.Value
                                    Ammo.Color = Options.ColorDroppedAmmo.Value
                                    Ammo.Position = Vector2.new(math.floor(Pos.x), math.floor(Pos.y + 25 + Name.TextBounds.Y))
                                    Ammo.Transparency = 1.41177 - ((GunDistance * 4) / 255)
                                    Ammo.Center = true
                                    Ammo.Text = tostring(v.Spare.Value)
                                    Ammo.Outline = true
                                end
                            end
                        end
                    else
                        for i1, v1 in pairs (DWPS[v]) do
                            if type(v1) ~= "boolean" then
                                v1.Visible = false
                            end
                        end
            
                    end
                end
            end))
        end

        do -- Movement
            Library:GiveSignal(rs.RenderStepped:Connect(function()
                if game_client.LocalPlayer.isAlive() then
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

                if game_client.LocalPlayer.isAlive() then
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

                if not game_client.LocalPlayer.isAlive() and Toggles.AutoDeploy.Value then
                    game_client.character_interface.spawn()
                end

                if game_client.LocalPlayer.isAlive() then
                    game_client.WeaponObject.walkSway = function(...) 
                        if Toggles.NoSway.Value then 
                            return CFrame.new()
                        end
                    end
                    game_client.WeaponObject.gunSway = function(...) 
                        if Toggles.NoSway.Value then 
                            return CFrame.new()
                        end
                    end
                end
                
                if game_client.LocalPlayer.isAlive() then
                    curgun = game_client.WCI:getController()._activeWeaponIndex
                end

                if Toggles.FovBarrel.Value and game_client.LocalPlayer.isAlive() and game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart ~= nil and game_client.WCI:getController()._activeWeaponRegistry[curgun] then
                    local hit, hitpos, normal = workspace:FindPartOnRayWithIgnoreList(Ray.new(game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart.Position, game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart.Parent.Trigger.CFrame.LookVector * 100), { workspace.Ignore, Camera }, false, true)	

                    FovPos = Camera:WorldToViewportPoint(hitpos + normal * 0.01)
                else
                    FovPos = ScreenSize / 2
                end

                if Toggles.CursorBarrel.Value and game_client.LocalPlayer.isAlive() and game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart ~= nil and game_client.WCI:getController()._activeWeaponRegistry[curgun] then
                    local hit, hitpos, normal = workspace:FindPartOnRayWithIgnoreList(Ray.new(game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart.Position, game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart.Parent.Trigger.CFrame.LookVector * 100), { workspace.Ignore, Camera }, false, true)	
                    local nigga = Camera:WorldToViewportPoint(hitpos + normal * 0.01)

                    CrosshairPos = Vector2.new(nigga.x, nigga.y)
                else
                    CrosshairPos = ScreenSize / 2
                end

                if game_client.LocalPlayer.isAlive() and game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart ~= nil then
                    BarrelPos = game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart.Position
                end

                if Toggles.CursorEnabled.Value and game_client.LocalPlayer.isAlive() then
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
                
                if Toggles.CursorEnabled.Value and Toggles.CursorBorder.Value and game_client.LocalPlayer.isAlive() then
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

                if Toggles.FovAimAssist.Value and game_client.LocalPlayer.isAlive() then
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
                else
                    if FCS.AimAssist.Visible ~= false then
                        FCS.AimAssist.Visible = false
                    end
                end

                if Toggles.FovSilent.Value and game_client.LocalPlayer.isAlive() then
                    FCS.SilentAim.Position = FovPos
                    if FCS.SilentAim.Visible ~= true then
                        FCS.SilentAim.Visible = true
                    end
                    if FCS.SilentAim.Color ~= Options.ColorSilent.Value then
                        FCS.SilentAim.Color = Options.ColorSilent.Value
                    end
                    if FCS.SilentAim.Radius ~= Options.SilentFov.Value * 2 then
                        FCS.SilentAim.Radius = Options.SilentFov.Value * 2
                    end
                else
                    if FCS.SilentAim.Visible ~= false then
                        FCS.SilentAim.Visible = false
                    end
                end
                
                if game_client.LocalPlayer.isAlive() and Toggles.ExtraGunSound.Value and game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.name ~= "KNIFE" then
                    game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.firesoundid = "rbxassetid://"
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

        do -- Third Person
            local player = Instance.new("Player")
            fake_rep_object = game_client.replication_object.new(player)
            fake_rep_object._player = LocalPlayer
            player:Destroy()
            player = nil
    
            if game_client.character_interface:isAlive() and game_client.weapon_controller_interface.getController() then
                local weapon_controller = game_client.weapon_controller_interface.getController()
    
                fake_rep_object._activeWeaponRegistry[1] = {
                    weaponName = weapon_controller._activeWeaponRegistry[1]._weaponName, 
                    weaponData = weapon_controller._activeWeaponRegistry[1]._weaponData, 
                    attachmentData = weapon_controller._activeWeaponRegistry[1]._weaponAttachments, 
                    camoData = weapon_controller._activeWeaponRegistry[1]._camoList
                }
    
                fake_rep_object._activeWeaponRegistry[2] = {
                    weaponName = weapon_controller._activeWeaponRegistry[2]._weaponName, 
                    weaponData = weapon_controller._activeWeaponRegistry[2]._weaponData, 
                    attachmentData = weapon_controller._activeWeaponRegistry[2]._weaponAttachments, 
                    camoData = weapon_controller._activeWeaponRegistry[2]._camoList
                }
    
                fake_rep_object._activeWeaponRegistry[3] = {
                    weaponName = weapon_controller._activeWeaponRegistry[3]._weaponName, 
                    weaponData = weapon_controller._activeWeaponRegistry[3]._weaponData, 
                    camoData = weapon_controller._activeWeaponRegistry[3]._camoData
                }
    
                fake_rep_object._activeWeaponRegistry[4] = {
                    weaponName = weapon_controller._activeWeaponRegistry[4]._weaponName, 
                    weaponData = weapon_controller._activeWeaponRegistry[4]._weaponData
                }
    
                fake_rep_object._thirdPersonObject = game_client.third_person_object.new(fake_rep_object._player, nil, fake_rep_object)
                fake_rep_object._thirdPersonObject:equip(1, true)
                fake_rep_object._alive = true
            end
        end

        do -- Gun Chams and arm chams
            Library:GiveSignal(rs.RenderStepped:Connect(function()
                for i,v in pairs(Camera:GetChildren()) do
                    if v.Name == "Main" then
                        if Toggles.GunChams.Value then
                            if not v:FindFirstChild("Highlight") then
                                local Highlight = Instance.new("Highlight", v)
                            end

                            if v.Highlight.DepthMode ~= Enum.HighlightDepthMode.Occluded then
                                v.Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                            end

                            if v.Highlight.FillColor ~= Options.ColorGunChams.Value then
                                v.Highlight.FillColor = Options.ColorGunChams.Value
                            end

                            if v.Highlight.OutlineColor ~= Options.ColorGunOutlineChams.Value then
                                v.Highlight.OutlineColor = Options.ColorGunOutlineChams.Value
                            end

                            if v.Highlight.FillTransparency ~= 1 - Options.GunChamsTrans.Value / 255 then
                                v.Highlight.FillTransparency = 1 - Options.GunChamsTrans.Value / 255
                            end

                            if v.Highlight.OutlineTransparency ~= 1 - Options.GunOutlineChamsTrans.Value / 255 then
                                v.Highlight.OutlineTransparency = 1 - Options.GunOutlineChamsTrans.Value / 255
                            end

                            if v.Highlight.Enabled ~= true then
                                v.Highlight.Enabled = true
                            end
                        else
                            if v:FindFirstChild("Highlight") then
                                v.Highlight:Remove()
                            end
                        end
                    end

                    if v.Name == "Left Arm" or v.Name == "Right Arm" then
                        if Toggles.ArmChams.Value then
                            if not v:FindFirstChild("Highlight") then
                                local Highlight = Instance.new("Highlight", v)
                            end

                            if v.Highlight.DepthMode ~= Enum.HighlightDepthMode.Occluded then
                                v.Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                            end

                            if v.Highlight.FillColor ~= Options.ColorArmChams.Value then
                                v.Highlight.FillColor = Options.ColorArmChams.Value
                            end

                            if v.Highlight.OutlineColor ~= Options.ColorArmOutlineChams.Value then
                                v.Highlight.OutlineColor = Options.ColorArmOutlineChams.Value
                            end

                            if v.Highlight.FillTransparency ~= 1 - Options.ArmChamsTrans.Value / 255 then
                                v.Highlight.FillTransparency = 1 - Options.ArmChamsTrans.Value / 255
                            end

                            if v.Highlight.OutlineTransparency ~= 1 - Options.ArmOutlineChamsTrans.Value / 255 then
                                v.Highlight.OutlineTransparency = 1 - Options.ArmOutlineChamsTrans.Value / 255
                            end

                            if v.Highlight.Enabled ~= true then
                                v.Highlight.Enabled = true
                            end
                        else
                            if v:FindFirstChild("Highlight") then
                                v.Highlight:Remove()
                            end
                        end
                    end
                end
            end))
        end

        do -- Aimbot
            Library:GiveSignal(rs.RenderStepped:Connect(function()  
                PingPerformance = PerformanceStats.Ping:GetValue()

                for i,v in pairs(Players:GetPlayers()) do
                    if Toggles.AimEnabled.Value and Options.AimKey:GetState() then
                        organizedPlayers = {}

                        if v == LocalPlayer then continue end		

                        local Character = get_character(v)
                        local Alive = get_alive(v)

                        if not Alive then continue end

                        if not Toggles.AimTeam.Value and v.Team and v.Team == LocalPlayer.Team then continue end

                        if Character then
                            local Head = Character:FindFirstChild("Head")

                            local _,OnScreen = Camera:WorldToViewportPoint(Character.Torso.Position)
                            local Pos = Camera:WorldToViewportPoint(Character.Torso.Position)

                            if Options.AimFov.Value * 2 ~= 0 then
                                if find_2d_distance(Pos, FovPos) > Options.AimFov.Value * 2 then
                                    continue
                                end
                            end

                            if Toggles.AimVisCheck.Value then
                                if OnScreen then
                                    if isVisible(Character.Torso.Position, ignorething) then
                                        table.insert(organizedPlayers, v)
                                    end
                                else
                                    if table.find(organizedPlayers, v) then
                                        table.remove(organizedPlayers, v)
                                    end
                                end
                            else
                                if OnScreen then
                                    table.insert(organizedPlayers, v)
                                else
                                    if table.find(organizedPlayers, v) then
                                        table.remove(organizedPlayers, v)
                                    end
                                end
                            end

                            for i,v in pairs(organizedPlayers) do
                                if get_alive(v) then
                                    local Hitbox = Character:FindFirstChild("Head")

                                    if Options.AimHitscan == "Head" then
                                        Hitbox = Character:FindFirstChild("Head")
                                    elseif Options.AimHitscan == "Torso" then
                                        Hitbox = Character:FindFirstChild("HumanoidRootPart")
                                    elseif Options.AimHitscan == "Closest" then
                                        local HeadPos  = Camera:WorldToViewportPoint(Character:FindFirstChild("Head").Position)
                                        local TorsoPos = Camera:WorldToViewportPoint(Character:FindFirstChild("Torso").Position)
                            
                                        local HeadDistance  = (Vector2.new(HeadPos.X, HeadPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                                        local TorsoDistance = (Vector2.new(TorsoPos.X, TorsoPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                            
                                        Hitbox = HeadDistance < TorsoDistance and Character:FindFirstChild("Head") or Character:FindFirstChild("Torso")
                                    end
                                    local Pos = Hitbox.Position

                                    if OnScreen then
                                        --if find_2d_distance(Pos, FovPos) < menu:GetVal("Combat", "Aim Assist", "Deadzone") * 3 then
                                            local Ps = Vector3.new(Pos.X, Pos.Y, Pos.Z)
                                            Mouse_Move(Ps, Options.AimHorizontal.Value + 1, Options.AimVertical.Value + 1)
                                            return
                                        --end
                                    end
                                end
                            end
                        end
                    end
                end
            end))
        end

        do -- Silent Aim
            local old;
            old = hookfunction(game_client.particle.new, function(args)
                if debug.getinfo(2).name == "fireRound" then
                    if Toggles.SilentEnabled.Value and Options.SilentKey:GetState() then
                        local position, entry = getClosest(args.velocity, args.visualorigin, args.physicsignore);
                        if position and entry then
                            local index = table.find(debug.getstack(2), args.velocity);
        
                            args.velocity = trajectory(
                                position - args.visualorigin,
                                entry._velspring.p,
                                -args.acceleration,
                                args.velocity.Magnitude);
        
                            debug.setstack(2, index, args.velocity);
                        end
                    end
                end

                ignorething = args.physicsignore;

                return old(args);
            end)
        end

        do -- Camera
            game_client.main_camera_object.setSway = function(self, amount)
                local sway = Toggles.NoSway.Value and 0 or amount
            
                return cache.setsway(self, sway)
            end
            
            game_client.main_camera_object.shake = function(self, amount)
                local shake = Toggles.NoShake.Value and Vector3.zero or amount
            
                return cache.shake(self, shake)
            end
        end

        do -- Stance
            Library:GiveSignal(rs.RenderStepped:Connect(function()  
                if game_client.LocalPlayer.isAlive() and Toggles.AntiEnabled.Value then
                    if Options.AntiStance.Value ~= "Off" then
                        game_client.network.send(game_client.network, "stance", string.lower(Options.AntiStance.Value))
                    end
                end
            end))
        end
    end
end

Library:Notify(string.format("Welcome to shambles haxx %s, Version: %s.\nLoaded modules in (%sms.)", shambles.username, shambles.version, math.floor((tick() - load1) * 1000)), 8, true)