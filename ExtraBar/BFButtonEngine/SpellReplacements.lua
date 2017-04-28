--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2016
	
	* The only important data here are the ID's, the names etc are just to help to track
		what each entry is.
	* This was a real PitA, to some degree we can make the jump from Base Spell to Replacement
		but not in the reverse direction
	* This list was literally me looking at Talent descriptions and then copying ID's from WoWHead
		so I could have missed some or got typos :S
	* Not to mention such a list suddenly requires maintenance as Bliz change the spells around - so
		hopefully they don't do that or they make the API better organised to deal with these spell replacements
		(though really they've always been a pain, just a lot more common now it seems... )
]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local SR = Engine.SpellReplacements;


local function AddReplacement(Class, Spec, ReplacementName, ReplacementSpellID, BaseName, BaseSpellID, IsPvP)
	SR[ReplacementSpellID] = BaseSpellID;
end



AddReplacement("", "", "Gladiator's Medallion", 208683, "Honorable Medallion", 195710, true);
AddReplacement("", "", "Relentless", 196029, "Honorable Medallion", 195710, true);
AddReplacement("Hunter", "Survival", "Caltrops", 194277, "Tar Trap", 187698, false);
AddReplacement("Hunter", "Survival", "Steel Trap", 162488, "Freezing Trap", 187650, false);
AddReplacement("Hunter", "Survival", "Ranger's Net", 200108, "Wing Clip", 195645, false);
AddReplacement("Hunter", "Survival", "Butchery", 212436, "Carve", 187708, false);
AddReplacement("Hunter", "Marksmanship", "Sidewinders", 214579, "Arcane Shot", 185358, false);
AddReplacement("Hunter", "Beast Mastery", "Dire Frenzy", 217200, "Dire Beast", 120679, false);
AddReplacement("Warlock", "Destruction", "Bane of Havoc", 200546, "Havoc", 80240, true);
AddReplacement("Warlock", "Demonology", "Demonbolt", 157695, "Shadow Bolt", 686, false);
AddReplacement("Warlock", "Affliction", "Drain Soul", 198590, "Drain Life", 689, false);
AddReplacement("Mage", "", "Shimmer", 212653, "Blink", 1953, false);
AddReplacement("Mage", "Frost", "Ice Form", 198144, "Icy Veins", 12472, true);
AddReplacement("Mage", "Frost", "Lonely Winter", 205024, "Summon Water Elemental", 31687, false);
AddReplacement("Priest", "Discipline", "Purge the Wicked", 204197, "Shadow Word: Pain", 589, false);
AddReplacement("Priest", "Discipline", "Shadow Covenant", 204065, "Power Word: Radiance", 194509, false);
AddReplacement("Priest", "Discipline", "MindBender", 123040, "Shadowfiend", 34433, false);
AddReplacement("Priest", "Holy", "Spirit of the Redeemer", 215982, "Spirit of Redemption", 20711, true);
AddReplacement("Priest", "Holy", "Greater Fade", 213602, "Fade", 586, true);
AddReplacement("Priest", "Shadow", "Mind Spike", 73510, "Mind Flay", 585, false);
AddReplacement("Priest", "Shadow", "MindBender", 200174, "Shadowfiend", 34433, false);
AddReplacement("Priest", "Shadow", "Mind Bomb", 205369, "Psychic Scream", 8122, false);
AddReplacement("Shaman", "Restoration", "Spirit Link", 204293, "Spirit Link Totem", 98008, true);
AddReplacement("Shaman", "", "Voodoo Totem", 196932, "Hex", 51514, false);
AddReplacement("Shaman", "Enhancement", "Ethereal Form", 210918, "Astral Shift", 108271, true);
AddReplacement("Shaman", "Enhancement", "Boulderfist", 201897, "Rockbiter", 193786, false);
AddReplacement("Shaman", "Elemental", "Control of Lava", 204393, "Lava Surge", 77756, true);
AddReplacement("Shaman", "Elemental", "Storm Elemental", 192249, "Fire Elemental", 198067, false);
AddReplacement("Paladin", "Retribution", "Crusade", 224668, "Avenging Wrath", 31884, false);
AddReplacement("Paladin", "Retribution", "Blade of Wrath", 202270, "Blade of Justice", 184575, false);
AddReplacement("Paladin", "Retribution", "Divine Hammer", 198034, "Blade of Justice", 184575, false);
AddReplacement("Paladin", "Retribution", "Zeal", 217020, "Crusader Strike", 35395, false);
AddReplacement("Paladin", "Protection", "Guardian of the Forgotten Queen", 228049, "Guardian of Ancient Kings", 86659, true);
AddReplacement("Paladin", "Protection", "Hand of the Protector", 213652, "Light of the Protector", 184092, false);
AddReplacement("Paladin", "Protection", "Blessing of Spellwarding", 204018, "Blessing of Protection", 1022, false);
AddReplacement("Paladin", "Protection", "Blessed Hammer", 204019, "Hammer of the Righteous", 53595, false);
AddReplacement("Paladin", "Holy", "Avenging Crusader", 216331, "Avenging Wrath", 31842, true);
AddReplacement("Paladin", "Holy", "Beacon of Virtue", 200025, "Beacon of Light", 53563, false);
AddReplacement("Druid", "Balance", "Incarnation: Chosen of Elune", 102560, "Celestial Alignment", 194223, false);
AddReplacement("Druid", "Feral", "Brutal Slash", 202028, "Swipe", 213764, false);
AddReplacement("Druid", "Feral", "Incarnation: King of the Jungle", 102543, "Berserk", 106951, false);
AddReplacement("Druid", "Guardian", "Enraged Mangle", 202085, "Mangle", 33917, true);
AddReplacement("Warrior", "Arms", "Intercept", 198758, "Charge", 100, true);
AddReplacement("Warrior", "Arms", "Ravager", 152277, "Bladestorm", 46924, false);
AddReplacement("Warrior", "Protection", "Mass Spell Reflection", 213915, "Spell Reflection", 23920, true);
AddReplacement("Warrior", "Protection", "Impending Victory", 202168, "Victory Rush", 34428, false);
AddReplacement("Rogue", "Outlaw", "Slice and Dice", 5171, "Roll the Bones", 193316, false);
AddReplacement("Rogue", "Outlaw", "Parley", 199743, "Blind", 2094, false);
AddReplacement("Rogue", "Subtlety", "Gloomblade", 200758, "Backstab", 53, false);
AddReplacement("Monk", "Wind Walker", "Serenity", 152173, "Storm, Earth, and Fire", 137639, false);
AddReplacement("Monk", "Wind Walker", "Chi Torpedo", 115008, "Roll", 109132, false);
AddReplacement("Monk", "Mistweaver", "Soothing Mist", 209525, "Soothing Mist", 193884, true);
AddReplacement("Death Knight", "Unholy", "Dark Arbiter", 207349, "Summon Gargoyle", 49206, false);
AddReplacement("Death Knight", "Unholy", "Defile", 152280, "Death and Decay", 43265, false);
AddReplacement("Death Knight", "Unholy", "Clawing Shadows", 207311, "Scourge Strike", 55090, false);
AddReplacement("Death Knight", "Frost", "Killing Machine", 204143, "Killing Machine", 51128, true);
AddReplacement("Death Knight", "Frost", "Hungering Rune Weapon", 207127, "Empower Rune Weapon", 47568, false);
AddReplacement("Demon Hunter", "Havoc", "Demon Blades", 203555, "Demon's Bite", 162243, false);
AddReplacement("Demon Hunter", "Havoc", "Desperate Instincts", 205411, "Blur", 198589, false);
AddReplacement("Demon Hunter", "Havoc", "Netherwalk", 196555, "Blur", 198589, false);