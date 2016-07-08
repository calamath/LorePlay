local SmartEmotes = LorePlay

local EVENT_STARTUP = "EVENT_STARTUP"
local EVENT_POWER_UPDATE_STAMINA = "EVENT_POWER_UPDATE_STAMINA"
local EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND = "EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND"
local EVENT_RETICLE_TARGET_CHANGED_TO_EPIC = "EVENT_RETICLE_TARGET_CHANGED_TO_EPIC"
local EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME = "EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME"
local EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL = "EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL"
--local emotes, eventName, duration = "Emotes", "EventName", "Duration"
local defaultEmotes
local defaultEmotesByRegion
local zoneToRegionEmotes
local defaultEmotesByCity
local defaultEmotesForDungeons
local eventTTLEmotes
local eventLatchedEmotes
local lastEventTimeStamp
local existsPreviousEvent
local lastLatchedEvent
local emoteFromLatched
local emoteFromTTL = {}
local playerTitles = {
	["Emperor"] = "Emperor",
	["Empress"] = "Empress",
	["Former Emperor"] = "Former Emperor",
	["Former Empress"] = "Former Empress",
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


function SmartEmotes.PerformSmartEmote()
	local name, UIMapType, MapContentType, _ = GetMapInfo(GetCurrentMapIndex())

	local randomNumber
	local smartEmoteIndex
	if eventLatchedEmotes["isEnabled"] then
		randomNumber = math.random(#emoteFromLatched["Emotes"])
		smartEmoteIndex = emoteFromLatched["Emotes"][randomNumber]
	elseif eventTTLEmotes["isEnabled"] then
		randomNumber = math.random(#emoteFromTTL["Emotes"])
		smartEmoteIndex = emoteFromTTL["Emotes"][randomNumber]
	else
		SmartEmotes.UpdateDefaultEmotesTable()
		randomNumber = math.random(#defaultEmotes["Emotes"])
		smartEmoteIndex = defaultEmotes["Emotes"][randomNumber]
	end
	PlayEmoteByIndex(smartEmoteIndex)
	d("Location: "..GetPlayerLocationName())
	d("Name: "..name.." UIMapType: "..UIMapType.." MapContentType: "..MapContentType)
	d("Active zone name: "..GetPlayerActiveZoneName())
end


function SmartEmotes.DisableTTLEmotes()
	if eventTTLEmotes["isEnabled"] then
		eventTTLEmotes["isEnabled"] = false
	end
end


function SmartEmotes.CheckToDisableTTLEmotes()
	local now = GetTimeStamp()
	local resetDurInSecs = emoteFromTTL["Duration"]/1000
	if GetDiffBetweenTimeStamps(now, lastEventTimeStamp) >= resetDurInSecs then
		SmartEmotes.DisableTTLEmotes()
	end
end


function SmartEmotes.UpdateLatchedEmoteTable(eventCode)
	if eventCode == nil then return end
	if eventLatchedEmotes[eventCode] == nil then return end
	emoteFromLatched = eventLatchedEmotes[eventCode]
	if not eventLatchedEmotes["isEnabled"] then
		eventLatchedEmotes["isEnabled"] = true
	end
end


--[[ Make the type of location be influential in what happens? ]]--
function SmartEmotes.UpdateTTLEmoteTable(eventCode)
	if eventCode == nil then return end
	if eventTTLEmotes[eventCode] == nil then return end
	lastEventTimeStamp = GetTimeStamp()
	if not eventTTLEmotes["isEnabled"] then 
		eventTTLEmotes["isEnabled"] = true
	end
	emoteFromTTL = eventTTLEmotes[eventCode]
	zo_callLater(SmartEmotes.CheckToDisableTTLEmotes, eventTTLEmotes[eventCode]["Duration"])
end


function SmartEmotes.CreateEmotesByRegionTable()
	defaultEmotesByRegion = {
		["ad1"] = { --Summerset
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		},
		["ad2"] = { --Valenwood
			["Emotes"] = {
				[1] = 129 -- thumbs
			}
		},
		["ep1"] = { --Skyrim
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		},
		["ep2"] = { --Morrowind
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		},
		["ep3"] = { --Shadowfen
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		},
		["dc1"] = { --deserty
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		},
		["dc2"] = { --foresty
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		},
		["ch"] = { --Coldharbour
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		},
		["ip"] = { --imperial
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		}
	}
end


function SmartEmotes.CreateZoneToRegionEmotesTable()
	zoneToRegionEmotes = {
		["Auridon"] = defaultEmotesByRegion["ad1"],
		["Grahtwood"] = defaultEmotesByRegion["ad2"],
		["Greenshade"] = defaultEmotesByRegion["ad2"],
		["Khenarthi's Roost"] = defaultEmotesByRegion["ad1"]
	}
end


function SmartEmotes.CreateEmotesByCityTable()
	defaultEmotesByCity = {
		["Elden Root"] = { 
			["Emotes"] = {
				[1] = 203 -- lookup
			}
		},
		["Skywatch"] = { 
			["Emotes"] = {
				[1] = 182 -- dance altmer
			}
		},
		["ep1"] = { --Skyrim
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		},
		["ep2"] = { --Morrowind
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		},
		["ep3"] = { --Shadowfen
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		},
		["dc1"] = { --deserty
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		},
		["dc2"] = { --foresty
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		},
		["ch"] = { --Coldharbour
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		},
		["ip"] = { --imperial
			["Emotes"] = {
				[1] = 25 -- cheer
			}
		}
	}
end


function SmartEmotes.CreateDungeonTable()
	defaultEmotesForDungeons = {
		["Emotes"] = {
			[1] = 63
		}
	}
end



function SmartEmotes.CreateDefaultEmoteTables()
	SmartEmotes.CreateEmotesByRegionTable()
	SmartEmotes.CreateZoneToRegionEmotesTable()
	SmartEmotes.CreateEmotesByCityTable()
	SmartEmotes.CreateDungeonTable()
end

--[[
function SmartEmotes.CreateDefaultEmoteTable()
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
]]--


function SmartEmotes.CreateLatchedEmoteEventTable()
	eventLatchedEmotes = {
		["isEnabled"] = false,

		[EVENT_POWER_UPDATE_STAMINA] = {
			["EventName"] = EVENT_POWER_UPDATE_STAMINA,
			["Emotes"] = {
				[1] = 114
			},
			["Switch"] = function() 
			local currentStam, _, effectiveMaxStam = GetUnitPower(LorePlay.player, POWERTYPE_STAMINA)
			if currentStam < effectiveMaxStam*(.55) then
				return true
			end
			end
		},
		[EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND] = {
			["EventName"] = EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND,
			["Emotes"] = {
				[1] = 70,
				[2] = 72,
				[3] = 8,
				[4] = 137
			}
		},
		[EVENT_RETICLE_TARGET_CHANGED_TO_EPIC] = {
			["EventName"] = EVENT_RETICLE_TARGET_CHANGED_TO_EPIC,
			["Emotes"] = {
				[1] = 142,
				[2] = 67
			}
		},
		[EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME] = {
			["EventName"] = EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME,
			["Emotes"] = {
				[2] = 56,
				[3] = 57,
				[4] = 58
			}
		},
		[EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL] = {
			["EventName"] = EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL,
			["Emotes"] = {
				[1] = 56,
				[2] = 136,
				[3] = 137
			}
		}
	}
end



function SmartEmotes.CreateTTLEmoteEventTable()
	-- Duration in miliseconds that the emote should be playable
	local defaultDuration = 30000
	eventTTLEmotes = {
		["isEnabled"] = false,
		[EVENT_LEVEL_UPDATE] = {
			["EventName"] = EVENT_LEVEL_UPDATE,
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
			["EventName"] = EVENT_PLAYER_NOT_SWIMMING,
			["Emotes"] = {
				[1] = 64,
				--[2] = 215
			},
			["Duration"] = defaultDuration
		},
		[EVENT_STARTUP] = {
			["EventName"] = EVENT_STARTUP,
			["Emotes"] = {
				[1] = 96,
				[2] = 91
			},
			["Duration"] = 2000 --defaultDuration*4
		},
		[EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE] = {
			["EventName"] = EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE,
			["Emotes"] = {
				[1] = 10,
				[2] = 125,
				[3] = 212,
				[4] = 213
			},
			["Duration"] = defaultDuration
		},
		[EVENT_HIGH_FALL_DAMAGE] = {
			["EventName"] = EVENT_HIGH_FALL_DAMAGE,
			["Emotes"] = {
				[1] = 115,
				[3] = 149,
				[4] = 12
			},
			["Duration"] = defaultDuration*(2/3)
		},
		[EVENT_LOW_FALL_DAMAGE] = {
			["EventName"] = EVENT_LOW_FALL_DAMAGE,
			["Emotes"] = {
				[1] = 133,
				[2] = 80,
				[3] = 33
			},
			["Duration"] = defaultDuration/2
		},
		[EVENT_MOUNTED_STATE_CHANGED] = {
			["EventName"] = EVENT_MOUNTED_STATE_CHANGED,
			["Emotes"] = {
				[1] = 91,
				[2] = 110,
				[3] = 203,
				[4] = 80
			},
			["Duration"] = defaultDuration*(2/3)
		},
		[EVENT_PLAYER_COMBAT_STATE] = {
			["EventName"] = EVENT_PLAYER_COMBAT_STATE,
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
			["EventName"] = EVENT_TRADE_SUCCEEDED,
			["Emotes"] = {
				[1] = 151
			},
			["Duration"] = defaultDuration*(2/3)
		},
		[EVENT_TRADE_CANCELED] = {
			["EventName"] = EVENT_TRADE_CANCELED,
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
		[EVENT_SKILL_POINTS_CHANGED] = {
			["EventName"] = EVENT_SKILL_POINTS_CHANGED,
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


function SmartEmotes.IfPlayerInZoneSetDefault(zoneName)
	if zoneToRegionEmotes[zoneName] ~= nil then
		if defaultEmotes ~= zoneToRegionEmotes[zoneName] then
			defaultEmotes = zoneToRegionEmotes[zoneName]
			--SmartEmotes.TryToUpdateDefaultEmotes()
		end
		return true
	end
	return false
end


function SmartEmotes.IfPlayerInCitySetDefault(POI)
	if defaultEmotesByCity[POI] ~= nil then
		if  defaultEmotes ~= defaultEmotesByCity[POI] then
			defaultEmotes = defaultEmotesByCity[POI]
			--SmartEmotes.TryToUpdateDefaultEmotes()
		end
		return true
	end
	return false
end



function SmartEmotes.IfPlayerInDungeonSetDefault(POI, zoneName)
	if defaultEmotesByCity[POI] == nil then
		if zoneToRegionEmotes[zoneName] == nil then
			if defaultEmotesForDungeons ~= defaultEmotes then
				defaultEmotes = defaultEmotesForDungeons
				--SmartEmotes.TryToUpdateDefaultEmotes()
			end 
			return true
		end
	end
	return false
end


-- Here we pass in event codes
function SmartEmotes.DoesEmoteFromLatchedEqualEvent(...)
	if not eventLatchedEmotes["isEnabled"] then return false end
	local arg = {...}
	for i = 1, #arg, 1 do
		if emoteFromLatched["EventName"] == eventLatchedEmotes[arg[i]]["EventName"] then
			return true
		end
	end
	return false
end


-- Here we pass in event codes to check if current latched event equals an incoming latched event.
-- If so, then it's false because that means the last event was the same.
function SmartEmotes.DoesPreviousLatchedEventExist(...)
	if emoteFromLatched == nil then return false end
	local arg = {...}
	for i = 1, #arg, 1 do
		if emoteFromLatched == eventLatchedEmotes[arg[i]] then return false end
	end
	existsPreviousEvent = true
	return existsPreviousEvent
end


function SmartEmotes.SetInitialDefaultEmotes()
	local firstZone = GetPlayerActiveZoneName()
	if zoneToRegionEmotes[firstZone] ~= nil then
		defaultEmotes = zoneToRegionEmotes[firstZone]
	else d("This shouldn't happen")
	end
end


function SmartEmotes.UpdateDefaultEmotesTable()
	local location = GetPlayerLocationName()
	local zoneName = GetPlayerActiveZoneName()
	d("ZONENAME:"..zoneName)
	zo_callLater(function() d("Delayed zone: "..zoneName) end, 15000)
	if SmartEmotes.IfPlayerInCitySetDefault(location) then return
	elseif SmartEmotes.IfPlayerInZoneSetDefault(zoneName) then return
	elseif SmartEmotes.IfPlayerInDungeonSetDefault(location, zoneName) then return
	end
end



--[[
function SmartEmotes.UpdateDefaultEmotesTable_For_EVENT_ZONE_CHANGED(eventCode)
	local location = GetPlayerLocationName()
	local zoneName = GetPlayerActiveZoneName()
	d("ZONENAME:"..zoneName)
	zo_callLater(function() d("Delayed zone: "..zoneName) end, 15000)
	if SmartEmotes.IfPlayerInCitySetDefault(location) then return
	elseif SmartEmotes.IfPlayerInZoneSetDefault(zoneName) then return
	elseif SmartEmotes.IfPlayerInDungeonSetDefault(location, zoneName) then return
	end
end
]]--


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LEVEL_UPDATE(eventCode)
	SmartEmotes.UpdateTTLEmoteTable(eventCode)
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_PLAYER_NOT_SWIMMING(eventCode)
	SmartEmotes.UpdateTTLEmoteTable(eventCode)
end


function SmartEmotes.UpdateTTLEmoteTable_For_FALL_DAMAGE(eventCode)
	SmartEmotes.UpdateTTLEmoteTable(eventCode)
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_PLAYER_COMBAT_STATE(eventCode, inCombat)
	if not inCombat then
		SmartEmotes.UpdateTTLEmoteTable(eventCode)
	end
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_MOUNTED_STATE_CHANGED(eventCode, mounted)
	if not mounted then
		SmartEmotes.UpdateTTLEmoteTable(eventCode)
	end
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE(eventCode, categoryIndex, collectionIndex, bookIndex, guildIndex, skillType, skillIndex, rank, previousXP, currentXP)
	SmartEmotes.UpdateTTLEmoteTable(eventCode)
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_TRADE_SUCCEEDED(eventCode)
	SmartEmotes.UpdateTTLEmoteTable(eventCode)
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


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_TRADE_CANCELED(eventCode)
	SmartEmotes.UpdateTTLEmoteTable(eventCode)
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_SKILL_POINTS_CHANGED(eventCode, pointsBefore, pointsNow, partialPointsBefore, partialPointsNow)
	if emoteFromTTL["EventName"] == eventTTLEmotes[EVENT_LEVEL_UPDATE]["EventName"] then return end
	if partialPointsNow > partialPointsBefore then
		SmartEmotes.UpdateTTLEmoteTable(EVENT_SKILL_POINTS_CHANGED)
	elseif pointsNow > pointsBefore then
		SmartEmotes.UpdateTTLEmoteTable(EVENT_SKILL_POINTS_CHANGED)
	end
end


function SmartEmotes.UpdateLatchedEmoteTable_For_EVENT_RETICLE_TARGET_CHANGED(eventCode)
	if IsUnitPlayer("reticleover") then
		if SmartEmotes.DoesPreviousLatchedEventExist(EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL,
		EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND, EVENT_RETICLE_TARGET_CHANGED_TO_EPIC,
		EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME) then
			lastLatchedEvent = emoteFromLatched["EventName"]
		end
		local unitTitle = GetUnitTitle("reticleover")
		if IsUnitFriend("reticleover") then
			SmartEmotes.UpdateLatchedEmoteTable(EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND)
		elseif playerTitles[unitTitle] ~= nil then
			if GetUnitTitle("player") == playerTitles[unitTitle] then
				SmartEmotes.UpdateLatchedEmoteTable(EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME)
			else SmartEmotes.UpdateLatchedEmoteTable(EVENT_RETICLE_TARGET_CHANGED_TO_EPIC)
			end
		else SmartEmotes.UpdateLatchedEmoteTable(EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL)
		end
	elseif not IsUnitPlayer("reticleover") and 
		SmartEmotes.DoesEmoteFromLatchedEqualEvent(EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL,
		EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND, EVENT_RETICLE_TARGET_CHANGED_TO_EPIC,
		EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME) then
			if existsPreviousEvent and eventLatchedEmotes[lastLatchedEvent].Switch() then
				SmartEmotes.UpdateLatchedEmoteTable(lastLatchedEvent)
			else
				eventLatchedEmotes["isEnabled"] = false
			end
			existsPreviousEvent = false
	end
end


-- Stamina bar
function SmartEmotes.UpdateLatchedEmoteTable_For_EVENT_POWER_UPDATE(eventCode, unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax)
	if unitTag ~= LorePlay.player then return end
	if powerType == POWERTYPE_STAMINA then
		local lowerThreshold = powerEffectiveMax*(.2)
		local upperThreshold = powerEffectiveMax*(.55)
		if powerValue <= lowerThreshold then 
			SmartEmotes.UpdateLatchedEmoteTable(EVENT_POWER_UPDATE_STAMINA)
		elseif powerValue >= upperThreshold 
		and SmartEmotes.DoesEmoteFromLatchedEqualEvent(EVENT_POWER_UPDATE_STAMINA) then
			eventLatchedEmotes["isEnabled"] = false
		end
	end
end


function SmartEmotes.InitializeEmotes()
	SmartEmotes.CreateTTLEmoteEventTable()
	SmartEmotes.CreateLatchedEmoteEventTable()
	--SmartEmotes.CreateDefaultEmoteTable()
	SmartEmotes.CreateDefaultEmoteTables()
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_LEVEL_UPDATE, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LEVEL_UPDATE)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_PLAYER_NOT_SWIMMING, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_PLAYER_NOT_SWIMMING)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_POWER_UPDATE, SmartEmotes.UpdateLatchedEmoteTable_For_EVENT_POWER_UPDATE)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_TRADE_CANCELED, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_TRADE_CANCELED)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_TRADE_SUCCEEDED, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_TRADE_SUCCEEDED)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_HIGH_FALL_DAMAGE, SmartEmotes.UpdateTTLEmoteTable_For_FALL_DAMAGE)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_LOW_FALL_DAMAGE, SmartEmotes.UpdateTTLEmoteTable_For_FALL_DAMAGE)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_SKILL_POINTS_CHANGED, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_SKILL_POINTS_CHANGED)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_RETICLE_TARGET_CHANGED, SmartEmotes.UpdateLatchedEmoteTable_For_EVENT_RETICLE_TARGET_CHANGED)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_MOUNTED_STATE_CHANGED, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_MOUNTED_STATE_CHANGED)
	EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_PLAYER_COMBAT_STATE, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_PLAYER_COMBAT_STATE)
	--EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_ZONE_CHANGED, SmartEmotes.UpdateDefaultEmotesTable_For_EVENT_ZONE_CHANGED)
	--EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_LOOT_RECEIVED, ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_LOOT_RECEIVED)
	SmartEmotes.UpdateTTLEmoteTable(EVENT_STARTUP)
end

LorePlay = SmartEmotes