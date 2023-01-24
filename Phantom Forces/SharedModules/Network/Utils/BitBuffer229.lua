
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = {};
local v3 = {};
v2.__index = v2;
v3.__index = v3;
local v4 = {};
for v5 = 0, 100 do
	v4[v5] = 2 ^ v5;
end;
local l__string_char__1 = string.char;
local l__string_byte__2 = string.byte;
function v1.newWriter()
	return setmetatable({
		_ndat = 0, 
		_dat = {}, 
		_ncache = 0, 
		_cache = 0
	}, v2);
end;
function v2.write(p1, p2, p3)
	while p1._ncache + p2 >= 47 do
		local v6 = 47 - p1._ncache;
		local v7 = v4[v6];
		local v8 = p3 % v7;
		p1._ndat = p1._ndat + 1;
		local v9 = p1._cache + v8 * v4[p1._ncache];
		local v10 = v9 % 229;
		local v11 = (v9 - v10) / 229;
		local v12 = v11 % 229;
		local v13 = (v11 - v12) / 229;
		local v14 = v13 % 229;
		local v15 = (v13 - v14) / 229;
		local v16 = v15 % 229;
		local v17 = (v15 - v16) / 229;
		local v18 = v17 % 229;
		p1._dat[p1._ndat] = l__string_char__1(v10 + 1, v12 + 1, v14 + 1, v16 + 1, v18 + 1, (v17 - v18) / 229 % 229 + 1);
		p1._ncache = 0;
		p1._cache = 0;
		p2 = p2 - v6;
		p3 = (p3 - v8) / v7;	
	end;
	p1._cache = p1._cache + p3 * v4[p1._ncache];
	p1._ncache = p1._ncache + p2;
end;
function v2.reset(p4)
	p4._ndat = 0;
	p4._dat = {};
	p4._ncache = 0;
	p4._cache = 0;
end;
local l__table_concat__3 = table.concat;
function v2.finalize(p5)
	if p5._ncache > 0 then
		local l___cache__19 = p5._cache;
		local v20 = l___cache__19 % 229;
		local v21 = (l___cache__19 - v20) / 229;
		local v22 = v21 % 229;
		local v23 = (v21 - v22) / 229;
		local v24 = v23 % 229;
		local v25 = (v23 - v24) / 229;
		local v26 = v25 % 229;
		local v27 = (v25 - v26) / 229;
		local v28 = v27 % 229;
		p5._dat[p5._ndat + 1] = l__string_char__1(v20 + 1, v22 + 1, v24 + 1, v26 + 1, v28 + 1, (v27 - v28) / 229 % 229 + 1);
		p5._ncache = 0;
		p5._cache = 0;
	end;
	return l__table_concat__3(p5._dat);
end;
function v1.newReader(p6)
	debug.profilebegin("create reader");
	local v29 = setmetatable({
		_ndat = 0, 
		_dat = p6, 
		_ncache = 0, 
		_cache = 0, 
		_currentbit = 0
	}, v3);
	debug.profileend();
	return v29;
end;
function v3.load(p7, p8)
	p7._ndat = 0;
	p7._dat = p8;
	p7._ncache = 0;
	p7._cache = 0;
	p7._currentbit = 0;
end;
function v3.read(p9, p10)
	p9._currentbit = p9._currentbit + p10;
	local v30 = 0;
	local v31 = 0;
	while p9._ncache + v30 < p10 do
		v31 = v31 + p9._cache * v4[v30];
		v30 = v30 + p9._ncache;
		p9._ndat = p9._ndat + 1;
		local l___ndat__32 = p9._ndat;
		local v33, v34, v35, v36, v37, v38 = l__string_byte__2(p9._dat, 6 * l___ndat__32 - 5, 6 * l___ndat__32);
		p9._cache = 1 * (v33 - 1) + 229 * (v34 - 1) + 52441 * (v35 - 1) + 12008989 * (v36 - 1) + 2750058481 * (v37 - 1) + 629763392149 * (v38 - 1);
		p9._ncache = 47;	
	end;
	local v39 = p10 - v30;
	local v40 = v4[v39];
	local v41 = p9._cache % v40;
	p9._ncache = p9._ncache - v39;
	p9._cache = (p9._cache - v41) / v40;
	return v31 + v41 * v4[v30];
end;
function v3.stats(p11)
	return p11._currentbit;
end;
return v1;

