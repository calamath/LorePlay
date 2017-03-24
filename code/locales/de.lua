--[[
	###################################################################
	A huge thank you to @iladrion for providing this de_ translation of
	LorePlay!
	###################################################################
]]--


languageTable = {}

function languageTable.CreateZoneToRegionEmotesTable()
	languageTable.zoneToRegionEmotes = {
		["Auridon"] = LorePlay.defaultEmotesByRegion["ad1"],
		["Grahtwald"] = LorePlay.defaultEmotesByRegion["ad2"],
		["Grünschatten"] = LorePlay.defaultEmotesByRegion["ad2"],
		["Khenarthis Rast"] = LorePlay.defaultEmotesByRegion["ad1"],
		["Malabal Tor"] = LorePlay.defaultEmotesByRegion["ad2"],
		["Schnittermark"] = LorePlay.defaultEmotesByRegion["ad2"],
		["Alik'r-Wüste"] = LorePlay.defaultEmotesByRegion["dc1"],
		["Bangkorai"] = LorePlay.defaultEmotesByRegion["dc1"],
		["Betnikh"] = LorePlay.defaultEmotesByRegion["dc2"],
		["Glenumbra"] = LorePlay.defaultEmotesByRegion["dc2"],
		["Kluftspitze"] = LorePlay.defaultEmotesByRegion["dc2"],
		["Sturmhafen"] = LorePlay.defaultEmotesByRegion["dc2"],
		["Stros M'Kai"] = LorePlay.defaultEmotesByRegion["dc1"],
		["Bal Foyen"] = LorePlay.defaultEmotesByRegion["ep2"],
		["Ödfels"] = LorePlay.defaultEmotesByRegion["ep2"],
		["Deshaan"] = LorePlay.defaultEmotesByRegion["ep2"],
		["Ostmarsch"] = LorePlay.defaultEmotesByRegion["ep1"],
		["Rift"] = LorePlay.defaultEmotesByRegion["ep1"],
		["Schattenfenn"] = LorePlay.defaultEmotesByRegion["ep3"],
		["Steinfälle"] = LorePlay.defaultEmotesByRegion["ep2"],
		["Kalthafen"] = LorePlay.defaultEmotesByRegion["ch"],
		["Kargstein"] = LorePlay.defaultEmotesByRegion["other"],
		["Cyrodiil"] = LorePlay.defaultEmotesByRegion["ip"],
		["Die Goldküste"] = LorePlay.defaultEmotesByRegion["other"],
		["Hews Fluch"] = LorePlay.defaultEmotesByRegion["other"],
		["Murkmire"] = LorePlay.defaultEmotesByRegion["ep3"],
		["Bangkorai"] = LorePlay.defaultEmotesByRegion["dc1"],
		["Wrothgar"] = LorePlay.defaultEmotesByRegion["other"],
	}
end


function languageTable.CreatePlayerTitles()
	languageTable.playerTitles = {
		["Kaiser"] = "Emperor",
		["Kaiserin"] = "Empress",
		["Ehemaliger Kaiser"] = "Former Emperor",
		["Ehemalige Kaiserin"] = "Former Empress",
		["Ophidischer Befehlshaber"] = "Ophidian Overlord", 
		["Ophidische Befehlshaberin"] = "Ophidian Overlord",
		["Retter von Nirn"] = "Savior of Nirn",
		["Retterin von Nirn"] = "Savior of Nirn",
		["Schlächter der Daedraherren"] = "Daedric Lord Slayer",
		["Schlächterin der Daedraherren"] = "Daedric Lord Slayer",
		["Held von Tamriel"] = "Tamriel Hero",
		["Heldin von Tamriel"] = "Tamriel Hero",
		["Champion der Mahlstrom-Arena"] = "Maelstrom Arena Champion",
		["Champion der Drachenstern-Arena"] = "Dragonstar Arena Champion",
		["makeloser Eroberer"] = "The Flawless Conqueror",
		["makelose Eroberin"] = "The Flawless Conqueror"
	}
end