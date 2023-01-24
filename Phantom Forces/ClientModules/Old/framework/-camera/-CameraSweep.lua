
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	UnionOperation = true, 
	MeshPart = true
};
local u2 = {
	getCameraPlaneMesh = function(p1, p2)
		local l__ViewportSize__1 = p1.ViewportSize;
		local l__NearPlaneZ__2 = p1.NearPlaneZ;
		local l__x__3 = l__ViewportSize__1.x;
		local l__y__4 = l__ViewportSize__1.y;
		local v5 = math.sqrt(l__x__3 * l__x__3 + l__y__4 * l__y__4);
		local v6 = math.tan(math.rad(p1.DiagonalFieldOfView / 2));
		local v7 = -l__NearPlaneZ__2 * v6 * l__x__3 / v5;
		local v8 = -l__NearPlaneZ__2 * v6 * l__y__4 / v5;
		local u3 = { p2 * Vector3.new(v7, v8, l__NearPlaneZ__2), p2 * Vector3.new(-v7, v8, l__NearPlaneZ__2), p2 * Vector3.new(v7, -v8, l__NearPlaneZ__2), p2 * Vector3.new(-v7, -v8, l__NearPlaneZ__2) };
		return function(p3)
			if not p3 then
				return p2.p;
			end;
			local v9 = nil;
			local v10 = (-1 / 0);
			for v11 = 1, 4 do
				local v12 = u3[v11]:Dot(p3);
				if v10 < v12 then
					v10 = v12;
					v9 = u3[v11];
				end;
			end;
			return v9;
		end;
	end
};
local u4 = shared.require("Region");
local u5 = shared.require("Raycast");
local function u6(p4)
	local v13 = u1[p4.ClassName];
	if v13 then
		v13 = false;
		if p4.Transparency == 0 then
			v13 = p4.CanCollide;
		end;
	end;
	return not v13;
end;
local u7 = shared.require("ConvexMesh");
local u8 = shared.require("Sweep");
function u2.sweep(p5, p6, p7, p8)
	local v14 = u2.getCameraPlaneMesh(p5, p6);
	local v15 = u4.new();
	v15:includeSweep(v14, p7);
	local v16 = workspace:FindPartsInRegion3WithIgnoreList(v15:getRegion3(), p8, (1 / 0));
	local v17 = u5.raycast(p6.Position, p7, p8, u6);
	local v18 = v17 and v17.Distance / p7.magnitude or 1;
	for v19 = 1, #v16 do
		local v20 = v16[v19];
		local v21, v22 = u7.makeFurthestPointFunction(v20);
		local v23 = nil;
		local v24 = nil;
		if not u1[v22] and v20.Transparency == 0 and v20.CanCollide then
			local v25, v26 = u8.mesh(v21, v14, p7, 0, true);
			v23 = v25;
			v24 = v26;
		end;
		if v23 and v24 < v18 and v24 > 0 then
			v18 = v24;
		end;
	end;
	return v18;
end;
return u2;

