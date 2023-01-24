
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = shared.require("MenuUtils");
local u2 = shared.require("GuiInputInterface");
local l__ContainerSquadDeploy__3 = shared.require("PageMainMenuInterface").getPageFrame().ContainerSquadDeploy;
local u4 = shared.require("PlayerStatusInterface");
function v1.init(p1, p2)
	local v2 = p2.ButtonMainSquad:Clone();
	v2.Visible = true;
	v2.Parent = p1;
	u1.setText(v2, "SQUAD DEPLOY");
	u2.onReleased(v2, function()
		l__ContainerSquadDeploy__3.Visible = not l__ContainerSquadDeploy__3.Visible;
	end);
	l__ContainerSquadDeploy__3.Visible = false;
	u2.onReleased(v2.CheckBox, function()
		local v3 = u4.getDisableAllState();
		u4.setDisableAllState(not v3);
		v2.CheckBox.CheckBoxFrame.Visible = v3;
	end);
	v2.CheckBox.CheckBoxFrame.Visible = not u4.getDisableAllState();
	return v2;
end;
return v1;

