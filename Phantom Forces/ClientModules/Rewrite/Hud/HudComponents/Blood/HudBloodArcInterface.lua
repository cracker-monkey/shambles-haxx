
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("HudScreenGui");
local l__Main__3 = v2.getScreenGui().Main;
local l__Templates__4 = l__Main__3.Templates;
local u1 = {};
function v1.getEntry(p1)
	return u1[p1];
end;
local u2 = shared.require("HudBloodArcObject");
function v1.addEntry(p2, p3)
	if u1[p2] then
		u1[p2]:Destroy();
		u1[p2] = nil;
	end;
	u1[p2] = u2.new(p2, p3);
end;
function v1.removEntry(p4)
	if u1[p4] then
		u1[p4]:Destroy();
		u1[p4] = nil;
	end;
end;
function v1.operateOnAllEntries(p5)
	for v5, v6 in next, u1 do
		p5(v5, v6);
	end;
end;
local l__ContainerActive__3 = l__Main__3.ContainerActive;
function v1.clearAllEntries()
	v1.operateOnAllEntries(function(p6, p7)
		v1.removEntry(p6);
	end);
	l__ContainerActive__3.Visible = false;
end;
function v1.step()
	v1.operateOnAllEntries(function(p8, p9)
		if not p9:isExpired() then
			p9:step();
			return;
		end;
		v1.removEntry(p8);
	end);
end;
local u4 = shared.require("CharacterEvents");
local u5 = shared.require("network");
local u6 = shared.require("CameraInterface");
local u7 = shared.require("RenderSteppedRunner");
function v1._init()
	u4.onDespawned:connect(v1.clearAllEntries);
	u5:add("shot", function(p10, p11, p12)
		if not u6.isCameraType("MainCamera") then
			return;
		end;
		local v7 = u6.getActiveCamera("MainCamera");
		v1.addEntry(p10, p11);
		v7:hit((-p12 / 12 + 4.166666666666667) * (v7:getCFrame().p - p11).unit);
	end);
	local u8 = nil;
	v2.getScreenGui():GetPropertyChangedSignal("Enabled"):Connect(function()
		if not v2.isEnabled() then
			if u8 then
				u8();
			end;
			return;
		end;
		if u8 then
			u8();
		end;
		l__ContainerActive__3.Visible = true;
		u8 = u7:addTask("HudBloodArcInterface", v1.step, { "CameraInterface" });
	end);
end;
return v1;

