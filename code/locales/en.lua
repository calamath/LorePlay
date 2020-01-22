LorePlay = LorePlay or {}

local strings = {
	SI_LOREPLAY_LOCATION_KEYWORD_DOLMEN			= "Dolmen", 

	SI_LOREPLAY_PC_TITLE_NAME_M_41				= "Emperor", 					-- "Emperor"
	SI_LOREPLAY_PC_TITLE_NAME_M_42				= "Former Emperor", 			-- "Former Emperor"
	SI_LOREPLAY_PC_TITLE_NAME_M_47				= "Daedric Lord Slayer", 		-- "Daedric Lord Slayer"
	SI_LOREPLAY_PC_TITLE_NAME_M_48				= "Savior of Nirn", 			-- "Savior of Nirn"
	SI_LOREPLAY_PC_TITLE_NAME_M_51				= "Dragonstar Arena Champion", 	-- "Dragonstar Arena Champion"
	SI_LOREPLAY_PC_TITLE_NAME_M_54				= "Maelstrom Arena Champion", 	-- "Maelstrom Arena Champion"
	SI_LOREPLAY_PC_TITLE_NAME_M_55				= "Stormproof",                 -- "Stormproof"
	SI_LOREPLAY_PC_TITLE_NAME_M_56				= "The Flawless Conqueror", 	-- "The Flawless Conqueror"
	SI_LOREPLAY_PC_TITLE_NAME_M_63				= "Ophidian Overlord", 			-- "Ophidian Overlord"

	SI_LOREPLAY_PC_TITLE_NAME_F_41				= "Empress", 					-- "Empress"
	SI_LOREPLAY_PC_TITLE_NAME_F_42				= "Former Empress", 			-- "Former Empress"
	SI_LOREPLAY_PC_TITLE_NAME_F_47				= "Daedric Lord Slayer", 		-- "Daedric Lord Slayer"
	SI_LOREPLAY_PC_TITLE_NAME_F_48				= "Savior of Nirn", 			-- "Savior of Nirn"
	SI_LOREPLAY_PC_TITLE_NAME_F_51				= "Dragonstar Arena Champion", 	-- "Dragonstar Arena Champion"
	SI_LOREPLAY_PC_TITLE_NAME_F_54				= "Maelstrom Arena Champion", 	-- "Maelstrom Arena Champion"
	SI_LOREPLAY_PC_TITLE_NAME_F_55				= "Stormproof",                 -- "Stormproof"
	SI_LOREPLAY_PC_TITLE_NAME_F_56				= "The Flawless Conqueror", 	-- "The Flawless Conqueror"
	SI_LOREPLAY_PC_TITLE_NAME_F_63				= "Ophidian Overlord", 			-- "Ophidian Overlord"

	SI_LOREPLAY_UI_WELCOME							= "[LorePlay] Welcome to LorePlay, Soulless One!", 
	SI_LOREPLAY_PANEL_SE_HEADER						= "Smart Emotes", 
	SI_LOREPLAY_PANEL_SE_DESCRIPTION				= "Contextual, appropriate emotes to perform at the touch of a button.\nBy default, pressing performs an emote based on location. However, it adapts and conforms to many different special environmental situations along your travels as well.\n|cFF0000Don't forget to bind your SmartEmotes button!|r", 
	SI_LOREPLAY_PANEL_SE_EDIT_SIGNIFICANT_CHAR_NAME	= "Significant Other's Character Name", 
	SI_LOREPLAY_PANEL_SE_EDIT_SIGNIFICANT_CHAR_TIPS	= "For those who have wed with the Ring of Mara, entering the exact character name of your loved one allows for special emotes between you two!\n(Note: Must be friends!)", 
	SI_LOREPLAY_PANEL_SE_INDICATOR_SW_NAME			= "Toggle Indicator On/Off", 
	SI_LOREPLAY_PANEL_SE_INDICATOR_SW_TIPS			= "Turns on/off the small, moveable indicator (drama masks) that appears on your screen whenever new special adaptive SmartEmotes are available to be performed.", 
	SI_LOREPLAY_PANEL_SE_INDICATOR_POS_RESET_NAME	= "Reset Indicator Position", 
	SI_LOREPLAY_PANEL_SE_INDICATOR_POS_RESET_TIPS	= "Resets the indicator to be positioned in the top left of the screen.", 
	SI_LOREPLAY_PANEL_IE_HEADER						= "Idle Emotes", 
	SI_LOREPLAY_PANEL_IE_DESCRIPTION				= "Contextual, automatic emotes that occur when you go idle or AFK (Not moving, not fighting, not stealthing).\n|cFF0000Don't forget to bind your IdleEmotes keypress for quick toggling!|r", 
	SI_LOREPLAY_PANEL_IE_SW_NAME					= "Toggle IdleEmotes On/Off", 
	SI_LOREPLAY_PANEL_IE_SW_TIPS					= "Turns on/off the automatic, contextual emotes that occur when you go idle or AFK.\n(Note: Disabling IdleEmotes displays all its settings as off, but will persist after re-enabling.)", 
	SI_LOREPLAY_PANEL_IE_EMOTE_DURATION_NAME		= "Emote Duration", 
	SI_LOREPLAY_PANEL_IE_EMOTE_DURATION_TIPS		= "Determines how long in seconds a given idle emote will be performed before switching to a new one.\nDefault is 30 seconds.", 
	SI_LOREPLAY_PANEL_IE_PLAY_INST_IN_CITY_SW_NAME	= "Can Play Instruments In Cities", 
	SI_LOREPLAY_PANEL_IE_PLAY_INST_IN_CITY_SW_TIPS	= "Determines whether or not your character can perform instrument emotes when idle in cities.", 
	SI_LOREPLAY_PANEL_IE_DANCE_IN_CITY_SW_NAME		= "Can Dance In Cities", 
	SI_LOREPLAY_PANEL_IE_DANCE_IN_CITY_SW_TIPS		= "Determines whether or not your character can perform dance emotes when idle in cities.", 
	SI_LOREPLAY_PANEL_IE_BE_DRUNK_IN_CITY_SW_NAME	= "Can Be Drunk In Cities", 
	SI_LOREPLAY_PANEL_IE_BE_DRUNK_IN_CITY_SW_TIPS	= "Determines whether or not your character can perform drunken emotes when idle in cities.", 
	SI_LOREPLAY_PANEL_IE_EXERCISE_IN_ZONE_SW_NAME	= "Can Exercise Outside Cities", 
	SI_LOREPLAY_PANEL_IE_EXERCISE_IN_ZONE_SW_TIPS	= "Determines whether or not your character can perform exercise emotes when idle outside of cities.", 
	SI_LOREPLAY_PANEL_IE_WORSHIP_SW_NAME			= "Can Worship/Pray", 
	SI_LOREPLAY_PANEL_IE_WORSHIP_SW_TIPS			= "Determines whether or not your character can perform prayer and worship emotes when idle in general.", 
	SI_LOREPLAY_PANEL_IE_CAMERA_SPIN_DISABLER_NAME	= "Camera Spin Disabler", 
	SI_LOREPLAY_PANEL_IE_CAMERA_SPIN_DISABLER_TIPS	= "Allows for emotes to be performed while in menus. Disables camera spin in menus. Removes '" .. GetString(SI_PLAYEREMOTEPLAYFAILURE0) .. "' message.", 
	SI_LOREPLAY_PANEL_LE_HEADER						= "Lore Wear", 
	SI_LOREPLAY_PANEL_LE_DESCRIPTION				= "Armor should be worn when venturing Tamriel, but not when in comfortable cities! Your character will automatically and appropriately equip their favorite collectibles depending on where they are.\n|cFF0000Don't forget to bind your LoreWear show/hide clothes button!|r", 
	SI_LOREPLAY_PANEL_LE_SW_NAME					= "Toggle LoreWear On/Off", 
	SI_LOREPLAY_PANEL_LE_SW_TIPS					= "Turns on/off the automatic, contextual clothing that will be put on when entering the areas respective to your outfits.\n(Note: Disabling LoreWear displays all its settings as off, but will persist after re-enabling.)", 
	SI_LOREPLAY_PANEL_LE_EQUIP_WHILE_MOUNT_SW_NAME	= "Allow Equip While Mounted", 
	SI_LOREPLAY_PANEL_LE_EQUIP_WHILE_MOUNT_SW_TIPS	= "Turns on/off the automatic, contextual clothing that can be put on while riding your trusty steed.", 
	SI_LOREPLAY_PANEL_LE_USE_COSTUME_SW_NAME		= "Use Favorite Costume", 
	SI_LOREPLAY_PANEL_LE_USE_COSTUME_SW_TIPS		= "If enabled, uses your favorite costume in outfits, along with your other favrotie collectibles.\n|cFF0000Note|r: Use if you want to save 'None' as your favorite, treating the empty slot as a piece of your outfit.", 
	SI_LOREPLAY_PANEL_LE_USE_HAT_SW_NAME			= "Use Favorite Hat", 
	SI_LOREPLAY_PANEL_LE_USE_HAT_SW_TIPS			= "If enabled, uses your favorite hat in outfits, along with your other favorite collectibles.\n|cFF0000Note|r: Use if you want to save 'None' as your favorite, treating the empty slot as a piece of your outfit.", 
	SI_LOREPLAY_PANEL_LE_USE_HAIR_SW_NAME			= "Use Favorite Hair", 
	SI_LOREPLAY_PANEL_LE_USE_HAIR_SW_TIPS			= "If enabled, uses your favorite hair in outfits, along with your other favorite collecibles.\n|cFF0000Note|r: Use if you want to save 'None' as your favorite, treating the empty slot as a piece of your outfit.", 
	SI_LOREPLAY_PANEL_LE_USE_SKIN_SW_NAME			= "Use Favorite Skin", 
	SI_LOREPLAY_PANEL_LE_USE_SKIN_SW_TIPS			= "If enabled, uses your favorite skin in outfits, along with your other favorite collectibles.\n|cFF0000Note|r: Use if you want to save 'None' as your favorite, treating the empty slot as a piece of your outfit.", 
	SI_LOREPLAY_PANEL_LE_USE_POLYMORPH_SW_NAME		= "Use Favorite Polymorphs", 
	SI_LOREPLAY_PANEL_LE_USE_POLYMORPH_SW_TIPS		= "If enabled, uses your favorite polymorph in outfits, along with your other favorite collectibles.\n|cFF0000Note|r: Use if you want to save 'None' as your favorite, treating the empty slot as a piece of your outfit.", 
	SI_LOREPLAY_PANEL_LE_USE_FACIAL_ACC_SW_NAME		= "Use Favorite Facial Accessories", 
	SI_LOREPLAY_PANEL_LE_USE_FACIAL_ACC_SW_TIPS		= "If enabled, uses your favorite facial accessories in outfits, along with your other favorite collectibles.\n|cFF0000Note|r: Use if you want to save 'None' as your favorite, treating the empty slot as a piece of your outfit.", 
	SI_LOREPLAY_PANEL_LE_USE_FACIAL_HAIR_SW_NAME	= "Use Favorite Facial Hair", 
	SI_LOREPLAY_PANEL_LE_USE_FACIAL_HAIR_SW_TIPS	= "If enabled, uses your favorite facial hairs/horns in outfits, along with your other favorite collectibles.\n|cFF0000Note|r: Use if you want to save 'None' as your favorite, treating the empty slot as a piece of your outfit.", 
	SI_LOREPLAY_PANEL_LE_USE_BODY_MARKING_SW_NAME	= "Use Favorite Body Markings", 
	SI_LOREPLAY_PANEL_LE_USE_BODY_MARKING_SW_TIPS	= "If enabled, uses your favorite body markings in outfits, along with your other favorite collectibles.\n|cFF0000Note|r: Use if you want to save 'None' as your favorite, treating the empty slot as a piece of your outfit.", 
	SI_LOREPLAY_PANEL_LE_USE_HEAD_MARKING_SW_NAME	= "Use Favorite Head Markings", 
	SI_LOREPLAY_PANEL_LE_USE_HEAD_MARKING_SW_TIPS	= "If enabled, uses your favorite head markings in outfits, along with your other favorite collectibles.\n|cFF0000Note|r: Use if you want to save 'None' as your favorite, treating the empty slot as a piece of your outfit.", 
	SI_LOREPLAY_PANEL_LE_USE_JEWELRY_SW_NAME		= "Use Favorite Jewelry", 
	SI_LOREPLAY_PANEL_LE_USE_JEWELRY_SW_TIPS		= "If enabled, uses your favorite jewelry in outfits, along with your other favorite collectibles.\n|cFF0000Note|r: Use if you want to save 'None' as your favorite, treating the empty slot as a piece of your outfit.", 
	SI_LOREPLAY_PANEL_LE_USE_PERSONALITY_SW_NAME	= "Use Favorite Personalities", 
	SI_LOREPLAY_PANEL_LE_USE_PERSONALITY_SW_TIPS	= "If enabled, uses your favorite personalities in outfits, along with your other favorite collectibles.\n|cFF0000Note|r: Use if you want to save 'None' as your favorite, treating the empty slot as a piece of your outfit.", 
	SI_LOREPLAY_PANEL_LE_USE_PET_SW_NAME			= "Use Favorite Pets", 
	SI_LOREPLAY_PANEL_LE_USE_PET_SW_TIPS			= "If enabled, uses your favorite vanity pets in outfits, along with your other favorite collectibles.\n|cFF0000Note|r: Use if you want to save 'None' as your favorite, treating the empty slot as a piece of your outfit.", 
	SI_LOREPLAY_PANEL_LE_SET_OUTFIT_CITY_NAME		= "Set City Outfit", 
	SI_LOREPLAY_PANEL_LE_SET_OUTFIT_CITY_TIPS		= "Sets the current outfit (collectibles) your character is wearing as their city outfit, allowing for automatic collectible changing when entering a city.\nAlso saves |cFF0000empty slots|r if the 'Use Favorite ...' setting for that category is enabled!", 
	SI_LOREPLAY_PANEL_LE_SET_OUTFIT_HOUSING_NAME	= "Set Housing Outfit", 
	SI_LOREPLAY_PANEL_LE_SET_OUTFIT_HOUSING_TIPS	= "Sets the current outfit (collectibles) your character is wearing as their housing outfit, allowing for automatic collectible changing when entering a house.\nAlso saves |cFF0000empty slots|r if the 'Use Favorite ...' setting for that category is enabled!", 
	SI_LOREPLAY_PANEL_LE_SET_OUTFIT_DUNGEON_NAME	= "Set Dungeon Outfit", 
	SI_LOREPLAY_PANEL_LE_SET_OUTFIT_DUNGEON_TIPS	= "Sets the current outfit (collectibles) your character is wearing as their dungeon outfit, allowing for automatic collectible changing when entering a dungeon.\nAlso saves |cFF0000empty slots|r if the 'Use Favorite ...' setting for that category is enabled!", 
	SI_LOREPLAY_PANEL_LE_SET_OUTFIT_ADVENTURE_NAME	= "Set Adventure Outfit", 
	SI_LOREPLAY_PANEL_LE_SET_OUTFIT_ADVENTURE_TIPS	= "Sets the current outfit (collectibles) your character is wearing as their adventuring outfit, allowing for automatic collectible changing when running around the land of Tamriel.\nAlso saves |cFF0000empty slots|r if the 'Use Favorite ...' setting for that category is enabled!", 


}
for stringId, stringToAdd in pairs(strings) do
   ZO_CreateStringId(stringId, stringToAdd)
   SafeAddVersion(stringId, 1)
