
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = {};
local u2 = {
	linear = {
		p0 = 0, 
		v0 = 1, 
		p1 = 1, 
		v1 = 1
	}, 
	smooth = {
		p0 = 0, 
		v0 = 0, 
		p1 = 1, 
		v1 = 0
	}, 
	accelerate = {
		p0 = 0, 
		v0 = 0, 
		p1 = 1, 
		v1 = 1
	}, 
	decelerate = {
		p0 = 0, 
		v0 = 1, 
		p1 = 1, 
		v1 = 0
	}, 
	bump = {
		p0 = 0, 
		v0 = 4, 
		p1 = 0, 
		v1 = -4
	}, 
	acceleratebump = {
		p0 = 0, 
		v0 = 0, 
		p1 = 0, 
		v1 = -6.75
	}, 
	deceleratebump = {
		p0 = 0, 
		v0 = 6.75, 
		p1 = 0, 
		v1 = 0
	}
};
local u3 = shared.require("cframe");
local u4 = shared.require("Event").new();
function v1.tweencframe(p1, p2, p3, p4, p5)
	if u1[p1] then
		u1[p1]:disconnect();
	end;
	if type(p4) == "table" then
		local v2 = p4[1];
		local v3 = p4[2];
		local v4 = p4[3];
		local v5 = p4[4];
	else
		local v6 = u2[p4];
		v2 = v6.p0;
		v3 = v6.v0;
		v4 = v6.p1;
		v5 = v6.v1;
	end;
	local u5 = os.clock();
	local u6 = u3.interpolator(p1[p2], p5);
	local u7 = nil;
	u7 = u4:connect(function()
		local v7 = (os.clock() - u5) / p3;
		if v7 > 1 then
			p1[p2] = u6(v4);
			u7:disconnect();
			u1[p1] = nil;
			return;
		end;
		local v8 = 1 - v7;
		p1[p2] = u6(v2 * v8 * v8 * v8 + (3 * v2 + v3) * v7 * v8 * v8 + (3 * v4 - v5) * v7 * v7 * v8 + v4 * v7 * v7 * v7);
	end);
	u1[p1] = u7;
	return nil;
end;
function v1.freebody(p6, p7, p8, p9, p10, p11, p12)
	local l__p__9 = p9.p;
	local u8 = os.clock();
	local u9 = nil;
	local u10 = p9 - l__p__9;
	u9 = u4:connect(function()
		local v10 = os.clock() - u8;
		if p8 and p8 < v10 then
			u9:disconnect();
			p6:Destroy();
		end;
		p6[p7] = u3.fromaxisangle(v10 * p11) * u10 + l__p__9 + v10 * p10 + v10 * v10 * p12;
	end);
	return nil;
end;
function v1.step(...)
	u4:fire(...);
end;
table.freeze(v1);
return v1;

