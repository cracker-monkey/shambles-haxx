
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new(p1, p2)
	return setmetatable({
		_event = p1, 
		_func = p2
	}, v1);
end;
function v1.disconnect(p3)
	p3._event:disconnect(p3);
end;
local u1 = shared.require("FastSpawn");
function v1.call(p4)
	u1(p4._func);
end;
local v2 = {};
v2.__index = v2;
function v2.new()
	return setmetatable({
		_fired = false, 
		_connections = {}
	}, v2);
end;
function v2.connect(p5, p6)
	local v3 = v1.new(p5, p6);
	p5._connections[v3] = true;
	if p5._fired then
		warn(debug.traceback("SingleEvent: Check singleEvent:hasFired() == false before connecting to it.", 2));
		v3:call();
	end;
	return v3;
end;
function v2.hasFired(p7)
	return p7._fired;
end;
function v2.disconnect(p8, p9)
	p8._connections[p9] = nil;
end;
function v2.fire(p10)
	if p10._fired then
		return;
	end;
	p10._fired = true;
	while next(p10._connections) do
		local v4 = next(p10._connections);
		v4:call();
		v4:disconnect();	
	end;
end;
return v2;

