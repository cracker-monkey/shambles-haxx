
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__DisplayScope__2 = shared.require("UnscaledScreenGui").getScreenGui().DisplayScope;
local l__ImageRearLayer__3 = l__DisplayScope__2.ImageRearLayer;
local l__DisplayScopeSteady__4 = shared.require("HudScreenGui").getScreenGui().Main.DisplayScopeSteady;
local l__DisplayBreath__1 = l__DisplayScopeSteady__4.DisplayBreath;
function v1.setSteadyBar(p1)
	l__DisplayBreath__1.Percent.Size = p1;
end;
function v1.getSteadySize()
	return l__DisplayBreath__1.Percent.Size.X.Scale;
end;
local u2 = false;
local u3 = shared.require("sound");
function v1.heartIn()
	if u2 then
		local v5 = v1.getSteadySize() / 5;
		u3.play("heartBeatIn", 0.05 + v5);
		task.delay(0.3 + v5, v1.heartOut);
	end;
end;
function v1.heartOut()
	if u2 then
		local v6 = v1.getSteadySize() / 4;
		u3.play("heartBeatOut", 0.05 + v6);
		task.delay(0.5 + v6, v1.heartIn);
	end;
end;
local l__TextSteady__4 = l__DisplayScopeSteady__4.TextSteady;
local u5 = shared.require("input");
local u6 = shared.require("CameraInterface");
function v1.setScope(p2, p3)
	l__DisplayScope__2.Visible = p2;
	l__DisplayScopeSteady__4.Visible = p2 and not p3;
	if u5.getInputType() == "controller" then
		local v7 = "Tap LS to Toggle Steady Scope";
	else
		v7 = "Hold Shift to Steady Scope";
	end;
	l__TextSteady__4.Text = v7;
	if p2 then
		u3.play("useScope", 0.25);
		u2 = true;
		task.delay(0.5, v1.heartIn);
	end;
	if not p2 then
		u2 = false;
	end;
	if not u6.isCameraType("MainCamera") then
		return;
	end;
	u6.getActiveCamera("MainCamera"):setDirectLookMode(p2);
end;
local l__ImageFrontLayer__7 = l__DisplayScope__2.ImageFrontLayer;
function v1.updateScope(p4, p5, p6, p7)
	l__ImageFrontLayer__7.Position = p4;
	l__ImageRearLayer__3.Position = p5;
	l__ImageFrontLayer__7.Size = p6;
	l__ImageRearLayer__3.Size = p7;
end;
local l__ImageReticle__8 = l__ImageRearLayer__3.ImageReticle;
function v1.setScopeSettings(p8)
	l__ImageFrontLayer__7.BackgroundColor3 = p8.scopelenscolor or Color3.new(0, 0, 0);
	l__ImageFrontLayer__7.BackgroundTransparency = p8.scopelenstrans and 1;
	local v8 = p8.scopeimagesize and 1;
	l__ImageReticle__8.Image = p8.scopeid;
	l__ImageReticle__8.ImageColor3 = p8.sightcolor and Color3.new(p8.sightcolor.r / 255, p8.sightcolor.g / 255, p8.sightcolor.b / 255) or (p8.scopecolor or Color3.new(1, 1, 1));
	l__ImageReticle__8.Size = UDim2.new(v8, 0, v8, 0);
	l__ImageReticle__8.Position = UDim2.new((1 - v8) / 2, 0, (1 - v8) / 2, 0);
end;
function v1._init()

end;
return v1;

