
-- create our namespace
local db
local CC, CL = BigWigs:NewPlugin("Crowd Control")
local spells = {
--	[spellID] = duration,

	-- MAGE --
	[118] = 50, [28271] = 50, [28272] = 50, [61721] = 50, [61305] = 50, -- Polymorph, Polymorph: Turtle, Polymorph: Pig, Polymorph: Rabbit, Polymorph: Black Cat
}


-- on enable
function CC:OnPluginEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	db = self.db.profile
end

CC.toggleOptions = {
	118, -- MAGE - Polymorph
}

CC.optionHeaders = {
	[118] = LOCALIZED_CLASS_NAMES_MALE["MAGE"],
}


-- icon cache and communications factory
local icons = setmetatable({}, { __index = function(self, key)
	local _, _, icon = GetSpellInfo(key)

	self[key] = icon
	return icon
end })

function CC:COMBAT_LOG_EVENT_UNFILTERED(_, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName)
	if not spells[spellID] or db[spellName] == 0 then return end

	local text = CL["on"]:format(spellName, destName)

	if event == "SPELL_AURA_APPLIED" then
		self:SendMessage("BigWigs_Message", self, spellID, text, "Personal", nil, icons[spellID])
		self:SendMessage("BigWigs_StartBar", self, spellID, text, spells[spellID], icons[spellID])

	elseif event == "SPELL_AURA_REFRESH" then
		self:SendMessage("BigWigs_StopBar", self, text)
		self:SendMessage("BigWigs_StartBar", self, spellID, text, spells[spellID], icons[spellID])

	elseif event == "SPELL_AURA_REMOVED" then
		self:SendMessage("BigWigs_StopBar", self, text)

	end
end
