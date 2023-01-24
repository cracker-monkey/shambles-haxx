
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local l__CurrentCamera__2 = workspace.CurrentCamera;
l__CurrentCamera__2.CameraType = "Scriptable";
local u1 = shared.require("Destructor");
local u2 = shared.require("FreeCameraConfig");
local u3 = shared.require("Math");
local u4 = shared.require("spring");
local l__Vector3_zero__5 = Vector3.zero;
local u6 = shared.require("Magnification");
local u7 = shared.require("BlurSuppression");
local u8 = shared.require("LockMouse");
local l__UserInputService__9 = game:GetService("UserInputService");
function v1.new(p1)
	local v3 = setmetatable({}, v1);
	v3._destructor = u1.new();
	v3._baseSpeed = u2.baseSpeed;
	v3._slowSpeed = u2.slowSpeed;
	v3._moveDirections = u2.moveDirections;
	v3._baseFieldOfView = u2.baseFieldOfView;
	v3._lastStep = 0;
	v3._targetCFrame = nil;
	local v4 = p1 and p1.cameraCFrame or l__CurrentCamera__2.CFrame;
	v3._position = v4.p;
	v3._lookVector = Vector3.new(u3.anglesYXZfromLookVector(v4.lookVector));
	v3._positionSpring = u4.new(v3._position, 1.5, 15);
	v3._lookVectorSpring = u4.new(v3._lookVector, 1.5, 30);
	v3._cameraSpeedSpring = u4.new(v3._baseSpeed, 0.75, 15);
	v3._targetPositionSpring = u4.new(l__Vector3_zero__5, 0.75, 5);
	v3._targetLookVectorSpring = u4.new(l__Vector3_zero__5, 0.9, 5);
	v3._targetFieldOfViewSpring = u4.new(v3._baseFieldOfView, 0.9, 5);
	v3._magnificationObject = u6.new();
	v3._destructor:add(v3._magnificationObject);
	v3._blurObject = u7.new();
	v3._destructor:add(v3._blurObject);
	v3._cinematicMode = true;
	v3._lockMouse = u8.new();
	v3._destructor:add(v3._lockMouse);
	v3._sensitivity = u2.sensitivity;
	v3._keyDown = {};
	v3._destructor:add(l__UserInputService__9.InputBegan:connect(function(p2, p3)
		if p3 then
			return;
		end;
		v3._keyDown[p2.KeyCode.Name] = true;
	end));
	v3._destructor:add(l__UserInputService__9.InputEnded:connect(function(p4)
		v3._keyDown[p4.KeyCode.Name] = false;
	end));
	v3._destructor:add(l__UserInputService__9.InputChanged:connect(function(p5)
		l__UserInputService__9.MouseBehavior = Enum.MouseBehavior.LockCenter;
		l__UserInputService__9.MouseIconEnabled = false;
		if p5.UserInputType.Name == "MouseMovement" then
			local l__delta__5 = p5.delta;
			v3:updateLookAngles(v3._sensitivity, l__delta__5.x, l__delta__5.y);
		end;
	end));
	return v3;
end;
function v1.Destroy(p6)
	p6._destructor:Destroy();
end;
function v1.isKeyDown(p7, p8)
	return p7._keyDown[p8];
end;
function v1.getBlurObject(p9)
	return p9._blurObject;
end;
function v1.getMagnificationObject(p10)
	return p10._magnificationObject;
end;
function v1.computeSuppressionMultiplier(p11)
	return 1 - (1 - p11._suppressionMultiplier0) * math.exp(-(tick() - p11._suppressionTick0) * p11._suppressionFactor);
end;
function v1.setTarget(p12, p13)
	p12._targetCFrame = p13;
	p12._targetPositionSpring.p = p12._position;
	p12._targetLookVectorSpring.p = p12._lookVector;
	p12._targetPositionSpring.t = p13.p;
	p12._targetLookVectorSpring.t = Vector3.new(u3.anglesYXZfromLookVector(p13.lookVector));
end;
function v1.updateLookAngles(p14, p15, p16, p17)
	if p14._targetCFrame then
		return;
	end;
	p14._lookVector = Vector3.new(p14._lookVector.x - p15 * p17, p14._lookVector.y - p15 * p16, p14._lookVector.z);
end;
function v1.step(p18)
	local v6 = tick();
	if p18._targetCFrame then
		local l__p__7 = p18._targetPositionSpring.p;
		local l__p__8 = p18._targetLookVectorSpring.p;
		p18._positionSpring.t = l__p__7;
		p18._lookVectorSpring.t = l__p__8;
		p18._position = l__p__7;
		p18._lookVector = l__p__8;
		if (p18._targetPositionSpring.t - p18._targetPositionSpring.p).Magnitude < 0.01 and (p18._targetLookVectorSpring.t - p18._targetLookVectorSpring.p).Magnitude < 0.01 then
			p18._targetCFrame = nil;
		end;
	else
		local v9 = l__Vector3_zero__5;
		for v10, v11 in next, p18._moveDirections do
			if p18._input:isKeyDown(v10) then
				v9 = v9 + v11;
			end;
		end;
		if p18._input:isKeyDown("LeftShift") then
			p18._cameraSpeedSpring.t = p18._slowSpeed;
		else
			p18._cameraSpeedSpring.t = p18._baseSpeed;
		end;
		local v12 = u3.safeUnit(v9) * p18._cameraSpeedSpring.p * (v6 - p18._lastStep);
		if v12.Magnitude > 0 then
			p18._magnificationObject:resetSprings();
			p18._magnificationObject:setMagnification(1);
		end;
		local l___lookVector__13 = p18._lookVector;
		local l___position__14 = p18._position;
		p18._position = ((CFrame.fromEulerAnglesYXZ(l___lookVector__13.x, l___lookVector__13.y, l___lookVector__13.z) + l___position__14) * CFrame.new(v12)).p;
		p18._positionSpring.t = l___position__14;
		p18._lookVectorSpring.t = l___lookVector__13;
	end;
	local l__p__15 = p18._lookVectorSpring.p;
	l__CurrentCamera__2.CFrame = CFrame.new(p18._positionSpring.p) * CFrame.fromEulerAnglesYXZ(l__p__15.x, l__p__15.y, l__p__15.z);
	if p18._cinematicMode then
		p18._blurObject:step();
	end;
	l__CurrentCamera__2.FieldOfView = p18._magnificationObject:getFieldOfView();
	p18._lastStep = v6;
end;
return v1;

