
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__setmetatable__1 = setmetatable;
function v1.new(p1)
	local v2 = {};
	local u2 = 0;
	local u3 = 0;
	local u4 = 0;
	local u5 = 0;
	local u6 = 0;
	local u7 = 0;
	local u8 = p1 and 1;
	function v2.__index(p2, p3)
		if p3 == "p" then
			local v3 = tick();
			if v3 < (u2 + u3) / 2 then
				local v4 = v3 - u2;
				return u4 + v4 * v4 / 2 * u5;
			elseif v3 < u3 then
				local v5 = v3 - u3;
				return u6 + v5 * v5 / 2 * u7;
			else
				return u6;
			end;
		end;
		if p3 ~= "v" then
			if p3 == "a" then
				return u8;
			elseif p3 == "t" then
				return u6;
			elseif p3 == "rtime" then
				local v6 = tick();
				return v6 < u3 and u3 - v6 or 0;
			else
				return;
			end;
		end;
		local v7 = tick();
		if v7 < (u2 + u3) / 2 then
			return (v7 - u2) * u5;
		end;
		if not (v7 < u3) then
			return 0;
		end;
		return (v7 - u3) * u7;
	end;
	local function u9(p4, p5, p6, p7)
		local v8 = tick();
		if not (v8 < (u2 + u3) / 2) and v8 < u3 then

		end;
		local v9 = p4 and v9;
		local v10 = p5 and v10;
		u8 = p6 or u8;
		local v11 = p7 or u6;
		if u8 < 0.0001 then
			u2 = 0;
			u4 = v9;
			u5 = 0;
			u3 = (1 / 0);
			u6 = v11;
			u7 = 0;
			return;
		end;
		local v12 = v11 < v9;
		local v13 = v10 < 0;
		if not (not v12) and not (not v13) and v9 - v10 * v10 / (2 * u8) < v11 or not v12 and (v13 or not v13 and v9 + v10 * v10 / (2 * u8) < v11) then
			u5 = u8;
			u3 = v8 + ((2 * v10 * v10 + 4 * u8 * (v11 - v9)) ^ 0.5 - v10) / u8;
		else
			u5 = -u8;
			local v14 = 2 * v10 * v10 - 4 * u8 * (v11 - v9);
			if v14 < 0 then
				u3 = v8 + v10 / u8;
			else
				u3 = v8 + (v14 ^ 0.5 + v10) / u8;
			end;
		end;
		u2 = v8 - v10 / u5;
		u4 = v9 - v10 * v10 / (2 * u5);
		u6 = v11;
		u7 = -u5;
	end;
	function v2.__newindex(p8, p9, p10)
		if p9 == "p" then
			u9(p10, nil, nil, nil);
			return;
		end;
		if p9 == "v" then
			u9(nil, p10, nil, nil);
			return;
		end;
		if p9 == "a" then
			p10 = p10 < 0 and -p10 or p10;
			u9(nil, nil, p10, nil);
			return;
		end;
		if p9 == "t" then
			u9(nil, nil, nil, p10);
			return;
		end;
		if p9 == "pt" then
			u9(p10, 0, nil, p10);
		end;
	end;
	return l__setmetatable__1({}, v2);
end;
return v1;

