
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("GameClock");
local v3 = CFrame.new();
local l__vectorToWorldSpace__4 = v3.vectorToWorldSpace;
local l__pointToWorldSpace__5 = v3.pointToWorldSpace;
local u1 = shared.require("Destructor");
local l__pointToObjectSpace__2 = v3.pointToObjectSpace;
local l__NumberSequence_new__3 = NumberSequence.new;
local l__Terrain__4 = workspace.Terrain;
function v1.new(p1, p2)
	local v6 = setmetatable({}, v1);
	v6._destructor = u1.new();
	local v7 = os.clock();
	local v8, v9 = l__pointToObjectSpace__2(p1, p2);
	v6._t0 = nil;
	v6._p0 = nil;
	v6._v0 = nil;
	v6._t1 = v7;
	v6._p1 = v8;
	v6._v1 = v9;
	v6._isTransparent = false;
	local v10 = Instance.new("Attachment");
	v6._attach0 = v10;
	v6._destructor:add(v6._attach0);
	local v11 = Instance.new("Attachment");
	v6._attach1 = v11;
	v6._destructor:add(v6._attach1);
	v6.beams = {};
	local v12 = Instance.new("Beam");
	v12.Attachment0 = v10;
	v12.Attachment1 = v11;
	v12.Segments = 64;
	v12.TextureSpeed = 0;
	v12.Transparency = l__NumberSequence_new__3(0);
	v12.FaceCamera = true;
	v12.Parent = l__Terrain__4;
	v6._destructor:add(v12);
	v6.beams[1] = v12;
	v10.Parent = l__Terrain__4;
	v11.Parent = l__Terrain__4;
	return v6;
end;
function v1.Destroy(p3)
	p3._destructor:Destroy();
end;
local u5 = shared.require("ScreenCull");
local u6 = NumberSequence.new(1);
local function u7(p4)
	local v13 = p4 * p4;
	local l__x__14 = v13.x;
	local l__y__15 = v13.y;
	local v16 = math.min(l__x__14, l__y__15, v13.z);
	if l__x__14 == v16 then
		return Vector3.xAxis:Cross(p4);
	end;
	if l__y__15 == v16 then
		return Vector3.yAxis:Cross(p4);
	end;
	return Vector3.zAxis:Cross(p4);
end;
function v1.step(p5, p6, p7, p8, p9, p10)
	debug.profilebegin("Beam");
	local l___attach0__17 = p5._attach0;
	local l___attach1__18 = p5._attach1;
	local v19 = os.clock();
	local v20 = l__pointToObjectSpace__2(p6, p7);
	local l___t0__21 = p5._t0;
	local l___v0__22 = p5._v0;
	local l___t1__23 = p5._t1;
	local v24 = p5._v1;
	local l___p1__25 = p5._p1;
	if l___t0__21 then
		local v26 = 1 / (l___t1__23 - l___t0__21);
		local v27 = 1 / (v19 - l___t0__21);
		local v28 = 1 / (v19 - l___t1__23);
		local v29 = (v26 - v27) * p5._p0 - (v26 + v28) * l___p1__25 + (v27 + v28) * v20;
	else
		v29 = (v20 - l___p1__25) / (v19 - l___t1__23);
		v24 = v29;
	end;
	local v30 = -l___p1__25.z;
	local v31 = -v20.z;
	if not u5.localSegment(l___p1__25, v20) or v30 < 1 and v31 < 1 then
		if not p5._isTransparent then
			p5:setWidthTransparencyCurveSize(0, 0, u6, 0, 0);
			p5._isTransparent = true;
		end;
		debug.profileend();
		return;
	end;
	p5._isTransparent = false;
	local v32 = v19 - l___t1__23;
	local l__magnitude__33 = v24.magnitude;
	local l__magnitude__34 = v29.magnitude;
	if v30 < 1 then
		local v35 = (1 - v30) / (v31 - v30);
		local v36 = p8 / 1;
		local v37 = p8 / v31;
		local v38 = v36 + p9;
		local v39 = v37 + p9;
		local v40 = v20 / v31 - ((1 - v35) * l___p1__25 + v35 * v20) / 1;
		local l__magnitude__41 = v40.magnitude;
		local v42 = (1 - v35) * 1 * v38;
		local v43 = v31 * v39;
		local v44 = l__NumberSequence_new__3(1 - p10 * ((v36 * v36 + v37 * v37) / (l__magnitude__41 * l__magnitude__41 * (v38 + v39) + v38 * v38 + v39 * v39)));
		local v45 = l___p1__25;
		local v46 = v20 + v31 * v39 / (2 * l__magnitude__41) * v40;
	elseif v31 < 1 then
		local v47 = (1 - v30) / (v31 - v30);
		local v48 = p8 / v30;
		local v49 = p8 / 1;
		local v50 = v48 + p9;
		local v51 = v49 + p9;
		local v52 = ((1 - v47) * l___p1__25 + v47 * v20) / 1 - l___p1__25 / v30;
		local l__magnitude__53 = v52.magnitude;
		v42 = v30 * v50;
		v43 = v47 * 1 * v51;
		v44 = l__NumberSequence_new__3(1 - p10 * ((v48 * v48 + v49 * v49) / (l__magnitude__53 * l__magnitude__53 * (v50 + v51) + v50 * v50 + v51 * v51)));
		v45 = l___p1__25 - v30 * v50 / (2 * l__magnitude__53) * v52;
		v46 = v20;
	else
		local v54 = p8 / v30;
		local v55 = p8 / v31;
		local v56 = v54 + p9;
		local v57 = v55 + p9;
		local v58 = v20 / v31 - l___p1__25 / v30;
		local l__magnitude__59 = v58.magnitude;
		v42 = v30 * v56;
		v43 = v31 * v57;
		v44 = l__NumberSequence_new__3(1 - p10 * ((v54 * v54 + v55 * v55) / (l__magnitude__59 * l__magnitude__59 * (v56 + v57) + v56 * v56 + v57 * v57)));
		v45 = l___p1__25 - v30 * v56 / (2 * l__magnitude__59) * v58;
		v46 = v20 + v31 * v57 / (2 * l__magnitude__59) * v58;
	end;
	p5:setWidthTransparencyCurveSize(v42, v43, v44, v32 / 3 * l__magnitude__33, v32 / 3 * l__magnitude__34);
	if l__magnitude__33 > 1E-08 then
		l___attach0__17.CFrame = p6 * CFrame.fromMatrix(v45, v24 / l__magnitude__34, u7(v24));
	else
		l___attach0__17.CFrame = p6 * CFrame.new(v45);
	end;
	if l__magnitude__34 > 1E-08 then
		l___attach1__18.CFrame = p6 * CFrame.fromMatrix(v46, v29 / l__magnitude__34, u7(v29));
	else
		l___attach1__18.CFrame = p6 * CFrame.new(v46);
	end;
	p5._t0 = l___t1__23;
	p5._v0 = v24;
	p5._p0 = l___p1__25;
	p5._t1 = v19;
	p5._v1 = v29;
	p5._p1 = v20;
	debug.profileend();
end;
function v1.setWidthTransparencyCurveSize(p11, p12, p13, p14, p15, p16)
	for v60, v61 in next, p11.beams do
		v61.Width0 = p12;
		v61.Width1 = p13;
		v61.CurveSize0 = p15;
		v61.CurveSize1 = p16;
		v61.Transparency = p14;
	end;
end;
table.freeze(v1);
return v1;

