
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._currentCamera = workspace.CurrentCamera;
	v2._baseFov = 80;
	v2._targetCFrame = p1 and nil;
	return v2;
end;
function v1.Destroy(p2)
	p2._destructor:Destroy();
end;
function v1.step(p3)
	if p3._targetCFrame then
		p3._currentCamera.CFrame = p3._targetCFrame;
	end;
	p3._currentCamera.FieldOfView = p3._baseFov;
end;
return v1;

