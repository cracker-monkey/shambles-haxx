
-- Decompiled with the Synapse X Luau decompiler.

local u1 = shared.require("MenuUtils");
local l__Templates__2 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u3 = shared.require("MenuColorConfig");
return function(p1, p2, p3)
	local v1 = l__Templates__2.DisplayWeaponAdvancedStatText:Clone();
	v1.TextFrameStat.Text = string.upper("Muzzle Velocity");
	v1.TextFrameValue.Text = u1.twoDecimal(p2.bulletspeed) .. " studs/s";
	if p3.bulletspeed then
		v1.TextFrameValue.TextColor3 = u3.previewDisplayTextStatsColor;
	end;
	return v1;
end;

