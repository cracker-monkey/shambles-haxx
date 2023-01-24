
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("GuiCaptureIndicator");
local v3 = shared.require("GuiMathLib");
local u1 = shared.require("GuiInput");
local u2 = shared.require("spring");
local l__UserInputService__3 = game:GetService("UserInputService");
function v1.new(p1)
	local v4 = setmetatable({}, v1);
	v4._screenGui = p1;
	v4._guiInput = u1.new();
	v4._guiCaptureIndicators = {};
	v4:setRadius(40);
	v4._scrollSpring = u2.new(Vector3.zero, 1, 32);
	v4._lastInputtedScrollPosition = Vector3.zero;
	v4._scrollSpeed = 2;
	v4._inputChangedConnection = l__UserInputService__3.InputChanged:Connect(function(p2)
		l__UserInputService__3.MouseIconEnabled = true;
		if p2.UserInputType == Enum.UserInputType.MouseMovement then
			v4._guiInput:setPosition(p2.Position.x, p2.Position.y);
			return;
		end;
		if p2.UserInputType == Enum.UserInputType.MouseWheel then
			if p2.Position.z > 0 then
				local v5 = 1;
			else
				v5 = -1;
			end;
			v4._scrollSpring.t = v4._scrollSpring.t + Vector3.new(0, -v4._scrollSpeed * v5, 0);
		end;
	end);
	v4._inputBeganConnection = l__UserInputService__3.InputBegan:Connect(function(p3)
		if p3.UserInputType == Enum.UserInputType.MouseButton1 or p3.UserInputType == Enum.UserInputType.MouseButton2 then
			local v6 = v4._guiInput:capture(p3.UserInputType);
		end;
	end);
	v4._inputEndedConnection = l__UserInputService__3.InputEnded:Connect(function(p4)
		if p4.UserInputType == Enum.UserInputType.MouseButton1 or p4.UserInputType == Enum.UserInputType.MouseButton2 then
			local v7 = v4._guiInput:getCapture(p4.UserInputType);
			if v7 then
				v7:release();
			end;
		end;
	end);
	v4._renderSteppedConnection = game:GetService("RunService").RenderStepped:Connect(function()
		local v8 = v4._scrollSpring.p - v4._lastInputtedScrollPosition;
		if v8.magnitude > 0.001 then
			v4._lastInputtedScrollPosition = v4._lastInputtedScrollPosition + v8;
			v4._guiInput:fireInput("ScrollInput", v8);
		end;
		v4._guiInput:update();
	end);
	return v4;
end;
function v1.setRadius(p5, p6)
	p5._guiInput:setRadius(p6);
end;
function v1.destroy(p7)
	p7._guiInput:destroy();
	p7._inputChangedConnection:Disconnect();
	p7._inputBeganConnection:Disconnect();
	p7._inputEndedConnection:Disconnect();
	p7._renderSteppedConnection:Disconnect();
end;
return v1;

