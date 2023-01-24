
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PageSettingsMenuInterface").getPageFrame();
local u1 = shared.require("DestructorGroup").new();
local u2 = shared.require("PageSettingsMenuConfig");
local l__DisplaySettingsList__3 = v2.DisplaySettingsList;
local u4 = shared.require("MenuUtils");
local u5 = shared.require("GuiInputInterface");
local l__ContainerSettingsTab__6 = v2.ContainerSettingsTab;
local l__Templates__7 = v2.Templates;
local function u8(p1)
	local v3 = u1:runAndReplace("settingsTab");
	for v4, v5 in next, u2.displaySettings[p1] do
		local v6 = shared.require(v5)(v2, v3);
		v6.Parent = l__DisplaySettingsList__3.Container;
		v3:add(v6);
	end;
	u4.updateScrollingSize(l__DisplaySettingsList__3);
	v3:add(u5.onScrolled(l__DisplaySettingsList__3, function(p2, p3)
		l__DisplaySettingsList__3.CanvasPosition = l__DisplaySettingsList__3.CanvasPosition + Vector2.new(p3.x, p3.y);
	end));
	u5.setGroup(l__DisplaySettingsList__3, "ScrollingGroup");
end;
local u9 = shared.require("UIToggleGroup");
local u10 = shared.require("MenuColorConfig");
local u11 = shared.require("MenuPagesInterface");
local u12 = shared.require("UIHighlight");
function v1._init()
	u4.clearContainer(l__DisplaySettingsList__3.Container);
	u4.clearContainer(l__ContainerSettingsTab__6);
	local v7 = {};
	for v8, v9 in next, u2.displayTabs do
		local v10 = l__Templates__7.ButtonSettingsTab:Clone();
		u4.setText(v10, string.upper(v9));
		v10.Parent = l__ContainerSettingsTab__6;
		local v11 = {
			buttonFrame = v10
		};
		local v12 = {};
		function v12.onToggled()
			u8(v9);
		end;
		v11.buttonConfig = v12;
		v7[v9] = v11;
	end;
	local v13 = u9.new(v7, u10.loadoutClassColorConfig);
	for v14 = #u2.displayTabs, 1, -1 do
		v13:setToggle(u2.displayTabs[v14]);
	end;
	local l__ButtonBack__15 = v2.ButtonBack;
	u5.onReleased(l__ButtonBack__15, function()
		u11.goToPage("PageMainMenu");
	end);
	local v16 = u12.new(l__ButtonBack__15, {
		highlightColor3 = u10.menuColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u10.menuColorConfig.default.BackgroundColor3
	});
end;
return v1;

