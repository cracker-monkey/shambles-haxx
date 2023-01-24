
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("SingleEvent");
local u2 = shared.require("Event");
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2._interactionData = p1;
	v2.destroyed = u1.new();
	v2.released = u1.new();
	v2.inputted = u2.new();
	p1.guiCapture:registerGuiInteraction(v2);
	p1.guiInterest:registerGuiInteraction(v2);
	p1.guiInteraction = v2;
	v2._guiCaptureReleasedEvent = p1.guiCapture.released:connect(function()
		v2:release();
	end);
	v2._guiCaptureDestroyedEvent = p1.guiCapture.destroyed:connect(function()
		v2:destroy();
	end);
	v2._guiInterestDestroyedEvent = p1.guiInterest.destroyed:connect(function()
		v2:destroy();
	end);
	v2._inputtedEvent = p1.guiCapture:getGuiInput().inputted:connect(function(p2, ...)
		v2.inputted:fire(p2, ...);
	end);
	return v2;
end;
function v1.destroy(p3)
	p3._guiCaptureReleasedEvent:disconnect();
	p3._guiCaptureDestroyedEvent:disconnect();
	p3._guiInterestDestroyedEvent:disconnect();
	p3._inputtedEvent:disconnect();
	p3.destroyed:fire();
end;
function v1.release(p4)
	p4.released:fire();
	p4:destroy();
end;
function v1.getInputPosition(p5)
	return p5._interactionData.guiCapture:getGuiInput():getPosition();
end;
function v1.getInputRadius(p6)
	return p6._interactionData.guiCapture:getGuiInput():getRadius();
end;
function v1.getInputTrigger(p7)
	return p7._interactionData.guiCapture:getInputTrigger();
end;
function v1.getClosestPosition(p8)
	return p8._interactionData.cx, p8._interactionData.cy;
end;
function v1.isInRange(p9)
	return p9._interactionData.inRange;
end;
function v1.getPrecedence(p10)
	return p10._interactionData.precedence;
end;
function v1.isTouching(p11)
	return p11._interactionData.touching;
end;
function v1.getInteractionData(p12)
	return p12._interactionData;
end;
return v1;

