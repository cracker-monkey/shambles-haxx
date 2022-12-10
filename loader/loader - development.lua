local PlaceId = game.PlaceId

local function printc(text)
    if syn then
        rconsoleprint(text)
    else
        warn(text)
    end
end

local function execute(path)
    if Square.new() then
        loadstring(loadfile(path))()
    else
        loadstring(readfile(path))()
    end
end

loadstring(readfile("shambles haxx/globals/information.lua"))()

local username = getgenv().username

printc("Welcome, ".. username .." to shambles haxx!")

if PlaceId == 299659045 or PlaceId == 292439477 then
    execute("shambles haxx/games/phantom-forces/development/core/source.lua")
else
    execute("shambles haxx/games/universal/development/core/source.lua")
end