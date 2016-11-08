--[[
AdiBags_Garrison - Adds Garrison group in your bags, using AdiBags inventory manager.
Copyright 2016 Kiber_ (4thekiber@gmail.com)
All rights reserved.
--]]

local addonName, addon = ...

local L = setmetatable({}, {
	__index = function(self, key)
		if key ~= nil then
			--[===[@debug@
			addon:Debug('Missing locale', tostring(key))
			--@end-debug@]===]
			rawset(self, key, tostring(key))
		end
		return tostring(key)
	end,
})
addon.L = L

local locale = GetLocale()

------------------------ enUS ------------------------

L["Basic Work Orders"] = true
L["Blueprints"] = true
L["Follower items"] = true
L["Garrison"] = true
L["Garrison items group."] = true
L["Iron Horde"] = true
L["Mining Coffee & Pick"] = true
L["Naval Equipment"] = true
L["Show Dwarven Bunker / War Mill items, like Iron Horde Scraps, in this group."] = true
L["Show follower enhancements and contracts in this group."] = true
L["Show Miner's Coffee and Preserved Mining Pick in this group."] = true
L["Show materials, like seeds, stone, timber, caged beasts and others, in this group."] = true
L["Show ships enhancements in this group."] = true
L["Show the plans needed to build in garrison in this group."] = true

------------------------ frFR ------------------------
if locale == "frFR" then


------------------------ deDE ------------------------
elseif locale == "deDE" then

L["Basic Work Orders"] = "Einfache Arbeitsaufträge"
L["Blueprints"] = "Baupläne"
L["Follower items"] = "Anhängergegenstände"
L["Garrison"] = "Garnison"
L["Garrison items group."] = "Garnisonsgegenständegruppe."
L["Iron Horde"] = "Eiserne Horde"
L["Mining Coffee & Pick"] = "Minenarbeiterkaffee & Spitzhacke"
L["Naval Equipment"] = "Marineausstattung"
L["Show Dwarven Bunker / War Mill items, like Iron Horde Scraps, in this group."] = "Zeigt Zwergenbunker-/Kriegswerkstatt-Gegenstände, wie z.B. Rüstungsteile der Eisernen Horde, in dieser Gruppe an."
L["Show follower items in this group."] = "Zeigt Anhängergegenstände in dieser Gruppe an."
L["Show Miner's Coffee and Preserved Mining Pick in this group."] = "Zeigt Minenarbeiterkaffee und Gut erhaltene Spitzhacke in dieser Gruppe an."
L["Show materials, like seeds, stone, timber, caged beasts and others, in this group."] = "Zeigt Samen, Steine, Holz, eingesperrte Tiere und andere Gegenstände in dieser Gruppe an."
L["Show ships enhancements in this group."] = "Zeigen Verbesserungen für die Schiffe in dieser Gruppe."
L["Show the plans needed to build in garrison in this group."] = "Zeigt die Pläne, die gebraucht werden, um die Garnison aufzubauen, in dieser Gruppe an."

------------------------ esMX ------------------------
elseif locale == "esMX" then


------------------------ ruRU ------------------------
elseif locale == "ruRU" then

L["Basic Work Orders"] = "Материалы заказов"
L["Blueprints"] = "Чертежи"
L["Follower items"] = "Предметы последователей"
L["Garrison"] = "Гарнизон"
L["Garrison items group."] = "В этой группе отображаются предметы, имеющие отношение к гарнизону."
L["Iron Horde"] = "Железная орда"
L["Mining Coffee & Pick"] = "Шахтерский кофе и кирка"
L["Naval Equipment"] = "Оборудование для кораблей"
L["Show Dwarven Bunker / War Mill items, like Iron Horde Scraps, in this group."] = "Показывать в этой группе предметы дворфийского бункера / военной фабрики, такие как Обломки доспехов Железной Орды."
L["Show follower enhancements and contracts in this group."] = "Показывать улучшения и контракты последователей в этой группе."
L["Show Miner's Coffee and Preserved Mining Pick in this group."] = "Показывать Кофе по-шахтерски и Сохранившуюся шахтерскую кирку в этой группе."
L["Show materials, like seeds, stone, timber, caged beasts and others, in this group."] = "Показывать семена, камень, древесину, пойманных животных и прочее в этой группе."
L["Show ships enhancements in this group."] = "Показывать улучшения для кораблей в этой группе."
L["Show the plans needed to build in garrison in this group."] = "Показывать чертежи к зданиям гарнизона в этой группе."

------------------------ esES ------------------------
elseif locale == "esES" then


------------------------ zhTW ------------------------
elseif locale == "zhTW" then

L["Basic Work Orders"] = "基本工作訂單"
L["Blueprints"] = "藍圖"
L["Follower items"] = "追隨者物品"
L["Garrison"] = "要塞"
L["Garrison items group."] = "要塞物品群組。"
L["Iron Horde"] = "鋼鐵部落"
L["Mining Coffee & Pick"] = "礦工咖啡&槁"
L["Naval Equipment"] = "船艦設備"
L["Show Dwarven Bunker / War Mill items, like Iron Horde Scraps, in this group."] = "顯示矮人地堡/戰爭磨坊物品，就像是鋼鐵部落碎片。"
L["Show follower items in this group."] = "顯示追隨者物品。"
L["Show Miner's Coffee and Preserved Mining Pick in this group."] = "顯示礦工咖啡和稿。"
L["Show materials, like seeds, stone, timber, caged beasts and others, in this group."] = "顯示種子、石頭、木材和其它。"
L["Show the plans needed to build in garrison in this group."] = "顯示需要在要塞裡建築的圖紙。"

------------------------ zhCN ------------------------
elseif locale == "zhCN" then


------------------------ koKR ------------------------
elseif locale == "koKR" then


end

-- Replace remaining true values by their key
for k,v in pairs(L) do if v == true then L[k] = k end end

-- 
local BIext = setmetatable({}, {
	__index = function(self, key)
		if key ~= nil then
			--[===[@debug@
			addon:Debug('Missing locale', tostring(key))
			--@end-debug@]===]
			rawset(self, key, tostring(key))
		end
		return tostring(key)
	end,
})
addon.BIext = BIext
BIext["Naval Equipment"] = "Naval Equipment"
if locale == "frFR" then
  BIext["Naval Equipment"] = "Équipement naval"
elseif locale == "deDE" then
  BIext["Naval Equipment"] = "Marineausstattung"
elseif locale == "esMX" then
  BIext["Naval Equipment"] = "Equipamiento naval"
elseif locale == "ruRU" then
  BIext["Naval Equipment"] = "Корабельное оборудование"
elseif locale == "esES" then
  BIext["Naval Equipment"] = "Equipo naval"
elseif locale == "zhTW" then
  BIext["Naval Equipment"] = "船艦設備"
elseif locale == "zhCN" then
  BIext["Naval Equipment"] = "海军装备"
elseif locale == "koKR" then
  BIext["Naval Equipment"] = "해상 장비"
end