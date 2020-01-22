LorePlay = LorePlay or {}
-- --- definitions : LPCategoryStrings.lua
local Appearance = LorePlay.Appearance
local Hats = LorePlay.Hats
local Costumes = LorePlay.Costumes
local Skins = LorePlay.Skins
local Polymorphs = LorePlay.Polymorphs
local Hair = LorePlay.Hair
local FacialAcc = LorePlay.FacialAcc
local FacialHair = LorePlay.FacialHair
local BodyMarkings = LorePlay.BodyMarkings
local HeadMarkings = LorePlay.HeadMarkings
local Jewelry = LorePlay.Jewelry
local Personalities = LorePlay.Personalities
local VanityPets = LorePlay.VanityPets
local City = LorePlay.City
local Housing = LorePlay.Housing
local Dungeon = LorePlay.Dungeon
local Adventure = LorePlay.Adventure
local Total = LorePlay.Total
local player = LorePlay.player
local stringToColTypeTable = LorePlay.stringToColTypeTable
-- ---
-- --- definitions : LPUtilities.lua
local EVENT_ACTIVE_EMOTE = LorePlay.EVENT_ACTIVE_EMOTE
local EVENT_ON_SMART_EMOTE = LorePlay.EVENT_ON_SMART_EMOTE
local EVENT_ON_IDLE_EMOTE = LorePlay.EVENT_ON_IDLE_EMOTE
local EVENT_PLEDGE_OF_MARA_RESULT_MARRIAGE = LorePlay.EVENT_PLEDGE_OF_MARA_RESULT_MARRIAGE
local EVENT_INDICATOR_MOVED = LorePlay.EVENT_INDICATOR_MOVED
local LPUtilities = LorePlay.LPUtilities

-- ------------------------------------------------------------

-- === LPSettings.lua ===

--local LAM2
local LAM2 = LibAddonMenu2
if not LAM2 then d("[LorePlay] Error : 'LibAddonMenu' not found.") return end

local L = GetString

local Settings = LorePlay

local defaultSettingsTable = {
	isIdleEmotesOn = true,
	isLoreWearOn = true,
	isSmartEmotesIndicatorOn = true,
	canPlayInstrumentsInCities = true,
	canDanceInCities = true,
	canBeDrunkInCities = true,
	canExerciseInZone = true,
	canWorship = true,
	isCameraSpinDisabled = true,

	isUsingFavorite = {
		[Costumes] = false,
		[Hats] = false,
		[Skins] = false,
		[Hair] = false,
		[Polymorphs] = false,
		[FacialAcc] = false,
		[FacialHair] = false,
		[BodyMarkings] = false,
		[HeadMarkings] = false,
		[Jewelry] = false,
		[Personalities] = false,
		[VanityPets] = false,
	},

	outfitTable = {
		[City] = {
			[Costumes] = 0,
			[Hats] = 0,
			[Hair] = 0,
			[Skins] = 0,
			[Polymorphs] = 0,
			[FacialAcc] = 0,
			[FacialHair] = 0,
			[BodyMarkings] = 0,
			[HeadMarkings] = 0,
			[Jewelry] = 0,
			[Personalities] = 0,
			[VanityPets] = 0,
		},
		[Housing] = {
			[Costumes] = 0,
			[Hats] = 0,
			[Hair] = 0,
			[Skins] = 0,
			[Polymorphs] = 0,
			[FacialAcc] = 0,
			[FacialHair] = 0,
			[BodyMarkings] = 0,
			[HeadMarkings] = 0,
			[Jewelry] = 0,
			[Personalities] = 0,
			[VanityPets] = 0,
		},
		[Dungeon] = {
			[Costumes] = 0,
			[Hats] = 0,
			[Hair] = 0,
			[Skins] = 0,
			[Polymorphs] = 0,
			[FacialAcc] = 0,
			[FacialHair] = 0,
			[BodyMarkings] = 0,
			[HeadMarkings] = 0,
			[Jewelry] = 0,
			[Personalities] = 0,
			[VanityPets] = 0,
		},
		[Adventure] = {
			[Costumes] = 0,
			[Hats] = 0,
			[Hair] = 0,
			[Skins] = 0,
			[Polymorphs] = 0,
			[FacialAcc] = 0,
			[FacialHair] = 0,
			[BodyMarkings] = 0,
			[HeadMarkings] = 0,
			[Jewelry] = 0,
			[Personalities] = 0,
			[VanityPets] = 0,
		}
	},

	canActivateLWClothesWhileMounted = false,
	maraSpouseName = "",
	indicatorLeft = nil,
	indicatorTop = nil,
	timeBetweenIdleEmotes = 30000, 

	savedSubZoneName = "", 
	savedSubZoneId = 0, 
}


