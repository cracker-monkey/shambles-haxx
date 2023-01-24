
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__PageCreditsMenu__1 = shared.require("MenuScreenGui").getScreenGui():FindFirstChild("PageCreditsMenu", true);
function v1.getPageFrame()
	return l__PageCreditsMenu__1;
end;
function v1._init()
	l__PageCreditsMenu__1.Visible = true;
end;
return v1;

