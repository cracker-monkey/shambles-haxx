
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("GameRoundInterface");
local v3 = shared.require("CharacterEvents");
local v4 = shared.require("PublicSettings");
local v5 = shared.require("InstanceType");
local v6 = shared.require("PlayerPolicy");
local v7 = shared.require("ScreenCull");
local v8 = shared.require("particle");
local v9 = shared.require("network");
local v10 = shared.require("vector");
local v11 = shared.require("sound");
local v12 = shared.require("trash");
local v13 = shared.require("PlayerSettingsEvents");
local v14 = shared.require("PlayerSettingsInterface");
local l__Effects__15 = game.ReplicatedStorage.Effects;
local l__Muzzle__16 = l__Effects__15.Muzzle;
local l__Ignore__17 = workspace.Ignore;
local v18 = v14.getValue("maxbloodparts");
local v19 = v14.getValue("maxbloodtime");
local u1 = 2 * math.pi;
local u2 = {};
local function u3(p1, p2, p3, p4)
	local v20 = {};
	local v21 = {};
	for v22 = 1, #p1 do
		local v23 = p1[v22];
		local l__unit__24 = p3:vectorToWorldSpace(v23 / p4).unit;
		v20[v22] = l__unit__24;
		v21[v22] = (p3 * (p2[v22] * v23 * p4)):Dot(l__unit__24);
	end;
	return v20, v21;
end;
local u4 = { Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 1, 0), Vector3.new(0, -1, 0), Vector3.new(0, 0, 1), Vector3.new(0, 0, -1) };
local u5 = { 0.5, 0.5, 0.5, 0.5, 0.5, 0.5 };
local function u6(p5, p6, p7)
	local v25 = nil;
	local v26 = (-1 / 0);
	for v27 = 1, #p5 do
		local v28 = p7:Dot(p5[v27]) - p6[v27];
		if v26 < v28 then
			v25 = v27;
			v26 = v28;
		end;
	end;
	if not v25 then
		return (1 / 0);
	end;
	local v29 = p5[v25];
	local v30 = p6[v25];
	local v31 = (1 / 0);
	for v32 = 1, #p5 do
		if v32 ~= v25 then
			local v33 = p5[v32];
			local v34 = v29:Dot(v33);
			local v35 = (p6[v32] - v30 * v34 + v34 * p7:Dot(v29) - p7:Dot(v33)) / (1 - v34 * v34) ^ 0.5;
			if v35 < v31 then
				v31 = v35;
			end;
		end;
	end;
	return v31;
end;
local u7 = {};
local u8 = 0;
local u9 = v18;
local u10 = v19;
function v1.setmaxbloodt(p8)
	u10 = p8;
end;
local u11 = 0;
local u12 = {};
local function u13(p9, p10, p11)
	local v36 = nil;
	table.sort(p10, p11);
	local v37 = {};
	local v38 = #p9;
	local v39 = #p10;
	local v40 = 1;
	local v41 = 1;
	v36 = 0;
	while v40 <= v38 and v41 <= v39 do
		v36 = v36 + 1;
		local v42 = p9[v40];
		local v43 = p10[v41];
		if p11(v42, v43) then
			v40 = v40 + 1;
			v37[v36] = v42;
		else
			v41 = v41 + 1;
			v37[v36] = v43;
		end;	
	end;
	for v44 = v40, v38 do
		v36 = v36 + 1;
		v37[v36] = p9[v44];
	end;
	for v45 = v41, v39 do
		v37[local v46 + 1] = p10[v45];
	end;
	return v37;
end;
local u14 = {};
local function u15(p12, p13)
	return p13.t0 < p12.t0;
end;
local function u16()
	if #u7 ~= 0 then
		return table.remove(u7);
	end;
	if not (u8 < u9) then
		return;
	end;
	u8 = u8 + 1;
	local v47 = Instance.new("Part");
	v47.Shape = "Cylinder";
	v47.CastShadow = false;
	v47.Anchored = true;
	v47.CanCollide = false;
	v47.CanTouch = false;
	v47.CanQuery = false;
	v47.BrickColor = BrickColor.new("Crimson");
	return v47;
