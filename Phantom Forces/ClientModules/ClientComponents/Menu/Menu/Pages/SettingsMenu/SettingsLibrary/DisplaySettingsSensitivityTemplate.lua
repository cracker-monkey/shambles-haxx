
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("MenuUtils");
local u2 = shared.require("UISlider");
local u3 = shared.require("PlayerSettingsInterface");
local u4 = shared.require("PlayerSettingsEvents");
function v1.new(p1, p2, p3, p4, p5, p6, p7)
	local v2 = p1.Templates.ButtonSettingsSlider:Clone();
	u1.setText(v2.Title, string.upper(p3));
	local v3 = u2.new(v2.DisplaySlider, function(p8)
		return math.log(p8 / p5) / math.log(p6 / p5);
	end);
	v3:setBounds(0, 1);
	p2:add(v3);
	p2:add(v3.onChanged:connect(function(p9)
		local v4 = p5 ^ (1 - p9) * p6 ^ p9;
		local v5 = 0.001 and 1;
		v3.sliderMain.TextBox.Text = string.format("%.3f", v4 + v5 / 2 - (v4 + v5 / 2) % v5);
	end));
	p2:add(v3.onDragEnded:connect(function(p10)
		local v6 = p5 ^ (1 - p10) * p6 ^ p10;
		local v7 = 0.001 and 1;
		v3.sliderMain.TextBox.Text = string.format("%.3f", v6 + v7 / 2 - (v6 + v7 / 2) % v7);
		u3.setValue(p4, p10 * 100);
		u4.onSensitivityChanged:fire(p4, p5 ^ (1 - p10) * p6 ^ p10);
	end));
	local v8 = u3.getValue(p4);
	if v8 == nil then
		u3.setValue(p4, p7);
	end;
	v3:setValue((v8 and p7) / 100);
	local v9 = (v8 and p7) / 100;
	u4.onSensitivityChanged:fire(p4, p5 ^ (1 - v9) * p6 ^ v9);
	return v2;
end;
return v1;

