
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local l__UserInputService__2 = game:GetService("UserInputService");
local l__TouchEnabled__3 = l__UserInputService__2.TouchEnabled;
local u1 = shared.require("Destructor");
local u2 = shared.require("GuiInterest");
local u3 = shared.require("MenuScreenGui");
local u4 = shared.require("MenuUpdater");
function v1.new(p1)
	local v4 = setmetatable({}, v1);
	v4._destructor = u1.new();
	v4._buttonFrame = p1;
	v4._interactionCount = 0;
	v4._interactionHash = {};
	v4._hoverInteractionCount = 0;
	v4._hoverInteractionHash = {};
	v4._actionFuncs = {};
	v4._guiInterest = u2.new(p1);
	v4._destructor:add(v4._guiInterest);
	v4._destructor:add(v4._guiInterest.inputCaptured:connect(function(p2)
		if not u3.isEnabled() then
			return;
		end;
		if p2:getInputTrigger() == nil then
			v4._hoverInteractionHash[p2] = true;
			v4._hoverInteractionCount = v4._hoverInteractionCount + 1;
			v4:_fireActionFuncs("onEntered");
			p2.inputted:connect(function(p3, ...)
				if p3 == "ScrollInput" then
					v4:_fireActionFuncs("onScrolled", p2, 24 * ...);
				end;
			end);
			p2.destroyed:connect(function()
				v4._hoverInteractionCount = v4._hoverInteractionCount - 1;
				v4._hoverInteractionHash[p2] = nil;
				v4:_fireActionFuncs("onExited");
			end);
			return;
		end;
		v4._interactionHash[p2] = true;
		v4._interactionCount = v4._interactionCount + 1;
		v4:_fireActionFuncs("onPressed", p2);
		p2.released:connect(function()
			if v4._interactionCount > 1 then
				return;
			end;
			if p2:isTouching() then
				v4:_fireActionFuncs("onReleased", p2);
				return;
			end;
			if p2:isInRange() then
				v4:_fireActionFuncs("onReleaseBlocked", p2);
				return;
			end;
			v4:_fireActionFuncs("onReleaseCancelled", p2);
		end);
		local u5 = u4.addTask(function()
			v4:_fireActionFuncs("onDragged", p2);
		end, 10);
		p2.destroyed:connect(function()
			v4._interactionCount = v4._interactionCount - 1;
			v4._interactionHash[p2] = nil;
			u5();
			v4:_fireActionFuncs("onDragEnded", p2);
		end);
	end));
	v4._destructor:add(function()
		if v4._offClickConnection then
			v4._offClickConnection:Disconnect();
		end;
	end);
	v4._destructor:add(u3.onEnabled:connect(function()
		if v4._actionFuncs.onPressedOff and #v4._actionFuncs.onPressedOff > 0 then
			v4:_enableOffClicks();
		end;
	end));
	v4._destructor:add(u3.onDisabled:connect(function()
		v4:_disableOffClicks();
	end));
	return v4;
end;
function v1.Destroy(p4)
	p4._destructor:Destroy();
end;
function v1.getGuiInterest(p5)
	return p5._guiInterest;
end;
function v1.getTopPrecedence(p6)
	local v5 = (1 / 0);
	for v6 in next, p6._interactionHash do
		v5 = math.min(v5, v6:getPrecedence());
	end;
	return v5;
end;
function v1.hasNoActionFuncs(p7)
	return #p7._actionFuncs <= 0;
end;
function v1.connectInput(p8, p9, p10)
	if not p8._actionFuncs[p9] then
		p8._actionFuncs[p9] = {};
	end;
	table.insert(p8._actionFuncs[p9], p10);
	if p9 == "onPressedOff" then
		p8:_enableOffClicks();
	end;
	local u6 = nil;
	return function()
		if u6 or not p8._actionFunc then
			return;
		end;
		local v7 = table.find(p8._actionFunc[p9], p10);
		if not v7 then
			warn("GuiInputObject: No remove index found for disconnecting", p9, p10);
			return;
		end;
		table.remove(p8._actionFunc[p9], v7);
		u6 = true;
		if #p8._actionFuncs[p9] <= 0 then
			p8._actionFuncs[p9] = nil;
			p8:_disableOffClicks();
		end;
	end;
end;
function v1._fireActionFuncs(p11, p12, ...)
	if not p11._actionFuncs[p12] then
		return;
	end;
	for v8, v9 in next, p11._actionFuncs[p12] do
		v9(...);
	end;
end;
function v1._enableOffClicks(p13)
	if p13._offClickConnection then
		return;
	end;
	p13._offClickConnection = l__UserInputService__2.InputBegan:Connect(function(p14)
		if (p14.KeyCode == Enum.KeyCode.ButtonA or p14.UserInputType == Enum.UserInputType.MouseButton1 or p14.UserInputType == Enum.UserInputType.MouseButton2 or p14.UserInputType == Enum.UserInputType.Touch) and p13._interactionCount <= 0 and p13._hoverInteractionCount <= 0 then
			p13:_fireActionFuncs("onPressedOff");
		end;
	end);
end;
function v1._disableOffClicks(p15)
	if p15._offClickConnection then
		p15._offClickConnection:Disconnect();
		p15._offClickConnection = nil;
	end;
end;
return v1;

