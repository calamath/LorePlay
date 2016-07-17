LPEventHandler = {}

eventToFunctionTable = {
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
	[EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE] = {}
}



local function CallEventFunctions(eventCode, ...)
	if #eventToFunctionTable[eventCode] == nil then return end
	local numOfFuncs = #eventToFunctionTable[eventCode]
	--local arg = {...}
	for i = 1, numOfFuncs, 1 do
		eventToFunctionTable[eventCode][i](eventCode, ...)
		--d("Function called!")
	end
end



function LPEventHandler.UnregisterForEvent(eventCode, functionName)
	if eventCode == nil or functionName == nil then return end
	if #eventToFunctionTable[eventCode] ~= nil then
		local numOfFuncs = #eventToFunctionTable[eventCode]
		local didUnregister = false
		for i = 1, numOfFuncs, 1 do
			if eventToFunctionTable[eventCode][i] == functionName then
				eventToFunctionTable[eventCode][i] = eventToFunctionTable[eventCode][numOfFuncs]
				eventToFunctionTable[eventCode][numOfFuncs] = nil
				didUnregister = true
				break
			end
		end
		if not didUnregister then d("No "..tostring(functionName).." for event "..eventCode) end
	else
		d("No function registered yet for "..eventCode)
	end
end


function LPEventHandler.RegisterForEvent(eventCode, functionName)
	if eventCode == nil or functionName == nil then return end
	if #eventToFunctionTable[eventCode] ~= nil then
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
	end
end



EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_PLAYER_NOT_SWIMMING, CallEventFunctions)
EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_MOUNTED_STATE_CHANGED, CallEventFunctions)
EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_PLAYER_COMBAT_STATE, CallEventFunctions)
EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_LEVEL_UPDATE, CallEventFunctions)
EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_POWER_UPDATE, CallEventFunctions)
EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_TRADE_CANCELED, CallEventFunctions)
EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_TRADE_SUCCEEDED, CallEventFunctions)
EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_HIGH_FALL_DAMAGE, CallEventFunctions)
EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_LOW_FALL_DAMAGE, CallEventFunctions)
EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_SKILL_POINTS_CHANGED, CallEventFunctions)
EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_RETICLE_TARGET_CHANGED, CallEventFunctions)
EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE, CallEventFunctions)