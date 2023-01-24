
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("HudNotificationInterface");
local v3 = shared.require("HudCrosshairsInterface");
local v4 = shared.require("WeaponControllerEvents");
local v5 = shared.require("HitDetectionInterface");
local v6 = shared.require("SamplePointGenerator");
local v7 = shared.require("HudSpottingInterface");
local v8 = shared.require("RecoilSpringLayers");
local v9 = shared.require("HudStatusInterface");
local v10 = shared.require("GameRoundInterface");
local v11 = shared.require("HudScopeInterface");
local v12 = shared.require("CharacterEvents");
local v13 = shared.require("CameraInterface");
local v14 = shared.require("FirearmTracker");
local v15 = shared.require("PublicSettings");
local v16 = shared.require("Sequencer");
local v17 = shared.require("GameClock");
local v18 = shared.require("animation");
local v19 = shared.require("MenuUtils");
local v20 = shared.require("InputType");
local v21 = shared.require("particle");
local v22 = shared.require("network");
local v23 = shared.require("effects");
local v24 = shared.require("spring");
local v25 = shared.require("sound");
local v26 = shared.require("input");
local v27 = shared.require("InstanceType");
local l__LocalPlayer__28 = game:GetService("Players").LocalPlayer;
local u1 = shared.require("Destructor");
local u2 = shared.require("CharacterInterface");
local u3 = shared.require("ModifyData");
local u4 = shared.require("ContentDatabase");
local u5 = shared.require("EquipStateMachine");
local u6 = shared.require("ChamberStateMachine");
local u7 = shared.require("WeaponUtils");
local u8 = shared.require("FirearmLaser");
local u9 = shared.require("FirearmStats");
local u10 = shared.require("FirearmSight");
local u11 = shared.require("PlayerSettingsInterface");
local u12 = shared.require("cframe");
local u13 = math.pi / 180;
function v1.new(p1, p2, p3, p4, p5, p6, p7)
	local v29 = setmetatable({}, v1);
	v29._destructor = u1.new();
	v29.weaponIndex = p1;
	v29._characterObject = u2.getCharacterObject();
	local v30 = u3.getModifiedData(u4.getWeaponData(p2, true), p3, p4);
	v29._weaponName = p2;
	v29._weaponData = v30;
	v29._weaponAttachments = p3;
	v29._magCount = math.ceil(p6 or v29:getWeaponStat("magsize"));
	v29._spareCount = math.ceil(p7 or v29:getWeaponStat("sparerounds"));
	v29._aiming = false;
	v29._isHidden = false;
	v29._boltOpen = false;
	v29._bolting = false;
	v29._inspecting = false;
	v29._blackScoped = false;
	v29._needRechambering = false;
	v29._wasSprinting = false;
	v29._wasBlackScoped = false;
	v29._equipState = u5.new();
	v29._chamberState = u6.new(v29);
	v29._stateChangeTimes = {};
	v29._destructor:add(v29._equipState.onStateTransition:connect(function(...)
		v29:_logStateTransition(...);
		v29:_processEquipStateChange(...);
	end));
	v29._destructor:add(v29._chamberState.onStateTransition:connect(function(...)
		v29:_logStateTransition(...);
		v29:_processChamberStateChange(...);
	end));
	local v31 = "ReloadMag";
	if v29:getWeaponStat("type") == "SHOTGUN" and not v29:getWeaponStat("magfeed") then
		v31 = "ReloadSingle";
	elseif v29:getWeaponStat("uniquereload") then
		v31 = "ReloadStaged";
	end;
	v29._reloadSequenceFunc = shared.require(v31);
	v29._activeReloadSequence = nil;
	local v32, v33 = u7.constructWeapon(p2, v30, p3, p5, p4);
	v29._animData = v33;
	v29._weaponModel = v32;
	v29._mainPart = v29:getWeaponPart(v29:getWeaponStat("mainpart"));
	v29._barrelPart = v29:getWeaponPart(v29:getWeaponStat("barrel"));
	v29._destructor:add(v29._weaponModel);
	v29._camoList = p5;
	v29._textureData = {};
	v29._transparencyData = {};
	v29._activeComponents = {};
	v29._weaponModel.MenuNodes:Destroy();
	local l__next__34 = next;
	local v35, v36 = v29._weaponModel:GetChildren();
	while true do
		local v37, v38 = l__next__34(v35, v36);
		if not v37 then
			break;
		end;
		v29._textureData[v38] = {};
		v29._transparencyData[v38] = v38.Transparency;
		local l__next__39 = next;
		local v40, v41 = v38:GetChildren();
		while true do
			local v42, v43 = l__next__39(v40, v41);
			if not v42 then
				break;
			end;
			v41 = v42;
			if v43:IsA("Texture") or v43:IsA("Decal") then
				v29._textureData[v38][v43] = {
					Transparency = v43.Transparency
				};
			end;		
		end;
		if v38.Name == "LaserLight" then
			local v44 = u8.new(v29, v38);
			v29._destructor:add(v44);
			table.insert(v29._activeComponents, v44);
		end;	
	end;
	v29._animData.camodata = v29._textureData;
	v29._activeAimStats = {};
	v29._activeAimStatIndex = 1;
	local v45 = u9.new(v29);
	table.insert(v29._activeAimStats, v45);
	if v45.midscope or v45.blackscope then
		local v46 = u10.new(v29, v45);
		v29._destructor:add(v46);
		table.insert(v29._activeComponents, v46);
	end;
	if v29:getWeaponStat("altaimdata") then
		local l__next__47 = next;
		local v48, v49 = v29:getWeaponStat("altaimdata");
		while true do
			local v50, v51 = l__next__47(v48, v49);
			if not v50 then
				break;
			end;
			v49 = v50;
			local v52 = u9.new(v29, v51);
			if v52.midscope or v52.blackscope then
				local v53 = u10.new(v29, v52);
				v29._destructor:add(v53);
				table.insert(v29._activeComponents, v53);
			end;
			table.insert(v29._activeAimStats, v52);		
		end;
	end;
	v29._mainOffset = v29:getWeaponStat("mainoffset");
	v29._yieldToAnimation = false;
	v29._mainWeld = Instance.new("Motor6D");
	v29._animData[v29:getWeaponStat("mainpart")] = {
		part = v29._mainPart, 
		basec0 = CFrame.new(), 
		basetransparency = v29._mainPart.Transparency, 
		weld = {
			C0 = CFrame.new()
		}
	};
	v29._animData.larm = {
		basec0 = v29:getWeaponStat("larmoffset"), 
		weld = {
			C0 = v29:getWeaponStat("larmoffset")
		}
	};
	v29._animData.rarm = {
		basec0 = v29:getWeaponStat("rarmoffset"), 
		weld = {
			C0 = v29:getWeaponStat("rarmoffset")
		}
	};
	local v54 = u11.getValue("toggledynamicstance");
	v29._sprintCF = u12.interpolator(v29:getWeaponStat("sprintoffset"));
	v29._climbCF = u12.interpolator(v29:getWeaponStat("climboffset") or CFrame.new(-0.9, -1.48, 0.43) * CFrame.Angles(-0.5, 0.3, 0));
	v29._crouchCF = u12.interpolator(not v54 and CFrame.new() or (v29:getWeaponStat("crouchoffset") or CFrame.new(-0.45, 0.1, 0.1) * CFrame.Angles(0, 0, 30 * u13)));
	v29._proneCF = u12.interpolator(not v54 and CFrame.new() or (v29:getWeaponStat("proneoffset") or CFrame.new(-0.3, 0.25, 0.2) * CFrame.Angles(0, 0, 10 * u13)));
	v29._boltCF = u12.interpolator(v29._animData[v29:getWeaponStat("bolt")].basec0, v29._animData[v29:getWeaponStat("bolt")].basec0 * v29:getWeaponStat("boltoffset"));
	v29._burst = 0;
	v29._nShots = 0;
	v29._auto = false;
	v29._nextShot = 0;
	v29._fireCount = 0;
	v29._disableUntil = 0;
	v29._firemodeIndex = 1;
	v29._steadyToggle = false;
	v29._firemodeStability = 0;
	v29._samplePointGenerator = v6.new(2);
	v29._reloadCancelTime = v29:getWeaponStat("reloadcanceltime") and 0.2;
	local v55 = v29:getWeaponStat("animationmods");
	if v55 then
		for v56, v57 in next, v55 do
			for v58, v59 in next, v57 do
				v29._weaponData.animations[v56][v58] = v59;
			end;
		end;
	end;
	v29._reloadspring = v24.new(0);
	v29._reloadspring.s = 12;
	v29._rotkickspring = v24.new(Vector3.new());
	v29._rotkickspring.s = v29:getWeaponStat("modelkickspeed");
	v29._rotkickspring.d = v29:getWeaponStat("modelkickdamper");
	v29._transkickspring = v24.new(Vector3.new());
	v29._transkickspring.s = v29:getWeaponStat("modelkickspeed");
	v29._transkickspring.d = v29:getWeaponStat("modelkickdamper");
	v29._spreadspring = v24.new(Vector3.new());
	v29._spreadspring.s = v29:getWeaponStat("hipfirespreadrecover");
	v29._spreadspring.d = v29:getWeaponStat("hipfirestability") and 0.7;
	v29._armaimspring = v24.new();
	v29._armaimspring.s = 16;
	v29._armaimspring.d = 0.95;
	v29._sprintposespring = v24.new();
	v29._sprintposespring.s = 40;
	v29._sprintposespring.d = 0.8;
	v29.thread2 = v16.new();
	for v60, v61 in next, p3 do
		if v61 == "Ballistics Tracker" then
			local v62 = v14.new(v29);
			v29._destructor:add(v62);
			table.insert(v29._activeComponents, v62);
		end;
	end;
	if v29._weaponData.recoilParameters then
		v29._experimentalRecoil = true;
		local l__recoilParameters__63 = v29._weaponData.recoilParameters;
		v29._recoilParameters = l__recoilParameters__63;
		v29._translationRecoil = v8.new(l__recoilParameters__63.hipTranslation, l__recoilParameters__63.aimTranslation, l__recoilParameters__63.hipTranslationRecovery, l__recoilParameters__63.aimTranslationRecovery);
		v29._rotationRecoil = v8.new(l__recoilParameters__63.hipRotation, l__recoilParameters__63.aimRotation, l__recoilParameters__63.hipRotationRecovery, l__recoilParameters__63.aimRotationRecovery);
	end;
	v29._destructor:add(v12.onMovementChanged:connect(function(p8)
		if not v29:isEquipped() then
			return;
		end;
		v29:updateStance(p8);
	end));
	v29._destructor:add(v12.onSprintChanged:connect(function(p9)
		if not v29:isEquipped() then
			return;
		end;
		if p9 then
			v29._auto = false;
			if v29:isAiming() then
				v29:setAim(false);
				return;
			end;
		elseif not p9 and not v29:isAiming() and (v26.mouse.down.right or v26.controller.down.l2) then
			v29:setAim(true);
		end;
	end));
	v29._destructor:add(v12.onParkouring:connect(function()
		if not v29:isEquipped() then
			return;
		end;
		if v29._characterObject:isSprinting() and u11.getValue("togglesprinttoggle") then
			v29._wasSprinting = true;
		end;
		if not v29:isAnimationReloading() then
			v29:playAnimation("parkour");
		end;
	end));
	v29._destructor:add(function()
		if v29:getWeaponStat("effectsettings") then
			v23:applyeffects(v29:getWeaponStat("effectsettings"), false);
		end;
	end);
	v29:updateAimStats();
	v29._destructor:add(game:GetService("UserInputService").InputBegan:Connect(function(p10)
		if p10.KeyCode.Name == "P" then
			v29:_printStates();
		end;
	end));
	return v29;
