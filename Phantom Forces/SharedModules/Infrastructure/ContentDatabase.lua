
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("DatabaseObject");
local v3 = v2.new(game:GetService("ReplicatedStorage"):WaitForChild("Content"), true);
local v4 = v2.new(v3:get("ProductionContent"), true);
local v5 = v2.new(v3:get("TestContent"), true);
local u1 = {};
local u2 = shared.require("InstanceType").IsTest();
local u3 = v5:get("WeaponDatabase");
function v1.isTestWeapon(p1)
	if not u2 then
		return false;
	end;
	if not p1 then
		warn("ContentDatabase: weaponName passed is nil");
		return;
	end;
	local v6 = u3:FindFirstChild(p1, true);
	return v6 and v6:IsA("Folder");
end;
local u4 = v4:get("WeaponDatabase");
local function u5(p2, p3)
	if not p2 then
		return;
	end;
	local v7 = u1["weaponModel" .. p3];
	if not v7 then
		v7 = {};
		u1["weaponModel" .. p3] = v7;
	end;
	local v8 = v7[p2];
	if not v8 then
		local v9 = u2 and u3:FindFirstChild(p2, true) or u4:FindFirstChild(p2, true);
		if v9 then
			local v10 = v9:FindFirstChild(p3);
			if v10 then
				v8 = v10;
			end;
		end;
		v7[p2] = v8;
	end;
	return v8;
end;
function v1.getWeaponModule(p4)
	return u5(p4, p4);
end;
function v1.getWeaponData(p5, p6)
	local v11 = u1.weaponRequire;
	if not v11 then
		v11 = {};
		u1.weaponRequire = v11;
	end;
	local v12 = v11[p5];
	if not v12 or p6 then
		local v13 = v1.getWeaponModule(p5);
		if not v13 then
			return;
		end;
		if p6 then
			local v14 = v13:Clone();
			v14.Parent = v13.Parent;
			v12 = require(v14);
			v14:Destroy();
		else
			v12 = require(v13);
		end;
		v11[p5] = v12;
	end;
	return v12;
end;
function v1.getWeaponModel(p7)
	return u5(p7, "Main");
end;
function v1.getExternalModel(p8)
	return u5(p8, "External");
end;
function v1.getWeaponDisplayName(p9, p10)
	if not p10 then
		local v15 = v1.getWeaponData(p9);
		if not v15 then
			return p9;
		else
			return v15.displayname and p9;
		end;
	end;
	local v16 = nil;
	local v17 = v1.getWeaponData(p9);
	for v18, v19 in p10, nil do
		if v19 ~= "" then
			local v20 = v1.getAttachmentModule(v19);
			if v20 then
				local v21 = require(v20);
				if not v17.attachments[v18][v19] then
					error(string.format("Attachment not found %s %s", p9, v19));
				end;
				local v22 = v17.attachments[v18][v19].displayname or v21.stats and v21.stats.displayname;
				if v22 then
					v16 = v22;
					break;
				end;
			else
				error(string.format("Attachment module not found %s %s", p9, v19));
			end;
		end;
	end;
	return v16 or (v17.displayname or p9);
end;
function v1.getWeaponClass(p11)
	local v23 = v1.getWeaponModule(p11);
	if not v23 then
		warn("ContentDatabase: No weaponModule found for", p11);
		return;
	end;
	return v23.Parent.Parent.Name;
end;
function v1.getWeaponList(p12)
	local v24 = u1["weaponList" .. p12];
	if v24 then
		return v24;
	end;
	local v25 = u4:FindFirstChild(p12);
	if not v25 then
		warn("ContentDatabase: No weaponClassFolder found for", p12);
		return;
	end;
	local v26 = {};
	for v27, v28 in v25() do
		if v28:IsA("Folder") then
			table.insert(v26, v28.Name);
		else
			warn("ContentDatabase: Non-folder object found in", p12, v28);
		end;
	end;
	if u2 then
		local v29 = u3:FindFirstChild(p12);
		if v29 then
			for v30, v31 in v29() do
				if v31:IsA("Folder") then
					if not table.find(v26, v31.Name) then
						table.insert(v26, v31.Name);
					end;
				else
					warn("ContentDatabase: Non-folder object found in test", p12, v31);
				end;
			end;
		end;
	end;
	u1["weaponList" .. p12] = v26;
	return v26;
end;
function v1.getAllWeaponsList()
	local l__allWeaponsList__32 = u1.allWeaponsList;
	if l__allWeaponsList__32 then
		return l__allWeaponsList__32;
	end;
	local v33 = {};
	for v34, v35 in u4() do
		for v36, v37 in v35() do
			if v37:IsA("Folder") then
				table.insert(v33, v37.Name);
			else
				warn("ContentDatabase: Non-folder object found in", v34, v37);
			end;
		end;
	end;
	if u2 then
		for v38, v39 in u3() do
			for v40, v41 in v39() do
				if v41:IsA("Folder") then
					if not table.find(v33, v41.Name) then
						table.insert(v33, v41.Name);
					end;
				else
					warn("ContentDatabase: Non-folder object found in test", v38, v41);
				end;
			end;
		end;
	end;
	u1.allWeaponsList = v33;
	return v33;
end;
local u6 = shared.require("LoadoutConfig");
function v1.getCamoSlots(p13)
	local v42 = {};
	for v43, v44 in pairs(u6.attachmentBaseSlots) do
		v42[v43] = v44;
	end;
	for v45, v46 in pairs(v1.getWeaponData(p13).weaponBodyCamoSlots or u6.weaponBaseSlots) do
		v42[v45] = v46;
	end;
	return v42;
