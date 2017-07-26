local _, ns = ...
local t = ns.TidyPlates_Threat
local L = t.L
local class = t.Class()
local path = t.Art

local TidyPlatesThreat = LibStub("AceAddon-3.0"):GetAddon("TidyPlatesThreat");
local db;

-- Functions
local function UpdateSpecial() -- Need to add a way to update options table.
	db.uniqueSettings.list = {};
	for k_c,k_v in pairs(db.uniqueSettings) do
		if db.uniqueSettings[k_c].name then
			if type(db.uniqueSettings[k_c].name) == "string" then
				db.uniqueSettings.list[k_c] = db.uniqueSettings[k_c].name
			end
		end
	end
	t.Update()
end

t.UpdateSpecial = UpdateSpecial

local function GetValue(info)
	local DB = TidyPlatesThreat.db.profile
	local value = DB
	local keys = info.arg
	for index = 1, #keys do
		value = value[keys[index]]
	end
	return value
end

local function SetValue(info, value)
	local DB = TidyPlatesThreat.db.profile
	local keys = info.arg
	for index = 1, #keys - 1 do
		DB = DB[keys[index]]
	end
	DB[keys[#keys]] = value
	t.Update()
end

local function GetValueChar(info)
	local DB = TidyPlatesThreat.db.char
	local value = DB
	local keys = info.arg
	for index = 1, #keys do
		value = value[keys[index]]
	end
	return value
end

local function SetValueChar(info, value)
	local DB = TidyPlatesThreat.db.char
	local keys = info.arg
	for index = 1, #keys - 1 do
		DB = DB[keys[index]]
	end
	DB[keys[#keys]] = value
	t.Update()
end

local function GetCVarNumber(info)
	local value = GetCVar(info.arg) * 1
	return value
end

local function SetCvarNumber(info, value)
	if InCombatLockdown() then
		t.Print("We're unable to change this while in combat")
	else
		SetCVar(info.arg, value)
		t.Update()
	end
end

local function GetCvar(info)
	local value = GetCVar(info.arg)
	if value == "1" then
		return true
	else
		return false
	end
end

local function SetCvar(info)
	if InCombatLockdown() then
		t.Print("We're unable to change this while in combat")
	else
		local value = abs(GetCVar(info.arg) - 1)
		SetCVar(info.arg,value)
		t.Update()
	end
end

-- Colors

local function GetColor(info)
	local DB = TidyPlatesThreat.db.profile
	local value = DB
	local keys = info.arg
	for index = 1, #keys do
		value = value[keys[index]]
	end
	return value.r,value.g,value.b
end

local function SetColor(info, r, g, b)
	local DB = TidyPlatesThreat.db.profile
	local keys = info.arg
	for index = 1, #keys - 1 do
		DB = DB[keys[index]]
	end
	DB[keys[#keys]].r, DB[keys[#keys]].g, DB[keys[#keys]].b = r,g,b
	t.Update()
end

local function GetColorAlpha(info)
	local DB = TidyPlatesThreat.db.profile
	local value = DB
	local keys = info.arg
	for index = 1, #keys do
		value = value[keys[index]]
	end
	return value.r,value.g,value.b,value.a
end

local function SetColorAlpha(info, r, g, b, a)
	local DB = TidyPlatesThreat.db.profile
	local keys = info.arg
	for index = 1, #keys - 1 do
		DB = DB[keys[index]]
	end
	DB[keys[#keys]].r, DB[keys[#keys]].g, DB[keys[#keys]].b, DB[keys[#keys]].a = r,g,b,a
	t.Update()
end

-- Set Theme Values

local function SetThemeValue(info, val)
	SetValue(info,val)
	t.SetThemes(TidyPlatesThreat)
	t.Update()
end

-- Return the Options table
local options = nil;
local function GetOptions()
	if not options then
		options = {
			name = t.Meta("title").." "..t.Meta("version"),
			handler = TidyPlatesThreat,
			type = "group",
			childGroups = "tab",
			get = GetValue,
			set = SetValue,
			args = {
			-- Config Guide
				NameplateSettings = {
					name = L["Nameplate Settings"],
					type = "group",
					order = 10,
					args = {
						GeneralSettings = {
							name = L["General Settings"],
							type = "group",
							order = 10,
							args = {
								TidyPlates = {
									name = "Tidy Plates Fading",
									type = "group",
									order = 0,
									inline = true,
									args = {
										Enable = {
											type = "toggle",
											order = 1,
											name = "Enable",
											desc = "This allows you to disable or enable the nameplates fading in or out when displayed or hidden.",
											descStyle = "inline",
											width = "full",
											set = function(info,val)
													SetValue(info,val)
													if db.tidyplatesFade then
														TidyPlates:EnableFadeIn()
													else
														TidyPlates:DisableFadeIn()
													end
												end,
											arg = {"tidyplatesFade"},
										},
									},
								},
								Hiding = {
									name = L["Hiding"],
									type = "group",
									order = 1,
									inline = true,
									args = {
										ShowNeutral = {
											type = "toggle",
											order = 1,
											name = L["Show Neutral"],
											arg = {"nameplate","toggle","Neutral"},
										},
										ShowTapped = {
											type = "toggle",
											order = 2,
											name = L["Show Tapped"],
											arg = {"nameplate","toggle","Tapped"},
										},
										ShowNormal = {
											type = "toggle",
											order = 3,
											name = L["Show Normal"],
											arg = {"nameplate","toggle","Normal"},
										},
										ShowElite = {
											type = "toggle",
											order = 4,
											name = L["Show Elite"],
											arg = {"nameplate","toggle","Elite"},
										},
										ShowBoss = {
											type = "toggle",
											order = 5,
											name = L["Show Boss"],
											arg = {"nameplate","toggle","Boss"},
										},
									},
								},
								BlizzSettings = {
									name = L["Blizzard Settings"],
									type = "group",
									order = 2,
									inline = true,
									get = GetCvar,
									set = SetCvar,
									args = {
										OpenBlizzardSettings = {
											name = L["Open Blizzard Settings"],
											type = "execute",
											order = 1,
											func = function()
												InterfaceOptionsFrame_OpenToCategory(_G["InterfaceOptionsNamesPanel"])
												LibStub("AceConfigDialog-3.0"):Close("Tidy Plates: Threat");
											end,
										},
										Friendly = {
											type = "group",
											name = L["Friendly"],
											order = 2,
											inline = true,
											args = {
												nameplateShowFriends = {
													name = L["Show Friends"],
													type = "toggle",
													order = 1,
													arg = "nameplateShowFriends",
												},
												nameplateShowFriendlyTotems = {
													name = L["Show Friendly Totems"],
													type = "toggle",
													order = 2,
													arg = "nameplateShowFriendlyTotems",
												},
												nameplateShowFriendlyPets = {
													name = L["Show Friendly Pets"],
													type = "toggle",
													order = 3,
													arg = "nameplateShowFriendlyPets",
												},
												nameplateShowFriendlyGuardians = {
													name = L["Show Friendly Guardians"],
													type = "toggle",
													order = 4,
													arg = "nameplateShowFriendlyGuardians",
												},
											},
										},
										Enemy = {
											type = "group",
											name = L["Enemy"],
											order = 3,
											inline = true,
											args = {
												nameplateShowEnemies = {
													name = L["Show Enemies"],
													type = "toggle",
													order = 1,
													arg = "nameplateShowEnemies",
												},
												nameplateShowEnemyTotems = {
													name = L["Show Enemy Totems"],
													type = "toggle",
													order = 2,
													arg = "nameplateShowEnemyTotems",
												},
												nameplateShowEnemyPets = {
													name = L["Show Enemy Pets"],
													type = "toggle",
													order = 3,
													arg = "nameplateShowEnemyPets",
												},
												nameplateShowEnemyGuardians = {
													name = L["Show Enemy Guardians"],
													type = "toggle",
													order = 4,
													arg = "nameplateShowEnemyGuardians",
												},
											},
										},
										Nameplate = {
											type = "group",
											name = L["Nameplate"],
											order = 4,
											inline = true,
											get = GetCVarNumber,
											set = SetCvarNumber,
											args = {
												nameplateMaxDistance = {
													name = L["Max Distance Nameplate Visibility"],
													type = "range",
													min = 0,
													max = 100,
													step = 5,
													order = 1,
													width = "full",
													arg = "nameplateMaxDistance",
												},
											},
										},
									},
								},
							},
						},
						HealthBarTexture = {
							name = L["Healthbar"],
							type = "group",
							inline = false,
							order = 20,
							args = {
								HealthBarGroup = {
									name = L["Textures"],
									type = "group",
									inline = true,
									order = 10,
									args = {
										HealthBarTexture = {
											name = L["Healthbar"],
											type = "select",
											order = 1,
											dialogControl = "LSM30_Statusbar",
											values = AceGUIWidgetLSMlists.statusbar,
											set = SetThemeValue,
											arg = {"settings","healthbar", "texture"},
										},
										Header1 = {
											type = "header",
											order = 1.5,
											name = "",
										},
										HealthBorderToggle = {
											type = "toggle",
											width = "double",
											order = 2,
											name = L["Show Border"],
											set = SetThemeValue,
											arg = {"settings","healthborder","show"},
										},
										HealthBorder = {
											type = "select",
											width = "double",
											order = 3,
											name = L["Normal Border"],
											set = SetThemeValue,
											disabled = function() if db.settings.healthborder.show then return false else return true end end,
											values = {TP_HealthBarOverlay = "Default",TP_HealthBarOverlayThin = "Thin"},
											arg = {"settings","healthborder","texture"},
										},
										Header2 = {
											type = "header",
											order = 3.5,
											name = "",
										},
										EliteHealthBorderToggle = {
											type = "toggle",
											width = "double",
											order = 4,
											name = L["Show Elite Border"],
											arg = {"settings","elitehealthborder","show"},
										},
										EliteBorder = {
											type = "select",
											width = "double",
											order = 5,
											name = L["Elite Border"],
											disabled = function() if db.settings.elitehealthborder.show then return false else return true end end,
											values = {TP_HealthBarEliteOverlay = "Default",TP_HealthBarEliteOverlayThin = "Thin"},
											arg = {"settings","elitehealthborder","texture"}
										},
										Header3 = {
											type = "header",
											order = 5.5,
											name = "",
										},
										Mouseover = {
											type = "select",
											width = "double",
											order = 6,
											name = L["Mouseover"],
											set = SetThemeValue,
											values = {TP_HealthBarHighlight = "Default",Empty = "None"},
											arg = {"settings","highlight","texture"},
										},
									},
								},
								Placement = {
									name = L["Placement"],
									type = "group",
									inline = true,
									order = 20,
									args = {
										Warning = {
											type = "description",
											order = 1,
											name = L["Changing these settings will alter the placement of the nameplates, however the mouseover area does not follow. |cffff0000Use with caution!|r"],
										},
										OffsetX = {
											name = L["Offset X"],
											type = "range",
											min = -60,
											max = 60,
											step = 1,
											order = 2,
											set = SetThemeValue,
											arg = {"settings","frame","x"},
										},
										Offsety = {
											name = L["Offset Y"],
											type = "range",
											min = -60,
											max = 60,
											step = 1,
											order = 3,
											set = SetThemeValue,
											arg = {"settings","frame","y"},
										},
									},
								},
								Coloring = {
									name = L["Coloring"],
									type = "group",
									inline = true,
									order = 30,
									args = {
										ColorByHPLevel = {
											name = L["Color HP by amount"],
											type = "toggle",
											desc = L["Changes the HP color depending on the amount of HP the nameplate shows."],
											descStyle = "inline",
											width = "full",
											order = 0,
											arg = {"healthColorChange"},
										},
										ColorLow = {
											name = "Low Color",
											type = "color",
											desc = "",
											descStyle = "inline",
											order = 0.5,
											get = GetColor,
											set = SetColor,
											arg = {"aHPbarColor"},
										},
										ColorHigh = {
											name = "High Color",
											type = "color",
											desc = "",
											descStyle = "inline",
											order = 1,
											get = GetColor,
											set = SetColor,
											arg = {"bHPbarColor"},
										},
										ClassColors = {
											name = L["Class Coloring"],
											order = 2,
											type = "group",
											disabled = function() return db.healthColorChange end,
											inline = true,
											args = {
												FriendlyClass = {
													type = "toggle",
													order = 1,
													name = L["Enable Friendly Class Colors"],
													width = "full",
													arg = {"friendlyClass"},
												},
												EnemyClass = {
													type = "toggle",
													order = 2,
													name = L["Enable Enemy Class Colors"],
													width = "full",
													arg = {"allowClass"},
												},
											},
										},
										CustomColors = {
											name = L["Reaction Colors"],
											order = 3,
											type = "group",
											inline = true,
											disabled = function() return db.healthColorChange end,
											get = GetColor,
											set = SetColor,
											args = {
												FriendlyColor = {
													name = L["Friendly Color"],
													type = "color",
													arg = {"friendlyHealthbarColor"},
												},
												EnemyColor = {
													name = L["Enemy Color"],
													type = "color",
													arg = {"enemyHealthbarColor"},
												},
												NeutralColor = {
													name = L["Neutral Color"],
													type = "color",
													arg = {"neutralHealthbarColor"},
												},
												TappedColor = {
													name = "Tapped Color",
													type = "color",
													arg = {"tapHealthbarColor"},
												},
											},
										},
										RaidMarkColors = {
											name = L["Raid Mark HP Color"],
											order = 4,
											type = "group",
											inline = true,
											args = {
												Enable = {
													name = L["Enable Raid Marked HP colors"],
													type = "toggle",
													width = "full",
													set = SetValue,
													order = 1,
													arg = {"settings","raidicon","hpColor"},
												},
												Colors = {
													name = L["Colors"],
													type = "group",
													inline = true,
													order = 2,
													disabled = function() if db.settings.raidicon.hpColor then return false else return true end end,
													get = GetColor,
													set = SetColor,
													args = {
														STAR = {
															type = "color",
															order = 1,
															name = RAID_TARGET_1,
															arg = {"settings","raidicon","hpMarked","STAR"},
														},
														CIRCLE = {
															type = "color",
															order = 2,
															name = RAID_TARGET_2,
															arg = {"settings","raidicon","hpMarked","CIRCLE"},
														},
														DIAMOND = {
															type = "color",
															order = 3,
															name = RAID_TARGET_3,
															arg = {"settings","raidicon","hpMarked","DIAMOND"},
														},
														TRIANGLE = {
															type = "color",
															order = 4,
															name = RAID_TARGET_4,
															arg = {"settings","raidicon","hpMarked","TRIANGLE"},
														},
														MOON = {
															type = "color",
															order = 5,
															name = RAID_TARGET_5,
															arg = {"settings","raidicon","hpMarked","MOON"},
														},
														SQUARE = {
															type = "color",
															order = 6,
															name = RAID_TARGET_6,
															arg = {"settings","raidicon","hpMarked","SQUARE"},
														},
														CROSS = {
															type = "color",
															order = 7,
															name = RAID_TARGET_7,
															arg = {"settings","raidicon","hpMarked","CROSS"},
														},
														SKULL = {
															type = "color",
															order = 8,
															name = RAID_TARGET_8,
															arg = {"settings","raidicon","hpMarked","SKULL"},
														},
													},
												},
											},
										},
										ThreatColors = {
											name = L["Threat Colors"],
											order = 1,
											type = "group",
											get = GetColorAlpha,
											set = SetColorAlpha,
											inline = true,
											args = {
												ThreatGlow = {
													type = "toggle",
													width = "double",
													order = 1,
													name = L["Show Threat Glow"],
													get = GetValue,
													set = SetThemeValue,
													arg = {"settings","threatborder","show"},
												},
												Header = {
													name = "Colors",
													type = "header",
													order = 2,
												},
												Low = {
													name = L["|cff00ff00Low threat|r"],
													type = "color",
													order = 3,
													arg = {"settings", "normal", "threatcolor", "LOW"},
													hasAlpha = true,
												},
												Med = {
													name = L["|cffffff00Medium threat|r"],
													type = "color",
													order = 4,
													arg = {"settings", "normal", "threatcolor", "MEDIUM"},
													hasAlpha = true,
												},
												High = {
													name = L["|cffff0000High threat|r"],
													type = "color",
													order = 5,
													arg = {"settings", "normal", "threatcolor", "HIGH"},
													hasAlpha = true,
												},
											},
										},
									},
								},
							},
						},
						CastBarSettings = {
							name = L["Castbar"],
							type = "group",
							order = 30,
							args = {
								Toggles = {
									name = L["Enable"],
									type = "group",
									inline = true,
									order = 1,
									args = {
										CastbarToggle = {
											name = L["Enable"],
											type = "toggle",
											order = 1,
											get = GetCvar,
											set = SetCvar,
											arg = "ShowVKeyCastbar",
										},
									},
								},
								Textures = {
									name = L["Textures"],
									type = "group",
									inline = true,
									order = 1,
									disabled = function() if GetCVar("ShowVKeyCastbar") == "1" then return false else return true end end,
									args = {
										CastBarTexture = {
											name = L["Castbar"],
											type = "select",
											order = 1,
											dialogControl = "LSM30_Statusbar",
											values = AceGUIWidgetLSMlists.statusbar,
											set = SetThemeValue,
											arg = {"settings","castbar", "texture"},
										},
										Header1 = {
											name = "",
											type = "header",
											order = 2,
										},
										CastBarBorderToggle = {
											name = "Show Border",
											type = "toggle",
											order = 3,
											set = SetThemeValue,
											arg = {"settings","castborder","show"},
										},
										CastBarBorder = {
											name = L["Normal Border"],
											type = "select",
											width = "double",
											order = 4,
											set = SetThemeValue,
											disabled = function() if db.settings.castborder.show then return false else return true end end,
											values = {TP_CastBarOverlay = "Default", TP_CastBarOverlayThin = "Thin"},
											arg = {"settings","castborder","texture"},
										},
									},
								},
								Placement = {
									name = L["Placement"],
									type = "group",
									inline = true,
									order = 20,
									disabled = function() if GetCVar("ShowVKeyCastbar") == "1" then return false else return true end end,
									args = {
										PlacementX = {
											name = L["X"],
											type = "range",
											min = -60,
											max = 60,
											step = 1,
											order = 2,
											set = function(info, val)
												local b1 = {}; b1.arg = {"settings","castborder","x"};
												local b2 = {}; b2.arg = {"settings","castnostop","x"};
												SetThemeValue(b1, val)
												SetThemeValue(b2, val)
												SetThemeValue(info, val)
												end,
											arg = {"settings","castbar","x"},
										},
										PlacementY = {
											name = L["Y"],
											type = "range",
											min = -60,
											max = 60,
											step = 1,
											order = 3,
											set = function(info, val)
												local b1 = {}; b1.arg = {"settings","castborder","y"};
												local b2 = {}; b2.arg = {"settings","castnostop","y"};
												SetThemeValue(b1, val)
												SetThemeValue(b2, val)
												SetThemeValue(info, val)
												end,
											arg = {"settings","castbar","y"},
										},
									},
								},
								Coloring = {
									name = L["Coloring"],
									type = "group",
									inline = true,
									order = 30,
									args = {
										Enable = {
											name = L["Enable Coloring"],
											type = "toggle",
											order = 1,
											disabled = function() if GetCVar("ShowVKeyCastbar") == "1" then return false else return true end end,
											arg = {"castbarColor","toggle"},
										},
										Interruptable = {
											name = L["Interruptable Casts"],
											type = "color",
											order = 2,
											get = GetColorAlpha,
											set = SetColorAlpha,
											disabled = function() if not db.castbarColor.toggle or GetCVar("ShowVKeyCastbar") ~= "1" then return true else return false end end,
											arg = {"castbarColor"},
										},
										Header1 = {
											type = "header",
											order = 3,
											name = "",
										},
										Enable2 = {
											name = L["Shielded Coloring"],
											type = "toggle",
											order = 4,
											disabled = function() if not db.castbarColor.toggle or GetCVar("ShowVKeyCastbar") ~= "1" then return true else return false end end,
											arg = {"castbarColorShield","toggle"},
										},
										Shielded = {
											name = L["Uninterruptable Casts"],
											type = "color",
											order = 5,
											get = GetColorAlpha,
											set = SetColorAlpha,
											disabled = function() if GetCVar("ShowVKeyCastbar") ~= "1" or not db.castbarColor.toggle or not db.castbarColorShield.toggle then return true else return false end end,
											arg = {"castbarColorShield"}
										},
									},
								},
							},
						},
						Alpha = {
							name = L["Alpha"],
							type = "group",
							order = 40,
							args = {
								BlizzFadeEnable = {
									name = L["Blizzard Target Fading"],
									type = "group",
									order = 1,
									inline = true,
									args = {
										Enable = {
											name = L["Enable Blizzard 'On-Target' Fading"],
											type = "toggle",
											desc = L["Enabling this will allow you to set the alpha adjustment for non-target nameplates."],
											descStyle = "inline",
											order = 1,
											width = "full",
											arg = {"blizzFadeA","toggle"},
										},
										blizzFade = {
											name = L["Non-Target Alpha"],
											type = "range",
											order = 2,
											width = "full",
											disabled = function() return not db.blizzFadeA.toggle end,
											min = -1,
											max = 0,
											step = 0.01,
											isPercent = true,
											arg = {"blizzFadeA","amount"},
										},
									},
								},
								Target = {
									name = "Target and No Target",
									type = "group",
									order = 2,
									inline = true,
									args = {
										CustomAlphaTarget = {
											name = "Custom Target Alpha",
											type = "toggle",
											desc = "If enabled your target's alpha will always be the setting below.",
											descStyle = "inline",
											order = 1,
											width = "full",
											arg = {"nameplate","toggle","TargetA"},
										},
										CustomAlphaTargetSet = {
											name = "",
											type = "range",
											order = 2,
											width = "full",
											disabled = function() return not db.nameplate.toggle.TargetA end,
											min = 0,
											max = 1,
											step = 0.01,
											isPercent = true,
											arg = {"nameplate","alpha","Target"},
										},
										CustomAlphaNoTarget = {
											name = "Custom No-Target Alpha",
											type = "toggle",
											desc = "If enabled your nameplates alpha will always be the setting below when you have no target.",
											descStyle = "inline",
											order = 3,
											width = "full",
											arg = {"nameplate","toggle","NoTargetA"},
										},
										CustomAlphaNoTargetSet = {
											name = "",
											type = "range",
											order = 4,
											width = "full",
											disabled = function() return not db.nameplate.toggle.NoTargetA end,
											min = 0,
											max = 1,
											step = 0.01,
											isPercent = true,
											arg = {"nameplate","alpha","NoTarget"},
										},
									},
								},
								Marked = {
									name = "Marked Units",
									type = "group",
									order = 3,
									inline = true,
									args = {
										CustomAlphaMarked = {
											name = "Custom Marked Alpha",
											type = "toggle",
											desc = "If enabled your marked units alpha will always be the setting below.",
											descStyle = "inline",
											order = 1,
											width = "full",
											arg = {"nameplate","toggle","MarkedA"},
										},
										CustomAlphaMarkedSet = {
											name = "",
											type = "range",
											order = 2,
											width = "full",
											disabled = function() return not db.nameplate.toggle.MarkedA end,
											min = 0,
											max = 1,
											step = 0.01,
											isPercent = true,
											arg = {"nameplate","alpha","Marked"},
										},

									},
								},
								NameplateAlpha = {
									name = L["Alpha Settings"],
									type = "group",
									order = 4,
									inline = true,
									args = {
										Tapped = {
											type = "range",
											width = "full",
											order = 1,
											name = L["Tapped"],
											arg = {"nameplate","alpha","Tapped"},
											step = 0.05,
											min = 0,
											max = 1,
											isPercent = true,
										},
										Neutral = {
											type = "range",
											width = "full",
											order = 2,
											name = COMBATLOG_FILTER_STRING_NEUTRAL_UNITS,
											arg = {"nameplate","alpha","Neutral"},
											step = 0.05,
											min = 0,
											max = 1,
											isPercent = true,
										},
										Normal = {
											type = "range",
											width = "full",
											order = 3,
											name = PLAYER_DIFFICULTY1,
											arg = {"nameplate","alpha","Normal"},
											step = 0.05,
											min = 0,
											max = 1,
											isPercent = true,
										},
										Elite = {
											type = "range",
											width = "full",
											order = 4,
											name = ELITE,
											arg = {"nameplate","alpha","Elite"},
											step = 0.05,
											min = 0,
											max = 1,
											isPercent = true,
										},
										Boss = {
											type = "range",
											width = "full",
											order = 5,
											name = BOSS,
											arg = {"nameplate","alpha","Boss"},
											step = 0.05,
											min = 0,
											max = 1,
											isPercent = true,
										},
										Allied = {
											type = "range",
											width = "full",
											order = 6,
											name = L["Allied"],
											arg = {"nameplate","alpha","Allied"},
											step = 0.05,
											min = 0,
											max = 1,
											isPercent = true,
										},
										Pet = {
											type = "range",
											width = "full",
											order = 7,
											name = L["Pet"],
											arg = {"nameplate","alpha","Pet"},
											step = 0.05,
											min = 0,
											max = 1,
											isPercent = true,
										},
										Guardian = {
											type = "range",
											width = "full",
											order = 8,
											name = L["Guardian"],
											arg = {"nameplate","alpha","Guardian"},
											step = 0.05,
											min = 0,
											max = 1,
											isPercent = true,
										}
									},
								},
							},
						},
						Scale = {
							name = L["Scale"],
							type = "group",
							order = 50,
							args = {
								Target = {
									name = "Target and No Target",
									type = "group",
									order = 1,
									inline = true,
									args = {
										CustomScaleTarget = {
											name = "Custom Target Scale",
											type = "toggle",
											desc = "If enabled your target's scale will always be the setting below.",
											descStyle = "inline",
											order = 1,
											width = "full",
											arg = {"nameplate","toggle","TargetS"},
										},
										CustomScaleTargetSet = {
											name = "",
											type = "range",
											order = 2,
											width = "full",
											disabled = function() return not db.nameplate.toggle.TargetS end,
											step = 0.05,
											softMin = 0.6,
											softMax = 1.5,
											isPercent = true,
											arg = {"nameplate","scale","Target"},
										},
										CustomScaleNoTarget = {
											name = "Custom No-Target Scale",
											type = "toggle",
											desc = "If enabled your nameplates scale will always be the setting below when you have no target.",
											descStyle = "inline",
											order = 3,
											width = "full",
											arg = {"nameplate","toggle","NoTargetS"},
										},
										CustomScaleNoTargetSet = {
											name = "",
											type = "range",
											order = 4,
											width = "full",
											disabled = function() return not db.nameplate.toggle.NoTargetS end,
											step = 0.05,
											softMin = 0.6,
											softMax = 1.5,
											isPercent = true,
											arg = {"nameplate","scale","NoTarget"},
										},
									},
								},
								Marked = {
									name = "Marked Units",
									type = "group",
									order = 2,
									inline = true,
									args = {
										CustomScaleMarked = {
											name = "Custom Marked Scale",
											type = "toggle",
											desc = "If enabled your marked units scale will always be the setting below.",
											descStyle = "inline",
											order = 1,
											width = "full",
											arg = {"nameplate","toggle","MarkedS"},
										},
										CustomScaleMarkedSet = {
											name = "",
											type = "range",
											order = 2,
											width = "full",
											disabled = function() return not db.nameplate.toggle.MarkedS end,
											step = 0.05,
											softMin = 0.6,
											softMax = 1.5,
											isPercent = true,
											arg = {"nameplate","scale","Marked"},
										},

									},
								},
								NameplateScale = {
									name = L["Scale Settings"],
									type = "group",
									order = 3,
									inline = true,
									args = {
										Tapped = {
											type = "range",
											width = "full",
											order = 1,
											name = L["Tapped"],
											arg = {"nameplate","scale","Tapped"},
											step = 0.05,
											softMin = 0.6,
											softMax = 1.5,
											isPercent = true,
										},
										Neutral = {
											type = "range",
											width = "full",
											order = 2,
											name = COMBATLOG_FILTER_STRING_NEUTRAL_UNITS,
											arg = {"nameplate","scale","Neutral"},
											step = 0.05,
											softMin = 0.6,
											softMax = 1.5,
											isPercent = true,
										},
										Normal = {
											type = "range",
											width = "full",
											order = 3,
											name = PLAYER_DIFFICULTY1,
											arg = {"nameplate","scale","Normal"},
											step = 0.05,
											softMin = 0.6,
											softMax = 1.5,
											isPercent = true,
										},
										Elite = {
											type = "range",
											width = "full",
											order = 4,
											name = ELITE,
											arg = {"nameplate","scale","Elite"},
											step = 0.05,
											softMin = 0.6,
											softMax = 1.5,
											isPercent = true,
										},
										Boss = {
											type = "range",
											width = "full",
											order = 5,
											name = BOSS,
											arg = {"nameplate","scale","Boss"},
											step = 0.05,
											softMin = 0.6,
											softMax = 1.5,
											isPercent = true,
										},
										Allied = {
											type = "range",
											width = "full",
											order = 6,
											name = L["Allied"],
											arg = {"nameplate","scale","Allied"},
											step = 0.05,
											softMin = 0.6,
											softMax = 1.5,
											isPercent = true,
										},
										Pet = {
											type = "range",
											width = "full",
											order = 7,
											name = L["Pet"],
											arg = {"nameplate","scale","Pet"},
											step = 0.05,
											softMin = 0.6,
											softMax = 1.5,
											isPercent = true,
										},
										Guardian = {
											type = "range",
											width = "full",
											order = 8,
											name = L["Guardian"],
											arg = {"nameplate","scale","Guardian"},
											step = 0.05,
											softMin = 0.6,
											softMax = 1.5,
											isPercent = true,
										}
									},
								},
							},
						},
						Nametext = {
							name = L["Name Text"],
							type = "group",
							order = 60,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									order = 1,
									inline = true,
									args = {
										Enable = {
											name = L["Enable Name Text"],
											type = "toggle",
											desc = L["Enables the showing of text on nameplates."],
											descStyle = "inline",
											width = "full",
											order = 1,
											set = SetThemeValue,
											arg = {"settings","name","show"},
										},
									},
								},
								Options = {
									name = L["Options"],
									type = "group",
									order = 3,
									inline = true,
									disabled = function() return not db.settings.name.show end,
									args = {
										FontLooks = {
											name = L["Font"],
											type = "group",
											inline = true,
											order = 1,
											args = {
												Font = {
													name = L["Font"],
													type = "select",
													order = 1,
													dialogControl = "LSM30_Font",
													values = AceGUIWidgetLSMlists.font,
													set = SetThemeValue,
													arg = {"settings","name", "typeface"},
												},
												FontStyle = {
													type = "select",
													order = 2,
													name = L["Font Style"],
													desc = L["Set the outlining style of the text."],
													values = t.FontStyle,
													set = SetThemeValue,
													arg = {"settings","name", "flags"},
												},
												Shadow = {
													name = L["Enable Shadow"],
													order = 3,
													type = "toggle",
													width = "full",
													set = SetThemeValue,
													arg = {"settings","name","shadow"},
												},
												ColorGroup = {
													name = L["Color"],
													type = "group",
													inline = true,
													order = 4,
													args = {
														FriendlyClass = {
															type = "toggle",
															order = 1,
															name = L["Enable Friendly Class Colors"],
															width = "full",
															set = SetThemeValue,
															arg = {"settings","name", "colorFriendlyClass"},
														},
														EnemyClass = {
															type = "toggle",
															order = 2,
															name = L["Enable Enemy Class Colors"],
															width = "full",
															set = SetThemeValue,
															arg = {"settings","name", "colorEnemyClass"},
														},
														Reaction = {
															type = "toggle",
															order = 3,
															name = L["Enable Reaction Colors"],
															width = "full",
															set = SetThemeValue,
															arg = {"settings","name", "colorByReaction"},
														},
														Color = {
															type = "color",
															order = 4,
															name = L["Color"],
															width = "full",
															get = GetColor,
															set = SetColor,
															arg = {"settings","name", "color"},
															hasAlpha = false,
														},
													},
												},
											},
										},
										FontSize = {
											name = L["Text Bounds and Sizing"],
											type = "group",
											order = 2,
											inline = true,
											args = {
												FontSize = {
													name = L["Font Size"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"settings","name","size"},
													max = 36,
													min = 6,
													step = 1,
													isPercent = false,
												},
												TextBounds = {
													name = L["Text Boundaries"],
													type = "group",
													order = 2,
													args = {
														Description = {
															type = "description",
															order = 1,
															name = L["key_FontWarning"],
															width = "full",
														},
														Width = {
															type = "range",
															width = "full",
															order = 2,
															name = L["Text Width"],
															set = SetThemeValue,
															arg = {"settings","name","width"},
															max = 250,
															min = 20,
															step = 1,
															isPercent = false,
														},
														Height = {
															type = "range",
															width = "full",
															order = 3,
															name = L["Text Height"],
															set = SetThemeValue,
															arg = {"settings","name","height"},
															max = 40,
															min = 8,
															step = 1,
															isPercent = false,
														},
													},
												},
											},
										},
										Placement = {
											name = L["Placement"],
											order = 3,
											type = "group",
											inline = true,
											args = {
												X = {
													name = L["X"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"settings","name","x"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												Y = {
													name = L["Y"],
													type = "range",
													width = "full",
													order = 2,
													set = SetThemeValue,
													arg = {"settings","name","y"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												AlignH = {
													name = L["Horizontal Align"],
													type = "select",
													width = "full",
													order = 3,
													values = t.AlignH,
													set = SetThemeValue,
													arg = {"settings","name","align"},
												},
												AlignV = {
													name = L["Vertical Align"],
													type = "select",
													width = "full",
													order = 4,
													values = t.AlignV,
													set = SetThemeValue,
													arg = {"settings","name","vertical"},
												},
											},
										},
									},
								},
							},
						},
						Healthtext = {
							name = L["Health Text"],
							type = "group",
							order = 70,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									order = 1,
									inline = true,
									args = {
										Enable = {
											name = L["Enable Health Text"],
											type = "toggle",
											desc = L["Enables the showing of text on nameplates."],
											descStyle = "inline",
											width = "full",
											order = 1,
											set = SetThemeValue,
											arg = {"settings","customtext","show"},
										},
									},
								},
								Options = {
									name = L["Options"],
									type = "group",
									order = 2,
									inline = true,
									disabled = function() if db.settings.customtext.show then return false else return true end end,
									args = {
										DisplaySettings = {
											name = L["Display Settings"],
											type = "group",
											order = 0,
											inline = true,
											args = {
												Full = {
													name = L["Text at Full HP"],
													type = "toggle",
													order = 0,
													width = "full",
													desc = L["Display health text on targets with full HP."],
													descStyle = "inline",
													arg = {"text","full"}
												},
												EnablePercent = {
													name = L["Percent Text"],
													type = "toggle",
													order = 1,
													width = "full",
													desc = L["Display health percentage text."],
													descStyle = "inline",
													arg = {"text","percent"}
												},
												EnableAmount = {
													name = L["Amount Text"],
													type = "toggle",
													order = 2,
													width = "full",
													desc = L["Display health amount text."],
													descStyle = "inline",
													arg = {"text","amount"}
												},
												AmountSettings = {
													name = L["Amount Text Formatting"],
													type = "group",
													order = 3,
													inline = true,
													disabled = function() if not db.text.amount or not db.settings.customtext.show then return true else return false end end,
													args = {
														Truncate = {
															name = L["Truncate Text"],
															type = "toggle",
															order = 1,
															width = "full",
															desc = L["This will format text to a simpler format using M or K for millions and thousands. Disabling this will show exact HP amounts."],
															descStyle = "inline",
															arg = {"text","truncate"}
														},
														MaxHP = {
															name = L["Max HP Text"],
															type = "toggle",
															order = 2,
															width = "full",
															desc = L["This will format text to show both the maximum hp and current hp."],
															descStyle = "inline",
															arg = {"text","max"}
														},
														Deficit = {
															name = L["Deficit Text"],
															type = "toggle",
															order = 3,
															width = "full",
															desc = L["This will format text to show hp as a value the target is missing."],
															descStyle = "inline",
															arg = {"text","deficit"}
														},
														Decimals = {
															name = L["Decimals"],
															type = "range",
															width = "full",
															order = 4,
															set = SetThemeValue,
															arg = {"text","decimals"},
															max = 3,
															min = 0,
															step = 1,
														},
													},
												},

											},
										},
										FontLooks = {
											name = L["Font"],
											type = "group",
											inline = true,
											order = 1,
											args = {
												Font = {
													name = L["Font"],
													type = "select",
													order = 1,
													dialogControl = "LSM30_Font",
													values = AceGUIWidgetLSMlists.font,
													set = SetThemeValue,
													arg = {"settings","customtext", "typeface"},
												},
												FontStyle = {
													type = "select",
													order = 2,
													name = L["Font Style"],
													desc = L["Set the outlining style of the text."],
													values = t.FontStyle,
													set = SetThemeValue,
													arg = {"settings","customtext", "flags"},
												},
												Shadow = {
													name = L["Enable Shadow"],
													order = 4,
													type = "toggle",
													width = "full",
													set = SetThemeValue,
													arg = {"settings","customtext","shadow"},
												},
											},
										},
										FontSize = {
											name = L["Text Bounds and Sizing"],
											type = "group",
											order = 2,
											inline = true,
											args = {
												FontSize = {
													name = L["Font Size"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"settings","customtext","size"},
													max = 36,
													min = 6,
													step = 1,
													isPercent = false,
												},
												TextBounds = {
													name = L["Text Boundaries"],
													type = "group",
													order = 2,
													args = {
														Description = {
															type = "description",
															order = 1,
															name = L["key_FontWarning"],
															width = "full",
														},
														Width = {
															type = "range",
															width = "full",
															order = 2,
															name = L["Text Width"],
															set = SetThemeValue,
															arg = {"settings","customtext","width"},
															max = 250,
															min = 20,
															step = 1,
															isPercent = false,
														},
														Height = {
															type = "range",
															width = "full",
															order = 3,
															name = L["Text Height"],
															set = SetThemeValue,
															arg = {"settings","customtext","height"},
															max = 40,
															min = 8,
															step = 1,
															isPercent = false,
														},
													},
												},
											},
										},
										Placement = {
											name = L["Placement"],
											order = 3,
											type = "group",
											inline = true,
											args = {
												X = {
													name = L["X"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"settings","customtext","x"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												Y = {
													name = L["Y"],
													type = "range",
													width = "full",
													order = 2,
													set = SetThemeValue,
													arg = {"settings","customtext","y"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												AlignH = {
													name = L["Horizontal Align"],
													type = "select",
													width = "full",
													order = 3,
													values = t.AlignH,
													set = SetThemeValue,
													arg = {"settings","customtext","align"},
												},
												AlignV = {
													name = L["Vertical Align"],
													type = "select",
													width = "full",
													order = 4,
													values = t.AlignV,
													set = SetThemeValue,
													arg = {"settings","customtext","vertical"},
												},
											},
										},
									},
								},
							},
						},
						SpellText = {
							name = L["Spell Text"],
							type = "group",
							order = 80,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									order = 1,
									inline = true,
									args = {
										Enable = {
											name = L["Enable Spell Text"],
											type = "toggle",
											desc = L["Enables the showing of text on nameplates."],
											descStyle = "inline",
											width = "full",
											order = 1,
											set = SetThemeValue,
											arg = {"settings","spelltext","show"},
										},
									},
								},
								Options = {
									name = L["Options"],
									type = "group",
									order = 2,
									inline = true,
									disabled = function() if db.settings.spelltext.show then return false else return true end end,
									args = {
										FontLooks = {
											name = L["Font"],
											type = "group",
											inline = true,
											order = 1,
											args = {
												Font = {
													name = L["Font"],
													type = "select",
													order = 1,
													dialogControl = "LSM30_Font",
													values = AceGUIWidgetLSMlists.font,
													set = SetThemeValue,
													arg = {"settings","spelltext", "typeface"},
												},
												FontStyle = {
													type = "select",
													order = 2,
													name = L["Font Style"],
													desc = L["Set the outlining style of the text."],
													values = t.FontStyle,
													set = SetThemeValue,
													arg = {"settings","spelltext", "flags"},
												},
												Shadow = {
													name = L["Enable Shadow"],
													order = 4,
													type = "toggle",
													width = "full",
													set = SetThemeValue,
													arg = {"settings","spelltext","shadow"},
												},
											},
										},
										FontSize = {
											name = L["Text Bounds and Sizing"],
											type = "group",
											order = 2,
											inline = true,
											args = {
												FontSize = {
													name = L["Font Size"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"settings","spelltext","size"},
													max = 36,
													min = 6,
													step = 1,
													isPercent = false,
												},
												TextBounds = {
													name = L["Text Boundaries"],
													type = "group",
													order = 2,
													args = {
														Description = {
															type = "description",
															order = 1,
															name = L["key_FontWarning"],
															width = "full",
														},
														Width = {
															type = "range",
															width = "full",
															order = 2,
															name = L["Text Width"],
															set = SetThemeValue,
															arg = {"settings","spelltext","width"},
															max = 250,
															min = 20,
															step = 1,
															isPercent = false,
														},
														Height = {
															type = "range",
															width = "full",
															order = 3,
															name = L["Text Height"],
															set = SetThemeValue,
															arg = {"settings","spelltext","height"},
															max = 40,
															min = 8,
															step = 1,
															isPercent = false,
														},
													},
												},
											},
										},
										Placement = {
											name = L["Placement"],
											order = 3,
											type = "group",
											inline = true,
											args = {
												X = {
													name = L["X"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"settings","spelltext","x"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												Y = {
													name = L["Y"],
													type = "range",
													width = "full",
													order = 2,
													set = SetThemeValue,
													arg = {"settings","spelltext","y"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												AlignH = {
													name = L["Horizontal Align"],
													type = "select",
													width = "full",
													order = 3,
													values = t.AlignH,
													set = SetThemeValue,
													arg = {"settings","spelltext","align"},
												},
												AlignV = {
													name = L["Vertical Align"],
													type = "select",
													width = "full",
													order = 4,
													values = t.AlignV,
													set = SetThemeValue,
													arg = {"settings","spelltext","vertical"},
												},
											},
										},
									},
								},
							},
						},
						Leveltext = {
							name = L["Level Text"],
							type = "group",
							order = 90,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									order = 1,
									inline = true,
									args = {
										Enable = {
											name = L["Enable Level Text"],
											type = "toggle",
											desc = L["Enables the showing of text on nameplates."],
											descStyle = "inline",
											width = "full",
											order = 1,
											set = SetThemeValue,
											arg = {"settings","level","show"},
										},
									},
								},
								Options = {
									name = L["Options"],
									type = "group",
									order = 2,
									inline = true,
									disabled = function() if db.settings.level.show then return false else return true end end,
									args = {
										FontLooks = {
											name = L["Font"],
											type = "group",
											inline = true,
											order = 1,
											args = {
												Font = {
													name = L["Font"],
													type = "select",
													order = 1,
													dialogControl = "LSM30_Font",
													values = AceGUIWidgetLSMlists.font,
													set = SetThemeValue,
													arg = {"settings","level", "typeface"},
												},
												FontStyle = {
													type = "select",
													order = 2,
													name = L["Font Style"],
													desc = L["Set the outlining style of the text."],
													values = t.FontStyle,
													set = SetThemeValue,
													arg = {"settings","level", "flags"},
												},
												Shadow = {
													name = L["Enable Shadow"],
													order = 4,
													type = "toggle",
													width = "full",
													set = SetThemeValue,
													arg = {"settings","level","shadow"},
												},
											},
										},
										FontSize = {
											name = L["Text Bounds and Sizing"],
											type = "group",
											order = 2,
											inline = true,
											args = {
												FontSize = {
													name = L["Font Size"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"settings","level","size"},
													max = 36,
													min = 6,
													step = 1,
													isPercent = false,
												},
												TextBounds = {
													name = L["Text Boundaries"],
													type = "group",
													order = 2,
													args = {
														Description = {
															type = "description",
															order = 1,
															name = L["key_FontWarning"],
															width = "full",
														},
														Width = {
															type = "range",
															width = "full",
															order = 2,
															name = L["Text Width"],
															set = SetThemeValue,
															arg = {"settings","level","width"},
															max = 250,
															min = 20,
															step = 1,
															isPercent = false,
														},
														Height = {
															type = "range",
															width = "full",
															order = 3,
															name = L["Text Height"],
															set = SetThemeValue,
															arg = {"settings","level","height"},
															max = 40,
															min = 8,
															step = 1,
															isPercent = false,
														},
													},
												},
											},
										},
										Placement = {
											name = L["Placement"],
											order = 3,
											type = "group",
											inline = true,
											args = {
												X = {
													name = L["X"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"settings","level","x"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												Y = {
													name = L["Y"],
													type = "range",
													width = "full",
													order = 2,
													set = SetThemeValue,
													arg = {"settings","level","y"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												AlignH = {
													name = L["Horizontal Align"],
													type = "select",
													width = "full",
													order = 3,
													values = t.AlignH,
													set = SetThemeValue,
													arg = {"settings","level","align"},
												},
												AlignV = {
													name = L["Vertical Align"],
													type = "select",
													width = "full",
													order = 4,
													values = t.AlignV,
													set = SetThemeValue,
													arg = {"settings","level","vertical"},
												},
											},
										},
									},
								},
							},
						},
						EliteIcon = {
							name = L["Elite Icon"],
							type = "group",
							order = 100,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									order = 1,
									inline = true,
									args = {
										Enable = {
											name = L["Enable Elite Icon"],
											type = "toggle",
											desc = L["Enables the showing of the elite icon on nameplates."],
											descStyle = "inline",
											width = "full",
											order = 1,
											set = SetThemeValue,
											arg = {"settings","eliteicon","show"},
										},
									},
								},
								Options = {
									name = L["Options"],
									type = "group",
									order = 2,
									inline = true,
									disabled = function() if db.settings.eliteicon.show then return false else return true end end,
									args = {
										Texture = {
											name = L["Texture"],
											type = "group",
											inline = true,
											order = 1,
											args = {
												Preview = {
													name = L["Preview"],
													type = "execute",
													order = 1,
													image = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\EliteArtWidget\\"..db.settings.eliteicon.theme,
												},
												Style = {
													type = "select",
													order = 2,
													name = L["Elite Icon Style"],
													values = {default = "Default",skullandcross = "Skull and Crossbones"},
													set = function(info,val)
														SetThemeValue(info,val)
														options.args.NameplateSettings.args.EliteIcon.args.Options.args.Texture.args.Preview.image = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\EliteArtWidget\\"..val
														t.Update()
													end,
													arg = {"settings","eliteicon","theme"},
												},
												Header1 = {
													type = "header",
													order = 3,
													name = "",
												},
												Size = {
													name = L["Size"],
													type = "range",
													width = "full",
													order = 4,
													set = SetThemeValue,
													arg = {"settings","eliteicon","scale"},
													max = 64,
													min = 6,
													step = 1,
													isPercent = false,
												},
											},
										},
										Placement = {
											name = L["Placement"],
											order = 3,
											type = "group",
											inline = true,
											args = {
												X = {
													name = L["X"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"settings","eliteicon","x"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												Y = {
													name = L["Y"],
													type = "range",
													width = "full",
													order = 2,
													set = SetThemeValue,
													arg = {"settings","eliteicon","y"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												Anchor = {
													name = L["Anchor"],
													type = "select",
													width = "full",
													order = 3,
													values = t.FullAlign,
													set = SetThemeValue,
													arg = {"settings","eliteicon","anchor"},
												},
											},
										},
									},
								},
							},
						},
						SkullIcon = {
							name = L["Skull Icon"],
							type = "group",
							order = 110,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									order = 1,
									inline = true,
									args = {
										Enable = {
											name = L["Enable Skull Icon"],
											type = "toggle",
											desc = L["Enables the showing of the skull icon on nameplates."],
											descStyle = "inline",
											width = "full",
											order = 1,
											set = SetThemeValue,
											arg = {"settings","skullicon","show"},
										},
									},
								},
								Options = {
									name = L["Options"],
									type = "group",
									order = 2,
									inline = true,
									disabled = function() if db.settings.skullicon.show then return false else return true end end,
									args = {
										Texture = {
											name = L["Texture"],
											type = "group",
											inline = true,
											order = 1,
											args = {
												Size = {
													name = L["Size"],
													type = "range",
													width = "full",
													order = 4,
													set = SetThemeValue,
													arg = {"settings","skullicon","scale"},
													max = 64,
													min = 6,
													step = 1,
													isPercent = false,
												},
											},
										},
										Placement = {
											name = L["Placement"],
											order = 3,
											type = "group",
											inline = true,
											args = {
												X = {
													name = L["X"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"settings","skullicon","x"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												Y = {
													name = L["Y"],
													type = "range",
													width = "full",
													order = 2,
													set = SetThemeValue,
													arg = {"settings","skullicon","y"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												Anchor = {
													name = L["Anchor"],
													type = "select",
													width = "full",
													order = 3,
													values = t.FullAlign,
													set = SetThemeValue,
													arg = {"settings","skullicon","anchor"},
												},
											},
										},
									},
								},
							},
						},
						SpellIcon = {
							name = L["Spell Icon"],
							type = "group",
							order = 120,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									order = 1,
									inline = true,
									args = {
										Enable = {
											name = L["Enable Spell Icon"],
											type = "toggle",
											desc = L["Enables the showing of the spell icon on nameplates."],
											descStyle = "inline",
											width = "full",
											order = 1,
											set = SetThemeValue,
											arg = {"settings","spellicon","show"},
										},
									},
								},
								Options = {
									name = L["Options"],
									type = "group",
									order = 2,
									inline = true,
									disabled = function() if db.settings.spellicon.show then return false else return true end end,
									args = {
										Texture = {
											name = L["Texture"],
											type = "group",
											inline = true,
											order = 1,
											args = {
												Size = {
													name = L["Size"],
													type = "range",
													width = "full",
													order = 4,
													set = SetThemeValue,
													arg = {"settings","spellicon","scale"},
													max = 64,
													min = 6,
													step = 1,
													isPercent = false,
												},
											},
										},
										Placement = {
											name = L["Placement"],
											order = 3,
											type = "group",
											inline = true,
											args = {
												X = {
													name = L["X"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"settings","spellicon","x"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												Y = {
													name = L["Y"],
													type = "range",
													width = "full",
													order = 2,
													set = SetThemeValue,
													arg = {"settings","spellicon","y"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												Anchor = {
													name = L["Anchor"],
													type = "select",
													width = "full",
													order = 3,
													values = t.FullAlign,
													set = SetThemeValue,
													arg = {"settings","spellicon","anchor"},
												},
											},
										},
									},
								},
							},
						},
						Raidmarks = {
							name = L["Raid Marks"],
							type = "group",
							order = 130,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									order = 1,
									inline = true,
									args = {
										Enable = {
											name = L["Enable Raid Mark Icon"],
											type = "toggle",
											desc = L["Enables the showing of the raid mark icon on nameplates."],
											descStyle = "inline",
											width = "full",
											order = 1,
											set = SetThemeValue,
											arg = {"settings","raidicon","show"},
										},
									},
								},
								Options = {
									name = L["Options"],
									type = "group",
									order = 2,
									inline = true,
									disabled = function() if db.settings.raidicon.show then return false else return true end end,
									args = {
										Texture = {
											name = L["Texture"],
											type = "group",
											inline = true,
											order = 1,
											args = {
												Size = {
													name = L["Size"],
													type = "range",
													width = "full",
													order = 4,
													set = SetThemeValue,
													arg = {"settings","raidicon","scale"},
													max = 64,
													min = 6,
													step = 1,
													isPercent = false,
												},
											},
										},
										Placement = {
											name = L["Placement"],
											order = 3,
											type = "group",
											inline = true,
											args = {
												X = {
													name = L["X"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"settings","raidicon","x"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												Y = {
													name = L["Y"],
													type = "range",
													width = "full",
													order = 2,
													set = SetThemeValue,
													arg = {"settings","raidicon","y"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												Anchor = {
													name = L["Anchor"],
													type = "select",
													width = "full",
													order = 3,
													values = t.FullAlign,
													set = SetThemeValue,
													arg = {"settings","raidicon","anchor"},
												},
											},
										},
									},
								},
							},
						},
						TextOnly = {
							name = L["Text Only Style"],
							type = "group",
							order = 140,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									order = 1,
									inline = true,
									args = {
										Enable = {
											name = L["Enable Text Only Style"],
											type = "toggle",
											desc = L["Enable to hide the healthbar, castbar and other art for selected unit types."],
											descStyle = "inline",
											width = "full",
											order = 1,
											set = SetThemeValue,
											set = function(info,val)
													SetThemeValue(info,val)
													if TidyPlatesThreat.db.profile.textOnly.ON then
														C_NamePlate.SetNamePlateFriendlyClickThrough(true)
													else
														C_NamePlate.SetNamePlateFriendlyClickThrough(false)
													end
												end,
											arg = {"textOnly","ON"},
										},
									},
								},
								Alpha = {
									name = L["Alpha"],
									type = "group",
									order = 2,
									inline = true,
									args = {
										Enable = {
											name = L["Enable Blizzard 'On-Target' Fading"],
											type = "toggle",
											desc = L["Enabling this will allow you to set the alpha adjustment for non-target nameplates."],
											descStyle = "inline",
											order = 1,
											width = "full",
											arg = {"textOnly","blizzFadeA"},
										},
										OverrideAlpha = {
											name = L["Override alpha settings"],
											type = "toggle",
											desc = L["Use the alpha set below for text only style."],
											descStyle = "inline",
											order = 2,
											width = "full",
											arg = {"textOnly","overrideAlpha"},
										},
										OverrideAlphaValue = {
											name = "",
											type = "range",
											order = 3,
											width = "full",
											disabled = function() return not db.textOnly.overrideAlpha end,
											min = 0,
											max = 1,
											step = 0.01,
											isPercent = true,
											arg = {"textOnly","alpha"},
										},
									},
								},
								Type = {
									name = L["Unit Type"],
									type = "group",
									order = 3,
									inline = true,
									disabled = function() return not db.textOnly.ON end,
									args = {
										Player = {
											name = L["Friendly Player"],
											type = "toggle",
											order = 1,
											set = SetThemeValue,
											arg = {"textOnly","friendlyPlayer"},
										},
										NPC = {
											name = L["Friendly NPC"],
											type = "toggle",
											order = 2,
											set = SetThemeValue,
											arg = {"textOnly","friendlyNPC"},
										},
										NeutralUnit = {
											name = L["Neutral NPC"],
											type = "toggle",
											order = 3,
											set = SetThemeValue,
											arg = {"textOnly","neutralUnit"},
										},
										MiniMobsUnit = {
											name = L["Mini Mob NPC"],
											type = "toggle",
											order = 4,
											set = SetThemeValue,
											arg = {"textOnly","miniMobsUnit"},
										},
									},
								},
								Name = {
									name = L["Name"],
									order = 10,
									type = "group",
									inline = true,
									disabled = function() return not db.textOnly.ON end,
									args = {
										ColorGroup = {
											name = L["Color"],
											type = "group",
											inline = true,
											order = 1,
											args = {
												ClassColor = {
													type = "toggle",
													order = 1,
													name = L["Enable Class Colors"],
													width = "full",
													set = SetThemeValue,
													arg = {"textOnly","name", "classColor"},
												},
												ReactionColor = {
															type = "toggle",
															order = 2,
															name = L["Enable Reaction Colors"],
															width = "full",
															set = SetThemeValue,
															arg = {"textOnly","name", "colorByReaction"},
														},
												Color = {
													type = "color",
													order = 3,
													name = L["Color"],
													width = "full",
													get = GetColor,
													set = SetColor,
													arg = {"textOnly","name", "color"},
													hasAlpha = false,
												},
											},
										},
										FontLooks = {
											name = L["Font"],
											type = "group",
											inline = true,
											order = 2,
											args = {
												Font = {
													name = L["Font"],
													type = "select",
													order = 1,
													dialogControl = "LSM30_Font",
													values = AceGUIWidgetLSMlists.font,
													set = SetThemeValue,
													arg = {"textOnly","name", "typeface"},
												},
												FontStyle = {
													type = "select",
													order = 2,
													name = L["Font Style"],
													desc = L["Set the outlining style of the text."],
													values = t.FontStyle,
													set = SetThemeValue,
													arg = {"textOnly","name", "flags"},
												},
												Shadow = {
													name = L["Enable Shadow"],
													order = 3,
													type = "toggle",
													width = "full",
													set = SetThemeValue,
													arg = {"textOnly","name","shadow"},
												},
											},
										},
										FontSize = {
											name = L["Text Bounds and Sizing"],
											type = "group",
											order = 3,
											inline = true,
											args = {
												FontSize = {
													name = L["Font Size"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"textOnly","name","size"},
													max = 36,
													min = 6,
													step = 1,
													isPercent = false,
												},
												TextBounds = {
													name = L["Text Boundaries"],
													type = "group",
													order = 2,
													args = {
														Description = {
															type = "description",
															order = 1,
															name = L["key_FontWarning"],
															width = "full",
														},
														Width = {
															type = "range",
															width = "full",
															order = 2,
															name = L["Text Width"],
															set = SetThemeValue,
															arg = {"textOnly","name","width"},
															max = 300,
															min = 20,
															step = 1,
															isPercent = false,
														},
														Height = {
															type = "range",
															width = "full",
															order = 3,
															name = L["Text Height"],
															set = SetThemeValue,
															arg = {"textOnly","name","height"},
															max = 40,
															min = 8,
															step = 1,
															isPercent = false,
														},
													},
												},
											},
										},
										Placement = {
											name = L["Placement"],
											order = 4,
											type = "group",
											inline = true,
											args = {
												X = {
													name = L["X"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"textOnly","name","x"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												Y = {
													name = L["Y"],
													type = "range",
													width = "full",
													order = 2,
													set = SetThemeValue,
													arg = {"textOnly","name","y"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												AlignH = {
													name = L["Horizontal Align"],
													type = "select",
													width = "full",
													order = 3,
													values = t.AlignH,
													set = SetThemeValue,
													arg = {"textOnly","name","align"},
												},
												AlignV = {
													name = L["Vertical Align"],
													type = "select",
													width = "full",
													order = 4,
													values = t.AlignV,
													set = SetThemeValue,
													arg = {"textOnly","name","vertical"},
												},
											},
										},
									},
								},
								Subtitle = {
									name = L["Subtitle"],
									order = 11,
									type = "group",
									inline = true,
									disabled = function() return not db.textOnly.ON end,
									args = {
										Hiding = {
											name = L["Hiding"],
											type = "group",
											order = 1,
											inline = true,
											args = {
												ShowRole = {
													type = "toggle",
													order = 1,
													name = L["Show Role"],
													arg = {"textOnly","customtext","showRole"},
												},
												ShowGuild = {
													type = "toggle",
													order = 2,
													name = L["Show Guild"],
													arg = {"textOnly","customtext","showGuild"},
												},
											},
										},
										ColorGroup = {
											name = L["Color"],
											type = "group",
											inline = true,
											order = 2,
											args = {
												Color = {
													type = "color",
													order = 1,
													name = L["Color"],
													width = "full",
													get = GetColor,
													set = SetColor,
													arg = {"textOnly","customtext", "color"},
													hasAlpha = false,
												},
											},
										},
										FontLooks = {
											name = L["Font"],
											type = "group",
											inline = true,
											order = 3,
											args = {
												Font = {
													name = L["Font"],
													type = "select",
													order = 1,
													dialogControl = "LSM30_Font",
													values = AceGUIWidgetLSMlists.font,
													set = SetThemeValue,
													arg = {"textOnly","customtext", "typeface"},
												},
												FontStyle = {
													type = "select",
													order = 2,
													name = L["Font Style"],
													desc = L["Set the outlining style of the text."],
													values = t.FontStyle,
													set = SetThemeValue,
													arg = {"textOnly","customtext", "flags"},
												},
												Shadow = {
													name = L["Enable Shadow"],
													order = 3,
													type = "toggle",
													width = "full",
													set = SetThemeValue,
													arg = {"textOnly","customtext","shadow"},
												},
											},
										},
										FontSize = {
											name = L["Text Bounds and Sizing"],
											type = "group",
											order = 4,
											inline = true,
											args = {
												FontSize = {
													name = L["Font Size"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"textOnly","customtext","size"},
													max = 36,
													min = 6,
													step = 1,
													isPercent = false,
												},
												TextBounds = {
													name = L["Text Boundaries"],
													type = "group",
													order = 2,
													args = {
														Description = {
															type = "description",
															order = 1,
															name = L["key_FontWarning"],
															width = "full",
														},
														Width = {
															type = "range",
															width = "full",
															order = 2,
															name = L["Text Width"],
															set = SetThemeValue,
															arg = {"textOnly","customtext","width"},
															max = 300,
															min = 20,
															step = 1,
															isPercent = false,
														},
														Height = {
															type = "range",
															width = "full",
															order = 3,
															name = L["Text Height"],
															set = SetThemeValue,
															arg = {"textOnly","customtext","height"},
															max = 40,
															min = 8,
															step = 1,
															isPercent = false,
														},
													},
												},
											},
										},
										Placement = {
											name = L["Placement"],
											order = 5,
											type = "group",
											inline = true,
											args = {
												X = {
													name = L["X"],
													type = "range",
													width = "full",
													order = 1,
													set = SetThemeValue,
													arg = {"textOnly","customtext","x"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												Y = {
													name = L["Y"],
													type = "range",
													width = "full",
													order = 2,
													set = SetThemeValue,
													arg = {"textOnly","customtext","y"},
													max = 120,
													min = -120,
													step = 1,
													isPercent = false,
												},
												AlignH = {
													name = L["Horizontal Align"],
													type = "select",
													width = "full",
													order = 3,
													values = t.AlignH,
													set = SetThemeValue,
													arg = {"textOnly","customtext","align"},
												},
												AlignV = {
													name = L["Vertical Align"],
													type = "select",
													width = "full",
													order = 4,
													values = t.AlignV,
													set = SetThemeValue,
													arg = {"textOnly","customtext","vertical"},
												},
											},
										},
									},
								},
							},
						},
					},
				},
				ThreatOptions = {
					name = L["Threat System"],
					type = "group",
					order = 30,
					args = {
						Enable = {
							name = L["Enable Threat System"],
							type = "toggle",
							order = 1,
							set = function(info, val)
								SetValue(info, val)
								local inInstance, iType = IsInInstance()
								if iType == "party" or iType == "raid" or iType == "none" then
									db.OldSetting = val
								end
							end,
							arg = {"threat", "ON"}
						},
						GeneralSettings = {
							name = L["General Settings"],
							type = "group",
							order = 0,
							disabled = function() return not db.threat.ON end,
							args = {
								AdditionalToggles = {
									name = L["Additional Toggles"],
									type = "group",
									order = 1,
									inline = true,
									args = {
										NonCombat = {
											type = "toggle",
											name = L["Show Non-Combat Threat"],
											order = 1,
											width = "full",
											desc = L["Disables threat feedback from mobs you're currently not in combat with."],
											descStyle = "inline",
											arg = {"threat","toggle","nonCombat"},
										},
										Tapped = {
											type = "toggle",
											name = L["Show Tapped Threat"],
											order = 2,
											width = "full",
											desc = L["Disables threat feedback from tapped mobs regardless of boss or elite levels."],
											descStyle = "inline",
											arg = {"threat","toggle","Tapped"},
										},
										Neutral = {
											type = "toggle",
											name = L["Show Neutral Threat"],
											order = 2,
											width = "full",
											desc = L["Disables threat feedback from neutral mobs regardless of boss or elite levels."],
											descStyle = "inline",
											arg = {"threat","toggle","Neutral"},
										},
										Normal = {
											type = "toggle",
											name = L["Show Normal Threat"],
											order = 3,
											width = "full",
											desc = L["Disables threat feedback from normal mobs."],
											descStyle = "inline",
											arg = {"threat","toggle","Normal"},
										},
										Elite = {
											type = "toggle",
											name = L["Show Elite Threat"],
											order = 4,
											width = "full",
											desc = L["Disables threat feedback from elite mobs."],
											descStyle = "inline",
											arg = {"threat","toggle","Elite"},
										},
										Boss = {
											type = "toggle",
											name = L["Show Boss Threat"],
											order = 5,
											width = "full",
											desc = L["Disables threat feedback from boss level mobs."],
											descStyle = "inline",
											arg = {"threat","toggle","Boss"},
										},
									},
								},
							},
						},
						Alpha = {
							name = L["Alpha"],
							type = "group",
							desc = L["Set alpha settings for different threat reaction types."],
							disabled = function() return not db.threat.ON end,
							order = 1,
							args = {
								Enable = {
									name = L["Enable Alpha Threat"],
									type = "group",
									inline = true,
									order = 0,
									args = {
										Enable = {
											type = "toggle",
											name = L["Enable"],
											desc = L["Enable nameplates to change alpha depending on the levels you set below."],
											width = "full",
											descStyle = "inline",
											order = 2,
											arg = {"threat","useAlpha"}
										},
									},
								},
								Tank = {
									name = L["|cff00ff00Tank|r"],
									type = "group",
									inline = true,
									order = 1,
									disabled = function() if db.threat.useAlpha then return false else return true end end,
									args = {
										Low = {
											name = L["|cffff0000Low threat|r"],
											type = "range",
											order = 1,
											arg = {"threat", "tank","alpha","LOW"},
											min = 0.01,
											max = 1,
											step = 0.01,
											isPercent = true,
										},
										Med = {
											name = L["|cffffff00Medium threat|r"],
											type = "range",
											order = 2,
											arg = {"threat", "tank","alpha","MEDIUM"},
											min = 0.01,
											max = 1,
											step = 0.01,
											isPercent = true,
										},
										High = {
											name = L["|cff00ff00High threat|r"],
											type = "range",
											order = 3,
											arg = {"threat", "tank","alpha","HIGH"},
											min = 0.01,
											max = 1,
											step = 0.01,
											isPercent = true,
										},
										OtherTank = {
											name = "|cff00ff00" .. L["Other tank"] .. "|r",
											type = "range",
											order = 4,
											arg = {"threat", "tank", "alpha", "OTHERTANK"},
											min = 0.01,
											max = 1,
											step = 0.01,
											isPercent = true,
										},
									},
								},
								DPS = {
									name = L["|cffff0000DPS/Healing|r"],
									type = "group",
									inline = true,
									order = 2,
									disabled = function() if db.threat.useAlpha then return false else return true end end,
									args = {
										Low = {
											name = L["|cff00ff00Low threat|r"],
											type = "range",
											order = 1,
											arg = {"threat", "dps","alpha","LOW"},
											min = 0.01,
											max = 1,
											step = 0.01,
											isPercent = true,
										},
										Med = {
											name = L["|cffffff00Medium threat|r"],
											type = "range",
											order = 2,
											arg = {"threat", "dps","alpha","MEDIUM"},
											min = 0.01,
											max = 1,
											step = 0.01,
											isPercent = true,
										},
										High = {
											name = L["|cffff0000High threat|r"],
											type = "range",
											order = 3,
											arg = {"threat", "dps","alpha","HIGH"},
											min = 0.01,
											max = 1,
											step = 0.01,
											isPercent = true,
										},
									},
								},
							},
						},
						Scale = {
							name = L["Scale"],
							type = "group",
							desc = L["Set scale settings for different threat reaction types."],
							disabled = function() return not db.threat.ON end,
							order = 1,
							args = {
								Enable = {
									name = L["Enable Scale Threat"],
									type = "group",
									inline = true,
									order = 0,
									args = {
										Enable = {
											type = "toggle",
											name = L["Enable"],
											desc = L["Enable nameplates to change scale depending on the levels you set below."],
											descStyle = "inline",
											width = "full",
											order = 2,
											arg = {"threat","useScale"}
										},
									},
								},
								Tank = {
									name = L["|cff00ff00Tank|r"],
									type = "group",
									inline = true,
									order = 1,
									disabled = function() if db.threat.useScale then return false else return true end end,
									args = {
										Low = {
											name = L["|cffff0000Low threat|r"],
											type = "range",
											order = 1,
											arg = {"threat", "tank","scale","LOW"},
											min = 0.01,
											max = 2,
											step = 0.01,
											isPercent = true,
										},
										Med = {
											name = L["|cffffff00Medium threat|r"],
											type = "range",
											order = 2,
											arg = {"threat", "tank","scale","MEDIUM"},
											min = 0.01,
											max = 2,
											step = 0.01,
											isPercent = true,
										},
										High = {
											name = L["|cff00ff00High threat|r"],
											type = "range",
											order = 3,
											arg = {"threat", "tank","scale","HIGH"},
											min = 0.01,
											max = 2,
											step = 0.01,
											isPercent = true,
										},
										OtherTank = {
											name = "|cff00ff00" .. L["Other tank"] .. "|r",
											type = "range",
											order = 4,
											arg = {"threat", "tank", "scale", "OTHERTANK"},
											min = 0.01,
											max = 2,
											step = 0.01,
											isPercent = true,
										},
									},
								},
								DPS = {
									name = L["|cffff0000DPS/Healing|r"],
									type = "group",
									inline = true,
									order = 2,
									disabled = function() if db.threat.useScale then return false else return true end end,
									args = {
										Low = {
											name = L["|cff00ff00Low threat|r"],
											type = "range",
											order = 1,
											arg = {"threat", "dps","scale","LOW"},
											min = 0.01,
											max = 2,
											step = 0.01,
											isPercent = true,
										},
										Med = {
											name = L["|cffffff00Medium threat|r"],
											type = "range",
											order = 2,
											arg = {"threat", "dps","scale","MEDIUM"},
											min = 0.01,
											max = 2,
											step = 0.01,
											isPercent = true,
										},
										High = {
											name = L["|cffff0000High threat|r"],
											type = "range",
											order = 3,
											arg = {"threat", "dps","scale","HIGH"},
											min = 0.01,
											max = 2,
											step = 0.01,
											isPercent = true,
										},
									},
								},
								TypeSpecific = {
									name = L["Additional Adjustments"],
									type = "group",
									inline = true,
									order = 4,
									disabled = function() if db.threat.useScale then return false else return true end end,
									args = {
										Toggle = {
											name = L["Enable Adjustments"],
											order = 1,
											type = "toggle",
											width = "full",
											desc = L["This will allow you to add additional scaling changes to specific mob types."],
											descStyle = "inline",
											arg = {"threat","useType"}
										},
										AdditionalSliders = {
											name = L["Additional Adjustments"],
											type = "group",
											order = 3,
											inline = true,
											disabled = function() if not db.threat.useType or not db.threat.useScale then return true else return false end end,
											args = {
												NormalNeutral = {
													name = PLAYER_DIFFICULTY1.." & "..COMBATLOG_FILTER_STRING_NEUTRAL_UNITS,
													order = 1,
													type = "range",
													width = "double",
													arg = {"threat","scaleType", "Normal"},
													min = -0.5,
													max = 0.5,
													step = 0.01,
													isPercent = true,
												},
												Elite = {
													name = ELITE,
													order = 2,
													type = "range",
													width = "double",
													arg = {"threat","scaleType", "Elite"},
													min = -0.5,
													max = 0.5,
													step = 0.01,
													isPercent = true,
												},
												Boss = {
													name = BOSS,
													order = 3,
													type = "range",
													width = "double",
													arg = {"threat","scaleType", "Boss"},
													min = -0.5,
													max = 0.5,
													step = 0.01,
													isPercent = true,
												},
											},
										},
									},
								},
							},
						},
						Coloring = {
							name = L["Coloring"],
							type = "group",
							order = 4,
							get = GetColorAlpha,
							set = SetColorAlpha,
							disabled = function() return not db.threat.ON end,
							args = {
								Toggles = {
									name = L["Toggles"],
									order = 1,
									type = "group",
									inline = true,
									args = {
										UseHPColor = {
											name = L["Color HP by Threat"],
											type = "toggle",
											order = 1,
											desc = L["This allows HP color to be the same as the threat colors you set below."],
											get = GetValue,
											set = SetValue,
											descStyle = "inline",
											width = "full",
											arg = {"threat","useHPColor"}
										},
									},
								},
								Tank = {
									name = L["|cff00ff00Tank|r"],
									type = "group",
									inline = true,
									order = 2,
									args = {
										Low = {
											name = L["|cffff0000Low threat|r"],
											type = "color",
											order = 1,
											arg = {"settings", "tank", "threatcolor", "LOW"},
											hasAlpha = true,
										},
										Med = {
											name = L["|cffffff00Medium threat|r"],
											type = "color",
											order = 2,
											arg = {"settings", "tank", "threatcolor", "MEDIUM"},
											hasAlpha = true,
										},
										High = {
											name = L["|cff00ff00High threat|r"],
											type = "color",
											order = 3,
											arg = {"settings", "tank", "threatcolor", "HIGH"},
											hasAlpha = true,
										},
										OtherTank = {
											name = "|cff00ff00" .. L["Other tank"] .. "|r",
											type = "color",
											order = 4,
											arg = {"settings", "tank", "threatcolor", "OTHERTANK"},
											hasAlpha = true,
										},
									},
								},
								DPS = {
									name = L["|cffff0000DPS/Healing|r"],
									type = "group",
									inline = true,
									order = 3,
									args = {
										Low = {
											name = L["|cff00ff00Low threat|r"],
											type = "color",
											order = 1,
											arg = {"settings", "dps", "threatcolor", "LOW"},
											hasAlpha = true,
										},
										Med = {
											name = L["|cffffff00Medium threat|r"],
											type = "color",
											order = 2,
											arg = {"settings", "dps", "threatcolor", "MEDIUM"},
											hasAlpha = true,
										},
										High = {
											name = L["|cffff0000High threat|r"],
											type = "color",
											order = 3,
											arg = {"settings", "dps", "threatcolor", "HIGH"},
											hasAlpha = true,
										},
									},
								},
							},
						},
						Textures = {
							name = L["Textures"],
							type = "group",
							order = 3,
							desc = L["Set threat textures and their coloring options here."],
							disabled = function() return not db.threat.ON end,
							args = {
								ThreatArt = {
									name = L["Enable"],
									type = "group",
									order = 1,
									inline = true,
									args = {
										Enable = {
											name = L["Enable"],
											type = "toggle",
											order = 1,
											desc = L["These options are for the textures shown on nameplates at various threat levels."],
											descStyle = "inline",
											width = "full",
											arg = {"threat","art","ON"},
										},
									},
								},
								Options = {
									name = L["Art Options"],
									type = "group",
									order = 2,
									inline = true,
									disabled = function() return not db.threat.art.ON end,
									args = {
										Description = {
											type = "description",
											order = 0,
											name = L["Textures are reversed for tanking role."],
											width = "full",
											hidden = function() return db.threat.art.theme ~= "default" end,
										},
										PrevLow = {
											name = L["Low Threat"],
											type = "execute",
											order = 1,
											width = "full",
											image = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\ThreatWidget\\"..db.threat.art.theme.."\\".."LOW",
											imageWidth = 256,
											imageHeight = 64,
										},
										PrevMed = {
											name = L["Medium Threat"],
											type = "execute",
											order = 2,
											width = "full",
											image = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\ThreatWidget\\"..db.threat.art.theme.."\\".."MEDIUM",
											imageWidth = 256,
											imageHeight = 64,
										},
										PrevHigh = {
											name = L["High Threat"],
											type = "execute",
											order = 3,
											width = "full",
											image = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\ThreatWidget\\"..db.threat.art.theme.."\\".."HIGH",
											imageWidth = 256,
											imageHeight = 64,
										},
										Style = {
											name = L["Style"],
											type = "group",
											order = 4,
											inline = true,
											args = {
												Dropdown = {
													name = "",
													type = "select",
													order = 1,
													set = function(info,val)
														SetValue(info,val)
														local i = options.args.ThreatOptions.args.Textures.args.Options.args
														local p = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\ThreatWidget\\"
														i.PrevLow.image = p..db.threat.art.theme.."\\".."LOW"
														i.PrevMed.image = p..db.threat.art.theme.."\\".."MEDIUM"
														i.PrevHigh.image = p..db.threat.art.theme.."\\".."HIGH"
													end,
													values = {default = "Default", bar = "Bar Style"},
													arg = {"threat","art","theme"}
												},
											},
										},
										Marked = {
											name = L["Marked Targets"],
											type = "group",
											inline = true,
											order = 4,
											args = {
												Toggle = {
													name = L["Ignore Marked Targets"],
													order = 2,
													type = "toggle",
													desc = L["This will allow you to disabled threat art on marked targets."],
													descStyle = "inline",
													width = "full",
													arg = {"threat","marked","art"}
												},
											},
										},
									},
								},
							},
						},
					},
				},
				Widgets = {
					name = L["Widgets"],
					type = "group",
					order = 40,
					args = {
						ArenaWidget = {
							name = "Arena Widget",
							type = "group",
							order = 0,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									inline = true,
									order = 10,
									args = {
										Toggle = {
											name = L["Enable"],
											type = "toggle",
											desc = L["Enables the showing if indicator icons for friends, guildmates, and BNET Friends"],
											descStyle = "inline",
											width = "full",
											order = 1,
											arg = {"arenaWidget", "ON"},
										},
									},
								},
								Sizing = {
									name = L["Scale"],
									type = "group",
									inline = true,
									order = 20,
									disabled = function() return not db.arenaWidget.ON end,
									args = {
										ScaleSlider = {
											name = "",
											type = "range",
											min = 5,
											max = 100,
											step = 1,
											arg = {"arenaWidget","scale"}
										},
									},
								},
								Placement = {
									name = L["Placement"],
									type = "group",
									inline = true,
									order = 30,
									disabled = function() return not db.arenaWidget.ON end,
									args = {
										X = {
											name = L["X"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"arenaWidget", "x"},
										},
										Y = {
											name = L["Y"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"arenaWidget", "y"},
										},
									},
								},
								Colors = {
									name = "Arena Orb Colors",
									type = "group",
									inline = true,
									order = 40,
									disabled = function() return not db.arenaWidget.ON end,
									args = {
										Arena1 = {
											name = "Arena 1",
											type = "color",
											order = 1,
											get = GetColorAlpha,
											set = SetColorAlpha,
											hasAlpha = true,
											arg = {"arenaWidget","colors",1},
										},
										Arena2 = {
											name = "Arena 2",
											type = "color",
											order = 2,
											get = GetColorAlpha,
											set = SetColorAlpha,
											hasAlpha = true,
											arg = {"arenaWidget","colors",2},
										},
										Arena3 = {
											name = "Arena 3",
											type = "color",
											order = 3,
											get = GetColorAlpha,
											set = SetColorAlpha,
											hasAlpha = true,
											arg = {"arenaWidget","colors",3},
										},
										Arena4 = {
											name = "Arena 4",
											type = "color",
											order = 4,
											get = GetColorAlpha,
											set = SetColorAlpha,
											hasAlpha = true,
											arg = {"arenaWidget","colors",4},
										},
										Arena5 = {
											name = "Arena 5",
											type = "color",
											order = 5,
											get = GetColorAlpha,
											set = SetColorAlpha,
											hasAlpha = true,
											arg = {"arenaWidget","colors",5},
										},
									},
								},
								numColors = {
									name = "Arena Number Colors",
									type = "group",
									inline = true,
									order = 50,
									disabled = function() return not db.arenaWidget.ON end,
									args = {
										Arena1 = {
											name = "Arena 1",
											type = "color",
											order = 1,
											get = GetColorAlpha,
											set = SetColorAlpha,
											hasAlpha = true,
											arg = {"arenaWidget","numColors",1},
										},
										Arena2 = {
											name = "Arena 2",
											type = "color",
											order = 2,
											get = GetColorAlpha,
											set = SetColorAlpha,
											hasAlpha = true,
											arg = {"arenaWidget","numColors",2},
										},
										Arena3 = {
											name = "Arena 3",
											type = "color",
											order = 3,
											get = GetColorAlpha,
											set = SetColorAlpha,
											hasAlpha = true,
											arg = {"arenaWidget","numColors",3},
										},
										Arena4 = {
											name = "Arena 4",
											type = "color",
											order = 4,
											get = GetColorAlpha,
											set = SetColorAlpha,
											hasAlpha = true,
											arg = {"arenaWidget","numColors",4},
										},
										Arena5 = {
											name = "Arena 5",
											type = "color",
											order = 5,
											get = GetColorAlpha,
											set = SetColorAlpha,
											hasAlpha = true,
											arg = {"arenaWidget","numColors",5},
										},
									},
								},
							},
						},
						AuraWidget = {
							name = L["Aura Widget"],
							type = "group",
							order = 5,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									inline = true,
									order = 10,
									args = {
										Toggle = {
											name = L["Enable"],
											type = "toggle",
											order = 1,
											desc = L["This widget will display auras that match your filtering on your target nameplate and others you recently moused over."],
											descStyle = "inline",
											width = "full",
											arg = {"auraWidget", "ON"},
										},
										TargetOnly = {
											name = L["Target Only"],
											type = "toggle",
											order = 2,
											desc = L["This will toggle the aura widget to only show for your current target."],
											descStyle = "inline",
											width = "full",
											disabled = function() return not db.auraWidget.ON end,
											set = function(info,val)
												SetValue(info,val)
											end,
											arg = {"auraWidget","targetOnly"},
										},
										Show = {
											name = "Display Locations",
											type = "group",
											order = 3,
											inline = true,
											disabled = function() return not db.auraWidget.ON end,
											args = {
												ShowFriendly = {
													name = "Show Friendly",
													order = 1,
													type = "toggle",
													arg = {"auraWidget","showFriendly"},
												},
												ShowEnemy = {
													name = "Show Enemy",
													order = 2,
													type = "toggle",
													arg = {"auraWidget","showEnemy"}
												}
											},
										},
										Display = {
											name = "Include Dispellable Aura Type",
											type = "multiselect",
											order = 4,
											disabled = function() return not db.auraWidget.ON end,
											values = {
												[1] = "Buff",
												[2] = "Curse",
												[3] = "Disease",
												[4] = "Magic",
												[5] = "Poison",
												[6] = "Debuff"
											},
											get = function(info,k)
												return db.auraWidget.displays[k]
											end,
											set = function(info,k,v)
												db.auraWidget.displays[k] = v
												t.Update()
											end,
										},
									},
								},
								Style = {
									name = L["Style"],
									type = "group",
									inline = true,
									disabled = function() return not db.auraWidget.ON end,
									order = 15,
									args = {
										Sizing = {
											name = L["Sizing"],
											type = "group",
											order = 2,
											inline = true,
											disabled = function() return not db.auraWidget.ON end,
											args = {
												columns = {
													name = L["Icons on a line"],
													type = "range",
													order = 1,
													min = 1,
													max = 8,
													step = 1,
													arg = {"auraWidget", "columns"},
												},
												rows = {
													name = L["Icon lines"],
													type = "range",
													order = 2,
													min = 1,
													max = 5,
													step = 1,
													arg = {"auraWidget", "rows"},
												},
												iconWidth = {
													name = L["Icon width"],
													type = "range",
													order = 3,
													min = 10,
													max = 30,
													step = 1,
													arg = {"auraWidget", "iconWidth"},
												},
												iconHeight = {
													name = L["Icon height"],
													type = "range",
													order = 4,
													min = 10,
													max = 30,
													step = 1,
													arg = {"auraWidget", "iconHeight"},
												},
												iconOffsetX = {
													name = L["Horizontal spacing"],
													type = "range",
													order = 5,
													min = 1,
													max = 20,
													step = 1,
													arg = {"auraWidget", "iconOffsetX"},
												},
												iconOffsetY = {
													name = L["Vertical spacing"],
													type = "range",
													order = 6,
													min = 1,
													max = 20,
													step = 1,
													arg = {"auraWidget", "iconOffsetY"},
												},
												Scale = {
													name = L["Scale"],
													type = "range",
													order = 10,
													width = "full",
													step = 0.05,
													softMin = 0.6,
													softMax = 1.3,
													isPercent = true,
													arg = {"auraWidget","scale",}
												},
											},
										},
										Placement = {
											name = L["Placement"],
											type = "group",
											inline = true,
											order = 3,
											disabled = function() return not db.auraWidget.ON end,
											args = {
												X = {
													name = L["X"],
													type = "range",
													order = 1,
													min = -120,
													max = 120,
													step = 1,
													arg = {"auraWidget", "x"},
												},
												Y = {
													name = L["Y"],
													type = "range",
													order = 2,
													min = -120,
													max = 120,
													step = 1,
													arg = {"auraWidget", "y"},
												},
												Anchor = {
													name = L["Anchor"],
													type = "select",
													order = 3,
													values = t.FullAlign,
													arg = {"auraWidget","anchor"}
												},
											},
										},
										Cooldown = {
											name = L["Show radial cooldown"],
											type = "toggle",
											order = 4,
											desc = L["Toggle the display of a radial cooldown over the icon."],
											descStyle = "inline",
											width = "full",
											arg = {"auraWidget", "radialCooldown"},
										},
										Border = {
											name = L["Show icon border"],
											type = "toggle",
											order = 5,
											desc = L["Toggle the display of a border around the icon."],
											descStyle = "inline",
											width = "full",
											arg = {"auraWidget", "iconBorder"},
										},
									},
								},
								Filtering = {
									name = L["Filtering"],
									order = 30,
									type = "group",
									inline = true,
									disabled = function() return not db.auraWidget.ON end,
									args = {
										Mode = {
											name = L["Mode"],
											type = "select",
											order = 1,
											width = "full",
											values = t.DebuffMode,
											arg = {"auraWidget","mode"},
										},
										separator = {
											order = 2,
											type = "description",
											name = "\n",
										},
										Description = {
											type = "description",
											order = 3,
											name = "|cFFFF0202"..L["Type each spell name on a new line."].."|r",
											width = "full",
										},
										DebuffList = {
											name = L["Filtered Auras"],
											type = "input",
											order = 4,
											dialogControl = "MultiLineEditBox",
											width = "full",
											get = function(info) return t.TTS(db.auraWidget.filter) end,
											set = function(info, v)
												local table = {strsplit("\n", v)};
												if v == "" then table = {} end
												db.auraWidget.filter = table
											end,
										},
										AcceptList = {
											name = L["Always Show Auras"],
											type = "input",
											order = 5,
											dialogControl = "MultiLineEditBox",
											width = "full",
											get = function(info) return t.TTS(db.auraWidget.allow) end,
											set = function(info, v)
												local table = {strsplit("\n", v)}
												if v == "" then table = {} end
												db.auraWidget.allow = table
											end,
										},
									},
								},
							},
						},
						ClassIconWidget = {
							name = L["Class Icons"],
							type = "group",
							order = 10,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									inline = true,
									order = 10,
									args = {
										Toggle = {
											name = L["Enable"],
											type = "toggle",
											order = 1,
											desc = L["This widget will display class icons on nameplate with the settings you set below."],
											descStyle = "inline",
											width = "full",
											arg = {"classWidget", "ON"},
										},
									},
								},
								Options = {
									name = L["Options"],
									type = "group",
									inline = true,
									order = 20,
									disabled = function() return not db.classWidget.ON end,
									args = {
										FriendlyClass = {
											name = L["Enable Friendly Icons"],
											type = "toggle",
											desc = L["Enable the showing of friendly player class icons."],
											descStyle = "inline",
											width = "full",
											arg = {"friendlyClassIcon"},
										},
									},
								},
								Textures = {
									name = L["Textures"],
									type = "group",
									inline = true,
									order = 30,
									disabled = function() return not db.classWidget.ON end,
									args = {},
								},
								Sizing = {
									name = L["Scale"],
									type = "group",
									inline = true,
									order = 40,
									disabled = function() return not db.classWidget.ON end,
									args = {
										ScaleSlider = {
											name = "",
											type = "range",
											arg = {"classWidget","scale"}
										},
									},
								},
								Placement = {
									name = L["Placement"],
									type = "group",
									inline = true,
									order = 50,
									disabled = function() return not db.classWidget.ON end,
									args = {
										X = {
											name = L["X"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"classWidget", "x"},
										},
										Y = {
											name = L["Y"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"classWidget", "y"},
										},
									},
								},
							},
						},
						ComboPointWidget = {
							name = L["Combo Points"],
							type = "group",
							order = 20,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									inline = true,
									order = 10,
									args = {
										Toggle = {
											name = L["Enable"],
											type = "toggle",
											order = 1,
											desc = L["This widget will display combo points on your target nameplate."],
											descStyle = "inline",
											width = "full",
											arg = {"comboWidget", "ON"},
										},
									},
								},
								Sizing = {
									name = L["Scale"],
									type = "group",
									inline = true,
									order = 20,
									disabled = function() return not db.comboWidget.ON end,
									args = {
										ScaleSlider = {
											name = "",
											type = "range",
											step = 0.05,
											softMin = 0.6,
											softMax = 1.3,
											isPercent = true,
											arg = {"comboWidget","scale"}
										},
									},
								},
								Placement = {
									name = L["Placement"],
									type = "group",
									inline = true,
									order = 30,
									disabled = function() return not db.comboWidget.ON end,
									args = {
										X = {
											name = L["X"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"comboWidget", "x"},
										},
										Y = {
											name = L["Y"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"comboWidget", "y"},
										},
									},
								},
							},
						},
						HealerTrackerWidget = {
							name = "Healer Tracker",
							type = "group",
							order = 30,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									inline = true,
									order = 10,
									args = {
										Toggle = {
											name = L["Enable"],
											type = "toggle",
											desc = L["Enables the showing if indicator icons for friends, guildmates, and BNET Friends"],
											descStyle = "inline",
											width = "full",
											order = 1,
											arg = {"healerTracker", "ON"},
										},
									},
								},
								Sizing = {
									name = L["Scale"],
									type = "group",
									inline = true,
									order = 20,
									disabled = function() if db.healerTracker.ON then return false else return true end end,
									args = {
										ScaleSlider = {
											name = "",
											type = "range",
											step = 0.05,
											softMin = 0.6,
											softMax = 1.3,
											isPercent = true,
											arg = {"healerTracker","scale"}
										},
									},
								},
								Placement = {
									name = L["Placement"],
									type = "group",
									inline = true,
									order = 30,
									disabled = function() if db.healerTracker.ON then return false else return true end end,
									args = {
										X = {
											name = L["X"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"healerTracker", "x"},
										},
										Y = {
											name = L["Y"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"healerTracker", "y"},
										},
									},
								},
							},
						},
						QuestWidget = {
							name = L["Quest Icons"],
							type = "group",
							order = 35,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									inline = true,
									order = 10,
									args = {
										Toggle = {
											name = L["Enable"],
											type = "toggle",
											order = 1,
											desc = L["This widget will display quest icons on nameplates that are quest objectives."],
											descStyle = "inline",
											width = "full",
											arg = {"questWidget", "ON"},
										},
									},
								},
								Sizing = {
									name = L["Scale"],
									type = "group",
									inline = true,
									order = 20,
									disabled = function() return not db.questWidget.ON end,
									args = {
										ScaleSlider = {
											name = "",
											type = "range",
											step = 1,
											min = 10,
											max = 60,
											arg = {"questWidget","scale"}
										},
									},
								},
								Placement = {
									name = L["Placement"],
									type = "group",
									inline = true,
									order = 30,
									disabled = function() return not db.questWidget.ON end,
									args = {
										X = {
											name = L["X"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"questWidget", "x"},
										},
										Y = {
											name = L["Y"],
											type = "range",
											order = 2,
											min = -120,
											max = 120,
											step = 1,
											arg = {"questWidget", "y"},
										},
										Anchor = {
											name = L["Anchor"],
											type = "select",
											order = 3,
											values = t.FullAlign,
											arg = {"questWidget","anchor"}
										},
									},
								},
							},
						},
						SocialWidget = {
							name = L["Social Widget"],
							type = "group",
							order = 40,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									inline = true,
									order = 10,
									args = {
										Toggle = {
											name = L["Enable"],
											type = "toggle",
											desc = L["Enables the showing if indicator icons for friends, guildmates, and BNET Friends"],
											descStyle = "inline",
											width = "full",
											order = 1,
											arg = {"socialWidget", "ON"},
										},
									},
								},
								Sizing = {
									name = L["Scale"],
									type = "group",
									inline = true,
									order = 20,
									disabled = function() return not db.socialWidget.ON end,
									args = {
										ScaleSlider = {
											name = "",
											type = "range",
											arg = {"socialWidget","scale"}
										},
									},
								},
								Placement = {
									name = L["Placement"],
									type = "group",
									inline = true,
									order = 30,
									disabled = function() return not db.socialWidget.ON end,
									args = {
										X = {
											name = L["X"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"socialWidget", "x"},
										},
										Y = {
											name = L["Y"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"socialWidget", "y"},
										},
									},
								},
							},
						},
						TankedWidget = {
							name = L["Tanked Widget"],
							type = "group",
							order = 50,
							set = SetValue,
							get = GetValue,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									inline = true,
									order = 10,
									args = {
										Toggle = {
											name = L["Enable"],
											type = "toggle",
											order = 1,
											desc = L["This widget will display a small shield or dagger that will indicate if the nameplate is currently being tanked."],
											descStyle = "inline",
											width = "full",
											arg = {"tankedWidget", "ON"},
										},
									},
								},
								Sizing = {
									name = L["Scale"],
									type = "group",
									inline = true,
									order = 20,
									disabled = function() if not db.tankedWidget.ON or not TidyPlatesThreat:isTank() then return true else return false end end,
									args = {
										ScaleSlider = {
											name = "",
											type = "range",
											step = 1,
											min = 10,
											max = 60,
											arg = {"tankedWidget","scale"}
										},
									},
								},
								Placement = {
									name = L["Placement"],
									type = "group",
									inline = true,
									order = 30,
									disabled = function() if not db.tankedWidget.ON or not TidyPlatesThreat:isTank() then return true else return false end end,
									args = {
										X = {
											name = L["X"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"tankedWidget", "x"},
										},
										Y = {
											name = L["Y"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"tankedWidget", "y"},
										},
										Anchor = {
											name = L["Anchor"],
											type = "select",
											order = 4,
											values = t.FullAlign,
											arg = {"tankedWidget","anchor"}
										},
									},
								},
							},
						},
						TargetArtWidget = {
							name = L["Target Highlight"],
							type = "group",
							order = 60,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									inline = true,
									order = 10,
									args = {
										Toggle = {
											name = L["Enable"],
											type = "toggle",
											desc = L["Enables the showing of a texture on your target nameplate"],
											descStyle = "inline",
											width = "full",
											order = 1,
											arg = {"targetWidget", "ON"},
										},
									},
								},
								Texture = {
									name = L["Texture"],
									type = "group",
									inline = true,
									disabled = function() if db.targetWidget.ON then return false else return true end end,
									args = {
										Preview = {
											name = L["Preview"],
											order = 0,
											width = "full",
											type = "execute",
											image = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\TargetArtWidget\\"..db.targetWidget.theme,
											imageWidth = 256,
											imageHeight = 64,
										},
										Color = {
											name = L["Color"],
											type = "color",
											width = "full",
											order = 1,
											get = GetColorAlpha,
											set = SetColorAlpha,
											hasAlpha = true,
											arg = {"targetWidget"},
										},
										Select = {
											name = L["Style"],
											type = "select",
											width = "full",
											order = 3,
											set = function(info,val)
												SetValue(info,val)
												options.args.Widgets.args.TargetArtWidget.args.Texture.args.Preview.image = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\TargetArtWidget\\"..db.targetWidget.theme;
											end,
											values = { default = "Default", arrows = "Arrows", crescent = "Crescent", bubble = "Bubble", brackets = "Brackets" },
											arg = {"targetWidget","theme"},
										},
									},
								},
							},
						},--[[
						ThreatLineWidget = {
							name = L["Threat Line"],
							type = "group",
							order = 70,
							args = {
								Enable = {
									name = L["Enable"],
									type = "group",
									inline = true,
									order = 10,
									args = {
										Toggle = {
											name = L["Enable"],
											type = "toggle",
											order = 1,
											desc = L["This widget will display a small bar that will display your current threat relative to other players on your target nameplate or recently mousedover namplates."],
											descStyle = "inline",
											width = "full",
											arg = {"threatWidget", "ON"},
										},
									},
								},
								Placement = {
									name = L["Placement"],
									type = "group",
									inline = true,
									order = 20,
									disabled = function() if db.threatWidget.ON then return false else return true end end,
									args = {
										X = {
											name = L["X"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"threatWidget", "x"},
										},
										Y = {
											name = L["Y"],
											type = "range",
											order = 1,
											min = -120,
											max = 120,
											step = 1,
											arg = {"threatWidget", "y"},
										},
										Anchor = {
											name = L["Anchor"],
											type = "select",
											order = 4,
											values = t.FullAlign,
											arg = {"threatWidget","anchor"}
										},
									},
								},
							},
						},]]--
					},
				},
				Totems = {
					name = L["Totem Nameplates"],
					type = "group",
					childGroups = "list",
					order = 50,
					args = {},
				},
				Custom = {
					name = L["Custom Nameplates"],
					type = "group",
					childGroups = "list",
					order = 60,
					args = {},
				},
			},
		}
	end
	local ClassOpts_OrderCount = 1
	local ClassOpts = {
		Style = {
			name = "Style",
			order = -1,
			type = "select",
			width = "full",
			set = function(info,val)
				SetValue(info,val)
				for k_c,v_c in pairs(CLASS_SORT_ORDER) do
					options.args.Widgets.args.ClassIconWidget.args.Textures.args["Prev"..k_c].image = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\ClassIconWidget\\"..db.classWidget.theme.."\\"..CLASS_SORT_ORDER[k_c]
				end
			end,
			values = {default = "Default",transparent = "Transparent"},
			arg = {"classWidget","theme"},
		},
	};
	for k_c,v_c in pairs(CLASS_SORT_ORDER) do
		ClassOpts["Prev"..k_c] = {
			name = CLASS_SORT_ORDER[k_c],
			type = "execute",
			order = ClassOpts_OrderCount,
			image = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\ClassIconWidget\\"..db.classWidget.theme.."\\"..CLASS_SORT_ORDER[k_c],
		}
		ClassOpts_OrderCount = ClassOpts_OrderCount+1
	end
	options.args.Widgets.args.ClassIconWidget.args.Textures.args = ClassOpts
	local TotemOpts = {
		TotemSettings = {
			name = L["|cffffffffTotem Settings|r"],
			type = "group",
			order = 0,
			get = GetValue,
			set = SetValue,
			args = {
				Toggles = {
					name = L["Toggling"],
					type = "group",
					order = 1,
					inline = true,
					args = {
						HideHealth = {
							name = L["Hide Healthbars"],
							type = "toggle",
							order = 1,
							arg = {"totemSettings","hideHealthbar"},
						},
						Header1 = {
							type = "header",
							order = 2,
							name = "",
						},
						ShowEnemy = {
							name = L["Show Enemy Totems"],
							type = "toggle",
							order = 3,
							get = GetCvar,
							set = SetCvar,
							arg = "nameplateShowEnemyTotems",
						},
						ShowFriend = {
							name = L["Show Friendly Totems"],
							type = "toggle",
							order = 4,
							get = GetCvar,
							set = SetCvar,
							arg = "nameplateShowFriendlyTotems",
						},
					},
				},
				Icon = {
					name = L["Icon"],
					type = "group",
					order = 2,
					inline = true,
					args = {
						Enable = {
							name = L["Enable"],
							type = "toggle",
							order = 1,
							arg = {"totemWidget","ON"}
						},
						Options = {
							name = L["Options"],
							type = "group",
							inline = true,
							order = 2,
							disabled = function() return not db.totemWidget.ON end,
							args = {
								Header1 = {
									type = "header",
									order = 1,
									name = L["Placement"],
								},
								X = {
									name = L["X"],
									type = "range",
									order = 2,
									min = -120,
									max = 120,
									step = 1,
									arg = {"totemWidget","x"},
								},
								Y = {
									name = L["Y"],
									type = "range",
									order = 3,
									min = -120,
									max = 120,
									step = 1,
									arg = {"totemWidget","y"},
								},
								Anchor = {
									name = L["Anchor"],
									type = "select",
									order = 4,
									values = t.FullAlign,
									arg = {"totemWidget","anchor"}
								},
								Header2 = {
									type = "header",
									order = 4,
									name = "",
								},
								Scale = {
									name = L["Icon Size"],
									type = "range",
									width = "full",
									order = 5,
									min = 0,
									max = 120,
									step = 1,
									arg = {"totemWidget","scale"},
								},
							},
						},
					},
				},
				Alpha = {
					name = L["Alpha"],
					type = "group",
					order = 3,
					inline = true,
					args = {
						TotemAlpha = {
							name = L["Totem Alpha"],
							order = 1,
							type = "range",
							width = "full",
							arg = {"nameplate","alpha","Totem"},
							step = 0.05,
							min = 0,
							max = 1,
							isPercent = true,
						},
					},
				},
				Scale = {
					name = L["Scale"],
					type = "group",
					order = 4,
					inline = true,
					args = {
						TotemAlpha = {
							name = L["Totem Scale"],
							order = 1,
							type = "range",
							width = "full",
							arg = {"nameplate","scale","Totem"},
							step = 0.05,
							softMin = 0.6,
							softMax = 1.5,
							isPercent = true,
						},
					},
				},
			},
		},
	};
for spellName, textureName in pairs(t.Totems) do
	TotemOpts[spellName] = {
		name = spellName,
		type = "group",
		order = t.TotemsOrder[spellName],
		args = {
			Header = {
				name = "> "..spellName.." <",
				type = "header",
				order = 0,
			},
			Enabled = {
				name = L["Enable"],
				type = "group",
				inline = true,
				order = 1,
				args = {
					Toggle = {
						name = L["Show Nameplate"],
						type = "toggle",
						arg = {"totemSettings",textureName,1},
					},
				},
			},
			HealthColor = {
				name = L["Health Coloring"],
				type = "group",
				order = 2,
				inline = true,
				disabled = function() if db.totemSettings[textureName][1] then return false else return true end end,
				args = {
					Enable = {
						name = L["Enable Custom Colors"],
						type = "toggle",
						order = 1,
						arg = {"totemSettings",textureName,2},
					},
					Color = {
						name = L["Color"],
						type = "color",
						order = 2,
						get = GetColor,
						set = SetColor,
						disabled = function() if not db.totemSettings[textureName][1] or not db.totemSettings[textureName][2] then return true else return false end end,
						arg = {"totemSettings",textureName,"color"},
					},
				},
			},
			Textures = {
				name = L["Textures"],
				type = "group",
				order = 3,
				inline = true,
				disabled = function() if db.totemSettings[textureName][1] then return false else return true end end,
				args = {
					Icon = {
						name = "",
						type = "execute",
						width = "full",
						order = 0,
						image = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\TotemIconWidget\\"..db.totemSettings[textureName][7].."\\"..textureName,
					},
					Style = {
						name = "",
						type = "select",
						order = 1,
						width = "full",
						set = function(info,val)
							SetValue(info, val)
							options.args.Totems.args[spellName].args.Textures.args.Icon.image = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\TotemIconWidget\\"..db.totemSettings[textureName][7].."\\"..textureName;
						end,
						values = {normal = "Normal", special = "Special"},
						arg = {"totemSettings",textureName,7},
					},
				},
			},
		},
	}
end
options.args.Totems.args = TotemOpts;
local CustomOpts_OrderCnt = 30;
local CustomOpts = {
	GeneralSettings = {
		name = L["|cffffffffGeneral Settings|r"],
		type = "group",
		order = 0,
		args = {
			Icon = {
				name = L["Icon"],
				type = "group",
				order = 1,
				inline = true,
				args = {
					Enable = {
						name = L["Enable"],
						type = "toggle",
						desc = L["Disabling this will turn off any all icons without harming custom settings per nameplate."],
						descStyle = "inline",
						width = "full",
						order = 1,
						arg = {"uniqueWidget","ON"}
					},
					Options = {
						name = L["Options"],
						type = "group",
						inline = true,
						order = 2,
						disabled = function() if db.uniqueWidget.ON then return false else return true end end,
						args = {
							Header1 = {
								type = "header",
								order = 1,
								name = L["Placement"],
							},
							X = {
								name = L["Y"],
								type = "range",
								order = 2,
								min = -120,
								max = 120,
								step = 1,
								arg = {"uniqueWidget","x"},
							},
							Y = {
								name = L["Y"],
								type = "range",
								order = 3,
								min = -120,
								max = 120,
								step = 1,
								arg = {"uniqueWidget","y"},
							},
							Anchor = {
								name = L["Anchor"],
								type = "select",
								order = 4,
								values = t.FullAlign,
								arg = {"uniqueWidget","anchor"}
							},
							Header2 = {
								type = "header",
								order = 4,
								name = L["Sizing"],
							},
							Scale = {
								name = "",
								type = "range",
								order = 5,
								min = 0,
								max = 120,
								step = 1,
								arg = {"uniqueWidget","scale"},
							},
						},
					},
				},
			},
		},
	},
};
local CustomOpts_OrderCnt = 30;
local clipboard = nil;
for k_c,v_c in ipairs(db.uniqueSettings) do
	CustomOpts["#"..k_c] = {
		name = "#"..k_c..". "..db.uniqueSettings[k_c].name,
		type = "group",
		order = CustomOpts_OrderCnt,
		args = {
			Header = {
				name = db.uniqueSettings[k_c].name,
				type = "header",
				order = 0,
			},
			Name = {
				name = L["Set Name"],
				order = 1,
				type = "group",
				inline = true,
				args = {
					SetName = {
						name = db.uniqueSettings[k_c].name,
						type = "input",
						order = 1,
						width = "full",
						set = function(info,val)
							SetValue(info,val)
							options.args.Custom.args["#"..k_c].name = "#"..k_c..". "..val
							options.args.Custom.args["#"..k_c].args.Header.name = val
							options.args.Custom.args["#"..k_c].args.Name.args.SetName.name = val
							UpdateSpecial()
						end,
						arg = {"uniqueSettings",k_c,"name"},
					},
					TargetButton = {
						name = L["Use Target's Name"],
						type = "execute",
						order = 2,
						width = "single",
						func = function()
							if UnitExists("Target") then
								local target = UnitName("Target")
								print(target)
								db.uniqueSettings[k_c].name = target
								options.args.Custom.args["#"..k_c].name = "#"..k_c..". "..target
								options.args.Custom.args["#"..k_c].args.Header.name = target
								options.args.Custom.args["#"..k_c].args.Name.args.SetName.name = target
								UpdateSpecial()
							else
								t.Print(L["No target found."])
							end
						end,
					},
					ClearButton = {
						name = L["Clear"],
						type = "execute",
						order = 3,
						width = "single",
						func = function()
							db.uniqueSettings[k_c].name = ""
							options.args.Custom.args["#"..k_c].name = "#"..k_c..". "..""
							options.args.Custom.args["#"..k_c].args.Header.name = ""
							options.args.Custom.args["#"..k_c].args.Name.args.SetName.name = ""
							UpdateSpecial()
						end,
					},
					Header1 = {
						name = "",
						order = 4,
						type = "header",
					},
					Copy = {
						name = L["Copy"],
						order = 5,
						type = "execute",
						func = function()
							clipboard = {}
							clipboard = t.CopyTable(db.uniqueSettings[k_c])
							t.Print(L["Copied!"])
						end,
					},
					Paste = {
						name = L["Paste"],
						order = 6,
						type = "execute",
						func = function()
							if type(clipboard) == "table" and clipboard.name then
								db.uniqueSettings[k_c] = t.CopyTable(clipboard)
								t.Print(L["Pasted!"])
							else
								t.Print(L["Nothing to paste!"])
							end
							options.args.Custom.args["#"..k_c].name = "#"..k_c..". "..db.uniqueSettings[k_c].name
							options.args.Custom.args["#"..k_c].args.Header.name = db.uniqueSettings[k_c].name
							options.args.Custom.args["#"..k_c].args.Name.args.SetName.name = db.uniqueSettings[k_c].name
							if tonumber(db.uniqueSettings[k_c].icon) == nil then
								options.args.Custom.args["#"..k_c].args.Icon.args.Icon.image = db.uniqueSettings[k_c].icon
							else
								local icon = select(3, GetSpellInfo(tonumber(db.uniqueSettings[k_c].icon)))
								if icon then
									options.args.Custom.args["#"..k_c].args.Icon.args.Icon.image = icon
								else
									options.args.Custom.args["#"..k_c].args.Icon.args.Icon.image = "Interface\\Icons\\Temp"
								end
							end
							UpdateSpecial()
							clipboard = nil
						end,
					},
					Header2 = {
						name = "",
						order = 7,
						type = "header",
					},
					ResetDefault = {
						type = "execute",
						name = L["Restore Defaults"],
						order = 8,
						func = function()
							local defaults = {
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
							}
							db.uniqueSettings[k_c] = defaults
							options.args.Custom.args["#"..k_c].name = "#"..k_c..". "..""
							options.args.Custom.args["#"..k_c].args.Header.name = ""
							options.args.Custom.args["#"..k_c].args.Name.args.SetName.name = ""
							options.args.Custom.args["#"..k_c].args.Icon.args.Icon.image = ""
							UpdateSpecial()
						end,
					},
				},
			},
			Enabled = {
				name = L["Enable"],
				type = "group",
				inline = true,
				order = 2,
				args = {
					UseStyle = {
						name = L["Use Custom Settings"],
						type = "toggle",
						order = 1,
						arg = {"uniqueSettings",k_c,"useStyle"},
					},
					Header1 = {
						type = "header",
						order = 2,
						name = "",
					},
					Namplate = {
						name = L["Show Nameplate"],
						type = "toggle",
						disabled = function() if db.uniqueSettings[k_c].useStyle then return false else return true end end,
						order = 3,
						arg = {"uniqueSettings",k_c,"showNameplate"},
					},
					CustomSettings = {
						name = L["Custom Settings"],
						type = "group",
						inline = true,
						order = 4,
						disabled = function() if not db.uniqueSettings[k_c].useStyle or not db.uniqueSettings[k_c].showNameplate then return true else return false end end,
						args = {
							AlphaSettings = {
								name = L["Alpha"],
								type = "group",
								order = 1,
								inline = true,
								args = {
									DisableOverride = {
										name = L["Disable Custom Alpha"],
										type = "toggle",
										desc = L["Disables the custom alpha setting for this nameplate and instead uses your normal alpha settings."],
										descStyle = "inline",
										width = "full",
										order = 1,
										arg = {"uniqueSettings",k_c,"overrideAlpha"},
									},
									AlphaSetting = {
										name = L["Custom Alpha"],
										type = "range",
										order = 2,
										disabled = function() if db.uniqueSettings[k_c].overrideAlpha or not db.uniqueSettings[k_c].useStyle or not db.uniqueSettings[k_c].showNameplate then return true else return false end end,
										min = 0,
										max = 1,
										step = 0.05,
										isPercent = true,
										arg = {"uniqueSettings",k_c,"alpha"},
									},
								},
							},
							ScaleSettings = {
								name = L["Scale"],
								type = "group",
								order = 1,
								inline = true,
								args = {
									DisableOverride = {
										name = L["Disable Custom Scale"],
										type = "toggle",
										desc = L["Disables the custom scale setting for this nameplate and instead uses your normal scale settings."],
										descStyle = "inline",
										width = "full",
										order = 1,
										arg = {"uniqueSettings",k_c,"overrideScale"},
									},
									ScaleSetting = {
										name = L["Custom Scale"],
										type = "range",
										order = 2,
										disabled = function() if db.uniqueSettings[k_c].overrideScale or not db.uniqueSettings[k_c].useStyle or not db.uniqueSettings[k_c].showNameplate then return true else return false end end,
										min = 0,
										max = 1.4,
										step = 0.05,
										isPercent = true,
										arg = {"uniqueSettings",k_c,"scale"},
									},
								},

							},
							HealthColor = {
								name = L["Health Coloring"],
								type = "group",
								order = 3,
								inline = true,
								args = {
									UseRaidMarked = {
										name = L["Allow Marked HP Coloring"],
										type = "toggle",
										desc = L["Allow raid marked hp color settings instead of a custom hp setting if the nameplate has a raid mark."],
										descStyle = "inline",
										width = "full",
										order = 1,
										arg = {"uniqueSettings",k_c,"allowMarked"},
									},
									Enable = {
										name = L["Enable Custom Colors"],
										type = "toggle",
										order = 2,
										width = "full",
										arg = {"uniqueSettings",k_c,"useColor"},
									},
									Color = {
										name = L["Color"],
										type = "color",
										order = 3,
										get = GetColor,
										set = SetColor,
										disabled = function() if not db.uniqueSettings[k_c].useColor or not db.uniqueSettings[k_c].useStyle or not db.uniqueSettings[k_c].showNameplate then return true else return false end end,
										arg = {"uniqueSettings",k_c,"color"},
									},
								},
							},
						},
					},
				},
			},
			Icon = {
				name = L["Icon"],
				type = "group",
				order = 3,
				inline = true,
				disabled = function() if not db.uniqueWidget.ON or not db.uniqueSettings[k_c].showNameplate then return true else return false end end,
				args = {
					Enable = {
						name = L["Enable"],
						type = "toggle",
						order = 1,
						desc = L["Enable the showing of the custom nameplate icon for this nameplate."],
						descStyle = "inline",
						width = "full",
						arg = {"uniqueSettings",k_c,"showIcon"}

					},
					Icon = {
						name = L["Preview"],
						type = "execute",
						width = "full",
						disabled = function() if not db.uniqueSettings[k_c].showIcon or not db.uniqueWidget.ON or not db.uniqueSettings[k_c].showNameplate then return true else return false end end,
						order = 2,
						image = function()
							if tonumber(db.uniqueSettings[k_c].icon) == nil then
								return db.uniqueSettings[k_c].icon
							else
								local icon = select(3, GetSpellInfo(tonumber(db.uniqueSettings[k_c].icon)))
								if icon then
									return icon
								else
									return "Interface\\Icons\\Temp"
								end
							end
						end,
						imageWidth = 64,
						imageHeight = 64,
					},
					Description = {
						type = "description",
						order = 3,
						name = L["Type direct icon texture path using '\\' to separate directory folders, or use a spellid."],
						width = "full",
					},
					SetIcon = {
						name = L["Set Icon"],
						type = "input",
						order = 4,
						disabled = function() if not db.uniqueSettings[k_c].showIcon or not db.uniqueWidget.ON or not db.uniqueSettings[k_c].showNameplate then return true else return false end end,
						width = "full",
						set = function(info,val)
							if tonumber(val) then
								val = select(3, GetSpellInfo(tonumber(val)))
							end
							SetValue(info,val)
							if val then
								options.args.Custom.args["#"..k_c].args.Icon.args.Icon.image = val
							else
								options.args.Custom.args["#"..k_c].args.Icon.args.Icon.image = "Interface\\Icons\\Temp"
							end
							UpdateSpecial()
						end,
						arg = {"uniqueSettings",k_c,"icon"},
					},
				},
			},
		},
	}
	CustomOpts_OrderCnt = CustomOpts_OrderCnt + 10;
	end
	options.args.Custom.args = CustomOpts;
	return options
end

local intoptions = nil;
local function GetIntOptions()
	if not intoptions then
		intoptions = {
			name = t.Meta("titleColored").." "..t.Meta("version"),
			handler = TidyPlatesThreat,
			type = "group",
			args = {
				note = {
					type = "description",
					name = L["You can access the "]..t.Meta("titleColored").." "..t.Meta("version")..L[" options by typing: /tptp"],
					order = 10,
				},
				openoptions = {
					type = "execute",
					name = L["Open Config"],
					image = path.."Logo",
					width = "full",
					imageWidth = 256,
					imageHeight = 32,
					func = function()
						TidyPlatesThreat:OpenOptions()
					end,
					order = 20,
				},
			},
		};
	end
	return intoptions;
end

function TidyPlatesThreat:OpenOptions()
	HideUIPanel(InterfaceOptionsFrame)
	HideUIPanel(GameMenuFrame)
	if not options then TidyPlatesThreat:SetUpOptions() end
	LibStub("AceConfigDialog-3.0"):Open("Tidy Plates: Threat");
end

function TidyPlatesThreat:ChatCommand(input)
	TidyPlatesThreat:OpenOptions();
end

function TidyPlatesThreat:ConfigRefresh()
	db = self.db.profile;
	t.SetThemes(self)
	UpdateSpecial()
end

function TidyPlatesThreat:SetUpInitialOptions()
	-- Chat Command
	self:RegisterChatCommand("tptp", "ChatCommand");

	-- Interface panel options

	LibStub("AceConfig-3.0"):RegisterOptionsTable("Tidy Plates: Threat Dialog", GetIntOptions);

	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Tidy Plates: Threat Dialog", "Tidy Plates: Threat");
end

function TidyPlatesThreat:AddOptions(class)
	local AddOptionsTable = {
		DEATHKNIGHT = {
			AuraType = L["Presences"],
			index = "presences",
			names = {
				[1] = GetSpellInfo(48263), -- Blood
				[2] = GetSpellInfo(48266), -- Frost
				[3] = GetSpellInfo(48265) -- Unholy
			},
		},
		DRUID = {
			AuraType = L["Shapeshifts"],
			index = "shapeshifts",
			names = {
				[1] = GetSpellInfo(5487), -- Bear Form
				[2] = GetSpellInfo(783), -- Cat Form
				[3] = GetSpellInfo(783), -- Travel Form
				[4] = GetSpellInfo(114282)..", "..GetSpellInfo(24858) -- Tree of Life (Glyphed), Moonkin
			},
		},
		PALADIN = {
			AuraType = L["Seals"],
			index = "seals",
			names = {
				[1] = GetSpellInfo(465), -- Devotion Aura
				[2] = GetSpellInfo(7294), -- Retribution Aura
				[3] = GetSpellInfo(19746), -- Concentration Aura
				[4] = GetSpellInfo(19891), -- Resistance Aura
				[5] = GetSpellInfo(32223) -- Crusader Aura
			},
		},
		WARRIOR = {
			AuraType = L["Stances"],
			index = "stances",
			names = {
				[1] = GetSpellInfo(2457), -- Battle Stance
				[2] = GetSpellInfo(71), -- Defensive Stance
				[3] = GetSpellInfo(2458) -- Berserker Stance
			},
		},
	}
	local index = AddOptionsTable[class].index
	local _db = TidyPlatesThreat.db.char[index]
	local AdditionalOptions = {
		type = "group",
		name = AddOptionsTable[class].AuraType,
		order = 70,
		args = {
			Enable = {
				type = "toggle",
				order = 1,
				name = L["Enable"],
				get = GetValueChar,
				set = SetValueChar,
				arg = {index,"ON"},
			},
			Options = {
				type = "group",
				order = 2,
				inline = false,
				disabled = function() if not _db.ON or not TidyPlatesThreat.db.profile.threat.ON then return true else return false end end,
				name = L["Options"],
				args = {},
			},
		},
	}
	local addorder = 20
	for k_c,k_v in pairs(AddOptionsTable[class].names) do
		print(k_c.. " "..k_v)
		AdditionalOptions.args.Options.args[index..k_c] = {
			type = "group",
			name = k_v,
			inline = true,
			order = k_c,
			args = {
				Tank = {
					type = "toggle",
					order = 1,
					name = L["|cff00ff00Tank|r"],
					get = function(info) if _db[k_c] then return true else return false end end,
					set = function(info, val) _db[k_c] = true; TidyPlatesThreat.ShapeshiftUpdate() end,
				},
				DPS = {
					type = "toggle",
					order = 2,
					name = L["|cffff0000DPS/Healing|r"],
					get = function(info) if not _db[k_c] then return true else return false end end,
					set = function(info, val) _db[k_c] = false; TidyPlatesThreat.ShapeshiftUpdate() end,
				},
			},
		}
		addorder = addorder + 10
	end
	options.args.Stances = {};
	options.args.Stances = AdditionalOptions;
end

function TidyPlatesThreat:SetUpOptions()
	db = self.db.profile;

	-- Options Window
	GetOptions();
	UpdateSpecial();

	if class == "DEATHKNIGHT" or class == "DRUID" or class == "PALADIN" or class == "WARRIOR" then
		--TidyPlatesThreat:AddOptions(class)
	end

	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db);
	options.args.profiles.order = 10000;

	LibStub("AceConfig-3.0"):RegisterOptionsTable("Tidy Plates: Threat", options);
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("Tidy Plates: Threat", 750, 600)
end
