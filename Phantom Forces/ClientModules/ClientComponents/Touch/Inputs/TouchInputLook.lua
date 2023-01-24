
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("TouchFieldObject");
local u3 = shared.require("TouchScreenGui").getScreenGui();
local u4 = shared.require("input");
function v1.new()
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._touchObject = u2.new(u3, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0));
	v2._destructor:add(v2._touchObject);
	v2._touchObject:setLayer(0);
	v2._destructor:add(v2._touchObject.onDragged:connect(function(p1, p2)
		u4.touch.onlookmove:fire(Vector3.new(p1, -p2, 0));
	end));
	return v2;
end;
function v1.Destroy(p3)
	p3._destructor:Destroy();
end;
function v1.getTouchObject(p4)
	return p4._touchObject;
end;
return v1;

