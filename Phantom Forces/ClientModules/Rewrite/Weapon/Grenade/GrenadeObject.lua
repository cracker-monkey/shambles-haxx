
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("WeaponControllerEvents");
local v3 = shared.require("HudCrosshairsInterface");
local v4 = shared.require("CameraInterface");
local v5 = shared.require("Sequencer");
local v6 = shared.require("GameClock");
local v7 = shared.require("animation");
local v8 = shared.require("network");
local v9 = shared.require("input");
local u1 = shared.require("Destructor");
local u2 = shared.require("CharacterInterface");
local u3 = shared.require("ContentDatabase");
local u4 = shared.require("InstanceType");
local u5 = shared.require("EquipStateMachine");
local u6 = shared.require("ArmStateMachine");
local u7 = shared.require("WeaponUtils");
local u8 = shared.require("cframe");
local u9 = shared.require("HudStatusInterface");
local u10 = shared.require("CharacterEvents");
function v1.new(p1, p2, p3)
	local v10 = setmetatable({}, v1);
	v10._destructor = u1.new();
	v10.weaponIndex = p1;
	v10._characterObject = u2.getCharacterObject();
	v10._weaponName = p2;
	v10._weaponData = u3.getWeaponData(p2, u4.IsStudio());
	v10._equipState = u5.new();
	v10._armState = u6.new(v10);
	v10._stateChangeTimes = {};
	v10._destructor:add(v10._equipState.onStateTransition:connect(function(...)
		v10:_logStateTransition(...);
		v10:_processEquipStateChange(...);
	end));
	v10._destructor:add(v10._armState.onStateTransition:connect(function(...)
		v10:_logStateTransition(...);
		v10:_processArmStateChange(...);
	end));
	v10._weaponModel = u3.getWeaponModel(p2):Clone();
	v10._mainPart = v10:getWeaponPart(v10:getWeaponStat("mainpart"));
	v10._pinPart = v10:getWeaponPart(v10:getWeaponStat("pin"));
	v10._mainOffset = v10:getWeaponStat("mainoffset");
	v10._mainWeld = Instance.new("Motor6D");
	v10._mainWeld.Part0 = v10._characterObject:getRootPart();
	v10._mainWeld.Part1 = v10._mainPart;
	v10._mainWeld.Parent = v10._mainPart;
	v10._animData = v10:_weldModel();
	v10._animData[v10:getWeaponStat("mainpart")] = {
		weld = {
			C0 = CFrame.new()
		}, 
		basec0 = CFrame.new()
	};
	v10._animData.larm = {
		weld = {
			C0 = v10:getWeaponStat("larmoffset")
		}, 
		basec0 = v10:getWeaponStat("larmoffset")
	};
	v10._animData.rarm = {
		weld = {
			C0 = v10:getWeaponStat("rarmoffset")
		}, 
		basec0 = v10:getWeaponStat("rarmoffset")
	};
	v10._textureData = {};
	v10._transparencyData = {};
	v10._activeComponents = {};
	v10._weaponModel.MenuNodes:Destroy();
	u7.textureModel(v10._weaponModel, p3);
	local l__next__11 = next;
	local v12, v13 = v10._weaponModel:GetChildren();
	while true do
		local v14, v15 = l__next__11(v12, v13);
		if not v14 then
			break;
		end;
		v13 = v14;
		v15.Anchored = false;
		v15.Massless = true;
		v15.CanTouch = false;
		v15.CanCollide = false;
		v15.CastShadow = false;
		v10._textureData[v15] = {};
		v10._transparencyData[v15] = v15.Transparency;
		local l__next__16 = next;
		local v17, v18 = v15:GetChildren();
		while true do
			local v19, v20 = l__next__16(v17, v18);
			if not v19 then
				break;
			end;
			v18 = v19;
			if v20:IsA("Texture") or v20:IsA("Decal") then
				v10._textureData[v15][v20] = {
					Transparency = v20.Transparency
				};
			end;		
		end;	
	end;
	v10._animData.camodata = v10._textureData;
	v10._equipCF = v10:getWeaponStat("equipoffset");
	v10._sprintCF = u8.interpolator(v10:getWeaponStat("sprintoffset"));
	v10._proneCF = u8.interpolator(v10:getWeaponStat("proneoffset"));
	v10._spareCount = v10:getWeaponStat("spare");
	v10._isHidden = false;
	v10._cooking = false;
	v10._thrown = false;
	v10._bounceElasticity = 0.2;
	v10._frictionConstant = 0.08;
	v10._velocity = Vector3.new(0, 0, 0);
	v10._position = Vector3.new(0, 0, 0);
	v10._acceleration = Vector3.new(0, -80, 0);
	v10._t0 = 0;
	v10._fuseTime = 0;
	v10._lastBounce = false;
	v10._offset = Vector3.new(0, 0, 0);
	v10.quick = false;
	u9.updateAmmo(v10);
	v10._destructor:add(game:GetService("UserInputService").InputBegan:Connect(function(p4)
		if p4.KeyCode.Name == "P" then
			v10:_printStates();
		end;
	end));
	v10._destructor:add(u10.onDespawning:connect(function()
		if v10:isState("armed") and not v10._weaponData.nodeaddrop then
			v10:throwInstance(true);
		end;
	end));
	return v10;
