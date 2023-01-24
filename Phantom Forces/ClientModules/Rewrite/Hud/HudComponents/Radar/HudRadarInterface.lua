
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PlayerSettingsInterface");
local v3 = shared.require("ReplicationInterface");
local v4 = shared.require("HudSpottingInterface");
local v5 = shared.require("PlayerSettingsEvents");
local v6 = shared.require("RenderSteppedRunner");
local v7 = shared.require("HeartbeatRunner");
local v8 = shared.require("HudRadarArrow");
local v9 = shared.require("HudScreenGui");
local l__LocalPlayer__10 = game:GetService("Players").LocalPlayer;
local l__DisplayRadar__11 = v9.getScreenGui().Main.DisplayRadarScore.DisplayRadar;
local l__Container__12 = l__DisplayRadar__11.Container;
local v13 = v8.new(l__LocalPlayer__10, l__Container__12);
v13.guiObject.ImageDeadCross.Visible = false;
v13.guiObject.ImageArrowHollow.Visible = false;
v13.guiObject.Size = UDim2.fromOffset(16, 16);
v13.guiObject.Position = UDim2.fromScale(0.5, 0.5);
local u1 = nil;
local u2 = shared.require("HudRadarConfig");
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = 1;
function v1.setRelHeight(p1)
	if u6 == 0 then
		local v14 = 1;
	else
		v14 = 0;
	end;
	u6 = v14;
end;
local u7 = false;
function v1.setMinimapStyle(p2)
	u7 = not u7;
end;
local l__Map__8 = workspace.Map;
local u9 = shared.require("GameRoundInterface");
local u10 = nil;
local u11 = {};
local u12 = shared.require("HudRadarProp");
local l__ViewportMinimap__13 = l__DisplayRadar__11.ViewportMinimap;
local u14 = nil;
local l__MiniMapModels__15 = game.ReplicatedStorage:WaitForChild("MiniMapModels");
function v1.setMapModel()
	if not l__Map__8 then
		warn("HudRadarInterface: No mapModel found");
		return;
	end;
	local v15 = u9.getMapName();
	u1 = l__Map__8.PrimaryPart;
	u10 = l__Map__8:FindFirstChild("AGMP");
	for v16, v17 in next, u11 do
		v17:Destroy();
		u11[v16] = nil;
	end;
	if u10 then
		local l__next__18 = next;
		local v19, v20 = u10:GetChildren();
		while true do
			local v21, v22 = l__next__18(v19, v20);
			if not v21 then
				break;
			end;
			v20 = v21;
			u11[v22] = u12.new(v22, l__Container__12);		
		end;
	end;
	u4 = l__ViewportMinimap__13:FindFirstChild("Camera") or Instance.new("Camera");
	u4.FieldOfView = u2.fov;
	l__ViewportMinimap__13.CurrentCamera = u4;
	u4.Parent = l__ViewportMinimap__13;
	if u14 and u14.Name == v15 then
		return;
	end;
	if u14 then
		u14:Destroy();
	end;
	local v23 = l__MiniMapModels__15:FindFirstChild(v15);
	if v23 then
		u14 = v23:Clone();
		u14.Parent = l__ViewportMinimap__13;
		u3 = u14.PrimaryPart;
		return;
	end;
	u14 = l__MiniMapModels__15.Temp:Clone();
	u14.Parent = l__ViewportMinimap__13;
	u3 = u14.PrimaryPart;
end;
local u16 = shared.require("PlayerStatusInterface");
local u17 = shared.require("GameClock");
local u18 = {};
local u19 = {};
local u20 = shared.require("HudRadarRing");
function v1.fireShot(p3, p4, p5, p6)
	if not u16.isPlayerAlive(p3) then
		return;
	end;
	local v24 = u17.getTime();
	if not u18[p3] then
		u18[p3] = v8.new(p3, l__Container__12);
		warn("HudRadarInterface: No arrowObject found for shooter", p3);
	end;
	local v25 = u18[p3];
	if not p4 and not u16.isFriendly(p3) then
		v25.shotTime = v24;
		v25.lifeTime = 5;
	end;
	if not u19[p3] then
		u19[p3] = u20.new(p3, l__Container__12);
		warn("HudRadarInterface: No ringObject found for shooter", p3);
	end;
	local v26 = u19[p3];
	v26.shotCFrame = p6;
	v26.lifeTime = p5.pinglife and 0.5;
	v26.size0 = p5.size0 or v26.size0;
	v26.size1 = p5.size1 or v26.size1;
	if v26.shotTime + v26.lifeTime < v24 then
		v26.shotTime = v24;
	end;
