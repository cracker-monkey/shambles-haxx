
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("GameRoundInterface");
if game:GetService("GuiService"):IsTenFootInterface() then
	local v3 = -36;
else
	v3 = 0;
end;
local u1 = shared.require("Destructor");
local l__PlayerTag__2 = game.ReplicatedStorage.Character.PlayerTag;
local l__ContainerNameTag__3 = shared.require("UnscaledScreenGui").getScreenGui().ContainerNameTag;
local l__LocalPlayer__4 = game:GetService("Players").LocalPlayer;
function v1.new(p1)
	local v4 = setmetatable({}, v1);
	v4._destructor = u1.new();
	v4._player = p1;
	v4._guiObject = l__PlayerTag__2:Clone();
	v4._guiObject.Text = p1.Name;
	v4._guiObject.Visible = false;
	v4._guiObject.Dot.BackgroundTransparency = 1;
	v4._guiObject.TextTransparency = 1;
	v4._guiObject.TextStrokeTransparency = 1;
	v4._guiObject.Parent = l__ContainerNameTag__3;
	v4._destructor:add(v4._guiObject);
	v4._displayHealth = v4._guiObject.Health;
	v4._displayDot = v4._guiObject.Dot;
	v4._destructor:add(v4._player:GetPropertyChangedSignal("TeamColor"):Connect(function()
		v4:updateTeam();
	end));
	v4._destructor:add(l__LocalPlayer__4:GetPropertyChangedSignal("TeamColor"):Connect(function()
		v4:updateTeam();
	end));
	v4:updateTeam();
	return v4;
end;
function v1.Destroy(p2)
	p2._destructor:Destroy();
end;
function v1.updateTeam(p3)
	if p3._player.TeamColor == l__LocalPlayer__4.TeamColor then
		p3._guiObject.Visible = true;
		p3._guiObject.TextColor3 = Color3.new(0, 1, 0.9176470588235294);
		p3._displayDot.BackgroundTransparency = 1;
		p3._displayDot.BackgroundColor3 = Color3.new(0, 1, 0.9176470588235294);
		p3._displayDot.Rotation = 90;
		p3._displayDot.Size = UDim2.new(0, 6, 0, 6);
		p3._displayHealth.Visible = false;
		return;
	end;
	p3._guiObject.Visible = false;
	p3._guiObject.TextColor3 = Color3.new(1, 0.0392156862745098, 0.0784313725490196);
	p3._displayDot.BackgroundTransparency = 1;
	p3._displayDot.BackgroundColor3 = Color3.new(1, 0.0392156862745098, 0.0784313725490196);
	p3._displayDot.Rotation = 45;
	p3._displayDot.Size = UDim2.new(0, 4, 0, 4);
	p3._displayHealth.Visible = false;
end;
local u5 = shared.require("ReplicationInterface");
local u6 = shared.require("ScreenCull");
local l__CurrentCamera__7 = workspace.CurrentCamera;
local u8 = shared.require("PlayerSettingsInterface");
local u9 = shared.require("HudSpottingInterface");
local u10 = shared.require("OcclusionCheck").new();
function v1.step(p4)
	local l___displayHealth__5 = p4._displayHealth;
	local l___displayDot__6 = p4._displayDot;
	local l___guiObject__7 = p4._guiObject;
	local v8 = u5.getEntry(p4._player);
	if not v8 or not v8:isReady() then
		return;
	end;
	local v9, v10 = v8:getPosition();
	if u6.sphere(v9, 4) then
		local l__CFrame__11 = l__CurrentCamera__7.CFrame;
		local v12 = l__CurrentCamera__7:WorldToScreenPoint(v10 + l__CFrame__11:VectorToWorldSpace(Vector3.new(0, 0.625, 0)));
		local v13 = l__CurrentCamera__7.CFrame.LookVector:Dot((v9 - l__CFrame__11.Position).unit);
		local v14 = (1 / (v13 * v13) - 1) ^ 0.5 * (v9 - l__CFrame__11.Position).magnitude;
		l___guiObject__7.Position = UDim2.new(0, v12.x - 75, 0, v12.y + v3);
		if u8.getValue("togglestreamermode") then
			l___guiObject__7.Text = "Player";
		else
			l___guiObject__7.Text = p4._player.Name;
		end;
		if p4._player.TeamColor == l__LocalPlayer__4.TeamColor then
			local v15 = nil;
			local v16 = nil;
			l___guiObject__7.Visible = true;
			l___displayHealth__5.Visible = true;
			v15, v16 = v8:getHealth();
			if v14 < 4 then
				l___guiObject__7.TextTransparency = 0.125;
				l___displayHealth__5.BackgroundTransparency = 0.75;
				l___displayHealth__5.Percent.BackgroundTransparency = 0.25;
				l___displayHealth__5.Percent.Size = UDim2.new(v15 / v16, 0, 1, 0);
				l___displayDot__6.BackgroundTransparency = 1;
				return;
			elseif v14 < 8 then
				l___guiObject__7.TextTransparency = 0.125 + 0.875 * (v14 - 4) / 4;
				l___displayHealth__5.BackgroundTransparency = 0.75 + 0.25 * (v14 - 4) / 4;
				l___displayHealth__5.Percent.BackgroundTransparency = 0.25 + 0.75 * (v14 - 4) / 4;
				l___displayHealth__5.Percent.Size = UDim2.new(v15 / v16, 0, 1, 0);
				l___displayDot__6.BackgroundTransparency = 1;
				return;
			else
				l___guiObject__7.TextTransparency = 1;
				l___displayHealth__5.BackgroundTransparency = 1;
				l___displayHealth__5.Percent.BackgroundTransparency = 1;
				l___displayDot__6.BackgroundTransparency = 0.125;
				return;
			end;
		end;
		l___displayDot__6.BackgroundTransparency = 1;
		if u9.isSpotted(p4._player) and u9.isInSight(p4._player) then
			l___guiObject__7.Visible = true;
			if v14 < 4 then
				l___guiObject__7.TextTransparency = 0;
				return;
			else
				l___guiObject__7.TextTransparency = 1;
				l___displayDot__6.BackgroundTransparency = 0;
				return;
			end;
		end;
		if not (not u9.isSpotted(p4._player)) or not (v14 < 4) then
			l___guiObject__7.Visible = false;
			return;
		end;
		local l__p__17 = l__CurrentCamera__7.CFrame.p;
		local v18 = u10:checkOcclusion(l__p__17, v9 - l__p__17);
		l___guiObject__7.Visible = v18;
		if v18 then
			if v14 < 2 then
				l___guiObject__7.TextTransparency = 0.125;
				return;
			end;
			if v14 < 4 then
				l___guiObject__7.TextTransparency = 0.4375 * v14 - 0.75;
				return;
			end;
		end;
	else
		l___guiObject__7.Visible = false;
		l___displayHealth__5.Visible = false;
	end;
end;
return v1;

