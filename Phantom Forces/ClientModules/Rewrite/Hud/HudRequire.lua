
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = { "HudInteractionInterface", "HudMatchScoreInterface", "HudCrosshairsInterface", "HudObjectiveInterface", "HudSpottingInterface", "HudBloodArcInterface", "HudKillfeedInterface", "HudKillCardInterface", "HudNameTagInterface", "HudStatusInterface", "HudRadarInterface", "MatchScreenInterface" };
function v1._init(p1)
	for v2 = 1, #u1 do
		shared.require(u1[v2]);
	end;
end;
return v1;

