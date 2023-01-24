
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("Event");
v1.onEnabled = v2.new();
v1.onDisabled = v2.new();
local l__LeaderboardScreenGui__1 = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("LeaderboardScreenGui");
function v1.getScreenGui()
	return l__LeaderboardScreenGui__1;
end;
function v1.isEnabled()
	return l__LeaderboardScreenGui__1.Enabled;
end;
function v1.mount(p1)
	p1.Parent = l__LeaderboardScreenGui__1;
end;
function v1.enable()
	l__LeaderboardScreenGui__1.Enabled = true;
	v1.onEnabled:fire();
end;
function v1.disable()
	l__LeaderboardScreenGui__1.Enabled = false;
	v1.onDisabled:fire();
end;
local u2 = shared.require("UIScaleUpdater");
local u3 = shared.require("PlayerSettingsInterface");
local u4 = shared.require("PlayerSettingsEvents");
function v1._init()
	local v3 = u2.new(l__LeaderboardScreenGui__1.UIScale);
	v3:setScale(u3.getValue("leaderboardscale") and 1);
	u4.onSettingChanged:connect(function(p2, p3)
		if p2 == "leaderboardscale" then
			v3:setScale(p3);
		end;
	end);
end;
return v1;

