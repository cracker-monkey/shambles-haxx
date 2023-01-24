
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = {
	title = "EQUIP SKIN"
};
local u1 = shared.require("PlayerDataStoreClient");
local u2 = shared.require("ContentDatabase");
local u3 = shared.require("LoadoutConfig");
local u4 = shared.require("MenuWeaponDisplayInterface");
local u5 = shared.require("ActiveLoadoutUtils");
local u6 = shared.require("network");
local u7 = shared.require("PageLoadoutMenuInterface");
local u8 = shared.require("MenuPagesInterface");
local u9 = shared.require("PageLoadoutMenuDisplayWeaponCamo");
function v2.func(p1)
	local l__Weapon__3 = p1.Weapon;
	local v4 = u1.getPlayerData();
	local v5 = u2.getWeaponClass(l__Weapon__3);
	local v6 = nil;
	local v7 = nil;
	for v8, v9 in next, u3.classSlots do
		for v10, v11 in next, v9 do
			for v12, v13 in next, v11 do
				if v5 == v13 then
					v6 = v8;
					v7 = v10;
				end;
			end;
		end;
	end;
	if not v6 or not v7 then
		warn("PageInventoryDropMenuSkin: No targetLoadoutSlot or targetClassSlot found for weapon", l__Weapon__3, v5, v6, v7);
		return;
	end;
	u4.clearPreview();
	u5.changeClassSlot(v4, v7);
	u6:send("changeClass", v7);
	u5.changeWeapon(v4, v6, l__Weapon__3);
	u6:send("changeWeapon", v6, l__Weapon__3);
	u7.setActiveLoadoutSlot(v6, true);
	u8.goToPage("PageLoadoutMenu");
	u7.goToSubPage("DisplayWeaponCamo");
	u9.updatePage();
end;
function v2.conditionFunc(p2)
	return p2.Weapon ~= "ALL";
end;
local v14 = {};
local u10 = shared.require("SkinCaseUtils");
local u11 = shared.require("RichTextUtils");
local u12 = shared.require("MenuColorConfig");
function v14.titleFunc(p3)
	return "SELL SKIN:\t\t\t" .. u11.formatTextColor3("$" .. u10.getSkinCost(p3.Name, p3.Case, p3.Weapon), u12.creditsColor);
end;
local u13 = shared.require("PageInventoryDisplayInventory");
function v14.func(p4)
	u13.promptSellSkin(p4);
end;
function v14.conditionFunc(p5)
	return p5.Weapon ~= "ALL";
end;
v1[1] = v2;
v1[2] = v14;
return v1;

