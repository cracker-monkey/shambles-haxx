
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("CharacterInterface");
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
local u3 = shared.require("sound");
local u4 = shared.require("effects");
local u5 = shared.require("HudCrosshairsInterface");
local u6 = shared.require("network");
function v1.playerHitDection(p1, p2, p3, p4, p5, p6, p7)
	if not u1.getCharacterObject() then
		return;
	end;
	if not p4.Parent then
		warn(string.format("We hit a bodypart that doesn't exist %s %s", l__LocalPlayer__2.Name, p4.Name));
		return;
	end;
	if p3.TeamColor == l__LocalPlayer__2.TeamColor then
		return;
	end;
	local v2 = p2:getWeaponStat("range0");
	local v3 = p2:getWeaponStat("range1");
	local v4 = p2:getWeaponStat("damage0");
	local v5 = p2:getWeaponStat("damage1");
	local l__Magnitude__6 = (p1.origin - p5).Magnitude;
	local v7 = l__Magnitude__6 < v2 and v4 or (l__Magnitude__6 < v3 and (v5 - v4) / (v3 - v2) * (l__Magnitude__6 - v2) + v4 or v5);
	if p4.Name == "Head" then
		v7 = v7 * p2:getWeaponStat("multhead");
	elseif p4.Name == "Torso" then
		v7 = v7 * p2:getWeaponStat("multtorso");
	end;
	u3.PlaySound("hitmarker", nil, 1, 1.5);
	u4:bloodhit(p5, true, v7, p1.velocity / 10);
	u5.fireHitmarker(p4.Name == "Head");
	if not p7 then
		u6:send("bullethit", p3, p5, p4.Name, p6);
		return;
	end;
	table.insert(p7, { p3, p5, p4.Name, p6 });
end;
function v1.hitDetection(p8, p9, p10, p11, p12, p13, p14, p15, p16, p17)
	if p9:IsDescendantOf(workspace.Ignore.DeadBody) then
		u4:bloodhit(p10);
		return;
	end;
	if p9.Anchored then
		if p9.Name == "Window" then
			u4:breakwindow(p9, p17);
		end;
		if p9.Name == "Hitmark" then
			u5.fireHitmarker();
		elseif p9.Name == "HitmarkHead" then
			u5.fireHitmarker(true);
		end;
		u4:bullethit(p9, p10, p11, p12, p13, p8.velocity, true, true, math.random(0, 2));
	end;
end;
local l__Players__7 = workspace:FindFirstChild("Players");
local u8 = shared.require("ReplicationInterface");
function v1.knifeHitDetection(p18, p19, p20, p21, p22, p23, p24)
	local v8 = u1.getCharacterObject();
	if not v8 then
		return;
	end;
	local v9 = nil;
	if not p19[p20.Parent] and not p19[p20] then
		if p20.Name == "Window" then
			u4:breakwindow(p20, p23.Origin, p23.Direction);
			v9 = p20;
		elseif p20.Parent.Name == "Dead" then
			u4:bloodhit(p20.Position, p20.CFrame.lookVector);
			v9 = p20.Parent;
		elseif p20:IsDescendantOf(l__Players__7) then
			local v10 = v8:getRootPart();
			local v11 = u8.getPlayerFromBodyPart(p20);
			local l__Torso__12 = p20.Parent:FindFirstChild("Torso");
			local v13 = p18:getWeaponStat("damage0");
			local v14 = p18:getWeaponStat("damage1");
			if v11 and v11.TeamColor ~= l__LocalPlayer__2.TeamColor and p20.Parent:FindFirstChild("Head") and l__Torso__12 then
				local v15 = (l__Torso__12.CFrame.lookVector:Dot((p21 - v10.Position).unit) * 0.5 + 0.5) * (v14 - v13) + v13;
				if v15 > 100 then

				end;
				if p20.Name == "Head" then
					v15 = v15 * p18:getWeaponStat("multhead");
				elseif p20.Name == "Torso" then
					v15 = v15 * p18:getWeaponStat("multtorso");
				end;
				u6:send("knifehit", v11, p20.Name);
				u4:bloodhit(p21, true, v15, Vector3.new(0, -8, 0) + (p21 - v10.Position).unit * 8);
				u5.fireHitmarker(p20.Name == "Head");
			end;
			v9 = p20.Parent;
		elseif p24 then
			u4:bullethit(p20, p21, p22);
			v9 = p20;
		end;
		if v9 then
			p19[v9] = true;
		end;
	end;
end;
return v1;

