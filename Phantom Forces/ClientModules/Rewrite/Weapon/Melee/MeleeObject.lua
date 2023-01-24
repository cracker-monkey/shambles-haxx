
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("PlayerSettingsInterface");
local v3 = shared.require("HudCrosshairsInterface");
local v4 = shared.require("HitDetectionInterface");
local v5 = shared.require("ReplicationInterface");
local v6 = shared.require("HudStatusInterface");
local v7 = shared.require("CameraInterface");
local v8 = shared.require("WeaponUtils");
local v9 = shared.require("network");
local v10 = shared.require("sound");
local v11 = shared.require("input");
local l__Map__12 = workspace:WaitForChild("Map");
local u1 = shared.require("Destructor");
local u2 = shared.require("CharacterInterface");
local u3 = shared.require("ContentDatabase");
local u4 = shared.require("InstanceType");
local u5 = shared.require("EquipStateMachine");
local u6 = shared.require("MeleeStateMachine");
local u7 = shared.require("cframe");
local u8 = shared.require("CharacterEvents");
function v1.new(p1, p2, p3)
	local v13 = setmetatable({}, v1);
	v13._destructor = u1.new();
	v13.weaponIndex = p1;
	v13._characterObject = u2.getCharacterObject();
	v13._weaponName = p2;
	v13._weaponData = u3.getWeaponData(p2, u4.IsStudio());
	v13._equipState = u5.new();
	v13._meleeState = u6.new(v13);
	v13._stateChangeTimes = {};
	v13._destructor:add(v13._equipState.onStateTransition:connect(function(...)
		v13:_logStateTransition(...);
		v13:_processEquipStateChange(...);
	end));
	v13._destructor:add(v13._meleeState.onStateTransition:connect(function(...)
		v13:_logStateTransition(...);
		v13:_processMeleeStateChange(...);
	end));
	v13._weaponModel = u3.getWeaponModel(p2):Clone();
	v13._mainPart = v13:getWeaponPart(v13:getWeaponStat("mainpart"));
	v13._bladePart = v13:getWeaponPart(v13:getWeaponStat("blade"));
	v13._tipPart = v13:getWeaponPart(v13:getWeaponStat("tip"));
	v13._destructor:add(v13._weaponModel);
	v13._knifePart = v13._mainPart:Clone();
	v13._knifePart.Name = "Handle";
	v13._knifePart.Parent = v13._weaponModel;
	v13._mainOffset = v13:getWeaponStat("mainoffset");
	v13._stabRate = 1000;
	v13._trailEffect = nil;
	v13._activeHitList = {};
	v13._activeStabType = nil;
	v13._animData = {};
	v13._textureData = {};
	v13._camoData = p3;
	v13:_weldKnife();
	local l__next__14 = next;
	local v15, v16 = v13._weaponModel:GetChildren();
	while true do
		local v17, v18 = l__next__14(v15, v16);
		if not v17 then
			break;
		end;
		v13._textureData[v18] = {};
		local l__next__19 = next;
		local v20, v21 = v18:GetChildren();
		while true do
			local v22, v23 = l__next__19(v20, v21);
			if not v22 then
				break;
			end;
			v21 = v22;
			if v23:IsA("Texture") or v23:IsA("Decal") then
				v13._textureData[v18][v23] = {
					Transparency = v23.Transparency
				};
			end;		
		end;
		if v18:IsA("BasePart") then
			v18.CastShadow = false;
		end;	
	end;
	v13._animData.camodata = v13._textureData;
	local v24, v25 = v13._characterObject:getArmModels();
	v13._knifeWeld = Instance.new("Motor6D");
	v13._knifeWeld.Part0 = v25.Arm;
	v13._knifeWeld.Part1 = v13._knifePart;
	v13._knifeWeld.Parent = v13._knifePart;
	v13._mainWeld = Instance.new("Motor6D");
	v13._mainWeld.Part0 = v13._characterObject:getRootPart();
	v13._mainWeld.Part1 = v13._mainPart;
	v13._mainWeld.Parent = v13._mainPart;
	v13._animData[v13:getWeaponStat("mainpart")] = {
		weld = {
			C0 = CFrame.new()
		}, 
		basec0 = CFrame.new()
	};
	v13._animData.knife = {
		weld = {
			C0 = v13:getWeaponStat("knifeoffset")
		}, 
		basec0 = v13:getWeaponStat("knifeoffset")
	};
	v13._animData.larm = {
		weld = {
			C0 = v13:getWeaponStat("larmoffset")
		}, 
		basec0 = v13:getWeaponStat("larmoffset")
	};
	v13._animData.rarm = {
		weld = {
			C0 = v13:getWeaponStat("rarmoffset")
		}, 
		basec0 = v13:getWeaponStat("rarmoffset")
	};
	v13._equipCF = v13:getWeaponStat("equipoffset");
	v13._proneCF = u7.interpolator(v13:getWeaponStat("proneoffset"));
	v13._sprintCF = u7.interpolator(v13:getWeaponStat("sprintoffset"));
	v13._inspecting = false;
	v13.quick = false;
	v13._destructor:add(u8.onParkouring:connect(function()
		if not v13:isEquipped() then
			return;
		end;
		if not v13:isMeleeing() then
			v13:playAnimation("parkour", true);
		end;
	end));
	return v13;
