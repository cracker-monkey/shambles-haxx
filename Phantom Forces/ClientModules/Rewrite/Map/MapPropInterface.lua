
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("CharacterInterface");
local v3 = shared.require("HeartbeatRunner");
local v4 = shared.require("GameClock");
local v5 = shared.require("network");
local v6 = shared.require("trash");
local l__ReplicatedStorage__7 = game.ReplicatedStorage;
local u1 = {
	caplight = nil, 
	Phantoms = {
		revealtime = 0, 
		droptime = 0, 
		carrier = nil, 
		carrymodel = nil, 
		dropmodel = nil, 
		dropped = false, 
		basecf = CFrame.new()
	}, 
	Ghosts = {
		revealtime = 0, 
		droptime = 0, 
		carrier = nil, 
		carrymodel = nil, 
		dropmodel = nil, 
		dropped = false, 
		basecf = CFrame.new()
	}
};
function v1.getFlagData(p1)
	return u1[p1];
end;
local u2 = 0;
local u3 = 0;
function v1.getTagCount()
	return u2, u3;
end;
local u4 = shared.require("ReplicationInterface");
local u5 = shared.require("PlayerStatusInterface");
function v1.isNearEnemyFlag(p2)
	local v8 = u4.getEntry(p2);
	if not v8 then
		return false;
	end;
	local v9 = u5.getOppositeTeam(p2);
	if u1[v9] and u1[v9].basecf and (u1[v9].basecf.p - v8:getPosition()).Magnitude < 100 then
		return true;
	end;
	return false;
end;
local u6 = shared.require("TeamConfig");
local l__LocalPlayer__7 = game:GetService("Players").LocalPlayer;
function v1.resetFlag(p3, p4)
	local v10 = u6.getTeamName(p3);
	local v11 = v1.getFlagData(v10);
	if not v11 then
		warn("MapPropInterface: No flagData found for resetFlag", p3, v10);
		return;
	end;
	v11.revealtime = 0;
	v11.carrier = nil;
	if p4 == l__LocalPlayer__7 and u1.caplight and u1.caplight.Parent then
		u1.caplight:Destroy();
		u1.caplight = nil;
		return;
	end;
	if v11.carrymodel and v11.carrymodel.Parent then
		v11.carrymodel:Destroy();
		v11.carrymodel = nil;
	end;
end;
function v1.cleanFlags()
	for v12, v13 in next, u6.teamNames do
		v1.resetFlag(v12);
		local v14 = u1[v13];
		if v14 and v14.dropmodel then
			v14.dropmodel:Destroy();
			v14.dropmodel = nil;
		end;
	end;
end;
local l__FlagDrop__8 = l__ReplicatedStorage__7.GamemodeProps.FlagDrop;
function v1.dropFlag(p5, p6, p7, p8)
	local v15 = u6.getTeamName(p5);
	local v16 = u1[v15];
	if not v16 then
		warn("MapPropInterface: No ctfData found for dropFlag", p5, v15);
		return;
	end;
	if v16.dropmodel and v16.dropmodel.Parent then
		local v17 = v16.dropmodel;
	else
		v17 = l__FlagDrop__8:Clone();
	end;
	local l__Base__18 = v17:FindFirstChild("Base");
	if not l__Base__18 then
		warn("MapPropInterface: No flag base found", v17);
		return;
	end;
	local l__BillboardGui__19 = l__Base__18:FindFirstChild("BillboardGui");
	v17:FindFirstChild("Tag").BrickColor = p5;
	l__Base__18:FindFirstChild("PointLight").Color = p5.Color;
	v17.TeamColor.Value = p5;
	l__BillboardGui__19.Display.BackgroundColor = p5;
	if p5 == l__LocalPlayer__7.TeamColor then
		if p8 then
			local v20 = "Protect";
		else
			v20 = "Dropped";
		end;
		l__BillboardGui__19.Status.Text = v20;
	else
		if p8 then
			local v21 = "Capture";
		else
			v21 = "Pick Up";
		end;
		l__BillboardGui__19.Status.Text = v21;
	end;
	v17:SetPrimaryPartCFrame(p6);
	v17.Location.Value = p6;
	v17.Parent = workspace.Ignore.GunDrop;
	v16.dropmodel = v17;
	v16.droptime = p7;
	v16.dropped = not p8;
	if p8 then
		v16.basecf = p6;
	end;
