
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("ContentDatabase");
local v3 = shared.require("HudScreenGui");
local v4 = shared.require("input");
local l__Main__5 = v3.getScreenGui().Main;
local u1 = nil;
function v1.canCapture(p1, p2)
	if not u1.isAlive() then
		return false;
	end;
	local v6 = u1:getCharacterObject():getRootPart().Position - p1;
	if not (v6.magnitude < p2) then
		return false;
	end;
	if not (v6.Y > 10) and not (v6.Y < 0) then
		return true;
	end;
	return false;
end;
local l__TextInteraction__2 = l__Main__5.TextInteraction;
function v1.updateInteraction(p3)
	l__TextInteraction__2.Text = p3;
end;
function v1.isInteracting()
	return l__TextInteraction__2.Text ~= "";
end;
local l__DisplayCapturing__3 = l__Main__5.DisplayCapturing;
function v1.updateCappingStatus(p4, p5, p6)
	if p6 == "ctf" then
		local v7 = 100;
	else
		v7 = 50;
	end;
	if not p4 then
		l__DisplayCapturing__3.Visible = false;
		return;
	end;
	l__DisplayCapturing__3.Visible = true;
	if p6 == "ctf" then
		local v8 = "Recovering...";
	else
		v8 = "Capturing...";
	end;
	l__DisplayCapturing__3.TextNote.Text = v8;
	l__DisplayCapturing__3.Percent.Size = UDim2.new(p5 / v7, 0, 1, 0);
end;
local l__Map__4 = workspace:FindFirstChild("Map");
local l__GunDrop__5 = workspace.Ignore.GunDrop;
local l__LocalPlayer__6 = game:GetService("Players").LocalPlayer;
local u7 = tick();
local u8 = shared.require("network");
function v1.step()
	local v9 = tick();
	if not u1.isAlive() then
		return;
	end;
	if not l__Map__4 then
		warn("HudInteractionInterface: No map found");
		return;
	end;
	local v10 = u1.getCharacterObject():getRootPart();
	v1.updateCappingStatus(false);
	local l__next__11 = next;
	local v12, v13 = l__GunDrop__5:GetChildren();
	while true do
		local v14, v15 = l__next__11(v12, v13);
		if not v14 then
			break;
		end;
		v13 = v14;
		if v15:FindFirstChild("Base") then
			if v15.Name == "FlagDrop" then
				if v1.canCapture(v15.Base.Position, 8) then
					if v15.TeamColor.Value == l__LocalPlayer__6.TeamColor and v15:FindFirstChild("IsCapping") and v15.IsCapping.Value then
						v1.updateCappingStatus(v15, v15.CapPoint.Value, "ctf");
					end;
					if u7 < v9 then
						u7 = u7 + 1;
						u8:send("captureflag", v15.TeamColor.Value);
					end;
				end;
			elseif v15.Name == "DogTag" and v1.canCapture(v15.Base.Position, 6) and u7 < v9 then
				u7 = u7 + 1;
				u8:send("capturedogtag", v15);
			end;
		end;	
	end;
	local l__AGMP__16 = l__Map__4:FindFirstChild("AGMP");
	if not l__AGMP__16 then
		return;
	end;
	local l__next__17 = next;
	local v18, v19 = l__AGMP__16:GetChildren();
	while true do
		local v20, v21 = l__next__17(v18, v19);
		if not v20 then
			break;
		end;
		v19 = v20;
		if v21:FindFirstChild("IsCapping") and v21.IsCapping.Value and v21.TeamColor.Value ~= l__LocalPlayer__6.TeamColor and v10 and v1.canCapture(v21.Base.Position, 15) then
			v1.updateCappingStatus(v21, v21.CapPoint.Value);
		end;	
	end;
end;
local u9 = shared.require("HeartbeatRunner");
function v1._init()
	u1 = shared.require("CharacterInterface");
	shared.require("CharacterEvents").onDespawned:connect(function()
		l__DisplayCapturing__3.Visible = false;
		v1.updateInteraction("");
	end);
	local u10 = nil;
	v3.getScreenGui():GetPropertyChangedSignal("Enabled"):Connect(function()
		if not v3.isEnabled() then
			if u10 then
				u10();
			end;
			return;
		end;
		if u10 then
			u10();
		end;
		u10 = u9:addTask("HudInteractionInterface", v1.step, {});
	end);
end;
return v1;

