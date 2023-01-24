
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
function u1.add(p1, p2, p3)
	u1:send("registerfunc", p2, p2);
	u2[p2] = p3;
	u3[p2] = p3;
	if u4[p2] then
		local v2 = u4[p2];
		for v3 = 1, #v2 do
			p3(unpack(v2[v3]));
		end;
		u4[p2] = nil;
	end;
end;
local u5 = false;
local l__ReadyEvent__6 = game.ReplicatedStorage:WaitForChild("ReadyEvent");
function u1.ready(p4)
	if not u5 then
		u5 = true;
		l__ReadyEvent__6:FireServer();
		function u1.add()

		end;
	end;
end;
local u7 = shared.require("TimeSyncClient").new();
function u1.getTime(p5)
	return u7:getTime();
end;
function u1.timeSyncReady(p6)
	return u7:isReady();
end;
local l__RemoteEvent__8 = game.ReplicatedStorage:WaitForChild("RemoteEvent");
function u1.send(p7, p8, ...)
	l__RemoteEvent__8:FireServer(p8, ...);
end;
local l__RemoteFunction__9 = game.ReplicatedStorage:WaitForChild("RemoteFunction");
local l__decode__10 = shared.require("NetworkEncode").decode;
function u1.fetch(p9, p10, ...)
	return unpack(l__decode__10((l__RemoteFunction__9:InvokeServer(p10, { ... }))), 1, 16);
end;
local v4 = {};
for v5 = 1, 100 do
	v4[v5] = v5;
end;
for v6 = 1, #v4 do
	local v7 = nil;
	local v8 = v6 - 1;
	v7 = v4[v6];
	local v9 = v8 * math.random();
	local v10 = v9 - v9 % 1;
	if v10 == v8 then
		v1[#v1 + 1] = v7;
	else
		v1[#v1 + 1] = v1[v10 + 1];
		v1[v10 + 1] = v7;
	end;
end;
l__RemoteEvent__8.OnClientEvent:connect(function(p11, ...)
	if u3[p11] then
		u3[p11](...);
		return;
	end;
	if u5 then
		warn(string.format("Tried to call a unregistered network event %s", p11));
		return;
	end;
	if not u4[p11] then
		u4[p11] = {};
	end;
	u4[p11][#u4[p11] + 1] = { ... };
end);
local u11 = v1;
local u12 = nil;
u12 = l__ReadyEvent__6.OnClientEvent:Connect(function()
	u3 = u2;
	u2 = {};
	u11 = {};
	u4 = {};
	u12:Disconnect();
end);
u1:add("ping", function(p12, p13)
	local v11, v12, v13 = u7:step(p12, p13);
	u1:send("ping", v11, v12, v13);
end);
u1.receive = u1.add;
return u1;

