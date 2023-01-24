
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("GuiInput");
local u2 = shared.require("spring");
local u3 = shared.require("GuiCaptureIndicator");
local l__UserInputService__4 = game:GetService("UserInputService");
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	v2._screenGui = p1;
	v2._guiInput = u1.new();
	local v3 = p1.AbsoluteSize / 2;
	v2._guiInput:setPosition(v3.x, v3.y);
	v2._cursorGui = Instance.new("ImageLabel", v2._screenGui);
	v2._cursorGui.Size = UDim2.new(0, 6, 0, 6);
	v2._cursorGui.AnchorPoint = Vector2.new(0.5, 0.5);
	v2._cursorGui.BorderSizePixel = 0;
	v2._cursorGui.ImageColor3 = Color3.new(0.952941, 1, 0.423529);
	v2._cursorGui.Image = "http://www.roblox.com/asset/?id=1804987887";
	v2._cursorGui.BackgroundTransparency = 1;
	v2._radiusSpring = u2.new(6, 1, 12);
	v2._offsetSpring = u2.new(Vector3.zero, 1, 24);
	v2._hoverGuiCaptureIndicator = u3.new(v2._guiInput:getHoverCapture(), p1, 1);
	v2._guiCaptureIndicators = {};
	v2:setRadius(48);
	v2._deadzone = 0.25;
	v2._gamepad = p2;
	v2._navStartT = nil;
	v2._navLastInt = nil;
	v2._inputBeganConnection = l__UserInputService__4.InputBegan:Connect(function(p3)
		if p3.UserInputType ~= v2._gamepad then
			return;
		end;
		if p3.KeyCode == Enum.KeyCode.ButtonA then
			local v4 = v2._guiInput:capture("PrimaryInput");
			local v5 = u3.new(v4, p1, 2, Color3.new(0.435294, 1, 0.435294));
			v2._guiCaptureIndicators[v4] = v5;
			v4.destroyed:connect(function()
				v5:destroy();
			end);
		end;
	end);
	v2._inputEndedConnection = l__UserInputService__4.InputEnded:Connect(function(p4)
		if p4.UserInputType ~= v2._gamepad then
			return;
		end;
		if p4.KeyCode == Enum.KeyCode.ButtonA then
			local v6 = v2._guiInput:getCapture("PrimaryInput");
			if v6 then
				v6:release();
			end;
		end;
	end);
	v2._timeAccelRate = 1;
	v2._curveDecelRate = 0.5;
	v2._cursorSpeed = 3000;
	v2._scrollSpeed = 32;
	v2._inputVel = Vector3.new(0, 0, 0);
	v2._renderSteppedConnection = game:GetService("RunService").RenderStepped:Connect(function(p5)
		local v7 = nil;
		l__UserInputService__4.MouseIconEnabled = false;
		local v8 = Vector3.zero;
		local v9 = Vector3.zero;
		local v10 = 0;
		local v11 = 0;
		local v12 = l__UserInputService__4:GetGamepadState(v2._gamepad);
		local v13 = nil;
		local v14 = nil;
		while true do
			local v15, v16 = v12(v13, v14);
			if not v15 then
				break;
			end;
			if v16.KeyCode == Enum.KeyCode.Thumbstick1 then
				local l__Position__17 = v16.Position;
				local l__magnitude__18 = l__Position__17.magnitude;
				if l__magnitude__18 > 1 then
					v8 = l__Position__17.unit;
				elseif v2._deadzone < l__magnitude__18 then
					v8 = (1 - v2._deadzone / l__magnitude__18) / (1 - v2._deadzone) * l__Position__17;
				end;
			elseif v16.KeyCode == Enum.KeyCode.Thumbstick2 then
				local l__Position__19 = v16.Position;
				local l__magnitude__20 = l__Position__19.magnitude;
				if l__magnitude__20 > 1 then
					v9 = l__Position__19.unit;
				elseif v2._deadzone < l__magnitude__20 then
					v9 = (1 - v2._deadzone / l__magnitude__20) / (1 - v2._deadzone) * l__Position__19;
				end;
			end;
			if v16.UserInputState == Enum.UserInputState.Begin then
				if v16.KeyCode == Enum.KeyCode.DPadLeft then
					v10 = v10 - 1;
				elseif v16.KeyCode == Enum.KeyCode.DPadRight then
					v10 = v10 + 1;
				elseif v16.KeyCode == Enum.KeyCode.DPadUp then
					v11 = v11 - 1;
				elseif v16.KeyCode == Enum.KeyCode.DPadDown then
					v11 = v11 + 1;
				end;
			end;		
		end;
		if v10 ^ 2 + v11 ^ 2 ~= 0 and not v2._navStartT then
			v2._navStartT = os.clock();
			v2._navLastInt = 0;
		elseif v10 ^ 2 + v11 ^ 2 == 0 and v2._navStartT then
			v2._navStartT = nil;
			v2._navLastInt = nil;
		end;
		if v2._navStartT then
			while v2._navLastInt < math.floor((6 * (os.clock() - v2._navStartT)) ^ 2 + 1) do
				v2._navLastInt = v2._navLastInt + 1;
				v2:directionalNavigate(v10, v11);			
			end;
		end;
		if v9.magnitude ~= 0 then
			v2._guiInput:fireInput("ScrollInput", p5 * v2._scrollSpeed * Vector3.new(1, -1, 1) * v9);
		end;
		local v21 = math.abs(math.atan2(v2._inputVel:Cross(v8).z, (v2._inputVel:Dot(v8))));
		v7 = v2._inputVel.magnitude;
		local l__magnitude__22 = v8.magnitude;
		if v21 == 0 then
			local v23 = v7 + p5 * l__magnitude__22 * v2._timeAccelRate;
		else
			local v24 = p5 * l__magnitude__22 * v2._timeAccelRate / (v21 * v2._curveDecelRate);
			v23 = v24 + math.exp(-v21 * v2._curveDecelRate) * (v7 - v24);
		end;
		if l__magnitude__22 == 0 then
			v2._inputVel = Vector3.zero;
		elseif v23 < 0 then
			v2._inputVel = Vector3.zero;
		elseif v23 < v8.magnitude then
			v2._inputVel = v23 * v8.unit;
		else
			v2._inputVel = v8;
		end;
		local v25, v26 = v2._guiInput:getPosition();
		local v27, v28 = v2:clamp(v25 + v2._cursorSpeed * p5 * v2._inputVel.x, v26 - v2._cursorSpeed * p5 * v2._inputVel.y);
		v2._guiInput:setPosition(v27, v28);
		v2._guiInput:update();
		local l__p__29 = v2._radiusSpring.p;
		local l__p__30 = v2._offsetSpring.p;
		local v31, v32, v33, v34 = v2:convertFromAbsoluteToRelativeScale(v27 + l__p__30.x, v28 + l__p__30.y, 2 * l__p__29, 2 * l__p__29);
		v2._cursorGui.Position = UDim2.new(v31, 0, v32, 0);
		v2._cursorGui.Size = UDim2.new(v33, 0, v34, 0);
		v2._hoverGuiCaptureIndicator:update();
		for v35, v36 in next, v2._guiCaptureIndicators do
			v36:update();
		end;
	end);
	return v2;
