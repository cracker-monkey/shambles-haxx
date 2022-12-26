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

    if not isfolder("shambles haxx/configs/icons") then
        makefolder("shambles haxx/configs/icons")
    end

    if not isfolder("shambles haxx/configs/sounds") then
        makefolder("shambles haxx/configs/sounds")
    end
    
    getgenv().Library = execute("shambles haxx/libraries/UI/UI.lua", true)
    getgenv().ThemeManager = execute("shambles haxx/libraries/Managers/Theme Manager.lua", true)
    getgenv().SaveManager = execute("shambles haxx/libraries/Managers/Configuration Manager.lua", true)
    getgenv().Window = Library:CreateWindow({Title = 'Shambles Haxx', Center = true, AutoShow = true})
    getgenv().event = execute("shambles haxx/libraries/Events/Listener.lua", true)

    execute("shambles haxx/globals/information.lua")

    if PlaceId == 299659045 or PlaceId == 292439477 then
        execute("shambles haxx/globals/functions.lua")
        execute("shambles haxx/games/phantom-forces/development/core/source.lua")
        execute("shambles haxx/globals/api.lua")
    else
        execute("shambles haxx/games/universal/development/core/source.lua")
    end
end