
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PageInventoryMenuInterface");
local v3 = shared.require("MenuScreenGui");
local v4 = v2.getPageFrame();
local l__DisplayOpenCase__5 = v4.DisplayOpenCase;
local l__Templates__6 = v4.Templates;
local l__DisplayCaseSetup__7 = l__DisplayOpenCase__5.DisplayCaseSetup;
local l__DisplayRolling__8 = l__DisplayOpenCase__5.DisplayRolling;
local v9 = l__DisplayCaseSetup__7.DisplayPromptItemPurchase;
v9.Visible = false;
local v10 = l__Templates__6.DisplayPromptConfirm:Clone();
v10.Position = UDim2.fromScale(0.5, 1);
v10.Visible = false;
v10.Parent = l__DisplayCaseSetup__7;
local u1 = false;
local u2 = false;
local u3 = shared.require("SkinCaseUtils");
local u4 = shared.require("MenuColorConfig");
local u5 = shared.require("ContentDatabase");
local l__DisplayRollResults__6 = l__DisplayOpenCase__5.DisplayRollResults;
local u7 = shared.require("DestructorGroup").new();
function v1.displayRolledSkin(p1, p2, p3)
	local v11 = nil;
	if p3 and u3.isLegendaryWeapon(p3) then
		local v12 = u3.getSkinDataset(p3);
		v11 = true;
	else
		v12 = u3.getSkinDataset(p2);
	end;
	local v13 = u4.rarityColorConfig[v12.Rarity and 0];
	local v14 = l__Templates__6.DisplayRolledSkin:Clone();
	v14.TextItemName.Text = v12.DisplayName and p2;
	v14.ImageLabel.Image = "rbxassetid://" .. v12.TextureId;
	v14.Design.BackFrame.BorderColor3 = v13.Color;
	v14.TextWeapon.Text = p3 and u5.getWeaponDisplayName(p3) or "RANDOM";
	if v12.Unlocked then
		local v15 = " / Customizable";
	else
		v15 = "";
	end;
	v14.TextRarity.Text = v13.Name .. v15;
	if v12.ImageColor then
		v14.ImageFrame.BackgroundColor3 = v12.ImageColor;
	end;
	if v11 then
		local v16 = u3.getSkinDataset(p2);
		v14.LegendaryTexture.Image = "rbxassetid://" .. v16.TextureId;
		v14.LegendaryTexture.BorderColor3 = u4.rarityColorConfig[v16.Rarity and 0].Color;
		if v16.ImageColor then
			v14.LegendaryTexture.BackgroundColor3 = v16.ImageColor;
		end;
		v14.LegendaryTexture.Visible = true;
	end;
	v14.Position = UDim2.new(0, 0, 0, -120);
	v14.Parent = l__DisplayRollResults__6.Container;
	local v17 = #l__DisplayRollResults__6.Container:GetChildren();
	for v18 = #l__DisplayRollResults__6.Container:GetChildren(), 1, -1 do
		local v19 = l__DisplayRollResults__6.Container:GetChildren()[v18];
		v19:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true);
		local v20 = 0 + (v19.Size.Y.Offset + 5);
		if v17 - v18 > 10 then
			u7:run(v19);
		end;
	end;
	u7:add(v14):add(v14);
