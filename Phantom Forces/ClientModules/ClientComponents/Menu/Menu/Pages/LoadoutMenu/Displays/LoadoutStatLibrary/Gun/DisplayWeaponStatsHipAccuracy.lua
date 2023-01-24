
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("PageLoadoutMenuInterface");
local v2 = shared.require("MenuColorConfig");
local u1 = shared.require("DestructorGroup").new();
local function u2(p1)
	local v3 = nil;
	local v4 = { 0.05 / p1.camkickmax.magnitude ^ 1.5, 0.05 / p1.camkickmin.magnitude ^ 1.5, p1.camkickspeed ^ 2.5 * 5E-05, p1.hipfirestability ^ 3 * 0.5, p1.modelkickspeed ^ 1.5 * 0.001, p1.hipfirespreadrecover ^ 2 * 0.0025 };
	local v5 = {};
	if p1.blackscope then
		local v6 = 0;
	else
		if p1.type == "REVOLVER" then
			local v7 = 0.2;
		else
			v7 = 1;
		end;
		v6 = p1.hipfirespread ^ 0.75 * v7;
	end;
	v5[1] = v6;
	if p1.blackscope then
		local v8 = 0;
	else
		v8 = (not p1.variablefirerate and p1.firerate or p1.firerate[1]) ^ 0.8 * 0.0003;
	end;
	v5[2] = v8;
	if p1.type == "REVOLVER" then
		local v9 = 0.001;
	else
		v9 = 0.08;
	end;
	v5[3] = (p1.camkickmax - p1.camkickmin).magnitude ^ 1.2 * v9;
	v3 = 0;
	for v10 = 1, #v4 do
		v3 = v3 + v4[v10];
	end;
	for v11 = 1, #v5 do
		local v12 = v12 - v5[v11];
	end;
	if local v13 > 0.9 then
		return 0.9;
	end;
	if v13 < 0.1 then

	end;
	return 0.1;
end;
local l__Templates__3 = v1.getPageFrame().Templates;
local u4 = shared.require("PageLoadoutMenuEvents");
return function(p2, p3, p4)
	local v14 = u1:runAndReplace("hipAccuracy");
	local v15 = u2(p2);
	local v16 = u2(p3);
	local v17 = l__Templates__3.DisplayWeaponStatBar:Clone();
	v17.TextFrameStat.Text = string.upper("Hip Accuracy");
	v17.DisplayBar.DisplayPercent.Size = UDim2.new(v16, 0, 1, 0);
	local u5 = v16 - v15;
	local l__DisplayPercentDifference__6 = v17.DisplayBar.DisplayPercentDifference;
	local function v18()
		if v1.getCurrentSubPage() ~= "DisplayWeaponAttachments" then
			l__DisplayPercentDifference__6.Size = UDim2.new(0, 0, 0, 0);
			return;
		end;
		if u5 < 0 then
			l__DisplayPercentDifference__6.Position = UDim2.new(v16, 0, 0, 0);
			l__DisplayPercentDifference__6.Size = UDim2.new(-u5, 0, 1, 0);
			l__DisplayPercentDifference__6.BackgroundColor3 = Color3.fromRGB(150, 20, 20);
			return;
		end;
		if not (u5 > 0) then
			l__DisplayPercentDifference__6.Size = UDim2.new(0, 0, 0, 0);
			return;
		end;
		l__DisplayPercentDifference__6.Position = UDim2.new(v15, 0, 0, 0);
		l__DisplayPercentDifference__6.Size = UDim2.new(u5, 0, 1, 0);
		l__DisplayPercentDifference__6.BackgroundColor3 = Color3.fromRGB(20, 150, 20);
	end;
	v14:add(u4.onSubPageChanged:connect(v18));
	v18();
	return v17;
end;