end;
local l__Blood__17 = l__Ignore__17.Blood;
local u18 = 0;
local u19 = {};
local u20 = {};
local function u21(p14, p15)
	return p15.t1 < p14.t1;
end;
function v1.bloodstep()
	local v48 = os.clock();
	if u11 > 0 then
		u12 = u13(u12, u14, u15);
		u11 = 0;
		u14 = {};
	end;
	for v49 = #u12, 1, -1 do
		if u10 / 1000 < os.clock() - v48 then
			break;
		end;
		local v50 = u12[v49];
		if not (v50.t0 < v48) then
			break;
		end;
		u12[v49] = nil;
		local v51 = u16();
		if v51 then
			local v52 = v50.size;
			local l__part__53 = v50.part;
			local l__pos__54 = v50.pos;
			local v55 = u2[l__part__53];
			if v55 then
				local v56 = v55.meshn;
				local v57 = v55.meshl;
			else
				local l__CFrame__58 = l__part__53.CFrame;
				local l__Size__59 = l__part__53.Size;
				local v60, v61 = u3(u4, u5, l__part__53.CFrame, l__part__53.Size);
				u2[l__part__53] = {
					meshn = v60, 
					meshl = v61
				};
				v56 = v60;
				v57 = v61;
			end;
			local v62 = 2 * u6(v56, v57, l__pos__54);
			if v62 < v52 then
				v52 = v62;
			end;
			v51.Size = Vector3.new(0.05, v52, v52);
			v51.CFrame = CFrame.new(l__pos__54, l__pos__54 + v50.norm) * CFrame.Angles(0, u1 / 4, 0);
			v51.Parent = l__Blood__17;
			u18 = u18 + 1;
			u19[u18] = {
				t1 = v50.t1, 
				spart = v51
			};
		end;
	end;
	if u18 > 0 then
		u20 = u13(u20, u19, u21);
		u18 = 0;
		u19 = {};
	end;
	for v63 = #u20, 1, -1 do
		if u10 / 1000 < os.clock() - v48 then
			break;
		end;
		local v64 = u20[v63];
		if not (v64.t1 < v48) then
			break;
		end;
		u20[v63] = nil;
		local l__spart__65 = v64.spart;
		if l__spart__65.Parent then
			l__spart__65.Parent = nil;
			table.insert(u7, l__spart__65);
		end;
	end;
end;
local function u22(p16, p17, p18, p19, p20, p21, p22, p23)
	debug.profilebegin("blood initialization");
	local v66 = os.clock();
	local v67 = p20 * p19.magnitude;
	if u8 < u9 then
		for v68 = 1, p16 do
			local v69 = 1 - math.random();
			local v70 = math.random() * u1;
			local v71 = (-2 * math.log(v69)) ^ 0.5;
			local v72 = v71 * math.cos(v70);
			local v73 = v71 * math.sin(v70);
			local v74 = 1 - math.random();
			local v75 = math.random() * u1;
			local v76 = (-2 * math.log(v74)) ^ 0.5;
			local v77 = v76 * math.cos(v75);
			local v78 = v76 * math.sin(v75);
			local v79 = -math.log(1 - math.random());
			local v80 = p19 + Vector3.new(v67 * v72, v67 * v73, v67 * v77);
			local v81, v82, v83 = workspace:FindPartOnRayWithWhitelist(Ray.new(p18, p21 * v80.unit), v2.raycastWhiteList);
			if v81 and v81.Name ~= "Window" and v81.Transparency ~= 1 then
				u11 = u11 + 1;
				local v84 = v66 + v80:Dot(v82 - p18) / v80:Dot(v80);
				u14[u11] = {
					t0 = v84, 
					t1 = v84 + math.random() * (p23 - p22) + p22, 
					size = p17 * v79, 
					part = v81, 
					norm = v83, 
					pos = v82
				};
			end;
		end;
	end;
	debug.profileend();
