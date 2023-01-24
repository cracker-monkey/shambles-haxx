
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {};
local l__PointToObjectSpace__2 = CFrame.new().PointToObjectSpace;
local u3 = nil;
function u1.segment(p1, p2)
	return u1.localSegment(l__PointToObjectSpace__2(u3, p1), l__PointToObjectSpace__2(u3, p2));
end;
local u4 = nil;
local u5 = nil;
function u1.localSegment(p3, p4)
	local v1 = nil;
	local v2 = -p3.z;
	local l__x__3 = p3.x;
	local l__y__4 = p3.y;
	local v5 = -p4.z - v2;
	local v6 = p4.x - l__x__3;
	local v7 = p4.y - l__y__4;
	local v8 = -v6 + v5 * u4;
	local v9 = v6 + v5 * u4;
	local v10 = -v7 + v5 * u5;
	local v11 = v7 + v5 * u5;
	v1 = -(-l__x__3 + v2 * u4) / v8;
	local v12 = -(l__x__3 + v2 * u4) / v9;
	local v13 = -(-l__y__4 + v2 * u5) / v10;
	local v14 = -(l__y__4 + v2 * u5) / v11;
	local v15 = 0;
	local v16 = 1;
	if v8 < 0 then
		if v1 < v16 then
			v16 = v1;
		end;
	elseif v8 > 0 and v15 < v1 then
		v15 = v1;
	end;
	if v9 < 0 then
		if v12 < v12 then
			v16 = v12;
		end;
	elseif v9 > 0 and v15 < v12 then
		v15 = v12;
	end;
	if v10 < 0 then
		if v13 < v16 then
			v16 = v13;
		end;
	elseif v10 > 0 and v15 < v13 then
		v15 = v13;
	end;
	if v11 < 0 then
		if v14 < v16 then
			v16 = v14;
		end;
	elseif v11 > 0 and v15 < v14 then
		v15 = v14;
	end;
	return v15 < v16;
end;
local u6 = nil;
local u7 = nil;
function u1.sphere(p5, p6)
	local v17 = l__PointToObjectSpace__2(u3, p5);
	local v18 = -v17.z;
	local l__x__19 = v17.x;
	local l__y__20 = v17.y;
	local v21 = false;
	if -v18 * u4 < l__x__19 + u6 * p6 then
		v21 = false;
		if l__x__19 - u6 * p6 < v18 * u4 then
			v21 = false;
			if -v18 * u5 < l__y__20 + u7 * p6 then
				v21 = false;
				if l__y__20 - u7 * p6 < v18 * u5 then
					v21 = -p6 < v18;
				end;
			end;
		end;
	end;
	return v21, v18;
end;
function u1.point(p7)
	local v22 = l__PointToObjectSpace__2(u3, p7);
	local v23 = -v22.z;
	local l__x__24 = v22.x;
	local l__y__25 = v22.y;
	local v26 = false;
	if -v23 * u4 < l__x__24 then
		v26 = false;
		if l__x__24 < v23 * u4 then
			v26 = false;
			if -v23 * u5 < l__y__25 then
				v26 = l__y__25 < v23 * u5;
			end;
		end;
	end;
	return v26;
end;
local u8 = nil;
local u9 = nil;
local u10 = math.pi / 180;
local u11 = nil;
local u12 = nil;
function u1.step(p8, p9, p10)
	u3 = p8;
	u8 = p9;
	u9 = p10 * u10 / 2;
	u11 = u8.y;
	u12 = u8.x;
	u5 = math.tan(u9);
	u4 = u12 / u11 * u5;
	u6 = (1 + u4 * u4) ^ 0.5;
	u7 = (1 + u5 * u5) ^ 0.5;
end;
u1.step(workspace.CurrentCamera.CFrame, workspace.CurrentCamera.ViewportSize, workspace.CurrentCamera.FieldOfView);
return u1;

