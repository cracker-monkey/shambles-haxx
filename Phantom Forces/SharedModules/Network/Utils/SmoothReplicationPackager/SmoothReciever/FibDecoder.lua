
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = { 1, 2 };
while true do
	local v3 = #v2;
	v2[v3 + 1] = v2[v3] + v2[v3 - 1];
	if v2[v3 + 1] >= 9007199254740992 then
		break;
	end;
end;
function v1.new(p1)
	local v4 = setmetatable({}, v1);
	v4._accuracy = p1;
	return v4;
end;
function v1.__call(p2, p3)
	local v5 = 0;
	local v6 = 0;
	for v7 = 1, #v2 do
		local v8 = p3(1);
		if v8 == 1 then
			if v6 == 1 then
				break;
			end;
			v5 = v5 + v2[v7];
		end;
		v6 = v8;
	end;
	if v5 % 2 == 0 then
		local v9 = v5 / 2;
	else
		v9 = (1 - v5) / 2;
	end;
	return p2._accuracy * v9;
end;
return v1;

