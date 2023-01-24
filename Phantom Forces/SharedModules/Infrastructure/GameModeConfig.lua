
-- Decompiled with the Synapse X Luau decompiler.

return {
	tdm = {
		Name = "Team Deathmatch", 
		Length = 15, 
		Startscore = 0, 
		Endscore = 200, 
		Point = 0, 
		Scoretype = "Gain"
	}, 
	dom = {
		Name = "Flare Domination", 
		Length = 15, 
		Startscore = 0, 
		Endscore = 250, 
		Interval = 10, 
		Point = 4, 
		Scoretype = "Gain"
	}, 
	koth = {
		Name = "King of the Hill", 
		Length = 15, 
		Startscore = 600, 
		Endscore = 0, 
		Interval = 1, 
		Point = 5, 
		Scoretype = "Attrition"
	}, 
	hp = {
		Name = "Hard Point", 
		Interval = 1, 
		Length = 15, 
		Startscore = 0, 
		Endscore = 700, 
		Point = 0, 
		Scoretype = "Gain"
	}, 
	kc = {
		Name = "Kill Confirmed", 
		Length = 15, 
		Startscore = 0, 
		Endscore = 150, 
		Point = 0, 
		Scoretype = "Gain"
	}, 
	ctf = {
		Name = "Capture the Flag", 
		Length = 10, 
		Startscore = 0, 
		Endscore = 5, 
		Point = 0, 
		Scoretype = "Gain"
	}, 
	trun = {
		Name = "Tag Run", 
		Length = 15, 
		Startscore = 0, 
		Endscore = 150, 
		Point = 0, 
		Scoretype = "Gain"
	}, 
	gg = {
		Name = "Gun Game", 
		Length = 30, 
		Startscore = 0, 
		Endscore = 32, 
		Point = 0, 
		Scoretype = "Gain", 
		Gundropdisabled = true
	}, 
	swap = {
		Name = "Swap", 
		Length = 15, 
		Startscore = 0, 
		Endscore = 200, 
		Point = 0, 
		Scoretype = "Gain", 
		Gundropdisabled = true
	}
};

