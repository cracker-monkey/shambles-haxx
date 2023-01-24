
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PlayerSettingsInterface");
local v3 = shared.require("PlayerSettingsEvents");
local v4 = shared.require("CameraSweep");
local v5 = shared.require("GyroService");
local v6 = shared.require("ScreenCull");
local v7 = shared.require("spring");
local v8 = shared.require("vector");
local v9 = shared.require("input");
local l__fromaxisangle__10 = shared.require("cframe").fromaxisangle;
local v11 = math.pi / 180;
local l__LocalPlayer__12 = game:GetService("Players").LocalPlayer;
local l__CurrentCamera__13 = workspace.CurrentCamera;
v1.currentcamera = l__CurrentCamera__13;
v1.type = "disabled";
v1.subcf = CFrame.new();
v1.sensitivitymult = 1;
v1.controlleraimmult = 1;
v1.directlook = false;
v1.sensitivity = v2.getValue("looksens") and 70;
v1.aimsensitivity = v2.getValue("aimsens") and 70;
v1.controllersens = v2.getValue("controllerlooksens") and 50;
v1.controlleraimsens = v2.getValue("controlleraimsens") and 50;
v1.controllerymult = v2.getValue("controllerverticalmult") and 50;
v1.controlleraccel = v2.getValue("controllerlookaccel") and 50;
v1.controlleraimaccel = v2.getValue("controlleraimaccel") and 50;
v1.controllersenspower = v2.getValue("controllersenspower") and 50;
if v2.getValue("toggleinvertyaxis") then
	local v14 = -1;
else
	v14 = 1;
end;
v1.xinvert = v14;
v1.directlookenabled = v2.getValue("togggledirectangularinput");
v1.curveDecelRate = v2.getValue("controllercurvedecel");
v1.basefov = 80;
v1.offset = Vector3.new(0, 1.5, 0);
v1.angles = Vector3.zero;
v1.maxangle = 0.496875 * math.pi;
v1.minangle = -0.496875 * math.pi;
v1.maxoffsetangle = math.pi / 6;
v1.basecframe = CFrame.new();
v1.shakecframe = CFrame.new();
v1.cframe = CFrame.new();
v1.lookvector = Vector3.new(0, 0, -1);
v1.shakespring = v7.new(Vector3.zero);
v1.magspring = v7.new(0);
v1.swayspring = v7.new(0);
v1.swayspeed = v7.new(0);
v1.zanglespring = v7.new(0);
v1.offsetspring = v7.new(Vector3.zero);
v1.delta = Vector3.zero;
v1.menufov = 60;
v1.spectatetype = "thirdperson";
v1.shakespring.s = 12;
v1.shakespring.d = 0.65;
v1.magspring.s = 12;
v1.magspring.d = 1;
v1.swayspring.s = 4;
v1.swayspring.d = 1;
v1.swayspeed.s = 6;
v1.swayspeed.d = 1;
v1.swayspeed.t = 1;
v1.zanglespring.s = 8;
v1.offsetspring.s = 16;
v1.currentcamera.CameraType = "Scriptable";
local v15 = v7.new(Vector3.zero);
v15.s = 32;
v15.d = 0.65;
local v16 = v7.new(Vector3.zero);
v16.s = 20;
v16.d = 0.75;
local v17 = v7.new(Vector3.zero);
v17.s = 16;
v17.d = 0.75;
local v18 = v7.new(Vector3.zero);
v18.s = 10;
v18.d = 0.8;
local v19 = math.tan(45 * v11);
local v20 = v7.new(0);
v20.s = 30;
local v21 = v7.new(0);
v21.s = 30;
function v1.setaimsensitivity(p1, p2)
	v1.sensitivitymult = p2 and v1.aimsensitivity or 1;
	v1.controlleraimmult = p2 and v1.controlleraimsens or 1;
end;
function v1.shake(p3, p4)
	v1.shakespring.a = p4;
end;
function v1.magnify(p5, p6)
	v1.magspring.t = math.log(p6);
