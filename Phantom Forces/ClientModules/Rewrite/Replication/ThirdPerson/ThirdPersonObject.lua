
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("PlayerSettingsInterface");
local v3 = shared.require("ContentDatabase");
local v4 = shared.require("WeaponUtils");
local v5 = shared.require("Destructor");
local v6 = shared.require("ScreenCull");
local v7 = shared.require("TeamConfig");
local v8 = shared.require("Sequencer");
local v9 = shared.require("GameClock");
local v10 = shared.require("effects");
local v11 = shared.require("spring");
local v12 = shared.require("cframe");
local v13 = shared.require("vector");
local v14 = shared.require("sound");
local l__LocalPlayer__15 = game:GetService("Players").LocalPlayer;
local l__Bodies__16 = game.ReplicatedStorage:WaitForChild("Character"):WaitForChild("Bodies");
local l__Players__17 = workspace:WaitForChild("Players");
local l__Ignore__18 = workspace:WaitForChild("Ignore");
local l__Map__19 = workspace:WaitForChild("Map");
local v20 = 2 * math.pi;
local v21 = v12.interpolator(CFrame.new(0, -0.125, 0), CFrame.new(0, -1, 0) * CFrame.Angles(-v20 / 24, 0, 0));
local v22 = v12.interpolator(CFrame.new(0, -1, 0) * CFrame.Angles(-v20 / 24, 0, 0), CFrame.new(0, -2, 0.5) * CFrame.Angles(-v20 / 4, 0, 0));
local v23 = CFrame.new(0.5, 0.5, 0, 0.918751657, -0.309533417, -0.245118901, 0.369528353, 0.455418497, 0.809963167, -0.139079139, -0.834734678, 0.532798767);
local v24 = CFrame.new(-0.5, 0.5, 0, 0.918751657, 0.309533417, 0.245118901, -0.369528353, 0.455418497, 0.809963167, 0.139079139, -0.834734678, 0.532798767);
local v25 = CFrame.new(0, 0, -0.5, 1, 0, 0, 0, 0, -1, 0, 1, 0);
local v26 = Vector3.new(0, 1, 0);
local v27 = Vector3.new(0, -1.5, 0);
local v28 = Vector3.new(0, 0, -1);
local v29 = RaycastParams.new();
v29.FilterType = Enum.RaycastFilterType.Whitelist;
v29.IgnoreWater = true;
v29.FilterDescendantsInstances = { workspace.Map };
local u1 = {};
shared.require("trash").Reset:connect(function()
	for v30 = 1, #u1 do
		u1[v30]:Destroy();
		u1[v30] = nil;
	end;
end);
function v1.new(p1, p2, p3)
	local v31 = setmetatable({}, v1);
	v31._destructor = v5.new();
	v31._replicationObject = p3;
	v31._player = p1;
	v31._stancespring = v11.new(0);
	v31._stancespring.s = 4;
	v31._stancespring.d = 0.8;
	v31._speedspring = v11.new(0);
	v31._speedspring.s = 8;
	v31._sprintspring = v11.new(1);
	v31._sprintspring.s = 8;
	v31._character = l__Bodies__16:WaitForChild((v7.getTeamName(p1.TeamColor))):Clone();
	v31._character.Name = "Player";
	v31._character.Torso.Anchored = true;
	v31._torso = v31._character.Torso;
	v31._head = v31._character.Head;
	v31._neck = v31._torso.Neck;
	v31._lsh = Instance.new("Motor6D");
	v31._rsh = Instance.new("Motor6D");
	v31._lhip = Instance.new("Motor6D");
	v31._rhip = Instance.new("Motor6D");
	v31._lsh.Part0 = v31._torso;
	v31._rsh.Part0 = v31._torso;
	v31._lhip.Part0 = v31._torso;
	v31._rhip.Part0 = v31._torso;
	v31._lsh.Part1 = v31._character["Left Arm"];
	v31._rsh.Part1 = v31._character["Right Arm"];
	v31._lhip.Part1 = v31._character["Left Leg"];
	v31._rhip.Part1 = v31._character["Right Leg"];
	v31._lsh.Parent = v31._torso;
	v31._rsh.Parent = v31._torso;
	v31._lhip.Parent = v31._torso;
	v31._rhip.Parent = v31._torso;
	v31._mainweld = Instance.new("Motor6D");
	v31._mainweld.Part0 = v31._torso;
	v31._mainweld.Parent = v31._torso;
	v31._muzzlelight = game.ReplicatedStorage.Effects.MuzzleLight:Clone();
	v31._muzzlelight.Parent = v31._torso;
	local l__Cosmetics__32 = v31._character:FindFirstChild("Cosmetics");
	if l__Cosmetics__32 then
		for v33, v34 in l__Cosmetics__32() do
			v34.Anchored = false;
			v34.CastShadow = false;
			v34.CanCollide = false;
			v34.CanTouch = false;
			v34.CanQuery = false;
			v34.CollisionGroupId = 1;
			v34.Massless = true;
			local v35 = v31._character:FindFirstChild(v34.Name);
			if v35 then
				local v36 = Instance.new("Weld");
				v36.Part0 = v35;
				v36.Part1 = v34;
				v36.C0 = v35.CFrame:inverse() * v34.CFrame;
				v36.Parent = v34;
			else
				warn(string.format("%s is not a valid part of character", v34.Name));
				v34:Destroy();
			end;
		end;
	end;
	v31._characterHash = {
		torso = v31._character.Torso, 
		head = v31._character.Head, 
		lleg = v31._character["Left Leg"], 
		rleg = v31._character["Right Leg"], 
		larm = v31._character["Left Arm"], 
		rarm = v31._character["Right Arm"]
	};
	v31._rfoot = {
		center = CFrame.new(), 
		pos = Vector3.zero, 
		sdown = CFrame.new(0.5, -3, 0), 
		pdown = CFrame.new(0.5, -2.75, 0), 
		weld = v31._rhip, 
		hipcf = CFrame.new(0.5, -0.5, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0), 
		legcf = v25, 
		angm = 1, 
		torsoswing = 0.1
	};
	v31._lfoot = {
		makesound = true, 
		center = CFrame.new(), 
		pos = Vector3.zero, 
		sdown = CFrame.new(-0.5, -3, 0), 
		pdown = CFrame.new(-0.5, -2.75, 0), 
		weld = v31._lhip, 
		hipcf = CFrame.new(-0.5, -0.5, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0), 
		legcf = v25, 
		angm = -1, 
		torsoswing = -0.1
	};
	v31._baseangle = 0;
	v31._maxdangle = 0.5;
	v31._stepradius = 1;
	v31._steplist = {};
	v31._soundid = nil;
	v31._muzzlepart = nil;
	v31._weapon = nil;
	v31._weaponname = nil;
	v31._weapontype = nil;
	v31._weapondualhand = nil;
	v31._weaponheadaimangle = 0;
	v31._weapontranskickmax = Vector3.zero;
	v31._weapontranskickmin = Vector3.zero;
	v31._weaponrotkickmax = Vector3.zero;
	v31._weaponrotkickmin = Vector3.zero;
	v31._weapontransoffset = CFrame.new();
	v31._weaponrotoffset = CFrame.new();
	v31._weaponsprintcf = CFrame.new();
	v31._weaponpivot = CFrame.new();
	v31._weaponaimpivot = CFrame.new();
	v31._weapondrawcf = CFrame.new();
	v31._weaponlhold = Vector3.new(0, -1, 0);
	v31._weaponrhold = Vector3.zero;
	v31._weaponforward = Vector3.new(0, 0, -1);
	v31._weaponstabcf = CFrame.new();
	v31._weprendered = false;
	v31._equipspring = v11.new();
	v31._equipspring.s = 12;
	v31._equipspring.d = 0.8;
	v31._aimspring = v11.new(1);
	v31._aimspring.s = 12;
	v31._stabspring = v11.new();
	v31._stabspring.s = 20;
	v31._stabspring.d = 0.8;
	v31._transkickspring = v11.new(Vector3.zero);
	v31._rotkickspring = v11.new(Vector3.zero);
	v31._muzzlelight = nil;
	v31._muzzlespring = v11.new(0);
	v31._muzzlespring.s = 50;
	v31._muzzlespring.d = 1;
	v31._group = Instance.new("SoundGroup");
	v31._group.Parent = game:GetService("SoundService");
	v31._equalizer = Instance.new("EqualizerSoundEffect");
	v31._equalizer.HighGain = 0;
	v31._equalizer.MidGain = 0;
	v31._equalizer.LowGain = 0;
	v31._equalizer.Parent = v31._group;
	v31._destructor:add(v31._group);
	v31._destructor:add(function()
		if v31._character then
			v31._character:Destroy();
			v31._character = nil;
		end;
		if v31._weapon then
			v31._weapon:Destroy();
			v31._weapon = nil;
		end;
	end);
	return v31;
