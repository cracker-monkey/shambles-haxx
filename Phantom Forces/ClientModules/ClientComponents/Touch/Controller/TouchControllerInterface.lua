
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = nil;
function v1.getObject()
	return u1;
end;
local u2 = false;
local u3 = true;
local u4 = shared.require("TouchControllerObject");
function v1.update()
	local v2 = u2 and u3;
	if v2 and not u1 then
		u1 = u4.new();
		return;
	end;
	if not v2 and u1 then
		u1:Destroy();
		u1 = nil;
	end;
end;
local u5 = shared.require("TouchScreenGui");
function v1._init()
	u5.onEnabled:connect(function()
		u2 = true;
		if u1 then
			u1:Destroy();
			u1 = nil;
		end;
		v1.update();
	end);
	u5.onDisabled:connect(function()
		u2 = false;
		v1.update();
	end);
	game:GetService("UserInputService").LastInputTypeChanged:Connect(function(p1)
		if p1 == Enum.UserInputType.Focus or p1 == Enum.UserInputType.Gyro then
			return;
		end;
		if p1 ~= Enum.UserInputType.Touch then
			u3 = false;
		elseif p1 == Enum.UserInputType.Touch then
			u3 = true;
		end;
		v1.update();
	end);
end;
return v1;

