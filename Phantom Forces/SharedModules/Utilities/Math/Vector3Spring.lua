
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {
	type = script.Name
};
local l__math_cos__1 = math.cos;
local l__math_sin__2 = math.sin;
local u3 = shared.require("GameClock");
local function u4(p1, p2, p3, p4, p5, p6, p7)
	local v2 = nil;
	v2 = p2 * (p7 - p6);
	local v3 = p1 * p1;
	if v3 < 1 then
		local v4 = (1 - v3) ^ 0.5;
		local v5 = 2.718281828459045 ^ (-p1 * v2) / v4;
		local v6 = v5 * l__math_cos__1(v4 * v2);
		local v7 = v5 * l__math_sin__2(v4 * v2);
	elseif v3 == 1 then
		v4 = 1;
		local v8 = 2.718281828459045 ^ (-p1 * v2) / v4;
		v6 = v8;
		v7 = v8 * v2;
	else
		v4 = (v3 - 1) ^ 0.5;
		local v9 = 2.718281828459045 ^ ((-p1 + v4) * v2) / (2 * v4);
		local v10 = 2.718281828459045 ^ ((-p1 - v4) * v2) / (2 * v4);
		v6 = v9 + v10;
		v7 = v9 - v10;
	end;
	return (v4 * v6 + p1 * v7) * p3 + (1 - (v4 * v6 + p1 * v7)) * p4 + v7 / p2 * p5, -p2 * v7 * p3 + p2 * v7 * p4 + (v4 * v6 - p1 * v7) * p5;
end;
local l__setmetatable__5 = setmetatable;
function v1.new(p8, p9, p10)
	local v11 = Vector3.new(0, 0, 0);
	local v12 = Vector3.new(1, 1, 1);
	local v13 = {};
	local v14 = {};
	local u6 = u3.getTime();
	local u7 = p8.x;
	local u8 = p8.y;
	local u9 = p8.z;
	local u10 = v11.x;
	local u11 = v11.y;
	local u12 = v11.z;
	local u13 = p8.x;
	local u14 = p8.y;
	local u15 = p8.z;
	function v13.init(p11, p12, p13)
		u6 = u3.getTime();
		p11 = p11 or v11;
		p12 = p12 or v11;
		p13 = p13 or (p11 or v11);
		u7 = p11.x;
		u8 = p11.y;
		u9 = p11.z;
		u10 = p12.x;
		u11 = p12.y;
		u12 = p12.z;
		u13 = p13.x;
		u14 = p13.y;
		u15 = p13.z;
	end;
	local u16 = p9 and p9.x or 1;
	local u17 = p10 and p10.x or 1;
	local u18 = p9 and p9.y or 1;
	local u19 = p10 and p10.y or 1;
	local u20 = p9 and p9.z or 1;
	local u21 = p10 and p10.z or 1;
	function v14.__index(p14, p15)
		local v15 = nil;
		v15 = u3.getTime();
		if p15 == "p" then
			local v16, v17 = u4(u16, u17, u7, u13, u10, u6, v15);
			local v18, v19 = u4(u18, u19, u8, u14, u11, u6, v15);
			local v20, v21 = u4(u20, u21, u9, u15, u12, u6, v15);
			return Vector3.new(v16, v18, v20);
		end;
		if p15 == "v" then
			local v22, v23 = u4(u16, u17, u7, u13, u10, u6, v15);
			local v24, v25 = u4(u18, u19, u8, u14, u11, u6, v15);
			local v26, v27 = u4(u20, u21, u9, u15, u12, u6, v15);
			return Vector3.new(v23, v25, v27);
		end;
		if p15 == "t" then
			return Vector3.new(u13, u14, u15);
		end;
		if p15 == "d" then
			return Vector3.new(u16, u18, u20);
		end;
		if p15 == "s" then
			return Vector3.new(u17, u19, u21);
		end;
		if p15 ~= "a" then
			return;
		end;
		local v28, v29 = u4(u16, u17, u7, u13, u10, u6, v15);
		local v30, v31 = u4(u18, u19, u8, u14, u11, u6, v15);
		local v32, v33 = u4(u20, u21, u9, u15, u12, u6, v15);
		return Vector3.new(u17 * u17 * (u13 - v28) - 2 * u17 * u16 * v29, u19 * u19 * (u14 - v30) - 2 * u19 * u18 * v31, u21 * u21 * (u15 - v32) - 2 * u21 * u20 * v33);
	end;
	function v14.__newindex(p16, p17, p18)
		local v34 = u3.getTime();
		local v35, v36 = u4(u16, u17, u7, u13, u10, u6, v34);
		u7 = v35;
		u10 = v36;
		local v37, v38 = u4(u18, u19, u8, u14, u11, u6, v34);
		u8 = v37;
		u11 = v38;
		local v39, v40 = u4(u20, u21, u9, u15, u12, u6, v34);
		u9 = v39;
		u12 = v40;
		u6 = v34;
		if p17 == "p" then
			local v41 = p18 or v11;
			u7 = v41.x;
			u8 = v41.y;
			u9 = v41.z;
			return;
		end;
		if p17 == "v" then
			local v42 = p18 or v11;
			u10 = v42.x;
			u11 = v42.y;
			u12 = v42.z;
			return;
		end;
		if p17 == "t" then
			local v43 = p18 or v11;
			u13 = v43.x;
			u14 = v43.y;
			u15 = v43.z;
			return;
		end;
		if p17 == "d" then
			local v44 = p18 and 1;
			u16 = v44.x;
			u18 = v44.y;
			u20 = v44.z;
			return;
		end;
		if p17 == "s" then
			local v45 = p18 and 1;
			u17 = v45.x;
			u19 = v45.y;
			u21 = v45.z;
		end;
	end;
	v13.init();
	return l__setmetatable__5(v13, v14);
end;
return v1;

