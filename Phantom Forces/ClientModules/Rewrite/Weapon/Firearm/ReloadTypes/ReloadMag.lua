
-- Decompiled with the Synapse X Luau decompiler.

return function(p1)
	local v1 = p1:getMagCount();
	if v1 == 0 then
		local v2 = (p1:getWeaponStat("altreloadlong") and "") .. "reload";
	else
		v2 = (p1:getWeaponStat("altreload") and "") .. "tacticalreload";
	end;
	if not p1:getWeaponStat("animations")[v2] then
		warn("ReloadMag: No reload animation found for", v2);
		if v1 == 0 then
			local v3 = "reload";
		else
			v3 = "tacticalreload";
		end;
		v2 = v3;
	end;
	return { {
			reloadName = v2, 
			magCountChange = p1:getWeaponStat("magsize"), 
			repetitionCount = 1
		} };
end;

