
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("TeamConfig");
local v3 = shared.require("GameClock");
local v4 = shared.require("Event");
local l__LocalPlayer__5 = game:GetService("Players").LocalPlayer;
v1.raycastWhiteList = { workspace.Map };
v1.onVoteListChanged = v4.new();
v1.onCountDownChanged = v4.new();
v1.onVoteStarted = v4.new();
v1.onModeVoteUpdated = v4.new();
v1.onMapVoteUpdated = v4.new();
v1.onMapChanged = v4.new();
v1.roundLock = false;
local u1 = {};
function v1.getMapState()
	return u1;
end;
function v1.getMapName()
	return u1.Name and "N/A";
end;
local u2 = shared.require("GameModeConfig");
function v1.getModeName()
	local v6 = u1.modeName and "N/A";
	local v7 = u2[v6];
	return v7 and v7.Name or v6;
end;
local u3 = {};
local u4 = {};
function v1.getVoteLists()
	return u3, u4;
end;
local l__ServerSettings__8 = game:GetService("ReplicatedStorage"):WaitForChild("ServerSettings");
local l__Countdown__5 = l__ServerSettings__8:WaitForChild("Countdown");
function v1.isCountingDown()
	return l__Countdown__5.Value;
end;
local l__GhostScore__6 = l__ServerSettings__8:WaitForChild("GhostScore");
local l__PhantomScore__7 = l__ServerSettings__8:WaitForChild("PhantomScore");
local l__MaxScore__8 = l__ServerSettings__8:WaitForChild("MaxScore");
function v1.getMatchScores()
	return l__GhostScore__6.Value, l__PhantomScore__7.Value, l__MaxScore__8.Value;
end;
local l__Timer__9 = l__ServerSettings__8:WaitForChild("Timer");
function v1.getMatchTime()
	return l__Timer__9.Value;
end;
local u10 = shared.require("network");
local u11 = shared.require("GameRoundEvents");
function v1._init()
	u10:receive("changeMapVoteUpdate", function(p1, p2, p3)
		for v9, v10 in next, u3 do
			if v10.Name == p2 then
				v10.Votes[p1.Name] = p3 and p1.UserId or nil;
			else
				v10.Votes[p1.Name] = nil;
			end;
		end;
		v1.onMapVoteUpdated:fire(p2);
	end);
	u10:receive("changeModeVoteUpdate", function(p4, p5, p6)
		for v11, v12 in next, u4 do
			if v12.Name == p5 then
				v12.Votes[p4.Name] = p6 and p4.UserId or nil;
			else
				v12.Votes[p4.Name] = nil;
			end;
		end;
		v1.onModeVoteUpdated:fire(p5);
	end);
	u10:receive("updateVoteList", function(p7, p8)
		u3 = p7;
		u4 = p8;
		v1.onVoteListChanged:fire(u3, u4);
	end);
	u10:receive("updateMapState", function(p9)
		u1 = p9;
		v1.onMapChanged:fire(p9);
	end);
	u10:receive("initializeGameState", function(p10, p11, p12)
		u1 = p10;
		u3 = p11;
		u4 = p12;
		v1.onVoteListChanged:fire(u3, u4);
		v1.onMapChanged:fire(p10);
	end);
	u10:receive("mapVoteStart", function()
		v1.onVoteStarted:fire();
	end);
	u10:receive("roundstart", function(p13)
		u11.onRoundStarted:fire();
	end);
end;
return v1;

