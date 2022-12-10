local Ut = {}

Ut.AutoDo = { -- If we use this table and dont need to set anything in the loop it will give us more fps.
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
        Transparency = 0.5,
        Visible = true,
        Data = game:HttpGet("https://i.imgur.com/2KZqAOV.png"),
    },
}

function Ut.New(data)
	local drawing = Drawing.new(data.type)

	for i, v in pairs(Ut.AutoDo[data.type]) do
		drawing[i] = v
	end

	if data.type == "Square" then
		if not data.filled then
			drawing.Filled = false
		elseif data.filled then
			drawing.Filled = true
		end
	end

    drawing.ZIndex = -1

	if data.out then
		drawing.Color = Color3.new(0,0,0)
		drawing.Thickness = 3
	end
	return drawing
end

if loop then
    for i,v in pairs(Watermark) do
        v:Remove()
    end

    loop:Disconnect()
end


local Watermark = {
    Border = Ut.New({type = "Square"}),
    Background = Ut.New({type = "Square"}),
    Accent = Ut.New({type = "Square"}),
    Accent2 = Ut.New({type = "Square"}),
    BorderLine = Ut.New({type = "Square"}),
    Gradient = Ut.New({type = "Image"}),
    Text = Ut.New({type = "Text"}),
    Icon = Ut.New({type = "Image"}),
}

Watermark.Icon.Data = game:HttpGet("https://i.imgur.com/0TNxXJG.png")

loop = game.RunService.RenderStepped:Connect(function(step)
    if Watermark.Text.Text ~= "shambles haxx | " ..math.floor(1/step) then
        Watermark.Text.Text = "shambles haxx | " ..math.floor(1/step)
    end

    if Watermark.Text.Position ~= Vector2.new(143, 17) then
        Watermark.Text.Position = Vector2.new(143, 17)
    end

    if Watermark.Text.Visible ~= Toggles.InterfaceWatermark.Value then
        Watermark.Text.Visible = Toggles.InterfaceWatermark.Value
    end
    
    if Watermark.Text.Center ~= false then
        Watermark.Text.Center = false
    end

    if Watermark.Border.Color ~= Color3.fromRGB(0, 0, 0) then
        Watermark.Border.Color = Color3.fromRGB(0, 0, 0)
    end

    if Watermark.Border.Position ~= Vector2.new(115, 8) then
        Watermark.Border.Position = Vector2.new(115, 8)
    end

    if Watermark.Border.Filled ~= true then
        Watermark.Border.Filled = true
    end

    if Watermark.Border.Visible ~= Toggles.InterfaceWatermark.Value then
        Watermark.Border.Visible = Toggles.InterfaceWatermark.Value
    end
    
    Watermark.Border.Size = Vector2.new(Watermark.Text.TextBounds.X + 31, Watermark.Text.TextBounds.Y + 17)


    if Watermark.Background.Color ~= Color3.fromRGB(25, 25, 25) then
        Watermark.Background.Color = Color3.fromRGB(25, 25, 25)
    end

    if Watermark.Background.Position ~= Vector2.new(116, 9) then
        Watermark.Background.Position = Vector2.new(116, 9)
    end

    if Watermark.Background.Filled ~= true then
        Watermark.Background.Filled = true
    end

    if Watermark.Background.Visible ~= Toggles.InterfaceWatermark.Value then
        Watermark.Background.Visible = Toggles.InterfaceWatermark.Value
    end

    Watermark.Background.Size = Vector2.new(Watermark.Text.TextBounds.X + 29, Watermark.Text.TextBounds.Y + 15)


    if Watermark.Gradient.Position ~= Vector2.new(116, 9) then
        Watermark.Gradient.Position = Vector2.new(116, 9)
    end

    if Watermark.Gradient.Visible ~= Toggles.InterfaceWatermark.Value then
        Watermark.Gradient.Visible = Toggles.InterfaceWatermark.Value
    end

    Watermark.Gradient.Size = Vector2.new(Watermark.Text.TextBounds.X + 29, Watermark.Text.TextBounds.Y + 15)

    if Watermark.Accent.Color ~= Color3.fromRGB(0, 153, 255) then
        Watermark.Accent.Color = Color3.fromRGB(0, 153, 255)
    end

    if Watermark.Accent.Position ~= Vector2.new(116, 9) then
        Watermark.Accent.Position = Vector2.new(116, 9)
    end

    if Watermark.Accent.Filled ~= true then
        Watermark.Accent.Filled = true
    end

    if Watermark.Accent.Visible ~= Toggles.InterfaceWatermark.Value then
        Watermark.Accent.Visible = Toggles.InterfaceWatermark.Value
    end

    Watermark.Accent.Size = Vector2.new(Watermark.Text.TextBounds.X + 29, 1)

    if Watermark.Accent2.Color ~= Color3.fromRGB(0 - 40, 153 - 40, 255 - 40) then
        Watermark.Accent2.Color = Color3.fromRGB(0 - 40, 153 - 40, 255 - 40)
    end

    if Watermark.Accent2.Position ~= Vector2.new(116, 10) then
        Watermark.Accent2.Position = Vector2.new(116, 10)
    end

    if Watermark.Accent2.Filled ~= true then
        Watermark.Accent2.Filled = true
    end

    if Watermark.Accent2.Visible ~= Toggles.InterfaceWatermark.Value then
        Watermark.Accent2.Visible = Toggles.InterfaceWatermark.Value
    end

    Watermark.Accent2.Size = Vector2.new(Watermark.Text.TextBounds.X + 29, 1)

    if Watermark.BorderLine.Color ~= Color3.fromRGB(0, 0, 0) then
        Watermark.BorderLine.Color = Color3.fromRGB(0, 0, 0)
    end

    if Watermark.BorderLine.Position ~= Vector2.new(116, 11) then
        Watermark.BorderLine.Position = Vector2.new(116, 11)
    end

    if Watermark.BorderLine.Filled ~= true then
        Watermark.BorderLine.Filled = true
    end

    if Watermark.BorderLine.Visible ~= Toggles.InterfaceWatermark.Value then
        Watermark.BorderLine.Visible = Toggles.InterfaceWatermark.Value
    end

    Watermark.BorderLine.Size = Vector2.new(Watermark.Text.TextBounds.X + 29, 1)

    if Watermark.Icon.Position ~= Vector2.new(116, 12) then
        Watermark.Icon.Position = Vector2.new(116, 12)
    end

    if Watermark.Icon.Visible ~= Toggles.InterfaceWatermark.Value then
        Watermark.Icon.Visible = Toggles.InterfaceWatermark.Value
    end

    if Watermark.Icon.Size ~= Vector2.new(25, 25) then
        Watermark.Icon.Size = Vector2.new(25, 25)
    end
    
end)