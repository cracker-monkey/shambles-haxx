
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PageCreditsMenuEvents");
local v3 = shared.require("MenuScreenGui");
local v4 = shared.require("UIPrompt");
local v5 = shared.require("PageInventoryMenuInterface").getPageFrame();
local l__DisplayTradeIns__6 = v5.DisplayTradeIns;
local l__DisplayRolling__7 = l__DisplayTradeIns__6.DisplayRolling;
local u1 = {};
local u2 = shared.require("SkinCaseUtils");
local u3 = 0;
local u4 = shared.require("PageInventoryMenuConfig");
local function u5(p1)
	if not u1[1] then
		return true;
	end;
	local v8 = u2.getSkinDataset(u1[1].skinName);
	local v9 = u2.getSkinDataset(p1);
	local l__Tier__10 = u2.getCaseDataset(v8.Case).Tier;
	local l__Tier__11 = u2.getCaseDataset(v9.Case).Tier;
	local v12 = false;
	if v8.Rarity == v9.Rarity then
		v12 = l__Tier__10 == l__Tier__11;
	end;
	return v12;
end;
local u6 = shared.require("PageInventoryMenuEvents");
local u7 = 1;
local u8 = 1;
local u9 = shared.require("MenuColorConfig");
local l__Templates__10 = v5.Templates;
local u11 = shared.require("ContentDatabase");
local l__DisplayRollResults__12 = l__DisplayTradeIns__6.DisplayRollResults;
local u13 = shared.require("DestructorGroup").new();
function v1.displayRolledSkin(p2, p3, p4)
	local v13 = nil;
	if p4 and u2.isLegendaryWeapon(p4) then
		local v14 = u2.getSkinDataset(p4);
		v13 = true;
	else
		v14 = u2.getSkinDataset(p3);
	end;
	local v15 = u9.rarityColorConfig[v14.Rarity and 0];
	local v16 = l__Templates__10.DisplayRolledSkin:Clone();
	v16.TextItemName.Text = v14.DisplayName and p3;
	v16.ImageLabel.Image = "rbxassetid://" .. v14.TextureId;
	v16.Design.BackFrame.BorderColor3 = v15.Color;
	v16.TextWeapon.Text = p4 and u11.getWeaponDisplayName(p4) or "RANDOM";
	if v14.Unlocked then
		local v17 = " / Customizable";
	else
		v17 = "";
	end;
	v16.TextRarity.Text = v15.Name .. v17;
	if v14.ImageColor then
		v16.ImageFrame.BackgroundColor3 = v14.ImageColor;
	end;
	if v13 then
		local v18 = u2.getSkinDataset(p3);
		v16.LegendaryTexture.Image = "rbxassetid://" .. v18.TextureId;
		v16.LegendaryTexture.BorderColor3 = u9.rarityColorConfig[v18.Rarity and 0].Color;
		if v18.ImageColor then
			v16.LegendaryTexture.BackgroundColor3 = v18.ImageColor;
		end;
		v16.LegendaryTexture.Visible = true;
	end;
	v16.Position = UDim2.new(0, 0, 0, -120);
	v16.Parent = l__DisplayRollResults__12.Container;
	local v19 = #l__DisplayRollResults__12.Container:GetChildren();
	for v20 = #l__DisplayRollResults__12.Container:GetChildren(), 1, -1 do
		local v21 = l__DisplayRollResults__12.Container:GetChildren()[v20];
		v21:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true);
		local v22 = 0 + (v21.Size.Y.Offset + 5);
		if v19 - v20 > 10 then
			u13:run(v21);
		end;
	end;
	u13:add(v16):add(v16);
