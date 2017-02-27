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


-- START EXPERIMENTAL

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
			UseCollectible(currentCollectible)
			lastUsedHat = currentCollectible
		else
			CHAT_SYSTEM:AddMessage("LorePlay: 'Use Favorite Hat' is enabled, but you haven't set a favorite hat! Turn off hats, or put on a new hat and set your outfit.")
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
			UseCollectible(currentCollectible)
			lastUsedHair = currentCollectible
			--Maybe here there will be the problem of accidentally taking off a hair that is the same in both favorite and outside cities?
		else
			CHAT_SYSTEM:AddMessage("LorePlay: 'Use Favorite Hair' is enabled, but you haven't set a favorite hair! Turn off hairs, or set your outfit with the option on.")
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
			UseCollectible(currentCollectible)
			lastUsedSkin = currentCollectible
			--Same problem as above?
		else
			CHAT_SYSTEM:AddMessage("LorePlay: 'Use Favorite Skin' is enabled, but you haven't set a favorite skin! Turn off skins, or put on a new skin and set your outfit.")
		end
	end
end


local function EquipLoreWearClothes()
	EquipLoreWearCostume()
	EquipLoreWearHat()
	EquipLoreWearHair()
	EquipLoreWearSkin()
end


-- END EXPERIMENTAL


--[[ REAL CODE DON'T DELETE
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
]]--


-- START EXPERIMENTAL

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

-- END EXPERIMENTAL


--[[ REAL CODE DON'T DELETE
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
]]--

local function IsCooldownOver()
	local now = GetTimeStamp()
	if lastTimeStamp then
		if GetDiffBetweenTimeStamps(now, lastTimeStamp) <= 3 then return false end
	end
	lastTimeStamp = now
	return true
end



-- START EXPERIMENTAL -- SHOULD BE OUTFIT STATE
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
		--d("CostumeCheck: "..tostring(costumeCheck))
		--d("HatCheck: "..tostring(hatCheck))
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
-- END EXPERIMENTAL



--[[ REAL CODE DON'T DELETE
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
]]--


local function CheckToToggleLoreWearClothes()
	if not LorePlay.savedSettingsTable.canActivateLWClothesWhileMounted then 
		if isMounted then return false end
	end
	return true
end



--[[ WORK IN PROGRESS
local function ForceShowOrHideClothes()
	currentCostumeID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
	currentHatID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAT)
	currentHairID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_HAIR)
	currentSkinID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_SKIN)

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


 --MAY NOT WORK YET