end;
local u8 = shared.require("MenuUtils");
local u9 = shared.require("PageInventoryMenuUtils");
local u10 = shared.require("UIScrollingList");
local u11 = shared.require("GuiInputInterface");
local l__DisplayMultiRollList__12 = l__DisplayOpenCase__5.DisplayMultiRollList;
local u13 = shared.require("UIHighlight");
function v1.displayMultiRolledSkin(p4, p5)
	local v21 = l__Templates__6.DisplayRolledSkinBatchLong:Clone();
	v21.TextTitle.Text = string.upper(p4) .. " BATCH";
	v21.TextCount.Text = "x" .. #p5.selectedSkinName .. " SKINS";
	v21.Design.BackFrame.BorderColor3 = u4.rarityColorConfig[u3.getCaseDataset(p4).Tier and 0].Color;
	local v22 = u7:add(v21);
	local v23 = {};
	u8.clearContainer(v21.ContainerBatch);
	local v24 = u9.getSortedMultiRollBatch(p5);
	local l__next__25 = next;
	local v26 = nil;
	while true do
		local v27, v28 = l__next__25(v24, v26);
		if not v27 then
			break;
		end;
		local l__Name__29 = v28.Name;
		local l__Weapon__30 = v28.Weapon;
		local v31 = nil;
		if l__Weapon__30 and u3.isLegendaryWeapon(l__Weapon__30) then
			local v32 = u3.getSkinDataset(l__Weapon__30);
			v31 = true;
		else
			v32 = u3.getSkinDataset(l__Name__29);
		end;
		if not v32 then
			print(l__Weapon__30, l__Name__29);
		end;
		local v33 = l__Templates__6.DisplayBatchSkin:Clone();
		v33.ImageLabel.Image = "rbxassetid://" .. v32.TextureId;
		v33.ImageLabel.BorderColor3 = u4.rarityColorConfig[v32.Rarity and 0].Color;
		if v32.ImageColor then
			v33.ImageLabel.BackgroundColor3 = v32.ImageColor;
		end;
		if v31 then
			local v34 = u3.getSkinDataset(l__Name__29);
			v33.LegendaryTexture.Image = "rbxassetid://" .. v34.TextureId;
			v33.LegendaryTexture.BorderColor3 = u4.rarityColorConfig[v34.Rarity and 0].Color;
			if v34.ImageColor then
				v33.LegendaryTexture.BackgroundColor3 = v34.ImageColor;
			end;
			v33.LegendaryTexture.Visible = true;
		end;
		v33.Parent = v21.ContainerBatch;
		if not v23[v32.Rarity] then
			v23[v32.Rarity] = 0;
		end;
		local l__Rarity__35 = v32.Rarity;
		v23[l__Rarity__35] = v23[l__Rarity__35] + 1;	
	end;
	v21.Position = UDim2.new(0, 0, 0, -240);
	v21.Parent = l__DisplayRollResults__6.Container;
	v22:add(u10.new(v21.ContainerBatch, v21.ContainerBatch.UIGridLayout));
	u8.clearContainer(v21.ContainerRarity);
	for v36 = 1, 5 do
		local v37 = l__Templates__6.DisplayRates:Clone();
		v37.TextRarity.Text = u4.rarityColorConfig[v36].Name .. ":";
		v37.TextRate.Text = "x" .. (v23[v36] and 0);
		v37.Parent = v21.ContainerRarity;
	end;
	local v38 = #l__DisplayRollResults__6.Container:GetChildren();
	for v39 = #l__DisplayRollResults__6.Container:GetChildren(), 1, -1 do
		local v40 = l__DisplayRollResults__6.Container:GetChildren()[v39];
		v40:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true);
		local v41 = 0 + (v40.Size.Y.Offset + 5);
		if v38 - v39 > 10 then
			u7:run(v40);
		end;
	end;
	v22:add(u11.onReleased(v21.ButtonView, function()
		l__DisplayMultiRollList__12.Visible = not l__DisplayMultiRollList__12.Visible;
		if l__DisplayMultiRollList__12.Visible then
			l__DisplayMultiRollList__12.TextTitle.Text = string.upper(p4) .. " BATCH";
			u8.clearContainer(l__DisplayMultiRollList__12.Container);
			for v42, v43 in next, v24 do
				local v44 = u9.drawInventorySkin(nil, v43.Name, v43.Weapon, 0);
				v44.Parent = l__DisplayMultiRollList__12.Container;
				v22:add(v44);
			end;
			v22:add(u10.new(l__DisplayMultiRollList__12.Container, l__DisplayMultiRollList__12.Container.UIGridLayout));
		end;
	end));
	v22:add(u13.new(v21.ButtonView, {
		highlightColor3 = u4.inventoryActionButton.highlighted.BackgroundColor3, 
		defaultColor3 = u4.inventoryActionButton.default.BackgroundColor3
	}));
	v22:add(v21);
