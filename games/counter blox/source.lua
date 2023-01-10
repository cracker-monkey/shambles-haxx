local PLRDS = {}
local load1 = tick()

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

local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local RunService = game.RunService
local ReplicatedStorage = game.ReplicatedStorage
local HitPart = ReplicatedStorage.Events:FindFirstChild("HitNN") or ReplicatedStorage.Events:FindFirstChild("Hit") or ReplicatedStorage.Events:FindFirstChild("HitPart")
local Camera = workspace.Camera
local UserInputService = game.UserInputService
local client = getsenv(LocalPlayer.PlayerGui.Client)
local clock = 0
local LastStep
local fps = 0
local rtar = nil
local AWParams = RaycastParams.new(); AWParams.FilterType = Enum.RaycastFilterType.Blacklist
local AWBackParams = RaycastParams.new(); AWBackParams.FilterType = Enum.RaycastFilterType.Whitelist

getgenv().Friends = {}
getgenv().Priority = {}

getgenv().Tabs = {
    Rage = Window:AddTab('Rage'), 
    Visuals = Window:AddTab('Visuals'), 
    Misc = Window:AddTab('Misc'), 
    Settings = Window:AddTab('Settings'), 
    Lua = Window:AddTab("Lua")
} 

function icons()
    local list = listfiles("shambles haxx/Configs/icons")

    local icons = {"N/A"}
    for i = 1, #list do
        local file = list[i]
        if file:sub(-4) == '.png' then
            local pos = file:find('.png', 1, true)
            local start = pos

            local char = file:sub(pos, pos)
            while char ~= '/' and char ~= '\\' and char ~= '' do
                pos = pos - 1
                char = file:sub(pos, pos)
            end

            if char == '/' or char == '\\' then
                table.insert(icons, file:sub(pos + 1, start - 1))
            end
        end
    end

    return icons;
end 

