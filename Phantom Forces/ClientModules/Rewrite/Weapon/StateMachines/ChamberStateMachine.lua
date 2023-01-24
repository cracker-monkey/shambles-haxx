
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("StateMachine");
setmetatable(v1, v2);
function v1.new(p1)
	local v3 = v2.new();
	setmetatable(v3, v1);
	v3:addState("chambered", true);
	v3:addState("unchambered");
	v3:addState("chambering");
	v3:addState("chamberCancelling");
	v3:addState("chamberedReloading");
	v3:addState("chamberedReloadCancelling");
	v3:addState("unchamberedReloading");
	v3:addState("unchamberedReloadCancelling");
	v3:addState("chamberedReloadCancelResetting");
	v3:addState("unchamberedReloadCancelResetting");
	local v4 = {};
	local v5 = {
		state0 = "chambered", 
		state1 = "chambered"
	};
	function v5.timeBoundFunc()
		return 60 / p1:getFirerate();
	end;
	function v5.conditionalFunc()
		local v6 = false;
		if p1:getMagCount() > 1 then
			v6 = not p1:getWeaponStat("requirechamber");
		end;
		return v6;
	end;
	function v5.transitionFunc()

	end;
	v4[1] = v5;
	v4[2] = {
		state0 = "chambered", 
		state1 = "unchambered", 
		conditionalFunc = function()
			local v7 = true;
			if p1:getMagCount() ~= 1 then
				v7 = p1:getWeaponStat("requirechamber");
			end;
			return v7;
		end, 
		transitionFunc = function()

		end
	};
	v3:addConditionalTransition("shoot", v4);
	v3:addConditionalTransition("chamberStart", { {
			state0 = "unchambered", 
			state1 = "chambering", 
			conditionalFunc = function()
				return p1:getMagCount() > 0;
			end
		} });
	v3:addStateTransition("chamberFinish", {
		state0 = "chambering", 
		state1 = "chambered", 
		timeBound = p1:getAnimLength("onfire")
	});
	v3:addStateTransition("chamberCancel", {
		state0 = "chambering", 
		state1 = "chamberCancelling"
	});
	v3:addStateTransition("chamberCancelFinish", {
		state0 = "chamberCancelling", 
		state1 = "unchambered", 
		timeBound = 0.2
	});
	v3:addConditionalTransition("reloadStart", { {
			state0 = "chambered", 
			state1 = "chamberedReloading", 
			conditionalFunc = function()
				return p1:canReload();
			end, 
			transitionFunc = function()
				p1:setReloadSequence();
			end
		}, {
			state0 = "unchambered", 
			state1 = "unchamberedReloading", 
			conditionalFunc = function()
				return p1:canReload();
			end, 
			transitionFunc = function()
				p1:setReloadSequence();
			end
		}, {
			state0 = "chambering", 
			state1 = "chamberCancelling", 
			conditionalFunc = function()
				return p1:canReload();
			end
		} });
	v3:addStateTransition("reloadStart", {
		state0 = "chamberedReloadCancelling", 
		state1 = "chamberedReloadCancelResetting"
	});
	v3:addStateTransition("reloadStart", {
		state0 = "unchamberedReloadCancelling", 
		state1 = "unchamberedReloadCancelResetting"
	});
	v3:addStateTransition("reloadResume", {
		state0 = "chamberedReloadCancelResetting", 
		state1 = "chamberedReloading", 
		transitionFunc = function()
			p1:setReloadSequence();
		end
	});
	v3:addStateTransition("reloadResume", {
		state0 = "unchamberedReloadCancelResetting", 
		state1 = "unchamberedReloading", 
		transitionFunc = function()
			p1:setReloadSequence();
		end
	});
	v3:addStateTransition("reloadResume", {
		state0 = "chamberCancelling", 
		state1 = "unchamberedReloading", 
		transitionFunc = function()
			p1:setReloadSequence();
		end
	});
	v3:addConditionalTransition("reloadFinish", { {
			state0 = "chamberedReloading", 
			state1 = "chambered", 
			timeBoundFunc = function()
				return p1:getCurrentReloadLength();
			end, 
			conditionalFunc = function()
				return p1:isLastReloadSequence();
			end, 
			transitionFunc = function()
				p1:popReloadSequence();
			end
		}, {
			state0 = "unchamberedReloading", 
			state1 = "chambered", 
			timeBoundFunc = function()
				return p1:getCurrentReloadLength();
			end, 
			conditionalFunc = function()
				return p1:isLastReloadSequence();
			end, 
			transitionFunc = function()
				p1:popReloadSequence();
			end
		}, {
			state0 = "chamberedReloading", 
			state1 = "chamberedReloading", 
			timeBoundFunc = function()
				return p1:getCurrentReloadLength();
			end, 
			conditionalFunc = function()
				return not p1:isLastReloadSequence();
			end, 
			transitionFunc = function()
				p1:popReloadSequence();
			end
		}, {
			state0 = "unchamberedReloading", 
			state1 = "unchamberedReloading", 
			timeBoundFunc = function()
				return p1:getCurrentReloadLength();
			end, 
			conditionalFunc = function()
				return not p1:isLastReloadSequence();
			end, 
			transitionFunc = function()
				p1:popReloadSequence();
			end
		} });
	v3:addStateTransition("reloadCancel", {
		state0 = "chamberedReloading", 
		state1 = "chamberedReloadCancelling"
	});
	v3:addStateTransition("reloadCancel", {
		state0 = "unchamberedReloading", 
		state1 = "unchamberedReloadCancelling", 
		transitionFunc = function()

		end
	});
	v3:addStateTransition("reloadCancelFinish", {
		state0 = "chamberedReloadCancelling", 
		state1 = "chambered", 
		timeBound = 0.1
	});
	v3:addStateTransition("reloadCancelFinish", {
		state0 = "unchamberedReloadCancelling", 
		state1 = "unchambered", 
		timeBound = 0.1
	});
	return v3;
end;
return v1;

