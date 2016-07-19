local IdleEmotes = LorePlay

local idleTime = 15000 -- time period in miliseconds to check whether player is idle
local isPlayerStealthed
local currentPlayerX, currentPlayerY
local emoteFromEvent
local defaultIdleTable
local eventIdleTable
local didIdleEmote = false


function IdleEmotes.CreateEventIdleEmotesTable()
	eventIdleTable = {
		["isEnabled"] = false,
		[EVENT_TRADE_INVITE_ACCEPTED] = {
			[1] = 76,
			[2] = 35,
			[3] = 19,
			[4] = 36,
			[5] = 50,
			[6] = 41,
			[7] = 153,
			[8] = 15,
			[9] = 154
		}
	}
end


function IdleEmotes.CreateDefaultIdleEmotesTable()
	defaultIdleTable = {
		["Zone"] = {
			[1] = 99,
			[2] = 119,
			[3] = 120,
			[4] = 121,
			[5] = 123,
			[6] = 85,
			[7] = 201,
			[8] = 15,
			[9] = 10,
			[10] = 172,
			[11] = 84,
			[12] = 102
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
			[9] = 107,
			[10] = 79
		},
		["Dungeon"] = {
			[1] = 195,
			[2] = 52,
			[3] = 104,
			[4] = 1,
			[5] = 1,
			[6] = 122,
			[7] = 101,
			[8] = 154,
			[9] = 1
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
	if IsPlayerMoving() then return end
	local randomEmote
	local currIdleEmote
	if eventIdleTable["isEnabled"] then
		randomEmote = math.random(#emoteFromEvent)
		currIdleEmote = emoteFromEvent[randomEmote]
	else
		-- Doubles the time checked for Idling to allow current IdleEmote to persist longer
		if didIdleEmote then
			didIdleEmote = false
			return
		end
		local location = IdleEmotes.GetLocation()
		randomEmote = math.random(#defaultIdleTable[location])
		currIdleEmote = defaultIdleTable[location][randomEmote]
	end
	PlayEmoteByIndex(currIdleEmote)
	didIdleEmote = true
end


function IdleEmotes.UpdateEmoteFromEvent(eventCode)
	emoteFromEvent = eventIdleTable[eventCode]
	if not eventIdleTable["isEnabled"] then
		eventIdleTable["isEnabled"] = true
	end
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


function IdleEmotes.OnTradeEvent_For_EVENT_TRADE_INVITE_ACCEPTED(eventCode)
	if eventCode ~= EVENT_TRADE_INVITE_ACCEPTED then return end
	IdleEmotes.UpdateEmoteFromEvent(eventCode)
end


function IdleEmotes.OnTradeEvent_For_TRADE_CESSATION(eventCode)
	if emoteFromEvent == eventIdleTable[EVENT_TRADE_INVITE_ACCEPTED] then
		eventIdleTable["isEnabled"] = false
	end
end


function IdleEmotes.OnPlayerCombatStateEvent(eventCode, inCombat)
	if not inCombat then
		if LorePlay.savedSettingsTable.isIdleEmotesOn then
			EVENT_MANAGER:RegisterForUpdate("IdleEmotes", idleTime, IdleEmotes.CheckToPerformIdleEmote)
		end
	else
		if LorePlay.savedSettingsTable.isIdleEmotesOn then
			EVENT_MANAGER:UnregisterForUpdate("IdleEmotes")
		end
	end
end


function IdleEmotes.OnMountedEvent(eventCode, mounted)
	if not mounted then
		if LorePlay.savedSettingsTable.isIdleEmotesOn then
			EVENT_MANAGER:RegisterForUpdate("IdleEmotes", idleTime, IdleEmotes.CheckToPerformIdleEmote)
		end
	else
		if LorePlay.savedSettingsTable.isIdleEmotesOn then
			EVENT_MANAGER:UnregisterForUpdate("IdleEmotes")
		end
	end
end


function IdleEmotes.OnChatterEvent(eventCode)
	if eventCode == EVENT_CHATTER_BEGIN then
		EVENT_MANAGER:UnregisterForUpdate("IdleEmotes")
	else
		EVENT_MANAGER:RegisterForUpdate("IdleEmotes", idleTime, IdleEmotes.CheckToPerformIdleEmote)
	end
end


function IdleEmotes.UnregisterIdleEvents()
	LPEventHandler.UnregisterForEvent(EVENT_MOUNTED_STATE_CHANGED, IdleEmotes.OnMountedEvent)
	LPEventHandler.UnregisterForEvent(EVENT_PLAYER_COMBAT_STATE, IdleEmotes.OnPlayerCombatStateEvent)
	LPEventHandler.UnregisterForEvent(EVENT_STEALTH_STATE_CHANGED, IdleEmotes.UpdateStealthState)
	LPEventHandler.UnregisterForEvent(EVENT_CHATTER_BEGIN, IdleEmotes.OnChatterEvent)
	LPEventHandler.UnregisterForEvent(EVENT_CHATTER_END, IdleEmotes.OnChatterEvent)
	LPEventHandler.UnregisterForEvent(EVENT_TRADE_INVITE_ACCEPTED, IdleEmotes.OnTradeEvent_For_EVENT_TRADE_INVITE_ACCEPTED)
	LPEventHandler.UnregisterForEvent(EVENT_TRADE_SUCCEEDED, IdleEmotes.OnTradeEvent_For_TRADE_CESSATION)
	LPEventHandler.UnregisterForEvent(EVENT_TRADE_CANCELED, IdleEmotes.OnTradeEvent_For_TRADE_CESSATION)
	EVENT_MANAGER:UnregisterForUpdate("IdleEmotes")
end


function IdleEmotes.RegisterIdleEvents()
	LPEventHandler.RegisterForEvent(EVENT_MOUNTED_STATE_CHANGED, IdleEmotes.OnMountedEvent)
	LPEventHandler.RegisterForEvent(EVENT_PLAYER_COMBAT_STATE, IdleEmotes.OnPlayerCombatStateEvent)
	LPEventHandler.RegisterForEvent(EVENT_STEALTH_STATE_CHANGED, IdleEmotes.UpdateStealthState)
	LPEventHandler.RegisterForEvent(EVENT_CHATTER_BEGIN, IdleEmotes.OnChatterEvent)
	LPEventHandler.RegisterForEvent(EVENT_CHATTER_END, IdleEmotes.OnChatterEvent)
	LPEventHandler.RegisterForEvent(EVENT_TRADE_INVITE_ACCEPTED, IdleEmotes.OnTradeEvent_For_EVENT_TRADE_INVITE_ACCEPTED)
	LPEventHandler.RegisterForEvent(EVENT_TRADE_SUCCEEDED, IdleEmotes.OnTradeEvent_For_TRADE_CESSATION)
	LPEventHandler.RegisterForEvent(EVENT_TRADE_CANCELED, IdleEmotes.OnTradeEvent_For_TRADE_CESSATION)
	EVENT_MANAGER:RegisterForUpdate("IdleEmotes", idleTime, IdleEmotes.CheckToPerformIdleEmote)
end


function IdleEmotes.InitializeIdle()
	if not LorePlay.savedSettingsTable.isIdleEmotesOn then return end
	IdleEmotes.CreateDefaultIdleEmotesTable()
	IdleEmotes.CreateEventIdleEmotesTable()
	currentPlayerX, currentPlayerY = GetMapPlayerPosition(LorePlay.player)
	IdleEmotes.RegisterIdleEvents()
end

LorePlay = IdleEmotes