end;
local u7 = v5:get("AttachmentDatabase");
local u8 = v4:get("AttachmentDatabase");
function v1.isTestAttachment(p14)
	if not u2 then
		return false;
	end;
	local v47 = u7:FindFirstChild(p14, true);
	return v47 and v47:IsA("Folder");
end;
function v1.getAttachments(p15)
	return v1.getWeaponData(p15).attachments;
end;
function v1.getAttachmentModule(p16)
	if u2 then
		local v48 = u7.Categories:FindFirstChild(p16, true);
		if v48 then
			local l__AttachmentData__49 = v48:FindFirstChild("AttachmentData");
			if l__AttachmentData__49 then
				return l__AttachmentData__49;
			end;
		end;
	end;
	local v50 = u8.Categories:FindFirstChild(p16, true);
	if not v50 then
		return;
	end;
	return v50:FindFirstChild("AttachmentData");
end;
local u9 = {};
local u10 = shared.require("LuaUtils");
function v1.getAttachmentData(p17, p18, p19)
	local v51 = u9[p17];
	if not v51 then
		local v52 = v1.getAttachmentModule(p17);
		if not v52 then
			return;
		end;
		v51 = require(v52);
		u9[p17] = v51;
	end;
	if not p18 or not p19 then
		if not v51 then
			warn("ContentDatabase: No attachmentData found for", p17, debug.traceback());
		end;
		return v51;
	end;
	local v53 = v1.getAttachments(p18);
	local v54 = u10.deepCopy(v51);
	if v53[p19] and v53[p19][p17] then
		for v55, v56 in v53[p19][p17], nil do
			v54[v55] = v56;
		end;
	end;
	return v54;
end;
function v1.getAttachmentDisplayName(p20)
	if not p20 then
		return "";
	end;
	local v57 = v1.getAttachmentModule(p20);
	if not v57 then
		return p20;
	end;
	return require(v57).displayname and p20;
end;
function v1.getAttachmentModel(p21)
	if u2 then
		local v58 = u7:FindFirstChild(p21, true);
		if v58 then
			if v58:IsA("Folder") then
				local v59 = v58:FindFirstChild("Models") and v58.Models:FindFirstChild("Main");
				if v59 then
					return v59;
				end;
			elseif v58:IsA("Model") then
				return v58;
			end;
		end;
	end;
	local v60 = u8:FindFirstChild(p21, true);
	if not v60 then
		warn("ContentDatabase: No attachmentFolder or shared model found for", p21);
		return;
	end;
	if not v60:IsA("Folder") then
		return v60;
	end;
	return v60:FindFirstChild("Models") and v60.Models:FindFirstChild("Main");
end;
local u11 = shared.require("SetFunctions");
function v1.getAttachmentSet(p22, p23)
	local v61 = {};
	local v62 = nil;
	local v63 = nil;
	while true do
		local v64, v65 = p22(v62, v63);
		if not v64 then
			break;
		end;
		local v66 = u2 and u7.Sets:FindFirstChild(v65, true) or u8.Sets:FindFirstChild(v65, true);
		if v66 and v66:IsA("ModuleScript") then
			table.insert(v61, require(v66));
		else
			warn("ContentDatabase: No setModule found for", v65);
		end;	
	end;
	local v67 = u11.new(v61, p23);
	return v67, v67.modify;
end;
local function u12(p24)
	if not p24 then
		warn("ContentDatabase: No attachmetName was passed");
		return;
	end;
	local v68 = u2 and u7.Categories:FindFirstChild(p24, true) or u8.Categories:FindFirstChild(p24, true);
	if not v68 or not v68:IsA("Folder") then
		warn("ContentDatabase: Did not return a folder for attachment", p24);
	end;
	return v68;
end;
function v1.getAttachmentCategory(p25)
	local v69 = u12(p25);
	if not v69 then
		warn("ContentDatabase: No attachmentFolder found for", p25);
		return;
	end;
	return v69.Parent.Name;
end;
local u13 = v3:get("MapDatabases");
function v1.getMapDatabase(p26)
	local v70 = u1["mapList" .. p26];
	if v70 then
		return v70;
	end;
	local v71 = u13:FindFirstChild(p26, true);
	if not v71 then
		warn("ContentDatabase: No mapDatabaseModule found for", p26);
		return;
	end;
	local l__Maps__72 = require(v71).Maps;
	u1["mapList" .. p26] = l__Maps__72;
	return l__Maps__72;
end;
function v1.getMapDatabases()
	local v73 = {};
	for v74, v75 in u13() do
		v73[v75.Name] = require(v75);
	end;
	return v73;
end;
local u14 = nil;
function v1.getCurrentMapDatabase()
	if u14 then
		return u14;
	end;
	local v76 = nil;
	for v77, v78 in v1.getMapDatabases(), nil do
		if v78.Default then
			if not v76 then
				v76 = v78.Maps;
			else
				error("Multiple default map databases are defined");
			end;
		elseif v78.PlaceId == game.PlaceId then
			u14 = v78.Maps;
		end;
	end;
	if not u14 then
		u14 = v76;
	end;
	return u14;
end;
function v1._init()
	if u2 then
		for v79, v80 in next, v1.getAllWeaponsList() do
			local v81 = v1.getWeaponData(v80);
			if v81.attachments then
				for v82, v83 in next, v81.attachments do
					for v84 in next, v83 do
						if not v1.getAttachmentData(v84, v80, v82) then
							warn("Missing attachment entry!", v80, v82, v84);
						end;
					end;
				end;
			end;
		end;
	end;
end;
return v1;