end;
function v1.Destroy(p4)
	p4._destructor:Destroy();
end;
function v1.getWeaponModel(p5)
	return p5._weapon;
end;
function v1.getCharacterHash(p6)
	return p6._characterHash;
end;
function v1.getBodyPart(p7, p8)
	return p7._characterHash[p8];
end;
function v1.getCharacterModel(p9)
	return p9._character;
end;
function v1.getWeaponPosition(p10)
	if p10._muzzlepart then
		return p10._muzzlepart.CFrame.p;
	end;
	if not p10._weapon then
		return p10._replicationObject._posspring.p;
	end;
	return p10._weapon.Slot1.CFrame * p10._weaponrotoffset:inverse() * Vector3.new(0, 0, -2);
end;
function v1.getBaseAngle(p11)
	return p11._baseangle;
end;
function v1.setAim(p12, p13)
	if p13 then
		local v37 = 0;
	else
		v37 = 1;
	end;
	p12._aimspring.t = v37;
end;
function v1.setSprint(p14, p15)
	if p15 then
		local v38 = 0;
	else
		v38 = 1;
	end;
	p14._sprintspring.t = v38;
end;
function v1.setStance(p16, p17)
	if p17 == "stand" then
		local v39 = 0;
	elseif p17 == "crouch" then
		v39 = 0.5;
	else
		v39 = 1;
	end;
	p16._stancespring.t = v39;
