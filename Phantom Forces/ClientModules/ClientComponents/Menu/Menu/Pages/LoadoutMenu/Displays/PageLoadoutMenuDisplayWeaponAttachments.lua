
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PageLoadoutMenuInterface");
local v3 = v2.getPageFrame();
local l__DisplayWeaponAttachments__4 = v3.DisplayWeaponAttachments;
local l__DisplayAttachmentStats__5 = l__DisplayWeaponAttachments__4.DisplayAttachmentStats;
local l__ContainerEdit__6 = l__DisplayWeaponAttachments__4.ContainerEdit;
local u1 = shared.require("PlayerDataStoreClient");
local u2 = shared.require("ActiveLoadoutUtils");
local u3 = shared.require("PlayerDataUtils");
local u4 = shared.require("MenuUtils");
local l__Title__5 = l__DisplayAttachmentStats__5.Title;
local l__DisplayAttachmentKills__6 = l__DisplayAttachmentStats__5.Container.DisplayAttachmentKills;
local u7 = shared.require("ContentDatabase");
local u8 = shared.require("DestructorGroup").new();
local l__Container__9 = l__ContainerEdit__6.ButtonEditAttachments.Container;
local u10 = shared.require("PageLoadoutMenuConfig");
local l__Templates__11 = v3.Templates;
local u12 = shared.require("UIHighlight");
local u13 = shared.require("MenuColorConfig");
local u14 = nil;
local u15 = shared.require("UIExpander");
local u16 = shared.require("GuiInputInterface");
local u17 = shared.require("UIToggleGroup");
local u18 = shared.require("MenuWeaponDisplayInterface");
local l__DisplayAttachmentList__19 = l__DisplayWeaponAttachments__4.DisplayAttachmentList;
local u20 = shared.require("network");
local function u21(p1)
	local v7 = u1.getPlayerData();
	local v8 = v2.getActiveLoadoutSlot();
	local v9 = u2.getActiveLoadoutData(v7);
	local v10 = u3.getAttLoadoutData(v7);
	local l__Name__11 = v9[v8].Name;
	local v12 = v9[v8].Attachments and v9[v8].Attachments[p1];
	local v13 = u3.getAttachmentKills(v7, l__Name__11, v12);
	if not v12 or v12 == "" then
		u4.setText(l__Title__5, "None");
		l__DisplayAttachmentKills__6.TextFrameValue.Text = "N/A";
		return;
	end;
	u4.setText(l__Title__5, string.upper(u7.getAttachmentData(v12, l__Name__11, p1).displayname and v12));
	l__DisplayAttachmentKills__6.TextFrameValue.Text = v13 and 0;
