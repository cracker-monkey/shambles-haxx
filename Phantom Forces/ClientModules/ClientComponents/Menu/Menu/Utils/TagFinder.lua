
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("Event");
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	if not p1 then
		error("TagFinder: No root provided: " .. p2);
		return;
	end;
	v2._destructor = u1.new();
	v2._root = p1;
	v2._className = p2;
	v2.onTagAdded = u2.new();
	v2._destructor:add(p1.DescendantAdded:connect(function(p3)
		local v3, v4 = v2:check(p3);
		if v3 and v4 then
			v2.onTagAdded:fire(v3, v4);
		end;
	end));
	return v2;
end;
function v1.Destroy(p4)
	p4._destructor:Destroy();
end;
function v1.check(p5, p6)
	if not p6:IsA(p5._className) then
		return;
	end;
	local v5 = p6.Parent;
	while v5:IsA("Folder") do
		v5 = v5.Parent;	
	end;
	return v5, p6;
end;
function v1.search(p7, p8)
	local l__next__6 = next;
	local v7, v8 = p7._root:GetDescendants();
	while true do
		local v9, v10 = l__next__6(v7, v8);
		if not v9 then
			break;
		end;
		v8 = v9;
		local v11, v12 = p7:check(v10);
		if v11 and v12 then
			p8(v11, v12);
		end;	
	end;
end;
return v1;

