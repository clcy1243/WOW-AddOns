
local heroes = {
	"Quake3",
}
local key = "Quake 3"
local path = "Interface\\AddOns\\BigWigs_Voice_Quake3\\enUS\\%s_%d.ogg"

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
