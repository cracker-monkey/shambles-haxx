
-- Decompiled with the Synapse X Luau decompiler.

return {
	encode = function(p1)
		local v1 = {};
		local u1 = {};
		local u2 = 0;
		local function u3(p2)
			if not u1[p2] then
				u2 = u2 + 1;
				u1[p2] = u2;
				if type(p2) == "table" then
					local v2 = {};
					local v3 = {};
					local v4 = {};
					v2[1] = v3;
					v2[2] = v4;
					v1[u2] = v2;
					local v5 = 0;
					for v6, v7 in p2, nil do
						v5 = v5 + 1;
						v3[v5] = u3(v6);
						v4[v5] = u3(v7);
					end;
				else
					v1[u2] = p2;
				end;
			end;
			return u1[p2];
		end;
		u3(p1);
		return v1;
	end, 
	decode = function(p3)
		local u4 = {};
		local function u5(p4)
			local v8 = p3[p4];
			if type(v8) ~= "table" then
				return p3[p4];
			end;
			if not u4[p4] then
				local v9 = {};
				u4[p4] = v9;
				local v10 = v8[1];
				local v11 = v8[2];
				for v12 = 1, #v10 do
					v9[u5(v10[v12])] = u5(v11[v12]);
				end;
			end;
			return u4[p4];
		end;
		return u5(1);
	end
};

