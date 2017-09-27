local AddOn, ns = ...

local L = AleaUI_GUI.GetLocale("FeralDotDamage")
local anonce_spells = {
	[77764] 	= { target = "", text = "%spell !!!", on = true, chat = 1 },
	[93985] 	= { target = "", text = "%spell -> %target %extraspell", on = true, chat = 1, iffailed = true },
	[20484] 	= { target = "", text = "%spell -> %target", on = true, chat = 1 },
	[61336]		= { target = "", text = "%spell -> %source", on = true, chat = 1 },
}
	
function ns:DefaultOptions()
	local default = {
	
			Frames = {
				ManaBar = {
					point = "CENTERUIParentCENTER1-132",
				},
				HealthBar = {
					point = "CENTERUIParentCENTER1-132",
				},
				MultiTargetFrames = {
					point = "CENTERUIParentCENTER-264-161",
				},
				EnergyBar = {
					point = "CENTERUIParentCENTER0-108",
				},
				CooldownsFrames = {
					point = "CENTERUIParentCENTER0-204",
				},
				IconsBar = {
					point = "CENTERUIParentCENTER0-137",
				},
				FrameBackground = {
					point = "CENTERUIParentCENTER-73151",
				},
				CombopointBar = {
					point = "CENTERUIParentCENTER0-92",
				},
				BuffCheckFrames = {
					point = "LEFTUIParentLEFT3000",
				},
			},
			
			locked = true,
			
			minimap = {
				hide = true,
			},			
			
			pos = { 0, -136 },
			
			growing = false,
			
			count_cp_to_power = false,
			show_on_target = false,
			show_in_combat = false,
			show_only_catform = false,
			show_for_non_feral_spec = false,
			show_for_guardian_spec = false,
			
			multi_xpos = -236,
			multi_ypos = -158,
			multi_scale = 1,
			multi_icon_size = 23,
			multi_font_size = 15,
			multi_font_icon_size = 16,
			multi_icon_gap = 4,
			multi_icon_hide_not_exists = true,
			multi_target_color = { 1, 1, 0, 1},
			multi_enable = true,
			multi_spacing = 4,
			multi_hide_names = false,
			multi_icon_time_format = 1,
			multi_show_target = true,
			multi_spells_ = {				
				[155722] 	= { true, 1 }, 
				[1079]		= { true, 2 }, 
				[106830]	= { true, 3 }, 
				[155625]	= { true, 4 }, 
				[339]	    = { false, 5 }, 
				[102359]	= { false, 5 },
			--	[210705]	= { true, 6 },
			},
			
			multi_border = {
				texture = "WHITE8x8",
				size = 4,
				inset = 1,
				color = { 
					0.874509803921569,
					0.874509803921569,
					0.874509803921569,
					1
				},
				background = { 0, 0, 0, 1},
				bg_inset = 0,
			},
			
			width = 125,
			height = 65,
			show_ticks = true,
		
			ordering_spells = { 
				spellidtoid = {
					[ns.glybokayrana_spid] = 3,
					[ns.razorvat_spid] = 4,
					[ns.vzbuchka_spid] = 2,
					[ns.dikiyrev_spid] = 5,
					[ns.moonfire_spid] = 1,
				},				
				sort = {
					{ name = ns.moonfire_spid, 	sort = 1, on = true },
					{ name = ns.vzbuchka_spid, 	sort = 2, on = true },
					{ name = ns.glybokayrana_spid, sort = 3, on = true },
					{ name = ns.razorvat_spid, 	sort = 4, on = true },
					{ name = ns.dikiyrev_spid, 	sort = 5, on = true },
				}
			},
			
			gap = 4,
			font = "Friz Quadrata TT",
			fontsize = 17,
			fontsize_timer = 21,
			fontflag = "OUTLINE",
			relative_numbers = false,
			shadow_color = { 0, 0, 0, 1 },
			
			dotpowerspike = 0,
			
			timer_text_color = { 1, 1, 1, 1 },
			
			widgetType = 1,
			
			shadow_pos = { 1, -1 },
			border = {
				texture = "WHITE8x8",
				size = 1,
				inset = 1,
				color = { 0, 0, 0, 0},
				background = { 0, 0, 0, 0},
				bg_inset = 0,
			},
			others = {
				AutoInv = false,
				AutoInvGuildOnly = true,
				playSoundFile = "Simon Error",
				playSound = false,
				anonceDDLMG = false,
				anonceHEALLMG = false,
				buffCheck = true,
				flashCheck = true,
				runeCheck = true,
				raidBuffsCheck = true,
				foodCheck = true,
				checkOnEvent = 1,
				checkBuffsSoundFile = 'Simon Tick',
				overlay = true,
				horizontal_overlay = true,
				overlay_minorIconSize = 18,
				overlay_mainIconSize = 26,
			},
			
			bars = {
				gap = 3,
				width = 152,
				height = 20,
				texture = "WHITE8x8",
				color = { 0.3, 0.3, 0.3, 1 },
				growUp = true,
			},
			icons = {
				gap = 3,
				width = 152,
				height = 40,
				show_ticks = true,
				color_tick = { 0.894117647058824, 0.968627450980392, 1, 1 },
				tick_position = 'BOTTOM',
				
				text_point = "BOTTOM;CENTER",
				text_timer_point = "TOP;CENTER",
				text_pos = { 0, -22 },
				power2_pos = { 0, 0},
				
				height_t = 5,
				gap_v = -1,
				gap_h = 0,
				text_color_values = true,
				icon_color_values = false,
				time_format = 1,
				power2_step = 0,
				text_show_current = true,
				text_show_buffs = true,
				
				powerType = 1,

				disableIconSwap = false,
				
				anchoring = 2,
				
				isvertical = 1,
				
				ignore_mmonfire = true,
				max_width = 60,
				
				icon_dark = 0,
				
				revert_text_coloring = true,
				
				fadingglow = false,
				showcp = false,
				
				timertext = true,
				
				glowsize = 2,
				glowcolor = { 1, 1, 0, 1},
				
				desaturated = false,
				alpha_outof_combat = 0.2,
				hide_overlay = false,
				
				fonts = {
					font = "Arial Narrow",
					fontflag = "OUTLINE",
					shadow_pos = { 1, -1 },

					timer = {
						font = "Friz Quadrata TT",
						fontsize = 21,
						fontflag = "OUTLINE",
						shadow_color = { 0, 0, 0, 1 },
						color = { 1, 1, 1, 1},
						shadow_pos = { 1, -1 },
						spacing_v = 0,
						spacing_h = 1,
						text_point = "TOP;CENTER",
					},
				
					power = {
						font = "Friz Quadrata TT",
						fontsize = 17,
						fontflag = "OUTLINE",
						shadow_color = { 0, 0, 0, 1 },	
						color = { 1, 1, 1, 1},
						shadow_pos = { 1, -1 },
						spacing_v = 0,
						spacing_h = 0,
						text_point = "BOTTOM;CENTER",
					},
				},
				
				same_color = { 
					0.996078431372549,
					0.949019607843137,
					1, 
					1,
				},
				better_color = { 0, 1, 0, 1},
				worse_color = { 1, 0, 0, 1},
				statusbar = "Blizzard Raid Bar",
				
				border = {
					texture = "WHITE8x8",
					size = 1,
					inset = 1,
					color = { 0, 0, 0, 1},
					background = { 0, 0, 0, 1},
					bg_inset = 0,
					
				},
				
				border_tick = {
					texture = "WHITE8x8",
					size = 1,
					inset = 1,
					color = { 0, 0, 0, 1},
					background = {
						0.156862745098039,
						0.156862745098039,
						0.156862745098039,  
						1
					},
					bg_inset = 0,
				},
				
			},
			combo_points = {
				show = true,
				width = 152,
				height = 11,
				gap = 3,			
				gap_v = 45,
				gap_h = 0,
				
				statusbar = "Blizzard Raid Bar",
				color = {					
					[1] = { 1, 1, 0, 1 },
					[2] = { 1, 1, 0, 1 },
					[3] = { 255/255, 171/255, 0, 1 },
					[4] = { 255/255, 171/255, 0, 1 },
					[5] = { 255/255, 107/255, 0, 1 },
				},
				border = {
					texture = "WHITE8x8",
					size = 1,
					inset = 1,
					color = { 0, 0, 0, 0.728914439678192},
					background = { 
						0.568627450980392,
						0.568627450980392,
						0.568627450980392, 
						1
					},
					bg_inset = 0,
				},
			},
			
			manabar = {
				show = false,
				show_text = true,
				width = 200,
				height = 14,
				color = { 0.2, 0.2, 1, 1 },
				gap = 4,
				gap_v = 113,
				gap_h = 0,
				statusbar = "Blizzard Raid Bar",
				border = {
					texture = "WHITE8x8",
					size = 1,
					inset = 1,
					color = { 0, 0, 0, 1},
					background = { 0, 0, 0, 1},
					bg_inset = 0,
				},
			},
			healthbar = {
				show = false,
				show_text = true,
				width = 200,
				height = 14,
				color = { 0.2, 1, 0.2, 1 },
				gap = 4,
				gap_v = 113,
				gap_h = 0,
				statusbar = "Blizzard Raid Bar",
				border = {
					texture = "WHITE8x8",
					size = 1,
					inset = 1,
					color = { 0, 0, 0, 1},
					background = { 0, 0, 0, 1},
					bg_inset = 0,
				},
			},
			energybar = {
				show = true,
				show_text = true,
				width = 152,
				height = 15,
				gap = 4,
				gap_v = 29,
				gap_h = 0,
				show_spark = true,
				
				show_spell_threshold = false,
				threshold_width = 2,
				threshold_color = { 0, 0, 0, 1},
				threshold_color2 = { 1, 1, 1, 1},
				clearcastbar = true,
				
				showglow = true,
				animglow = true,
				glowclearcast = { 
					0, 
					0.819607843137255,
					1,
					1, 
				},
				
				color = {
					energy = { 1, 1, 0, 1 },
					rage = { 0.9, 0.1, 0.1, 1 },						
				},
				statusbar = "Blizzard Raid Bar",
				border = {
					texture = "WHITE8x8",
					size = 1,
					inset = 1,
					color = { 0, 0, 0, 0.427710175514221},
					background = { 0, 0, 0, 1},
					bg_inset = 0,
				},
			},
			anonse = {
				enable = true,
				chat = 1,
				
				spells = {
					[77764] 	= { target = "", text = "%spell !!!", on = true, chat = 1 },
					[93985] 	= { target = "", text = "%spell -> %target %extraspell", on = true, chat = 1, iffailed = true },
					[20484] 	= { target = "", text = "%spell -> %target", on = true, chat = 1 },
					[61336]		= { target = "", text = "%spell -> %source", on = false, chat = 1 },
				},
			},
			aurawidgets = {
				enable = true,
				spelllist = {},			
			},
			cooldowns = {
				enable = true,
				width = 176,
				anchoring = 2,
				blackwhite = true,
				glowAnim = true,
				visual = 1,
				icon_dark = 0,
				gap = 4,
				hide_timer_text = true,
				spacing_v = -35,
				icon_spacing = 2,
				time_format = 1,
				max_width = 31,
				
				isvertical = 1,
				
				nonactivealpha = 0.5,
				showmissing = false,
				
				bartexture1 = "Blizzard Raid Bar",
				bartexturebg = "Blizzard Raid Bar",
				bg_color = { 0.3, 0.3, 0.3, 1},
				
				fonts = {
					font = "Arial Narrow",
					fontflag = "OUTLINE",
					shadow_pos = { 1, -1 },

					timer = {
						font = "Arial Narrow",
						fontsize = 10,
						fontflag = "OUTLINE",
						shadow_color = { 0, 0, 0, 1 },
						color = { 1, 0.972549019607843, 0, 1},
						shadow_pos = { 1, -1 },
						spacing_v = 0,
						spacing_h = 1,
						text_point = "TOP;CENTER",
					},
				
					stack = {
						font = "Arial Narrow",
						fontsize = 14,
						fontflag = "OUTLINE",
						shadow_color = { 0, 0, 0, 1 },	
						color = { 1, 1, 1, 1},
						shadow_pos = { 1, -1 },
						spacing_v = 0,
						spacing_h = -5,
						text_point = "BOTTOM;RIGHT",
					},
				},
				colors = {
					{ 57/255, 117/255, 64/255, 1 },
					{ 0.3, 0.3, 0.3, 1 },
					{ 57/255, 117/255, 64/255, 1 },
					{ 0.3, 0.3, 1, 1 },
				},
				border = {
					texture = "WHITE8x8",
					size = 1,
					inset = 1,
					color = { 0.749019607843137, 0.749019607843137, 0.749019607843137, 0.427710175514221},
					background = { 0, 0, 0, 1},
					bg_inset = 0,
				},
				
				specificSpell = {
				
					[ns.predator_spid] = {
						
						predatorIconRed = false,
						color = { 1, 0, 0, 1 },
					},
					[ns.dikiyrev_spid] = {
						
						CP_Pandemia = true,
						CP_Pandemia_anim = true,
						ShowGlow = false,
					},
					[ns.tigrinoe_spid] = {
						artRegen = true,						
						color = { 1, 70/255, 30/255, 1},
					},
				},
				ordering_spells = {
					spellList = {
						[ns.berserk_spid] 		= { sort = 1, on = true },
						[ns.tigrinoe_spid] 		= { sort = 2, on = true },					
						[ns.skullbuch_spid] 		= { sort = 3, on = true },
						[ns.dash_spid] 			= { sort = 4, on = true },
						[ns.survival_spid] 		= { sort = 5, on = true },
						[ns.predator_spid] 		= { sort = 6, on = true },
						[ns.trollberserk_spid] 	= { sort = 7, on = true },
						[ns.krovaviekogti_spid] 	= { sort = 8, on = true },
						[ns.sremit_rivok_spid] 	= { sort = 9, on = true },
						[ns.astralskachek_spid] 	= { sort = 10, on = true },
						[ns.trevogniyrev_spid] 	= { sort = 11, on = true },
						[ns.clearcast_id] 		= { sort = 12, on = true },
						[ns.dikiyrev_spid] 		= { sort = 13, on = true },
						[ns.eluneguid_spid] 		= { sort = 14, on = true },
						[ns.ashamane_spid]		= { sort = 15, on = true },
						[ns.ydarkogtiami_spid]   = { sort = 16, on = true },
						[ns.maim_spid]   		= { sort = 17, on = true },
					}
				},
			},
		}
		
--	ns.db = LibStub("AceDB-3.0"):New("FeralDotDamageDB", default, true)	
	ns.db = {}
	ns.db.profile = ALEAUI_NewDB("FeralDotDamageDB", default, true)
end

local donation = { 
	"Je*** Hui*****(jfd**iz@xs4***.nl) @Curse.com",
	"Mary Jo*** @PayPal",
	"A**et***ve A**e @PayPal",
	"Chere**** Anatoly @PatPal",
}

