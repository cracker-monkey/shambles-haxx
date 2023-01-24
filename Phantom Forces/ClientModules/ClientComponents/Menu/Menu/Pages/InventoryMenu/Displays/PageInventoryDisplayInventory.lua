
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("UIPrompt");
local v3 = shared.require("PageInventoryMenuInterface").getPageFrame();
local l__Templates__4 = v3.Templates;
local l__DisplayInventory__5 = v3.DisplayInventory;
local v6 = l__Templates__4.DisplayPrompt:Clone();
v6.Position = UDim2.fromScale(0.5, 0.5);
v6.Visible = false;
v6.Parent = l__DisplayInventory__5;
local v7 = l__Templates__4.DisplayPromptConfirm:Clone();
v7.Position = UDim2.fromScale(0.5, 0.5);
v7.Visible = false;
v7.Parent = l__DisplayInventory__5;
local u1 = shared.require("PageInventoryMenuConfig");
local u2 = shared.require("SkinCaseUtils");
local u3 = shared.require("ContentDatabase");
local u4 = shared.require("PlayerDataStoreClient");
local u5 = shared.require("PlayerDataUtils");
function getInventoryItemCount()
	local v8 = 0;
	local l__next__9 = next;
	local v10 = u5.getInventoryData((u4.getPlayerData()));
	local v11 = nil;
	while true do
		local v12, v13 = l__next__9(v10, v11);
		if v12 then

		else
			break;
		end;
		local l__Cases__14 = v13.Cases;
		if u1.itemTypes.Case.toggled then
			if 0 < l__Cases__14.Count then
				v8 = v8 + 1;
			end;
			local l__next__15 = next;
			local l__Assigned__16 = l__Cases__14.Assigned;
			local v17 = nil;
			while true do
				local v18, v19 = l__next__15(l__Assigned__16, v17);
				if v18 then

				else
					break;
				end;
				v17 = v18;
				v8 = v8 + 1;			
			end;
		end;
		if u1.itemTypes["Case Key"].toggled then
			if 0 < v13.Keys then
				v8 = v8 + 1;
			end;
		end;
		if u1.itemTypes.Skin.toggled then
			local l__next__20 = next;
			local l__Skins__21 = v13.Skins;
			local v22 = nil;
			while true do
				local v23, v24 = l__next__20(l__Skins__21, v22);
				if v23 then

				else
					break;
				end;
				v22 = v23;
				local l__next__25 = next;
				local v26 = nil;
				while true do
					local v27, v28 = l__next__25(v24, v26);
					if v27 then

					else
						break;
					end;
					v26 = v27;
					if 0 < v28 then
						v8 = v8 + 1;
					else
						warn("PageInventoryDisplayInventory: Should remove zero weaponSkinCount", v23, v27, v28);
					end;				
				end;			
			end;
		end;	
	end;
	return v8;
end;
function getInventoryMaxPage()
	return math.max(1, math.ceil(getInventoryItemCount() / u1.maxItemsPerPage));
end;
local u6 = 1;
local u7 = shared.require("PageInventoryMenuEvents");
function v1.goPrevPage()
	local v29 = nil;
	v29 = getInventoryMaxPage();
	if u6 - 1 <= 0 then
		u6 = v29;
	elseif v29 < u6 then
		u6 = v29;
	else
		u6 = u6 - 1;
	end;
	u7.onInventoryChanged:fire();
end;
function v1.goNextPage()
	local v30 = getInventoryMaxPage();
	if u6 < 1 then
		u6 = 1;
	elseif v30 < u6 + 1 then
		u6 = 1;
	else
		u6 = u6 + 1;
	end;
	u7.onInventoryChanged:fire();
end;
local u8 = v2.new(v6, v6.Container.Confirm, v6.Container.Cancel);
local u9 = shared.require("RichTextUtils");
local u10 = shared.require("MenuColorConfig");
local u11 = shared.require("network");
local u12 = v2.new(v7, v7.Container.Confirm);
local u13 = nil;
function v1.promptSellSkin(p1)
	local l__Name__31 = p1.Name;
	local l__Weapon__32 = p1.Weapon;
	local l__Case__33 = p1.Case;
	local v34 = u2.getSkinCost(l__Name__31, l__Case__33, l__Weapon__32);
	u8:activate("SELL [" .. string.upper(l__Weapon__32) .. "] " .. u9.escapeForbiddenCharacters(string.upper(l__Name__31)) .. " SKIN FOR: " .. u9.formatTextColor3("$" .. v34, u10.creditsColor), function()
		print("attempt to sell", l__Name__31, "skin for", v34);
		u11:send("sellSkin", l__Case__33, l__Name__31, l__Weapon__32);
		u12:activate("AWAITING SELLING...");
		u13 = true;
	end, function()

	end);
