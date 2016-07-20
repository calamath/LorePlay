--[[ MAKE ADAPTIVE, TOGGLEABLE, AND CUSTOMIZABLE (PERTAINING TO WHETHER CHAR IS WITHIN A ZONE, BLACKLIST CITIES, CERTAIN COSTUMES IN DUNGEONS, AT DOLMENS, ETC.) ]]--

local LoreWear = LorePlay

local isMounted
local lastUsedCollectible
local collectiblesMenu
local lastTimeStamp
local Appearance, Costumes, Hats, Polymorphs, Skins = 3, 1, 2, 3, 4 -- DLC = 1, Upgrade = 2, Appearance = 3, Assistants = 4, etc. Subcategories are also sequential
LoreWear.loreWearClothesActive = false


--[[
function LoreWear.ToggleLoreWear()
end
]]--


local function GetRandomLoreWearCostumeID()
	local randomNumber
	local id
	local isValid = false
	while not isValid do
		randomNumber = math.random(collectiblesMenu[Appearance][Costumes]["Total"])
		id = GetCollectibleId(Appearance,Costumes,randomNumber)
		if collectiblesMenu[Appearance][Costumes][id] == true then isValid = true break
		else
			if collectiblesMenu[Appearance][Costumes][id] == nil or IsCollectibleNew(id) then
				if IsCollectibleUnlocked(id) then 
					collectiblesMenu[Appearance][Costumes][id] = true 
					isValid = true 
				end
			end
		end
	end
	return id
end


local function EquipLoreWearClothes()
	local currentCollectible
	if LorePlay.savedSettingsTable.isUsingFavoriteCostume and LorePlay.savedSettingsTable.favoriteCostumeId then
		currentCollectible = LorePlay.savedSettingsTable.favoriteCostumeId
	else
		currentCollectible = GetRandomLoreWearCostumeID()
	end
	UseCollectible(currentCollectible)
	LoreWear.loreWearClothesActive = true
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
	LoreWear.loreWearClothesActive = false
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
	--[[
	if inCombat and not LoreWear.loreWearClothesActive then
		return false
	end
	]]--
	return true
end


function LoreWear.ToggleLoreWearClothes()
	if not CheckToToggleLoreWearClothes() then return end
	if LoreWear.loreWearClothesActive then
		UnequipLoreWearClothes() 
	else
		EquipLoreWearClothes()
	end
	--d("Toggled!")
end


function LoreWear.KeypressToggleLoreWearClothes()
	if not LorePlay.savedSettingsTable.isLoreWearOn then return end
	if not IsCooldownOver() then return end
	LoreWear.ToggleLoreWearClothes()
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
end


--[[
local function OnCombatStateChanged()
end
]]--


local function UpdateLocation(eventCode)
	local location = GetPlayerLocationName()
	local isInCity = LorePlay.IsPlayerInCity(location)
	local currentCostumeID = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
	-- If not wearing clothing and in city, then definitely toggle clothes
	if isInCity then
		if currentCostumeID == 0 then
			LoreWear.ToggleLoreWearClothes()
		elseif not LoreWear.loreWearClothesActive then
			lastUsedCollectible = currentCostumeID
			LoreWear.loreWearClothesActive = true -- This is to check for whether the player was wearing clothes but not activated from my addon
		end
	else
		if currentCostumeID ~= 0 then
			if CheckToToggleLoreWearClothes() then
				lastUsedCollectible = currentCostumeID
				UnequipLoreWearClothes()
			end
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
			zo_callLater(function() UpdateLocation(EVENT_ZONE_CHANGED) end, 1000)
		end
	end
end


function LoreWear.UnregisterLoreWearEvents()
	LPEventHandler.UnregisterForEvent(EVENT_MOUNTED_STATE_CHANGED, OnMountedStateChanged)
	LPEventHandler.UnregisterForEvent(EVENT_ZONE_CHANGED, UpdateLocation)
	LPEventHandler.UnregisterForEvent(EVENT_PLAYER_ACTIVATED, OnPlayerIsActivated)
end


function LoreWear.RegisterLoreWearEvents()
	LPEventHandler.RegisterForEvent(EVENT_MOUNTED_STATE_CHANGED, OnMountedStateChanged)
	LPEventHandler.RegisterForEvent(EVENT_ZONE_CHANGED, UpdateLocation)
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