local sites = {
	["twitter"]	  = { "Twitter", "TimoshN", false, nil },
	["website"]	  = { "URL", "http://aleaaddons.ru", false, nil },
	["anyhelp"]	  = { "Help", "http://www.aleaaddons.ru/p/support.html" , true, "full"},
}

local function GetSpellNameGUI(spellID)
	local name, _, icon = GetSpellInfo(spellID)
	
	return "\124T"..icon..":14\124t "..name
end

function ns:UpdateOptionTable()
	if ns.db.profile.icons.isvertical == 2 then
		
	else
	
	
	end
end

function ns:UpdateSettingsOptionsFromOldDB()
	
	if not ns.db.profile.settings_version_db then
		ns.db.profile.settings_version_db = 0
	end
	--[==[
	if ns.db.profile.settings_version_db < 3 then
		ns.db.profile.settings_version_db = 3
		
		ns.db.profile.icons.text_pos[2] = ns.db.profile.icons.text_pos[1]		
		ns.db.profile.icons.text_pos[1] = 0
	end
	]==]
	--[==[
	if ns.db.profile.settings_version_db < 4 then
		ns.db.profile.settings_version_db = 4
		
		ns.db.profile.icons.power2_pos[2] = power2_step		
	end
	]==]
end


function ns:OptionsTable()
	ns:UpdateSettingsOptionsFromOldDB()
	
	local SwitchToIconSettings, SwitchToBarSettings
	local SwitchPowerTextSettings
	
	local o = {
		type = "group", title = AddOn..  " v" .. ( GetAddOnMetadata(AddOn, "Version") or "0" ),
		args = {
			--[[
			lock = {
				order = 1,name = "Блокировать",type = "toggle",
				set = function(info,val) ns.db.profile.locked = not ns.db.profile.locked; self:UnlockFrames() end,
				get = function() return ns.db.profile.locked end
			},
			]]
			general={
				order = 1,name = L["Основное"],type = "group",
				args={
				
				},
			},
			icons_ ={
				order = 2,name = L["Иконки"],type = "group",
				args={
				
				},
			},
			combo_points = {
				order = 3,name = L["Очки серии"],type = "group",
				args={
				
				},
			},
			energy_bar = {
				order = 4,name = L["Полоса энергии"],type = "group",
				args={
				
				},
			},
			mana_bar = {
				order = 5,name = L["Полоса маны"],type = "group",
				args={
				
				},
			},
			health_bar = {
				order = 5.1,name = L["Полоса здоровья"],type = "group",
				args={
				
				},
			},
			cleudots = {
				order = 6,name = L["Побочные цели"],type = "group",
				args={
				
				},
			},
			
			background = {
				order = 6.1,name = L["Фон"],type = "group",
				args={
				
				},
			},
			
			cooldowns = ns:AddCooldownsGUI(),
			
		--	about = {
		--		order = 999,name = "About",type = "group",
		--		args={},
		--	},
		--	profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(ns.db),
		},

	}

	o.args.background.args.movingme = {
		order = 1,name = L["Передвинуть фон"], type = "execute",
		set = function(info,val) ns:UnlockMover("FrameBackground"); end,
		get = function(info) return false end
	}
	
	o.args.background.args.sizes ={
		order = 2,name = "",type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.background.args.sizes.args.width = {
		name = L["Ширина"], disabled = false,
		type = "slider",
		order	= 1.1,
		min		= 1,
		max		= 800,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.width = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.width
		end,
	}
	o.args.background.args.sizes.args.height = {
		name = L["Высота"], disabled = false,
		type = "slider",
		order	= 1.2,
		min		= 1,
		max		= 800,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.height = val
			ns:UpdateFramesStyle();
		end,
		get = function(info)
			return ns.db.profile.height
		end,
	}
	
	o.args.general.args.hideMinimap = {
		name = L['Показывать иконку у миникарты'],
		order = 1.2,
		width = 'full',
		type = 'toggle',
		set = function(info)
			ns.db.profile.minimap.hide = not ns.db.profile.minimap.hide
			AleaUI_GUI.GetMinimapButton(AddOn):Update(ns.db.profile.minimap)
		end,
		get = function()
			return ns.db.profile.minimap.hide
		end
	}

	o.args.general.args.show_in_combat = {
		order = 1.3,name = L["Показать только в бою"], desc = L["Показать только в бою"], type = "toggle", width = "full",
		set = function(info,val) ns.db.profile.show_in_combat = not ns.db.profile.show_in_combat;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.show_in_combat end	
	}
	o.args.general.args.show_on_target = {
		order = 1.4,name = L["Показать если есть цель"], desc = L["Показать если есть цель"], type = "toggle", width = "full",
		set = function(info,val) ns.db.profile.show_on_target = not ns.db.profile.show_on_target;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.show_on_target end	
	}
	
	o.args.general.args.show_only_catform = {
		order = 1.5,name = L["Показать в форме кота"], desc = L["Показать только в форме кота"], type = "toggle", width = "full",
		set = function(info,val) ns.db.profile.show_only_catform = not ns.db.profile.show_only_catform;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.show_only_catform end	
	}
	
	o.args.general.args.show_for_non_feral_spec = {
		order = 1.6,name = L["Показать c "]..GetSpellNameGUI(202155) , desc = L["Показать панель для других специализаций с талантом "]..GetSpellNameGUI(202155), type = "toggle", width = "full",
		set = function(info,val) ns.db.profile.show_for_non_feral_spec = not ns.db.profile.show_for_non_feral_spec; ns:UpdateTalentsAndPercs(event); end,
		get = function(info) return ns.db.profile.show_for_non_feral_spec end	
	}
	
	o.args.general.args.show_for_guardian_spec = {
		order = 1.7,name = L["Показать частично в специализации стража"] , desc = L["Показать полосу ресурса для специализации стража"], type = "toggle", width = "full",
		set = function(info,val) ns.db.profile.show_for_guardian_spec = not ns.db.profile.show_for_guardian_spec; ns:UpdateTalentsAndPercs(event); end,
		get = function(info) return ns.db.profile.show_for_guardian_spec end	
	}

	o.args.general.args.font ={
		order = 2,name = L["Шрифт"]..L[' для побочных целей, полос энергии и маны'],type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.general.args.font.args.font = {
		order = 4,name = L["Шрифт"],type = 'font',
		values = ns.SharedMedia:HashTable("font"),
		set = function(info,key) 
			ns.db.profile.font = key
			ns:UpdateFramesStyle()
			ns:MultitargetFontUpdate()
		end,
		get = function(info) return ns.db.profile.font end,
	}
	o.args.general.args.font.args.fontisize = {
		name = L["Размер шрифта"], disabled = false,
		type = "slider",
		order	= 41,
		min		= 1,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.fontsize = val
			ns:UpdateFramesStyle()
			ns:MultitargetFontUpdate()
		end,
		get =function(info)
			return ns.db.profile.fontsize
		end,
	}
	
	o.args.general.args.font.args.fontflag = {
		type = "dropdown",	order = 4.2,
		name = L["Обводка шрифта"],
		values = {
			["NONE"] = NO,
			["OUTLINE"] = "OUTLINE",
			["THICKOUTLINE"] = "THICKOUTLINE",
			["MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
		},
		set = function(info,val) 
			ns.db.profile.fontflag = val
			ns:UpdateFramesStyle()
			ns:MultitargetFontUpdate()
		end,
		get = function(info) return ns.db.profile.fontflag end
	}
	--[[
	o.args.general.args.font.args.shadow_pos1 = {
		name = L["Тень текста X"], disabled = false,
		type = "slider",
		order	= 5,
		min		= -5,
		max		= 5,
		step	= 0.1,
		set = function(info,val) 
			ns.db.profile.shadow_pos[1] = val
			ns:UpdateFramesStyle()
			ns:MultitargetFontUpdate()
		end,
		get =function(info)
			return ns.db.profile.shadow_pos[1]
		end,
	}
	o.args.general.args.font.args.shadow_pos2 = {
		name = L["Тень текста Y"], disabled = false,
		type = "slider",
		order	= 5.1,
		min		= -5,
		max		= 5,
		step	= 0.1,
		set = function(info,val) 
			ns.db.profile.shadow_pos[2] = val
			ns:UpdateFramesStyle()
			ns:MultitargetFontUpdate()
		end,
		get =function(info)
			return ns.db.profile.shadow_pos[2]
		end,
	}
	]]
	o.args.background.args.borders ={
		order = 10,name = L["Граница"],type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.background.args.borders.args.border = {
		order = 19.1,type = 'border',name = L["Текстура"],
		values = ns.SharedMedia:HashTable("border"),
		set = function(info,value) ns.db.profile.border.texture = value;ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.border.texture end,
	}
					
	o.args.background.args.borders.args.bordercolor = {
		order = 19.2,name = L["Цвет"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.border.color={r,g,b,a};ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.border.color[1],ns.db.profile.border.color[2],ns.db.profile.border.color[3],ns.db.profile.border.color[4] end
	}
					
	o.args.background.args.borders.args.bordersize = {
		name = L["Размер"],
		type = "slider",
		order	= 19.3,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.border.size = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.border.size
		end,
	}
	o.args.background.args.borders.args.borderinset = {
		name = L["Отступ границ"],
		type = "slider",
		order	= 19.4,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.border.inset = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.border.inset
		end,
	}
	
	o.args.background.args.borders.args.bgcolor = {
		order = 19.2,name = L["Фон"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.border.background={r,g,b,a};ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.border.background[1],ns.db.profile.border.background[2],ns.db.profile.border.background[3],ns.db.profile.border.background[4] end
	}
	o.args.background.args.borders.args.bginset = {
		name = L["Отступ фона"],
		type = "slider",
		order	= 19.4,
		min		= -50,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.border.bg_inset = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.border.bg_inset
		end,
	}
	
	-----------------------------
	o.args.combo_points.args.borders ={
		order = 11,name = L["Граница"],type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.combo_points.args.borders.args.border = {
		order = 19.1,type = 'border',name = L["Текстура"],
		values = ns.SharedMedia:HashTable("border"),
		set = function(info,value) ns.db.profile.combo_points.border.texture = value;ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.combo_points.border.texture end,
	}
					
	o.args.combo_points.args.borders.args.bordercolor = {
		order = 19.2,name = L["Цвет"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.combo_points.border.color={r,g,b,a};ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.combo_points.border.color[1],ns.db.profile.combo_points.border.color[2],ns.db.profile.combo_points.border.color[3],ns.db.profile.combo_points.border.color[4] end
	}
					
	o.args.combo_points.args.borders.args.bordersize = {
		name = L["Размер"],
		type = "slider",
		order	= 19.3,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.combo_points.border.size = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.combo_points.border.size
		end,
	}
	o.args.combo_points.args.borders.args.borderinset = {
		name = L["Отступ границ"],
		type = "slider",
		order	= 19.4,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.combo_points.border.inset = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.combo_points.border.inset
		end,
	}
	-------------------------------------------------
	o.args.combo_points.args.borders.args.bgcolor = {
		order = 19.2,name = L["Фон"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.combo_points.border.background={r,g,b,a};ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.combo_points.border.background[1],ns.db.profile.combo_points.border.background[2],ns.db.profile.combo_points.border.background[3],ns.db.profile.combo_points.border.background[4] end
	}
	o.args.combo_points.args.borders.args.bginset = {
		name = L["Отступ Фона"],
		type = "slider",
		order	= 19.4,
		min		= -50,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.combo_points.border.bg_inset = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.combo_points.border.bg_inset
		end,
	}
	-------------------------------------------------
	o.args.combo_points.args.show = {
		order = 1,name = L["Показать"],type = "toggle",
		set = function(info,val) ns.db.profile.combo_points.show = not ns.db.profile.combo_points.show;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.combo_points.show end	
	}
	
	o.args.combo_points.args.movingme = {
		order = 1.1,name = L["Передвинь меня!"], type = "execute",
		set = function(info,val) ns:UnlockMover("CombopointBar"); end,
		get = function(info) return false end
	}
	
	o.args.combo_points.args.sizes ={
		order = 2,name = "",type = "group", embend = true,
		args={
		
		},
	}
		
	o.args.combo_points.args.sizes.args.width = {
		name = L["Ширина"], disabled = false,
		type = "slider",
		order	= 2,
		min		= 1,
		max		= 800,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.combo_points.width = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.combo_points.width
		end,
	}
	
	o.args.combo_points.args.sizes.args.height = {
		name = L["Высота"], disabled = false,
		type = "slider",
		order	= 3,
		min		= 1,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.combo_points.height = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.combo_points.height
		end,
	}
	
	o.args.combo_points.args.sizes.args.gap = {
		name = L["Отступ"], disabled = false,
		type = "slider",
		order	= 4,
		min		= 0,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.combo_points.gap = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.combo_points.gap
		end,
	}
	o.args.combo_points.args.statusbar = {
		order = 5,type = 'statusbar',name = L["Полоса"], 
		values = ns.SharedMedia:HashTable("statusbar"),
		set = function(info,value) ns.db.profile.combo_points.statusbar = value; ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.combo_points.statusbar end,
	}
	
	o.args.combo_points.args.colors ={
		order = 6,name = L["Цвета"],type = "group", embend = true,
		args={
		
		},
	}
	
	for i=1, 5 do
		o.args.combo_points.args.colors.args["color"..i] = {
			order = 2,name = L["цвет КП"]..i,type = "color", hasAlpha = true,
			set = function(info,r,g,b,a) ns.db.profile.combo_points.color[i]={r,g,b,a}; ns:UpdateFramesStyle();end,
			get = function(info)
				return ns.db.profile.combo_points.color[i][1],ns.db.profile.combo_points.color[i][2],ns.db.profile.combo_points.color[i][3],ns.db.profile.combo_points.color[i][4] 
			end
		}
	end
	--[[
	o.args.combo_points.args.gap_v = {
		name = L["Отступ панели по вертикали"], disabled = false,
		type = "slider",
		order	= 7,
		min		= -500,
		max		= 500,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.combo_points.gap_v = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.combo_points.gap_v
		end,
	}
	
	o.args.combo_points.args.gap_h = {
		name = L["Отступ панели по горизонтали"], disabled = false,
		type = "slider",
		order	= 8,
		min		= -500,
		max		= 500,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.combo_points.gap_h = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.combo_points.gap_h
		end,
	}
	]]
	o.args.energy_bar.args.borders ={
		order = 11,name = L["Граница"],type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.energy_bar.args.borders.args.border = {
		order = 19.1,type = 'border',name = L["Текстура"],
		values = ns.SharedMedia:HashTable("border"),
		set = function(info,value) ns.db.profile.energybar.border.texture = value;ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.energybar.border.texture end,
	}
					
	o.args.energy_bar.args.borders.args.bordercolor = {
		order = 19.2,name = L["Цвет"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.energybar.border.color={r,g,b,a};ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.energybar.border.color[1],ns.db.profile.energybar.border.color[2],ns.db.profile.energybar.border.color[3],ns.db.profile.energybar.border.color[4] end
	}
					
	o.args.energy_bar.args.borders.args.bordersize = {
		name = L["Размер"],
		type = "slider",
		order	= 19.3,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.energybar.border.size = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.energybar.border.size
		end,
	}
	o.args.energy_bar.args.borders.args.borderinset = {
		name = L["Отступ границ"],
		type = "slider",
		order	= 19.4,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.energybar.border.inset = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.energybar.border.inset
		end,
	}
	-------------------------------------------------
	o.args.energy_bar.args.borders.args.bgcolor = {
		order = 19.2,name = L["Фон"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.energybar.border.background={r,g,b,a};ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.energybar.border.background[1],ns.db.profile.energybar.border.background[2],ns.db.profile.energybar.border.background[3],ns.db.profile.energybar.border.background[4] end
	}
	o.args.energy_bar.args.borders.args.bginset = {
		name = L["Отступ фона"],
		type = "slider",
		order	= 19.4,
		min		= -50,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.energybar.border.bg_inset = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.energybar.border.bg_inset
		end,
	}
	-------------------------------------------------
	
	o.args.energy_bar.args.show = {
		order = 1,name = L["Показать"],type = "toggle",
		set = function(info,val) ns.db.profile.energybar.show = not ns.db.profile.energybar.show;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.energybar.show end	
	}
	o.args.energy_bar.args.movingme = {
		order = 1.1,name = L["Передвинь меня!"], type = "execute",
		set = function(info,val) ns:UnlockMover("EnergyBar"); end,
		get = function(info) return false end
	}
	
	o.args.energy_bar.args.show_text = {
		order = 1.2,name = L["Показать текст"],type = "toggle",
		set = function(info,val) ns.db.profile.energybar.show_text = not ns.db.profile.energybar.show_text;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.energybar.show_text end	
	}
	
	o.args.energy_bar.args.show_spark = {
		order = 1.3,name = L["Показать искру"],type = "toggle",
		set = function(info,val) ns.db.profile.energybar.show_spark = not ns.db.profile.energybar.show_spark;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.energybar.show_spark end	
	}
	
	o.args.energy_bar.args.show_spell_threshold_grp ={
		order = 12,name = L['Пороги заклинаний'],type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.energy_bar.args.show_spell_threshold_grp.args.show_spell_threshold = {
		order = 1.4,name = L["Показать"],type = "toggle", width = "full",
		set = function(info,val) ns.db.profile.energybar.show_spell_threshold = not ns.db.profile.energybar.show_spell_threshold;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.energybar.show_spell_threshold end	
	}
	
	o.args.energy_bar.args.show_spell_threshold_grp.args.width = {
		name = L["Ширина"], disabled = false,
		type = "slider",
		order	= 2,
		min		= 1,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.energybar.threshold_width = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.energybar.threshold_width
		end,
	}
	
	o.args.energy_bar.args.show_spell_threshold_grp.args.color = {
		order = 2,name = L['Цвет'],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.energybar.threshold_color={r,g,b,a};ns:UpdateFramesStyle(); end,
		get = function(info)
			return ns.db.profile.energybar.threshold_color[1],ns.db.profile.energybar.threshold_color[2],ns.db.profile.energybar.threshold_color[3],ns.db.profile.energybar.threshold_color[4] 
		end
	}
	
	o.args.energy_bar.args.show_spell_threshold_grp.args.color2 = {
		order = 3,name = L['Цвет'].."2",type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.energybar.threshold_color2={r,g,b,a};ns:UpdateFramesStyle(); end,
		get = function(info)
			return ns.db.profile.energybar.threshold_color2[1],ns.db.profile.energybar.threshold_color2[2],ns.db.profile.energybar.threshold_color2[3],ns.db.profile.energybar.threshold_color2[4] 
		end
	}
	
	
	o.args.energy_bar.args.glow_group ={
		order = 11,name = L['Сияние "'].. ns.clearcast_name ..'"',type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.energy_bar.args.glow_group.args.showglow = {
		order = 1.2,name = L['Показать'] ,type = "toggle", width = "full",
		set = function(info,val) ns.db.profile.energybar.showglow = not ns.db.profile.energybar.showglow;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.energybar.showglow end	
	}
	
	o.args.energy_bar.args.glow_group.args.glowclearcast = {
		order = 2,name = L['Цвет'],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.energybar.glowclearcast={r,g,b,1};ns:UpdateFramesStyle(); end,
		get = function(info)
			return ns.db.profile.energybar.glowclearcast[1],ns.db.profile.energybar.glowclearcast[2],ns.db.profile.energybar.glowclearcast[3],ns.db.profile.energybar.glowclearcast[4] 
		end
	}
	
	o.args.energy_bar.args.glow_group.args.animglow = {
		order = 1.3,name = L["Анимация сияния"],type = "toggle",
		set = function(info,val) ns.db.profile.energybar.animglow = not ns.db.profile.energybar.animglow;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.energybar.animglow end	
	}
	o.args.energy_bar.args.glow_group.args.clearcastbar = {
		order = 1.4,name = L['Менять цвет полосы'] ,type = "toggle",
		set = function(info,val) ns.db.profile.energybar.clearcastbar = not ns.db.profile.energybar.clearcastbar; end,
		get = function(info) return ns.db.profile.energybar.clearcastbar end	
	}
	
	o.args.energy_bar.args.sizes ={
		order = 2,name = '',type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.energy_bar.args.sizes.args.height = {
		name = L["Высота"], disabled = false,
		type = "slider",
		order	= 2,
		min		= 1,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.energybar.height = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.energybar.height
		end,
	}
	
	o.args.energy_bar.args.sizes.args.width = {
		name = L["Ширина"], disabled = false,
		type = "slider",
		order	= 2.1,
		min		= 1,
		max		= 300,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.energybar.width = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.energybar.width
		end,
	}
	
	o.args.energy_bar.args.energy_color = {
		order = 3,name = L["Цвет энергии"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.energybar.color.energy={r,g,b,a};ns:UpdateFramesStyle(); end,
		get = function(info)
			return ns.db.profile.energybar.color.energy[1],ns.db.profile.energybar.color.energy[2],ns.db.profile.energybar.color.energy[3],ns.db.profile.energybar.color.energy[4] 
		end
	}
	
	o.args.energy_bar.args.rage_color = {
		order = 3.1,name = L["Цвет ярости"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.energybar.color.rage={r,g,b,a}; ns:UpdateFramesStyle();end,
		get = function(info)
			return ns.db.profile.energybar.color.rage[1],ns.db.profile.energybar.color.rage[2],ns.db.profile.energybar.color.rage[3],ns.db.profile.energybar.color.rage[4] 
		end
	}
	o.args.energy_bar.args.statusbar = {
		order = 5,type = 'statusbar',name = L["Полоса"], 
		values = ns.SharedMedia:HashTable("statusbar"),
		set = function(info,value) ns.db.profile.energybar.statusbar = value; ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.energybar.statusbar end,
	}
	--[[
	o.args.energy_bar.args.gap_v = {
		name = L["Отступ панели по вертикали"], disabled = false,
		type = "slider",
		order	= 4,
		min		= -500,
		max		= 500,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.energybar.gap_v = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.energybar.gap_v
		end,
	}
	
	o.args.energy_bar.args.gap_h = {
		name = L["Отступ панели по горизонтали"], disabled = false,
		type = "slider",
		order	= 4.1,
		min		= -500,
		max		= 500,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.energybar.gap_h = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.energybar.gap_h
		end,
	}
	]]
	

	o.args.health_bar.args.show = {
		order = 1,name = L["Показать"],type = "toggle",
		set = function(info,val) ns.db.profile.healthbar.show = not ns.db.profile.healthbar.show; ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.healthbar.show end	
	}
	o.args.health_bar.args.movingme = {
		order = 1.1,name = L["Передвинь меня!"], type = "execute",
		set = function(info,val) ns:UnlockMover("HealthBar"); end,
		get = function(info) return false end
	}
	
	o.args.health_bar.args.show_text = {
		order = 1.1,name = L["Показать текст"],type = "toggle", width = "full",
		set = function(info,val) ns.db.profile.healthbar.show_text = not ns.db.profile.healthbar.show_text; ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.healthbar.show_text end	
	}
	
	o.args.health_bar.args.sizes ={
		order = 2,name = '',type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.health_bar.args.sizes.args.height = {
		name = L["Высота"], disabled = false,
		type = "slider",
		order	= 2,
		min		= 1,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.healthbar.height = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.healthbar.height
		end,
	}
	
	o.args.health_bar.args.sizes.args.width = {
		name = L["Ширина"], disabled = false,
		type = "slider",
		order	= 2.1,
		min		= 1,
		max		= 300,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.healthbar.width = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.healthbar.width
		end,
	}
	
	o.args.health_bar.args.energy_color = {
		order = 3,name = L["Цвет полосы"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.healthbar.color={r,g,b,a}; ns:UpdateFramesStyle();end,
		get = function(info)
			return ns.db.profile.healthbar.color[1],ns.db.profile.healthbar.color[2],ns.db.profile.healthbar.color[3],ns.db.profile.healthbar.color[4] 
		end
	}
	o.args.health_bar.args.statusbar = {
		order = 3.1,type = 'statusbar',name = L["Полоса"], 
		values = ns.SharedMedia:HashTable("statusbar"),
		set = function(info,value) ns.db.profile.healthbar.statusbar = value;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.healthbar.statusbar end,
	}
	
	o.args.health_bar.args.borders ={
		order = 6,name = L["Граница"],type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.health_bar.args.borders.args.border = {
		order = 19.1,type = 'border',name = L["Текстура"],
		values = ns.SharedMedia:HashTable("border"),
		set = function(info,value) ns.db.profile.healthbar.border.texture = value;ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.healthbar.border.texture end,
	}
					
	o.args.health_bar.args.borders.args.bordercolor = {
		order = 19.2,name = L["Цвет"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.healthbar.border.color={r,g,b,a};ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.healthbar.border.color[1],ns.db.profile.healthbar.border.color[2],ns.db.profile.healthbar.border.color[3],ns.db.profile.healthbar.border.color[4] end
	}
	
	o.args.health_bar.args.borders.args.bordersize = {
		name = L["Размер"],
		desc = L["Set Border Size"],
		type = "slider",
		order	= 19.3,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.healthbar.border.size = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.healthbar.border.size
		end,
	}
	o.args.health_bar.args.borders.args.borderinset = {
		name = L["Отступ границ"],
		type = "slider",
		order	= 19.4,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.healthbar.border.inset = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.healthbar.border.inset
		end,
	}
	-------------------------------------------------
	o.args.health_bar.args.borders.args.bgcolor = {
		order = 19.2,name = L["Цвет фона"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.healthbar.border.background={r,g,b,a};ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.healthbar.border.background[1],ns.db.profile.healthbar.border.background[2],ns.db.profile.healthbar.border.background[3],ns.db.profile.healthbar.border.background[4] end
	}
	o.args.health_bar.args.borders.args.bginset = {
		name = L["Отступ фона"],
		type = "slider",
		order	= 19.4,
		min		= -50,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.healthbar.border.bg_inset = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.healthbar.border.bg_inset
		end,
	}
	
	
	
	o.args.mana_bar.args.show = {
		order = 1,name = L["Показать"],type = "toggle",
		set = function(info,val) ns.db.profile.manabar.show = not ns.db.profile.manabar.show; ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.manabar.show end	
	}
	o.args.mana_bar.args.movingme = {
		order = 1.1,name = L["Передвинь меня!"], type = "execute",
		set = function(info,val) ns:UnlockMover("ManaBar"); end,
		get = function(info) return false end
	}
	
	o.args.mana_bar.args.show_text = {
		order = 1.1,name = L["Показать текст"],type = "toggle", width = "full",
		set = function(info,val) ns.db.profile.manabar.show_text = not ns.db.profile.manabar.show_text; ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.manabar.show_text end	
	}
	
	o.args.mana_bar.args.sizes ={
		order = 2,name = '',type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.mana_bar.args.sizes.args.height = {
		name = L["Высота"], disabled = false,
		type = "slider",
		order	= 2,
		min		= 1,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.manabar.height = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.manabar.height
		end,
	}
	
	o.args.mana_bar.args.sizes.args.width = {
		name = L["Ширина"], disabled = false,
		type = "slider",
		order	= 2.1,
		min		= 1,
		max		= 300,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.manabar.width = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.manabar.width
		end,
	}
	
	o.args.mana_bar.args.energy_color = {
		order = 3,name = L["Цвет маны"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.manabar.color={r,g,b,a}; ns:UpdateFramesStyle();end,
		get = function(info)
			return ns.db.profile.manabar.color[1],ns.db.profile.manabar.color[2],ns.db.profile.manabar.color[3],ns.db.profile.manabar.color[4] 
		end
	}
	o.args.mana_bar.args.statusbar = {
		order = 3.1,type = 'statusbar',name = L["Полоса"], 
		values = ns.SharedMedia:HashTable("statusbar"),
		set = function(info,value) ns.db.profile.manabar.statusbar = value;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.manabar.statusbar end,
	}
	
	o.args.mana_bar.args.borders ={
		order = 6,name = L["Граница"],type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.mana_bar.args.borders.args.border = {
		order = 19.1,type = 'border',name = L["Текстура"],
		values = ns.SharedMedia:HashTable("border"),
		set = function(info,value) ns.db.profile.manabar.border.texture = value;ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.manabar.border.texture end,
	}
					
	o.args.mana_bar.args.borders.args.bordercolor = {
		order = 19.2,name = L["Цвет"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.manabar.border.color={r,g,b,a};ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.manabar.border.color[1],ns.db.profile.manabar.border.color[2],ns.db.profile.manabar.border.color[3],ns.db.profile.manabar.border.color[4] end
	}
	
	o.args.mana_bar.args.borders.args.bordersize = {
		name = L["Размер"],
		desc = L["Set Border Size"],
		type = "slider",
		order	= 19.3,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.manabar.border.size = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.manabar.border.size
		end,
	}
	o.args.mana_bar.args.borders.args.borderinset = {
		name = L["Отступ границ"],
		type = "slider",
		order	= 19.4,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.manabar.border.inset = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.manabar.border.inset
		end,
	}
	-------------------------------------------------
	o.args.mana_bar.args.borders.args.bgcolor = {
		order = 19.2,name = L["Цвет фона"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.manabar.border.background={r,g,b,a};ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.manabar.border.background[1],ns.db.profile.manabar.border.background[2],ns.db.profile.manabar.border.background[3],ns.db.profile.manabar.border.background[4] end
	}
	o.args.mana_bar.args.borders.args.bginset = {
		name = L["Отступ фона"],
		type = "slider",
		order	= 19.4,
		min		= -50,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.manabar.border.bg_inset = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.manabar.border.bg_inset
		end,
	}
	--[[
	o.args.mana_bar.args.gap_v = {
		name = L["Отступ панели по вертикали"], disabled = false,
		type = "slider",
		order	= 3.5,
		min		= -500,
		max		= 500,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.manabar.gap_v = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.manabar.gap_v
		end,
	}
	
	o.args.mana_bar.args.gap_h = {
		name = L["Отступ панели по горизонтали"], disabled = false,
		type = "slider",
		order	= 3.6,
		min		= -500,
		max		= 500,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.manabar.gap_h = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.manabar.gap_h
		end,
	}
	]]
	-------------------------------------------------
	function SwitchPowerTextSettings(enable)
	
		if enable then
			o.args.icons_.args.powertext ={
				order = 3,name = L["Текст силы"],type = "group", embend = true,
				args={
				
				},
			}
			
			o.args.icons_.args.powertext.args.updatedText = {
				type = 'group', order  = 2,
				name = L['Будущее значение'],
				args = {},
				embend = true,
			}
			
			o.args.icons_.args.powertext.args.updatedText.args.textposition = {	
				type = "dropdown",order = 5,
				name = L["Выравнивание текста"],
				values = {
					["TOP;CENTER"] = L["Сверху"],
					["TOP;LEFT"] = L["Слева вверху"],
					["TOP;RIGHT"] = L["Справа вверху"],
					["CENTER;CENTER"] = L["Центр"],
					["BOTTOM;CENTER"] = L["Снизу"],
					["BOTTOM;LEFT"] = L["Слева внизу"],
					["BOTTOM;RIGHT"] = L["Справа внизу"],
					["CENTER;LEFT"] = L["По центру слева"],
					["CENTER;RIGHT"] = L["По центру справа"],
				},
				set = function(info,val) 
					ns.db.profile.icons.text_point = val
					ns:UpdateFramesStyle();
				end,
				get = function(info) return ns.db.profile.icons.text_point end
			}
			
			
			o.args.icons_.args.powertext.args.updatedText.args.text_pos1 = {
				name = L["Смещение по горизонтали"], disabled = false,
				type = "slider",
				order	= 2,
				min		= -100,
				max		= 100,
				step	= 1,
				set = function(info,val) 
					ns.db.profile.icons.text_pos[1] = val
					ns:UpdateFramesStyle();
				end,
				get =function(info)
					return ns.db.profile.icons.text_pos[1]
				end,
			}
			
			o.args.icons_.args.powertext.args.updatedText.args.text_pos2 = {
				name = L["Смещение по вертикали"], disabled = false,
				type = "slider",
				order	= 3,
				min		= -100,
				max		= 100,
				step	= 1,
				set = function(info,val) 
					ns.db.profile.icons.text_pos[2] = val
					ns:UpdateFramesStyle();
				end,
				get =function(info)
					return ns.db.profile.icons.text_pos[2]
				end,
			}
			
			o.args.icons_.args.powertext.args.currentText = {
				type = 'group', order  = 1,
				name = L['Текущее значение'],
				args = {},
				embend = true,
			}
			
			o.args.icons_.args.powertext.args.currentText.args.power2_step = {
				name = L["Смещение по горизонтали"], desc = L["Отступ текста текущего значения"],
				type = "slider",
				order	= 2.5,
				min		= -100,
				max		= 100,
				step	= 1,
				set = function(info,val) 
					ns.db.profile.icons.power2_pos[1] = val
					ns:UpdateFramesStyle();
				end,
				get =function(info)
					return ns.db.profile.icons.power2_pos[1]
				end,
			}

			o.args.icons_.args.powertext.args.currentText.args.power2_step2 = {
				name = L["Смещение по вертикали"], desc = L["Отступ текста текущего значения"],
				type = "slider",
				order	= 2.5,
				min		= -100,
				max		= 100,
				step	= 1,
				set = function(info,val) 
					ns.db.profile.icons.power2_pos[2] = val
					ns:UpdateFramesStyle();
				end,
				get =function(info)
					return ns.db.profile.icons.power2_pos[2]
				end,
			}
			
			o.args.icons_.args.powertext.args.currentText.args.textposition_stack = {	
				type = "dropdown",order = 6,
				name = L["Выравнивание текста"],
				desc = L["Выравнивание текста"],
				values = {
					["TOP;CENTER"] = L["Сверху"],
					["TOP;LEFT"] = L["Слева вверху"],
					["TOP;RIGHT"] = L["Справа вверху"],
					["CENTER;CENTER"] = L["Центр"],
					["BOTTOM;CENTER"] = L["Снизу"],
					["BOTTOM;LEFT"] = L["Слева внизу"],
					["BOTTOM;RIGHT"] = L["Справа внизу"],
					["CENTER;LEFT"] = L["По центру слева"],
					["CENTER;RIGHT"] = L["По центру справа"],
				},
				set = function(info,val) 
					ns.db.profile.icons.fonts.power.text_point = val
					ns:UpdateFramesStyle()
				end,
				get = function(info) return ns.db.profile.icons.fonts.power.text_point end
			}
			
			o.args.icons_.args.powertext.args.fontisize_stack = {
				name = L["Размер шрифта"], disabled = false, width = 'full',
				type = "slider",
				order	= 0.1,
				min		= 1,
				max		= 60,
				step	= 1,
				set = function(info,val) 
					ns.db.profile.icons.fonts.power.fontsize = val
					ns:UpdateFramesStyle()
				end,
				get =function(info)
					return ns.db.profile.icons.fonts.power.fontsize
				end,
			}
		else
			o.args.icons_.args.powertext = nil
		end
	end
	
	function SwitchToIconSettings()
	
		o.args.icons_.args.style ={
			order = 1,name = L["Стиль"],type = "group", embend = true,
			args={
			
			},
		}
		
		o.args.icons_.args.style.args.gap = {
			name = L["Отступ иконок"], disabled = false,
			type = "slider",
			order	= 2,
			min		= 0,
			max		= 50,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.gap = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.gap
			end,
		}

		
		o.args.icons_.args.style.args.width = {
			name = L["Ширина панели"], disabled = false,
			desc = L["При изменении количества иконок, их размер будет рассчитывается из значения ширины панели."],
			type = "slider",
			order	= 1,
			min		= 1,
			max		= 800,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.width = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.width
			end,
		}
		
		o.args.icons_.args.style.args.max_width = {
			name = L["Максимальный размер"], disabled = false,
			desc = L['Размер иконки не будет превышать максимального размера'],
			type = "slider",
			order	= 1.1,
			min		= 1,
			max		= 300,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.max_width = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.max_width
			end,
		}
		
		o.args.icons_.args.style.args.ignore_mmonfire = {
			name = L["Игнорировать "]..ns.moonfire_name , disabled = false,
			desc = L['Игнорировать ']..ns.moonfire_name..L[' при расчете размера иконок'],
			type = "toggle", order	= 1.2,
			set = function(info,val) 
				ns.db.profile.icons.ignore_mmonfire = not ns.db.profile.icons.ignore_mmonfire
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.ignore_mmonfire
			end,
		}
		
		o.args.icons_.args.style.args.ignore_savageroar = {
			name = L["Игнорировать "]..ns.dikiyrev_name , disabled = false,
			desc = L['Игнорировать ']..ns.dikiyrev_name..L[' при расчете размера иконок'],
			type = "toggle", order	= 1.2,
			set = function(info,val) 
				ns.db.profile.icons.ignore_savageroar = not ns.db.profile.icons.ignore_savageroar
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.ignore_savageroar
			end,
		}
		
		o.args.icons_.args.style.args.disableIconSwap = {
			name = L["Отключить смену иконок"], disabled = false,
			desc = L['Отключить смену иконок для ']..ns.vzbuchka_name..', '..ns.fb_name..', '..ns.razorvat_name,
			type = "toggle", order	= 1.3, width = 'full',
			set = function(info,val) 
				ns.db.profile.icons.disableIconSwap = not ns.db.profile.icons.disableIconSwap
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.disableIconSwap
			end,
		}
		
		o.args.icons_.args.style.args.anchoring = {
			order = 2, name = L["Точка привязки"],
			type = "dropdown",
			values = function()
				return ( ns.db.profile.icons.isvertical == 2 and { L['Справа'], L['Слева'] } or { L['Снизу'], L['Сверху'] } )
			end,
			set = function(self, value)
				ns.db.profile.icons.anchoring = value;
				ns:UpdateFramesStyle();
			end,
			get = function(self)		
				return ns.db.profile.icons.anchoring
			end	
		}
		
		o.args.icons_.args.style.args.isvertical = {
			order = 3, name = L["Расположение"],
			type = "dropdown",
			values = { L['Горизонтально'], L['Вертикально'] },
			set = function(self, value)
				ns.db.profile.icons.isvertical = value;
				ns:UpdateFramesStyle();
				ns:UpdateOptionTable();
			end,
			get = function(self)		
				return ns.db.profile.icons.isvertical
			end	
		}

		o.args.icons_.args.style.args.icon_darkness = {
			order = 4, name = L["Затемнение"],
			type = "slider", min = 0, max = 1, step = 0.1,
			set = function(self, value)
				ns.db.profile.icons.icon_dark = value;
				ns:UpdateFramesStyle();
			end,
			get = function(self)		
				return ns.db.profile.icons.icon_dark
			end	
		}
		
		o.args.icons_.args.powerType = {
			order = 2.9, name = L["Тип отображения силы дот"],
			type = "dropdown",
			width = 'full',
			values = { L['Текст'], L['Индикаторы'] },
			set = function(self, value)
				ns.db.profile.icons.powerType = value;
				
				SwitchPowerTextSettings(ns.db.profile.icons.powerType==1)
			end,
			get = function(self)		
				return ns.db.profile.icons.powerType
			end	
		}
		
		o.args.icons_.args.powertext ={
			order = 3,name = L["Текст силы"],type = "group", embend = true,
			args={
			
			},
		}
		
		o.args.icons_.args.powertext.args.updatedText = {
			type = 'group', order  = 2,
			name = L['Будущее значение'],
			args = {},
			embend = true,
		}
		
		o.args.icons_.args.powertext.args.updatedText.args.textposition = {	
			type = "dropdown",order = 5,
			name = L["Выравнивание текста"],
			values = {
				["TOP;CENTER"] = L["Сверху"],
				["TOP;LEFT"] = L["Слева вверху"],
				["TOP;RIGHT"] = L["Справа вверху"],
				["CENTER;CENTER"] = L["Центр"],
				["BOTTOM;CENTER"] = L["Снизу"],
				["BOTTOM;LEFT"] = L["Слева внизу"],
				["BOTTOM;RIGHT"] = L["Справа внизу"],
				["CENTER;LEFT"] = L["По центру слева"],
				["CENTER;RIGHT"] = L["По центру справа"],
			},
			set = function(info,val) 
				ns.db.profile.icons.text_point = val
				ns:UpdateFramesStyle();
			end,
			get = function(info) return ns.db.profile.icons.text_point end
		}
		
		
		o.args.icons_.args.powertext.args.updatedText.args.text_pos1 = {
			name = L["Смещение по горизонтали"], disabled = false,
			type = "slider",
			order	= 2,
			min		= -100,
			max		= 100,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.text_pos[1] = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.text_pos[1]
			end,
		}
		
		o.args.icons_.args.powertext.args.updatedText.args.text_pos2 = {
			name = L["Смещение по вертикали"], disabled = false,
			type = "slider",
			order	= 3,
			min		= -100,
			max		= 100,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.text_pos[2] = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.text_pos[2]
			end,
		}
		
		o.args.icons_.args.powertext.args.currentText = {
			type = 'group', order  = 1,
			name = L['Текущее значение'],
			args = {},
			embend = true,
		}
		
		o.args.icons_.args.powertext.args.currentText.args.power2_step = {
			name = L["Смещение по горизонтали"], desc = L["Отступ текста текущего значения"],
			type = "slider",
			order	= 2.5,
			min		= -100,
			max		= 100,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.power2_pos[1] = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.power2_pos[1]
			end,
		}

		o.args.icons_.args.powertext.args.currentText.args.power2_step2 = {
			name = L["Смещение по вертикали"], desc = L["Отступ текста текущего значения"],
			type = "slider",
			order	= 2.5,
			min		= -100,
			max		= 100,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.power2_pos[2] = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.power2_pos[2]
			end,
		}
		
		o.args.icons_.args.powertext.args.currentText.args.textposition_stack = {	
			type = "dropdown",order = 6,
			name = L["Выравнивание текста"],
			desc = L["Выравнивание текста"],
			values = {
				["TOP;CENTER"] = L["Сверху"],
				["TOP;LEFT"] = L["Слева вверху"],
				["TOP;RIGHT"] = L["Справа вверху"],
				["CENTER;CENTER"] = L["Центр"],
				["BOTTOM;CENTER"] = L["Снизу"],
				["BOTTOM;LEFT"] = L["Слева внизу"],
				["BOTTOM;RIGHT"] = L["Справа внизу"],
				["CENTER;LEFT"] = L["По центру слева"],
				["CENTER;RIGHT"] = L["По центру справа"],
			},
			set = function(info,val) 
				ns.db.profile.icons.fonts.power.text_point = val
				ns:UpdateFramesStyle()
			end,
			get = function(info) return ns.db.profile.icons.fonts.power.text_point end
		}
		
		o.args.icons_.args.powertext.args.fontisize_stack = {
			name = L["Размер шрифта"], disabled = false, width = 'full',
			type = "slider",
			order	= 0.1,
			min		= 1,
			max		= 60,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.fonts.power.fontsize = val
				ns:UpdateFramesStyle()
			end,
			get =function(info)
				return ns.db.profile.icons.fonts.power.fontsize
			end,
		}
		
		o.args.icons_.args.cooldown_overlay ={
			order = 4,name = L["Перезарядки"],type = "group", embend = true,
			args={
			
			},
		}

		o.args.icons_.args.cooldown_overlay.args.timertext = {
			order = 1,name = L["Текст таймера"],type = "toggle", width = "full",
			set = function(info,val) ns.db.profile.icons.timertext = not ns.db.profile.icons.timertext;ns:UpdateFramesStyle(); end,
			get = function(info) return ns.db.profile.icons.timertext end
		}
		o.args.icons_.args.cooldown_overlay.args.hide_overlay = {
			order = 3,name = L["Показывать оверлей"],type = "toggle", width = "full",
			set = function(info,val) ns.db.profile.icons.hide_overlay = not ns.db.profile.icons.hide_overlay;ns:UpdateFramesStyle(); end,
			get = function(info) return ns.db.profile.icons.hide_overlay end
		}
		
		o.args.icons_.args.ticks_position ={
			order = 6,name = L["Тики"],type = "group", embend = true,
			args={
			
			},
		}

		o.args.icons_.args.ticks_position.args.show_ticks = {
			order = 1,name = L["Показывать тики"],type = "toggle",
			set = function(info,val) ns.db.profile.show_ticks = not ns.db.profile.show_ticks;ns:UpdateFramesStyle(); end,
			get = function(info) return ns.db.profile.show_ticks end
		}

		o.args.icons_.args.ticks_position.args.position = {
			order = 1.1,
			name = L["Расположение"],
			type = "dropdown",
			values = {
				['BOTTOM'] = L['Снизу'],
				['TOP'] = L['Сверху'],
				['LEFT'] = L['Слева'],
				['RIGHT'] = L['Справа'],
			},
			set = function(info,val) 
				ns.db.profile.icons.tick_position = val
				ns:UpdateFramesStyle(); end,
			get = function(info) 
				return ns.db.profile.icons.tick_position 
			end
		}

		o.args.icons_.args.ticks_position.args.color_tick = {
			order = 3,name = L["Цвет тика"],type = "color", hasAlpha = true,
			set = function(info,r,g,b,a) ns.db.profile.icons.color_tick={r,g,b,a};ns:UpdateFramesStyle(); end,
			get = function(info)
				return ns.db.profile.icons.color_tick[1],ns.db.profile.icons.color_tick[2],ns.db.profile.icons.color_tick[3],ns.db.profile.icons.color_tick[4] 
			end
		}
		o.args.icons_.args.ticks_position.args.height = {
			name = L["Высота Тиков"], disabled = false,
			type = "slider",
			order	= 2,
			min		= 1,
			max		= 30,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.height_t = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.height_t
			end,
		}

		o.args.icons_.args.ticks_position.args.gap_v = {
			name = L["Отступ панели"], disabled = false,
			type = "slider",
			order	= 7,
			min		= -100,
			max		= 100,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.gap_v = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.gap_v
			end,
		}

		o.args.icons_.args.ticks_position.args.statusbar = {
			order = 13,type = 'statusbar',name = L["Полоса"], 
			values = ns.SharedMedia:HashTable("statusbar"),
			set = function(info,value) ns.db.profile.icons.statusbar = value;ns:UpdateFramesStyle(); end,
			get = function(info) return ns.db.profile.icons.statusbar end,
		}
		
		o.args.icons_.args.borders_tick ={
			order = 7,name = L["Граница тиков"],type = "group", embend = true,
			args={
			
			},
		}
		
		o.args.icons_.args.borders_tick.args.bgcolor = {
			order = 19.2,name = L["Цвет фона"],type = "color", hasAlpha = true,
			set = function(info,r,g,b,a) ns.db.profile.icons.border_tick.background={r,g,b,a};ns:UpdateFramesStyle();end,
			get = function(info) return ns.db.profile.icons.border_tick.background[1],ns.db.profile.icons.border_tick.background[2],ns.db.profile.icons.border_tick.background[3],ns.db.profile.icons.border_tick.background[4] end
		}
		o.args.icons_.args.borders_tick.args.bginset = {
			name = L["Отступ фона"],
			type = "slider",
			order	= 19.4,
			min		= -50,
			max		= 50,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.border_tick.bg_inset = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.border_tick.bg_inset
			end,
		}
		o.args.icons_.args.borders_tick.args.border = {
			order = 19.1,type = 'border',name = L["Текстура"],
			values = ns.SharedMedia:HashTable("border"),
			set = function(info,value) ns.db.profile.icons.border_tick.texture = value;ns:UpdateFramesStyle();end,
			get = function(info) return ns.db.profile.icons.border_tick.texture end,
		}
						
		o.args.icons_.args.borders_tick.args.bordercolor = {
			order = 19.2,name = L["Цвет"],type = "color", hasAlpha = true,
			set = function(info,r,g,b,a) ns.db.profile.icons.border_tick.color={r,g,b,a};ns:UpdateFramesStyle();end,
			get = function(info) return ns.db.profile.icons.border_tick.color[1],ns.db.profile.icons.border_tick.color[2],ns.db.profile.icons.border_tick.color[3],ns.db.profile.icons.border_tick.color[4] end
		}
			
		o.args.icons_.args.borders_tick.args.bordersize = {
			name = L["Размер"],
			type = "slider",
			order	= 19.3,
			min		= 0,
			max		= 32,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.border_tick.size = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.border_tick.size
			end,
		}
		o.args.icons_.args.borders_tick.args.borderinset = {
			name = L["Отступ границ"],
			type = "slider",
			order	= 19.4,
			min		= 0,
			max		= 32,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.border_tick.inset = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.border_tick.inset
			end,
		}
		
		o.args.icons_.args.font.args.timer ={
			order = 10,name = L["Таймер"],type = "group", embend = true,
			args={
				fontisize_stack = {
					name = L["Размер шрифта"], disabled = false,
					type = "slider",
					order	= 1,
					min		= 1,
					max		= 32,
					step	= 1,
					set = function(info,val) 
						ns.db.profile.icons.fonts.timer.fontsize = val
						ns:UpdateFramesStyle()
					end,
					get =function(info)
						return ns.db.profile.icons.fonts.timer.fontsize
					end,
				},
				textposition_stack = {	
					type = "dropdown",order = 6,
					name = L["Выравнивание текста"],
					desc = L["Выравнивание текста"],
					values = {
						["TOP;CENTER"] = L["Сверху"],
						["TOP;LEFT"] = L["Слева вверху"],
						["TOP;RIGHT"] = L["Справа вверху"],
						["CENTER;CENTER"] = L["Центр"],
						["BOTTOM;CENTER"] = L["Снизу"],
						["BOTTOM;LEFT"] = L["Слева внизу"],
						["BOTTOM;RIGHT"] = L["Справа внизу"],
						["CENTER;LEFT"] = L["По центру слева"],
						["CENTER;RIGHT"] = L["По центру справа"],
					},
					set = function(info,val) 
						ns.db.profile.icons.fonts.timer.text_point = val
						ns:UpdateFramesStyle()
					end,
					get = function(info) return ns.db.profile.icons.fonts.timer.text_point end
				},
				color = {
					order = 7,name = L["Цвет"], type = "color", hasAlpha = false,
					set = function(info,r,g,b,a) 
						ns.db.profile.icons.fonts.timer.color ={r,g,b,1};
						ns:UpdateFramesStyle()
					end,
					get = function(info) 
						return ns.db.profile.icons.fonts.timer.color[1], ns.db.profile.icons.fonts.timer.color[2], ns.db.profile.icons.fonts.timer.color[3], 1
					end
				},
				font_pos_x = {
					name = L["Смещение по горизонтали"], disabled = false,
					type = "slider",
					order	= 10,
					min		= -50,
					max		= 50,
					step	= 1,
					set = function(info,val) 
						ns.db.profile.icons.fonts.timer.spacing_h = val
						ns:UpdateFramesStyle()
					end,
					get =function(info)
						return ns.db.profile.icons.fonts.timer.spacing_h
					end,
				},
				font_pos_7 = {
					name = L["Смещение по вертикали"], disabled = false,
					type = "slider",
					order	= 15,
					min		= -50,
					max		= 50,
					step	= 1,
					set = function(info,val) 
						ns.db.profile.icons.fonts.timer.spacing_v = val
						ns:UpdateFramesStyle()
					end,
					get =function(info)
						return ns.db.profile.icons.fonts.timer.spacing_v
					end,
				},
			},
		}
		
		o.args.icons_.args.borders ={
			order = 8,name = L["Граница иконок"],type = "group", embend = true,
			args={
			
			},
		}


		o.args.icons_.args.borders.args.bgcolor = {
			order = 19.2,name = L["Цвет фона"],type = "color", hasAlpha = true,
			set = function(info,r,g,b,a) ns.db.profile.icons.border.background={r,g,b,a};ns:UpdateFramesStyle();end,
			get = function(info) return ns.db.profile.icons.border.background[1],ns.db.profile.icons.border.background[2],ns.db.profile.icons.border.background[3],ns.db.profile.icons.border.background[4] end
		}
		o.args.icons_.args.borders.args.bginset = {
			name = L["Отступ фона"],
			type = "slider",
			order	= 19.4,
			min		= -50,
			max		= 50,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.border.bg_inset = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.border.bg_inset
			end,
		}
		o.args.icons_.args.borders.args.border = {
			order = 19.1,type = 'border',name = L["Граница"],
			values = ns.SharedMedia:HashTable("border"),
			set = function(info,value) ns.db.profile.icons.border.texture = value;ns:UpdateFramesStyle();end,
			get = function(info) return ns.db.profile.icons.border.texture end,
		}
						
		o.args.icons_.args.borders.args.bordercolor = {
			order = 19.2,name = L["Цвет"],type = "color", hasAlpha = true,
			set = function(info,r,g,b,a) ns.db.profile.icons.border.color={r,g,b,a};ns:UpdateFramesStyle();end,
			get = function(info) return ns.db.profile.icons.border.color[1],ns.db.profile.icons.border.color[2],ns.db.profile.icons.border.color[3],ns.db.profile.icons.border.color[4] end
		}
			
		o.args.icons_.args.borders.args.bordersize = {
			name = L["Размер"],
			type = "slider",
			order	= 19.3,
			min		= 0,
			max		= 32,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.border.size = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.border.size
			end,
		}
		o.args.icons_.args.borders.args.borderinset = {
			name = L["Отступ границ"],
			type = "slider",
			order	= 19.4,
			min		= 0,
			max		= 32,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.border.inset = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.border.inset
			end,
		}
		
		
		o.args.icons_.args.powerType = {
			order = 2.9, name = L["Тип отображения силы дот"],
			type = "dropdown",
			width = 'full',
			values = { L['Текст'], L['Индикаторы'] },
			set = function(self, value)
				ns.db.profile.icons.powerType = value;
				
				SwitchPowerTextSettings(ns.db.profile.icons.powerType==1)
			end,
			get = function(self)		
				return ns.db.profile.icons.powerType
			end	
		}
		SwitchPowerTextSettings(ns.db.profile.icons.powerType==1)
	end
	
	function SwitchToBarSettings()
		o.args.icons_.args.style ={
			order = 1,name = L["Стиль"],type = "group", embend = true,
			args={
			
			},
		}
		
		o.args.icons_.args.style.args.gap = {
			name = L["Отступ"], disabled = false,
			type = "slider",
			order	= 2,
			min		= 0,
			max		= 50,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.bars.gap = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.bars.gap
			end,
		}

		
		o.args.icons_.args.style.args.width = {
			name = L["Ширина"], disabled = false,
			type = "slider",
			order	= 1,
			min		= 1,
			max		= 800,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.bars.width = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.bars.width
			end,
		}
		
		o.args.icons_.args.style.args.height = {
			name = L["Высота"], disabled = false,
			type = "slider",
			order	= 1,
			min		= 1,
			max		= 800,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.bars.height = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.bars.height
			end,
		}
		
		o.args.icons_.args.powertext ={
			order = 3,name = L["Текст силы"],type = "group", embend = true,
			args={
			
			},
		}
		
		o.args.icons_.args.powertext.args.fontisize_stack = {
			name = L["Размер шрифта"], disabled = false, width = 'full',
			type = "slider",
			order	= 0.1,
			min		= 1,
			max		= 60,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.fonts.power.fontsize = val
				ns:UpdateFramesStyle()
			end,
			get =function(info)
				return ns.db.profile.icons.fonts.power.fontsize
			end,
		}
		
		o.args.icons_.args.cooldown_overlay = nil
		o.args.icons_.args.ticks_position = nil
		o.args.icons_.args.borders_tick = nil
		
		o.args.icons_.args.font.args.timer ={
			order = 10,name = L["Таймер"],type = "group", embend = true,
			args={
				fontisize_stack = {
					name = L["Размер шрифта"], disabled = false,
					type = "slider",
					order	= 1,
					min		= 1,
					max		= 32,
					step	= 1,
					set = function(info,val) 
						ns.db.profile.icons.fonts.timer.fontsize = val
						ns:UpdateFramesStyle()
					end,
					get =function(info)
						return ns.db.profile.icons.fonts.timer.fontsize
					end,
				},
				color = {
					order = 7,name = L["Цвет"], type = "color", hasAlpha = false,
					set = function(info,r,g,b,a) 
						ns.db.profile.icons.fonts.timer.color ={r,g,b,1};
						ns:UpdateFramesStyle()
					end,
					get = function(info) 
						return ns.db.profile.icons.fonts.timer.color[1], ns.db.profile.icons.fonts.timer.color[2], ns.db.profile.icons.fonts.timer.color[3], 1
					end
				},
			},
		}
		o.args.icons_.args.borders = nil
		
		o.args.icons_.args.style.args.borders ={
			order = 8,name = L["Граница"],type = "group", embend = true,
			args={
			
			},
		}
		
		o.args.icons_.args.style.args.borders.args.bgcolor = {
			order = 19.2,name = L["Цвет фона"],type = "color", hasAlpha = true,
			set = function(info,r,g,b,a) ns.db.profile.icons.border.background={r,g,b,a};ns:UpdateFramesStyle();end,
			get = function(info) return ns.db.profile.icons.border.background[1],ns.db.profile.icons.border.background[2],ns.db.profile.icons.border.background[3],ns.db.profile.icons.border.background[4] end
		}
		o.args.icons_.args.style.args.borders.args.bginset = {
			name = L["Отступ фона"],
			type = "slider",
			order	= 19.4,
			min		= -50,
			max		= 50,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.border.bg_inset = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.border.bg_inset
			end,
		}
		o.args.icons_.args.style.args.borders.args.border = {
			order = 19.1,type = 'border',name = L["Граница"],
			values = ns.SharedMedia:HashTable("border"),
			set = function(info,value) ns.db.profile.icons.border.texture = value;ns:UpdateFramesStyle();end,
			get = function(info) return ns.db.profile.icons.border.texture end,
		}
						
		o.args.icons_.args.style.args.borders.args.bordercolor = {
			order = 19.2,name = L["Цвет"],type = "color", hasAlpha = true,
			set = function(info,r,g,b,a) ns.db.profile.icons.border.color={r,g,b,a};ns:UpdateFramesStyle();end,
			get = function(info) return ns.db.profile.icons.border.color[1],ns.db.profile.icons.border.color[2],ns.db.profile.icons.border.color[3],ns.db.profile.icons.border.color[4] end
		}
			
		o.args.icons_.args.style.args.borders.args.bordersize = {
			name = L["Размер"],
			type = "slider",
			order	= 19.3,
			min		= 0,
			max		= 32,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.border.size = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.border.size
			end,
		}
		o.args.icons_.args.style.args.borders.args.borderinset = {
			name = L["Отступ границ"],
			type = "slider",
			order	= 19.4,
			min		= 0,
			max		= 32,
			step	= 1,
			set = function(info,val) 
				ns.db.profile.icons.border.inset = val
				ns:UpdateFramesStyle();
			end,
			get =function(info)
				return ns.db.profile.icons.border.inset
			end,
		}
		
		o.args.icons_.args.style.args.growUp = {
			order = 4,type = 'toggle',name = L["Рост вверх"], 
			set = function(info,value) ns.db.profile.bars.growUp = not ns.db.profile.bars.growUp; ns:UpdateFramesStyle();end,
			get = function(info) return ns.db.profile.bars.growUp end,
		}
		
		o.args.icons_.args.style.args.statusbar = {
			order = 5,type = 'statusbar',name = L["Полоса"], 
			values = ns.SharedMedia:HashTable("statusbar"),
			set = function(info,value) ns.db.profile.bars.texture = value; ns:UpdateFramesStyle();end,
			get = function(info) return ns.db.profile.bars.texture end,
		}
		
		o.args.icons_.args.style.args.color = {
			order = 6,name = L["Цвет"],type = "color", hasAlpha = true,
			set = function(info,r,g,b,a) ns.db.profile.bars.color={r,g,b,a}; ns:UpdateFramesStyle();end,
			get = function(info)
				return ns.db.profile.bars.color[1],ns.db.profile.bars.color[2],ns.db.profile.bars.color[3],ns.db.profile.bars.color[4] 
			end
		}
		
		
		o.args.icons_.args.powerType = nil
		SwitchPowerTextSettings(false)
	end
	
	
	o.args.icons_.args.movingme = {
		order = 0.1,name = L["Передвинь меня!"], type = "execute",
		set = function(info,val) ns:UnlockMover("IconsBar"); end,
		get = function(info) return false end
	}
	
	o.args.icons_.args.widgetType = {
		order = 0.2,name = L["Стиль индикатора"], type = "dropdown",
		values = {
			L['Иконка'],
			L['Полоса'],
		},
		set = function(info,val)
			ns.db.profile.widgetType = val
			
			if ns.db.profile.widgetType == 1 then
				SwitchToIconSettings()
			else
				SwitchToBarSettings()
			end
			
			ns:UpdateOrders()
		end,
		get = function(info) 
			return ns.db.profile.widgetType 
		end
	}
	
	o.args.icons_.args.iconorder_new ={
		order = 0.4,name = L["Сортировка"],type = "group", embend = true,
		args={
		
		},
	}
	
	for i, spell in pairs({ns.glybokayrana_spid, ns.razorvat_spid, ns.vzbuchka_spid, ns.dikiyrev_spid, ns.moonfire_spid  }) do
		o.args.icons_.args.iconorder_new.args['spell'..i] = {
			name = L["Показывать"],
			order = i,
			width = 'full',
			spellID = spell,
			type = "FeralDotDamageSortElement",
			set1 = function(info, value)	
				ns.db.profile.ordering_spells.sort[ns.db.profile.ordering_spells.spellidtoid[spell]].on = 
					not ns.db.profile.ordering_spells.sort[ns.db.profile.ordering_spells.spellidtoid[spell]].on			

			--	print('Set1')
				ns:UpdateOrders()
			end,
			get1 = function(info, value)
				return ns.db.profile.ordering_spells.sort[ns.db.profile.ordering_spells.spellidtoid[spell]].on
			end,
			
			set = function(info, value)
				ns.db.profile.ordering_spells.sort[ns.db.profile.ordering_spells.spellidtoid[info]].sort = value
			--	print('Set')
				ns:UpdateOrders()
			end,
			get = function(info, value)
				return ( ns.db.profile.ordering_spells.sort[ns.db.profile.ordering_spells.spellidtoid[info]].sort == value )
			end,
		}
	end

	o.args.icons_.args.font ={
		order = 1.1,name = L["Шрифт"],type = "group", embend = true,
		args={
			font = {
				order = 4,name = L["Шрифт"],type = 'font',
				values = ns.SharedMedia:HashTable("font"),
				set = function(info,key) 
					ns.db.profile.icons.fonts.font = key
					ns:UpdateFramesStyle()
				end,
				get = function(info) return ns.db.profile.icons.fonts.font end,
			},
			time_format = {
				name = L["Формат времени"],
				type = "dropdown",
				order	= 4.1,
				values = {
					"1 3 10 20 50 2m",
					"0.1 1 1.5 3 2m",
				},
				set = function(info,val) 
					ns.db.profile.icons.time_format = val
				end,
				get =function(info)
					return ns.db.profile.icons.time_format
				end,
			},	
			fontflag = {
				type = "dropdown",	order = 4.2,
				name = L["Обводка шрифта"],
				values = {
					["NONE"] = NO,
					["OUTLINE"] = "OUTLINE",
					["THICKOUTLINE"] = "THICKOUTLINE",
					["MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
				},
				set = function(info,val) 
					ns.db.profile.icons.fonts.fontflag = val
					ns:UpdateFramesStyle()
				end,
				get = function(info) return ns.db.profile.icons.fonts.fontflag end
			},
			--[[
			shadow_pos1 = {
				name = L["Тень текста X"], disabled = false,
				type = "slider",
				order	= 5,
				min		= -5,
				max		= 5,
				step	= 0.1,
				set = function(info,val) 
					ns.db.profile.icons.fonts.shadow_pos[1] = val
					ns:UpdateFramesStyle()
				end,
				get =function(info)
					return ns.db.profile.icons.fonts.shadow_pos[1]
				end,
			},
			shadow_pos2 = {
				name = L["Тень текста Y"], disabled = false,
				type = "slider",
				order	= 5.1,
				min		= -5,
				max		= 5,
				step	= 0.1,
				set = function(info,val) 
					ns.db.profile.icons.fonts.shadow_pos[2] = val
					ns:UpdateFramesStyle()
				end,
				get =function(info)
					return ns.db.profile.icons.fonts.shadow_pos[2]
				end,
			},
			]]
		},
	}
	o.args.icons_.args.coloring ={
		order = 2,name = L["Цвета"],type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.icons_.args.powertext ={
		order = 3,name = L["Текст силы"],type = "group", embend = true,
		args={
		
		},
	}
	o.args.icons_.args.cooldown_overlay ={
		order = 4,name = L["Перезарядки"],type = "group", embend = true,
		args={
		
		},
	}
	o.args.icons_.args.glow_group ={
		order = 5,name = L["Пандемия"],type = "group", embend = true,
		args={
		
		},
	}
	o.args.icons_.args.ticks_position ={
		order = 6,name = L["Тики"],type = "group", embend = true,
		args={
		
		},
	}
	o.args.icons_.args.borders_tick ={
		order = 7,name = L["Граница тиков"],type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.icons_.args.borders ={
		order = 8,name = L["Граница иконок"],type = "group", embend = true,
		args={
		
		},
	}
	o.args.icons_.args.others ={
		order = 9,name = L["Разное"],type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.icons_.args.font.args.timer ={
		order = 10,name = L["Таймер"],type = "group", embend = true,
		args={
			fontisize_stack = {
				name = L["Размер шрифта"], disabled = false,
				type = "slider",
				order	= 1,
				min		= 1,
				max		= 32,
				step	= 1,
				set = function(info,val) 
					ns.db.profile.icons.fonts.timer.fontsize = val
					ns:UpdateFramesStyle()
				end,
				get =function(info)
					return ns.db.profile.icons.fonts.timer.fontsize
				end,
			},
			textposition_stack = {	
				type = "dropdown",order = 6,
				name = L["Выравнивание текста"],
				desc = L["Выравнивание текста"],
				values = {
					["TOP;CENTER"] = L["Сверху"],
					["TOP;LEFT"] = L["Слева вверху"],
					["TOP;RIGHT"] = L["Справа вверху"],
					["CENTER;CENTER"] = L["Центр"],
					["BOTTOM;CENTER"] = L["Снизу"],
					["BOTTOM;LEFT"] = L["Слева внизу"],
					["BOTTOM;RIGHT"] = L["Справа внизу"],
					["CENTER;LEFT"] = L["По центру слева"],
					["CENTER;RIGHT"] = L["По центру справа"],
				},
				set = function(info,val) 
					ns.db.profile.icons.fonts.timer.text_point = val
					ns:UpdateFramesStyle()
				end,
				get = function(info) return ns.db.profile.icons.fonts.timer.text_point end
			},
			color = {
				order = 7,name = L["Цвет"], type = "color", hasAlpha = false,
				set = function(info,r,g,b,a) 
					ns.db.profile.icons.fonts.timer.color ={r,g,b,1};
					ns:UpdateFramesStyle()
				end,
				get = function(info) 
					return ns.db.profile.icons.fonts.timer.color[1], ns.db.profile.icons.fonts.timer.color[2], ns.db.profile.icons.fonts.timer.color[3], 1
				end
			},
			font_pos_x = {
				name = L["Смещение по горизонтали"], disabled = false,
				type = "slider",
				order	= 10,
				min		= -50,
				max		= 50,
				step	= 1,
				set = function(info,val) 
					ns.db.profile.icons.fonts.timer.spacing_h = val
					ns:UpdateFramesStyle()
				end,
				get =function(info)
					return ns.db.profile.icons.fonts.timer.spacing_h
				end,
			},
			font_pos_7 = {
				name = L["Смещение по вертикали"], disabled = false,
				type = "slider",
				order	= 15,
				min		= -50,
				max		= 50,
				step	= 1,
				set = function(info,val) 
					ns.db.profile.icons.fonts.timer.spacing_v = val
					ns:UpdateFramesStyle()
				end,
				get =function(info)
					return ns.db.profile.icons.fonts.timer.spacing_v
				end,
			},
		},
	}
	
	o.args.icons_.args.glow_group.args.fadingglow = {
		order = 1,name = L["Анимация пандемии"],type = "toggle", width = "full",
		desc = L['Пандемия - порог в 30% от базовой длительности ауры. При обновлении ауры, оставшаяся длительность, в пределах Пандемии, приплюсуется к новой ауре.'],
		set = function(info,val) ns.db.profile.icons.fadingglow = not ns.db.profile.icons.fadingglow;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.icons.fadingglow end
	}
	o.args.icons_.args.glow_group.args.glowcolor = {
		order = 2,name = L["Цвет"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.icons.glowcolor={r,g,b,a};ns:UpdateFramesStyle(); end,
		get = function(info)
			return ns.db.profile.icons.glowcolor[1],ns.db.profile.icons.glowcolor[2],ns.db.profile.icons.glowcolor[3],ns.db.profile.icons.glowcolor[4] 
		end
	}
	o.args.icons_.args.glow_group.args.glowsize = {
		name = L["Размер"],
		type = "slider",
		order	= 3,
		min		= 1,
		max		= 10,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.icons.glowsize = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.icons.glowsize
		end,
	}
	
	
	o.args.icons_.args.borders_tick.args.bgcolor = {
		order = 19.2,name = L["Цвет фона"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.icons.border_tick.background={r,g,b,a};ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.icons.border_tick.background[1],ns.db.profile.icons.border_tick.background[2],ns.db.profile.icons.border_tick.background[3],ns.db.profile.icons.border_tick.background[4] end
	}
	o.args.icons_.args.borders_tick.args.bginset = {
		name = L["Отступ фона"],
		type = "slider",
		order	= 19.4,
		min		= -50,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.icons.border_tick.bg_inset = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.icons.border_tick.bg_inset
		end,
	}
	o.args.icons_.args.borders_tick.args.border = {
		order = 19.1,type = 'border',name = L["Текстура"],
		values = ns.SharedMedia:HashTable("border"),
		set = function(info,value) ns.db.profile.icons.border_tick.texture = value;ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.icons.border_tick.texture end,
	}
					
	o.args.icons_.args.borders_tick.args.bordercolor = {
		order = 19.2,name = L["Цвет"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.icons.border_tick.color={r,g,b,a};ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.icons.border_tick.color[1],ns.db.profile.icons.border_tick.color[2],ns.db.profile.icons.border_tick.color[3],ns.db.profile.icons.border_tick.color[4] end
	}
		
	o.args.icons_.args.borders_tick.args.bordersize = {
		name = L["Размер"],
		type = "slider",
		order	= 19.3,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.icons.border_tick.size = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.icons.border_tick.size
		end,
	}
	o.args.icons_.args.borders_tick.args.borderinset = {
		name = L["Отступ границ"],
		type = "slider",
		order	= 19.4,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.icons.border_tick.inset = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.icons.border_tick.inset
		end,
	}
	
	o.args.icons_.args.coloring.args.text_color_values = {
		order = 1,name = L["Цвет текста от значения"],type = "toggle",
		set = function(info,val) ns.db.profile.icons.text_color_values = not ns.db.profile.text_color_values;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.icons.text_color_values end
	}
	
	o.args.icons_.args.coloring.args.icon_color_values = {
		order = 2,name = L["Цвет инонок от значения"],type = "toggle",
		set = function(info,val) ns.db.profile.icons.icon_color_values = not ns.db.profile.icons.icon_color_values;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.icons.icon_color_values end
	}
	
	o.args.icons_.args.coloring.args.text_show_current = {
		order = 3,name = L["Показать текущее значение"],type = "toggle",
		desc = L["Показать текущее значение"],
		set = function(info,val) ns.db.profile.icons.text_show_current = not ns.db.profile.icons.text_show_current;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.icons.text_show_current end
	}
	
	o.args.icons_.args.coloring.args.text_show_current_main = {
		order = 3.1,name = L["Показать значение баффов"],type = "toggle",
		desc = L["Показать значение баффов"],
		set = function(info,val) ns.db.profile.icons.text_show_buffs = not ns.db.profile.icons.text_show_buffs;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.icons.text_show_buffs end
	}
	
	o.args.icons_.args.coloring.args.revert_text_coloring = {
		order = 4,name = L["Обратить цвет текста"],type = "toggle",
		set = function(info,val) ns.db.profile.icons.revert_text_coloring = not ns.db.profile.icons.revert_text_coloring;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.icons.revert_text_coloring end
	}
	
	o.args.icons_.args.coloring.args.same_color = {
		order = 5,name = L['цвет "Схожий"'],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.icons.same_color={r,g,b,a};ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.icons.same_color[1],ns.db.profile.icons.same_color[2],ns.db.profile.icons.same_color[3],ns.db.profile.icons.same_color[4] end
	}
	
	o.args.icons_.args.coloring.args.better_color = {
		order = 6,name = L['цвет "Лучше"'],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.icons.better_color={r,g,b,a};ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.icons.better_color[1],ns.db.profile.icons.better_color[2],ns.db.profile.icons.better_color[3],ns.db.profile.icons.better_color[4] end
	}
	
	o.args.icons_.args.coloring.args.worse_color = {
		order = 7,name = L['цвет "Хуже"'],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.icons.worse_color={r,g,b,a}; ns:UpdateFramesStyle();end,
		get = function(info) return ns.db.profile.icons.worse_color[1],ns.db.profile.icons.worse_color[2],ns.db.profile.icons.worse_color[3],ns.db.profile.icons.worse_color[4] end
	}
	
	o.args.icons_.args.coloring.args.text_relative = {
		order = 2,name = L["Относительные значения"],type = "toggle",
		set = function(info,val) ns.db.profile.relative_numbers = not ns.db.profile.relative_numbers;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.relative_numbers end
	}
	
	o.args.icons_.args.coloring.args.count_cp_to_power = {
		order = 4.1,name = L["Учитывать очки серии для "]..GetSpellNameGUI(1079), type = "toggle", width = 'full',
		set = function(info,val) ns.db.profile.count_cp_to_power = not ns.db.profile.count_cp_to_power;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.count_cp_to_power end
	}
	
	o.args.icons_.args.coloring.args.dotpowerspike = {
		name = L["Пороговое значение"], disabled = false,
		type = "slider",
		order	= 10,
		min		= 0,
		max		= 400,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.dotpowerspike = val
		end,
		get =function(info)
			return ns.db.profile.dotpowerspike
		end,
	}
	
	o.args.icons_.args.cooldown_overlay.args.timertext = {
		order = 1,name = L["Текст таймера"],type = "toggle", width = "full",
		set = function(info,val) ns.db.profile.icons.timertext = not ns.db.profile.icons.timertext;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.icons.timertext end
	}
	o.args.icons_.args.cooldown_overlay.args.hide_overlay = {
		order = 3,name = L["Показывать оверлей"],type = "toggle", width = "full",
		set = function(info,val) ns.db.profile.icons.hide_overlay = not ns.db.profile.icons.hide_overlay;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.icons.hide_overlay end
	}
	
	o.args.icons_.args.others.args.desaturated = {
		order = 1,name = L["Черно-белая иконка"],type = "toggle",
		set = function(info,val) ns.db.profile.icons.desaturated = not ns.db.profile.icons.desaturated;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.icons.desaturated end
	}
	
	o.args.icons_.args.others.args.showcp = {
		order = 2,name = L["Показывать КП на иконках"],type = "toggle",
		desc = L["Показывать КП на иконках"],
		set = function(info,val) ns.db.profile.icons.showcp = not ns.db.profile.icons.showcp;ns:UpdateFramesStyle(); end,
		get = function(info) return ns.db.profile.icons.showcp end
	}
	
	o.args.icons_.args.others.args.alpha_outof_combat = {
		name = L["Прозрачность неактивной иконки"],
		desc = L["Прозрачность неактивной иконки"],
		type = "slider",
		order	= 3,
		min		= 0,
		max		= 1,
		step	= 0.1,
		set = function(info,val) 
			ns.db.profile.icons.alpha_outof_combat = val
			ns:UpdateFramesStyle();
		end,
		get =function(info)
			return ns.db.profile.icons.alpha_outof_combat
		end,
	}
	
	o.args.cleudots.args.enable = {
		order = 0.9,name = L["Включено"], desc = L["Включено"], type = "toggle", width = "full",
		set = function(info,val) ns.db.profile.multi_enable = not ns.db.profile.multi_enable; ns:UpdateMultiDot(); end,
		get = function(info) return ns.db.profile.multi_enable end	
	}
	
	o.args.cleudots.args.growing = {
		order = 1,name = L["Рост вверх"],type = "toggle",
		set = function(info,val) ns.db.profile.growing = not ns.db.profile.growing; ns:UpdateMultiDot(); end,
		get = function(info) return ns.db.profile.growing end
	}
	
	o.args.cleudots.args.movingme = {
		order = 1.1,name = L["Передвинь меня!"], type = "execute",
		set = function(info,val) ns:ShowMovingFrame(); end,
		get = function(info) return false end
	}
	
	o.args.cleudots.args.multi_show_target = {
		order = 1.2,name = L["Показывать основную цель"],type = "toggle", width = 'full', 
		set = function(info,val) ns.db.profile.multi_show_target = not ns.db.profile.multi_show_target; ns:UpdateMultiDot(); end,
		get = function(info) return ns.db.profile.multi_show_target end
	}
	
	
	o.args.cleudots.args.spacing = {
		name = L["Отступ элементов"], disabled = false,
		type = "slider",
		order	= 1.4,
		min		= 0,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.multi_spacing = val
			ns:UpdateMultiDot();
		end,
		get =function(info)
			return ns.db.profile.multi_spacing
		end,
	}
	--[[
	o.args.cleudots.args.xpos = {
		name = L["X pos"], disabled = false,
		type = "slider",
		order	= 3,
		min		= -1500,
		max		= 1500,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.multi_xpos = val
			ns:UpdateMultiDot();
		end,
		get =function(info)
			return ns.db.profile.multi_xpos
		end,
	}
	
	o.args.cleudots.args.ypos = {
		name = L["Y pos"], disabled = false,
		type = "slider",
		order	= 4,
		min		= -1500,
		max		= 1500,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.multi_ypos = val
			ns:UpdateMultiDot();
		end,
		get =function(info)
			return ns.db.profile.multi_ypos
		end,
	}
	]]
	
	o.args.cleudots.args.scale = {
		name = L["Увеличение"], disabled = false,
		type = "slider",
		order	= 2,
		min		= 0.1,
		max		= 1,
		step	= 0.1,
		set = function(info,val) 
			ns.db.profile.multi_scale = val
			ns:UpdateMultiDot();
		end,
		get =function(info)
			return ns.db.profile.multi_scale
		end,
	}
	
	o.args.cleudots.args.font_size = {
		name = L["Размер шрифта"], disabled = false,
		type = "slider",
		order	= 5,
		min		= 1,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.multi_font_size = val
			ns:MultitargetFontUpdate();
		end,
		get =function(info)
			return ns.db.profile.multi_font_size
		end,
	}
	
	o.args.cleudots.args.icon_scale = {
		name = L["Размер иконок"], disabled = false,
		type = "slider",
		order	= 5,
		min		= 1,
		max		= 40,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.multi_icon_size = val
			ns:UpdateMultiDot();
		end,
		get =function(info)
			return ns.db.profile.multi_icon_size
		end,
	}
	
	o.args.cleudots.args.font_icon_scale = {
		name = L["Размер шрифта иконок"], disabled = false,
		type = "slider",
		order	= 6,
		min		= 1,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.multi_font_icon_size = val
			ns:MultitargetFontUpdate();
		end,
		get =function(info)
			return ns.db.profile.multi_font_icon_size
		end,
	}
	
	o.args.cleudots.args.multi_icon_gap = {
		name = L["Отступ иконок"], disabled = false,
		type = "slider",
		order	= 7,
		min		= 1,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.multi_icon_gap = val
			ns:UpdateMultiDot();
		end,
		get =function(info)
			return ns.db.profile.multi_icon_gap
		end,
	}
	
	o.args.cleudots.args.multi_icon_time_format = {
		name = L["Формат времени"],
		type = "dropdown",
		order	= 7.1,
		values = {
			"1 3 10 20 50",
			"0.1 1 1.5 3"
		},
		set = function(info,val) 
			ns.db.profile.multi_icon_time_format = val
			ns:UpdateMultiDot();
		end,
		get =function(info)
			return ns.db.profile.multi_icon_time_format
		end,
	}
	
	o.args.cleudots.args.multi_icon_hide_not_exists = {
		name = L["Скрывать отсутствующие ауры"], disabled = false,
		desc = L["Скрывать отсутствующие ауры"],
		type = "toggle",
		order	= 8,
		set = function(info,val) 
			ns.db.profile.multi_icon_hide_not_exists = not ns.db.profile.multi_icon_hide_not_exists
			ns:UpdateMultiDot();
		end,
		get =function(info)
			return ns.db.profile.multi_icon_hide_not_exists
		end,
	}
	
	o.args.cleudots.args.multi_hide_names = {
		name = L["Скрывать имена"], disabled = false,
		desc = L["Скрывать имена"],
		type = "toggle",
		order	= 8.1,
		set = function(info,val) 
			ns.db.profile.multi_hide_names = not ns.db.profile.multi_hide_names
			ns:MultitargetFontUpdate();
		end,
		get =function(info)
			return ns.db.profile.multi_hide_names
		end,
	}

	o.args.cleudots.args.multi_target_color = {
		name = L["Цвет текста цели"],
		type = "color",
		order	= 9,
		set = function(info,r,g,b) 
			ns.db.profile.multi_target_color = { r, g, b, 1};
			ns:UpdateMultiDot();
		end,
		get =function(info)
			return ns.db.profile.multi_target_color[1], ns.db.profile.multi_target_color[2], ns.db.profile.multi_target_color[3], 1
		end,
	}
	
	o.args.cleudots.args.Spells ={
		order = 9.1,name = L["Заклинания"],type = "group", embend = true,
		args={
		
		},
	}
	
	for i=1, 6 do
		local spell_id = { 155722, 1079, 106830, 155625, 339, 102359 } --210705		
		spell_id = spell_id[i]
		
		o.args.cleudots.args.Spells.args["spell"..i] = {
			name = GetSpellNameGUI(spell_id) , disabled = false,
			type = "toggle",
			order	= i,
			set = function(info,val)
				ns.db.profile.multi_spells_[spell_id][1] = not ns.db.profile.multi_spells_[spell_id][1]
				ns:UpdateMultiDot();
			end,
			get =function(info)
				return ns.db.profile.multi_spells_[spell_id][1]
			end,
		}	
	end
	
	o.args.cleudots.args.borders ={
		order = 10,name = L["Граница"],type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.cleudots.args.borders.args.border = {
		order = 19.1,type = 'border',name = L["Текстура"],
		values = ns.SharedMedia:HashTable("border"),
		set = function(info,value) ns.db.profile.multi_border.texture = value;ns:UpdateMultiDotBorders();end,
		get = function(info) return ns.db.profile.multi_border.texture end,
	}
					
	o.args.cleudots.args.borders.args.bordercolor = {
		order = 19.2,name = L["Цвет"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.multi_border.color={r,g,b,a};ns:UpdateMultiDotBorders();end,
		get = function(info) return ns.db.profile.multi_border.color[1],ns.db.profile.multi_border.color[2],ns.db.profile.multi_border.color[3],ns.db.profile.multi_border.color[4] end
	}
					
	o.args.cleudots.args.borders.args.bordersize = {
		name = L["Размер"],
		type = "slider",
		order	= 19.3,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.multi_border.size = val
			ns:UpdateMultiDotBorders();
		end,
		get =function(info)
			return ns.db.profile.multi_border.size
		end,
	}
	o.args.cleudots.args.borders.args.borderinset = {
		name = L["Отступ границ"],
		type = "slider",
		order	= 19.4,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.multi_border.inset = val
			ns:UpdateMultiDotBorders();
		end,
		get =function(info)
			return ns.db.profile.multi_border.inset
		end,
	}
	
	o.args.cleudots.args.borders.args.bgcolor = {
		order = 19.2,name = L["Фон"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) ns.db.profile.multi_border.background={r,g,b,a};ns:UpdateMultiDotBorders();end,
		get = function(info) return ns.db.profile.multi_border.background[1],ns.db.profile.multi_border.background[2],ns.db.profile.multi_border.background[3],ns.db.profile.multi_border.background[4] end
	}
	o.args.cleudots.args.borders.args.bginset = {
		name = L["Отступ фона"],
		type = "slider",
		order	= 19.4,
		min		= -50,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			ns.db.profile.multi_border.bg_inset = val
			ns:UpdateMultiDotBorders();
		end,
		get =function(info)
			return ns.db.profile.multi_border.bg_inset
		end,
	}
	
	local order_1 = 1
	--[==[
	for k,v in pairs(sites) do
	
		o.args.about.args[k] =  {
			type = "editbox",	order = order_1,
			name = v[1],
			width = v[4],
			set = function(info,val) end,						
			get = function(info) return v[2] end
		}
		order_1 = order_1 + 1
	
	end
	
	local don_text = "Donations:\n"
	
	for k,v in ipairs(donation) do
		don_text = don_text..format("%d. %s\n", k, v)	
	end
	
	o.args.about.args.donations  = {
		order = order_1,
		width = "full",
		type = "string",
		name = don_text,
		set = function()
	
		end,
		get = function()
			return don_text
		end,
	}
	]==]
	o.args.anonses = ns:GetAnonseOptions()
	
	o.args.aurawidgets = ns:AddAuraWatcherGUI()
	
	o.args.profiles = ALEAUI_GetProfileOptions("FeralDotDamageDB")
	
	o.args.others = {
		order = 11,name = L["Разное"],type = "group", embend = false,
		args={
			
			AutoInv = {
				name = L["Автоинвайт"], disabled = false, desc = "inv, инв",
				type = "toggle",
				order	= 1,
				set = function(info,val) 
					ns.db.profile.others.AutoInv = not ns.db.profile.others.AutoInv
				end,
				get =function(info)
					return ns.db.profile.others.AutoInv
				end,
			},
			
			AutoInvGuildOnly = {
				name = L["Приглашать только членов гильдии"], disabled = false,
				type = "toggle",
				order	= 2,
				set = function(info,val) 
					ns.db.profile.others.AutoInvGuildOnly = not ns.db.profile.others.AutoInvGuildOnly
				end,
				get =function(info)
					return ns.db.profile.others.AutoInvGuildOnly
				end,
			},
			
			rangeIndicator = {
				name = L["Индикатор расстояния"],
				embend = true,
				order = 2.2,
				type = 'group',
				args = {
					Enable = {
						name = L['Включить'],
						order = 1,
						type = 'toggle',
						set = function(info)
							ns.db.profile.rangeIndicator = not ns.db.profile.rangeIndicator
							ns:UpdateRangeIndicator()
						end,
						get = function(info)
							return ns.db.profile.rangeIndicator
						end,
					},
					Move = {
						name = L['Передвинь меня!'],
						order = 2,
						type = 'execute',
						set = function(info)
							ns:UnlockMover('rangeIndicator')
						end,
						get = function(info)
							return false
						end,
					},
				},
			},

			miss_alert = {
				order = 3,name = L["Проигрывать звук если не попали способностью"],type = "group", embend = true,
				args={	
					SoundOnMiss = {
						name = L["Включить"], disabled = false, desc = L["Проигрывать звук если не попали способностью"],
						type = "toggle",
						order	= 3,
						set = function(info,val) 
							ns.db.profile.others.playSound = not ns.db.profile.others.playSound
						end,
						get =function(info)
							return ns.db.profile.others.playSound
						end,			
					},
					
					SoundOnMissFile = {
						name = L["Файл"], disabled = false,
						order = 4,				
						type = 'sound',
						values = ns.SharedMedia:HashTable("sound"),									
						set = function(info,val) 
							ns.db.profile.others.playSoundFile = val
						end,
						get =function(info)
							return ns.db.profile.others.playSoundFile
						end,			
					},
				},
			},
			--[==[
			anonceDDLMG = {
				name = L["Анонс легендарного кольца нанесения урона"], disabled = false,
				type = "toggle", width = 'full',
				order	= 6,
				set = function(info,val) 
					ns.db.profile.others.anonceDDLMG = not ns.db.profile.others.anonceDDLMG
				end,
				get =function(info)
					return ns.db.profile.others.anonceDDLMG
				end,
			},
			anonceHEALLMG = {
				name = L["Анонс легендарного кольца исцеления"], disabled = false,
				type = "toggle", width = 'full',
				order	= 7,
				set = function(info,val) 
					ns.db.profile.others.anonceHEALLMG = not ns.db.profile.others.anonceHEALLMG
				end,
				get =function(info)
					return ns.db.profile.others.anonceHEALLMG
				end,
			},
			]==]
			buff_allert = {
				order = 9,name = L["Проверка положительных баффов"],type = "group", embend = true,
				args={	
					
					enable = {
						name = L["Включить"],
						type = "toggle",
						order	= 1,
						set = function(info,val) 
							ns.db.profile.others.buffCheck = not ns.db.profile.others.buffCheck
							ns:UpdateBuffCheckStatus()
						end,
						get =function(info)
							return ns.db.profile.others.buffCheck
						end,			
					},
					
					checkOnEvent = {
						name = L["Событие для проверки"],
						desc = L['Если выбрано "']..L['Проверка готовности или бой начат']..L['" или "']..L['Проверка готовности или бой c боссом начат']..L['" то игрок получит только одно уведомление в течениe 20 секунд.'],
						type = "dropdown",
						values = {
							L['Проверка готовности'],
							L['Бой начат'],
							L['Бой с боссом начат'],
							L['Проверка готовности или бой начат'],
							L['Проверка готовности или бой c боссом начат'],
						},
						order = 2,
						set = function(info,val) 
							ns.db.profile.others.checkOnEvent = val
							ns:UpdateBuffCheckStatus()
						end,
						get =function(info)
							return ns.db.profile.others.checkOnEvent
						end,			
					},
			
					checkBuffsSoundFile = {
						name = L["Звуковое уведомление"],
						type = "sound",
						values = ns.SharedMedia:HashTable("sound"),
						order = 2.1,
						set = function(info,val) 
							ns.db.profile.others.checkBuffsSoundFile = val
							ns:UpdateBuffCheckStatus()
						end,
						get =function(info)
							return ns.db.profile.others.checkBuffsSoundFile
						end,			
					},
					
					flashCheck = {
						name = L["Проверять настой"], disabled = false,
						type = "toggle",
						order	= 3,
						set = function(info,val) 
							ns.db.profile.others.flashCheck = not ns.db.profile.others.flashCheck
							ns:UpdateBuffCheckStatus()
						end,
						get =function(info)
							return ns.db.profile.others.flashCheck
						end,
					},
					runeCheck = {
						name = L["Проверять руну"], disabled = false,
						type = "toggle",
						order	= 4,
						set = function(info,val) 
							ns.db.profile.others.runeCheck = not ns.db.profile.others.runeCheck
							ns:UpdateBuffCheckStatus()
						end,
						get =function(info)
							return ns.db.profile.others.runeCheck
						end,
					},
					foodCheck = {
						name = L["Проверять еду"], disabled = false,
						type = "toggle",
						order	= 5,
						set = function(info,val) 
							ns.db.profile.others.foodCheck = not ns.db.profile.others.foodCheck
							ns:UpdateBuffCheckStatus()
						end,
						get =function(info)
							return ns.db.profile.others.foodCheck
						end,
					},
					--[==[
					raidBuffsCheck = {
						name = L["Проверять рейдовые баффы"], disabled = false,
						type = "toggle",
						order	= 6,
						set = function(info,val) 
							ns.db.profile.others.raidBuffsCheck = not ns.db.profile.others.raidBuffsCheck
							ns:UpdateBuffCheckStatus()
						end,
						get =function(info)
							return ns.db.profile.others.raidBuffsCheck
						end,
					},
					]==]
					overlay = {
						order = -1,name = L["Окно проверки"],type = "group", embend = true,
						args={	
							overlay = {
								name = L["Включить"], disabled = false,
								type = "toggle", width = 'full',
								order	= 1,
								set = function(info,val) 
									ns.db.profile.others.overlay = not ns.db.profile.others.overlay
									ns:UpdateBuffCheckOverlay()
								end,
								get =function(info)
									return ns.db.profile.others.overlay
								end,
							},
							
							horizontal_overlay = {
								name = L["Горизонтально"], disabled = false,
								type = "toggle",
								order	= 2,
								set = function(info,val) 
									ns.db.profile.others.horizontal_overlay = not ns.db.profile.others.horizontal_overlay
									ns:UpdateBuffCheckOverlay()
								end,
								get =function(info)
									return ns.db.profile.others.horizontal_overlay
								end,
							},

							unlock = {
								name = L["Передвинь меня!"], disabled = false,
								type = "execute",
								order	= 3,
								set = function(info,val) 
									ns:UnlockMover('BuffCheckFrames')
								end,
								get =function(info)
									return ns.db.profile.others.overlay
								end,
							},
							
							mainiconSize = {
								name = L['Размер настоя, руны и еды'], order = 4,
								min = 10, max = 60, step = 1, type = 'slider',
								set = function(info, value)
									ns.db.profile.others.overlay_mainIconSize = value
									ns:UpdateBuffCheckOverlay()
								end,
								get = function(info)
								
									return ns.db.profile.others.overlay_mainIconSize
								end,						
							},
							
							minoriconSize = {
								name = L['Размер рейдовых баффов'], order = 5,
								min = 10, max = 60, step = 1, type = 'slider',
								set = function(info, value)
									ns.db.profile.others.overlay_minorIconSize = value
									ns:UpdateBuffCheckOverlay()
								end,
								get = function(info)
								
									return ns.db.profile.others.overlay_minorIconSize
								end,						
							},
						},
					},
				},
			},
		},
	}
	
	if ns.db.profile.widgetType == 1 then
		SwitchToIconSettings()
	else
		SwitchToBarSettings()
	end
			
	return o
end


function ns:GetAnonseOptions()
	local o = {
		order = 9,name = L["Анонсы"],type = "group",
		args={},
	}
	
	o.args.tags  = {
		order = 1,
		width = "full",
		type = "string",
		name = L["Tags Desc"],
		set = function()
	
		end,
		get = function()
			return L["Tags Desc"]
		end,
	}
	
	for k,v in pairs(anonce_spells) do
	

		o.args["ordergroup"..k] ={
			order = k, name = GetSpellNameGUI(k) ,type = "group", embend = true,
			args={
			
			},
		}
		
		if k == 93985 then
			o.args["ordergroup"..k].args.enable = {
				name = L["Включить"],
				type = "toggle",
				order	= 1,
				set = function(info,val)
					ns.db.profile.anonse.spells[k].on = not ns.db.profile.anonse.spells[k].on				
				end,
				get =function(info)
					return ns.db.profile.anonse.spells[k].on
				end,
			}	
			o.args["ordergroup"..k].args.iffailed = {
				name = L["Сообщать всегда"], desc = L["Даже если заклинание не сбито"],
				type = "toggle",
				order	= 1.1,
				set = function(info,val)
					ns.db.profile.anonse.spells[k].iffailed = not ns.db.profile.anonse.spells[k].iffailed				
				end,
				get =function(info)
					return ns.db.profile.anonse.spells[k].iffailed
				end,
			}
		else
			o.args["ordergroup"..k].args.enable = {
				name = L["Включить"], width = "full",
				type = "toggle",
				order	= 1,
				set = function(info,val)
					ns.db.profile.anonse.spells[k].on = not ns.db.profile.anonse.spells[k].on				
				end,
				get =function(info)
					return ns.db.profile.anonse.spells[k].on
				end,
			}
		end
		o.args["ordergroup"..k].args.chat = {
			name = L["Чат"],
			type = "dropdown",
			order	= 2,
			values = {
				L["Авто"], 
				L['Группа'], 
				L['Рейд'], 
				L['Шепот'], 
				L['Крик'], 
				L['Сказать'],
				L['Подземелье'],
			},
			set = function(info,val)
				ns.db.profile.anonse.spells[k].chat = val			
			end,
			get =function(info)
				return ns.db.profile.anonse.spells[k].chat
			end,
		}
	
		o.args["ordergroup"..k].args.target = {
			name = L["Цель"], disabled = false, desc = L["Укажите цель шепона"],
			type = "editbox",
			order	= 3,
			set = function(info,val)
				ns.db.profile.anonse.spells[k].target = val
			end,
			get =function(info)
				return ns.db.profile.anonse.spells[k].target
			end,
		}
	
		o.args["ordergroup"..k].args.text = {
			name = L["Текст"], disabled = false, width = "full",
			type = "editbox",
			order	= 4,
			set = function(info,val)
				ns.db.profile.anonse.spells[k].text = val
			end,
			get =function(info)
				return ns.db.profile.anonse.spells[k].text
			end,
		}
	
	end

	return o
end


do
	local ns = AleaUI_GUI
	ns.customFeralDotDamageElementFrames = {}
	
	local function Update(self, panel, opts)
		
		self.free = false
		self:SetParent(panel)
		self:Show()	
		
		local name, rank, icon = GetSpellInfo(opts.spellID)
		
		self.main.icon.texture:SetTexture(icon)
		self.main.spellText:SetText(name)
		self.main._rname = name
		self.main.spellID = opts.spellID
		
		self.main.showbutton.text:SetText(opts.name)
		
		local c = RAID_CLASS_COLORS['DRUID'] or { r=0,g=0,b=0 }
		self.main.bg:SetColorTexture(c.r,c.g,c.b,0.2)
		
		self.main._OnClick = opts.set
		self.main._OnShow = opts.get
		
		self.main._OnClick1 = opts.set1
		self.main._OnShow1 = opts.get1
		
		
		self.main.showbutton:SetChecked(opts.get1())
		
		for i=1, #self.main._buttons do	
			self.main._buttons[i]:SetChecked(opts.get(opts.spellID, i))
		end
	end

	local function Remove(self)
		self.free = true
		self:Hide()
	end
	
	local function UpdateSize(self, panel, opts, parent)	
		if opts.width == 'full' then
			if parent then
				self:SetWidth( parent:GetWidth() - 5)
				self.main:SetWidth( parent:GetWidth() - 5)
			else
				self:SetWidth( panel:GetWidth() - 5)
				self.main:SetWidth( panel:GetWidth() - 5)
			end
		else
			self:SetWidth(180)
			self.main:SetWidth(160)
		end
	end
	
	local function CreateCoreButton(parent)
		local f = CreateFrame("Frame", nil, parent)
		f:SetSize(160, 22)
		f:SetFrameLevel(parent:GetFrameLevel() + 2)
		
		f.bg = f:CreateTexture(nil, 'ARTWORK')
		f.bg:SetAllPoints()
	
		f.icon = CreateFrame("Frame", nil, f)
		f.icon.f = f
		f.icon:SetSize(20, 20)
		f.icon:SetPoint('LEFT', f, 'LEFT', 2, 0)
		f.icon:SetScript("OnEnter", function(self)	
			ns.Tooltip(self, self.f._rname, self.f.desc, "show", "spell:"..self.f.spellID, string.match(self.f._rname,"|T(.-):"))
		end)
		f.icon:SetScript("OnLeave", function(self)
			ns.Tooltip(self, self.f._rname, self.f.desc, "hide")
		end)
		
		f.icon.texture = f.icon:CreateTexture(nil, 'ARTWORK')
		f.icon.texture:SetAllPoints()
		f.icon.texture:SetColorTexture(1, 0, 0, 1)
		
		f.spellText = f.icon:CreateFontString(nil, 'OVERLAY', "GameFontHighlight")
		f.spellText:SetPoint("LEFT", f.icon, "RIGHT", 2 , 0)
		f.spellText:SetWidth(160)
		f.spellText:SetText("TEST1 TEST1 TEST1 TEST1 TEST1 TEST1 TEST1TEST1 TEST1 TEST1 TEST1")
		f.spellText:SetTextColor(1, 1, 1)
		f.spellText:SetJustifyH("LEFT")
		f.spellText:SetWordWrap(true)
		
		f.showbutton = CreateFrame('CheckButton', nil, f, "UICheckButtonTemplate") --"UICheckButtonTemplate"
		f.showbutton:SetFrameLevel(f:GetFrameLevel() + 1)
		f.showbutton:SetPoint("LEFT", f, 'RIGHT', -200, 0)
		f.showbutton.f = f
		f.showbutton:SetSize(20, 20)
		f.showbutton:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		f.showbutton:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
		f.showbutton:SetScript("OnClick", function(self)
			self.f._OnClick1()
			self:SetChecked(self.f._OnShow1())		
			ns:GetRealParent(self):RefreshData()
		end)
		
		f.spellText:SetPoint("RIGHT", f.showbutton, "LEFT", -2 , 0)
		
		f.showbutton.text = f.showbutton:CreateFontString(nil, 'OVERLAY', "GameFontHighlight")
		f.showbutton.text:SetPoint("LEFT", f.showbutton, "RIGHT", 0 , 0)
		f.showbutton.text:SetText('Show')
		f.showbutton.text:SetTextColor(1, 1, 1)
		f.showbutton.text:SetJustifyH("LEFT")
		f.showbutton.text:SetWordWrap(false)
		
		f._buttons = {}
		
		for i=1, 5 do
		
			local button = CreateFrame('CheckButton', nil, f, "UICheckButtonTemplate") --"UICheckButtonTemplate"
			button:SetFrameLevel(f:GetFrameLevel() + 1)
			button:SetPoint("LEFT", f, 'RIGHT', ( -110 + 20*(i-1) ), -5)
			button.f = f
			button.id = i
			button:SetSize(20, 20)
			button:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
			button:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
			button:SetScript("OnClick", function(self)
				self.f._OnClick(self.f.spellID, self.id)
				self:SetChecked(self.f._OnShow(self.f.spellID, self.id))		
				ns:GetRealParent(self):RefreshData()
			end)
			
			local text = button:CreateFontString(nil, 'OVERLAY', "GameFontHighlight")
			text:SetPoint("BOTTOM", button, "TOP", 0 , 0)
			text:SetText(i)
			text:SetTextColor(1, 1, 1)
			text:SetJustifyH("LEFT")
			text:SetWordWrap(false)
			
			f._buttons[i] = button
		end
		
		return f
	end

	function ns:CreateFeralDotDamageSortElement()
		
		for i=1, #ns.customFeralDotDamageElementFrames do
			if ns.customFeralDotDamageElementFrames[i].free then
				return ns.customFeralDotDamageElementFrames[i]
			end
		end
		
		local f = CreateFrame("Frame", nil, UIParent)
		f:SetSize(180, 35)
		f.free = true
		
		f.main = CreateCoreButton(f)
		f.main:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -1)
		f.main:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -5, 1)
	
		f.Update = Update
		f.Remove = Remove
		f.UpdateSize = UpdateSize
		
		ns.customFeralDotDamageElementFrames[#ns.customFeralDotDamageElementFrames+1] = f
		
		return f
	end

	ns.prototypes["FeralDotDamageSortElement"] = "CreateFeralDotDamageSortElement"
end