end;
local u14 = shared.require("DestructorGroup").new();
local u15 = shared.require("MenuUtils");
local l__Container__16 = l__DisplayInventory__5.DisplayInventoryList.Container;
local u17 = shared.require("PageInventoryMenuUtils");
local u18 = {};
local function u19(p2, p3)
	local l__priority__35 = u1.itemTypes[p2.Type].priority;
	local l__priority__36 = u1.itemTypes[p3.Type].priority;
	local l__Name__37 = p2.Name;
	local l__Name__38 = p3.Name;
	if p2.Type ~= p3.Type then
		if l__priority__35 == l__priority__36 then
			local v39 = true;
			if not (l__Name__37 < l__Name__38) then
				v39 = l__priority__35 < l__priority__36;
			end;
		else
			v39 = l__priority__35 < l__priority__36;
		end;
		return v39;
	end;
	if p2.Legendary then
		local v40 = 1;
	else
		v40 = 0;
	end;
	if p3.Legendary then
		local v41 = 1;
	else
		v41 = 0;
	end;
	local v42 = "";
	local v43 = "";
	local v44 = nil;
	local v45 = nil;
	if p2.Type == "Skin" then
		local v46 = u2.getSkinDataset(l__Name__37);
		local v47 = u2.getSkinDataset(l__Name__38);
		local v48 = v46 and v46.Rarity or 0;
		local v49 = v47 and v47.Rarity or 0;
		v42 = v46 and v46.Case or "";
		v43 = v47 and v47.Case or "";
	elseif p2.Type == "Case" or p2.Type == "Case Key" then
		local v50 = u2.getCaseDataset(l__Name__37);
		local v51 = u2.getCaseDataset(l__Name__38);
		v44 = v50 and v50.Tier or 0;
		v45 = v51 and v51.Tier or 0;
	end;
	local v52 = p2.Weapon and u3.getWeaponDisplayName(p2.Weapon) or "";
	local v53 = p3.Weapon and u3.getWeaponDisplayName(p3.Weapon) or "";
	if v40 == v41 then
		if v44 == v45 then
			if l__Name__37 == l__Name__38 then
				if v42 == v43 then
					local v54 = true;
					if not (v52 < v53) then
						v54 = true;
						if not (v42 < v43) then
							v54 = true;
							if not (l__Name__37 < l__Name__38) then
								v54 = true;
								if not (v45 < v44) then
									v54 = v41 < v40;
								end;
							end;
						end;
					end;
				else
					v54 = true;
					if not (v42 < v43) then
						v54 = true;
						if not (l__Name__37 < l__Name__38) then
							v54 = true;
							if not (v45 < v44) then
								v54 = v41 < v40;
							end;
						end;
					end;
				end;
			else
				v54 = true;
				if not (l__Name__37 < l__Name__38) then
					v54 = true;
					if not (v45 < v44) then
						v54 = v41 < v40;
					end;
				end;
			end;
		else
			v54 = true;
			if not (v45 < v44) then
				v54 = v41 < v40;
			end;
		end;
	else
		v54 = v41 < v40;
	end;
	return v54;
end;
local u20 = shared.require("UIHighlight");
local u21 = shared.require("GuiInputInterface");
local l__DisplayPageCount__22 = l__DisplayInventory__5.DisplayPageCount;
function v1.updateInventoryList(p4)
	local v55 = u14:runAndReplace("updateInventoryList");
	u15.clearContainer(l__Container__16);
	local v56 = u5.getInventoryData((u4.getPlayerData()));
	if p4 then
		u6 = 1;
	end;
	local u23 = 0;
	local u24 = (u6 - 1) * u1.maxItemsPerPage;
	local v57 = u17.generateSortedInventoryList(v56);
	if #u18 > 0 then
		local v58 = {};
		local l__next__59 = next;
		local v60 = nil;
		while true do
			local v61, v62 = l__next__59(v57, v60);
			if not v61 then
				break;
			end;
			local v63 = v62.Weapon and u3.getWeaponDisplayName(v62.Weapon);
			local v64 = v62.Weapon and u3.getWeaponData(v62.Weapon).type;
			if v62.Type == "Skin" then
				v58[v62] = u17.termDist(u18, u17.separate({ u10.rarityColorConfig[u2.getSkinRarity(v62.Name)].Name, v62.Name, v62.Case, v62.Type, v63, v64 }));
			else
				v58[v62] = u17.termDist(u18, u17.separate({ v62.Name, v62.Type, v63, v64 }));
			end;		
		end;
		table.sort(v57, function(p5, p6)
			if v58[p5] == v58[p6] then
				return u19(p5, p6);
			end;
			return v58[p5] < v58[p6];
		end);
	else
		table.sort(v57, u19);
	end;
	local l__next__65 = next;
	local v66 = nil;
	while true do
		local v67, v68 = l__next__65(v57, v66);
		if not v67 then
			break;
		end;
		local v69 = false;
		if u24 <= u23 then
			v69 = u23 < u24 + u1.maxItemsPerPage;
		end;
		if v69 then
			if v68.Type == "Skin" then
				local v70 = u17.drawInventorySkin(nil, v68.Name, v68.Weapon, v68.Count);
			else
				local l__Name__71 = v68.Name;
				local v72 = u2.getCaseDataset(l__Name__71);
				local v73 = nil;
				local v74 = nil;
				if v68.Type == "Case Key" then
					v74 = v72["Case KeyImg"];
					v73 = l__Name__71 .. " Key";
				elseif v68.Type == "Case" then
					v74 = v72.CaseImg;
					v73 = l__Name__71;
				end;
				v70 = u17.drawInventoryCase(nil, v73, v68.Count, v74, v72.Tier, v68.Desc);
			end;
			v70.Parent = l__Container__16;
			local v75 = {};
			function v75.updateFunc(p7)
				v70.HighlightFrame.Transparency = 0.3 + (1 - p7) * 0.7;
			end;
			v55:add(u20.new(v70, v75));
			v55:add(v70);
			for v76, v77 in next, shared.require(u1.dropMenuTypes[v68.Type]) do
				if not v77.conditionFunc or v77.conditionFunc(v68) then
					local v78 = l__Templates__4.ButtonDropMenu:Clone();
					if v77.titleFunc then
						u15.setText(v78, v77.titleFunc(v68));
					else
						u15.setText(v78, v77.title);
					end;
					v78.Parent = v70.ContainerDropMenu;
					v55:add(v78);
					v55:add(u21.onReleased(v78, function()
						if not (not u13) or not (not v6.Visible) or v7.Visible then
							return;
						end;
						v77.func(v68);
						u7.onInventoryButtonClicked:fire();
					end));
					v55:add(u20.new(v78, {
						highlightColor3 = u10.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
						defaultColor3 = u10.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
					}));
				end;
			end;
			v55:add(u21.onReleased(v70, function()
				if not (not u13) or not (not v6.Visible) or v7.Visible then
					return;
				end;
				v70.ContainerDropMenu.Visible = not v70.ContainerDropMenu.Visible;
				u7.onInventoryButtonClicked:fire(v70);
			end));
			v55:add(u7.onInventoryButtonClicked:connect(function(p8)
				if p8 ~= v70 then
					v70.ContainerDropMenu.Visible = false;
				end;
			end));
			v70.ContainerDropMenu.Visible = false;
		end;
		u23 = u23 + 1;	
	end;
	u15.setText(l__DisplayPageCount__22, u6 .. "/" .. getInventoryMaxPage());
