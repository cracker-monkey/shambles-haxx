
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("ragdolltable");
local function u2(p1, p2)
	local v2 = Instance.new("Part");
	v2.CastShadow = false;
	v2.Size = Vector3.new(0.1, 0.1, 0.1);
	v2.Shape = "Ball";
	v2.TopSurface = "Smooth";
	v2.BottomSurface = "Smooth";
	v2.Transparency = 1;
	v2.CanCollide = false;
	v2.Massless = true;
	v2.CollisionGroupId = 3;
	v2.Parent = p1;
	game.Debris:AddItem(v2, 5);
	local v3 = Instance.new("Weld");
	v3.Part0 = p1;
	v3.Part1 = v2;
	v3.C0 = u1[p1.Name].c;
	v3.Parent = v2;
	local v4 = Instance.new("Attachment");
	v4.CFrame = u1[p1.Name].a;
	v4.Parent = p2;
	local v5 = Instance.new("Attachment");
	v5.CFrame = u1[p1.Name].b;
	v5.Parent = p1;
	if u1[p1.Name].d0 then
		v4.Axis = u1[p1.Name].d0;
		v5.Axis = u1[p1.Name].d1;
	end;
	local v6 = Instance.new("BallSocketConstraint");
	v6.Attachment0 = v4;
	v6.Attachment1 = v5;
	v6.Restitution = 0.5;
	v6.LimitsEnabled = true;
	v6.UpperAngle = 70;
	v6.Parent = p2;
end;
local function u3(p3, p4)
	local v7 = Instance.new("Part");
	v7:BreakJoints();
	v7.Shape = "Ball";
	v7.TopSurface = 0;
	v7.BottomSurface = 0;
	v7.formFactor = "Custom";
	v7.Size = Vector3.new(0.25, 0.25, 0.25);
	v7.Transparency = 1;
	v7.CastShadow = false;
	v7.Massless = true;
	v7.CollisionGroupId = 3;
	local v8 = Instance.new("Weld");
	v8.Part0 = p3;
	v8.Part1 = v7;
	v8.C0 = not p4 and CFrame.new(0, -0.5, 0) or p4;
	v8.Parent = v7;
	v7.Parent = p3;
	game.Debris:AddItem(v7, 5);
end;
local l__DeadBody__4 = workspace.Ignore.DeadBody;
local u5 = shared.require("ExplosionForceMesh");
local u6 = shared.require("ExplosionForce");
function v1.createRagdoll(p5, p6, p7, p8, p9)
	p8 = p8 or Vector3.zero;
	p9 = p9 and 20;
	local l__Torso__9 = p5:FindFirstChild("Torso");
	local l__next__10 = next;
	local v11, v12 = l__Torso__9:GetChildren();
	while true do
		local v13, v14 = l__next__10(v11, v12);
		if not v13 then
			break;
		end;
		v12 = v13;
		if v14:IsA("Motor6D") and v14.Name ~= "Neck" then
			v14:Destroy();
		end;	
	end;
	local v15 = nil;
	for v16, v17 in p5() do
		if v17:IsA("BasePart") and v17.Transparency == 0 then
			v17.TopSurface = 0;
			v17.BottomSurface = 0;
			v17.CastShadow = false;
			v17.Anchored = false;
			v17.CanCollide = true;
			v17.CanTouch = false;
			v17.CanQuery = false;
			v17.CollisionGroupId = 3;
			if v17.Name == p6 then
				v15 = v17;
			end;
		end;
	end;
	for v18 in u1, nil do
		local v19 = p5:FindFirstChild(v18);
		if v19 then
			u2(v19, l__Torso__9);
		end;
	end;
	u3(l__Torso__9, CFrame.new(0, 0.5, 0));
	p5.Name = "Dead";
	p5.Parent = l__DeadBody__4;
	if p7 then
		for v20, v21 in p5() do
			if v21:IsA("BasePart") and u5[v21.Name] then
				v21:ApplyImpulseAtPosition(u6.computeMeshExplosionForce(p7, v21.CFrame, v21.Size, u5[v21.Name]) * 300, p7);
			end;
		end;
	elseif v15 then
		v15:ApplyImpulseAtPosition(p8 * p9, v15.Position);
	end;
	local v22 = {};
	for v23, v24 in p5() do
		if v24:IsA("BasePart") or v24:IsA("Decal") then
			table.insert(v22, v24);
		end;
	end;
	task.delay(5, function()
		for v25, v26 in v22, nil do
			if v26:IsA("BasePart") then
				v26.Anchored = true;
			end;
		end;
	end);
	task.delay(30, function()
		for v27 = 1, 20 do
			for v28, v29 in v22, nil do
				v29.Transparency = v27 / 20;
			end;
			task.wait(0.016666666666666666);
		end;
		p5:Destroy();
	end);
end;
return v1;