end;
function v1.Destroy(p4)
	p4._destructor:Destroy();
end;
function v1.getWeaponData(p5)
	return p5._weaponData;
end;
function v1.getWeaponStat(p6, p7)
	return p6._weaponData[p7];
end;
function v1.getWeaponType(p8)
	return "Melee";
end;
function v1.getWeaponModel(p9)
	return p9._weaponModel;
end;
function v1.getWeaponPart(p10, p11)
	return p10._weaponModel[p11];
end;
function v1.getMainPart(p12)
	return p12._mainPart;
end;
function v1.getDropInfo(p13)
	return p13._mainPart.Position;
end;
function v1.getTimePassedSinceStateChange(p14, p15, p16)
	return p16 - p14._stateChangeTimes[p15];
end;
function v1.getAnimation(p17, p18)
	return p17:getWeaponStat("animations")[p18];
end;
local u9 = shared.require("MenuUtils");
function v1.getAnimLength(p19, p20)
	local v26 = p19:getAnimation(p20);
	if not v26 then
		warn("MeleeObject: No animation found for", p20);
		return;
	end;
	return u9.getAnimationTime(v26);
end;
function v1.stateTimeCheck(p21, p22, p23, p24)
	return p21:isState(p22) and p23 < p21:getTimePassedSinceStateChange(p22, p24);
end;
function v1.animationStateCheck(p25, p26, p27, p28)
	return p25:stateTimeCheck(p26, p25:getAnimLength(p27), p28);
end;
function v1.isState(p29, p30)
	return p29._equipState:isState(p30) or p29._meleeState:isState(p30);
end;
function v1.isEquipped(p31)
	return p31._equipState:isState("equipped");
end;
function v1.isUnequipped(p32)
	return p32._equipState:isState("unequipped");
end;
function v1.isEquipping(p33)
	return p33._equipState:isState("equipping");
end;
function v1.isUnequipping(p34)
	return p34._equipState:isState("unequipping");
end;
function v1.isMeleeing(p35)
	return p35._meleeState:isState("meleeing") or p35._meleeState:isState("meleeCancelling");
end;
function v1.isInspecting(p36)
	return p36._inspecting;
end;
function v1.canMelee(p37)
	return p37:isEquipped() and p37:isState("meleeReady");
end;
local u10 = shared.require("GameClock");
local u11 = shared.require("WeaponControllerEvents");
function v1.setFlag(p38, p39, p40, ...)
	if not p40 then
		warn("FirearmObject: No currentTime was passed for setFlag", p39, ...);
		p40 = u10.getTime();
	end;
	u11.onControllerFlag:fire(p38, p39, p40, ...);
end;
function v1.equip(p41)
	p41:fireInput("equipStart", (u10.getTime()));
end;
function v1.unequip(p42)
	p42:fireInput("unequipStart", (u10.getTime()));
end;
local u12 = shared.require("animation");
function v1.playAnimation(p43, p44)
	if p43:isMeleeing() or not p43:isEquipped() then
		return;
	end;
	local v27 = p43:getWeaponStat("animations");
	local l___characterObject__28 = p43._characterObject;
	local l__thread__29 = l___characterObject__28.thread;
	l__thread__29:clear();
	if l___characterObject__28.animating then
		l__thread__29:add(u12.reset(p43._animData, 0.05));
	end;
	l___characterObject__28.animating = true;
	l___characterObject__28:getSpring("sprintspring").t = 0;
	if p44 == "inspect" then
		p43._inspecting = true;
	end;
	l__thread__29:add(u12.player(p43._animData, v27[p44]));
	l__thread__29:add(function()
		l__thread__29:add(u12.reset(p43._animData, v27[p44].resettime));
		l___characterObject__28.animating = false;
		l__thread__29:add(function()
			if l___characterObject__28:isSprinting() then
				l___characterObject__28:getSpring("sprintspring").t = 1;
			end;
			p43._inspecting = false;
		end);
	end);
