
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PageLoadoutMenuInterface");
local v3 = shared.require("Event");
local v4 = v2.getPageFrame();
local l__DisplayWeaponSelection__5 = v4.DisplayWeaponSelection;
local u1 = shared.require("DestructorGroup").new();
local l__Templates__2 = v4.Templates;
local u3 = shared.require("UIExpander");
local u4 = shared.require("ContentDatabase");
local u5 = nil;
local u6 = shared.require("PlayerDataUtils");
local u7 = shared.require("PlayerDataStoreClient");
local l__DisplayWeaponList__8 = l__DisplayWeaponSelection__5.DisplayWeaponList;
local u9 = shared.require("GuiInputInterface");
local u10 = shared.require("MenuWeaponDisplayInterface");
local u11 = shared.require("ActiveLoadoutUtils");
local u12 = shared.require("network");
local u13 = shared.require("MenuColorConfig");
local u14 = shared.require("MenuScreenGui");
local u15 = shared.require("UIHighlight");
local u16 = shared.require("ActiveLoadoutEvents");
local u17 = shared.require("UIScrollingList");
local u18 = shared.require("LoadoutConfig");
local l__ContainerWeaponClass__19 = l__DisplayWeaponSelection__5.ContainerWeaponClass;
local function u20()
	local v6 = u1:runAndReplace("weaponList");
	local v7 = l__Templates__2.DisplayWeaponHint:Clone();
	v7.Visible = true;
	v7.Size = UDim2.new(0, 0, 0, 0);
	v7.Parent = l__DisplayWeaponSelection__5;
	v6:add(v7);
	local v8 = u3.new(v7, {
		size0 = UDim2.new(0, 0, 0, 0), 
		size1 = UDim2.new(0, 280, 0, 50), 
		speed = 65536
	});
	v6:add(v8);
	local v9 = v2.getActiveLoadoutSlot();
	for v10, v11 in next, u4.getWeaponList(u5) do
		local v12 = u4.getWeaponData(v11);
		local v13 = u6.ownsWeapon(u7.getPlayerData(), v11);
		local v14 = u4.isTestWeapon(v11);
		if not v12.hideunlessowned or v13 then
			local v15 = l__Templates__2.ButtonWeaponList:Clone();
			v15.Design.TextFrame.Text = string.upper(v12.displayname and v11);
			v15.Parent = l__DisplayWeaponList__8.Container;
			v6:add(v15);
			v6:add(u9.onReleased(v15, function()
				if not v13 then
					u10.previewWeapon(v11);
					return;
				end;
				u10.clearPreview();
				u11.changeWeapon(u7.getPlayerData(), v9, v11);
				u12:send("changeWeapon", v9, v11);
			end));
			v6:add(u9.onEntered(v15, function()
				v7.TextFrameHint.Text = v12.description and "Empty description.";
				if v12.exclusiveunlock then
					local v16 = "Exclusive Unlock";
				else
					v16 = "Rank " .. (v12.unlockrank and "N/A");
				end;
				v7.TextFrameRank.Text = v16;
				v7.TextFrameRank.TextColor3 = u13.weaponRankHintColors[v13].TextColor3;
				if u6.isNewWeapon(u7.getPlayerData(), v11) then
					v7.TextFrameRank.Text = v7.TextFrameRank.Text .. " [New]";
				end;
				task.wait();
				v7.Position = UDim2.fromOffset(425, (v15.AbsolutePosition.Y - l__DisplayWeaponSelection__5.AbsolutePosition.Y) / u14.getUIScale());
				v8:setOpenTarget(UDim2.fromOffset(280, 50 + v7.TextFrameHint.TextBounds.Y / u14.getUIScale()));
				v8:open();
			end));
			v6:add(u9.onExited(v15, function()
				v8:close();
			end));
			local v17 = v12.unlockrank and 0;
			local v18 = u13.weaponListColorConfig;
			if v14 then
				v18 = u13.testWeaponListColorConfig;
				v17 = -1;
			elseif v12.supertest then
				v18 = u13.superTestWeaponListColorConfig;
				v17 = -2;
			elseif not v13 then
				v18 = u13.lockedWeaponListColorConfig;
				v15.KillsColor.Visible = false;
			end;
			v15.LayoutOrder = v17;
			v6:add(u15.new(v15, {
				highlightColor3 = v18.highlighted.BackgroundColor3, 
				defaultColor3 = v18.default.BackgroundColor3
			}));
			v6:add(u16.onLoadoutChanged:connect(function(p1, p2)
				v15.CheckBox.CheckBoxFrame.Visible = p2[v9].Name == v11;
			end));
			v15.CheckBox.CheckBoxFrame.Visible = u11.getActiveLoadoutData(u7.getPlayerData())[v9].Name == v11;
			if u6.isNewWeapon(u7.getPlayerData(), v11) then
				v15.NewBox.Visible = true;
			else
				v15.NewBox.Visible = false;
			end;
			v15.KillsColor.Visible = false;
		end;
	end;
	v6:add(u17.new(l__DisplayWeaponList__8));
	l__DisplayWeaponList__8.Visible = true;
