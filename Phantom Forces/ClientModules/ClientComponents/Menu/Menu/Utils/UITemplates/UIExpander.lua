
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("Event");
local u3 = shared.require("AccelTween");
local u4 = shared.require("ConditionalUpdater");
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._guiObject = p1;
	v2.onUpdated = u2.new();
	v2._sizeXOffsetTween = u3.new(p2.speed and 16384);
	v2._sizeYOffsetTween = u3.new(p2.speed and 16384);
	v2._sizeXScaleTween = u3.new(p2.speed and 16384);
	v2._sizeYScaleTween = u3.new(p2.speed and 16384);
	v2._size0 = p2.size0;
	v2._size1 = p2.size1;
	v2._sizeUpdater = u4.new(function()
		v2._guiObject.Size = UDim2.new(v2._sizeXScaleTween.p, v2._sizeXOffsetTween.p, v2._sizeYScaleTween.p, v2._sizeYOffsetTween.p);
		v2.onUpdated:fire();
	end, function()
		local v3 = false;
		if v2._sizeXOffsetTween.rtime == 0 then
			v3 = false;
			if v2._sizeYOffsetTween.rtime == 0 then
				v3 = false;
				if v2._sizeXScaleTween.rtime == 0 then
					v3 = v2._sizeYScaleTween.rtime == 0;
				end;
			end;
		end;
		return v3;
	end);
	v2._opened = false;
	v2:close();
	v2._sizeXOffsetTween.p = v2._size0.X.Offset;
	v2._sizeYOffsetTween.p = v2._size0.Y.Offset;
	v2._sizeXScaleTween.p = v2._size1.X.Scale;
	v2._sizeYScaleTween.p = v2._size1.Y.Scale;
	return v2;
end;
function v1.Destroy(p3)
	p3._destructor:Destroy();
end;
function v1.setCloseTarget(p4, p5)
	p4._size0 = p5;
end;
function v1.setOpenTarget(p6, p7)
	p6._size1 = p7;
end;
function v1.open(p8)
	p8._opened = true;
	p8._sizeXOffsetTween.t = p8._size1.X.Offset;
	p8._sizeYOffsetTween.t = p8._size1.Y.Offset;
	p8._sizeXScaleTween.t = p8._size1.X.Scale;
	p8._sizeYScaleTween.t = p8._size1.Y.Scale;
	p8._sizeUpdater:start();
end;
function v1.close(p9)
	p9._opened = false;
	p9._sizeXOffsetTween.t = p9._size0.X.Offset;
	p9._sizeYOffsetTween.t = p9._size0.Y.Offset;
	p9._sizeXScaleTween.t = p9._size0.X.Scale;
	p9._sizeYScaleTween.t = p9._size0.Y.Scale;
	p9._sizeUpdater:start();
end;
function v1.toggle(p10)
	if p10._opened then
		p10:close();
		return;
	end;
	p10:open();
end;
function v1.setAcceleration(p11, p12)
	p11._sizeXOffsetTween.a = p12;
	p11._sizeYOffsetTween.a = p12;
	p11._sizeXScaleTween.a = p12;
	p11._sizeYScaleTween.a = p12;
	p11._sizeUpdater:start();
end;
return v1;

