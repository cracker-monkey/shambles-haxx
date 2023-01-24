getgenv().runService = game:GetService"RunService"
getgenv().textService = game:GetService"TextService"
getgenv().inputService = game:GetService"UserInputService"
getgenv().tweenService = game:GetService"TweenService"

local gamename = game.PlaceId == 9993529229 and "Counter Blox" or "Universal"

if getgenv().library then
	getgenv().library:Unload()
end
if getgenv().Watermarke then
    getgenv().Watermarke()
end

local function log(text)
	rconsoleprint(string.format("%s\n", text))
end

local function rotateVector2(v2, r)
    local c = math.cos(r);
    local s = math.sin(r);
    return Vector2.new(c * v2.X - s*v2.Y, s*v2.X + c*v2.Y)
end

local function find_2d_distance( pos1, pos2 )
    local dx = pos1.X - pos2.X
    local dy = pos1.Y - pos2.Y
    return math.sqrt ( dx * dx + dy * dy )
end

local ChatSpam = {
	"Alsike > all",
	"Tbh you suck...", 
	"Skill issue and hack issue.",
	"Bro you no have cheats ? (70% visible WH)",
	"You dont mom",
	"CHEATERSOUL 2020",
	"Day n Nite",
	"WHO>?",
	"you are a nn..",
	"BRO VOTEKICK M+9",
	"Idk what are u mean",
	"I don't will show u anything",
	"Are u care",
	"Show ur brains",
	"Say who u on real life",
}

local ChatSize = 0

for _ in pairs(ChatSpam) do
	ChatSize = ChatSize + 1
end

local drawingPool                = {}
local function newDrawing(type, prop)
    local obj = Drawing.new(type)
    if prop then
        for i,v in next, prop do
            obj[i] = v
        end
    end
    return obj  
end

for i,v in next, drawingPool do
    if not v.used then
        v.used = true
        drawing = v
        break
    end
end

local esp = {
    BoxFill = 0.5,
    ChamsF = 0.5,
    ChamsO = 0.5,
	BoxFillL = 0.5,
    ChamsFL = 0.5,
    ChamsOL = 0.5,
    F1 = 1,
    F2 = 1,
	F3 = 1,
	F4 = 1,	
	WeaponChams = 0.5,
	HandChams = 0.5,
}

local eventLogs = {}

local function gs(a)
    return game:GetService(a)
end

local library = {design = getgenv().design == "kali" and "kali" or "Alsike", tabs = {}, draggable = true, flags = {}, title = "alsike", open = false, mousestate = inputService.MouseIconEnabled, popup = nil, instances = {}, connections = {}, options = {}, notifications = {}, tabSize = 0, theme = {}, foldername = "alsike", configgame = gamename, fileext = ".al"}
local title = "alsike"
getgenv().library = library

--Locals
local dragging, dragInput, dragStart, startPos, dragObject

local blacklistedKeys = {
	Enum.KeyCode.Unknown,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Slash,Enum.KeyCode.Tab,Enum.KeyCode.Escape
}
local whitelistedMouseinputs = {
	Enum.UserInputType.MouseButton1,Enum.UserInputType.MouseButton2,Enum.UserInputType.MouseButton3
}

--Functions
library.round = function(num, bracket)
	if typeof(num) == "Vector2" then
		return Vector2.new(library.round(num.X), library.round(num.Y))
	elseif typeof(num) == "Vector3" then
		return Vector3.new(library.round(num.X), library.round(num.Y), library.round(num.Z))
	elseif typeof(num) == "Color3" then
		return library.round(num.r * 255), library.round(num.g * 255), library.round(num.b * 255)
	else
		return num - num % (bracket or 1);
	end
end

local chromaColor
spawn(function()
	while library and wait() do
		chromaColor = Color3.fromHSV(tick() % 6 / 6, 1, 1)
	end
end)

function library:Create(class, properties)
	properties = properties or {}
	if not class then return end
	local a = class == "Square" or class == "Line" or class == "Text" or class == "Quad" or class == "Circle" or class == "Triangle"
	local t = a and Drawing or Instance
	local inst = t.new(class)
	for property, value in next, properties do
		inst[property] = value
	end
	table.insert(self.instances, {object = inst, method = a})
	return inst
end

function library:AddConnection(connection, name, callback)
	callback = type(name) == "function" and name or callback
	connection = connection:connect(callback)
	if name ~= callback then
		self.connections[name] = connection
	else
		table.insert(self.connections, connection)
	end
	return connection
end

function library:Unload()
	inputService.MouseIconEnabled = self.mousestate
	for _, c in next, self.connections do
		c:Disconnect()
	end
	for _, i in next, self.instances do
		if i.method then
			pcall(function() i.object:Remove() end)
		else
			i.object:Destroy()
		end
	end
	for _, o in next, self.options do
		if o.type == "toggle" then
			coroutine.resume(coroutine.create(o.SetState, o))
		end
	end
	library = nil
	getgenv().library = nil
end

function library:LoadConfig(config)
	if table.find(self:GetConfigs(), config) then
		local Read, Config = pcall(function() return game:GetService"HttpService":JSONDecode(readfile(""..self.foldername.."/" ..self.configgame.."/".. config .. self.fileext)) end)
		Config = Read and Config or {}
		for _, option in next, self.options do
			if option.hasInit then
				if option.type ~= "button" and option.flag and not option.skipflag then
					if option.type == "toggle" then
						spawn(function() option:SetState(Config[option.flag] == 1) end)
					elseif option.type == "color" then
						if Config[option.flag] then
							spawn(function() option:SetColor(Config[option.flag]) end)
							if option.trans then
								spawn(function() option:SetTrans(Config[option.flag .. " Transparency"]) end)
							end
						end
					elseif option.type == "bind" then
						spawn(function() option:SetKey(Config[option.flag]) end)
					else
						spawn(function() option:SetValue(Config[option.flag]) end)
					end
				end
			end
		end
	end
end

function library:SaveConfig(config)
	local Config = {}
	if table.find(self:GetConfigs(), config) then
		Config = game:GetService"HttpService":JSONDecode(readfile(""..self.foldername.."/" ..self.configgame.."/".. config .. self.fileext))
	end
	for _, option in next, self.options do
		if option.type ~= "button" and option.flag and not option.skipflag then
			if option.type == "toggle" then
				Config[option.flag] = option.state and 1 or 0
			elseif option.type == "color" then
				Config[option.flag] = {option.color.r, option.color.g, option.color.b}
				if option.trans then
					Config[option.flag .. " Transparency"] = option.trans
				end
			elseif option.type == "bind" then
				if option.key ~= "none" then
					Config[option.flag] = option.key
				end
			elseif option.type == "list" then
				Config[option.flag] = option.value
			else
				Config[option.flag] = option.value
			end
		end
	end
	writefile(""..self.foldername.."/" ..self.configgame.."/".. config .. self.fileext, game:GetService"HttpService":JSONEncode(Config))
end

function library:GetConfigs()
	if not isfolder(self.foldername) then
		makefolder(self.foldername)
		return {}
	end
	if not isfolder(""..self.foldername.."/"..self.configgame) then
		makefolder(""..self.foldername.."/"..self.configgame)
	end

	local files = {}
	local a = 0
	for i,v in next, listfiles(""..self.foldername.."/" ..self.configgame) do
		if v:sub(#v - #self.fileext + 1, #v) == self.fileext then
			a = a + 1
			v = v:gsub(""..self.foldername.."/" ..self.configgame.. "\\", "")
			v = v:gsub(self.fileext, "")
			table.insert(files, a, v)
		end
	end
	return files
end

library.createLabel = function(option, parent)
	option.main = library:Create("TextLabel", {
		LayoutOrder = option.position,
		Position = UDim2.new(0, 6, 0, 0),
		Size = UDim2.new(1, -12, 0, 24),
		BackgroundTransparency = 1,
		TextSize = 15,
		Font = Enum.Font.Code,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Parent = parent
	})

	setmetatable(option, {__newindex = function(t, i, v)
		if i == "Text" then
			option.main.Text = tostring(v)
			option.main.Size = UDim2.new(1, -12, 0, textService:GetTextSize(option.main.Text, 15, Enum.Font.Code, Vector2.new(option.main.AbsoluteSize.X, 9e9)).Y + 6)
		end
	end})
	option.Text = option.text
end

library.createDivider = function(option, parent)
	option.main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		Parent = parent
	})

	library:Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -24, 0, 1),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderColor3 = Color3.new(),
		Parent = option.main
	})

	option.title = library:Create("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0,
		TextColor3 =  Color3.new(1, 1, 1),
		TextSize = 15,
		Font = Enum.Font.Code,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = option.main
	})

	setmetatable(option, {__newindex = function(t, i, v)
		if i == "Text" then
			if v then
				option.title.Text = tostring(v)
				option.title.Size = UDim2.new(0, textService:GetTextSize(option.title.Text, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X + 12, 0, 20)
				option.main.Size = UDim2.new(1, 0, 0, 18)
			else
				option.title.Text = ""
				option.title.Size = UDim2.new()
				option.main.Size = UDim2.new(1, 0, 0, 6)
			end
		end
	end})
	option.Text = option.text
end

library.createToggle = function(option, parent)
	option.hasInit = true

	option.main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1,
		Parent = parent
	})

	local tickbox
	local tickboxOverlay
	if option.style then
		tickbox = library:Create("ImageLabel", {
			Position = UDim2.new(0, 6, 0, 4),
			Size = UDim2.new(0, 12, 0, 12),
			BackgroundTransparency = 1,
			Image = "rbxassetid://3570695787",
			ImageColor3 = Color3.new(),
			Parent = option.main
		})

		library:Create("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -2, 1, -2),
			BackgroundTransparency = 1,
			Image = "rbxassetid://3570695787",
			ImageColor3 = Color3.fromRGB(60, 60, 60),
			Parent = tickbox
		})

		library:Create("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -6, 1, -6),
			BackgroundTransparency = 1,
			Image = "rbxassetid://3570695787",
			ImageColor3 = Color3.fromRGB(40, 40, 40),
			Parent = tickbox
		})

		tickboxOverlay = library:Create("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -6, 1, -6),
			BackgroundTransparency = 1,
			Image = "rbxassetid://3570695787",
			ImageColor3 = library.flags["Menu Accent Color"],
			Visible = option.state,
			Parent = tickbox
		})

		table.insert(library.theme, tickboxOverlay)
	else
		tickbox = library:Create("Frame", {
			Position = UDim2.new(0, 6, 0, 4),
			Size = UDim2.new(0, 12, 0, 12),
			BackgroundColor3 = library.flags["Menu Accent Color"],
			BorderColor3 = Color3.new(),
			Parent = option.main
		})

		tickboxOverlay = library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = option.state and 1 or 0,
			BackgroundColor3 = Color3.fromRGB(45, 45, 45),
			BorderColor3 = Color3.new(),
			Image = "rbxassetid://4155801252",
			ImageTransparency = 0.6,
			ImageColor3 = Color3.new(),
			Parent = tickbox
		})

		library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2592362371",
			ImageColor3 = Color3.fromRGB(60, 60, 60),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 62, 62),
			Parent = tickbox
		})

		table.insert(library.theme, tickbox)
	end

	option.interest = library:Create("Frame", {
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1,
		Parent = option.main
	})

	option.title = library:Create("TextLabel", {
		Position = UDim2.new(0, 24, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = option.text,
		TextColor3 =  option.state and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(180, 180, 180),
		TextSize = 15,
		Font = Enum.Font.Code,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = option.interest
	})

	option.interest.InputBegan:connect(function(input)
		if input.UserInputType.Name == "MouseButton1" then
			option:SetState(not option.state)
		end
		if input.UserInputType.Name == "MouseMovement" then
			if not library.warning and not library.slider then
				if option.style then
					tickbox.ImageColor3 = library.flags["Menu Accent Color"]
					--tweenService:Create(tickbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = library.flags["Menu Accent Color"]}):Play()
				else
					tickbox.BorderColor3 = library.flags["Menu Accent Color"]
					tickboxOverlay.BorderColor3 = library.flags["Menu Accent Color"]
					--tweenService:Create(tickbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = library.flags["Menu Accent Color"]}):Play()
					--tweenService:Create(tickboxOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = library.flags["Menu Accent Color"]}):Play()
				end
			end
			if option.tip then
				library.tooltip.Text = option.tip
				library.tooltip.Size = UDim2.new(0, textService:GetTextSize(option.tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
			end
		end
	end)

	option.interest.InputChanged:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			if option.tip then
				library.tooltip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
			end
		end
	end)

	option.interest.InputEnded:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			if option.style then
				tickbox.ImageColor3 = Color3.new()
				--tweenService:Create(tickbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.new()}):Play()
			else
				tickbox.BorderColor3 = Color3.new()
				tickboxOverlay.BorderColor3 = Color3.new()
				--tweenService:Create(tickbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = Color3.new()}):Play()
				--tweenService:Create(tickboxOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = Color3.new()}):Play()
			end
			library.tooltip.Position = UDim2.new(2)
		end
	end)

	function option:SetState(state, nocallback)
		state = typeof(state) == "boolean" and state
		state = state or false
		library.flags[self.flag] = state
		self.state = state
		option.title.TextColor3 = state and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(160, 160, 160)
		if option.style then
			tickboxOverlay.Visible = state
		else
			tickboxOverlay.BackgroundTransparency = state and 1 or 0
		end
		if not nocallback then
			self.callback(state)
		end
	end

	if option.state ~= nil then
		delay(1, function()
			if library then
				option.callback(option.state)
			end
		end)
	end

	setmetatable(option, {__newindex = function(t, i, v)
		if i == "Text" then
			option.title.Text = tostring(v)
		end
	end})
end

library.createButton = function(option, parent)
	option.hasInit = true

	option.main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Parent = parent
	})

	option.title = library:Create("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -5),
		Size = UDim2.new(1, -12, 0, 18),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BorderColor3 = Color3.new(),
		Text = option.text,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 15,
		Font = Enum.Font.Code,
		Parent = option.main
	})

	library:Create("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2592362371",
		ImageColor3 = Color3.fromRGB(60, 60, 60),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(2, 2, 62, 62),
		Parent = option.title
	})

	library:Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 180)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(253, 253, 253)),
		}),
		Rotation = -90,
		Parent = option.title
	})

	option.title.InputBegan:connect(function(input)
		if input.UserInputType.Name == "MouseButton1" then
			option.callback()
			if library then
				library.flags[option.flag] = true
			end
			if option.tip then
				library.tooltip.Text = option.tip
				library.tooltip.Size = UDim2.new(0, textService:GetTextSize(option.tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
			end
		end
		if input.UserInputType.Name == "MouseMovement" then
			if not library.warning and not library.slider then
				option.title.BorderColor3 = library.flags["Menu Accent Color"]
			end
		end
	end)

	option.title.InputChanged:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			if option.tip then
				library.tooltip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
			end
		end
	end)

	option.title.InputEnded:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			option.title.BorderColor3 = Color3.new()
			library.tooltip.Position = UDim2.new(2)
		end
	end)
end

library.createBind = function(option, parent)
	option.hasInit = true

	local binding
	local holding
	local Loop

	if option.sub then
		option.main = option:getMain()
	else
		option.main = option.main or library:Create("Frame", {
			LayoutOrder = option.position,
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Parent = parent
		})

		library:Create("TextLabel", {
			Position = UDim2.new(0, 6, 0, 0),
			Size = UDim2.new(1, -12, 1, 0),
			BackgroundTransparency = 1,
			Text = option.text,
			TextSize = 15,
			Font = Enum.Font.Code,
			TextColor3 = Color3.fromRGB(210, 210, 210),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = option.main
		})
	end

	local bindinput = library:Create(option.sub and "TextButton" or "TextLabel", {
		Position = UDim2.new(1, -6 - (option.subpos or 0), 0, option.sub and 2 or 3),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0,
		TextSize = 15,
		Font = Enum.Font.Code,
		TextColor3 = Color3.fromRGB(160, 160, 160),
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = option.main
	})

	if option.sub then
		bindinput.AutoButtonColor = false
	end

	local interest = option.sub and bindinput or option.main
	local inContact
	interest.InputEnded:connect(function(input)
		if input.UserInputType.Name == "MouseButton1" then
			binding = true
			bindinput.Text = "[...]"
			bindinput.Size = UDim2.new(0, -textService:GetTextSize(bindinput.Text, 16, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 16)
			bindinput.TextColor3 = library.flags["Menu Accent Color"]
		end
	end)

	library:AddConnection(inputService.InputBegan, function(input)
		if inputService:GetFocusedTextBox() then return end
		if binding then
			local key = (table.find(whitelistedMouseinputs, input.UserInputType) and not option.nomouse) and input.UserInputType
			option:SetKey(key or (not table.find(blacklistedKeys, input.KeyCode)) and input.KeyCode)
		else
			if (input.KeyCode.Name == option.key or input.UserInputType.Name == option.key) and not binding then
				if option.mode == "toggle" then
					library.flags[option.flag] = not library.flags[option.flag]
					option.callback(library.flags[option.flag], 0)
				else
					library.flags[option.flag] = true
					if Loop then Loop:Disconnect() option.callback(true, 0) end
					Loop = library:AddConnection(runService.RenderStepped, function(step)
						if not inputService:GetFocusedTextBox() then
							option.callback(nil, step)
						end
					end)
				end
			end
		end
	end)

	library:AddConnection(inputService.InputEnded, function(input)
		if option.key ~= "none" then
			if input.KeyCode.Name == option.key or input.UserInputType.Name == option.key then
				if Loop then
					Loop:Disconnect()
					library.flags[option.flag] = false
					option.callback(true, 0)
				end
			end
		end
	end)

	function option:SetKey(key)
		binding = false
		bindinput.TextColor3 = Color3.fromRGB(160, 160, 160)
		if Loop then Loop:Disconnect() library.flags[option.flag] = false option.callback(true, 0) end
		self.key = (key and key.Name) or key or self.key
		if self.key == "Backspace" then
			self.key = "none"
			bindinput.Text = "[NONE]"
		else
			local a = self.key
			if self.key:match"Mouse" then
				a = self.key:gsub("Button", ""):gsub("Mouse", "M")
			elseif self.key:match"Shift" or self.key:match"Alt" or self.key:match"Control" then
				a = self.key:gsub("Left", "L"):gsub("Right", "R")
			end
			bindinput.Text = "[" .. a:gsub("Control", "CTRL"):upper() .. "]"
		end
		bindinput.Size = UDim2.new(0, -textService:GetTextSize(bindinput.Text, 16, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 16)
	end
	option:SetKey()
end

library.createSlider = function(option, parent)
	option.hasInit = true

	if option.sub then
		option.main = option:getMain()
		option.main.Size = UDim2.new(1, 0, 0, 42)
	else
		option.main = library:Create("Frame", {
			LayoutOrder = option.position,
			Size = UDim2.new(1, 0, 0, option.textpos and 24 or 40),
			BackgroundTransparency = 1,
			Parent = parent
		})
	end

	option.slider = library:Create("Frame", {
		Position = UDim2.new(0, 6, 0, (option.sub and 22 or option.textpos and 4 or 20)),
		Size = UDim2.new(1, -12, 0, 14),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BorderColor3 = Color3.new(),
		Parent = option.main
	})

	library:Create("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2454009026",
		ImageColor3 = Color3.new(),
		ImageTransparency = 0.8,
		Parent = option.slider
	})

	option.fill = library:Create("Frame", {
		BackgroundColor3 = library.flags["Menu Accent Color"],
		BorderSizePixel = 0,
		Parent = option.slider
	})

	library:Create("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2592362371",
		ImageColor3 = Color3.fromRGB(60, 60, 60),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(2, 2, 62, 62),
		Parent = option.slider
	})

	option.title = library:Create("TextBox", {
		Position = UDim2.new((option.sub or option.textpos) and 0.5 or 0, (option.sub or option.textpos) and 0 or 6, 0, 0),
		Size = UDim2.new(0, 0, 0, (option.sub or option.textpos) and 16 or 18),
		BackgroundTransparency = 1,
		Text = (option.text == "nil" and "" or option.text .. ": ") .. option.value .. option.suffix,
		TextSize = (option.sub or option.textpos) and 14 or 15,
		Font = Enum.Font.Code,
		TextColor3 = Color3.fromRGB(210, 210, 210),
		TextXAlignment = Enum.TextXAlignment[(option.sub or option.textpos) and "Center" or "Left"],
		Parent = (option.sub or option.textpos) and option.slider or option.main
	})

	if option.sub then
		option.title.Position = UDim2.new((option.sub or option.textpos) and 0.5 or 0, (option.sub or option.textpos) and 0 or 6, 0, -2)
	end
	
	table.insert(library.theme, option.fill)

	library:Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(115, 115, 115)),
			ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
		}),
		Rotation = -90,
		Parent = option.fill
	})

	if option.min >= 0 then
		option.fill.Size = UDim2.new((option.value - option.min) / (option.max - option.min), 0, 1, 0)
	else
		option.fill.Position = UDim2.new((0 - option.min) / (option.max - option.min), 0, 0, 0)
		option.fill.Size = UDim2.new(option.value / (option.max - option.min), 0, 1, 0)
	end

	local manualInput
	option.title.Focused:connect(function()
		if not manualInput then
			option.title:ReleaseFocus()
			option.title.Text = (option.text == "nil" and "" or option.text .. ": ") .. option.value .. option.suffix
		end
	end)

	option.title.FocusLost:connect(function()
		option.slider.BorderColor3 = Color3.new()
		if manualInput then
			if tonumber(option.title.Text) then
				option:SetValue(tonumber(option.title.Text))
			else
				option.title.Text = (option.text == "nil" and "" or option.text .. ": ") .. option.value .. option.suffix
			end
		end
		manualInput = false
	end)

	local interest = (option.sub or option.textpos) and option.slider or option.main
	interest.InputBegan:connect(function(input)
		if input.UserInputType.Name == "MouseButton1" then
			if inputService:IsKeyDown(Enum.KeyCode.LeftControl) or inputService:IsKeyDown(Enum.KeyCode.RightControl) then
				manualInput = true
				option.title:CaptureFocus()
			else
				library.slider = option
				option.slider.BorderColor3 = library.flags["Menu Accent Color"]
				option:SetValue(option.min + ((input.Position.X - option.slider.AbsolutePosition.X) / option.slider.AbsoluteSize.X) * (option.max - option.min))
			end
		end
		if input.UserInputType.Name == "MouseMovement" then
			if not library.warning and not library.slider then
				option.slider.BorderColor3 = library.flags["Menu Accent Color"]
			end
			if option.tip then
				library.tooltip.Text = option.tip
				library.tooltip.Size = UDim2.new(0, textService:GetTextSize(option.tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
			end
		end
	end)

	interest.InputChanged:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			if option.tip then
				library.tooltip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
			end
		end
	end)

	interest.InputEnded:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			library.tooltip.Position = UDim2.new(2)
			if option ~= library.slider then
				option.slider.BorderColor3 = Color3.new()
				--option.fill.BorderColor3 = Color3.new()
			end
		end
	end)

	function option:SetValue(value, nocallback)
		if typeof(value) ~= "number" then value = 0 end
		value = library.round(value, option.float)
		value = math.clamp(value, self.min, self.max)
		if self.min >= 0 then
			option.fill:TweenSize(UDim2.new((value - self.min) / (self.max - self.min), 0, 1, 0), "Out", "Quad", 0.05, true)
		else
			option.fill:TweenPosition(UDim2.new((0 - self.min) / (self.max - self.min), 0, 0, 0), "Out", "Quad", 0.05, true)
			option.fill:TweenSize(UDim2.new(value / (self.max - self.min), 0, 1, 0), "Out", "Quad", 0.1, true)
		end
		library.flags[self.flag] = value
		self.value = value
		option.title.Text = (option.text == "nil" and "" or option.text .. ": ") .. option.value .. option.suffix
		if not nocallback then
			self.callback(value)
		end
	end
	delay(1, function()
		if library then
			option:SetValue(option.value)
		end
	end)
end

library.createList = function(option, parent)
	option.hasInit = true

	if option.sub then
		option.main = option:getMain()
		option.main.Size = UDim2.new(1, 0, 0, 48)
	else
		option.main = library:Create("Frame", {
			LayoutOrder = option.position,
			Size = UDim2.new(1, 0, 0, option.text == "nil" and 30 or 48),
			BackgroundTransparency = 1,
			Parent = parent
		})

		if option.text ~= "nil" then
			library:Create("TextLabel", {
				Position = UDim2.new(0, 6, 0, 0),
				Size = UDim2.new(1, -12, 0, 18),
				BackgroundTransparency = 1,
				Text = option.text,
				TextSize = 15,
				Font = Enum.Font.Code,
				TextColor3 = Color3.fromRGB(210, 210, 210),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = option.main
			})
		end
	end

	local function getMultiText()
		local s = ""
		for _, value in next, option.values do
			s = s .. (option.value[value] and (tostring(value) .. ", ") or "")
		end
		return string.sub(s, 1, #s - 2)
	end

	option.listvalue = library:Create("TextLabel", {
		Position = UDim2.new(0, 6, 0, (option.text == "nil" and not option.sub) and 4 or 22),
		Size = UDim2.new(1, -12, 0, 18),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BorderColor3 = Color3.new(),
		Text = " " .. (typeof(option.value) == "string" and option.value or getMultiText()),
		TextSize = 15,
		Font = Enum.Font.Code,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = option.main
	})

	library:Create("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2454009026",
		ImageColor3 = Color3.new(),
		ImageTransparency = 0.8,
		Parent = option.listvalue
	})

	library:Create("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2592362371",
		ImageColor3 = Color3.fromRGB(60, 60, 60),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(2, 2, 62, 62),
		Parent = option.listvalue
	})


	option.arrow = library:Create("ImageLabel", {
		Position = UDim2.new(1, -16, 0, 5),
		Size = UDim2.new(0, 8, 0, 8),
		Rotation = 90,
		BackgroundTransparency = 1,
		Image = "rbxassetid://4918373417",
		ImageColor3 = Color3.new(1, 1, 1),
		ScaleType = Enum.ScaleType.Fit,
		ImageTransparency = 0.4,
		Parent = option.listvalue
	})

	option.holder = library:Create("TextButton", {
		ZIndex = 4,
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderColor3 = Color3.new(),
		Text = "",
		AutoButtonColor = false,
		Visible = false,
		Parent = library.base
	})

	option.content = library:Create("ScrollingFrame", {
		ZIndex = 4,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarImageColor3 = Color3.new(),
		ScrollBarThickness = 3,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		VerticalScrollBarInset = Enum.ScrollBarInset.Always,
		TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
		BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
		Parent = option.holder
	})

	library:Create("ImageLabel", {
		ZIndex = 4,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2592362371",
		ImageColor3 = Color3.fromRGB(60, 60, 60),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(2, 2, 62, 62),
		Parent = option.holder
	})

	local layout = library:Create("UIListLayout", {
		Padding = UDim.new(0, 2),
		Parent = option.content
	})

	library:Create("UIPadding", {
		PaddingTop = UDim.new(0, 4),
		PaddingLeft = UDim.new(0, 4),
		Parent = option.content
	})

	local valueCount = 0
	layout.Changed:connect(function()
		option.holder.Size = UDim2.new(0, option.listvalue.AbsoluteSize.X, 0, 8 + (valueCount > option.max and (-2 + (option.max * 22)) or layout.AbsoluteContentSize.Y))
		option.content.CanvasSize = UDim2.new(0, 0, 0, 8 + layout.AbsoluteContentSize.Y)
	end)
	local interest = option.sub and option.listvalue or option.main

	option.listvalue.InputBegan:connect(function(input)
		if input.UserInputType.Name == "MouseButton1" then
			if library.popup == option then library.popup:Close() return end
			if library.popup then
				library.popup:Close()
			end
			option.arrow.Rotation = -90
			option.open = true
			option.holder.Visible = true
			local pos = option.main.AbsolutePosition
			option.holder.Position = UDim2.new(0, pos.X + 6, 0, pos.Y + ((option.text == "nil" and not option.sub) and 66 or 84))
			library.popup = option
			option.listvalue.BorderColor3 = library.flags["Menu Accent Color"]
		end
		if input.UserInputType.Name == "MouseMovement" then
			if not library.warning and not library.slider then
				option.listvalue.BorderColor3 = library.flags["Menu Accent Color"]
			end
		end
	end)

	option.listvalue.InputEnded:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			if not option.open then
				option.listvalue.BorderColor3 = Color3.new()
			end
		end
	end)

	interest.InputBegan:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			if option.tip then
				library.tooltip.Text = option.tip
				library.tooltip.Size = UDim2.new(0, textService:GetTextSize(option.tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
			end
		end
	end)

	interest.InputChanged:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			if option.tip then
				library.tooltip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
			end
		end
	end)

	interest.InputEnded:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			library.tooltip.Position = UDim2.new(2)
		end
	end)

	local selected
	function option:AddValue(value, state)
		if self.labels[value] then return end
		valueCount = valueCount + 1

		if self.multiselect then
			self.values[value] = state
		else
			if not table.find(self.values, value) then
				table.insert(self.values, value)
			end
		end

		local label = library:Create("TextLabel", {
			ZIndex = 4,
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = value,
			TextSize = 15,
			Font = Enum.Font.Code,
			TextTransparency = self.multiselect and (self.value[value] and 1 or 0) or self.value == value and 1 or 0,
			TextColor3 = Color3.fromRGB(210, 210, 210),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = option.content
		})
		self.labels[value] = label

		local labelOverlay = library:Create("TextLabel", {
			ZIndex = 4,	
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = " " ..value,
			TextSize = 15,
			Font = Enum.Font.Code,
			TextColor3 = library.flags["Menu Accent Color"],
			TextXAlignment = Enum.TextXAlignment.Left,
			Visible = self.multiselect and self.value[value] or self.value == value,
			Parent = label
		})
		selected = selected or self.value == value and labelOverlay
		table.insert(library.theme, labelOverlay)

		label.InputBegan:connect(function(input)
			if input.UserInputType.Name == "MouseButton1" then
				if self.multiselect then
					self.value[value] = not self.value[value]
					self:SetValue(self.value)
				else
					self:SetValue(value)
					self:Close()
				end
			end
		end)
	end

	for i, value in next, option.values do
		option:AddValue(tostring(typeof(i) == "number" and value or i))
	end

	function option:RemoveValue(value)
		local label = self.labels[value]
		if label then
			label:Destroy()
			self.labels[value] = nil
			valueCount = valueCount - 1
			if self.multiselect then
				self.values[value] = nil
				self:SetValue(self.value)
			else
				table.remove(self.values, table.find(self.values, value))
				if self.value == value then
					selected = nil
					self:SetValue(self.values[1] or "")
				end
			end
		end
	end

	function option:SetValue(value, nocallback)
		if self.multiselect and typeof(value) ~= "table" then
			value = {}
			for i,v in next, self.values do
				value[v] = false
			end
		end
		self.value = typeof(value) == "table" and value or tostring(table.find(self.values, value) and value or self.values[1])
		library.flags[self.flag] = self.value
		option.listvalue.Text = " " .. (self.multiselect and getMultiText() or self.value)
		if self.multiselect then
			for name, label in next, self.labels do
				label.TextTransparency = self.value[name] and 1 or 0
				if label:FindFirstChild"TextLabel" then
					label.TextLabel.Visible = self.value[name]
				end
			end
		else
			if selected then
				selected.TextTransparency = 0
				if selected:FindFirstChild"TextLabel" then
					selected.TextLabel.Visible = false
				end
			end
			if self.labels[self.value] then
				selected = self.labels[self.value]
				selected.TextTransparency = 1
				if selected:FindFirstChild"TextLabel" then
					selected.TextLabel.Visible = true
				end
			end
		end
		if not nocallback then
			self.callback(self.value)
		end
	end
	delay(1, function()
		if library then
			option:SetValue(option.value)
		end
	end)

	function option:Close()
		library.popup = nil
		option.arrow.Rotation = 90
		self.open = false
		option.holder.Visible = false
		option.listvalue.BorderColor3 = Color3.new()
	end

	return option
end

library.createBox = function(option, parent)
	option.hasInit = true

	option.main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, option.text == "nil" and 28 or 44),
		BackgroundTransparency = 1,
		Parent = parent
	})

	if option.text ~= "nil" then
		option.title = library:Create("TextLabel", {
			Position = UDim2.new(0, 6, 0, 0),
			Size = UDim2.new(1, -12, 0, 18),
			BackgroundTransparency = 1,
			Text = option.text,
			TextSize = 15,
			Font = Enum.Font.Code,
			TextColor3 = Color3.fromRGB(210, 210, 210),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = option.main
		})
	end

	option.holder = library:Create("Frame", {
		Position = UDim2.new(0, 6, 0, option.text == "nil" and 4 or 20),
		Size = UDim2.new(1, -12, 0, 20),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BorderColor3 = Color3.new(),
		Parent = option.main
	})

	library:Create("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2454009026",
		ImageColor3 = Color3.new(),
		ImageTransparency = 0.8,
		Parent = option.holder
	})

	library:Create("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2592362371",
		ImageColor3 = Color3.fromRGB(60, 60, 60),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(2, 2, 62, 62),
		Parent = option.holder
	})

	local inputvalue = library:Create("TextBox", {
		Position = UDim2.new(0, 4, 0, 0),
		Size = UDim2.new(1, -4, 1, 0),
		BackgroundTransparency = 1,
		Text = "  " .. option.value,
		TextSize = 15,
		Font = Enum.Font.Code,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		ClearTextOnFocus = false,
		Parent = option.holder
	})

	inputvalue.FocusLost:connect(function(enter)
		option.holder.BorderColor3 = Color3.new()
		option:SetValue(inputvalue.Text, enter)
	end)

	inputvalue.Focused:connect(function()
		option.holder.BorderColor3 = library.flags["Menu Accent Color"]
	end)

	inputvalue.InputBegan:connect(function(input)
		if input.UserInputType.Name == "MouseButton1" then
			inputvalue.Text = ""
		end
		if input.UserInputType.Name == "MouseMovement" then
			if not library.warning and not library.slider then
				option.holder.BorderColor3 = library.flags["Menu Accent Color"]
			end
			if option.tip then
				library.tooltip.Text = option.tip
				library.tooltip.Size = UDim2.new(0, textService:GetTextSize(option.tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
			end
		end
	end)

	inputvalue.InputChanged:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			if option.tip then
				library.tooltip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
			end
		end
	end)

	inputvalue.InputEnded:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			if not inputvalue:IsFocused() then
				option.holder.BorderColor3 = Color3.new()
			end
			library.tooltip.Position = UDim2.new(2)
		end
	end)

	function option:SetValue(value, enter)
		if tostring(value) == "" then
			inputvalue.Text = self.value
		else
			library.flags[self.flag] = tostring(value)
			self.value = tostring(value)
			inputvalue.Text = self.value
			self.callback(value, enter)
		end
	end
	delay(1, function()
		if library then
			option:SetValue(option.value)
		end
	end)
