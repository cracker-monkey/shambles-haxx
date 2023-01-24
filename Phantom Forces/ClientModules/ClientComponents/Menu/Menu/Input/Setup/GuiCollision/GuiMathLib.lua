
-- Decompiled with the Synapse X Luau decompiler.

return {
	invMul = function(p1, p2, p3, p4, p5, p6, p7, p8)
		local v1 = p7 - p1;
		local v2 = p8 - p2;
		local v3 = p3 * p6 - p5 * p4;
		return (v1 * p6 - v2 * p4) / v3, (v2 * p3 - v1 * p5) / v3;
	end, 
	mul = function(p9, p10, p11, p12, p13, p14, p15, p16)
		return p9 + p15 * p11 + p16 * p12, p10 + p15 * p13 + p16 * p14;
	end, 
	getCenteredScaledMatrix = function(p17, p18, p19)
		local l__x__4 = p17.x;
		local l__y__5 = p17.y;
		local v6 = math.rad(p19);
		local v7 = math.cos(v6);
		local v8 = math.sin(v6);
		return p18.x + l__x__4 / 2, p18.y + l__y__5 / 2, l__x__4 * v7, -l__y__5 * v8, l__x__4 * v8, l__y__5 * v7;
	end, 
	getCenteredUnitMatrix = function(p20, p21, p22)
		local v9 = math.rad(p22);
		local v10 = math.cos(v9);
		local v11 = math.sin(v9);
		return p21.x + p20.x / 2, p21.y + p20.y / 2, v10, -v11, v11, v10;
	end, 
	getTopLeftScaledMatrix = function(p23, p24, p25)
		local l__x__12 = p23.x;
		local l__y__13 = p23.y;
		local v14 = math.rad(p25);
		local v15 = math.cos(v14);
		local v16 = math.sin(v14);
		return p24.x + l__x__12 / 2 - l__x__12 / 2 * v15 + l__y__13 / 2 * v16, p24.y + l__y__13 / 2 - l__x__12 / 2 * v16 - l__y__13 / 2 * v15, l__x__12 * v15, -l__y__13 * v16, l__x__12 * v16, l__y__13 * v15;
	end, 
	getTopLeftUnitMatrix = function(p26, p27, p28)
		local l__x__17 = p26.x;
		local l__y__18 = p26.y;
		local v19 = math.rad(p28);
		local v20 = math.cos(v19);
		local v21 = math.sin(v19);
		return p27.x + l__x__17 / 2 - l__x__17 / 2 * v20 + l__y__18 / 2 * v21, p27.y + l__y__18 / 2 - l__x__17 / 2 * v21 - l__y__18 / 2 * v20, v20, -v21, v21, v20;
	end, 
	getGuiData = function(p29)
		return p29.AbsoluteSize, p29.AbsolutePosition, p29.AbsoluteRotation;
	end
};

