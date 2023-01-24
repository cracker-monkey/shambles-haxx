
-- Decompiled with the Synapse X Luau decompiler.

local u1 = shared.require("MenuUtils");
local l__Templates__2 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u3 = shared.require("MenuColorConfig");
return function(p1, p2, p3)
	local v1 = p2.altreloadlong and "";
	if p2.animationmods and p2.animationmods[v1 .. "reload"] then
		for v2, v3 in next, p2.animationmods[v1 .. "reload"] do
			p2.animations[v1 .. "reload"][v2] = v3;
		end;
	end;
	if p2.uniquereload then
		local v4 = u1.getAnimationTime(p2.animations.initstage) + u1.getAnimationTime(p2.animations.reloadstage) + u1.getAnimationTime(p2.animations.emptyendstage);
	else
		v4 = u1.getAnimationTime(p2.animations[v1 .. "reload"]);
	end;
	local v5 = l__Templates__2.DisplayWeaponAdvancedStatText:Clone();
	v5.TextFrameStat.Text = string.upper("Empty Reload Time");
	v5.TextFrameValue.Text = v4 .. " seconds";
	if p3.altreloadlong and local v6 then
		v5.TextFrameValue.TextColor3 = u3.previewDisplayTextStatsColor;
	end;
	return v5;
end;

