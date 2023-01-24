
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("spring");
function v1.new()
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._baseFieldOfView = 80;
	v2._defaultSettings = {
		speed = 20, 
		damping = 0.85
	};
	v2._logMagSpring = u2.new(0, v2._defaultSettings.damping, v2._defaultSettings.speed);
	return v2;
end;
function v1.Destroy(p1)
	p1._destructor:Destroy();
end;
local u3 = math.pi / 180;
function v1.getFieldOfView(p2)
	return math.atan(math.tan(p2._baseFieldOfView * u3 / 2) / 2.718281828459045 ^ p2._logMagSpring.p) / u3 * 2;
end;
function v1.getMagnification(p3)
	return 2.718281828459045 ^ p3._logMagSpring.t;
end;
function v1.getAngularZoomRatio(p4)
	return p4:getFieldOfView() / p4._baseFieldOfView;
end;
function v1.setSprings(p5, p6)
	p5._logMagSpring.s = p6.speed or p5._logMagSpring.s;
	p5._logMagSpring.d = p6.damping or p5._logMagSpring.d;
end;
function v1.resetSprings(p7)
	p7._logMagSpring.s = p7._defaultSettings.speed or p7._logMagSpring.s;
	p7._logMagSpring.d = p7._defaultSettings.damping or p7._logMagSpring.d;
end;
function v1.setMagnification(p8, p9)
	p8._logMagSpring.t = math.log(p9);
end;
function v1.setFieldOfView(p10, p11)
	p10._baseFieldOfView = p11;
	p10:setMagnification(1);
end;
return v1;

