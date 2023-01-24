
-- Decompiled with the Synapse X Luau decompiler.

local v1 = shared.require("PageMainMenuInterface");
local v2 = v1.getPageFrame();
local l__DisplayMatchVote__3 = v2.DisplayMatchVote;
local l__DisplayPlayerCard__4 = v2.DisplayPlayerCard;
local u1 = shared.require("DestructorGroup").new();
local u2 = {};
local u3 = shared.require("ContentDatabase");
local u4 = shared.require("GameRoundInterface");
local l__ContainerMap__5 = l__DisplayMatchVote__3.ContainerMap;
local u6 = shared.require("network");
local u7 = shared.require("UIToggleGroup");
local u8 = {};
local l__ContainerMode__9 = l__DisplayMatchVote__3.ContainerMode;
local u10 = shared.require("GameModeConfig");
local u11 = shared.require("MenuColorConfig");
local u12 = shared.require("GameClock");
local u13 = nil;
local u14 = {
	updateMapVoteSetup = function()
		local v5 = u1:runAndReplace("updateMapVoteSetup");
		u2 = {};
		local v6 = u3.getCurrentMapDatabase();
		local v7, v8 = u4.getVoteLists();
		local l__next__9 = next;
		local v10 = nil;
		while true do
			local v11, v12 = l__next__9(v7, v10);
			if not v11 then
				break;
			end;
			local l__Name__13 = v12.Name;
			local l__next__14 = next;
			local v15 = nil;
			while true do
				local v16, v17 = l__next__14(v6, v15);
				if not v16 then
					warn("No mapData found for", l__Name__13, "in database", v6);
					local v18 = nil;
					break;
				end;
				v15 = v16;
				if v17.Name == l__Name__13 then
					v18 = v17;
					break;
				end;			
			end;
			local v19 = l__ContainerMap__5["ButtonVoteMap" .. v11];
			local v20 = 0;
			for v21, v22 in next, v12.Votes do
				v20 = v20 + 1;
			end;
			v19.ImageMap.Image = "rbxassetid://" .. v18.imageid;
			v19.TextMap.Text = string.upper(v12.Name);
			v19.TextVotes.Text = "VOTES: " .. v20;
			local v23 = {
				buttonFrame = v19
			};
			local v24 = {};
			function v24.onToggled()
				print("vote for map", l__Name__13);
				u6:send("changeMapVote", l__Name__13, true);
			end;
			v23.buttonConfig = v24;
			u2[l__Name__13] = v23;		
		end;
		v5:add((u7.new(u2, {
			updateFunc = function(p1, p2)
				p1.FrameHighlight.Transparency = 0.2 + p2 * 0.8;
			end
		}, function(p3)
			print("unvote", p3);
			u6:send("changeMapVote", p3, false);
		end)));
		u8 = {};
		for v25, v26 in next, v8 do
			local l__Name__27 = v26.Name;
			local v28 = l__ContainerMode__9["ButtonVoteMode" .. v25];
			local v29 = 0;
			for v30, v31 in next, v26.Votes do
				v29 = v29 + 1;
			end;
			v28.TextMode.Text = string.upper(u10[l__Name__27].Name);
			v28.TextVotes.Text = "VOTES: " .. v29;
			local v32 = {
				buttonFrame = v28
			};
			local v33 = {};
			function v33.onToggled()
				print("vote for mode", l__Name__27);
				u6:send("changeModeVote", l__Name__27, true);
			end;
			v32.buttonConfig = v33;
			u8[l__Name__27] = v32;
		end;
		local v34 = u7.new(u8, u11.mapToggleColorConfig, function(p4)
			print("unvote", p4);
			u6:send("changeModeVote", p4, false);
		end);
		u4.onVoteStarted:connectOnce(function()
			l__DisplayMatchVote__3.Visible = true;
			local l__RenderStepped__35 = game:GetService("RunService").RenderStepped;
			local u15 = u12.getTime() + 15;
			local u16 = nil;
			u16 = l__RenderStepped__35:Connect(function()
				debug.profilebegin("VoteStep");
				local v36 = math.ceil(u15 - u12.getTime());
				if v36 > 0 then
					l__DisplayMatchVote__3.TextTitleMap.Text = "MAP VOTING :\t\t" .. v36 .. " SECONDS LEFT";
				else
					l__DisplayMatchVote__3.TextTitleMap.Text = "MAP VOTING : \t\tMAPS HAVE BEEN SELECTED";
					u16:Disconnect();
					task.delay(3, function()
						if not u13:getToggleState() then
							l__DisplayMatchVote__3.Visible = false;
						end;
					end);
				end;
				debug.profileend();
			end);
		end);
		l__DisplayMatchVote__3.TextTitleMap.Text = "MAP VOTING: READY TO VOTE FOR NEXT MATCH";
		v5:add(v34);
		u14.updateMapVote();
		u14.updateModeVote();
	end
};
function u14.updateMapVote()
	local v37 = 0;
	local v38 = nil;
	local v39 = {};
	local l__next__40 = next;
	local v41 = u4.getVoteLists();
	local v42 = nil;
	while true do
		local v43, v44 = l__next__40(v41, v42);
		if not v43 then
			break;
		end;
		local l__Name__45 = v44.Name;
		local v46 = u2[l__Name__45];
		if not v46 then
			print("PageMainMenuDisplayMenu: No mapVoteToggleData found for map", l__Name__45);
			return;
		end;
		local v47 = 0;
		for v48, v49 in next, v44.Votes do
			v47 = v47 + 1;
		end;
		v46.buttonFrame.TextVotes.Text = "VOTES: " .. v47;
		if v37 < v47 then
			v38 = l__Name__45;
			v37 = v47;
		end;
		table.insert(v39, v47);	
	end;
	local v50 = 0;
	for v51, v52 in next, v39 do
		if v52 == v37 then
			v50 = v50 + 1;
		end;
	end;
	if v37 == 0 then
		v2.ButtonVoteToggle.TextNextMap.Text = "NO VOTES";
		return;
	end;
	if v50 > 1 then
		v2.ButtonVoteToggle.TextNextMap.Text = v50 .. " TIES";
		return;
	end;
	v2.ButtonVoteToggle.TextNextMap.Text = string.upper(v38);
