local PlaceId = game.PlaceId

local function printc(text)
    if syn then
        rconsoleprint(text)
    else
        warn(text)
    end
end

loadstring(readfile("shambles haxx/globals/information.lua"))()

local username = getgenv().username

printc("Welcome, ".. username .." to shambles haxx!")

if PlaceId == 299659045 or PlaceId == 292439477 then
    loadstring(readfile("shambles haxx/games/phantom-forces/development/core/source.lua"))()
else
    loadstring(readfile("shambles haxx/games/universal/development/core/source.lua"))()
end