end

library.createColorPickerWindow = function(option)
	option.mainHolder = library:Create("TextButton", {
		ZIndex = 4,
		--Position = UDim2.new(1, -184, 1, 6),
		Size = UDim2.new(0, option.trans and 200 or 184, 0, 264),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderColor3 = Color3.new(),
		AutoButtonColor = false,
		Visible = false,
		Parent = library.base
	})

	option.rgbBox = library:Create("Frame", {
		Position = UDim2.new(0, 6, 0, 214),
		Size = UDim2.new(0, (option.mainHolder.AbsoluteSize.X - 12), 0, 20),
		BackgroundColor3 = Color3.fromRGB(57, 57, 57),
		BorderColor3 = Color3.new(),
		ZIndex = 5;
		Parent = option.mainHolder
	})

	library:Create("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2454009026",
		ImageColor3 = Color3.new(),
		ImageTransparency = 0.8,
		ZIndex = 6;
		Parent = option.rgbBox
	})

	library:Create("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2592362371",
		ImageColor3 = Color3.fromRGB(60, 60, 60),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(2, 2, 62, 62),
		ZIndex = 6;
		Parent = option.rgbBox
	})

	option.rgbInput = library:Create("TextBox", {
		Position = UDim2.new(0, 4, 0, 0),
		Size = UDim2.new(1, -4, 1, 0),
		BackgroundTransparency = 1,
		Text = tostring(option.color),
		TextSize = 14,
		Font = Enum.Font.Code,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextWrapped = true,
		ClearTextOnFocus = false,
		ZIndex = 6;
		Parent = option.rgbBox
	})

	option.hexBox = option.rgbBox:Clone()
	option.hexBox.Position = UDim2.new(0, 6, 0, 238)
	-- option.hexBox.Size = UDim2.new(0, (option.mainHolder.AbsoluteSize.X/2 - 10), 0, 20)
	option.hexBox.Parent = option.mainHolder
	option.hexInput = option.hexBox.TextBox;

	library:Create("ImageLabel", {
		ZIndex = 4,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2592362371",
		ImageColor3 = Color3.fromRGB(60, 60, 60),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(2, 2, 62, 62),
		Parent = option.mainHolder
	})

	local hue, sat, val = Color3.toHSV(option.color)
	hue, sat, val = hue == 0 and 1 or hue, sat + 0.005, val - 0.005
	local editinghue
	local editingsatval
	local editingtrans

	local transMain
	if option.trans then
		transMain = library:Create("ImageLabel", {
			ZIndex = 5,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://2454009026",
			ImageColor3 = Color3.fromHSV(hue, 1, 1),
			Rotation = 180,
			Parent = library:Create("ImageLabel", {
				ZIndex = 4,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -6, 0, 6),
				Size = UDim2.new(0, 10, 1, -60),
				BorderColor3 = Color3.new(),
				Image = "rbxassetid://4632082392",
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.new(0, 5, 0, 5),
				Parent = option.mainHolder
			})
		})

		option.transSlider = library:Create("Frame", {
			ZIndex = 5,
			Position = UDim2.new(0, 0, option.trans, 0),
			Size = UDim2.new(1, 0, 0, 2),
			BackgroundColor3 = Color3.fromRGB(38, 41, 65),
			BorderColor3 = Color3.fromRGB(255, 255, 255),
			Parent = transMain
		})

		transMain.InputBegan:connect(function(Input)
			if Input.UserInputType.Name == "MouseButton1" then
				editingtrans = true
				option:SetTrans(1 - ((Input.Position.Y - transMain.AbsolutePosition.Y) / transMain.AbsoluteSize.Y))
			end
		end)

		transMain.InputEnded:connect(function(Input)
			if Input.UserInputType.Name == "MouseButton1" then
				editingtrans = false
			end
		end)
	end

	local hueMain = library:Create("Frame", {
		ZIndex = 4,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 6, 1, -54),
		Size = UDim2.new(1, option.trans and -28 or -12, 0, 10),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderColor3 = Color3.new(),
		Parent = option.mainHolder
	})

	local Gradient = library:Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
		}),
		Parent = hueMain
	})

	local hueSlider = library:Create("Frame", {
		ZIndex = 4,
		Position = UDim2.new(1 - hue, 0, 0, 0),
		Size = UDim2.new(0, 2, 1, 0),
		BackgroundColor3 = Color3.fromRGB(38, 41, 65),
		BorderColor3 = Color3.fromRGB(255, 255, 255),
		Parent = hueMain
	})

	hueMain.InputBegan:connect(function(Input)
		if Input.UserInputType.Name == "MouseButton1" then
			editinghue = true
			X = (hueMain.AbsolutePosition.X + hueMain.AbsoluteSize.X) - hueMain.AbsolutePosition.X
			X = math.clamp((Input.Position.X - hueMain.AbsolutePosition.X) / X, 0, 0.995)
			option:SetColor(Color3.fromHSV(1 - X, sat, val))
		end
	end)

	hueMain.InputEnded:connect(function(Input)
		if Input.UserInputType.Name == "MouseButton1" then
			editinghue = false
		end
	end)

	local satval = library:Create("ImageLabel", {
		ZIndex = 4,
		Position = UDim2.new(0, 6, 0, 6),
		Size = UDim2.new(1, option.trans and -28 or -12, 1, -74),
		BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
		BorderColor3 = Color3.new(),
		Image = "rbxassetid://4155801252",
		ClipsDescendants = true,
		Parent = option.mainHolder
	})

	local satvalSlider = library:Create("Frame", {
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(sat, 0, 1 - val, 0),
		Size = UDim2.new(0, 4, 0, 4),
		Rotation = 45,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Parent = satval
	})

	satval.InputBegan:connect(function(Input)
		if Input.UserInputType.Name == "MouseButton1" then
			editingsatval = true
			X = (satval.AbsolutePosition.X + satval.AbsoluteSize.X) - satval.AbsolutePosition.X
			Y = (satval.AbsolutePosition.Y + satval.AbsoluteSize.Y) - satval.AbsolutePosition.Y
			X = math.clamp((Input.Position.X - satval.AbsolutePosition.X) / X, 0.005, 1)
			Y = math.clamp((Input.Position.Y - satval.AbsolutePosition.Y) / Y, 0, 0.995)
			option:SetColor(Color3.fromHSV(hue, X, 1 - Y))
		end
	end)

	library:AddConnection(inputService.InputChanged, function(Input)
		if Input.UserInputType.Name == "MouseMovement" then
			if editingsatval then
				X = (satval.AbsolutePosition.X + satval.AbsoluteSize.X) - satval.AbsolutePosition.X
				Y = (satval.AbsolutePosition.Y + satval.AbsoluteSize.Y) - satval.AbsolutePosition.Y
				X = math.clamp((Input.Position.X - satval.AbsolutePosition.X) / X, 0.005, 1)
				Y = math.clamp((Input.Position.Y - satval.AbsolutePosition.Y) / Y, 0, 0.995)
				option:SetColor(Color3.fromHSV(hue, X, 1 - Y))
			elseif editinghue then
				X = (hueMain.AbsolutePosition.X + hueMain.AbsoluteSize.X) - hueMain.AbsolutePosition.X
				X = math.clamp((Input.Position.X - hueMain.AbsolutePosition.X) / X, 0, 0.995)
				option:SetColor(Color3.fromHSV(1 - X, sat, val))
			elseif editingtrans then
				option:SetTrans(1 - ((Input.Position.Y - transMain.AbsolutePosition.Y) / transMain.AbsoluteSize.Y))
			end
		end
	end)

	satval.InputEnded:connect(function(Input)
		if Input.UserInputType.Name == "MouseButton1" then
			editingsatval = false
		end
	end)

	local r, g, b = library.round(option.color)
	option.hexInput.Text = string.format("#%02x%02x%02x", r, g, b)
	option.rgbInput.Text = table.concat({r, g, b}, ",")

	option.rgbInput.FocusLost:connect(function()
		local r, g, b = option.rgbInput.Text:gsub("%s+", ""):match("(%d+),(%d+),(%d+)")
		if r and g and b then
			local color = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
			return option:SetColor(color)
		end

		local r, g, b = library.round(option.color)
		option.rgbInput.Text = table.concat({r, g, b}, ",")
	end)

	option.hexInput.FocusLost:connect(function()
		local r, g, b = option.hexInput.Text:match("#?(..)(..)(..)")
		if r and g and b then
			local color = Color3.fromRGB(tonumber("0x"..r), tonumber("0x"..g), tonumber("0x"..b))
			return option:SetColor(color)
		end

		local r, g, b = library.round(option.color)
		option.hexInput.Text = string.format("#%02x%02x%02x", r, g, b)
	end)

	function option:updateVisuals(Color)
		hue, sat, val = Color3.toHSV(Color)
		hue = hue == 0 and 1 or hue
		satval.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
		if option.trans then
			transMain.ImageColor3 = Color3.fromHSV(hue, 1, 1)
		end
		hueSlider.Position = UDim2.new(1 - hue, 0, 0, 0)
		satvalSlider.Position = UDim2.new(sat, 0, 1 - val, 0)

		local r, g, b = library.round(Color3.fromHSV(hue, sat, val))

		option.hexInput.Text = string.format("#%02x%02x%02x", r, g, b)
		option.rgbInput.Text = table.concat({r, g, b}, ",")
	end

	return option
end

library.createColor = function(option, parent)
	option.hasInit = true

	if option.sub then
		option.main = option:getMain()
	else
		option.main = library:Create("Frame", {
			LayoutOrder = option.position,
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Parent = parent
		})

		option.title = library:Create("TextLabel", {
			Position = UDim2.new(0, 6, 0, 0),
			Size = UDim2.new(1, -12, 1, 0),
			BackgroundTransparency = 1,
			Text = option.text,
			TextSize = 15,
			Font = Enum.Font.Code,
			TextColor3 = Color3.fromRGB(210, 210, 210),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = option.main
		})
	end

	option.visualize = library:Create(option.sub and "TextButton" or "Frame", {
		Position = UDim2.new(1, -(option.subpos or 0) - 24, 0, 4),
		Size = UDim2.new(0, 18, 0, 12),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundColor3 = option.color,
		BorderColor3 = Color3.new(),
		Parent = option.main
	})

	library:Create("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2454009026",
		ImageColor3 = Color3.new(),
		ImageTransparency = 0.6,
		Parent = option.visualize
	})

	library:Create("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2592362371",
		ImageColor3 = Color3.fromRGB(60, 60, 60),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(2, 2, 62, 62),
		Parent = option.visualize
	})

	local interest = option.sub and option.visualize or option.main

	if option.sub then
		option.visualize.Text = ""
		option.visualize.AutoButtonColor = false
	end

	interest.InputBegan:connect(function(input)
		if input.UserInputType.Name == "MouseButton1" then
			if not option.mainHolder then library.createColorPickerWindow(option) end
			if library.popup == option then library.popup:Close() return end
			if library.popup then library.popup:Close() end
			option.open = true
			local pos = option.main.AbsolutePosition
			option.mainHolder.Position = UDim2.new(0, pos.X + 36 + (option.trans and -16 or 0), 0, pos.Y + 56)
			option.mainHolder.Visible = true
			library.popup = option
			option.visualize.BorderColor3 = library.flags["Menu Accent Color"]
		end
		if input.UserInputType.Name == "MouseMovement" then
			if not library.warning and not library.slider then
				option.visualize.BorderColor3 = library.flags["Menu Accent Color"]
			end
			if option.tip then
				library.tooltip.Text = option.tip
				library.tooltip.Size = UDim2.new(0, textService:GetTextSize(option.tip, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X, 0, 20)
			end
		end
	end)

	interest.InputChanged:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			if option.tip then
				library.tooltip.Position = UDim2.new(0, input.Position.X + 26, 0, input.Position.Y + 36)
			end
		end
	end)

	interest.InputEnded:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			if not option.open then
				option.visualize.BorderColor3 = Color3.new()
			end
			library.tooltip.Position = UDim2.new(2)
		end
	end)

	function option:SetColor(newColor, nocallback)
		if typeof(newColor) == "table" then
			newColor = Color3.new(newColor[1], newColor[2], newColor[3])
		end
		newColor = newColor or Color3.new(1, 1, 1)
		if self.mainHolder then
			self:updateVisuals(newColor)
		end
		option.visualize.BackgroundColor3 = newColor
		library.flags[self.flag] = newColor
		self.color = newColor
		if not nocallback then
			self.callback(newColor)
		end
	end

	if option.trans then
		function option:SetTrans(value, manual)
			value = math.clamp(tonumber(value) or 0, 0, 1)
			if self.transSlider then
				self.transSlider.Position = UDim2.new(0, 0, value, 0)
			end
			self.trans = value
			library.flags[self.flag .. " Transparency"] = 1 - value
			self.calltrans(value)
		end
		option:SetTrans(option.trans)
	end

	delay(1, function()
		if library then
			option:SetColor(option.color)
		end
	end)

	function option:Close()
		library.popup = nil
		self.open = false
		self.mainHolder.Visible = false
		option.visualize.BorderColor3 = Color3.new()
	end
end

function library:AddTab(title, pos)
	local tab = {canInit = true, tabs = {}, columns = {}, title = tostring(title)}
	table.insert(self.tabs, pos or #self.tabs + 1, tab)

	function tab:AddColumn()
		local column = {sections = {}, position = #self.columns, canInit = true, tab = self}
		table.insert(self.columns, column)

		function column:AddSection(title)
			local section = {title = tostring(title), options = {}, canInit = true, column = self}
			table.insert(self.sections, section)

			function section:AddLabel(text)
				local option = {text = text}
				option.section = self
				option.type = "label"
				option.position = #self.options
				option.canInit = true
				table.insert(self.options, option)

				if library.hasInit and self.hasInit then
					library.createLabel(option, self.content)
				else
					option.Init = library.createLabel
				end

				return option
			end

			function section:AddDivider(text)
				local option = {text = text}
				option.section = self
				option.type = "divider"
				option.position = #self.options
				option.canInit = true
				table.insert(self.options, option)

				if library.hasInit and self.hasInit then
					library.createDivider(option, self.content)
				else
					option.Init = library.createDivider
				end

				return option
			end

			function section:AddToggle(option)
				option = typeof(option) == "table" and option or {}
				option.section = self
				option.text = tostring(option.text)
				option.state = option.state == nil and nil or (typeof(option.state) == "boolean" and option.state or false)
				option.callback = typeof(option.callback) == "function" and option.callback or function() end
				option.type = "toggle"
				option.position = #self.options
				option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
				option.subcount = 0
				option.canInit = (option.canInit ~= nil and option.canInit) or true
				option.tip = option.tip and tostring(option.tip)
				option.style = option.style == 2
				library.flags[option.flag] = option.state
				table.insert(self.options, option)
				library.options[option.flag] = option

				function option:AddColor(subOption)
					subOption = typeof(subOption) == "table" and subOption or {}
					subOption.sub = true
					subOption.subpos = self.subcount * 24
					function subOption:getMain() return option.main end
					self.subcount = self.subcount + 1
					return section:AddColor(subOption)
				end

				function option:AddBind(subOption)
					subOption = typeof(subOption) == "table" and subOption or {}
					subOption.sub = true
					subOption.subpos = self.subcount * 24
					function subOption:getMain() return option.main end
					self.subcount = self.subcount + 1
					return section:AddBind(subOption)
				end

				function option:AddList(subOption)
					subOption = typeof(subOption) == "table" and subOption or {}
					subOption.sub = true
					function subOption:getMain() return option.main end
					self.subcount = self.subcount + 1
					return section:AddList(subOption)
				end

				function option:AddSlider(subOption)
					subOption = typeof(subOption) == "table" and subOption or {}
					subOption.sub = true
					function subOption:getMain() return option.main end
					self.subcount = self.subcount + 1
					return section:AddSlider(subOption)
				end

				if library.hasInit and self.hasInit then
					library.createToggle(option, self.content)
				else
					option.Init = library.createToggle
				end

				return option
			end

			function section:AddButton(option)
				option = typeof(option) == "table" and option or {}
				option.section = self
				option.text = tostring(option.text)
				option.callback = typeof(option.callback) == "function" and option.callback or function() end
				option.type = "button"
				option.position = #self.options
				option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
				option.subcount = 0
				option.canInit = (option.canInit ~= nil and option.canInit) or true
				option.tip = option.tip and tostring(option.tip)
				table.insert(self.options, option)
				library.options[option.flag] = option

				function option:AddBind(subOption)
					subOption = typeof(subOption) == "table" and subOption or {}
					subOption.sub = true
					subOption.subpos = self.subcount * 24
					function subOption:getMain() option.main.Size = UDim2.new(1, 0, 0, 40) return option.main end
					self.subcount = self.subcount + 1
					return section:AddBind(subOption)
				end

				function option:AddColor(subOption)
					subOption = typeof(subOption) == "table" and subOption or {}
					subOption.sub = true
					subOption.subpos = self.subcount * 24
					function subOption:getMain() option.main.Size = UDim2.new(1, 0, 0, 40) return option.main end
					self.subcount = self.subcount + 1
					return section:AddColor(subOption)
				end

				if library.hasInit and self.hasInit then
					library.createButton(option, self.content)
				else
					option.Init = library.createButton
				end

				return option
			end

			function section:AddBind(option)
				option = typeof(option) == "table" and option or {}
				option.section = self
				option.text = tostring(option.text)
				option.key = (option.key and option.key.Name) or option.key or "none"
				option.nomouse = typeof(option.nomouse) == "boolean" and option.nomouse or false
				option.mode = typeof(option.mode) == "string" and (option.mode == "toggle" or option.mode == "hold" and option.mode) or "toggle"
				option.callback = typeof(option.callback) == "function" and option.callback or function() end
				option.type = "bind"
				option.position = #self.options
				option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
				option.canInit = (option.canInit ~= nil and option.canInit) or true
				option.tip = option.tip and tostring(option.tip)
				table.insert(self.options, option)
				library.options[option.flag] = option

				if library.hasInit and self.hasInit then
					library.createBind(option, self.content)
				else
					option.Init = library.createBind
				end

				return option
			end

			function section:AddSlider(option)
				option = typeof(option) == "table" and option or {}
				option.section = self
				option.text = tostring(option.text)
				option.min = typeof(option.min) == "number" and option.min or 0
				option.max = typeof(option.max) == "number" and option.max or 0
				option.value = option.min < 0 and 0 or math.clamp(typeof(option.value) == "number" and option.value or option.min, option.min, option.max)
				option.callback = typeof(option.callback) == "function" and option.callback or function() end
				option.float = typeof(option.value) == "number" and option.float or 1
				option.suffix = option.suffix and tostring(option.suffix) or ""
				option.textpos = option.textpos == 2
				option.type = "slider"
				option.position = #self.options
				option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
				option.subcount = 0
				option.canInit = (option.canInit ~= nil and option.canInit) or true
				option.tip = option.tip and tostring(option.tip)
				library.flags[option.flag] = option.value
				table.insert(self.options, option)
				library.options[option.flag] = option

				function option:AddColor(subOption)
					subOption = typeof(subOption) == "table" and subOption or {}
					subOption.sub = true
					subOption.subpos = self.subcount * 24
					function subOption:getMain() return option.main end
					self.subcount = self.subcount + 1
					return section:AddColor(subOption)
				end

				function option:AddBind(subOption)
					subOption = typeof(subOption) == "table" and subOption or {}
					subOption.sub = true
					subOption.subpos = self.subcount * 24
					function subOption:getMain() return option.main end
					self.subcount = self.subcount + 1
					return section:AddBind(subOption)
				end

				if library.hasInit and self.hasInit then
					library.createSlider(option, self.content)
				else
					option.Init = library.createSlider
				end

				return option
			end

			function section:AddList(option)
				option = typeof(option) == "table" and option or {}
				option.section = self
				option.text = tostring(option.text)
				option.values = typeof(option.values) == "table" and option.values or {}
				option.callback = typeof(option.callback) == "function" and option.callback or function() end
				option.multiselect = typeof(option.multiselect) == "boolean" and option.multiselect or false
				--option.groupbox = (not option.multiselect) and (typeof(option.groupbox) == "boolean" and option.groupbox or false)
				option.value = option.multiselect and (typeof(option.value) == "table" and option.value or {}) or tostring(option.value or option.values[1] or "")
				if option.multiselect then
					for i,v in next, option.values do
						option.value[v] = false
					end
				end
				option.max = option.max or 4
				option.open = false
				option.type = "list"
				option.position = #self.options
				option.labels = {}
				option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
				option.subcount = 0
				option.canInit = (option.canInit ~= nil and option.canInit) or true
				option.tip = option.tip and tostring(option.tip)
				library.flags[option.flag] = option.value
				table.insert(self.options, option)
				library.options[option.flag] = option

				function option:AddValue(value, state)
					if self.multiselect then
						self.values[value] = state
					else
						table.insert(self.values, value)
					end
				end

				function option:AddColor(subOption)
					subOption = typeof(subOption) == "table" and subOption or {}
					subOption.sub = true
					subOption.subpos = self.subcount * 24
					function subOption:getMain() return option.main end
					self.subcount = self.subcount + 1
					return section:AddColor(subOption)
				end

				function option:AddBind(subOption)
					subOption = typeof(subOption) == "table" and subOption or {}
					subOption.sub = true
					subOption.subpos = self.subcount * 24
					function subOption:getMain() return option.main end
					self.subcount = self.subcount + 1
					return section:AddBind(subOption)
				end

				if library.hasInit and self.hasInit then
					library.createList(option, self.content)
				else
					option.Init = library.createList
				end

				return option
			end

			function section:AddBox(option)
				option = typeof(option) == "table" and option or {}
				option.section = self
				option.text = tostring(option.text)
				option.value = tostring(option.value or "")
				option.callback = typeof(option.callback) == "function" and option.callback or function() end
				option.type = "box"
				option.position = #self.options
				option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
				option.canInit = (option.canInit ~= nil and option.canInit) or true
				option.tip = option.tip and tostring(option.tip)
				library.flags[option.flag] = option.value
				table.insert(self.options, option)
				library.options[option.flag] = option

				if library.hasInit and self.hasInit then
					library.createBox(option, self.content)
				else
					option.Init = library.createBox
				end

				return option
			end

			function section:AddColor(option)
				option = typeof(option) == "table" and option or {}
				option.section = self
				option.text = tostring(option.text)
				option.color = typeof(option.color) == "table" and Color3.new(option.color[1], option.color[2], option.color[3]) or option.color or Color3.new(1, 1, 1)
				option.callback = typeof(option.callback) == "function" and option.callback or function() end
				option.calltrans = typeof(option.calltrans) == "function" and option.calltrans or (option.calltrans == 1 and option.callback) or function() end
				option.open = false
				option.trans = tonumber(option.trans)
				option.subcount = 1
				option.type = "color"
				option.position = #self.options
				option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
				option.canInit = (option.canInit ~= nil and option.canInit) or true
				option.tip = option.tip and tostring(option.tip)
				library.flags[option.flag] = option.color
				table.insert(self.options, option)
				library.options[option.flag] = option

				function option:AddColor(subOption)
					subOption = typeof(subOption) == "table" and subOption or {}
					subOption.sub = true
					subOption.subpos = self.subcount * 24
					function subOption:getMain() return option.main end
					self.subcount = self.subcount + 1
					return section:AddColor(subOption)
				end

				if option.trans then
					library.flags[option.flag .. " Transparency"] = option.trans
				end

				if library.hasInit and self.hasInit then
					library.createColor(option, self.content)
				else
					option.Init = library.createColor
				end

				return option
			end

			function section:SetTitle(newTitle)
				self.title = tostring(newTitle)
				if self.titleText then
					self.titleText.Text = tostring(newTitle)
				end
			end

			function section:Init()
				if self.hasInit then return end
				self.hasInit = true

				self.main = library:Create("Frame", {
					BackgroundColor3 = Color3.fromRGB(30, 30, 30),
					BorderColor3 = Color3.new(),
					Parent = column.main
				})

				self.content = library:Create("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Color3.fromRGB(30, 30, 30),
					BorderColor3 = Color3.fromRGB(60, 60, 60),
					BorderMode = Enum.BorderMode.Inset,
					Parent = self.main
				})

				table.insert(library.theme, library:Create("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = library.flags["Menu Accent Color"],
					BorderSizePixel = 0,
					BorderMode = Enum.BorderMode.Inset,
					Parent = self.main
				}))

				local layout = library:Create("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 2),
					Parent = self.content
				})

				library:Create("UIPadding", {
					PaddingTop = UDim.new(0, 12),
					Parent = self.content
				})

				self.titleText = library:Create("TextLabel", {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 12, 0, 0),
					Size = UDim2.new(0, textService:GetTextSize(self.title, 15, Enum.Font.Code, Vector2.new(9e9, 9e9)).X + 10, 0, 3),
					BackgroundColor3 = Color3.fromRGB(30, 30, 30),
					BorderSizePixel = 0,
					Text = self.title,
					TextSize = 15,
					Font = Enum.Font.Code,
					TextColor3 = Color3.new(1, 1, 1),
					Parent = self.main
				})

				layout.Changed:connect(function()
					self.main.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 16)
				end)

				for _, option in next, self.options do
					if option.canInit then
						option.Init(option, self.content)
					end
				end
			end

			if library.hasInit and self.hasInit then
				section:Init()
			end

			return section
		end

		function column:Init()
			if self.hasInit then return end
			self.hasInit = true

			self.main = library:Create("ScrollingFrame", {
				ZIndex = 2,
				Position = UDim2.new(0, 6 + (self.position * 239), 0, 2),
				Size = UDim2.new(0, 233, 1, -4),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarImageColor3 = Color3.fromRGB(),
				ScrollBarThickness = 4,	
				VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Visible = false,
				Parent = library.columnHolder
			})

			local layout = library:Create("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12),
				Parent = self.main
			})

			library:Create("UIPadding", {
				PaddingTop = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 2),
				PaddingRight = UDim.new(0, 2),
				Parent = self.main
			})

			layout.Changed:connect(function()
				self.main.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 14)
			end)

			for _, section in next, self.sections do
				if section.canInit and #section.options > 0 then
					section:Init()
				end
			end
		end

		if library.hasInit and self.hasInit then
			column:Init()
		end

		return column
	end

	function tab:Init()
		if self.hasInit then return end
		self.hasInit = true
		local size = textService:GetTextSize(self.title, 18, Enum.Font.Code, Vector2.new(9e9, 9e9)).X + 10

		self.button = library:Create("TextLabel", {
			Position = UDim2.new(0, library.tabSize, 0, 22),
			Size = UDim2.new(0, size, 0, 30),
			BackgroundTransparency = 1,
			Text = self.title,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 15,
			Font = Enum.Font.Code,
			TextWrapped = true,
			ClipsDescendants = true,
			Parent = library.main
		})
		library.tabSize = library.tabSize + size

		self.button.InputBegan:connect(function(input)
			if input.UserInputType.Name == "MouseButton1" then
				library:selectTab(self)
			end
		end)

		for _, column in next, self.columns do
			if column.canInit then
				column:Init()
			end
		end
	end

	if self.hasInit then
		tab:Init()
	end

	return tab
end

function library:AddWarning(warning)
	warning = typeof(warning) == "table" and warning or {}
	warning.text = tostring(warning.text) 
	warning.type = warning.type == "confirm" and "confirm" or ""

	local answer
	function warning:Show()
		library.warning = warning
		if warning.main and warning.type == "" then return end
		if library.popup then library.popup:Close() end
		if not warning.main then
			warning.main = library:Create("TextButton", {
				ZIndex = 2,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 0.6,
				BackgroundColor3 = Color3.new(),
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				Parent = library.main
			})

			warning.message = library:Create("TextLabel", {
				ZIndex = 2,
				Position = UDim2.new(0, 20, 0.5, -60),
				Size = UDim2.new(1, -40, 0, 40),
				BackgroundTransparency = 1,
				TextSize = 16,
				Font = Enum.Font.Code,
				TextColor3 = Color3.new(1, 1, 1),
				TextWrapped = true,
				RichText = true,
				Parent = warning.main
			})

			if warning.type == "confirm" then
				local button = library:Create("TextLabel", {
					ZIndex = 2,
					Position = UDim2.new(0.5, -105, 0.5, -10),
					Size = UDim2.new(0, 100, 0, 20),
					BackgroundColor3 = Color3.fromRGB(40, 40, 40),
					BorderColor3 = Color3.new(),
					Text = "Yes",
					TextSize = 16,
					Font = Enum.Font.Code,
					TextColor3 = Color3.new(1, 1, 1),
					Parent = warning.main
				})

				library:Create("ImageLabel", {
					ZIndex = 2,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Image = "rbxassetid://2454009026",
					ImageColor3 = Color3.new(),
					ImageTransparency = 0.8,
					Parent = button
				})

				library:Create("ImageLabel", {
					ZIndex = 2,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Image = "rbxassetid://2592362371",
					ImageColor3 = Color3.fromRGB(60, 60, 60),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(2, 2, 62, 62),
					Parent = button
				})

				local button1 = library:Create("TextLabel", {
					ZIndex = 2,
					Position = UDim2.new(0.5, 5, 0.5, -10),
					Size = UDim2.new(0, 100, 0, 20),
					BackgroundColor3 = Color3.fromRGB(40, 40, 40),
					BorderColor3 = Color3.new(),
					Text = "No",
					TextSize = 16,
					Font = Enum.Font.Code,
					TextColor3 = Color3.new(1, 1, 1),
					Parent = warning.main
				})

				library:Create("ImageLabel", {
					ZIndex = 2,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Image = "rbxassetid://2454009026",
					ImageColor3 = Color3.new(),
					ImageTransparency = 0.8,
					Parent = button1
				})

				library:Create("ImageLabel", {
					ZIndex = 2,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Image = "rbxassetid://2592362371",
					ImageColor3 = Color3.fromRGB(60, 60, 60),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(2, 2, 62, 62),
					Parent = button1
				})

				button.InputBegan:connect(function(input)
					if input.UserInputType.Name == "MouseButton1" then
						answer = true
					end
				end)

				button1.InputBegan:connect(function(input)
					if input.UserInputType.Name == "MouseButton1" then
						answer = false
					end
				end)
			else
				local button = library:Create("TextLabel", {
					ZIndex = 2,
					Position = UDim2.new(0.5, -50, 0.5, -10),
					Size = UDim2.new(0, 100, 0, 20),
					BackgroundColor3 = Color3.fromRGB(30, 30, 30),
					BorderColor3 = Color3.new(),
					Text = "OK",
					TextSize = 16,
					Font = Enum.Font.Code,
					TextColor3 = Color3.new(1, 1, 1),
					Parent = warning.main
				})

				library:Create("ImageLabel", {
					ZIndex = 2,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Image = "rbxassetid://2454009026",
					ImageColor3 = Color3.new(),
					ImageTransparency = 0.8,
					Parent = button
				})

				library:Create("ImageLabel", {
					ZIndex = 2,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BackgroundTransparency = 1,
					Image = "rbxassetid://3570695787",
					ImageColor3 = Color3.fromRGB(50, 50, 50),
					Parent = button
				})

				button.InputBegan:connect(function(input)
					if input.UserInputType.Name == "MouseButton1" then
						answer = true
					end
				end)
			end
		end
		warning.main.Visible = true
		warning.message.Text = warning.text

		repeat wait()
		until answer ~= nil
		spawn(warning.Close)
		library.warning = nil
		return answer
	end

	function warning:Close()
		answer = nil
		if not warning.main then return end
		warning.main.Visible = false
	end

	return warning
end

function library:Close()
	self.open = not self.open
	if self.open then
		inputService.MouseIconEnabled = false
	else
		inputService.MouseIconEnabled = self.mousestate
	end
	if self.main then
		if self.popup then
			self.popup:Close()
		end
		self.main.Visible = self.open
		self.cursor.Visible  = self.open
		self.cursor1.Visible  = self.open
	end
end

