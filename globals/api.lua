if not isfolder("shambles haxx/Configs/Phantom Forces/lua") then
    makefolder("shambles haxx/Configs/Phantom Forces/lua")
end

local function execute(path, r)
    if r then
        return loadstring(readfile(tostring(path)))();
    else
        loadstring(readfile(tostring(path)))();
    end
end

local function print_syn(text, color)
    printconsole(text, color.R * 255, color.B * 255, color.G * 255)
end

local function notify(text, time, warning)
    Library:Notify(text, time, warning)
end

local function w_connect(port)
    if port == nil then port = 8022 end

    local websocket = syn.websocket.connect("ws://localhost:".. tostring(port))

    return websocket
end

local function w_send(websocket, message)
    websocket:Send(message)
end

local function scripts()
    local list = listfiles("shambles haxx/Configs/Phantom Forces/lua")

    local scripts = {}
    for i = 1, #list do
        local file = list[i]
        if file:sub(-4) == '.lua' then
            local pos = file:find('.lua', 1, true)
            local start = pos

            local char = file:sub(pos, pos)
            while char ~= '/' and char ~= '\\' and char ~= '' do
                pos = pos - 1
                char = file:sub(pos, pos)
            end

            if char == '/' or char == '\\' then
                table.insert(scripts, file:sub(pos + 1, start - 1))
            end
        end
    end

    return scripts;
end

getgenv().cheat = {
    print = print_syn,
    notify = notify,
    username = username,
    uid = uid,
    library = Library,
    window = Window,
    tabs = Tabs,
}

getgenv().websockets = {
    connect = w_connect,
    send = w_send,
}

local LuaSection = Tabs.Lua:AddLeftGroupbox("Scripts")
LuaSection:AddDropdown('ScriptList', { Text = 'Script List', Values = scripts(), AllowNull = true })

LuaSection:AddButton('Load', function()
    if isfile("shambles haxx/Configs/Phantom Forces/lua/" ..Options.ScriptList.Value..".lua") then
        execute("shambles haxx/Configs/Phantom Forces/lua/" ..Options.ScriptList.Value..".lua")
    end
end)

LuaSection:AddButton('Refresh', function()
    Options.ScriptList.Values = scripts()
    Options.ScriptList:SetValues()
    Options.ScriptList:SetValue(nil)
end)