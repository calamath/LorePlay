local LoreWear = LorePlay

local isMounted
local isFastTraveling
local isInCombat
local currentCostumeID
local lastUsedCollectible
local costumeBeforeCity
local collectiblesMenu
local lastTimeStamp
local wasLastLocationCity
local Appearance, Hats, Costumes, Skins, Polymorphs = "Appearance", "Hats", "Costumes", "Skins", "Polymorphs"


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


local function EquipLoreWearClothes()
	local currentCollectible
	if LorePlay.savedSettingsTable.isUsingFavoriteCostume then
		if LorePlay.savedSettingsTable.favoriteCostumeId then 
			currentCollectible = LorePlay.savedSettingsTable.favoriteCostumeId
		else
			currentCollectible = GetRandomLoreWearCostumeID()
			CHAT_SYSTEM:AddMessage("LorePlay: 'Use Favorite Costume' is enabled, but you haven't set a favorite costume! Go to your addon settings to set a favorite costume.")
		end
	else
		currentCollectible = GetRandomLoreWearCostumeID()
	end
	UseCollectible(currentCollectible)
	lastUsedCollectible = currentCollectible
end


local function UnequipLoreWearClothes()
	if LorePlay.savedSettingsTable.isUsingFavoriteCostume then
		if LorePlay.savedSettingsTable.favoriteCostumeId ~= nil then
			if GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME) == LorePlay.savedSettingsTable.favoriteCostumeId then
				lastUsedCollectible = LorePlay.savedSettingsTable.favoriteCostumeId
			end
		end
	end
	UseCollectible(lastUsedCollectible)
end


local function IsCooldownOver()
	local now = GetTimeStamp()
	if lastTimeStamp then
		if GetDiffBetweenTimeStamps(now, lastTimeStamp) <= 3 then return false end
	end
	lastTimeStamp = now
	return true
end


-- NEW EXPERIMENTAL
-- Return: didLoreWearChooseClothes, didPlayerChooseClothes
local function GetPlayerCostumeState()
	currentCostumeID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
	if currentCostumeID == 0 then
		return false, false
	else
		if not LorePlay.savedSettingsTable.isUsingFavoriteCostume or 
		currentCostumeID == LorePlay.savedSettingsTable.favoriteCostumeId then
			lastUsedCollectible = currentCostumeID
			return true, false
		else
			lastUsedCollectible = currentCostumeID
			return false, true
		end
	end
end


local function CheckToToggleLoreWearClothes()
	if not LorePlay.savedSettingsTable.canActivateLWClothesWhileMounted then 
		if isMounted then return false end
	end
	return true
end


local function ShowOrHideClothes()
	currentCostumeID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
	if currentCostumeID == 0 then
		UseCollectible(lastUsedCollectible)
	else
		lastUsedCollectible = currentCostumeID
		UnequipLoreWearClothes()
	end
end


function LoreWear.KeypressToggleLoreWearClothes()
	if not LorePlay.savedSettingsTable.isLoreWearOn then return end
	if not CheckToToggleLoreWearClothes() then
		CHAT_SYSTEM:AddMessage("Your current settings indicate you cannot equip/unequip clothing while mounted. Check your LorePlay settings to more information.")
		return 
	end
	if not IsCooldownOver() then return end
	ShowOrHideClothes()
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


local function UpdateUnlockedCollectiblesOnCollectibleUpdate(eventCode)
	LoreWear.UpdateUnlockedCostumes()
	--UpdateUnlockedHats()
	--UpdateUnlockedPolymorphs()
	--UpdateUnlockedSkins()
end


local function BuildCollectiblesMenuTable()	
	collectiblesMenu = {
		[Appearance] = {
			[Costumes] = {["Total"] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)},
			[Hats] =  {["Total"] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_HAT)},
			[Polymorphs] = {["Total"] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_POLYMORPH)},
			[Skins] = {["Total"] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_SKIN)}
		}
	}
	LoreWear.UpdateUnlockedCostumes()
end


local function ShouldUpdateLocation(isInCity)
	if not CheckToToggleLoreWearClothes() then return false end
	if wasLastLocationCity == nil then
		wasLastLocationCity = isInCity
		return true
	end
	if isInCity then
		if wasLastLocationCity then 
			--d("is in city, was in city")
			return false
		else 
			--d("is in city, was NOT in city")
			return true
		end
	else
		if not wasLastLocationCity then
			--d("is NOT in city, was NOT in city")
			return false
		else 
			--d("is NOT in city, was in city")
			return true
		end
	end
end


-- EXPERIMENTAL
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
		costumeBeforeCity = currentCostumeID
		if arePlayerChosenClothesActive then
			if LorePlay.savedSettingsTable.shouldFavoriteOverride then
				EquipLoreWearClothes()
			end
		elseif not areLoreWearChosenClothesActive then
			EquipLoreWearClothes()
		end
	else
		if areLoreWearChosenClothesActive or arePlayerChosenClothesActive then
			if LorePlay.savedSettingsTable.equipPreviousCostumeWhenAdventuring and costumeBeforeCity ~= 0 then
				if costumeBeforeCity ~= currentCostumeID then
					UseCollectible(costumeBeforeCity)
				end
			else
				UnequipLoreWearClothes()
			end
		end
	end
	wasLastLocationCity = isInCity
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
		LPEventHandler:UnregisterForEvent(EVENT_MOUNTED_STATE_CHANGED, OnMountedStateChanged)
	end
	LPEventHandler:UnregisterForEvent(EVENT_ZONE_CHANGED, UpdateLocationDelayed)
	LPEventHandler:UnregisterForEvent(EVENT_COLLECTIBLE_NOTIFICATION_NEW, UpdateUnlockedCollectiblesOnCollectibleUpdate)
	LPEventHandler:UnregisterForEvent(EVENT_PLAYER_ACTIVATED, OnPlayerIsActivated)
	LPEventHandler:UnregisterForEvent(EVENT_END_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:UnregisterForEvent(EVENT_START_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:UnregisterForEvent(EVENT_PLAYER_COMBAT_STATE, OnPlayerCombatState)
end


function LoreWear.RegisterLoreWearEvents()
	LPEventHandler:RegisterForEvent(EVENT_MOUNTED_STATE_CHANGED, OnMountedStateChanged)
	LPEventHandler:RegisterForEvent(EVENT_ZONE_CHANGED, UpdateLocationDelayed)
	LPEventHandler:RegisterForEvent(EVENT_COLLECTIBLE_NOTIFICATION_NEW, UpdateUnlockedCollectiblesOnCollectibleUpdate)
	LPEventHandler:RegisterForEvent(EVENT_PLAYER_ACTIVATED, OnPlayerIsActivated)
	LPEventHandler:RegisterForEvent(EVENT_END_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:RegisterForEvent(EVENT_START_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:RegisterForEvent(EVENT_PLAYER_COMBAT_STATE, OnPlayerCombatState)
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