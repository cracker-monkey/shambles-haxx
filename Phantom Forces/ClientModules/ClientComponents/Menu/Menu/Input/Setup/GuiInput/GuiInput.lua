
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local l__GuiService__2 = game:GetService("GuiService");
local u1 = shared.require("SingleEvent");
local u2 = shared.require("Event");
local u3 = shared.require("GuiCapture");
function v1.new()
	local v3 = setmetatable({}, v1);
	v3._px = 0;
	v3._py = 0;
	v3._radius = 0;
	v3.destroyed = u1.new();
	v3.inputted = u2.new();
	v3._hoverGuiCapture = u3.new(v3, nil, true, true);
	v3._guiCaptures = {};
	return v3;
end;
function v1.destroy(p1)
	p1.destroyed:fire();
end;
function v1.fireInput(p2, p3, ...)
	p2.inputted:fire(p3, ...);
end;
function v1.capture(p4, p5, p6, p7)
	if p4._guiCaptures[p5] then
		p4._guiCaptures[p5]:destroy();
	end;
	local v4 = u3.new(p4, p5, p6, p7);
	v4.destroyed:connect(function()
		if p4._guiCaptures[p5] == v4 then
			p4._guiCaptures[p5] = nil;
		end;
	end);
	p4._guiCaptures[p5] = v4;
	return v4;
end;
function v1.update(p8)
	p8._hoverGuiCapture:update();
	for v5, v6 in next, p8._guiCaptures do
		v6:update();
	end;
end;
function v1.getCapture(p9, p10)
	if p10 == nil then
		return p9._hoverGuiCapture;
	end;
	return p9._guiCaptures[p10];
end;
function v1.getHoverCapture(p11)
	return p11._hoverGuiCapture;
end;
function v1.getRadius(p12)
	return p12._radius;
end;
function v1.getPosition(p13)
	return p13._px, p13._py;
end;
function v1.setRadius(p14, p15)
	p14._radius = p15;
end;
function v1.setPosition(p16, p17, p18)
	p16._px = p17;
	p16._py = p18;
end;
return v1;

