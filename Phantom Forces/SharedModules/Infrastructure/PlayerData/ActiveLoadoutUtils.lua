
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("PlayerDataUtils");
function v1.getActiveClassSlot(p1)
	local v2 = u1.getClassData(p1);
	if not v2 then
		warn("no class data found", p1);
	end;
	return v2.curclass;
end;
function v1.getActiveLoadoutData(p2)
	local v3 = u1.getClassData(p2);
	return v3[v3.curclass];
end;
function v1.getActiveWeaponLoadout(p3, p4)
	return v1.getActiveLoadoutData(p3)[p4];
end;
function v1.getPastWeaponLoadoutData(p5, p6, p7)
	local v4 = u1.getGunLoadoutData(p5);
	if not v4[p6] then
		v4[p6] = {};
	end;
	if not v4[p6][p7] then
		v4[p6][p7] = {};
	end;
	local v5 = v4[p6][p7];
	if not v5.Attachments then
		v5.Attachments = {};
	end;
	if not v5.Camo then
		v5.Camo = {};
	end;
	return v5;
end;
local u2 = shared.require("ActiveLoadoutEvents");
function v1.changeClassSlot(p8, p9)
	local v6 = u1.getClassData(p8);
	if not v6[p9] then
		warn("ActiveLoadoutUtils: Invalid class slot", p9);
		return;
	end;
	v6.curclass = p9;
	u2.onClassChanged:fire(p9);
	return true;
end;
local u3 = shared.require("ContentDatabase");
local u4 = shared.require("LoadoutConfig");
local u5 = shared.require("LuaUtils");
function v1.changeWeapon(p10, p11, p12)
	local v7 = v1.getActiveLoadoutData(p10);
	if not v7[p11] then
		warn("ActiveLoadoutUtils: Invalid loadout slot", p10, p11, p12, debug.traceback());
		return;
	end;
	if not u1.ownsWeapon(p10, p12) then
		warn("ActiveLoadoutUtils: Invalid loadout player doesn't own weapon", p12);
		return;
	end;
	local v8 = v1.getActiveClassSlot(p10);
	local v9 = u3.getWeaponClass(p12);
	local v10 = false;
	for v11, v12 in u4.classSlots[p11][v8], nil do
		if v12 == v9 then
			v10 = true;
			break;
		end;
	end;
	if not v10 then
		warn(string.format("ActiveLoadoutUtils: player tried equipping weapon %s of class %s in loadout class %s", p12, v9, v8));
		return;
	end;
	local v13 = v1.getPastWeaponLoadoutData(p10, v8, p12);
	v7[p11].Attachments = u5.deepCopy(v13.Attachments);
	v7[p11].Camo = u5.deepCopy(v13.Camo);
	v7[p11].Name = p12;
	u2.onLoadoutChanged:fire(v8, v7);
	return true;
end;
function v1.changeAttachment(p13, p14, p15, p16)
	local v14 = v1.getActiveLoadoutData(p13);
	local v15 = v1.getActiveClassSlot(p13);
	local v16 = v14[p14];
	local l__Name__17 = v16.Name;
	if p16 and not u1.ownsAttachment(p13, p16, l__Name__17, p15) then
		return;
	end;
	if not u4.attachmentSlots[p14] or not table.find(u4.attachmentSlots[p14], p15) then
		warn("ActiveLoadoutUtils: Invalid attachment slot", p14, p15, p16);
		return;
	end;
	local v18 = u3.getAttachments(l__Name__17);
	if p16 and (not v18[p15] or not v18[p15][p16]) then
		warn("ActiveLoadoutUtils:", p16, "attachment not found in weaponData", l__Name__17, p15);
		return;
	end;
	if not v16.Attachments then
		v16.Attachments = {};
	end;
	v16.Attachments[p15] = p16;
	v1.getPastWeaponLoadoutData(p13, v15, l__Name__17).Attachments[p15] = p16;
	u2.onLoadoutChanged:fire(v15, v14);
	return true;
end;
function v1.resetAttachments(p17, p18)
	local v19 = v1.getActiveLoadoutData(p17);
	local v20 = v19[p18];
	local l__Name__21 = v20.Name;
	if not v20.Attachments then
		v20.Attachments = {};
	end;
	for v22 in v20.Attachments, nil do
		v1.changeAttachment(p17, p18, v22, nil);
	end;
	u2.onLoadoutChanged:fire(v1.getActiveClassSlot(p17), v19);
	return true;
