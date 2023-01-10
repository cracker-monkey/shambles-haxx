local shambles ={
    workspace = "shambles haxx",
    game = "Phantom Forces",
    version = "2.5.6a",
    username = username,
}

local PLRDS = {}
local DWPS = {}
local FCS = {}
local load1 = tick()
local t = tick()
local alive = false

local fovcircles = {}
local Ut = {}

local skeleton_parts = { 
    "Head", 
    "Right Arm", 
    "Right Leg", 
    "Left Leg", 
    "Left Arm" 
}

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

function Ut.AddToPlayer(Player)
	if not PLRDS[Player] then
		PLRDS[Player] = {
			Offscreen = Ut.New({type = "Triangle"}),
			Name = Ut.New({type = "Text"}),
            Level = Ut.New({type = "Text"}),
			Distance = Ut.New({type = "Text"}),
			BoxOutline = Ut.New({type = "Square", out = true}),
			Box = Ut.New({type = "Square"}),
			HealthNumber = Ut.New({type = "Text"}),
			HealthOutline = Ut.New({type = "Line", out = true}),
			Health = Ut.New({type = "Line"}),
			Weapon = Ut.New({type = "Text"}),
			Team = Ut.New({type = "Text"}),
            Icon = Ut.New({type = "Image"}),
            Head = Ut.New({type = "Line"}),
            ["Right Arm"] = Ut.New({type = "Line"}),
            ["Right Leg"] = Ut.New({type = "Line"}),
            ["Left Leg"] = Ut.New({type = "Line"}),
            ["Left Arm"] = Ut.New({type = "Line"}),
		}
	end
end

function Ut.AddToGun(Gun)   
	if not DWPS[Gun] then
		DWPS[Gun] = {
			Name = Ut.New({type = "Text"}),
            Ammo = Ut.New({type = "Text"}),
            Icon = Ut.New({type = "Image"}),
		}
	end
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

local FCS = {
    AimAssist = Ut.New({type = "Circle"}),
    SilentAim = Ut.New({type = "Circle"}),
}

local INST                      = Instance.new
local V2                        = Vector2.new
local V3                        = Vector3.new
local C3                        = Color3.fromRGB
local ColorCorrection           = INST("ColorCorrectionEffect", workspace.CurrentCamera)
local Players                   = game:GetService('Players')
local Http                      = game:GetService('HttpService')
local RunService                = game:GetService('RunService')
local UserInputService          = game:GetService('UserInputService')
local TweenService              = game:GetService('TweenService')
local Stats                     = game:GetService('Stats')
local Actionservice             = game:GetService('ContextActionService')
local ReplicatedStorage 		= game:GetService('ReplicatedStorage')
local Lighting 					= game:GetService("Lighting")
local rs                        = game:GetService("RunService")
local Tween                     = game:GetService("TweenService")
local Debris                    = game:GetService("Debris")
local LocalPlayer               = Players.LocalPlayer
local LocalMouse                = LocalPlayer:GetMouse()
local GameSettings              = UserSettings():GetService("UserGameSettings")
local Camera                    = workspace.CurrentCamera
local ScreenSize                = Camera.ViewportSize
local Ping 						= game.Stats.PerformanceStats.Ping:GetValue() 
local saturationEffect 			= INST("ColorCorrectionEffect", Lighting)
local currentAngle 				= 0
local pi 						= math.pi
local cos 						= math.cos
local sin 						= math.sin
local floor 					= math.floor
local rad 						= math.rad
local resolveron 				= false
local PerformanceStats 			= game.Stats.PerformanceStats
local MousePos 					= Vector3.new(UserInputService:GetMouseLocation().x, UserInputService:GetMouseLocation().y, 0)
local PingPerformance			= PerformanceStats.Ping:GetValue()
local devmode 					= true
local CrosshairPos 				= ScreenSize / 2
local curgun					= 0
local gaysex 					= 0
local fake_rep_object 		    = nil
local CrosshairLeft             = Crosshair.Left
local CrosshairRight            = Crosshair.Right
local CrosshairTop              = Crosshair.Top
local CrosshairBottom           = Crosshair.Bottom
local CrosshairLeftBorder       = Crosshair.LeftBorder
local CrosshairRightBorder      = Crosshair.RightBorder
local CrosshairTopBorder        = Crosshair.TopBorder
local CrosshairBottomBorder     = Crosshair.BottomBorder
local organizedPlayers          = {}
local rage                      = {target = nil, lastf = 0}
local currentAngle              = 0
local fps                       = 0
local cache                     = {
    setsway = game_client.main_camera_object.setSway, 
    shake = game_client.main_camera_object.shake, 
    gsway = game_client.firearm_object.gunSway, 
    wsway = game_client.firearm_object.walkSway,
    msway = game_client.melee_object.meleeSway,
    mwsway = game_client.melee_object.walkSway,
}
local raycastparameters         = RaycastParams.new()
local tableinfo                 = { firepos = BarrelPos, bullets = {}, camerapos = BarrelPos, }
local ignorething
local BarrelPos
local RPos
getgenv().Friends = {}
getgenv().Priority = {}
local teamdata = {}
do
    local container = LocalPlayer.PlayerGui.LeaderboardScreenGui.DisplayScoreFrame.Container
    local phantoms = container:WaitForChild("DisplayPhantomBoard")
    local ghosts = container:WaitForChild("DisplayGhostBoard")
    local phac = phantoms:WaitForChild("Container"):GetChildren()
    local ghoc = ghosts:WaitForChild("Container"):GetChildren()
    
    teamdata[1] = phac
    teamdata[2] = ghoc
end

function sounds()
    local list = listfiles("shambles haxx/Configs/sounds")

    local sounds = {}
    for i = 1, #list do
        local file = list[i]
        if file:sub(-4) == '.mp3' or file:sub(-4) == '.wav' then
            local pos = file:find('.mp3', 1, true) or file:find('.wav', 1, true)
            local start = pos

            local char = file:sub(pos, pos)
            while char ~= '/' and char ~= '\\' and char ~= '' do
                pos = pos - 1
                char = file:sub(pos, pos)
            end

            if char == '/' or char == '\\' then
                table.insert(sounds, file:sub(pos + 1, start - 1))
            end
        end
    end

    return sounds;
end 

function icons()
    local list = listfiles("shambles haxx/Configs/icons")

    local icons = {"N/A"}
    for i = 1, #list do
        local file = list[i]
        if file:sub(-4) == '.png' then
            local pos = file:find('.png', 1, true)
            local start = pos

            local char = file:sub(pos, pos)
            while char ~= '/' and char ~= '\\' and char ~= '' do
                pos = pos - 1
                char = file:sub(pos, pos)
            end

            if char == '/' or char == '\\' then
                table.insert(icons, file:sub(pos + 1, start - 1))
            end
        end
    end

    return icons;
end 

local gunicons = { 
    ["1858 CARBINE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABHUlEQVR4nNXUTyuEURQG8N/LSEiSv7GzseMjkI/B3sqSvY/hYxBJsZCVwUIRamRnMyl/R2ia1+K+Y2YxmsHL5Knbvfd07j3Pec7pRHEcSwkjGMVSla0dByhW2frQg1sU8JZC7IkoxURacY1BRImtiEwN3wfcIMYmnn8avFaQr6IFk5jDkIrCbVjAPHI4w4lQiWPcpRD7A9UV6cAAhpO9v+pePndiJSE1jRlMoVdQN48dvGAVu3hKk/BniOI4XsQyur75Rw6H2BKUvhd6/9UfJUFIJMI5xht8k8cG9oRe30/2Arrx+As86yIjtEShjt8p1pOVRSmxtwvKl9GUJAgVGcOlyqQp4UIgnMU2rppDr3FkMIs1Yd5ncSS0yr/CO58sURmvjH21AAAAAElFTkSuQmCC", 50, 9},
    ["1858 NEW ARMY"] = {"iVBORw0KGgoAAAANSUhEUgAAACkAAAAPCAYAAAB5lebdAAABhUlEQVR4nM3VPWsVQRTG8d9efAVFBG0kpBIFtRRsAgpWphAsLIKVIH4E/Qo2phU7LawUG8HCSlEUJOlEsVKITUgUBV8iV3ksZoV1c+PdEO/FPwwMZ2bOPDzn7GyVxBCOYg7b8RST+Njasw378BDPEXxGf1jyIZzF7aqDyFM4j9NYwa4NXrxuuoiEuzgzYi2/+YL7zcCmDoe24sCQPfN18in0Oorp4yreDMg13wx0EXkDh+v5N6U329zBFSxhT2ttCU/wAm/xCR/wEosd7l+z3JO4hOM40ogHX+vkuxvxR1hWXF/GPcWp93jVRch6Rc7gmm4fyBwe1CIfK07/e5I0x4kkP7OafpLXSWaTTCU5mOR6kqp1fiSj2ZM7cdOfjb+CC3iGY1hQ+kvtXqenYaM0RV5UerHJLG7V85PYj73YoTT+eKgt3ZJkYUCZp1vWT9R7R17iQeU+h4m2fqXMTd6N3LUBVEkq5Q071Fr7gc3jl7SanvJPbgukPLr/BT1cXmPt+ziF/I1fmt1T3HjM+CIAAAAASUVORK5CYII=", 41, 15},
    ["AA-12"] = {"iVBORw0KGgoAAAANSUhEUgAAACcAAAAPCAYAAABnXNZuAAABdElEQVR4nM3Vv0odQRQG8J9iKgXjDQQ7DVgknU1ICKkkWFmk0MoulT5BCh8hL5A8gyDYpEkr5A9RbIKVhSIIFjfR/FFvNJNizoXNYszuXgl+MMyZmbNnvv327DlSSmqOuymlzQbPVRlLxXW/+niAhYq+Qxiv6HsHU8WNATxDH44qBBjBQxzjZwX/OXTwDoP/8H2Mm8WNvpRSqnDJ/8JnWcFDsnLXCaeY7i6um3In+NRdVFXuGz5iD0/lRL8M51iX87iD73HxcdgdfMWZ/AnP8SXiv+0GuUi5s2D/Hh9i3ooAMIvlsNewH/YUboX9CzdibowB7AaBLpmNeLu/ofhXz4jkxRs8Cbsfw3KC90RurIb/MF6F/RqjaOERyl+g1Su5uhX8Rco4TCndLp29TH/ifq8do26HmC+odlA6a5fWrUZqFVCX3Cp2sH3B2ZWTq1uEF2OexHO5na3IZaOMkea0Mpp2iM0YE7gnV/U1/JAVbMu1sSf8Bjx4QyzAKlIYAAAAAElFTkSuQmCC", 39, 15},
    ["AG-3"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAALCAYAAAA9St7UAAABjUlEQVR4nL3UPU8VURDG8d/CqqgJ+BJDwLcYOqJiiDbGQkyM34HCxljYWNlY+Q38CDZWVBAa6NTE2kKlI6iFmqDeoBEJKK7FmRvXl724dyP/ZLNzzj5zzszsnJMVRaEmp7Efj+o6NuAhLnYS5DUWu46zuIw+fEQ/spKmXZXy3DqmauxTZhOfMIbDeF0lzIqimMQ8Wh0WHMMchroMqAmfsQs3pC74Xvo2JBVvR1ak3prBcofFRnGhQTAF3kkVfo9hrOILDmEldPtCtwd78QZHY+5V6MpnYQAv0Z/jHq5tEchB3MH52GykRhLHpBY8gw2p1XZHUptStddDuzM0vVLbf42E7v+WwB/kfv1VVXzAzbAP4DZuxXgxNm5FgKs4V/L9hoV4/hu5dJjq0MKsn4lcwXE8wEmsScm1GcTbZmFuTQ/uduE3Ee92P2cYj/GS1B5tBpsE+K/kOlxpFWS4GvY8nv9Fs4wjYW9LIj1d+JzCibAfV2jKN+C2/ZG6PJVuokuYrtC8kG6ZZ3jSXWj1+AH54FX7iZqi9gAAAABJRU5ErkJggg==", 50, 11},
    ["AK103"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAAB0ElEQVR4nLXVPWuUQRAH8N+d52sQTUS4gGinZSpBBBsb0SLkQwg2gljoZ7ASsbCxEbGSCDYWWogWCr5Uoo0h0eRAFCHxDaMk3ljsJvfk4fBevPvDMjuzs7vPzPyf2UpE6AN7cQFbOvhVstyTRw1/8AKbS77zmCnZFvC2ZLuMO3iy4aKIuNThYz7iBr5kfRI3savDvn/hK5ol2yM0sJz13TiIKXwr+E1hVQp6Ze28SnRXkh9SFnfiUJaDxmNslyqzhglsxfOs78M46tiWbVew3G0g3WLFRsrM4o2UiFGclKj1EO9Ke1/jXpsz6xIrSJRexA6pIj/XvaIzmhHxISKeRcR0RJyJiPnC+t2IOB4RIuJaRKwW1s5lu4ioRsRoRIwUbAMbNfySytmQfq4FvM+ykcfvUpYmsT9n+zo+54zfwgGcyn7jhT1NLLXJ+EBQk8rUC7024UieT9tIh6d4qRXIxP9+YLeo6i0IOIyxPL/fZv1VYX5M4vXQUe1jz4ksl7S6SREPtCg0gvN93NEz+glkTmrFM1IHKuM7rhb0s1LLHioqg+2+6xiTGsbaezOHo/g0jMvoryLdYBGntV7vWa1XeCioDfHs21IrruOi9jQcGP4COQMMvMuv7DoAAAAASUVORK5CYII=", 50, 13},
    ["AK105"] = {"iVBORw0KGgoAAAANSUhEUgAAAC4AAAAPCAYAAACbSf2kAAABwElEQVR4nL3Wu2sUURTH8c9uooKFIOIjguCrEJQ0NjY2RtIoQQTBzjJ/gjbWgoKt/gPaidiImKiF2gVtxCeSqPho4iNGjWKyFmcGbsZxM86sfmHYc7nn3vubMz/O3Van01GT1TiOBbTQh3yzhSRuZ/NtrMNXbMA87mJ5yd5X8QUrsQKnMIrJPKEfRyqIvI13yXgE57CxwtpuHBIvXGREvCCswit8TxNanWoln8NFPBBij2FtTbEpM6LyKX2isvfxIzvnAL6JLzmDW1WF/29O4AlmhVX2ZDF8wmRd4dNYk4zf4CkeYT0OF/IPCqvNYhC7hRWu4GUhd15UtSvdhM/hBaaS57X4jBOZ0E1Z7gVcxiXsF7ZKrbQdz5cS8zf0YywTM1V43i6xNvfmTZzEMmzFM5zGmSR3l38gfLjGui3YnMXjkjaVcacw3its0TPaNdcNJfF4yfyExT4dKslpRF3h+7Lfj7hXMv9T9P6cQc17/iLqCm8Jjz/0ex/OuV4452jNs8oFNLzytwlblDEgbrz8ZnyMneISaUzdisMHfxZNdKWxZLxD9POe0ER4Fc4m8XvxJ6snNLFKVa7hBs7jc682/QW/sHjrCuQ/hgAAAABJRU5ErkJggg==", 46, 15},
    ["AK12"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABtUlEQVR4nL3Vz4tOURzH8dczHiNqhAgbaWpsxXL+ASmSlWyYrZ34I5Riwx/AwkZJSZSm2MgkC81GslGkZkZjZsiP0eNrcc7tua7b47mTO+/6ds+93/Pj+z3fzzm3ExEaMIbrWMYrfPlH/07lfQ/mULfovdz/54B5H+AqpquOLg7nCfZic8U/X5l0EmcGx75mlvQT/IavmKj0eYZe3eBORCxie0vBNeGaFHzBFO7jkxT8KE7hjbTBBS/xriuVukjkFxawG++zzWZfYD+O5PceXmfr4jh+YFP2z2JGqvYw+n0oyapgGgdy0EvYKFXqMxZL/VawLCKeROJxRFyMiJ0RMR4RYxGhYhPR53tEHI2IbRGxIX97WvLfqRnfmhUVgUfSYfqYrY6yBG/jBbbk3ZrKFZvM/oNDVOG/MYK3kg53STfRIE6W2jckGX7Iz5tSYgXj0gWyPjQs4UyWTS8idtT4t0bEakleZ9dLWiMN8z6Hy7jrzwNXsCJdkQUn1ri/jelEsx/iMFzAldxexT79c9gaTSsyDLf0r9FRnG9hjb9oI5E5KZmCY1JCrdJGInAJz3EahySJtcpvOtqVG6/0I4sAAAAASUVORK5CYII=", 50, 13},
    ["AK12BR"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABoElEQVR4nL3VO2tVQRTF8d+N9xLwGXyAIrEI2AhWwc4PIXZ+AEH8BlaaJpZWWtha2ViJoIKvSkNIq/gqjPiKmqeFSLIszhw8Xm/IjYn+YThzZs8e1qy9OaeVxDrYhktYxCSW0H1Aqzx7rR/EByz3OLuFlVXOqjmHMdzuTm5jtMz3Y2tXfKaIrjmO0z1EbAbxp/BuruNHr0AryRx2bbKomn7E1VwsOs7gvMrUASyoKtjBWTzHp0beU7xv46PfL7KIHZgt8yeN2AFVVWo+4y224Ci+Y7DEFvAY34qItZgsOfcxj504jOmisY1rKmO+NPJmMCvJo1RMJRlPMpxkNMm+JLrGkSQrZf9yklNJOklaZW0iv3jWI/+fjXajTDdwtzgwvYprzVa5h4cYLk6OYQ+OlfhIcXWhj2psmAFV2RRBE2vsP9GYX8Y7vFa12AXV5Wo6OLkZIvsiye4kI0mG+ijhg0brHOoR355kvrHnZZLB/9FaA/haXJ3r495XcAcv8KZHfAlXG++vsHdjVvdHK+v7IdZ0rPI9xxBuYhy3/k7W+vkJAjiOxDLReeUAAAAASUVORK5CYII=", 50, 10},
    ["AK12C"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB2ElEQVR4nM3Wv2tUQRDA8c/lzh9JwB8giIWFooKVINiLhZUI6l8g2NgIYm8rForaCDYi2FpIChUhplAwQkQDghaKP/BHjBBOg54kYSx2jzwvOfLu4YFfWNiZN7Mzsztv36tFhApcwU+0MJF1xYVqhfly+hp24iPms65esH2JyY6Yx3EYR5ZLqIHteb4xj07eYaEgr8PJ7Nsv5gvrz6KJOdzr5lCLiGZO7n9iHDekDQwM4SheSBtb5BN+NPBF90Ja0k5MF3Q1bOshqZBaaA5rrNx2MCB1SrsTBjGFQ3jVsf5DzDTwFbvyouM4i73ZaATvpeNtsznrVmf5Al7javabwCgO5Oe/sXXleksxJL2bS2ifCIzhGu7n0Y0pqZAdWf6OJ3newlN8KNivxRZ87j3vJSxbBOkIp/L8kb9bqBu7LRYxiXN4I10U09iHxx0+e3pIthIN6SZYJbXKWAmf4vX3TOr9mQ6b5x3yQdytlGFZIqLXcT0WOd3FZjAivhXsZiNiU4VYpcdAhdpPYD8u4k4Xm1+4XJCHcaZCrNLUKn7Zy7Aeb7Ehyws4htv9CFblRMrSxKWCXMdNi38S/5Z+9m1E1CNiJL8ncxFxql+x+tlabYZxC+fxoF9B/gAcy5p3z7j4hwAAAABJRU5ErkJggg==", 50, 14},
    ["AK47"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB4klEQVR4nLXWzYvNURzH8dcdkyyIwZSVEE1CWUnyUGZjYaE8LVAaf4O1v0GZYmWhPGwkDytFVsxGDTbKU0kieahhPN6Pxe9MruvOg3vvvOt0Tud8v+d8P+f77fc7tSTaZBm2ojZD+35sLOMVeIFFLex+4iJeNcx9xNMWtoM4iiO9Mwyimc04h9Vt+kNdFexbDJT+AzZgG76X1ot52I7nTXssxA2oJTkzzYHvcRdfsBjrsB9rOxAxwTi+YgG+lcAX4h3uNNitVIm9Unwm2FX6kVo6qK0uUscnRFVGwxhrWO/FfHxWZW6C5arSvt1Oab3GiOo25pW56yWA+ziAPtUNTnAZx1VZ3YmluIWXRUDHTCekjicYxT3cxMOydg27y/gCHuEB1qvSvwY9ZX0VnpXx+W4E/g/5m3qSB0lOJtmTpC+JSdrp4nMjyeJi25dkSZI5Sc427T0wxV4dN0lGkwwn2Zekf4aOPUlelQB3TWIz2CTk6mwLaadtKcF9SDJ3CrGjTWKGZktIz/TF15JNpX+k+mS2oo4h/GiYO4UdbZ45NR3cwrIka2Zgd6IpK+NJDnY7I7Vk1n8jc3AJexvm3qheBWMtPdqg3dL6H37hkD+f3eCYLopg+v9It/iGw3is4X3UTX4DquzM63GDCPgAAAAASUVORK5CYII=", 50, 14},
    ["AK74"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB6ElEQVR4nL3VO2tUQRTA8d+G+CZiwGJFfKGRFIJgI0QFG7USQQQVIb2fwMavIIidhZ1WKmIrGjExvg1YKBqSRgxEUBIf+CDosZhZdt24N8lu1j8Md+bMmTmvuTOliNAES3ASy+epX85tDdZhDJv/oXcPj+pkbzFaJzuK3ThTEZSaCGQVruPQQhfWMYRl2IEH2IQNUpA/a2w9RX/d2mOYwc2KoBQRF9FdYHAML9CB7ejDwRaDKGJINZAuqXJP8CPLVmCPlISp7NtAKSJG0dNGxyr8lpIBgeks+4Rf+IxnuJvlsrPl/K0cr30YRwkf8AWTCw1kCgPYgl1ZNozn0tk+jiN1a/pxA99xAu9xXzXDi0LnHPPvpCyN4A4eS9k7gFtZ5yXOSz/lRnzLDpfy/FZ8zf0ri+T3bCJiNKp8jIhrEXE6InoiQoPWl/UnImJtRHTntjoilkbEcM2egwX7LFrrlG6MSznjI6rns4jD+XtVOqf1DEqXAuyVqjLeUsbnoskMvMrZ3t9gvjf+5nK7K9Ixd6iz6FJ9CN800HmN2zXjU6pVbAvNPIgVypgsmN8m3fEr83hCevymmzVYRDMVqVAUBOkhPVszXo9zLdgrpJVA5sMFPMz9GSn4UmP1FvgPV2NvRAxFxM522vkDiYU2tM7CwnkAAAAASUVORK5CYII=", 50, 14},
    ["AKM"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAByklEQVR4nL3VzYuNYRgG8N9hRPIxvhL5iBkLSoxiNdmyUKLE0s6S8gfM/yDZoFmwkIkpJVmPBcIkUcwsqJlYTONjfEeXxXnV22nmOM6cM1fdvb33fT3PdV/389RTSaJJdGMX5jXI78IGdGIdXmHVNLz3GKjJPcfbabgXcRN3OhpsohYHcAVrmlwPvapmfmArXmO+6oAO4XvB+6xq4nDBLeMJvkAlySX8riP4EQ/wVXWSO3BcdbqzxVSh3VnoVLAMT1VN/sX+ouHHpVwHjmAY5yqZxd1qIabwS/UURnG1pr4QSzFSylXQg/sYa8bICJ7haCk3gHd4ibNFU9tK9b6iuU+qpzmBexj/T+2ZkX9jPMm1JKeSbEkiSSXJoxKnN0lXURtKcr5mj8tFrW0xnZHRJP1JTibprrP4dsG/kKQzyYoiVhdGH5b2nEiyqN1GhosJnkiyvsGFS5J8K5rcPgPnTM2A+tptpJk4VjT3og5nZZLJkpGfSfa0y0ijj1kt9hbf4TqcSZwu/S/AIDY1qVkfs5jCxiSbG+AN1lyxsSQ9rT6RStL2Z2Q5hrCzlLuLg60UmQsjsBa3sA8fsBtvWikwV0ZgMfpxA9dbvfkfBORvDGB21QAAAAAASUVORK5CYII=", 50, 14},
    ["AKU12"] = {"iVBORw0KGgoAAAANSUhEUgAAAC0AAAAPCAYAAABwfkanAAAB6UlEQVR4nLXWz4uNURgH8M+duSYjl+GGMikWUpIkCwtloUw2FjYWs7CzsPc/2FhZUFYskDJFyUKmLJUoGwkzSiPSNIQZLuaxOOc2r7d7x7g/vnV6z3nO8zzn+XnOW4kIHeA8fuIXHqGopJK/rWhF+g7MZD1l/nlMYg4H8Lp4eLUDg9fjDFZ3ILtSfMcURlptViUPZ/Emzz9hQ4FnEZ/zvJYV9dNg2Z4n2I2zeIcGFjBdiYgGxqVULGd0HZektPYb3/AcG7ENqzJ9DrOViFjAcBvhYRyXnNqHu1Kt3Szw3MErXMMm3MPbfFgTu/BRcnwxDxi0VO+/paA119P5uyfvNTL/lIhYiAiFMRgRRyPiSkTMRMTViBjL9CbP41jCxYg4FhFDETGSaRPxNw6WzuhqVCLiR/amjpM4gWc5crelTi5iXY7akFRKh/E17w1gLXaWsnEal9tk879RzYdP5nTcwH6pEdphLMvAC8nBMsqOHtJjo0fx3lKd/QtHCvOnbXheSh2/tYVM1xjIyldqMEzgvvSwPGzDE3hQWI9ibycGttbeeUPUI6K2zP54qRnP9bIRexaAEmpS2a3J6w/YLr12XWGgWwXL4AtuFdZbcKoXivtpNOnHqpnKeWzuhdJ+lkcT16Xb5IJ0v3eNPxBaj7M/EmAxAAAAAElFTkSuQmCC", 45, 15},
    ["AN-94"] = {"iVBORw0KGgoAAAANSUhEUgAAADEAAAAPCAYAAABN7CfBAAAB00lEQVR4nMXWv2sUQRTA8c/FOz2jIIrBgNgKIqiIoILYWdj5q7NRRERs0/gf2NiksbCyTyOCheRiYaeCgoLgryKiiPE3Mf4ieRY7kmPdu9tL9vALw86bN+/Ne7tvZ6YWEUrSwD7sxhN8KGtYwBr8TP0aIj0X8BwfO9idxdX8YL2Pha/gTB/zl8op3CkYX4uT2IMd+IYNGKtFxDWs7uG4gSOVhdmdB/79ygfQxCP8wjDeYhPe1CJiTu8kBslvzFksq9f43qbfKgt6AufwJe+gnpx0S+IpLmMXzreNT+AWPuM0DufsxjEq+4+GMYOXspp/gWepPy17u53YidlkU0xEzEYx9yPiREQMRYSIGEvjXyPiQkRsi4i9STceEfM5++NJN/AmIuZyi7ci4lDB5JtJfyPJIxGxPrUtEXHxfyXxt5xW4Tou4W7BB1uJg6nfSs+ZNv0n/MjZrOtSIpVSx1G8ktVoJ/bL9nYWk8jzLiePLC+08tQxVWJeA/ewGY87zMknMbqMuPqi7GE3mVpTtg0WMZ2Tty81qH6pRflrRy9WyLbCZpLfyw6jhaoW6MRQhb7m8bBN3ijb4wdOlUmQlVw7xyr2X0g/F8AyTMnuWK3Ublfsv5A/SBySI+YtT1UAAAAASUVORK5CYII=", 49, 15},
    ["ARM PISTOL-ALT"] = {"iVBORw0KGgoAAAANSUhEUgAAAC4AAAAPCAYAAACbSf2kAAABtklEQVR4nNXWPWgUQRjG8d9eLgYRFawEFSUoNjZ+FCksFKy0UXvRxt5GQVMKQoqUgq2lhTa2WtgkNrGxMKJEERsJSoKcBj94LWZP7ta53O3lRPzDsLvvvDPvs8/ODFtExH280p8Wbg6QV+U8HmAf3g4xHiZwHI/bgSIiVrFtyAlzPMeH8n4vDmAFr/Gm5lyBAg3cwaN2x98QXpeQXqx6D2vYhP24gLl2RxERa9Kn+B9oYRGbm/jm3woPLOl2+qvkNhzEHmmZLOMzxoqImMfUCAQ8LIs9wyfJjGvY3WfcF2xZp/8uDpVz/d6cImIqIlZjY8xExHhEqLTZTO6liLgdEUfLdiYzrm9r4ikO47p0ZPWigZPSLu/kI27gZx9n2yziBRbK58kBx3XRLK9LuDxA/gq2Z2I50RM4W4ktY4d0nk+W9ccHEVql2T+li7FMrJfTV3S72cIxvKtZM0ujZn5O+I9MbCemK7EZIxJNfeG5L5QTfgtbO57fY7ZmrXXZqOPfpXXbyRFcrMSuSsfeyKi7xuelH7IF6WR44k/Hp3Ub8hL3hhXYiyIiRj3nLpzDaZyQ/i9OjbrIL+XD/twN05nXAAAAAElFTkSuQmCC", 46, 15},
    ["ARM PISTOL"] = {"iVBORw0KGgoAAAANSUhEUgAAACsAAAAPCAYAAAB9YDbgAAABmklEQVR4nL3Vv2sUURAH8M95hyIo0UKDwVIQLCQBC8HKv8BCYmVh6R8REAVtLCwtFETQ1l7FX6hFtBAiClrZaIJVTM7EcNw9i7eLy97e5d5u8AsDM/PmzXxneDvbCiHMmwyPsTZhLNzAQxzEV/QS7ub4g83caIUQ1rC/RiJYxo8RZ8cwVTNvjmu4khudhsmOZFIHP3FPnHi34F/HFu7iEGbRJk52C7trFvwfCFhFuyN20YTsLwwy/QBaE95bxdNM7/r3pgfiRM/jGZ7kOTt4jnMNyH7CmUxfwD5M49I2977hwoizU3iPN3ibO1shhBNYzIqkoouj4nSLmMWHku+quE1eYY/Y4M2UYh18xlncwsyY2MOGG/pYQXQv7pd865jDCo6jL661NIQQJpUHYRivK+Jul2K+hxBOJtQZKbsS+mpX+AYlex6XC3YfF7GUOMNKNCXbL+hTuFM6v44XqaRGIYVsVWyRbE/ciUU8SmY0Bil/sO2ewYb4Ec7htLgrv9SnNoymZJdLdg/vMtlxpJD9LU7qZUFWdpzRGPwFoGrg1hC6LbEAAAAASUVORK5CYII=", 43, 15},
    ["AS VAL"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAAB/klEQVR4nLXWzYvNURgH8M9ljPFOyk7IAiVNFmpQNBYWykZZWFlY2vMH2LCgrGZDyD9gIUpWRhQ1SixFSCJvM8Zr92txfpo7v5lp7tyZ+dbp/s5zznOe1+85t5HELLAZ+/EbS6pfWIRRLKtkP7BxEv0tWI5VGMLpDnw4hv7GLALZhzuK09PhuxJUHU0sqMmG8XcGfnRjWRc24YuSwV/VwRvwBn+q+Rqsxlpsw8FKr50goGsKeT0IWNHmmRMMPMB7xWloYAfe4hMW4nM1RpVSwsPaWSMtZ6ww3vnFLd+/8BSP8dHEZHRUEUleJGkkUY31Sd4lOVnN1yU5k+RJkqEk95PcSHI5STMFf5OcT9Jb6QxkPJpJTlTri1pszdnownO0EuU1XmI7LqAfF9GnkLY1E0eV3h/BT6VFu5XK/URPtbeBm3g3g0zPCAuwsibbpNwkB/AIO3HJ+CBgjzECX8cAvlayqzhb279xrpyeFEk+J9ma5FCSa0keJjmepGeacp5taZ3dtbXFlawVx+ajpf6PRpJBpeSvcAt328zBoFKVpvIOjNTWe/DNGJnP4dRsEz8VurC3Q93/Dr40MQgKR56ht5r3dWinLUx1v7eDKwqJPyhca06y556xQHYp1/LwLGxOjfns2ySHazw5Mp8cmZcEVViqPH6Dyt+Z28ojOOf4ByC7Nc+GCt/WAAAAAElFTkSuQmCC", 50, 13},
    ["ASP BATON"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAACCAYAAAAaRY8cAAAAMklEQVR4nGP8////WwYGBhYGBgY+BvLBZwYGhpMU6L/NwMDwiUy93xgYGH4zUWD5oAIA3Q0Jetjcu8gAAAAASUVORK5CYII=", 50, 2},
    ["AUG A1"] = {"iVBORw0KGgoAAAANSUhEUgAAACsAAAAPCAYAAAB9YDbgAAAB4UlEQVR4nK3WO2gVQRQG4O/Gi0bEB0lhESvFJkpKG8EmpSCIYDqbNBaK1oKFdsFCESsbIWDhA0QIIiLa2FpoiKYwEoIQUBM1ilHzOBY7S5Zlb7ivH4bZ/c+Zc3b+OTOztYjQJkZxqcR9wr8K3yWcajdRjnoHYxfxscQNoIbJAteDgziEqQ7yqXWgbBW24CbOoRh4F85iP+7hZTvB6+jFGM7LVOkGlvGlgt+HF3iEp4lbxc8GcVawjt+o1yJiCoNd+sh2MIsPDWz5x87iTy26XAdNYk22ikdkdf+tmUF12e7d2kbCv3iCedmSX8Tugn0Uv3Adz/EK35PtKI7hdUsZI2Iu2sO1iJDatohYSPxSRNyPiJ2JHy/45e1B8t1RYWvYejaZx1fMYRxDSaWysjmuok+2vIM4Lds0xzFREbs39f2dKrseEbcioi8pk89spuR3O/EDEbGauGclNe5ExPYKlaaTf3+nyl6RnZOLJfXmS34HUj8iO1/hbsG+J41frsiRK7vWgq6VN1ij0+G9bGPkOJz6oQI3U3gewcMGscZkF0XVRBqiFhFnbMw08BifK3wv4EaJ24uTGE7vKzZqewGXtajepmihZobLx0FEnGil5jptrfzITOIHpvEGb/Gua6o1gf/niwh4NmNiowAAAABJRU5ErkJggg==", 43, 15},
    ["AUG A2"] = {"iVBORw0KGgoAAAANSUhEUgAAAC4AAAAPCAYAAACbSf2kAAAB8klEQVR4nL3WT4hNYRgG8N89M7gsZiFpNJli1KXZiY2GBWVxi1KUouwkZWNjQWhiYTULsmDLQpMUZSeWCqWU/6WYhoxkxr+LOBbfuebMde695869PPX1nvN+73nf5zzn/b7vFOI41iZ2oII7eNMk9jD6sL/dot3tJsBDLMMQFmIP1uEH5mTYd3iMa3gx26KFRPHVOI75s02UQiQQXI8y3qbmluIVDmArdgsvUcUHZLVAAUV8w2SV+DAOYW4HSP8PjKNSiDvQ5G3gl/CFzgtr5LJsxWP8xHdB9e5/TfwjJrAAvQmBMXxN5sawApsFJXMjwus2iD3CWqF3izhXMz+KAWzADSxCP0pYgykMoqfVwpEgfzNM4laG/wLuCspF2JT4n2InhpP7Mk7hfZ38i/PRnUaj7fAlTgs7xFmsxO0GBU8K6sIJXErNbcSZjBpLElvMyfcP6hEfwRF8SfkmMuJ6E9uDfcn1Z1xJxZTwTFhctehP7FQesmlkEb+Ogxn+8aR4V8q3KrFbTJ8BV/EpFbMLF+vUj3IzrUEW8b46sRU8FxSsoiS00kDKF2F5ct0lHG5H6+TchnlmHkK5UIjjeMjMHnsinG5ZGMX2Gt+gsFuUGzxzr1ViTRHHcSvjWPw39raYoyOj1Z+s+8JP0oPUuNlhLXPhN0TD/Cfdw9YjAAAAAElFTkSuQmCC", 46, 15},
    ["AUG A3 PARA"] = {"iVBORw0KGgoAAAANSUhEUgAAACUAAAAPCAYAAABjqQZTAAABuUlEQVR4nM3Vz4tOURzH8dcd48fjRxNqkNnIQspCVmJtY2NhY2EjG/kDsEH8D5YaZSGKSJSyI03ZkC2P1BBGTDLGr3ws7p1xezzPzJ2nWXjX6Xw73++953O+55zvKZJYJJbhKF7gGT7VfEXNrk94ButxEpOzwZWoAnuxok9BW3AOmzomL7qH/8PHStysqI24iP19CurFLwzOE/MV3/ED19DGSJFkEkOLLKgffuIsNgz6PwTBAzzH0yLJtP7PEtzCK0xgGw7XfA+VZ63AKO7hPnZjH75gRy2+wFtJXqZ/7iZpJVG1EzVfO8nparyV5Hotbs4230Ecx1rlFR/C9g7/O0xX9ghOVfYY9vh7/Q9UGW1Gj0x9SHI8ydIk5+fI1J3aCi/Xxo91rP5qktVNM9VN1HiSrR2BR5J87iLqceVfk2SqGvuWZF3t2+Ekl5oKSmKgS/ImlVW5zih24gZu18aXVP0urKzsJ8piOMMhXGm8dcriNqa8ijM86hHbxsHKnqqJgOX4jYFK4E1lQYQWLixE1Mwzs1DayqflDTb384O56LZ9TXhf9cOav2+Nma8k9OK1MksTWKUsgovGH0jxzXyX+j5jAAAAAElFTkSuQmCC", 37, 15},
    ["AUG A3"] = {"iVBORw0KGgoAAAANSUhEUgAAACsAAAAPCAYAAAB9YDbgAAAB40lEQVR4nMXWz4tOURgH8M8dP0JMo4QmWWEos5HEQmgUUiglsmL+BmtLK5YWxMpikjSWdrJgZWb8KDbMLCyIoYxpGPJYnDN13e47c98x8a2n55zveZ5zv+9zn3PuW0SEBcQ9dOJAw/hBnGi6+eL29bTcpw8H8Sb7chWKbDOIbNtwBPfxa66HFLmyXTiPJfMUexa9FTFFi9g6PME+TM4WVETEIVzDxnYV/iV+YqI0H8YX/Mjzbql47/AMm4tY4KZtAzPVH5eEPsT70voqqb0mpMr3/k+xH/Eat3GlSUKH9Mvmi2GpX/uknh2trB+XqncRV7EFizK3QTpgexs/LSLGYm5MR8RoDX8sImTrjoipzI9ExLnMiYiBiFheihURS3PsUIVvabNdXeO4i2+4jJ24U4lZWxrfwDKpF09KrxjWSQdnqpLblX1n08K2EnsTF/CpxNXdFuuz34XDefyoJBTOYKAmd1P2EzVrteio4QbRXxEKb2tie7I/XeJuVWL240FN7kyh5vwYVBPKWNMidgxfsbLEbc++p8RNY3Ueb8WrFoJe4hQ+N9SqiIijWFHihvz5Gst4jN2l+XdJfD921MRP4hI+NBU0K5qexGzXa26EPW3uMW9r94/MiPT5e46neCG1xz/Bb86uexoVUGNgAAAAAElFTkSuQmCC", 43, 15},
    ["AUG HBAR"] = {"iVBORw0KGgoAAAANSUhEUgAAADEAAAAPCAYAAABN7CfBAAACDUlEQVR4nLXWO2uUQRQG4Gc1qy6KEu8oCGqTgPYWNqKFgrWXH+AFhCjWotgoiJhK8AekNIWVgiKxULERNAZsVLzgLfFCNDGSsGMxs2bYfCab3fWFYWbeOWe+c+Y758yUQghawCm8w4M0X4IJLMR3dGAKF/Aal1v52L/Q0aL+HSxGFzbhIioYw4dMbgMeo4p+0aG2oRRCKOM8jrdpz6W4jqcZV8EvHMEKnEAtBMbxO5MtY7JgXMOyxP3VKYUQBrGtPfY3hIBSNn+EbixvQHcUi/AcI/iE4VJoMSmawISYO6dxA2+TYWMN6q8X822iRnTgvRiz88UX3MIwfuJMtvYQvejEJVzFkBgGozgrht3LJF8fMrPh4wwmhPAmzI1qAbc/hCC17owfCiGcTPyOEEJPJldrUyGEmwV8U2226vRC/MX9GMC9uvXx1C9IJ13T2S5WITgkltcclaSzsrGDnxtFTkziHK6YrgCrCuTWpX4fdqVxn2kHymI4fa7T2yom9o/mTJ6JIid6cK2O+yZeWrn82tQfzri+bLxXzJl6lFNfLVhrCkVOVAq4qljONmbc5tR31RnVKZ70QRwt2OsVDqT92oJSCGGnWPKINfy+rHxluI092fwuduOYaYdyDCj+E21HaR7XRK/4VqphBGvabVAzWDAP2cG6+WpsaaMtTWM+D8BBfBUvrWd4ovFb9r/iD1BPGUL5VqhSAAAAAElFTkSuQmCC", 49, 15},
    ["AUTO 9"] = {"iVBORw0KGgoAAAANSUhEUgAAAB0AAAAPCAYAAAAYjcSfAAABPklEQVR4nL3UPUtcQRjF8d8uuwYiKVTWQlzBRkk6Y5UUAVPapQvJJ7HTzsoqYG3hV4gG89JKlmAZEQKGVCoqmBgtlMdids1wUUHXm383Z+6dM8+cZ6YSETI+YAR72MEPzOHE9YxhGNuZ1ovjbDyKASxiqpKZNvEFgzjLfviKoxtMX6CBjUzrw2E2/o0ePMFaJSKamMVjPLth8W74iSrqWBIRgxHxPv4PrYhQwwP8ko60VtjhjpTNHym3/vsoO890GW+yuQW8wzhW25trSU0yIzXZbfmL73llE4UPGlIWQ1IW51J3z2P/DoaXdCp9im+FuWns+nfsPVhH6JJOpW8L+hZWul38Oqp4iNcF/VNZhh3TV1JuOQdlm768Qt8t23RSauUOp/hYpmklIh5JV6De1jalJ7E0qnieGcLnMg3hAkvWtlcmHbfCAAAAAElFTkSuQmCC", 29, 15},
    ["AWS"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABHElEQVR4nMXTsUpcYRDF8d/qEhWxEkQWQTAGMUKKVKnS2MXSR7Cy9SGshDxBLKxMo5YWQlJoUgVCithskY2VlUVEFHFPinurZdds9or+YaqZM9+Z4ZtaEhVYw4ceuQbmcFzlgX6pDTjIO7zFK/zoUdNAHX8Gs/ZfpJZkBTNY7kie430X0Tg+YvEBjVzhSwV9aklamFQYfCqaeFGlQf0f+TY2cITn2McQ1hVfagHbHZpr7OFEcR+Xffi47d9yD5K0klylO+0k40kkGUlyk+RbkpdJ5pO8SXLQoflV1j9q1DGKsXKuTWxhFrvlxr/iFEt4hkP8LOub2MFnnOE3WpW3OwB1hfFPGMYdLsp4jVVMYRoTijv63tFj75G83stfjl3YXlWyhK8AAAAASUVORK5CYII=", 50, 8},
    ["BANJO"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAABIUlEQVR4nN3WMUujQRDG8d8boqAochaCYGljfWghiCBoc1hfc2IvXH2NVqeFWFlY+TkEv4BgYWdznYVg4IiF3R2oj0UQXoKGJKJJ/MPAPgwzu8sOM1skUWIcW1jDHEbwB2c4xLV+JcmzfUtSz+v8T/IrSVGK6Rt7XqwnuW9xiTK/e33ol6xIMoErfGn3EbGI83crky6o4Kf2LwEFdt647xI2uow9btK7GK1itYtkq7ho4R/DUAt/Ffv42uG+sxjGd5xiHjP4USS5xWSHCfuBaFQHGqU1qBRlUcUlljtM8k9jrnw0sxrz7RInWMAKbiTZbrPtljnpYas9atIHSUYHsf1Oo1bSU6hXcIdNPLSZaE9vZ0itSf/F46f5ohTJ5/g0PgGQZbQmy/b+pgAAAABJRU5ErkJggg==", 50, 14},
    ["BASEBALL BAT"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAACCAYAAAAaRY8cAAAAS0lEQVR4nM3OOwqAMABEwUlQUVTi/Stv5FmsLGMTQYJNOl+17Ac25Jx3HLi00WEtekPAjAE9lqr/ZG9GTJX3tY1IHx9Syc7YcPzX3MgVBvHSNhaEAAAAAElFTkSuQmCC", 50, 2},
    ["BEOWULF ECR"] = {"iVBORw0KGgoAAAANSUhEUgAAACwAAAAPCAYAAACfvC2ZAAABv0lEQVR4nLXWv48NURQH8M/w/MrGJmQLkfiVrGYL0YiGhEIl4Q/gf1BJFBLR6VWUQii3ZiOiUCCEKERkC4pHgbWxll3vHcW97Ji3nnlvnm9ykjv3/JhzvnPuPVNEhAbYj2942STIKpjEKVysKloNAy9hAicwjusN443hMNbh+WoGRQOGL2FKSnQn9uA2nmEZa7MsYDbbLmMRnbz+gi4+Yz7H3Iw7OCMR0pPwxyGSDWytadvFmgHiFniNu1LCC2WDFrbUDFYNXBfFALZvJPbnpLyWsL5s0LSH6+ApbuFATiTwHV9zcvN5r40b0hf5K4oYrInf4onUp21ctlL0jywbKz4H8XCAd/RH/BtzEXE1Ig5FRBERSvIu2zyKiNMRMR4R7yv++yo+jaRlpdHL6Egn9RqmpZNdxV5/HrxZbNPb351REPsbEdEtsfEiIs5GxPYa1U5nn25ETJX2L1QYnhw1wx9wM7P5uGadR3Eyr6/gVUnXrtjukq6p0SAixoao9EFmbzEiJiq6IxWGz4+S4WEn3Q4cx26cq+g24RM25OcZHBuSzx40Gc39cF/6JyDdt7+GQGP8r8Exk2Pfy9J3GAyCn1DyDO+30BjQAAAAAElFTkSuQmCC", 44, 15},
    ["BEOWULF TCR"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAABx0lEQVR4nL3Wv29OURjA8c/bvrQEibQhIhITkf4Bfqw2f4FIJEQwWInJYDAYTRYWk4VFTLRDYxCLRCTUUJJSIaJSSVstHsO5jdPbt+99e/u23+Qk9zznnOfnee69jYiwRq7gEd6uVVELTuIlxqo29nTBWG8XdKzEbmztZGOzpoGDOIu/OIe9+CYlJgp5j/+J+lPIn2MCjQr9RzGI8xiXqtKWRkRMor/Nnnf4mc03YwgDVcpb8GLRbiaLYh6WB9iPSUxjBr+ytQFcwAHMNbGnwvjhwsgIvkuBzK/C+WmpIvAD27GpmJedK7MFn/Glhb7Zwq85zIvEWEQ8iYjfsZTXEbEjIpTG9eiMiYjYVzq7PyIORcRQROxsobvWaOIr+nBcukJ3sFBEer/IQJmbRSZvZJl9jGNSvyzyQOqJnA9tKlCbpnQvhzGFu3jTwbkZvM/mV3EPp3A7k/d1x81qmrgoBdIq8yvRi8vF8ycp+EEpGTnlaqwfNe/kpawPzmTyZkQsZGu3utUDVaPOoV0RMVU4OtxifTwLZHSjAqnzZZ/FNTyUXgxlRrPnI9hWw8bqWYfsnI6lnNiIitT9RWnHU3zEs2K8Wgcby/gH8jbLOOESHgwAAAAASUVORK5CYII=", 50, 14},
    ["BFG 50"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABWElEQVR4nMXUv0vVYRTH8dc3b5ZpZC3lUIKLINHi6N/R4B+QTu7N4daug3+C0tTQGIgKDkFTQRimqEMgopbJtU7D+V66onjzfq37hsP3+cJ5nud8zo+niAht0oVHOMEeDjCKVxgsfa5jCH0IvGv3slYUFYQM42O5/oY6DnEfW7iDXnSXPvWm9ZVTq7B3GxOyIoFJzMvgr2EEc1JwH35WirQFRUSsYQNvKpzzBI/xyx9hdSzKanXjSArax218xw0psAefS/sbvuJH0//dIir0Vgd5iSUUMmnPGkI+SYU1OcC7eIh1zMh22ZetNHzOwe/xXFajXS5TkTM0ZuRAlr4ft7CCKbyWpR/AMRbwATexis1y/4R8uTpGQ8gDGchbPJXBNrNTfsdkP69iGsu4p8MiQCSzETEaES6woYjYjYiNiBhs4fvfrSYzeuT0K3Ae43JOXuDLP87vpfkNyofv/8tF7+MAAAAASUVORK5CYII=", 50, 10},
    ["BOTTLE"] = {"iVBORw0KGgoAAAANSUhEUgAAADEAAAAPCAYAAABN7CfBAAAA5ElEQVR4nO3WP05CQRDH8c9TYqFnEDR2XkIOQu1ZvAGU3kCNFMYzSEJiaMTKBG0ogEJNXsha7COBgiBQuI/47TaZmd1fZudPFkKAMzRQRxVj9PGAewwtcoAaTnFS+NRwXpy/cDhnP8I7BujhqYjZwdSWZCGEJi6xt8Rmime84UgUfIz9bS8XhbRxg0d8bxIkC0UqEmCCa1zhYx3HlETM+MQt7sTvPFnlkKKIeXK84kWs0VltXqAr1t0gdRG/Id8FEUs7Uqn4F5EIeeWvX7CC0nantedESpnYeGJX0LIDuxMl32J/AFNeaeJY2r1GAAAAAElFTkSuQmCC", 49, 15},
    ["BRASS KNUCKLE"] = {"iVBORw0KGgoAAAANSUhEUgAAABIAAAAPCAYAAADphp8SAAABc0lEQVR4nI3TsWoVYRAF4O8uIngJomJjMCRlGjEqBBRBURB8AAkEVJJCVCzSWZjGF9BCIZLSzlcQTOUDiCIpbFUUCzUQCEI4FndW1usGHBiWOefMP/Pv2ZVET57bA5fkbB/e6I+bONqDH8GNvoYGMz34JK714As43oPPNLiNiR7y5H9iE7jTYIiVMXITFzDdwaYL2xzTruBAgy0sd4gz2MFVo6s8qFwobAenO/plbEkym+RnkqVy5FGSQceRjcq2HiR5Utql6p1tsIj7+ITHOIZ0Jn6obCNGjq7jc/Uu7iviWYne49XYOxj4N07hcg2Hh+1BbXzDFF5gA3O4VNwa3lQ9Vdo/W7autVPnq96thi+4aOTW18J2SzPf2Xg4SDKHW0buHTL6cq/gdc+V4Dxe4jl+4CDWB0nGhWs19d4eBz01+iPu/oV2bB0mWU3yPcl2kutJmg7fFLZdmtXqkcT4RvtxopOH8bE2mKyrvMPbev5qG38DD4zt9GPY6RcAAAAASUVORK5CYII=", 18, 15},
    ["C7A2"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABtklEQVR4nMXWO2sVQRTA8d/1LqiND9B0ESPYRAsjchsbBfEj2NrZKH4GUwjiB9DCxlYEay0EQfFJLkgI+IwSIUFFFCXRxOSOxYy43Ozl7kPxD4ednTl7zsw5Z2a2FULQgC/4igl8amJoAHtxBUeGKW5o4OQstmIUIw3sDGIEO/C+jHKG85hFwNMCnQXM9/UdxikxI9twBy/TWD7FGaawD6tYEzMY8CPJTyyn5woWU7uDccyVWUgrhDCLsTLK/4ke3hb0r4hB2YL5DN/xBm3s6lN+hxkxKp9xW4zmBC6WnEgXBytM/Bs+JJ/78QCX8ahgIYvYiV4mpruLjQULOYYXBc4e4xBODJnUVZzBgSRtcV+u4SFei4FZxtIQW4P4SCyt59iNa9gjRmBazMSMWMeDWMJm3MB1bMel3PgkztWcYCUy3MQFcVOPiWVWhg42pfar9N1qkiz1NzrbKxFCqCPtEMJUiDwLIWS5sbnwh8ma9itL3XvktLiBezgpZuE3+eNyvKb9ytRdSFu8H+5Zf5rcz7WPNvBRiVbDX5QijuNW7r2DJ3/bST/ZcJXK3BXLq5vaC//Axzp+Ac7nBz2s99AmAAAAAElFTkSuQmCC", 50, 13},
    ["CANDY CANE"] = {"iVBORw0KGgoAAAANSUhEUgAAAC0AAAAPCAYAAABwfkanAAABZ0lEQVR4nNXWsWoUURQG4G/CFmo2G0VIF1KFQAQLg2IhpPMRArGySJPGPqmTPIKFaO0DCJpXEFGxEURimhBI5cZs2AjBY7Fn4Sak2IVdhvxwmHP/e878/wxz594qIowYk2hhKuP2FXkL02gm18q+Ozl/Cw3s4z1eYq8vUBWmp/JGlwUnky8FWy6aaBaCjVE9fYG/eIFXfdM/MI9qDGKjxhreVBHRxY0aDPxGGycZHfzJaGMCT/Cw6OlisZENg5o+z/pSsJPX4+TayZ0m3y6MlPWDYhPbmd/E8yoi1jGboseFWCfN9fkTnA0hNkp8xKPMP1Vj+HuMA9t6bxw6E3U6GQJHRd68LqbvFvnpdTBd4Wkx/jmOjWAYLGAF3/AFB1fUbOFxMX5X90LcwUYxPsRnfNXbYZdxv5jv4p6IqDM+xOD4FxGrEaHub/p8wLozPMNbLh6Y6sIMlvAgYwlzeoek79jFa/zqN/wHqCb0Y2EfwxkAAAAASUVORK5CYII=", 45, 15},
    ["CHOSEN ONE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAACCAYAAAAaRY8cAAAAT0lEQVR4nM3PoQ2AQBREwTkBVSBwVEAfVEEtCDqkARzJGTDkY0iOUMGNfFmzKSJmLIpAwonrbR02ZLTqs6eIGDB9Ysb9GzboMWJVDtbieADxkRHkoyqOkQAAAABJRU5ErkJggg==", 50, 2},
    ["CLEAVER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAAAuUlEQVR4nO3UMWpCURBG4e8+mxSCjc+AILYGJCSlYIyLcDtp0giWrijYmCatO0iTRWQsfI1FQIxXn+CBgSmGmfM3kyLCldHAM6Z4xQTrVMMgd2hXdY+y6ks84gUt/GCGJyxTRAyxRP/8znsUdsLNA+c/MUIX3ykiNnjIJJebL3TQSxHxi3RhoX9TYHVpiVOQIqLEAj18VLXBMV+ggTHmGJxG8TByfa03vOdY/BfFOY/l5BakbtyC1I0tOzomc2n0nSwAAAAASUVORK5CYII=", 50, 13},
    ["CLEMENTINE"] = {"iVBORw0KGgoAAAANSUhEUgAAACsAAAAPCAYAAAB9YDbgAAABc0lEQVR4nM2WPUscURSGn41iNiL+AkkQUfyoLQULbWLA2i6VXdr8AgshioWl2mhjqRa2NhaCQbS021WEwAomu1q4qz4Ws+JlnMUJuM6+cOCeO4c7z7ycMzM5dRA4BPaBVWAHqNGKUvPqkc/6o86r/SqtFE+LL2rJl/qtzqqdWYOGsKiT6l0CsOqluqQOtwos6s8GsKH21e9m4HZODVt4CFgAvqZo93/AXL3+LdUG/ADOgDKQBwaAlTgsQBdwDPSlPPwQKAAPRA8Q6gaoBvkdUInVlIH7IB8HZhLus9aesHkNHPwH7Gg9mqEqcEpkQnsS7AjwLeVhFWAZKAICf2PX465VidwOdRXLx4FfwEUdtABsA8V4E/eoZymG7F7dVceaNEwD6rT6KdwPC7rV41cgL4w+GL3NnPpG8bT4qO41AKypW+qU2pYFZAibUzcSIM/rLn7OEjAOuxgA3qqb6oT6IWu4eOTUE6CD6I9rHSilfBO8ux4BVoQAWAGhrhYAAAAASUVORK5CYII=", 43, 15},
    ["CLONKER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABYklEQVR4nNXVzUocQRQF4K8lYMa/MTAKBgIhuxAC7gQfQH0JwScR3KkLX0DiLnGbLJNNXBohCK7MJu78N+AiIkmwXFTJtMMMjNUDkgMNfW/Rt8+pOvdWEUKQiQEsYQoTaOBZbrGqeJL53SQ+4HVLvoHzKoRykSOkjm30p/gPjvCrlOuEwfQMYbQUD6e6d/FIyt3FozjAGvbbFS6StZ6L9vjehZAGztJ7wPskpN7m50OluBe2u8EnrOBbeaEIISxgHRfYEHf1NwqxD67xF7VEbA6vekCqKrawjM9EIScYf0xGFbGL1T7xuP53hCKEMI93uNTZWv/wVLTWLF4+BtsWfBWt9YVms09gDHtdFGjX7IfuT6FOU6mvIvkbfBSbfae8UGRciHUciydEHASn4v0xk947oaY5Xkc0hXYz8X6K4/dHu8I5QuAtNvGmJT+Iq5yCVZErhLi7i5gWrVnDix7xejBuASoAVAF0wMlOAAAAAElFTkSuQmCC", 50, 12},
    ["COLT LMG"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB30lEQVR4nL3Vz4uNYRTA8c+drgVj5NdGfmRlI9SwUiQiaZStbCVlI/8AZWNnZy2F1GzZaMZmhCFZiUKUhZlGzKCLmTvH4n0077z3uve+d8Z869R53vec857znPM+TyUilKSCZ9iMV3iLz/iEiaSP40nZwAWO4gTOdmJc7eID+9Gf9GOyoopclRX5Gj/Ss15cx7uc3Xc8Lvj+wkq8xECnSVUi4kqnxokBbE/6eEpmXswk37CjZGyYxQO8kRV/sYlNHT1Jr6JeiS5mawmYxDRW4VHS89RxSLZhwxjrZrQ64a5sNE6ndRV9LexnZB2En7iAUZzDEFZgNdZgebLbiQ84QjZa7ToynYINp+QmcAPbUEtJ78HWnM9uPM+tq1jW4huXMZVbf0nytYleaxohmjMTEUMRcSYi1kWEgrxIdjcjohoRpwr+/U18WsmmkvYNkh+tWTzEHQxi7B+7dxy7ZONwC1tkR3CeqaJTGz6WtG8kIp5GxPmI2NhB5b0R8T7t+rXCu8lcRw4udIfLSlmHkxHxOyJqEdFXeDeSK+TSUhfS075n87iNtdhn7pT5y/2cfnghU9INlVi8a2Sv7B8j+3/Wy+6DJaFsR1oxai7xKg4sYuy2LOaFOIN72IARjSfZf+UPY2o8Vu7ICHMAAAAASUVORK5CYII=", 50, 14},
    ["COLT SMG 635"] = {"iVBORw0KGgoAAAANSUhEUgAAAB8AAAAPCAYAAAAceBSiAAABaUlEQVR4nMXTz4uNURgH8M+9vQxNTE0WbGyU2YiNBaUUNf+AsrO0UBbKyk62JHt/BMqOsiILG5QyKQtDhpoppMFcX4tzyjXN3HfeO2q+dTrPeX6e5znf00tiDDzBLizgIz7VfQGf8RSLI+LPYFGSrut0kkEK9q9h35vkSkuO40lmG5zFT7xYdbse3uL3kG4a59Gv5xtYWhU3Vf1mcAjf8aPavqHBJK710n3uczjYMWYtfGjwFcHuIcMAX/Coyg+VDqdxqSVp8B47sGeE3/UG97GCc0OGVzi8TtBRZaS9dewrOKE85aQy9gEmFDL2sRPLKnEeJ3mZ5GaSy0mOtRBmrsbdTTKT5E7+Ymmj5G0wiwc4guctI6WMfl+VX+MX3iikmsBVbKv60Rjjq92qHb5Lsn1I/6zqpzaaq996u39xABeqfFF517HRdPQ/hWXM495mCqNz57eV73Nys4XHKU4h0vxWFf9v2NLifwBur2bP2wW9HAAAAABJRU5ErkJggg==", 31, 15},
    ["CRANE"] = {"iVBORw0KGgoAAAANSUhEUgAAABMAAAAPCAYAAAAGRPQsAAAAsklEQVR4nO3TPUoDURTF8d+EMWgjWrmEELBwA+7Byj24DfcgLsBFuJDUIWnSWKtoVI6FVwzDBDJgJf7h8L7uO+++4jRJdDjCGRZ4whvWGOEV790L37Q1NjgoPdZ6gjn2qq4ps318lLmav+C5xQNucFqHd7gos9W2LnpYSXKVZJREaZzkPsnlxt5OanHbeWGNJaYDumLj333MftNsMP9mf93sGIc48ZXD3emJxXV+OB8Sp09OyY4hBg1cSAAAAABJRU5ErkJggg==", 19, 15},
    ["CRICKET BAT"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAGCAYAAACB1M0KAAAAgElEQVR4nM3TvQkCURRE4e/Jooj4B1uA+RZiGTYi2IP12IlgBQbqgphdE42MdC/qiYdhBmZKREig4IBFhtmbHLGsEowqrP2mBNRYlYjYocENY1wwxQkznDFBixGuGD70A/Qx/272F/a9BJOUbXaklISPPKe16Z7nY7YZRfiDs98By3wc4fma3AQAAAAASUVORK5CYII=", 50, 6},
    ["CROWBAR"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAAAk0lEQVR4nNXSPwrBYRzH8dfPIjeQYuEORmUwkrJZbG5iMrqIAygZrMriAAwkkwM8Bj2Lkj+Dn+d1gs/72zcLIfTQwRYr7CQoCyFAGVMMccQcG4T8pr3l7H78SwyJ2pigmceqL13RfwyJamig8NNJn6tghsOzkJQs0Eo9pIg9Tv/+Oq8MUMI49ZARulin/Fp1VLGEGyOxKRfVq1bPAAAAAElFTkSuQmCC", 50, 9},
    ["CUTTER"] = {"iVBORw0KGgoAAAANSUhEUgAAACIAAAAPCAYAAACBdR0qAAABPUlEQVR4nLXUsUscQRQG8N9GLwQRiQmx8T8ICEkhhAMbm1gk/4C9ECNYirWdjb2kshUEQyBgmcY6ELFTgk0KhUMxR8ixvhQ3F84jbvZk94PHvjf73sw337yZLCLUgEV8xM+yBQ/qYIEMQ+2wLiKP0R6mYLQGEs9w/Y/xabzCE5zhC379/RsRVdtSRDT64omI2ImITtzGeUQs9/KyiPiMqZK77SQbK8i5wELyx3GImYL8Taxn0b02eRocKUmoCDmukt9IZIoQmO8R2cAjrFVA5D7Yr1ORMmr08KO/R26whVndc32JVrImXqRFcjwsmLTXI2/wqSSRdh235n36Po/y+Fb1g9bE1+Qf46hk3W7VaqwMxK8jIv+PGqcRMVm1Ip2B+ADv8PuO/BO8RauOJ34QH3SbfxVzeIrv2MM2LuEPYkKR10ZxY1YAAAAASUVORK5CYII=", 34, 15},
    ["DARKHEART"] = {"iVBORw0KGgoAAAANSUhEUgAAACkAAAAPCAYAAAB5lebdAAABjUlEQVR4nNXWT0uVQRQG8N9rN0ipILsLWykItjUoWxnUoo2r1rWoXR/BbW1dmKs+RDsXBdpCCkEIAi2EFoqJYGnRxj+V2nHxTt3b9b1q6Av2wGEOc+bMPHPmnJnJIkLJyHAD9zGAaYwlmcGBBLKSSZ5LRLqa2D/jpRrpT0WDyiZZxeohxwbeycmO4nXNElGmVONvPIiIpxExFwdjNCK6I+JPJFtxDUuYLzGSVXxNejduJ7mF8wX+3zFUwRU8R4c85E/wCBfxBadS/ybakvMazhbo67iMdvnR3W1YtF+ehzexk/qmMIGPiUsfvqXNrWI+i4gpXG+YbBmXsIXT/0iyFS2YRQ8qdfOuYBFX7cVk8vmAV3jz25BFxCbOFDiVhR356eyHn/JK70K0yO+tRiyndiu1gY06+1oTfR2/kj6L7YZ5V/C2CbFnGMRD9KIzrSuLiF68UMvJYTx2tJy8gPe4h5E6InfszUnyAtk3Jznh1f1f3ZNl4VhenEozj2PCDyw44W83xb+g8URq2iF+Qbv3DaP4pXIShgAAAABJRU5ErkJggg==", 41, 15},
    ["DBV12"] = {"iVBORw0KGgoAAAANSUhEUgAAAC0AAAAPCAYAAABwfkanAAAByUlEQVR4nLXWvWsUQRzG8c+dSXxBJCCKhYVGkCCmE0FsE5CUlv4dNtbWYiE2VmJnrWITsFGigoj4gpjCRoIagyQaA3l7LHaPbI7L5XK5+8LAb/aZ+e0zMz9mt5bELqjhPubxET+aNGhOWH1+spy73KTBS8yVcR1/cLhFPrUkI2V8Aoea9LlycoNzeLTNgvbKKgaxgUUMK8y3NL2AI30yshseY7aMx3AJ93BacUJreIKzA/hpq+kVDClWu4q3FW0YFyr9f/hVJhzBOvaV2ipe40CHppcr8Rd8K+Ml/FacwF8sSvI8BZ+S3EkymmQ8yZkkQ0lU2miStXL8WpJrSY6V2vckr7LJSpL9TfN70ho7DQ/xDJ/L1oo5mzU2g2kcL3fhARZwsdQHMYp3He50x9Qrpo/ixQ7jJzFQxrfxVXGLzOMGpprGj/XG5lbquIUJ3FXUZDsmK/GbJm1dsYBqjst7NdiSXdbT9SSzSZaSHNxmzHSlrmf6UdPdTKonOd9Gv5mtnOq16XoXh7OBD2305roe7+IdbenG9E5MK+7TBld7/YJ+mF7B00p/QvGL0DP6YZrizm4wgCu9TF7L7v7yOmVQ8QmfUizgfS+T/wfEDAK1oC5O4QAAAABJRU5ErkJggg==", 45, 15},
    ["DEAGLE 44"] = {"iVBORw0KGgoAAAANSUhEUgAAABoAAAAPCAYAAAD6Ud/mAAABKklEQVR4nK3TQSuEURTG8d+MkSk2FnbCwkY2FjbKZsoH8AVk5wso38BGslQie3vZscXSAslCE2KkFJMyg2sxr0zvzGuGeZ+6dTr3Of3vufeeTAhBTBs4xSX6cRHlJ1CM4lccoqG4icaxmoslV7DQRjHco4oPvKMniqvI4xMllNGTiToaQA63yLQJakc3uEY+q9ZBEespQ2AQU+jK4gz7mE0ZUq/tHApqj/+AOXQnmHexh3lMYhE7eGsBKaMqhFC/lkNzHYcQpiPPUAhhM1bXcmVj9KuEU91hOIpLOG/RRYPi37uQ4KvgBTNqs3X0V9D394YxnGj+RiN+hvVfqr+6pQTIA546gcRBMwmeAzynBRpVG65m6usUUg/K/+LZShN0jjU8xvYr6E0D9AXA3pDZrXRslAAAAABJRU5ErkJggg==", 26, 15},
    ["DEAGLE 50"] = {"iVBORw0KGgoAAAANSUhEUgAAABoAAAAPCAYAAAD6Ud/mAAABF0lEQVR4nL2UoUsEQRSHvz0viVkspgP/hQsiYrtoMdusYhU0CVaD/ZJgt5oEg0EwKKKCQcQoiJ7owvoZbg6W4eZ0dfUHj9mZeew37zePyVRKyoAucAHcAfPAWNgrgLPwnQPHwBMwwXAVIa8NbKGWY9dqeh+x96Hmg0kWKmoBb8B94nS/VgNYA66B/b+CALdN4Ia+33M/+EGP/j2M0guwjbqsrqgb6nPC70LdUzvqgfqqLqqN6I6TES+sJ0BH6mzImVR3vgsYRCMq8zFRfg5Ml6yo3DTNaN5J5F2GcQkYBw6rgsrltUPvxzqpatNX1q3SfxlinVY+/RANQBmwkMg5rxM0A0z9ByjuvrJ6dYKugE3gYQikVQfoE6lqjTYJGXlDAAAAAElFTkSuQmCC", 26, 15},
    ["DRAGUNOV SVDS"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAHCAYAAABKiB6vAAABW0lEQVR4nK3SvWqUQRjF8V/CKjFaRAW1iKIIqdNob6HgZ2kRAqkFL8BOvIRgo5BLSBkheAFG0CKQJgixUlyE+LVZEjVwLOYtJsuuG3T/MLzvA+eZOc/MGUuih0mcq+rP2KnqG7jY23QIzuMIdrE3RNvBu6ruYq2P7joWMN/Cc3zBN/zGJTysxEt4gwllyMfN/yjYw3dM4StOYRunsdn4gTNYxVZP/3Szx82xJDt40mxIubUTlbiLfdzHtX80vIo2xhuD20P0H/DWwUEo6aiZwDH8kKSdRJ81meRekqUka0kWk9xO8iyF/SRPk1xt9BeSHE0ym2QrB5kfcMbIVqtnwrO4izvKc7/EIjYqzZXqlh/huBKJNn5hHXN4XfXMDHmB/6aFk1hWctnBCh7g04CeW813RYldt49mHe+VTG/i1cgcD6Cl3N4GPg4wVTOu5LuDF3/R/cTlURg8LH8A7IDlsCBMiSEAAAAASUVORK5CYII=", 50, 7},
    ["DRAGUNOV SVU"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABs0lEQVR4nL3Uv2tUQRAH8M8zx/kjxpAiKIqIFmKhWKiFBsTGRrAQW0GwFKwUsRZtbAX/Au0kRpuAIFHQLoU/wVYiIkbRBA1yp67FTvC4vNzhyyNfGHZ35s3M+87ObJFSUhG7cB6/4vwYs9iJgyFb8QAv8QlDaCDhbtXEZShWQGQvXlX0/YOBqonL0FiB7xyuxL6FKYzgMg7jXuiP4xKeyze0Tr6RWlGklEZxA4M1xNuCMXzGU/zGEbzGfB/fAczIBVqPZ7gftqM4IRd+CBfxPWxNtIuU0jhO1UCC3DJretjmMIw2fsZ+Qb6hQXnOvsT32+Q5msFJnOmINS8XaZHIzQYO1USC5Uks2kZivzYENsTawke8i/N77A5ZkAltD9umrtgbi1Rt2n9Y2ornMCG31yR24BuuyRW/hdH4oSrYr3ymm5guM0zK/bgczuICDnTpG/ga8kEmAo8i2Wa5pariRU9rWoqxlJIe0kwp7Snxuxr24ZRSO3R3+sSqTbp7+on8WvRCC2/lyndiX6zH/GuBh33rXBO6W+v6f/hOya/Om5Dp0M/itjwPq0akc9jHcXq1EteNv5A2BF7pvrjaAAAAAElFTkSuQmCC", 50, 12},
    ["EXECUTIONER"] = {"iVBORw0KGgoAAAANSUhEUgAAAB4AAAAPCAYAAADzun+cAAABbElEQVR4nLXVsWsUURDH8c+eB4KI4RQEEbEIAUkXK/8BsQj2CqnS2VgIVoH06ZLKImkCgRDExk4Qwb9AYqWRkCIQhBg0UULQSybFe8J67C6Xu/iDZXnzhvm+eTszW0SEBt3DW6xht8Gvg23sYB13sZntBfYwhtt4jPdFDfghRvAMEzjAlaYTnlE/WjUbH/AoQ+FiQ5BfA4C/9YLHsYyPmCzZLzQE+T4AeKVdWkxhHtcqHI9wuSbIHm5hBm/6BG+UwfdroPBbKp4qeCe/X+JLn2B/r/oSHjT4Xc3Q1zjMsK50zcdSBe/3CwURISJmo15bEfEiItay7/WIWIyIVl4P9LRxA88rzrQu9eVXPMFstnfxDidnyrBHRUQs4GnF3qRULNPSt+tIQ+AnlvBnWPBGDljWLm6Wgt+RWuqzlPHQaldASRVazujTecDKqptcq+cN6lUREV3/TqYtjKLx7zGsWngl9eKJNCTm/jcUTgGHOrFGuXB0YgAAAABJRU5ErkJggg==", 30, 15},
    ["FAL 50.00"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABl0lEQVR4nLXVzYtIYRQG8N8do0byMT4WigUyk7/AnsiCsrBjJx8liQX5IxRNs7BhZzPK0grJxlIaJJJIZkFjmsTMMI/Ffadu0wx3bjNPnc499z3Pueec933PrZLogI04i2M4jJ6WvC2YwDb0tuTM4Afu4yReLOiVZCmyJkl/kpdJZtMNi/FmktxL8jHJSJJPxZ5u+NxdLLcqyXH8REqnNxQ9J/2NdzuxtWUnu2Ac6zDZ0P2N9XeYxeYiMIXpKsloITxWb/s4vhe5iiG8L6QzOI83GOyQ6Dn0qY/WYvilbuwcpvC5PI8UvQrrGz6pkgwV40JjYRA3sV19PifUha3GDgzjNz7gCo4U3hhG8RWHsKkRc3yevazoVXf7YLH7cA1HcRFPW8Q4UfQkTuGhOuE9eNLw6zRV2qIHX7AbB/BMvZX7/L+ICtfV0wtOF/5a9e6NLX+6/0CS/WWSPEiyq+X0qpLcbkyT4QV8BuZNpW8tY3eSXrzFLVxSX7RW9eMG/mAvLq9Ek5eCKt1+iG0wgEd4hdd4jjsr9bG/36imFGTzFhEAAAAASUVORK5CYII=", 50, 10},
	["FAL 50.63 PARA"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABl0lEQVR4nLXVzYtIYRQG8N8do0byMT4WigUyk7/AnsiCsrBjJx8liQX5IxRNs7BhZzPK0grJxlIaJJJIZkFjmsTMMI/Ffadu0wx3bjNPnc499z3Pueec933PrZLogI04i2M4jJ6WvC2YwDb0tuTM4Afu4yReLOiVZCmyJkl/kpdJZtMNi/FmktxL8jHJSJJPxZ5u+NxdLLcqyXH8REqnNxQ9J/2NdzuxtWUnu2Ac6zDZ0P2N9XeYxeYiMIXpKsloITxWb/s4vhe5iiG8L6QzOI83GOyQ6Dn0qY/WYvilbuwcpvC5PI8UvQrrGz6pkgwV40JjYRA3sV19PifUha3GDgzjNz7gCo4U3hhG8RWHsKkRc3yevazoVXf7YLH7cA1HcRFPW8Q4UfQkTuGhOuE9eNLw6zRV2qIHX7AbB/BMvZX7/L+ICtfV0wtOF/5a9e6NLX+6/0CS/WWSPEiyq+X0qpLcbkyT4QV8BuZNpW8tY3eSXrzFLVxSX7RW9eMG/mAvLq9Ek5eCKt1+iG0wgEd4hdd4jjsr9bG/36imFGTzFhEAAAAASUVORK5CYII=", 50, 10},
	["FAL PARA SHORTY"] = {"iVBORw0KGgoAAAANSUhEUgAAAB8AAAAPCAYAAAAceBSiAAABlUlEQVR4nL2Uv0tcURCFv923CYiIBgyIGgVNlUZsRAL+gIBlwCak0t6/ICmFFBYpRAKKjXUgdjZpAiGghZUiSURS6CI2QQQVNRK/FO8K6+Pu010wBy7cO/PmnJn7Zi4qaqNaVt+F832sJ+qh2nttKwHvgX6gE3gFtAIF6sNT4BL4DZxW2LuBNuARMA+MA6cF1TqF8nBEWkBzxLcGjAEn9yWeB4ELICmRZtnyH8UXgTMgQZ2zNvzNsbepTepztUNdV7fUHnVUfV3ZhEXgHNjPyfSyYn8A7Fb5rggsAMfAauB8QNpsZeA7sHcjImTxWJ1Sp6vcxB/1Y6hoJoxMDG+9OV47wf7MyPhlDYm6XEG2pw6pb9QNdVPtVr9EhK/U9gzf1+AbvE28qC5lyF6oXab/rE9dUQ/UXxHxckRgSd1Xh/PEC+p8hmw2EpCYXnsMP2MCeet68yFD9ENtyAn8FhHfrlW8FPpuFngITAAJMBlmsRpivtqf5Ew27erLO2T9OVL5Tq2VF6zvdf0EdAAb4TwAjJDO+J3xD3mTbSbom+uYAAAAAElFTkSuQmCC", 31, 15},
    ["FAMAS"] = {"iVBORw0KGgoAAAANSUhEUgAAACgAAAAPCAYAAACWV43jAAAB0klEQVR4nMXUz4tOYRQH8M878zavQmnKgkxkIaWXYmtBkYj/wg41ZWXFamLF3p6lhcKGWCgbk/ErFppGTWj8GF6GGWOOxfOMruuaH/ctvnW7557vc89znnO+52lEhJo4jgvoxXd8xjSm8A1fsz2NL5jBJ/zAR8yhg0ncwIuqTRpdJHgLezGBlzVjNNCWklyP2T9WRETd524kbO8ihogYynEGqvgmLuNAIecrGEJgJfoqTj6FFdneILV3IQyihbc4hAd4I8mgldf0VJY4Ip5jyyIb/AscxnVJmz0YQG8jImYlof9PRH7uSd1Zi80Yb6qf3AQu4iHW4BQ21ozVwSZ8KBPNmgEfYz9eF3zrcDrb5/Aee3BfqsoxnJRaWMZYVXIgqjEaEYMRsS8iLpW4TkS0S9PWHxHvMj8XETvyv/N8T0QcrDPlxQqO46l0N53FzezfXTrTMB6VfEfRn+1rGPH79O8sxFsWmlLpn+GOJNSqFszjiXRBl3EkvwPnsz1T4PtK30vHEsp8ptDekQq+ERGTmR+r4NsRsbpOeyOi+nIsn2ERfpUkDzhR4rZKkukss26/UHeKi+hgm6SzFnZlfwujeNVN8KUmOIbbuLrAmuFuEvkbfgLCvN9GPBQiawAAAABJRU5ErkJggg==", 40, 15},
    ["FIRE AXE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAABPklEQVR4nNXVSyuEYRQH8N+45NoIUS4LKcpWSlZKlJ2SknwSGx/AF7BgY6t8CiWKlS8gC0Wm3GbcjcX7TPOaZmpcwvuv03nP/32e0/k/t5PK5/MSiB6sYxGPUPOn5XwPc1grBEkWAktIkXwhXeiEuj8u5LMYxDTGY9wIdv+7kDTmsYxJPKGlZMysIGQLbzgPP7owhL4QZ0MCyCGDS1wEnwn8VfA53OAOz2FutoqiG9AfbAxTwRpjY+rLzOslOlozoufst3CD1zJ8+xfz3REJWcVGIM+xgyOc4hbNqEWr6GJ1BB//TqMtWKtodSsh/cWCK+GKSMhmKPQW23j5geT1IkGFVW7y8YhUiwfcx+JHHCgee7iGVMI6+wT2SrgTDCetj6yU4QawnKQdGcWh0MlLsJ+kHVnAMc4U2wHRne5+BzbzQJPooZf9AAAAAElFTkSuQmCC", 50, 14},
    ["FIVE SEVEN"] = {"iVBORw0KGgoAAAANSUhEUgAAABYAAAAPCAYAAADgbT9oAAABD0lEQVR4nLXSTytEYRTH8c+9Rv6WkIUs2WrKfmoWysY7sPEilC07O2t/XoKNNZI3ICk7sbJSSgYzqGMxd2oa18hcfnU6T52n73PO7zlJRMAepnGIc8W0g/UkIqo4LQjrVCPF0h9Doe+/wHeppre96ANPeMV7lmvYwnwSEWWsYBVTOYBjzGEbdYxjDRXcYggDeMsiQU1EtGI3vqoREaMRsRkRadvdjbZzbiTZus3gGoMd3dZRRT/GcI9ZjGC/m0+lLC/nQOEiA7/gIfP1ElfdoNBq/SDHhoiIyk8jd7MizUac6HizhknND/m1UizkQOGsV2gLvPhN7aRXaAtc/qZ2VARcwo2mn89ZPGpuwXAR8Cccv8rWqd2QmgAAAABJRU5ErkJggg==", 22, 15},
    ["FRAG"] = {"iVBORw0KGgoAAAANSUhEUgAAAAsAAAAPCAYAAAAyPTUwAAAA0klEQVR4nI2SMWoCURRFz4zaSSC9lRY2NlaKRfrgErIBi4CltQtwF1Y2gtO4AAMpsgaFWAhCmlRhCJ4UmcGvqOOBV93z+ZfHQyWYZ//5VdfqOMxDsaS+eco8lGOOvAB1bpDLVaALLIAkyPcndvbFUH1Um+okqJGoPTXKO9cyeaYevMyHWo/UEVADXm/1Bd5j4AdoF4gAnRiIsikiyuX0DjmNgQqwuUNel4Fd9qCIFeqD2le3V9ammqqt8DZ66vcF8aAOzg8JtaFO1U/1S12qT3n+BxKfG6GUHtoVAAAAAElFTkSuQmCC", 11, 15},
    ["FRYING PAN"] = {"iVBORw0KGgoAAAANSUhEUgAAAB8AAAAPCAYAAAAceBSiAAAA7UlEQVR4nNWVPUpDQRRGD75BELFRxMLC0kpIoWtQxM4NBJIqNmndQMgObIONuAGxcgPWNoLiT8wSYqHx2OSBBJQ38yaFH9xmmMNpLt9FJePsqGfqnfqujtQbtaUuzf7PJS3Uvvrl73lR9+Yhv/xD+jNjdTenvFNRXOZBXckhD+owUq56orJAvRwAmwlcEyAAG8ByBFgAW8Ai0EoQAzSA4wCcAlfABbBaAXwC9oF7oJ0oD8B6ALrTh7UIcBs4BCaJ8g/gte7CHSUsm+ptjoW7Bt4SuAFQW/4J9CKZR+Ac+P8NV7Xbn51Tt5cTddW+AYZBqQeVEH41AAAAAElFTkSuQmCC", 31, 15},
    ["G11K2"] = {"iVBORw0KGgoAAAANSUhEUgAAACgAAAAPCAYAAACWV43jAAABKElEQVR4nM3Vuy5FQRTG8d85FCQuiUKiJrQSiYhGQsEDUCupFN5BR6NU8BAKHVGIJ0CiIEFQ6cgRYin2JI77YY7LP5nM3mvN+vY3O3MREerQJiJi6IN8OSKWvqNdVh86MMq7ei0YSOO+RCkiRtBZw9j+9KHzqlg3JtGEZpziPuWaUtvAMdpwiS3sfsXgDoZrLfgGy55P6jPWcZGeb37DYA4L9VqDP8XUfzfYW0bDX7v4gNtGxU78KU5wmFF/VoqIdk/nVzPmEFjEQ4p3oTXF26oErjGNmfS+jTvsoYIjrGQYVI9bZDyeGI+IwapcT65+Y9bsCmZTX8GV4g8Opv7ivaJaKUVETn0f9hVLZBNjuYZeknvMzFdpbGdqvUmuwTWsKjbPQb6d1zwC+CMsNCrWQC8AAAAASUVORK5CYII=", 40, 15},
    ["G3"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAALCAYAAAA9St7UAAABaUlEQVR4nL3UPUscURTG8d/qiAoLmyZaWKRSG0FIkSIhiGiTQpJPkG9h48ewFyVNCosUgVRJkxQJqURLsRDFqEV8Ib5tomNx74CZ3ZWZEf3DcJkz55z7PJx7p5amqZI8wnP8wO+yxRX5hDdodkpICjYawSwaqOMVPuLX3fS1cInjXOwfhjEtGGpLgg9RXCcaeIruXHympMgUtZI1GReYxF4uXkcP1NI0XcH4PQuBK3RVrF3FEXZz8QY2UU+0umzHMdZvvI+ht6CIWSygD+cFazL6Y90W/t6WmGC/TbwpXObP+IKfwlnNeIn3GBJM7uOPMOYzPMHjmFvDQUkDGYXrEuH8pcL4MuFfcXJL3be4yRAWsSyYHcU2lvA65g6Ukl6RBPOY034ynRiLD+wI03gRexzmeg3eWWUBEmESZXkb1ybeab2EN+/dgxip+heZiuuGVhP8b+TBjlYVnmECpx2+7wom1/C94h6luAbtLU9JNGp1kwAAAABJRU5ErkJggg==", 50, 11},
    ["G36"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB6ElEQVR4nL3VO2hUQRTG8d+uMQkYNIgKxvgqFCwEEQJqaxobLS0UBAsbG4tYCVqqtZ1YJIgsItgKMa1E8FWpKX2DEVFDXE18HIuZ6HVd4+bG5A/DzO7MmTnnO2fmViJCSbbhcUnbXbhd9uBmtJW024caJlHP+1Ql565hKb7jKzpyX0Ul2x/FFQyVdbyRuQbSg8M4jhW5FXmHviZ2n/Epj2t4gDHsx0t0Flod45IQy/AC9zAym2OViLguKfYs95P4gqm8aR/WYTO2YElLIc+PD5IoXVIgb3BBymg9r1mJ7jz+1oadWCuVQDOWY1BS9Rz6/7/ff1DM9qrcv5WErhfWdOMjptvwSlK8GT3YLmWhA70lHbsv3Z2Zl6UT7ZjIvzfgtVQFf+OSFExTKhExgr0YwFNJgbpUo8/xSFKikdM4IZXhmFTHW7GnYd1ZnCoEsTBExM1ITETEwYioRIQW2uVsNxgR/fm/MxExFb/T1eJ+82pV6amEI7jaonK7cSiPh/Ae6zEqvURFVs9b7VaIiNGIeDiH6KsRcSerPdxkfk1DRg4sVkZu4OQcYu/160U532R+XLpbMzTemYWhpALtEXFslvlaISN3FysjZZjGxVnmhwvjHdhU8pyWKRvIv7glfTsGsBFPFuicn/wATdwxlPjWUp4AAAAASUVORK5CYII=", 50, 14},
    ["G36C"] = {"iVBORw0KGgoAAAANSUhEUgAAACYAAAAPCAYAAACInr1QAAAB8ElEQVR4nLXVzauNURQG8N/hupebMEAikVs+y2c3mUiEMrxlJB8TGUkmpvwFBqaUkoGJUiZXKUoZSEImlIHkI5Krq3ze+xi8+/DinJxzylOrd++91l57rWetvd9GEj1iO5bjLCa62DcDz7AJz9sZ9fUY1C6MIliFj5hS/N3FN/SrAp7EdHzCIObhMw7jVNH/hUYPjA3iJE600H3Dlj/WxtAo40l8wRtcwTjO1WwfFp1Gkh1lczv0YxaWYBh7MbvTLAq+4xVm4j2uYzPWlUAHit0tbG0GNlYOOqCieExVovHi8AiWFYdrVKX7n3iMeZLcT4W+JFrIodr4aP4/didZ30hyA9uwAk9K1ItUt2YOhlTNG1UpphVZrSpHJ7isavQXtbX5eFv8DmChqndHMCHJaIn0RpILSY4n2ZNkbhsGmzJUy/J8yXRnCwau/sNPUxpJ1jbnfZhay2AfXnbIwrHyfYhLuIOluI2NheWmvhPkN9skN5NMJtnQYWaSrEzytTCyP8nsJIuS9CdZnORujbGLXfj9KZLcKY662Xi1HPo8ybQW+gu1wB71EtgUnMbBDummeuEfqJ6WM6pH9U/cq41XqS5Rd+glm/xq/gVtdMP5HSO9MNYrnuJ1G909vKvNd3XrvNef+L8wgWv4gIuqm9oVfgDr8cpHGQRouwAAAABJRU5ErkJggg==", 38, 15},
    ["G36K"] = {"iVBORw0KGgoAAAANSUhEUgAAAC0AAAAPCAYAAABwfkanAAACKklEQVR4nK3Wz4vVVRgG8M91ZmzMNH9gmrkJEV0EKigIigi1qV1Qbt1IMCBZC9Gl4EZo179Q6dIIcSGKmxJhNlYui8ZEaPzBoNaUU93HxTnXuc6MM3Pvdx544Xzf8z7nvOc57znn20qiAd7BrT65+/FDP8RWg6RP4xOM4/9qr+AnfIchPMVAtTZalRscxDA+x5NeJh7sI9lNOIITeBVvzuifwLraXtXlDyaxEr/hGL7FdXz9krna+FJZ/HO0kpycJ8F2JazGZuxQFBqYh/MyPK1Jw5+4h7eVBU7UMf/BGzVmCr/iM2WRqzs5tZKM18B9uF0Hn8JfNehdfIQxrMGpPhJuggksV0rvLqZaSUaxBxvwYA7SoUr6pcbcaJDAPUXlDjbhj9peruzmWFf/EH7Hge5BBvGotnfiKl7HbmxVDtdwl49ppYdxHGsXkexjZZu/wn+LiO9gKz6d5U1yKQV3klxJMpJke5JWEgvYxcq9lOR4ko1JzmQ2ji5irLlsKMn6mf5B0zfIfXys1NBisAfv1/Y5/I0VVckL+LAr9nYP6nbjXzyc5U1yraqxqwcFWkm+r7wf6/eq2rcxybYZSo/0qfScNqjcmz/jZg8KHFZeNPhCuYM7D8S4cqAnlXuc6fOwNEjyQZItPa52b5LRJGO17uaK6exEktxaSqWbkJctUFJnu5JuJ3lrqZJe1mCT2uYvqcszvt9rMNcLaPLDtBBeUx6i8/jGi49GIzwDdb6ek0arAxsAAAAASUVORK5CYII=", 45, 15},
    ["GB-22"] = {"iVBORw0KGgoAAAANSUhEUgAAABwAAAAPCAYAAAD3T6+hAAABUUlEQVR4nK3UPUtcQRQG4GeXBSVIAgYLSZUmBCRFCoOCrV0Ka+3FIhD8ESlEEJI0FnaGKFgEf4DZwmBno5WEVGoRIaRLFNSTYmfx5jp3ZeW+cOB8zbxnzpmZRkQs46EOGniNUb1xhOOkP8J4IfYXWzhP9jq+dYONiIg7Ns/hLT4kfRJ7PXJP8LNrtO5B1i/+4HeRcAVDyR7GTPK38b20uIU5TGMq+R5nSHbwI+mfsNsNNDIdfY6v8nNcwBu8T0SDWExFX6ScY2wgP6qIyMlG5PExIpZKuZsVe2Slma2CsQr/FQ5KvgcVuVnkLs0EXmT8v3CGEcwn3xM802nteWbNbWSO/aWine/6aV2VlC/NS+zrfABFXOGpm8d+bxRn2MJqhgy26yArE87iVUXeWh1k+G+G7YrZnUZEs475lZ/FSEVNh7iu64BFws+4zOQM1EUG/wAKREZ/zXo9+wAAAABJRU5ErkJggg==", 28, 15},
    ["GLOCK 17"] = {"iVBORw0KGgoAAAANSUhEUgAAABQAAAAPCAYAAADkmO9VAAAA7UlEQVR4nK3Tr0pEQRgF8N9eZQ2aFN/AYLBYrYLNpPgCFl9Bk48gYtksgj6ACGajIAgWETGLLAYNpmPZCxedvbB/DnwwzDdzvnMOM50kGzjDlcmwg3NJTjJFVOhMqKyJfoVL3E2JcKaTBLp4wsqQg0d4wTK2cK3srC9JXReFSD6TnCZZa5w7aKz/VdVgXy1MfMAhtlENFHbbPNeWl/A+uNTEMb4w29h7xM1QxoHU3SGvYK7NXpvlzcKsN/y02SuhwgL2Cr3eqGQ14T4WC73XcQgluS9k95FkftT86gzXC3Oe8T2OwPrr/cXtOGTwC3lWNDiscuQ8AAAAAElFTkSuQmCC", 20, 15},
    ["GLOCK 18"] = {"iVBORw0KGgoAAAANSUhEUgAAABQAAAAPCAYAAADkmO9VAAAA6UlEQVR4nK3RPUpDURQE4C/P30orEawtbMwCLMXWVreQFdiJra2QKr2CnV1wAS5AEURsrEQEXYCIY6EPQrx5kJ+BA5d7DjNn5rSS7KCLS9OhjWtJupkhqim3GsZHhXPczIiwaiWBJdxjc8TgCR6wjl300SrMvUlS10UhkvckZ0naA3Odgfe/Gsxwq6B4h2PsYw4bWGjyXFtewyuGj3SETywPifRHMv6teliw+51kvslek+W9gtYjvprslVBhFQeFXm9cspqwg5VC73kSQkluC/m9JFkcN786w+2CzpPf646NCqeF/6tJyOAHPB00BQ9CloEAAAAASUVORK5CYII=", 20, 15},
    ["GROZA-1"] = {"iVBORw0KGgoAAAANSUhEUgAAAB8AAAAPCAYAAAAceBSiAAABv0lEQVR4nJ2UvWsVQRTFf6tPIipRMCGIiChBUDD4AbGxMURJJ9iJoIUfhZUK/gk2NiIoltomhRBsA9ZWIfiwsFAUSWHziIkGYl5+FnvXjI/dl3UvXGbm3LPnMDt3JlNpGFPAI2ABWASWgaUYl4EVYAIYAB6WCbSaOofhSWAc6FZwMmCwSqAFzADfgH3AnprGg8ApYDvwChgt4awCG8C5Et02cLkFXAR+A8M1jXvjILCjorYXWAM+AG8CGyPf9IlM7ZDvuklsANu24KySn3svz1YIVEXRjVmCvQO+kjfVGvALeJDU2+Q7/QzsJ2/IZ8Au4DtwHXgNvERdV3+qU+pZdVQdUXerqCv+G1cCT7Od1J+ok4GfVs/HfGfUr8X6AOqceqtEsMgz6vtE/EUJZz5qs+oR9Wjk4YRzKDj3CqzKsDfvJ+YddTipDandqN3tozEUnDsFtlWzFDEd5wt5cz5NahNsNtNcH41O9FCnAOqaLwKPk/VV4EbMJ2P8Anzso9Elv26fCiCz/vM6AMwDx2O9Dtwm/yM3Q/xSXTGg9pkXOab+SM6/qx77T42/2eSjC+pSmD9vatzUvLi/b918CxrlHxyykmaYSfikAAAAAElFTkSuQmCC", 31, 15},
    ["GROZA-4"] = {"iVBORw0KGgoAAAANSUhEUgAAACkAAAAPCAYAAAB5lebdAAAByElEQVR4nL3WPWtUQRQG4GfjwqoorhIIGkgIqKVVQNBGwcLKStDGSvwJorWdjT8gNhb+ArEQ3E78KCWgERvFgEGLxM2uRqNyLGaWjZf98u7iC8Odlzkz8875mDuViDAGjuMemniHTXxBG638beJi5tfLbFIdR2EWdgKX8XCA3W78KrtJFTek00P9H+YewUl8x3mc62PXxFGs41EZkZWIaGMVx7CrzCJ4itN9xlYkL77K/VnslxzUlsQv4zC+YgvT+IFv2K5ExEfMYKqkwMgLbw+wqWFPyfVVpXwpK5Akcm9ug/AA85jLtjXdQnuDs/iQ+zXJ+y3Zk53yfok1KQQbutW5gEt5YgdLuC3l25YUliVc22FzBzfxU8rZadzPY/NS/r/N8wcjItYjYjUi6hGhRzsVEc/jb9zqYXdlx/iLiFiMiLk8thAR+/qsP7RNZY9c0K3wIp7h7tDTpjuzg6tS6Fo4qHt3lkI1ixyGzQLvdQt0rqA1vJZydSIYtWA2CvxQgdexmPsNExTI6CI/F/hMgZ/R/Xs1xhHUC6OK/FTgswW+IuXteyncE0VlxAdGRQr5gczbUoh/T1pQL4z6wAg8kaq1gcf+k0D4A0358UBFsaTkAAAAAElFTkSuQmCC", 41, 15},
    ["HATTORI"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAECAYAAADMHGwBAAAAnUlEQVR4nLXOS2pCURAE0HMlfmIUNCCuKzvI0py5hywkOHYBOvEXBdtJDx5BHhfFgqYKquiqEhEq0cG1NvwgCj4xTW7qNv4pEfGNeUVJD6sW/w1jdDHK/Af6GOIdg9T99HqZ7eaoScWOCzbYYo0FliUijlnwapxwzDvhgL8Gb/M2d7ipd/eel4j4wqxiyAC/Lf4lS87Y/xt5qPj/FG6GtjGY12SQPQAAAABJRU5ErkJggg==", 50, 4},
    ["HAVOC BLADE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABpElEQVR4nLXVu2tVQRDH8c/1QRQNKFgZRLGwVhHSCtZqZWejpYWNNqKi/gMWAQsF0UJtg4gSotiLL0QjCIJEBAmRGImPGEJ+FmcvHJJcb3Jz84Xl7JwzO7OzZ2a2kcQqsBGDeIBr2INZ/MZfTOPPf9ZvRh/24zG+tXPYKIGsxSHs6mDTn/AEzRPZh6s4WOQf6MWaRdbO4JcqyKliYxK7sRVzZTzCdQwVeSFJ+pOMZGWMJrmf5FWSuRXaavI+yUCx17Q5muRikr4k6kOSmSRDXXLeTZ4mOdni22ySh0mOJelJopEkOI47HaRVO8ZxoSafxzCeF3kvjuJKTecStrewVy/oRnlO4EwzkAGcXtmeW/K9Nt+iKvTpIveoGsPkPJ2GhWTe+zHcxS28k+RUkp9dSIWxVGm6FKaSTJQUWQ4zSQaTHEmyPrUaaXatHTihannt6MW6mjyCm/iCTbiMs0uwsxze4LbqD4wvptAMpJtsK85e4BwOqO6Pj2X+ARtUh/dMVSdzeIt+fMYNVTu+p0qd1+2crkYgvWWzh/GyQxs78VV1zyyJfxkRnYFvaWCLAAAAAElFTkSuQmCC", 50, 10},
    ["HECATE II"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABu0lEQVR4nL3VT4jNURQH8M+b+cmfMv6FopAFGlHDStnJRoqNxE4WktlY21gpG0UWw1JNWSglFNlaqikUg1HqUSQxkaF5x+L+1OvH75n7Zp5v3X731z3nfs+953vObUSEHmIHxtDqJQn0deGzNMP2I5Z3wZGNItO+gdX4ip9YjPU4jFt4hAEMYis24R4ezFG89YFlSmsDXmdynMRIpk82cjPyRpJKYAorcAH3cRyHpIwNYg3WYQLLSv/dpX0fTktZnA36JQVoRMR57JS0P4X5kmz6S+NpzMMlXGvb5CYOdiBpYm2H9XFMlpzNzAOQLuo9LuJIgSHsmYHjASxo+x/6h33dIUKqtXG8lS7qywz4q/iOH1KdNnKktRLD2JZJ2JJa8CS24BzeSQ3gU+ZedbhdYGEHg5cYLccL7MOdcm1U6khnsbHG/xXOYAm+YRGu6y4DnRERz+NPXI2IXRGhMjaX69MRMRwR2yPiSkS0Kv6tiJiIiGN/2aMno8CqtnM1cQp3pYKv4nct3cDlcn5C0ukHPMFjPJWk9N9QYL9UfAN4JrXLOuwtv9UH7ujch5aHAg8z7Mekt+BzT6KZBX4BjRT2nNo+BfYAAAAASUVORK5CYII=", 50, 13},
    ["HENRY 45-70"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABIklEQVR4nMXUu0qdURQE4O83okjUQkGxsRESxCBa+AaCRRB7S0GLFD5GUlsKtj6CD6GgiOaiiUWEBEmiEgSNeMlY/Kew8ZzjhePALtZe+zIze9hFEo/ENNrv6J3jEv34jmM8+kJ0YR7vcQHFA4W0oA8TWHwCYsHfe+55iVO8wF6RpBqREyzgB5owinG8U7r8VKgl5Ha/A81ow68Kj9YiyRrGqhxyhlUMo/vW/Dmu8AFHeItJ/McUDuog/weH+FdjbW0kWcr9sJFkNslQkrkkr5NIMpBkN8lypW7oaMZWnZp/YwYrylwO4CdG0IleDCpfpOGoJuQa+8oMHipjs443yp/oG742gGNdKJJ04yM2sY1PlfqzMrs9eIUvStd3PJPr1XADdZTrpjR8aVoAAAAASUVORK5CYII=", 50, 8},
    ["HK21"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAALCAYAAAA9St7UAAABhElEQVR4nLXUPWsVQRTG8d/K6uVKhFwriyRoLGxUBCt7sZKAoDYW+j1srMTORhubfAkLUUidBAWJEhGMovhSeDV4IyYQcsdiprhZdpPJav4wzO4+z5xzZs8wRQhBC05hDC+x1SbAHrmOcTxqMhR72Mgl3EAXPVzEM3zDRsU7joBfNXF6uQlHmMQXXG0yFCGEWZzZJdBRnMAnTLUoJJff6OBgjbaMO5VvQ/xBWeIxbmUmGmT63qOPY5jAgcx1Y2leQzHyviF2/lrFP8RPHCqxkJlkDd+xmgKvY7rB20vaZiroLmbxDveStoQHSR9l3fajejx5PuxUXBFCmMZKg76C+5jDmxp9gCNJ7+ArXmMG50d8h1OB+0Yptr6JF3jYoF0QN7GJKzid/JO4XPEO/63M3SnFv/UEP8Sj0xfPY19sfxM307wktn8LZ/F8n2rdmRBCm9ENIayGyO0afTFsp9MyT/bIvU2qTOFjen6a4e+2zJNN2XLdW5zDSXyu0QeYxyv1l8R/5y914O4uU5hBIgAAAABJRU5ErkJggg==", 50, 11},
    ["HK416"] = {"iVBORw0KGgoAAAANSUhEUgAAACwAAAAPCAYAAACfvC2ZAAABx0lEQVR4nLXWu2sUURQG8N+uGw0qIS4+EBXBxkp8BLGzNo2FWNhaW4i21nYBwU78C6wkgq9yk0pRAipBBUXEBxKIhCwY0eyxuFeZDOs+spsPLnPnnjvf/c453zBTiQgD4DDeDELQBufwGU/aBasDEI/jKHZg8wA8ZezuFKz1SXYElySBFwvr9/EOLakIFWzFKFbzniqitGc1a/iFu2hgL17+T0AlIhrY30HkJ3zDGCaws48E4SeWsQnfsQdLWMHBLLyaxU9hEi8wm58fzYmOoFWTWnuow4HjOaGxdYiVD1vBtjaxZha7iK/YhVdZ/ERB8I/Ms1CJiPlMtiBlX6z2e1zBPWyR2jbZg8jfmJes080SXzCHGTzoyhwRz2MtmhGxmMfxiFAYZyLiWXTHndJzQxtVyRt/8RT7UM9jrpTfI0wX7k/mSl0r7VvuWql1opZFvZb8dFV6ITrhWL62pGTrUquLGLFR6LMlpwttv11Y316yxK2NtESvqOJGni/heiHWtNYGBwasY0cRveICTuT5FD6U4m8L81N9cveMfkincR438bBNvFGY16Wv4vAxRH+dLfn48kZ4uN9/iU6YxUfpA9DA4yFy/8MfO2b75SIbwhAAAAAASUVORK5CYII=", 44, 15},
    ["HK417"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB7ElEQVR4nLXVv2+OURQH8M/zpqWt3yJBWEwSIWFAYhIqxCgxsUknEavJajXaicHgH5AIkSqCSJpIKh0YiK20Wu1b7THcK63H03rex+ubnDzPPffcc77n3nPuLSJCF7APb7vhqALXcBsfVzNqdSHQZhzEFvR3wV8Z2+sY9TR0fhrnMICLy/RP8FTaoLaU2GyO05917TxeWMZhDn15rpWlByPYU4dQERH3snGxit2bHHgNDmFnJrahTpCMWBZjNpOdz+TXZ92P7LOFr9iU/y/jecnfujw3g4UiIl7g8F9IfMtBW9n5v2ICvZjOsiMT/45t0mmszePPmex8RSJ9+IK5IiJGpR0Zx0YcKS0YkUppKicyhFsNyE9LJzqZiS5Kp1RVWm3ckU7+Qh3nRUQM49gK8w9xsqQ7gLM5yNUOEtmFTx3Yd4aIGI0lTEbE8YhQQwYiYjGvG4+ImxExGBF3oxp9Nf02kh6MSXUYuI5nNfdgv6XmncMjqaYnKmynpD5433zLV0fR8EFsSdfsUWkDTkiJ/MKk32+0eakP241Y1iTUBJekJOA+hkvzY6Vxr5X7sCtokshW3Mj/M7jiz6vxccW6Mw1i1UaT0urFeZySHrChCptBPCjp3mFvp8HqommP/A278TrLq/x9iQ//Ixj8BCDzFJ97l5j+AAAAAElFTkSuQmCC", 50, 14},
    ["HK51B"] = {"iVBORw0KGgoAAAANSUhEUgAAACUAAAAPCAYAAABjqQZTAAABnklEQVR4nLXVPWtVQRAG4CeXo6iJiaQRG21E/MCPmDIiIlb+AVFSCv4Af4adnZ2doIW1IkJEuxQmETQEbMQvojeKN6JG77GYBQ+ba/TknvvCsrM7Ozsv887ZM1SWpQyj2IF3uWMAeIWDWK1uFmnejj0ocQ+7MYmPfSTsYO0fZ1o4hNlepC7jehaw1AehOhjJNwrcxPkBJXyDYSHPML6K1hgTKowKRUaEWisYGyrLcganGyDwA9+x8z/Pd9P8XrRNC89woEAbTzBVk8RzPMUvHMVxUZF5HEtn2inpsvhwqvYsXqaYn9WLC3zGtD8SjuMkTuHwXwh9wVZczPbf4kLyL4vq1UYhyriKO5nvWoXUfSHLQlp3RMmvZjG38GIzRHJSbdFoncx3rmJfwQTuppgJUZEc6x69zaCFG6JBqziCE8n+hH34IGQ9KyrWtR6NkCr0fo+mK/ZtPMKutF7EtyaSb0QqRwuXKusHogIrgySSE8gxhb3J7uJhjfu29c1I70o9xhkh4X71/n9bGuDUk1SJmTQ2wpp4PBfSmMPrJkj9Bv08X2HuQWD8AAAAAElFTkSuQmCC", 37, 15},
    ["HOCKEY STICK"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAAApElEQVR4nNXSsQ1BURyF8R9RaRQSE2gsIDYwhcIMZrCCSggljS0sINEpqREJCa7iPaFARCIv96tO7m2+k//JhRAOOGGLq9fscX7zlwUXjNC7PxSwkhT5xBrH/3l9TRFNiXdd4jSAXAghQ6+faEvlJSuqYZPPzudnhlimuYQuxFgE+k+5hWqM04IKNh6HGMdaBOZopHkX67Rg+pRnMV+kjAUm6NwAvEgp7xTIxOwAAAAASUVORK5CYII=", 50, 9},
    ["HONEY BADGER"] = {"iVBORw0KGgoAAAANSUhEUgAAACcAAAAPCAYAAABnXNZuAAABeElEQVR4nK3Vv0tVYRgH8M89qJQOQi0tIQ4JbWKDgmEudwxxksaWwv+gIXJxCPoDdKi5KajdQacC3QKHgkCJphpEMPOCj8N5hcvpXm/nPX3h5f3xfZ7vec7zvD9EhAZtJiIeZ/q+H2RTaIYCNzJ9xwcZDGUKz+EB5tHGLXzBedIs0ME1tHCC4eTbSfw8PuI13vT6SCsi9vAIXytcGy9wvYffpH/LWKTgstCKiMA7/KpwU1jMFU74L8G18a0HP46baTyBVdyroX+MjRRkP/zGfo/1cxFxFhEjNU7ZXEQ8i4iDGIynTW6DQrnXzmpk4xNe4kOad/AQY9iq2B7V0P0LBT5n+k6nPvBHeWJPKzbDmiAiRjNSvtRVuudd64uVsq40LetJzf8Zwas0PsRmF/ejYns7M2eQ9UI8wZ00XsPPLu5QWeJLzGbGhbwX4q0y2wvYqXCn2MX9NF9Q3nNXXSX90WRP9GnrlX13N1cr9229CttYTv02vucKXQAZXiZ33EcJAwAAAABJRU5ErkJggg==", 39, 15},
    ["HUNTING KNIFE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAAA60lEQVR4nNXTvUpDQRDF8d/FWEVEMKQRtBPRFzAggpWFj+PrpBJsfQMbsdLCRgRBrAIqRK0s4tex2GuhhR94FfzDMDAsZ2dnz1RJNEgfW9hrUvQrtOpcYRZddDBd505dm/pEZwILmMMjeg30NsIBDvHwwbkuZqokPWWSiw1c/hvcY4Dbd/W2MrhLrFdJTjH/x801xRE2cFEleVas9V+4wT52sK1YWQvPGMNQWdIrXGNc8X1b8egZTnBX1zt4wjmCFaxhs9ZZwnKDDxjUusd1z29JMkyym2QyiR9GP8lqAzrfjpayMKPXL/qvvAC4rMwnD9xXDwAAAABJRU5ErkJggg==", 50, 8},
    ["ICE PICK"] = {"iVBORw0KGgoAAAANSUhEUgAAAB0AAAAPCAYAAAAYjcSfAAABcUlEQVR4nL3UMUjVURQG8N/TCkIhHBIiCXESMhqipoKmEEKHxkApp6aQdnc3hyDaoiEa2iKoJYQ2EYoIWmyMWpIHQlCafg3v/unPH8t6vvzgg3PPvfd899x7z2klcUAYwiU87TsoRbQxg9ahHgQ7gjPF3sYXfC52ExdwtlvRc7iGqziNZpxNfMAqlvEMOxjGdOsf3nQINzCHiZo/+KST4Y+ybkTnBipsYQ1v0L9Xpn2YxCymcbSceAUv8LJk862x7zDGcR4XcbnEeoJ5SXbjsSTzSdbyC6+T3E4y/Js9f2IryVyJ87E5OZrkbpKNsmAnyfMk75Pc7EKszsEkX5O0646lJJtFbCvJwyQTZX6gZnfLhSTbSaYkOZnkcS2zR0nG9inQ5PEk6+XJSHIryZ0iOtljsYpLSR5U46pkxnAf7/Cq/Mzve9XQX2IAb8tPbkOzTvvt3kn2g+s4hcXK0ey9vRaEK7hXd/zvhn9Cpwtt1J0/AQI+AwH0NOaQAAAAAElFTkSuQmCC", 29, 15},
    ["ICEMOURNE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAALCAYAAAA9St7UAAABPElEQVR4nM3Vyy5lURAG4O8chwShW4h4AiHmPegJiRfoMPIAhDD2Et7CxIgXMDBmYqSZGUnc4hrE7ZTBWh0n4tK2kzh/UlkrWVX/rqp/1V4iwietEhGzEXGUbbIAR92t7POoYhk7WEEZPQV46opKgZgqJtCFQUwj6plUEZQiCuXQigWcoF9S6C8OcIOreiX4v6igDb+xh2Opu224zz7NuM7rKH5iDGfYwh+MoEW6Zj/wgLvMdY6mvD9Eu6TqRU0eZ55VvcqxcJu/DY+vxBxiDbuliFjHrxrnpg+Kr2IOGznxQSy+8GnGJobe4dlHX+Y7Rbek5r9GnqMTJVyio6bQ9ry/z+fzpYj4iiKrmEGvBlDknaa9iYackSKYlubiBMMa4K9V5B0pY0m619uY0gDvSNFCxjEgzUpVmq1vxRNXRwR/GJ3ktgAAAABJRU5ErkJggg==", 50, 11},
    ["INTERVENTION"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABxUlEQVR4nL3VO2hUURDG8V/iGhUUiRiFFAqJYKMBA2qjIoKQxk7BLoWNjaCVpaVt+oCQWnsrK0ERGy1EUogYENRExCcmxnwW92yyLrvZzUP/MNzzmHvPfDNnuD1JrJMd+IyruLPej2wWtS589uE+lrCIl2U8h18Yw7HiO4AjGCzztzi6ifG2pRshWzHaMD+IbXiNeYxge/HbU8Z1vm1OmJ2pYahhvoiZJp/3OIQeXFdV4SzuNvicKO8+V4l5iF7MNpyzC7/xZRPjX6YnfzfJjCrjzUzgCnZ28c1F1dXrxdey1klIMNldyMv8xH5M4003VwtO6k4EVeX6yri/aW9LizUqIUMt1lejLuQ75qViJslwkt1JNNlIkqV0z6skh5NMJekvdr7sTTesNVvzuWuyekUWcLGN8gMly52YwDuMq8o93rC3gGGcwqc1Zr47SqYerKL2dPF5nGQwyZk2lbicpC/JbJLRJHuLDSS5kWQsyfGNZr5TRVbjWnlOqvpkDve0rmBN1cy3VY3da6XxH+HpBvPelrqQZ232z+GS6s89VYKDJ1oL+aG6Qv+dWjl4rs3+BXzETSsiqDJ7Cx9U/5lZvPh3YXbmD1gslWkEpeM2AAAAAElFTkSuQmCC", 50, 12},
    ["JASON"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAECAYAAADMHGwBAAAAkElEQVR4nM3QuwkCURCF4W9hYX3LJnZgA1ZgAyaWYCBWZmYiNiGCmYGpqZmCaCDXYK/huqCI/nCYYTgMcyYJIcAKQzS95oxjhecXHFIk6OGkOkg76p+4YppiiT4mio+XMcAIKTJ00Yh9/tVTy9lihk0SQhhjj92HSzNFsA5qaEU9Q9fjPH/Te8Ml1jXmWOAOD3rDGjgve6YhAAAAAElFTkSuQmCC", 50, 4},
    ["JKEY"] = {"iVBORw0KGgoAAAANSUhEUgAAACsAAAAPCAYAAAB9YDbgAAABjklEQVR4nM3WPWtUURAG4GfDTREUBMVCm0DAH6CFhfgTtIuNnYiWWlgKolhYaiWCoDZiIRaWfiHBwsJCUAvxo1BQQVTWgOJHzGtx7uJ1NzFuvLh5YWDO3HuGmTnvmTOSWEJO5nd8TDL+F/tal8riOIO1mOyzf8PFWj+B+3/w0So6SZrrddhc68ewbYn9u9DFWzxoO7gB9JV6Q5L5DI8j/4MGnSTbsaMR/wFMDJnzJ4Ue53GopToOoJNklcK7TS34u4Gzi3ybUeiybHSSTOEwnmCvdoJeCMELzDdsE/iACuO1bRarlZMaw1ec7gU7g0t4plRmxaLCHqWya/DUaCo7ZeF78kap9D3cWSmcfYX1eK309S7mcBBXlQuswhbcwnX8wD7L7wYPcXnIvT28xDkcVRKbVR6faVzBQJ/dOKI+ezzJqdrX/iR3kzxOsjvJzmafbWY3iheswjXlNOcUbvcQXKhlYDZ4j5u1Pq1waRJbG/+8w+1af+7fZ4MxPFJa1xd87wv286/V8FNXNyOaun4C7uyPkfZxtm4AAAAASUVORK5CYII=", 43, 15},
    ["JUDGE"] = {"iVBORw0KGgoAAAANSUhEUgAAABkAAAAPCAYAAAARZmTlAAABX0lEQVR4nK3Tv49NQRjG8c+5Nn4kiO00K0Ej0fgLRCUSShW9RDSiVMvWColKJxKJUGjo0GokCg13E2ILimWDyHLvozhzk7M3Z04s+ySTOXnf8873nXlmmiQGdAp3sI6v2Fvi3/CrfE/wEe/xs1N7CBfwqqlAzuIoLuNYgewf6mZIo0r8JU4XAOwaWOPHQO43nknSHSeSPEqyns3aSF0rA7nzSSx0qJdwE3t6OvqOA5Vuv5T5Kh534sEKNkFOVgCzgjVsFGBXu8v8FOO+4pkn+3CmAoBFTHG/AI90GtqJt6WJSoutFzcGznWcZDnJvfLvYpLbSZo5P6tjhCVc6+G/xhO8wHW8QYMdeF529FdqktzClZ7cuQK5iM/asz+OT9oHOtkK5J32jLtaw0Gt0XBY6994KzuYaaEHAA86AMpV/FfVXvzd/1l0Xk2SyRxsVXsZptsFGeGh1sQpPmB5OwHwBwIu/VPhwT22AAAAAElFTkSuQmCC", 25, 15},
    ["JURY"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABVklEQVR4nMXUPUtcQRQG4OeuSwJrUmxIE+wEMfgBQQiRNPkPYi2CIFiIBBKwshT8BenszE8IJF2KYCUmaVJoYWGi+I2aQlkZixnxclHiXZfNC4cZzrzn4505TBZC0AJkmMAxAo7S2pF8y4lXRz/GsYC1Juu9wjvsYhbHWQuE9GAKb/ELD3NnD/BMFCOd1dL+Iucvi8eopv0pzm8TUsPTZE+wgfUC5xGmMYIhVNDIFYCDFF8Wo1gtE1DFe3QmG05N1Qq8c7zGSs43hvkCr3grFfxGV4mevuILTkrEyEII29hH3z+43/FSvPUMPzGQO9/AJuYwg8/i+PzFYCFXSDX3cuueOPNHZQRcoYotnN2B+wKLWMLzgohJ8RUPU845UWjbkIUQPqUm3jSZ44co8r+iIr5I4x45PrSol3vharTq+OZ6XneT5Wd4HzvoFv/wXvzBx7Z3fQMuAd7aWIxR7/0uAAAAAElFTkSuQmCC", 50, 9},
    ["K14"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABRklEQVR4nL3Tv0vVYRQG8M8VLUshaBFxkEahXPwDmtqipaYaQl2E9hZxbO0/aGkIAkehrUH6ExqCaLApAuVqSWje+zTcU30NhfujeuDA+T7f933Pc877vJIYMR4kuTLiGXdG1TFuOMxhAfPYwBq26t91LGEcHbTRwldcQhcnmMRhcdfwDRlQx8Wqc9hKsoJ3+ISbuN9Y+LmEqiItXMZtPMFYH8UO8L2aaooPjuo8eDlkI21stZL0s7lbgqb5dYvtyoMpp5vq1PoPWC4uFWPnfL8dsInTSH+4W1681+BuJJlK8jDJ8wa/n+TqX3h7A8VZ1tjFceVvGtO64LfNHtckZ7GNL439R9gbabpD4M/H/gzviz/BCz1rbGIHi3iNp3r2+YlX+Fh5R6/J7j9TfRaSrCa5lWQmycQ5VzeTZD3JTpJH/9s2/cQPqeoUgESrhlcAAAAASUVORK5CYII=", 50, 8},
    ["K1A"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABsklEQVR4nLXWPWsUURTG8d+sk8T4BoqFYqcRRBAsFFELGxsb+1TGT2EnCFb5DvoBRKyCEWyCooLgCyioUVFIYVgFIwaCxngs7kgmk92NM7v+4TIzd849z7kz58wZEaHPcS4iHkbE/AB8dRoXImJ6I7tcczK8xOHSXNRY/w2bsFz4WsAQfmAEt/ERx7Fjw2Ai4gQe1wwCzmCm5pqmvMZlbMWh0vwyFjGSRcQ8HqGN7/jcw+EithXnOa4OOuIOvMcezEmx7SvdeyVlxakcz3ANUw1ExjBRw34SN7Db2nTZIqVTmVv4gmG0pBR+2s1xjreFUZONXMQHXCnN3S/Ef+Nkxf4OntTU+FkcZ3sZZRExKdXHpZoCZd7hQOFnM47hBZ5jf8lup1TUA6eFXVLRNGXcarDnpbR5g+24W7HN+tDpSY4lzZ/SaVyXApyyPj3bleu9+NpQqzcRkUfEcINGNRYR7UisRMSRLs2szMR/appa+GW1oOowhJvS27wn1USVmcr12QY6/0QWUbcPrmMUR6Ve1IlZHCzOP0l9oG/RKv38ovxlSfdNwLTUDx5In+YWVgagu4Y/cguKMaEeSIYAAAAASUVORK5CYII=", 50, 13},
    ["K2"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABu0lEQVR4nLXVu2vTURTA8U80IUUsig9oFVQUBEHi4CLo0j9AEdwcnFx0dXGwk7OLxUHd3QQVpCI4SNXBCoqVDp20U0F8YDDgi+Nwb+DXmKTJL/YLFw73PH73vPiJCCXP1oh4GxFLEXFyhDhrnbmI2LuWXdXwjGMGR3E4393CVXzssG3gJ36hluUqfqOZ7ypoYbmL/27swx586PeoKq5jI57iEb71sB3DEVzG6Q7dBG70+9AAPMZr1DGJFezEDqkg7zrsN+CgVBSViFjEoREfMQot/JC60ZQS2Y/3+b6BRambRdqJLGCsihd6J/LH6g5tyQEG5S5mpY4XqWFzlufyG4ocx/MsH8MrufI9iYjpWM33iJiJiBMRUeuyWJsi4kxEvCn4PIyIexEx3xHrfMkFHx/Wp4qvhbzu4JI0n71o5UofkHbmMy7kqm/Llaxn26W+VexNc1iHKl7ipjQC9wf0a+BKlk/hS461IiXaTqT+r+s6UaLtkxGxnEfnQRf9QmG0LpYcraHPMIvb5iy2Z3m6i36+IE+ViF+KMolcwy6cw6cu+icFearkN4amEhH/O+aE1JVn0uLflv4H68pfhbQeLlaOUcIAAAAASUVORK5CYII=", 50, 12},
    ["K7"] = {"iVBORw0KGgoAAAANSUhEUgAAACcAAAAPCAYAAABnXNZuAAABZElEQVR4nOXVPWsUURTG8d+uGxuDkHyHWASxUhBTLQiCvaCFhWJnl9ZWexsrUZJmGyvBT5BGQSs3GjsxIBaiSHyJEfWxmFmyC8nszrja5A8Dd87bPHPm3DuSaHjNJekn2UhypkH+g3ExHfU5jNs4ieOl7R5uYGsoro1F9PENX0v7DOZxbNyDWknqiruEXt2kfXiHt3i9h2+nleQJ1vAbb/Brj8Afio5BFxenJK6SVpKnOIePE+Ys4BmOThD7COcVL7dT2jo4Uq638cI+nZOkl2Sp5jCfSPIhu2wmWU/yOaMsjqlzqsrfVgzq/IRdG/Act4buuziL63hV2q7h5Zg6G1XONubws6a4WVwp11cVn20WD7FS2j9NUOdLlbODTbyvIayF+4pjZB2ris00YLtGrUo6WK6Zs4wL5fqmUWFTpckhfBffcRmPpytnlHaDnC3cwWnFSPwzmoj7bxw4cYOf9aG/LfQH6uc0rKhFHCkAAAAASUVORK5CYII=", 39, 15},
    ["KAC SSR"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABX0lEQVR4nMXVP68NURQF8N9lcl1XFCSeAkGiUJFbCInyVUQl0WgUGpWI6DSiUCpE4QuoJBo+ASJPpRCUHiHxUEiukFctxZyXN5m4cifjz0p2Vs6eM/usteecOYMkemAjhriJw3iNVQywXOaMcBLv0GuxGRhiMuhpZAOu4jqm2IrvGPeW1xFV4RE2lxg1eIxNLb6vFl3hNhZLjUHhz9jbQ9MTXOowf4iRJB+S3EnyJvNhWxJJTrfyq4Wnc9aZha9JqrLG3FHhFS5gu3qv7y5d/YIjOIDnjQ7cwgImjdwL3MUDnMJOHFN/xa5YLlo+dXorydMkR3/hcpjk5YxnFxsdnCY5k2SS5FCSLV27+SeiwgrO41nL42U8bOXH2I/jjdxj3OvUvb+ANSNn8Uh9cHZhD87hrVr4vhI78KNVY+nfSP09KrxX/4Wu4KP183FNbXJtvKLet99wAjdw0Pp98V/xE8OTiZ82/I/mAAAAAElFTkSuQmCC", 50, 9},
    ["KARAMBIT R"] = {"iVBORw0KGgoAAAANSUhEUgAAACUAAAAPCAYAAABjqQZTAAABm0lEQVR4nMWVP0hVYRiHn3sUlKAWwcElKajNP6uDoA5hEJGDoEtDTjWH4JIGiiDo4lLSbhQUrhEo6hIIuhQiDhVFg5qCXBRvPg73XDx86L3nojd/8HI43/vy/Z73nO89J6NyQVUDc8BbYAvYBfbi6y6wX/aOatqoU7vV2sRagzpnca2qw2pLWq80RY3qe/VfbLKtflKX1MMSQKG+qg8vAnVNfalmyzROo89qc7lQveqPCsAklTPfdEmoJnW+wjChRkOo6sSZfwK8AqpKzMYRMAjMAvXAFNAR1GSB5Xj6CsoATcCdoHYIyAEvwul77OlBPk+b6gf1WdDZDXVH/auOq51qTdh9Im6qA+aHJ5fY/7mJ1/coSJ6l12pVEaM+9XaR/HnRqi7GHgfqrQLURLz4RX2jfo/vc+pHdSp+GuUapo2M2q/+Ud8loSbjZOFTsKD2VBDkrLir/lbbIiACRoDC/yYLjAE/Sxz4y9Y60AU8iIBm4DAoOCYP+7/1DZiOgDXgaSIRAfeBlSuAAviVUQHuAe3AAXAdmAE2rgiKE+MJmz/k8x3oAAAAAElFTkSuQmCC", 37, 15},
    ["KEY"] = {"iVBORw0KGgoAAAANSUhEUgAAACMAAAAPCAYAAABut3YUAAABOklEQVR4nLXVsUscQRTH8c+dSSHYWIjE2KQT0loJgjZaSgqbWFvapoh1ipSmVStRxDZdCnN/gI2IFukSSJkmREUl/CzuJJvF25DT+cJj2beP4bsz82YkUYnxJO+TfElyk+RnksMkr2t1RaKeeJf+PC8t0/Y38/oz1/DtUajKjGC6oXaurMofmUls4GlD7QKWsYShEjKtJLP4iHOMYnjAsa5w8QCXsVaSk57MW0zgCM8eMOigLEryO8nLyq7ebeiokly0cYaVnt2E5o5qIuj0nnV+4Pie3B03WHmsPXOFVezo/tg0FrGHFvbxDes4xQzeYA1TOMCnu6WZTLL9j2n8mmQ5yVKSdgqfwCNJrhtkNksIVKN66P3S7aR+dAZYvv+ifh18bqjtFPQAT2rvH3q5V3iBS93Z2sL30jK3a+J1LqWZOigAAAAASUVORK5CYII=", 35, 15},
    ["KEYBOARD"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAACCAYAAAAaRY8cAAAAc0lEQVR4nNXNvQkCURBF4e/5u6CY2YGBgYmVCNudbdiAmVYgKFiBoZGw8sZkxG3Bmxxmzgy3RMQeLV6Y4YkFOjS44YId7ljhijXOmGPjlwEqIlkxSfdGyd04O6fJUd58/bA3d+lrjwds8/9YIuKBpf/O6QOxmx5W4Igb8QAAAABJRU5ErkJggg==", 50, 2},
    ["KNIFE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABJ0lEQVR4nO3VzysEcRjH8ddolxQ5UyhnNzcnB+XgwMnRH+Dg4O6fkFKbk1KOclG4uSnFwYk9+JmIUNTu2sZhvrStlW0b+ZH35fuZ+X6fzzPP88w0URzHUmAV42kYNUrTdyZPk/9CfhoZDFdcnyKP5zpiW9EZdBs2q/ZLmMYM5jGFHCaxggmsYxA7GMAB+nCCrvBspeD3iGLQTygE/YCLKH7/tR+jF7fIoj0Y9+AsJCjiGt2fFFtASzjfHNaspFEZlBEhDqsKHYczi9gI93LoqMpxj6Fahfw09nAY9JikIa+cYxT7v6GQWpSxgFnckYxut2Izj231vVo36A+xIyHmKyngCMtYkkzjjSilgaxhLg2jKsq4wqWkcR+SSSlhjK2UvBriz/xHXgBHZVKFWT6XkAAAAABJRU5ErkJggg==", 50, 12},
    ["KOMMANDO"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAGCAYAAACB1M0KAAAAyElEQVR4nM3SoUrDcRTF8c8fQYfBooIWo8knEIt7BDGKD+Ab2IxiExb2DJZteUkMJtNwTKNJ1GKVzWOYYQxRwR/ML9x07j2cC6dKMo8T7GADq1g0W55wgSZusYV9vOFlYu7xCJIc539zmeQwydUXWj9JLQlJBhNCI8nwG9PzYvHKcZpEleQVS3+owRAPWDObSo6wXSUJ3tFGB3d4/uF4wbizuzjCwPiRHlY+d25QRxdzhcNP06+StHCG6wKGm1jGOg6wV8DzV3wAbRawFwKF/QUAAAAASUVORK5CYII=", 50, 6},
    ["KRAMPUS KUKRI"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABPElEQVR4nM3VP0vWURjG8c8vREltEBUdc+gPSrs0t9jeuxCcdQ4C6QU0BEWja6EujkLQoi0NgjjolJhZYEV6OZwf+iQq+vgkzxcOnPvc933g4pzrnCrJLDpxW+EvBuv5Twwh+FPn9tCN/TqGH3iKbXzD77ruAN9xWO/V61+60VXXrWEVK9hxRaokuWrTDfAZ8/iAj4rQC2lXIY1s4h3eKqd2Jv9TyBfcQ0cL91zEcyyfTlRJXuJOw9oh+hviPif+6MSWcrc7sKv4B8bxos5T7vuoIuYrHuAJxlDh7jUELWEan45XkrRqzCYZvmTtQJKpJAtJfqU5DpK8TtKfpKVCJpL0NtHXk2QmyXqTgtaTPKrSPl6/hceYxLM63nfyLZzHBt60k5BGhvBQ8d8r5V8aUbw1h/vKa/ZeeQB2jwCwkpt9G7GegwAAAABJRU5ErkJggg==", 50, 9},
    ["KRINKOV"] = {"iVBORw0KGgoAAAANSUhEUgAAACkAAAAPCAYAAAB5lebdAAAByklEQVR4nLWWPWtUQRSGn2v8CEhABCPZQIzgB1go2ESQmH9gQBTESlIKlrHQVjvFSm0EFYSQJqRJoSiW2RSColHwq4im2WAkMeCCmMfijngdrsnubPaFF2Y4c85558xhZjKVNqACTAPDwDKwBRgCvgE1oLvE5xdwCrgJPP/HoqZwUF12Y7EaYp6I82XqALDQYIUyoB94BHQ0Xd+/+BR4CHgD7AH2AlNAF/A5VHYO+Jmpc+RHsB66gH3AphbESb7RMqwCD4HjQE8QWQMWNwNPgJF1gleA88AosKPE/gP4HkTsjmwvgCqwRN6XfcBj4D1QB1YC68BE+dZ0Ru2M+mC/OqLeVz+oH8P4knpMvVDopWl1SM3U02o96rWxuMeaJeo99bB6UR1X59VX6i31rFopcdwaGl31rtqt9qoDwWemIPLtRohcUqvqdfWkurMBxyNBwIK6LbJ1qJejah5sVeSuBMcrIfmD/9iPRiKvtSoyhdWQ/Mwaa14XRK6o/akiU6+TWeALML/GmhuF8XbgTmKu5Eo2wkx9Fh37uZRYmbbl7f6DA8BLoDPMa+SvzNdmgrTyejSCd8DVwvwp+YXfFNpdSch/QFPAbWAyJcBvZZriwvQUZB0AAAAASUVORK5CYII=", 41, 15},
    ["KRISS VECTOR"] = {"iVBORw0KGgoAAAANSUhEUgAAAB0AAAAPCAYAAAAYjcSfAAABjElEQVR4nLXUPWvUQRAG8N8lRxA0iJ3GwhQWihZKECzEIo1gZ2NAAsbC0tLCxtIv4AcwYGWtohZisJDYWHgIEcQqimAgiETFt8cicxCP+1/iER9YdnZ23p7ZYSUxxNqb5OI/+sx15bbhcAi7MYEWftU+gt8lt0pW+pOYh1aSfkHnKnAvTpR+Yshid2GtlWQK3/CqLk7hKdbwo8fpIxZwupKv4BGWMV1FqXhfsRNjG/z34YMky0ne5W+sJNkz4H0uld1CkpnSXc3muJ/kXhuv8RO3MYNJXMfqgDZ1Gb2pDk0V0168xCK+YBQ3ukwfJJmvam8l6SQZ3WQSl6ry2Q26F32Y9e1Wd3rHcRmzOGt9GpswhoMld2o/h2M9dsuN3UrypN4wSe5uwlCSsSQ3y286yfkkn/uwfNgUo43D9S6PcWcAwy6+48qG8wQuYEedr+E4njVGSHIgyeQWGG51vS2mZ5psmj6HYTGOT9Z/o/14389oZDsz4kglXG1K+D+SHq29M8hou5OuYQnPBxn9AaaqFSn0yNjQAAAAAElFTkSuQmCC", 29, 15},
    ["KS-23M"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABQ0lEQVR4nMXUv0pcURAG8J/Loqws6gbEBLvF2FhYausjxMLSN7CR+AopFHyE9CmChW2alBbWgq2IWURFWFf8A5PinCWrqNG7F/eD4c4M937nm5kzdygilIgxLOEjmpjI+UY2GMYVjnLcwR9cvOGcCsbxAVOYrfaj+hGWsSUV8O6olMSziZ9SEbclcb6ENk7xS5pKs4p1bPdBuoqN7N9krgbm8RvnWMPX7I/kw2ewiDlMP8N9hLsn8oF71KQreSEidiOiHhEKWD0iDuMfvuX8UEQsRESzx57jGM1WK6hBRKjiUlqctnTVJrNNSUvbjT/l5ziquSvwuadTP3o6tve/UWZ0Xvnei+gu+w6us3+GE+kOnkrj3c9+y8O/Sx0rmM3xQRmiiqBbyBccF/i+je/lySmOilTM/aCF9IuKtAutQQvpF38BaOXOEPWpp44AAAAASUVORK5CYII=", 50, 10},
    ["KSG 12"] = {"iVBORw0KGgoAAAANSUhEUgAAAC0AAAAPCAYAAABwfkanAAABoUlEQVR4nNXVPWsVQRTG8d/q9SViIJGYVKKFWkXRJliphSCkMSD4AUxl4wdI5WdIF8HaFH6AVEFQFKKgTbAQVEQMGhsTjYjJPSlmr2xWs/e6iwb/MOyeeXl4mDlzRkT4R206IrKGGjMRoeXvk+EwTuIq5rGO/fiGvWhjI+9by7/r+fo9+bw+XMBYFhEzWEV/DUMbWOnB9HU8xlLFvCMY7qJ1CNNZRARe4kSPRnecXTttoAZL/6PpZ1lEtPECiziOU2jhB55gGR9wBmMlgc/SJaoiw4CU+58q5hzV/eQnsdBC4Auu4QpuSBdnNW9F7mAIj0r94zhf6ruHp/n/MWkTblYYuihVik5lWcM+aVPaUpWZw5aSN4CDeIj32whPbtO/XDL9Fbek05OPvakwDPe7jP+keBzncBq3e11c4FIpfi2l2aB0Mrvxtobub+mkRx8mpLz7+Ica/VJadXhXiAfz74P6Fn+lhSl8l/JotobGBA4U4rt41dhZBVl6Wxoxh8uF+CyeNxWtoqnpIelp7lzoRYw2NdWNpo/LiK0VaL6hXk9sAkCW3l2tgZsfAAAAAElFTkSuQmCC", 45, 15},
    ["L115A3"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABLUlEQVR4nL3UMUvVYRQG8J95wRTvoLg0ag7aEikEgSCBQ4ObENEH8RM4ioOtTS41NYhbhBAhiIMShOB2E1xdjBrMx+G+w58/lvd6Lz5wOIfDeQ7PezjnlcQdrZnkdQ/8qvXcp+FueIlXmMSTSj7FD5f4BBc17gweYKCSe17hdorBouMQPxpYwBSWa4Vn2LyhQRPvC6df+In5LjmDeKM9lMmBJC2MY7SPwrrFVyz20uC21brCKj7jKbZK/q322rzAuxrnAp/wDXv43YGOPx3q/TeStJL8ys34m+RhOaixJFdJ9pLMJplLspRku8Y56tMH0PWxD2GkvGsNG5jGBzzGfpn+M+0D3cFxZRYT+IIWTou/dzSwjt0SX+IcB9qrtIJHRWyz1Hyv9fh4X2L/h2vr/2Uq5peL5QAAAABJRU5ErkJggg==", 50, 8},
    ["L22"] = {"iVBORw0KGgoAAAANSUhEUgAAABoAAAAPCAYAAAD6Ud/mAAABoklEQVR4nK3UPWsVURAG4OeaFeKNIlgkIiqiIIJio4IEUws2/oNU1nbW2oqtjZb6Byy1ECxUUGPAkAQbDaKEqIUYQgzmmrE458bjsne9hS8sOztf75nZmdOJCEPgFr5jER8K/eua30+cw5t6gmoYFhzBTcxiK+smG/zeY2dTgmGJ1rGEvRjDJvbXfMZwDKODiF5gFYcaTrOJjziP6UL/A1Ho9uVDVLiIp3WiTkSsYGKoutqxji7m8CXrdqOH1Urq6/8g6ub3Z6nNfVzHSoUDDUE9jKCTv7/iPpazPIUrhf9bPMRdHMaNnPda9icitiJiNiIuR8TJiBiPCBGxFn/wMuv6z0hEvCvsjyJiOtsORsTViHhQxlTYMaAVSziV5fpe/MrVHcUMLuGENFDfMJ6fbQwigeeFvFyzdXE2y/OZeEGa0DVpxP8a8zaijULeU7NNFonmG2J7mXwbbQv7qZCP12ynC3mhIfY27pWKtopeFfIFaQr7eIY70mpMDTjkYqnotFyqo9KP7bfojHTX1bFLuila0da6DTyWKnkiLWIT/kkCvwE+t6q0jK8+kgAAAABJRU5ErkJggg==", 26, 15},
    ["L2A3"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAACEUlEQVR4nL3Vy4uOYRgG8N8wExrGoWbMQs7KYUSysFI2dooFyh9hhSwtUchKlsp/oCSHkrKgEEkhp0+Z5DDjOA7DZfE+X76mj8Z8M666e59T131d73M/zyOJFqMtydUkp0eMz01yahz4/xYzk6xJoi2JFnASm7AMX3CmYa4H83BzlFxDeIr3mIR+TC48w3iB2ejCOwxgK5ZibytGZuBeETteCL6qDHwtY1PxHT/QVvpf8LNogKH2FpJ+LAlbwbsiqBMduFa+HXhY+JeVXE+wE29wA29LfxKej2ZHpmEh5pdYUL5dWI1FJdFrPMe30v+OT9hehDbDC/SV9pDqjw+rdqajjH8rhiajt6wbLHM/MB2D7ejGHKwsAuui64K78QE1VQ3X8Aob8RK7ca6QNkMf1jf0a6qzdBePVLXeDMMN7Tr3kybrBqAtyXVMKU5rDfEUz0q7nqwHe7AOR3H2DyLqWI47qr/7CpdwHcfK/JJipmW0Y1YhPvGXdXOxF2twBPtGyX9cZWIY+/FZVTbdqtJ8ORbRTZGkP8n0P9zTvUmOJjmfZPM/3vHb8huHy1hXksVJliTpHM83RZJakhkjJnqSHExyIcmWMRBPS/K4mOgvBibyYSTJgyR9IwycH6OBehxo2I1dE20i5WW/rTofq1Sv5CFcbrFib2Et7mOF6lxMKNpxETtwAFfGiXeD6lqe6T+YgF+o8Nsuh04prAAAAABJRU5ErkJggg==", 50, 13},
    ["L85A2"] = {"iVBORw0KGgoAAAANSUhEUgAAACMAAAAPCAYAAABut3YUAAABsUlEQVR4nLXVz2oUQRAG8N/GFcSs/xAkKgqC8RLIUVDQgyA+gB715oP4AD6AePAkePDgyYMXQVEUxESQqDlIFGIEY6KgISom5aFbth1md8e4ftBQU/XVzFc13dWtiNAAl7GEWbzNvsBUk2Tcx3Vc7UdqN3zZIdzANNaz73jDXPiA1iBSUzEreIMd2IZVjPXgjmFrxXcAm5uIeSKp7tQk/MA8juFC4V/CGs7m5z3YiUmpc58L7jr2YVPhn83f/QOtiHivd5UbwU98x6i0r75ge4Uzh9fZ7uScZRHxMIaDhYiYioj1BtxLEaG62thbU90qtuhuuo+4gsW8TuFiwZ/BTVzDURwe0L07td6IWIuIxxFxJiKOREQnK10uKnlaqaIdEfNF/FZEnM+xg3VVN1ltaWPVYQ67sv2oEkv/mP24i3MYl0bA4oCu9MRIn9izwl6oxHZjItvPpZP1Sirg6/8Q862wO5XYiSJ3ZqMf/xsx7wp7vBKbLOyXwxLTbwKXQ+mkdLJ+X2S3pdlxOsceDENMK3pflKP4pDuVJ/Cihjeie1/9E/p1ZkU6KWu4l4XVYShC4BfK10i/1Nww+gAAAABJRU5ErkJggg==", 35, 15},
    ["L86 LSW"] = {"iVBORw0KGgoAAAANSUhEUgAAACkAAAAPCAYAAAB5lebdAAAB4ElEQVR4nLWWT0uUURTGf+84SeEfJLCVjeRCxKhFkZE710IfJPoWbdvoRltFLgShj9CiCKJFCYPJIBEOJTSDpDGjoCbzuDjnpet1ZnqdZh64vOee89x7n/vnvPcmksiABaAClIAf7hOwnqUx8BooAs8y8s8hn5FXAF76QOmsZi8xThU4uQT/HLKKrAM14BZw1QcsAB8iXgKMNGk/BvzqTCIkkj5hqzMI9EfxP9j2PgIGAv8e0ADeeNtR9z8EhlqM9dH76UhkFbjRSeMIv/070iJeB3Yz9nUKXMfy4Gse+EZ3RB4Dh8AwkGsRf+W2nBue035sN1M89u+TRFIZGI86PMC2N/F6FVjGVuInMAc8DfiHWOauYAn1oInIbeBFs9n9E5IaktYlrUk6lrQkCUk1/cVn96UlJ2kriBclzXtsLOL+d8kDE0DZNX8HVt0uA3fcfh/NreErOglsAPeBKSzj9ztarTbIBQJTpMKKga8Sca5hmQwm8hT4gk2y3l2JFw/4AXDT7aPAPxjxZrD/JS6up4hF7mCpn9opJiPe3cDe7LaoC4gO6W1JBbfng8SoSEoC3j1Ji5JKkp53O1HikrR5YAxjN0uf16exB0aMK9jN1DO0u7trwFvsbL6jddb2VCDAGb65Zt3fD7LLAAAAAElFTkSuQmCC", 41, 15},
    ["LINKED SWORD"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABBUlEQVR4nM3WsS4EURTG8d+wsaJQiWJblcILKPQKUYhOxAso1N5DqdyICm+gJpFtFDo0WgpkE65iZ+IKiXHvyM4/mcw9mZzJd843594pQggyWcI+dvCa+7JUOpn5qzjAijEWQV4hyzjBLu4bUZNBkfhpTeEaPczhuUlRKVSO9Mr1Xc28dSzgFot4wxPe8Rjdf2MWk1HcxUwUV+uqUS94wLfuFyGEU6yVD/u4KoVAUV5x3MUe5msI/Q+GuMEAlzjHoAgNbFst4LCDM5+OHOHCz05U8bSWOsLfZ2QTx0YzsqElM1JT+xdat2tNJOYNsW3Uza3m5KST6khFfLKP9VDMLYSW/Gt9AABUWPTDV0pUAAAAAElFTkSuQmCC", 50, 13},
    ["LONGSWORD"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAAArUlEQVR4nM3TvQlCMRhG4UfxfwUbC7G0EZzAUmysHMMR3MBZxEpcQERwAAuHEMFCYuFtLXJjxFMlgRfOy5evEkIQyQALrGKDOamWyCyx/bZIKrFFOhjjlMElidgifVwzeCRTCSFs0MC5eGujVZxvqKNZ3LuY4P5Dx088ccQeuzI78i9Uvb96G50aZhHhIR6YZxBLInYiF/QyeCQTW+SOA0YZXJIosyNrTL/skcwL7OoXItfN2nkAAAAASUVORK5CYII=", 50, 10},
    ["M107"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABgklEQVR4nM3VvWpWQRDG8d+Jx6BvjFgEBBWEgKA2WgSEaJXCQiwEvQHb9OI9eA+KaCuIWCmCH42kSplglcKPYCUIxmiSSTGrvp4Ino0R8sBwdjmzs/vfmd1tIkKF9uIAvmMF67iOq7hcfEYwiYP4gsWaCbarphLkCh6W9nsJ0+AQPmAURzBWfF5jegfW+Ve1lf4fcV9m5BNO4LHM1CTG8RWnsQ9vcBRRjAQ31F8vcf9JTUTcwLUywYY/w63K3Z/G/or4UcaRgO/8DgWn1GdtgHNYkGseNBGxhOOVgfpqwy+QFVmOXZCzeIVvFXEncBg3ZeZPtniOS3gpa5wkftAZPIszPSaZwx1cwBLeDv2bkuUYeIHl0r4toftqgD34XPqtiLgbEXMRMRIRis0MtX/YsUg9i4hbEbEYW/U0IiaKfxsRTSdGt79j1sq6ncL5n3RJ29VM+T7CE3nYL2J+yBawVvzWbFXVFVmjvtfvuHwPluXBXP1fC9qu+l6/Y7gn34VdBwGbHFf3mJfeNPwAAAAASUVORK5CYII=", 50, 10},
    ["M16A3"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABuUlEQVR4nL3VPWvUQRDH8c8lp8aIIj5gYRuM2KQWCx+IL0GwshYrC9+CvVikESwtFOxiQBDURgsLC/EhwcaARgwY0JBo9H4W/w35cyZ3l+PIFwaW3ZnZ2ZnZ3UYSfXAe0/iGWXwt40Us4Dve4n0/ztu4ijHc6KiVpB+ZTsW7LdabSab69F2XiSQnktzuptvE5DYzdLxkaBEnVdlvL+swPuMFjqCBUbSKrJS5EQwVWS62Q9iNV5jHS6x2C6qRPntrh/iBJRxUte5mjGKh2YfzqLLZjS/4aaMiu1TZ/q2qChvZb2Gt5nsXXuMWHuIBLheddvZiZTsVWcIbfMApnO6iP4E5HC4BDuMPmvhbAm6U8frcULFtlf2W9Uo6s5TkbpKLSYZrl2uypnM9ybEkT9ps9w/gsvcsTf+3yorqab2HGZtftLM13XnsUz3BdXppv8GRpJVkLclMkitJDnQ5/ViS1ZL1m1tUKUkO7WRFJLmW5Og2jB6VQGeT7KnNj7cd5MxOHmQIU7Z+2toZwSd8xB38qq3Nqf6WdS4MomN6pZHBfiP3camMn+HcIJ13op9/pBOPMY7neDpg3x35B+Ddzaaa0l23AAAAAElFTkSuQmCC", 50, 13},
    ["M16A4"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABuUlEQVR4nL3VPWvUQRDH8c8lp8aIIj5gYRuM2KQWCx+IL0GwshYrC9+CvVikESwtFOxiQBDURgsLC/EhwcaARgwY0JBo9H4W/w35cyZ3l+PIFwaW3ZnZ2ZnZ3UYSfXAe0/iGWXwt40Us4Dve4n0/ztu4ijHc6KiVpB+ZTsW7LdabSab69F2XiSQnktzuptvE5DYzdLxkaBEnVdlvL+swPuMFjqCBUbSKrJS5EQwVWS62Q9iNV5jHS6x2C6qRPntrh/iBJRxUte5mjGKh2YfzqLLZjS/4aaMiu1TZ/q2qChvZb2Gt5nsXXuMWHuIBLheddvZiZTsVWcIbfMApnO6iP4E5HC4BDuMPmvhbAm6U8frcULFtlf2W9Uo6s5TkbpKLSYZrl2uypnM9ybEkT9ps9w/gsvcsTf+3yorqab2HGZtftLM13XnsUz3BdXppv8GRpJVkLclMkitJDnQ5/ViS1ZL1m1tUKUkO7WRFJLmW5Og2jB6VQGeT7KnNj7cd5MxOHmQIU7Z+2toZwSd8xB38qq3Nqf6WdS4MomN6pZHBfiP3camMn+HcIJ13op9/pBOPMY7neDpg3x35B+Ddzaaa0l23AAAAAElFTkSuQmCC", 50, 13},
    ["M1911"] = {"iVBORw0KGgoAAAANSUhEUgAAABgAAAAPCAYAAAD+pA/bAAABFUlEQVR4nK3STytFURQF8N/1XkLGDEgMmCgTKUbmRkoGJvIVDOSTeRmJkVK+gCgihREG8u9tA/fqeO7znq5Vu3M6+5y19t5nZREhwRZW8Og73lrO+tDvd4zhOmsRuMRoh4d/QhYRM7jBE+7/kxwndWxiBM//TA4vdZxjCEsdLu/hDAtoYht3Sb7p5wSeREQRixHxGuW4i4je/N5ARKwl736NnkTtACdtqu9BLdlfdOj2C6mLJnCaE6S4QgNHOXH4HFfoAvVkv15C/oBZ3HZbcSsKwho2SvK7VchTgWWMl+R3qpBD8dv7Jc55j4jhbt3SLkTEdEQ0SwQOq5IXNl1FVtJco/J4fNp0EPOYwySm8nUJx1UFPgAHuCAfqpubJQAAAABJRU5ErkJggg==", 24, 15},
    ["M231"] = {"iVBORw0KGgoAAAANSUhEUgAAACoAAAAPCAYAAACSol3eAAABjUlEQVR4nLXVv2pUQRTH8c8mKyYiSazSKWKvdRoFS58hhY8gVjbaqZXgAwgWNtaCCIKinZ2ondhEEP+hMcSYGJMci5nFm+GyO272fmG458w9M3Pu+c3c6UWECk7hNb7hCz7ha35+btgv8b1mwv+lXxl3EUdyW8ablphFXMOlSSRW0ouIRWwPiVnAE5zM/i2pgiUzOIOnONvoX23YO1jHHkJSaAa38WtUolXaV7KJ2THG3cRaS/825rBVK30t02OOm8dUS/8WjmK3j8OGS7+Me5UL3sc7+6XfzAsOWJe2wJ5UxcB1/Bw6c0SMaici4kbs531EbBR9GxExVTHfWK2t3CUruIM/2X+I4zhdxO3k6nRC7R5dwqFsr2b/GH5LW4eUaN+/D5osFWWfjYiVLO+H7A/ePWhIv9aV7LXSX5akhqvS4RjwsWHPSf/cThiV6AKuZPsV7hbv3xb+0gRyamXUHv2B87ggVa88LM8L/xweTSSzgt4BL6Zp6Rqcz/4LHVX1oDfTLh5LiT6T7vlO+AvryV2hWKLF3QAAAABJRU5ErkJggg==", 42, 15},
    ["M3A1"] = {"iVBORw0KGgoAAAANSUhEUgAAAB4AAAAPCAYAAADzun+cAAAA6UlEQVR4nO3TPUpDQRSG4SfhWlhFdAduwdYd2Cu4Dgs3ki2YDfgHinZpBQshpdgEIWAM/iHeazERNcydO4p2eathzuF7mTkzraqqZNDGNgYoI/UOtvCIBTzjCvu4jQW2MsXLGOU0znCJo1ihwPp0/ZQI6PxCWqGP0zrxGk6wmAgZ4wAbmdJSuKVxXUOBB2EeTQy+iHu4wabPmV+gizO84j4VVog/lhgfIxniEOfYFa50lrJm/5s4hyVhJLCDvUTwHSZNgQWuM8QrwglfcJyQmva8NQXmfqefMBT+82qqqf3X1lzm4rn433gHBZ040gudpfUAAAAASUVORK5CYII=", 30, 15},
    ["M4"] = {"iVBORw0KGgoAAAANSUhEUgAAADAAAAAPCAYAAACiLkz/AAACCklEQVR4nLXWS0vUURgG8J8XwiyLgkJbBEUEUYsoaFO71mVkmwpsF/QB+gbRjWgZRLXpA3RZ1MIwEoqgVhFZEAoRxVRmYhdHcHxbnCOMgzp/HeaBw7m9572c9zmXlojQAK7iLEr4kUsJ33P7Wy4vMbMMvb3oR189wfbl+TsPnTiN9RjFMcwuINePLjwuqHcnxrCxiHA7tuf2V5QLGoGjWI1pbMPFReR24xGOYEcdnXcxhUG8LuJES0SM4Rcq+LOAzBgma8Z6sBdrixiR6FPGJ3RgHf5le51Shn6jO9sqYQNu5HYrNmddZSnTXai0RPFDEHgjBdqDLQXXza0tS7vbmp0u58DapExO5foV3uOUlImPec2amgACP9txC+M4ia1VRidwEy8kek1gpGr+OQ4WcL6CKziEXbk/jpbs2IyUjTZcwz0MSxS6LzFgcUTEZESMR8RMzMdIRFii9EbE26iPB3X0NFRaJS4N5+g/YA+OY1+dnX2IJ1X9M3lXL9XI/a2jpyG04zCeSvS5LFHlXcH1+3Ndwarc76iRaeihqYsG0tdXRZPrVeObaih0u5kUWunCjogYzQ6WIqK7aq41IqarAhho9hlYCc5JjxdckO7qOcxKV98cDkg3TFOw0q/EHXyRrsbBBeafSS8w6auxT8GXddloUmpP1JyD882iUCOfuaUwhM+5HsJAk+z4D05vz1lTmv18AAAAAElFTkSuQmCC", 48, 15},
    ["M41A"] = {"iVBORw0KGgoAAAANSUhEUgAAACUAAAAPCAYAAABjqQZTAAAB70lEQVR4nKXVTYuOYRQH8N8zHmbGWzMpk91ERnnZUErS2CArxUpSfAAfQPEFJFnYSElqrFirKUpYKFGzoIyMt0zyksjMYPS3eO5pbk8zj/sx/zp13edc53/Ofa5znauWREUsxi3sKunu4kKx7pnHbwpXqwaBeht7TxQJXcSXkn5rC58OHMN33KgcKUkVWZfkS5K7FffPSC3JzSRjSbqq+knSO48MJfmU5F2S6TSwO8m+JH3/IN6Q5GeSb5nFqapJ1ZKM4F5xlCvxGTUcwJpyUTGGFZjEdIsD6G7yVRzhUAufTnThbB1XMDLHpk1NxDWsbUHajGm8xCq8wmocLtaLMYp+vC14r2Mp3tSSDOLOHKR92IY92I9zhb4Hp7G8jQRnMIEf89g+YhyvJRn8xxl3Jxlo0j0u+uRnkvNJtiR5noXjc5LRKiNhEs9K3xuxuVi/xzV80Cj9QtGLo3WtG3YunNW4FF+xXaPk8NRsD04U9vcF/wuzPboEy+bg/Y0zeFDH/TYSWq/RXzSm9HjJViutT+AyTmIAx0u2HUWCM9VfVCQ0gYeoPDxnpDPJoyRTacyysu12qTe6kvQnmUyyt80YbT0zNG7OThzy91PTjIM4gtsYbjNG25VqJcNNN+lXko3/w9XR9l/Mj+b5cwlP/ofoD7wmpH/PtLzMAAAAAElFTkSuQmCC", 37, 15},
    ["M45A1"] = {"iVBORw0KGgoAAAANSUhEUgAAABMAAAAPCAYAAAAGRPQsAAABAklEQVR4nKXTvUpDQRCG4Sfx+APaWQg2opJGsBOxslWwsBPsvAQrL8EL8CZsBUkpFhZWNilEEQQLwR8QRDBKwLFIAsf1hJjjB1Ps7My73wxsJSJ0tI9tXOIcLXzivXM/gnHFWsBUJQdrYLFH8Z+UYQ0vqP0HhOcME9jF2IDNLRzlzo8ZTrCM9R5Nq3jAFg61d9jEKJ5+VEZEN67it74iYjIiKhGxkqstjKzDnMZc4ugMdSzhFRf95u7CdjCcyzexgbd+gHTMoYi4TcY77jdSUVSxidnkjfpAjnLOTgsWP1PWWTXhN3BXxlgVe0nuowyoC5tPcvdlYRlucKD9N2u4Lgv7Bshx4GsGwxQKAAAAAElFTkSuQmCC", 19, 15},
    ["M4A1"] = {"iVBORw0KGgoAAAANSUhEUgAAADAAAAAPCAYAAACiLkz/AAACCklEQVR4nLXWS0vUURgG8J8XwiyLgkJbBEUEUYsoaFO71mVkmwpsF/QB+gbRjWgZRLXpA3RZ1MIwEoqgVhFZEAoRxVRmYhdHcHxbnCOMgzp/HeaBw7m9572c9zmXlojQAK7iLEr4kUsJ33P7Wy4vMbMMvb3oR189wfbl+TsPnTiN9RjFMcwuINePLjwuqHcnxrCxiHA7tuf2V5QLGoGjWI1pbMPFReR24xGOYEcdnXcxhUG8LuJES0SM4Rcq+LOAzBgma8Z6sBdrixiR6FPGJ3RgHf5le51Shn6jO9sqYQNu5HYrNmddZSnTXai0RPFDEHgjBdqDLQXXza0tS7vbmp0u58DapExO5foV3uOUlImPec2amgACP9txC+M4ia1VRidwEy8kek1gpGr+OQ4WcL6CKziEXbk/jpbs2IyUjTZcwz0MSxS6LzFgcUTEZESMR8RMzMdIRFii9EbE26iPB3X0NFRaJS4N5+g/YA+OY1+dnX2IJ1X9M3lXL9XI/a2jpyG04zCeSvS5LFHlXcH1+3Ndwarc76iRaeihqYsG0tdXRZPrVeObaih0u5kUWunCjogYzQ6WIqK7aq41IqarAhho9hlYCc5JjxdckO7qOcxKV98cDkg3TFOw0q/EHXyRrsbBBeafSS8w6auxT8GXddloUmpP1JyD882iUCOfuaUwhM+5HsJAk+z4D05vz1lTmv18AAAAAElFTkSuQmCC", 48, 15},
    ["M60"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAAByklEQVR4nMXWTYhOURgH8N8118fwlo8lJRIyNshOsRY2SFaUrZWSpWJhoazs5WNhIWJKYmFhZWMkinxMKWOGLGimGDOvY3HOW9f13jvvvOPNv07d5znn/M/zP8/znG4WQtADHMDNXhBjATbiedE5r0eHTfWIF3bhbNmZd7h5OU5gK7YhiJeQ4VfBnsIQnuAx7mASo7iPy3MQ0MIWPCg7sxDCBywu+eejMYfD3mNYFLoeq0SRE23WXsDrCp5G2pOnsQw7xIu7hWaKtS8LIQxjbU1QE6pLpZGIukHAD0ynUcVfFNJMvmmMJ3sMC3N8Vi+km8y8xScMYInYoGVk6Pd3RvqxKH0fw6UU3xq8FLM7iVNiyUayEMIg9lUE9EJUXMamRPg/cRRXW0Yu3lwRH3Ed1/CsguQKjojZfIjDhbkhnBHreQB7sTnNfRVLql2WxrEfK9LedmhgA37ibnGiLOQcTou1V4XVOJi+H+F2ScgoBgv2RaxMAp4m7nVYir7kb+I7XtWcW4tWj7RwT70IOC++cm9wEttnWD+SRhHvZhFjR8jFW7oh9sKXGdbvxCGx2XaLz+yIP8V8+9dBdoJslr8ox8WXZAx7ehJRl/gNvhRxDqBRSKMAAAAASUVORK5CYII=", 50, 12},
    ["M79 THUMPER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABcUlEQVR4nM3VO2sVURTF8d+Ya5r4AEFNsBKttBHRTsVCSBEs8gEEGwv9AlZaCoIWgp2VjZ2NgvgoDIqgqKTwhY2CiqA2JsQHid5lcQYyDEFuEm7IvznMXofF7D3nrKmSTGInfuIJzuOR1cEadHvZWCV5in2N2l+cxsU+vNhiGMFDnMVhvMXnWutiBnN4g3MdzLYMBnABJ/EcL/CyXt/rbULHMIgxbFMmWzX0O7iKP//x2FGvj/Ea0y19vdLsXhypktxXOu6FH3iFSVxWGmxzHOPYpRzZlSHJ7SyN30nOJNmcZDDJaJIHS/RaNlWSGzi6YpPrEwvdkdXMdZxo1TpY18H2RZp1MYXv2ISNDW0OE8rdGcZW3MUefDWfOm0GsKHxPFvXDuGaEhSfcMvCAfGtoyTIM+U/Mo0PSuIM1yapTadqfaZhsBY3MVr7nMI7HMR+XFLi/Ao+KmnYF6oky/UYwgHcMx/NW7AbX5Sv9EuZaN/4Bx/WHO3vIhLtAAAAAElFTkSuQmCC", 50, 10},
    ["M9"] = {"iVBORw0KGgoAAAANSUhEUgAAABcAAAAPCAYAAAAPr1RWAAABHUlEQVR4nK3SsSuFYRTH8c+9bopiQIqUMlAWZTAQZTGwMfgXJKt/wW4yGAzKn2DBpkhKzKJIKcUiETqG+17drvflzb2/OvV0fs/zPc9zzlOICFVaxDKO/NQt3lPytWrFCjYLEdGDZ8xiB8UcgFwqYQ2j6GokGKtFbCDQ20AwXJcwgc5/HL7DLh5r8pc4w1UhGWgz9jFZs/FTecADuMAxZrCEcbz8Wj4iKrEeP3WeeEMRsVC1d7FqnRmlpEYR8ym1BzGGE+WBdyu38e2vnuEbPo2+FH8bH4nfhGEc4iEPvPKErZSWREQM5nl+VhQiogX3aK+pe4P+XDfMUBFzKWA4qAdcgU9leKeNgL9meJ/1wkvYU/5aI+hIog1P9cK/AGgLxyuYNzzEAAAAAElFTkSuQmCC", 23, 15},
    ["M93R"] = {"iVBORw0KGgoAAAANSUhEUgAAABQAAAAPCAYAAADkmO9VAAABKklEQVR4nKWUu0pDQRRF171GIYL4iFhYpJOIlY0ECztBxMJS/8DaTjvBUuwEK8HeH/AbgmhlL4IYCwUfKIbgsshE481NiLkbppkzs84+Zx6RStAGsA3c8qsP4J7OGgLWgFPgCZiM1C2gCpwBg102d9M58AbkUXfVT7NpVEUlF8i1YL9XXQCXwCNwBbz/RAJ5KZHxS11XD9Rxtajuh1il6SZtdALW1GF1Xi2FNSX1Qa2rh+pAGjAORjcTJVWBVSAGxoAFoAAUgTIwBRwBUVsz1FzI3KqdbmWFsRxa0lbySsqplXsAoi6qs0ngcQL2Elz3AkztYSHRhWeg/o8r9EcxcALctMzt9QsDiGy85TtgmoazCeC1X2AMzAUYQCULrAmcAa5p/Cp5YCQL8Bvg6bq9FCiAqQAAAABJRU5ErkJggg==", 20, 15},
    ["MAC10"] = {"iVBORw0KGgoAAAANSUhEUgAAAA4AAAAPCAYAAADUFP50AAAAxUlEQVR4nOXQzyqEARQF8N+MqcmGKAtbJAsZr2Cn7OQZPIEXsbL0CtZewl6xQf4MhYUUOTY3ps/m+9ZOnbp17/nT7SXZxQhTeMU9HrCJU7+YwzYOQJKtJCdph5sk60mWBrphEft46yU5wgyWMY2NOvqo2s+1P8cXdvApyTjJShJJZpM8Va1xkr0k/SRrtf/hAAsTVV5wgfl61DVWcfendMNpmOS9Es+aKZPsN3xGGLb5UlP4iOOab7sIL3FY81UXYWv8B+E3bBmtOuCg9UQAAAAASUVORK5CYII=", 14, 15},
    ["MACHETE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABaklEQVR4nM3WvWpVQRTF8d+9udFYiB9ISOMTCFaKVVCEoJVYSBBLW0srwUdI5TtYxBewEGLjBwYRohK7kEbEGBHBD2JyWRZnRBHheu4Zon8YBjazFjOzz559eklUYh53apm1pV/J5xxeVPIaiwGO4koHj73Yg1dYxAEEW9iHIbYxVeZhiW/9ov+KieLzpcwTJT71m98OFvAAs1jF816SBVzvcJCPZfO7zY4mEfCsl4pF8g/5NBi9Zld5hJc4jEstdOuSXE7yJOOzkWQpyXIHjx/MJpGkn+Rbid1IcnWE7vYAj3ETa5rieoj7mmL6/Be3cbqsvYCTLW7xT1zDG1zEZIm9x+sRupVeupfIHJ7iIE600E3jTBlHOu7hvJLKLmMuyaEO+n6SU0nuJhmO+UnO1MjIpOYprPH6ncUtHGuheYuZGp19W51DwJKmyS230Kzws6H8T3zQ/PIs4rim8+/XZH0TG5osbOId7sF3oU6xy/7UmiwAAAAASUVORK5CYII=", 50, 13},
    ["MAGLITE CLUB"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAAAdUlEQVR4nO3UMQ6CQBCF4W8NpR0mgrUeQ3vCtTwD8XK21JZ2ayF0qzQG3IS/nb94L5OZEGOUATWuaLFPCQU67GYMlaLHAyc8cccR22F+8aHASIiZrGSKzdIBfsVa5N8ocEO5dJAJzqi+CSGTW6+832+DQ0p4ARGeEgUAyWGcAAAAAElFTkSuQmCC", 50, 8},
    ["MATEBA 6"] = {"iVBORw0KGgoAAAANSUhEUgAAABoAAAAPCAYAAAD6Ud/mAAABO0lEQVR4nLXUMWtUQRiF4Wd1A4kWFhLFQAq1sLUMJFbptJOgEEhIZWXrD0lhLaSw0jJtinRWQZAUKQKiEAsLQY2CMSfFzsJlvDery3rgMsz5hu89c5mZXhKV1rBUm0Vb2O+o1bqDh3iGhV4L6AU2RjR5g7eN+SPs4lOZT2O9UX9Sg+ZwgMstzT9gHkf4Ubyp4o3SZh99XMMlvOqAwPcy3viLxrXuSbKR5GuSn/mPGv66+9geI+lQ3/DrnPpHSSSZ6QhynOQwyWqSx0n2W9a8TjJf+nR+/UJcbEkR3MRTvCze+5bkezgdteUhaLWltoOrBkd5uUCOyvjP6iWZNjj/Vxr+O9zF7ZL2M76MAxiqjwcVBJ7jt8GdmoguYKXF35kUoAm6VXknJriTJuh65f3x+E0KNFt5F3U/Q2PrDBP/+u9+r6RCAAAAAElFTkSuQmCC", 26, 15},
    ["MC51SD"] = {"iVBORw0KGgoAAAANSUhEUgAAACwAAAAPCAYAAACfvC2ZAAABiUlEQVR4nM3VP2sVQRQF8N9uFtQuCgkRG0FB/AMBSzuLpLGwMYWF30Bs7C20ljTxC1gpQiAgCCJYpAoShWARiGAEwWdERFGCmpexmAlM1rc8eL59eGCZe++ZuXv27p2ZIoSghgM4ik/4USdHhFsIuFMnqsw+jhJXcRtLeI5VdBoSnxU/7tmQhG7jQ7LP9ZpQpAofw/shvfRf0cWOWLxTeJuTFZ7iyOh1NWIsPfAEkxnXLUIIuyhGLmtAVNjEG8wMKecjse8v4GIWL7Gb+XtFCrXYnv8bL2u5uxW+YxY3MZGIGzg0oOAHWBxwbV9UYpMXuJvF57GAK8kPYvMfxpcUO4jPOG3/adPqfiixgfFa/COWM/8VTuB6Gs/gMi75+8ib1CJK3G/gTmb2Sho74t+Yxpp4Zm7V1rUquMLjhvhc5m+Jm+grzuMnfmVcjtYF98IMppK9jXviVd0LdcETPWcNCWVD/Fpmv9MslhFXuEnwC6wn+2GfHP9FS8ynZwrf+uToiBfPGl6nsTX8AR7pUnTliEKNAAAAAElFTkSuQmCC", 44, 15},
    ["MEKLETH"] = {"iVBORw0KGgoAAAANSUhEUgAAACMAAAAPCAYAAABut3YUAAABxklEQVR4nL2UP0hWURiHn2uiWVFWFhE1aEm05dQqEm4hTQnRkkThIk0tjVGLNNRQQUt/aGsSoyFoKoUPGgJDCqF0MCiiGlLLvqfhOx8ervdePy58/uAH93Le877PeXnPSVQydBA4CRwDOoHdQALcAmajuAToBvqBAaAH2AccAFqBr8AiMAe8DJ7PKgiAWnevelddsFjv1Al1Rl3aIDZLr9UzaktUG5VEHQSuhtO15FLn6x8wA3wEtgFdwNHQzSK9B84Db+POPMmgX1XfqOPqPfWBWlGXU3HP1O70CYMPq+fUp+qvnC4tq1fURAX1c7S4oF5Q9+QUOKT+CLFz6tacuLR3qmPqhxyo5+p+1LPqF/Wmun2DpG3q95Cg0iBI7C3qZfVbBtB8PaijgUSt6uNo888G92W5S51MwSw1urlXnc44zcPQrTJAifooyvW7NjjFukjtfdkBVIFXQAX4BLQDU+G/jNrCrToC/CkiP66+CNSr6h21p2QXijymrqjDWYt71dvq3wAyrfY1AaLuIfW6SnphxLWrW1VvWBvcZoHUZ6czDXN6bZasqpeaDLHO8fN/IvoeBe6XHMrSim/TLuAU0Adc22wQgP8p+KVO5YBdrAAAAABJRU5ErkJggg==", 35, 15},
    ["MG36"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAALCAYAAAA9St7UAAABvElEQVR4nMXUv2/NURjH8dfVplqlpCREVCJ+RcSfYDKIFKPNZOjAYmDpPyAd7CY6iY3E77EJAyFiEZF0EA2DoH5cpE0/hnOa3EjruqW8k5PvOec5zznP5znP+TaSWAL9GMEkrnboO1a/Z5dy8GJ0L9HvHE5hGk+xAo3av44uBHMtfXXNVxzA4br2r9CpkK04huE6Xov9LfY+Rdw839HEN0VsD67gFu7jIqbQW317MIu3iuB+vMIzTPwqsEaS2/iIJ/XQZrVNKxk9hO3Yhi1KVpebaXxQhEzhPcaVm52PbxDrauwzjSQvMKRkZSFOKhls4gKOLk/sbRlTbnZeyCqsVITMduONku2BOkmp653Yjb1YXR178Kiu2VfH7ZhRsnkXG7G+ntnuLzOAHUoF7MJlpWoWpLuq7FLqdVKpx894jpu4tojvaZzHa9yogR7B8ZY1c3XuTpug/5hu5RFSsjWiPLR29OBE7V/CQzzAHnzCmmpLy/7LS5KJJM0km5P4zTaawrska5P01fnBJPeq7UuSl0nOdLDvkpskj5OMd+A0VIWnCvrZvinJhn8RfGtrJOlV3kknDGMUB5VS+u/8ANPhlY/CBHGDAAAAAElFTkSuQmCC", 50, 11},
    ["MG3KWS"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABnUlEQVR4nLXUu2pVURAG4O+cHI05Bg1iEAneUvgAgo3BR7BSsBAEtbDRzlvlA9j6BoKIaGMVJKiFhYqFgqA2WlioEUlMvCZexmJNcGeDes7x+MOw1541M2v++dfejYiQGMB3/cUY3mKhD7UO4sLvNlu4gW14iFncwxPcRlsh2Eo7iyN4hlVYjyH8UIbwOHM+4SQ24ShmMJiEzmMFPlTqfsHqzGtgTfbXxH28Sv/ejHmJ6VzPQyMirmZAFfNZZLiTUeFzHjbeYXy3+KgQHsz311irDGQKoy1FiTqRy1jEHr8mtz33FioFlzBkOYlZRZ2JWtw0ruX+oqL2gDLZNr4p6q6s+AJbsRNfcRcPsFFRcXKJSBVzOJFE3uNY+sdwPNcvcBqbcVORfjd2VepM4jCuY102NIoN2dgZ/UZEHIiIWxFxJSK2RIS/WDMinkfB/ogYj4gdsRwXK7HNSm47IhodnNG19ZK0L5t9VGlquEbk0v9o9k/W7EHEQ/k8p1wTGKnFvOvxgvSM+jfSCWYUAncqvjc4pfy55vD031vrDj8BuOiKGiBTnAEAAAAASUVORK5CYII=", 50, 9},
    ["MG42"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABU0lEQVR4nLXUT4uOURzG8c/d3CMmMU2YbCQLeQNegCI7S9PsrKwtZusNsDR5C9hSLOyU1CSFEpPMSjQaZphJw4zL4pxy9yiexz2+9ev+c851ndN1Or8myVWFW3js/3AMy1jv6TOj7PM32rrAFczhBRawiCV8wjZWMI1d2I+PmMJBHKp1uPqtYw/G8B0P8QYX6/yv1X8e49ionp+xGz+q7kD1Xa7rNziDo3iHD9jCIzRNktO43yOlQVYxuYN+f2IF3zDVKkkMsonzeFu/t3FSORG4piT0EicGtJOd93u4oZxKl7HqOQqnqu4L7ta9HMFTbElyIb/YSPI8yYMkE0n8pZoka0k2k8wk2ZvkVcfv+hAeO1ItzuIm7uC20S7kOeyrCS0o9+Y1jtfx8RFT/2dazPbQX6rPy0pzgInOeN8uNTRtT32UrvKk829eaZHv8ayn/9D8BNb65Uw6yMdEAAAAAElFTkSuQmCC", 50, 8},
    ["MICRO UZI"] = {"iVBORw0KGgoAAAANSUhEUgAAABQAAAAPCAYAAADkmO9VAAABBklEQVR4nKXTvy6EQRQF8N+ysd1qiRAV0SglVB5AoqVXeglPoPMMNLK1klLlT6IjUZIgdIKj+L7Nbta3+xEnuZnJvXPO3DkzI4kyxpLsJzlJ0urLV8VOOU4n6SRpd2uNJErM466cn+ILc6oxgwtMYhErOIdGklUcYXYI+Te4xR7Gm7jBxz/EYAob3Q63EHziBevYVRxnFJ6xXfIecNkVrFrcxho6aPXlN7GMKzzhbJDYHLL7q8Lk1kD+tKy9oVFFHCZIYUM/PrCkuP1H3FezRr+34/TwXrNWEmMjOoSFmvoP1AnW1f9MONTzsoGJWsVf+HJQenidpPlfDyluleIB1/6oP3tUh2/zbeu7PlyXMQAAAABJRU5ErkJggg==", 20, 15},
    ["MJOLNIR"] = {"iVBORw0KGgoAAAANSUhEUgAAAB4AAAAPCAYAAADzun+cAAAAoElEQVR4nMWUPQrCQBBG3w4rglfQ1sIjWNt7EO+Y2iNY2Cp4AiH481kkRZpkmnz4wbLDPtg3W8wWSZhyA9Yj7Bgm6W5CCnBwifcZd4mXGXeJ3wlfBeCQLxK+rcAd+AAtUPs6gELXeZ3Yv/1FMTgLYJN1VmScp6lU4MEfXoykkMTM66QkMeh6zrwSfnWNU0340yVuM+4SnzPuEl/o/oexND/i84psRuKqjAAAAABJRU5ErkJggg==", 30, 15},
    ["MK11"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABkElEQVR4nL3VO2uUURAG4Cd7ySpeIAREUbC2EGz8ERZBKy3SWomFjYU/QLSztLXVQtA/kYiCYuEFYyGKhaKRhYR42W8s5ixslmzcb7PuC8M3MPOe751z5swRESa0axHR3gO/rt3YLd4wOU7i8h74U0ULCzU5l3Adi9iHK2hgDj00EajQxhr240iJ9Upuo/j9zaxKvCr85sB6K/iym6i5iIiahfwvBLaKNWWBv3EA83iLl0OcbziE7iwK+VFEHd4htomfxW9iXZ5CDx38kkU8wy18H+L31223agjq4ik2sCTb41+4i6s4Ktv4T/lGscH2CnyqoWcbRhUS8ihXZX+u4FX5KdzHxeK/xmOcwPLQOu9lz3+eVOC46BfSxRMpeLXY+gjOPE4VP3BHFraF8zg4kNuZst6RaOG03O1qTM7twoGb+CpbpyMn1JmB3HdTUTkOaj5K5yKiisTziFgYij+I7Via1YNZ50E8hnvykm/igtHtR06jjUk3uC7qTK3jeISz+IgPO+Q8lBf/Bd7IKTUT/AXKuom/Yr6sdwAAAABJRU5ErkJggg==", 50, 12},
    ["MORNING STAR"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAAA0UlEQVR4nNXVoUqEQRQF4G90gyDYNv2CweITCIsYzQaLUew+iC/hoxhkMfsARoNBw7KCsIjHMuLwWzQtc+DCPfcMhzMMlylJdIhL3LSDjTUF+S8KhtrPcIFp5QP9XCS4whz3OMZj5QNMcI4ltrFV+wk+qskmPquZkTY+d4KXOn/FO94afdGEW+FpFHjZ+H1jD7s4wFEz38E+HqCk0yVpcIubkqSXFznD6Uh7rvpKkl7qOsk8P1hUfpjEusP9tUqSofazJHdJppUPSZROV+TXP/IFsqFsUJMYmAoAAAAASUVORK5CYII=", 50, 9},
    ["MOSIN NAGANT"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAHCAYAAABKiB6vAAAA/0lEQVR4nNXSTSuEYRTG8d+TYVZsSYqlwdJiyoLvIB/IR1B2ylpJWVCWFkrJTjKL2XgLeRdCdCyeezGMxcyzEP86m+t0zt117iuLCAUoYxyjOMdpQ28MfXjCW9L6MYAeHOESD/ho890S3vH67c1qVsBIBbOYaXewIJuY+kE/w5zcWL2EXoxgOFUFQ+jAFWqooxMTmEy9Voi04xqHOEj7athX/EcayXCTRcQDultc9IwlnMiNLWJVHrEn7GALC7hNWqHstksWEduoftMv5BkexAvWsIINuZmuNPMoz/4x9jRf6/eIiPlo5i4iliNiOiLKEeGvVwm7ydM91n29/L/hE8EM4YhbYPVlAAAAAElFTkSuQmCC", 50, 7},
    ["MP10"] = {"iVBORw0KGgoAAAANSUhEUgAAACEAAAAPCAYAAABqQqYpAAABkElEQVR4nLXUz4vNURgG8M8d94pIkZqdzZRSFrJQfm9MVv4ByUJhISuhSLKwsLCymVKSf2BqNiILI4vZWbixG42NhSipIYzX4ryX63bvnXtuPPV2vue8z3nf9zzf9xwRodImI+JIRLTG2NuxOxGxoTNvqsM2nMcFXMUWNLr8gQk8x9sBMdZiBw7hITQi4vIIyTflpv09SWvwGp+75g+wgMVGRPzAFD7iKfbiWxd5HR7j4JjJB+EDPlGk+46lrHIG53rIXzvkCtzFNM4O4VxSDj/VzEJaWcx9vMA7RYGfivz3cFFR6AZOrFLEKzzJ2DexdRi5iXlcwyJWcBptf/+/biznOIs5PMN25Z9fwZlck4c4gI194iz9/qq8Wq2IeB8FtyLicERsjojd6T+VvpM1cWuv6FF/pJ1RmmsNXuZaO8edNUFrizie45u0XrSVvtlXE3SisoiFTDQ/wL+cnD3690F/jPnsrh/iu559cWzUeLVKdPBliG9Web5735t/rsRq9ijV2PU/bseouK3028oo5F9aKtp9IuT0cQAAAABJRU5ErkJggg==", 33, 15},
    ["MP1911"] = {"iVBORw0KGgoAAAANSUhEUgAAAA0AAAAPCAYAAAA/I0V3AAAA9klEQVR4nI2RPUpDQRRGT54xYGknRCwtkhAsxE4sLCVY6wbcgavIDrKFVCmsFLEQSy3cgIUipjGVEH+OzR2dvLzifXCZmW/mcL+ZaagATaAN3AOPwCvL2gKmwLQZRg84BdaB/QpgQQlaA45Ke0OgA2zGegTcAaCmOvFfM/VAPVYn4Q3S2RwaZ1A/87fDOy9DbXUem29qkUEt9Uu9Tl4Rec+A1ZhfAD/Z3ebAE/D55wS9G10+1J2sS6oNtZHW6fX6Md4CDxWvvPBvKd5hjFeVH1NWtH2JeHsV0ZYKtRvAu7pSByqyaDfAd510OXRZ6z4BCTxHp1r6BZSjGC4UypD2AAAAAElFTkSuQmCC", 13, 15},
    ["MP40"] = {"iVBORw0KGgoAAAANSUhEUgAAACQAAAAPCAYAAACMa21tAAABWUlEQVR4nO3TPWtUURDG8d+udxVjAgFRREEsrCy0CUJSaSHYJq0Qa7+BX8BKSGdtYWGlNhYiFlkwXyDVClokIIJCwCKurzwW9wiLYO6JsmLhH4Yz5zAz95m55/SSHMdb3ZzEObzGp4nzBWzi88TZAF8m9gcxjzfY+kX9ZZxucB23O8ScwjrOVgjfi294gTE+aBvbxYy22a8NznQUmcO1fYoZ4/DE/j7e4yVG6JeYMT6W+jew20vyFEM02rEfKoEzpQsl6SZOVAq6i1lcwjFc0P7WbpLcSaLCHqVlJ8likotJVpMMkqwkuZVkI8koyVLJWSs55yu/ocF2he5ZXCn+UPsIeniivbwPi/3MgbI2VdMpgQ8q4pZxpPhreFVZ/8frfVcrqK+9aF2slnULz2uL/w79ipijuFz8x8j05NQJ2sFV3FM3zT+i5rIFz4pNnZoJ/VX+C+rinxP0HXZCsUHF4lUZAAAAAElFTkSuQmCC", 36, 15},
    ["MP412 REX"] = {"iVBORw0KGgoAAAANSUhEUgAAABwAAAAPCAYAAAD3T6+hAAABJklEQVR4nLWUoU4DQRRFzzataSAYBLJBIEDiqgGFAcEf8AEEAwnB8BVgSfAoBH9AEKiGYBpMHSEIaEJJDmJ3YTtst+xme5IR+2Y2d+59MxOp5NAAOsA2sAYIRJn58Hsac8AGcIM6aRypH8Z8Os6rFWnm7OYY6CbuUlol3BSSJ7gUiE3iHXgsqTfKE+z/48cWcAiclxQk7FtTvctEPlTv1YG6oy4n46Cg94UjLJwGPb5M6mfBus2qgo2M2RXgJAigQ3z8n+Fn7QLwVTrKhMjfe3gB7Afze8AQGAHzwFtSv60qmFrtJn3K0lejqtFNi3QdxuIFuCJ+UepFbau9v2+Cq3W7Sx1uAYvBPh6AXu3uiGPcBdpB/XoWYqngC/AEDIhPI8QncyZ8A6Aa7h5KlouLAAAAAElFTkSuQmCC", 28, 15},
    ["MP5-10"] = {"iVBORw0KGgoAAAANSUhEUgAAAB4AAAAPCAYAAADzun+cAAABXElEQVR4nK3Uu0odURQG4O/oYMSIhYogwdhFooKNTSpJ6wNYWvkAnvo0FiGkT5VnSBmJjdqInZWK2EkM4iUqFl5CRLfF3sIpjmf2QH74WcOstf912bNGCEEFTocQZiqeaeby83MhD7OoYxw92ErvB3Gb2IFXuMM17pvOPyT7Ab24roUQvuAbrl5I2o0VTGUW2Q7/0MCvAvP4mypthS68yxS+wes2/p94i8EC37FUIriOBXHkQ23ifuBP4jHOEk9wqqm5Ao8lSWEzsYFPOMI+LtEnTuVjEl/M0FPgd05gwkyyX8V738Z7sZMDjOUK1UIIubHDYpGdmEuJHnGIc3Gk93iTpVZhB+sh4iSEUGvhX03+/hy9jtx2MSru4xpajWk32YkcsSqJFzGCzy/495KdzBHL/XM94zixFXaS/e8dl2FXvIKsjqt81Tk4EPd6oCyw6qjLsCGu0wAu2gU+Ae6NAO3PKv5YAAAAAElFTkSuQmCC", 30, 15},
    ["MP5"] = {"iVBORw0KGgoAAAANSUhEUgAAACMAAAAPCAYAAABut3YUAAABk0lEQVR4nLXVvWtUQRQF8N/KovELK4X4UViISNSoCIKFihY2WqTxfwhWFmJhZf4ES1v7lKKoEMRGEAxLKhXBQolZwUKj+IHH4s2GRdbd9xZz4PLu3Llz5sy7l5lWEmNgBw6jg8/jEBRcxBnchHaDhSdxofj7MIs7eFFik/jSJ25bGcOnAXw/cQzTvUAryXVsGCKiVYTMjMgbB7/xHJfQbSVZwc7/vEldBN/wCx/bWC8xK/iBvWX8FR+wjG7xO3iilLMnZmoIabCI132xCVweIWY7Tqt6aBmro9T3xPyNd3hY7NGAnIN9YhZwv/iTqlPPYk/h6Y4SsYYkt5OsJrmX5FqSqSRG2I1U+J7kXJLNJT6dZGuS+TJ/tgbXmkmyO8mmJouSdMpmi0lOFTuRZFeZv1XmrzbhbeN97d9Y4SiOFH8ezwbkLJXv8SbE49wbV/r8x//Ieapq/PONmBuWR5KNSWaS3E0yMSRvqZTqUJOeWS+bK2Lm6q5pZbyHsg4O4CXeYr+qbEPR5KFsild4gDfYosal9wdOMvzoLZjPiQAAAABJRU5ErkJggg==", 35, 15},
    ["MP5K"] = {"iVBORw0KGgoAAAANSUhEUgAAABEAAAAPCAYAAAACsSQRAAABTUlEQVR4nI3TsWoVYRAF4O9eV0ijBuIFwUrRIigWKlgYJMTKJvgc1mLpG/gAikUE8waCCCoIFoKogRRBEBFJYadRlCSQHIudq5fFmD2w7M6ZYf5zZvYfJFE4hcN4qz+m8KSpYA53MYPbxR3EcXyquCnuJzYQ/MIZSS4nuZdkN/2wM1G7mWS7wQhXMehpYTjx3WDQYAsvcKJHo2Ws4iIWsYSRJJJcSPKqh5VbVT9XlkZJFsaDfYMVXMIHPMU7HNBubQo3cHTSBmbxfKxkmGS9TruT5Erxs0mmk5yv3KPiT1e8mMRYybx2nfAZX3FSu8ZvWMMOzlbNx8qvw1jJ/eq8neRQcd3nfc1hppsblu/rdcJr/NhjMy9rDvPdxLBknsNNPNijATyr97VuYpC/d2c/HMEXbOKY9v/6o6QvNvAY0101zb+q/4OH2kv6fZL8DULeHvZfhuAuAAAAAElFTkSuQmCC", 17, 15},
    ["MP5SD"] = {"iVBORw0KGgoAAAANSUhEUgAAACkAAAAPCAYAAAB5lebdAAABlElEQVR4nLXWPWsUURTG8d/EBCQaBDVELIKkDCkExVIUA4pfwE6wsPQTWFj5EawsRLC2UgxuFFEbbW0SLISoGNOIL+RFF4/FvcJs2Mnu3k3+cJm5c84855mZew9TRYQC9uEMPuFjiUCNBVzFWlPC6ABiJ3EFFdq4idd4lOMTOIDVPB/DCLawgc1tem3pYY/hFJ40Fa4i4nZO3ok5XOojr5QHeNUQiyoiVjG1R8V3hVF8tXcmH0qf/D9/G+YbWKld38J63WTjgs208SaPPzXxGzjY494F3O2R05Mmk0tYRAsv8GNbfATXJZMtvMQyjksPchrXMDmswbrJNTzLBRf1bivncDSf38EXvJU6wHt8zibndsOkiDgUEVVEGGDci8RmRMxHxGxEzETEiRyfyfF3A+p2HVVBMx+XeuEEnuNCl5wK37Efh/FriPfYsdP65bxkkLQ0uhFS3xvD2YIaHZSYfIxZ3MLTHfJa+Xi5oEYHJZ+7X6bxAd+kXf+7VKjkTfbLitSajuDiMEKD/GCUcF9anz+HEfkHQgfUlgZnscIAAAAASUVORK5CYII=", 41, 15},
    ["MP7"] = {"iVBORw0KGgoAAAANSUhEUgAAABwAAAAPCAYAAAD3T6+hAAABNElEQVR4nL3UT0uUURgF8J/jtAoiFKx14sJFgrgewm8QuIr2QR9AoX1LdwotRfDrOAtRDCpoEyiCRJRQM3pavHdkGKZ3/gRz4OFw33Of53DPe7lzSYyBh3iBBezgHTq4RQN3Q7iFU5zj7H5SkmdJ5pOoqVf5P2z2ZjXxBfv4VXPClXFiqEEL12jOpcr0KS5rGl7jaMj3LoKfeKCKGebxCL9xgzb20FWOvDgi0qUkb0q9T3LXF9dh2bPWt3+laFtl3WOSdJI0RhgOVrsM/J7kbZKNJMt9+vOivxzsbeJKdasmwUesq27gh0kaG7iY0Izqv9Xhqs5wbwrDUbjGLr4NCk0cTDHwc+GTf+h/sD1MaExhBl8LH0/aOK3hj8KPZ2XYeySezMrwU+HVWRleFtMb1ZM2Nv4CumVMM5mtS2kAAAAASUVORK5CYII=", 28, 15},
    ["MSG90"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABNElEQVR4nL3UzSpFURQH8N/RIeVSRDEzMFEGxooHYGbmBUw9gJkpA0/gNXwUSgzExMxEknwNhOujENtgb8WV2z23y79W+5y11n/1X2vtdhZCUADtGMcyykWIBTGESczVSshqaKQN8xhDEwZxjXO8fMlrRheuatcLAm4rfCUMYBSHtRTJQgiLiTTxS04ZHQXFNQqrOKnwtYgD7Ejf1wi5OMGZKsXqaeIm2See8YR3casveEyxd7ym+Nf8B6zh4JdG2tP/PeS4qyJoHbM4wlvyNWEf/ThDlmLP4maJ12GkSt2GI0cfLtIpCdrFBpZwWsHpRK84gGF0i1O9xAqOsf3Hun8gF9e0gB5R/I7va67EFFqxJTaVpfyyf97CN4QQitpeiJiug/tnlhfsOxdfkhI2Gz/W+vEBSIjfes9qxc0AAAAASUVORK5CYII=", 50, 9},
    ["NIGHTSTICK"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAAAxUlEQVR4nM2WMQoCMRBFX9a1Uqy00gt4EhuvaW+hF7GwtBREm0UUkbhjkYBBWHQnu8YHgT8hE/6HhMSICDWZAwvgCsyATd0N2iBX9ByAgR+7Zu3oyRQ9w0CPmjISiybIuEInRROkH+heU0Zi0QQxkf2toDFyqdBJ0QTZV+ik5MAEKHwtQOnnLe4YZcDD13fgFPQff+b0A0ZEtsD0i7UWOANdXhe+wAVPzcqIiAU6qZ1EcsuBJe6VFj/AHal3bXHfkn+jBNZPkrIq9nsKo+oAAAAASUVORK5CYII=", 50, 12},
    ["NOOBSLAYER"] = {"iVBORw0KGgoAAAANSUhEUgAAACoAAAAPCAYAAACSol3eAAABwUlEQVR4nM3VTYiOYRQG4OvDYDZCjNIwM0nK/2YWtiNZSTaUtVgo2bCgJAtbViwRs0HZizJslJ9SjI3IX/ktKYqY2+J5/STfV+/rS+469XQ65zx393vu520l8R+jH8O4MKlB8wLM6C6fttiM9dCE6A68xknM7x6nP2IrRmBKg+ZxBLvxvsrNrM4Tf8/tB5ZitSLmQF1FV+MBpuFAdb6FmziFtZiL7VXNd8yqeU8/RjEZLYy0aprpOK5iHz5iHgba1N7GJTzFIRzG4za1LQxhZRVL0KMIMR1jrSS7sA578aIDyVU4XxF8h2X4hF580WyN2uGV4oEj1ewFrXTnfdqCt5jdhVnjuKeofE0RaGcryQnlCdiDlx0GrFQ+3yR8UAz0HZ8xtQskKUZ9rih6TDHo3Lo7ehpXsEnZoykYbFN7F2PKju7HUTzrMLsfKxRBhhRF7ys7el2SOrE2yXAKziR5luR+kidJzibZkGQwye4kvb/09dW8Z1GS8fzEtrpEJdmYZCLJwiQ9VW5OkskNZnWK5b8QHWryZ1quOPEg+qrcG3xtMKsT7uIOHuJRkyflIi7jhu6T+x2jWAx1zfSv0Y81OPcNyo9lXlsJCwsAAAAASUVORK5CYII=", 42, 15},
    ["NORDIC WAR AXE"] = {"iVBORw0KGgoAAAANSUhEUgAAACcAAAAPCAYAAABnXNZuAAABDUlEQVR4nMXUvUoDURCG4ScSQcWfKoK1io0WImgpeBEWegneg4XXYSVaehGCYGdhWhFBbEQNRkULYSw2IUuiuxjMycDCsPN9h3fP7EwlIiSOE9xjH59FwsoQ4GAT29grEo2kYemJM4xiskg0LDhoYLpIMKy2TqGOBXz9Jqomw8mAahjHAT4UgJHB1XHTymv+v9WzrXPHut6/lRmrOMQ1JjAn+7KfotEHWDUHN4dFLLdqd6XuiEj5bEUndsr0qad1LZfPl6oT3tp6RDznbu4xIpaKPClWyZFsZWzoHbZ3nOJCNph1NNvFQcOt4vKPnlsZ5PGg/7ndPn1PeBj0En7FOVYw01Vr6rTyKpe/tAXfHswkRn5JJ08AAAAASUVORK5CYII=", 39, 15},
    ["OBREZ"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABd0lEQVR4nLXVz0tUURQH8M+LoR8LS/FHRW3btzQEcScIupPaFq2ittEf0Lply1qq5NJFbRRBq4WKhWa2iqYQbAqSSErzurh3aJKZ3mhvvnDg3XfOvd/v97zLeVkIwRHQj7M169dYz9kzhIs169/YqlO3m3J3sY0zuIT2lF/HA3SkeIdH2SGN3EEfrh54v4W9RLzdYO8FnDgMWQ4CMuxgo1kj53EbN3CuQDFFYBX3SzlFXbiHWzhVIPkejhV0Vhnj9YycxjBGMYiTBRHW4n9MlPEWaykWoGqkDSNaK75Z/EIlxXt/BK+JBuoNCCVxmjxGTw5B9Tp8xTcsid0ZwOUmRQaMYSIJbhOHQ1X4ZiOhechCCBV0NshXEumT9DyLa2IDnqaaAcz8g+M7XmIOU1g8itA8lPDB30Z2MC2KnxS7X8VDvMJNUfxP/DhwZhnP8QLzWBb/DS1FFkLowXXxs3/EM3xpUN+LK/gsXrVddOM43mAFn1qsuS72AT7eZ3QJztt/AAAAAElFTkSuQmCC", 50, 10},
    ["P90"] = {"iVBORw0KGgoAAAANSUhEUgAAACYAAAAPCAYAAACInr1QAAABvElEQVR4nM3WTUtXURAG8N/fBGlRWZC9kiG9Y4sWQUH7Fq0K2kYEEbVtWW0k/AJFH6CgTUS0DKJtUIEISWBGGpHYohKyTejT4h7rclHRzGpgOOfMPDPzcO7cuVcSK6CdSY4vAT+YZG3d1m5l5BTOoQutmj1lbdo2YB+ezRpXitg33MZV7FlkzEl/gdgV9OIahrGr6O6im+aI6a0f2tHzh0mtwt6yH8QQXjQwa1RE9+MyOnGgDmgliX8rY+jGOLbOGn+H2AwmF/C3YV3Zf15Evln8Z1VfTmPof7ixpkxh5E80/3c8wgdVnxybA/MEo6o3b/08eZ6jD6sxI8uT+0m6GsPyegPzJUlH8Z1OMl3zfUoykGQmyWg9T9syb+sWPjZsY43zDLaX/T1cqPn6cQgDfg1fVI03hcdFF9OsdTmrGg/Keh43a/7hUnAEO4vtVc3/tqzTzcStJH14X85bVM+4KW/wDpdwokYGPpUC27C5Zp/AUdzFETzFHVzEQdVNbizx+1Qz9eXP6CV8aGe1O0l/kokFeu9rksNJWkkm58E8XKjOcv4gOpI8aBR7neRGkp6C2TEHofEkZwrpefP/AOBlSTxrU6/FAAAAAElFTkSuQmCC", 38, 15},
    ["PP-19 BIZON"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAAB7klEQVR4nL3VvWuUQRAG8N9dLipR9DQWgjGSWkUkECWIIGiRRktBxNJWsfYPsPJPsAj2BkSxUAs/UdFEECMookGFiBiMwc/kxmL3zCV4l+Ry+sCw+87uzszzzsxuISK0CGvxHe2YRhsqea2YddW1IgIl9OAQXmIfTuPHAr62YBgbq4pSCwgUcA4n83y5GJBIzkcHypjEBK7ULhZb4PgqTmkNCVKGOnENL/Auz39iEG+xwVyy5UJEDGG8CYclKcUHm4+5LioYkUqnHe+xHaNZ14UZPMEKRCEinmNoCU7K2Ik9LQq6iik8wq8Gey5hBz7hjdRvHVhXiIhbUpMtpus34wh6cbTOnml8kUphHN3SRfBZ+tOddc6N5bMLoTPb65UaHqk8VmE/bsw70IZt2Iv+PHbhKe7jDC5jDW6a7ZG7OC7V8TAuZvsT2NogwO5FkKhFaf7Ht0xiNfpqAu/PZB7gNi7kICf/YvQ6DuT5lJT2aoafZTKDeIxdSwy4HuZcLoWIeIWP2cEH3KmREYtL9z2pZ8akLK40+4ZU8FWq/WGNs7KY4Mt53oeHf1Yi4nxEHIuInojQhGyKiJlIOLvA3oEmfdRKOSLWR0SxVr9coyLiRMxidwvsNSWteBAP53F8Tqr/M1pBZBSvpT6oNN767/AbCJKhK/ppxRkAAAAASUVORK5CYII=", 50, 13},
    ["PPK12"] = {"iVBORw0KGgoAAAANSUhEUgAAACkAAAAPCAYAAAB5lebdAAAB6UlEQVR4nL3WTYhOURgH8N87mBkkyqTUmKKUyMeeElmxwUaxUBZkpWZnoVgoH2VlyYYoGytZisWsLEQ+8lVSzKRZIFNGM/O3uGeaG6+Zeedt/Ot0zzn3ec75n//znOfeRhItohsX8AOf8A4NBBM1u47ybJT5idJvYAl68B5jxe4JXmMfntU3XNiExCJcrY0/4nxtvBmnWjrW7PAWvc1eLFSd5ptKkQmM4FjNZhh9pb8cG+aBIHzAepxRRWgUP/GykWQM1/C1kPyOtTXn0eIE/Vg1TyQHVKm0EYvL3DCGGklGsHQa5y4cxAlsw2Psqb2/hE7cVSlxvckaz3C5EAkWmMrjyfZZJUgvxku/G4OSjCTRpK1PcjnJlyQPkhxK0plkUZKfmcLRJPuKz8ok4/kbp/+xx6zanxenE/txHFtwAzvwpmazvag7GaKHRZl1WFH8J8N2VlUFbk4TqZmR5FeSk0kuJhlK8ijJkSRd/zjZxZpCV6ZRYHXNrqcdJTtK7Peqbvpu7MStMt8Mu2r9p9Ocf1CV+LC1XSVbbQeS3Ct5uWYG2/tFyXPtKDlnxyTLZmHTX0gOtEOykdY/i61gE56r6m+fqXrbEjpmNmkLL1Q1sgOH57rIfJNkqvwcnesC/4PkbbzCHc1/aGbEbzIYXZKpnhe5AAAAAElFTkSuQmCC", 41, 15},
    ["PPSH-41"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB5ElEQVR4nL3WO2sUYRQG4GfiGoxGo0JQhAhKCoVsRETBRlQQLATBxkos7K0sLP0PIv4BRSyEgIhWYqWNl2BAUmgUQSGSRI3XmGzG4nxhQ9xdNpOJLwwDc+a833nPbSbL89wqYAdqGF8NcpzHBZzET6isgOwALoqg4TmeYgCnhZAhjLbg2IAM35d59jF0CkETmM8KViTDLZwt4twA8+jAJF5gLQ7iSbIfFkn6g314j8/oxyUcb1WRzSK7XzGy6PlOXMOpkkQQIog2GcMafErBwhSmRZUn8FuIGscgRitYh70p6AFU070vkeRJyBtsw350FQj2JfaIloBhnMGXRe/MJDHLRgU/1DPSCJlQPdjA9k4I3IRuzGEjPibOTpGIbmwXLdGffO/gbZGgG6GitYhmuIErQgQcQi/uiar1JFst2bdiFy6rCxkrFHETLBUxL/pvroXPVZxTFwHrxSztFpuoS10E0ePP0rWAo4UiboKlw14TM7OASdzGQ9EyvbjegOdRm+ctXhon2vRpC1n+7/79hbu4iQdiO5SFPjEnMCtmpxT+LM/zWbwW2bovhnC6DPImmMIWsQR68K0M0orIykwZZG1iBEfENqzicRmkHf6vCOJ7soBqWaQr+dcqimHx//UKH8oi/Qu3jXF9n30YrwAAAABJRU5ErkJggg==", 50, 14},
    ["RAILGUN"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAABuklEQVR4nM3Wv49MURQH8M+bnRlCiMJS+5EoRYhCQ2IVJCgkCqWOQiT+Aoot+A/0Go1OFAphFWQ3oRCFEIUoJDIbsmTMmqN4d7IvmzdvJm9ms77JyTv33Pu959x7T855IsIU5faU9xsl1wZ603DsxfaKefiVpI0+ZnEOr9FLa1r4m6SVbD000MRq4rYRaW4mSZGX4U+B18dpfMJSFhGPCw7KDtJOAW4ZcpifeJX0rSmAlREXAPtwoDBeQqdi/QlsS3oXL5KvU7ibRcQznBzD8f+MSw283+wopoEGvm92ENNAE4dqcpexqya3j881uWVYaeJYTfI7fF1na+GstcLQlVc1eIK3Sf+CBzX9liMiLkfEjYiYi4jlyHEzIq5ENc4Pqe3XC2uuFuxnNrKnNPBQXsaKWMRCzbspltCDOJqkqmdNjMHmvXX23fLU6RreP47jd4n9Vvrex72k7zS6uU6G9DQXI+JjRKymlHgTETMRMV+RWv0kZehExJ7C01+IiGyjUwue4w5+pPFhvJR3zWHIKubm8S3p++W/EVH7tsfAILU68nT6YO0wAzyt4Gc4ovxQc+m7A48miHEs/AM96SZT05tTrgAAAABJRU5ErkJggg==", 50, 14},
    ["REAPER"] = {"iVBORw0KGgoAAAANSUhEUgAAACAAAAAPCAYAAACFgM0XAAABFElEQVR4nMXVwSpEURzH8c+dJhFZKJ5ArJCFQrZ4CVkoD+Il7Cw8gb0FO1mwUUQNJWWaMSGhJMZiztGkE1cy91f/zu3+zv9/vud/b+dkzWbTH7WMK+zmnD+IcXSjVMYMen9IauAI7wmvgqlvALowiwXM4QH7KGGyHIyeMDnDNC5RRWzPAMZwge0Q1eAdY+XLoiOh7nzI3Qs5a3jBIpZwnSU+wSrOsZPYzXBb4SE8ox+jOMET+kJXImgtUWcjQG+WE2Y9FE+pEmK97V2m1ak45tEnVClhnuEuZyFti/7mb76JD6kOnIb4T9XD+JrqQCcUARpFATxGkKIAogoHqBUJ8IaDIgEOcV8kwBakjuJOaELrBr39ADheRQQ3V2w2AAAAAElFTkSuQmCC", 32, 15},
    ["REDHAWK 44"] = {"iVBORw0KGgoAAAANSUhEUgAAAB0AAAAPCAYAAAAYjcSfAAABSUlEQVR4nLWTu0pDQRCGvxyDN7QIeEE7BcFCCWplpeALWKnPYGFjIYLv4ANYio1a2Vn7CCraiCBEgoUekBgv0d/i7JF1sxtMzPlh2LMzc+bbnWFzkghoCxg33+fAuxWLgZvQjwEVgR3gIOeBrgFVYBfoBHqtmIA+429ZPmgXcAWMAffAqBX7JLlxT4OasTlcWJJcK0p6VqI3/daLpJLqVZG0J2nGU6/O7M26pEdJNavYnVM8lnQh6VhSwbLuv8BSy1uXXgEKnlY/WftXk1Ny/E0pMuscsOCJDwH9QNnABkjmWW0VCPy099Azp5qkVUmbJmdD0kQzbWw00xFnjqlOTNK8pEFJS+0ASiICZoEOpwFnwDawCHwBk8D1v1pqKQ9Me/ynwGW7IK6iAPQoK2AKnXJ8HyRPIlPosON7ACpZQ5eBfQMDuM0SCPANMWCr7GWj+gYAAAAASUVORK5CYII=", 29, 15},
    ["REMINGTON 700"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAALCAYAAAA9St7UAAABaElEQVR4nMXVO0sdYRDG8d/RLYQUIl4SG8EgCGr8BFokpAgWImIhBO3UKpBvIWJpk5DeQgSLJARioQQLSxuxEAtFQVEUjleI8Vi8Kyzrfc8x/mGKYWbefWZn3t1coVBQQlqwjC78KuXB9xFlrPuEzzjFEebxD3/j+Ad0oAz1aEVj7MMbbGV89o1kbaQOrxN+s9DIIQ7QgxfIoRLlqfoyJSaXcbVq0YBz9KFGmMYUCoLQEaGxH8LkGuPaPH7ipBjhabI2Uocv6Hb9bT8LydWqEna7JrZazGA2kdOLMTT9L4EJhvHttmCEr8K+X1mSTrSjGhPofxqND+LO+xzhJd7fEm/DJN4J6wRLGMJHTOMM43ibqh3ABjYziE5zgfW7EiKs3nNIcgqLwj/iABVCE3lhBdONlOPPI8QWRYTjB+bOCZf7KPYXErFDrKTy14qT9jgi4dOYxz5+4zv2sINdvMIgRuPcm9iO7dm4BPG6ST7TpSsKAAAAAElFTkSuQmCC", 50, 11},
    ["REMINGTON 870"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABNklEQVR4nM3SPUucURAF4GfZVzDIIolbqY2JlZYhhYVELaxsAulCynT5CalDGmv/ioWVSBoRC7Gw0JCQRfwKIQSyosmkeEdYYVk3umoODPfcmbncMx+ViHADVDGD99jDGproy/gZPmesV3iACRSo4Q3eVq5RSIE5vMQL1Hso8tooOsQGMJT8S57zWMLj2xTVBgf4mvxiIpv4k76PBZ7jYYqcUoqv5wPYwTQW8Tp951jFM2zjJyZxivUWATX8wlEbcQsY/odCNpJX88/vuFinXRFxEhFb0Rk/WngjIqYjQkTMRsTT5PMRMZa8GxvvMq8/IkavyqtExDYGMdJFZ1bwCod5f6Sc4LlyKu06fycosI8nyjFVOuR+wDv8bvF9S7t3FGgo9+0TlvM8wbGyw0eZ13S5iP8KfwHBduFeUw7c1QAAAABJRU5ErkJggg==", 50, 8},
    ["RITUAL SICKLE"] = {"iVBORw0KGgoAAAANSUhEUgAAABsAAAAPCAYAAAAVk7TYAAABT0lEQVR4nJ2UsStFYRiHn8tJhDAgg2xSShbJYpTJf2FhQcokm7/AJovZIGVCGe7AplgYDIrFVZe6pHQfw3lvJHG/+9bX13f6Pf3e7/eec1BpcBXUOXVPvTevd/VC3VQHfzKNGg2pRb+qqn7EXqs3dS2aQqWgklgjwCnQD7wAd0ARuAVagUlgDBgM/Q4wDyTfqF29/hbZgtr3i25KPVIroV1pJMaNgEvq0j/abvU0oq2o/SlGmfoYZrtqUx3MpPoUzHqK2XRAz+pMAncY3FkGTAPDQAEw9lq1AO/AJbAcz8rAVcILdQLMAqMZsA/0JMBV4DlB/xRMRwZMAEP8fbMbYDs6bAM6gUqdZr1AE1BOmdlUZP+qdiVwB8EVs4Q4zoEH8pnVG+M4+UcOcJxiViWf734CMwD0kTe3lWIGsAq8JeibY18ESo3+iOtdHep27fwJbGPXE3snskwAAAAASUVORK5CYII=", 27, 15},
    ["RPK"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABz0lEQVR4nM2Vv2sUURSFv010N4tBjFFYVDbRIiKmF7QyCiaCf4ONoNhYWgVFsNLCQjSFNtYiiHYGIiEmjYiFqSKYQrGwUFl/JGb1s5gnPofZzaxm1AOXB/fc++49c2BeSaUD1IHRnHV1oAYsAZ+ArohfBiZDHuAF8LiTRQK2AM+A2roOmurALLD9NwbOAx+BXcBTYD+wDXge+CFgHJjJ6O0GqsCHVH4jcAS4DvSVUo7UgAF+ftEBYBDYGYaVO1j+G7+6EGMJeBBOwr1VYDGjtgz0A69T+T3ACrAXmC6pt4HhsHRPm8WWw1kBJLH0FbCbROgP3AcehpqjJC4uAg2gCWwF3gOngS9t5q2GMnALuAmAOmc2Guoj9bJ6WK2o5wL3VR1Su9QJdT7qu6GySnSrG3LU5Q7UaxkiLoYl0w0nA39W7QuxWd0RxKm+UatruWReIadSIl6qvS0a7qlNtT+Dm4ruuPQvhOxT76pn1GG11KK4V/2sTrfgD0SuNNVDf1tI3qiox9UTbWquRK401NH/UUie6FFnIjEr6nl1fdFC0u/IWmATcAc4GOWeACMkv91C0OrB+hO8A8aAqyRvCcACBYoACnEkxghwATgGvC1y0Hf7SvNx2X9kUQAAAABJRU5ErkJggg==", 50, 13},
    ["RPK12"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABxUlEQVR4nMXVsW/NURQH8M+vXpValKRSiVQM5E2NxWQTmyYSiVFMBoO/AoM/wCxMJGxiYCCihKliEINIeASJIvqq0vYY7q3ePO3r7yVPfZOT37nn3HvuOfd77u9WEaEGKtzCIh5iCZvyd9lf2qqs78KHvG4Age94l/WPaON1nSQKXMID3F42NHABmzHeMbmF+ayP4HjWT/S4aSc+5STgB/biqFRsiQpbMFfYhjGEmSIvWKgi4j3GOoIsZpktgm6vkeQvqfhB6cRJTJSMtDGdYw5hKz7j2yqFHMDLwtbM3x25wK94i+cNid4xPMZF7M6LX+BLXjiKN3nTm7iBu5jKm1USg3uKAtZDE/ukVlzyNyMkRn4W4/3YicvZPvvHExF3ImImIo5FhDVkJCLmI+FMRIxn2+mIuBcrmOgSo1OqLHXnd5UG7meaWl1Ob1K6R21cs9K3V6S+PZLHJ6W2qYO6zNWMVq/isxExFxFPV/GNFmy1ImKwX6fci/QyeVtENNfwXS/a69z/KKSKeu/IepjAM+lv1cZBvOpH4LoY6FOcaZzP+jCuSm/UhqFfjJASf4RD0kWeVLy8/xr9YgQWcApPcNgGFgG/Acl2LyU01kx/AAAAAElFTkSuQmCC", 50, 12},
    ["RPK74"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB3ElEQVR4nL3WzYvNYRQH8M+dYbwNGSHvbwuyYJSNxFqKlSwtFGvZSbb+ALKRjWRnhSkWMmSEpCQvCxuTJQsamSYvX4vfs/g17nXv5ZpvnZ7Tc87395zzO+d5aSTRBTbgMPra+K3AUqzCJwxO40zgOr7W5kbxsZtgsBJPsWZWF6TNuFfI3eKVKuj1eIH9WIy3xT5cxmtNuP2Yhy/T5tfgIK5iqFGryADWYl2RDTV9Y5F2lagjaLSwfcObMsJszMe7Jr4DWOT3aq0o8SzHaCPJbWxT/elWC8MkfmIBfuAZxrEdW2p+NzFS9H14VPwm8B3L8BmnMPWH9dphCJdwESR5mOYYT3IjyekkO5P0JzlTbFNJNiVpJDmf5GmNdyWJNtKXZLADv45FkgtNkjjZgnCi2I8lGShzg0lW17jvS4I9C7LTRI7XgviR5HGSOS0Id5NMJlnYxPay9p3hmU6kD09wAYdK/+5q0btLsBdjpd+nY6SmH/mH3v8r1E+tduhXJTIPt5rYt+J10T+ojtrJfw2wY/S4xA9q7XV2Jlurm4p0gj24rzrfv2O36ub97+jmgusEYzhX9Fm4jLk9XqMpel0Rqj30XPWkmcIB3On1ItPR64pQbfCjqkfgDjOQBPwCKfbHJlUgKu0AAAAASUVORK5CYII=", 50, 14},
    ["SA58 SPR"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABcElEQVR4nM3UsUtWYRQG8N+nF00RBYMiEqQlGhyanBqE/oKgIRpbm42GxmhxaW10yHBz6y8ImqNSQSlycBBKw9AvsePwvh9e3i/8vJLSAy/33HvPed7zPOe+txURGmASD/ALP2vPOySt2n0LK9jBwSn5R/AYb7HUpLGqFk9hsHi/ju28wRTmcKfJBjXs4AeGJKG/MSwZMpqvNyQDJvChB98QLuU4KixkwhmMFclfcsFVx26fFX159eNPjjtGVgX/OF714OsIaWO/yk22dYsgOQSHWMVe3nASl4vctu6J3sI13OzRVMmzJE3w9IiIlxGxEX/HWkQ8iYgrEaG2rtdy5iPibkTci4jlon60qDu3VWFDOgsTWdv3mjO3sVto78fzHL/Di1yzj2k8beTkP0KFTWn029Ih3JNEvNctYgCvcV9q/iG+XVCvJ6LCIt44/oWehDF8lUQ/8p+IIAk5bJC/hVk8k6ZW4gAf8RmfpM/tQnAEhj3qWWVxduQAAAAASUVORK5CYII=", 50, 9},
    ["SAIGA-12"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABfElEQVR4nMXUv2oUURTH8c+EYOJKrGysUuUFLBMtLERFrLS19gESS3uFPIJgqQ8QCEnURrBQQRD/gBBJNhERhYiiJgZyLO4I4+7szmRnwC9c7rl3fnfOOTP3nCwiNOAo5g55ZgrzeIPn2MbvIe+/gO/YxD18LRNmEXEJexXO9/Ekn/8yh7uYqRV+O5zCi7IHWdT/JV3cwXucxE0cbyW8agKvlX/wCXQOk8j/5hkelexPoDPesrNveIVMut/ruNKj2cU17Bhw3wfwSaqnUuokEvgoFVu3MK/gAaYL2jVcze3p3PECbhU0k3iHl7XCr0kWEXvYKgRZHN382aBm8Binc/u2lNwX/MABNnAEH3CicO4GFlvMg4iYiggjjGMRsRuJXxHRGaK9H/+yOqLPgWNM6tGjcE4qNFIR/hyiXetZn5FqqDXGGpy9WLCXK7SrPetJnG3gu48miZwv2CsV2i287dm73sB3H03a72UpmVmp7VaxhM94KHW7pw189/EHRhD21effCJUAAAAASUVORK5CYII=", 50, 12},
    ["SAIGA-12U"] = {"iVBORw0KGgoAAAANSUhEUgAAACUAAAAPCAYAAABjqQZTAAABX0lEQVR4nMXSu2tUURTF4e9egpo0ioiCqQwWlhYWtr5AqzSpBRvLFCnzN6RLZyeIYmOlkjQ2NgEVsdFYSEBiIahE8gB1cFl4xOt4YcaZkVmwOa+9Ob+9zqmSKNqPKYPrBjbxEht4g60eNccxiw/YwxO8lqRKcjXJZsavx0nUWMRNTA/h0ij0zE+HL1ZJ3uPomIH+UJX8/lRjVgd3cGDiH4q+YBuH0Fa3hpWSszMA1C7uoiPJfJKnLZ+uk+RsksNJTiS5kkSSW0m+tuSvlvOh49fkWssl95PMNpJnyjid5GFL/l6SyVFA1cW6usvK61jAK8yUqMrZO6y22D+J8wM8298qdLcbHX9LcrBHN6danEpxcCRO1bjU4FzD5x69rONtY/0R9/CgODaUJnAGRxp7K33WLmEfHuEFvg8L04S63LXXL9TyqCC6VeNCY/0Jz//XZf2qSnIacziHkzg2ViL8ABDnNNdpL/l3AAAAAElFTkSuQmCC", 37, 15},
    ["SAWED OFF"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABUElEQVR4nMXUsUocURTG8d/sJmgSCdjYqNgFwS5WEdKIYCGSerGxFfIOlnmAhLRrZSBYiKUPIEJCsBdhwWZ3s8JqCNkIyaS4MzBZTYaddZ0/XIY5994z3zf33BPFcawA01jGKtbwFJUiie6KBwOs3RbET2F+NHKKk2dkDhvCn1/Ek5ErGowz7PFvI4/xBq8NVzIxoiH2p3xDC18zo4l9fOZ2I0uo41lO8iZOko9kucRvdAUj6XPxP7m+o52I7SRCW0msg16OlhtGtvAW1b54D5/wKBnv8REP8SMRWypRpms9xxHGMvM/cYh3aOCXUGqnmTWzOB+10DzSE5nAB3+b6GAdX3AtlFwDF0LnamMymSud9ETq2Oybe4WDzPs4ZoTLWxHq/kq4K6UTxXFcw25f/BgvStBTmAoWhA6RZef+pQxHWlpVrKCGl0Kr7JYna3D+AF43ThjDJPReAAAAAElFTkSuQmCC", 50, 12},
    ["SCAR HAMR"] = {"iVBORw0KGgoAAAANSUhEUgAAADAAAAAPCAYAAACiLkz/AAABwUlEQVR4nLXWu2tUQRTH8U/i3WwiRMEougrWYiHYSFCxUCsrCyEW+hdY+ehFwUoUtLGzUiGIYKMQ0qS3igYUtQyCSrYJPsDIsZir3r3srvfuul8YmJkz58xv3iMiDJjORkRzCP9e6Xmd9uMG5xh2DuHfi591Gmc1g2/FKezFUbzANWzUjNONKSxgtY7TWETM5k5fCvVbcByHsQs70JJmvPkfxPbiEc7gBq5XcchwCZvwDuewZ1TqKjCDCZzH6y72fXiT579jMsMnXBixsDa2VWjXwGPpHJzsYj+Np3n+Gz7/HsAo+YhbGM877UUDz/yd4W5cwXqxItO59+EiVjCJ3X2CNaW9Op2XA1+lw1i83e7gZp84dVgvV2TYXCgv5R1GxYBzOIJXuIsH0i31pNBmagChlRnH/jy/gcuqiz+IQ3n+PV5KK1beJstDauxPRKxE4l6NF3AiIpZzv3ZENAq2VnSyMILX+k/KcF+6kh7WGPdVHJBWaw4/CrbyuZmVbqD24NPcmwy3a/o0JZGreIvFkv1EqTwtDXZpAH3/ZCyi6pbvygzWSnUtfCiU17B9mE76UfcvVKYsns7P2CLmh+yjL78Afadxcy8/WcUAAAAASUVORK5CYII=", 48, 15},
    ["SCAR PDW"] = {"iVBORw0KGgoAAAANSUhEUgAAACEAAAAPCAYAAABqQqYpAAABlklEQVR4nLXVu2tVQRAG8N+VaLgIEREVCx8xiq0g9ilSWYqWYiUINpJK8F8QxFYE0VYsBbUJEhQLwVgJAb2FYBExRMVXfHwW95xkvSbk3AN+MOzuzM63c2Z29kiihZxp6VfLxSRT9XqTdjjd0q/Ez3oy0tBhD6ZwCF9wAg9wt8XhixhFb0WTPr4lWazkUpWmg/k/eJtkNslMkgNJVjIxWgmcwjg6eFaNNXZiX4uvL9HFbhzGWbxYqxxdbK/mvUI/hmMtDn2DvcX6Nx5hDltxvJMkxYavOI/ba5BtxvKQATzGFeyvuOsgbpSbyiC+4ykm1yEcwU3M4gimC9IOPulna9Dn14ahVpdlIcnEEH2+q7hol5Ocq/T3Cv2PJNua8NXvxB282jDiVVyoxs9YwnP9y7xU7OnhQyO2KuprQ2ThaJLlyu/6gG26yMRSU876PdjR0GFLkrnqkPkkYwP2k/kb403L8RrvG5ZhAvNYwFV8HLA/Qdltk03L0UY6Sbrr2F4WmbjVhK/pv+Of2K32/SAe4h1mcL8J2R+bdL9CKghLtgAAAABJRU5ErkJggg==", 33, 15},
    ["SCAR SSR"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABYUlEQVR4nMXUPWhVQRAF4O89ryIEg+KDCApiY6eNYmNhChtTiGIhCKK1tZ2lpEgXxELETmwtxcJSsLEMgvaCPwHjT0TQ5FjcDVzk5b57JdEDwy675+zs7MyOJHra9b/Q9LH5JKO+ukp37MIULmMJr7Be9oZbOD+EQY97gUGSo/iBWy28YA+u9HXQgk94joeNtRuYxSU87nNYhUWca+G8xwXc7nNwB+zDafUjbuBIGa/i1Ca6dXzGbhzAClYqvGtx9g3X8KGIumINT7Df5HI6WPgDvC32FC8n+Kiwt2hVWG4hf8VxHMYq7qtreK7BWVX/nSZm1WXz75DkTsbjUZJqTIc4U/a/JDmfZEeSBw3dWpKT29zZxnatY3iDiyW2oTpdH/Hrj7h3YqHM76rTP43vDc5Pk8ti65HkWZJ7HSNfKK/+IslMY32U5ETDhv8jI2c7xjyFEV7jprqbbWBZ+1/bdvwGWBAPCE3D7DEAAAAASUVORK5CYII=", 50, 10},
    ["SCAR-H"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABn0lEQVR4nLXWy6uNURgG8J/dcok4TlFy6nAyEAMyMZBLRjIgAwORDOQfMDFSyh9AiZm5YkqSsZJ/QGfiILl0ctsR59hnGayl9t59e5/v5qm33rXW+6yeZ31va31ijGrGZIzxVAP+qNgZY7xVlddRHzM40IA/DotVCaFC7XpM4wT2YRMOYz9eYkWOUVgas/aPuxL38K6CLiQj5/AT3b75dTiEg5jKoteM2ONIjrawBzvQw82ypIDj2Iw5HMO2FkXVQcQELmBLwfqMZLIr6f+GhYAP0lf533iEo/hlsAUX8SfnAQ9wH/N4XbDPbqzC91wf0Qv4NFT4W2q1jnQyRejhLbaXNPEEF6VDa4qnRZMBC33jJanfnxtvJOIr7uAMNuAxZvP8NYOn/lk7JkYiGOzDu5IJkqkvy/CnMJnz63iB1biCtX11s42VLoMO9uZ8HlcrcM/iZM4vSf08IV3Tb4Zq5+pLLIcgGeniMj6W5E3jds6f4aHB1um1JbAsArbW4N3ARukGOo/3LWqqhSovez9OY5f0qr8qWP8xNG7yK1QKfwGUvd7WolZqhgAAAABJRU5ErkJggg==", 50, 13},
    ["SCAR-L"] = {"iVBORw0KGgoAAAANSUhEUgAAAC4AAAAPCAYAAACbSf2kAAABqklEQVR4nMXUz4uNYRQH8M+9c2nUqAmNKUwoC2LNcoosbaSkLFDKTrIVZSt7Cysb6f4DGhvJgpqyUCSKhs0ls/FjTDOOxfvI4/KO973v3HzrWbznfL9P33Oe8x4RYcBzsoG27FyPiF1VuG2D41gD7UpYqkLq1Lx0Cw5hEgfxAN2ad5Shh7V4XYXciogDmMOXLL4xGduPzdmZVL/YqniOz5jH6eSpFK2I6GId3uJoMv0/MIdlbMeF5CfHuKJ5b7DQUTzRuSGbeojWPzif8EIxLuuxsy8/jglso3j23qpa/BP3cA27sbgC7yNuV720o5irn/iOE3iJDdhRovuKKVxOZkbxLuWm+rhHEv9uVVOVEBFX4he6NXbuWKa7FBGnUvxOFl+KiE1D2Pfa2JN18WKNms9nuvd4opjL+YzTw4dGnS1DRDxL3blao+J9EfEt6W715c5mHV+MiPYwOi4izkTE8YgYrShaExGzydirv+gOx+/YOwzjHdys+UhbMYsx3MBCX/6RYh+PpO9pPB18JkrQsPKRkvjjrON1fvhaHW+C5ZL4jGJN3rfaazDhB3/ZCvQhZGtMAAAAAElFTkSuQmCC", 46, 15},
    ["SERBU SHOTGUN"] = {"iVBORw0KGgoAAAANSUhEUgAAACUAAAAPCAYAAABjqQZTAAABa0lEQVR4nMXVsUpcQRTG8d/qriIhIb6AiFpIXiBFqqQ0YOFaBLSIrV1IEyzS2Nulj2lShVQKWogvIFgoKlFIwIAIKYIgJGomxZ2L191xV1x294NTzJk5M/975py5pRCCJirhGaZQxSAuo1XQi7/4h/5C3CccN9s8eWACqoQneICXmMXIfTa/r8o14xFMYAZPI2A79QuH8awz7GFbCCG3UgjhQwjhKnRP+yGEG9dXwZ8OZKeRDjBevL4LLON1YvEmPuJnHFcxJyv+/Zq1g9F+4FsDgFf4jAWsy5rknJs1NYAXieDfeCvrsJ3o28ERVhsc2kzf45672CpOFKHeYygRvILHGHPd8o+w1AIQDKMPo7UTOdQbvEsErmFelq2NFiHurDKmpb96FZO46hRMrh5Z0aa0rAtAZFDPE/6v0dqp/C2qe4J6cFLjO5W1+0WboXKYuv9cGV/wsOBblBV2u3VrpsoRYrEDELepLlP/AXEf0pvsdGTCAAAAAElFTkSuQmCC", 37, 15},
    ["SFG 50"] = {"iVBORw0KGgoAAAANSUhEUgAAACUAAAAPCAYAAABjqQZTAAABpklEQVR4nMXUO2tVQRwE8N+9RCW+go0EG42IoJggCGJlo42lKIJgZRG/g7WFrU2QdBYKCvkKolWKIPgmiiCIgsYHJhqieTgWeySHkMTc61UH/rB79szu7OzuSOIf1ekUHP7dv106jxvowiw+YBxT2FWNH0Q/FrAdB7C34sClRpJOi/qGDX/AH/wbTl1FN77gLY5iBM+wWXHtHD7jOQawH+vRwJtGkuPVZKOY7rDAflypRDbxSXFyKyZwdjlSI4vn9xRPOiyqR7kzG6v+NKI40o2XuI0XeIBNmK2L+t84hm1I/U79qLWbVb+5hBg8Ul7NDPrWsNgEvq4yPorXinsL+C6LGKlVktxN8r5qzyW5nmQgyY4k40l6ktzP6hhLsqfVTKuLulWrX5hJMpRkd420LsnJqr0zybsVBL1K0tuqoKWiblaVJJNJLq9x0tGK8zDJYO37vnYEZUmin1Gy4yKGMLmG+3IeRzCvvKJ5HMKckkftoXZMg0lOtLCjviRTFf9Ou66s5NSwEmjDLeyliWvYogTiqbZdWQZduNAGrxePlWS+h4+dFPUTOhukC3UWCCwAAAAASUVORK5CYII=", 37, 15},
    ["SKORPION"] = {"iVBORw0KGgoAAAANSUhEUgAAABgAAAAPCAYAAAD+pA/bAAABlklEQVR4nK3T32vOURwH8Nfz9PjVYhsz2YW4kJpyQ24oRSm5IJJ7Lmn8BWp/AuVGspuVWlzwD7g1saQIe8wdhYsRGxveLr7f6buHPdvkXafOOe/P+bzP5/05p5bkME6jH1OYRTceYxpf0Yk6Pld4+IQVOIoxNHEDr0peAycwjuOYxFbUsNfy8BSvcRVHsBP9tSTj5Y02LDPhQpjGfaxGVx2X8Og/JYe3GMYQxuq4idF/SDSFAfRiPToU1g7jFkbQbKAHp1oOf1c0cw2+KHo1g7Ulfx7X8W0B4W6FVSQ5mT9xL8lAkt4kfUm2JRms8GeTWGBsTHI5yZUkmxu4g4fYU7nFT7zAu3Ldh+cVflcb697jwtyiXtrR/ItFz0qLehA8qPAH2gjMR5KVSSYr5Y8m6UjSWdqzqlL+RCVuRxubfo869it+6hyGFI39iDfmN3KkMj+3lALqONiyN9Mm/hp+lPMz2LQUgd0te11t4idwu5x3YHApAtuXIUDx82fxAXcXE6glOYYtOIR1uIgni5zbh5eKJ9kWvwDzG+/7GHEBdAAAAABJRU5ErkJggg==", 24, 15},
    ["SKS"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABgklEQVR4nL3UOWtUURgG4GeSIRFX0ESIEYKgIAjaxs4irQiKtYWW9v4GO/+AiJ2FIKQLWhg7BSEIiqQQmyioEEHRmMXX4h7JNcxM7iAzL3yc5duXc1pJ9IE9ONNQ9gDWcB6jOIzpGr+Fb1jGhy42XuLdLn7u41q7YVBj2IezeNpQB9YRjOMtNnFIFfhJvMINPOugO44V3N0lrhnMtZK8x1YXwdWynsLBPhLoB79wp8P9SPH5tYfuDE5joY0j2FCNwt8ObRUDT8q5jaOYKufv+Kkajf2F96XwJmqOPquqv9whiDW8KTTfI9hmSLKU5HGS1WzjdRI7aCzJo8KfT3Kl3B8v694kE0k2anZud7AzEBrBOcyp2vgQN3G9Q87rWCz7T1jCpKoz8EPVlRc1nUv/XemmSPI7yYMkJxpkvlgqfbmHzK38i9lhdESSYw2Fp7I9fpM95KaTbNYSuTes0er2h+/ER9Vjv6h6xN2wgoXaeVb1TQ4WA6rQhSTPk1xNMjqMjvwBBYyqLfSB7OsAAAAASUVORK5CYII=", 50, 10},
    ["SL-8"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB3ElEQVR4nMXWy4uPYRQH8M9vZhiNS64xIbGQrYWdlQWbsWQlGitlx5pi5w9gJVtSJHJdKUlsKLeiiKQRi5lcG8bX4n0nPz/v7zc/84Zvnd73ec45z/c5zznPpZHENDEXO/AY16c7yBRYh1tYiI4T7atBcqckeoMb6ME4FjfZfGr6LkKjqT3QBccKzMcQLnQybJQZmYUvTf3zm0hb8QHbcQIzK/SP8Ln8n8BJzMBSfCv7j2IDzuAl3uI9PpYyWvJMtuE+LnUK5DA2+7U89pXkVbiL9e0G7IBRP8tjDP0Y/AP/F9jUTtlI8grLpzGx/4F7eFel6FOk9l8E8hgPurQdUJRnFHtvHtbgCE5VeiS5lu6xM8mCUrYk+Vr2jyV5mORcks8tPhNJdiXpSaKGrErS204vyZUug5hIMqfJuTfJ6yTfkwwlWVn2j7T4na8ZQFfSp/2mhrOKk2UmhhU1+rzUDZZyHA+xTHHS7cF+bCzt+rssp3pIcrNNBg5URL41RQlNYjzJ6gq7Y002I/8iI40kB/2+2W8r7okq9CqycwhXsbvCZrjFfy2e1lvyKVBjFWYnWdJGt6Ylu3v/dkZ6aqzBR8WNXIVneNLU3laDpyvUeWtNhYuKV8BpXP6LPOAHvHrfSg5u5VkAAAAASUVORK5CYII=", 50, 14},
    ["SLEDGE HAMMER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAAAg0lEQVR4nN3UMQrCUBCE4S8xRQQbG88gBIxXzpE8h2KVIij40qRInoiFSnz5u2GWZRdmNwshSJADTiN9zeea5EPKWKe6yBMFapxxwW3ecV6ywQ7bQe8jP8/C747kjvYLfUqs3xUtKlpH6UWrQjPyu8L0jf0rrWlMV5H/WEy0Ul2ki3UPNEUZDinIJnkAAAAASUVORK5CYII=", 50, 10},
    ["SPAS-12"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABsElEQVR4nM3Wv29OURjA8c+9bkUUlTZq0DYsGEQkYmPBQBphE6PB4A8wicFgEpEY+AcMto4kGKwGiRgIEVRCIhHeolI/cg3PaXLcVnvf0ni/yc055znnPuf5cc5zb1HXtRYMYzw9w3iMGjsxkeRvcCKt/4JvDR23cbzNZkuhWmBulzDwCPagTPKX+CQc2YCtqV2BH3iI3ehv6Fvzj2xeiTO4kAuLlJF+DGFHMnwco/MomcKzhmwQW/6waY2n+IzvqW3DvbS+SYmNOI2LskQUdV2P4YqI4kjLjZabacwssmatzJEKB3F0GY1aCh/QQR/eWziTE7ha4WsXG7xrKB3E+tSfSfN9WIfVXehtsgmTomB8NLdw5EwTR2sI13Eom3yOS7iR2pMiSiOzLyYqURQOiPswlRw5jP14gSI9P0VBIC7saDYmCsVk6tfYh7eL+xwUWfl9hbHUv4nzuI+zGMAt3G2pdxte+93pJgPYKy5wBw+0LwZzmHXkmDhrRFS3i6OxCk9ENHuaShh8OZOd00VKe4VSGL45jTu49t+s+QtKnMrGd8z/Iep5SjzKxq1+vHqRXyITY0mbtafdAAAAAElFTkSuQmCC", 50, 13},
    ["SR-3M"] = {"iVBORw0KGgoAAAANSUhEUgAAACgAAAAPCAYAAACWV43jAAACMElEQVR4nL3WwYtVVRwH8M+b3pRlMhJikSJOk9BGCyqqjTBh5DJctAna9gfkMgKxNpIrdy4EoSBa5SYrFKrFqKCCpjAUgSSCzgxB4TTjgPNtcc+budx5781zHvSFy/2d3/mec7/nnN/vd64k/qfn4yTfJpkYgPt9x24bDk/hEP7GdizgIcbwFzZhFLN4B+/iDZzuM+f9Mg60kmxU3Gb8gWcH5C/gyQG5c/gUv21E4DhexXHsetTBA2IZl/GwleQSHisdS5gvIuYwgy14pjzwHBsKjWWM1NpLqhOYw108wAdoFf9bmG1jB14rIp8og7/BFZzCP6rjPIh9eK+HwBs4iWnsxyeN/nnVYi/gS3ytitM6XlbF7EequCXJz40M2p5kOsmxJM8nOVHah5PsT7IvybYku5OczSrOJXkpydNJ3s5aHClz98vehcId7fhGVpSuYgYX8T5+ws2yc1/gF1wvx3ILL5Yxi2Xn7mEr/rU2U3eUuXthp9UTnFjxJrleW8HWJEeT3Csr3tRntbtru/NVo+/xJHuSLNY4P66ze+M17t56HdyDz8r7dVUcTajqUT8cqNk3Gn1L+B1TmCy+F9aZryvaRdwdnMeHqmwaBBM1+9cenJsNgWOqot4NrW52G58PKKiJ5Zp9uwfnauOjb+KHHtx0s4e56k6pysYWVQnphqlGe1JvgQ+s1srFjnOYq25Q3FZlKFzDK324u1QCb3Ucw/4sDIIzqgQ8i+/W4f7ZdPwH4dnnxjgQtLwAAAAASUVORK5CYII=", 40, 15},
    ["STEVENS DB"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABAElEQVR4nNXUuUpFMRDG8d/hxqUSQQSxtFK0sBDfQCx8CQsLn8DeJ/CCjY2dtWBhY2+njyCC4L4X1xWNxYlwcUHPuYv4h5DJZGbyDQnJYoxKMolhTCU7lC3UBEKZw6cxjxl0NCjgEuvYabCO7Isb6UN/3RhADzawgNkU94yzJOQw+Wp4QiXlvPOI8xR/muyLVKMpZDHGOUxgFGPo/SFnD4vYTcJu0Zma+DOyGOMDun4Zf4cRHMgbruAV1y1RV4Agf6eD3+y/YDPN49iWNwE3LdZWiIAjnxupYRVV7Cdfhu62KStIwHHd+gTLWMHVh9iI+zbpKkzAFoawhDX5D/PveAOhkDzBunVvSAAAAABJRU5ErkJggg==", 50, 9},
    ["STEYR SCOUT"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABPklEQVR4nL3UTUtXQRTH8c/FW6grlQSNwP+mjdTCTYsWvQBB8E0IrnwvbVu1THAZBb4DF7WqFtEmKhLEh/AhSuvXYiYwyf7Xh/zCcC8zc875nTNzpkniggzgNm7iFl7iU11rcB9D+Invdf5atTvCYZ0bqt8ZvMBrvKt7+tKihxvYqcFOcogPp9hfx1tMdQl2DnaxeoquP0nyJP35nGQpyUASSXpJVpK872B7UdaTDNe4fxtNktEWYx0qM4GHWMArzGOwrh1hCz8w2a9uysnDl1rp3epjTzn9A3xTruF+9d308bndYqRDIr+5U0fwGNtKYsvKHb+HrzWp/Sp685j4/0aL0XPYLeJR/e9hWqnss8uRdXaaJBtKs8Nz5cU53lx7SjM/wDieYu4qRXahxRvcxRpm/7G3UZ7Zj1eg68z8AnHM/AdN6FVoAAAAAElFTkSuQmCC", 50, 8},
    ["STICK GRENADE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAAAlUlEQVR4nN3VTQ5BMRSG4edKzcTE1MwQWxFbuCuUWAGbEBOxDULUoBWGJW403kl/0q85X9tz2sQYVcoSLc4Fa/chd/q4ohZXk9wuSgUBG8wk5yfccMQuj7tgjCmGL3MNRtKhBmU38RTHit/WO/R+HcC3+BsjAVv15sigdMMmp0iNVWuOVangUX4vnYTzOQfJyFrhP3IH6RImezn8IfwAAAAASUVORK5CYII=", 50, 9},
    ["STREITER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAADCAYAAADRGVy5AAAAf0lEQVR4nM3QMQ5BYRSE0XMlGlahVIhGp7AMicJ2rEGlsQeNNdgHUT1eCImr+AsUEtWLr5tkMpmZyMwV5l4k4k0HDqh9csMWPezRwQNXjNHWDBUWkZkDTHD+YmzhiClmWGKEIU4NFIWLctBd6VkrAzZYo4rM/DWsix36yvN/xRNzkSJRssjMKwAAAABJRU5ErkJggg==", 50, 3},
    ["STYLIS BRUSH"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAADCAYAAADRGVy5AAAAlUlEQVR4nKXSTQrCMBCG4adaf0AQqUtv4MITufQuXsiDeABXLgXrpohgS1w0BYUW1L4wTCYZMt9MkoQQRCbIsIx+7H8CjrhihDUWyONejscP9+2wxyXGczxRRT9IcY7CZz2Ed1FgirTl7O6zsWZ9a8ndqIdTIlE30MQlVkkIYevzJRprK96H6k1wgWFH3Uz9O77lhMMLwL0nKYwtr4kAAAAASUVORK5CYII=", 50, 3},
    ["SVK12E"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAAB2ElEQVR4nLXUz4tNYRgH8M8dd0T5kR9l0k2xsUFpLNiRKcVGahb+grG0uwv/gS1LCzZENuxETSxGIhkWbDBK8mP8aOZeEuOxeM/pHsfBvebeb729532e57zv831+1SJCH7AT97EXN/txYa+o92g/jia+4hum8AN5NA7hAL6jge3YjBra2LR4l6vRK5EGRgvn3ViQHIdjGMaSbC+ifO4reiXyGZfxBk+wKlvns30OE5jGSykjWyViG7FDh3SONl50+f44VuNMWVHHmuy7gaUl/YxUOrJ9HPsrHmh26ch0hewT3ma+tDCPizhVYbsBX6ourkvRWNmlI3P4+AfdCv9XPrM4qxOwtTgqZWq+ZLtPIrK+IHuF2boUjZxISI28LLvkeaYn9cIenQzm8paUzSKJBUxmsmL5Vo3IdwUS8AFXcBB3S7ZtjGBLQVbDsIiYioTJiGhGxK6IGIuIdRGhtC5EBxMRcTiTX49f0ar4d6ArzwjcwDm8rohaMdKk8prB+yw6VzFWsFueZaLc2APDkDSBcvyNRF1KN9zGNdzDM5yWmrZ470jfvOwCQzguNdjJf9iO6vTHg5Iu8LQk27ZI33pCXZoClSOthMc4gSO4VaG/hDt4iEd+JztQ/AR21QEhh3ph1gAAAABJRU5ErkJggg==", 50, 12},
    ["TACTICAL SPATULA"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAALCAYAAAA9St7UAAABEklEQVR4nM2UIUtDURiGn3tdmwpb9F+MBcFgENP8B6bJgliMVsEg2FwXxGAUNgWzCGsyi8F1xeDAPEGfhSsynWI491x84JTvHN6P93znPahEWhtqorbVirqt1tVltaVW1UN1Rh0YxkksE5sfDc7VJ7Wn3qn36pX6rJ6pr+qpOgowMVBnE5WcWQM6QClv4R8YAUtAvwQsAgvABbAKzAUIzwNtijEBsAP0AVAP1Jp6rL4HjLhoumYZRCUFXoBb4AZICrrJUB6AFvCZixSoADWgPrnxj3kD1oHhZDFRY2SkHKDxF7vA3vdijF+rAXSJE/hrYIVsKl9IIzS7BLYi6A7JntSUCYhjBOAI2M9RT6AJPP52YAxkSz5bbrNGwQAAAABJRU5ErkJggg==", 50, 11},
    ["TANZANITE BLADE-ALT"] = {"iVBORw0KGgoAAAANSUhEUgAAAA4AAAAPCAYAAADUFP50AAAA3ElEQVR4nI3Pr0pEQRTH8YNJQYNYLItpg6CIPoBgEowW9xXsvoDdps0XEJNi9CX8gwhbZDEYbxJsH8u5ODvuZe8XDsww5zvn/ALRsxZxK+krLeNSQR9pBeemGc+TlnBWSa9YnyeeVtITthFl0xB7xX1USS/Yb9/bpgFu8IgtnKAppHccldu0h4Oi6QGT4j7BcR2jnljT5PR/+euM95U4miUhFuKPjYjYjGkOo4v8YRfjnHKB5zz/4Kpr1Td8ZOM11nLtr6xhl9hyh9XicZDVmXEnt/6OiKZI8Zk1k18tZmJJn30IFwAAAABJRU5ErkJggg==", 14, 15},
    ["TANZANITE BLADE"] = {"iVBORw0KGgoAAAANSUhEUgAAACEAAAAPCAYAAABqQqYpAAABRElEQVR4nM2UTSvEURTGfzNMmoVmYWWHFbJQklJeNpKVjbIijRIbKwv5DMrnICu7YYG1svK6kZHERkmZovGzmP80L6W5i5nhqdM5t845Pfee5x5UAiylZtQxdU+dDawLslZqIwVkgBFgCogBZwF1wYgH5PQAvVEcA3LASbNJXFB58yQwX08Sxbn0qwu/zGxU/bSED7VHnVOH1HF1Ru1TF9VOdV1tVzfVNnVLTaobaoe6EvVApUjgWc2r6ag4rSbUVbVFPbAST+qX+qq+qzn1JerxGOU81PBZtbtI4riseV69juLLKt8I3KtdMXUQOKcgur/AaRzYKSPwDdxE8VWVbwSywBIWBFWtiWULmlizSZr4F7+jliXUo6qX2A6oC7aQZTUADJedc8BuPYURQuKOklilsDEnm03iDZgGDoEJYB+4rSeJH3i4Mu/3nJ3cAAAAAElFTkSuQmCC", 33, 15},
    ["TANZANITE PICK-ALT"] = {"iVBORw0KGgoAAAANSUhEUgAAAA8AAAAPCAYAAAA71pVKAAAA5klEQVR4nJWRMUpDQRCGv1zCE1ilSSOYPq0oCM8DeA8rz5BKvEkuIA/SpIwWQhqbR0Ah6T6beTiu+546MDDD7Lf/vzsTlYFYAh1wN3QANedK7SKP6iHqh+IcKpNCuQXOKhofwFvUr8CipjxTnxyP5yFlgDlwkvor4Db1L8BpTbnMRl0Xyu/9H4yBN2obwFp9TBd0Y3CTwDb6ywQf1PsaeJ2stuGAAj6qyxK8UDfJapNmGf5he6FuY7gJB3k+92uN3+BzdReDbTioPWkWT1n18FTdB7gLB7+tkB7uYx8O/gSW8PQ/oMonaJhuTL57J60AAAAASUVORK5CYII=", 15, 15},
    ["TANZANITE PICK"] = {"iVBORw0KGgoAAAANSUhEUgAAABEAAAAPCAYAAAACsSQRAAAA40lEQVR4nK3TMUpDYRAE4O/FB4EgFuIJBEVBUEirlnoGT+CVtBObdDZaxFpvoJ1oJWJlIWIjOBZ5D2JI8T/IwMI//8CyO8NKorCGSa6TDGa10gZLSZ4ywTjJWpLdVu8pwy8emvcxnnHaiqVNKnxN8RUMmv/idSSpk1zlP066eNJWP8lt0+AnyV4SNTZwjje8Ygt9PGIV63jBB3aQZqUaYxxUSe6wX+jNPNxXSTZx1mGSyiQheMfhQjwpjbj1YISjKb6N4nR6SS5n4r1IUnWZJFie4p/41ia1iNvpYuowyU3mXPEftSjMQJ/z9ZcAAAAASUVORK5CYII=", 17, 15},
    ["TAR-21"] = {"iVBORw0KGgoAAAANSUhEUgAAACcAAAAPCAYAAABnXNZuAAAB9ElEQVR4nK2WTWsUQRCGn9kPhCgRTNQoiAgGzGEPBhERPAfEH6DgzT/hRW+C/oTgSRBFkOBB0IOBHAUVA3tYBDUHUWNEWTWGDSZ5PEwFx2V2Zz/yQlPdVdVdL2/1NJOo9IkaUO93Uw5OAq+7JVT6PHAE2B92HagCAglQipzNsKXwt6+3Yk8NWIx5LhJ1EpgH9hQQ2wTGogCk6p0IgnnYAr4Cv3Nio8A4MAm87VSwAtwBjhQQy0Mt7BdgCWiRqgkwQ6rUQaAZBH8BH0mVOgrsA451I5eoLWDXAOS28Qf4AWzwr8UTPe5dBtbaOZESJ1GbwN4hyA2DU8D7HH8J0ra26J/cQ2A2s54GbsW8TtrqaUKBDvgAvOpWZJtcP1gF7gHPMr7dYdeC1AZwGnhOqsxLYAVoAN+BMnC8sJLa8H+8U5sx/6SuZ2J19Zw6pRKjor6J+BU1Cf+U+kgtZ3L7GqiLmeINdUI9oN5Ux9S5TPxFziHnI7YcRFGr6pM4ayBiKhXSuzIO/AQeA99C1KthVzJCH84R/3LYB9FOgOvAbdKvcWBUgPsFOUtt5A4BnzO+EdIH926sz0TOtWGIAfQi79m2O3mpLV5WL6o31Bl1Xh0dpp3ZO1c0qupqhtxsh7wk7t+FnSCmktjbX8kc6XOxADyl4G9ip/AXghhMT6fnhg4AAAAASUVORK5CYII=", 39, 15},
    ["TEC-9"] = {"iVBORw0KGgoAAAANSUhEUgAAABsAAAAPCAYAAAAVk7TYAAABLElEQVR4nLXUvy5EURAG8N+yJIhGgo7YSkOCR1BIFGg0Qq33AuIF1AqtSiFR2HcgKiQKjYRi240/iZUdzb3J3Ws37rK+ZJKZc7453zkzk1OKCJjCAUa0xweeMvE4ZnCJITTw2Savgn7s47aUiO3iqINQL/CCal8SrP2jEAygUk6Cxh8Pe8VF4g9qbUcdx6imYpdY/6XQAzZw9yMzIlI7jVbUI2I4s59aM8fbacNpa30Z3dHcPc7wVuBlzaIlSMUmsJzbOyl6SFGkPdvK+FDDGDZ7qpbU8yrXh8MOdR+KiL2IqGW4K0V7JiJm4zuWOiSUEsHHDHehmwHZzj32HtedCoF3WgarqwFZza31fDBSlLGIacxjDucF8koZP4qKpR9xN+jHMyaTeB43RRK/AHQWNXJ8THmUAAAAAElFTkSuQmCC", 27, 15},
    ["TOMAHAWK"] = {"iVBORw0KGgoAAAANSUhEUgAAAB4AAAAPCAYAAADzun+cAAABBUlEQVR4nL3VTyuEURTH8c+MZ6LGiMlKkmIhmXdgKbGQBcnCSnk1rL0FC3kTY6GsLa2lNJspGgzH4t5iMTWJeX51O+d26nzvuef+qUSEErWHK6iUDL7HOh6rJUKbWMIRlAluZbtVNriZ7Srl9ngWT9mvFxjDGZZRQYEPvKOW42/ZyvF2TtLAGm6GQMdx/GPeqETEJfb/WM1vtVhIq21hTqq4ik/0sz+BF6niAoFrdDEp9ex2CKiGTXRyvtcCPaz8az2DtY0TzOC5wHkJUJjHg7STvbKu0w5OMS0dyL6IGNWoR8RBRLTjW52I6EbE1CjBGxFxF4O1O+oHpCqd5kPpc1iQenzxBbos7//aspntAAAAAElFTkSuQmCC", 30, 15},
    ["TOMMY GUN"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAACJUlEQVR4nMXVO2iUQRAH8F9CIDFGjBEVbMTCF4gWPgorDUIQGysRtLGRFDYKEhAEK1EQIoKCiNgIIgoWioXRWFlE0NiIT3yALyQEY2KMmjgW3164HF8ud2fhHwZmd3Zm57WzdRGhRvRhY+IDK/ASHWjFlVoN14DDdTUGchRHUF+09wUjaE77I1XafIAx/Ek0kYgsURMYx+8c3c6GKi8roM3UIGBhouJ1HkaKnGlGY+JvYFQWxHjam4V5+CwLckI+LlUSSBs2YzVuYS2W55wbw0fMxqIy9prQkvhuPEv8CVlLDuAmdqR1AaNYV3R+KiKilOZExPaIOBkRjyJiIirDxaRfFxEXcuSfIuJpyV5H0b19EXE8Iuam9cGSs505vk5Sg6x8m9COLdiAalruA3rQVcgNfpac2Sar1gDeTWN/K4YT34bdJfK75ZxowBMsrdRrfMVt3EMvXpTIF2NP0foVfmEIq/AGy3LsFoJoTbbXpPV77JIlbHpExPMKW6c/InZGRGO5EkfE5SKd1xHRUiLvnqa1CnSqSD4aEQdmuG+ytX7MUIFhHMJ52UQph/UpewV0qX4MLynkWPYXdVeiVC97I9OhV1bic2YOgmw8Fj6mh7hfiRMlOCObgI+xt1KleszP2R/CftkDfFuFE/3Yh2+4Lnvg1eIOVuKsaoZOTB2v3yPidEQsqKQvy1BTojzZsYgYTNT+j/dMUl1E9KSYruEqBmvI4n/HXywSWo5LRNnyAAAAAElFTkSuQmCC", 50, 13},
    ["TOY GUN"] = {"iVBORw0KGgoAAAANSUhEUgAAACAAAAAPCAYAAACFgM0XAAABpklEQVR4nL2VvUpcURSFv3EUB3SCNmqllTYW5g1CClstYhNEBoKFVtpEA5oHkITkKawstEmXwgSClURFAwmMQgIWEiJG0IyKn8U9g3fM9Tri6IIDh3X32T/r7H0uKjVYPepU2OfVZ9WevWvgZnVe/aOeqDvqZ7XzvhPIqWPqhnqg7qo/vURBzaqP1ZlaJpBXX6o/QuDTWNDvVuKfeh72k7VIIBMLsuz/OFV/J/BlvA+qVPit42bUA8PAOtATuCxwlmD3K8XPJLAINFewKRXn1HF1+5pqd65wJ+pmigJlLMeVyKgAXUB3yKkb6AMGgY6ESgQywCfgCVAC/gYFWm/UM8IrYC6uwEIVme8azXqXuqUeqmtGzWjYf1Rn1dEYn4SS2mdowg51NcW4aDRyOS+vZ+SKzZ7aojaog8GmYPRGlK7xu642on5NMXhuQueGQB/UYbXJqGLUdrVXbVP7AzedUtxcRn0BDAHvgG/AMbBf5V2WkQeehn4QOARWwre64Hsi4dxRuQnvG1mgSNTscby967/gNmsgJv25+sbYGD4UloBHwGvgC8AFDJdenNPvBQ8AAAAASUVORK5CYII=", 32, 15},
    ["TRENCH KNIFE"] = {"iVBORw0KGgoAAAANSUhEUgAAACwAAAAPCAYAAACfvC2ZAAABoUlEQVR4nMXVvWtUQRTG4WcXDUSM6dQQKxEFK9FC0ogGRawtLARB0CJgs0Uq/wFBsLHQzo8igoWFpaKFjVVSiChaxELED9AgSr5QX4u7C7MGdtXd1R8M3JeZOfe9Z86cW0uiA1OYwBCu4gXOYwMe4XqnzYNg3S96L85iBTPYjlOo4xaCBt5iGkfxGLvwpLlvsCRpja1JbiYZTjKe5HWSk8X8TJKLhd6SZC7JjSRTSW4n2VnMD2TUC++HcA1LeIO7WC3mv2G20BuxgNO4ojqZc4NMLu0lMYpaoZ9rN/wdc4Xeg0v40dSfMdx/i+2UGR7F/kK/0/4Bm/Gl0AfxrNDrsanP/tZQZngS+zCvymYDixjDbhzDHVzGDpzBuOpyruDEvzBca7a1STzoQ7yXqm5ywN+bX8Jy8/kjnqpK8SGWa0kuNF8w0ZvXgfMejbqqNkf+s5nfYQRjrZI4jPt9CPoK93BEdWE7/ka7sICvqm41q2qzH1qGh7CtJ6vVSU3jeI9xOtLqEquq7tAL8/jUY4yu1Lsv+SNq3Zf0Rr8NL/Y53hp+AosL2uQMlUOhAAAAAElFTkSuQmCC", 44, 15},
    ["TRENCH MACE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAABZ0lEQVR4nN2WMUvEQBCFv7sEDhuxtRHBzsI7uEpIp4WlgnZ2ooWFxWHvPxDxF4idCoI/wsZCgyDnoaWlYKGggnfPYvdgEzYa8DaFD5bkvZ3ZmWFnN0ESFYwFSc2c1snxuqSdnLYiabpMjDrVYA5o5bQ1YMzhM0BSws+Lqgpp2jFEZPnsDzZFmhfxX7L7BVPAkn1vAW/AluUNzG6sA22rJcCkYwOm0HFHOwNefMFqkkaUd3Zd4AHTLqPEBbDsm4iBTWAeGJDdob59Ro72hWnHYUvK2kWY5LHrDBh9EQATRRM1BdqSQHgFroB7TKt+Aj2gW9VhD44Yc5BCtNZGgHyvgUXfxL857KEKgez1u43p6WPLG8AhcAB0rZbYJHedNTrAE3BqeeH1W8XvCZKOJO07PJL0LqntaKuSejm/c0l7ZWKE/CC6uAWeHd4HUuAuZ3Pj8UvLBKiqkJRsIQAnwIfDH4FLj19aJsA3/5h5NAUQJ9wAAAAASUVORK5CYII=", 50, 14},
    ["TRG-42"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABGElEQVR4nM3TvS5EURDA8d9lKSQSlY6EkkbpBbQiEQWJmkajIVFphCfQSLyGTqIRhcRHoyQKIhIJ62sTRnFPsVjZ3btb+CeTe87MnDkzc+eICC1IKSLmfuimWoxZSLKIUJAhLGAROygjMIlLbCe/F7xjGKPJJ0vfc5wUTaCaLCKWUUrBB9CPCp5xgQMcV50ZxCw223D/G17bEIeoz2dEjKVfuNKAfzNsFBmjWlJqoNayfFQmsJ50V9jHNaYxUuNcBTf4wEPSPaZ9GT04Ldj/XzRSSG9KqBsd8lHbTcmcJdsabtP6LtkPU9J/0VnH3hRZxLfXvoentO7DuLyQalax1a4E2kUJR/LuZJjHfZW9CzNYkhdF3vV/xxeS+4V6sDXUbAAAAABJRU5ErkJggg==", 50, 8},
    ["TYPE 88"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABUklEQVR4nK3TsWtUQRDH8c9dDi+agCKS4sQINnZWYm8n2pgyTQJ2afKnBNJaKf4HSgpJI2KpcqggmoBFOC+EVL4mMTFjsXv4PI0ne/eFZWfn7fx25g3TiAhjcCuvGVSYRQPHOMLZfO8QF3ADbbTwGlNDej3sZruNc3ic4wfcxzWs1QMbYxSyjtXSYOz7s5BtvMBJPs9jBw8xSPQmrmAPB1mn3ypI4C42CuKGufQXXwcX8SOfD7Eidf2z1KF5qdBKKuQV5hoR8civdv4Pt3E92+dr/i/oZnuh5j/Oj37L56t57+PrkPYnqQN1WriMxX9mFRFLEaFgnYmIKhK9iHiQfZ2I+BCT5emofJrScJYwi+lsL+OZNPRHeFKoeRrdURdKZmTAnRxf4SW+1769xZsxtId5PupCC+8Lxe/lfdPvRQx8m4W6RTSlv1fCFj7i3eTSKecnEwDv8Lz2H3MAAAAASUVORK5CYII=", 50, 9},
    ["UKULELE"] = {"iVBORw0KGgoAAAANSUhEUgAAACsAAAAPCAYAAAB9YDbgAAABO0lEQVR4nNWWvUqDMRiFn2or/lGLmy7iLtLN0QsQr8DZW3Cou5MK3oGboqvFC1AER0FadHHoIKKIVUv9KT4OXwpdLBYjbQ8EzpuEcHJySIJKaHn1UH0xwYN6oC62zOlqa5Ilte7P2FMnuy02pU4BZWCC9rgHdoBrYBZYBhaAV2AfWAv8/6ButHG0E5yomQgODqoFdb2Fb6rDqBeRxKquRhCbVcvqlZoLJtyqMyn1HRiKdFBnwDZQDXUN+AAEnkLfG1APvAp8BT4ArAAFYBzIAhlgJIwXU6qRhP4FnySbGmsz56ZXxP4GjYFuKwhokESmHSppEvtjZnYLeA51M7OQZFY6y2waGA3jpV68DXLqpVpSp9Vz9U6dSwNFYD6Cq6fAboR1asARidOPwDGJy5W+e8H65m/QWuTt8V/XN9cZJHogLHAJAAAAAElFTkSuQmCC", 43, 15},
    ["UMP45"] = {"iVBORw0KGgoAAAANSUhEUgAAAB0AAAAPCAYAAAAYjcSfAAABbUlEQVR4nL2UO0tdURCFvytXBUUTIihWvhDEWKRJYyVYBC2stBEhnXaChVj5D2wsLK3Fylb7QIpYqohCksJCQS8+UCQ+Pos7moOo51y5umCYzbBn1pq9Z29USrBGdURtLTEPdUmdUsmTDQ3ABDANfAR+An+AC+AKqADywDVwC1QCy4n8ZmAI2AVIU9ekTqqHlgdzKjn1FFgFaoCvwG+gG6jPeAql4ATYQd1OdLYWfly9SSg8U9fD9jN0dK7uqZexvlD/qfNqVZK0Vj1Qe9WFIP0VAuoSwqpDhFGsoF4lCPvUKp++ri4V1CN1IIhUj2P95ZnEDvU2CAcjtuD/e//2TN6DEUoL6g/1u1qTkjQbxVfUdrVT/aDORHwsjTQPfCpxGIbDL1Icuntshu9JK5D1nSbRD4wC64/iG+E/pxXIqa/gfboWcAwUgLaXNlaUixEQ2AJaSHnj5SSF4hHnKH4u70aaaZjeotO/QONLm+4AiM1w4f2iFXkAAAAASUVORK5CYII=", 29, 15},
    ["UTILITY KNIFE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAAA9UlEQVR4nL3UPUqDQRDG8V9C8CMaglhYBNTaUkxnYWflDbyHtY0nEFurXEALBcUTCPZiaSMaFTGSiGEs3hWCRUDerH8Yltkdnmd2GbYSES08YBVbWFQwixlMo44pzKGGBqpoptqFtDbTfiPVdXGFU5zjUS4ioh0RJxExjLz0ImI3IuSIKtrYSS+ZkzqOsZZDvIbtHMJj/M6UG7E+nnCLa1ziuYav0u39jeUUk6KPgyo6ExT9b14U/XcqEQF72Ff8ULno4kYxAYcYlNAK3OMOQ/i5CCxhEyuYRwsbWE/nPXyOiA3wMZIP8fbL8DWZXuAI7yWaH8s324HgmwHy84AAAAAASUVORK5CYII=", 50, 8},
    ["UZI"] = {"iVBORw0KGgoAAAANSUhEUgAAAB8AAAAPCAYAAAAceBSiAAABbUlEQVR4nLXTPWuUURAF4GfX9aPwI35hYZNCsE4nWKTxDySIlcRfYZVeEH+Bnb2oCCIBK7XQRrSyEpIiImgiq0bJBuOx2Bu5rG42+5ocGO68885wZu6cK4lid5N8TnKhiu3UDia5neRkFZtIcj/JpWF1HX2cwuXiX8ctTOAIjuMw9huOn5jDO7zEOi5iBt/wAt//qkrSTjKfvUM3yc0kc4OTt5JMYnGbqXYLPbyvAx3M7jHpFzzBEm7UP1pJPuI01rCJY6XLHziKp5gq/r5S9wFfS82JUtNCBs7HeIB7/2wrSa/s5kqSO0lminolmSqq7VY77CU5l2Sy5DR5HX/Uvo4DmMc0ulVvr8v5q4qt4my5zkOlthHahXwT1waIayxX/ic8wwbO43lT8q3Jr+LNNnlnBr6Dt01Jt9DWF9erEXmNr3YU+QJWRuQ9rPzO0KxxMYY6F4raHyVpNVV4be0x+two55r+zv8b45DvOn4D3E7UPCcemn4AAAAASUVORK5CYII=", 31, 15},
    ["VOID STAFF"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABIklEQVR4nNXVv0qcQRQF8N+nrmgMcaNg0qSxSiQEQh5DUgTyGkKKbCvYRPBRbNIFOyshATsLm/wjErTdIlsoy0kx88GH1Wqje2C4M3fuzD1zZoYriSlrL5N8STJM8jPJxyS9JokpwgfsYQaf8RV/cDV3h6QmxQJe4x0GuMBbHHeD5rCOFfSr7/E120dT+7MY4W8d/8PlDQhtYIg1LNX8a3XONR4wj+fodXw7+FG5jFtnk+QcTyckc98QHGG3SbKoKNLah4oCy4piy52FPUWF7xMkafdrsYAXyo30FfUbPMGDGrPayfeo5numqN9iG4fKSxjjFKNp+OxLeIP32MIZNnHSDZqGg3QxwCflSe3jG35jfNc14TbtVZKDWkd+JRkkmf8PguhkfiyUgawAAAAASUVORK5CYII=", 50, 9},
    ["VSS VINTOREZ"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABi0lEQVR4nLXVv2sVQRDA8c97XCBiLIyghSiJoOIPRFFJq4ilRcAihYj+E5a28sBWCwsL/wOxFkQbCxFFQhARsXiCIBhDjEQhY3H7yL7z1He+8wvLzTAzuzO7s7ediDAmW3AVO5I+ieWkr6KLCXzC4UpsB9PYwCxu4RG+NFj/PC52xizkAG7iwjiTtEGB7VjD+ogx05jHOezF6f+TWjM6EfEW+1qabxWPlcXuwe4anz6eZ+OrssUGbGjWWhOYKvDSZiHruI2PmeNxLCT5He5g0I9HcSnJkRK6nuIn8aay6Am8aJDk6ERELzbpRYTKKCLie7JfqbE/zOL7ETEbEUci4lBEvI5h5mriWxldfMjq2lpT607l8cGzGvsgJnBGeWqLWMK1iu/MP+73X+kavh+nanxOZnK/YpvCsSS/92sr3Tfc7zPNUxyNAgczfQ73lDs64HIm38XTTD+rfEf4fe/fwA/lJtSdaCsU2IZX+IYV7FJe1FA+bE/wIPl/Tt/l9N2fzZX/IHJ6rWX7B34CvKzpPjgLsUwAAAAASUVORK5CYII=", 50, 10},
    ["WA2000"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB8klEQVR4nMXWT4hOURgG8N838zWN5G/5hvwpyWiYWCoLsrGylVhIrOxmI3sLpVlIItbWJCtJGtlIqSHF1JSMmUgifTFjZnzX4j3T3JlmuN/9ME+d7u2c+5z7Pud9z3NOJcsyJfEaNXzHAJ5jM16iG6dwAyPowSh6U+tBJ/pwuWwAeVRaEPIe61v8f5+/JKTaAvcFxjCBxxhCP46hA8vxLT2viKB3Yxd2iEXYiiNN/PMgVuP4/IF8Rg5jlSiZP2EE21KAVfxMwXfjFRqopG/bsBOXcBGfU38/zjYhYoazH3sXEvIQ0ziQgimC8cRZ0WQgP8SeeoqpNE8z2IcufMKG/EAly7IptItVbC84YUOsdFncwccSvI1CyB7UzWa9URXqukR5FBXSKuoleWO4L5zvgVkhWSXLsiFsF6kuWlqtYhzLSnJv4RBW5jvbUMZ/3+JNjjud2m08KcAvK4KomvPzO6vCqVi85jOzKYSbOJHer+GMsOC7OJm+vYrhFoL9He6Jw3cO8pv9KM4JYR1iQ1/HaVF6MxgV7tHAI2HDveJcqAufH8DkP5GxCCpZll3AV+Hxm0T91kWGJoUZrMlxBrFFlFIt9a3Fl/8T8sIockXpxDrhbDV8wLPc+LC5GVsSFLmiTOBdajMYFNeNNnHItQv7XjL8AtVxf+1zfjOnAAAAAElFTkSuQmCC", 50, 14},
    ["WAR FAN"] = {"iVBORw0KGgoAAAANSUhEUgAAABgAAAAPCAYAAAD+pA/bAAABKElEQVR4nLWUvy4EURhHz9hFPIBGI5uoFEQkEgodWglPsK+g1ngHBQrRaCQ0JFiJ2JAgNP48gETjFWx2j2L3ymQys2Y34yRfcyff+d07882NVLowD6wCi8A00AQawBBwB1wAN8BzpkFNq1n12vzcqgtpruRCWd1Rmz3IAy11Wx3MChhWj/sQJzmKh8TlVwXIA6chJARsFigPbKlEagV4B0a6jVMffANTkXoJLBUsD5wNAAfAyz/Iv4D78A0idUWtFfDuX9Wq7cFJ/dFm1EO1EWtqqY/qrrqnPnXW4s/P1eXOZn99kdlXRQXYAKpArXPkOSACHoAxYBI4AfaBt1RLygmSNaquq/XYjuvqmlr6qz9PQKgJ9VP9UMfz9pV7mIoS7dlu0r5Nc/EDbRMgY2WoQNkAAAAASUVORK5CYII=", 24, 15},
    ["WARHAMMER"] = {"iVBORw0KGgoAAAANSUhEUgAAACsAAAAPCAYAAAB9YDbgAAAA9UlEQVR4nM3WsS5EQRTG8d9em3gAzSYKoVRpdRq1B/AEaLyAV0A8gMYL6LYguzReYAvR0GqUorGO4t6bMGY3iNj5kslk/jkz+c7JmcmICIWN+Yg4jM8aRcRqJyIUpi2cZ3i/+mcj39HyBL5SotkznCbsFjslmn3CRcIecV1iz8IN1hO21sUB9vCMS1zhFWPMfZhl2F/HVFhCL5PARicixk1Q6Rp0cYxdvKgrO1RnmqvImzqx31St3TstpsIitn19FQZtz1bNYaUo27NtpiUZhZNkPcSoxF5dwGbCepoLNgM/U7WPowy/K7GyDxP4/ax/WD/6db0DbndSEZVbeYYAAAAASUVORK5CYII=", 43, 15},
    ["WORLD BUSTER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAAAqElEQVR4nNXUvwpBARTH8c/VtckjGOzyCCYymKweyaPYjLKalSwGsUixKFmkruGmpFvuJRff8fyp3+l3zgmiKJKSAUroY522KScuQYZBZqh9UMyrnNELMzQUPqXkDU7oYhRiiAbGSLInQB3V3OSl44AOJhCKV6aMRUJxJHaigAqKuUh8zg5tTG+Bf7yRLVqY3wez3MgvsEITy8dElkEW2Pju+93jmJS4AjlvJGu/bS3RAAAAAElFTkSuQmCC", 50, 8},
    ["X95 SMG"] = {"iVBORw0KGgoAAAANSUhEUgAAAB0AAAAPCAYAAAAYjcSfAAABVUlEQVR4nMXUu2oVURQG4O/oCAFvICohnRfirbCwsg3a5xW09hFsFPRN7H0AY2MsBLVQEQQl6ZSDoIQDHhXPb3H2hEEmw2QS8IfFXmvNuu89a5TEQFzG+562pzDCGA4MzYiju7D9iYu1UOFTD6cZTjTkKT7jTIvtCCnnqOiCp1jHrMLZXVTcxFLHtzGe4bR5h3/wY7uqJLNGRfuJutsa37CBVNjUPqY2jDEp/BIWOmz/beQ57tVJ35Wkr3CtI8gWbuBtkVewZn63j3ABV3AXL1r8L+ElSPIgO+N7g99IcjKJQreL/nWSY0lullh2oIWar/AYBxsVTXCkjOdcGeN1rOJrw+5WOZ/gN95o/BYtmG5zHZXV9LB0dLWhO5zkV5JpkvNFdyfJYo94g5fDcRwyfw8fi24RX/o4VwOTbuEDlnHffHms93UemnSi+/46sZfdOxj/Jelfh0r3n91oDZEAAAAASUVORK5CYII=", 29, 15},
    ["X95R"] = {"iVBORw0KGgoAAAANSUhEUgAAAB8AAAAPCAYAAAAceBSiAAABkElEQVR4nLXUz4uNURwG8M+duTEUmSzIkpSVxGiUGptJWfBfSNbKH2ApO1s2tiwkKSxM2AqTX1nYaZQYGcVM7jwW77l13DT3vaN56vT98Z7zPuc55/s9nSTWiX34iF8jrDmEF/1gbL3M2IodmEC32AlsKeNf2F8HXTxsSTaPKdzDB8zgLIKXOFjmdYqdxacS98q8AxrBq9DJf5z7ECxjBd8xXsh/YxoLG02uEHaqeAnX8BW9MXzZQPLOQNyvse2YlGQuDd5kOOaTnEwym+RUkuclv5LkZ5LlIetfJdEfXbzGCexuoeQtHlTxtKZ9ruAWduIcrmrud1D9xF9/S3K+heI+zlQ7H0+yUPJ3kmxOsjfJpVrdWqOL67hf7WcJ24p/HDeqb73KP1yd1kVNdR/B3RYniKbPVzR9W+NzsYsD+T2Vf6zY23hX/KO42ZZ82Au3OLCBqcrv31+feBLf2hLTKB+Gpzhd/Jkq/wTPNC/ZODbh8ijkbQrjQlVwq0l2tS2oNgU3DI/xHo8whx8jqVsDfwBaPIPgIwLktwAAAABJRU5ErkJggg==", 31, 15},
    ["ZERO CUTTER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAADCAYAAADRGVy5AAAAq0lEQVR4nL3RzUqCURDG8d+rgQmZWu1btAuCbq1lN9SmW3AheAvpqoWbhBRTgoqCmBbviC78CAQfGP5nzmEOD88UEXGBe7xjYLN+UcU3PvPuBx9bZnYpMF/pj9DIcwMnyVO00EQbZzjP9y4eiojo43oPM4fWGD108IgpFBFxhTs8Y6RMqYZbXGKo3MZN8s0ypSYqypSsEI5R/6e5WXKxoS9M8Jp8wVPWcN0Hf3zHKylcKx3UAAAAAElFTkSuQmCC", 50, 3},
    ["ZIP 22"] = {"iVBORw0KGgoAAAANSUhEUgAAABsAAAAPCAYAAAAVk7TYAAABF0lEQVR4nL3TsStFYRzG8c897mRUdoO6WbEoMZspsZBJBovR5E9QRExS/gQpFjvFoKQYDFwZ7qAk5DXcc/N26DoH11NPvef9Pb/3e97T75RCCBWcYwQXfq5RDGIe1wifEiGElfD3mgkhyLr8i5s00xAeMnv7rYJNpY7Vm6CvRcCsthN0/hOsJ8FegYbnKH+Kg8i1KLeIjtSl1G3l9IC8OsIuhtGP16g2h9V0Xc3AQYLHArDGv/OWAfHx0rfY+ao5KQDKqzs8fVUoOvoVdKMdy7iJamPfNReF1XCG2WivhPU8zUVhVWxEzwmmcY9J9anMDbvEeJP8UrQewAIO0SXHoJXVP80VTrCJ4yb5Layp3/AKE3j5DtLQOxU/nR3e/F9+AAAAAElFTkSuQmCC", 27, 15},
    ["ZIRCON SLAMSICKLE"] = {"iVBORw0KGgoAAAANSUhEUgAAABAAAAAPCAYAAADtc08vAAABGElEQVR4nJWRu0pDQRRFFxIDISrRQvADJKJgYxcsTKWFfyD5hVj6E1Y+PsHKKiIodil8gCja2knA0gcKFyWyLDKRy3VuMBs2zJyZvZhzBpXgqrql7thTEvYrqTt/3F/sqx/Glagn6kQeYFf9Vp/UltrOAR2rlRjAAKmGYlmtqdtqJwNpqZNZwLpazOlxPvKSa/VAXUjPYJAPc1r6UhuDghV1T71UP3Mg3bzwlHobLl2oJfUxE07U5Vh4Wr1RT+0NdDTUG6nwm1qPzWBGvbL3ZeXMWSkM71ld7dez4XP1yMh/B4+rs+laAdgAloA7oAasAa/E9R78qwIwBmwCD0A7gP6tEaADdIE54B54GRawCBSBM6AJ1IcB/ADDcl/CIOsnNwAAAABJRU5ErkJggg==", 16, 15},
    ["ZIRCON TRIDENT"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABG0lEQVR4nM2UsS5FQRCGvz3u2StUwhuISqH0BgrxAirvQELFO5B4A4ncXiWhVBGFUqsVHXEc51ecf282N/eIgjiTTHZ3/szszsz+EyTRI1kCRsA+cGfbBrAHDAEB79Yr4GTsKakvWkq6VysvkpYlbUp6U7fsJP+B84nAFrAIPAMXwKexmSmVa6yDKZiAGig7qv5hvzBhz23R+yNg1vFOgQKYM14Cl95XQdIhsA2sOFgNPHpNiURrDVR+DA4cadve0La8MhYyjAxrJrAiw1azxJ6AeWDB54cs4ZRIbd/zoqNqP5HvyPXXxAvW8T3BZO/L17oB1oBXr2fAOt1fa9fvrf6b4L9G9tSRvkgavwfArW1p/Eaf0/i9Bo6T4xdM44pWBHcfuQAAAABJRU5ErkJggg==", 50, 8},
    ["ZWEIHANDER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAA7ElEQVR4nM3UPUpDQRTF8Z8mRBQUrBKwiJDWHdi4DXtrV+HCbFxBasFSLRIRMX4gz+I9IYYRfXcmPP8wMHOGC+cwc+9GVVVaMsIZLtoWrpPNQM0YR6WN5BIJcofb0kZyiQa5L20kl0iQBa5LG8klEmSA44Q+yfSSRR8n2G/2sIUd7KHXrI/mbhcznKqn1xcHzXm+pD0u1f1EhYeE/ornhP6OJ7yof8Zc/c2nqRf5yyutzuzfDK+dPi5b1gxwiPMVfaLD3on0yBuuEnqnAyASZFvHjZ0iEmSEYWkjuUSCDH2fWP+CSJAbTAv7yOYTCAcjy7oQ9i0AAAAASUVORK5CYII=", 50, 14},
}

if syn and syn.cache_replace and syn.cache_invalidate and syn.is_cached and syn.write_clipboard and syn.set_thread_identity then
	for k, v in pairs(gunicons) do
		gunicons[k][1] = syn.crypt.base64.decode(v[1])
	end
end

local emojis = {
    "😎😎😎😎😎😎😎😎😎😎",
    "🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣",
    "👀👀👀👀👀👀👀👀👀👀",
    "🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄",
    "🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥",
    "😅😅😅😅😅😅😅😅😅😅",
    "😂😂😂😂😂😂😂😂😂😂",
    "😹😹😹😹😹😹😹😹😹😹",
    "😛😛😛😛😛😛😛😛😛😛",
    "🤩🤩🤩🤩🤩🤩🤩🤩🤩🤩",
    "🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈",
    "😎😎😎😎😎😎😎😎😎😎",
    "🤠🤠🤠🤠🤠🤠🤠🤠🤠🤠",
    "😔😔😔😔😔😔😔😔😔😔",
    "🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡",
    "💤💤💤💤💤💤💤💤💤💤",
    "🚶‍♂️🚶‍♀️🚶‍♂️🚶‍‍🚶‍♀️🚶‍♂️🚶‍♀️🚶‍♂️🚶🚶‍♀️🚶‍♂️🚶🚶‍♀️🚶‍♂️🚶‍",
    "🙀🙀🙀🙀🙀🙀🙀🙀🙀🙀",
    "😂😂😂😂😂😂😂😂😂😂",
    "📈📈📈📈📈📈📈📈📈📈",
    "🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏",
}
    
local symbols = {
    "~~~~~~~~~~",
    "!!!!!!!!!!",
    "@@@@@@@@@@",
    "##########",
    "$$$$$$$$$$",
    "%%%%%%%%%%",
    "^^^^^^^^^^",
    "&&&&&&&&&&",
    "**********",
    "((((((((((",
    "))))))))))",
    "__________",
    "++++++++++",
    "{{{{{{{{{{",
    "}}}}}}}}}}",
    "||||||||||",
    "::::::::::",
    '""""""""""',
    "<<<<<<<<<<",
    ">>>>>>>>>>",
    "??????????",
    "..........",
    ",,,,,,,,,,",
    "//////////",
    "''''''''''",
}

local phrases = {
    "how many bites are in a d-word?",
    "i think your bad.",
    "*TOT*",
    "d(-_-)b",
    "keep crying :C",
    "how much is a gigabyte?",
    "i have 10tb of cp (club pengiun)",
    "hi hi hi hi hi hi",
    "AAAAAAAAAAAAAAAAAAAA",
    "SET UPVALUES (CONSTANT)",
    "brb taking a nap",
    "gonna go take a walk",
    "low orbit ion cannon booting up",
    "im a firing my laza!",
    "GAMING CHAIR",
    "can't hear you over these kill sounds",
    "i'm just built different yo",
    "OFF THE CHART ",
    "KICK HIM",
    "SORRY I HURT YOUR ROBLOX EGO",
    "FULCRUM COME IN YUUHH YODIE GANG",
    "Shall we? cheers my friends.",
    "Cheers my friends.",
    "Let's take a blinker, shall we?",
    "Shall we go to penjamin city?",
    "PLUG PLUG P-P-PLUG.",
    "Im completely obliterated",
    "i am a person.",	
    "cl_junkcode 1",
    "moment - Vierre Cloud",
    "IT BASICALLY WIPES EVERY LOBBY",
    "I WILL- STAND ON THIS",
    "THERE IS NO CHEAT THAT CAN COMPETE WITH EXODUS",
    "THAT LIKE-LIKE KILLS IT",
    "LIKE IM TELLING YOU BRO",
    "I-I GOT VOTEKICKED FROM AN AECH VEE AECH LOBBY",
    "FROM AN AECH VEE AECH LOBBY.",
}

local stringsub_table = {
    [1] = 4,
    [2] = 8,
    [3] = 12,
    [4] = 16,
    [5] = 20,
    [6] = 24,
    [7] = 28,
    [8] = 32,
    [9] = 36,
    [10] = 40
}

getgenv().Tabs = {Legit = Window:AddTab('Legit'), Rage = Window:AddTab('Rage'), Visuals = Window:AddTab('Visuals'), Misc = Window:AddTab('Misc'), ['Settings'] = Window:AddTab('Settings'), Lua = Window:AddTab("Lua")} 

do -- Legit Tab
    local AimAssist = Tabs.Legit:AddLeftGroupbox('Aim Assist') do
        AimAssist:AddToggle('AimEnabled', {Text = 'Enabled'}):AddKeyPicker('AimKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Aim Assist', NoUI = false})
        AimAssist:AddSlider('AimFov', {Text = 'Field Of View', Default = 30, Min = 1, Max = 360, Rounding = 0})
        AimAssist:AddSlider('AimHorizontal', {Text = 'Horizontal Smoothing', Default = 20, Min = 1, Max = 100, Rounding = 0})
        AimAssist:AddSlider('AimVertical', {Text = 'Vertical Smoothing', Default = 20, Min = 1, Max = 100, Rounding = 0})
        AimAssist:AddToggle('AimVisCheck', {Text = 'Visible Check'})
        AimAssist:AddToggle('AimTeam', {Text = 'Target Teammates'})
        AimAssist:AddDropdown('AimHitscan', {Values = { "Head", "Torso", "Closest" }, Default = 1, Multi = false, Text = 'Hitscan Priority'})
        AimAssist:AddLabel("If your using high sensitivity make your smoothing higher!", true)
    end

    local SilentAim = Tabs.Legit:AddRightGroupbox('Silent Aim') do
        SilentAim:AddToggle('SilentEnabled', {Text = 'Enabled'}):AddKeyPicker('SilentKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Silent Aim', NoUI = false})
        SilentAim:AddSlider('SilentFov', {Text = 'Field Of View', Default = 30, Min = 1, Max = 360, Rounding = 0})
        SilentAim:AddSlider('SilentHitchance', {Text = 'Hit Chance', Default = 80, Min = 1, Max = 100, Rounding = 0})
        SilentAim:AddToggle('SilentVisCheck', {Text = 'Visible Check'})
        SilentAim:AddToggle('SilentTeam', {Text = 'Target Teammates'})
        SilentAim:AddDropdown('SilentHitscan', {Values = { "Head", "Torso", "Closest" }, Default = 1, Multi = false, Text = 'Hitscan Priority'})
    end
end

do -- Rage Tab
    local RageBot = Tabs.Rage:AddLeftGroupbox('Rage Bot') do
        RageBot:AddToggle('RageEnabled', {Text = 'Enabled'}):AddKeyPicker('RageKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Rage Bot', NoUI = false})
        RageBot:AddDropdown('RageHitscan', {Values = { "Head", "Torso" }, Default = 1, Multi = false, Text = 'Hitscan Priority'})
        RageBot:AddToggle('RageFirePos', {Text = 'Fire Position Scanning'})
        RageBot:AddSlider('RageFirePosAmount', {Text = 'Studs', Default = 3, Min = 0, Max = 8, Rounding = 10})
    end

    local KnifeBot = Tabs.Rage:AddRightGroupbox("Knife Bot") do
        KnifeBot:AddToggle('KnifeBot', {Text = 'Enabled'}):AddKeyPicker('KnifeKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Knife Bot', NoUI = false})
        KnifeBot:AddDropdown('KnifeScan', {Values = { "Head", "Torso" }, Default = 1, Multi = false, Text = 'Hitscan Priority'})
        KnifeBot:AddSlider('KnifeRange', {Text = 'Studs', Default = 10, Min = 0, Max = 25, Rounding = 10})
    end

    local AntiAim = Tabs.Rage:AddRightGroupbox('Anti Aim') do
        AntiAim:AddToggle('AntiEnabled', {Text = 'Enabled'}):AddKeyPicker('AntiKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Anti Aim', NoUI = false})
        AntiAim:AddDropdown('AntiPitch', {Values = { "Off", "Up", "Down", "Random", "Sine Wave", "Custom" }, Default = 1, Multi = false, Text = 'Pitch'})
        AntiAim:AddDropdown('AntiYaw', {Values = { "Off", "Backwards", "Spin", "Random", "Sine Wave", "Custom" }, Default = 1, Multi = false, Text = 'Yaw'})
        AntiAim:AddSlider('AntiSineWave', {Text = 'Sine Wave Speed', Default = 4, Min = 0, Max = 20, Rounding = 0})
        AntiAim:AddSlider('AntiCustomYaw', {Text = 'Custom Yaw', Default = 0, Min = 0, Max = 360, Rounding = 0})
        AntiAim:AddSlider('AntiCustomPitch', {Text = 'Custom Yaw', Default = 0, Min = -4, Max = 4, Rounding = 0})
        AntiAim:AddSlider('AntiSpinRate', {Text = 'Spin Rate', Default = 0, Min = -100, Max = 100, Rounding = 0})
        AntiAim:AddDropdown('AntiStance', {Values = { "Off", "Stand", "Crouch", "Prone" }, Default = 1, Multi = false, Text = 'Force Stance'})
        AntiAim:AddToggle('AntiHide', {Text = 'Hide In Floor'})
    end
end

do -- Visuals Tab
    local EspBox = Tabs.Visuals:AddLeftTabbox() do
        local EnemyEsp = EspBox:AddTab('Enemy ESP') do
            EnemyEsp:AddToggle('EnemyEspEnabled', {Text = 'Enabled'})
            EnemyEsp:AddToggle('EnemyEspBox', {Text = 'Box'}):AddColorPicker('EnemyColorBox', {Default = Color3.fromRGB(255, 255, 255), Title = 'Box Color'})
            EnemyEsp:AddToggle('EnemyEspName', {Text = 'Name'}):AddColorPicker('EnemyColorName', {Default = Color3.fromRGB(255, 255, 255), Title = 'Name Color'})
            EnemyEsp:AddToggle('EnemyEspHealthBar', {Text = 'Health Bar'}):AddColorPicker('EnemyColorHealthBar', {Default = Color3.fromRGB(255, 255, 0), Title = 'Health Bar Color'})
            EnemyEsp:AddToggle('EnemyEspHealthNumber', {Text = 'Health Number'}):AddColorPicker('EnemyColorHealthNumber', {Default = Color3.fromRGB(255, 255, 255), Title = 'Health Number Color'})
            EnemyEsp:AddToggle('EnemyEspWeapon', {Text = 'Weapon'}):AddColorPicker('EnemyColorWeapon', {Default = Color3.fromRGB(255, 255, 255), Title = 'Weapon Color'})
            EnemyEsp:AddToggle('EnemyEspIcon', {Text = 'Weapon Icon'})
            EnemyEsp:AddToggle('EnemyEspSkeleton', {Text = 'Skeleton'}):AddColorPicker('EnemyColorSkeleton', {Default = Color3.fromRGB(255, 255, 255), Title = 'Skeleton Color'})
            EnemyEsp:AddDivider()
            EnemyEsp:AddToggle('EnemyEspLevel', {Text = '[F] Level'}):AddColorPicker('EnemyColorLevel', {Default = Color3.fromRGB(255, 255, 255), Title = 'Level Color'})
            EnemyEsp:AddToggle('EnemyEspDistance', {Text = '[F] Distance'}):AddColorPicker('EnemyColorDistance', {Default = Color3.fromRGB(255, 255, 255), Title = 'Distance Color'})
            EnemyEsp:AddDivider()
            EnemyEsp:AddToggle('EnemyEspOutOfView', {Text = 'Out Of View'}):AddColorPicker('EnemyColorOutOfView', {Default = Color3.fromRGB(255, 255, 255), Title = 'Out Of View Color'})
            EnemyEsp:AddToggle('EnemyEspOutOfViewSine', {Text = 'Pulse'})
            EnemyEsp:AddSlider('EnemyEspOutOfViewDistance', {Text = 'Distance', Default = 20, Min = 0, Max = 100, Rounding = 1})
            EnemyEsp:AddSlider('EnemyEspOutOfViewSize', {Text = 'Size', Default = 12, Min = 0, Max = 30, Rounding = 1})
            EnemyEsp:AddDivider()
            EnemyEsp:AddToggle('EnemyEspChams', {Text = 'Chams'}):AddColorPicker('EnemyColorChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Chams Color'})
            EnemyEsp:AddSlider('EnemyEspChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
            EnemyEsp:AddDivider()
            EnemyEsp:AddToggle('EnemyEspHighlights', {Text = 'Highlights'}):AddColorPicker('EnemyColorHighlights', {Default = Color3.fromRGB(255, 255, 255), Title = 'Highlights Color'}):AddColorPicker('EnemyColorHighlightsOutline', {Default = Color3.fromRGB(255, 255, 255), Title = 'Highlights Outline Color'})
            EnemyEsp:AddToggle('EnemyEspHighlightsSine', {Text = 'Pulse'})
            EnemyEsp:AddSlider('EnemyEspHighlightsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
            EnemyEsp:AddSlider('EnemyEspOutlineHighlightsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
        end

        local TeamEsp = EspBox:AddTab('Team ESP') do
            TeamEsp:AddToggle('TeamEspEnabled', {Text = 'Enabled'})
            TeamEsp:AddToggle('TeamEspBox', {Text = 'Box'}):AddColorPicker('TeamColorBox', {Default = Color3.fromRGB(255, 255, 255), Title = 'Box Color'})
            TeamEsp:AddToggle('TeamEspName', {Text = 'Name'}):AddColorPicker('TeamColorName', {Default = Color3.fromRGB(255, 255, 255), Title = 'Name Color'})
            TeamEsp:AddToggle('TeamEspHealthBar', {Text = 'Health Bar'}):AddColorPicker('TeamColorHealthBar', {Default = Color3.fromRGB(255, 255, 0), Title = 'Health Bar Color'})
            TeamEsp:AddToggle('TeamEspHealthNumber', {Text = 'Health Number'}):AddColorPicker('TeamColorHealthNumber', {Default = Color3.fromRGB(255, 255, 255), Title = 'Health Number Color'})
            TeamEsp:AddToggle('TeamEspWeapon', {Text = 'Weapon'}):AddColorPicker('TeamColorWeapon', {Default = Color3.fromRGB(255, 255, 255), Title = 'Weapon Color'})
            TeamEsp:AddToggle('TeamEspIcon', {Text = 'Weapon Icon'})
            TeamEsp:AddToggle('TeamEspSkeleton', {Text = 'Skeleton'}):AddColorPicker('TeamColorSkeleton', {Default = Color3.fromRGB(255, 255, 255), Title = 'Skeleton Color'})
            TeamEsp:AddDivider()
            TeamEsp:AddToggle('TeamEspLevel', {Text = '[F] Level'}):AddColorPicker('TeamColorLevel', {Default = Color3.fromRGB(255, 255, 255), Title = 'Level Color'})
            TeamEsp:AddToggle('TeamEspDistance', {Text = '[F] Distance'}):AddColorPicker('TeamColorDistance', {Default = Color3.fromRGB(255, 255, 255), Title = 'Distance Color'})
            TeamEsp:AddDivider()
            TeamEsp:AddToggle('TeamEspOutOfView', {Text = 'Out Of View'}):AddColorPicker('TeamColorOutOfView', {Default = Color3.fromRGB(255, 255, 255), Title = 'Out Of View Color'})
            TeamEsp:AddToggle('TeamEspOutOfViewSine', {Text = 'Pulse'})
            TeamEsp:AddSlider('TeamEspOutOfViewDistance', {Text = 'Distance', Default = 20, Min = 0, Max = 100, Rounding = 1})
            TeamEsp:AddSlider('TeamEspOutOfViewSize', {Text = 'Size', Default = 12, Min = 0, Max = 30, Rounding = 1})
            TeamEsp:AddDivider()
            TeamEsp:AddToggle('TeamEspChams', {Text = 'Chams'}):AddColorPicker('TeamColorChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Chams Color'})
            TeamEsp:AddSlider('TeamEspChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
            TeamEsp:AddDivider()
            TeamEsp:AddToggle('TeamEspHighlights', {Text = 'Highlights'}):AddColorPicker('TeamColorHighlights', {Default = Color3.fromRGB(255, 255, 255), Title = 'Highlights Color'}):AddColorPicker('TeamColorHighlightsOutline', {Default = Color3.fromRGB(255, 255, 255), Title = 'Highlights Outline Color'})
            TeamEsp:AddToggle('TeamEspHighlightsSine', {Text = 'Pulse'})
            TeamEsp:AddSlider('TeamEspHighlightsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
            TeamEsp:AddSlider('TeamEspOutlineHighlightsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
        end

        local LocalEsp = EspBox:AddTab('Local ESP') do
            LocalEsp:AddToggle('LocalEspEnabled', {Text = 'Enabled'})
            LocalEsp:AddToggle('LocalEspBox', {Text = 'Box'}):AddColorPicker('LocalColorBox', {Default = Color3.fromRGB(255, 255, 255), Title = 'Box Color'})
            LocalEsp:AddToggle('LocalEspName', {Text = 'Name'}):AddColorPicker('LocalColorName', {Default = Color3.fromRGB(255, 255, 255), Title = 'Name Color'})
            LocalEsp:AddToggle('LocalEspHealthBar', {Text = 'Health Bar'}):AddColorPicker('LocalColorHealthBar', {Default = Color3.fromRGB(255, 255, 0), Title = 'Health Bar Color'})
            LocalEsp:AddToggle('LocalEspHealthNumber', {Text = 'Health Number'}):AddColorPicker('LocalColorHealthNumber', {Default = Color3.fromRGB(255, 255, 255), Title = 'Health Number Color'})
            LocalEsp:AddToggle('LocalEspWeapon', {Text = 'Weapon'}):AddColorPicker('LocalColorWeapon', {Default = Color3.fromRGB(255, 255, 255), Title = 'Weapon Color'})
            LocalEsp:AddToggle('LocalEspIcon', {Text = 'Weapon Icon'})
            LocalEsp:AddToggle('LocalEspSkeleton', {Text = 'Skeleton'}):AddColorPicker('LocalColorSkeleton', {Default = Color3.fromRGB(255, 255, 255), Title = 'Skeleton Color'})
            LocalEsp:AddDivider()
            LocalEsp:AddToggle('LocalEspLevel', {Text = '[F] Level'}):AddColorPicker('LocalColorLevel', {Default = Color3.fromRGB(255, 255, 255), Title = 'Level Color'})
            TeamEsp:AddToggle('LocalEspDistance', {Text = '[F] Distance'}):AddColorPicker('TeamColorDistance', {Default = Color3.fromRGB(255, 255, 255), Title = 'Distance Color'})
            LocalEsp:AddDivider()
            LocalEsp:AddToggle('LocalEspChams', {Text = 'Chams'}):AddColorPicker('LocalColorChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Chams Color'})
            LocalEsp:AddSlider('LocalEspChamsTrans', {Text = 'Transparency', Default = 150, Min = 1, Max = 255, Rounding = 0, Compact = true})
            LocalEsp:AddSlider('LocalEspChamsReflectance', {Text = 'Reflectance', Default = 5, Min = 0, Max = 100, Rounding = 0, Compact = true})
            LocalEsp:AddDropdown('LocalEspChamsMaterial', {Values = { "ForceField", "Neon", "Plastic", "Glass" }, Default = 1, Multi = false, Text = 'Material'})                                    
            LocalEsp:AddDivider()
            LocalEsp:AddToggle('LocalEspHighlights', {Text = 'Highlights'}):AddColorPicker('LocalColorHighlights', {Default = Color3.fromRGB(255, 255, 255), Title = 'Highlights Color'}):AddColorPicker('LocalColorHighlightsOutline', {Default = Color3.fromRGB(255, 255, 255), Title = 'Highlights Outline Color'})
            LocalEsp:AddToggle('LocalEspHighlightsSine', {Text = 'Pulse'})
            LocalEsp:AddSlider('LocalEspHighlightsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
            LocalEsp:AddSlider('LocalEspOutlineHighlightsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
        end
    end

    local SettingsEsp = Tabs.Visuals:AddLeftGroupbox('Settings') do
        SettingsEsp:AddToggle('EspTarget', {Text = 'Display Target'}):AddColorPicker('ColorTarget', {Default = Color3.fromRGB(255, 0, 0), Title = 'Distance Color'})
        SettingsEsp:AddDropdown('TextFont', {Values = { "UI", "System", "Plex", "Monospace" }, Default = 3, Multi = false, Text = 'Text Font'})
        SettingsEsp:AddDropdown('TextCase', {Values = { "lowercase", "Normal", "UPPERCASE" }, Default = 2, Multi = false, Text = 'Text Case'})
        SettingsEsp:AddSlider('TextSize', {Text = 'Text Size', Default = 13, Min = 1, Max = 34, Rounding = 0})
        SettingsEsp:AddSlider('HpVis', {Text = 'Max HP Visibility Cap', Default = 90, Min = 0, Max = 100, Rounding = 0})
    end

    local WeaponEsp = Tabs.Visuals:AddLeftGroupbox('Dropped ESP') do
        WeaponEsp:AddToggle('DroppedWeapon', {Text = 'Weapon'}):AddColorPicker('ColorDroppedWeapon', {Default = Color3.fromRGB(255, 255, 255), Title = 'Weapon Color'})
        WeaponEsp:AddToggle('DroppedAmmo', {Text = 'Ammo'}):AddColorPicker('ColorDroppedAmmo', {Default = Color3.fromRGB(255, 255, 255), Title = 'Ammo Color'})
        WeaponEsp:AddToggle('DroppedIcon', {Text = 'Weapon Icon'})
    end

    local InterfaceBox = Tabs.Visuals:AddRightTabbox() do
        local CursorEsp = InterfaceBox:AddTab('Cursor') do
            CursorEsp:AddToggle('CursorEnabled', {Text = 'Enabled'}):AddColorPicker('ColorCursor', {Default = Color3.fromRGB(255, 255, 0), Title = 'Cursor Color'}):AddColorPicker('ColorCursorBorder', {Default = Color3.fromRGB(0, 0, 0), Title = 'Cursor Border Color'})
            CursorEsp:AddSlider('CursorSize', {Text = 'Size', Default = 13, Min = 1, Max = 100, Rounding = 0})
            CursorEsp:AddSlider('CursorThickness', {Text = 'Thickness', Default = 2, Min = 1, Max = 50, Rounding = 0})
            CursorEsp:AddSlider('CursorGap', {Text = 'Gap', Default = 5, Min = 1, Max = 100, Rounding = 0})
            CursorEsp:AddToggle('CursorBarrel', {Text = 'Follow Barrel'})
            CursorEsp:AddToggle('CursorBorder', {Text = 'Border'})
            CursorEsp:AddToggle('CursorSpin', {Text = 'Spin'})
            CursorEsp:AddSlider('CursorSpinSpeed', {Text = 'Spin Speed', Default = 5, Min = 1, Max = 50, Rounding = 0})
        end

        local FovEsp = InterfaceBox:AddTab('Field Of View') do
            FovEsp:AddToggle('FovAimAssist', {Text = 'Aim Assist'}):AddColorPicker('ColorFovAimAssist', {Default = Color3.fromRGB(255, 255, 255), Title = 'Aim Assist Color'})
            FovEsp:AddToggle('FovSilent', {Text = 'Silent Aim'}):AddColorPicker('ColorSilent', {Default = Color3.fromRGB(255, 255, 255), Title = 'Silent Color'})
            FovEsp:AddToggle('FovBarrel', {Text = 'Follow Barrel'})
        end
    end

    local OtherEspBox = Tabs.Visuals:AddRightTabbox() do
        local LocalEsp = OtherEspBox:AddTab('Local Player') do
            LocalEsp:AddToggle('ViewModel', {Text = 'Viewmodel Changer'})
            LocalEsp:AddSlider('ViewModelX', {Text = 'X Position', Default = 0, Min = -10, Max = 10, Rounding = 1})
            LocalEsp:AddSlider('ViewModelY', {Text = 'Y Position', Default = 0, Min = -10, Max = 10, Rounding = 1})
            LocalEsp:AddSlider('ViewModelZ', {Text = 'Z Position', Default = 0, Min = -10, Max = 10, Rounding = 1})
            LocalEsp:AddSlider('ViewModelPitch', {Text = 'Pitch', Default = 0, Min = -360, Max = 360, Rounding = 0})
            LocalEsp:AddSlider('ViewModelYaw', {Text = 'Yaw', Default = 0, Min = -360, Max = 360, Rounding = 0})
            LocalEsp:AddSlider('ViewModelRoll', {Text = 'Roll', Default = 0, Min = -360, Max = 360, Rounding = 0})
            LocalEsp:AddButton('Reset Viewmodel', function() 
                Options.ViewModelX:SetValue(0)
                Options.ViewModelY:SetValue(0)
                Options.ViewModelZ:SetValue(0)
                Options.ViewModelPitch:SetValue(0)
                Options.ViewModelYaw:SetValue(0)
                Options.ViewModelRoll:SetValue(0)
            end)
            LocalEsp:AddToggle('ViewModelBob', {Text = 'Custom Gun Bob'})
            LocalEsp:AddSlider('ViewModelBobSpeed', {Text = 'Speed', Default = 50, Min = 1, Max = 200, Rounding = 0})
            LocalEsp:AddSlider('ViewModelBobAmount', {Text = 'Amount', Default = 3, Min = 0, Max = 10, Rounding = 5})
            LocalEsp:AddToggle('ThirdPerson', {Text = 'Third Person'}):AddKeyPicker('ThirdPersonKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Third Person', NoUI = false})
            LocalEsp:AddSlider('ThirdPersonX', {Text = 'X Position', Default = 0, Min = -100, Max = 100, Rounding = 1}) 
            LocalEsp:AddSlider('ThirdPersonY', {Text = 'Y Position', Default = 5, Min = 0, Max = 100, Rounding = 1})
            LocalEsp:AddSlider('ThirdPersonZ', {Text = 'Z Position', Default = 5, Min = 0, Max = 100, Rounding = 1})
            LocalEsp:AddToggle('AGunChams', {Text = 'Gun Chams'}):AddColorPicker('AColorGunChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Gun Chams Color'})
            LocalEsp:AddSlider('AGunChamsTrans', {Text = 'Transparency', Default = 150, Min = 1, Max = 255, Rounding = 0, Compact = true})
            LocalEsp:AddSlider('AGunChamsReflectance', {Text = 'Reflectance', Default = 5, Min = 0, Max = 100, Rounding = 0, Compact = true})
            LocalEsp:AddDropdown('AGunChamsMaterial', {Values = { "ForceField", "Neon", "Plastic", "Glass" }, Default = 1, Multi = false, Text = 'Material'})
            LocalEsp:AddToggle('AArmChams', {Text = 'Arm Chams'}):AddColorPicker('AColorArmChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Arm Chams Color'})
            LocalEsp:AddSlider('AArmChamsTrans', {Text = 'Transparency', Default = 150, Min = 1, Max = 255, Rounding = 0, Compact = true})
            LocalEsp:AddSlider('AArmChamsReflectance', {Text = 'Reflectance', Default = 5, Min = 0, Max = 100, Rounding = 0, Compact = true})
            LocalEsp:AddDropdown('AArmChamsMaterial', {Values = { "ForceField", "Neon", "Plastic", "Glass" }, Default = 1, Multi = false, Text = 'Material'})
            LocalEsp:AddToggle('GunChams', {Text = 'Highlight Gun Chams'}):AddColorPicker('ColorGunChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Highlight Gun Chams Color'}):AddColorPicker('ColorGunOutlineChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Highlight Gun Outline Chams Color'})
            LocalEsp:AddSlider('GunChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
            LocalEsp:AddSlider('GunOutlineChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
            LocalEsp:AddToggle('ArmChams', {Text = 'Highlight Arm Chams'}):AddColorPicker('ColorArmChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Highlight Arm Chams Color'}):AddColorPicker('ColorArmOutlineChams', {Default = Color3.fromRGB(255, 255, 255), Title = 'Highlight Arm Outline Chams Color'})
            LocalEsp:AddSlider('ArmChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
            LocalEsp:AddSlider('ArmOutlineChamsTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
            LocalEsp:AddToggle('BulletTracers', {Text = 'Bullet Tracers'}):AddColorPicker('ColorBulletTracers', {Default = Color3.fromRGB(255, 255, 255), Title = 'Bullet Tracers Color'})
            LocalEsp:AddSlider('BulletTracersTrans', {Text = 'Transparency', Default = 150, Min = 0, Max = 255, Rounding = 0, Compact = true})
            LocalEsp:AddToggle('NoSway', {Text = 'No Sway'}) 
            LocalEsp:AddToggle('NoShake', {Text = 'No Shake'}) 
        end

        local WorldEsp = OtherEspBox:AddTab('World Visuals') do
            WorldEsp:AddToggle('WorldAmbience', {Text = 'Ambience'}):AddColorPicker('ColorInsideAmbience', {Default = Color3.fromRGB(255, 255, 255), Title = 'Inside Ambience Color'}):AddColorPicker('ColorOutsideAmbience', {Default = Color3.fromRGB(255, 255, 255), Title = 'Outside Ambience Color'})
            WorldEsp:AddToggle('WorldTime', {Text = 'Force Time'})
            WorldEsp:AddSlider('WorldTimeAmount', {Text = 'Custom Time', Default = 12, Min = 0, Max = 24, Rounding = 0})
            WorldEsp:AddToggle('WorldSaturation', {Text = 'Custom Saturation'}):AddColorPicker('ColorSaturation', {Default = Color3.fromRGB(255, 255, 255), Title = 'Saturation Color'})
            WorldEsp:AddSlider('WorldSaturationAmount', {Text = 'Saturation Density', Default = 2, Min = 0, Max = 100, Rounding = 0})
        end
    end
end

do -- Misc Tab
    local Movement = Tabs.Misc:AddLeftGroupbox('Movement') do
        Movement:AddToggle('MovementSpeed', {Text = 'Speed'}):AddKeyPicker('MovementSpeedKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Speed', NoUI = false})
        Movement:AddSlider('MovementSpeedAmount', {Text = 'Speed Amount', Default = 60, Min = 1, Max = 80, Rounding = 0})
        Movement:AddToggle('MovementFly', {Text = 'Fly'}):AddKeyPicker('MovementFlyKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Fly', NoUI = false})
        Movement:AddSlider('MovementFlyAmount', {Text = 'Fly Amount', Default = 60, Min = 1, Max = 80, Rounding = 0})
        Movement:AddToggle('MovementAutoJump', {Text = 'Auto Jump'})
        Movement:AddToggle('MovementFall', {Text = 'No Fall Damage'})
    end

    local Exploits = Tabs.Misc:AddLeftGroupbox('Exploits W.I.P') do
        Exploits:AddSlider('ExploitsFireRate', {Text = 'Fire Rate', Default = 100, Min = 50, Max = 5000, Rounding = 0})
    end

    local Extra = Tabs.Misc:AddRightGroupbox('Extra') do
        Extra:AddToggle('IgnoreFriends', {Text = 'Ignore Friends'})
        Extra:AddToggle('PriorityOnly', {Text = 'Target Prioritized Players Only'})
        Extra:AddToggle('SupOnly', {Text = 'Suppress Only'})
        Extra:AddToggle('AutoDeploy', {Text = 'Auto Deploy'})
        Extra:AddToggle('HitLogs', {Text = 'Hit Logs'})
        Extra:AddSlider('HitLogTime', {Text = 'Time', Default = 3, Min = 1, Max = 10, Rounding = 0})
        Extra:AddToggle('ExtraHeadsound', {Text = 'Head Sound'})
        Extra:AddSlider('ExtraHeadsoundVolume', {Text = 'Head Sound Volume', Default = 50, Min = 1, Max = 100, Rounding = 0})
        Extra:AddSlider('ExtraHeadsoundPitch', {Text = 'Head Sound Pitch', Default = 100, Min = 1, Max = 300, Rounding = 0})
        Extra:AddDropdown('ExtraHeadsoundId', {Values = sounds(), Default = 1, Multi = false, Text = 'Head Sound'})
        Extra:AddToggle('ExtraBodysound', {Text = 'Body Sound'})
        Extra:AddSlider('ExtraBodysoundVolume', {Text = 'Body Sound Volume', Default = 50, Min = 1, Max = 100, Rounding = 0})
        Extra:AddSlider('ExtraBodysoundPitch', {Text = 'Body Sound Pitch', Default = 100, Min = 1, Max = 300, Rounding = 0})
        Extra:AddDropdown('ExtraBodysoundId', {Values = sounds(), Default = 1, Multi = false, Text = 'Body Sound'})
        Extra:AddToggle('ExtraGunSound', {Text = 'Gun Sound'})
        Extra:AddSlider('ExtraGunsoundVolume', {Text = 'Gun Sound Volume', Default = 50, Min = 1, Max = 100, Rounding = 0})
        Extra:AddSlider('ExtraGunsoundPitch', {Text = 'Gun Sound Pitch', Default = 100, Min = 1, Max = 300, Rounding = 0})
        Extra:AddDropdown('ExtraGunsoundId', {Values = sounds(), Default = 1, Multi = false, Text = 'Gun Sound'})
        Extra:AddButton('Refresh', function()
            Options.ExtraHeadsoundId.Values = sounds()
            Options.ExtraHeadsoundId:SetValues()
            Options.ExtraHeadsoundId:SetValue()

            Options.ExtraBodysoundId.Values = sounds()
            Options.ExtraBodysoundId:SetValues()
            Options.ExtraBodysoundId:SetValue()

            Options.ExtraGunsoundId.Values = sounds()
            Options.ExtraGunsoundId:SetValues()
            Options.ExtraGunsoundId:SetValue()
        end)
        Extra:AddToggle('ChatSpam', {Text = 'Chat Spam'})
        Extra:AddToggle('ChatSpamEmojis', {Text = 'Emojis'})
        Extra:AddToggle('ChatSpamSymbols', {Text = 'Symbols'})
        Extra:AddSlider('ChatSpamDelay', {Text = 'Delay', Default = 3, Min = 1, Max = 20, Rounding = 0})
        Extra:AddToggle('GameVotekick', {Text = 'Join new game on votekick'})
        Extra:AddToggle('ServerHop', {Text = 'Force Server Hop'}):AddKeyPicker('ServerHopKey', {Default = '', SyncToggleState = false, Mode = 'Toggle', Text = 'Server Hop', NoUI = false})
        Extra:AddButton('Join New Game', function()
            local jobid = ""

            local Servers = game.HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)))

            for Index, Value in pairs(Servers.data) do
                if Value.playing ~= Value.maxPlayers and Value.playing ~= nil and Value.playing > 20 and Value.ping < 100 then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Value.id)
                    jobid = tostring(Value.id)
                end
            end

            Library:Notify("Attempting hop to "..string.sub(jobid, 0, 8).."-XXXX-XXXX-XXXX-XXXXXXXXXXXX.", 5, "move")
        end)
    end
end

do -- Settings Tab  
    local MenuGroup = Tabs['Settings']:AddLeftGroupbox('Menu') do
        MenuGroup:AddButton('Unload', function() Library:Unload() end)
        MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' }) 
    end

    do -- Managers
        Library.ToggleKeybind = Options.MenuKeybind
        ThemeManager:SetLibrary(Library)
        SaveManager:SetLibrary(Library)
        SaveManager:IgnoreThemeSettings() 
        SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 
        ThemeManager:SetFolder(shambles.workspace.."/Configs/"..shambles.game)
        SaveManager:SetFolder(shambles.workspace .."/Configs/"..shambles.game)
        SaveManager:BuildConfigSection(Tabs['Settings']) 
        ThemeManager:ApplyToTab(Tabs['Settings'])
    end

    local PlayerList = Tabs.Settings:AddRightGroupbox("Player List") do
        PlayerList:AddDropdown('PlayerList', {Values = {}, Default = 1, Multi = false, Text = 'Player List'})
        PlayerList:AddButton('Refresh', function()
            for i,v in pairs(Players:GetPlayers()) do   
                if not table.find(Options.PlayerList.Values, v.Name) and v.Name ~= LocalPlayer.Name then
                    table.insert(Options.PlayerList.Values, v.Name)
                    Options.PlayerList:SetValues()
                    Options.PlayerList:SetValue(nil)
                end
            end
        end)
        PlayerList:AddButton('Friend', function()
            if not table.find(Friends, Options.PlayerList.Value) then
                table.insert(Friends, Options.PlayerList.Value)
                Library:Notify("Friended player " ..Options.PlayerList.Value.. ".", 2.5)
            elseif table.find(Friends, Options.PlayerList.Value) then
                for i1, v1 in pairs(Options.PlayerList.Values) do
                    if Options.PlayerList.Value == v1 then
                        table.remove(Friends, i1)
                    end
                end
                Library:Notify("Un-Friended player " ..Options.PlayerList.Value.. ".", 2.5)
            end
        end)
        PlayerList:AddButton('Prioritize', function()
            if not table.find(Priority, Options.PlayerList.Value) then
                table.insert(Priority, Options.PlayerList.Value)
                Library:Notify("Prioritized player " ..Options.PlayerList.Value.. ".", 2.5)
            elseif table.find(Priority, Options.PlayerList.Value) then
                for i1, v1 in pairs(Options.PlayerList.Values) do
                    if Options.PlayerList.Value == v1 then
                        table.remove(Priority, i1)
                    end
                end
                Library:Notify("Un-Prioritized player " ..Options.PlayerList.Value.. ".", 2.5)
            end
        end)
    end

    local Interface = Tabs.Settings:AddRightGroupbox("Interface") do
        Interface:AddToggle('InterfaceKeybinds', {Text = 'Keybinds'})
        Interface:AddToggle('InterfaceWatermark', {Text = 'Watermark', Default = true}):AddColorPicker('ColorWatermark', {Default = Color3.fromRGB(0, 140, 255), Title = 'Watermark Color'})
        Interface:AddDropdown('WatermarkIcon', {Values = icons(), Default = 1, Multi = false, Text = 'Custom Logo'})
        Interface:AddButton('Refresh', function()
            Options.WatermarkIcon.Values = icons()
            Options.WatermarkIcon:SetValues()
            Options.WatermarkIcon:SetValue("N/A")
        end)
        Interface:AddInput('WatermarkText', {Default = 'Shambles Haxx | {user} | {fps} fps | {ping} ms | {version}', Numeric = false, Finished = false, Text = 'Custom Watermark', Placeholder = 'Watermark Text', Tooltip = "{user}, {hour}, {minute}, {second}\n{ap}, {month}, {day}, {year}\n{version}, {fps}, {ping}, {game}\n{time}, {date}"})   
        Interface:AddToggle('RainbowAccent', {Text = 'Rainbow Accent'})
        Interface:AddSlider('RainbowSpeed', {Text = 'Rainbow Speed', Default = 40, Min = 1, Max = 50, Rounding = 0})
        SaveManager:LoadAutoloadConfig()
    end 
end

do -- Checks
    if isfile("shambles haxx/Configs/icons/"..Options.WatermarkIcon.Value..".png") then
        Watermark.Icon.Data = readfile("shambles haxx/Configs/icons/"..Options.WatermarkIcon.Value..".png")
    else
        Watermark.Icon.Data = readfile("")
    end

    Options.ServerHopKey:OnClick(function()
        while wait() do
            if Toggles.ServerHop.Value and Options.ServerHopKey:GetState() then
                if not Toggles.ServerHop.Value or not Options.ServerHopKey:GetState() then
                    break
                end

                Library:Notify("Attempting server hop in 3 seconds!", 3, "move")
                
                wait(3)

                if not Toggles.ServerHop.Value or not Options.ServerHopKey:GetState() then
                    Library:Notify("Cancelling server hop!", 3, "move")
                    break
                end

                local jobid = ""

                local Servers = game.HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)))
    
                for Index, Value in pairs(Servers.data) do
                    if Value.playing ~= Value.maxPlayers and Value.playing ~= nil and Value.playing > 20 and Value.ping < 100 then
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Value.id)
                        jobid = tostring(Value.id)
                    end
                end

                Toggles.ServerHop:SetValue(false)

                Library:Notify("Attempting hop to "..string.sub(jobid, 0, 8).."-XXXX-XXXX-XXXX-XXXXXXXXXXXX.", 5, "move")
            end
        end
    end)

    Options.WatermarkIcon:OnChanged(function()
        if isfile("shambles haxx/Configs/icons/"..Options.WatermarkIcon.Value..".png") then
            Watermark.Icon.Data = readfile("shambles haxx/Configs/icons/"..Options.WatermarkIcon.Value..".png")
        else
            Watermark.Icon.Data = readfile("")
        end
    end)

    Library:SetWatermarkVisibility(false)
    Library.KeybindFrame.Visible = Toggles.InterfaceKeybinds.Value

    Toggles.InterfaceKeybinds:OnChanged(function()
        Library.KeybindFrame.Visible = Toggles.InterfaceKeybinds.Value
    end)   

    Toggles.AutoDeploy:OnChanged(function()
        if Toggles.AutoDeploy.Value then
            game_client.character_interface.spawn()
        end

        alive = Toggles.AutoDeploy.Value
        t = tick()
    end)

    load1 = tick()

    Library:OnUnload(function()
        if PLRDS[v] then
            for i, v in pairs(PLRDS[v]) do
                v:Remove()
            end
        end

        for i,v in pairs(Crosshair) do
            if v ~= nil then
                v:Remove()
            end
        end

        local third_person_object = fake_rep_object:getThirdPersonObject()
        if third_person_object then
            local character_model = third_person_object:popCharacterModel()
            character_model:Destroy()
            fake_rep_object:despawn()
        end

        for i,v in pairs(FCS) do
            v:Remove()
        end

        for i,v in pairs(Watermark) do
            v:Remove()
        end

        Library.Unloaded = true
    end)
end

wait(0.1) -- Keep this because game breaks cause the UI loads slower then the modules and then Options table doesn't exist.

do
    local send = game_client.network.send

    for _,Player in pairs(Players:GetPlayers()) do
        Ut.AddToPlayer(Player)
    end
    Players.PlayerAdded:Connect(Ut.AddToPlayer)

    Players.PlayerRemoving:Connect(function(Player)
        if PLRDS[Player] then
            for i, v in pairs(PLRDS[Player]) do
                v:Remove()
            end

            PLRDS[Player] = nil
        end
    end)

    for _,v in pairs(game.Workspace.Ignore.GunDrop:GetChildren()) do
        Ut.AddToGun(v)
    end

    game.Workspace.Ignore.GunDrop.ChildAdded:Connect(Ut.AddToGun)

    game.Workspace.Ignore.GunDrop.ChildRemoved:Connect(function(Gun)
        if DWPS[Gun] then
            for i,v in pairs(DWPS[Gun]) do
                if v then
                    v:Remove()
                end
            end

            DWPS[Gun] = nil
        end
    end)

    local solve = debug.getupvalue(game_client.physics.timehit, 2);
    local beams = {}

    task.spawn(function()
        while task.wait(Options.ChatSpamDelay.Value) do
            if Toggles.ChatSpam.Value and Library.Unloaded ~= false and game_client.LocalPlayer.isAlive() then
                local lol = ""
    
                if Toggles.ChatSpamEmojis.Value and Toggles.ChatSpamSymbols.Value then
                    lol = string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)])
                elseif Toggles.ChatSpamEmojis.Value then
                    lol = string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. phrases[math.random(1, #phrases)] .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)]) .. string.sub(emojis[math.random(1, #emojis)]:gsub('\"', ''), 1, stringsub_table[math.random(1, 10)])
                elseif Toggles.ChatSpamSymbols.Value then
                    lol = string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. phrases[math.random(1, #phrases)] .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10)) .. string.sub(symbols[math.random(1, #symbols)], 1, math.random(1, 10))
                else
                    lol = phrases[math.random(1, #phrases)] .. " " .. phrases[math.random(1, #phrases)] .. " " .. phrases[math.random(1, #phrases)]
                end
    
                game_client.network.send(nil, "chatted", lol) 
            end
        end
    end)

    function isVisible(position, ignore)
        return #Camera:GetPartsObscuringTarget({ position }, ignore) == 0;
    end

    function NameToIcon(name)
        local tempimage = gunicons[name]
    
        if tempimage ~= nil then
            local new_w = tempimage[2]
            local new_h = tempimage[3]
    
            return {data = tempimage[1], w = new_w, h = new_h}
        end
        return nil
    end

    function CreateBeam(origin_att, ending_att, texture)
        local beam = Instance.new("Beam")
        beam.Texture = texture or "http://www.roblox.com/asset/?id=446111271"
        beam.TextureMode = Enum.TextureMode.Wrap
        beam.TextureSpeed = 8
        beam.LightEmission = 1
        beam.LightInfluence = 1
        beam.TextureLength = 12
        beam.FaceCamera = true
        beam.Enabled = true
        beam.ZOffset = -1
        beam.Transparency = NumberSequence.new((1 - Options.BulletTracersTrans.Value / 255),(1 - Options.BulletTracersTrans.Value / 255))
        beam.Color = ColorSequence.new(Options.ColorBulletTracers.Value, Options.ColorBulletTracers.Value)
        beam.Attachment0 = origin_att
        beam.Attachment1 = ending_att
        Debris:AddItem(beam, 3)
        Debris:AddItem(origin_att, 3)
        Debris:AddItem(ending_att, 3)

        local speedtween = TweenInfo.new(5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
        Tween:Create(beam, speedtween, { TextureSpeed = 2 }):Play()
        beam.Parent = workspace
        table.insert(beams, { beam = beam, time = tick() })
        return beam
    end

    function find_2d_distance( pos1, pos2 )
        local dx = pos1.X - pos2.X
        local dy = pos1.Y - pos2.Y
        return math.sqrt ( dx * dx + dy * dy )
    end

    function getClosest(dir, origin, ignore)
        local _position, _entry;

        game_client.replication.operateOnAllEntries(function(player, entry)
            local tpObject = entry and entry._thirdPersonObject;
            local character = tpObject and tpObject._character;
            if character and player.Team ~= LocalPlayer.Team then
                local part = Options.SilentHitscan.Value == "Head" and character["Head"] or Options.SilentHitscan.Value == "Torso" and character["Torso"] or Options.SilentHitscan.Value == "Closest" and character[math.random() > 0.5 and "Head" or "Torso"]
                local _, OnScreen = Camera:WorldToViewportPoint(character.Torso.Position)
                if not (Toggles.SilentVisCheck.Value and not isVisible(part.Position, ignore)) and math.random(1, 100) <= Options.SilentHitchance.Value then
                    if OnScreen then
                        local product = dir.Unit:Dot((part.Position - origin).Unit);
                        local angle = math.deg(math.acos(product));
                        if find_2d_distance(Camera:WorldToViewportPoint(character.Head.Position), FovPos) > Options.SilentFov.Value * 2 then
                        else
                            _position = part.Position;
                            _entry = entry;
                        end
                    end
                end
            end
        end);

        return _position, _entry;
    end

    function Mouse_Move(pos, smoothx, smoothy)
        local mouse = LocalPlayer:GetMouse()
        local targetPos = Camera:WorldToScreenPoint(pos)
        local mousePos = Camera:WorldToScreenPoint(mouse.Hit.p)
        mousemoverel((targetPos.X - mousePos.X) / smoothx, (targetPos.Y - mousePos.Y) / smoothy)
    end

    function trajectory(dir, velocity, accel, speed)
        local t1, t2, t3, t4 = solve(
            accel:Dot(accel) * 0.25,
            accel:Dot(velocity),
            accel:Dot(dir) + velocity:Dot(velocity) - speed^2,
            dir:Dot(velocity) * 2,
            dir:Dot(dir));

        local time = (t1>0 and t1) or (t2>0 and t2) or (t3>0 and t3) or t4;
        local bullet = (dir + velocity*time + 0.5*accel*time^2) / time;
        return bullet, time;
    end 

    function get_character(player)
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
    end

    function get_health(player)
        if player == LocalPlayer and fake_rep_object ~= nil then
            return fake_rep_object:getHealth()
        else
            local entry = game_client.replication_interface.getEntry(player)

            if entry then
                return entry:getHealth()
            end
        end
    end

    function get_alive(player)
        if player == LocalPlayer and fake_rep_object ~= nil then
            return fake_rep_object._alive
        else
            local entry = game_client.replication_interface.getEntry(player)

            if entry then
                return entry._alive
            end
        end
    end

    function get_receivedpos(player) 
        local entry = game_client.replication_interface.getEntry(player)

        if entry then
            local third_person_object = entry._thirdPersonObject
            if third_person_object then
                return third_person_object._replicationObject._receivedPosition, third_person_object._replicationObject._receivedFrameTime, third_person_object._replicationObject._velspring._p0
            end
        end
    end 

    function get_weapon(player)
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
    end

    function calculate_player_bounding_box(character)
        local Pos = Camera:WorldToViewportPoint(character.Torso.Position)
        local CSize = (Camera:WorldToViewportPoint(character.Torso.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(character.Torso.Position + Vector3.new(0, 2.6, 0)).Y) / 2
        local BoxSize = Vector2.new(math.floor(CSize * 1.2), math.floor(CSize * 2))
        local BoxPos = Vector2.new(math.floor(Pos.X - CSize * 1 / 2), math.floor(Pos.Y - CSize * 1.6 / 2))

        return BoxPos, BoxSize
    end

    function chams(part, color, trans, reflectance, material)
        part.Material = material == "ForceField" and "ForceField" or material == "Neon" and "Neon" or material == "Plastic" and "SmoothPlastic" or "Glass"
        part.Color = color
        part.Transparency =  1 - trans
        part.Reflectance = reflectance / 10
        if part:IsA("Part") and part:FindFirstChild("Mesh") and not part:IsA("BlockMesh") then 
            part.Mesh.VertexColor = Vector3.new(color.R, color.G, color.B)
            if material == "Plastic" or material == "Glass" then 
                part.Mesh.TextureId = "" 
            end 
        end
        if part:FindFirstChildWhichIsA("Texture") or part:FindFirstChildWhichIsA("Texture") then
            if material == "ForceField" then
                part.Transparency = 1
            else
                part.Transparency = 1 - trans
            end
        end
        if part:FindFirstChildWhichIsA("SpecialMesh") then
            part.Mesh.VertexColor = Vector3.new(color.R, color.G, color.B)
            if part.Name == "Head" or part.name == "Torso" then
                part:FindFirstChildWhichIsA("SpecialMesh").TextureId = "rbxassetid://5614184106"
            end
        end
        if (material == "Plastic" or material == "Glass") and part:FindFirstChild("Mesh") then 
            part:FindFirstChild("Mesh").TextureId = "" 
        end 
    end
	
	function findtextrandom(text)
		if text:find(' @r ') then 
			local b = text:split(' @r ')
			return b[math.random(#b)]
		else 
			return text
		end
	end

	function textboxtriggers(text)
        local triggers = {
            ['{user}'] = shambles.username,
            ['{hour}'] = os.date("%H"),
            ['{minute}'] = os.date("%M"),
            ['{second}'] = os.date("%S"),
            ['{ap}'] = os.date("%p"),
            ['{month}'] = os.date("%b"),
            ['{day}'] = os.date("%d"),
            ['{year}'] = os.date("%Y"),
            ['{version}'] = shambles.version,
            ['{fps}'] = fps,
            ['{ping}'] = game:GetService('Stats') ~= nil and math.floor(game:GetService('Stats').Network.ServerStatsItem["Data Ping"]:GetValue()) or "0",
            ['{game}'] = shambles.game,
            ['{time}'] = os.date("%H:%M:%S"),
            ['{date}'] = os.date("%b. %d, %Y")
         }        

		for a,b in next, triggers do 
			text = string.gsub(text, a, b)
		end

		return findtextrandom(text)
	end

    function rotateVector2(v2, r)
        local c = math.cos(r);
        local s = math.sin(r);
        return Vector2.new(c * v2.X - s*v2.Y, s*v2.X + c*v2.Y)
    end

    function floor_vector2(vector2)
        return vector2(math.floor(vector2.X), math.floor(vector2.Y))
    end

    function raycast(origin, direction, filterlist, whitelist)
        raycastparameters.FilterDescendantsInstances = filterlist
        raycastparameters.FilterType = Enum.RaycastFilterType[whitelist and "Whitelist" or "Blacklist"]
        local result = workspace:Raycast(origin, direction, raycastparameters)
        return result and result.Instance, result and result.Position, result and result.Normal
    end
    
    function rage:bulletcheck(o, t, p)
        if p <= 0 then
            return false
        end
        
        local ve = t - o
        local n = ve.Unit
        local h, po = raycast(o, ve, ignorething)
    
        if h then
            if h.CanCollide or h.Transparency == 0 then
                local e = h.Size.Magnitude * n
                local nh, dp = raycast(po + e, -e, {h}, true)
                local m = (dp - po).Magnitude
    
                if m >= p then
                    return false
                else
                    p = p - m
                end
            end
    
            return rage:bulletcheck(po + n / 100, t, p)
        end
    
        return true
    end

    function rage:scanplayer(s, d, r, e)
        local c = CFrame.new(s, d)
    
        for p = 1, 2 do
            p = (p - 1) * 45
            local cf = c * CFrame.Angles(0, math.rad(p), 0)
    
            for i = 1, 2 do
                i = i * 45
                
                for k, o in pairs({
                    cf,
                    cf * CFrame.Angles(math.rad(i), 0, 0),
                    cf * CFrame.Angles(-math.rad(i), 0, 0)
                }) do
                    local v = (o * CFrame.new(0, 0, -r)).Position
    
                    if rage:bulletcheck(v, d, e) then
                        return v
                    end
                end
                
                for k, o in pairs({
                    cf,
                    cf * CFrame.Angles(0, 0, -math.rad(i)),
                    cf * CFrame.Angles(0, 0, math.rad(i))
                }) do
                    local v = (o * CFrame.new(r, 0, 0)).Position
    
                    if rage:bulletcheck(v, d, e) then
                        return v
                    end
                    if p == 0 then
                        local q = (o * CFrame.new(-r, 0, 0)).Position
    
                        if rage:bulletcheck(q, d, e) then
                            return q
                        end
                    end
                end
            end
        end
        
        return s
    end

    function rage:reload(weapon)
        local magSize = weapon:getWeaponStat("magsize")
        local newCount = (magSize + (weapon:getWeaponStat("chamber") and 1 or 0)) - weapon._magCount
        
        if weapon._spareCount > newCount then
            weapon._magCount += newCount
            weapon._spareCount -= newCount
        else
            weapon._magCount += weapon._spareCount
            weapon._spareCount = 0
        end
        
        game_client.network:send("reload")
        game_client.HudStatusInterface.updateAmmo(weapon)
    end

    function rage:fireratecheck(firerate)
        local curTick = tick()
        local future = curTick + (60 / firerate)
        
        local shoot = curTick > rage.lastf
        rage.lastf = shoot and future or rage.lastf

        return shoot
    end

    function rage:KnifeTargets(range, visible, hitscan)
        local results = {}
    
        for i, v in ipairs(Players:GetPlayers()) do
            if Toggles.IgnoreFriends.Value and table.find(Friends, v.Name) then return end
            if not table.find(Priority, v.Name) and Toggles.PriorityOnly.Value then continue end
            
            if v.Team ~= LocalPlayer.Team and game_client.LocalPlayer.isAlive() then
                local Character = get_character(v)
                if Character then
                    local target_pos = Character.Torso.Position
                    local target_direction = target_pos - Camera.CFrame.Position
                    local target_dist = (target_pos - Camera.CFrame.Position).Magnitude
                    if range ~= 26 and target_dist > range then
                        continue
                    end
                    local ignore = { game.Players.LocalPlayer, Camera, workspace.Ignore, workspace.Players }
    
                    local part1, ray_pos = workspace:FindPartOnRayWithIgnoreList(Ray.new(Camera.CFrame.Position, target_direction), ignore)
        
                    if part and visible then
                        continue
                    end
        
                    local part2, ray_pos = workspace:FindPartOnRayWithIgnoreList(Ray.new(Camera.CFrame.Position - Vector3.new(0, 2, 0), target_direction), ignore)
        
                    local ray_distance = (target_pos - ray_pos).Magnitude
                    table.insert(results, {
                        player = v,
                        part = Character[hitscan],
                        tppos = ray_pos,
                        direction = target_direction,
                        dist = target_dist,
                        insight = ray_distance < 15 and part1 == part2,
                    })
                end
            end
        end
    
        return results
    end

    function rage:KnifeTarget(target)
        if target ~= nil and target.part ~= nil and curgun == 3 and game_client.LocalPlayer.isAlive() then
            send(game_client.network, "stab")
            send(game_client.network, "knifehit", target.player, target.part.Name)
        end
    end

    do -- Cheat Functions
        do -- Rage Bot   
            Library:GiveSignal(rs.RenderStepped:Connect(function()  
                for i,v in pairs(Players:GetPlayers()) do
                    if Toggles.IgnoreFriends.Value and table.find(Friends, v.Name) then return end
                    if not table.find(Priority, v.Name) and Toggles.PriorityOnly.Value then continue end
                    if Toggles.RageEnabled.Value and Options.RageKey:GetState() and get_character(v) and get_alive(v) and  v.Team ~= LocalPlayer.Team and v ~= LocalPlayer and game_client.LocalPlayer.isAlive(v) and curgun <= 2 then
                        if Toggles.RageFirePos.Value then
                            RPos = rage:scanplayer(BarrelPos, get_character(v)[Options.RageHitscan.Value].Position, Options.RageFirePosAmount.Value, game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.penetrationdepth)
                        else
                            RPos = BarrelPos
                        end
                        local traj = game_client.physics.trajectory(RPos, game_client.PBS.bulletAcceleration, get_character(v)[Options.RageHitscan.Value].Position, game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.bulletspeed)                   
                        
                        tableinfo.firepos = RPos

                        if game_client.WCI:getController()._activeWeaponRegistry[curgun]._magCount == 0 then
                            rage:reload(game_client.WCI:getController()._activeWeaponRegistry[curgun])
                        end
                        
                        if rage:bulletcheck(RPos, get_character(v)[Options.RageHitscan.Value].Position, game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.penetrationdepth) and 
                        rage:fireratecheck(type(game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.firerate) == "table" and 
                        game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.firerate[1] or 
                        game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.firerate) and 
                        game_client.WCI:getController()._activeWeaponRegistry[curgun]._magCount ~= 0 then
                            debug.setupvalue(game_client.firearm_object.fireRound, 10, debug.getupvalue(game_client.firearm_object.fireRound, 10) + 1)
                            tableinfo.bullets[1] = {
                                traj.Unit * game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.bulletspeed, 
                                debug.getupvalue(game_client.firearm_object.fireRound, 10),
                            }
                            
                            game_client.WCI:getController()._activeWeaponRegistry[curgun]._magCount -= 1

                            rage.target = v

                            game_client.network:send("newbullets", tableinfo, game_client.game_clock.getTime())
                            for i = 1, #tableinfo.bullets do
                                game_client.network:send("bullethit", v, get_character(v)[Options.RageHitscan.Value].Position, Options.RageHitscan.Value, tableinfo.bullets[i][2], game_client.game_clock.getTime())
                            end
                        end
                    end
				end
            end))
        end

        do -- Knife Bot
            Library:GiveSignal(rs.RenderStepped:Connect(function()
                if Toggles.KnifeBot.Value and Options.KnifeKey:GetState() then
                    local target = rage:KnifeTargets(Options.KnifeRange.Value, true, Options.KnifeScan.Value)[1]
                    rage:KnifeTarget(target)
                end 
            end))
        end
        
        do -- ESP Players
            Library:GiveSignal(rs.RenderStepped:Connect(function()
                if game_client.LocalPlayer.isAlive() then
                    tableinfo.camerapos = game_client.LocalPlayer.getCharacterObject()._rootPart.Parent.Head.Position
                    tableinfo.firepos = RPos
                end
                
                for i,v in pairs(Players:GetPlayers()) do
                    local Group = "Enemy"
                    local tdata = teamdata[1]
                    
                    if v.Team == "Ghosts" then
                        tdata = teamdata[2]
                    end

                    if v == LocalPlayer then
                        Group = "Local"
                    elseif v.Team == LocalPlayer.Team then
                        Group = "Team"
                    end

                    if Group == "Local" and PLRDS[v] and game_client.LocalPlayer.isAlive() and fake_rep_object ~= nil then
                        local PLRD = PLRDS[v]
                        for _,v in pairs (PLRD) do
                            if v.Visible ~= false then
                                v.Visible = false
                            end
                        end
                        
                        local Character = get_character(LocalPlayer)
                        if Character then
                            local _, OnScreen = Camera:WorldToViewportPoint(Character.Torso.Position)
                            if OnScreen then
                                local Pos, Size = calculate_player_bounding_box(Character)
                                if Pos and Size then
                                    local Cur_Health, Max_Health = get_health(v)
                                    local Box = PLRD.Box
                                    local BoxFill = PLRD.BoxFill
                                    local BoxOutline = PLRD.BoxOutline
                                    local Name = PLRD.Name
                                    local Weapon = PLRD.Weapon
                                    local Health = PLRD.Health
                                    local HealthOutline = PLRD.HealthOutline
                                    local HealthNumber = PLRD.HealthNumber
                                    local Distance = PLRD.Distance
                                    local Icon = PLRD.Icon
                                    local IconImg = NameToIcon(get_weapon(v))
                                    local yadd = 0
                                    local lvl = 0
                                    
                                    for _,t in pairs(tdata) do
                                        if not t:IsA("UIListLayout") then
                                            if t:FindFirstChild("TextPlayer") and t:FindFirstChild("TextPlayer").Text == v.Name then
                                                lvl = t.TextRank.Text
                                            end
                                        end
                                    end


                                    local torsopos = Camera:WorldToViewportPoint(Character.Torso.Position)

                                    for _,s in pairs (skeleton_parts) do
                                        if Toggles[Group.."EspSkeleton"].Value and Character:FindFirstChild("Torso") and torsopos then
                                            local line = PLRD[s]
                                            local pos = Camera:WorldToViewportPoint(Character:FindFirstChild(s).Position)

                                            line.From = Vector2.new(pos.x, pos.y)
                                            line.To = Vector2.new(torsopos.x, torsopos.y)
                                            if line.Visible ~= true then
                                                line.Visible = true
                                            end
                                            if line.Thickness ~= 1 then
                                                line.Thickness = 1
                                            end
                                            if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                                if line.Color ~= Options.ColorTarget.Value then
                                                    line.Color = Options.ColorTarget.Value
                                                end
                                            else
                                                if line.Color ~= Options[Group.."ColorSkeleton"].Value then
                                                    line.Color = Options[Group.."ColorSkeleton"].Value
                                                end
                                            end
                                        else
                                            PLRD[s].Visible = false
                                        end
                                    end
                                    
                                    if Toggles[Group.."EspChams"].Value then
                                        for _,q in pairs(Character.Cosmetics:GetChildren()) do
                                            --if q.Name ~= "Head" then
                                                chams(q, Options.LocalColorChams.Value, Options.LocalEspChamsTrans.Value / 255, Options.LocalEspChamsReflectance.Value, Options.LocalEspChamsMaterial.Value)
                                            --end
                                        end
                                        for _,q in pairs(Character:GetChildren()) do
                                            if (q:IsA("BasePart") or q:IsA("MeshPart") or q:IsA("Part")) and q.Transparency ~= 1 then
                                                chams(q, Options.LocalColorChams.Value, Options.LocalEspChamsTrans.Value / 255, Options.LocalEspChamsReflectance.Value, Options.LocalEspChamsMaterial.Value)
                                            
                                                for _,a in pairs(q:GetChildren()) do
                                                    if a.Name == "Pant" or a.Name == "Shirt" then
                                                        a:Destroy()
                                                    end
                                                end
                                            elseif q:IsA("Texture") or q:IsA("Decal") then
                                                q.Transparency = 0.999999999999
                                            end
                                        end
                                    end

                                    if Toggles[Group.."EspHighlights"].Value then
                                        if not game.CoreGui:FindFirstChild(v.Name) then
                                            local Highlight = Instance.new("Highlight", game.CoreGui)
                                            if Highlight.Name ~= v.Name then
                                                Highlight.Name = v.Name
                                            end
                                        end

                                        if game.CoreGui[v.Name].Adornee ~= Character then
                                            game.CoreGui[v.Name].Adornee = Character
                                        end

                                        if Toggles[Group.."EspHighlightsSine"].Value then	
                                            game.CoreGui[v.Name].FillTransparency = 1 - (math.sin(tick() * 5) + 1) / 2
                                        else
                                            if game.CoreGui[v.Name].FillTransparency ~= 1 - Options[Group.."EspHighlightsTrans"].Value / 255 then
                                                game.CoreGui[v.Name].FillTransparency = 1 - Options[Group.."EspHighlightsTrans"].Value / 255
                                            end
                                        end
                    
                                        if game.CoreGui[v.Name].Adornee ~= Character then
                                            game.CoreGui[v.Name].Adornee = Character
                                        end

                                        if game.CoreGui[v.Name].Enabled ~= false then
                                            game.CoreGui[v.Name].Enabled = false
                                        end

                                        if game.CoreGui[v.Name].OutlineTransparency ~= 1 - Options[Group.."EspOutlineHighlightsTrans"].Value / 255 then
                                            game.CoreGui[v.Name].OutlineTransparency = 1 - Options[Group.."EspOutlineHighlightsTrans"].Value / 255
                                        end

                                        if game.CoreGui[v.Name].Enabled ~= true then
                                            game.CoreGui[v.Name].Enabled = true
                                        end
                                        
                                        if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                            if game.CoreGui[v.Name].FillColor ~= Options.ColorTarget.Value then
                                                game.CoreGui[v.Name].FillColor = Options.ColorTarget.Value
                                            end
                                            
                                            if game.CoreGui[v.Name].OutlineColor ~= Options.ColorTarget.Value then
                                                game.CoreGui[v.Name].OutlineColor = Options.ColorTarget.Value
                                            end
                                        else
                                            if game.CoreGui[v.Name].FillColor ~= Options[Group.."ColorHighlights"].Value then
                                                game.CoreGui[v.Name].FillColor = Options[Group.."ColorHighlights"].Value
                                            end
                                            
                                            if game.CoreGui[v.Name].OutlineColor ~= Options[Group.."ColorHighlightsOutline"].Value then
                                                game.CoreGui[v.Name].OutlineColor = Options[Group.."ColorHighlightsOutline"].Value
                                            end
                                        end
                                    else
                                        if game.CoreGui:FindFirstChild(v.Name) then
                                            if game.CoreGui[v.Name].Enabled ~= false then
                                                game.CoreGui[v.Name].Enabled = false
                                            end
                                        end
                                    end

                                    if Toggles[Group.."EspIcon"].Value and IconImg ~= nil then
                                        --if Icon.Data ~= IconImg.data then
                                            Icon.Data = IconImg.data
                                        --end

                                        if Icon.Size ~= Vector2.new(IconImg.w, IconImg.h) then
                                            Icon.Size = Vector2.new(IconImg.w, IconImg.h)
                                        end

                                        if Icon.Position ~= Vector2.new(Pos.X + (Size.X / 2) - (IconImg.w / 2), Pos.Y + Size.Y + 4) then
                                            Icon.Position = Vector2.new(Pos.X + (Size.X / 2) - (IconImg.w / 2), Pos.Y + Size.Y + 4)
                                        end

                                        Icon.Visible = true

                                        yadd = yadd + IconImg.h + 4
                                    end

                                    if Toggles[Group.."EspWeapon"].Value then
                                        Weapon.Visible = true
                                        if Weapon.Font ~= Drawing.Fonts[Options.TextFont.Value] then
                                            Weapon.Font = Drawing.Fonts[Options.TextFont.Value]
                                        end
                                        if Weapon.Size ~= Options.TextSize.Value then
                                            Weapon.Size = Options.TextSize.Value
                                        end

                                        if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                            if Weapon.Color ~= Options.ColorTarget.Value then
                                                Weapon.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Weapon.Color ~= Options[Group.."ColorWeapon"].Value then
                                                Weapon.Color = Options[Group.."ColorWeapon"].Value
                                            end
                                        end

                                        Weapon.Position = Vector2.new(Pos.X + (Size.X / 2), Pos.Y + Size.Y + 2 + yadd)

                                        if Options.TextCase.Value == "Normal" then
                                            if Weapon.Text ~= get_weapon(v) then
                                                Weapon.Text = get_weapon(v)
                                            end
                                        elseif Options.TextCase.Value == "UPPERCASE" then
                                            if Weapon.Text ~= string.upper(get_weapon(v)) then
                                                Weapon.Text = string.upper(get_weapon(v))
                                            end
                                        elseif Options.TextCase.Value == "lowercase" then
                                            if Weapon.Text ~= string.lower(get_weapon(v)) then
                                                Weapon.Text = string.lower(get_weapon(v))
                                            end
                                        end
                                    end

                                    if Toggles[Group.."EspBox"].Value then
                                        if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                            if Box.Color ~= Options.ColorTarget.Value then
                                                Box.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Box.Color ~= Options[Group.."ColorBox"].Value then
                                                Box.Color = Options[Group.."ColorBox"].Value
                                            end
                                        end
                                        Box.Position = Pos
                                        Box.Size = Size
                                        Box.Visible = true

                                        BoxOutline.Position = Pos
                                        BoxOutline.Size = Size
                                        BoxOutline.Visible = true
                                    end

                                    if Toggles[Group.."EspName"].Value then
                                        Name.Position = Vector2.new(Size.X / 2 + Pos.X, Pos.Y - 5 - Name.TextBounds.Y)
                                        if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                            if Name.Color ~= Options.ColorTarget.Value then
                                                Name.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Name.Color ~= Options[Group.."ColorName"].Value then
                                                Name.Color = Options[Group.."ColorName"].Value
                                            end
                                        end 


                                        if Name.Font ~= Drawing.Fonts[Options.TextFont.Value] then
                                            Name.Font = Drawing.Fonts[Options.TextFont.Value]
                                        end
                                        if Name.Size ~= Options.TextSize.Value then
                                            Name.Size = Options.TextSize.Value
                                        end
                                        Name.Visible = true
                                        if Options.TextCase.Value == "Normal" then
                                            if Name.Text ~= v.Name then
                                                Name.Text = v.Name
                                            end
                                        elseif Options.TextCase.Value == "UPPERCASE" then
                                            if Name.Text ~= string.upper(v.Name) then
                                                Name.Text = string.upper(v.Name)
                                            end
                                        elseif Options.TextCase.Value == "lowercase" then
                                            if Name.Text ~= string.lower(v.Name) then
                                                Name.Text = string.lower(v.Name)
                                            end
                                        end
                                    end

                                    if Toggles[Group.."EspHealthBar"].Value then
                                        Health.From = Vector2.new(Pos.X - 4, Pos.Y + Size.Y)
                                        Health.To = Vector2.new(Pos.X - 4, Health.From.Y - (Cur_Health / Max_Health) * Size.Y)
                                        Health.Visible = true
                                        if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                            if Health.Color ~= Options.ColorTarget.Value then
                                                Health.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Health.Color ~= Options[Group.."ColorHealthBar"].Value then
                                                Health.Color = Options[Group.."ColorHealthBar"].Value
                                            end
                                        end

                                        HealthOutline.From = Vector2.new(Health.From.X, Pos.Y + Size.Y + 1)
                                        HealthOutline.To = Vector2.new(Health.From.X, (Health.From.Y - 1 * Size.Y) -1)
                                        HealthOutline.Visible = true
                                        if HealthOutline.Thickness ~= 3 then
                                            HealthOutline.Thickness = 3
                                        end
                                    end

                                    if Toggles[Group.."EspHealthNumber"].Value and Cur_Health <= Options.HpVis.Value then
                                        HealthNumber.Visible = true
                                        if HealthNumber.Font ~= Drawing.Fonts[Options.TextFont.Value] then
                                            HealthNumber.Font = Drawing.Fonts[Options.TextFont.Value]
                                        end
                                        if HealthNumber.Size ~= Options.TextSize.Value then
                                            HealthNumber.Size = Options.TextSize.Value
                                        end
                                        if HealthNumber.Text ~= tostring(math.floor(Cur_Health)) then
                                            HealthNumber.Text = tostring(math.floor(Cur_Health))
                                        end
                                        if HealthNumber.Center ~= false then
                                            HealthNumber.Center = false
                                        end
                                        if Toggles[Group.."EspHealthBar"].Value then
                                            HealthNumber.Position = Vector2.new(Pos.X - 6 - HealthNumber.TextBounds.X, Health.To.Y - 3)
                                        else
                                            HealthNumber.Position = Vector2.new(Pos.X - 6 - HealthNumber.TextBounds.X, Pos.Y - 3)
                                        end

                                        if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                            if HealthNumber.Color ~= Options.ColorTarget.Value then
                                                HealthNumber.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if HealthNumber.Color ~= Options[Group.."ColorHealthNumber"].Value then
                                                HealthNumber.Color = Options[Group.."ColorHealthNumber"].Value
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if game.CoreGui:FindFirstChild(v.Name) then
                                game.CoreGui[v.Name]:Destroy()
                            end
    
                            if PLRDS[v] then
                                for i, v in pairs(PLRDS[v]) do
                                    if v.Visible ~= false then
                                        v.Visible = false
                                    end
                                end
                            end    
                        end
                    else
                        if game.CoreGui:FindFirstChild(v.Name) then
                            game.CoreGui[v.Name]:Destroy()
                        end

                        if PLRDS[v] then
                            for i, v in pairs(PLRDS[v]) do
                                if v.Visible ~= false then
                                    v.Visible = false
                                end
                            end
                        end
                    end

                    if Group ~= "Local" and Toggles[Group.."EspEnabled"].Value and PLRDS[v] and game_client.LocalPlayer.isAlive() then
                        local PLRD = PLRDS[v]
                        for _,v in pairs (PLRD) do
                            if v.Visible ~= false then
                                v.Visible = false
                            end
                        end

                        local Character = get_character(v)
                        local Alive = get_alive(v)
                        if Character and Alive then
                            local _, OnScreen = Camera:WorldToViewportPoint(Character.Torso.Position)
                            if OnScreen then
                                local Pos, Size = calculate_player_bounding_box(Character)
                                if Pos and Size then
                                    local Cur_Health, Max_Health = get_health(v)
                                    local Box = PLRD.Box
                                    local BoxFill = PLRD.BoxFill
                                    local BoxOutline = PLRD.BoxOutline
                                    local Name = PLRD.Name
                                    local Weapon = PLRD.Weapon
                                    local Health = PLRD.Health
                                    local HealthOutline = PLRD.HealthOutline
                                    local HealthNumber = PLRD.HealthNumber
                                    local Distance = PLRD.Distance
                                    local Icon = PLRD.Icon
                                    local Level = PLRD.Level
                                    local IconImg = NameToIcon(get_weapon(v))
                                    local yadd = 0
                                    local lvl = 0
                                    
                                    for _,t in pairs(tdata) do
                                        if not t:IsA("UIListLayout") then
                                            if t:FindFirstChild("TextPlayer") and t:FindFirstChild("TextPlayer").Text == v.Name then
                                                lvl = t.TextRank.Text
                                            end
                                        end
                                    end

                                    local torsopos = Camera:WorldToViewportPoint(Character.Torso.Position)
                                    
                                    for _,s in pairs (skeleton_parts) do
                                        if Toggles[Group.."EspSkeleton"].Value and Character:FindFirstChild("Torso") and torsopos == Camera:WorldToViewportPoint(Character.Torso.Position) then
                                            local line = PLRD[s]
                                            local pos = Camera:WorldToViewportPoint(Character:FindFirstChild(s).Position)

                                            line.From = Vector2.new(pos.x, pos.y)
                                            line.To = Vector2.new(torsopos.x, torsopos.y)
                                            if line.Visible ~= true then
                                                line.Visible = true
                                            end
                                            if line.Thickness ~= 1 then
                                                line.Thickness = 1
                                            end
                                            if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                                if line.Color ~= Options.ColorTarget.Value then
                                                    line.Color = Options.ColorTarget.Value
                                                end
                                            else
                                                if line.Color ~= Options[Group.."ColorSkeleton"].Value then
                                                    line.Color = Options[Group.."ColorSkeleton"].Value
                                                end
                                            end
                                        else
                                            PLRD[s].Visible = false
                                        end
                                    end

                                    if Toggles[Group.."EspChams"].Value then
                                        for _,q in pairs(Character:GetChildren()) do
                                            if (q:IsA("BasePart") or q:IsA("MeshPart") or q:IsA("Part")) and q.Transparency ~= 1 then
                                                if not q:FindFirstChildWhichIsA("BoxHandleAdornment") then
                                                    local Cham = Instance.new("BoxHandleAdornment", q)
                                                    Cham.Name = "Cham"
                                                end

                                                if q:FindFirstChildWhichIsA("BoxHandleAdornment") then
                                                    if q.Cham.Parent ~= q then
                                                        q.Cham.Parent = q
                                                    end

                                                    if q.Cham.Adornee ~= q then
                                                        q.Cham.Adornee = q
                                                    end

                                                    if q.Cham.Transparency ~=  1 - Options[Group.."EspChamsTrans"].Value / 255 then
                                                        q.Cham.Transparency =  1 - Options[Group.."EspChamsTrans"].Value / 255
                                                    end

                                                    if q.Cham.Color3 ~= Options[Group.."ColorChams"].Value then
                                                        q.Cham.Color3 = Options[Group.."ColorChams"].Value
                                                    end

                                                    if q.Cham.Size ~= q.Size * 1.01 then
                                                        q.Cham.Size = q.Size * 1.01
                                                    end

                                                    if q.Cham.ZIndex ~= 4 then
                                                        q.Cham.ZIndex = 4
                                                    end

                                                    if q.Cham.AlwaysOnTop ~= true then
                                                        q.Cham.AlwaysOnTop = true
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        for _,q in pairs(Character:GetChildren()) do
                                            if q:FindFirstChildWhichIsA("BoxHandleAdornment") then
                                                q.Cham:Destroy()
                                            end
                                        end
                                    end

                                    if Toggles[Group.."EspHighlights"].Value then
                                        if not game.CoreGui:FindFirstChild(v.Name) then
                                            local Highlight = Instance.new("Highlight", game.CoreGui)
                                            if Highlight.Name ~= v.Name then
                                                Highlight.Name = v.Name
                                            end
                                        end

                                        if game.CoreGui[v.Name].Adornee ~= Character then
                                            game.CoreGui[v.Name].Adornee = Character
                                        end

                                        if Toggles[Group.."EspHighlightsSine"].Value then	
                                            game.CoreGui[v.Name].FillTransparency = 1 - (math.sin(tick() * 5) + 1) / 2
                                        else
                                            if game.CoreGui[v.Name].FillTransparency ~= 1 - Options[Group.."EspHighlightsTrans"].Value / 255 then
                                                game.CoreGui[v.Name].FillTransparency = 1 - Options[Group.."EspHighlightsTrans"].Value / 255
                                            end
                                        end
                    
                                        if game.CoreGui[v.Name].Adornee ~= Character then
                                            game.CoreGui[v.Name].Adornee = Character
                                        end

                                        if game.CoreGui[v.Name].Enabled ~= false then
                                            game.CoreGui[v.Name].Enabled = false
                                        end

                                        if game.CoreGui[v.Name].OutlineTransparency ~= 1 - Options[Group.."EspOutlineHighlightsTrans"].Value / 255 then
                                            game.CoreGui[v.Name].OutlineTransparency = 1 - Options[Group.."EspOutlineHighlightsTrans"].Value / 255
                                        end

                                        if game.CoreGui[v.Name].Enabled ~= true then
                                            game.CoreGui[v.Name].Enabled = true
                                        end
                                        
                                        if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                            if game.CoreGui[v.Name].FillColor ~= Options.ColorTarget.Value then
                                                game.CoreGui[v.Name].FillColor = Options.ColorTarget.Value
                                            end
                                            
                                            if game.CoreGui[v.Name].OutlineColor ~= Options.ColorTarget.Value then
                                                game.CoreGui[v.Name].OutlineColor = Options.ColorTarget.Value
                                            end
                                        else
                                            if game.CoreGui[v.Name].FillColor ~= Options[Group.."ColorHighlights"].Value then
                                                game.CoreGui[v.Name].FillColor = Options[Group.."ColorHighlights"].Value
                                            end
                                            
                                            if game.CoreGui[v.Name].OutlineColor ~= Options[Group.."ColorHighlightsOutline"].Value then
                                                game.CoreGui[v.Name].OutlineColor = Options[Group.."ColorHighlightsOutline"].Value
                                            end
                                        end
                                    else
                                        if game.CoreGui:FindFirstChild(v.Name) then
                                            if game.CoreGui[v.Name].Enabled ~= false then
                                                game.CoreGui[v.Name].Enabled = false
                                            end
                                        end
                                    end

                                    if Toggles[Group.."EspIcon"].Value and IconImg ~= nil then
                                        --if Icon.Data ~= IconImg.data then
                                            Icon.Data = IconImg.data
                                        --end

                                        if Icon.Size ~= Vector2.new(IconImg.w, IconImg.h) then
                                            Icon.Size = Vector2.new(IconImg.w, IconImg.h)
                                        end

                                        if Icon.Position ~= Vector2.new(Pos.X + (Size.X / 2) - (IconImg.w / 2), Pos.Y + Size.Y + 4) then
                                            Icon.Position = Vector2.new(Pos.X + (Size.X / 2) - (IconImg.w / 2), Pos.Y + Size.Y + 4)
                                        end

                                        Icon.Visible = true

                                        yadd = yadd + IconImg.h + 4
                                    end

                                    if Toggles[Group.."EspWeapon"].Value then
                                        Weapon.Visible = true
                                        if Weapon.Font ~= Drawing.Fonts[Options.TextFont.Value] then
                                            Weapon.Font = Drawing.Fonts[Options.TextFont.Value]
                                        end
                                        if Weapon.Size ~= Options.TextSize.Value then
                                            Weapon.Size = Options.TextSize.Value
                                        end

                                        if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                            if Weapon.Color ~= Options.ColorTarget.Value then
                                                Weapon.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Weapon.Color ~= Options[Group.."ColorWeapon"].Value then
                                                Weapon.Color = Options[Group.."ColorWeapon"].Value
                                            end
                                        end

                                        Weapon.Position = Vector2.new(Pos.X + (Size.X / 2), Pos.Y + Size.Y + 2 + yadd)

                                        if Options.TextCase.Value == "Normal" then
                                            if Weapon.Text ~= get_weapon(v) then
                                                Weapon.Text = get_weapon(v)
                                            end
                                        elseif Options.TextCase.Value == "UPPERCASE" then
                                            if Weapon.Text ~= string.upper(get_weapon(v)) then
                                                Weapon.Text = string.upper(get_weapon(v))
                                            end
                                        elseif Options.TextCase.Value == "lowercase" then
                                            if Weapon.Text ~= string.lower(get_weapon(v)) then
                                                Weapon.Text = string.lower(get_weapon(v))
                                            end
                                        end
                                    end

                                    if Toggles[Group.."EspBox"].Value then
                                        if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                            if Box.Color ~= Options.ColorTarget.Value then
                                                Box.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Box.Color ~= Options[Group.."ColorBox"].Value then
                                                Box.Color = Options[Group.."ColorBox"].Value
                                            end
                                        end
                                        Box.Position = Pos
                                        Box.Size = Size
                                        Box.Visible = true

                                        BoxOutline.Position = Pos
                                        BoxOutline.Size = Size
                                        BoxOutline.Visible = true
                                    end

                                    if Toggles[Group.."EspName"].Value then
                                        Name.Position = Vector2.new(Size.X / 2 + Pos.X, Pos.Y - 5 - Name.TextBounds.Y)
                                        if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                            if Name.Color ~= Options.ColorTarget.Value then
                                                Name.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Name.Color ~= Options[Group.."ColorName"].Value then
                                                Name.Color = Options[Group.."ColorName"].Value
                                            end
                                        end 


                                        if Name.Font ~= Drawing.Fonts[Options.TextFont.Value] then
                                            Name.Font = Drawing.Fonts[Options.TextFont.Value]
                                        end
                                        if Name.Size ~= Options.TextSize.Value then
                                            Name.Size = Options.TextSize.Value
                                        end
                                        Name.Visible = true
                                        if Options.TextCase.Value == "Normal" then
                                            if Name.Text ~= v.Name then
                                                Name.Text = v.Name
                                            end
                                        elseif Options.TextCase.Value == "UPPERCASE" then
                                            if Name.Text ~= string.upper(v.Name) then
                                                Name.Text = string.upper(v.Name)
                                            end
                                        elseif Options.TextCase.Value == "lowercase" then
                                            if Name.Text ~= string.lower(v.Name) then
                                                Name.Text = string.lower(v.Name)
                                            end
                                        end
                                    end

                                    if Toggles[Group.."EspHealthBar"].Value then
                                        Health.From = Vector2.new(Pos.X - 4, Pos.Y + Size.Y)
                                        Health.To = Vector2.new(Pos.X - 4, Health.From.Y - (Cur_Health / Max_Health) * Size.Y)
                                        Health.Visible = true
                                        if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                            if Health.Color ~= Options.ColorTarget.Value then
                                                Health.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Health.Color ~= Options[Group.."ColorHealthBar"].Value then
                                                Health.Color = Options[Group.."ColorHealthBar"].Value
                                            end
                                        end

                                        HealthOutline.From = Vector2.new(Health.From.X, Pos.Y + Size.Y + 1)
                                        HealthOutline.To = Vector2.new(Health.From.X, (Health.From.Y - 1 * Size.Y) -1)
                                        HealthOutline.Visible = true
                                        if HealthOutline.Thickness ~= 3 then
                                            HealthOutline.Thickness = 3
                                        end
                                    end

                                    if Toggles[Group.."EspHealthNumber"].Value and Cur_Health <= Options.HpVis.Value then
                                        HealthNumber.Visible = true
                                        if HealthNumber.Font ~= Drawing.Fonts[Options.TextFont.Value] then
                                            HealthNumber.Font = Drawing.Fonts[Options.TextFont.Value]
                                        end
                                        if HealthNumber.Size ~= Options.TextSize.Value then
                                            HealthNumber.Size = Options.TextSize.Value
                                        end
                                        if HealthNumber.Text ~= tostring(math.floor(Cur_Health)) then
                                            HealthNumber.Text = tostring(math.floor(Cur_Health))
                                        end
                                        if HealthNumber.Center ~= false then
                                            HealthNumber.Center = false
                                        end
                                        if Toggles[Group.."EspHealthBar"].Value then
                                            HealthNumber.Position = Vector2.new(Pos.X - 6 - HealthNumber.TextBounds.X, Health.To.Y - 3)
                                        else
                                            HealthNumber.Position = Vector2.new(Pos.X - 6 - HealthNumber.TextBounds.X, Pos.Y - 3)
                                        end

                                        if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                            if HealthNumber.Color ~= Options.ColorTarget.Value then
                                                HealthNumber.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if HealthNumber.Color ~= Options[Group.."ColorHealthNumber"].Value then
                                                HealthNumber.Color = Options[Group.."ColorHealthNumber"].Value
                                            end
                                        end
                                    end

                                    if Toggles[Group.."EspLevel"].Value then
                                        Level.Visible = true
                                        if Level.Font ~= Drawing.Fonts[Options.TextFont.Value] then
                                            Level.Font = Drawing.Fonts[Options.TextFont.Value]
                                        end
                                        if Level.Size ~= Options.TextSize.Value then
                                            Level.Size = Options.TextSize.Value
                                        end
                                        if Options.TextCase.Value == "Normal" then
                                            if Level.Text ~= "LVL " ..lvl then
                                                Level.Text = "LVL " ..lvl
                                            end
                                        elseif Options.TextCase.Value == "UPPERCASE" then
                                            if Level.Text ~= string.upper("LVL " ..lvl) then
                                                Level.Text = string.upper("LVL " ..lvl)
                                            end
                                        elseif Options.TextCase.Value == "lowercase" then
                                            if Level.Text ~= string.lower("LVL " ..lvl) then
                                                Level.Text = string.lower("LVL " ..lvl)
                                            end
                                        end
                                        if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                            if Level.Color ~= Options.ColorTarget.Value then
                                                Level.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Level.Color ~= Options[Group.."ColorLevel"].Value then
                                                Level.Color = Options[Group.."ColorLevel"].Value
                                            end
                                        end
                                        Level.Position = Vector2.new(Pos.X + Size.X + 3, Pos.Y - 3)
                                        if Level.Center ~= false then
                                            Level.Center = false
                                        end
                                    end

                                    if Toggles[Group.."EspDistance"].Value then
                                        Distance.Visible = true
                                        if Distance.Font ~= Drawing.Fonts[Options.TextFont.Value] then
                                            Distance.Font = Drawing.Fonts[Options.TextFont.Value]
                                        end
                                        if Distance.Size ~= Options.TextSize.Value then
                                            Distance.Size = Options.TextSize.Value
                                        end
                                        if Distance.Text ~= tostring(math.ceil(LocalPlayer:DistanceFromCharacter(Character.Torso.Position) / 5)).."M" then
                                            Distance.Text = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(Character.Torso.Position) / 5)).."M"
                                        end
                                        if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                            if Distance.Color ~= Options.ColorTarget.Value then
                                                Distance.Color = Options.ColorTarget.Value
                                            end
                                        else
                                            if Distance.Color ~= Options[Group.."ColorDistance"].Value then
                                                Distance.Color = Options[Group.."ColorDistance"].Value
                                            end
                                        end
                                        Distance.Position = Vector2.new(Pos.X + Size.X + 3, Pos.Y - 3 + yadd)
                                        if Distance.Center ~= false then
                                            Distance.Center = false
                                        end
                                    end
                                end
                            else
                                if Toggles[Group.."EspOutOfView"].Value then
                                    local OutOfView = PLRD.Offscreen

                                    local ptos = Camera.CFrame:PointToObjectSpace(Character.Torso.Position)
                                    local ang = math.atan2(ptos.Z, ptos.X)
                                    local dir = Vector2.new(math.cos(ang), math.sin(ang))
                                    local pos = (dir * Options[Group.."EspOutOfViewDistance"].Value * 10 * .5) + ScreenSize / 2

                                    if Toggles[Group.."EspOutOfViewSine"].Value then
                                        OutOfView.Transparency = (math.sin(tick() * 5) + 1) / 2
                                    else
                                        if OutOfView.Transparency ~= 1 then
                                            OutOfView.Transparency = 1
                                        end
                                    end

                                    OutOfView.PointA = pos
                                    OutOfView.PointB = pos - rotateVector2(dir, math.rad(35)) * Options[Group.."EspOutOfViewSize"].Value
                                    OutOfView.PointC = pos - rotateVector2(dir, -math.rad(35)) * Options[Group.."EspOutOfViewSize"].Value
                                    if Toggles.EspTarget.Value and rage.target ~= nil and v.Name == rage.target.Name then
                                        if OutOfView.Color ~= Options.ColorTarget.Value then
                                            OutOfView.Color = Options.ColorTarget.Value
                                        end
                                    else
                                        if OutOfView.Color ~= Options[Group.."ColorOutOfView"].Value then
                                            OutOfView.Color = Options[Group.."ColorOutOfView"].Value
                                        end
                                    end
                                    OutOfView.Visible = true
                                end
                            end
                        else
                            if game.CoreGui:FindFirstChild(v.Name) then
								game.CoreGui[v.Name]:Destroy()
							end
                            
                            if PLRDS[v] then
                                for i, v in pairs(PLRDS[v]) do
                                    if v.Visible ~= false then
                                        v.Visible = false
                                    end
                                end
                            end    

                            if get_character(v) ~= nil then
                                for _,q in pairs(get_character(v):GetChildren()) do
                                    if q:FindFirstChildWhichIsA("BoxHandleAdornment") then
                                        q.Cham:Destroy()
                                    end
                                end
                            end
                        end
                    elseif Group ~= "Local" then
                        if game.CoreGui:FindFirstChild(v.Name) then
                            game.CoreGui[v.Name]:Destroy()
                        end

                        if PLRDS[v] then
                            for i, v in pairs(PLRDS[v]) do
                                if v.Visible ~= false then
                                    v.Visible = false
                                end
                            end
                        end

                        if get_character(v) ~= nil then
                            for _,q in pairs(get_character(v):GetChildren()) do
                                if q:FindFirstChildWhichIsA("BoxHandleAdornment") then
                                    q.Cham:Destroy()
                                end
                            end
                        end
                    end
                end
            end))
        end

        do -- ESP Weapons
            Library:GiveSignal(rs.RenderStepped:Connect(function()
                for i,v in pairs(game.Workspace.Ignore.GunDrop:GetChildren()) do
                    if v.Name == "Dropped" and DWPS[v] and v:FindFirstChild("Slot1") and game_client.LocalPlayer.isAlive() then
                        local DWP = DWPS[v]
                        for i1, v1 in pairs (DWP) do
                            if type(v1) ~= "boolean" then
                                v1.Visible = false
                            end
                        end
            
                        local SlotPos = v:FindFirstChild("Slot1").Position
            
                        local Pos, OnScreen = Camera:WorldToScreenPoint(SlotPos)
                        
                        local GunDistance = math.ceil(game.Players.LocalPlayer:DistanceFromCharacter(SlotPos))
                
                        if OnScreen and v:FindFirstChild("Gun") and v:FindFirstChild("Spare") and GunDistance < 90 then
                            local Name = DWP.Name
                            local Ammo = DWP.Ammo
                            local Icon = DWP.Icon
                            local IconImg = NameToIcon(v.Gun.Value)
                            local ypos = 0
            
                            if Toggles.DroppedIcon.Value and IconImg ~= nil then
                                --if Icon.Data ~= IconImg.data then
                                Icon.Data = IconImg.data
                                --end

                                if Icon.Size ~= Vector2.new(IconImg.w, IconImg.h) then
                                    Icon.Size = Vector2.new(IconImg.w, IconImg.h)
                                end

                                if Icon.Position ~= Vector2.new(math.floor(Pos.x) - (IconImg.w / 2), math.floor(Pos.y + 25)) then
                                    Icon.Position = Vector2.new(math.floor(Pos.x) - (IconImg.w / 2), math.floor(Pos.y + 25))
                                end

                                Icon.Visible = true
                                Icon.Transparency = 1.41177 - ((GunDistance * 4) / 255)

                                ypos = ypos + IconImg.h + 2
                            end

                            if Toggles.DroppedWeapon.Value then
                                Name.Visible = true
                                Name.Font = Drawing.Fonts[Options.TextFont.Value]
                                Name.Size = Options.TextSize.Value
                                Name.Color = Options.ColorDroppedWeapon.Value
                                Name.Position = Vector2.new(math.floor(Pos.x), math.floor(Pos.y + 25 + ypos))
                                Name.Transparency = 1.41177 - ((GunDistance * 4) / 255)
                                Name.Center = true
                                Name.Text = v.Gun.Value
                                Name.Outline = true

                                ypos = ypos + Name.TextBounds.Y + 2
                            end

                            if Toggles.DroppedAmmo.Value then
                                Ammo.Visible = true
                                Ammo.Font = Drawing.Fonts[Options.TextFont.Value]
                                Ammo.Size = Options.TextSize.Value
                                Ammo.Color = Options.ColorDroppedAmmo.Value
                                Ammo.Position = Vector2.new(math.floor(Pos.x), math.floor(Pos.y + 25 + ypos))
                                Ammo.Transparency = 1.41177 - ((GunDistance * 4) / 255)
                                Ammo.Center = true
                                Ammo.Text = "[ "..tostring(v.Spare.Value).." ]"
                                Ammo.Outline = true
                            end
                        end
                    else
                        for i1, v1 in pairs (DWPS[v]) do
                            if type(v1) ~= "boolean" then
                                v1.Visible = false
                            end
                        end
                    end
                end
            end))
        end

        do -- Movement
            Library:GiveSignal(rs.RenderStepped:Connect(function()
                if game_client.LocalPlayer.isAlive() then
                    if Toggles.MovementSpeed.Value and Options.MovementSpeedKey:GetState() then
                        local travel = V3()
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            travel += V3(Camera.CFrame.lookVector.x, 0, Camera.CFrame.lookVector.Z)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            travel -= V3(Camera.CFrame.lookVector.x, 0, Camera.CFrame.lookVector.Z)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            travel += V3(-Camera.CFrame.lookVector.Z, 0, Camera.CFrame.lookVector.x)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            travel += V3(Camera.CFrame.lookVector.Z, 0, -Camera.CFrame.lookVector.x)
                        end

                        travel = travel.Unit

                        local newDir = V3(travel.x * Options.MovementSpeedAmount.Value, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.y, travel.Z * Options.MovementSpeedAmount.Value)
        
                        if Toggles.MovementAutoJump.Value and LocalPlayer.Character:FindFirstChild("Humanoid"):GetState() ~= Enum.HumanoidStateType.Freefall then
                            LocalPlayer.Character:FindFirstChild("Humanoid").Jump = true
                        end

                        if travel.Unit.x == travel.Unit.x then
                            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = newDir
                        end
                    end
                end

                if game_client.LocalPlayer.isAlive() then
                    if Toggles.MovementFly.Value and Options.MovementFlyKey:GetState() then
                        local travel = V3()
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            travel += Camera.CFrame.lookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            travel -= Camera.CFrame.lookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            travel += V3(-Camera.CFrame.lookVector.Z, 0, Camera.CFrame.lookVector.x)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            travel += V3(Camera.CFrame.lookVector.Z, 0, -Camera.CFrame.lookVector.x)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            travel += V3(0, 1, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            travel -= V3(0, 1, 0)
                        end

                        if travel.Unit.x == travel.Unit.x then
                            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false
                            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = travel.Unit * Options.MovementFlyAmount.Value
                        else
                            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = V3(0, 0, 0)
                            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true
                        end
                    else
                        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false
                    end
                end
            end))
        end

        do -- Visuals
            Library:GiveSignal(rs.RenderStepped:Connect(function(step)
                fps = math.floor(1/step)
                currentAngle = currentAngle + math.rad((Options.CursorSpinSpeed.Value * 10) * step);

                if alive and not game_client.LocalPlayer.isAlive() and t + 1 < tick() then
                    game_client.character_interface.spawn()
                    t = tick()
                end
                
                if game_client.LocalPlayer.isAlive() then
                    curgun = game_client.WCI:getController()._activeWeaponIndex
                end

                if Toggles.FovBarrel.Value and game_client.LocalPlayer.isAlive() and game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart ~= nil and game_client.WCI:getController()._activeWeaponRegistry[curgun] then
                    local hit, hitpos, normal = workspace:FindPartOnRayWithIgnoreList(Ray.new(game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart.Position, game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart.Parent.Trigger.CFrame.LookVector * 100), { workspace.Ignore, Camera }, false, true)	
                    local nigga = Camera:WorldToViewportPoint(hitpos + normal * 0.01)

                    FovPos = Vector2.new(nigga.x, nigga.y)
                else
                    FovPos = ScreenSize / 2
                end

                if Toggles.CursorBarrel.Value and game_client.LocalPlayer.isAlive() and game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart ~= nil and game_client.WCI:getController()._activeWeaponRegistry[curgun] then
                    local hit, hitpos, normal = workspace:FindPartOnRayWithIgnoreList(Ray.new(game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart.Position, game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart.Parent.Trigger.CFrame.LookVector * 100), { workspace.Ignore, Camera }, false, true)	
                    local nigga = Camera:WorldToViewportPoint(hitpos + normal * 0.01)

                    CrosshairPos = Vector2.new(nigga.x, nigga.y)
                else
                    CrosshairPos = ScreenSize / 2
                end

                if game_client.LocalPlayer.isAlive() and game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart ~= nil then
                    BarrelPos = game_client.WCI:getController()._activeWeaponRegistry[curgun]._barrelPart.Position
                end

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
                    
                    if Toggles.CursorSpin.Value then
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

                if Toggles.FovAimAssist.Value and game_client.LocalPlayer.isAlive() then
                    FCS.AimAssist.Position = FovPos
                    if FCS.AimAssist.Visible ~= true then
                        FCS.AimAssist.Visible = true
                    end
                    if FCS.AimAssist.Color ~= Options.ColorFovAimAssist.Value then
                        FCS.AimAssist.Color = Options.ColorFovAimAssist.Value
                    end
                    if FCS.AimAssist.Radius ~= Options.AimFov.Value * 2 then
                        FCS.AimAssist.Radius = Options.AimFov.Value * 2
                    end 
                else
                    if FCS.AimAssist.Visible ~= false then
                        FCS.AimAssist.Visible = false
                    end
                end

                if Toggles.FovSilent.Value and game_client.LocalPlayer.isAlive() then
                    FCS.SilentAim.Position = FovPos
                    if FCS.SilentAim.Visible ~= true then
                        FCS.SilentAim.Visible = true
                    end
                    if FCS.SilentAim.Color ~= Options.ColorSilent.Value then
                        FCS.SilentAim.Color = Options.ColorSilent.Value
                    end
                    if FCS.SilentAim.Radius ~= Options.SilentFov.Value * 2 then
                        FCS.SilentAim.Radius = Options.SilentFov.Value * 2
                    end
                else
                    if FCS.SilentAim.Visible ~= false then
                        FCS.SilentAim.Visible = false
                    end
                end
                
                if game_client.LocalPlayer.isAlive() and Toggles.ExtraGunSound.Value and curgun <= 2 then
                    game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.firesoundid = "rbxassetid://"
                end

                Watermark.Text.Text = textboxtriggers(Options.WatermarkText.Value)
            
                if Watermark.Text.Position ~= Vector2.new(Options.WatermarkIcon.Value == "N/A" and 58 + 4 or 58 + 27, 15) then
                    Watermark.Text.Position = Vector2.new(Options.WatermarkIcon.Value == "N/A" and 58 + 4 or 58 + 27, 15)
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
            
                if Watermark.Border.Position ~= Vector2.new(57, 8) then
                    Watermark.Border.Position = Vector2.new(57, 8)
                end
            
                if Watermark.Border.Filled ~= true then
                    Watermark.Border.Filled = true
                end
            
                if Watermark.Border.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.Border.Visible = Toggles.InterfaceWatermark.Value
                end
                
                Watermark.Border.Size = Vector2.new(Options.WatermarkIcon.Value == "N/A" and Watermark.Text.TextBounds.X + 9 or Watermark.Text.TextBounds.X + 34, Watermark.Text.TextBounds.Y + 13)
            
                if Watermark.Gradient.Position ~= Vector2.new(58, 12) then
                    Watermark.Gradient.Position = Vector2.new(58, 12)
                end

                if Watermark.Gradient.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.Gradient.Visible = Toggles.InterfaceWatermark.Value
                end
                
                if Watermark.Gradient.Transparency ~= 0.5 then
                    Watermark.Gradient.Transparency = 0.5
                end

                Watermark.Gradient.Size = Vector2.new(Options.WatermarkIcon.Value == "N/A" and Watermark.Text.TextBounds.X + 7 or Watermark.Text.TextBounds.X + 32, Watermark.Text.TextBounds.Y + 11)
            
                if Watermark.Background.Color ~= Color3.fromRGB(25, 25, 25) then
                    Watermark.Background.Color = Color3.fromRGB(25, 25, 25)
                end
            
                if Watermark.Background.Position ~= Vector2.new(58, 9) then
                    Watermark.Background.Position = Vector2.new(58, 9)
                end
            
                if Watermark.Background.Filled ~= true then
                    Watermark.Background.Filled = true
                end
            
                if Watermark.Background.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.Background.Visible = Toggles.InterfaceWatermark.Value
                end
            
                Watermark.Background.Size = Vector2.new(Options.WatermarkIcon.Value == "N/A" and Watermark.Text.TextBounds.X + 7 or Watermark.Text.TextBounds.X + 32, Watermark.Text.TextBounds.Y + 11)

                local Color = Color3.fromRGB((math.abs(math.sin(tick() / (Options.RainbowSpeed.Value - 51))) * 255), 255, 255)

                if Watermark.Accent.Color ~= Color3.fromHSV(Color.R, Color.G, Color.B) and Toggles.RainbowAccent.Value then
                    Watermark.Accent.Color = Color3.fromHSV(Color.R, Color.G, Color.B)
                elseif Watermark.Accent.Color ~= Color3.new(Options.ColorWatermark.Value.R, Options.ColorWatermark.Value.G, Options.ColorWatermark.Value.B) then
                    Watermark.Accent.Color = Color3.new(Options.ColorWatermark.Value.R, Options.ColorWatermark.Value.G, Options.ColorWatermark.Value.B)
                end
            
                if Watermark.Accent.Position ~= Vector2.new(58, 9) then
                    Watermark.Accent.Position = Vector2.new(58, 9)
                end
            
                if Watermark.Accent.Filled ~= true then
                    Watermark.Accent.Filled = true
                end
            
                if Watermark.Accent.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.Accent.Visible = Toggles.InterfaceWatermark.Value
                end
            
                Watermark.Accent.Size = Vector2.new(Options.WatermarkIcon.Value == "N/A" and Watermark.Text.TextBounds.X + 7 or Watermark.Text.TextBounds.X + 32, 1)
            
                if Watermark.Accent2.Color ~= Color3.fromHSV(Color.R, Color.G, Color.B) and Toggles.RainbowAccent.Value then
                    Watermark.Accent2.Color = Color3.fromHSV(Color.R, Color.G, Color.B)
                elseif Watermark.Accent2.Color ~= Color3.fromRGB(Options.ColorWatermark.Value.R * 255 - 40, Options.ColorWatermark.Value.G * 255 - 40, Options.ColorWatermark.Value.B * 255 - 40) then
                    Watermark.Accent2.Color = Color3.fromRGB(Options.ColorWatermark.Value.R * 255 - 40, Options.ColorWatermark.Value.G * 255 - 40, Options.ColorWatermark.Value.B * 255 - 40)
                end
            
                if Watermark.Accent2.Position ~= Vector2.new(58, 10) then
                    Watermark.Accent2.Position = Vector2.new(58, 10)
                end
            
                if Watermark.Accent2.Filled ~= true then
                    Watermark.Accent2.Filled = true
                end
            
                if Watermark.Accent2.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.Accent2.Visible = Toggles.InterfaceWatermark.Value
                end
            
                Watermark.Accent2.Size = Vector2.new(Options.WatermarkIcon.Value == "N/A" and Watermark.Text.TextBounds.X + 7 or Watermark.Text.TextBounds.X + 32, 1)
            
                if Watermark.BorderLine.Color ~= Color3.fromRGB(0, 0, 0) then
                    Watermark.BorderLine.Color = Color3.fromRGB(0, 0, 0)
                end
            
                if Watermark.BorderLine.Position ~= Vector2.new(58, 11) then
                    Watermark.BorderLine.Position = Vector2.new(58, 11)
                end
            
                if Watermark.BorderLine.Filled ~= true then
                    Watermark.BorderLine.Filled = true
                end
            
                if Watermark.BorderLine.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.BorderLine.Visible = Toggles.InterfaceWatermark.Value
                end
            
                Watermark.BorderLine.Size = Vector2.new(Options.WatermarkIcon.Value == "N/A" and Watermark.Text.TextBounds.X + 7 or Watermark.Text.TextBounds.X + 32, 1)
            
                if Watermark.Icon.Position ~= Vector2.new(58, 12) then
                    Watermark.Icon.Position = Vector2.new(58, 12)
                end
            
                if Watermark.Icon.Visible ~= Toggles.InterfaceWatermark.Value then
                    Watermark.Icon.Visible = Toggles.InterfaceWatermark.Value
                end
            
                if Watermark.Icon.Size ~= Vector2.new(Watermark.Text.TextBounds.Y + 8, Watermark.Text.TextBounds.Y + 8) then
                    Watermark.Icon.Size = Vector2.new(Watermark.Text.TextBounds.Y + 8, Watermark.Text.TextBounds.Y + 8)
                end

                if Toggles.WorldAmbience.Value then
                    Lighting.Ambient = Options.ColorInsideAmbience.Value
                    Lighting.OutdoorAmbient = Options.ColorOutsideAmbience.Value
                end

                if Toggles.WorldTime.Value then
                    Lighting.TimeOfDay = Options.WorldTimeAmount.Value
                end

                if Toggles.WorldSaturation.Value then
                    saturationEffect.TintColor = Options.ColorSaturation.Value
                    saturationEffect.Saturation = Options.WorldSaturationAmount.Value / 50
                end
            end))
        end

        do -- Third Person
            local player = Instance.new("Player")
            fake_rep_object = game_client.replication_object.new(player)
            fake_rep_object._player = LocalPlayer
            player:Destroy()
            player = nil
    
            if game_client.character_interface:isAlive() and game_client.weapon_controller_interface.getController() then
                local weapon_controller = game_client.weapon_controller_interface.getController()
    
                fake_rep_object._activeWeaponRegistry[1] = {
                    weaponName = weapon_controller._activeWeaponRegistry[1]._weaponName, 
                    weaponData = weapon_controller._activeWeaponRegistry[1]._weaponData, 
                    attachmentData = weapon_controller._activeWeaponRegistry[1]._weaponAttachments, 
                    camoData = weapon_controller._activeWeaponRegistry[1]._camoList
                }
    
                fake_rep_object._activeWeaponRegistry[2] = {
                    weaponName = weapon_controller._activeWeaponRegistry[2]._weaponName, 
                    weaponData = weapon_controller._activeWeaponRegistry[2]._weaponData, 
                    attachmentData = weapon_controller._activeWeaponRegistry[2]._weaponAttachments, 
                    camoData = weapon_controller._activeWeaponRegistry[2]._camoList
                }
    
                fake_rep_object._activeWeaponRegistry[3] = {
                    weaponName = weapon_controller._activeWeaponRegistry[3]._weaponName, 
                    weaponData = weapon_controller._activeWeaponRegistry[3]._weaponData, 
                    camoData = weapon_controller._activeWeaponRegistry[3]._camoData
                }
    
                fake_rep_object._activeWeaponRegistry[4] = {
                    weaponName = weapon_controller._activeWeaponRegistry[4]._weaponName, 
                    weaponData = weapon_controller._activeWeaponRegistry[4]._weaponData
                }
    
                fake_rep_object._thirdPersonObject = game_client.third_person_object.new(fake_rep_object._player, nil, fake_rep_object)
                fake_rep_object._thirdPersonObject:equip(1, true)
                fake_rep_object._alive = true
            end

            local old_new_index
        
            old_new_index = hookmetamethod(game, "__newindex", function(self, index, value)
                if checkcaller() then
                    return old_new_index(self, index, value)
                end
        
                if Toggles.ThirdPerson.Value and Options.ThirdPersonKey:GetState() and game_client.character_interface:isAlive() then
                    if self == Camera and index == "CFrame" then
                        value *= CFrame.new(Options.ThirdPersonX.Value / 10, Options.ThirdPersonY.Value / 10, Options.ThirdPersonZ.Value / 10)
                    end
                end
        
                return old_new_index(self, index, value)
            end)
        end

        do -- Gun Chams and arm chams
            Library:GiveSignal(rs.RenderStepped:Connect(function()
                for i,v in pairs(Camera:GetChildren()) do
                    if v.Name == "Main" then
                        if Toggles.GunChams.Value then
                            if not v:FindFirstChild("Highlight") then
                                local Highlight = Instance.new("Highlight", v)
                            end

                            if v.Highlight.DepthMode ~= Enum.HighlightDepthMode.Occluded then
                                v.Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                            end

                            if v.Highlight.FillColor ~= Options.ColorGunChams.Value then
                                v.Highlight.FillColor = Options.ColorGunChams.Value
                            end

                            if v.Highlight.OutlineColor ~= Options.ColorGunOutlineChams.Value then
                                v.Highlight.OutlineColor = Options.ColorGunOutlineChams.Value
                            end

                            if v.Highlight.FillTransparency ~= 1 - Options.GunChamsTrans.Value / 255 then
                                v.Highlight.FillTransparency = 1 - Options.GunChamsTrans.Value / 255
                            end

                            if v.Highlight.OutlineTransparency ~= 1 - Options.GunOutlineChamsTrans.Value / 255 then
                                v.Highlight.OutlineTransparency = 1 - Options.GunOutlineChamsTrans.Value / 255
                            end

                            if v.Highlight.Enabled ~= true then
                                v.Highlight.Enabled = true
                            end
                        else
                            if v:FindFirstChild("Highlight") then
                                v.Highlight:Remove()
                            end
                        end

                        if Toggles.AGunChams.Value then
                            for _,v1 in pairs(v:GetChildren()) do
                                if (v1:IsA("BasePart") or v1:IsA("MeshPart")) and v1.Transparency ~= 1 then
                                    chams(v1, Options.AColorGunChams.Value, Options.AGunChamsTrans.Value / 255, Options.AGunChamsReflectance.Value, Options.AGunChamsMaterial.Value)
                                end
                            end
                        end
                    end

                    if v.Name == "Left Arm" or v.Name == "Right Arm" then
                        if Toggles.ArmChams.Value then
                            if not v:FindFirstChild("Highlight") then
                                local Highlight = Instance.new("Highlight", v)
                            end

                            if v.Highlight.DepthMode ~= Enum.HighlightDepthMode.Occluded then
                                v.Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                            end

                            if v.Highlight.FillColor ~= Options.ColorArmChams.Value then
                                v.Highlight.FillColor = Options.ColorArmChams.Value
                            end

                            if v.Highlight.OutlineColor ~= Options.ColorArmOutlineChams.Value then
                                v.Highlight.OutlineColor = Options.ColorArmOutlineChams.Value
                            end

                            if v.Highlight.FillTransparency ~= 1 - Options.ArmChamsTrans.Value / 255 then
                                v.Highlight.FillTransparency = 1 - Options.ArmChamsTrans.Value / 255
                            end

                            if v.Highlight.OutlineTransparency ~= 1 - Options.ArmOutlineChamsTrans.Value / 255 then
                                v.Highlight.OutlineTransparency = 1 - Options.ArmOutlineChamsTrans.Value / 255
                            end

                            if v.Highlight.Enabled ~= true then
                                v.Highlight.Enabled = true
                            end
                        else
                            if v:FindFirstChild("Highlight") then
                                v.Highlight:Remove()
                            end
                        end

                        if Toggles.AArmChams.Value then
                            for _,v1 in pairs(v:GetChildren()) do
                                if (v1:IsA("BasePart") or v1:IsA("MeshPart")) and v1.Transparency ~= 1 then
                                    chams(v1, Options.AColorArmChams.Value, Options.AArmChamsTrans.Value / 255, Options.AArmChamsReflectance.Value, Options.AArmChamsMaterial.Value)
                                end
                            end
                        end
                    end
                end
            end))
        end

        do -- Aimbot
            Library:GiveSignal(rs.RenderStepped:Connect(function()  
                PingPerformance = PerformanceStats.Ping:GetValue()

                for i,v in pairs(Players:GetPlayers()) do
                    if Toggles.AimEnabled.Value and Options.AimKey:GetState() then
                        organizedPlayers = {}

                        if v == LocalPlayer then continue end		

                        local Character = get_character(v)
                        local Alive = get_alive(v)

                        if not Alive then continue end

                        if not Toggles.AimTeam.Value and v.Team and v.Team == LocalPlayer.Team then continue end

                        if Character then
                            local Head = Character:FindFirstChild("Head")

                            local _,OnScreen = Camera:WorldToViewportPoint(Character.Torso.Position)
                            local Pos = Camera:WorldToViewportPoint(Character.Torso.Position)

                            if Options.AimFov.Value * 2 ~= 0 then
                                if find_2d_distance(Pos, FovPos) > Options.AimFov.Value * 2 then
                                    continue
                                end
                            end

                            if Toggles.AimVisCheck.Value then
                                if OnScreen then
                                    if isVisible(Character.Torso.Position, ignorething) then
                                        table.insert(organizedPlayers, v)
                                    end
                                else
                                    if table.find(organizedPlayers, v) then
                                        table.remove(organizedPlayers, v)
                                    end
                                end
                            else
                                if OnScreen then
                                    table.insert(organizedPlayers, v)
                                else
                                    if table.find(organizedPlayers, v) then
                                        table.remove(organizedPlayers, v)
                                    end
                                end
                            end

                            for i,v in pairs(organizedPlayers) do
                                if get_alive(v) then
                                    local Hitbox = Character:FindFirstChild("Head")

                                    if Options.AimHitscan == "Head" then
                                        Hitbox = Character:FindFirstChild("Head")
                                    elseif Options.AimHitscan == "Torso" then
                                        Hitbox = Character:FindFirstChild("HumanoidRootPart")
                                    elseif Options.AimHitscan == "Closest" then
                                        local HeadPos  = Camera:WorldToViewportPoint(Character:FindFirstChild("Head").Position)
                                        local TorsoPos = Camera:WorldToViewportPoint(Character:FindFirstChild("Torso").Position)
                            
                                        local HeadDistance  = (Vector2.new(HeadPos.X, HeadPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                                        local TorsoDistance = (Vector2.new(TorsoPos.X, TorsoPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                            
                                        Hitbox = HeadDistance < TorsoDistance and Character:FindFirstChild("Head") or Character:FindFirstChild("Torso")
                                    end
                                    local Pos = Hitbox.Position

                                    if OnScreen then
                                        --if find_2d_distance(Pos, FovPos) < menu:GetVal("Combat", "Aim Assist", "Deadzone") * 3 then
                                            local Ps = Vector3.new(Pos.X, Pos.Y, Pos.Z)
                                            Mouse_Move(Ps, Options.AimHorizontal.Value + 1, Options.AimVertical.Value + 1)
                                            return
                                        --end
                                    end
                                end
                            end
                        end
                    end
                end
            end))
        end

        do -- Silent Aim
            local old;
            old = hookfunction(game_client.particle.new, function(args)
                if debug.getinfo(2).name == "fireRound" then
                    if Toggles.SilentEnabled.Value and Options.SilentKey:GetState() then
                        local position, entry = getClosest(args.velocity, args.visualorigin, args.physicsignore);
                        if position and entry then
                            local index = table.find(debug.getstack(2), args.velocity);
        
                            args.velocity = trajectory(
                                position - args.visualorigin,
                                entry._velspring.p,
                                -args.acceleration,
                                args.velocity.Magnitude);
        
                            debug.setstack(2, index, args.velocity);
                        end
                    end
                end

                ignorething = args.physicsignore;

                return old(args);
            end)
        end

        do -- Camera
            game_client.main_camera_object.setSway = function(self, amount)
                local sway = Toggles.NoSway.Value and 0 or amount
            
                return cache.setsway(self, sway)
            end
            
            game_client.main_camera_object.shake = function(self, amount)
                local shake = Toggles.NoShake.Value and Vector3.zero or amount
            
                return cache.shake(self, shake)
            end

            game_client.firearm_object.walkSway = function(...) 
                if Toggles.ViewModel.Value then
                    local angle = CFrame.new(Options.ViewModelX.Value / 2.5, Options.ViewModelY.Value / 2.5, Options.ViewModelZ.Value / 2.5)

                    angle *= CFrame.Angles(Options.ViewModelPitch.Value / 50, Options.ViewModelYaw.Value / 50, Options.ViewModelRoll.Value / 50)

                    if Toggles.ViewModelBob.Value and LocalPlayer.Character.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
                        angle *= CFrame.new(0, (math.sin(tick() * (Options.ViewModelBobSpeed.Value / 10)) * Options.ViewModelBobAmount.Value) / 12, (math.sin(tick() * (Options.ViewModelBobSpeed.Value / 10)) * Options.ViewModelBobAmount.Value) / 2)
                    end

                    return angle
                elseif Toggles.NoSway.Value then
                    return CFrame.new() 
                end 

                return cache.wsway(...)
            end

            game_client.firearm_object.gunSway = function(...) 
                if Toggles.ViewModel.Value then
                    local angle = CFrame.new(Options.ViewModelX.Value / 2.5, Options.ViewModelY.Value / 2.5, Options.ViewModelZ.Value / 2.5)

                    angle *= CFrame.Angles(Options.ViewModelPitch.Value / 50, Options.ViewModelYaw.Value / 50, Options.ViewModelRoll.Value / 50)

                    if Toggles.ViewModelBob.Value and LocalPlayer.Character.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
                        angle *= CFrame.new(0, (math.sin(tick() * (Options.ViewModelBobSpeed.Value / 10)) * Options.ViewModelBobAmount.Value) / 12, (math.sin(tick() * (Options.ViewModelBobSpeed.Value / 10)) * Options.ViewModelBobAmount.Value) / 2)
                    end

                    return angle               
                elseif Toggles.NoSway.Value then
                    return CFrame.new() 
                end 

                return cache.gsway(...)
            end

            game_client.firearm_object.gunSway = function(...) 
                if Toggles.ViewModel.Value then
                    local angle = CFrame.new(Options.ViewModelX.Value / 2.5, Options.ViewModelY.Value / 2.5, Options.ViewModelZ.Value / 2.5)

                    angle *= CFrame.Angles(Options.ViewModelPitch.Value / 50, Options.ViewModelYaw.Value / 50, Options.ViewModelRoll.Value / 50)

                    if Toggles.ViewModelBob.Value and LocalPlayer.Character.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
                        angle *= CFrame.new(0, (math.sin(tick() * (Options.ViewModelBobSpeed.Value / 10)) * Options.ViewModelBobAmount.Value) / 12, (math.sin(tick() * (Options.ViewModelBobSpeed.Value / 10)) * Options.ViewModelBobAmount.Value) / 2)
                    end

                    return angle               
                elseif Toggles.NoSway.Value then
                    return CFrame.new() 
                end 

                return cache.gsway(...)
            end

            game_client.melee_object.meleeSway = function(...)
                if Toggles.ViewModel.Value then
                    local angle = CFrame.new(Options.ViewModelX.Value / 2.5, Options.ViewModelY.Value / 2.5, Options.ViewModelZ.Value / 2.5)

                    angle *= CFrame.Angles(Options.ViewModelPitch.Value / 50, Options.ViewModelYaw.Value / 50, Options.ViewModelRoll.Value / 50)

                    if Toggles.ViewModelBob.Value and LocalPlayer.Character.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
                        angle *= CFrame.new(0, (math.sin(tick() * (Options.ViewModelBobSpeed.Value / 10)) * Options.ViewModelBobAmount.Value) / 12, (math.sin(tick() * (Options.ViewModelBobSpeed.Value / 10)) * Options.ViewModelBobAmount.Value) / 2)
                    end

                    return angle               
                elseif Toggles.NoSway.Value then
                    return CFrame.new() 
                end 

                return cache.msway(...)
            end

            game_client.melee_object.walkSway = function(...)
                if Toggles.ViewModel.Value then
                    local angle = CFrame.new(Options.ViewModelX.Value / 2.5, Options.ViewModelY.Value / 2.5, Options.ViewModelZ.Value / 2.5)

                    angle *= CFrame.Angles(Options.ViewModelPitch.Value / 50, Options.ViewModelYaw.Value / 50, Options.ViewModelRoll.Value / 50)

                    if Toggles.ViewModelBob.Value and LocalPlayer.Character.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
                        angle *= CFrame.new(0, (math.sin(tick() * (Options.ViewModelBobSpeed.Value / 10)) * Options.ViewModelBobAmount.Value) / 12, (math.sin(tick() * (Options.ViewModelBobSpeed.Value / 10)) * Options.ViewModelBobAmount.Value) / 2)
                    end

                    return angle               
                elseif Toggles.NoSway.Value then
                    return CFrame.new() 
                end 

                return cache.mwsway(...)
            end
        end

        do -- Stance
            Library:GiveSignal(rs.RenderStepped:Connect(function()  
                if game_client.LocalPlayer.isAlive() and Toggles.AntiEnabled.Value and Options.AntiKey:GetState() then
                    if Options.AntiStance.Value ~= "Off" then
                        game_client.network.send(game_client.network, "stance", string.lower(Options.AntiStance.Value))
                    end
                end
            end))
        end

        do -- Network
            local send = game_client.network.send

            game_client.network.send = function(self, command, ...)
                local args = { ... }
        
                if command == "bullethit" then
                    if Toggles.SupOnly.Value then return end

                    if Toggles.IgnoreFriends.Value and table.find(Friends, tostring(args[1])) then return end
                        
                    if Toggles.HitLogs.Value then
                        Library:Notify(string.format("Hit %s in the %s with a %s.", tostring(args[1]), tostring(args[3]), tostring(game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.name)), Options.HitLogTime.Value)
                    end
                end

                if command == "knifehit" then
                    if Toggles.SupOnly.Value then return end

                    if Toggles.IgnoreFriends.Value and table.find(Friends, tostring(args[1])) then return end

                    if Toggles.HitLogs.Value then
                        Library:Notify(string.format("Hit %s in the %s with a %s.", tostring(args[1].Name), tostring(args[2]), tostring(game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.name)), Options.HitLogTime.Value)
                    end
                end

                if command == "debug" then
                    if args[1] == "Server Kick Message: You have been votekicked out of the server!" and Toggles.GameVotekick.Value then
                        local jobid = ""
        
                        local Servers = game.HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)))
                    
                        for Index, Value in pairs(Servers.data) do
                            if Value.playing ~= Value.maxPlayers and Value.playing ~= nil and Value.playing > 20 and Value.ping < 100 then
                                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Value.id)
                                jobid = tostring(Value.id)
                            end
                        end
                    
                        Library:Notify("Attempting hop to "..string.sub(jobid, 0, 8).."-XXXX-XXXX-XXXX-XXXXXXXXXXXX.", 5, "move")
                    end
                end
        
                if command == "newbullets" then 
                    if Toggles.ExtraGunSound.Value then
                        local gun = Instance.new("Sound")
                        gun.Looped = false   
                        gun.Volume = Options.ExtraGunsoundVolume.Value / 10
                        gun.Parent = workspace
                        gun.Pitch = Options.ExtraGunsoundPitch.Value / 100
        
                        if isfile(shambles.workspace.."/Configs/sounds/"..Options.ExtraGunsoundId.Value..".mp3") then
                            gun.SoundId = getsynasset(shambles.workspace.."/Configs/sounds/"..Options.ExtraGunsoundId.Value..".mp3")
                        elseif isfile(shambles.workspace.."/Configs/sounds/"..Options.ExtraGunsoundId.Value..".wav") then
                            gun.SoundId = getsynasset(shambles.workspace.."/Configs/sounds/"..Options.ExtraGunsoundId.Value..".wav")
                        end    
        
                        gun:Play()
                    end
        
                    if Toggles.BulletTracers.Value then
                        for k = 1, #args[1].bullets do
                            local bullet = args[1].bullets[k]
                            local origin = args[1].firepos
                            local attach_origin = Instance.new("Attachment", workspace.Terrain)
                            attach_origin.Position = origin
                            local ending = origin + (type(bullet[1]) == "table" and bullet[1].unit.Unit or bullet[1].Unit) * 300
                            local attach_ending = Instance.new("Attachment", workspace.Terrain)
                            attach_ending.Position = ending
                            local beam = CreateBeam(attach_origin, attach_ending)
                            beam.Parent = workspace
                        end
                    end
                end
        
                if command == "repupdate" then   
                    if Toggles.AntiHide.Value and Options.AntiKey:GetState() and game_client.LocalPlayer.isAlive() then
                        args[1] = args[1] - Vector3.new(0, 1.2, 0)
                    end
                    
                    if Toggles.AntiEnabled.Value and Options.AntiKey:GetState() then
                        --{ "Off", "Up", "Down", "Random", "Sine Wave" }
                        --{Values = { "Off", "Backwards", "Spin", "Random" }
        
                        local AntiAimPitch = args[2].x
                        local AntiAimYaw = args[2].y
                        local newa
        
                        if Options.AntiPitch.Value == "Up" then
                            AntiAimPitch = 1.5
                        elseif Options.AntiPitch.Value == "Down" then
                            AntiAimPitch = -1.5
                        elseif Options.AntiPitch.Value == "Random" then
                            AntiAimPitch = math.random(-2, 2)
                        elseif Options.AntiPitch.Value == "Sine Wave" then
                            AntiAimPitch = math.sin(tick() * Options.AntiSineWave.Value) * 2
                        elseif Options.AntiPitch.Value == "Custom" then
                            AntiAimPitch = Options.AntiCustomPitch.Value / 2
                        end
        
                        if Options.AntiYaw.Value == "Backwards" then
                            AntiAimYaw += math.pi
                        elseif Options.AntiYaw.Value == "Spin" then
                            AntiAimYaw = (tick() * Options.AntiSpinRate.Value) % 12
                        elseif Options.AntiYaw.Value == "Random" then
                            AntiAimYaw = math.random(99999)
                        elseif Options.AntiYaw.Value == "Sine Wave" then
                            AntiAimYaw = math.sin(tick() * Options.AntiSineWave.Value) * 4
                        elseif Options.AntiYaw.Value == "Custom" then
                            AntiAimYaw = Options.AntiCustomYaw.Value / 50
                        end
                        
                        newa = newa or Vector2.new(AntiAimPitch, AntiAimYaw)
        
                        args[2] = newa
                    end
                end
        
                if command == "bullethit" then
                    --[[if Toggles.SupOnly.Value then return end

                    if Toggles.IgnoreFriends.Value and table.find(Friends, tostring(args[1])) then return end]]
                        
                    if Toggles.ExtraHeadsound.Value and tostring(args[3]) == "Head" then
                        local head = Instance.new("Sound")
                        head.Looped = false
                        head.Parent = workspace
                        head.Volume = Options.ExtraHeadsoundVolume.Value / 10
                        head.Pitch = Options.ExtraHeadsoundPitch.Value / 100
        
                        if isfile(shambles.workspace.."/Configs/sounds/"..Options.ExtraHeadsoundId.Value..".mp3") then
                            head.SoundId = getsynasset(shambles.workspace.."/Configs/sounds/"..Options.ExtraHeadsoundId.Value..".mp3")
                        elseif isfile(shambles.workspace.."/Configs/sounds/"..Options.ExtraHeadsoundId.Value..".wav") then
                            head.SoundId = getsynasset(shambles.workspace.."/Configs/sounds/"..Options.ExtraHeadsoundId.Value..".wav")
                        end
        
                        head:Play()
                    end
        
                    if Toggles.ExtraBodysound.Value and tostring(args[3]) == "Body" then
                        local body = Instance.new("Sound")
                        body.Looped = false
                        body.Parent = workspace            
                        body.Pitch = Options.ExtraBodysoundPitch.Value / 100
                        body.Volume = Options.ExtraBodysoundVolume.Value / 10
        
                        if isfile(shambles.workspace.."/Configs/sounds/"..Options.ExtraBodysoundId.Value..".mp3") then
                            body.SoundId = getsynasset(shambles.workspace.."/Configs/sounds/"..Options.ExtraBodysoundId.Value..".mp3")
                        elseif isfile(shambles.workspace.."/Configs/sounds/"..Options.ExtraBodysoundId.Value..".wav") then
                            head.SoundId = getsynasset(shambles.workspace.."/Configs/sounds/"..Options.ExtraBodysoundId.Value..".wav")
                        end    
        
                        body:Play()
                    end

                    --[[if Toggles.HitLogs.Value then
                        Library:Notify(string.format("Hit %s in the %s with a %s.", tostring(args[1]), tostring(args[3]), tostring(game_client.WCI:getController()._activeWeaponRegistry[curgun]._weaponData.name)), Options.HitLogTime.Value)
                    end]]
                end
        
                if command == "falldamage" then
                    if Toggles.MovementFall.Value then
                        return
                    end
                end
        
                if command == "stance" then
                    local third_person_object = fake_rep_object:getThirdPersonObject()
                    if third_person_object then
                        local stance = args[1]
                        third_person_object:setStance(stance)
                    end
                end
        
                if command == "aim" then
                    local third_person_object = fake_rep_object:getThirdPersonObject()
                    if third_person_object then
                        local aim = args[1]
                        third_person_object:setAim(aim)
                    end
                end
        
                if command == "equip" then
                    local third_person_object = fake_rep_object:getThirdPersonObject()
                    if third_person_object then
                        local weapon_index = args[1]
                        if weapon_index < 3 then
                            third_person_object:equip(weapon_index)
                        elseif weapon_index == 3 then
                            third_person_object:equipMelee(weapon_index)
                        end
                    end
                end
        
                if command == "sprint" then
                    local third_person_object = fake_rep_object:getThirdPersonObject()
                    if third_person_object then
                        local sprinting = args[1]
                        third_person_object:setSprint(sprinting)
                    end
                end
        
                if command == "stab" then
                    local third_person_object = fake_rep_object:getThirdPersonObject()
                    if third_person_object then
                        third_person_object:stab()
                    end
                end
        
                if command == "spawn" then
                    local third_person_object = fake_rep_object:getThirdPersonObject()
                    if third_person_object then
                        local character_model = third_person_object:popCharacterModel()
                        character_model:Destroy()
                        fake_rep_object:despawn()
                    end
        
                    local current_loadout = game_client.active_loadout.getActiveLoadoutData(game_client.player_data.getPlayerData())
                    fake_rep_object:spawn(nil, current_loadout)
                end
        
                if command == "forcereset" then
                    local third_person_object = fake_rep_object:getThirdPersonObject()
                    if third_person_object then
                        local character_model = third_person_object._character
                        character_model:Destroy()
                        fake_rep_object:despawn()
                    end
                end
        
                if command == "swapweapon" then
                    local third_person_object = fake_rep_object:getThirdPersonObject()
                    if third_person_object then
                        local weapon_index = args[2]
                        local weapon_dropped = args[1]
        
                        if weapon_index < 3 then
                            fake_rep_object._activeWeaponRegistry[weapon_index] = {
                                weaponName = weapon_dropped.Gun.Value,
                                weaponData = game_client.content_database.getWeaponData(weapon_dropped.Gun.Value),
                            }
                        else
                            fake_rep_object._activeWeaponRegistry[weapon_index] = {
                                weaponName = weapon_dropped.Knife.Value,
                                weaponData = game_client.content_database.getWeaponData(weapon_dropped.Knife.Value),
                            }
                        end
                    end
                end
        
                if command == "repupdate" then
                    if Toggles.ThirdPerson.Value and Options.ThirdPersonKey:GetState() and game_client.character_interface:isAlive() then
                        local third_person_object = fake_rep_object:getThirdPersonObject()
                        if not third_person_object then
                            local weapon_controller = game_client.weapon_controller_interface.getController()
                            fake_rep_object._activeWeaponRegistry[1] = {
                                weaponName = weapon_controller._activeWeaponRegistry[1]._weaponName, 
                                weaponData = weapon_controller._activeWeaponRegistry[1]._weaponData, 
                                attachmentData = weapon_controller._activeWeaponRegistry[1]._weaponAttachments, 
                                camoData = weapon_controller._activeWeaponRegistry[1]._camoList
                            }
        
                            fake_rep_object._activeWeaponRegistry[2] = {
                                weaponName = weapon_controller._activeWeaponRegistry[2]._weaponName, 
                                weaponData = weapon_controller._activeWeaponRegistry[2]._weaponData, 
                                attachmentData = weapon_controller._activeWeaponRegistry[2]._weaponAttachments, 
                                camoData = weapon_controller._activeWeaponRegistry[2]._camoList
                            }
        
                            fake_rep_object._activeWeaponRegistry[3] = {
                                weaponName = weapon_controller._activeWeaponRegistry[3]._weaponName, 
                                weaponData = weapon_controller._activeWeaponRegistry[3]._weaponData, 
                                camoData = weapon_controller._activeWeaponRegistry[3]._camoData
                            }
        
                            fake_rep_object._activeWeaponRegistry[4] = {
                                weaponName = weapon_controller._activeWeaponRegistry[4]._weaponName, 
                                weaponData = weapon_controller._activeWeaponRegistry[4]._weaponData
                            }
        
                            fake_rep_object._thirdPersonObject = game_client.third_person_object.new(fake_rep_object._player, nil, fake_rep_object)
                            fake_rep_object._thirdPersonObject:equip(weapon_controller._activeWeaponIndex, true)
                            fake_rep_object._alive = true
                        end
                        local clock_time = game_client.game_clock.getTime()
                        local tick = tick()
                        local velocity = Vector3.zero
        
                        if fake_rep_object._receivedPosition and fake_rep_object._receivedFrameTime then
                            velocity = (args[1] - fake_rep_object._receivedPosition) / (tick - fake_rep_object._receivedFrameTime);
                        end
                        
                        local broken = false
                        if fake_rep_object._lastPacketTime and clock_time - fake_rep_object._lastPacketTime > 0.5 then
                            broken = true
                            fake_rep_object._breakcount = fake_rep_object._breakcount + 1
                        end
        
                        fake_rep_object._smoothReplication:receive(clock_time, tick, {
                            t = tick, 
                            position = args[1],
                            velocity = velocity, 
                            angles = args[2], 
                            breakcount = fake_rep_object._breakcount
                        }, broken);
        
                        fake_rep_object._updaterecieved = true
                        fake_rep_object._receivedPosition = args[1]
                        fake_rep_object._receivedFrameTime = tick
                        fake_rep_object._lastPacketTime = clock_time
                        fake_rep_object:step(3, true)
                    else
                        local third_person_object = fake_rep_object:getThirdPersonObject()
                        if third_person_object then
                            local character_model = third_person_object:popCharacterModel()
                            character_model:Destroy()
                            fake_rep_object:despawn()
                        end
                    end
                end 
        
                if command == "newbullets" then
                    local third_person_object = fake_rep_object:getThirdPersonObject()
                    if third_person_object then
                        third_person_object:kickWeapon()
                    end
                end
        
                return send(self, command, table.unpack(args))
            end
        end
    end
end

Library:Notify(string.format("Welcome to shambles haxx, %s. Version: %s.\nLoaded modules in (%sms.)", shambles.username, shambles.version, math.floor((tick() - load1) * 1000)), 8, "time")