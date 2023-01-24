
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = CFrame.new();
local l__ToObjectSpace__3 = v2.ToObjectSpace;
local l__CFrame_new__1 = CFrame.new;
function v1.fromaxisangle(p1, p2, p3)
	if not p2 then
		p2 = p1.y;
		p3 = p1.z;
		p1 = p1.x;
	end;
	local v4 = (p1 * p1 + p2 * p2 + p3 * p3) ^ 0.5;
	if not (v4 > 1E-05) then
		return v2;
	end;
	local v5 = math.sin(v4 / 2) / v4;
	return l__CFrame_new__1(0, 0, 0, v5 * p1, v5 * p2, v5 * p3, math.cos(v4 / 2));
end;
local l__components__2 = v2.components;
local l__math_pi__3 = math.pi;
function v1.toaxisangle(p4)
	local v6 = nil;
	local v7 = nil;
	local v8 = nil;
	local v9 = nil;
	local v10 = nil;
	local v11 = nil;
	local v12 = nil;
	local v13 = nil;
	local v14 = nil;
	local v15 = nil;
	local v16 = nil;
	local v17 = nil;
	v12, v13, v14, v15, v11, v8, v10, v16, v7, v9, v6, v17 = l__components__2(p4);
	local v18 = (v15 + v16 + v17 - 1) / 2;
	if not (v18 < -0.99999) then
		if v18 < 0.99999 then
			local v19 = v6 - v7;
			local v20 = v8 - v9;
			local v21 = v10 - v11;
			local v22 = math.acos(v18) * (v19 * v19 + v20 * v20 + v21 * v21) ^ -0.5;
			return Vector3.new(v22 * v19, v22 * v20, v22 * v21);
		else
			return Vector3.zero;
		end;
	end;
	local v23 = v15 + v11 + v8 + 1;
	local v24 = v10 + v16 + v7 + 1;
	local v25 = v9 + v6 + v17 + 1;
	local v26 = l__math_pi__3 * (v23 * v23 + v24 * v24 + v25 * v25) ^ -0.5;
	return Vector3.new(v26 * v23, v26 * v24, v26 * v25);
end;
local l__VectorToObjectSpace__4 = v2.VectorToObjectSpace;
local u5 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1);
function v1.direct(p5, p6, p7, p8)
	local l__x__27 = p6.x;
	local l__y__28 = p6.y;
	local l__z__29 = p6.z;
	local v30 = l__VectorToObjectSpace__4(p5, p7);
	local l__x__31 = v30.x;
	local l__y__32 = v30.y;
	local l__z__33 = v30.z;
	local v34 = ((l__x__31 * l__x__31 + l__y__32 * l__y__32 + l__z__33 * l__z__33) * (l__x__27 * l__x__27 + l__y__28 * l__y__28 + l__z__29 * l__z__29)) ^ 0.5;
	local v35 = (l__x__27 * l__x__31 + l__y__28 * l__y__32 + l__z__29 * l__z__33) / v34;
	if v35 < -0.99999 then
		return p5 * u5;
	end;
	if not (v35 < 0.99999) then
		return p5;
	end;
	if not p8 then
		local v36 = ((v35 + 1) / 2) ^ 0.5;
		local v37 = 2 * v36 * v34;
		return p5 * l__CFrame_new__1(0, 0, 0, (l__y__28 * l__z__33 - l__z__29 * l__y__32) / v37, (l__z__29 * l__x__31 - l__x__27 * l__z__33) / v37, (l__x__27 * l__y__32 - l__y__28 * l__x__31) / v37, v36);
	end;
	local v38 = math.cos(p8 * math.acos(v35) / 2);
	local v39 = v34 * ((1 - v35 * v35) / (1 - v38 * v38)) ^ 0.5;
	return p5 * l__CFrame_new__1(0, 0, 0, (l__y__28 * l__z__33 - l__z__29 * l__y__32) / v39, (l__z__29 * l__x__31 - l__x__27 * l__z__33) / v39, (l__x__27 * l__y__32 - l__y__28 * l__x__31) / v39, v38);
end;
function v1.toquaternion(p9)
	local v40 = nil;
	local v41 = nil;
	local v42 = nil;
	local v43 = nil;
	local v44 = nil;
	local v45 = nil;
	local v46 = nil;
	local v47 = nil;
	local v48 = nil;
	local v49 = nil;
	local v50 = nil;
	local v51 = nil;
	v40, v41, v42, v49, v48, v45, v47, v50, v44, v46, v43, v51 = l__components__2(p9);
	local v52 = v49 + v50 + v51;
	if v52 > 2.99999 then
		return v40, v41, v42, 0, 0, 0, 1;
	end;
	if v52 > -0.99999 then
		local v53 = 2 * (v52 + 1) ^ 0.5;
		return v40, v41, v42, (v43 - v44) / v53, (v45 - v46) / v53, (v47 - v48) / v53, v53 / 4;
	end;
	local v54 = v49 + v48 + v45 + 1;
	local v55 = v47 + v50 + v44 + 1;
	local v56 = v46 + v43 + v51 + 1;
	local v57 = (v54 * v54 + v55 * v55 + v56 * v56) ^ 0.5;
	return v40, v41, v42, v54 / v57, v55 / v57, v56 / v57, 0;
