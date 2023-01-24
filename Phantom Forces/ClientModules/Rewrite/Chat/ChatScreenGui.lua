
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("Event");
v1.onEnabled = v2.new();
v1.onDisabled = v2.new();
local l__ChatScreenGui__1 = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("ChatScreenGui");
function v1.getScreenGui()
	return l__ChatScreenGui__1;
end;
local u2 = true;
function v1.isEnabled()
	return u2;
end;
function v1.mount(p1)
	p1.Parent = l__ChatScreenGui__1;
end;
function v1.enable()
	u2 = true;
	l__ChatScreenGui__1.Main.ContainerChat.Visible = true;
	v1.onEnabled:fire();
end;
function v1.disable()
	u2 = false;
	l__ChatScreenGui__1.Main.ContainerChat.Visible = false;
	v1.onDisabled:fire();
end;
local l__UIScale__3 = l__ChatScreenGui__1.UIScale;
function v1.getUIScale()
	return l__UIScale__3.Scale;
end;
local u3 = shared.require("UIScaleUpdater").new(l__UIScale__3);
function v1.setUIScale(p2)
	u3:setScale(p2);
end;
function v1.toggleAspectRatio(p3)
	u3:toggleAspectRatio(p3);
end;
local u4 = shared.require("PlayerSettingsInterface");
local u5 = shared.require("PlayerSettingsEvents");
function v1._init()
	local l__UIScale__4 = l__ChatScreenGui__1.Main.ContainerChat.UIScale;
	l__UIScale__4.Scale = u4.getValue("chatscale") and 1;
	u5.onSettingChanged:connect(function(p4, p5)
		if p4 == "chatscale" then
			l__UIScale__4.Scale = p5;
		end;
	end);
end;
return v1;

