
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("UnscaledScreenGui");
local v3 = shared.require("MenuScreenGui");
local v4 = shared.require("ModifyData");
local l__Main__5 = shared.require("HudScreenGui").getScreenGui().Main;
local u1 = shared.require("CharacterEvents");
local u2 = shared.require("network");
local l__CurrentCamera__3 = workspace.CurrentCamera;
local l__LocalPlayer__4 = game:GetService("Players").LocalPlayer;
local u5 = shared.require("CameraInterface");
local u6 = shared.require("ReplicationInterface");
local u7 = shared.require("WeaponUtils");
local l__Templates__8 = l__Main__5.Templates;
local u9 = shared.require("PlayerSettingsInterface");
local u10 = shared.require("ContentDatabase");
local u11 = shared.require("PlayerStatusInterface");
function v1._init()
	u1.onSpawned:connect(function()
		local l__DisplayKillCard__6 = l__Main__5:FindFirstChild("DisplayKillCard");
		if l__DisplayKillCard__6 then
			l__DisplayKillCard__6.Visible = false;
		end;
	end);
	u2:add("killed", function(p1, p2, p3)
		local l__CFrame__7 = l__CurrentCamera__3.CFrame;
		if p1 == l__LocalPlayer__4 then
			u5.setCameraType("FixedCamera", l__CFrame__7);
			return;
		end;
		local v8 = u6.getEntry(p1):getWeaponObject(p2);
		if not v8 then
			warn("WeaponObject not found for", p1, p2);
			u2:send("debug", string.format("Missing weapon index for kill card %s %d", p1.Name, p2));
			return;
		end;
		local l__weaponData__9 = v8.weaponData;
		local v10 = u7.constructWeapon(v8.weaponName, l__weaponData__9, v8.attachmentData, v8.camoData);
		if not v10 then
			return;
		end;
		local v11 = l__Templates__8.DisplayKillCard:Clone();
		if u9.getValue("togglestreamermode") then
			v11.DisplayKiller.TextValue.Text = "Player";
		else
			v11.DisplayKiller.TextValue.Text = p1.Name;
		end;
		v11.DisplayWeapon.TextValue.Text = l__weaponData__9.displayname or l__weaponData__9.name;
		v11.DisplayRank.TextValue.Text = p3;
		v11.Parent = l__Main__5;
		for v12, v13 in v10() do
			if v13:IsA("BasePart") and v13.Name == "LaserLight" then
				v13.Material = "SmoothPlastic";
				if v13:FindFirstChild("Bar") then
					v13.Bar.Offset = Vector3.new(0, 100, 0);
					v13.Bar.Scale = Vector3.new(0.1, 1, 0.1);
				end;
			end;
		end;
		local u12 = nil;
		u12 = game:GetService("RunService").Stepped:Connect(function()
			v10.Parent = workspace.Ignore;
			u12:Disconnect();
		end);
		local u13 = nil;
		u13 = game:GetService("RunService").Heartbeat:Connect(function()
			local v14 = v10.MenuNodes:FindFirstChild("ViewportNode") or v10.MenuNodes.MenuNode;
			v10.PrimaryPart = v14;
			v10:SetPrimaryPartCFrame(CFrame.new(0, 0, 0));
			v10.Parent = v11.ViewportWeapon;
			local v15 = Instance.new("Camera");
			v15.CFrame = CFrame.new(v14.CFrame.p + v14.CFrame.RightVector * -7 + v14.CFrame.lookVector * 4 + v14.CFrame.upVector * 4, v14.CFrame.p + v14.CFrame.lookVector * 1.5);
			v15.FieldOfView = 16;
			v15.Parent = v10;
			v11.ViewportWeapon.CurrentCamera = v15;
			u13:Disconnect();
		end);
		for v16, v17 in v11.DisplayAttachments() do
			v17.TextValue.Text = "None";
		end;
		if v8.attachmentData then
			for v18, v19 in v8.attachmentData, nil do
				if v18 ~= "Name" and v19 ~= "" then
					v11.DisplayAttachments[v18].TextValue.Text = u10.getAttachmentDisplayName(v19, v8.weaponName, v18);
				end;
			end;
		end;
		if u11.isPlayerAlive(p1) then
			u5.setCameraType("SpectateCamera", {
				player = p1
			});
		else
			u5.setCameraType("FixedCamera", l__CFrame__7);
		end;
		local u14 = game:GetService("RunService").Heartbeat:Connect(function()
			local v20 = math.ceil(u11.getPlayerHealth(p1));
			v11.DisplayHealth.TextValue.Text = v20;
			v11.DisplayHealth.TextValue.TextColor3 = v20 < 20 and Color3.new(1, 0, 0) or (v20 < 50 and Color3.new(1, 1, 0) or Color3.new(0, 1, 0));
		end);
		task.delay(5, function()
			v11:Destroy();
			u14:Disconnect();
		end);
	end);
end;
return v1;

