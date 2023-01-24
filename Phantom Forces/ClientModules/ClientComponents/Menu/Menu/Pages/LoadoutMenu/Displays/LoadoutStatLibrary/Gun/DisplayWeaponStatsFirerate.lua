
-- Decompiled with the Synapse X Luau decompiler.

local l__Templates__1 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u2 = shared.require("MenuColorConfig");
return function(p1, p2, p3)
	local v1 = "";
	if p2.doublebarrel then
		v1 = type(p2.firerate) == "table" and math.round(p2.firerate[1]) .. " Semi | INSTANT Burst" or math.round(p2.firerate);
	else
		local l__firerate__2 = p2.firerate;
		if type(l__firerate__2) == "table" then
			local l__next__3 = next;
			local v4 = nil;
			while true do
				local v5, v6 = l__next__3(l__firerate__2, v4);
				if not v5 then
					break;
				end;
				local v7 = p2.firemodes[v5];
				if v7 then
					if type(v7) == "number" then
						if v7 == 1 then
							v1 = v1 .. math.round(v6) .. " S";
						else
							v1 = v1 .. math.round(v6) .. " B";
						end;
					else
						v1 = v1 .. math.round(v6) .. " A";
					end;
				end;
				if v5 < #l__firerate__2 then
					v1 = v1 .. " | ";
				end;			
			end;
		else
			v1 = math.round(l__firerate__2);
		end;
	end;
	local v8 = l__Templates__1.DisplayWeaponStatText:Clone();
	v8.TextFrameStat.Text = string.upper("Firerate");
	v8.TextFrameValue.Text = string.upper(v1);
	if p3.firerate or p3.firemodes then
		v8.TextFrameValue.TextColor3 = u2.previewDisplayTextStatsColor;
	end;
	return v8;
end;

