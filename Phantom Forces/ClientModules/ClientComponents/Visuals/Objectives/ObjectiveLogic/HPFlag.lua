
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2._model = p1;
	v2._destructor = u1.new();
	v2._destructor:add(p1:WaitForChild("TeamColor"):GetPropertyChangedSignal("Value"):connect(function()
		v2:update();
	end));
	v2:update();
	return v2;
end;
function v1.update(p2)
	local l___model__3 = p2._model;
	local l__Letter__4 = l___model__3:WaitForChild("Flag"):WaitForChild("Spot"):WaitForChild("Letter");
	local l__Value__5 = l___model__3:WaitForChild("TeamColor").Value;
	local l__next__6 = next;
	local v7, v8 = l___model__3:GetDescendants();
	while true do
		local v9, v10 = l__next__6(v7, v8);
		if not v9 then
			break;
		end;
		v8 = v9;
		if v10:IsA("ParticleEmitter") then
			v10.Color = ColorSequence.new(l__Value__5.Color, Color3.new(1, 1, 1));
		end;	
	end;
	l__Letter__4.TextColor3 = l__Value__5.Color;
end;
function v1.Destroy(p3)
	p3._destructor:Destroy();
end;
return v1;