end;
function v1.suppress(p7, p8)
	v15.a = p8;
end;
function v1.hit(p9, p10)
	local v22 = v1.cframe:vectorToObjectSpace(p10);
	v16.a = Vector3.new(v22.z, 0, -v22.x) * 0.25;
end;
function v1.setmagnification(p11, p12)
	local v23 = math.log(p12);
	v1.magspring.p = v23;
	v1.magspring.t = v23;
	v1.magspring.v = 0;
end;
function v1.setmagnificationspeed(p13, p14)
	v1.magspring.s = p14;
end;
function v1.setswayspeed(p15, p16)
	v1.swayspeed.t = p16 and 1;
end;
function v1.setsway(p17, p18)
	v1.swayspring.t = p18;
end;
function v1.setgyroaim(p19, p20)
	v1.gyroaiming = p20;
end;
local u1 = nil;
local u2 = nil;
function v1.isspectating(p21)
	local v24 = false;
	if v1.type == "spectate" then
		v24 = u1 and u2;
	end;
	return v24;
end;
local u3 = nil;
local u4 = nil;
function v1.setspectate(p22, p23, p24)
	local v25 = u3.getEntry(p23);
	if v25 then
		v1.type = "spectate";
		u1 = p23;
		u4 = v25;
		u2 = v25:getThirdPersonObject():getBodyPart("head");
		local v26 = u2.CFrame * Vector3.new(1, 1, 6.5);
		v17.t = v26;
		v17.p = v26;
		v17.v = Vector3.zero;
	end;
	v1.forcespectating = p24 and false;
end;
function v1.setfixedcam(p25, p26)
	v1.type = "fixed";
	u2 = p26;
end;
local u5 = nil;
local u6 = {
	c0 = CFrame.new(), 
	c1 = CFrame.new()
};
local l__CFrame_new__7 = CFrame.new;
function v1.setmenucam(p27, p28)
	local l__CharStage__27 = p28:WaitForChild("CharStage");
	local l__GunStage__28 = p28:WaitForChild("GunStage");
	v1.type = "menu";
	u5 = p28;
	u6.c0 = l__CFrame_new__7(l__CharStage__27.CamPos.Position, l__CharStage__27.Focus.Position);
	u6.c1 = l__CFrame_new__7(l__GunStage__28.CamPos.Position, l__GunStage__28.Focus.Position);
end;
function v1.setmenucf(p29, p30, p31)
	u6[p30] = l__CFrame_new__7(p31.CamPos.Position, p31.Focus.Position);
end;
function v1.setmenufov(p32, p33)
	v20.t = p33;
end;
function v1.setmenuspring(p34, p35)
	v21.t = p35;
end;
function v1.setfirstpersoncam(p36)
	v1.type = "firstperson";
	v1.FieldOfView = v1.basefov;
end;
function v1.setdisabled(p37)
	v1.type = "disabled";
end;
local u8 = false;
local l__math_pi__9 = math.pi;
local u10 = 2 * math.pi;
local u11 = 0.016666666666666666;
function v1.setlookvector(p38, p39, p40, p41)
	u8 = true;
	if p40 and p41 then
		local v29 = math.cos(tick());
		local v30 = math.sin(tick());
		p41 = v30 * p40 + v29 * p41;
		p40 = v29 * p40 - v30 * p41;
	end;
	local v31, v32 = v8.toanglesyx(p39);
	local v33 = v31 + (p40 and 0);
	local l__y__34 = v1.angles.y;
	local v35 = Vector3.new(v1.maxangle < v33 and v1.maxangle or (v33 < v1.minangle and v1.minangle or v33), (v32 + (p41 and 0) + l__math_pi__9 - l__y__34) % u10 - l__math_pi__9 + l__y__34, 0);
	v1.delta = (v35 - v1.angles) / u11;
	v1.angles = v35;
end;
function v1.changemenufov(p42, p43)
	local v36 = v20.t + p43;
	if v36 < 0 then
		local v37 = 0;
	else
		v37 = v36 < 3 and v36 or 3;
	end;
	v20.t = v37;
