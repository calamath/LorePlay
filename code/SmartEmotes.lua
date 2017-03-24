local SmartEmotes = LorePlay


local indicator
local wasIndicatorTurnedOffForTTL
local indicatorFadeIn
local indicatorFadeOut
local timelineFadeIn
local timelineFadeOut


local EVENT_STARTUP = "EVENT_STARTUP"
local EVENT_KILLED_CREATURE = "EVENT_KILLED_CREATURE"
local EVENT_POWER_UPDATE_STAMINA = "EVENT_POWER_UPDATE_STAMINA"
local EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND = "EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND"
local EVENT_RETICLE_TARGET_CHANGED_TO_EPIC = "EVENT_RETICLE_TARGET_CHANGED_TO_EPIC"
local EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME = "EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME"
local EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL = "EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL"
local EVENT_RETICLE_TARGET_CHANGED_TO_SPOUSE = "EVENT_RETICLE_TARGET_CHANGED_TO_SPOUSE"
local EVENT_PLAYER_COMBAT_STATE_NOT_INCOMBAT = "EVENT_PLAYER_COMBAT_STATE_NOT_INCOMBAT"
local EVENT_PLAYER_COMBAT_STATE_NOT_INCOMBAT_FLED = "EVENT_PLAYER_COMBAT_STATE_NOT_INCOMBAT_FLED"
local EVENT_PLAYER_COMBAT_STATE_INCOMBAT = "EVENT_PLAYER_COMBAT_STATE_INCOMBAT"
local EVENT_LOCKPICK_SUCCESS_EASY = "EVENT_LOCKPICK_SUCCESS_EASY"
local EVENT_LOCKPICK_SUCCESS_MEDIUM = "EVENT_LOCKPICK_SUCCESS_MEDIUM"
local EVENT_LOCKPICK_SUCCESS_HARD = "EVENT_LOCKPICK_SUCCESS_HARD"
local EVENT_LOOT_RECEIVED_RUNE_TA = "EVENT_LOOT_RECEIVED_RUNE_TA"
local EVENT_LOOT_RECEIVED_RUNE_REKUTA = "EVENT_LOOT_RECEIVED_RUNE_REKUTA"
local EVENT_LOOT_RECEIVED_RUNE_KUTA = "EVENT_LOOT_RECEIVED_RUNE_KUTA"
local EVENT_LOOT_RECEIVED_UNIQUE = "EVENT_LOOT_RECEIVED_UNIQUE"
local EVENT_LOOT_RECEIVED_GENERAL = "EVENT_LOOT_RECEIVED_GENERAL"
local EVENT_LOOT_RECEIVED_BETTER = "EVENT_LOOT_RECEIVED_BETTER"
local EVENT_LOOT_RECEIVED_RECIPE_OR_MATERIAL = "EVENT_LOOT_RECEIVED_RECIPE_OR_MATERIAL"
local EVENT_LOOT_RECEIVED_RARE_RECIPE_OR_MATERIAL = "EVENT_LOOT_RECEIVED_RARE_RECIPE_OR_MATERIAL"
local EVENT_KILLED_BOSS = "EVENT_KILLED_BOSS"
local EVENT_INDICATOR_ON = "EVENT_INDICATOR_ON"


local isMounted
local isInCombat
local lockpickQuality
local defaultEmotes
local defaultEmotesByCity
local defaultEmotesForDungeons
local eventTTLEmotes
local eventLatchedEmotes
local reticleEmotesTable
local lastEventTimeStamp
local existsPreviousEvent
local lastLatchedEvent
local emoteFromLatched
local emoteFromReticle


local emoteFromTTL = {}
local lockpickValues = {
	[LOCK_QUALITY_PRACTICE] = 1,
	[LOCK_QUALITY_TRIVIAL] = 2,
	[LOCK_QUALITY_SIMPLE] = 3,
	[LOCK_QUALITY_INTERMEDIATE] = 4,
	[LOCK_QUALITY_ADVANCED] = 5,
	[LOCK_QUALITY_MASTER] = 6,
	[LOCK_QUALITY_IMPOSSIBLE] = 7
}
local runeQualityToEvents = {
	[ITEM_QUALITY_NORMAL] = EVENT_LOOT_RECEIVED_RUNE_TA,
	[ITEM_QUALITY_ARTIFACT] = EVENT_LOOT_RECEIVED_RUNE_REKUTA,
	[ITEM_QUALITY_LEGENDARY] = EVENT_LOOT_RECEIVED_RUNE_KUTA
}


local function TurnIndicatorOff()
	timelineFadeOut:PlayFromStart()
	indicator = false
end


local function TurnIndicatorOn()
	SmartEmotesIndicator:SetHidden(false)
	timelineFadeIn:PlayFromStart()
	indicator = true
end


function SmartEmotes.IsTargetSpouse()
	if GetUnitNameHighlightedByReticle() == LorePlay.savedSettingsTable.maraSpouseName then
		return true
	end
	return false