end;
function v1.Destroy(p11)
	p11._destructor:Destroy();
end;
function v1.getWeaponData(p12)
	return p12._weaponData;
end;
function v1.getWeaponStat(p13, p14)
	return p13._weaponData[p14];
end;
function v1.getWeaponType(p15)
	return "Firearm";
end;
function v1.getWeaponModel(p16)
	return p16._weaponModel;
end;
function v1.getWeaponPart(p17, p18)
	if not p17._weaponModel:FindFirstChild(p18) then
		v22:send("debug", string.format("No part %s found on %s %s", p18, p17._weaponName, tostring(p17._weaponModel.Parent)));
		warn(string.format("No part %s found on %s", p18, p17._weaponName));
	end;
	return p17._weaponModel[p18];
end;
function v1.getMainPart(p19)
	return p19._mainPart;
end;
function v1.getActiveAimStats(p20)
	return p20._activeAimStats;
end;
function v1.getActiveAimStat(p21, p22)
	return p21._activeAimStats[p21._activeAimStatIndex][p22];
end;
function v1.getMagCount(p23)
	return p23._magCount;
end;
function v1.getSpareCount(p24)
	return p24._spareCount;
end;
function v1.getFiremode(p25)
	return p25:getWeaponStat("firemodes")[p25._firemodeIndex];
end;
function v1.getFirerate(p26)
	return p26:getActiveAimStat("variablefirerate") and p26:getActiveAimStat("firerate")[p26._firemodeIndex] or p26:getActiveAimStat("firerate");
end;
function v1.getDropInfo(p27)
	return p27._magCount, p27._spareCount, p27._mainPart.Position;
end;
function v1.getTimePassedSinceStateChange(p28, p29, p30)
	return p30 - p28._stateChangeTimes[p29];
end;
function v1.getAnimation(p31, p32)
	return p31:getWeaponStat("animations")[p32];
end;
function v1.getAnimLength(p33, p34)
	local v64 = p33:getAnimation(p34);
	if not v64 then
		return 0;
	end;
	return v19.getAnimationTime(v64, true);
end;
function v1.getCurrentReloadFile(p35)
	if not p35._activeReloadSequence then
		return;
	end;
	return p35._activeReloadSequence[1];
end;
function v1.getCurrentReloadLength(p36)
	local v65 = p36:getCurrentReloadFile();
	if not v65 then
		return;
	end;
	return p36:getAnimLength(v65.reloadName);
end;
function v1.isState(p37, p38)
	return p37._equipState:isState(p38) or p37._chamberState:isState(p38);
end;
function v1.isSteadyState(p39)
	return p39:isEquipped() and (p39:isState("chambered") or p39:isState("unchambered"));
end;
function v1.isEquipped(p40)
	return p40._equipState:isState("equipped");
end;
function v1.isUnequipped(p41)
	return p41._equipState:isState("unequipped");
end;
function v1.isEquipping(p42)
	return p42._equipState:isState("equipping");
end;
function v1.isUnequipping(p43)
	return p43._equipState:isState("unequipping");
end;
function v1.isStateReloading(p44)
	return p44._chamberState:isState("chamberedReloading") or p44._chamberState:isState("unchamberedReloading");
end;
function v1.isAnimationReloading(p45)
	return p45:isStateReloading() or (p45._characterObject.reloading or p45._yieldToAnimation);
end;
function v1.isReloadingCancelling(p46)
	return p46._chamberState:isState("chamberedReloadCancelling") or (p46._chamberState:isState("unchamberedReloadCancelling") or (p46._chamberState:isState("chamberedReloadCancelResetting") or p46._chamberState:isState("unchamberedReloadCancelResetting")));
end;
function v1.isChambering(p47)
	return p47._chamberState:isState("chambering") or p47._chamberState:isState("chamberCancelling");
end;
function v1.isAiming(p48)
	return p48._aiming;
end;
function v1.isInspecting(p49)
	return p49._inspecting;
end;
function v1.isBlackScope(p50)
	return p50._blackScoped;
end;
function v1.isLastReloadSequence(p51)
	if not p51._activeReloadSequence then
		return;
	end;
	if #p51._activeReloadSequence ~= 1 then
		return;
	end;
	return p51._activeReloadSequence[1].repetitionCount == 1;
end;
function v1.canUnequip(p52)
	return true;
end;
function v1.canReload(p53)
	local v66 = p53:isEquipped();
	if v66 then
		v66 = not p53:isAnimationReloading();
		if v66 then
			v66 = false;
			if p53:getSpareCount() > 0 then
				if p53:getWeaponStat("chamber") then
					local v67 = 1;
				else
					v67 = 0;
				end;
				v66 = p53:getMagCount() < p53:getWeaponStat("magsize") + v67;
			end;
		end;
	end;
	return v66;
end;
function v1.canFire(p54)
	if v17.getTime() < p54._nextShot or not p54:isEquipped() or v10.roundLock then
		return false;
	end;
	if not p54:isState("chambered") and (not p54:isState("chamberedReloading") or not p54._canShoot) then
		return;
	end;
	if p54:getWeaponStat("burstcam") and p54:getFiremode() ~= true then
		return p54._auto and p54._burst > 0;
	end;
	return p54._auto or p54._burst > 0;
end;
function v1.stateTimeCheck(p55, p56, p57, p58)
	return p55:isState(p56) and p57 < p55:getTimePassedSinceStateChange(p56, p58);
end;
function v1.animationStateCheck(p59, p60, p61, p62)
	return p59:stateTimeCheck(p60, p59:getAnimLength(p61), p62);
end;
function v1.setFlag(p63, p64, p65, ...)
	if not p65 then
		warn("FirearmObject: No currentTime was passed for setFlag", p64, ...);
		p65 = v17.getTime();
	end;
	v4.onControllerFlag:fire(p63, p64, p65, ...);
end;
function v1.setAim(p66, p67)
	local v68 = v13.getActiveCamera("MainCamera");
	local l___characterObject__69 = p66._characterObject;
	if p66:isStateReloading() or p66:getWeaponStat("forcehip") then
		return;
	end;
	if p66:isInspecting() then
		p66._inspecting = false;
		p66:cancelAnimation(p66._reloadCancelTime);
	end;
	if p67 and not p66._aiming then
		if (not (not p66._chamberState:isState("unchambered")) or not (not p66:isChambering()) or p66._bolting) and not p66:getWeaponStat("straightpull") and p66:getActiveAimStat("blackscope") then
			return;
		end;
		if p66:getWeaponStat("proneonly") then
			if l___characterObject__69:getMovementMode() == "stand" then
				return;
			end;
			if l___characterObject__69:getSpring("pronespring").p < 0.5 then
				return;
			end;
		end;
		if p66:getWeaponStat("restrictedads") then
			local v70 = false;
			if l___characterObject__69:getMovementMode() == "stand" and l___characterObject__69:parkourDetection() then
				v70 = true;
			end;
			if not v70 and math.max(l___characterObject__69:getSpring("crouchspring").p, l___characterObject__69:getSpring("pronespring").p) > 0.5 then
				v70 = true;
			end;
			if not v70 then
				return;
			end;
		end;
		p66._aiming = true;
		v22:send("aim", true);
		v25.play("aimGear", 0.15);
		if p66._experimentalRecoil then
			p66._translationRecoil:setAim(true);
			p66._rotationRecoil:setAim(true);
			v68:setAim(true);
		end;
		if l___characterObject__69:isSprinting() then
			if u11.getValue("togglesprinttoggle") then
				p66._wasSprinting = true;
			end;
			l___characterObject__69:setSprint(false);
		end;
		l___characterObject__69.sprintdisable = p66:getActiveAimStat("blackscope");
		l___characterObject__69:setWalkSpeedMult(p66:getActiveAimStat("aimwalkspeedmult"));
		l___characterObject__69:getSpring("aimspring").t = 1;
		v68:getSpring("shakespring").s = p66:getActiveAimStat("aimcamkickspeed");
		v68:setAimSensitivity(true);
		if p66._yieldToAnimation and p66:getActiveAimStat("zoompullout") then
			local v71 = 0;
		else
			v71 = 1;
		end;
		p66._armaimspring.t = v71;
		p66:updateAimStats();
		if p66._yieldToAnimation and p66:getActiveAimStat("zoompullout") and p66:getActiveAimStat("aimspringcancel") then
			local v72 = 0;
		elseif p66._yieldToAnimation and p66:getActiveAimStat("zoompullout") and not p66:getActiveAimStat("blackscope") then
			v72 = 0.5;
		else
			v72 = 1;
		end;
		l___characterObject__69:getSpring("zoommodspring").t = v72;
		v3.setCrossSize(0);
	elseif not p67 and p66._aiming then
		if p66._aiming and p66:getActiveAimStat("blackscope") then
			p66.thread2:clear();
		end;
		p66._aiming = false;
		p66._armaimspring.t = 0;
		p66:updateAimStats();
		if p66._experimentalRecoil then
			p66._translationRecoil:setAim(false);
			p66._rotationRecoil:setAim(false);
			v68:setAim(false);
		end;
		v25.play("aimCloth", 0.15);
		v22:send("aim", false);
		l___characterObject__69.sprintdisable = false;
		l___characterObject__69:getSpring("zoommodspring").t = 0;
		l___characterObject__69:getSpring("aimspring").t = 0;
		l___characterObject__69:setWalkSpeedMult(1);
		if not p66._wasBlackScoped then
			l___characterObject__69:setSprint(v26.keyboard.down.leftshift or (v26.keyboard.down.w and l___characterObject__69.doubletap or p66._wasSprinting));
		end;
		p66._wasSprinting = false;
		v68:getSpring("shakespring").s = p66:getWeaponStat("camkickspeed");
		v68:setAimSensitivity(false);
		p66.thread2:add(function()
			if p66._magCount == 0 and p66._spareCount > 0 and not p66:isAnimationReloading() then
				p66:reload();
			end;
		end);
		v3.setCrossSize(p66:getWeaponStat("crosssize"));
	end;
	l___characterObject__69:updateWalkSpeed();
