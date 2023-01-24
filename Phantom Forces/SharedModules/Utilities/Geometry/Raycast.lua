
-- Decompiled with the Synapse X Luau decompiler.

return {
	raycastSingleExit = function(p1, p2, p3)
		local v1 = RaycastParams.new();
		v1.FilterType = Enum.RaycastFilterType.Whitelist;
		v1.FilterDescendantsInstances = { p3 };
		v1.IgnoreWater = true;
		return workspace:Raycast(p1 + p2, -p2, v1);
	end, 
	raycast = function(p4, p5, p6, p7, p8)
		local v2 = nil;
		local v3 = RaycastParams.new();
		v3.FilterDescendantsInstances = p6;
		v3.IgnoreWater = true;
		while true do
			v2 = workspace:Raycast(p4, p5, v3);
			if not p7 then
				break;
			end;
			if not v2 then
				break;
			end;
			if not p7(v2.Instance) then
				break;
			end;
			table.insert(p6, v2.Instance);
			v3.FilterDescendantsInstances = p6;		
		end;
		if not p8 then
			for v4 = #p6, #p6 + 1, -1 do
				p6[v4] = nil;
			end;
		end;
		return v2;
	end
};