end;
local l__CurrentCamera__21 = workspace.CurrentCamera;
local u22 = shared.require("CameraInterface");
local u23 = shared.require("CharacterInterface");
local u24 = 0;
local u25 = math.pi / 180;
local function u26(p7)
	local v27, v28 = u4:WorldToViewportPoint((u1.CFrame:inverse() * p7).p * u2.scale + u3.Position);
	local v29 = v27.X;
	local v30 = v27.Y;
	local v31 = 0.5 - v30;
	local v32 = math.atan((v29 - 0.5) / v31) * 180 / math.pi;
	if v31 < 0 then
		v32 = v32 - 180;
	end;
	if v29 > 1 then
		v29 = 1;
	end;
	if v29 < 0 then
		v29 = 0;
	end;
	if v30 > 1 then
		v30 = 1;
	end;
	if v30 < 0 then
		v30 = 0;
	end;
	return v29, v30, math.abs(p7.p.Y - u5.CFrame.p.Y), v28, v32;
end;
function v1.step()
	local v33 = nil;
	local v34 = nil;
	local v35 = u17.getTime();
	u5 = l__CurrentCamera__21;
	local v36 = u22.isCameraType("SpectateCamera");
	if v36 then
		u5 = u22.getActiveCamera("SpectateCamera"):getSpectatePart();
	end;
	if u23.isAlive() then
		v13:show();
		v13:setColor(u2.colors.lightBlue);
	else
		if v36 then
			v13:show();
		else
			v13:hide();
		end;
		v13:setColor(u2.colors.red);
	end;
	local v37 = (u1.CFrame:inverse() * u5.CFrame).p * u2.scale * Vector3.new(1, u6, 1);
	local v38, v39, v40 = l__CurrentCamera__21.CFrame:ToOrientation();
	u24 = v39 * 180 / math.pi;
	v34 = u1.Orientation.Y - u24;
	v33 = v37 + u3.Position;
	if u7 then
		u4.CFrame = CFrame.new(v33 + Vector3.new(0, u2.height, 0)) * CFrame.Angles(-90 * u25, 0, 0);
		v13.Rotation = v34;
	else
		u4.CFrame = CFrame.new(v33 + Vector3.new(0, u2.height, 0)) * CFrame.Angles(0, -v34 * u25, 0) * CFrame.Angles(-90 * u25, 0, 0);
		v13.Rotation = 0;
	end;
	for v41, v42 in next, u18 do
		if not v41.Parent then
			v42:Destroy();
			u18[v41] = nil;
		else
			local v43 = nil;
			if v41 == l__LocalPlayer__10 then
				local v44 = u23.isAlive();
				if v44 then
					v43 = u23.getCharacterObject():getRootPart().CFrame;
				end;
			else
				v44 = u16.isPlayerAlive(v41);
				if v44 then
					local v45 = v3.getEntry(v41);
					local v46 = v45:getLookAngles();
					v43 = CFrame.new((v45:getPosition())) * CFrame.Angles(v46.x, v46.y, 0);
				end;
			end;
			local v47 = 0;
			local v48 = false;
			if v44 then
				v42.lastCFrame = v43;
				v42.lastAliveTime = v35;
				if u16.isFriendly(v41) or v4.isSpotted(v41) and v4.isInSight(v41) then
					v48 = true;
				else
					local v49 = (v35 - v42.shotTime) / v42.lifeTime;
					v47 = math.min(v49 > 0.1 and v49 ^ 0.5 or 0, 1);
					if v42.shotTime + v42.lifeTime - v35 > 0 and v47 < 1 then
						v48 = true;
					end;
				end;
			else
				local v50 = (v35 - v42.lastAliveTime) / 5;
				v47 = math.min(v50 > 0.1 and v50 ^ 0.5 or 0, 1);
				if v47 < 1 then
					v48 = true;
				end;
			end;
			local l__guiObject__51 = v42.guiObject;
			if v48 then
				local v52, v53, v54, v55, v56 = u26(v42.lastCFrame);
				if v44 then
					local v57 = l__guiObject__51.ImageArrowHollow;
					l__guiObject__51.ImageArrowHollow.Visible = true;
					l__guiObject__51.ImageDeadCross.Visible = false;
					l__guiObject__51.ImageArrowSolid.Visible = true;
					l__guiObject__51.ImageArrowSolid.ImageTransparency = v47;
				else
					v57 = l__guiObject__51.ImageDeadCross;
					l__guiObject__51.ImageArrowSolid.Visible = false;
					l__guiObject__51.ImageArrowHollow.Visible = false;
					l__guiObject__51.ImageDeadCross.Visible = true;
				end;
				local v58, v59, v60 = v42.lastCFrame:ToOrientation();
				local v61 = u24;
				if u7 then
					v61 = u1.Orientation.Y;
				end;
				if v55 then
					l__guiObject__51.Rotation = v61 - v59 * 180 / math.pi;
					v57.ImageTransparency = v47 and 0.002 * v54 ^ 2.5;
				else
					l__guiObject__51.Rotation = v56;
					v57.ImageTransparency = v47 and 0;
				end;
				l__guiObject__51.Position = UDim2.new(v52, 0, v53, 0);
			end;
			l__guiObject__51.Visible = v48;
		end;
	end;
	local l__next__62 = next;
	local v63 = nil;
	while true do
		local v64 = nil;
		local v65 = nil;
		v65, v64 = l__next__62(u19, v63);
		if not v65 then
			break;
		end;
		v63 = v65;
		if not v65.Parent then
			v64:Destroy();
			u19[v65] = nil;
		else
			local v66 = nil;
			v66 = v64.guiObject;
			if v64.shotTime + v64.lifeTime - v35 > 0 then
				local v67, v68, v69, v70 = u26(v64.shotCFrame);
				local v71 = (v35 - v64.shotTime) / v64.lifeTime;
				local l__size0__72 = v64.size0;
				local v73 = l__size0__72 + (v64.size1 - l__size0__72) * v71;
				v66.ImageRing.ImageTransparency = v71;
				v66.Size = UDim2.new(0, v73, 0, v73);
				v66.Position = UDim2.new(v67, 0, v68, 0);
				v66.Visible = true;
			else
				v66.Visible = false;
			end;
		end;	
	end;
	for v74, v75 in next, u11 do
		local v76, v77, v78, v79 = u26(v75.base.CFrame);
		v75.guiObject.Position = UDim2.new(v76, 0, v77, 0);
	end;