end;
function v1.setReloadSequence(p68)
	p68._activeReloadSequence = p68:_reloadSequenceFunc();
	for v73 = #p68._activeReloadSequence, 1, -1 do
		if p68._activeReloadSequence[v73].repetitionCount <= 0 then
			table.remove(p68._activeReloadSequence, v73);
		end;
	end;
end;
function v1.popReloadSequence(p69)
	local l___characterObject__74 = p69._characterObject;
	if not p69._activeReloadSequence then
		warn("FirearmObject: No activeReloadSequence found on popReloadSequence");
		return;
	end;
	local v75 = p69._activeReloadSequence[1];
	local l__reloadName__76 = v75.reloadName;
	if not v75 then
		warn("FirearmObject: No reloadFile found on popReloadSequence");
		return;
	end;
	if not p69:getWeaponStat("animations")[l__reloadName__76] then
		warn("FirearmObject: No animationFile found on popReloadSequence", l__reloadName__76);
		v22:send("debug", string.format("FirearmObject: No animationFile found on popReloadSequence %s %s", p69._weaponName, l__reloadName__76));
	end;
	p69:applyReloadCount(v75.magCountChange);
	if p69:getSpareCount() > 0 and v75.repetitionCount > 1 then
		v75.repetitionCount = v75.repetitionCount - 1;
	else
		table.remove(p69._activeReloadSequence, 1);
	end;
	if #p69._activeReloadSequence <= 0 then
		p69._activeReloadSequence = nil;
		l___characterObject__74.thread:add(function()
			p69._canShoot = true;
			l___characterObject__74.thread:add(v18.reset(p69._animData, p69:getWeaponStat("animations")[l__reloadName__76].resettime and 0.5));
			l___characterObject__74.thread:add(function()
				l___characterObject__74.animating = false;
				l___characterObject__74.reloading = false;
				p69._canShoot = false;
				p69._reloadspring.t = 0;
				if l___characterObject__74:isSprinting() then
					l___characterObject__74:getSpring("sprintspring").t = 1;
				end;
			end);
		end);
	end;
	v22:send("reload");
	v9.updateAmmo(p69);
end;
function v1.applyReloadCount(p70, p71)
	if p70:getWeaponStat("chamber") then
		local v77 = 1;
	else
		v77 = 0;
	end;
	local v78 = p70:getWeaponStat("magsize") + v77 - p70._magCount;
	local v79 = p71 < v78 and p71 or v78;
	if not (v79 < p70._spareCount) then
		p70._magCount = p70._magCount + p70._spareCount;
		p70._spareCount = 0;
		return;
	end;
	p70._magCount = p70._magCount + v79;
	p70._spareCount = p70._spareCount - v79;
end;
function v1.equip(p72)
	p72:fireInput("equipStart", (v17.getTime()));
end;
function v1.unequip(p73)
	p73:fireInput("unequipStart", (v17.getTime()));
end;
function v1.reload(p74)
	if not p74:canReload() then
		return;
	end;
	if p74:isChambering() then
		return;
	end;
	if p74:isInspecting() then
		p74._characterObject.thread:clear();
		p74._characterObject.thread:add(v18.reset(p74._animData, 0.1, p74:getWeaponStat("data.keepanimvisibility")));
	elseif p74._characterObject.animating then
		p74:cancelAnimation();
	end;
	if p74:isAiming() then
		p74:setAim(false);
	end;
	p74:fireInput("reloadStart", (v17.getTime()));
end;
function v1.reloadCancel(p75)
	p75:fireInput("reloadCancel", (v17.getTime()));
end;
function v1.chamber(p76)
	p76:fireInput("chamberStart", (v17.getTime()));
end;
function v1.toggleSight(p77)
	p77._activeAimStatIndex = p77._activeAimStatIndex % #p77._activeAimStats + 1;
	p77:updateAimStats();
end;
function v1.addAmmo(p78, p79, p80)
	p78._spareCount = p78._spareCount + p79;
	v9.updateAmmo(p78);
	v2.customAward("Picked up " .. p79 .. " rounds from dropped " .. p80);
end;
function v1.decrementMagCount(p81)
	if p81:getMagCount() <= 0 then
		warn("FirearmObject: Attempt to fire weapon with empty mag");
		return;
	end;
	p81._magCount = p81._magCount - 1;
end;
local u14 = { "LaserLight" };
function v1.hideModel(p82)
	if p82._isHidden then
		return;
	end;
	p82._isHidden = true;
	local l__next__80 = next;
	local v81, v82 = p82._weaponModel:GetChildren();
	while true do
		local v83, v84 = l__next__80(v81, v82);
		if not v83 then
			break;
		end;
		v82 = v83;
		if v84:IsA("BasePart") and not table.find(u14, v84.Name) and (not p82._weaponData.invisible or not p82._weaponData.invisible[v84.Name]) then
			v84.Transparency = 1;
			p82:updateTextureTransparency(v84, 1);
		end;	
	end;
	local v85, v86 = p82._characterObject:getArmModels();
	local l__next__87 = next;
	local v88, v89 = v85:GetChildren();
	while true do
		local v90, v91 = l__next__87(v88, v89);
		if not v90 then
			break;
		end;
		v89 = v90;
		if v91:IsA("BasePart") then
			v91.Transparency = 1;
		end;	
	end;
	local l__next__92 = next;
	local v93, v94 = v86:GetChildren();
	while true do
		local v95, v96 = l__next__92(v93, v94);
		if not v95 then
			break;
		end;
		v94 = v95;
		if v96:IsA("BasePart") then
			v96.Transparency = 1;
		end;	
	end;
	p82:updateTextureTransparency(p82:getActiveAimStat("sightpart"), 1);
end;
function v1.showModel(p83)
	if not p83._isHidden or p83._blackScoped then
		return;
	end;
	p83._isHidden = false;
	local l__next__97 = next;
	local v98, v99 = p83._weaponModel:GetChildren();
	while true do
		local v100, v101 = l__next__97(v98, v99);
		if not v100 then
			break;
		end;
		v99 = v100;
		if v101:IsA("BasePart") and not table.find(u14, v101.Name) and (not p83._weaponData.invisible or not p83._weaponData.invisible[v101.Name]) then
			v101.Transparency = p83._transparencyData[v101];
			p83:updateTextureTransparency(v101, 0);
		end;	
	end;
	for v102, v103 in next, p83._activeAimStats do
		p83:updateTextureTransparency(v103.sightpart, 0);
	end;
	local v104, v105 = p83._characterObject:getArmModels();
	local l__next__106 = next;
	local v107, v108 = v104:GetChildren();
	while true do
		local v109, v110 = l__next__106(v107, v108);
		if not v109 then
			break;
		end;
		v108 = v109;
		if v110:IsA("BasePart") then
			v110.Transparency = 0;
		end;	
	end;
	local l__next__111 = next;
	local v112, v113 = v105:GetChildren();
	while true do
		local v114, v115 = l__next__111(v112, v113);
		if not v114 then
			break;
		end;
		v113 = v114;
		if v115:IsA("BasePart") then
			v115.Transparency = 0;
		end;	
	end;
end;
function v1.updateScope(p84)
	if p84._blackScoped and not p84._wasBlackScoped then
		p84._wasBlackScoped = true;
		p84:hideModel();
		v23:applyeffects(p84:getWeaponStat("effectsettings"), true);
		v11.setScope(true, p84:getActiveAimStat("nosway"));
		return;
	end;
	if not p84._blackScoped and p84._wasBlackScoped then
		p84._wasBlackScoped = false;
		p84:showModel();
		v23:applyeffects(p84:getWeaponStat("effectsettings"), false);
		v11.setScope(false);
	end;
end;
function v1.updateAimStats(p85)
	local v116 = v13.getActiveCamera("MainCamera");
	local l__next__117 = next;
	local l___activeAimStats__118 = p85._activeAimStats;
	local v119 = nil;
	while true do
		local v120, v121 = l__next__117(l___activeAimStats__118, v119);
		if not v120 then
			break;
		end;
		if p85:isAiming() and v120 == p85._activeAimStatIndex then
			local v122 = p85._characterObject:getSpring("aimspring").t or 0;
		else
			v122 = 0;
		end;
		v121.sightmagspring.t = v122;
		v121.sightaimspring.t = v122;
		v121.sightmagspring.s = v27.IsTest() and p85:getActiveAimStat("magnifyspeed") or p85:getActiveAimStat("aimspeed");
		v121.sightaimspring.s = p85:getActiveAimStat("aimspeed");	
	end;
	p85._characterObject:setWalkSpeedMult(p85:isAiming() and p85:getActiveAimStat("aimwalkspeedmult") or 1);
	v116:getSpring("shakespring").s = p85:isAiming() and p85:getActiveAimStat("aimcamkickspeed") or p85:getWeaponStat("camkickspeed");
	if p85:getActiveAimStat("blackscope") then
		v11.setScopeSettings(p85._activeAimStats[p85._activeAimStatIndex]);
	end;
	if p85:isAiming() then
		p85._characterObject.sprintdisable = p85:getActiveAimStat("blackscope");
	else
		p85._characterObject.sprintdisable = false;
	end;
	v3.updateSightMark(p85:getActiveAimStat("sightpart"), p85:getActiveAimStat("centermark"));
end;
function v1.updateStance(p86, p87)
	if p86:getWeaponStat("restrictedads") and p86:isAiming() and p87 == "stand" then
		p86:setAim(false);
	end;
	if p86:getWeaponStat("proneonly") and p86:isAiming() and p87 ~= "prone" then
		p86:setAim(false);
	end;
end;
function v1.updateFiremodeStability(p88)
	local v123 = p88:getWeaponStat("firemodestability");
	p88._firemodeStability = v123 and v123[p88._firemodeIndex] or 0;
end;
function v1.updateTextureTransparency(p89, p90, p91)
	local l__next__124 = next;
	local v125, v126 = p90:GetChildren();
	while true do
		local v127, v128 = l__next__124(v125, v126);
		if not v127 then
			break;
		end;
		v126 = v127;
		if v128:IsA("Texture") or v128:IsA("Decal") then
			v128.Transparency = p91 ~= 1 and p89._textureData[p90][v128].Transparency or 1;
		elseif v128:IsA("SurfaceGui") then
			v128.Enabled = p91 ~= 1;
		end;	
	end;
