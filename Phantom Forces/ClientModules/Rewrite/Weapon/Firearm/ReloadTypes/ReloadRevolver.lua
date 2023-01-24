
-- Decompiled with the Synapse X Luau decompiler.

return function(p1)
	local v1 = {};
	for v2 = p1:getMagCount() + 1, p1:getStat("Magazine Size") do
		table.insert(v1, {
			reloadName = "ReloadRound" .. v2, 
			magCountChange = 1, 
			repetitionCount = 1
		});
	end;
	return v1;
end;

