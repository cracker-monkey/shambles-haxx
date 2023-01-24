
-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
v1.__index = v1;
local u1 = shared.require("Destructor");
local u2 = shared.require("DestructorGroup");
function v1.new(p1, p2, p3)
	local v2 = setmetatable({}, v1);
	v2._destructor = u1.new();
	v2._destructorGroup = u2.new();
	v2._destructor:add(v2._destructorGroup);
	v2._guiObject = p1;
	v2._guiObject.Visible = false;
	v2._buttonConfirm = p2;
	v2._buttonCancel = p3;
	return v2;
end;
function v1.Destroy(p4)
	p4._destructor:Destroy();
end;
function v1.isActive(p5)
	return p5._guiObject.Visible;
end;
local u3 = shared.require("GuiInputInterface");
local u4 = shared.require("UIHighlight");
local u5 = shared.require("MenuColorConfig");
function v1.activate(p6, p7, p8, p9, p10)
	if p8 and type(p8) ~= "function" then
		warn("UIPrompt: Confirm Function argument is not a function", p8);
		return;
	end;
	if p9 and type(p9) ~= "function" then
		warn("UIPrompt: Cancel Function argument is not a function", p8);
		return;
	end;
	if type(p10) == "function" and p10() then
		p8();
		p6:deactivate();
		return;
	end;
	local v3 = p6._destructorGroup:runAndReplace("input");
	p6._guiObject.Title.Text = p7;
	if p6._buttonConfirm then
		v3:add(u3.onReleased(p6._buttonConfirm, function()
			if p8 then
				p8();
			end;
			p6:deactivate();
		end));
	end;
	if p6._buttonCancel then
		v3:add(u3.onReleased(p6._buttonCancel, function()
			if p9 then
				p9();
			end;
			p6:deactivate();
		end));
	end;
	if p6._buttonConfirm then
		v3:add(u4.new(p6._buttonConfirm, {
			highlightColor3 = u5.promptConfirmColorConfig.highlighted.BackgroundColor3, 
			defaultColor3 = u5.promptConfirmColorConfig.default.BackgroundColor3
		}));
	end;
	if p6._buttonCancel then
		v3:add(u4.new(p6._buttonCancel, {
			highlightColor3 = u5.promptCancelColorConfig.highlighted.BackgroundColor3, 
			defaultColor3 = u5.promptCancelColorConfig.default.BackgroundColor3
		}));
	end;
	p6._guiObject.Visible = true;
end;
function v1.deactivate(p11)
	p11._guiObject.Visible = false;
end;
return v1;