end;
function v1.cancelAnimation(p92, p93)
	p92._characterObject.thread:clear();
	p92._characterObject.thread:add(v18.reset(p92._animData, p93 and 0.05, p92:getWeaponStat("keepanimvisibility") or p92:isBlackScope()));
	p92._characterObject.animating = false;
end;
function v1.playAnimation(p94, p95, p96, p97)
	local l___characterObject__129 = p94._characterObject;
	local l__thread__130 = l___characterObject__129.thread;
	if p94:isAnimationReloading() or not p94:isEquipped() then
		return;
	end;
	l__thread__130:clear();
	if l___characterObject__129.animating then
		p94:cancelAnimation();
	end;
	if p94:isAiming() and p95 ~= "selector" then
		p94:setAim(false);
	end;
	p94._reloadspring.t = 1;
	l___characterObject__129.animating = true;
	l___characterObject__129:getSpring("sprintspring").t = 0;
	if p95 == "inspect" then
		p94._inspecting = true;
	end;
	if p97 then
		p94._yieldToAnimation = true;
		p94._bolting = true;
	end;
	l__thread__130:add(v18.player(p94._animData, p94:getWeaponStat("animations")[p95], p94._weaponName, p95));
	l__thread__130:add(function()
		print("resetting animation", p95);
		if p96 then
			local v131 = 0;
		else
			v131 = p94:getWeaponStat("animations")[p95].resettime;
		end;
		l__thread__130:add(v18.reset(p94._animData, v131, p94:getWeaponStat("keepanimvisibility") or p94:isBlackScope()));
		l__thread__130:add(function()
			p94._inspecting = false;
			l___characterObject__129.animating = false;
			if p97 then
				p94._yieldToAnimation = false;
				p94._needRechambering = false;
				p94._bolting = false;
			end;
			if p94:isStateReloading() then
				return;
			end;
			if (v26.mouse.down.right or v26.controller.down.l2) and not p94:isAiming() then
				p94:setAim(true);
			end;
			if l___characterObject__129:isSprinting() then
				l___characterObject__129:getSpring("sprintspring").t = 1;
			end;
			p94._reloadspring.t = 0;
		end);
	end);
end;
function v1.shoot(p98, p99)
	local v132 = v17.getTime();
	if p99 then
		if not p98:isEquipped() then
			return;
		end;
		if v10.roundLock then
			return;
		end;
		if p98._magCount <= 0 then
			p98:reload();
			return;
		end;
		if v132 < p98._disableUntil then
			return;
		end;
		if p98:isEquipping() then
			return;
		end;
		if p98:isAnimationReloading() and not p98._canShoot then
			return p98:reloadCancel();
		end;
		p98._characterObject:setSprint(false);
		local v133 = p98:getFiremode();
		if v133 == "BINARY" then
			v133 = 1;
		end;
		if v133 == true then
			p98._auto = true;
		elseif p98._burst == 0 and p98._nextShot < v132 then
			p98._burst = v133;
		end;
		if p98:getWeaponStat("burstcam") then
			p98._auto = true;
		end;
		if p98._nextShot < v132 then
			p98._nextShot = v132;
		end;
		if p98:getWeaponStat("forcecap") and not p98._auto then
			p98._disableUntil = v132 + 60 / p98:getWeaponStat("firecap") * (tonumber(v133) and 1);
			return;
		end;
	elseif not p98:getWeaponStat("loosefiring") then
		if p98:getWeaponStat("autoburst") and p98._auto and p98._nShots > 0 then
			p98._nextShot = v132 + 60 / p98:getWeaponStat("firecap");
		end;
		p98._nShots = 0;
		p98._auto = false;
		if not p98:getWeaponStat("burstlock") and not p98:getWeaponStat("burstcam") then
			p98._burst = 0;
		end;
		if p98:isStateReloading() or p98:isEquipping() then
			return;
		end;
		if p98:getFiremode() == "BINARY" then
			p98._burst = 1;
		end;
	end;
