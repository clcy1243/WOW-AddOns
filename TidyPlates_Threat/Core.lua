local MODNAME, ns = ...
local t = ns.TidyPlates_Threat
local L = t.L
local class = t.Class()

TidyPlatesThreat = LibStub("AceAddon-3.0"):NewAddon("TidyPlatesThreat", "AceConsole-3.0", "AceEvent-3.0")

t.Print = function(val,override)
	local db = TidyPlatesThreat.db.profile
	if override or db.verbose then
		print("|cff89f559["..t.Meta("title").."]|r "..val)
	end
end

StaticPopupDialogs["SetToThreatPlates"] = {
	preferredIndex = STATICPOPUP_NUMDIALOGS,
	text = t.Meta("title")..L["key_SetThemePopup"],
	button1 = L["Yes"],
	button2 = L["Cancel"],
	button3 = L["No"],
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	OnAccept = function()
		TidyPlatesOptions.ActiveTheme = "Threat"
		TidyPlates:SetTheme("Threat")
		TidyPlatesThreat:StartUp()
	end,
	OnAlt = function()
		-- call twice to workaround a bug in Blizzard's function
		InterfaceOptionsFrame_OpenToCategory("Tidy Plates")
		InterfaceOptionsFrame_OpenToCategory("Tidy Plates")
	end,
	OnCancel = function()
		t.Print(L["-->>|cffff0000Activate Threat Plates from the Tidy Plates options!|r<<--"])
	end,
}

-- Callback Functions
function TidyPlatesThreat:OnProfileChanged()
	t.SetThemes(self)
	self:ConfigRefresh();
	self:StartUp();
end

function TidyPlatesThreat:isTank()
	return TidyPlatesThreat.db.char.specInfo.role == "TANK"
end

function TidyPlatesThreat:RoleText()
	if self:isTank() then
		return L["|cff00ff00tanking|r"]
	else
		return L["|cffff0000dpsing / healing|r"]
	end
end

function TidyPlatesThreat:SpecName()
	return self.db.char.specInfo.name
end

