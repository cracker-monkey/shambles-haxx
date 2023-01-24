
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("MenuScreenGui");
local u1 = shared.require("Destructor");
local u2 = shared.require("Event");
local u3 = shared.require("AccelTween");
local l__Lerp__4 = Color3.new().Lerp;
local u5 = shared.require("MenuUtils");
local u6 = shared.require("ConditionalUpdater");
local u7 = shared.require("GuiInputInterface");
function v1.new(p1, p2)
	local v3 = setmetatable({}, v1);
	v3._destructor = u1.new();
	v3._guiObject = p1;
	v3.onToggleChanged = u2.new();
	v3._pressTween = u3.new(512);
	if p2 then
		if p2.updateFunc then
			local v4 = p2.updateFunc;
		else
			v4 = function(p3, p4)
				u5.setBackgroundColor3(p3, (l__Lerp__4(p2.default.BackgroundColor3, p2.highlighted.BackgroundColor3, p4)));
			end;
		end;
		v3._conditionalUpdater = u6.new(function()
			local v5, v6 = pcall(v4, v3._guiObject, v3._pressTween.p);
			if not v5 then
				v3._conditionalUpdater:Destroy();
			end;
		end, function()
			return v3._pressTween.rtime == 0;
		end);
		v3._destructor:add(v3._conditionalUpdater);
		v3._conditionalUpdater:start();
	end;
	v3._isOverButton = false;
	v3._isButtonHeld = false;
	v3._toggleState = false;
	v3._destructor:add(u7.onPressed(v3._guiObject, function()
		v3._isButtonHeld = true;
		v3:updateTarget();
	end));
	v3._destructor:add(u7.onReleased(v3._guiObject, function()
		v3._toggleState = not v3._toggleState;
		v3.onToggleChanged:fire(v3._toggleState);
		v3._isButtonHeld = false;
		v3:updateTarget();
	end));
	v3._destructor:add(u7.onReleaseBlocked(v3._guiObject, function()
		v3._isButtonHeld = false;
		v3:updateTarget();
	end));
	v3._destructor:add(u7.onReleaseCancelled(v3._guiObject, function()
		v3._isButtonHeld = false;
		v3:updateTarget();
	end));
	v3._destructor:add(u7.onEntered(v3._guiObject, function()
		v3._isOverButton = true;
		v3:updateTarget();
	end));
	v3._destructor:add(u7.onExited(v3._guiObject, function()
		v3._isOverButton = false;
		v3:updateTarget();
	end));
	return v3;
end;
function v1.Destroy(p5)
	p5._destructor:Destroy();
end;
function v1.getToggleState(p6)
	return p6._toggleState;
end;
function v1.setToggleState(p7, p8)
	p7._toggleState = p8;
	p7.onToggleChanged:fire(p7._toggleState, true);
	p7:updateTarget();
end;
function v1.updateTarget(p9)
	if p9._isOverButton then
		if p9._isButtonHeld then
			local v7 = 0.75;
		elseif p9._toggleState then
			v7 = 1.1;
		else
			v7 = 0.15;
		end;
	elseif p9._isButtonHeld then
		v7 = 0.5;
	elseif p9._toggleState then
		v7 = 1;
	else
		v7 = 0;
	end;
	p9._pressTween.t = v7;
	if p9._conditionalUpdater then
		p9._conditionalUpdater:start();
	end;
end;
return v1;

