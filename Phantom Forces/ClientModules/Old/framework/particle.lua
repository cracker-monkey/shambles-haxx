
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("VectorVisualizer");
local u1 = shared.require("BeamObject");
local l__CurrentCamera__2 = workspace.CurrentCamera;
local u3 = {};
local u4 = shared.require("Raycast");
local function u5(p1)
	local v3 = not p1.CanCollide or p1.Transparency == 1;
	return v3;
end;
local u6 = shared.require("ParticleEvents");
function v1.new(p2)
	local v4 = {};
	local v5 = p2.position or Vector3.zero;
	local v6 = p2.velocity or Vector3.zero;
	local v7 = p2.acceleration or Vector3.zero;
	local l__thirdperson__8 = p2.thirdperson;
	if p2.culling ~= nil then
		local l__culling__9 = p2.culling;
	end;
	local v10 = true;
	if p2.cancollide ~= nil then
		v10 = p2.cancollide;
	end;
	if p2.elasticity then

	end;
	local l__penetrationdepth__11 = p2.penetrationdepth;
	local v12 = (p2.visualorigin and v5) - v5;
	local v13 = { p2.physicsignore };
	local l__onplayerhit__14 = p2.onplayerhit;
	local v15 = nil;
	v4.onplayerhit = l__onplayerhit__14;
	v4.physignore = v13;
	v4.velocity = v6;
	v4.acceleration = v7;
	v4.penetrationdepth = l__penetrationdepth__11;
	if not p2.tracerless then
		v15 = u1.new(l__CurrentCamera__2.CFrame, v5 + v12);
		for v16, v17 in next, v15.beams do
			v17.Texture = "rbxassetid://2650195052";
			v17.LightInfluence = 0;
			v17.Brightness = 1.5;
			v17.LightEmission = 1;
			v17.Color = ColorSequence.new(p2.color or Color3.new(1, 1, 1));
		end;
	end;
	function v4.remove()
		u3[v4] = nil;
		if v15 then
			v15:Destroy();
		end;
	end;
	local u7 = os.clock() + (p2.life and 10);
	local u8 = nil;
	local u9 = v5;
	local u10 = v6;
	local u11 = v7;
	local u12 = v10;
	local l__nopenetration__13 = p2.nopenetration;
	local l__ontouch__14 = p2.ontouch;
	local u15 = l__penetrationdepth__11;
	local u16 = p2.physicsonly and false;
	local l__onstep__17 = p2.onstep;
	local u18 = p2.size and 1;
	local u19 = p2.bloom and 0;
	local u20 = p2.brightness and 1;
	function v4.step(p3, p4, p5)
		if u7 and u7 < p4 then
			v4.remove();
			return;
		end;
		if not u8 then
			local v18 = p3 * u10 + p3 * p3 / 2 * u11;
			if u12 then
				local v19 = u4.raycast(u9, v18, v13, u5, true);
				if v19 then
					local v20 = nil;
					local l__Instance__21 = v19.Instance;
					local l__Position__22 = v19.Position;
					v20 = v19.Normal;
					local l__unit__23 = v18.unit;
					if l__Instance__21.Name == "killbullet" then
						v4.remove();
						return;
					end;
					if l__nopenetration__13 then
						if l__ontouch__14 then
							debug.profilebegin("ontouch");
							l__ontouch__14(v4, l__Instance__21, l__Position__22, v20);
							debug.profileend();
						end;
					else
						local v24 = u4.raycastSingleExit(l__Position__22, l__Instance__21.Size.magnitude * l__unit__23, l__Instance__21);
						if v24 then
							local l__Position__25 = v24.Position;
							local v26 = l__unit__23:Dot(l__Position__25 - l__Position__22);
							if v26 < u15 then
								u15 = u15 - v26;
								if l__ontouch__14 then
									debug.profilebegin("ontouch");
									l__ontouch__14(v4, l__Instance__21, l__Position__22, v20, l__Position__25, v24.Normal);
									debug.profileend();
								end;
							else
								if l__ontouch__14 then
									debug.profilebegin("ontouch");
									l__ontouch__14(v4, l__Instance__21, l__Position__22, v20);
									debug.profileend();
								end;
								v4.remove();
							end;
						end;
						local v27 = v18:Dot(l__Position__22 - u9) / v18:Dot(v18) * p3;
						u9 = l__Position__22 + 0.01 * (u9 - l__Position__22).unit;
						u10 = u10 + v27 * u11;
					end;
					if not u16 then
						table.insert(v13, l__Instance__21);
					end;
				else
					u9 = u9 + v18;
					u10 = u10 + p3 * u11;
				end;
				if l__onplayerhit__14 then
					u6.processHitEvent:fire(v4, v5, u9, u9, u5);
				end;
			else
				u9 = u9 + v18;
				u10 = u10 + p3 * u11;
			end;
		end;
		if l__onstep__17 then
			debug.profilebegin("onstep");
			l__onstep__17(v4, p3);
			debug.profileend();
		end;
		if not p5 then
			debug.profilebegin("beam update");
			if v15 then
				v15:step(l__CurrentCamera__2.CFrame, u9 + v12, u18, u19, u20);
			end;
			debug.profileend();
		end;
	end;
	u3[v4] = true;
	local v28 = {};
	local u21 = {};
	function v28.__index(p6, p7)
		return u21[p7]();
	end;
	local u22 = {};
	function v28.__newindex(p8, p9, p10)
		return u22[p9](p10);
	end;
	function u21.position()
		return u9;
	end;
	function u21.origin()
		return v5;
	end;
	function u21.velocity()
		return u10;
	end;
	function u21.acceleration()
		return u11;
	end;
	function u21.cancollide()
		return u12;
	end;
	function u21.size()
		return u18;
	end;
	function u21.bloom()
		return u19;
	end;
	function u21.brightness()
		return u20;
	end;
	function u21.color()
		return v15.beams[1].Color;
	end;
	function u21.life()
		return u7 - os.clock();
	end;
	function u21.stopmotion()
		return u8;
	end;
	function u22.position(p11)
		u9 = p11;
	end;
	function u22.velocity(p12)
		u10 = p12;
	end;
	function u22.acceleration(p13)
		u11 = p13;
	end;
	function u22.cancollide(p14)
		u12 = p14;
	end;
	function u22.size(p15)
		u18 = p15;
	end;
	function u22.bloom(p16)
		u19 = p16;
	end;
	function u22.brightness(p17)
		u20 = p17;
	end;
	function u22.color(p18)
		for v29, v30 in next, v15.beams do
			v30.Color = p18;
		end;
	end;
	function u22.life(p19)
		u7 = os.clock() + p19;
	end;
	function u22.stopmotion(p20)
		u8 = p20;
	end;
	setmetatable(v4, v28);
	if p2.dt then
		v4.step(p2.dt, os.clock(), true);
	end;
end;
function v1.step(p21)
	local v31 = os.clock();
	for v32 in u3, nil do
		v32.step(p21, v31);
	end;
end;
function v1.reset(p22)
	for v33 in u3, nil do
		v33.remove();
	end;
end;
table.freeze(v1);
return v1;

