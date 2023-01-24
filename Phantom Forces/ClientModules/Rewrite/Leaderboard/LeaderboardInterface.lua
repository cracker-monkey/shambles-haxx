
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("LeaderboardScreenGui");
local v3 = shared.require("GameClock");
local v4 = v2.getScreenGui();
local l__Templates__5 = v4.Templates;
local l__DisplayScoreFrame__6 = v4.DisplayScoreFrame;
local u1 = {};
function v1.getEntry(p1)
	return u1[p1];
end;
local u2 = shared.require("LeaderboardObject");
function v1.addEntry(p2)
	if u1[p2] then
		u1[p2]:Destroy();
		u1[p2] = nil;
	end;
	u1[p2] = u2.new(p2);
end;
function v1.removeEntry(p3)
	if u1[p3] then
		u1[p3]:Destroy();
		u1[p3] = nil;
	end;
end;
function v1.operateOnAllEntries(p4)
	for v7, v8 in next, u1 do
		p4(v7, v8);
	end;
end;
function v1.updateStats(p5, p6)
	if not v1.getEntry(p5) then
		v1.addEntry(p5);
	end;
	v1.getEntry(p5):updateStats(p6);
end;
function v1.fillBoard(p7)
	for v9, v10 in p7, nil do
		v1.updateStats(v10.player, v10.stats);
	end;
end;
local u3 = 60;
local u4 = v3.getTime();
local l__TextPing__5 = l__DisplayScoreFrame__6.DisplayTopFrame.TextPing;
function v1.step(p8)
	u3 = 0.95 * u3 + 0.05 / p8;
	if not v2.isEnabled() then
		return;
	end;
	if u4 < v3.getTime() then
		local v11 = u3 - u3 % 1;
		if v11 ~= v11 or v11 == (1 / 0) or v11 == (-1 / 0) then
			v11 = 60;
			u3 = v11;
		end;
		l__TextPing__5.Text = "Average FPS: " .. v11;
		u4 = v3.getTime() + 1;
	end;
end;
local u6 = shared.require("MenuUtils");
local l__DisplayPhantomBoard__7 = l__DisplayScoreFrame__6.Container.DisplayPhantomBoard;
local l__DisplayGhostBoard__8 = l__DisplayScoreFrame__6.Container.DisplayGhostBoard;
local u9 = shared.require("network");
local u10 = shared.require("input");
local u11 = shared.require("RenderSteppedRunner");
function v1._init()
	u6.clearContainer(l__DisplayPhantomBoard__7.Container);
	u6.clearContainer(l__DisplayGhostBoard__8.Container);
	game:GetService("Players").PlayerAdded:connect(v1.addEntry);
	game:GetService("Players").PlayerRemoving:connect(v1.removeEntry);
	local l__next__12 = next;
	local v13, v14 = game:GetService("Players"):GetPlayers();
	while true do
		local v15, v16 = l__next__12(v13, v14);
		if not v15 then
			break;
		end;
		v14 = v15;
		v1.addEntry(v16);	
	end;
	u9:add("updatestats", v1.updateStats);
	u9:add("fillboard", v1.fillBoard);
	game:GetService("UserInputService").InputBegan:connect(function(p9)
		local l__KeyCode__17 = p9.KeyCode;
		if l__KeyCode__17 == Enum.KeyCode.Tab and not u10.iskeydown(Enum.KeyCode.LeftAlt) or l__KeyCode__17 == Enum.KeyCode.ButtonSelect then
			if v2.isEnabled() then
				v2.disable();
				return;
			end;
			v2.enable();
		end;
	end);
	v2.disable();
	u11:addTask("leaderboard", v1.step);
end;
return v1;

