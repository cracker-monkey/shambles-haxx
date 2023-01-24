local Ut = {}
local Nades = {}

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

    if data.grn == true then
        drawing.Data = game:HttpGet("https://i.imgur.com/3HGuyVa.png")
    end

    drawing.ZIndex = -1

	if data.out then
		drawing.Color = Color3.new(0,0,0)
		drawing.Thickness = 3
	end
	return drawing
end

function Ut.AddToGrenade(Nade)
    if not Nades[Nade] then
        Nades[Nade] = {
            BoxOutline = Ut.New({type = "Square"}),
            Box = Ut.New({type = "Square"}),
            Accent = Ut.New({type = "Square"}),
            Icon = Ut.New({type = "Image", grn = true}),
		}
    end
end

local thing = {["FRAG"] = {"iVBORw0KGgoAAAANSUhEUgAAAAsAAAAPCAYAAAAyPTUwAAAA0klEQVR4nI2SMWoCURRFz4zaSSC9lRY2NlaKRfrgErIBi4CltQtwF1Y2gtO4AAMpsgaFWAhCmlRhCJ4UmcGvqOOBV93z+ZfHQyWYZ//5VdfqOMxDsaS+eco8lGOOvAB1bpDLVaALLIAkyPcndvbFUH1Um+okqJGoPTXKO9cyeaYevMyHWo/UEVADXm/1Bd5j4AdoF4gAnRiIsikiyuX0DjmNgQqwuUNel4Fd9qCIFeqD2le3V9ammqqt8DZ66vcF8aAOzg8JtaFO1U/1S12qT3n+BxKfG6GUHtoVAAAAAElFTkSuQmCC", 11, 15}}

thing["FRAG"][1] = syn.crypt.base64.decode(thing["FRAG"][1])

function nadeESP(pos, color, time)
    local stran = tostring(math.random(-99999, 99999))

    Ut.AddToGrenade(stran)
    local Nade = Nades[stran]
    local BoxOutline = Nade.BoxOutline
    local Box = Nade.Box
    local Accent = Nade.Accent
    local Icon = Nade.Icon

    BoxOutline.Visible = true
    BoxOutline.Color = Color3.new(0, 0, 0)
    BoxOutline.Position = pos
    BoxOutline.Size = Vector2.new(52, 52)
    BoxOutline.Filled = true

    Box.Visible = true
    Box.Color = Color3.fromRGB(25, 25, 25)
    Box.Position = pos + Vector2.new(1, 1)
    Box.Size = Vector2.new(50, 50)
    Box.Filled = true

    Icon.Visible = true
    Icon.Position = pos + Vector2.new(14, 3)
    Icon.Size = Vector2.new(25, 30)
    Icon.Transparency = 1

    Accent.Visible = true
    Accent.Color = color
    Accent.Position = pos + Vector2.new(1, 49)
    Accent.Size = Vector2.new(50, 2)
    Accent.Filled = true

    wait(time)

    BoxOutline:Remove()
    Box:Remove()
    Accent:Remove()
    Icon:Remove()
end

nadeESP(Vector2.new(960, 580), Color3.fromRGB(0, 153, 255), 5)