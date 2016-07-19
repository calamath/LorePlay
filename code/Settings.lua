local Settings = LorePlay
local LAM2

local defaultSettingsTable = {
	isIdleEmotesOn = true,
	maraSpouseName = ""
}


function Settings.LoadSavedSettings()
	Settings.savedSettingsTable = defaultSettingsTable
	Settings.savedSettingsTable.isIdleEmotesOn = Settings.savedVariables.isIdleEmotesOn
	Settings.savedSettingsTable.maraSpouseName = Settings.savedVariables.maraSpouseName
end


function Settings.LoadMenuSettings()
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
			text = "|cFF0000Don't forget to bind your SmartEmotes button!|r\nContextual, appropriate emotes to perform at the touch of a button.\n",
			width = "full",
		},
		[3] = {
			type = "editbox",
			name = "Significant Other's Character Name",
			tooltip = "For those who have wed with the Ring of Mara, entering the exact character name of your loved one allows for special emotes between you two!\n(Note: Must be friends!)",
			getFunc = function() return Settings.savedSettingsTable.maraSpouseName end,
			setFunc = function(input)
				Settings.savedSettingsTable.maraSpouseName = input
				Settings.savedVariables.maraSpouseName = Settings.savedSettingsTable.maraSpouseName
			end,
			isMultiline = false,
			width = "full",
			default = "",
		},
		[4] = {
			type = "header",
			name = "Idle Emotes",
			width = "full",
		},
		[5] = {
			type = "description",
			title = nil,
			text = "Contextual, automatic emotes that occur when you go idle or AFK (Not moving, not fighting, not stealthing).\n",
			width = "full",
		},
		[6] = {
			type = "checkbox",
			name = "Toggle IdleEmotes On/Off",
			tooltip = "Turns on/off the automatic, contextual emotes that occur when you go idle or AFK.",
			getFunc = function() return Settings.savedSettingsTable.isIdleEmotesOn end,
			setFunc = function(setting) 
				Settings.savedSettingsTable.isIdleEmotesOn = setting
				Settings.savedVariables.isIdleEmotesOn = Settings.savedSettingsTable.isIdleEmotesOn
				if not Settings.savedSettingsTable.isIdleEmotesOn then LorePlay.UnregisterIdleEvents() end
				LorePlay.InitializeIdle()
				--ReloadUI() 
			end,
			width = "full",
		},
	}

	LAM2:RegisterAddonPanel("MyAddonOptions", panelData)
	LAM2:RegisterOptionControls("MyAddonOptions", optionsTable)
end


function Settings.InitializeSettings()
	Settings.savedVariables = ZO_SavedVars:New("LorePlaySavedVars", LorePlay.majorVersion, nil, defaultSettingsTable)
	Settings.LoadSavedSettings()
	LAM2 = LibStub("LibAddonMenu-2.0")
	Settings.LoadMenuSettings()
end

LorePlay = Settings