function library:Init()
	if self.hasInit then return end
	self.hasInit = true

	self.base = library:Create("ScreenGui", {IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Global})
	if runService:IsStudio() then
		self.base.Parent = script.Parent.Parent
	elseif syn then
		pcall(function() syn.protect_gui(self.base) end)
		self.base.Parent = game:GetService"CoreGui"
	end

	self.main = self:Create("ImageButton", {
		AutoButtonColor = false,
		Position = UDim2.new(0, 100, 0, 46),
		Size = UDim2.new(0, 500, 0, 600),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderColor3 = Color3.new(),
		ScaleType = Enum.ScaleType.Tile,
		Modal = true,
		Visible = false,
		Parent = self.base
	})

	self.top = self:Create("Frame", {
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.new(),
		Parent = self.main
	})

	self.gradientelelele = self:Create("UIGradient", {
		Rotation = 90,
		Parent = self.top,
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(29, 29, 29)), 
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(12, 12, 12))
		}
	})

	self.ihateniggers = self:Create("TextLabel", {
		Position = UDim2.new(0, 6, 0, -1),
		Size = UDim2.new(0, 0, 0, 20),
		BackgroundTransparency = 1,
		Text = title,
		Font = Enum.Font.Code,
		TextSize = 18,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self.main
	})

	table.insert(library.theme, self:Create("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 0, 24),
		BackgroundColor3 = library.flags["Menu Accent Color"],
		BorderSizePixel = 0,
		Parent = self.main
	}))

	library:Create("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2454009026",
		ImageColor3 = Color3.new(),
		ImageTransparency = 0.4,
		Parent = top
	})

	self.tabHighlight = self:Create("Frame", {
		BackgroundColor3 = library.flags["Menu Accent Color"],
		BorderSizePixel = 0,
		Parent = self.main
	})
	table.insert(library.theme, self.tabHighlight)

	self.columnHolder = self:Create("Frame", {
		Position = UDim2.new(0, 5, 0, 55),
		Size = UDim2.new(1, -10, 1, -60),
		BackgroundTransparency = 1,
		Parent = self.main
	})

	self.cursor = self:Create("Triangle", {
		Color = Color3.fromRGB(180, 180, 180),
		Transparency = 0.6,
	})
	self.cursor1 = self:Create("Triangle", {
		Color = Color3.fromRGB(240, 240, 240),
		Transparency = 0.6,
	})

	self.tooltip = self:Create("TextLabel", {
		ZIndex = 2,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextSize = 15,
		Font = Enum.Font.Code,
		TextColor3 = Color3.new(1, 1, 1),
		Visible = true,
		Parent = self.base
	})

	self:Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(1, 10, 1, 0),
		Style = Enum.FrameStyle.RobloxRound,
		Parent = self.tooltip
	})

	self:Create("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://2592362371",
		ImageColor3 = Color3.fromRGB(60, 60, 60),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(2, 2, 62, 62),
		Parent = self.main
	})

	self.top.InputBegan:connect(function(input)
		self.ihateniggers.Text = title
		if input.UserInputType.Name == "MouseButton1" then
			dragObject = self.main
			dragging = true
			dragStart = input.Position
			startPos = dragObject.Position
			if library.popup then library.popup:Close() end
		end
	end)
	self.top.InputChanged:connect(function(input)
		self.ihateniggers.Text = title
		if dragging and input.UserInputType.Name == "MouseMovement" then
			dragInput = input
		end
	end)
	self.top.InputEnded:connect(function(input)
		self.ihateniggers.Text = title
		if input.UserInputType.Name == "MouseButton1" then
			dragging = false
		end
	end)

	function self:selectTab(tab)
		if self.currentTab == tab then return end
		if library.popup then library.popup:Close() end
		if self.currentTab then
			self.currentTab.button.TextColor3 = Color3.fromRGB(255, 255, 255)
			for _, column in next, self.currentTab.columns do
				column.main.Visible = false
			end
		end
		self.main.Size = UDim2.new(0, 16 + ((#tab.columns < 2 and 2 or #tab.columns) * 239), 0, 600)
		self.currentTab = tab
		tab.button.TextColor3 = library.flags["Menu Accent Color"]
		self.tabHighlight:TweenPosition(UDim2.new(0, tab.button.Position.X.Offset, 0, 50), "Out", "Quad", 0.2, true)
		self.tabHighlight:TweenSize(UDim2.new(0, tab.button.AbsoluteSize.X, 0, -1), "Out", "Quad", 0.1, true)
		for _, column in next, tab.columns do
			column.main.Visible = true
		end
	end

	spawn(function()
		while library do
			wait(1)
			local Configs = self:GetConfigs()
			for _, config in next, Configs do
				if not table.find(self.options["Config List"].values, config) then
					self.options["Config List"]:AddValue(config)
				end
			end
			for _, config in next, self.options["Config List"].values do
				if not table.find(Configs, config) then
					self.options["Config List"]:RemoveValue(config)
				end
			end
		end
	end)

	for _, tab in next, self.tabs do
		if tab.canInit then
			tab:Init()
			self:selectTab(tab)
		end
	end

	self:AddConnection(inputService.InputEnded, function(input)
		if input.UserInputType.Name == "MouseButton1" and self.slider then
			self.slider.slider.BorderColor3 = Color3.new()
			self.slider = nil
		end
	end)

	self:AddConnection(inputService.InputChanged, function(input)
		if not self.open then return end
		
		if input.UserInputType.Name == "MouseMovement" then
			if self.cursor then
				local mouse = inputService:GetMouseLocation()
				local MousePos = Vector2.new(mouse.X, mouse.Y)
				self.cursor.PointA = MousePos
				self.cursor.PointB = MousePos + Vector2.new(2, 8)
				self.cursor.PointC = MousePos + Vector2.new(2, 8)
				self.cursor1.PointA = MousePos
				self.cursor1.PointB = MousePos + Vector2.new(2, 8)
				self.cursor1.PointC = MousePos + Vector2.new(2, 8)
			end
			if self.slider then
				self.slider:SetValue(self.slider.min + ((input.Position.X - self.slider.slider.AbsolutePosition.X) / self.slider.slider.AbsoluteSize.X) * (self.slider.max - self.slider.min))
			end
		end
		if input == dragInput and dragging and library.draggable then
			local delta = input.Position - dragStart
			local yPos = (startPos.Y.Offset + delta.Y) < -36 and -36 or startPos.Y.Offset + delta.Y
			dragObject:TweenPosition(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, yPos), "Out", "Quint", 0.1, true)
		end
	end)

	local Old_index
	Old_index = hookmetamethod(game, "__index", function(t, i)
		if checkcaller() then return Old_index(t, i) end

		if library and i == "MouseIconEnabled" then
			return library.mousestate
		end

		return Old_index(t, i)
	end)

	local Old_new
	Old_new = hookmetamethod(game, "__newindex", function(t, i, v)
		if checkcaller() then return Old_new(t, i, v) end

		if library and i == "MouseIconEnabled" then
			library.mousestate = v
			if library.open then return end
		end

		return Old_new(t, i, v)
	end)

	if not getgenv().silent then
		delay(1, function() self:Close() end)
	end
end

--SECTION Locals

local INST                      = Instance.new
local V2                        = Vector2.new
local V3                        = Vector3.new
local C3                        = Color3.fromRGB
local ColorCorrection           = INST("ColorCorrectionEffect", workspace.CurrentCamera)
local Players                   = gs('Players')
local Http                      = gs('HttpService')
local RunService                = gs('RunService')
local UserInputService          = gs('UserInputService')
local TweenService              = gs('TweenService')
local Stats                     = gs('Stats')
local Actionservice             = gs('ContextActionService')
local ReplicatedStorage 		= gs('ReplicatedStorage')
local Lighting 					= gs("Lighting")
local LocalPlayer               = Players.LocalPlayer
local LocalMouse                = LocalPlayer:GetMouse()
local GameSettings              = UserSettings():GetService("UserGameSettings")
local Camera                    = workspace.CurrentCamera
local ScreenSize                = Camera.ViewportSize
local Ping 						= game.Stats.PerformanceStats.Ping:GetValue() 

local Theme = {
    Border = C3(0, 0, 0),
    Border2 = C3(60, 60, 60),
    Background = C3(45, 45, 45),
    Accent = C3(91, 194, 255),

    Gradient = game:HttpGet("https://i.imgur.com/5hmlrjX.png"),

    TextColor = C3(255, 255, 255),
    TextOutline = C3(0, 0, 0),
    Font = 2,
    Size = 13,
}	

function MouseOverDrawing(values, valuesAdd)
    local valuesAdd = valuesAdd or {}
    local values = {
        (values[1] or 0) + (valuesAdd[1] or 0),
        (values[2] or 0) + (valuesAdd[2] or 0),
        (values[3] or 0) + (valuesAdd[3] or 0),
        (values[4] or 0) + (valuesAdd[4] or 0)
    }

    local mouseLocation = UserInputService:GetMouseLocation()
    return (mouseLocation.x >= values[1] and mouseLocation.x <= (values[1] + (values[3] - values[1]))) and (mouseLocation.y >= values[2] and mouseLocation.y <= (values[2] + (values[4] - values[2])))
end

function createEventLog(text, time)
    local eventLog = {
        text = text,
        startTick = tick(),
        lifeTime = time,
        
        Border1 = newDrawing("Square", {
            Visible = true,
            Filled = true,
            Color = Theme.Border1
        }),
        Accent = newDrawing("Square", {
            Visible = true,
            Filled = true,
            Color = Theme.Accent
        }),
        Border2 = newDrawing("Square", {
            Visible = true,
            Filled = true,
            Color = Theme.Border2
        }),
        Background = newDrawing("Square", {
            Visible = true,
            Filled = true,
            Color = Theme.Background
        }),
        Gradient = newDrawing("Image", {
            Visible = true,
            Data = Theme.Gradient,
            Transparency = 1,
        }),
        mainText = newDrawing("Text", {
            Center = false,
            Outline = false,
            Color = Theme.TextColor,
            OutlineColor = Theme.TextOutline,
            Transparency = 1,
            Text = text,
            Size = Theme.Size,
            Font = Theme.Font,
            Visible = true
        })
    }

    function eventLog:Destroy()
        local mainTextOrigin = self.mainText.Position
        local mainTextTrans = self.mainText.Transparency

        local Border1Pos = self.Border1.Position
        local Border2Pos = self.Border2.Position
        local BackgroundPos = self.Background.Position
        local AccentPos = self.Accent.Position
        local GradientPos = self.Gradient.Position
        for i = 0, 1, 1/60 do
            self.mainText.Position = mainTextOrigin:Lerp(Vector2.new(), i)
            self.Border1.Position = Border1Pos:Lerp(Vector2.new(), i)
            self.Border2.Position = Border2Pos:Lerp(Vector2.new(), i)
            self.Background.Position = BackgroundPos:Lerp(Vector2.new(), i)
            self.Accent.Position = AccentPos:Lerp(Vector2.new(), i)
            self.Gradient.Position = GradientPos:Lerp(Vector2.new(), i)

            self.mainText.Transparency = mainTextTrans * (1 - i)
            self.Border1.Transparency = mainTextTrans * (1 - i)
            self.Border2.Transparency = mainTextTrans * (1 - i)
            self.Gradient.Transparency = mainTextTrans * (1 - i)
            self.Background.Transparency = mainTextTrans * (1 - i)
            self.Accent.Transparency = mainTextTrans * (1 - i)

            game:GetService("RunService").RenderStepped:Wait()
        end
        self.mainText:Remove()
        self.Background:Remove()
        self.Accent:Remove()
        self.Border1:Remove()
        self.Gradient:Remove()
        self.Border2:Remove()
        self.mainText = nil
        self.Border1 = nil
        self.Border2 = nil
        self.Gradient = nil
        self.Background = nil
        self.Accent = nil
        table.clear(self)
        self = nil
    end


    table.insert(eventLogs, eventLog)
    return eventLog
end

local function RenderChams(part, color, trans, reflectance, material)
	if part:IsA("MeshPart") then 
		part.TextureID = "" 
	end 
	if part:IsA("Part") and part:FindFirstChild("Mesh") and not part:IsA("BlockMesh") then 
		part.Mesh.VertexColor = V3(color.R, color.G, color.B)
		if material == "Plastic" or material == "Glass" then 
			part.Mesh.TextureId = "" 
		else 
			pcall(function() 
				part.Mesh.TextureId = part.Mesh.OriginalTexture.Value 
				part.Mesh.TextureID = part.Mesh.OriginalTexture.Value 
			end) 
		end 
	end 
	part.Color = color
	part.Material = material == "ForceField" and "ForceField" or material == "Neon" and "Neon" or material == "Plastic" and "SmoothPlastic" or "Glass"
	part.Reflectance = reflectance / 10 
	part.Transparency = 1 - trans
end

local function RenderChams2(part, color, trans, reflectance, material)
	part.Material = material == "ForceField" and "ForceField" or material == "Neon" and "Neon" or material == "Plastic" and "SmoothPlastic" or "Glass"
	part.Mesh.VertexColor = V3(color.R, color.G, color.B)
	part.Color = color
	part.Transparency =  1 - trans
	part.Reflectance = reflectance / 10 
	if material == "Plastic" or material == "Glass" then 
		part.Mesh.TextureId = "" 
	else 
		part.Mesh.TextureId = part.StringValue.Value 
	end 
end

function isAlive(player)
	local alive = false
	if player ~= nil and player.Parent == game.Players and player.Character ~= nil then
		if player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") ~= nil and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("Head") then
			alive = true
		end
	end
	return alive
end

function isTarget(plr, teammates)
	if isAlive(plr) then
		if not plr.Neutral and not LocalPlayer.Neutral then
			if teammates == false then
				return plr.Team ~= LocalPlayer.Team
			elseif teammates == true then
				return plr ~= LocalPlayer
			end
		else
			return plr ~= LocalPlayer
		end
	end
end

local function lol()
	local number = os.date("%d", os.time()) 
	if number == "01" then
		return "st"
	elseif number == "02" then
		return "nd"
	elseif number == "03" then
		return "rd"
	else
		return "th"
	end
end

local PLRDS = {}

local Ut = {}

Ut.Settings = {
	Line = {
		Thickness = 1,
		Color = Color3.fromRGB(0, 255, 0)
	},
	Text = {
		Size = 13,
		Center = true,
		Outline = true,
		Font = 2,
		Color = Color3.fromRGB(255, 255, 255)
	},
	Square = {
		Thickness = 1,
		Color = Color3.fromRGB(255, 255, 255),
		Filled = false,
	},
	Circle = {
		Filled = false,
		NumSides = 30,
		Thickness = 0,
	},
	Triangle = {
		Color = Color3.fromRGB(255, 255, 255),
		Filled = true,
		Visible = false,
		Thickness = 1,
	}
}

function Ut.New(data)
	local drawing = Drawing.new(data.type)
	for i, v in pairs(Ut.Settings[data.type]) do
		drawing[i] = v
	end
	if data.type == "Square" then
		if not data.filled then
			drawing.Filled = false
		elseif data.filled then
			drawing.Filled = true
		end
	end
	if data.out then
		drawing.Color = Color3.new(0,0,0)
		drawing.Thickness = 3
	end
	return drawing
end

function Ut.Add(Player)
	if not PLRDS[Player] then
		PLRDS[Player] = {
			Offscreen = Ut.New({type = "Triangle"}),
			Name = Ut.New({type = "Text"}),
			NameB = Ut.New({type = "Text"}),
			Distance = Ut.New({type = "Text"}),
			DistanceB = Ut.New({type = "Text"}),
			BoxOutline = Ut.New({type = "Square", out = true}),
			Box = Ut.New({type = "Square"}),
			HealthNumber = Ut.New({type = "Text"}),
			HealthNumberB = Ut.New({type = "Text"}),
			BoxFill = Ut.New({type = "Square"}),
			HealthOutline = Ut.New({type = "Line", out = true}),
			HealthOutline2 = Ut.New({type = "Line"}),
			Health = Ut.New({type = "Line"}),
			Health2 = Ut.New({type = "Line"}),
			HeadDot = Ut.New({type = "Circle"}),
			Tracers = Ut.New({type = "Line"}),
			Exit = Ut.New({type = "Text"}),
			ExitB = Ut.New({type = "Text"}),
			FovTracers = Ut.New({type = "Line"}),
			Tool = Ut.New({type = "Text"}),
			ToolB = Ut.New({type = "Text"}),
		}
	end
end

local crosshair = {
	leftb = Ut.New({type = "Square", filled = true}),
	rightb = Ut.New({type = "Square", filled = true}),
	topb = Ut.New({type = "Square", filled = true}),
	bottomb = Ut.New({type = "Square", filled = true}),
	left = Ut.New({type = "Square", filled = true}),
	right = Ut.New({type = "Square", filled = true}),
	top = Ut.New({type = "Square", filled = true}),
	bottom = Ut.New({type = "Square", filled = true}),
}

local fovcircle = {
	F2 = Ut.New({type = "Circle"}),
	F1 = Ut.New({type = "Circle"}),
	F4 = Ut.New({type = "Circle"}), 
	F3 = Ut.New({type = "Circle"}), 
}

local Watermark = {
	Border = newDrawing("Square", {
        Visible = true,
        Color = Theme.Border,
        Filled = true,
    }),
    Accent = newDrawing("Square", {
        Visible = true,
        Color = Theme.Accent,
        Filled = true,
    }),
    Border2 = newDrawing("Square", {
        Visible = true,
        Color = Theme.Border2,
        Filled = true,
    }),
    Background = newDrawing("Square", {
        Visible = true,
        Color = Theme.Background,
        Filled = true,
    }),
    Gradient = newDrawing("Image", {
        Visible = true,
        Data = Theme.Gradient,
        Transparency = 1,
    }),
    Text = newDrawing("Text", {
        Visible = true,
        Color = Theme.TextColor,
        OutlineColor = Theme.TextOutline,
        Font = Theme.Font,
        Size = Theme.Size,
        Outline = true,
        Text = "alsike | v2.6 [dev] | FPS: 00 | Ping: 00",
    })
}   

StatText = newDrawing("Text", {
	Visible = false,
	Font = 2,
	Size = 13,
	Outline = true,
	Color = C3(255, 255, 255),
	Position = V2(8, 400),
	Text = string.format("Network Send: %s kbps", math.floor(game.Stats.PhysicsSendKbps))
})

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.F2 then
		StatText.Visible = not StatText.Visible
	end
end)

for _,Player in pairs(Players:GetPlayers()) do
	Ut.Add(Player)
end
Players.PlayerAdded:Connect(Ut.Add)
Players.PlayerAdded:Connect(function(Player)
	library.options["plrlist"]:AddValue(Player.Name)
end)
Players.PlayerRemoving:Connect(function(Player)
	if PLRDS[Player] then
		for i,v in pairs(PLRDS[Player]) do
			if v then
				v:Remove()
			end
		end

		PLRDS[Player] = nil
	end

	library.options["plrlist"]:RemoveValue(Player.Name)
end)

if game.PlaceId == 301549746 then
	local Additionals 				= LocalPlayer.Additionals
	local Viewmodel 				= CFrame.new(0,0,0) 
	local FT 						= false 
	local LastStep
	local RTar 
	local WeaponT 					= {} 
	local LeftGlove, RightGlove, LeftSleeve, RightSleeve, RightArm, LeftArm 
	local Pitch
	local AntiAngle
	local smath = 0
	local vangle = nil
	local crash = false
	local x_off = 0
	local y_off = 0
	local dragx = 5
	local dragy = 600
	local stored = false
	local arrows = {
		left = false,
		right = false,
		orig = true,
	}
	local FAn = INST("Animation", workspace) 
	FAn.AnimationId = "rbxassetid://0" 
	local Multipliers = { 
		["Head"] = 4, 
		["FakeHead"] = 4, 
		["HeadHB"] = 4, 
		["UpperTorso"] = 1, 
		["LowerTorso"] = 1.25, 
		["LeftUppeRightArm"] = 1, 
		["LeftLoweRightArm"] = 1, 
		["LeftHand"] = 1, 
		["RightUppeRightArm"] = 1, 
		["RightLoweRightArm"] = 1, 
		["RightHand"] = 1, 
		["LeftUpperLeg"] = 0.75, 
		["LeftLowerLeg"] = 0.75, 
		["LeftFoot"] = 0.75, 
		["RightUpperLeg"] = 0.75, 
		["RightLowerLeg"] = 0.75, 
		["RightFoot"] = 0.75, 
	} 

	local arrowsaa = {
		left = newDrawing("Triangle", {
			Visible = false,
			Color = C3(0, 0, 0),
			Filled = true,
			Transparency = 0.2,
			PointA = V2(ScreenSize.X / 2 - 40, ScreenSize.Y / 2 - 8),
			PointB = V2(ScreenSize.X / 2 - 50, ScreenSize.Y / 2),
			PointC = V2(ScreenSize.X / 2 - 40, ScreenSize.Y / 2 + 8),
		}),
		right = newDrawing("Triangle", {
			Visible = false,
			Color = C3(0, 0, 0),
			Transparency = 0.2,
			Filled = true,
			PointA = V2(ScreenSize.X / 2 + 40, ScreenSize.Y / 2 - 8),
			PointB = V2(ScreenSize.X / 2 + 50, ScreenSize.Y / 2),
			PointC = V2(ScreenSize.X / 2 + 40, ScreenSize.Y / 2 + 8),
		}),
		bottom = newDrawing("Triangle", {
			Visible = false,
			Color = C3(0, 0, 0),
			Transparency = 0.2,
			Filled = true,
			PointA = V2(ScreenSize.X / 2 - 8, ScreenSize.Y / 2 + 40),
			PointB = V2(ScreenSize.X / 2, ScreenSize.Y / 2 + 50),
			PointC = V2(ScreenSize.X / 2 + 8, ScreenSize.Y / 2 + 40),
		})
	}

	local Collision = {Camera, workspace.Ray_Ignore, workspace.Debris}

	VelocityText = newDrawing("Text", {
		Visible = true,
		Font = 2,
		Size = 13,
		Outline = true,
		Color = C3(255, 255, 255),
		Position = V2(ScreenSize.X / 2, 1000),
		Center = true,
	})

	JbText = newDrawing("Text", {
		Visible = false,
		Font = 2,
		Size = 13,
		Outline = true,
		Color = C3(255, 255, 255),
		Position = V2(ScreenSize.X / 2, 1014),
		Text = "JB",
		Center = true,
	})

	EbText = newDrawing("Text", {
		Visible = false,
		Font = 2,
		Size = 13,
		Outline = true,
		Color = C3(255, 255, 255),
		Position = V2(ScreenSize.X / 2, 1014),
		Text = "EB",
		Center = true,
	})

	--[[local SpectatorsList = {
		Border1 = newDrawing("Square", {
			Visible = true,
			Filled = true,
			Color = Theme.Border1,
			Position = V2(dragx, dragy),
		}),
		Background = newDrawing("Square", {
			Visible = true,
			Filled = true,
			Color = Theme.Background,
			Position = V2(dragx + 1, dragy + 3),
		}),
		Accent = newDrawing("Square", {
			Visible = true,
			Filled = true,
			Color = Theme.Accent,
			Position = V2(dragx + 1, dragy + 1),
		}),
		Gradient = newDrawing("Image", {
			Visible = true,
			Data = game:HttpGet("https://i.imgur.com/1wd7il6.png"), 
			Position = V2(dragx + 1, dragy + 3),
		}),
		TopText = newDrawing("Text", {
			Visible = true,
			Font = 0,
			Size = 20,
			Outline = true,
			Position = V2(dragx + 8, dragy + 4),
			Color = Theme.Text,
			Text = "Spectators",
		}),
		Players = newDrawing("Text", {
			Visible = true,
			Font = 0,
			Size = 20,
			Outline = true,
			Position = V2(dragx + 8, dragy + 23),
			Color = Theme.Text,
			Text = "First Player\nSecond Player\nPlease help me dude\nWhat the fuckqwdqwdqwdqwdqwd",
		})
	}--]]

	local NewScope = {
		Line1 = newDrawing("Square", {
			Visible = false,
			Size = V2(ScreenSize.X, 3),
			Position = V2(0, ScreenSize.Y / 2 - 1.5),
			Color = C3(0, 0, 0),
			Filled = true,
		}),
		Line2 = newDrawing("Square", {
			Visible = false,
			Size = V2(3, ScreenSize.Y),
			Position = V2(ScreenSize.X / 2 - 1.5, 0),
			Color = C3(0, 0, 0),
			Filled = true,
		}),
	}

	--!SECTION

	--SECTION Library Shit

	library.CombatTab           	= library:AddTab("Legit", 1)
	library.RageTab           		= library:AddTab("Rage", 2)
	library.VisualsTab              = library:AddTab("Visuals", 3)
	library.MiscTab                 = library:AddTab("Misc", 4)
	library.PlayersColumn1          = library.VisualsTab:AddColumn()
	library.PlayersColumn2          = library.VisualsTab:AddColumn()
	library.MiscColumn1             = library.MiscTab:AddColumn()
	library.MiscColumn2             = library.MiscTab:AddColumn()
	library.CombatColumn1           = library.CombatTab:AddColumn()
	library.CombatColumn2           = library.CombatTab:AddColumn()
	library.RageColumn1         	= library.RageTab:AddColumn()
	library.RageColumn2        		= library.RageTab:AddColumn()

	--!SECTION

	--SECTION Rage

	--SECTION Rage-Aimbot

	--SECTION Misc
	function GetSpectators()
		local CurrentSpectators = ""
		for i,v in pairs(game.Players:GetChildren()) do 
			pcall(function()
				if v ~= game.Players.LocalPlayer then
					if not v.Character then 
						if (v.CameraCF.Value.p - game.Workspace.CurrentCamera.CFrame.p).Magnitude < 10 then 
								if CurrentSpectators == "" then
									CurrentSpectators = v.Name
								else
									CurrentSpectators = CurrentSpectators.. "\n" ..v.Name
								end
							end
						end
					end
				end)
			end
		return CurrentSpectators
	end

	local lasttick = tick()
	local Velocity = 0
	local Speed = 0
	local vadd = 0
	local function Misc(step)
		if isAlive(LocalPlayer) then
			Velocity = (game.Players.LocalPlayer.Character.PrimaryPart.Velocity * Vector3.new(1, 0, 1)).magnitude
			Speed = Velocity * 14.85

			if library.flags["Movement_Velocity"] then
				VelocityText.Text = tostring(math.floor(Speed))
				VelocityText.Visible = true
			else
				VelocityText.Visible = false
			end

			if library.flags["Movement_Indicators"] then
				if library.flags["Movement_JumpBug"] and library.flags["Movement_JumpKey"] then
					JbText.Visible = true
					JbText.Position = V2(ScreenSize.X / 2, 1014)
					vadd = 14
				else
					vadd = 0
					JbText.Visible = false
				end
				if library.flags["Movement_EdgeBug"] and library.flags["Movement_EdgeKey"] then
					EbText.Visible = true
					EbText.Position = V2(ScreenSize.X / 2, 1014 + vadd)
				else
					EbText.Visible = false
				end
			else
				JbText.Visible = false
				EbText.Visible = false
			end
			
			local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")  
			local RootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			local Character = LocalPlayer:FindFirstChild("Character")

			for i,v in next, library.flags["tweaks"] do
				if not v then continue end
			
				if i == "Infinite Cash" then
					LocalPlayer.Cash.Value = 69420
				end
			end

			if library.flags["Movement_Bunny"] and library.flags["Movement_BunnyKey"] then
				local travel = V3()
				local looking = Workspace.CurrentCamera.CFrame.lookVector
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then
					travel += V3(looking.x, 0, looking.Z)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then
					travel -= V3(looking.x, 0, looking.Z)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then
					travel += V3(-looking.Z, 0, looking.x)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then
					travel += V3(looking.Z, 0, -looking.x)
				end

				travel = travel.Unit

				LocalPlayer.Character.Humanoid.Jump = true
				LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

				local newDir = V3(travel.x * library.flags["Movement_BunnyAmt"], RootPart.Velocity.y, travel.Z * library.flags["Movement_BunnyAmt"])

				if travel.Unit.x == travel.Unit.x then
					RootPart.Velocity = newDir
				end
			end

			if library.flags["Movement_Walk"] and library.flags["Movement_WalkKey"] then
				local travel = V3()
				local looking = Workspace.CurrentCamera.CFrame.lookVector
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then
					travel += V3(looking.x, 0, looking.Z)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then
					travel -= V3(looking.x, 0, looking.Z)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then
					travel += V3(-looking.Z, 0, looking.x)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then
					travel += V3(looking.Z, 0, -looking.x)
				end

				travel = travel.Unit

				local newDir = V3(travel.x * library.flags["Movement_WalkAmt"], RootPart.Velocity.y, travel.Z * library.flags["Movement_WalkAmt"])

				if travel.Unit.x == travel.Unit.x then
					RootPart.Velocity = newDir
				end
			end

			if library.flags["Movement_Noclip"] and library.flags["Movement_NoclipKey"] then
				for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
					if v:IsA("BasePart") and v.CanCollide == true then
						v.CanCollide = false
					end
				end
			end

			if library.flags["Movement_Fly"] then
				if library.flags["Movement_FlyM"]== "Noclip" and library.flags["Movement_FlyKey"] then
					for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart") and v.CanCollide == true then
							v.CanCollide = false
						end
					end
				end
				if library.flags["Movement_FlyKey"] then
					local Speed = library.flags.mvflyamt

					local travel = V3()
					local looking = Camera.CFrame.lookVector

					do
						if UserInputService:IsKeyDown(Enum.KeyCode.W) then
							travel += looking
						end
						if UserInputService:IsKeyDown(Enum.KeyCode.S) then
							travel -= looking
						end
						if UserInputService:IsKeyDown(Enum.KeyCode.D) then
							travel += V3(-looking.Z, 0, looking.x)
						end
						if UserInputService:IsKeyDown(Enum.KeyCode.A) then
							travel += V3(looking.Z, 0, -looking.x)
						end

						if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
							travel += V3(0, 1, 0)
						end
						if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
							travel -= V3(0, 1, 0)
						end
					end

					if travel.Unit.x == travel.Unit.x then
						RootPart.Anchored = false
						RootPart.Velocity = travel.Unit * library.flags["Movement_FlyAmt"]
					else
						RootPart.Velocity = V3(0, 0, 0)
						RootPart.Anchored = true
					end
				else
					RootPart.Anchored = false
				end
			end
		end

		if library.flags["r_chat"] then
			game:GetService('ReplicatedStorage').Events.PlayerChatted:FireServer(ChatSpam[math.random(1, ChatSize)]:gsub('\"', ''), false, 'Innocent', false, true)
		end

		--[[SpectatorsList.Accent.Color = library.flags["Menu Accent Color"]
		SpectatorsList.Border1.Position = V2(dragx, dragy - 2)
		SpectatorsList.Background.Position = V2(dragx + 1, dragy + 3)
		SpectatorsList.Accent.Position = V2(dragx + 1, dragy - 1)
		SpectatorsList.Gradient.Position = V2(dragx + 1, dragy + 1)
		SpectatorsList.TopText.Position = V2(dragx + 8, dragy + 4)
		SpectatorsList.Players.Position = V2(dragx + 8, dragy + 23)
		SpectatorsList.Players.Text = GetSpectators()
		if Theme.Outline and library.flags["speclist"] then
			SpectatorsList.Border1.Visible = true
			SpectatorsList.TopText.Outline = true
			SpectatorsList.Players.Outline = true
		else
			SpectatorsList.Border1.Visible = false
			SpectatorsList.TopText.Outline = false
			SpectatorsList.Players.Outline = false
		end
		if SpectatorsList.TopText.TextBounds.X <= SpectatorsList.Players.TextBounds.X then
			if SpectatorsList.Players.Text == "" then
				SpectatorsList.Border1.Size = V2(SpectatorsList.TopText.TextBounds.X, SpectatorsList.TopText.TextBounds.Y) + V2(16, 14)
				SpectatorsList.Background.Size = V2(SpectatorsList.TopText.TextBounds.X, SpectatorsList.TopText.TextBounds.Y) + V2(14, 8)
				SpectatorsList.Accent.Size = V2(SpectatorsList.TopText.TextBounds.X, 2) + V2(14, 0)
				SpectatorsList.Gradient.Size = V2(SpectatorsList.TopText.TextBounds.X, 10) + V2(14, 0)
			else
				SpectatorsList.Border1.Size = V2(SpectatorsList.Players.TextBounds.X, SpectatorsList.TopText.TextBounds.Y) + V2(16, 14) + V2(0, SpectatorsList.Players.TextBounds.Y)
				SpectatorsList.Background.Size = V2(SpectatorsList.Players.TextBounds.X, SpectatorsList.TopText.TextBounds.Y) + V2(14, 8) + V2(0, SpectatorsList.Players.TextBounds.Y)
				SpectatorsList.Accent.Size = V2(SpectatorsList.Players.TextBounds.X, 2) + V2(14, 0)
				SpectatorsList.Gradient.Size = V2(SpectatorsList.Players.TextBounds.X, 10) + V2(14, 0)
			end
		elseif SpectatorsList.TopText.TextBounds.X >= SpectatorsList.Players.TextBounds.X then
			if SpectatorsList.Players.Text == "" then
				SpectatorsList.Border1.Size = V2(SpectatorsList.TopText.TextBounds.X, SpectatorsList.TopText.TextBounds.Y) + V2(16, 14)
				SpectatorsList.Background.Size = V2(SpectatorsList.TopText.TextBounds.X, SpectatorsList.TopText.TextBounds.Y) + V2(14, 8)
				SpectatorsList.Accent.Size = V2(SpectatorsList.TopText.TextBounds.X, 2) + V2(14, 0)
				SpectatorsList.Gradient.Size = V2(SpectatorsList.TopText.TextBounds.X, 10) + V2(14, 0)
			else
				SpectatorsList.Border1.Size = V2(SpectatorsList.TopText.TextBounds.X, SpectatorsList.TopText.TextBounds.Y) + V2(16, 14) + V2(0, SpectatorsList.Players.TextBounds.Y)
				SpectatorsList.Background.Size = V2(SpectatorsList.TopText.TextBounds.X, SpectatorsList.TopText.TextBounds.Y) + V2(14, 8) + V2(0, SpectatorsList.Players.TextBounds.Y)
				SpectatorsList.Accent.Size = V2(SpectatorsList.TopText.TextBounds.X, 2) + V2(14, 0)
				SpectatorsList.Gradient.Size = V2(SpectatorsList.TopText.TextBounds.X, 10) + V2(14, 0)
			end
		end
	
		if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
			if MouseOverDrawing({dragx, dragy, dragx + SpectatorsList.Border1.Size.X, dragy + SpectatorsList.Border1.Size.Y}) then
				if not stored then
					x_off = UserInputService:GetMouseLocation().X - dragx
					y_off = UserInputService:GetMouseLocation().Y - dragy
					stored = true
				end
				dragx = UserInputService:GetMouseLocation().X - x_off
				dragy = UserInputService:GetMouseLocation().Y - y_off
			end
		elseif stored then
			stored = false
		end--]]

		local count = #eventLogs
		local removedFirst = false
		for i = 1, count do
			local curTick = tick()
			local eventLog = eventLogs[i]
			if eventLog then
				if curTick - eventLog.startTick > eventLog.lifeTime then
					task.spawn(eventLog.Destroy, eventLog)
					table.remove(eventLogs, i)
				elseif count > 10 and not removedFirst then
					removedFirst = true
					local first = table.remove(eventLogs, 1)
					task.spawn(first.Destroy, first)
				else
					local previousEventLog = eventLogs[i - 1]
					local basePosition
					if previousEventLog then
						basePosition = Vector2.new(20, previousEventLog.mainText.Position.y + previousEventLog.mainText.TextBounds.y + 10)
					else
						basePosition = Vector2.new(20, 48)
					end
					eventLog.mainText.Position = V2(eventLog.Background.Position.X + 5, eventLog.Background.Position.Y + 5)
					eventLog.mainText.Outline = true
	
					eventLog.Border1.Position = V2(basePosition.X, basePosition.Y)
					eventLog.Accent.Position = V2(eventLog.Border1.Position.X + 1, eventLog.Border1.Position.Y + 1)
					eventLog.Border2.Position = V2(eventLog.Accent.Position.X + 1, eventLog.Accent.Position.Y + 1)
					eventLog.Background.Position = V2(eventLog.Border2.Position.X + 1, eventLog.Border2.Position.Y + 1)
					eventLog.Gradient.Position = V2(eventLog.Border2.Position.X + 1, eventLog.Border2.Position.Y + 1)
	
					eventLog.Border1.Size = V2(eventLog.mainText.TextBounds.X + 16, eventLog.mainText.TextBounds.Y + 16)
					eventLog.Accent.Size = V2(eventLog.mainText.TextBounds.X + 14, eventLog.mainText.TextBounds.Y + 14)
					eventLog.Border2.Size = V2(eventLog.mainText.TextBounds.X + 12, eventLog.mainText.TextBounds.Y + 12)
					eventLog.Background.Size = V2(eventLog.mainText.TextBounds.X + 10, eventLog.mainText.TextBounds.Y + 10)
					eventLog.Gradient.Size = V2(eventLog.mainText.TextBounds.X + 10, eventLog.mainText.TextBounds.Y + 10)
	
					eventLog.Accent.Color = Theme.Accent
				end
			end
		end
	end
	getgenv().createEventLog = createEventLog
	--!SECTION

	library.Rage = library.RageColumn1:AddSection("Aimbot")
	library.Rage:AddToggle({text = "Enabled", flag = "rage_enabled"}):AddBind({callback = function(val)
		library.options["rage_enabled"]:SetState(not library.flags["rage_enabled"])
	end})
	library.Rage:AddList({text = "Origin",  flag = "rage_origin", value = "Character", values = {"Character", "Camera"}})
	library.Rage:AddToggle({text = "Silent Aim", flag = "rage_silent"})
	library.Rage:AddToggle({text = "Automatic Fire", flag = "rage_fire"})
	library.Rage:AddToggle({text = "Automatic Penetration", flag = "rage_pen"}):AddSlider({flag = "rage_penamt", value = 1, min = 1, max = 100})
	library.Rage:AddToggle({text = "Prediction", flag = "rage_pred"})
	library.Rage:AddToggle({text = "Force Headshot", flag = "rage_head"})
	library.Rage:AddToggle({text = "Forward Track", flag = "ftrack"})
	library.Rage:AddSlider({text = "Amount", flag = "ftrackamt", suffix = "ms", value = 0, min = 0, max = 1000})
	library.Rage:AddDivider("Settings")
	library.Rage:AddSlider({text = "Minimum Damage", flag = "rage_damage", value = 1, min = 1, max = 100})
	library.Rage:AddList({text = "Hitbox", multiselect = true,  flag = "rage_hitbox", value = "Head", values = {"Head", "Torso", "Arms", "Legs"}})
	--!SECTION

	--SECTION Rage-Exploits
	library.Exploits = library.RageColumn1:AddSection("Exploits")
	library.Exploits:AddToggle({text = "Kill All", flag = "rage_kill"}):AddBind({flag = "rage_killkey", callback = function(val)
		if val then
			createEventLog("Successfully enabled kill all!", 5)
		else
			createEventLog("Successfully disabled kill all!", 5)
		end
	end})
	library.Exploits:AddToggle({text = "Double Tap", flag = "rage_dt"}):AddBind({flag = "rage_dtkey", callback = function(val)
		if val then
			createEventLog("Successfully enabled double tap!", 5)
		else
			createEventLog("Successfully disabled double tap!", 5)
		end
	end})
	--!SECTION

	--SECTION Rage-Antiaim
	library.AntiAim = library.RageColumn2:AddSection("Anti-Aim")
	library.AntiAim:AddToggle({text = "Enabled", flag = "anti_enabled"}):AddBind({callback = function(val)
		library.options["anti_enabled"]:SetState(not library.flags["anti_enabled"])
	end})
	library.AntiAim:AddList({text = "Pitch",  flag = "anti_pitch", value = "Down", values = {"Up", "Down", "Zero", "Random"}})
	library.AntiAim:AddList({text = "Yaw",  flag = "anti_yaw", value = "Camera", values = {"Backward", "Forward", "Spin", "Random"}})
	library.AntiAim:AddSlider({text = "Spin Speed", flag = "anti_spinamt", value = 1, min = 1, max = 50})
	library.AntiAim:AddToggle({text = "Slide Walk", flag = "anti_slide"})
	library.AntiAim:AddToggle({text = "Manual Anti-Aim", flag = "anti_man"})
	library.AntiAim:AddToggle({text = "Anti-Aim Arrows", flag = "anti_arrow"}):AddColor({flag = "anticol", color = C3(255, 255, 255)})
	library.AntiAim:AddBind({text = "Left", flag = "left", callback = function(val)
		if val then
			arrows.right = false
			arrows.left = true
			arrows.orig = false
		end
	end})
	library.AntiAim:AddBind({text = "Right", flag = "right", callback = function(val)
		if val then
			arrows.left = false
			arrows.right = true
			arrows.orig = false
		end
	end})
	library.AntiAim:AddBind({text = "Original Yaw", flag = "right", callback = function(val)
		if val then
			arrows.left = false
			arrows.right = false
			arrows.orig = true
		end
	end})
	--!SECTION

	--SECTION Rage-Knifebot
	library.Knife = library.RageColumn2:AddSection("Knife Bot")
	library.Knife:AddToggle({text = "Enabled", flag = "rage_knife"}):AddBind({flag = "rage_knifek", callback = function(val)
		if val then
			createEventLog("Successfully enabled knife bot!", 5)
		else
			createEventLog("Successfully disabled knife bot!", 5)
		end
	end})
	library.Knife:AddToggle({text = "Visible Check", flag = "rage_knifev"})
	library.Knife:AddToggle({text = "Rapid", flag = "rage_knifer"})
	library.Knife:AddSlider({text = "Maximum Distance", flag = "rage_knifed", value = 0, min = 0, max = 10000})
	--!SECTION

	--!SECTION

	--SECTION Combat

	--SECTION Combat-Aimbot
	library.Aimbot = library.CombatColumn1:AddSection("Aimbot")
	library.Aimbot:AddToggle({text = "Enabled", flag = "aimbot_enabled"}):AddBind({flag = "aimbot_key", mode = "hold"})
	library.Aimbot:AddToggle({text = "Visible Check", flag = "aimbot_vis"})
	library.Aimbot:AddList({text = "Hitbox",  flag = "aimbot_hit", value = "Head", values = {"Head", "Torso"}})
	library.Aimbot:AddSlider({text = "Smoothing", flag = "aimbot_smooth", value = 1, min = 1, max = 100, suffix = '%'})
	library.Aimbot:AddToggle({text = "Teammates", flag = "aimbot_team"})
	library.Aimbot:AddToggle({text = "Distance Check", flag = "aimbot_distance"}):AddSlider({flag = "aimbot_distanceamt", value = 500, min = 30, max = 1500, suffix = 'm'})
	--!SECTION

	--SECTION Combat-Silent
	library.Silent = library.CombatColumn2:AddSection("Silent-Aim")
	library.Silent:AddToggle({text = "Enabled", flag = "silent_enabled"}):AddBind({flag = "silent_key", mode = "hold"})
	library.Silent:AddToggle({text = "Visible Check", flag = "silent_vis"})
	library.Silent:AddList({text = "Hitbox",  flag = "silent_hit", value = "Head", values = {"Head", "Torso"}})
	library.Silent:AddSlider({text = "Hit Chance", flag = "silent_hitc", value = 1, min = 1, max = 100, suffix = '%'})
	library.Silent:AddToggle({text = "Teammates", flag = "silent_team"})
	library.Silent:AddToggle({text = "Distance Check", flag = "silent_distance"}):AddSlider({flag = "silent_distanceamt", value = 500, min = 30, max = 1500, suffix = 'm'})
	--!SECTION

	--SECTION Combat-Aimbot Settings
	library.Aimbot = library.CombatColumn2:AddSection("Aimbot Settings")
	library.Aimbot:AddSlider({text = "Aim Assist FOV", flag = "aimbot_fov", value = 60, min = 0, max = 800})
	library.Aimbot:AddSlider({text = "Silent Aim FOV", flag = "silent_fov", value = 60, min = 0, max = 800})
	--!SECTION

	--!SECTION

	--SECTION Visuals

	--SECTION Visuals-Player ESP
	library.Players = library.PlayersColumn1:AddSection("Player ESP")
	library.Players:AddToggle({text = "Enabled", flag = "ESP_Enabled"}):AddBind({callback = function()
		library.options["ESP_Enabled"]:SetState(not library.flags["ESP_Enabled"])
	end})
	library.Players:AddToggle({text = "Chams", flag = "ESP_Chams"}):AddColor({flag = "ESPC_ChamsF", trans = 0.5, color = C3(66, 135, 245), calltrans = function(val)
		esp.ChamsF = val
	end}):AddColor({flag = "ESPC_ChamsO", trans = 0.5, color = C3(66, 245, 176), calltrans = function(val)
		esp.ChamsO = val
	end})
	library.Players:AddToggle({text = "Box ESP", flag = "ESP_Box"}):AddColor({flag = "ESPC_Box", color = C3(255, 255, 255)}):AddColor({flag = "ESPC_BoxF", color = C3(255, 255, 255), trans = 0.2, calltrans = function(val)
		esp.BoxFill = val
	end})
	library.Players:AddToggle({text = "Name ESP", flag = "ESP_Name"}):AddColor({flag = "ESPC_Name", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Weapon ESP", flag = "ESP_Tool"}):AddColor({flag = "ESPC_Tool", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Distance ESP", flag = "ESP_Distance"}):AddColor({flag = "ESPC_Distance", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Health Bar", flag = "ESP_HealthB"}):AddColor({flag = "ESPC_HealthB", color = C3(255, 255, 0)})
	library.Players:AddToggle({text = "Health Number", flag = "ESP_HNum"}):AddColor({flag = "ESPC_HNum", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Tracers", flag = "ESP_Tracers"}):AddColor({flag = "ESPC_Tracers", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Head Dot", flag = "ESP_Head"}):AddColor({flag = "ESPC_Head", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Out Of View", flag = "ESP_OOF"}):AddColor({flag = "ESPC_OOF", color = C3(255, 255, 255)})
	library.Players:AddDivider("Local ESP")
	library.Players:AddToggle({text = "Chams", flag = "ESPL_Chams"}):AddColor({flag = "ESPCL_ChamsF", trans = 0.5, color = C3(66, 135, 245), calltrans = function(val)
		esp.ChamsFL = val
	end}):AddColor({flag = "ESPCL_ChamsO", trans = 0.5, color = C3(66, 245, 176), calltrans = function(val)
		esp.ChamsOL = val
	end})
	library.Players:AddToggle({text = "Box ESP", flag = "ESPL_Box"}):AddColor({flag = "ESPCL_Box", color = C3(255, 255, 255)}):AddColor({flag = "ESPCL_BoxF", color = C3(255, 255, 255), trans = 0.2, calltrans = function(val)
		esp.BoxFillL = val
	end})
	library.Players:AddToggle({text = "Name ESP", flag = "ESPL_Name"}):AddColor({flag = "ESPCL_Name", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Weapon ESP", flag = "ESPL_Tool"}):AddColor({flag = "ESPCL_Tool", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Health Bar", flag = "ESPL_HealthB"}):AddColor({flag = "ESPCL_HealthB", color = C3(255, 255, 0)})
	library.Players:AddToggle({text = "Health Number", flag = "ESPL_HNum"}):AddColor({flag = "ESPCL_HNum", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Head Dot", flag = "ESPL_Head"}):AddColor({flag = "ESPCL_Head", color = C3(255, 255, 255)})
	library.Players:AddDivider("Settings")
	library.Players:AddToggle({text = "Outline", state = true, flag = "ESP_Out"})
	library.Players:AddToggle({text = "Bold Text", flag = "ESP_Bold"})
	library.Players:AddToggle({text = "Teammates", state = true, flag = "ESP_Team"})
	library.Players:AddSlider({text = "Out Of View Size", flag = "ESP_OS", value = 10, min = 1, max = 25})
	library.Players:AddSlider({text = "Out Of View Distance", flag = "ESP_OD", value = 300, min = 50, max = 800})
	library.Players:AddSlider({text = "HP Visibility Cap", flag = "ESP_HP", value = 90, min = 0, max = 100})
	library.Players:AddList({text = "Font",  flag = "ESP_Font", value = "Plex", values = {"UI", "System", "Plex", "Monospace"}})
	library.Players:AddList({text = "Text Mode", flag = "ESP_TMode",  value = "Normal", values = {"Normal", "lowercase", "UPPERCASE"}})
	library.Players:AddSlider({text = "Size", flag = "ESP_Size", value = 13, min = 1, max = 50})
	--!SECTION

	--SECTION Visuals-Misc
	library.Misc = library.PlayersColumn1:AddSection("Misc")
	library.Misc:AddToggle({text = "Remove Scope", flag = "rems"})
	library.Misc:AddToggle({text = "Bullet Tracers", flag = "bullet"}):AddColor({flag = "bulletc", color = C3(255, 255, 255)})
	library.Misc:AddToggle({text = "Third Person", flag = "thirdperson"}):AddSlider({flag = "thirdamt", value = 5, min = 1, max = 30}):AddBind({flag = "thirdekey"})
	--!SECTION

	--SECTION Visuals-Local
	library.Local = library.PlayersColumn2:AddSection("Local")
	library.Local:AddToggle({text = "Force Crosshair", flag = "Local_Force"})
	library.Local:AddToggle({text = "Weapon Chams", flag = "Local_Gun"}):AddList({flag = "Local_GunM", value = "ForceField", values = {"ForceField", "Neon", "Plastic", "Glass"}}):AddColor({flag = "LocalC_Gun", trans = 0.5, color = C3(255, 255, 255), calltrans = function(val)
		esp.WeaponChams = val
	end})
	library.Local:AddSlider({text = "Reflectance", flag = "Local_GunR", value = 5, min = 0, max = 100})
	library.Local:AddToggle({text = "Arm Chams", flag = "Local_Arm"}):AddList({flag = "Local_ArmM", value = "ForceField", values = {"ForceField", "Neon", "Plastic", "Glass"}}):AddColor({flag = "LocalC_Arm", color = C3(255, 255, 255), trans = 0.5, calltrans = function(val)
		esp.HandChams = val
	end})		
	library.Local:AddSlider({text = "Reflectance", flag = "Local_ArmR", value = 5, min = 0, max = 100})
	library.Local:AddToggle({text = "Field Of View", flag = "Local_Fov"}):AddSlider({flag = "Local_FAmt", value = 90, min = 30, max = 120})
	library.Local:AddToggle({text = "Aim Assist Circle", flag = "FOV_Enabled"}):AddColor({flag = "FOVC", trans = 1, color = C3(255, 255, 255), calltrans = function(val)
		esp.F1 = val
	end}):AddColor({flag = "FOVCO", trans = 1, color = C3(0, 0, 0), calltrans = function(val)
		esp.F2 = val
	end})
	library.Local:AddToggle({text = "Silent Aim Circle", flag = "FOVS_Enabled"}):AddColor({flag = "FOVSC", trans = 1, color = C3(255, 255, 255), calltrans = function(val)
		esp.F3 = val
	end}):AddColor({flag = "FOVSCO", trans = 1, color = C3(0, 0, 0), calltrans = function(val)
		esp.F4 = val
	end})
	library.Local:AddToggle({text = "Filled", flag = "FOV_Filled"})
	library.Local:AddSlider({text = "Num Sides",flag = "FOVN", value = 20, min = 0, max = 50})
	library.Local:AddSlider({text = "Thickness",flag = "FOVT", value = 1, min = 1, max = 25})
	--!SECTION

	--SECTION Visuals-World
	library.World = library.PlayersColumn2:AddSection("World")
	library.World:AddToggle({text = "Ambient", flag = "World_Ambient"}):AddColor({flag = "WorldC_OutC", color = C3(255, 255, 255)}):AddColor({flag = "WorldC_C", color = C3(255, 255, 255)})
	library.World:AddToggle({text = "Contrast", flag = "World_Contrast"}):AddSlider({flag = "World_CAmt", value = 0.5, min = 0, max = 1, float = 0.01})
	library.World:AddToggle({text = "Saturation", flag = "World_Saturation"}):AddSlider({flag = "World_SAmt", value = 0.5, min = 0, max = 1, float = 0.01})
	library.World:AddToggle({text = "Fog", flag = "World_Fog"}):AddColor({flag = "World_FogC", color = C3(255, 255, 255)})
	library.World:AddSlider({text = "Fog Start", flag = "World_FogS", value = 0, min = 0, max = 1000})
	library.World:AddSlider({text = "Fog End", flag = "World_FogE", value = 0, min = 0, max = 1000})
	library.World:AddToggle({text = "Time", flag = "World_Time"}):AddSlider({flag = "World_TAmt", value = 12, min = 0, max = 24})
	--!SECTION

	--SECTION Visuals-Viewmodel
	library.View = library.PlayersColumn2:AddSection("Viewmodel")
	library.View:AddToggle({text = "Enabled", flag = "viewmodel"})
	library.View:AddToggle({text = "Visualize Silent Angles", flag = "silenta"})
	library.View:AddSlider({text = "X", flag = "viewx", value = 10, min = -20, max = 20})
	library.View:AddSlider({text = "Y", flag = "viewy", value = 10, min = -20, max = 20})
	library.View:AddSlider({text = "Z", flag = "viewz", value = 10, min = -20, max = 20})
	library.View:AddSlider({text = "Roll", flag = "viewr", value = 0, min = -180, max = 180})
	--!SECTION

	--!SECTION

	--SECTION Misc

	--SECTION Misc-Main

	library.Main = library.MiscColumn1:AddSection("Main")
	library.Main:AddToggle({text = "Hitlogs", flag = "rage_logs"})
	--[[library.Main:AddToggle({text = "Spectators List", flag = "speclist", callback = function(val)
		for i,v in pairs(SpectatorsList) do	
			v.Visible = val
		end
	end})--]]
	library.Main:AddToggle({text = "Watermark", flag = "watermark", state = true, callback = function(val)
		for i,v in pairs(Watermark) do	
			v.Visible = val
		end
	end})
	--[[for i,v in pairs(SpectatorsList) do	
		v.Visible = false
	end--]]
	library.Main:AddToggle({text = "Outline", state = false, callback = function(val)
		Theme.Outline = val
	end})
	library.Main:AddToggle({text = "Hitsound", flag = "hitsound"}):AddList({flag = "hits",  value = "Neverlose", values = {"Neverlose", "Skeet", "Rust", "Baimware", "Oni-Chan", "Rifk7"}})
	library.Main:AddSlider({text = "Hitsound Volume", flag = "hitv", value = 50, min = 1, max = 100})
	library.Main:AddList({text = "Game Tweaks",  multiselect = true, flag = "tweaks", value = "Velocity", values = {"Infinite Cash", "Infinite Ammo", "Instant Reload", "No Fire Damage", "Infinite Buy Time", "Shop Anywhere", "Rapid Fire"}})
	--!SECTION

	--SECTION Misc-Players
	library.Players2 = library.MiscColumn2:AddSection("Players")
	library.Players2:AddList({flag = "Player List", skipflag = true, flag = "plrlist", textpos = 2, max = 10, values = (function() 
		local t = {} 
		for _, Player in next, Players:GetPlayers() do 
			if Player ~= LocalPlayer then 
				table.insert(t, Player.Name) 
			end 
		end 
		return t 
	end)()})
	library.Players2:AddToggle({text = "Loop Kill", flag = "loopkill"})
	--!SECTION

	--SECTION Misc-Character
	library.Movement = library.MiscColumn1:AddSection("Movement")
	library.Movement:AddToggle({text = "Bunny Hop", flag = "Movement_Bunny"}):AddSlider({flag = "Movement_BunnyAmt", value = 18, min = 18, max = 300}):AddBind({flag = "Movement_BunnyKey", mode = "hold"})
	library.Movement:AddToggle({text = "Walk Speed", flag = "Movement_Walk"}):AddSlider({flag = "Movement_WalkAmt", value = 18, min = 18, max = 300}):AddBind({flag = "Movement_WalkKey", mode = "hold"})
	library.Movement:AddToggle({text = "Fly", flag = "Movement_Fly"}):AddSlider({flag = "Movement_FlyAmt", value = 18, min = 18, max = 300}):AddBind({flag = "Movement_FlyKey"})
	library.Movement:AddToggle({text = "Noclip", flag = "Movement_Noclip"}):AddBind({flag = "Movement_NoclipKey"})
	library.Movement:AddToggle({text = "No Fall Damage", flag = "Movement_DMG"})
	library.Movement:AddList({text = "Fly Method",  flag = "Movement_FlyM", value = "Velocity", values = {"Velocity", "Noclip"}})
	--!SECTION

	--SECTION Misc-Auto Buy
	library.Buy = library.MiscColumn1:AddSection("Auto Buy")
	library.Buy:AddToggle({text = "Enabled", flag = "buybot"})
	library.Buy:AddList({text = "Primary",  flag = "prim", values = {"MP9", "MAC10", "MP7", "UMP", "P90", "Bizon", "M4A4", "M4A1", "AK47", "Famas", "Galil", "AUG", "SG", "AWP", "Scout", "G3SG1", "XM", "Nova", "Sawed off", "Mag 7"}})
	library.Buy:AddList({text = "Secondary",  flag = "sec", values = {"P2000", "DualBerettas", "P250", "FiveSeven", "Tec9", "CZ", "DesertEagle", "R8"}})
	--!SECTION

	--SECTION Misc-Other
	library.Other = library.MiscColumn2:AddSection("Other")
	library.Crash = library:AddWarning({type = "confirm"})
	library.Other:AddToggle({text = "Remove Recoil", flag = "r_recoil"})
	library.Other:AddToggle({text = "Remove Spread", flag = "r_spread"})
	library.Other:AddToggle({text = "Chat Spammer", flag = "r_chat"})
	library.Other:AddButton({text = "Crash Server", callback = function()
		library.Crash.text = "Are you sure you want to crash server?"
		if library.Crash:Show() then
			crash = true
		end
	end})
	LocalPlayer.CharacterAdded:Connect(function()
		if library.flags["buybot"] then
			local givefunc
			for _, v in pairs(getgc()) do
				local parentScript = rawget(getfenv(v), "script")
				if type(v) == "function" and parentScript == game:GetService("Players").LocalPlayer.PlayerGui.Client and islclosure(v) and not is_synapse_function(v) and debug.getinfo(v).name == "giveTool" then
					givefunc = v
					break
				end
			end

			if library.flags["prim"] ~= "" then
				debug.setupvalue(givefunc, 8, library.flags["prim"])
			end
			
			if library.flags["sec"] ~= "" then
				debug.setupvalue(givefunc, 7, library.flags["sec"])
			end
		end
	end)
	library.Other:AddButton({text = "God Mode", callback = function()
	    local ReplicatedStorage = game:GetService("ReplicatedStorage");
        local ApplyGun = ReplicatedStorage.Events.ApplyGun;
        ApplyGun:FireServer({
        	Model = ReplicatedStorage.Hostage.Hostage,
        	Name = "USP"
        }, game.Players.LocalPlayer);
    end})
	--!SECTION
	
	--!SECTION

	--SECTION Misc-Crosshair
	library.Crosshair = library.MiscColumn2:AddSection("Crosshair")
	library.Crosshair:AddToggle({text = "Enabled", flag = "Crosshair_Enabled"}):AddColor({flag = "CrosshairC", color = C3(255, 255, 0)}):AddColor({flag = "CrosshairCO", color = C3(0, 0, 0)})
	library.Crosshair:AddSlider({text = "Length", flag = "CrosshairL", value = 5, min = 1, max = 300})
	library.Crosshair:AddSlider({text = "Thickness", flag = "CrosshairT", value = 2, min = 2, max = 14, float = 2})
	library.Crosshair:AddSlider({text = "Gap", flag = "CrosshairG", value = 4, min = 1, max = 100})
	library.Crosshair:AddToggle({text = "Border", flag = "Crosshair_Border"})
	--!SECTION

	--SECTION Misc-Meme Features
	library.Meme = library.MiscColumn2:AddSection("Meme Features")
	library.Meme:AddToggle({text = "Edge Bug", flag = "Movement_EdgeBug"}):AddBind({flag = "Movement_EdgeKey", mode = "hold"})
	library.Meme:AddToggle({text = "Jump Bug", flag = "Movement_JumpBug"}):AddBind({flag = "Movement_JumpKey", mode = "hold"})
	library.Meme:AddToggle({text = "Velocity", flag = "Movement_Velocity"})
	library.Meme:AddToggle({text = "Indicators", flag = "Movement_Indicators"})
	--!SECTION

	--SECTION Functions
	local Remote = ReplicatedStorage.Events:FindFirstChild("HitNN") or ReplicatedStorage.Events:FindFirstChild("Hit") or ReplicatedStorage.Events:FindFirstChild("HitPart")
	local Client = getsenv(LocalPlayer.PlayerGui.Client)
	--SECTION Combat
	local function YROTATION(cframe) 
		local x, y, z = cframe:ToOrientation() 
		return CFrame.new(cframe.Position) * CFrame.Angles(0,y,0) 
	end 
	local function Combat(step)
		LastStep = step 
		Ping = game.Stats.PerformanceStats.Ping:GetValue() 
		local RPar = RaycastParams.new()        	
		RPar.IgnoreWater = true 
		RPar.FilterType = Enum.RaycastFilterType.Blacklist
		RPar.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
		Camera = workspace.Camera
		local mousePos = V3(UserInputService:GetMouseLocation().x, UserInputService:GetMouseLocation().y, 0)

		if library.flags["r_recoil"] then
			Client.RecoilX = 0 
			Client.RecoilY = 0 
			Client.resetaccuracy() 
		end

		if library.flags["loopkill"] then
			if isAlive(Players[library.flags["plrlist"]]) and isAlive(LocalPlayer) and isTarget(Players[library.flags["plrlist"]], false) and LocalPlayer.Character:FindFirstChild("Gun") and not Players[library.flags["plrlist"]].Character:FindFirstChildOfClass("ForceField") then
				local ARG = {
					[1] = Players[library.flags["plrlist"]].Character.Head,
					[2] = Vector3.zero,
					[3] = "P2000TEST",
					[4] = 100,
					[5] = LocalPlayer.Character.Gun,
					[8] = 10,
					[9] = true,
					[10] = true,
					[11] = Vector3.zero,
					[12] = 100,
					[13] = Vector3.zero
				}
				Remote:FireServer(unpack(ARG))
			end
		end

		if library.flags["rage_kill"] and library.flags["rage_killkey"] then
			for i,v in pairs(Players:GetChildren()) do
				if v ~= Players.LocalPlayer and isTarget(v, false) and isAlive(v) and isAlive(LocalPlayer) and LocalPlayer.Character:FindFirstChild("Gun") and not v.Character:FindFirstChildOfClass("ForceField") then
    				local ARG = {
    					[1] = v.Character.Head,
    					[2] = Vector3.zero,
    					[3] = LocalPlayer.Character.EquippedTool.Value,
    					[4] = 100,
    					[5] = LocalPlayer.Character.Gun,
    					[8] = 10,
    					[9] = true,
    					[10] = true,
    					[11] = Vector3.zero,
    					[12] = 100,
    					[13] = Vector3.zero
    				}
					Remote:FireServer(unpack(ARG))
				end
			end
		end

		if RTar then
			vangle = RTar.Position
			lasttick = tick()
		else
			if tick() - lasttick > 0.2 then
				vangle = nil
			end
		end

		if isAlive(LocalPlayer) then -- CB Rage start please kill me.
			-- If you are reading this don't expect this to be self coded, it's my first time making a ragebot so be nice! ;D
			-- This is a thing for me to learn of.
			RTar = nil 
			if Client.gun.Name ~= "C4" and workspace:FindFirstChild("Map") and Client.gun ~= nil and Client.gun ~= "none" then
				local Origin = library.flags["rage_origin"] == "Character" and LocalPlayer.Character.LowerTorso.Position + V3(0, 2.5, 0) or Camera.CFrame.p
				for _,Player in pairs(Players:GetPlayers()) do 
					for i,v in next, library.flags["tweaks"] do
						if not v then continue end

						if i == "Rapid Fire" then
							Client.DISABLED = false
						end
					end
					
					if isAlive(Player) and not Client.DISABLED and Player.Team ~= "TTT" and not Player.Character:FindFirstChildOfClass("ForceField") and Player ~= LocalPlayer and Player.Team ~= LocalPlayer.Team and Player:FindFirstChild("Status") and Player.Status.Team.Value ~= LocalPlayer.Status.Team.Value and Player.Status.Alive.Value then 
						if Client.gun:FindFirstChild("Melee") and library.flags["rage_knife"] and library.flags["rage_knifek"] then 
							local Ignore = {unpack(Collision)}
							if library.flags["rage_knifer"] then
								Client.DISABLED = false
							end
							if not library.flags["rage_knifev"] then
								table.insert(Ignore, game.Workspace.Map)
							end
							table.insert(Ignore, workspace.Map.Clips)
							table.insert(Ignore, workspace.Map.SpawnPoints)
							table.insert(Ignore, LocalPlayer.Character)
							table.insert(Ignore, Player.Character.HumanoidRootPart)
							if Player.Character:FindFirstChild("BackC4") then
								table.insert(Ignore, Player.Character.BackC4)
							end
							if Player.Character:FindFirstChild("Gun") then
								table.insert(Ignore, Player.Character.Gun)
							end

							local Ray = Ray.new(Origin, (Player.Character.HumanoidRootPart.Position - Origin).unit * library.flags["rage_knifed"])
							local Hit, Pos = workspace:FindPartOnRayWithIgnoreList(Ray, Ignore, false, true)

							if Hit and Hit.Parent == Player.Character then                                    
								RTar = Hit
								FT = true

								spawn(function()
									wait(0.9)
									FT = false
								end)
							
								local ARG = {
									[1] = Hit,
									[2] = Vector3.zero,
									[3] = LocalPlayer.Character.EquippedTool.Value,
									[4] = 100,
									[5] = LocalPlayer.Character.Gun,
									[8] = 10,
									[9] = true,
									[10] = true,
									[11] = Vector3.zero,
									[12] = 100,
									[13] = Vector3.zero
								}
								Remote:FireServer(unpack(ARG))
							end
						else
							if library.flags["rage_enabled"] then
								if library.flags["ftrack"] then
									Player.Character.UpperTorso.Waist.C0 = CFrame.new(0, 0.5 * (library.flags["ftrackamt"] / 10), library.flags["ftrackamt"] / 10)
									Player.Character.Head.Neck.C0 = CFrame.new(0, 0.7 * (library.flags["ftrackamt"] / 10), library.flags["ftrackamt"] / 10)
									Player.Character.RightUpperArm:FindFirstChildWhichIsA("Motor6D").C0 = CFrame.new(1.5 * (library.flags["ftrackamt"] / 10), 0.549999952, -0.2)
									Player.Character.LeftUpperArm:FindFirstChildWhichIsA("Motor6D").C0 = CFrame.new(-(1.5 * (library.flags["ftrackamt"] / 10)), 0.549999952, -0.2)
								end
								-- Our ignore shit, map clips spawns and shit.
								local Character = Player.Character
								local IG = {unpack(Collision)} 
								table.insert(IG, workspace.Map.Clips)
								table.insert(IG, workspace.Map.SpawnPoints)
								table.insert(IG, LocalPlayer.Character)
								table.insert(IG, Player.Character.HumanoidRootPart)
								if Player.Character:FindFirstChild("BackC4") then
									table.insert(IG, Player.Character.BackC4)
								end
								if Player.Character:FindFirstChild("Gun") then
									table.insert(IG, Player.Character.Gun)
								end

								-- Getting our hitboxes. (VERY RETARDED!!!!)
								local Hitb = {}
								for i,v in next, library.flags["rage_hitbox"] do
									if not v then continue end
									if i == "Head" then
										table.insert(Hitb, Player.Character:FindFirstChild("Head"))
									end
									if i == "Torso" then
										table.insert(Hitb, Player.Character:FindFirstChild("UpperTorso"))
										table.insert(Hitb, Player.Character:FindFirstChild("LowerTorso")) 
									end
									if i == "Arms" then
										table.insert(Hitb, Player.Character:FindFirstChild("LeftUppeRightArm"))
										table.insert(Hitb, Player.Character:FindFirstChild("RightUppeRightArm"))
										table.insert(Hitb, Player.Character:FindFirstChild("LeftLoweRightArm"))
										table.insert(Hitb, Player.Character:FindFirstChild("RightLoweRightArm"))
									end
									if i == "Legs" then
										table.insert(Hitboxes, Player.Character:FindFirstChild("LeftUpperLeg"))
										table.insert(Hitboxes, Player.Character:FindFirstChild("RightUpperLeg"))
										table.insert(Hitboxes, Player.Character:FindFirstChild("LeftLowerLeg"))
										table.insert(Hitboxes, Player.Character:FindFirstChild("RightLowerLeg"))
									end
								end

								--[[
								library.Rage:AddToggle({text = "Enabled", flag = "rage_enabled"}):AddBind({flag = "rage_key"})
								library.Rage:AddList({text = "Origin",  flag = "rage_origin", value = "Character", values = {"Character", "Camera"}})
								library.Rage:AddToggle({text = "Silent Aim", flag = "rage_silent"})
								library.Rage:AddToggle({text = "Automatic Fire", flag = "rage_fire"})
								library.Rage:AddSlider({text = "Penetration", flag = "rage_pen", value = 1, min = 1, max = 100})
								library.Rage:AddToggle({text = "Force Headshot", flag = "rage_head"})
								library.Rage:AddToggle({text = "Logs", flag = "rage_logs"})
								library.Rage:AddDivider("Settings")
								library.Rage:AddSlider({text = "Minimum Damage", flag = "rage_damage", value = 1, min = 1, max = 100})
								library.Rage:AddList({text = "Hitbox",  flag = "rage_hitbox", value = "Head", values = {"Head", "Torso", "Arms", "Legs"}})
								library.Rage:AddDivider("Extra")
								library.Rage:AddToggle({text = "Kill All", flag = "rage_kill"}):AddBind({flag = "rage_killkey"})]]

								for _,Hitbox in ipairs(Hitb) do
									local IG2 = {unpack(IG)}
									for _,Part in next, Character:GetChildren() do
										if Part ~= Hitbox then table.insert(IG2, Part) end
									end

									for i,v in next, Players:GetChildren() do 
										if v ~= Player and v.Character then
											for i,v2 in next, v.Character:GetChildren() do 
												table.insert(IG2, v2)
											end
										end 
									end

									if library.flags["rage_pen"] then
										local Hits = {}
										local EHit, Hit, Pos
										
										local Ray1 = Ray.new(Origin, (Hitbox.Position  - Origin).unit * (Hitbox.Position - Origin).magnitude)
										repeat
											Hit, Pos = workspace:FindPartOnRayWithIgnoreList(Ray1, IG2, false, true)
											if Hit ~= nil and Hit.Parent ~= nil then
												if Hit and Multipliers[Hit.Name] ~= nil then
													EHit = Hit
												else
													table.insert(IG2, Hit)
													table.insert(Hits, {["Position"] = Pos,["Hit"] = Hit})
												end
											end
										until EHit ~= nil or #Hits >= 4 or Hit == nil

										if EHit ~= nil and Multipliers[EHit.Name] ~= nil and #Hits <= 4 then
											if #Hits == 0 then
												local Damage = Client.gun.DMG.Value * Multipliers[EHit.Name]
												if Player:FindFirstChild("Kevlar") then
													if string.find(EHit.Name, "Head") then
														if Player:FindFirstChild("Helmet") then
															Damage = (Damage / 100) * Client.gun.ArmorPenetration.Value
														end
													else
														Damage = (Damage / 100) * Client.gun.ArmorPenetration.Value
													end
												end
												Damage = Damage * (Client.gun.RangeModifier.Value/100 ^ ((Origin - EHit.Position).Magnitude/500))/100
												if Damage >= library.flags["rage_damage"] then
													RTar = EHit
													if not library.flags["rage_silent"] then
														Camera.CFrame = CFrame.new(Camera.CFrame.Position, Hit.Position)
													end
													if library.flags["rage_fire"] then
														if library.flags["rage_dt"] and library.flags["rage_dtkey"] then
															Client.firebullet()
															local ARGS = {
																[1] = EHit,
																[2] = EHit.Position,
																[3] = LocalPlayer.Character.EquippedTool.Value,
																[4] = 100,
																[5] = LocalPlayer.Character.Gun,
																[8] = 1,
																[9] = false,
																[10] = false,
																[11] = Vector3.zero,
																[12] = 100,
																[13] = Vector3.zero
															}
															Remote:FireServer(unpack(ARGS))
														end

														if library.flags["rage_logs"] then
															createEventLog(string.format("hurt %s in the %s for %s with a %s", EHit.Parent.Name, EHit.Name, math.floor(Damage), Client.gun.Name), 3)
														end	
														Client.firebullet()
														local ARGS = {
															[1] = EHit,
															[2] = EHit.Position,
															[3] = LocalPlayer.Character.EquippedTool.Value,
															[4] = 100,
															[5] = LocalPlayer.Character.Gun,
															[8] = 1,
															[9] = false,
															[10] = false,
															[11] = Vector3.zero,
															[12] = 100,
															[13] = Vector3.zero
														}
														Remote:FireServer(unpack(ARGS))
													end
													FT = false
													break
												end
											else
												local penetration = Client.gun.Penetration.Value * (0.01 * library.flags["rage_penamt"])
												local limit = 0 
												local dmgmodifier = 1 
												for i = 1, #Hits do 
													local data = Hits[i] 
													local part = data["Hit"] 
													local pos = data["Position"] 
													local modifier = 1 
													if part.Material == Enum.Material.DiamondPlate then 
														modifier = 3 
													end 
													if part.Material == Enum.Material.CorrodedMetal or part.Material == Enum.Material.Metal or part.Material == Enum.Material.Concrete or part.Material == Enum.Material.Brick then 
														modifier = 2 
													end 
													if part.Name == "Grate" or part.Material == Enum.Material.Wood or part.Material == Enum.Material.WoodPlanks then 
														modifier = 0.1 
													end 
													if part.Name == "nowallbang" then 
														modifier = 100 
													end 
													if part:FindFirstChild("PartModifier") then 
														modifier = part.PartModifier.Value 
													end 
													if part.Transparency == 1 or part.CanCollide == false or part.Name == "Glass" or part.Name == "Cardboard" then 
														modifier = 0 
													end 
													local direction = (Hitbox.Position - pos).unit * math.clamp(Client.gun.Range.Value, 1, 100) 
													local ray = Ray.new(pos + direction * 1, direction * -2) 
													local _,endpos = workspace:FindPartOnRayWithWhitelist(ray, {part}, true) 
													local thickness = (endpos - pos).Magnitude 
													thickness = thickness * modifier 
													limit = math.min(penetration, limit + thickness) 
													dmgmodifier = 1 - limit / penetration 
												end 
												local Damage = Client.gun.DMG.Value * Multipliers[EHit.Name] * dmgmodifier 
												if Player:FindFirstChild("Kevlar") then 
													if string.find(EHit.Name, "Head") then 
														if Player:FindFirstChild("Helmet") then 
															Damage = (Damage / 100) * Client.gun.ArmorPenetration.Value 
														end 
													else 
														Damage = (Damage / 100) * Client.gun.ArmorPenetration.Value 
													end 
												end 
												Damage = Damage * (Client.gun.RangeModifier.Value/100 ^ ((Origin - EHit.Position).Magnitude/500))/100 
												if Damage >= library.flags["rage_damage"] then 
													RTar = EHit 
													FT = false
													if not library.flags["rage_silent"] then
														Camera.CFrame = CFrame.new(Camera.CFrame.Position, Hit.Position)
													end
													if library.flags["rage_fire"] then
														if library.flags["rage_dt"] and library.flags["rage_dtkey"] then
															Client.firebullet()
															local ARGS = {
																[1] = EHit,
																[2] = EHit.Position,
																[3] = LocalPlayer.Character.EquippedTool.Value,
																[4] = 100,
																[5] = LocalPlayer.Character.Gun,
																[8] = 1,
																[9] = false,
																[10] = false,
																[11] = Vector3.zero,
																[12] = 100,
																[13] = Vector3.zero
															}
															Remote:FireServer(unpack(ARGS))
														end
														
														if library.flags["rage_logs"] then
															createEventLog(string.format("hurt %s in the %s for %s with a %s", EHit.Parent.Name, EHit.Name, math.floor(Damage), Client.gun.Name), 3)
														end

														Client.firebullet()
														local ARGS = {
															[1] = EHit,
															[2] = EHit.Position,
															[3] = LocalPlayer.Character.EquippedTool.Value,
															[4] = 100,
															[5] = LocalPlayer.Character.Gun,
															[8] = 1,
															[9] = false,
															[10] = false,
															[11] = Vector3.zero,
															[12] = 100,
															[13] = Vector3.zero
														}
														Remote:FireServer(unpack(ARGS)) 
													end
													FT = false
													break 
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end

			-- Anti-Aim
			if library.flags["anti_enabled"] then
				LocalPlayer.Character.Humanoid.AutoRotate = false 
				Pitch = library.flags["anti_pitch"] == "Up" and 1 or library.flags["anti_pitch"] == "Down" and -1 or library.flags["anti_pitch"] == "Zero" and 0 or library.flags["anti_pitch"] == "Random" and math.random(-1, 1) or 0
				smath = math.clamp(smath + library.flags["anti_spinamt"], 0, 360)
				if smath == 360 then smath = 0 end
				
				--library.AntiAim:AddToggle({text = "Manual Anti-Aim", flag = "anti_man"})
				--library.AntiAim:AddToggle({text = "Anti-Aim Arrows", flag = "anti_arrow"})

				
				if library.flags["anti_man"] then
					for i,v in pairs(arrowsaa) do
						v.Visible = library.flags["anti_arrow"] 
					end

					if arrows.left then	
						if library.flags["anti_arrow"] then
							arrowsaa.left.Transparency = 1
							arrowsaa.left.Color = library.flags["anticol"]
							
							arrowsaa.right.Transparency = 0.2
							arrowsaa.right.Color = C3(0, 0, 0)
							arrowsaa.bottom.Transparency = 0.2
							arrowsaa.bottom.Color = C3(0, 0, 0)
						end
						AntiAngle = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X)
					elseif arrows.right then
						if library.flags["anti_arrow"] then
							arrowsaa.right.Transparency = 1
							arrowsaa.right.Color = library.flags["anticol"]

							arrowsaa.left.Transparency = 0.2
							arrowsaa.left.Color = C3(0, 0, 0)
							arrowsaa.bottom.Transparency = 0.2
							arrowsaa.bottom.Color = C3(0, 0, 0)
						end
						AntiAngle = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X) + math.rad(180)
					elseif arrows.orig then
						if library.flags["anti_arrow"] then
							arrowsaa.bottom.Transparency = 1
							arrowsaa.bottom.Color = library.flags["anticol"]

							arrowsaa.left.Transparency = 0.2
							arrowsaa.left.Color = C3(0, 0, 0)
							arrowsaa.right.Transparency = 0.2
							arrowsaa.right.Color = C3(0, 0, 0)
						end
						if library.flags["anti_yaw"] == "Backward" then
							AntiAngle = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X) - math.rad(-90)
						elseif library.flags["anti_yaw"] == "Forward" then 
							AntiAngle = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X) + math.rad(-90) 
						elseif library.flags["anti_yaw"] == "Random" then 
							AntiAngle = AntiAngle + math.rad(math.random(-360, 360)) 
						elseif library.flags["anti_yaw"] == "Spin" then 
							AntiAngle = AntiAngle + math.rad(smath) 
						end 		
					end
				else
					for i,v in pairs(arrowsaa) do
						v.Visible = false
					end
					if library.flags["anti_yaw"] == "Backward" then
						AntiAngle = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X) - math.rad(-90)
					elseif library.flags["anti_yaw"] == "Forward" then 
						AntiAngle = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X) + math.rad(-90) 
					elseif library.flags["anti_yaw"] == "Random" then 
						AntiAngle = AntiAngle + math.rad(math.random(-360, 360)) 
					elseif library.flags["anti_yaw"] == "Spin" then 
						AntiAngle = AntiAngle + math.rad(smath) 
					end 		
				end	
				
				game.ReplicatedStorage.Events.ControlTurn:FireServer(Pitch, LocalPlayer.Character:FindFirstChild("Climbing") and true or false) 
				local CPos = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) * CFrame.Angles(0, AntiAngle, 0) 

				LocalPlayer.Character.HumanoidRootPart.CFrame = YROTATION(CPos) 
			else
				LocalPlayer.Character.Humanoid.AutoRotate = true
				game.ReplicatedStorage.Events.ControlTurn:FireServer(Camera.CFrame.LookVector.Y, false) 
			end
		end

		if library.flags["aimbot_enabled"] then
			local organizedPlayers = {}
			local fov = library.flags["aimbot_fov"]

			for i, v in ipairs(Players:GetPlayers()) do
				if v == LocalPlayer then continue end

				if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") then
					local Humanoid = v.Character:FindFirstChild("Humanoid")
					local RootPart = v.Character:FindFirstChild("HumanoidRootPart")

					local Head = v.Character:FindFirstChild("Head")
					local Pos = Camera:WorldToViewportPoint(RootPart.Position)
					if Head then
						Pos = Camera:WorldToViewportPoint(Head.Position)
					else
						Pos = Camera:WorldToViewportPoint(RootPart.Position)
					end
					if fov ~= 0 then
						if find_2d_distance(Pos, mousePos) > fov then
							continue
						end
					end

					if library.flags["aimbot_team"] and v.Team and v.Team == LocalPlayer.Team then continue end

					if library.flags["aimbot_distance"] and LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5 > library.flags["aimbot_distanceamt"] then continue end

					if library.flags["aimbot_vis"] then
						local Dir = RootPart.Position - Camera.CFrame.Position
						local Res = workspace:Raycast(Camera.CFrame.Position, Dir.Unit * Dir.Magnitude, RPar)
			
						if not Res then continue end
						local Hit = Res.Instance
			
						if not Hit:FindFirstAncestor(v.Name) then continue end

						table.insert(organizedPlayers, v)
					else
						table.insert(organizedPlayers, v)
					end
				end
			end

			table.sort(organizedPlayers, function(a, b)
				local aPos, aVis = Camera:WorldToViewportPoint(a.Character.Head.Position)
				local bPos, bVis = Camera:WorldToViewportPoint(b.Character.Head.Position)
				if aVis and not bVis then
					return true
				end
				if bVis and not aVis then
					return false
				end

				return (aPos - mousePos).Magnitude < (bPos - mousePos).Magnitude
			end)
			
			for i, v in ipairs(organizedPlayers) do
				local Hitbox = nil
				if library.flags["aimbot_hit"] == "Head" then
					Hitbox = v.Character:FindFirstChild("Head")
				elseif library.flags["aimbot_hit"] == "Torso" then
					Hitbox = v.Character:FindFirstChild("Torso")
					if Hitbox == nil then
						Hitbox = v.Character:FindFirstChild("UpperTorso")
					end
				end

				if Hitbox then
					local Pos, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)
					if OnScreen then
						if library.flags["aimbot_key"] then
							local inc = V2(Pos.X - UserInputService:GetMouseLocation().x, Pos.Y - UserInputService:GetMouseLocation().y)
							mousemoverel(inc.X / (library.flags["aimbot_smooth"] + 3), inc.Y / (library.flags["aimbot_smooth"] + 3))
							return
						end
					end
				end
			end
		end
	end 

	local mt = getrawmetatable(game) 
	local oldNamecall = mt.__namecall 
	local oldIndex = mt.__index 
	local oldNewIndex = mt.__newindex 
	setreadonly(mt,false) 
	mt.__namecall = function(self, ...)
		local method = tostring(getnamecallmethod())
		local args = {...} 

		if method == "SetPrimaryPartCFrame" and self.Name == "Arms" then  
			if library.flags["thirdperson"] and library.flags["thirdekey"] then 
				args[1] *= CFrame.new(99, 99, 99)
			else 
				if library.flags["viewmodel"] then 
					args[1] = args[1] * Viewmodel 
				end 	

				if library.flags["silenta"] and vangle then
					args[1] = CFrame.lookAt(args[1].p, vangle)
				else
					if library.flags["viewmodel"] then 
						args[1] = args[1] * Viewmodel 
					end 
				end 
			end 
		end

		if method == "FireServer" and self.Name == "HitPart" then 
			if library.flags["rage_pred"] and RTar ~= nil then
				-- Stolen pred from J's dms. <3
				coroutine.wrap(function()
					if Players:GetPlayerFromCharacter(args[1].Parent) or args[1] == RTar then 
						local RootPart = RTar.Parent.HumanoidRootPart.Position
						local OldRootPart = RTar.Parent.HumanoidRootPart.Velocity
						local Velocity = (V3(RootPart.X, 0, RootPart.Z) - Vec3(OldRootPart.X, 0, OldRootPart.Z)) / LastStep
						local Direction = V3(Velocity.X / Velocity.magnitude, 0, Velocity.Z / Velocity.magnitude)
						args[2] = args[2] + Direction * (Ping / (math.pow(Ping, (1.5))) * (Direction / (Direction / 2)))
						args[12]= args[12] - 500	
					end
				end)()
			end
		end

		if method == "FireServer" then 
			if self.Name == "FallDamage" and library.flags["Movement_DMG"] then return end
			for i,v in next, library.flags["tweaks"] do
				if not v then continue end
		
				if i == "No Fire Damage" then
					if self.Name == "BURNME" then return end
				end
			end
			if self.Name == "ControlTurn" and not checkcaller() then 
				return 
			end 
		end

		if method == "FindPartOnRayWithWhitelist" and not checkcaller() and Client.gun ~= "none" and Client.gun.Name ~= "C4" then 
			if #args[2] == 1 and args[2][1].Name == "SpawnPoints" then 
				local Team = LocalPlayer.Status.Team.Value 

				for i,v in next, library.flags["tweaks"] do
					if not v then continue end
			
					if i == "Shop Anywhere" then
						return Team == "T" and args[2][1].BuyArea or args[2][1].BuyArea2 
					end
				end
			end 
		end

		if method == "FireServer" and self.Name == "HitPart" then 
			if library.flags["rage_head"] and RTar ~= nil then 
				print("LOL")
				args[1] = RTar.Parent.Head
				args[2] = RTar.Position 
			end 
		end

		if method == "FindPartOnRayWithIgnoreList" and args[2][1] == workspace.Debris then 
			if not checkcaller() or FT then 
				if library.flags["r_spread"] then
					args[1] = Ray.new(Camera.CFrame.p, Camera.CFrame.LookVector * Client.gun.Range.Value) 
				end

				coroutine.wrap(function() 
					local mousePos = V3(UserInputService:GetMouseLocation().x, UserInputService:GetMouseLocation().y, 0)
					if library.flags["silent_enabled"] then
						local organizedPlayers = {}
						local fov = library.flags["silent_fov"]
				
						for i, v in ipairs(Players:GetPlayers()) do
							if v == LocalPlayer then continue end
				
							if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") then
								local Humanoid = v.Character:FindFirstChild("Humanoid")
								local RootPart = v.Character:FindFirstChild("HumanoidRootPart")
				
								local Head = v.Character:FindFirstChild("Head")
								local Pos = Camera:WorldToViewportPoint(RootPart.Position)
								if Head then
									Pos = Camera:WorldToViewportPoint(Head.Position)
								else
									Pos = Camera:WorldToViewportPoint(RootPart.Position)
								end
								if fov ~= 0 then
									if find_2d_distance(Pos, mousePos) > fov then
										continue
									end
								end
				
								if library.flags["silent_team"] and v.Team and v.Team == LocalPlayer.Team then continue end
				
								if library.flags["silent_distance"] and LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5 > library.flags["aimbot_distanceamt"] then continue end
				
								if library.flags["silent_vis"] then
									local Dir = RootPart.Position - Camera.CFrame.Position
									local Res = workspace:Raycast(Camera.CFrame.Position, Dir.Unit * Dir.Magnitude, RPar)
						
									if not Res then continue end
									local Hit = Res.Instance
						
									if not Hit:FindFirstAncestor(v.Name) then continue end
				
									table.insert(organizedPlayers, v)
								else
									table.insert(organizedPlayers, v)
								end
							end
						end
				
						table.sort(organizedPlayers, function(a, b)
							local aPos, aVis = Camera:WorldToViewportPoint(a.Character.Head.Position)
							local bPos, bVis = Camera:WorldToViewportPoint(b.Character.Head.Position)
							if aVis and not bVis then
								return true
							end
							if bVis and not aVis then
								return false
							end
				
							return (aPos - mousePos).Magnitude < (bPos - mousePos).Magnitude
						end)
						
						for i, v in ipairs(organizedPlayers) do
							local Hitbox = nil
							if library.flags["silent_hit"] == "Head" then
								Hitbox = v.Character:FindFirstChild("Head")
							elseif library.flags["silent_hit"] == "Torso" then
								Hitbox = v.Character:FindFirstChild("Torso")
								if Hitbox == nil then
									Hitbox = v.Character:FindFirstChild("UpperTorso")
								end
							end
				
							local Hit = math.random(1, 100) <= library.flags["silent_hitc"]

							if Hitbox and Hit then
								local Pos, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)
								if OnScreen then
									if library.flags["silent_key"] then
										args[1] = Ray.new(Camera.CFrame.Position, (Hitbox.Position - Camera.CFrame.Position).unit * (Hitbox.Position - Camera.CFrame.Position).magnitude) 
									end
								end
							end
						end
					end
				end)()
			end
		end

		if method == "LoadAnimation" and self.Name == "Humanoid" then 
			if library.flags["anti_slide"] then
				if string.find(args[1].Name, "Run") or string.find(args[1].Name, "Jump") then
					args[1] = FAn
				end
			end
		end

		return oldNamecall(self, unpack(args)) 
	end 
	mt.__index = newcclosure(function(self, key)
		local CallingScript = getcallingscript()

		if key == "Value" then
			for i,v in next, library.flags["tweaks"] do
				if not v then continue end

				if i == "Instant Reload" and self.Name == "ReloadTime" then
					return 0.001
				end
				if i == "Infinite Buy Time" and self.Name == "BuyTime" then
					return 5
				end
			end
		end
		return oldIndex(self, key)
	end)
	--[[mt.__newindex = function(self, i, v) 
		if self:IsA("Humanoid") and i == "JumpPower" and not checkcaller() then 
			if library.flags["Movement_JumpBug"] and library.flags["Movement_JumpKey"] then
				v = 38
			end 
			if library.flags["Movement_EdgeBug"] and library.flags["Movement_EdgeKey"] then 
				v = 0 
			end
		end
	
		return oldNewIndex(self, i, v) 
	end]]
	Camera.ChildAdded:Connect(function(part) 
		for i,v in next, library.flags["tweaks"] do
			if not v then continue end

			if i == "Infinite Ammo" then
				Client.ammocount = 9000000
				Client.ammocount2 = 9000000
			end
		end

		if isAlive(LocalPlayer) then
			if not part.Name ~= "Arms" then
				local Model 
				for i,v in pairs(part:GetChildren()) do 
					if v:IsA("Model") and (v:FindFirstChild("Right Arm") or v:FindFirstChild("Left Arm")) then 
						Model = v 
					end 
				end 

				if Model == nil then 
					return 
				end 
				
				for i,v in pairs(part:GetChildren()) do 
					if (v:IsA("BasePart") or v:IsA("Part")) and v.Transparency ~= 1 and v.Name ~= "Flash" then 
						local va = true 
						if v:IsA("Part") and v:FindFirstChild("Mesh") and not v:IsA("BlockMesh") then 
							va = false 
							local sa = pcall(function() 
								local OriginalTexture = INST("StringValue") 
								OriginalTexture.Value = v.Mesh.TextureId 
								OriginalTexture.Name = "OriginalTexture" 
								OriginalTexture.Parent = v.Mesh 
							end) 
							if sa then 
								va = true 
							end 
						end 

						for a,l in pairs(v:GetChildren()) do 
							if l:IsA("BasePart") or l:IsA("Part") then 
								table.insert(WeaponT, l) 
							end 
						end 

						if va then 
							table.insert(WeaponT, v) 
						end 
					end 
				end

				RightArm = Model:FindFirstChild("Right Arm") 
				LeftArm = Model:FindFirstChild("Left Arm") 
				if RightArm then 
					RightGlove = RightArm:FindFirstChild("Glove") or RightArm:FindFirstChild("RightGlove") 		
					RightSleeve = RightArm:FindFirstChild("Sleeve") 

					if library.flags["Local_Arm"] then
						RightArm.Color = library.flags["LocalC_Arm"]
						RightArm.Transparency = esp.HandChams 
					end 

					local GloveTexture = INST("StringValue") 
					GloveTexture.Value = RightGlove.Mesh.TextureId 
					GloveTexture.Name = "StringValue" 
					GloveTexture.Parent = RightGlove 

					if library.flags["Local_Arm"] then
						RenderChams2(RightGlove, library.flags["LocalC_Arm"], esp.HandChams, library.flags["Local_ArmR"], library.flags["Local_ArmM"])
					end 

					if RightSleeve ~= nil then 
						local SleeveTexture = INST("StringValue") 
						SleeveTexture.Value = RightSleeve.Mesh.TextureId 
						SleeveTexture.Name = "StringValue" 
						SleeveTexture.Parent = RightSleeve 

						if library.flags["Local_Arm"] then
							RenderChams2(RightSleeve, library.flags["LocalC_Arm"], esp.HandChams, library.flags["Local_ArmR"], library.flags["Local_ArmM"]) 
						end 
					end 
				end 
				if LeftArm then 
					LeftGlove = LeftArm:FindFirstChild("Glove") or LeftArm:FindFirstChild("LeftGlove") 
					LeftSleeve = LeftArm:FindFirstChild("Sleeve") 

					if library.flags["Local_Arm"] then
						LeftArm.Color = library.flags["LocalC_Arm"]
						LeftArm.Transparency = esp.HandChams 
					end 

					local GloveTexture = INST("StringValue") 
					GloveTexture.Value = LeftGlove.Mesh.TextureId 
					GloveTexture.Name = "StringValue" 
					GloveTexture.Parent = LeftGlove 

					if library.flags["Local_Arm"] then
						RenderChams2(LeftGlove, library.flags["LocalC_Arm"], esp.HandChams, library.flags["Local_ArmR"], library.flags["Local_ArmM"]) 
					end 

					if LeftSleeve ~= nil then 
						local SleeveTexture = INST("StringValue") 
						SleeveTexture.Value = LeftSleeve.Mesh.TextureId 
						SleeveTexture.Name = "StringValue" 
						SleeveTexture.Parent = LeftSleeve 
			
						if library.flags["Local_Arm"] then 
							RenderChams2(LeftSleeve, library.flags["LocalC_Arm"], esp.HandChams, library.flags["Local_ArmR"], library.flags["Local_ArmM"])
						end 
					end 
				end 
			end
		end
	end)
	--!SECTION

	--SECTION Visuals
	Additionals.TotalDamage:GetPropertyChangedSignal("Value"):Connect(function(val) 
		if val == 0 then return end

		if library.flags["hitsound"] then
			local Sound = INST("Sound") 
			Sound.Parent = gs("SoundService") 
			Sound.PlayOnRemove = true 
			Sound.SoundId = library.flags["hits"] == "Neverlose" and "rbxassetid://8679627751" or library.flags["hits"] == "Skeet" and "rbxassetid://5447626464" or library.flags["hits"] == "Rust" and "rbxassetid://5043539486" or library.flags["hits"] == "Baimware" and "rbxassetid://6607339542" or library.flags["hits"] == "Oni-Chan" and "rbxassetid://130822574" or library.flags["hits"] == "Rifk7" and "rbxassetid://9102080552"
			Sound.Volume = library.flags["hitv"] / 10
			Sound:Destroy() 
		end
	end)
	LocalPlayer.PlayerGui.GUI.Crosshairs.Crosshair:GetPropertyChangedSignal("Visible"):Connect(function(current) 
		if isAlive(LocalPlayer) and library.flags["Local_Force"] and not LocalPlayer.Character:FindFirstChild("AIMING") then 
			LocalPlayer.PlayerGui.GUI.Crosshairs.Crosshair.Visible = true 
		end
	end)
	local function Visuals()
		ColorCorrection.Saturation = 0
		ColorCorrection.Contrast = 0
		Camera = workspace.CurrentCamera
		Viewmodel = CFrame.new(library.flags["viewx"] / 7, library.flags["viewy"] / 7, library.flags["viewz"] / 7) * CFrame.Angles(0, 0,  library.flags["viewr"] / 50) 

		if library.flags["thirdperson"] and library.flags["thirdekey"] then
			if LocalPlayer.CameraMinZoomDistance ~= library.flags["thirdamt"] and LocalPlayer.CameraMaxZoomDistance ~= library.flags["thirdamt"] then
				LocalPlayer.CameraMaxZoomDistance = library.flags["thirdamt"]
				LocalPlayer.CameraMinZoomDistance = library.flags["thirdamt"]
			end
		else
			if LocalPlayer.CameraMinZoomDistance ~= 0 and LocalPlayer.CameraMaxZoomDistance ~= 0 then
				LocalPlayer.CameraMaxZoomDistance = 0
				LocalPlayer.CameraMinZoomDistance = 0
			end
		end

		if isAlive(LocalPlayer) then
			if library.flags["Local_Arm"] then
				if RightArm ~= nil then
					if RightGlove ~= nil then
						RenderChams2(RightGlove, library.flags["LocalC_Arm"], esp.HandChams, library.flags["Local_ArmR"], library.flags["Local_ArmM"])
					end
					if RightSleeve ~= nil then
						RenderChams2(RightSleeve, library.flags["LocalC_Arm"], esp.HandChams, library.flags["Local_ArmR"], library.flags["Local_ArmM"]) 
					end
					RightArm.Color = library.flags["LocalC_Arm"]
					RightArm.Transparency = esp.HandChams
				end
				if LeftArm ~= nil then
					if LeftGlove ~= nil then
						RenderChams2(LeftGlove, library.flags["LocalC_Arm"], esp.HandChams, library.flags["Local_ArmR"], library.flags["Local_ArmM"]) 
					end
					if LeftSleeve ~= nil then
						RenderChams2(LeftSleeve, library.flags["LocalC_Arm"], esp.HandChams, library.flags["Local_ArmR"], library.flags["Local_ArmM"])
					end
					LeftArm.Color = library.flags["LocalC_Arm"]
					LeftArm.Transparency = esp.HandChams 
				end
			end
		
			if library.flags["Local_Gun"] then
				for i,v in pairs(WeaponT) do 
					RenderChams(v, library.flags["LocalC_Gun"], esp.WeaponChams, library.flags["Local_GunR"], library.flags["Local_GunM"])
				end
			end

			if library.flags["rems"] then
				for i,v in pairs(NewScope) do
					if LocalPlayer.Character:FindFirstChild("AIMING") then
						v.Visible = true
					else
						v.Visible = false
					end
				end
				for i,v in pairs(LocalPlayer.PlayerGui.GUI.Crosshairs:GetChildren()) do
					if v.Name == "Frame1" or v.Name == "Frame2" or v.Name == "Frame3" or v.Name == "Frame4" or v.Name == "Scope" then
						v.Visible = false
					end
				end
			else
				for i,v in pairs(NewScope) do
					v.Visible = false
				end
			end
		end

		local MousePosition = V2(UserInputService:GetMouseLocation().x, UserInputService:GetMouseLocation().y)

		fovcircle.F4.Visible = library.flags["FOVS_Enabled"]
		fovcircle.F4.Radius = library.flags["silent_fov"]
		fovcircle.F4.Transparency = esp.F4    
		fovcircle.F4.Filled = false
		fovcircle.F4.Position = MousePosition
		fovcircle.F4.NumSides = library.flags["FOVN"]
		fovcircle.F4.Thickness = library.flags["FOVT"] + 3
		fovcircle.F4.Color = library.flags["FOVSCO"]

		fovcircle.F3.Visible = library.flags["FOVS_Enabled"]
		fovcircle.F3.Radius = library.flags["silent_fov"]
		fovcircle.F3.Transparency = esp.F3
		fovcircle.F3.Filled = library.flags["FOV_Filled"]
		fovcircle.F3.Position = MousePosition
		fovcircle.F3.NumSides = library.flags["FOVN"]
		fovcircle.F3.Thickness = library.flags["FOVT"]
		fovcircle.F3.Color = library.flags["FOVSC"]

		fovcircle.F2.Visible = library.flags["FOV_Enabled"]
		fovcircle.F2.Radius = library.flags["aimbot_fov"]
		fovcircle.F2.Transparency = esp.F2
		fovcircle.F2.Filled = false
		fovcircle.F2.Position = MousePosition
		fovcircle.F2.NumSides = library.flags["FOVN"]
		fovcircle.F2.Thickness = library.flags["FOVT"] + 3
		fovcircle.F2.Color = library.flags["FOVCO"]

		fovcircle.F1.Visible = library.flags["FOV_Enabled"]
		fovcircle.F1.Radius = library.flags["aimbot_fov"]
		fovcircle.F1.Transparency = esp.F1
		fovcircle.F1.Filled = library.flags["FOV_Filled"]
		fovcircle.F1.Position = MousePosition
		fovcircle.F1.NumSides = library.flags["FOVN"]
		fovcircle.F1.Thickness = library.flags["FOVT"]
		fovcircle.F1.Color = library.flags["FOVC"]

		if library.flags["World_Ambient"] then
			Lighting.OutdoorAmbient = library.flags["WorldC_OutC"]
			Lighting.Ambient = library.flags["WorldC_C"]
		end

		if library.flags["World_Contrast"] then
			ColorCorrection.Contrast = library.flags["World_CAmt"]
		end

		if library.flags["World_Saturation"] then
			ColorCorrection.Saturation = library.flags["World_SAmt"]
		end

		if library.flags["World_Fog"] then
			Lighting.FogStart = library.flags["World_FogS"]
			Lighting.FogEnd = library.flags["World_FogE"]
			Lighting.FogColor = library.flags["World_FogC"]
		end

		if library.flags["Local_Fov"] then
			Camera.FieldOfView = library.flags["Local_FAmt"]
		end

		if library.flags["World_Time"] then
			Lighting.TimeOfDay = library.flags["World_TAmt"]
		end

		for _,Player in pairs (Players:GetPlayers()) do
			if library.flags["ESP_Enabled"] and PLRDS[Player] and isTarget(Player, library.flags["ESP_Team"]) then
				local PLRD = PLRDS[Player]
				for _,v in pairs (PLRD) do
					v.Visible = false
				end

				local Character = Player.Character
				local RootPart, Humanoid = Character and Character:FindFirstChild("HumanoidRootPart"), Character and Character:FindFirstChildOfClass("Humanoid")
				if Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then
					if Humanoid then
						if Humanoid.Health <= 0 then
							continue
						end
					end
				end

				local Head = Player.Character:FindFirstChild("Head")
				local poser = Camera:WorldToViewportPoint(Head.Position)
				local mousePos = V2(UserInputService:GetMouseLocation().x, UserInputService:GetMouseLocation().y, 0)
				local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
				local DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. "m"
				local alivecheck = true
				
				if Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then
					if Humanoid then
						if game.PlaceId == 4991214437 then
							if alivecheck and Humanoid.Health <= 1 then
								continue
							end
						else
							if alivecheck and Humanoid.Health <= 0 then
								continue
							end
						end
					end
				end
				if library.flags["ESP_TMode"] == "Normal" then
					DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. "m"
				elseif library.flags["ESP_TMode"] == "lowercase" then
					DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. string.lower("m")
				elseif library.flags["ESP_TMode"] == "UPPERCASE" then
					DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. string.upper("m")
				end
				local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
				
				if library.flags["ESP_Chams"] and isTarget(Player, library.flags["ESP_Team"]) then
					if Player.Character:FindFirstChildWhichIsA("Highlight") == nil then
						local highlight = Instance.new("Highlight", Player.Character)
					end
					Player.Character.Highlight.FillColor = library.flags["ESPC_ChamsF"]
					Player.Character.Highlight.OutlineTransparency = esp.ChamsO
					Player.Character.Highlight.FillTransparency = esp.ChamsF
					Player.Character.Highlight.OutlineColor = library.flags["ESPC_ChamsO"]
				else
					if Player.Character:FindFirstChildWhichIsA("Highlight") then
						Player.Character:FindFirstChildWhichIsA("Highlight"):Destroy()
					end
				end
				if not OnScreen then
					local niggars = Character.PrimaryPart
					local proj = Camera.CFrame:PointToObjectSpace(RootPart.Position)
					local ang = math.atan2(proj.Z, proj.X)
					local dir = Vector2.new(math.cos(ang), math.sin(ang))
					local pos = (dir * library.flags["ESP_OD"] * .5) + Camera.ViewportSize / 2
					local Drawing = PLRD.Offscreen

					
					if library.flags["ESP_OOF"] then
						Drawing.PointA = pos
						Drawing.PointB = pos - rotateVector2(dir, math.rad(35)) * library.flags["ESP_OS"]
						Drawing.PointC = pos - rotateVector2(dir, -math.rad(35)) * library.flags["ESP_OS"]
						Drawing.Color = library.flags["ESPC_OOF"]
						Drawing.Filled = true
						Drawing.Transparency = 1
						Drawing.Visible = true
					end
				else    
					local IhateMyLifeSize = (Camera:WorldToViewportPoint(RootPart.Position - V3(0, 3, 0)).Y - Camera:WorldToViewportPoint(RootPart.Position + V3(0, 2.6, 0)).Y) / 2
					local BoxSize = Vector2.new(math.floor(IhateMyLifeSize * 1.2), math.floor(IhateMyLifeSize * 2))
					local BoxPos = Vector2.new(math.floor(Pos.X - IhateMyLifeSize * 1 / 2), math.floor(Pos.Y - IhateMyLifeSize * 1.6 / 2))
					local HeadPos = Head.Position
					local HeadPosA = workspace.CurrentCamera:WorldToViewportPoint(V3(HeadPos.x, HeadPos.y + 0.1, HeadPos.z))
					local HeadPosAB = workspace.CurrentCamera:WorldToViewportPoint(V3(HeadPos.x, HeadPos.y - 0.2, HeadPos.z))
					local Dif = HeadPosAB.y - HeadPosA.y
					local Name = PLRD.Name
					local Distance = PLRD.Distance
					local Box = PLRD.Box
					local Tracers = PLRD.Tracers
					local HeadDot = PLRD.HeadDot
					local BoxOutline = PLRD.BoxOutline
					local Health = PLRD.Health
					local HealthOutline = PLRD.HealthOutline
					local HealthNumber = PLRD.HealthNumber
					local HealthNumberB = PLRD.HealthNumberB
					local BoxFill = PLRD.BoxFill   
					--local FovTracer = PLRD.FovTracers 
					local Tool = PLRD.Tool 
					local DistanceB = PLRD.DistanceB
					local NameB = PLRD.NameB
					local ToolB = PLRD.ToolB
					local Health2 = PLRD.Health2
					local HealthOutline2 = PLRD.HealthOutline2
					local Y_off = BoxSize.Y + BoxPos.Y + 1
					
					local ptool = Player.Character.EquippedTool.Value 

					if library.flags["ESP_Tool"] then
						if ptool ~= nil then
							if library.flags["ESP_TMode"] == "Normal" then
								Tool.Text = ptool
							elseif library.flags["ESP_TMode"] == "lowercase" then
								Tool.Text = string.lower(ptool)
							elseif library.flags["ESP_TMode"] == "UPPERCASE" then
								Tool.Text = string.upper(ptool)
							end
							Tool.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, Y_off)
							Tool.Color = library.flags["ESPC_Tool"]
							Tool.Font = Drawing.Fonts[library.flags["ESP_Font"]]
							Tool.Size = library.flags["ESP_Size"]
							Tool.Visible = true
							Tool.Outline = library.flags["ESP_Out"]
							if library.flags["ESP_Bold"] then
								if library.flags["ESP_TMode"] == "Normal" then
									ToolB.Text = ptool
								elseif library.flags["ESP_TMode"] == "lowercase" then
									ToolB.Text = string.lower(ptool)
								elseif library.flags["ESP_TMode"] == "UPPERCASE" then
									ToolB.Text = string.upper(ptool)
								end
								ToolB.Position = Vector2.new(BoxSize.X/2 + BoxPos.X + 1, Y_off)
								ToolB.Color = library.flags["ESPC_Tool"]
								ToolB.Font = Drawing.Fonts[library.flags["ESP_Font"]]
								ToolB.Size = library.flags["ESP_Size"]
								ToolB.Visible = true
								ToolB.Outline = false
							end
							Y_off += 15
						end
					end

					if library.flags["ESP_Box"] then
						Box.Size = BoxSize
						Box.Position = BoxPos
						Box.Visible = true
						--[[if library.flags.tt and tname == "["..Player.DisplayName.."]" then
							Box.Color = library.flags.tcol
						else]]
							Box.Color = library.flags["ESPC_Box"]
						--end

						if library.flags["ESP_Out"] then
							BoxOutline.Size = BoxSize
							BoxOutline.Position = BoxPos
							BoxOutline.Visible = true
						end
						
						BoxFill.Filled = true
						BoxFill.Visible = true
						BoxFill.Size = Vector2.new(math.floor(IhateMyLifeSize * 1.2 - 2), math.floor(IhateMyLifeSize * 2 - 2))
						BoxFill.Position = Vector2.new(math.floor(Pos.X - IhateMyLifeSize * 1 / 2 + 1), math.floor(Pos.Y - IhateMyLifeSize * 1.6 / 2 + 1))
						BoxFill.Color = library.flags["ESPC_BoxF"]
						BoxFill.Transparency = esp.BoxFill
					end

					if library.flags["ESP_Name"] then
						if library.flags["ESP_TMode"] == "Normal" then
							Name.Text = Player.DisplayName
						elseif library.flags["ESP_TMode"] == "lowercase" then
							Name.Text = string.lower(Player.DisplayName)
						elseif library.flags["ESP_TMode"] == "UPPERCASE" then
							Name.Text = string.upper(Player.DisplayName)
						end
						Name.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X, BoxPos.Y - 5 - Name.TextBounds.Y)
						Name.Color = library.flags["ESPC_Name"]
						Name.Font = Drawing.Fonts[library.flags["ESP_Font"]]
						Name.Size = library.flags["ESP_Size"]
						Name.Visible = true
						Name.Outline = library.flags["ESP_Out"]
						if library.flags["ESP_Bold"] then
							if library.flags["ESP_TMode"] == "Normal" then
								NameB.Text = Player.DisplayName
							elseif library.flags["ESP_TMode"] == "lowercase" then
								NameB.Text = string.lower(Player.DisplayName)
							elseif library.flags["ESP_TMode"] == "UPPERCASE" then
								NameB.Text = string.upper(Player.DisplayName)
							end
							NameB.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X + 1, BoxPos.Y - 5 - Name.TextBounds.Y)
							NameB.Color = library.flags["ESPC_Name"]
							NameB.Font = Drawing.Fonts[library.flags["ESP_Font"]]
							NameB.Size = library.flags["ESP_Size"]
							NameB.Visible = true
							NameB.Outline = false
						end
					end

					if library.flags["ESP_HealthB"] then  
						Health.From = Vector2.new((BoxPos.X - 5), BoxPos.Y + BoxSize.Y)
						Health.To = Vector2.new((BoxPos.X - 5), Health.From.Y - (Humanoid.Health / Humanoid.MaxHealth) * BoxSize.Y)
						Health.Color = library.flags["ESPC_HealthB"] 
						Health.Visible = true

						Health2.From = Vector2.new((BoxPos.X - 6), BoxPos.Y + BoxSize.Y)
						Health2.To = Vector2.new((BoxPos.X - 6), Health.From.Y - (Humanoid.Health / Humanoid.MaxHealth) * BoxSize.Y)
						Health2.Color = library.flags["ESPC_HealthB"]
						Health2.Visible = true

						if library.flags["ESP_Out"] then
							HealthOutline.From = Vector2.new(Health.From.X, BoxPos.Y + BoxSize.Y + 1)
							HealthOutline.To = Vector2.new(Health.From.X, (Health.From.Y - 1 * BoxSize.Y) -1)
							HealthOutline.Visible = true

							HealthOutline2.From = Vector2.new(Health.From.X - 2, BoxPos.Y + BoxSize.Y + 1)
							HealthOutline2.To = Vector2.new(Health.From.X - 2, (Health.From.Y - 1 * BoxSize.Y) -1)
							HealthOutline2.Visible = true
							HealthOutline2.Thickness = 1
							HealthOutline2.Color = Color3.new(0, 0, 0)
						end
					end

					if library.flags["ESP_HNum"] and math.floor(Humanoid.Health) <= library.flags["ESP_HP"] then
						HealthNumber.Text = tostring(math.round(Humanoid.Health))
						if library.flags["ESP_HealthB"] then
							HealthNumber.Position = Vector2.new(BoxPos.X - 3 - HealthNumber.TextBounds.X, BoxPos.Y - 2)
						else
							HealthNumber.Position = Vector2.new(BoxPos.X - 3 - (HealthNumber.TextBounds.X / 2) - 4, BoxPos.Y - 2)
						end
						HealthNumber.Color = library.flags["ESPC_HNum"]
						HealthNumber.Font = Drawing.Fonts[library.flags["ESP_Font"]]
						HealthNumber.Size = library.flags["ESP_Size"]
						HealthNumber.Visible = true
						HealthNumber.Outline = library.flags["ESP_Out"]
						if library.flags["ESP_Bold"] then
							HealthNumberB.Text = tostring(math.round(Humanoid.Health))
							if library.flags["ESP_HealthB"] then
								HealthNumberB.Position = Vector2.new(BoxPos.X - 2 - HealthNumber.TextBounds.X, BoxPos.Y - 2)
							else
								HealthNumberB.Position = Vector2.new(BoxPos.X - 2 - (HealthNumber.TextBounds.X / 2) - 3, BoxPos.Y - 2)
							end
							HealthNumberB.Color = library.flags["ESPC_HNum"]
							HealthNumberB.Font = Drawing.Fonts[library.flags["ESP_Font"]]
							HealthNumberB.Size = library.flags["ESP_Size"]
							HealthNumberB.Visible = true
							HealthNumberB.Outline = false
						end
					end

					if library.flags["ESP_Distance"] then
						Distance.Text = DistanceFromCharacter
						Distance.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, Y_off)
						Distance.Color = library.flags["ESPC_Distance"]
						Distance.Font = Drawing.Fonts[library.flags["ESP_Font"]]
						Distance.Size = library.flags["ESP_Size"]
						Distance.Visible = true
						Distance.Outline = library.flags["ESP_Out"]
						if library.flags["ESP_Bold"] then
							DistanceB.Text = DistanceFromCharacter
							DistanceB.Position = Vector2.new(BoxSize.X/2 + BoxPos.X + 1, Y_off)
							DistanceB.Color = library.flags["ESPC_Distance"]
							DistanceB.Font = Drawing.Fonts[library.flags["ESP_Font"]]
							DistanceB.Size = library.flags["ESP_Size"]
							DistanceB.Visible = true
							DistanceB.Outline = false
						end
						Y_off += 15
					end

					if library.flags["ESP_Tracers"] then
						Tracers.From = Vector2.new(BoxSize.X / 2 + BoxPos.X, BoxPos.Y + BoxSize.Y)
						Tracers.To = Vector2.new(960, 1080)
						Tracers.Color = library.flags["ESPC_Tracers"]
						Tracers.Visible = true
					end

					if library.flags["ESP_Head"] then
						if Head then
							HeadDot.Radius = Dif * 2
							HeadDot.Visible = true
							HeadDot.Position = Vector2.new(HeadPosA.x, HeadPosAB.y - Dif)
							HeadDot.Color = library.flags["ESPC_Head"]
						end
					end
				end
			else
				if isAlive(Player) and Player.Character:FindFirstChildOfClass("Highlight") then
					Player.Character:FindFirstChildOfClass("Highlight"):Destroy()
				end
				if PLRDS[Player] then
					for i, v in pairs(PLRDS[Player]) do
						if v.Visible ~= false then
							v.Visible = false
						end
					end
				end
			end

			if library.flags["ESP_Enabled"] and PLRDS[Player] and Player == LocalPlayer and isAlive(Player) then
				local PLRD = PLRDS[Player]
				for _,v in pairs (PLRD) do
					v.Visible = false
				end

				local Character = Player.Character
				local RootPart, Humanoid = Character and Character:FindFirstChild("HumanoidRootPart"), Character and Character:FindFirstChildOfClass("Humanoid")
				if Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then
					if Humanoid then
						if Humanoid.Health <= 0 then
							continue
						end
					end
				end

				local Head = Player.Character:FindFirstChild("Head")
				local poser = Camera:WorldToViewportPoint(Head.Position)
				local mousePos = V2(UserInputService:GetMouseLocation().x, UserInputService:GetMouseLocation().y, 0)
				local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
				local DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. "m"
				local alivecheck = true
				
				if Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then
					if Humanoid then
						if game.PlaceId == 4991214437 then
							if alivecheck and Humanoid.Health <= 1 then
								continue
							end
						else
							if alivecheck and Humanoid.Health <= 0 then
								continue
							end
						end
					end
				end
				if library.flags["ESP_TMode"] == "Normal" then
					DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. "m"
				elseif library.flags["ESP_TMode"] == "lowercase" then
					DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. string.lower("m")
				elseif library.flags["ESP_TMode"] == "UPPERCASE" then
					DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. string.upper("m")
				end
				local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
				if library.flags["ESPL_Chams"] then
					if Player.Character:FindFirstChildWhichIsA("Highlight") == nil then
						local highlight = Instance.new("Highlight", Player.Character)
					end
					Player.Character.Highlight.FillColor = library.flags["ESPCL_ChamsF"]
					Player.Character.Highlight.OutlineTransparency = esp.ChamsOL
					Player.Character.Highlight.FillTransparency = esp.ChamsFL
					Player.Character.Highlight.OutlineColor = library.flags["ESPCL_ChamsO"]
				else
					if Player.Character:FindFirstChildWhichIsA("Highlight") then
						Player.Character:FindFirstChildWhichIsA("Highlight"):Destroy()
					end
				end

				local IhateMyLifeSize = (Camera:WorldToViewportPoint(RootPart.Position - V3(0, 3, 0)).Y - Camera:WorldToViewportPoint(RootPart.Position + V3(0, 2.6, 0)).Y) / 2
				local BoxSize = Vector2.new(math.floor(IhateMyLifeSize * 1.2), math.floor(IhateMyLifeSize * 2))
				local BoxPos = Vector2.new(math.floor(Pos.X - IhateMyLifeSize * 1 / 2), math.floor(Pos.Y - IhateMyLifeSize * 1.6 / 2))
				local HeadPos = Head.Position
				local HeadPosA = workspace.CurrentCamera:WorldToViewportPoint(V3(HeadPos.x, HeadPos.y + 0.1, HeadPos.z))
				local HeadPosAB = workspace.CurrentCamera:WorldToViewportPoint(V3(HeadPos.x, HeadPos.y - 0.2, HeadPos.z))
				local Dif = HeadPosAB.y - HeadPosA.y
				local Name = PLRD.Name
				local Distance = PLRD.Distance
				local Box = PLRD.Box
				local Tracers = PLRD.Tracers
				local HeadDot = PLRD.HeadDot
				local BoxOutline = PLRD.BoxOutline
				local Health = PLRD.Health
				local HealthOutline = PLRD.HealthOutline
				local HealthNumber = PLRD.HealthNumber
				local HealthNumberB = PLRD.HealthNumberB
				local BoxFill = PLRD.BoxFill   
				--local FovTracer = PLRD.FovTracers 
				local Tool = PLRD.Tool 
				local DistanceB = PLRD.DistanceB
				local NameB = PLRD.NameB
				local ToolB = PLRD.ToolB
				local Health2 = PLRD.Health2
				local HealthOutline2 = PLRD.HealthOutline2
				local Y_off = BoxSize.Y + BoxPos.Y + 1
				
				local ptool = Player.Character.EquippedTool.Value 

				if library.flags["ESPL_Tool"] then
					if ptool ~= nil then
						if library.flags["ESP_TMode"] == "Normal" then
							Tool.Text = ptool
						elseif library.flags["ESP_TMode"] == "lowercase" then
							Tool.Text = string.lower(ptool)
						elseif library.flags["ESP_TMode"] == "UPPERCASE" then
							Tool.Text = string.upper(ptool)
						end
						Tool.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, Y_off)
						Tool.Color = library.flags["ESPCL_Tool"]
						Tool.Font = Drawing.Fonts[library.flags["ESP_Font"]]
						Tool.Size = library.flags["ESP_Size"]
						Tool.Visible = true
						Tool.Outline = library.flags["ESP_Out"]
						if library.flags["ESP_Bold"] then
							if library.flags["ESP_TMode"] == "Normal" then
								ToolB.Text = ptool
							elseif library.flags["ESP_TMode"] == "lowercase" then
								ToolB.Text = string.lower(ptool)
							elseif library.flags["ESP_TMode"] == "UPPERCASE" then
								ToolB.Text = string.upper(ptool)
							end
							ToolB.Position = Vector2.new(BoxSize.X/2 + BoxPos.X + 1, Y_off)
							ToolB.Color = library.flags["ESPCL_Tool"]
							ToolB.Font = Drawing.Fonts[library.flags["ESP_Font"]]
							ToolB.Size = library.flags["ESP_Size"]
							ToolB.Visible = true
							ToolB.Outline = false
						end
						Y_off += 15
					end
				end

				if library.flags["ESPL_Box"] then
					Box.Size = BoxSize
					Box.Position = BoxPos
					Box.Visible = true
					--[[if library.flags.tt and tname == "["..Player.DisplayName.."]" then
						Box.Color = library.flags.tcol
					else]]
						Box.Color = library.flags["ESPCL_Box"]
					--end

					if library.flags["ESP_Out"] then
						BoxOutline.Size = BoxSize
						BoxOutline.Position = BoxPos
						BoxOutline.Visible = true
					end
					
					BoxFill.Filled = true
					BoxFill.Visible = true
					BoxFill.Size = Vector2.new(math.floor(IhateMyLifeSize * 1.2 - 2), math.floor(IhateMyLifeSize * 2 - 2))
					BoxFill.Position = Vector2.new(math.floor(Pos.X - IhateMyLifeSize * 1 / 2 + 1), math.floor(Pos.Y - IhateMyLifeSize * 1.6 / 2 + 1))
					BoxFill.Color = library.flags["ESPCL_BoxF"]
					BoxFill.Transparency = esp.BoxFillL
				end

				if library.flags["ESPL_Name"] then
					if library.flags["ESP_TMode"] == "Normal" then
						Name.Text = Player.DisplayName
					elseif library.flags["ESP_TMode"] == "lowercase" then
						Name.Text = string.lower(Player.DisplayName)
					elseif library.flags["ESP_TMode"] == "UPPERCASE" then
						Name.Text = string.upper(Player.DisplayName)
					end
					Name.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X, BoxPos.Y - 5 - Name.TextBounds.Y)
					Name.Color = library.flags["ESPCL_Name"]
					Name.Font = Drawing.Fonts[library.flags["ESP_Font"]]
					Name.Size = library.flags["ESP_Size"]
					Name.Visible = true
					Name.Outline = library.flags["ESP_Out"]
					if library.flags["ESP_Bold"] then
						if library.flags["ESP_TMode"] == "Normal" then
							NameB.Text = Player.DisplayName
						elseif library.flags["ESP_TMode"] == "lowercase" then
							NameB.Text = string.lower(Player.DisplayName)
						elseif library.flags["ESP_TMode"] == "UPPERCASE" then
							NameB.Text = string.upper(Player.DisplayName)
						end
						NameB.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X + 1, BoxPos.Y - 5 - Name.TextBounds.Y)
						NameB.Color = library.flags["ESPCL_Name"]
						NameB.Font = Drawing.Fonts[library.flags["ESP_Font"]]
						NameB.Size = library.flags["ESP_Size"]
						NameB.Visible = true
						NameB.Outline = false
					end
				end

				if library.flags["ESPL_HealthB"] then  
					Health.From = Vector2.new((BoxPos.X - 5), BoxPos.Y + BoxSize.Y)
					Health.To = Vector2.new((BoxPos.X - 5), Health.From.Y - (Humanoid.Health / Humanoid.MaxHealth) * BoxSize.Y)
					Health.Color = library.flags["ESPCL_HealthB"] 
					Health.Visible = true

					Health2.From = Vector2.new((BoxPos.X - 6), BoxPos.Y + BoxSize.Y)
					Health2.To = Vector2.new((BoxPos.X - 6), Health.From.Y - (Humanoid.Health / Humanoid.MaxHealth) * BoxSize.Y)
					Health2.Color = library.flags["ESPCL_HealthB"]
					Health2.Visible = true

					if library.flags["ESP_Out"] then
						HealthOutline.From = Vector2.new(Health.From.X, BoxPos.Y + BoxSize.Y + 1)
						HealthOutline.To = Vector2.new(Health.From.X, (Health.From.Y - 1 * BoxSize.Y) -1)
						HealthOutline.Visible = true

						HealthOutline2.From = Vector2.new(Health.From.X - 2, BoxPos.Y + BoxSize.Y + 1)
						HealthOutline2.To = Vector2.new(Health.From.X - 2, (Health.From.Y - 1 * BoxSize.Y) -1)
						HealthOutline2.Visible = true
						HealthOutline2.Thickness = 1
						HealthOutline2.Color = Color3.new(0, 0, 0)
					end
				end

				if library.flags["ESPL_HNum"] and math.floor(Humanoid.Health) <= library.flags["ESP_HP"] then
					HealthNumber.Text = tostring(math.round(Humanoid.Health))
					if library.flags["ESPL_HealthB"] then
						HealthNumber.Position = Vector2.new(BoxPos.X - 3 - HealthNumber.TextBounds.X, BoxPos.Y - 2)
					else
						HealthNumber.Position = Vector2.new(BoxPos.X - 3 - (HealthNumber.TextBounds.X / 2) - 4, BoxPos.Y - 2)
					end
					HealthNumber.Color = library.flags["ESPCL_HNum"]
					HealthNumber.Font = Drawing.Fonts[library.flags["ESP_Font"]]
					HealthNumber.Size = library.flags["ESP_Size"]
					HealthNumber.Visible = true
					HealthNumber.Outline = library.flags["ESP_Out"]
					if library.flags["ESP_Bold"] then
						HealthNumberB.Text = tostring(math.round(Humanoid.Health))
						if library.flags["ESPL_HealthB"] then
							HealthNumberB.Position = Vector2.new(BoxPos.X - 2 - HealthNumber.TextBounds.X, BoxPos.Y - 2)
						else
							HealthNumberB.Position = Vector2.new(BoxPos.X - 2 - (HealthNumber.TextBounds.X / 2) - 3, BoxPos.Y - 2)
						end
						HealthNumberB.Color = library.flags["ESPCL_HNum"]
						HealthNumberB.Font = Drawing.Fonts[library.flags["ESP_Font"]]
						HealthNumberB.Size = library.flags["ESP_Size"]
						HealthNumberB.Visible = true
						HealthNumberB.Outline = false
					end
				end

				if library.flags["ESPL_Head"] then
					if Head then
						HeadDot.Radius = Dif * 2
						HeadDot.Visible = true
						HeadDot.Position = Vector2.new(HeadPosA.x, HeadPosAB.y - Dif)
						HeadDot.Color = library.flags["ESPCL_Head"]
					end
				end
			end
		end

		crosshair.leftb.Visible = library.flags["Crosshair_Enabled"] and library.flags["Crosshair_Border"]
		crosshair.leftb.Size = Vector2.new(library.flags["CrosshairL"] + 2, math.round(library.flags["CrosshairT"]) + 2)
		crosshair.leftb.Position = Vector2.new((ScreenSize.X / 2) - library.flags["CrosshairL"] - library.flags["CrosshairG"] - 1, (ScreenSize.Y / 2) - (math.round(library.flags["CrosshairT"]) / 2) - 1)
		crosshair.leftb.Color = library.flags["CrosshairCO"]

		crosshair.rightb.Visible = library.flags["Crosshair_Enabled"] and library.flags["Crosshair_Border"]
		crosshair.rightb.Size = Vector2.new(library.flags["CrosshairL"] + 2, math.round(library.flags["CrosshairT"]) + 2)
		crosshair.rightb.Position = Vector2.new((ScreenSize.X / 2) + library.flags["CrosshairG"] - 1, (ScreenSize.Y / 2) - (math.round(library.flags["CrosshairT"]) / 2) - 1)
		crosshair.rightb.Color = library.flags["CrosshairCO"]

		crosshair.topb.Visible = library.flags["Crosshair_Enabled"] and library.flags["Crosshair_Border"]
		crosshair.topb.Size = Vector2.new(math.round(library.flags["CrosshairT"]) + 2, library.flags["CrosshairL"] + 2)
		crosshair.topb.Position = Vector2.new((ScreenSize.X / 2) - (math.round(library.flags["CrosshairT"]) / 2) - 1, (ScreenSize.Y / 2) - library.flags["CrosshairL"] - library.flags["CrosshairG"] - 1)
		crosshair.topb.Color = library.flags["CrosshairCO"]

		crosshair.bottomb.Visible = library.flags["Crosshair_Enabled"] and library.flags["Crosshair_Border"]
		crosshair.bottomb.Size = Vector2.new(math.round(library.flags["CrosshairT"]) + 2, library.flags["CrosshairL"] + 2)
		crosshair.bottomb.Position = Vector2.new((ScreenSize.X / 2) - (math.round(library.flags["CrosshairT"]) / 2) - 1, (ScreenSize.Y / 2) + library.flags["CrosshairG"] - 1)
		crosshair.bottomb.Color = library.flags["CrosshairCO"]

		crosshair.left.Visible = library.flags["Crosshair_Enabled"]
		crosshair.left.Size = Vector2.new(library.flags["CrosshairL"], math.round(library.flags["CrosshairT"]))
		crosshair.left.Position = Vector2.new((ScreenSize.X / 2) - library.flags["CrosshairL"] - library.flags["CrosshairG"], (ScreenSize.Y / 2) - (math.round(library.flags["CrosshairT"]) / 2))
		crosshair.left.Color = library.flags["CrosshairC"]

		crosshair.right.Visible = library.flags["Crosshair_Enabled"]
		crosshair.right.Size = Vector2.new(library.flags["CrosshairL"], math.round(library.flags["CrosshairT"]))
		crosshair.right.Position = Vector2.new((ScreenSize.X / 2) + library.flags["CrosshairG"], (ScreenSize.Y / 2) - (math.round(library.flags["CrosshairT"]) / 2))
		crosshair.right.Color = library.flags["CrosshairC"]

		crosshair.top.Visible = library.flags["Crosshair_Enabled"]
		crosshair.top.Size = Vector2.new(math.round(library.flags["CrosshairT"]), library.flags["CrosshairL"])
		crosshair.top.Position = Vector2.new((ScreenSize.X / 2) - (math.round(library.flags["CrosshairT"]) / 2), (ScreenSize.Y / 2) - library.flags["CrosshairL"] - library.flags["CrosshairG"])
		crosshair.top.Color = library.flags["CrosshairC"]

		crosshair.bottom.Visible = library.flags["Crosshair_Enabled"]
		crosshair.bottom.Size = Vector2.new(math.round(library.flags["CrosshairT"]), library.flags["CrosshairL"])
		crosshair.bottom.Position = Vector2.new((ScreenSize.X / 2) - (math.round(library.flags["CrosshairT"]) / 2), (ScreenSize.Y / 2) + library.flags["CrosshairG"])
		crosshair.bottom.Color = library.flags["CrosshairC"]
	end
	--!SECTION

	--SECTION ETC
	local function ETC(step)
		StatText.Text = string.format("Network Send: %s kbps\nNetwork Recieve: %s kbps\nFPS: %s\nTick: %s", math.floor(game.Stats.PhysicsSendKbps), math.floor(game.Stats.PhysicsReceiveKbps), math.floor(1/step), math.floor(tick()))

		if library.flags["cheatt"] then
			title = library.flags["cheatname"]
		else
			title = "alsike"
		end

		Watermark.Text.Text = string.format("%s | v2.6 [dev] | FPS: %s | Ping: %sms", title, math.floor(1/step), math.floor(game:GetService('Stats').Network.ServerStatsItem["Data Ping"]:GetValue()))

		Watermark.Border.Position = V2(10, 10)
		Watermark.Accent.Position = Watermark.Border.Position + V2(1, 1)
		Watermark.Border2.Position = Watermark.Accent.Position + V2(1, 1)
		Watermark.Background.Position = Watermark.Border2.Position + V2(1, 1)
		Watermark.Gradient.Position = Watermark.Border2.Position + V2(1, 1)
	
		Watermark.Border.Size = V2(Watermark.Text.TextBounds.X + 16, Watermark.Text.TextBounds.Y + 16)
		Watermark.Accent.Size = V2(Watermark.Text.TextBounds.X + 14, Watermark.Text.TextBounds.Y + 14)
		Watermark.Border2.Size = V2(Watermark.Text.TextBounds.X + 12, Watermark.Text.TextBounds.Y + 12)
		Watermark.Background.Size = V2(Watermark.Text.TextBounds.X + 10, Watermark.Text.TextBounds.Y + 10)
		Watermark.Gradient.Size = V2(Watermark.Text.TextBounds.X + 10, Watermark.Text.TextBounds.Y + 10)
	
		Watermark.Text.Position = Watermark.Background.Position + V2(5, 5)

		Theme.Accent = library.flags["Menu Accent Color"]
		Theme.Border = library.flags["Border Color"]
		Theme.Border2 = library.flags["Inline Color"]
		Theme.Background = library.flags["Background Color"]
		Theme.TextColor = library.flags["Text Color"]
		Theme.TextOutline = library.flags["Text Border Color"]

		Watermark.Background.Color = Theme.Background
		Watermark.Border.Color = Theme.Border
		Watermark.Border2.Color = Theme.Border2
		Watermark.Text.Color = Theme.TextColor
		Watermark.Text.OutlineColor = Theme.TextOutline
		Watermark.Accent.Color = Theme.Accent
	end
	--!SECTION

	--!SECTION

	--SECTION Main Loop

	library:AddConnection(runService.RenderStepped, function(step)
		do Combat(step) end
		do Visuals() end
		do Misc(step) end
		do ETC(step) end
	end)

	--!SECTION

	--SECTION Settings Tab

	local function SettingsTab()
		library.SettingsTab             = library:AddTab("Settings", 1252352135)
		library.SettingsColumn          = library.SettingsTab:AddColumn()
		library.SettingsColumn1         = library.SettingsTab:AddColumn()

		library.SettingsMenu = library.SettingsColumn:AddSection"Menu"
		library.SettingsMenu:AddBind({text = "Open / Close", flag = "UI Toggle", nomouse = true, key = "RightShift", callback = function() library:Close() end})
		library.SettingsMenu:AddColor({text = "Accent Color", flag = "Menu Accent Color", color = Color3.fromRGB(30, 60, 150), callback = function(Color)
			if library.currentTab then
				library.currentTab.button.TextColor3 = Color
			end
			for _, obj in next, library.theme do
				obj[(obj.ClassName == "TextLabel" and "TextColor3") or (obj.ClassName == "ImageLabel" and "ImageColor3") or "BackgroundColor3"] = Color
			end
		end})
		library.SettingsMenu:AddColor({text = "Border Color", flag = "Border Color", color = Color3.fromRGB(0, 0, 0)})
		library.SettingsMenu:AddColor({text = "Inline Color", flag = "Inline Color", color = Color3.fromRGB(60, 60, 60)})
		library.SettingsMenu:AddColor({text = "Background Color", flag = "Background Color", color = Color3.fromRGB(45, 45, 45)})
		library.SettingsMenu:AddColor({text = "Text Color", flag = "Text Color", color = Color3.fromRGB(255, 255, 255)})
		library.SettingsMenu:AddColor({text = "Text Border Color", flag = "Text Border Color", color = Color3.fromRGB(0, 0, 0)})

		local Backgrounds = {
			["Floral"] = 5553946656,
			["Flowers"] = 6071575925,
			["Circles"] = 6071579801,
			["Hearts"] = 6073763717,
			["Polka dots"] = 6214418014,
			["Mountains"] = 6214412460,
			["Zigzag"] = 6214416834,
			["Zigzag 2"] = 6214375242,
			["Tartan"] = 6214404863,
			["Roses"] = 6214374619,
			["Hexagons"] = 6214320051,
			["Leopard print"] = 6214318622
		}
		library.SettingsMenu:AddList({text = "Background", flag = "UI Background", max = 6, values = {"Floral", "Flowers", "Circles", "Hearts", "Polka dots", "Mountains", "Zigzag", "Zigzag 2", "Tartan", "Roses", "Hexagons", "Leopard print"}, callback = function(Value)
			if Backgrounds[Value] then
				library.main.Image = "rbxassetid://" .. Backgrounds[Value]
			end
		end}):AddColor({flag = "Menu Background Color", color = Color3.new(), callback = function(Color)
			library.main.ImageColor3 = Color
		end, trans = 1, calltrans = function(Value)
			library.main.ImageTransparency = 1 - Value
		end})
		library.SettingsMenu:AddSlider({text = "Tile Size", textpos = 16, value = 90, min = 50, max = 500, callback = function(Value)
			library.main.TileSize = UDim2.new(0, Value, 0, Value)
		end})
		library.SettingsMenu:AddToggle({text = "Custom Cheat Name", flag = "cheatt"})
		library.SettingsMenu:AddBox({text = "Cheat Name", flag = "cheatname", value = "alsike"})

		
		library.SettingsMain = library.SettingsColumn:AddSection"Main"
		library.SettingsMain:AddButton({text = "Unload Cheat", nomouse = true, callback = function()
			library:Unload()
			getgenv().Alsike = nil
		end})
		library.SettingsMain:AddBind({text = "Panic Key", callback = library.options["Unload Cheat"].callback})
		library.SettingsMain:AddButton({text = "Copy Job Id", callback = function()
			createEventLog(string.format("Copied Job Id (%s).", game.JobId), 5)
			setclipboard(game.JobId)
		end})

		library.ConfigSection = library.SettingsColumn1:AddSection"Configs"
		library.ConfigSection:AddBox({text = "Config Name", skipflag = false})
		library.ConfigWarning = library:AddWarning({type = "confirm"})
		library.ConfigSection:AddList({text = "Configs",  value = "", flag = "Config List", values = library:GetConfigs()})
		library.ConfigSection:AddButton({text = "Create", callback = function()
			library:GetConfigs()
			writefile(""..library.foldername.."/" ..library.configgame.."/".. library.flags["Config Name"] .. library.fileext, "{}")
			createEventLog(string.format("Successfully created config (%s%s).", library.flags["Config Name"], library.fileext), 5)
			library.options["Config List"]:AddValue(library.flags["Config Name"])
		end})
		library.ConfigSection:AddButton({text = "Save", callback = function()
			local r, g, b = library.round(library.flags["Menu Accent Color"])
			library.ConfigWarning.text = "Are you sure you want to save the current settings to config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?"
			if library.ConfigWarning:Show() then
				createEventLog(string.format("Successfully saved config (%s%s).", library.flags["Config List"], library.fileext), 5)
				library:SaveConfig(library.flags["Config List"])
			end
		end})
		library.ConfigSection:AddButton({text = "Load", callback = function()
			local r, g, b = library.round(library.flags["Menu Accent Color"])
			library.ConfigWarning.text = "Are you sure you want to load config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?"
			if library.ConfigWarning:Show() then
				createEventLog(string.format("Successfully loaded config (%s%s).", library.flags["Config List"], library.fileext), 5)
				library:LoadConfig(library.flags["Config List"])
			end
		end})
		library.ConfigSection:AddButton({text = "Delete", callback = function()
			local r, g, b = library.round(library.flags["Menu Accent Color"])
			library.ConfigWarning.text = "Are you sure you want to delete config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?"
			if library.ConfigWarning:Show() then
				local Config = library.flags["Config List"]
				if table.find(library:GetConfigs(), Config) and isfile(library.foldername .. "/" .. Config .. library.fileext) then
					createEventLog(string.format("Successfully deleted config (%s%s).", library.flags["Config List"], library.fileext), 5)
					library.options["Config List"]:RemoveValue(Config)
					delfile(""..library.foldername.."/" ..library.configgame.. Config .. library.fileext)
				end
			end
		end})
	end
	SettingsTab()

	createEventLog(string.format("Welcome to alsike %s\nCurrent version is 3.2 [in-dev]\nExecuted at: %s", LocalPlayer.Name, os.date("%I:%M:%S", os.time())), 10)
	createEventLog("Press RightShift to open/close menu.", 5)

	--!SECTION

	library:Init()
