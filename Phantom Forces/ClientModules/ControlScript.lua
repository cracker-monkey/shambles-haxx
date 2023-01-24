
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local function v2(p1)
	return p1 + Vector3.new(0, 0, -1);
end;
local function v3(p2)
	return p2 + Vector3.new(-1, 0, 0);
end;
local function v4(p3)
	return p3 + Vector3.new(0, 0, 1);
end;
local function v5(p4)
	return p4 + Vector3.new(1, 0, 0);
end;
local l__LocalPlayer__1 = game:GetService("Players").LocalPlayer;
local u2 = false;
local l__UserInputService__3 = game:GetService("UserInputService");
local u4 = {
	[Enum.KeyCode.W] = v2, 
	[Enum.KeyCode.A] = v3, 
	[Enum.KeyCode.S] = v4, 
	[Enum.KeyCode.D] = v5, 
	[Enum.KeyCode.Up] = v2, 
	[Enum.KeyCode.Down] = v4, 
	[Enum.KeyCode.Left] = v3, 
	[Enum.KeyCode.Right] = v5, 
	[Enum.KeyCode.Thumbstick1] = function(p5, p6)
		local l__Position__6 = p6.Position;
		local v7 = Vector3.new(l__Position__6.x, 0, -l__Position__6.y);
		local l__magnitude__8 = v7.magnitude;
		if l__magnitude__8 == 0 then
			local v9 = v7;
		elseif l__magnitude__8 < 0.25 then
			v9 = 0 * v7;
		elseif l__magnitude__8 < 1 then
			v9 = (1 - 0.25 / l__magnitude__8) / 0.75 * v7;
		else
			v9 = v7 / l__magnitude__8;
		end;
		return p5 + v9;
	end
};
local u5 = Vector3.zero;
game:GetService("RunService").Stepped:Connect(function()
	if not l__LocalPlayer__1.Character or u2 then
		return;
	end;
	local v10 = Vector3.zero;
	for v11, v12 in next, l__UserInputService__3:GetConnectedGamepads() do
		for v13, v14 in next, l__UserInputService__3:GetGamepadState(v12) do
			if u4[v14.KeyCode] then
				v10 = u4[v14.KeyCode](v10, v14);
			end;
		end;
	end;
	for v15, v16 in next, u4 do
		if l__UserInputService__3:IsKeyDown(v15) then
			v10 = v16(v10);
		end;
	end;
	local v17 = v10 + u5;
	if v17.magnitude > 1 then
		v17 = v17.unit;
	end;
	local v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29 = workspace.CurrentCamera.CFrame:components();
	l__LocalPlayer__1:Move(CFrame.Angles(0, math.atan2(v23 - v27, v21 + v29), 0) * v17, false);
end);
l__UserInputService__3.TextBoxFocused:Connect(function()
	u2 = true;
end);
l__UserInputService__3.TextBoxFocusReleased:Connect(function()
	u2 = false;
end);
function v1.addInputDirection(p7)
	u5 = p7;
end;
return v1;

