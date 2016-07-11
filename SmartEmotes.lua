local SmartEmotes = LorePlay

local EVENT_STARTUP = "EVENT_STARTUP"
local EVENT_POWER_UPDATE_STAMINA = "EVENT_POWER_UPDATE_STAMINA"
local EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND = "EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND"
local EVENT_RETICLE_TARGET_CHANGED_TO_EPIC = "EVENT_RETICLE_TARGET_CHANGED_TO_EPIC"
local EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME = "EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME"
local EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL = "EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL"
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
--[[ IDLE EMOTES
local idleCounter = 0 --reset if reaches 6 (2 secs each tick)
local isPlayerIdle = false
]]--
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

SmartEmotes.isPlayerInCombat = false
SmartEmotes.isSmartEmoting = false


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
	SmartEmotes.isSmartEmoting = true
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
				[1] = 191,
				[2] = 191,
				[3] = 210,
				[4] = 174,
				[5] = 174,
				[6] = 11,
				[7] = 121,
				[8] = 38,
				[9] = 52,
				[10] = 9,
				[11] = 91,
				[12] = 210
			}
		},
		["ad2"] = { --Valenwood
			["Emotes"] = {
				[1] = 210,
				[2] = 119,
				[3] = 102,
				[4] = 201,
				[5] = 202,
				[6] = 99,
				[7] = 121,
				[8] = 38,
				[9] = 52,
				[10] = 104,
				[11] = 91,
				[12] = 210,
				[13] = 123,
				[14] = 104
			}
		},
		["ep1"] = { --Skyrim
			["Emotes"] = {
				[1] = 8,
				[2] = 169,
				[3] = 64,
				[4] = 215,
				[5] = 52,
				[6] = 38,
				[7] = 9,
				[8] = 64,
				[9] = 215,
				[10] = 104
			}
		},
		["ep2"] = { --Morrowind
			["Emotes"] = {
				[1] = 52,
				[2] = 201,
				[3] = 169,
				[4] = 178,
				[5] = 120,
				[6] = 91,
				[7] = 9,
				[8] = 110
			}
		},
		["ep3"] = { --Shadowfen
			["Emotes"] = {
				[1] = 52,
				[2] = 201,
				[3] = 169,
				[4] = 178,
				[5] = 202,
				[6] = 38,
				[7] = 9,
				[8] = 91,
				[9] = 104
			}
		},
		["dc1"] = { --deserty
			["Emotes"] = {
				[1] = 52,
				[2] = 201,
				[3] = 11,
				[4] = 110,
				[5] = 122,
				[6] = 91,
				[7] = 38,
				[8] = 9,
				[9] = 91,
				[10] = 95,
				[11] = 95,
				[12] = 110
			}
		},
		["dc2"] = { --foresty
			["Emotes"] = {
				[1] = 52,
				[2] = 119,
				[3] = 201,
				[4] = 99,
				[5] = 121,
				[6] = 38,
				[7] = 9,
				[8] = 91,
				[9] = 123,
				[10] = 104
			}
		},
		["ch"] = { --Coldharbour
			["Emotes"] = {
				[1] = 63,
				[2] = 27,
				[3] = 122,
				[4] = 52,
				[5] = 102,
				[6] = 104
			}
		},
		["ip"] = { --imperial
			["Emotes"] = {
				[1] = 52,
				[2] = 34,
				[3] = 148,
				[4] = 110,
				[5] = 38,
				[6] = 9,
				[7] = 91
			}
		},
		["other"] = { --other
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
				[14] = 121,
				[15] = 52,
				[16] = 9
			}
		}
	}
end


