
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("sound");
local l__ReplicatedStorage__3 = game.ReplicatedStorage;
local l__Character__4 = l__ReplicatedStorage__3:WaitForChild("Character");
local u1 = shared.require("network");
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
local u3 = shared.require("Destructor");
local l__RefPlayer__4 = l__Character__4:WaitForChild("Bodies"):WaitForChild("RefPlayer");
local function u5(p1)
	if p1:IsA("Script") then
		p1.Disabled = true;
		return;
	end;
	if p1:IsA("BodyMover") and p1.Name ~= "\n" then
		u1:send("logmessage", "BodyMover");
		l__LocalPlayer__2:Kick();
		return;
	end;
	if p1:IsA("BasePart") then
		p1.Transparency = 1;
		p1.CollisionGroupId = 1;
		p1.CanCollide = true;
		p1.CanTouch = false;
		p1.CanQuery = false;
		return;
	end;
	if p1:IsA("Decal") then
		p1.Transparency = 1;
	end;
end;
local function u6(p2, p3)
	local l__CFrame__5 = p3.CFrame;
	local l__next__6 = next;
	local v7, v8 = p2:GetChildren();
	while true do
		local v9, v10 = l__next__6(v7, v8);
		if not v9 then
			break;
		end;
		v8 = v9;
		if v10 ~= p3 and v10:IsA("BasePart") then
			local v11 = l__CFrame__5:ToObjectSpace(v10.CFrame);
			local v12 = Instance.new("Weld");
			v12.Part0 = p3;
			v12.Part1 = v10;
			v12.C0 = v11;
			v12.Parent = p3;
			v10.CFrame = l__CFrame__5 * v11;
		end;	
	end;
	local l__next__13 = next;
	local v14, v15 = p2:GetDescendants();
	while true do
		local v16, v17 = l__next__13(v14, v15);
		if not v16 then
			break;
		end;
		v15 = v16;
		if v17:IsA("BasePart") then
			v17.Massless = true;
			v17.Anchored = false;
			v17.CanCollide = false;
			v17.CanTouch = false;
			v17.CanQuery = false;
		end;	
	end;
