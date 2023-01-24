
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("MenuUtils");
function v1.new(p1, p2, p3)
	local v2 = p1.Templates.DisplaySettingsTitle:Clone();
	u1.setText(v2.Title, string.upper(p3));
	return v2;
end;
return v1;

