local AddonName, AddonTable = ...
AddonTable.L = {}
local L = AddonTable.L

--Name and description
L["Legion"] = EXPANSION_NAME6
L["Put items from Legion in their own sections."] = true
--Container Names
L["Artifact Power"] = ARTIFACT_POWER --Localized by Blizzard global strings.
L["Ancient Mana"] = GetCurrencyInfo(1155)
L["Champion Upgrades"] = true
L["Champion Equipment"] = true
L["Bait"] = true
L["Rare Fish"] = true
L["Fish Bait"] = true --The Combined Bait and Rare Fish container
--Option Strings
L['Create a section for Artifact Power items.'] = true
L['Create a section for Ancient Mana items.'] = true
L['Artifact Relics'] = true
L['Create a section for Artifact Relics.'] = true
L['Create a section for Champion Upgrades items.'] = true
L['Create a section for Champion Equipment.'] = true
L["Merge Champion Items"] = true
L['Put Champion Equipment and Upgrades in one section.'] = true
L['Create a section for Bait.'] = true
L['Create a section for Rare Fish.'] = true
L["Merge Bait and Fish"] = true
L['Put Fish Bait and Rare Fish in one section.'] = true
--Artifact Power Plugin
L["Artifact Power Values"] = true
L["k"] = true --means thousands used for number rounding
L["m"] = true --means millions used for number rounding
--Artifact Power Currency
L["Artifact Power Currency"] = true

-- Replace remaining true values by their key
for k,v in pairs(L) do if v == true then L[k] = k end end