end;
local u7 = { Enum.HumanoidStateType.Dead, Enum.HumanoidStateType.Flying, Enum.HumanoidStateType.Seated, Enum.HumanoidStateType.Ragdoll, Enum.HumanoidStateType.Physics, Enum.HumanoidStateType.Swimming, Enum.HumanoidStateType.GettingUp, Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.RunningNoPhysics, Enum.HumanoidStateType.StrafingNoPhysics };
local u8 = nil;
local u9 = shared.require("GameRoundInterface");
local l__soundfonts__10 = v2.soundfonts;
local u11 = shared.require("spring");
local u12 = shared.require("Sequencer");
local u13 = shared.require("PlayerSettingsInterface");
local u14 = shared.require("MenuScreenGui");
local u15 = shared.require("HudScreenGui");
local u16 = shared.require("UnscaledScreenGui");
local u17 = shared.require("effects");
local u18 = shared.require("input");
function v1.new(p4, p5)
	local v18 = setmetatable({}, v1);
	v18._destructor = u3.new();
	v18._characterModel = l__RefPlayer__4:Clone();
	v18._destructor:add(v18._characterModel);
	local l__next__19 = next;
	local v20, v21 = v18._characterModel:GetDescendants();
	while true do
		local v22, v23 = l__next__19(v20, v21);
		if not v22 then
			break;
		end;
		v21 = v22;
		u5(v23);	
	end;
	v18._rootPart = v18._characterModel:WaitForChild("HumanoidRootPart");
	v18._rootPart.Position = p4;
	v18._rootPart.Velocity = Vector3.new();
	v18._rootPart.CanCollide = false;
	v18._rootJoint = v18._rootPart:WaitForChild("RootJoint");
	v18._rootJoint.C0 = CFrame.new();
	v18._rootJoint.C1 = CFrame.new();
	v18._bodyVelocity = Instance.new("BodyVelocity");
	v18._bodyVelocity.Name = "\n";
	v18._bodyVelocity.MaxForce = Vector3.new();
	v18._bodyVelocity.Parent = v18._rootPart;
	v18._torso = v18._characterModel:WaitForChild("Torso");
	v18._muzzleLight = l__ReplicatedStorage__3.Effects.MuzzleLight:Clone();
	v18._muzzleLight.Parent = v18._rootPart;
	v18._leftArmModel = l__Character__4["Left Arm"]:Clone();
	v18._leftMainPart = v18._leftArmModel.Arm;
	v18._leftWeld = Instance.new("Motor6D");
	v18._leftWeld.Part0 = v18._rootPart;
	v18._leftWeld.Part1 = v18._leftMainPart;
	v18._leftWeld.Parent = v18._leftMainPart;
	v18._leftArmModel.Parent = workspace.CurrentCamera;
	v18._rightArmModel = l__Character__4["Right Arm"]:Clone();
	v18._rightMainPart = v18._rightArmModel.Arm;
	v18._rightWeld = Instance.new("Motor6D");
	v18._rightWeld.Part0 = v18._rootPart;
	v18._rightWeld.Part1 = v18._rightMainPart;
	v18._rightWeld.Parent = v18._rightMainPart;
	v18._rightArmModel.Parent = workspace.CurrentCamera;
	u6(v18._leftArmModel, v18._leftMainPart);
	u6(v18._rightArmModel, v18._rightMainPart);
	v18._destructor:add(v18._leftArmModel);
	v18._destructor:add(v18._rightArmModel);
	v18._fallsound = Instance.new("Sound");
	v18._fallsound.Looped = true;
	v18._fallsound.SoundId = "rbxassetid://9057212926";
	v18._fallsound.Volume = 0;
	v18._fallsound.Parent = workspace;
	v18._destructor:add(v18._fallsound);
	v18._humanoid = Instance.new("Humanoid");
	for v24, v25 in next, u7 do
		v18._humanoid:SetStateEnabled(v25, false);
	end;
	v18._humanoid.AutoRotate = false;
	v18._humanoid.RequiresNeck = false;
	v18._humanoid.AutoJumpEnabled = false;
	v18._humanoid.NameDisplayDistance = 0;
	v18._humanoid.HealthDisplayDistance = 0;
	v18._humanoid.BreakJointsOnDeath = false;
	v18._humanoid.AutomaticScalingEnabled = false;
	v18._humanoid.RigType = Enum.HumanoidRigType.R6;
	v18._destructor:add(v18._humanoid.StateChanged:Connect(function(p6, p7)
		local v26 = u8.getActiveCamera("MainCamera");
		if p6 == Enum.HumanoidStateType.Climbing and p7 ~= Enum.HumanoidStateType.Climbing then
			v18._climbing.t = 0;
		end;
		if p7 == Enum.HumanoidStateType.Freefall then
			v18._fallsound.Volume = 0;
			v18._fallsound:Play();
			while v18._fallsound.Parent and v18._fallsound.Playing do
				if not v18._characterModel or not v18._characterModel.Parent then
					v18._fallsound:Stop();
					v18._fallsound.Volume = 0;
				end;
				local v27 = math.abs(v18._rootPart.Velocity.Y / 80) ^ 5;
				if v27 < 0 then
					v27 = 0;
				end;
				v18._fallsound.Volume = v27 <= 0.75 and v27 or 0.75;
				task.wait();			
			end;
		elseif p7 == Enum.HumanoidStateType.Climbing then
			local v28 = workspace:FindPartOnRayWithWhitelist(Ray.new(v26:getCFrame().p, v26:getLookVector() * 2), u9.raycastWhiteList);
			if v28 and v28:IsA("TrussPart") then
				v18._climbing.t = 1;
				return;
			end;
		elseif p7 == Enum.HumanoidStateType.Landed then
			v18._fallsound:Stop();
			local v29 = CFrame.Angles(0, v26:getAngles().y, 0) + v18._rootPart.Position;
			local l__y__30 = v18._rootPart.Velocity.y;
			local v31 = l__y__30 * l__y__30 / (2 * workspace.Gravity);
			if v31 > 2 and v18._floorMaterial then
				local v32 = l__soundfonts__10[v18._floorMaterial];
				if v32 then
					v2.PlaySound(v32 .. "Land", "SelfFoley", 0.25);
				end;
			end;
			if v31 > 12 then
				v2.PlaySound("landHard", "SelfFoley", 0.25);
			end;
			if v31 > 16 then
				v2.PlaySound("landNearDeath", "SelfFoley", 0.25);
				local v33 = true;
				if v31 == v31 then
					v33 = true;
					if v31 ~= (1 / 0) then
						v33 = v31 == (-1 / 0);
					end;
				end;
				if v33 then
					v31 = 100;
				end;
				u1:send("falldamage", v31);
			end;
		end;
	end));
	v18._humanoid:ChangeState(Enum.HumanoidStateType.Running);
	v18._humanoid.Parent = v18._characterModel;
	l__LocalPlayer__2.Character = v18._characterModel;
	v18._speed = 0;
	v18._distance = 0;
	v18._velocity = Vector3.new();
	v18._acceleration = Vector3.new();
	v18._baseWalkSpeed = 14;
	v18._walkSpeedMult = 1;
	v18._backSpeedMult = 0.8;
	v18._nextStep = 0;
	v18._sprinting = false;
	v18._movementMode = "stand";
	v18._floorMaterial = nil;
	v18._healWait = 8;
	v18._healRate = 0.25;
	v18._maxHealth = 100;
	v18._health0 = 0;
	v18._healTick0 = 0;
	v18._walkspeedspring = u11.new(v18._baseWalkSpeed);
	v18._walkspeedspring.s = 8;
	v18._speedspring = u11.new();
	v18._speedspring.s = 16;
	v18._velocityspring = u11.new(Vector3.new());
	v18._velocityspring.s = 16;
	v18._truespeedspring = u11.new(0);
	v18._truespeedspring.s = 8;
	v18._sprintspring = u11.new();
	v18._sprintspring.s = 12;
	v18._sprintspring.d = 0.9;
	v18._climbing = u11.new();
	v18._climbing.s = 12;
	v18._climbing.d = 0.9;
	v18._pronespring = u11.new(0);
	v18._pronespring.s = 8;
	v18._crouchspring = u11.new(0);
	v18._crouchspring.s = 8;
	v18._headheightspring = u11.new(1.5);
	v18._headheightspring.s = 8;
	v18._slidespring = u11.new(0);
	v18._slidespring.s = 20;
	v18._swingspring = u11.new(Vector3.new());
	v18._swingspring.s = 10;
	v18._swingspring.d = 0.75;
	v18._equipspring = u11.new(1);
	v18._equipspring.s = 12;
	v18._equipspring.d = 0.75;
	v18._aimspring = u11.new();
	v18._aimspring.d = 0.95;
	v18._zoommodspring = u11.new(1);
	v18._zoommodspring.s = 12;
	v18._zoommodspring.d = 0.95;
	v18._muzzlespring = u11.new(0);
	v18._muzzlespring.s = 50;
	v18._muzzlespring.d = 1;
	v18._destructor:add(v18._characterModel.DescendantAdded:Connect(u5));
	v18._destructor:add(v18._rootPart.Touched:Connect(function(p8)
		if string.lower(p8.Name) == "killwall" then
			u1:send("forcereset");
		end;
	end));
	v18.thread = u12.new();
	v18.sprintdisable = false;
	v18.doubletap = false;
	v18.reloading = false;
	v18.animating = false;
	v18.unaimedfov = u13.getValue("fov");
	v18.stability = 0;
	v18.nextjump = 0;
	v18._publicSprings = {
		truespeedspring = v18._truespeedspring, 
		walkspeedspring = v18._walkspeedspring, 
		zoommodspring = v18._zoommodspring, 
		sprintspring = v18._sprintspring, 
		muzzlespring = v18._muzzlespring, 
		crouchspring = v18._crouchspring, 
		pronespring = v18._pronespring, 
		swingspring = v18._swingspring, 
		slidespring = v18._slidespring, 
		equipspring = v18._equipspring, 
		aimspring = v18._aimspring, 
		climbing = v18._climbing
	};
	v18._characterModel.Parent = workspace.Ignore;
	u14.disable();
	u15.enable();
	u16.enable();
	u17:setuplighting(true);
	u18.mouse.lockcenter();
	u18.mouse.hide();
	u8.setCameraType("MainCamera", {
		cameraSubject = v18._humanoid, 
		direction = p5
	});
	v18._destructor:add(function()
		l__LocalPlayer__2.Character = nil;
	end);
	return v18;