end;
local u23 = {};
local function u24(p24, p25, p26, p27, p28)
	if not v6:isReady() then
		return;
	end;
	if v5.IsConsole() or not v6:isFeatureAvailable("Blood") then
		return;
	end;
	if not p26 or not p24 or not p27 then
		return;
	end;
	if p25 and v14.getValue("togglebloodsplatter") then
		u22((p26 and 20) / 2, 0.5, p24, p27, 0.125, 20, 4, 10);
	end;
	if v14.getValue("togglebloodparticle") and not p28 and v7.sphere(p24, 4) then
		if #u23 > 0 then
			local v85 = table.remove(u23);
			local v86 = v85.Blood;
		else
			v86 = l__Effects__15.Blood:Clone();
			v85 = Instance.new("Part");
			v85.CanCollide = false;
			v85.CanTouch = false;
			v85.CanQuery = false;
			v85.Transparency = 1;
			v86.Parent = v85;
		end;
		v85.Position = p24;
		v85.Parent = l__Blood__17;
		v86:emit(0.1 * v86.Rate);
		task.delay(v86.Lifetime.Max, function()
			v85.Parent = nil;
			table.insert(u23, v85);
		end);
	end;
end;
function v1.bloodhit(p29, p30, p31, p32, p33, p34)
	local v87 = p32 and 20;
	if v87 > 100 then
		v87 = 100;
	end;
	u24(p30, p31, v87, p33, p34);
end;
v13.onSettingChanged:connect(function(p35, p36)
	if p35 == "maxbloodparts" then
		u9 = p36;
		return;
	end;
	if p35 == "maxbloodtime" then
		u10 = p36;
	end;
end);
local u25 = {};
local l__Casings__26 = l__Effects__15.Casings;
local u27 = math.pi / 180;
local l__Misc__28 = l__Ignore__17.Misc;
function v1.ejectshell(p37, p38, p39, p40)
	if v14.getValue("togglefirstpersoncasings") then
		p40 = p40 or CFrame.new(0.2, 0, -0.6);
		p39 = p39 and "Shell";
		local v88 = u25[p39];
		if not v88 then
			v88 = u25.Shell;
			p39 = "Shell";
		end;
		if #v88 ~= 0 then
			local v89 = table.remove(v88);
		else
			v89 = l__Casings__26[p39]:Clone();
		end;
		v89.CFrame = (p38 * CFrame.Angles((90 + math.random(-5, 5)) * u27, math.random(-5, 5) * u27, math.random(-5, 5) * u27) * p40):ToWorldSpace((CFrame.Angles(0, 0, 3.141592653589793)));
		v89.Velocity = p38:vectorToWorldSpace(Vector3.new(30, 5, -15));
		v89.RotVelocity = p38:vectorToWorldSpace(Vector3.new(2, 60 + 60 * math.random(), 0));
		v89.Parent = l__Misc__28;
		task.delay(5, function()
			v89.Parent = nil;
			table.insert(v88, v89);
		end);
	end;
end;
local l__muzzleeffects__29 = l__Effects__15.muzzleeffects;
function v1.muzzleflash(p41, p42, p43)
	if not p42:FindFirstChild("Smoke") then
		for v90, v91 in l__muzzleeffects__29() do
			if v91:IsA("ParticleEmitter") then
				v91:Clone().Parent = p42;
			end;
		end;
	end;
	local l__Smoke__92 = p42:FindFirstChild("Smoke");
	if not p43 then
		for v93, v94 in p42() do
			if v94 ~= l__Smoke__92 and v94:IsA("ParticleEmitter") then
				v94:Emit(1);
			end;
		end;
	end;
	l__Smoke__92:Emit(1);
