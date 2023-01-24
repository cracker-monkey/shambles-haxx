
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	v2._ignoreList = p1 or { workspace.Terrain, workspace.Ignore, workspace.CurrentCamera, workspace.Players };
	v2._defaultLimit = p2 and 1.5;
	v2._aggregatedOcclusion = 0;
	return v2;
end;
local u1 = shared.require("Raycast");
function v1.checkOcclusion(p3, p4, p5, p6)
	local u2 = 0;
	return not u1.raycast(p4, p5, p3._ignoreList, function(p7)
		if p7.Transparency == 0 then
			return false;
		end;
		u2 = u2 + (1 - p7.Transparency);
		return u2 < (p6 or p3._defaultLimit);
	end);
end;
return v1;

