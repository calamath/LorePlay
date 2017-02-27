local Settings = {}
local LAM2
EVENT_INDICATOR_MOVED = "EVENT_INDICATOR_MOVED"

local defaultSettingsTable = {
	isIdleEmotesOn = true,
	isLoreWearOn = true,
	isSmartEmotesIndicatorOn = true,
	canPlayInstrumentsInCities = true,
	canDanceInCities = true,
	canBeDrunkInCities = true,
	canExerciseInZone = true,
	canWorship = true,
	--isUsingFavoriteOutfit = false,
	isUsingFavoriteCostume = false,
	isUsingFavoriteHat = false,
	isUsingFavoriteHair = false,
	isUsingFavoriteSkin = false,
	shouldFavoriteOverride = true,
	equipPreviousCostumeWhenAdventuring = true,
	favoriteCostumeId = nil,
	favoriteHatId = nil,
	favoriteHairId = nil,
	favoriteSkinId = nil,
	blacklistedCostumes = {
		["count"] = 0
	},
	canActivateLWClothesWhileMounted = false,
	maraSpouseName = "",
	indicatorLeft = nil,
	indicatorTop = nil,
	timeBetweenIdleEmotes = 30000
}


function Settings.LoadSavedSettings()
	--Settings.savedSettingsTable = defaultSettingsTable
	Settings.savedSettingsTable = {}
	Settings.savedSettingsTable.isIdleEmotesOn = Settings.savedVariables.isIdleEmotesOn
	Settings.savedSettingsTable.isLoreWearOn = Settings.savedVariables.isLoreWearOn
	Settings.savedSettingsTable.isSmartEmotesIndicatorOn = Settings.savedVariables.isSmartEmotesIndicatorOn
	Settings.savedSettingsTable.canPlayInstrumentsInCities = Settings.savedVariables.canPlayInstrumentsInCities
	Settings.savedSettingsTable.canDanceInCities = Settings.savedVariables.canDanceInCities
	Settings.savedSettingsTable.canBeDrunkInCities = Settings.savedVariables.canBeDrunkInCities
	Settings.savedSettingsTable.canExerciseInZone = Settings.savedVariables.canExerciseInZone
	Settings.savedSettingsTable.canWorship = Settings.savedVariables.canWorship
	Settings.savedSettingsTable.isUsingFavoriteCostume = Settings.savedVariables.isUsingFavoriteCostume
	Settings.savedSettingsTable.isUsingFavoriteHat = Settings.savedVariables.isUsingFavoriteHat
	Settings.savedSettingsTable.isUsingFavoriteHair = Settings.savedVariables.isUsingFavoriteHair
	Settings.savedSettingsTable.isUsingFavoriteSkin = Settings.savedVariables.isUsingFavoriteSkin
	Settings.savedSettingsTable.shouldFavoriteOverride = Settings.savedVariables.shouldFavoriteOverride
	Settings.savedSettingsTable.equipPreviousCostumeWhenAdventuring = Settings.savedVariables.equipPreviousCostumeWhenAdventuring
	Settings.savedSettingsTable.favoriteCostumeId = Settings.savedVariables.favoriteCostumeId
	Settings.savedSettingsTable.favoriteHatId = Settings.savedVariables.favoriteHatId
	Settings.savedSettingsTable.favoriteHairId = Settings.savedVariables.favoriteHairId
	Settings.savedSettingsTable.favoriteSkinId = Settings.savedVariables.favoriteSkinId
	Settings.savedSettingsTable.blacklistedCostumes = Settings.savedVariables.blacklistedCostumes
	Settings.savedSettingsTable.maraSpouseName = Settings.savedVariables.maraSpouseName
	Settings.savedSettingsTable.canActivateLWClothesWhileMounted = Settings.savedVariables.canActivateLWClothesWhileMounted
	Settings.savedSettingsTable.indicatorLeft = Settings.savedVariables.indicatorLeft
	Settings.savedSettingsTable.indicatorTop = Settings.savedVariables.indicatorTop
	Settings.savedSettingsTable.timeBetweenIdleEmotes = Settings.savedVariables.timeBetweenIdleEmotes
end


