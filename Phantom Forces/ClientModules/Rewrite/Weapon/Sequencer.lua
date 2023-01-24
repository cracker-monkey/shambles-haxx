
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
function v1.new()
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._t0 = nil;
	v2._n = 0;
	v2._deletions = 0;
	v2._sequence = {};
	return v2;
end;
function v1.Destroy(p1)
	p1._destructor:Destroy();
end;
local u2 = shared.require("GameClock");
function v1.add(p2, p3, p4)
	p2._n = p2._n + 1;
	if p2._n == 1 then
		p2._t0 = u2.getTime();
	end;
	p2._sequence[p2._n] = {
		func = p3, 
		dur = p4
	};
end;
function v1.delay(p5, p6)
	p5._n = p5._n + 1;
	if p5._n == 1 then
		p5._t0 = u2.getTime();
	end;
	p5._sequence[p5._n] = {
		dur = p6
	};
end;
function v1.clear(p7)
	for v3 = 1, p7._n do
		p7._sequence[v3] = nil;
	end;
	p7._deletions = 0;
	p7._n = 0;
end;
function v1.step(p8, p9)
	if p8._n == 0 then
		return;
	end;
	if p8._deletions ~= 0 then
		for v4 = p8._deletions + 1, p8._n do
			p8._sequence[v4 - p8._deletions] = p8._sequence[v4];
		end;
		for v5 = p8._n - p8._deletions + 1, p8._n do
			p8._sequence[v5] = nil;
		end;
		p8._n = p8._n - p8._deletions;
		p8._deletions = 0;
	end;
	local v6 = u2.getTime();
	for v7 = 1, p8._n do
		local v8 = v6 - p8._t0;
		local v9 = p8._sequence[v7];
		if v9 then
			local l__dur__10 = v9.dur;
			local v11 = false;
			if v9.func then
				v11 = v9.func(v8, p9);
			end;
			if not v11 and v11 ~= nil then
				if not l__dur__10 then
					break;
				end;
				if not (l__dur__10 < v8) then
					break;
				end;
			end;
			p8._t0 = v6;
			p8._deletions = p8._deletions + 1;
		end;
	end;
end;
table.freeze(v1);
return v1;