end


--[[
function languageTable.CreateZoneToRegionEmotesTable()
	languageTable.zoneToRegionEmotes = {
		["Auridon"] = LorePlay.defaultEmotesByRegion["ad1"],
		["Grahtwood"] = LorePlay.defaultEmotesByRegion["ad2"],
		["Greenshade"] = LorePlay.defaultEmotesByRegion["ad2"],
		["Khenarthi's Roost"] = LorePlay.defaultEmotesByRegion["ad1"],
		["Malabal Tor"] = LorePlay.defaultEmotesByRegion["ad2"],
		["Reaper's March"] = LorePlay.defaultEmotesByRegion["ad2"],
		["Alik'r Desert"] = LorePlay.defaultEmotesByRegion["dc1"],
		["Bangkorai"] = LorePlay.defaultEmotesByRegion["dc1"],
		["Betnikh"] = LorePlay.defaultEmotesByRegion["dc2"],
		["Glenumbra"] = LorePlay.defaultEmotesByRegion["dc2"],
		["Rivenspire"] = LorePlay.defaultEmotesByRegion["dc2"],
		["Stormhaven"] = LorePlay.defaultEmotesByRegion["dc2"],
		["Stros M'Kai"] = LorePlay.defaultEmotesByRegion["dc1"],
		["Bal Foyen"] = LorePlay.defaultEmotesByRegion["ep2"],
		["Bleakrock Isle"] = LorePlay.defaultEmotesByRegion["ep2"],
		["Deshaan"] = LorePlay.defaultEmotesByRegion["ep2"],
		["Eastmarch"] = LorePlay.defaultEmotesByRegion["ep1"],
		["The Rift"] = LorePlay.defaultEmotesByRegion["ep1"],
		["Shadowfen"] = LorePlay.defaultEmotesByRegion["ep3"],
		["Stonefalls"] = LorePlay.defaultEmotesByRegion["ep2"],
		["Coldharbour"] = LorePlay.defaultEmotesByRegion["ch"],
		["Craglorn"] = LorePlay.defaultEmotesByRegion["other"],
		["Cyrodiil"] = LorePlay.defaultEmotesByRegion["ip"],
		["Gold Coast"] = LorePlay.defaultEmotesByRegion["other"],
		["Hew's Bane"] = LorePlay.defaultEmotesByRegion["other"],
		["Murkmire"] = LorePlay.defaultEmotesByRegion["ep3"],
		["Bangkorai"] = LorePlay.defaultEmotesByRegion["dc1"],
		["Wrothgar"] = LorePlay.defaultEmotesByRegion["other"],
		["Vvardenfell"] = LorePlay.defaultEmotesByRegion["ep1"],
	}
end
]]

