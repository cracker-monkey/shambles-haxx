
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__math_atan2__1 = math.atan2;
local l__math_cos__2 = math.cos;
local l__math_sin__3 = math.sin;
local function u4(p1, p2, p3, p4, p5)
	if not p1 then
		return;
	end;
	if p1 > -1E-10 and p1 < 1E-10 then
		return u4(p2, p3, p4, p5);
	end;
	if not p5 then
		if p4 then
			local v2 = -p2 / (3 * p1);
			local v3 = (3 * p1 * p3 - p2 * p2) / (9 * p1 * p1);
			local v4 = (2 * p2 * p2 * p2 - 9 * p1 * p2 * p3 + 27 * p1 * p1 * p4) / (54 * p1 * p1 * p1);
			local v5 = v3 * v3 * v3 + v4 * v4;
			local v6 = v5 ^ 0.5 + v4;
			if v6 > -1E-10 and v6 < 1E-10 then
				if v4 < 0 then
					return v2 + (-2 * v4) ^ 0.3333333333333333;
				else
					return v2 - (2 * v4) ^ 0.3333333333333333;
				end;
			elseif v5 < 0 then
				local v7 = (-v3) ^ 0.5;
				local v8 = l__math_atan2__1((-v5) ^ 0.5, v4) / 3;
				local v9 = v7 * l__math_cos__2(v8);
				local v10 = v7 * l__math_sin__3(v8);
				return v2 - 2 * v9, v2 + v9 - 1.7320508075688772 * v10, v2 + v9 + 1.7320508075688772 * v10;
			elseif v6 < 0 then
				local v11 = -(-v6) ^ 0.3333333333333333;
				return v2 + v3 / v11 - v11;
			else
				local v12 = v6 ^ 0.3333333333333333;
				return v2 + v3 / v12 - v12;
			end;
		elseif p3 then
			local v13 = -p2 / (2 * p1);
			local v14 = v13 * v13 - p3 / p1;
			if v14 < 0 then
				return;
			else
				local v15 = v14 ^ 0.5;
				return v13 - v15, v13 + v15;
			end;
		elseif p2 then
			return -p2 / p1;
		else
			return;
		end;
	end;
	local v16 = -p2 / (4 * p1);
	local v17 = (8 * p1 * p3 - 3 * p2 * p2) / (8 * p1 * p1);
	local v18 = (p2 * p2 * p2 + 8 * p1 * p1 * p4 - 4 * p1 * p2 * p3) / (8 * p1 * p1 * p1);
	local v19 = (16 * p1 * p1 * p2 * p2 * p3 + 256 * p1 * p1 * p1 * p1 * p5 - 3 * p1 * p2 * p2 * p2 * p2 - 64 * p1 * p1 * p1 * p2 * p4) / (256 * p1 * p1 * p1 * p1 * p1);
	local v20, v21, v22 = u4(1, 2 * v17, v17 * v17 - 4 * v19, -v18 * v18);
	local v23 = v22 and v20;
	if v23 < 1E-10 then
		local v24, v25 = u4(1, v17, v19);
		if not v25 or v25 < 0 then
			return;
		else
			local v26 = v25 ^ 0.5;
			return v16 - v26, v16 + v26;
		end;
	end;
	local v27 = v23 ^ 0.5;
	local v28 = (v27 * v27 * v27 + v27 * v17 - v18) / (2 * v27);
	if v28 > -1E-10 and v28 < 1E-10 then
		return v16 - v27, v16;
	end;
	local v29, v30 = u4(1, v27, v28);
	local v31, v32 = u4(1, -v27, v19 / v28);
	if v29 and v31 then
		return v16 + v29, v16 + v30, v16 + v31, v16 + v32;
	end;
	if v29 then
		return v16 + v29, v16 + v30;
	end;
	if not v31 then
		return;
	end;
	return v16 + v31, v16 + v32;
end;
local l__Vector3_zero_Dot__5 = Vector3.zero.Dot;
function v1.timehit(p6, p7, p8, p9)
	local v33 = p6 - p9;
	local v34 = { u4(l__Vector3_zero_Dot__5(p8, p8), 3 * l__Vector3_zero_Dot__5(p8, p7), 2 * (l__Vector3_zero_Dot__5(p8, v33) + l__Vector3_zero_Dot__5(p7, p7)), 2 * l__Vector3_zero_Dot__5(v33, p7)) };
	local v35 = 0;
	local v36 = (1 / 0);
	for v37 = 1, #v34 do
		local v38 = v34[v37];
		local l__magnitude__39 = (v33 + v38 * p7 + v38 * v38 / 2 * p8).magnitude;
		if v35 < v38 and l__magnitude__39 < v36 then
			v35 = v38;
			v36 = l__magnitude__39;
		end;
	end;
	return v35, v36;
end;
function v1.trajectory(p10, p11, p12, p13)
	local v40 = p12 - p10;
	local v41 = -p11;
	local v42, v43, v44, v45 = u4(l__Vector3_zero_Dot__5(v41, v41) / 4, 0, l__Vector3_zero_Dot__5(v41, v40) - p13 * p13, 0, l__Vector3_zero_Dot__5(v40, v40));
	if v42 and v42 > 0 then
		return v41 * v42 / 2 + v40 / v42, v42;
	end;
	if v43 and v43 > 0 then
		return v41 * v43 / 2 + v40 / v43, v43;
	end;
	if v44 and v44 > 0 then
		return v41 * v44 / 2 + v40 / v44, v44;
	end;
	if not v45 or not (v45 > 0) then
		return;
	end;
	return v41 * v45 / 2 + v40 / v45, v45;
end;
return v1;

