
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = {};
function v1.addTask(p1, p2)
	if not p1 then
		error("MenuUpdater: No task given");
	end;
	if not p2 then
		warn("MenuUpdater: No priority given, defaulting to 10");
		p2 = 10;
	end;
	local v2 = {
		task = p1, 
		priority = p2
	};
	table.insert(u1, v2);
	return function()
		local v3 = table.find(u1, v2);
		if not v3 then
			warn("MenuUpdater: Unable to find task", v2, "to be removed");
			return;
		end;
		u1[v3] = "remove";
	end;
end;
local u2 = nil;
local u3 = shared.require("HeartbeatUpdater");
local function u4(p3)
	for v4 = #u1, 1, -1 do
		if u1[v4] == "remove" then
			u1[v4] = u1[#u1];
			u1[#u1] = nil;
		end;
	end;
	table.sort(u1, function(p4, p5)
		return p4.priority < p5.priority;
	end);
	for v5 = 1, #u1 do
		u1[v5].task(p3);
	end;
end;
local u5 = shared.require("MenuScreenGui");
local function u6()
	u2 = u3.addTask(u4, 10);
end;
local function u7()
	if u2 then
		u2();
	end;
end;
function v1._init()
	u5.onEnabled:connect(u6);
	u5.onDisabled:connect(u7);
	if u5.isEnabled() then
		u2 = u3.addTask(u4, 10);
	end;
end;
return v1;