end;
function v1.cancelAnimation(p45)
	local l___characterObject__30 = p45._characterObject;
	local l__thread__31 = l___characterObject__30.thread;
	l__thread__31:clear();
	l__thread__31:add(u12.reset(p45._animData, 0.2));
	l___characterObject__30.animating = false;
	l__thread__31:add(function()
		if l___characterObject__30:isSprinting() then
			l___characterObject__30:getSpring("sprintspring").t = 1;
		end;
	end);
end;
local u13 = shared.require("GameRoundInterface");
function v1.shoot(p46, p47)
	if u13.roundLock then
		return;
	end;
	if p46:isInspecting() then
		p46:cancelAnimation();
		p46._inspecting = false;
	end;
	if p46:isMeleeing() or not p46:isEquipped() then
		return;
	end;
	if p46.quick then
		local v32 = "quickstab";
	else
		v32 = p47 or "stab1";
	end;
	p46._activeStabType = v32;
	p46:fireInput("meleeStart", u10.getTime());
end;
local u14 = 2 * math.pi;
function v1.walkSway(p48, p49, p50)
	local l___characterObject__33 = p48._characterObject;
	local v34, v35, v36 = l___characterObject__33:getWalkValues();
	local v37 = p50 and 1;
	local v38 = v34 * u14 * 3 / 4;
	local v39 = -v36;
	local v40 = v35 * (1 - l___characterObject__33:getSpring("slidespring").p * 0.9);
	return CFrame.new(v37 * math.cos(v38 / 8 - 1) * v40 / 196, 1.25 * (p49 and 1) * math.sin(v38 / 4) * v40 / 512, 0) * u7.fromaxisangle(Vector3.new(v37 * math.sin(v38 / 4 - 1) / 256 + v37 * (math.sin(v38 / 64) - v37 * v39.z / 4) / 512, v37 * math.cos(v38 / 128) / 128 - v37 * math.cos(v38 / 8) / 256, v37 * math.sin(v38 / 8) / 128 + v37 * v39.x / 1024) * math.sqrt(v40 / 20) * u14);
end;
function v1.meleeSway(p51, p52)
	local v41 = u10.getTime() * 6;
	local v42 = 2 * (1.1 - p52);
	return CFrame.new(math.cos(v41 / 8) * v42 / 128, -math.sin(v41 / 4) * v42 / 128, math.sin(v41 / 16) * v42 / 64);
end;
function v1.fireInput(p53, p54, p55)
	if not p53._equipState:fireInput(p54, p55) then
		if not p53:isEquipped() then
			return;
		elseif p53._meleeState:fireInput(p54, p55) then
			return true;
		else
			return;
		end;
	end;
	if p54 == "unequipStart" and (p53:isState("meleeing") or p53:isState("meleeCancelling")) then
		p53._meleeState:setState("meleeReady", p55);
	end;
	return true;
end;
function v1.stepStatemachines(p56, p57)
	local v43 = u10.getTime();
	if p56.quick then
		local v44 = 0.05;
	else
		v44 = p56:getWeaponStat("equiptime") or (p56:getAnimation("equipping") and p56:getAnimLength("equipping") or 0.1);
	end;
	local v45 = p56:getWeaponStat("unequiptime") or (p56:getAnimation("unequipping") and p56:getAnimLength("unequipping") or 0.1);
	if p56:stateTimeCheck("equipping", v44, v43) then
		p56:setFlag("equipFlag", v43);
	elseif p56:stateTimeCheck("unequipping", v45, v43) then
		p56:setFlag("unequipFlag", v43);
	end;
	if p56:isState("meleeing") then
		if not p56._activeStabType then
			warn("MeleeObject: No activeStabType found");
		end;
		if p56:animationStateCheck("meleeing", p56._activeStabType, v43) then
			p56:fireInput("meleeFinish", v43);
			return;
		end;
	elseif p56:stateTimeCheck("meleeCancelling", 0.2, v43) then
		p56:fireInput("meleeCancelFinish", v43);
	end;
