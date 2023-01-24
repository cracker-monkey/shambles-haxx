
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
v1.allowedMatchStartInputs = { "h", "q", "f", "one", "two", "three" };
local v3 = {};
local u1 = shared.require("CharacterInterface");
function v3.Jump(p1, p2)
	local v4 = u1.getCharacterObject();
	if p2 <= v4.nextjump then
		return;
	end;
	if v4:jump(4, p1) then
		v4.nextjump = p2 + 0.6666666666666666;
		return;
	end;
	v4.nextjump = p2 + 0.25;
end;
v3["Lower Stance"] = function(p3, p4)
	local v5 = u1.getCharacterObject();
	if v5:getSlideCondition() and not v5.dived then
		v5.sprintdisable = true;
		v5.dived = true;
		v5:setMovementMode("crouch", true);
		task.wait(0.2);
		v5.sprintdisable = false;
		task.wait(0.9);
		v5.dived = false;
		return;
	end;
	if v5:getMovementMode() == "crouch" then
		local v6 = "prone";
	else
		v6 = "crouch";
	end;
	v5:setMovementMode(v6);
end;
v3["Raise Stance"] = function(p5, p6)
	local v7 = u1.getCharacterObject();
	if not v7:isSprinting() or not (not v7.dived) then
		if v7.dived then
			return;
		else
			if v7:getMovementMode() == "crouch" then
				local v8 = "stand";
			else
				v8 = "crouch";
			end;
			v7:setMovementMode(v8);
			return;
		end;
	end;
	v7.sprintdisable = true;
	v7.dived = true;
	v7:setMovementMode("prone", true);
	task.wait(0.8);
	v7.sprintdisable = false;
	if v7:isSprinting() then
		v7:setSprint(true);
	end;
	task.wait(1.8);
	v7.dived = false;
end;
function v3.Slide(p7, p8)
	local v9 = u1.getCharacterObject();
	if not v9:getSlideCondition() or not (not v9.dived) then
		v9:setMovementMode("prone");
		return;
	end;
	v9.sprintdisable = true;
	v9.dived = true;
	v9:setMovementMode("crouch", true);
	task.wait(0.2);
	v9.sprintdisable = false;
	task.wait(0.9);
	v9.dived = false;
end;
function v3.Dive(p9, p10)
	local v10 = u1.getCharacterObject();
	if not v10:isSprinting() or not (not v10.dived) then
		if v10.dived then
			return;
		else
			v10:setMovementMode("stand");
			return;
		end;
	end;
	v10.sprintdisable = true;
	v10.dived = true;
	v10:setMovementMode("prone", true);
	task.wait(0.8);
	v10.sprintdisable = false;
	task.wait(1.8);
	v10.dived = false;
end;
v3["Reload Weapon"] = function(p11, p12)
	local v11 = p11:getActiveWeapon();
	if v11:getWeaponType() ~= "Firearm" then
		return;
	end;
	if v11:isEquipping() or v11:isUnequipping() then
		return;
	end;
	v11:reload();
end;
local u2 = shared.require("HudSpottingInterface");
function v3.Spotting(p13, p14)
	local v12 = nil;
	local v13 = u1.getCharacterObject();
	v12 = p13:getActiveWeapon();
	if v13.spotting or v12:getWeaponType() == "Grenade" then
		return;
	end;
	v13.spotting = true;
	if u2.spot() then
		v12:playAnimation("spot");
	end;
	task.wait(1);
	v13.spotting = false;
end;
v3["Quick Melee Action"] = function(p15, p16)
	local v14 = u1.getCharacterObject();
	local v15 = p15:getActiveWeapon();
	if v15:isEquipping() or v15:isUnequipping() then
		return;
	end;
	if v15:getWeaponType() == "Melee" then
		v15:shoot();
		return;
	end;
	p15:getWeaponObject(3).quick = true;
	p15:swapWeapon(p16, 3);
end;
v3["Quick Throw Action"] = function(p17, p18)
	local v16 = u1.getCharacterObject();
	local v17 = p17:getActiveWeapon();
	if v17:isEquipping() or v17:isUnequipping() then
		return;
	end;
	if v17:getWeaponType() == "Grenade" then
		return;
	end;
	local v18 = p17:getWeaponObject(4);
	if v18:getSpareCount() <= 0 then
		return;
	end;
	v18.quick = true;
	p17:swapWeapon(p18, 4);