function SmartEmotes.CreateZoneToRegionEmotesTable()
	zoneToRegionEmotes = {
		["Auridon"] = defaultEmotesByRegion["ad1"],
		["Grahtwood"] = defaultEmotesByRegion["ad2"],
		["Greenshade"] = defaultEmotesByRegion["ad2"],
		["Khenarthi's Roost"] = defaultEmotesByRegion["ad1"],
		["Malabal Tor"] = defaultEmotesByRegion["ad2"],
		["Reaper's March"] = defaultEmotesByRegion["ad2"],
		["Alik'r Desert"] = defaultEmotesByRegion["dc1"],
		["Bangkorai"] = defaultEmotesByRegion["dc1"],
		["Betnikh"] = defaultEmotesByRegion["dc2"],
		["Glenumbra"] = defaultEmotesByRegion["dc2"],
		["Rivenspire"] = defaultEmotesByRegion["dc2"],
		["Stormhaven"] = defaultEmotesByRegion["dc2"],
		["Stros M'Kai"] = defaultEmotesByRegion["dc1"],
		["Bal Foyen"] = defaultEmotesByRegion["ep2"],
		["Bleakrock Isle"] = defaultEmotesByRegion["ep2"],
		["Deshaan"] = defaultEmotesByRegion["ep2"],
		["Eastmarch"] = defaultEmotesByRegion["ep1"],
		["The Rift"] = defaultEmotesByRegion["ep1"],
		["Shadowfen"] = defaultEmotesByRegion["ep3"],
		["Stonefalls"] = defaultEmotesByRegion["ep2"],
		["Coldharbour"] = defaultEmotesByRegion["ch"],
		["Craglorn"] = defaultEmotesByRegion["other"],
		["Cyrodiil"] = defaultEmotesByRegion["ip"],
		["Gold Coast"] = defaultEmotesByRegion["other"],
		["Hew's Bane"] = defaultEmotesByRegion["other"],
		["Murkmire"] = defaultEmotesByRegion["ep3"],
		["Bangkorai"] = defaultEmotesByRegion["dc1"],
		["Wrothgar"] = defaultEmotesByRegion["other"],
	}
end


function SmartEmotes.CreateEmotesByCityTable()
	defaultEmotesByCity = {
		["Elden Root"] = { 
			["Emotes"] = {
				[1] = 203,
				[2] = 203,
				[3] = 203,
				[4] = 203,
				[5] = 177,
				[6] = 174,
				[7] = 202,
				[8] = 99,
				[9] = 8,
				[10] = 52

			}
		},
		["Skywatch"] = { 
			["Emotes"] = {
				[1] = 174,
				[2] = 8,
				[3] = 38,
				[4] = 191,
				[5] = 210,
				[6] = 11,
				[7] = 121,
				[8] = 52,
				[9] = 9,
				[10] = 91
			}
		},
		["Mournhold"] = {
			["Emotes"] = {
				[1] = 174,
				[2] = 8,
				[3] = 52,
				[4] = 52,
				[5] = 203,
				[6] = 203,
				[7] = 121

			}
		},
		["Windhelm"] = { 
			["Emotes"] = {
				[1] = 8,
				[2] = 139,
				[3] = 163,
				[4] = 169,
				[5] = 5,
				[6] = 79,
				[7] = 209,
				[8] = 64,
				[9] = 174,
				[10] = 52
			}
		},
		["Riften"] = { 
			["Emotes"] = {
				[1] = 8,
				[2] = 139,
				[3] = 163,
				[4] = 169,
				[5] = 5,
				[6] = 79,
				[7] = 209,
				[8] = 64,
				[10] = 52
			}
		},
		["Wayrest"] = {
			["Emotes"] = {
				[1] = 25,
				[2] = 52,
				[3] = 201,
				[4] = 11,
				[5] = 110,
				[6] = 122,
				[7] = 91,
				[8] = 38,
				[9] = 9,
				[10] = 91,
				[11] = 95,
				[12] = 95,
				[13] = 203,
				[14] = 203
			}
		}
	}
end


function SmartEmotes.CreateDungeonTable()
	defaultEmotesForDungeons = {
		["Emotes"] = {
			[1] = 63,
			[2] = 1,
			[3] = 101,
			[4] = 102,
			[5] = 52,
			[6] = 22,
			[7] = 171
		}
	}
end


function SmartEmotes.CreateDefaultEmoteTables()
	SmartEmotes.CreateEmotesByRegionTable()
	SmartEmotes.CreateZoneToRegionEmotesTable()
	SmartEmotes.CreateEmotesByCityTable()
	SmartEmotes.CreateDungeonTable()
