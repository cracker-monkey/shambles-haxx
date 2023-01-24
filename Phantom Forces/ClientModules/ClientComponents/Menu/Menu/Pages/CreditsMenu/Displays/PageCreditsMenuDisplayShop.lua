
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = shared.require("PlayerDataStoreClient");
local v3 = shared.require("PageCreditsMenuEvents");
local v4 = shared.require("GuiInputInterface");
local v5 = shared.require("MenuColorConfig");
local v6 = shared.require("PlayerDataUtils");
local v7 = shared.require("InstanceType");
local v8 = shared.require("UIHighlight");
local v9 = shared.require("network");
local v10 = shared.require("MenuUtils");
local v11 = shared.require("UIToggle");
local v12 = shared.require("PageCreditsMenuInterface").getPageFrame();
local l__DisplayFrameShop__13 = v12.DisplayFrameShop;
local l__DisplayFrameShopList__14 = l__DisplayFrameShop__13.DisplayFrameShopList;
local v15 = shared.require("DestructorGroup").new();
local v16 = { {
		robuxPrice = 10, 
		creditAmount = 80, 
		imageId = 464548075
	}, {
		robuxPrice = 20, 
		creditAmount = 160, 
		imageId = 464553560
	}, {
		robuxPrice = 50, 
		creditAmount = 420, 
		imageId = 464563596
	}, {
		robuxPrice = 150, 
		creditAmount = 1300, 
		imageId = 464582243
	}, {
		robuxPrice = 350, 
		creditAmount = 3200, 
		imageId = 464609675
	}, {
		robuxPrice = 500, 
		creditAmount = 4600, 
		imageId = 464597950
	}, {
		robuxPrice = 1000, 
		creditAmount = 10000, 
		imageId = 464617164
	}, {
		robuxPrice = 2500, 
		creditAmount = 27000, 
		imageId = 464659254
	}, {
		robuxPrice = 5000, 
		creditAmount = 60000, 
		imageId = 465201557
	} };
local v17 = {};
local v18 = 0;
for v19, v20 in next, v16 do
	v18 = v18 + 1;
	v17[v18] = {
		cr = v20.creditAmount, 
		rb = v20.robuxPrice
	};
end;
table.sort(v17, function(p1, p2)
	return p1.cr < p2.cr;
end);
local l__Templates__1 = v12.Templates;
local function u2(p3)
	if p3 < 0 then
		return nil;
	end;
	local v21 = 0;
	while v21 < #v17 do
		v21 = v21 + 1;
		if p3 < v17[v21].rb then
			break;
		end;	
	end;
	if v21 == 1 then
		local v22 = v17[1];
		local v23 = v17[2];
	else
		v22 = v17[v21 - 1];
		v23 = v17[v21];
	end;
	local v24 = (p3 - v22.rb) / (v23.rb - v22.rb);
	local v25 = (1 - v24) * v22.cr + v24 * v23.cr;
	return v25 - v25 % 1;
end;
local function u3(p4)
	if p4 < 0 then
		return nil;
	end;
	local v26 = 0;
	while v26 < #v17 do
		v26 = v26 + 1;
		if p4 < v17[v26].cr then
			break;
		end;	
	end;
	if v26 == 1 then
		local v27 = v17[1];
		local v28 = v17[2];
	else
		v27 = v17[v26 - 1];
		v28 = v17[v26];
	end;
	local v29 = (p4 - v27.cr) / (v28.cr - v27.cr);
	local v30 = (1 - v29) * v27.rb + v29 * v28.rb;
	local v31 = v30 - v30 % -1;
	if v31 < 1 then
		return 1;
	end;
	return v31;
end;
local l__Container__4 = l__DisplayFrameShopList__14.Container;
local function u5()
	local v32 = v15:runAndReplace("updateShop");
	for v33, v34 in next, v16 do
		local v35 = l__Templates__1.ButtonCredits:Clone();
		v35.TextCreditsAmount.Text = "$" .. v10.commaValue((u2(v34.robuxPrice)));
		v35.TextRobuxCost.Text = "Buy for $" .. v10.commaValue((u3(v34.creditAmount))) .. " Robux";
		v35.ImageLabel.Image = "rbxassetid://" .. v34.imageId;
		v35.Parent = l__Container__4;
		v32:add(v35);
		v32:add(v4.onReleased(v35, function()
			print("Attempt to purchase", v34.creditAmount, "credits");
			v9:send("purchaseCredits", v34.creditAmount);
		end));
		v32:add(v8.new(v35, {
			highlightColor3 = v5.purchaseWeaponPreviewColorConfig.highlighted.BackgroundColor3, 
			defaultColor3 = v5.purchaseWeaponPreviewColorConfig.default.BackgroundColor3
		}));
	end;
end;
local function u6()
	v12.ButtonShop.TextCredits.Text = "$" .. v10.commaValue((v6.getPlayerCredits(v2.getPlayerData())));
end;
function v1._init()
	l__DisplayFrameShop__13.Visible = false;
	v10.clearContainer(l__Container__4);
	u5();
	v12.ButtonShop.TextCredits.Text = "$" .. v10.commaValue((v6.getPlayerCredits(v2.getPlayerData())));
	if v7.CanSave() or v7.IsStudio() then
		v11.new(v12.ButtonShop, v5.toggleColorConfig).onToggleChanged:connect(function(p5)
			l__DisplayFrameShop__13.Visible = p5;
		end);
		v4.onReleased(l__DisplayFrameShopList__14.ButtonBack, function()
			l__DisplayFrameShop__13.Visible = false;
		end);
		v8.new(l__DisplayFrameShopList__14.ButtonBack, {
			highlightColor3 = v5.inventoryActionButton.highlighted.BackgroundColor3, 
			defaultColor3 = v5.inventoryActionButton.default.BackgroundColor3
		});
	end;
	v3.onCreditsUpdated:connect(u6);
	v9:receive("purchaseCreditsUpdate", function(p6, p7)
		if not p6 then
			warn("PageCreditsMenuDisplayShop: Credit purchase of", p7, "failed");
			return;
		end;
		v6.purchaseCredits(v2.getPlayerData(), p7);
		v3.onCreditsUpdated:fire();
	end);
end;
return v1;