end;
function v1.Destroy(p5)
	p5._destructor:Destroy();
end;
function v1.getWeaponData(p6)
	return p6._weaponData;
end;
function v1.getWeaponStat(p7, p8)
	return p7._weaponData[p8];
end;
function v1.getWeaponType(p9)
	return "Grenade";
end;
function v1.getWeaponModel(p10)
	return p10._weaponModel;
end;
function v1.getWeaponPart(p11, p12)
	return p11._weaponModel[p12];
end;
function v1.getMainPart(p13)
	return p13._mainPart;
end;
function v1.getDropInfo(p14)
	return p14._mainPart.Position;
end;
function v1.getTimePassedSinceStateChange(p15, p16, p17)
	return p17 - p15._stateChangeTimes[p16];
end;
function v1.getAnimation(p18, p19)
	return p18:getWeaponStat("animations")[p19];
end;
local u11 = shared.require("MenuUtils");
function v1.getAnimLength(p20, p21)
	local v21 = p20:getAnimation(p21);
	if not v21 then
		warn("GrenadeObject: No animation found for", p21);
	end;
	return u11.getAnimationTime(v21, true);
end;
function v1.getSpareCount(p22)
	return p22._spareCount;
end;
function v1.canUnequip(p23)
	return p23._cooking;
end;
function v1.canThrow(p24)
	local v22 = false;
	if p24._spareCount > 0 then
		v22 = p24:isState("armReady");
	end;
	return v22;
end;
function v1.canCancelThrow(p25)
	return false;
end;
function v1.stateTimeCheck(p26, p27, p28, p29)
	local v23 = p26:isState(p27) and p28 < p26:getTimePassedSinceStateChange(p27, p29);
	return v23;
end;
function v1.animationStateCheck(p30, p31, p32, p33)
	return p30:stateTimeCheck(p31, p30:getAnimLength(p32), p33);
end;
function v1.isEquipped(p34)
	return p34._equipState:isState("equipped");
end;
function v1.isUnequipped(p35)
	return p35._equipState:isState("unequipped");
end;
function v1.isEquipping(p36)
	return p36._equipState:isState("equipping");
end;
function v1.isUnequipping(p37)
	return p37._equipState:isState("unequipping");
end;
function v1.isState(p38, p39)
	return p38._equipState:isState(p39) or p38._armState:isState(p39);
end;
local u12 = 2 * math.pi;
function v1.walkSway(p40, p41, p42)
	local l___characterObject__24 = p40._characterObject;
	local v25, v26, v27 = l___characterObject__24:getWalkValues();
	local v28 = p42 and 1;
	local v29 = v25 * u12 * 3 / 4;
	local v30 = -v27;
	local v31 = v26 * (1 - l___characterObject__24:getSpring("slidespring").p * 0.9);
	return CFrame.new(v28 * math.cos(v29 / 8 - 1) * v31 / 196, 1.25 * (p41 and 1) * math.sin(v29 / 4) * v31 / 512, 0) * u8.fromaxisangle(Vector3.new(v28 * math.sin(v29 / 4 - 1) / 256 + v28 * (math.sin(v29 / 64) - v28 * v30.z / 4) / 512, v28 * math.cos(v29 / 128) / 128 - v28 * math.cos(v29 / 8) / 256, v28 * math.sin(v29 / 8) / 128 + v28 * v30.x / 1024) * math.sqrt(v31 / 20) * u12);
