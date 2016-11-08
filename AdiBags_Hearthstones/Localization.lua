--[[
AdiBags_Hearths - Adds various hearthing items to AdiBags virtual groups
© 2016 Paul "Myrroddin" Vandersypen, All Rights Reserved
]]--

local addonName, addon = ...

local L = setmetatable({}, {
	__index = function(self, key)
		if key then
			rawset(self, key, tostring(key))
		end
		return tostring(key)
	end,
})
addon.L = L

local locale = GetLocale()

if locale == "ruRU" then
-- L["Flight Master's Whistle"] = ""
-- L["FMW isn't a Hearthstone, but helps you get around faster."] = ""
-- L["Items that hearth you to various places."] = ""
-- L["Jewelry"] = ""
-- L["Show items like Innkeeper's Daughter in this group."] = ""
-- L["Show items like Ruby Slippers in this group."] = ""
-- L["Show items like the Kirin Tor rings in this group."] = ""
-- L["Show quest items that portal in this group."] = ""
-- L["ToC/Notes"] = ""


elseif locale == "deDE" then
L["Flight Master's Whistle"] = "Pfeife des Flugmeisters"
L["FMW isn't a Hearthstone, but helps you get around faster."] = "Pfeife des Flugmeisters ist kein Ruhestein, aber er hilft dabei, schneller ans Ziel zu kommen."
L["Items that hearth you to various places."] = "Teleportationsgegenstände"
L["Jewelry"] = "Juwelier"
L["Show items like Innkeeper's Daughter in this group."] = "Spielzeuge"
L["Show items like Ruby Slippers in this group."] = "Rüstung"
L["Show items like the Kirin Tor rings in this group."] = "Ringe"
L["Show quest items that portal in this group."] = "Quest Port"
L["ToC/Notes"] = "Fügt mehrere Ruhestein ähnliche items zu Adibags Gruppen hinzu."


elseif locale == "itIT" then
-- L["Flight Master's Whistle"] = ""
-- L["FMW isn't a Hearthstone, but helps you get around faster."] = ""
-- L["Items that hearth you to various places."] = ""
-- L["Jewelry"] = ""
-- L["Show items like Innkeeper's Daughter in this group."] = ""
-- L["Show items like Ruby Slippers in this group."] = ""
-- L["Show items like the Kirin Tor rings in this group."] = ""
-- L["Show quest items that portal in this group."] = ""
-- L["ToC/Notes"] = ""


elseif locale == "frFR" then
-- L["Flight Master's Whistle"] = ""
-- L["FMW isn't a Hearthstone, but helps you get around faster."] = ""
L["Items that hearth you to various places."] = "Objets qui vous téléportent à divers endroits." -- Needs review
L["Jewelry"] = "Bijoux" -- Needs review
L["Show items like Innkeeper's Daughter in this group."] = "Montrer les objets du type La fille de l'aubergiste dans ce groupe."
L["Show items like Ruby Slippers in this group."] = "Montrer les objets du type Souliers de rubis dans ce groupe." -- Needs review
L["Show items like the Kirin Tor rings in this group."] = "Montrer les objets du type Anneau du Kirin Tor dans ce groupe." -- Needs review
L["Show quest items that portal in this group."] = "Montrer les objets de quête de type portail dans ce groupe." -- Needs review
L["ToC/Notes"] = "Ajoute différents objets de type Pierre de foyer aux groupes virtuels d'AdiBags" -- Needs review


elseif locale == "koKR" then
-- L["Flight Master's Whistle"] = ""
L["FMW isn't a Hearthstone, but helps you get around faster."] = "FMW는 귀환석이 아니지만, 빠르게 돌아다닐 수 있게 도와줍니다."
L["Items that hearth you to various places."] = "여러 위치로 순간 이동하는 아이템입니다."
L["Jewelry"] = "장신구"
L["Show items like Innkeeper's Daughter in this group."] = "여관주인의 딸 같은 아이템을 이 그룹에 표시합니다."
L["Show items like Ruby Slippers in this group."] = "루비 끌신 같은 아이템을 이 그룹에 표시합니다."
L["Show items like the Kirin Tor rings in this group."] = "키린 토 반지 같은 아이템을 이 그룹에 표시합니다."
L["Show quest items that portal in this group."] = "포탈 퀘스트 아이템을 이 그룹에 표시합니다."
L["ToC/Notes"] = "여러 순간이동 아이템을 AdiBags 가상 그룹에 추가합니다"


