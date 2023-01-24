
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	solveLinear = function(p1, p2)
		local v1 = -p1 / p2;
		if v1 ~= v1 then
			return;
		end;
		return v1;
	end, 
	solveQuadratic = function(p3, p4, p5)
		local v2 = (p4 * p4 - 4 * p3 * p5) ^ 0.5;
		if v2 ~= v2 then
			return;
		end;
		local v3 = (-p4 - v2) / (2 * p5);
		local v4 = (-p4 + v2) / (2 * p5);
		if v3 == v3 and v4 == v4 then
			if v3 ~= v4 then
				return v3, v4;
			else
				return v3;
			end;
		end;
		return u1.solveLinear(p3, p4);
	end, 
	getMinimumPositive = function(...)
		local v5 = nil;
		local v6 = (1 / 0);
		for v7 = 1, select("#", ...) do
			local v8 = select(v7, ...);
			if v8 >= 0 and v8 < v6 then
				v5 = v7;
				v6 = v8;
			end;
		end;
		if not v5 then
			return;
		end;
		return v6, v5;
	end, 
	solveRaySphereIntersection = function(p6, p7, p8, p9)
		local v9 = p6 - p8;
		return u1.solveQuadratic(v9:Dot(v9) - p9 * p9, 2 * p7:Dot(v9), (p7:Dot(p7)));
	end, 
	doesRayIntersectSphere = function(p10, p11, p12, p13)
		local v10, v11 = u1.solveRaySphereIntersection(p10, p11, p12, p13);
		if v10 and v11 and v10 < 1 and v11 > 0 then
			return true;
		end;
		return false;
	end, 
	solvePlaneParabolaIntersection = function(p14, p15, p16, p17, p18)
		return u1.solveQuadratic(p15:Dot(p16 - p14), p15:Dot(p17), p15:Dot(p18));
	end, 
	solvePlaneLineIntersection = function(p19, p20, p21, p22)
		return u1.solveLinear(p20:Dot(p21 - p19), p20:Dot(p22));
	end
};
local u2 = 2 * math.pi;
local l__math_cos__3 = math.cos;
local l__math_sin__4 = math.sin;
function u1.randomUnit()
	local v12 = 2 * math.random() - 1;
	local v13 = u2 * math.random();
	local v14 = math.sqrt(1 - v12 * v12);
	return Vector3.new(v12, v14 * l__math_cos__3(v13), v14 * l__math_sin__4(v13));
end;
function u1.capVectorMagnitude(p23, p24)
	if p24.magnitude < p23 then
		return p24;
	end;
	return p23 * p24.unit;
end;
local l__math_atan2__5 = math.atan2;
function u1.anglesYXZfromLookVector(p25)
	local l__x__15 = p25.x;
	local l__z__16 = p25.z;
	return l__math_atan2__5(p25.y, (l__x__15 * l__x__15 + l__z__16 * l__z__16) ^ 0.5), l__math_atan2__5(-l__x__15, -l__z__16), 0;
end;
function u1.cframeFromAxisAngle(p26)
	local v17 = CFrame.fromAxisAngle(p26.Unit, p26.Magnitude);
	if v17 == v17 then
		return v17;
	end;
	return CFrame.new();
end;
function u1.quaternionFromCFrame(p27)
	local v18, v19 = p27:toAxisAngle();
	local v20 = l__math_sin__4(v19 / 2);
	return l__math_cos__3(v19 / 2), v20 * v18.X, v20 * v18.Y, v20 * v18.Z;
end;
function u1.axisAngleFromQuaternion(p28, p29, p30, p31)
	local v21 = nil;
	local v22 = nil;
	local v23 = (p29 * p29 + p30 * p30 + p31 * p31) ^ 0.5;
	local v24 = 2 * l__math_atan2__5(v23, p28) / v23;
	local v25 = v24 * p29;
	v21 = v24 * p30;
	v22 = v24 * p31;
	if v25 ~= v25 or v21 ~= v21 or v22 ~= v22 then
		return Vector3.new(0, 0, 0);
	end;
	return Vector3.new(v25, v21, v22);
end;
function u1.angularVelocityFromQuaternionDerivative(p32, p33, p34, p35, p36, p37, p38, p39)
	return Vector3.new(2 * (-p32 * p37 + p33 * p36 - p34 * p39 + p35 * p38), 2 * (-p32 * p38 + p33 * p39 + p34 * p36 - p35 * p37), 2 * (-p32 * p39 - p33 * p38 + p34 * p37 + p35 * p36));
end;
function u1.quaternionFromAxisAngle(p40)
	local l__unit__26 = p40.unit;
	local l__magnitude__27 = p40.magnitude;
	local v28 = l__math_cos__3(l__magnitude__27 / 2);
	local v29 = l__math_sin__4(l__magnitude__27 / 2);
	local v30 = v29 * l__unit__26.X;
	local v31 = v29 * l__unit__26.Y;
	local v32 = v29 * l__unit__26.Z;
	if v28 == v28 and v30 == v30 and v31 == v31 and v32 == v32 then
		return v28, v30, v31, v32;
	end;
	return 1, 0, 0, 0;
end;
function u1.axisAngleFromCFrame(p41)
	local v33, v34 = p41:toAxisAngle();
	return v34 * v33;
end;
function u1.look(p42, p43, p44)
	local v35 = p42:Cross(p43);
	local v36 = CFrame.new(0, 0, 0, v35.x, v35.y, v35.z, p42:Dot(p43) + p42.magnitude * p43.magnitude);
	if v36 ~= v36 then
		return CFrame.new();
	end;
	local v37 = typeof(p44);
	if v37 == "nil" then
		return v36;
	end;
	if v37 == "Vector3" then
		return v36 - v36 * p44 + p44;
	end;
	if v37 ~= "CFrame" then
		error("Math.look's 3rd argument is not nil, Vector3 or CFrame!");
		return;
	end;
	local l__p__38 = p44.p;
	return v36 * (p44 - l__p__38) + l__p__38;
end;
return u1;