end;
function v1.modelSway(p43, p44)
	local v32 = v6.getTime() * 6;
	local v33 = 2 * (1.1 - p44);
	return CFrame.new(math.cos(v32 / 8) * v33 / 128, -math.sin(v32 / 4) * v33 / 128, math.sin(v32 / 16) * v33 / 64);
end;
function v1.setFlag(p45, p46, p47, ...)
	if not p47 then
		warn("GrenadeObject: No currentTime was passed for setFlag", p46, ...);
		p47 = v6.getTime();
	end;
	v2.onControllerFlag:fire(p45, p46, p47, ...);
end;
function v1.equip(p48)
	p48:fireInput("equipStart", (v6.getTime()));
end;
function v1.unequip(p49)
	p49:fireInput("unequipStart", (v6.getTime()));
end;
function v1.arm(p50)
	p50:fireInput("armStart", (v6.getTime()));
end;
function v1.throw(p51)
	p51:fireInput("throwStart", (v6.getTime()));
end;
function v1.throwInstance(p52, p53)
	if p52._thrown then
		return;
	end;
	p52._thrown = true;
	local v34 = v4.getActiveCamera("MainCamera");
	p52._spareCount = p52._spareCount - 1;
	local v35 = not p53 and (v34:getCFrame() * CFrame.Angles(math.rad(p52:getWeaponStat("throwangle") and 0), 0, 0)).lookVector * p52:getWeaponStat("throwspeed") + p52._characterObject:getRootPart().Velocity or p52._characterObject:getRootPart().Velocity;
	local l__p__36 = v34:getBaseCFrame().p;
	local v37, v38, v39 = workspace:FindPartOnRayWithWhitelist(Ray.new(l__p__36, p52._mainPart.CFrame.p - l__p__36), { workspace.Map });
	local v40 = v6.getTime();
	print(p52._fuseTime - v40);
	v8:send("newgrenade", v38 + 0.01 * v39, v35, v40, p52._fuseTime - v40);
	p52:hideModel();
	u9.updateAmmo(p52);
end;
function v1.hideModel(p54)
	if p54._isHidden then
		return;
	end;
	p54._isHidden = true;
	local l__next__41 = next;
	local v42, v43 = p54._weaponModel:GetChildren();
	while true do
		local v44, v45 = l__next__41(v42, v43);
		if not v44 then
			break;
		end;
		v43 = v44;
		if v45:IsA("BasePart") then
			v45.Transparency = 1;
		end;	
	end;
end;
function v1.showModel(p55)
	if not p55._isHidden then
		return;
	end;
	p55._isHidden = false;
	local l__next__46 = next;
	local v47, v48 = p55._weaponModel:GetChildren();
	while true do
		local v49, v50 = l__next__46(v47, v48);
		if not v49 then
			break;
		end;
		v48 = v49;
		if v50:IsA("BasePart") then
			v50.Transparency = p55._transparencyData[v50];
		end;	
	end;
end;
function v1.fireInput(p56, p57, p58)
	if not p56._equipState:fireInput(p57, p58) then
		if not p56:isEquipped() then
			return;
		elseif p56._armState:fireInput(p57, p58) then
			return true;
		else
			return;
		end;
	end;
	if p56:isState("unequipped") and not p56:isState("armReady") then
		p56:showModel();
		p56._armState:setState("armReady", p58);
	end;
	return true;
