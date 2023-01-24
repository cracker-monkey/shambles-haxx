
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = CFrame.new();
local l__VectorToObjectSpace__3 = v2.VectorToObjectSpace;
local l__PointToObjectSpace__4 = v2.PointToObjectSpace;
local l__lerp__5 = v2.lerp;
v1.identity = v2;
v1.new = CFrame.new;
v1.vtws = v2.VectorToWorldSpace;
v1.tos = v2.ToObjectSpace;
v1.ptos = l__PointToObjectSpace__4;
v1.vtos = l__VectorToObjectSpace__3;
v1.interpolate = l__lerp__5;
local l__math_sin__1 = math.sin;
local l__CFrame_new__2 = CFrame.new;
local l__math_cos__3 = math.cos;
function v1.fromAxisAngle(p1, p2, p3)
	if not p2 then
		p2 = p1.y;
		p3 = p1.z;
		p1 = p1.x;
	end;
	local v6 = (p1 * p1 + p2 * p2 + p3 * p3) ^ 0.5;
	if not (v6 > 1E-05) then
		return v2;
	end;
	local v7 = l__math_sin__1(v6 / 2) / v6;
	return l__CFrame_new__2(0, 0, 0, v7 * p1, v7 * p2, v7 * p3, l__math_cos__3(v6 / 2));
end;
local l__components__4 = v2.components;
local l__math_pi__5 = math.pi;
local l__Vector3_new__6 = Vector3.new;
local l__math_acos__7 = math.acos;
local l__Vector3_zero__8 = Vector3.zero;
function v1.toAxisAngle(p4)
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
	local v18 = nil;
	local v19 = nil;
	v14, v15, v16, v17, v13, v10, v12, v18, v9, v11, v8, v19 = l__components__4(p4);
	local v20 = (v17 + v18 + v19 - 1) / 2;
	if not (v20 < -0.99999) then
		if v20 < 0.99999 then
			local v21 = v8 - v9;
			local v22 = v10 - v11;
			local v23 = v12 - v13;
			local v24 = l__math_acos__7(v20) * (v21 * v21 + v22 * v22 + v23 * v23) ^ -0.5;
			return l__Vector3_new__6(v24 * v21, v24 * v22, v24 * v23);
		else
			return l__Vector3_zero__8;
		end;
	end;
	local v25 = v17 + v13 + v10 + 1;
	local v26 = v12 + v18 + v9 + 1;
	local v27 = v11 + v8 + v19 + 1;
	local v28 = l__math_pi__5 * (v25 * v25 + v26 * v26 + v27 * v27) ^ -0.5;
	return l__Vector3_new__6(v28 * v25, v28 * v26, v28 * v27);
end;
local u9 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1);
function v1.direct(p5, p6, p7, p8)
	local l__x__29 = p6.x;
	local l__y__30 = p6.y;
	local l__z__31 = p6.z;
	local v32 = l__VectorToObjectSpace__3(p5, p7);
	local l__x__33 = v32.x;
	local l__y__34 = v32.y;
	local l__z__35 = v32.z;
	local v36 = ((l__x__33 * l__x__33 + l__y__34 * l__y__34 + l__z__35 * l__z__35) * (l__x__29 * l__x__29 + l__y__30 * l__y__30 + l__z__31 * l__z__31)) ^ 0.5;
	local v37 = (l__x__29 * l__x__33 + l__y__30 * l__y__34 + l__z__31 * l__z__35) / v36;
	if v37 < -0.99999 then
		return p5 * u9;
	end;
	if not (v37 < 0.99999) then
		return p5;
	end;
	if not p8 then
		local v38 = ((v37 + 1) / 2) ^ 0.5;
		local v39 = 2 * v38 * v36;
		return p5 * l__CFrame_new__2(0, 0, 0, (l__y__30 * l__z__35 - l__z__31 * l__y__34) / v39, (l__z__31 * l__x__33 - l__x__29 * l__z__35) / v39, (l__x__29 * l__y__34 - l__y__30 * l__x__33) / v39, v38);
	end;
	local v40 = l__math_cos__3(p8 * l__math_acos__7(v37) / 2);
	local v41 = v36 * ((1 - v37 * v37) / (1 - v40 * v40)) ^ 0.5;
	return p5 * l__CFrame_new__2(0, 0, 0, (l__y__30 * l__z__35 - l__z__31 * l__y__34) / v41, (l__z__31 * l__x__33 - l__x__29 * l__z__35) / v41, (l__x__29 * l__y__34 - l__y__30 * l__x__33) / v41, v40);
end;
function v1.toQuaternion(p9)
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
	local v52 = nil;
	local v53 = nil;
	v42, v43, v44, v51, v50, v47, v49, v52, v46, v48, v45, v53 = l__components__4(p9);
	local v54 = v51 + v52 + v53;
	if v54 > 2.99999 then
		return v42, v43, v44, 0, 0, 0, 1;
	end;
	if v54 > -0.99999 then
		local v55 = 2 * (v54 + 1) ^ 0.5;
		return v42, v43, v44, (v45 - v46) / v55, (v47 - v48) / v55, (v49 - v50) / v55, v55 / 4;
	end;
	local v56 = v51 + v50 + v47 + 1;
	local v57 = v49 + v52 + v46 + 1;
	local v58 = v48 + v45 + v53 + 1;
	local v59 = (v56 * v56 + v57 * v57 + v58 * v58) ^ 0.5;
	return v42, v43, v44, v56 / v59, v57 / v59, v58 / v59, 0;
