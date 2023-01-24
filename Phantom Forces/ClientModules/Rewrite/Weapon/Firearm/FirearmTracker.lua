
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("PlayerStatusInterface");
local v3 = shared.require("HudScreenGui");
local v4 = v3.getScreenGui();
local u1 = shared.require("Destructor");
local l__ContainerActive__2 = v4.Main.ContainerActive;
function v1.new(p1)
	local v5 = setmetatable({}, v1);
	v5._destructor = u1.new();
	v5._firearmObject = p1;
	v5._size = 0.009259259259259259;
	local v6 = v3.getUIScale();
	v5._dot = Instance.new("Frame");
	v5._dot.Size = UDim2.new(v5._size * v6, 0, v5._size * v6, 0);
	v5._dot.BackgroundColor3 = Color3.new(1, 1, 0.7);
	v5._dot.SizeConstraint = "RelativeYY";
	v5._dot.BorderSizePixel = 0;
	v5._dot.Rotation = 45;
	v5._dot.Parent = l__ContainerActive__2;
	v5._destructor:add(v5._dot);
	return v5;
end;
function v1.Destroy(p2)
	p2._destructor:Destroy();
end;
local u3 = shared.require("CameraInterface");
local u4 = shared.require("CharacterInterface");
local u5 = shared.require("vector");
local u6 = shared.require("ReplicationInterface");
local l__LocalPlayer__7 = game:GetService("Players").LocalPlayer;
local u8 = shared.require("GameRoundInterface");
local u9 = shared.require("physics");
local u10 = shared.require("PublicSettings");
local l__CurrentCamera__11 = workspace.CurrentCamera;
function v1.step(p3)
	local v7 = u3.getActiveCamera("MainCamera");
	if not p3._firearmObject:isAiming() then
		p3._dot.BackgroundTransparency = 1;
		return;
	end;
	local v8 = u4.getCharacterObject();
	if not v8 or v8:getSpring("aimspring").p < 0.95 then
		p3._dot.BackgroundTransparency = 1;
		return;
	end;
	local v9 = game:GetService("Players"):GetPlayers();
	local v10 = v7:getAngles();
	local v11 = u5.anglesyx(v10.x, v10.y);
	local v12 = p3._size / 2 * v4.AbsoluteSize.y;
	local v13 = v3.getUIScale();
	local u12 = 0.995;
	local u13 = nil;
	u6.operateOnAllEntries(function(p4, p5)
		if p4.TeamColor ~= l__LocalPlayer__7.TeamColor and p5:isAlive() then
			local l__p__14 = v7:getCFrame().p;
			local v15, v16 = u6.getEntry(p4):getPosition();
			if v16 and not workspace:FindPartOnRayWithWhitelist(Ray.new(l__p__14, v16 - l__p__14), u8.raycastWhiteList) then
				local v17 = u9.trajectory(l__p__14, u10.bulletAcceleration, v16, p3._firearmObject:getWeaponStat("bulletspeed"));
				if v17 then
					local v18 = v17.unit:Dot(v11);
					if u12 < v18 then
						u12 = v18;
						u13 = l__CurrentCamera__11:WorldToViewportPoint(l__p__14 + v17);
					end;
				end;
			end;
		end;
	end);
	if u13 then
		p3._dot.BackgroundTransparency = 0;
		p3._dot.Position = UDim2.new(0, u13.x / v13 - v12, 0, u13.y / v13 - v12);
		p3._dot.Size = UDim2.new(p3._size * v13, 0, p3._size * v13, 0);
	else
		p3._dot.BackgroundTransparency = 1;
	end;
end;
return v1;