end;
local l__ContainerFilters__25 = l__DisplayInventory__5.ContainerFilters;
local u26 = false;
local u27 = shared.require("PageCreditsMenuEvents");
function v1._init()
	v1.updateInventoryList();
	local l__ButtonPrev__79 = l__DisplayInventory__5.ButtonPrev;
	u21.onReleased(l__ButtonPrev__79, function()
		v1.goPrevPage();
	end);
	u20.new(l__ButtonPrev__79, {
		highlightColor3 = u10.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u10.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	});
	local l__ButtonNext__80 = l__DisplayInventory__5.ButtonNext;
	u21.onReleased(l__ButtonNext__80, function()
		v1.goNextPage();
	end);
	u20.new(l__ButtonNext__80, {
		highlightColor3 = u10.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u10.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	});
	u15.clearContainer(l__ContainerFilters__25);
	for v81, v82 in next, u1.inventoryFilters do
		local v83 = shared.require(v82)(v3, u1.itemTypes);
		v83.Parent = l__ContainerFilters__25;
		u20.new(v83, {
			highlightColor3 = u10.subMenuColorConfig.highlighted.BackgroundColor3, 
			defaultColor3 = u10.subMenuColorConfig.default.BackgroundColor3
		});
	end;
	local v84 = l__Templates__4.ButtonInventorySearch:Clone();
	v84.Parent = l__ContainerFilters__25;
	v84.TextBox.Focused:connect(function()
		u26 = true;
	end);
	v84.TextBox.FocusLost:connect(function(p9)
		u26 = false;
		if v84.TextBox.Text == "" then
			u18 = {};
			v84.TextBox.Text = "SEARCH";
			u7.onInventoryChanged:fire(true);
		end;
	end);
	u21.onReleased(v84.TextBox, function()
		v84.TextBox:CaptureFocus();
	end);
	u21.onPressedOff(v84.TextBox, function()
		v84.TextBox:ReleaseFocus();
	end);
	v84.TextBox.Changed:connect(function(p10)
		if p10 == "Text" and u26 then
			u18 = {};
			for v85 in string.gmatch(string.lower(v84.TextBox.Text), "%w+") do
				u18[#u18 + 1] = v85;
			end;
			u7.onInventoryChanged:fire(true);
		end;
	end);
	u11:receive("sellSkinUpdate", function(p11, p12, p13, p14)
		u13 = false;
		if not p11 then
			warn("PageInventoryDisplayInventory: sellSkin was not successful for", p13, p14);
			return;
		end;
		u2.sellSkin(u4.getPlayerData(), p12, p13, p14);
		u7.onInventoryChanged:fire();
		u27.onCreditsUpdated:fire();
		u12:activate("SELLING SUCCESSFUL!");
	end);
	u7.onInventoryChanged:connect(v1.updateInventoryList);
end;
return v1;

