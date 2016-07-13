local IdleEmotes = LorePlay

IdleEmotes.idleTime = 15000 -- time period in miliseconds to check whether player is idle
local isPlayerStealthed
local currentPlayerX, currentPlayerY
local idleTable
local didIdleEmote = false


function IdleEmotes.CreateIdleEmotesTable()
	idleTable = {
		["Zone"] = {
			[1] = 99,
			[2] = 119,
			[3] = 120,
			[4] = 121,
			[5] = 123,
			[6] = 85,
			[7] = 116,
			[8] = 118,
			[9] = 10,
			[10] = 172,
			[11] = 84,
			[12] = 102,
			[13] = 15,
			[14] = 201
		},
		["City"] = {
			[1] = 202,
			[2] = 72,
			[3] = 7,
			[4] = 6,
			[5] = 5,
			[6] = 195,
			[7] = 8,
			[8] = 174,
			[9] = 107
		},
		["Dungeon"] = {
			[1] = 195,
			[2] = 52,
			[3] = 104,
			[4] = 1,
			[5] = 1,
			[6] = 122,
			[7] = 101,
			[8] = 154
		}
	}
end


function IdleEmotes.GetLocation()
	local location = GetPlayerLocationName()
	local zoneName = GetPlayerActiveZoneName()

	if LorePlay.IsPlayerInCity(location) then
		return "City"
	elseif LorePlay.IsPlayerInZone(zoneName) then
		return "Zone"
	elseif LorePlay.IsPlayerInDungeon(location, zoneName) then
		return "Dungeon"
	end
end


function IdleEmotes.PerformIdleEmote()
	if didIdleEmote then
		didIdleEmote = false
		return
	end
	if IsPlayerMoving() then return end
	local location = IdleEmotes.GetLocation()
	local randomEmote = math.random(#idleTable[location])
	local currIdleEmote = idleTable[location][randomEmote]
	PlayEmoteByIndex(currIdleEmote)
	didIdleEmote = true
end


function IdleEmotes.DidPlayerMove()
	local newX, newY = GetMapPlayerPosition(LorePlay.player)
	if newX ~= currentPlayerX or newY ~= currentPlayerY then
		currentPlayerX = newX
		currentPlayerY = newY
		return true
	end
	return false
end


function IdleEmotes.UpdateStealthState(eventCode, unitTag, stealthState)
	if unitTag ~= LorePlay.player then return end
	if stealthState ~= STEALTH_STATE_NONE then
		isPlayerStealthed = true
	else
		isPlayerStealthed = false
	end
end


function IdleEmotes.IsCharacterIdle()
	if not LorePlay.didSmartEmote then
		if not IdleEmotes.DidPlayerMove() then
			if isPlayerStealthed == nil then
				IdleEmotes.UpdateStealthState(EVENT_STEALTH_STATE_CHANGED, LorePlay.player, GetUnitStealthState(LorePlay.player))
			end
			if not isPlayerStealthed then
				local interactionType = GetInteractionType()
				--d(interactionType)
  				if interactionType == INTERACTION_NONE then
					return true
				end
			end
		end
	else
		LorePlay.didSmartEmote = false
	end
	return false
end


function IdleEmotes.CheckToPerformIdleEmote()
	if IdleEmotes.IsCharacterIdle() then
		IdleEmotes.PerformIdleEmote()
	end
end


function IdleEmotes.OnChatterEvent(eventCode)
	if eventCode == EVENT_CHATTER_BEGIN then
		EVENT_MANAGER:UnregisterForUpdate("IdleEmotes")
	else
		EVENT_MANAGER:RegisterForUpdate("IdleEmotes", IdleEmotes.idleTime, IdleEmotes.CheckToPerformIdleEmote)
	end
end


function IdleEmotes.UnregisterIdleEvents()
	EVENT_MANAGER:UnregisterForEvent(LorePlay.name, EVENT_STEALTH_STATE_CHANGED)
	EVENT_MANAGER:UnregisterForEvent(LorePlay.name, EVENT_CHATTER_BEGIN)
	EVENT_MANAGER:UnregisterForEvent(LorePlay.name, EVENT_CHATTER_END)
	EVENT_MANAGER:UnregisterForUpdate("IdleEmotes")
end


function IdleEmotes.RegisterIdleEvents()
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_STEALTH_STATE_CHANGED, IdleEmotes.UpdateStealthState)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_CHATTER_BEGIN, IdleEmotes.OnChatterEvent)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_CHATTER_END, IdleEmotes.OnChatterEvent)
	EVENT_MANAGER:RegisterForUpdate("IdleEmotes", IdleEmotes.idleTime, IdleEmotes.CheckToPerformIdleEmote)
end


function IdleEmotes.InitializeIdle()
	if not LorePlay.savedSettingsTable.isIdleEmotesOn then return end
	IdleEmotes.CreateIdleEmotesTable()
	currentPlayerX, currentPlayerY = GetMapPlayerPosition(LorePlay.player)
	IdleEmotes.RegisterIdleEvents()
end

LorePlay = IdleEmotes