end;
local l__FlagCarry__9 = l__ReplicatedStorage__7.GamemodeProps.FlagCarry;
function v1.attachFlag(p9)
	local v22 = u4.getEntry(p9);
	if not (not p9) and not (not p9.Parent) and not (not v22) and not (not v22:isAlive()) then
		local v23, v24 = u5.getOppositeTeam(p9);
		local v25 = v22:getThirdPersonObject();
		if not v25 then
			error(string.format("No third person object model found for %s parent %s alive %s", tostring(p9), tostring(p9.Parent), tostring(v22:isAlive())));
		end;
		local v26 = v25:getCharacterHash();
		if v26 and v26.torso then
			local v27 = l__FlagCarry__9:Clone();
			v27.Tag.BrickColor = v24;
			v27.Tag.BillboardGui.Display.BackgroundColor3 = v24.Color;
			v27.Tag.BillboardGui.AlwaysOnTop = false;
			v27.Base.PointLight.Color = v24.Color;
			local l__next__28 = next;
			local v29, v30 = v27:GetChildren();
			while true do
				local v31, v32 = l__next__28(v29, v30);
				if not v31 then
					break;
				end;
				if v32 ~= v27.Base then
					local v33 = Instance.new("Weld");
					v33.Part0 = v27.Base;
					v33.Part1 = v32;
					v33.C0 = v27.Base.CFrame:inverse() * v32.CFrame;
					v33.Parent = v27.Base;
				end;
				if v32:IsA("BasePart") then
					v32.Massless = true;
					v32.CastShadow = false;
					v32.Anchored = false;
					v32.CanCollide = false;
				end;			
			end;
			local v34 = Instance.new("Weld");
			v34.Part0 = v26.torso;
			v34.Part1 = v27.Base;
			v34.Parent = v27.Base;
			v27.Parent = workspace.Ignore.Misc;
			u1[v23].carrymodel = v27;
		end;
		return;
	end;
end;
function v1.clearMap()
	workspace.Ignore.GunDrop:ClearAllChildren();
	v1.cleanFlags();
end;
local u10 = shared.require("ObjectiveManagerClient");
local u11 = nil;
local l__Map__12 = workspace.Map;
local u13 = shared.require("effects");
function v1.setUpObjectives()
	u10:clear();
	if u11 then
		u11:Disconnect();
	end;
	local l__AGMP__35 = l__Map__12:FindFirstChild("AGMP");
	if l__AGMP__35 then
		for v36, v37 in l__AGMP__35() do
			u10:add(v37);
		end;
		u11 = l__AGMP__35.ChildAdded:connect(function(p10)
			u10:add(p10);
		end);
	end;
	if u13.highperf then
		u13:simplify();
	end;
end;
local u14 = shared.require("GameRoundInterface");
local u15 = 0;
local u16 = math.pi / 180;
function v1.renderStep()
	local v38 = u14.getModeName();
	u15 = u15 + 1;
	if v38 == "Capture the Flag" then
		local l__next__39 = next;
		local v40, v41 = workspace.Ignore.GunDrop:GetChildren();
		while true do
			local v42, v43 = l__next__39(v40, v41);
			if not v42 then
				break;
			end;
			v41 = v42;
			if v43.Name == "FlagDrop" then
				v43:SetPrimaryPartCFrame(v43.Location.Value * CFrame.new(0, 0.2 * math.sin(u15 * 5 * u16), 0) * CFrame.Angles(0, u15 * 4 * u16, 0));
				local v44 = v1.getFlagData((u6.getTeamName(v43.TeamColor.Value)));
				if v44.dropped then
					local l__BillboardGui__45 = v43.Base:FindFirstChild("BillboardGui");
					local l__droptime__46 = v44.droptime;
					if l__BillboardGui__45 and l__droptime__46 and v4.getTime() < l__droptime__46 + 60 then
						if l__LocalPlayer__7.TeamColor ~= v43.TeamColor.Value then
							local v47 = "Pick up in: ";
						else
							v47 = "Returning in: ";
						end;
						l__BillboardGui__45.Status.Text = v47 .. math.floor(l__droptime__46 + 60 - v4.getTime());
					end;
				end;
			end;		
		end;
	end;
