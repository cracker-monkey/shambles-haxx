
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	classSlotOrder = { "Assault", "Scout", "Support", "Recon" }, 
	loadoutSlotOrder = { "Primary", "Secondary", "Grenade", "Knife" }, 
	loadoutSlotDisplayName = {
		Knife = "Melee"
	}, 
	attachmentSlots = {
		Primary = { "Optics", "Barrel", "Underbarrel", "Other", "Ammo" }, 
		Secondary = { "Optics", "Barrel", "Other", "Ammo" }, 
		Grenade = {}, 
		Knife = {}, 
		Equipment = {}
	}, 
	classSlots = {
		Primary = {
			Assault = { "ASSAULT RIFLE", "BATTLE RIFLE", "CARBINE", "SHOTGUN" }, 
			Scout = { "PDW", "DMR", "CARBINE", "SHOTGUN" }, 
			Support = { "LMG", "BATTLE RIFLE", "CARBINE", "SHOTGUN" }, 
			Recon = { "SNIPER RIFLE", "DMR", "BATTLE RIFLE", "CARBINE" }
		}, 
		Secondary = {
			Assault = { "PISTOLS", "MACHINE PISTOLS", "REVOLVERS", "OTHER" }, 
			Scout = { "PISTOLS", "MACHINE PISTOLS", "REVOLVERS", "OTHER" }, 
			Support = { "PISTOLS", "MACHINE PISTOLS", "REVOLVERS", "OTHER" }, 
			Recon = { "PISTOLS", "MACHINE PISTOLS", "REVOLVERS", "OTHER" }
		}, 
		Grenade = {
			Assault = { "FRAGMENTATION", "HIGH EXPLOSIVE", "IMPACT" }, 
			Scout = { "FRAGMENTATION", "HIGH EXPLOSIVE", "IMPACT" }, 
			Support = { "FRAGMENTATION", "HIGH EXPLOSIVE", "IMPACT" }, 
			Recon = { "FRAGMENTATION", "HIGH EXPLOSIVE", "IMPACT" }
		}, 
		Knife = {
			Assault = { "ONE HAND BLADE", "TWO HAND BLADE", "ONE HAND BLUNT", "TWO HAND BLUNT" }, 
			Scout = { "ONE HAND BLADE", "TWO HAND BLADE", "ONE HAND BLUNT", "TWO HAND BLUNT" }, 
			Support = { "ONE HAND BLADE", "TWO HAND BLADE", "ONE HAND BLUNT", "TWO HAND BLUNT" }, 
			Recon = { "ONE HAND BLADE", "TWO HAND BLADE", "ONE HAND BLUNT", "TWO HAND BLUNT" }
		}
	}, 
	assignableWeaponClasses = { {
			weaponClass = "ASSAULT RIFLE", 
			weaponClassColor = Color3.new(0.3, 0.2, 0.1)
		}, {
			weaponClass = "BATTLE RIFLE", 
			weaponClassColor = Color3.new(0.2, 0.2, 0.1)
		}, {
			weaponClass = "CARBINE", 
			weaponClassColor = Color3.new(0.1, 0.2, 0.2)
		}, {
			weaponClass = "DMR", 
			weaponClassColor = Color3.new(0.1, 0.3, 0.3)
		}, {
			weaponClass = "LMG", 
			weaponClassColor = Color3.new(0.1, 0.2, 0.3)
		}, {
			weaponClass = "PDW", 
			weaponClassColor = Color3.new(0.2, 0.15, 0.2)
		}, {
			weaponClass = "SHOTGUN", 
			weaponClassColor = Color3.new(0.25, 0.15, 0.1)
		}, {
			weaponClass = "SNIPER RIFLE", 
			weaponClassColor = Color3.new(0.35, 0.25, 0.1)
		}, {
			weaponClass = "PISTOLS", 
			weaponClassColor = Color3.new(0.2, 0.25, 0.15)
		}, {
			weaponClass = "MACHINE PISTOLS", 
			weaponClassColor = Color3.new(0.2, 0.2, 0.3)
		}, {
			weaponClass = "REVOLVERS", 
			weaponClassColor = Color3.new(0.2, 0.25, 0.35)
		}, {
			weaponClass = "OTHER", 
			weaponClassColor = Color3.new(0.15, 0.25, 0.3)
		} }, 
	attachmentBaseSlots = {}, 
	weaponBaseSlots = {
		["Slot 1"] = "Slot1", 
		["Slot 2"] = "Slot2"
	}, 
	camoPropertyTypes = {
		BrickProperties = {
			BrickColor = {
				type = "string", 
				values = {
					[""] = true
				}
			}, 
			Color = {
				type = "table", 
				structure = {
					r = "number", 
					g = "number", 
					b = "number"
				}
			}, 
			Material = {
				type = "string", 
				values = {
					[""] = true
				}
			}, 
			Reflectance = {
				type = "number"
			}, 
			DefaultColor = {
				type = "boolean"
			}
		}, 
		TextureProperties = {
			Color = {
				type = "table", 
				structure = {
					r = "number", 
					g = "number", 
					b = "number"
				}
			}, 
			Transparency = {
				type = "number"
			}, 
			StudsPerTileU = {
				type = "number"
			}, 
			StudsPerTileV = {
				type = "number"
			}, 
			OffsetStudsU = {
				type = "number"
			}, 
			OffsetStudsV = {
				type = "number"
			}
		}
	}, 
	_init = function()
		local l__BrickProperties__1 = u1.camoPropertyTypes.BrickProperties;
		for v2 = 1, 1500 do
			l__BrickProperties__1.BrickColor.values[BrickColor.new(v2).Name] = true;
		end;
		for v3, v4 in Enum.Material() do
			l__BrickProperties__1.Material.values[v4.Name] = true;
		end;
	end
};
return u1;

