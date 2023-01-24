
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("sound");
local v3 = shared.require("cframe");
local v4 = shared.require("vector");
local v5 = CFrame.new();
local l__inverse__6 = v5.inverse;
local l__toObjectSpace__7 = v5.toObjectSpace;
local l__toquaternion__8 = v3.toquaternion;
local l__Debris__9 = game:GetService("Debris");
local l__CFrame_new__1 = CFrame.new;
local u2 = {
	linear = {
		p0 = 0, 
		v0 = 1, 
		p1 = 1, 
		v1 = 1
	}, 
	smooth = {
		p0 = 0, 
		v0 = 0, 
		p1 = 1, 
		v1 = 0
	}, 
	accelerate = {
		p0 = 0, 
		v0 = 0, 
		p1 = 1, 
		v1 = 1
	}, 
	decelerate = {
		p0 = 0, 
		v0 = 1, 
		p1 = 1, 
		v1 = 0
	}, 
	bump = {
		p0 = 0, 
		v0 = 4, 
		p1 = 0, 
		v1 = -4
	}, 
	acceleratebump = {
		p0 = 0, 
		v0 = 0, 
		p1 = 0, 
		v1 = -6.75
	}, 
	deceleratebump = {
		p0 = 0, 
		v0 = 6.75, 
		p1 = 0, 
		v1 = 0
	}
};
local function u3(p1, p2, p3, p4, p5, p6)
	p6 = p6 or Vector3.zero;
	p1 = p1 * l__CFrame_new__1(p6);
	p2 = p2 * l__CFrame_new__1(p6);
	if type(p5) == "table" then
		local v10 = p5[1];
		local v11 = p5[2];
		local v12 = p5[3];
		local v13 = p5[4];
	else
		local v14 = u2[p5 and "smooth"];
		v10 = v14.p0;
		v11 = v14.v0;
		v12 = v14.p1;
		v13 = v14.v1;
	end;
	return function(p7)
		p7 = (p7 - p3) / p4;
		p7 = p7 < 1 and p7 or 1;
		local v15 = 1 - p7;
		return p1:Lerp(p2, v10 * v15 * v15 * v15 + (3 * v10 + v11) * p7 * v15 * v15 + (3 * v12 - v13) * p7 * p7 * v15 + v12 * p7 * p7 * p7) * l__CFrame_new__1(-p6), p7 == 1;
	end;
