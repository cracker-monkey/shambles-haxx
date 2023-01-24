
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	tagCost = 70000, 
	sightColorKillReq = 200, 
	rankUpCreditsCalculator = function(p1, p2)
		return 5 * (p2 - p1) * (81 + p2 + p1) / 2;
	end, 
	rankCalculator = function(p3)
		p3 = p3 and 0;
		return math.floor((0.25 + p3 / 500) ^ 0.5 - 0.5);
	end, 
	expCalculator = function(p4)
		p4 = p4 and 0;
		return math.floor(500 * ((p4 + 0.5) ^ 2 - 0.25));
	end, 
	gunPriceCalculator = function(p5, p6)
		if p6 then
			local v1 = 0.9;
		else
			v1 = 1;
		end;
		return math.ceil((1000 + 200 * p5) * 0.7 * v1);
	end, 
	attachPriceCalculator = function(p7, p8)
		if p8 then
			local v2 = 0.9;
		else
			v2 = 1;
		end;
		return math.ceil((200 + p7) * 0.7 * v2);
	end, 
	getPlayerCredits = function(p9)
		return p9.stats.money;
	end, 
	getPlayerRank = function(p10)
		return u1.rankCalculator(p10.stats.experience);
	end, 
	getAttLoadoutData = function(p11)
		local v3 = p11.settings.attloadoutdata;
		if not v3 then
			v3 = {};
			p11.settings.attloadoutdata = v3;
		end;
		return v3;
	end, 
	getGunLoadoutData = function(p12)
		local v4 = p12.settings.gunloadoutdata;
		if not v4 then
			v4 = {};
			p12.settings.gunloadoutdata = v4;
		end;
		return v4;
	end, 
	getUnlocksData = function(p13)
		local v5 = p13.unlocks;
		if not v5 then
			v5 = {};
			p13.unlocks = v5;
		end;
		return v5;
	end, 
	getClassData = function(p14)
		local v6 = p14.settings.classdata;
		if not v6 then
			v6 = {};
			p14.settings.classdata = v6;
		end;
		return v6;
	end, 
	getInventoryData = function(p15)
		local v7 = p15.inventorydatav2;
		if not v7 then
			v7 = {};
			p15.inventorydatav2 = v7;
		end;
		return v7;
	end, 
	getOptionsData = function(p16)
		local v8 = p16.settings.optionsv2;
		if not v8 then
			v8 = {};
			p16.settings.optionsv2 = v8;
		end;
		return v8;
	end, 
	getPityData = function(p17)
		local v9 = p17.settings.pitydata;
		if not v9 then
			v9 = {};
			p17.settings.pitydata = v9;
		end;
		return v9;
	end, 
	getTagData = function(p18)
		if not p18.settings.tagdata then
			p18.settings.tagdata = {
				text = "", 
				r = 255, 
				g = 255, 
				b = 255
			};
		end;
		return p18.settings.tagdata;
	end, 
	isNewWeapon = function(p19, p20)
		if not u1.ownsWeapon(p19, p20) then
			return false;
		end;
		for v10, v11 in u1.getGunLoadoutData(p19), nil do
			if v11[p20] and u1.getGunKills(p19, p20) > 0 then
				return false;
			end;
		end;
		return true;
	end
};
local u2 = shared.require("ContentDatabase");
local u3 = shared.require("InstanceType");
function u1.ownsWeapon(p21, p22)
	local v12 = u1.getUnlocksData(p21);
	local v13 = u2.getWeaponData(p22);
	if not v13 then
		warn("PlayerDataUtils: No gunData found for", p22, debug.traceback());
		return false;
	end;
	if p21.superuser then
		return true;
	end;
	if v13.supertest then
		if p21.supertester then
			return true;
		else
			return false;
		end;
	end;
	if v13.exclusiveunlock then
		return v12[p22] and v12[p22].paid or false;
	end;
	if u3.IsVIP() then
		return true;
	end;
	if u2.isTestWeapon(p22) and u3.IsTest() then
		return true;
	end;
	if not ((v13.unlockrank and 0) <= u1.getPlayerRank(p21)) and (not v12[p22] or not v12[p22].paid) then
		return false;
	end;
	return true;
