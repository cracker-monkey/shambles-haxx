
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("PlayerDataUtils");
local u2 = shared.require("PlayerDataStoreClient");
function v1.getValue(p1)
	return u1.getOptionsData(u2.getPlayerData())[p1];
end;
local u3 = shared.require("PlayerSettingsEvents");
local u4 = shared.require("network");
function v1.setValue(p2, p3)
	u1.getOptionsData(u2.getPlayerData())[p2] = p3;
	u3.onSettingChanged:fire(p2, p3);
	u4:send("changePlayerSetting", p2, p3);
end;
return v1;

