local Settings = LorePlay
local LAM2

local defaultSettingsTable = {
	isIdleEmotesOn = true,
	isLoreWearOn = true,
	canPlayInstrumentsInCities = true,
	canDanceInCities = true,
	canBeDrunkInCities = true,
	canExerciseInZone = true,
	canWorship = true,
	isUsingFavoriteCostume = false,
	favoriteCostumeId = nil,
	canActivateLWClothesWhileMounted = false,
	maraSpouseName = ""
}


function Settings.LoadSavedSettings()
	Settings.savedSettingsTable = defaultSettingsTable
	Settings.savedSettingsTable.isIdleEmotesOn = Settings.savedVariables.isIdleEmotesOn
	Settings.savedSettingsTable.isLoreWearOn = Settings.savedVariables.isLoreWearOn
	Settings.savedSettingsTable.canPlayInstrumentsInCities = Settings.savedVariables.canPlayInstrumentsInCities
	Settings.savedSettingsTable.canDanceInCities = Settings.savedVariables.canDanceInCities
	Settings.savedSettingsTable.canBeDrunkInCities = Settings.savedVariables.canBeDrunkInCities
	Settings.savedSettingsTable.canExerciseInZone = Settings.savedVariables.canExerciseInZone
	Settings.savedSettingsTable.canWorship = Settings.savedVariables.canWorship
	Settings.savedSettingsTable.isUsingFavoriteCostume = Settings.savedVariables.isUsingFavoriteCostume
	Settings.savedSettingsTable.favoriteCostumeId = Settings.savedVariables.favoriteCostumeId
	Settings.savedSettingsTable.maraSpouseName = Settings.savedVariables.maraSpouseName
	Settings.savedSettingsTable.canActivateLWClothesWhileMounted = Settings.savedVariables.canActivateLWClothesWhileMounted
end


