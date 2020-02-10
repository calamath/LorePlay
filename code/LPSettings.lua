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

LorePlay.collectibleType = {
	COLLECTIBLE_CATEGORY_TYPE_COSTUME, 
	COLLECTIBLE_CATEGORY_TYPE_HAT, 
	COLLECTIBLE_CATEGORY_TYPE_HAIR, 
	COLLECTIBLE_CATEGORY_TYPE_SKIN, 
	COLLECTIBLE_CATEGORY_TYPE_POLYMORPH, 
	COLLECTIBLE_CATEGORY_TYPE_FACIAL_ACCESSORY, 
	COLLECTIBLE_CATEGORY_TYPE_FACIAL_HAIR_HORNS, 
	COLLECTIBLE_CATEGORY_TYPE_BODY_MARKING, 
	COLLECTIBLE_CATEGORY_TYPE_HEAD_MARKING, 
	COLLECTIBLE_CATEGORY_TYPE_PIERCING_JEWELRY, 
	COLLECTIBLE_CATEGORY_TYPE_PERSONALITY, 
	COLLECTIBLE_CATEGORY_TYPE_VANITY_PET, 
}

local Settings = LorePlay

-- default savedata table for [LorePlay Forever]
local default_db = {
	migrated = false, 
	-- ------------------------------------------------------------
	isSmartEmotesIndicatorOn = true, 
	indicatorLeft = nil, 
	indicatorTop = nil, 
	-- ------------------------------------------------------------
	isIdleEmotesOn = true, 
	canPlayInstrumentsInCities = true, 
	canDanceInCities = true, 
	canBeDrunkInCities = true, 
	canExerciseInZone = true, 
	canWorship = true, 
	isCameraSpinDisabled = true, 
	timeBetweenIdleEmotes = 30000, 
	-- ------------------------------------------------------------
	isLoreWearOn = true, 
	canActivateLWClothesWhileMounted = false,
	maraSpouseName = "", 
	isUsingCollectible = {
		[COLLECTIBLE_CATEGORY_TYPE_COSTUME] = false, 
		[COLLECTIBLE_CATEGORY_TYPE_HAT] = false, 
		[COLLECTIBLE_CATEGORY_TYPE_HAIR] = false, 
		[COLLECTIBLE_CATEGORY_TYPE_SKIN] = false, 
		[COLLECTIBLE_CATEGORY_TYPE_POLYMORPH] = false, 
		[COLLECTIBLE_CATEGORY_TYPE_FACIAL_ACCESSORY] = false, 
		[COLLECTIBLE_CATEGORY_TYPE_FACIAL_HAIR_HORNS] = false, 
		[COLLECTIBLE_CATEGORY_TYPE_BODY_MARKING] = false, 
		[COLLECTIBLE_CATEGORY_TYPE_HEAD_MARKING] = false, 
		[COLLECTIBLE_CATEGORY_TYPE_PIERCING_JEWELRY] = false, 
		[COLLECTIBLE_CATEGORY_TYPE_PERSONALITY] = false, 
		[COLLECTIBLE_CATEGORY_TYPE_VANITY_PET] = false, 
	}, 
	stylePreset = {
		[1] = {
			displayName = "City", 
			collectible = {
				[COLLECTIBLE_CATEGORY_TYPE_COSTUME] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_HAT] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_HAIR] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_SKIN] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_POLYMORPH] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_FACIAL_ACCESSORY] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_FACIAL_HAIR_HORNS] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_BODY_MARKING] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_HEAD_MARKING] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_PIERCING_JEWELRY] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_PERSONALITY] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_VANITY_PET] = 0, 
			}, 
		}, 
		[2] = {
			displayName = "Housing", 
			collectible = {
				[COLLECTIBLE_CATEGORY_TYPE_COSTUME] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_HAT] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_HAIR] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_SKIN] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_POLYMORPH] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_FACIAL_ACCESSORY] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_FACIAL_HAIR_HORNS] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_BODY_MARKING] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_HEAD_MARKING] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_PIERCING_JEWELRY] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_PERSONALITY] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_VANITY_PET] = 0, 
			}, 
		}, 
		[3] = {
			displayName = "Dungeon", 
			collectible = {
				[COLLECTIBLE_CATEGORY_TYPE_COSTUME] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_HAT] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_HAIR] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_SKIN] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_POLYMORPH] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_FACIAL_ACCESSORY] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_FACIAL_HAIR_HORNS] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_BODY_MARKING] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_HEAD_MARKING] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_PIERCING_JEWELRY] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_PERSONALITY] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_VANITY_PET] = 0, 
			}, 
		}, 
		[4] = {
			displayName = "Adventure", 
			collectible = {
				[COLLECTIBLE_CATEGORY_TYPE_COSTUME] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_HAT] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_HAIR] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_SKIN] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_POLYMORPH] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_FACIAL_ACCESSORY] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_FACIAL_HAIR_HORNS] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_BODY_MARKING] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_HEAD_MARKING] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_PIERCING_JEWELRY] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_PERSONALITY] = 0, 
				[COLLECTIBLE_CATEGORY_TYPE_VANITY_PET] = 0, 
			}, 
		}, 
	},
	-- variables for location recognize engine -----
	savedSubZoneName = "", 
	savedSubZoneId = 0, 
	specificPOINameNearby = nil, 
}


