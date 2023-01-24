
-- Decompiled with the Synapse X Luau decompiler.

local l__ReplicatedFirst__1 = game:GetService("ReplicatedFirst");
local u1 = require(l__ReplicatedFirst__1:WaitForChild("ModuleLoader")).new({ l__ReplicatedFirst__1:WaitForChild("ClientModules"), l__ReplicatedFirst__1:WaitForChild("SharedModules") });
function shared.require(p1)
	return u1:require(p1);
end;
function shared.add(p2, p3)
	u1:add(p2, p3);
end;
function shared.close()
	shared.require = nil;
	shared.add = nil;
	shared.close = nil;
	u1:ClearScripts();
	l__ReplicatedFirst__1:WaitForChild("ClientModules"):Destroy();
	l__ReplicatedFirst__1:WaitForChild("SharedModules"):Destroy();
	for v2 in next, u1 do
		u1[v2] = nil;
	end;
	u1 = nil;
	script:Destroy();
end;
u1:require("MainClient");

