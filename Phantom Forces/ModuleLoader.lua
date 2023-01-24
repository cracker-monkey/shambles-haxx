
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new(p1)
	local v2 = {
		_cache = {}, 
		_requireStack = {}, 
		_server = game:GetService("RunService"):IsServer()
	};
	for v3, v4 in next, p1 do
		for v5, v6 in next, v4:GetDescendants() do
			if v6:IsA("ModuleScript") then
				if v2._cache[v6.Name] then
					warn(string.format("Warning: Duplicate name of %q already exists! Undefined behavior!", v6.Name));
				end;
				v2._cache[v6.Name] = {
					object = v6, 
					module = nil, 
					requires = 0
				};
			end;
		end;
	end;
	return setmetatable(v2, v1);
end;
function v1.require(p2, p3)
	local v7 = p2._cache[p3];
	local v8 = string.format("Module %q not found!", p3);
	if not v7 then
		error(v8, 0);
	end;
	v7.requires = v7.requires + 1;
	if v7.module then
		return v7.module;
	end;
	if table.find(p2._requireStack, p3) then
		table.insert(p2._requireStack, p3);
		error(string.format("Reciprocal require attempted! RequireStack: %s", table.concat(p2._requireStack, " -> ")), 0);
	end;
	table.insert(p2._requireStack, p3);
	if p2._server then
		v7.module = require(v7.object);
	else
		local v9, v10 = pcall(require, v7.object);
		if v9 then
			v7.module = v10;
		else
			error(string.format("Error when requiring: %s", table.concat(p2._requireStack, " -> ")), 0);
		end;
	end;
	table.remove(p2._requireStack);
	if type(v7.module) == "table" and type(v7.module._init) == "function" then
		v7.module:_init(p2);
	end;
	return v7.module;
end;
function v1.add(p4, p5, p6)
	if p4._cache[p5] then
		error(string.format("%s Is already registered", p5));
	end;
	p4._cache[p5] = {
		module = p6, 
		requires = 0
	};
end;
function v1.requireCache(p7)
	for v11 in next, p7._cache do
		p7:require(v11);
	end;
end;
function v1.ClearScripts(p8)
	local l__next__12 = next;
	local l___cache__13 = p8._cache;
	local v14 = nil;
	while true do
		local v15, v16 = l__next__12(l___cache__13, v14);
		if not v15 then
			break;
		end;
		if v16.object then
			v16.object.Parent = nil;
		end;
		if v16.requires == 0 then
			warn("Unused module", v15);
		end;	
	end;
end;
return v1;