end;
local u14 = shared.require("PlayerDataStoreClient");
local l__DisplayRollingList__15 = l__DisplayRolling__8.DisplayRollingList;
local u16 = shared.require("GameClock");
local u17 = shared.require("PlayerDataUtils");
local u18 = nil;
function v1.startRollAnimation(p6, p7, p8, p9, p10)
	local v45 = u7:runAndReplace("startRollAnimation");
	local v46 = u14.getPlayerData();
	u8.clearContainer(l__DisplayRollingList__15.Container);
	l__DisplayRolling__8.Visible = true;
	local v47 = u3.getAllowedWeaponList(v46);
	local v48 = math.random(40, 60);
	for v49 = 1, 70 do
		if v49 == v48 then
			local v50 = p8;
			local v51 = p9;
		else
			local v52, v53 = u3.getSimulatedRollResult(v46, p6);
			v50 = v52;
			v51 = v53;
		end;
		local v54 = u9.drawInventorySkin(nil, v50, p7 and v51, 0);
		v54.Parent = l__DisplayRollingList__15.Container;
		v54.Size = UDim2.new(0, 140, 0, 140);
		v45:add(v54);
	end;
	print("Selected skin", p8, p9);
	local v55 = u16.getTime() + 4 + math.random() * 3;
	local u19 = nil;
	local function v56(p11)
		if p11 ~= Enum.TweenStatus.Completed then
			return;
		end;
		u19 = true;
		l__DisplayRolling__8.Visible = false;
		v1.displayRolledSkin(p6, p8, p9);
		local v57, v58 = u17.getCaseAndKeyCount(v46, p6, p7);
		if not (v57 <= 0) then
			v1.startRollSetup(p6, p7, nil, u18);
			return;
		end;
		local v59 = u17.getCasePacketData(v46, p6);
		if not (v59.Cases.Count <= 0) then
			v1.startRollSetup(p6, nil, nil, u18);
			return;
		end;
		local v60 = {};
		for v61, v62 in next, v59.Cases.Assigned do
			if v62 > 0 then
				table.insert(v60, v61);
			end;
		end;
		table.sort(v60, function(p12, p13)
			return p12 < p13;
		end);
		v1.startRollSetup(p6, v60[1], nil, u18);
	end;
	l__DisplayRollingList__15.Container.Position = UDim2.new(0, 0, 0.5, 0);
	l__DisplayRollingList__15.Container:TweenPosition(UDim2.new(0, 405 - 145 * v48 + math.random(-55, 55), 0.5, 0), "Out", "Quart", v55 - u16.getTime(), true, v56);
	l__DisplayRolling__8.ButtonSkip.Visible = true;
	delay(v55 - u16.getTime() - 3, function()
		if u19 then
			return;
		end;
		l__DisplayRolling__8.ButtonSkip.Visible = false;
	end);
	local u20 = nil;
	local u21 = v55;
	v45:add(u11.onReleased(l__DisplayRolling__8.ButtonSkip, function()
		if not u20 then
			u20 = true;
			l__DisplayRolling__8.ButtonSkip.Visible = false;
			u21 = 1;
			l__DisplayRollingList__15.Container.Position = UDim2.new(0, 405 - 145 * (v48 - 2), 0.5, 0);
			l__DisplayRollingList__15.Container:TweenPosition(UDim2.new(0, 405 - 145 * v48 + math.random(-55, 55), 0.5, 0), "Out", "Quart", u21, true, v56);
		end;
	end));
	v45:add(u13.new(l__DisplayRolling__8.ButtonSkip, {
		highlightColor3 = u4.promptConfirmColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u4.promptConfirmColorConfig.default.BackgroundColor3
	}));
