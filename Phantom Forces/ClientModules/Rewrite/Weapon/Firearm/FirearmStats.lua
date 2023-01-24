
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("cframe");
local u2 = shared.require("spring");
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	local v3 = p1:getWeaponData();
	v2.sight = v3.sight;
	v2.sightpart = p1:getWeaponPart(v3.sight);
	v2.aimoffset = CFrame.new();
	v2.aimrotkickmin = v3.aimrotkickmin;
	v2.aimrotkickmax = v3.aimrotkickmax;
	v2.aimtranskickmin = v3.aimtranskickmin * Vector3.new(1, 1, 0.5);
	v2.aimtranskickmax = v3.aimtranskickmax * Vector3.new(1, 1, 0.5);
	v2.larmaimoffset = v3.larmaimoffset;
	v2.rarmaimoffset = v3.rarmaimoffset;
	v2.aimcamkickmin = v3.aimcamkickmin;
	v2.aimcamkickmax = v3.aimcamkickmax;
	v2.aimcamkickspeed = v3.aimcamkickspeed;
	v2.aimspeed = v3.aimspeed;
	v2.aimwalkspeedmult = v3.aimwalkspeedmult;
	v2.zoom = v3.zoom;
	v2.magnifyspeed = v3.magnifyspeed;
	v2.scopebegin = v3.scopebegin and 0.9;
	v2.prezoom = v3.prezoom or v3.zoom ^ 0.25;
	v2.firerate = v3.firerate;
	v2.aimedfirerate = v3.aimedfirerate;
	v2.variablefirerate = v3.variablefirerate;
	v2.onfireanim = v3.onfireanim and "";
	v2.onfireaimedanim = v3.onfireaimedanim;
	v2.sightr = v3.sightr;
	v2.sightsize = v3.sightsize;
	v2.aimzdist = v3.aimzdist;
	v2.aimzoffset = v3.aimzoffset;
	v2.aimreloffset = v3.aimreloffset;
	v2.aimspringcancel = v3.aimspringcancel;
	v2.nosway = v3.nosway;
	v2.swayamp = v3.swayamp;
	v2.swayspeed = v3.swayspeed;
	v2.steadyspeed = v3.steadyspeed;
	v2.breathspeed = v3.breathspeed;
	v2.recoverspeed = v3.recoverspeed;
	v2.standsteadyspeed = v3.standsteadyspeed;
	v2.standswayampmult = v3.standswayampmult;
	v2.standswayspeedmult = v3.standswayspeedmult;
	v2.scopeid = v3.scopeid;
	v2.scopesize = v3.scopesize;
	v2.scopecolor = v3.scopecolor;
	v2.sightcolor = v3.sightcolor;
	v2.scopelenscolor = v3.lenscolor;
	v2.scopelenstrans = v3.lenstrans;
	v2.scopeimagesize = v3.scopeimagesize;
	v2.reddot = v3.reddot;
	v2.midscope = v3.midscope;
	v2.blackscope = v3.blackscope;
	v2.pullout = v3.pullout;
	v2.zoompullout = v3.zoompullout;
	v2.centermark = v3.centermark;
	if p2 then
		for v4, v5 in next, p2 do
			v2[v4] = v5;
		end;
	end;
	local v6 = p1:getWeaponModel();
	if not v6:FindFirstChild(v2.sight) then
		warn("no sight found for", v2.sight);
		return v2;
	end;
	local v7 = v3.mainoffset:inverse() * v6[v2.sight].CFrame:inverse() * p1:getMainPart().CFrame;
	local v8 = (v7 - (v2.aimzdist and Vector3.new(0, 0, v2.aimzdist + (v2.aimzoffset and 0)) or v7.p * Vector3.new(0, 0, 1) - Vector3.new(0, 0, 0))) * (v2.aimreloffset or CFrame.new());
	v2.sightpart = v6[v2.sight];
	v2.aimoffset = v8;
	v2.aimoffsetp = v8.p;
	v2.aimoffsetr = u1.toaxisangle(v8);
	v2.larmaimoffsetp = v2.larmaimoffset.p;
	v2.larmaimoffsetr = u1.toaxisangle(v2.larmaimoffset);
	v2.rarmaimoffsetp = v2.rarmaimoffset.p;
	v2.rarmaimoffsetr = u1.toaxisangle(v2.rarmaimoffset);
	v2.sightmagspring = u2.new(0);
	v2.sightaimspring = u2.new(0);
	return v2;
end;
return v1;

