
-- Decompiled with the Synapse X Luau decompiler.

return {
	new = function(p1, p2, p3, p4, p5)
		if p5 then
			warn("RecoilLayer: Did you add an extra comma?");
			warn(debug.traceback());
		end;
		return { p1 and 1, p2 and 1, p3 and 0, p4 and 0 };
	end
};

