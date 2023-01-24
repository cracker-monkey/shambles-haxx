
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PlayerDataStoreClient");
local v3 = shared.require("RenderSteppedRunner");
local v4 = shared.require("ActiveLoadoutUtils");
local v5 = shared.require("PlayerDataUtils");
local v6 = shared.require("CharacterEvents");
local v7 = shared.require("GameClock");
local v8 = shared.require("input");
local u1 = nil;
function v1.isAlive()
	return u1 or true;
end;
function v1.getCharacterObject()
	return u1;
end;
local u2 = shared.require("network");
function v1.spawn(p1)
	if u1 then
		warn("CharacterInterface: Called spawn again before despawning existing character");
		return;
	end;
	u2:send("spawn", p1);
end;
function v1.despawn()
	if not v1.isAlive() then
		warn("CharacterInterface: No active character to despawn");
		return;
	end;
	u2:send("forcereset");
end;
local u3 = v7.getTime();
local u4 = 1 / shared.require("PublicSettings").actorClientReplicationRate;
local u5 = nil;
function v1.step(p2)
	local v9 = v7.getTime();
	if not v1.isAlive() then
		return;
	end;
	u1:step(p2);
	if u3 < v9 then
		u3 = v9 + u4;
		local v10 = u5.getActiveCamera("MainCamera"):getAngles();
		u2:send("repupdate", u1:getRootPart().Position, Vector2.new(v10.x, v10.y), v7.getTime());
	end;
end;
local u6 = nil;
function v1._init()
	u5 = shared.require("CameraInterface");
	u6 = shared.require("CharacterObject");
	game:GetService("UserInputService").WindowFocused:Connect(function()
		if v1.isAlive() then
			wait(0.03333333333333333);
			v8.mouse:hide();
		end;
	end);
	game:GetService("UserInputService").InputChanged:Connect(function(...)
		if not v1.isAlive() then
			return;
		end;
		v8.processInputChanged(...);
	end);
	game:GetService("UserInputService").InputBegan:Connect(function(...)
		if not v1.isAlive() then
			return;
		end;
		v8.processInputBegan(...);
	end);
	v3:addTask("CharacterInterface", v1.step);
	u2:add("spawn", function(p3, p4, p5)
		if u1 then
			u1:Destroy();
			u1 = nil;
			warn("CharacterInterface: Found existing character when spawning");
		end;
		u1 = u6.new(p3, p4);
		v6.onSpawned:fire(p3, p4, p5 and p5.classData or v4.getActiveLoadoutData(v2.getPlayerData()), p5 and p5.attachmentData or v5.getAttLoadoutData(v2.getPlayerData()));
	end);
	u2:add("despawn", function(p6)
		v6.onDespawning:fire(p6);
		if u1 then
			u1:Destroy();
			u1 = nil;
		end;
		v6.onDespawned:fire(p6);
	end);
	u2:add("correctposition", function(p7)
		if u1 then
			local v11 = u1:getRootPart();
			v11.Position = p7;
			v11.Velocity = Vector3.zero;
		end;
	end);
	u2:add("updatepersonalhealth", function(...)
		if not u1 then
			warn("CharacterInterface: No active character for updatepersonalhealth");
			return;
		end;
		u1:updateHealth(...);
	end);
end;
return v1;

