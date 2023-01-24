
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("StateMachine");
setmetatable(v1, v2);
function v1.new(p1)
	local v3 = v2.new();
	setmetatable(v3, v1);
	v3:addState("armReady", true);
	v3:addState("arming");
	v3:addState("armed");
	v3:addState("armCancelling");
	v3:addState("throwing");
	v3:addState("thrown");
	local v4 = {};
	local v5 = {
		state0 = "armReady", 
		state1 = "arming"
	};
	function v5.conditionalFunc()
		return p1:canThrow();
	end;
	v4[1] = v5;
	v3:addConditionalTransition("armStart", v4);
	v3:addStateTransition("armFinish", {
		state0 = "arming", 
		state1 = "armed", 
		timeBound = p1:getAnimLength("Arming")
	});
	v3:addConditionalTransition("armCancel", { {
			state0 = "arming", 
			state1 = "armCancelling", 
			conditionalFunc = function()
				return p1:canCancelThrow();
			end
		}, {
			state0 = "armed", 
			state1 = "armCancelling", 
			conditionalFunc = function()
				return p1:canCancelThrow();
			end
		} });
	v3:addStateTransition("throwStart", {
		state0 = "armed", 
		state1 = "throwing", 
		transitionFunc = function()
			p1:throwInstance();
		end
	});
	v3:addStateTransition("throwFinish", {
		state0 = "throwing", 
		state1 = "thrown", 
		timeBound = p1:getAnimLength("Throwing")
	});
	v3:addStateTransition("reload", {
		state0 = "thrown", 
		state1 = "armReady"
	});
	v3:addStateTransition("armCancelFinish", {
		state0 = "armCancelling", 
		state1 = "armReady", 
		timeBound = p1:getAnimLength("ArmCancel")
	});
	return v3;
end;
return v1;

