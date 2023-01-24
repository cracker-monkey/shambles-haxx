
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("MenuUtils");
local u2 = shared.require("UISwitch");
local u3 = shared.require("PlayerSettingsInterface");
function v1.new(p1, p2, p3, p4, p5)
	local v2 = p1.Templates.ButtonSettingsToggle:Clone();
	u1.setText(v2.Title, string.upper(p3));
	local u4 = u2.new(v2.DisplayToggle);
	p2:add(u4.onChanged:connect(function(p6, p7)
		if p6 then
			local v3 = "True";
		else
			v3 = "False";
		end;
		u1.setText(u4.guiObject, (string.upper(v3)));
		u4.checkBox.CheckBoxFrame.Visible = p6;
		if p7 then
			return;
		end;
		u3.setValue(p4, p6);
	end));
	p2:add(u4);
	local v4 = u3.getValue(p4);
	if v4 == nil then
		u3.setValue(p4, p5);
		v4 = p5;
	end;
	u4:setValue(v4);
	return v2;
end;
return v1;

