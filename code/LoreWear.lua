local LoreWear = LorePlay

local isMounted
local isFastTraveling
local isInCombat
local currentCostumeID

local currentHatID
local currentHairID
local currentSkinID

local lastUsedCostume
local lastUsedHat
local lastUsedHair
local lastUsedSkin

local lastUsedCollectible
local costumeBeforeCity
local hatBeforeCity
local hairBeforeCity
local skinBeforeCity
local collectiblesMenu
local lastTimeStamp
local wasLastLocationCity
local Appearance, Hats, Costumes, Skins, Polymorphs, Hair = "Appearance", "Hats", "Costumes", "Skins", "Polymorphs", "Hair"


local function GetRandomLoreWearCostumeID()
	local randomNumber
	local id
	local numOfUnlockedCostumes = #collectiblesMenu[Appearance][Costumes]
	if numOfUnlockedCostumes >= 1 then
		randomNumber = math.random(numOfUnlockedCostumes)
		id = collectiblesMenu[Appearance][Costumes][randomNumber]
		return id
	end
	return
end


local function EquipLoreWearCostume()
	local currentCollectible
	if LorePlay.savedSettingsTable.isUsingFavoriteCostume then
		if LorePlay.savedSettingsTable.favoriteCostumeId then 
			currentCollectible = LorePlay.savedSettingsTable.favoriteCostumeId
			-- Might need to set lastUsedCostume to current collectible here?
			if currentCollectible == GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME) then return end
		else
			currentCollectible = GetRandomLoreWearCostumeID()
			CHAT_SYSTEM:AddMessage("LorePlay: 'Use Favorite Costume' is enabled, but you haven't set a favorite costume! Go to your addon settings to set a favorite costume.")
		end
	else
		currentCollectible = GetRandomLoreWearCostumeID()
	end
	UseCollectible(currentCollectible)
	lastUsedCostume = currentCollectible
end


local function EquipLoreWearHat()
	local currentCollectible
	if LorePlay.savedSettingsTable.isUsingFavoriteHat then
		if LorePlay.savedSettingsTable.favoriteHatId then
			currentCollectible = LorePlay.savedSettingsTable.favoriteHatId
			-- Might need to set lastUsedCostume to current collectible here?
			if currentCollectible == GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAT) then return end
			-- If favorite is 0 but character is wearing a hat, take off the hat
			if currentCollectible == 0 then UseCollectible(lastUsedHat) return end
			UseCollectible(currentCollectible)
			lastUsedHat = currentCollectible
		end
	end
end


local function EquipLoreWearHair()
	local currentCollectible
	if LorePlay.savedSettingsTable.isUsingFavoriteHair then
		if LorePlay.savedSettingsTable.favoriteHairId then
			currentCollectible = LorePlay.savedSettingsTable.favoriteHairId
			-- Might need to set lastUsedCostume to current collectible here?
			if currentCollectible == GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAIR) then return end
			-- If favorite is 0 but you are wearing hair, then take off the hair
			if currentCollectible == 0 then UseCollectible(lastUsedHair) return end
			UseCollectible(currentCollectible)
			lastUsedHair = currentCollectible
			--Maybe here there will be the problem of accidentally taking off a hair that is the same in both favorite and outside cities?
		end
	end
end


local function EquipLoreWearSkin()
	local currentCollectible
	if LorePlay.savedSettingsTable.isUsingFavoriteSkin then
		if LorePlay.savedSettingsTable.favoriteSkinId then
			currentCollectible = LorePlay.savedSettingsTable.favoriteSkinId
			-- Might need to set lastUsedCostume to current collectible here?
			if currentCollectible == GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_SKIN) then return end
			-- If wearing a skin but favorite is 0, then take skin off
			if currentCollectible == 0 then UseCollectible(lastUsedSkin) return end
			UseCollectible(currentCollectible)
			lastUsedSkin = currentCollectible
			--Same problem as above?
		end
	end
