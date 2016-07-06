LorePlay = {}
LorePlay.version = 1
--LorePlay.savedVariables = ZO_SavedVars:New("LorePlaySavedVars", LorePlay.version, nil, {})
LorePlay.name = "LorePlay"
LorePlay.player = "player"


function LorePlay.OnAddOnLoaded(event, addonName)
	-- The goal for this is to initialize chat
	if addonName ~= LorePlay.name then return end
	LorePlay.InitializeChat()
    LorePlay.InitializeEmotes()
    EVENT_MANAGER:UnregisterForEvent(LorePlay.name, event)
	--[[
	if addonName == LorePlay.name then
    	LorePlay.InitializeChat()
    	LorePlay.InitializeEmotes()
  	end
  	]]--
end


function LorePlay.OnPlayerActivated(event)
	CHAT_SYSTEM:SetChannel(CHAT_CHANNEL_ZONE_LANGUAGE_1)
	zo_callLater(function() CHAT_SYSTEM:AddMessage("Welcome to LorePlay, Soulless One!") end, 50)
	EVENT_MANAGER:UnregisterForEvent(LorePlay.name, event)
end


EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_ADD_ON_LOADED, LorePlay.OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_PLAYER_ACTIVATED, LorePlay.OnPlayerActivated)