end;
local u15 = 0;
local u16 = { workspace.Players, workspace.Terrain, workspace.Ignore, workspace.CurrentCamera };
function v1.fireRound(p100, p101)
	local v134 = v13.getActiveCamera("MainCamera");
	local v135 = v17.getTime();
	local l___characterObject__136 = p100._characterObject;
	local l__thread__137 = l___characterObject__136.thread;
	while true do
		local u17 = nil;
		local u18 = nil;
		if not (p100._magCount > 0) then
			break;
		end;
		if not p100:canFire() then
			break;
		end;
		if p100._inspecting then
			p100._inspecting = false;
			p100:cancelAnimation(p100._reloadCancelTime);
		end;
		p100.thread2:clear();
		if not l___characterObject__136.reloading and not (not p100:getWeaponStat("forceonfire")) or p100._magCount > 1 and p100:getWeaponStat("animations").onfire and (not p100:isAiming() or p100:isAiming() and (not p100:getActiveAimStat("pullout") or p100:getWeaponStat("straightpull"))) then
			local v138 = p100:getActiveAimStat("zoom");
			if p100:getActiveAimStat("zoompullout") then
				p100._armaimspring.t = p100:getWeaponStat("aimarmblend") and 0;
				if p100:isAiming() and not p100:getWeaponStat("aimspringcancel") and not p100:getWeaponStat("straightpull") then
					local v139 = 0.5;
				else
					v139 = 1;
				end;
				l___characterObject__136:getSpring("zoommodspring").t = v139;
				p100:updateAimStats();
			end;
			if p100:isAiming() and p100:getActiveAimStat("onfireaimedanim") then
				local v140 = "onfire" .. p100:getActiveAimStat("onfireaimedanim");
			elseif p100:getActiveAimStat("onfireanim") then
				v140 = "onfire" .. p100:getActiveAimStat("onfireanim");
			else
				v140 = "onfire";
			end;
			local v141 = p100:getWeaponStat("animations")[v140];
			if not p100:getWeaponStat("ignorestanceanim") then
				p100._reloadspring.t = 1;
			end;
			l__thread__137:clear();
			if p100._inspecting or l___characterObject__136.animating then
				p100._inspecting = false;
				p100:cancelAnimation(p100._reloadCancelTime);
			end;
			l___characterObject__136.animating = true;
			p100._yieldToAnimation = true;
			p100._bolting = true;
			l__thread__137:add(v18.player(p100._animData, v141, p100._weaponName, v140));
			l__thread__137:add(function()
				if p100:isStateReloading() then
					return;
				end;
				if p100:isAiming() then
					l___characterObject__136:getSpring("zoommodspring").t = 1;
					p100._armaimspring.t = 1;
					p100:updateAimStats();
				end;
				l__thread__137:add(v18.reset(p100._animData, v141.resettime, p100:getWeaponStat("keepanimvisibility") or p100:isAiming()));
				p100._bolting = false;
				l___characterObject__136.animating = false;
				p100._yieldToAnimation = false;
				p100._reloadspring.t = 0;
				if v26.mouse.down.right or v26.controller.down.l2 then
					p100:setAim(true);
				elseif not p100._auto and not p100._wasBlackScoped then
					print("Sprinting");
					l___characterObject__136:setSprint(v26.keyboard.down.leftshift or (v26.keyboard.down.w and l___characterObject__136.doubletap or p100._wasSprinting));
				end;
				if l___characterObject__136:isSprinting() then
					l___characterObject__136:getSpring("sprintspring").t = 1;
				end;
				if p100:getWeaponStat("forcereload") and p100._magCount <= 0 and not p100:isAiming() then
					p100:reload();
				end;
			end);
		elseif p100:getWeaponStat("shelloffset") then
			if not p100:getWeaponStat("caselessammo") then
				v23:ejectshell(p100._mainPart.CFrame, p100:getWeaponStat("casetype") or p100:getWeaponStat("ammotype"), p100:getWeaponStat("shelloffset"));
			end;
			if p100._magCount > 0 then
				p100.thread2:add(function(p102)
					if p100._magCount <= 0 and p100:getWeaponStat("boltlock") then
						return p100:boltStop(p102);
					end;
					return p100:boltKick(p102);
				end);
			end;
		end;
		if p100._burst ~= 0 then
			p100._burst = p100._burst - 1;
		end;
		p100:fireInput("shoot", v135);
		if v20.purecontroller() then
			local v142 = 0.5;
		else
			v142 = 1;
		end;
		local v143 = v3.getCrossSize();
		local l__stability__144 = l___characterObject__136.stability;
		local v145 = (1 - p100._firemodeStability) * (1 - l__stability__144);
		local v146 = p100:getWeaponStat("transkickmin");
		local v147 = v146 + Vector3.new(math.random(), math.random(), math.random()) * (p100:getWeaponStat("transkickmax") - v146);
		local v148 = p100:getActiveAimStat("aimtranskickmin");
		local v149 = p101 * (v148 + Vector3.new(math.random(), math.random(), math.random()) * (p100:getActiveAimStat("aimtranskickmax") - v148));
		local v150 = p100:getWeaponStat("rotkickmin");
		local v151 = v150 + Vector3.new(math.random(), math.random(), math.random()) * (p100:getWeaponStat("rotkickmax") - v150);
		local v152 = p100:getActiveAimStat("aimrotkickmin");
		local v153 = p101 * (v152 + Vector3.new(math.random(), math.random(), math.random()) * (p100:getActiveAimStat("aimrotkickmax") - v152));
		local v154 = p100:getWeaponStat("firedelay") and 0;
		local u19 = v145 * ((1 - p101) * v147 + v149);
		local u20 = v145 * ((1 - p101) * v151 + v153);
		task.delay(v154, function()
			if p100._experimentalRecoil then
				p100._translationRecoil:applyImpulse();
				p100._rotationRecoil:applyImpulse();
				v134:applyImpulse();
				return;
			end;
			p100._spreadspring.a = 0.5 * (1 - p101) * (1 - l__stability__144) * p100:getWeaponStat("hipfirespread") * p100:getWeaponStat("hipfirespreadrecover") * v143 / p100:getWeaponStat("crosssize") * Vector3.new(2 * math.random() - 1, 2 * math.random() - 1, 0);
			p100._transkickspring.a = u19;
			p100._rotkickspring.a = u20;
			local v155 = p100:getWeaponStat("camkickmin");
			local v156 = p100:getActiveAimStat("aimcamkickmin");
			v134:shake((1 - p100._firemodeStability) * (1 - p101) * v142 * (v155 + Vector3.new(math.random(), math.random(), math.random()) * (p100:getWeaponStat("camkickmax") - v155)) + (1 - p100._firemodeStability) * v142 * p101 * (v156 + Vector3.new(math.random(), math.random(), math.random()) * (p100:getActiveAimStat("aimcamkickmax") - v156)));
		end);
		task.delay(0.4, function()
			if p100:getWeaponStat("type") == "SNIPER" then
				v25.play("metalshell", 0.15, 0.8);
				return;
			end;
			if p100:getWeaponStat("type") == "SHOTGUN" then
				task.wait(0.3);
				v25.play("shotgunshell", 0.2);
				return;
			end;
			if p100:getWeaponStat("type") ~= "REVOLVER" and not p100:getWeaponStat("caselessammo") then
				v25.play("metalshell", 0.1);
			end;
		end);
		if not p100:isAiming() then
			v3.fireImpulse(p100:getWeaponStat("crossexpansion") * (1 - p101));
		elseif p100:getWeaponStat("animations").onfire and p100:getActiveAimStat("pullout") then
			p100._needRechambering = true;
		end;
		local l__CFrame__157 = (p100:isAiming() and p100:getActiveAimStat("sightpart") or p100._barrelPart).CFrame;
		local l__p__158 = v134:getBaseCFrame().p;
		local v159, v160, v161 = workspace:FindPartOnRayWithIgnoreList(Ray.new(l__p__158, l__CFrame__157.p - l__p__158), { workspace.Players:FindFirstChild(l__LocalPlayer__28.TeamColor.Name), workspace.Terrain, workspace.Ignore, workspace.CurrentCamera });
		local v162 = v160 + 0.01 * v161;
		local v163 = {};
		local v164 = {};
		local v165 = {
			camerapos = v134:getBaseCFrame().p, 
			firepos = v162, 
			bullets = v164
		};
		p100._fireCount = p100._fireCount + 1;
		local v166, v167 = p100._samplePointGenerator:getPoint(p100._fireCount);
		local v168 = p100:getWeaponStat("type") == "SHOTGUN" and p100:getWeaponStat("pelletcount") or 1;
		local v169 = 1 - 1;
		while true do
			local u21 = nil;
			local v170 = nil;
			local u22 = nil;
			local v171 = nil;
			local v172 = nil;
			local v173 = nil;
			local v174 = nil;
			local v175 = nil;
			local v176 = nil;
			local v177 = nil;
			local v178 = nil;
			local v179 = nil;
			local v180 = nil;
			local v181 = nil;
			local v182 = nil;
			local v183 = nil;
			local v184 = nil;
			local v185 = nil;
			local v186 = nil;
			local v187 = nil;
			local v188 = nil;
			local v189 = nil;
			local v190 = nil;
			local v191 = nil;
			local v192 = nil;
			local v193 = nil;
			local v194 = nil;
			local v195 = nil;
			local v196 = nil;
			local v197 = nil;
			local v198 = nil;
			local v199 = nil;
			local v200 = nil;
			local v201 = nil;
			local v202 = nil;
			local v203 = nil;
			local v204 = nil;
			local v205 = nil;
			local v206 = nil;
			local v207 = nil;
			local v208 = nil;
			local v209 = nil;
			local v210 = nil;
			local v211 = nil;
			local v212 = nil;
			local v213 = nil;
			local v214 = nil;
			local v215 = nil;
			local v216 = nil;
			local v217 = nil;
			local v218 = nil;
			local v219 = nil;
			local v220 = nil;
			local v221 = nil;
			local v222 = nil;
			local v223 = nil;
			local v224 = nil;
			local v225 = nil;
			local v226 = nil;
			local v227 = nil;
			local v228 = nil;
			local v229 = nil;
			local v230 = nil;
			local v231 = nil;
			local v232 = nil;
			local v233 = nil;
			local v234 = nil;
			local v235 = nil;
			local v236 = nil;
			local v237 = nil;
			local v238 = nil;
			local v239 = nil;
			local v240 = nil;
			local v241 = nil;
			local v242 = nil;
			local v243 = nil;
			local v244 = nil;
			local v245 = nil;
			local v246 = nil;
			local v247 = nil;
			local v248 = nil;
			local v249 = nil;
			local v250 = nil;
			local v251 = nil;
			local v252 = nil;
			local v253 = nil;
			local v254 = nil;
			local u23 = nil;
			local u24 = nil;
			local v255 = nil;
			local v256 = nil;
			local v257 = nil;
			local v258 = nil;
			local v259 = nil;
			local v260 = nil;
			local v261 = nil;
			local v262 = nil;
			local v263 = nil;
			local v264 = nil;
			local v265 = nil;
			local v266 = nil;
			local v267 = nil;
			local v268 = nil;
			local v269 = nil;
			local v270 = nil;
			local v271 = nil;
			local v272 = nil;
			local v273 = nil;
			local v274 = nil;
			local v275 = nil;
			local v276 = nil;
			local v277 = nil;
			local v278 = nil;
			u15 = u15 + 1;
			local v279 = {};
			if not p100:getWeaponStat("spread") and (not p100:getWeaponStat("crosssize") or not p100:getWeaponStat("aimchoke")) then
				local v280 = p100:getWeaponStat("bulletspeed") * l__CFrame__157.lookVector;
				u22 = v279;
				u21 = u15;
				u17 = v163;
				v170 = function(p103, p104, p105, p106)
					if u22[p104] then
						return;
					end;
					u22[p104] = true;
					v5.playerHitDection(p103, p100, p104, p105, p106, u21, u17);
				end;
				v171 = v21;
				v172 = "new";
				v174 = v171;
				v175 = v172;
				v173 = v174[v175];
				local v281 = {};
				local v282 = "position";
				v176 = v281;
				v177 = v282;
				v178 = v162;
				v176[v177] = v178;
				local v283 = "velocity";
				v179 = v281;
				v180 = v283;
				v181 = v280;
				v179[v180] = v181;
				v182 = v15;
				local v284 = "bulletAcceleration";
				v183 = v182;
				v184 = v284;
				v185 = v183[v184];
				local v285 = "acceleration";
				v186 = v281;
				v187 = v285;
				v188 = v185;
				v186[v187] = v188;
				v192 = "bulletcolor";
				local v286 = "getWeaponStat";
				v189 = p100;
				local v287 = v189;
				v190 = p100;
				v191 = v286;
				local v288 = v190[v191];
				v193 = v288;
				v194 = v287;
				v195 = v192;
				local v289 = v193(v194, v195);
				v196 = v289;
				if not v196 then
					v289 = Color3.fromRGB(200, 70, 70);
				end;
				local v290 = "color";
				v197 = v281;
				v198 = v290;
				v199 = v289;
				v197[v198] = v199;
				local v291 = 0.2;
				local v292 = "size";
				v200 = v281;
				v201 = v292;
				v202 = v291;
				v200[v201] = v202;
				local v293 = 0.005;
				local v294 = "bloom";
				v203 = v281;
				v204 = v294;
				v205 = v293;
				v203[v204] = v205;
				local v295 = 400;
				local v296 = "brightness";
				v206 = v281;
				v207 = v296;
				v208 = v295;
				v206[v207] = v208;
				local v297 = v15;
				local v298 = "bulletLifeTime";
				v209 = v297;
				v210 = v298;
				local v299 = v209[v210];
				local v300 = "life";
				v211 = v281;
				v212 = v300;
				v213 = v299;
				v211[v212] = v213;
				local v301 = "_barrelPart";
				v214 = p100;
				v215 = v301;
				local v302 = v214[v215];
				local v303 = "Position";
				v216 = v302;
				v217 = v303;
				local v304 = v216[v217];
				local v305 = "visualorigin";
				v218 = v281;
				v219 = v305;
				v220 = v304;
				v218[v219] = v220;
				local v306 = u16;
				local v307 = "physicsignore";
				v221 = v281;
				v222 = v307;
				v223 = v306;
				v221[v222] = v223;
				local v308 = "_nextShot";
				v224 = p100;
				v225 = v308;
				local v309 = v224[v225];
				v226 = v135;
				v227 = v309;
				local v310 = v226 - v227;
				local v311 = "dt";
				v228 = v281;
				v229 = v311;
				v230 = v310;
				v228[v229] = v230;
				local v312 = "penetrationdepth";
				local v313 = "getWeaponStat";
				v231 = p100;
				local v314 = v231;
				v232 = p100;
				v233 = v313;
				local v315 = v232[v233];
				v234 = v315;
				v235 = v314;
				v236 = v312;
				local v316 = v234(v235, v236);
				local v317 = "penetrationdepth";
				v237 = v281;
				v238 = v317;
				v239 = v316;
				v237[v238] = v239;
				local v318 = "tracerless";
				local v319 = "getWeaponStat";
				v240 = p100;
				local v320 = v240;
				v241 = p100;
				v242 = v319;
				local v321 = v241[v242];
				v243 = v321;
				v244 = v320;
				v245 = v318;
				local v322 = v243(v244, v245);
				local v323 = "tracerless";
				v246 = v281;
				v247 = v323;
				v248 = v322;
				v246[v247] = v248;
				local v324 = nil;
				local v325 = "wallbang";
				v249 = v281;
				v250 = v325;
				v251 = v324;
				v249[v250] = v251;
				local v326 = "onplayerhit";
				v252 = v281;
				v253 = v326;
				v254 = v170;
				v252[v253] = v254;
				u23 = v162;
				u24 = v280;
				u18 = v135;
				local v327 = function(p107, p108, p109, p110, p111, p112)
					v5.hitDetection(p107, p108, p109, p110, p111, p112, u23, u24, u18, u21);
				end;
				local v328 = "ontouch";
				v255 = v281;
				v256 = v328;
				v257 = v327;
				v255[v256] = v257;
				v258 = v173;
				v259 = v281;
				v258(v259);
				v260 = v164;
				local v329 = #v260;
				local v330 = 1;
				v261 = v329;
				v262 = v330;
				local v331 = v261 + v262;
				local v332 = {};
				v263 = u24;
				local v333 = v263;
				v264 = u21;
				local v334 = v264;
				v267 = v333;
				v270 = v334;
				v266 = 1;
				v265 = v332;
				v265[v266] = v267;
				v269 = 2;
				v268 = v332;
				v268[v269] = v270;
				v271 = v164;
				v272 = v331;
				v273 = v332;
				v271[v272] = v273;
				local v335 = 0;
				v274 = v335;
				v275 = 1;
				if v274 <= v275 then
					if not (v169 < v168) then
						break;
					end;
				elseif not (v168 < v169) then
					break;
				end;
				v276 = v169;
				v277 = 1;
				v169 = v276 + v277;
			end;
			while true do
				local v336 = math.sqrt((v169 - v167) / v168);
				local v337 = 0.7639320225002102 * math.pi;
				local v338 = v336 * math.cos((v169 - v166) * v337);
				local v339 = v336 * math.sin((v169 - v166) * v337);
				v278 = v338 * v338 + v339 * v339;
				if v278 <= 1.00001 then
					break;
				end;			
			end;
			local v340 = (p100:getWeaponStat("spread") or 0.6666666666666666 * p100:getWeaponStat("crosssize") * p100:getWeaponStat("aimchoke") / p100:getWeaponStat("bulletspeed")) * math.sqrt(-math.log(v278) / v278);
			v280 = p100:getWeaponStat("bulletspeed") * l__CFrame__157:VectorToWorldSpace((Vector3.new(v340 * (p100:getWeaponStat("choke") and p100:getWeaponStat("xbias") or 1) * v338, v340 * (p100:getWeaponStat("choke") and p100:getWeaponStat("ybias") or 1) * v339, -1))).unit;
			u22 = v279;
			u21 = u15;
			u17 = v163;
			v170 = function(p113, p114, p115, p116)
				if u22[p114] then
					return;
				end;
				u22[p114] = true;
				v5.playerHitDection(p113, p100, p114, p115, p116, u21, u17);
			end;
			v171 = v21;
			v172 = "new";
			v174 = v171;
			v175 = v172;
			v173 = v174[v175];
			v281 = {};
			v282 = "position";
			v176 = v281;
			v177 = v282;
			v178 = v162;
			v176[v177] = v178;
			v283 = "velocity";
			v179 = v281;
			v180 = v283;
			v181 = v280;
			v179[v180] = v181;
			v182 = v15;
			v284 = "bulletAcceleration";
			v183 = v182;
			v184 = v284;
			v185 = v183[v184];
			v285 = "acceleration";
			v186 = v281;
			v187 = v285;
			v188 = v185;
			v186[v187] = v188;
			v192 = "bulletcolor";
			v286 = "getWeaponStat";
			v189 = p100;
			v287 = v189;
			v190 = p100;
			v191 = v286;
			v288 = v190[v191];
			v193 = v288;
			v194 = v287;
			v195 = v192;
			v289 = v193(v194, v195);
			v196 = v289;
			if not v196 then
				v289 = Color3.fromRGB(200, 70, 70);
			end;
			v290 = "color";
			v197 = v281;
			v198 = v290;
			v199 = v289;
			v197[v198] = v199;
			v291 = 0.2;
			v292 = "size";
			v200 = v281;
			v201 = v292;
			v202 = v291;
			v200[v201] = v202;
			v293 = 0.005;
			v294 = "bloom";
			v203 = v281;
			v204 = v294;
			v205 = v293;
			v203[v204] = v205;
			v295 = 400;
			v296 = "brightness";
			v206 = v281;
			v207 = v296;
			v208 = v295;
			v206[v207] = v208;
			v297 = v15;
			v298 = "bulletLifeTime";
			v209 = v297;
			v210 = v298;
			v299 = v209[v210];
			v300 = "life";
			v211 = v281;
			v212 = v300;
			v213 = v299;
			v211[v212] = v213;
			v301 = "_barrelPart";
			v214 = p100;
			v215 = v301;
			v302 = v214[v215];
			v303 = "Position";
			v216 = v302;
			v217 = v303;
			v304 = v216[v217];
			v305 = "visualorigin";
			v218 = v281;
			v219 = v305;
			v220 = v304;
			v218[v219] = v220;
			v306 = u16;
			v307 = "physicsignore";
			v221 = v281;
			v222 = v307;
			v223 = v306;
			v221[v222] = v223;
			v308 = "_nextShot";
			v224 = p100;
			v225 = v308;
			v309 = v224[v225];
			v226 = v135;
			v227 = v309;
			v310 = v226 - v227;
			v311 = "dt";
			v228 = v281;
			v229 = v311;
			v230 = v310;
			v228[v229] = v230;
			v312 = "penetrationdepth";
			v313 = "getWeaponStat";
			v231 = p100;
			v314 = v231;
			v232 = p100;
			v233 = v313;
			v315 = v232[v233];
			v234 = v315;
			v235 = v314;
			v236 = v312;
			v316 = v234(v235, v236);
			v317 = "penetrationdepth";
			v237 = v281;
			v238 = v317;
			v239 = v316;
			v237[v238] = v239;
			v318 = "tracerless";
			v319 = "getWeaponStat";
			v240 = p100;
			v320 = v240;
			v241 = p100;
			v242 = v319;
			v321 = v241[v242];
			v243 = v321;
			v244 = v320;
			v245 = v318;
			v322 = v243(v244, v245);
			v323 = "tracerless";
			v246 = v281;
			v247 = v323;
			v248 = v322;
			v246[v247] = v248;
			v324 = nil;
			v325 = "wallbang";
			v249 = v281;
			v250 = v325;
			v251 = v324;
			v249[v250] = v251;
			v326 = "onplayerhit";
			v252 = v281;
			v253 = v326;
			v254 = v170;
			v252[v253] = v254;
			u23 = v162;
			u24 = v280;
			u18 = v135;
			v327 = function(p117, p118, p119, p120, p121, p122)
				v5.hitDetection(p117, p118, p119, p120, p121, p122, u23, u24, u18, u21);
			end;
			v328 = "ontouch";
			v255 = v281;
			v256 = v328;
			v257 = v327;
			v255[v256] = v257;
			v258 = v173;
			v259 = v281;
			v258(v259);
			v260 = v164;
			v329 = #v260;
			v330 = 1;
			v261 = v329;
			v262 = v330;
			v331 = v261 + v262;
			v332 = {};
			v263 = u24;
			v333 = v263;
			v264 = u21;
			v334 = v264;
			v267 = v333;
			v270 = v334;
			v266 = 1;
			v265 = v332;
			v265[v266] = v267;
			v269 = 2;
			v268 = v332;
			v268[v269] = v270;
			v271 = v164;
			v272 = v331;
			v273 = v332;
			v271[v272] = v273;
			v335 = 0;
			v274 = v335;
			v275 = 1;
			if v274 <= v275 then
				if not (v169 < v168) then
					break;
				end;
			elseif not (v168 < v169) then
				break;
			end;
			v276 = v169;
			v277 = 1;
			v169 = v276 + v277;		
		end;
		v22:send("newbullets", v165, u18);
		for v341 = 1, #u17 do
			v22:send("bullethit", unpack(u17[v341]));
		end;
		p100._magCount = p100._magCount - 1;
		p100._nShots = p100._nShots + 1;
		if p100._burst <= 0 and p100:getWeaponStat("firecap") and p100:getFiremode() ~= true then
			p100._nextShot = u18 + 60 / p100:getWeaponStat("firecap");
		elseif p100:getWeaponStat("autoburst") and p100._auto and p100._nShots < p100:getWeaponStat("autoburst") then
			p100._nextShot = p100._nextShot + 60 / p100:getWeaponStat("burstfirerate");
		elseif p100:isAiming() and p100:getActiveAimStat("aimedfirerate") then
			p100._nextShot = p100._nextShot + 60 / p100:getActiveAimStat("aimedfirerate");
		else
			p100._nextShot = p100._nextShot + 60 / p100:getFirerate();
		end;
		if p100._magCount == 0 then
			p100._burst = 0;
			p100._auto = false;
			if p100:getWeaponStat("magdisappear") then
				p100:getWeaponPart(p100:getWeaponStat("mag")).Transparency = 1;
			end;
			if (not p100:getActiveAimStat("pullout") and not p100:getActiveAimStat("blackscope") or not p100:isAiming()) and (p100:getWeaponStat("firemodes")[1] == true or not p100:isAiming()) then
				p100:reload();
			end;
		end;	
	end;
	if false then
		if p100:getWeaponStat("sniperbass") then
			v25.play("1PsniperBass", 0.75);
			v25.play("1PsniperEcho", 1);
		end;
		if not p100:getWeaponStat("nomuzzleeffects") then
			v23:muzzleflash(p100._barrelPart, p100:getWeaponStat("hideflash"));
			if not p100:getWeaponStat("hideflash") then
				l___characterObject__136:fireMuzzleLight();
			end;
		end;
		if not p100:getWeaponStat("hideminimap") then
			v7.goingLoud();
		end;
		v25.PlaySoundId(p100:getWeaponStat("firesoundid"), p100:getWeaponStat("firevolume"), p100:getWeaponStat("firepitch"), p100._barrelPart, nil, 0, 0.05);
		v9.updateAmmo(p100);
	end;
