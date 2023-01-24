
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PageLoadoutMenuInterface");
local v3 = shared.require("PlayerDataStoreClient");
local v4 = shared.require("ActiveLoadoutUtils");
local v5 = shared.require("GuiInputInterface");
local v6 = shared.require("ContentDatabase");
local v7 = v2.getPageFrame();
local l__DisplayAdvancedStats__8 = v7.DisplayAdvancedStats;
local l__TitleWeaponName__9 = l__DisplayAdvancedStats__8.TitleWeaponName;
local l__Container__10 = l__DisplayAdvancedStats__8.Container;
local u1 = shared.require("DestructorGroup").new();
local u2 = shared.require("MenuWeaponDisplayInterface");
local u3 = shared.require("PageLoadoutMenuConfig");
local u4 = nil;
local u5 = shared.require("ModifyData");
local l__Templates__6 = v7.Templates;
local u7 = shared.require("UIScrollingList");
local u8 = shared.require("MenuScreenGui");
local l__Offset__9 = l__Container__10.Position.Y.Offset;
local u10 = shared.require("MenuUtils");
local u11 = shared.require("MenuColorConfig");
function v1.updateDisplay()
	local v11 = u1:runAndReplace("updateDisplay");
	local v12 = v2.getActiveLoadoutSlot();
	local v13, v14, v15 = u2.getActiveWeaponDataToDisplay();
	if u3.loadoutSlotStatType[v12] ~= "Gun" then
		u4:setToggleState();
		v7.ButtonAdvancedStats.Visible = false;
		return;
	end;
	v7.ButtonAdvancedStats.Visible = true;
	if not v14 then
		warn("PageLoadoutMenuDisplayWeaponStats: No gun data found for weapon", v13);
		return;
	end;
	local v16, v17 = u5.getModifiedData(v14, v15, {});
	local l__advancedStatConfig__18 = u3.advancedStatConfig;
	local l__advancedStatOrder__19 = u3.advancedStatOrder;
	local l__next__20 = next;
	local v21 = nil;
	while true do
		local v22, v23 = l__next__20(l__advancedStatOrder__19, v21);
		if not v22 then
			break;
		end;
		local v24 = l__Templates__6.DisplayWeaponAdvancedStatTitle:Clone();
		v24.TextFrame.Text = string.upper(v23);
		v24.Parent = l__Container__10;
		v11:add(v24);
		for v25, v26 in next, l__advancedStatConfig__18[v23] do
			local v27 = shared.require(v26)(v14, v16, v17);
			v27.Parent = l__Container__10;
			v11:add(v27);
		end;
		if v22 < #l__advancedStatOrder__19 then
			local v28 = l__Templates__6.DisplayWeaponAdvancedStatEmpty:Clone();
			v28.Parent = l__Container__10;
			v11:add(v28);
		end;	
	end;
	v11:add(u7.new(l__DisplayAdvancedStats__8));
	task.defer(function()
		l__DisplayAdvancedStats__8.CanvasSize = UDim2.new(0, 0, 0, l__Container__10.UIListLayout.AbsoluteContentSize.Y / u8.getUIScale() + l__Offset__9 + 10);
	end);
	if u2.isPreviewing() then
		u10.setBackgroundColor3(l__DisplayAdvancedStats__8, u11.previewDisplayStatsColor);
		return;
	end;
	u10.setBackgroundColor3(l__DisplayAdvancedStats__8, u11.defaultDisplayStatsColor);
end;
local u12 = shared.require("UIToggle");
local u13 = shared.require("PageLoadoutMenuEvents");
function v1._init()
	u10.clearContainer(l__Container__10);
	l__DisplayAdvancedStats__8.Visible = false;
	u4 = u12.new(v7.ButtonAdvancedStats, u11.toggleColorConfig);
	u4.onToggleChanged:connect(function(p1)
		l__DisplayAdvancedStats__8.Visible = p1;
	end);
	u13.onWeaponStatsChanged:connect(v1.updateDisplay);
end;
return v1;

