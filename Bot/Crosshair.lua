if loop then
    local loop:Disconnect()
    for i,v in pairs (local Crosshair) do
        v:Remove()
    end
end

local Ut = {}

Ut.AutoDo = {
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


local Crosshair = {
    LeftBorder = Ut.New({type = "Line"}),
    RightBorder = Ut.New({type = "Line"}),
    TopBorder = Ut.New({type = "Line"}),
    BottomBorder = Ut.New({type = "Line"}),

    Left = Ut.New({type = "Line"}),
    Right = Ut.New({type = "Line"}),
    Top = Ut.New({type = "Line"}),
    Bottom = Ut.New({type = "Line"}),
}

local settings = {
    gap = 5,
    thick = 3,
    size = 20,
    color = Color3.new(1, 1, 1),
    borderc = Color3.new(0, 0, 0),
    speed = 5,
    spin = true,
}

CursorEsp:AddToggle('CursorEnabled', {Text = 'Enabled'}):AddColorPicker('ColorCursor', {Default = Color3.fromRGB(255, 255, 0), Title = 'Cursor Color'}):AddColorPicker('ColorCursorBorder', {Default = Color3.fromRGB(0, 0, 0), Title = 'Cursor Border Color'})
CursorEsp:AddSlider('CursorSize', {Text = 'Size', Default = 13, Min = 1, Max = 100, Rounding = 0})
CursorEsp:AddSlider('CursorThickness', {Text = 'Thickness', Default = 2, Min = 1, Max = 50, Rounding = 0})
CursorEsp:AddSlider('CursorGap', {Text = 'Gap', Default = 5, Min = 1, Max = 100, Rounding = 0})
CursorEsp:AddToggle('CursorBarrel', {Text = 'Follow Barrel'})
CursorEsp:AddToggle('CursorBorder', {Text = 'Border'})
CursorEsp:AddToggle('CursorSpin', {Text = 'Spin'})
CursorEsp:AddSlider('CursorSpinSpeed', {Text = 'Spin Speed', Default = 5, Min = 1, Max = 50, Rounding = 0})

local CrosshairPos = workspace.Camera.ViewportSize / 2
local currentAngle = 0;

local loop = game.RunService.RenderStepped:Connect(function(step)
    local CrosshairLeft = local Crosshair.Left
    local CrosshairRight = local Crosshair.Right
    local CrosshairTop = local Crosshair.Top
    local CrosshairBottom = local Crosshair.Bottom
    local CrosshairLeftBorder = local Crosshair.LeftBorder
    local CrosshairRightBorder = local Crosshair.RightBorder
    local CrosshairTopBorder = local Crosshair.TopBorder
    local CrosshairBottomBorder = local Crosshair.BottomBorder

    currentAngle = currentAngle + math.rad((Options.CursorSpinSpeed.Value * 10) * step);

    if Toggles.CursorEnabled.Value and game_client.LocalPlayer.isAlive() then
        if CrosshairLeft.Color ~= Options.ColorCursor.Value then
            CrosshairLeft.Color = Options.ColorCursor.Value
        end

        if CrosshairLeft.Visible ~= true then
            CrosshairLeft.Visible = true
        end

        if CrosshairLeft.Thickness ~= Options.CursorThickness.Value then
            CrosshairLeft.Thickness = Options.CursorThickness.Value
        end

        if CrosshairLeftBorder.Color ~= Options.ColorCursorBorder.Value then
            CrosshairLeftBorder.Color = Options.ColorCursorBorder.Value
        end

        if CrosshairLeftBorder.Thickness ~= Options.CursorThickness.Value + 2 then
            CrosshairLeftBorder.Thickness = Options.CursorThickness.Value + 2
        end

        --

        if CrosshairRight.Color ~= Options.ColorCursor.Value then
            CrosshairRight.Color = Options.ColorCursor.Value
        end

        if CrosshairRight.Visible ~= true then
            CrosshairRight.Visible = true
        end

        if CrosshairRight.Thickness ~= Options.CursorThickness.Value then
            CrosshairRight.Thickness = Options.CursorThickness.Value
        end

        if CrosshairRightBorder.Color ~= Options.ColorCursorBorder.Value then
            CrosshairRightBorder.Color = Options.ColorCursorBorder.Value
        end

        if CrosshairRightBorder.Thickness ~= Options.CursorThickness.Value + 2 then
            CrosshairRightBorder.Thickness = Options.CursorThickness.Value + 2
        end
        
        --

        if CrosshairTop.Color ~= Options.ColorCursor.Value then
            CrosshairTop.Color = Options.ColorCursor.Value
        end

        if CrosshairTop.Visible ~= true then
            CrosshairTop.Visible = true
        end

        if CrosshairTop.Thickness ~= Options.CursorThickness.Value then
            CrosshairTop.Thickness = Options.CursorThickness.Value
        end

        if CrosshairTopBorder.Color ~= Options.ColorCursorBorder.Value then
            CrosshairTopBorder.Color = Options.ColorCursorBorder.Value
        end

        if CrosshairTopBorder.Thickness ~= Options.CursorThickness.Value + 2 then
            CrosshairTopBorder.Thickness = Options.CursorThickness.Value + 2
        end

        --

        if CrosshairBottom.Color ~= Options.ColorCursor.Value then
            CrosshairBottom.Color = Options.ColorCursor.Value
        end

        if CrosshairBottom.Visible ~= true then
            CrosshairBottom.Visible = true
        end

        if CrosshairBottom.Thickness ~= Options.CursorThickness.Value then
            CrosshairBottom.Thickness = Options.CursorThickness.Value
        end

        if CrosshairBottomBorder.Color ~= Options.ColorCursorBorder.Value then
            CrosshairBottomBorder.Color = Options.ColorCursorBorder.Value
        end

        if CrosshairBottomBorder.Thickness ~= Options.CursorThickness.Value + 2 then
            CrosshairBottomBorder.Thickness = Options.CursorThickness.Value + 2
        end
        
        if Options.CursorSpin.Value then
            CrosshairLeft.From = CrosshairPos + (Vector2.new(math.cos(currentAngle), math.sin(currentAngle)) * Options.CursorGap.Value)
        
            CrosshairLeft.To = CrosshairLeft.From + (Vector2.new(math.cos(currentAngle), math.sin(currentAngle)) * Options.CursorSize.Value)

            CrosshairLeftBorder.From = CrosshairPos + (Vector2.new(math.cos(currentAngle - 0.01), math.sin(currentAngle - 0.01)) * (Options.CursorGap.Value - 1))
        
            CrosshairLeftBorder.To = CrosshairLeftBorder.From + (Vector2.new(math.cos(currentAngle - 0.01), math.sin(currentAngle - 0.01)) * (Options.CursorSize.Value + 2))

            CrosshairRight.From = CrosshairPos + (Vector2.new(math.cos(currentAngle + math.pi / 2), math.sin(currentAngle + math.pi / 2)) * Options.CursorGap.Value)
        
            CrosshairRight.To = CrosshairRight.From + (Vector2.new(math.cos(currentAngle + math.pi / 2), math.sin(currentAngle + math.pi / 2)) * Options.CursorSize.Value)

            CrosshairRightBorder.From = CrosshairPos + (Vector2.new(math.cos(((currentAngle) - 0.01) + math.pi / 2), math.sin(((currentAngle) - 0.01) + math.pi / 2)) * (Options.CursorGap.Value - 1))
        
            CrosshairRightBorder.To = CrosshairRightBorder.From + (Vector2.new(math.cos(((currentAngle) - 0.01) + math.pi / 2), math.sin(((currentAngle) - 0.01) + math.pi / 2)) * (Options.CursorSize.Value + 2))

            CrosshairTop.From = CrosshairPos + (Vector2.new(math.cos(currentAngle + math.pi), math.sin(currentAngle + math.pi)) * Options.CursorGap.Value)
        
            CrosshairTop.To = CrosshairTop.From + (Vector2.new(math.cos(currentAngle + math.pi), math.sin(currentAngle + math.pi)) * Options.CursorSize.Value)

            CrosshairTopBorder.From = CrosshairPos + (Vector2.new(math.cos(((currentAngle) - 0.01) + math.pi), math.sin(((currentAngle) - 0.01) + math.pi)) * (Options.CursorGap.Value - 1))
        
            CrosshairTopBorder.To = CrosshairTopBorder.From + (Vector2.new(math.cos(((currentAngle) - 0.01) + math.pi), math.sin(((currentAngle) - 0.01) + math.pi)) * (Options.CursorSize.Value + 2))

            CrosshairBottom.From = CrosshairPos + (Vector2.new(math.cos(currentAngle + math.pi / 2 * 3), math.sin(currentAngle + math.pi / 2 * 3)) * Options.CursorGap.Value)
        
            CrosshairBottom.To = CrosshairBottom.From + (Vector2.new(math.cos(currentAngle + math.pi / 2 * 3), math.sin(currentAngle + math.pi / 2 * 3)) * Options.CursorSize.Value)

            CrosshairBottomBorder.From = CrosshairPos + (Vector2.new(math.cos(((currentAngle) - 0.01) + math.pi / 2 * 3), math.sin(((currentAngle) - 0.01) + math.pi / 2 * 3)) * (Options.CursorGap.Value - 1))
        
            CrosshairBottomBorder.To = CrosshairBottomBorder.From + (Vector2.new(math.cos(((currentAngle) - 0.01) + math.pi / 2 * 3), math.sin(((currentAngle) - 0.01) + math.pi / 2 * 3)) * (Options.CursorSize.Value + 2))
        else
            if CrosshairLeft.From ~= Vector2.new(CrosshairPos.x - Options.CursorGap.Value - Options.CursorSize.Value, CrosshairPos.y) then
                CrosshairLeft.From = Vector2.new(CrosshairPos.x - Options.CursorGap.Value - Options.CursorSize.Value, CrosshairPos.y)
            end
        
            if CrosshairLeft.To ~= Vector2.new(CrosshairPos.x - Options.CursorGap.Value, CrosshairPos.y) then
                CrosshairLeft.To = Vector2.new(CrosshairPos.x - Options.CursorGap.Value, CrosshairPos.y)
            end
        
            if CrosshairLeftBorder.From ~= Vector2.new(CrosshairPos.x - Options.CursorGap.Value - Options.CursorSize.Value - 1, CrosshairPos.y) then
                CrosshairLeftBorder.From = Vector2.new(CrosshairPos.x - Options.CursorGap.Value - Options.CursorSize.Value - 1, CrosshairPos.y)
            end
        
            if CrosshairLeftBorder.To ~= Vector2.new(CrosshairPos.x - Options.CursorGap.Value + 1, CrosshairPos.y) then
                CrosshairLeftBorder.To = Vector2.new(CrosshairPos.x - Options.CursorGap.Value + 1, CrosshairPos.y)
            end
        
            if CrosshairRight.From ~= Vector2.new(CrosshairPos.x + Options.CursorGap.Value + Options.CursorSize.Value + 1, CrosshairPos.y) then
                CrosshairRight.From = Vector2.new(CrosshairPos.x + Options.CursorGap.Value + Options.CursorSize.Value + 1, CrosshairPos.y)
            end
        
            if CrosshairRight.To ~= Vector2.new(CrosshairPos.x + Options.CursorGap.Value + 1, CrosshairPos.y) then
                CrosshairRight.To = Vector2.new(CrosshairPos.x + Options.CursorGap.Value + 1, CrosshairPos.y)
            end
        
            if CrosshairRightBorder.From ~= Vector2.new(CrosshairPos.x + Options.CursorGap.Value + Options.CursorSize.Value + 2, CrosshairPos.y) then
                CrosshairRightBorder.From = Vector2.new(CrosshairPos.x + Options.CursorGap.Value + Options.CursorSize.Value + 2, CrosshairPos.y)
            end
        
            if CrosshairRightBorder.To ~= Vector2.new(CrosshairPos.x + Options.CursorGap.Value, CrosshairPos.y) then
                CrosshairRightBorder.To = Vector2.new(CrosshairPos.x + Options.CursorGap.Value, CrosshairPos.y)
            end
        
            if CrosshairTop.From ~= Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value - Options.CursorSize.Value) then
                CrosshairTop.From = Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value - Options.CursorSize.Value)
            end
        
            if CrosshairTop.To ~= Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value) then
                CrosshairTop.To = Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value)
            end
        
            if CrosshairTopBorder.From ~= Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value - Options.CursorSize.Value - 1) then
                CrosshairTopBorder.From = Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value - Options.CursorSize.Value - 1)
            end
        
            if CrosshairTopBorder.To ~= Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value + 1) then
                CrosshairTopBorder.To = Vector2.new(CrosshairPos.x, CrosshairPos.y - Options.CursorGap.Value + 1)
            end
        
            if CrosshairBottom.From ~= Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value + Options.CursorSize.Value + 1) then
                CrosshairBottom.From = Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value + Options.CursorSize.Value + 1)
            end
        
            if CrosshairBottom.To ~= Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value + 1) then
                CrosshairBottom.To = Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value + 1)
            end
        
            if CrosshairBottomBorder.From ~= Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value + Options.CursorSize.Value + 2) then
                CrosshairBottomBorder.From = Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value + Options.CursorSize.Value + 2)
            end
        
            if CrosshairBottomBorder.To ~= Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value) then
                CrosshairBottomBorder.To = Vector2.new(CrosshairPos.x, CrosshairPos.y + Options.CursorGap.Value)
            end
        end
    else
        for i,v in pairs (Crosshair) do
            if v.Visible ~= false then
                v.Visible = false 
            end
        end
    end
    
    if Toggles.CursorEnabled.Value and Toggles.CursorBorder.Value and game_client.LocalPlayer.isAlive() then
        if CrosshairBottomBorder.Visible ~= true then
            CrosshairBottomBorder.Visible = true
        end
        if CrosshairTopBorder.Visible ~= true then
            CrosshairTopBorder.Visible = true
        end
        if CrosshairRightBorder.Visible ~= true then
            CrosshairRightBorder.Visible = true
        end
        if CrosshairLeftBorder.Visible ~= true then
            CrosshairLeftBorder.Visible = true
        end
    else
        if CrosshairBottomBorder.Visible ~= false then
            CrosshairBottomBorder.Visible = false
        end
        if CrosshairTopBorder.Visible ~= false then
            CrosshairTopBorder.Visible = false
        end
        if CrosshairRightBorder.Visible ~= false then
            CrosshairRightBorder.Visible = false
        end
        if CrosshairLeftBorder.Visible ~= false then
            CrosshairLeftBorder.Visible = false
        end
    end
end)