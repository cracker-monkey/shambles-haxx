
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = {};
local u2 = {};
function v1.add(p1, p2)
	if u1[p2] then
		return;
	end;
	local v2 = u2[p2.Name];
	if not v2 then
		return false;
	end;
	u1[p2] = v2.new(p2);
end;
function v1.clear(p3)
	for v3, v4 in next, u1 do
		v4:Destroy();
		u1[v3] = nil;
	end;
end;
function v1._init()
	local l__next__5 = next;
	local v6, v7 = script.Parent:WaitForChild("ObjectiveLogic"):GetChildren();
	while true do
		local v8, v9 = l__next__5(v6, v7);
		if not v8 then
			break;
		end;
		v7 = v8;
		u2[v9.Name] = require(v9);	
	end;
end;
return v1;