end;
function u1.canPurchaseWeapon(p23)
	local v14 = u2.getWeaponData(p23);
	if not v14 then
		warn("PlayerDataUtils: No gunData found for", p23, debug.traceback());
		return false;
	end;
	if v14.supertest then
		return false;
	end;
	if v14.exclusiveunlock then
		return false;
	end;
	return true;
end;
function u1.canPurchaseAttachment(p24, p25, p26)
	local v15 = u2.getAttachmentData(p26, p24, p25);
	if not v15 then
		warn("PlayerDataUtils: No attachmentData found for", p24, p25, p26, debug.traceback());
		return false;
	end;
	if v15.supertest then
		return false;
	end;
	return true;
end;
function u1.getGunKills(p27, p28)
	local v16 = u1.getUnlocksData(p27);
	return v16[p28] and tonumber(v16[p28].kills) or 0;
end;
function u1.getNextWeaponUnlockList(p29)
	local v17 = u1.getPlayerRank(p29);
	local v18 = {};
	for v19, v20 in u2.getAllWeaponsList() do
		local v21 = u2.getWeaponData(v20);
		local l__unlockrank__22 = v21.unlockrank;
		if l__unlockrank__22 and not v21.supertest and not v21.hideunlessowned and v17 < l__unlockrank__22 and not u1.ownsWeapon(p29, v20) then
			v18[#v18 + 1] = {
				weaponName = v20, 
				weaponRank = l__unlockrank__22
			};
		end;
	end;
	table.sort(v18, function(p30, p31)
		return p30.weaponRank < p31.weaponRank;
	end);
	return v18;
end;
function u1.getWeaponAttData(p32, p33)
	local v23 = u1.getAttLoadoutData(p32);
	if not v23[p33] then
		v23[p33] = {};
	end;
	return v23[p33];
end;
function u1.getAttachmentKills(p34, p35, p36)
	local v24 = u1.getWeaponAttData(p34, p35);
	return v24[p36] and v24[p36].kills or 0;
end;
function u1.getAttachmentSettings(p37, p38, p39)
	local v25 = u1.getWeaponAttData(p37, p38);
	if not v25[p39] then
		v25[p39] = {};
	end;
	if not v25[p39].settings then
		v25[p39].settings = {};
	end;
	return v25[p39].settings;
end;
function u1.getCamoList(p40, p41)
	local v26 = {};
	for v27, v28 in u1.getInventoryData(p40), nil do
		for v29, v30 in v28.Skins, nil do
			for v31, v32 in v30, nil do
				if p41 == v31 or v31 == "ALL" then
					table.insert(v26, v29);
				end;
			end;
		end;
	end;
	return v26;
end;
function u1.ownsAttachment(p42, p43, p44, p45)
	local v33 = u1.getUnlocksData(p42);
	local v34 = u2.getAttachmentData(p43, p44, p45);
	if p42.superuser then
		return true;
	end;
	if u2.getWeaponData(p44).supertest or v34.supertest then
		if p42.supertester then
			return true;
		else
			return false;
		end;
	end;
	if (u2.isTestAttachment(p43) or u2.isTestWeapon(p44)) and u3.IsTest() then
		return true;
	end;
	if u3.IsVIP() then
		return true;
	end;
	if v33[p44] and v33[p44][p43] then
		return true;
	end;
	if v34.unlockkills <= u1.getGunKills(p42, p44) then
		return true;
	end;
	return false;
