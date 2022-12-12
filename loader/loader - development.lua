local PlaceId = game.PlaceId


local function execute(path, r)
    if r then
        return loadstring(readfile(tostring(path)))();
    else
        loadstring(readfile(tostring(path)))()
    end
end

do
    if not isfolder("shambles haxx/Configs") then
        makefolder("shambles haxx/Configs")
    end

    getgenv().Library = execute("shambles haxx/libraries/UI/UI.lua", true)
    getgenv().ThemeManager = execute("shambles haxx/libraries/Managers/Theme Manager.lua", true)
    getgenv().SaveManager = execute("shambles haxx/libraries/Managers/Configuration Manager.lua", true)
    getgenv().Window = getgenv().Library:CreateWindow({Title = 'Shambles Haxx', Center = true, AutoShow = true})

    execute("shambles haxx/globals/information.lua")
    execute("shambles haxx/globals/api.lua")

    if PlaceId == 299659045 or PlaceId == 292439477 then
        execute("shambles haxx/games/phantom-forces/development/core/source.lua")
        execute("shambles haxx/libraries/WebSockets/Phantom Forces - WS.lua")
    else
        execute("shambles haxx/games/universal/development/core/source.lua")
    end
end