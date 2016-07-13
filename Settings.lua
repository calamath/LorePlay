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
			width = "full",
		},
		[2] = {
			type = "description",
			title = nil,
			text = "|cFF0000Don't forget to bind your SmartEmotes button!|r\nContextual, appropriate emotes to perform at the touch of a button.",
			width = "full",
		},
		[3] = {
			type = "header",
			name = "Idle Emotes",
			width = "full",
		},
		[4] = {
			type = "description",
			title = nil,
			text = "Contextual, automatic emotes that occur when you go idle or AFK (Not moving, not fighting, not stealthing).",
			width = "full",
		},
		[5] = {
			type = "checkbox",
			name = "Toggle IdleEmotes On/Off",
			tooltip = "Turns on/off the automatic emotes that occur when you go idle or AFK.",
			getFunc = function() return Settings.savedVariables.isIdleEmotesOn end,
			setFunc = function(setting) Settings.savedVariables.isIdleEmotesOn = setting ReloadUI() end,
			width = "full",
			warning = "Will ReloadUI.",
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