end;
function v1.setRadius(p6, p7)
	p6._guiInput:setRadius(p7);
	p6._radiusSpring.t = p7;
end;
local u5 = shared.require("GuiInterestRegistry");
local u6 = shared.require("GuiDirectionalNavigationLib");
function v1.directionalNavigate(p8, p9, p10)
	local v37 = u6.getNextSelection(u5:getEnabledList(), p9, p10, p8._guiInput:getPosition());
	if v37 then
		p8:setPositionSmooth(v37:getCenter());
	end;
end;
function v1.setPositionSmooth(p11, p12, p13)
	local v38, v39 = p11._guiInput:getPosition();
	p11._guiInput:setPosition(p12, p13);
	local l__p__40 = p11._offsetSpring.p;
	p11._offsetSpring.p = Vector3.new(v38 + l__p__40.x - p12, v39 + l__p__40.y - p13, 0);
	p11._offsetSpring.t = Vector3.zero;
end;
local u7 = shared.require("GuiMathLib");
function v1.convertFromAbsoluteToRelativeScale(p14, p15, p16, p17, p18)
	local l__AbsoluteSize__41 = p14._screenGui.AbsoluteSize;
	local v42, v43, v44, v45, v46, v47 = u7.getTopLeftScaledMatrix(l__AbsoluteSize__41, p14._screenGui.AbsolutePosition, p14._screenGui.AbsoluteRotation);
	local v48, v49 = u7.invMul(v42, v43, v44, v45, v46, v47, p15, p16);
	return v48, v49, p17 / l__AbsoluteSize__41.x, p18 / l__AbsoluteSize__41.y;
end;
function v1.clamp(p19, p20, p21)
	local v50, v51, v52, v53, v54, v55 = u7.getTopLeftScaledMatrix(p19._screenGui.AbsoluteSize, p19._screenGui.AbsolutePosition, p19._screenGui.AbsoluteRotation);
	local v56, v57 = u7.invMul(v50, v51, v52, v53, v54, v55, p20, p21);
	return u7.mul(v50, v51, v52, v53, v54, v55, math.clamp(v56, 0, 1), math.clamp(v57, 0, 1));
end;
function v1.destroy(p22)
	p22._cursorGui:Destroy();
	p22._guiInput:destroy();
	p22._inputBeganConnection:Disconnect();
	p22._inputEndedConnection:Disconnect();
	p22._renderSteppedConnection:Disconnect();
end;
return v1;

