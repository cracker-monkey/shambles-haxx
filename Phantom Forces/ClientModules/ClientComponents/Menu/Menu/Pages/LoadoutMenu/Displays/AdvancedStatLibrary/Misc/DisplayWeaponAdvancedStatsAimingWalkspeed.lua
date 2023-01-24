
-- Decompiled with the Synapse X Luau decompiler.

local u1 = shared.require("MenuUtils");
local l__Templates__2 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u3 = shared.require("MenuColorConfig");
return function(p1, p2, p3)
	local v1 = l__Templates__2.DisplayWeaponAdvancedStatText:Clone();
	v1.TextFrameStat.Text = string.upper("Aiming Walkspeed");
	v1.TextFrameValue.Text = u1.oneDecimal(p2.walkspeed * p2.aimwalkspeedmult);
	if p3.walkspeed or p3.aimwalkspeedmult then
		v1.TextFrameValue.TextColor3 = u3.previewDisplayTextStatsColor;
	end;
	return v1;
end;

