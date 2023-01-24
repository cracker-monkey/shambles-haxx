
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	closeCastBox = function(p1, p2, p3)
		local v1 = p1.x / 2;
		local v2 = p1.y / 2;
		local v3 = p1.z / 2;
		local v4 = p2.x;
		local v5 = p2.y;
		local v6 = p2.z;
		local v7 = p3.x;
		local v8 = p3.y;
		local v9 = p3.z;
		if v7 > 0 then
			v4 = -v4;
			v7 = -v7;
		end;
		if v8 > 0 then
			v5 = -v5;
			v8 = -v8;
		end;
		if v9 > 0 then
			v6 = -v6;
			v9 = -v9;
		end;
		local v10 = (-1 / 0);
		local v11 = (v1 - v4) / v7;
		local v12 = (v2 - v5) / v8;
		local v13 = (v3 - v6) / v9;
		if v7 ~= 0 and v10 < v11 then
			v10 = v11;
		end;
		if v8 ~= 0 and v10 < v12 then
			v10 = v12;
		end;
		if v9 ~= 0 and v10 < v13 then
			v10 = v13;
		end;
		if v10 == v12 then
			v2 = v1;
			v1 = v2;
			v5 = v4;
			v4 = v5;
			v8 = v7;
			v7 = v8;
		elseif v10 == v13 then
			v3 = v1;
			v1 = v3;
			v6 = v4;
			v4 = v6;
			v9 = v7;
			v7 = v9;
		end;
		if v5 + v10 * v8 < -v2 then
			v5 = -v5;
			v8 = -v8;
		elseif not (v2 < v5 + v10 * v8) then
			if v6 + v10 * v9 < -v3 then
				v3 = v2;
				v2 = v3;
				v6 = v5;
				v5 = -v6;
				v9 = v8;
				v8 = -v9;
			else
				if not (v3 < v6 + v10 * v9) then
					return v10, 0;
				end;
				v3 = v2;
				v2 = v3;
				v6 = v5;
				v5 = v6;
				v9 = v8;
				v8 = v9;
			end;
		end;
		local v14 = v4 - v1;
		local v15 = v5 - v2;
		local v16 = v7 * v14 + v8 * v15;
		local v17 = v7 * v7 + v8 * v8;
		local v18 = -v16 / v17;
		if v6 + v18 * v9 < -v3 then
			v6 = -v6;
			v9 = -v9;
		elseif not (v3 < v6 + v18 * v9) then
			return v18, (v14 * v14 + v15 * v15 - v16 * v16 / v17) ^ 0.5;
		end;
		local v19 = v4 - v1;
		local v20 = v5 - v2;
		local v21 = v6 - v3;
		local v22 = v7 * v19 + v8 * v20 + v9 * v21;
		local v23 = v7 * v7 + v8 * v8 + v9 * v9;
		return -v22 / v23, (v19 * v19 + v20 * v20 + v21 * v21 - v22 * v22 / v23) ^ 0.5;
	end, 
	getClosestPoint = function(p4, p5)
		local v24 = p4.x / 2;
		local v25 = p4.y / 2;
		local v26 = p4.z / 2;
		local v27 = p5.x;
		local v28 = p5.y;
		local v29 = p5.z;
		if v27 < -v24 then
			v27 = -v24;
		elseif v24 < v27 then
			v27 = v24;
		end;
		if v28 < -v25 then
			v28 = -v25;
		elseif v25 < v28 then
			v28 = v25;
		end;
		if v29 < -v26 then
			v29 = -v26;
		elseif v26 < v29 then
			v29 = v26;
		end;
		return Vector3.new(v27, v28, v29);
	end
};
local l__PointToObjectSpace__2 = CFrame.new().PointToObjectSpace;
local l__VectorToObjectSpace__3 = CFrame.new().VectorToObjectSpace;
function u1.closeCastPart(p6, p7, p8)
	local l__CFrame__30 = p6.CFrame;
	local v31, v32 = u1.closeCastBox(p6.Size, l__PointToObjectSpace__2(l__CFrame__30, p7), l__VectorToObjectSpace__3(l__CFrame__30, p8));
	local v33 = p7 + v31 * p8;
	local l__CFrame__34 = p6.CFrame;
	return v31, v33, l__CFrame__34 * u1.getClosestPoint(p6.Size, l__PointToObjectSpace__2(l__CFrame__34, v33)), v32;
end;
return u1;

