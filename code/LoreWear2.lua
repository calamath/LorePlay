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


--[[ DEPRECATED FUNCTION ]]--
local function UnequipLoreWearClothes()
	table = LorePlay.savedSettingsTable.isUsingFavorite
	for i,v in pairs(table) do
		if v then
			local collectible = GetActiveCollectibleByType(stringToColTypeTable[i])
			if collectible ~= 0 then
				UseCollectible(collectible)
			end
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
	local colToStore, colType, curCol
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

--[[
function LoreWear.UpdateUnlockedCostumes()
	local id
	for i = 1, collectiblesMenu[Appearance][Costumes][Total], 1 do
		id = GetCollectibleIdFromType(COLLECTIBLE_CATEGORY_TYPE_COSTUME, i)
		if IsCollectibleUnlocked(id) then
			if not LorePlay.savedSettingsTable.blacklistedCostumes[tostring(id)] then
				collectiblesMenu[Appearance][Costumes][(#collectiblesMenu[Appearance][Costumes] + 1)] = id
			end
		end
	end
end


local function UpdateUnlockedHats()
	local id
	for i = 1, collectiblesMenu[Appearance][Hats][Total], 1 do
		id = GetCollectibleIdFromType(COLLECTIBLE_CATEGORY_TYPE_HAT, i)
		if IsCollectibleUnlocked(id) then
			collectiblesMenu[Appearance][Hats][(#collectiblesMenu[Appearance][Hats] + 1)] = id
		end
	end
end


local function UpdateUnlockedHair()
	local id
	for i = 1, collectiblesMenu[Appearance][Hair][Total], 1 do
		id = GetCollectibleIdFromType(COLLECTIBLE_CATEGORY_TYPE_HAIR, i)
		if IsCollectibleUnlocked(id) then
			collectiblesMenu[Appearance][Hair][(#collectiblesMenu[Appearance][Hair] + 1)] = id
		end
	end
end


local function UpdateUnlockedSkins()
	local id
	for i = 1, collectiblesMenu[Appearance][Skins][Total], 1 do
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


local function UpdateUnlockedCollectibles()
	LoreWear.UpdateUnlockedCostumes()
	UpdateUnlockedHats()
	UpdateUnlockedHair()
	UpdateUnlockedSkins()
end


local function BuildCollectiblesMenuTable()	
	collectiblesMenu = {
		[Appearance] = {
			[Costumes] = {[Total] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)},
			[Hats] =  {[Total] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_HAT)},
			--[Polymorphs] = {["Total"] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_POLYMORPH)},
			[Skins] = {[Total] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_SKIN)},
			[Hair] = {[Total] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_HAIR)}
		}
	}
	UpdateUnlockedCollectibles()
end
]]--


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


local function ChangeLoreWearClothes(isCurrentlyInCity, POI, zone)
	if isCurrentlyInCity then
		outfitToToggle = LorePlay.savedSettingsTable.outfitTable[City]
	elseif LorePlay.IsPlayerInHouse() then
		outfitToToggle = LorePlay.savedSettingsTable.outfitTable[Housing]
	elseif LorePlay.IsPlayerInZone(zone) then
		outfitToToggle = LorePlay.savedSettingsTable.outfitTable[Adventure]
	elseif LorePlay.IsPlayerInDungeon(POI, zone) or LorePlay.isPlayerInDolmen(POI) then
		outfitToToggle = LorePlay.savedSettingsTable.outfitTable[Dungeon]
	end
	EquipLoreWearClothes(outfitToToggle)
end


local function UpdateLocation(eventCode)
	local location = GetPlayerLocationName()
	local zoneName = GetPlayerActiveZoneName()
	local isInCity = LorePlay.IsPlayerInCity(location)
	if isFastTraveling or isInCombat then return end
	if not ShouldUpdateLocation(isInCity) then return end
	if not IsCooldownOver() then
		zo_callLater(function() UpdateLocation(eventCode) end, 3000)
		return
	end
	ChangeLoreWearClothes(isInCity, location, zoneName)
	wasLastLocationCity = isCurrentlyInCity
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
	--LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_COLLECTIBLE_NOTIFICATION_NEW, UpdateUnlockedCollectiblesOnCollectibleUpdate)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_PLAYER_ACTIVATED, OnPlayerIsActivated)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_END_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_START_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_PLAYER_COMBAT_STATE, OnPlayerCombatState)
end


function LoreWear.RegisterLoreWearEvents()
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_MOUNTED_STATE_CHANGED, OnMountedStateChanged)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_ZONE_CHANGED, UpdateLocationDelayed)
	--LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_COLLECTIBLE_NOTIFICATION_NEW, UpdateUnlockedCollectiblesOnCollectibleUpdate)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_PLAYER_ACTIVATED, OnPlayerIsActivated)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_END_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_START_FAST_TRAVEL_INTERACTION, OnFastTravelInteraction)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_PLAYER_COMBAT_STATE, OnPlayerCombatState)
end


function LoreWear.InitializeLoreWear()
	if not LorePlay.savedSettingsTable.isLoreWearOn then return end
	--BuildCollectiblesMenuTable()
	BuildToggleTable()
	LoreWear.RegisterLoreWearEvents()
end


function LoreWear.ReenableLoreWear()
	LoreWear.InitializeLoreWear()
	UpdateLocation(EVENT_ZONE_CHANGED)
end


LorePlay = LoreWear