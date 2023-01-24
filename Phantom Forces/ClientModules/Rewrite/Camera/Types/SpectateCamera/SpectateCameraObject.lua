
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("CameraUtils");
local u1 = shared.require("Destructor");
local u2 = shared.require("spring");
local u3 = shared.require("effects");
function v1.new(p1)
	local v3 = setmetatable({}, v1);
	v3._destructor = u1.new();
	v3._currentCamera = workspace.CurrentCamera;
	v3._baseFov = 80;
	v3._cframe = CFrame.new();
	v3._angles = Vector3.zero;
	v3._lookVector = Vector3.new(0, 0, -1);
	v3._spectateType = "thirdperson";
	v3._spectatePart = nil;
	v3._spectatePlayer = nil;
	v3._spectateReplicationObject = nil;
	v3._forceSpectating = false;
	v3._followSpring = u2.new(Vector3.zero);
	v3._followSpring.s = 16;
	v3._followSpring.d = 0.75;
	if p1 then
		if p1.player then
			print("spectating", p1.player);
			v3:setSpectate(p1.player, p1.force);
		end;
		v3._fallbackCFrame = p1.fallbackCFrame;
	end;
	u3:setuplighting(true);
	return v3;
end;
function v1.Destroy(p2)
	p2._destructor:Destroy();
end;
function v1.getSpectatePart(p3)
	return p3._spectatePart;
end;
function v1.getSpectatePlayer(p4)
	return p4._spectatePlayer;
end;
local u4 = shared.require("ReplicationInterface");
function v1.setSpectate(p5, p6, p7)
	local v4 = u4.getEntry(p6);
	if not v4 then
		return;
	end;
	local v5 = v4:getThirdPersonObject();
	if not v5 then
		return;
	end;
	p5._cameratype = "spectate";
	p5._spectatePlayer = p6;
	p5._spectateReplicationObject = v4;
	p5._spectatePart = v5:getBodyPart("head");
	local v6 = p5._spectatePart.CFrame * Vector3.new(1, 1, 6.5);
	p5._followSpring.t = v6;
	p5._followSpring.p = v6;
	p5._followSpring.v = Vector3.zero;
	p5._forceSpectating = p7 and false;
end;
local l__LocalPlayer__5 = game:GetService("Players").LocalPlayer;
local u6 = shared.require("PlayerStatusInterface");
local u7 = shared.require("vector");
local l__math_pi__8 = math.pi;
local u9 = shared.require("CameraSweep");
local u10 = shared.require("CameraEvents");
function v1.step(p8)
	local v7 = p8._spectatePlayer;
	if v7 then
		v7 = p8._spectateReplicationObject;
		if v7 then
			v7 = false;
			if p8._spectatePlayer ~= l__LocalPlayer__5 then
				v7 = p8._spectatePart and u6.isPlayerAlive(p8._spectatePlayer);
			end;
		end;
	end;
	if v7 then
		if p8._spectateReplicationObject then
			p8._spectateReplicationObject:step(3, true);
		end;
		local l__CFrame__8 = p8._spectatePart.CFrame;
		local l__p__9 = l__CFrame__8.p;
		local l__x__10 = l__p__9.x;
		local v11 = true;
		if l__x__10 == l__x__10 then
			v11 = true;
			if l__x__10 ~= (1 / 0) then
				v11 = l__x__10 == (-1 / 0);
			end;
		end;
		if not v11 then
			local l__y__12 = l__p__9.y;
			local v13 = true;
			if l__y__12 == l__y__12 then
				v13 = true;
				if l__y__12 ~= (1 / 0) then
					v13 = l__y__12 == (-1 / 0);
				end;
			end;
			if not v13 then
				local l__z__14 = l__p__9.z;
				local v15 = true;
				if l__z__14 == l__z__14 then
					v15 = true;
					if l__z__14 ~= (1 / 0) then
						v15 = l__z__14 == (-1 / 0);
					end;
				end;
				if v15 then
					return;
				elseif p8._spectateType == "thirdperson" then
					local v16, v17 = u7.toanglesyx(l__CFrame__8.lookVector);
					local v18 = CFrame.Angles(0, v17, 0) * CFrame.Angles(v16, 0, 0) + p8._followSpring.p;
					if v18.RightVector:Dot(l__CFrame__8.RightVector) < 0 then
						v18 = v18 * CFrame.Angles(0, 0, l__math_pi__8);
					end;
					local v19 = v18 * CFrame.new(1, 1, 0);
					p8._followSpring.t = l__p__9;
					local v20 = v19 * Vector3.new(0, 0, 6.5) - v19.Position;
					p8._cframe = v19 + u9.sweep(p8._currentCamera, v19, v20, { p8._spectatePart, workspace.Terrain, workspace.Ignore }) * v20;
					p8._lookVector = p8._cframe.lookVector;
					p8._currentCamera.CFrame = p8._cframe;
				elseif p8._spectateType == "firstperson" then
					local v21, v22 = u7.toanglesyx(l__CFrame__8.lookVector);
					local v23 = CFrame.Angles(0, v22, 0) * CFrame.Angles(v21, 0, 0) + l__p__9;
					p8._currentCamera.CFrame = v23;
					p8._cframe = v23;
					p8._lookVector = v23.lookVector;
				end;
			else
				return;
			end;
		else
			return;
		end;
	elseif not p8._forceSpectating and not u6.isPlayerAlive(p8._spectatePlayer) then
		p8._spectateReplicationObject = nil;
		p8._spectatePlayer = nil;
		p8._spectatePart = nil;
		u10.onCameraTypeChangeForced:fire("FixedCamera", p8._fallbackCFrame or p8._cframe);
	end;
	p8._currentCamera.FieldOfView = p8._baseFov;
end;
return v1;

