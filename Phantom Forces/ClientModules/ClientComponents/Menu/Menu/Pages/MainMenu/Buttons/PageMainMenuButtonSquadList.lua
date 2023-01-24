
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local v2 = shared.require("MenuLobbyInterface");
local v3 = shared.require("MenuScreenGui");
local u1 = shared.require("Destructor");
local l__Templates__2 = shared.require("PageMainMenuInterface").getPageFrame().Templates;
local u3 = shared.require("UIToggle");
local u4 = shared.require("MenuColorConfig");
local u5 = shared.require("MenuCameraEvents");
local u6 = shared.require("UIExpander");
local u7 = shared.require("GuiInputInterface");
local u8 = shared.require("PlayerStatusInterface");
function v1.new(p1, p2)
	local v4 = setmetatable({}, v1);
	v4._destructor = u1.new();
	v4._player = p1;
	v4._buttonFrame = l__Templates__2.ButtonSquadDeploy:Clone();
	v4._buttonFrame.Design.TextFrame.Text = p1.Name;
	v4._buttonFrame.Name = string.lower(p1.Name);
	v4._buttonFrame.Parent = p2;
	v4._destructor:add(v4._buttonFrame);
	v4._statusFrame = v4._buttonFrame.StatusBox.Design.BackFrame;
	v4._toggleObject = u3.new(v4._buttonFrame, u4.squadDeployColorConfig);
	v4._destructor:add(v4._toggleObject);
	v4._destructor:add(v4._toggleObject.onToggleChanged:connect(function(p3, p4)
		if p3 then
			u5.onSpectatePlayerChanged:fire(p1);
			return;
		end;
		if not p3 and not p4 then
			u5.onSpectatePlayerChanged:fire(nil);
		end;
	end));
	v4._displaySquadHint = l__Templates__2.DisplaySquadHint:Clone();
	v4._displaySquadHint.Parent = v4._buttonFrame;
	v4._hintExpander = u6.new(v4._displaySquadHint, {
		size0 = UDim2.new(0, 0, 0, 0), 
		size1 = UDim2.new(0, 300, 0, 130), 
		speed = 65536
	});
	v4._destructor:add(v4._hintExpander);
	v4._destructor:add(u7.onEntered(v4._buttonFrame, function()
		v4._hintExpander:setOpenTarget(UDim2.fromOffset(280, 130));
		v4._hintExpander:open();
	end));
	v4._destructor:add(u7.onExited(v4._buttonFrame, function()
		v4._hintExpander:close();
	end));
	v4._destructor:add(u5.onSpectatePlayerChanged:connect(function(p5)
		if p5 ~= v4._player and v4._toggleObject:getToggleState() then
			v4._toggleObject:setToggleState(false);
		end;
	end));
	v4._destructor:add(u7.onReleased(v4._buttonFrame.CheckBox, function()
		u8.setAllowedState(v4._player, not u8.getAllowedState(v4._player));
	end));
	v4._destructor:add(function()
		if v4:isSelected() then
			u5.onSpectatePlayerChanged:fire(nil);
		end;
	end);
	return v4;
end;
function v1.setToggleState(p6, p7)
	p6._toggleObject:setToggleState(p7);
end;
function v1.isSelected(p8)
	return p8._toggleObject:getToggleState();
end;
function v1.Destroy(p9)
	p9._destructor:Destroy();
end;
local u9 = {
	DEPLOYABLE = {
		boxColor = Color3.fromRGB(51, 125, 51), 
		hintColor = Color3.fromRGB(92, 225, 92), 
		hintText = "You can spawn on this player"
	}, 
	["IN COMBAT"] = {
		boxColor = Color3.fromRGB(255, 216, 61), 
		hintColor = Color3.fromRGB(255, 216, 61), 
		hintText = "Player in combat, spawn unavailable"
	}, 
	DESPAWNED = {
		boxColor = Color3.fromRGB(116, 38, 38), 
		hintColor = Color3.fromRGB(255, 83, 83), 
		hintText = "Player is not currently spawned"
	}, 
	DISABLED = {
		boxColor = Color3.fromRGB(35, 35, 35), 
		hintColor = Color3.fromRGB(255, 83, 83), 
		hintText = "Player disabled squad spawning"
	}, 
	["DEPLOY ENABLED"] = {
		boxColor = Color3.fromRGB(51, 125, 51), 
		hintColor = Color3.fromRGB(92, 225, 92), 
		hintText = "This player can spawn on you"
	}, 
	["DEPLOY DISABLED"] = {
		boxColor = Color3.fromRGB(35, 35, 35), 
		hintColor = Color3.fromRGB(255, 83, 83), 
		hintText = "This player cannot spawn on you"
	}
};
local u10 = shared.require("PlayerSettingsInterface");
function v1.update(p10)
	local v5 = u8.getDeployStatus(p10._player);
	p10._statusFrame.BackgroundColor3 = u9[v5].boxColor;
	p10._displaySquadHint.TextFrameStatus.Text = v5;
	p10._displaySquadHint.TextFrameStatus.TextColor3 = u9[v5].hintColor;
	p10._displaySquadHint.TextFrameStatusHint.Text = u9[v5].hintText;
	local v6 = u8.getAllowedState(p10._player) and not u8.getDisableAllState();
	if v6 then
		local v7 = "DEPLOY ENABLED";
	else
		v7 = "DEPLOY DISABLED";
	end;
	p10._displaySquadHint.TextFrameAllowed.Text = v7;
	p10._displaySquadHint.TextFrameAllowed.TextColor3 = u9[v7].hintColor;
	p10._displaySquadHint.TextFrameAllowedHint.Text = u9[v7].hintText;
	p10._buttonFrame.CheckBox.CheckBoxFrame.Visible = v6;
	if u10.getValue("togglestreamermode") then
		p10._buttonFrame.Design.TextFrame.Text = "Player";
		return;
	end;
	p10._buttonFrame.Design.TextFrame.Text = p10._player.Name;
end;
return v1;

