
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("GuiInputInterface");
local u3 = shared.require("Event");
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2.guiObject = p1;
	v2.checkBox = v2.guiObject.CheckBox;
	v2._value = true;
	v2._destructor:add(u2.onReleased(v2.guiObject, function(p2)
		v2:setValue(not v2._value, true);
	end));
	v2.onChanged = u3.new();
	return v2;
end;
function v1.Destroy(p3)
	p3._destructor:Destroy();
end;
function v1.getValue(p4)
	return p4._value;
end;
function v1.setValue(p5, p6, p7)
	p5._value = p6;
	p5.onChanged:fire(p5._value, not p7);
end;
return v1;

