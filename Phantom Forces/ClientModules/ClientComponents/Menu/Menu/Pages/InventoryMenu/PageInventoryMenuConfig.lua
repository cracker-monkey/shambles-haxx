
-- Decompiled with the Synapse X Luau decompiler.

return {
	maxItemsPerPage = 32, 
	subPageFrames = { "DisplayBuyCaseKeys", "DisplayAssignCase", "DisplayInventory", "DisplayBuyCases", "DisplayTradeIns", "DisplayOpenCase" }, 
	inventoryFilters = { "DisplayButtonShowCaseKeys", "DisplayButtonShowCases", "DisplayButtonShowSkins" }, 
	dropMenuTypes = {
		["Case Key"] = "PageInventoryDropMenuCaseKey", 
		Case = "PageInventoryDropMenuCase", 
		Skin = "PageInventoryDropMenuSkin"
	}, 
	inventoryTabs = {
		DisplayInventory = "INVENTORY", 
		DisplayBuyCaseKeys = "CASE KEY SHOP", 
		DisplayTradeIns = "TRADE IN SKINS"
	}, 
	itemTypes = {
		["Case Key"] = {
			toggled = true, 
			priority = 1
		}, 
		Case = {
			toggled = true, 
			priority = 2
		}, 
		Skin = {
			toggled = true, 
			priority = 3
		}
	}
};

