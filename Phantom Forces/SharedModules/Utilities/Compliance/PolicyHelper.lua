
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
function v1.new(p1)
	assert(p1, "No player passed!");
	local v2 = setmetatable({}, v1);
	v2._player = p1;
	v2._policyInfo = nil;
	v2._region = nil;
	v2._fetching = false;
	task.spawn(function()
		while not v2:isReady() do
			v2:_fetchPolicy();
			task.wait(30);		
		end;
	end);
	return v2;
end;
function v1._fetchPolicy(p2)
	if not p2:isReady() then
		if not p2._policyInfo then
			local v3, v4 = pcall(function()
				return game:GetService("PolicyService"):GetPolicyInfoForPlayerAsync(p2._player);
			end);
			if not v3 then
				warn("Policy Helper failed to fetch player policies!");
			end;
			p2._policyInfo = v4;
		end;
		if not p2._region then
			local v5, v6 = pcall(function()
				return game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(p2._player);
			end);
			if not v5 then
				warn("Policy Helper failed to fetch player region!");
			else
				p2._region = v6;
			end;
		end;
	end;
	print(p2._policyInfo);
end;
function v1.isReady(p3)
	return p3._policyInfo and p3._region;
end;
local u1 = require(script.PolicyConfig);
function v1.isFeatureAvailable(p4, p5)
	if not p4:isReady() then
		error("Policy Helper not ready! Please use PolicyHelper:isReady() prior to calling");
	end;
	if u1[p5][p4._region] then
		return false;
	end;
	return true;
end;
function v1.getPolicy(p6)
	if not p6:isReady() then
		error("Policy Helper not ready! Please use PolicyHelper:isReady() prior to calling");
	end;
	return p6._policyInfo;
end;
function v1.canPurchaseRandomItems(p7)
	if not p7:isReady() then
		return false;
	end;
	return p7:isFeatureAvailable("RandomItems");
end;
return v1;

