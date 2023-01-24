
-- Decompiled with the Synapse X Luau decompiler.

return {
	new = function(p1, p2)
		local l__Name__1 = p1.Name;
		local l__registry__2 = p2.registry;
		for v3, v4 in p2.retrievers, nil do
			p1[v4] = function(p3, ...)
				local v5 = l__registry__2:getEntry(p3);
				if not v5 then
					warn(l__Name__1 .. " : No entry found for retrieval call " .. v4);
					return;
				end;
				return v5[v4](v5, ...);
			end;
		end;
		for v6, v7 in p2.modifiers, nil do
			p1[v7] = function(p4, ...)
				local v8 = l__registry__2:getEntry(p4);
				if not v8 then
					warn(l__Name__1 .. ": No entry found for modifier call", v7);
					return;
				end;
				return v8[v7](v8, ...);
			end;
		end;
	end
};

