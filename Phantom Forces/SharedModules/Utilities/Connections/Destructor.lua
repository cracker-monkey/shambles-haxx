
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new()
	local v2 = setmetatable({}, v1);
	v2._tasks = {};
	return v2;
end;
function v1.Destroy(p1)
	for v3, v4 in p1._tasks, nil do
		p1:_attemptDestroy(v4);
		p1._tasks[v3] = nil;
	end;
	setmetatable(p1, nil);
end;
function v1.add(p2, p3)
	table.insert(p2._tasks, p3);
end;
function v1._attemptDestroy(p4, p5)
	local v5 = typeof(p5);
	if v5 == "nil" then
		return;
	end;
	if v5 == "table" then
		if type(p5.destroy) == "function" then
			p5:destroy();
			return;
		end;
		if type(p5.Destroy) == "function" then
			p5:Destroy();
			return;
		end;
		if type(p5.remove) == "function" then
			p5:remove();
			return;
		end;
		if type(p5.Remove) == "function" then
			p5:Remove();
			return;
		end;
		if type(p5.disconnect) == "function" then
			p5:disconnect();
			return;
		end;
		if getmetatable(p5) == v1 then
			return;
		end;
	else
		if v5 == "function" then
			p5();
			return;
		end;
		if v5 == "Instance" then
			p5:Destroy();
			return;
		end;
		if v5 == "RBXScriptConnection" then
			p5:Disconnect();
			return;
		end;
	end;
	error(string.format("Destructor was given a task it cannot handle! Type: %q Value: %q", tostring(v5), tostring(p5)), 0);
end;
return v1;

