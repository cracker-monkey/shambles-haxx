local PlaceId = game.PlaceId

local function printc(text)
    if syn then
        rconsoleprint(text)
    else
        warn(text)
    end
end

getgenv().ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/addons/ThemeManager.lua'))()
getgenv().SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/addons/SaveManager.lua'))()

printc("Hello developer to shambles haxx!")

if PlaceId == 299659045 or PlaceId == 292439477 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FunnyManWrehas/shambles-haxx/main/games/phantom-forces/development/core/phantom-forces%20-%20development.lua?token=GHSAT0AAAAAAB2IVB74JBOYMMUWXADD333KY4UQMQQ"))
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FunnyManWrehas/shambles-haxx/main/games/universal/development/core/universal%20-%20development.lua?token=GHSAT0AAAAAAB2IVB743SQGHGG7IRNS63WQY4UQM5A"))
end