end;
function v1.Destroy(p9)
	p9._destructor:Destroy();
end;
function v1.isSprinting(p10)
	return p10._sprinting;
end;
function v1.getState(p11)
	return p11._humanoid:GetState();
end;
function v1.getRootPart(p12)
	return p12._rootPart;
end;
function v1.getArmModels(p13)
	return p13._leftArmModel, p13._rightArmModel;
end;
function v1.getSpeed(p14)
	return p14._speed;
end;
function v1.getAcceleration(p15)
	return p15._acceleration;
end;
function v1.getSpring(p16, p17)
	return p16._publicSprings[p17];
end;
function v1.getSlideCondition(p18)
	return p18._baseWalkSpeed * 1.2 < p18._walkspeedspring.p;
end;
function v1.getMovementMode(p19)
	return p19._movementMode;
end;
local u19 = shared.require("GameClock");
function v1.getHealth(p20)
	local v34 = u19.getTime() - p20._healTick0;
	if v34 < 0 then
		return p20._health0;
	end;
	local v35 = p20._health0 + v34 * v34 * p20._healRate;
	return v35 < p20._maxHealth and v35 or p20._maxHealth, true;
end;
function v1.getMaxHealth(p21)
	return p21._maxHealth;
end;
function v1.getWalkValues(p22)
	return p22._distance, p22._speed, p22._velocity;
