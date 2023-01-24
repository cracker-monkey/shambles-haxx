
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("GuiInputInterface");
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2.textBox = p1;
	v2._value = 0;
	v2._minValue = 0;
	v2._maxValue = 1;
	v2._destructor:add(v2.textBox.FocusLost:connect(function()
		local v3 = tonumber(v2.textBox.Text);
		if not v3 then
			return;
		end;
		v2:setValue(v3);
	end));
	v2._destructor:add(u2.onReleased(v2.textBox, function()
		v2.textBox:CaptureFocus();
	end));
	v2._destructor:add(u2.onPressedOff(v2.textBox, function()
		v2.textBox:ReleaseFocus();
	end));
	return v2;
end;
function v1.Destroy(p2)
	p2._destructor:Destroy();
end;
function v1.setBounds(p3, p4, p5)
	if p5 < p4 then
		warn("ButtonSlider: Attempt to set bounds with minValue greater than maxValue", p4, p5);
		p5 = p4;
		p4 = p5;
	end;
	p3._minValue = p4;
	p3._maxValue = p5;
end;
function v1.setValue(p6, p7)
	p7 = math.min(p7, p6._maxValue);
	p7 = math.max(p6._minValue, p7);
	p6._value = p7;
	p6.onChanged:fire(p6._value);
end;
return v1;

