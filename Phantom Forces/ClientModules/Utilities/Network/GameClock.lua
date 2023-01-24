
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("network");
function v1.getTime()
	return u1:getTime();
end;
function v1.isReady()
	return u1:timeSyncReady();
end;
return v1;

