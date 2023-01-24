
-- Decompiled with the Synapse X Luau decompiler.

local l__Templates__1 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u2 = shared.require("MenuColorConfig");
return function(p1, p2, p3)
	local v1 = l__Templates__1.DisplayWeaponStatText:Clone();
	v1.TextFrameStat.Text = string.upper("Ammo Capacity");
	v1.TextFrameValue.Text = string.upper(p2.magsize .. " / " .. p2.sparerounds);
	if p3.magsize or p3.spareround then
		v1.TextFrameValue.TextColor3 = u2.previewDisplayTextStatsColor;
	end;
	return v1;
end;

