
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2.player = p1;
	v2.lastCombatTime = 0;
	v2.spawnAllowed = true;
	v2.canSpawnOn = true;
	v2.lastSightedTime = nil;
	v2.brokenSight = false;
	v2.isSpotted = false;
	return v2;
end;
function v1.Destroy(p2)
	p2._destructor:Destroy();
end;
return v1;