local function UpdateUnlockedHats()
	local id
	for i = 1, collectiblesMenu[Appearance][Hats]["Total"], 1 do
		id = GetCollectibleIdFromType(COLLECTIBLE_CATEGORY_TYPE_HAT, i)
		if IsCollectibleUnlocked(id) then
			--blacklistedHats doesn't yet exist
			--[[ Hats don't need to be blacklisted ]]--
			--if not LorePlay.savedSettingsTable.blacklistedHats[tostring(id)] then
				collectiblesMenu[Appearance][Hats][(#collectiblesMenu[Appearance][Hats] + 1)] = id
			--end
		end
	end
end


 --MAY NOT WORK YET
local function UpdateUnlockedHair()
	local id
	for i = 1, collectiblesMenu[Appearance][Hair]["Total"], 1 do
		id = GetCollectibleIdFromType(COLLECTIBLE_CATEGORY_TYPE_HAIR, i)
		if IsCollectibleUnlocked(id) then
			--blacklistedHair doesn't yet exist
			--[[ Hair doesn't need to be blacklisted ]]--
			--if not LorePlay.savedSettingsTable.blacklistedHair[tostring(id)] then
				collectiblesMenu[Appearance][Hair][(#collectiblesMenu[Appearance][Hair] + 1)] = id
			--end
		end
	end
end


 --MAY NOT WORK YET
local function UpdateUnlockedSkins()
	local id
	for i = 1, collectiblesMenu[Appearance][Skins]["Total"], 1 do
		id = GetCollectibleIdFromType(COLLECTIBLE_CATEGORY_TYPE_SKIN, i)
		if IsCollectibleUnlocked(id) then
			--blacklistedSkins doesn't yet exist
			--[[ Skins don't need to be blacklisted ]]--
			--if not LorePlay.savedSettingsTable.blacklistedSkins[tostring(id)] then
				collectiblesMenu[Appearance][Skins][(#collectiblesMenu[Appearance][Skins] + 1)] = id
			--end
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



--[[ WORK IN PROGRESS
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
		if not areLoreWearChosenClothesActive or 
		arePlayerChosenClothesActive and LorePlay.savedSettingsTable.shouldFavoriteOverride then
			EquipLoreWearClothes()
			if wasLastLocationCity == nil then return end
			wasLastLocationCity = isInCity
			costumeBeforeCity = currentCostumeID
			return
		end
	else
		if areLoreWearChosenClothesActive or arePlayerChosenClothesActive then
			if LorePlay.savedSettingsTable.equipPreviousCostumeWhenAdventuring and costumeBeforeCity and costumeBeforeCity ~= 0 then
				if costumeBeforeCity ~= currentCostumeID or wasLastLocationCity == nil then
					UseCollectible(costumeBeforeCity)
				end
			else
				UnequipLoreWearClothes()
			end
			wasLastLocationCity = isInCity
		end
	end
end

]]--



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
	d(areLoreWearChosenClothesActive)
	d(arePlayerChosenClothesActive)
	if isInCity then
		if not areLoreWearChosenClothesActive then
		--if not areLoreWearChosenClothesActive == (arePlayerChosenClothesActive and LorePlay.savedSettingsTable.shouldFavoriteOverride) then
			if arePlayerChosenClothesActive and not LorePlay.savedSettingsTable.shouldFavoriteOverride then return end
			d("Equipping!")
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
					-- Was a costume, is wearing a different costume
					if costumeBeforeCity ~= 0 and currentCostumeID ~= costumeBeforeCity then
						UseCollectible(costumeBeforeCity)
					elseif (costumeBeforeCity ~= 0 and currentCostumeID == 0) then
						UseCollectible(lastUsedCostume)
					elseif (costumeBeforeCity == 0 and currentCostumeID ~= 0) then
						UseCollectible(lastUsedCostume)
					end

					if LorePlay.savedSettingsTable.isUsingFavoriteHat then 
						if hatBeforeCity ~= 0 and currentHatID ~= hatBeforeCity then
							d(hatBeforeCity)
							d(currentHatID)
							--If different than default, equip it
							UseCollectible(hatBeforeCity) 
						elseif (hatBeforeCity ~= 0 and currentHatID == 0) then
							--Otherwise, revert from last hair to default hair
							UseCollectible(lastUsedHat)
						elseif (hatBeforeCity == 0 and currentHatID ~= 0) then
							UseCollectible(lastUsedHat)
						end
					end
					if LorePlay.savedSettingsTable.isUsingFavoriteHair then 
						if hairBeforeCity ~= 0 and currentHairID ~= hairBeforeCity then
							--If different than default, equip it
							UseCollectible(hairBeforeCity) 
						elseif (hairBeforeCity ~= 0 and currentHairID == 0) then
							--Otherwise, revert from last hair to default hair
							UseCollectible(lastUsedHair)
						elseif (hairBeforeCity == 0 and currentHairID ~= 0) then
							UseCollectible(lastUsedHair)
						end
					end
					if LorePlay.savedSettingsTable.isUsingFavoriteSkin then 
						if skinBeforeCity ~= 0 and currentSkinID ~= skinBeforeCity then
							--If different than default, equip it
							UseCollectible(skinBeforeCity) 
						elseif (skinBeforeCity ~= 0 and currentSkinID == 0) then
							--Otherwise, revert from last hair to default hair
							UseCollectible(lastUsedSkin)
						elseif (skinBeforeCity == 0 and currentSkinID ~= 0) then
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