end;
function v1.changeSightColors(p19, p20, p21, p22)
	local v23 = u1.getAttachmentSettings(p19, p20, p21);
	local v24 = u1.getAttachmentKills(p19, p20, p21);
	if v24 < u1.sightColorKillReq then
		warn("PlayerDataUtils: Not enough attachment kills to change sight colors", v24, p20, p21, p22);
		return;
	end;
	if not p22 then
		v23.sightcolor = nil;
		return true;
	end;
	if not v23.sightcolor then
		v23.sightcolor = {
			r = 255, 
			g = 255, 
			b = 255
		};
	end;
	if type(p22) ~= "table" then
		warn("PlayerDataUtils: reticleColorData is not a table format", p20, p21, p22);
		return false;
	end;
	if not tonumber(p22.r) or not tonumber(p22.g) or not tonumber(p22.b) then
		warn("PlayerDataUtils: reticleColorData does not contain valid numbers", p20, p21, p22);
		return false;
	end;
	v23.sightcolor.r = math.max(math.min(p22.r, 255), 0);
	v23.sightcolor.g = math.max(math.min(p22.g, 255), 0);
	v23.sightcolor.b = math.max(math.min(p22.b, 255), 0);
	return true;
end;
local u6 = require(game:GetService("ReplicatedStorage"):WaitForChild("Content"):WaitForChild("ProductionContent"):WaitForChild("CamoDatabase"));
function v1.changeCamo(p23, p24, p25, p26)
	local v25 = v1.getActiveLoadoutData(p23);
	local v26 = v1.getActiveClassSlot(p23);
	local v27 = v25[p24];
	local l__Name__28 = v27.Name;
	local v29 = u3.getCamoSlots(l__Name__28)[p25];
	if not v29 then
		warn("ActiveLoadoutUtils: Invalid camo slot", p25);
		return;
	end;
	if p26 and not u6[p26] then
		warn("ActiveLoadoutUtils: Missing camo skin name in database", p26);
		return;
	end;
	if not v27.Camo then
		v27.Camo = {};
	end;
	v27.Camo[v29] = {};
	v27.Camo[v29].Name = p26;
	local v30 = v1.getPastWeaponLoadoutData(p23, v26, l__Name__28);
	v30.Camo[v29] = {};
	v30.Camo[v29].Name = p26;
	u2.onLoadoutChanged:fire(v26, v25);
	return true;
end;
function v1.validateCamoProperty(p27, p28, p29, p30)
	local l__camoPropertyTypes__31 = u4.camoPropertyTypes;
	if not l__camoPropertyTypes__31[p27] then
		warn("ActiveLoadoutUtils: Invalid property type given", p27);
		return false;
	end;
	local v32 = l__camoPropertyTypes__31[p27][p28];
	if not v32 then
		warn("ActiveLoadoutUtils: Invalid property name given", p28);
		return false;
	end;
	if p29 then
		if v32.type ~= type(p29) then
			warn("ActiveLoadoutUtils: Invalid value type", p28, v32.type, type(p29));
			return false;
		end;
		if v32.values and not v32.values[p29] then
			warn("ActiveLoadoutUtils: Invalid value", p28, p29);
			return false;
		end;
		if v32.type == "table" and v32.structure then
			for v33, v34 in next, v32.structure do
				if type(p29[v33]) ~= v34 then
					warn("ActiveLoadoutUtils: Invalid structure", p28, p29);
					return false;
				end;
			end;
		end;
	end;
	return true;
end;
function v1.changeCamoProperty(p31, p32, p33, p34, p35, p36)
	local v35 = v1.getActiveWeaponLoadout(p31, p32);
	local v36 = v1.getActiveClassSlot(p31);
	local l__Name__37 = v35.Name;
	local v38 = u3.getCamoSlots(l__Name__37)[p33];
	if not v38 then
		warn("ActiveLoadoutUtils: Invalid camo slot", p33);
		return;
	end;
	if not v35.Camo or not v35.Camo[v38] or not v35.Camo[v38].Name then
		warn("ActiveLoadoutUtils: No camo data found for changeCamoProperty", p32, p33, p34, p35, p36);
		return;
	end;
	if not v1.validateCamoProperty(p34, p35, p36) then
		warn("ActiveLoadoutUtils: Failed camo property validation");
		return;
	end;
	if not v35.Camo[v38][p34] then
		v35.Camo[v38][p34] = {};
	end;
	v35.Camo[v38][p34][p35] = p36;
	local v39 = v1.getPastWeaponLoadoutData(p31, v36, l__Name__37);
	if not v39.Camo[v38] then
		warn("ActiveLoadoutUtils: No past loadout camo cache found for", v36, l__Name__37, v38);
	else
		if not v39.Camo[v38][p34] then
			v39.Camo[v38][p34] = {};
		end;
		v39.Camo[v38][p34][p35] = p36;
	end;
	u2.onLoadoutChanged:fire(v36, (v1.getActiveLoadoutData(p31)));
	return true;
end;
return v1;

