
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("OrderedTaskRunner").new();
v1:lock();
game:GetService("RunService").RenderStepped:connect(function(p1)
	v1:step(p1);
end);
return v1;

