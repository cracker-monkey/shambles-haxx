local PlaceId = game.PlaceId

local function printc(text)
    if syn then
        printconsole(text, 255, 255, 255)
    else
        warn(text)
    end
end

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

    execute("shambles haxx/globals/information.lua")
    --execute("shambles haxx/websockets/main.lua")

    getgenv().Library = execute("shambles haxx/libraries/UI/UI.lua", true)
    getgenv().ThemeManager = execute("shambles haxx/libraries/Managers/Theme Manager.lua", true)
    getgenv().SaveManager = execute("shambles haxx/libraries/Managers/Configuration Manager.lua", true)

    local username = getgenv().username

    printc("Welcome, ".. username .." to shambles haxx!")

    if PlaceId == 299659045 or PlaceId == 292439477 then
        execute("shambles haxx/games/phantom-forces/development/core/source.lua")
    else
        execute("shambles haxx/games/universal/development/core/source.lua")
    end
end