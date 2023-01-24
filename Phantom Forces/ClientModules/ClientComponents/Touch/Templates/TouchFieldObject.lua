
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local l__Templates__2 = shared.require("TouchScreenGui").getScreenGui().Templates;
local u3 = shared.require("GuiInterest");
local u4 = shared.require("spring");
local u5 = shared.require("Event");
function v1.new(p1, p2, p3, p4)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._guiObject = l__Templates__2.TouchField:Clone();
	v2._guiObject.Position = p2;
	v2._guiObject.Size = p3;
	v2._guiObject.Parent = p1;
	v2._destructor:add(v2._guiObject);
	v2._guiInterest = u3.new(v2._guiObject);
	v2._guiInterest:setGroup(p4 and "touchField");
	v2._destructor:add(v2._guiInterest);
	v2._guiInteractions = {};
	v2._dragPositionSpring = u4.new(Vector3.zero, 0.8, 20);
	v2.onDragged = u5.new();
	v2.onPressed = u5.new();
	v2.onReleased = u5.new();
	v2.onReleasedInRange = u5.new();
	v2._guiInterest.inputCaptured:connect(function(p5)
		if p5:getInputTrigger() == nil then
			return;
		end;
		if v2:getInteractionCount() == 0 then
			v2.onPressed:fire();
		end;
		local v3, v4 = v2._guiInterest:getRelativePosition(p5:getInputPosition());
		v2._guiInteractions[p5] = {
			prev = Vector3.new(v3, v4, 0)
		};
		p5.released:connect(function()
			if v2:getInteractionCount() == 1 then
				v2.onReleased:fire();
				if p5:isTouching() then
					v2.onReleasedInRange:fire();
				end;
			end;
		end);
		p5.destroyed:connect(function()
			v2._guiInteractions[p5] = nil;
		end);
	end);
	v2._destructor:add(game:GetService("RunService").RenderStepped:Connect(function()
		local v5 = Vector3.zero;
		for v6, v7 in next, v2._guiInteractions do
			local v8, v9 = v2._guiInterest:getRelativePosition(v6:getInputPosition());
			local v10 = Vector3.new(v8, v9, 0);
			v5 = v5 + v10 - v7.prev;
			v7.prev = v10;
		end;
		if v5 ~= Vector3.zero then
			v2.onDragged:fire(v5.x, -v5.y);
		end;
	end));
	return v2;
end;
function v1.Destroy(p6)
	p6._destructor:Destroy();
end;
function v1.getInteractionCount(p7)
	local v11 = 0;
	for v12, v13 in next, p7._guiInteractions do
		v11 = v11 + 1;
	end;
	return v11;
end;
function v1.setLayer(p8, p9)
	p8._guiInterest:setLayer(p9);
end;
return v1;