end;
v3["Inspect Weapon"] = function(p19, p20)
	local v19 = p19:getActiveWeapon();
	if not (not v19:isEquipping()) or not (not v19:isUnequipping()) or u1.getCharacterObject().spotting then
		return;
	end;
	if v19:getWeaponType() == "Grenade" then
		return;
	end;
	if v19:getWeaponType() == "Firearm" and v19:isBlackScope() then
		return;
	end;
	if v19:isInspecting() then
		return;
	end;
	v19:playAnimation("inspect");
end;
local u3 = shared.require("PlayerSettingsInterface");
function v3.Sprint(p21, p22)
	local v20 = u1.getCharacterObject();
	local v21 = p21:getActiveWeapon();
	if v20.sprintdisable then
		return;
	end;
	if v21:getWeaponType() == "Firearm" and v21:isAiming() and v21:isBlackScope() then
		return;
	end;
	if not u3.getValue("togglesprinttoggle") then
		v20:setSprint(true);
		return;
	end;
	v20:setSprint(not v20:isSprinting());
end;
v3["Double Tap Sprint"] = function(p23, p24)
	if not u3.getValue("toggledoubletap") then
		return;
	end;
	local v22 = u1.getCharacterObject();
	local v23 = p23:getActiveWeapon();
	if not v22.doubletap and not v22:isSprinting() then
		spawn(function()
			v22.doubletap = true;
			task.wait(0.2);
			v22.doubletap = false;
		end);
		return;
	end;
	if v22.doubletap then
		if v23:getWeaponType() == "Firearm" and v23:isAiming() and v23:isBlackScope() then
			return;
		end;
		if v22.sprintdisable then
			return;
		end;
		v22:setSprint(true);
	end;
end;
v3["Aim Toggle"] = function(p25, p26)
	local v24 = p25:getActiveWeapon();
	if v24:getWeaponType() ~= "Firearm" then
		return;
	end;
	if v24:isEquipping() or v24:isUnequipping() then
		return;
	end;
	if v24:isInspecting() then
		v24:cancelAnimation();
	end;
	v24:setAim(not v24:isAiming());
end;
v3["Alt Aim Toggle"] = function(p27, p28)
	local v25 = p27:getActiveWeapon();
	if v25:getWeaponType() ~= "Firearm" then
		return;
	end;
	v25:toggleSight();
end;
local u4 = shared.require("HudInteractionInterface");
local u5 = shared.require("input");
v3["Interact Action"] = function(p29, p30)
	local v26 = u1.getCharacterObject();
	local v27 = p29:getActiveWeapon();
	if v27:isEquipping() or v27:isUnequipping() then
		return;
	end;
	if v27:getWeaponType() == "Grenade" then
		return;
	end;
	if u4.isInteracting() then
		task.delay(0.15, function()
			if not u5.keyboard.down.v then
				return;
			end;
			local v28 = 8;
			local v29 = nil;
			local v30 = nil;
			local l__next__31 = next;
			local v32, v33 = workspace.Ignore.GunDrop:GetChildren();
			while true do
				local v34, v35 = l__next__31(v32, v33);
				if not v34 then
					break;
				end;
				v33 = v34;
				if v35.Name == "Dropped" then
					local l__Magnitude__36 = (v35.Slot1.Position - v26:getRootPart().Position).Magnitude;
					if l__Magnitude__36 < v28 then
						if v35:FindFirstChild("Gun") then
							v28 = l__Magnitude__36;
							v29 = v35;
						elseif v35:FindFirstChild("Knife") then
							v28 = l__Magnitude__36;
							v30 = v35;
						end;
					end;
				end;			
			end;
			if v29 then
				p29:requestPickUpFirearm(v29);
				return;
			end;
			if v30 then
				p29:requestPickUpMelee(v30);
			end;
		end);
		return;
	end;
	if v27:getWeaponType() == "Firearm" then
		v27:nextFiremode();
	end;
end;
v3["Equip Primary"] = function(p31, p32)
	p31:swapWeapon(p32, 1);
