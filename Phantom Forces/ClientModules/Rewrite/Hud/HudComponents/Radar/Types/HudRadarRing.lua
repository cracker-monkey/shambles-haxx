
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local l__Templates__2 = shared.require("HudScreenGui").getScreenGui().Main.Templates;
local l__LocalPlayer__3 = game:GetService("Players").LocalPlayer;
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2.player = p1;
	v2.shotCFrame = CFrame.new();
	v2.shotTime = 0;
	v2.size0 = 4;
	v2.size1 = 30;
	v2.lifeTime = 0.5;
	v2.guiObject = l__Templates__2.DisplayRingMarker:Clone();
	v2.guiObject.Parent = p2;
	v2._destructor:add(v2.guiObject);
	v2:updateColor();
	v2._destructor:add(p1:GetPropertyChangedSignal("TeamColor"):Connect(function()
		v2:updateColor();
	end));
	v2._destructor:add(l__LocalPlayer__3:GetPropertyChangedSignal("TeamColor"):Connect(function()
		v2:updateColor();
	end));
	return v2;
end;
function v1.Destroy(p3)
	p3._destructor:Destroy();
end;
local u4 = shared.require("PlayerStatusInterface");
local u5 = shared.require("HudRadarConfig");
function v1.updateColor(p4)
	p4.guiObject.ImageRing.ImageColor3 = u4.isFriendly(p4.player) and u5.colors.lightBlue or u5.colors.red;
end;
return v1;

