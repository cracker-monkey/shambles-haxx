
-- Decompiled with the Synapse X Luau decompiler.

return {
	new = function(p1, p2)
		local l__Name__1 = p1.Name;
		for v2, v3 in p2.retrievers, nil do
			p1[v3] = function(p3, ...)
				local l___singleton__4 = p1._singleton;
				if not l___singleton__4 then
					warn(l__Name__1 .. ": No singleton found for retrieval call", v3);
					return;
				end;
				return l___singleton__4[v3](l___singleton__4, ...);
			end;
		end;
		for v5, v6 in p2.modifiers, nil do
			p1[v6] = function(p4, ...)
				local l___singleton__7 = p1._singleton;
				if not l___singleton__7 then
					warn(l__Name__1 .. ": No singleton found for modifier call", v6);
					return;
				end;
				l___singleton__7[v6](l___singleton__7, ...);
			end;
		end;
	end
};

