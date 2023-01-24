
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = {};
local v3 = {};
v2.__index = v2;
v3.__index = v3;
local v4 = {};
local v5 = {};
for v6 = 1, 64 do
	local v7 = string.byte("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+-", v6);
	v4[v6 - 1] = v7;
	v5[v7] = v6 - 1;
end;
local v8 = { 1, 2 };
while true do
	local v9 = #v8;
	v8[v9 + 1] = v8[v9] + v8[v9 - 1];
	if v8[v9 + 1] >= 9007199254740992 then
		break;
	end;
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
local function u3(p1)
	local v10 = p1 % 64;
	p1 = (p1 - v10) / 64;
	local v11 = p1 % 64;
	p1 = (p1 - v11) / 64;
	local v12 = p1 % 64;
	p1 = (p1 - v12) / 64;
	local v13 = p1 % 64;
	p1 = (p1 - v13) / 64;
	local v14 = p1 % 64;
	p1 = (p1 - v14) / 64;
	local v15 = p1 % 64;
	p1 = (p1 - v15) / 64;
	local v16 = p1 % 64;
	p1 = (p1 - v16) / 64;
	local v17 = p1 % 64;
	p1 = (p1 - v17) / 64;
	return l__string_char__1(v4[v10], v4[v11], v4[v12], v4[v13], v4[v14], v4[v15], v4[v16], v4[v17]);
end;
function v2.write(p2, p3, p4)
	while p2._ncache + p3 >= 48 do
		local v18 = 48 - p2._ncache;
		local v19 = 2 ^ v18;
		local v20 = p4 % v19;
		p2._ndat = p2._ndat + 1;
		p2._dat[p2._ndat] = u3(p2._cache + v20 * 2 ^ p2._ncache);
		p2._ncache = 0;
		p2._cache = 0;
		p3 = p3 - v18;
		p4 = (p4 - v20) / v19;	
	end;
	p2._cache = p2._cache + p4 * 2 ^ p2._ncache;
	p2._ncache = p2._ncache + p3;
end;
function v2.finalize(p5)
	if p5._ncache > 0 then
		p5._dat[p5._ndat + 1] = u3(p5._cache);
		p5._ncache = 0;
		p5._cache = 0;
	end;
	return table.concat(p5._dat);
end;
function v2.writeFib(p6, p7)
	local v21 = nil;
	local v22 = nil;
	p7 = p7 + 1;
	if p7 > 9007199254740992 then
		error("data too large for fib encode");
	end;
	local v23 = 0;
	while v8[v23 + 1] <= p7 do
		v23 = v23 + 1;	
	end;
	local v24 = nil;
	v22 = 1;
	local v25 = 1;
	for v26 = v23, 1, -1 do
		v21 = v25 + 1;
		if v8[v26] <= p7 then
			p7 = p7 - v8[v26];
			local v27 = 2 * v22 + 1;
		else
			v27 = 2 * v22;
		end;
		if v21 == 53 then
			v24 = v27;
			v27 = 0;
			v21 = 0;
		end;
	end;
	p6:write(v21, v27);
	if v24 then
		p6:write(53, v24);
	end;
end;
local u4 = tostring((0 / 0));
function v2.writeFloat(p8, p9)
	if p9 ~= p9 then
		if tostring(p9) == u4 then
			p8:write(23, 1);
		else
			p8:write(23, 2);
		end;
		p8:write(8, 255);
		p8:write(1, 0);
		return;
	end;
	local v28 = math.abs(p9);
	if v28 == (1 / 0) then
		p8:write(23, 0);
		p8:write(8, 255);
	elseif v28 < 1.1754943508222875E-38 then
		p8:write(23, v28 * 8.507059173023462E+37 * 8388608);
		p8:write(8, 0);
	else
		local v29, v30 = math.frexp(v28);
		p8:write(23, 8388608 * (2 * v29 - 1));
		p8:write(8, v30 + 126);
	end;
	if p9 < 0 then
		p8:write(1, 1);
		return;
	end;
	p8:write(1, 0);
end;
function v2.writeString64(p10, p11)
	p10:writeFib(#p11);
	for v31 = 1, #p11 do
		p10:write(6, v5[string.byte(p11, v31)]);
	end;
end;
function v1.newReader(p12)
	return setmetatable({
		_ndat = 0, 
		_dat = p12, 
		_ncache = 0, 
		_cache = 0
	}, v3);
end;
local function u5(p13, p14)
	local v32, v33, v34, v35, v36, v37, v38, v39 = l__string_byte__2(p13, 8 * p14 - 7, 8 * p14);
	return v5[v32] * 1 + v5[v33] * 64 + v5[v34] * 4096 + v5[v35] * 262144 + v5[v36] * 16777216 + v5[v37] * 1073741824 + v5[v38] * 68719476736 + v5[v39] * 4398046511104;
end;
function v3.read(p15, p16)
	local v40 = 0;
	local v41 = 0;
	while p15._ncache + v40 < p16 do
		v41 = v41 + p15._cache * 2 ^ v40;
		v40 = v40 + p15._ncache;
		p15._ndat = p15._ndat + 1;
		p15._cache = u5(p15._dat, p15._ndat);
		p15._ncache = 48;	
	end;
	local v42 = p16 - v40;
	local v43 = 2 ^ v42;
	local v44 = p15._cache % v43;
	p15._ncache = p15._ncache - v42;
	p15._cache = (p15._cache - v44) / v43;
	return v41 + v44 * 2 ^ v40;
end;
function v3.readFib(p17)
	local v45 = 0;
	local v46 = 0;
	for v47 = 1, #v8 do
		local v48 = p17:read(1);
		if v48 == 1 then
			if v46 == 1 then
				break;
			end;
			v45 = v45 + v8[v47];
		end;
		v46 = v48;
	end;
	return v45 - 1;
end;
function v3.readFloat(p18)
	local v49 = p18:read(23);
	local v50 = p18:read(8);
	if p18:read(1) == 0 then
		local v51 = 1;
	else
		v51 = -1;
	end;
	if v50 == 255 then
		if v49 == 0 then
			return v51 / 0;
		elseif v49 == 1 then
			return (0 / 0);
		else
			return (0 / 0);
		end;
	end;
	if v50 == 0 then
		return v51 * v49 * 1.401298464324817E-45;
	end;
	return v51 * (v49 / 8388608 + 1) * 2 ^ (v50 - 127);
end;
function v3.readString64(p19)
	local v52 = {};
	for v53 = 1, p19:readFib() do
		v52[v53] = string.char(v4[p19:read(6)]);
	end;
	return table.concat(v52);
end;
return v1;