end;
function u1.getCasePacketData(p46, p47, p48)
	local v35 = u1.getInventoryData(p46);
	local v36 = v35[p47];
	if not v36 and p48 then
		v36 = {
			Cases = {
				Count = 0, 
				Assigned = {}
			}, 
			Keys = 0, 
			Skins = {}
		};
		v35[p47] = v36;
	end;
	return v36;
end;
function u1.getCaseAndKeyCount(p49, p50, p51)
	local v37 = u1.getCasePacketData(p49, p50);
	if not v37 then
		return 0, 0;
	end;
	local v38 = 0;
	if not p51 then
		v38 = v37.Cases.Count;
	else
		for v39, v40 in v37.Cases.Assigned, nil do
			if v39 == p51 then
				v38 = v40;
			end;
		end;
	end;
	return v38, v37.Keys;
end;
function u1.getTotalCaseAndKeyCount(p52, p53)
	local v41 = u1.getCasePacketData(p52, p53);
	if not v41 then
		return 0, 0;
	end;
	local v42 = v41.Cases.Count;
	for v43, v44 in v41.Cases.Assigned, nil do
		v42 = v42 + v44;
	end;
	return v42, v41.Keys;
end;
function u1.getWeaponBuildPrice(p54, p55, p56, p57)
	local v45 = u1.getGunKills(p55, p56);
	local v46 = 0;
	local v47 = {};
	local v48 = {};
	local v49 = 0;
	for v50, v51 in p57, nil do
		if v51 ~= "" then
			local v52 = u2.getAttachmentData(v51, p56, v50).unlockkills - v45;
			if v52 > 0 and not u1.ownsAttachment(p55, v51, p56, v50) then
				local v53 = u1.attachPriceCalculator(v52, p54.MembershipType == Enum.MembershipType.Premium);
				v46 = v46 + v53;
				v49 = v49 + 1;
				v48[v50] = v51;
				v47[v50] = v53;
			end;
		end;
	end;
	local v54 = u2.getWeaponData(p56).unlockrank - u1.getPlayerRank(p55);
	local v55 = nil;
	if v54 > 0 and not u1.ownsWeapon(p55, p56) then
		local v56 = u1.gunPriceCalculator(v54, p54.MembershipType == Enum.MembershipType.Premium);
		v46 = v46 + v56;
		v55 = p56;
		v47[v55] = v56;
	end;
	return v46, v55, v48, v49, v47;
end;
function u1.purchaseWeapon(p58, p59, p60, p61, p62)
	local v57 = u1.getPlayerCredits(p59);
	local v58, v59, v60 = u1.getWeaponBuildPrice(p58, p59, p61, p62);
	if v57 < v58 then
		warn("PlayerDataUtils: Player attempting to make invalid purchase", p61, p62, v57);
		return;
	end;
	for v61, v62 in p62, nil do
		if v62 ~= "" and not u1.canPurchaseAttachment(p61, v61, v62) then
			warn("PlayerDataUtils: Player attempting to purchase unobtainable attachment", p61, v61, v62);
			return;
		end;
	end;
	if not u1.canPurchaseWeapon(p61) then
		warn("PlayerDataUtils: Player attempting to purchase unobtainable weapon", p61);
		return;
	end;
	local v63 = u1.getUnlocksData(p59);
	if v59 then
		local v64 = v63[v59];
		if not v64 then
			v64 = {};
			v63[v59] = v64;
		end;
		v64.paid = true;
	end;
	for v65, v66 in v60, nil do
		local v67 = v63[p61];
		if not v67 then
			v67 = {};
			v63[p61] = v67;
		end;
		v67[v66] = true;
	end;
	p59.stats.money = p59.stats.money - v58;
	return true;
end;
function u1.purchaseCredits(p63, p64)
	if not p63.stats.money then
		p63.stats.money = 0;
	end;
	local l__stats__68 = p63.stats;
	l__stats__68.money = l__stats__68.money + p64;
	return true;
