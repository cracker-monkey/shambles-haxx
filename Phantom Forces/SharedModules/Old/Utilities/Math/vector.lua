
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__math_random__1 = math.random;
local l__math_acos__2 = math.acos;
local l__math_sin__3 = math.sin;
local l__math_cos__4 = math.cos;
local u5 = math.pi * 2;
local l__Vector3_new__6 = Vector3.new;
function v1.random(p1, p2)
	local v2 = nil;
	local v3 = nil;
	local v4 = l__math_acos__2(1 - 2 * l__math_random__1()) / 3;
	local v5 = 1.7320508075688772 * l__math_sin__3(v4) - l__math_cos__4(v4);
	local v6 = ((1 - v5 * v5) * l__math_random__1()) ^ 0.5;
	local v7 = u5 * l__math_random__1();
	v2 = v6 * l__math_cos__4(v7);
	v3 = v6 * l__math_sin__3(v7);
	if not p2 then
		if p1 then
			return l__Vector3_new__6(p1 * v2, p1 * v3, p1 * v5);
		else
			return l__Vector3_new__6(v2, v3, v5);
		end;
	end;
	local v8 = (p1 + (p2 - p1) * l__math_random__1()) / (v2 * v2 + v3 * v3 + v5 * v5) ^ 0.5;
	return l__Vector3_new__6(v8 * v2, v8 * v3, v8 * v5);
end;
function v1.anglesyx(p3, p4)
	local v9 = l__math_cos__4(p3);
	return l__Vector3_new__6(-v9 * l__math_sin__3(p4), l__math_sin__3(p3), -v9 * l__math_cos__4(p4));
end;
local l__math_asin__7 = math.asin;
local l__math_atan2__8 = math.atan2;
function v1.toanglesyx(p5)
	local l__x__10 = p5.x;
	local l__y__11 = p5.y;
	local l__z__12 = p5.z;
	return l__math_asin__7(l__y__11 / (l__x__10 * l__x__10 + l__y__11 * l__y__11 + l__z__12 * l__z__12) ^ 0.5), l__math_atan2__8(-l__x__10, -l__z__12);
end;
local l__math_pi__9 = math.pi;
local l__Vector3_zero__10 = Vector3.zero;
function v1.slerp(p6, p7, p8)
	local l__x__13 = p6.x;
	local l__y__14 = p6.y;
	local l__z__15 = p6.z;
	local l__x__16 = p7.x;
	local l__y__17 = p7.y;
	local l__z__18 = p7.z;
	local v19 = (l__x__13 * l__x__13 + l__y__14 * l__y__14 + l__z__15 * l__z__15) ^ 0.5;
	local v20 = (l__x__16 * l__x__16 + l__y__17 * l__y__17 + l__z__18 * l__z__18) ^ 0.5;
	local v21 = (l__x__13 * l__x__16 + l__y__14 * l__y__17 + l__z__15 * l__z__18) / (v19 * v20);
	if v21 < -0.99999 then
		local v22 = nil;
		local v23 = 0;
		local v24 = 0;
		local v25 = 0;
		local v26 = l__x__13 * l__x__13;
		local v27 = l__y__14 * l__y__14;
		v22 = l__z__15 * l__z__15;
		if v26 < v27 then
			if v26 < v22 then
				v23 = 1;
			else
				v25 = 1;
			end;
		elseif v27 < v22 then
			v24 = 1;
		else
			v25 = 1;
		end;
		local v28 = l__math_acos__2((l__x__13 * v23 + l__y__14 * v24 + l__z__15 * v25) / v19);
		local v29 = l__math_pi__9 / v28 * p8;
		local v30 = ((1 - p8) * v19 + p8 * v20) / l__math_sin__3(v28);
		local v31 = v30 / v19 * l__math_sin__3((1 - v29) * v28);
		local v32 = v30 / v20 * l__math_sin__3(v29 * v28);
		return l__Vector3_new__6(v31 * l__x__13 + v32 * v23, v31 * l__y__14 + v32 * v24, v31 * l__z__15 + v32 * v25);
	end;
	if not (v21 < 0.99999) then
		if v19 > 1E-05 or v20 > 1E-05 then
			if v19 < v20 then
				return ((1 - p8) * v19 / v20 + p8) * p7;
			else
				return (1 - p8 + p8 * v20 / v19) * p6;
			end;
		else
			return l__Vector3_zero__10;
		end;
	end;
	local v33 = l__math_acos__2(v21);
	local v34 = ((1 - p8) * v19 + p8 * v20) / (1 - v21 * v21) ^ 0.5;
	local v35 = v34 / v19 * l__math_sin__3((1 - p8) * v33);
	local v36 = v34 / v20 * l__math_sin__3(p8 * v33);
	return l__Vector3_new__6(v35 * l__x__13 + v36 * l__x__16, v35 * l__y__14 + v36 * l__y__17, v35 * l__z__15 + v36 * l__z__18);
end;
table.freeze(v1);
return v1;