end;
function v1.nextFiremode(p123)
	if p123:isAnimationReloading() then
		return;
	end;
	local l__selector__342 = p123:getWeaponStat("animations").selector;
	local l___characterObject__343 = p123._characterObject;
	local l__thread__344 = l___characterObject__343.thread;
	if l__selector__342 then
		if l___characterObject__343.animating then
			l__thread__344:clear();
			l__thread__344:add(v18.reset(p123._animData, 0.2, p123:getWeaponStat("keepanimvisibility") or p123:isBlackScope()));
		end;
		l___characterObject__343.animating = true;
		if p123:isAiming() and not p123:getActiveAimStat("aimspringcancel") then
			l___characterObject__343:getSpring("zoommodspring").t = 0.5;
			p123._armaimspring.t = 0;
			p123:updateAimStats();
		end;
		if l___characterObject__343:isSprinting() then
			l___characterObject__343:getSpring("sprintspring").t = 0.5;
		end;
		p123._yieldToAnimation = true;
		l__thread__344:add(v18.player(p123._animData, l__selector__342, p123._weaponName, "selector"));
		l__thread__344:add(function()
			l__thread__344:add(v18.reset(p123._animData, l__selector__342.resettime, p123:getWeaponStat("keepanimvisibility") or p123:isBlackScope()));
			l___characterObject__343.animating = false;
			p123._inspecting = false;
			p123._yieldToAnimation = false;
			if l___characterObject__343:isSprinting() then
				l___characterObject__343:getSpring("sprintspring").t = 1;
			end;
			if p123:isAiming() then
				l___characterObject__343:getSpring("zoommodspring").t = 1;
				p123._armaimspring.t = 1;
				p123:updateAimStats();
			end;
		end);
	end;
	l__thread__344:add(function()
		p123._firemodeIndex = p123._firemodeIndex % #p123:getWeaponStat("firemodes") + 1;
		if p123._auto then
			p123._auto = false;
		end;
		p123._burst = 0;
		p123:updateFiremodeStability();
	end);
end;
function v1.boltKick(p124, p125)
	local v345 = nil;
	v345 = p124._animData;
	p125 = p125 / p124:getWeaponStat("bolttime") * 1.5;
	p124._boltOpen = false;
	if p125 > 1.5 then
		v345[p124:getWeaponStat("bolt")].weld.C0 = p124._boltCF(0);
		return nil;
	end;
	if not (p125 > 0.5) then
		v345[p124:getWeaponStat("bolt")].weld.C0 = p124._boltCF(1 - 4 * (p125 - 0.5) * (p125 - 0.5));
		return false;
	end;
	p125 = (p125 - 0.5) * 0.5 + 0.5;
	v345[p124:getWeaponStat("bolt")].weld.C0 = p124._boltCF(1 - 4 * (p125 - 0.5) * (p125 - 0.5));
	return false;
