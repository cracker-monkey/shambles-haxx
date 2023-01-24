
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("PlayerSettingsInterface");
local v3 = shared.require("PlayerSettingsEvents");
local v4 = shared.require("GyroService");
local v5 = shared.require("CameraUtils");
local v6 = shared.require("cframe");
local v7 = shared.require("vector");
local l__LocalPlayer__8 = game:GetService("Players").LocalPlayer;
local u1 = shared.require("Destructor");
local l__math_pi__2 = math.pi;
local u3 = shared.require("spring");
local u4 = shared.require("RecoilSpringLayers");
local u5 = shared.require("input");
local u6 = {
	sensitivity = v2.getValue("looksens"), 
	aimSensitivity = v2.getValue("aimsens"), 
	controllerSens = v2.getValue("controllerlooksens"), 
	controllerAimSens = v2.getValue("controlleraimsens"), 
	controllerAccel = v2.getValue("controllerlookaccel"), 
	controlleraimaccel = v2.getValue("controlleraimaccel"), 
	controllerSenspower = v2.getValue("controllersenspower"), 
	controlleryMult = v2.getValue("controllerverticalmult")
};
local u7 = math.pi / 180;
function v1.new(p1)
	local v9 = setmetatable({}, v1);
	v9._destructor = u1.new();
	v9._currentCamera = workspace.CurrentCamera;
	v9._baseFov = 80;
	v9._maxAngle = 0.496875 * l__math_pi__2;
	v9._minAngle = -0.496875 * l__math_pi__2;
	v9._delta = Vector3.zero;
	v9._cframe = CFrame.new();
	v9._angles = Vector3.zero;
	v9._lookVector = Vector3.new(0, 0, -1);
	v9._lookDt = 0.016666666666666666;
	v9._swayT = 0;
	v9._offset = Vector3.new(0, 1.5, 0);
	v9._baseCFrame = CFrame.new();
	v9._shakeCFrame = CFrame.new();
	if v2.getValue("toggleinvertyaxis") then
		local v10 = -1;
	else
		v10 = 1;
	end;
	v9._xInvert = v10;
	v9._didChange = false;
	v9._directLook = false;
	v9._gyroAiming = false;
	v9._directLookEnabled = v2.getValue("togggledirectangularinput");
	v9._curveDecelRate = v2.getValue("controllercurvedecel");
	v9._lastDeathCFrame = nil;
	v9._prevControllerDelta = Vector3.zero;
	v9._controllerUsed = false;
	v9._controllerSpeed = 0;
	v9._sensitivityMult = 1;
	v9._controllerAimMult = 1;
	v9._magSpring = u3.new(0);
	v9._magSpring.s = 12;
	v9._magSpring.d = 1;
	v9._swaySpring = u3.new(0);
	v9._swaySpring.s = 4;
	v9._swaySpring.d = 1;
	v9._swaySpeed = u3.new(0);
	v9._swaySpeed.s = 6;
	v9._swaySpeed.d = 1;
	v9._swaySpeed.t = 1;
	v9._shakeSpring = u3.new(Vector3.zero);
	v9._shakeSpring.s = 12;
	v9._shakeSpring.d = 0.65;
	v9._zAngleSpring = u3.new(0);
	v9._zAngleSpring.s = 8;
	v9._offsetSpring = u3.new(Vector3.zero);
	v9._offsetSpring.s = 16;
	v9._suppressionSpring = u3.new(Vector3.zero);
	v9._suppressionSpring.s = 32;
	v9._suppressionSpring.d = 0.65;
	v9._damageSpring = u3.new(Vector3.zero);
	v9._damageSpring.s = 20;
	v9._damageSpring.d = 0.75;
	v9._accelSpring = u3.new(Vector3.zero);
	v9._accelSpring.s = 10;
	v9._accelSpring.d = 0.8;
	v9._publicSprings = {
		suppressionspring = v9._suppressionSpring, 
		zanglespring = v9._zAngleSpring, 
		offsetspring = v9._offsetSpring, 
		damagespring = v9._damageSpring, 
		shakespring = v9._shakeSpring, 
		accelSpring = v9._accelSpring, 
		swayspring = v9._swaySpring, 
		magspring = v9._magSpring, 
		swayspeed = v9._swaySpeed
	};
	v9._bodyRecoil = u4.new({
		x = { { 1, 1, 0, 0 } }, 
		y = { { 1, 1, 0, 0 } }, 
		z = { { 1, 1, 0, 0 } }
	}, {
		x = { { 1, 1, 0, 0 } }, 
		y = { { 1, 1, 0, 0 } }, 
		z = { { 1, 1, 0, 0 } }
	});
	v9._destructor:add(u5.touch.onlookmove:connect(function(p2)
		v9._didChange = true;
		local v11 = 4 * u6.sensitivity * v9._sensitivityMult / (32 * l__math_pi__2);
		if v9._directLookEnabled and v9._directLook then
			local v12 = v11 * math.atan(math.tan(v9._baseFov * u7 / 2) / 2.718281828459045 ^ v9._magSpring.p);
			local v13 = Vector3.new(-v12 * p2.y * v9._xInvert, -v12 * p2.x, 0);
		else
			local v14 = v11 * math.atan(math.tan(v9._baseFov * u7 / 2) / 2.718281828459045 ^ v9._magSpring.p);
			local v15 = math.cos(v9._angles.x);
			v13 = Vector3.new(-v14 * p2.y * v9._xInvert, -(v14 * (1 - (1 - v15) ^ (v11 * math.atan(math.tan(v9._baseFov * u7 / 2)) / v14)) / v15) * p2.x, 0);
		end;
		v9:_applyLookDelta(v13);
	end));
	v9._destructor:add(v4.rotationChanged:connect(function(p3, p4)
		if v9._gyroAiming then
			print("gyroaimang");
			v9:_applyLookDelta(math.atan(math.tan(v9._baseFov * u7 / 2) / 2.718281828459045 ^ v9._magSpring.p) / (v9._baseFov * u7 / 2) * Vector3.new(1, 1, 0) * p4);
		end;
	end));
	v9._destructor:add(u5.mouse.onmousemove:connect(function(p5)
		v9._didChange = true;
		local v16 = u6.sensitivity * v9._sensitivityMult / (32 * l__math_pi__2);
		if v9._directLookEnabled and v9._directLook then
			local v17 = v16 * math.atan(math.tan(v9._baseFov * u7 / 2) / 2.718281828459045 ^ v9._magSpring.p);
			local v18 = Vector3.new(-v17 * p5.y * v9._xInvert, -v17 * p5.x, 0);
		else
			local v19 = v16 * math.atan(math.tan(v9._baseFov * u7 / 2) / 2.718281828459045 ^ v9._magSpring.p);
			local v20 = math.cos(v9._angles.x);
			v18 = Vector3.new(-v19 * p5.y * v9._xInvert, -(v19 * (1 - (1 - v20) ^ (v16 * math.atan(math.tan(v9._baseFov * u7 / 2)) / v19)) / v20) * p5.x, 0);
		end;
		v9:_applyLookDelta(v18);
	end));
	v9._destructor:add(u5.controller.onintegralmove:connect(function(p6, p7)
		local v21 = nil;
		if p6 ~= Vector3.zero then
			v9._controllerUsed = true;
			v9._didChange = true;
		end;
		p6 = p6.magnitude ^ (u6.controllerSenspower - 1) * p6;
		local v22 = 15 * p7 * u6.controllerSens * v9._controllerAimMult * math.atan(math.tan(v9._baseFov * u7 / 2) / 2.718281828459045 ^ v9._magSpring.p);
		local v23 = math.abs(math.atan2(v9._prevControllerDelta:Cross(p6).z, (v9._prevControllerDelta:Dot(p6))));
		v21 = v9._prevControllerDelta.magnitude;
		local l__magnitude__24 = p6.magnitude;
		if v23 * v9._curveDecelRate == 0 then
			local v25 = v21 + p7 * l__magnitude__24 * u6.controllerAccel;
		else
			local v26 = p7 * l__magnitude__24 * u6.controllerAccel / (v23 * v9._curveDecelRate);
			v25 = v26 + math.exp(-v23 * v9._curveDecelRate) * (v21 - v26);
		end;
		if l__magnitude__24 == 0 then
			v9._prevControllerDelta = Vector3.zero;
		elseif v25 < 0 then
			v9._prevControllerDelta = Vector3.zero;
		elseif v25 < p6.magnitude then
			v9._prevControllerDelta = v25 * p6.unit;
		else
			v9._prevControllerDelta = p6;
		end;
		v9:_applyLookDelta((Vector3.new(u6.controlleryMult * v22 * v9._prevControllerDelta.y * v9._xInvert, -v22 * v9._prevControllerDelta.x, 0)));
	end));
	v9._destructor:add(v3.onSettingChanged:connect(function(p8, p9)
		if p8 == "toggleinvertyaxis" then
			if p9 then
				local v27 = -1;
			else
				v27 = 1;
			end;
			v9._xInvert = v27;
			return;
		end;
		if p8 == "togggledirectangularinput" then
			v9._directLookEnabled = p9;
			return;
		end;
		if p8 == "controllercurvedecel" then
			v9._curveDecelRate = p9;
		end;
	end));
	v9._currentCamera.FieldOfView = v9._baseFov;
	if p1 then
		v9._currentCamera.CameraSubject = p1.cameraSubject;
		if p1.direction then
			v9:setLookVector(p1.direction);
		end;
	end;
	v9._currentCamera.CameraType = "Scriptable";
	return v9;