end


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
				[2] = 67,
				[3] = 214,
				[4] = 24
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
				[5] = 25,
				[6] = 129,
				[7] = 97
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
			["Duration"] = defaultDuration*2
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
				[4] = 12,
				[5] = 168,
				[6] = 133,
				[7] = 80,
			},
			["Duration"] = defaultDuration*(2/3)
		},
		[EVENT_LOW_FALL_DAMAGE] = {
			["EventName"] = EVENT_LOW_FALL_DAMAGE,
			["Emotes"] = {
				[1] = 133,
				[2] = 80,
				[3] = 33,
				[4] = 149
			},
			["Duration"] = defaultDuration/2
		},
		[EVENT_MOUNTED_STATE_CHANGED] = {
			["EventName"] = EVENT_MOUNTED_STATE_CHANGED,
			["Emotes"] = {
				[1] = 91,
				[2] = 110,
				[3] = 80
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
				[7] = 200,
				[8] = 39
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
				[8] = 62,
				[9] = 44,
				[10] = 44,
				[11] = 44
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


function SmartEmotes.IsPlayerInZone(zoneName)
	if zoneToRegionEmotes[zoneName] ~= nil then
		return true
	end
	return false
end


function SmartEmotes.IsPlayerInCity(POI)
	if defaultEmotesByCity[POI] ~= nil then
		return true
	end
	return false
end



function SmartEmotes.IsPlayerInDungeon(POI, zoneName)
	if defaultEmotesByCity[POI] == nil then
		if zoneToRegionEmotes[zoneName] == nil then 
			return true
		end
	end
	return false
end


--[[
function SmartEmotes.IfPlayerInZoneSetDefault(zoneName)
	if zoneToRegionEmotes[zoneName] ~= nil then
		if defaultEmotes ~= zoneToRegionEmotes[zoneName] then
			defaultEmotes = zoneToRegionEmotes[zoneName]
		end
		return true
	end
	return false
end


function SmartEmotes.IfPlayerInCitySetDefault(POI)
	if defaultEmotesByCity[POI] ~= nil then
		if  defaultEmotes ~= defaultEmotesByCity[POI] then
			defaultEmotes = defaultEmotesByCity[POI]
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
			end 
			return true
		end
	end
	return false
end
]]--

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


function SmartEmotes.UpdateDefaultEmotesTable()
	local location = GetPlayerLocationName()
	local zoneName = GetPlayerActiveZoneName()

	if SmartEmotes.IsPlayerInCity(location) then
		defaultEmotes = defaultEmotesByCity[location]
	elseif SmartEmotes.IsPlayerInZone(zoneName) then
		defaultEmotes = zoneToRegionEmotes[zoneName]
	elseif SmartEmotes.IsPlayerInDungeon(location, zoneName) then
		defaultEmotes = defaultEmotesForDungeons
	end
end


--[[
function SmartEmotes.UpdateDefaultEmotesTable()
	local location = GetPlayerLocationName()
	local zoneName = GetPlayerActiveZoneName()
	if SmartEmotes.IfPlayerInCitySetDefault(location) then return
	elseif SmartEmotes.IfPlayerInZoneSetDefault(zoneName) then return
	elseif SmartEmotes.IfPlayerInDungeonSetDefault(location, zoneName) then return
	end
end
]]--

--[[ IDLE EMOTES
function SmartEmotes.PerformIdleEmote()
	PlayEmoteByIndex(199)
end


function SmartEmotes.UpdateStealthState(eventCode, unitTag, stealthState)
	if unitTag ~= LorePlay.player then return end
	if stealthState ~= STEALTH_STATE_NONE then
		isPlayerStealthed = true
	else
		isPlayerStealthed = false
	end
end


function SmartEmotes.IsPlayerIdle()
	if not IsPlayerMoving() and not isPlayerInCombat then
		if isPlayerStealthed == nil then
			SmartEmotes.UpdateStealthState(EVENT_STEALTH_STATE_CHANGED, LorePlay.player, GetUnitStealthState(LorePlay.player))
		end
		if not isPlayerStealthed then
			return true
		end
	end
	return false
end


function SmartEmotes.SetIdleCounter()
	local idleTime = 6
	if not SmartEmotes.IsPlayerIdle() then
		idleCounter = 0
	elseif idleCounter == idleTime then
		return
	else 
		idleCounter = idleCounter + 1
	end
end


function SmartEmotes.ShouldBeginIdleEmote()
	local idleTime = 6 -- 6 ticks of 2 seconds each means idle
	SmartEmotes.SetIdleCounter()
	if idleCounter < idleTime then
		return false
	else
		return true
	end
end


function SmartEmotes.BeginIdleTimer()
	if SmartEmotes.ShouldBeginIdleEmote() then
		SmartEmotes.PerformIdleEmote()
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
		SmartEmotes.isPlayerInCombat = false
		if emoteFromTTL["EventName"] == eventTTLEmotes[EVENT_LEVEL_UPDATE]["EventName"] then return end
		SmartEmotes.UpdateTTLEmoteTable(eventCode)
	else
		SmartEmotes.isPlayerInCombat = true
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
	

	--EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_STEALTH_STATE_CHANGED, SmartEmotes.UpdateStealthState)
	--EVENT_MANAGER:RegisterForUpdate(LorePlay.name, 2000, SmartEmotes.BeginIdleTimer)


	--EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_LOOT_RECEIVED, ImmersiveEmotes.UpdateSmartEmoteTable_For_EVENT_LOOT_RECEIVED)
	SmartEmotes.UpdateTTLEmoteTable(EVENT_STARTUP)
end

LorePlay = SmartEmotes