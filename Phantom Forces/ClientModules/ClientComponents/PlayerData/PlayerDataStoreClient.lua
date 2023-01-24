
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("ContentDatabase");
local v3 = shared.require("Event");
v1.onDataLoaded = v3.new();
v1.onDataUpdated = v3.new();
local u1 = nil;
function v1.getPlayerData()
	return u1;
end;
function v1.isDataReady()
	if u1 then
		return true;
	end;
	return false;
end;
local u2 = shared.require("network");
local u3 = shared.require("PageCreditsMenuEvents");
local u4 = shared.require("PlayerDataUtils");
function v1._init()
	u2:receive("loadPlayerData", function(p1)
		u1 = p1;
		v1.onDataLoaded:fire();
	end);
	u2:receive("updatePlayerData", function(p2, ...)
		local v4 = nil;
		local v5 = { ... };
		v4 = u1;
		for v6 = 1, #v5 - 1 do
			if not v4[v5[v6]] then
				v4[v5[v6]] = {};
			end;
			v4 = v4[v5[v6]];
		end;
		local v7[v5[#v5]] = p2;
		v1.onDataUpdated:fire();
	end);
	u2:receive("updatemoney", function(p3)
		u1.stats.money = p3;
		u3.onCreditsUpdated:fire();
	end);
	u2:receive("updatetotalkills", function(p4)
		u1.stats.totalkills = p4;
	end);
	u2:receive("updatetotaldeaths", function(p5)
		u1.stats.totaldeaths = p5;
	end);
	u2:receive("updateexperience", function(p6)
		u1.stats.experience = p6;
	end);
	u2:receive("updategunkills", function(p7, p8)
		local v8 = u1.unlocks[p7];
		if not v8 then
			v8 = {};
			u1.unlocks[p7] = v8;
		end;
		v8.kills = p8;
	end);
	u2:receive("updateattachkills", function(p9, p10, p11)
		if p10 then
			local v9 = u4.getWeaponAttData(u1, p9);
			local v10 = v9[p10];
			if not v10 then
				v10 = {
					kills = 0
				};
				v9[p10] = v10;
			end;
			v10.kills = p11;
		end;
	end);
end;
return v1;

