
local L = BigWigs:NewBossLocale("Al'Akir", "zhTW")
if not L then return end
if L then
	L.stormling = "小風暴"
	L.stormling_desc = "當召喚小風暴時發出警報。"

	L.acid_rain = "酸雨：>%d<！"

	L.feedback_message = "%dx 回饋！"
end

L = BigWigs:NewBossLocale("Conclave of Wind", "zhTW")
if L then
	L.gather_strength = "%s正在聚集力量！"

	L["93059_desc"] = "當風暴之盾吸收傷害時發出警報。"

	L.full_power = "滿能量"
	L.full_power_desc = "當首領獲得滿能量並開始施放特殊技能時發出警報。"
	L.gather_strength_emote = "%s開始從剩下的風之王那裡取得力量!"
end