do -- Menu things
    do -- Rage Tab
        local RageBot = Tabs.Rage:AddLeftGroupbox("Rage Bot") do
            RageBot:AddToggle('RageEnabled', {Text = 'Enabled'}):AddKeyPicker('RageKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Rage Bot', NoUI = false})
            RageBot:AddDropdown('RageHitscan', {Values = { "Head", "Torso" }, Default = 1, Multi = false, Text = 'Hitscan Priority'})
            RageBot:AddToggle('RageForwardTrack', {Text = 'Forward Track'})
            RageBot:AddSlider('RageForwardTrackAmount', {Text = 'Amount', Default = 1, Min = 0, Max = 2000, Rounding = 0})
        end
    end
     
    do -- Visuals Tab
        local EnemyEspBox = Tabs.Visuals:AddLeftTabbox() do        
            local EnemyEsp = EnemyEspBox:AddTab('Enemy ESP') do
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
            end
            
            local TeamEsp = EnemyEspBox:AddTab('Team ESP') do
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
            end
            
            local SettingsEsp = EnemyEspBox:AddTab('Settings') do
                SettingsEsp:AddToggle('EspTarget', {Text = 'Display Target'}):AddColorPicker('ColorTarget', {Default = Color3.fromRGB(255, 0, 0), Title = 'Distance Color'})
                SettingsEsp:AddDropdown('TextFont', {Values = { "UI", "System", "Plex", "Monospace" }, Default = 3, Multi = false, Text = 'Text Font'})
                SettingsEsp:AddDropdown('TextCase', {Values = { "lowercase", "Normal", "UPPERCASE" }, Default = 2, Multi = false, Text = 'Text Case'})
                SettingsEsp:AddSlider('TextSize', {Text = 'Text Size', Default = 13, Min = 1, Max = 34, Rounding = 0})
                SettingsEsp:AddSlider('HpVis', {Text = 'Max HP Visibility Cap', Default = 90, Min = 0, Max = 100, Rounding = 0})
            end
        end

        local LocalEsp = Tabs.Visuals:AddRightGroupbox('Local') do
            LocalEsp:AddToggle('ThirdPerson', {Text = 'Third Person'}):AddKeyPicker('ThirdPersonKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Third Person', NoUI = false})
            LocalEsp:AddSlider('ThirdPersonDistance', {Text = 'Distance', Default = 0, Min = 0, Max = 100, Rounding = 1}) 
        end

        local WorldEsp = Tabs.Visuals:AddRightGroupbox('World Visuals') do
            WorldEsp:AddToggle('WorldAmbience', {Text = 'Ambience'}):AddColorPicker('ColorInsideAmbience', {Default = Color3.fromRGB(255, 255, 255), Title = 'Inside Ambience Color'}):AddColorPicker('ColorOutsideAmbience', {Default = Color3.fromRGB(255, 255, 255), Title = 'Outside Ambience Color'})
            WorldEsp:AddToggle('WorldTime', {Text = 'Force Time'})
            WorldEsp:AddSlider('WorldTimeAmount', {Text = 'Custom Time', Default = 12, Min = 0, Max = 24, Rounding = 0})
            WorldEsp:AddToggle('WorldSaturation', {Text = 'Custom Saturation'}):AddColorPicker('ColorSaturation', {Default = Color3.fromRGB(255, 255, 255), Title = 'Saturation Color'})
            WorldEsp:AddSlider('WorldSaturationAmount', {Text = 'Saturation Density', Default = 2, Min = 0, Max = 100, Rounding = 0})
        end
    end

    do -- Misc Tab
        local Movement = Tabs.Misc:AddLeftGroupbox('Movement') do
            Movement:AddToggle('MovementSpeed', {Text = 'Speed'}):AddKeyPicker('MovementSpeedKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Speed', NoUI = false})
            Movement:AddSlider('MovementSpeedAmount', {Text = 'Speed Amount', Default = 60, Min = 1, Max = 500, Rounding = 0})
            Movement:AddToggle('MovementFly', {Text = 'Fly'}):AddKeyPicker('MovementFlyKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Fly', NoUI = false})
            Movement:AddSlider('MovementFlyAmount', {Text = 'Fly Amount', Default = 60, Min = 1, Max = 500, Rounding = 0})
            Movement:AddToggle('MovementAutoJump', {Text = 'Auto Jump'})
        end
    end

    do -- Settings Tab
        local MenuGroup = Tabs['Settings']:AddLeftGroupbox('Menu') do
            MenuGroup:AddButton('Unload', function() Library:Unload() end)
            MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' }) 
        end
        
        do     
            load1 = tick()

            Library.ToggleKeybind = Options.MenuKeybind
            ThemeManager:SetLibrary(Library)
            SaveManager:SetLibrary(Library)
            SaveManager:IgnoreThemeSettings() 
            SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 
            ThemeManager:SetFolder("shambles haxx/Configs/counter blox/")
            SaveManager:SetFolder("shambles haxx/Configs/counter blox/")
            SaveManager:BuildConfigSection(Tabs.Settings) 
            ThemeManager:ApplyToTab(Tabs.Settings)
    
            Library:OnUnload(function()
                for i,v in pairs (Players:GetPlayers()) do
                    if PLRDS[v] then
                        for i, v in pairs(PLRDS[v]) do
                            v:Remove()
                        end
                    end
                end

                for i,v in pairs(Watermark) do
                    v:Remove()
                end
            
                Library.Unloaded = true
            end)
        end
        
        local PlayerList = Tabs.Settings:AddRightGroupbox("Player List") do
            PlayerList:AddDropdown('PlayerList', {Values = {}, Default = 1, Multi = false, Text = 'Player List'})
            PlayerList:AddButton('Refresh', function()
                for i,v in pairs(Players:GetPlayers()) do   
                    if not table.find(Options.PlayerList.Values, v.Name) and v.Name ~= LocalPlayer.Name then
                        table.insert(Options.PlayerList.Values, v.Name)
                        Options.PlayerList:SetValues()
                        Options.PlayerList:SetValue(nil)
                    end
                end
            end)
            PlayerList:AddButton('Friend', function()
                if not table.find(Friends, Options.PlayerList.Value) then
                    table.insert(Friends, Options.PlayerList.Value)
                    Library:Notify("Friended player " ..Options.PlayerList.Value.. ".", 2.5)
                elseif table.find(Friends, Options.PlayerList.Value) then
                    for i1, v1 in pairs(Options.PlayerList.Values) do
                        if Options.PlayerList.Value == v1 then
                            table.remove(Friends, i1)
                        end
                    end
                    Library:Notify("Un-Friended player " ..Options.PlayerList.Value.. ".", 2.5)
                end
            end)
            PlayerList:AddButton('Prioritize', function()
                if not table.find(Priority, Options.PlayerList.Value) then
                    table.insert(Priority, Options.PlayerList.Value)
                    Library:Notify("Prioritized player " ..Options.PlayerList.Value.. ".", 2.5)
                elseif table.find(Priority, Options.PlayerList.Value) then
                    for i1, v1 in pairs(Options.PlayerList.Values) do
                        if Options.PlayerList.Value == v1 then
                            table.remove(Priority, i1)
                        end
                    end
                    Library:Notify("Un-Prioritized player " ..Options.PlayerList.Value.. ".", 2.5)
                end
            end)
        end

        local Interface = Tabs.Settings:AddRightGroupbox("Interface") do
            Interface:AddToggle('InterfaceKeybinds', {Text = 'Keybinds'})
            Interface:AddToggle('InterfaceWatermark', {Text = 'Watermark', Default = true}):AddColorPicker('ColorWatermark', {Default = Color3.fromRGB(0, 140, 255), Title = 'Watermark Color'})
            Interface:AddDropdown('WatermarkIcon', {Values = icons(), Default = 1, Multi = false, Text = 'Custom Logo'})
            Interface:AddButton('Refresh', function()
                Options.WatermarkIcon.Values = icons()
                Options.WatermarkIcon:SetValues()
                Options.WatermarkIcon:SetValue("N/A")
            end)
            Interface:AddInput('WatermarkText', {Default = 'Shambles Haxx | {user} | {fps} fps | {ping} ms | {version}', Numeric = false, Finished = false, Text = 'Custom Watermark', Placeholder = 'Watermark Text', Tooltip = "{user}, {hour}, {minute}, {second}\n{ap}, {month}, {day}, {year}\n{version}, {fps}, {ping}, {game}\n{time}, {date}"})   
            Interface:AddToggle('RainbowAccent', {Text = 'Rainbow Accent'})
            Interface:AddSlider('RainbowSpeed', {Text = 'Rainbow Speed', Default = 40, Min = 1, Max = 50, Rounding = 0})
            SaveManager:LoadAutoloadConfig()
        end 

        do
            if isfile("shambles haxx/Configs/icons/"..Options.WatermarkIcon.Value..".png") then
                Watermark.Icon.Data = readfile("shambles haxx/Configs/icons/"..Options.WatermarkIcon.Value..".png")
            else
                Watermark.Icon.Data = readfile("")
            end
        
            Options.WatermarkIcon:OnChanged(function()
                if isfile("shambles haxx/Configs/icons/"..Options.WatermarkIcon.Value..".png") then
                    Watermark.Icon.Data = readfile("shambles haxx/Configs/icons/"..Options.WatermarkIcon.Value..".png")
                else
                    Watermark.Icon.Data = readfile("")
                end
            end)
        
            Library:SetWatermarkVisibility(false)
            Library.KeybindFrame.Visible = Toggles.InterfaceKeybinds.Value
        
            Toggles.InterfaceKeybinds:OnChanged(function()
                Library.KeybindFrame.Visible = Toggles.InterfaceKeybinds.Value
            end)   
        end
    end
