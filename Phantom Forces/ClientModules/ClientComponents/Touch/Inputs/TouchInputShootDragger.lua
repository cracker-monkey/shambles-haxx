
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
		position = UDim2.new(1, -250, 1, -250), 
		radius = 20, 
		group = "touchDragger"
	});
	v2._touchObject:setDraggable(true);
	v2._destructor:add(v2._touchObject);
	v2._touchObject:setLayer(2);
	v2._shootMode = "released";
	v2._destructor:add(v2._touchObject.onReleased:connect(function()
		u4.touch.onshootreleased:fire();
	end));
	v2._destructor:add(v2._touchObject.onPressed:connect(function()
		u4.touch.onshootpressed:fire();
	end));
	v2._destructor:add(v2._touchObject.onDragged:connect(function(p1, p2)
		u4.touch.onlookmove:fire(Vector3.new(p1, -p2, 0) * 0.5);
	end));
	return v2;
end;
function v1.Destroy(p3)
	p3._destructor:Destroy();
end;
function v1.getTouchObject(p4)
	return p4._touchObject;
end;
function v1.setShootMode(p5, p6)
	p5._shootMode = p6;
end;
return v1;

