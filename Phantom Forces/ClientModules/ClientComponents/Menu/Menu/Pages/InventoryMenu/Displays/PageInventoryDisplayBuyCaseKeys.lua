
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("UIPrompt");
local v3 = shared.require("PageInventoryMenuInterface").getPageFrame();
local l__DisplayBuyCaseKeys__4 = v3.DisplayBuyCaseKeys;
local l__Templates__5 = v3.Templates;
local l__DisplayCaseInfo__6 = l__DisplayBuyCaseKeys__4.DisplayCaseInfo;
local v7 = l__DisplayBuyCaseKeys__4.DisplayPromptItemPurchase;
v7.Visible = false;
local v8 = l__Templates__5.DisplayPromptConfirm:Clone();
v8.Visible = false;
v8.Parent = l__DisplayBuyCaseKeys__4;
local u1 = false;
local u2 = shared.require("DestructorGroup").new();
local u3 = shared.require("MenuUtils");
local l__DisplaySkinList__4 = l__DisplayBuyCaseKeys__4.DisplaySkinList;
local u5 = shared.require("SkinCaseUtils");
local u6 = shared.require("PageInventoryMenuUtils");
local u7 = shared.require("UIScrollingList");
local u8 = shared.require("PlayerDataStoreClient");
local l__ButtonBuyCredits__9 = l__DisplayCaseInfo__6.ButtonBuyCredits;
local l__ButtonBuyRobux__10 = l__DisplayCaseInfo__6.ButtonBuyRobux;
local u11 = shared.require("PlayerDataUtils");
local l__DisplayCaseCount__12 = l__DisplayCaseInfo__6.DisplayCaseCount;
local l__DisplayKeyCount__13 = l__DisplayCaseInfo__6.DisplayKeyCount;
local u14 = shared.require("PageInventoryMenuEvents");
local l__DisplayBuyQuantity__15 = l__DisplayCaseInfo__6.DisplayBuyQuantity;
local u16 = shared.require("UIIncrement");
local u17 = shared.require("UIHighlight");
local u18 = shared.require("MenuColorConfig");
local u19 = shared.require("GuiInputInterface");
local u20 = shared.require("ContentDatabase");
local function u21(p1, p2)
	local v9 = u2:runAndReplace("updateSkinList");
	u3.clearContainer(l__DisplaySkinList__4.Container);
	for v10, v11 in next, u5.getCaseDataset(p1).RarityPool do
		table.sort(v11, function(p3, p4)
			return p3 < p4;
		end);
		for v12, v13 in next, v11 do
			u6.drawInventorySkin(nil, v13, p2, 0, not p2).Parent = l__DisplaySkinList__4.Container;
		end;
	end;
	v9:add(u7.new(l__DisplaySkinList__4.Container, l__DisplaySkinList__4.Container.UIGridLayout));