end;
local u12 = false;
local u13 = 0;
local u14 = nil;
local u15 = 0;
local l__CFrame_Angles__16 = CFrame.Angles;
local u17 = nil;
function v1.step(p44)
	u11 = p44;
	if u8 then
		v1.delta = Vector3.zero;
	end;
	if u12 then
		u12 = false;
	else
		u13 = 0;
	end;
	u8 = false;
	if v1.type == "firstperson" and u14.isAlive() then
		local v38 = u14.getCharacterObject();
		local l__CFrame__39 = v38:getRootPart().CFrame;
		local v40 = Vector3.new(0, v38._headheightspring.p, 0);
		v18.t = v38._acceleration;
		u15 = u15 + p44 * v1.swayspeed.p;
		local v41 = 0.5 * v38._speed;
		local v42 = v38._distance * u10 / 4 * 3 / 4;
		local l__p__43 = v1.swayspring.p;
		local v44 = l__CFrame_Angles__16(0, v1.angles.y, 0) * l__CFrame_Angles__16(v1.angles.x, 0, 0) * l__fromaxisangle__10(v1.offsetspring.p) * l__CFrame_Angles__16(0, 0, v1.zanglespring.p);
		v1.basecframe = v44 + l__CFrame__39 * v40;
		local v45 = v44 * l__fromaxisangle__10(v1.shakespring.p) * l__fromaxisangle__10(v41 * math.cos(v42 + 2) / 2048, v41 * math.cos(v42 / 2) / 2048, v41 * math.cos(v42 / 2 + 2) / 4096) * l__fromaxisangle__10(l__p__43 * math.cos(2 * u15 + 2) / 2048, l__p__43 * math.cos(2 * u15 / 2) / 2048, l__p__43 * math.cos(2 * u15 / 2 - 2) / 4096);
		local v46 = v45 * l__fromaxisangle__10(Vector3.new(0, 0, 1):Cross(v18.v / 4096 / 16) * Vector3.new(1, 0, 0)) * l__fromaxisangle__10(v15.p + v16.p) + l__CFrame__39 * v40;
		l__CurrentCamera__13.FieldOfView = 2 * math.atan(math.tan(v1.basefov * v11 / 2) / 2.718281828459045 ^ v1.magspring.p) / v11;
		l__CurrentCamera__13.CFrame = v46;
		v1.shakecframe = v45 + l__CFrame__39 * v40;
		v1.cframe = v46;
		v1.lookvector = v46.lookVector;
	elseif v1.type == "spectate" then
		if u1 and u4 and u1 ~= l__LocalPlayer__12 and u2 and u17.isPlayerAlive(u1) then
			if u4 then
				u4:step(3, true);
			end;
			local l__CFrame__47 = u2.CFrame;
			local l__p__48 = l__CFrame__47.p;
			local l__x__49 = l__p__48.x;
			local v50 = true;
			if l__x__49 == l__x__49 then
				v50 = true;
				if l__x__49 ~= (1 / 0) then
					v50 = l__x__49 == (-1 / 0);
				end;
			end;
			if not v50 then
				local l__y__51 = l__p__48.y;
				local v52 = true;
				if l__y__51 == l__y__51 then
					v52 = true;
					if l__y__51 ~= (1 / 0) then
						v52 = l__y__51 == (-1 / 0);
					end;
				end;
				if not v52 then
					local l__z__53 = l__p__48.z;
					local v54 = true;
					if l__z__53 == l__z__53 then
						v54 = true;
						if l__z__53 ~= (1 / 0) then
							v54 = l__z__53 == (-1 / 0);
						end;
					end;
					if v54 then
						return;
					elseif v1.spectatetype == "thirdperson" then
						local v55, v56 = v8.toanglesyx(l__CFrame__47.lookVector);
						local v57 = l__CFrame_Angles__16(0, v56, 0) * l__CFrame_Angles__16(v55, 0, 0) + v17.p;
						if v57.RightVector:Dot(l__CFrame__47.RightVector) < 0 then
							v57 = v57 * l__CFrame_Angles__16(0, 0, l__math_pi__9);
						end;
						local v58 = v57 * CFrame.new(1, 1, 0);
						v17.t = l__p__48;
						local v59 = v58 * Vector3.new(0, 0, 6.5) - v58.Position;
						v1.cframe = v58 + v4.sweep(l__CurrentCamera__13, v58, v59, { u2, workspace.Terrain, workspace.Ignore }) * v59;
						v1.lookvector = v1.cframe.lookVector;
						l__CurrentCamera__13.CFrame = v1.cframe;
					elseif v1.spectatetype == "firstperson" then
						local v60, v61 = v8.toanglesyx(l__CFrame__47.lookVector);
						local v62 = l__CFrame_Angles__16(0, v61, 0) * l__CFrame_Angles__16(v60, 0, 0) + l__p__48;
						l__CurrentCamera__13.CFrame = v62;
						v1.cframe = v62;
						v1.lookvector = v62.lookVector;
					end;
				else
					return;
				end;
			else
				return;
			end;
		elseif not v1.forcespectating and not u17.isPlayerAlive(u1) then
			u1 = nil;
			u4 = nil;
			u2 = nil;
			if v1.lastDeathCFrame then
				v1:setfixedcam(v1.lastDeathCFrame);
			end;
		end;
		l__CurrentCamera__13.FieldOfView = v1.basefov;
	elseif v1.type == "fixed" then
		if u2 then
			local v63 = u2 * l__CFrame_new__7(0, 1, 2);
			l__CurrentCamera__13.CFrame = v63;
			v1.cframe = v63;
			v1.lookvector = v1.cframe.lookVector;
		end;
		l__CurrentCamera__13.FieldOfView = v1.basefov;
	end;
	v6.step(l__CurrentCamera__13.CFrame, l__CurrentCamera__13.ViewportSize, l__CurrentCamera__13.FieldOfView);