end;
local u30 = {};
local l__effectobjects__31 = l__Effects__15.effectobjects;
local u32 = {};
local l__Hole__33 = l__Effects__15.Hole;
local u34 = {
	[Enum.Material.Cobblestone] = { 8778790891, 8778790887, 8778790888, 8778790908 }, 
	[Enum.Material.Slate] = { 8778790891, 8778790887, 8778790888, 8778790908 }, 
	[Enum.Material.Wood] = { 8777829622, 8777829611, 8777829615, 8777829739, 8777829721 }, 
	[Enum.Material.WoodPlanks] = { 8777829622, 8777829611, 8777829615, 8777829739, 8777829721 }, 
	[Enum.Material.Brick] = { 185237818, 185237842, 185237826, 185237805 }, 
	[Enum.Material.Plastic] = { 8778524408, 8778524396, 8778524403 }, 
	[Enum.Material.SmoothPlastic] = { 8778524408, 8778524396, 8778524403 }, 
	[Enum.Material.Concrete] = { 8777991671, 8777991646, 8777991649, 8777991626 }, 
	[Enum.Material.Glass] = { 8778374084, 8778374102, 8778374139, 8778374202, 8778374198, 8778374236 }, 
	[Enum.Material.Glacier] = { 8778374084, 8778374102, 8778374139, 8778374202, 8778374198, 8778374236 }, 
	[Enum.Material.Ice] = { 8778374084, 8778374102, 8778374139, 8778374202, 8778374198, 8778374236 }, 
	[Enum.Material.Foil] = { 8778374084, 8778374102, 8778374139, 8778374202, 8778374198, 8778374236 }, 
	[Enum.Material.Sand] = { 8778680025, 8778680038, 8778680023 }, 
	[Enum.Material.Mud] = { 8778680025, 8778680038, 8778680023 }, 
	[Enum.Material.Snow] = { 8778680025, 8778680038, 8778680023 }, 
	[Enum.Material.Metal] = { 8805902692, 8805902667, 8805902703, 8805902697, 8805902704 }, 
	[Enum.Material.CorrodedMetal] = { 8805902692, 8805902667, 8805902703, 8805902697, 8805902704 }, 
	[Enum.Material.DiamondPlate] = { 8805902692, 8805902667, 8805902703, 8805902697, 8805902704 }, 
	[Enum.Material.Fabric] = { 8806557257, 8806557324, 8806557307 }
};
local l__CurrentCamera__35 = workspace.CurrentCamera;
local l__materialhitsound__36 = v11.materialhitsound;
local l__bulletAcceleration__37 = v4.bulletAcceleration;
local function u38(p44, p45, p46)
	local v95 = 0;
	if p44.Material == Enum.Material.Grass then
		local v96 = "ImpactGrass";
	else
		v96 = "ImpactDefault";
	end;
	local v97 = u30[v96];
	if not v97 then
		u30[v96] = {};
		v97 = u30[v96];
	end;
	if #v97 == 0 then
		local v98 = l__effectobjects__31[v96]:Clone();
	else
		v98 = table.remove(v97);
	end;
	v98.CFrame = CFrame.new(p45, p45 + 2 * p46 + v10.random(0.5));
	v98.Parent = l__Misc__28;
	local v99 = v98:GetChildren();
	for v100 = 1, #v99 do
		local v101 = v99[v100];
		if v101:IsA("ParticleEmitter") then
			local l__Max__102 = v101.Lifetime.Max;
			v101.Acceleration = Vector3.new(5 * (math.random() - 0.5), v101.Acceleration.Y, 5 * (math.random() - 0.5));
			v101.EmissionDirection = "Front";
			v101:Emit(0.1 * v101.Rate);
			if v95 < l__Max__102 then
				v95 = l__Max__102;
			end;
		end;
	end;
	task.delay(v95, function()
		v98.Parent = nil;
		table.insert(v97, v98);
	end);
