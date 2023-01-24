
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__DisplayVoteKick__2 = shared.require("ChatScreenGui").getScreenGui().Main.DisplayVoteKick;
local u1 = false;
local l__TextYes__2 = l__DisplayVoteKick__2.TextYes;
local l__TextNo__3 = l__DisplayVoteKick__2.TextNo;
local u4 = shared.require("network");
function v1.vote(p1)
	if u1 then
		if p1 == "yes" then
			l__TextYes__2.BorderColor3 = Color3.new(1, 1, 1);
			l__TextNo__3.BorderColor3 = Color3.new(0.16470588235294117, 0.16470588235294117, 0.16470588235294117);
		elseif p1 == "dismiss" then
			u1 = false;
			l__DisplayVoteKick__2.Visible = false;
		elseif p1 == "no" then
			l__TextYes__2.BorderColor3 = Color3.new(0.16470588235294117, 0.16470588235294117, 0.16470588235294117);
			l__TextNo__3.BorderColor3 = Color3.new(1, 1, 1);
		end;
		u4:send("votefromUI", p1);
	end;
end;
local u5 = shared.require("PlayerSettingsInterface").getValue("togglevotekick");
local l__TextTimer__6 = l__DisplayVoteKick__2.TextTimer;
local u7 = 0;
local u8 = shared.require("GameClock");
local l__TextVotes__9 = l__DisplayVoteKick__2.TextVotes;
local u10 = 0;
function v1.step()
	if u5 and u1 then
		l__DisplayVoteKick__2.Visible = true;
		l__TextTimer__6.Text = "Time left: 0:" .. string.format("%.2d", (u7 - u8.getTime()) % 60);
		l__TextVotes__9.Text = string.format("%d players have cast their vote", u10);
		if not (u7 <= u8.getTime()) then
			return;
		end;
	else
		l__DisplayVoteKick__2.Visible = false;
		return;
	end;
	u1 = false;
	l__DisplayVoteKick__2.Visible = false;
end;
local l__TextTitle__11 = l__DisplayVoteKick__2.TextTitle;
local l__TextDismiss__12 = l__DisplayVoteKick__2.TextDismiss;
local l__TextChoice__13 = l__DisplayVoteKick__2.TextChoice;
local u14 = shared.require("PlayerSettingsEvents");
function v1._init()
	u4:add("startvotekick", function(p2, p3)
		if u5 then
			l__TextTitle__11.Text = "Votekick " .. p2 .. " out of the server?";
			l__TextYes__2.BorderColor3 = Color3.new(0.16470588235294117, 0.16470588235294117, 0.16470588235294117);
			l__TextNo__3.BorderColor3 = Color3.new(0.16470588235294117, 0.16470588235294117, 0.16470588235294117);
			l__DisplayVoteKick__2.Visible = true;
			l__TextDismiss__12.Visible = true;
			l__TextChoice__13.Visible = false;
			l__TextYes__2.Visible = true;
			l__TextNo__3.Visible = true;
			u7 = u8.getTime() + p3;
			u1 = true;
		end;
	end);
	u4:add("votefinished", function()
		u1 = false;
	end);
	u4:add("updatenumvotes", function(p4)
		u10 = p4;
	end);
	u14.onSettingChanged:connect(function(p5, p6)
		if p5 == "togglevotekick" then
			u5 = p6;
		end;
	end);
	game:GetService("RunService").Heartbeat:Connect(v1.step);
end;
return v1;

