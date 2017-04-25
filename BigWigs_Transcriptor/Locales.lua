-- update at http://www.wowace.com/addons/bigwigs_transcriptor/localization/

local _, ns = ...
local L = ns.L

local locale = GetLocale()
if locale == "ptBR" then

elseif locale == "frFR" then
L["Automatically delete logs shorter than 30 seconds."] = "Efface automatiquement les journaux de moins de 30 secondes." -- Needs review
L["Automatically start Transcriptor logging when you pull a boss and stop when you win or wipe."] = "Lance un enregistrement Transcriptor quand vous engagez un boss et l'arrête quand vous gagnez ou wipez, le tout automatiquement."
L["|cff20ff20Win!|r"] = "|cff20ff20Victoire !|r"
L["Clear All"] = "Tout effacer" -- Needs review
L["Delete short logs"] = "Effacer les journaux courts" -- Needs review
L["%d stored events over %.01f seconds. %s"] = "%d évènements enregistrés durant %.01f secondes. %s"
L["Ignored Events"] = "Évènements ignorés"
L["Log deleted."] = "Journal supprimé." -- Needs review
L["No logs recorded"] = "Aucun combat enregistré"
L["Start Transcriptor logging from a pull timer at two seconds remaining."] = "Lance la journalisation de Transcriptor quand il ne reste plus que deux secondes à un délai de pull."
L["Start with pull timer"] = "Lancer avec les délais de pull"
L["Stored logs (%s) - Click to delete"] = "Combats enregistrés (%s) - cliquez pour supprimer"
L["Transcriptor"] = "Transcriptor"
L["Transcriptor is currently using %.01f MB of memory. You should clear some logs or risk losing them."] = "Transcriptor utilise actuellement %.01f Mo de mémoire. Vous devriez effacer certains journaux ou vous risquez de tous les perdre."
L["Your Transcriptor DB has been reset! You can still view the contents of the DB in your SavedVariables folder until you exit the game or reload your UI."] = "La base de données de votre Transcriptor a été réinitialisée ! Vous pouvez toujours voir le contenu de la base de données dans votre répertoire SavedVariables tant que vous n'avez pas quitté le jeu ou rechargé votre interface."

elseif locale == "deDE" then
L["Automatically delete logs shorter than 30 seconds."] = "Löscht automatisch Logs, die kürzer sind als 30 Sekunden."
L["Automatically start Transcriptor logging when you pull a boss and stop when you win or wipe."] = "Die Transcriptor-Aufzeichnung wird automatisch gestartet, wenn ein Boss gepullt wird und stoppt, wenn ihr gewinnt oder sterbt. "
L["|cff20ff20Win!|r"] = "|cff20ff20Gewonnen!|r"
L["Clear All"] = "Alle löschen"
L["Delete short logs"] = "Kurze Logs löschen"
L["%d stored events over %.01f seconds. %s"] = "%d hat Ereignisse über %.01f Sekunden gespeichert. %s"
L["Ignored Events"] = "Ignorierte Ereignisse"
L["Include some spell stats and the time between casts in the log tooltip when available."] = "Fügt dem Log-Tooltip einige Zauberstatistiken und die Zeit zwischen Zaubern, falls verfügbar, hinzu."
L["Log deleted."] = "Log gelöscht."
L["No logs recorded"] = "Keine Logs aufgezeichnet"
L["Show spell cast details"] = "Zauberdetails anzeigen"
L["Start Transcriptor logging from a pull timer at two seconds remaining."] = "Die Transcriptor-Aufzeichnung beginnt bei einem Pull-Timer, mit verbleibenden 2 Sekunden."
L["Start with pull timer"] = "Bei Pull-Timer starten"
L["Stored logs (%s) - Click to delete"] = "Gespeicherte Logs (%s) - Klicken, um zu löschen"
L["Transcriptor"] = "Transcriptor"
L["Transcriptor is currently using %.01f MB of memory. You should clear some logs or risk losing them."] = "Transcriptor nutzt aktuell %.01f MB Speicher. Du solltest einige Logs löschen oder du riskierst, sie zu verlieren."
L["Your Transcriptor DB has been reset! You can still view the contents of the DB in your SavedVariables folder until you exit the game or reload your UI."] = "Deine Transcriptor-Datenbank wurde zurückgesetzt! Du kannst den Inhalt der Datenbank in deinem SavedVariables-Ordner, noch so lange sehen, bis du das Spiel beendest oder dein UI neu lädst"