end;
function v1.getArmWelds(p23)
	return p23._leftWeld, p23._rightWeld;
end;
function v1.updateHealth(p24, p25, p26, p27, p28)
	p24._health0 = p25;
	p24._healTick0 = p26;
	p24._healRate = p27;
	p24._maxHealth = p28;
end;
function v1.updateWalkSpeed(p29)
	if p29._sprinting then
		p29._walkspeedspring.t = 1.4 * p29._walkSpeedMult * p29._baseWalkSpeed;
		return;
	end;
	if p29._movementMode == "prone" then
		p29._walkspeedspring.t = p29._walkSpeedMult * p29._baseWalkSpeed / 4;
		return;
	end;
	if p29._movementMode == "crouch" then
		p29._walkspeedspring.t = p29._walkSpeedMult * p29._baseWalkSpeed / 2;
		return;
	end;
	if p29._movementMode == "stand" then
		p29._walkspeedspring.t = p29._walkSpeedMult * p29._baseWalkSpeed;
	end;
end;
local l__Enum_Material_Air__20 = Enum.Material.Air;
function v1.jump(p30, p31, p32)
	if p30._floorMaterial == l__Enum_Material_Air__20 then
		return;
	end;
	local v36 = p32:getActiveWeapon();
	if v36:getWeaponType() == "Melee" then
		p31 = p31 * 1.15;
	end;
	local l__y__37 = p30._rootPart.Velocity.y;
	local v38 = p31 and (2 * game.Workspace.Gravity * p31) ^ 0.5 or 40;
	if l__y__37 < 0 then
		local v39 = v38;
	else
		v39 = (l__y__37 * l__y__37 + v38 * v38) ^ 0.5;
	end;
	if p30._movementMode == "prone" or p30._movementMode == "crouch" then
		p30:setMovementMode("stand");
		return;
	end;
	if v36:getWeaponType() == "Firearm" and v36:isAiming() then
		p30._humanoid.JumpPower = v39;
		p30._humanoid.Jump = true;
		return true;
	end;
	if p30._speed > 5 and p30._velocity.z < 0 and p30:parkourDetection() then
		p30:parkour();
	else
		p30._humanoid.JumpPower = v39;
		p30._humanoid.Jump = true;
	end;
	return true;
