
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new()
	local v2 = setmetatable({}, v1);
	v2._taskContainers = {};
	v2._locked = false;
	v2._changed = false;
	v2._additions = {};
	v2._removals = {};
	return v2;
end;
function v1.lock(p1)
	p1._locked = true;
end;
function v1.unlock(p2)
	p2._locked = false;
end;
function v1.addTask(p3, p4, p5, p6)
	assert(type(p4) == "string", "OrderedTaskRunner: No name given");
	assert(type(p5) == "function", "OrderedTaskRunner: No task given");
	local v3 = {
		name = p4, 
		task = p5, 
		dependencies = p6 or {}
	};
	p3._additions[v3] = true;
	p3._changed = true;
	return function()
		p3._removals[v3] = true;
		p3._changed = true;
	end;
end;
function v1._processAdditions(p7)
	for v4 in p7._additions, nil do
		p7._additions[v4] = nil;
		if not p7._taskContainers[v4.name] then
			p7._taskContainers[v4.name] = {
				name = v4.name, 
				tasks = {}
			};
		end;
		p7._taskContainers[v4.name].tasks[v4] = true;
	end;
end;
function v1._processRemovals(p8)
	local l___removals__5 = p8._removals;
	local v6 = nil;
	local v7 = nil;
	while true do
		local v8 = l___removals__5(v6, v7);
		if not v8 then
			break;
		end;
		p8._removals[v8] = nil;
		local v9 = p8._taskContainers[v8.name];
		if v9 then
			v9.tasks[v8] = nil;
		end;
		if not next(v9.tasks) then

		end;	
	end;
end;
function v1._runTaskByName(p9, p10, p11, ...)
	if not p9._taskContainers[p11] then
		warn("OrderedTaskRunner:", p11, "is not a dependency");
		return;
	end;
	if p10[p11] ~= nil then
		if p10[p11] == "processing" then
			warn("OrderedTaskRunner: Cyclical dependency involving", p11);
			return;
		else
			if p10[p11] == "complete" then

			end;
			return;
		end;
	end;
	p10[p11] = "processing";
	local l__tasks__10 = p9._taskContainers[p11].tasks;
	debug.profilebegin(p11);
	for v11 in p9._taskContainers[p11].tasks, nil do
		for v12, v13 in v11.dependencies, nil do
			p9:_runTaskByName(p10, v13, ...);
		end;
		v11.task(...);
	end;
	debug.profileend();
	p10[p11] = "complete";
end;
function v1._processTasks(p12, ...)
	local v14 = {};
	for v15 in p12._taskContainers, nil do
		p12:_runTaskByName(v14, v15, ...);
	end;
end;
function v1.step(p13, ...)
	if p13._locked then
		return;
	end;
	if p13._changed then
		p13:_processAdditions();
		p13:_processRemovals();
	end;
	p13:_processTasks(...);
end;
return v1;