else
	--!SECTION

	--SECTION Library Shit

	library.CombatTab           	= library:AddTab("Combat", 2)
	library.VisualsTab              = library:AddTab("Visuals", 3)
	library.MiscTab                 = library:AddTab("Misc", 4)
	library.PlayersColumn1          = library.VisualsTab:AddColumn()
	library.PlayersColumn2          = library.VisualsTab:AddColumn()
	library.MiscColumn1             = library.MiscTab:AddColumn()
	library.MiscColumn2             = library.MiscTab:AddColumn()
	library.CombatColumn1           = library.CombatTab:AddColumn()
	library.CombatColumn2           = library.CombatTab:AddColumn()

	--!SECTION

	--SECTION Combat

	--SECTION Combat-Aimbot
	library.Aimbot = library.CombatColumn1:AddSection("Aimbot")
	library.Aimbot:AddToggle({text = "Enabled", flag = "aimbot_enabled"}):AddBind({flag = "aimbot_key", mode = "hold"})
	library.Aimbot:AddToggle({text = "Visible Check", flag = "aimbot_vis"})
	library.Aimbot:AddList({text = "Hitbox",  flag = "aimbot_hit", value = "Head", values = {"Head", "Torso"}})
	library.Aimbot:AddSlider({text = "Smoothing", flag = "aimbot_smooth", value = 1, min = 1, max = 100, suffix = '%'})
	library.Aimbot:AddToggle({text = "Teammates", flag = "aimbot_team"})
	library.Aimbot:AddToggle({text = "Distance Check", flag = "aimbot_distance"}):AddSlider({flag = "aimbot_distanceamt", value = 500, min = 30, max = 1500, suffix = 'm'})
	--!SECTION

	--SECTION Combat-Aimbot Settings
	library.Aimbot = library.CombatColumn2:AddSection("Aimbot Settings")
	library.Aimbot:AddSlider({text = "Aim Assist FOV", flag = "aimbot_fov", value = 60, min = 0, max = 800})
	--!SECTION

	--!SECTION

	--SECTION Visuals

	--SECTION Visuals-Player ESP
	library.Players = library.PlayersColumn1:AddSection("Player ESP")
	library.Players:AddToggle({text = "Enabled", flag = "ESP_Enabled"}):AddBind({callback = function()
		library.options["ESP_Enabled"]:SetState(not library.flags["ESP_Enabled"])
	end})
	library.Players:AddToggle({text = "Chams", flag = "ESP_Chams"}):AddColor({flag = "ESPC_ChamsF", trans = 0.5, color = C3(66, 135, 245), calltrans = function(val)
		esp.ChamsF = val
	end}):AddColor({flag = "ESPC_ChamsO", trans = 0.5, color = C3(66, 245, 176), calltrans = function(val)
		esp.ChamsO = val
	end})
	library.Players:AddToggle({text = "Box ESP", flag = "ESP_Box"}):AddColor({flag = "ESPC_Box", color = C3(255, 255, 255)}):AddColor({flag = "ESPC_BoxF", color = C3(255, 255, 255), trans = 0.2, calltrans = function(val)
		esp.BoxFill = val
	end})
	library.Players:AddToggle({text = "Name ESP", flag = "ESP_Name"}):AddColor({flag = "ESPC_Name", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Weapon ESP", flag = "ESP_Tool"}):AddColor({flag = "ESPC_Tool", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Distance ESP", flag = "ESP_Distance"}):AddColor({flag = "ESPC_Distance", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Health Bar", flag = "ESP_HealthB"}):AddColor({flag = "ESPC_HealthB", color = C3(255, 255, 0)})
	library.Players:AddToggle({text = "Health Number", flag = "ESP_HNum"}):AddColor({flag = "ESPC_HNum", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Tracers", flag = "ESP_Tracers"}):AddColor({flag = "ESPC_Tracers", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Head Dot", flag = "ESP_Head"}):AddColor({flag = "ESPC_Head", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Out Of View", flag = "ESP_OOF"}):AddColor({flag = "ESPC_OOF", color = C3(255, 255, 255)})
	library.Players:AddDivider("Local ESP")
	library.Players:AddToggle({text = "Chams", flag = "ESPL_Chams"}):AddColor({flag = "ESPCL_ChamsF", trans = 0.5, color = C3(66, 135, 245), calltrans = function(val)
		esp.ChamsFL = val
	end}):AddColor({flag = "ESPCL_ChamsO", trans = 0.5, color = C3(66, 245, 176), calltrans = function(val)
		esp.ChamsOL = val
	end})
	library.Players:AddToggle({text = "Box ESP", flag = "ESPL_Box"}):AddColor({flag = "ESPCL_Box", color = C3(255, 255, 255)}):AddColor({flag = "ESPCL_BoxF", color = C3(255, 255, 255), trans = 0.2, calltrans = function(val)
		esp.BoxFillL = val
	end})
	library.Players:AddToggle({text = "Name ESP", flag = "ESPL_Name"}):AddColor({flag = "ESPCL_Name", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Weapon ESP", flag = "ESPL_Tool"}):AddColor({flag = "ESPCL_Tool", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Health Bar", flag = "ESPL_HealthB"}):AddColor({flag = "ESPCL_HealthB", color = C3(255, 255, 0)})
	library.Players:AddToggle({text = "Health Number", flag = "ESPL_HNum"}):AddColor({flag = "ESPCL_HNum", color = C3(255, 255, 255)})
	library.Players:AddToggle({text = "Head Dot", flag = "ESPL_Head"}):AddColor({flag = "ESPCL_Head", color = C3(255, 255, 255)})
	library.Players:AddDivider("Settings")
	library.Players:AddToggle({text = "Outline", state = true, flag = "ESP_Out"})
	library.Players:AddToggle({text = "Bold Text", flag = "ESP_Bold"})
	library.Players:AddToggle({text = "Teammates", state = true, flag = "ESP_Team"})
	library.Players:AddSlider({text = "Out Of View Size", flag = "ESP_OS", value = 10, min = 1, max = 25})
	library.Players:AddSlider({text = "Out Of View Distance", flag = "ESP_OD", value = 300, min = 50, max = 800})
	library.Players:AddSlider({text = "HP Visibility Cap", flag = "ESP_HP", value = 90, min = 0, max = 100})
	library.Players:AddList({text = "Font",  flag = "ESP_Font", value = "Plex", values = {"UI", "System", "Plex", "Monospace"}})
	library.Players:AddList({text = "Text Mode", flag = "ESP_TMode",  value = "Normal", values = {"Normal", "lowercase", "UPPERCASE"}})
	library.Players:AddSlider({text = "Size", flag = "ESP_Size", value = 13, min = 1, max = 50})
	--!SECTION

	--SECTION Visuals-Misc
	library.Misc = library.PlayersColumn1:AddSection("Misc")
	library.Misc:AddToggle({text = "Third Person", flag = "thirdperson"}):AddSlider({flag = "thirdamt", value = 5, min = 1, max = 30}):AddBind({flag = "thirdekey"})
	--!SECTION

	--SECTION Visuals-Local
	library.Local = library.PlayersColumn2:AddSection("Local")
	library.Local:AddToggle({text = "Field Of View", flag = "Local_Fov"}):AddSlider({flag = "Local_FAmt", value = 90, min = 30, max = 120})
	library.Local:AddToggle({text = "Aim Assist Circle", flag = "FOV_Enabled"}):AddColor({flag = "FOVC", trans = 1, color = C3(255, 255, 255), calltrans = function(val)
		esp.F1 = val
	end}):AddColor({flag = "FOVCO", trans = 1, color = C3(0, 0, 0), calltrans = function(val)
		esp.F2 = val
	end})
	library.Local:AddToggle({text = "Filled", flag = "FOV_Filled"})
	library.Local:AddSlider({text = "Num Sides",flag = "FOVN", value = 20, min = 0, max = 50})
	library.Local:AddSlider({text = "Thickness",flag = "FOVT", value = 1, min = 1, max = 25})
	--!SECTION

	--SECTION Visuals-World
	library.World = library.PlayersColumn2:AddSection("World")
	library.World:AddToggle({text = "Ambient", flag = "World_Ambient"}):AddColor({flag = "WorldC_OutC", color = C3(255, 255, 255)}):AddColor({flag = "WorldC_C", color = C3(255, 255, 255)})
	library.World:AddToggle({text = "Contrast", flag = "World_Contrast"}):AddSlider({flag = "World_CAmt", value = 0.5, min = 0, max = 1, float = 0.01})
	library.World:AddToggle({text = "Saturation", flag = "World_Saturation"}):AddSlider({flag = "World_SAmt", value = 0.5, min = 0, max = 1, float = 0.01})
	library.World:AddToggle({text = "Time", flag = "World_Time"}):AddSlider({flag = "World_TAmt", value = 12, min = 0, max = 24})
	--!SECTION

	--!SECTION

	--SECTION Misc

	--SECTION Misc-Main

	library.Main = library.MiscColumn1:AddSection("Main")
	library.Main:AddToggle({text = "Watermark", state = true, callback = function(val)
		for i,v in pairs(Watermark) do	
			v.Visible = val
		end
	end})
	library.Main:AddToggle({text = "Outline", state = false, callback = function(val)
		Theme.Outline = val
	end})
	--!SECTION

	--SECTION Misc-Players
	library.Players2 = library.MiscColumn2:AddSection("Players")
	library.Players2:AddList({flag = "Player List", skipflag = true, flag = "plrlist", textpos = 2, max = 10, values = (function() 
		local t = {} 
		for _, Player in next, Players:GetPlayers() do 
			if Player ~= LocalPlayer then 
				table.insert(t, Player.Name) 
			end 
		end 
		return t 
	end)()})
	--!SECTION

	--SECTION Misc-Character
	library.Movement = library.MiscColumn1:AddSection("Movement")
	library.Movement:AddToggle({text = "Walk Speed", flag = "Movement_Walk"}):AddSlider({flag = "Movement_WalkAmt", value = 18, min = 18, max = 300}):AddBind({flag = "Movement_WalkKey", mode = "hold"})
	library.Movement:AddToggle({text = "Fly", flag = "Movement_Fly"}):AddSlider({flag = "Movement_FlyAmt", value = 18, min = 18, max = 300}):AddBind({flag = "Movement_FlyKey"})
	library.Movement:AddToggle({text = "Noclip", flag = "Movement_Noclip"}):AddBind({flag = "Movement_NoclipKey"})
	library.Movement:AddList({text = "Fly Method",  flag = "Movement_FlyM", value = "Velocity", values = {"Velocity", "Noclip"}})
	--!SECTION

	--!SECTION

	--SECTION Misc-Crosshair
	library.Crosshair = library.MiscColumn2:AddSection("Crosshair")
	library.Crosshair:AddToggle({text = "Enabled", flag = "Crosshair_Enabled"}):AddColor({flag = "CrosshairC", color = C3(255, 255, 0)}):AddColor({flag = "CrosshairCO", color = C3(0, 0, 0)})
	library.Crosshair:AddSlider({text = "Length", flag = "CrosshairL", value = 5, min = 1, max = 300})
	library.Crosshair:AddSlider({text = "Thickness", flag = "CrosshairT", value = 2, min = 2, max = 14, float = 2})
	library.Crosshair:AddSlider({text = "Gap", flag = "CrosshairG", value = 4, min = 1, max = 100})
	library.Crosshair:AddToggle({text = "Border", flag = "Crosshair_Border"})
	--!SECTION

	--SECTION Functions

	--SECTION Misc
	local lasttick = tick()
	local function Misc(step)
		if isAlive(LocalPlayer) then
			local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")  
			local RootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			local Character = LocalPlayer:FindFirstChild("Character")

			if library.flags["Movement_Walk"] and library.flags["Movement_WalkKey"] then
				local travel = V3()
				local looking = Workspace.CurrentCamera.CFrame.lookVector
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then
					travel += V3(looking.x, 0, looking.Z)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then
					travel -= V3(looking.x, 0, looking.Z)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then
					travel += V3(-looking.Z, 0, looking.x)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then
					travel += V3(looking.Z, 0, -looking.x)
				end

				travel = travel.Unit

				local newDir = V3(travel.x * library.flags["Movement_WalkAmt"], RootPart.Velocity.y, travel.Z * library.flags["Movement_WalkAmt"])

				if travel.Unit.x == travel.Unit.x then
					RootPart.Velocity = newDir
				end
			end

			if library.flags["Movement_Noclip"] and library.flags["Movement_NoclipKey"] then
				for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
					if v:IsA("BasePart") and v.CanCollide == true then
						v.CanCollide = false
					end
				end
			end

			if library.flags["Movement_Fly"] then
				if library.flags["Movement_FlyM"]== "Noclip" and library.flags["Movement_FlyKey"] then
					for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart") and v.CanCollide == true then
							v.CanCollide = false
						end
					end
				end
				if library.flags["Movement_FlyKey"] then
					local Speed = library.flags.mvflyamt

					local travel = V3()
					local looking = Camera.CFrame.lookVector

					do
						if UserInputService:IsKeyDown(Enum.KeyCode.W) then
							travel += looking
						end
						if UserInputService:IsKeyDown(Enum.KeyCode.S) then
							travel -= looking
						end
						if UserInputService:IsKeyDown(Enum.KeyCode.D) then
							travel += V3(-looking.Z, 0, looking.x)
						end
						if UserInputService:IsKeyDown(Enum.KeyCode.A) then
							travel += V3(looking.Z, 0, -looking.x)
						end

						if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
							travel += V3(0, 1, 0)
						end
						if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
							travel -= V3(0, 1, 0)
						end
					end

					if travel.Unit.x == travel.Unit.x then
						RootPart.Anchored = false
						RootPart.Velocity = travel.Unit * library.flags["Movement_FlyAmt"]
					else
						RootPart.Velocity = V3(0, 0, 0)
						RootPart.Anchored = true
					end
				else
					RootPart.Anchored = false
				end
			end
		end



		local count = #eventLogs
		local removedFirst = false
		for i = 1, count do
			local curTick = tick()
			local eventLog = eventLogs[i]
			if eventLog then
				if curTick - eventLog.startTick > eventLog.lifeTime then
					task.spawn(eventLog.Destroy, eventLog)
					table.remove(eventLogs, i)
				elseif count > 10 and not removedFirst then
					removedFirst = true
					local first = table.remove(eventLogs, 1)
					task.spawn(first.Destroy, first)
				else
					local previousEventLog = eventLogs[i - 1]
					local basePosition
					if previousEventLog then
						basePosition = Vector2.new(10, previousEventLog.mainText.Position.y + previousEventLog.mainText.TextBounds.y + 10)
					else
						basePosition = Vector2.new(10, 48)
					end
					eventLog.mainText.Position = V2(eventLog.Background.Position.X + 5, eventLog.Background.Position.Y + 5)
					eventLog.mainText.Outline = true
	
					eventLog.Border1.Position = V2(basePosition.X, basePosition.Y)
					eventLog.Accent.Position = V2(eventLog.Border1.Position.X + 1, eventLog.Border1.Position.Y + 1)
					eventLog.Border2.Position = V2(eventLog.Accent.Position.X + 1, eventLog.Accent.Position.Y + 1)
					eventLog.Background.Position = V2(eventLog.Border2.Position.X + 1, eventLog.Border2.Position.Y + 1)
					eventLog.Gradient.Position = V2(eventLog.Border2.Position.X + 1, eventLog.Border2.Position.Y + 1)
	
					eventLog.Border1.Size = V2(eventLog.mainText.TextBounds.X + 16, eventLog.mainText.TextBounds.Y + 16)
					eventLog.Accent.Size = V2(eventLog.mainText.TextBounds.X + 14, eventLog.mainText.TextBounds.Y + 14)
					eventLog.Border2.Size = V2(eventLog.mainText.TextBounds.X + 12, eventLog.mainText.TextBounds.Y + 12)
					eventLog.Background.Size = V2(eventLog.mainText.TextBounds.X + 10, eventLog.mainText.TextBounds.Y + 10)
					eventLog.Gradient.Size = V2(eventLog.mainText.TextBounds.X + 10, eventLog.mainText.TextBounds.Y + 10)
	
					eventLog.Border1.Color = Theme.Border
					eventLog.Border2.Color = Theme.Border2
					eventLog.Background.Color = Theme.Background
					eventLog.Accent.Color = Theme.Accent
					eventLog.mainText.Color = Theme.TextColor
					eventLog.mainText.OutlineColor = Theme.TextOutline
				end
			end
		end
	end
	getgenv().createEventLog = createEventLog
	--!SECTION

	--SECTION Combat
	local function Combat(step)
		LastStep = step 
		Ping = game.Stats.PerformanceStats.Ping:GetValue() 
		local RPar = RaycastParams.new()        	
		RPar.IgnoreWater = true 
		RPar.FilterType = Enum.RaycastFilterType.Blacklist
		RPar.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
		Camera = workspace.Camera
		local mousePos = V3(UserInputService:GetMouseLocation().x, UserInputService:GetMouseLocation().y, 0)

		if library.flags["aimbot_enabled"] then
			local organizedPlayers = {}
			local fov = library.flags["aimbot_fov"]

			for i, v in ipairs(Players:GetPlayers()) do
				if v == LocalPlayer then continue end

				if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") then
					local Humanoid = v.Character:FindFirstChild("Humanoid")
					local RootPart = v.Character:FindFirstChild("HumanoidRootPart")

					local Head = v.Character:FindFirstChild("Head")
					local Pos = Camera:WorldToViewportPoint(RootPart.Position)
					if Head then
						Pos = Camera:WorldToViewportPoint(Head.Position)
					else
						Pos = Camera:WorldToViewportPoint(RootPart.Position)
					end
					if fov ~= 0 then
						if find_2d_distance(Pos, mousePos) > fov then
							continue
						end
					end

					if library.flags["aimbot_team"] and v.Team and v.Team == LocalPlayer.Team then continue end

					if library.flags["aimbot_distance"] and LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5 > library.flags["aimbot_distanceamt"] then continue end

					if library.flags["aimbot_vis"] then
						local Dir = RootPart.Position - Camera.CFrame.Position
						local Res = workspace:Raycast(Camera.CFrame.Position, Dir.Unit * Dir.Magnitude, RPar)
			
						if not Res then continue end
						local Hit = Res.Instance
			
						if not Hit:FindFirstAncestor(v.Name) then continue end

						table.insert(organizedPlayers, v)
					else
						table.insert(organizedPlayers, v)
					end
				end
			end

			table.sort(organizedPlayers, function(a, b)
				local aPos, aVis = Camera:WorldToViewportPoint(a.Character.Head.Position)
				local bPos, bVis = Camera:WorldToViewportPoint(b.Character.Head.Position)
				if aVis and not bVis then
					return true
				end
				if bVis and not aVis then
					return false
				end

				return (aPos - mousePos).Magnitude < (bPos - mousePos).Magnitude
			end)
			
			for i, v in ipairs(organizedPlayers) do
				local Hitbox = nil
				if library.flags["aimbot_hit"] == "Head" then
					Hitbox = v.Character:FindFirstChild("Head")
				elseif library.flags["aimbot_hit"] == "Torso" then
					Hitbox = v.Character:FindFirstChild("Torso")
					if Hitbox == nil then
						Hitbox = v.Character:FindFirstChild("UpperTorso")
					end
				end

				if Hitbox then
					local Pos, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)
					if OnScreen then
						if library.flags["aimbot_key"] then
							local inc = V2(Pos.X - UserInputService:GetMouseLocation().x, Pos.Y - UserInputService:GetMouseLocation().y)
							mousemoverel(inc.X / (library.flags["aimbot_smooth"] + 3), inc.Y / (library.flags["aimbot_smooth"] + 3))
							return
						end
					end
				end
			end
		end
	end 
	--!SECTION

	--SECTION Visuals
	local function Visuals()


		ColorCorrection.Saturation = 0
		ColorCorrection.Contrast = 0
		Camera = workspace.CurrentCamera

		if library.flags["thirdperson"] and library.flags["thirdekey"] then
			if LocalPlayer.CameraMinZoomDistance ~= library.flags["thirdamt"] and LocalPlayer.CameraMaxZoomDistance ~= library.flags["thirdamt"] then
				LocalPlayer.CameraMaxZoomDistance = library.flags["thirdamt"]
				LocalPlayer.CameraMinZoomDistance = library.flags["thirdamt"]
			end
		end

		local MousePosition = V2(UserInputService:GetMouseLocation().x, UserInputService:GetMouseLocation().y)

		fovcircle.F2.Visible = library.flags["FOV_Enabled"]
		fovcircle.F2.Radius = library.flags["aimbot_fov"]
		fovcircle.F2.Transparency = esp.F2
		fovcircle.F2.Filled = false
		fovcircle.F2.Position = MousePosition
		fovcircle.F2.NumSides = library.flags["FOVN"]
		fovcircle.F2.Thickness = library.flags["FOVT"] + 3
		fovcircle.F2.Color = library.flags["FOVCO"]

		fovcircle.F1.Visible = library.flags["FOV_Enabled"]
		fovcircle.F1.Radius = library.flags["aimbot_fov"]
		fovcircle.F1.Transparency = esp.F1
		fovcircle.F1.Filled = library.flags["FOV_Filled"]
		fovcircle.F1.Position = MousePosition
		fovcircle.F1.NumSides = library.flags["FOVN"]
		fovcircle.F1.Thickness = library.flags["FOVT"]
		fovcircle.F1.Color = library.flags["FOVC"]

		if library.flags["World_Ambient"] then
			Lighting.OutdoorAmbient = library.flags["WorldC_OutC"]
			Lighting.Ambient = library.flags["WorldC_C"]
		end

		if library.flags["World_Contrast"] then
			ColorCorrection.Contrast = library.flags["World_CAmt"]
		end

		if library.flags["World_Saturation"] then
			ColorCorrection.Saturation = library.flags["World_SAmt"]
		end

		if library.flags["Local_Fov"] then
			Camera.FieldOfView = library.flags["Local_FAmt"]
		end

		if library.flags["World_Time"] then
			Lighting.TimeOfDay = library.flags["World_TAmt"]
		end

		for _,Player in pairs (Players:GetPlayers()) do
			if library.flags["ESP_Enabled"] and PLRDS[Player] and isTarget(Player, library.flags["ESP_Team"]) then
				local PLRD = PLRDS[Player]
				for _,v in pairs (PLRD) do
					v.Visible = false
				end

				local Character = Player.Character
				local RootPart, Humanoid = Character and Character:FindFirstChild("HumanoidRootPart"), Character and Character:FindFirstChildOfClass("Humanoid")
				if Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then
					if Humanoid then
						if Humanoid.Health <= 0 then
							continue
						end
					end
				end

				local Head = Player.Character:FindFirstChild("Head")
				local poser = Camera:WorldToViewportPoint(Head.Position)
				local mousePos = V2(UserInputService:GetMouseLocation().x, UserInputService:GetMouseLocation().y, 0)
				local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
				local DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. "m"
				local alivecheck = true
				
				if Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then
					if Humanoid then
						if game.PlaceId == 4991214437 then
							if alivecheck and Humanoid.Health <= 1 then
								continue
							end
						else
							if alivecheck and Humanoid.Health <= 0 then
								continue
							end
						end
					end
				end
				if library.flags["ESP_TMode"] == "Normal" then
					DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. "m"
				elseif library.flags["ESP_TMode"] == "lowercase" then
					DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. string.lower("m")
				elseif library.flags["ESP_TMode"] == "UPPERCASE" then
					DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. string.upper("m")
				end
				local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
				if library.flags["ESP_Chams"] and isTarget(Player, library.flags["ESP_Team"]) then
					if Player.Character:FindFirstChildWhichIsA("Highlight") == nil then
						local highlight = Instance.new("Highlight", Player.Character)
					end
					Player.Character.Highlight.FillColor = library.flags["ESPC_ChamsF"]
					Player.Character.Highlight.OutlineTransparency = esp.ChamsO
					Player.Character.Highlight.FillTransparency = esp.ChamsF
					Player.Character.Highlight.OutlineColor = library.flags["ESPC_ChamsO"]
				else
					if Player.Character:FindFirstChildWhichIsA("Highlight") then
						Player.Character:FindFirstChildWhichIsA("Highlight"):Destroy()
					end
				end
				if not OnScreen then
					local niggars = Character.PrimaryPart
					local proj = Camera.CFrame:PointToObjectSpace(RootPart.Position)
					local ang = math.atan2(proj.Z, proj.X)
					local dir = Vector2.new(math.cos(ang), math.sin(ang))
					local pos = (dir * library.flags["ESP_OD"] * .5) + Camera.ViewportSize / 2
					local Drawing = PLRD.Offscreen

					
					if library.flags["ESP_OOF"] then
						Drawing.PointA = pos
						Drawing.PointB = pos - rotateVector2(dir, math.rad(35)) * library.flags["ESP_OS"]
						Drawing.PointC = pos - rotateVector2(dir, -math.rad(35)) * library.flags["ESP_OS"]
						Drawing.Color = library.flags["ESPC_OOF"]
						Drawing.Filled = true
						Drawing.Transparency = 1
						Drawing.Visible = true
					end
				else    
					local IhateMyLifeSize = (Camera:WorldToViewportPoint(RootPart.Position - V3(0, 3, 0)).Y - Camera:WorldToViewportPoint(RootPart.Position + V3(0, 2.6, 0)).Y) / 2
					local BoxSize = Vector2.new(math.floor(IhateMyLifeSize * 1.2), math.floor(IhateMyLifeSize * 2))
					local BoxPos = Vector2.new(math.floor(Pos.X - IhateMyLifeSize * 1 / 2), math.floor(Pos.Y - IhateMyLifeSize * 1.6 / 2))
					local HeadPos = Head.Position
					local HeadPosA = workspace.CurrentCamera:WorldToViewportPoint(V3(HeadPos.x, HeadPos.y + 0.1, HeadPos.z))
					local HeadPosAB = workspace.CurrentCamera:WorldToViewportPoint(V3(HeadPos.x, HeadPos.y - 0.2, HeadPos.z))
					local Dif = HeadPosAB.y - HeadPosA.y
					local Name = PLRD.Name
					local Distance = PLRD.Distance
					local Box = PLRD.Box
					local Tracers = PLRD.Tracers
					local HeadDot = PLRD.HeadDot
					local BoxOutline = PLRD.BoxOutline
					local Health = PLRD.Health
					local HealthOutline = PLRD.HealthOutline
					local HealthNumber = PLRD.HealthNumber
					local HealthNumberB = PLRD.HealthNumberB
					local BoxFill = PLRD.BoxFill   
					--local FovTracer = PLRD.FovTracers 
					local Tool = PLRD.Tool 
					local DistanceB = PLRD.DistanceB
					local NameB = PLRD.NameB
					local ToolB = PLRD.ToolB
					local Health2 = PLRD.Health2
					local HealthOutline2 = PLRD.HealthOutline2
					local Y_off = BoxSize.Y + BoxPos.Y + 1
					
					local ptool = Player.Character:FindFirstChildOfClass("Tool") and Player.Character:FindFirstChildOfClass("Tool").Name

					if library.flags["ESP_Tool"] then
						if ptool ~= nil then
							if library.flags["ESP_TMode"] == "Normal" then
								Tool.Text = ptool
							elseif library.flags["ESP_TMode"] == "lowercase" then
								Tool.Text = string.lower(ptool)
							elseif library.flags["ESP_TMode"] == "UPPERCASE" then
								Tool.Text = string.upper(ptool)
							end
							Tool.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, Y_off)
							Tool.Color = library.flags["ESPC_Tool"]
							Tool.Font = Drawing.Fonts[library.flags["ESP_Font"]]
							Tool.Size = library.flags["ESP_Size"]
							Tool.Visible = true
							Tool.Outline = library.flags["ESP_Out"]
							if library.flags["ESP_Bold"] then
								if library.flags["ESP_TMode"] == "Normal" then
									ToolB.Text = ptool
								elseif library.flags["ESP_TMode"] == "lowercase" then
									ToolB.Text = string.lower(ptool)
								elseif library.flags["ESP_TMode"] == "UPPERCASE" then
									ToolB.Text = string.upper(ptool)
								end
								ToolB.Position = Vector2.new(BoxSize.X/2 + BoxPos.X + 1, Y_off)
								ToolB.Color = library.flags["ESPC_Tool"]
								ToolB.Font = Drawing.Fonts[library.flags["ESP_Font"]]
								ToolB.Size = library.flags["ESP_Size"]
								ToolB.Visible = true
								ToolB.Outline = false
							end
							Y_off += 15
						end
					end

					if library.flags["ESP_Box"] then
						Box.Size = BoxSize
						Box.Position = BoxPos
						Box.Visible = true
						--[[if library.flags.tt and tname == "["..Player.DisplayName.."]" then
							Box.Color = library.flags.tcol
						else]]
							Box.Color = library.flags["ESPC_Box"]
						--end

						if library.flags["ESP_Out"] then
							BoxOutline.Size = BoxSize
							BoxOutline.Position = BoxPos
							BoxOutline.Visible = true
						end
						
						BoxFill.Filled = true
						BoxFill.Visible = true
						BoxFill.Size = Vector2.new(math.floor(IhateMyLifeSize * 1.2 - 2), math.floor(IhateMyLifeSize * 2 - 2))
						BoxFill.Position = Vector2.new(math.floor(Pos.X - IhateMyLifeSize * 1 / 2 + 1), math.floor(Pos.Y - IhateMyLifeSize * 1.6 / 2 + 1))
						BoxFill.Color = library.flags["ESPC_BoxF"]
						BoxFill.Transparency = esp.BoxFill
					end

					if library.flags["ESP_Name"] then
						if library.flags["ESP_TMode"] == "Normal" then
							Name.Text = Player.DisplayName
						elseif library.flags["ESP_TMode"] == "lowercase" then
							Name.Text = string.lower(Player.DisplayName)
						elseif library.flags["ESP_TMode"] == "UPPERCASE" then
							Name.Text = string.upper(Player.DisplayName)
						end
						Name.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X, BoxPos.Y - 5 - Name.TextBounds.Y)
						Name.Color = library.flags["ESPC_Name"]
						Name.Font = Drawing.Fonts[library.flags["ESP_Font"]]
						Name.Size = library.flags["ESP_Size"]
						Name.Visible = true
						Name.Outline = library.flags["ESP_Out"]
						if library.flags["ESP_Bold"] then
							if library.flags["ESP_TMode"] == "Normal" then
								NameB.Text = Player.DisplayName
							elseif library.flags["ESP_TMode"] == "lowercase" then
								NameB.Text = string.lower(Player.DisplayName)
							elseif library.flags["ESP_TMode"] == "UPPERCASE" then
								NameB.Text = string.upper(Player.DisplayName)
							end
							NameB.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X + 1, BoxPos.Y - 5 - Name.TextBounds.Y)
							NameB.Color = library.flags["ESPC_Name"]
							NameB.Font = Drawing.Fonts[library.flags["ESP_Font"]]
							NameB.Size = library.flags["ESP_Size"]
							NameB.Visible = true
							NameB.Outline = false
						end
					end

					if library.flags["ESP_HealthB"] then  
						Health.From = Vector2.new((BoxPos.X - 5), BoxPos.Y + BoxSize.Y)
						Health.To = Vector2.new((BoxPos.X - 5), Health.From.Y - (Humanoid.Health / Humanoid.MaxHealth) * BoxSize.Y)
						Health.Color = library.flags["ESPC_HealthB"] 
						Health.Visible = true

						Health2.From = Vector2.new((BoxPos.X - 6), BoxPos.Y + BoxSize.Y)
						Health2.To = Vector2.new((BoxPos.X - 6), Health.From.Y - (Humanoid.Health / Humanoid.MaxHealth) * BoxSize.Y)
						Health2.Color = library.flags["ESPC_HealthB"]
						Health2.Visible = true

						if library.flags["ESP_Out"] then
							HealthOutline.From = Vector2.new(Health.From.X, BoxPos.Y + BoxSize.Y + 1)
							HealthOutline.To = Vector2.new(Health.From.X, (Health.From.Y - 1 * BoxSize.Y) -1)
							HealthOutline.Visible = true

							HealthOutline2.From = Vector2.new(Health.From.X - 2, BoxPos.Y + BoxSize.Y + 1)
							HealthOutline2.To = Vector2.new(Health.From.X - 2, (Health.From.Y - 1 * BoxSize.Y) -1)
							HealthOutline2.Visible = true
							HealthOutline2.Thickness = 1
							HealthOutline2.Color = Color3.new(0, 0, 0)
						end
					end

					if library.flags["ESP_HNum"] and math.floor(Humanoid.Health) <= library.flags["ESP_HP"] then
						HealthNumber.Text = tostring(math.round(Humanoid.Health))
						if library.flags["ESP_HealthB"] then
							HealthNumber.Position = Vector2.new(BoxPos.X - 3 - HealthNumber.TextBounds.X, BoxPos.Y - 2)
						else
							HealthNumber.Position = Vector2.new(BoxPos.X - 3 - (HealthNumber.TextBounds.X / 2) - 4, BoxPos.Y - 2)
						end
						HealthNumber.Color = library.flags["ESPC_HNum"]
						HealthNumber.Font = Drawing.Fonts[library.flags["ESP_Font"]]
						HealthNumber.Size = library.flags["ESP_Size"]
						HealthNumber.Visible = true
						HealthNumber.Outline = library.flags["ESP_Out"]
						if library.flags["ESP_Bold"] then
							HealthNumberB.Text = tostring(math.round(Humanoid.Health))
							if library.flags["ESP_HealthB"] then
								HealthNumberB.Position = Vector2.new(BoxPos.X - 2 - HealthNumber.TextBounds.X, BoxPos.Y - 2)
							else
								HealthNumberB.Position = Vector2.new(BoxPos.X - 2 - (HealthNumber.TextBounds.X / 2) - 3, BoxPos.Y - 2)
							end
							HealthNumberB.Color = library.flags["ESPC_HNum"]
							HealthNumberB.Font = Drawing.Fonts[library.flags["ESP_Font"]]
							HealthNumberB.Size = library.flags["ESP_Size"]
							HealthNumberB.Visible = true
							HealthNumberB.Outline = false
						end
					end

					if library.flags["ESP_Tracers"] then
						Tracers.From = Vector2.new(BoxSize.X / 2 + BoxPos.X, BoxPos.Y + BoxSize.Y)
						Tracers.To = Vector2.new(960, 1080)
						Tracers.Color = library.flags["ESPC_Tracers"]
						Tracers.Visible = true
					end

					if library.flags["ESP_Head"] then
						if Head then
							HeadDot.Radius = Dif * 2
							HeadDot.Visible = true
							HeadDot.Position = Vector2.new(HeadPosA.x, HeadPosAB.y - Dif)
							HeadDot.Color = library.flags["ESPC_Head"]
						end
					end
				end
			else
				if isAlive(Player) and Player.Character:FindFirstChildOfClass("Highlight") then
					Player.Character:FindFirstChildOfClass("Highlight"):Destroy()
				end
				if PLRDS[Player] then
					for i, v in pairs(PLRDS[Player]) do
						if v.Visible ~= false then
							v.Visible = false
						end
					end
				end
			end

			if library.flags["ESP_Enabled"] and PLRDS[Player] and Player == LocalPlayer then
				local PLRD = PLRDS[Player]
				for _,v in pairs (PLRD) do
					v.Visible = false
				end

				local Character = Player.Character
				local RootPart, Humanoid = Character and Character:FindFirstChild("HumanoidRootPart"), Character and Character:FindFirstChildOfClass("Humanoid")
				if Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then
					if Humanoid then
						if Humanoid.Health <= 0 then
							continue
						end
					end
				end

				local Head = Player.Character:FindFirstChild("Head")
				local poser = Camera:WorldToViewportPoint(Head.Position)
				local mousePos = V2(UserInputService:GetMouseLocation().x, UserInputService:GetMouseLocation().y, 0)
				local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
				local DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. "m"
				local alivecheck = true
				
				if Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then
					if Humanoid then
						if game.PlaceId == 4991214437 then
							if alivecheck and Humanoid.Health <= 1 then
								continue
							end
						else
							if alivecheck and Humanoid.Health <= 0 then
								continue
							end
						end
					end
				end
				if library.flags["ESP_TMode"] == "Normal" then
					DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. "m"
				elseif library.flags["ESP_TMode"] == "lowercase" then
					DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. string.lower("m")
				elseif library.flags["ESP_TMode"] == "UPPERCASE" then
					DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. string.upper("m")
				end
				local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
				if library.flags["ESPL_Chams"] then
					if Player.Character:FindFirstChildWhichIsA("Highlight") == nil then
						local highlight = Instance.new("Highlight", Player.Character)
					end
					Player.Character.Highlight.FillColor = library.flags["ESPCL_ChamsF"]
					Player.Character.Highlight.OutlineTransparency = esp.ChamsOL
					Player.Character.Highlight.FillTransparency = esp.ChamsFL
					Player.Character.Highlight.OutlineColor = library.flags["ESPCL_ChamsO"]
				else
					if Player.Character:FindFirstChildWhichIsA("Highlight") then
						Player.Character:FindFirstChildWhichIsA("Highlight"):Destroy()
					end
				end

				local IhateMyLifeSize = (Camera:WorldToViewportPoint(RootPart.Position - V3(0, 3, 0)).Y - Camera:WorldToViewportPoint(RootPart.Position + V3(0, 2.6, 0)).Y) / 2
				local BoxSize = Vector2.new(math.floor(IhateMyLifeSize * 1.2), math.floor(IhateMyLifeSize * 2))
				local BoxPos = Vector2.new(math.floor(Pos.X - IhateMyLifeSize * 1 / 2), math.floor(Pos.Y - IhateMyLifeSize * 1.6 / 2))
				local HeadPos = Head.Position
				local HeadPosA = workspace.CurrentCamera:WorldToViewportPoint(V3(HeadPos.x, HeadPos.y + 0.1, HeadPos.z))
				local HeadPosAB = workspace.CurrentCamera:WorldToViewportPoint(V3(HeadPos.x, HeadPos.y - 0.2, HeadPos.z))
				local Dif = HeadPosAB.y - HeadPosA.y
				local Name = PLRD.Name
				local Distance = PLRD.Distance
				local Box = PLRD.Box
				local Tracers = PLRD.Tracers
				local HeadDot = PLRD.HeadDot
				local BoxOutline = PLRD.BoxOutline
				local Health = PLRD.Health
				local HealthOutline = PLRD.HealthOutline
				local HealthNumber = PLRD.HealthNumber
				local HealthNumberB = PLRD.HealthNumberB
				local BoxFill = PLRD.BoxFill   
				--local FovTracer = PLRD.FovTracers 
				local Tool = PLRD.Tool 
				local DistanceB = PLRD.DistanceB
				local NameB = PLRD.NameB
				local ToolB = PLRD.ToolB
				local Health2 = PLRD.Health2
				local HealthOutline2 = PLRD.HealthOutline2
				local Y_off = BoxSize.Y + BoxPos.Y + 1
				
				local ptool = Player.Character:FindFirstChildOfClass("Tool") and Player.Character:FindFirstChildOfClass("Tool").Name

				if library.flags["ESPL_Tool"] then
					if ptool ~= nil then
						if library.flags["ESP_TMode"] == "Normal" then
							Tool.Text = ptool
						elseif library.flags["ESP_TMode"] == "lowercase" then
							Tool.Text = string.lower(ptool)
						elseif library.flags["ESP_TMode"] == "UPPERCASE" then
							Tool.Text = string.upper(ptool)
						end
						Tool.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, Y_off)
						Tool.Color = library.flags["ESPCL_Tool"]
						Tool.Font = Drawing.Fonts[library.flags["ESP_Font"]]
						Tool.Size = library.flags["ESP_Size"]
						Tool.Visible = true
						Tool.Outline = library.flags["ESP_Out"]
						if library.flags["ESP_Bold"] then
							if library.flags["ESP_TMode"] == "Normal" then
								ToolB.Text = ptool
							elseif library.flags["ESP_TMode"] == "lowercase" then
								ToolB.Text = string.lower(ptool)
							elseif library.flags["ESP_TMode"] == "UPPERCASE" then
								ToolB.Text = string.upper(ptool)
							end
							ToolB.Position = Vector2.new(BoxSize.X/2 + BoxPos.X + 1, Y_off)
							ToolB.Color = library.flags["ESPCL_Tool"]
							ToolB.Font = Drawing.Fonts[library.flags["ESP_Font"]]
							ToolB.Size = library.flags["ESP_Size"]
							ToolB.Visible = true
							ToolB.Outline = false
						end
						Y_off += 15
					end
				end

				if library.flags["ESPL_Box"] then
					Box.Size = BoxSize
					Box.Position = BoxPos
					Box.Visible = true
					--[[if library.flags.tt and tname == "["..Player.DisplayName.."]" then
						Box.Color = library.flags.tcol
					else]]
						Box.Color = library.flags["ESPCL_Box"]
					--end

					if library.flags["ESP_Out"] then
						BoxOutline.Size = BoxSize
						BoxOutline.Position = BoxPos
						BoxOutline.Visible = true
					end
					
					BoxFill.Filled = true
					BoxFill.Visible = true
					BoxFill.Size = Vector2.new(math.floor(IhateMyLifeSize * 1.2 - 2), math.floor(IhateMyLifeSize * 2 - 2))
					BoxFill.Position = Vector2.new(math.floor(Pos.X - IhateMyLifeSize * 1 / 2 + 1), math.floor(Pos.Y - IhateMyLifeSize * 1.6 / 2 + 1))
					BoxFill.Color = library.flags["ESPCL_BoxF"]
					BoxFill.Transparency = esp.BoxFillL
				end

				if library.flags["ESPL_Name"] then
					if library.flags["ESP_TMode"] == "Normal" then
						Name.Text = Player.DisplayName
					elseif library.flags["ESP_TMode"] == "lowercase" then
						Name.Text = string.lower(Player.DisplayName)
					elseif library.flags["ESP_TMode"] == "UPPERCASE" then
						Name.Text = string.upper(Player.DisplayName)
					end
					Name.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X, BoxPos.Y - 5 - Name.TextBounds.Y)
					Name.Color = library.flags["ESPCL_Name"]
					Name.Font = Drawing.Fonts[library.flags["ESP_Font"]]
					Name.Size = library.flags["ESP_Size"]
					Name.Visible = true
					Name.Outline = library.flags["ESP_Out"]
					if library.flags["ESP_Bold"] then
						if library.flags["ESP_TMode"] == "Normal" then
							NameB.Text = Player.DisplayName
						elseif library.flags["ESP_TMode"] == "lowercase" then
							NameB.Text = string.lower(Player.DisplayName)
						elseif library.flags["ESP_TMode"] == "UPPERCASE" then
							NameB.Text = string.upper(Player.DisplayName)
						end
						NameB.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X + 1, BoxPos.Y - 5 - Name.TextBounds.Y)
						NameB.Color = library.flags["ESPCL_Name"]
						NameB.Font = Drawing.Fonts[library.flags["ESP_Font"]]
						NameB.Size = library.flags["ESP_Size"]
						NameB.Visible = true
						NameB.Outline = false
					end
				end

				if library.flags["ESPL_HealthB"] then  
					Health.From = Vector2.new((BoxPos.X - 5), BoxPos.Y + BoxSize.Y)
					Health.To = Vector2.new((BoxPos.X - 5), Health.From.Y - (Humanoid.Health / Humanoid.MaxHealth) * BoxSize.Y)
					Health.Color = library.flags["ESPCL_HealthB"] 
					Health.Visible = true

					Health2.From = Vector2.new((BoxPos.X - 6), BoxPos.Y + BoxSize.Y)
					Health2.To = Vector2.new((BoxPos.X - 6), Health.From.Y - (Humanoid.Health / Humanoid.MaxHealth) * BoxSize.Y)
					Health2.Color = library.flags["ESPCL_HealthB"]
					Health2.Visible = true

					if library.flags["ESP_Out"] then
						HealthOutline.From = Vector2.new(Health.From.X, BoxPos.Y + BoxSize.Y + 1)
						HealthOutline.To = Vector2.new(Health.From.X, (Health.From.Y - 1 * BoxSize.Y) -1)
						HealthOutline.Visible = true

						HealthOutline2.From = Vector2.new(Health.From.X - 2, BoxPos.Y + BoxSize.Y + 1)
						HealthOutline2.To = Vector2.new(Health.From.X - 2, (Health.From.Y - 1 * BoxSize.Y) -1)
						HealthOutline2.Visible = true
						HealthOutline2.Thickness = 1
						HealthOutline2.Color = Color3.new(0, 0, 0)
					end
				end

				if library.flags["ESPL_HNum"] and math.floor(Humanoid.Health) <= library.flags["ESP_HP"] then
					HealthNumber.Text = tostring(math.round(Humanoid.Health))
					if library.flags["ESPL_HealthB"] then
						HealthNumber.Position = Vector2.new(BoxPos.X - 3 - HealthNumber.TextBounds.X, BoxPos.Y - 2)
					else
						HealthNumber.Position = Vector2.new(BoxPos.X - 3 - (HealthNumber.TextBounds.X / 2) - 4, BoxPos.Y - 2)
					end
					HealthNumber.Color = library.flags["ESPCL_HNum"]
					HealthNumber.Font = Drawing.Fonts[library.flags["ESP_Font"]]
					HealthNumber.Size = library.flags["ESP_Size"]
					HealthNumber.Visible = true
					HealthNumber.Outline = library.flags["ESP_Out"]
					if library.flags["ESP_Bold"] then
						HealthNumberB.Text = tostring(math.round(Humanoid.Health))
						if library.flags["ESPL_HealthB"] then
							HealthNumberB.Position = Vector2.new(BoxPos.X - 2 - HealthNumber.TextBounds.X, BoxPos.Y - 2)
						else
							HealthNumberB.Position = Vector2.new(BoxPos.X - 2 - (HealthNumber.TextBounds.X / 2) - 3, BoxPos.Y - 2)
						end
						HealthNumberB.Color = library.flags["ESPCL_HNum"]
						HealthNumberB.Font = Drawing.Fonts[library.flags["ESP_Font"]]
						HealthNumberB.Size = library.flags["ESP_Size"]
						HealthNumberB.Visible = true
						HealthNumberB.Outline = false
					end
				end

				if library.flags["ESPL_Head"] then
					if Head then
						HeadDot.Radius = Dif * 2
						HeadDot.Visible = true
						HeadDot.Position = Vector2.new(HeadPosA.x, HeadPosAB.y - Dif)
						HeadDot.Color = library.flags["ESPCL_Head"]
					end
				end
			end
		end

		crosshair.leftb.Visible = library.flags["Crosshair_Enabled"] and library.flags["Crosshair_Border"]
		crosshair.leftb.Size = Vector2.new(library.flags["CrosshairL"] + 2, math.round(library.flags["CrosshairT"]) + 2)
		crosshair.leftb.Position = Vector2.new((ScreenSize.X / 2) - library.flags["CrosshairL"] - library.flags["CrosshairG"] - 1, (ScreenSize.Y / 2) - (math.round(library.flags["CrosshairT"]) / 2) - 1)
		crosshair.leftb.Color = library.flags["CrosshairCO"]

		crosshair.rightb.Visible = library.flags["Crosshair_Enabled"] and library.flags["Crosshair_Border"]
		crosshair.rightb.Size = Vector2.new(library.flags["CrosshairL"] + 2, math.round(library.flags["CrosshairT"]) + 2)
		crosshair.rightb.Position = Vector2.new((ScreenSize.X / 2) + library.flags["CrosshairG"] - 1, (ScreenSize.Y / 2) - (math.round(library.flags["CrosshairT"]) / 2) - 1)
		crosshair.rightb.Color = library.flags["CrosshairCO"]

		crosshair.topb.Visible = library.flags["Crosshair_Enabled"] and library.flags["Crosshair_Border"]
		crosshair.topb.Size = Vector2.new(math.round(library.flags["CrosshairT"]) + 2, library.flags["CrosshairL"] + 2)
		crosshair.topb.Position = Vector2.new((ScreenSize.X / 2) - (math.round(library.flags["CrosshairT"]) / 2) - 1, (ScreenSize.Y / 2) - library.flags["CrosshairL"] - library.flags["CrosshairG"] - 1)
		crosshair.topb.Color = library.flags["CrosshairCO"]

		crosshair.bottomb.Visible = library.flags["Crosshair_Enabled"] and library.flags["Crosshair_Border"]
		crosshair.bottomb.Size = Vector2.new(math.round(library.flags["CrosshairT"]) + 2, library.flags["CrosshairL"] + 2)
		crosshair.bottomb.Position = Vector2.new((ScreenSize.X / 2) - (math.round(library.flags["CrosshairT"]) / 2) - 1, (ScreenSize.Y / 2) + library.flags["CrosshairG"] - 1)
		crosshair.bottomb.Color = library.flags["CrosshairCO"]

		crosshair.left.Visible = library.flags["Crosshair_Enabled"]
		crosshair.left.Size = Vector2.new(library.flags["CrosshairL"], math.round(library.flags["CrosshairT"]))
		crosshair.left.Position = Vector2.new((ScreenSize.X / 2) - library.flags["CrosshairL"] - library.flags["CrosshairG"], (ScreenSize.Y / 2) - (math.round(library.flags["CrosshairT"]) / 2))
		crosshair.left.Color = library.flags["CrosshairC"]

		crosshair.right.Visible = library.flags["Crosshair_Enabled"]
		crosshair.right.Size = Vector2.new(library.flags["CrosshairL"], math.round(library.flags["CrosshairT"]))
		crosshair.right.Position = Vector2.new((ScreenSize.X / 2) + library.flags["CrosshairG"], (ScreenSize.Y / 2) - (math.round(library.flags["CrosshairT"]) / 2))
		crosshair.right.Color = library.flags["CrosshairC"]

		crosshair.top.Visible = library.flags["Crosshair_Enabled"]
		crosshair.top.Size = Vector2.new(math.round(library.flags["CrosshairT"]), library.flags["CrosshairL"])
		crosshair.top.Position = Vector2.new((ScreenSize.X / 2) - (math.round(library.flags["CrosshairT"]) / 2), (ScreenSize.Y / 2) - library.flags["CrosshairL"] - library.flags["CrosshairG"])
		crosshair.top.Color = library.flags["CrosshairC"]

		crosshair.bottom.Visible = library.flags["Crosshair_Enabled"]
		crosshair.bottom.Size = Vector2.new(math.round(library.flags["CrosshairT"]), library.flags["CrosshairL"])
		crosshair.bottom.Position = Vector2.new((ScreenSize.X / 2) - (math.round(library.flags["CrosshairT"]) / 2), (ScreenSize.Y / 2) + library.flags["CrosshairG"])
		crosshair.bottom.Color = library.flags["CrosshairC"]
	end
	--!SECTION

	--SECTION ETC
	local function ETC(step)
		StatText.Text = string.format("Network Send: %s kbps\nNetwork Recieve: %s kbps\nFPS: %s\nTick: %s", math.floor(game.Stats.PhysicsSendKbps), math.floor(game.Stats.PhysicsReceiveKbps), math.floor(1/step), math.floor(tick()))

		if library.flags["cheatt"] then
			title = library.flags["cheatname"]
		else
			title = "alsike"
		end

		Watermark.Text.Text = string.format("%s | v2.6 [dev] | FPS: %s | Ping: %sms", title, math.floor(1/step), math.floor(game:GetService('Stats').Network.ServerStatsItem["Data Ping"]:GetValue()))

		Watermark.Border.Position = V2(10, 10)
		Watermark.Accent.Position = Watermark.Border.Position + V2(1, 1)
		Watermark.Border2.Position = Watermark.Accent.Position + V2(1, 1)
		Watermark.Background.Position = Watermark.Border2.Position + V2(1, 1)
		Watermark.Gradient.Position = Watermark.Border2.Position + V2(1, 1)
	
		Watermark.Border.Size = V2(Watermark.Text.TextBounds.X + 16, Watermark.Text.TextBounds.Y + 16)
		Watermark.Accent.Size = V2(Watermark.Text.TextBounds.X + 14, Watermark.Text.TextBounds.Y + 14)
		Watermark.Border2.Size = V2(Watermark.Text.TextBounds.X + 12, Watermark.Text.TextBounds.Y + 12)
		Watermark.Background.Size = V2(Watermark.Text.TextBounds.X + 10, Watermark.Text.TextBounds.Y + 10)
		Watermark.Gradient.Size = V2(Watermark.Text.TextBounds.X + 10, Watermark.Text.TextBounds.Y + 10)
	
		Watermark.Text.Position = Watermark.Background.Position + V2(5, 5)

		Theme.Accent = library.flags["Menu Accent Color"]
		Theme.Border = library.flags["Border Color"]
		Theme.Border2 = library.flags["Inline Color"]
		Theme.Background = library.flags["Background Color"]
		Theme.TextColor = library.flags["Text Color"]
		Theme.TextOutline = library.flags["Text Border Color"]

		Watermark.Background.Color = Theme.Background
		Watermark.Border.Color = Theme.Border
		Watermark.Border2.Color = Theme.Border2
		Watermark.Text.Color = Theme.TextColor
		Watermark.Text.OutlineColor = Theme.TextOutline
		Watermark.Accent.Color = Theme.Accent
	end
	--!SECTION

	--!SECTION

	--SECTION Main Loop

	library:AddConnection(runService.RenderStepped, function(step)
		do Combat(step) end
		do Visuals() end
		do Misc(step) end
		do ETC(step) end
	end)

	--!SECTION

	--SECTION Settings Tab

	local function SettingsTab()
		library.SettingsTab             = library:AddTab("Settings", 1252352135)
		library.SettingsColumn          = library.SettingsTab:AddColumn()
		library.SettingsColumn1         = library.SettingsTab:AddColumn()

		library.SettingsMenu = library.SettingsColumn:AddSection"Menu"
		library.SettingsMenu:AddBind({text = "Open / Close", flag = "UI Toggle", nomouse = true, key = "RightShift", callback = function() library:Close() end})
		library.SettingsMenu:AddColor({text = "Accent Color", flag = "Menu Accent Color", color = Color3.fromRGB(30, 60, 150), callback = function(Color)
			if library.currentTab then
				library.currentTab.button.TextColor3 = Color
			end
			for _, obj in next, library.theme do
				obj[(obj.ClassName == "TextLabel" and "TextColor3") or (obj.ClassName == "ImageLabel" and "ImageColor3") or "BackgroundColor3"] = Color
			end
		end})
		library.SettingsMenu:AddColor({text = "Border Color", flag = "Border Color", color = Color3.fromRGB(0, 0, 0)})
		library.SettingsMenu:AddColor({text = "Inline Color", flag = "Inline Color", color = Color3.fromRGB(60, 60, 60)})
		library.SettingsMenu:AddColor({text = "Background Color", flag = "Background Color", color = Color3.fromRGB(45, 45, 45)})
		library.SettingsMenu:AddColor({text = "Text Color", flag = "Text Color", color = Color3.fromRGB(255, 255, 255)})
		library.SettingsMenu:AddColor({text = "Text Border Color", flag = "Text Border Color", color = Color3.fromRGB(0, 0, 0)})

		local Backgrounds = {
			["Floral"] = 5553946656,
			["Flowers"] = 6071575925,
			["Circles"] = 6071579801,
			["Hearts"] = 6073763717,
			["Polka dots"] = 6214418014,
			["Mountains"] = 6214412460,
			["Zigzag"] = 6214416834,
			["Zigzag 2"] = 6214375242,
			["Tartan"] = 6214404863,
			["Roses"] = 6214374619,
			["Hexagons"] = 6214320051,
			["Leopard print"] = 6214318622
		}
		library.SettingsMenu:AddList({text = "Background", flag = "UI Background", max = 6, values = {"Floral", "Flowers", "Circles", "Hearts", "Polka dots", "Mountains", "Zigzag", "Zigzag 2", "Tartan", "Roses", "Hexagons", "Leopard print"}, callback = function(Value)
			if Backgrounds[Value] then
				library.main.Image = "rbxassetid://" .. Backgrounds[Value]
			end
		end}):AddColor({flag = "Menu Background Color", color = Color3.new(), callback = function(Color)
			library.main.ImageColor3 = Color
		end, trans = 1, calltrans = function(Value)
			library.main.ImageTransparency = 1 - Value
		end})
		library.SettingsMenu:AddSlider({text = "Tile Size", textpos = 16, value = 90, min = 50, max = 500, callback = function(Value)
			library.main.TileSize = UDim2.new(0, Value, 0, Value)
		end})
		library.SettingsMenu:AddToggle({text = "Custom Cheat Name", flag = "cheatt"})
		library.SettingsMenu:AddBox({text = "Cheat Name", flag = "cheatname", value = "alsike"})

		
		library.SettingsMain = library.SettingsColumn:AddSection"Main"
		library.SettingsMain:AddButton({text = "Unload Cheat", nomouse = true, callback = function()
			library:Unload()
			getgenv().Alsike = nil
		end})
		library.SettingsMain:AddBind({text = "Panic Key", callback = library.options["Unload Cheat"].callback})
		library.SettingsMain:AddButton({text = "Copy Job Id", callback = function()
			createEventLog(string.format("Copied Job Id (%s).", game.JobId), 5)
			setclipboard(game.JobId)
		end})

		library.ConfigSection = library.SettingsColumn1:AddSection"Configs"
		library.ConfigSection:AddBox({text = "Config Name", skipflag = false})
		library.ConfigWarning = library:AddWarning({type = "confirm"})
		library.ConfigSection:AddList({text = "Configs",  value = "", flag = "Config List", values = library:GetConfigs()})
		library.ConfigSection:AddButton({text = "Create", callback = function()
			library:GetConfigs()
			writefile(""..library.foldername.."/" ..library.configgame.."/".. library.flags["Config Name"] .. library.fileext, "{}")
			createEventLog(string.format("Successfully created config (%s%s).", library.flags["Config Name"], library.fileext), 5)
			library.options["Config List"]:AddValue(library.flags["Config Name"])
		end})
		library.ConfigSection:AddButton({text = "Save", callback = function()
			local r, g, b = library.round(library.flags["Menu Accent Color"])
			library.ConfigWarning.text = "Are you sure you want to save the current settings to config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?"
			if library.ConfigWarning:Show() then
				createEventLog(string.format("Successfully saved config (%s%s).", library.flags["Config List"], library.fileext), 5)
				library:SaveConfig(library.flags["Config List"])
			end
		end})
		library.ConfigSection:AddButton({text = "Load", callback = function()
			local r, g, b = library.round(library.flags["Menu Accent Color"])
			library.ConfigWarning.text = "Are you sure you want to load config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?"
			if library.ConfigWarning:Show() then
				createEventLog(string.format("Successfully loaded config (%s%s).", library.flags["Config List"], library.fileext), 5)
				library:LoadConfig(library.flags["Config List"])
			end
		end})
		library.ConfigSection:AddButton({text = "Delete", callback = function()
			local r, g, b = library.round(library.flags["Menu Accent Color"])
			library.ConfigWarning.text = "Are you sure you want to delete config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?"
			if library.ConfigWarning:Show() then
				local Config = library.flags["Config List"]
				if table.find(library:GetConfigs(), Config) and isfile(library.foldername .. "/" .. Config .. library.fileext) then
					createEventLog(string.format("Successfully deleted config (%s%s).", library.flags["Config List"], library.fileext), 5)
					library.options["Config List"]:RemoveValue(Config)
					delfile(""..library.foldername.."/" ..library.configgame.. Config .. library.fileext)
				end
			end
		end})
	end
	SettingsTab()

	createEventLog(string.format("Welcome to alsike %s\nCurrent version is 3.2 [in-dev]\nExecuted at: %s", LocalPlayer.Name, os.date("%I:%M:%S", os.time())), 10)
	createEventLog("Press RightShift to open/close menu.", 5)

	--!SECTION

	library:Init()
end

function Watermarke()
    for i,v in pairs(Watermark) do	
        if v ~= nil then
            v:Remove()
        end
    end
end

getgenv().Watermarke = Watermarke