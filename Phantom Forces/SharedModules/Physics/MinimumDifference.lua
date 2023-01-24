
-- Decompiled with the Synapse X Luau decompiler.

local function u1(p1)
	local l__x__1 = p1.x;
	local l__y__2 = p1.y;
	local l__z__3 = p1.z;
	local v4 = math.min(l__x__1 * l__x__1, l__y__2 * l__y__2, l__z__3 * l__z__3);
	if l__x__1 * l__x__1 == v4 then
		return Vector3.new(l__y__2 * l__y__2 + l__z__3 * l__z__3, -l__x__1 * l__y__2, -l__x__1 * l__z__3);
	end;
	if l__y__2 * l__y__2 == v4 then
		return Vector3.new(-l__x__1 * l__y__2, l__x__1 * l__x__1 + l__z__3 * l__z__3, -l__y__2 * l__z__3);
	end;
	return Vector3.new(-l__x__1 * l__z__3, -l__y__2 * l__z__3, l__x__1 * l__x__1 + l__y__2 * l__y__2);
end;
local function u2(p2, p3, p4, p5)
	local v5 = -p2;
	local v6 = p3 - p2;
	local v7 = p4 - p2;
	local v8 = p5 - p2;
	local v9 = v6:Cross(v7);
	local v10 = v7:Cross(v8);
	local v11 = v8:Cross(v6);
	local v12 = v9:Dot(v8);
	local v13 = v10:Dot(v5);
	local v14 = v11:Dot(v5);
	local v15 = v9:Dot(v5);
	if v13 / v12 >= 0 and v14 / v12 >= 0 and v15 / v12 >= 0 then
		return Vector3.new(0, 0, 0), p2, p3, p4, p5;
	end;
	if v12 < 0 then
		local v16 = -1;
	elseif v12 > 0 then
		v16 = 1;
	else
		v16 = 0;
	end;
	local v17 = v13 * v16 / v10.magnitude;
	local v18 = v14 * v16 / v11.magnitude;
	local v19 = math.min(v15 * v16 / v9.magnitude, v17, v18);
	if v17 == v19 then
		v6 = v7;
		v7 = v8;
		p3 = p4;
		p4 = p5;
		v9 = v10;
	elseif v18 == v19 then
		v7 = v6;
		v6 = v8;
		p4 = p3;
		p3 = p5;
		v9 = v11;
	end;
	local v20 = v6:Cross(v5);
	local v21 = v5:Cross(v7);
	local v22 = v9:Dot(v20);
	local v23 = v9:Dot(v21);
	if v22 >= 0 and v23 >= 0 then
		return v12 < 0 and v9 or -v9, p2, p3, p4;
	end;
	local v24 = v7:Dot(v7);
	local v25 = v22 / (v6:Dot(v6) * v7.magnitude);
	local v26 = v23 / (v24 * v6.magnitude);
	if v26 == math.min(v25, v26) then
		v6 = v7;
		p3 = p4;
		v20 = -v21;
		v9 = -v9;
	end;
	if not (v5:Dot(v6) >= 0) then
		local v27 = v5;
		if v27.magnitude == 0 then
			v27 = v12 < 0 and v9 or -v9;
		end;
		return v27, p2;
	end;
	local v28 = v20:Cross(v6);
	if v28.magnitude == 0 then
		v28 = v12 < 0 and v9 or -v9;
	end;
	return v28, p2, p3;
end;
local function u3(p6, p7, p8)
	local v29 = -p6;
	local v30 = p7 - p6;
	local v31 = p8 - p6;
	local v32 = v30:Cross(v31);
	local v33 = v30:Cross(v29);
	local v34 = v29:Cross(v31);
	local v35 = v32:Dot(v33);
	local v36 = v32:Dot(v34);
	if v35 >= 0 and v36 >= 0 then
		return v32:Dot(v29) < 0 and -v32 or v32, p6, p7, p8;
	end;
	local v37 = v31:Dot(v31);
	local v38 = v35 / (v30:Dot(v30) * v31.magnitude);
	local v39 = v36 / (v37 * v30.magnitude);
	if v39 == math.min(v38, v39) then
		v30 = v31;
		p7 = p8;
		v33 = -v34;
		v32 = -v32;
	end;
	if not (v29:Dot(v30) >= 0) then
		local v40 = v29;
		if v40.magnitude == 0 then
			v40 = v32;
		end;
		return v40, p6;
	end;
	local v41 = v33:Cross(v30);
	if v41.magnitude == 0 then
		v41 = v32;
	end;
	return v41, p6, p7;
end;
local function u4(p9, p10)
	local v42 = -p9;
	local v43 = p10 - p9;
	if not (v42:Dot(v43) >= 0) then
		local v44 = v42;
		if v44.magnitude == 0 then
			v44 = u1(v43);
		end;
		return v44, p9;
	end;
	local v45 = v43:Cross(v42):Cross(v43);
	if v45.magnitude == 0 then
		v45 = u1(v43);
	end;
	return v45, p9, p10;