end;
function v1.popCharacterModel(p18)
	if p18._weapon then
		p18._weapon:Destroy();
	end;
	p18._character = nil;
	p18._characterHash = nil;
	p18._weapon = nil;
	p18._weapontype = nil;
	return p18._character;
end;
local function u2(p19, p20)
	local l__Slot1__40 = p19:FindFirstChild("Slot1");
	local l__Slot2__41 = p19:FindFirstChild("Slot2");
	if not l__Slot1__40 or not l__Slot2__41 then
		warn("ThirdPersonObject: Missing Slot1 or Slot2 part in third person model", p19, l__Slot1__40, l__Slot2__41);
		return;
	end;
	local v42 = nil;
	local l__next__43 = next;
	local v44, v45 = p19:GetChildren();
	while true do
		local v46, v47 = l__next__43(v44, v45);
		if not v46 then
			break;
		end;
		v45 = v46;
		if v47:IsA("BasePart") then
			if v47.Name == "Flame" then
				v42 = v47;
			end;
			if v47 ~= l__Slot1__40 then
				local v48 = Instance.new("Weld");
				v48.Part0 = l__Slot1__40;
				v48.Part1 = v47;
				v48.C0 = l__Slot1__40.CFrame:inverse() * v47.CFrame;
				v48.Parent = l__Slot1__40;
			end;
			if v2.getValue("togglethirdpersoncamo") and p20 then
				v4.textureModel(p19, p20);
			end;
			v47.Massless = true;
			v47.Anchored = false;
			v47.CastShadow = false;
			v47.CanCollide = false;
		end;	
	end;
	return v42;
