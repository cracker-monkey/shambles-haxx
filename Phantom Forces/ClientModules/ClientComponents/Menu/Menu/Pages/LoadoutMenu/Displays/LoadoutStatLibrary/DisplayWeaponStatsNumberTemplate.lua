
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("MenuUtils");
local l__Templates__2 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u3 = shared.require("MenuColorConfig");
function v1.new(p1, p2, p3, p4, p5)
	local v2 = l__Templates__2.DisplayWeaponStatText:Clone();
	v2.TextFrameStat.Text = string.upper(p4);
	v2.TextFrameValue.Text = u1.twoDecimal(p2[p5] and 0);
	if p3[p5] then
		v2.TextFrameValue.TextColor3 = u3.previewDisplayTextStatsColor;
	end;
	return v2;
end;
return v1;

