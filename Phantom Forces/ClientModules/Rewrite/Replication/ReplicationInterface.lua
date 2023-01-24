
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("CharacterInterface");
local v3 = shared.require("ContentDatabase");
local v4 = shared.require("PublicSettings");
local v5 = table.create(game:GetService("Players").MaxPlayers);
local u1 = table.create(game:GetService("Players").MaxPlayers);
local u2 = 0;
local u3 = 0;
local u4 = shared.require("GameClock");
local u5 = shared.require("ScreenCull");
local u6 = 2;
function v1.setHighMs(p1)
	u6 = p1;
end;
local u7 = 1;
function v1.setLowMs(p2)
	u7 = p2;
end;
local u8 = {};
function v1.getEntry(p3)
	return u8[p3];
end;
local u9 = shared.require("ReplicationObject");
local u10 = shared.require("ReplicationEvents");
function v1.addEntry(p4, ...)
	if u8[p4] then
		u8[p4]:Destroy();
		u8[p4] = nil;
	end;
	print("added new entry", p4, ...);
	u8[p4] = u9.new(p4, ...);
	u10.onEntryAdded:fire(p4, ...);
end;
function v1.removeEntry(p5)
	if u8[p5] then
		u8[p5]:Destroy();
		u8[p5] = nil;
		u10.onEntryRemoved:fire(p5);
	end;
end;
function v1.operateOnAllEntries(p6)
	for v6, v7 in next, u8 do
		p6(v6, v7);
	end;
end;
function v1.getPlayerFromBodyPart(p7)
	local u11 = nil;
	v1.operateOnAllEntries(function(p8, p9)
		if not p9:isAlive() then
			return;
		end;
		if p7:IsDescendantOf((p9:getThirdPersonObject():getCharacterModel())) then
			u11 = p8;
		end;
	end);
	return nil;
end;
function v1.getAllBodyParts()
	local u12 = {};
	v1.operateOnAllEntries(function(p10, p11)
		if not p11:isAlive() then
			return;
		end;
		local l__next__8 = next;
		local v9, v10 = p11:getThirdPersonObject():getCharacterHash();
		while true do
			local v11, v12 = l__next__8(v9, v10);
			if not v11 then
				break;
			end;
			v10 = v11;
			table.insert(u12, v12);		
		end;
	end);
	return u12;
end;
local u13 = shared.require("HitBoxConfig");
local u14 = shared.require("InputType");
local l__LocalPlayer__15 = game:GetService("Players").LocalPlayer;
local u16 = shared.require("Math");
local u17 = { "head", "torso", "lleg", "rleg", "larm", "rarm" };
local u18 = nil;
local u19 = shared.require("CloseCast");
function v1.playerHitCheck(p12, p13)
	local u20 = u13:get(u14.purecontroller());
	local u21 = {};
	v1.operateOnAllEntries(function(p14, p15)
		if not p15:isAlive() or p14.TeamColor == l__LocalPlayer__15.TeamColor then
			return;
		end;
		local v13 = p15:getThirdPersonObject():getCharacterHash();
		local v14 = p13 - p12;
		if u16.doesRayIntersectSphere(p12, v14, v13.torso.Position, 6) then
			local v15 = nil;
			local v16 = nil;
			local v17 = (1 / 0);
			local v18 = nil;
			local v19 = nil;
			local v20 = (1 / 0);
			local v21 = nil;
			for v22 = 1, #u17 do
				local v23 = v13[u17[v22]];
				local l__precedence__24 = u20[v23.Name].precedence;
				local v25, v26, v27, v28 = u19.closeCastPart(v23, p12, v14);
				if l__precedence__24 < v17 and v28 < (u18 or u20[v23.Name].radius) then
					v17 = l__precedence__24;
					v15 = v23;
					v16 = v28;
					v18 = v27;
				end;
				if l__precedence__24 < v20 and v28 == 0 then
					v20 = l__precedence__24;
					v19 = v23;
					v21 = v27;
				end;
			end;
			if v15 then
				u21[p14] = {
					bestPart = v15, 
					bestDistance = v16, 
					bestNearestPosition = v18, 
					bestDirectPart = v19, 
					bestDirectNearestPosition = v21
				};
			end;
		end;
	end);
	return u21;
