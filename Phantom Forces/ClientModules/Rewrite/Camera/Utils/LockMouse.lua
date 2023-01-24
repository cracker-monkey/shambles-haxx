
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local l__UserInputService__2 = game:GetService("UserInputService");
function v1.new()
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._lockMouseCenter = true;
	v2._toggleMouseIcon = false;
	v2._destructor:add(l__UserInputService__2.InputChanged:connect(function(p1)
		l__UserInputService__2.MouseBehavior = v2._lockMouseCenter and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default;
		l__UserInputService__2.MouseIconEnabled = v2._toggleMouseIcon;
	end));
	local function v3()
		if not v2._lockMouseCenter then
			return;
		end;
		l__UserInputService__2.MouseBehavior = Enum.MouseBehavior.Default;
		wait();
		l__UserInputService__2.MouseBehavior = Enum.MouseBehavior.LockCenter;
	end;
	v2._destructor:add(l__UserInputService__2.WindowFocusReleased:Connect(v3));
	v2._destructor:add(l__UserInputService__2.WindowFocused:Connect(v3));
	local u3 = game:GetService("RunService"):IsStudio();
	v2._destructor:add(l__UserInputService__2.InputBegan:connect(function(p2, p3)
		if p3 then
			return;
		end;
		local l__Name__4 = p2.KeyCode.Name;
		if u3 then
			if l__Name__4 ~= "M" then
				if l__Name__4 == "K" then
					v2._lockMouseCenter = not v2._lockMouseCenter;
					v2._toggleMouseIcon = false;
				end;
				return;
			end;
		else
			return;
		end;
		v2._toggleMouseIcon = not v2._toggleMouseIcon;
	end));
	return v2;
end;
function v1.Destroy(p4)
	p4._destructor:Destroy();
end;
return v1;