end;
function v1.stepStatemachines(p59, p60)
	local v51 = v6.getTime();
	if p59.quick then
		local v52 = 0.05;
	else
		v52 = p59:getWeaponStat("equiptime") or (p59:getAnimation("equipping") and p59:getAnimLength("equipping") or 0.1);
	end;
	local v53 = p59:getWeaponStat("unequiptime") or (p59:getAnimation("unequipping") and p59:getAnimLength("unequipping") or 0.1);
	if p59:stateTimeCheck("equipping", v52, v51) then
		p59:setFlag("equipFlag", v51);
	elseif p59:stateTimeCheck("unequipping", v53, v51) then
		p59:setFlag("unequipFlag", v51);
	end;
	if p59:animationStateCheck("arming", "pull", v51) then
		p59:fireInput("armFinish", v51);
		return;
	end;
	if p59:animationStateCheck("throwing", "throw", v51) then
		p59:fireInput("throwFinish", v51);
		return;
	end;
	if p59:stateTimeCheck("thrown", 0.1, v51) then
		p59:fireInput("reload", v51);
	end;
end;
function v1.step(p61, p62)
	local v54 = v6.getTime();
	local l___characterObject__55 = p61._characterObject;
	local v56 = l___characterObject__55:getRootPart().CFrame:inverse() * v4.getActiveCamera("MainCamera"):getShakeCFrame() * p61._mainOffset * p61._animData[p61:getWeaponStat("mainpart")].weld.C0 * p61._proneCF(l___characterObject__55:getSpring("pronespring").p) * CFrame.new(0, 0, 1) * u8.fromaxisangle(l___characterObject__55:getSpring("swingspring").v) * CFrame.new(0, 0, -1) * p61:walkSway(0.7, 1) * p61:modelSway(0) * p61._sprintCF(l___characterObject__55:getSpring("truespeedspring").p / l___characterObject__55:getSpring("walkspeedspring").p * l___characterObject__55:getSpring("sprintspring").p):Lerp(p61:getWeaponStat("equipoffset"), l___characterObject__55:getSpring("equipspring").p);
	p61._mainWeld.C0 = v56;
	local v57, v58 = l___characterObject__55:getArmWelds();
	v57.C0 = v56 * p61._animData.larm.weld.C0;
	v58.C0 = v56 * p61._animData.rarm.weld.C0;
	if p61:isState("armed") then
		if p61._fuseTime < v54 then
			p61:throwInstance(true);
			p61:fireInput("throwStart", v54);
			p61:fireInput("throwFinish", v54);
		elseif not v9.keyboard.down.g then
			p61:throw();
		elseif (p61._fuseTime - v54) % 1 < p62 then
			v3.fireImpulse(p61:getWeaponStat("crossexpansion"));
		end;
	end;
	p61:stepStatemachines(p62);
end;
function v1._logStateTransition(p63, p64, p65, p66)
	p63._stateChangeTimes[p65] = p66;
end;
local l__CurrentCamera__13 = workspace.CurrentCamera;
function v1._processEquipStateChange(p67, p68, p69, p70)
	local l___characterObject__59 = p67._characterObject;
	local l__thread__60 = l___characterObject__59.thread;
	if p69 ~= "equipped" then
		if p69 == "equipping" then
			l__thread__60:clear();
			p67._weaponModel.Parent = l__CurrentCamera__13;
			l__thread__60:add(v7.reset(p67._animData, 0));
			u9.updateFiremode(p67);
			u9.updateAmmo(p67);
			return;
		elseif p69 == "unequipped" then
			p67._weaponModel.Parent = nil;
			l___characterObject__59.animating = false;
			return;
		else
			if p69 == "unequipping" then
				l___characterObject__59:getSpring("equipspring").t = 1;
			end;
			return;
		end;
	end;
	l___characterObject__59:setBaseWalkSpeed(p67:getWeaponStat("walkspeed"));
	l___characterObject__59:getSpring("equipspring").t = 0;
	local l__next__61 = next;
	local v62, v63 = p67._mainPart:GetChildren();
	while true do
		local v64, v65 = l__next__61(v62, v63);
		if not v64 then
			break;
		end;
		v63 = v64;
		if v65:IsA("Weld") and (not v65.Part1 or v65.Part1.Parent ~= p67._weaponModel) then
			v65:Destroy();
		end;	
	end;
	if p67.quick then
		p67:arm();
	end;
	p67._thrown = false;