elseif locale == "zhCN" then
-- L["Flight Master's Whistle"] = ""
-- L["FMW isn't a Hearthstone, but helps you get around faster."] = ""
-- L["Items that hearth you to various places."] = ""
-- L["Jewelry"] = ""
-- L["Show items like Innkeeper's Daughter in this group."] = ""
-- L["Show items like Ruby Slippers in this group."] = ""
-- L["Show items like the Kirin Tor rings in this group."] = ""
-- L["Show quest items that portal in this group."] = ""
-- L["ToC/Notes"] = ""


elseif locale == "ptBR" then
-- L["Flight Master's Whistle"] = ""
-- L["FMW isn't a Hearthstone, but helps you get around faster."] = ""
-- L["Items that hearth you to various places."] = ""
-- L["Jewelry"] = ""
-- L["Show items like Innkeeper's Daughter in this group."] = ""
-- L["Show items like Ruby Slippers in this group."] = ""
-- L["Show items like the Kirin Tor rings in this group."] = ""
-- L["Show quest items that portal in this group."] = ""
-- L["ToC/Notes"] = ""


elseif locale == "zhTW" then
L["Flight Master's Whistle"] = "飛行管理員的口哨"
L["FMW isn't a Hearthstone, but helps you get around faster."] = "飛行管理員的口哨不是個爐石，但有助於你更快的到達。"
L["Items that hearth you to various places."] = "傳送你到各個地方的物品。"
L["Jewelry"] = "首飾"
L["Show items like Innkeeper's Daughter in this group."] = "在此類別顯示像是旅館老闆的女兒的物品。"
L["Show items like Ruby Slippers in this group."] = "在此類別顯示像是紅寶石軟靴的物品"
L["Show items like the Kirin Tor rings in this group."] = "在此類別顯示像是祈倫托戒指的物品。"
L["Show quest items that portal in this group."] = "在此類別顯示任務傳送物品。"
L["ToC/Notes"] = "增加各種傳送物品到AdiBags的虛擬類別"


elseif locale == "esES" then
-- L["Flight Master's Whistle"] = ""
-- L["FMW isn't a Hearthstone, but helps you get around faster."] = ""
L["Items that hearth you to various places."] = "Objetos que teletransporten a varios lugares."
L["Jewelry"] = "Joyería"
L["Show items like Innkeeper's Daughter in this group."] = "Mostrar objetos como \"La hija del tabernero\" en este grupo"
L["Show items like Ruby Slippers in this group."] = "Mostrar objectos como \"Chapines de rubíes\" en este grupo."
L["Show items like the Kirin Tor rings in this group."] = "Mostrar objetos como los anillos del Kirin Tor en este grupo."
L["Show quest items that portal in this group."] = "Mostrar objetos de teletransporte de misiones en este grupo."
L["ToC/Notes"] = "Añadir objetos de teletransporte a los grupos virtuales de AdiBags"


elseif locale == "esMX" then
-- L["Flight Master's Whistle"] = ""
-- L["FMW isn't a Hearthstone, but helps you get around faster."] = ""
L["Items that hearth you to various places."] = "Objetos que teletransporten a varios lugares."
L["Jewelry"] = "Joyería"
L["Show items like Innkeeper's Daughter in this group."] = "Mostrar objetos como \"La hija del tabernero\" en este grupo"
L["Show items like Ruby Slippers in this group."] = "Mostrar objectos como \"Chapines de rubíes\" en este grupo."
L["Show items like the Kirin Tor rings in this group."] = "Mostrar objetos como los anillos del Kirin Tor en este grupo."
L["Show quest items that portal in this group."] = "Mostrar objetos de teletransporte de misiones en este grupo."
L["ToC/Notes"] = "Añadir objetos de teletransporte a los grupos virtuales de AdiBags"


else
-- enUS default
L["Flight Master's Whistle"] = true
L["FMW isn't a Hearthstone, but helps you get around faster."] = true
L["Items that hearth you to various places."] = true
L["Jewelry"] = true
L["Show items like Innkeeper's Daughter in this group."] = true
L["Show items like the Kirin Tor rings in this group."] = true
L["Show items like Ruby Slippers in this group."] = true
L["Show quest items that portal in this group."] = true
end

-- Replace remaining true values by their key
for k,v in pairs(L) do
	if v == true then
		L[k] = k
	end
end