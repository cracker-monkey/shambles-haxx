
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2._constants = v2:_getConstants(p1);
	v2._dim = p1;
	v2._cache = {};
	return v2;
end;
function v1.getPoint(p2, p3)
	for v3 = 1, p2._dim do
		p2._cache[v3] = p2._constants[v3] * p3 % 1;
	end;
	return unpack(p2._cache);
end;
function v1._getPhi(p4, p5)
	local v4 = nil;
	v4 = 1;
	for v5 = 1, 6 do
		local v6 = v4 ^ (p5 + 1);
		v4 = v4 - v4 * (v6 - v4 - 1) / (p5 * v6 + 1);
	end;
	return local v7;
end;
function v1._getConstants(p6, p7)
	local v8 = {};
	local v9 = p6:_getPhi(p7);
	for v10 = 1, p7 do
		v8[v10] = 1 / v9 ^ v10;
	end;
	return v8;
end;
return v1;