end;
function v1.setdirectlookmode(p45)
	if v1.directlook == p45 then
		return;
	end;
	v1.directlook = p45;
	if not p45 then
		v1.offsetspring.t = Vector3.zero;
	end;
end;
local function u18(p46, p47, p48)
	local v64 = nil;
	local v65 = nil;
	local v66 = nil;
	local v67 = nil;
	local v68 = nil;
	local v69 = nil;
	local v70 = nil;
	local v71 = nil;
	local v72 = nil;
	local v73 = nil;
	local v74 = nil;
	local v75 = nil;
	v68, v69, v70, v71, v72, v66, v65, v73, v64, v74, v75, v67 = p46:components();
	if v73 < 0 then
		local v76 = math.atan2(-v64, -math.sqrt(v65 * v65 + v73 * v73));
		local v77 = math.atan2(-v66, -v67);
		local v78 = math.atan2(-v65, -v73);
	else
		v76 = math.atan2(-v64, math.sqrt(v65 * v65 + v73 * v73));
		v77 = math.atan2(v66, v67);
		v78 = math.atan2(v65, v73);
	end;
	local v79 = (p47 + p48) / 2;
	local v80 = (v76 - v79 + math.pi) % (2 * math.pi) - math.pi + v79;
	local v81 = (p47 + p48) / 2;
	local v82 = (math.pi - v76 - v81 + math.pi) % (2 * math.pi) - math.pi + v81;
	if (not (p47 <= v80) or not (v80 <= p48)) and not (v82 < p47) and not (p48 < v82) then
		return v82, (v77 + math.pi - 0 + math.pi) % (2 * math.pi) - math.pi + 0, (v78 + math.pi - 0 + math.pi) % (2 * math.pi) - math.pi + 0;
	end;
	return v80, v77, v78;