end;
function v1.boltStop(p126, p127)
	local v346 = nil;
	v346 = p126._animData;
	p127 = p127 / p126:getWeaponStat("bolttime") * 1.5;
	if p127 > 0.5 then
		v346[p126:getWeaponStat("bolt")].weld.C0 = p126._boltCF(1);
		p126._boltOpen = true;
		return true;
	end;
	v346[p126:getWeaponStat("bolt")].weld.C0 = p126._boltCF(1 - 4 * (p127 - 0.5) * (p127 - 0.5));
	p126._boltOpen = false;
	return false;
end;
local u25 = 2 * math.pi;
function v1.walkSway(p128, p129, p130)
	local l___characterObject__347 = p128._characterObject;
	local v348, v349, v350 = l___characterObject__347:getWalkValues();
	local v351 = p130 and 1;
	local v352 = v348 * u25 * 3 / 4;
	local v353 = -v350;
	local v354 = v349 * (1 - l___characterObject__347:getSpring("slidespring").p * 0.9);
	return CFrame.new(v351 * math.cos(v352 / 8 - 1) * v354 / 196, 1.25 * (p129 and 1) * math.sin(v352 / 4) * v354 / 512, 0) * u12.fromaxisangle(Vector3.new(v351 * math.sin(v352 / 4 - 1) / 256 + v351 * (math.sin(v352 / 64) - v351 * v353.z / 4) / 512, v351 * math.cos(v352 / 128) / 128 - v351 * math.cos(v352 / 8) / 256, v351 * math.sin(v352 / 8) / 128 + v351 * v353.x / 1024) * math.sqrt(v354 / 20) * u25);
end;
function v1.gunSway(p131, p132)
	local v355 = v17.getTime() * 6;
	local v356 = 2 * (1.1 - p132);
	return CFrame.new(math.cos(v355 / 8) * v356 / 128, -math.sin(v355 / 4) * v356 / 128, math.sin(v355 / 16) * v356 / 64);
end;
function v1.fireInput(p133, p134, p135)
	if not p133._equipState:fireInput(p134, p135) then
		if not p133:isEquipped() then
			return;
		elseif p133._chamberState:fireInput(p134, p135) then
			return true;
		else
			return;
		end;
	end;
	if p134 == "unequipStart" then
		if not p133:canUnequip() then
			return;
		end;
		if not (not p133:isState("unchamberedReloading")) or not (not p133:isState("unchamberedReloadCancelling")) or not (not p133:isState("chambering")) or p133:isState("chamberCancelling") then
			p133._needRechambering = true;
			p133._chamberState:setState("unchambered", p135);
		elseif p133:isState("chamberedReloading") or p133:isState("chamberedReloadCancelling") then
			p133._chamberState:setState("chambered", p135);
		end;
	end;
	return true;
end;
function v1.stepAttachments(p136, p137)
	for v357, v358 in next, p136._activeComponents do
		v358:step(p137);
	end;
end;
function v1.stepStateMachines(p138, p139)
	local v359 = v17.getTime();
	local v360 = p138:getWeaponStat("equiptime") or (p138:getAnimation("equipping") and p138:getAnimLength("equipping") or 0.2);
	local v361 = p138:getWeaponStat("unequiptime") or (p138:getAnimation("unequipping") and p138:getAnimLength("unequipping") or 0.2);
	if p138:stateTimeCheck("equipping", v360, v359) then
		p138:setFlag("equipFlag", v359);
	elseif p138:stateTimeCheck("unequipping", v361, v359) then
		p138:setFlag("unequipFlag", v359);
	end;
	if p138:isState("unchambered") then
		if p138._magCount > 0 and ((not p138:getActiveAimStat("pullout") or not p138:isAiming() or p138:getWeaponStat("straightpull")) and p138:stateTimeCheck("unchambered", 0.1, v359) and p138:isSteadyState()) then
			p138:fireInput("chamberStart", v359);
			return;
		end;
	else
		if p138:animationStateCheck("chambering", "onfire", v359) then
			p138:fireInput("chamberFinish", v359);
			return;
		end;
		if p138:isStateReloading() then
			p138._characterObject:getSpring("sprintspring").t = 0;
			local v362 = p138:getCurrentReloadFile();
			if v362 and (p138:animationStateCheck("chamberedReloading", v362.reloadName, v359) or p138:animationStateCheck("unchamberedReloading", v362.reloadName, v359)) then
				p138:fireInput("reloadFinish", v359);
				return;
			end;
		else
			if p138:stateTimeCheck("chamberedReloadCancelling", p138._reloadCancelTime, v359) or p138:stateTimeCheck("unchamberedReloadCancelling", p138._reloadCancelTime, v359) then
				p138:fireInput("reloadCancelFinish", v359);
				return;
			end;
			if not (not p138:stateTimeCheck("chamberCancelling", p138._reloadCancelTime, v359)) or not (not p138:stateTimeCheck("chamberedReloadCancelResetting", p138._reloadCancelTime, v359)) or p138:stateTimeCheck("unchamberedReloadCancelResetting", p138._reloadCancelTime, v359) then
				p138:fireInput("reloadResume", v359);
				return;
			end;
			if p138:stateTimeCheck("chamberCancelling", p138._reloadCancelTime, v359) then
				p138:fireInput("chamberCancelFinish", v359);
			end;
		end;
	end;
end;
function v1.step(p140, p141)
	local v363 = v13.getActiveCamera("MainCamera");
	local l___characterObject__364 = p140._characterObject;
	local l__p__365 = l___characterObject__364:getSpring("zoommodspring").p;
	local l__p__366 = l___characterObject__364:getSpring("aimspring").p;
	local l__p__367 = p140._armaimspring.p;
	p140._sprintposespring.t = math.min(l___characterObject__364:getSpring("truespeedspring").p / l___characterObject__364:getSpring("walkspeedspring").p * l___characterObject__364:getSpring("sprintspring").p, 1);
	local l__p__368 = p140._sprintposespring.p;
	local v369 = 0;
	local v370 = Vector3.new();
	local v371 = Vector3.new();
	local v372 = Vector3.new();
	local v373 = Vector3.new();
	local v374 = Vector3.new();
	local v375 = Vector3.new();
	p140._blackScoped = false;
	local l__next__376 = next;
	local v377, v378 = p140:getActiveAimStats();
	while true do
		local v379, v380 = l__next__376(v377, v378);
		if not v379 then
			break;
		end;
		v378 = v379;
		local l__p__381 = v380.sightaimspring.p;
		v370 = v370 + l__p__381 * v380.aimoffsetp;
		v371 = v371 + l__p__381 * v380.aimoffsetr;
		v372 = v372 + l__p__381 * v380.larmaimoffsetp;
		v373 = v373 + l__p__381 * v380.larmaimoffsetr;
		v374 = v374 + l__p__381 * v380.rarmaimoffsetp;
		v375 = v375 + l__p__381 * v380.rarmaimoffsetr;
		v369 = v369 + l__p__381;
		if v380.blackscope and v380.scopebegin < v380.sightmagspring.p then
			p140._blackScoped = true;
		end;	
	end;
	local l__C0__382 = p140._animData.larm.weld.C0;
	local v383 = u12.toaxisangle(l__C0__382);
	local l__C0__384 = p140._animData.rarm.weld.C0;
	local v385 = u12.toaxisangle(l__C0__384);
	p140:updateScope();
	local v386 = v11.getSteadySize();
	local v387 = l___characterObject__364:getMovementMode();
	if p140._blackScoped then
		local v388 = p140:getActiveAimStat("swayamp") and 0;
		if v387 == "stand" then
			v388 = v388 * (p140:getActiveAimStat("standswayampmult") and 1);
		end;
		v363:setSway(v388);
		if p140:getActiveAimStat("breathspeed") then
			if v386 < 1 and (not (not v26.keyboard.down.leftshift) or not (not v26.controller.down.up) or not (not v26.controller.down.l3) or p140._steadyToggle) then
				v363:setSwaySpeed(v387 == "stand" and p140:getActiveAimStat("standsteadyspeed") or 0);
				if v386 < 1 then
					local v389 = v386 + p141 * 60 * p140:getActiveAimStat("breathspeed") or v386;
				else
					v389 = v386;
				end;
				v11.setSteadyBar(UDim2.new(v389, 0, 1, 0));
			else
				p140._steadyToggle = false;
				local v390 = p140:getActiveAimStat("swayspeed") and 1;
				if v387 == "stand" then
					v390 = v390 * (p140:getActiveAimStat("standswayspeedmult") and 1);
				end;
				v363:setSwaySpeed(v390);
				v11.setSteadyBar(UDim2.new(v386 > 0 and v386 - p141 * 60 * p140:getActiveAimStat("recoverspeed") or 0, 0, 1, 0));
			end;
		end;
	else
		v363:setSwaySpeed(0);
		if v386 > 0 then
			local v391 = v386 - p141 * 60 * (p140:getActiveAimStat("recoverspeed") and 0.005) or 0;
		else
			v391 = 0;
		end;
		v11.setSteadyBar(UDim2.new(v391, 0, 1, 0));
	end;
	local v392 = CFrame.new(v370 * l__p__365) * u12.fromaxisangle(v371 * l__p__365);
	local v393 = CFrame.new(v372 + (1 - v369) * l__C0__382.p) * u12.fromaxisangle(v373 + (1 - v369) * v383);
	local v394 = CFrame.new(v374 + (1 - v369) * l__C0__384.p) * u12.fromaxisangle(v375 + (1 - v369) * v385);
	local v395 = p140._transkickspring.p;
	local v396 = p140._rotkickspring.p;
	if p140._experimentalRecoil then
		v395 = p140._translationRecoil:getPosition();
		v396 = p140._rotationRecoil:getPosition();
	end;
	local v397 = l___characterObject__364:getRootPart().CFrame:inverse() * v363:getShakeCFrame() * p140._mainOffset * p140._climbCF(l___characterObject__364:getSpring("climbing").p) * CFrame.new(v392.p) * CFrame.new(0, 0, 1) * u12.fromaxisangle(l___characterObject__364:getSpring("swingspring").v * ((p140:getActiveAimStat("blackscope") and math.max(0.2, 1 - l__p__366) or (p140:getActiveAimStat("midscope") and math.max(0.4, 1 - l__p__366) or math.max(0.6, 1 - l__p__366))) * (p140:isAiming() and p140:getWeaponStat("aimswingmod") or (p140:getWeaponStat("swingmod") or 1)))) * CFrame.new(0, 0, -1) * p140:walkSway(0.7 - 0.3 * l__p__366, 1 - 0.8 * l__p__366) * p140:gunSway(l__p__366) * p140._proneCF(l___characterObject__364:getSpring("pronespring").p * (1 - l__p__366)):Lerp(CFrame.new(), p140._reloadspring.p) * p140._crouchCF(l___characterObject__364:getSpring("crouchspring").p):Lerp(CFrame.new(), p140._reloadspring.p):Lerp(CFrame.new(), l__p__366) * p140._sprintCF(l__p__368):Lerp(p140:getWeaponStat("equipoffset"), l___characterObject__364:getSpring("equipspring").p) * u12.fromaxisangle(p140._spreadspring.p) * CFrame.new(v395) * u12.fromaxisangle(v396) * (v392 - v392.p) * p140._animData[p140:getWeaponStat("mainpart")].weld.C0;
	p140._mainWeld.C0 = v397;
	local v398, v399 = l___characterObject__364:getArmWelds();
	v398.C0 = v397 * l__C0__382:Lerp(v393, l__p__367):Lerp(p140:getWeaponStat("larmsprintoffset"), l__p__368);
	v399.C0 = v397 * l__C0__384:Lerp(v394, l__p__367):Lerp(p140:getWeaponStat("rarmsprintoffset"), l__p__368);
	p140.thread2:step();
	if l___characterObject__364:getSpring("climbing").t == 1 and p140:isAiming() then
		p140:setAim(false);
	end;
	if p140:getWeaponStat("restrictedads") and p140:isEquipped() and ((v26.mouse.down.right or v26.controller.down.l2) and not p140:isAiming() and v387 ~= "stand") then
		p140:setAim(true);
	end;
	p140:stepStateMachines(p141);
	p140:stepAttachments(p141);
	p140:fireRound(l__p__366);
	if p140._experimentalRecoil then
		p140._translationRecoil:step();
		p140._rotationRecoil:step();
	end;