end;
local l__lerp__6 = v2.lerp;
function v1.power(p10, p11)
	return l__lerp__6(v2, p10, p11);
end;
function v1.interpolator(p12, p13, p14)
	if p14 then
		return function(p15)
			return l__lerp__6(l__lerp__6(p12, p13, p15), l__lerp__6(p13, p14, p15), p15);
		end;
	end;
	if p13 then
		return function(p16)
			return l__lerp__6(p12, p13, p16);
		end;
	end;
	return function(p17)
		return l__lerp__6(v2, p12, p17);
	end;
end;
local l__PointToObjectSpace__7 = v2.PointToObjectSpace;
function v1.jointleg(p18, p19, p20, p21, p22)
	local v58 = l__PointToObjectSpace__7(p20, p21);
	local l__x__59 = v58.x;
	local l__y__60 = v58.y;
	local l__z__61 = v58.z;
	local v62 = (l__x__59 * l__x__59 + l__y__60 * l__y__60 + l__z__61 * l__z__61) ^ 0.5;
	local v63 = l__x__59 / v62;
	local v64 = l__y__60 / v62;
	local v65 = l__z__61 / v62;
	local v66 = p18 + p19 < v62 and p18 + p19 or v62;
	local v67 = (p19 * p19 - p18 * p18 - v66 * v66) / (2 * p18 * v66);
	local v68 = -(1 - v67 * v67) ^ 0.5;
	local v69 = (2 * (1 + v68 * v64 + v67 * v65)) ^ 0.5;
	local v70 = v69 / 2;
	local v71 = (v68 * v65 - v67 * v64) / v69;
	local v72 = v67 * v63 / v69;
	local v73 = -v68 * v63 / v69;
	if p22 then
		local v74 = math.cos(p22 / 2);
		local v75 = math.sin(p22 / 2);
		v73 = v74 * v73 + v75 * (v65 * v70 - v64 * v71 + v63 * v72);
		v70 = v74 * v70 - v75 * (v63 * v71 + v64 * v72 + v65 * v73);
		v71 = v74 * v71 + v75 * (v63 * v70 - v65 * v72 + v64 * v73);
		v72 = v74 * v72 + v75 * (v64 * v70 + v65 * v71 - v63 * v73);
	end;
	local v76 = (v66 * v67 + p18) / (v66 * v66 + 2 * v66 * v67 * p18 + p18 * p18) ^ 0.5;
	local v77 = ((1 - v76) / 2) ^ 0.5;
	local v78 = -((1 + v76) / 2) ^ 0.5;
	return p20 * l__CFrame_new__1(-p18 * 2 * (v71 * v73 + v72 * v70), p18 * 2 * (v71 * v70 - v72 * v73), p18 * (2 * (v71 * v71 + v72 * v72) - 1), v77 * v71 + v78 * v70, v77 * v72 + v78 * v73, v77 * v73 - v78 * v72, v77 * v70 - v78 * v71);
end;
function v1.jointarm(p23, p24, p25, p26, p27)
	local v79 = l__PointToObjectSpace__7(p25, p26);
	local l__x__80 = v79.x;
	local l__y__81 = v79.y;
	local l__z__82 = v79.z;
	local v83 = (l__x__80 * l__x__80 + l__y__81 * l__y__81 + l__z__82 * l__z__82) ^ 0.5;
	local v84 = l__x__80 / v83;
	local v85 = l__y__81 / v83;
	local v86 = l__z__82 / v83;
	local v87 = p23 + p24 < v83 and p23 + p24 or v83;
	local v88 = (p24 * p24 - p23 * p23 - v87 * v87) / (2 * p23 * v87);
	local v89 = (1 - v88 * v88) ^ 0.5;
	local v90 = (2 * (1 + v89 * v85 + v88 * v86)) ^ 0.5;
	local v91 = v90 / 2;
	local v92 = (v89 * v86 - v88 * v85) / v90;
	local v93 = v88 * v84 / v90;
	local v94 = -v89 * v84 / v90;
	if p27 then
		local v95 = math.cos(p27 / 2);
		local v96 = math.sin(p27 / 2);
		v94 = v95 * v94 + v96 * (v86 * v91 - v85 * v92 + v84 * v93);
		v91 = v95 * v91 - v96 * (v84 * v92 + v85 * v93 + v86 * v94);
		v92 = v95 * v92 + v96 * (v84 * v91 - v86 * v93 + v85 * v94);
		v93 = v95 * v93 + v96 * (v85 * v91 + v86 * v92 - v84 * v94);
	end;
	local v97 = (v87 * v88 + p23) / (v87 * v87 + 2 * v87 * v88 * p23 + p23 * p23) ^ 0.5;
	local v98 = ((1 - v97) / 2) ^ 0.5;
	local v99 = ((1 + v97) / 2) ^ 0.5;
	return p25 * l__CFrame_new__1(-p23 * 2 * (v92 * v94 + v93 * v91), p23 * 2 * (v92 * v91 - v93 * v94), p23 * (2 * (v92 * v92 + v93 * v93) - 1), v98 * v92 + v99 * v91, v98 * v93 + v99 * v94, v98 * v94 - v99 * v93, v98 * v91 - v99 * v92), p25 * l__CFrame_new__1(0, 0, 0, v92, v93, v94, v91);
end;
table.freeze(v1);
return v1;