--[[Options and Default Settings]]--
function TidyPlatesThreat:OnInitialize()
	local defaults = {
		global = {
			version = "",
		},
		char = {
			welcome = false,
			specInfo = {
				index = nil,
				id = nil,
				name = "",
				role = "",
			},
			stances = {
				ON = false,
				[0] = false, -- No Stance
				[1] = false, -- Battle Stance
				[2] = true, -- Defensive Stance
				[3] = false -- Berserker Stance
			},
			shapeshifts = {
				ON = false,
				[0] = false, -- Caster Form
				[1] = true, -- Bear Form
				[2] = false, -- Cat Form
				[3] = false, -- Travel Form
				[4] = false, -- Moonkin Form, Tree of Life
			},
			presences = {
				ON = false,
				[0] = false, -- No Presence
				[1] = true, -- Blood
				[2] = false, -- Frost
				[3] = false -- Unholy
			},
			seals = {
				ON = false,
				[0] = false, -- No Aura
				[1] = true, -- Devotion Aura
				[2] = false, -- Retribution Aura
				[3] = false, -- Concentration Aura
				[4] = false, -- Resistance Aura
				[5] = false -- Crusader Aura
			},
		},
		profile = {
			OldSetting = true,
			verbose = true,
			blizzFadeA = {
				toggle = true,
				amount = -0.3
			},
			blizzFadeS = {
				toggle = true,
				amount = -0.3
			},
			tidyplatesFade = false,
			healthColorChange = false,
			allowClass = false,
			friendlyClass = true,
			friendlyClassIcon = false,
			castbarColor = {
				toggle = true,
				r = 1,
				g = 0.56,
				b = 0.06,
				a = 1
			},
			castbarColorShield = {
				toggle = true,
				r = 1,
				g = 0,
				b = 0,
				a = 1
			},
			aHPbarColor = {
				r = 0,
				g = 1,
				b = 0
			},
			bHPbarColor = {
				r = 1,
				g = 1,
				b = 0
			},
			friendlyHealthbarColor = {
				r = 0,
				g = 1,
				b = 0
			},
			enemyHealthbarColor = {
				r = 1,
				g = 0,
				b = 0
			},
			neutralHealthbarColor = {
				r = 1,
				g = 1,
				b = 0
			},
			tapHealthbarColor = {
				r = 0.5,
				g = 0.5,
				b = 0.5
			},
			text = {
				amount = true,
				percent = true,
				full = false,
				max = false,
				deficit = false,
				truncate = true,
				decimals = 1
			},
			totemWidget = {
				ON = true,
				scale = 35,
				x = 0,
				y = 35,
				level = 1,
				anchor = "CENTER"
			},
			arenaWidget = {
				ON = true,
				scale = 16,
				x = 36,
				y = -6,
				anchor = "CENTER",
				colors = {
					[1] = {
						r = 1,
						g = 0,
						b = 0,
						a = 1
					},
					[2] = {
						r = 1,
						g = 1,
						b = 0,
						a = 1
					},
					[3] = {
						r = 0,
						g = 1,
						b = 0,
						a = 1
					},
					[4] = {
						r = 0,
						g = 1,
						b = 1,
						a = 1
					},
					[5] = {
						r = 0,
						g = 0,
						b = 1,
						a = 1
					},
				},
				numColors = {
					[1] = {
						r = 1,
						g = 1,
						b = 1,
						a = 1
					},
					[2] = {
						r = 1,
						g = 1,
						b = 1,
						a = 1
					},
					[3] = {
						r = 1,
						g = 1,
						b = 1,
						a = 1
					},
					[4] = {
						r = 1,
						g = 1,
						b = 1,
						a = 1
					},
					[5] = {
						r = 1,
						g = 1,
						b = 1,
						a = 1
					},
				},
			},
			healerTracker = {
				ON = true,
				scale = 1,
				x = 0,
				y = 35,
				level = 1,
				anchor = "CENTER"
			},
			auraWidget = {
				ON = true,
				targetOnly = false,
				showFriendly = true,
				showEnemy = true,
				displays = {
					[1] = true,
					[2] = true,
					[3] = true,
					[4] = true,
					[5] = true,
					[6] = true
				},
				columns = 4,
				rows = 2,
				iconWidth = 25,
				iconHeight = 18,
				iconOffsetX = 3,
				iconOffsetY = 5,
				scale = 1,
				x = 8,
				y = 8,
				radialCooldown = true,
				iconBorder = true,
				anchor = "CENTER",
				mode = "all",
				filter = {},
				allow = {"Demonic Vision"},
			},
			uniqueWidget = {
				ON = true,
				scale = 35,
				x = 0,
				y = 35,
				level = 1,
				anchor = "CENTER"
			},
			classWidget = {
				ON = true,
				scale = 22,
				x = -74,
				y = -7,
				theme = "default",
				anchor = "CENTER",
			},
			targetWidget = {
				ON = true,
				theme = "default",
				r = 1,
				g = 1,
				b = 1,
				a = 1
			},
			questWidget = {
				ON = true,
				scale = 22,
				x = -55,
				y = 9,
				anchor = "CENTER",
			},
			threatWidget = {
				ON = false,
				x = 0,
				y = 26,
				anchor = "CENTER",
			},
			tankedWidget = {
				ON = false,
				scale = 18,
				x = -55,
				y = 10,
				anchor = "CENTER",
			},
			comboWidget = {
				ON = false,
				scale = 1,
				x = 0,
				y = -8,
			},
			eliteWidget = {
				ON = true,
				theme = "default",
				scale = 15,
				x = 64,
				y = 9,
				anchor = "CENTER"
			},
			socialWidget = {
				ON = false,
				scale = 16,
				x = 65,
				y = 6,
				anchor = "CENTER",
			},
			totemSettings = {
				hideHealthbar = false,
			--	["Reference"] = {allow totem nameplate, allow hp color, r, g, b, show icon, style}
				["T1"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T2"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T3"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T4"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T5"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T6"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T7"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T8"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T9"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T10"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T11"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T12"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T13"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T14"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T15"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T16"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T17"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T18"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
				["T19"] = {true,true,true,nil, nil, nil,"normal",color = {r = 0.58,g = 0.72,b = 1}},
			},
			uniqueSettings = {
				list = {},
				["**"] = {
					name = "",
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "",
					scale = 1,
					alpha = 1,
					color = {
						r = 1,
						g = 1,
						b = 1
					},
				},
				[1] = {
					name = L["Shadow Fiend"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U1",
					scale = 0.45,
					alpha = 1,
					color = {
						r = 0.61,
						g = 0.40,
						b = 0.86
					},
				},
				[2] = {
					name = L["Spirit Wolf"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U2",
					scale = 0.45,
					alpha = 1,
					color = {
						r = 0.32,
						g = 0.7,
						b = 0.89
					},
				},
				[3] = {
					name = L["Ebon Gargoyle"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U3",
					scale = 0.45,
					alpha = 1,
					color = {
						r = 1,
						g = 0.71,
						b = 0
					},
				},
				[4] = {
					name = L["Water Elemental"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U4",
					scale = 0.45,
					alpha = 1,
					color = {
						r = 0.33,
						g = 0.72,
						b = 0.44
					},
				},
				[5] = {
					name = L["Treant"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U5",
					scale = 0.45,
					alpha = 1,
					color = {
						r = 1,
						g = 0.71,
						b = 0
					},
				},
				[6] = {
					name = L["Viper"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U6",
					scale = 0.45,
					alpha = 1,
					color = {
						r = 0.39,
						g = 1,
						b = 0.11
					},
				},
				[7] = {
					name = L["Venomous Snake"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U6",
					scale = 0.45,
					alpha = 1,
					color = {
						r = 0.75,
						g = 0,
						b = 0.02
					},
				},
				[8] = {
					name = L["Army of the Dead Ghoul"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U7",
					scale = 0.45,
					alpha = 1,
					color = {
						r = 0.87,
						g = 0.78,
						b = 0.88
					},
				},
				[9] = {
					name = L["Shadowy Apparition"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U8",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.62,
						g = 0.19,
						b = 1
					},
				},
				[10] = {
					name = L["Shambling Horror"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U9",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.69,
						g = 0.26,
						b = 0.25
					},
				},
				[11] = {
					name = L["Web Wrap"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U10",
					scale = 0.75,
					alpha = 1,
					color = {
						r = 1,
						g = 0.39,
						b = 0.96
					},
				},
				[12] = {
					name = L["Immortal Guardian"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U11",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.33,
						g = 0.33,
						b = 0.33
					},
				},
				[13] = {
					name = L["Marked Immortal Guardian"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U12",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.75,
						g = 0,
						b = 0.02
					},
				},
				[14] = {
					name = L["Empowered Adherent"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U13",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.29,
						g = 0.11,
						b = 1
					},
				},
				[15] = {
					name = L["Deformed Fanatic"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U14",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.55,
						g = 0.7,
						b = 0.29
					},
				},
				[16] = {
					name = L["Reanimated Adherent"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U15",
					scale = 1,
					alpha = 1,
					color = {
						r = 1,
						g = 0.88,
						b = 0.61
					},
				},
				[17] = {
					name = L["Reanimated Fanatic"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U15",
					scale = 1,
					alpha = 1,
					color = {
						r = 1,
						g = 0.88,
						b = 0.61
					},
				},
				[18] = {
					name = L["Bone Spike"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U16",
					scale = 1,
					alpha = 1,
					color = {
						r = 1,
						g = 1,
						b = 1
					},
				},
				[19] = {
					name = L["Onyxian Whelp"],
					showNameplate = false,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U17",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.33,
						g = 0.28,
						b = 0.71
					},
				},
				[20] = {
					name = L["Gas Cloud"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U18",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.96,
						g = 0.56,
						b = 0.07
					},
				},
				[21] = {
					name = L["Volatile Ooze"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U19",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.36,
						g = 0.95,
						b = 0.33
					},
				},
				[22] = {
					name = L["Darnavan"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U20",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.78,
						g = 0.61,
						b = 0.43
					},
				},
				[23] = {
					name = L["Val'kyr Shadowguard"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U21",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.47,
						g = 0.89,
						b = 1
					},
				},
				[24] = {
					name = L["Kinetic Bomb"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U22",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.91,
						g = 0.71,
						b = 0.1
					},
				},
				[25] = {
					name = L["Lich King"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U23",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.77,
						g = 0.12,
						b = 0.23
					},
				},
				[26] = {
					name = L["Raging Spirit"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U24",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.77,
						g = 0.27,
						b = 0
					},
				},
				[27] = {
					name = L["Drudge Ghoul"],
					showNameplate = true,
					showIcon = false,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U25",
					scale = 0.85,
					alpha = 1,
					color = {
						r = 0.43,
						g = 0.43,
						b = 0.43
					},
				},
				[28] = {
					name = L["Living Inferno"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U27",
					scale = 1,
					alpha = 1,
					color = {
						r = 0,
						g = 1,
						b = 0
					},
				},
				[29] = {
					name = L["Living Ember"],
					showNameplate = true,
					showIcon = false,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U28",
					scale = 0.60,
					alpha = 0.75,
					color = {
						r = 0.25,
						g = 0.25,
						b = 0.25
					},
				},
				[30] = {
					name = L["Fanged Pit Viper"],
					showNameplate = false,
					showIcon = false,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "",
					scale = 0,
					alpha = 0,
					color = {
						r = 1,
						g = 1,
						b = 1
					},
				},
				[31] = {
					name = L["Canal Crab"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U29",
					scale = 1,
					alpha = 1,
					color = {
						r = 0,
						g = 1,
						b = 1
					},
				},
				[32] = {
					name = L["Muddy Crawfish"],
					showNameplate = true,
					showIcon = true,
					useStyle = true,
					useColor = true,
					allowMarked = true,
					overrideScale = false,
					overrideAlpha = false,
					icon = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\UniqueIconWidget\\U30",
					scale = 1,
					alpha = 1,
					color = {
						r = 0.96,
						g = 0.36,
						b = 0.34
					},
				},
				[33] = {},
				[34] = {},
				[35] = {},
				[36] = {},
				[37] = {},
				[38] = {},
				[39] = {},
				[40] = {},
				[41] = {},
				[42] = {},
				[43] = {},
				[44] = {},
				[45] = {},
				[46] = {},
				[47] = {},
				[48] = {},
				[49] = {},
				[50] = {},
				[51] = {},
				[52] = {},
				[53] = {},
				[54] = {},
				[55] = {},
				[56] = {},
				[57] = {},
				[58] = {},
				[59] = {},
				[60] = {},
				[61] = {},
				[62] = {},
				[63] = {},
				[64] = {},
				[65] = {},
				[66] = {},
				[67] = {},
				[68] = {},
				[69] = {},
				[70] = {},
				[71] = {},
				[72] = {},
				[73] = {},
				[74] = {},
				[75] = {},
				[76] = {},
				[77] = {},
				[78] = {},
				[79] = {},
				[80] = {},
				[81] = {},
				[82] = {},
				[83] = {},
				[84] = {},
				[85] = {},
				[86] = {},
				[87] = {},
				[88] = {},
				[89] = {},
				[90] = {},
				[91] = {},
				[92] = {},
				[93] = {},
				[94] = {},
				[95] = {},
				[96] = {},
				[97] = {},
				[98] = {},
				[99] = {},
				[100] = {},
			},
			settings = {
				frame = {
					x = 0,
					y = -15,
				},
				highlight = {
					texture = "TP_HealthBarHighlight",
				},
				elitehealthborder = {
					texture = "TP_HealthBarEliteOverlay",
					show = true,
				},
				healthborder = {
					texture = "TP_HealthBarOverlay",
					backdrop = "",
					show = true,
				},
				threatborder = {
					show = true,
				},
				healthbar = {
					texture = "ThreatPlatesBar",
				},
				castnostop = {
					texture = "TP_CastBarLock",
					x = 0,
					y = -15,
					show = true,
				},
				castborder = {
					texture = "TP_CastBarOverlay",
					x = 0,
					y = -15,
					show = true,
				},
				castbar = {
					texture = "ThreatPlatesBar",
					x = 0,
					y = -15,
					show = true,
				},
				name = {
					typeface = "Accidental Presidency",
					width = 120,
					height = 14,
					size = 14,
					x = 0,
					y = 13,
					align = "CENTER",
					vertical = "CENTER",
					shadow = true,
					flags = "NONE",
					colorFriendlyClass = false,
					colorEnemyClass = false,
					colorByReaction = false,
					color = {
						r = 1,
						g = 1,
						b = 1
					},
					show = true,
				},
				level = {
					typeface = "Accidental Presidency",
					size = 12,
					width = 20,
					height = 14,
					x = 50,
					y = 0,
					align = "RIGHT",
					vertical = "TOP",
					shadow = true,
					flags = "NONE",
					show = true,
				},
				eliteicon = {
					show = true,
					theme = "default",
					scale = 15,
					x = 64,
					y = 9,
					level = 22,
					anchor = "CENTER"
				},
				customtext = {
					typeface = "Accidental Presidency",
					size = 12,
					width = 110,
					height = 14,
					x = 0,
					y = 1,
					align = "CENTER",
					vertical = "CENTER",
					shadow = true,
					flags = "NONE",
					show = true,
				},
				spelltext = {
					typeface = "Accidental Presidency",
					size = 12,
					width = 110,
					height = 14,
					x = 0,
					y = -13,
					align = "CENTER",
					vertical = "CENTER",
					shadow = true,
					flags = "NONE",
					show = true,
				},
				raidicon = {
					scale = 20,
					x = 0,
					y = 30,
					anchor = "CENTER",
					hpColor = true,
					show = true,
					hpMarked = {
						["STAR"] = {
							r = 0.85,
							g = 0.81,
							b = 0.27
						},
						["MOON"] = {
							r = 0.60,
							g = 0.75,
							b = 0.85
						},
						["CIRCLE"] = {
							r = 0.93,
							g = 0.51,
							b = 0.06
						},
						["SQUARE"] = {
							r = 0,
							g = 0.64,
							b = 1
						},
						["DIAMOND"] = {
							r = 0.7,
							g = 0.06,
							b = 0.84
						},
						["CROSS"] = {
							r = 0.82,
							g = 0.18,
							b = 0.18
						},
						["TRIANGLE"] = {
							r = 0.14,
							g = 0.66,
							b = 0.14
						},
						["SKULL"] = {
							r = 0.89,
							g = 0.83,
							b = 0.74
						},
					},
				},
				spellicon = {
					scale = 20,
					x = 75,
					y = -7,
					anchor = "CENTER",
					show = true,
				},
				customart = {
					scale = 22,
					x = -74,
					y = -7,
					anchor = "CENTER",
					show = true,
				},
				skullicon = {
					scale = 16,
					x = 55,
					y = 0,
					anchor = "CENTER",
					show = true,
				},
				unique = {
					threatcolor = {
						LOW = {
							r = 0,
							g = 0,
							b = 0,
							a = 0
						},
						MEDIUM = {
							r = 0,
							g = 0,
							b = 0,
							a = 0
						},
						HIGH = {
							r = 0,
							g = 0,
							b = 0,
							a = 0
						},
					},
				},
				totem = {
					threatcolor = {
						LOW = {
							r = 0,
							g = 0,
							b = 0,
							a = 0
						},
						MEDIUM = {
							r = 0,
							g = 0,
							b = 0,
							a = 0
						},
						HIGH = {
							r = 0,
							g = 0,
							b = 0,
							a = 0
						},
					},
				},
				normal = {
					threatcolor = {
						LOW = {
							r = 1,
							g = 1,
							b = 1,
							a = 1
						},
						MEDIUM = {
							r = 1,
							g = 1,
							b = 0,
							a = 1
						},
						HIGH = {
							r = 1,
							g = 0,
							b = 0,
							a = 1
						},
					},
				},
				dps = {
					threatcolor = {
						LOW = {
							r = 0,
							g = 1,
							b = 0,
							a = 1
						},
						MEDIUM = {
							r = 1,
							g = 1,
							b = 0,
							a = 1
						},
						HIGH = {
							r = 1,
							g = 0,
							b = 0,
							a = 1
						},
					},
				},
				tank = {
					threatcolor = {
						LOW = {
							r = 1,
							g = 0,
							b = 0,
							a = 1
						},
						MEDIUM = {
							r = 1,
							g = 1,
							b = 0,
							a = 1
						},
						HIGH = {
							r = 0,
							g = 1,
							b = 0,
							a = 1
						},
						OTHERTANK = {
							r = 0,
							g = 0.8,
							b = 1,
							a = 1
						},
					},
				},
			},
			textOnly = {
				ON = false,
				blizzFadeA = true,
				overrideAlpha = true,
				alpha = 1,
				friendlyPlayer = false,
				friendlyNPC = true,
				neutralUnit = false,
				miniMobsUnit = false,
				name = {
					classColor = true,
					colorByReaction = true,
					color = {
						r = 0,
						g = 1,
						b = 0,
					},
					typeface = "Accidental Presidency",
					shadow = true,
					flags = "NONE",
					size = 12,
					width = 180,
					height = 12,
					x = 0,
					y = 13,
					align = "CENTER",
					vertical = "CENTER",
				},
				customtext = {
					showRole = true,
					showGuild = true,
					color = {
						r = 1,
						g = 1,
						b = 1,
					},
					typeface = "Accidental Presidency",
					shadow = true,
					flags = "NONE",
					size = 11,
					width = 200,
					height = 11,
					x = 0,
					y = 1,
					align = "CENTER",
					vertical = "CENTER",
				},
			},
			threat = {
				ON = true,
				marked = false,
				useType = true,
				useScale = true,
				useAlpha = true,
				useHPColor = true,
				art = {
					ON = true,
					theme = "default",
				},
				scaleType = {
					["Normal"] = -0.2,
					["Elite"] = 0,
					["Boss"] = 0.2
				},
				toggle = {
					["nonCombat"] = false,
					["Boss"] = true,
					["Elite"] = true,
					["Normal"] = true,
					["Neutral"] = true,
					["Tapped"] = true
				},
				dps = {
					scale = {
						LOW = 0.8,
						MEDIUM = 0.9,
						HIGH = 1.25
					},
					alpha = {
						LOW = 1,
						MEDIUM = 1,
						HIGH = 1
					},
				},
				tank = {
					scale = {
						LOW = 1.25,
						MEDIUM = 0.9,
						HIGH = 0.8,
						OTHERTANK = 0.8
					},
					alpha = {
						LOW = 1,
						MEDIUM = 0.85,
						HIGH = 0.75,
						OTHERTANK = 0.75
					},
				},
				marked = {
					art = false,
				},
			},
			nameplate = {
				toggle = {
					["Boss"] = true,
					["Elite"] = true,
					["Normal"] = true,
					["Neutral"] = true,
					["Tapped"] = true,
					["TargetA"] = false, -- Custom Target Alpha
					["NoTargetA"] = false, -- Custom Target Alpha
					["TargetS"] = false, -- Custom Target Scale
					["NoTargetS"] = false, -- Custom Target Alpha
					["MarkedA"] = false,
					["MarkedS"] = false
				},
				scale = {
					["Target"] = 1,
					["NoTarget"] = 1,
					["Totem"] = 0.75,
					["Boss"] = 1.1,
					["Elite"] = 1.04,
					["Normal"] = 1,
					["Neutral"] = 0.9,
					["Tapped"] = 0.9,
					["Marked"] = 1,
					["Allied"] = 1,
					["Pet"] = 0.75,
					["Guardian"] = 0.65,
				},
				alpha = {
					["Target"] = 1,
					["NoTarget"] = 1,
					["Totem"] = 1,
					["Boss"] = 1,
					["Elite"] = 1,
					["Normal"] = 1,
					["Neutral"] = 1,
					["Tapped"] = 1,
					["Marked"] = 1,
					["Allied"] = 1,
					["Pet"] = 1,
					["Guardian"] = 1,
				},
			},
		}
	}
	local db = LibStub('AceDB-3.0'):New('TidyPlatesThreatDB', defaults, 'Default')
	self.db = db

	local RegisterCallback = db.RegisterCallback

	RegisterCallback(self, 'OnProfileChanged', 'OnProfileChanged')
	RegisterCallback(self, 'OnProfileCopied', 'OnProfileChanged')
	RegisterCallback(self, 'OnProfileReset', 'OnProfileChanged')

	self:SetUpInitialOptions()
end

local function ShowConfigPanel()
	TidyPlatesThreat:OpenOptions()
end
------------
-- EVENTS --
------------
function TidyPlatesThreat:SetSpecInfo()
	local oldId = self.db.char.specInfo.id

	local specIndex, id, name, role = t.ActiveInfo()
	self.db.char.specInfo.index = specIndex
	if id ~= nil then
		self.db.char.specInfo.id = id
		self.db.char.specInfo.name = name
		self.db.char.specInfo.role = role
	end

	if oldId ~= id and self.db.profile.verbose then
		t.Print(L["Player spec change detected"] .. ": |cff" .. t.HCC[class] .. self:SpecName() .. "|r, " .. L["you are now in your "] .. self:RoleText() .. L[" role."])
	end

	t.Update()
end

------------------
-- ADDON LOADED --
------------------
function TidyPlatesThreat:OnEnable()
	local ProfDB = self.db.profile
	local setup = {
		SetStyle = self.SetStyle,
		SetScale = self.SetScale,
		SetAlpha = self.SetAlpha,
		SetCustomText = self.SetCustomText,
		SetNameColor = self.SetNameColor,
		SetThreatColor = self.SetThreatColor,
		SetCastbarColor = self.SetCastbarColor,
		SetHealthbarColor = self.SetHealthbarColor,
		OnInitialize = ThreatPlatesWidgets.CreateWidgets,
		OnUpdate = ThreatPlatesWidgets.UpdatePlate,
		OnContextUpdate = ThreatPlatesWidgets.UpdatePlate,
		ShowConfigPanel = ShowConfigPanel,
	}
	TidyPlatesThemeList["Threat"] = setup

	if ProfDB.tidyplatesFade then
		TidyPlates:EnableFadeIn()
	else
		TidyPlates:DisableFadeIn()
	end

	if TidyPlatesThreat.db.profile.textOnly.ON then
		C_NamePlate.SetNamePlateFriendlyClickThrough(true)
	else
		C_NamePlate.SetNamePlateFriendlyClickThrough(false)
	end

	self:SetCvars()
	self:SetSpecInfo()
	self:StartUp()

	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self:RegisterEvent('PLAYER_LOGOUT')
	self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')

	self.db.profile.cache = {}
	if self.db.char.welcome and (TidyPlates:GetThemeName() == "Threat") then
		t.Print(L["Welcome back"].." |cff"..t.HCC[class]..UnitName("player").."|r!")
	end
	if class == "WARRIOR" or class == "DRUID" or class == "DEATHKNIGHT" or class == "PALADIN" then
		self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	end
end

function TidyPlatesThreat:StartUp()
	if not self.db.char.welcome then
		self.db.char.welcome = true
		t.Print(L["key_FirstWelcome"]..t.HCC[class]..self:SpecName().." "..UnitClass("player").."|r|cff89F559.|r\n")
		t.Print(L["|cff89f559Additional options can be found by typing |r'/tptp'|cff89F559.|r"])
		if (TidyPlates:GetThemeName() ~= "Threat") then
			StaticPopup_Show("SetToThreatPlates")
		end
	end

	t.SetThemes(self)
	t.Update()
end

function TidyPlatesThreat:PLAYER_ENTERING_WORLD()
	local _,type = IsInInstance()
	local ProfDB = self.db.profile
	if type == "pvp" or type == "arena" then
		ProfDB.OldSetting = ProfDB.threat.ON
		ProfDB.threat.ON = false
	else
		ProfDB.threat.ON = ProfDB.OldSetting
	end
end

function TidyPlatesThreat:PLAYER_LOGOUT(...)
	self.db.profile.cache = {}
end

local set = false
function TidyPlatesThreat:SetCvars()
	if not set then
		local ProfDB = self.db.profile

		SetCVar("ShowClassColorInNameplate", 1)

		if ProfDB.threat.ON then
			SetCVar("threatWarning", 3)
		else
			SetCVar("threatWarning", 0)
		end

		if GetCVar("nameplateShowEnemyTotems") == "1" then
			ProfDB.nameplate.toggle["Totem"] = true
		else
			ProfDB.nameplate.toggle["Totem"] = false
		end

		if GetCVar("ShowVKeyCastbar") == "1" then
			ProfDB.settings.castbar.show = true
		else
			ProfDB.settings.castbar.show = false
		end

		set = true
	end
end

function TidyPlatesThreat:UPDATE_SHAPESHIFT_FORM()
	--self.ShapeshiftUpdate()
end

function TidyPlatesThreat:ACTIVE_TALENT_GROUP_CHANGED()
	self:SetSpecInfo()
end

t.GetReactionColor = function(unit)
	local db = TidyPlatesThreat.db.profile
	local c

	if unit.isTapped then
		c = db["tapHealthbarColor"]
	elseif unit.reaction == "FRIENDLY" then
		c = db["friendlyHealthbarColor"]
	elseif unit.reaction == "NEUTRAL" then
		c = db["neutralHealthbarColor"]
	else
		c = db["enemyHealthbarColor"]
	end

	return c
end
