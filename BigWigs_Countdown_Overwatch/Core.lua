local _, ns = ...
local L = ns.L

local localeMap = {
	enUS = "English",
	deDE = "Deutsch",
	-- esES = "Español (es)",
	-- esMX = "Español (mx)",
	frFR = "Français",
	-- itIT = "Italiano",
	-- koKR = "한국어",
	-- ptBR = "Português",
	-- ruRU = "Русский",
	-- zhCN = "简体中文",
	-- zhTW = "繁體中文",
}
local locale = GetLocale()
if not localeMap[locale] then
	locale = "enUS"
end

local heroes = {
	Announcer = "Athena",
	Ana = "Ana",
	Ashe = "Ashe",
	Bastion = "Bastion",
	Brigitte = "Brigitte",
	DVa = "D.Va",
	Doomfist = "Doomfist",
	Genji = "Genji",
	Hanzo = "Hanzo",
	Junkrat = "Junkrat",
	Lucio = "Lúcio",
	McCree = "McCree",
	Mei = "Mei",
	Mercy = "Mercy",
	Moira = "Moira",
	Orisa = "Orisa",
	Pharah = "Pharah" ,
	Reaper = "Reaper",
	Reinhardt = "Reinhardt",
	Roadhog = "Roadhog",
	Soldier76 = "Soldier: 76",
	Sombra = "Sombra",
	Symmetra = "Symmetra",
	Torbjorn = "Torbjörn",
	Tracer = "Tracer",
	Widowmaker = "Widowmaker",
	Winston = "Winston",
	WreckingBall = "Wrecking Ball",
	Zarya = "Zarya",
	Zenyatta = "Zenyatta",
}

local lang = localeMap[locale]
local path = "Interface\\AddOns\\BigWigs_Countdown_Overwatch\\"..locale.."\\%s_%d.ogg"

for k, v in next, heroes do
	local id = ("%s: Overwatch: %s"):format(lang, k)
	local name = L.key:format(lang, L[k] or v)
	BigWigsAPI:RegisterCountdown(id, name, {
		path:format(k, 1),
		path:format(k, 2),
		path:format(k, 3),
		path:format(k, 4),
		path:format(k, 5),
	})
end
