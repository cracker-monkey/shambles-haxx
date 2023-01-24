
-- Decompiled with the Synapse X Luau decompiler.

return function(p1)
	if p1:getWeaponStat("chamber") then
		local v1 = 1;
	else
		v1 = 0;
	end;
	local v2 = p1:getMagCount();
	if v2 == 0 then
		local v3 = 0;
	else
		v3 = v1;
	end;
	local v4 = p1:getWeaponStat("magsize") + v3 - v2;
	local v5 = (p1:getWeaponStat("altreload") and "") .. "reload";
	if not p1:getWeaponStat("animations")[v5] then
		warn("ReloadSingle: No reload animation found for", v5);
		v5 = "reload";
	end;
	local v6 = {};
	local v7 = {
		reloadName = "pump", 
		magCountChange = 0
	};
	if v2 == 0 then
		local v8 = 1;
	else
		v8 = 0;
	end;
	v7.repetitionCount = v8;
	v6[1] = {
		reloadName = v5, 
		magCountChange = 1, 
		repetitionCount = v4
	};
	v6[2] = v7;
	return v6;
end;

