
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local l__Main__2 = shared.require("HudScreenGui").getScreenGui().Main;
local u1 = shared.require("Destructor");
local l__Templates__2 = l__Main__2.Templates;
local l__ContainerActive__3 = l__Main__2.ContainerActive;
local u4 = shared.require("GameClock");
function v1.new(p1, p2)
	local v3 = setmetatable({}, v1);
	v3._destructor = u1.new();
	v3._player = p1;
	v3._position = p2;
	v3._guiObject = l__Templates__2.ImageBloodArc:Clone();
	v3._guiObject.Parent = l__ContainerActive__3;
	v3._destructor:add(v3._guiObject);
	v3._expireTime = u4.getTime() + 5;
	return v3;
end;
function v1.Destroy(p3)
	p3._destructor:Destroy();
end;
function v1.isExpired(p4)
	return p4._expireTime < u4.getTime();
end;
local l__CurrentCamera__5 = workspace.CurrentCamera;
local u6 = 180 / math.pi;
function v1.step(p5)
	local v4 = l__CurrentCamera__5.CFrame:inverse() * p5._position;
	local l__Unit__5 = Vector3.new(v4.x, v4.z).Unit;
	local v6 = l__Unit__5.x * 200;
	local v7 = l__Unit__5.y * 200;
	p5._guiObject.Position = UDim2.new(0.5, v6, 0.5, v7);
	p5._guiObject.Rotation = math.atan2(v7, v6) * u6;
	p5._guiObject.ImageTransparency = math.max(0, 1 - 2 * ((p5._expireTime - u4.getTime()) / 5));
end;
return v1;

