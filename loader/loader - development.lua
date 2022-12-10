local PlaceId = game.PlaceId

local function printc(text)
    if syn then
        rconsoleprint(text)
    else
        warn(text)
    end
end

printc("Hello developer to shambles haxx!")

if PlaceId == 299659045 or PlaceId == 292439477 then
    loadstring(readfile("shambles haxx/games/phantom-forces/development/core/pf.lua"))()
else
    loadstring(readfile("shambles haxx/games/universal/development/core/universal.lua"))()
end