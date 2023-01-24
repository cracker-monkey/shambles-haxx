
-- Decompiled with the Synapse X Luau decompiler.

local function u1(p1, p2, p3, p4, p5, p6, p7)
	local v1 = p3:Cross(p5);
	local v2 = p5:Cross(p7);
	local v3 = p7:Cross(p3);
	local v4 = v1:Dot(p7);
	if v4 == 0 then
		return;
	end;
	return p2:Dot(p3) / v4 * v2 + p4:Dot(p5) / v4 * v3 + p6:Dot(p7) / v4 * v1, math.sqrt((p3:Dot(p3))) / v4 * v2 + math.sqrt((p5:Dot(p5))) / v4 * v3 + math.sqrt((p7:Dot(p7))) / v4 * v1;
end;
local function u2(p8, p9, p10, p11, p12)
	local v5 = p10:Cross(p12);
	local v6 = p12:Cross(v5);
	local v7 = v5:Cross(p10);
	local v8 = v5:Dot(v5);
	if v8 == 0 then
		return;
	end;
	return p8 + (p9 - p8):Dot(p10) / v8 * v6 + (p11 - p8):Dot(p12) / v8 * v7, math.sqrt((p10:Dot(p10))) / v8 * v6 + math.sqrt((p12:Dot(p12))) / v8 * v7;
end;
local function u3(p13, p14, p15, p16, p17, p18, p19)
	if not p19 then
		if p18 then
			local v9 = p13[p16];
			local v10 = p14[p16];
			local v11 = p13[p17];
			local v12 = p14[p17];
			local v13 = p13[p18];
			local v14 = p14[p18];
			local v15, v16 = u1(p15, v9, v10, v11, v12, v13, v14);
			local v17, v18 = u2(p15, v9, v10, v11, v12);
			local v19, v20 = u2(p15, v9, v10, v13, v14);
			local v21 = (1 / 0);
			local v22 = nil;
			local v23 = nil;
			if v16 and v16.magnitude < v21 then
				v21 = v16.magnitude;
				v22 = v15;
				v23 = v16;
			end;
			if v18 and v18.magnitude < v21 and v14.magnitude <= v18:Dot(v14) then
				v21 = v18.magnitude;
				v22 = v17;
				v23 = v18;
			end;
			if v20 and v20.magnitude < v21 and v12.magnitude <= v20:Dot(v12) then
				local l__magnitude__24 = v20.magnitude;
				v22 = v19;
				v23 = v20;
			end;
			if not v23 then
				return nil, nil, p16, p17, p18;
			elseif v23 == v16 then
				return v22, v23, p16, p17, p18;
			elseif v23 == v18 then
				return v22, v23, p16, p17;
			elseif v23 == v20 then
				return v22, v23, p16, p18;
			else
				error("lol wut");
				return;
			end;
		elseif p17 then
			local v25, v26 = u2(p15, p13[p16], p14[p16], p13[p17], p14[p17]);
			return v25, v26, p16, p17;
		elseif p16 then
			local v27 = p14[p16];
			return p15 + (p13[p16] - p15):Dot(v27) / v27:Dot(v27) * v27, v27.unit, p16;
		else
			return p15, Vector3.zero;
		end;
	end;
	local v28 = p13[p16];
	local v29 = p14[p16];
	local v30 = p13[p17];
	local v31 = p14[p17];
	local v32 = p13[p18];
	local v33 = p14[p18];
	local v34 = p13[p19];
	local v35 = p14[p19];
	local v36, v37 = u1(p15, v28, v29, v30, v31, v32, v33);
	local v38, v39 = u1(p15, v28, v29, v30, v31, v34, v35);
	local v40, v41 = u1(p15, v28, v29, v32, v33, v34, v35);
	local v42, v43 = u2(p15, v28, v29, v30, v31);
	local v44, v45 = u2(p15, v28, v29, v32, v33);
	local v46, v47 = u2(p15, v28, v29, v34, v35);
	local v48 = (1 / 0);
	local v49 = nil;
	local v50 = nil;
	if v37 and v37.magnitude < v48 and v35.magnitude <= v37:Dot(v35) then
		v48 = v37.magnitude;
		v49 = v36;
		v50 = v37;
	end;
	if v39 and v39.magnitude < v48 and v33.magnitude <= v39:Dot(v33) then
		v48 = v39.magnitude;
		v49 = v38;
		v50 = v39;
	end;
	if v41 and v41.magnitude < v48 and v31.magnitude <= v41:Dot(v31) then
		v48 = v41.magnitude;
		v49 = v40;
		v50 = v41;
	end;
	if v43 and v43.magnitude < v48 and v33.magnitude <= v43:Dot(v33) and v35.magnitude <= v43:Dot(v35) then
		v48 = v43.magnitude;
		v49 = v42;
		v50 = v43;
	end;
	if v45 and v45.magnitude < v48 and v31.magnitude <= v45:Dot(v31) and v35.magnitude <= v45:Dot(v35) then
		v48 = v45.magnitude;
		v49 = v44;
		v50 = v45;
	end;
	if v47 and v47.magnitude < v48 and v31.magnitude <= v47:Dot(v31) and v33.magnitude <= v47:Dot(v33) then
		local l__magnitude__51 = v47.magnitude;
		v49 = v46;
		v50 = v47;
	end;
	if not v50 then
		return nil, nil, p16, p17, p18, p19;
	end;
	if v50 == v37 then
		return v49, v50, p16, p17, p18;
	end;
	if v50 == v39 then
		return v49, v50, p16, p17, p19;
	end;
	if v50 == v41 then
		return v49, v50, p16, p18, p19;
	end;
	if v50 == v43 then
		return v49, v50, p16, p17;
	end;
	if v50 == v45 then
		return v49, v50, p16, p18;
	end;
	if v50 ~= v47 then
		error("lol wut");
		return;
	end;
	return v49, v50, p16, p19;
end;
local function u4(p20, p21, p22, p23, p24, p25, p26)
	local v52 = (1 / 0);
	local v53 = nil;
	for v54 = 1, #p20 do
		if v54 ~= p24 and v54 ~= p25 and v54 ~= p26 then
			local v55 = p21[v54];
			local v56 = (p22 - p20[v54]):Dot(v55) / (v55.unit - p23):Dot(v55);
			if p23:Dot(v55) < v55.magnitude and v56 < v52 then
				v52 = v56;
				v53 = v54;
			end;
		end;
	end;
	return v52, v53;
end;
local v57 = {};
local function u5(p27, p28, p29, p30, p31)
	p30 = p30 and 0;
	local v58 = (-1 / 0);
	local v59, v60, v61, v62, v63, v64 = u3(p27, p28, p29);
	for v65 = 1, 300 do
		local v66, v67 = u4(p27, p28, v59, v60, v61, v62, v63);
		if p31 and not v67 then
			return v59 + math.max(p30, v58) * v60;
		end;
		if not p31 and p30 <= v66 then
			return v59 + p30 * v60;
		end;
		local v68 = v59 + v66 * v60;
		local v69, v70, v71, v72, v73, v74 = u3(p27, p28, v68, v67, v61, v62, v63);
		if not v70 then
			return v68;
		end;
		if v65 == 300 then
			warn("here");
			print(p27);
			print(p28);
			print(p29);
		end;
	end;
	return p29;
end;
function v57.push(p32, p33, p34, p35, p36)
	debug.profilebegin("Incenter");
	local v75 = u5(p32, p33, p34, p35, p36);
	debug.profileend();
	return v75;
end;
return v57;