end;
local u21 = shared.require("UIToggleGroup");
local l__ContainerEditWeapon__22 = l__DisplayWeaponSelection__5.ContainerEditWeapon;
local u23 = shared.require("MenuUtils");
local l__ContainerLoadoutClass__24 = l__DisplayWeaponSelection__5.ContainerLoadoutClass;
local l__ContainerLoadoutSlots__25 = l__DisplayWeaponSelection__5.ContainerLoadoutSlots;
local function u26()
	local v19 = u1:runAndReplace("weaponClass");
	local v20 = u7.getPlayerData();
	local v21 = v2.getActiveLoadoutSlot();
	local v22 = {};
	for v23, v24 in next, u18.classSlots[v21][u11.getActiveClassSlot(v20)] do
		local v25 = l__Templates__2.ButtonLoadoutSlot:Clone();
		v25.Design.TextFrame.Text = string.upper(v24);
		v25.Parent = l__ContainerWeaponClass__19;
		local v26 = {
			buttonFrame = v25
		};
		local v27 = {};
		function v27.onToggled()
			u5 = v24;
			u20();
		end;
		v26.buttonConfig = v27;
		v22[v24] = v26;
		v19:add(v25);
	end;
	local v28 = u21.new(v22, u13.weaponClassColorConfig, function()
		u1:runAndReplace("weaponList");
		l__DisplayWeaponList__8.CanvasSize = UDim2.new(0, 0, 0, 0);
		l__DisplayWeaponList__8.Visible = false;
	end);
	v19:add(v28);
	u5 = u4.getWeaponClass(u11.getActiveLoadoutData(v20)[v21].Name);
	v28:setToggle(u5);
	u16.onWeaponClassChanged:fire();