end;
function v1.Destroy(p10)
	print("Destroying");
	p10._destructor:Destroy();
end;
function v1.getDelta(p11)
	return p11._delta;
end;
function v1.getAngles(p12)
	return p12._angles;
end;
function v1.getCFrame(p13)
	return p13._cframe;
end;
function v1.getLookVector(p14)
	return p14._lookVector;
end;
function v1.getBaseCFrame(p15)
	return p15._baseCFrame;
end;
function v1.getShakeCFrame(p16)
	return p16._shakeCFrame;
end;
function v1.getBaseFov(p17)
	return p17._baseFov;
end;
function v1.getSpring(p18, p19)
	return p18._publicSprings[p19];
end;
function v1.applyImpulse(p20)
	p20._bodyRecoil:applyImpulse();
end;
function v1.setBodyRecoil(p21, ...)
	p21._bodyRecoil = u4.new(...);
end;
function v1.setAim(p22, p23)
	p22._bodyRecoil:setAim(p23);
end;
function v1.magnify(p24, p25)
	p24._magSpring.t = math.log(p25);
end;
function v1.hit(p26, p27)
	local v28 = p26._cframe:VectorToObjectSpace(p27);
	p26._damageSpring.a = Vector3.new(v28.z, 0, -v28.x) * 0.25;
