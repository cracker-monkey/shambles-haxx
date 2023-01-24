
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
local l__displayColorBarConfig__9 = shared.require("PageLoadoutMenuConfig").displayColorBarConfig;
local u10 = shared.require("UISlider");
local function u11(p1)
	local v3 = p1.BrickProperties or {};
	local v4 = u1.getSkinDataset(p1.Name).BrickPreset or {};
	local v5 = u2;
	if not v3.Color and not v4.Color then
		if v3.BrickColor or v4.BrickColor then
			return BrickColor.new(v3.BrickColor or v4.BrickColor).Color;
		else
			if v3.DefaultColor or v4.DefaultColor then
				v5 = u2;
			end;
			return v5;
		end;
	end;
	return Color3.fromRGB((v3.Color or v4.Color).r, (v3.Color or v4.Color).g, (v3.Color or v4.Color).b);
end;
local u12 = shared.require("ActiveLoadoutEvents");
local u13 = shared.require("MenuColorConfig");
function v1.activate(p2, p3, p4)
	local v6 = l__Templates__3.DisplayEditColors:Clone();
	v6.Parent = p2;
	local v7 = v2.getActiveLoadoutSlot();
	local l__ContainerColorWheel__8 = v6.ContainerColorWheel;
	u4.clearContainer(l__ContainerColorWheel__8);
	for v9, v10 in next, u5 do
		local v11 = l__Templates__3.ContainerColorWheelRow:Clone();
		v11.LayoutOrder = v9;
		p4:add(v11);
		for v12, v13 in next, v10 do
			local v14 = l__Templates__3.ButtonColorWheel:Clone();
			v14.LayoutOrder = v12;
			local l__Color__15 = BrickColor.new(v13).Color;
			u4.setBackgroundColor3(v14, l__Color__15);
			p4:add(u6.new(v14, {
				highlightColor3 = l__Color__15:lerp(Color3.new(0, 0, 0), 0.5), 
				defaultColor3 = l__Color__15
			}));
			p4:add(u7.onReleased(v14, function()
				if not v2.getActiveCamoData(p3) then
					return;
				end;
				u8.changeCamoProperty(v7, p3, "BrickProperties", "Color", nil);
				u8.changeCamoProperty(v7, p3, "BrickProperties", "BrickColor", v13);
			end));
			p4:add(v14);
			v14.Parent = v11;
		end;
		v11.Parent = l__ContainerColorWheel__8;
	end;
	local u14 = {};
	for v16, v17 in next, l__displayColorBarConfig__9 do
		local v18 = v6[v16];
		local v19 = u10.new(v18);
		v19:setBounds(0, 255);
		p4:add(v19);
		p4:add(v19.onDragEnded:connect(function(p5)
			local v20 = v2.getActiveCamoData(p3);
			if not v20 then
				return;
			end;
			p5 = math.round(p5);
			local v21 = v17.colorTableFunc(p5, (u11(v20)));
			u8.changeCamoProperty(v7, p3, "BrickProperties", "BrickColor", nil);
			u8.changeCamoProperty(v7, p3, "BrickProperties", "Color", v21);
		end));
		p4:add(v19.onChanged:connect(function(p6, p7)
			local v22 = v2.getActiveCamoData(p3);
			if not v22 then
				return;
			end;
			p6 = math.round(p6);
			local v23 = u11(v22);
			local v24 = v17.newBrickColor3Func(p6, v23);
			u4.setText(v6.TitleColorName, string.upper(BrickColor.new(v24.R, v24.G, v24.B).Name));
			u4.setBackgroundColor3(v6.DisplayColorValue, v24);
			v18.TextBox.Text = math.round(p6);
			if p7 then
				if v23.R == v24.R and v23.G == v24.G and v23.B == v24.B then
					return;
				end;
				local v25 = v17.colorTableFunc(p6, v24);
				u8.changeCamoProperty(v7, p3, "BrickProperties", "BrickColor", nil);
				u8.changeCamoProperty(v7, p3, "BrickProperties", "Color", v25);
			end;
		end));
		u14[v16] = v19;
	end;
	local function u15(p8)
		for v26, v27 in next, l__displayColorBarConfig__9 do
			v27.updateFunc(v6[v26], u14[v26], p8);
		end;
	end;
	local function v28()
		local v29 = v2.getActiveCamoData(p3);
		if not v29 then
			u4.setText(v6.TitleSlot, "NO SKIN SELECTED");
			u4.setText(v6.TitleColorName, "N/A");
			u4.setBackgroundColor3(v6.DisplayColorValue, u2);
			u15(u2);
			return;
		end;
		u4.setText(v6.TitleEdit, string.upper("EDITING " .. p3 .. " BRICKCOLOR"));
		u4.setText(v6.TitleSlot, string.upper(v29.Name));
		local v30 = u11(v29);
		u4.setText(v6.TitleColorName, string.upper(BrickColor.new(v30.R, v30.G, v30.B).Name));
		u4.setBackgroundColor3(v6.DisplayColorValue, v30);
		u15(v30);
	end;
	v28();
	p4:add(u12.onLoadoutChanged:connect(v28));
	local l__TextBoxEnterColor__31 = v6.TextBoxEnterColor;
	p4:add(l__TextBoxEnterColor__31.FocusLost:connect(function()
		local l__Text__32 = l__TextBoxEnterColor__31.Text;
		if string.lower(BrickColor.new(l__Text__32).Name) ~= string.lower(l__Text__32) then
			return;
		end;
		u8.changeCamoProperty(v7, p3, "BrickProperties", "Color", nil);
		u8.changeCamoProperty(v7, p3, "BrickProperties", "BrickColor", l__Text__32);
	end));
	p4:add(u7.onReleased(l__TextBoxEnterColor__31, function()
		l__TextBoxEnterColor__31:CaptureFocus();
	end));
	p4:add(u7.onPressedOff(l__TextBoxEnterColor__31, function()
		l__TextBoxEnterColor__31:ReleaseFocus();
	end));
	p4:add(u7.onReleased(v6.ButtonReset, function()
		if not v2.getActiveCamoData(p3) then
			return;
		end;
		u8.changeCamoProperty(v7, p3, "BrickProperties", "Color", nil);
		u8.changeCamoProperty(v7, p3, "BrickProperties", "BrickColor", nil);
	end));
	p4:add(u6.new(v6.ButtonReset, {
		highlightColor3 = u13.subMenuColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u13.subMenuColorConfig.default.BackgroundColor3
	}));
	p4:add(v6);
end;
function v1.init(p9)
	u4.setText(p9, "BRICKCOLOR");
end;
return v1;

