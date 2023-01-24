
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("PlayerSettingsInterface");
local u1 = shared.require("Destructor");
local u2 = shared.require("GameClock");
local u3 = shared.require("PlayerDataStoreClient");
local u4 = shared.require("ActiveLoadoutUtils");
local u5 = shared.require("FirearmObject");
local u6 = shared.require("MeleeObject");
local u7 = shared.require("GrenadeObject");
local u8 = shared.require("WeaponControllerEvents");
local u9 = shared.require("input");
local u10 = shared.require("GameRoundInterface");
local u11 = shared.require("WeaponControllerConfig");
local u12 = shared.require("CharacterInterface");
local l__RunService__13 = game:GetService("RunService");
local u14 = shared.require("HudCrosshairsInterface");
local u15 = shared.require("CameraInterface");
function v1.new(p1, p2)
	local v3 = setmetatable({}, v1);
	v3._destructor = u1.new();
	v3._activeWeaponRegistry = {};
	v3._activeWeaponIndex = 1;
	v3._nextWeaponIndex = nil;
	v3._lastweaponIndex = nil;
	v3._lastFirearmWeaponIndex = 1;
	v3._pickUpFirearm = nil;
	v3._pickUpMelee = nil;
	v3._pickUpRejected = nil;
	v3._debounceAmmoPickup = u2.getTime();
	local v4 = u4.getActiveLoadoutData((u3.getPlayerData()));
	local l__Primary__5 = p1.Primary;
	local l__Secondary__6 = p1.Secondary;
	local l__Knife__7 = p1.Knife;
	local l__Grenade__8 = p1.Grenade;
	v3._activeWeaponRegistry[1] = u5.new(1, l__Primary__5.Name, l__Primary__5.Attachments, p2[l__Primary__5.Name] or {}, l__Primary__5.Camo);
	if l__Secondary__6 then
		v3._activeWeaponRegistry[2] = u5.new(2, l__Secondary__6.Name, l__Secondary__6.Attachments, p2[l__Secondary__6.Name] or {}, l__Secondary__6.Camo);
	end;
	v3._activeWeaponRegistry[3] = u6.new(3, l__Knife__7.Name, l__Knife__7.Camo);
	v3._activeWeaponRegistry[4] = u7.new(4, l__Grenade__8.Name, l__Grenade__8.Camo);
	v3._destructor:add(function()
		for v9, v10 in next, v3._activeWeaponRegistry do
			v10:Destroy();
		end;
	end);
	v3._destructor:add(u8.onControllerFlag:connect(function(...)
		v3:_handleFlag(...);
	end));
	v3._destructor:add(u9.mouse.onbuttondown:connect(function(p3)
		local v11 = nil;
		local v12 = v3:getActiveWeapon();
		if v12:isEquipping() or v12:isUnequipping() then
			return;
		end;
		v11 = v12:getWeaponType();
		if p3 == "left" then
			if v11 == "Firearm" then
				v12:shoot(true);
				return;
			end;
			if v11 == "Melee" then
				v12:shoot("stab1");
				return;
			end;
			if v11 == "Grenade" then
				return;
			end;
		elseif p3 == "right" then
			if v11 == "Firearm" then
				v12:setAim(true);
				return;
			end;
			if v11 == "Melee" then
				v12:shoot("stab2");
				return;
			end;
			if v11 == "Grenade" then

			end;
		end;
	end));
	v3._destructor:add(u9.mouse.onscroll:connect(function(p4)
		if v3._activeWeaponIndex == 1 then
			local v13 = 2;
		elseif v3._activeWeaponIndex == 2 then
			v13 = 1;
		else
			v13 = v3._lastFirearmWeaponIndex;
		end;
		v3:swapWeapon(u2.getTime(), v13);
	end));
	v3._destructor:add(u9.mouse.onbuttonup:connect(function(p5)
		local v14 = v3:getActiveWeapon();
		if v14:isEquipping() or v14:isUnequipping() then
			return;
		end;
		if v14:getWeaponType() ~= "Firearm" then
			return;
		end;
		if p5 == "left" then
			v14:shoot(false);
			return;
		end;
		if p5 == "right" then
			v14:setAim(false);
		end;
	end));
	v3._destructor:add(u9.keyboard.onkeydown:connect(function(p6)
		if u10.roundLock and not table.find(u11.allowedMatchStartInputs, p6) then
			return;
		end;
		if not u12.isAlive() then
			return;
		end;
		if l__RunService__13:IsStudio() then
			u9.mouse:lockcenter();
		end;
		local v15 = u2.getTime();
		local v16 = u11.keyActionMapping[u11.keyDownMapping[p6]];
		if v16 then
			v16(v3, v15);
		end;
	end));
	v3._destructor:add(u9.keyboard.onkeyup:connect(function(p7)
		if u10.roundLock and not table.find(u11.allowedMatchStartInputs, p7) then
			return;
		end;
		local v17 = u2.getTime();
		local v18 = u11.keyActionMapping[u11.keyUpMapping[p7]];
		if v18 then
			v18(v3, v17);
		end;
	end));
	u9.controller:map("a", "space");
	u9.controller:map("x", "r");
	u9.controller:map("r1", "g");
	u9.controller:map("up", "h");
	u9.controller:map("r3", "f");
	u9.controller:map("right", "v");
	u9.controller:map("down", "e");
	u9.controller:map("left", "t");
	v3._destructor:add(u9.controller.onbuttondown:connect(function(p8)
		if u10.roundLock then
			return;
		end;
		local v19 = u2.getTime();
		local v20 = u11.controllerActionMapping[u11.controllerDownMapping[p8]];
		if v20 then
			v20(v3, v19);
		end;
	end));
	v3._destructor:add(u9.controller.onbuttonup:connect(function(p9)
		if u10.roundLock then
			return;
		end;
		local v21 = u2.getTime();
		local v22 = u11.controllerActionMapping[u11.controllerUpMapping[p9]];
		if v22 then
			v22(v3, v21);
		end;
	end));
	u14.setEquipState(true);
	v3:getActiveWeapon():equip();
	u15.getActiveCamera("MainCamera"):setAimSensitivity(false);
	return v3;
