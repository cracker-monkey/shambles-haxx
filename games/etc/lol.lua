local function execute(path, r)
    if r then
        return loadstring(readfile(tostring(path)))();
    else
        loadstring(readfile(tostring(path)))()
    end
end
local token                                                                                                                                                                                                                                                                                                                                                                                                                             = "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"
local library = execute("shambles haxx/libraries/UI/UI.lua", true)
local D_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/3D%20Drawing%20Api.lua"))()
local circle = D_Library:New3DCircle()
circle.Visible = true
circle.ZIndex = 1
circle.Transparency = 1
circle.Color = Color3.fromRGB(255, 255, 255)
circle.Thickness = 1
circle.Position = Vector3.new(0, 0, 0)
circle.Radius = 0

local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local RunService = game.RunService
local Camera = workspace.Camera
local UserInputService = game.UserInputService
local targets = {}

function isAlive(player)
    if not player then player = LocalPlayer end
    return player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildWhichIsA("Humanoid").Health > 0 and true or false
end

function aiTargets(range)
    for i, v in ipairs(Players:GetPlayers()) do
        if isAlive() and isAlive(v) and v ~= LocalPlayer then
            local Character = v.Character
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                local target_pos = Character.HumanoidRootPart.Position
                local target_direction = target_pos - LocalPlayer.Character.HumanoidRootPart.Position
                local target_dist = (target_direction).Magnitude
                if target_dist <= range then
                    if not table.find(targets, v.Name) then
                        table.insert(targets, v.Name)
                    end
                else
                    for k, a in pairs(targets) do
                        if a == v.Name then
                            table.remove(targets, k)
                        end
                    end
                end
            end
        end
    end
end

function showDistance(rad, col, vis)
    if vis then
        local center3d = LocalPlayer.Character.HumanoidRootPart.Position

        local radiusamt = rad
        local radius2d = center3d + Vector3.new(radiusamt, 0, 0)
        local radius = (center3d - radius2d).magnitude


        circle.Position = center3d - Vector3.new(0, 3, 0)
        circle.Radius = radius
        circle.Color = col
    end

    circle.Visible = vis
end

function OpenAI(token, prompt)
    -- if prompt does not contain hashtags continue 
    if prompt:find("#") then
        return
    end

    local err, request = pcall(syn.request, {
        Url = "https://api.openai.com/v1/engines/text-davinci-003/completions",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. token
        },
        Body = game:GetService("HttpService"):JSONEncode({
            prompt = "Responding to: " .. prompt,
            max_tokens = Options.Tokens.Value,
            temperature = Options.Temperature.Value / 1000,
            frequency_penalty = Options.frequencypen.Value / 100,
            presence_penalty = Options.presencypen.Value / 100,
            best_of = Options.bestof.Value,
            n = 1,
        })
    })
    if err then
        print("success")
        return request.Body
    else
        return request
    end
end

local lastmsg = tick()

local window = library:CreateWindow({Title = 'Open AI Chat Bot', Center = true, AutoShow = true})

local main = window:AddTab("Main") do
    local ChatBot = main:AddLeftGroupbox('Chat Bot') do
        ChatBot:AddToggle('ChatBotEnabled', {Text = 'Enabled'})
        ChatBot:AddToggle('ChatBotShowRadius', {Text = 'Show Radius'}):AddColorPicker('RadiusColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Radius Color'})
        ChatBot:AddSlider('ChatBotRadius', {Text = 'Distance', Default = 20, Min = 1, Max = 100, Rounding = 1})
    end

    local MenuGroup = main:AddLeftGroupbox('Menu') do
        MenuGroup:AddButton('Unload', function() library:Unload() end)
        MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' })

        library.ToggleKeybind = Options.MenuKeybind
    end

    local Settings = main:AddRightGroupbox('Settings') do
        Settings:AddSlider('Temperature', {Text = 'Temperature', Default = 20, Min = 1, Max = 100, Rounding = 0})
        Settings:AddSlider('Tokens', {Text = 'Tokens', Default = 20, Min = 1, Max = 1000, Rounding = 0})
        Settings:AddSlider('frequencypen', {Text = 'Frequency Penalty', Default = 20, Min = 1, Max = 100, Rounding = 0})
        Settings:AddSlider('presencypen', {Text = 'Presence Penalty', Default = 20, Min = 1, Max = 100, Rounding = 0})
        Settings:AddSlider('bestof', {Text = 'Figure out best value', Default = 20, Min = 1, Max = 100, Rounding = 0})
    end
end

game.ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(msg)   
    if Toggles.ChatBotEnabled.Value and table.find(targets, msg.FromSpeaker) and msg.FromSpeaker ~= LocalPlayer.Name and (tick() - lastmsg) > 1.5 then
        lastmsg = tick()
        local response = OpenAI(token, msg.Message)
        local parsed = game:GetService("HttpService"):JSONDecode(response)
        local text = parsed.choices[1].text
        -- take newline characters out

        text = text:gsub("\n", "")

        -- take hashtags out
        text = text:gsub("#", "")

        if string.len(text) >= 200 then 
            for i = 1, #text, 200 do
                local substring = string.sub(text, i, i + 200 - 1)
                game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(substring, "All")
            end
        else
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, "All")
        end
    end
end)

library:GiveSignal(RunService.RenderStepped:Connect(function()  
    showDistance(Options.ChatBotRadius.Value, Options.RadiusColor.Value, Toggles.ChatBotShowRadius.Value)
    aiTargets(Options.ChatBotRadius.Value)
end))