end;
local u17 = 0;
function v1.step()
	local v48 = v4.getTime();
	if u17 + 0.016666666666666666 < v48 then
		v1.renderStep();
		u17 = v48 + 0.016666666666666666;
	end;
end;
local l__PointLight__18 = l__ReplicatedStorage__7.GamemodeProps.FlagDrop.Base.PointLight;
function v1._init()
	v1.setUpObjectives();
	v5:add("newmap", v1.setUpObjectives);
	v5:add("stealflag", function(p11, p12)
		print("flag stolen", p11);
		local v49, v50 = u5.getOppositeTeam(p11);
		local v51 = v1.getFlagData(v49);
		v51.revealtime = p12;
		v51.carrier = p11;
		if v51.dropmodel then
			v51.dropmodel:Destroy();
			v51.dropmodel = nil;
		end;
		if p11 ~= l__LocalPlayer__7 or not v2.isAlive() then
			v1.attachFlag(p11);
			return;
		end;
		u1.caplight = l__PointLight__18:Clone();
		u1.caplight.Color = v50.Color;
		u1.caplight.Parent = v2.getCharacterObject():getRootPart();
	end);
	v5:add("updateflagrecover", function(p13, p14, p15)
		local v52 = v1.getFlagData((u6.getTeamName(p13)));
		if not v52 then
			warn("MapPropInterface: No flagData found on updateflagrecover", p13, p14, p15);
			return;
		end;
		if v52.dropmodel then
			local l__IsCapping__53 = v52.dropmodel:FindFirstChild("IsCapping");
			local l__CapPoint__54 = v52.dropmodel:FindFirstChild("CapPoint");
			if l__IsCapping__53 and l__CapPoint__54 then
				l__IsCapping__53.Value = p14;
				l__CapPoint__54.Value = p15;
			end;
		end;
	end);
	v5:add("dropflag", function(p16, p17, p18, p19, p20)
		v1.dropFlag(p16, p18, p19, p20);
		v1.resetFlag(p16, p17);
	end);
	v5:add("updatetags", function(p21, p22)
		u3 = p21 and 0;
		u2 = p22 and 0;
	end);
	v5:add("getrounddata", function(p23)
		local l__ServerSettings__55 = game.ReplicatedStorage.ServerSettings;
		if l__ServerSettings__55.AllowSpawn.Value and l__ServerSettings__55.GameMode.Value == "Capture the Flag" and p23.ctf then
			for v56, v57 in u6.teamNames, nil do
				local v58 = p23.ctf[v56.Name];
				if v58 and u1[v57] then
					u1[v57].basecf = v58.basecf;
					if v58.carrier and not v58.dropped then
						u1[v57].carrier = v58.carrier;
						u1[v57].revealtime = v58.revealtime;
						v1.attachFlag(v58.carrier);
					elseif v58.dropped then
						u1[v57].dropped = true;
						v1.dropFlag(v56, v58.dropcf, v58.droptime, false);
					else
						u1[v57].dropped = false;
						v1.dropFlag(v56, v58.basecf, v58.droptime, true);
					end;
				end;
			end;
		end;
	end);
	v6.Reset:connect(v1.clearMap);
	v3:addTask("MapPropInterfaceStep", v1.step);
end;
return v1;