end;
function v1._processArmStateChange(p71, p72, p73, p74)
	local l___characterObject__66 = p71._characterObject;
	local l__thread__67 = l___characterObject__66.thread;
	if p73 == "armReady" then
		if l___characterObject__66:isSprinting() then
			l___characterObject__66:getSpring("sprintspring").t = 0;
			return;
		end;
	else
		if p73 == "arming" then
			if l___characterObject__66.animating then
				l__thread__67:add(v7.reset(p71._animData, 0.1));
				l___characterObject__66.animating = false;
			end;
			l__thread__67:add(v7.player(p71._animData, p71:getWeaponStat("animations").pull, p71._weaponName));
			v3.setCrossHairType("Dot");
			return;
		end;
		if p73 == "armed" then
			p71._fuseTime = p74 + p71:getWeaponStat("fusetime");
			v3.setCrossHairType("Cross");
			v3.setCrossSettings(p71:getWeaponStat("type"), p71:getWeaponStat("crosssize"), p71:getWeaponStat("crossspeed"), p71:getWeaponStat("crossdamper"), p71._mainPart);
			return;
		end;
		if p73 == "throwing" then
			l___characterObject__66:getSpring("sprintspring").t = 0;
			l__thread__67:add(v7.player(p71._animData, p71:getWeaponStat("animations").throw, p71._weaponName));
			return;
		end;
		if p73 == "thrown" then
			if p71.quick then
				p71.quick = false;
				p71:setFlag("lastEquipFlag", p74);
				return;
			end;
		elseif p73 == "armCancelling" then
			l__thread__67:add(v7.reset(p71._animData, 0.1));
		end;
	end;
end;
function v1._weldModel(p75)
	local v68 = {};
	local l__CFrame__69 = p75._mainPart.CFrame;
	local l__next__70 = next;
	local v71, v72 = p75._weaponModel:GetChildren();
	while true do
		local v73, v74 = l__next__70(v71, v72);
		if not v73 then
			break;
		end;
		v72 = v73;
		if v74 ~= p75._mainPart and v74:IsA("BasePart") then
			local l__Name__75 = v74.Name;
			if p75:getWeaponStat("removeparts") and p75:getWeaponStat("removeparts")[l__Name__75] then
				v74:Destroy();
			else
				if p75:getWeaponStat("transparencymod") and p75:getWeaponStat("transparencymod")[l__Name__75] then
					v74.Transparency = p75:getWeaponStat("transparencymod")[l__Name__75];
				end;
				if p75:getWeaponStat("weldexception") and p75:getWeaponStat("weldexception")[l__Name__75] and p75._weaponModel:FindFirstChild(p75:getWeaponStat("weldexception")[l__Name__75]) then
					local v76 = p75._weaponModel[p75:getWeaponStat("weldexception")[l__Name__75]];
					local v77 = v76.CFrame:ToObjectSpace(v74.CFrame);
					local v78 = Instance.new("Weld");
					v78.Part0 = v76;
					v78.Part1 = v74;
					v78.C0 = v77;
					v78.Parent = p75._mainPart;
					v74.CFrame = l__CFrame__69 * v77;
					v68[l__Name__75] = {
						part = v74, 
						weld = v78, 
						basec0 = v77, 
						basetransparency = v74.Transparency
					};
				else
					local v79 = l__CFrame__69:ToObjectSpace(v74.CFrame);
					local v80 = Instance.new("Weld");
					v80.Part0 = p75._mainPart;
					v80.Part1 = v74;
					v80.C0 = v79;
					v80.Parent = p75._mainPart;
					v74.CFrame = l__CFrame__69 * v79;
					v68[l__Name__75] = {
						part = v74, 
						weld = v80, 
						basec0 = v79, 
						basetransparency = v74.Transparency
					};
				end;
			end;
		end;	
	end;
	return v68;
end;
function v1._printStates(p76)
	print("GrenadeObject: ", p76._weaponName, "Equipped state:", p76._equipState:getState());
	print("GrenadeObject: ", p76._weaponName, "Arm state:", p76._armState:getState());
end;
return v1;