end


local function UpdateEmoteFromReticle()
	local unitTitle = GetUnitTitle("reticleover")
	if IsUnitFriend("reticleover") then
		if SmartEmotes.IsTargetSpouse() then
			emoteFromReticle = reticleEmotesTable[EVENT_RETICLE_TARGET_CHANGED_TO_SPOUSE]
		else
			emoteFromReticle = reticleEmotesTable[EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND]
		end
	elseif languageTable.playerTitles[unitTitle] ~= nil then
		if GetUnitTitle("player") == languageTable.playerTitles[unitTitle] then
			emoteFromReticle = reticleEmotesTable[EVENT_RETICLE_TARGET_CHANGED_TO_EPIC_SAME]
		else 
			emoteFromReticle = reticleEmotesTable[EVENT_RETICLE_TARGET_CHANGED_TO_EPIC]
		end
	else 
		emoteFromReticle = reticleEmotesTable[EVENT_RETICLE_TARGET_CHANGED_TO_NORMAL]
	end
end


local function GetSmartEmoteIndex(emoteTable)
	local randomNumber, smartEmoteIndex
	randomNumber = math.random(#emoteTable["Emotes"])
	smartEmoteIndex = emoteTable["Emotes"][randomNumber]
	return smartEmoteIndex
end


function SmartEmotes.PerformSmartEmote()
	if IsPlayerMoving() or isMounted then return end
	local smartEmoteIndex, wasReticle, wasTTL
	if IsUnitPlayer("reticleover") and 
	not SmartEmotes.DoesEmoteFromTTLEqualEvent(EVENT_TRADE_SUCCEEDED, EVENT_TRADE_CANCELED) then
		UpdateEmoteFromReticle()
		smartEmoteIndex = GetSmartEmoteIndex(emoteFromReticle)
		wasReticle = true
	elseif eventLatchedEmotes["isEnabled"] then
		smartEmoteIndex = GetSmartEmoteIndex(emoteFromLatched)
	elseif eventTTLEmotes["isEnabled"] then
		smartEmoteIndex = GetSmartEmoteIndex(emoteFromTTL)
		wasTTL = true
	else
		SmartEmotes.UpdateDefaultEmotesTable()
		smartEmoteIndex = GetSmartEmoteIndex(defaultEmotes)
	end
	LPEventHandler:FireEvent(EVENT_ON_SMART_EMOTE, false, smartEmoteIndex)
	PlayEmoteByIndex(smartEmoteIndex)
	if not LorePlay.savedSettingsTable.isSmartEmotesIndicatorOn then return end
	if indicator and not wasReticle then
		TurnIndicatorOff()
		if wasTTL then
			wasIndicatorTurnedOffForTTL = true
		end
	end
end


function SmartEmotes.DisableTTLEmotes()
	eventTTLEmotes["isEnabled"] = false
	if not LorePlay.savedSettingsTable.isSmartEmotesIndicatorOn then return end
	if indicator and not eventLatchedEmotes["isEnabled"] then
		TurnIndicatorOff()
	end
end


function SmartEmotes.DisableLatchedEmotes()
	eventLatchedEmotes["isEnabled"] = false
	if not LorePlay.savedSettingsTable.isSmartEmotesIndicatorOn then return end
	if indicator and not eventTTLEmotes["isEnabled"] or wasIndicatorTurnedOffForTTL then
		TurnIndicatorOff()
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
	if not eventCode then return end
	if not eventLatchedEmotes[eventCode] then return end
	--if emoteFromLatched == eventLatchedEmotes[eventCode] and eventLatchedEmotes["isEnabled"] then return end
	emoteFromLatched = eventLatchedEmotes[eventCode]
	eventLatchedEmotes["isEnabled"] = true
	if not LorePlay.savedSettingsTable.isSmartEmotesIndicatorOn then return end
	if not indicator then
		TurnIndicatorOn()
	end
end


function SmartEmotes.UpdateTTLEmoteTable(eventCode)
	if eventCode == nil then return end
	if eventTTLEmotes[eventCode] == nil then return end
	lastEventTimeStamp = GetTimeStamp()
	if not eventTTLEmotes["isEnabled"] then 
		eventTTLEmotes["isEnabled"] = true
	end
	emoteFromTTL = eventTTLEmotes[eventCode]
	zo_callLater(SmartEmotes.CheckToDisableTTLEmotes, eventTTLEmotes[eventCode]["Duration"])
	if not LorePlay.savedSettingsTable.isSmartEmotesIndicatorOn then return end
	if not indicator then
		TurnIndicatorOn()
	end
	wasIndicatorTurnedOffForTTL = false
end


function SmartEmotes.CreateEmotesByRegionTable()
	SmartEmotes.defaultEmotesByRegion = {
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
				[4] = 214,
				[5] = 52,
				[6] = 38,
				[7] = 104,
				[8] = 64,
				[9] = 214,
				[10] = 169
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
	LorePlay = SmartEmotes
end



function SmartEmotes.CreateEmotesByCityTable()
	local defaultCityToRegionEmotes = {
		["AD"] = {
			[1] = 177,
			[2] = 174,
			[3] = 202,
			[4] = 99,
			[5] = 8,
			[6] = 52,
			[7] = 184,
			[8] = 5,
			[9] = 6,
			[10] = 7,
			[11] = 72,
			[12] = 72,
			[13] = 182,
			[14] = 187,
			[15] = 52,
			[16] = 8,
			[17] = 79
		},
		["EP"] = {
			[1] = 174,
			[2] = 8,
			[3] = 52,
			[4] = 7,
			[5] = 203,
			[6] = 169,
			[7] = 121,
			[8] = 185,
			[9] = 5,
			[10] = 6,
			[11] = 72,
			[12] = 72,
			[13] = 188,
			[14] = 183,
			[15] = 100,
			[16] = 8,
			[17] = 79
		},
		["DC"] = {
			[1] = 25,
			[2] = 52,
			[3] = 201,
			[4] = 11,
			[5] = 6,
			[6] = 122,
			[7] = 91,
			[8] = 38,
			[9] = 9,
			[10] = 72,
			[11] = 95,
			[12] = 7,
			[13] = 181,
			[14] = 5,
			[15] = 189,
			[16] = 190,
			[17] = 8,
			[18] = 79
		},
		["Other"] = {
			[1] = 177,
			[2] = 8,
			[3] = 72,
			[4] = 72,
			[5] = 52,
			[6] = 5,
			[7] = 6,
			[8] = 7,
			[9] = 211,
			[10] = 100,
			[11] = 8,
			[12] = 79
		}
	}


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
				[10] = 52,
				[11] = 184,
				[12] = 5,
				[13] = 6,
				[14] = 7,
				[15] = 79
			}
		},
		["Elden Root Services"] = { 
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
				[10] = 52,
				[11] = 184,
				[12] = 5,
				[13] = 6,
				[14] = 7,
				[15] = 79,
				[16] = 8
			}
		},
		["Vulkhel Guard"] = { 
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
				[10] = 91,
				[11] = 182,
				[12] = 5,
				[13] = 6,
				[14] = 7,
				[15] = 79,
				[16] = 8
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
				[7] = 121,
				[8] = 185,
				[9] = 5,
				[10] = 6,
				[11] = 7,
				[12] = 79,
				[13] = 8
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
				[10] = 52,
				[11] = 188,
				[12] = 6,
				[13] = 7,
				[14] = 8
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
				[10] = 52,
				[11] = 188,
				[12] = 6,
				[13] = 7,
				[14] = 8
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
				[14] = 203,
				[15] = 181,
				[16] = 5,
				[17] = 6,
				[18] = 7,
				[19] = 8,
				[20] = 79
			}
		},
		["Abah's Landing"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Aldcroft"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Anvil"] = { 
			["Emotes"] = defaultCityToRegionEmotes["Other"]
		},
		["Arenthia"] = { 
			["Emotes"] = defaultCityToRegionEmotes["AD"]
		},
		["Baandari Trading Post"] = { 
			["Emotes"] = defaultCityToRegionEmotes["AD"]
		},
		["Baandari Post Wayshrine"] = { 
			["Emotes"] = defaultCityToRegionEmotes["AD"]
		},
		["Belkarth"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Camlorn"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Clockwork City"] = { 
			["Emotes"] = defaultCityToRegionEmotes["EP"]
		},
		["Daggerfall"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Daggerfall Castle Town"] = {
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Davon's Watch"] = { 
			["Emotes"] = defaultCityToRegionEmotes["EP"]
		},
		["Dune"] = { 
			["Emotes"] = defaultCityToRegionEmotes["AD"]
		},
		["Ebonheart"] = { 
			["Emotes"] = defaultCityToRegionEmotes["EP"]
		},
		["Elinhir"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Evermore"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Firsthold"] = { 
			["Emotes"] = defaultCityToRegionEmotes["AD"]
		},
		["Hallin's Stand"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Haven"] = { 
			["Emotes"] = defaultCityToRegionEmotes["AD"]
		},
		["Hollow City"] = { 
			["Emotes"] = defaultCityToRegionEmotes["Other"]
		},
		["The Hollow City"] = { 
			["Emotes"] = defaultCityToRegionEmotes["Other"]
		},
		["Imperial City"] = { 
			["Emotes"] = defaultCityToRegionEmotes["Other"]
		},
		["Kozanset"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Kragenmoor"] = { 
			["Emotes"] = defaultCityToRegionEmotes["EP"]
		},
		["Kvatch"] = { 
			["Emotes"] = defaultCityToRegionEmotes["Other"]
		},
		["Marbruk"] = { 
			["Emotes"] = defaultCityToRegionEmotes["AD"]
		},
		["Mistral"] = { 
			["Emotes"] = defaultCityToRegionEmotes["AD"]
		},
		["Northpoint"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Orsinium"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Port Hunding"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Rawl'kha"] = { 
			["Emotes"] = defaultCityToRegionEmotes["AD"]
		},
		["Sentinel"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Shornhelm"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Silvenar"] = { 
			["Emotes"] = defaultCityToRegionEmotes["AD"]
		},
		["Silvenar's Audience Hall"] = { 
			["Emotes"] = defaultCityToRegionEmotes["AD"]
		},
		["Stormhold"] = { 
			["Emotes"] = defaultCityToRegionEmotes["EP"]
		},
		["Tava's Blessing"] = { 
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Skywatch"] = { 
			["Emotes"] = defaultCityToRegionEmotes["AD"]
		},
		["Woodhearth"] = { 
			["Emotes"] = defaultCityToRegionEmotes["AD"]
		}
	}

	local cityWayshrine
	for i,v in pairs(defaultEmotesByCity) do
		cityWayshrine = i.." Wayshrine"
		defaultEmotesByCity[cityWayshrine] = defaultEmotesByCity[i]
	end
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
			[7] = 171,
			[8] = 1,
			[9] = 22
		}
	}
