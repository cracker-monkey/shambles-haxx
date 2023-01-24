
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._firearmObject = p1;
	v2._laserPart = p2;
	v2._dotPart = script.LaserDot:Clone();
	v2._destructor:add(v2._dotPart);
	v2._billboardGui = Instance.new("BillboardGui");
	v2._billboardGui.Size = UDim2.new(50, 0, 50, 0);
	v2._billboardGui.AlwaysOnTop = false;
	v2._billboardGui.Parent = v2._dotPart;
	v2._dotGui = script.LaserDot.SurfaceGui.ImageLabel:Clone();
	v2._dotGui.Parent = v2._billboardGui;
	v2._dotGui.ImageColor3 = v2._laserPart.BrickColor.Color;
	v2._dotGui.Visible = true;
	return v2;
end;
function v1.Destroy(p3)
	p3._destructor:Destroy();
end;
local l__CurrentCamera__2 = workspace.CurrentCamera;
local u3 = workspace.FindPartOnRayWithIgnoreList;
function v1.step(p4)
	local l___dotPart__3 = p4._dotPart;
	local v4 = 3;
	local v5 = nil;
	local v6 = nil;
	local v7 = nil;
	local v8 = p4._laserPart.CFrame.p;
	local v9 = { l__CurrentCamera__2, l___dotPart__3 };
	while not v5 and v4 > 0 do
		local v10, v11 = u3(workspace, Ray.new(v8, p4._laserPart.CFrame.upVector * 999), v9);
		if v10 then
			if v10.Transparency == 0 then
				v6 = v10;
				v7 = v11;
				v5 = true;
			else
				v8 = v11;
				v9[#v9 + 1] = v10;
				v4 = v4 - 1;
			end;
		else
			v4 = 0;
		end;	
	end;
	if not v6 then
		l___dotPart__3.Parent = nil;
		p4._laserPart.Bar.Scale = Vector3.new(0.02, 1000, 0.02);
		p4._laserPart.Bar.Offset = Vector3.new(0, 100, 0);
		return;
	end;
	local l__Magnitude__12 = (v7 - p4._laserPart.Position).Magnitude;
	l___dotPart__3.Parent = p4._firearmObject:getWeaponModel();
	l___dotPart__3.CFrame = CFrame.new(v7);
	p4._laserPart.Bar.Scale = Vector3.new(0.02, l__Magnitude__12 * 5, 0.02);
	p4._laserPart.Bar.Offset = Vector3.new(0, l__Magnitude__12 / 2, 0);
end;
return v1;

