local function connect(port)
    if port == nil then port = 8022 end

    local websocket = 
    Krnl and Krnl.WebSocket.connect("ws://localhost:".. tostring(port)) or 
    syn and syn.websocket.connect("ws://localhost:".. tostring(port)) or 
    WebSocket and WebSocket.connect("ws://localhost:".. tostring(port))

    return websocket
end

local WebSocket = connect()

WebSocket.OnMessage:Connect(function(msg)
    print(msg)
end)