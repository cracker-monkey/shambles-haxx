
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("ActiveLoadoutEvents");
local u1 = { "changeClassSlot", "changeWeapon", "changeAttachment", "resetAttachments", "changeSightColors", "changeCamo", "changeCamoProperty" };
local u2 = {};
local u3 = shared.require("PlayerDataStoreClient");
local u4 = shared.require("ActiveLoadoutUtils");
local u5 = shared.require("network");
function u2._init()
	for v2, v3 in u1, nil do
		u2[v3] = function(...)
			if not u4[v3](u3.getPlayerData(), ...) then
				warn("ActiveLoadoutInterfaceClient:", v3, "was not successful", ...);
				return;
			end;
			u5:send(v3, ...);
		end;
	end;
end;
return u2;

