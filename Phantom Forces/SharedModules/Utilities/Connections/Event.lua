
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new(p1, p2)
	return setmetatable({
		func = p2, 
		_event = p1
	}, v1);
end;
function v1.disconnect(p3)
	p3._event:disconnect(p3);
end;
v1.Disconnect = v1.disconnect;
local v2 = {};
v2.__index = v2;
function v2.new()
	return setmetatable({
		_connections = {}, 
		_removals = {}
	}, v2);
end;
function v2.fire(p4, ...)
	for v3 = #p4._connections, 1, -1 do
		local v4 = p4._connections[v3];
		if p4._removals[v4] then
			p4._removals[v4] = nil;
			table.remove(p4._connections, v3);
		end;
	end;
	for v5 = 1, #p4._connections do
		task.spawn(p4._connections[v5].func, ...);
	end;
end;
function v2.connectOnce(p5, p6)
	local u1 = nil;
	u1 = p5:connect(function(...)
		p6(...);
		u1:Disconnect();
	end);
end;
function v2.connect(p7, p8)
	local v6 = v1.new(p7, p8);
	table.insert(p7._connections, v6);
	return v6;
end;
function v2.disconnect(p9, p10)
	p9._removals[p10] = true;
end;
v2.Connect = v2.connect;
v2.Disconnect = v2.disconnect;
return v2;

