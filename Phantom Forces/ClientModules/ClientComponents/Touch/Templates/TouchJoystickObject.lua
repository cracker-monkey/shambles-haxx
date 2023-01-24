
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
	v2._baseAnchor = Vector3.new(0.5, 0.5, 0);
	v2._guiObject = l__Templates__2.TouchJoystick:Clone();
	v2._guiObject.Position = p2;
	v2._guiObject.Size = p3;
	v2._guiObject.Parent = p1;
	v2._destructor:add(v2._guiObject);
	v2._joystickBase = v2._guiObject.JoystickBase;
	v2._joystickPad = v2._joystickBase.JoystickPad;
	v2._guiInterest = u3.new(v2._guiObject);
	v2._guiInterest:setGroup(p4 and "touchJoystick");
	v2._destructor:add(v2._guiInterest);
	v2._guiInteractions = {};
	v2._staticMode = false;
	v2._followMode = false;
	v2._orbitalMode = false;
	v2._unitRadius = 50;
	v2._orbitalRadius = 100;
	v2._followRadius = 150;
	v2._padRadius = 16;
	v2:_updateGuiSize();
	v2._followOffset = Vector3.zero;
	v2._inOrbit = false;
	v2._basePositionSpring = u4.new(Vector3.zero, 0.8, 20);
	v2._padPositionSpring = u4.new(Vector3.zero, 0.8, 20);
	v2.onDragged = u5.new();
	v2.onPressed = u5.new();
	v2.onReleased = u5.new();
	v2.onOrbited = u5.new();
	v2.onDeorbited = u5.new();
	v2.onReleasedInRange = u5.new();
	v2._guiInterest.inputCaptured:connect(function(p5)
		if p5:getInputTrigger() == nil then
			return;
		end;
		local v3, v4 = v2:_getOffsetFromAnchor(p5:getInputPosition());
		v2._guiInteractions[p5] = {
			init = Vector3.new(v3, v4, 0)
		};
		v2.onPressed:fire();
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
			if v2:getInteractionCount() == 0 then
				v2.onDragged:fire(0, 0, false);
			end;
		end);
	end);
	v2._destructor:add(game:GetService("RunService").RenderStepped:Connect(function()
		if v2:getInteractionCount() > 0 then
			local v5 = Vector3.zero;
			local v6 = Vector3.zero;
			local v7 = 0;
			for v8, v9 in next, v2._guiInteractions do
				if not v2._staticMode then
					v5 = v5 + v9.init;
				end;
				local v10, v11 = v2:_getOffsetFromAnchor(v8:getInputPosition());
				v6 = v6 + Vector3.new(v10, v11, 0);
				v7 = v7 + 1;
			end;
			local v12 = v5 / v7;
			local v13 = v6 / v7;
			if v2._followMode then
				local v14 = v13 - (v12 + v2._followOffset);
				local l__magnitude__15 = v14.magnitude;
				if v2._followRadius < l__magnitude__15 then
					v2._followOffset = v2._followOffset + (l__magnitude__15 - v2._followRadius) / l__magnitude__15 * v14;
				end;
			end;
			local v16 = v12 + v2._followOffset;
			local v17 = v13 - v16;
			local l__magnitude__18 = v17.magnitude;
			if v2._orbitalMode and v2._orbitalRadius < l__magnitude__18 then
				local v19 = v17 / l__magnitude__18;
				local v20 = true;
			elseif v2._unitRadius < l__magnitude__18 then
				v19 = v17 / l__magnitude__18;
				v20 = false;
			else
				v19 = v17 / v2._unitRadius;
				v20 = false;
			end;
			if v2._inOrbit and not v20 then
				v2.onDeorbited:fire();
			elseif not v2._inOrbit and v20 then
				v2.onOrbited:fire();
			end;
			v2._inOrbit = v20;
			v2.onDragged:fire(v19.x, -v19.y, v20);
			if v20 then
				local v21 = (v2._orbitalRadius + v2._padRadius) * v19;
			else
				v21 = v2._unitRadius * v19;
			end;
			local v22 = v2._basePositionSpring:update(v16, nil, nil, 1, 30);
			local v23 = v2._padPositionSpring:update(v21, nil, nil, 1, 50);
		else
			v2._followOffset = Vector3.zero;
			v22 = v2._basePositionSpring:update(Vector3.zero, nil, nil, 1, 30);
			v23 = v2._padPositionSpring:update(Vector3.zero, nil, nil, 0.6, 50);
		end;
		v2._joystickBase.Position = UDim2.new(v2._baseAnchor.x, math.round(v22.x), v2._baseAnchor.y, math.round(v22.y));
		v2._joystickPad.Position = UDim2.new(0.5, math.round(v23.x), 0.5, math.round(v23.y));
	end));
	v2:_updateGuiSize();
	return v2;
end;
function v1.Destroy(p6)
	p6._destructor:Destroy();
end;
local u6 = shared.require("GuiMathLib");
function v1._getOffsetFromAnchor(p7, p8, p9)
	local v24, v25, v26 = u6.getGuiData(p7._guiObject);
	local v27, v28, v29, v30, v31, v32 = u6.getTopLeftScaledMatrix(v24, v25, v26);
	local v33, v34, v35, v36, v37, v38 = u6.getTopLeftUnitMatrix(v24, v25, v26);
	local v39, v40 = u6.mul(v27, v28, v29, v30, v31, v32, p7._baseAnchor.x, p7._baseAnchor.y);
	return u6.invMul(v39, v40, v35, v36, v37, v38, p8, p9);
end;
function v1._updateGuiSize(p10)
	p10._joystickBase.Size = UDim2.fromOffset(2 * p10._unitRadius, 2 * p10._unitRadius);
	p10._joystickPad.Size = UDim2.fromOffset(2 * p10._padRadius, 2 * p10._padRadius);
end;
function v1.getGuiObject(p11)
	return p11._guiObject;
end;
function v1.setLayer(p12, p13)
	p12._guiInterest:setLayer(p13);
end;
function v1.setBaseAnchor(p14, p15)
	p14._baseAnchor = Vector3.new(p15.x, p15.y, 0);
end;
function v1.setStaticMode(p16, p17)
	p16._staticMode = p17;
end;
function v1.setFollowMode(p18, p19)
	p18._followMode = p19;
end;
function v1.setOrbitalMode(p20, p21)
	p20._orbitalMode = p21;
end;
function v1.setOrbitalRadius(p22, p23)
	p22._orbitalRadius = p23;
end;
function v1.setFollowRadius(p24, p25)
	p24._followRadius = p25;
end;
function v1.setBaseRadius(p26, p27)
	p26._unitRadius = p27;
	p26:_updateGuiSize();
end;
function v1.setPadRadius(p28, p29)
	p28._padRadius = p29;
	p28:_updateGuiSize();
end;
function v1.getInteractionCount(p30)
	local v41 = 0;
	for v42, v43 in next, p30._guiInteractions do
		v41 = v41 + 1;
	end;
	return v41;
end;
return v1;

