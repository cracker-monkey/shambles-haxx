
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PlayerSettingsInterface");
local v3 = shared.require("PlayerSettingsEvents");
local l__UserInputService__4 = game:GetService("UserInputService");
local v5 = shared.require("InputType");
local v6 = shared.require("Event");
local l__HapticService__7 = game:GetService("HapticService");
if l__HapticService__7:IsVibrationSupported(Enum.UserInputType.Gamepad1) then
	largevibrations = l__HapticService__7:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large);
end;
v1.keyboard = {};
v1.keyboard.down = {};
v1.keyboard.onkeydown = v6.new();
v1.keyboard.onkeyup = v6.new();
v1.mouse = {};
v1.mouse.Position = Vector3.zero;
v1.mouse.down = {};
v1.mouse.onbuttondown = v6.new();
v1.mouse.onbuttonup = v6.new();
v1.mouse.onmousemove = v6.new();
v1.mouse.onscroll = v6.new();
v1.controller = {};
v1.controller.down = {};
v1.controller.inuse = false;
v1.controller.onbuttondown = v6.new();
v1.controller.onbuttonup = v6.new();
v1.controller.onintegralmove = v6.new();
v1.controller.onstatuschanged = v6.new();
v1.consoleon = not l__UserInputService__4.KeyboardEnabled;
v1.touch = {};
v1.touch.onlookmove = v6.new();
v1.touch.onshootpressed = v6.new();
v1.touch.onshootreleased = v6.new();
local u1 = shared.require("GameClock");
v1.keyboard.onkeydown:connect(function(p1)
	v1.keyboard.down[p1] = u1.getTime();
end);
v1.keyboard.onkeyup:connect(function(p2)
	v1.keyboard.down[p2] = nil;
end);
local v8 = v2.getValue("controllerdeadzone") and 0.25;
local v9 = {};
function v1.iskeydown(p3)
	return l__UserInputService__4:IsKeyDown(p3);
end;
local u2 = {
	ButtonX = "x", 
	ButtonY = "y", 
	ButtonA = "a", 
	ButtonB = "b", 
	ButtonR1 = "r1", 
	ButtonL1 = "l1", 
	ButtonR2 = "r2", 
	ButtonL2 = "l2", 
	ButtonR3 = "r3", 
	ButtonL3 = "l3", 
	ButtonStart = "start", 
	ButtonSelect = "select", 
	DPadLeft = "left", 
	DPadRight = "right", 
	DPadUp = "up", 
	DPadDown = "down"
};
local u3 = {};
function v1.processInputChanged(p4)
	local l__Name__10 = p4.UserInputType.Name;
	local l__Position__11 = p4.Position;
	if l__Name__10 == "MouseMovement" then
		v1.mouse.position = l__Position__11;
		v1.mouse.onmousemove:fire(p4.Delta);
		v1.controller.onstatuschanged:fire(false);
		return;
	end;
	if l__Name__10 == "MouseWheel" then
		v1.mouse.onscroll:fire(l__Position__11.z);
		return;
	end;
	if l__Name__10 == "Gamepad1" then
		local l__Name__12 = p4.KeyCode.Name;
		if l__Name__12 == "Thumbstick2" or l__Name__12 == "Thumbstick1" then
			v1.controller.onstatuschanged:fire(true);
		end;
		if l__Name__12 == "Thumbstick2" then
			return;
		end;
		if l__Name__12 == "ButtonL2" or l__Name__12 == "ButtonR2" then
			local v13 = u2[l__Name__12];
			if l__Position__11.z > 0.1 and not v1.controller.down[v13] then
				local v14 = u3[v13];
				if v14 then
					v1.keyboard.down[v14] = u1.getTime();
					v1.keyboard.onkeydown:fire(v14);
				end;
				v1.controller.down[v13] = u1.getTime();
				v1.controller.onbuttondown:fire(v13);
				return;
			end;
			if l__Position__11.z < 0.1 and v1.controller.down[v13] then
				local v15 = u3[v13];
				if v15 then
					v1.keyboard.down[v15] = nil;
					v1.keyboard.onkeyup:fire(v15);
				end;
				v1.controller.down[v13] = nil;
				v1.controller.onbuttonup:fire(v13);
			end;
		end;
	end;
