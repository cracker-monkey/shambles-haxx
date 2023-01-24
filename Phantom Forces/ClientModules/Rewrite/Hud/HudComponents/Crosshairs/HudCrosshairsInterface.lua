
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("HudScreenGui");
local v3 = shared.require("spring");
local v4 = v2.getScreenGui();
local l__DisplayCrosshairs__5 = v4.Main.DisplayCrosshairs;
local v6 = v3.new(0);
v6.s = 10;
v6.d = 0.8;
v6.t = 1;
local v7 = v3.new(0);
v7.s = 12;
v7.d = 0.65;
local v8 = v3.new(1);
v8.s = 5;
v8.d = 0.7;
function v1.getCrossSize()
	return v7.p;
end;
function v1.setCrossScale(p1)
	v6.t = p1;
end;
function v1.setCrossSize(p2)
	v7.t = p2;
end;
function v1.setEquipState(p3)
	if p3 then
		v7.s = 18;
		v7.d = 0.8;
		return;
	end;
	v7.t = 0;
	v7.s = 18;
	v7.d = 0.8;
end;
local u1 = { l__DisplayCrosshairs__5.Left, l__DisplayCrosshairs__5.Right, l__DisplayCrosshairs__5.Down, l__DisplayCrosshairs__5.Up, l__DisplayCrosshairs__5.Center };
local u2 = "Cross";
function v1.setCrossHairType(p4)
	for v9 = 1, 4 do
		local l__next__10 = next;
		local v11, v12 = u1[v9]:GetChildren();
		while true do
			local v13, v14 = l__next__10(v11, v12);
			if not v13 then
				break;
			end;
			v12 = v13;
			if v14.Name == p4 then
				v14.Visible = true;
			else
				v14.Visible = false;
			end;		
		end;
	end;
	if p4 == "Dot" then
		u1[5].Visible = true;
	else
		u1[5].Visible = false;
	end;
	u2 = p4;
end;
local u3 = nil;
local u4 = nil;
function v1.setCrossSettings(p5, p6, p7, p8, p9, p10)
	v7.t = p6;
	v7.s = p7;
	v7.d = p8;
	u3 = p10;
	u4 = p9;
	if p5 == "SHOTGUN" then
		v1.setCrossHairType("Shot");
		return;
	end;
	if p5 == "KNIFE" then
		v1.setCrossHairType("Dot");
		return;
	end;
	v1.setCrossHairType("Cross");
end;
function v1.fireImpulse(p11)
	v7.a = p11;
end;
local l__ImageHitmarker__5 = v4.Main.ImageHitmarker;
function v1.fireHitmarker(p12)
	v8.p = -3;
	if p12 then
		l__ImageHitmarker__5.ImageColor3 = Color3.new(1, 0, 0);
		return;
	end;
	l__ImageHitmarker__5.ImageColor3 = Color3.new(1, 1, 1);
end;
function v1.updateSightMark(p13, p14)
	u3 = p14;
	u4 = p13;
end;
function v1.disable()
	l__DisplayCrosshairs__5.Visible = false;
	l__ImageHitmarker__5.Visible = false;
end;
local u6 = shared.require("PlayerSettingsInterface");
function v1.enable()
	l__DisplayCrosshairs__5.Visible = u6.getValue("togglecrosshairs");
	l__ImageHitmarker__5.Visible = u6.getValue("togglehitmarkers");
end;
local u7 = shared.require("CharacterInterface");
local l__CurrentCamera__8 = workspace.CurrentCamera;
function v1.step()
	if not u7.isAlive() then
		return;
	end;
	local v15 = u7.getCharacterObject();
	local v16 = math.round(v7.p * 2 * v6.p * (v15:getSpeed() / 14 * 0.19999999999999996 * 2 + 0.8) * (v15:getSpring("sprintspring").p / 2 + 1));
	if u2 == "Cross" then
		u1[1].BackgroundTransparency = 1 - v16 / 20;
		u1[2].BackgroundTransparency = 1 - v16 / 20;
		u1[3].BackgroundTransparency = 1 - v16 / 20;
		u1[4].BackgroundTransparency = 1 - v16 / 20;
	else
		for v17 = 1, 4 do
			u1[v17].BackgroundTransparency = 1;
			local l__next__18 = next;
			local v19, v20 = u1[v17]:GetChildren();
			while true do
				local v21, v22 = l__next__18(v19, v20);
				if not v21 then
					break;
				end;
				v20 = v21;
				if v22.Name == u2 then
					v22.BackgroundTransparency = 1 - v16 / 20 * (v16 / 20);
				end;			
			end;
		end;
	end;
	u1[1].Position = UDim2.new(0, -v16, 0, 0);
	u1[2].Position = UDim2.new(0, v16, 0, 0);
	u1[3].Position = UDim2.new(0, 0, 0, v16);
	u1[4].Position = UDim2.new(0, 0, 0, -v16);
	local v23 = v2.getUIScale();
	if not u3 and v7.t == 0 and u4 and u4.Parent then
		local v24 = l__CurrentCamera__8:WorldToViewportPoint(u4.Position + u4.CFrame.LookVector * -1000);
		l__ImageHitmarker__5.Position = UDim2.new(0, v24.x / v23, 0, v24.y / v23);
	else
		l__ImageHitmarker__5.Position = UDim2.new(0.5, 0, 0.5, 0);
	end;
	l__ImageHitmarker__5.ImageTransparency = v8.p;
end;
local u9 = shared.require("HudCrosshairsEvents");
local u10 = shared.require("CharacterEvents");
local u11 = shared.require("RenderSteppedRunner");
function v1._init()
	u9.requestCrossScaleUpdate:connect(v1.setCrossScale);
	u10.onDespawned:connect(function()
		v8.p = 1;
		l__ImageHitmarker__5.ImageTransparency = 1;
		v1.disable();
	end);
	local u12 = nil;
	v2.getScreenGui():GetPropertyChangedSignal("Enabled"):Connect(function()
		if not v2.isEnabled() then
			if u12 then
				u12();
			end;
			return;
		end;
		v1.enable();
		if u12 then
			u12();
		end;
		u12 = u11:addTask("HudCrosshairsInterface", v1.step, { "CharacterInterface", "CameraInterface", "WeaponControllerInterface" });
	end);
end;
return v1;

