
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("Event");
v1.Clear = v2.new();
v1.Reset = v2.new();
function v1._init()
	shared.require("network"):add("emptytrash", function()
		print("Clearing Caches");
		v1.Reset:fire();
	end);
end;
table.freeze(v1);
return v1;