end;
local u27 = shared.require("PageLoadoutMenuEvents");
local l__DisplayWeaponPurchase__28 = v4.DisplayWeaponPurchase;
local u29 = shared.require("MenuWeaponDisplayEvents");
local l__LocalPlayer__30 = game:GetService("Players").LocalPlayer;
local u31 = shared.require("UIPrompt");
local u32 = shared.require("PageCreditsMenuEvents");
function v1._init()
	u23.clearContainer(l__DisplayWeaponList__8.Container);
	u23.clearContainer(l__ContainerWeaponClass__19);
	u23.clearContainer(l__ContainerLoadoutClass__24);
	u23.clearContainer(l__ContainerLoadoutSlots__25);
	local l__ButtonBack__29 = l__DisplayWeaponSelection__5.ButtonBack;
	local u33 = shared.require("MenuPagesInterface");
	u9.onReleased(l__ButtonBack__29, function()
		u33.goToPage("PageMainMenu");
	end);
	local v30 = u15.new(l__ButtonBack__29, {
		highlightColor3 = u13.menuColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u13.menuColorConfig.default.BackgroundColor3
	});
	u9.onReleased(l__ContainerEditWeapon__22.ButtonEditAttachments, function()
		v2.goToSubPage("DisplayWeaponAttachments");
	end);
	u15.new(l__ContainerEditWeapon__22.ButtonEditAttachments, {
		highlightColor3 = u13.loadoutClassColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u13.loadoutClassColorConfig.default.BackgroundColor3
	});
	u9.onReleased(l__ContainerEditWeapon__22.ButtonEditCamo, function()
		v2.goToSubPage("DisplayWeaponCamo");
	end);
	u15.new(l__ContainerEditWeapon__22.ButtonEditCamo, {
		highlightColor3 = u13.loadoutClassColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u13.loadoutClassColorConfig.default.BackgroundColor3
	});
	local v31 = {};
	for v32, v33 in next, u18.loadoutSlotOrder do
		local v34 = l__Templates__2.ButtonLoadoutSlot:Clone();
		u23.setText(v34, string.upper(u18.loadoutSlotDisplayName[v33] and v33));
		v34.Parent = l__ContainerLoadoutSlots__25;
		local v35 = {
			buttonFrame = v34
		};
		local v36 = {};
		function v36.onToggled()
			u10.clearPreview();
			v2.setActiveLoadoutSlot(v33);
			l__ContainerEditWeapon__22.ButtonEditAttachments.Visible = #u18.attachmentSlots[v2.getActiveLoadoutSlot()] > 0;
			u26();
		end;
		v35.buttonConfig = v36;
		v31[v33] = v35;
	end;
	local v37 = u21.new(v31, u13.loadoutClassColorConfig, function()
		u1:runAndReplace("weaponList");
		u1:runAndReplace("weaponClass");
		l__DisplayWeaponList__8.CanvasSize = UDim2.new(0, 0, 0, 0);
		l__DisplayWeaponList__8.Visible = false;
	end);
	v37:setToggle(u18.loadoutSlotOrder[1]);
	u27.onActiveLoadoutSlotChanged:connect(function(p3, p4)
		if not p4 then
			return;
		end;
		v37:setToggle(p3, p4);
		l__ContainerEditWeapon__22.ButtonEditAttachments.Visible = #u18.attachmentSlots[v2.getActiveLoadoutSlot()] > 0;
		u26();
	end);
	local v38 = {};
	for v39, v40 in next, u18.classSlotOrder do
		local v41 = u7.getPlayerData();
		local v42 = l__Templates__2.ButtonLoadoutClass:Clone();
		u23.setText(v42, string.upper(v40));
		v42.Parent = l__ContainerLoadoutClass__24;
		local v43 = {
			buttonFrame = v42
		};
		local v44 = {};
		function v44.onToggled()
			u10.clearPreview();
			u11.changeClassSlot(v41, v40);
			u12:send("changeClass", v40);
		end;
		v43.buttonConfig = v44;
		v38[v40] = v43;
	end;
	local v45 = u21.new(v38, u13.loadoutClassColorConfig);
	v45:setToggle(u11.getActiveClassSlot(u7.getPlayerData()));
	local l__ButtonPurchase__34 = l__DisplayWeaponPurchase__28.ButtonPurchase;
	u29.onPreviewChanged:connect(function(p5)
		if not p5 then
			l__DisplayWeaponPurchase__28.Visible = false;
			return;
		end;
		local v46, v47, v48 = u10.getActiveWeaponDataToDisplay();
		local v49, v50, v51, v52 = u6.getWeaponBuildPrice(l__LocalPlayer__30, u7.getPlayerData(), v46, v48);
		if v47.exclusiveunlock then
			l__DisplayWeaponPurchase__28.Visible = false;
			return;
		end;
		if v50 and v52 > 0 then
			l__DisplayWeaponPurchase__28.TextFrame.Text = "COST FOR WEAPON + \n(" .. v52 .. ") ATTACHMENTS:";
			l__DisplayWeaponPurchase__28.TextFrame.Size = UDim2.new(0.55, 0, 0, 60);
			l__DisplayWeaponPurchase__28.TitleFrame.Text = "UNLOCK RANK: " .. v47.unlockrank;
		elseif v50 and v52 <= 0 then
			l__DisplayWeaponPurchase__28.TextFrame.Text = "COST TO UNLOCK WEAPON EARLY:";
			l__DisplayWeaponPurchase__28.TextFrame.Size = UDim2.new(0.45, 0, 0, 60);
			l__DisplayWeaponPurchase__28.TitleFrame.Text = "UNLOCK RANK: " .. v47.unlockrank;
		elseif not v50 and v52 > 0 then
			l__DisplayWeaponPurchase__28.TextFrame.Text = "COST TO UNLOCK (" .. v52 .. ") ATTACHMENTS:";
			l__DisplayWeaponPurchase__28.TextFrame.Size = UDim2.new(0.5, 0, 0, 60);
			l__DisplayWeaponPurchase__28.TitleFrame.Text = "UNLOCK ATTACHMENTS";
		end;
		u23.setText(l__ButtonPurchase__34, "$" .. u23.commaValue(v49));
		l__DisplayWeaponPurchase__28.Visible = true;
	end);
	l__DisplayWeaponPurchase__28.Visible = false;
	local v53 = l__Templates__2.DisplayPromptConfirm:Clone();
	v53.Parent = v4;
	local v54 = l__Templates__2.DisplayPromptPurchase:Clone();
	v54.Parent = v4;
	local u35 = false;
	local u36 = u31.new(v53, v53.Container.Confirm);
	local u37 = u31.new(v54, v54.Container.Confirm, v54.Container.Cancel);
	u9.onReleased(l__ButtonPurchase__34, function()
		if u35 then
			return;
		end;
		u23.clearContainer(v54.ContainerPurchase);
		local v55, v56, v57 = u10.getActiveWeaponDataToDisplay();
		local v58, v59, v60, v61, v62 = u6.getWeaponBuildPrice(l__LocalPlayer__30, u7.getPlayerData(), v55, v57);
		if u6.getPlayerCredits(u7.getPlayerData()) < v58 then
			u36:activate("Not enough credits!");
			return;
		end;
		local v63 = 0;
		if v59 then
			local v64 = l__Templates__2.DisplayPurchaseList:Clone();
			v64.TextSlot.Text = "<font color='rgb(55, 170, 190)'>WEAPON</font> " .. string.upper(u4.getWeaponDisplayName(v59, v60));
			v64.TextPrice.Text = "$" .. u23.commaValue(v62[v59]);
			v64.Parent = v54.ContainerPurchase;
			v63 = v63 + 1;
		end;
		for v65, v66 in next, u18.attachmentSlots[v2.getActiveLoadoutSlot()] do
			local v67 = v60[v66];
			if v67 then
				local v68 = l__Templates__2.DisplayPurchaseList:Clone();
				v68.TextSlot.Text = "<font color='rgb(55, 170, 190)'>" .. string.upper(v66) .. "</font> " .. string.upper(u4.getAttachmentDisplayName(v67));
				v68.TextPrice.Text = "$" .. u23.commaValue(v62[v66]);
				v68.Parent = v54.ContainerPurchase;
				v63 = v63 + 1;
			end;
		end;
		v54.Size = UDim2.fromOffset(405, 120 + v63 * v54.ContainerPurchase.Size.Y.Offset - 5);
		u37:activate("", function()
			local v69 = v2.getActiveLoadoutSlot();
			local v70, v71, v72 = u10.getActiveWeaponDataToDisplay();
			u12:send("purchaseWeapon", v69, v70, v72);
			u35 = true;
		end, function()
			print("cancelled purchase");
		end);
		v54.Title.Text = "<font color='rgb(255, 255, 255)'>PURCHASE THE FOLLOWING FOR </font>$" .. u23.commaValue(v58) .. "<font color='rgb(255, 255, 255)'>?</font>";
	end);
	u15.new(l__ButtonPurchase__34, {
		highlightColor3 = u13.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u13.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	});
	local v73 = l__Templates__2.DisplayPromptConfirm:Clone();
	v73.Parent = v4;
	local u38 = u31.new(v73, v73.Container.Confirm);
	u12:receive("purchaseWeaponUpdate", function(p6)
		local v74 = u7.getPlayerData();
		local v75 = v2.getActiveLoadoutSlot();
		local v76, v77, v78 = u10.getActiveWeaponDataToDisplay();
		local v79, v80, v81, v82 = u6.getWeaponBuildPrice(l__LocalPlayer__30, u7.getPlayerData(), v76, v78);
		u35 = false;
		if not p6 then
			warn("PageLoadoutMenuDisplayWeaponSelection: Attempt to purchase", v80, v81, "not successful", v79);
			return;
		end;
		u6.purchaseWeapon(l__LocalPlayer__30, v74, v75, v76, v78);
		u10.clearPreview();
		u11.changeWeapon(v74, v75, v80 and v76);
		u12:send("changeWeapon", v75, v80 and v76);
		for v83, v84 in next, v81 do
			u11.changeAttachment(v74, v75, v83, v84);
			u12:send("changeAttachment", v75, v83, v84);
		end;
		u20();
		u32.onCreditsUpdated:fire();
		u27.onForcedAttachmentListUpdate:fire();
		u38:activate("Purchase Successful!");
		print("Purchase successful");
	end);
	u16.onClassChanged:connect(function(p7)
		u26();
		v45:setToggle(p7, true);
	end);
end;
return v1;

