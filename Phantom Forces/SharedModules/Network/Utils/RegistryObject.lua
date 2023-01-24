
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2.name = p1;
	v2._registryDatabase = {};
	return v2;
end;
function v1.getEntry(p2, p3)
	return p2._registryDatabase[p3];
end;
function v1.addEntry(p4, p5, p6)
	p4._registryDatabase[p5] = p6;
	return p4:getEntry(p5);
end;
function v1.removeEntry(p7, p8)
	local v3 = p7:getEntry(p8);
	if not v3 then
		warn("RegistryObject: Could not find", p8, "key in", p7.name, "registry");
		return;
	end;
	p7._registryDatabase[p8] = nil;
	return v3;
end;
function v1.operateOnAllEntries(p9, p10)
	for v4, v5 in p9._registryDatabase, nil do
		p10(v4, v5);
	end;
end;
function v1.print(p11)
	print("RegistryObject: Printing elements of", p11.name, "...");
	for v6, v7 in p11._registryDatabase, nil do
		print("RegistryObject:", p11.name, v6, v7);
	end;
end;
return v1;

