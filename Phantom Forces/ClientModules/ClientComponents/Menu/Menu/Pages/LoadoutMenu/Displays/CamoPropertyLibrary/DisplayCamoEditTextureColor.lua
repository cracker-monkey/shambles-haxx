
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PageLoadoutMenuInterface");
local u1 = shared.require("SkinCaseUtils");
local u2 = Color3.new();
local l__Templates__3 = v2.getPageFrame().Templates;
local u4 = shared.require("MenuUtils");
local u5 = shared.require("BrickColorWheel");
local u6 = shared.require("UIHighlight");
local u7 = shared.require("GuiInputInterface");
local u8 = shared.require("ActiveLoadoutInterfaceClient");
local function u9(p1)
	local v3 = BrickColor.new(p1);
	return {
		r = math.round(v3.Color.R * 255), 
		g = math.round(v3.Color.G * 255), 
		b = math.round(v3.Color.B * 255)
	};
end;
local l__displayColorBarConfig__10 = shared.require("PageLoadoutMenuConfig").displayColorBarConfig;
local u11 = shared.require("UISlider");
local function u12(p2)
	local v4 = p2.TextureProperties or {};
	local v5 = u1.getSkinDataset(p2.Name).TexturePreset or {};
	local v6 = u2;
	if v4.Color or v5.Color then
		v6 = Color3.fromRGB((v4 and v5).Color.r, (v4 and v5).Color.g, (v4 and v5).Color.b);
	end;
	return v6;
end;
local u13 = shared.require("ActiveLoadoutEvents");
local u14 = shared.require("MenuColorConfig");
function v1.activate(p3, p4, p5)
	local v7 = l__Templates__3.DisplayEditColors:Clone();
	v7.Parent = p3;
	local v8 = v2.getActiveLoadoutSlot();
	local l__ContainerColorWheel__9 = v7.ContainerColorWheel;
	u4.clearContainer(l__ContainerColorWheel__9);
	for v10, v11 in next, u5 do
		local v12 = l__Templates__3.ContainerColorWheelRow:Clone();
		v12.LayoutOrder = v10;
		p5:add(v12);
		for v13, v14 in next, v11 do
			local v15 = l__Templates__3.ButtonColorWheel:Clone();
			v15.LayoutOrder = v13;
			local l__Color__16 = BrickColor.new(v14).Color;
			u4.setBackgroundColor3(v15, l__Color__16);
			p5:add(u6.new(v15, {
				highlightColor3 = l__Color__16:lerp(Color3.new(0, 0, 0), 0.5), 
				defaultColor3 = l__Color__16
			}));
			p5:add(u7.onReleased(v15, function()
				if not v2.getActiveCamoData(p4) then
					return;
				end;
				u8.changeCamoProperty(v8, p4, "TextureProperties", "Color", (u9(v14)));
			end));
			p5:add(v15);
			v15.Parent = v12;
		end;
		v12.Parent = l__ContainerColorWheel__9;
	end;
	local u15 = {};
	for v17, v18 in next, l__displayColorBarConfig__10 do
		local v19 = v7[v17];
		local v20 = u11.new(v19);
		v20:setBounds(0, 255);
		p5:add(v20);
		p5:add(v20.onDragEnded:connect(function(p6)
			local v21 = v2.getActiveCamoData(p4);
			if not v21 then
				return;
			end;
			u8.changeCamoProperty(v8, p4, "TextureProperties", "Color", (v18.colorTableFunc(p6, (u12(v21)))));
		end));
		p5:add(v20.onChanged:connect(function(p7)
			local v22 = v2.getActiveCamoData(p4);
			if not v22 then
				return;
			end;
			local v23 = v18.newBrickColor3Func(p7, (u12(v22)));
			u4.setText(v7.TitleColorName, string.upper(BrickColor.new(v23.R, v23.G, v23.B).Name));
			u4.setBackgroundColor3(v7.DisplayColorValue, v23);
			v19.TextBox.Text = math.round(p7);
		end));
		u15[v17] = v20;
	end;
	local function u16(p8)
		for v24, v25 in next, l__displayColorBarConfig__10 do
			v25.updateFunc(v7[v24], u15[v24], p8);
		end;
	end;
	local function v26()
		local v27 = v2.getActiveCamoData(p4);
		if not v27 then
			u4.setText(v7.TitleSlot, "NO SKIN SELECTED");
			u4.setText(v7.TitleColorName, "N/A");
			u4.setBackgroundColor3(v7.DisplayColorValue, u2);
			u16(u2);
			return;
		end;
		u4.setText(v7.TitleEdit, string.upper("EDITING " .. p4 .. " TEXTURE COLOR"));
		u4.setText(v7.TitleSlot, string.upper(v27.Name));
		local v28 = u12(v27);
		u4.setText(v7.TitleColorName, string.upper(BrickColor.new(v28.R, v28.G, v28.B).Name));
		u4.setBackgroundColor3(v7.DisplayColorValue, v28);
		u16(v28);
	end;
	v26();
	p5:add(u13.onLoadoutChanged:connect(v26));
	local l__TextBoxEnterColor__29 = v7.TextBoxEnterColor;
	p5:add(l__TextBoxEnterColor__29.FocusLost:connect(function()
		local l__Text__30 = l__TextBoxEnterColor__29.Text;
		if string.lower(BrickColor.new(l__Text__30).Name) ~= string.lower(l__Text__30) then
			return;
		end;
		u8.changeCamoProperty(v8, p4, "TextureProperties", "Color", (u9(l__Text__30)));
	end));
	p5:add(u7.onReleased(l__TextBoxEnterColor__29, function()
		l__TextBoxEnterColor__29:CaptureFocus();
	end));
	p5:add(u7.onPressedOff(l__TextBoxEnterColor__29, function()
		l__TextBoxEnterColor__29:ReleaseFocus();
	end));
	p5:add(u7.onReleased(v7.ButtonReset, function()
		if not v2.getActiveCamoData(p4) then
			return;
		end;
		u8.changeCamoProperty(v8, p4, "TextureProperties", "Color", nil);
	end));
	p5:add(u6.new(v7.ButtonReset, {
		highlightColor3 = u14.subMenuColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u14.subMenuColorConfig.default.BackgroundColor3
	}));
	p5:add(v7);
end;
function v1.init(p9)
	u4.setText(p9, "TEXTURE COLOR");
end;
return v1;