end;
function v1.startMultiRollAnimation(p14, p15, p16, p17)
	local v63 = u7:runAndReplace("startRollAnimation");
	local v64 = u14.getPlayerData();
	u8.clearContainer(l__DisplayRollingList__15.Container);
	l__DisplayRolling__8.Visible = true;
	local v65 = math.random(40, 60);
	local v66 = p15 and u5.getWeaponDisplayName(p15) or "RANDOM";
	for v67 = 1, 70 do
		if v65 == v67 then
			local v68 = u9.drawMultiRollCaseTarget(p14, p17);
		else
			v68 = u9.drawMultiRollCaseBlank(p14, v66, p16);
		end;
		v68.Parent = l__DisplayRollingList__15.Container;
		v68.Size = UDim2.new(0, 140, 0, 140);
		v63:add(v68);
	end;
	local v69 = u16.getTime() + 4 + math.random() * 3;
	local u22 = nil;
	local function v70(p18)
		if p18 ~= Enum.TweenStatus.Completed then
			return;
		end;
		u22 = true;
		l__DisplayRolling__8.Visible = false;
		v1.displayMultiRolledSkin(p14, p17);
		v1.startRollSetup(p14, nil, nil, u18);
	end;
	l__DisplayRollingList__15.Container.Position = UDim2.new(0, 0, 0.5, 0);
	l__DisplayRollingList__15.Container:TweenPosition(UDim2.new(0, 405 - 145 * v65 + math.random(-55, 55), 0.5, 0), "Out", "Quart", v69 - u16.getTime(), true, v70);
	l__DisplayRolling__8.ButtonSkip.Visible = true;
	delay(v69 - u16.getTime() - 3, function()
		if u22 then
			return;
		end;
		l__DisplayRolling__8.ButtonSkip.Visible = false;
	end);
	local u23 = nil;
	local u24 = v69;
	v63:add(u11.onReleased(l__DisplayRolling__8.ButtonSkip, function()
		if not u23 then
			u23 = true;
			l__DisplayRolling__8.ButtonSkip.Visible = false;
			u24 = 1;
			l__DisplayRollingList__15.Container.Position = UDim2.new(0, 405 - 145 * (v65 - 2), 0.5, 0);
			l__DisplayRollingList__15.Container:TweenPosition(UDim2.new(0, 405 - 145 * v65 + math.random(-55, 55), 0.5, 0), "Out", "Quart", u24, true, v70);
		end;
	end));
	v63:add(u13.new(l__DisplayRolling__8.ButtonSkip, {
		highlightColor3 = u4.promptConfirmColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u4.promptConfirmColorConfig.default.BackgroundColor3
	}));
