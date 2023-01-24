
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	deepFreeze = function(p1)
		table.freeze(p1);
		for v1, v2 in p1, nil do
			if type(v2) == "table" and not table.isfrozen(p1) then
				u1.deepFreeze(v2);
			end;
		end;
	end, 
	deepCopy = function(p2)
		local u2 = {};
		local function u3(p3)
			local v3 = table.clone(p3);
			for v4, v5 in v3, nil do
				if type(v5) == "table" then
					if not u2[v5] then
						u2[v5] = u3(v5);
					end;
					v3[v4] = u2[v5];
				else
					v3[v4] = v5;
				end;
			end;
			return v3;
		end;
		return u3(p2);
	end
};
return u1;

