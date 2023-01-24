
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("ChatScreenGui");
local v3 = shared.require("HudScreenGui");
local v4 = v2.getScreenGui();
local l__Main__5 = v4.Main;
local l__TextChatInput__1 = v4.TextChatInput;
local u2 = shared.require("network");
local u3 = shared.require("ChatConfig");
local l__TextWarn__4 = v4.TextWarn;
local l__LocalPlayer__5 = game:GetService("Players").LocalPlayer;
local l__ContainerChat__6 = l__Main__5.ContainerChat;
local u7 = shared.require("InstanceType");
local l__TextVersion__8 = v4.TextVersion;
local l__Value__9 = game:GetService("ReplicatedFirst"):WaitForChild("GameData"):WaitForChild("Version", 3).Value;
function v1.updateVersion(p1)
	l__TextVersion__8.Text = string.format("<b>Version: %s-%s#%s</b>", l__Value__9, string.lower((u7.GetString())), p1 and "N/A");
end;
function v1.inMenu()
	l__ContainerChat__6.Position = UDim2.new(0, 60, 1, -120);
	v2.toggleAspectRatio(true);
end;
local l__DisplayRadar__10 = v3.getScreenGui().Main.DisplayRadarScore.DisplayRadar;
function v1.inGame()
	l__ContainerChat__6.Position = UDim2.new(0, (l__DisplayRadar__10.AbsoluteSize.X + 10) / v2.getUIScale(), 1, -30);
	v2.toggleAspectRatio(false);
end;
local function u11()
	local v6 = l__TextChatInput__1.Text;
	l__TextChatInput__1.Text = "Press '/' or click here to chat";
	l__TextChatInput__1.ClearTextOnFocus = true;
	if string.sub(v6, 1, 1) == "/" then
		u2:send("modcmd", v6);
		l__TextChatInput__1.Text = "Press '/' or click here to chat";
		l__TextChatInput__1.ClearTextOnFocus = true;
		return;
	end;
	local v7 = nil;
	if string.sub(v6, 1, 1) == "%" then
		v7 = true;
		v6 = string.sub(v6, 2, string.len(v6));
	end;
	if not (u3.chatSpam > 5) then
		if string.len(v6) > 256 then
			v6 = string.sub(v6, 1, 256);
		end;
		u3.chatSpam = u3.chatSpam + 1;
		u2:send("chatted", v6, v7);
		task.delay(10, function()
			u3.chatSpam = u3.chatSpam - 1;
		end);
		return;
	end;
	u3.chatSpam = u3.chatSpam + 1;
	u3.totalSpam = u3.totalSpam + 1;
	l__TextWarn__4.Text = "You have been blocked temporarily for spamming.   WARNING : " .. u3.totalSpam .. " out of 3";
	l__TextWarn__4.Visible = true;
	if u3.totalSpam > 3 then
		l__LocalPlayer__5:Kick("Kicked for repeated spamming");
	end;
	task.delay(5, function()
		u3.chatSpam = u3.chatSpam - 5;
		l__TextWarn__4.Visible = false;
	end);
end;
local u12 = shared.require("PlayerSettingsInterface");
local u13 = shared.require("PlayerSettingsEvents");
local u14 = shared.require("MenuScreenGui");
local u15 = shared.require("VoteKickConfig");
local u16 = shared.require("VoteKickInterface");
local l__Templates__17 = l__Main__5.Templates;
local u18 = shared.require("RichTextUtils");
local function u19()
	local v8 = l__ContainerChat__6:GetChildren();
	local v9 = #v8;
	local v10 = -20;
	for v11 = #v8, 1, -1 do
		local v12 = v8[v11];
		if v12:IsA("Frame") then
			v12:TweenPosition(UDim2.new(0, 0, 1, v10), "Out", "Quad", 0.2, true);
			v10 = v10 - 20;
			if u3.lines <= v9 - v11 then
				v12:Destroy();
			end;
		end;
	end;
