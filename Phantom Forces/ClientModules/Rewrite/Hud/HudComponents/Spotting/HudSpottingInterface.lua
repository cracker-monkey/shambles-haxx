
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PlayerSettingsInterface");
local v3 = shared.require("GameRoundInterface");
local v4 = shared.require("HudScreenGui");
local u1 = shared.require("PlayerStatusInterface");
function v1.isSpotted(p1)
	local v5 = u1.getEntry(p1);
	if not v5 then
		return;
	end;
	return v5.isSpotted;
end;
function v1.isInSight(p2)
	local v6 = u1.getEntry(p2);
	if not v6 then
		return;
	end;
	return v6.lastSightedTime or not v6.brokenSight;
end;
local u2 = 0;
function v1.goingLoud()
	if u2 <= 30 then
		local v7 = 30;
	elseif u2 + 30 > 200 then
		v7 = 200;
	else
		v7 = u2 + 30;
	end;
	u2 = v7;
end;
local u3 = shared.require("CharacterInterface");
local l__CurrentCamera__4 = workspace.CurrentCamera;
local l__localPlayer__5 = game:GetService("Players").localPlayer;
local u6 = shared.require("GameClock");
local u7 = shared.require("ReplicationInterface");
local u8 = shared.require("OcclusionCheck").new(nil, 1);
local u9 = shared.require("network");
function v1.spot()
	if not u3.isAlive() then
		return;
	end;
	local l__CFrame__8 = l__CurrentCamera__4.CFrame;
	local l__TeamColor__9 = l__localPlayer__5.TeamColor;
	local l__unit__10 = l__CFrame__8.lookVector.unit;
	local u11 = u6.getTime();
	local u12 = {};
	u7.operateOnAllEntries(function(p3, p4)
		if p4:isAlive() and not u1.isFriendly(p3) then
			local v10, v11 = p4:getPosition();
			local v12 = v11 - l__CurrentCamera__4.CFrame.p;
			if l__unit__10:Dot(v12.unit) > 0.96592582628 and u8:checkOcclusion(l__CFrame__8.p, v12) then
				local v13 = u1.getEntry(p3);
				if not v13 then
					warn("PlayerStatusInterface: No status found for", p3, "on spot");
					return;
				end;
				v13.lastSightedTime = u11;
				v13.isSpotted = true;
				table.insert(u12, p3);
			end;
		end;
	end);
	if not (#u12 > 0) then
		return;
	end;
	u9:send("spotplayers", u12, u11);
	return true;
end;
local u13 = 0;
local u14 = shared.require("ScreenCull");
local l__TextSpotted__15 = v4.getScreenGui().Main.DisplayStatus.TextSpotted;
function v1.step()
	local v14 = u6.getTime();
	if not (u13 + 0.1 < v14) then
		return;
	end;
	if u2 > 0 then
		u2 = u2 - 1;
	end;
	u13 = v14 + 0.1;
	u7.operateOnAllEntries(function(p5, p6)
		local v15 = u1.getEntry(p5);
		if not p6:isAlive() or not v15.isSpotted then
			return;
		end;
		local v16 = false;
		if u3.isAlive() and not u1.isFriendly(p5) then
			local v17 = p6:getThirdPersonObject();
			local v18 = v17:getBodyPart("head");
			if u14.sphere(v17:getBodyPart("torso").Position, 4) then
				local l__p__19 = l__CurrentCamera__4.CFrame.p;
				local v20 = v18.Position - l__p__19;
				local v21 = Ray.new(l__p__19, v20);
				if u8:checkOcclusion(l__p__19, v20) then
					v16 = true;
					if not (not v15.brokenSight) or not v15.lastSightedTime or v15.lastSightedTime < v14 then
						v15.lastSightedTime = v14 + 1;
						v15.brokenSight = false;
						u9:send("updatesight", p5, true, v14);
					end;
				end;
			end;
		end;
		if not v16 and (not v15.lastSightedTime or v15.lastSightedTime < v14) then
			v15.lastSightedTime = v14 + 1;
			v15.brokenSight = true;
			u9:send("updatesight", p5, false, v14);
		end;
	end);
	if not v1.isSpotted(l__localPlayer__5) then
		if u2 > 0 then
			l__TextSpotted__15.Visible = true;
			l__TextSpotted__15.Text = "On Radar!";
			l__TextSpotted__15.TextColor3 = Color3.new(1, 0.8, 0);
			return;
		else
			l__TextSpotted__15.Visible = false;
			return;
		end;
	end;
	l__TextSpotted__15.Visible = true;
	if v1.isInSight(l__localPlayer__5) then
		l__TextSpotted__15.Text = "Spotted by enemy!";
		l__TextSpotted__15.TextColor3 = Color3.new(1, 0.125, 0.125);
		return;
	end;
	l__TextSpotted__15.Text = "Hiding from enemy...";
	l__TextSpotted__15.TextColor3 = Color3.new(0.125, 1, 0.125);
end;
local u16 = shared.require("RenderSteppedRunner");
function v1._init()
	u9:add("brokensight", function(p7, p8)
		local v22 = u1.getEntry(p7);
		if v22 then
			v22.brokenSight = p8;
			return;
		end;
		warn("PlayerStatusInterface: No status found for", p7, "on brokensight");
	end);
	u9:add("spotplayer", function(p9)
		local v23 = u1.getEntry(p9);
		if v23 then
			v23.isSpotted = true;
			return;
		end;
		warn("PlayerStatusInterface: No status found for", p9, "on spotplayer");
	end);
	u9:add("unspotplayer", function(p10)
		local v24 = u1.getEntry(p10);
		if v24 then
			v24.isSpotted = false;
			return;
		end;
		warn("PlayerStatusInterface: No status found for", p10, "on spotplayer");
	end);
	local u17 = nil;
	v4.getScreenGui():GetPropertyChangedSignal("Enabled"):Connect(function()
		if not v4.isEnabled() then
			if u17 then
				u17();
			end;
			return;
		end;
		if u17 then
			u17();
		end;
		u17 = u16:addTask("HudSpottingInterface", v1.step, { "CharacterInterface", "CameraInterface", "WeaponControllerInterface" });
	end);
end;
return v1;

