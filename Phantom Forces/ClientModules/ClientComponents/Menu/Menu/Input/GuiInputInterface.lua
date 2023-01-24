
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("GuiCollisionService");
local v3 = shared.require("GuiInputConfig");
local v4 = shared.require("GuiInputObject");
shared.require("GuiCursor");
local u1 = {};
function v1.getEntry(p1)
	return u1[p1];
end;
function v1.setLayer(p2, p3)
	local v5 = u1[p2];
	if not v5 then
		warn("GuiInputInterface: No guiInputObject found for button frame", p2);
		return;
	end;
	v5:getGuiInterest():setLayer(p3);
end;
function v1.setGroup(p4, p5)
	local v6 = u1[p4];
	if not v6 then
		warn("GuiInputInterface: No guiInputObject found for button frame", p4);
		return;
	end;
	v6:getGuiInterest():setGroup(p5);
end;
function v1.canCollide(p6, p7)
	return v2:canCollide(p6, p7);
end;
function v1.disableCollisions(p8, p9)
	v2:disableCollisions(p8, p9);
end;
function v1.enableCollisions(p10, p11)
	v2:enableCollisions(p10, p11);
end;
function v1.getTopPrecedence(p12)
	local v7 = u1[p12];
	if not v7 then
		warn("GuiInputInterface: No guiInputObject found for button frame", p12);
		return;
	end;
	return v7:getTopPrecedence();
end;
local l__inputTypes__2 = v3.inputTypes;
function v1._init()
	for v8, v9 in next, l__inputTypes__2 do
		v1[v9] = function(p13, p14)
			local v10 = u1[p13];
			if not v10 then
				v10 = v4.new(p13);
				u1[p13] = v10;
			end;
			local u3 = v10:connectInput(v9, p14);
			return function()
				u3();
				local v11 = u1[p13];
				if v11 and v11:hasNoActionFuncs() then
					v11:Destroy();
					u1[p13] = nil;
				end;
			end;
		end;
	end;
	v2:disableCollisions(0, "ScrollingGroup");
end;
return v1;

