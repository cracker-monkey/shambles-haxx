
-- Decompiled with the Synapse X Luau decompiler.

local l__UserInputService__1 = game:GetService("UserInputService");
local v2 = shared.require("GuiControllerCursor");
local v3 = shared.require("GuiTouchCursor");
local v4 = shared.require("GuiMouseCursor");
local v5 = shared.require("MenuScreenGui");
local u1 = true;
local u2 = {};
v5.onDisabled:connect(function()
	print("Disabling cursor");
	u1 = false;
	for v6, v7 in next, u2 do
		v7:destroy();
		u2[v6] = nil;
	end;
end);
v5.onEnabled:connect(function()
	print("Enabling cursor");
	u1 = true;
end);
local u3 = {
	[Enum.UserInputType.MouseMovement] = "Mouse", 
	[Enum.UserInputType.MouseButton1] = "Mouse", 
	[Enum.UserInputType.MouseButton2] = "Mouse", 
	[Enum.UserInputType.MouseButton3] = "Mouse", 
	[Enum.UserInputType.MouseWheel] = "Mouse", 
	[Enum.UserInputType.Gamepad1] = "Gamepad", 
	[Enum.UserInputType.Gamepad2] = "Gamepad", 
	[Enum.UserInputType.Gamepad3] = "Gamepad", 
	[Enum.UserInputType.Gamepad4] = "Gamepad", 
	[Enum.UserInputType.Gamepad5] = "Gamepad", 
	[Enum.UserInputType.Gamepad6] = "Gamepad", 
	[Enum.UserInputType.Gamepad7] = "Gamepad", 
	[Enum.UserInputType.Gamepad8] = "Gamepad"
};
local u4 = nil;
local function v8(p1)
	if u1 then
		if not u3[p1.UserInputType] then
			return;
		end;
		if u3[p1.UserInputType] ~= u4 then
			print("Destroying cursor", p1.UserInputType, u3[p1.UserInputType], u4);
			for v9, v10 in next, u2 do
				v10:destroy();
				u2[v9] = nil;
			end;
		end;
		local v11 = u3[p1.UserInputType];
		if v11 == "Mouse" then
			if not u2.Mouse then
				u2.Mouse = v4.new(v5.getScreenGui());
			end;
		elseif v11 == "Gamepad" and not u2[p1.UserInputType] then
			u2[p1.UserInputType] = v2.new(v5.getScreenGui(), p1.UserInputType);
		end;
		u4 = v11;
	end;
end;
l__UserInputService__1.InputBegan:Connect(v8);
l__UserInputService__1.InputChanged:Connect(v8);
local u5 = {};
l__UserInputService__1.InputBegan:Connect(function(p2)
	if p2.UserInputType == Enum.UserInputType.Touch then
		u5[p2] = v3.new(v5.getScreenGui(), p2);
	end;
end);
l__UserInputService__1.InputEnded:Connect(function(p3)
	if u5[p3] then
		u5[p3]:release();
	end;
end);
return true;

