local L = BigWigs:NewBossLocale("Yor'sahj Priority", "esMX")
if not L then return end
if L then
	L.modname = "Yor'sahj Prioridades"

	L.blobs = "Mocos"
	L.blobs_desc = "Abrir la configuración principal para más opciones /bwyp"

	L.blobs_message = "MATAR >>%s<<"

	L.warn = "Aviso de raid"
	L.warn_desc = "Decir a la raid cual moco matar con un aviso de raid, requiere Lider de banda o ayudante."

	L.update = "Prioridad para mocos '%s' actualizado a %s por %s."
	L.denied = "¡Debes ser Lider de banda o ayudante para hacer eso!"
	L.allowed = "Los miembros de la raid han sido actualizados."
	L.loaded = "Cargado. Para configurar teclea /bwyp"
	L.button = "El Gran Botón Rojo"
	L.button_header = "¿Compañeros miembros de raid usan BigWigs Yor'sahj Prioridades? ¿Necesitas actualizarlo con la última lista de prioridades? ¿Eres Lider de banda o ayudante? ¡Entonces El Gran Botón Rojo es para ti!"
end

