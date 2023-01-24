
-- Decompiled with the Synapse X Luau decompiler.

local function u1(p1, p2, p3)
	local v1 = p2:Dot(p2);
	local v2 = p2:Dot(p3);
	local v3 = p2:Cross(p3);
	local v4 = v3:Cross(p2);
	local v5 = p1 * p1 - v3:Dot(v3) / v1;
	local v6 = v5 >= 0;
	local v7 = -v4 / v1;
	local v8 = v2 / v1;
	if v5 > 0 then
		local v9 = math.sqrt(v5 / v1);
		v7 = v7 - v9 * p2;
		v8 = v8 - v9;
	end;
	if v7:Dot(v7) == 0 then
		if not v6 then
			print("wtttff");
			v6 = true;
		end;
		v7 = -p2;
	end;
	return v6, v8, v7;
end;
local function u2(p4, p5, p6, p7)
	local v10 = p5:Dot(p7);
	local v11 = p7:Dot(p7);
	local v12 = p5:Cross(p7);
	local v13 = v12:Dot(p6);
	local v14 = p7:Cross(v12);
	local v15 = p5:Cross(p6):Dot(v12);
	local v16 = v12:Dot(v12);
	local v17 = p6:Cross(p7):Dot(v12);
	if v16 == 0 then
		return;
	end;
	local v18 = p4 * p4 - v13 * v13 / v16;
	local v19 = v18 >= 0;
	local v20 = -v13 / v16 * v12;
	local v21 = v17 / v16;
	local v22 = -v15 / v16;
	if v18 > 0 then
		local v23 = math.sqrt(v18 / (v11 * v16));
		v20 = v20 - v23 * v14;
		v21 = v21 - v23 * v11;
		v22 = v22 - v23 * v10;
	end;
	if v20:Dot(v20) == 0 then
		if not v19 then
			print("wtttff");
			v19 = true;
		end;
		v20 = -v14;
	end;
	return v19, v21, v20, v22;
end;
local function u3(p8, p9, p10, p11, p12)
	local v24 = nil;
	local v25 = nil;
	local v26 = nil;
	local v27 = nil;
	local v28 = nil;
	local v29 = nil;
	local v30 = p9:Cross(p12);
	local v31 = p11:Cross(p9);
	local v32 = p11:Cross(p12);
	local v33 = v32:Dot(p9);
	v25 = v32:Dot(p10);
	v27 = v30:Dot(p10);
	v29 = v31:Dot(p10);
	v26 = v32:Dot(v30);
	v28 = v32:Dot(v31);
	v24 = math.sqrt((v32:Dot(v32)));
	if v33 == 0 then
		return;
	end;
	if v33 < 0 then
		local v34 = v32;
		local v35 = (v25 + p8 * v24) / v33;
		local v36 = (v27 + p8 * v26 / v24) / v33;
		local v37 = (v29 + p8 * v28 / v24) / v33;
	else
		v34 = -v32;
		v35 = (v25 - p8 * v24) / v33;
		v36 = (v27 - p8 * v26 / v24) / v33;
		v37 = (v29 - p8 * v28 / v24) / v33;
	end;
	return true, v35, v34, v36, v37;
