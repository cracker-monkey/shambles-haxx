
-- Decompiled with the Synapse X Luau decompiler.

local u1 = shared.require("MenuUtils");
local u2 = shared.require("UISlider");
local u3 = shared.require("PlayerSettingsInterface");
return function(p1, p2)
	local v1 = p1.Templates.ButtonSettingsSlider:Clone();
	u1.setText(v1.Title, string.upper("Controller Deadzone"));
	local v2 = u2.new(v1.DisplaySlider);
	v2:setBounds(0, 0.8);
	p2:add(v2);
	p2:add(v2.onChanged:connect(function(p3)
		v2.sliderMain.TextBox.Text = math.round(p3 * 100) / 100;
	end));
	p2:add(v2.onDragEnded:connect(function(p4)
		p4 = math.round(p4 * 100) / 100;
		v2.sliderMain.TextBox.Text = math.round(p4 * 100) / 100;
		u3.setValue("controllerdeadzone", p4);
	end));
	local v3 = u3.getValue("controllerdeadzone");
	if v3 == nil then
		u3.setValue("controllerdeadzone", 0.25);
	end;
	v2:setValue(v3 and 0.25);
	return v1;
end;

