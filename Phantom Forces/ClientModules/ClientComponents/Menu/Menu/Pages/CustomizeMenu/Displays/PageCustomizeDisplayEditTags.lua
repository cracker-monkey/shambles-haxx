
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("PageCustomizeMenuConfig");
local v2 = shared.require("UIPrompt");
local v3 = shared.require("PageCustomizeMenuInterface").getPageFrame();
local l__DisplayEditTags__4 = v3.DisplayEditTags;
local l__DisplayPromptPurchaseTag__5 = l__DisplayEditTags__4.DisplayPromptPurchaseTag;
local l__DisplayTagFrame__6 = l__DisplayEditTags__4.DisplayTagFrame;
local l__DisplayPreviewTag__7 = l__DisplayTagFrame__6.DisplayPreviewTag;
local v8 = v3.Templates.DisplayPromptConfirm:Clone();
v8.Parent = l__DisplayEditTags__4;
local u1 = {
	r = 255, 
	g = 255, 
	b = 255
};
local u2 = shared.require("PlayerDataStoreClient");
local u3 = shared.require("PlayerDataUtils");
local u4 = {};
local u5 = shared.require("RichTextUtils");
local l__Name__6 = game:GetService("Players").LocalPlayer.Name;
local l__Color__7 = BrickColor.new("Bright blue").Color;
local function u8()
	return Color3.fromRGB(u1.r, u1.g, u1.b);
end;
local l__DisplayCurrentTag__9 = l__DisplayTagFrame__6.DisplayCurrentTag;
local l__DisplayEditColors__10 = l__DisplayTagFrame__6.DisplayEditColors;
local u11 = shared.require("MenuUtils");
function u4.updateCurrentTag(p1)
	local v9 = u3.getTagData((u2.getPlayerData()));
	local l__text__10 = v9.text;
	if p1 then
		u1.r = v9.r;
		u1.g = v9.g;
		u1.b = v9.b;
		u4.updatePreviewTag("");
	end;
	if l__text__10 == "" then
		local v11 = "";
	else
		v11 = u5.formatTextColor3("=" .. u5.escapeForbiddenCharacters(l__text__10) .. "=", u8());
	end;
	l__DisplayCurrentTag__9.DisplayTagValue.TextFrame.Text = l__text__10;
	l__DisplayCurrentTag__9.DisplaySampleChat.TextFrame.Text = v11 .. "" .. u5.formatTextColor3(l__Name__6 .. ":", l__Color__7) .. " hi I am playing Phantom Forces";
	local v12 = Color3.fromRGB(u1.r, u1.g, u1.b);
	l__DisplayEditColors__10.DisplayHexValue.TextFrame.Text = "HEX COLOR: " .. string.upper(v12:ToHex());
	l__DisplayCurrentTag__9.DisplayTagValue.TextFrame.TextColor3 = v12;
	l__DisplayEditColors__10.DisplayColorName.TextFrame.Text = BrickColor.new(v12).Name;
	u11.setBackgroundColor3(l__DisplayEditColors__10.DisplayColorValue, v12);
	local v13 = u3.getTagData((u2.getPlayerData()));
	if u1.r == v13.r and u1.g == v13.g and u1.b == v13.b then
		l__DisplayEditColors__10.ButtonConfirm.Visible = false;
		return;
	end;
	l__DisplayEditColors__10.ButtonConfirm.Visible = true;
end;
function u4.updatePreviewTag(p2)
	if not p2 then
		warn("PageCustomizeDisplayEditTags: no previewTagText was given");
		return;
	end;
	local v14 = u3.getTagData((u2.getPlayerData()));
	if p2 == "" then
		local v15 = "";
		l__DisplayPreviewTag__7.ButtonConfirm.Visible = false;
	else
		v15 = u5.formatTextColor3(u5.escapeForbiddenCharacters(p2), u8());
		l__DisplayPreviewTag__7.ButtonConfirm.Visible = true;
	end;
	l__DisplayPreviewTag__7.DisplayTagValue.TextFrame.Text = p2;
	l__DisplayPreviewTag__7.DisplayTagValue.TextFrame.TextColor3 = Color3.fromRGB(u1.r, u1.g, u1.b);
	l__DisplayPreviewTag__7.DisplaySampleChat.TextFrame.Text = v15 .. "" .. u5.formatTextColor3(l__Name__6 .. ":", l__Color__7) .. " hi I am playing Phantom Forces";
