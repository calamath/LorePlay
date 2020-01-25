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

-- === LoreWear.lua ===

local LoreWear = LorePlay

local isMounted
local isFastTraveling
local isInCombat
local outfitToToggle
local collectiblesMenu
local lastTimeStamp
local wasLastLocationCity
local toggleTable = {}
local keypressWhileMountedString = "Your current settings indicate you cannot equip/unequip clothing while mounted. Do '/loreplay' for more information."


local function BuildToggleTable()
	for i,_ in pairs(stringToColTypeTable) do
		toggleTable[i] = 0
	end
end


local function EquipLoreWearClothes(tableToOutfit)
	for i,v in pairs(tableToOutfit) do
		local collectibleType, curCol, isUsing
		collectibleType = stringToColTypeTable[i]
		curCol = GetActiveCollectibleByType(collectibleType)
		isUsing = LorePlay.savedSettingsTable.isUsingFavorite[i]
		if isUsing then
			if v ~= 0 and curCol ~= v then
				UseCollectible(v)
			--Unequip current collectible if supposed to be off
			elseif v == 0 and curCol ~= 0 then
				UseCollectible(curCol)
			end
		end
	end
	--Reset the toggle table for correct keypress toggling
	BuildToggleTable()
end


local function EquipWeddingClothes()
	local weddingSuit = 95
	local weddingGown = 79
	local eveningDress = 76
	local currCostume = GetActiveCollectibleByType(stringToColTypeTable[Costumes])
	local gender = GetUnitGender(player)
	if gender == GENDER_MALE then
		-- Put on wedding suit
		if currCostume ~= weddingSuit and IsCollectibleUnlocked(weddingSuit) then
			UseCollectible(weddingSuit)
		end
	elseif gender == GENDER_FEMALE then
		-- Put on wedding gown or evening dress
		if currCostume ~= weddingGown and IsCollectibleUnlocked(weddingGown) then
			UseCollectible(weddingGown)
			return
		elseif currCostume ~= eveningDress and IsCollectibleUnlocked(eveningDress) then
			UseCollectible(eveningDress)
		end
	end
end


local function IsCooldownOver()
	local now = GetTimeStamp()
	if lastTimeStamp then
		if GetDiffBetweenTimeStamps(now, lastTimeStamp) <= 3 then return false end
	end
	lastTimeStamp = now
	return true
end


local function CheckToToggleLoreWearClothes()
	if not LorePlay.savedSettingsTable.canActivateLWClothesWhileMounted then 
		if isMounted then return false end
	end
	return true
end


local function ForceShowOrHideClothes()
	local colType, curCol
	for i,v in pairs(toggleTable) do
		if LorePlay.savedSettingsTable.isUsingFavorite[i] then
			colType = stringToColTypeTable[i]
			curCol = GetActiveCollectibleByType(colType)
			if v ~= 0 then
				UseCollectible(v)
			else
				if curCol ~= 0 then
					UseCollectible(curCol)
				end
			end
			-- Store previous collectible into table to be used again
			toggleTable[i] = curCol
		end
	end
end


function LoreWear.KeypressToggleLoreWearClothes()
	if not LorePlay.savedSettingsTable.isLoreWearOn then return end
	if not CheckToToggleLoreWearClothes() then
		CHAT_SYSTEM:AddMessage(keypressWhileMountedString)
		return 
	end
	if not IsCooldownOver() then return end
	ForceShowOrHideClothes()
end


function LoreWear.KeypressEquipOutfit(outfitSetString)
	local colType, curCol
	for i,v in pairs(LorePlay.savedSettingsTable.outfitTable[outfitSetString]) do
		if LorePlay.savedSettingsTable.isUsingFavorite[i] then
			colType = stringToColTypeTable[i]
			curCol = GetActiveCollectibleByType(colType)
			if v ~= 0 and curCol ~= v then
				UseCollectible(v)
			elseif v == 0 and curCol ~= 0 then
				UseCollectible(curCol)
			end
		end
	end
end


