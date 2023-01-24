
-- Decompiled with the Synapse X Luau decompiler.

local l__Templates__1 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u2 = shared.require("MenuColorConfig");
return function(p1, p2, p3)
	if not p2.blastradius then
		warn("no blast radius found for", p1.name, p2, p3);
	end;
	local v1 = l__Templates__1.DisplayWeaponStatText:Clone();
	v1.TextFrameStat.Text = string.upper("Blast Radius");
	v1.TextFrameValue.Text = string.upper(p2.blastradius);
	if p3.blastradius then
		v1.TextFrameValue.TextColor3 = u2.previewDisplayTextStatsColor;
	end;
	return v1;
end;

