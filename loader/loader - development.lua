local PlaceId = game.PlaceId

local function printc(text)
    if syn then
        rconsoleprint(text)
    else
        warn(text)
    end
end

local function execute(path, r)
    if syn and syn.is_beta then
        if r then
            return loadstring(loadfile(tostring(path)))();
        else
            loadstring(loadfile(tostring(path)))()
        end
    else
        if r then
            return loadstring(readfile(tostring(path)))();
        else
            loadstring(readfile(tostring(path)))()
        end
    end
end

do
    execute("shambles haxx/globals/information.lua")
    execute("shambles haxx/websockets/main.lua")

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