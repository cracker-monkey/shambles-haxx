
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("spring");
function v1.new()
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._suppressionFactor = 1;
	v2._reductionFactor = 0.1;
	v2._suppressionTick0 = tick();
	v2._suppressionMultiplier0 = 1;
	v2._blurSpring = u2.new(0, 1, 40);
	v2._blur = Instance.new("BlurEffect");
	v2._blur.Parent = game.Lighting;
	v2._destructor:add(v2._blur);
	return v2;
end;
function v1.Destroy(p1)
	p1._destructor:Destroy();
end;
function v1.computeSuppressionMultiplier(p2)
	return 1 - (1 - p2._suppressionMultiplier0) * math.exp(-(tick() - p2._suppressionTick0) * p2._suppressionFactor);
end;
function v1.impulse(p3, p4, p5)
	local v3 = p3:computeSuppressionMultiplier();
	p3._blurSpring.v = p3._blurSpring.v + p3._blurSpring.s * p4 * 30 * v3;
	p3._suppressionTick0 = tick();
	p3._suppressionMultiplier0 = v3 * (1 - p3._reductionFactor / math.max(1, p5));
end;
function v1.step(p6)
	p6._blur.Size = p6._blurSpring.p;
end;
return v1;

