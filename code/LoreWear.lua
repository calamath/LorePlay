--[[ MAKE ADAPTIVE, TOGGLEABLE, AND CUSTOMIZABLE (PERTAINING TO WHETHER CHAR IS WITHIN A ZONE, BLACKLIST CITIES, CERTAIN COSTUMES IN DUNGEONS, AT DOLMENS, ETC.) ]]--

local LoreWear = LorePlay

local isMounted
local lastUsedCollectible
local collectiblesMenu
local lastTimeStamp
local wasLastLocationCity
local Appearance, Costumes, Hats, Polymorphs, Skins = 3, 1, 2, 3, 4 -- DLC = 1, Upgrade = 2, Appearance = 3, Assistants = 4, etc. Subcategories are also sequential
LoreWear.loreWearClothesActive = false


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


local function CheckToToggleLoreWearClothes()
	if not LorePlay.savedSettingsTable.canActivateLWClothesWhileMounted then 
		if isMounted then return false end
	end
	return true
end


function LoreWear.ToggleLoreWearClothes()
	if LoreWear.loreWearClothesActive then
		UnequipLoreWearClothes() 
	else
		EquipLoreWearClothes()
	end
end


function LoreWear.KeypressToggleLoreWearClothes()
	if not LorePlay.savedSettingsTable.isLoreWearOn then return end
	if not CheckToToggleLoreWearClothes() then
		CHAT_SYSTEM:AddMessage("Your current settings indicate you cannot equip/unequip clothing while mounted. Check your LorePlay settings to more information.")
		return 
	end
	if not IsCooldownOver() then return end
	LoreWear.ToggleLoreWearClothes()
end


function LoreWear.UpdateUnlockedCostumes()
	local id
	for i = 1, collectiblesMenu[Appearance][Costumes]["Total"], 1 do
		id = GetCollectibleId(Appearance,Costumes,i)
		if IsCollectibleUnlocked(id) then
			if not LorePlay.savedSettingsTable.blacklistedCostumes[tostring(id)] then
				collectiblesMenu[Appearance][Costumes][(#collectiblesMenu[Appearance][Costumes] + 1)] = id
			end
		end
	end
end


local function UpdateUnlockedCostumesOnCollectibleUpdate(eventCode)
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
			return false
		else 
			wasLastLocationCity = true
			return true
		end
	else
		if not wasLastLocationCity then
			return false
		else 
			wasLastLocationCity = false
			return true
		end
	end
end


local function UpdateLocation(eventCode)
	local location = GetPlayerLocationName()
	local isInCity = LorePlay.IsPlayerInCity(location)
	local currentCostumeID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
	-- If not wearing clothing and in city, then definitely toggle clothes
	if not ShouldUpdateLocation(isInCity) then return end
	if isInCity then
		if currentCostumeID == 0 then
			LoreWear.loreWearClothesActive = false
			LoreWear.ToggleLoreWearClothes()
		elseif not LoreWear.loreWearClothesActive then	--This is to check for whether the player was wearing clothes but not activated from my addon
			lastUsedCollectible = currentCostumeID
			LoreWear.loreWearClothesActive = true
		end
	else
		if currentCostumeID ~= 0 then
			LoreWear.loreWearClothesActive = true
			lastUsedCollectible = currentCostumeID
			LoreWear.ToggleLoreWearClothes()
		end
	end
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
			zo_callLater(function() UpdateLocation(EVENT_ZONE_CHANGED) end, 1350)
		end	
	end
end


function LoreWear.UnregisterLoreWearEvents()
	if not LorePlay.savedSettingsTable.canActivateLWClothesWhileMounted then
		LPEventHandler.UnregisterForEvent(EVENT_MOUNTED_STATE_CHANGED, OnMountedStateChanged)
	end
	LPEventHandler.UnregisterForEvent(EVENT_ZONE_CHANGED, UpdateLocation)
	LPEventHandler.UnregisterForEvent(EVENT_COLLECTIBLE_NOTIFICATION_NEW, UpdateUnlockedCostumesOnCollectibleUpdate)
	LPEventHandler.UnregisterForEvent(EVENT_PLAYER_ACTIVATED, OnPlayerIsActivated)
end


function LoreWear.RegisterLoreWearEvents()
	LPEventHandler.RegisterForEvent(EVENT_MOUNTED_STATE_CHANGED, OnMountedStateChanged)
	LPEventHandler.RegisterForEvent(EVENT_ZONE_CHANGED, UpdateLocation)
	LPEventHandler.RegisterForEvent(EVENT_COLLECTIBLE_NOTIFICATION_NEW, UpdateUnlockedCostumesOnCollectibleUpdate)
	LPEventHandler.RegisterForEvent(EVENT_PLAYER_ACTIVATED, OnPlayerIsActivated)
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