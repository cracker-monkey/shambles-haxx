if esp then
    esp:unload()
end

local v2 = Vector2.new
local v3 = Vector3.new
local c3 = Color3.fromRGB
local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local RunService = game.RunService
local Camera = workspace.Camera

local Enum = {
    Position = {
        Top = "top",
        Bottom = "bottom",
        Left = "left",
        Right = "right",
    },
}

local esp = {
    enabled = true,
    teamcheck = false,
    displayname = false,
    localplayer = true,
    limitdistance = false,
    distance = 500,
    arrowdistance = 50,
    arrowsize = 8,
    font = 2,
    size = 13,
    distancetext = "m",
    outline = {true, c3(0, 0, 0)},
    box = {true, c3(255, 255, 255)},
    boxfill = {false, c3(255, 255, 255)},
    highlights = {true, c3(0, 187, 255), c3(0, 157, 255), 0, 0.5, false--[[vis only]]},
    oof = {true, c3(255, 255, 255), c3(200, 200, 200), 0, 0.5},
    text = {
        name = {Enum.Position.Top, true, c3(255, 255, 255)},
        distance = {Enum.Position.Bottom, true, c3(255, 255, 255)},
        tool = {Enum.Position.Bottom, true, c3(255, 255, 255)},
        health = {Enum.Position.Left, true, c3(255, 255, 255), true},
    },
    bars = {
        healthbar = {Enum.Position.Left, true, c3(255, 255, 0)},
    },
    players = {},
    connections = {},
}

esp.cache = {
	Line = {
		Thickness = 1,
		Color = Color3.fromRGB(0, 255, 0),
        Transparency = 1,
	},
	Text = {
		Size = 13,
		Center = true,
		Outline = true,
		Font = 2,
		Color = Color3.fromRGB(255, 255, 255),
        Transparency = 1,
	},
	Square = {
		Thickness = 1,
		Color = Color3.fromRGB(255, 255, 255),
		Filled = false,
        Transparency = 1,
	},
	Circle = {
		Filled = false,
		NumSides = 30,
		Thickness = 0,
        Transparency = 1,
	},
	Triangle = {
		Color = Color3.fromRGB(255, 255, 255),
		Filled = true,
		Visible = false,
		Thickness = 1,
        Transparency = 1,
	},
    Image = {
        Transparency = 1,
        Visible = true,
        Data = game:HttpGet("https://i.imgur.com/2KZqAOV.png"),
    },
}

function esp:new(data)
	local drawing = Drawing.new(data.type)

	for i, v in pairs(esp.cache[data.type]) do
		drawing[i] = v
	end

	if data.type == "Square" then
		if not data.filled then
			drawing.Filled = false
		elseif data.filled then
			drawing.Filled = true
		end
	end

	if data.outline then
		drawing.Color = Color3.new(0,0,0)
		drawing.Thickness = 3
	end

    drawing.ZIndex = -1

	return drawing
end

function esp:setprop(drawings, prop, val)
    for i,v in next, drawings do
        if (i == 'text' or i == 'bar' or i =='custombox') then
            for _,v2 in next, v do
                v2[1][prop] = val;
                v2[2][prop] = val;
            end
        elseif i ~= 'highlights' and i ~= 'oof' and v ~= nil then
            v[prop] = val;
        end
    end
end

function esp:addtoplayer(player)
	if not esp.players[player] then
		esp.players[player] = {
			offscreen = esp:new({type = "Triangle"}),
			name = esp:new({type = "Text"}),
			distance = esp:new({type = "Text"}),
			boxoutline = esp:new({type = "Square", outline = true}),
			box = esp:new({type = "Square"}),
			health = esp:new({type = "Text"}),
			healthoutline = esp:new({type = "Line", outline = true}),
			weapon = esp:new({type = "Text"}),
			team = esp:new({type = "Text"}),

            bar = {},            

            ["Head"] = esp:new({type = "Line"}),
            ["Right Arm"] = esp:new({type = "Line"}),
            ["Right Leg"] = esp:new({type = "Line"}),
            ["Left Leg"] = esp:new({type = "Line"}),
            ["Left Arm"] = esp:new({type = "Line"}),
		}

        for i,v in pairs(esp.bars) do
            esp.players[player].bar[i] = {esp:new({type = "Square"}), esp:new({type = "Square"})}
        end
	end
