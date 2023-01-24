
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("PlayerStatusInterface");
local v3 = shared.require("HudRadarConfig");
local l__LocalPlayer__4 = game:GetService("Players").LocalPlayer;
local u1 = shared.require("Destructor");
local l__Templates__2 = shared.require("HudScreenGui").getScreenGui().Main.Templates;
function v1.new(p1, p2)
	local v5 = setmetatable({}, v1);
	v5._destructor = u1.new();
	v5.model = p1;
	v5.teamcolor = p1:FindFirstChild("TeamColor");
	v5.letter = p1:FindFirstChild("Letter");
	v5.base = p1:FindFirstChild("Base");
	local v6 = nil;
	if p1.Name == "Flag" then
		v6 = v5.letter and v5.letter.Value or "";
	elseif p1.Name == "FlagBase" then
		v6 = "F";
	elseif p1.Name == "HPFlag" then
		v6 = "P";
	elseif p1.Name == "RedeemBase" then
		v6 = "R";
	end;
	v5.guiObject = l__Templates__2.DisplayPropMarker:Clone();
	v5.guiObject.ImageObjective.TextMarker.Text = v6;
	v5.guiObject.Parent = p2;
	v5._destructor:add(v5.guiObject);
	v5._destructor:add(v5.teamcolor:GetPropertyChangedSignal("Value"):Connect(function()
		v5:updateColor();
	end));
	v5:updateColor();
	return v5;
end;
function v1.Destroy(p3)
	p3._destructor:Destroy();
end;
function v1.updateColor(p4)
	local l__Color__7 = p4.teamcolor.Value.Color;
	p4.guiObject.ImageObjective.ImageColor3 = l__Color__7;
	p4.guiObject.ImageObjective.TextMarker.TextColor3 = l__Color__7;
end;
return v1;

