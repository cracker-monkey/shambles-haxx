
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("MenuUtils");
local l__Templates__1 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u2 = shared.require("MenuColorConfig");
return function(p1, p2, p3)
	local v2 = l__Templates__1.DisplayWeaponAdvancedStatText:Clone();
	v2.TextFrameStat.Text = string.upper("Radar Suppression Range");
	v2.TextFrameValue.Text = p2.hiderange and "Beyond " .. p2.hiderange .. " studs" or "Unsuppressed";
	if p3.hiderange then
		v2.TextFrameValue.TextColor3 = u2.previewDisplayTextStatsColor;
	end;
	return v2;
end;

