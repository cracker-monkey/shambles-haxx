
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("GameModeConfig");
local v3 = shared.require("UIScaleUpdater");
local v4 = shared.require("HudScreenGui");
local l__Main__5 = v4.getScreenGui().Main;
local l__Templates__6 = l__Main__5.Templates;
local l__DisplayMatchScore__7 = l__Main__5.DisplayRadarScore.DisplayMatchScore;
local l__TextGameMode__1 = l__DisplayMatchScore__7.TextGameMode;
local u2 = shared.require("GameRoundInterface");
local l__LocalPlayer__3 = game:GetService("Players").LocalPlayer;
local l__DisplayPhantomPoints__4 = l__DisplayMatchScore__7.Container.DisplayPhantomPoints;
local l__DisplayGhostPoints__5 = l__DisplayMatchScore__7.Container.DisplayGhostPoints;
function v1.updateMatch()
	l__TextGameMode__1.Text = u2.getModeName();
	if l__LocalPlayer__3.TeamColor == game.Teams.Phantoms.TeamColor then
		l__DisplayPhantomPoints__4.LayoutOrder = 0;
		l__DisplayGhostPoints__5.LayoutOrder = 1;
		return;
	end;
	l__DisplayPhantomPoints__4.LayoutOrder = 1;
	l__DisplayGhostPoints__5.LayoutOrder = 0;
end;
local l__TextMatchTimer__6 = l__DisplayMatchScore__7.TextMatchTimer;
function v1.step()
	local v8, v9, v10 = u2.getMatchScores();
	l__DisplayPhantomPoints__4.DisplayPointScale.Percent.Size = UDim2.new(v9 / v10, 0, 1, 0);
	l__DisplayGhostPoints__5.DisplayPointScale.Percent.Size = UDim2.new(v8 / v10, 0, 1, 0);
	l__DisplayPhantomPoints__4.TextScore.Text = v9;
	l__DisplayGhostPoints__5.TextScore.Text = v8;
	if u2.isCountingDown() then
		l__TextMatchTimer__6.Text = "COUNTDOWN";
		return;
	end;
	local v11 = u2.getMatchTime();
	local v12 = v11 % 60;
	if v12 < 10 then
		v12 = "0" .. v12;
	end;
	l__TextMatchTimer__6.Text = math.floor(v11 / 60) .. ":" .. v12;
end;
local u7 = shared.require("PlayerSettingsInterface");
local u8 = shared.require("RenderSteppedRunner");
local u9 = shared.require("PlayerSettingsEvents");
function v1._init()
	u2.onMapChanged:connect(v1.updateMatch);
	local u10 = nil;
	v4.getScreenGui():GetPropertyChangedSignal("Enabled"):Connect(function()
		if not v4.isEnabled() then
			if u10 then
				u10();
			end;
			return;
		end;
		l__DisplayMatchScore__7.Visible = u7.getValue("toggleroundhud");
		if not u7.getValue("toggleroundhud") then
			return;
		end;
		if u10 then
			u10();
		end;
		u10 = u8:addTask("HudMatchScoreInterface", v1.step, {});
	end);
	local l__UIScale__13 = l__Main__5.DisplayRadarScore.UIScale;
	l__UIScale__13.Scale = u7.getValue("radarscale") and 1;
	u9.onSettingChanged:connect(function(p1, p2)
		if p1 == "radarscale" then
			l__UIScale__13.Scale = p2;
		end;
	end);
end;
return v1;

