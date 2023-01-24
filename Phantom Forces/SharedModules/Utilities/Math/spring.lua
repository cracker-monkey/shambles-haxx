
-- Decompiled with the Synapse X Luau decompiler.

local l__math_sqrt__1 = math.sqrt;
local l__math_exp__2 = math.exp;
local l__math_cos__3 = math.cos;
local l__math_sin__4 = math.sin;
local u5 = {
	new = function(p1, p2, p3)
		return setmetatable({
			_d = p2 and 1, 
			_s = p3 and 1, 
			_t0 = os.clock(), 
			_p0 = p1 and 0, 
			_v0 = 0 * (p1 and 0), 
			_p1 = p1 and 0, 
			init = u5.init, 
			update = u5.update, 
			accelerate = u5.accelerate
		}, u5);
	end, 
	init = function(p4, p5, p6, p7)
		p4._t0 = os.clock();
		p4._p0 = p5 or 0 * p4._p0;
		p4._v0 = p6 or 0 * p4._v0;
		p4._p1 = p7 or (p5 or 0 * p4._p1);
	end
};
local function u6(p8, p9, p10, p11, p12, p13, p14)
	local v1 = nil;
	v1 = p9 * (p14 - p10);
	local v2 = p8 * p8;
	if v2 < 1 then
		local v3 = l__math_sqrt__1(1 - v2);
		local v4 = l__math_exp__2(-p8 * v1) / v3;
		local v5 = v4 * l__math_cos__3(v3 * v1);
		local v6 = v4 * l__math_sin__4(v3 * v1);
	elseif v2 == 1 then
		v3 = 1;
		local v7 = l__math_exp__2(-p8 * v1) / v3;
		v5 = v7;
		v6 = v7 * v1;
	else
		v3 = l__math_sqrt__1(v2 - 1);
		local v8 = l__math_exp__2((-p8 + v3) * v1) / (2 * v3);
		local v9 = l__math_exp__2((-p8 - v3) * v1) / (2 * v3);
		v5 = v8 + v9;
		v6 = v8 - v9;
	end;
	return (v3 * v5 + p8 * v6) * p11 + (1 - (v3 * v5 + p8 * v6)) * p13 + v6 / p9 * p12, -p9 * v6 * p11 + p9 * v6 * p13 + (v3 * v5 - p8 * v6) * p12;
end;
function u5.update(p15, p16, p17, p18, p19, p20)
	local v10 = os.clock();
	local v11, v12 = u6(p15._d, p15._s, p15._t0, p15._p0, p15._v0, p15._p1, v10);
	p15._t0 = v10;
	p15._p0 = p17 and v11;
	p15._v0 = p18 and v12;
	p15._p1 = p16 or p15._p1;
	p15._d = p19 or p15._d;
	p15._s = p20 or p15._s;
	return v11, v12;
end;
function u5.accelerate(p21, p22)
	local v13 = os.clock();
	local v14, v15 = u6(p21._d, p21._s, p21._t0, p21._p0, p21._v0, p21._p1, v13);
	p21._t0 = v13;
	p21._p0 = v14;
	p21._v0 = v15 + p22;
end;
function u5.__index(p23, p24)
	local v16 = nil;
	v16 = os.clock();
	if p24 == "p" then
		local v17, v18 = u6(p23._d, p23._s, p23._t0, p23._p0, p23._v0, p23._p1, v16);
		return v17;
	end;
	if p24 == "v" then
		local v19, v20 = u6(p23._d, p23._s, p23._t0, p23._p0, p23._v0, p23._p1, v16);
		return v20;
	end;
	if p24 == "t" then
		return p23._p1;
	end;
	if p24 == "d" then
		return p23._d;
	end;
	if p24 == "s" then
		return p23._s;
	end;
	if p24 ~= "a" then
		return;
	end;
	local v21, v22 = u6(p23._d, p23._s, p23._t0, p23._p0, p23._v0, p23._p1, v16);
	return p23._s * p23._s * (p23._p1 - v21) - 2 * p23._s * p23._d * v22;
end;
function u5.__newindex(p25, p26, p27)
	if p27 ~= p27 then
		return;
	end;
	local v23 = os.clock();
	local v24, v25 = u6(p25._d, p25._s, p25._t0, p25._p0, p25._v0, p25._p1, v23);
	p25._p0 = v24;
	p25._v0 = v25;
	p25._t0 = v23;
	if p26 == "p" then
		p25._p0 = p27;
		return;
	end;
	if p26 == "v" then
		p25._v0 = p27;
		return;
	end;
	if p26 == "t" then
		p25._p1 = p27;
		return;
	end;
	if p26 == "d" then
		p25._d = p27;
		return;
	end;
	if p26 == "s" then
		p25._s = p27;
		return;
	end;
	if p26 == "a" then
		p25._v0 = p25._v0 + p27;
	end;
end;
return u5;

