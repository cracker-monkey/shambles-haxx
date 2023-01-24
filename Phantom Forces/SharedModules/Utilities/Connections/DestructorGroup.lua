
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new()
	local v2 = setmetatable({}, v1);
	v2._destructorHash = {};
	return v2;
end;
function v1.Destroy(p1)
	for v3, v4 in p1._destructorHash, nil do
		v4:Destroy();
	end;
end;
local u1 = shared.require("Destructor");
function v1.add(p2, p3)
	local v5 = u1.new();
	p2._destructorHash[p3] = v5;
	return v5;
end;
function v1.run(p4, p5)
	local v6 = p4._destructorHash[p5];
	if v6 then
		v6:Destroy();
	end;
	p4._destructorHash[p5] = nil;
end;
function v1.runAndReplace(p6, p7)
	local v7 = p6._destructorHash[p7];
	if v7 then
		v7:Destroy();
	end;
	local v8 = u1.new();
	p6._destructorHash[p7] = v8;
	return v8;
end;
return v1;

