
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("spring");
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2._springs = {};
	for v3 = 1, p1 do
		table.insert(v2._springs, u1.new(0));
	end;
	return v2;
end;
function v1.getPosition(p2)
	local v4 = nil;
	v4 = 0;
	for v5 = 1, #p2._springs do
		v4 = v4 + p2._springs[v5].p;
	end;
	return local v6;
end;
function v1.applyImpulse(p3)
	for v7 = 1, #p3._springLayerParameters do
		local v8 = p3._springLayerParameters[v7];
		local v9 = v8[4];
		p3._springs[v7].v = v9 * 2 * math.random() - v9 + v8[3];
	end;
end;
function v1.updateLayer(p4, p5, p6)
	local v10 = p4._springs[p5];
	if not v10 then
		warn("SpringLayers: Attempt to set layer for invalid index", p6, p5);
		return;
	end;
	v10.d = p6[1];
	v10.s = p6[2];
end;
function v1.setParameters(p7, p8)
	if #p7._springs < #p8 then
		warn("SpringLayers: Not enough springs to set parameters", #p8, #p7._springs);
		return;
	end;
	p7._springLayerParameters = p8;
	for v11 = 1, #p7._springLayerParameters do
		p7:updateLayer(v11, p7._springLayerParameters[v11]);
	end;
end;
return v1;

