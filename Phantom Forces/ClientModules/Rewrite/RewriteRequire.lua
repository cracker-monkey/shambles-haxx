
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = { "WeaponControllerInterface", "PlayerStatusInterface", "HitDetectionInterface", "ReplicationInterface", "ProjectileInterface", "GameRoundInterface", "MapPropInterface", "LeaderboardRequire", "ChatRequire", "HudRequire" };
function v1._init(p1)
	for v2 = 1, #u1 do
		shared.require(u1[v2]);
	end;
end;
return v1;

