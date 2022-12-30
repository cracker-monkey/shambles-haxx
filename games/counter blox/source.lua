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

local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local RunService = game.RunService
local REvents = game.ReplicatedStorage.Events
local HitPart = REvents:FindFirstChild("GGGHGGHG")
local Camera = workspace.Camera
local UserInputService = game.UserInputService
local clock = 0
local raycastparameters = RaycastParams.new()
local OriginScanParamas = RaycastParams.new()
OriginScanParamas.IgnoreWater = true
OriginScanParamas.FilterType = Enum.RaycastFilterType.Whitelist 
for i,v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
    if v.ClassName == "LocalScript" then
        pcall(function()
            if getsenv(v).firebullet then
                client = getsenv(v)
            end
        end)
    end
end

getgenv().Tabs = {
    Rage = Window:AddTab('Rage'), 
    Visuals = Window:AddTab('Visuals'), 
    Misc = Window:AddTab('Misc'), 
    Settings = Window:AddTab('Settings'), 
    Lua = Window:AddTab("Lua")
} 

do -- Menu things
    local RageBot = Tabs.Rage:AddLeftGroupbox("Rage Bot") do
        RageBot:AddToggle('RageEnabled', {Text = 'Enabled'}):AddKeyPicker('RageKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Rage Bot', NoUI = false})
        RageBot:AddDropdown('RageHitscan', {Values = { "Head", "Torso" }, Default = 1, Multi = false, Text = 'Hitscan Priority'})
        RageBot:AddToggle('RageForwardTrack', {Text = 'Forward Track'})
        RageBot:AddSlider('RageForwardTrackAmount', {Text = 'Amount', Default = 1, Min = 0, Max = 2000, Rounding = 0})
    end

    local Movement = Tabs.Misc:AddLeftGroupbox('Movement') do
        Movement:AddToggle('MovementSpeed', {Text = 'Speed'}):AddKeyPicker('MovementSpeedKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Speed', NoUI = false})
        Movement:AddSlider('MovementSpeedAmount', {Text = 'Speed Amount', Default = 60, Min = 1, Max = 500, Rounding = 0})
        Movement:AddToggle('MovementFly', {Text = 'Fly'}):AddKeyPicker('MovementFlyKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Fly', NoUI = false})
        Movement:AddSlider('MovementFlyAmount', {Text = 'Fly Amount', Default = 60, Min = 1, Max = 500, Rounding = 0})
        Movement:AddToggle('MovementAutoJump', {Text = 'Auto Jump'})
    end
     
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

    local MenuGroup = Tabs['Settings']:AddLeftGroupbox('Menu') do
        MenuGroup:AddButton('Unload', function() Library:Unload() end)
        MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' }) 
    end

    do
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
        
            Library.Unloaded = true
        end)
    end
end

