
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	_hash = {}, 
	disableCollisions = function(p1, p2, p3)
		local l___hash__1 = u1._hash;
		if not l___hash__1[p2] then
			l___hash__1[p2] = {};
		end;
		l___hash__1[p2][p3] = true;
		if not l___hash__1[p3] then
			l___hash__1[p3] = {};
		end;
		l___hash__1[p3][p2] = true;
	end, 
	enableCollisions = function(p4, p5, p6)
		local l___hash__2 = u1._hash;
		if l___hash__2[p5] then
			l___hash__2[p5][p6] = nil;
			if not next(l___hash__2[p5]) then
				l___hash__2[p5] = nil;
			end;
		end;
		if l___hash__2[p6] then
			l___hash__2[p6][p5] = nil;
			if not next(l___hash__2[p6]) then
				l___hash__2[p6] = nil;
			end;
		end;
	end, 
	canCollide = function(p7, p8, p9)
		local l___hash__3 = u1._hash;
		return not l___hash__3[p8] or not l___hash__3[p8][p9];
	end
};
return u1;

