
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local function u1(p1, p2)
	if type(p1) ~= "table" or type(p2) ~= "table" then
		return p2;
	end;
	local v2 = {};
	for v3, v4 in p1, nil do
		v2[v3] = v4;
	end;
	for v5, v6 in p2, nil do
		v2[v5] = u1(p1[v5], v6);
	end;
	return v2;
end;
local u2 = shared.require("LuaUtils");
function v1.new(p3, p4)
	local v7 = {};
	local v8 = nil;
	local v9 = nil;
	while true do
		local v10, v11 = p3(v8, v9);
		if not v10 then
			break;
		end;
		local v12 = v11[2];
		local v13 = v11[3];
		local v14 = u1(u2.deepCopy(v7), u2.deepCopy(v11[1]));
		if v12 then
			for v15 = 1, #v12 do
				local v16 = v12[v15];
				v1[v16[1]](v14, unpack(v16, 2, #v16));
			end;
		end;
		if v13 then
			for v17 = 1, #v13 do
				local v18 = v13[v17];
				v1[v18[1]](p4, v7, unpack(v18, 2, #v18));
			end;
		end;	
	end;
	return setmetatable(v7, v1);
end;
function v1.modify(p5, p6, p7, p8)
	if p8 == "remove" then
		p5[p6][p7] = nil;
		return;
	end;
	if not p5[p6][p7] then
		p5[p6][p7] = {};
	end;
	if p8 then
		for v19, v20 in p8, nil do
			p5[p6][p7][v19] = v20;
		end;
	end;
end;
function v1.modifyall(p9, p10, p11)
	for v21, v22 in p9[p10], nil do
		if p11 == "remove" then
			p9[p10][v21] = nil;
		else
			if not v22 then
				v22 = {};
			end;
			for v23, v24 in p11, nil do
				v22[v23] = v24;
			end;
		end;
	end;
end;
function v1.modifyallexcept(p12, p13, p14, p15)
	local v25 = {};
	for v26, v27 in p14, nil do
		v25[v27] = true;
	end;
	for v28, v29 in p12[p13], nil do
		if not v25[v28] then
			if not v29 then
				v29 = {};
			end;
			for v30, v31 in p15, nil do
				v29[v30] = v31;
			end;
		end;
	end;
end;
function v1.modifyset(p16, p17, p18, p19)
	local v32 = {};
	for v33, v34 in p18, nil do
		v32[v34] = true;
	end;
	for v35, v36 in p16[p17], nil do
		if v32[v35] then
			if p19 == "remove" then
				p16[p17][v35] = nil;
			else
				if not v36 then
					v36 = {};
				end;
				for v37, v38 in p19, nil do
					v36[v37] = v38;
				end;
			end;
		end;
	end;
end;
function v1.modifylist(p20, p21, p22)
	local v39 = nil;
	local v40 = nil;
	while true do
		local v41, v42 = p22(v39, v40);
		if not v41 then
			break;
		end;
		local v43 = p20[p21][v41];
		if not v43 then
			v43 = {};
			p20[p21][v41] = v43;
		end;
		for v44, v45 in v42, nil do
			v43[v44] = v45;
		end;	
	end;
end;
function v1.mult(p23, p24, p25, p26, p27)
	if p27 == "remove" then
		p24[p25][p26] = nil;
		return;
	end;
	if not p24[p25][p26] then
		p24[p25][p26] = {};
	end;
	for v46, v47 in p27, nil do
		p24[p25][p26][v46] = p23[v46] * v47;
	end;
end;
function v1.multall(p28, p29, p30, p31)
	local v48 = p29[p30];
	local v49 = nil;
	local v50 = nil;
	while true do
		local v51, v52 = v48(v49, v50);
		if not v51 then
			break;
		end;
		if not v52 then
			v52 = {};
		end;
		for v53, v54 in p31, nil do
			v52[v53] = p28[v53] * v54;
		end;	
	end;
end;
function v1.multallexcept(p32, p33, p34, p35, p36)
	local v55 = {};
	for v56, v57 in p35, nil do
		v55[v57] = true;
	end;
	for v58, v59 in p33[p34], nil do
		if not v55[v58] then
			if not v59 then
				v59 = {};
			end;
			for v60, v61 in p36, nil do
				v59[v60] = p32[v60] * v61;
			end;
		end;
	end;
end;
function v1.multset(p37, p38, p39, p40, p41)
	local v62 = {};
	for v63, v64 in p40, nil do
		v62[v64] = true;
	end;
	for v65, v66 in p38[p39], nil do
		if v62[v65] then
			if not v66 then
				v66 = {};
			end;
			for v67, v68 in p41, nil do
				v66[v67] = p37[v67] * v68;
			end;
		end;
	end;
end;
return v1;