end;
local function u39(p47, p48, p49, p50)
	if #u32 ~= 0 then
		local v103 = table.remove(u32);
	else
		v103 = l__Hole__33:Clone();
	end;
	v103.CFrame = CFrame.new(p48, p48 - p49) * CFrame.Angles(-90 * u27, math.random(0, 360) * u27, 0);
	if u34[p47.Material] then
		local v104 = u34[p47.Material];
	else
		v104 = u34[Enum.Material.Cobblestone];
	end;
	v103.Decal1.Texture = "rbxassetid://" .. v104[math.random(1, #v104)];
	v103.Parent = l__Misc__28;
	if p50 then
		local l__magnitude__105 = (p48 - l__CurrentCamera__35.CFrame.p).magnitude;
		if l__magnitude__105 < 20 then
			local v106 = l__materialhitsound__36[p47.Material];
			if v106 then
				v11.PlaySound(v106, nil, 2 / l__magnitude__105, 1, nil, nil, v103, 20, 6);
			end;
		end;
	end;
	task.delay(8, function()
		v103.Parent = nil;
		table.insert(u32, v103);
	end);
end;
function v1.bullethit(p51, p52, p53, p54, p55, p56, p57, p58, p59, p60)
	if p52.Transparency == 1 then
		return;
	end;
	local v107 = v7.sphere(p53, 4);
	if v107 then
		if v14.getValue("toggleparticlesparks") and p60 then
			local l__Material__108 = p52.Material;
			if l__Material__108 ~= Enum.Material.Sand and l__Material__108 ~= Enum.Material.Grass and l__Material__108 ~= Enum.Material.Wood then
				local u40 = nil;
				local v109 = 20 * math.random();
				local v110 = { workspace.Terrain, workspace.Ignore, l__CurrentCamera__35 };
				for v111 = 1, p60 * 2 + 1 do
					local v112 = -0.25 * math.log(1 - math.random());
					local v113 = {
						position = p53, 
						nopenetration = true, 
						velocity = (p57 - 1.2 * p54:Dot(p57) / p54:Dot(p54) * p54) * 0.1 + v10.random(50), 
						acceleration = l__bulletAcceleration__37, 
						cancollide = true, 
						size = 0.15, 
						brightness = v109, 
						color = Color3.new(1, 1, 0.8), 
						bloom = 0.005 * math.random(), 
						physicsignore = v110, 
						life = v112, 
						physicsonly = true, 
						ontouch = function(p61, p62, p63, p64)
							local l__velocity__114 = p61.velocity;
							local v115 = p64:Dot(l__velocity__114) * p64;
							local v116 = 0.6 * (l__velocity__114 - v115) - 0.3 * v115;
							p61.position = p63 + 0.1 * p64;
							p61.velocity = v116;
							if v116.magnitude < 2 then
								p61.stopmotion = true;
							end;
						end
					};
					u40 = v109;
					function v113.onstep(p65, p66)
						p65.brightness = u40 * (p65.life / v112);
						p65.size = 0.15 * (p65.life / v112);
					end;
					v8.new(v113);
				end;
				if p55 and p56 then
					for v117 = 1, p60 * 2 + 1 do
						local u41 = -0.25 * math.log(1 - math.random());
						v8.new({
							position = p55, 
							nopenetration = true, 
							velocity = (p57 - 1.2 * p56:Dot(p57) / p56:Dot(p56) * p56) * 0.1 + v10.random(50), 
							acceleration = l__bulletAcceleration__37, 
							cancollide = true, 
							size = 0.15, 
							brightness = u40, 
							physicsignore = v110, 
							color = Color3.new(1, 1, 0.8), 
							bloom = 0.005 * math.random(), 
							life = u41, 
							physicsonly = true, 
							ontouch = function(p67, p68, p69, p70)
								if not p67.stopmotion then
									local l__velocity__118 = p67.velocity;
									local v119 = p70:Dot(l__velocity__118) * p70;
									local v120 = 0.6 * (l__velocity__118 - v119) - 0.3 * v119;
									p67.position = p69 + 0.1 * p70;
									p67.velocity = v120;
									if v120.magnitude < 2 then
										p67.stopmotion = true;
									end;
								end;
							end, 
							onstep = function(p71, p72)
								p71.brightness = u40 * (p71.life / u41);
								p71.size = 0.15 * (p71.life / u41) * 1.2;
							end
						});
					end;
				end;
			end;
		end;
		if v14.getValue("togglerobloxparticles") and p58 then
			u38(p52, p53, p54);
			if p55 and p56 then
				u38(p52, p55, p56);
			end;
		end;
	end;
	if v14.getValue("togglebulletholes") and p59 and v107 and p52.Transparency == 0 and p52.CanCollide then
		u39(p52, p53, p54, true);
		if p55 and p56 then
			u39(p52, p55, p56);
		end;
	end;
	local v121 = p52:FindFirstChildWhichIsA("Light");
	if v121 then
		if v14.getValue("toggleparticlesparks") and p60 and v107 then
			local v122 = { p52, workspace.Terrain, workspace.Ignore, l__CurrentCamera__35 };
			for v123 = 1, 10 do
				local v124 = -2 * math.log(1 - math.random());
				local v125 = {
					position = p53, 
					nopenetration = true, 
					velocity = p54 * 30 + v10.random(15), 
					acceleration = Vector3.new(0, -30, 0), 
					cancollide = true, 
					size = 0.16, 
					brightness = 4 * math.random(), 
					color = Color3.new(1, 1, 0.8), 
					bloom = 0.005 * math.random(), 
					physicsignore = v122, 
					life = v124, 
					physicsonly = true, 
					ontouch = function(p73, p74, p75, p76)
						if not p73.stopmotion then
							local l__velocity__126 = p73.velocity;
							local v127 = p76:Dot(l__velocity__126) * p76;
							local v128 = 0.6 * (l__velocity__126 - v127) - 0.3 * v127;
							p73.position = p75 + 0.1 * p76;
							p73.velocity = v128;
							if v128.magnitude < 2 then
								p73.stopmotion = true;
							end;
						end;
					end
				};
				local u42 = 5 * math.random();
				function v125.onstep(p77, p78)
					p77.brightness = u42 * (p77.life / v124);
					p77.size = 0.16 * (p77.life / v124);
				end;
				v8.new(v125);
			end;
		end;
		v121:Destroy();
		p52.Material = Enum.Material.SmoothPlastic;
	end;
end;
local u43 = { "rbxassetid://627558532", "rbxassetid://627558611", "rbxassetid://627558676" };
function v1.breakwindow(p79, p80, p81, p82)
	if p80.Name ~= "Window" then
		return;
	end;
	if p81 then
		v9:send("breakwindow", p80, p81, p82);
	end;
	local l__Size__129 = p80.Size;
	local v130 = Instance.new("Part");
	v130.Transparency = 1;
	v130.CFrame = p80.CFrame;
	v130.Size = l__Size__129;
	v130.Anchored = true;
	v130.CanCollide = false;
	v130.Parent = l__Misc__28;
	p80:Destroy();
	local v131 = Instance.new("Sound");
	v131.SoundId = u43[math.random(1, 3)];
	v131.Volume = 0.75;
	v131.MaxDistance = 200;
	v131.Parent = v130;
	local v132 = l__Effects__15.WindowShatter:Clone();
	v132.Color = ColorSequence.new(p80.Color);
	v132.Transparency = NumberSequence.new(p80.Transparency);
	local v133 = l__Size__129.Magnitude / 15;
	v132.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, v133, v133 / 4), (NumberSequenceKeypoint.new(1, v133, v133 / 4)) });
	v132.Parent = v130;
	v132:Emit(l__Size__129.Magnitude * 2);
	if v131 then
		local v134 = v131.Ended:connect(function()
			v130:Destroy();
		end);
		v131:Play();
	end;
