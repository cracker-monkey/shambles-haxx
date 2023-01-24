
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local function u1(p1, p2, p3, p4, p5, p6, p7)
	local v2 = p2 - p1;
	local v3 = p3 - p1;
	if p6 < v2 then
		local v4 = math.min(v2, p7);
		local v5 = p2 + 0 * v4 - 0 / p4 + math.exp((p6 - v4) * p4) * (p5 - p2 + 0 / p4 - 0 * p6);
		if p7 <= v2 then
			return v5;
		else
			return u1(p1, p2, p3, p4, v5, v4, p7);
		end;
	elseif p6 < v3 then
		v4 = math.min(v3, p7);
		v5 = p1 + 1 * v4 - 1 / p4 + math.exp((p6 - v4) * p4) * (p5 - p1 + 1 / p4 - 1 * p6);
		if p7 <= v3 then
			return v5;
		else
			return u1(p1, p2, p3, p4, v5, v4, p7);
		end;
	end;
	return p3 + 0 * p7 - 0 / p4 + math.exp((p6 - p7) * p4) * (p5 - p3 + 0 / p4 - 0 * p6);
end;
function v1.new(p8, p9, p10, p11)
	local v6 = setmetatable({}, v1);
	v6._sampleSecondsAtLimit = p8;
	v6._extrapolationLimit = p9;
	v6._interpolationFunc = p11;
	v6._maxDelay = p10;
	v6:init();
	return v6;
end;
function v1.init(p12)
	p12._weightTotal = 0;
	p12._offsetTotal = 0;
	p12._initialOffset = 0;
	p12._prevLocalTime = nil;
	p12._prevFrameTime = nil;
	p12._frameTimeMin = nil;
	p12._smoothTimeP0 = nil;
	p12._smoothTimeT0 = nil;
	p12._frameTimeList = {};
	p12._frameDataList = {};
	p12._discontinuityList = {};
	p12._ready = false;
end;
function v1.receive(p13, p14, p15, p16, p17, p18)
	if p13._prevLocalTime and p13._prevFrameTime then
		if p13._smoothTimeP0 and p13._smoothTimeT0 then
			p13._smoothTimeP0 = p13:getSmoothTime(p14);
			p13._smoothTimeT0 = p14;
			p13._frameTimeMin = math.min(p13._offsetTotal / p13._weightTotal + p14, p13._prevFrameTime);
		end;
		local v7 = p13._prevFrameTime - math.min(p14, p13._prevLocalTime + p13._maxDelay);
		if not p18 then
			local v8 = math.exp(-(p14 - p13._prevLocalTime) / p13._sampleSecondsAtLimit);
			p13._weightTotal = v8 * (p13._weightTotal - 1) + 1;
			p13._offsetTotal = v8 * (p13._offsetTotal - v7) + v7;
			p13._initialOffset = v7;
		end;
		if not p13._smoothTimeP0 or not p13._smoothTimeT0 then
			p13._smoothTimeP0 = p14 + p13._offsetTotal / p13._weightTotal;
			p13._smoothTimeT0 = p14;
			p13._frameTimeMin = p14 + p13._offsetTotal / p13._weightTotal;
			p13._ready = true;
		end;
	end;
	p13._prevLocalTime = p14;
	p13._prevFrameTime = p15;
	table.insert(p13._frameTimeList, p15);
	table.insert(p13._frameDataList, p16);
	if p17 then
		local v9 = true;
	else
		v9 = false;
	end;
	table.insert(p13._discontinuityList, v9);
end;
function v1.isReady(p19)
	return p19._ready;
end;
function v1.getOffset(p20)
	return p20._offsetTotal / p20._weightTotal - p20._initialOffset;
end;
function v1.getSmoothTime(p21, p22)
	return u1(p21._offsetTotal / p21._weightTotal + p21._extrapolationLimit, p21._frameTimeMin + p21._extrapolationLimit, p21._prevFrameTime + p21._extrapolationLimit, 1 / p21._extrapolationLimit, p21._smoothTimeP0, p21._smoothTimeT0, p22);
end;
function v1.getPreviousFrameIndex(p23, p24)
	if #p23._frameTimeList == 0 then
		return;
	end;
	for v10 = #p23._frameTimeList, 1, -1 do
		if p23._frameTimeList[v10] < p24 then
			return v10;
		end;
	end;
	return 1;
end;
function v1.cleanFrameCache(p25, p26)
	for v11 = 1, p26 do
		table.remove(p25._frameDataList, 1);
		table.remove(p25._frameTimeList, 1);
		table.remove(p25._discontinuityList, 1);
	end;
end;
function v1.getFrame(p27, p28)
	local v12 = p27:getSmoothTime(p28);
	local v13 = p27:getPreviousFrameIndex(v12);
	if not v13 then
		return;
	end;
	if p27._frameTimeList[v13 + 1] and not p27._discontinuityList[v13 + 1] then
		local v14 = p27._interpolationFunc(p27._frameDataList[v13], p27._frameDataList[v13 + 1], p27._frameTimeList[v13], p27._frameTimeList[v13 + 1], v12);
		p27:cleanFrameCache(v13 - 1);
		return v14;
	end;
	if not p27._frameTimeList[v13 - 1] or not (not p27._discontinuityList[v13]) then
		p27:cleanFrameCache(v13 - 1);
		return p27._frameDataList[v13];
	end;
	local v15 = p27._interpolationFunc(p27._frameDataList[v13 - 1], p27._frameDataList[v13], p27._frameTimeList[v13 - 1], p27._frameTimeList[v13], v12);
	p27:cleanFrameCache(v13 - 2);
	return v15;
end;
return v1;