--[[
function languageTable.CreatePlayerTitles()
	languageTable.playerTitles = {
		["Emperor"] = "Emperor",
		["Empress"] = "Empress",
		["Former Emperor"] = "Former Emperor",
		["Former Empress"] = "Former Empress",
		["Ophidian Overlord"] = "Ophidian Overlord",
		["Savior of Nirn"] = "Savior of Nirn",
		["Daedric Lord Slayer"] = "Daedric Lord Slayer",
		["Tamriel Hero"] = "Tamriel Hero",
		["Maelstrom Arena Champion"] = "Maelstrom Arena Champion",
		["Dragonstar Arena Champion"] = "Dragonstar Arena Champion",
		["The Flawless Conqueror"] = "The Flawless Conqueror",
		["Stormproof"] = "Stormproof",
	}
end
]]


--[[
function languageTable.CreateEmotesByCityTable()
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


	languageTable.defaultEmotesByCity = {
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
		["Daggerfall Harbor District"] = {
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Daggerfall Trade District"] = {
			["Emotes"] = defaultCityToRegionEmotes["DC"]
		},
		["Castle Daggerfall"] = {
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
		},
		["Vivec City"] = {
			["Emotes"] = defaultCityToRegionEmotes["EP"]
		},
		["Seyda Neen"] = {
			["Emotes"] = defaultCityToRegionEmotes["EP"]
		},
		["Balmora"] = {
			["Emotes"] = defaultCityToRegionEmotes["EP"]
		},
		["Sadrith Mora"] = {
			["Emotes"] = defaultCityToRegionEmotes["EP"]
		},
	}

	-- Add Wayshrines
	local temp = {}
	for i,v in pairs(languageTable.defaultEmotesByCity) do
		local cityWayshrine = i.." Wayshrine"
		temp[i] = languageTable.defaultEmotesByCity[i]
		temp[cityWayshrine] = languageTable.defaultEmotesByCity[i]
	end
	languageTable.defaultEmotesByCity = temp

	-- Add special cases, such as name variations
	languageTable.defaultEmotesByCity["Mournhold Plaza of the Gods"] = {
		["Emotes"] = languageTable.defaultEmotesByCity["Mournhold"]["Emotes"]
	}

	languageTable.defaultEmotesByCity["Mournhold Banking District"] = {
		["Emotes"] = languageTable.defaultEmotesByCity["Mournhold"]["Emotes"]
	}

	languageTable.defaultEmotesByCity["Elden Root Services"] = {
		["Emotes"] = languageTable.defaultEmotesByCity["Elden Root"]["Emotes"]
	}

	languageTable.defaultEmotesByCity["Vivec Temple Wayshrine"] = {
		["Emotes"] = languageTable.defaultEmotesByCity["Vivec City"]["Emotes"]
	}
end
]]

-- ---