end;
function v1.Destroy(p10)
	p10._destructor:Destroy();
end;
function v1.getActiveWeapon(p11)
	return p11._activeWeaponRegistry[p11._activeWeaponIndex];
end;
function v1.getActiveWeaponIndex(p12)
	return p12._activeWeaponIndex;
end;
function v1.getWeaponObject(p13, p14)
	local v23 = p13._activeWeaponRegistry[p14];
	if v23 then
		return v23;
	end;
	warn("PlayerLoadoutObject: No weaponObject found for", p14);
end;
function v1.activeWeaponInput(p15, p16, p17)
	return p15:getActiveWeapon():fireInput(p16, p17);
end;
function v1.executeNextWeaponIndex(p18, p19)
	p18._lastWeaponIndex = p18._activeWeaponIndex;
	p18._activeWeaponIndex = p18._nextWeaponIndex;
	p18._nextWeaponIndex = nil;
	if p18._activeWeaponIndex == 1 or p18._activeWeaponIndex == 2 then
		p18._lastFirearmWeaponIndex = p18._activeWeaponIndex;
	end;
	if p18._awaitingPickUp then
		spawn(function()
			while p18._awaitingPickUp and u12.isAlive() do
				if p18._pickUpFirearm then
					local l___pickUpFirearm__24 = p18._pickUpFirearm;
					p18._activeWeaponRegistry[l___pickUpFirearm__24.weaponIndex]:Destroy();
					p18._activeWeaponRegistry[l___pickUpFirearm__24.weaponIndex] = l___pickUpFirearm__24;
					u14.setEquipState(true);
					l___pickUpFirearm__24:equip();
					p18._pickUpFirearm = nil;
					p18._awaitingPickUp = nil;
				elseif p18._pickUpMelee then
					local l___pickUpMelee__25 = p18._pickUpMelee;
					p18._activeWeaponRegistry[3]:Destroy();
					p18._activeWeaponRegistry[3] = l___pickUpMelee__25;
					u14.setEquipState(true);
					l___pickUpMelee__25:equip();
					p18._pickUpMelee = nil;
					p18._awaitingPickUp = nil;
				elseif p18._pickUpRejected then
					u14.setEquipState(true);
					p18._activeWeaponRegistry[p18._activeWeaponIndex]:equip();
					p18._pickUpRejected = nil;
					p18._awaitingPickUp = nil;
				end;
				task.wait();			
			end;
		end);
		return;
	end;
	if not u12.isAlive() then
		error("Player not alive while trying to equip weapon [2]");
	end;
	local v26 = p18:getActiveWeapon();
	u14.setEquipState(true);
	v26:equip();
end;
function v1.removeWeapon(p20, p21)
	local v27 = p20._activeWeaponRegistry[p21];
	if v27 then
		v27:Destroy();
	end;
	p20._activeWeaponRegistry[p21] = nil;
end;
local l__LocalPlayer__16 = game:GetService("Players").LocalPlayer;
function v1.swapWeapon(p22, p23, p24, p25)
	if p22._awaitingPickUp then
		return;
	end;
	if #p22._activeWeaponRegistry < p24 then
		warn("PlayerLoadoutObject: Attempt to equip invalid weapon slot", p24, "for", l__LocalPlayer__16);
		return;
	end;
	if not p22._activeWeaponRegistry[p24] then
		return;
	end;
	if p22._activeWeaponIndex == p24 and not p25 then
		return;
	end;
	p22._nextWeaponIndex = p24;
	local v28 = p22:getActiveWeapon();
	u14.setEquipState(false);
	v28:unequip();
end;
local u17 = shared.require("network");
function v1.requestPickUpFirearm(p26, p27)
	local v29 = p26._activeWeaponIndex;
	if p26._activeWeaponIndex > 2 then
		v29 = 2;
	end;
	p26:swapWeapon(u2.getTime(), v29, true);
	p26._awaitingPickUp = true;
	u17:send("swapweapon", p27, v29);
