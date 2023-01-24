
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local l__UserInputService__2 = game:GetService("UserInputService");
local v3 = shared.require("MenuCameraConfig");
local v4 = shared.require("MenuCameraEvents");
local v5 = shared.require("Magnification");
local v6 = shared.require("Destructor");
local v7 = shared.require("effects");
local v8 = shared.require("spring");
local v9 = shared.require("Math");
local l__CurrentCamera__10 = workspace.CurrentCamera;
l__CurrentCamera__10.CameraType = "Scriptable";
local v11 = math.pi / 180;
function v1.new(p1)
	local v12 = setmetatable({}, v1);
	v12._destructor = v6.new();
	local v13 = p1 and p1.cameraCFrame or l__CurrentCamera__10.CFrame;
	v12._baseCFrameTarget = v13;
	v12._offsetCFrameTarget = CFrame.new();
	local v14, v15, v16, v17 = v9.quaternionFromCFrame(v13);
	v12._position = v13.p;
	v12._positionSpring = v8.new(v13.p, v3.positionSpringDamping, v3.positionSpringSpeed);
	v12._quaternionISpring = v8.new(Vector3.new(v15, v16, v17), v3.lookVectorSpringDamping, v3.lookVectorSpringSpeed);
	v12._quaternionRSpring = v8.new(v14, v3.lookVectorSpringDamping, v3.lookVectorSpringSpeed);
	v12._logTanSpring = v8.new(0);
	v12._logTanSpring.s = v3.lookVectorSpringSpeed;
	v7:setuplighting(false);
	return v12;
end;
function v1.Destroy(p2)
	p2._destructor:Destroy();
end;
function v1.setTarget(p3, p4)
	p3._baseCFrameTarget = p4;
end;
function v1.setFieldOfView(p5, p6)
	p5._logTanSpring.t = math.log(math.tan(p6 / 2));
end;
local u1 = math.tan(22.5 * v11);
local function u2(p7)
	return math.clamp(p7, 1, u1 / math.tan(0.5 * v11));
end;
function v1.setMagnification(p8, p9)
	p8._logTanSpring.t = math.log(u2(p9));
end;
function v1.changeFieldOfView(p10, p11)
	local v18 = p10._logTanSpring.t + p11;
	if v18 < 0 then
		local v19 = 0;
	else
		v19 = v18 < 3 and v18 or 3;
	end;
	p10._logTanSpring.t = v19;
end;
local l__math_atan__3 = math.atan;
local function u4(p12, p13)
	local l__magnitude__20 = p12.magnitude;
	local l__magnitude__21 = p13.magnitude;
	return CFrame.new(0, 0, 0, l__magnitude__21 * p12.y - l__magnitude__20 * p13.y, l__magnitude__20 * p13.x - l__magnitude__21 * p12.x, 0, l__magnitude__21 * p12.z + l__magnitude__20 * p13.z);
end;
function v1.zoom(p14, p15, p16)
	local v22 = nil;
	v22 = 2.718281828459045 ^ p14._logTanSpring.t;
	local v23 = math.clamp(2.718281828459045 ^ (p14._logTanSpring.t + p15), 1, u1 / math.tan(0.5 * v11));
	if p15 > 0 then
		local l__CurrentCamera__24 = workspace.CurrentCamera;
		l__CurrentCamera__24.CFrame = CFrame.new();
		l__CurrentCamera__24.FieldOfView = 2 / v11 * l__math_atan__3(u1 / v23);
		l__CurrentCamera__24.CFrame = l__CurrentCamera__24.CFrame;
		l__CurrentCamera__24.FieldOfView = l__CurrentCamera__24.FieldOfView;
		local l__CurrentCamera__25 = workspace.CurrentCamera;
		l__CurrentCamera__25.CFrame = p14._offsetCFrameTarget;
		l__CurrentCamera__25.FieldOfView = 2 / v11 * l__math_atan__3(u1 / v22);
		l__CurrentCamera__25.CFrame = l__CurrentCamera__25.CFrame;
		l__CurrentCamera__25.FieldOfView = l__CurrentCamera__25.FieldOfView;
		p14._offsetCFrameTarget = u4(l__CurrentCamera__24:ViewportPointToRay(p16.x, p16.y, 0).Direction.unit, l__CurrentCamera__25:ViewportPointToRay(p16.x, p16.y, 0).Direction.unit);
	elseif v22 > 1 then
		p14._offsetCFrameTarget = CFrame.identity:Lerp(p14._offsetCFrameTarget, (1 - 1 / v23) / (1 - 1 / v22));
	else
		p14._offsetCFrameTarget = CFrame.identity;
	end;
	p14._logTanSpring.t = math.log(v23);
end;
function v1.resetZoom(p17, p18)
	p17._offsetCFrameTarget = CFrame.identity;
	p17._logTanSpring.t = math.log(p18);
end;
function v1.step(p19)
	local v26 = p19._baseCFrameTarget * p19._offsetCFrameTarget;
	local v27, v28, v29, v30 = v9.quaternionFromCFrame(v26);
	p19._positionSpring.t = v26.p;
	if p19._quaternionRSpring.t * v27 + p19._quaternionISpring.t:Dot(Vector3.new(v28, v29, v30)) < 0 then
		v27 = -v27;
		v28 = -v28;
		v29 = -v29;
		v30 = -v30;
	end;
	p19._quaternionRSpring.t = v27;
	p19._quaternionISpring.t = Vector3.new(v28, v29, v30);
	local l__p__31 = p19._quaternionISpring.p;
	l__CurrentCamera__10.CFrame = CFrame.new(p19._positionSpring.p) * CFrame.new(0, 0, 0, l__p__31.x, l__p__31.y, l__p__31.z, p19._quaternionRSpring.p);
	l__CurrentCamera__10.FieldOfView = 2 / v11 * l__math_atan__3(u1 / 2.718281828459045 ^ p19._logTanSpring.p);
end;
return v1;