-- default savedata table for [LorePlay (standard version)]
--[[
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

-- variables for location recognize engine -----
	savedSubZoneName = "", 
	savedSubZoneId = 0, 
	specificPOINameNearby = nil, 
-- ---------------------------------------------

}
]]


local function ConvertToForeverSavedata()
	local sv = Settings.savedVariables

	if sv.isSmartEmotesIndicatorOn			then LorePlay.db.isSmartEmotesIndicatorOn			= sv.isSmartEmotesIndicatorOn				end
	if sv.indicatorLeft						then LorePlay.db.indicatorLeft						= sv.indicatorLeft							end
	if sv.indicatorTop						then LorePlay.db.indicatorTop						= sv.indicatorTop							end
	-- ------------------------------------------------------------
	if sv.isIdleEmotesOn					then LorePlay.db.isIdleEmotesOn						= sv.isIdleEmotesOn							end
	if sv.canPlayInstrumentsInCities		then LorePlay.db.canPlayInstrumentsInCities			= sv.canPlayInstrumentsInCities				end
	if sv.canDanceInCities					then LorePlay.db.canDanceInCities					= sv.canDanceInCities						end
	if sv.canBeDrunkInCities				then LorePlay.db.canBeDrunkInCities					= sv.canBeDrunkInCities						end
	if sv.canExerciseInZone					then LorePlay.db.canExerciseInZone					= sv.canExerciseInZone						end
	if sv.canWorship						then LorePlay.db.canWorship							= sv.canWorship								end
	if sv.isCameraSpinDisabled				then LorePlay.db.isCameraSpinDisabled				= sv.isCameraSpinDisabled					end
	if sv.timeBetweenIdleEmotes				then LorePlay.db.timeBetweenIdleEmotes				= sv.timeBetweenIdleEmotes					end
	-- ------------------------------------------------------------
	if sv.isLoreWearOn						then LorePlay.db.isLoreWearOn						= sv.isLoreWearOn							end
	if sv.canActivateLWClothesWhileMounted	then LorePlay.db.canActivateLWClothesWhileMounted	= sv.canActivateLWClothesWhileMounted		end
	if sv.maraSpouseName					then LorePlay.db.maraSpouseName						= sv.maraSpouseName							end

	for k, v in pairs(sv.isUsingFavorite) do
		LorePlay.db.isUsingCollectible[stringToColTypeTable[k]] = v
	end

	for i, j in pairs({ "City", "Housing", "Dungeon", "Adventure", }) do
		for k, v in pairs(sv.outfitTable[j]) do
			LorePlay.db.stylePreset[i].collectible[stringToColTypeTable[k]] = v
		end
	end
	-- ------------------------------------------------------------
	if sv.savedSubZoneName					then LorePlay.db.savedSubZoneName					= sv.savedSubZoneName						end
	if sv.savedSubZoneId					then LorePlay.db.savedSubZoneId						= sv.savedSubZoneId							end
	if sv.specificPOINameNearby				then LorePlay.db.specificPOINameNearby				= sv.specificPOINameNearby					end

	LorePlay.LDL:Debug("savedata migration finished.")
	-- ==========================================================================================================================================
	if sv.savedSubZoneName then Settings.savedVariables.savedSubZoneName = nil end
	if sv.savedSubZoneId then Settings.savedVariables.savedSubZoneId = nil end
	if sv.specificPOINameNearby then Settings.savedVariables.specificPOINameNearby = nil end
end