end


function SmartEmotes.CreateDolmenTable()
	defaultEmotesForDolmens = {
		["Emotes"] = {
			[1] = 63,
			[2] = 110,
			[3] = 101,
			[4] = 102,
			[5] = 52,
			[6] = 22,
			[7] = 171,
			[8] = 63,
			[9] = 22,
			[10] = 110,
			[11] = 152
		}
	}
end


function SmartEmotes.CreateDefaultEmoteTables()
	SmartEmotes.CreateEmotesByRegionTable()
	languageTable.CreateZoneToRegionEmotesTable()
	SmartEmotes.CreateEmotesByCityTable()
	SmartEmotes.CreateDungeonTable()
	SmartEmotes.CreateDolmenTable()
end


function SmartEmotes.CreateReticleEmoteTable()
	reticleEmotesTable = {
		[EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND] = {
			["EventName"] = EVENT_RETICLE_TARGET_CHANGED_TO_FRIEND,
			["Emotes"] = {
				[1] = 70,
				[2] = 72,
				[3] = 8,
				[4] = 137,
				[5] = 94
			}
		},
		[EVENT_RETICLE_TARGET_CHANGED_TO_SPOUSE] = {
			["EventName"] = EVENT_RETICLE_TARGET_CHANGED_TO_SPOUSE,
			["Emotes"] = {
				[1] = 70,
				[2] = 72,
				[3] = 8,
				[4] = 137,
				[5] = 21,
				[6] = 147,
				[7] = 39,
				[8] = 213,
				[9] = 166,
				[10] = 21
			}
		},
		[EVENT_RETICLE_TARGET_CHANGED_TO_EPIC] = {
			["EventName"] = EVENT_RETICLE_TARGET_CHANGED_TO_EPIC,
			["Emotes"] = {
				[1] = 142,
				[2] = 67,
				[3] = 213,
				[4] = 24,
				[5] = 175,
				[6] = 142
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
				[3] = 137,
				[4] = 17
			}
		}
	}
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
				if currentStam < effectiveMaxStam*(.60) then
					return true
				end
			end
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
				[7] = 97,
				[8] = 97,
				[9] = 97
			},
			["Duration"] = defaultDuration*4
		},
		[EVENT_PLAYER_NOT_SWIMMING] = {
			["EventName"] = EVENT_PLAYER_NOT_SWIMMING,
			["Emotes"] = {
				[1] = 64
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
				[3] = 212
				--[4] = 213
			},
			["Duration"] = defaultDuration
		},
		[EVENT_HIGH_FALL_DAMAGE] = {
			["EventName"] = EVENT_HIGH_FALL_DAMAGE,
			["Emotes"] = {
				[1] = 115,
				[2] = 149,
				[3] = 12,
				[4] = 168,
				[5] = 133,
				[6] = 80,
				[7] = 173,
				[8] = 71
			},
			["Duration"] = defaultDuration*(2/3)
		},
		[EVENT_LOCKPICK_FAILED] = {
			["EventName"] = EVENT_LOCKPICK_FAILED,
			["Emotes"] = {
				[1] = 32,
				[2] = 32,
				[3] = 155,
				[4] = 12,
				[5] = 167,
				[6] = 109,
				[7] = 109
			},
			["Duration"] = defaultDuration*(2/3)
		},
		[EVENT_LOCKPICK_SUCCESS_EASY] = {
			["EventName"] = EVENT_LOCKPICK_SUCCESS_EASY,
			["Emotes"] = {
				[1] = 129,
				[2] = 42,
				[3] = 36,
				[4] = 78,
				[5] = 41
			},
			["Duration"] = defaultDuration
		},
		[EVENT_LOCKPICK_SUCCESS_MEDIUM] = {
			["EventName"] = EVENT_LOCKPICK_SUCCESS_MEDIUM,
			["Emotes"] = {
				[1] = 129,
				[2] = 36,
				[3] = 36,
				[4] = 91,
				[5] = 95,
				[6] = 95
			},
			["Duration"] = defaultDuration
		},
		[EVENT_LOCKPICK_SUCCESS_HARD] = {
			["EventName"] = EVENT_LOCKPICK_SUCCESS_HARD,
			["Emotes"] = {
				[1] = 95,
				[2] = 25,
				[3] = 25,
				[4] = 25,
				[5] = 82,
				[6] = 150,
				[7] = 36,
				[8] = 26,
				[9] = 66
			},
			["Duration"] = defaultDuration
		},
		[EVENT_LOOT_RECEIVED_RUNE_TA] = {
			["EventName"] = EVENT_LOOT_RECEIVED_RUNE_TA,
			["Emotes"] = {
				[1] = 29,
				[2] = 69,
				[3] = 73,
				[4] = 33,
				[5] = 134,
				[6] = 40,
				[7] = 133,
				[8] = 23
			},
			["Duration"] = defaultDuration*(2/3)
		},
		[EVENT_LOOT_RECEIVED_RUNE_REKUTA] = {
			["EventName"] = EVENT_LOOT_RECEIVED_RUNE_REKUTA,
			["Emotes"] = {
				[1] = 36,
				[2] = 54,
				[3] = 42,
				[4] = 81,
				[5] = 129,
				[6] = 26
			},
			["Duration"] = defaultDuration*(2/3)
		},
		[EVENT_LOOT_RECEIVED_RUNE_KUTA] = {
			["EventName"] = EVENT_LOOT_RECEIVED_RUNE_KUTA,
			["Emotes"] = {
				[1] = 67,
				[2] = 13,
				[3] = 66,
				[4] = 25,
				[5] = 163,
				[6] = 72,
				[7] = 150,
				[8] = 26
			},
			["Duration"] = defaultDuration
		},
		[EVENT_LOOT_RECEIVED_RARE_RECIPE_OR_MATERIAL] = {
			["EventName"] = EVENT_LOOT_RECEIVED_RARE_RECIPE_OR_MATERIAL,
			["Emotes"] = {
				[1] = 67,
				[2] = 13,
				[3] = 66,
				[4] = 25,
				[5] = 163,
				[6] = 72,
				[7] = 150,
				[8] = 26
			},
			["Duration"] = defaultDuration
		},
		[EVENT_LOOT_RECEIVED_BETTER] = {
			["EventName"] = EVENT_LOOT_RECEIVED_BETTER,
			["Emotes"] = {
				[1] = 25,
				[2] = 25,
				[3] = 39,
				[4] = 14,
				[5] = 151,
				[6] = 54,
				[7] = 164,
				[8] = 130
			},
			["Duration"] = defaultDuration
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
		[EVENT_PLAYER_COMBAT_STATE_NOT_INCOMBAT] = {
			["EventName"] = EVENT_PLAYER_COMBAT_STATE_NOT_INCOMBAT,
			["Emotes"] = {
				[1] = 78,
				[2] = 162,
				[3] = 39,
				[4] = 179,
				[5] = 52,
				[6] = 119,
				[7] = 200
			},
			["Duration"] = defaultDuration*(1/2)
		},
		[EVENT_PLAYER_COMBAT_STATE_NOT_INCOMBAT_FLED] = {
			["EventName"] = EVENT_PLAYER_COMBAT_STATE_NOT_INCOMBAT_FLED,
			["Emotes"] = {
				[1] = 95,
				[2] = 95,
				[3] = 74,
				[4] = 73,
				[5] = 93,
				[6] = 109,
				[7] = 78
			},
			["Duration"] = defaultDuration*(1/2)
		},
		[EVENT_PLAYER_COMBAT_STATE_INCOMBAT] = {
			["EventName"] = EVENT_PLAYER_COMBAT_STATE_INCOMBAT,
			["Emotes"] = {
				[1] = 27,
				[2] = 160,
				[3] = 164,
				[4] = 106,
				[5] = 159,
				[6] = 159
			},
			["Duration"] = defaultDuration*(2/3)
		},
		[EVENT_KILLED_BOSS] = {
			["EventName"] = EVENT_KILLED_BOSS,
			["Emotes"] = {
				[1] = 200,
				[2] = 162,
				[3] = 119,
				[4] = 179,
				[5] = 25,
				[6] = 152,
				[7] = 145,
				[8] = 62,
				[9] = 13,
				[10] = 22,
				[11] = 97,
				[12] = 8
			},
			["Duration"] = defaultDuration
		},
		[EVENT_TRADE_SUCCEEDED] = {
			["EventName"] = EVENT_TRADE_SUCCEEDED,
			["Emotes"] = {
				[1] = 151,
				[2] = 130
			},
			["Duration"] = defaultDuration/2
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
				[11] = 44,
				[12] = 152
			},
			["Duration"] = defaultDuration/2
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
	if languageTable.zoneToRegionEmotes[zoneName] ~= nil then
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
		if languageTable.zoneToRegionEmotes[zoneName] == nil then 
			return true
		end
	end
	return false
end


function SmartEmotes.IsPlayerInDolmen(POI)
	if PlainStringFind(POI, "Dolmen") then
		return true
	end
	return false
end


-- Here we pass in event codes
function SmartEmotes.DoesEmoteFromTTLEqualEvent(...)
	if not eventTTLEmotes["isEnabled"] then return false end
	local arg = {...}
	for i = 1, #arg, 1 do
		if emoteFromTTL["EventName"] == eventTTLEmotes[arg[i]]["EventName"] then
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


function SmartEmotes.UpdateDefaultEmotesTable()
	local location = GetPlayerLocationName()
	local zoneName = GetPlayerActiveZoneName()

	-- Must remain in this order for proper detection
	if SmartEmotes.IsPlayerInCity(location) then
		defaultEmotes = defaultEmotesByCity[location]
		return
	elseif SmartEmotes.IsPlayerInDolmen(location) then
		defaultEmotes = defaultEmotesForDolmens
		return
	elseif SmartEmotes.IsPlayerInZone(zoneName) then
		defaultEmotes = languageTable.zoneToRegionEmotes[zoneName]
		return
	elseif SmartEmotes.IsPlayerInDungeon(location, zoneName) then
		defaultEmotes = defaultEmotesForDungeons
		return
	end
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LEVEL_UPDATE(eventCode)
	SmartEmotes.UpdateTTLEmoteTable(eventCode)
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_PLAYER_NOT_SWIMMING(eventCode)
	SmartEmotes.UpdateTTLEmoteTable(eventCode)
end


function SmartEmotes.UpdateTTLEmoteTable_For_FALL_DAMAGE(eventCode)
	SmartEmotes.UpdateTTLEmoteTable(eventCode)
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_COMBAT_EVENT(eventCode, result, sourceName)
	if sourceName ~= GetUnitName(LorePlay.player).."^Fx" or isInCombat then return end
	if result == ACTION_RESULT_DIED_XP or result == ACTION_RESULT_DIED or 
	result == ACTION_RESULT_KILLING_BLOW or result == ACTION_RESULT_TARGET_DEAD then
		if SmartEmotes.DoesEmoteFromTTLEqualEvent(EVENT_LEVEL_UPDATE, EVENT_KILLED_BOSS) then return end
		SmartEmotes.UpdateTTLEmoteTable(EVENT_PLAYER_COMBAT_STATE_NOT_INCOMBAT)
	end
end


local function OnCombatEvent(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
	zo_callLater(function() 
		SmartEmotes.UpdateTTLEmoteTable_For_EVENT_COMBAT_EVENT(eventCode, result, sourceName) 
	end, 0250)
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_PLAYER_COMBAT_STATE(eventCode, inCombat)
	if SmartEmotes.DoesEmoteFromTTLEqualEvent(EVENT_LEVEL_UPDATE, EVENT_KILLED_BOSS, 
		EVENT_PLAYER_COMBAT_STATE_NOT_INCOMBAT) then return end
	if not inCombat then
		isInCombat = false
		SmartEmotes.UpdateTTLEmoteTable(EVENT_PLAYER_COMBAT_STATE_NOT_INCOMBAT_FLED)
	else
		isInCombat = true
		SmartEmotes.UpdateTTLEmoteTable(EVENT_PLAYER_COMBAT_STATE_INCOMBAT)
	end
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_MOUNTED_STATE_CHANGED(eventCode, mounted)
	if not mounted then
		isMounted = false
		SmartEmotes.UpdateTTLEmoteTable(eventCode)
	else
		isMounted = true
	end
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE(eventCode, categoryIndex, collectionIndex, bookIndex, guildIndex, skillType, skillIndex, rank, previousXP, currentXP)
	SmartEmotes.UpdateTTLEmoteTable(eventCode)
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_TRADE_SUCCEEDED(eventCode)
	SmartEmotes.UpdateTTLEmoteTable(eventCode)
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LOOT_RECEIVED_GENERAL(eventCode, itemName)
	if eventCode ~= EVENT_LOOT_RECEIVED_GENERAL then return end
	--local equipType = GetItemLinkEquipType(itemName)
	--if equipType == EQUIP_TYPE_INVALID then return end
	local equipSlot1, equipSlot2 = GetComparisonEquipSlotsFromItemLink(itemName)
	if not equipSlot1 or equipSlot1 == EQUIP_SLOT_NONE or equipSlot1 == EQUIP_SLOT_COSTUME then return end
	local qualityReceived = GetItemLinkQuality(itemName)
	local wornItem1 = GetSlotItemLink(equipSlot1)
	local wornItem2
	if equipSlot2 and equipSlot2 ~= EQUIP_SLOT_NONE then
		wornItem2 = GetSlotItemLink(equipSlot2)
	end
	local wornQuality1 = GetItemLinkQuality(wornItem1)
	local wornQuality2
	if wornItem2 then
		wornQuality2 = GetItemLinkQuality(wornItem2)
	end
	if qualityReceived > wornQuality1 or wornQuality2 and qualityReceived > wornQuality2 then
		SmartEmotes.UpdateTTLEmoteTable(EVENT_LOOT_RECEIVED_BETTER)
	end
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LOOT_RECEIVED_RUNE(eventCode, itemName)
	local quality = GetItemLinkQuality(itemName)
	if quality == ITEM_QUALITY_NORMAL or quality == ITEM_QUALITY_ARTIFACT or 
	quality == ITEM_QUALITY_LEGENDARY then
		SmartEmotes.UpdateTTLEmoteTable(runeQualityToEvents[quality])
	end
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LOOT_RECEIVED_RECIPE_OR_MATERIAL(eventCode, itemName)
	local quality = GetItemLinkQuality(itemName)
	if quality == ITEM_QUALITY_ARTIFACT or quality == ITEM_QUALITY_LEGENDARY then
		SmartEmotes.UpdateTTLEmoteTable(EVENT_LOOT_RECEIVED_RARE_RECIPE_OR_MATERIAL)
	end
end


local function OnLootReceived(eventCode, receivedBy, itemName, quantity, itemSound, lootType, self, isPickpocketLoot, questItemIcon, itemId)
	if emoteFromTTL["EventName"] == eventTTLEmotes[EVENT_LEVEL_UPDATE]["EventName"] or
	emoteFromTTL["EventName"] == eventTTLEmotes[EVENT_KILLED_BOSS]["EventName"] then return end
	
	local itemType = GetItemLinkItemType(itemName)
	if IsItemLinkEnchantingRune(itemName) then
		SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LOOT_RECEIVED_RUNE(EVENT_LOOT_RECEIVED_RUNE, itemName)
	elseif itemType == ITEMTYPE_RAW_MATERIAL or ITEMTYPE_RECIPE then
		SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LOOT_RECEIVED_RECIPE_OR_MATERIAL(EVENT_LOOT_RECEIVED_RECIPE_OR_MATERIAL, itemName)
	elseif IsItemLinkUnique(itemName) then
		SmartEmotes.UpdateTTLEmoteTable(EVENT_LOOT_RECEIVED_BETTER)
	else
		SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LOOT_RECEIVED_GENERAL(EVENT_LOOT_RECEIVED_GENERAL, itemName)
	end
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_TRADE_CANCELED(eventCode)
	SmartEmotes.UpdateTTLEmoteTable(eventCode)
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_SKILL_POINTS_CHANGED(eventCode, pointsBefore, pointsNow, partialPointsBefore, partialPointsNow)
	if emoteFromTTL["EventName"] == eventTTLEmotes[EVENT_LEVEL_UPDATE]["EventName"] then return end
	--[[ MAKE NEW TABLE FOR DIFFERENCE BETWEEN SKYSHARD AND SKILL POINT GAIN ]]--
	if partialPointsNow > partialPointsBefore then
		SmartEmotes.UpdateTTLEmoteTable(EVENT_SKILL_POINTS_CHANGED)
	elseif pointsNow > pointsBefore then
		SmartEmotes.UpdateTTLEmoteTable(EVENT_SKILL_POINTS_CHANGED)
	end
end


-- Stamina bar
function SmartEmotes.UpdateLatchedEmoteTable_For_EVENT_POWER_UPDATE(eventCode, unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax)
	if unitTag ~= LorePlay.player then return end
	if powerType == POWERTYPE_STAMINA then
		local lowerThreshold = powerEffectiveMax*(.20)
		local upperThreshold = powerEffectiveMax*(.60)
		if powerValue <= lowerThreshold then 
			SmartEmotes.UpdateLatchedEmoteTable(EVENT_POWER_UPDATE_STAMINA)
		elseif powerValue >= upperThreshold 
		and SmartEmotes.DoesEmoteFromLatchedEqualEvent(EVENT_POWER_UPDATE_STAMINA) then
			SmartEmotes.DisableLatchedEmotes()
		end
	end
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_EXPERIENCE_UPDATE(eventCode, unitTag, currentExp, maxExp, reason)
	if unitTag ~= LorePlay.player then return end
	if SmartEmotes.DoesEmoteFromTTLEqualEvent(EVENT_LEVEL_UPDATE) then return end
	if reason == PROGRESS_REASON_OVERLAND_BOSS_KILL then
		SmartEmotes.UpdateTTLEmoteTable(EVENT_KILLED_BOSS)
		return
	end
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LOCKPICK_FAILED(eventCode)
	if eventCode ~= EVENT_LOCKPICK_FAILED then return end
	if SmartEmotes.DoesEmoteFromTTLEqualEvent(EVENT_LEVEL_UPDATE) then return end
	SmartEmotes.UpdateTTLEmoteTable(EVENT_LOCKPICK_FAILED)
end


function SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LOCKPICK_SUCCESS(eventCode)
	if eventCode ~= EVENT_LOCKPICK_SUCCESS then return end
	if SmartEmotes.DoesEmoteFromTTLEqualEvent(EVENT_LEVEL_UPDATE) then return end
	if not lockpickQuality then return end
	if lockpickQuality <= lockpickValues[LOCK_QUALITY_SIMPLE] then
		SmartEmotes.UpdateTTLEmoteTable(EVENT_LOCKPICK_SUCCESS_EASY)
		return
	elseif lockpickQuality > lockpickValues[LOCK_QUALITY_SIMPLE] 
	and lockpickQuality <= lockpickValues[LOCK_QUALITY_ADVANCED] then
		SmartEmotes.UpdateTTLEmoteTable(EVENT_LOCKPICK_SUCCESS_MEDIUM)
		return
	elseif lockpickQuality > lockpickValues[LOCK_QUALITY_ADVANCED] then
		SmartEmotes.UpdateTTLEmoteTable(EVENT_LOCKPICK_SUCCESS_HARD)
		return
	end
end


local function OnBeginLockpick(eventCode)
	if eventCode ~= EVENT_BEGIN_LOCKPICK then return end
	lockpickQuality = lockpickValues[GetLockQuality()]
end


function SmartEmotes.RegisterSmartEvents()
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_LEVEL_UPDATE, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LEVEL_UPDATE)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_PLAYER_NOT_SWIMMING, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_PLAYER_NOT_SWIMMING)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_POWER_UPDATE, SmartEmotes.UpdateLatchedEmoteTable_For_EVENT_POWER_UPDATE)
	EVENT_MANAGER:AddFilterForEvent(LorePlay.name, EVENT_POWER_UPDATE, REGISTER_FILTER_POWER_TYPE, POWERTYPE_STAMINA)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_TRADE_CANCELED, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_TRADE_CANCELED)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_TRADE_SUCCEEDED, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_TRADE_SUCCEEDED)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_HIGH_FALL_DAMAGE, SmartEmotes.UpdateTTLEmoteTable_For_FALL_DAMAGE)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_LOW_FALL_DAMAGE, SmartEmotes.UpdateTTLEmoteTable_For_FALL_DAMAGE)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_SKILL_POINTS_CHANGED, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_SKILL_POINTS_CHANGED)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LORE_BOOK_LEARNED_SKILL_EXPERIENCE)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_MOUNTED_STATE_CHANGED, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_MOUNTED_STATE_CHANGED)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_PLAYER_COMBAT_STATE, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_PLAYER_COMBAT_STATE)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_EXPERIENCE_UPDATE, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_EXPERIENCE_UPDATE)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_LOCKPICK_FAILED, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LOCKPICK_FAILED)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_LOCKPICK_SUCCESS, SmartEmotes.UpdateTTLEmoteTable_For_EVENT_LOCKPICK_SUCCESS)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_BEGIN_LOCKPICK, OnBeginLockpick)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_COMBAT_EVENT, OnCombatEvent)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_LOOT_RECEIVED, OnLootReceived)