end;
function u14.updateModeVote()
	local v53 = 0;
	local v54 = nil;
	local v55 = {};
	local v56, v57 = u4.getVoteLists();
	local l__next__58 = next;
	local v59 = nil;
	while true do
		local v60, v61 = l__next__58(v57, v59);
		if not v60 then
			break;
		end;
		local l__Name__62 = v61.Name;
		local v63 = u8[l__Name__62];
		if not v63 then
			print("PageMainMenuDisplayMenu: No modeVoteToggleData found for mode", l__Name__62);
			return;
		end;
		local v64 = 0;
		for v65, v66 in next, v61.Votes do
			v64 = v64 + 1;
		end;
		v63.buttonFrame.TextVotes.Text = "VOTES: " .. v64;
		if v53 < v64 then
			v54 = l__Name__62;
			v53 = v64;
		end;
		table.insert(v55, v64);	
	end;
	local v67 = 0;
	for v68, v69 in next, v55 do
		if v69 == v53 then
			v67 = v67 + 1;
		end;
	end;
	if v53 == 0 then
		v2.ButtonVoteToggle.TextNextMode.Text = "NO VOTES";
		return;
	end;
	if v67 > 1 then
		v2.ButtonVoteToggle.TextNextMode.Text = v67 .. " TIES";
		return;
	end;
	v2.ButtonVoteToggle.TextNextMode.Text = string.upper(u10[v54].Name);
end;
local l__DisplayMapThumbnail__17 = v2.DisplayMapThumbnail;
function u14.updateMapThumbnail()
	local v70 = u4.getMapState();
	local l__mapName__71 = v70.mapName;
	local v72 = u3.getCurrentMapDatabase();
	local l__next__73 = next;
	local v74 = nil;
	while true do
		local v75, v76 = l__next__73(v72, v74);
		if not v75 then
			warn("No mapData found for", l__mapName__71, "in database", v72);
			local v77 = nil;
			break;
		end;
		v74 = v75;
		if v76.Name == l__mapName__71 then
			v77 = v76;
			break;
		end;	
	end;
	l__DisplayMapThumbnail__17.ImageMap.Image = "rbxassetid://" .. (v70.imageId or v77.imageid);
	l__DisplayMapThumbnail__17.TextMap.Text = string.upper(l__mapName__71);
	l__DisplayMapThumbnail__17.TextMode.Text = string.upper(u10[v70.modeName].Name);
