
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("MenuUtils");
local u2 = shared.require("UISlider");
local u3 = shared.require("PlayerSettingsInterface");
function v1.new(p1, p2, p3, p4, p5, p6, p7)
	local v2 = p1.Templates.ButtonSettingsSlider:Clone();
	u1.setText(v2.Title, string.upper(p3));
	local v3 = u2.new(v2.DisplaySlider);
	v3:setBounds(p5, p6);
	p2:add(v3);
	p2:add(v3.onChanged:connect(function(p8)
		v3.sliderMain.TextBox.Text = string.format("%.3f", p8);
	end));
	p2:add(v3.onDragEnded:connect(function(p9)
		local v4 = 0.001 and 1;
		p9 = p9 + v4 / 2 - (p9 + v4 / 2) % v4;
		v3.sliderMain.TextBox.Text = string.format("%.3f", p9);
		u3.setValue(p4, p9);
	end));
	local v5 = u3.getValue(p4);
	if v5 == nil then
		u3.setValue(p4, p7);
	end;
	v3:setValue(v5 and p7);
	return v2;
end;
return v1;