end

--[[ MUST FIX THIS. IF THERE'S NO HAT SET IN FAVORITE, BUT OPTION IS ON, THEN IT SHOULD TAKE ANY HAT OFF UPON ENTERING THE CITY.
 POSSIBLE SOLUTION: Remove 'return' in the Settings.lua favorite section where collectibleId == 0. The, check for 0 here and use lastUsedCollectible? ]]--
local function EquipLoreWearClothes()
	EquipLoreWearCostume()
	EquipLoreWearHat()
	EquipLoreWearHair()
	EquipLoreWearSkin()
end


local function UnequipLoreWearCostume()
	if LorePlay.savedSettingsTable.isUsingFavoriteCostume then
		if LorePlay.savedSettingsTable.favoriteCostumeId ~= nil then
			if GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME) == LorePlay.savedSettingsTable.favoriteCostumeId then
				lastUsedCostume = LorePlay.savedSettingsTable.favoriteCostumeId
			end
		end
	end
	UseCollectible(lastUsedCostume)
end


local function UnequipLoreWearHat()
	if LorePlay.savedSettingsTable.isUsingFavoriteHat then
		if LorePlay.savedSettingsTable.favoriteHatId ~= nil then
			if GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAT) == LorePlay.savedSettingsTable.favoriteHatId then
				lastUsedHat = LorePlay.savedSettingsTable.favoriteHatId
			end
		end
	end
	UseCollectible(lastUsedHat)
end


local function UnequipLoreWearHair()
	if LorePlay.savedSettingsTable.isUsingFavoriteHair then
		if LorePlay.savedSettingsTable.favoriteHairId ~= nil then
			if GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAIR) == LorePlay.savedSettingsTable.favoriteHairId then
				lastUsedHair = LorePlay.savedSettingsTable.favoriteHairId
			end
		end
	end
	UseCollectible(lastUsedHair)
end


local function UnequipLoreWearSkin()
	if LorePlay.savedSettingsTable.isUsingFavoriteSkin then
		if LorePlay.savedSettingsTable.favoriteSkinId ~= nil then
			if GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_SKIN) == LorePlay.savedSettingsTable.favoriteSkinId then
				lastUsedSkin = LorePlay.savedSettingsTable.favoriteSkinId
			end
		end
	end
	UseCollectible(lastUsedSkin)
end


local function UnequipLoreWearClothes()
	UnequipLoreWearCostume()
	UnequipLoreWearHat()
	UnequipLoreWearHair()
	UnequipLoreWearSkin()
end


local function IsCooldownOver()
	local now = GetTimeStamp()
	if lastTimeStamp then
		if GetDiffBetweenTimeStamps(now, lastTimeStamp) <= 3 then return false end
	end
	lastTimeStamp = now
	return true
end


-- SHOULD BE OUTFIT STATE
-- Return: didLoreWearChooseClothes, didPlayerChooseClothes
local function GetPlayerCostumeState()
	currentCostumeID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
	currentHatID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAT)
	currentHairID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAIR)
	currentSkinID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_SKIN)
	local costumeCheck = true
	local hatCheck = true
	local hairCheck = true
	local skinCheck = true

	if LorePlay.savedSettingsTable.isUsingFavoriteCostume then
		if currentCostumeID ~= 0 then 
			lastUsedCostume = currentCostumeID
		end
		if currentCostumeID ~= LorePlay.savedSettingsTable.favoriteCostumeId then
			costumeCheck = false
		end
	end
	if LorePlay.savedSettingsTable.isUsingFavoriteHat then
		if currentHatID ~= 0 then
			lastUsedHat = currentHatID
		end
		if currentHatID ~= LorePlay.savedSettingsTable.favoriteHatId then
			hatCheck = false
		end
	end
	if LorePlay.savedSettingsTable.isUsingFavoriteHair then
		if currentHairID ~= 0 then-- Need to check for 0?
			lastUsedHair = currentHairID
		end
		if currentHairID ~= LorePlay.savedSettingsTable.favoriteHairId then
			hairCheck = false
		end
	end
	if LorePlay.savedSettingsTable.isUsingFavoriteSkin then
		if currentSkinID ~= 0 then
			lastUsedSkin = currentSkinID
		end
		if currentSkinID ~= LorePlay.savedSettingsTable.favoriteSkinId then
			skinCheck = false
		end
	end

	-- If any one category failed, either player chose clothes or player isn't in city
	if not costumeCheck or not hatCheck or not hairCheck or not skinCheck then
		-- If player is wearing nothing, they didn't choose their clothes
		if currentCostumeID == 0 and currentHatID == 0 and currentSkinID == 0
		and currentHairID == 0 then
			return false, false
		else
			return false, true
		end
	end
	return true, false
