
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = RaycastParams.new();
v2.IgnoreWater = true;
v2.FilterDescendantsInstances = { workspace.Map };
v2.FilterType = Enum.RaycastFilterType.Whitelist;
local u1 = shared.require("effects");
local u2 = shared.require("HudCrosshairsInterface");
local v3 = {};
local l__CurrentCamera__3 = workspace.CurrentCamera;
local u4 = shared.require("sound");
local l__Ignore__5 = workspace:FindFirstChild("Ignore");
local u6 = shared.require("PlayerStatusInterface");
local u7 = shared.require("ReplicationInterface");
function v3.Frag(p1, p2, p3, p4)
	local l__range0__4 = p1.range0;
	local l__range1__5 = p1.range1;
	local l__damage0__6 = p1.damage0;
	local l__damage1__7 = p1.damage1;
	local l__magnitude__8 = (l__CurrentCamera__3.CFrame.p - p3).magnitude;
	p2.Position = p3;
	if l__magnitude__8 <= 50 then
		u4.play("fragClose", 2, 1, p2, true);
	elseif l__magnitude__8 <= 200 then
		u4.play("fragMed", 3, 1, p2, true);
	elseif l__magnitude__8 > 200 then
		u4.play("fragFar", 3, 1, p2, true);
	end;
	local l__Explosion__9 = p2:FindFirstChild("Explosion");
	if l__Explosion__9 and l__Explosion__9:IsA("Attachment") then
		local v10 = Instance.new("Part");
		v10.Position = p3;
		v10.Transparency = 1;
		v10.Size = p2.Size;
		v10.CanCollide = false;
		v10.CanQuery = false;
		v10.CanTouch = false;
		v10.Anchored = true;
		v10.Parent = l__Ignore__5.Misc;
		l__Explosion__9.Parent = v10;
		for v11, v12 in pairs(l__Explosion__9:GetChildren()) do
			if v12:IsA("ParticleEmitter") then
				v12:Emit(v12:GetAttribute("EmitCount") and 1);
			end;
		end;
		delay(5, function()
			v10:Destroy();
		end);
	else
		local v13 = Instance.new("Explosion");
		v13.Position = p3;
		v13.BlastRadius = p1.blastradius;
		v13.BlastPressure = 0;
		v13.DestroyJointRadiusPercent = 0;
		v13.Parent = workspace;
	end;
	local l__next__14 = next;
	local v15, v16 = game:GetService("Players"):GetPlayers();
	while true do
		local v17, v18 = l__next__14(v15, v16);
		if not v17 then
			break;
		end;
		v16 = v17;
		if not u6.isFriendly(v18) and u6.isPlayerAlive(v18) then
			local v19 = u7.getEntry(v18):getPosition();
			if v19 then
				local v20 = v19 - p3;
				local l__magnitude__21 = v20.magnitude;
				if l__magnitude__21 < l__range1__5 and not workspace:Raycast(p3, v20, v2) then
					u1:bloodhit(v19, true, l__magnitude__21 < l__range0__4 and l__damage0__6 or (l__magnitude__21 < l__range1__5 and (l__damage1__7 - l__damage0__6) / (l__range1__5 - l__range0__4) * (l__magnitude__21 - l__range0__4) + l__damage0__6 or l__damage1__7), v20.unit * 50);
					if p4 then
						u2.fireHitmarker();
					end;
				end;
			end;
		end;	
	end;
end;
local u8 = shared.require("network");
local u9 = shared.require("ContentDatabase");
local l__LocalPlayer__10 = game:GetService("Players").LocalPlayer;
local u11 = shared.require("GameClock");
local u12 = shared.require("BinarySearchLib");
local function u13(p5, p6, p7, p8, p9, p10, p11)
	if p5 == p8 and p5 == p11 then
		return p9, p10;
	end;
	local v22 = p8 - p5;
	local v23 = (p11 - p5) / v22;
	local v24 = (p8 - p11) / v22;
	return v24 * v24 * (v24 + 3 * v23) * p6 + v22 * v24 * v24 * v23 * p7 - v22 * v24 * v23 * v23 * p10 + v23 * v23 * (v23 + 3 * v24) * p9, 6 * v24 * v23 / v22 * p9 - 6 * v24 * v23 / v22 * p6 + v24 * (v24 - 2 * v23) * p7 + v23 * (v23 - 2 * v24) * p10;
end;
local u14 = shared.require("ScreenCull");
function v1._init()
	u8:add("newgrenade", function(p12, p13, p14, p15, p16)
		local v25 = u9.getWeaponData(p13);
		local v26 = u9.getWeaponModel(p13).Trigger:Clone();
		v26.Trail.Enabled = true;
		v26.Anchored = true;
		v26.Ticking:Play();
		v26.Parent = l__Ignore__5.Misc;
		local l__Indicator__27 = v26:FindFirstChild("Indicator");
		if l__Indicator__27 then
			if p12.TeamColor ~= l__LocalPlayer__10.TeamColor then
				l__Indicator__27.Enemy.Visible = true;
			else
				l__Indicator__27.Friendly.Visible = true;
			end;
		end;
		local u15 = p12 == l__LocalPlayer__10;
		local l__t__16 = p14[1].t;
		local u17 = u11.getTime();
		local u18 = 1;
		local u19 = nil;
		u19 = game:GetService("RunService").RenderStepped:connect(function()
			local v28 = u11.getTime();
			local v29 = ((p16 - v28) * l__t__16 + (v28 - u17) * p16) / (p16 - u17);
			local v30, v31 = u12.spanSearchNodes(p14, "t", v29);
			local v32 = p14[v30];
			local v33 = p14[v31];
			local v34 = Vector3.zero;
			if v32 and v33 then
				local v35, v36 = u13(v32.t, v32.p, v32.v, v33.t, v33.p, v33.v, v29);
				v34 = v35;
			elseif v32 then
				v34 = v32.p;
				local l__v__37 = v32.v;
			elseif v33 then
				v34 = v33.p;
				local l__v__38 = v33.v;
			end;
			v26.CFrame = CFrame.new(v34);
			if l__Indicator__27 then
				if u14.sphere(v34, 4) then
					l__Indicator__27.Enabled = not workspace:Raycast(v34, l__CurrentCamera__3.CFrame.p - v34, v2);
				else
					l__Indicator__27.Enabled = false;
				end;
			end;
			local v39 = p15[u18];
			if v39 and v39.t <= v29 then
				u1:breakwindow(v39.part);
				u18 = u18 + 1;
			end;
			if p16 <= v28 then
				(v3[v25.grenadetype] or v3.Frag)(v25, v26, v34, u15);
				v26:Destroy();
				u19:Disconnect();
			end;
		end);
	end);
end;
return v1;

