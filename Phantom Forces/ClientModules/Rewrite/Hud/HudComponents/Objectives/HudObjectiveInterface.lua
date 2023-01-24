
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("HudScreenGui");
local l__DisplayStatus__3 = v2.getScreenGui().Main.DisplayStatus;
local u1 = shared.require("GameRoundInterface");
local l__TextCaptured__2 = l__DisplayStatus__3.TextCaptured;
local l__TextRevealed__3 = l__DisplayStatus__3.TextRevealed;
local u4 = shared.require("PlayerStatusInterface");
local l__LocalPlayer__5 = game:GetService("Players").LocalPlayer;
local u6 = shared.require("MapPropInterface");
local u7 = shared.require("GameClock");
local u8 = shared.require("TeamConfig");
local l__TextEnemyTags__9 = l__DisplayStatus__3.TextEnemyTags;
local l__TextTeamTags__10 = l__DisplayStatus__3.TextTeamTags;
function v1.step()
	local v4 = u1.getModeName();
	l__TextCaptured__2.Visible = false;
	l__TextRevealed__3.Visible = false;
	if v4 == "Capture the Flag" then
		local v5, v6 = u4.getOppositeTeam(l__LocalPlayer__5);
		local v7 = u6.getFlagData(v5);
		if v7.carrier == l__LocalPlayer__5 and v7.revealtime then
			l__TextCaptured__2.Visible = true;
			l__TextCaptured__2.Text = "Capturing Enemy Flag!";
			l__TextRevealed__3.Visible = true;
			local l__revealtime__8 = v7.revealtime;
			if u7.getTime() < l__revealtime__8 then
				l__TextRevealed__3.Text = "Position revealed in " .. math.ceil(l__revealtime__8 - u7.getTime()) .. " seconds";
			else
				l__TextRevealed__3.Text = "Flag position revealed to all enemies!";
			end;
		end;
		for v9, v10 in next, u8.teamNames do
			local v11 = u6.getFlagData(v10);
			if v11.carrier and v11.carrier ~= l__LocalPlayer__5 then
				if not v11.carrier.Parent then
					u6.resetFlag(v9, nil);
				end;
				if not v11.carrymodel then
					u6.attachFlag(v11.carrier);
				end;
				if v11.carrymodel and v11.carrymodel.Parent and v11.revealtime then
					local l__BillboardGui__12 = v11.carrymodel.Tag.BillboardGui;
					if l__LocalPlayer__5.TeamColor == v11.carrier.TeamColor then
						local v13 = "Capturing!";
					else
						v13 = "Stolen!";
					end;
					local v14 = true;
					if l__LocalPlayer__5.TeamColor ~= v11.carrier.TeamColor then
						v14 = v11.revealtime < u7.getTime();
					end;
					l__BillboardGui__12.AlwaysOnTop = v14;
					l__BillboardGui__12.Distance.Text = v13;
				end;
			end;
		end;
	end;
	if v4 ~= "Tag Run" then
		l__TextEnemyTags__9.Visible = false;
		l__TextTeamTags__10.Visible = false;
		return;
	end;
	local v15, v16 = u6.getTagCount();
	l__TextEnemyTags__9.Visible = true;
	l__TextTeamTags__10.Visible = true;
	l__TextTeamTags__10.Text = v15 .. " Friendly Tags";
	l__TextEnemyTags__9.Text = v16 .. " Enemy Tags";
end;
local u11 = shared.require("PlayerSettingsInterface");
local u12 = shared.require("RenderSteppedRunner");
function v1._init()
	local u13 = nil;
	v2.getScreenGui():GetPropertyChangedSignal("Enabled"):Connect(function()
		if not v2.isEnabled() then
			if u13 then
				u13();
			end;
			return;
		end;
		if not u11.getValue("toggleroundhud") then
			return;
		end;
		if u13 then
			u13();
		end;
		u13 = u12:addTask("HudObjectiveInterface", v1.step, {});
	end);
end;
return v1;

