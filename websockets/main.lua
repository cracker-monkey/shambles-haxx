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
        print(msg)
    elseif string.find(msg, "botcount") then
        game_client.network.send(nil, "chatted", "Clients connected: " ..string.sub(msg, 10, #msg)) 
        print(msg)
    elseif string.find(msg, "commands") then
        game_client.network.send(nil, "chatted", string.sub(msg, 10, #msg)) 
        print(msg)
    elseif string.find(msg, "loadstring") then
        execute(string.sub(msg, 13, #msg))
        print(msg)
    elseif string.find(msg, "fpscap") then
        setfpscap(tonumber(string.sub(msg, 7, #msg)))
        print(msg)
    elseif string.find(msg, "joke") then
        game_client.network.send(nil, "chatted", string.sub(msg, 6, #msg)) 
        print(msg)
    end
end)