
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("MenuUtils");
local u2 = shared.require("UIIncrement");
local u3 = shared.require("PlayerSettingsInterface");
function v1.new(p1, p2, p3, p4, p5, p6, p7)
	local v2 = p1.Templates.ButtonSettingsIncrement:Clone();
	u1.setText(v2.Title, string.upper(p3));
	local v3 = u2.new(v2.DisplayIncrement);
	v3:setBounds(p5, p6, 1);
	p2:add(v3);
	local function u4(p8)
		u1.setText(v3.incrementMain, p8 .. " ms");
		u1.setImageColor3(v3.leftFrame, p5 < p8 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5));
		u1.setImageColor3(v3.rightFrame, p8 < p6 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5));
	end;
	p2:add(v3.onChanged:connect(function(p9, p10)
		u4(p9);
		if p10 then
			return;
		end;
		u3.setValue(p4, p9);
	end));
	local v4 = u3.getValue(p4);
	if v4 == nil then
		u3.setValue(p4, p7);
	end;
	v3:setValue(v4 and p7);
	return v2;
end;
return v1;

