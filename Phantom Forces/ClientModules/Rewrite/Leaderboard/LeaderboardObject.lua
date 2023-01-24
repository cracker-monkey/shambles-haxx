
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("LeaderboardScreenGui").getScreenGui();
local l__DisplayScoreFrame__3 = v2.DisplayScoreFrame;
local u1 = shared.require("Destructor");
local l__Templates__2 = v2.Templates;
local l__LocalPlayer__3 = game:GetService("Players").LocalPlayer;
local u4 = shared.require("PlayerSettingsEvents");
function v1.new(p1)
	local v4 = setmetatable({}, v1);
	v4._destructor = u1.new();
	v4._player = p1;
	v4._guiObject = l__Templates__2.DisplayPlayerScore:Clone();
	v4._destructor:add(v4._guiObject);
	v4._textMapping = {
		Deaths = v4._guiObject.TextDeaths, 
		Streak = v4._guiObject.TextStreak, 
		Kills = v4._guiObject.TextKills, 
		Score = v4._guiObject.TextScore, 
		Rank = v4._guiObject.TextRank, 
		Kdr = v4._guiObject.TextKdr
	};
	if v4._player == l__LocalPlayer__3 then
		v4._guiObject.TextPlayer.TextColor3 = Color3.new(1, 1, 0);
	end;
	v4._destructor:add(v4._player:GetPropertyChangedSignal("TeamColor"):Connect(function()
		v4:updateTeam();
	end));
	v4._destructor:add(u4.onSettingChanged:connect(function(p2, p3)
		if p2 == "togglestreamermode" then
			v4:updateName();
		end;
	end));
	v4:updateName();
	v4:updateTeam();
	v4:updateStats({
		Deaths = 0, 
		Streak = 0, 
		Kills = 0, 
		Score = 0, 
		Rank = 0, 
		Kdr = 0
	});
	return v4;
end;
function v1.Destroy(p4)
	p4._destructor:Destroy();
end;
local u5 = shared.require("PlayerSettingsInterface");
function v1.updateName(p5)
	if u5.getValue("togglestreamermode") then
		local v5 = "Player";
	else
		v5 = p5._player.Name;
	end;
	p5._guiObject.TextPlayer.Text = v5;
end;
local u6 = shared.require("TeamConfig");
local l__DisplayPhantomBoard__7 = l__DisplayScoreFrame__3.Container.DisplayPhantomBoard;
local l__DisplayGhostBoard__8 = l__DisplayScoreFrame__3.Container.DisplayGhostBoard;
function v1.updateTeam(p6)
	if u6.getTeamName(p6._player.TeamColor) == "Phantoms" then
		p6._guiObject.Parent = l__DisplayPhantomBoard__7.Container;
		return;
	end;
	p6._guiObject.Parent = l__DisplayGhostBoard__8.Container;
end;
function v1.updateStats(p7, p8)
	for v6, v7 in next, p8 do
		p7._textMapping[v6].Text = v7;
	end;
	p7._guiObject.LayoutOrder = -tonumber(p7._textMapping.Score.Text);
end;
return v1;

