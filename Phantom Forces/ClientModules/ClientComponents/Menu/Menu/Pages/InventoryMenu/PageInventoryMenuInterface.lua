
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PlayerDataStoreClient");
local v3 = shared.require("MenuScreenGui").getPageFrame("PageInventoryMenu");
function v1.getPageFrame()
	return v3;
end;
local u1 = {};
function v1.getCurrentSubPage()
	for v4, v5 in next, u1 do
		if v5.Visible then
			return v4;
		end;
	end;
end;
local u2 = shared.require("PageInventoryMenuEvents");
function v1.goToSubPage(p1, p2)
	local v6 = nil;
	local l__next__7 = next;
	local v8 = nil;
	while true do
		local v9, v10 = l__next__7(u1, v8);
		if not v9 then
			break;
		end;
		if v9 == p1 then
			v6 = true;
		end;
		v10.Visible = v9 == p1;	
	end;
	if not v6 then
		warn("PageInventoryMenuInterface: No sub page found for", p1);
		return;
	end;
	u2.onSubPageChanged:fire(p1, p2);
end;
local u3 = shared.require("GuiInputInterface");
local u4 = shared.require("MenuPagesInterface");
local u5 = shared.require("UIHighlight");
local u6 = shared.require("MenuColorConfig");
local u7 = shared.require("PageInventoryMenuConfig");
local u8 = shared.require("MenuUtils");
local l__Templates__9 = v3.Templates;
local u10 = shared.require("UIToggleGroup");
local u11 = shared.require("network");
function v1._init()
	local l__ButtonBack__11 = v3.ButtonBack;
	u3.onReleased(l__ButtonBack__11, function()
		u4.goToPage("PageMainMenu");
	end);
	u5.new(l__ButtonBack__11, {
		highlightColor3 = u6.menuColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u6.menuColorConfig.default.BackgroundColor3
	});
	for v12, v13 in next, u7.subPageFrames do
		local v14 = v3:FindFirstChild(v13, true);
		if not v14 then
			warn("PageLoadoutMenuInterface: Unable to find display frame", v13);
		end;
		u1[v13] = v14;
	end;
	u8.clearContainer(v3.ContainerTabs);
	local v15 = {};
	for v16, v17 in next, u7.inventoryTabs do
		local v18 = l__Templates__9.ButtonInventoryTabs:Clone();
		v18.Design.TextFrame.Text = string.upper(v17);
		v18.Parent = v3.ContainerTabs;
		local v19 = {
			buttonFrame = v18
		};
		local v20 = {};
		function v20.onToggled()
			v1.goToSubPage(v16);
		end;
		v19.buttonConfig = v20;
		v15[v16] = v19;
	end;
	local u12 = u10.new(v15, u6.loadoutClassColorConfig);
	u2.onSubPageChanged:connect(function(p3, p4)
		if p4 or not u7.inventoryTabs[p3] then
			return;
		end;
		u12:setToggle(p3, true);
	end);
	u12:setToggle("DisplayInventory");
	u11:receive("purchaseCaseCreditUpdate", function(p5, p6, p7, p8)
		u2.onPurchaseCaseCreditUpdated:fire(p5, p6, p7, p8);
	end);
	u11:receive("purchaseCaseKeyCreditUpdate", function(p9, p10, p11)
		u2.onPurchaseCaseKeyCreditUpdated:fire(p9, p10, p11);
	end);
end;
return v1;

