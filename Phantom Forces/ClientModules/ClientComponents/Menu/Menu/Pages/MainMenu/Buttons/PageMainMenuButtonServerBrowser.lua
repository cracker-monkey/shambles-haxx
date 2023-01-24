
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("MenuUtils");
local u2 = shared.require("GuiInputInterface");
local u3 = shared.require("network");
function v1.init(p1, p2)
	local v2 = p2.ButtonMain:Clone();
	v2.Visible = true;
	v2.Parent = p1;
	u1.setText(v2, "SERVER BROWSER");
	u2.onReleased(v2, function()
		u3:send("teleportwithdata");
	end);
	return v2;
end;
return v1;

