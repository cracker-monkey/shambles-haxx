
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("ChatLibrary");
function v1.new(p1, p2, p3)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._textBox = p1.Design.TextBox;
	local function v3()
		local v4 = u2.preFilter(v2._textBox.Text);
		local v5 = false;
		if v4 ~= v2._textBox.PlaceholderText then
			v5 = v4 ~= "";
		end;
		p2(v2._textBox.Text, v5);
	end;
	v2._destructor:add(v2._textBox.FocusLost:connect(v3));
	v2._destructor:add(v2._textBox:GetPropertyChangedSignal("Text"):connect(v3));
	return v2;
end;
function v1.Destroy(p4)
	p4._destructor:Destroy();
end;
return v1;

