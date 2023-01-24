
-- Decompiled with the Synapse X Luau decompiler.

local l__Templates__1 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u2 = shared.require("MenuColorConfig");
return function(p1, p2, p3)
	local v1 = "|";
	for v2, v3 in next, p2.firemodes do
		if v3 == true then
			local v4 = "   AUTO   |";
		elseif v3 == 3 then
			v4 = "   III   |";
		elseif v3 == 2 then
			v4 = "   II   |";
		else
			v4 = "   SEMI   |";
		end;
		v1 = v1 .. v4;
	end;
	local v5 = l__Templates__1.DisplayWeaponStatText:Clone();
	v5.TextFrameStat.Text = string.upper("Fire Modes");
	v5.TextFrameValue.Text = string.upper(v1);
	if p3.firemodes then
		v5.TextFrameValue.TextColor3 = u2.previewDisplayTextStatsColor;
	end;
	return v5;
end;