end;
function v1._logStateTransition(p142, p143, p144, p145)
	p142._stateChangeTimes[p144] = p145;
end;
local l__currentCamera__26 = workspace.currentCamera;
function v1._processEquipStateChange(p146, p147, p148, p149)
	local v400 = v13.getActiveCamera("MainCamera");
	local l___characterObject__401 = p146._characterObject;
	if p148 == "equipped" then
		if v26.mouse.down.right or v26.controller.down.l2 then
			p146:setAim(true);
		end;
		if l___characterObject__401:isSprinting() then
			l___characterObject__401:getSpring("sprintspring").t = 1;
			return;
		end;
	elseif p148 == "equipping" then
		l___characterObject__401:setBaseWalkSpeed(p146:getWeaponStat("walkspeed"));
		l___characterObject__401:getSpring("zoommodspring").s = p146:getActiveAimStat("aimspeed");
		l___characterObject__401:getSpring("sprintspring").s = p146:getWeaponStat("sprintspeed");
		l___characterObject__401:getSpring("equipspring").s = p146:getWeaponStat("equipspeed");
		l___characterObject__401:getSpring("aimspring").s = p146:getActiveAimStat("aimspeed");
		l___characterObject__401:getSpring("equipspring").p = 1;
		l___characterObject__401:getSpring("equipspring").t = 0;
		v400:getSpring("swayspring").s = p146:getActiveAimStat("steadyspeed") and 4;
		v400:getSpring("magspring").s = p146:getActiveAimStat("magnifyspeed");
		v400:getSpring("shakespring").s = p146:getWeaponStat("camkickspeed");
		v400:setSwaySpeed(p146:getActiveAimStat("swayspeed") and 1);
		v400:setSway(0);
		if p146._experimentalRecoil then
			v400:setBodyRecoil(p146._recoilParameters.hipCameraBody, p146._recoilParameters.aimCameraBody, p146._recoilParameters.hipCameraBodyRecovery, p146._recoilParameters.aimCameraBodyRecovery);
		end;
		p146._armaimspring.s = p146:getActiveAimStat("aimspeed");
		p146._reloadspring.t = 0;
		v25.play("equipCloth", 0.25);
		v25.play("equipGear", 0.1);
		v22:send("equip", p146.weaponIndex);
		p146:setAim(false);
		p146:updateAimStats();
		p146:updateFiremodeStability();
		p146._inspecting = false;
		local l__next__402 = next;
		local v403, v404 = p146._mainPart:GetChildren();
		while true do
			local v405, v406 = l__next__402(v403, v404);
			if not v405 then
				break;
			end;
			v404 = v405;
			if v406:IsA("Weld") and (not v406.Part1 or v406.Part1.Parent ~= p146._weaponModel) then
				v406:Destroy();
			end;		
		end;
		p146._mainWeld.Part0 = l___characterObject__401:getRootPart();
		p146._mainWeld.Part1 = p146._mainPart;
		p146._mainWeld.Parent = p146._mainPart;
		l___characterObject__401.thread:clear();
		l___characterObject__401.reloading = false;
		if p146._boltOpen then
			p146._animData[p146:getWeaponStat("bolt")].weld.C0 = p146._boltCF(1);
		else
			p146._animData[p146:getWeaponStat("bolt")].weld.C0 = p146._boltCF(0);
		end;
		v3.setCrossSettings(p146:getWeaponStat("type"), p146:getWeaponStat("crosssize"), p146:getWeaponStat("crossspeed"), p146:getWeaponStat("crossdamper"), p146:getActiveAimStat("sightpart"), p146:getActiveAimStat("centermark"));
		v9.updateFiremode(p146);
		v9.updateAmmo(p146);
		l___characterObject__401.thread:add(v18.reset(p146._animData, 0, p146:getWeaponStat("keepanimvisibility")));
		l___characterObject__401.thread:add(function()
			p146._weaponModel.Parent = l__currentCamera__26;
		end);
		return;
	else
		if p148 == "unequipped" then
			v400:magnify(1);
			p146._mainWeld.Part1 = nil;
			p146._weaponModel.Parent = nil;
			p146._yieldToAnimation = false;
			l___characterObject__401.animating = false;
			return;
		end;
		if p148 == "unequipping" then
			local l__next__407 = next;
			local v408, v409 = p146._barrelPart:GetChildren();
			while true do
				local v410, v411 = l__next__407(v408, v409);
				if not v410 then
					break;
				end;
				v409 = v410;
				if v411:IsA("Sound") then
					v411:Stop();
				end;			
			end;
			p146._auto = false;
			if not p146:getWeaponStat("burstcam") then
				p146._burst = 0;
			end;
			if p146:isAiming() then
				p146:setAim(false);
			end;
			p146._inspecting = false;
			l___characterObject__401.reloading = false;
			l___characterObject__401:getSpring("equipspring").t = 1;
			if l___characterObject__401.animating then
				l___characterObject__401.thread:clear();
				l___characterObject__401.thread:add(v18.reset(p146._animData, 0.1, p146:getWeaponStat("keepanimvisibility")));
			end;
			v23:applyeffects(p146:getWeaponStat("effectsettings"), false);
		end;
	end;
end;
function v1._processChamberStateChange(p150, p151, p152, p153)
	local v412 = p150:getWeaponStat("animations");
	local l___characterObject__413 = p150._characterObject;
	local l___animData__414 = p150._animData;
	local l__thread__415 = l___characterObject__413.thread;
	if p152 == "chambering" then
		if p150._needRechambering then
			if v412.pullbolt then
				p150:playAnimation("pullbolt", false, true);
				return;
			else
				warn(string.format("Missing animation pullbolt on %s", p150._weaponName));
				return;
			end;
		end;
	elseif p152 == "chambered" then
		l__thread__415:add(function()
			if v26.mouse.down.right or v26.controller.down.l2 then
				p150:setAim(true);
			end;
		end);
		p150._boltOpen = false;
		if p150._canShoot then
			p150._canShoot = false;
			l___characterObject__413.animating = false;
			l___characterObject__413.reloading = false;
			return;
		end;
	else
		if p152 == "unchambered" then
			return;
		end;
		if p152 == "chamberCancelling" then
			if l___characterObject__413.animating then
				l__thread__415:clear();
				l__thread__415:add(v18.reset(p150._animData, p150._reloadCancelTime, p150:getWeaponStat("keepanimvisibility")));
			end;
			l___characterObject__413.animating = false;
			l___characterObject__413.reloading = false;
			return;
		end;
		if p152 == "chamberedReloading" or p152 == "unchamberedReloading" then
			local l__reloadName__416 = p150:getCurrentReloadFile().reloadName;
			l___characterObject__413.animating = true;
			l___characterObject__413.reloading = true;
			p150._yieldToAnimation = false;
			p150._burst = 0;
			p150._auto = false;
			p150._inspecting = false;
			p150._reloadspring.t = 1;
			l__thread__415:add(v18.player(p150._animData, v412[l__reloadName__416], p150._weaponName, l__reloadName__416));
			return;
		end;
		if p152 == "chamberedReloadCancelling" or p152 == "unchamberedReloadCancelling" then
			if p152 == "unchamberedReloadCancelling" then
				p150._needRechambering = true;
			end;
			l__thread__415:clear();
			l__thread__415:add(v18.reset(p150._animData, p150._reloadCancelTime, p150:getWeaponStat("keepanimvisibility")));
			l___characterObject__413.reloading = false;
			l___characterObject__413.animating = false;
			l__thread__415:add(function()
				l___characterObject__413.animating = false;
				p150._yieldToAnimation = false;
				l___characterObject__413:setSprint(v26.keyboard.down.leftshift or (v26.keyboard.down.w and l___characterObject__413.doubletap or p150._wasSprinting));
				if l___characterObject__413:isSprinting() then
					l___characterObject__413:getSpring("sprintspring").t = 1;
				end;
				if v26.mouse.down.right or v26.controller.down.l2 then
					p150:setAim(true);
				end;
			end);
			return;
		elseif p152 == "chamberedReloadCancelResetting" or p152 == "unchamberedReloadCancelResetting" then
			l___characterObject__413.reloading = false;
			l___characterObject__413.animating = false;
			l__thread__415:clear();
			l__thread__415:add(v18.reset(p150._animData, p150._reloadCancelTime, p150:getWeaponStat("keepanimvisibility")));
		end;
	end;
end;
function v1._printStates(p154)
	print("FirearmObject: ", p154._weaponName, "Equipped state:", p154._equipState:getState());
	print("FirearmObject: ", p154._weaponName, "Chambered state:", p154._chamberState:getState());
	print(p154._characterObject.animating, p154._yieldToAnimation, p154._characterObject:getSpring("sprintspring").t);
end;
return v1;