local function updateSpouseName(newMaraSpouseName)
	Settings.savedSettingsTable.maraSpouseName = newMaraSpouseName
	Settings.savedVariables.maraSpouseName = Settings.savedSettingsTable.maraSpouseName
end


function Settings.LoadSavedSettings()
	Settings.savedSettingsTable = {}
	Settings.savedSettingsTable.isIdleEmotesOn = Settings.savedVariables.isIdleEmotesOn
	Settings.savedSettingsTable.isLoreWearOn = Settings.savedVariables.isLoreWearOn
	Settings.savedSettingsTable.isSmartEmotesIndicatorOn = Settings.savedVariables.isSmartEmotesIndicatorOn
	Settings.savedSettingsTable.canPlayInstrumentsInCities = Settings.savedVariables.canPlayInstrumentsInCities
	Settings.savedSettingsTable.canDanceInCities = Settings.savedVariables.canDanceInCities
	Settings.savedSettingsTable.canBeDrunkInCities = Settings.savedVariables.canBeDrunkInCities
	Settings.savedSettingsTable.canExerciseInZone = Settings.savedVariables.canExerciseInZone
	Settings.savedSettingsTable.canWorship = Settings.savedVariables.canWorship
	Settings.savedSettingsTable.isCameraSpinDisabled = Settings.savedVariables.isCameraSpinDisabled
	Settings.savedSettingsTable.isUsingFavorite = Settings.savedVariables.isUsingFavorite
	Settings.savedSettingsTable.outfitTable = Settings.savedVariables.outfitTable
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

--[[
local function SetFavoriteCostume(tableToOutfit)
	local collectibleId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
	if collectibleId == 0 then CHAT_SYSTEM:AddMessage("No costume was detected.") end
	tableToOutfit[Costumes] = collectibleId
	Settings.savedVariables.outfitTable = Settings.savedSettingsTable.outfitTable
	Settings.savedSettingsTable.isUsingFavorite[Costumes] = true
	Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
	CHAT_SYSTEM:AddMessage("Favorite costume set as '"..GetCollectibleName(collectibleId).."'")
end


local function SetFavoriteHat(tableToOutfit)
	local didChange = true
	local collectibleId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAT)
	local name = GetCollectibleName(collectibleId)
	if collectibleId == 0 then 
		CHAT_SYSTEM:AddMessage("No hat was detected.") 
		name = "None"
		didChange = false
	end
	tableToOutfit[Hats] = collectibleId
	Settings.savedVariables.outfitTable = Settings.savedSettingsTable.outfitTable
	if didChange then
		Settings.savedSettingsTable.isUsingFavorite[Hats] = true
		Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
	end
	CHAT_SYSTEM:AddMessage("Favorite hat set as '"..name.."'")
end


local function SetFavoriteHair(tableToOutfit)
	local didChange = true
	local collectibleId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAIR)
	local name = GetCollectibleName(collectibleId)
	if collectibleId == 0 then 
		CHAT_SYSTEM:AddMessage("Default hair detected.") 
		name = "Default"
		didChange = false
	end
	tableToOutfit[Hair] = collectibleId
	Settings.savedVariables.outfitTable = Settings.savedSettingsTable.outfitTable
	if didChange then
		Settings.savedSettingsTable.isUsingFavorite[Hair] = true
		Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
	end
	CHAT_SYSTEM:AddMessage("Favorite hair set as '"..name.."'")
end


