
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("SingleEvent");
local u2 = shared.require("Event");
local u3 = shared.require("GuiInterestRegistry");
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2._gui = p1;
	v2._layer = 0;
	v2._group = 0;
	v2._shape = "box";
	v2.destroyed = u1.new();
	v2.inputCaptured = u2.new();
	u3:register(v2);
	v2._size = p1.AbsoluteSize;
	v2._position = p1.AbsolutePosition;
	v2._rotation = p1.AbsoluteRotation;
	v2._sizeChangedConnection = p1:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		v2._size = p1.AbsoluteSize;
	end);
	v2._positionChangedConnection = p1:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
		v2._position = p1.AbsolutePosition;
	end);
	v2._rotationChangedConnection = p1:GetPropertyChangedSignal("AbsoluteRotation"):Connect(function()
		v2._rotation = p1.AbsoluteRotation;
	end);
	return v2;
end;
function v1.destroy(p2)
	p2._sizeChangedConnection:Disconnect();
	p2._positionChangedConnection:Disconnect();
	p2._rotationChangedConnection:Disconnect();
	p2.destroyed:fire();
end;
function v1.setLayer(p3, p4)
	p3._layer = p4;
end;
function v1.setGroup(p5, p6)
	p5._group = p6;
end;
function v1.setShape(p7, p8)
	local v3 = true;
	if p8 ~= "box" then
		v3 = p8 == "circle";
	end;
	assert(v3, "Shape must be 'box' or 'circle'");
	p7._shape = p8;
end;
function v1.getLayer(p9)
	return p9._layer;
end;
function v1.getGroup(p10)
	return p10._group;
end;
function v1.getCenter(p11)
	local l___size__4 = p11._size;
	local l___position__5 = p11._position;
	return l___position__5.x + l___size__4.x / 2, l___position__5.y + l___size__4.y / 2;
end;
function v1.getShapeData(p12)
	local l___gui__6 = p12._gui;
	local l___size__7 = p12._size;
	local l___position__8 = p12._position;
	local l__x__9 = l___size__7.x;
	local l__y__10 = l___size__7.y;
	local v11 = math.rad(p12._rotation);
	local v12 = math.cos(v11);
	local v13 = math.sin(v11);
	return p12._shape, l___position__8.x + l__x__9 / 2, l___position__8.y + l__y__10 / 2, l__x__9 / 2 * v12, -l__y__10 / 2 * v13, l__x__9 / 2 * v13, l__y__10 / 2 * v12;
end;
function v1.getCoordinateData(p13)
	local l___gui__14 = p13._gui;
	local l___size__15 = p13._size;
	local l___position__16 = p13._position;
	local l__x__17 = l___size__15.x;
	local l__y__18 = l___size__15.y;
	local v19 = math.rad(p13._rotation);
	local v20 = math.cos(v19);
	local v21 = math.sin(v19);
	return l___position__16.x + l__x__17 / 2 - l__x__17 / 2 * v20 + l__y__18 / 2 * v21, l___position__16.y + l__y__18 / 2 - l__x__17 / 2 * v21 - l__y__18 / 2 * v20, v20, -v21, v21, v20;
end;
local u4 = shared.require("EllipseSolverLib");
local u5 = shared.require("BoxSolverLib");
function v1.getClosestPosition(p14, p15, p16)
	local v22 = nil;
	local v23 = nil;
	local v24 = nil;
	local v25 = nil;
	local v26 = nil;
	local v27 = nil;
	local v28 = nil;
	v28, v22, v23, v24, v25, v26, v27 = p14:getShapeData();
	if v28 == "circle" then
		return u4.getClosestPoint(v22, v23, v24, v25, v26, v27, p15, p16);
	end;
	return u5.getClosestPoint(v22, v23, v24, v25, v26, v27, p15, p16);
end;
function v1.getRelativePosition(p17, p18, p19)
	local v29, v30, v31, v32, v33, v34 = p17:getCoordinateData();
	local v35 = p18 - v29;
	local v36 = p19 - v30;
	local v37 = v31 * v34 - v33 * v32;
	return (v35 * v34 - v36 * v32) / v37, (v36 * v31 - v35 * v33) / v37;
end;
function v1.getGui(p20)
	return p20._gui;
end;
function v1.registerGuiInteraction(p21, p22)
	p21.inputCaptured:fire(p22);
end;
return v1;