end;
function v1.shake(p28, p29)
	p28._shakeSpring.a = p29;
end;
function v1.setMagnification(p30, p31)
	local v29 = math.log(p31);
	p30._magSpring.p = v29;
	p30._magSpring.t = v29;
	p30._magSpring.v = 0;
end;
function v1.setAimSensitivity(p32, p33)
	p32._sensitivityMult = p33 and u6.aimSensitivity or 1;
	p32._controllerAimMult = p33 and u6.controllerAimSens or 1;
end;
function v1.setMagnificationSpeed(p34, p35)
	p34._magSpring.s = p35;
end;
function v1.setSwaySpeed(p36, p37)
	p36._swaySpeed.t = p37 and 1;
end;
function v1.setSway(p38, p39)
	p38._swaySpring.t = p39;
end;
function v1.setGyroAim(p40, p41)
	p40._gyroAiming = p41;
end;
function v1.setSuppression(p42, p43)
	p42._suppressionSpring.a = p43;
end;
function v1.setControllerAimMult(p44, p45)
	p44._controllerAimMult = p45;
end;
function v1.setDirectLookMode(p46, p47)
	if p46._directLook == p47 then
		return;
	end;
	p46._directLook = p47;
	if not p47 then
		p46._offsetSpring.t = Vector3.zero;
	end;
end;
local u8 = 2 * math.pi;
function v1.setLookVector(p48, p49)
	p48._didChange = true;
	local v30, v31 = v7.toanglesyx(p49);
	local l__y__32 = p48._angles.y;
	local v33 = Vector3.new(p48._maxAngle < v30 and p48._maxAngle or (v30 < p48._minAngle and p48._minAngle or v30), (v31 + l__math_pi__2 - l__y__32) % u8 - l__math_pi__2 + l__y__32, 0);
	p48._delta = (v33 - p48._angles) / p48._lookDt;
	p48._angles = v33;
