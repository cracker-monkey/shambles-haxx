
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = {
	title = "OPEN CASE"
};
local u1 = shared.require("PageInventoryDisplayOpenCase");
function v2.func(p1)
	u1.startRollSetup(p1.Name, p1.Weapon);
end;
local v3 = {
	title = "ASSIGN WEAPON"
};
local u2 = shared.require("PageInventoryDisplayAssignCase");
function v3.func(p2)
	u2.selectCase(p2.Name, "DisplayInventory");
end;
local u3 = shared.require("PlayerPolicy");
function v3.conditionFunc(p3)
	if not u3:isReady() and not u3:canPurchaseRandomItems() then
		return false;
	end;
	return not p3.Weapon;
end;
v1[1] = v2;
v1[2] = v3;
return v1;

