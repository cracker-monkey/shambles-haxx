
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PageLoadoutMenuInterface");
local v3 = shared.require("ActiveLoadoutUtils");
local v4 = v2.getPageFrame();
local l__DisplayWeaponStats__5 = v4.DisplayWeaponStats;
local u1 = shared.require("DestructorGroup").new();
local u2 = shared.require("MenuWeaponDisplayInterface");
local u3 = shared.require("ContentDatabase");
local u4 = shared.require("MenuUtils");
local l__TitleWeaponName__5 = l__DisplayWeaponStats__5.TitleWeaponName;
local l__TitleWeaponRank__6 = l__DisplayWeaponStats__5.TitleWeaponRank;
local u7 = shared.require("MenuColorConfig");
local l__Templates__8 = v4.Templates;
local u9 = shared.require("PlayerDataUtils");
local u10 = shared.require("PlayerDataStoreClient");
local l__Container__11 = l__DisplayWeaponStats__5.Container;
local u12 = shared.require("LoadoutConfig");
local u13 = shared.require("PageLoadoutMenuConfig");
local u14 = shared.require("ModifyData");
local u15 = shared.require("MenuScreenGui");
local l__Offset__16 = l__DisplayWeaponStats__5.Size.X.Offset;
local l__BlackWhite__17 = game.Lighting:WaitForChild("BlackWhite");
local u18 = shared.require("PageLoadoutMenuEvents");
function v1.updateDisplay()
	local v6 = u1:runAndReplace("updateDisplay");
	local v7 = v2.getActiveLoadoutSlot();
	local v8, v9, v10 = u2.getActiveWeaponDataToDisplay();
	local v11, v12 = u2.getPreviewSettings();
	u4.setText(l__TitleWeaponName__5, string.upper((u3.getWeaponDisplayName(v8, v10))));
	u4.setText(l__TitleWeaponRank__6, string.upper("Rank " .. (v9.unlockrank and "Special")));
	if v11 == v8 then
		u4.setTextColor3(l__TitleWeaponName__5, u7.previewDisplayTextStatsColor);
	else
		u4.setTextColor3(l__TitleWeaponName__5, u7.defaultDisplayTextStatsColor);
	end;
	local v13 = l__Templates__8.DisplayWeaponStatText:Clone();
	v13.TextFrameStat.TextColor3 = u7.previewDisplayTextStatsColor;
	v13.TextFrameStat.Text = "KILLS";
	v13.TextFrameValue.Text = u9.getGunKills(u10.getPlayerData(), v8);
	v13.Parent = l__Container__11;
	v6:add(v13);
	local v14 = u12.attachmentSlots[v7];
	if not v14 then
		warn("PageLoadoutMenuDisplayWeaponStats: No attachment slot stat config found for", v7);
		return;
	end;
	local l__next__15 = next;
	local v16 = nil;
	while true do
		local v17, v18 = l__next__15(v14, v16);
		if not v17 then
			break;
		end;
		local v19 = l__Templates__8.DisplayWeaponStatText:Clone();
		local v20 = nil;
		if v10 then
			v20 = v10[v18];
		end;
		local v21 = v20;
		if v20 and v20 ~= "" then
			v21 = u3.getAttachmentDisplayName(v20);
			if v12[v18] == v20 then
				v19.TextFrameValue.TextColor3 = u7.previewDisplayTextStatsColor;
			end;
		end;
		v19.TextFrameStat.Text = string.upper(v18);
		if not v21 or v21 == "" then
			local v22 = "Default";
		else
			v22 = v21;
		end;
		v19.TextFrameValue.Text = string.upper(v22);
		v19.Parent = l__Container__11;
		v6:add(v19);	
	end;
	local v23 = u13.loadoutSlotStatConfig[u13.loadoutSlotStatType[v7]];
	if not v23 then
		warn("PageLoadoutMenuDisplayWeaponStats: No loadout slot stat config found for", v7);
		return;
	end;
	local v24, v25 = u14.getModifiedData(v9, v10, {});
	for v26, v27 in next, v23 do
		if v27 == "" then
			local v28 = l__Templates__8.DisplayWeaponStatEmpty:Clone();
			v28.Parent = l__Container__11;
			v6:add(v28);
		else
			local v29 = shared.require(v27)(v9, v24, v25);
			v29.Parent = l__Container__11;
			v6:add(v29);
		end;
	end;
	l__DisplayWeaponStats__5.Size = UDim2.new(0, l__Offset__16, 0, 65 + l__Container__11.UIListLayout.AbsoluteContentSize.Y / u15.getUIScale());
	if u2.isPreviewing() then
		u4.setBackgroundColor3(l__DisplayWeaponStats__5, u7.previewDisplayStatsColor);
		l__BlackWhite__17.Saturation = -1;
	else
		u4.setBackgroundColor3(l__DisplayWeaponStats__5, u7.defaultDisplayStatsColor);
		l__BlackWhite__17.Saturation = 0;
	end;
	u18.onWeaponStatsChanged:fire(v7);
end;
local u19 = shared.require("MenuWeaponDisplayEvents");
local u20 = shared.require("ActiveLoadoutEvents");
local u21 = shared.require("MenuPagesEvents");
local l__TweenService__22 = game:GetService("TweenService");
function v1._init()
	u4.clearContainer(l__Container__11);
	v1.updateDisplay();
	u19.onPreviewChanged:connect(v1.updateDisplay);
	u20.onWeaponClassChanged:connect(v1.updateDisplay);
	u20.onLoadoutChanged:connect(v1.updateDisplay);
	local v30 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
	u15.onDisabled:connect(function()
		l__BlackWhite__17.Enabled = false;
	end);
	u15.onEnabled:connect(function()
		l__BlackWhite__17.Enabled = true;
		v1.updateDisplay();
	end);
	u21.onPageChanged:connect(function(p1)
		local v31 = {};
		if p1 == "PageLoadoutMenu" and u2.isPreviewing() then
			v31.Saturation = -1;
		else
			v31.Saturation = 0;
		end;
		l__TweenService__22:Create(l__BlackWhite__17, v30, v31):Play();
	end);
end;
return v1;