end;
local function u19(p49, p50, p51)
	local v83 = nil;
	local v84 = nil;
	local v85 = nil;
	local v86 = nil;
	local v87 = nil;
	local v88 = nil;
	local v89 = nil;
	local v90 = nil;
	local v91 = nil;
	local v92 = nil;
	local v93 = nil;
	local v94 = nil;
	v87, v88, v89, v90, v84, v83, v91, v92, v93, v94, v86, v85 = p49:components();
	local v95 = math.atan2(-v93, v92);
	local v96 = math.atan2(-v94, v90);
	if v95 < p50 then
		local v97 = math.cos(p50);
		local v98 = math.sin(p50);
		return p50, math.atan2(-v94 + v83 * v97 + v84 * v98, v90 + v85 * v97 + v86 * v98);
	end;
	if p51 < v95 then
		local v99 = math.cos(p51);
		local v100 = math.sin(p51);
		v95 = p51;
		v96 = math.atan2(-v94 + v83 * v99 + v84 * v100, v90 + v85 * v99 + v86 * v100);
	end;
	return v95, v96;
end;
local function u20(p52)
	if not v1.directlookenabled or not v1.directlook then
		local v101 = v1.angles.y + p52.y;
		local v102 = math.clamp(v1.angles.x + p52.x, v1.minangle, v1.maxangle);
		local v103, v104 = (l__CFrame_Angles__16(0, v1.angles.y, 0) * l__CFrame_Angles__16(v1.angles.x, 0, 0) * l__fromaxisangle__10(v1.offsetspring.p)):toObjectSpace(l__CFrame_Angles__16(0, v101, 0) * l__CFrame_Angles__16(v102, 0, 0) * l__fromaxisangle__10(v1.offsetspring.p)):toAxisAngle();
		v1.delta = v104 * v103 / u11;
		v1.angles = Vector3.new(v102, v101, 0);
		return;
	end;
	local l__p__105 = v1.zanglespring.p;
	local v106 = l__CFrame_Angles__16(0, v1.angles.y, 0) * l__CFrame_Angles__16(v1.angles.x, 0, 0) * l__fromaxisangle__10(v1.offsetspring.p) * l__fromaxisangle__10(p52);
	local v107, v108 = u19(v106, v1.minangle, v1.maxangle);
	local l__y__109 = v1.angles.y;
	local v110 = (v108 - l__y__109 + math.pi) % (2 * math.pi) - math.pi + l__y__109;
	v1.delta = p52 / u11;
	v1.angles = Vector3.new(v107, v110, 0);
	local v111, v112 = (l__CFrame_Angles__16(0, v110, 0) * l__CFrame_Angles__16(v107, 0, 0)):toObjectSpace(v106):toAxisAngle();
	local v113 = v112 * v111;
	v1.offsetspring.p = v113;
	v1.offsetspring.t = v113;
