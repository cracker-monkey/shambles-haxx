
-- Decompiled with the Synapse X Luau decompiler.

local l__Templates__1 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u2 = shared.require("MenuColorConfig");
return function(p1, p2, p3)
	local v1 = l__Templates__1.DisplayWeaponStatText:Clone();
	v1.TextFrameStat.Text = string.upper("Killing Radius");
	v1.TextFrameValue.Text = string.upper(p2.range0 + math.floor(100 / ((p2.damage0 - p2.damage1) / (p2.range1 - p2.range0))));
	if p3.damage0 or (p3.damage1 or (p3.range0 or p3.range1)) then
		v1.TextFrameValue.TextColor3 = u2.previewDisplayTextStatsColor;
	end;
	return v1;
end;