end;
v3["Equip Secondary"] = function(p33, p34)
	p33:swapWeapon(p34, 2);
end;
v3["Equip Melee"] = function(p35, p36)
	p35:swapWeapon(p36, 3);
end;
local u6 = nil;
local u7 = shared.require("InstanceType");
v3["Force Respawn"] = function(p37, p38)
	if u6 or u5.keyboard.down.leftshift then
		return;
	end;
	u6 = true;
	u1.despawn();
	if not u7.IsTest() and not u7.IsVIP() then
		local v37 = game:GetService("ReplicatedStorage"):WaitForChild("Misc").RespawnGui.Title:Clone();
		v37.Parent = l__LocalPlayer__2.PlayerGui:FindFirstChild("MainGui");
		for v38 = 5, 0, -1 do
			if not u7.IsStudio() then
				v37.Count.Text = v38;
				task.wait(1);
			end;
		end;
		v37:Destroy();
	end;
	u6 = false;
end;
local u8 = shared.require("superusers")[l__LocalPlayer__2.UserId];
v3["Mouse Lock Toggle"] = function(p39, p40)
	if not u8 then
		return;
	end;
	if u5.mouse:visible() then
		u5.mouse:hide();
		u5.mouse:lockcenter();
		return;
	end;
	u5.mouse:show();
	u5.mouse:free();
end;
v3["Sprint End"] = function(p41, p42)
	local v39 = u1.getCharacterObject();
	if not u3.getValue("togglesprinttoggle") then
		v39:setSprint(false);
	end;
end;
v3["Double Tap Sprint End"] = function(p43, p44)
	if u5.keyboard.down.leftshift then
		return;
	end;
	local v40 = u1.getCharacterObject();
	if not u3.getValue("togglesprinttoggle") then
		v40:setSprint(false);
	end;
end;
v1.keyActionMapping = v3;
local v41 = {
	["Lower Stance"] = function(p45, p46)
		local v42 = u1.getCharacterObject();
		if v42:getMovementMode() == "crouch" then
			v42:setMovementMode("prone");
			return;
		end;
		if not v42:getSlideCondition() or not (not v42.dived) then
			v42:setMovementMode("crouch");
			return;
		end;
		v42.dived = true;
		v42:setMovementMode("crouch", true);
		task.wait(0.2);
		v42.sprintdisable = false;
		task.wait(0.9);
		v42.dived = false;
	end, 
	["Shoot Weapon"] = function(p47, p48)
		local v43 = p47:getActiveWeapon();
		local v44 = v43:getWeaponType();
		if v44 == "Firearm" then
			v43:shoot(true);
			return;
		end;
		if v44 == "Melee" then
			v43:shoot("stab1");
			return;
		end;
		if v44 == "Grenade" then

		end;
	end, 
	["Aim Weapon"] = function(p49, p50)
		local v45 = p49:getActiveWeapon();
		local v46 = v45:getWeaponType();
		if v46 == "Firearm" then
			v45:setAim(true);
			return;
		end;
		if v46 == "Melee" then
			v45:shoot("stab2");
			return;
		end;
		if v46 == "Grenade" then

		end;
	end, 
	["Dive/Spotting"] = function(p51, p52)
		local v47 = u1.getCharacterObject();
		local v48 = p51:getActiveWeapon();
		if v47:isSprinting() and not v47.dived then
			v47.dived = true;
			v47.sprintdisable = true;
			v47:setMovementMode("prone", true);
			task.wait(0.8);
			v47.sprintdisable = false;
			task.wait(1.8);
			v47.dived = false;
			return;
		end;
		if v47.spotting or v48:getWeaponType() == "Grenade" then
			return;
		end;
		v47.spotting = true;
		if u2.spot() then
			v48:playAnimation("spot");
		end;
		task.wait(1);
		v47.spotting = false;
	end
};
local u9 = nil;
local u10 = nil;
v41["Pick Up Weapon"] = function(p53, p54)
	local v49 = u1.getCharacterObject();
	local v50 = p53:getActiveWeapon();
	if v50:isEquipping() or v50:isUnequipping() then
		return;
	end;
	if v50:getWeaponType() == "Grenade" then
		return;
	end;
	u9 = false;
	u10 = false;
	if u4.isInteracting() then
		task.delay(0.2, function()
			if not u5.controller.down.y then
				return;
			end;
			u9 = true;
			local v51 = 8;
			local v52 = nil;
			local v53 = nil;
			local l__next__54 = next;
			local v55, v56 = workspace.Ignore.GunDrop:GetChildren();
			while true do
				local v57, v58 = l__next__54(v55, v56);
				if not v57 then
					break;
				end;
				v56 = v57;
				if v58.Name == "Dropped" then
					local l__Magnitude__59 = (v58.Slot1.Position - v49:getRootPart().Position).Magnitude;
					if l__Magnitude__59 < v51 then
						if v58:FindFirstChild("Gun") then
							v51 = l__Magnitude__59;
							v52 = v58;
						elseif v58:FindFirstChild("Knife") then
							v51 = l__Magnitude__59;
							v53 = v58;
						end;
					end;
				end;			
			end;
			if v52 then
				p53:requestPickUpFirearm(v52);
				return;
			end;
			if v53 then
				p53:requestPickUpMelee(v53);
			end;
		end);
		return;
	end;
	task.delay(0.2, function()
		if not u5.controller.down.y or v50:getWeaponType() ~= "Firearm" then
			return;
		end;
		u10 = true;
		p53:swapWeapon(p54, 3);
	end);