end;
function v1.power(p10, p11)
	return l__lerp__5(v2, p10, p11);
end;
function v1.interpolator(p12, p13, p14)
	if p14 then
		return function(p15)
			return l__lerp__5(l__lerp__5(p12, p13, p15), l__lerp__5(p13, p14, p15), p15);
		end;
	end;
	if p13 then
		return function(p16)
			return l__lerp__5(p12, p13, p16);
		end;
	end;
	return function(p17)
		return l__lerp__5(v2, p12, p17);
	end;
end;
function v1.jointLeg(p18, p19, p20, p21, p22)
	local v60 = l__PointToObjectSpace__4(p20, p21);
	local l__x__61 = v60.x;
	local l__y__62 = v60.y;
	local l__z__63 = v60.z;
	local v64 = (l__x__61 * l__x__61 + l__y__62 * l__y__62 + l__z__63 * l__z__63) ^ 0.5;
	local v65 = l__x__61 / v64;
	local v66 = l__y__62 / v64;
	local v67 = l__z__63 / v64;
	local v68 = p18 + p19 < v64 and p18 + p19 or v64;
	local v69 = (p19 * p19 - p18 * p18 - v68 * v68) / (2 * p18 * v68);
	local v70 = -(1 - v69 * v69) ^ 0.5;
	local v71 = (2 * (1 + v70 * v66 + v69 * v67)) ^ 0.5;
	local v72 = v71 / 2;
	local v73 = (v70 * v67 - v69 * v66) / v71;
	local v74 = v69 * v65 / v71;
	local v75 = -v70 * v65 / v71;
	if p22 then
		local v76 = l__math_cos__3(p22 / 2);
		local v77 = l__math_sin__1(p22 / 2);
		v75 = v76 * v75 + v77 * (v67 * v72 - v66 * v73 + v65 * v74);
		v72 = v76 * v72 - v77 * (v65 * v73 + v66 * v74 + v67 * v75);
		v73 = v76 * v73 + v77 * (v65 * v72 - v67 * v74 + v66 * v75);
		v74 = v76 * v74 + v77 * (v66 * v72 + v67 * v73 - v65 * v75);
	end;
	local v78 = (v68 * v69 + p18) / (v68 * v68 + 2 * v68 * v69 * p18 + p18 * p18) ^ 0.5;
	local v79 = ((1 - v78) / 2) ^ 0.5;
	local v80 = -((1 + v78) / 2) ^ 0.5;
	return p20 * l__CFrame_new__2(-p18 * 2 * (v73 * v75 + v74 * v72), p18 * 2 * (v73 * v72 - v74 * v75), p18 * (2 * (v73 * v73 + v74 * v74) - 1), v79 * v73 + v80 * v72, v79 * v74 + v80 * v75, v79 * v75 - v80 * v74, v79 * v72 - v80 * v73);
end;
function v1.jointArm(p23, p24, p25, p26, p27)
	local v81 = l__PointToObjectSpace__4(p25, p26);
	local l__x__82 = v81.x;
	local l__y__83 = v81.y;
	local l__z__84 = v81.z;
	local v85 = (l__x__82 * l__x__82 + l__y__83 * l__y__83 + l__z__84 * l__z__84) ^ 0.5;
	local v86 = l__x__82 / v85;
	local v87 = l__y__83 / v85;
	local v88 = l__z__84 / v85;
	local v89 = p23 + p24 < v85 and p23 + p24 or v85;
	local v90 = (p24 * p24 - p23 * p23 - v89 * v89) / (2 * p23 * v89);
	local v91 = (1 - v90 * v90) ^ 0.5;
	local v92 = (2 * (1 + v91 * v87 + v90 * v88)) ^ 0.5;
	local v93 = v92 / 2;
	local v94 = (v91 * v88 - v90 * v87) / v92;
	local v95 = v90 * v86 / v92;
	local v96 = -v91 * v86 / v92;
	if p27 then
		local v97 = l__math_cos__3(p27 / 2);
		local v98 = l__math_sin__1(p27 / 2);
		v96 = v97 * v96 + v98 * (v88 * v93 - v87 * v94 + v86 * v95);
		v93 = v97 * v93 - v98 * (v86 * v94 + v87 * v95 + v88 * v96);
		v94 = v97 * v94 + v98 * (v86 * v93 - v88 * v95 + v87 * v96);
		v95 = v97 * v95 + v98 * (v87 * v93 + v88 * v94 - v86 * v96);
	end;
	local v99 = (v89 * v90 + p23) / (v89 * v89 + 2 * v89 * v90 * p23 + p23 * p23) ^ 0.5;
	local v100 = ((1 - v99) / 2) ^ 0.5;
	local v101 = ((1 + v99) / 2) ^ 0.5;
	return p25 * l__CFrame_new__2(-p23 * 2 * (v94 * v96 + v95 * v93), p23 * 2 * (v94 * v93 - v95 * v96), p23 * (2 * (v94 * v94 + v95 * v95) - 1), v100 * v94 + v101 * v93, v100 * v95 + v101 * v96, v100 * v96 - v101 * v95, v100 * v93 - v101 * v94), p25 * l__CFrame_new__2(0, 0, 0, v94, v95, v96, v93);
end;
return v1;

