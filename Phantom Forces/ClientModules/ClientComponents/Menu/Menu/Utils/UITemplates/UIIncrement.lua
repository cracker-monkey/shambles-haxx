
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("GuiInputInterface");
local u3 = shared.require("Event");
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2.incrementMain = p1;
	v2.container = v2.incrementMain.Container;
	v2.leftFrame = v2.container.LeftFrame;
	v2.rightFrame = v2.container.RightFrame;
	v2._value = 0;
	v2._minValue = 0;
	v2._maxValue = 1;
	v2._increment = 1;
	v2._destructor:add(u2.onReleased(v2.leftFrame, function(p2)
		v2:_updateValue(p2, -1);
	end));
	v2._destructor:add(u2.onReleased(v2.rightFrame, function(p3)
		v2:_updateValue(p3, 1);
	end));
	v2.onChanged = u3.new();
	return v2;
end;
function v1.Destroy(p4)
	p4._destructor:Destroy();
end;
function v1.getValue(p5)
	return p5._value;
end;
function v1.setBounds(p6, p7, p8, p9)
	if p8 < p7 then
		warn("UIIncrement: Attempt to set bounds with minValue greater than maxValue", p7, p8);
		p8 = p7;
		p7 = p8;
	end;
	p6._minValue = p7;
	p6._maxValue = p8;
end;
function v1.setValue(p10, p11, p12)
	local v3 = math.max(p10._minValue, (math.min(p11, p10._maxValue)));
	if v3 ~= p11 then
		return;
	end;
	p10._value = v3;
	p10.onChanged:fire(p10._value, not p12);
end;
function v1._updateValue(p13, p14, p15)
	p13:setValue(p13._value + p15 * p13._increment, true);
end;
return v1;