end;
function v41.Sprint(p55, p56)
	local v60 = u1.getCharacterObject();
	local v61 = p55:getActiveWeapon();
	if v61:getWeaponType() == "Firearm" and v61:isAiming() and v61:isBlackScope() then
		v60.steadytoggle = not v60.steadytoggle;
		return;
	end;
	if not v60.sprintdisable then
		v60:setSprint(not v60:isSprinting());
	end;
end;
v41["Force Respawn"] = function(p57, p58)
	if u6 then
		return;
	end;
	u6 = true;
	for v62 = 1, 20 do
		task.wait(0.1);
		if not u6 then
			return;
		end;
	end;
	if u6 then
		u6 = false;
		u1.despawn();
	end;
end;
v41["Shoot Weapon End"] = function(p59, p60)
	local v63 = p59:getActiveWeapon();
	if v63:getWeaponType() == "Firearm" then
		v63:shoot(false);
	end;
end;
v41["Swap Weapon"] = function(p61, p62)
	if u9 or u10 then
		return;
	end;
	p61:swapWeapon(p62, p61:getActiveWeaponIndex() % 2 + 1);
end;
v41["Unaim Weapon"] = function(p63, p64)
	local v64 = p63:getActiveWeapon();
	if v64:getWeaponType() == "Firearm" and v64:isAiming() then
		v64:setAim(false);
	end;
end;
v41["Force Respawn Cancel"] = function(p65, p66)
	u6 = false;
end;
v1.controllerActionMapping = v41;
v1.keyDownMapping = {
	space = "Jump", 
	c = "Lower Stance", 
	x = "Raise Stance", 
	leftcontrol = "Slide", 
	z = "Dive", 
	r = "Reload Weapon", 
	e = "Spotting", 
	f = "Quick Melee Action", 
	g = "Quick Throw Action", 
	h = "Inspect Weapon", 
	leftshift = "Sprint", 
	w = "Double Tap Sprint", 
	q = "Aim Toggle", 
	t = "Alt Aim Toggle", 
	v = "Interact Action", 
	one = "Equip Primary", 
	two = "Equip Secondary", 
	three = "Equip Melee", 
	f5 = "Force Respawn", 
	f8 = "Force Respawn", 
	m = "Mouse Lock Toggle"
};
v1.keyUpMapping = {
	leftshift = "Sprint End", 
	w = "Double Tap Sprint End"
};
v1.controllerDownMapping = {
	b = "Lower Stance", 
	r2 = "Shoot Weapon", 
	l2 = "Aim Weapon", 
	l1 = "Dive/Spotting", 
	l3 = "Sprint", 
	y = "Pick Up Weapon", 
	select = "Force Respawn"
};
v1.controllerUpMapping = {
	r2 = "Shoot Weapon End", 
	y = "Swap Weapon", 
	l2 = "Unaim Weapon", 
	select = "Force Respawn Cancel"
};
return v1;