local function updateSpouseName(newMaraSpouseName)
	LorePlay.db.maraSpouseName = newMaraSpouseName
end


--[[
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
]]


local function ResetIndicator()
	SmartEmotesIndicator:ClearAnchors()
	SmartEmotesIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 0, 0)
	LorePlay.db.indicatorLeft = nil
	LorePlay.db.indicatorTop = nil
end


local function OnIndicatorMoved(eventCode, top, left)
	LorePlay.db.indicatorTop = top
	LorePlay.db.indicatorLeft = left
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



local function SetFavoriteStylePreset(presetIndex)
	local collectibleId = 0
	for k, v in pairs(Settings.collectibleType) do
		collectibleId = GetActiveCollectibleByType(v)
		if collectibleId == 0 then		-- no active collectible
		end
		LorePlay.db.stylePreset[presetIndex].collectible[v] = collectibleId
		LorePlay.LDL:Debug("Preset[%d] collectible[%d] = %s", presetIndex, v, GetCollectibleName(collectibleId))
	end
end


--[[
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
]]


function Settings.ToggleIdleEmotes(value)
	if LorePlay.db.isIdleEmotesOn == value then return end
	LorePlay.db.isIdleEmotesOn = value
	if not LorePlay.db.isIdleEmotesOn then LorePlay.UnregisterIdleEvents() end
	LorePlay.InitializeIdle()
	if value then 
		CHAT_SYSTEM:AddMessage("[LorePlay] Toggled IdleEmotes on")
	else
		CHAT_SYSTEM:AddMessage("[LorePlay] Toggled IdleEmotes off")
	end
end
LorePlay.ToggleIdleEmotes = Settings.ToggleIdleEmotes


