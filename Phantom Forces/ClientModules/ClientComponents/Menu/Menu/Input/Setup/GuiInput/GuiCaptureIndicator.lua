
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new(p1, p2, p3, p4)
	local v2 = setmetatable({}, v1);
	v2._guiCapture = p1;
	v2._screenGui = p2;
	v2._zIndex = p3 and 1;
	v2._color = p4 or Color3.new(1, 0.5, 1);
	v2._radius = 5;
	v2._indicatorPoints = {};
	local l__next__3 = next;
	local v4, v5 = p1:getGuiInteractions();
	while true do
		local v6, v7 = l__next__3(v4, v5);
		if not v6 then
			break;
		end;
		v5 = v6;
		v2:_createIndicatorPoint(v7, true);	
	end;
	v2._guiCaptureInteractionAddedEvent = p1.interactionAdded:connect(function(p5)
		v2:_createIndicatorPoint(p5);
	end);
	return v2;
end;
function v1.destroy(p6)
	p6._guiCaptureInteractionAddedEvent:disconnect();
	for v8 in next, p6._indicatorPoints do
		p6:_destroyIndicatorPoint(v8);
	end;
end;
local u1 = shared.require("spring");
function v1._createIndicatorPoint(p7, p8, p9)
	local v9, v10 = p8:getInputPosition();
	local v11, v12 = p8:getClosestPosition();
	local v13 = {
		gui = Instance.new("Frame", p7._screenGui)
	};
	v13.uiCorner = Instance.new("UICorner", v13.gui);
	v13.radiusSpring = u1.new(0, 0.7, 32);
	v13.offsetSpring = u1.new(Vector3.new(v9 - v11, v10 - v12, 0), 0.7, 32);
	if p9 then
		v13.offsetSpring.p = Vector3.zero;
	end;
	v13.radiusSpring.t = p7._radius;
	v13.offsetSpring.t = Vector3.zero;
	v13.uiCorner.CornerRadius = UDim.new(0.5, 0);
	v13.gui.BackgroundColor3 = p7._color;
	v13.gui.ZIndex = p7._zIndex;
	v13.gui.AnchorPoint = Vector2.new(0.5, 0.5);
	v13.gui.BorderSizePixel = 0;
	p7._indicatorPoints[p8] = v13;
	v13.guiInteractionDestroyedEvent = p8.destroyed:connect(function()
		p7:_destroyIndicatorPoint(p8);
	end);
end;
function v1._destroyIndicatorPoint(p10, p11)
	local v14 = p10._indicatorPoints[p11];
	v14.gui:Destroy();
	v14.uiCorner:Destroy();
	v14.guiInteractionDestroyedEvent:disconnect();
	p10._indicatorPoints[p11] = nil;
end;
function v1.update(p12)
	for v15 in next, p12._indicatorPoints do
		p12:_updateIndicatorPoint(v15);
	end;
end;
function v1._updateIndicatorPoint(p13, p14)
	local v16 = p13._indicatorPoints[p14];
	local v17 = p14:getPrecedence();
	local v18, v19 = p14:getClosestPosition();
	local l__p__20 = v16.offsetSpring.p;
	local l__p__21 = v16.radiusSpring.p;
	local v22, v23, v24, v25 = p13:convertFromAbsoluteToRelativeScale(v18 + l__p__20.x, v19 + l__p__20.y, 2 * l__p__21, 2 * l__p__21);
	v16.gui.Position = UDim2.new(v22, 0, v23, 0);
	v16.gui.Size = UDim2.new(v24, 0, v25, 0);
	if v17 ~= nil then
		v16.gui.BackgroundColor3 = p13._color;
		return;
	end;
	v16.gui.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5):Lerp(p13._color, -1);
end;
local u2 = shared.require("GuiMathLib");
function v1.convertFromAbsoluteToRelativeScale(p15, p16, p17, p18, p19)
	local l__AbsoluteSize__26 = p15._screenGui.AbsoluteSize;
	local v27, v28, v29, v30, v31, v32 = u2.getTopLeftScaledMatrix(l__AbsoluteSize__26, p15._screenGui.AbsolutePosition, p15._screenGui.AbsoluteRotation);
	local v33, v34 = u2.invMul(v27, v28, v29, v30, v31, v32, p16, p17);
	return v33, v34, p18 / l__AbsoluteSize__26.x, p19 / l__AbsoluteSize__26.y;
end;
return v1;

