
-- Decompiled with the Synapse X Luau decompiler.

local u1 = shared.require("MenuUtils");
local l__Templates__2 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u3 = shared.require("MenuColorConfig");
return function(p1, p2, p3)
	local v1 = nil;
	local v2 = nil;
	v1 = u1.twoDecimal(p2.damage0, true);
	v2 = u1.twoDecimal(p2.damage1, true);
	if p2.type == "SHOTGUN" then
		local v3 = v1 .. "\195\151" .. p2.pelletcount .. " -> " .. v2 .. "\195\151" .. p2.pelletcount;
	else
		v3 = v1 .. " -> " .. v2;
	end;
	local v4 = l__Templates__2.DisplayWeaponStatText:Clone();
	v4.TextFrameStat.Text = string.upper("Damage");
	v4.TextFrameValue.Text = string.upper(v3);
	if p3.damage0 or (p3.damage1 or p3.pelletcount) then
		v4.TextFrameValue.TextColor3 = u3.previewDisplayTextStatsColor;
	end;
	return v4;
end;