end;
function u1.changeTag(p65, p66, p67)
	local v69 = u1.getTagData(p65);
	if p66 then
		v69.text = p66;
	end;
	if p67 then
		v69.r = p67.r or v69.r;
		v69.g = p67.g or v69.g;
		v69.b = p67.b or v69.b;
	end;
end;
function u1.changeTagColor(p68, p69)
	local v70 = u1.getTagData(p68);
	local v71 = {};
	for v72, v73 in p69, nil do
		if not tonumber(v73) then
			warn("PlayerDataUtils: changeTagColor received a non-number", p69, v72, v73);
			return false;
		end;
		v71[v72] = math.min(255, (math.max(0, v73)));
	end;
	u1.changeTag(p68, nil, v71);
	return true;
end;
function u1.purchaseTag(p70, p71, p72)
	if not p70.stats.money then
		p70.stats.money = 0;
	end;
	if p70.stats.money < 70000 then
		warn("PlayerDataUtils: Not enough credits to purchase tag", p70.stats.money, p71);
		return false;
	end;
	if p72 then
		p72(70000);
	end;
	u1.changeTag(p70, p71);
	local l__stats__74 = p70.stats;
	l__stats__74.money = l__stats__74.money - u1.tagCost;
	return true;
end;
local u4 = require(game:GetService("ReplicatedStorage"):WaitForChild("Content"):WaitForChild("ProductionContent"):WaitForChild("CamoDatabase"));
function u1.convertInventoryData(p73)
	local u5 = {};
	local function v75(p74)
		if not u5[p74] then
			u5[p74] = {
				Cases = {
					Count = 0, 
					Assigned = {}
				}, 
				Keys = 0, 
				Skins = {}
			};
		end;
		return u5[p74];
	end;
	for v76, v77 in p73, nil do
		local l__Type__78 = v77.Type;
		if l__Type__78 == "Case" then
			local v79 = v75(v77.Name);
			local l__Wep__80 = v77.Wep;
			if l__Wep__80 then
				if not v79.Cases.Assigned[l__Wep__80] then
					v79.Cases.Assigned[l__Wep__80] = 0;
				end;
				local l__Assigned__81 = v79.Cases.Assigned;
				l__Assigned__81[l__Wep__80] = l__Assigned__81[l__Wep__80] + 1;
			else
				local l__Cases__82 = v79.Cases;
				l__Cases__82.Count = l__Cases__82.Count + 1;
			end;
		elseif l__Type__78 == "Case Key" then
			local v83 = v75(v77.Name);
			v83.Keys = v83.Keys + 1;
		elseif l__Type__78 == "Skin" then
			local l__Wep__84 = v77.Wep;
			local l__Name__85 = v77.Name;
			local v86 = u4[l__Name__85] and u4[l__Name__85].Case;
			if v86 then
				local v87 = v75(v86);
				if not v87.Skins[l__Name__85] then
					v87.Skins[l__Name__85] = {};
				end;
				if not v87.Skins[l__Name__85][l__Wep__84] then
					v87.Skins[l__Name__85][l__Wep__84] = 0;
				end;
				local v88 = v87.Skins[l__Name__85];
				v88[l__Wep__84] = v88[l__Wep__84] + 1;
			else
				warn("PlayerDataUtils: Did not find case name for camo", l__Name__85);
			end;
		end;
	end;
	return u5;
end;
local u6 = {
	fov = "fov", 
	looksen = "looksens", 
	aimsen = "aimsens", 
	controllersens = "controllerlooksens", 
	controlleraimsens = "controlleraimsens", 
	controllerymult = "controllerverticalmult", 
	aimaccel = "controlleraimaccel", 
	lookaccel = "controllerlookccel"
};
function u1.portSettings(p75)
	local v89 = {};
	for v90, v91 in p75, nil do
		if u6[v90] then
			v89[u6[v90]] = v91;
		end;
	end;
	for v92, v93 in v89, nil do
		p75[v92] = v93;
	end;
end;
return u1;