end;
local l__DisplayAssignWeaponList__22 = l__DisplayBuyCaseKeys__4.DisplayAssignWeaponList;
local u23 = shared.require("LoadoutConfig");
local u24 = shared.require("PlayerPolicy");
local u25 = v2.new(v8, v8.Container.Confirm);
local u26 = v2.new(v7, v7.Container.Confirm, v7.Container.Cancel);
local u27 = shared.require("network");
local u28 = shared.require("PageInventoryDisplayOpenCase");
function v1.loadCaseShop(p5)
	local v14 = u2:runAndReplace("loadShopTab");
	local v15 = u5.getCaseDataset(p5);
	l__DisplayCaseInfo__6.Title.Text = string.upper(p5) .. " CASE";
	l__DisplayCaseInfo__6.DisplayCaseImage.ImageLabel.Image = "rbxassetid://" .. v15.CaseImg;
	l__ButtonBuyCredits__9.TextFrame.Text = "BUY CASES";
	l__ButtonBuyRobux__10.TextFrame.Text = "BUY CASES";
	local u29 = u8.getPlayerData();
	v14:add(u14.onInventoryChanged:connect(function()
		local v16, v17 = u11.getTotalCaseAndKeyCount(u29, p5);
		l__DisplayCaseCount__12.TextRight.Text = "x" .. v16;
		l__DisplayKeyCount__13.TextRight.Text = "x" .. v17;
		local v18 = true;
		if not (v17 > 0) then
			v18 = v16 > 0;
		end;
		l__DisplayCaseInfo__6.ButtonOpenCase.Visible = v18;
	end));
	local v19, v20 = u11.getTotalCaseAndKeyCount(u29, p5);
	l__DisplayCaseCount__12.TextRight.Text = "x" .. v19;
	l__DisplayKeyCount__13.TextRight.Text = "x" .. v20;
	local v21 = true;
	if not (v20 > 0) then
		v21 = v19 > 0;
	end;
	l__DisplayCaseInfo__6.ButtonOpenCase.Visible = v21;
	local v22 = u16.new(l__DisplayBuyQuantity__15);
	v22:setBounds(1, 100);
	v14:add(v22);
	local l__TextBox__30 = l__DisplayBuyQuantity__15.DisplayQuantity.TextBox;
	local l__cr__31 = v15.CaseCost.cr;
	local l__robux__32 = v15.CaseCost.robux;
	v14:add(v22.onChanged:connect(function(p6)
		l__TextBox__30.Text = "QTY : " .. p6;
		l__ButtonBuyCredits__9.TextCost.Text = "$" .. u3.commaValue(l__cr__31 * p6);
		l__ButtonBuyRobux__10.TextCost.Text = u3.commaValue(l__robux__32 * p6) .. " R$";
	end));
	v14:add(u17.new(l__DisplayBuyQuantity__15.Container.LeftFrame, {
		highlightColor3 = u18.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u18.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
	v14:add(u17.new(l__DisplayBuyQuantity__15.Container.RightFrame, {
		highlightColor3 = u18.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u18.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
	v14:add(u19.onReleased(l__TextBox__30, function()
		l__TextBox__30:CaptureFocus();
	end));
	v14:add(u19.onPressedOff(l__TextBox__30, function()
		l__TextBox__30:ReleaseFocus();
	end));
	v14:add(l__TextBox__30.FocusLost:Connect(function()
		local v23 = tonumber(l__TextBox__30.Text);
		if not v23 then
			l__TextBox__30.Text = "QTY : " .. v22:getValue();
			return;
		end;
		v22:setValue((math.round((math.min(math.max(v23, 1), 100)))));
	end));
	v22:setValue(1);
	local u33 = nil;
	l__DisplayCaseInfo__6.ButtonAssignWeapon.Visible = true;
	v14:add(u19.onReleased(l__DisplayCaseInfo__6.ButtonAssignWeapon, function()
		l__DisplayAssignWeaponList__22.Visible = not l__DisplayAssignWeaponList__22.Visible;
		if l__DisplayAssignWeaponList__22.Visible then
			u3.clearContainer(l__DisplayAssignWeaponList__22.Container);
			for v24, v25 in next, u23.assignableWeaponClasses do
				local v26 = u20.getWeaponList(v25.weaponClass);
				table.sort(v26, function(p7, p8)
					return p7 < p8;
				end);
				for v27, v28 in next, v26 do
					if u11.ownsWeapon(u29, v28) then
						local v29 = l__Templates__5.ButtonAssignedWeapons:Clone();
						v29.TextWeapon.Text = u20.getWeaponDisplayName(v28);
						v29.TextCount.Text = "";
						v29.Parent = l__DisplayAssignWeaponList__22.Container;
						v14:add(v29);
						v14:add(u19.onReleased(v29, function()
							u33 = v28;
							l__DisplayCaseInfo__6.ButtonAssignWeapon.TextWeapon.Text = u33 and u20.getWeaponDisplayName(u33) or "RANDOM";
							l__DisplayCaseInfo__6.ButtonAssignWeapon.TextWeapon.TextColor3 = u33 and u18.assignedWeaponColor or u18.defaultTextColor;
							u21(p5, u33);
							l__DisplayAssignWeaponList__22.Visible = false;
						end));
						v14:add(u17.new(v29, {
							highlightColor3 = u18.inventoryBoxColorConfig.default.BackgroundColor3, 
							defaultColor3 = v25.weaponClassColor
						}));
					end;
				end;
			end;
		else
			u33 = nil;
			l__DisplayCaseInfo__6.ButtonAssignWeapon.TextWeapon.Text = u33 and u20.getWeaponDisplayName(u33) or "RANDOM";
			l__DisplayCaseInfo__6.ButtonAssignWeapon.TextWeapon.TextColor3 = u33 and u18.assignedWeaponColor or u18.defaultTextColor;
			u21(p5, u33);
		end;
		v14:add(u7.new(l__DisplayAssignWeaponList__22.Container, l__DisplayAssignWeaponList__22.Container.UIGridLayout));
	end));
	v14:add(u17.new(l__DisplayCaseInfo__6.ButtonAssignWeapon, {
		highlightColor3 = u18.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u18.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
	l__DisplayCaseInfo__6.ButtonAssignWeapon.TextWeapon.Text = u33 and u20.getWeaponDisplayName(u33) or "RANDOM";
	l__DisplayCaseInfo__6.ButtonAssignWeapon.TextWeapon.TextColor3 = u33 and u18.assignedWeaponColor or u18.defaultTextColor;
	u21(p5, u33);
	v14:add(u19.onReleased(l__DisplayCaseInfo__6.ButtonBuyCredits, function()
		local v30 = v22:getValue();
		local v31 = l__cr__31 * v30;
		if not u24:canPurchaseRandomItems() then
			u25:activate("Disabled due to local regulations!");
			return;
		end;
		if u11.getPlayerCredits(u29) < v31 then
			u25:activate("Not Enough Credits!");
			return;
		end;
		u26:activate("<font color='rgb(255, 255, 255)'>PURCHASE THE FOLLOWING FOR </font>$" .. u3.commaValue(v31) .. "<font color='rgb(255, 255, 255)'>?</font>", function()
			if u1 or v8.Visible then
				local v32 = nil;
			else
				v32 = true;
			end;
			if not v32 then
				return;
			end;
			print("attempt to purchase", v30, p5, "cases");
			u27:send("purchaseCaseCredit", p5, v30, u33);
			u25:activate("Awaiting purchase...");
			u1 = true;
		end);
		u6.updateCaseImage(v7.ContainerItem.ButtonInventoryCase, p5, v30, "Case", u33 and u20.getWeaponDisplayName(u33) or "RANDOM");
	end));
	v14:add(u17.new(l__DisplayCaseInfo__6.ButtonBuyCredits, {
		highlightColor3 = u18.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u18.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
	v14:add(u19.onReleased(l__DisplayCaseInfo__6.ButtonBuyRobux, function()
		u25:activate("Robux purchasing isn't implemented!");
	end));
	v14:add(u17.new(l__DisplayCaseInfo__6.ButtonBuyRobux, {
		highlightColor3 = u18.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u18.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
	v14:add(u19.onReleased(l__DisplayCaseInfo__6.ButtonOpenCase, function()
		u28.startRollSetup(p5, u33, nil, "DisplayBuyCaseKeys");
	end));
	v14:add(u17.new(l__DisplayCaseInfo__6.ButtonOpenCase, {
		highlightColor3 = u18.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u18.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
end;
function v1.loadKeyShop(p9)
	local v33 = u2:runAndReplace("loadShopTab");
	local v34 = u5.getCaseDataset(p9);
	l__DisplayCaseInfo__6.Title.Text = string.upper(p9) .. " KEY";
	l__DisplayCaseInfo__6.DisplayCaseImage.ImageLabel.Image = "rbxassetid://" .. v34["Case KeyImg"];
	l__ButtonBuyCredits__9.TextFrame.Text = "BUY KEYS";
	l__ButtonBuyRobux__10.TextFrame.Text = "BUY KEYS";
	local u34 = u8.getPlayerData();
	v33:add(u14.onInventoryChanged:connect(function()
		local v35, v36 = u11.getTotalCaseAndKeyCount(u34, p9);
		l__DisplayCaseCount__12.TextRight.Text = "x" .. v35;
		l__DisplayKeyCount__13.TextRight.Text = "x" .. v36;
		local v37 = true;
		if not (v36 > 0) then
			v37 = v35 > 0;
		end;
		l__DisplayCaseInfo__6.ButtonOpenCase.Visible = v37;
	end));
	local v38, v39 = u11.getTotalCaseAndKeyCount(u34, p9);
	l__DisplayCaseCount__12.TextRight.Text = "x" .. v38;
	l__DisplayKeyCount__13.TextRight.Text = "x" .. v39;
	local v40 = true;
	if not (v39 > 0) then
		v40 = v38 > 0;
	end;
	l__DisplayCaseInfo__6.ButtonOpenCase.Visible = v40;
	local v41 = u16.new(l__DisplayBuyQuantity__15);
	v41:setBounds(1, 100);
	v33:add(v41);
	local l__TextBox__35 = l__DisplayBuyQuantity__15.DisplayQuantity.TextBox;
	local l__cr__36 = v34["Case KeyCost"].cr;
	local l__robux__37 = v34["Case KeyCost"].robux;
	v33:add(v41.onChanged:connect(function(p10)
		l__TextBox__35.Text = "QTY : " .. p10;
		l__ButtonBuyCredits__9.TextCost.Text = "$" .. u3.commaValue(l__cr__36 * p10);
		l__ButtonBuyRobux__10.TextCost.Text = u3.commaValue(l__robux__37 * p10) .. " R$";
	end));
	v33:add(u17.new(l__DisplayBuyQuantity__15.Container.LeftFrame, {
		highlightColor3 = u18.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u18.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
	v33:add(u17.new(l__DisplayBuyQuantity__15.Container.RightFrame, {
		highlightColor3 = u18.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u18.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
	v33:add(u19.onReleased(l__TextBox__35, function()
		l__TextBox__35:CaptureFocus();
	end));
	v33:add(u19.onPressedOff(l__TextBox__35, function()
		l__TextBox__35:ReleaseFocus();
	end));
	v33:add(l__TextBox__35.FocusLost:Connect(function()
		local v42 = tonumber(l__TextBox__35.Text);
		if not v42 then
			l__TextBox__35.Text = "QTY : " .. v41:getValue();
			return;
		end;
		v41:setValue((math.round((math.min(math.max(v42, 1), 100)))));
	end));
	v41:setValue(1);
	v33:add(u19.onReleased(l__DisplayCaseInfo__6.ButtonBuyCredits, function()
		local v43 = v41:getValue();
		local v44 = l__cr__36 * v43;
		if not u24:canPurchaseRandomItems() then
			u25:activate("Disabled due to local regulations!");
			return;
		end;
		if u11.getPlayerCredits(u34) < v44 then
			u25:activate("Not Enough Credits!");
			return;
		end;
		u26:activate("<font color='rgb(255, 255, 255)'>PURCHASE THE FOLLOWING FOR </font>$" .. u3.commaValue(v44) .. "<font color='rgb(255, 255, 255)'>?</font>", function()
			if u1 or v8.Visible then
				local v45 = nil;
			else
				v45 = true;
			end;
			if not v45 then
				return;
			end;
			print("attempt to purchase", v43, p9, "cases");
			u27:send("purchaseCaseKeyCredit", p9, v43);
			u25:activate("Awaiting purchase...");
			u1 = true;
		end);
		u6.updateCaseImage(v7.ContainerItem.ButtonInventoryCase, p9, v43, "Case Key");
	end));
	v33:add(u17.new(l__DisplayCaseInfo__6.ButtonBuyCredits, {
		highlightColor3 = u18.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u18.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
	v33:add(u19.onReleased(l__DisplayCaseInfo__6.ButtonBuyRobux, function()
		u25:activate("Robux purchasing isn't implemented!");
	end));
	v33:add(u17.new(l__DisplayCaseInfo__6.ButtonBuyRobux, {
		highlightColor3 = u18.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u18.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
	v33:add(u19.onReleased(l__DisplayCaseInfo__6.ButtonOpenCase, function()
		u28.startRollSetup(p9, nil, nil, "DisplayBuyCaseKeys");
	end));
	v33:add(u17.new(l__DisplayCaseInfo__6.ButtonOpenCase, {
		highlightColor3 = u18.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u18.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
	u21(p9);
	l__DisplayAssignWeaponList__22.Visible = false;
	l__DisplayCaseInfo__6.ButtonAssignWeapon.Visible = false;
end;
local l__DisplayCaseShopList__38 = l__DisplayBuyCaseKeys__4.DisplayCaseShopList;
local u39 = shared.require("MenuScreenGui");
function v1.loadCaseRarityTab(p11)
	local v46 = u2:runAndReplace("loadRarityTab");
	local v47 = u5.getCaseRarityList(p11);
	u3.clearContainer(l__DisplayCaseShopList__38.Container);
	l__DisplayCaseShopList__38.Container.CanvasPosition = Vector2.new(0, 0);
	table.sort(v47, function(p12, p13)
		local l__cr__48 = u5.getCaseDataset(p12).CaseCost.cr;
		local l__cr__49 = u5.getCaseDataset(p13).CaseCost.cr;
		if l__cr__48 == l__cr__49 then
			local v50 = true;
			if not (p12 < p13) then
				v50 = l__cr__48 < l__cr__49;
			end;
		else
			v50 = l__cr__48 < l__cr__49;
		end;
		return v50;
	end);
	for v51, v52 in next, v47 do
		local v53 = u5.getCaseDataset(v52);
		local v54 = l__Templates__5.ButtonCaseShopList:Clone();
		v54.TextCaseName.Text = string.upper(v52) .. " CASE";
		v54.ImageLabel.Image = "rbxassetid://" .. v53.CaseImg;
		v54.TextCostRobux.Text = u3.commaValue(v53.CaseCost.robux) .. " Robux";
		v54.TextCostCredits.Text = u3.commaValue(v53.CaseCost.cr) .. " Credits";
		v54.Parent = l__DisplayCaseShopList__38.Container;
		v46:add(v54);
		v46:add(u19.onReleased(v54, function()
			v1.loadCaseShop(v52);
		end));
		local v55 = {};
		function v55.updateFunc(p14)
			v54.HighlightFrame.Transparency = 0.3 + (1 - p14) * 0.7;
		end;
		v46:add(u17.new(v54, v55));
		if v51 == 1 then
			v1.loadCaseShop(v52);
		end;
	end;
	v46:add(u7.new(l__DisplayCaseShopList__38.Container, l__DisplayCaseShopList__38.Container.UIListLayout));
	l__DisplayCaseShopList__38.Container.CanvasSize = UDim2.fromOffset(0, (l__DisplayCaseShopList__38.Container.UIListLayout.AbsoluteContentSize.Y + 5) / u39.getUIScale());
	l__DisplayAssignWeaponList__22.Visible = false;
end;
function v1.loadKeyRarityTab(p15)
	local v56 = u2:runAndReplace("loadRarityTab");
	local v57 = u5.getCaseRarityList(p15);
	u3.clearContainer(l__DisplayCaseShopList__38.Container);
	l__DisplayCaseShopList__38.Container.CanvasPosition = Vector2.new(0, 0);
	table.sort(v57, function(p16, p17)
		local l__cr__58 = u5.getCaseDataset(p16)["Case KeyCost"].cr;
		local l__cr__59 = u5.getCaseDataset(p17)["Case KeyCost"].cr;
		if l__cr__58 == l__cr__59 then
			local v60 = true;
			if not (p16 < p17) then
				v60 = l__cr__58 < l__cr__59;
			end;
		else
			v60 = l__cr__58 < l__cr__59;
		end;
		return v60;
	end);
	for v61, v62 in next, v57 do
		local v63 = u5.getCaseDataset(v62);
		local v64 = l__Templates__5.ButtonCaseShopList:Clone();
		v64.TextCaseName.Text = string.upper(v62) .. " KEY";
		v64.ImageLabel.Image = "rbxassetid://" .. v63["Case KeyImg"];
		v64.TextCostRobux.Text = u3.commaValue(v63["Case KeyCost"].robux) .. " Robux";
		v64.TextCostCredits.Text = u3.commaValue(v63["Case KeyCost"].cr) .. " Credits";
		v64.Parent = l__DisplayCaseShopList__38.Container;
		v56:add(v64);
		v56:add(u19.onReleased(v64, function()
			v1.loadKeyShop(v62);
		end));
		local v65 = {};
		function v65.updateFunc(p18)
			v64.HighlightFrame.Transparency = 0.3 + (1 - p18) * 0.7;
		end;
		v56:add(u17.new(v64, v65));
		if v61 == 1 then
			v1.loadKeyShop(v62);
		end;
	end;
	v56:add(u7.new(l__DisplayCaseShopList__38.Container, l__DisplayCaseShopList__38.Container.UIListLayout));
	l__DisplayCaseShopList__38.Container.CanvasSize = UDim2.fromOffset(0, (l__DisplayCaseShopList__38.Container.UIListLayout.AbsoluteContentSize.Y + 5) / u39.getUIScale());
end;
local u40 = { "I", "II", "III", "IV", "V" };
local u41 = shared.require("UIToggleGroup");
local u42 = shared.require("PageCreditsMenuEvents");
function v1._init()
	u3.clearContainer(l__DisplayBuyCaseKeys__4.ContainerCaseTiers);
	u3.clearContainer(l__DisplayBuyCaseKeys__4.ContainerKeyTiers);
	l__DisplayAssignWeaponList__22.Visible = false;
	local v66 = {};
	local v67 = 1 - 1;
	while true do
		local v68 = l__Templates__5.ButtonCaseTier:Clone();
		u3.setText(v68, "TIER " .. u40[v67] .. " CASES");
		v68.Parent = l__DisplayBuyCaseKeys__4.ContainerCaseTiers;
		local v69 = {
			buttonFrame = v68
		};
		local v70 = {};
		local u43 = v67;
		function v70.onToggled()
			v1.loadCaseRarityTab(u43);
		end;
		v69.buttonConfig = v70;
		v66["Case" .. v67] = v69;
		local v71 = l__Templates__5.ButtonCaseTier:Clone();
		u3.setText(v71, "TIER " .. u40[u43] .. " KEYS");
		v71.Parent = l__DisplayBuyCaseKeys__4.ContainerKeyTiers;
		v66["Key" .. u43] = {
			buttonFrame = v71, 
			buttonConfig = {
				onToggled = function()
					v1.loadKeyRarityTab(u43);
				end
			}
		};
		if 0 <= 1 then
			if not (u43 < 5) then
				break;
			end;
		elseif not (u43 > 5) then
			break;
		end;
		u43 = u43 + 1;	
	end;
	u41.new(v66, u18.loadoutClassColorConfig):setToggle("Case1");
	u14.onPurchaseCaseCreditUpdated:connect(function(p19, p20, p21, p22)
		if not u1 then
			return;
		end;
		u1 = false;
		if not p19 then
			warn("PageInventoryDisplayBuyCaseKeys: purchaseCase was not successful for", p20, p21, p22);
			return;
		end;
		u5.purchaseCaseCredit(u8.getPlayerData(), p20, p21, p22);
		u25:activate("Purchase Successful!");
		u14.onInventoryChanged:fire();
		u42.onCreditsUpdated:fire();
	end);
	u14.onPurchaseCaseKeyCreditUpdated:connect(function(p23, p24, p25)
		if not u1 then
			return;
		end;
		u1 = false;
		if not p23 then
			warn("PageInventoryDisplayBuyCaseKeys: purchaseCaseKey was not successful for", p24, p25);
			return;
		end;
		u5.purchaseCaseKeyCredit(u8.getPlayerData(), p24, p25);
		u25:activate("Purchase Successful!");
		u14.onInventoryChanged:fire();
		u42.onCreditsUpdated:fire();
	end);
end;
return v1;

