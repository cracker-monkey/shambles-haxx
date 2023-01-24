
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {
	tradeInRequirement = 6
};
local u1 = require(game:GetService("ReplicatedStorage"):WaitForChild("Content"):WaitForChild("ProductionContent"):WaitForChild("CaseDatabase"));
function v1.getCaseDataset(p1)
	return u1[p1];
end;
local u2 = require(game:GetService("ReplicatedStorage"):WaitForChild("Content"):WaitForChild("ProductionContent"):WaitForChild("CamoDatabase"));
function v1.getSkinDataset(p2)
	return u2[p2];
end;
function v1.getCaseDatasetFromSkin(p3)
	return v1.getCaseDataset(v1.getSkinDataset(p3).Case);
end;
function v1.getSkinRarity(p4)
	local v2 = v1.getSkinDataset(p4);
	if not v2 then
		warn("No skinDataset found for", p4);
	end;
	return v2 and v2.Rarity or 0;
end;
function v1.getSkinCost(p5, p6, p7)
	local v3 = v1.getSkinRarity(p5);
	if p7 and v1.isLegendaryWeapon(p7) then
		v3 = 5;
	end;
	return math.floor(v3 ^ 2 * 250 * (500 + v1.getCaseDatasetFromSkin(p5)["Case KeyCost"].cr) / 5000);
end;
function v1.getCaseRarityList(p8)
	local v4 = {};
	for v5, v6 in next, u1 do
		if v6.Tier == p8 then
			table.insert(v4, v5);
		end;
	end;
	return v4;
end;
function v1.getCaseAssignCost(p9)
	return math.round(v1.getCaseDataset(p9).CaseCost.cr * 0.2);
end;
function v1.getRateText(p10, p11)
	return string.format("%.2f", ({ 60 - p11 * 0.5, 26 - p11 * 0.25, 10, 3 + p11 * 0.5, 1 + p11 * 0.25 })[p10]) .. "%";
end;
local u3 = shared.require("LoadoutConfig");
local u4 = shared.require("ContentDatabase");
local u5 = shared.require("PlayerDataUtils");
function v1.getAllowedWeaponList(p12)
	local v7 = {};
	for v8, v9 in next, u3.assignableWeaponClasses do
		for v10, v11 in next, u4.getWeaponList(v9.weaponClass) do
			if u5.ownsWeapon(p12, v11) then
				local v12 = u4.getWeaponData(v11);
				if not v12.unrollable and not v12.notinmysterybox then
					table.insert(v7, v11);
				end;
			end;
		end;
	end;
	return v7;
end;
function v1.isLegendaryWeapon(p13)
	local v13 = u4.getWeaponData(p13);
	local v14 = v13 and v13.type == "KNIFE";
	return v14;
