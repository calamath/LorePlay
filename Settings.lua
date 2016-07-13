local Settings = LorePlay
local LAM2

local defaultSettingsTable = {
	isIdleEmotesOn = true
}


function Settings.LoadSettings()
	local panelData = {
		type = "panel",
		name = LorePlay.name,
		displayName = "|c8c7037LorePlay",
		author = "Justinon",
		version = LorePlay.version,
		registerForRefresh = true,
		registerForDefaults = true,
	}


	local optionsTable = {
		[1] = {
			type = "header",
			name = "Smart Emotes",
			width = "full",	--or "half" (optional)
		},
		[2] = {
			type = "description",
			--title = "My Title",	--(optional)
			title = nil,	--(optional)
			text = "|cFF0000Don't forget to bind your SmartEmotes button!|r\nContextual, appropriate emotes to perform at the touch of a button.",
			width = "full",	--or "half" (optional)
		},
		[3] = {
			type = "header",
			name = "Idle Emotes",
			width = "full",	--or "half" (optional)
		},
		[4] = {
			type = "description",
			--title = "My Title",	--(optional)
			title = nil,	--(optional)
			text = "Contextual, automatic emotes that occur when you go idle or AFK.",
			width = "full",	--or "half" (optional)
		},
		[5] = {
			type = "checkbox",
			name = "Toggle IdleEmotes On/Off",
			tooltip = "Turns on/off the automatic emotes that occur when you go idle or AFK.",
			getFunc = function() return Settings.savedVariables.isIdleEmotesOn end,
			setFunc = function(setting) Settings.savedVariables.isIdleEmotesOn = setting ReloadUI() end,
			width = "full",	--or "half" (optional)
			warning = "Will ReloadUI.",	--(optional)
		},
	}

	LAM2:RegisterAddonPanel("MyAddonOptions", panelData)
	LAM2:RegisterOptionControls("MyAddonOptions", optionsTable)
end


function Settings.InitializeSettings()
	Settings.savedVariables = ZO_SavedVars:New("LorePlaySavedVars", LorePlay.majorVersion, nil, defaultSettingsTable)
	LAM2 = LibStub("LibAddonMenu-2.0")
	Settings.LoadSettings()
end

LorePlay = Settings