local function ResetIndicator()
	SmartEmotesIndicator:ClearAnchors()
	SmartEmotesIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 0, 0)
	Settings.savedSettingsTable.indicatorLeft = nil
	Settings.savedSettingsTable.indicatorTop = nil
	Settings.savedVariables.indicatorLeft = Settings.savedSettingsTable.indicatorLeft
	Settings.savedVariables.indicatorTop = Settings.savedSettingsTable.indicatorTop
end


local function OnIndicatorMoved(eventCode, top, left)
	Settings.savedSettingsTable.indicatorTop = top
	Settings.savedSettingsTable.indicatorLeft = left
	Settings.savedVariables.indicatorTop = Settings.savedSettingsTable.indicatorTop
	Settings.savedVariables.indicatorLeft = Settings.savedSettingsTable.indicatorLeft
end


local function GetBlacklistedCostumeStrings()
	local blacklist = Settings.savedSettingsTable.blacklistedCostumes
	if not blacklist then return end
	local string = ""
	if blacklist["count"] ~= 0 then
		for i,v in pairs(blacklist) do
			if i ~= "count" then
				string = string.."'"..GetCollectibleName(v).."'".." "
			end
		end
		return string
	else
		return string.."None"
	end
end


local function CheckBlacklistForCostumeId(collectibleId)
	if collectibleId == 0 then return false end
	local blacklist = Settings.savedSettingsTable.blacklistedCostumes
	if not blacklist then
		blacklist = {}
		Settings.savedSettingsTable.blacklistedCostumes = blacklist
		return false
	end
	local idString = tostring(collectibleId)
	if blacklist[idString] then
		return idString
	end
	return false
end


local function RemoveBlacklistedCostumeId(costumeId)
	local idString = CheckBlacklistForCostumeId(costumeId)
	if idString then
		Settings.savedSettingsTable.blacklistedCostumes[idString] = nil
		Settings.savedVariables.blacklistedCostumes = Settings.savedSettingsTable.blacklistedCostumes
		return true
	end
end


local function UnblacklistCurrentCostume()
	if not Settings.savedSettingsTable.blacklistedCostumes then return end 
	local collectibleId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
	if not RemoveBlacklistedCostumeId(collectibleId) then
		return false
	end
	local count = Settings.savedSettingsTable.blacklistedCostumes["count"]
	Settings.savedSettingsTable.blacklistedCostumes["count"] = count - 1
	LorePlay.UpdateUnlockedCostumes()
	return GetCollectibleName(collectibleId)
end


local function ClearBlacklist()
	if Settings.savedSettingsTable.blacklistedCostumes["count"] == 0 then
		CHAT_SYSTEM:AddMessage("Nothing is on your blacklist.")
		return
	end
	local blacklisted = GetBlacklistedCostumeStrings()
	Settings.savedSettingsTable.blacklistedCostumes = {
		["count"] = 0
	}
	Settings.savedVariables.blacklistedCostumes = Settings.savedSettingsTable.blacklistedCostumes
	LorePlay.UpdateUnlockedCostumes()
	CHAT_SYSTEM:AddMessage("Blacklist cleared. The following items were removed: "..blacklisted)
end


local function BlacklistCostume()
	local collectibleId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
	if collectibleId == 0 then CHAT_SYSTEM:AddMessage("No costume was detected.") return end
	if collectibleId == Settings.savedSettingsTable.favoriteCostumeId then 
		CHAT_SYSTEM:AddMessage("Current costume is your favorite! Clear it from your favorites first, just to be sure you meant to do this.")
		return 
	end
	if CheckBlacklistForCostumeId(collectibleId) then
		CHAT_SYSTEM:AddMessage("Current costume already blacklisted.")
		return
	end
	Settings.savedSettingsTable.blacklistedCostumes[tostring(collectibleId)] = collectibleId
	local count = Settings.savedSettingsTable.blacklistedCostumes["count"]
	Settings.savedSettingsTable.blacklistedCostumes["count"] = count + 1 
	Settings.savedVariables.blacklistedCostumes = Settings.savedSettingsTable.blacklistedCostumes
	LorePlay.UpdateUnlockedCostumes()
	CHAT_SYSTEM:AddMessage("Blacklisted costume added as '"..GetCollectibleName(collectibleId).."'")
end