end;
local function u4(p13, p14, p15, p16, p17, p18)
	local v38 = p16 - p15;
	local v39 = p17 - p15;
	local v40 = p18 - p15;
	local v41 = v38:Cross(v39);
	local v42 = v41:Dot(v40);
	local v43 = v41:Dot(p14);
	local v44 = v39:Cross(v40):Dot(p14);
	local v45 = v40:Cross(v38):Dot(p14);
	if v42 == 0 then
		local v46 = true;
		if v43 == 0 then
			if v43 < 0 then
				v46 = true;
				if not (v42 < 0) then
					v46 = false;
					if v43 > 0 then
						v46 = v42 > 0;
					end;
				end;
			else
				v46 = false;
				if v43 > 0 then
					v46 = v42 > 0;
				end;
			end;
		end;
	elseif v43 < 0 then
		v46 = true;
		if not (v42 < 0) then
			v46 = false;
			if v43 > 0 then
				v46 = v42 > 0;
			end;
		end;
	else
		v46 = false;
		if v43 > 0 then
			v46 = v42 > 0;
		end;
	end;
	if v42 == 0 then
		local v47 = true;
		if v44 == 0 then
			if v44 < 0 then
				v47 = true;
				if not (v42 < 0) then
					v47 = false;
					if v44 > 0 then
						v47 = v42 > 0;
					end;
				end;
			else
				v47 = false;
				if v44 > 0 then
					v47 = v42 > 0;
				end;
			end;
		end;
	elseif v44 < 0 then
		v47 = true;
		if not (v42 < 0) then
			v47 = false;
			if v44 > 0 then
				v47 = v42 > 0;
			end;
		end;
	else
		v47 = false;
		if v44 > 0 then
			v47 = v42 > 0;
		end;
	end;
	if v42 == 0 then
		local v48 = true;
		if v45 == 0 then
			if v45 < 0 then
				v48 = true;
				if not (v42 < 0) then
					v48 = false;
					if v45 > 0 then
						v48 = v42 > 0;
					end;
				end;
			else
				v48 = false;
				if v45 > 0 then
					v48 = v42 > 0;
				end;
			end;
		end;
	elseif v45 < 0 then
		v48 = true;
		if not (v42 < 0) then
			v48 = false;
			if v45 > 0 then
				v48 = v42 > 0;
			end;
		end;
	else
		v48 = false;
		if v45 > 0 then
			v48 = v42 > 0;
		end;
	end;
	local v49 = 0;
	local v50 = 0;
	local v51 = 0;
	local v52 = 0;
	local v53 = 0;
	local v54 = 0;
	if v46 then
		local v55, v56, v57, v58, v59 = u3(p13, p14, p15, v38, v39);
		if v56 and v58 >= 0 and v59 >= 0 then
			return v55, v56, v57, p15, p16, p17;
		end;
		v49 = v58;
		v50 = v59;
	end;
	if v47 then
		local v60, v61, v62, v63, v64 = u3(p13, p14, p15, v39, v40);
		if v61 and v63 >= 0 and v64 >= 0 then
			return v60, v61, v62, p15, p17, p18;
		end;
		v51 = v63;
		v52 = v64;
	end;
	if v48 then
		local v65, v66, v67, v68, v69 = u3(p13, p14, p15, v40, v38);
		if v66 and v68 >= 0 and v69 >= 0 then
			return v65, v66, v67, p15, p18, p16;
		end;
		v53 = v68;
		v54 = v69;
	end;
	if not (not v46) and v50 <= 0 or v48 and v53 <= 0 then
		local v70, v71, v72, v73 = u2(p13, p14, p15, v38);
		if v71 and v73 >= 0 then
			return v70, v71, v72, p15, p16;
		end;
	end;
	if not (not v46) and v49 <= 0 or v47 and v52 <= 0 then
		local v74, v75, v76, v77 = u2(p13, p14, p15, v39);
		if v75 and v77 >= 0 then
			return v74, v75, v76, p15, p17;
		end;
	end;
	if not (not v48) and v54 <= 0 or v47 and v51 <= 0 then
		local v78, v79, v80, v81 = u2(p13, p14, p15, v40);
		if v79 and v81 >= 0 then
			return v78, v79, v80, p15, p18;
		end;
	end;
	local v82, v83, v84 = u1(p13, p14, p15);
	return v82, v83, v84, p15;
end;
local function u5(p19, p20, p21, p22, p23)
	local v85 = p22 - p21;
	local v86 = p23 - p21;
	local v87 = v85:Cross(v86);
	local v88 = v87:Dot(p20);
	local v89 = v87:Dot((v85:Cross(p20)));
	local v90 = v87:Dot((p20:Cross(v86)));
	local v91 = true;
	if v88 == 0 then
		v91 = v89 > 0;
	end;
	local v92 = true;
	if v88 == 0 then
		v92 = v90 > 0;
	end;
	local v93 = 0;
	local v94 = 0;
	if v88 ~= 0 then
		local v95, v96, v97, v98, v99 = u3(p19, p20, p21, v85, v86);
		if v96 and v98 >= 0 and v99 >= 0 then
			return v95, v96, v97, p21, p22, p23;
		end;
		v93 = v98;
		v94 = v99;
	end;
	if v91 and v94 <= 0 then
		local v100, v101, v102, v103 = u2(p19, p20, p21, v85);
		if v101 and v103 >= 0 then
			return v100, v101, v102, p21, p22;
		end;
	end;
	if v92 and v93 <= 0 then
		local v104, v105, v106, v107 = u2(p19, p20, p21, v86);
		if v105 and v107 >= 0 then
			return v104, v105, v106, p21, p23;
		end;
	end;
	local v108, v109, v110 = u1(p19, p20, p21);
	return v108, v109, v110, p21;
