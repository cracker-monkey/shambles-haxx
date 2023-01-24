
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
local u1 = {};
function v1.getEntry(p1)
	return u1[p1];
end;
local u2 = shared.require("HudNameTagObject");
function v1.addEntry(p2)
	if u1[p2] then
		u1[p2]:Destroy();
		u1[p2] = nil;
	end;
	u1[p2] = u2.new(p2);
end;
function v1.removeEntry(p3)
	if u1[p3] then
		u1[p3]:Destroy();
		u1[p3] = nil;
	end;
end;
function v1.operateOnAllEntries(p4)
	for v3, v4 in next, u1 do
		p4(v3, v4);
	end;
end;
function v1.step()
	v1.operateOnAllEntries(function(p5, p6)
		p6:step();
	end);
end;
local u3 = shared.require("PlayerStatusEvents");
local u4 = shared.require("ReplicationEvents");
local u5 = shared.require("PlayerSettingsInterface");
local u6 = shared.require("RenderSteppedRunner");
local u7 = shared.require("HudScreenGui");
function v1._init()
	u3.onPlayerSpawned:connect(function(p7)
		v1.addEntry(p7);
	end);
	u3.onPlayerDied:connect(function(p8)
		v1.removeEntry(p8);
	end);
	u4.onEntryRemoved:connect(function(p9)
		v1.removeEntry(p9);
	end);
	local u8 = nil;
	local function u9()
		if not u5.getValue("togglenametags") then
			return;
		end;
		if u8 then
			u8();
		end;
		u8 = u6:addTask("HudNameTagInterface", v1.step, { "CharacterInterface", "CameraInterface" });
	end;
	u7.getScreenGui():GetPropertyChangedSignal("Enabled"):Connect(function()
		if u7.isEnabled() then
			u9();
			return;
		end;
		if u8 then
			u8();
		end;
	end);
end;
return v1;

