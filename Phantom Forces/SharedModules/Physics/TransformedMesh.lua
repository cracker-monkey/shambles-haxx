
-- Decompiled with the Synapse X Luau decompiler.

local u1 = shared.require("BitBuffer64");
local u2 = { Enum.CollisionFidelity.Hull, Enum.CollisionFidelity.PreciseConvexDecomposition };
local function u3(p1)
	local v1 = nil;
	local v2 = nil;
	local v3 = u1.newReader(p1);
	v1 = Vector3.new((1 / 0), (1 / 0), (1 / 0));
	v2 = Vector3.new((-1 / 0), (-1 / 0), (-1 / 0));
	local v4 = {};
	for v5 = 1, v3:readFib() do
		local v6 = {};
		local v7 = {};
		for v8 = 1, v3:readFib() do
			local v9 = Vector3.new(v3:readFloat(), v3:readFloat(), v3:readFloat());
			v6[v8] = v9;
			v1 = v1:Min(v9);
			v2 = v2:Max(v9);
		end;
		for v10 = 1, v3:readFib() do
			v7[v10] = Vector3.new(v3:readFib() + 1, v3:readFib() + 1, v3:readFib() + 1);
		end;
		v4[v5] = {
			verts = v6, 
			tris = v7
		};
	end;
	local v11 = (local v12 + local v13) / 2;
	local v14 = v13 - v12;
	for v15, v16 in v4, nil do
		local l__verts__17 = v16.verts;
		for v18, v19 in l__verts__17, nil do
			l__verts__17[v18] = (v19 - v11) / v14;
		end;
	end;
	return v4;
end;
local u4 = { function(p2)
		if not p2 then
			return Vector3.zero;
		end;
		local v20 = 0.5;
		local v21 = 0.5;
		local v22 = 0.5;
		if p2.x < 0 then
			v20 = -0.5;
		end;
		if p2.y < 0 then
			v21 = -0.5;
		end;
		if p2.z < 0 then
			v22 = -0.5;
		end;
		return Vector3.new(v20, v21, v22);
	end };
local v23 = {};
v23.__index = v23;
function v23.new(p3, p4, p5, p6)
	return setmetatable({
		query = p3, 
		cframe = p4, 
		size = p5, 
		radius = p6 and 0, 
		elasticity = 0, 
		friction = 1, 
		canCollide = true, 
		data = nil
	}, v23);
end;
local u5 = nil;
local function u6(p7)
	local v24 = u1.newReader(p7);
	local v25 = {};
	for v26 = 1, v24:readFib() do
		local v27 = v24:readFib();
		if not v25[v27] then
			v25[v27] = {};
		end;
		local v28 = u3((v24:readString64()));
		local v29 = {};
		for v30 = 1, #v28 do
			local l__verts__7 = v28[v30].verts;
			v29[v30] = function(p8)
				if not p8 then
					return Vector3.zero;
				end;
				local v31 = nil;
				local v32 = (-1 / 0);
				for v33 = 1, #l__verts__7 do
					local v34 = l__verts__7[v33];
					local v35 = v34:Dot(p8);
					if v32 < v35 then
						v31 = v34;
						v32 = v35;
					end;
				end;
				return v31;
			end;
		end;
		v25[v27][u2[v24:readFib()]] = v29;
	end;
	return v25;
end;
function v23.importCollisionData(p9)
	if not p9 then
		u5 = nil;
		return;
	end;
	u5 = u6(p9);
end;
local function u8(p10, p11, p12)
	if not p10[p11] then
		return u4;
	end;
	if p10[p11][p12] then
		return p10[p11][p12];
	end;
	if p10[p11][Enum.CollisionFidelity.PreciseConvexDecomposition] then
		return p10[p11][Enum.CollisionFidelity.PreciseConvexDecomposition];
	end;
	if p10[p11][Enum.CollisionFidelity.Hull] then
		return p10[p11][Enum.CollisionFidelity.Hull];
	end;
	return select(2, next(p10[p11]));
