-- ImmersiveEmotes expands the way your character traverses the land of Tamriel. Simply press a button
-- of your choosing, and your character will perform smart emotes that are proper for your environment!
-- Did you conquer a mighty daedric creature, or complete an epic trial? You should celebrate with a cheer, or maybe an ale!
-- Did you just swim in a bit of water that was just a tad too cold? You'll certainly have the shivers!

local ImmersiveEmotes = LorePlay
--local emotes = {}
local EVENT_STARTUP = "EVENT_STARTUP"
local EVENT_POWER_UPDATE_STAMINA = "EVENT_POWER_UPDATE_STAMINA"
local EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND = "EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND"
local EVENT_RETICLE_TARGET_CHANGED_TO_EPIC = "EVENT_RETICLE_TARGET_CHANGED_TO_EPIC"
local EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME = "EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME"
local EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL = "EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL"
local defaultEmotes
local eventEmotes
local lastEventTimeStamp
local currSmartEmotes = {}
local currEventTableName
local playerTitles = {
	["Emperor"] = "Emperor",
	["Empress"] = "Empress",
	["Former Emperor"] = "Former Emperor",
	["Former Empress"] = "Former Empress",
	--["Master Wizard"] = "Master Wizard",
	["Ophidian Overlord"] = "Ophidian Overlord",
	["Savior of Nirn"] = "Savior of Nirn",
	["Daedric Lord Slayer"] = "Daedric Lord Slayer",
	["Tamriel Hero"] = "Tamriel Hero"
}


--local myStrings = {}


--[[ USE TO ACHIEVE MASTER LIST IN SAVED VARS
local function StoreMyEmotesIntoSavedVars()
	local emoteString = ""
	local emoteString2 = ""
	local emoteSlashName
	local emoteIndex
	local emoteCategory
	local emoteID
	local emoteDisplayName
	local emoteShowInGamepad
	local HalfOfEmotes = (GetNumEmotes()/2)
	
	for i = 1, HalfOfEmotes, 1 do
		emoteSlashName, emoteCategory, emoteID, 
		emoteDisplayName, emoteShowInGamepad = GetEmoteInfo(i)
		emoteString = emoteString..emoteSlashName..","..emoteCategory..","..i.."\n"
	end

	for i = HalfOfEmotes+1, GetNumEmotes(), 1 do
		emoteSlashName, emoteCategory, emoteID, 
		emoteDisplayName, emoteShowInGamepad = GetEmoteInfo(i)
		emoteString2 = emoteString2..emoteSlashName..","..emoteCategory..","..i.."\n"
	end

	myStrings[1] = emoteString
	myStrings[2] = emoteString2
	LorePlay.savedVariables = ZO_SavedVars:New("LorePlaySavedVars", LorePlay.version, nil, myStrings)
end
]]--


