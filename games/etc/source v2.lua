local shambles = {
    path = "shambles haxx",
    folder = "shambles haxx/Configs/"..game_name.."/",
}

do -- Local's
    local RunService = game.RunService
    local Players = game.Players
    local Http = game.HttpService
    local UserInputService = game.UserInputService
    local TweenService = game.TweenService
    local Stats = game.Stats
    local Actionservice = game.ContextActionService
    local ReplicatedStorage = game.ReplicatedStorage
    local Lighting = game.Lighting
    local Tween = game.TweenService
    local Debris = game.Debris
    local LocalPlayer = Players.LocalPlayer
    local LocalMouse = LocalPlayer:GetMouse()
    local Camera = workspace.CurrentCamera
    local ScreenSize = Camera.ViewportSize
    local Ping = game.Stats.PerformanceStats.Ping:GetValue() 
    local SaturationEffect = Instance.new("ColorCorrectionEffect", Lighting)
    local FPS = 0
    local RaycastParameters = RaycastParams.new()
    local Positions = {
        MousePos = Vector3.new(UserInputService:GetMouseLocation().x, UserInputService:GetMouseLocation().y, 0),
        CrosshairPos = ScreenSize / 2,
        FovPos = ScreenSize / 2,
        Barrel = Vector2.new()
    }
    local BulletHitTable = { 
        firepos = Positions.Barrel, 
        bullets = {}, 
        camerapos = Vector3.new(), 
    }
    local Cache = {
        setsway = game_client.main_camera_object.setSway, 
        shake = game_client.main_camera_object.shake, 
        gsway = game_client.firearm_object.gunSway, 
        wsway = game_client.firearm_object.walkSway,
    }
    local rage = {
        target = nil, 
        lastf = 0,
        pos = Vector3.new(),
    }

    getgenv().Friends = {}
end

getgenv().Tabs = {
    Rage = Window:AddTab('Rage'), 
    Legit = Window:AddTab('Legit'), 
    Visuals = Window:AddTab('Visuals'), 
    Misc = Window:AddTab('Misc'), 
    Settings = Window:AddTab('Settings'), 
    Lua = Window:AddTab("Lua")
} 

do -- Settings Tab
    local MenuGroup = Tabs.Settings:AddLeftGroupbox('Menu') do
        MenuGroup:AddButton('Unload', function() 
            Library:Unload() 
        end)
        MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' }) 
        Library.ToggleKeybind = Options.MenuKeybind
    end

    do -- Save Manager
        SaveManager:SetLibrary(Library)
        SaveManager:SetIgnoreIndexes({'MenuKeybind'}) 
        SaveManager:SetFolder(shambles.folder)
        SaveManager:BuildConfigSection(Tabs.Settings) 
    end

    do -- Theme Manager
        ThemeManager:SetLibrary(Library)
        ThemeManager:SetFolder(shambles.folder)
        ThemeManager:ApplyToTab(Tabs.Settings)
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
end