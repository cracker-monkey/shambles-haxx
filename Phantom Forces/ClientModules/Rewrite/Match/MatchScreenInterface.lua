
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("MatchScreenGui").getScreenGui();
local l__DisplayStartMatch__3 = v2.DisplayStartMatch;
local l__DisplayEndMatch__4 = v2.DisplayEndMatch;
local l__ServerSettings__5 = game:GetService("ReplicatedStorage"):WaitForChild("ServerSettings");
local u1 = shared.require("GameRoundInterface");
local l__ShowResults__2 = l__ServerSettings__5:WaitForChild("ShowResults");
local u3 = shared.require("input");
local u4 = shared.require("CharacterInterface");
local l__TextTeamName__5 = l__DisplayStartMatch__3.TextTeamName;
local l__LocalPlayer__6 = game:GetService("Players").LocalPlayer;
local l__TextNumber__7 = l__DisplayStartMatch__3.TextNumber;
function v1.updateCountdown()
	if not u1.isCountingDown() then
		if u1.getMatchTime() > 0 and not l__ShowResults__2.Value then
			u1.roundLock = false;
			l__DisplayStartMatch__3.Visible = false;
		end;
		return;
	end;
	u1.roundLock = true;
	if u3.consoleon then
		local v6 = "Press ButtonSelect to return to menu";
	else
		v6 = "Press F5 to return to menu";
	end;
	l__DisplayStartMatch__3.TextTip.Text = v6;
	if u4.isAlive() then
		local v7 = u1.getMatchTime();
		if l__LocalPlayer__6.TeamColor == game.Teams.Ghosts.TeamColor then
			local v8 = "Ghosts";
		else
			v8 = "Phantoms";
		end;
		l__TextTeamName__5.Text = v8;
		l__TextTeamName__5.TextColor3 = l__LocalPlayer__6.TeamColor.Color;
		l__TextTeamName__5.Visible = true;
		l__TextNumber__7.FontSize = 9;
		l__TextNumber__7.Text = v7;
		l__DisplayStartMatch__3.Visible = true;
		l__TextNumber__7.FontSize = 9;
		task.wait(0.03333333333333333);
		l__TextNumber__7.FontSize = 8;
		task.wait(0.03333333333333333);
		l__TextNumber__7.FontSize = 7;
		task.wait(0.03333333333333333);
		if v7 ~= 0 then
			l__TextNumber__7.TextTransparency = 0;
			l__DisplayStartMatch__3.BackgroundTransparency = 0.5;
			l__DisplayStartMatch__3.TextTitle.TextTransparency = 0;
			l__DisplayStartMatch__3.TextTitle.TextStrokeTransparency = 0.5;
			return;
		end;
	else
		return;
	end;
	task.wait(1);
	u1.roundLock = false;
	l__DisplayStartMatch__3.Visible = false;
end;
local l__TextQuote__8 = l__DisplayEndMatch__4.TextQuote;
local u9 = shared.require("Quotes");
local l__TextMode__10 = l__DisplayEndMatch__4.TextMode;
local l__Winner__11 = l__ServerSettings__5:WaitForChild("Winner");
local l__TextResult__12 = l__DisplayEndMatch__4.TextResult;
local u13 = shared.require("GameRoundEvents");
function v1.showEndResult()
	if not l__ShowResults__2.Value then
		l__DisplayEndMatch__4.Visible = false;
		return;
	end;
	l__TextQuote__8.Text = u9[math.random(1, #u9)];
	l__TextMode__10.Text = u1.getModeName();
	if l__Winner__11.Value == l__LocalPlayer__6.TeamColor then
		l__TextResult__12.Text = "VICTORY";
		l__TextResult__12.TextColor = BrickColor.new("Bright green");
	elseif l__Winner__11.Value == BrickColor.new("Black") then
		l__TextResult__12.Text = "STALEMATE";
		l__TextResult__12.TextColor = BrickColor.new("Bright orange");
	else
		l__TextResult__12.Text = "DEFEAT";
		l__TextResult__12.TextColor = BrickColor.new("Bright red");
	end;
	u1.roundLock = true;
	l__DisplayEndMatch__4.Visible = true;
	u13.onRoundEnded:fire();
end;
local l__Timer__14 = l__ServerSettings__5:WaitForChild("Timer");
local u15 = shared.require("InstanceType");
function v1._init()
	l__DisplayStartMatch__3.Visible = false;
	l__DisplayEndMatch__4.Visible = false;
	v1.updateCountdown();
	l__Timer__14.Changed:connect(v1.updateCountdown);
	l__ShowResults__2.Changed:connect(v1.showEndResult);
	u13.onRoundStarted:connect(function()
		if u15.IsTest() then
			u1.roundLock = false;
		end;
	end);
end;
return v1;

