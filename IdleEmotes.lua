local IdleEmotes = LorePlay

IdleEmotes.idleTime = 15000 -- time in miliseconds to check whether player is idle
local isPlayerStealthed
local currentPlayerX, currentPlayerY
local idleTable



function IdleEmotes.CreateIdleEmotesTable()
	idleTable = {
		["Zone"] = {
			[1] = 
		},
		["City"] = {
			[1] = 
		},
		["Dungeon"] = {
			[1] = 
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
	local location = IdleEmotes.GetLocation()
	local randomEmote = math.random(#idleTable[location])
	local currIdleEmote = idleTable[location][randomEmote]
	PlayEmoteByIndex(currIdleEmote)
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


function IdleEmotes.InitializeIdle()
	currentPlayerX, currentPlayerY = GetMapPlayerPosition(LorePlay.player)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_STEALTH_STATE_CHANGED, IdleEmotes.UpdateStealthState)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_CHATTER_BEGIN, IdleEmotes.OnChatterEvent)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_CHATTER_END, IdleEmotes.OnChatterEvent)
	EVENT_MANAGER:RegisterForUpdate("IdleEmotes", IdleEmotes.idleTime, IdleEmotes.CheckToPerformIdleEmote)
end

LorePlay = IdleEmotes