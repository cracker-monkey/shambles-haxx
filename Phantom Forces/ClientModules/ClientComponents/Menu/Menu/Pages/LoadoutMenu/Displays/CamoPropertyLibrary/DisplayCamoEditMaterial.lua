
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PageLoadoutMenuInterface");
local v3 = shared.require("MenuScreenGui");
local u1 = shared.require("SkinCaseUtils");
local l__Templates__2 = v2.getPageFrame().Templates;
local u3 = shared.require("MenuUtils");
local u4 = { "SmoothPlastic", "Neon", "Granite", "Marble", "Ice", "Cobblestone", "Foil", "Metal", "Pebble", "Slate", "CorrodedMetal", "DiamondPlate", "Brick", "Fabric", "WoodPlanks", "Wood", "Grass", "Sand", "Concrete", "Plastic", "Glass", "ForceField" };
local u5 = shared.require("UIHighlight");
local u6 = shared.require("GuiInputInterface");
local u7 = shared.require("ActiveLoadoutInterfaceClient");
local u8 = shared.require("ActiveLoadoutEvents");
local u9 = shared.require("ActiveLoadoutUtils");
local u10 = shared.require("PlayerDataStoreClient");
local u11 = shared.require("UIScrollingList");
local function u12(p1)
	return (p1.BrickProperties or {}).Material or ((u1.getSkinDataset(p1.Name).BrickPreset or {}).Material or "Default");
end;
function v1.activate(p2, p3, p4)
	local v4 = l__Templates__2.DisplayEditList:Clone();
	v4.Parent = p2;
	local v5 = v2.getActiveLoadoutSlot();
	local l__Container__6 = v4.DisplayList.Container;
	u3.clearContainer(l__Container__6);
	for v7, v8 in next, u4 do
		local v9 = l__Templates__2.ButtonWeaponList:Clone();
		u3.setText(v9, v8);
		u3.setTextColor3(v9, Color3.fromRGB(235, 235, 235));
		local v10 = Color3.fromRGB(35, 35, 35);
		p4:add(u5.new(v9, {
			highlightColor3 = v10:lerp(Color3.new(1, 1, 1), 0.25), 
			defaultColor3 = v10
		}));
		p4:add(u6.onReleased(v9, function()
			local v11 = v2.getActiveCamoData(p3);
			if not v11 then
				return;
			end;
			if v11.BrickProperties and v11.BrickProperties.Material == v8 then
				u7.changeCamoProperty(v5, p3, "BrickProperties", "Material", nil);
				return;
			end;
			u7.changeCamoProperty(v5, p3, "BrickProperties", "Material", v8);
		end));
		p4:add(u8.onLoadoutChanged:connect(function(p5, p6)
			local v12 = v2.getActiveCamoData(p3);
			if not v12 then
				return;
			end;
			local v13 = v12.BrickProperties and v12.BrickProperties.Material == v8;
			v9.CheckBox.CheckBoxFrame.Visible = v13;
		end));
		local v14 = u9.getActiveLoadoutData(u10.getPlayerData());
		local v15 = v2.getActiveCamoData(p3);
		if v15 then
			local v16 = v15.BrickProperties and v15.BrickProperties.Material == v8;
			v9.CheckBox.CheckBoxFrame.Visible = v16;
		end;
		p4:add(v9);
		v9.Parent = l__Container__6;
	end;
	p4:add(u11.new(v4.DisplayList));
	local function v17()
		local v18 = v2.getActiveCamoData(p3);
		if not v18 then
			u3.setText(v4.TitleSlot, "SLOT N/A");
			u3.setText(v4.TitleValue, "N/A");
			return;
		end;
		local l__Name__19 = v18.Name;
		u3.setText(v4.TitleEdit, string.upper("EDITING MATERIAL"));
		u3.setText(v4.TitleSlot, string.upper(p3));
		u3.setText(v4.TitleValue, string.upper((u12(v18))));
	end;
	v17();
	p4:add(u8.onLoadoutChanged:connect(v17));
	p4:add(v4);
end;
function v1.init(p7)
	u3.setText(p7, "MATERIAL");
end;
return v1;