end;
function v1._init()
	local l__UIScale__13 = l__ContainerChat__6.UIScale;
	l__UIScale__13.Parent = nil;
	l__ContainerChat__6:ClearAllChildren();
	l__UIScale__13.Parent = l__ContainerChat__6;
	l__TextChatInput__1.Focused:connect(function()
		l__TextChatInput__1.Active = true;
	end);
	l__TextChatInput__1.FocusLost:connect(function(p2)
		if p2 and l__TextChatInput__1.Text ~= "" then
			u11();
		end;
		l__TextChatInput__1.Active = false;
	end);
	if u12.getValue("togglechat") then
		v2.enable();
	else
		v2.disable();
	end;
	u13.onSettingChanged:connect(function(p3, p4)
		if p3 == "togglechat" then
			if not p4 then
				v2.disable();
				return;
			end;
		else
			return;
		end;
		v2.enable();
	end);
	v3.onEnabled:connect(function()
		v1.inGame();
	end);
	u14.onEnabled:connect(function()
		v1.inMenu();
	end);
	l__DisplayRadar__10:GetPropertyChangedSignal("AbsoluteSize"):connect(function()
		if v3.isEnabled() then
			v1.inGame();
		end;
	end);
	v1.inMenu();
	game:GetService("UserInputService").InputBegan:connect(function(p5)
		if l__TextWarn__4.Visible or l__TextChatInput__1.Active then
			return;
		end;
		local l__KeyCode__14 = p5.KeyCode;
		if l__KeyCode__14 == Enum.KeyCode.Slash then
			wait(0.03333333333333333);
			l__TextChatInput__1:CaptureFocus();
			l__TextChatInput__1.ClearTextOnFocus = false;
			return;
		end;
		local l__Name__15 = l__KeyCode__14.Name;
		if l__Name__15 == u15.keyCodes.dismiss then
			u16.vote("dismiss");
			return;
		end;
		if l__Name__15 == u15.keyCodes.yes then
			u16.vote("yes");
			return;
		end;
		if l__Name__15 == u15.keyCodes.no then
			u16.vote("no");
		end;
	end);
	u2:add("console", function(p6)
		local v16 = l__Templates__17.DisplayChatLine:Clone();
		v16:WaitForChild("TextPlayerChat").Text = u18.formatTextColor3("[Console]:", Color3.new(0.4, 0.4, 0.4)) .. " " .. p6;
		v16.Position = UDim2.new(0, 0, 1, 0);
		v16.Parent = l__ContainerChat__6;
		u19();
	end);
	u2:add("announce", function(p7)
		local v17 = l__Templates__17.DisplayChatLine:Clone();
		v17:WaitForChild("TextPlayerChat").Text = u18.formatTextColor3("[ANNOUNCEMENT]:", Color3.new(0.9803921568627451, 0.6509803921568628, 0.10196078431372549)) .. " " .. p7;
		v17.Position = UDim2.new(0, 0, 1, 0);
		v17.Parent = l__ContainerChat__6;
		u19();
	end);
	u2:add("chatted", function(p8, p9, p10, p11, p12)
		local v18 = l__Templates__17.DisplayChatLine:Clone();
		local l__TextPlayerChat__19 = v18:WaitForChild("TextPlayerChat");
		local l__ImageStaffTag__20 = v18:WaitForChild("ImageStaffTag");
		local v21 = p8.Name;
		if u12.getValue("togglestreamermode") then
			v21 = "Player";
		end;
		local v22 = "";
		if p10 then
			if string.sub(p10, 0, 1) == "$" then
				l__TextPlayerChat__19.TextPadding.PaddingLeft = UDim.new(0, 25);
				l__ImageStaffTag__20.Visible = true;
				l__ImageStaffTag__20.Image = "rbxassetid://" .. string.sub(p10, 2);
			else
				v22 = u18.formatTextColor3(u18.escapeForbiddenCharacters(p10), p11) .. " ";
			end;
		end;
		local v23 = u18.escapeForbiddenCharacters(p9);
		if p12 then
			v23 = u18.formatTextColor3(v23, Color3.new(1, 0, 0));
		end;
		l__TextPlayerChat__19.Text = v22 .. u18.formatTextColor3(v21 .. ":", p8.TeamColor.Color) .. " " .. v23;
		v18.Position = UDim2.new(0, 0, 1, 0);
		v18.Parent = l__ContainerChat__6;
		u19();
	end);
	u2:add("printstring", function(...)
		local v24 = nil;
		local v25 = { ... };
		v24 = "";
		for v26 = 1, #v24 do
			v24 = v24 .. "\t" .. v25[v26];
		end;
		local v27 = 0;
		local v28 = "";
		for v29 in string.gmatch(local v30 .. "\n", "(^[\n]*)\n") do
			v27 = v27 + 1;
			v28 = v28 .. "\n" .. v29;
			if v27 == 64 then
				print(v28);
				v27 = 0;
				v28 = "";
			end;
		end;
	end);
	u2:add("newroundid", function(p13)
		v1.updateVersion(p13);
	end);
	v1.updateVersion();
end;
return v1;

