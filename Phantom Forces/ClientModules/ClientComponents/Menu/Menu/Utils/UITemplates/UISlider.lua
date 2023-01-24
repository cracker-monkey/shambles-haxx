
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("Event");
local u3 = shared.require("GuiInputInterface");
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2.sliderMain = p1;
	v2.sliderBar = v2.sliderMain.SliderBar;
	v2.sliderBarValue = v2.sliderBar.SliderBarValue;
	v2.onChanged = u2.new();
	v2.onDragEnded = u2.new();
	v2._value = 0;
	v2._minValue = 0;
	v2._maxValue = 1;
	v2._destructor:add(u3.onDragged(v2.sliderBar, function(p3)
		v2:_updateValue(p3:getInputPosition(), true);
	end));
	v2._destructor:add(u3.onDragEnded(v2.sliderBar, function(p4)
		v2:_updateValue((p4:getInputPosition()));
		v2.onDragEnded:fire(v2._value);
	end));
	if v2.sliderMain:FindFirstChild("TextBox") then
		v2.sliderTextBox = v2.sliderMain.TextBox;
		v2._destructor:add(v2.sliderTextBox.FocusLost:connect(function()
			local v3 = tonumber(v2.sliderTextBox.Text);
			if v3 and p2 then
				v3 = p2(v3);
			end;
			if not v3 then
				v2.onChanged:fire(v2._value);
				return;
			end;
			v2:setValue(v3);
			v2.onDragEnded:fire(v2._value);
		end));
		v2._destructor:add(u3.onReleased(v2.sliderTextBox, function()
			v2.sliderTextBox:CaptureFocus();
		end));
		v2._destructor:add(u3.onPressedOff(v2.sliderTextBox, function()
			v2.sliderTextBox:ReleaseFocus();
		end));
	end;
	return v2;
end;
function v1.Destroy(p5)
	p5._destructor:Destroy();
end;
function v1.getValue(p6)
	return p6._value;
end;
function v1.setBounds(p7, p8, p9)
	if p9 < p8 then
		warn("UISlider: Attempt to set bounds with minValue greater than maxValue", p8, p9);
		p9 = p8;
		p8 = p9;
	end;
	p7._minValue = p8;
	p7._maxValue = p9;
end;
function v1.setValue(p10, p11)
	p11 = math.min(p11, p10._maxValue);
	p11 = math.max(p10._minValue, p11);
	p10.sliderBarValue.Size = UDim2.fromScale((p11 - p10._minValue) / (p10._maxValue - p10._minValue), 1);
	p10._value = p11;
	p10.onChanged:fire(p10._value);
end;
function v1._updateValue(p12, p13, p14)
	local v4 = math.max(0, (math.min(math.max(p13 - p12.sliderBar.AbsolutePosition.X, 0) / p12.sliderBar.AbsoluteSize.X, 1)));
	p12.sliderBarValue.Size = UDim2.fromScale(v4, 1);
	p12._value = p12._minValue + (p12._maxValue - p12._minValue) * v4;
	local v5 = false;
	if p12._value ~= p12._value then
		v5 = p14;
	end;
	p12.onChanged:fire(p12._value, v5);
end;
return v1;