local function UnblacklistCostume()
	local nameOfRemoved = UnblacklistCurrentCostume()
	if not nameOfRemoved then
		CHAT_SYSTEM:AddMessage("Current costume not found in blacklist.")
	else
		CHAT_SYSTEM:AddMessage("Blacklist no longer contains '"..nameOfRemoved.."'")
	end
end


local function SetFavoriteCostume()
	local collectibleId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
	if collectibleId == 0 then CHAT_SYSTEM:AddMessage("No costume was detected.") return end
	if UnblacklistCurrentCostume() then
		CHAT_SYSTEM:AddMessage("Current costume was on your blacklist, but setting it as your favorite removed it from the blacklist.")
	end
	Settings.savedSettingsTable.favoriteCostumeId = collectibleId
	Settings.savedVariables.favoriteCostumeId = Settings.savedSettingsTable.favoriteCostumeId
	Settings.savedSettingsTable.isUsingFavoriteCostume = true
	Settings.savedVariables.isUsingFavoriteCostume = Settings.savedSettingsTable.isUsingFavoriteCostume
	CHAT_SYSTEM:AddMessage("Favorite costume set as '"..GetCollectibleName(collectibleId).."'")
end


local function SetFavoriteHat()
	local collectibleId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAT)
	if collectibleId == 0 then CHAT_SYSTEM:AddMessage("No hat was detected.") return end
	Settings.savedSettingsTable.favoriteHatId = collectibleId
	Settings.savedVariables.favoriteHatId = Settings.savedSettingsTable.favoriteHatId
	--Settings.savedSettingsTable.isUsingFavoriteHat = true
	Settings.savedVariables.isUsingFavoriteHat = Settings.savedSettingsTable.isUsingFavoriteHat
	CHAT_SYSTEM:AddMessage("Favorite hat set as '"..GetCollectibleName(collectibleId).."'")
end

local function SetFavoriteHair()
	local collectibleId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAIR)
	Settings.savedSettingsTable.favoriteHairId = collectibleId
	Settings.savedVariables.favoriteHairId = Settings.savedSettingsTable.favoriteHairId
	--Settings.savedSettingsTable.isUsingFavoriteHat = true
	Settings.savedVariables.isUsingFavoriteHair = Settings.savedSettingsTable.isUsingFavoriteHair
	CHAT_SYSTEM:AddMessage("Favorite hair set as '"..GetCollectibleName(collectibleId).."'")
end


local function SetFavoriteSkin()
	local collectibleId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_SKIN)
	if collectibleId == 0 then CHAT_SYSTEM:AddMessage("No skin was detected.") return end
	Settings.savedSettingsTable.favoriteSkinId = collectibleId
	Settings.savedVariables.favoriteSkinId = Settings.savedSettingsTable.favoriteSkinId
	--Settings.savedSettingsTable.isUsingFavoriteHat = true
	Settings.savedVariables.isUsingFavoriteSkin = Settings.savedSettingsTable.isUsingFavoriteSkin
	CHAT_SYSTEM:AddMessage("Favorite skin set as '"..GetCollectibleName(collectibleId).."'")
end



--[[ WIP ]]--
local function SetFavoriteOutfit()
	if Settings.savedSettingsTable.isUsingFavoriteCostume then
		SetFavoriteCostume()
	end
	if Settings.savedSettingsTable.isUsingFavoriteHat then
		SetFavoriteHat()
	end
	if Settings.savedSettingsTable.isUsingFavoriteHair then
		SetFavoriteHair()
	end
	if Settings.savedSettingsTable.isUsingFavoriteSkin then
		SetFavoriteSkin()
	end
end