end;
function v1.fireMuzzleLight(p33)
	p33._muzzlespring.a = 100;
end;
function v1.setBaseWalkSpeed(p34, p35)
	p34._baseWalkSpeed = p35;
	p34:updateWalkSpeed();
end;
function v1.setWalkSpeedMult(p36, p37)
	p36._walkSpeedMult = p37;
	p36:updateWalkSpeed();
end;
local u21 = shared.require("CharacterEvents");
function v1.setSprint(p38, p39)
	if p39 == p38._sprinting or p38.sprintdisable then
		return;
	end;
	if p39 then
		if p38._sliding then
			v2.play("slideEnd", 0.15);
			p38._sliding = false;
		end;
		p38:setMovementMode("stand");
		p38._sprinting = true;
		p38._walkSpeedMult = 1;
		p38._walkspeedspring.t = 1.5 * p38._walkSpeedMult * p38._baseWalkSpeed;
		if not p38.reloading and not p38.animating then
			p38._sprintspring.t = 1;
		end;
	elseif p38._sprinting then
		p38._sprinting = false;
		p38._sprintspring.t = 0;
		p38._walkspeedspring.t = p38._walkSpeedMult * p38._baseWalkSpeed;
	end;
	u1:send("sprint", p38._sprinting);
	u21.onSprintChanged:fire(p39);