end;
local u9 = nil;
function v1.step(p50, p51)
	p50._lookDt = p51;
	if p50._didChange then
		p50._delta = Vector3.zero;
		p50._didChange = false;
	end;
	if p50._controllerUsed then
		p50._controllerUsed = false;
	else
		p50._controllerSpeed = 0;
	end;
	if not u9.isAlive() then
		return;
	end;
	local v34 = u9.getCharacterObject();
	local l__CFrame__35 = v34:getRootPart().CFrame;
	local v36 = Vector3.new(0, v34._headheightspring.p, 0);
	p50._accelSpring.t = v34._acceleration;
	p50._swayT = p50._swayT + p51 * p50._swaySpeed.p;
	local l___swayT__37 = p50._swayT;
	local v38 = 0.5 * v34._speed;
	local v39 = v34._distance * u8 / 4 * 3 / 4;
	local l__p__40 = p50._swaySpring.p;
	local v41 = CFrame.Angles(0, p50._angles.y, 0) * CFrame.Angles(p50._angles.x, 0, 0) * v6.fromaxisangle(p50._offsetSpring.p) * CFrame.Angles(0, 0, p50._zAngleSpring.p);
	p50._baseCFrame = v41 + l__CFrame__35 * v36;
	local v42 = v41 * v6.fromaxisangle(p50._bodyRecoil:getPosition()) * v6.fromaxisangle(p50._shakeSpring.p) * v6.fromaxisangle(v38 * math.cos(v39 + 2) / 2048, v38 * math.cos(v39 / 2) / 2048, v38 * math.cos(v39 / 2 + 2) / 4096) * v6.fromaxisangle(l__p__40 * math.cos(2 * l___swayT__37 + 2) / 2048, l__p__40 * math.cos(2 * l___swayT__37 / 2) / 2048, l__p__40 * math.cos(2 * l___swayT__37 / 2 - 2) / 4096);
	local v43 = v42 * v6.fromaxisangle(Vector3.new(0, 0, 1):Cross(p50._accelSpring.v / 4096 / 16) * Vector3.new(1, 0, 0)) * v6.fromaxisangle(p50._suppressionSpring.p + p50._damageSpring.p) + l__CFrame__35 * v36;
	p50._currentCamera.FieldOfView = 2 * math.atan(math.tan(p50._baseFov * u7 / 2) / 2.718281828459045 ^ p50._magSpring.p) / u7;
	p50._currentCamera.CFrame = v43;
	p50._shakeCFrame = v42 + l__CFrame__35 * v36;
	p50._cframe = v43;
	p50._lookVector = v43.lookVector;
	p50._bodyRecoil:step();
end;
function v1._applyLookDelta(p52, p53)
	if not p52._directLookEnabled or not p52._directLook then
		local v44 = p52._angles.y + p53.y;
		local v45 = math.clamp(p52._angles.x + p53.x, p52._minAngle, p52._maxAngle);
		p52._delta = v5.getOffsetAxisAngle(CFrame.Angles(0, p52._angles.y, 0) * CFrame.Angles(p52._angles.x, 0, 0) * v6.fromaxisangle(p52._offsetSpring.p), CFrame.Angles(0, v44, 0) * CFrame.Angles(v45, 0, 0) * v6.fromaxisangle(p52._offsetSpring.p)) / p52._lookDt;
		p52._angles = Vector3.new(v45, v44, 0);
		return;
	end;
	local l__p__46 = p52._zAngleSpring.p;
	local v47 = CFrame.Angles(0, p52._angles.y, 0) * CFrame.Angles(p52._angles.x, 0, 0) * v6.fromaxisangle(p52._offsetSpring.p) * v6.fromaxisangle(p53);
	local v48, v49 = v5.limitAnglesYX(v47, p52._minAngle, p52._maxAngle);
	local v50 = v5.getClosestAngle(p52._angles.y, v49);
	p52._delta = p53 / p52._lookDt;
	p52._angles = Vector3.new(v48, v50, 0);
	local v51 = v5.getOffsetAxisAngle(CFrame.Angles(0, v50, 0) * CFrame.Angles(v48, 0, 0), v47);
	p52._offsetSpring.p = v51;
	p52._offsetSpring.t = v51;
end;
function v1._init()
	u9 = shared.require("CharacterInterface");
	v3.onSensitivityChanged:connect(function(p54, p55)
		if p54 == "looksens" then
			u6.sensitivity = p55;
			return;
		end;
		if p54 == "aimsens" then
			u6.aimSensitivity = p55;
			return;
		end;
		if p54 == "controllerlooksens" then
			u6.controllerSens = p55;
			return;
		end;
		if p54 == "controllersenspower" then
			u6.controllerSenspower = p55;
			return;
		end;
		if p54 == "controlleraimsens" then
			u6.controllerAimSens = p55;
			return;
		end;
		if p54 == "controllerverticalmult" then
			u6.controlleryMult = p55;
			return;
		end;
		if p54 == "controllerlookaccel" then
			u6.controllerAccel = p55;
			return;
		end;
		if p54 == "controlleraimaccel" then
			u6.controlleraimaccel = p55;
		end;
	end);
end;
return v1;

