
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("StateMachine");
setmetatable(v1, v2);
function v1.new()
	local v3 = v2.new();
	setmetatable(v3, v1);
	v3:addState("equipped");
	v3:addState("equipping");
	v3:addState("unequipped", true);
	v3:addState("unequipping");
	v3:addStateTransition("equipStart", {
		state0 = "unequipped", 
		state1 = "equipping"
	});
	v3:addStateTransition("equipFastStart", {
		state0 = "unequipped", 
		state1 = "equipped"
	});
	v3:addStateTransition("equipFinish", {
		state0 = "equipping", 
		state1 = "equipped"
	});
	v3:addStateTransition("unequipStart", {
		state0 = "equipped", 
		state1 = "unequipping"
	});
	v3:addStateTransition("unequipFinish", {
		state0 = "unequipping", 
		state1 = "unequipped"
	});
	return v3;
end;
return v1;

