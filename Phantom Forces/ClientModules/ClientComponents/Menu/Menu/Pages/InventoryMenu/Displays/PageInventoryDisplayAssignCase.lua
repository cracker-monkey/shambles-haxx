
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PageInventoryMenuInterface");
local v3 = shared.require("MenuScreenGui");
local v4 = shared.require("UIPrompt");
local v5 = v2.getPageFrame();
local l__DisplayAssignCase__6 = v5.DisplayAssignCase;
local l__Templates__7 = v5.Templates;
local l__DisplayWeaponList__8 = l__DisplayAssignCase__6.DisplayWeaponList;
local l__DisplayCaseInfo__9 = l__DisplayAssignCase__6.DisplayCaseInfo;
local l__DisplayPromptAssignCase__10 = l__DisplayWeaponList__8.DisplayPromptAssignCase;
local v11 = l__Templates__7.DisplayPromptConfirm:Clone();
v11.Parent = l__DisplayWeaponList__8;
local u1 = shared.require("PlayerDataStoreClient");
local u2 = shared.require("PlayerDataUtils");
local u3 = shared.require("SkinCaseUtils");
local u4 = shared.require("DestructorGroup").new();
local l__DisplayCaseCount__5 = l__DisplayCaseInfo__9.DisplayCaseCount;
local l__DisplayCaseImage__6 = l__DisplayCaseInfo__9.DisplayCaseImage;
local l__DisplayBuyQuantity__7 = l__DisplayCaseInfo__9.DisplayBuyQuantity;
local u8 = shared.require("UIIncrement");
local l__DisplayAssignCost__9 = l__DisplayCaseInfo__9.DisplayAssignCost;
local u10 = shared.require("UIHighlight");
local u11 = shared.require("MenuColorConfig");
local u12 = shared.require("GuiInputInterface");
local u13 = shared.require("MenuUtils");
local u14 = shared.require("LoadoutConfig");
local u15 = shared.require("ContentDatabase");
local u16 = false;
local u17 = v4.new(v11, v11.Container.Confirm);
local u18 = v4.new(l__DisplayPromptAssignCase__10, l__DisplayPromptAssignCase__10.Container.Confirm, l__DisplayPromptAssignCase__10.Container.Cancel);
local u19 = shared.require("network");
local u20 = shared.require("UIScrollingList");
local u21 = nil;
local u22 = nil;
function v1.selectCase(p1, p2, p3)
	local v12 = u1.getPlayerData();
	local v13 = u2.getCasePacketData(v12, p1);
	if not v13 then
		warn("PageInventoryDisplayAssignCase: No casePacketData found for", p1);
		return;
	end;
	local v14 = u3.getCaseAssignCost(p1);
	local l__Count__15 = v13.Cases.Count;
	if l__Count__15 <= 0 then
		v2.goToSubPage(p2);
		return;
	end;
	local v16 = u4:runAndReplace("selectCase");
	v2.goToSubPage("DisplayAssignCase");
	l__DisplayCaseInfo__9.Title.Text = p1;
	l__DisplayCaseCount__5.TextRight.Text = "x" .. l__Count__15;
	l__DisplayCaseImage__6.ImageLabel.Image = "rbxassetid://" .. u3.getCaseDataset(p1).CaseImg;
	local v17 = u8.new(l__DisplayBuyQuantity__7);
	v17:setBounds(1, l__Count__15);
	v16:add(v17);
	local l__TextBox__23 = l__DisplayBuyQuantity__7.DisplayQuantity.TextBox;
	v16:add(v17.onChanged:connect(function(p4)
		l__TextBox__23.Text = "QTY : " .. p4;
		l__DisplayAssignCost__9.TextRight.Text = "$" .. v14 * p4;
	end));
	v16:add(u10.new(l__DisplayBuyQuantity__7.Container.LeftFrame, {
		highlightColor3 = u11.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u11.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
	v16:add(u10.new(l__DisplayBuyQuantity__7.Container.RightFrame, {
		highlightColor3 = u11.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u11.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
	v16:add(u12.onReleased(l__TextBox__23, function()
		l__TextBox__23:CaptureFocus();
	end));
	v16:add(u12.onPressedOff(l__TextBox__23, function()
		l__TextBox__23:ReleaseFocus();
	end));
	v16:add(l__TextBox__23.FocusLost:Connect(function()
		local v18 = tonumber(l__TextBox__23.Text);
		if not v18 then
			l__TextBox__23.Text = "QTY : " .. v17:getValue();
			return;
		end;
		v17:setValue((math.round((math.min(math.max(v18, 1), l__Count__15)))));
	end));
	v17:setValue(1);
	u13.clearContainer(l__DisplayWeaponList__8.Container);
	for v19, v20 in next, u14.assignableWeaponClasses do
		local v21 = u15.getWeaponList(v20.weaponClass);
		table.sort(v21, function(p5, p6)
			return p5 < p6;
		end);
		for v22, v23 in next, v21 do
			if u2.ownsWeapon(v12, v23) then
				local v24 = u15.getWeaponDisplayName(v23);
				local v25 = l__Templates__7.ButtonAssignedWeapons:Clone();
				v25.TextWeapon.Text = v24;
				v25.TextCount.Text = "";
				v25.Parent = l__DisplayWeaponList__8.Container;
				v16:add(v25);
				v16:add(u12.onReleased(v25, function()
					if not (not l__DisplayPromptAssignCase__10.Visible) or not (not v11.Visible) or u16 then
						return;
					end;
					local v26 = v17:getValue();
					local v27 = v14 * v26;
					if u2.getPlayerCredits(v12) < v27 then
						u17:activate("Not Enough Credits!");
						return;
					end;
					l__DisplayPromptAssignCase__10.Desc.Text = v24 .. " -> " .. string.upper(p1) .. " CASE (<font color='rgb(255, 216, 61)'>x" .. v26 .. "</font>)";
					u18:activate("<font color='rgb(255, 255, 255)'>ASSIGN WEAPON CASE:</font>\t\t$" .. u13.commaValue(v27), function()
						u19:send("purchaseCaseAssign", p1, v26, v23);
						u17:activate("Awaiting purchase...");
						u16 = true;
						print("Attempt to purchase weapon", v23, p1, v26);
					end, function()

					end);
				end));
				v16:add(u10.new(v25, {
					highlightColor3 = u11.inventoryBoxColorConfig.default.BackgroundColor3, 
					defaultColor3 = v20.weaponClassColor
				}));
			end;
		end;
	end;
	v16:add(u20.new(l__DisplayWeaponList__8.Container, l__DisplayWeaponList__8.Container.UIGridLayout));
	u21 = p2;
	u22 = p3;
end;
local u24 = shared.require("PageInventoryMenuEvents");
local u25 = shared.require("PageCreditsMenuEvents");
function v1._init()
	u13.clearContainer(l__DisplayWeaponList__8.Container);
	l__DisplayPromptAssignCase__10.Visible = false;
	local l__ButtonBack__28 = l__DisplayCaseInfo__9.ButtonBack;
	u12.onReleased(l__ButtonBack__28, function()
		v2.goToSubPage(u21 and "DisplayInventory");
	end);
	u10.new(l__ButtonBack__28, {
		highlightColor3 = u11.inventoryActionButton.highlighted.BackgroundColor3, 
		defaultColor3 = u11.inventoryActionButton.default.BackgroundColor3
	});
	u19:receive("purchaseCaseAssignUpdate", function(p7, p8, p9, p10)
		u16 = false;
		if not p7 then
			warn("PageInventoryDisplayAssignCase: purchaseCaseAssign was not successful for", p8, p9, p10);
			u17:activate("Purchase failed!");
			return;
		end;
		u3.purchaseCaseAssign(u1.getPlayerData(), p8, p9, p10);
		u17:activate("Purchase Successful!", function()
			if u22 then
				u22(p10);
				return;
			end;
			v1.selectCase(p8, u21);
		end);
		u24.onInventoryChanged:fire();
		u25.onCreditsUpdated:fire();
	end);
end;
return v1;

