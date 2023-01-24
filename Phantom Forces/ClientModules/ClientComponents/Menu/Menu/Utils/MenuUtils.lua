
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	oneDecimal = function(p1, p2)
		if p2 and p1 == math.round(p1) then
			return p1;
		end;
		return string.format("%0.1f", math.round(p1 * 10) / 10);
	end, 
	twoDecimal = function(p3, p4)
		if p4 and p3 == math.round(p3) then
			return p3;
		end;
		return string.format("%0.2f", math.round(p3 * 100) / 100);
	end, 
	commaValue = function(p5)
		local v1 = p5;
		while true do
			local v2, v3 = string.gsub(v1, "^(-?%d+)(%d%d%d)", "%1,%2");
			v1 = v2;
			if v3 == 0 then
				break;
			end;		
		end;
		return v1;
	end, 
	vector3ToString = function(p6)
		return "(" .. u1.twoDecimal(p6.X) .. ", " .. u1.twoDecimal(p6.Y) .. ", " .. u1.twoDecimal(p6.Z) .. ")";
	end, 
	getAnimationTime = function(p7, p8)
		if not p7 then
			return 0;
		end;
		local v4 = 0;
		if p7.stdtimescale then

		end;
		local v5 = p7.timescale and 0.5;
		if p8 then
			local v6 = 0;
		else
			v6 = p7.resettime or 0.5;
		end;
		for v7, v8 in next, p7 do
			if type(v8) == "table" and v8.delay then
				v4 = v4 + v8.delay * v5;
			end;
		end;
		return math.round((v4 + v6) * 10) / 10;
	end, 
	setText = function(p9, p10)
		p9.Design.TextFrame.Text = p10;
	end, 
	setTextColor3 = function(p11, p12)
		p11.Design.TextFrame.TextColor3 = p12;
	end, 
	setBackgroundColor3 = function(p13, p14)
		p13.Design.BackFrame.BackgroundColor3 = p14;
	end, 
	setImageColor3 = function(p15, p16)
		p15.Design.ImageFrame.ImageColor3 = p16;
	end, 
	clearContainer = function(p17, p18)
		local l__next__9 = next;
		local v10, v11 = p17:GetChildren();
		while true do
			local v12, v13 = l__next__9(v10, v11);
			if not v12 then
				break;
			end;
			v11 = v12;
			if not v13:IsA("UIBase") and (not p18 or not p18(v13)) then
				v13:Destroy();
			end;		
		end;
	end
};
local u2 = shared.require("MenuScreenGui");
function u1.updateScrollingSize(p19, p20, p21)
	if not p20 then
		p20 = p19.Container:FindFirstChild("UIListLayout") or p19.Container:FindFirstChild("UIGridLayout");
	end;
	p19.CanvasSize = UDim2.new(0, 0, 0, (p20.AbsoluteContentSize.Y + (p21 and 0)) / u2.getUIScale());
end;
return u1;

