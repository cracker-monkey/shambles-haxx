
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("CharacterInterface");
local u1 = {};
function v1.getEntry(p1)
	return u1[p1];
end;
local u2 = shared.require("PlayerStatusObject");
function v1.addEntry(p2)
	u1[p2] = u2.new(p2);
end;
function v1.removeEntry(p3)
	local v3 = u1[p3];
	if not v3 then
		return;
	end;
	v3:Destroy();
	u1[p3] = nil;
end;
function v1.operateOnAllEntries(p4)
	for v4, v5 in next, u1 do
		p4(v4, v5);
	end;
end;
local u3 = shared.require("GameClock");
function v1.getTimeSinceLastCombat(p5)
	local v6 = v1.getEntry(p5);
	if not v6 then
		return 0;
	end;
	return u3.getTime() - v6.lastCombatTime;
end;
local l__LocalPlayer__4 = game:GetService("Players").LocalPlayer;
function v1.isFriendly(p6)
	return p6.TeamColor == l__LocalPlayer__4.TeamColor;
end;
local u5 = shared.require("ReplicationInterface");
function v1.isPlayerAlive(p7)
	local v7 = u5.getEntry(p7);
	return v7 and v7:isAlive();
end;
function v1.getPlayerHealth(p8)
	local v8 = u5.getEntry(p8);
	if not v8 then
		return 0;
	end;
	return v8:isAlive() and v8:getHealth() or 0;
end;
local u6 = nil;
function v1.isNearEnemyFlag(p9)
	return u6.isNearEnemyFlag(p9);
end;
local u7 = shared.require("TeamConfig");
function v1.getOppositeTeam(p10)
	for v9, v10 in next, u7.teamNames do
		if p10.TeamColor ~= v9 then
			return v10, v9;
		end;
	end;
end;
local u8 = shared.require("GameRoundInterface");
function v1.getDeployStatus(p11)
	local v11 = v1.getEntry(p11);
	if not v11 then
		return;
	end;
	if not v11.canSpawnOn then
		return "DISABLED";
	end;
	if not v1.isPlayerAlive(p11) then
		return "DESPAWNED";
	end;
	if v1.getTimeSinceLastCombat(p11) < 5 or v1.getPlayerHealth(p11) <= 25 then
		return "IN COMBAT";
	end;
	if u8.getModeName() == "Capture the Flag" and v1.isNearEnemyFlag(p11) then
		return "IN COMBAT";
	end;
	return "DEPLOYABLE";
end;
function v1.getAllowedState(p12)
	local v12 = v1.getEntry(p12);
	if not v12 then
		warn("PlayerStatusInterface: No status found for", p12, "on getAllowedState");
		return;
	end;
	return v12.spawnAllowed;
end;
local u9 = shared.require("network");
function v1.setAllowedState(p13, p14)
	local v13 = v1.getEntry(p13);
	if not v13 then
		warn("PlayerStatusInterface: No status found for", p13, "on setAllowedState");
		return;
	end;
	v13.spawnAllowed = p14;
	u9:send("squadspawnupdate", p13, p14);
end;
local u10 = false;
function v1.setDisableAllState(p15)
	u10 = p15;
	u9:send("togglesquadspawn", p15);
end;
function v1.getDisableAllState()
	return u10;
end;
function v1._init()
	u6 = shared.require("MapPropInterface");
	game:GetService("Players").PlayerAdded:Connect(v1.addEntry);
	game:GetService("Players").PlayerRemoving:Connect(v1.removeEntry);
	for v14, v15 in pairs(game:GetService("Players"):GetPlayers()) do
		v1.addEntry(v15);
	end;
	u9:add("squadspawnupdate", function(p16, p17)
		if not u1[p16] then
			return;
		end;
		u1[p16].canSpawnOn = p17;
	end);
	u9:add("updatecombat", function(p18)
		if not u1[p18] then
			return;
		end;
		u1[p18].lastCombatTime = u3.getTime();
	end);
end;
return v1;

