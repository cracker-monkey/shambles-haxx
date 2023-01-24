
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	v2._root = p1;
	v2._checked = p2 and false;
	v2._containerType = nil;
	return v2;
end;
function v1.setContainerType(p3, p4)
	p3._containerType = p4;
end;
function v1._checkErrors(p5)
	local v3 = {};
	for v4, v5 in p5._root() do
		if not p5._containerType or v5.Parent.ClassName == p5._containerType then
			if v3[v5.Name] then
				error(string.format("Duplicate named Object %s in %s", v5.Name, p5._root:GetFullName()));
			end;
			v3[v5.Name] = true;
		end;
	end;
	p5._checked = true;
end;
function v1.getRoot(p6)
	return p6._root;
end;
function v1.get(p7, p8)
	if not p7._checked then
		p7:_checkErrors();
	end;
	for v6, v7 in p7._root() do
		if (not p7._containerType or v7.Parent.ClassName == p7._containerType) and v7.Name == p8 then
			return v7;
		end;
	end;
end;
function v1.getAllOfType(p9, p10)
	local v8 = {};
	for v9, v10 in p9._root() do
		if v10:IsA(p10) then
			table.insert(v8, v10);
		end;
	end;
	return v8;
end;
return v1;