end;
local l__DisplaySetNewTag__12 = l__DisplayPreviewTag__7.DisplaySetNewTag;
local u13 = shared.require("network");
local u14 = shared.require("GuiInputInterface");
local u15 = shared.require("PageCustomizeMenuEvents");
local u16 = shared.require("UIHighlight");
local u17 = shared.require("MenuColorConfig");
local u18 = nil;
local u19 = v2.new(v8, v8.Container.Confirm);
local u20 = v2.new(l__DisplayPromptPurchaseTag__5, l__DisplayPromptPurchaseTag__5.Container.Confirm, l__DisplayPromptPurchaseTag__5.Container.Cancel);
local u21 = shared.require("UISlider");
local u22 = shared.require("PageCreditsMenuEvents");
function u4._init()
	u4.updateCurrentTag(true);
	l__DisplayPreviewTag__7.ButtonConfirm.Visible = false;
	l__DisplayEditColors__10.ButtonConfirm.Visible = false;
	l__DisplaySetNewTag__12.TextBox.FocusLost:Connect(function()
		u13:send("requestPreviewTag", l__DisplaySetNewTag__12.TextBox.Text);
		l__DisplaySetNewTag__12.TextBox.Text = "";
	end);
	u14.onReleased(l__DisplaySetNewTag__12.TextBox, function()
		l__DisplaySetNewTag__12.TextBox:CaptureFocus();
	end);
	u14.onPressedOff(l__DisplaySetNewTag__12.TextBox, function()
		l__DisplaySetNewTag__12.TextBox:ReleaseFocus();
	end);
	l__DisplayEditColors__10.TextBoxEnterHex.FocusLost:Connect(function()
		local l__Text__16 = l__DisplayEditColors__10.TextBoxEnterHex.Text;
		if #l__Text__16 == 6 then
			local v17 = tonumber(string.sub(l__Text__16, 1, 2), 16) and -1;
			local v18 = tonumber(string.sub(l__Text__16, 3, 4), 16) and -1;
			local v19 = tonumber(string.sub(l__Text__16, 5, 6), 16) and -1;
			if v17 >= 0 and v17 <= 255 and v18 >= 0 and v18 <= 255 and v19 >= 0 and v19 <= 255 then
				u1.r = v17;
				u1.g = v18;
				u1.b = v19;
				u15.onPreviewColorChanged:fire();
			end;
		end;
	end);
	u14.onReleased(l__DisplayEditColors__10.TextBoxEnterHex, function()
		l__DisplayEditColors__10.TextBoxEnterHex:CaptureFocus();
	end);
	u14.onPressedOff(l__DisplayEditColors__10.TextBoxEnterHex, function()
		l__DisplayEditColors__10.TextBoxEnterHex:ReleaseFocus();
	end);
	u14.onReleased(l__DisplayEditColors__10.ButtonReset, function()
		local v20 = u3.getTagData((u2.getPlayerData()));
		u1.r = v20.r;
		u1.g = v20.g;
		u1.b = v20.b;
		u15.onPreviewColorChanged:fire();
	end);
	u16.new(l__DisplayEditColors__10.ButtonReset, {
		highlightColor3 = u17.menuColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u17.menuColorConfig.default.BackgroundColor3
	});
	u14.onReleased(l__DisplayPreviewTag__7.ButtonConfirm, function()
		if u18 then
			return;
		end;
		if l__DisplayPreviewTag__7.DisplayTagValue.TextFrame.Text == "" then
			return;
		end;
		if u3.getPlayerCredits((u2.getPlayerData())) < u3.tagCost then
			u19:activate("Not enough credits!");
			return;
		end;
		l__DisplayPromptPurchaseTag__5.Desc.Text = u5.formatTextColor3("=" .. u5.escapeForbiddenCharacters(l__DisplayPreviewTag__7.DisplayTagValue.TextFrame.Text) .. "=", u8());
		u20:activate(u5.formatTextColor3("PURCHASE TAG FOR\t\t", u17.defaultTextColor) .. "$" .. u11.commaValue(u3.tagCost), function()
			u13:send("purchaseTag");
			u18 = true;
			print("Attempt to purchase tag", l__DisplayPreviewTag__7.DisplayTagValue.TextFrame.Text);
		end);
	end);
	u16.new(l__DisplayPreviewTag__7.ButtonConfirm, {
		highlightColor3 = u17.menuColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u17.menuColorConfig.default.BackgroundColor3
	});
	u14.onReleased(l__DisplayEditColors__10.ButtonConfirm, function()
		if u18 then
			return;
		end;
		local v21 = "(" .. math.round(u1.r) .. ", " .. math.round(u1.g) .. ", " .. math.round(u1.b) .. ")";
		l__DisplayPromptPurchaseTag__5.Desc.Text = u5.formatTextColor3(v21, u8());
		u20:activate(u5.formatTextColor3("UPDATE TAG COLOR", u17.defaultTextColor), function()
			u13:send("changeTagColor", u1);
			u18 = true;
			print("Attempt to update tag color", v21);
		end);
	end);
	u16.new(l__DisplayEditColors__10.ButtonConfirm, {
		highlightColor3 = u17.menuColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u17.menuColorConfig.default.BackgroundColor3
	});
	for v22, v23 in next, { "r", "g", "b" } do
		local v24 = l__DisplayEditColors__10.ContainerColorBar["DisplayColorBar" .. string.upper(v23)];
		local v25 = u21.new(v24);
		v25:setBounds(0, 255);
		v25:setValue(u1[v23]);
		v25.onChanged:connect(function(p3)
			if not u3.getTagData((u2.getPlayerData())) then
				return;
			end;
			v24.TextBox.Text = math.round(p3);
			u1[v23] = p3;
			u4.updateCurrentTag();
			u4.updatePreviewTag(l__DisplayPreviewTag__7.DisplayTagValue.TextFrame.Text);
		end);
		u15.onTagDataChanged:connect(function()
			local v26 = u3.getTagData((u2.getPlayerData()));
			if u1[v23] ~= v26[v23] then
				u1[v23] = v26[v23];
				v25:setValue(u1[v23]);
			end;
		end);
		u15.onPreviewColorChanged:connect(function()
			local v27 = u1[v23];
			v25:setValue(u1[v23]);
		end);
	end;
	u13:receive("requestPreviewTagUpdate", function(p4, p5)
		if not p4 then
			warn("PageCustomizeDisplayEditTags: requestPreviewTag failed", l__DisplaySetNewTag__12.TextBox.Text);
		end;
		u4.updatePreviewTag(p5);
	end);
	u13:receive("purchaseTagUpdate", function(p6, p7)
		if not p6 then
			warn("PageCustomizeDisplayEditTags: purchaseTag failed", p7);
			u19:activate("Purchase failed!");
			return;
		end;
		u3.purchaseTag(u2.getPlayerData(), p7);
		u15.onTagDataChanged:fire();
		u22.onCreditsUpdated:fire();
		u19:activate("Purchase successful!");
		u18 = false;
	end);
	u13:receive("changeTagColorUpdate", function(p8, p9)
		if not p8 then
			warn("PageCustomizeDisplayEditTags: changeTagColor failed", p9);
			u19:activate("Color change failed!");
			return;
		end;
		u3.changeTagColor(u2.getPlayerData(), p9);
		u15.onTagDataChanged:fire();
		u19:activate("Color change successful!");
		u18 = false;
	end);
	u15.onTagDataChanged:connect(function()
		u4.updateCurrentTag(true);
	end);
	u15.onPreviewColorChanged:connect(function()
		u4.updateCurrentTag();
		u4.updatePreviewTag(l__DisplayPreviewTag__7.DisplayTagValue.TextFrame.Text);
	end);
end;
return u4;