do -- Functions
    function hitpart_args(hitbox, position, mod)
        return {
            [1] = hitbox,
            [2] = position,
            [3] = client.gun.Name,
            [4] = 8192,
            [5] = LocalPlayer.Character.Gun,
            [8] = mod,
            [10] = false,
            [11] = Vector3.zero,
            [12] = 28644,
            [13] = Vector3.zero,
            [14] = true,
            [15] = 36,
            [16] = 86
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
        Library:GiveSignal(RunService.RenderStepped:Connect(function()                
            for _,v in pairs(Players:GetPlayers()) do  
                local Now = os.clock()
                if Toggles.RageEnabled.Value and Options.RageKey:GetState() and client.gun.Melee ~= true and v.Team ~= LocalPlayer.Team and isAlive(v) and isAlive() and client.gun.Penetration ~= nil then
                    if (Now - clock < (client.gun.FireRate or 0.5)) then
                        return
                    end

                    clock = Now
                    
                    local character = v.Character

                    local origin = Camera.CFrame.Position

                    local map = workspace:FindFirstChild("Map")
                    if map == nil then return end

                    --[[OriginScanParamas.FilterDescendantsInstances = {
                        LocalPlayer.Character, Camera, map:FindFirstChild("Clips"), map:FindFirstChild("Debris"), map:FindFirstChild("SpawnPoints"), workspace:FindFirstChild("Ray_Ignore")
                    }]]

                    local v2 = character.Head.Position - origin
                    
                    local passed = false
                    local mod = 1
                    local maximum_penetration = 0
                    local pen = client.gun.Penetration * 0.01
                    local DamageModifier = 1
                    local ignorelist = {
                        LocalPlayer.Character, Camera, map:FindFirstChild("Clips"), map:FindFirstChild("Debris"), map:FindFirstChild("SpawnPoints"), workspace:FindFirstChild("Ray_Ignore")
                    }

                    if character:FindFirstChild("BackC4") then
                        table.insert(ignorelist, character.BackC4)
                    end
                    if character:FindFirstChild("Gun") then
                        table.insert(ignorelist, character.Gun)
                    end
                    
                    OriginScanParamas.FilterDescendantsInstances = ignorelist

                    local direction = (character.Head.Position - origin) * pen
                    local result = raycast(origin, direction, ignorelist)
                    if not result then
                        print('hi')
                        if Toggles.RageForwardTrack.Value then
                            local Velocity = character.HumanoidRootPart.Velocity
                            local extrapolateTime = Options.RageForwardTrackAmount.Value / 1000
                            local extrapolatedVector = Velocity * extrapolateTime
                            local _, a, positionHit = raycast(character.Head.Position, extrapolatedVector, ignorelist)
                            local extrapolatedpos = positionHit

                            client.firebullet()
                            HitPart:FireServer(unpack(hitpart_args(character.Head, extrapolatedpos, 2)))
                        else
                            client.firebullet()
                            HitPart:FireServer(unpack(hitpart_args(character.Head, character.Head.Position, 2)))
                        end
                    else
                        local parthit = result
                        local hitmat = parthit.Material
                        table.insert(ignorelist, parthit)
                        mod = (hitmat == Enum.Material.DiamondPlate) and 3 
                        or ((hitmat == Enum.Material.CorrodedMetal) or (hitmat == Enum.Material.Metal) or (hitmat == Enum.Material.Concrete) or (hitmat == Enum.Material.Brick)) and 2 
                        or ((hitmat == Enum.Material.Wood) or (hitmat == Enum.Material.WoodPlanks) or (parthit.Name == "Grate")) and 0.1 
                        or (parthit.Name == "nowallbang") and 100 
                        or (parthit:FindFirstChild("PartModifier")) and tonumber(parthit.PartModifier.Value) 
                        or ((parthit.Transparency == 1) or (not parthit.CanCollide) or (parthit.Name == "Glass") or (parthit.Name == "Cardboard")) and 0 
                        or 1
                        if mod <= 0 then return end
                        local maxpen = (pen - maximum_penetration) / mod
                        local reverse_direction = v2.Unit * maxpen
                        local end_result = raycast(result.Position + reverse_direction, reverse_direction * -2, ignorelist)
                        if not end_result then return end
                                   
                        local lol = {
                            Head = 4,
                            HeadHB = 4,
                            FakeHead = 4,
                            LeftFoot = 0.75,
                            RightFoot = 0.75,
                            LeftUpperLeg = 0.75,
                            LeftLowerLeg = 0.75,
                            RightLowerLeg = 0.75,
                            RightUpperLeg = 0.75,
                            LeftUpperArm = 0.75,
                            LeftLowerArm = 0.75,
                            RightLowerArm = 0.75,
                            RightUpperArm = 0.75,
                            LowerTorso = 1.25
                        }

                        local pen_distance = (end_result.Position - result.Position).Magnitude * mod 
                        maximum_penetration += pen_distance
                        DamageModifier = 1 - (maximum_penetration / pen)

                        if table.find(lol, parthit.Name) then
                            if Toggles.RageForwardTrack.Value then
                                local Velocity = character.HumanoidRootPart.Velocity
                                local extrapolateTime = Options.RageForwardTrackAmount.Value / 1000
                                local extrapolatedVector = Velocity * extrapolateTime
                                local _, a, positionHit = raycast(character.Head.Position, extrapolatedVector, ignorelist)
                                local extrapolatedpos = positionHit
    
                                client.firebullet()
                                HitPart:FireServer(unpack(hitpart_args(character.Head, extrapolatedpos, lol[parthit.Name])))
                            else
                                client.firebullet()
                                HitPart:FireServer(unpack(hitpart_args(character.Head, character.Head.Position, lol[parthit.Name])))
                            end
                        end

                        if (maximum_penetration >= pen or DamageModifier <= 0) then return end

                        print(parthit.Name, mod, pen, DamageModifier)

                        if Toggles.RageForwardTrack.Value then
                            local Velocity = character.HumanoidRootPart.Velocity
                            local extrapolateTime = Options.RageForwardTrackAmount.Value / 1000
                            local extrapolatedVector = Velocity * extrapolateTime
                            local _, a, positionHit = raycast(character.Head.Position, extrapolatedVector, ignorelist)
                            local extrapolatedpos = positionHit

                            client.firebullet()
                            HitPart:FireServer(unpack(hitpart_args(character.Head, extrapolatedpos, 2)))
                        else
                            client.firebullet()
                            HitPart:FireServer(unpack(hitpart_args(character.Head, character.Head.Position, 2)))
                        end
                   end
                end
            end
        end))
    end
end