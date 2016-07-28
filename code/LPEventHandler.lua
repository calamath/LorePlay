LPEventHandler = {}


eventToFunctionTable = {}


local function CallEventFunctions(eventCode, ...)
	if #eventToFunctionTable[eventCode] == 0 then return end
	local numOfFuncs = #eventToFunctionTable[eventCode]
	for i = 1, numOfFuncs, 1 do
		eventToFunctionTable[eventCode][i](eventCode, ...)
	end
end 


function LPEventHandler.FireEvent(eventCode, ...)
	if not eventToFunctionTable[eventCode] or #eventToFunctionTable[eventCode] == 0 then
		d("Event "..eventCode.." trying to be fired is not yet registered with any functions.")
		return
	end
	local arg = {...}
	zo_callLater(function() CallEventFunctions(eventCode, unpack(arg)) end, 500)
end


function LPEventHandler.UnregisterForLocalEvent(eventCode, functionName)
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
					return true
				end
				return false
			end
		end
		if not didUnregister then d("Function trying to be removed isn't registered with event "..eventCode) end
		return false
	else
		d("No function registered yet for "..eventCode)
		return false
	end
end


function LPEventHandler.UnregisterForEvent(eventCode, functionName)
	local needsUnregistration = LPEventHandler.UnregisterForLocalEvent(eventCode, functionName)
	if needsUnregistration then
		EVENT_MANAGER:UnregisterForEvent(LorePlay.name, eventCode)
	end
end



function LPEventHandler.RegisterForLocalEvent(eventCode, functionName)
	if eventCode == nil or functionName == nil then return end
	if not eventToFunctionTable[eventCode] then
		eventToFunctionTable[eventCode] = {}
	end
	if #eventToFunctionTable[eventCode] ~= 0 then
		local numOfFuncs = #eventToFunctionTable[eventCode]
		for i = 1, numOfFuncs, 1 do
			if eventToFunctionTable[eventCode][i] == functionName then
				d("Function already registered for event "..eventCode)
				return false
			end
		end
		eventToFunctionTable[eventCode][numOfFuncs + 1] = functionName
		return false
	else
		eventToFunctionTable[eventCode][1] = functionName
		return true
	end
end


function LPEventHandler.RegisterForEvent(eventCode, functionName)
	local needsRegistration = LPEventHandler.RegisterForLocalEvent(eventCode, functionName)
	if needsRegistration then
		EVENT_MANAGER:RegisterForEvent(LorePlay.name, eventCode, CallEventFunctions)
	end
end