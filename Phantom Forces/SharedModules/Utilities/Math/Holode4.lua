
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	v2._r = p2;
	v2._t0 = 0;
	v2._p0 = p1;
	v2._v0 = 0 * p1;
	v2._a0 = 0 * p1;
	v2._j0 = 0 * p1;
	v2._p1 = p1;
	return v2;
end;
function v1.update(p3, p4, p5, p6, p7, p8, p9, p10)
	local v3 = p3._t0 + p4;
	local v4, v5, v6, v7 = p3:_compute(v3);
	p3._t0 = v3;
	p3._p0 = p6 and v4;
	p3._v0 = p7 and v5;
	p3._a0 = p8 and v6;
	p3._j0 = p9 and v7;
	p3._p1 = p5 or p3._p1;
	p3._r = p10 or p3._r;
	return v4, v5, v6, v7;
end;
function v1.get(p11)
	return p11:_compute(p11._t0);
end;
function v1._compute(p12, p13)
	local v8 = p13 - p12._t0;
	local v9 = v8 * v8;
	local v10 = v8 * v8 * v8;
	local l___r__11 = p12._r;
	local v12 = l___r__11 * l___r__11;
	local v13 = l___r__11 * l___r__11 * l___r__11;
	local v14 = l___r__11 * l___r__11 * l___r__11 * l___r__11;
	local v15 = math.exp(-l___r__11 * v8);
	return (1 - v15 / 6 * (6 + 6 * l___r__11 * v8 + 3 * v12 * v9 + v13 * v10)) * p12._p1 + v15 / 6 * (6 + 6 * l___r__11 * v8 + 3 * v12 * v9 + v13 * v10) * p12._p0 + v15 / 2 * v8 * (2 + 2 * l___r__11 * v8 + v12 * v9) * p12._v0 + v15 / 2 * v9 * (1 + l___r__11 * v8) * p12._a0 + v15 / 6 * v10 * p12._j0, v15 / 6 * v14 * v10 * p12._p1 - v15 / 6 * v14 * v10 * p12._p0 + v15 / 2 * (2 + 2 * l___r__11 * v8 + v12 * v9 - v13 * v10) * p12._v0 - v15 / 2 * v8 * (-2 - 2 * l___r__11 * v8 + v12 * v9) * p12._a0 - v15 / 6 * v9 * (-3 + l___r__11 * v8) * p12._j0, v15 / 6 * v14 * v9 * (-3 + l___r__11 * v8) * p12._p0 - v15 / 6 * v14 * v9 * (-3 + l___r__11 * v8) * p12._p1 + v15 / 2 * v13 * v9 * (-4 + l___r__11 * v8) * p12._v0 + v15 / 2 * (2 + 2 * l___r__11 * v8 - 5 * v12 * v9 + v13 * v10) * p12._a0 + v15 / 6 * v8 * (6 - 6 * l___r__11 * v8 + v12 * v9) * p12._j0, v15 / 6 * v14 * v8 * (6 - 6 * l___r__11 * v8 + v12 * v9) * p12._p1 - v15 / 6 * v14 * v8 * (6 - 6 * l___r__11 * v8 + v12 * v9) * p12._p0 - v15 / 2 * v13 * v8 * (8 - 7 * l___r__11 * v8 + v12 * v9) * p12._v0 - v15 / 2 * v12 * v8 * (12 - 8 * l___r__11 * v8 + v12 * v9) * p12._a0 - v15 / 6 * (-6 + 18 * l___r__11 * v8 - 9 * v12 * v9 + v13 * v10) * p12._j0;
end;
return v1;

