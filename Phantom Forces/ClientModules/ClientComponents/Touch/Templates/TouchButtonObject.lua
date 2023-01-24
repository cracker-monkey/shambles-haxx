
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local l__Templates__2 = shared.require("TouchScreenGui").getScreenGui().Templates;
local u3 = shared.require("GuiInterest");
local u4 = shared.require("spring");
local u5 = shared.require("Event");
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	p2 = p2 or {};
	local v3 = p2.radius and 20;
	v2._color = p2.color or Color3.new(0.415686, 0.415686, 0.415686);
	v2._pressedColor = p2.pressedColor or Color3.new(0.176471, 0.176471, 0.176471);
	v2._guiObject = l__Templates__2.TouchButton:Clone();
	v2._guiObject.Size = UDim2.fromOffset(2 * v3, 2 * v3);
	v2._guiObject.Position = p2.position or UDim2.fromScale(0.5, 0.5);
	v2._guiObject.Parent = p1;
	v2._destructor:add(v2._guiObject);
	v2._dragger = v2._guiObject.Dragger;
	v2._dragger.TextLabel.Text = p2.text and "Button";
	v2._guiInterest = u3.new(v2._guiObject);
	v2._guiInterest:setShape("circle");
	v2._guiInterest:setGroup(p2.group and "touchButton");
	v2._destructor:add(v2._guiInterest);
	v2._draggable = false;
	v2._guiInteractions = {};
	v2._dragPositionSpring = u4.new(Vector3.zero, 0.8, 20);
	v2._colorSpring = u4.new(Vector3.zero, 1, 20);
	local l___color__4 = v2._color;
	v2._colorSpring.t = Vector3.new(l___color__4.r, l___color__4.g, l___color__4.b);
	v2.onDragged = u5.new();
	v2.onPressed = u5.new();
	v2.onReleased = u5.new();
	v2.onCancelled = u5.new();
	v2.onReleasedInRange = u5.new();
	v2._guiInterest.inputCaptured:connect(function(p3)
		if p3:getInputTrigger() == nil then
			return;
		end;
		local v5 = v2:getInteractionCount();
		if v2._draggable and v5 > 0 then
			return;
		end;
		if v5 == 0 then
			v2.onPressed:fire();
			local l___pressedColor__6 = v2._pressedColor;
			v2._colorSpring.t = Vector3.new(l___pressedColor__6.r, l___pressedColor__6.g, l___pressedColor__6.b);
		end;
		local v7, v8 = v2._guiInterest:getRelativePosition(p3:getInputPosition());
		v2._guiInteractions[p3] = {
			init = Vector3.new(v7, v8), 
			prev = Vector3.new(v7, v8)
		};
		p3.released:connect(function()
			if v2:getInteractionCount() == 1 then
				v2.onReleased:fire();
				if p3:isTouching() then
					v2.onReleasedInRange:fire();
				end;
			end;
		end);
		p3.destroyed:connect(function()
			v2._guiInteractions[p3] = nil;
			if v2:getInteractionCount() == 0 then
				local l___color__9 = v2._color;
				v2._colorSpring.t = Vector3.new(l___color__9.r, l___color__9.g, l___color__9.b);
				v2.onCancelled:fire();
			end;
		end);
	end);
	v2._destructor:add(game:GetService("RunService").RenderStepped:Connect(function()
		if not v2._draggable then
			for v10 in next, v2._guiInteractions do
				if not v10:isInRange() then
					v10:destroy();
				end;
			end;
			local v11 = v2._dragPositionSpring:update(Vector3.zero, nil, nil, 0.8, 20);
			v2._dragger.Position = UDim2.fromOffset(v11.x, v11.y);
		else
			local v12 = Vector3.zero;
			local v13 = Vector3.zero;
			for v14, v15 in next, v2._guiInteractions do
				local v16, v17 = v2._guiInterest:getRelativePosition(v14:getInputPosition());
				local v18 = Vector3.new(v16, v17, 0);
				v12 = v12 + v18 - v15.prev;
				v13 = v13 + v18 - v15.init;
				v15.prev = v18;
			end;
			if v12 ~= Vector3.zero then
				v2.onDragged:fire(v12.x, -v12.y);
			end;
			if v2:getInteractionCount() > 0 then
				local v19 = v2._dragPositionSpring:update(v13, nil, nil, 1, 50);
			else
				v19 = v2._dragPositionSpring:update(v13, nil, nil, 0.8, 20);
			end;
			v2._dragger.Position = UDim2.fromOffset(math.round(v19.x), math.round(v19.y));
		end;
		local l__p__20 = v2._colorSpring.p;
		v2._dragger.BackgroundColor3 = Color3.new(l__p__20.x, l__p__20.y, l__p__20.z);
	end));
	return v2;
end;
function v1.Destroy(p4)
	p4._destructor:Destroy();
end;
function v1.getInteractionCount(p5)
	local v21 = 0;
	for v22, v23 in next, p5._guiInteractions do
		v21 = v21 + 1;
	end;
	return v21;
end;
function v1.setDraggable(p6, p7)
	p6._draggable = p7;
end;
function v1.setLayer(p8, p9)
	p8._guiInterest:setLayer(p9);
end;
return v1;