end;
function v23.fromPart(p13, p14, p15)
	debug.profilebegin("TM Part");
	local v36 = {};
	local v37 = p13:GetAttribute("Id");
	local l__ClassName__38 = p13.ClassName;
	if p15 and v37 and u5 then
		local l__CFrame__39 = p13.CFrame;
		local l__Size__40 = p13.Size;
		for v41, v42 in u8(u5, v37, p13.CollisionFidelity), nil do
			v36[v41] = v23.new(v42, l__CFrame__39, l__Size__40, p14);
		end;
	elseif l__ClassName__38 == "Part" then
		local l__Name__43 = p13.Shape.Name;
		if l__Name__43 == "Ball" then
			local l__Size__44 = p13.Size;
			v36[1] = v23.new(v23._queryPoint, p13.CFrame, Vector3.one, math.min(l__Size__44.x, l__Size__44.y, l__Size__44.z) / 2 + (p14 and 0));
		elseif l__Name__43 == "Cylinder" then
			local l__Size__45 = p13.Size;
			local v46 = math.min(l__Size__45.y, l__Size__45.z) / 2;
			v36[1] = v23.new(v23._queryPseudoCylinder, p13.CFrame, Vector3.new(l__Size__45.x, 2 * v46, 2 * v46), p14);
		else
			v36[1] = v23.new(v23._queryBox, p13.CFrame, p13.Size, p14);
		end;
	elseif l__ClassName__38 == "WedgePart" then
		v36[1] = v23.new(v23._queryWedge, p13.CFrame, p13.Size, p14);
	elseif l__ClassName__38 == "CornerWedgePart" then
		v36[1] = v23.new(v23._queryCornerWedge, p13.CFrame, p13.Size, p14);
	else
		v36[1] = v23.new(v23._queryBox, p13.CFrame, p13.Size, p14);
	end;
	local l__Elasticity__47 = p13.Elasticity;
	local l__Friction__48 = p13.Friction;
	local l__CanCollide__49 = p13.CanCollide;
	for v50, v51 in v36, nil do
		v51.elasticity = l__Elasticity__47;
		v51.friction = l__Friction__48;
		v51.canCollide = l__CanCollide__49;
		v51.part = p13;
	end;
	debug.profileend();
	return v36;
end;
function v23._queryBox(p16)
	if not p16 then
		return Vector3.zero;
	end;
	if p16.x < 0 then
		local v52 = -0.5;
	else
		v52 = 0.5;
	end;
	if p16.y < 0 then
		local v53 = -0.5;
	else
		v53 = 0.5;
	end;
	if p16.z < 0 then
		local v54 = -0.5;
	else
		v54 = 0.5;
	end;
	return Vector3.new(v52, v53, v54);
end;
local u9 = 2 * math.pi / 24;
function v23._queryPseudoCylinder(p17)
	local v55 = nil;
	if not p17 then
		return Vector3.zero;
	end;
	local v56 = math.atan2(p17.z, p17.y) + u9 / 2;
	v55 = v56 - v56 % u9;
	if p17.x < 0 then
		return Vector3.new(-0.5, math.cos(v55) / 2, math.sin(v55) / 2);
	end;
	return Vector3.new(0.5, math.cos(v55) / 2, math.sin(v55) / 2);
end;
local u10 = { Vector3.new(-0.5, -0.5, -0.5), Vector3.new(-0.5, -0.5, 0.5), Vector3.new(0.5, -0.5, -0.5), Vector3.new(0.5, -0.5, 0.5), Vector3.new(0.5, 0.5, -0.5) };
function v23._queryCornerWedge(p18)
	if not p18 then
		return Vector3.zero;
	end;
	local v57 = (-1 / 0);
	local v58 = nil;
	for v59, v60 in u10, nil do
		local v61 = v60:Dot(p18);
		if v57 < v61 then
			v57 = v61;
			v58 = v60;
		end;
	end;
	return v58;
end;
local u11 = { Vector3.new(-0.5, -0.5, -0.5), Vector3.new(-0.5, -0.5, 0.5), Vector3.new(0.5, -0.5, -0.5), Vector3.new(0.5, -0.5, 0.5), Vector3.new(-0.5, 0.5, 0.5), Vector3.new(0.5, 0.5, 0.5) };
function v23._queryWedge(p19)
	if not p19 then
		return Vector3.zero;
	end;
	local v62 = (-1 / 0);
	local v63 = nil;
	for v64, v65 in u11, nil do
		local v66 = v65:Dot(p19);
		if v62 < v66 then
			v62 = v66;
			v63 = v65;
		end;
	end;
	return v63;
end;
function v23._queryPoint(p20)
	return Vector3.zero;
end;
function v23.__call(p21, p22)
	return p21.cframe * (p21.query(p22 and p21.cframe:vectorToObjectSpace(p22) * p21.size) * p21.size);
end;
return v23;

