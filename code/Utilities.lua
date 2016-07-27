LPUtilities = {}


EVENT_ON_SMART_EMOTE = "EVENT_ON_SMART_EMOTE"


function LPUtilities.DidPlayerMove(currentPlayerX, currentPlayerY)
	local newX, newY = GetMapPlayerPosition(LorePlay.player)
	if newX ~= currentPlayerX or newY ~= currentPlayerY then
		return newX, newY, true
	end
	return newX, newY, false
end