end;
local l__CurrentCamera__15 = workspace.CurrentCamera;
function v1.step(p58, p59)
	local l___characterObject__46 = p58._characterObject;
	local v47 = l___characterObject__46:getSpring("truespeedspring");
	local v48 = l___characterObject__46:getSpring("walkspeedspring");
	local v49 = l___characterObject__46:getSpring("sprintspring");
	if p58:isMeleeing() then
		local v50 = v5.getAllBodyParts();
		table.insert(v50, l__Map__12);
		local l__p__51 = p58._tipPart.CFrame.p;
		local v52 = p58._bladePart.CFrame.p - l__p__51;
		local l__Magnitude__53 = v52.Magnitude;
		for v54 = 0, l__Magnitude__53, 0.1 do
			local v55 = Ray.new(l__CurrentCamera__15.CFrame.p, l__p__51 + v54 / l__Magnitude__53 * v52 - l__CurrentCamera__15.CFrame.p);
			local v56, v57, v58 = workspace:FindPartOnRayWithWhitelist(v55, v50);
			if v56 then
				v4.knifeHitDetection(p58, p58._activeHitList, v56, v57, v58, v55, v54 == 0);
			end;
		end;
		v49.t = 0;
	end;
	local v59 = l___characterObject__46:getRootPart().CFrame:inverse() * v7.getActiveCamera("MainCamera"):getShakeCFrame() * p58._mainOffset * p58._animData[p58:getWeaponStat("mainpart")].weld.C0 * p58._proneCF(l___characterObject__46:getSpring("pronespring").p) * CFrame.new(0, 0, 1) * u7.fromaxisangle(l___characterObject__46:getSpring("swingspring").v) * CFrame.new(0, 0, -1) * p58:walkSway(0.7, 1) * p58:meleeSway(0) * p58._sprintCF(v47.p / v48.p * v49.p):Lerp(p58:getWeaponStat("equipoffset"), l___characterObject__46:getSpring("equipspring").p);
	p58._mainWeld.C0 = v59;
	p58._knifeWeld.C0 = p58._animData.knife.weld.C0;
	local v60, v61 = l___characterObject__46:getArmWelds();
	v60.C0 = v59 * p58._animData.larm.weld.C0:Lerp(p58:getWeaponStat("larmsprintoffset"), v47.p / v48.p * v49.p);
	v61.C0 = v59 * p58._animData.rarm.weld.C0:Lerp(p58:getWeaponStat("rarmsprintoffset"), v47.p / v48.p * v49.p);
	p58:stepStatemachines(p59);
end;
function v1._logStateTransition(p60, p61, p62, p63)
	p60._stateChangeTimes[p62] = p63;
end;
function v1._processEquipStateChange(p64, p65, p66, p67)
	local l___characterObject__62 = p64._characterObject;
	local l__thread__63 = l___characterObject__62.thread;
	if p66 == "equipped" then
		if p64.quick then
			local v64 = 2000;
		else
			v64 = 1000;
		end;
		p64._stabRate = v64;
		if l___characterObject__62:isSprinting() then
			l___characterObject__62:getSpring("sprintspring").t = 1;
		end;
		if p64._trailEffect then
			p64._trailEffect.Enabled = false;
		end;
		if p64:getWeaponStat("soundClassification") == "saber" then
			v10.play("saberLoop", 0.25, 1, p64._weaponModel, false, true);
		end;
		if p64.quick then
			p64:shoot();
			return;
		end;
	elseif p66 == "equipping" then
		l___characterObject__62:setBaseWalkSpeed(p64:getWeaponStat("walkspeed"));
		l___characterObject__62:getSpring("sprintspring").s = p64:getWeaponStat("sprintspeed");
		if p64._quick then
			l___characterObject__62:getSpring("equipspring").p = 0;
		end;
		if p64.quick then
			local v65 = 32;
		else
			v65 = 16;
		end;
		l___characterObject__62:getSpring("equipspring").s = v65;
		l___characterObject__62:getSpring("equipspring").t = 0;
		l__thread__63:clear();
		p64._inspecting = false;
		v10.play("equipCloth", 0.25);
		v10.play(p64:getWeaponStat("soundClassification") .. "Equip", 0.25);
		v9:send("equip", 3);
		v3.setCrossSettings(p64:getWeaponStat("type"), p64:getWeaponStat("crosssize"), p64:getWeaponStat("crossspeed"), p64:getWeaponStat("crossdamper"), p64._mainPart);
		v6.updateFiremode(p64);
		v6.updateAmmo(p64);
		l__thread__63:add(u12.reset(p64._animData, 0));
		l__thread__63:add(function()
			p64._weaponModel.Parent = l__CurrentCamera__15;
		end);
		return;
	else
		if p66 == "unequipped" then
			local v66 = p64._weaponModel:FindFirstChildOfClass("Sound");
			if v66 then
				v66:Stop();
			end;
			p64._weaponModel.Parent = nil;
			l___characterObject__62.animating = false;
			return;
		end;
		if p66 == "unequipping" then
			p64._inspecting = false;
			l___characterObject__62:getSpring("equipspring").t = 1;
			l__thread__63:add(u12.reset(p64._animData, 0.1));
		end;
	end;
