
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PageMainMenuConfig");
local v3 = shared.require("PageMainMenuInterface").getPageFrame();
local u1 = shared.require("MenuUtils");
local l__ContainerLoadout__2 = v3.ContainerLoadout;
local u3 = shared.require("MenuColorConfig");
local u4 = shared.require("ActiveLoadoutEvents");
local function u5(p1)
	u1.setText(l__ContainerLoadout__2.DisplayLoadoutClass, string.upper(p1));
	u1.setBackgroundColor3(l__ContainerLoadout__2.DisplayLoadoutClass, u3.menuColorConfig.default.BackgroundColor3);
end;
local u6 = { "Primary", "Secondary", "Grenade", "Knife" };
local l__Templates__7 = v3.Templates;
local u8 = shared.require("ContentDatabase");
local u9 = shared.require("LoadoutConfig");
local u10 = shared.require("UIExpander");
local u11 = shared.require("ActiveLoadoutUtils");
local u12 = shared.require("PlayerDataStoreClient");
local u13 = shared.require("GuiInputInterface");
local u14 = shared.require("UIHighlight");
function v1._init()
	u1.clearContainer(l__ContainerLoadout__2, function(p2)
		return p2.Name == "DisplayLoadoutClass";
	end);
	u4.onClassChanged:connect(u5);
	for v4 = 1, #u6 do
		local u15 = u6[v4];
		local u16 = l__Templates__7.DisplayLoadoutSlot:Clone();
		local u17 = nil;
		local function u18(p3)
			local v5 = p3[u15];
			u16.DisplayLoadoutName.TextFrameSlot.Text = u15;
			u16.DisplayLoadoutName.TextFrameWeapon.Text = u8.getWeaponDisplayName(v5.Name, v5.Attachments);
			u1.clearContainer(u16.ContainerAttachments, function(p4)
				return p4:IsA("Folder");
			end);
			if u17 then
				u17:Destroy();
				u17 = nil;
			end;
			local v6 = 0;
			local l__next__7 = next;
			local v8 = u9.attachmentSlots[u15];
			local v9 = nil;
			while true do
				local v10, v11 = l__next__7(v8, v9);
				if not v10 then
					break;
				end;
				local v12 = v5.Attachments and v5.Attachments[v11];
				local v13 = l__Templates__7.DisplayAttachment:Clone();
				v13.TextFrameSlot.Text = v11;
				if not v12 or v12 == "" then
					local v14 = "Default";
				else
					v14 = u8.getAttachmentDisplayName(v12);
				end;
				v13.TextFrameAttachment.Text = v14;
				v13.Parent = u16.ContainerAttachments;
				v6 = v6 + 1;			
			end;
			if v6 > 0 then
				u17 = u10.new(u16, {
					size0 = UDim2.new(1, 0, 0, 30), 
					size1 = UDim2.new(1, 0, 0, 30 + v6 * 25)
				});
				u17:open();
			end;
		end;
		u4.onLoadoutChanged:connect(function(p5, p6)
			u18(p6);
		end);
		u4.onClassChanged:connect(function()
			u18(u11.getActiveLoadoutData(u12.getPlayerData()));
		end);
		u13.onReleased(u16.DisplayLoadoutName, function()
			if u17 then
				u17:toggle();
			end;
		end);
		local v15 = u14.new(u16.DisplayLoadoutName, {
			highlightColor3 = Color3.fromRGB(156, 156, 156), 
			defaultColor3 = Color3.fromRGB(223, 223, 223)
		});
		u16.Parent = l__ContainerLoadout__2;
	end;
end;
return v1;

