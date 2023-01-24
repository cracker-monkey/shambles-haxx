
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("FibDecoder");
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2._decoder = u1.new(p1);
	return v2;
end;
function v1.__call(p2, p3)
	return Vector3.new(p2._decoder(p3), p2._decoder(p3), p2._decoder(p3));
end;
return v1;

