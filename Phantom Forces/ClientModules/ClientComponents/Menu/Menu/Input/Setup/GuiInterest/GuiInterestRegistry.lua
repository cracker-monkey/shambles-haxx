
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = {};
local u2 = true;
local function u3(p1)
	if u1[p1] then
		u2 = true;
		local v2 = u1[p1];
		u1[p1] = nil;
		for v3 = 1, #v2 do
			v2[v3]:Disconnect();
		end;
		local l__next__4 = next;
		local v5, v6 = p1:GetChildren();
		while true do
			local v7, v8 = l__next__4(v5, v6);
			if not v7 then
				break;
			end;
			v6 = v7;
			u3(v8);		
		end;
	end;
end;
local function u4(p2)
	if not p2 then
		return false;
	end;
	if u1[p2] then
		return u1[p2].enabled;
	end;
	u1[p2] = {};
	local v9 = u1[p2];
	if p2:IsA("GuiObject") then
		table.insert(v9, p2:GetPropertyChangedSignal("Visible"):Connect(function()
			u3(p2);
		end));
		if not p2.Visible then
			v9.enabled = false;
		else
			table.insert(v9, p2:GetPropertyChangedSignal("Parent"):Connect(function()
				u3(p2);
			end));
			v9.enabled = u4(p2.Parent);
		end;
	elseif p2:IsA("LayerCollector") then
		table.insert(v9, p2:GetPropertyChangedSignal("Enabled"):Connect(function()
			u3(p2);
		end));
		if not p2.Enabled then
			v9.enabled = false;
		else
			table.insert(v9, p2:GetPropertyChangedSignal("Parent"):Connect(function()
				u3(p2);
			end));
			v9.enabled = u4(p2.Parent);
		end;
	elseif p2:IsA("BasePlayerGui") then
		v9.enabled = true;
	else
		warn("what", p2.ClassName);
		table.insert(v9, p2:GetPropertyChangedSignal("Parent"):Connect(function()
			u3(p2);
		end));
		v9.enabled = u4(p2.Parent);
	end;
	return v9.enabled;
end;
v1._registry = {};
v1._enabledList = {};
function v1.getEnabledList(p3)
	if u2 then
		u2 = false;
		table.clear(p3._enabledList);
		for v10 in next, p3._registry do
			if u4(v10:getGui()) then
				p3._enabledList[v10] = true;
			end;
		end;
	end;
	return p3._enabledList;
end;
function v1.isEnabled(p4, p5)
	return u4(p5:getGui());
end;
function v1.getRegistry(p6)
	return v1._registry;
end;
function v1.register(p7, p8)
	u2 = true;
	v1._registry[p8] = true;
	p8.destroyed:connect(function()
		v1._registry[p8] = nil;
	end);
end;
return v1;

