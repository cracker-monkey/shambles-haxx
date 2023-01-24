
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = nil;
function v1.getController()
	return u1;
end;
local u2 = shared.require("WeaponControllerObject");
function v1.spawn(...)
	if u1 then
		u1:Destroy();
	end;
	u1 = u2.new(...);
end;
function v1.despawn()
	if u1 then
		u1:Destroy();
		u1 = nil;
	end;
end;
local u3 = shared.require("CharacterInterface");
function v1.step(p1)
	if not u3.isAlive() then
		return;
	end;
	if u1 then
		u1:step(p1);
	end;
end;
local u4 = shared.require("RenderSteppedRunner");
local u5 = shared.require("CharacterEvents");
local u6 = shared.require("network");
function v1._init()
	u4:addTask("WeaponControllerInterface", v1.step, { "CharacterInterface", "particle", "CameraInterface" });
	u5.onSpawned:connect(function(p2, p3, p4, p5)
		v1.spawn(p4, p5);
	end);
	u5.onDespawned:connect(v1.despawn);
	u6:add("swapgun", function(p6, p7, p8, p9, p10, p11, p12, p13)
		if not u1 then
			warn("WeaponControllerInterface: No activeWeaponController found on swapgun", p6);
			return;
		end;
		u1:preparePickUpFirearm(p12, p6, p9, p10, p11, p7, p8, p13);
	end);
	u6:add("swapknife", function(p14, p15, p16)
		if not u1 then
			warn("WeaponControllerInterface: No activeWeaponController found on swapknife", p14);
			return;
		end;
		u1:preparePickUpMelee(p14, p15, p16);
	end);
	u6:add("swapfailed", function()
		u1:weaponPickupFailed();
	end);
	u6:add("addammo", function(p17, p18, p19)
		local v2 = u1:getWeaponObject(p17);
		if not v2 then
			return;
		end;
		if v2:getWeaponType() ~= "Firearm" then
			warn("WeaponControllerInterface: Attempt to add ammo to non-firearm", p17, v2);
			return;
		end;
		v2:addAmmo(p18, p19);
	end);
	u6:add("removeweapon", function(p20)
		u1:removeWeapon(p20);
	end);
end;
return v1;

