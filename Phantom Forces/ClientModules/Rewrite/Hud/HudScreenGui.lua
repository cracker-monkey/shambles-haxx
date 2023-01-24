
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("Event");
v1.onEnabled = v2.new();
v1.onDisabled = v2.new();
local l__HudScreenGui__1 = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("HudScreenGui");
function v1.getScreenGui()
	return l__HudScreenGui__1;
end;
function v1.isEnabled()
	return l__HudScreenGui__1.Enabled;
end;
function v1.mount(p1)
	p1.Parent = l__HudScreenGui__1;
end;
function v1.enable()
	l__HudScreenGui__1.Enabled = true;
	v1.onEnabled:fire();
end;
function v1.disable()
	l__HudScreenGui__1.Enabled = false;
	v1.onDisabled:fire();
end;
local l__UIScale__3 = l__HudScreenGui__1.UIScale;
function v1.getUIScale()
	return l__UIScale__3.Scale;
end;
local u2 = shared.require("UIScaleUpdater").new(l__UIScale__3);
function v1.setUIScale(p2)
	u2:setScale(p2);
end;
return v1;

