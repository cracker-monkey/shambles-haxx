
-- Decompiled with the Synapse X Luau decompiler.

local u1 = shared.require("MenuUtils");
local l__Templates__2 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u3 = shared.require("MenuColorConfig");
return function(p1, p2, p3)
	local v1 = l__Templates__2.DisplayWeaponAdvancedStatText:Clone();
	v1.TextFrameStat.Text = string.upper("Minimum Time To Kill");
	v1.TextFrameValue.Text = u1.twoDecimal(60 / (type(p2.firerate) == "table" and p2.firerate[1] or p2.firerate) * (math.ceil(100 / (p2.damage0 * p2.multhead)) - 1) * 100 / 100) .. " s";
	if p3.damage0 or (p3.multhead or p3.firerate) then
		v1.TextFrameValue.TextColor3 = u3.previewDisplayTextStatsColor;
	end;
	return v1;
end;