end;
local u25 = nil;
local l__DisplayBuyCases__26 = l__DisplayCaseSetup__7.DisplayBuyCases;
local u27 = shared.require("PageInventoryDisplayBuyObject");
local u28 = shared.require("PlayerPolicy");
local u29 = shared.require("UIPrompt").new(v10, v10.Container.Confirm);
local u30 = shared.require("network");
local l__DisplayBuyKeys__31 = l__DisplayCaseSetup__7.DisplayBuyKeys;
local l__DisplayStartRoll__32 = l__DisplayCaseSetup__7.DisplayStartRoll;
local l__DisplayCase__33 = l__DisplayCaseSetup__7.DisplayCase;
local l__DisplayCaseKey__34 = l__DisplayCaseSetup__7.DisplayCaseKey;
local l__DisplaySkinList__35 = l__DisplayOpenCase__5.DisplaySkinList;
local l__DisplayAsssignedCases__36 = l__DisplayCaseSetup__7.DisplayAsssignedCases;
local u37 = shared.require("PageInventoryDisplayAssignCase");
local l__DisplayRollingRates__38 = l__DisplayCaseSetup__7.DisplayRollingRates;
function v1.startRollSetup(p19, p20, p21, p22)
	local v71 = u14.getPlayerData();
	local v72 = u17.getCasePacketData(v71, p19);
	if not v72 then
		warn("PageInventoryDisplayOpenCase: No casePacketData found for", p19);
		return;
	end;
	u25 = p20;
	v2.goToSubPage("DisplayOpenCase");
	local v73 = u7:runAndReplace("startRollSetup");
	local v74 = u3.getCaseDataset(p19);
	local v75, v76 = u17.getCaseAndKeyCount(v71, p19, p20);
	if v75 <= 0 then
		l__DisplayBuyCases__26.Visible = true;
		local l__cr__77 = v74.CaseCost.cr;
		local v78 = u27.new(l__DisplayBuyCases__26, v9, l__cr__77, 1, 100);
		v78:setConditionalFunc(function()
			if u28:canPurchaseRandomItems() then
				return true;
			end;
			u29:activate("Disabled due to local regulations!");
			return false;
		end);
		v78:setBuyFunc(function(p23)
			if not (not l__DisplayRolling__8.Visible) or not (not v10.Visible) or not (not u1) or u2 then
				local v79 = nil;
			else
				v79 = true;
			end;
			if not v79 then
				return;
			end;
			if u17.getPlayerCredits(v71) < l__cr__77 * p23 then
				u29:activate("Not Enough Credits!");
				return;
			end;
			print("attempt to purchase", p23, p19, "cases");
			u30:send("purchaseCaseCredit", p19, p23, p20);
			u29:activate("Awaiting purchase...");
			u2 = true;
		end);
		v78:setPromptFunc(function(p24, p25)
			if not (not l__DisplayRolling__8.Visible) or not (not u1) or u2 then
				return;
			end;
			u9.updateCaseImage(p24.ContainerItem.ButtonInventoryCase, p19, p25, "Case");
		end);
		v73:add(v78);
		l__DisplayBuyCases__26.Desc.Visible = v76 > 0;
		l__DisplayBuyCases__26.Desc.Text = "Purchase more cases to use the " .. p19 .. " Case Key";
	else
		l__DisplayBuyCases__26.Visible = false;
	end;
	if v76 <= 0 then
		l__DisplayBuyKeys__31.Visible = true;
		local l__cr__80 = v74["Case KeyCost"].cr;
		local v81 = u27.new(l__DisplayBuyKeys__31, v9, l__cr__80, 1, 100);
		v81:setConditionalFunc(function()
			if u28:canPurchaseRandomItems() then
				return true;
			end;
			u29:activate("Disabled due to local regulations!");
			return false;
		end);
		v81:setBuyFunc(function(p26)
			if not (not l__DisplayRolling__8.Visible) or not (not v10.Visible) or not (not u1) or u2 then
				local v82 = nil;
			else
				v82 = true;
			end;
			if not v82 then
				return;
			end;
			if u17.getPlayerCredits(v71) < l__cr__80 * p26 then
				u29:activate("Not Enough Credits!");
				return;
			end;
			print("attempt to purchase", p26, p19, "keys");
			u30:send("purchaseCaseKeyCredit", p19, p26);
			u29:activate("Awaiting purchase...");
			u2 = true;
		end);
		v81:setPromptFunc(function(p27, p28)
			if not (not l__DisplayRolling__8.Visible) or not (not u1) or u2 then
				return;
			end;
			u9.updateCaseImage(p27.ContainerItem.ButtonInventoryCase, p19, p28, "Case Key");
		end);
		v73:add(v81);
		l__DisplayBuyKeys__31.Desc.Visible = v75 > 0;
		l__DisplayBuyKeys__31.Desc.Text = "Purchase more keys to use the " .. p19 .. " Case";
	else
		l__DisplayBuyKeys__31.Visible = false;
	end;
	if v76 > 0 and v75 > 0 then
		l__DisplayStartRoll__32.Visible = true;
		v73:add(u11.onReleased(l__DisplayStartRoll__32.ButtonUseSingle, function()
			if not (not l__DisplayRolling__8.Visible) or not (not v10.Visible) or not (not u1) or u2 then
				local v83 = nil;
			else
				v83 = true;
			end;
			if not v83 then
				return;
			end;
			u30:send("requestRoll", p19, p20);
			u1 = true;
		end));
		v73:add(u13.new(l__DisplayStartRoll__32.ButtonUseSingle, {
			highlightColor3 = u4.promptConfirmColorConfig.highlighted.BackgroundColor3, 
			defaultColor3 = u4.promptConfirmColorConfig.default.BackgroundColor3
		}));
		if v76 < v75 and v76 > 3 then
			l__DisplayStartRoll__32.ButtonUseAllCases.Visible = false;
			l__DisplayStartRoll__32.ButtonUseAllKeys.Visible = true;
			v73:add(u11.onReleased(l__DisplayStartRoll__32.ButtonUseAllKeys, function()
				if not (not l__DisplayRolling__8.Visible) or not (not v10.Visible) or not (not u1) or u2 then
					local v84 = nil;
				else
					v84 = true;
				end;
				if not v84 then
					return;
				end;
				u30:send("requestMultiRoll", p19, p20, v76);
				u1 = true;
			end));
			v73:add(u13.new(l__DisplayStartRoll__32.ButtonUseAllKeys, {
				highlightColor3 = u4.promptConfirmColorConfig.highlighted.BackgroundColor3, 
				defaultColor3 = u4.promptConfirmColorConfig.default.BackgroundColor3
			}));
		elseif v75 <= v76 and v75 > 3 then
			l__DisplayStartRoll__32.ButtonUseAllCases.Visible = true;
			l__DisplayStartRoll__32.ButtonUseAllKeys.Visible = false;
			v73:add(u11.onReleased(l__DisplayStartRoll__32.ButtonUseAllCases, function()
				if not (not l__DisplayRolling__8.Visible) or not (not v10.Visible) or not (not u1) or u2 then
					local v85 = nil;
				else
					v85 = true;
				end;
				if not v85 then
					return;
				end;
				u30:send("requestMultiRoll", p19, p20, v75);
				u1 = true;
			end));
			v73:add(u13.new(l__DisplayStartRoll__32.ButtonUseAllCases, {
				highlightColor3 = u4.promptConfirmColorConfig.highlighted.BackgroundColor3, 
				defaultColor3 = u4.promptConfirmColorConfig.default.BackgroundColor3
			}));
		else
			l__DisplayStartRoll__32.ButtonUseAllCases.Visible = false;
			l__DisplayStartRoll__32.ButtonUseAllKeys.Visible = false;
		end;
	else
		l__DisplayStartRoll__32.Visible = false;
	end;
	u9.updateCaseImage(l__DisplayCase__33, p19, v75, "Case", p20 and u5.getWeaponDisplayName(p20) or "RANDOM");
	u9.updateCaseImage(l__DisplayCaseKey__34, p19, v76, "Case Key");
	u8.clearContainer(l__DisplaySkinList__35.Container);
	local v86 = 0;
	for v87, v88 in next, u3.getCaseDataset(p19).RarityPool do
		for v89, v90 in next, v88 do
			local v91 = u9.drawInventorySkin(nil, v90, p20, 0, not p20);
			v91.Parent = l__DisplaySkinList__35.Container;
			v91.LayoutOrder = v87;
			v73:add(v91);
			v86 = v86 + 1;
		end;
	end;
	l__DisplaySkinList__35.Size = UDim2.new(0, 1090, 0, 160 + (math.ceil(v86 / 7) - 1) * 155);
	if not p21 then
		local v92 = u7:runAndReplace("startRollSetupFullRefresh");
		u8.clearContainer(l__DisplayAsssignedCases__36.Container);
		local v93 = l__Templates__6.ButtonAssignedWeapons:Clone();
		v93.TextWeapon.Text = "RANDOM";
		v93.TextCount.Text = "x" .. v72.Cases.Count;
		v93.Parent = l__DisplayAsssignedCases__36.Container;
		v92:add(u11.onReleased(v93, function()
			v1.startRollSetup(p19, nil, true);
		end));
		v92:add(v93);
		v92:add(u13.new(v93, {
			highlightColor3 = u4.inventoryBoxColorConfig.highlighted.BackgroundColor3, 
			defaultColor3 = u4.inventoryBoxColorConfig.default.BackgroundColor3
		}));
		local v94 = {};
		for v95, v96 in next, v72.Cases.Assigned do
			if v96 > 0 then
				table.insert(v94, v95);
			end;
		end;
		table.sort(v94, function(p29, p30)
			return p29 < p30;
		end);
		for v97, v98 in next, v94 do
			local v99 = l__Templates__6.ButtonAssignedWeapons:Clone();
			v99.TextWeapon.Text = u5.getWeaponDisplayName(v98);
			v99.TextCount.Text = "x" .. v72.Cases.Assigned[v98];
			v99.Parent = l__DisplayAsssignedCases__36.Container;
			v92:add(u11.onReleased(v99, function()
				v1.startRollSetup(p19, v98, true);
			end));
			v92:add(v99);
			v92:add(u13.new(v99, {
				highlightColor3 = u4.inventoryBoxColorConfig.highlighted.BackgroundColor3, 
				defaultColor3 = u4.inventoryBoxColorConfig.default.BackgroundColor3
			}));
		end;
		if v72.Cases.Count > 0 then
			local v100 = l__Templates__6.ButtonAssignedWeapons:Clone();
			v100.TextWeapon.Text = "ASSIGN MORE WEAPONS";
			v100.TextCount.Text = "";
			v100.Parent = l__DisplayAsssignedCases__36.Container;
			v92:add(u11.onReleased(v100, function()
				if u28:canPurchaseRandomItems() then
					u37.selectCase(p19, "DisplayOpenCase", function(p31)
						v1.startRollSetup(p19, p31);
					end);
					return;
				end;
				u29:activate("Disabled due to local regulations!");
			end));
			v92:add(v100);
			v92:add(u13.new(v100, {
				highlightColor3 = u4.inventoryBoxColorConfig.highlighted.BackgroundColor3, 
				defaultColor3 = u4.inventoryBoxColorConfig.default.BackgroundColor3
			}));
		end;
		v73:add(u10.new(l__DisplayAsssignedCases__36.Container, l__DisplayAsssignedCases__36.Container.UIListLayout));
		u8.clearContainer(l__DisplayRollingRates__38.Container);
		local v101 = u17.getPityData(v71)[p19] and 0;
		for v102 = 1, 5 do
			local v103 = l__Templates__6.DisplayRates:Clone();
			v103.TextRarity.Text = u4.rarityColorConfig[v102].Name;
			v103.TextRate.Text = u3.getRateText(v102, v101);
			v103.Parent = l__DisplayRollingRates__38.Container;
		end;
	end;
	u18 = p22;