end;
function v1._init()
	game:GetService("Players").PlayerAdded:Connect(function(p8)
		u18[p8] = v8.new(p8, l__Container__12);
		u19[p8] = u20.new(p8, l__Container__12);
	end);
	game:GetService("Players").PlayerRemoving:Connect(function(p9)
		local v80 = u18[p9];
		if v80 then
			v80:Destroy();
			u18[p9] = nil;
		end;
		local v81 = u19[p9];
		if v81 then
			v81:Destroy();
			u19[p9] = nil;
		end;
	end);
	local l__next__82 = next;
	local v83, v84 = game:GetService("Players"):GetPlayers();
	while true do
		local v85, v86 = l__next__82(v83, v84);
		if not v85 then
			break;
		end;
		v84 = v85;
		if v86 ~= l__LocalPlayer__10 then
			u18[v86] = v8.new(v86, l__Container__12);
			u19[v86] = u20.new(v86, l__Container__12);
		end;	
	end;
	local u27 = nil;
	local function u28()
		if not v2.getValue("toggleradarhud") then
			return;
		end;
		if u27 then
			u27();
		end;
		u27 = v7:addTask("HudRadarInterface", v1.step, { "ReplicationInterface" });
	end;
	v9.getScreenGui():GetPropertyChangedSignal("Enabled"):Connect(function()
		if v9.isEnabled() then
			l__DisplayRadar__11.Visible = v2.getValue("toggleradarhud");
			u28();
			return;
		end;
		if u27 then
			u27();
		end;
	end);
	u9.onMapChanged:connect(function()
		v1.setMapModel();
	end);
end;
return v1;