end;
local u22 = shared.require("HudCrosshairsEvents");
function v1.setMovementMode(p40, p41, p42)
	local v40 = nil;
	v40 = p40._movementMode;
	p40._movementMode = p41;
	if p41 == "prone" then
		if not p42 and v40 ~= p41 then
			v2.play("stanceProne", 0.15);
		end;
		p40.stability = 0.25;
		p40._pronespring.t = 1;
		p40._crouchspring.t = 0;
		p40._headheightspring.t = -1.5;
		p40._walkspeedspring.t = p40._walkSpeedMult * p40._baseWalkSpeed / 4;
		u22.requestCrossScaleUpdate:fire(0.5);
		if p42 and p40._sprinting and p40._rootPart.Velocity.y > -5 then
			spawn(function()
				local l__lookVector__41 = p40._rootPart.CFrame.lookVector;
				p40._rootPart.Velocity = l__lookVector__41 * 50 + Vector3.new(0, 40, 0);
				task.wait(0.1);
				p40._rootPart.Velocity = l__lookVector__41 * 60 + Vector3.new(0, 30, 0);
				task.wait(0.4);
				p40._rootPart.Velocity = l__lookVector__41 * 20 + Vector3.new(0, -10, 0);
			end);
		end;
	elseif p41 == "crouch" then
		if not p42 and v40 ~= p41 then
			v2.play("stanceStandCrouch", 0.15);
		end;
		local v42 = p40:getSlideCondition();
		p40.stability = 0.15;
		p40._pronespring.t = 0;
		p40._crouchspring.t = 1;
		p40._headheightspring.t = 0;
		p40._walkspeedspring.t = p40._walkSpeedMult * p40._baseWalkSpeed / 2;
		u22.requestCrossScaleUpdate:fire(0.75);
		local v43 = u8.getActiveCamera("MainCamera");
		if p42 and v42 and p40._humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
			v2.play("slideStart", 0.25);
			p40._sliding = true;
			p40._slidespring.t = 1;
			local u23 = false;
			spawn(function()
				local function v44()
					local v45, v46, v47, v48, v49, v50, v51, v52, v53, v54, v55, v56 = v43:getCFrame():components();
					local v57 = math.atan2(v50 - v54, v48 + v56);
					if v57 ~= v57 then
						warn("AngY is nan!");
						return CFrame.identity;
					end;
					return CFrame.Angles(0, v57, 0);
				end;
				local v58 = p40._rootPart.Velocity * Vector3.new(1, 0, 1);
				if v58.magnitude < 0.001 then
					local v59 = v44().lookVector;
				else
					v59 = v58 / v58.magnitude;
				end;
				if v59 ~= v59 then
					warn("Yep this is the problem and we need it", p40._rootPart.Velocity, v58, v59);
					v59 = Vector3.xAxis;
				end;
				local v60 = v44():vectorToObjectSpace(v59);
				p40._bodyVelocity.MaxForce = Vector3.new(40000, 10, 40000);
				local v61 = u19.getTime();
				while u19.getTime() < v61 + 0.6666666666666666 do
					if u18.keyboard.down.leftshift or u18.controller.down.l3 then
						if u23 then
							break;
						end;
						v59 = v44():vectorToWorldSpace(v60);
						if v59 ~= v59 then
							warn("AAAAAAAAAAAAAAAAAA", v44(), v59);
							v59 = Vector3.xAxis;
						end;
					else
						u23 = true;
					end;
					p40._bodyVelocity.Velocity = v59 * (40 - (u19.getTime() - v61) * 30 / 0.6666666666666666);
					task.wait();				
				end;
				local v62 = math.min(p40._rootPart.Velocity.Magnitude, 70);
				if v62 ~= v62 then
					warn("walkspeed bugged");
				end;
				p40._walkspeedspring.p = v62;
				p40._bodyVelocity.MaxForce = Vector3.new();
				p40._bodyVelocity.Velocity = Vector3.new();
				if p40._sliding then
					v2.play("slideEnd", 0.15);
					p40._sliding = false;
				end;
				p40._slidespring.t = 0;
			end);
		end;
	elseif p41 == "stand" then
		if v40 ~= p41 then
			v2.play("stanceStandCrouch", 0.15);
		end;
		p40.stability = 0;
		p40._pronespring.t = 0;
		p40._crouchspring.t = 0;
		p40._headheightspring.t = 1.5;
		p40._walkspeedspring.t = p40._walkSpeedMult * p40._baseWalkSpeed;
		u22.requestCrossScaleUpdate:fire(1);
	end;
	p40._sprinting = false;
	p40._sprintspring.t = 0;
	u1:send("stance", p41);
	u1:send("sprint", p40._sprinting);
	u21.onMovementChanged:fire(p41);
end;
function v1.parkour(p43)
	v2.play("parkour", 0.25);
	p43._bodyVelocity.MaxForce = Vector3.new();
	local v63 = Instance.new("BodyPosition");
	v63.P = 4000;
	v63.Name = "\n";
	v63.maxForce = Vector3.new(500000, 500000, 500000);
	v63.position = p43._rootPart.Position + p43._rootPart.CFrame.lookVector.unit * p43._speed * 1.5 + Vector3.new(0, 10, 0);
	v63.Parent = p43._rootPart;
	game:GetService("Debris"):AddItem(v63, 0.5);
	u21.onParkouring:fire();
