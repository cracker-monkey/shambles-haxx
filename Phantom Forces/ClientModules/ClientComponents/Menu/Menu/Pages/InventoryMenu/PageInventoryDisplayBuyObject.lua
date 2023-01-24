
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("UIPrompt");
local u3 = shared.require("GuiInputInterface");
local u4 = shared.require("MenuUtils");
local u5 = shared.require("UIHighlight");
local u6 = shared.require("MenuColorConfig");
local u7 = shared.require("UIIncrement");
function v1.new(p1, p2, p3, p4, p5)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._displayBuy = p1;
	v2._maxCount = p5;
	v2._minCount = p4;
	v2._displayPromptObject = u2.new(p2, p2.Container.Confirm, p2.Container.Cancel);
	v2._destructor:add(v2._displayPromptObject);
	v2._buttonBuy = v2._displayBuy.ButtonBuy;
	v2._destructor:add(u3.onReleased(v2._buttonBuy, function()
		local v3 = v2._incrementObject:getValue();
		local v4 = p3 * v3;
		if v2._conditionalFunc and not v2._conditionalFunc(v3, v4) then
			return;
		end;
		if v2._promptFunc then
			v2._promptFunc(p2, v3);
		end;
		v2._displayPromptObject:activate("<font color='rgb(255, 255, 255)'>PURCHASE THE FOLLOWING FOR </font>$" .. u4.commaValue(v4) .. "<font color='rgb(255, 255, 255)'>?</font>", function()
			if v2._buyFunc then
				v2._buyFunc(v3);
			end;
		end, function()
			if v2._cancelFunc then
				v2._cancelFunc(v3);
			end;
		end);
	end));
	v2._destructor:add(u5.new(v2._buttonBuy, {
		highlightColor3 = u6.promptConfirmColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u6.promptConfirmColorConfig.default.BackgroundColor3
	}));
	v2._textBoxQuantity = v2._displayBuy.DisplayQuantity.TextBox;
	v2._incrementObject = u7.new(v2._displayBuy);
	v2._incrementObject:setBounds(v2._minCount, v2._maxCount, 1);
	v2._destructor:add(v2._incrementObject);
	v2._destructor:add(v2._incrementObject.onChanged:connect(function(p6)
		v2._textBoxQuantity.Text = "QTY : " .. p6;
		v2._displayBuy.ButtonBuy.TextCost.Text = "$" .. p3 * p6;
	end));
	v2._destructor:add(v2._textBoxQuantity.FocusLost:Connect(function()
		local v5 = tonumber(v2._textBoxQuantity.Text);
		if not v5 then
			v2._textBoxQuantity.Text = "QTY : " .. v2._incrementObject:getValue();
			return;
		end;
		v2._incrementObject:setValue((math.round((math.min(math.max(v5, v2._minCount), v2._maxCount)))));
	end));
	v2._destructor:add(u3.onReleased(v2._textBoxQuantity, function()
		v2._textBoxQuantity:CaptureFocus();
	end));
	v2._destructor:add(u3.onPressedOff(v2._textBoxQuantity, function()
		v2._textBoxQuantity:ReleaseFocus();
	end));
	v2._destructor:add(u5.new(v2._displayBuy.Container.LeftFrame, {
		highlightColor3 = u6.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u6.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
	v2._destructor:add(u5.new(v2._displayBuy.Container.RightFrame, {
		highlightColor3 = u6.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u6.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
	}));
	v2._incrementObject:setValue(1);
	return v2;
end;
function v1.Destroy(p7)
	p7._destructor:Destroy();
end;
function v1.setConditionalFunc(p8, p9)
	if type(p9) == "function" then
		p8._conditionalFunc = p9;
		return;
	end;
	warn("PageInventoryDisplayBuyObject:", p9, "is not a function");
end;
function v1.setBuyFunc(p10, p11)
	if type(p11) == "function" then
		p10._buyFunc = p11;
		return;
	end;
	warn("PageInventoryDisplayBuyObject:", p11, "is not a function");
end;
function v1.setPromptFunc(p12, p13)
	if type(p13) == "function" then
		p12._promptFunc = p13;
		return;
	end;
	warn("PageInventoryDisplayBuyObject:", p13, "is not a function");
end;
return v1;

