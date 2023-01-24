
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PageLoadoutMenuInterface");
local v3 = shared.require("MenuScreenGui");
local v4 = v2.getPageFrame();
local l__DisplayWeaponCamo__5 = v4.DisplayWeaponCamo;
local u1 = shared.require("DestructorGroup").new();
local u2 = false;
local u3 = shared.require("PageLoadoutMenuConfig");
local l__Templates__4 = v4.Templates;
local u5 = shared.require("UIHighlight");
local u6 = shared.require("MenuColorConfig");
local u7 = nil;
local u8 = shared.require("UIExpander");
local u9 = shared.require("UIToggleGroup");
local u10 = shared.require("MenuUtils");
local l__ContainerEdit__11 = l__DisplayWeaponCamo__5.ContainerEdit;
local u12 = nil;
function v1.getActiveCamoSlot()
	return u7, u12;
end;
local l__Title__13 = l__DisplayWeaponCamo__5.Title;
local l__DisplayCamoList__14 = l__DisplayWeaponCamo__5.DisplayCamoList;
local u15 = shared.require("GuiInputInterface");
local u16 = shared.require("ActiveLoadoutInterfaceClient");
local u17 = shared.require("ActiveLoadoutEvents");
local u18 = shared.require("ActiveLoadoutUtils");
local u19 = shared.require("PlayerDataStoreClient");
local u20 = shared.require("PlayerDataUtils");
local u21 = shared.require("SkinCaseUtils");
local function u22()
	local v6 = u1:runAndReplace("camoEditList");
	u1:runAndReplace("camoPropertyWindow");
	u2 = true;
	local function v7(p1, p2)
		local v8 = u3.editCamoConfig[p2];
		if not v8 then
			warn("PageLoadoutMenuDisplayWeaponCamo: Invalid edit name given", p2);
			return;
		end;
		local v9 = {};
		for v10, v11 in next, v8 do
			local v12 = l__Templates__4.ButtonWeaponList:Clone();
			local v13 = shared.require(v11);
			v13.init(v12);
			v6:add(u5.new(v12, {
				highlightColor3 = u6.weaponListColorConfig.highlighted.BackgroundColor3, 
				defaultColor3 = u6.weaponListColorConfig.default.BackgroundColor3
			}));
			v6:add(v12);
			v12.Parent = p1;
			local v14 = {
				buttonFrame = v12
			};
			local v15 = {};
			function v15.onToggled()
				v13.activate(l__DisplayWeaponCamo__5, u7, (u1:runAndReplace("camoPropertyWindow")));
				v12.CheckBox.CheckBoxFrame.Visible = true;
			end;
			function v15.onUntoggled()
				v12.CheckBox.CheckBoxFrame.Visible = false;
			end;
			v14.buttonConfig = v15;
			v9[v11] = v14;
		end;
		local v16 = nil;
		if #v8 > 0 then
			v16 = u8.new(p1.Parent, {
				size0 = UDim2.new(1, 0, 0, 30), 
				size1 = UDim2.new(1, 0, 0, 30 + #v8 * 35)
			});
			v6:add(v16);
		end;
		v6:add((u9.new(v9, nil, function()
			u1:runAndReplace("camoPropertyWindow");
		end)));
		return v16;
	end;
	local v17 = {};
	for v18 in next, u3.editCamoConfig do
		local v19 = l__Templates__4.ButtonEdit:Clone();
		u10.setText(v19, string.upper(v18));
		v19.Name = v18;
		v19.Parent = l__ContainerEdit__11;
		local v20 = v7(v19.Container, v18);
		v6:add(v19);
		local v21 = {
			buttonFrame = v19
		};
		local v22 = {};
		function v22.onToggled()
			u1:runAndReplace("camoPropertyWindow");
			v20:toggle();
		end;
		function v22.onUntoggled()
			v20:toggle();
		end;
		v21.buttonConfig = v22;
		v17[v18] = v21;
	end;
	v6:add(u9.new(v17, u6.loadoutClassColorConfig, function()
		u1:runAndReplace("camoPropertyWindow");
	end));
	v6:add(function()
		u1:runAndReplace("camoPropertyList");
		u1:runAndReplace("camoPropertyWindow");
		u2 = false;
	end);
end;
local u23 = shared.require("UIScrollingList");
local u24 = shared.require("ContentDatabase");
local l__ContainerSlots__25 = l__DisplayWeaponCamo__5.ContainerSlots;
local u26 = shared.require("PageLoadoutMenuEvents");
function v1.updatePage()
	local v23 = u1:runAndReplace("camoSlot");
	u1:runAndReplace("camoList");
	u7 = nil;
	u12 = nil;
	local v24 = v2.getActiveLoadoutSlot();
	u10.setText(l__Title__13, string.upper(v24 .. " Camo Skins"));
	local function u27(p3, p4, p5)
		local v25 = l__Templates__4.ButtonListCamo:Clone();
		u10.setText(v25, "NONE");
		v25.Parent = l__DisplayCamoList__14.Container;
		p5:add(v25);
		p5:add(u15.onReleased(v25, function()
			u16.changeCamo(v24, p3, nil);
			u1:runAndReplace("camoEditList");
		end));
		local v26 = u6.rarityColorConfig[6];
		p5:add(u5.new(v25, {
			highlightColor3 = v26.Color:lerp(Color3.new(0, 0, 0), 0.5), 
			defaultColor3 = v26.Color
		}));
		v25.ImageCamo.Image = "";
		v25.ImageCamo.BackgroundColor3 = v26.TextColor;
		p5:add(u17.onLoadoutChanged:connect(function(p6, p7)
			local v27 = p7[v24].Camo;
			if v27 then
				v27 = p7[v24].Camo[p4];
				if v27 then
					v27 = true;
					if p7[v24].Camo[p4].Name ~= "" then
						v27 = p7[v24].Camo[p4].Name == nil;
					end;
				end;
			end;
			v25.CheckBox.CheckBoxFrame.Visible = v27;
		end));
		local v28 = u18.getActiveLoadoutData(u19.getPlayerData());
		local v29 = v28[v24].Camo;
		if v29 then
			v29 = v28[v24].Camo[p4];
			if v29 then
				v29 = true;
				if v28[v24].Camo[p4].Name ~= "" then
					v29 = v28[v24].Camo[p4].Name == nil;
				end;
			end;
		end;
		v25.CheckBox.CheckBoxFrame.Visible = v29;
	end;
	local function v30(p8, p9)
		local v31 = u1:runAndReplace("camoList");
		u7 = p8;
		u12 = p9;
		local v32 = u18.getActiveLoadoutData(u19.getPlayerData());
		local v33 = u20.getCamoList(u19.getPlayerData(), v32[v24].Name);
		table.sort(v33, function(p10, p11)
			local v34 = u21.getSkinDataset(p10);
			local v35 = u21.getSkinDataset(p11);
			if not v34 then
				warn("No skinDataA", p10);
				return true;
			end;
			if not v35 then
				warn("No skinDataB", p11);
				return false;
			end;
			if v34.Rarity == v35.Rarity then
				return p10 < p11;
			end;
			return v34.Rarity < v35.Rarity;
		end);
		u27(p8, p9, v31);
		for v36, v37 in next, v33 do
			local v38 = u21.getSkinDataset(v37);
			if v38 then
				local v39 = l__Templates__4.ButtonListCamo:Clone();
				v39.ImageCamo.Image = "rbxassetid://" .. v38.TextureId;
				u10.setText(v39, string.upper(v38.DisplayName and v37));
				v39.Parent = l__DisplayCamoList__14.Container;
				v31:add(v39);
				v31:add(u15.onReleased(v39, function()
					if v32[v24].Camo and v32[v24].Camo[p9] and v32[v24].Camo[p9].Name == v37 then
						u16.changeCamo(v24, p8, nil);
						u1:runAndReplace("camoEditList");
						return;
					end;
					u16.changeCamo(v24, p8, v37);
					if v38.Unlocked then
						if u2 then
							return;
						end;
					else
						u1:runAndReplace("camoEditList");
						return;
					end;
					u22();
				end));
				local v40 = u6.rarityColorConfig[v38.Rarity and 6];
				v31:add(u5.new(v39, {
					highlightColor3 = v40.Color:lerp(Color3.new(0, 0, 0), 0.5), 
					defaultColor3 = v40.Color
				}));
				v31:add(u17.onLoadoutChanged:connect(function(p12, p13)
					v39.CheckBox.CheckBoxFrame.Visible = p13[v24].Camo and (p13[v24].Camo[p9] and p13[v24].Camo[p9].Name == v37);
				end));
				local v41 = u18.getActiveLoadoutData(u19.getPlayerData());
				v39.CheckBox.CheckBoxFrame.Visible = v41[v24].Camo and (v41[v24].Camo[p9] and v41[v24].Camo[p9].Name == v37);
				if v39.CheckBox.CheckBoxFrame.Visible and v38.Unlocked then
					u22();
				end;
			else
				warn("PageLoadoutMenuDisplayWeaponCamo: No skin data found for skin", v37);
			end;
		end;
		v23:add(u23.new(l__DisplayCamoList__14));
		v31:add(function()
			u1:runAndReplace("camoEditList");
		end);
	end;
	local v42 = {};
	for v43, v44 in pairs((u24.getCamoSlots(u18.getActiveLoadoutData(u19.getPlayerData())[v24].Name))) do
		local v45 = l__Templates__4.ButtonLoadoutSlot:Clone();
		u10.setText(v45, string.upper(v43));
		v45.Name = v43;
		v45.Parent = l__ContainerSlots__25;
		v23:add(v45);
		local v46 = {
			buttonFrame = v45
		};
		local v47 = {};
		function v47.onToggled()
			v30(v43, v44);
			u26.onWeaponStatsChanged:fire();
		end;
		v46.buttonConfig = v47;
		v42[v43] = v46;
	end;
	local v48 = u9.new(v42, u6.loadoutClassColorConfig, function()
		u1:runAndReplace("camoList");
		u1:runAndReplace("camoEditList");
		u7 = nil;
		u12 = nil;
		l__DisplayCamoList__14.CanvasSize = UDim2.new(0, 0, 0, 0);
		u26.onWeaponStatsChanged:fire();
	end);
	v23:add(v48);
	v48:setToggle("Slot 1");
	l__DisplayCamoList__14.CanvasSize = UDim2.new(0, 0, 0, 0);
	u26.onWeaponStatsChanged:fire();
end;
function v1._init()
	u10.clearContainer(l__DisplayCamoList__14.Container);
	u10.clearContainer(l__ContainerSlots__25);
	u10.clearContainer(l__ContainerEdit__11);
	u15.onReleased(l__DisplayWeaponCamo__5.ButtonBack, function()
		v2.goToSubPage("DisplayWeaponSelection");
		u26.onWeaponStatsChanged:fire();
	end);
	u5.new(l__DisplayWeaponCamo__5.ButtonBack, {
		highlightColor3 = u6.menuColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u6.menuColorConfig.default.BackgroundColor3
	});
	u26.onSubPageChanged:connect(function(p14)
		if p14 ~= l__DisplayWeaponCamo__5.Name then
			return;
		end;
		v1.updatePage();
	end);
end;
return v1;

