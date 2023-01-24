
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("GuiInputInterface");
local u1 = shared.require("Destructor");
local u2 = shared.require("UIToggle");
function v1.new(p1, p2, p3)
	local v3 = setmetatable({}, v1);
	v3._destructor = u1.new();
	v3._toggleButtonHash = p1;
	v3._detoggledFunc = p3;
	v3._activeToggleName = nil;
	v3._activeUIToggles = {};
	for v4, v5 in next, v3._toggleButtonHash do
		local l__buttonFrame__6 = v5.buttonFrame;
		local v7 = u2.new(l__buttonFrame__6, p2);
		v3._activeUIToggles[l__buttonFrame__6] = v7;
		local l__buttonConfig__3 = v5.buttonConfig;
		v3._destructor:add(v7.onToggleChanged:connect(function(p4, p5)
			if p5 then
				return;
			end;
			if not (not p4) or v3._activeToggleName ~= v4 then
				if p4 and v3._activeToggleName ~= v4 then
					v3:setToggle(v4);
				end;
				return;
			end;
			if not v3._detoggledFunc then
				v7:setToggleState(true);
				return;
			end;
			if l__buttonConfig__3.onUntoggled then
				l__buttonConfig__3.onUntoggled(v4);
			end;
			v3._detoggledFunc(v4);
			v3._activeToggleName = nil;
		end));
		v3._destructor:add(v7);
	end;
	return v3;
end;
function v1.Destroy(p6)
	p6._destructor:Destroy();
end;
function v1.setToggle(p7, p8, p9)
	if p7._activeToggleName == p8 then
		return;
	end;
	local v8 = nil;
	local l___activeToggleName__9 = p7._activeToggleName;
	local l__next__10 = next;
	local l___toggleButtonHash__11 = p7._toggleButtonHash;
	local v12 = nil;
	while true do
		local v13 = nil;
		local v14, v15 = l__next__10(l___toggleButtonHash__11, v12);
		if not v14 then
			break;
		end;
		v12 = v14;
		v13 = v15.buttonConfig;
		local l__buttonFrame__16 = v15.buttonFrame;
		if v14 == p8 then
			v8 = true;
			if not p9 then
				v13.onToggled(v14);
			end;
			p7._activeToggleName = v14;
			p7._activeUIToggles[l__buttonFrame__16]:setToggleState(true);
		else
			if not p9 and v14 == l___activeToggleName__9 and v13.onUntoggled then
				v13.onUntoggled(v14);
			end;
			p7._activeUIToggles[l__buttonFrame__16]:setToggleState(false);
		end;	
	end;
	if v8 then
		return;
	end;
	warn("UIToggleGroup: Did not find toggle", p8);
end;
return v1;