local function ClearFavoriteOutfit()
	if Settings.savedSettingsTable.favoriteCostumeId then 
		Settings.savedSettingsTable.favoriteCostumeId = nil
		Settings.savedVariables.favoriteCostumeId = Settings.savedSettingsTable.favoriteCostumeId
		Settings.savedSettingsTable.isUsingFavoriteCostume = false
		Settings.savedVariables.isUsingFavoriteCostume = Settings.savedSettingsTable.isUsingFavoriteCostume
	end
	if Settings.savedSettingsTable.favoriteHatId then
		Settings.savedSettingsTable.favoriteHatId = nil
		Settings.savedVariables.favoriteHatId = Settings.savedSettingsTable.favoriteHatId
		Settings.savedSettingsTable.isUsingFavoriteHat = false
		Settings.savedVariables.isUsingFavoriteHat = Settings.savedSettingsTable.isUsingFavoriteHat
	end
	if Settings.savedSettingsTable.favoriteHairId then
		Settings.savedSettingsTable.favoriteHairId = nil
		Settings.savedVariables.favoriteHairId = Settings.savedSettingsTable.favoriteHairId
		Settings.savedSettingsTable.isUsingFavoriteHair = false
		Settings.savedVariables.isUsingFavoriteHair = Settings.savedSettingsTable.isUsingFavoriteHair
	end
	if Settings.savedSettingsTable.favoriteSkinId then
		Settings.savedSettingsTable.favoriteSkinId = nil
		Settings.savedVariables.favoriteSkinId = Settings.savedSettingsTable.favoriteSkinId
		Settings.savedSettingsTable.isUsingFavoriteSkin = false
		Settings.savedVariables.isUsingFavoriteSkin = Settings.savedSettingsTable.isUsingFavoriteSkin
	end
	CHAT_SYSTEM:AddMessage("Favorite outfit cleared.")
end



function Settings.ToggleIdleEmotes(settings)
	if Settings.savedSettingsTable.isIdleEmotesOn == settings then return end
	Settings.savedSettingsTable.isIdleEmotesOn = settings
	Settings.savedVariables.isIdleEmotesOn = Settings.savedSettingsTable.isIdleEmotesOn
	if not Settings.savedSettingsTable.isIdleEmotesOn then LorePlay.UnregisterIdleEvents() end
	LorePlay.InitializeIdle()
	if settings then 
		CHAT_SYSTEM:AddMessage("Toggled IdleEmotes on")
	else
		CHAT_SYSTEM:AddMessage("Toggled IdleEmotes off")
	end
end




