
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("StateMachine");
setmetatable(v1, v2);
function v1.new(p1)
	local v3 = v2.new();
	setmetatable(v3, v1);
	v3:addState("meleeReady", true);
	v3:addState("meleeing");
	v3:addState("meleeCancelling");
	local v4 = {};
	local v5 = {
		state0 = "meleeReady", 
		state1 = "meleeing"
	};
	function v5.conditionalFunc()
		return p1:canMelee();
	end;
	v4[1] = v5;
	v3:addConditionalTransition("meleeStart", v4);
	v3:addStateTransition("meleeFinish", {
		state0 = "meleeing", 
		state1 = "meleeReady", 
		timeBound = p1:getAnimLength("Meleeing")
	});
	v3:addStateTransition("meleeCancel", {
		state0 = "meleeing", 
		state1 = "meleeCancelling"
	});
	v3:addStateTransition("meleeCancelFinish", {
		state0 = "meleeCancelling", 
		state1 = "meleeReady", 
		timeBound = p1:getAnimLength("MeleeCancel")
	});
	return v3;
end;
return v1;

