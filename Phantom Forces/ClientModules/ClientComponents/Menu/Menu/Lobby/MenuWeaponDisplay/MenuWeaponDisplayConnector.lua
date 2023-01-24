
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("PageLoadoutMenuEvents");
local u2 = shared.require("MenuWeaponDisplayInterface");
local u3 = shared.require("ActiveLoadoutEvents");
function v1._init()
	u1.onWeaponStatsChanged:connect(function()
		u2.updateWeaponModel();
	end);
	u1.onForcedWeaponModelUpdate:connect(function()
		u2.updateWeaponModel();
	end);
	u2.updateWeaponModel();
	u3.onWeaponClassChanged:connect(u2.clearPreview);
	u3.onClassChanged:connect(u2.clearPreview);
end;
return v1;

