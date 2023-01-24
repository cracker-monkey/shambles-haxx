
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PlayerSettingsInterface");
local v3 = shared.require("PlayerSettingsEvents");
local v4 = shared.require("MenuPagesInterface");
local v5 = shared.require("MenuCameraEvents");
local v6 = shared.require("CameraInterface");
local v7 = shared.require("MenuPagesEvents");
local v8 = shared.require("MenuScreenGui");
local v9 = shared.require("CameraEvents");
local l__MenuLobby__10 = game:GetService("ReplicatedStorage"):WaitForChild("MenuLobby");
local v11 = shared.require("Collector").new();
v11:watchTag("HideMenu");
function v1.getMenuLobby()
	return l__MenuLobby__10;
end;
local u1 = {
	PageCustomizeMenu = l__MenuLobby__10.CameraCustomize, 
	PageInventoryMenu = l__MenuLobby__10.CameraInventory, 
	PageSettingsMenu = l__MenuLobby__10.CameraSettings, 
	PageLoadoutMenu = l__MenuLobby__10.CameraWeapon, 
	PageMainMenu = l__MenuLobby__10.CameraMain
};
function v1.getTargetNode(p1)
	if not p1 then
		p1 = v4.getCurrentPage();
	end;
	return u1[p1];
end;
function v1.updateCameraTarget(p2)
	local v12 = u1[p2];
	if not v12 then
		warn("MenuLobbyInterface: No targetCFrame found for pageName", p2);
		return;
	end;
	local v13 = v6.getActiveCamera("MenuCamera", true);
	if not v13 then
		return;
	end;
	v13:setTarget(v12.CFrame);
	v13:resetZoom(1);
end;
local l__GUNS__2 = l__MenuLobby__10.Detail.GUNS;
function v1.toggleWeaponModels(p3)
	if not p3 then
		l__GUNS__2.Parent = nil;
		return;
	end;
	l__GUNS__2.Parent = l__MenuLobby__10.Detail;
end;
function v1.showHiddenObjects(p4, p5)
	local l__next__14 = next;
	local v15, v16 = v11:getObjectList();
	while true do
		local v17, v18 = l__next__14(v15, v16);
		if not v17 then
			break;
		end;
		v16 = v17;
		if v18:IsA("BasePart") then
			if p5 then
				local v19 = 0;
			else
				v19 = 1;
			end;
			v18.Transparency = v19;
		elseif v18:IsA("LayerCollector") then
			if p5 then
				local v20 = true;
			else
				v20 = false;
			end;
			v18.Enabled = v20;
		end;	
	end;
end;
function v1._init()
	l__MenuLobby__10:SetPrimaryPartCFrame(CFrame.new(math.random(-5000, 5000), -math.random(1500, 2250), math.random(-5000, 5000)));
	v1.toggleWeaponModels(v2.getValue("togglelobbyweaponmodels"));
	v3.onSettingChanged:connect(function(p6, p7)
		if p6 == "togglelobbyweaponmodels" then
			v1.toggleWeaponModels(p7);
		end;
	end);
	v9.onCameraTypeChanged:connect(function(p8)
		if p8 ~= "MenuCamera" then
			v1:showHiddenObjects(true);
			l__MenuLobby__10.Parent = nil;
			return;
		end;
		v1:showHiddenObjects(false);
		l__MenuLobby__10.Parent = workspace;
		v1.updateCameraTarget(v4.getCurrentPage());
	end);
	for v21, v22 in next, u1 do
		v22.Transparency = 1;
	end;
	v8.onEnabled:connect(function()
		v1:showHiddenObjects(false);
	end);
	v8.onDisabled:connect(function()
		v1:showHiddenObjects(true);
		l__MenuLobby__10.Parent = nil;
	end);
	v11.objectAdded:connect(function(p9)
		if v8.isEnabled() and v6.getCameraType() == "MenuCamera" then
			if p9:IsA("BasePart") then
				p9.Transparency = 1;
				return;
			end;
			if p9:IsA("LayerCollector") then
				p9.Enabled = false;
			end;
		end;
	end);
end;
return v1;