end;
local u4 = shared.require("tween");
local u5 = shared.require("effects");
function v1.player(p8, p9, p10, p11)
	local v16 = {};
	local v17 = {};
	for v18, v19 in p8, nil do
		if v19.part then
			v17[v18] = v19.part.CFrame;
			v16[v18] = v19.part.CFrame;
		end;
	end;
	local u6 = 0;
	local u7 = 1;
	local u8 = 0;
	local u9 = {};
	local l__timescale__10 = p9.timescale;
	local l__Misc__11 = workspace.Ignore.Misc;
	local l__LocalPlayer__12 = game:GetService("Players").LocalPlayer;
	local l__stdtimescale__13 = p9.stdtimescale;
	return function(p12, p13)
		u6 = p12;
		for v20 = u7, #p9 do
			local v21 = p9[v20];
			if not (u8 < p12) then
				break;
			end;
			for v22 = 1, #v21 do
				local v23 = v21[v22];
				local l__part__24 = v23.part;
				local v25 = p8[l__part__24];
				if not v25 then
					warn("Error in frame: " .. u7 .. ". " .. (l__part__24 and "unkown partname") .. " is not in modeldata for " .. (p10 and "unknown weapon") .. " " .. (p11 and "unknown sequence"));
				else
					if v23.c0 then
						u9[l__part__24] = nil;
						v25.weld.C0 = v23.c0 == "base" and v25.basec0 or v23.c0;
					end;
					if v23.c1 then
						u9[l__part__24] = u3(v25.weld.C0, v23.c1 == "base" and v25.basec0 or (v23.basemult and v25.basec0 * v23.c1 or v23.c1), u8, v23.t and v23.t * l__timescale__10 or v21.delay * l__timescale__10, v23.eq, v23.pivot);
					end;
					if v23.clone then
						if p8[v23.clone] then
							local l__clone__26 = v23.clone;
							if l__clone__26 == "dropmag" then
								p8[l__clone__26].weld:Destroy();
								p8[l__clone__26].part:Destroy();
								p8[l__clone__26] = nil;
								u9[l__clone__26] = nil;
							else
								error("Error in frame: " .. u7 .. ". Cannot clone " .. l__part__24 .. ". " .. v23.clone .. " already exists.");
							end;
						end;
						local v27 = v25.part:Clone();
						for v28, v29 in v27() do
							v29:Destroy();
						end;
						local v30 = v25.part:GetChildren();
						for v31 = 1, #v30 do
							local v32 = v30[v31];
							if v32:IsA("Texture") then
								local v33 = v32:Clone();
								v33.Transparency = p8.camodata[v25.part][v32].Transparency;
								v33.Parent = v27;
							elseif not (not v32:IsA("FileMesh")) or not (not v32:IsA("CylinderMesh")) or not (not v32:IsA("BlockMesh")) or v32:IsA("SpecialMesh") then
								v32:Clone().Parent = v27;
							end;
						end;
						local v34 = Instance.new("Motor6D");
						local v35 = v23.part0 and p8[v23.part0].part or v25.weld.Part0;
						v34.Part0 = v35;
						v34.Part1 = v27;
						v34.C0 = v35.CFrame:inverse() * v25.weld.Part0.CFrame * v25.weld.C0;
						v34.Parent = v27;
						v27.Parent = l__Misc__11;
						p8[v23.clone] = {
							part = v27, 
							weld = v34, 
							clone = true
						};
						v16[v23.clone] = v16[l__part__24];
						v17[v23.clone] = v17[l__part__24];
					end;
					if v23.transparency then
						v25.part.Transparency = v23.transparency;
						if p8.camodata and p8.camodata[v25.part] then
							local v36 = v25.part:GetChildren();
							for v37 = 1, #v36 do
								if v36[v37]:IsA("Texture") or v36[v37]:IsA("Decal") then
									v36[v37].Transparency = v23.transparency ~= 1 and p8.camodata[v25.part][v36[v37]].Transparency or 1;
								end;
							end;
						end;
					end;
					if v23.sound then
						local v38 = Instance.new("Sound");
						if v23.soundid then
							v38.SoundId = v23.soundid;
						end;
						if v23.v then
							v38.Volume = v23.v;
						end;
						if v23.p then
							v38.Pitch = v23.p;
						end;
						if v23.tp then
							v38.TimePosition = v23.tp;
						else
							v38.TimePosition = 0;
						end;
						if v23.head then
							v38.Parent = l__LocalPlayer__12.Character.Head;
						else
							v38.Parent = v25.part;
						end;
						v38:Play();
						if v23.d then
							delay(v23.d, function()
								v38:Destroy();
							end);
						else
							v38.Ended:Connect(function()
								v38:Destroy();
							end);
						end;
					end;
					if v23.drop then
						if not v25.clone then
							error("Error in frame: " .. u7 .. ". Cannot drop " .. l__part__24 .. ". Part is not a clone");
						end;
						local v39 = v17[l__part__24];
						local v40 = v16[l__part__24];
						local l__part__41 = v25.part;
						u4.freebody(l__part__41, "CFrame", l__timescale__10 / l__stdtimescale__13, l__part__41.CFrame, (v40.p - v39.p) / p13, v3.toaxisangle(v40 * v39:inverse()) / p13, Vector3.new(0, -196.2 / l__stdtimescale__13 * l__stdtimescale__13 * (l__timescale__10 * l__timescale__10), 0));
						v25.weld:Destroy();
						p8[l__part__24] = nil;
						u9[l__part__24] = nil;
					end;
					if v23.delete then
						v25.weld:Destroy();
						v25.part:Destroy();
						p8[l__part__24] = nil;
						u9[l__part__24] = nil;
					end;
					if v23.eject then
						u5:ejectshell(v25.part.CFrame, p8.gunvars.ammotype, v23.offset);
					end;
				end;
			end;
			u8 = u8 + v21.delay * l__timescale__10;
			u7 = u7 + 1;
		end;
		for v42, v43 in u9, nil do
			local v44, v45, v46 = v43(p12);
			if p8[v42] then
				p8[v42].weld.C0 = v44;
				if v45 then
					u9[v42] = nil;
				end;
			else
				u9[v42] = nil;
				warn(p8, v42, "not found");
			end;
		end;
		for v47, v48 in p8, nil do
			if v48.part then
				v17[v47] = v16[v47];
				v16[v47] = v48.part.CFrame;
			end;
		end;
		if u8 < p12 then
			for v49, v50 in p8, nil do
				if v50.clone then
					v50.weld:Destroy();
					v50.part:Destroy();
					p8[v49] = nil;
				end;
			end;
		end;
		return u8 < p12;
	end;
end;
function v1.reset(p14, p15, p16, p17)
	if not p17 and p14.gunvars then
		p17 = not p14.gunvars.boltlock;
	end;
	local v51 = {};
	for v52, v53 in p14, nil do
		if v53.clone then
			p14[v52] = nil;
			v53.weld:Destroy();
			v53.part:Destroy();
		else
			if not p16 and v53.part then
				v53.part.Transparency = v53.basetransparency;
				if p14.camodata and p14.camodata[v53.part] then
					local v54 = v53.part:GetChildren();
					for v55 = 1, #v54 do
						if v54[v55]:IsA("Texture") or v54[v55]:IsA("Decal") then
							v54[v55].Transparency = p14.camodata[v53.part][v54[v55]].Transparency;
						end;
					end;
				end;
			end;
			if v53.weld then
				local v56 = v52 == "Bolt";
				if not v56 or v56 and p17 then
					v51[v52] = u3(v53.weld.C0, v53.basec0, 0, p15 and 1);
				end;
			end;
		end;
	end;
	return function(p18)
		local v57 = nil;
		local v58 = nil;
		while true do
			local v59, v60 = v51(v57, v58);
			if not v59 then
				break;
			end;
			local v61 = v59 == "Bolt";
			if not v61 or v61 and p17 then
				local v62, v63 = v60(p18);
				p14[v59].weld.C0 = v62;
			end;		
		end;
		return p15 < p18;
	end;
end;
return v1;

