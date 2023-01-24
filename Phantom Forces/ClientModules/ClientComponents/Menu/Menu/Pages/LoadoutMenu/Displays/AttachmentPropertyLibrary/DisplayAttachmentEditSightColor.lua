
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("ActiveLoadoutEvents");
local v3 = shared.require("network");
local v4 = Color3.new();
local l__displayColorBarConfig__5 = shared.require("PageLoadoutMenuConfig").displayColorBarConfig;
local u1 = shared.require("MenuWeaponDisplayInterface");
local u2 = shared.require("PlayerDataUtils");
local u3 = shared.require("PlayerDataStoreClient");
local u4 = shared.require("ContentDatabase");
local l__Templates__5 = shared.require("PageLoadoutMenuInterface").getPageFrame().Templates;
local u6 = shared.require("RichTextUtils");
local u7 = shared.require("MenuColorConfig");
local u8 = shared.require("MenuUtils");
local u9 = shared.require("UISlider");
local u10 = shared.require("ActiveLoadoutUtils");
local u11 = shared.require("PageLoadoutMenuEvents");
local u12 = shared.require("ActiveLoadoutInterfaceClient");
local function u13(p1)
	local v6 = BrickColor.new(p1);
	return {
		r = math.round(v6.Color.R * 255), 
		g = math.round(v6.Color.G * 255), 
		b = math.round(v6.Color.B * 255)
	};
end;
local u14 = shared.require("GuiInputInterface");
local u15 = shared.require("UIHighlight");
function v1.activate(p2, p3, p4)
	local v7, v8, v9 = u1.getActiveWeaponDataToDisplay();
	local v10 = v9[p3];
	if not v10 then
		return;
	end;
	local v11 = u2.getAttachmentKills(u3.getPlayerData(), v7, v10);
	local v12 = nil;
	local v13 = nil;
	local v14 = u4.getAttachmentModel(v10);
	if v14 and v14:FindFirstChild("SightMark") and v14.SightMark:FindFirstChild("SurfaceGui") then
		local l__SurfaceGui__15 = v14.SightMark.SurfaceGui;
		if l__SurfaceGui__15:FindFirstChild("Border") and l__SurfaceGui__15.Border:FindFirstChild("Scope") then
			v13 = l__SurfaceGui__15.Border.Scope;
			local l__ImageColor3__16 = v13.ImageColor3;
			v12 = {
				r = math.round(l__ImageColor3__16.r * 255), 
				g = math.round(l__ImageColor3__16.g * 255), 
				b = math.round(l__ImageColor3__16.b * 255)
			};
		end;
	end;
	if not v12 then
		local v17 = l__Templates__5.DisplayEditSightColorsBlock:Clone();
		v17.TextDesc.Text = "Sight colors is unsupported for this attachment";
		v17.Size = UDim2.fromOffset(405, 90);
		v17.TitleAttachmentName.Design.TextFrame.Text = string.upper(v10);
		v17.Parent = p2;
		p4:add(v17);
	elseif v11 < u2.sightColorKillReq then
		local v18 = l__Templates__5.DisplayEditSightColorsBlock:Clone();
		v18.Size = UDim2.fromOffset(405, 110);
		v18.TitleAttachmentName.Design.TextFrame.Text = string.upper(v10);
		v18.TextDesc.Text = "Need " .. u6.formatTextColor3(u2.sightColorKillReq, u7.creditsColor) .. " sight kills to unlock sight colors\nCurrent attachment kills:\t\t\t" .. u6.formatTextColor3(v11, u7.creditsColor);
		v18.Parent = p2;
		p4:add(v18);
	else
		local v19 = l__Templates__5.DisplayEditSightColors:Clone();
		v19.Parent = p2;
		local v20 = u4.getAttachmentData(v10, v7, p3);
		local v21 = v20 and v20.stats and v20.stats.imgres or Vector2.new(512, 512);
		local u16 = {
			r = 255, 
			g = 255, 
			b = 255
		};
		local v22 = u2.getAttachmentSettings(u3.getPlayerData(), v7, v10).sightcolor and v12;
		u16.r = v22.r;
		u16.g = v22.g;
		u16.b = v22.b;
		for v23, v24 in next, { "r", "g", "b" } do
			local v25 = v19.ContainerColorBar["DisplayColorBar" .. string.upper(v24)];
			local v26 = u9.new(v25);
			v26:setBounds(0, 255);
			v26:setValue(u16[v24]);
			p4:add(v26);
			p4:add(v26.onChanged:connect(function(p5)
				v25.TextBox.Text = math.round(p5);
				u16[v24] = p5;
				u10.changeSightColors(u3.getPlayerData(), v7, v10, u16);
				u11.onWeaponStatsChanged:fire();
			end));
			p4:add(v26.onDragEnded:connect(function(p6)
				u12.changeSightColors(v7, v10, u16);
			end));
			p4:add(u11.onSightColorChanged:connect(function()
				v26:setValue(u16[v24]);
			end));
		end;
		local function u17()
			local v27 = Color3.fromRGB(u16.r, u16.g, u16.b);
			v19.TitleColorName.Design.TextFrame.Text = string.upper(BrickColor.new(v27).Name);
			v19.TitleAttachmentName.Design.TextFrame.Text = string.upper(v10);
			u8.setBackgroundColor3(v19.DisplayColorValue, v27);
			v19.ImageScope.ImageColor3 = v27;
			v19.ImageScope.ImageRectOffset = Vector2.new(v21.x / 4, v21.y / 4);
			v19.ImageScope.ImageRectSize = Vector2.new(v21.x / 2, v21.y / 2);
			v19.ImageScope.Image = v13 and v13.Image or "";
		end;
		p4:add(u11.onWeaponStatsChanged:connect(function()
			u17();
		end));
		p4:add(v19.TextBoxEnterColor.FocusLost:Connect(function()
			local l__Text__28 = v19.TextBoxEnterColor.Text;
			if l__Text__28 == "" then
				return;
			end;
			local v29 = u13(l__Text__28);
			u12.changeSightColors(v7, v10, v29);
			local v30 = u2.getAttachmentSettings(u3.getPlayerData(), v7, v10).sightcolor or v12;
			u16.r = v30.r;
			u16.g = v30.g;
			u16.b = v30.b;
			u11.onSightColorChanged:fire();
			print("input text", l__Text__28, v29);
		end));
		p4:add(u14.onReleased(v19.TextBoxEnterColor, function()
			v19.TextBoxEnterColor:CaptureFocus();
		end));
		p4:add(u14.onPressedOff(v19.TextBoxEnterColor, function()
			v19.TextBoxEnterColor:ReleaseFocus();
		end));
		p4:add(u14.onReleased(v19.ButtonReset, function()
			u12.changeSightColors(v7, v10);
			local v31 = u2.getAttachmentSettings(u3.getPlayerData(), v7, v10).sightcolor or v12;
			u16.r = v31.r;
			u16.g = v31.g;
			u16.b = v31.b;
			u11.onSightColorChanged:fire();
		end));
		p4:add(u15.new(v19.ButtonReset, {
			highlightColor3 = u7.subMenuColorConfig.highlighted.BackgroundColor3, 
			defaultColor3 = u7.subMenuColorConfig.default.BackgroundColor3
		}));
		p4:add(v19);
		u17();
	end;
end;
function v1.init(p7)
	u8.setText(p7, "SIGHT COLOR");
end;
return v1;

