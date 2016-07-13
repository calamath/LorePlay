LorePlay = {}
LorePlay.majorVersion = 1
LorePlay.minorVersion = 2
LorePlay.bugVersion = 1
LorePlay.version = LorePlay.majorVersion.."."..LorePlay.minorVersion.."."..LorePlay.bugVersion
LorePlay.name = "LorePlay"
LorePlay.player = "player"


function LorePlay.OnAddOnLoaded(event, addonName)
	if addonName ~= LorePlay.name then return end
	LorePlay.InitializeSettings()
    LorePlay.InitializeEmotes()
    LorePlay.InitializeIdle()
    EVENT_MANAGER:UnregisterForEvent(LorePlay.name, event)
end


function LorePlay.OnPlayerActivated(event)
	zo_callLater(function() CHAT_SYSTEM:AddMessage("Welcome to LorePlay, Soulless One!") end, 50)
	EVENT_MANAGER:UnregisterForEvent(LorePlay.name, event)
end


EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_ADD_ON_LOADED, LorePlay.OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_PLAYER_ACTIVATED, LorePlay.OnPlayerActivated)