
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("TouchButtonObject");
local u3 = shared.require("TouchScreenGui").getScreenGui();
local u4 = shared.require("input");
function v1.new()
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._touchObject = u2.new(u3, {
		text = "Shoot", 
		position = UDim2.new(0, 40, 1, -200), 
		radius = 20, 
		group = "leftButton"
	});
	v2._destructor:add(v2._touchObject);
	v2._touchObject:setLayer(2);
	v2._shootMode = "released";
	v2._destructor:add(v2._touchObject.onReleased:connect(function()
		u4.touch.onshootreleased:fire();
	end));
	v2._destructor:add(v2._touchObject.onCancelled:connect(function()
		u4.touch.onshootreleased:fire();
	end));
	v2._destructor:add(v2._touchObject.onPressed:connect(function()
		u4.touch.onshootpressed:fire();
	end));
	return v2;
end;
function v1.Destroy(p1)
	p1._destructor:Destroy();
end;
function v1.getTouchObject(p2)
	return p2._touchObject;
end;
function v1.setShootMode(p3, p4)
	p3._shootMode = p4;
end;
function v1.fire(p5)
	print("TouchInputShoot: Shoot weapon");
end;
return v1;

