
-- Decompiled with the Synapse X Luau decompiler.

return {
	isInside = function(p1, p2, p3, p4, p5, p6, p7, p8)
		local v1 = p7 - p1;
		local v2 = p8 - p2;
		local v3 = p3 * p6 - p5 * p4;
		local v4 = (v2 * p4 - v1 * p6) / v3;
		local v5 = (v2 * p3 - v1 * p5) / v3;
		local v6 = false;
		if v4 >= -1 then
			v6 = false;
			if v4 <= 1 then
				v6 = false;
				if v5 >= -1 then
					v6 = v5 <= 1;
				end;
			end;
		end;
		return v6;
	end, 
	getClosestPoint = function(p9, p10, p11, p12, p13, p14, p15, p16)
		local v7 = p15 - p9;
		local v8 = p16 - p10;
		local v9 = p11 * p14 - p13 * p12;
		local v10 = (v7 * p14 - v8 * p12) / v9;
		local v11 = (v8 * p11 - v7 * p13) / v9;
		local v12 = p11 * p11 + p13 * p13;
		local v13 = p12 * p12 + p14 * p14;
		local v14 = ((v7 - p11) * p12 + (v8 - p13) * p14) / v13;
		local v15 = ((v7 + p11) * p12 + (v8 + p13) * p14) / v13;
		local v16 = ((v7 - p12) * p11 + (v8 - p14) * p13) / v12;
		local v17 = ((v7 + p12) * p11 + (v8 + p14) * p13) / v12;
		if v14 > 1 and v16 > 1 then
			return p9 + p11 + p12, p10 + p13 + p14;
		end;
		if v14 < -1 and v17 > 1 then
			return p9 + p11 - p12, p10 + p13 - p14;
		end;
		if v15 > 1 and v16 < -1 then
			return p9 - p11 + p12, p10 - p13 + p14;
		end;
		if v15 < -1 and v17 < -1 then
			return p9 - p11 - p12, p10 - p13 - p14;
		end;
		if v10 > 1 then
			return p9 + p11 + v14 * p12, p10 + p13 + v14 * p14;
		end;
		if v11 > 1 then
			return p9 + v16 * p11 + p12, p10 + v16 * p13 + p14;
		end;
		if v10 < -1 then
			return p9 - p11 + v14 * p12, p10 - p13 + v14 * p14;
		end;
		if not (v11 < -1) then
			return p15, p16;
		end;
		return p9 + v16 * p11 - p12, p10 + v16 * p13 - p14;
	end
};

