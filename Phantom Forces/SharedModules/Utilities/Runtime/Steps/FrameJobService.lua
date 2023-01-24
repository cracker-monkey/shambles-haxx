
-- Decompiled with the Synapse X Luau decompiler.

local u1 = shared.require("JobScheduler").new();
game:GetService("RunService").Heartbeat:Connect(function()
	u1:step(1);
end);
return u1;

