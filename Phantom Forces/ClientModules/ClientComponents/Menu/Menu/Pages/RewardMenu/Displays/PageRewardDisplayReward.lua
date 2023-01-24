
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__DisplayReward__2 = shared.require("PageRewardMenuInterface").getPageFrame().DisplayReward;
local l__DisplayBox__3 = l__DisplayReward__2.DisplayBox;
local l__TitleText__1 = l__DisplayBox__3.TitleText;
local u2 = shared.require("PlayerDataStoreClient");
local u3 = shared.require("SkinCaseUtils");
local l__DisplayItem__4 = l__DisplayBox__3.Container.DisplayItem;
local u5 = shared.require("PageInventoryMenuEvents");
local u6 = shared.require("PlayerDataUtils");
local u7 = shared.require("PageCreditsMenuEvents");
function v1.activate(p1, p2, p3)
	local v4 = nil;
	print("New award", p1, p2, p3);
	if p1 == "Victory" then
		l__TitleText__1.Text = "MATCH VICTORY REWARD";
	elseif p1 == "Login" then
		l__TitleText__1.Text = "DAILY LOGIN REWARD";
	elseif p1 == "MVP" then
		l__TitleText__1.Text = "MVP REWARD";
	end;
	v4 = u2.getPlayerData();
	if p2 == "Case" then
		l__DisplayItem__4.ImageLabel.Image = "rbxassetid://" .. u3.getCaseDataset(p3).CaseImg;
		l__DisplayItem__4.TextItemName.Text = p3 .. " Case";
		u3.awardItem(v4, p2, p3);
		u5.onInventoryChanged:fire();
	elseif p2 == "Case Key" then
		l__DisplayItem__4.ImageLabel.Image = "rbxassetid://" .. u3.getCaseDataset(p3)["Case KeyImg"];
		l__DisplayItem__4.TextItemName.Text = p3 .. " Case Key";
		u3.awardItem(v4, p2, p3);
		u5.onInventoryChanged:fire();
	elseif p2 == "Credits" then
		l__DisplayItem__4.ImageLabel.Image = "rbxassetid://464563596";
		l__DisplayItem__4.TextItemName.Text = p3 .. " Credits";
		u6.purchaseCredits(v4, p3);
		u7.onCreditsUpdated:fire();
	end;
	l__DisplayReward__2.Visible = true;
end;
local u8 = {};
function v1.newAward(p4, p5, p6)
	if not l__DisplayReward__2.Visible then
		v1.activate(p4, p5, p6);
		return;
	end;
	table.insert(u8, { p4, p5, p6 });
end;
local u9 = shared.require("GuiInputInterface");
local u10 = shared.require("UIHighlight");
local u11 = shared.require("MenuColorConfig");
local u12 = shared.require("network");
function v1._init()
	l__DisplayReward__2.Visible = false;
	u9.onReleased(l__DisplayBox__3.Confirm, function()
		if not (#u8 > 0) then
			l__DisplayReward__2.Visible = false;
			return;
		end;
		v1.activate(unpack((table.remove(u8, 1))));
	end);
	u10.new(l__DisplayBox__3.Confirm, {
		highlightColor3 = u11.promptConfirmColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u11.promptConfirmColorConfig.default.BackgroundColor3
	});
	u12:add("displayaward", v1.newAward);
end;
return v1;

