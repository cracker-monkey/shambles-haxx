
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("MenuColorConfig");
local u1 = shared.require("ContentDatabase");
local u2 = shared.require("MenuUtils");
local l__Templates__3 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
return function(p1, p2, p3)
	local v2 = 0;
	local v3 = u1.getWeaponModel(p2.name);
	if v3 then
		local l__Tip__4 = v3:FindFirstChild("Tip");
		local l__Trigger__5 = v3:FindFirstChild("Trigger");
		if l__Tip__4 and l__Trigger__5 then
			v2 = u2.oneDecimal((l__Tip__4.Position - l__Trigger__5.Position).Magnitude);
		end;
	end;
	local v6 = l__Templates__3.DisplayWeaponStatText:Clone();
	v6.TextFrameStat.Text = string.upper("Blade Length");
	v6.TextFrameValue.Text = string.upper(v2);
	return v6;
end;