local function SetFavoriteSkin(tableToOutfit)
	local didChange = true
	local collectibleId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_SKIN)
	local name = GetCollectibleName(collectibleId)
	if collectibleId == 0 then 
		CHAT_SYSTEM:AddMessage("No skin was detected.") 
		name = "None"
		didChange = false
	end
	tableToOutfit[Skins] = collectibleId
	Settings.savedVariables.outfitTable = Settings.savedSettingsTable.outfitTable
	if didChange then
		Settings.savedSettingsTable.isUsingFavorite[Skins] = true
		Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
	end
	CHAT_SYSTEM:AddMessage("Favorite skin set as '"..name.."'")
end
]]--





local function SetFavoriteCollectible(tableToOutfit, LPCatString)
	local didChange = true
	local collectibleId = GetActiveCollectibleByType(stringToColTypeTable[LPCatString])
	local name = GetCollectibleName(collectibleId)
	if collectibleId == 0 then 
		name = "None"
		didChange = false
	end
	tableToOutfit[LPCatString] = collectibleId
	Settings.savedVariables.outfitTable = Settings.savedSettingsTable.outfitTable
	if didChange then
		Settings.savedSettingsTable.isUsingFavorite[LPCatString] = true
		Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
	end
	CHAT_SYSTEM:AddMessage(LPCatString.." set as ".."'"..name.."'.")
end



local function SetFavoriteOutfit(outfitsTable, whichOutfitString)
	CHAT_SYSTEM:AddMessage("[LorePlay] "..whichOutfitString.." Outfit:")

	for i,_ in pairs(stringToColTypeTable) do
		if Settings.savedSettingsTable.isUsingFavorite[i] then
			SetFavoriteCollectible(outfitsTable[whichOutfitString], i)
		end
	end
	CHAT_SYSTEM:AddMessage("Success.")
end


function Settings.ToggleIdleEmotes(settings)
	if Settings.savedSettingsTable.isIdleEmotesOn == settings then return end
	Settings.savedSettingsTable.isIdleEmotesOn = settings
	Settings.savedVariables.isIdleEmotesOn = Settings.savedSettingsTable.isIdleEmotesOn
	if not Settings.savedSettingsTable.isIdleEmotesOn then LorePlay.UnregisterIdleEvents() end
	LorePlay.InitializeIdle()
	if settings then 
		CHAT_SYSTEM:AddMessage("[LorePlay] Toggled IdleEmotes on")
	else
		CHAT_SYSTEM:AddMessage("[LorePlay] Toggled IdleEmotes off")
	end
end


-- Fixes "Cannot play emote at this time" in most circumstances
local scenes = {}
local function noCameraSpin()
	if Settings.savedSettingsTable.isCameraSpinDisabled then
		for name, scene in pairs(SCENE_MANAGER.scenes) do
		  if not name:find("market") and not name:find("store") and not name:find("crownCrate") and not name:find("housing") and scene:HasFragment(FRAME_PLAYER_FRAGMENT) then
			scene:RemoveFragment(FRAME_PLAYER_FRAGMENT)
			scenes[name] = scene
		  end
		end
	else
		for name, scene in pairs(scenes) do
			scene:AddFragment(FRAME_PLAYER_FRAGMENT)
		end
	end
end

local function OnPlayerMaraResult(eventCode, isGettingMarried, playerMarriedTo)
	if eventCode ~= EVENT_PLEDGE_OF_MARA_RESULT_MARRIAGE then return end
	if not isGettingMarried then
		updateSpouseName(playerMarriedTo)
	end
end