local function ShouldUpdateLocation(isInCity)
	if not CheckToToggleLoreWearClothes() then return false end
--[[
	if wasLastLocationCity == nil then
		return true
	end
	if isInCity then
		if wasLastLocationCity then 
			return false
		else 
			return true
		end
	else
		if not wasLastLocationCity then
			return false
		else 
			return true
		end
	end
]]
	return true
end


local function ChangeLoreWearClothes(isCurrentlyInCity)
--[[
	if isCurrentlyInCity then
		outfitToToggle = LorePlay.savedSettingsTable.outfitTable[City]
	elseif LorePlay.IsPlayerInHouse() then
		outfitToToggle = LorePlay.savedSettingsTable.outfitTable[Housing]
	elseif LorePlay.IsPlayerInZone() then
		outfitToToggle = LorePlay.savedSettingsTable.outfitTable[Adventure]
	elseif LorePlay.IsPlayerInDungeon() or LorePlay.IsPlayerInDolmen() then
		outfitToToggle = LorePlay.savedSettingsTable.outfitTable[Dungeon]
	end
]]
	if LorePlay.IsPlayerInHouse() then
		outfitToToggle = LorePlay.savedSettingsTable.outfitTable[Housing]
	elseif LorePlay.IsPlayerInDungeon() or LorePlay.IsPlayerInDolmen() or LorePlay.IsPlayerInAbyssalGeyser() then
		outfitToToggle = LorePlay.savedSettingsTable.outfitTable[Dungeon]
	elseif isCurrentlyInCity then
		outfitToToggle = LorePlay.savedSettingsTable.outfitTable[City]
	elseif LorePlay.IsPlayerInParentZone() then
		outfitToToggle = LorePlay.savedSettingsTable.outfitTable[Adventure]
	else
		outfitToToggle = LorePlay.savedSettingsTable.outfitTable[Dungeon]	-- unregistered region case
	end
	EquipLoreWearClothes(outfitToToggle)
end


local function UpdateLocation(eventCode, subZoneName, subZoneId)
	local location = GetPlayerLocationName()
	if eventCode == EVENT_ZONE_CHANGED then
		LorePlay.savedVariables.savedSubZoneName = subZoneName
		LorePlay.savedVariables.savedSubZoneId = subZoneId
	end
	if eventCode == EVENT_PLAYER_ACTIVATED then
		LorePlay.savedVariables.savedSubZoneName = location
		if location ~= LorePlay.savedVariables.savedSubZoneName then
			wasLastLocationCity = nil
		end
	end
	LorePlay.LDL:Debug("Location = %s, MapName = %s, ZoneName = %s", GetPlayerLocationName(), GetMapName(), GetPlayerActiveZoneName())
	LorePlay.LDL:Debug("mapId = %d, zoneId = %d, parentZoneId = %d", GetCurrentMapId(), GetUnitWorldPosition("player"), GetParentZoneId(GetUnitWorldPosition("player")))

	local isInCity = LorePlay.IsPlayerInCity()
	if isFastTraveling or isInCombat then return end
	if not ShouldUpdateLocation(isInCity) then return end
	if not IsCooldownOver() then
		zo_callLater(function() UpdateLocation(nil) end, 3000)	-- nil nil :-)
		return
	end

	if not LorePlay.savedSettingsTable.isLoreWearOn then return end

	ChangeLoreWearClothes(isInCity)
	wasLastLocationCity = isInCity
end


--[[
local function UpdateLocationDelayed(eventCode)
	zo_callLater(function() UpdateLocation(eventCode) end, 5000)
end
]]
local function OnZoneChanged(eventCode, _, subZoneName, _, _, subZoneId)
	LorePlay.LDL:Debug("EVENT_ZONE_CHANGED : subzoneName = %s , subZoneId = %d", subZoneName, subZoneId)
	SetMapToPlayerLocation()	-- my special thanks to both votan and Garkin!
--	zo_callLater(function() UpdateLocation(eventCode, subZoneName, subZoneId) end, 5000)
	UpdateLocation(eventCode, subZoneName, subZoneId)
