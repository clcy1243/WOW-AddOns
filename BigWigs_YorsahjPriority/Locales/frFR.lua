local L = BigWigs:NewBossLocale("Yor'sahj Priority", "frFR")
if not L then return end
if L then
	L.modname = "Priorité Yor'sahj"

	L.blobs = "Globules"
	L.blobs_desc = "Ouvrez la fenêtre de config. principal pour plus d'options : /bwyp"
	L.blobs_message = "TUEZ >>%s<<"

	L.warn = "Alerte raid"
	L.warn_desc = "Indiquer à votre raid quel globule tuer avec un Avertissement raid (chef ou assistant de raid uniquement)."

	L.update = "Priorité pour les globules '%s' mis à jour à %s par %s."
	L.denied = "Vous devez être chef ou assistant de raid pour faire cela !"
	L.allowed = "Les membres du raid ont été mis à jour."
	L.loaded = "Chargé. Pour configurer, tapez /bwyp"
	L.button = "Gros bouton rouge"
	L.button_header = "Des compagnons de raid utilisent aussi Priorité Yor'sahj pour BigWigs ? Il est nécessaire de les mettre à jour avec la toute dernière liste des priorités ? Vous êtes chef ou assistant du raid ? Alors le gros bouton rouge est pour vous !"
end