end;
local u18 = shared.require("PlayerDataStoreClient");
local u19 = shared.require("PlayerSettingsInterface");
local l__ContainerLeft__20 = l__DisplayPlayerCard__4.ContainerLeft;
local l__LocalPlayer__21 = game:GetService("Players").LocalPlayer;
local u22 = shared.require("PlayerDataUtils");
local u23 = shared.require("MenuUtils");
local l__ContainerRight__24 = l__DisplayPlayerCard__4.ContainerRight;
function u14.updatePlayerCard()
	local v78 = u18.getPlayerData();
	if u19.getValue("togglestreamermode") then
		l__ContainerLeft__20.DisplayPlayerName.TextRight.Text = "Player";
	else
		l__ContainerLeft__20.DisplayPlayerName.TextRight.Text = l__LocalPlayer__21.Name;
	end;
	local v79 = v78.stats.experience and 0;
	local v80 = u22.getPlayerRank(v78);
	l__ContainerLeft__20.DisplayRank.TextRight.Text = u23.commaValue(v80);
	local v81 = u22.expCalculator(v80);
	local v82 = u22.expCalculator(v80 + 1) - v81;
	local v83 = v79 - v81;
	l__ContainerLeft__20.DisplayExperience.TextRight.Text = u23.commaValue(v83) .. " / " .. u23.commaValue(v82);
	l__ContainerLeft__20.DisplayExperience.SliderBar.SliderBarValue.Size = UDim2.fromScale(v83 / v82, 1);
	l__ContainerRight__24.DisplayTotalExperience.TextRight.Text = u23.commaValue(v79);
	l__ContainerRight__24.DisplayRankReward.TextRight.Text = "$" .. u23.commaValue(u22.rankUpCreditsCalculator(v80, v80 + 1));
	local v84 = u22.getNextWeaponUnlockList(v78);
	if #v84 < 1 then
		l__ContainerLeft__20.DisplayNextUnlock.TextWeapon.Text = "NOTHING";
		l__ContainerRight__24.DisplayUnlockRank.TextRight.Text = "N/A";
	else
		local v85 = nil;
		for v86, v87 in next, v84 do
			if not v85 or v85 == v87.weaponRank then
				local v88 = u3.getWeaponDisplayName(v87.weaponName);
				l__ContainerLeft__20.DisplayNextUnlock.TextWeapon.Text = v86 == 1 and v88 or l__ContainerLeft__20.DisplayNextUnlock.TextWeapon.Text .. " / " .. v88;
				l__ContainerRight__24.DisplayUnlockRank.TextRight.Text = v87.weaponRank;
				v85 = v87.weaponRank;
			end;
		end;
	end;
	local v89 = v78.stats.totalkills and 0;
	local v90 = v78.stats.totaldeaths and 0;
	l__ContainerRight__24.DisplayKills.TextRight.Text = u23.commaValue(v89);
	l__ContainerRight__24.DisplayDeaths.TextRight.Text = u23.commaValue(v90);
	l__ContainerRight__24.DisplayKDR.TextRight.Text = u23.commaValue(v90 == 0 and v89 or u23.twoDecimal(v89 / v90));
end;
local u25 = {};
function u14.getSelectedPlayer()
	for v91, v92 in next, u25 do
		if v92:isSelected() then
			return v91;
		end;
	end;
end;
local u26 = shared.require("PlayerStatusInterface");
function u14.getSquadSpawnPlayer()
	for v93, v94 in next, u25 do
		if v94:isSelected() then
			if u26.getDeployStatus(v93) == "DEPLOYABLE" then
				return v93, true, v94;
			else
				return v93, false, v94;
			end;
		end;
	end;
	return nil, true;
end;
local u27 = shared.require("MenuScreenGui");
local u28 = shared.require("PageMainMenuButtonSquadList");
local l__ContainerSquadDeploy__29 = v2.ContainerSquadDeploy;
function u14.step()
	if not u27.isEnabled() then
		return;
	end;
	local v95 = game:GetService("Players"):GetPlayers();
	for v96, v97 in next, v95 do
		if v97 ~= game:GetService("Players").LocalPlayer and u26.isFriendly(v97) then
			local v98 = u25[v97];
			if not v98 then
				v98 = u28.new(v97, l__ContainerSquadDeploy__29);
				u25[v97] = v98;
			end;
			v98:update();
		end;
	end;
	for v99, v100 in next, u25 do
		if not table.find(v95, v99) or not u26.isFriendly(v99) then
			v100:Destroy();
			u25[v99] = nil;
		end;
	end;