end

function esp:removeplayer(player)
    if esp.players[player] then
        for i,v in pairs(esp.players[player]) do
            if i == "bar" and i ~= "healthbar" then
                for i2,v2 in next, v do
                    v2[1]:Remove();
                    v2[2]:Remove();
                end
            else
                if v ~= nil then
                    v:Remove()
                end
            end
        end

        esp.players[player] = nil
    end
end

function esp:getcharacter(player)
    if game.PlaceId == 292439477 then
        if player == LocalPlayer and fake_rep_object ~= nil then
            if fake_rep_object._thirdPersonObject ~= nil then
                return fake_rep_object._thirdPersonObject._character
            end
        else
            local entry = game_client.replication_interface.getEntry(player)

            if entry then
                local third_person_object = entry._thirdPersonObject
                if third_person_object then
                    return third_person_object._character
                end
            end
        end
    else
        if player.Character ~= nil then
            return player.Character
        end
    end

    return nil
end

function esp:getweapon(player)
    if game.PlaceId == 292439477 then
        if player == LocalPlayer and fake_rep_object ~= nil then
            if fake_rep_object._thirdPersonObject ~= nil then
                return fake_rep_object._thirdPersonObject._weaponname or ""
            end
        else
            local entry = game_client.replication_interface.getEntry(player)

            if entry then
                local third_person_object = entry._thirdPersonObject
                if third_person_object then
                    return third_person_object._weaponname or ""
                end
            end
        end
    else
        if esp:getcharacter(player):FindFirstChildWhichIsA("Tool") then
            return esp:getcharacter(player):FindFirstChildWhichIsA("Tool")
        end
    end

    return nil
end

function esp:gethealth(player)
    if game.PlaceId == 292439477 then
        if player == LocalPlayer and fake_rep_object ~= nil then
            return fake_rep_object:getHealth()
        else
            local entry = game_client.replication_interface.getEntry(player)

            if entry then
                return entry:getHealth()
            end
        end
    else
        if esp:getcharacter(player):FindFirstChildWhichIsA("Humanoid") then
            return esp:getcharacter(player):FindFirstChildWhichIsA("Humanoid").Health, esp:getcharacter(player):FindFirstChildWhichIsA("Humanoid").MaxHealth
        end
    end
end

function esp:gettorso(char)
    if char:FindFirstChild("HumanoidRootPart") then
        return char.HumanoidRootPart
    elseif char:FindFirstChild("Torso") then
        return char.Torso
    end

    return nil
end

function esp:getsizing(torso)
	local vTop = torso.Position + (torso.CFrame.UpVector * 1.8) + Camera.CFrame.UpVector
    local vBottom = torso.Position - (torso.CFrame.UpVector * 2.5) - Camera.CFrame.UpVector

    local top, topIsRendered = Camera:WorldToViewportPoint(vTop)
    local bottom, bottomIsRendered = Camera:WorldToViewportPoint(vBottom)

    local _width = math.max(math.floor(math.abs(top.x - bottom.x)), 3)
    local _height = math.max(math.floor(math.max(math.abs(bottom.y - top.y), _width / 2)), 3)
    local boxSize = Vector2.new(math.floor(math.max(_height / 1.5, _width)), _height)
    local boxPosition = Vector2.new(math.floor(top.x * 0.5 + bottom.x * 0.5 - boxSize.x * 0.5), math.floor(math.min(top.y, bottom.y)))

    return boxSize, boxPosition
end

function esp:getdistance(torso)
    return math.ceil(LocalPlayer:DistanceFromCharacter(torso.Position) / 5)
end

