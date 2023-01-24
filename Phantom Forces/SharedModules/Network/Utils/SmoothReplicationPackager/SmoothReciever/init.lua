
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	v2._decode = p1;
	v2._value0 = p2;
	v2._value1 = p2;
	return v2;
end;
function v1.readAndUpdate(p3, p4)
	p3._value0 = p3._value1;
	p3._value1 = 2 * p3._value1 - p3._value0 + p3._decode(p4);
	return p3._value1;
end;
function v1.initializeState(p5, p6, p7)
	p5._value0 = p6;
	p5._value1 = p7;
end;
return v1;