end

do -- Functions
    function hitpart_args(hitbox, position, mod)
        return {
            [1] = hitbox,
            [2] = position,
            [3] = LocalPlayer.Character.EquippedTool.Value,
            [4] = 100,
            [5] = LocalPlayer.Character.Gun,
            [8] = 10,
            [9] = true,
            [10] = true,
            [11] = Vector3.zero,
            [12] = 100,
            [13] = Vector3.zero
        }
    end

    function isAlive(player)
        if not player then player = LocalPlayer end
        return player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildWhichIsA("Humanoid").Health > 0 and true or false
	end

    function calculate_player_bounding_box(character)
        local Pos = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
        local CSize = (Camera:WorldToViewportPoint(character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(character.HumanoidRootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2
        local BoxSize = Vector2.new(math.floor(CSize * 1.2), math.floor(CSize * 2))
        local BoxPos = Vector2.new(math.floor(Pos.X - CSize * 1 / 2), math.floor(Pos.Y - CSize * 1.6 / 2))

        return BoxPos, BoxSize
    end

    function rotateVector2(v2, r)
        local c = math.cos(r);
        local s = math.sin(r);
        return Vector2.new(c * v2.X - s*v2.Y, s*v2.X + c*v2.Y)
    end

    function raycast(origin, direction, filterlist, whitelist)
        raycastparameters.FilterDescendantsInstances = filterlist
        raycastparameters.FilterType = Enum.RaycastFilterType[whitelist and "Whitelist" or "Blacklist"]
        local result = workspace:Raycast(origin, direction, raycastparameters)
        return result and result.Instance, result and result.Position, result and result.Normal
    end

    function findtextrandom(text)
		if text:find(' @r ') then 
			local b = text:split(' @r ')
			return b[math.random(#b)]
		else 
			return text
		end
	end

	function textboxtriggers(text)
        local triggers = {
            ['{user}'] = username,
            ['{hour}'] = os.date("%H"),
            ['{minute}'] = os.date("%M"),
            ['{second}'] = os.date("%S"),
            ['{ap}'] = os.date("%p"),
            ['{month}'] = os.date("%b"),
            ['{day}'] = os.date("%d"),
            ['{year}'] = os.date("%Y"),
            ['{version}'] = "0.0.8a",
            ['{fps}'] = fps,
            ['{ping}'] = game:GetService('Stats') ~= nil and math.floor(game:GetService('Stats').Network.ServerStatsItem["Data Ping"]:GetValue()) or "0",
            ['{game}'] = "counter blox",
            ['{time}'] = os.date("%H:%M:%S"),
            ['{date}'] = os.date("%b. %d, %Y")
         }        

		for a,b in next, triggers do 
			text = string.gsub(text, a, b)
		end

		return findtextrandom(text)
	end
end

do -- Modules
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

    do -- ESP Players
        Library:GiveSignal(RunService.RenderStepped:Connect(function()                
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

                    local Box = PLRD.Box
                    local BoxFill = PLRD.BoxFill
                    local BoxOutline = PLRD.BoxOutline
                    local Name = PLRD.Name
                    local Weapon = PLRD.Weapon
                    local Health = PLRD.Health
                    local HealthOutline = PLRD.HealthOutline
                    local HealthNumber = PLRD.HealthNumber
                    local Distance = PLRD.Distance

                    local Character = v.Character
                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                        local Lol, OnScreen = Camera:WorldToViewportPoint(Character.HumanoidRootPart.Position)
                        local Cur_Health, Max_Health = Character:FindFirstChildWhichIsA("Humanoid").Health, Character:FindFirstChildWhichIsA("Humanoid").MaxHealth
                        if OnScreen then
                            local Pos, Size = calculate_player_bounding_box(Character)
                            if Pos and Size then
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

                                OutOfView.PointA = floor_vector2(pos)
                                OutOfView.PointB = floor_vector2(pos - rotateVector2(dir, math.rad(35)) * Options[Group.."EspOutOfViewSize"].Value)
                                OutOfView.PointC = floor_vector2(pos - rotateVector2(dir, -math.rad(35)) * Options[Group.."EspOutOfViewSize"].Value)
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

                                local box_position = floor_vector2((OutOfView.PointA + OutOfView.PointB + OutOfView.PointC) / 3 - Vector2.new(Options[Group.."EspOutOfViewSize"].Value / 2, Options[Group.."EspOutOfViewSize"].Value / 2))
                                local box_size = Vector2.new(Options[Group.."EspOutOfViewSize"].Value, Options[Group.."EspOutOfViewSize"].Value)

                                if Toggles[Group.."EspName"].Value then
                                    Name.Position = Vector2.new(box_size.X / 2 + box_position.X, box_position.Y - Name.TextBounds.Y - 3)
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
                                    Health.From = Vector2.new(box_position.X - 4, box_position.Y + box_size.Y)
                                    Health.To = Vector2.new(box_position.X - 4, Health.From.Y - (Cur_Health / Max_Health) * box_size.Y)
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

                                    HealthOutline.From = Vector2.new(Health.From.X, box_position.Y + box_size.Y + 1)
                                    HealthOutline.To = Vector2.new(Health.From.X, (Health.From.Y - 1 * box_size.Y) -1)
                                    HealthOutline.Visible = true
                                    if HealthOutline.Thickness ~= 3 then
                                        HealthOutline.Thickness = 3
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

    do -- Visuals
        Library:GiveSignal(RunService.RenderStepped:Connect(function(step)                
            fps = math.floor(1/step)

            if Toggles.ThirdPerson.Value and Options.ThirdPersonKey:GetState() and LocalPlayer.CameraMaxZoomDistance ~= Options.ThirdPersonDistance.Value / 5 and LocalPlayer.CameraMinZoomDistance ~= Options.ThirdPersonDistance.Value / 5 and isAlive() then
                LocalPlayer.CameraMinZoomDistance = Options.ThirdPersonDistance.Value / 5
                LocalPlayer.CameraMaxZoomDistance = Options.ThirdPersonDistance.Value / 5
            elseif LocalPlayer.CameraMaxZoomDistance ~= 0 and LocalPlayer.CameraMinZoomDistance ~= 0 and isAlive() then
                LocalPlayer.CameraMinZoomDistance = 0
                LocalPlayer.CameraMaxZoomDistance = 0
            end

            Watermark.Text.Text = textboxtriggers(Options.WatermarkText.Value)
            
            if Watermark.Text.Position ~= Vector2.new(Options.WatermarkIcon.Value == "N/A" and 58 + 4 or 58 + 27, 15) then
                Watermark.Text.Position = Vector2.new(Options.WatermarkIcon.Value == "N/A" and 58 + 4 or 58 + 27, 15)
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
        
            if Watermark.Border.Position ~= Vector2.new(57, 8) then
                Watermark.Border.Position = Vector2.new(57, 8)
            end
        
            if Watermark.Border.Filled ~= true then
                Watermark.Border.Filled = true
            end
        
            if Watermark.Border.Visible ~= Toggles.InterfaceWatermark.Value then
                Watermark.Border.Visible = Toggles.InterfaceWatermark.Value
            end
            
            Watermark.Border.Size = Vector2.new(Options.WatermarkIcon.Value == "N/A" and Watermark.Text.TextBounds.X + 9 or Watermark.Text.TextBounds.X + 34, Watermark.Text.TextBounds.Y + 13)
        
            if Watermark.Gradient.Position ~= Vector2.new(58, 12) then
                Watermark.Gradient.Position = Vector2.new(58, 12)
            end

            if Watermark.Gradient.Visible ~= Toggles.InterfaceWatermark.Value then
                Watermark.Gradient.Visible = Toggles.InterfaceWatermark.Value
            end
            
            if Watermark.Gradient.Transparency ~= 0.5 then
                Watermark.Gradient.Transparency = 0.5
            end

            Watermark.Gradient.Size = Vector2.new(Options.WatermarkIcon.Value == "N/A" and Watermark.Text.TextBounds.X + 7 or Watermark.Text.TextBounds.X + 32, Watermark.Text.TextBounds.Y + 11)
        
            if Watermark.Background.Color ~= Color3.fromRGB(25, 25, 25) then
                Watermark.Background.Color = Color3.fromRGB(25, 25, 25)
            end
        
            if Watermark.Background.Position ~= Vector2.new(58, 9) then
                Watermark.Background.Position = Vector2.new(58, 9)
            end
        
            if Watermark.Background.Filled ~= true then
                Watermark.Background.Filled = true
            end
        
            if Watermark.Background.Visible ~= Toggles.InterfaceWatermark.Value then
                Watermark.Background.Visible = Toggles.InterfaceWatermark.Value
            end
        
            Watermark.Background.Size = Vector2.new(Options.WatermarkIcon.Value == "N/A" and Watermark.Text.TextBounds.X + 7 or Watermark.Text.TextBounds.X + 32, Watermark.Text.TextBounds.Y + 11)

            local Color = Color3.fromRGB((math.abs(math.sin(tick() / (Options.RainbowSpeed.Value - 51))) * 255), 255, 255)

            if Watermark.Accent.Color ~= Color3.fromHSV(Color.R, Color.G, Color.B) and Toggles.RainbowAccent.Value then
                Watermark.Accent.Color = Color3.fromHSV(Color.R, Color.G, Color.B)
            elseif Watermark.Accent.Color ~= Color3.new(Options.ColorWatermark.Value.R, Options.ColorWatermark.Value.G, Options.ColorWatermark.Value.B) then
                Watermark.Accent.Color = Color3.new(Options.ColorWatermark.Value.R, Options.ColorWatermark.Value.G, Options.ColorWatermark.Value.B)
            end
        
            if Watermark.Accent.Position ~= Vector2.new(58, 9) then
                Watermark.Accent.Position = Vector2.new(58, 9)
            end
        
            if Watermark.Accent.Filled ~= true then
                Watermark.Accent.Filled = true
            end
        
            if Watermark.Accent.Visible ~= Toggles.InterfaceWatermark.Value then
                Watermark.Accent.Visible = Toggles.InterfaceWatermark.Value
            end
        
            Watermark.Accent.Size = Vector2.new(Options.WatermarkIcon.Value == "N/A" and Watermark.Text.TextBounds.X + 7 or Watermark.Text.TextBounds.X + 32, 1)
        
            if Watermark.Accent2.Color ~= Color3.fromHSV(Color.R, Color.G, Color.B) and Toggles.RainbowAccent.Value then
                Watermark.Accent2.Color = Color3.fromHSV(Color.R, Color.G, Color.B)
            elseif Watermark.Accent2.Color ~= Color3.fromRGB(Options.ColorWatermark.Value.R * 255 - 40, Options.ColorWatermark.Value.G * 255 - 40, Options.ColorWatermark.Value.B * 255 - 40) then
                Watermark.Accent2.Color = Color3.fromRGB(Options.ColorWatermark.Value.R * 255 - 40, Options.ColorWatermark.Value.G * 255 - 40, Options.ColorWatermark.Value.B * 255 - 40)
            end
        
            if Watermark.Accent2.Position ~= Vector2.new(58, 10) then
                Watermark.Accent2.Position = Vector2.new(58, 10)
            end
        
            if Watermark.Accent2.Filled ~= true then
                Watermark.Accent2.Filled = true
            end
        
            if Watermark.Accent2.Visible ~= Toggles.InterfaceWatermark.Value then
                Watermark.Accent2.Visible = Toggles.InterfaceWatermark.Value
            end
        
            Watermark.Accent2.Size = Vector2.new(Options.WatermarkIcon.Value == "N/A" and Watermark.Text.TextBounds.X + 7 or Watermark.Text.TextBounds.X + 32, 1)
        
            if Watermark.BorderLine.Color ~= Color3.fromRGB(0, 0, 0) then
                Watermark.BorderLine.Color = Color3.fromRGB(0, 0, 0)
            end
        
            if Watermark.BorderLine.Position ~= Vector2.new(58, 11) then
                Watermark.BorderLine.Position = Vector2.new(58, 11)
            end
        
            if Watermark.BorderLine.Filled ~= true then
                Watermark.BorderLine.Filled = true
            end
        
            if Watermark.BorderLine.Visible ~= Toggles.InterfaceWatermark.Value then
                Watermark.BorderLine.Visible = Toggles.InterfaceWatermark.Value
            end
        
            Watermark.BorderLine.Size = Vector2.new(Options.WatermarkIcon.Value == "N/A" and Watermark.Text.TextBounds.X + 7 or Watermark.Text.TextBounds.X + 32, 1)
        
            if Watermark.Icon.Position ~= Vector2.new(58, 12) then
                Watermark.Icon.Position = Vector2.new(58, 12)
            end
        
            if Watermark.Icon.Visible ~= Toggles.InterfaceWatermark.Value then
                Watermark.Icon.Visible = Toggles.InterfaceWatermark.Value
            end
        
            if Watermark.Icon.Size ~= Vector2.new(Watermark.Text.TextBounds.Y + 8, Watermark.Text.TextBounds.Y + 8) then
                Watermark.Icon.Size = Vector2.new(Watermark.Text.TextBounds.Y + 8, Watermark.Text.TextBounds.Y + 8)
            end

            if Toggles.WorldAmbience.Value then
                game.Lighting.Ambient = Options.ColorInsideAmbience.Value
                game.Lighting.OutdoorAmbient = Options.ColorOutsideAmbience.Value
            end

            if Toggles.WorldTime.Value then
                game.Lighting.TimeOfDay = Options.WorldTimeAmount.Value
            end

            if Toggles.WorldSaturation.Value then
                saturationEffect.TintColor = Options.ColorSaturation.Value
                saturationEffect.Saturation = Options.WorldSaturationAmount.Value / 50
            end
        end))
    end
    
    do -- Movement
        Library:GiveSignal(RunService.RenderStepped:Connect(function()
            if isAlive() then
                if Toggles.MovementSpeed.Value and Options.MovementSpeedKey:GetState() then
                    local travel = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        travel += Vector3.new(Camera.CFrame.lookVector.x, 0, Camera.CFrame.lookVector.Z)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        travel -= Vector3.new(Camera.CFrame.lookVector.x, 0, Camera.CFrame.lookVector.Z)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        travel += Vector3.new(-Camera.CFrame.lookVector.Z, 0, Camera.CFrame.lookVector.x)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        travel += Vector3.new(Camera.CFrame.lookVector.Z, 0, -Camera.CFrame.lookVector.x)
                    end

                    travel = travel.Unit

                    local newDir = Vector3.new(travel.x * Options.MovementSpeedAmount.Value, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.y, travel.Z * Options.MovementSpeedAmount.Value)
    
                    if Toggles.MovementAutoJump.Value and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid"):GetState() ~= Enum.HumanoidStateType.Freefall then
                        LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").Jump = true
                    end

                    if travel.Unit.x == travel.Unit.x then
                        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = newDir
                    end
                end
            end

            if isAlive() then
                if Toggles.MovementFly.Value and Options.MovementFlyKey:GetState() then
                    local travel = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        travel += Camera.CFrame.lookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        travel -= Camera.CFrame.lookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        travel += Vector3.new(-Camera.CFrame.lookVector.Z, 0, Camera.CFrame.lookVector.x)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        travel += Vector3.new(Camera.CFrame.lookVector.Z, 0, -Camera.CFrame.lookVector.x)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        travel += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        travel -= Vector3.new(0, 1, 0)
                    end

                    if travel.Unit.x == travel.Unit.x then
                        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false
                        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = travel.Unit * Options.MovementFlyAmount.Value
                    else
                        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, 0, 0)
                        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true
                    end
                else
                    LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false
                end
            end
        end))
    end

    do -- Rage Bot
        Library:GiveSignal(RunService.RenderStepped:Connect(function(step)   
            LastStep = step
            rtar = nil             
            for _,v in pairs(Players:GetPlayers()) do  
                local Now = os.clock()
                if Toggles.RageEnabled.Value and Options.RageKey:GetState() and v.Team ~= LocalPlayer.Team and isAlive(v) and isAlive() and client.gun.Penetration ~= nil and not v.Character:FindFirstChildOfClass("ForceField") then
                    if (Now - clock < (client.gun.FireRate.Value or 0.5)) then
                        return
                    end
                
                    clock = Now
                    
                    local character = v.Character
                
                    local origin = Camera.CFrame.Position
                
                    local map = workspace:FindFirstChild("Map")
                    if not map then return end
                
                    --[[RageScanParams.FilterDescendantsInstances = {
                        LocalPlayer.Character, Camera, map:FindFirstChild("Clips"), map:FindFirstChild("Debris"), map:FindFirstChild("SpawnPoints"), workspace:FindFirstChild("Ray_Ignore")
                    }]]
                
                    local direction = (character.Head.Position - origin)
                    
                
                    local maximum_penetration = 0
                    local penetrationPower = (client.gun.Penetration.Value or 50) * 0.01
                    local DamageModifier = 1
                    local ignorelist = {character, LocalPlayer.Character, Camera, map:FindFirstChild("Clips"), map:FindFirstChild("Debris"), map:FindFirstChild("SpawnPoints"), workspace:FindFirstChild("Ray_Ignore")}
                    -- add the enemy character to this ignore list
                
                    AWParams.FilterDescendantsInstances = ignorelist
                    
                    local vis = workspace:Raycast(origin, direction, AWParams)

                    -- office, this process is done 4 times, you are able to penetrate up to 4 walls in counter blox

                    --for i = 1, #results do
                    if not vis then
                        if Toggles.RageForwardTrack.Value then
                            local vel = character.HumanoidRootPart.Velocity
                            local amount = Options.RageForwardTrackAmount.Value / 1000
                            local vect = vel * amount
                            local poshit = workspace:Raycast(character.Head.Position, vect, AWParams)
                            if not poshit then
                                client.firebullet()
                                HitPart:FireServer(unpack(hitpart_args(character.Head, character.Head.Position, 2)))
                            else
                                client.firebullet()
                                HitPart:FireServer(unpack(hitpart_args(character.Head, poshit.Position, 2)))    
                            end
                        else
                            client.firebullet()
                            HitPart:FireServer(unpack(hitpart_args(character.Head, character.Head.Position, 2)))
                        end

                        rtar = v

                        return;
                    end

                    local results = {}

                    repeat
                        local Result = workspace:Raycast(origin, direction, AWParams)
                        if Result then
                            table.insert(results, Result)
                        end
                    until #results >= 4
                    
                    for i = 1, #results do
                        local Hitpos = results[i].Position
                        local PartHit = results[i].Instance
                        local hitmat = PartHit.Material
                        table.insert(ignorelist, PartHit)
                
                        AWParams.FilterDescendantsInstances = ignorelist
                
                        local mod = 1
                        mod = (hitmat == Enum.Material.DiamondPlate) and 3 
                            or ((hitmat == Enum.Material.CorrodedMetal) or (hitmat == Enum.Material.Metal) or (hitmat == Enum.Material.Concrete) or (hitmat == Enum.Material.Brick)) and 2 
                            or ((hitmat == Enum.Material.Wood) or (hitmat == Enum.Material.WoodPlanks) or (PartHit.Name == "Grate")) and 0.1 
                            or (PartHit.Name == "nowallbang") and 100 
                            or (PartHit:FindFirstChild("PartModifier")) and tonumber(PartHit.PartModifier.Value) 
                            or ((PartHit.Transparency == 1) or (not PartHit.CanCollide) or (PartHit.Name == "Glass") or (PartHit.Name == "Cardboard")) and 0 
                            or 1
                        if mod <= 0 then 
                            if Toggles.RageForwardTrack.Value then
                                local vel = character.HumanoidRootPart.Velocity
                                local amount = Options.RageForwardTrackAmount.Value
                                local vect = vel * amount
                                local poshit = workspace:Raycast(character.Head.Position, vect, AWParams)
                                if poshit then
                                    client.firebullet()
                                    HitPart:FireServer(unpack(hitpart_args(character.Head, poshit.Position, 2)))
                                else
                                    client.firebullet()
                                    HitPart:FireServer(unpack(hitpart_args(character.Head, character.Head.Position, 2)))
                                end
                            else
                                client.firebullet()
                                HitPart:FireServer(unpack(hitpart_args(character.Head, character.Head.Position, 2)))
                            end

                            rtar = v

                            return;
                        end
                        local maxpen = (penetrationPower - maximum_penetration) / mod
                        local reverse_direction = direction.Unit * maxpen

                        AWBackParams.FilterDescendantsInstances = {PartHit}

                        local end_result = workspace:Raycast(Hitpos + reverse_direction, reverse_direction * -2, AWBackParams)
                        if not end_result then 
                            return 
                        end
                        
                        local pen_distance = (end_result.Position - Hitpos).Magnitude * mod 
                        maximum_penetration += pen_distance
                        DamageModifier = 1 - (maximum_penetration / penetrationPower)
                
                        if (maximum_penetration >= penetrationPower or DamageModifier <= 0) then
                            return
                        end

                        --[[if Toggles.RageForwardTrack.Value then
                            local vel = character.HumanoidRootPart.Velocity
                            local amount = Options.RageForwardTrackAmount.Value / 1000
                            local vect = vel * amount
                            local poshit = workspace:Raycast(character.Head.Position, vect, AWParams)
                            if poshit then
                                client.firebullet()
                                HitPart:FireServer(unpack(hitpart_args(character.Head, poshit.Position, 2)))
                            else
                                client.firebullet()
                                HitPart:FireServer(unpack(hitpart_args(character.Head, character.Head.Position, 2)))
                            end
                        else]]
                            --client.firebullet()
                            --HitPart:FireServer(unpack(hitpart_args(character.Head, character.Head.Position, 2)))
                        --end
                    end
                end
            end
        end))
    end

    local mt = getrawmetatable(game) 
	local oldNamecall = mt.__namecall 
	local oldIndex = mt.__index 
	local oldNewIndex = mt.__newindex 
	setreadonly(mt,false) 
	mt.__namecall = function(self, ...)
		local method = tostring(getnamecallmethod())
		local args = {...} 

        if method == "FireServer" and self.Name == "HitPart" then 
			if rtar ~= nil then
				-- Stolen pred from J's dms. <3
				coroutine.wrap(function()
					if Players:GetPlayerFromCharacter(args[1].Parent) or args[1] == rtar then 
						local RootPart = rtar.Parent.HumanoidRootPart.Position
						local OldRootPart = rtar.Parent.HumanoidRootPart.OldPosition.Value
						local Velocity = (Vector3.new(RootPart.X, 0, RootPart.Z) - Vector3.new(OldRootPart.X, 0, OldRootPart.Z)) / LastStep
						local Direction = Vector3.new(Velocity.X / Velocity.magnitude, 0, Velocity.Z / Velocity.magnitude)
						args[2] = args[2] + Direction * (game.Stats.PerformanceStats.Ping:GetValue() / (math.pow(game.Stats.PerformanceStats.Ping:GetValue(), (1.5))) * (Direction / (Direction / 2)))
						args[12]= args[12] - 500	
					end
				end)()
			end
		end

        return oldNamecall(self, unpack(args)) 
	end
end