# LUA Api for shambles haxx.

Cheat table
---
cheat
---
    cheat.print(text (string), color (color3))
    ---
    cheat.notify(text (string), time (int), type (string - "move", "time", "normal"))
    ---
    cheat.username
    ---
    cheat.uid
    ---
    cheat.library
    ---
    cheat.window
    ---
    cheat.tabs
    ---
    friends
    ---
    cheat.scripts:
    ---
        cheat.scripts:Run(file (string)) (File must be located in LUA folder.)
---
Websockets table
---
websockets
---
    websockets:connect(port (int))
    ---
    websockets:send(text (string))
    ---
    websockets:close(websocket)
---
Event table
---
event
---
    event:new()
    ---
    event_name:add(name (string), callback)
    ---
    event_name:call(name, ...)
---
