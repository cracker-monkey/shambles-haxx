
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PublicSettings");
local l__RunService__3 = game:GetService("RunService");
local l__TestingPlaces__1 = v2.TestingPlaces;
local l__PlaceId__2 = game.PlaceId;
function v1.IsTest()
	return l__TestingPlaces__1[l__PlaceId__2];
end;
local l__ConsolePlaces__3 = v2.ConsolePlaces;
function v1.IsConsole()
	return l__ConsolePlaces__3[l__PlaceId__2];
end;
local u4 = l__RunService__3:IsStudio();
function v1.IsStudio()
	return u4;
end;
function v1.CanSave()
	return not v1.IsBanland() and (not v1.IsVIP() and (not v1.IsTest() and not v1.IsStudio()));
end;
local u5 = nil;
local u6 = {
	VIP = 1, 
	BanLand = 2, 
	MatchMaking = 3
};
function v1.IsVIP()
	return u5 == u6.VIP;
end;
function v1.IsBanland()
	return u5 == u6.BanLand;
end;
function v1.IsMatchMaking()
	return u5 == u6.MatchMaking;
end;
function v1.Override(p1)
	local v4 = u6[p1];
	if v4 then
		u5 = v4;
		return;
	end;
	error("Instance type" .. p1 .. "not found");
end;
function v1.GetString()
	local v5 = "PROD";
	if v1.IsTest() then
		v5 = "TP";
	elseif v1.IsVIP() then
		v5 = "VIP";
	elseif v1.IsBanland() then
		v5 = "BL";
	elseif v1.IsMatchMaking() then
		v5 = "COMP";
	end;
	if v1.IsConsole() then
		v5 = "XBOX";
	end;
	if v1.IsStudio() then
		v5 = "STUDIO";
	end;
	return v5;
end;
local u7 = l__RunService__3:IsServer();
function v1._init()
	local v6 = shared.require("network");
	if not u7 then
		u5 = v6:fetch("servertype");
		return;
	end;
	if game.VIPServerId ~= "" then
		if game.VIPServerOwnerId == 0 then
			u5 = u6.BanLand;
		else
			u5 = u6.VIP;
		end;
	end;
	v6:add("servertype", function()
		return u5;
	end);
end;
return v1;

