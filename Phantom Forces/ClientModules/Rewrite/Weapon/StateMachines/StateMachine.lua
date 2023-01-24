
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Event");
function v1.new()
	local v2 = setmetatable({}, v1);
	v2.onStateTransition = u1.new();
	v2._currentState = nil;
	v2._stateTransitions = {};
	v2._conditionalTransitions = {};
	v2._states = {};
	return v2;
end;
function v1.getState(p1)
	return p1._currentState;
end;
function v1.isState(p2, p3)
	return p2:getState() == p3;
end;
function v1.setState(p4, p5)
	if p4._states[p5] then
		p4._currentState = p5;
		return;
	end;
	warn("StateMachine: Setting invalid state", p5);
end;
function v1.addState(p6, p7, p8)
	p6._states[p7] = true;
	if not p6._currentState or p8 then
		p6:setState(p7);
	end;
end;
function v1.addConditionalTransition(p9, p10, p11)
	if p9._conditionalTransitions[p10] then
		warn("StateMachine: Overwriting existing conditional transition for input", p10);
	end;
	for v3, v4 in next, p11 do
		local l__state0__5 = v4.state0;
		local l__state1__6 = v4.state1;
		if not p9._states[l__state0__5] then
			error("StateMachine: Adding conditional transition for invalid state " .. l__state0__5 .. " -> " .. l__state1__6);
			return;
		end;
		if not p9._states[l__state1__6] then
			error("StateMachine: Adding conditional transition for invalid state " .. l__state0__5 .. " -> " .. l__state1__6);
			return;
		end;
		if not v4.conditionalFunc then
			error("StateMachine: Missing conditional check for " .. p10 .. " " .. l__state0__5 .. " -> " .. l__state1__6);
			return;
		end;
	end;
	p9._conditionalTransitions[p10] = p11;
end;
function v1.addStateTransition(p12, p13, p14)
	local l__state0__7 = p14.state0;
	local l__state1__8 = p14.state1;
	if not p12._states[l__state0__7] or not p12._states[l__state1__8] then
		error("StateMachine: Adding transition for invalid state " .. l__state0__7 .. " -> " .. l__state1__8);
		return;
	end;
	if p12._stateTransitions[p13 .. l__state0__7] then
		warn("StateMachine: Overwriting existing transition for input", p13);
	end;
	p12._stateTransitions[p13 .. l__state0__7] = p14;
end;
function v1.fireInput(p15, p16)
	local v9 = p15:_getTransitionData(p16);
	if not v9 then
		return;
	end;
	p15:_fireTransition(v9);
	return true;
end;
function v1._checkConditionalTransitions(p17, p18)
	local v10 = p17._conditionalTransitions[p18];
	if not v10 then
		return;
	end;
	for v11, v12 in next, v10 do
		local l__state1__13 = v12.state1;
		local l__transitionFunc__14 = v12.transitionFunc;
		if p17._currentState == v12.state0 and v12.conditionalFunc() then
			return v12;
		end;
	end;
end;
function v1._checkStateTransitions(p19, p20)
	return p19._stateTransitions[p20 .. p19._currentState];
end;
function v1._getTransitionData(p21, p22)
	return p21:_checkStateTransitions(p22) or p21:_checkConditionalTransitions(p22);
end;
local u2 = shared.require("GameClock");
function v1._fireTransition(p23, p24)
	local l__state1__15 = p24.state1;
	p23._currentState = l__state1__15;
	if p24.transitionFunc then
		p24.transitionFunc();
	end;
	p23.onStateTransition:fire(p24.state0, l__state1__15, u2.getTime());
end;
return v1;

