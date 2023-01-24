
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("SingleEvent");
local u2 = shared.require("Event");
function v1.new(p1, p2, p3, p4)
	local v2 = setmetatable({}, v1);
	v2._guiInput = p1;
	v2._inputTrigger = p2;
	v2._canExpandCapture = p3;
	v2._canReduceCapture = p4;
	v2._interactionDataList = {};
	v2.destroyed = u1.new();
	v2.released = u1.new();
	v2.interactionAdded = u2.new();
	v2._guiInputDestroyed = v2._guiInput.destroyed:connect(function()
		v2:destroy();
	end);
	v2:initalize();
	return v2;
end;
function v1._updateCapture(p5, p6, p7)
	p5:_updateInteractionData(p5._interactionDataList);
	if p6 then
		p5:_expandInteractionData(p5._interactionDataList);
	end;
	p5:_sortAndRankInteractionData(p5._interactionDataList);
	if p7 then
		p5:_reduceGuiInteractions(p5._interactionDataList);
	end;
	if p6 then
		p5:_expandGuiInteractions(p5._interactionDataList);
	end;
	p5:_cleanInteractionDataList(p5._interactionDataList);
end;
function v1.destroy(p8)
	p8._guiInputDestroyed:disconnect();
	p8.destroyed:fire();
end;
function v1.release(p9)
	p9.released:fire();
	p9:destroy();
end;
function v1.initalize(p10)
	p10:_updateCapture(true, true);
end;
function v1.getGuiInteractions(p11)
	local v3 = {};
	local l___interactionDataList__4 = p11._interactionDataList;
	for v5 = 1, #l___interactionDataList__4 do
		v3[v5] = l___interactionDataList__4[v5].guiInteraction;
	end;
	return v3;
end;
function v1.update(p12)
	p12:_updateCapture(p12._canExpandCapture, p12._canReduceCapture);
end;
function v1._updateInteractionData(p13, p14)
	local v6, v7 = p13._guiInput:getPosition();
	local v8 = p13._guiInput:getRadius();
	local l__next__9 = next;
	local v10 = nil;
	while true do
		local v11, v12 = l__next__9(p14, v10);
		if not v11 then
			break;
		end;
		local v13, v14 = v12.guiInterest:getClosestPosition(v6, v7);
		local v15 = v6 - v13;
		local v16 = v7 - v14;
		local v17 = math.sqrt(v15 * v15 + v16 * v16);
		if v15 < 0 then
			local v18 = -1;
		else
			v18 = 1;
		end;
		if v16 < 0 then
			local v19 = -1;
		else
			v19 = 1;
		end;
		v12.cx = v13 - v13 % v18;
		v12.cy = v14 - v14 % v19;
		v12.dist = v17;
		v12.inRange = v17 <= v8;	
	end;
end;
local u3 = shared.require("GuiInterestRegistry");
function v1._expandInteractionData(p15, p16)
	local v20 = u3:getEnabledList();
	local v21 = {};
	for v22 = 1, #p16 do
		v21[p16[v22].guiInterest] = true;
	end;
	local v23, v24 = p15._guiInput:getPosition();
	local v25 = p15._guiInput:getRadius();
	for v26 in next, v20 do
		if not v21[v26] then
			local v27, v28 = v26:getClosestPosition(v23, v24);
			local v29 = v23 - v27;
			local v30 = v24 - v28;
			local v31 = math.sqrt(v29 * v29 + v30 * v30);
			if v31 <= v25 then
				if v29 < 0 then
					local v32 = -1;
				else
					v32 = 1;
				end;
				if v30 < 0 then
					local v33 = -1;
				else
					v33 = 1;
				end;
				table.insert(p16, {
					guiCapture = p15, 
					guiInterest = v26, 
					cx = v27 - v27 % v32, 
					cy = v28 - v28 % v33, 
					dist = v31, 
					inRange = true
				});
			end;
		end;
	end;
end;
function v1._cleanInteractionDataList(p17, p18)
	for v34 = #p18, 1, -1 do
		if not p18[v34].guiInteraction then
			table.remove(p18, v34);
		end;
	end;
end;
function v1._reduceGuiInteractions(p19, p20)
	for v35, v36 in next, p20 do
		if not v36.touching and v36.guiInteraction then
			v36.guiInteraction:release();
		end;
	end;
end;
local u4 = shared.require("GuiInteraction");
function v1._expandGuiInteractions(p21, p22)
	for v37, v38 in next, p22 do
		if v38.touching and not v38.guiInteraction then
			u4.new(v38);
		end;
	end;
end;
local l__PlayerGui__5 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");
local u6 = shared.require("GuiCollisionService");
function v1._sortAndRankInteractionData(p23, p24)
	local v39, v40 = p23._guiInput:getPosition();
	local v41 = {};
	for v42, v43 in next, l__PlayerGui__5:GetGuiObjectsAtPosition(v39, v40) do
		v41[v43] = v42;
	end;
	table.sort(p24, function(p25, p26)
		local v44 = p25.guiInterest:getLayer();
		local v45 = p26.guiInterest:getLayer();
		if v44 ~= v45 then
			return v45 < v44;
		end;
		if p25.dist ~= 0 or p26.dist ~= 0 then
			return p25.dist < p26.dist;
		end;
		return (v41[p25.guiInterest:getGui()] and (1 / 0)) < (v41[p26.guiInterest:getGui()] and (1 / 0));
	end);
	local v46 = 1;
	for v47 = 1, #p24 do
		local v48 = p24[v47];
		local v49 = v48.inRange;
		if v49 then
			local v50 = v48.guiInterest:getGroup();
			for v51 = 1, v47 - 1 do
				local v52 = p24[v51];
				if v52.touching and u6:canCollide(v50, (v52.guiInterest:getGroup())) then
					v49 = false;
					break;
				end;
			end;
		end;
		if v49 then
			local v53 = l__PlayerGui__5:GetGuiObjectsAtPosition(v48.cx, v48.cy);
			local v54 = v48.guiInterest:getGui();
			local v55 = #v53;
			local v56 = 1 - 1;
			while true do
				local v57 = v53[v56];
				if v57 == v54 then
					v49 = true;
					break;
				end;
				if v57.Active then
					v49 = false;
					break;
				end;
				if 0 <= 1 then
					if not (v56 < v55) then
						v49 = false;
						break;
					end;
				elseif not (v55 < v56) then
					v49 = false;
					break;
				end;
				v56 = v56 + 1;			
			end;
		end;
		if v49 then
			v48.precedence = v46;
			v46 = v46 + 1;
		else
			v48.precedence = nil;
		end;
		v48.touching = v49;
	end;
end;
function v1.getGuiInput(p27)
	return p27._guiInput;
end;
function v1.getInputTrigger(p28)
	return p28._inputTrigger;
end;
function v1.registerGuiInteraction(p29, p30)
	p30.destroyed:connect(function()
		local v58 = table.find(p29._interactionDataList, p30:getInteractionData());
		if v58 then
			table.remove(p29._interactionDataList, v58);
		end;
	end);
	p29.interactionAdded:fire(p30);
end;
return v1;