end;
function v1.equipMelee(p21)
	local v49 = p21._replicationObject:getWeaponObject(3);
	local l__weaponData__50 = v49.weaponData;
	if p21._weapon then
		p21._equipspring.t = 0;
		p21._weapon.Slot1.Transparency = 1;
		p21._weapon.Slot2.Transparency = 1;
		p21._mainweld.Part1 = nil;
		p21._weapon:Destroy();
		p21._weapon = nil;
	end;
	p21._weapontype = "melee";
	p21._weaponname = v49.weaponName;
	p21._weapondualhand = l__weaponData__50.dualhand;
	p21._weapontransoffset = CFrame.new(l__weaponData__50.offset3p.p);
	p21._weaponrotoffset = l__weaponData__50.offset3p - l__weaponData__50.offset3p.p;
	p21._weaponpivot = l__weaponData__50.pivot3p;
	p21._weapondrawcf = l__weaponData__50.drawcf3p;
	p21._weaponforward = l__weaponData__50.forward3p;
	p21._weaponsprintcf = l__weaponData__50.sprintcf3p;
	p21._weaponlhold = l__weaponData__50.lhold3p;
	p21._weaponrhold = l__weaponData__50.rhold3p;
	p21._weaponstabcf = l__weaponData__50.stabcf3p;
	local v51 = v3.getExternalModel(v49.weaponName);
	if not v51 then
		warn("ThirdPersonObject: No external model found for", v49.weaponName);
		return;
	end;
	p21._weapon = v51:Clone();
	p21._muzzlepart = u2(p21._weapon, v49.camoData);
	p21._weapon.Parent = p21._torso.Parent;
	p21._mainweld.Part1 = p21._weapon.Slot1;
	p21._equipspring.t = 1;
end;
function v1.equip(p22, p23, p24)
	local v52 = p22._replicationObject:getWeaponObject(p23);
	local l__weaponData__53 = v52.weaponData;
	if p22._weapon then
		p22._equipspring.t = 0;
		p22._weapon.Slot1.Transparency = 1;
		p22._weapon.Slot2.Transparency = 1;
		p22._mainweld.Part1 = nil;
		p22._weapon:Destroy();
		p22._weapon = nil;
	end;
	p22._weapontype = "firearm";
	p22._weaponname = v52.weaponName;
	p22._weapontranskickmax = l__weaponData__53.transkickmax;
	p22._weapontranskickmin = l__weaponData__53.transkickmin;
	p22._weaponrotkickmax = l__weaponData__53.rotkickmax;
	p22._weaponrotkickmin = l__weaponData__53.rotkickmin;
	p22._weapontransoffset = CFrame.new(l__weaponData__53.offset3p.p);
	p22._weaponrotoffset = l__weaponData__53.offset3p - l__weaponData__53.offset3p.p;
	p22._weaponpivot = l__weaponData__53.pivot3p;
	p22._weapondrawcf = l__weaponData__53.drawcf3p;
	p22._weaponforward = l__weaponData__53.forward3p;
	p22._weaponheadaimangle = l__weaponData__53.headaimangle3p and 0;
	p22._weaponsprintcf = l__weaponData__53.sprintcf3p;
	p22._weaponaimpivot = l__weaponData__53.aimpivot3p;
	p22._transkickspring.s = l__weaponData__53.modelkickspeed;
	p22._transkickspring.d = l__weaponData__53.modelkickdamper;
	p22._rotkickspring.s = l__weaponData__53.modelkickspeed;
	p22._rotkickspring.d = l__weaponData__53.modelkickdamper;
	p22._weaponlhold = l__weaponData__53.lhold3p;
	p22._weaponrhold = l__weaponData__53.rhold3p;
	p22._weapon = v3.getExternalModel(v52.weaponName):Clone();
	p22._muzzlepart = u2(p22._weapon, v52.camoData);
	p22._weapon.Parent = p22._torso.Parent;
	p22._mainweld.Part1 = p22._weapon.Slot1;
	p22._equipspring.t = 1;
	if l__weaponData__53.firesoundid then
		p22._soundid = l__weaponData__53.firesoundid;
	end;
