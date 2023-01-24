
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("SkinCaseUtils");
function v1.textureModel(p1, p2)
	if not p2 then
		return;
	end;
	for v2, v3 in p2, nil do
		if v3.Name and v3.Name ~= "" then
			for v4, v5 in p1() do
				if v5:IsA("BasePart") and v5:FindFirstChild(v2) then
					for v6, v7 in v5() do
						if v7:IsA("Texture") then
							v7:Destroy();
						end;
					end;
					local v8 = u1.getSkinDataset(v3.Name);
					local v9 = v8.TexturePreset or {};
					local v10 = v3.TextureProperties or {};
					if v5:IsA("MeshPart") or v5:IsA("UnionOperation") then
						local v11 = 5;
					else
						v11 = 0;
					end;
					for v12 = 0, v11 do
						local v13 = Instance.new("Texture");
						v13.Name = v2;
						v13.Texture = "rbxassetid://" .. (v8.TextureId and "");
						v13.StudsPerTileU = v10.StudsPerTileU or (v9.StudsPerTileU or 1);
						v13.StudsPerTileV = v10.StudsPerTileV or (v9.StudsPerTileU or 1);
						v13.OffsetStudsU = v10.OffsetStudsU or (v9.OffsetStudsU or 0);
						v13.OffsetStudsV = v10.OffsetStudsV or (v9.OffsetStudsV or 0);
						if v5.Transparency == 1 then
							local v14 = 1;
						else
							v14 = v10.Transparency or (v9.Transparency or 0);
						end;
						v13.Transparency = v14;
						local v15 = v10.Color or v9.Color;
						if v15 then
							v13.Color3 = Color3.new(v15.r / 255, v15.g / 255, v15.b / 255);
						end;
						v13.Face = v12;
						v13.Parent = v5;
					end;
					local l__BrickPreset__16 = v8.BrickPreset;
					local v17 = v3.BrickProperties or {};
					if not v17.DefaultColor and not l__BrickPreset__16.DefaultColor then
						if v5:IsA("UnionOperation") then
							v5.UsePartColor = true;
						end;
						local v18 = v17.Color or l__BrickPreset__16.Color;
						local v19 = v17.BrickColor or l__BrickPreset__16.BrickColor;
						if v18 then
							v5.Color = Color3.new(v18.r / 255, v18.g / 255, v18.b / 255);
						elseif v19 then
							v5.BrickColor = BrickColor.new(v19);
						end;
					end;
					local v20 = v17.Material or l__BrickPreset__16.Material;
					if v20 then
						v5.Material = v20;
					end;
					local v21 = v17.Reflectance or l__BrickPreset__16.Reflectance;
					if v21 then
						v5.Reflectance = v21;
					end;
				end;
			end;
		end;
	end;
