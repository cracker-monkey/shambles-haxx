
-- Decompiled with the Synapse X Luau decompiler.

return {
	subPageFrames = { "DisplayEditTags" }, 
	customizeTabs = {
		DisplayEditTags = "EDIT TAGS"
	}, 
	displayColorBarConfig = {
		DisplayColorBarR = {
			colorTableFunc = function(p1, p2)
				return {
					r = math.round(p1), 
					g = math.round(p2.G * 255), 
					b = math.round(p2.B * 255)
				};
			end, 
			newBrickColor3Func = function(p3, p4)
				return Color3.fromRGB(p3, p4.G * 255, p4.B * 255);
			end, 
			updateFunc = function(p5, p6, p7)
				local v1 = math.round(p7.R * 255);
				p5.TextBox.Text = v1;
				p6:setValue(v1);
			end
		}, 
		DisplayColorBarG = {
			colorTableFunc = function(p8, p9)
				return {
					r = math.round(p9.R * 255), 
					g = math.round(p8), 
					b = math.round(p9.B * 255)
				};
			end, 
			newBrickColor3Func = function(p10, p11)
				return Color3.fromRGB(p11.R * 255, p10, p11.B * 255);
			end, 
			updateFunc = function(p12, p13, p14)
				local v2 = math.round(p14.G * 255);
				p12.TextBox.Text = v2;
				p13:setValue(v2);
			end
		}, 
		DisplayColorBarB = {
			colorTableFunc = function(p15, p16)
				return {
					r = math.round(p16.R * 255), 
					g = math.round(p16.G * 255), 
					b = math.round(p15)
				};
			end, 
			newBrickColor3Func = function(p17, p18)
				return Color3.fromRGB(p18.R * 255, p18.G * 255, p17);
			end, 
			updateFunc = function(p19, p20, p21)
				local v3 = math.round(p21.B * 255);
				p19.TextBox.Text = v3;
				p20:setValue(v3);
			end
		}
	}
};

