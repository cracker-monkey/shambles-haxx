
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = CFrame.new(0, 0, -0.5, 1, 0, 0, 0, 0, -1, 0, 1, 0);
local u1 = shared.require("Destructor");
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
local u3 = shared.require("SmoothReplicationPackager");
local u4 = shared.require("Fib3Decoder");
local u5 = shared.require("Fib2Decoder");
local u6 = shared.require("ReplicationSmoother");
local u7 = shared.require("GameClock");
local u8 = shared.require("spring");
local u9 = shared.require("Holode4");
function v1.new(p1)
	local v3 = setmetatable({}, v1);
	v3._destructor = u1.new();
	if p1 == l__LocalPlayer__2 then
		warn("ReplicationObject: Attempting to create object for localPlayer");
	end;
	v3._player = p1;
	v3.lastlevel = 0;
	v3.lastupdate = 0;
	v3.lastupframe = 0;
	v3._smoothPosition = u3.new(u4.new(0.020833333333333332), Vector3.zero);
	v3._smoothLookAngles = u3.new(u5.new(0.020833333333333332), Vector2.new());
	v3._smoothReplication = u6.new(10, 0.25, 0.5, function(p2, p3, p4, p5, p6)
		if p4 == p5 then
			return p2;
		end;
		local v4 = (p5 - p6) / (p5 - p4);
		local v5 = (p6 - p4) / (p5 - p4);
		return {
			t = v4 * p2.t + v5 * p3.t, 
			position = v4 * p2.position + v5 * p3.position, 
			velocity = v4 * p2.velocity + v5 * p3.velocity, 
			angles = v4 * p2.angles + v5 * p3.angles, 
			breakcount = p2.breakcount
		};
	end);
	v3._breakcount = 0;
	v3._lastbreakcount = nil;
	v3._lastPacketTime = nil;
	v3._lastSmoothTime = nil;
	v3._receivedFrameTime = nil;
	v3._receivedPosition = nil;
	v3._updaterecieved = false;
	v3._alive = false;
	v3._healthstate = {
		health0 = 100, 
		healtick0 = u7.getTime(), 
		healrate = 0.25, 
		maxhealth = 100, 
		healwait = 8
	};
	v3._posspring = u8.new(Vector3.zero, 1, 32);
	v3._velspring = u8.new(Vector3.zero, 1, 6);
	v3._lookangles = u8.new(Vector2.new(), 0.75, 12);
	v3._interpolator = u9.new(Vector3.zero, 12);
	v3._activeWeaponRegistry = {};
	v3._thirdPersonObject = nil;
	v3._destructor:add(function()
		if v3._thirdPersonObject then
			v3._thirdPersonObject:Destroy();
		end;
	end);
	return v3;
end;
function v1.Destroy(p7)
	p7._destructor:Destroy();
end;
function v1.isAlive(p8)
	return p8._alive;
end;
function v1.isReady(p9)
	return p9:isAlive() and p9._smoothReplication:isReady();
end;
function v1.getPosition(p10)
	return p10._posspring.p, p10._thirdPersonObject:getCharacterHash().head.Position;
end;
function v1.getLookAngles(p11)
	return p11._lookangles.p;
end;
function v1.getWeaponObject(p12, p13)
	return p12._activeWeaponRegistry[p13];
end;
function v1.getHealth(p14)
	local v6 = nil;
	v6 = p14._healthstate.health0;
	local l__maxhealth__7 = p14._healthstate.maxhealth;
	local v8 = u7.getTime() - p14._healthstate.healtick0;
	if v8 < 0 then
		return v6, l__maxhealth__7;
	end;
	local v9 = v6 + v8 * v8 * p14._healthstate.healrate;
	return v9 < l__maxhealth__7 and v9 or l__maxhealth__7, l__maxhealth__7;
end;
function v1.getThirdPersonObject(p15)
	return p15._thirdPersonObject;
