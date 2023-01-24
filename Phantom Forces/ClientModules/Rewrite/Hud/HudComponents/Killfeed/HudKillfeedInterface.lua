
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("UIScaleUpdater");
local v3 = shared.require("HudScreenGui");
local l__Main__4 = v3.getScreenGui().Main;
local l__DisplayKillfeed__5 = l__Main__4.DisplayKillfeed;
local l__Container__1 = l__DisplayKillfeed__5.Container;
local u2 = shared.require("PlayerSettingsInterface");
local u3 = shared.require("PlayerSettingsEvents");
local u4 = shared.require("network");
local l__Templates__5 = l__Main__4.Templates;
local u6 = shared.require("RichTextUtils");
function v1._init()
	l__Container__1:ClearAllChildren();
	local l__UIScale__6 = l__DisplayKillfeed__5.UIScale;
	l__UIScale__6.Scale = u2.getValue("killfeedscale") and 1;
	u3.onSettingChanged:connect(function(p1, p2)
		if p1 == "killfeedscale" then
			l__UIScale__6.Scale = p2;
		end;
	end);
	u4:add("killfeed", function(p3, p4, p5, p6, p7)
		if not u2.getValue("togglekillfeed") then
			return;
		end;
		local v7 = l__Templates__5.DisplayKillfeedLine:Clone();
		v7.Position = UDim2.new(0, 0, 1, 27);
		local v8 = p3.Name;
		local v9 = p4.Name;
		if u2.getValue("togglestreamermode") then
			v8 = "Player";
			v9 = "Player";
		end;
		local v10 = u6.formatTextColor3(v8, p3.TeamColor.Color);
		local v11 = u6.formatTextColor3(v9, p4.TeamColor.Color);
		local v12 = u6.formatTextColor3(p6, Color3.fromRGB(255, 255, 255));
		local l__TextKillfeed__13 = v7.TextKillfeed;
		l__TextKillfeed__13.TextDistance.Text = "Dist: " .. p5 .. " studs";
		v7.Parent = l__Container__1;
		local v14 = v3.getUIScale() * l__UIScale__6.Scale;
		l__TextKillfeed__13.Text = v10;
		l__TextKillfeed__13.Text = v10 .. "       " .. v12 .. "       .";
		l__TextKillfeed__13.Text = v10 .. "       " .. v12 .. "       " .. v11;
		l__TextKillfeed__13.TextDistance.Position = UDim2.new(0, (l__TextKillfeed__13.TextBounds.x / v14 + l__TextKillfeed__13.TextBounds.x / v14) / 2, 0, 20);
		if p7 then
			v7.ImageHeadshot.Visible = true;
			v7.ImageHeadshot.Position = UDim2.new(0, 25 + l__TextKillfeed__13.TextBounds.x / v14, 0.5, -3);
		else
			v7.ImageHeadshot.Visible = false;
		end;
		task.spawn(function()
			task.wait(20);
			for v15 = 1, 10 do
				if v7.Parent then
					l__TextKillfeed__13.TextTransparency = v15 / 10;
					l__TextKillfeed__13.TextStrokeTransparency = v15 / 10 + 0.5;
					l__TextKillfeed__13.TextDistance.TextStrokeTransparency = v15 / 10 + 0.5;
					l__TextKillfeed__13.TextDistance.TextTransparency = v15 / 10;
					task.wait(0.03333333333333333);
				end;
			end;
			if v7 and v7.Parent then
				v7:Destroy();
			end;
		end);
		local v16 = l__Container__1:GetChildren();
		local v17 = #v16;
		for v18 = #v16, 1, -1 do
			local v19 = v16[v18];
			v19:TweenPosition(UDim2.new(0, 0, 1, 0), "Out", "Quad", 0.2, true);
			if v17 - v18 > 10 then
				v19:Destroy();
			end;
		end;
	end);
end;
return v1;

