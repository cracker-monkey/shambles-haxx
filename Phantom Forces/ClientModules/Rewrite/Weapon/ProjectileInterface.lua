
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("GameClock");
local l__Ignore__3 = workspace:WaitForChild("Ignore");
local u1 = v2.getTime();
local u2 = 1.25;
local function u3()
	return 2.718281828459045 ^ (-(v2.getTime() - u1) / 1) * (1.25 - u2) + u2;
end;
local u4 = shared.require("network");
local l__LocalPlayer__5 = game:GetService("Players").LocalPlayer;
local u6 = shared.require("ReplicationInterface");
local l__Players__7 = workspace:WaitForChild("Players");
local l__CurrentCamera__8 = workspace.CurrentCamera;
local u9 = shared.require("HudRadarInterface");
local u10 = shared.require("particle");
local u11 = shared.require("PublicSettings");
local u12 = shared.require("sound");
local function u13()
	u2 = (u3() - 0.5) / 1.1331484530668263 + 0.5;
	u1 = v2.getTime();
end;
local u14 = shared.require("CameraInterface");
local u15 = shared.require("vector");
local l__Map__16 = workspace:WaitForChild("Map");
local u17 = shared.require("effects");
function v1._init()
	u4:add("newbullets", function(p1)
		local v4 = nil;
		local l__player__5 = p1.player;
		local v6 = l__player__5.TeamColor ~= l__LocalPlayer__5.TeamColor;
		local l__weaponData__7 = u6.getEntry(l__player__5):getWeaponObject(p1.index).weaponData;
		local l__bullets__8 = p1.bullets;
		local l__firepos__9 = p1.firepos;
		local l__hideminimap__10 = l__weaponData__7.hideminimap;
		local l__snipercrack__11 = l__weaponData__7.snipercrack;
		local v12 = l__weaponData__7.firepitch * (1 + 0.05 * math.random());
		local v13 = l__weaponData__7.bulletcolor or Color3.new(0.7843137254901961, 0.27450980392156865, 0.27450980392156865);
		local l__penetrationdepth__14 = l__weaponData__7.penetrationdepth;
		local v15 = l__weaponData__7.suppression and 1;
		local v16 = { l__Players__7, workspace.Terrain, workspace.Ignore, workspace.CurrentCamera };
		local v17 = u6.getEntry(l__player__5);
		if v17 and v17:isAlive() then
			local v18 = v17:getThirdPersonObject();
			v18:kickWeapon(l__weaponData__7.hideflash, l__weaponData__7.firesoundid, v12, l__weaponData__7.firevolume);
			v4 = v18:getWeaponPosition();
		else
			warn("ReplicationInterface: No replicationObject found for", l__player__5, "on newbullet");
		end;
		if not l__hideminimap__10 or l__hideminimap__10 and (l__firepos__9 - l__CurrentCamera__8.CFrame.p).Magnitude < l__weaponData__7.hiderange then
			local v19 = v17:getLookAngles();
			local v20 = CFrame.new(l__firepos__9) * CFrame.Angles(v19.x, v19.y, 0);
			if v20 then
				u9.fireShot(l__player__5, l__hideminimap__10, {
					size0 = l__weaponData__7.pingsize0, 
					size1 = l__weaponData__7.pingsize1, 
					pinglife = l__weaponData__7.pinglife
				}, v20);
			end;
		end;
		local v21 = false;
		local v22 = false;
		for v23 = 1, #l__bullets__8 do
			local v24 = l__bullets__8[v23];
			local v25 = {
				position = l__firepos__9, 
				velocity = v24.velocity, 
				acceleration = u11.bulletAcceleration, 
				physicsignore = v16, 
				color = v13, 
				size = 0.2, 
				bloom = 0.005, 
				brightness = 400, 
				life = u11.bulletLifeTime, 
				visualorigin = v4, 
				penetrationdepth = l__penetrationdepth__14, 
				tracerless = l__weaponData__7.tracerless, 
				thirdperson = true
			};
			local v26 = v6;
			if v26 then
				local u18 = v21;
				local u19 = v22;
				v26 = function(p2, p3)
					local v27 = p3 * p2.velocity;
					local v28 = p2.position - v27;
					local l__p__29 = l__CurrentCamera__8.CFrame.p;
					local v30 = (l__p__29 - v28):Dot(v27) / v27:Dot(v27);
					if v30 > 0 and v30 < 1 then
						local l__Magnitude__31 = (v28 + v30 * v27 - l__p__29).Magnitude;
						if l__Magnitude__31 < 2 then
							local v32 = 2;
						else
							v32 = l__Magnitude__31;
						end;
						local v33 = u3() * v15 / v32 * l__weaponData__7.bulletspeed / 512 * (math.clamp(((l__p__29 - p1.firepos).Magnitude - l__weaponData__7.range0) / (l__weaponData__7.range1 - l__weaponData__7.range0), 0, 1) * (l__weaponData__7.damage1 - l__weaponData__7.damage0) + l__weaponData__7.damage0) / l__weaponData__7.damage0;
						if l__Magnitude__31 < 50 then
							if not u18 then
								if l__snipercrack__11 and l__Magnitude__31 < 25 then
									u12.PlaySound("crackBig", nil, 8 / l__Magnitude__31);
								elseif l__Magnitude__31 <= 5 then
									u12.PlaySound("crackSmall", nil, 2);
								end;
								u12.PlaySound("whizz", nil, 2 / l__Magnitude__31, nil, -0.05, 0.05);
								u18 = true;
							end;
							if not u19 and l__Magnitude__31 < 15 then
								u19 = true;
								u4:send("suppressionassist", l__player__5, v33, v24.id);
							end;
						end;
						u13();
						if u14.isCameraType("MainCamera") then
							u14.getActiveCamera("MainCamera"):setSuppression(u15.random(v33, v33));
						end;
					end;
				end;
			end;
			v25.onstep = v26;
			function v25.ontouch(p4, p5, p6, p7, p8, p9)
				if p5:IsDescendantOf(l__Map__16) then
					u17:bullethit(p5, p6, p7, p8, p9, p4.velocity, true, true);
					return;
				end;
				if p5:IsDescendantOf(l__Players__7) then
					u17:bloodhit(p6, true, nil, p4.velocity / 10, true);
				end;
			end;
			u10.new(v25);
		end;
	end);
end;
return v1;

