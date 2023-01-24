
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("Event");
v1.onEnabled = v2.new();
v1.onDisabled = v2.new();
local l__MatchScreenGui__1 = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MatchScreenGui");
function v1.getScreenGui()
	return l__MatchScreenGui__1;
end;
function v1.isEnabled()
	return l__MatchScreenGui__1.Enabled;
end;
function v1.mount(p1)
	p1.Parent = l__MatchScreenGui__1;
end;
function v1.enable()
	l__MatchScreenGui__1.Enabled = true;
	v1.onEnabled:fire();
end;
function v1.disable()
	l__MatchScreenGui__1.Enabled = false;
	v1.onDisabled:fire();
end;
local l__UIScale__2 = l__MatchScreenGui__1.UIScale;
function v1.getUIScale()
	return l__UIScale__2.Scale;
end;
return v1;

