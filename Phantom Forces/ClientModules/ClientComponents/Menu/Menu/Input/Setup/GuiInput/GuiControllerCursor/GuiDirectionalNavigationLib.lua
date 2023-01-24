
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__PlayerGui__1 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");
function v1.getNextSelection(p1, p2, p3, p4, p5)
	local v2 = (p2 * p2 + p3 * p3) ^ 0.5;
	local v3 = {};
	for v4 in next, p1 do
		local v5, v6 = v4:getCenter();
		local v7 = v5 - p4;
		local v8 = v6 - p5;
		local v9 = (v7 * v7 + v8 * v8) ^ 0.5;
		local v10 = v7 * p2 + v8 * p3;
		local v11 = (v7 * v7 + v8 * v8) / v10 ^ 1.5;
		if v9 > 3 and v11 == v11 and v10 == v10 and math.cos(math.pi / 4) * v9 * v2 < v10 then
			table.insert(v3, {
				guiInterest = v4, 
				x = v7, 
				y = v8, 
				m = v9, 
				d = v10, 
				v = v11
			});
		end;
	end;
	table.sort(v3, function(p6, p7)
		return p6.v < p7.v;
	end);
	for v12 = 1, #v3 do
		local v13 = v3[v12];
		local l__guiInterest__14 = v13.guiInterest;
		local v15 = l__PlayerGui__1:GetGuiObjectsAtPosition(l__guiInterest__14:getCenter());
		local v16 = l__guiInterest__14:getGui();
		local v17 = #v15;
		local v18 = 1 - 1;
		while true do
			local v19 = v15[v18];
			if v19 == v16 then
				local v20 = true;
				break;
			end;
			if v19.Active then
				v20 = false;
				break;
			end;
			if 0 <= 1 then
				if not (v18 < v17) then
					v20 = false;
					break;
				end;
			elseif not (v17 < v18) then
				v20 = false;
				break;
			end;
			v18 = v18 + 1;		
		end;
		if v20 then
			return v13.guiInterest;
		end;
	end;
end;
return v1;