elseif locale == "itIT" then

elseif locale == "koKR" then

elseif locale == "esMX" then

elseif locale == "ruRU" then

elseif locale == "zhCN" then
L["Automatically delete logs shorter than 30 seconds."] = "自动删除少于30秒的记录。"
L["Automatically start Transcriptor logging when you pull a boss and stop when you win or wipe."] = "当你攻击一个首领胜利或灭团时自动开始和停止 Transcriptor 记录。"
L["|cff20ff20Win!|r"] = "|cff20ff20获胜！|r"
L["Clear All"] = "清除全部"
L["Delete short logs"] = "删除短记录"
L["%d stored events over %.01f seconds. %s"] = "%d 已储存的事件超过%.01f秒。%s"
L["Ignored Events"] = "忽略事件"
L["Include some spell stats and the time between casts in the log tooltip when available."] = "包含一些法术统计和当在记录提示施放之间的时间。"
L["Log deleted."] = "记录已删除。"
L["No logs recorded"] = "无记录录入"
L["Show spell cast details"] = "显示法术施放细节"
L["Start Transcriptor logging from a pull timer at two seconds remaining."] = "拉怪计时器剩余2秒时开启 Transcriptor 记录。"
L["Start with pull timer"] = "跟随开怪计时器启用"
L["Stored logs (%s) - Click to delete"] = "短记录（%s）- 点击删除"
L["Transcriptor"] = "Transcriptor 记录器"
L["Transcriptor is currently using %.01f MB of memory. You should clear some logs or risk losing them."] = "Transcriptor 当前存储使用 %.01f MB。应清除一些记录否则会丢失。"
L["Your Transcriptor DB has been reset! You can still view the contents of the DB in your SavedVariables folder until you exit the game or reload your UI."] = "你的 Transcriptor 数据库已被重置！你仍然可以在你的 SavedVariables文件夹查看中数据库的内容，直到你退出游戏或重新加载用户界面。"

elseif locale == "esES" then
L["Automatically start Transcriptor logging when you pull a boss and stop when you win or wipe."] = "Transcriptor automáticamente empezará a grabar cuando pulees un jefe y parará cuando lo derrotes o wipees."
L["|cff20ff20Win!|r"] = "|cff20ff20¡Victoria!|r"
L["%d stored events over %.01f seconds. %s"] = "%d eventos almacenados durante %.01f segundos. %s"
L["Ignored Events"] = "Eventos ingorados"
L["No logs recorded"] = "No hay logs registrados"
L["Stored logs (%s) - Click to delete"] = "Logs almacenados (%s) - Click para borrar"
L["Transcriptor"] = "Transcriptor"
L["Your Transcriptor DB has been reset! You can still view the contents of the DB in your SavedVariables folder until you exit the game or reload your UI."] = "¡Tu base de dados ha sido reiniciada! Aún puedes ver el contenido de la base de datos en tu carpeta SavedVariables hasta que salgas del juego o recargues tu interfaz."

elseif locale == "zhTW" then
L["Automatically start Transcriptor logging when you pull a boss and stop when you win or wipe."] = "當你攻擊一個首領勝利或滅團時自動開始和停止 Transcriptor 記錄."
L["|cff20ff20Win!|r"] = "|cff20ff20獲勝!|r"
L["%d stored events over %.01f seconds. %s"] = "%d 已儲存的事件超過%.01f秒. %s"
L["Ignored Events"] = "忽略事件"
L["No logs recorded"] = "無日誌記錄"
L["Stored logs (%s) - Click to delete"] = "儲存的日誌(%s) - 點擊刪除" -- Needs review
L["Transcriptor"] = "Transcriptor 記錄器"
L["Your Transcriptor DB has been reset! You can still view the contents of the DB in your SavedVariables folder until you exit the game or reload your UI."] = "你的 Transcriptor 資料庫已被重設! 你仍然可以在你的SavedVariables資料夾查看中資料庫的內容,直到你退出遊戲或重新載入你的UI."

end
