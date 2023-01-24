
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("HudScopeInterface");
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._firearmObject = p1;
	v2._sightData = p2;
	v2._sightPart = p2.sightpart;
	v2._dotPart = v2._sightPart:Clone();
	v2._dotPart.Anchored = true;
	v2._dotPart:ClearAllChildren();
	v2._dotPart.Name = "SightMark" .. math.random(1, 99);
	v2._destructor:add(v2._dotPart);
	local l__SurfaceGui__3 = v2._sightPart:FindFirstChild("SurfaceGui");
	if l__SurfaceGui__3 and l__SurfaceGui__3:FindFirstChild("Border") and l__SurfaceGui__3.Border:FindFirstChild("Scope") then
		v2._reticle = l__SurfaceGui__3.Border.Scope;
		v2._border = l__SurfaceGui__3.Border;
		v2._surfaceGui = l__SurfaceGui__3;
		v2._reticle.AnchorPoint = Vector2.new(0.5, 0.5);
		v2._border.AnchorPoint = Vector2.new(0.5, 0.5);
	end;
	v2._sightR = p2.sightr and 0.2;
	v2._reticleScale = v2._reticle and Vector2.new(v2._reticle.Size.X.Scale, v2._reticle.Size.Y.Scale) or Vector2.new(1, 1);
	v2._initialSize = (p2.sightsize or (p2.aimzdist and 1) + (p2.sightr and 0.2)) * v2._reticleScale;
	v2._focalDist = p2.focaldist;
	v2._blackScope = p2.blackscope;
	v2._sightRadius = p2.scopesize;
	v2._destructor:add(function()
		u2.setScope(false);
	end);
	return v2;
end;
function v1.Destroy(p3)
	p3._destructor:Destroy();
end;
local l__CurrentCamera__3 = workspace.CurrentCamera;
local u4 = math.pi / 180;
function v1.step(p4)
	local l___sightPart__4 = p4._sightPart;
	local l___dotPart__5 = p4._dotPart;
	l___dotPart__5.Parent = workspace.Ignore;
	l___dotPart__5.CFrame = CFrame.new(l___sightPart__4.CFrame.p + l___sightPart__4.CFrame.lookVector * 500);
	local l__CFrame__6 = l__CurrentCamera__3.CFrame;
	local l__Size__7 = l___sightPart__4.Size;
	local v8 = l___sightPart__4.CFrame * CFrame.new(0, 0, 0.5 * l__Size__7.z);
	if p4._blackScope then
		if p4._firearmObject:isBlackScope() and p4._firearmObject:isAiming() then
			local l__ViewportSize__9 = l__CurrentCamera__3.ViewportSize;
			local v10 = 2 * math.tan(l__CurrentCamera__3.FieldOfView * u4 / 2);
			local v11 = l__ViewportSize__9.x / 2;
			local v12 = l__ViewportSize__9.y / 2;
			local v13 = p4._sightRadius and 0.17;
			local v14 = l__CFrame__6:pointToObjectSpace(v8.p);
			local v15 = l__CFrame__6:vectorToObjectSpace(v8.lookVector);
			local v16 = l__CFrame__6:pointToObjectSpace(v8 * Vector3.new(0, 0, -(p4._focalDist and 0.2)));
			local v17 = -v14.z;
			local v18 = -v15.z;
			local v19 = -v16.z;
			u2.updateScope(UDim2.new(v14.x / (v10 * v17), v11, -v14.y / (v10 * v17), v12), UDim2.new(v15.x / (v10 * v18), v11, -v15.y / (v10 * v18), v12), UDim2.new(v13 / (v10 * v17), 0, v13 / (v10 * v17), 0), (UDim2.new(v13 / (v10 * v19), 0, v13 / (v10 * v19), 0)));
			return;
		end;
	elseif p4._reticle and p4._surfaceGui then
		local v20 = v8:pointToObjectSpace(l__CFrame__6.p);
		local l__z__21 = v20.z;
		local v22 = p4._focalDist and 0.2;
		p4._border.Position = UDim2.new(0.5, 0, 0.5, 0);
		p4._reticle.Position = UDim2.new(0.5 + v20.x / l__Size__7.x, 0, 0.5 - v20.y / l__Size__7.y, 0);
		p4._reticle.Size = UDim2.new(l__z__21 / (l__z__21 + v22) * p4._initialSize.x, 0, l__z__21 / (l__z__21 + v22) * p4._initialSize.y, 0);
	end;
end;
return v1;

