
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PageLoadoutMenuInterface");
local v3 = shared.require("GuiInputInterface");
local v4 = shared.require("MenuColorConfig");
local v5 = shared.require("MenuScreenGui");
local v6 = shared.require("UIHighlight");
local u1 = shared.require("SkinCaseUtils");
local l__Templates__2 = v2.getPageFrame().Templates;
local u3 = shared.require("MenuUtils");
local u4 = shared.require("UISlider");
local u5 = shared.require("ActiveLoadoutInterfaceClient");
local function u6(p1)
	return (p1.TextureProperties or {}).Transparency or ((u1.getSkinDataset(p1.Name).TexturePreset or {}).Transparency or 0);
end;
local u7 = shared.require("ActiveLoadoutEvents");
function v1.activate(p2, p3, p4)
	local v7 = l__Templates__2.DisplayEditSlider:Clone();
	v7.Parent = p2;
	u3.setText(v7.TitleEdit, string.upper("Editing Transparency"));
	u3.setText(v7.TitleValue, "Transparency:");
	local v8 = v2.getActiveLoadoutSlot();
	local v9 = u4.new(v7);
	v9:setBounds(0, 0.9);
	p4:add(v9);
	p4:add(v9.onDragEnded:connect(function(p5)
		if not v2.getActiveCamoData(p3) then
			return;
		end;
		p5 = math.round(p5 * 100) / 100;
		u5.changeCamoProperty(v8, p3, "TextureProperties", "Transparency", p5);
	end));
	p4:add(v9.onChanged:connect(function(p6, p7)
		if not v2.getActiveCamoData(p3) then
			return;
		end;
		v7.TextBox.Text = string.format("%0.2f", math.round(p6 * 100) / 100);
		if p7 then
			u5.changeCamoProperty(v8, p3, "TextureProperties", "Transparency", p6);
		end;
	end));
	local function v10()
		local v11 = v2.getActiveCamoData(p3);
		if not v11 then
			return;
		end;
		local v12 = u6(v11);
		v7.TextBox.Text = string.format("%0.2f", math.round(v12 * 100) / 100);
		v9:setValue(v12);
	end;
	v10();
	p4:add(u7.onLoadoutChanged:connect(v10));
	p4:add(v7);
end;
function v1.init(p8)
	u3.setText(p8, string.upper("Transparency"));
end;
return v1;

