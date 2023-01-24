
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("GuiInterestRegistry");
local l__UserInputService__3 = game:GetService("UserInputService");
local v4 = shared.require("GuiDirectionalNavigationLib");
local v5 = shared.require("GuiCaptureIndicator");
local u1 = shared.require("GuiInput");
local u2 = shared.require("spring");
function v1.new(p1, p2)
	local v6 = setmetatable({}, v1);
	v6._screenGui = p1;
	v6._inputObject = p2;
	v6._guiInput = u1.new();
	v6._guiInput:setPosition(p2.Position.x, p2.Position.y);
	v6._cursorGui = Instance.new("ImageLabel", v6._screenGui);
	v6._cursorGui.AnchorPoint = Vector2.new(0.5, 0.5);
	v6._cursorGui.BorderSizePixel = 0;
	v6._cursorGui.ImageColor3 = Color3.new(0.952941, 1, 0.423529);
	v6._cursorGui.Image = "http://www.roblox.com/asset/?id=1804987887";
	v6._cursorGui.BackgroundTransparency = 1;
	v6._radiusSpring = u2.new(6, 1, 20);
	v6:setRadius(24);
	v6._primaryCapture = v6._guiInput:capture("PrimaryInput");
	v6._changedConnection = v6._inputObject:GetPropertyChangedSignal("Position"):Connect(function()
		local l__Position__7 = v6._inputObject.Position;
		v6._guiInput:setPosition(l__Position__7.x, l__Position__7.y);
	end);
	v6._renderSteppedConnection = game:GetService("RunService").RenderStepped:Connect(function(p3)
		local v8, v9 = v6._guiInput:getPosition();
		v6._guiInput:update();
		local l__p__10 = v6._radiusSpring.p;
		local v11, v12, v13, v14 = v6:convertFromAbsoluteToRelativeScale(v8, v9, 2 * l__p__10, 2 * l__p__10);
		v6._cursorGui.Position = UDim2.new(v11, 0, v12, 0);
		v6._cursorGui.Size = UDim2.new(v13, 0, v14, 0);
	end);
	return v6;
end;
function v1.release(p4)
	p4._primaryCapture:release();
	p4:destroy();
end;
function v1.setRadius(p5, p6)
	p5._guiInput:setRadius(p6);
	p5._radiusSpring.t = p6;
end;
local u3 = shared.require("GuiMathLib");
function v1.convertFromAbsoluteToRelativeScale(p7, p8, p9, p10, p11)
	local l__AbsoluteSize__15 = p7._screenGui.AbsoluteSize;
	local v16, v17, v18, v19, v20, v21 = u3.getTopLeftScaledMatrix(l__AbsoluteSize__15, p7._screenGui.AbsolutePosition, p7._screenGui.AbsoluteRotation);
	local v22, v23 = u3.invMul(v16, v17, v18, v19, v20, v21, p8, p9);
	return v22, v23, p10 / l__AbsoluteSize__15.x, p11 / l__AbsoluteSize__15.y;
end;
function v1.destroy(p12)
	p12._cursorGui:Destroy();
	p12._guiInput:destroy();
	p12._changedConnection:Disconnect();
	p12._renderSteppedConnection:Disconnect();
end;
return v1;

