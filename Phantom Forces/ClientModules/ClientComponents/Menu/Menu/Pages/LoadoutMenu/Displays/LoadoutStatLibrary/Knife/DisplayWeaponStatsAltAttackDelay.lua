
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("MenuColorConfig");
local u1 = shared.require("MenuUtils");
local l__Templates__2 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
return function(p1, p2, p3)
	local v2 = l__Templates__2.DisplayWeaponStatText:Clone();
	v2.TextFrameStat.Text = string.upper("Alt Attack Delay");
	v2.TextFrameValue.Text = string.upper(u1.oneDecimal(p2.hitdelay.stab2) .. " seconds");
	return v2;
end;