end;
local u22 = table.create(game:GetService("Players").MaxPlayers);
local u23 = coroutine.create(function()
	while true do
		if u1[1].lastupframe == u2 then
			coroutine.yield(true);
		elseif u3 < u4.getTime() then
			coroutine.yield(true);
		end;
		local v29 = table.remove(u1, 1);
		if v29:isAlive() then
			local v30, v31 = v29:getPosition();
			if u5.sphere(v30, 4) or u5.sphere(v31, 4) then
				v29:step(3, true);
			else
				v29:step(1, false);
			end;
		end;
		v29.lastupframe = u2;
		table.insert(u1, v29);	
	end;
end);
local u24 = nil;
local u25 = shared.require("network");
function v1.step()
	for v32, v33 in next, u8 do
		if v32.Parent then
			if not u22[v33] then
				u22[v33] = true;
				table.insert(u1, v33);
			end;
		else
			warn("ReplicationInterface: Player object is gone", v32);
			for v34 = 1, #u1 do
				if u1[v34] == v33 then
					table.remove(u1, v34);
				end;
			end;
			u22[v33] = nil;
			v1.removeEntry(v32);
		end;
	end;
	u2 = u2 + 1;
	u3 = u4.getTime() + (u7 + u6) / 1000;
	if #u1 > 0 then
		local v35, v36 = coroutine.resume(u23);
		if not v35 and not u24 then
			warn("CRITICAL: Replication thread yielded or errored");
			warn(v36);
			u24 = true;
			u25:send("debug", string.format("Replication thread broke.\n%s", v36));
		end;
	end;
