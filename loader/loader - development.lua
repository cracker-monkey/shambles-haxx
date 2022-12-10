local PlaceId = game.PlaceId

local function printc(text)
    if syn then
        rconsoleprint(text)
    else
        warn(text)
    end
end

local function execute(path)
    if syn and syn.is_beta then
        loadstring(loadfile(path))()
    else
        loadstring(readfile(path))()
    end
end

execute("shambles haxx/globals/information.lua")
execute("shambles haxx/websockets/main.lua")

getgenv().Library = execute("shambles haxx/libraries/UI/UI.lua")
getgenv().ThemeManager = execute("shambles haxx/libraries/Managers/Theme Manager.lua")
getgenv().SaveManager = execute("shambles haxx/libraries/Managers/Configuration Manager.lua")

local username = getgenv().username

printc("Welcome, ".. username .." to shambles haxx!")

if PlaceId == 299659045 or PlaceId == 292439477 then
    execute("shambles haxx/games/phantom-forces/development/core/source.lua")
else
    execute("shambles haxx/games/universal/development/core/source.lua")
end