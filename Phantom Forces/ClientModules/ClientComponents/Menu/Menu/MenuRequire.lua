
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = { "MenuScreenGui", "MenuPagesInterface", "PageMainMenuRequire", "PageRewardMenuRequire", "PageCreditsMenuRequire", "PageLoadoutMenuRequire", "PageSettingsMenuRequire", "PageInventoryMenuRequire", "PageCustomizeMenuRequire", "MenuLobbyRequire" };
function v1._init(p1)
	local v2 = shared.require("PlayerDataStoreClient");
	local v3 = v2.isDataReady();
	if not v3 then
		local u2 = v3;
		v2.onDataLoaded:Connect(function()
			u2 = true;
		end);
	end;
	while true do
		task.wait(0.03333333333333333);
		if v3 then
			break;
		end;	
	end;
	for v4 = 1, #u1 do
		shared.require(u1[v4]);
	end;
end;
return v1;