end;
local u39 = shared.require("PageInventoryMenuEvents");
local u40 = shared.require("PageCreditsMenuEvents");
function v1._init()
	l__DisplayRolling__8.Visible = false;
	u8.clearContainer(l__DisplaySkinList__35.Container);
	u8.clearContainer(l__DisplayRollResults__6.Container);
	u8.clearContainer(l__DisplayAsssignedCases__36.Container);
	u11.onReleased(l__DisplayCaseSetup__7.ButtonBack, function()
		v2.goToSubPage(u18 and "DisplayInventory");
	end);
	u13.new(l__DisplayCaseSetup__7.ButtonBack, {
		highlightColor3 = u4.inventoryActionButton.highlighted.BackgroundColor3, 
		defaultColor3 = u4.inventoryActionButton.default.BackgroundColor3
	});
	l__DisplayMultiRollList__12.Visible = false;
	u11.onReleased(l__DisplayMultiRollList__12.ButtonBack, function()
		l__DisplayMultiRollList__12.Visible = false;
	end);
	u13.new(l__DisplayMultiRollList__12.ButtonBack, {
		highlightColor3 = u4.inventoryActionButton.highlighted.BackgroundColor3, 
		defaultColor3 = u4.inventoryActionButton.default.BackgroundColor3
	});
	u39.onPurchaseCaseKeyCreditUpdated:connect(function(p32, p33, p34)
		if not u2 then
			return;
		end;
		u2 = false;
		if not p32 then
			warn("PageInventoryDisplayOpenCase: purchaseCaseKey was not successful for", p33, p34);
			return;
		end;
		u3.purchaseCaseKeyCredit(u14.getPlayerData(), p33, p34);
		v1.startRollSetup(p33, u25, nil, u18);
		u29:activate("Purchase Successful!");
		u39.onInventoryChanged:fire();
		u40.onCreditsUpdated:fire();
	end);
	u39.onPurchaseCaseCreditUpdated:connect(function(p35, p36, p37, p38)
		if not u2 then
			return;
		end;
		u2 = false;
		if not p35 then
			warn("PageInventoryDisplayOpenCase: purchaseCase was not successful for", p36, p37, p38);
			return;
		end;
		u3.purchaseCaseCredit(u14.getPlayerData(), p36, p37, p38);
		v1.startRollSetup(p36, p38, nil, u18);
		u29:activate("Purchase Successful!");
		u39.onInventoryChanged:fire();
		u40.onCreditsUpdated:fire();
	end);
	u30:receive("requestRollUpdate", function(p39, p40, p41, p42, p43, p44, p45)
		u1 = false;
		if not p39 then
			warn("PageInventoryDisplayOpenCase: requestRoll was not successful for", p40, p41);
			return;
		end;
		u3.rollCase(u14.getPlayerData(), p40, p41, p42, p43, p44, p45);
		v1.startRollAnimation(p40, p41, p42, p43, p44);
		u39.onInventoryChanged:fire();
		u39.onTradeSkinListChanged:fire();
	end);
	u30:receive("requestMultiRollUpdate", function(p46, p47, p48, p49, p50)
		u1 = false;
		if not p46 then
			warn("PageInventoryDisplayOpenCase: requestMultiRoll was not successful for", p47, p48);
			return;
		end;
		u3.rollCaseMulti(u14.getPlayerData(), p47, p48, p49, p50);
		v1.startMultiRollAnimation(p47, p48, p49, p50);
		u39.onInventoryChanged:fire();
		u39.onTradeSkinListChanged:fire();
	end);
end;
return v1;

