
if BigWigsAPI:HasCountdown("English: Overwatch: Tracer") or GetAddOnEnableState(UnitName("player"), "BigWigs_Voice_Overwatch") > 0 then
	C_Timer.After(7, function()
		print("|cFF33FF99BigWigs_Voice_Overwatch|r has been renamed to |cFF33FF99BigWigs_Countdown_Overwatch|r and you seem to have both addons enabled! Please remove the old |cFF33FF99BigWigs_Voice_Overwatch|r folder from your Interface/AddOns folder to ensure you're using the correct version.")
	end)
	return
end

local heroes = {
	"Announcer",
	"Ana",
	"Bastion",
	"D.Va",
	"Doomfist",
	"Genji",
	"Hanzo",
	"Junkrat",
	"Lucio",
	"McCree",
	"Mei",
	"Mercy",
	"Moira",
	"Orisa",
	"Pharah",
	"Reaper",
	"Reinhardt",
	"Roadhog",
	"Soldier76",
	"Sombra",
	"Symmetra",
	"Torbjorn",
	"Tracer",
	"Widowmaker",
	"Winston",
	"Zarya",
	"Zenyatta",
}
local key = "English: Overwatch: %s"
local path = "Interface\\AddOns\\BigWigs_Countdown_Overwatch\\enUS\\%s_%d.ogg"

for i = 1, #heroes do
	local hero = heroes[i]
	BigWigsAPI:RegisterCountdown(key:format(hero), {
		path:format(hero, 1), 
		path:format(hero, 2),
		path:format(hero, 3),
		path:format(hero, 4),
		path:format(hero, 5),
	})
end
