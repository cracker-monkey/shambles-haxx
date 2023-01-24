
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local function u2(p1)
	local v2 = p1.Parent;
	while not v2:IsA("ScreenGui") do
		v2 = v2.Parent;
		if v2 == game then
			error("UIScaleUpdater: " .. p1 .. " not parented under a ScreenGui");
		end;	
	end;
	return v2;
end;
function v1.new(p2)
	local v3 = setmetatable({}, v1);
	v3._destructor = u1.new();
	local v4 = u2(p2);
	if not v4 then
		return;
	end;
	v3._scale = 1;
	v3._screenGui = v4;
	v3._uiscaleObject = p2;
	v3._baseSizeX = p2.BaseX.Value;
	v3._baseSizeY = p2.BaseY.Value;
	v3._prevUIScaleParent = p2.Parent;
	v3._aspectRatioEnabled = true;
	v3._uiAspectRatioObject = v4:FindFirstChild("UIAspectRatioConstraint", true);
	if v3._uiAspectRatioObject then
		v3._prevParent = v3._uiAspectRatioObject.Parent;
	end;
	v3._destructor:add(v4:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		v3:update();
	end));
	v3:update();
	return v3;
end;
function v1.getScale(p3)
	return p3._scale;
end;
function v1.getRawScale(p4)
	return p4._uiscaleObject.Scale;
end;
function v1.setScale(p5, p6)
	p5._scale = p6;
	p5:update();
end;
function v1.toggleAspectRatio(p7, p8)
	p7._aspectRatioEnabled = p8;
	p7:update();
end;
function v1.update(p9)
	task.wait();
	local l___uiscaleObject__5 = p9._uiscaleObject;
	local l___baseSizeY__6 = p9._baseSizeY;
	local l___baseSizeX__7 = p9._baseSizeX;
	local l__AbsoluteSize__8 = p9._screenGui.AbsoluteSize;
	local l__X__9 = l__AbsoluteSize__8.X;
	local l__Y__10 = l__AbsoluteSize__8.Y;
	local v11 = math.round(l__X__9 / l___baseSizeX__7 * 50) / 50;
	local v12 = math.round(l__Y__10 / l___baseSizeY__6 * 50) / 50;
	if l___baseSizeX__7 / l___baseSizeY__6 <= l__X__9 / l__Y__10 then
		l___uiscaleObject__5.Scale = v12 * p9._scale;
	else
		l___uiscaleObject__5.Scale = v11 * p9._scale;
	end;
	local l___uiAspectRatioObject__13 = p9._uiAspectRatioObject;
	if l___uiAspectRatioObject__13 then
		l___uiAspectRatioObject__13.Parent = nil;
	end;
	l___uiscaleObject__5.Parent = nil;
	task.wait();
	if l___uiAspectRatioObject__13 and p9._aspectRatioEnabled then
		l___uiAspectRatioObject__13.Parent = p9._prevParent;
	end;
	l___uiscaleObject__5.Parent = p9._prevUIScaleParent;
end;
function v1.Destroy(p10)
	p10._destructor:Destroy();
end;
return v1;