end;
function v1._processMeleeStateChange(p68, p69, p70, p71)
	local v67 = p68:getWeaponStat("animations");
	local l___characterObject__68 = p68._characterObject;
	local l__thread__69 = l___characterObject__68.thread;
	local v70 = l___characterObject__68:getSpring("sprintspring");
	if p70 == "meleeReady" then
		if p69 == "meleeing" and (l___characterObject__68:isSprinting() or p68._activeStabType == "quickstab") then
			l__thread__69:add(function()
				if l___characterObject__68:isSprinting() then
					v70.t = 1;
				end;
			end);
		end;
		v70.s = p68:getWeaponStat("sprintspeed");
		if p68._trailEffect then
			p68._trailEffect.Enabled = false;
		end;
		p68._activeStabType = nil;
		return;
	end;
	if p70 == "meleeing" then
		local v71 = v67[p68._activeStabType];
		v70.t = 0;
		if p68.quick then
			v70.p = 0;
		end;
		p68._activeHitList = {};
		if p68._trailEffect then
			p68._trailEffect.Enabled = true;
		end;
		if l___characterObject__68.animating then
			l__thread__69:add(u12.reset(p68._animData, 0.1));
			l___characterObject__68.animating = false;
		end;
		v10.play(p68:getWeaponStat("soundClassification"), 0.25);
		v9:send("stab");
		l__thread__69:add(u12.player(p68._animData, v71, p68._weaponName));
		l__thread__69:add(function()
			l__thread__69:add(u12.reset(p68._animData, v71.resettime));
		end);
		if p68.quick then
			local u16 = false;
			task.delay(0.1, function()
				if v11.keyboard.down.f then
					u16 = true;
				end;
			end);
			p68.quick = false;
			l__thread__69:delay(0.2);
			l__thread__69:add(function()
				if u16 then
					return;
				end;
				p68:setFlag("firearmEquipFlag", p71);
			end);
			return;
		end;
	elseif p70 == "meleeCancelling" then

	end;
end;
function v1._weldKnife(p72)
	local l__CFrame__72 = p72._knifePart.CFrame;
	local l__MenuNodes__73 = p72._weaponModel:FindFirstChild("MenuNodes");
	local l__next__74 = next;
	local v75, v76 = p72._weaponModel:GetChildren();
	while true do
		local v77, v78 = l__next__74(v75, v76);
		if not v77 then
			break;
		end;
		v76 = v77;
		if v78:IsA("BasePart") then
			if v78 ~= p72._knifePart and v78 ~= p72._mainPart then
				local v79 = l__CFrame__72:ToObjectSpace(v78.CFrame);
				local v80 = Instance.new("Weld");
				v80.Part0 = p72._knifePart;
				v80.Part1 = v78;
				v80.C0 = v79;
				v80.Parent = p72._knifePart;
				p72._animData[v78.Name] = {
					part = v78, 
					weld = v80, 
					basec0 = v79, 
					basetransparency = v78.Transparency
				};
			end;
			local l__Trail__81 = v78:FindFirstChild("Trail");
			if l__Trail__81 and l__Trail__81:IsA("Trail") then
				p72._trailEffect = l__Trail__81;
				p72._trailEffect.Enabled = false;
			end;
			v78.Anchored = false;
			v78.CanCollide = false;
		end;	
	end;
	if p72._camoData and v2.getValue("togglefirstpersoncamo") then
		v8.textureModel(p72._weaponModel, p72._camoData);
	end;
	if l__MenuNodes__73 then
		l__MenuNodes__73:Destroy();
	end;
end;
return v1;