end


local function CheckToToggleLoreWearClothes()
	if not LorePlay.savedSettingsTable.canActivateLWClothesWhileMounted then 
		if isMounted then return false end
	end
	return true
end


local function ForceShowOrHideClothes()
	local isWearingOther = false
	local isUsingCostume = LorePlay.savedSettingsTable.isUsingFavoriteCostume
	local isUsingHat = LorePlay.savedSettingsTable.isUsingFavoriteHat
	local isUsingHair = LorePlay.savedSettingsTable.isUsingFavoriteHair
	local isUsingSkin = LorePlay.savedSettingsTable.isUsingFavoriteSkin

	currentCostumeID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
	currentHatID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAT)
	currentHairID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAIR)
	currentSkinID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_SKIN)

	if not forceShowOrHideTable then
		forceShowOrHideTable = 
		{
			[Costumes] = 0,--currentCostumeID, 
			[Hats] = 0,--currentHatID, 
			[Hair] = 0,--currentSkinID, 
			[Skins] = 0--currentSkinID
		}
	end

	-- Checking if the player is wearing something else
	if isUsingCostume and currentCostumeID ~= 0 then
		forceShowOrHideTable[Costumes] = currentCostumeID
		if currentCostumeID ~= LorePlay.savedSettingsTable.favoriteCostumeId then
			isWearingOther = true
		end
	end
	if isUsingHat and currentHatID ~= 0 then
		forceShowOrHideTable[Hats] = currentHatID
		if currentHatID ~= LorePlay.savedSettingsTable.favoriteHatId then
			isWearingOther = true
		end
	end
	if isUsingHair and currentHairID ~= 0 then
		forceShowOrHideTable[Hair] = currentHairID
		if currentHairID ~= LorePlay.savedSettingsTable.favoriteHairId then
			isWearingOther = true
		end
	end
	if isUsingSkin and currentSkinID ~= 0 then
		forceShowOrHideTable[Skin] = currentSkinID
		if currentSkinID ~= LorePlay.savedSettingsTable.favoriteSkinId then
			isWearingOther = true
		end
	end

	--If wearing nothing, put on the LoreWear clothes
	if currentCostumeID == 0 and currentHatID == 0 and currentHairID == 0 and currentSkinID == 0 then
		EquipLoreWearClothes()
		isWearingOther = false
	--Otherwise, handle what's being worn
	else
		if isWearingOther then
			EquipLoreWearClothes()
			return
		end
		if isUsingCostume then
			UseCollectible(forceShowOrHideTable[Costumes])
		end
		if isUsingHat then
			UseCollectible(forceShowOrHideTable[Hats])
		end
		if isUsingHair then
			UseCollectible(forceShowOrHideTable[Hair])
		end
		if isUsingSkin then
			UseCollectible(forceShowOrHideTable[Skins])
		end
		return
	end

	-- Delayed because otherwise it doesn't detect the change of collectible fast enough.
	zo_callLater(function()
		if forceShowOrHideTable[Costumes] ~= 0 and forceShowOrHideTable[Costumes] ~= LorePlay.savedSettingsTable.favoriteCostumeId then
			forceShowOrHideTable[Costumes] = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
		end
		if forceShowOrHideTable[Hats] ~= 0 and forceShowOrHideTable[Hats] ~= LorePlay.savedSettingsTable.favoriteHatId then
			forceShowOrHideTable[Hats] = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAT)
		end
		if forceShowOrHideTable[Hair] ~= 0 and forceShowOrHideTable[Hair] ~= LorePlay.savedSettingsTable.favoriteHairId then
			forceShowOrHideTable[Hair] = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAIR)
		end
		if forceShowOrHideTable[Skins] ~= 0 and forceShowOrHideTable[Skins] ~= LorePlay.savedSettingsTable.favoriteSkinId then
			forceShowOrHideTable[Skins] = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_SKIN)
		end
	end, 1000)
