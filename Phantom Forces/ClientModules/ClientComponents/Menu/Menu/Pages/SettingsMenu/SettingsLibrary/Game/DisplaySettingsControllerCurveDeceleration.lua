
-- Decompiled with the Synapse X Luau decompiler.

local u1 = shared.require("MenuUtils");
local u2 = shared.require("UISlider");
local u3 = shared.require("PlayerSettingsInterface");
return function(p1, p2)
	local v1 = p1.Templates.ButtonSettingsSlider:Clone();
	u1.setText(v1.Title, string.upper("Controller Curve Deceleration"));
	local v2 = u2.new(v1.DisplaySlider);
	v2:setBounds(0, 2);
	p2:add(v2);
	p2:add(v2.onChanged:connect(function(p3)
		v2.sliderMain.TextBox.Text = math.round(p3 * 100) / 100;
	end));
	p2:add(v2.onDragEnded:connect(function(p4)
		p4 = math.round(p4 * 100) / 100;
		v2.sliderMain.TextBox.Text = math.round(p4 * 100) / 100;
		u3.setValue("controllercurvedecel", p4);
	end));
	local v3 = u3.getValue("controllercurvedecel");
	if v3 == nil then
		u3.setValue("controllercurvedecel", 0.5);
	end;
	v2:setValue(v3 and 0.5);
	return v1;
end;

