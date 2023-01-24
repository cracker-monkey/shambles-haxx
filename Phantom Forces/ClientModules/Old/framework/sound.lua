
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__CurrentCamera__2 = workspace.CurrentCamera;
local v3 = Random.new(tick());
for v4 = 1, 20 do
	v3:NextNumber();
end;
v1.PreloadFolder = Instance.new("Folder");
local u1 = {};
function v1.getsound()
	if #u1 == 0 then
		local v5 = Instance.new("Sound");
		v5.Ended:connect(function()
			table.insert(u1, v5);
			v5.Parent = nil;
		end);
		v5.Stopped:connect(function()
			table.insert(u1, v5);
			v5.Parent = nil;
		end);
	else
		v5 = table.remove(u1);
	end;
	return v5;
end;
function v1.clear()
	local l__PreloadFolder__6 = v1.PreloadFolder;
	if l__PreloadFolder__6 then
		l__PreloadFolder__6:Destroy();
		v1.PreloadFolder = nil;
	end;
	for v7 = 1, #u1 do
		u1[v7]:Destroy();
		u1[v7] = nil;
	end;
end;
local l__TweenService__2 = game:GetService("TweenService");
local u3 = {};
function v1.CreateSubset(p1, ...)
	if u3[p1] then
		warn("Tried to create subset '" .. p1 .. "', which already exists.");
		return;
	end;
	local v8 = { ... };
	u3[p1] = {};
	for v9 = 1, #v8 do
		local v10 = nil;
		local v11 = v8[v9];
		v10 = "rbxassetid://";
		if type(v11) == "number" then
			local v12 = v10 .. v11;
			table.insert(u3[p1], v12);
		else
			v12 = v10 .. v11[1];
			for v13 = 1, v11[2] do
				table.insert(u3[p1], v12);
			end;
		end;
		local v14 = Instance.new("Sound");
		v14.SoundId = v12;
		v14.Parent = v1.PreloadFolder;
	end;
end;
local u4 = {};
local l__SoundService__5 = game:GetService("SoundService");
function v1.CreateSoundGroup(p2, p3)
	if u4[p2] then
		warn("Tried to create sound group '" .. p2 .. "', which already exists.");
		return;
	end;
	local v15 = script.SoundGroup:Clone();
	v15.Name = p2;
	v15.Volume = p3 and 1;
	v15.Parent = l__SoundService__5;
	u4[p2] = v15;
end;
function v1.EditSoundGroup(p4, p5, p6, p7)
	if not u4[p4] then
		warn("Tried to edit sound group '" .. p4 .. "', which doesn't exist.");
		return;
	end;
	if p5 then
		l__TweenService__2:Create(u4[p4], TweenInfo.new(p7 and 1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
			Volume = p5
		}):Play();
	end;
	if p6 then
		l__TweenService__2:Create(u4[p4].EQ, TweenInfo.new(p7 and 1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
			LowGain = p6[1], 
			MidGain = p6[2], 
			HighGain = p6[3]
		}):Play();
	end;
end;
local l__PlayerGui__6 = game:GetService("Players").LocalPlayer.PlayerGui;
function v1.PlaySound(p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19)
	debug.profilebegin("Sound.PlaySound");
	local v16 = nil;
	if u3[p8] then
		v16 = u3[p8][v3:NextInteger(1, #u3[p8])];
	end;
	if not v16 then
		debug.profileend();
		return;
	end;
	local v17 = v1.getsound();
	v17.Volume = p10 and 1;
	v17.Pitch = p11 and 1;
	v17.SoundGroup = u4[p9] and nil;
	v17.MaxDistance = p15 and 200;
	v17.EmitterSize = p16 and 20;
	v17.RollOffMode = p17 or Enum.RollOffMode.InverseTapered;
	v17.Name = p8;
	if p12 and p13 then
		v17.Pitch = v17.Pitch + ((p13 - p12) * v3:NextNumber() + p12);
	end;
	v17.SoundId = v16;
	v17.Looped = p19;
	v17.Parent = p14 or l__PlayerGui__6;
	v17:Play();
	if p18 then
		v17.PlayOnRemove = true;
	else
		v17.PlayOnRemove = false;
	end;
	debug.profileend();
end;
function v1.PlaySoundId(p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30)
	debug.profilebegin("Sound.PlaySoundId");
	local v18 = v1.getsound();
	v18.Volume = p21 and 1;
	v18.Pitch = p22 and 1;
	v18.SoundGroup = nil;
	v18.MaxDistance = p24 and 200;
	v18.EmitterSize = p27 and 20;
	v18.RollOffMode = p28 or Enum.RollOffMode.InverseTapered;
	v18.Name = "Sound";
	if p25 and p26 then
		v18.Pitch = v18.Pitch + ((p26 - p25) * math.random() + p25);
	end;
	v18.SoundId = p20;
	v18.Looped = p30;
	v18.Parent = p23 or l__PlayerGui__6;
	v18:Play();
	if p29 then
		v18.PlayOnRemove = true;
	else
		v18.PlayOnRemove = false;
	end;
	debug.profileend();
end;
function v1.GetPreloadFolder()
	return v1.PreloadFolder;
end;
function v1.play(p31, p32, p33, p34, p35, p36)
	v1.PlaySound(p31, nil, p32, p33, nil, nil, p34, nil, nil, nil, p35, p36);
end;
require(script.Sets)(v1);
return v1;

