
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("PageLoadoutMenuInterface");
local v2 = shared.require("MenuColorConfig");
local u1 = shared.require("DestructorGroup").new();
local function u2(p1)
	local v3 = nil;
	local v4 = {};
	if p1.requirechamber then
		local v5 = 0;
	elseif p1.blackscope or p1.type == "DMR" then
		v5 = 0.2;
	else
		v5 = 400 / (not p1.variablefirerate and p1.firerate ^ 1.3 or p1.firerate[1] ^ 1.3);
	end;
	v4[1] = v5;
	v4[2] = p1.modelkickdamper ^ 3 * 0.1;
	v4[3] = 0.001 / p1.hipfirespread ^ 1.5;
	v4[4] = p1.blackscope and p1.zoom ^ 1.2 * 0.03 or p1.zoom ^ 1.5 * 0.025;
	v4[5] = p1.bulletspeed ^ 2.5 * 2.5E-10;
	local v6 = { p1.hipchoke and (p1.hipchoke + p1.aimchoke) * 0.01 or 0 };
	if p1.hipchoke then
		local v7 = 350 / (not p1.variablefirerate and p1.firerate ^ 1.3 or p1.firerate[1]) or 0;
	else
		v7 = 0;
	end;
	v6[2] = v7;
	v3 = 0;
	for v8 = 1, #v4 do
		v3 = v3 + v4[v8];
	end;
	for v9 = 1, #v6 do
		local v10 = v10 - v6[v9];
	end;
	if local v11 > 0.9 then
		return 0.9;
	end;
	if v11 < 0.1 then

	end;
	return 0.1;
end;
local l__Templates__3 = v1.getPageFrame().Templates;
local u4 = shared.require("PageLoadoutMenuEvents");
return function(p2, p3, p4)
	local v12 = u1:runAndReplace("accuracy");
	local v13 = u2(p2);
	local v14 = u2(p3);
	local v15 = l__Templates__3.DisplayWeaponStatBar:Clone();
	v15.TextFrameStat.Text = string.upper("Accuracy");
	v15.DisplayBar.DisplayPercent.Size = UDim2.new(v14, 0, 1, 0);
	local u5 = v14 - v13;
	local l__DisplayPercentDifference__6 = v15.DisplayBar.DisplayPercentDifference;
	local function v16()
		if v1.getCurrentSubPage() ~= "DisplayWeaponAttachments" then
			l__DisplayPercentDifference__6.Size = UDim2.new(0, 0, 0, 0);
			return;
		end;
		if u5 < 0 then
			l__DisplayPercentDifference__6.Position = UDim2.new(v14, 0, 0, 0);
			l__DisplayPercentDifference__6.Size = UDim2.new(-u5, 0, 1, 0);
			l__DisplayPercentDifference__6.BackgroundColor3 = Color3.fromRGB(150, 20, 20);
			return;
		end;
		if not (u5 > 0) then
			l__DisplayPercentDifference__6.Size = UDim2.new(0, 0, 0, 0);
			return;
		end;
		l__DisplayPercentDifference__6.Position = UDim2.new(v13, 0, 0, 0);
		l__DisplayPercentDifference__6.Size = UDim2.new(u5, 0, 1, 0);
		l__DisplayPercentDifference__6.BackgroundColor3 = Color3.fromRGB(20, 150, 20);
	end;
	v12:add(u4.onSubPageChanged:connect(v16));
	v16();
	return v15;
end;