end;
local function u6(p24, p25, p26, p27)
	local v111, v112, v113, v114 = u2(p24, p25, p26, p27 - p26);
	if v112 and v114 >= 0 then
		return v111, v112, v113, p26, p27;
	end;
	local v115, v116, v117 = u1(p24, p25, p26);
	return v115, v116, v117, p26;
end;
local function u7(p28, p29, p30)
	local v118, v119, v120 = u1(p28, p29, p30);
	return v118, v119, v120, p30;
end;
local function u8(p31, p32, p33, p34, p35, p36)
	if p36 then
		return u4(p31, p32, p33, p34, p35, p36);
	end;
	if p35 then
		return u5(p31, p32, p33, p34, p35);
	end;
	if p34 then
		return u6(p31, p32, p33, p34);
	end;
	if not p33 then
		error("wtf u doin");
		return;
	end;
	return u7(p31, p32, p33);
end;
local v121 = {};
local function u9(p37, p38, p39, p40, p41, p42)
	if p39.magnitude == 0 then
		return nil, nil, "zero length sweep";
	end;
	local v122 = p38(-p39) - p37(p39);
	if p42 and p42 < v122:Dot(p39) / p39:Dot(p39) - p40 / p39.magnitude then
		return nil, nil, "maxT exit";
	end;
	local v123 = (1 / 0);
	local v124 = nil;
	local v125 = nil;
	local v126 = nil;
	local v127 = nil;
	local v128 = nil;
	local v129 = nil;
	for v130 = 1, 300 do
		debug.profilebegin("step");
		local v131, v132, v133, v134, v135, v136 = u8(p40, p39, v122, v124, v125, v126);
		local v137 = p38(v133) - p37(-v133);
		if v132 ~= v132 then
			debug.profileend();
			break;
		end;
		local v138 = v133:Dot(v137 - v134) / v133.magnitude;
		if v138 < v123 then
			v123 = v138;
			v127 = v131;
			v128 = v132;
			v129 = v133;
		end;
		if v138 <= v130 * 1E-07 then
			debug.profileend();
			break;
		end;
		if p41 and not v131 and p40 * v133.magnitude < v133:Dot(v132 * p39 - v137) then
			debug.profileend();
			return false, nil, "far pass exit";
		end;
		debug.profileend();
	end;
	if v127 == nil then
		return nil, nil, "exhausted search time";
	end;
	local v139 = p37();
	return v127, v128, v129.unit;
end;
function v121.point(p43, p44, p45, p46)
	return u9(function()
		return p44;
	end, p43, p45, 0, p46);
end;
local function u10(p47, p48, p49, p50, p51, p52, p53, p54, p55)
	local v140 = p50 - p54;
	local v141 = p48 + p52;
	if v140.magnitude == 0 then
		return nil, nil, "zero length sweep";
	end;
	local v142 = p51(-v140) - p47(v140) + p53 - p49;
	local v143 = (1 / 0);
	local v144 = nil;
	local v145 = nil;
	local v146 = nil;
	local v147 = nil;
	local v148 = nil;
	local v149 = nil;
	for v150 = 1, 300 do
		local v151, v152, v153, v154, v155, v156 = u8(v141, v140, v142, v144, v145, v146);
		local v157 = p51(v153) - p47(-v153) + p53 - p49;
		local v158 = v153:Dot(v157 - v154) / v153.magnitude;
		if v152 ~= v152 then
			break;
		end;
		if v158 < v143 then
			v143 = v158;
			v147 = v151;
			v148 = v152;
			v149 = v153;
		end;
		if v158 <= v150 * 1E-07 then
			break;
		end;
		if p55 and not v151 and v141 * v153.magnitude < v153:Dot(v152 * v140 - v157) then
			return false, nil, "far pass exit";
		end;
	end;
	if v147 == nil then
		return nil, nil, "exhausted search iterations";
	end;
	return v147, v148, v149.unit;
end;
local function u11()
	return Vector3.zero;
end;
function v121.sphere(p56, p57, p58, p59, p60)
	return u10(u11, p59, p57, p58, p56, p56.radius, Vector3.zero, Vector3.zero, p60);
end;
function v121.mesh(p61, p62, p63, p64, p65, p66)
	debug.profilebegin("Sweep");
	local v159, v160, v161, v162 = u9(p62, p61, p63, p64 and 0, p65, p66);
	debug.profileend();
	return v159, v160, v161, v162;
end;
return v121;