end;
v9:add("breakwindow", function(p83)
	v1:breakwindow(p83);
end);
function v1.reload(p84)
	local v135 = nil;
	local v136 = nil;
	while true do
		local v137, v138 = u30(v135, v136);
		if not v137 then
			break;
		end;
		for v139 = 1, #v138 do
			table.remove(v138):Destroy();
		end;	
	end;
	for v140 = 1, #u32 do
		table.remove(u32):Destroy();
	end;
	local v141 = nil;
	local v142 = nil;
	while true do
		local v143, v144 = u25(v141, v142);
		if not v143 then
			break;
		end;
		for v145 = 1, #v144 do
			table.remove(v144):Destroy();
		end;	
	end;
	for v146 = 1, #u23 do
		table.remove(u23):Destroy();
	end;
end;
function v1.cleanup()
	for v147 in u2, nil do
		if not v147.Parent then
			u2[v147] = nil;
			v147:Destroy();
		end;
	end;
	for v148, v149 in u7, nil do
		u7[v148] = nil;
		v149:Destroy();
	end;
	u8 = 0;
	for v150 = 1, #u20 do
		local v151 = u20[v150];
		if v151.spart then
			v151.spart:Destroy();
		end;
		u20[v150] = nil;
	end;
end;
local l__Lighting__152 = game:GetService("Lighting");
local l__MapLighting__153 = l__Lighting__152:WaitForChild("MapLighting");
local l__ShaderObjects__44 = l__MapLighting__153:WaitForChild("ShaderObjects");
local u45 = {};
function v1.setuplighting(p85, p86)
	if p86 then
		for v154, v155 in l__MapLighting__153() do
			if v155:IsA("ValueBase") then
				l__Lighting__152[v155.Name] = v155.Value;
			end;
		end;
		if v14.getValue("togglerobloxshaders") then
			for v156, v157 in l__ShaderObjects__44() do
				table.insert(u45, v157);
				v157.Parent = l__Lighting__152;
			end;
			return;
		end;
	else
		l__Lighting__152.Brightness = 1;
		l__Lighting__152.Ambient = Color3.new(0, 0, 0);
		l__Lighting__152.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5);
		l__Lighting__152.ColorShift_Bottom = Color3.new(0, 0, 0);
		l__Lighting__152.ColorShift_Top = Color3.new(0, 0, 0);
		l__Lighting__152.ExposureCompensation = 0.3;
		l__Lighting__152.EnvironmentDiffuseScale = 0;
		l__Lighting__152.EnvironmentSpecularScale = 0;
		l__Lighting__152.FogEnd = 10000000;
		l__Lighting__152.FogStart = 0;
		for v158 = 1, #u45 do
			local v159 = table.remove(u45);
			if v159.Parent then
				v159.Parent = l__ShaderObjects__44;
			end;
		end;
	end;
