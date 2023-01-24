
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	_rotation = CFrame.new(), 
	rotationChanged = shared.require("Event").new()
};
game:GetService("UserInputService").DeviceRotationChanged:Connect(function(p1, p2)
	local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12 = p2:components();
	u1._rotation = CFrame.new(v1, v2, v3, -v5, v8, -v11, v6, -v9, v12, v4, -v7, v10);
	local v13, v14 = u1._rotation:toObjectSpace(u1._rotation):ToAxisAngle();
	u1.rotationChanged:fire(u1._rotation, v14 * v13);
end);
function u1.getRotation(p3)
	return u1._rotation;
end;
return u1;

