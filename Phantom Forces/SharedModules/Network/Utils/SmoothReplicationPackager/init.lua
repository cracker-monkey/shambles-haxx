
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
if game:GetService("RunService"):IsServer() then
	return shared.require("SmoothSender");
end;
return shared.require("SmoothReciever");