function Settings.LoadMenuSettings()
	local panelData = {
		type = "panel",
		name = LorePlay.name,
		displayName = "|c8c7037LorePlay",
		author = "Justinon",
		version = LorePlay.version,
		registerForRefresh = true,
		registerForDefaults = true,
	}


	local optionsTable = {
		[1] = {
			type = "header",
			name = "Smart Emotes",
			width = "full",
		},
		[2] = {
			type = "description",
			title = nil,
			text = "|cFF0000Don't forget to bind your SmartEmotes button!|r\nContextual, appropriate emotes to perform at the touch of a button.\n",
			width = "full",
		},
		[3] = {
			type = "editbox",
			name = "Significant Other's Character Name",
			tooltip = "For those who have wed with the Ring of Mara, entering the exact character name of your loved one allows for special emotes between you two!\n(Note: Must be friends!)",
			getFunc = function() return Settings.savedSettingsTable.maraSpouseName end,
			setFunc = function(input)
				Settings.savedSettingsTable.maraSpouseName = input
				Settings.savedVariables.maraSpouseName = Settings.savedSettingsTable.maraSpouseName
			end,
			isMultiline = false,
			width = "full",
			default = "",
		},
		[4] = {
			type = "header",
			name = "Idle Emotes",
			width = "full",
		},
		[5] = {
			type = "description",
			title = nil,
			text = "Contextual, automatic emotes that occur when you go idle or AFK (Not moving, not fighting, not stealthing).\n",
			width = "full",
		},
		[6] = {
			type = "checkbox",
			name = "Toggle IdleEmotes On/Off",
			tooltip = "Turns on/off the automatic, contextual emotes that occur when you go idle or AFK.",
			getFunc = function() return Settings.savedSettingsTable.isIdleEmotesOn end,
			setFunc = function(setting) 
				Settings.savedSettingsTable.isIdleEmotesOn = setting
				Settings.savedVariables.isIdleEmotesOn = Settings.savedSettingsTable.isIdleEmotesOn
				if not Settings.savedSettingsTable.isIdleEmotesOn then LorePlay.UnregisterIdleEvents() end
				LorePlay.InitializeIdle()
			end,
			width = "full",
		},
		[7] = {
			type = "checkbox",
			name = "Can Play Instruments In Cities",
			tooltip = "Determines whether or not your character can perform instrument emotes when idle in cities.",
			getFunc = function() 
				if Settings.savedSettingsTable.isIdleEmotesOn then
					return Settings.savedSettingsTable.canPlayInstrumentsInCities
				else
					return false
				end
			end,
			setFunc = function(setting)
				if not Settings.savedSettingsTable.isIdleEmotesOn then return end
				Settings.savedSettingsTable.canPlayInstrumentsInCities = setting
				Settings.savedVariables.canPlayInstrumentsInCities = Settings.savedSettingsTable.canPlayInstrumentsInCities
				LorePlay.CreateDefaultIdleEmotesTable()
			end,
			width = "full",
		},
		[8] = {
			type = "checkbox",
			name = "Can Dance In Cities",
			tooltip = "Determines whether or not your character can perform dance emotes when idle in cities.",
			getFunc = function() 
				if Settings.savedSettingsTable.isIdleEmotesOn then
					return Settings.savedSettingsTable.canDanceInCities
				else
					return false
				end
			end,
			setFunc = function(setting)
				if not Settings.savedSettingsTable.isIdleEmotesOn then return end
				Settings.savedSettingsTable.canDanceInCities = setting
				Settings.savedVariables.canDanceInCities = Settings.savedSettingsTable.canDanceInCities
				LorePlay.CreateDefaultIdleEmotesTable()
			end,
			width = "full",
		},
		[9] = {
			type = "checkbox",
			name = "Can Be Drunk In Cities",
			tooltip = "Determines whether or not your character can perform drunken emotes when idle in cities.",
			getFunc = function() 
				if Settings.savedSettingsTable.isIdleEmotesOn then
					return Settings.savedSettingsTable.canBeDrunkInCities
				else
					return false
				end
			end,
			setFunc = function(setting)
				if not Settings.savedSettingsTable.isIdleEmotesOn then return end
				Settings.savedSettingsTable.canBeDrunkInCities = setting
				Settings.savedVariables.canBeDrunkInCities = Settings.savedSettingsTable.canBeDrunkInCities
				LorePlay.CreateDefaultIdleEmotesTable()
			end,
			width = "full",
		},
		[10] = {
			type = "checkbox",
			name = "Can Exercise Outside Cities",
			tooltip = "Determines whether or not your character can perform exercise emotes when idle outside of cities.",
			getFunc = function() 
				if Settings.savedSettingsTable.isIdleEmotesOn then
					return Settings.savedSettingsTable.canExerciseInZone
				else
					return false
				end
			end,
			setFunc = function(setting)
				if not Settings.savedSettingsTable.isIdleEmotesOn then return end
				Settings.savedSettingsTable.canExerciseInZone = setting
				Settings.savedVariables.canExerciseInZone = Settings.savedSettingsTable.canExerciseInZone
				LorePlay.CreateDefaultIdleEmotesTable()
			end,
			width = "full",
		},
		[11] = {
			type = "checkbox",
			name = "Can Worship/Pray",
			tooltip = "Determines whether or not your character can perform prayer and worship emotes when idle in general.",
			getFunc = function() 
				if Settings.savedSettingsTable.isIdleEmotesOn then
					return Settings.savedSettingsTable.canWorship
				else
					return false
				end
			end,
			setFunc = function(setting)
				if not Settings.savedSettingsTable.isIdleEmotesOn then return end
				Settings.savedSettingsTable.canWorship = setting
				Settings.savedVariables.canWorship = Settings.savedSettingsTable.canWorship
				LorePlay.CreateDefaultIdleEmotesTable()
			end,
			width = "full",
		},
		[12] = {
			type = "header",
			name = "Lore Wear",
			width = "full",
		},
		[13] = {
			type = "description",
			title = nil,
			text = "Armor should be worn when venturing Tamriel, but not when in comfortable cities! Your character will automatically equip his/her favorite (or a random) costume anytime he/she enters a city, and unequip upon exiting.\n",
			width = "full",
		},
		[14] = {
			type = "checkbox",
			name = "Toggle LoreWear On/Off",
			tooltip = "Turns on/off the automatic, contextual clothing that will be put on when entering cities.\n(Note: Disabling LoreWear displays all its settings as off, but will persist after re-enabling.)",
			getFunc = function() return Settings.savedSettingsTable.isLoreWearOn end,
			setFunc = function(setting) 
				Settings.savedSettingsTable.isLoreWearOn = setting
				Settings.savedVariables.isLoreWearOn = Settings.savedSettingsTable.isLoreWearOn
				if not Settings.savedSettingsTable.isLoreWearOn then 
					LorePlay.UnregisterLoreWearEvents()
				else
					LorePlay.ReenableLoreWear()
				end
			end,
			width = "full",
		},
		[15] = {
			type = "checkbox",
			name = "Allow Equip While Mounted",
			tooltip = "Turns on/off the automatic, contextual clothing that can be put on while riding your trusty steed.",
			getFunc = function() 
				if Settings.savedSettingsTable.isLoreWearOn then
					return Settings.savedSettingsTable.canActivateLWClothesWhileMounted
				else
					return false
				end
			end,
			setFunc = function(setting) 
				if not Settings.savedSettingsTable.isLoreWearOn then return end
				Settings.savedSettingsTable.canActivateLWClothesWhileMounted = setting
				Settings.savedVariables.canActivateLWClothesWhileMounted = Settings.savedSettingsTable.canActivateLWClothesWhileMounted 
			end,
			width = "full",
		},
		[16] = {
			type = "checkbox",
			name = "Use Favorite Costume",
			tooltip = "If enabled, uses your favorite costume when entering cities, as opposed to picking from the defaults randomly.",
			getFunc = function() 
				if Settings.savedSettingsTable.isLoreWearOn then
					return Settings.savedSettingsTable.isUsingFavoriteCostume 
				else
					return false
				end
			end,
			setFunc = function(setting)
				if not Settings.savedSettingsTable.isLoreWearOn then return end
				Settings.savedSettingsTable.isUsingFavoriteCostume = setting
				Settings.savedVariables.isUsingFavoriteCostume = Settings.savedSettingsTable.isUsingFavoriteCostume 
			end,
			width = "full",
			default = false,
		},
		[17] = {
		type = "button",
		name = "Set Favorite Costume",
		tooltip = "Sets the current costume your character is wearing as his/her favorite costume, allowing him/her to automatically put it on/off when entering/exiting cities. Also turns 'Use Favorite Costume' on upon pressing.",
		func = function()
			local collectibleId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
			if collectibleId == 0 then CHAT_SYSTEM:AddMessage("No costume was detected.") return end
			Settings.savedSettingsTable.favoriteCostumeId = collectibleId
			Settings.savedVariables.favoriteCostumeId = Settings.savedSettingsTable.favoriteCostumeId
			Settings.savedSettingsTable.isUsingFavoriteCostume = true
			Settings.savedVariables.isUsingFavoriteCostume = Settings.savedSettingsTable.isUsingFavoriteCostume
			CHAT_SYSTEM:AddMessage("Favorite costume set as '"..GetCollectibleName(collectibleId).."'")
			end,
		width = "half",
		},
		[18] = {
		type = "button",
		name = "Clear Favorite Costume",
		tooltip = "Clears the current costume your character has selected as his/her favorite, allowing him/her to automatically put on/off random costumes when entering/exiting cities. Also turns 'Use Favorite Costume' off upon pressing.",
		func = function()
			if not Settings.savedSettingsTable.favoriteCostumeId then return end 
			local collectibleName = GetCollectibleName(Settings.savedSettingsTable.favoriteCostumeId)
			Settings.savedSettingsTable.favoriteCostumeId = nil
			Settings.savedVariables.favoriteCostumeId = Settings.savedSettingsTable.favoriteCostumeId
			Settings.savedSettingsTable.isUsingFavoriteCostume = false
			Settings.savedVariables.isUsingFavoriteCostume = Settings.savedSettingsTable.isUsingFavoriteCostume
			CHAT_SYSTEM:AddMessage("Favorite costume is no longer '"..collectibleName.."'")
			end,
		width = "half",
		},
	}

	LAM2:RegisterAddonPanel("MyAddonOptions", panelData)
	LAM2:RegisterOptionControls("MyAddonOptions", optionsTable)
end


function Settings.InitializeSettings()
	Settings.savedVariables = ZO_SavedVars:New("LorePlaySavedVars", LorePlay.majorVersion, nil, defaultSettingsTable)
	Settings.LoadSavedSettings()
	LAM2 = LibStub("LibAddonMenu-2.0")
	Settings.LoadMenuSettings()
end

LorePlay = Settings