function esp:playerdata(player)
    local character = esp:getcharacter(player)
    local pos, onscreen = Camera:WorldToViewportPoint(esp:gettorso(character).Position)
    local size, position = esp:getsizing(esp:gettorso(character))
    local alive = isAlive(player)
    local health, maxhealth = esp:gethealth(player)
    return {
        position = position,
        size = size,
        alive = alive,
        character = character,
        pos = pos,
        onscreen = onscreen,
        torso = esp:gettorso(character),
        tool = "",
        health = health,
        maxhealth = maxhealth,
    }
end

function esp:optioninfo(player, data)
    return {
        name = {esp.displayname and player.DisplayName or player.Name},
        health = {tostring(math.floor(data.health))},
        distance = {math.floor(esp:getdistance(data.torso)) ..esp.distancetext},
        tool = {esp:getweapon(player)}
    }, {
        healthbar = {data.health, 0, data.maxhealth, data.health / data.maxhealth}
    }
end

function esp:getteam(player)
    return player.Team
end

function esp:checks(player)
    if player == LocalPlayer and not esp.localplayer then return false end
    local boolean = true
    local character = esp:getcharacter(player)

    if not isAlive(player) then
        boolean = false
    elseif esp.limitdistance and esp:getdistance(esp:gettorso(character)) > esp.maxdistance then
        boolean = false
    elseif esp.teamcheck and esp:getteam(player) == esp:getteam(LocalPlayer) then
        boolean = false
    end

    return boolean
end

function esp:unload()
    for _,v in pairs(esp.connections) do
        if v ~= nil then
            v:Disconnect()
            v = nil
        end
    end

    for _,v in pairs(Players:GetPlayers()) do
        esp:removeplayer(v)
    end

    table.clear(esp)
    esp = nil
end

function ConvertNumberRange(val,oldmin,oldmax,newmin,newmax)
    return (((val - oldmin) * (newmax - newmin)) / (oldmax - oldmin)) + newmin;
end

function isAlive(player)
    if not player then player = LocalPlayer end

    if game.PlaceId == 292439477 then
        if esp:getcharacter(player) and esp:gettorso(esp:getcharacter(player)) then
            return true
        else
            return false
        end
    else
        return player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildWhichIsA("Humanoid").Health > 0 and true or false
    end
end

