
-- Decompiled with the Synapse X Luau decompiler.

return {
	escapeForbiddenCharacters = function(p1)
		return p1:gsub("&", "&amp;"):gsub(">", "&gt;"):gsub("<", "&lt;"):gsub("\"", "&quot;"):gsub("'", "&apos;");
	end, 
	formatTextColor3 = function(p2, p3)
		if typeof(p3) ~= "Color3" then
			return;
		end;
		return "<font color=\"rgb(" .. math.round(p3.R * 255) .. ", " .. math.round(p3.G * 255) .. ", " .. math.round(p3.B * 255) .. ")\">" .. p2 .. "</font>";
	end, 
	formatLineBreak = function(p4, p5, p6, p7)
		local v1 = 0;
		local v2 = p7 and 0;
		local v3 = 0;
		local v4 = "";
		for v5 in string.gmatch(p4, "%S+") do
			v1 = v1 + 1;
			local v6 = string.len(v5);
			if p5 < v2 + v6 + 1 then
				v4 = v4 .. "<br />" .. string.rep(" ", p6) .. v5;
				v2 = v6 + p6;
				v3 = v3 + 1;
			else
				v4 = v1 == 1 and v5 or v4 .. " " .. v5;
				v2 = v2 + (v6 + 1);
			end;
		end;
		return v4, v3;
	end
};