end;
v9.touch.onlookmove:connect(function(p53)
	u8 = true;
	local v114 = 4 * v1.sensitivity * v1.sensitivitymult / (32 * l__math_pi__9);
	if v1.directlookenabled and v1.directlook then
		local v115 = v114 * math.atan(math.tan(v1.basefov * v11 / 2) / 2.718281828459045 ^ v1.magspring.p);
		local v116 = Vector3.new(-v115 * p53.y * v1.xinvert, -v115 * p53.x, 0);
	else
		local v117 = v114 * math.atan(math.tan(v1.basefov * v11 / 2) / 2.718281828459045 ^ v1.magspring.p);
		local v118 = math.cos(v1.angles.x);
		v116 = Vector3.new(-v117 * p53.y * v1.xinvert, -(v117 * (1 - (1 - v118) ^ (v114 * math.atan(math.tan(v1.basefov * v11 / 2)) / v117)) / v118) * p53.x, 0);
	end;
	u20(v116);
end);
v5.rotationChanged:connect(function(p54, p55)
	if v1.gyroaiming then
		print("gyroaimang");
		u20(math.atan(math.tan(v1.basefov * v11 / 2) / 2.718281828459045 ^ v1.magspring.p) / (v1.basefov * v11 / 2) * Vector3.new(1, 1, 0) * p55);
	end;
end);
v9.mouse.onmousemove:connect(function(p56)
	u8 = true;
	local v119 = v1.sensitivity * v1.sensitivitymult / (32 * l__math_pi__9);
	if v1.directlookenabled and v1.directlook then
		local v120 = v119 * math.atan(math.tan(v1.basefov * v11 / 2) / 2.718281828459045 ^ v1.magspring.p);
		local v121 = Vector3.new(-v120 * p56.y * v1.xinvert, -v120 * p56.x, 0);
	else
		local v122 = v119 * math.atan(math.tan(v1.basefov * v11 / 2) / 2.718281828459045 ^ v1.magspring.p);
		local v123 = math.cos(v1.angles.x);
		v121 = Vector3.new(-v122 * p56.y * v1.xinvert, -(v122 * (1 - (1 - v123) ^ (v119 * math.atan(math.tan(v1.basefov * v11 / 2)) / v122)) / v123) * p56.x, 0);
	end;
	u20(v121);
end);
v1.prevControllerDelta = Vector3.zero;
v9.controller.onintegralmove:connect(function(p57, p58)
	local v124 = nil;
	if p57 ~= Vector3.zero then
		u12 = true;
		u8 = true;
	end;
	p57 = p57.magnitude ^ (v1.controllersenspower - 1) * p57;
	local v125 = 15 * p58 * v1.controllersens * v1.controlleraimmult * math.atan(math.tan(v1.basefov * v11 / 2) / 2.718281828459045 ^ v1.magspring.p);
	local v126 = math.abs(math.atan2(v1.prevControllerDelta:Cross(p57).z, (v1.prevControllerDelta:Dot(p57))));
	v124 = v1.prevControllerDelta.magnitude;
	local l__magnitude__127 = p57.magnitude;
	if v126 * v1.curveDecelRate == 0 then
		local v128 = v124 + p58 * l__magnitude__127 * v1.controlleraccel;
	else
		local v129 = p58 * l__magnitude__127 * v1.controlleraccel / (v126 * v1.curveDecelRate);
		v128 = v129 + math.exp(-v126 * v1.curveDecelRate) * (v124 - v129);
	end;
	if l__magnitude__127 == 0 then
		v1.prevControllerDelta = Vector3.zero;
	elseif v128 < 0 then
		v1.prevControllerDelta = Vector3.zero;
	elseif v128 < p57.magnitude then
		v1.prevControllerDelta = v128 * p57.unit;
	else
		v1.prevControllerDelta = p57;
	end;
	u20((Vector3.new(v1.controllerymult * v125 * v1.prevControllerDelta.y * v1.xinvert, -v125 * v1.prevControllerDelta.x, 0)));
end);
v3.onSensitivityChanged:connect(function(p59, p60)
	if p59 == "looksens" then
		v1.sensitivity = p60;
		return;
	end;
	if p59 == "aimsens" then
		v1.aimsensitivity = p60;
		return;
	end;
	if p59 == "controllerlooksens" then
		v1.controllersens = p60;
		return;
	end;
	if p59 == "controllersenspower" then
		v1.controllersenspower = p60;
		return;
	end;
	if p59 == "controlleraimsens" then
		v1.controlleraimsens = p60;
		return;
	end;
	if p59 == "controllerverticalmult" then
		v1.controllerymult = p60;
		return;
	end;
	if p59 == "controllerlookaccel" then
		v1.controlleraccel = p60;
		return;
	end;
	if p59 == "controlleraimaccel" then
		v1.controlleraimaccel = p60;
	end;
end);
v3.onSettingChanged:connect(function(p61, p62)
	if p61 == "toggleinvertyaxis" then
		if p62 then
			local v130 = -1;
		else
			v130 = 1;
		end;
		v1.xinvert = v130;
		return;
	end;
	if p61 == "togggledirectangularinput" then
		v1.directlookenabled = p62;
		return;
	end;
	if p61 == "controllercurvedecel" then
		v1.curveDecelRate = p62;
	end;
end);
function v1._init()
	u17 = shared.require("PlayerStatusInterface");
	u3 = shared.require("ReplicationInterface");
	u14 = shared.require("CharacterInterface");
end;
return v1;

