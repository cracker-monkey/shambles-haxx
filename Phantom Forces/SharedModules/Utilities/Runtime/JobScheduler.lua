
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new()
	local v2 = setmetatable({}, v1);
	v2._jobs = {};
	v2._removals = {};
	return v2;
end;
local u1 = {};
function v1.connect(p1, p2, p3)
	local v3 = u1.new(p1, p2, p3);
	table.insert(p1._jobs, v3);
	return v3;
end;
function v1.getJobCount(p4)
	return #p4._jobs;
end;
function v1.step(p5, p6)
	local v4 = nil;
	local l___jobs__5 = p5._jobs;
	for v6 = #l___jobs__5, 1, -1 do
		if p5._removals[l___jobs__5[v6]] then
			p5._removals[l___jobs__5[v6]] = nil;
			l___jobs__5[v6] = l___jobs__5[#l___jobs__5];
			l___jobs__5[#l___jobs__5] = nil;
		end;
	end;
	local v7 = #l___jobs__5;
	v4 = 0;
	for v8 = 1, v7 do
		v4 = v4 + l___jobs__5[v8]:_iterateCount(p6);
	end;
	local v9 = math.floor(local v10);
	p5:_moveFirstKToFront(1, v7, v9);
	for v11 = 1, v9 do
		l___jobs__5[v11]:_step();
	end;
end;
function v1._moveFirstKToFront(p7, p8, p9, p10)
	if not (p8 <= p10) or not (p10 <= p9) then
		return;
	end;
	local l___jobs__12 = p7._jobs;
	local v13 = math.random(p8, p9);
	l___jobs__12[v13] = l___jobs__12[p9];
	l___jobs__12[p9] = l___jobs__12[v13];
	local v14 = p8;
	for v15 = p8, p9 do
		if l___jobs__12[v15]:_getScore() < l___jobs__12[p9]:_getScore() then
			l___jobs__12[v14] = l___jobs__12[v15];
			l___jobs__12[v15] = l___jobs__12[v14];
			v14 = v14 + 1;
		end;
	end;
	l___jobs__12[v14] = l___jobs__12[p9];
	l___jobs__12[p9] = l___jobs__12[v14];
	if v14 == p10 then
		return;
	end;
	if p10 < v14 then
		p7:_moveFirstKToFront(p8, v14 - 1, p10);
		return;
	end;
	p7:_moveFirstKToFront(v14 + 1, p9, p10);
end;
function v1._disconnectJob(p11, p12)
	p11._removals[p12] = true;
end;
u1.__index = u1;
function u1.new(p13, p14, p15)
	local v16 = setmetatable({}, u1);
	v16._jobScheduler = p13;
	v16._rate = p15 and 0;
	v16._func = p14;
	v16._count = 0;
	return v16;
end;
function u1.disconnect(p16)
	p16._jobScheduler:_disconnectJob(p16);
end;
function u1.setRate(p17, p18)
	p17._rate = p18;
end;
function u1._iterateCount(p19, p20)
	p19._count = p19._count + math.min(p20 * p19._rate, 1);
	return p19._count;
end;
function u1._getScore(p21)
	local v17 = (1 - p21._count) / p21._rate;
	if v17 ~= v17 then
		v17 = (1 / 0);
	end;
	return v17;
end;
function u1._step(p22)
	p22._count = p22._count - 1;
	p22:_func();
end;
return v1;

