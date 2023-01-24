
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {
	menuButtons = { "PageMainMenuButtonDeploy", "PageMainMenuButtonSquadDeploy", "", "PageMainMenuButtonWeaponLoadout", "PageMainMenuButtonInventory", "PageMainMenuButtonCustomize", "PageMainMenuButtonSettings", "PageMainMenuButtonServerBrowser" }, 
	displayComponents = { "PageMainMenuDisplayLoadout", "PageMainMenuDisplayMenu" }, 
	controllerPageOrder = { "PageMainMenu", "PageLoadoutMenu", "PageInventoryMenu", "PageSettingsMenu" }
};
if shared.require("InstanceType").IsConsole() then
	table.remove(v1.menuButtons, table.find(v1.menuButtons, "PageMainMenuButtonServerBrowser"));
	table.remove(v1.menuButtons, table.find(v1.menuButtons, "PageMainMenuButtonCustomize"));
end;
return v1;

