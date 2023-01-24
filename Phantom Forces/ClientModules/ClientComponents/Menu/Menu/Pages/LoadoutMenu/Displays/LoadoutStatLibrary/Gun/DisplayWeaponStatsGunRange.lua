
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("PageLoadoutMenuInterface").getPageFrame();
local l__Templates__1 = v1.Templates;
local u2 = shared.require("MenuUtils");
local u3 = shared.require("MenuColorConfig");
local l__DisplayWeaponStats__4 = v1.DisplayWeaponStats;
local function u5(p1, p2, p3, p4, p5, p6)
	local v2 = p4 - p3;
	local v3 = p3;
	local v4 = p4;
	if p5 then
		v3 = p3 - (p2 / 2 * math.tan(math.abs(math.atan2(p5:Cross(v2), p5:Dot(v2))) / 2) + 0.25) * v2.unit;
	end;
	if p6 then
		v4 = p4 + (p2 / 2 * math.tan(math.abs(math.atan2(v2:Cross(p6), v2:Dot(p6))) / 2) + 0.25) * v2.unit;
	end;
	local v5 = v4 - v3;
	local v6 = math.deg(math.atan2(v5.y, v5.x));
	local l__magnitude__7 = v5.magnitude;
	local v8 = (v3 + v4) / 2 - Vector2.new(l__magnitude__7, p2) / 2;
	p1.Rotation = v6;
	p1.Size = UDim2.fromOffset(l__magnitude__7, p2);
	p1.Position = UDim2.fromOffset(v8.x, v8.y);
end;
return function(p7, p8, p9)
	local v9 = math.floor(math.max(p8.damage0, p8.damage1) / 100 + 1) * 125;
	local v10 = math.ceil(p8.range1 / 100 + 1) * 100;
	local v11 = l__Templates__1.DisplayDamageGraph:Clone();
	local l__DisplayDamageGraph__12 = v11.DisplayDamageGraph;
	v11.TextFrameRangeEnd.Text = v10;
	v11.TextFrameRangeMid.Text = v10 / 2;
	l__DisplayDamageGraph__12.DisplayRange0Line.TextDamage0.Text = u2.twoDecimal(p8.damage0, true);
	l__DisplayDamageGraph__12.DisplayRange1Line.TextDamage1.Text = u2.twoDecimal(p8.damage1, true);
	if p9.damage0 then
		l__DisplayDamageGraph__12.DisplayRange0Line.TextDamage0.TextColor3 = u3.previewDisplayTextStatsColor;
	end;
	if p9.damage1 then
		l__DisplayDamageGraph__12.DisplayRange1Line.TextDamage1.TextColor3 = u3.previewDisplayTextStatsColor;
	end;
	local v13 = l__DisplayWeaponStats__4.Size.X.Offset + l__DisplayDamageGraph__12.Size.X.Offset;
	local v14 = l__DisplayWeaponStats__4.Container.Size.Y.Offset * 4;
	local v15 = Vector2.new(0, (1 - p8.damage0 / v9) * v14);
	local v16 = Vector2.new(p8.range0 / v10 * v13, (1 - p8.damage0 / v9) * v14);
	local v17 = Vector2.new(math.round(v16.x), math.round(v16.y));
	local v18 = Vector2.new(p8.range1 / v10 * v13, (1 - p8.damage1 / v9) * v14);
	local v19 = Vector2.new(math.round(v18.x), math.round(v18.y));
	local v20 = Vector2.new(1 * v13, (1 - p8.damage1 / v9) * v14);
	local v21 = Vector2.new(math.round(v20.x), math.round(v20.y));
	u5(l__DisplayDamageGraph__12.DisplayRange0Line, 4, Vector2.new(math.round(v15.x), math.round(v15.y)), v17, Vector2.new(1, 0), v19 - v17);
	u5(l__DisplayDamageGraph__12.DisplayRangeSlope, 4, v17, v19, Vector2.new(1, 0), Vector2.new(1, 0));
	u5(l__DisplayDamageGraph__12.DisplayRange1Line, 4, v19, v21, v19 - v17, Vector2.new(1, 0));
	return v11;
end;

