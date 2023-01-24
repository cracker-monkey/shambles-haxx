
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("HudScreenGui");
local l__Main__3 = v2.getScreenGui().Main;
local u1 = shared.require("sound");
local l__Templates__2 = l__Main__3.Templates;
local l__DisplayNotifications__3 = l__Main__3.DisplayNotifications;
local u4 = shared.require("HudNotificationConfig");
function v1.smallAward(p1, p2)
	local v4 = l__Templates__2.DisplaySmallAward:Clone();
	local l__TextPrimary__5 = v4:FindFirstChild("TextPrimary");
	local l__TextPoint__6 = v4:FindFirstChild("TextPoint");
	u1.play("ui_smallaward", 0.2);
	v4.Parent = l__DisplayNotifications__3;
	local v7 = l__DisplayNotifications__3:GetChildren();
	local v8 = #v7;
	for v9, v10 in next, v7 do
		if v10:IsA("Frame") and v10.Parent then
			v10:TweenPosition(UDim2.new(0, 0, 0, (v8 - v9) * 20), "Out", "Sine", 0.05, true);
		end;
	end;
	l__TextPoint__6.Text = "[+" .. (p2 and 25) .. "]";
	local v11 = u4.typeList[p1];
	if v11 then
		if #v11 > 1 then
			l__TextPrimary__5.Text = v11[math.random(1, #v11)];
		else
			l__TextPrimary__5.Text = v11[1];
		end;
	else
		l__TextPrimary__5.Text = p1;
	end;
	if p1 == "head" then
		u1.play("headshotkill", 0.45);
	end;
	l__TextPoint__6.TextTransparency = 0;
	l__TextPrimary__5.TextTransparency = 0;
	l__TextPoint__6.AutoLocalize = false;
	l__TextPoint__6.Text = "";
	local u5 = l__TextPoint__6.Text;
	local u6 = 3;
	task.spawn(function()
		local v12 = 1;
		for v13, v14 in utf8.graphemes(u5) do
			l__TextPoint__6.Text = l__TextPoint__6.Text .. u5:sub(v13, v14);
			if v12 * u6 < v13 then
				u1.play("ui_typeout", 0.2);
				v12 = v12 + 1;
				task.wait(0.016666666666666666);
			end;
		end;
	end);
	u5 = false;
	l__TextPrimary__5.AutoLocalize = u5;
	u5 = l__TextPrimary__5.Text;
	l__TextPrimary__5.Text = "";
	u6 = 3;
	task.spawn(function()
		local v15 = 1;
		for v16, v17 in utf8.graphemes(u5) do
			l__TextPrimary__5.Text = l__TextPrimary__5.Text .. u5:sub(v16, v17);
			if v15 * u6 < v16 then
				u1.play("ui_typeout", 0.2);
				v15 = v15 + 1;
				task.wait(0.016666666666666666);
			end;
		end;
	end);
	u5 = task.wait;
	u5(5.5);
	u5 = 10;
	for v18 = 1, u5 do
		u6 = v18 / 10;
		l__TextPoint__6.TextTransparency = u6;
		u6 = v18 / 10;
		l__TextPrimary__5.TextTransparency = u6;
		u6 = v18 / 10 + 0.4;
		l__TextPoint__6.TextStrokeTransparency = u6;
		u6 = v18 / 10 + 0.4;
		l__TextPrimary__5.TextStrokeTransparency = u6;
		u6 = task.wait;
		u6(0.016666666666666666);
	end;
	u5 = task.wait;
	u5(0.1);
	u5 = v4.Destroy;
	u5(v4);
end;
local u7 = shared.require("PlayerSettingsInterface");
local function u8(p3, p4)
	p3.AutoLocalize = false;
	local v19 = p4 and 3;
	local l__Text__20 = p3.Text;
	p3.Text = "";
	local v21 = 1;
	for v22, v23 in utf8.graphemes(l__Text__20) do
		p3.Text = p3.Text .. l__Text__20:sub(v22, v23);
		if v21 * v19 < v22 then
			u1.play("ui_typeout", 0.2);
			v21 = v21 + 1;
			task.wait(0.016666666666666666);
		end;
	end;
end;
function v1.bigAward(p5, p6, p7, p8)
	local v24 = l__Templates__2.DisplayBigAward:Clone();
	local l__ImageOverlay__25 = v24:FindFirstChild("ImageOverlay");
	local l__TextPrimary__26 = v24:FindFirstChild("TextPrimary");
	local l__TextPoint__27 = v24:FindFirstChild("TextPoint");
	local l__TextEnemy__28 = v24:FindFirstChild("TextEnemy");
	v24.Parent = l__DisplayNotifications__3;
	local v29 = l__DisplayNotifications__3:GetChildren();
	local v30 = #v29;
	for v31, v32 in next, v29 do
		if v32:IsA("Frame") and v32.Parent then
			v32:TweenPosition(UDim2.new(0, 0, 0, (v30 - v31) * 20), "Out", "Sine", 0.05, true);
		end;
	end;
	l__TextPoint__27.Text = "[+" .. p8 .. "]";
	local v33 = u4.typeList[p5];
	if #v33 > 1 then
		l__TextPrimary__26.Text = v33[math.random(1, #v33)];
	else
		l__TextPrimary__26.Text = v33[1];
	end;
	if u7.getValue("togglestreamermode") then
		l__TextEnemy__28.Text = "Player";
	else
		l__TextEnemy__28.Text = p6.Name and "";
	end;
	l__TextEnemy__28.TextColor3 = p6.TeamColor.Color;
	u1.play("ui_begin", 0.4);
	if p5 == "kill" then
		u1.play("killshot", 0.2);
	end;
	l__TextPoint__27.TextTransparency = 0;
	l__TextPoint__27.TextStrokeTransparency = 0;
	l__TextPrimary__26.TextTransparency = 0;
	l__TextPrimary__26.TextStrokeTransparency = 0;
	l__TextEnemy__28.TextTransparency = 1;
	l__TextEnemy__28.TextStrokeTransparency = 1;
	l__ImageOverlay__25.ImageTransparency = 0.2;
	l__ImageOverlay__25:TweenSizeAndPosition(UDim2.new(0, 200, 0, 80), UDim2.new(0.5, -150, 0.7, -40), "Out", "Linear", 0, true);
	l__TextPoint__27.AutoLocalize = false;
	l__TextPoint__27.Text = "";
	local u9 = l__TextPoint__27.Text;
	local u10 = 2;
	task.spawn(function()
		local v34 = 1;
		for v35, v36 in utf8.graphemes(u9) do
			l__TextPoint__27.Text = l__TextPoint__27.Text .. u9:sub(v35, v36);
			if v34 * u10 < v35 then
				u1.play("ui_typeout", 0.2);
				v34 = v34 + 1;
				task.wait(0.016666666666666666);
			end;
		end;
	end);
	u9 = false;
	l__TextPrimary__26.AutoLocalize = u9;
	u9 = l__TextPrimary__26.Text;
	l__TextPrimary__26.Text = "";
	u10 = 2;
	task.spawn(function()
		local v37 = 1;
		for v38, v39 in utf8.graphemes(u9) do
			l__TextPrimary__26.Text = l__TextPrimary__26.Text .. u9:sub(v38, v39);
			if v37 * u10 < v38 then
				u1.play("ui_typeout", 0.2);
				v37 = v37 + 1;
				task.wait(0.016666666666666666);
			end;
		end;
	end);
	u9 = task.delay;
	u9(0.05, function()
		for v40 = 1, 10 do
			l__ImageOverlay__25.ImageTransparency = v40 / 10;
			task.wait(0.1);
		end;
		l__ImageOverlay__25.Size = UDim2.new(0, 200, 0, 80);
		l__ImageOverlay__25.Position = UDim2.new(0.55, -100, 0.3, -40);
	end);
	u10 = 0;
	u10 = UDim2.new;
	u10 = u10(0.5, -150, 0.7, -15);
	u9 = l__ImageOverlay__25.TweenSizeAndPosition;
	u9(l__ImageOverlay__25, UDim2.new(u10, 300, 0, 30), u10, "Out", "Linear", 0.05, true);
	u9 = task.wait;
	u9(0.05);
	u10 = 0;
	u10 = UDim2.new;
	u10 = u10(0.5, -150, 0.7, -4);
	u9 = l__ImageOverlay__25.TweenSizeAndPosition;
	u9(l__ImageOverlay__25, UDim2.new(u10, 500, 0, 8), u10, "Out", "Linear", 0.05, true);
	u9 = task.wait;
	u9(1.5);
	u9 = 2;
	for v41 = 1, u9 do
		u10 = 1;
		l__TextPrimary__26.TextTransparency = u10;
		u10 = 1;
		l__TextPrimary__26.TextStrokeTransparency = u10;
		u10 = u1.play;
		u10("ui_blink", 0.4);
		u10 = task.wait;
		u10(0.1);
		u10 = 0;
		l__TextPrimary__26.TextTransparency = u10;
		u10 = 0;
		l__TextPrimary__26.TextStrokeTransparency = u10;
		u10 = task.wait;
		u10(0.1);
	end;
	u9 = 1;
	l__TextPrimary__26.TextTransparency = u9;
	u9 = 1;
	l__TextPrimary__26.TextStrokeTransparency = u9;
	u9 = task.wait;
	u9(0.2);
	u9 = 0;
	l__TextEnemy__28.TextTransparency = u9;
	u9 = 0;
	l__TextEnemy__28.TextStrokeTransparency = u9;
	u9 = u8;
	u9(l__TextEnemy__28, 4);
	u9 = 0;
	l__TextPrimary__26.TextTransparency = u9;
	u9 = 0;
	l__TextPrimary__26.TextStrokeTransparency = u9;
	u9 = UDim2.new;
	u10 = l__TextEnemy__28.TextBounds.x / v2.getUIScale();
	u10 = 0.7;
	u9 = u9(0.5, u10 + 10, u10, -10);
	l__TextPrimary__26.Position = u9;
	if p5 == "kill" then
		u10 = "]";
		u9 = "[" .. p7 .. u10;
		l__TextPrimary__26.Text = u9;
	else
		l__TextPrimary__26.Text = p7;
	end;
	u9 = u8;
	u9(l__TextPrimary__26, 4);
	u9 = task.wait;
	u9(3);
	u9 = 10;
	for v42 = 1, u9 do
		u10 = v42 / 10;
		l__TextPoint__27.TextTransparency = u10;
		u10 = v42 / 10;
		l__TextPrimary__26.TextTransparency = u10;
		u10 = v42 / 10;
		l__TextEnemy__28.TextTransparency = u10;
		u10 = v42 / 10 + 0.4;
		l__TextPoint__27.TextStrokeTransparency = u10;
		u10 = v42 / 10 + 0.4;
		l__TextPrimary__26.TextStrokeTransparency = u10;
		u10 = v42 / 10 + 0.4;
		l__TextEnemy__28.TextStrokeTransparency = u10;
		u10 = task.wait;
		u10(0.016666666666666666);
	end;
	u9 = task.wait;
	u9(0.1);
	u9 = v24.Destroy;
	u9(v24);
end;
function v1.customAward(p9)
	local v43 = l__Templates__2.DisplaySmallAward:Clone();
	local l__TextPrimary__44 = v43:FindFirstChild("TextPrimary");
	v43.Parent = l__DisplayNotifications__3;
	u1.play("ui_smallaward", 0.2);
	local v45 = #l__DisplayNotifications__3:GetChildren();
	local l__next__46 = next;
	local v47, v48 = l__DisplayNotifications__3:GetChildren();
	while true do
		local v49, v50 = l__next__46(v47, v48);
		if not v49 then
			break;
		end;
		v48 = v49;
		if v50:IsA("Frame") and v50.Parent then
			v50:TweenPosition(UDim2.new(0, 0, 0, (v45 - v49) * 20), "Out", "Sine", 0.05, true);
		end;	
	end;
	task.spawn(function()
		l__TextPrimary__44.Text = p9;
		l__TextPrimary__44.TextTransparency = 0;
		l__TextPrimary__44.AutoLocalize = false;
		l__TextPrimary__44.Text = "";
		local u11 = l__TextPrimary__44.Text;
		local u12 = l__TextPrimary__44;
		local u13 = 3;
		task.spawn(function()
			local v51 = 1;
			for v52, v53 in utf8.graphemes(u11) do
				u12.Text = u12.Text .. u11:sub(v52, v53);
				if v51 * u13 < v52 then
					u1.play("ui_typeout", 0.2);
					v51 = v51 + 1;
					task.wait(0.016666666666666666);
				end;
			end;
		end);
		u12 = task.wait;
		u11 = 5.5;
		u12(u11);
		u12 = 10;
		u11 = 1;
		for v54 = 1, u12, u11 do
			u13 = v54 / 10;
			l__TextPrimary__44.TextTransparency = u13;
			u13 = v54 / 10 + 0.4;
			l__TextPrimary__44.TextStrokeTransparency = u13;
			u13 = 0.016666666666666666;
			task.wait(u13);
		end;
		u12 = task.wait;
		u11 = 0.1;
		u12(u11);
		u12 = v43;
		u11 = u12;
		u12 = u12.Destroy;
		u12(u11);
	end);
end;
local u14 = shared.require("GameClock");
function v1.customEvent(p10, p11)
	local v55 = l__Templates__2.DisplayAttachmentUnlock:Clone();
	local l__TextTitle__56 = v55.TextTitle;
	local l__TextAttachment__57 = v55.TextAttachment;
	v55.Position = UDim2.new(0.5, 0, 0.15, 0);
	l__TextTitle__56.Text = p10;
	l__TextAttachment__57.Text = p11;
	v55.Parent = l__Main__3;
	local l__RenderStepped__58 = game:GetService("RunService").RenderStepped;
	local u15 = u14.getTime() + 6;
	local u16 = nil;
	u16 = l__RenderStepped__58:connect(function()
		local v59 = u15 - u14.getTime();
		if v59 < 5 then
			local v60 = 0;
		else
			v60 = v59 < 5.5 and (v59 - 5) / 0.5 or 1;
		end;
		l__TextAttachment__57.TextTransparency = v60;
		if v59 < 5 then
			local v61 = 0;
		else
			v61 = v59 < 5.5 and (v59 - 5) / 0.5 or 1;
		end;
		l__TextTitle__56.TextTransparency = v61;
		if v59 <= 0 then
			u16:disconnect();
			v55:Destroy();
		end;
	end);
end;
function v1.unlockedgun(p12)
	local v62 = l__Templates__2.DisplayAttachmentUnlock:Clone();
	local l__TextTitle__63 = v62.TextTitle;
	local l__TextAttachment__64 = v62.TextAttachment;
	v62.Position = UDim2.new(0.5, 0, 0.15, 0);
	v62.Parent = l__Main__3;
	l__TextTitle__63.Text = "Unlocked New Weapon!";
	l__TextAttachment__64.Text = p12;
	local u17 = u14.getTime();
	local u18 = nil;
	u18 = game:GetService("RunService").RenderStepped:connect(function()
		local v65 = u14.getTime() - u17;
		if v65 < 2 then
			local v66 = 0;
		else
			v66 = v65 < 2.5 and (v65 - 2) / 0.5 or 1;
		end;
		l__TextAttachment__64.TextTransparency = v66;
		if v65 < 2 then
			local v67 = 0;
		else
			v67 = v65 < 2.5 and (v65 - 2) / 0.5 or 1;
		end;
		l__TextTitle__63.TextTransparency = v67;
		if v65 > 3 then
			u18:disconnect();
			v62:Destroy();
		end;
	end);
end;
function v1.unlockedAttach(p13, p14)
	for v68, v69 in next, p14 do
		local v70 = l__Templates__2.DisplayAttachmentUnlock:Clone();
		local l__TextMoney__71 = v70.TextMoney;
		local l__TextTitle__72 = v70.TextTitle;
		local l__TextAttachment__73 = v70.TextAttachment;
		v70.Position = UDim2.new(0.5, 0, 0.15, 0);
		v70.Parent = l__Main__3;
		l__TextTitle__72.Text = "Unlocked " .. p13 .. " Attachment";
		l__TextAttachment__73.Text = v69;
		l__TextMoney__71.Text = "[+200]";
		local u19 = u14.getTime();
		local u20 = nil;
		u20 = game:GetService("RunService").RenderStepped:connect(function()
			local v74 = u14.getTime() - u19;
			if v74 < 2 then
				local v75 = 0;
			else
				v75 = v74 < 2.5 and (v74 - 2) / 0.5 or 1;
			end;
			l__TextAttachment__73.TextTransparency = v75;
			if v74 < 2 then
				local v76 = 0;
			else
				v76 = v74 < 2.5 and (v74 - 2) / 0.5 or 1;
			end;
			l__TextTitle__72.TextTransparency = v76;
			if v74 < 0.5 then
				local v77 = 1;
			elseif v74 < 2.5 then
				v77 = 0;
			else
				v77 = v74 < 3 and (v74 - 2.5) / 0.5 or 1;
			end;
			l__TextMoney__71.TextTransparency = v77;
			if v74 > 3 then
				u20:disconnect();
				v70:Destroy();
			end;
		end);
		task.wait(3);
	end;
end;
function v1.rankUp(p15, p16, p17)
	local v78 = l__Templates__2.DisplayRankUnlock:Clone();
	local l__TextMoney__79 = v78.TextMoney;
	local l__TextRank__80 = v78.TextRank;
	l__TextRank__80.Text = p16;
	l__TextMoney__79.Text = "+" .. 5 * (p16 - p15) * (81 + p16 + p15) / 2 .. " CR";
	v78.Parent = l__Main__3;
	local v81 = 0;
	local v82 = l__Main__3:GetChildren();
	for v83 = 1, #v82 do
		if v82[v83].Name == "RankBar" or v82[v83].Name == "AttachBar" then
			v81 = v81 + 1;
		end;
	end;
	local u21 = u14.getTime();
	local l__TextTitle__22 = v78.TextTitle;
	local u23 = nil;
	u23 = game:GetService("RunService").RenderStepped:connect(function()
		local v84 = u14.getTime() - u21;
		if v84 < 3 then
			local v85 = 0;
		else
			v85 = v84 < 3.5 and (v84 - 3) / 0.5 or 1;
		end;
		l__TextRank__80.TextTransparency = v85;
		if v84 < 3 then
			local v86 = 0;
		else
			v86 = v84 < 3.5 and (v84 - 3) / 0.5 or 1;
		end;
		l__TextTitle__22.TextTransparency = v86;
		if v84 < 0.5 then
			local v87 = 1;
		elseif v84 < 3.5 then
			v87 = 0;
		else
			v87 = v84 < 4 and (v84 - 3.5) / 0.5 or 1;
		end;
		l__TextMoney__79.TextTransparency = v87;
		if v84 > 4 then
			u23:disconnect();
			v78:Destroy();
			task.spawn(function()
				if p17 then
					for v88 = 1, #p17 do
						v1.unlockedgun(p17[v88]);
						task.wait(3);
					end;
				end;
			end);
		end;
	end);
end;
local u24 = shared.require("network");
function v1._init()
	u24:add("unlockedattach", v1.unlockedAttach);
	u24:add("newevent", v1.customEvent);
	u24:add("rankup", v1.rankUp);
	u24:add("bigaward", function(p18, p19, p20, p21)
		v1.bigAward(p18, p19, p20, p21);
	end);
	u24:add("smallaward", function(p22, p23)
		v1.smallAward(p22, p23);
	end);
end;
return v1;