-- Fixes "Cannot play emote at this time" in most circumstances
local scenes = {}
local function noCameraSpin()
	if LorePlay.db.isCameraSpinDisabled then
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
		displayName = "|c8c7037LorePlay Forever",
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
		getFunc = function() return LorePlay.db.maraSpouseName end, 
		setFunc = function(input) LorePlay.db.maraSpouseName = input end, 
		isMultiline = false, 
		width = "full", 
		default = "", 
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_SE_INDICATOR_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_SE_INDICATOR_SW_TIPS),
		getFunc = function() return LorePlay.db.isSmartEmotesIndicatorOn end, 
		setFunc = function(value) 
			LorePlay.db.isSmartEmotesIndicatorOn = value
			if value == false then
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
		getFunc = function() return LorePlay.db.isIdleEmotesOn end,
		setFunc = function(value) 
			LorePlay.ToggleIdleEmotes(value)
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
			return LorePlay.db.timeBetweenIdleEmotes/1000 -- Converting ms to s
		end, 
		setFunc = function(value)
			LorePlay.db.timeBetweenIdleEmotes = (value*1000) -- Converting seconds to ms
		end, 
		width = "full",
		disabled = function() return not LorePlay.db.isIdleEmotesOn end, 
		default = 30,
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_IE_PLAY_INST_IN_CITY_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_IE_PLAY_INST_IN_CITY_SW_TIPS),
		getFunc = function() return LorePlay.db.canPlayInstrumentsInCities end, 
		setFunc = function(value)
			LorePlay.db.canPlayInstrumentsInCities = value
			LorePlay.CreateDefaultIdleEmotesTable()
		end, 
		width = "full",
		disabled = function() return not LorePlay.db.isIdleEmotesOn end, 
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox", 
		name = L(SI_LOREPLAY_PANEL_IE_DANCE_IN_CITY_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_IE_DANCE_IN_CITY_SW_TIPS),
		getFunc = function() return LorePlay.db.canDanceInCities end, 
		setFunc = function(value)
			LorePlay.db.canDanceInCities = value
			LorePlay.CreateDefaultIdleEmotesTable()
		end, 
		width = "full",
		disabled = function() return not LorePlay.db.isIdleEmotesOn end, 
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_IE_BE_DRUNK_IN_CITY_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_IE_BE_DRUNK_IN_CITY_SW_TIPS),
		getFunc = function() return LorePlay.db.canBeDrunkInCities end, 
		setFunc = function(value)
			LorePlay.db.canBeDrunkInCities = value
			LorePlay.CreateDefaultIdleEmotesTable()
		end, 
		width = "full",
		disabled = function() return not LorePlay.db.isIdleEmotesOn end, 
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_IE_EXERCISE_IN_ZONE_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_IE_EXERCISE_IN_ZONE_SW_TIPS),
		getFunc = function() return LorePlay.db.canExerciseInZone end, 
		setFunc = function(value)
			LorePlay.db.canExerciseInZone = value
			LorePlay.CreateDefaultIdleEmotesTable()
		end, 
		width = "full",
		disabled = function() return not LorePlay.db.isIdleEmotesOn end, 
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_IE_WORSHIP_SW_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_IE_WORSHIP_SW_TIPS),
		getFunc = function() return LorePlay.db.canWorship end, 
		setFunc = function(value)
			LorePlay.db.canWorship = value
			LorePlay.CreateDefaultIdleEmotesTable()
		end, 
		width = "full",
		disabled = function() return not LorePlay.db.isIdleEmotesOn end, 
	}
	optionsTable[#optionsTable + 1] = {
		type = "checkbox",
		name = L(SI_LOREPLAY_PANEL_IE_CAMERA_SPIN_DISABLER_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_IE_CAMERA_SPIN_DISABLER_TIPS),
		getFunc = function() return LorePlay.db.isCameraSpinDisabled end, 
		setFunc = function(value)
			LorePlay.db.isCameraSpinDisabled = value
			noCameraSpin()
		end, 
		width = "full",
--		disabled = function() return not LorePlay.db.isIdleEmotesOn end, 
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
		getFunc = function() return LorePlay.db.isLoreWearOn end,
		setFunc = function(value) 
			LorePlay.db.isLoreWearOn = value
			if not LorePlay.db.isLoreWearOn then 
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
			if LorePlay.db.isLoreWearOn then
				return LorePlay.db.canActivateLWClothesWhileMounted
			else
				return false
			end
		end,
		setFunc = function(value) 
			if not LorePlay.db.isLoreWearOn then return end
			LorePlay.db.canActivateLWClothesWhileMounted = value
		end,
		width = "full",
	}

	for k, v in pairs(LorePlay.collectibleType) do
		optionsTable[#optionsTable + 1] = {
			type = "checkbox", 
			name = L("SI_LOREPLAY_PANEL_LW_COLLECTIBLE_SW_NAME_", v), 
			tooltip = L("SI_LOREPLAY_PANEL_LW_COLLECTIBLE_SW_TIPS_", v), 
			getFunc = function() 
				if LorePlay.db.isLoreWearOn then
					return LorePlay.db.isUsingCollectible[v]
				else
					return false
				end
			end,
			setFunc = function(value) 
				LorePlay.db.isUsingCollectible[v] = value
			end,
			width = "full",
			disabled = function() return not LorePlay.db.isLoreWearOn end, 
			default = false,
		}
	end

--[[
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
]]
	optionsTable[#optionsTable + 1] = {
		type = "button",
		name = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_CITY_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_CITY_TIPS),
		func = function()
			SetFavoriteStylePreset(1)
		end,
		width = "half",
	}
	optionsTable[#optionsTable + 1] = {
		type = "button",
		name = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_HOUSING_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_HOUSING_TIPS),
		func = function()
			SetFavoriteStylePreset(2)
		end,
		width = "half",
	}
	optionsTable[#optionsTable + 1] = {
		type = "button",
		name = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_DUNGEON_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_DUNGEON_TIPS),
		func = function()
			SetFavoriteStylePreset(3)
		end,
		width = "half",
	}
	optionsTable[#optionsTable + 1] = {
		type = "button",
		name = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_ADVENTURE_NAME),
		tooltip = L(SI_LOREPLAY_PANEL_LE_SET_OUTFIT_ADVENTURE_TIPS),
		func = function()
			SetFavoriteStylePreset(4)
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
	LorePlay.db = ZO_SavedVars:NewCharacterIdSettings(LorePlay.savedVars, LorePlay.savedVarsVersion, nil, default_db, "ForeverDB")
	if LorePlay.db.migrated == false then
		Settings.savedVariables = ZO_SavedVars:New("LorePlaySavedVars", 1, nil, {})	-- save data of LorePlay standard version
		ConvertToForeverSavedata()
		LorePlay.db.migrated = true
	end

--	LAM2 = LibStub("LibAddonMenu-2.0")
	Settings.LoadMenuSettings()
	noCameraSpin()
	RegisterSettingsEvents()
end
LorePlay.InitializeSettings = Settings.InitializeSettings

