
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	isInside = function(p1, p2, p3, p4, p5, p6, p7, p8)
		local v1 = p7 - p1;
		local v2 = p8 - p2;
		local v3 = p3 * p6 - p5 * p4;
		local v4 = v2 * p4 - v1 * p6;
		local v5 = v2 * p3 - v1 * p5;
		return v4 * v4 + v5 * v5 <= v3 * v3;
	end, 
	getH = function(p9, p10, p11, p12)
		return ((p11 + p10) ^ 2 + (p9 - p12) ^ 2) / ((p11 - p10) ^ 2 + (p9 + p12) ^ 2);
	end, 
	getClosestPoint = function(p13, p14, p15, p16, p17, p18, p19, p20, p21)
		local v6 = nil;
		local v7 = p21 and 1E-05;
		local v8 = p19 - p13;
		local v9 = p20 - p14;
		local v10 = p15 * p18 - p17 * p16;
		local v11 = (v8 * p18 - v9 * p16) / v10;
		local v12 = (v9 * p15 - v8 * p17) / v10;
		local v13 = math.sqrt(v11 * v11 + v12 * v12);
		if v13 < 1 then
			return p19, p20;
		end;
		if u1.getH(p15, p16, p17, p18) < v7 * v7 / 4 then
			local v14 = v11 / v13;
			local v15 = v12 / v13;
			return p13 + v14 * p15 + v15 * p16, p14 + v14 * p17 + v15 * p18;
		end;
		v6 = 0;
		local l__math_pi__16 = math.pi;
		local v17, v18 = math.frexp(1 / v7);
		for v19 = 1, math.min(v18, 53) do
			local v20 = l__math_pi__16 / 2;
			local v21 = math.cos(v6);
			local v22 = math.sin(v6);
			if (p18 * v21 - p17 * v22) * (v9 - (p17 * v21 + p18 * v22)) - (p15 * v22 - p16 * v21) * (v8 - (p15 * v21 + p16 * v22)) > 0 then
				local v23 = v6 + v20;
			else
				v23 = v6 - v20;
			end;
		end;
		local v24 = math.cos(v23);
		local v25 = math.sin(v23);
		return p13 + v24 * p15 + v25 * p16, p14 + v24 * p17 + v25 * p18;
	end
};
return u1;

