
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("PageLoadoutMenuInterface");
local v2 = shared.require("MenuColorConfig");
local u1 = shared.require("DestructorGroup").new();
local function u2(p1)
	local v3 = nil;
	local v4 = {};
	if p1.hipchoke then
		local v5 = 1;
	else
		v5 = 0.08;
	end;
	v4[1] = v5 / p1.aimcamkickmax.magnitude ^ 3;
	if p1.hipchoke then
		local v6 = 1;
	else
		v6 = 0.08;
	end;
	v4[2] = v6 / p1.aimcamkickmin.magnitude ^ 3;
	if p1.blackscope then
		local v7 = 0;
	else
		if p1.hipchoke then
			local v8 = 0.5;
		else
			v8 = 0.05;
		end;
		v7 = v8 / p1.aimrotkickmax.magnitude ^ 1.5;
	end;
	v4[3] = v7;
	if p1.blackscope then
		local v9 = 0;
	else
		if p1.hipchoke then
			local v10 = 0.5;
		else
			v10 = 0.05;
		end;
		v9 = v10 / p1.aimrotkickmin.magnitude ^ 1.5;
	end;
	v4[4] = v9;
	v4[5] = p1.aimcamkickspeed ^ 2.5 * 5E-05;
	v4[6] = p1.modelkickspeed ^ 2.5 * 5E-05;
	v4[7] = (p1.requirechamber or p1.hipchoke) and 1 / (not p1.variablefirerate and p1.firerate or p1.firerate[1]) ^ 0.5 or 300 / (not p1.variablefirerate and p1.firerate ^ 1.3 or p1.firerate[1] ^ 1.3);
	local v11 = {};
	if p1.type == "REVOLVER" then
		local v12 = 0.005;
	else
		v12 = 0.05;
	end;
	v11[1] = (p1.aimcamkickmax - p1.aimcamkickmin).magnitude ^ 1.5 * v12;
	if p1.type == "REVOLVER" or p1.type == "PISTOL" then
		local v13 = 0.002;
	else
		v13 = 0.05;
	end;
	v11[2] = (p1.aimrotkickmax - p1.aimrotkickmin).magnitude ^ 1.5 * v13;
	if p1.type ~= "ASSAULT" and p1.type ~= "LMG" then
		local v14 = 0;
	else
		v14 = 0.9;
	end;
	if p1.blackscope then
		local v15 = 0.005;
	else
		v15 = 0.05;
	end;
	v11[3] = p1.zoom ^ v14 * v15;
	v3 = 0;
	for v16 = 1, #v4 do
		v3 = v3 + v4[v16];
	end;
	for v17 = 1, #v11 do
		local v18 = v18 - v11[v17];
	end;
	if local v19 > 0.9 then
		return 0.9;
	end;
	if v19 < 0.1 then

	end;
	return 0.1;
end;
local l__Templates__3 = v1.getPageFrame().Templates;
local u4 = shared.require("PageLoadoutMenuEvents");
return function(p2, p3, p4)
	local v20 = u1:runAndReplace("sightAccuracy");
	local v21 = u2(p2);
	local v22 = u2(p3);
	local v23 = l__Templates__3.DisplayWeaponStatBar:Clone();
	v23.TextFrameStat.Text = string.upper("Sight Accuracy");
	v23.DisplayBar.DisplayPercent.Size = UDim2.new(v22, 0, 1, 0);
	local u5 = v22 - v21;
	local l__DisplayPercentDifference__6 = v23.DisplayBar.DisplayPercentDifference;
	local function v24()
		if v1.getCurrentSubPage() ~= "DisplayWeaponAttachments" then
			l__DisplayPercentDifference__6.Size = UDim2.new(0, 0, 0, 0);
			return;
		end;
		if u5 < 0 then
			l__DisplayPercentDifference__6.Position = UDim2.new(v22, 0, 0, 0);
			l__DisplayPercentDifference__6.Size = UDim2.new(-u5, 0, 1, 0);
			l__DisplayPercentDifference__6.BackgroundColor3 = Color3.fromRGB(150, 20, 20);
			return;
		end;
		if not (u5 > 0) then
			l__DisplayPercentDifference__6.Size = UDim2.new(0, 0, 0, 0);
			return;
		end;
		l__DisplayPercentDifference__6.Position = UDim2.new(v21, 0, 0, 0);
		l__DisplayPercentDifference__6.Size = UDim2.new(u5, 0, 1, 0);
		l__DisplayPercentDifference__6.BackgroundColor3 = Color3.fromRGB(20, 150, 20);
	end;
	v20:add(u4.onSubPageChanged:connect(v24));
	v24();
	return v23;
end;

