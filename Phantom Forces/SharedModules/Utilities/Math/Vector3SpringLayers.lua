
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Vector3Spring");
local u2 = Vector3.new();
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2._springLayers = {};
	v2._activeParameters = p1;
	for v3 = 1, #p1 do
		local v4 = p1[v3];
		table.insert(v2._springLayers, u1.new(u2, v4.Damping, v4.Speed));
	end;
	return v2;
end;
function v1.getPosition(p2)
	local v5 = nil;
	v5 = u2;
	for v6 = 1, #p2._springLayers do
		v5 = v5 + p2._springLayers[v6].p;
	end;
	return local v7;
end;
function v1.applyImpulse(p3)
	for v8 = 1, #p3._springLayers do
		local v9 = p3._activeParameters[v8];
		local l__Mean__10 = v9.Mean;
		local l__Variance__11 = v9.Variance;
		local l__x__12 = l__Variance__11.x;
		local l__y__13 = l__Variance__11.y;
		local l__z__14 = l__Variance__11.z;
		p3._springLayers[v8].v = Vector3.new(l__x__12 * 2 * math.random() - l__x__12 + l__Mean__10.x, l__y__13 * 2 * math.random() - l__y__13 + l__Mean__10.y, l__z__14 * 2 * math.random() - l__z__14 + l__Mean__10.z);
	end;
end;
function v1.updateLayer(p4, p5, p6)
	local v15 = p4._springLayers[p6];
	if not v15 then
		warn("Vector3SpringLayers: Attempt to set layer for invalid index", p5, p6);
		return;
	end;
	v15.d = p5.Damping;
	v15.s = p5.Speed;
end;
function v1.setActiveParameters(p7, p8)
	if #p7._springLayers < #p8 then
		warn("Vector3SpringLayers: Attempt to set parameters with inconsistent layer count", #p8, #p7._springLayers);
		return;
	end;
	p7._activeParameters = p8;
	for v16 = 1, #p8 do
		p7:updateLayer(p7._activeParameters[v16], v16);
	end;
end;
return v1;

