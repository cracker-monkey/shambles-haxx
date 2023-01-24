
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = { "PageMainMenuDisplayMenu", "PageMainMenuDisplayLoadout" };
function v1._init(p1)
	for v2 = 1, #u1 do
		shared.require(u1[v2]);
	end;
end;
return v1;

