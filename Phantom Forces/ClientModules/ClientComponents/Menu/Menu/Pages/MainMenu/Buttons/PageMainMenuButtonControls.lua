
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("MenuUtils");
local u2 = shared.require("GuiInputInterface");
local u3 = shared.require("MenuPagesInterface");
function v1.init(p1, p2)
	local v2 = p2.ButtonMain:Clone();
	v2.Visible = true;
	v2.Parent = p1;
	u1.setText(v2, "CONTROLS");
	u2.onReleased(v2, function()
		u3.goToPage("PageControlsMenu");
	end);
	return v2;
end;
return v1;