end;
local u26 = shared.require("Raycast");
local u27 = shared.require("BulletCheck");
local u28 = shared.require("PlayerStatusEvents");
local u29 = shared.require("PlayerSettingsInterface");
local u30 = shared.require("RagdollInterface");
local u31 = shared.require("HeartbeatRunner");
function v1._init()
	shared.require("ParticleEvents").processHitEvent:connect(function(p16, p17, p18, p19, p20)
		local v37 = v1.playerHitCheck(p18, p19);
		if v37 then
			local v38 = nil;
			local v39 = nil;
			while true do
				local v40, v41 = v37(v38, v39);
				if not v40 then
					break;
				end;
				local v42 = nil;
				local v43 = nil;
				local l__bestNearestPosition__44 = v41.bestNearestPosition;
				local l__bestDirectPart__45 = v41.bestDirectPart;
				local v46 = nil;
				if v41.bestDistance > 0 then
					v46 = u26.raycast(p17, l__bestNearestPosition__44 - p17, p16.physignore, p20) or true;
				end;
				if not v46 then
					v42 = v41.bestPart;
					v43 = l__bestNearestPosition__44;
				elseif l__bestDirectPart__45 then
					v42 = l__bestDirectPart__45;
					v43 = v41.bestDirectNearestPosition;
				end;
				if v42 and u27(p17, v43, p16.velocity, p16.acceleration, p16.penetrationdepth, 0.022222222222222223) then
					p16:onplayerhit(v40, v42, v43);
				end;			
			end;
		end;
	end);
	u25:add("lolhi", function(p21)
		u18 = p21;
	end);
	game:GetService("Players").PlayerAdded:Connect(function(p22)
		v1.addEntry(p22);
	end);
	local l__next__47 = next;
	local v48, v49 = game:GetService("Players"):GetPlayers();
	while true do
		local v50, v51 = l__next__47(v48, v49);
		if not v50 then
			break;
		end;
		v49 = v50;
		if v51 ~= l__LocalPlayer__15 then
			v1.addEntry(v51);
		end;	
	end;
	game:GetService("Players").PlayerRemoving:Connect(function(p23)
		v1.removeEntry(p23);
	end);
	u25:add("updateothershealth", function(p24, p25, p26, p27)
		local v52 = v1.getEntry(p24);
		if not v52 then
			warn("ReplicationInterface: No replicationObject found on updateothershealth for", p24);
			return;
		end;
		v52:updateHealth(p25, p26, p27);
	end);
	u25:add("state", function(p28, p29)
		local v53 = v1.getEntry(p28);
		if not v53 then
			warn("ReplicationInterface: No replicationObject found on state for", p28);
			return;
		end;
		v53:updateState(p29);
	end);
	u25:add("stance", function(p30, p31)
		local v54 = v1.getEntry(p30);
		if not v54 then
			warn("ReplicationInterface: No replicationObject found on stance for", p30);
			return;
		end;
		if not v54:isAlive() then
			return;
		end;
		v54:getThirdPersonObject():setStance(p31);
	end);
	u25:add("sprint", function(p32, p33)
		local v55 = v1.getEntry(p32);
		if not v55 then
			warn("ReplicationInterface: No replicationObject found on sprint for", p32);
			return;
		end;
		if not v55:isAlive() then
			return;
		end;
		v55:getThirdPersonObject():setSprint(p33);
	end);
	u25:add("aim", function(p34, p35)
		local v56 = v1.getEntry(p34);
		if not v56 then
			warn("ReplicationInterface: No replicationObject found on aim for", p34);
			return;
		end;
		if not v56:isAlive() then
			return;
		end;
		v56:getThirdPersonObject():setAim(p35);
	end);
	u25:add("stab", function(p36)
		local v57 = v1.getEntry(p36);
		if not v57 then
			warn("ReplicationInterface: No replicationObject found on stab for", p36);
			return;
		end;
		if not v57:isAlive() then
			return;
		end;
		v57:getThirdPersonObject():stab();
	end);
	u25:add("equip", function(p37, p38)
		local v58 = nil;
		local v59 = v1.getEntry(p37);
		if not v59 then
			warn("ReplicationInterface: No replicationObject found on equip for", p37);
			return;
		end;
		if not v59:isAlive() then
			return;
		end;
		v58 = v59:getThirdPersonObject();
		if p38 > 2 then
			v58:equipMelee();
			return;
		end;
		v58:equip(p38);
	end);
	u25:add("swapweapon", function(p39, p40, p41)
		local v60 = v1.getEntry(p39);
		if not v60 then
			warn("ReplicationInterface: No replicationObject found on swapweapon for", p39);
			return;
		end;
		if not v60:isAlive() then
			return;
		end;
		v60:swapWeapon(p40, p41);
	end);
	u25:add("newspawn", function(p42, p43, p44)
		local v61 = v1.getEntry(p42);
		if not v61 then
			warn("ReplicationInterface: No replicationObject found on newspawn for", p42);
			return;
		end;
		v61:spawn(p43, p44);
		u28.onPlayerSpawned:fire(p42, p43, p44);
	end);
	u25:add("died", function(p45, p46, p47, p48, p49)
		local v62 = v1.getEntry(p45);
		if not v62 then
			return;
		end;
		local v63 = v62:despawn();
		if v63 then
			local v64 = nil;
			v64 = v63:popCharacterModel();
			if u29.getValue("toggleragdolls") then
				u30.createRagdoll(v64, p46, p47, p48, p49);
			else
				v64:Destroy();
			end;
			v63:Destroy();
		else
			warn("ReplicationInterface: No thirdPersonObject found on died", p45);
		end;
		u28.onPlayerDied:fire(p45, p46, p47, p48, p49);
	end);
	local v65 = shared.require("SmoothReplicationPackager");
	local u32 = shared.require("BitBuffer229").newReader();
	local u33 = {};
	local u34 = v65.new(shared.require("Fib3Decoder").new(0.020833333333333332), Vector3.zero);
	local u35 = v65.new(shared.require("Fib2Decoder").new(0.020833333333333332), Vector2.new());
	local function u36(p50)
		return u32:read(p50);
	end;
	u25:add("bulkplayerupdate", function(p51)
		if p51.newarray then
			u33 = p51.newarray;
		end;
		if p51.initstates then
			local l__initstates__66 = p51.initstates;
			for v67 = 1, #l__initstates__66 do
				local v68 = nil;
				v68 = l__initstates__66[v67];
				local v69 = u33[v67];
				if v69 == l__LocalPlayer__15 then
					local v70, v71 = unpack(v68);
					u34:initializeState(unpack(v70));
					u35:initializeState(unpack(v71));
				else
					local v72 = v1.getEntry(v69);
					if not v72 then
						warn("ReplicationInterface: No replicationObject found on bulkplayerupdate initstates for", v69);
					else
						v72:initState(v68);
					end;
				end;
			end;
		end;
		if p51.packets then
			local l__packets__73 = p51.packets;
			for v74 = 1, #u33 do
				local v75 = u33[v74];
				local v76 = u32:load(l__packets__73[v74]);
				if u32:read(1) == 1 then
					if v75 == l__LocalPlayer__15 then
						local v77 = u32:read(64);
						u34:readAndUpdate(u36);
						u35:readAndUpdate(u36);
					else
						local v78 = v1.getEntry(v75);
						if not v78 then
							warn("ReplicationInterface: No replicationObject found on bulkplayerupdate packets for", v75);
						else
							v78:updateReplication(u36);
						end;
					end;
				end;
			end;
		end;
	end);
	u31:addTask("ReplicationInterface", v1.step);
end;
return v1;

