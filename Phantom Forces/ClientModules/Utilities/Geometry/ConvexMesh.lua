
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	makeFurthestPointRegularPrismYFunction = function(p1, p2, p3, p4)
		local l__p__2 = p1.p;
		local u3 = 2 * math.pi / p4;
		return function(p5)
			if not p5 then
				return l__p__2;
			end;
			local v1 = p1:vectorToObjectSpace(p5);
			local v2 = math.atan2(v1.x, v1.z) + u3 / 2;
			local v3 = v2 - v2 % u3;
			return p1 * Vector3.new(p3 * math.sin(v3), v1.y < 0 and -p2 / 2 or p2 / 2, p3 * math.cos(v3));
		end;
	end, 
	makeFurthestPointBoxFunction2 = function(p6, p7)
		debug.profilebegin("makeFurthestPointBlockFunction2");
		local v4 = p7.x / 2;
		local v5 = p7.y / 2;
		local v6 = p7.z / 2;
		local v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18 = p6:components();
		local v19 = Vector3.new(v10, v13, v16);
		local v20 = Vector3.new(v11, v14, v17);
		local v21 = Vector3.new(v12, v15, v18);
		local v22 = p6 * Vector3.new(0, 0, 0);
		local v23 = p6 * Vector3.new(v4, v5, v6);
		local v24 = p6 * Vector3.new(-v4, v5, v6);
		local v25 = p6 * Vector3.new(v4, -v5, v6);
		local v26 = p6 * Vector3.new(-v4, -v5, v6);
		local v27 = p6 * Vector3.new(v4, v5, -v6);
		local v28 = p6 * Vector3.new(-v4, v5, -v6);
		local v29 = p6 * Vector3.new(v4, -v5, -v6);
		local v30 = p6 * Vector3.new(-v4, -v5, -v6);
		debug.profileend();
		return function(p8)
			local v31 = nil;
			local v32 = nil;
			if not p8 then
				return v22;
			end;
			v31 = p8:Dot(v20);
			v32 = p8:Dot(v21);
			if p8:Dot(v19) < 0 then
				if v31 < 0 then
					if v32 < 0 then
						return v30;
					else
						return v26;
					end;
				elseif v32 < 0 then
					return v28;
				else
					return v24;
				end;
			end;
			if v31 < 0 then
				if v32 < 0 then
					return v29;
				else
					return v25;
				end;
			end;
			if v32 < 0 then
				return v27;
			end;
			return v23;
		end;
	end, 
	makeFurthestPointWedgeFunction = function(p9, p10)
		debug.profilebegin("makeFurthestPointWedgeFunction");
		local v33 = p10.x / 2;
		local v34 = p10.y / 2;
		local v35 = p10.z / 2;
		local v36, v37, v38, v39, v40, v41, v42, v43, v44, v45, v46, v47 = p9:components();
		local v48 = p9 * Vector3.new(0, -v34 / 3, v35 / 3);
		local v49 = { p9 * Vector3.new(v33, v34, v35), p9 * Vector3.new(-v33, v34, v35), p9 * Vector3.new(v33, -v34, v35), p9 * Vector3.new(-v33, -v34, v35), p9 * Vector3.new(v33, -v34, -v35), p9 * Vector3.new(-v33, -v34, -v35) };
		debug.profileend();
		return function(p11)
			if not p11 then
				return v48;
			end;
			local v50 = (-1 / 0);
			local v51 = nil;
			for v52, v53 in v49, nil do
				local v54 = p11:Dot(v53);
				if v50 <= v54 then
					v50 = v54;
					v51 = v53;
				end;
			end;
			return v51;
		end;
	end, 
	makeFurthestPointCornerWedgeFunction = function(p12, p13)
		debug.profilebegin("makeFurthestPointCornerWedgeFunction");
		local v55 = p13.x / 2;
		local v56 = p13.y / 2;
		local v57 = p13.z / 2;
		local v58, v59, v60, v61, v62, v63, v64, v65, v66, v67, v68, v69 = p12:components();
		local v70 = p12 * Vector3.new(v55 / 4, -v56 / 2, -v57 / 4);
		local v71 = { p12 * Vector3.new(v55, -v56, v57), p12 * Vector3.new(-v55, -v56, v57), p12 * Vector3.new(v55, v56, -v57), p12 * Vector3.new(v55, -v56, -v57), p12 * Vector3.new(-v55, -v56, -v57) };
		debug.profileend();
		return function(p14)
			if not p14 then
				return v70;
			end;
			local v72 = (-1 / 0);
			local v73 = nil;
			for v74, v75 in v71, nil do
				local v76 = p14:Dot(v75);
				if v72 <= v76 then
					v72 = v76;
					v73 = v75;
				end;
			end;
			return v73;
		end;
	end, 
	makeFurthestPointBallFunction = function(p15, p16)
		debug.profilebegin("makeFurthestPointBallFunction");
		local v77 = math.min(p16.x / 2, p16.y / 2, p16.z / 2);
		debug.profileend();
		return function(p17)
			if not p17 then
				return p15;
			end;
			return p15 + v77 * p17.unit;
		end;
	end, 
	makeFurthestPointCylinderFunction = function(p18, p19)
		debug.profilebegin("makeFurthestPointCylinderFunction");
		local v78 = math.min(p19.y / 2, p19.z / 2);
		debug.profileend();
		local l__p__4 = p18.p;
		local l__XVector__5 = p18.XVector;
		local u6 = p19.x / 2;
		return function(p20)
			if not p20 then
				return l__p__4;
			end;
			local v79 = p20:Dot(l__XVector__5);
			if v79 < 0 then
				local v80 = -u6 * l__XVector__5;
			else
				v80 = u6 * l__XVector__5;
			end;
			local v81 = v78 * (p20 - v79 * l__XVector__5).unit;
			local v82 = v81:Dot(l__XVector__5);
			if v82 < -v78 * 0.0001 or v78 * 0.0001 < v82 or v82 ~= v82 then
				v81 = Vector3.zero;
			end;
			return l__p__4 + v80 + v81;
		end;
	end, 
	makeFurthestPointFunction = function(p21)
		debug.profilebegin("makeFurthestPointFunction");
		local l__ClassName__83 = p21.ClassName;
		if l__ClassName__83 == "Part" then
			local l__Shape__84 = p21.Shape;
			if l__Shape__84 == Enum.PartType.Ball then
				debug.profileend();
				return u1.makeFurthestPointBallFunction(p21.Position, p21.Size);
			elseif l__Shape__84 == Enum.PartType.Cylinder then
				debug.profileend();
				return u1.makeFurthestPointCylinderFunction(p21.CFrame, p21.Size);
			else
				debug.profileend();
				return u1.makeFurthestPointBoxFunction2(p21.CFrame, p21.Size);
			end;
		end;
		if l__ClassName__83 == "WedgePart" then
			debug.profileend();
			return u1.makeFurthestPointWedgeFunction(p21.CFrame, p21.Size);
		end;
		if l__ClassName__83 == "CornerWedgePart" then
			debug.profileend();
			return u1.makeFurthestPointCornerWedgeFunction(p21.CFrame, p21.Size);
		end;
		if l__ClassName__83 ~= "UnionOperation" and l__ClassName__83 ~= "MeshPart" and l__ClassName__83 ~= "TrussPart" then
			return;
		end;
		debug.profileend();
		return u1.makeFurthestPointBoxFunction2(p21.CFrame, p21.Size), l__ClassName__83;
	end
};
return u1;