function Settings.LoadMenuSettings()
	local panelData = {
		type = "panel",
		name = LorePlay.name,
		displayName = "|c8c7037LorePlay",
		author = "Justinon",
		version = LorePlay.version,
		slashCommand = "/loreplay",
		registerForRefresh = true,
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
			text = "Contextual, appropriate emotes to perform at the touch of a button.\nBy default, pressing performs an emote based on location. However, it adapts and conforms to many different special environmental situations along your travels as well.\n|cFF0000Don't forget to bind your SmartEmotes button!|r",
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
			type = "checkbox",
			name = "Toggle Indicator On/Off",
			tooltip = "Turns on/off the small, moveable indicator (drama masks) that appears on your screen whenever new special adaptive SmartEmotes are available to be performed.",
			getFunc = function() return Settings.savedSettingsTable.isSmartEmotesIndicatorOn end,
			setFunc = function(setting) 
				Settings.savedSettingsTable.isSmartEmotesIndicatorOn = setting
				Settings.savedVariables.isSmartEmotesIndicatorOn = Settings.savedSettingsTable.isSmartEmotesIndicatorOn
				if not Settings.savedSettingsTable.isSmartEmotesIndicatorOn then
					SmartEmotesIndicator:SetHidden(true)
				end
			end,
			width = "full",
		},
		[5] = {
			type = "button",
			name = "Reset Indicator Position",
			tooltip = "Resets the indicator to be positioned in the top left of the screen.",
			func = function() ResetIndicator() end,
			width = "full",
		},
		[6] = {
			type = "header",
			name = "Idle Emotes",
			width = "full",
		},
		[7] = {
			type = "description",
			title = nil,
			text = "Contextual, automatic emotes that occur when you go idle or AFK (Not moving, not fighting, not stealthing).\n",
			width = "full",
		},
		[8] = {
			type = "checkbox",
			name = "Toggle IdleEmotes On/Off",
			tooltip = "Turns on/off the automatic, contextual emotes that occur when you go idle or AFK.\n(Note: Disabling IdleEmotes displays all its settings as off, but will persist after re-enabling.)",
			getFunc = function() return Settings.savedSettingsTable.isIdleEmotesOn end,
			setFunc = function(setting) 
				Settings.ToggleIdleEmotes(setting)
			end,
			width = "full",
			reference = "IdleEmotesToggleCheckbox",
		},
		[9] = {
			type = "slider",
			name = "Emote Duration",
			tooltip = "Determines how long in seconds a given idle emote will be performed before switching to a new one.\nDefault is 30 seconds.",
			min = 10,
			max = 120,
			step = 2,
			getFunc = function() 
				return Settings.savedSettingsTable.timeBetweenIdleEmotes/1000 -- Converting ms to s
			end,
			setFunc = function(value)
				if not Settings.savedSettingsTable.isIdleEmotesOn then return end
				Settings.savedSettingsTable.timeBetweenIdleEmotes = (value*1000) -- Converting seconds to ms
				Settings.savedVariables.timeBetweenIdleEmotes = Settings.savedSettingsTable.timeBetweenIdleEmotes
			end,
			width = "full",
			default = 30,
		},
		[10] = {
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
		[11] = {
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
		[12] = {
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
		[13] = {
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
		[14] = {
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
		[15] = {
			type = "header",
			name = "Lore Wear",
			width = "full",
		},
		[16] = {
			type = "description",
			title = nil,
			text = "Armor should be worn when venturing Tamriel, but not when in comfortable cities! Your character will automatically equip his/her favorite (or a random) costume anytime he/she enters a city, and unequip upon exiting.\n|cFF0000Don't forget to bind your LoreWear show/hide clothes button!|r",
			width = "full",
		},
		[17] = {
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
		[18] = {
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
		[19] = {
			type = "checkbox",
			name = "Equip Last Worn Costume When Adventuring",
			tooltip = "If enabled, when exiting a city your character will equip the last worn costume from before entering the city.\nIf disabled, your character will show armor when exiting a city regardless of what was previously worn.",
			getFunc = function() 
				if Settings.savedSettingsTable.isLoreWearOn then
					return Settings.savedSettingsTable.equipPreviousCostumeWhenAdventuring
				else
					return false
				end
			end,
			setFunc = function(setting) 
				if not Settings.savedSettingsTable.isLoreWearOn then return end
				Settings.savedSettingsTable.equipPreviousCostumeWhenAdventuring = setting
				Settings.savedVariables.equipPreviousCostumeWhenAdventuring = Settings.savedSettingsTable.equipPreviousCostumeWhenAdventuring 
			end,
			width = "full",
		},
		[20] = {
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
		[21] = {
			type = "checkbox",
			name = "Use Favorite Hat",
			tooltip = "If enabled, uses your favorite hat when entering cities, along with your other favorite collectibles.",
			getFunc = function() 
				if Settings.savedSettingsTable.isLoreWearOn then
					return Settings.savedSettingsTable.isUsingFavoriteHat 
				else
					return false
				end
			end,
			setFunc = function(setting)
				if not Settings.savedSettingsTable.isLoreWearOn then return end
				Settings.savedSettingsTable.isUsingFavoriteHat = setting
				Settings.savedVariables.isUsingFavoriteHat = Settings.savedSettingsTable.isUsingFavoriteHat
			end,
			width = "full",
			default = false,
		},
		[22] = {
			type = "checkbox",
			name = "Use Favorite Hair",
			tooltip = "If enabled, uses your favorite hair when entering cities, along with your other favorite collecibles.",
			getFunc = function() 
				if Settings.savedSettingsTable.isLoreWearOn then
					return Settings.savedSettingsTable.isUsingFavoriteHair 
				else
					return false
				end
			end,
			setFunc = function(setting)
				if not Settings.savedSettingsTable.isLoreWearOn then return end
				Settings.savedSettingsTable.isUsingFavoriteHair = setting
				Settings.savedVariables.isUsingFavoriteHair = Settings.savedSettingsTable.isUsingFavoriteHair
			end,
			width = "full",
			default = false,
		},
		[23] = {
			type = "checkbox",
			name = "Use Favorite Skin",
			tooltip = "If enabled, uses your favorite skin when entering cities, along with your other favorite collectibles.",
			getFunc = function() 
				if Settings.savedSettingsTable.isLoreWearOn then
					return Settings.savedSettingsTable.isUsingFavoriteSkin 
				else
					return false
				end
			end,
			setFunc = function(setting)
				if not Settings.savedSettingsTable.isLoreWearOn then return end
				Settings.savedSettingsTable.isUsingFavoriteSkin = setting
				Settings.savedVariables.isUsingFavoriteSkin = Settings.savedSettingsTable.isUsingFavoriteSkin
			end,
			width = "full",
			default = false,
		},
		[24] = {
			type = "checkbox",
			name = "Should Favorite Override Others",
			tooltip = "If enabled, uses your favorite outfit when entering cities, even if you enter the city wearing a different outfit.\nIf disabled, if you enter a city with a different outfit, your favorite will NOT be put on over it.\nThis is to allow for easy, individual outfit selection without changing your favorite.",
			getFunc = function() 
				if Settings.savedSettingsTable.isLoreWearOn and Settings.savedSettingsTable.isUsingFavoriteCostume then
					return Settings.savedSettingsTable.shouldFavoriteOverride
				else
					return false
				end
			end,
			setFunc = function(setting)
				if not Settings.savedSettingsTable.isLoreWearOn or not Settings.savedSettingsTable.isUsingFavoriteCostume then return end
				Settings.savedSettingsTable.shouldFavoriteOverride = setting
				Settings.savedVariables.shouldFavoriteOverride = Settings.savedSettingsTable.shouldFavoriteOverride 
			end,
			width = "full",
			default = true,
		},
		[25] = {
			type = "button",
			name = "Set Favorite Outfit",
			tooltip = "Sets the current outfit (costumes, hats, hair, skins) your character is wearing as your favorite, allowing your character to automatically put it on/off when entering/exiting cities.",
			func = function()
				SetFavoriteOutfit()
			end,
			width = "half",
		},
		[26] = {
			type = "button",
			name = "Clear Favorite Outfit",
			tooltip = "Clears the outfit you have previously selected as your favorite. Also turns 'Use Favorite [collectible]' off upon pressing for each favorited collectible type.",
			func = function()
				ClearFavoriteOutfit()
			end,
			width = "half",
		},
		[27] = {
			type = "button",
			name = "Blacklist Costume",
			tooltip = "Sets the current costume your character is wearing as a blacklisted costume, no longer allowing it to be automatically put on/off when entering/exiting cities.",
			func = function() BlacklistCostume() end,
			width = "half",
		},
		[28] = {
			type = "button",
			name = "Unblacklist Costume",
			tooltip = "Removes the current costume your character is wearing from the blacklist, re-allowing it to be automatically put on/off from the random costumes when entering/exiting cities.",
			func = function() UnblacklistCostume() end,
			width = "half",
		},
		[29] = {
			type = "button",
			name = "Show Blacklist",
			tooltip = "Prints the names of all the costumes currently blacklisted to the chat box.",
			func = function()
				if Settings.savedSettingsTable.blacklistedCostumes["count"] == 0 then
					CHAT_SYSTEM:AddMessage("Nothing is on your blacklist.")
					return
				end
				CHAT_SYSTEM:AddMessage("Number of blacklisted costumes: "..tostring(Settings.savedSettingsTable.blacklistedCostumes["count"]).."\nCurrent blacklisted costume(s): "..GetBlacklistedCostumeStrings())
			end,
			width = "half",
		},
		[30] = {
			type = "button",
			name = "Clear Blacklist",
			tooltip = "Wipes your blacklist clean, allowing your character to now automatically equip/unequip anything that was once on the list.",
			func = function() ClearBlacklist() end,
			width = "half",
		},
	}

	LAM2:RegisterAddonPanel("LorePlayOptions", panelData)
	LAM2:RegisterOptionControls("LorePlayOptions", optionsTable)
end


local function RegisterSettingsEvents()
	LPEventHandler:RegisterForLocalEvent(EVENT_INDICATOR_MOVED, OnIndicatorMoved)
end


function Settings.InitializeSettings()
	Settings.savedVariables = ZO_SavedVars:New("LorePlaySavedVars", LorePlay.majorVersion, nil, defaultSettingsTable)
	Settings.LoadSavedSettings()
	LAM2 = LibStub("LibAddonMenu-2.0")
	Settings.LoadMenuSettings()
	RegisterSettingsEvents()
end


LorePlay = Settings