
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("RenderSteppedRunner");
local v3 = shared.require("UIScaleUpdater");
local v4 = shared.require("HudScreenGui");
local l__DisplayStatus__5 = v4.getScreenGui().Main.DisplayStatus;
local l__TextMagCount__1 = l__DisplayStatus__5.TextMagCount;
local l__TextSpareCount__2 = l__DisplayStatus__5.TextSpareCount;
local l__TextGrenadeCount__3 = l__DisplayStatus__5.TextGrenadeCount;
function v1.updateAmmo(p1)
	local v6 = p1:getWeaponType();
	if v6 == "Firearm" then
		l__TextMagCount__1.Text = p1:getMagCount();
		l__TextSpareCount__2.Text = p1:getSpareCount();
		return;
	end;
	if v6 == "Melee" then
		l__TextMagCount__1.Text = "- - -";
		l__TextSpareCount__2.Text = "- - -";
		return;
	end;
	if v6 == "Grenade" then
		l__TextMagCount__1.Text = "- - -";
		l__TextSpareCount__2.Text = "- - -";
		l__TextGrenadeCount__3.Text = "x" .. p1:getSpareCount();
	end;
end;
local l__TextFiremode__4 = l__DisplayStatus__5.TextFiremode;
function v1.updateFiremode(p2)
	if p2:getWeaponType() ~= "Firearm" then
		l__TextFiremode__4.Text = "- - -";
		return;
	end;
	local v7 = p2:getFiremode();
	if v7 == true then
		local v8 = "AUTO";
	elseif v7 == 1 then
		v8 = "SEMI";
	elseif v7 == "BINARY" then
		v8 = "BINARY";
	else
		v8 = "BURST";
	end;
	l__TextFiremode__4.Text = v8;
end;
local l__DisplayHealth__5 = l__DisplayStatus__5.DisplayHealth;
local u6 = 0;
local l__ImageBloodScreen__7 = v4.getScreenGui().Main.ImageBloodScreen;
local u8 = { Color3.new(0.14901960784313725, 0.3137254901960784, 0.2784313725490196), Color3.new(0.17647058823529413, 0.5019607843137255, 0.43137254901960786), Color3.new(0.8745098039215686, 0.12156862745098039, 0.12156862745098039), Color3.new(0.5333333333333333, 0.06666666666666667, 0.06666666666666667) };
function v1.updateHealth(p3)
	local v9 = p3:getHealth();
	local v10 = p3:getMaxHealth();
	l__DisplayHealth__5.TextHealth.Text = v9 + -v9 % 1;
	if v9 < u6 then
		local v11 = u6 - v9;
		l__ImageBloodScreen__7.ImageTransparency = l__ImageBloodScreen__7.ImageTransparency - v11 / u6 * 0.7;
		l__ImageBloodScreen__7.BackgroundTransparency = l__ImageBloodScreen__7.BackgroundTransparency - v11 / u6 * 0.5 + 0.3;
	elseif u6 < v9 or v9 == v10 then
		if l__ImageBloodScreen__7.ImageTransparency < 1 then
			l__ImageBloodScreen__7.ImageTransparency = l__ImageBloodScreen__7.ImageTransparency + 0.001;
		end;
		if l__ImageBloodScreen__7.BackgroundTransparency < 1 then
			l__ImageBloodScreen__7.BackgroundTransparency = l__ImageBloodScreen__7.BackgroundTransparency + 0.001;
		end;
	end;
	if v9 <= v10 / 4 then
		l__DisplayHealth__5.BackgroundColor3 = u8[4];
		l__DisplayHealth__5.Percent.BackgroundColor3 = u8[3];
	else
		l__DisplayHealth__5.BackgroundColor3 = u8[1];
		l__DisplayHealth__5.Percent.BackgroundColor3 = u8[2];
	end;
	l__DisplayHealth__5.Percent.Size = UDim2.new(math.floor(v9) / v10, 0, 1, 0);
	u6 = v9;
end;
function v1.toggleKidFriendlyDamage(p4)
	if p4 then
		l__ImageBloodScreen__7.BackgroundColor3 = Color3.new();
		l__ImageBloodScreen__7.ImageColor3 = Color3.new();
		return;
	end;
	l__ImageBloodScreen__7.BackgroundColor3 = Color3.new(1, 0, 0.01568627450980392);
	l__ImageBloodScreen__7.ImageColor3 = Color3.new(1, 1, 1);
end;
local u9 = shared.require("CharacterInterface");
function v1.step(p5)
	local v12 = u9.getCharacterObject();
	if not v12 then
		warn("HudStatusInterface: No character object found");
		return;
	end;
	v1.updateHealth(v12);
	local v13 = p5:getActiveWeapon();
	if not v13 then
		warn("HudStatusInterface: No active weapon object found");
		return;
	end;
	v1.updateFiremode(v13);
	v1.updateAmmo(v13);
end;
local u10 = shared.require("CharacterEvents");
local u11 = shared.require("PlayerSettingsInterface");
local u12 = shared.require("PlayerSettingsEvents");
function v1._init()
	u10.onDespawned:connect(function()
		l__DisplayHealth__5.TextHealth.Text = 0;
		l__ImageBloodScreen__7.ImageTransparency = 1;
		l__ImageBloodScreen__7.BackgroundTransparency = 1;
		l__DisplayHealth__5.BackgroundColor3 = u8[4];
		l__DisplayHealth__5.Percent.BackgroundColor3 = u8[3];
		l__DisplayHealth__5.Percent.Size = UDim2.new(0, 0, 1, 0);
	end);
	v1.toggleKidFriendlyDamage(u11.getValue("togglekidfriendlydamage"));
	u12.onSettingChanged:connect(function(p6, p7)
		if p6 == "togglekidfriendlydamage" then
			v1.toggleKidFriendlyDamage(p7);
		end;
	end);
	v4.getScreenGui():GetPropertyChangedSignal("Enabled"):Connect(function()
		if v4.isEnabled() then
			l__DisplayStatus__5.Visible = u11.getValue("toggleammohud");
		end;
	end);
	local l__UIScale__14 = l__DisplayStatus__5.UIScale;
	l__UIScale__14.Scale = u11.getValue("statusscale") and 1;
	u12.onSettingChanged:connect(function(p8, p9)
		if p8 == "statusscale" then
			l__UIScale__14.Scale = p9;
		end;
	end);
end;
return v1;

