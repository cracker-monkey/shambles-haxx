
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("MenuUtils");
local u1 = shared.require("Destructor");
local u2 = shared.require("MenuScreenGui");
local u3 = shared.require("GuiInputInterface");
function v1.new(p1, p2)
	local v3 = setmetatable({}, v1);
	v3._destructor = u1.new();
	v3._guiObject = p1;
	v3._guiLayout = p2 or p1.Container.UIListLayout;
	p1.CanvasSize = UDim2.new(0, 0, 0, v3._guiLayout.AbsoluteContentSize.Y / u2.getUIScale());
	v3._destructor:add(u3.onScrolled(p1, function(p3, p4)
		p1.CanvasPosition = p1.CanvasPosition + Vector2.new(p4.x, p4.y);
	end));
	u3.setGroup(p1, "ScrollingGroup");
	v3._guiInputObject = u3.getEntry(p1);
	v3._guiInterest = v3._guiInputObject:getGuiInterest();
	v3._destructor:add(v3._guiInterest.inputCaptured:connect(function(p5)
		if p5:getInputTrigger() == nil then
			return;
		end;
		local v4, v5 = v3._guiInterest:getRelativePosition(p5:getInputPosition());
		local u4 = v4;
		local u5 = v5;
		local u6 = false;
		local u7 = game:GetService("RunService").RenderStepped:Connect(function()
			local v6, v7 = v3._guiInterest:getRelativePosition(p5:getInputPosition());
			u4 = v6;
			u5 = v7;
			if not u6 and (v6 - v4) ^ 2 + (v7 - v5) ^ 2 > 576 then
				u6 = true;
				for v8, v9 in next, p5:getInteractionData().guiCapture:getGuiInteractions() do
					if v9 ~= p5 then
						v9:destroy();
					end;
				end;
			end;
			if u6 then
				p1.CanvasPosition = p1.CanvasPosition - Vector2.new(0, v7 - u5);
			end;
		end);
		p5.destroyed:connect(function()
			u7:Disconnect();
		end);
	end));
	return v3;
end;
function v1.Destroy(p6)
	p6._destructor:Destroy();
end;
return v1;