end;
function v1.resetSprings(p16, p17)
	p17 = p17 or Vector3.zero;
	p16._posspring.t = p17;
	p16._posspring.p = p17;
	p16._posspring.v = Vector3.zero;
	p16._velspring.t = Vector3.zero;
	p16._velspring.p = Vector3.zero;
	p16._velspring.v = Vector3.zero;
	p16._interpolator._p0 = p17;
	p16._interpolator._p1 = p17;
	p16._interpolator._a0 = Vector3.zero;
	p16._interpolator._j0 = Vector3.zero;
	p16._interpolator._v0 = Vector3.zero;
	p16._interpolator._t0 = 0;
end;
function v1.initState(p18, p19)
	local v10, v11 = unpack(p19);
	p18._smoothPosition:initializeState(unpack(v10));
	p18._smoothLookAngles:initializeState(unpack(v11));
end;
local u10 = shared.require("ModifyData");
local u11 = shared.require("ContentDatabase");
local u12 = shared.require("ThirdPersonObject");
function v1.spawn(p20, p21, p22)
	local l__Primary__12 = p22.Primary;
	p20._activeWeaponRegistry[1] = {
		weaponName = l__Primary__12.Name, 
		weaponData = u10.getModifiedData(u11.getWeaponData(l__Primary__12.Name), l__Primary__12.Attachments, l__Primary__12.AttData), 
		attachmentData = l__Primary__12.Attachments, 
		camoData = l__Primary__12.Camo
	};
	local l__Secondary__13 = p22.Secondary;
	if l__Secondary__13 then
		p20._activeWeaponRegistry[2] = {
			weaponName = l__Secondary__13.Name, 
			weaponData = u10.getModifiedData(u11.getWeaponData(l__Secondary__13.Name), l__Secondary__13.Attachments, l__Secondary__13.AttData), 
			attachmentData = l__Secondary__13.Attachments, 
			camoData = l__Secondary__13.Camo
		};
	end;
	local l__Knife__14 = p22.Knife;
	p20._activeWeaponRegistry[3] = {
		weaponName = l__Knife__14.Name, 
		weaponData = u11.getWeaponData(l__Knife__14.Name), 
		camoData = l__Knife__14.Camo
	};
	local l__Grenade__15 = p22.Grenade;
	p20._activeWeaponRegistry[4] = {
		weaponName = l__Grenade__15.Name, 
		weaponData = u11.getWeaponData(l__Grenade__15.Name)
	};
	p20._thirdPersonObject = u12.new(p20._player, p21, p20);
	p20._thirdPersonObject:equip(1, true);
	p20._alive = true;
end;
function v1.despawn(p23)
	p23._breakcount = 0;
	p23._lastbreakcount = nil;
	p23._lastPacketTime = nil;
	p23._lastSmoothTime = nil;
	p23._receivedPosition = nil;
	p23._receivedFrameTime = nil;
	p23._smoothReplication:init();
	p23._activeWeaponRegistry = {};
	p23._thirdPersonObject = nil;
	p23._alive = false;
	return p23._thirdPersonObject;
end;
function v1.swapWeapon(p24, p25, p26)
	if p25 ~= 1 and p25 ~= 2 then
		if p25 == 3 then
			p24._activeWeaponRegistry[p25] = {
				weaponName = p26.Name, 
				weaponData = u11.getWeaponData(p26.Name), 
				camoData = p26.Camo
			};
		end;
		return;
	end;
	p24._activeWeaponRegistry[p25] = {
		weaponName = p26.Name, 
		weaponData = u10.getModifiedData(u11.getWeaponData(p26.Name), p26.Attachments, p26.AttData), 
		attachmentData = p26.Attachments, 
		camoData = p26.Camo
	};
end;
function v1.updateHealth(p27, p28, p29, p30)
	p27._healthstate.health0 = p28;
	p27._healthstate.healtick0 = p29;