end


function SmartEmotes.InitializeIndicator()
	if not LorePlay.savedSettingsTable.isSmartEmotesIndicatorOn then 
		SmartEmotesIndicator:SetHidden(true)
	end
	if LorePlay.savedSettingsTable.indicatorTop then
		SmartEmotesIndicator:ClearAnchors()
		SmartEmotesIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LorePlay.savedSettingsTable.indicatorLeft, LorePlay.savedSettingsTable.indicatorTop)
	end
	local fadeTime = 1500
	indicatorFadeIn, timelineFadeIn = CreateSimpleAnimation(ANIMATION_ALPHA, SmartEmotesIndicator)
	indicatorFadeOut, timelineFadeOut = CreateSimpleAnimation(ANIMATION_ALPHA, SmartEmotesIndicator) --SmartEmotesIndicator defined in xml file of same name
	indicatorFadeIn:SetAlphaValues(0, EmoteImage:GetAlpha())
	indicatorFadeIn:SetDuration(fadeTime)
	indicatorFadeOut:SetAlphaValues(EmoteImage:GetAlpha(), 0)
	indicatorFadeOut:SetDuration(fadeTime)
	timelineFadeIn:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT)
	timelineFadeOut:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT)
	indicator = false
end


function SmartEmotes.InitializeEmotes()
	SmartEmotes.CreateTTLEmoteEventTable()
	SmartEmotes.CreateLatchedEmoteEventTable()
	SmartEmotes.CreateReticleEmoteTable()
	SmartEmotes.CreateDefaultEmoteTables()
	SmartEmotes.RegisterSmartEvents()
	SmartEmotes.InitializeIndicator()
	SmartEmotes.UpdateTTLEmoteTable(EVENT_STARTUP)
	isMounted = IsMounted()
end

LorePlay = SmartEmotes