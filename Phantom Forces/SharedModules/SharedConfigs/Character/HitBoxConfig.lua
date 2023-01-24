
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("InstanceType");
local u2 = game:GetService("RunService"):IsServer();
local u3 = {
	Desktop = shared.require("DesktopHitBox"), 
	Console = shared.require("ConsoleHitBox")
};
function v1.get(p1, p2)
	if not u1.IsConsole() then
		return u3.Desktop;
	end;
	if not p2 and not u2 then
		return u3.Desktop;
	end;
	return u3.Console;
end;
return v1;

