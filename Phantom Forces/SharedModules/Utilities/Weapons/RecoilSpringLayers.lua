
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("SpringLayers");
function v1.new(p1, p2, p3, p4)
	local v2 = setmetatable({}, v1);
	v2._hipParameters = p1;
	v2._aimParameters = p2;
	v2._hipRecoveryParameters = p3;
	v2._aimRecoveryParameters = p4;
	v2._lastImpulseTime = 0;
	v2._lastAimMode = false;
	v2._isRecoveryMode = false;
	v2._springLayersHash = {};
	for v3, v4 in next, { "x", "y", "z" } do
		local v5 = u1.new((math.max(#v2._hipParameters[v4], #v2._aimParameters[v4])));
		v5:setParameters(v2._hipParameters[v4]);
		v2._springLayersHash[v4] = v5;
	end;
	return v2;
end;
function v1.getPosition(p5)
	return Vector3.new(p5._springLayersHash.x:getPosition(), p5._springLayersHash.y:getPosition(), p5._springLayersHash.z:getPosition());
end;
function v1.setAim(p6, p7)
	local l__next__6 = next;
	local l___springLayersHash__7 = p6._springLayersHash;
	local v8 = nil;
	while true do
		local v9 = nil;
		local v10 = nil;
		v10, v9 = l__next__6(l___springLayersHash__7, v8);
		if not v10 then
			break;
		end;
		v8 = v10;
		if p7 then
			v9:setParameters(p6._aimParameters[v10]);
		else
			v9:setParameters(p6._hipParameters[v10]);
		end;	
	end;
	p6._lastAimMode = p7;
end;
local u2 = shared.require("GameClock");
function v1.applyImpulse(p8)
	p8._lastImpulseTime = u2.getTime();
	p8:setAim(p8._lastAimMode);
	for v11, v12 in next, p8._springLayersHash do
		v12:applyImpulse();
	end;
end;
function v1.step(p9)
	local v13 = p9._lastAimMode and p9._aimRecoveryParameters or p9._hipRecoveryParameters;
	if v13 then
		for v14, v15 in next, v13 do
			if p9._lastImpulseTime + v15.delay < u2.getTime() then
				p9._springLayersHash[v14]:setParameters(v15);
			end;
		end;
	end;
end;
return v1;