function ImmersiveEmotes.PerformSmartEmote()
	d(GetMapInfo(GetCurrentMapIndex()))
	
	d(GetPlayerLocationName())
	local randomNumber = math.random(#currSmartEmotes["Emotes"])
	local smartEmoteIndex = currSmartEmotes["Emotes"][randomNumber]
	PlayEmoteByIndex(smartEmoteIndex)
end


function ImmersiveEmotes.SetDefaultEmotes()
	currSmartEmotes = defaultEmotes
end


function ImmersiveEmotes.CheckToSwitchToDefaultEmotes()
	-- Some events will override the natural switch to default
	if currSmartEmotes == defaultEmotes then return end
	local now = GetTimeStamp()
	local resetDurInSecs = currSmartEmotes["Duration"]/1000
	--d("Last time stamp: "..lastEventTimeStamp)
	--d("Current time stamp: "..now)
	if GetDiffBetweenTimeStamps(now, lastEventTimeStamp) >= resetDurInSecs then
		ImmersiveEmotes.SetDefaultEmotes()
		--d("This worked!")
		--currSmartEmotes = defaultEmotes
	end
end


--[[ Make the type of location be influential in what happens? ]]--
function ImmersiveEmotes.UpdateSmartEmoteTable(eventCode)
	if eventCode == nil then return end
	if eventEmotes[eventCode] == nil then return end
	--d(eventCode)
	lastEventTimeStamp = GetTimeStamp()
	--local randomNumber = math.random(#eventEmotes[eventCode])
	currSmartEmotes = eventEmotes[eventCode]
	zo_callLater(ImmersiveEmotes.CheckToSwitchToDefaultEmotes, eventEmotes[eventCode]["Duration"])
	--zo_callLater(ImmersiveEmotes.SetDefaultEmotes, eventEmotes[eventCode]["Duration"])
end


function ImmersiveEmotes.CreateDefaultEmoteTable()
	defaultEmotes = {
		["Emotes"] = {
			[1] = 203,
			[2] = 54,
			[3] = 83,
			[4] = 91,
			[5] = 191,
			[6] = 40,
			[7] = 110,
			[8] = 177,
			[9] = 178,
			[10] = 174,
			[11] = 201,
			[12] = 138,
			[13] = 99,
			[14] = 121
		}
	}
end


function ImmersiveEmotes.CreateEmoteEventTable()
	-- Duration in miliseconds that the emote should be playable
	local defaultDuration = 30000
	--eventEmotes[EVENT_LOOT_RECEIVED] = {}
	--eventEmotes[EVENT_LOOT_RECEIVED] = emotes[EMOTE_CATEGORY_CHEERS_AND_JEERS]
	eventEmotes = {
		[EVENT_LEVEL_UPDATE] = {
			["EventName"] = "EVENT_LEVEL_UPDATE",
			["Emotes"] = {
				[1] = 52,
				[2] = 8,
				[3] = 82,
				[4] = 165,
				[5] = 25
			},
			["Duration"] = defaultDuration*4
		},
		[EVENT_PLAYER_NOT_SWIMMING] = {
			["EventName"] = "EVENT_PLAYER_NOT_SWIMMING",
			["Emotes"] = {
				[1] = 64,
				--[2] = 215
			},
			["Duration"] = defaultDuration
		},
		[EVENT_STARTUP] = {
			["EventName"] = "EVENT_STARTUP",
			["Emotes"] = {
				[1] = 96,
				[2] = 91
			},
			["Duration"] = defaultDuration*4
		},
		[EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE] = {
			["EventName"] = "EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE",
			["Emotes"] = {
				[1] = 10,
				[2] = 125,
				[3] = 212,
				[4] = 213
			},
			["Duration"] = defaultDuration
		},
		[EVENT_POWER_UPDATE_STAMINA] = {
			["EventName"] = "EVENT_POWER_UPDATE_STAMINA",
			["Emotes"] = {
				[1] = 114
			},
			["Duration"] = defaultDuration
		},
		[EVENT_HIGH_FALL_DAMAGE] = {
			["EventName"] = "EVENT_HIGH_FALL_DAMAGE",
			["Emotes"] = {
				[1] = 115,
				[3] = 149,
				[4] = 12
			},
			["Duration"] = defaultDuration*(2/3)
		},
		[EVENT_LOW_FALL_DAMAGE] = {
			["EventName"] = "EVENT_LOW_FALL_DAMAGE",
			["Emotes"] = {
				[1] = 133,
				[2] = 80,
				[3] = 33
			},
			["Duration"] = defaultDuration/2
		},
		[EVENT_MOUNTED_STATE_CHANGED] = {
			["EventName"] = "EVENT_MOUNTED_STATE_CHANGED",
			["Emotes"] = {
				[1] = 91,
				[2] = 110,
				[3] = 203,
				[4] = 80
			},
			["Duration"] = defaultDuration*(2/3)
		},
		[EVENT_PLAYER_COMBAT_STATE] = {
			["EventName"] = "EVENT_PLAYER_COMBAT_STATE",
			["Emotes"] = {
				[1] = 78,
				[2] = 162,
				[3] = 81,
				[4] = 179,
				[5] = 52,
				[6] = 119,
				[7] = 200
			},
			["Duration"] = defaultDuration*(2/3)
		},
		[EVENT_TRADE_SUCCEEDED] = {
			["EventName"] = "EVENT_TRADE_SUCCEEDED",
			["Emotes"] = {
				[1] = 151
			},
			["Duration"] = defaultDuration*(2/3)
		},
		[EVENT_TRADE_CANCELED] = {
			["EventName"] = "EVENT_TRADE_CANCELED",
			["Emotes"] = {
				[1] = 149,
				[2] = 153,
				[3] = 170,
				[4] = 54,
				[5] = 81,
				[6] = 156,
				[7] = 32,
				[8] = 62
			},
			["Duration"] = defaultDuration*(2/3)
		},
		[EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND] = {
			["EventName"] = "EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND",
			["Emotes"] = {
				[1] = 70,
				[2] = 72,
				[3] = 8,
				[4] = 137
			},
			["Duration"] = defaultDuration/2
		},
		[EVENT_RETICLE_TARGET_CHANGED_TO_EPIC] = {
			["EventName"] = "EVENT_RETICLE_TARGET_CHANGED_TO_EPIC",
			["Emotes"] = {
				[1] = 142,
				[2] = 67
			},
			["Duration"] = defaultDuration/3
		},
		[EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME] = {
			["EventName"] = "EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME",
			["Emotes"] = {
				[2] = 56,
				[3] = 57,
				[4] = 58
			},
			["Duration"] = defaultDuration/3
		},
		[EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL] = {
			["EventName"] = "EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL",
			["Emotes"] = {
				[1] = 56,
				[2] = 136,
				[3] = 137
			},
			["Duration"] = defaultDuration/3
		},
		[EVENT_SKILL_POINTS_CHANGED] = {
			["EventName"] = "EVENT_SKILL_POINTS_CHANGED",
			["Emotes"] = {
				[1] = 104,
				[2] = 52,
				[3] = 98,
				[4] = 165
			},
			["Duration"] = defaultDuration
		}
	}
end


function ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_LEVEL_UPDATE(eventCode)
	ImmersiveEmotes.UpdateSmartEmoteTable(eventCode)
end


function ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_PLAYER_NOT_SWIMMING(eventCode)
	ImmersiveEmotes.UpdateSmartEmoteTable(eventCode)
end


function ImmersiveEmotes.UpdateSmartEmoteTable_For_FALL_DAMAGE(eventCode)
	ImmersiveEmotes.UpdateSmartEmoteTable(eventCode)
end


function ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_PLAYER_COMBAT_STATE(eventCode, inCombat)
	if not inCombat then
		ImmersiveEmotes.UpdateSmartEmoteTable(eventCode)
	end
end


function ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_MOUNTED_STATE_CHANGED(eventCode, mounted)
	if not mounted then
		ImmersiveEmotes.UpdateSmartEmoteTable(eventCode)
	end
end


function ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE(eventCode, categoryIndex, collectionIndex, bookIndex, guildIndex, skillType, skillIndex, rank, previousXP, currentXP)
	ImmersiveEmotes.UpdateSmartEmoteTable(eventCode)
end


function ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_TRADE_SUCCEEDED(eventCode)
	ImmersiveEmotes.UpdateSmartEmoteTable(eventCode)
end


--[[ TODO
function ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_LOOT_RECEIVED(eventCode, receivedBy, itemName, quantity, itemSound, lootType, self, isPickpocketLoot, questItemIcon, itemId)
	--if itemName == "Rough Beech" or itemName == "Ta" then d("You found an item!") end
	--local name,col,typID,id,qual,levelreq,enchant,ench1,ench2,un1,un2,un3,un4,un5,un6,un7,un8,un9,style,un10,bound,charge,un11=ZO_LinkHandler_ParseLink(itemName)
	local un,un8,col,itemID,subtype,reqLevel,enchID,enchst,enchlvl,enchID2,enchst2,enchlvl2,un1,un2,un3,un4,un5,un6,style,crafted,bound,stolen,charge,potEff=ZO_LinkHandler_ParseLink(itemName)
	--id = tonumber(id)
	--name = zo_strformat(SI_TOOLTIP_ITEM_NAME, name)
	d("itemId: "..itemId)
	d("ID: "..itemID)
	d("Col: "..col)
	d("ReqLevel: "..reqLevel)
	d("subtype: "..subtype)
	d("Style: "..style)
	--d("The item ID is: "..itemId)
	--d(receivedBy.." "..itemName.." "..quantity.." "..lootType.." "..questItemIcon.." "..itemId)
	--ImmersiveEmotes.UpdateSmartEmoteTable(eventCode)
end
]]--


function ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_TRADE_CANCELED(eventCode)
	ImmersiveEmotes.UpdateSmartEmoteTable(eventCode)
end


function ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_SKILL_POINTS_CHANGED(eventCode, pointsBefore, pointsNow, partialPointsBefore, partialPointsNow)
	if currSmartEmotes["EventName"] == eventEmotes[EVENT_LEVEL_UPDATE]["EventName"] then return end
	if partialPointsNow > partialPointsBefore then
		ImmersiveEmotes.UpdateSmartEmoteTable(EVENT_SKILL_POINTS_CHANGED)
	elseif pointsNow > pointsBefore then
		ImmersiveEmotes.UpdateSmartEmoteTable(EVENT_SKILL_POINTS_CHANGED)
	end
end


function ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_RETICLE_TARGET_CHANGED(eventCode)
	if IsUnitPlayer("reticleover") then
		local unitTitle = GetUnitTitle("reticleover")
		if IsUnitFriend("reticleover") then
			ImmersiveEmotes.UpdateSmartEmoteTable(EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND)
		elseif playerTitles[unitTitle] ~= nil then
			if GetUnitTitle("player") == playerTitles[unitTitle] then
				ImmersiveEmotes.UpdateSmartEmoteTable(EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME)
			else ImmersiveEmotes.UpdateSmartEmoteTable(EVENT_RETICLE_TARGET_CHANGED_TO_EPIC)
			end
		else ImmersiveEmotes.UpdateSmartEmoteTable(EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL)
		end
	elseif not IsUnitPlayer("reticleover") and currSmartEmotes["EventName"] == eventEmotes[EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND]["EventName"]
		or currSmartEmotes["EventName"] == eventEmotes[EVENT_RETICLE_TARGET_CHANGED_TO_EPIC]["EventName"]
		or currSmartEmotes["EventName"] == eventEmotes[EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME]["EventName"]
		or currSmartEmotes["EventName"] == eventEmotes[EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL]["EventName"] then
		ImmersiveEmotes.SetDefaultEmotes()
	end
end


-- Stamina bar
function ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_POWER_UPDATE(eventCode, unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax)
	if unitTag ~= LorePlay.player then return end
	if powerType == POWERTYPE_STAMINA then
		local lowerThreshold = powerEffectiveMax*(.2)
		local upperThreshold = powerEffectiveMax*(.5)
		if powerValue <= lowerThreshold then 
			ImmersiveEmotes.UpdateSmartEmoteTable(EVENT_POWER_UPDATE_STAMINA)
		elseif powerValue >= upperThreshold and currSmartEmotes["EventName"] == eventEmotes[EVENT_POWER_UPDATE_STAMINA]["EventName"] then
			ImmersiveEmotes.SetDefaultEmotes()
		end
	end
end


function ImmersiveEmotes.InitializeEmotes()
	ImmersiveEmotes.CreateEmoteEventTable()
	ImmersiveEmotes.CreateDefaultEmoteTable()
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_LEVEL_UPDATE, ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_LEVEL_UPDATE)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_PLAYER_NOT_SWIMMING, ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_PLAYER_NOT_SWIMMING)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_POWER_UPDATE, ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_POWER_UPDATE)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_TRADE_CANCELED, ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_TRADE_CANCELED)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_TRADE_SUCCEEDED, ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_TRADE_SUCCEEDED)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_HIGH_FALL_DAMAGE, ImmersiveEmotes.UpdateSmartEmoteTable_For_FALL_DAMAGE)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_LOW_FALL_DAMAGE, ImmersiveEmotes.UpdateSmartEmoteTable_For_FALL_DAMAGE)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_SKILL_POINTS_CHANGED, ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_SKILL_POINTS_CHANGED)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_RETICLE_TARGET_CHANGED, ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_RETICLE_TARGET_CHANGED)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE, ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_MOUNTED_STATE_CHANGED, ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_MOUNTED_STATE_CHANGED)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_PLAYER_COMBAT_STATE, ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_PLAYER_COMBAT_STATE)
	--EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_LOOT_RECEIVED, ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_LOOT_RECEIVED)
	ImmersiveEmotes.UpdateSmartEmoteTable(EVENT_STARTUP)
end

LorePlay = ImmersiveEmotes