table.insert(esp.connections, RunService.RenderStepped:Connect(function()
    for i,v in pairs(esp.players) do
        local valid, data = isAlive(i) and esp:checks(i) and esp.enabled == true, nil
        local pos, onscreen

        if valid then
            data = esp:playerdata(i)
            pos, onscreen = data.pos, data.onscreen
        end

        if not (valid and onscreen) then
            esp:setprop(v, "Visible", false)
        end

        if not valid or not onscreen then
            continue
        end

        local character = data.character
        local transparency = esp.limitdistance and (1 - math.clamp(ConvertNumberRange(math.floor((data.cframe.p - camera.CFrame.p).magnitude), esp.maxdistance - 150, esp.maxdistance, 0, 1), 0, 1)) or 1
        local texti, bari = esp:optioninfo(i, data)
        local size, position = data.size, data.position
        local barsizepixel    = 3;
		local padding         = 2;
		local topOptionPos    = 1;
		local bottomOptionPos = 1;
		local leftTextPos     = -1;
		local rightTextPos    = -1;
		local leftBarPos      = 1;
		local rightBarPos     = 1;

        if esp.box[1] then
            v.boxoutline.Size = size
            v.boxoutline.Position = position
            v.boxoutline.Visible = esp.box[1] and esp.outline[1]
            v.boxoutline.Color = esp.outline[2]
            v.boxoutline.Transparency = transparency

            v.box.Size = size
            v.box.Position = position
            v.box.Visible = true
            v.box.Color = esp.box[2]
            v.box.Transparency = transparency
        end
        
        for o,b in pairs(esp.bars) do
            local drawing = v.bar[o]
            local barinfo = bari[o]
            if drawing ~= nil and barinfo ~= nil then
                local vert = b[1] == 'left' or b[1] == 'right'
                drawing[1].Visible = b[2] and esp.outline[1]
                drawing[2].Visible = b[2]
                if drawing[2].Visible then
                    drawing[1].Color = esp.outline[2]
                    drawing[1].Transparency = transparency
                    drawing[1].Filled = true
                    drawing[1].Size = vert and v2(barsizepixel, size.Y + 2) or v2(size.X + 2, barsizepixel)
                    drawing[1].Position =  position + (
                        b[1] == 'left' and v2(- padding - barsizepixel - leftBarPos, -1) or
                        b[1] == 'right' and v2(size.X + padding + rightBarPos, -1) or
                        b[1] == 'top' and v2(-1, - padding - barsizepixel - topOptionPos) or
                        v2(-1, size.Y + padding + bottomOptionPos)
                    )

                    local barSize = ConvertNumberRange(barinfo[1] or 0, barinfo[2], barinfo[3] or 100, 0, (vert and drawing[1].Size.Y or drawing[1].Size.X) - 2);
                    drawing[2].Color = b[3]
                    drawing[2].Transparency = transparency
                    drawing[2].Filled = true
					drawing[2].Position = drawing[1].Position + v2(1, 1) + (vert and v2(0, drawing[1].Size.Y - 2 - barSize) or v2(0, 0));
					drawing[2].Size = vert and v2(barsizepixel - 2, barSize) or v2(barSize, barsizepixel - 2)

                    if b[1] == 'left' then
						leftBarPos = leftBarPos + padding + barsizepixel
					elseif b[1] == 'right'  then
						rightBarPos = rightBarPos + padding + barsizepixel
					elseif b[1] == 'top'    then
						topOptionPos = topOptionPos + padding + barsizepixel
					elseif b[1] == 'bottom' then
						bottomOptionPos = bottomOptionPos + padding + barsizepixel
					end
                end
            end
        end

        for o,b in pairs(esp.text) do
            local drawing = v[o]
            local textinfo = texti[o]
            if drawing ~= nil and textinfo ~= nil then
                drawing.Visible = b[2]
                if drawing.Visible then
                    drawing.Text = tostring(textinfo[1])
                    drawing.Color = b[3]
                    drawing.Transparency = transparency
                    drawing.Outline = esp.outline[1]
                    drawing.OutlineColor = esp.outline[2]
                    drawing.Font = esp.font
                    drawing.Size = esp.size
                    drawing.Center = b[1] == 'top' or b[1] == 'bottom'
                    local tBounds = drawing.TextBounds
                    drawing.Position = position + (
                        b[1] == 'top'    and v2(size.X / 2, - (tBounds.Y + padding + topOptionPos)) or
                        b[1] == 'bottom' and v2(size.X / 2, size.Y + padding + bottomOptionPos) or
                        b[1] == 'left'   and v2(-(tBounds.X + padding + leftBarPos + (esp.outline[1] and 2 or 0)), - (2 + padding) + leftTextPos + padding) or
                        v2(size.X + padding + rightBarPos + (esp.outline[1] and 2 or 0), - (2 + padding) + rightTextPos + padding)
                    )

                    if b[1] == 'top' then
                        topOptionPos = topOptionPos + padding + tBounds.Y
                    elseif b[1] == 'bottom' then
                        bottomOptionPos = bottomOptionPos + padding + tBounds.Y
                    elseif b[1] == 'left' then
                        leftTextPos = leftTextPos + padding + tBounds.Y
                    elseif b[1] == 'right' then
                        rightBarPos = rightBarPos + padding + tBounds.Y
                    end
                end
            end
        end
    end
end))

table.insert(esp.connections, Players.PlayerAdded:Connect(function(player)
    esp:addtoplayer(player)
end))

table.insert(esp.connections, Players.PlayerRemoving:Connect(function(player)
    esp:removeplayer(player)
end))

for _,v in pairs(Players:GetPlayers()) do
    esp:addtoplayer(v)
end

getgenv().esp = esp