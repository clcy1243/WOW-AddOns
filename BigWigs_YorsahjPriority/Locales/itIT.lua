local L = BigWigs:NewBossLocale("Yor'sahj Priority", "itIT")
if not L then return end
if L then
	L.modname = "Priorità di Yor'sahj "

	L.blobs = "Globuli"
	L.blobs_desc = "Apre la configurazione delle priorità di Yor'Sahj /bwyp"

	L.blobs_message = "UCCIDERE >>%s<<"

	L.warn = "Avviso di Incursione"
	L.warn_desc = "Comunica ai giocatori quale Globulo devono uccidere con un Avviso di Incursione. È neccario essere Capo Incursione o Assitente di Incursione."

	L.update = "Priorita per i Globuli '%s' aggiornata a %s da %s."
	L.denied = "Devi essere Capo Incursione o Assistente per farlo!"
	L.allowed = "I giocatori dell'Incursione sono stati aggiornati."
	L.loaded = "Caricato. Per configurare scrivi /bwyp"
	L.button = "Grande Bottone Rosso"
	L.button_header = "Vuoi avvisare i compagni di Incursione con BigWigs Yor'Sahj priority? Devi aggiornare la lista delle Priorità? Sei Capo incursione o assistente? Allora il Bottone rosso fa per te!"
end

