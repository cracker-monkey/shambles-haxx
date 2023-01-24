
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PlayerDataStoreClient");
local v3 = shared.require("PlayerDataUtils");
function v1.separate(p1)
	local v4 = {};
	local v5 = 0;
	for v6 = 1, #p1 do
		for v7 in string.gmatch(string.lower(p1[v6]), "%w+") do
			v5 = v5 + 1;
			v4[v5] = v7;
		end;
	end;
	return v4;
end;
function v1.strDist(p2, p3)
	local v8 = {};
	local v9 = #p2;
	for v10 = 1, v9 do
		v8[v10] = v10;
	end;
	for v11 = 1, #p3 do
		local v12 = string.byte(p3, v11);
		local v13 = v11 - 1;
		local v14 = v11;
		for v15 = 1, v9 do
			local v16 = v8[v15];
			if string.byte(p2, v15) == v12 then
				local v17 = v13;
			else
				v17 = math.min(v13, v16, v14) + 1;
			end;
			v13 = v16;
			v14 = v17;
			v8[v15] = v17;
		end;
	end;
	return v17;
end;
function v1.termDist(p4, p5)
	local v18 = nil;
	local v19 = #p5;
	v18 = 0;
	for v20 = 1, #p4 do
		local v21 = (1 / 0);
		for v22 = 1, v19 do
			local v23 = v1.strDist(p4[v20], p5[v22]) / (#p4[v20] + #p5[v22]);
			if v23 < v21 then
				v21 = v23;
			end;
		end;
		v18 = v18 + v21;
	end;
	return local v24;
end;
local u1 = shared.require("ContentDatabase");
local u2 = shared.require("SkinCaseUtils");
function v1.sortSkins(p6, p7)
	local l__Name__25 = p6.Name;
	local l__Name__26 = p7.Name;
	local v27 = u1.getWeaponDisplayName(p6.Weapon);
	local v28 = u1.getWeaponDisplayName(p7.Weapon);
	if u2.isLegendaryWeapon(p6.Weapon) then
		local v29 = 1;
	else
		v29 = 0;
	end;
	if u2.isLegendaryWeapon(p7.Weapon) then
		local v30 = 1;
	else
		v30 = 0;
	end;
	local v31 = u2.getSkinDataset(l__Name__25);
	local v32 = u2.getSkinDataset(l__Name__26);
	local v33 = v31 and v31.Rarity or 0;
	local v34 = v32 and v32.Rarity or 0;
	if v29 == v30 then
		if v33 == v34 then
			if l__Name__25 == l__Name__26 then
				local v35 = true;
				if not (v27 < v28) then
					v35 = true;
					if not (l__Name__25 < l__Name__26) then
						v35 = true;
						if not (v34 < v33) then
							v35 = v30 < v29;
						end;
					end;
				end;
			else
				v35 = true;
				if not (l__Name__25 < l__Name__26) then
					v35 = true;
					if not (v34 < v33) then
						v35 = v30 < v29;
					end;
				end;
			end;
		else
			v35 = true;
			if not (v34 < v33) then
				v35 = v30 < v29;
			end;
		end;
	else
		v35 = v30 < v29;
	end;
	return v35;
end;
function v1.getSortedMultiRollBatch(p8)
	local v36 = {};
	for v37 = 1, #p8.selectedSkinName do
		table.insert(v36, {
			Name = p8.selectedSkinName[v37], 
			Weapon = p8.selectedWeaponName[v37]
		});
	end;
	table.sort(v36, v1.sortSkins);
	return v36;
end;
local u3 = shared.require("PageInventoryMenuConfig");
function v1.generateSortedInventoryList(p9, p10)
	local v38 = {};
	local l__next__39 = next;
	local v40 = nil;
	while true do
		local v41, v42 = l__next__39(p9, v40);
		if not v41 then
			break;
		end;
		local l__Cases__43 = v42.Cases;
		local v44 = u2.getCaseDataset(v41);
		if not p10 then
			if u3.itemTypes.Case.toggled then
				if l__Cases__43.Count > 0 then
					table.insert(v38, {
						Type = "Case", 
						Name = v41, 
						Count = l__Cases__43.Count, 
						Desc = "RANDOM"
					});
				end;
				for v45, v46 in next, l__Cases__43.Assigned do
					if v46 > 0 then
						table.insert(v38, {
							Type = "Case", 
							Name = v41, 
							Count = v46, 
							Weapon = v45, 
							Desc = string.upper(u1.getWeaponDisplayName(v45))
						});
					end;
				end;
			end;
			if u3.itemTypes["Case Key"].toggled then
				local l__Keys__47 = v42.Keys;
				if l__Keys__47 > 0 then
					table.insert(v38, {
						Type = "Case Key", 
						Name = v41, 
						Count = l__Keys__47
					});
				end;
			end;
		end;
		if u3.itemTypes.Skin.toggled or p10 then
			for v48, v49 in next, v42.Skins do
				local l__next__50 = next;
				local v51 = nil;
				while true do
					local v52, v53 = l__next__50(v49, v51);
					if not v52 then
						break;
					end;
					local v54 = u2.isLegendaryWeapon(v52);
					if p10 and not v54 then
						for v55 = 1, v53 do
							table.insert(v38, {
								Type = "Skin", 
								Name = v48, 
								Case = v41, 
								Weapon = v52
							});
						end;
					elseif not p10 then
						table.insert(v38, {
							Type = "Skin", 
							Name = v48, 
							Case = v41, 
							Count = v53, 
							Weapon = v52, 
							Legendary = v54
						});
					end;				
				end;
			end;
		end;	
	end;
	return v38;
end;
local u4 = shared.require("MenuColorConfig");
function v1.updateCaseImage(p11, p12, p13, p14, p15)
	local v56 = u2.getCaseDataset(p12);
	if p14 == "Case" then
		local v57 = v56.CaseImg;
		if not v57 then
			v57 = false;
			if p14 == "Case Key" then
				v57 = v56["Case KeyImg"];
			end;
		end;
	else
		v57 = false;
		if p14 == "Case Key" then
			v57 = v56["Case KeyImg"];
		end;
	end;
	p11.TextItemName.Text = p12;
	p11.ImageLabel.Image = "rbxassetid://" .. v57;
	p11.RarityFrame.BackgroundColor3 = u4.rarityColorConfig[v56.Tier and 0].Color;
	p11.TextItemDesc.Text = p15 and "";
	if p15 ~= "RANDOM" then
		p11.TextItemDesc.TextColor3 = u4.assignedWeaponColor;
	else
		p11.TextItemDesc.TextColor3 = u4.defaultTextColor;
	end;
	if p13 == 0 then
		p11.TextItemCount.Text = "NONE";
		return;
	end;
	if p13 > 0 then
		p11.TextItemCount.Text = "x" .. p13;
	end;
end;
local l__Templates__5 = shared.require("PageInventoryMenuInterface").getPageFrame().Templates;
function v1.drawInventoryCase(p16, p17, p18, p19, p20, p21)
	local v58 = p16 or l__Templates__5.ButtonInventoryCase:Clone();
	v58.TextItemName.Text = p17;
	v58.ImageLabel.Image = "rbxassetid://" .. p19;
	v58.RarityFrame.BackgroundColor3 = u4.rarityColorConfig[p20 and 0].Color;
	v58.TextItemDesc.Text = p21 and "";
	if p21 ~= "RANDOM" then
		v58.TextItemDesc.TextColor3 = u4.assignedWeaponColor;
	end;
	if not (p18 > 0) then
		v58.TextItemCount.Text = "";
		return v58;
	end;
	v58.TextItemCount.Text = "x" .. p18;
	return v58;
end;
local u6 = shared.require("MenuUtils");
function v1.drawInventorySkin(p22, p23, p24, p25, p26)
	local v59 = nil;
	if p24 and u2.isLegendaryWeapon(p24) then
		local v60 = u2.getSkinDataset(p24);
		v59 = true;
	else
		v60 = u2.getSkinDataset(p23);
	end;
	if not v60 then
		warn(p23, p24, u2.isLegendaryWeapon(p24));
	end;
	local v61 = u4.rarityColorConfig[v60.Rarity and 0];
	local v62 = p22 or l__Templates__5.ButtonInventorySkin:Clone();
	v62.TextItemName.Text = v60.DisplayName and p23;
	v62.ImageLabel.Image = "rbxassetid://" .. v60.TextureId;
	v62.RarityFrame.BackgroundColor3 = v61.Color;
	if p26 then
		local v63 = "RANDOM";
	else
		v63 = p24 and u1.getWeaponDisplayName(p24) or "";
	end;
	v62.TextWeapon.Text = v63;
	if v60.Unlocked then
		local v64 = " / Customizable";
	else
		v64 = "";
	end;
	v62.TextRarity.Text = v61.Name .. v64;
	if v60.ImageColor then
		u6.setBackgroundColor3(v62, v60.ImageColor);
	end;
	if p25 > 0 then
		v62.TextItemCount.Text = "x" .. p25;
	else
		v62.TextItemCount.Text = "";
	end;
	if v59 then
		local v65 = u2.getSkinDataset(p23);
		v62.LegendaryTexture.Image = "rbxassetid://" .. v65.TextureId;
		v62.LegendaryTexture.BorderColor3 = u4.rarityColorConfig[v65.Rarity and 0].Color;
		if v65.ImageColor then
			v62.LegendaryTexture.BackgroundColor3 = v65.ImageColor;
		end;
		v62.LegendaryTexture.Visible = true;
	end;
	return v62;
end;
function v1.drawMultiRollCaseBlank(p27, p28, p29)
	local v66 = u2.getCaseDataset(p27);
	local v67 = l__Templates__5.ButtonInventoryMultiRollBlank:Clone();
	v67.TextItemName.Text = p27;
	v67.ImageLabel.Image = "rbxassetid://" .. v66.CaseImg;
	v67.RarityFrame.BackgroundColor3 = u4.rarityColorConfig[v66.Tier and 0].Color;
	v67.TextItemDesc.Text = p28 and "";
	if p28 ~= "RANDOM" then
		v67.TextItemDesc.TextColor3 = u4.assignedWeaponColor;
	end;
	if not (p29 > 0) then
		v67.TextItemCount.Text = "";
		return v67;
	end;
	v67.TextItemCount.Text = "x" .. p29;
	return v67;
end;
function v1.drawMultiRollCaseTarget(p30, p31)
	local v68 = l__Templates__5.ButtonInventoryMultiRollTarget:Clone();
	v68.TextItemName.Text = p30;
	v68.RarityFrame.BackgroundColor3 = u4.rarityColorConfig[u2.getCaseDataset(p30).Tier and 0].Color;
	u6.clearContainer(v68.ContainerBatch);
	local v69 = v1.getSortedMultiRollBatch(p31);
	for v70 = 1, math.min(4, #v69) do
		local v71 = v69[v70];
		local l__Name__72 = v71.Name;
		local l__Weapon__73 = v71.Weapon;
		local v74 = nil;
		if l__Weapon__73 and u2.isLegendaryWeapon(l__Weapon__73) then
			local v75 = u2.getSkinDataset(l__Weapon__73);
			v74 = true;
		else
			v75 = u2.getSkinDataset(l__Name__72);
		end;
		local v76 = l__Templates__5.DisplayBatchSkin:Clone();
		v76.ImageLabel.Image = "rbxassetid://" .. v75.TextureId;
		v76.ImageLabel.BorderColor3 = u4.rarityColorConfig[v75.Rarity and 0].Color;
		if v75.ImageColor then
			v76.ImageLabel.BackgroundColor3 = v75.ImageColor;
		end;
		if v74 then
			local v77 = u2.getSkinDataset(l__Name__72);
			v76.LegendaryTexture.Image = "rbxassetid://" .. v77.TextureId;
			v76.LegendaryTexture.BorderColor3 = u4.rarityColorConfig[v77.Rarity and 0].Color;
			if v77.ImageColor then
				v76.LegendaryTexture.BackgroundColor3 = v77.ImageColor;
			end;
			v76.LegendaryTexture.Visible = true;
		end;
		v76.Parent = v68.ContainerBatch;
	end;
	return v68;
end;
return v1;