end;
function v1.stab(p25)
	if p25._weapontype ~= "melee" then
		warn("ThirdPersonObject: Attempt to stab with a non-melee", p25._player, p25._weaponname, p25._weapontype);
		return;
	end;
	p25._stabspring.a = 47;
	local l__CFrame__54 = p25._torso.CFrame;
	local v55, v56, v57 = workspace:FindPartOnRayWithIgnoreList(Ray.new(l__CFrame__54.p, l__CFrame__54.LookVector * 5), { l__Ignore__18, l__Map__19, l__Players__17:FindFirstChild(p25._player.TeamColor.Name) });
	if v55 then
		v10:bloodhit(v56, true, 85, Vector3.new(0, -8, 0) + (v56 - l__CFrame__54.p).unit * 8, true);
	end;
end;
local l__CurrentCamera__3 = workspace.CurrentCamera;
function v1.kickWeapon(p26, p27, p28, p29, p30)
	if p26._weapontype ~= "firearm" then
		warn("ThirdPersonObject: Attempt to shoot with a non-firearm", p26._player, p26._weaponname);
		return;
	end;
	local l__p__58 = p26._aimspring.p;
	local l___weapontranskickmin__59 = p26._weapontranskickmin;
	p26._transkickspring.a = l___weapontranskickmin__59 + Vector3.new(math.random(), math.random(), math.random()) * (p26._weapontranskickmax - l___weapontranskickmin__59);
	local l___weaponrotkickmin__60 = p26._weaponrotkickmin;
	p26._rotkickspring.a = l___weaponrotkickmin__60 + Vector3.new(math.random(), math.random(), math.random()) * (p26._weaponrotkickmax - l___weaponrotkickmin__60);
	if #u1 == 0 then
		local v61 = Instance.new("Sound");
		v61.Ended:connect(function()
			v61.Parent = nil;
			table.insert(u1, v61);
		end);
	else
		v61 = table.remove(u1, 1);
	end;
	v61.SoundGroup = p26._group;
	v61.SoundId = p28 or p26._soundid;
	if p29 then
		v61.Pitch = p29;
	end;
	if p30 then
		v61.Volume = p30;
	end;
	local v62 = -(p26._torso.Position - l__CurrentCamera__3.CFrame.p).Magnitude / 14.6484;
	p26._equalizer.HighGain = v62;
	p26._equalizer.MidGain = v62;
	v61.Parent = p26._torso;
	v61:Play();
	local l___muzzlepart__63 = p26._muzzlepart;
	if v2.getValue("togglemuzzleffects") and l___muzzlepart__63 and v6.point(l___muzzlepart__63.Position) then
		if not p27 then
			p26._muzzlespring.a = 125;
		end;
		local l__Smoke__64 = l___muzzlepart__63:FindFirstChild("Smoke");
		if not p27 then
			local l__next__65 = next;
			local v66, v67 = l___muzzlepart__63:GetChildren();
			while true do
				local v68, v69 = l__next__65(v66, v67);
				if not v68 then
					break;
				end;
				v67 = v68;
				if v69 ~= l__Smoke__64 and v69:IsA("ParticleEmitter") then
					v69:Emit(1);
				end;			
			end;
		end;
	end;
end;
local function u4(p31, p32, p33, p34)
	local v70 = p32 - p31;
	local l__magnitude__71 = v70.magnitude;
	if not (l__magnitude__71 > 0) then
		return 0;
	end;
	local v72 = p31 - p34;
	local v73 = v72:Dot(v70) / l__magnitude__71;
	local v74 = p33 * p33 + v73 * v73 - v72:Dot(v72);
	if not (v74 > 0) then
		return 1;
	end;
	local v75 = v74 ^ 0.5 - v73;
	if not (v75 > 0) then
		return 1;
	end;
	return l__magnitude__71 / v75, v75 - l__magnitude__71;
