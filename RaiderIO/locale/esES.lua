local _, ns = ...

if ns:IsSameLocale("esES") then
	local L = ns.L or ns:NewLocale()

	L.LOCALE_NAME = "esES"

L["ALLOW_IN_LFD"] = "Habilitar en el buscador de grupos"
L["ALLOW_IN_LFD_DESC"] = "Permite hacer clic derecho sobre grupos ya creados del buscador o jugadores que soliciten unirse a tu grupo para copiar la dirección de su perfil de Raider.IO."
L["ALLOW_ON_PLAYER_UNITS"] = "Habilitar en marcos de unidad de jugadores"
L["ALLOW_ON_PLAYER_UNITS_DESC"] = "Permite hacer clic derecho sobre los marcos de unidad de los jugadores para copiar la dirección de su perfil de Raider.IO."
L["ALWAYS_SHOW_EXTENDED_INFO"] = "Mostrar siempre puntuaciones de rol"
L["ALWAYS_SHOW_EXTENDED_INFO_DESC"] = "Puedes mantener pulsado Mayús, Control o Alt para mostrar las puntuaciones de rol de un jugador en la ventana emergente. Si activas esta opción, las ventanas emergentes incluirán siempre las puntuaciones de rol."
L["API_DEPRECATED"] = "|cffFF0000¡Atención!|r El addon |cffFFFFFF%s|r está solicitando una función obsoleta de RaiderIO.%s. Esta función será eliminada en la próxima versión. Por favor, avisa al autor de %s de que actualice su addon. Pila solicitada: %s."
L["API_DEPRECATED_UNKNOWN_ADDON"] = "<Addon desconocido>"
L["API_DEPRECATED_UNKNOWN_FILE"] = "<Archivo de addon desconocido>"
L["API_DEPRECATED_WITH"] = "|cffFF0000¡Atención!|r El addon |cffFFFFFF%s|r está solicitando una función obsoleta de RaiderIO.%s. Esta función será eliminada en la próxima versión. Por favor, avisa al autor de %s de que lo actualice a la nueva API de Raider.IO.%s. Pila solicitada: %s."
L["API_INVALID_DATABASE"] = "|cffFF0000¡Atención!|r Se ha detectado una base de datos inválida de RaiderIO en |cffffffff%s|r. Por favor, actualiza todas las regiones y facciones en el cliente de RaiderIO o reinstala manualmente el addon."
L["BEST_FOR_DUNGEON"] = "Mejor M+ en esta mazmorra"
L["BEST_RUN"] = "Mejor M+"
--[[Translation missing --]]
--[[ L["BEST_SCORE"] = ""--]] 
L["CHANGES_REQUIRES_UI_RELOAD"] = [=[Se han guardado los cambios, pero se necesita reiniciar la interfaz para que surtan efecto.

¿Quieres reiniciarla ahora?]=]
L["CHECKBOX_DISPLAY_WEEKLY"] = "Mostrar semanal"
--[[Translation missing --]]
--[[ L["CHOOSE_HEADLINE_HEADER"] = ""--]] 
L["CONFIG_SHOW_TOOLTIPS_HEADER"] = "Ventanas emergentes de M+ y bandas"
--[[Translation missing --]]
--[[ L["CONFIG_WHERE_TO_SHOW_TOOLTIPS"] = ""--]] 
L["COPY_RAIDERIO_PROFILE_URL"] = "Copiar dirección de Raider.IO"
L["COPY_RAIDERIO_URL"] = "Copiar dirección de Raider.IO"
--[[Translation missing --]]
--[[ L["CURRENT_MAINS_SCORE"] = ""--]] 
--[[Translation missing --]]
--[[ L["CURRENT_SCORE"] = ""--]] 
L["DPS"] = "DPS"
L["DPS_SCORE"] = "Puntuación de DPS"
L["DUNGEON_SHORT_NAME_AD"] = "Atal'Dazar"
L["DUNGEON_SHORT_NAME_ARC"] = "Arquería"
L["DUNGEON_SHORT_NAME_BRH"] = "Torreón"
L["DUNGEON_SHORT_NAME_COEN"] = "Catedral"
L["DUNGEON_SHORT_NAME_COS"] = "Corte"
L["DUNGEON_SHORT_NAME_DHT"] = "Arboleda"
L["DUNGEON_SHORT_NAME_EOA"] = "Ojo"
L["DUNGEON_SHORT_NAME_FH"] = "Fuerte Libre"
L["DUNGEON_SHORT_NAME_HOV"] = "Valor"
L["DUNGEON_SHORT_NAME_KR"] = "Reposo"
L["DUNGEON_SHORT_NAME_LOWR"] = "Kara-I"
L["DUNGEON_SHORT_NAME_ML"] = "Veta Madre"
L["DUNGEON_SHORT_NAME_MOS"] = "Fauce"
L["DUNGEON_SHORT_NAME_NL"] = "Guarida"
L["DUNGEON_SHORT_NAME_SEAT"] = "Trono"
L["DUNGEON_SHORT_NAME_SIEGE"] = "Asedio"
L["DUNGEON_SHORT_NAME_SOTS"] = "Altar"
L["DUNGEON_SHORT_NAME_TD"] = "Tol Dagor"
L["DUNGEON_SHORT_NAME_TM"] = "Veta Madre"
L["DUNGEON_SHORT_NAME_TOS"] = "Templo"
L["DUNGEON_SHORT_NAME_UNDR"] = "Catacumbas"
L["DUNGEON_SHORT_NAME_UPPR"] = "Kara-S"
L["DUNGEON_SHORT_NAME_VOTW"] = "Celadoras"
L["DUNGEON_SHORT_NAME_WM"] = "Mansión"
L["ENABLE_AUTO_FRAME_POSITION"] = "Posicionar automáticamente el marco de perfil de RaiderIO"
L["ENABLE_AUTO_FRAME_POSITION_DESC"] = "Fija la ventana emergente de perfil de M+ junto al marco del buscador de grupos o la ventana emergente de jugador."
L["ENABLE_LOCK_PROFILE_FRAME"] = "Bloquear el marco de perfil de RaiderIO"
L["ENABLE_LOCK_PROFILE_FRAME_DESC"] = "Evita que se pueda desplazar el marco de perfil de M+. No tiene efecto si el marco de perfil de M+ está configurado para posicionarse automáticamente."
L["ENABLE_NO_SCORE_COLORS"] = "Desactivar colores de puntuación"
L["ENABLE_NO_SCORE_COLORS_DESC"] = "Desactiva los colores de las puntuaciones. Todas las puntuaciones se mostrarán de color blanco."
L["ENABLE_RAIDERIO_CLIENT_ENHANCEMENTS"] = "Habilitar mejoras del cliente de RaiderIO"
L["ENABLE_RAIDERIO_CLIENT_ENHANCEMENTS_DESC"] = "Permite ver información detallada del cliente de RaiderIO de tus personajes confirmados."
L["ENABLE_SIMPLE_SCORE_COLORS"] = "Usar colores de puntuación simples"
L["ENABLE_SIMPLE_SCORE_COLORS_DESC"] = "Muestra las puntuaciones usando solo los colores estándar de calidad de objeto. Facilita la distinción de puntuaciones para personas con defectos de visión cromática."
L["EXPORTJSON_COPY_TEXT"] = "Copia este texto y pégalo en |cff00C8FFhttps://raider.io|r para ver información de todos los jugadores."
--[[Translation missing --]]
--[[ L["GENERAL_TOOLTIP_OPTIONS"] = ""--]] 
L["GUILD_BEST_SEASON"] = "Hermandad: mejor de la temporada"
L["GUILD_BEST_TITLE"] = "Récords de hermandad"
L["GUILD_BEST_WEEKLY"] = "Mejores de la semana"
L["HEALER"] = "Sanador"
L["HEALER_SCORE"] = "Puntuación de sanador"
L["HIDE_OWN_PROFILE"] = "Ocultar ventana emergente de perfil personal de RaiderIO"
L["HIDE_OWN_PROFILE_DESC"] = "Oculta la ventana emergente de tu perfil personal de RaiderIO. No afecta a las ventanas emergentes de otros jugadores."
L["INVERSE_PROFILE_MODIFIER"] = "Invertir modificador de marco de perfil"
L["INVERSE_PROFILE_MODIFIER_DESC"] = "Invierte el comportamiento del modificador del marco de perfil (mayús/ctrl/alt) para que muestre por defecto el perfil del líder del grupo."
L["KEYSTONE_COMPLETED_10"] = "+10-14 (en tiempo)"
L["KEYSTONE_COMPLETED_15"] = "+15 (en tiempo)"
L["KEYSTONE_COMPLETED_5"] = "+5-9 (en tiempo)"
L["LEGION_MAIN_SCORE"] = "Puntuación de personaje principal en Legion"
L["LEGION_SCORE"] = "Puntuación en Legion"
L["LOCKING_PROFILE_FRAME"] = "RaiderIO: bloqueando el marco de perfil de M+."
--[[Translation missing --]]
--[[ L["MAINS_BEST_SCORE_BEST_SEASON"] = ""--]] 
L["MAINS_RAID_PROGRESS"] = "Progreso de personaje principal"
L["MAINS_SCORE"] = "Puntuación de personaje principal"
L["MAINS_SCORE_COLON"] = "Puntuación de personaje principal:"
L["MODULE_AMERICAS"] = "América"
L["MODULE_EUROPE"] = "Europa"
L["MODULE_KOREA"] = "Corea"
L["MODULE_TAIWAN"] = "Taiwan"
L["MY_PROFILE_TITLE"] = "Perfil personal de M+"
L["MYTHIC_PLUS_DB_MODULES"] = "Módulos de la base de datos"
L["MYTHIC_PLUS_SCORES"] = "Puntuaciones de M+"
L["NO_GUILD_RECORD"] = "No hay récords de hermandad"
L["OPEN_CONFIG"] = "Abrir configuración"
L["OUT_OF_SYNC_DATABASE_S"] = "|cffFFFFFF%s|r tiene datos de facción sin sincronizar. Por favor, actualiza tu configuración del cliente de RaiderIO para sincronizar ambas facciones."
L["OUTDATED_DATABASE"] = "Estas puntuaciones son de hace %d día(s)"
L["OUTDATED_DATABASE_HOURS"] = "Estas puntuaciones son de hace %d hora(s)"
L["OUTDATED_DATABASE_S"] = "|cffFFFFFF%s|r está usando datos de hace |cffFF6666%d|r día(s). Por favor, actualiza el addon para disponer de las puntuaciones de M+ más recientes."
L["PLAYER_PROFILE_TITLE"] = "Perfil de M+"
L["PREV_SEASON_SUFFIX"] = "(*)"
--[[Translation missing --]]
--[[ L["PREVIOUS_SCORE"] = ""--]] 
L["PROFILE_BEST_RUNS"] = "Mejor de cada mazmorra"
--[[Translation missing --]]
--[[ L["PROVIDER_NOT_LOADED"] = ""--]] 
L["RAID_ABBREVIATION_ULD"] = "Uldir"
L["RAID_BOSS_ABT_1"] = "Rompemundos"
L["RAID_BOSS_ABT_10"] = "Aggramar"
L["RAID_BOSS_ABT_11"] = "Argus"
L["RAID_BOSS_ABT_2"] = "Canes"
L["RAID_BOSS_ABT_3"] = "Hasabel"
L["RAID_BOSS_ABT_4"] = "Alto Mando"
L["RAID_BOSS_ABT_5"] = "Eonar"
L["RAID_BOSS_ABT_6"] = "Imonar"
L["RAID_BOSS_ABT_7"] = "Kin'garoth"
L["RAID_BOSS_ABT_8"] = "Varimathras"
L["RAID_BOSS_ABT_9"] = "Aquelarre"
L["RAID_BOSS_BOD_1"] = "Campeona de la Luz"
L["RAID_BOSS_BOD_2"] = "Grong"
L["RAID_BOSS_BOD_3"] = "Maestros Fuego de Jade"
L["RAID_BOSS_BOD_4"] = "Opulencia"
L["RAID_BOSS_BOD_5"] = "Cónclave de los Elegidos"
L["RAID_BOSS_BOD_6"] = "Rey Rastakhan"
L["RAID_BOSS_BOD_7"] = "Manitas mayor Mekkatorque"
L["RAID_BOSS_BOD_8"] = "Bloqueo de la tormenta"
L["RAID_BOSS_BOD_9"] = "Lady Jaina Valiente"
L["RAID_BOSS_ULD_1"] = "Taloc"
L["RAID_BOSS_ULD_2"] = "MADRE"
L["RAID_BOSS_ULD_3"] = "Devorador fétido"
L["RAID_BOSS_ULD_4"] = "Zek'voz"
L["RAID_BOSS_ULD_5"] = "Vectis"
L["RAID_BOSS_ULD_6"] = "Zul el Renacido"
L["RAID_BOSS_ULD_7"] = "Mythrax"
L["RAID_BOSS_ULD_8"] = "G'huun"
L["RAID_DIFFICULTY_NAME_HEROIC"] = "Heroico"
L["RAID_DIFFICULTY_NAME_MYTHIC"] = "Mítico"
L["RAID_DIFFICULTY_NAME_NORMAL"] = "Normal"
L["RAID_DIFFICULTY_SUFFIX_HEROIC"] = "H"
L["RAID_DIFFICULTY_SUFFIX_MYTHIC"] = "M"
L["RAID_DIFFICULTY_SUFFIX_NORMAL"] = "N"
L["RAID_ENCOUNTERS_DEFEATED_TITLE"] = "Encuentros de banda derrotados"
L["RAID_PROGRESS_TITLE"] = "Progreso de banda"
L["RAIDERIO_AVERAGE_PLAYER_SCORE"] = "Puntuación media de +%s en tiempo"
--[[Translation missing --]]
--[[ L["RAIDERIO_BEST_RUN"] = ""--]] 
L["RAIDERIO_CLIENT_CUSTOMIZATION"] = "Personalización del cliente de RaiderIO"
L["RAIDERIO_MP_BASE_SCORE"] = "Puntuación de M+ base"
--[[Translation missing --]]
--[[ L["RAIDERIO_MP_BEST_SCORE"] = ""--]] 
L["RAIDERIO_MP_SCORE"] = "Puntuación de M+"
L["RAIDERIO_MP_SCORE_COLON"] = "Puntuación de M+:"
L["RAIDERIO_MYTHIC_OPTIONS"] = "Opciones de Raider.IO Mythic Plus"
L["RAIDING_DATA_HEADER"] = "Progreso de banda de Raider.IO"
L["RAIDING_DB_MODULES"] = "Módulos de la base de datos de bandas"
L["RELOAD_LATER"] = "La reiniciaré más tarde"
L["RELOAD_NOW"] = "Reiniciarla ahora"
--[[Translation missing --]]
--[[ L["SEASON_LABEL_1"] = ""--]] 
--[[Translation missing --]]
--[[ L["SEASON_LABEL_2"] = ""--]] 
L["SHOW_AVERAGE_PLAYER_SCORE_INFO"] = "Mostrar puntuación media de M+ en tiempo"
L["SHOW_AVERAGE_PLAYER_SCORE_INFO_DESC"] = "Muestra la puntuación media de M+ en tiempo de los miembros de un grupo. Aparece en las descripciones emergentes de piedras angulares y jugadores en el buscador de grupos."
--[[Translation missing --]]
--[[ L["SHOW_BEST_MAINS_SCORE"] = ""--]] 
--[[Translation missing --]]
--[[ L["SHOW_BEST_MAINS_SCORE_DESC"] = ""--]] 
--[[Translation missing --]]
--[[ L["SHOW_BEST_RUN"] = ""--]] 
--[[Translation missing --]]
--[[ L["SHOW_BEST_RUN_DESC"] = ""--]] 
--[[Translation missing --]]
--[[ L["SHOW_BEST_SEASON"] = ""--]] 
--[[Translation missing --]]
--[[ L["SHOW_BEST_SEASON_DESC"] = ""--]] 
L["SHOW_CLIENT_GUILD_BEST"] = "Mostrar mejores puntuaciones de mazmorra en el buscador de grupos"
L["SHOW_CLIENT_GUILD_BEST_DESC"] = "Muestra las cinco mejores puntuaciones de tu hermandad (tanto de temporada como semanales) en la pestaña 'Piedra angular mítica' de la ventana del buscador de grupos."
--[[Translation missing --]]
--[[ L["SHOW_CURRENT_SEASON"] = ""--]] 
--[[Translation missing --]]
--[[ L["SHOW_CURRENT_SEASON_DESC"] = ""--]] 
L["SHOW_IN_FRIENDS"] = "Mostrar en la lista de amigos"
L["SHOW_IN_FRIENDS_DESC"] = "Muestra la puntuación de M+ de tus amigos cuando pasas el ratón por encima."
L["SHOW_IN_LFD"] = "Mostrar en el buscador de grupos"
L["SHOW_IN_LFD_DESC"] = "Muestra la puntuación de M+ cuando pasas el ratón por encima de grupos ya creados del buscador o jugadores que soliciten unirse a tu grupo."
L["SHOW_IN_SLASH_WHO_RESULTS"] = "Mostrar en resultados de /who"
L["SHOW_IN_SLASH_WHO_RESULTS_DESC"] = "Muestra la puntuación de M+ cuando usas \"/who\" con un jugador específico."
L["SHOW_IN_WHO_UI"] = "Mostrar en la interfaz de ¿Quién?"
L["SHOW_IN_WHO_UI_DESC"] = "Muestra la puntuación de M+ cuando pasas el ratón por encima de los resultados de la ventana ¿Quién?"
L["SHOW_KEYSTONE_INFO"] = "Mostrar información de piedras angulares"
L["SHOW_KEYSTONE_INFO_DESC"] = "Muestra la puntuación base de cada piedra angular en su descripción emergente. También muestra la mejor M+ de esa mazmorra de cada jugador en tu grupo."
L["SHOW_LEADER_PROFILE"] = "Habilitar modificador del marco de perfil"
L["SHOW_LEADER_PROFILE_DESC"] = "Permite mantener pulsado un modificador (mayús/ctrl/alt) para alternar el marco de perfil entre el personal y el del líder del grupo."
L["SHOW_MAINS_SCORE"] = "Mostrar puntuación de personaje principal"
L["SHOW_MAINS_SCORE_DESC"] = "Muestra la puntuación en la temporada actual del personaje principal del jugador inspeccionado. El jugador en cuestión debe estar registrado en Raider.IO y haber seleccionado su personaje principal."
L["SHOW_ON_GUILD_ROSTER"] = "Mostrar en lista de hermandad"
L["SHOW_ON_GUILD_ROSTER_DESC"] = "Muestra la puntuación de M+ de los miembros de tu hermandad cuando pasas el ratón por encima de ellos en la lista de hermandad."
L["SHOW_ON_PLAYER_UNITS"] = "Mostrar en marcos de jugador"
L["SHOW_ON_PLAYER_UNITS_DESC"] = "Muestra la puntuación de M+ de los jugadores en su ventana emergente cuando pasas el ratón sobre ellos."
L["SHOW_RAID_ENCOUNTERS_IN_PROFILE"] = "Mostrar encuentros de banda en la ventana emergente de perfil"
L["SHOW_RAID_ENCOUNTERS_IN_PROFILE_DESC"] = "Muestra el progreso de banda en la ventana emergente de perfil de RaiderIO."
--[[Translation missing --]]
--[[ L["SHOW_RAIDERIO_BESTRUN_FIRST"] = ""--]] 
--[[Translation missing --]]
--[[ L["SHOW_RAIDERIO_BESTRUN_FIRST_DESC"] = ""--]] 
L["SHOW_RAIDERIO_PROFILE"] = "Mostrar marco de perfil en el buscador de grupos"
L["SHOW_RAIDERIO_PROFILE_DESC"] = "Muestra el marco de perfil de Raider.IO en el buscador de grupos."
--[[Translation missing --]]
--[[ L["SHOW_ROLE_ICONS"] = ""--]] 
--[[Translation missing --]]
--[[ L["SHOW_ROLE_ICONS_DESC"] = ""--]] 
L["SHOW_SCORE_IN_COMBAT"] = "Mostrar puntuación en combate"
L["SHOW_SCORE_IN_COMBAT_DESC"] = "Desactiva esta opción para mejorar el rendimiento al pasar el ratón por encima de jugadores cuando estás en combate."
L["TANK"] = "Tanque"
L["TANK_SCORE"] = "Puntuación de tanque"
L["TIMED_10_RUNS"] = "+10-14 en tiempo"
L["TIMED_15_RUNS"] = "+15 en tiempo"
--[[Translation missing --]]
--[[ L["TIMED_20_RUNS"] = ""--]] 
L["TIMED_5_RUNS"] = "+5-9 en tiempo"
L["TOOLTIP_CUSTOMIZATION"] = "Personalización de ventanas emergentes"
L["TOOLTIP_PROFILE"] = "Personalización del marco de perfil"
L["TOTAL_MP_SCORE"] = "Puntuación de M+"
L["TOTAL_RUNS"] = "Total en BfA"
L["UNKNOWN_SCORE"] = "Desconocida"
L["UNKNOWN_SERVER_FOUND"] = "|cffFFFFFF%s|r ha encontrado un nuevo servidor. Por favor, apunta esta información |cffFF9999{|r |cffFFFFFF%s|r |cffFF9999,|r |cffFFFFFF%s|r |cffFF9999}|r y envíasela a los desarrolladores. ¡Gracias!"
L["UNLOCKING_PROFILE_FRAME"] = "RaiderIO: desbloqueando el marco de perfil de M+."
L["WARNING_LOCK_POSITION_FRAME_AUTO"] = "RaiderIO: primero debes deshabilitar el posicionamiento automático del marco de perfil de RaiderIO."


	ns.L = L
end