end;
function v1.requestPickUpMelee(p28, p29)
	p28:swapWeapon(u2.getTime(), 3, true);
	p28._awaitingPickUp = true;
	u17:send("swapweapon", p29, 3);
end;
function v1.preparePickUpFirearm(p30, p31, p32, p33, p34, p35, p36, p37, p38)
	if p38 then
		p30:swapWeapon(u2.getTime(), p31, true);
		p30._awaitingPickUp = true;
	end;
	p30._pickUpFirearm = u5.new(p31, p32, p33, p34, p35, p36, p37, p38);
end;
function v1.preparePickUpMelee(p39, p40, p41, p42)
	p39._pickUpMelee = u6.new(3, p40, p41);
end;
function v1.weaponPickupFailed(p43)
	p43._pickUpRejected = true;
end;
local u18 = shared.require("HudInteractionInterface");
local u19 = shared.require("ContentDatabase");
function v1.checkDroppedWeapon(p44, p45, p46)
	if not p45 then
		u18.updateInteraction("");
		return;
	end;
	local v30 = u19.getWeaponData(p46);
	if not v30 then
		return;
	end;
	local v31 = p44:getActiveWeapon();
	if u9.getInputType() == "controller" then
		local v32 = "Hold Y";
	else
		v32 = "Hold V";
	end;
	u18.updateInteraction(v32 .. " to pick up [" .. (v30.displayname and p46) .. "]");
	if v30.type == v31:getWeaponStat("type") or v30.ammotype == v31:getWeaponStat("ammotype") then
		local v33 = u2.getTime();
		if p44._debounceAmmoPickup < v33 then
			local v34, v35 = v31:getDropInfo();
			if v35 and v35 < v31:getWeaponStat("sparerounds") then
				p44._debounceAmmoPickup = v33 + 1;
				u17:send("getammo", p45);
			end;
		end;
	end;
end;
local l__GunDrop__20 = workspace.Ignore.GunDrop;
local u21 = shared.require("HudStatusInterface");
function v1.step(p47, p48)
	local v36 = u15.getActiveCamera("MainCamera");
	if not v36 then
		return;
	end;
	local v37 = u12.getCharacterObject();
	if not v37 then
		return;
	end;
	local v38 = v37:getRootPart();
	local l__p__39 = v37:getSpring("zoommodspring").p;
	local v40 = 1;
	local v41 = 1;
	local v42 = false;
	local v43 = math.tan(v36:getBaseFov() * math.pi / 360) / math.tan(v37.unaimedfov * math.pi / 360);
	for v44 = 1, 2 do
		local v45 = p47._activeWeaponRegistry[v44];
		if v45 then
			local v46 = v45:getActiveAimStats();
			for v47 = 1, #v46 do
				local v48 = v46[v47];
				local l__p__49 = v48.sightmagspring.p;
				if v48.blackscope then
					if v48.scopebegin < l__p__49 then
						v41 = v48.zoom;
						v42 = true;
					end;
					v40 = v40 * (v48.prezoom / v43) ^ l__p__49;
				else
					v40 = v40 * (v48.zoom / v43) ^ l__p__49;
				end;
			end;
		end;
	end;
	if v42 then
		v36:setMagnification(v41);
	else
		v36:setMagnification(v43 * v40 ^ l__p__39);
	end;
	p47:getActiveWeapon():step(p48);
	if u9.controller.down.b and (u9.controller.down.b + 0.5 < u2.getTime() and v37:getMovementMode() ~= "prone") then
		v37:setMovementMode("prone");
	end;
	local v50 = 8;
	p47:checkDroppedWeapon(false);
	local l__next__51 = next;
	local v52, v53 = l__GunDrop__20:GetChildren();
	while true do
		local v54, v55 = l__next__51(v52, v53);
		if not v54 then
			break;
		end;
		v53 = v54;
		if v55.Name == "Dropped" and v55:FindFirstChild("Slot1") then
			local l__magnitude__56 = (v55.Slot1.Position - v38.Position).magnitude;
			if l__magnitude__56 < v50 then
				v50 = l__magnitude__56;
				if v55:FindFirstChild("Gun") then
					p47:checkDroppedWeapon(v55, v55.Gun.Value);
				elseif v55:FindFirstChild("Knife") then
					p47:checkDroppedWeapon(v55, v55.Knife.Value);
				end;
			end;
		end;	
	end;
	u21.step(p47);
end;
function v1._handleFlag(p49, p50, p51, p52)
	if p51 == "equipFlag" then
		if not p49:activeWeaponInput("equipFinish", p52) then
			return;
		end;
	elseif p51 == "unequipFlag" then
		if not p49:activeWeaponInput("unequipFinish", p52) then
			return;
		end;
		p49:executeNextWeaponIndex(p52);
	end;
	if p51 == "firearmEquipFlag" then
		p49:swapWeapon(p52, p49._lastFirearmWeaponIndex);
		return;
	end;
	if p51 == "lastEquipFlag" then
		p49:swapWeapon(p52, p49._lastWeaponIndex);
	end;
end;
return v1;

