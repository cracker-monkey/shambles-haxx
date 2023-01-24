
-- Decompiled with the Synapse X Luau decompiler.

math.randomseed(tick());
local v1 = game:GetService("RunService"):IsStudio();
local l__Value__2 = game:GetService("ReplicatedFirst"):WaitForChild("GameData"):WaitForChild("Version", 3).Value;
local l__LocalPlayer__3 = game:GetService("Players").LocalPlayer;
print("Waiting on game to finish loading");
while true do
	wait(1);
	if game:IsLoaded() and shared.require then
		break;
	end;
end;
local v4 = tick();
local v5 = shared.require("superusers")[l__LocalPlayer__3.UserId];
pcall(function()
	game:GetService("StarterGui"):SetCore("TopbarEnabled", false);
end);
local v6 = Instance.new("Folder");
v6.Name = "Players";
v6.Parent = workspace;
for v7, v8 in game:GetService("Teams")() do
	local v9 = Instance.new("Folder");
	v9.Name = v8.TeamColor.Name;
	v9.Parent = v6;
end;
shared.add("PlayerPolicy", (shared.require("PolicyHelper").new(l__LocalPlayer__3)));
local v10 = shared.require("GameClock");
print("Waiting on GameClock sync");
while true do
	wait();
	if v10.isReady() then
		break;
	end;
end;
print("Waiting on player data");
local v11 = shared.require("PlayerDataStoreClient");
while true do
	wait();
	if v11.isDataReady() then
		break;
	end;
end;
local v12 = shared.require("PublicSettings");
local v13 = shared.require("RenderSteppedRunner");
local v14 = shared.require("HeartbeatRunner");
local u1 = { "failed to load", "http request failed", "could not fetch", "download sound", "thumbnail" };
local u2 = shared.require("network");
game:GetService("LogService").MessageOut:connect(function(p1, p2)
	if p2 == Enum.MessageType.MessageError then
		for v15 = 1, #u1 do
			if string.find(string.lower(p1), u1[v15]) then
				return;
			end;
		end;
		u2:send("debug", p1);
	end;
end);
local v16 = shared.require("trash");
local v17 = shared.require("vector");
local v18 = shared.require("cframe");
local v19 = shared.require("spring");
local v20 = shared.require("Event");
local v21 = shared.require("ScreenCull");
local v22 = shared.require("CameraInterface");
shared.require("MenuRequire");
shared.require("TouchRequire");
shared.require("ControlScript");
local v23 = shared.require("UnscaledScreenGui");
local v24 = shared.require("TouchScreenGui");
local v25 = shared.require("MenuScreenGui");
local v26 = shared.require("ChatScreenGui");
local v27 = shared.require("HudScreenGui");
local v28 = shared.require("Sequencer");
local v29 = shared.require("animation");
local v30 = shared.require("input");
local v31 = shared.require("particle");
local v32 = shared.require("effects");
local v33 = shared.require("tween");
local v34 = shared.require("InstanceType");
local v35 = shared.require("sound");
local l__getModifiedData__36 = shared.require("ModifyData").getModifiedData;
local v37 = shared.require("DayCycle");
local v38 = shared.require("GameClock");
local v39 = shared.require("ContentDatabase");
local v40 = shared.require("PlayerSettingsInterface");
local v41 = shared.require("PlayerSettingsEvents");
local v42 = shared.require("WeaponUtils");
local v43 = shared.require("Raycast");
local v44 = shared.require("LuaUtils");
for v45, v46 in v39.getAllWeaponsList() do
	v44.deepFreeze(v39.getWeaponData(v46));
end;
shared.require("RewriteRequire");
shared.require("ThrowableConnector");
shared.require("PerformanceAnalytics");
u2:add("setuiscale", function(p3)
	v27.setUIScale(p3);
	v26.setUIScale(p3);
end);
u2:add("setmenuscale", function(p4)
	v25.setUIScale(p4);
end);
u2:add("setmenuaspectratio", function(p5)
	v25.setUIAspectRatio(p5);
end);
u2:add("lightingt", function(p6)
	v37.setSeed(p6);
end);
print("Framework finished loading, duration:", tick() - v4);
game:GetService("RunService").Heartbeat:wait();
u2:ready();
if not v34.IsStudio() then

end;
v16.Reset:connect(v35.clear);
local v47 = shared.require("RunUpdater");
local v48 = shared.require("HeartbeatUpdater");
local v49 = shared.require("PageMainMenuDisplayMenu");
v13:addTask("CameraInterface", v22.step, { "input", "CharacterInterface" });
v13:addTask("tween", v33.step, { "WeaponControllerInterface" });
v13:addTask("particle", v31.step, { "CameraInterface" });
v13:addTask("RunUpdater", v47.step);
v13:addTask("input", v30.step);
v14:addTask("HeartbeatUpdater", v48.step);
v14:addTask("MenuStep", v49.step);
v14:addTask("dynobj", v37.objStep);
v14:addTask("blood", v32.bloodstep);
v14:addTask("daycycle", v37.step);
v25.enable();
v27.disable();
v23.disable();
v13:unlock();
v14:unlock();
local v50 = shared.require("CharacterInterface");
shared.require("CharacterEvents").onDespawned:connect(function(p7)
	v24.disable();
	v30.mouse.show();
	v30.mouse.free();
	if p7 then
		if v25.isEnabled() then
			return;
		end;
	else
		if v34.IsStudio() then
			local v51 = 0.1;
		else
			v51 = 5;
		end;
		task.delay(v51, function()
			if not v25.isEnabled() then
				v32:setuplighting(false);
				v23.disable();
				v25.enable();
				v27.disable();
			end;
		end);
		return;
	end;
	v32:setuplighting(false);
	v23.disable();
	v25.enable();
	v27.disable();
end);
local v52 = Instance.new("BindableEvent");
v52.Event:Connect(function()
	v50.despawn();
end);
local v53 = nil;
while not v53 do
	v53 = pcall(function()
		game:GetService("StarterGui"):SetCore("ResetButtonCallback", v52);
	end);
	task.wait(10);
end;

