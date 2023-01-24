
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = {};
function v1.getCurrentPage()
	for v2, v3 in next, u1 do
		if v3.Visible then
			return v2;
		end;
	end;
end;
local u2 = nil;
local u3 = shared.require("MenuPagesEvents");
function v1.goToPage(p1)
	if not u1[p1] then
		warn("MenuPagesInterface: Attempt to go to missing page", p1);
		return;
	end;
	u2 = v1.getCurrentPage();
	local l__next__4 = next;
	local v5 = nil;
	while true do
		local v6, v7 = l__next__4(u1, v5);
		if not v6 then
			break;
		end;
		v7.Visible = v6 == p1;
		if v6 == p1 then
			u3.onPageChanged:fire(p1);
		end;	
	end;
end;
function v1.goToPreviousPage()
	v1.goToPage(u2);
end;
local u4 = nil;
function v1.goToDefaultPage()
	if not u4 then
		warn("MenuPagesInterface: No default page is set");
		return;
	end;
	v1.goToPage(u4);
end;
function v1.setDefaultPage(p2)
	if u1[p2] then
		u4 = p2;
		return;
	end;
	warn("MenuPagesInterface: Attempt to set missing default page", p2);
end;
local u5 = shared.require("MenuScreenGui");
local u6 = shared.require("PageMainMenuConfig");
function v1._init()
	local l__next__8 = next;
	local v9, v10 = u5.getScreenGui():WaitForChild("Pages"):GetDescendants();
	while true do
		local v11, v12 = l__next__8(v9, v10);
		if not v11 then
			break;
		end;
		v10 = v11;
		if v12:IsA("Frame") and string.sub(v12.name, 1, 4) == "Page" then
			u1[v12.Name] = v12;
		end;	
	end;
	v1.setDefaultPage("PageMainMenu");
	v1.goToDefaultPage();
	game:GetService("UserInputService").InputBegan:connect(function(p3, p4)
		if p4 then
			return;
		end;
		if not u5.isEnabled() then
			return;
		end;
		if p3.UserInputType == Enum.UserInputType.Gamepad1 then
			local l__KeyCode__13 = p3.KeyCode;
			if l__KeyCode__13 == Enum.KeyCode.ButtonB then
				v1.goToPreviousPage();
				return;
			end;
			if l__KeyCode__13 == Enum.KeyCode.ButtonL1 then
				local v14 = 1;
				local v15 = table.find(u6.controllerPageOrder, (v1.getCurrentPage()));
				if v15 then
					v14 = v15 - 1;
					if v14 <= 0 then
						v14 = #u6.controllerPageOrder;
					end;
				end;
				v1.goToPage(u6.controllerPageOrder[v14]);
				return;
			end;
			if l__KeyCode__13 == Enum.KeyCode.ButtonR1 then
				local v16 = 1;
				local v17 = table.find(u6.controllerPageOrder, (v1.getCurrentPage()));
				if v17 then
					v16 = v17 % #u6.controllerPageOrder + 1;
				end;
				v1.goToPage(u6.controllerPageOrder[v16]);
			end;
		end;
	end);
end;
return v1;

