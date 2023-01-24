
-- Decompiled with the Synapse X Luau decompiler.

return {
	robuxColor = Color3.fromRGB(73, 199, 0), 
	creditsColor = Color3.fromRGB(255, 216, 61), 
	defaultTextColor = Color3.fromRGB(255, 255, 255), 
	assignedWeaponColor = Color3.fromRGB(73, 199, 0), 
	previewDisplayStatsColor = Color3.fromRGB(76, 61, 61), 
	defaultDisplayStatsColor = Color3.fromRGB(46, 116, 104), 
	defaultDisplayTextStatsColor = Color3.fromRGB(255, 255, 255), 
	previewDisplayTextStatsColor = Color3.fromRGB(255, 205, 23), 
	menuColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(55, 127, 158)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(36, 86, 107)
		}
	}, 
	subMenuColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(46, 116, 104)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(25, 63, 56)
		}
	}, 
	toggleColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(47, 47, 47), 
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(65, 65, 65), 
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}
	}, 
	mapToggleColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(65, 65, 65), 
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(102, 102, 102), 
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}
	}, 
	promptConfirmColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(36, 102, 0)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(17, 53, 17)
		}
	}, 
	squadDeployColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(85, 85, 85), 
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(55, 83, 89), 
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}
	}, 
	promptCancelColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(116, 38, 38)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(53, 17, 17)
		}
	}, 
	inventoryBoxColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(75, 75, 75)
		}
	}, 
	loadoutClassColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(47, 47, 47), 
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(41, 117, 143), 
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}
	}, 
	weaponClassColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(47, 47, 47), 
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(46, 116, 104), 
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}
	}, 
	weaponListColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(226, 226, 226)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(113, 113, 113)
		}
	}, 
	lockedWeaponListColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(124, 124, 124)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		}
	}, 
	purchaseWeaponPreviewColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(58, 58, 58)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(136, 136, 136)
		}
	}, 
	inventoryActionButton = {
		default = {
			BackgroundColor3 = Color3.fromRGB(47, 47, 47)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(113, 113, 113)
		}
	}, 
	adminWeaponListColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(191, 128, 32)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(113, 113, 113)
		}
	}, 
	testWeaponListColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(191, 64, 64)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(113, 113, 113)
		}
	}, 
	superTestWeaponListColorConfig = {
		default = {
			BackgroundColor3 = Color3.fromRGB(32, 191, 191)
		}, 
		highlighted = {
			BackgroundColor3 = Color3.fromRGB(113, 113, 113)
		}
	}, 
	weaponRankHintColors = {
		[true] = {
			TextColor3 = Color3.fromRGB(75, 225, 75)
		}, 
		[false] = {
			TextColor3 = Color3.fromRGB(255, 175, 50)
		}
	}, 
	rarityColorConfig = {
		[0] = {
			Name = "Default", 
			Color = Color3.new(0.3333333333333333, 0.3333333333333333, 0.3333333333333333)
		},
		{
			Name = "Common", 
			Color = Color3.fromRGB(25, 50, 100)
		}, {
			Name = "Uncommon", 
			Color = Color3.fromRGB(75, 50, 100)
		}, {
			Name = "Rare", 
			Color = Color3.fromRGB(150, 50, 150)
		}, {
			Name = "Very Rare", 
			Color = Color3.fromRGB(150, 25, 25)
		}, {
			Name = "Legendary", 
			Color = Color3.fromRGB(200, 150, 25)
		}, {
			Name = "Unknown", 
			Color = Color3.new(0.125, 0.125, 0.125), 
			TextColor = Color3.fromRGB(221, 215, 215), 
			TextHintColor = Color3.fromRGB(136, 17, 17)
		}
	}
};

