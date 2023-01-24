
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("MenuUtils");
local l__Templates__1 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u2 = shared.require("MenuColorConfig");
return function(p1, p2, p3)
	if p2.chamber then
		local v2 = "One";
	else
		v2 = "None";
	end;
	local v3 = l__Templates__1.DisplayWeaponAdvancedStatText:Clone();
	v3.TextFrameStat.Text = string.upper("Round In Chamber");
	v3.TextFrameValue.Text = v2;
	if p3.chamber then
		v3.TextFrameValue.TextColor3 = u2.previewDisplayTextStatsColor;
	end;
	return v3;
end;