end;
local u14 = shared.require("PlayerDataStoreClient");
local u15 = shared.require("MenuUtils");
local l__DisplayRollingList__16 = l__DisplayRolling__7.DisplayRollingList;
local u17 = shared.require("PageInventoryMenuUtils");
local u18 = shared.require("GameClock");
local u19 = shared.require("GuiInputInterface");
local u20 = shared.require("UIHighlight");
function v1.startRollAnimation(p5, p6, p7, p8)
	local v23 = u13:runAndReplace("startRollAnimation");
	local v24 = u2.getSkinDataset(p6);
	local v25 = u14.getPlayerData();
	u15.clearContainer(l__DisplayRollingList__16.Container);
	l__DisplayRolling__7.Visible = true;
	local v26 = math.random(40, 60);
	for v27 = 1, 70 do
		if v27 == v26 then
			local v28 = p6;
			local v29 = p7;
		else
			local v30 = nil;
			v30 = u2.getCaseDataset(u2.getSkinDataset(p5[math.random(1, #p5)].skinName).Case);
			if p8 then
				local v31 = v30.RarityPool[math.ceil(math.random() * 4)];
				v28 = v31[math.random(1, #v31)];
				local v32 = u2.getLegendaryWeaponList(v25);
				v29 = v32[math.random(1, #v32)];
			else
				local v33 = v30.RarityPool[v24.Rarity];
				v28 = v33[math.random(1, #v33)];
				local v34 = u2.getAllowedWeaponList(v25);
				v29 = v34[math.random(1, #v34)];
			end;
		end;
		local v35 = u17.drawInventorySkin(nil, v28, v29, 0);
		v35.Parent = l__DisplayRollingList__16.Container;
		v35.Size = UDim2.new(0, 140, 0, 140);
		v23:add(v35);
	end;
	local v36 = u18.getTime() + 4 + math.random() * 3;
	local u21 = nil;
	local l__Case__22 = v24.Case;
	local function v37(p9)
		if p9 ~= Enum.TweenStatus.Completed then
			return;
		end;
		u21 = true;
		l__DisplayRolling__7.Visible = false;
		v1.displayRolledSkin(l__Case__22, p6, p7);
	end;
	l__DisplayRollingList__16.Container.Position = UDim2.new(0, 0, 0.5, 0);
	l__DisplayRollingList__16.Container:TweenPosition(UDim2.new(0, 425 - 145 * v26 + math.random(-55, 55), 0.5, 0), "Out", "Quart", v36 - u18.getTime(), true, v37);
	l__DisplayRolling__7.ButtonSkip.Visible = true;
	delay(v36 - u18.getTime() - 3, function()
		if u21 then
			return;
		end;
		l__DisplayRolling__7.ButtonSkip.Visible = false;
	end);
	local u23 = nil;
	local u24 = v36;
	v23:add(u19.onReleased(l__DisplayRolling__7.ButtonSkip, function()
		if not u23 then
			u23 = true;
			l__DisplayRolling__7.ButtonSkip.Visible = false;
			u24 = 1;
			l__DisplayRollingList__16.Container.Position = UDim2.new(0, 425 - 145 * (v26 - 2), 0.5, 0);
			l__DisplayRollingList__16.Container:TweenPosition(UDim2.new(0, 425 - 145 * v26 + math.random(-55, 55), 0.5, 0), "Out", "Quart", u24, true, v37);
		end;
	end));
	v23:add(u20.new(l__DisplayRolling__7.ButtonSkip, {
		highlightColor3 = u9.promptConfirmColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u9.promptConfirmColorConfig.default.BackgroundColor3
	}));
end;
local l__DisplayTradeSetup__25 = l__DisplayTradeIns__6.DisplayTradeSetup;
local u26 = false;
function v1.updatePickedList()
	local v38 = u13:runAndReplace("updatePickedList");
	u15.clearContainer(l__DisplayTradeSetup__25.Container);
	for v39 = 1, u2.tradeInRequirement do
		local v40 = u1[v39];
		if v40 then
			local v41 = u17.drawInventorySkin(nil, v40.skinName, v40.weaponName, 0);
			v41.Size = UDim2.fromOffset(140, 140);
			v41.Parent = l__DisplayTradeSetup__25.Container;
			v38:add(v41);
			local v42 = {};
			function v42.updateFunc(p10)
				v41.HighlightFrame.Transparency = 0.3 + (1 - p10) * 0.7;
			end;
			v38:add(u20.new(v41, v42));
			v38:add(u19.onReleased(v41, function()
				if u26 then
					return;
				end;
				if #u1 < v39 then
					warn("PageInventoryDisplayTradeIns: Attempt to remove invalid index from picked list", u1, v39);
					return;
				end;
				table.remove(u1, v39);
				u6.onTradePickedListChanged:fire();
			end));
		else
			local v43 = l__Templates__10.ButtonInventorySkinEmpty:Clone();
			v43.Size = UDim2.fromOffset(140, 140);
			v43.Parent = l__DisplayTradeSetup__25.Container;
			v38:add(v43);
		end;
	end;
end;
function v1.goPrevPage()
	local v44 = nil;
	v44 = math.max(1, math.ceil(u3 / u4.maxItemsPerPage));
	if u8 - 1 <= 0 then
		u8 = v44;
	elseif v44 < u8 then
		u8 = v44;
	else
		u8 = u8 - 1;
	end;
	u6.onTradeSkinListChanged:fire();
end;
function v1.goNextPage()
	local v45 = math.max(1, math.ceil(u3 / u4.maxItemsPerPage));
	if u8 < 1 then
		u8 = 1;
	elseif v45 < u8 + 1 then
		u8 = 1;
	else
		u8 = u8 + 1;
	end;
	u6.onTradeSkinListChanged:fire();
end;
local l__DisplaySkinList__27 = l__DisplayTradeIns__6.DisplaySkinList;
local u28 = shared.require("PlayerDataUtils");
local function u29(p11)
	local v46 = {};
	local v47 = {};
	for v48, v49 in next, p11 do
		local l__Cases__50 = v49.Cases;
		local v51 = u2.getCaseDataset(v48);
		for v52, v53 in next, v49.Skins do
			for v54, v55 in next, v53 do
				if not u2.isLegendaryWeapon(v54) and u5(v52) then
					local v56 = 0;
					for v57, v58 in next, u1 do
						if not v47[v57] and v58.skinName == v52 and v58.weaponName == v54 then
							v47[v57] = true;
							v56 = v56 + 1;
						end;
					end;
					for v59 = 1, v55 - v56 do
						table.insert(v46, {
							Type = "Skin", 
							Name = v52, 
							Case = v48, 
							Weapon = v54
						});
					end;
				end;
			end;
		end;
	end;
	return v46;
end;
local u30 = {};
local function u31(p12, p13)
	if #u1 < u2.tradeInRequirement then
		if u1[1] and not u5(p12) then
			warn("PageInventoryDisplayTradeIns: Current picked skin incompatible with first picked skin", u1[1], p12);
			return;
		end;
		if #u1 <= 0 then
			u7 = u8;
		end;
		table.insert(u1, {
			skinName = p12, 
			weaponName = p13
		});
		u6.onTradePickedListChanged:fire();
	end;
end;
local l__DisplayPageCount__32 = l__DisplayTradeIns__6.DisplayPageCount;
function v1.updateSkinList(p14)
	local v60 = u13:runAndReplace("updateSkinList");
	u15.clearContainer(l__DisplaySkinList__27.Container);
	local v61 = u29((u28.getInventoryData((u14.getPlayerData()))));
	u3 = #v61;
	local v62 = math.max(1, math.ceil(u3 / u4.maxItemsPerPage));
	if p14 and #u1 <= 0 then
		u8 = math.min(u7, v62);
	elseif v62 < u8 then
		u8 = v62;
	end;
	local v63 = {};
	local u33 = 0;
	local u34 = (u8 - 1) * u4.maxItemsPerPage;
	if #u30 > 0 then
		local v64 = {};
		local l__next__65 = next;
		local v66 = nil;
		while true do
			local v67, v68 = l__next__65(v61, v66);
			if not v67 then
				break;
			end;
			v64[v68] = u17.termDist(u30, u17.separate({ u9.rarityColorConfig[u2.getSkinRarity(v68.Name)].Name, v68.Name, v68.Case, v68.Type, v68.Weapon and u11.getWeaponDisplayName(v68.Weapon), v68.Weapon and u11.getWeaponData(v68.Weapon).type }));		
		end;
		table.sort(v61, function(p15, p16)
			if v64[p15] == v64[p16] then
				return u17.sortSkins(p15, p16);
			end;
			return v64[p15] < v64[p16];
		end);
	else
		table.sort(v61, u17.sortSkins);
	end;
	local l__next__69 = next;
	local v70 = nil;
	while true do
		local v71, v72 = l__next__69(v61, v70);
		if not v71 then
			break;
		end;
		local v73 = false;
		if u34 <= u33 then
			v73 = u33 < u34 + u4.maxItemsPerPage;
		end;
		if v73 then
			local l__Name__74 = v72.Name;
			local l__Weapon__75 = v72.Weapon;
			local v76 = u17.drawInventorySkin(nil, l__Name__74, l__Weapon__75, 0);
			v76.Parent = l__DisplaySkinList__27.Container;
			v60:add(v76);
			local v77 = {};
			function v77.updateFunc(p17)
				v76.HighlightFrame.Transparency = 0.3 + (1 - p17) * 0.7;
			end;
			v60:add(u20.new(v76, v77));
			v60:add(u19.onReleased(v76, function()
				if u26 then
					return;
				end;
				u31(l__Name__74, l__Weapon__75);
			end));
			v76.ContainerDropMenu.Visible = false;
		end;
		u33 = u33 + 1;	
	end;
	l__DisplayPageCount__32.DisplayQuantity.TextLabel.Text = u8 .. "/" .. math.max(1, math.ceil(u3 / u4.maxItemsPerPage));
end;
local u35 = false;
local u36 = shared.require("network");
function v1._init()
	u15.clearContainer(l__DisplayRollResults__12.Container);
	l__DisplayRolling__7.Visible = false;
	v1.updateSkinList();
	local l__ButtonPrev__78 = l__DisplayPageCount__32.ButtonPrev;
	u19.onReleased(l__ButtonPrev__78, function()
		v1.goPrevPage();
	end);
	u20.new(l__ButtonPrev__78, {
		highlightColor3 = u9.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u9.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	});
	local l__ButtonNext__79 = l__DisplayPageCount__32.ButtonNext;
	u19.onReleased(l__ButtonNext__79, function()
		v1.goNextPage();
	end);
	u20.new(l__ButtonNext__79, {
		highlightColor3 = u9.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u9.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	});
	local l__ButtonInventorySearch__80 = l__DisplayTradeIns__6.ButtonInventorySearch;
	l__ButtonInventorySearch__80.TextBox.Focused:connect(function()
		u35 = true;
	end);
	l__ButtonInventorySearch__80.TextBox.FocusLost:connect(function(p18)
		u35 = false;
		if l__ButtonInventorySearch__80.TextBox.Text == "" then
			u30 = {};
			l__ButtonInventorySearch__80.TextBox.Text = "SEARCH";
			u6.onTradeSkinListChanged:fire(true);
		end;
	end);
	u19.onReleased(l__ButtonInventorySearch__80.TextBox, function()
		l__ButtonInventorySearch__80.TextBox:CaptureFocus();
	end);
	u19.onPressedOff(l__ButtonInventorySearch__80.TextBox, function()
		l__ButtonInventorySearch__80.TextBox:ReleaseFocus();
	end);
	l__ButtonInventorySearch__80.TextBox.Changed:connect(function(p19)
		if p19 == "Text" and u35 then
			u30 = {};
			for v81 in string.gmatch(string.lower(l__ButtonInventorySearch__80.TextBox.Text), "%w+") do
				u30[#u30 + 1] = v81;
			end;
			u6.onTradeSkinListChanged:fire(true);
		end;
	end);
	u19.onReleased(l__DisplayTradeSetup__25.ButtonRoll, function()
		if #u1 ~= u2.tradeInRequirement or u26 then
			return;
		end;
		u26 = true;
		u36:send("requestTradeRoll", u1);
	end);
	u20.new(l__DisplayTradeSetup__25.ButtonRoll, {
		highlightColor3 = u9.promptConfirmColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u9.promptConfirmColorConfig.default.BackgroundColor3
	});
	l__DisplayTradeSetup__25.ButtonRoll.Visible = false;
	l__DisplayTradeSetup__25.TextRollUpdate.Visible = false;
	u6.onTradeSkinListChanged:connect(v1.updateSkinList);
	u6.onTradePickedListChanged:connect(function()
		v1.updateSkinList(true);
		v1.updatePickedList();
		if #u1 ~= u2.tradeInRequirement then
			l__DisplayTradeSetup__25.ButtonRoll.Visible = false;
			l__DisplayTradeSetup__25.TextRollUpdate.Visible = false;
			return;
		end;
		l__DisplayTradeSetup__25.ButtonRoll.Visible = true;
		l__DisplayTradeSetup__25.TextRollUpdate.Visible = true;
		local v82 = "";
		local v83 = nil;
		local v84 = {};
		for v85, v86 in next, u1 do
			local v87 = u2.getSkinDataset(v86.skinName);
			if not table.find(v84, v87.Case) then
				table.insert(v84, v87.Case);
			end;
			v83 = v87.Rarity + 1;
		end;
		table.sort(v84, function(p20, p21)
			return p20 < p21;
		end);
		local l__next__88 = next;
		local v89 = nil;
		while true do
			local v90 = nil;
			local v91 = nil;
			v91, v90 = l__next__88(v84, v89);
			if not v91 then
				break;
			end;
			v89 = v91;
			if v91 == 1 then
				v82 = v90;
			else
				v82 = v82 .. ", " .. v90;
			end;		
		end;
		local l__Color__92 = u9.rarityColorConfig[v83].Color;
		l__DisplayTradeSetup__25.TextRollUpdate.Text = "Receive one " .. "" .. u9.rarityColorConfig[v83].Name .. "" .. " skin from the possible following cases {" .. v82 .. "}";
	end);
	u36:receive("requestTradeRollUpdate", function(p22, p23, p24, p25, p26)
		u26 = false;
		if not p22 then
			warn("PageInventoryDisplayTradeIns: requestTradeRoll was not successful for", p23);
			u1 = {};
			u6.onTradePickedListChanged:fire();
			return;
		end;
		u2.rollTrade(u14.getPlayerData(), p23, p24, p25, p26);
		v1.startRollAnimation(p23, p24, p25, p26);
		u6.onInventoryChanged:fire();
		u6.onTradeSkinListChanged:fire();
		u1 = {};
		u6.onTradePickedListChanged:fire();
	end);
end;
return v1;