end;
local function u5(p11)
	local v46 = -p11;
	if v46.magnitude == 0 then
		v46 = Vector3.new(1, 0, 0);
	end;
	return v46, p11;
end;
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = {};
local function u10(p12, p13, p14)
	local v47 = u6[p12];
	local l__unit__48 = (u6[p13] - v47):Cross(u6[p14] - v47).unit;
	local v49 = l__unit__48:Dot(v47);
	u7[p13 + (p13 + p14) * (p13 + p14 + 1) / 2] = p12;
	u7[p14 + (p14 + p12) * (p14 + p12 + 1) / 2] = p13;
	u7[p12 + (p12 + p13) * (p12 + p13 + 1) / 2] = p14;
	local v50 = p12;
	local v51 = p13;
	local v52 = p14;
	if v50 < v51 then
		if not (v50 < v52) then
			v52 = v51;
			v50 = v52;
			v51 = v50;
		end;
	elseif v51 < v52 then
		v51 = v52;
		v52 = v50;
		v50 = v51;
	else
		v52 = v51;
		v50 = v52;
		v51 = v50;
	end;
	local v53 = v50 + 65536 * v51 + 4294967296 * v52;
	u8[v53] = l__unit__48;
	u9[v53] = v49;
end;
local function u11(p15, p16, p17)
	local v54 = u7[p15 + (p15 + p16) * (p15 + p16 + 1) / 2];
	if not v54 then
		return;
	end;
	local v55 = p15;
	local v56 = p16;
	local v57 = v54;
	if v55 < v56 then
		if not (v55 < v57) then
			v57 = v56;
			v55 = v57;
			v56 = v55;
		end;
	elseif v56 < v57 then
		v56 = v57;
		v57 = v55;
		v55 = v56;
	else
		v57 = v56;
		v55 = v57;
		v56 = v55;
	end;
	local v58 = v55 + 65536 * v56 + 4294967296 * v57;
	if not (u8[v58]:Dot(u6[p17]) - u9[v58] > 0) then
		if not u7[p16 + (p16 + p15) * (p16 + p15 + 1) / 2] then
			u10(p16, p15, p17);
			return;
		else
			return;
		end;
	end;
	u7[p16 + (p16 + v54) * (p16 + v54 + 1) / 2] = nil;
	u7[v54 + (v54 + p15) * (v54 + p15 + 1) / 2] = nil;
	u7[p15 + (p15 + p16) * (p15 + p16 + 1) / 2] = nil;
	local v59 = p15;
	local v60 = p16;
	local v61 = v54;
	if v59 < v60 then
		if not (v59 < v61) then
			v61 = v60;
			v59 = v61;
			v60 = v59;
		end;
	elseif v60 < v61 then
		v60 = v61;
		v61 = v59;
		v59 = v60;
	else
		v61 = v60;
		v59 = v61;
		v60 = v59;
	end;
	local v62 = v59 + 65536 * v60 + 4294967296 * v61;
	u8[v62] = nil;
	u9[v62] = nil;
	u11(p16, p15, p17);
	u11(p15, v54, p17);
	u11(v54, p16, p17);
end;
local function u12(p18, p19, p20, p21)
	if p21 then
		return u2(p18, p19, p20, p21);
	end;
	if p20 then
		return u3(p18, p19, p20);
	end;
	if p19 then
		return u4(p18, p19);
	end;
	if not p18 then
		error("can a simplex have 0 points?");
		return;
	end;
	return u5(p18);
