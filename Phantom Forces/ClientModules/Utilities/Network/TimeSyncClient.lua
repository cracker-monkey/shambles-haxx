
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local l__syncRate__1 = shared.require("NetworkConfig").syncRate;
function v1.new()
	local v2 = setmetatable({}, v1);
	v2._cState = {};
	v2._cState.cTime0 = nil;
	v2._cState.offset0 = nil;
	v2._cState.offsetTarget = nil;
	v2._cState.syncRate = l__syncRate__1;
	v2._cState.ready = false;
	return v2;
end;
function v1.getTime(p1)
	local v3 = p1:_getCTime();
	return v3 - p1:_getCStateOffset(v3);
end;
function v1.step(p2, p3, p4)
	local v4 = p2:_getCTime();
	p2:_stepCState(v4, p4);
	return p3, v4, tick();
end;
function v1._getCTime(p5)
	return os.clock();
end;
function v1.isReady(p6)
	return p6._cState.ready;
end;
function v1._stepCState(p7, p8, p9)
	local l___cState__5 = p7._cState;
	if l___cState__5.offset0 then
		l___cState__5.offset0 = p7:_getCStateOffset(p8);
		l___cState__5.ready = true;
	else
		l___cState__5.offset0 = p9;
	end;
	l___cState__5.cTime0 = p8;
	l___cState__5.offsetTarget = p9;
end;
function v1._getCStateOffset(p10, p11)
	local v6 = nil;
	local l___cState__7 = p10._cState;
	v6 = l___cState__7.syncRate * (p11 - l___cState__7.cTime0);
	if l___cState__7.offsetTarget < l___cState__7.offset0 then
		return math.max(l___cState__7.offsetTarget, l___cState__7.offset0 - v6);
	end;
	return math.min(l___cState__7.offsetTarget, l___cState__7.offset0 + v6);
end;
return v1;

