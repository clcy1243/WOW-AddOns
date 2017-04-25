local L = BigWigs:NewBossLocale("Yor'sahj Priority", "zhTW")
if not L then return end
if L then
	L.modname = "尤沙吉血珠優先"

	L.blobs = "血珠"
	L.blobs_desc = "使用 /bwyp打開設定"
	L.blobs_message = "擊殺 >>%s<<"

	L.warn = "團隊警告"
	L.warn_desc = "通知團隊需要擊殺哪個血珠"

	L.update = "血珠優先級 '%s' 已經更新為 %s 由 %s更新."
	L.denied = "你必須是團隊領袖或者助理!"
	L.allowed = "團隊成員已經被更新."
	L.loaded = "使用 /bwyp打開設定"
	L.button = "大紅按鈕"
	L.button_header = "各位團隊成員正在使用Bwyp嗎?需要告訴他們優先順序嗎?你要成爲成功的團隊領袖或者助理嗎? 大紅按鈕將是你的首選!"
end

