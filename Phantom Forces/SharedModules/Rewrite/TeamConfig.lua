
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	teamNames = {
		[game:GetService("Teams").Phantoms.TeamColor] = "Phantoms", 
		[game:GetService("Teams").Ghosts.TeamColor] = "Ghosts"
	}, 
	teamColors = {
		Phantoms = game:GetService("Teams").Phantoms.TeamColor, 
		Ghosts = game:GetService("Teams").Ghosts.TeamColor
	}, 
	getTeamName = function(p1)
		for v1, v2 in next, u1.teamNames do
			if p1 == v1 then
				return v2, v1;
			end;
		end;
	end
};
return u1;

