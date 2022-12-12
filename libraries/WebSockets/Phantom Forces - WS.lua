local function connect(port)
    if port == nil then port = 8022 end

    local websocket = 
    Krnl and Krnl.WebSocket.connect("ws://localhost:".. tostring(port)) or 
    syn and syn.websocket.connect("ws://localhost:".. tostring(port)) or 
    WebSocket and WebSocket.connect("ws://localhost:".. tostring(port))

    return websocket
end

local WebSocket = connect()

local game_client = {}
do -- Client Collector
    local garbage = getgc(true)

    for i = 1, #garbage do
        local v = garbage[i]
        if typeof(v) == "table" then
            if rawget(v, "send") then
                game_client.network = v
            elseif rawget(v, "getCharacterObject") then
                game_client.character_interface = v
            end
        end
    end
end

local function execute(path, r)
    if r then
        return loadstring(readfile(tostring(path)))();
    else
        loadstring(readfile(tostring(path)))()
    end
end

WebSocket.OnMessage:Connect(function(msg)
    if string.find(msg, "saycmd") then
        game_client.network.send(nil, "chatted", string.sub(msg, 8, #msg)) 
        getgenv().Library:Notify("You got sent a request\nSay (" ..string.sub(msg, 8, #msg).. ").")
                --print(msg)
    elseif string.find(msg, "botcount") then
        game_client.network.send(nil, "chatted", "Clients connected: " ..string.sub(msg, 10, #msg)) 
        getgenv().Library:Notify("You got sent a request\nBot Count (" ..string.sub(msg, 10, #msg).. ").")
        --print(msg)
    elseif string.find(msg, "commands") then
        game_client.network.send(nil, "chatted", string.sub(msg, 10, #msg)) 
        getgenv().Library:Notify("You got sent a request\nCommands (" ..string.sub(msg, 10, #msg).. ").")
        --print(msg)
    elseif string.find(msg, "loadstring") then
        execute(string.sub(msg, 13, #msg))
        getgenv().Library:Notify("You got sent a request\nLoadstring (" ..string.sub(msg, 13, #msg).. ").")
        --print(msg)
    elseif string.find(msg, "fpscap") then
        setfpscap(tonumber(string.sub(msg, 7, #msg)))
        getgenv().Library:Notify("You got sent a request\nFpsCap (" ..string.sub(msg, 7, #msg).. ").")
        --print(msg)
    elseif string.find(msg, "joke") then
        game_client.network.send(nil, "chatted", string.sub(msg, 6, #msg)) 
        getgenv().Library:Notify("You got sent a request\nJoke (" ..string.sub(msg, 6, #msg).. ").")
        --print(msg)
    elseif string.find(msg, "deploy") then
        if string.sub(msg, 8, #msg) == "all" then
            game_client.character_interface.spawn()
        elseif string.sub(msg, 8, #msg) == game.Players.LocalPlayer.Name then
            game_client.character_interface.spawn()
        end

        getgenv().Library:Notify("You got sent a request\nDeploy (" ..string.sub(msg, 8, #msg).. ").")
        --print(msg)
    end
end)

getgenv().Library:Notify("Websockets successfully loaded!", 5, true)

WebSocket.OnClose:Connect(function()
    getgenv().Library:Notify("Websockets disconnected!", 5, true)
end)