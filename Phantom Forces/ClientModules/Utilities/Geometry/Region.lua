
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new()
	local v2 = setmetatable({}, v1);
	v2._minX = (1 / 0);
	v2._minY = (1 / 0);
	v2._minZ = (1 / 0);
	v2._maxX = (-1 / 0);
	v2._maxY = (-1 / 0);
	v2._maxZ = (-1 / 0);
	return v2;
end;
function v1.getRegion3(p1)
	return Region3.new(Vector3.new(p1._minX, p1._minY, p1._minZ), Vector3.new(p1._maxX, p1._maxY, p1._maxZ));
end;
function v1.reset(p2)
	p2._minX = (1 / 0);
	p2._minY = (1 / 0);
	p2._minZ = (1 / 0);
	p2._maxX = (-1 / 0);
	p2._maxY = (-1 / 0);
	p2._maxZ = (-1 / 0);
end;
function v1.includeBounds(p3, p4, p5, p6, p7, p8, p9, p10)
	p10 = p10 and 0;
	p3._minX = math.min(p3._minX, p4 - p10);
	p3._minY = math.min(p3._minY, p5 - p10);
	p3._minZ = math.min(p3._minZ, p6 - p10);
	p3._maxX = math.max(p3._maxX, p7 + p10);
	p3._maxY = math.max(p3._maxY, p8 + p10);
	p3._maxZ = math.max(p3._maxZ, p9 + p10);
end;
local u1 = Vector3.new(-1, 0, 0);
local u2 = Vector3.new(0, -1, 0);
local u3 = Vector3.new(0, 0, -1);
local u4 = Vector3.new(1, 0, 0);
local u5 = Vector3.new(0, 1, 0);
local u6 = Vector3.new(0, 0, 1);
function v1.includeMesh(p11, p12, p13)
	p11:includeBounds(p12(u1).x, p12(u2).y, p12(u3).z, p12(u4).x, p12(u5).y, p12(u6).z, p13);
end;
function v1.includeSweep(p14, p15, p16, p17)
	p14:includeBounds(p15(u1).x, p15(u2).y, p15(u3).z, p15(u4).x, p15(u5).y, p15(u6).z, p17);
	p14:includeBounds(p15(u1).x + p16.x, p15(u2).y + p16.y, p15(u3).z + p16.z, p15(u4).x + p16.x, p15(u5).y + p16.y, p15(u6).z + p16.z, p17);
end;
function v1.includeCapsule(p18, p19, p20, p21, p22)
	local l__x__3 = p19.x;
	local l__y__4 = p19.y;
	local l__z__5 = p19.z;
	local l__x__6 = p20.x;
	local l__y__7 = p20.y;
	local l__z__8 = p20.z;
	p18:includeBounds(l__x__3 + l__x__6 / 2 - math.abs(l__x__6 / 2) - p21, l__y__4 + l__y__7 / 2 - math.abs(l__y__7 / 2) - p21, l__z__5 + l__z__8 / 2 - math.abs(l__z__8 / 2) - p21, l__x__3 + l__x__6 / 2 + math.abs(l__x__6 / 2) + p21, l__y__4 + l__y__7 / 2 + math.abs(l__y__7 / 2) + p21, l__z__5 + l__z__8 / 2 + math.abs(l__z__8 / 2) + p21, p22);
end;
function v1.includeCylinder(p23, p24, p25, p26, p27)
	local l__x__9 = p24.x;
	local l__y__10 = p24.y;
	local l__z__11 = p24.z;
	local l__x__12 = p25.x;
	local l__y__13 = p25.y;
	local l__z__14 = p25.z;
	local v15 = l__x__12 * l__x__12 + l__y__13 * l__y__13 + l__z__14 * l__z__14;
	local v16 = p26 * math.sqrt(1 - l__x__12 * l__x__12 / v15);
	local v17 = p26 * math.sqrt(1 - l__y__13 * l__y__13 / v15);
	local v18 = p26 * math.sqrt(1 - l__z__14 * l__z__14 / v15);
	p23:includeBounds(l__x__9 + l__x__12 / 2 - math.abs(l__x__12 / 2) - v16, l__y__10 + l__y__13 / 2 - math.abs(l__y__13 / 2) - v17, l__z__11 + l__z__14 / 2 - math.abs(l__z__14 / 2) - v18, l__x__9 + l__x__12 / 2 + math.abs(l__x__12 / 2) + v16, l__y__10 + l__y__13 / 2 + math.abs(l__y__13 / 2) + v17, l__z__11 + l__z__14 / 2 + math.abs(l__z__14 / 2) + v18, p27);
end;
function v1.includeBox(p28, p29, p30, p31)
	local v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30 = p29:components();
	local l__x__31 = p30.x;
	local l__y__32 = p30.y;
	local l__z__33 = p30.z;
	local v34 = l__x__31 / 2 * math.abs(v22) + l__y__32 / 2 * math.abs(v23) + l__z__33 / 2 * math.abs(v24);
	local v35 = l__x__31 / 2 * math.abs(v25) + l__y__32 / 2 * math.abs(v26) + l__z__33 / 2 * math.abs(v27);
	local v36 = l__x__31 / 2 * math.abs(v28) + l__y__32 / 2 * math.abs(v29) + l__z__33 / 2 * math.abs(v30);
	p28:includeBounds(v19 - v34, v20 - v35, v21 - v36, v19 + v34, v20 + v35, v21 + v36, p31);
end;
function v1.includeSphere(p32, p33, p34)
	local l__x__37 = p33.x;
	local l__y__38 = p33.y;
	local l__z__39 = p33.z;
	p32:includeBounds(l__x__37, l__y__38, l__z__39, l__x__37, l__y__38, l__z__39, p34);
end;
function v1.getParts(p35, p36)
	local v40 = workspace:FindPartsInRegion3(p35:getRegion3(), (1 / 0));
	if not p36 then
		return v40;
	end;
	for v41 = #v40, 1, -1 do
		if p36(v40[v41]) then
			v40[v41] = v40[#v40];
			v40[#v40] = nil;
		end;
	end;
	return v40;
end;
return v1;

