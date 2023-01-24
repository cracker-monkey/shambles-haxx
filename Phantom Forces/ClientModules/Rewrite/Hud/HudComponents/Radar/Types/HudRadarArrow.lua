
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("CharacterInterface");
local u1 = shared.require("Destructor");
local l__Templates__2 = shared.require("HudScreenGui").getScreenGui().Main.Templates;
local l__LocalPlayer__3 = game:GetService("Players").LocalPlayer;
function v1.new(p1, p2)
	local v3 = setmetatable({}, v1);
	v3._destructor = u1.new();
	v3.player = p1;
	v3.shotTime = 0;
	v3.lifeTime = 0;
	v3.lastCFrame = CFrame.new();
	v3.lastAliveTime = 0;
	v3.guiObject = l__Templates__2.DisplayPlayerMarker:Clone();
	v3.guiObject.Parent = p2;
	v3._destructor:add(v3.guiObject);
	v3:updateColor();
	v3._destructor:add(p1:GetPropertyChangedSignal("TeamColor"):Connect(function()
		v3:updateColor();
	end));
	v3._destructor:add(l__LocalPlayer__3:GetPropertyChangedSignal("TeamColor"):Connect(function()
		v3:updateColor();
	end));
	return v3;
end;
function v1.Destroy(p3)
	p3._destructor:Destroy();
end;
function v1.hide(p4)
	p4.guiObject.Visible = false;
end;
function v1.show(p5)
	p5.guiObject.Visible = true;
end;
local u4 = shared.require("PlayerStatusInterface");
local u5 = shared.require("HudRadarConfig");
function v1.updateColor(p6)
	local v4 = u4.isFriendly(p6.player) and u5.colors.lightBlue or u5.colors.red;
	p6.guiObject.ImageArrowHollow.ImageColor3 = v4;
	p6.guiObject.ImageArrowSolid.ImageColor3 = v4;
	p6.guiObject.ImageDeadCross.ImageColor3 = v4;
end;
function v1.setColor(p7, p8)
	p7.guiObject.ImageArrowHollow.ImageColor3 = p8;
	p7.guiObject.ImageArrowSolid.ImageColor3 = p8;
	p7.guiObject.ImageDeadCross.ImageColor3 = p8;
end;
return v1;

