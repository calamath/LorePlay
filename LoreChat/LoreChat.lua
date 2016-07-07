local LoreChat = LorePlay
LoreChat.tabName = "|c8c7037LoreChat"
local tabs = {}


--[[ CREATE A FUNCTION FOR SETTINGS ON WHETHER TO ENABLE OR DISABLE ZONE IN LORECHAT TAB ]] --
function LoreChat.UpdateChannelTypesForTab(containerNumber, tabIndex)
	-- Recycling English Zone as the Roleplay/LoreChat tab since not popular
	tabs[tabIndex].isEnZoneChecked 
		= IsChatContainerTabCategoryEnabled(containerNumber, tabIndex, CHAT_CATEGORY_ZONE_ENGLISH)
	tabs[tabIndex].isZoneChecked 
		= IsChatContainerTabCategoryEnabled(containerNumber, tabIndex, CHAT_CATEGORY_ZONE)
	tabs[tabIndex].isSayChecked 
		= IsChatContainerTabCategoryEnabled(containerNumber, tabIndex, CHAT_CATEGORY_SAY)
	tabs[tabIndex].isTellChecked 
		= IsChatContainerTabCategoryEnabled(containerNumber, tabIndex, CHAT_CATEGORY_WHISPER_INCOMING)
	tabs[tabIndex].isYellChecked 
		= IsChatContainerTabCategoryEnabled(containerNumber, tabIndex, CHAT_CATEGORY_YELL)
	tabs[tabIndex].isNPCChecked 
		= IsChatContainerTabCategoryEnabled(containerNumber, tabIndex, CHAT_CATEGORY_MONSTER_SAY)
end


function LoreChat.UpdateTabInfo(containerNumber)
	local numContainerTabs = GetNumChatContainerTabs(containerNumber)

	for tabIndex = 1, numContainerTabs, 1 do
		tabs[tabIndex] = {}
		tabs[tabIndex].name, tabs[tabIndex].isLocked, 
		tabs[tabIndex].isInteractable, tabs[tabIndex].isCombatLog,
		tabs[tabIndex].areTimestampsEnabled = GetChatContainerTabInfo(1, tabIndex)
		LoreChat.UpdateChannelTypesForTab(containerNumber, tabIndex)
	end
end


function LoreChat.DoesLoreChatTabExist(containerNumber)
	local numContainerTabs = GetNumChatContainerTabs(containerNumber)
	-- Basic checks that should be good enough to not conflict with other's addons
	for tabIndex = 1, numContainerTabs, 1 do
		if (tabs[tabIndex].name == LoreChat.tabName) then
			return true
		end
	end
	return false
end


function LoreChat.AddChatChannelSwitch(desiredCommandAlias, existingCommand)
	CHAT_SYSTEM.switchLookup[desiredCommandAlias] = CHAT_SYSTEM.switchLookup[existingCommand]
end


--[[ Zone OFF by default, EnZone ON be default]]
function LoreChat.SetLoreChatTabSettings(containerNumber)
	local numContainerTabs = GetNumChatContainerTabs(containerNumber)
	for tabIndex = 1, numContainerTabs, 1 do
		local loreTab = tabs[tabIndex]
		if loreTab.name == LoreChat.tabName then
			if not loreTab.isEnZoneChecked then
				SetChatContainerTabCategoryEnabled(containerNumber, tabIndex, CHAT_CATEGORY_ZONE_ENGLISH, true)
			end 
			if loreTab.isZoneChecked then
				SetChatContainerTabCategoryEnabled(containerNumber, tabIndex, CHAT_CATEGORY_ZONE, false)
			end
			if not loreTab.isSayChecked then
				SetChatContainerTabCategoryEnabled(containerNumber, tabIndex, CHAT_CATEGORY_SAY, true)
			end
			if not loreTab.isTellChecked then
				SetChatContainerTabCategoryEnabled(containerNumber, tabIndex, CHAT_CATEGORY_WHISPER_INCOMING, true)
			end
			if not loreTab.isYellChecked then
				SetChatContainerTabCategoryEnabled(containerNumber, tabIndex, CHAT_CATEGORY_YELL, true)
			end
			if not loreTab.isNPCChecked then
				SetChatContainerTabCategoryEnabled(containerNumber, tabIndex, CHAT_CATEGORY_MONSTER_SAY, true)
			end
			break
		end
	end
end


-- Function to enforce certain features for the LoreChat tab, such as EnZone and Say channels being checked
function LoreChat.ConfigureLoreChat(containerNumber)
	LoreChat.SetLoreChatTabSettings(containerNumber)
	local channelInfo = ZO_ChatSystem_GetChannelInfo()
	channelInfo[CHAT_CHANNEL_ZONE_LANGUAGE_1].name = "Roleplay"
	--ResetChatCategoryColorToDefault(CHAT_CATEGORY_CODE)
	SetChatCategoryColor(CHAT_CATEGORY_ZONE_ENGLISH, .55, .44, .21)
	LoreChat.AddChatChannelSwitch("/rp", "/enzone")
	LoreChat.AddChatChannelSwitch("/roleplay", "/enzone")
	LoreChat.AddChatChannelSwitch("/lorechat", "/enzone")
	LoreChat.AddChatChannelSwitch("/loreplay", "/enzone")
end


function LoreChat.ShiftChatTabs(containerNumber)
	local numContainerTabs = GetNumChatContainerTabs(containerNumber)
	local nextTab

	for currTab = (numContainerTabs-1), 1, -1 do
		nextTab = (currTab + 1)
		-- "Transfer" exchanges tabs, therefore bubbling LoreChat to the front
		TransferChatContainerTab(containerNumber, currTab, containerNumber, nextTab)
	end
	LoreChat.UpdateTabInfo(containerNumber)
end


function LoreChat.CreateLoreChatTab(containerNumber)
	AddChatContainerTab(containerNumber, LoreChat.tabName, false)
	LoreChat.ShiftChatTabs(containerNumber)
	LoreChat.ConfigureLoreChat(containerNumber)
end


function LoreChat.InitializeChat()
	-- Passing in 1 to just update the primary chat container for our purposes
	LoreChat.UpdateTabInfo(1)
	
	if (not LoreChat.DoesLoreChatTabExist(1)) then
		LoreChat.CreateLoreChatTab(1)
	elseif(LoreChat.DoesLoreChatTabExist(1)) then
		LoreChat.ConfigureLoreChat(1)
	end
end


LorePlay = LoreChat