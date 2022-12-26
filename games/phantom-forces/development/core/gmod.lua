local Hooks = {}

if lol then
	Unloaded = true
end

_G.lol = "hi"
_G.Unloaded = false

surface.CreateFont("ESP",{font = "Verdana", size = 12, outline = true, weight = 500, antialias = false, blursize = 0})
surface.CreateFont("ESP2",{font = "Smallest Pixel-7", size = 11, outline = true, weight = 500, antialias = false, blursize = 0})

function AddHook( NormID, Event, ID, Function )
	table.insert( Hooks, NormID.."|"..Event.."|"..ID )
	hook.Add( Event, ID, Function )
end

function ESPGetPos( plr )
	local origin = plr:GetPos()
    local min, max = plr:GetCollisionBounds()
    min = min + origin
    max = max + origin
    
    local points = {
        Vector(min.x, min.y, min.z),
        Vector(min.x, max.y, min.z),
        Vector(max.x, max.y, min.z),
        Vector(max.x, min.y, min.z),
        Vector(max.x, max.y, max.z),
        Vector(min.x, max.y, max.z),
        Vector(min.x, min.y, max.z),
        Vector(max.x, min.y, max.z)
    }
    
    local flb = points[4]:ToScreen()
    local brt = points[6]:ToScreen()
    local blb = points[1]:ToScreen()
    local frt = points[5]:ToScreen()
    local frb = points[3]:ToScreen()
    local brb = points[2]:ToScreen()
    local blt = points[7]:ToScreen()
    local flt = points[8]:ToScreen()
    
    local arr = { flb, brt, blb, frt, frb, brb, blt, flt }
    
    local left = flb.x
    local top = flb.y
    local right = flb.x
    local bottom = flb.y
    
    for i=1,8 do
        if(arr[i]) then
            if (left > arr[i].x) then
                left = arr[i].x
            end
            if (bottom < arr[i].y) then
                bottom = arr[i].y
            end
            if (right < arr[i].x) then
                right = arr[i].x
            end
            if (top > arr[i].y) then
                top = arr[i].y
            end
        end
    end
    
    local bbox = {x=0,y=0,w=0,h=0}
 
    bbox.x = left
    bbox.y = top
    bbox.w = right - left
    bbox.h = bottom - top
 
    return bbox
end


local function ValidateESP(ply)
	if !IsValid(ply) or ply == LocalPlayer() or !ply:IsPlayer() or !ply:Alive() or ply:IsDormant() then 
		return false
	else
		return true
	end
end

local y_add = 0

AddHook( "ESP", "HUDPaint", tostring(math.random(-9999991231239999, 999999991231233299)), function()
	--for i, u in ipairs( player.GetAll() ) do
		for k, v in pairs( ents.GetAll() ) do
			if --[[ValidateESP(u) and v != LocalPlayer()]] v:IsValid() && v != LocalPlayer() && !v:IsDormant() && _G.Unloaded ~= true && (v:IsPlayer() or v:IsNPC()) then
				local entity = v
				local health, maxhealth = entity:Health() > 0 and entity:Health() or 0, entity:GetMaxHealth()

				y_add = 0

				if entity:Health() > 0 then
					local name = entity:IsNPC() and "NPC" or entity:Nick()

					local size = ESPGetPos(entity)

					local box = {
						x = size.x,
						y = size.y,
						w = size.w,
						h = size.h,
					}

					surface.SetDrawColor( Color(0, 0, 0) )

					for i = 0, 2 do
						surface.DrawLine(box.x - 1 + i, box.y - 1, box.x - 1 + i, box.y + box.h + 2)
						surface.DrawLine(box.x - 1, box.y - 1 + i, box.x + box.w - 1, box.y - 1 + i)
						surface.DrawLine(box.x + box.w - 1 + i, box.y - 1, box.x + box.w - 1 + i, box.y + box.h + 2)
						surface.DrawLine(box.x - 1, box.y + box.h - 1 + i, box.x + box.w - 1, box.y + box.h - 1 + i)
					end

					surface.SetDrawColor( Color(255, 255, 255) )
					surface.DrawLine(box.x, box.y, box.x, box.y + box.h)
					surface.DrawLine(box.x, box.y, box.x + box.w, box.y)
					surface.DrawLine(box.x + box.w, box.y, box.x + box.w, box.y + box.h)
					surface.DrawLine(box.x, box.y + box.h, box.x + box.w, box.y + box.h)

					local From = Vector(box.x - 5, box.y + box.h + 1)
					local To = Vector(From.X, From.Y - (health / maxhealth) * (box.h + 2))

					for i = 0, 2 do
						surface.SetDrawColor( Color(0, 0, 0) )
						surface.DrawLine(From.X - 1 + i, From.Y + 1, From.X - 1 + i, box.y - 2)
					end

					surface.SetDrawColor( Color(255, 255, 0) )
					surface.DrawLine(From.X, From.Y, To.X, To.Y)

					draw.SimpleText(tostring(health), "ESP2", box.x - 9, To.Y - 3, Color(255, 255, 255), TEXT_ALIGN_RIGHT)

					--[[if entity:Team() then
						draw.SimpleText(team.GetName( entity:Team() ), "ESP2", box.w + 9, To.Y - 4, Color(255, 255, 255), TEXT_ALIGN_LEFT)
					end]]

					local function flag(text, color)
						draw.SimpleText(text, "ESP2", box.x + box.w + 5, (To.Y - 3) + y_add, color, TEXT_ALIGN_LEFT)

						y_add = y_add + 8
					end
					
					flag("T", Color(255, 255, 255))
					flag("HK", Color(255, 255, 255))

					draw.SimpleText(name, "ESP2", box.x + box.w / 2, box.y - 13, Color(255, 255, 255), TEXT_ALIGN_CENTER)

					if entity:GetActiveWeapon():IsValid() then
						draw.SimpleText(entity:GetActiveWeapon():GetPrintName(), "ESP2", box.x + box.w / 2, box.y + box.h + 3, Color(255, 255, 255), TEXT_ALIGN_CENTER)
					end
				end
			end
		end
	--end

    if _G.Unloaded == true then
		for k, v in pairs( Hooks ) do
			local SubTable = string.Explode( "|", v )
			hook.Remove( SubTable[2], SubTable[3] )
		end
    end
end)    
