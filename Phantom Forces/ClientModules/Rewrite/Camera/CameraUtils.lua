
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	toAnglesYXZ = function(p1, p2, p3)
		local v1 = nil;
		local v2 = nil;
		local v3 = nil;
		local v4 = nil;
		local v5 = nil;
		local v6 = nil;
		local v7 = nil;
		local v8 = nil;
		local v9 = nil;
		local v10 = nil;
		local v11 = nil;
		local v12 = nil;
		v5, v6, v7, v8, v9, v3, v2, v10, v1, v11, v12, v4 = p1:components();
		if v10 < 0 then
			local v13 = math.atan2(-v1, -math.sqrt(v2 * v2 + v10 * v10));
			local v14 = math.atan2(-v3, -v4);
			local v15 = math.atan2(-v2, -v10);
		else
			v13 = math.atan2(-v1, math.sqrt(v2 * v2 + v10 * v10));
			v14 = math.atan2(v3, v4);
			v15 = math.atan2(v2, v10);
		end;
		local v16 = u1.getClosestAngle((p2 + p3) / 2, v13);
		local v17 = u1.getClosestAngle((p2 + p3) / 2, math.pi - v13);
		if (not (p2 <= v16) or not (v16 <= p3)) and not (v17 < p2) and not (p3 < v17) then
			return v17, u1.getClosestAngle(0, v14 + math.pi), u1.getClosestAngle(0, v15 + math.pi);
		end;
		return v16, v14, v15;
	end, 
	getClosestAngle = function(p4, p5)
		return (p5 - p4 + math.pi) % (2 * math.pi) - math.pi + p4;
	end, 
	limitAnglesYX = function(p6, p7, p8)
		local v18 = nil;
		local v19 = nil;
		local v20 = nil;
		local v21 = nil;
		local v22 = nil;
		local v23 = nil;
		local v24 = nil;
		local v25 = nil;
		local v26 = nil;
		local v27 = nil;
		local v28 = nil;
		local v29 = nil;
		v22, v23, v24, v25, v19, v18, v26, v27, v28, v29, v21, v20 = p6:components();
		local v30 = math.atan2(-v28, v27);
		local v31 = math.atan2(-v29, v25);
		if v30 < p7 then
			local v32 = math.cos(p7);
			local v33 = math.sin(p7);
			return p7, math.atan2(-v29 + v18 * v32 + v19 * v33, v25 + v20 * v32 + v21 * v33);
		end;
		if p8 < v30 then
			local v34 = math.cos(p8);
			local v35 = math.sin(p8);
			v30 = p8;
			v31 = math.atan2(-v29 + v18 * v34 + v19 * v35, v25 + v20 * v34 + v21 * v35);
		end;
		return v30, v31;
	end, 
	getOffsetAxisAngle = function(p9, p10)
		local v36, v37 = p9:toObjectSpace(p10):toAxisAngle();
		return v37 * v36;
	end
};
return u1;