end


--[[ REAL CODE DON'T DELETE YET
local function ForceShowOrHideClothes()
	currentCostumeID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
	if currentCostumeID == 0 then
		if not lastUsedCollectible then
			EquipLoreWearClothes()
		else
			UseCollectible(lastUsedCollectible)
		end
	else
		lastUsedCollectible = currentCostumeID
		UnequipLoreWearClothes()
	end
end
]]--


function LoreWear.KeypressToggleLoreWearClothes()
	if not LorePlay.savedSettingsTable.isLoreWearOn then return end
	if not CheckToToggleLoreWearClothes() then
		CHAT_SYSTEM:AddMessage("Your current settings indicate you cannot equip/unequip clothing while mounted. Check your LorePlay settings to more information.")
		return 
	end
	if not IsCooldownOver() then return end
	ForceShowOrHideClothes()
end


function LoreWear.UpdateUnlockedCostumes()
	local id
	for i = 1, collectiblesMenu[Appearance][Costumes]["Total"], 1 do
		id = GetCollectibleIdFromType(COLLECTIBLE_CATEGORY_TYPE_COSTUME, i)
		if IsCollectibleUnlocked(id) then
			if not LorePlay.savedSettingsTable.blacklistedCostumes[tostring(id)] then
				collectiblesMenu[Appearance][Costumes][(#collectiblesMenu[Appearance][Costumes] + 1)] = id
			end
		end
	end
end


 -- Not needed yet, not really used
local function UpdateUnlockedHats()
	local id
	for i = 1, collectiblesMenu[Appearance][Hats]["Total"], 1 do
		id = GetCollectibleIdFromType(COLLECTIBLE_CATEGORY_TYPE_HAT, i)
		if IsCollectibleUnlocked(id) then
			collectiblesMenu[Appearance][Hats][(#collectiblesMenu[Appearance][Hats] + 1)] = id
		end
	end
end


 -- Not needed yet, not really used
local function UpdateUnlockedHair()
	local id
	for i = 1, collectiblesMenu[Appearance][Hair]["Total"], 1 do
		id = GetCollectibleIdFromType(COLLECTIBLE_CATEGORY_TYPE_HAIR, i)
		if IsCollectibleUnlocked(id) then
			collectiblesMenu[Appearance][Hair][(#collectiblesMenu[Appearance][Hair] + 1)] = id
		end
	end
end


 --Not needed yet, not really used
local function UpdateUnlockedSkins()
	local id
	for i = 1, collectiblesMenu[Appearance][Skins]["Total"], 1 do
		id = GetCollectibleIdFromType(COLLECTIBLE_CATEGORY_TYPE_SKIN, i)
		if IsCollectibleUnlocked(id) then
			collectiblesMenu[Appearance][Skins][(#collectiblesMenu[Appearance][Skins] + 1)] = id
		end
	end
end

local function UpdateUnlockedCollectiblesOnCollectibleUpdate(eventCode, collectibleId)
	local _,_,_,_,_,_,_,collCategory = GetCollectibleInfo(collectibleId)
	if collCategory == COLLECTIBLE_CATEGORY_TYPE_COSTUME then
		LoreWear.UpdateUnlockedCostumes()
	elseif collCategory == COLLECTIBLE_CATEGORY_TYPE_HAT then
		UpdateUnlockedHats()
	elseif collCategory == COLLECTIBLE_CATEGORY_TYPE_HAIR then
		UpdateUnlockedHair()
	elseif collCategorry == COLLECTIBLE_CATEGORY_TYPE_SKIN then
		UpdateUnlockedSkins()
	end
	--UpdateUnlockedPolymorphs()
end


local function BuildCollectiblesMenuTable()	
	collectiblesMenu = {
		[Appearance] = {
			[Costumes] = {["Total"] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)},
			[Hats] =  {["Total"] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_HAT)},
			[Polymorphs] = {["Total"] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_POLYMORPH)},
			[Skins] = {["Total"] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_SKIN)},
			[Hair] = {["Total"] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_HAIR)}
		}
	}
	LoreWear.UpdateUnlockedCostumes()
	UpdateUnlockedHats()
	UpdateUnlockedHair()
end


local function ShouldUpdateLocation(isInCity)
	if not CheckToToggleLoreWearClothes() then return false end
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
end


-- This is disgusting. I know. Need to break up into multiple functions for better clarity and ease of reading
local function UpdateLocation(eventCode)
	local location = GetPlayerLocationName()
	local isInCity = LorePlay.IsPlayerInCity(location)
	if isFastTraveling or isInCombat then return end
	if not ShouldUpdateLocation(isInCity) then return end
	if not IsCooldownOver() then
		zo_callLater(function() UpdateLocation(eventCode) end, 3000)
		return
	end
	local areLoreWearChosenClothesActive, arePlayerChosenClothesActive = GetPlayerCostumeState()
	if isInCity then
		if not areLoreWearChosenClothesActive then
			if arePlayerChosenClothesActive and not LorePlay.savedSettingsTable.shouldFavoriteOverride then return end
			EquipLoreWearClothes()
			if wasLastLocationCity == nil then return end
			wasLastLocationCity = isInCity
			costumeBeforeCity = currentCostumeID
			hatBeforeCity = currentHatID
			hairBeforeCity = currentHairID
			skinBeforeCity = currentSkinID
			return
		end
	else
		if areLoreWearChosenClothesActive or arePlayerChosenClothesActive then
			if LorePlay.savedSettingsTable.equipPreviousCostumeWhenAdventuring and ((costumeBeforeCity and costumeBeforeCity ~= 0)
			or (hatBeforeCity and hatBeforeCity ~= 0) or (hairBeforeCity and hairBeforeCity ~= 0) or (skinBeforeCity and skinBeforeCity ~= 0)) then
				--if wasLastLocationCity == nil then

					if LorePlay.savedSettingsTable.isUsingFavoriteCostume then
						-- Was a costume, is wearing a different costume
						if costumeBeforeCity ~= 0 and currentCostumeID ~= costumeBeforeCity then
							--If different than before, equip it
							UseCollectible(costumeBeforeCity)
						elseif (costumeBeforeCity ~= 0 and currentCostumeID == 0) then
							--If not wearing it, but you need to, equip it
							UseCollectible(lastUsedCostume)
						elseif (costumeBeforeCity == 0 and currentCostumeID ~= 0) then
							--If wearing something but need to take it off, take it off
							UseCollectible(lastUsedCostume)
						end
					end
					if LorePlay.savedSettingsTable.isUsingFavoriteHat then 
						if hatBeforeCity ~= 0 and currentHatID ~= hatBeforeCity then
							--If different than before, equip it
							UseCollectible(hatBeforeCity) 
						--[[ Convert the next 2 elseif statements to logical xors ]]--
						elseif (hatBeforeCity ~= 0 and currentHatID == 0) then
							--If not wearing it, but you need to, equip it
							UseCollectible(lastUsedHat)
						elseif (hatBeforeCity == 0 and currentHatID ~= 0) then
							--If wearing something but need to take it off, take it off
							UseCollectible(lastUsedHat)
						end
					end
					if LorePlay.savedSettingsTable.isUsingFavoriteHair then 
						if hairBeforeCity ~= 0 and currentHairID ~= hairBeforeCity then
							--If different than before, equip it
							UseCollectible(hairBeforeCity) 
						elseif (hairBeforeCity ~= 0 and currentHairID == 0) then
							--If not wearing hair, but you now need to, equip it
							UseCollectible(lastUsedHair)
						elseif (hairBeforeCity == 0 and currentHairID ~= 0) then
							--If wearing hair but need to take it off, take it off
							UseCollectible(lastUsedHair)
						end
					end
					if LorePlay.savedSettingsTable.isUsingFavoriteSkin then 
						if skinBeforeCity ~= 0 and currentSkinID ~= skinBeforeCity then
							--If different than before, equip it
							UseCollectible(skinBeforeCity) 
						elseif (skinBeforeCity ~= 0 and currentSkinID == 0) then
							--If not wearing a skin, but you now need to, equip it
							UseCollectible(lastUsedSkin)
						elseif (skinBeforeCity == 0 and currentSkinID ~= 0) then
							--If wearing a skin but need to take it off, take it off
							UseCollectible(lastUsedSkin)
						end
					end
				--end
			else
				UnequipLoreWearClothes()
			end
			wasLastLocationCity = isInCity
		end
	end
end


local function UpdateLocationDelayed(eventCode)
	zo_callLater(function() UpdateLocation(eventCode) end, 5000)
end


local function OnPlayerIsActivated(eventCode)
	isMounted = IsMounted()
	UpdateLocation(EVENT_ZONE_CHANGED)
end


local function OnMountedStateChanged(eventCode, mounted)
	if mounted then 
		isMounted = true
	else 
		isMounted = false
		if not LorePlay.savedSettingsTable.canActivateLWClothesWhileMounted then 
			zo_callLater(function() UpdateLocation(EVENT_ZONE_CHANGED) end, 1400)
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
		zo_callLater(function() UpdateLocation(EVENT_ZONE_CHANGED) end, 1000)
	end
end


function LoreWear.UnregisterLoreWearEvents()
	if not LorePlay.savedSettingsTable.canActivateLWClothesWhileMounted then
		LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_MOUNTED_STATE_CHANGED, OnMountedStateChanged)
	end
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_ZONE_CHANGED, UpdateLocationDelayed)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_COLLECTIBLE_NOTIFICATION_NEW, UpdateUnlockedCollectiblesOnCollectibleUpdate)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_PLAYER_ACTIVATED, OnPlayerIsActivated)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_END_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_START_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_PLAYER_COMBAT_STATE, OnPlayerCombatState)
end


function LoreWear.RegisterLoreWearEvents()
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_MOUNTED_STATE_CHANGED, OnMountedStateChanged)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_ZONE_CHANGED, UpdateLocationDelayed)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_COLLECTIBLE_NOTIFICATION_NEW, UpdateUnlockedCollectiblesOnCollectibleUpdate)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_PLAYER_ACTIVATED, OnPlayerIsActivated)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_END_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_START_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_PLAYER_COMBAT_STATE, OnPlayerCombatState)
end


function LoreWear.InitializeLoreWear()
	if not LorePlay.savedSettingsTable.isLoreWearOn then return end
	BuildCollectiblesMenuTable()
	LoreWear.RegisterLoreWearEvents()
end


function LoreWear.ReenableLoreWear()
	LoreWear.InitializeLoreWear()
	UpdateLocation(EVENT_ZONE_CHANGED)
end


LorePlay = LoreWear