end;
function v1.updateState(p31, p32)
	local v16 = nil;
	if p32.healthstate and p32.healthstate.alive then
		p31._healthstate.health0 = p32.healthstate.health0;
		p31._healthstate.healtick0 = p32.healthstate.healtick0;
	end;
	if p32.aim then
		p31._thirdPersonObject:setAim(p32.aim);
	end;
	if p32.sprint then
		p31._thirdPersonObject:setSprint(p32.sprint);
	end;
	if p32.stance then
		p31._thirdPersonObject:setStance(p32.stance);
	end;
	print(p31._player, p32, p31._thirdPersonObject);
	if p32.weaponIndex then
		v16 = p32.weaponIndex;
		if v16 ~= 1 and v16 ~= 2 then
			if v16 == 3 then
				p31._thirdPersonObject:equipMelee();
			end;
			return;
		end;
	else
		return;
	end;
	p31._thirdPersonObject:equip(v16);
end;
local function u13(p33)
	local v17 = p33(11);
	local v18 = p33(52);
	if p33(1) == 0 then
		local v19 = 1;
	else
		v19 = -1;
	end;
	if v17 == 2047 then
		if v18 == 0 then
			return v19 / 0;
		elseif v18 == 1 then
			return (0 / 0);
		else
			return (0 / 0);
		end;
	end;
	if v17 == 0 then
		return v19 * v18 * 5E-324;
	end;
	return v19 * (v18 / 4503599627370496 + 1) * 2 ^ (v17 - 1023);
end;
function v1.updateReplication(p34, p35)
	local v20 = u7.getTime();
	local v21 = u13(p35);
	local v22 = p34._smoothPosition:readAndUpdate(p35);
	local v23 = Vector3.zero;
	if p34._receivedPosition and p34._receivedFrameTime then
		v23 = (v22 - p34._receivedPosition) / (v21 - p34._receivedFrameTime);
	end;
	local v24 = false;
	if p34._lastPacketTime and v20 - p34._lastPacketTime > 0.5 then
		v24 = true;
		p34._breakcount = p34._breakcount + 1;
	end;
	p34._smoothReplication:receive(v20, v21, {
		t = v21, 
		position = v22, 
		velocity = v23, 
		angles = p34._smoothLookAngles:readAndUpdate(p35), 
		breakcount = p34._breakcount
	}, v24);
	p34._updaterecieved = true;
	p34._receivedPosition = v22;
	p34._receivedFrameTime = v21;
	p34._lastPacketTime = v20;
end;
local l__Players__14 = workspace:WaitForChild("Players");
function v1.step(p36, p37, p38)
	debug.profilebegin("ReplicationObject.step " .. p37 .. " " .. p36._player.Name);
	if not p36._thirdPersonObject then
		return;
	end;
	local v25 = nil;
	local v26 = nil;
	local v27 = nil;
	local v28 = nil;
	local v29 = 0;
	if p36._smoothReplication:isReady() then
		local v30 = p36._smoothReplication:getFrame(u7.getTime());
		if v30.breakcount ~= p36._lastbreakcount then
			p36:resetSprings(v30.position);
			p36._lastbreakcount = v30.breakcount;
			local v31 = p36._thirdPersonObject:getCharacterModel();
			if v31 then
				v31.Parent = l__Players__14[p36._player.TeamColor.Name];
			end;
		end;
		v25 = v30.position;
		v26 = v30.angles;
		v27 = v30.velocity;
		v28 = v30.position;
		v29 = v30.t - (p36._lastSmoothTime or v30.t);
		p36._lastSmoothTime = v30.t;
	end;
	local v32 = p36._lookangles:update(v26);
	local v33 = p36._posspring:update(v28);
	local v34 = p36._velspring:update(v27);
	local v35, v36, v37, v38 = p36._interpolator:update(v29, v25);
	p36._thirdPersonObject:render(p37, p38, CFrame.Angles(0, p36._thirdPersonObject:getBaseAngle(), 0) + (0 * v35 + 1 * v33), 0 * v36 + 1 * v34, v32, v37);
	debug.profileend();
end;
return v1;

