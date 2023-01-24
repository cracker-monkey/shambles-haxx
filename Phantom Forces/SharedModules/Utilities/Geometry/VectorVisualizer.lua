
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local l__NormalPointer__1 = script:WaitForChild("NormalPointer");
function v1.newSurfacePoint()
	local v2 = l__NormalPointer__1:Clone();
	v2.Parent = workspace.Terrain;
	game:GetService("CollectionService"):AddTag(v2, "HoverColliderIgnore");
	local v3 = {};
	function v3.move(p1, p2, p3)
		v2.CFrame = CFrame.new(p2, p2 + p3);
	end;
	function v3.setColor(p4, p5)
		v2.Color = p5;
		v2.ConeHandleAdornment.Color3 = p5;
		v2.SphereHandleAdornment.Color3 = p5;
	end;
	function v3.destroy(p6)
		v2:Destroy();
	end;
	return v3;
end;
function v1.drawSurfacePoint(p7, p8, p9, p10, p11, p12)
	local v4 = l__NormalPointer__1:Clone();
	v4.CFrame = CFrame.new(p8, p8 + p9);
	game:GetService("CollectionService"):AddTag(v4, "HoverColliderIgnore");
	if p7 then
		local v5 = Instance.new("WeldConstraint");
		v5.Part0 = p7;
		v5.Part1 = v4;
		v5.Parent = v4;
		v4.Anchored = false;
	else
		v4.Anchored = true;
	end;
	v4.CanCollide = false;
	v4.BrickColor = p11;
	v4.ConeHandleAdornment.Color3 = p11.Color;
	v4.ConeHandleAdornment.SizeRelativeOffset = p12 or Vector3.new(0, 0, 0);
	v4.SphereHandleAdornment.Color3 = p11.Color;
	v4.Parent = workspace.Terrain;
	game.Debris:AddItem(v4, p10 and 30);
end;
local l__Point__2 = script:WaitForChild("Point");
function v1.drawPoint(p13, p14, p15, p16, p17)
	local v6 = l__Point__2:Clone();
	v6.CFrame = CFrame.new(p14);
	if p13 then
		local v7 = Instance.new("WeldConstraint");
		v7.Part0 = p13;
		v7.Part1 = v6;
		v7.Parent = v6;
		v6.Anchored = false;
	else
		v6.Anchored = true;
	end;
	v6.CanCollide = false;
	v6.BrickColor = p16;
	v6.SphereHandleAdornment.Color3 = p16.Color;
	v6.SphereHandleAdornment.Radius = p17 or v6.SphereHandleAdornment.Radius;
	v6.Parent = workspace.Terrain;
	game.Debris:AddItem(v6, p15 and 30);
end;
return v1;

