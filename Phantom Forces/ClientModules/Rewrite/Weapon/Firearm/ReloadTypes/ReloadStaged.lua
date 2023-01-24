
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
	if v2 == 0 then
		local v4 = "emptyendstage";
	else
		v4 = "endstage";
	end;
	return { {
			reloadName = "initstage", 
			magCountChange = 0, 
			repetitionCount = 1
		}, {
			reloadName = "reloadstage", 
			magCountChange = 1, 
			repetitionCount = p1:getWeaponStat("magsize") + v3 - v2
		}, {
			reloadName = v4, 
			magCountChange = 0, 
			repetitionCount = 1
		} };
end;

