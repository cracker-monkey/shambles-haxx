
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("TransformedMesh");
local u1 = shared.require("Sweep");
local u2 = shared.require("MinimumDifference");
local u3 = shared.require("Incenter");
return function(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11)
	p4.cframe = p4.cframe.Rotation + p6;
	local v2, v3, v4 = p8(p5, p6, p7);
	local v5 = {};
	for v6 = 1, 200 do
		local v7 = nil;
		local v8 = nil;
		if p11 and p11() then
			break;
		end;
		local v9 = v3 - p6;
		local v10 = nil;
		local v11 = (1 / 0);
		local v12 = {};
		for v13, v14 in p2(p4, v9), nil do
			if not v5[v14] then
				local v15, v16 = u1.mesh(v14, p4, v9, v14.radius + p4.radius, true, (v11 - p5) / (v2 - p5));
				if v15 then
					local v17 = (1 - v16) * p5 + v16 * v2;
				else
					v17 = nil;
				end;
				if v17 then
					if p5 < v17 then
						if v17 < v11 then
							v11 = v17;
							v10 = v14;
						end;
					else
						local v18, v19 = u1.mesh(v14, p4, -v9, v14.radius + p4.radius + p1, true);
						if v18 then
							local v20 = (1 + v19) * p5 - v19 * v2;
						else
							v20 = nil;
						end;
						if v20 and p5 < v20 then
							v5[v14] = v20;
							v12[v14] = true;
							if v17 < v11 then
								v11 = v17;
								v10 = v14;
							end;
						end;
					end;
				end;
			end;
		end;
		for v21 in v5, nil do
			if not v12[v21] then
				local v22, v23 = u1.mesh(v21, p4, -v9, v21.radius + p4.radius + p1, true);
				if v22 then
					local v24 = (1 + v23) * p5 - v23 * v2;
				else
					v24 = nil;
				end;
				if v24 then
					if p5 < v24 then
						v5[v21] = v24;
					else
						v5[v21] = nil;
					end;
				end;
			end;
		end;
		local v25 = math.clamp(v11, p5, math.min(p3, v2));
		p6 = p6 + (v25 - p5) / (v2 - p5) * (v3 - p6);
		p7 = p7 + (v25 - p5) / (v2 - p5) * (v4 - p7);
		p5 = v25;
		p4.cframe = p4.cframe.Rotation + p6;
		if p9 then
			p9(p5, p6, p7);
		end;
		if v25 == p3 then
			break;
		end;
		for v26, v27 in v5, nil do
			if v27 < v25 then
				v5[v26] = nil;
			end;
		end;
		if v10 and v11 == v25 then
			v5[v10] = v11;
		end;
		local v28 = {};
		local v29 = {};
		for v30, v31 in v5, nil do
			local v32, v33 = u2.mesh(v30, p4);
			if v33 and p1 < v33 - v30.radius - p4.radius then
				v5[v30] = nil;
			elseif v32 and v30.canCollide then
				table.insert(v28, Vector3.zero);
				table.insert(v29, v32);
			end;
		end;
		if v10 and not v10.canCollide and v10.entryBreakSpeed then
			local v34, v35 = u2.mesh(v10, p4);
			if v34 and v10.entryBreakSpeed < -v34:Dot(p7) then
				p7 = p7 - v34:Dot(p7.unit) * v34 * v10.entryBreakSpeed;
				v10.broken = true;
			else
				p7 = p7 - v34:Dot(p7) * v34 * (1 + p4.elasticity);
			end;
		end;
		local v36 = u3.push(v28, v29, p7);
		local v37 = (1 + p4.elasticity) * (v36 - p7);
		if 0 * v37.magnitude < v36.magnitude then
			p7 = v37 - 0 * v37.magnitude * v36.unit + p7;
		else
			p7 = v37 - v36 + p7;
		end;
		if p9 then
			p9(p5, p6, p7);
		end;
		if p10 then
			p10(v10, p5, p6, p7, p7);
		end;
		local v38, v39, v40 = p8(p5, p6, p7);
		v7 = v38 - p5;
		v8 = u3.push(v28, v29, v39 - p6) + p6;
		local v41 = u3.push(v28, v29, v40);
		local l__magnitude__42 = (v41 - v40).magnitude;
		if p4.friction * l__magnitude__42 < v41.magnitude then
			local v43 = p4.friction * l__magnitude__42 * v41.unit;
			local v44 = v8 - v7 / 2 * v43;
			local v45 = v41 - v43;
		else
			v44 = v8 - v7 / 2 * v41;
			v45 = Vector3.zero;
		end;
	end;
	return p5, p6, p7;
end;

