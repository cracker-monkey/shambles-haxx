
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("Event");
v1.onEnabled = v2.new();
v1.onDisabled = v2.new();
local l__MenuScreenGui__1 = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MenuScreenGui");
function v1.getScreenGui()
	return l__MenuScreenGui__1;
end;
function v1.isEnabled()
	return l__MenuScreenGui__1.Enabled;
end;
function v1.mount(p1)
	p1.Parent = l__MenuScreenGui__1;
end;
function v1.enable()
	l__MenuScreenGui__1.Enabled = true;
	v1.onEnabled:fire();
end;
function v1.disable()
	l__MenuScreenGui__1.Enabled = false;
	v1.onDisabled:fire();
end;
local l__Pages__2 = l__MenuScreenGui__1:WaitForChild("Pages");
function v1.getPageFrame(p2)
	local v3 = l__Pages__2:FindFirstChild(p2, true);
	if not v3 then
		warn("MenuScreenGui: No page frame found for", p2);
	end;
	return v3;
end;
local l__UIScale__4 = l__MenuScreenGui__1.UIScale;
function v1.getUIScale()
	return l__UIScale__4.Scale;
end;
local u3 = shared.require("UIScaleUpdater").new(l__UIScale__4);
function v1.setUIScale(p3)
	u3:setScale(p3);
end;
function v1.setUIAspectRatio(p4)
	l__MenuScreenGui__1.Pages.UIAspectRatioConstraint.AspectRatio = p4;
	l__MenuScreenGui__1.PagesStatic.UIAspectRatioConstraint.AspectRatio = p4;
end;
return v1;

