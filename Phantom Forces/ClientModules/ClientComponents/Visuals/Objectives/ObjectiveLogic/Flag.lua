
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2._model = p1;
	v2._destructor = u1.new();
	local v3 = {};
	v2._destructor:add(p1:WaitForChild("TeamColor"):GetPropertyChangedSignal("Value"):connect(function()
		v2:update();
	end));
	v2._destructor:add(p1:WaitForChild("Letter"):GetPropertyChangedSignal("Value"):connect(function()
		v2:update();
	end));
	v2:update();
	return v2;
end;
function v1.update(p2)
	local l___model__4 = p2._model;
	local l__Letter__5 = l___model__4:WaitForChild("Letter");
	local l__Letter__6 = l___model__4:WaitForChild("Flag"):WaitForChild("Spot"):WaitForChild("Letter");
	local l__Value__7 = l___model__4:WaitForChild("TeamColor").Value;
	local l__next__8 = next;
	local v9, v10 = l___model__4:GetDescendants();
	while true do
		local v11, v12 = l__next__8(v9, v10);
		if not v11 then
			break;
		end;
		v10 = v11;
		if v12:IsA("ParticleEmitter") then
			v12.Color = ColorSequence.new(l__Value__7.Color, Color3.new(1, 1, 1));
		end;	
	end;
	l__Letter__6.TextColor3 = l__Value__7.Color;
	l__Letter__6.Text = l__Letter__5.Value;
end;
function v1.Destroy(p3)
	p3._destructor:Destroy();
end;
return v1;

