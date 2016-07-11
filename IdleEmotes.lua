local IdleEmotes = LorePlay

local idleTime = 6 -- 6 ticks of 2 seconds each means idle
local idleCounter = 0 -- if reaches idletime, then player is away (2 secs each tick)
local isPlayerStealthed

function IdleEmotes.PerformIdleEmote()
	PlayEmoteByIndex(199)
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
	if not LorePlay.isSmartEmoting then
		if not IsPlayerMoving() and not LorePlay.isPlayerInCombat then
			if isPlayerStealthed == nil then
				IdleEmotes.UpdateStealthState(EVENT_STEALTH_STATE_CHANGED, LorePlay.player, GetUnitStealthState(LorePlay.player))
			end
			if not isPlayerStealthed then
				return true
			end
		end
	else
		LorePlay.isSmartEmoting = false
	end
	return false
end


function IdleEmotes.SetIdleCounter()
	if not IdleEmotes.IsCharacterIdle() then
		idleCounter = 0
	else
		idleCounter = idleCounter + 1
	end
	--[[
	elseif idleCounter < idleTime then
		idleCounter = idleCounter + 1
	else
		idleCounter = 0
	end
	]]--
end


function IdleEmotes.IsPlayerAway()
	IdleEmotes.SetIdleCounter()
	if idleCounter >= idleTime then
		return true
	end
	return false
end


function IdleEmotes.CheckToPerformIdleEmote()
	if IdleEmotes.IsPlayerAway() and idleCounter%idleTime == 0 then --modulo to deal with small movements in-between checks
		IdleEmotes.PerformIdleEmote()
	end
end


function IdleEmotes.InitializeIdle()
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_STEALTH_STATE_CHANGED, IdleEmotes.UpdateStealthState)
	EVENT_MANAGER:RegisterForUpdate(LorePlay.name, 2000, IdleEmotes.CheckToPerformIdleEmote)
end

LorePlay = IdleEmotes