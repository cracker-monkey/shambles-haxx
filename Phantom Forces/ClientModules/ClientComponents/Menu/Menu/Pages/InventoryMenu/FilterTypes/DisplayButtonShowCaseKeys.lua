
-- Decompiled with the Synapse X Luau decompiler.

local u1 = shared.require("MenuUtils");
local u2 = shared.require("UISwitch");
local u3 = shared.require("PageInventoryMenuEvents");
return function(p1, p2)
	local v1 = p1.Templates.ButtonInventoryFilters:Clone();
	u1.setText(v1, "SHOW CASE KEYS");
	local v2 = u2.new(v1);
	v2.onChanged:connect(function(p3, p4)
		p2["Case Key"].toggled = p3;
		v2.checkBox.CheckBoxFrame.Visible = p3;
		if not p4 then
			u3.onInventoryChanged:fire(true);
		end;
	end);
	v2:setValue(true);
	return v1;
end;

