
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("PageMainMenuDisplayMenu");
local v2 = shared.require("PageMainMenuInterface");
local v3 = shared.require("GuiInputInterface");
local v4 = shared.require("MenuScreenGui");
local v5 = shared.require("network");
local v6 = shared.require("MenuUtils");
local u1 = tick() + 1;
local function u2()
	if tick() < u1 then
		return;
	end;
	local v7, v8, v9 = v1.getSquadSpawnPlayer();
	if not v8 then
		return;
	end;
	if v9 then
		v9:setToggleState(false);
	end;
	u1 = tick() + 1;
	v5:send("spawn", v7);
end;
game:GetService("UserInputService").InputBegan:connect(function(p1, p2)
	if p2 then
		return;
	end;
	if v4.isEnabled() then
		local l__KeyCode__10 = p1.KeyCode;
		local l__Name__11 = p1.UserInputType.Name;
		if l__Name__11 == "Keyboard" and l__KeyCode__10 == Enum.KeyCode.Space or l__Name__11 == "Gamepad1" and l__KeyCode__10 == Enum.KeyCode.ButtonX then
			if game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Loadscreen") then
				return;
			end;
			u2();
		end;
	end;
end);
local v12 = {};
function v12.init(p3, p4)
	local v13 = p4.ButtonMain:Clone();
	v13.Visible = true;
	v13.Parent = p3;
	v6.setText(v13, "DEPLOY");
	v3.onReleased(v13, u2);
	return v13;
end;
return v12;