end;
local u2 = shared.require("ContentDatabase");
local function u3(p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
	local v22 = p9.altmodel and u2.getAttachmentModel(p9.altmodel) or u2.getAttachmentModel(p6);
	local v23 = nil;
	if v22 then
		for v24 = 0, p9.copy and 0 do
			local v25 = v22:Clone();
			local v26 = {};
			local l__Node__27 = v25.Node;
			local l__CFrame__28 = l__Node__27.CFrame;
			local v29 = v25:GetChildren();
			for v30 = 1, #v29 do
				local v31 = v29[v30];
				if v31:IsA("BasePart") then
					if p4.weldexception and p4.weldexception[v31.Name] then
						v26[v31] = p3[p4.weldexception[v31.Name]].CFrame:ToObjectSpace(v31.CFrame);
					else
						v26[v31] = l__CFrame__28:ToObjectSpace(v31.CFrame);
					end;
					v31.Anchored = false;
					v31.Massless = true;
					v31.CanTouch = false;
					v31.CanCollide = false;
					v31.CastShadow = false;
				end;
			end;
			l__Node__27.CFrame = v24 == 0 and p7.CFrame or p12[p9.copynodes[v24]].CFrame;
			if p5 == "Optics" then
				local v32 = p3:GetChildren();
				for v33 = 1, #v32 do
					if v32[v33].Name == "Iron" or v32[v33].Name == "IronGlow" or v32[v33].Name == "SightMark" and not v32[v33]:FindFirstChild("Stay") then
						v32[v33]:Destroy();
					end;
				end;
			elseif p5 == "Underbarrel" then
				local v34 = p3:GetChildren();
				for v35 = 1, #v34 do
					if v34[v35].Name == "Grip" then
						v23 = v34[v35]:FindFirstChild("Slot1") or v34[v35]:FindFirstChild("Slot2");
						v34[v35]:Destroy();
					end;
				end;
			elseif p5 == "Barrel" then
				local v36 = p3:GetChildren();
				for v37 = 1, #v36 do
					if v36[v37].Name == "Barrel" then
						v23 = v36[v37]:FindFirstChild("Slot1") or v36[v37]:FindFirstChild("Slot2");
						v36[v37]:Destroy();
					end;
				end;
			end;
			if p9.replacemag then
				local v38 = p3:GetChildren();
				for v39 = 1, #v38 do
					if v24 == 0 and v38[v39].Name == "Mag" or v24 > 0 and v38[v39].Name == "Mag" .. v24 + 1 then
						v38[v39]:Destroy();
					end;
				end;
			end;
			if p9.replacepart then
				local v40 = p3:GetChildren();
				for v41 = 1, #v40 do
					if v40[v41].Name == p9.replacepart then
						v40[v41]:Destroy();
					end;
				end;
			end;
			if p10 and p10[p6] and p10[p6].settings then
				for v42, v43 in p10[p6].settings, nil do
					if v42 == "sightcolor" then
						local l__SightMark__44 = v25:FindFirstChild("SightMark");
						if l__SightMark__44 and l__SightMark__44:FindFirstChild("SurfaceGui") then
							local l__SurfaceGui__45 = l__SightMark__44.SurfaceGui;
							if l__SurfaceGui__45:FindFirstChild("Border") and l__SurfaceGui__45.Border:FindFirstChild("Scope") then
								l__SurfaceGui__45.Border.Scope.ImageColor3 = Color3.new(v43.r / 255, v43.g / 255, v43.b / 255);
							end;
						end;
					end;
				end;
			end;
			for v46 = 1, #v29 do
				local v47 = v29[v46];
				if v47:IsA("BasePart") then
					if v23 and v47:IsA("UnionOperation") then
						v23:Clone().Parent = v47;
					end;
					if p9.replacemag and v47.Name == "AttMag" then
						if v24 == 0 then
							local v48 = "Mag";
						else
							v48 = false;
							if v24 > 0 then
								v48 = "Mag" .. v24 + 1;
							end;
						end;
						v47.Name = v48;
					end;
					if p9.replacepart and v47.Name == "Part" then
						v47.Name = p9.replacepart;
					end;
					if p4.weldexception and p4.weldexception[v47.Name] then
						local v49 = p3[p4.weldexception[v47.Name]];
					else
						v49 = p8;
					end;
					if v47 ~= l__Node__27 then
						local v50 = v49.CFrame:ToObjectSpace(l__Node__27.CFrame);
						local v51 = Instance.new("Weld");
						v51.Part0 = v49;
						v51.Part1 = v47;
						v51.C0 = v50 * v26[v47];
						v51.Parent = v49;
						v47.CFrame = v49.CFrame * v51.C0;
						p11[v47.Name] = {
							part = v47, 
							weld = v51, 
							basec0 = v50 * v26[v47], 
							basetransparency = v47.Transparency
						};
					end;
					v47.Anchored = false;
					v47.Massless = true;
					v47.CanTouch = false;
					v47.CanCollide = false;
					v47.CastShadow = false;
					v47.Parent = p3;
				end;
			end;
			l__Node__27:Destroy();
			v25:Destroy();
		end;
	end;
	return v23;
end;
function v1.constructWeapon(p13, p14, p15, p16, p17)
	local v52 = {};
	local v53 = u2.getWeaponModel(p13):Clone();
	if not v53 then
		warn("WeaponUtils: No weapon model found for", p13);
		return;
	end;
	local l__MenuNodes__54 = v53:FindFirstChild("MenuNodes");
	if not l__MenuNodes__54 then
		warn("WeaponUtils: No MenuNodes found for weapon model", v53);
		return;
	end;
	if not p14.mainpart then
		warn("WeaponUtils: No main part found for weapon", p14, p14.mainpart);
		return;
	end;
	local v55 = v53[p14.mainpart];
	if not v55 then
		warn("WeaponUtils: No main part found for weapon model", v53, p14.mainpart);
		return;
	end;
	local l__CFrame__56 = v55.CFrame;
	for v57, v58 in v53() do
		if v58:IsA("BasePart") then
			local l__Name__59 = v58.Name;
			if p14.removeparts and p14.removeparts[l__Name__59] then
				v58:Destroy();
			else
				if p14.transparencymod and p14.transparencymod[l__Name__59] then
					v58.Transparency = p14.transparencymod[l__Name__59];
				end;
				local l__weldexception__60 = p14.weldexception;
				if l__weldexception__60 and l__weldexception__60[l__Name__59] and v53:FindFirstChild(l__weldexception__60[l__Name__59]) then
					local v61 = v53[l__weldexception__60[l__Name__59]];
				else
					v61 = v55;
				end;
				local v62 = v61.CFrame:ToObjectSpace(v58.CFrame);
				local v63 = Instance.new("Weld");
				v63.Part0 = v61;
				v63.Part1 = v58;
				v63.C0 = v62;
				v63.Parent = v58;
				v58.CFrame = l__CFrame__56 * v62;
				v52[l__Name__59] = {
					part = v58, 
					weld = v63, 
					basec0 = v62, 
					basetransparency = v58.Transparency
				};
				v58.Anchored = false;
				v58.Massless = true;
				v58.CanTouch = false;
				v58.CanCollide = false;
				v58.CastShadow = false;
			end;
		end;
	end;
	local v64 = l__MenuNodes__54:GetChildren();
	for v65 = 1, #v64 do
		local v66 = v64[v65];
		local v67 = Instance.new("Weld");
		v67.Part0 = v55;
		v67.Part1 = v66;
		v67.C0 = l__CFrame__56:ToObjectSpace(v66.CFrame);
		v67.Parent = v55;
		v66.Anchored = false;
		v66.Massless = true;
		v66.CanTouch = false;
		v66.CanCollide = false;
		v66.CastShadow = false;
	end;
	if p15 then
		for v68, v69 in p15, nil do
			if v68 ~= "Name" and v69 and v69 ~= "" then
				local v70 = p14.attachments and u2.getAttachmentData(v69, p13, v68) or {};
				local v71 = v70.sidemount and u2.getAttachmentModel(v70.sidemount):Clone();
				local v72 = v70.mountweldpart and v53[v70.mountweldpart] or v55;
				local v73 = v70.node and l__MenuNodes__54[v70.node];
				local v74 = {};
				if v71 then
					local l__Node__75 = v71.Node;
					if v70.mountnode then
						local v76 = l__MenuNodes__54[v70.mountnode];
						if not v76 then
							if v68 == "Underbarrel" then
								v76 = l__MenuNodes__54.UnderMountNode;
								if not v76 then
									v76 = false;
									if v68 == "Optics" then
										v76 = l__MenuNodes__54.MountNode;
									end;
								end;
							else
								v76 = false;
								if v68 == "Optics" then
									v76 = l__MenuNodes__54.MountNode;
								end;
							end;
						end;
					elseif v68 == "Underbarrel" then
						v76 = l__MenuNodes__54.UnderMountNode;
						if not v76 then
							v76 = false;
							if v68 == "Optics" then
								v76 = l__MenuNodes__54.MountNode;
							end;
						end;
					else
						v76 = false;
						if v68 == "Optics" then
							v76 = l__MenuNodes__54.MountNode;
						end;
					end;
					local v77 = {};
					local v78 = v71:GetDescendants();
					local l__CFrame__79 = l__Node__75.CFrame;
					for v80 = 1, #v78 do
						if v78[v80]:IsA("BasePart") then
							v77[v80] = l__CFrame__79:ToObjectSpace(v78[v80].CFrame);
						end;
					end;
					l__Node__75.CFrame = v76.CFrame;
					for v81 = 1, #v78 do
						local v82 = v78[v81];
						if v82:IsA("BasePart") then
							local v83 = v72.CFrame:ToObjectSpace(l__Node__75.CFrame);
							local v84 = v55.CFrame:ToObjectSpace(v72.CFrame);
							if v82 ~= l__Node__75 then
								local v85 = Instance.new("Weld");
								if v70.weldtobase then
									v85.Part0 = v55;
									v85.Part1 = v82;
									v85.C0 = v84 * v83 * v77[v81];
									v82.CFrame = l__Node__75.CFrame * v77[v81];
									local v86 = l__CFrame__56:ToObjectSpace(v82.CFrame);
								else
									v85.Part0 = v72;
									v85.Part1 = v82;
									v85.C0 = v83 * v77[v81];
									v82.CFrame = l__Node__75.CFrame * v77[v81];
									v86 = v72.CFrame:ToObjectSpace(v82.CFrame);
								end;
								v85.Parent = v55;
								v52[v82.Name] = {
									part = v82, 
									weld = v85, 
									basec0 = v86, 
									basetransparency = v82.Transparency
								};
							end;
							v82.Anchored = false;
							v82.Massless = true;
							v82.CanTouch = false;
							v82.CanCollide = false;
							v82.CastShadow = false;
							v82.Parent = v53;
							v74[v82.Name] = v82;
							if v82.Name == v68 .. "Node" and not v73 then
								v73 = v82;
							elseif v82.Name == v70.nodeside then
								v73 = v82;
							elseif v82.Name == "SightMark" then
								local v87 = Instance.new("Model");
								v87.Name = "Stay";
								v87.Parent = v82;
							end;
						end;
					end;
					l__Node__75.Parent = l__MenuNodes__54;
					v71:Destroy();
				else
					local v88 = v70.node and l__MenuNodes__54[v70.node] or l__MenuNodes__54[v68 .. "Node"];
				end;
				if v70.auxmodels then
					local v89 = {};
					local l__auxmodels__90 = v70.auxmodels;
					local v91 = nil;
					local v92 = nil;
					while true do
						local v93, v94 = l__auxmodels__90(v91, v92);
						if not v93 then
							break;
						end;
						local v95 = v94.Name or v69 .. " " .. v94.PostName;
						local v96 = u2.getAttachmentModel(v95):Clone();
						local l__Node__97 = v96.Node;
						v89[v95] = {};
						if v94.sidemount and v74[v94.Node] then
							local v98 = v74[v94.Node];
						elseif v94.auxmount and v89[v94.auxmount] and v89[v94.auxmount][v94.Node] then
							v98 = v89[v94.auxmount][v94.Node];
						else
							v98 = l__MenuNodes__54[v94.Node];
						end;
						if v94.mainnode then
							v88 = v96[v94.mainnode];
						end;
						local v99 = {};
						local v100 = v96:GetChildren();
						local l__CFrame__101 = l__Node__97.CFrame;
						for v102 = 1, #v100 do
							if v100[v102]:IsA("BasePart") then
								v99[v102] = l__CFrame__101:ToObjectSpace(v100[v102].CFrame);
							end;
						end;
						l__Node__97.CFrame = v98.CFrame;
						for v103 = 1, #v100 do
							local v104 = v100[v103];
							if v104:IsA("BasePart") then
								local v105 = v72.CFrame:ToObjectSpace(l__Node__97.CFrame);
								local v106 = v55.CFrame:ToObjectSpace(v72.CFrame);
								if v104 ~= l__Node__97 then
									local v107 = Instance.new("Weld");
									if v94.weldtobase then
										v107.Part0 = v55;
										v107.Part1 = v104;
										v107.C0 = v106 * v105 * v99[v103];
										v104.CFrame = l__Node__97.CFrame * v99[v103];
										local v108 = l__CFrame__56:ToObjectSpace(v104.CFrame);
									else
										v107.Part0 = v72;
										v107.Part1 = v104;
										v107.C0 = v105 * v99[v103];
										v104.CFrame = l__Node__97.CFrame * v99[v103];
										v108 = v72.CFrame:ToObjectSpace(v104.CFrame);
									end;
									v107.Parent = v104;
									v52[v104.Name] = {
										part = v104, 
										weld = v107, 
										basec0 = v108, 
										basetransparency = v104.Transparency
									};
								end;
								v104.Anchored = false;
								v104.Massless = true;
								v104.CanTouch = false;
								v104.CanCollide = false;
								v104.CastShadow = false;
								v104.Parent = v53;
								v89[v95][v104.Name] = v104;
								if v104.Name == v93 .. "Node" and not v88 then
									v88 = v104;
								elseif v104.Name == "SightMark" then
									local v109 = Instance.new("Model");
									v109.Name = "Stay";
									v109.Parent = v104;
								end;
							end;
						end;
						v96:Destroy();
						l__Node__97:Destroy();					
					end;
				end;
				u3(v53, p14, v68, v69, v88, v70.weldpart and v53[v70.weldpart] or v55, v70, p17, v52, l__MenuNodes__54);
			end;
		end;
	end;
	v1.textureModel(v53, p16);
	v53.PrimaryPart = l__MenuNodes__54.MenuNode;
	for v110, v111 in v53() do
		if v111:IsA("BasePart") and string.match(v111.Name, "Node") and v111.Transparency == 1 then
			v111:Destroy();
		end;
	end;
	if p14 then
		v52.gunvars = {
			ammotype = p14.casetype or p14.ammotype, 
			boltlock = p14.boltlock
		};
	end;
	return v53, v52;
end;
return v1;

