
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PageLoadoutMenuInterface");
local v3 = shared.require("MenuLobbyInterface").getMenuLobby();
local l__CFrame__4 = v3.GunStage.Focus.CFrame;
local v5 = shared.require("spring").new(Vector3.zero);
v5.s = 16;
local u1 = nil;
local u2 = {};
function v1.isPreviewing()
	return u1 or next(u2);
end;
function v1.getPreviewSettings()
	return u1, u2;
end;
local u3 = shared.require("MenuWeaponDisplayEvents");
function v1.clearPreview()
	u1 = nil;
	u2 = {};
	u3.onPreviewChanged:fire(v1.isPreviewing());
end;
function v1.previewAttachment(p1, p2)
	if u2[p2] == p1 then
		u2[p2] = nil;
	else
		u2[p2] = p1;
	end;
	u3.onPreviewChanged:fire(v1.isPreviewing());
end;
function v1.previewWeapon(p3)
	u1 = p3;
	u2 = {};
	u3.onPreviewChanged:fire(v1.isPreviewing());
end;
local u4 = shared.require("ActiveLoadoutUtils");
local u5 = shared.require("PlayerDataStoreClient");
local u6 = shared.require("ContentDatabase");
function v1.getActiveWeaponDataToDisplay()
	local v6 = u4.getActiveLoadoutData(u5.getPlayerData())[v2.getActiveLoadoutSlot()];
	local v7, v8 = v1.getPreviewSettings();
	if v7 then
		local v9 = v7;
	else
		v9 = v6.Name;
	end;
	local v10 = {};
	if not v7 and v6.Attachments then
		for v11, v12 in next, v6.Attachments do
			v10[v11] = v12;
		end;
	end;
	for v13, v14 in next, v8 do
		v10[v13] = v14;
	end;
	local v15 = u6.getWeaponData(v9);
	if v15 then
		return v9, v15, v10;
	end;
	warn("PageLoadoutMenuDisplayWeaponStats: No gun data found for weapon", v9);
end;
local u7 = shared.require("DestructorGroup").new();
local u8 = shared.require("PlayerDataUtils");
local u9 = shared.require("ModifyData");
local u10 = shared.require("WeaponUtils");
local u11 = shared.require("PageLoadoutMenuDisplayWeaponCamo");
local u12 = v2.getPageFrame();
local u13 = l__CFrame__4;
local u14 = shared.require("CFrameLib");
local u15 = shared.require("MenuUpdater");
local u16 = false;
local u17 = shared.require("GuiInputInterface");
local u18 = nil;
local l__CurrentCamera__19 = workspace.CurrentCamera;
local u20 = os.clock();
local u21 = shared.require("CameraInterface");
function v1.updateWeaponModel()
	local v16 = u7:runAndReplace("weaponModel");
	local v17 = u5.getPlayerData();
	local v18 = u4.getActiveLoadoutData(v17)[v2.getActiveLoadoutSlot()];
	local v19, v20, v21 = v1.getActiveWeaponDataToDisplay();
	local v22 = u10.constructWeapon(v19, u9.getModifiedData(u6.getWeaponData(v19), v21), v21, not u1 and v18.Camo or {}, (u8.getWeaponAttData(v17, v19)));
	if v2.getCurrentSubPage() == "DisplayWeaponCamo" then
		local v23, v24 = u11.getActiveCamoSlot();
		if v24 then
			local l__next__25 = next;
			local v26, v27 = v22:GetDescendants();
			while true do
				local v28, v29 = l__next__25(v26, v27);
				if not v28 then
					break;
				end;
				v27 = v28;
				if v29:IsA("BasePart") and v29.Transparency ~= 1 and not v29:FindFirstChild(v24) then
					v29.Transparency = 0.9;
					local l__next__30 = next;
					local v31, v32 = v29:GetChildren();
					while true do
						local v33, v34 = l__next__30(v31, v32);
						if not v33 then
							break;
						end;
						v32 = v33;
						if v34:IsA("Texture") or v34:IsA("Decal") then
							v34.Transparency = 0.9;
						end;					
					end;
				end;			
			end;
		end;
	end;
	if v1.isPreviewing() then
		local v35 = u12.Templates.DisplayPreview:Clone();
		v35.Enabled = true;
		v35.Parent = v22.PrimaryPart;
	end;
	v22.Parent = v3;
	v22.PrimaryPart.Anchored = true;
	v16:add(v22);
	v22.PrimaryPart.CFrame = u13 * u14.fromAxisAngle(v5.p);
	v16:add(u15.addTask(function()
		if not u16 and v5.p.Magnitude < 1E-06 then
			return;
		end;
		v22.PrimaryPart.CFrame = u13 * u14.fromAxisAngle(v5.p);
	end, 10));
	local function u22(p4, p5, p6)
		local v36, v37, v38, v39, v40, v41, v42, v43, v44, v45, v46, v47 = p4:components();
		local v48 = math.clamp(math.atan2(v42, v43), p5, p6);
		local v49 = math.cos(v48);
		local v50 = math.sin(v48);
		local v51 = math.atan2(v41 - v45 * v49 + v46 * v50, v47 + v39 * v49 - v40 * v50);
		return CFrame.Angles(0, v51, v48), v51, v48;
	end;
	v16:add(u17.onDragged(u12, function(p7)
		u16 = true;
		local v52 = Vector2.new(p7:getInputPosition());
		if not u18 then
			u18 = v52;
		end;
		local v53 = v52 - u18;
		if v22 then
			local l__CFrame__54 = l__CurrentCamera__19.CFrame;
			local v55 = l__CFrame__54:inverse() * v22.PrimaryPart.CFrame;
			local v56 = (l__CFrame__54 - l__CFrame__54.p) * u14.fromAxisAngle(v53.y / 256, v53.x / 256, 0) * (v55 - v55.p) + l__CFrame__4.p;
			u13 = l__CFrame__4 * u22(l__CFrame__4:inverse() * v56, 0, 0);
			local v57 = u14.toAxisAngle(u13:inverse() * v56);
			v5.p = v57;
			v5.t = v57;
		end;
		u18 = v52;
		u20 = os.clock();
	end));
	v16:add(u17.onScrolled(u12, function(p8, p9)
		local v58, v59 = p8:getInputPosition();
		u21.getActiveCamera("MenuCamera"):zoom(0.010416666666666666 * -p9.y, Vector2.new(v58, v59));
	end));
	v16:add(u17.onDragEnded(u12, function()
		u16 = false;
		u18 = nil;
		v5.t = Vector3.zero;
	end));
	u17.setLayer(u12, -1);
	u17.setGroup(u12, "WeaponPageGroup");
end;
return v1;

