
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("VectorVisualizer");
local l__timehit__1 = shared.require("physics").timehit;
local l__bulletLifeTime__2 = shared.require("PublicSettings").bulletLifeTime;
local u3 = { workspace.Terrain, workspace.Ignore, workspace.CurrentCamera };
local u4 = shared.require("Raycast");
local function u5(p1)
	if not p1.CanCollide then
		return true;
	end;
	if p1.Transparency ~= 1 then
		return;
	end;
	return true;
end;
return function(p2, p3, p4, p5, p6, p7)
	local v2 = l__timehit__1(p2, p4, p5, p3);
	local v3 = true;
	if v2 == v2 then
		v3 = true;
		if v2 ~= (1 / 0) then
			v3 = v2 == (-1 / 0);
		end;
	end;
	if v3 or l__bulletLifeTime__2 < v2 then
		return false;
	end;
	local v4 = { u3 };
	local v5 = true;
	local v6 = false;
	local v7 = 0;
	local v8 = p7 and 0.016666666666666666;
	local v9 = p2;
	local v10 = p4;
	local v11 = p6;
	while v7 < v2 do
		local v12 = v2 - v7;
		if v8 < v12 then
			v12 = v8;
		end;
		local v13 = v12 * v10 + v12 * v12 / 2 * p5;
		local v14 = u4.raycast(v9, v13, v4, u5, true);
		if v14 then
			local l__Instance__15 = v14.Instance;
			local l__Position__16 = v14.Position;
			local l__unit__17 = v13.unit;
			local v18 = u4.raycastSingleExit(l__Position__16, l__Instance__15.Size.magnitude * l__unit__17, l__Instance__15);
			if v18 then
				v11 = v11 - l__unit__17:Dot(v18.Position - l__Position__16);
				if v11 < 0 then
					v5 = false;
					break;
				end;
				v6 = true;
			end;
			local v19 = v13:Dot(l__Position__16 - v9) / v13:Dot(v13) * v12;
			v9 = l__Position__16 + 0.01 * (v9 - l__Position__16).unit;
			v10 = v10 + v19 * p5;
			v7 = v7 + v19;
			table.insert(v4, l__Instance__15);
		else
			v9 = v9 + v13;
			v10 = v10 + v12 * p5;
			v7 = v7 + v12;
		end;	
	end;
	return v5, v6, v11;
end;

