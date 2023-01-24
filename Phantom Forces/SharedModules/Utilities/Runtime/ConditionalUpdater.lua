
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	v2._updateFunc = p1;
	v2._stopFunc = p2;
	v2._disconnection = nil;
	return v2;
end;
function v1.Destroy(p3)
	if p3._disconnection then
		p3._disconnection();
	end;
end;
local u1 = shared.require("HeartbeatUpdater");
function v1.start(p4)
	if p4._disconnection then
		p4._disconnection();
		p4._disconnection = nil;
	end;
	p4._disconnection = u1.addTask(function()
		p4._updateFunc();
		if p4._stopFunc and p4._stopFunc() then
			p4._disconnection();
			p4._disconnection = nil;
		end;
	end, 10);
end;
return v1;

