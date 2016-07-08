LorePlay = {}
LorePlay.version = 1
--LorePlay.savedVariables = ZO_SavedVars:New("LorePlaySavedVars", LorePlay.version, nil, {})
LorePlay.name = "LorePlay"
LorePlay.player = "player"


function LorePlay.OnAddOnLoaded(event, addonName)
	if addonName ~= LorePlay.name then return end
    LorePlay.InitializeEmotes()
    EVENT_MANAGER:UnregisterForEvent(LorePlay.name, event)
end


function LorePlay.OnPlayerActivated(event)
	LorePlay.SetInitialDefaultEmotes()
	zo_callLater(function() CHAT_SYSTEM:AddMessage("Welcome to LorePlay, Soulless One!") end, 50)
	EVENT_MANAGER:UnregisterForEvent(LorePlay.name, event)
end


EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_ADD_ON_LOADED, LorePlay.OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_PLAYER_ACTIVATED, LorePlay.OnPlayerActivated)