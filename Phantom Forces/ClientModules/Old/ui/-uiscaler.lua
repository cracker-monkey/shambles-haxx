
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {};
local u2 = {
	scalechanged = shared.require("Event").new()
};
local u3 = 1;
function u2.setscale(p1)
	if p1 then
		for v1, v2 in u1, nil do
			v2.Scale = p1;
			if p1 ~= 1 then
				v2.Parent = v1;
			else
				v2.Parent = nil;
			end;
		end;
		u2.scalechanged:fire(p1, u3);
		u3 = p1;
	end;
end;
function u2.getscale()
	return u3;
end;
local u4 = shared.require("InstanceType");
local l__PlayerGui__5 = game:GetService("Players").LocalPlayer.PlayerGui;
function u2._init()
	if u4.IsConsole() then
		u3 = 1.5;
	end;
	for v3, v4 in { l__PlayerGui__5:WaitForChild("ChatGame"), l__PlayerGui__5:WaitForChild("Leaderboard"), l__PlayerGui__5:WaitForChild("MainGui") }, nil do
		local v5 = Instance.new("UIScale");
		v5.Parent = v4;
		u1[v4] = v5;
	end;
	u2.setscale(u3);
end;
return u2;