end;
local function u22(p2)
	local v14 = u8:runAndReplace("attachmentEditList");
	u4.clearContainer(l__Container__9);
	local v15 = u10.editAttachmentConfig[p2];
	if not v15 then
		warn("PageLoadoutMenuDisplayWeaponAttachments: Invalid edit name given", p2);
		return;
	end;
	local v16 = false;
	local v17 = {};
	for v18, v19 in next, v15 do
		local v20 = l__Templates__11.ButtonWeaponList:Clone();
		local v21 = shared.require(v19);
		v21.init(v20);
		v14:add(u12.new(v20, {
			highlightColor3 = u13.weaponListColorConfig.highlighted.BackgroundColor3, 
			defaultColor3 = u13.weaponListColorConfig.default.BackgroundColor3
		}));
		v14:add(v20);
		v20.Parent = l__Container__9;
		local v22 = {
			buttonFrame = v20
		};
		local v23 = {};
		function v23.onToggled()
			v21.activate(l__DisplayWeaponAttachments__4, p2, (u8:runAndReplace("attachmentPropertyWindow")));
			v20.CheckBox.CheckBoxFrame.Visible = true;
			u14 = v19;
		end;
		function v23.onUntoggled()
			v20.CheckBox.CheckBoxFrame.Visible = false;
		end;
		v22.buttonConfig = v23;
		v17[v19] = v22;
		if u14 == v19 then
			v16 = true;
		end;
	end;
	local v24 = nil;
	if #v15 > 0 then
		v24 = u15.new(l__ContainerEdit__6.ButtonEditAttachments, {
			size0 = UDim2.new(1, 0, 0, 30), 
			size1 = UDim2.new(1, 0, 0, 30 + #v15 * 35)
		});
		v14:add(v24);
	end;
	v14:add(u16.onReleased(l__ContainerEdit__6.ButtonEditAttachments, function()
		if v24 then
			v24:toggle();
		end;
	end));
	local v25 = u17.new(v17, nil, function()
		u8:runAndReplace("attachmentPropertyWindow");
	end);
	v14:add(v25);
	if v16 then
		v25:setToggle(u14);
	end;
	v14:add(function()
		u8:runAndReplace("attachmentPropertyWindow");
	end);
end;
local u23 = shared.require("MenuScreenGui");
local u24 = shared.require("MenuWeaponDisplayEvents");
local u25 = shared.require("ActiveLoadoutEvents");
local u26 = shared.require("UIScrollingList");
local u27 = shared.require("PageLoadoutMenuEvents");
local l__ContainerCategory__28 = l__DisplayWeaponAttachments__4.ContainerCategory;
local l__Title__29 = l__DisplayWeaponAttachments__4.Title;
local u30 = shared.require("LoadoutConfig");
local l__ContainerSlots__31 = l__DisplayWeaponAttachments__4.ContainerSlots;
local function u32(p3)
	local v26 = v2.getActiveLoadoutSlot();
	local v27 = u8:runAndReplace("attachmentCategory");
	u8:runAndReplace("attachmentList");
	local v28 = u2.getActiveLoadoutData(u1.getPlayerData());
	local v29, v30, v31 = u18.getActiveWeaponDataToDisplay();
	local v32 = {};
	for v33 in next, u7.getAttachments(v29)[p3] do
		local v34 = u7.getAttachmentCategory(v33);
		if not v32[v34] then
			v32[v34] = {};
		end;
		table.insert(v32[v34], v33);
	end;
	local u33 = nil;
	local u34 = nil;
	local function u35(p4, p5)
		local v35 = u8:runAndReplace("attachmentList");
		u33 = p4;
		u34 = p5;
		local v36 = l__Templates__11.DisplayWeaponHint:Clone();
		v36.Visible = true;
		v36.Size = UDim2.new(0, 0, 0, 0);
		v36.Parent = l__DisplayWeaponAttachments__4;
		v27:add(v36);
		local v37 = u15.new(v36, {
			size0 = UDim2.new(0, 0, 0, 0), 
			size1 = UDim2.new(0, 280, 0, 50), 
			speed = 65536
		});
		v27:add(v37);
		local v38 = u1.getPlayerData();
		local l__next__39 = next;
		local v40 = nil;
		while true do
			local v41, v42 = l__next__39(p5, v40);
			if not v41 then
				break;
			end;
			local v43 = u7.getAttachmentData(v42, v29, p3);
			local v44 = u3.ownsAttachment(v38, v42, v29, p3);
			local v45 = u3.ownsWeapon(v38, v29);
			local v46 = u7.isTestAttachment(v42);
			local v47 = v43.supertest and false;
			if not v47 or v38.supertester then
				local v48 = v43.unlockkills;
				local v49 = l__Templates__11.ButtonWeaponList:Clone();
				v49.Design.TextFrame.Text = string.upper((u7.getAttachmentDisplayName(v42)));
				v49.Parent = l__DisplayAttachmentList__19.Container;
				v35:add(v49);
				local v50 = u13.weaponListColorConfig;
				if v46 then
					v50 = u13.testWeaponListColorConfig;
					v48 = -1;
				elseif v47 then
					v50 = u13.superTestWeaponListColorConfig;
					v48 = -2;
				elseif not v44 then
					v50 = u13.lockedWeaponListColorConfig;
				end;
				v49.LayoutOrder = v48;
				v49.NewBox.Visible = false;
				v49.KillsColor.Visible = false;
				v35:add(u16.onReleased(v49, function()
					if not v44 or not v45 then
						u18.previewAttachment(v42, p3);
						u22("Empty");
						return;
					end;
					local v51, v52, v53 = u18.getActiveWeaponDataToDisplay();
					if u18.isPreviewing() then
						u18.previewAttachment(nil, p3);
					end;
					if v53[p3] == v42 then
						u2.changeAttachment(v38, v26, p3, nil);
						u20:send("changeAttachment", v26, p3, nil);
					else
						u2.changeAttachment(v38, v26, p3, v42);
						u20:send("changeAttachment", v26, p3, v42);
					end;
					u21(p3);
					u22(p3);
				end));
				v27:add(u16.onEntered(v49, function()
					v36.TextFrameHint.Text = v43.info and "Empty description.";
					v36.TextFrameRank.Text = "Kill Req: " .. (v43.unlockkills and 0);
					v36.TextFrameRank.TextColor3 = u13.weaponRankHintColors[v44].TextColor3;
					if u3.isNewWeapon(v38, v29) then
						v36.TextFrameRank.Text = v36.TextFrameRank.Text .. " [New]";
					end;
					task.wait();
					v36.Position = UDim2.fromOffset(425, (v49.AbsolutePosition.Y - l__DisplayWeaponAttachments__4.AbsolutePosition.Y) / u23.getUIScale());
					v37:setOpenTarget(UDim2.fromOffset(280, 50 + v36.TextFrameHint.TextBounds.Y / u23.getUIScale()));
					v37:open();
				end));
				v27:add(u16.onExited(v49, function()
					v37:close();
				end));
				v27:add(u12.new(v49, {
					highlightColor3 = v50.highlighted.BackgroundColor3, 
					defaultColor3 = v50.default.BackgroundColor3
				}));
				local function v54()
					local v55, v56, v57 = u18.getActiveWeaponDataToDisplay();
					v49.CheckBox.CheckBoxFrame.Visible = v57 and v57[p3] == v42;
				end;
				v35:add(u24.onPreviewChanged:connect(v54));
				v35:add(u25.onLoadoutChanged:connect(v54));
				local v58, v59, v60 = u18.getActiveWeaponDataToDisplay();
				v49.CheckBox.CheckBoxFrame.Visible = v60 and v60[p3] == v42;
			end;		
		end;
		v27:add(u26.new(l__DisplayAttachmentList__19));
		l__DisplayAttachmentList__19.Visible = true;
	end;
	v27:add(u27.onForcedAttachmentListUpdate:connect(function()
		if not u33 or not u34 then
			return;
		end;
		u35(u33, u34);
	end));
	local v61 = {};
	local v62 = nil;
	local v63 = nil;
	for v64, v65 in next, v32 do
		if table.find(v65, v28[v26].Attachments[p3]) then
			v63 = v64;
		elseif not v62 or v64 < v62 then
			v62 = v64;
		end;
		local v66 = l__Templates__11.ButtonLoadoutSlot:Clone();
		u4.setText(v66, string.upper(v64));
		v66.Name = v64;
		v66.Parent = l__ContainerCategory__28;
		v27:add(v66);
		table.sort(v65, function(p6, p7)
			local l__unlockkills__67 = u7.getAttachmentData(p6, v29, p3).unlockkills;
			local l__unlockkills__68 = u7.getAttachmentData(p7, v29, p3).unlockkills;
			if not l__unlockkills__67 then
				return true;
			end;
			if not l__unlockkills__68 then
				return false;
			end;
			return l__unlockkills__67 < l__unlockkills__68;
		end);
		local v69 = {
			buttonFrame = v66
		};
		local v70 = {};
		function v70.onToggled()
			u35(v64, v65);
		end;
		v69.buttonConfig = v70;
		v61[v64] = v69;
	end;
	local v71 = u17.new(v61, u13.weaponClassColorConfig, function()
		u8:runAndReplace("attachmentPropertyWindow");
		u8:runAndReplace("attachmentList");
		l__DisplayAttachmentList__19.CanvasSize = UDim2.new(0, 0, 0, 0);
		l__DisplayAttachmentList__19.Visible = false;
	end);
	v27:add(v71);
	v71:setToggle(v63 and v62);
end;
function v1.updatePage()
	local v72 = v2.getActiveLoadoutSlot();
	local v73 = u8:runAndReplace("attachmentSlot");
	u4.setText(l__Title__29, string.upper(v72 .. " Attachments"));
	local v74 = {};
	local v75 = u30.attachmentSlots[v72];
	for v76, v77 in next, v75 do
		local v78 = l__Templates__11.ButtonLoadoutSlot:Clone();
		u4.setText(v78, string.upper(v77));
		v78.Parent = l__ContainerSlots__31;
		v73:add(v78);
		local v79 = {
			buttonFrame = v78
		};
		local v80 = {};
		function v80.onToggled()
			u14 = nil;
			u32(v77);
			u21(v77);
			u22(v77);
		end;
		v79.buttonConfig = v80;
		v74[v77] = v79;
	end;
	local v81 = u17.new(v74, u13.loadoutClassColorConfig, function()
		u8:runAndReplace("attachmentPropertyWindow");
		u8:runAndReplace("attachmentCategory");
		u8:runAndReplace("attachmentList");
		l__DisplayAttachmentList__19.CanvasSize = UDim2.new(0, 0, 0, 0);
		l__DisplayAttachmentList__19.Visible = false;
	end);
	v73:add(v81);
	v73:add(function()
		u8:runAndReplace("attachmentEditList");
		u14 = nil;
	end);
	l__DisplayAttachmentList__19.CanvasSize = UDim2.new(0, 0, 0, 0);
	l__DisplayAttachmentList__19.Visible = false;
	v81:setToggle(v75[1]);
end;
local u36 = shared.require("UIPrompt");
function v1._init()
	u4.clearContainer(l__DisplayAttachmentList__19.Container);
	u4.clearContainer(l__Container__9);
	u4.clearContainer(l__ContainerCategory__28);
	u4.clearContainer(l__ContainerSlots__31);
	local v82 = l__Templates__11.DisplayPrompt:Clone();
	v82.Parent = l__DisplayWeaponAttachments__4;
	local u37 = u36.new(v82, v82.Container.Confirm, v82.Container.Cancel);
	u16.onReleased(l__ContainerEdit__6.ButtonResetAttachments, function()
		if u37:isActive() then
			u37:deactivate();
			return;
		end;
		local u38 = v2.getActiveLoadoutSlot();
		u37:activate("Reset Attachments?", function()
			u2.resetAttachments(u1.getPlayerData(), u38);
			u20:send("resetAttachments", u38);
		end, function()
			print("cancelled prompt");
		end);
	end);
	u12.new(l__ContainerEdit__6.ButtonResetAttachments, {
		highlightColor3 = u13.loadoutClassColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u13.loadoutClassColorConfig.default.BackgroundColor3
	});
	u12.new(l__ContainerEdit__6.ButtonEditAttachments, {
		highlightColor3 = u13.loadoutClassColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u13.loadoutClassColorConfig.default.BackgroundColor3
	});
	u16.onReleased(l__DisplayWeaponAttachments__4.ButtonBack, function()
		u8:runAndReplace("attachmentList");
		u8:runAndReplace("attachmentSlot");
		u8:runAndReplace("attachmentCategory");
		v2.goToSubPage("DisplayWeaponSelection");
	end);
	u12.new(l__DisplayWeaponAttachments__4.ButtonBack, {
		highlightColor3 = u13.menuColorConfig.highlighted.BackgroundColor3, 
		defaultColor3 = u13.menuColorConfig.default.BackgroundColor3
	});
	u27.onSubPageChanged:connect(function(p8)
		if p8 ~= l__DisplayWeaponAttachments__4.Name then
			return;
		end;
		v1.updatePage();
	end);
	u23.onEnabled:connect(function()
		v1.updatePage();
	end);
end;
return v1;