end;
local function u13(p22, p23, p24, p25, p26, p27, p28)
	table.clear(u6);
	table.clear(u8);
	table.clear(u9);
	table.clear(u7);
	if (p24 - p27):Cross(p25 - p27):Dot(p26 - p27) < 0 then
		p25 = p26;
		p26 = p27;
		p27 = p24;
		p24 = p25;
	end;
	u6[1] = p24;
	u6[2] = p25;
	u6[3] = p26;
	u6[4] = p27;
	u10(1, 2, 3);
	u10(4, 3, 2);
	u10(4, 2, 1);
	u10(4, 1, 3);
	for v63 = 1, 100 do
		local v64 = (1 / 0);
		local v65 = nil;
		for v66, v67 in u9, nil do
			if v67 < v64 then
				v64 = v67;
				v65 = v66;
			end;
		end;
		local v68 = u8[v65];
		local v69 = u9[v65];
		if not v68 then
			print(v68, v69, v65);
		end;
		local v70 = p23(v68) - p22(-v68);
		if v68:Dot(v70) - v69 < p28 then
			return v68, v69;
		end;
		table.insert(u6, v70);
		local v71 = v65 % 65536;
		u11(v71, (v65 - v71) / 65536 % 65536, #u6);
	end;
	return nil;
end;
local function u14(p29, p30, p31, p32)
	if not p32 then
		return (p29 + p30 + p31) / 3;
	end;
	local v72 = p29:Dot(p32);
	local v73 = p30:Dot(p32);
	local v74 = math.max(v72, v73, (p31:Dot(p32)));
	if v74 == v72 then
		return p29;
	end;
	if v74 == v73 then
		return p30;
	end;
	return p31;
end;
local function u15(p33, p34, p35)
	local v75 = nil;
	local v76 = nil;
	local v77 = p34() - p33();
	local v78 = p34(-v77) - p33(v77);
	local v79 = nil;
	local v80 = nil;
	local v81 = nil;
	p35 = p35 and (1 / 0);
	local v82 = 1 - 1;
	while true do
		local v83, v84, v85, v86, v87 = u12(v78, v79, v80, v81);
		v75 = v83;
		v76 = v84;
		local v88 = p34(v75) - p33(-v75);
		if v76 and v85 and v86 and v87 then
			local v89, v90 = u13(p33, p34, v76, v85, v86, v87, 1E-05);
			if v89 and v90 then
				return -v89, -v90;
			else
				return nil, nil;
			end;
		end;
		if p35 * v75.magnitude < -v75:Dot(v88) then
			return nil, nil;
		end;
		if v75:Dot(v88 - v76) <= 0 then
			break;
		end;
		local v91 = v76 and v76 - v88;
		local v92 = v85 and v85 - v88;
		local v93 = v86 and v86 - v88;
		if v93 then
			local v94 = math.abs(v91:Cross(v92):Dot(v93));
		elseif v92 then
			v94 = v91:Cross(v92).magnitude;
		elseif v91 then
			v94 = v91.magnitude;
		else
			v94 = 1;
		end;
		if v94 < 1E-06 then
			break;
		end;
		if 0 <= 1 then
			if not (v82 < 100) then
				return nil, nil;
			end;
		elseif not (v82 > 100) then
			return nil, nil;
		end;
		v82 = v82 + 1;	
	end;
	local l__unit__95 = v75.unit;
	local v96 = v76:Dot(l__unit__95);
	if not (-v96 <= p35) then
		return nil, nil;
	end;
	return -l__unit__95, -v96;
end;
local v97 = {};
local function u16(p36, p37, p38)
	debug.profilebegin("md");
	local v98, v99 = u15(p36, p37, p38);
	debug.profileend();
	return v98, v99;
end;
function v97.point(p39, p40, p41)
	return u16(function()
		return p39;
	end, p40, p41);
end;
v97.mesh = u16;
function v97.boxTriIntersection(p42, p43, p44, p45, p46, p47)
	local v100 = nil;
	local v101 = nil;
	local v102 = u14(p44, p45, p46) - p42;
	if not v102 then
		local v103 = p42;
	else
		if v102.x < 0 then
			local v104 = -1;
		else
			v104 = 1;
		end;
		if v102.y < 0 then
			local v105 = -1;
		else
			v105 = 1;
		end;
		if v102.z < 0 then
			local v106 = -1;
		else
			v106 = 1;
		end;
		v103 = p42 + p43 * Vector3.new(v104, v105, v106);
	end;
	local v107 = u14(p44, p45, p46, -v102) - v103;
	local v108 = nil;
	local v109 = nil;
	local v110 = nil;
	p47 = p47 and 0;
	local v111 = 1 - 1;
	while true do
		local v112, v113, v114, v115, v116 = u12(v107, v108, v109, v110);
		v100 = v112;
		v101 = v113;
		local v117 = u14(p44, p45, p46, v100);
		local v118 = -v100;
		if not v118 then
			local v119 = p42;
		else
			if v118.x < 0 then
				local v120 = -1;
			else
				v120 = 1;
			end;
			if v118.y < 0 then
				local v121 = -1;
			else
				v121 = 1;
			end;
			if v118.z < 0 then
				local v122 = -1;
			else
				v122 = 1;
			end;
			v119 = p42 + p43 * Vector3.new(v120, v121, v122);
		end;
		local v123 = v117 - v119;
		if v101 and v114 and v115 and v116 then
			return true;
		end;
		if p47 * v100.magnitude < -v100:Dot(v123) then
			return false;
		end;
		if v100:Dot(v123 - v101) <= 0 then
			break;
		end;
		local v124 = v101 and v101 - v123;
		local v125 = v114 and v114 - v123;
		local v126 = v115 and v115 - v123;
		if v126 then
			local v127 = math.abs(v124:Cross(v125):Dot(v126));
		elseif v125 then
			v127 = v124:Cross(v125).magnitude;
		elseif v124 then
			v127 = v124.magnitude;
		else
			v127 = 1;
		end;
		if v127 < 1E-06 then
			break;
		end;
		if 0 <= 1 then
			if not (v111 < 100) then
				return false;
			end;
		elseif not (v111 > 100) then
			return false;
		end;
		v111 = v111 + 1;	
	end;
	if -v101:Dot(v100.unit) <= p47 then
		return true;
	end;
	return false;
end;
return v97;