end;
local u24 = {
	mid = {
		lower = 1.8, 
		upper = 4, 
		width = 1.5, 
		xrays = 5, 
		yrays = 8, 
		dist = 6, 
		sprintdist = 8, 
		color = BrickColor.new("Bright blue")
	}, 
	upper = {
		lower = 5, 
		upper = 6, 
		width = 1, 
		xrays = 5, 
		yrays = 7, 
		dist = 8, 
		sprintdist = 10, 
		color = BrickColor.new("Bright green")
	}
};
function v1.parkourDetection(p44)
	local v64 = p44._rootPart.CFrame * CFrame.new(0, -3, 0);
	local l__lookVector__65 = p44._rootPart.CFrame.lookVector;
	local v66 = false;
	local v67 = false;
	local v68 = {
		mid = {}, 
		upper = {}
	};
	local v69 = {};
	local l__next__70 = next;
	local v71 = nil;
	while true do
		local v72, v73 = l__next__70(u24, v71);
		if not v72 then
			break;
		end;
		for v74 = 0, v73.xrays - 1 do
			for v75 = 0, v73.yrays - 1 do
				local v76 = (v74 / (v73.xrays - 1) - 0.5) * v73.width;
				local v77 = v64 * Vector3.new(v76, v75 / (v73.yrays - 1) * (v73.upper - v73.lower) + v73.lower, 0);
				local v78, v79 = workspace:FindPartOnRayWithWhitelist(Ray.new(v77, l__lookVector__65 * (p44._sprinting and v73.sprintdist or v73.dist)), u9.raycastWhiteList);
				if v78 and v78.CanCollide then
					local l__Magnitude__80 = (v77 - v79).Magnitude;
					v68[v72][#v68[v72] + 1] = l__Magnitude__80;
					if v72 == "mid" then
						v66 = true;
						if v76 == 0 then
							v69[#v69 + 1] = l__Magnitude__80;
						end;
					elseif v72 == "upper" then
						v67 = true;
					end;
				end;
			end;
		end;	
	end;
	if v66 then
		local v81 = {};
		for v82 = 2, #v69 do
			v81[#v81 + 1] = v69[v82] - v69[v82 - 1];
		end;
		local v83 = nil;
		for v84 = 1, #v81 do
			if 0 == 0 then
				v83 = v81[v84];
				local v85 = 1;
			elseif math.abs(v81[v84] - v83) < 0.01 then
				v85 = 0 + 1;
			else
				v85 = 0 - 1;
			end;
		end;
		local v86 = 0;
		for v87 = 1, #v81 do
			if math.abs(v81[v87] - v83) < 0.01 then
				v86 = v86 + 1;
			end;
		end;
		if #v81 / 2 < v86 and v83 ~= 0 and math.abs((u24.mid.upper - u24.mid.lower) / u24.mid.yrays / v83) < 2 then
			return false;
		end;
		local v88 = {
			mid = 100, 
			upper = 100
		};
		local v89 = {
			mid = 0, 
			upper = 0
		};
		local l__next__90 = next;
		local v91 = nil;
		while true do
			local v92, v93 = l__next__90(v68, v91);
			if not v92 then
				break;
			end;
			for v94 = 1, #v93 do
				local v95 = v93[v94];
				if v95 < v88[v92] then
					v88[v92] = v95;
				end;
				if v89[v92] < v95 then
					v89[v92] = v95;
				end;
			end;		
		end;
		if not v67 or v67 and math.abs((v89.upper + v88.upper - v89.mid - v88.mid) / 2) > 4 then
			return true;
		end;
	end;
end;
local u25 = CFrame.new(0, -1.5, 0);
local u26 = CFrame.new(0, -1.5, 1.5, 1, 0, 0, 0, 0, 1, 0, -1, 0);
local u27 = CFrame.new();
function v1.step(p45, p46)
	local v96 = u8.getActiveCamera("MainCamera");
	local v97 = p45._headheightspring.p / 1.5;
	if v97 < 0 then
		p45._rootJoint.C0 = u25:lerp(u26, -v97);
	else
		p45._rootJoint.C0 = u25:lerp(u27, v97);
	end;
	local v98 = p45._velocityspring.v + Vector3.new(0, p45._headheightspring.v * 24, 0);
	local l__p__99 = p45._walkspeedspring.p;
	local v100 = v96:getDelta();
	p45._swingspring.t = Vector3.new(v98.z / 1024 / 32 - v98.y / 1024 / 16 - v100.x / 1024 * 3 / 2, v98.x / 1024 / 32 - v100.y / 1024 * 3 / 2, v100.y / 1024 * 3 / 2);
	local v101 = p45._rootPart.CFrame:VectorToObjectSpace(p45._rootPart.Velocity);
	local l__magnitude__102 = (Vector3.new(1, 0, 1) * v101).magnitude;
	if v101.magnitude < 0.0001 then
		if u9.roundLock then
			local v103 = 0;
		else
			v103 = l__p__99;
		end;
		p45._humanoid.WalkSpeed = v103;
	else
		if u9.roundLock then
			local v104 = 0;
		else
			v104 = (p45._backSpeedMult + (1 - p45._backSpeedMult) * (1 - v101.z / v101.magnitude) / 2) * l__p__99;
		end;
		p45._humanoid.WalkSpeed = v104;
	end;
	p45._rootPart.CFrame = CFrame.Angles(0, v96:getAngles().y, 0) + p45._rootPart.Position;
	local l__FloorMaterial__105 = p45._humanoid.FloorMaterial;
	if l__FloorMaterial__105 ~= l__Enum_Material_Air__20 then
		p45._speedspring.t = l__magnitude__102;
		local v106 = p45._speedspring.p;
		if p45._nextStep < p45._distance * 3 / 16 - 1 then
			p45._nextStep = p45._nextStep + 1;
			local v107 = l__soundfonts__10[l__FloorMaterial__105];
			if v107 and not p45._sliding and p45._movementMode ~= "prone" then
				if v106 <= 15 then
					local v108 = v107 .. "walk";
				else
					v108 = v107 .. "run";
				end;
				if v108 == "grasswalk" or v108 == "sandwalk" then
					local v109 = (v106 / 40) ^ 2;
				else
					v109 = (v106 / 35) ^ 2;
				end;
				v2.PlaySound("friendly_" .. v108, "SelfFoley", math.clamp(v109 <= 0.75 and v109 or 0.75, 0, 0.5), nil, 0, 0.2);
				v2.PlaySound("movement_extra", "SelfFoley", math.clamp((v106 / 50) ^ 2, 0, 0.25));
				if v106 >= 10 and v106 <= 15 then
					v2.PlaySound("cloth_walk", "SelfFoley", math.clamp((v106 / 20) ^ 2 / 6, 0, 0.25));
				elseif v106 > 15 then
					v2.PlaySound("cloth_run", "SelfFoley", math.clamp((v106 / 20) ^ 2 / 3, 0, 0.25));
				end;
			end;
		end;
	else
		p45._speedspring.t = 0;
		v106 = p45._speedspring.p;
	end;
	p45._speed = v106;
	p45._acceleration = v98;
	p45._velocity = p45._velocityspring.p;
	p45._distance = p45._distance + p46 * v106;
	p45._velocityspring.t = v101;
	p45._truespeedspring.t = l__magnitude__102 < l__p__99 and l__magnitude__102 or l__p__99;
	p45._floorMaterial = l__FloorMaterial__105;
	p45._muzzleLight.Brightness = p45._muzzlespring.p;
	if v101.magnitude < l__p__99 * 1 / 3 and u18.controllertype == "controller" and p45._sprinting then
		p45:setSprint(false);
	end;
	p45.thread:step(p46);
end;
function v1._init()
	u8 = shared.require("CameraInterface");
end;
return v1;