end;
local l__ContainerMenu__30 = v2.ContainerMenu;
local u31 = shared.require("PageMainMenuConfig");
local l__Templates__32 = v2.Templates;
local u33 = shared.require("UIHighlight");
local u34 = shared.require("UIToggle");
local u35 = shared.require("PlayerStatusEvents");
local u36 = shared.require("MenuPagesInterface");
local u37 = shared.require("CameraInterface");
local u38 = shared.require("MenuLobbyInterface");
local u39 = shared.require("MenuPagesEvents");
local u40 = shared.require("MenuCameraEvents");
local u41 = shared.require("PlayerSettingsEvents");
function u14._init()
	l__DisplayMatchVote__3.Visible = false;
	u23.clearContainer(l__ContainerMenu__30);
	u23.clearContainer(l__ContainerSquadDeploy__29);
	for v101, v102 in next, u31.menuButtons do
		if v102 == "" then
			l__Templates__32.ButtonMainEmpty:Clone().Parent = l__ContainerMenu__30;
		else
			local v103 = u33.new(shared.require(v102).init(l__ContainerMenu__30, l__Templates__32), {
				highlightColor3 = u11.menuColorConfig.highlighted.BackgroundColor3, 
				defaultColor3 = u11.menuColorConfig.default.BackgroundColor3
			});
		end;
	end;
	u13 = u34.new(v2.ButtonVoteToggle, u11.inventoryBoxColorConfig);
	u13.onToggleChanged:connect(function(p5)
		l__DisplayMatchVote__3.Visible = p5;
	end);
	u4.onVoteListChanged:connect(u14.updateMapVoteSetup);
	u4.onModeVoteUpdated:connect(u14.updateModeVote);
	u4.onMapChanged:connect(u14.updateMapThumbnail);
	u4.onMapVoteUpdated:connect(u14.updateMapVote);
	local u42 = nil;
	u35.onPlayerSpawned:connect(function(p6)
		if not u27.isEnabled() then
			return;
		end;
		if u36.getCurrentPage() ~= v1.getPageName() then
			return;
		end;
		if p6 == u42 and p6.TeamColor == l__LocalPlayer__21.TeamColor then
			u37.setCameraType("SpectateCamera", {
				player = p6
			});
		end;
	end);
	u35.onPlayerDied:connect(function(p7)
		if not u27.isEnabled() then
			return;
		end;
		if u36.getCurrentPage() ~= v1.getPageName() then
			return;
		end;
		if p7 == u14.getSelectedPlayer() or p7 == u42 then
			u42 = p7;
			u37.setCameraType("MenuCamera", {
				cameraCFrame = u38.getTargetNode().CFrame
			});
		end;
	end);
	u39.onPageChanged:connect(function(p8)
		if not u27.isEnabled() then
			return;
		end;
		if u37.isCameraType("SpectateCamera") then
			u37.setCameraType("MenuCamera", {
				cameraCFrame = u38.getTargetNode("PageMainMenu").CFrame
			});
			return;
		end;
		u38.updateCameraTarget(p8);
		if p8 == "PageMainMenu" and u26.isPlayerAlive(u42) and u42 then
			u37.setCameraType("SpectateCamera", {
				player = u42
			});
		end;
	end);
	u40.onSpectatePlayerChanged:connect(function(p9)
		u42 = p9;
		if not u27.isEnabled() then
			return;
		end;
		if p9 == nil then
			u37.setCameraType("MenuCamera", {
				cameraCFrame = u38.getTargetNode().CFrame
			});
			return;
		end;
		if u26.isPlayerAlive(p9) then
			u37.setCameraType("SpectateCamera", {
				player = p9, 
				force = true
			});
		end;
	end);
	u27.onEnabled:connect(function()
		print("Changing Menu Camera");
		u37.setCameraType("MenuCamera", {
			cameraCFrame = u38.getTargetNode("PageMainMenu").CFrame
		});
		u38.updateCameraTarget(u36.getCurrentPage());
		u14.updatePlayerCard();
		local v104 = u14.getSelectedPlayer();
		if v104 and u36.getCurrentPage() == "PageMainMenu" and u26.isPlayerAlive(v104) then
			u37.setCameraType("SpectateCamera", {
				player = v104
			});
		end;
	end);
	u41.onSettingChanged:connect(function(p10)
		if p10 == "togglestreamermode" then
			u14.updatePlayerCard();
		end;
	end);
	u14.updatePlayerCard();
end;
return u14;