end


local function OnPlayerIsActivated(eventCode)
	LorePlay.LDL:Debug("EVENT_PLAYER_ACTIVATED")
	isMounted = IsMounted()
	SetMapToPlayerLocation()	-- my special thanks to both votan and Garkin!
	UpdateLocation(eventCode)
end


local function OnMountedStateChanged(eventCode, mounted)
	if mounted then 
		isMounted = true
	else 
		isMounted = false
		if not LorePlay.savedSettingsTable.canActivateLWClothesWhileMounted then 
			zo_callLater(function() UpdateLocation(eventCode) end, 1400)
		end	
	end
end


local function OnFastTravelInteraction(eventCode)
	if eventCode == EVENT_START_FAST_TRAVEL_INTERACTION then
		isFastTraveling = true
	else
		isFastTraveling = false
	end
end


local function OnPlayerCombatState(eventCode, inCombat)
	if inCombat then
		isInCombat = true
	else
		isInCombat = false
		zo_callLater(function() UpdateLocation(eventCode) end, 1000)
	end
end

local function OnPlayerMaraPledge(eventCode, isGettingMarried)
	if eventCode ~= EVENT_PLEDGE_OF_MARA_RESULT_MARRIAGE then return end
	if isGettingMarried then
		EquipWeddingClothes()
	end
end


--[[
local function initializeIndicator()
	if not LorePlay.savedSettingsTable.isLoreWearIndicatorOn then 
		LoreWearIndicator:SetHidden(true)
	end
	if LorePlay.savedSettingsTable.indicatorTop then
		LoreWearIndicator:ClearAnchors()
		LoreWearIndicator:SetAnchor(TOPRIGHT, GuiRoot, TOPRIGHT, LorePlay.savedSettingsTable.indicatorLeft, LorePlay.savedSettingsTable.indicatorTop)
	end
	local fadeTime = 1500
	indicatorFadeIn, timelineFadeIn = CreateSimpleAnimation(ANIMATION_ALPHA, LoreWearIndicator)
	indicatorFadeOut, timelineFadeOut = CreateSimpleAnimation(ANIMATION_ALPHA, LoreWearIndicator) --LoreWearIndicator defined in xml file of same name
	indicatorFadeIn:SetAlphaValues(0, EmoteImage:GetAlpha())
	indicatorFadeIn:SetDuration(fadeTime)
	indicatorFadeOut:SetAlphaValues(EmoteImage:GetAlpha(), 0)
	indicatorFadeOut:SetDuration(fadeTime)
	timelineFadeIn:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT)
	timelineFadeOut:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT)
	indicator = false
end
]]


function LoreWear.UnregisterLoreWearEvents()
	if not LorePlay.savedSettingsTable.canActivateLWClothesWhileMounted then
		LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_MOUNTED_STATE_CHANGED, OnMountedStateChanged)
	end
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_END_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_START_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_PLAYER_COMBAT_STATE, OnPlayerCombatState)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_PLEDGE_OF_MARA_RESULT_MARRIAGE, OnPlayerMaraPledge)
end


function LoreWear.RegisterLoreWearEvents()
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_MOUNTED_STATE_CHANGED, OnMountedStateChanged)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_END_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_START_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_PLAYER_COMBAT_STATE, OnPlayerCombatState)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_PLEDGE_OF_MARA_RESULT_MARRIAGE, OnPlayerMaraPledge)
end


function LoreWear.InitializeLoreWear()
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_ZONE_CHANGED, OnZoneChanged)				-- always active
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_PLAYER_ACTIVATED, OnPlayerIsActivated)

	if not LorePlay.savedSettingsTable.isLoreWearOn then return end
	BuildToggleTable()
	LoreWear.RegisterLoreWearEvents()
--[[
	initializeIndicator()
]]
end


function LoreWear.ReenableLoreWear()
	BuildToggleTable()
	LoreWear.RegisterLoreWearEvents()
--[[
	initializeIndicator()
]]
	UpdateLocation(nil)
end


LorePlay = LoreWear
