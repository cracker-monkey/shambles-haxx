
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = { function(p1)
		return p1:gsub("^%s*(.-)%s*$", "%1");
	end, function(p2)
		return p2:gsub("[<>]", "");
	end, function(p3)
		return p3:gsub("[\n\r]", " ");
	end };
function v1.preFilter(p4)
	for v2 = 1, #u1 do
		p4 = u1[v2](p4);
	end;
	return p4;
end;
return v1;

