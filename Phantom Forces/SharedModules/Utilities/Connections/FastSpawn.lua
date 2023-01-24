
-- Decompiled with the Synapse X Luau decompiler.

return function(p1, ...)
	assert(type(p1) == "function");
	local v1 = Instance.new("BindableEvent");
	local u1 = { ... };
	local u2 = select("#", ...);
	v1.Event:Connect(function()
		p1(unpack(u1, 1, u2));
	end);
	v1:Fire();
	v1:Destroy();
end;