end;
function v1.render(p35, p36, p37, p38, p39, p40, p41)
	if p35._weapon then
		if not p35._weapon:FindFirstChild("Slot1") then
			warn("ThirdPersonObject: No slot1 found for", p35._weapon, p35._weaponname, p35._weapon.Parent, p35._player, p35._player.Parent);
			p35._weapon = nil;
		elseif p37 and not p35._weprendered then
			p35._weapon.Slot1.Transparency = 0;
			p35._weapon.Slot2.Transparency = 0;
			p35._weprendered = true;
		elseif not p37 and p35._weprendered then
			p35._weapon.Slot1.Transparency = 1;
			p35._weapon.Slot2.Transparency = 1;
			p35._weprendered = false;
		end;
	end;
	p35._torso.CFrame = p38;
	if p36 >= 1 then
		local l__p__76 = p35._stancespring.p;
		local l__p__77 = p35._sprintspring.p;
		local l__y__78 = p40.y;
		local v79 = l__p__77 * p35._maxdangle;
		p35._baseangle = p35._baseangle - l__y__78 < -v79 and l__y__78 - v79 or (v79 < p35._baseangle - l__y__78 and l__y__78 + v79 or p35._baseangle);
		local v80 = CFrame.Angles(0, p35._baseangle, 0) * CFrame.new(0, 0.05 * math.sin(2 * v9.getTime()) - 0.55, 0) * (l__p__76 < 0.5 and v21(2 * l__p__76) or v22(2 * l__p__76 - 1)) * CFrame.new(0, 0.5, 0) + p38.p;
		local v81 = l__p__76 > 0.5 and 2 * l__p__76 - 1 or 0;
		local v82 = (p38 * p35._rfoot.sdown):Lerp(v80 * p35._rfoot.pdown, v81);
		local v83 = (p38 * p35._lfoot.sdown):Lerp(v80 * p35._lfoot.pdown, v81);
		local l__p__84 = v83.p;
		p35._stepradius = 0.5 * (1 - l__p__76) + 0.5 + (1 - l__p__77) * 0.5;
		local v85, v86 = u4(p35._rfoot.center.p, v82.p, p35._stepradius, p35._rfoot.pos);
		if v86 then
			p35._steplist.remp = v86;
		end;
		p35._speedspring.t = p39.magnitude;
		local v87 = l__p__84 - p35._lfoot.center.p;
		local l__magnitude__88 = v87.magnitude;
		if l__magnitude__88 > 0 then
			local v89 = l__p__84 + p35._stepradius / l__magnitude__88 * v87;
		else
			v89 = l__p__84;
		end;
		if v85 < 1 then
			p35._lfoot.pos = (1 - v85) * (v83 * p35._lfoot.center:inverse() * p35._lfoot.pos) + v85 * v89;
			p35._rfoot.center = v82;
			p35._lfoot.center = v83;
		else
			local l__Magnitude__90 = (l__CurrentCamera__3.CFrame.p - l__p__84).Magnitude;
			if p35._lfoot.makesound and l__Magnitude__90 < 128 then
				local v91 = workspace:Raycast(l__p__84 + v26, v27, v29);
				if v91 then
					local v92 = v14.soundfonts[v91.Material];
					if v92 then
						if p35._player.TeamColor ~= l__LocalPlayer__15.TeamColor then
							local v93 = "enemy_" .. v92;
							local v94 = 3.872983346207417 / (l__Magnitude__90 / 5);
						else
							v93 = "friendly_" .. v92;
							v94 = 1.4142135623730951 / (l__Magnitude__90 / 5);
						end;
						if v93 == "enemy_wood" then
							v94 = 3.1622776601683795 / (l__Magnitude__90 / 5);
						end;
						if p35._speedspring.p <= 15 then
							local v95 = v93 .. "walk";
						else
							v95 = v93 .. "run";
						end;
						v14.PlaySound(v95, nil, v94, 1, nil, nil, p35._torso, 128, 10);
					end;
				end;
			end;
			p35._rfoot.center = v82;
			p35._lfoot.center = v83;
			p35._rfoot.pos = v82.p + p35._stepradius * (p35._rfoot.pos - v82.p).unit;
			p35._lfoot.pos = v89;
			p35._rfoot = p35._lfoot;
			p35._lfoot = p35._rfoot;
		end;
		if p36 >= 2 then
			local v96 = v13.anglesyx(p40.x, l__y__78);
			local l__p__97 = p35._equipspring.p;
			local v98 = p35._speedspring.p / 8;
			local v99 = v98 < 1 and v98 or 1;
			local v100 = p35._steplist.remp * (2 - p35._steplist.remp / p35._stepradius);
			if v100 < 0 then
				local v101 = 0;
			else
				v101 = v100;
			end;
			local v102 = v12.direct(v80, v28, v96, 0.5 * l__p__77 * (1 - l__p__76) * l__p__97) * CFrame.Angles(0, v101 * p35._rfoot.torsoswing, 0) * CFrame.new(0, -3, 0);
			local v103 = v12.direct(CFrame.new(), Vector3.new(0, 1, 0), Vector3.new(0, 333.3333333333333, 0) + p41, 1 - v81) * (v102 - v102.p) * CFrame.new(0, 3, 0) + v102.p + Vector3.new(0, v101 * v99 / 16, 0);
			p35._torso.CFrame = v103;
			p35._rfoot.weld.C0 = v12.jointleg(1, 1.5, p35._rfoot.hipcf, v103:inverse() * p35._rfoot.pos, v81 * v20 / 5 * p35._rfoot.angm) * p35._rfoot.legcf;
			p35._lfoot.weld.C0 = v12.jointleg(1, 1.5, p35._lfoot.hipcf, v103:inverse() * (p35._lfoot.pos + v101 * v99 / 3 * Vector3.new(0, 1, 0)), v81 * v20 / 5 * p35._lfoot.angm) * p35._lfoot.legcf;
			local l__p__104 = p35._aimspring.p;
			p35._neck.C0 = v103:inverse() * v12.direct(v103 * CFrame.new(0, 0.825, 0), v28, v96) * CFrame.Angles(0, 0, (1 - l__p__104) * p35._weaponheadaimangle) * CFrame.new(0, 0.675, 0);
			if p35._muzzlelight then
				p35._muzzlelight.Brightness = p35._muzzlespring.p;
			end;
			if p35._weapon then
				if p35._weapontype == "firearm" then
					local v105 = p35._weapondrawcf:Lerp(CFrame.Angles(v101 / 10, v101 * p35._rfoot.torsoswing, 0) * p35._weaponsprintcf:Lerp(v103:inverse() * v12.direct(v103 * p35._weaponaimpivot:Lerp(p35._weaponpivot, l__p__104), v28, v96) * p35._weapontransoffset * CFrame.new(p35._transkickspring.p) * v12.fromaxisangle(p35._rotkickspring.p) * p35._weaponrotoffset, l__p__77), l__p__97);
					p35._lsh.C0 = v12.jointarm(1, 1.5, v24, v105 * p35._weaponlhold) * v25;
					p35._rsh.C0 = v12.jointarm(1, 1.5, v23, v105 * p35._weaponrhold) * v25;
					p35._mainweld.C0 = v105;
					return;
				end;
				if p35._weapontype == "melee" then
					local v106 = p35._weapondrawcf:Lerp(p35._weaponsprintcf:Lerp(v103:inverse() * v12.direct(v103 * p35._weaponpivot, v28, v96) * p35._weapontransoffset * p35._weaponrotoffset * CFrame.new():Lerp(p35._weaponstabcf, p35._stabspring.p), l__p__77), l__p__97);
					if p35._weapondualhand then
						p35._lsh.C0 = v12.jointarm(1, 1.5, v24, v106 * p35._weaponlhold) * v25;
					else
						p35._lsh.C0 = v12.jointarm(1, 1.5, v24, p35._weaponlhold) * v25;
					end;
					p35._rsh.C0 = v12.jointarm(1, 1.5, v23, v106 * p35._weaponrhold) * v25;
					p35._mainweld.C0 = v106;
				end;
			end;
		end;
	end;
end;
return v1;

