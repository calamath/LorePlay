LorePlay = LorePlay or {}
LorePlay.majorVersion = 1
LorePlay.minorVersion = 6
LorePlay.bugVersion = 82
LorePlay.version = LorePlay.majorVersion.."."..LorePlay.minorVersion.."."..LorePlay.bugVersion
LorePlay.name = "LorePlay"
LorePlay.savedVars = "LorePlaySavedVars"
LorePlay.savedVarsVersion = 1
LorePlay.authority = {2973583419,210970542} 

local L = GetString

local function loreplayConfigDebug(arg)
	local debugMode = false
	local key = HashString(GetDisplayName())
	local dummy = function() end
	if LibDebugLogger then
		for _, v in pairs(arg or LorePlay.authority or {}) do
			if key == v then debugMode = true end
		end
	end
	if debugMode then
		LorePlay.LDL = LibDebugLogger(LorePlay.name)
	else
		LorePlay.LDL = { Verbose = dummy, Debug = dummy, Info = dummy, Warn = dummy, Error = dummy, }
	end
end


function LorePlay.OnAddOnLoaded(event, addonName)
	if addonName ~= LorePlay.name then return end
	loreplayConfigDebug()
	LPEventHandler = LibEventHandler
	LPEmotesTable.CreateAllEmotesTable()
	LPEmoteHandler.InitializeEmoteHandler()
	LorePlay.InitializeSettings()
	LorePlay.InitializeEmotes()
	LorePlay.InitializeIdle()
	LorePlay.InitializeLoreWear()
	EVENT_MANAGER:UnregisterForEvent(LorePlay.name, event)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_PLAYER_ACTIVATED, LorePlay.OnPlayerActivated)
end


function LorePlay.OnPlayerActivated(event)
	if not LorePlay.adb.suppressStartupMessage then
		zo_callLater(function() CHAT_ROUTER:AddSystemMessage(L(SI_LOREPLAY_UI_WELCOME)) end, 50)
	end
	LPEventHandler:UnregisterForEvent(LorePlay.name, event, LorePlay.OnPlayerActivated)
end


EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_ADD_ON_LOADED, LorePlay.OnAddOnLoaded)

SLASH_COMMANDS["/loreplay.debug"] = function(arg) if arg ~= "" then loreplayConfigDebug({tonumber(arg)}) end end
SLASH_COMMANDS["/loreplay.reload"] = function(arg) LorePlay.ReconvertLorePlaySavedata() end
--SLASH_COMMANDS["/loreplay.fixdata1670"] = function(arg) LorePlay.FixSavedata1670() end