function Settings.LoadMenuSettings()
	local panelData = {
		type = "panel",
		name = LorePlay.name,
		displayName = "|c8c7037LorePlay",
		author = "Justinon, modified by Calamath",
		version = LorePlay.version,
		slashCommand = "/loreplay",
		registerForRefresh = true,
	}

	local optionsTable = {}
	optionsTable[#optionsTable + 1] = {
		type = "header",
		name = L(SI_LOREPLAY_PANEL_SE_HEADER),
		width = "full",
	}
	optionsTable[#optionsTable + 1] = {
		type = "description",
		title = nil,
		text = L(SI_LOREPLAY_PANEL_SE_DESCRIPTION),
		width = "full",
	}
	optionsTable[#optionsTable + 1] = {
		type = "editbox",
		name = L(SI_LOREPLAY_PANEL_SE_EDIT_SIGNIFICANT_CHAR_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_SE_EDIT_SIGNIFICANT_CHAR_TIPS),
		getFunc = function() return Settings.savedSettingsTable.maraSpouseName end,
		setFunc = function(input)
			Settings.savedSettingsTable.maraSpouseName = input
			Settings.savedVariables.maraSpouseName = Settings.savedSettingsTable.maraSpouseName
		end,
		isMultiline = false,
		width = "full",
		default = "",
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_SE_INDICATOR_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_SE_INDICATOR_SW_TIPS),
		getFunc = function() return Settings.savedSettingsTable.isSmartEmotesIndicatorOn end,
		setFunc = function(setting) 
			Settings.savedSettingsTable.isSmartEmotesIndicatorOn = setting
			Settings.savedVariables.isSmartEmotesIndicatorOn = Settings.savedSettingsTable.isSmartEmotesIndicatorOn
			if not Settings.savedSettingsTable.isSmartEmotesIndicatorOn then
				SmartEmotesIndicator:SetHidden(true)
			end
		end,
		width = "full",
	}
	optionsTable[#optionsTable + 1] = {
		type = "button",
		name = L(SI_LOREPLAY_PANEL_SE_INDICATOR_POS_RESET_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_SE_INDICATOR_POS_RESET_TIPS),
		func = function() ResetIndicator() end,
		width = "full",
	}
	optionsTable[#optionsTable + 1] = {
		type = "header",
		name =  L(SI_LOREPLAY_PANEL_IE_HEADER),
		width = "full",
	}
	optionsTable[#optionsTable + 1] = {
		type = "description",
		title = nil,
		text =  L(SI_LOREPLAY_PANEL_IE_DESCRIPTION),
		width = "full",
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name =  L(SI_LOREPLAY_PANEL_IE_SW_NAME),
		tooltip =  L(SI_LOREPLAY_PANEL_IE_SW_TIPS),
		getFunc = function() return Settings.savedSettingsTable.isIdleEmotesOn end,
		setFunc = function(setting) 
			Settings.ToggleIdleEmotes(setting)
		end,
		width = "full",
		reference = "IdleEmotesToggleCheckbox",
	}
	optionsTable[#optionsTable + 1] = {
		type = "slider",
		name = L(SI_LOREPLAY_PANEL_IE_EMOTE_DURATION_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_IE_EMOTE_DURATION_TIPS),
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
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_IE_PLAY_INST_IN_CITY_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_IE_PLAY_INST_IN_CITY_SW_TIPS),
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
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_IE_DANCE_IN_CITY_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_IE_DANCE_IN_CITY_SW_TIPS),
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
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_IE_BE_DRUNK_IN_CITY_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_IE_BE_DRUNK_IN_CITY_SW_TIPS),
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
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_IE_EXERCISE_IN_ZONE_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_IE_EXERCISE_IN_ZONE_SW_TIPS),
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
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_IE_WORSHIP_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_IE_WORSHIP_SW_TIPS),
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
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_IE_CAMERA_SPIN_DISABLER_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_IE_CAMERA_SPIN_DISABLER_TIPS),
		getFunc = function() 
			if Settings.savedSettingsTable.isCameraSpinDisabled then
				return true
			else
				return false
			end
		end,
		setFunc = function(setting)
			if not Settings.savedSettingsTable.isIdleEmotesOn then return end
			Settings.savedSettingsTable.isCameraSpinDisabled = setting
			Settings.savedVariables.isCameraSpinDisabled = Settings.savedSettingsTable.isCameraSpinDisabled
			noCameraSpin()
		end,
		width = "full",
	}
	optionsTable[#optionsTable + 1] = {
		type = "header",
		name = L(SI_LOREPLAY_PANEL_LE_HEADER),
		width = "full",
	}
	optionsTable[#optionsTable + 1] = {
		type = "description",
		title = nil,
		text = L(SI_LOREPLAY_PANEL_LE_DESCRIPTION),
		width = "full",
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_LE_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_SW_TIPS),
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
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_LE_EQUIP_WHILE_MOUNT_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_EQUIP_WHILE_MOUNT_SW_TIPS),
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
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_LE_USE_COSTUME_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_USE_COSTUME_SW_TIPS),
		getFunc = function() 
			if Settings.savedSettingsTable.isLoreWearOn then
				return Settings.savedSettingsTable.isUsingFavorite[Costumes] 
			else
				return false
			end
		end,
		setFunc = function(setting)
			if not Settings.savedSettingsTable.isLoreWearOn then return end
			Settings.savedSettingsTable.isUsingFavorite[Costumes] = setting
			Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite 
		end,
		width = "full",
		default = false,
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_LE_USE_HAT_SW_NAME),
		tooltip =L(SI_LOREPLAY_PANEL_LE_USE_HAT_SW_TIPS),
		getFunc = function() 
			if Settings.savedSettingsTable.isLoreWearOn then
				return Settings.savedSettingsTable.isUsingFavorite[Hats]
			else
				return false
			end
		end,
		setFunc = function(setting)
			if not Settings.savedSettingsTable.isLoreWearOn then return end
			Settings.savedSettingsTable.isUsingFavorite[Hats] = setting
			Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
		end,
		width = "full",
		default = false,
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_LE_USE_HAIR_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_USE_HAIR_SW_TIPS),
		getFunc = function() 
			if Settings.savedSettingsTable.isLoreWearOn then
				return Settings.savedSettingsTable.isUsingFavorite[Hair]
			else
				return false
			end
		end,
		setFunc = function(setting)
			if not Settings.savedSettingsTable.isLoreWearOn then return end
			Settings.savedSettingsTable.isUsingFavorite[Hair] = setting
			Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
		end,
		width = "full",
		default = false,
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_LE_USE_SKIN_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_USE_SKIN_SW_TIPS),
		getFunc = function() 
			if Settings.savedSettingsTable.isLoreWearOn then
				return Settings.savedSettingsTable.isUsingFavorite[Skins] 
			else
				return false
			end
		end,
		setFunc = function(setting)
			if not Settings.savedSettingsTable.isLoreWearOn then return end
			Settings.savedSettingsTable.isUsingFavorite[Skins] = setting
			Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
		end,
		width = "full",
		default = false,
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_LE_USE_POLYMORPH_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_USE_POLYMORPH_SW_TIPS),
		getFunc = function() 
			if Settings.savedSettingsTable.isLoreWearOn then
				return Settings.savedSettingsTable.isUsingFavorite[Polymorphs] 
			else
				return false
			end
		end,
		setFunc = function(setting)
			if not Settings.savedSettingsTable.isLoreWearOn then return end
			Settings.savedSettingsTable.isUsingFavorite[Polymorphs] = setting
			Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
		end,
		width = "full",
		default = false,
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_LE_USE_FACIAL_ACC_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_USE_FACIAL_ACC_SW_TIPS),
		getFunc = function() 
			if Settings.savedSettingsTable.isLoreWearOn then
				return Settings.savedSettingsTable.isUsingFavorite[FacialAcc] 
			else
				return false
			end
		end,
		setFunc = function(setting)
			if not Settings.savedSettingsTable.isLoreWearOn then return end
			Settings.savedSettingsTable.isUsingFavorite[FacialAcc] = setting
			Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
		end,
		width = "full",
		default = false,
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_LE_USE_FACIAL_HAIR_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_USE_FACIAL_HAIR_SW_TIPS),
		getFunc = function() 
			if Settings.savedSettingsTable.isLoreWearOn then
				return Settings.savedSettingsTable.isUsingFavorite[FacialHair] 
			else
				return false
			end
		end,
		setFunc = function(setting)
			if not Settings.savedSettingsTable.isLoreWearOn then return end
			Settings.savedSettingsTable.isUsingFavorite[FacialHair] = setting
			Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
		end,
		width = "full",
		default = false,
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_LE_USE_BODY_MARKING_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_USE_BODY_MARKING_SW_TIPS),
		getFunc = function() 
			if Settings.savedSettingsTable.isLoreWearOn then
				return Settings.savedSettingsTable.isUsingFavorite[BodyMarkings] 
			else
				return false
			end
		end,
		setFunc = function(setting)
			if not Settings.savedSettingsTable.isLoreWearOn then return end
			Settings.savedSettingsTable.isUsingFavorite[BodyMarkings] = setting
			Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
		end,
		width = "full",
		default = false,
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_LE_USE_HEAD_MARKING_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_USE_HEAD_MARKING_SW_TIPS),
		getFunc = function() 
			if Settings.savedSettingsTable.isLoreWearOn then
				return Settings.savedSettingsTable.isUsingFavorite[HeadMarkings] 
			else
				return false
			end
		end,
		setFunc = function(setting)
			if not Settings.savedSettingsTable.isLoreWearOn then return end
			Settings.savedSettingsTable.isUsingFavorite[HeadMarkings] = setting
			Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
		end,
		width = "full",
		default = false,
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_LE_USE_JEWELRY_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_USE_JEWELRY_SW_TIPS),
		getFunc = function() 
			if Settings.savedSettingsTable.isLoreWearOn then
				return Settings.savedSettingsTable.isUsingFavorite[Jewelry] 
			else
				return false
			end
		end,
		setFunc = function(setting)
			if not Settings.savedSettingsTable.isLoreWearOn then return end
			Settings.savedSettingsTable.isUsingFavorite[Jewelry] = setting
			Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
		end,
		width = "full",
		default = false,
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_LE_USE_PERSONALITY_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_USE_PERSONALITY_SW_TIPS),
		getFunc = function() 
			if Settings.savedSettingsTable.isLoreWearOn then
				return Settings.savedSettingsTable.isUsingFavorite[Personalities] 
			else
				return false
			end
		end,
		setFunc = function(setting)
			if not Settings.savedSettingsTable.isLoreWearOn then return end
			Settings.savedSettingsTable.isUsingFavorite[Personalities] = setting
			Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
		end,
		width = "full",
		default = false,
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_LE_USE_PET_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_USE_PET_SW_TIPS),
		getFunc = function() 
			if Settings.savedSettingsTable.isLoreWearOn then
				return Settings.savedSettingsTable.isUsingFavorite[VanityPets] 
			else
				return false
			end
		end,
		setFunc = function(setting)
			if not Settings.savedSettingsTable.isLoreWearOn then return end
			Settings.savedSettingsTable.isUsingFavorite[VanityPets] = setting
			Settings.savedVariables.isUsingFavorite = Settings.savedSettingsTable.isUsingFavorite
		end,
		width = "full",
		default = false,
	}
	optionsTable[#optionsTable + 1] = {
		type = "button",
		name = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_CITY_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_CITY_TIPS),
		func = function()
			SetFavoriteOutfit(Settings.savedSettingsTable.outfitTable, City)
		end,
		width = "half",
	}
	optionsTable[#optionsTable + 1] = {
		type = "button",
		name = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_HOUSING_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_HOUSING_TIPS),
		func = function()
			SetFavoriteOutfit(Settings.savedSettingsTable.outfitTable, Housing)
		end,
		width = "half",
	}
	optionsTable[#optionsTable + 1] = {
		type = "button",
		name = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_DUNGEON_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_DUNGEON_TIPS),
		func = function()
			SetFavoriteOutfit(Settings.savedSettingsTable.outfitTable, Dungeon)
		end,
		width = "half",
	}
	optionsTable[#optionsTable + 1] = {
		type = "button",
		name = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_ADVENTURE_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_ADVENTURE_TIPS),
		func = function()
			SetFavoriteOutfit(Settings.savedSettingsTable.outfitTable, Adventure)
		end,
		width = "half",
	}

	LAM2:RegisterAddonPanel("LorePlayOptions", panelData)
	LAM2:RegisterOptionControls("LorePlayOptions", optionsTable)
end


local function RegisterSettingsEvents()
	LPEventHandler:RegisterForLocalEvent(EVENT_INDICATOR_MOVED, OnIndicatorMoved)
	LPEventHandler:RegisterForLocalEvent(EVENT_PLEDGE_OF_MARA_RESULT_MARRIAGE, OnPlayerMaraResult)
end


function Settings.InitializeSettings()
	Settings.savedVariables = ZO_SavedVars:New("LorePlaySavedVars", LorePlay.majorVersion, nil, defaultSettingsTable)
	Settings.LoadSavedSettings()
--	LAM2 = LibStub("LibAddonMenu-2.0")
	Settings.LoadMenuSettings()
	noCameraSpin()
	RegisterSettingsEvents()
end


LorePlay = Settings
