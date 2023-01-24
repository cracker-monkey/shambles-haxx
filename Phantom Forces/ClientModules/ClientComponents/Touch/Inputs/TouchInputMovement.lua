
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("TouchJoystickObject");
local u3 = shared.require("TouchScreenGui");
local u4 = shared.require("ControlScript");
local u5 = shared.require("input");
function v1.new()
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._touchObject = u2.new(u3.getScreenGui(), UDim2.new(0, 0, 0, 0), UDim2.new(0.3, 0, 1, 0));
	v2._destructor:add(v2._touchObject);
	v2._touchObject:setLayer(1);
	v2._touchObject:setBaseRadius(30);
	v2._touchObject:setStaticMode(false);
	v2._touchObject:setFollowMode(false);
	v2._touchObject:setOrbitalMode(true);
	v2._touchObject:setBaseAnchor(Vector3.new(0.35, 0.7, 0));
	v2._destructor:add(v2._touchObject.onDragged:connect(function(p1, p2, p3)
		u4.addInputDirection(Vector3.new(p1, 0, -p2));
	end));
	v2._destructor:add(v2._touchObject.onOrbited:connect(function()
		u5.keyboard.onkeydown:fire("leftshift");
	end));
	v2._destructor:add(v2._touchObject.onDeorbited:connect(function()
		u5.keyboard.onkeyup:fire("leftshift");
	end));
	return v2;
end;
function v1.Destroy(p4)
	p4._destructor:Destroy();
end;
function v1.getTouchObject(p5)
	return p5._touchObject;
end;
return v1;

