
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = nil;
function v1.isCameraType(p1)
	return u1 == p1;
end;
function v1.getCameraType()
	return u1;
end;
local u2 = nil;
function v1.getActiveCamera(p2, p3)
	if p2 and p2 ~= u1 then
		warn("CameraInterface: Failed camera type check", p2, "- Current camera:", u1);
		warn(debug.traceback());
		if p3 then
			return;
		end;
		v1.setCameraType(p2);
	end;
	return u2;
end;
local u3 = nil;
local u4 = shared.require("CameraEvents");
function v1.setCameraType(p4, p5)
	local v2 = u3[p4];
	if not v2 then
		warn("CameraInterface: Attempt to set invalid cameraType", p4);
		return;
	end;
	if u2 then
		u2:Destroy();
		u2 = nil;
	end;
	u1 = p4;
	u2 = v2.new(p5);
	u4.onCameraTypeChanged:fire(u1, u2);
end;
local u5 = shared.require("ScreenCull");
local l__CurrentCamera__6 = workspace.CurrentCamera;
function v1.step(p6)
	if not u2 then
		return;
	end;
	u2:step(p6);
	u5.step(l__CurrentCamera__6.CFrame, l__CurrentCamera__6.ViewportSize, l__CurrentCamera__6.FieldOfView);
end;
function v1._init()
	workspace.CurrentCamera.CameraType = "Scriptable";
	u3 = {
		MainCamera = shared.require("MainCameraObject"), 
		MenuCamera = shared.require("MenuCameraObject"), 
		FreeCamera = shared.require("FreeCameraObject"), 
		FixedCamera = shared.require("FixedCameraObject"), 
		SpectateCamera = shared.require("SpectateCameraObject")
	};
	u4.onCameraTypeChangeForced:connect(v1.setCameraType);
	u5.step(l__CurrentCamera__6.CFrame, l__CurrentCamera__6.ViewportSize, l__CurrentCamera__6.FieldOfView);
end;
return v1;

