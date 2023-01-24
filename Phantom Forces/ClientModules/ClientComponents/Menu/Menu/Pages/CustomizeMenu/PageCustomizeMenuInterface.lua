
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("MenuScreenGui").getPageFrame("PageCustomizeMenu");
function v1.getPageFrame()
	return v2;
end;
local u1 = {};
function v1.getCurrentSubPage()
	for v3, v4 in next, u1 do
		if v4.Visible then
			return v3;
		end;
	end;
end;
local u2 = shared.require("PageCustomizeMenuEvents");
function v1.goToSubPage(p1)
	local v5 = nil;
	local l__next__6 = next;
	local v7 = nil;
	while true do
		local v8, v9 = l__next__6(u1, v7);
		if not v8 then
			break;
		end;
		if v8 == p1 then
			v5 = true;
		end;
		v9.Visible = v8 == p1;	
	end;
	if not v5 then
		warn("PageCustomizeMenuInterface: No sub page found for", p1);
		return;
	end;
	u2.onSubPageChanged:fire(p1);
end;
local u3 = shared.require("GuiInputInterface");
local u4 = shared.require("MenuPagesInterface");
local u5 = shared.require("UIHighlight");
local u6 = shared.require("MenuColorConfig");
local u7 = shared.require("PageCustomizeMenuConfig");
local u8 = shared.require("MenuUtils");
local l__Templates__9 = v2.Templates;
local u10 = shared.require("UIToggleGroup");
function v1._init()
	local l__ButtonBack__10 = v2.ButtonBack;
	u3.onReleased(l__ButtonBack__10, function()
		u4.goToPage("PageMainMenu");
	end);
	u5.new(l__ButtonBack__10, {
		highlightColor3 = u6.menuColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u6.menuColorConfig.default.BackgroundColor3
	});
	for v11, v12 in next, u7.subPageFrames do
		local v13 = v2:FindFirstChild(v12, true);
		if not v13 then
			warn("PageCustomizeMenuInterface: Unable to find display frame", v12);
		end;
		u1[v12] = v13;
	end;
	u8.clearContainer(v2.ContainerTabs);
	local v14 = {};
	for v15, v16 in next, u7.customizeTabs do
		local v17 = l__Templates__9.ButtonCustomizeTabs:Clone();
		v17.Design.TextFrame.Text = string.upper(v16);
		v17.Parent = v2.ContainerTabs;
		local v18 = {
			buttonFrame = v17
		};
		local v19 = {};
		function v19.onToggled()
			v1.goToSubPage(v15);
		end;
		v18.buttonConfig = v19;
		v14[v15] = v18;
	end;
	local u11 = u10.new(v14, u6.loadoutClassColorConfig);
	u2.onSubPageChanged:connect(function(p2, p3)
		if p3 or not u7.customizeTabs[p2] then
			return;
		end;
		u11:setToggle(p2, true);
	end);
	u11:setToggle("DisplayEditTags");
end;
return v1;

