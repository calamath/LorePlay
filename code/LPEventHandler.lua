LPEventHandler = {}

eventToFunctionTable = {
	[EVENT_PLAYER_ACTIVATED] = {},
	[EVENT_PLAYER_NOT_SWIMMING] = {},
	[EVENT_MOUNTED_STATE_CHANGED] = {},
	[EVENT_PLAYER_COMBAT_STATE] = {},
	[EVENT_LEVEL_UPDATE] = {},
	[EVENT_POWER_UPDATE] = {},
	[EVENT_TRADE_CANCELED] = {},
	[EVENT_TRADE_SUCCEEDED] = {},
	[EVENT_HIGH_FALL_DAMAGE] = {},
	[EVENT_LOW_FALL_DAMAGE] = {},
	[EVENT_SKILL_POINTS_CHANGED] = {},
	[EVENT_RETICLE_TARGET_CHANGED] = {},
	[EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE] = {},
	[EVENT_STEALTH_STATE_CHANGED] = {},
	[EVENT_CHATTER_BEGIN] = {},
	[EVENT_CHATTER_END] = {},
	[EVENT_TRADE_INVITE_ACCEPTED] = {},
	[EVENT_ZONE_CHANGED] = {},
	[EVENT_COLLECTIBLE_NOTIFICATION_NEW] = {}
}


local function CallEventFunctions(eventCode, ...)
	if #eventToFunctionTable[eventCode] == 0 then return end
	local numOfFuncs = #eventToFunctionTable[eventCode]
	for i = 1, numOfFuncs, 1 do
		eventToFunctionTable[eventCode][i](eventCode, ...)
		--d("Function called!")
	end
end


function LPEventHandler.UnregisterForEvent(eventCode, functionName)
	if eventCode == nil or functionName == nil then return end
	if #eventToFunctionTable[eventCode] ~= 0 then
		local numOfFuncs = #eventToFunctionTable[eventCode]
		local didUnregister = false
		for i = 1, numOfFuncs, 1 do
			if eventToFunctionTable[eventCode][i] == functionName then
				eventToFunctionTable[eventCode][i] = eventToFunctionTable[eventCode][numOfFuncs]
				eventToFunctionTable[eventCode][numOfFuncs] = nil
				didUnregister = true
				numOfFuncs = numOfFuncs - 1
				if numOfFuncs == 0 then
					EVENT_MANAGER:UnregisterForEvent(LorePlay.name, eventCode)
				end
				break
			end
		end
		if not didUnregister then d("Function trying to be removed isn't registered with event "..eventCode) end
	else
		d("No function registered yet for "..eventCode)
	end
end


function LPEventHandler.RegisterForEvent(eventCode, functionName)
	if eventCode == nil or functionName == nil then return end
	if #eventToFunctionTable[eventCode] ~= 0 then
		local numOfFuncs = #eventToFunctionTable[eventCode]
		for i = 1, numOfFuncs, 1 do
			if eventToFunctionTable[eventCode][i] == functionName then
				d("Function already registered for event "..eventCode)
				return
			end
		end
		eventToFunctionTable[eventCode][numOfFuncs + 1] = functionName
	else
		eventToFunctionTable[eventCode][1] = functionName
		EVENT_MANAGER:RegisterForEvent(LorePlay.name, eventCode, CallEventFunctions)
	end
end