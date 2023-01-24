
-- Decompiled with the Synapse X Luau decompiler.

return function(p1)
	local v1 = p1:getWeaponStat("clipsize");
	local v2 = p1:getWeaponStat("magsize") - p1:getMagCount();
	return { {
			reloadName = "ReloadClip", 
			magCountChange = v1, 
			repetitionCount = math.floor(v2 / v1)
		}, {
			reloadName = "ReloadSingle", 
			magCountChange = 1, 
			repetitionCount = v2 % v1
		} };
end;