end;
function v1.enableshadows(p87, p88)
	l__Lighting__152.GlobalShadows = p88;
end;
function v1.simplify(p89)
	print("bruh1");
	local l__Map__160 = workspace:WaitForChild("Map");
	if l__Map__160 then
		local l__Map__161 = l__Map__160:FindFirstChild("Map");
		if l__Map__161 then
			print("bruh2");
			for v162, v163 in l__Map__161() do
				if v163:IsA("BasePart") then
					v163.Material = Enum.Material.SmoothPlastic;
				end;
			end;
		end;
	end;
end;
local u46 = {};
local u47 = {};
function v1.applyeffects(p90, p91, p92)
	if p91 then
		if p92 then
			for v164, v165 in p91.Lighting, nil do
				l__Lighting__152[v164] = v165;
			end;
			for v166, v167 in p91.PostEffects, nil do
				local v168 = Instance.new(v167.Type);
				if v168:IsA("PostEffect") then
					for v169, v170 in v167.Properties, nil do
						v168[v169] = v170;
					end;
					v168.Enabled = true;
					v168.Parent = l__Lighting__152;
					table.insert(u46, v168);
				end;
			end;
			local l__MapShaders__171 = p91.MapShaders;
			local v172 = nil;
			local v173 = nil;
			while true do
				local v174, v175 = l__MapShaders__171(v172, v173);
				if not v174 then
					break;
				end;
				for v176 = 1, #u45 do
					local v177 = u45[v176];
					if v177.ClassName == v174 then
						u47[v177] = v177.Enabled;
						v177.Enabled = v175;
					end;
				end;			
			end;
			return;
		else
			for v178 = 1, #u46 do
				table.remove(u46):Destroy();
			end;
			for v179, v180 in l__MapLighting__153() do
				if v180:IsA("ValueBase") then
					l__Lighting__152[v180.Name] = v180.Value;
				end;
			end;
			for v181, v182 in u47, nil do
				v181.Enabled = v182;
				u47[v181] = nil;
			end;
		end;
	end;
end;
u47 = l__Casings__26;
u46 = l__Casings__26.GetChildren;
for v183, v184 in u46(u47) do
	u25[v184.Name] = {};
end;
u47 = v1;
u46 = v1.enableshadows;
u46(u47, v14.getValue("toggleglobalshadows"));
u46 = v13.onSettingChanged;
u47 = u46;
u46 = u46.connect;
u46(u47, function(p93, p94)
	if p93 == "toggleglobalshadows" then
		v1:enableshadows(p94);
	end;
end);
u46 = v12.Reset;
u47 = u46;
u46 = u46.connect;
u46(u47, v1.cleanup);
return v1;

