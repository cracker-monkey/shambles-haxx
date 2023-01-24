
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = {};
function v1.addTask(p1, p2)
	if not p1 then
		error("RunUpdater: No task given");
	end;
	if not p2 then
		warn("RunUpdater: No priority given, defaulting to 10");
		p2 = 10;
	end;
	local v2 = {
		task = p1, 
		priority = p2
	};
	table.insert(u1, v2);
	local u2 = nil;
	return function()
		if u2 then
			warn("Already disconnected", v2);
			return;
		end;
		local v3 = table.find(u1, v2);
		if not v3 then
			warn("RunUpdater: Unable to find task", v2, "to be removed");
			return;
		end;
		u2 = true;
		u1[v3] = "remove";
	end;
end;
function v1.step(p3)
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
		if u1[v5] ~= "remove" then
			u1[v5].task(p3);
		end;
	end;
end;
return v1;

