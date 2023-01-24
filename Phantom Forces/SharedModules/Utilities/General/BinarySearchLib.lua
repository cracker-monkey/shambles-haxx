
-- Decompiled with the Synapse X Luau decompiler.

return {
	spanSearch = function(p1, p2)
		local v1 = 1;
		local v2 = #p1;
		if v2 < v1 then
			return nil, nil;
		end;
		if p2 < p1[v1] then
			return nil, v1;
		end;
		if p1[v2] < p2 then
			return v2, nil;
		end;
		while v2 - v1 > 1 do
			local v3 = (v1 + v2) / 2;
			local v4 = v3 - v3 % 1;
			if p2 < p1[v4] then
				v2 = v4;
			else
				v1 = v4;
			end;		
		end;
		return v1, v2;
	end, 
	spanSearchNodes = function(p3, p4, p5)
		local v5 = 1;
		local v6 = #p3;
		if v6 < v5 then
			return nil, nil;
		end;
		if p5 < p3[v5][p4] then
			return nil, v5;
		end;
		if p3[v6][p4] < p5 then
			return v6, nil;
		end;
		while v6 - v5 > 1 do
			local v7 = (v5 + v6) / 2;
			local v8 = v7 - v7 % 1;
			if p5 < p3[v8][p4] then
				v6 = v8;
			else
				v5 = v8;
			end;		
		end;
		return v5, v6;
	end, 
	spanSearchAnything = function(p6, p7, p8)
		local v9 = 1;
		local v10 = p6;
		if v10 < v9 then
			return nil, nil;
		end;
		if p8 < p7(v9) then
			return nil, v9;
		end;
		if p7(v10) < p8 then
			return v10, nil;
		end;
		while v10 - v9 > 1 do
			local v11 = (v9 + v10) / 2;
			local v12 = v11 - v11 % 1;
			if p8 < p7(v12) then
				v10 = v12;
			else
				v9 = v12;
			end;		
		end;
		return v9, v10;
	end
};