end;
local u4 = nil;
function v1.processInputBegan(p5)
	if u4 then
		return;
	end;
	local v16 = u1.getTime();
	local l__Name__17 = p5.UserInputType.Name;
	if l__Name__17 == "Keyboard" then
		local v18 = string.lower(p5.KeyCode.Name);
		v1.keyboard.down[v18] = v16;
		v1.keyboard.onkeydown:fire(v18);
		v1.controller.onstatuschanged:fire(false);
		return;
	end;
	if l__Name__17 == "Gamepad1" then
		local v19 = u2[p5.KeyCode.Name];
		if not (not v19) and v19 ~= "l2" and v19 ~= "r2" or not v1.controller.down[v19] then
			local v20 = u3[v19];
			if v20 then
				v1.keyboard.down[v20] = v16;
				v1.keyboard.onkeydown:fire(v20);
			end;
			v1.controller.down[v19] = v16;
			v1.controller.onbuttondown:fire(v19);
			v1.controller.onstatuschanged:fire(true);
			return;
		end;
	else
		if l__Name__17 == "MouseButton1" then
			v1.mouse.down.left = v16;
			v1.mouse.onbuttondown:fire("left");
			return;
		end;
		if l__Name__17 == "MouseButton2" then
			v1.mouse.down.right = v16;
			v1.mouse.onbuttondown:fire("right");
			return;
		end;
		if l__Name__17 == "MouseButton3" then
			v1.mouse.down.middle = v16;
			v1.mouse.onbuttondown:fire("middle");
		end;
	end;
end;
l__UserInputService__4.TextBoxFocused:connect(function()
	u4 = true;
end);
l__UserInputService__4.TextBoxFocusReleased:connect(function()
	u4 = false;
end);
l__UserInputService__4.InputEnded:connect(function(p6)
	if u4 then
		return;
	end;
	local l__Name__21 = p6.UserInputType.Name;
	if l__Name__21 == "Keyboard" then
		local v22 = string.lower(p6.KeyCode.Name);
		v1.keyboard.down[v22] = nil;
		v1.keyboard.onkeyup:fire(v22);
		return;
	end;
	if l__Name__21 == "Gamepad1" then
		local v23 = u2[p6.KeyCode.Name];
		if not (not v23) and v23 ~= "l2" and v23 ~= "r2" or v1.controller.down[v23] then
			local v24 = u3[v23];
			if v24 then
				v1.keyboard.down[v24] = nil;
				v1.keyboard.onkeyup:fire(v24);
			end;
			v1.controller.down[v23] = nil;
			v1.controller.onbuttonup:fire(v23);
			return;
		end;
	else
		if l__Name__21 == "MouseButton1" then
			v1.mouse.down.left = nil;
			v1.mouse.onbuttonup:fire("left");
			return;
		end;
		if l__Name__21 == "MouseButton2" then
			v1.mouse.down.right = nil;
			v1.mouse.onbuttonup:fire("right");
			return;
		end;
		if l__Name__21 == "MouseButton3" then
			v1.mouse.down.middle = nil;
			v1.mouse.onbuttonup:fire("middle");
		end;
	end;
end);
v1.controller.firevibration = function(p7)

end;
v1.mouse.hide = function(p8)
	l__UserInputService__4.MouseIconEnabled = false;
end;
v1.mouse.show = function(p9)
	l__UserInputService__4.MouseIconEnabled = true;
end;
v1.mouse.visible = function()
	return l__UserInputService__4.MouseIconEnabled;
end;
v1.mouse.lockcenter = function(p10)
	l__UserInputService__4.MouseBehavior = "LockCenter";
end;
v1.mouse.free = function(p11)
	l__UserInputService__4.MouseBehavior = "Default";
end;
v1.mouse.lock = function(p12)
	l__UserInputService__4.MouseBehavior = "LockCurrentPosition";
end;
v1.controller.map = function(p13, p14, p15)
	u3[p14] = p15;
end;
v1.controller.unmap = function(p16, p17)
	u3[p17] = nil;
end;
local u5 = {};
function v1.mapaction(p18, p19, p20)
	u5[p19] = p20;
end;
function v1.getInputType()
	if v5.purecontroller() then
		return "controller";
	end;
	return "keyboard";
end;
local u6 = v8;
function v1.step(p21)
	local v25 = Vector3.zero;
	local v26 = 0;
	for v27, v28 in l__UserInputService__4:GetGamepadState(Enum.UserInputType.Gamepad1), nil do
		if v28.KeyCode == Enum.KeyCode.Thumbstick2 then
			local l__Position__29 = v28.Position;
			local l__magnitude__30 = l__Position__29.magnitude;
			if u6 < l__magnitude__30 then
				v25 = (1 - u6 / l__magnitude__30) / (1 - u6) * l__Position__29;
			end;
			v26 = v26 + 1;
		end;
	end;
	if v26 > 1 then
		print("wtha the hel");
	end;
	if v1.getInputType() == "controller" then
		v1.controller.onintegralmove:fire(v25, p21);
	end;
end;
v3.onSettingChanged:connect(function(p22, p23)
	if p22 == "controllerdeadzone" then
		u6 = p23;
	end;
end);
return v1;