end;
function v1.getLegendaryWeaponList(p14)
	local v15 = {};
	local v16 = {};
	for v17, v18 in next, u4.getAllWeaponsList() do
		local v19 = u4.getWeaponData(v18);
		if v19.type == "KNIFE" and not v19.unrollable and (not v19.notinmysterybox or u5.ownsWeapon(p14, v18)) then
			v15[#v15 + 1] = v18;
			v16[v18] = true;
		end;
	end;
	return v15, v16;
end;
function v1.pickLegendaryWeapon(p15)
	local v20 = nil;
	local v21 = v1.getLegendaryWeaponList(p15);
	local v22 = #v21;
	for v23 = 1, math.ceil(v22 ^ 0.75) do
		v20 = v21[math.random(1, v22)];
		if not u5.ownsWeapon(p15, v20) then
			return v20;
		end;
	end;
	return v20;
end;
function v1.getSimulatedRollResult(p16, p17, p18)
	local v24 = math.random() * 100;
	local v25 = 61 - 0 * 0.5;
	local v26 = 26 - 0 * 0.5;
	if p18 then
		local v27 = p18;
	elseif v25 + v26 + 10 + (3 + 0 * 0.75) < v24 then
		v27 = 5;
	elseif v25 + v26 + 10 < v24 then
		v27 = 4;
	elseif v25 + v26 < v24 then
		v27 = 3;
	elseif v25 < v24 then
		v27 = 2;
	else
		v27 = 1;
	end;
	local v28 = v1.getCaseDataset(p17).RarityPool[v27];
	local v29 = v1.getAllowedWeaponList(p16);
	return v28[math.random(1, #v28)], v29[math.random(1, #v29)];
end;
local u6 = Random.new(os.clock() * 1.2);
function v1.getRealRollResult(p19, p20, p21)
	local v30 = u5.getPityData(p19)[p20] and 0;
	for v31 = 1, 20 do
		u6:NextNumber();
	end;
	local v32 = u6:NextNumber() * 100;
	local v33 = 60 - v30 * 0.5;
	local v34 = 26 - v30 * 0.25;
	if v33 + v34 + 10 + (3 + v30 * 0.5) < v32 then
		local v35 = "legendary";
		local v36 = 5;
		local v37 = 0;
	elseif v33 + v34 + 10 < v32 then
		v35 = "very rare";
		v36 = 4;
		v37 = 0;
	elseif v33 + v34 < v32 then
		v35 = "rare";
		v36 = 3;
		v37 = v30 + 1;
	elseif v33 < v32 then
		v35 = "uncommon";
		v36 = 2;
		v37 = v30 + 1;
	else
		v35 = "common";
		v36 = 1;
		v37 = v30 + 1;
	end;
	local v38 = v1.getCaseDataset(p20);
	local v39 = nil;
	if v35 == "legendary" then
		v39 = true;
		local v40 = v1.pickLegendaryWeapon(p19);
		local v41 = v38.RarityPool[math.ceil(math.random() * 4)];
		local v42 = v41[math.random(1, #v41)];
	else
		local v43 = v1.getAllowedWeaponList(p19);
		if not p21 then
			v40 = v43[math.random(1, #v43)];
		else
			v40 = p21;
		end;
		local v44 = v38.RarityPool[v36];
		v42 = v44[math.random(1, #v44)];
	end;
	return v42, v40, v39, v37;
end;
function v1.rollCase(p22, p23, p24, p25, p26, p27, p28)
	local v45 = u5.getCasePacketData(p22, p23);
	if not v45 then
		warn("SkinCaseUtils: No casePacketData found for", p23);
		return;
	end;
	if p24 then
		local v46 = v45.Cases.Assigned[p24];
		if not v46 or v46 <= 0 then
			warn("SkinCaseUtils: No cases with assigned weapon found for", p23, p24);
			return;
		end;
	elseif v45.Cases.Count <= 0 then
		warn("SkinCaseUtils: No cases found for", p23);
		return;
	end;
	if v45.Keys <= 0 then
		warn("SkinCaseUtils: No keys found for", p23);
		return;
	end;
	if p24 then
		local l__Assigned__47 = v45.Cases.Assigned;
		l__Assigned__47[p24] = l__Assigned__47[p24] - 1;
		if v45.Cases.Assigned[p24] <= 0 then
			v45.Cases.Assigned[p24] = nil;
		end;
	else
		local l__Cases__48 = v45.Cases;
		l__Cases__48.Count = l__Cases__48.Count - 1;
	end;
	v45.Keys = v45.Keys - 1;
	if not p25 and not p26 then
		local v49, v50, v51, v52 = v1.getRealRollResult(p22, p23, p24);
		p25 = v49;
		p26 = v50;
		p27 = v51;
		p28 = v52;
	end;
	local v53 = v45.Skins[p25];
	if not v53 then
		v53 = {};
		v45.Skins[p25] = v53;
	end;
	if not v53[p26] then
		v53[p26] = 0;
	end;
	v53[p26] = v53[p26] + 1;
	if p27 then
		local v54 = u5.getUnlocksData(p22);
		if not v54[p26] then
			v54[p26] = {};
		end;
		v54[p26].paid = true;
	end;
	u5.getPityData(p22)[p23] = p28;
	return p25, p26, p27, p28;
end;
function v1.rollCaseMulti(p29, p30, p31, p32, p33)
	local v55 = tick();
	if not u5.getCasePacketData(p29, p30) then
		warn("SkinCaseUtils: No casePacketData found for", p30);
		return;
	end;
	local v56, v57 = u5.getCaseAndKeyCount(p29, p30, p31);
	if v56 < p32 or v57 < p32 then
		warn("SkinCaseUtils: Not enough cases / keys for multi roll", p30, p31, p32, v56, v57);
		return;
	end;
	local v58 = false;
	local v59 = {
		selectedSkinName = {}, 
		selectedWeaponName = {}, 
		isLegendary = {}, 
		currentPity = {}
	};
	for v60 = 1, p32 do
		if p33 then
			v1.rollCase(p29, p30, p31, p33.selectedSkinName[v60], p33.selectedWeaponName[v60], p33.isLegendary[tostring(v60)], p33.currentPity[v60]);
		else
			local v61, v62, v63, v64 = v1.rollCase(p29, p30, p31);
			v59.selectedSkinName[v60] = v61;
			v59.selectedWeaponName[v60] = v62;
			v59.isLegendary[v60] = v63;
			v59.currentPity[v60] = v64;
			if v63 then
				v58 = true;
			end;
		end;
	end;
	print(tick() - v55);
	return v59, v58;
end;
function v1.rollTrade(p34, p35, p36, p37, p38)
	if #p35 < v1.tradeInRequirement then
		warn("SkinCaseUtils: Not enough picked skins", p35);
		return;
	end;
	local v65 = v1.getSkinDataset(p35[1].skinName);
	local l__Rarity__7 = v65.Rarity;
	local l__Tier__8 = v1.getCaseDataset(v65.Case).Tier;
	local v66 = {};
	local v67 = {};
	local l__next__68 = next;
	local v69 = nil;
	while true do
		local v70, v71 = l__next__68(p35, v69);
		if not v70 then
			break;
		end;
		local l__skinName__72 = v71.skinName;
		local l__weaponName__73 = v71.weaponName;
		table.insert(v67, v1.getSkinDataset(l__skinName__72).Case);
		if not p35[1] then
			local v74 = true;
		else
			local v75 = v1.getSkinDataset(l__skinName__72);
			local l__Tier__76 = v1.getCaseDataset(v75.Case).Tier;
			v74 = false;
			if l__Rarity__7 == v75.Rarity then
				v74 = l__Tier__8 == l__Tier__76;
			end;
		end;
		if not v74 then
			warn("SkinCaseUtils: Incompatible skins in pickedSkinList", l__skinName__72, p35);
			return;
		end;
		if not v66[l__skinName__72] then
			v66[l__skinName__72] = {};
		end;
		if not v66[l__skinName__72][l__weaponName__73] then
			v66[l__skinName__72][l__weaponName__73] = 0;
		end;
		local v77 = v66[l__skinName__72];
		v77[l__weaponName__73] = v77[l__weaponName__73] + 1;	
	end;
	for v78, v79 in next, v66 do
		for v80, v81 in next, v79 do
			local l__Case__82 = v1.getSkinDataset(v78).Case;
			local v83 = u5.getCasePacketData(p34, l__Case__82);
			if not v83 then
				warn("SkinCaseUtils: No casePacketData found for trade rolling", l__Case__82, v78, v80, p35, v83);
				return;
			end;
			local v84 = v83.Skins[v78];
			if not v84 then
				warn("SkinCaseUtils: No skinPacketData found for trade rolling", l__Case__82, v78, v80, p35, v83);
				return;
			end;
			local v85 = v84[v80] and 0;
			if v85 < v81 then
				warn("SkinCaseUtils: Not enough weapon skins for trade rolling", l__Case__82, v78, v80, v85, v81, p35, v83);
				return;
			end;
		end;
	end;
	if not p36 and not p37 then
		local v86 = nil;
		local v87 = v67[math.random(1, #v67)];
		v86 = v1.getCaseDataset(v87);
		if l__Rarity__7 == 4 then
			p38 = true;
			p37 = v1.pickLegendaryWeapon(p34);
			local v88 = v86.RarityPool[math.ceil(math.random() * 4)];
			p36 = v88[math.random(1, #v88)];
		else
			local v89 = v1.getAllowedWeaponList(p34);
			p37 = v89[math.random(1, #v89)];
			local v90 = v86.RarityPool[l__Rarity__7 + 1];
			p36 = v90[math.random(1, #v90)];
		end;
	else
		v87 = v1.getSkinDataset(p36).Case;
		local v91 = v1.getCaseDataset(v87);
	end;
	local v92 = u5.getCasePacketData(p34, v87, true);
	local v93 = v92.Skins[p36];
	if not v93 then
		v93 = {};
		v92.Skins[p36] = v93;
	end;
	if not v93[p37] then
		v93[p37] = 0;
	end;
	v93[p37] = v93[p37] + 1;
	if p38 then
		local v94 = u5.getUnlocksData(p34);
		if not v94[p37] then
			v94[p37] = {};
		end;
		v94[p37].paid = true;
	end;
	for v95, v96 in next, v66 do
		for v97, v98 in next, v96 do
			local v99 = u5.getCasePacketData(p34, v1.getSkinDataset(v95).Case).Skins[v95];
			v99[v97] = v99[v97] - v98;
			if v99[v97] <= 0 then
				v99[v97] = nil;
			end;
		end;
	end;
	print("traded skin result", p36, p37, p38);
	return p36, p37, p38;
end;
function v1.awardItem(p39, p40, p41)
	local v100 = nil;
	local v101 = v1.getCaseDataset(p41);
	v100 = u5.getCasePacketData(p39, p41, true);
	if p40 == "Case" then
		local l__Cases__102 = v100.Cases;
		l__Cases__102.Count = l__Cases__102.Count + 1;
	elseif p40 == "Case Key" then
		v100.Keys = v100.Keys + 1;
	end;
	return true;
end;
function v1.purchaseCaseKeyCredit(p42, p43, p44)
	p44 = math.round(p44);
	local v103 = u5.getCasePacketData(p42, p43, true);
	local v104 = v1.getCaseDataset(p43)["Case KeyCost"].cr * p44;
	if p42.stats.money <= v104 then
		warn("SkinCaseUtils: Not enough credits to purchase", p44, p43, "Keys");
		return;
	end;
	v103.Keys = v103.Keys + p44;
	local l__stats__105 = p42.stats;
	l__stats__105.money = l__stats__105.money - v104;
	return true, v104;
end;
function v1.purchaseCaseCredit(p45, p46, p47, p48)
	p47 = math.round(p47);
	local v106 = u5.getCasePacketData(p45, p46, true);
	local v107 = v1.getCaseDataset(p46).CaseCost.cr * p47;
	if p45.stats.money <= v107 then
		warn("SkinCaseUtils: Not enough credits to purchase", p47, p46, "Cases", p48);
		return;
	end;
	if p48 then
		if not u5.ownsWeapon(p45, p48) or not table.find(v1.getAllowedWeaponList(p45), p48) or v1.isLegendaryWeapon(p48) then
			warn("SkinCaseUtils: Invalid weapon to assign case", p48, p46, p47);
			return;
		end;
		if not v106.Cases.Assigned[p48] then
			v106.Cases.Assigned[p48] = 0;
		end;
		local l__Assigned__108 = v106.Cases.Assigned;
		l__Assigned__108[p48] = l__Assigned__108[p48] + p47;
	else
		local l__Cases__109 = v106.Cases;
		l__Cases__109.Count = l__Cases__109.Count + p47;
	end;
	local l__stats__110 = p45.stats;
	l__stats__110.money = l__stats__110.money - v107;
	return true, v107;
end;
function v1.purchaseCaseAssign(p49, p50, p51, p52)
	p51 = math.round(p51);
	if p52 and u5.ownsWeapon(p49, p52) and table.find(v1.getAllowedWeaponList(p49), p52) and not v1.isLegendaryWeapon(p52) then
		local v111 = u5.getCasePacketData(p49, p50);
		if v111.Cases.Count < p51 then
			warn("SkinCaseUtils: Not enough unassigned cases to assign", p50, v111.Cases.Count, p51, p52);
			return;
		else
			local v112 = v1.getCaseAssignCost(p50) * p51;
			if p49.stats.money <= v112 then
				warn("SkinCaseUtils: Not enough credits to assign cases", p51, p50, "Cases", p52);
				return;
			else
				if not v111.Cases.Assigned[p52] then
					v111.Cases.Assigned[p52] = 0;
				end;
				local l__Assigned__113 = v111.Cases.Assigned;
				l__Assigned__113[p52] = l__Assigned__113[p52] + p51;
				local l__Cases__114 = v111.Cases;
				l__Cases__114.Count = l__Cases__114.Count - p51;
				local l__stats__115 = p49.stats;
				l__stats__115.money = l__stats__115.money - v112;
				return true;
			end;
		end;
	end;
	warn("SkinCaseUtils: Invalid weapon to assign case", p52, p50, p51);
end;
function v1.sellSkin(p53, p54, p55, p56)
	local v116 = u5.getCasePacketData(p53, p54);
	if not v116 then
		warn("SkinCaseUtils: No casePacketData found for player selling skin", p55, p56);
		return false;
	end;
	local v117 = v116.Skins[p55];
	if not v117 then
		warn("SkinCaseUtils: No skinPacketData found for player selling skin", p55, p56);
		return false;
	end;
	if not v117[p56] or v117[p56] <= 0 then
		warn("SkinCaseUtils: No enough weapon skins to sell", p55, p56, v117[p56]);
		return false;
	end;
	if p56 == "ALL" then
		warn("SkinCaseUtils: Cannot sell special skin", p55);
		return false;
	end;
	local v118 = v1.getSkinCost(p55, p54, p56);
	local l__stats__119 = p53.stats;
	l__stats__119.money = l__stats__119.money + v118;
	v117[p56] = v117[p56] - 1;
	if v117[p56] <= 0 then
		v117[p56] = nil;
	end;
	return true, v118;
end;
return v1;

