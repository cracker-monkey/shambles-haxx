
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("MenuScreenGui");
local u1 = shared.require("Destructor");
local u2 = shared.require("AccelTween");
local u3 = shared.require("ConditionalUpdater");
local u4 = shared.require("GuiInputInterface");
function v1.new(p1, p2)
	local v3 = setmetatable({}, v1);
	v3._destructor = u1.new();
	v3._guiObject = p1;
	v3._pressTween = u2.new(256);
	v3._conditionalUpdater = u3.new(function()
		v3:update();
	end, function()
		return v3._pressTween.rtime == 0;
	end);
	v3._destructor:add(v3._conditionalUpdater);
	v3._highlightColor3 = p2.highlightColor3;
	v3._defaultColor3 = p2.defaultColor3;
	v3._updateFunc = p2.updateFunc;
	v3._isOverButton = false;
	v3._isButtonHeld = false;
	v3._isToggled = false;
	v3._destructor:add(u4.onPressed(v3._guiObject, function()
		v3._isButtonHeld = true;
		v3:updateTarget();
	end));
	v3._destructor:add(u4.onReleased(v3._guiObject, function()
		v3._isButtonHeld = false;
		v3:updateTarget();
	end));
	v3._destructor:add(u4.onDragEnded(v3._guiObject, function()
		v3._isButtonHeld = false;
		v3:updateTarget();
	end));
	v3._destructor:add(u4.onReleaseBlocked(v3._guiObject, function()
		v3._isButtonHeld = false;
		v3:updateTarget();
	end));
	v3._destructor:add(u4.onReleaseCancelled(v3._guiObject, function()
		v3._isButtonHeld = false;
		v3:updateTarget();
	end));
	v3._destructor:add(u4.onEntered(v3._guiObject, function()
		v3._isOverButton = true;
		v3:updateTarget();
	end));
	v3._destructor:add(u4.onExited(v3._guiObject, function()
		v3._isOverButton = false;
		v3:updateTarget();
	end));
	v3._conditionalUpdater:start();
	return v3;
end;
function v1.Destroy(p3)
	p3._destructor:Destroy();
end;
function v1.updateTarget(p4)
	if p4._isOverButton then
		if p4._isButtonHeld then
			local v4 = 1;
		else
			v4 = 0.25;
		end;
	elseif p4._isButtonHeld then
		v4 = 0.5;
	else
		v4 = 0;
	end;
	p4._pressTween.t = v4;
	p4._conditionalUpdater:start();
end;
function v1.setColors(p5, p6)
	p5._highlightColor3 = p6.highlightColor3;
	p5._defaultColor3 = p6.defaultColor3;
end;
local u5 = shared.require("MenuUtils");
local l__Lerp__6 = Color3.new().Lerp;
function v1.update(p7)
	local u7 = nil;
	if p7._updateFunc then
		u7 = p7;
		local v5, v6 = pcall(function()
			u7._updateFunc(u7._pressTween.p);
		end);
		if v5 then
			return;
		end;
	else
		local v7, v8 = pcall(function()
			u5.setBackgroundColor3(p7._guiObject, l__Lerp__6(p7._defaultColor3, p7._highlightColor3, p7._pressTween.p));
		end);
		if not v7 then
			p7._conditionalUpdater:Destroy();
		end;
		return;
	end;
	u7._conditionalUpdater:Destroy();
end;
return v1;

