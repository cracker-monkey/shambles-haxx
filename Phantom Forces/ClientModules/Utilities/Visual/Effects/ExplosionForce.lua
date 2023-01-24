
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local function u1(p1, p2, p3, p4)
	local v2 = p1 * (p3[1] * p2);
	local v3 = p1 * (p3[2] * p2);
	local v4 = p1 * (p3[3] * p2);
	return (v3:Cross(v4) + v4:Cross(v2) + v2:Cross(v3)):Dot(p4 - v2);
end;
local function u2(p5, p6, p7)
	local v5 = p6 - p5;
	local v6 = p7 - p5;
	local v7 = v5:Cross(v6);
	local v8 = v5:Dot(v6);
	local l__magnitude__9 = v7.magnitude;
	if not (l__magnitude__9 > 1E-08) then
		return Vector3.zero;
	end;
	return (math.atan((v8 - v5:Dot(v5)) / l__magnitude__9) + math.atan((v8 - v6:Dot(v6)) / l__magnitude__9)) / (2 * l__magnitude__9) * v7;
end;
function v1.computeMeshExplosionForce(p8, p9, p10, p11)
	local v10 = Vector3.zero;
	for v11, v12 in p11, nil do
		if u1(p9, p10, v12, p8) > 0 then
			local v13 = #v12;
			for v14 = 1, v13 do
				v10 = v10 + u2(p8, p9 * (v12[v14] * p10), p9 * (v12[v14 % v13 + 1] * p10));
			end;
		end;
	end;
	return v10;
end;
return v1;

