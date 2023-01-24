
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Event");
function v1.new()
	local v2 = setmetatable({}, v1);
	v2._tags = {};
	v2._objectList = {};
	v2._objectHash = {};
	v2._objectCount = {};
	v2.objectAdded = u1.new();
	v2.objectRemoved = u1.new();
	return v2;
end;
function v1.delete(p1)
	for v3 in next, p1._tags do
		p1:forgetTag(v3);
	end;
end;
function v1.getObjectList(p2)
	return p2._objectList;
end;
local l__CollectionService__2 = game:GetService("CollectionService");
function v1.watchTag(p3, p4)
	if p3._tags[p4] then
		return;
	end;
	local v4 = {
		tag = p4
	};
	v4.addedConnection = l__CollectionService__2:GetInstanceAddedSignal(p4):Connect(function(p5)
		p3:_addObject(p5);
	end);
	v4.removedConnection = l__CollectionService__2:GetInstanceRemovedSignal(p4):Connect(function(p6)
		p3:_removeObject(p6);
	end);
	p3._tags[p4] = v4;
	local l__next__5 = next;
	local v6, v7 = l__CollectionService__2:GetTagged(p4);
	while true do
		local v8, v9 = l__next__5(v6, v7);
		if not v8 then
			break;
		end;
		v7 = v8;
		p3:_addObject(v9);	
	end;
end;
function v1.forgetTag(p7, p8)
	if not p7._tags[p8] then
		return;
	end;
	p7._tags[p8].addedConnection:Disconnect();
	p7._tags[p8].removedConnection:Disconnect();
	p7._tags[p8] = nil;
	local l__next__10 = next;
	local v11, v12 = l__CollectionService__2:GetTagged(p8);
	while true do
		local v13, v14 = l__next__10(v11, v12);
		if not v13 then
			break;
		end;
		v12 = v13;
		p7:_removeObject(v14);	
	end;
end;
function v1._addObject(p9, p10)
	if not p9._objectCount[p10] then
		local v15 = #p9._objectList + 1;
		p9._objectList[v15] = p10;
		p9._objectHash[p10] = v15;
		p9._objectCount[p10] = 0;
	end;
	p9._objectCount[p10] = p9._objectCount[p10] + 1;
	p9.objectAdded:fire(p10);
end;
function v1._removeObject(p11, p12)
	p11._objectCount[p12] = p11._objectCount[p12] - 1;
	if p11._objectCount[p12] == 0 then
		local v16 = p11._objectHash[p12];
		local v17 = #p11._objectList;
		local v18 = p11._objectList[v17];
		p11._objectList[v16] = v18;
		p11._objectHash[v18] = v16;
		p11._objectList[v17] = nil;
		p11._objectHash[p12] = nil;
		p11._objectCount[p12] = nil;
	end;
	p11.objectRemoved:fire(p12);
end;
return v1;

