
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("TouchScreenGui").getScreenGui();
local u1 = shared.require("Destructor");
local u2 = shared.require("TouchConfig");
local u3 = shared.require("GuiCollisionService");
function v1.new()
	local v3 = setmetatable({}, v1);
	v3._destructor = u1.new();
	v3._buttonRegistry = {};
	for v4, v5 in next, u2.buttonTypes do
		local v6 = v5.new();
		v3._buttonRegistry[v4] = v6;
		v3._destructor:add(v6);
	end;
	u3:disableCollisions("touchButton", "touchField");
	return v3;
end;
function v1.Destroy(p1)
	p1._destructor:Destroy();
end;
function v1.addButton(p2, p3)

end;
return v1;

