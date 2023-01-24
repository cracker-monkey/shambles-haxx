
-- Decompiled with the Synapse X Luau decompiler.

local u1 = shared.require("MenuUtils");
local l__Templates__2 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u3 = shared.require("MenuColorConfig");
return function(p1, p2, p3)
	local v1 = l__Templates__2.DisplayWeaponAdvancedStatText:Clone();
	v1.TextFrameStat.Text = string.upper("Damage Range");
	v1.TextFrameValue.Text = u1.twoDecimal(p2.range0) .. " studs -> " .. u1.twoDecimal(p2.range1) .. " studs";
	if p3.range0 or p3.range1 then
		v1.TextFrameValue.TextColor3 = u3.previewDisplayTextStatsColor;
	end;
	return v1;
end;

