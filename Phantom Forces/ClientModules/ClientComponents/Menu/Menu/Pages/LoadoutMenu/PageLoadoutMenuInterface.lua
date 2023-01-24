
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = nil;
function v1.getActiveLoadoutSlot()
	return u1;
end;
local u2 = shared.require("PageLoadoutMenuEvents");
function v1.setActiveLoadoutSlot(p1, p2)
	u1 = p1;
	u2.onActiveLoadoutSlotChanged:fire(u1, p2);
end;
local u3 = shared.require("ActiveLoadoutUtils");
local u4 = shared.require("PlayerDataStoreClient");
local u5 = shared.require("ContentDatabase");
local u6 = shared.require("SkinCaseUtils");
function v1.getActiveCamoData(p3)
	local v2 = u3.getActiveWeaponLoadout(u4.getPlayerData(), u1);
	local v3 = v2.Camo and v2.Camo[u5.getCamoSlots(v2.Name)[p3]];
	if not v3 then
		return;
	end;
	local l__Name__4 = v3.Name;
	if u6.getSkinDataset(l__Name__4) then
		return v3;
	end;
	if l__Name__4 and l__Name__4 ~= "" then
		warn("DisplayCamoEditBrickColor: Skin not found in camo database", l__Name__4);
	end;
end;
local u7 = shared.require("MenuScreenGui").getPageFrame("PageLoadoutMenu");
function v1.getPageFrame()
	return u7;
end;
local u8 = {};
function v1.getCurrentSubPage()
	for v5, v6 in next, u8 do
		if v6.Visible then
			return v5;
		end;
	end;
end;
function v1.goToSubPage(p4)
	local v7 = nil;
	local l__next__8 = next;
	local v9 = nil;
	while true do
		local v10, v11 = l__next__8(u8, v9);
		if not v10 then
			break;
		end;
		if v10 == p4 then
			v7 = true;
		end;
		v11.Visible = v10 == p4;	
	end;
	if not v7 then
		warn("PageLoadoutMenuInterface: No sub page found for", p4);
		return;
	end;
	u2.onSubPageChanged:fire(p4);
end;
local u9 = shared.require("PageLoadoutMenuConfig");
function v1._init()
	for v12, v13 in next, u9.subPageFrames do
		local v14 = u7:FindFirstChild(v13, true);
		if not v14 then
			warn("PageLoadoutMenuInterface: Unable to find display frame", v13);
		end;
		u8[v13] = v14;
	end;
	v1.goToSubPage(u9.subPageFrames[1]);
end;
return v1;

