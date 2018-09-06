-----------------------------------------------
---- Raeli's Spell Announcer Shaman Module ----
-----------------------------------------------
local RSA = LibStub("AceAddon-3.0"):GetAddon("RSA")
local L = LibStub("AceLocale-3.0"):GetLocale("RSA")
local LRI = LibStub("LibResInfo-1.0",true)
local RSA_Shaman = RSA:NewModule("Shaman")

local spellinfo,spelllinkinfo,extraspellinfo,extraspellinfolink,missinfo
local SpiritLink_GUID,TremorTotem_GUID,WindRush_GUID,Protection_GUID,Protection_Cast,LightningSurge_GUID,LightningCounter,Cloudburst_GUID,EarthenShield_GUID,Cloudburst_Announced
local ShamanSpells = RSA.db.profile.Shaman.Spells

function RSA_Shaman:OnInitialize()
	if RSA.db.profile.General.Class == "SHAMAN" then
		RSA_Shaman:SetEnabledState(true)
	else
		RSA_Shaman:SetEnabledState(false)
	end
end

function RSA.Resurrect(_, _, target, _, caster)
	if caster ~= "player" then return end
	local dest = UnitName(target)
	local pName = UnitName("player")
	local spell = 2008
	local messagemax = #RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.Start
	if messagemax == 0 then return end
	local messagerandom = math.random(messagemax)
	local message = RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.Start[messagerandom]
	local full_destName,dest = RSA.RemoveServerNames(dest)
	spellinfo = GetSpellInfo(spell) spelllinkinfo = GetSpellLink(spell)
	RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
	if message ~= "" then
		if RSA.db.profile.Shaman.Spells.AncestralSpirit.Local == true then
			RSA.Print_LibSink(string.gsub(message, ".%a+.", RSA.String_Replace))
		end
		if RSA.db.profile.Shaman.Spells.AncestralSpirit.Yell == true then
			RSA.Print_Yell(string.gsub(message, ".%a+.", RSA.String_Replace))
		end
		if RSA.db.profile.Shaman.Spells.AncestralSpirit.Whisper == true and dest ~= pName then
			RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
			RSA.Print_Whisper(string.gsub(message, ".%a+.", RSA.String_Replace), full_destName)
			RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
		end
		if RSA.db.profile.Shaman.Spells.AncestralSpirit.CustomChannel.Enabled == true then
			RSA.Print_Channel(string.gsub(message, ".%a+.", RSA.String_Replace), RSA.db.profile.Shaman.Spells.AncestralSpirit.CustomChannel.Channel)
		end
		if RSA.db.profile.Shaman.Spells.AncestralSpirit.Say == true then
			RSA.Print_Say(string.gsub(message, ".%a+.", RSA.String_Replace))
		end
		if RSA.db.profile.Shaman.Spells.AncestralSpirit.SmartGroup == true then
			RSA.Print_SmartGroup(string.gsub(message, ".%a+.", RSA.String_Replace))
		end
		if RSA.db.profile.Shaman.Spells.AncestralSpirit.Party == true then
			if RSA.db.profile.Shaman.Spells.AncestralSpirit.SmartGroup == true and GetNumGroupMembers() == 0 then return end
				RSA.Print_Party(string.gsub(message, ".%a+.", RSA.String_Replace))
		end
		if RSA.db.profile.Shaman.Spells.AncestralSpirit.Raid == true then
			if RSA.db.profile.Shaman.Spells.AncestralSpirit.SmartGroup == true and GetNumGroupMembers() > 0 then return end
			RSA.Print_Raid(string.gsub(message, ".%a+.", RSA.String_Replace))
		end
	end	
end

function RSA_Shaman:OnEnable()
	if LRI then LRI.RegisterCallback(RSA, "LibResInfo_ResCastStarted", "Resurrect") end
	RSA.db.profile.Modules.Shaman = true -- Set state to loaded, to know if we should announce when a spell is refreshed.
	local pName = UnitName("player")
	local Config_Ascendance = { -- ASCENDANCE
		profile = 'Ascendance'
	}
	local Config_Ascendance_End = { -- ASCENDANCE
		profile = 'Ascendance',
		section = 'End'
	}
	local MonitorConfig_Shaman = {
		player_profile = RSA.db.profile.Shaman,
		SPELL_RESURRECT = {
			[2008] = { -- AncestralSpirit
				profile = 'AncestralSpirit',
				section = 'End',
				replacements = { TARGET = 1 },
			},
		},
		SPELL_CAST_START = {
			[212048] = { -- ANCESTRAL VISION
				profile = 'AncestralVision'
			},
		},
		SPELL_CAST_SUCCESS = {
			[212048] = { -- ANCESTRAL VISION
				profile = 'AncestralVision',
				section = 'End',
			},
			[2008] = { -- ANCESTRAL VISION
				profile = 'AncestralSpirit',
				section = 'End',
				replacements = { TARGET = 1 }
			},
			[198103] = { -- EARTH ELEMENTAL
				profile = 'EarthElemental'
			},
			[198067] = { -- FIRE ELEMENTAL
				profile = 'FireElemental',
			},
			[98008] = { -- SPIRIT LINK TOTEM
				profile = 'SpiritLink'
			},
			[8143] = { -- Tremor Totem
				profile = 'TremorTotem'
			},
			[192077] = { -- WINDRUSH TOTEM
				profile = 'WindRushTotem'
			},
			[2825] = { -- BLOODLUST
				profile = 'Heroism'
			},
			[32182] = { -- HEROISM
				profile = 'Heroism'
			},
			[51490] = { -- THUNDERSTORM
				profile = 'Thunderstorm',
				section = "Cast"
			},
			[108281] = { -- ANCESTRAL GUIDANCE
				profile = 'AncestralGuidance'
			},
			[108271] = { -- ASTRAL SHIFT
				profile = 'AstralShift'
			},
			[51533] = { -- FERAL SPIRIT
				profile = 'FeralSpirit',
				section = "Cast"
			},
			[21169] = { -- REINCARNATION
				profile = 'Reincarnation',
				section = "Cast"
			},
			[207399] = { -- Ancestral Protection Totem
				profile = 'AncestralProtection',
				section = "Cast",
			},
		--[[	[207553] = { -- Ancestral Protection Totem
				profile = 'AncestralProtection',
				linkID = 207399,
				replacements = { SOURCE = 1},
				section = 'Success'
			},]]--
			[192058] = { -- Lightning Surge Totem
				profile = 'LightningSurge',
				section = "Cast",
			},
			[157153] = { -- Cloudburst Totem
				profile = 'Cloudburst'
			},
			[201764] = { -- Cloudburst Totem
				profile = 'Cloudburst',
				linkID = 157153,
				section = "End"
			},
			[198838] = { -- Earthen Shield Totem
				profile = 'EarthenShieldTotem'
			},
		},
		SPELL_AURA_APPLIED = {
			[51514] = { -- HEX
				profile = 'Hex',
				replacements = { TARGET = 1 }
			},
			[108280] = { -- HEALING TIDE TOTEM
				profile = 'HealingTide'
			},
			[114050] = Config_Ascendance, -- ASCENDANCE
			[114051] = Config_Ascendance, -- ASCENDANCE
			[114052] = Config_Ascendance -- ASCENDANCE
		},
		SPELL_AURA_REMOVED = {
			[198103] = { -- EARTH ELEMENTAL
				profile = 'EarthElemental',
				section = 'End',
			},
			[118291] = { -- FIRE ELEMENTAL
				profile = 'FireElemental',
				section = 'End',
				linkID = 198067,
			},
			[188592] = { -- FIRE ELEMENTAL
				profile = 'FireElemental',
				section = 'End',
				linkID = 198067,
			},
			[108280] = { -- HEALING TIDE TOTEM
				profile = 'HealingTide',
				section = 'End'
			},
			[51514] = { -- HEX
				profile = 'Hex',
				section = 'End',
				replacements = { TARGET = 1 }
			},
			[2825] = { -- BLOODLUST
				profile = 'Heroism',
				section = 'End',
				targetIsMe = 1
			},
			[32182] = { -- HEROISM
				profile = 'Heroism',
				section = 'End',
				targetIsMe = 1
			},
			[114050] = Config_Ascendance_End, -- ASCENDANCE
			[114051] = Config_Ascendance_End, -- ASCENDANCE
			[114052] = Config_Ascendance_End, -- ASCENDANCE
			[108281] = { -- ANCESTRAL GUIDANCE
				profile = 'AncestralGuidance',
				section = 'End'
			},
			[108271] = { -- ASTRAL SHIFT
				profile = 'AstralShift',
				section = 'End'
			}
		},
		SPELL_DISPEL = {
			[370] = { -- PURGE
				profile = 'Purge',
				section = "Dispel",
				replacements = { TARGET = 1, extraSpellName = "[AURA]", extraSpellLink = "[AURALINK]" }
			},
			[51886] = { -- CLEANSE SPIRIT
				profile = 'CleanseSpirit',
				section = "Dispel",
				replacements = { TARGET = 1, extraSpellName = "[AURA]", extraSpellLink = "[AURALINK]" }
			},
			[77130] = { -- PURIFY SPIRIT
				profile = 'CleanseSpirit',
				section = "Dispel",
				replacements = { TARGET = 1, extraSpellName = "[AURA]", extraSpellLink = "[AURALINK]" }
			},
		},
		SPELL_DISPEL_FAILED = {
			[370] = { -- PURGE
				profile = 'Purge',
				section = 'Resist',
				replacements = { TARGET = 1}
			},
		},
		SPELL_INTERRUPT = {
			[57994] = { -- WIND SHEAR
				profile = 'WindShear',
				section = "Interrupt",
				replacements = { TARGET = 1, extraSpellName = "[TARSPELL]", extraSpellLink = "[TARLINK]" }
			},
		},
		SPELL_MISSED = {
			[57994] = {-- WIND SHEAR
				profile = 'WindShear',
				section = 'Resist',
				immuneSection = "Immune",
				replacements = { TARGET = 1, MISSTYPE = 1 },
			},
			[51514] = { -- HEX
				profile = 'Hex',
				section = 'Resist',
				immuneSection = "Immune",
				replacements = { TARGET = 1, MISSTYPE = 1 },
			},
		},
	}
	RSA.MonitorConfig(MonitorConfig_Shaman, UnitGUID("player"))
	local MonitorAndAnnounce = RSA.MonitorAndAnnounce
	local ResTarget = L["Unknown"]
	local Ressed
	local function Shaman_Spells()
		local timestamp, event, hideCaster, sourceGUID, source, sourceFlags, sourceRaidFlag, destGUID, dest, destFlags, destRaidFlags, spellID, spellName, spellSchool, missType, overheal, ex3, ex4 = CombatLogGetCurrentEventInfo()
		if RSA.AffiliationMine(sourceFlags) then
			if (event == "SPELL_CAST_SUCCESS" and RSA.db.profile.Modules.Reminders_Loaded == true) then -- Reminder Refreshed
				local ReminderSpell = RSA.db.profile.Shaman.Reminders.SpellName
				if spellName == ReminderSpell and (dest == pName or dest == nil) then
					RSA.Reminder:SetScript("OnUpdate", nil)
					if RSA.db.profile.Reminders.RemindChannels.Chat == true then
						RSA.Print_Self(ReminderSpell .. L[" Refreshed!"])
					end
					if RSA.db.profile.Reminders.RemindChannels.RaidWarn == true then
						RSA.Print_Self_RW(ReminderSpell .. L[" Refreshed!"])
					end
				end
			end -- BUFF REMINDER
			if event == "SPELL_SUMMON" then
				if spellID == 98008 then -- SPIRIT LINK TOTEM
					SpiritLink_GUID = destGUID return -- Unit source isn't player. GUID tracking used to ensure we only announce our own. 
				end
				if spellID == 8143 then -- SPIRIT LINK TOTEM
					TremorTotem_GUID = destGUID return -- Unit source isn't player. GUID tracking used to ensure we only announce our own. 
				end
				if spellID == 192077 then -- WINDRUSH TOTEM
					WindRush_GUID = destGUID return
				end
				if spellID == 207399 then -- Ancestral Protection Totem
					Protection_Cast = true
					Protection_GUID = destGUID return
				end
				if spellID == 192058 then -- Lightning Surge Totem
					LightningCounter = 0
					LightningSurge_GUID = destGUID return
				end
				if spellID == 157153 then -- Cloudburst Totem
					Cloudburst_Announced = false
				end
				if spellID == 198838 then -- Earthen Shield Totem
					EarthenShield_GUID = destGUID return
				end
			end -- IF EVENT IS SPELL_SUMMON
			if event == "SPELL_CAST_SUCCESS" and spellID == 201764 then -- Recall Cloudburst Totem
				--Cloudburst_Announced = true
			end
			if event == "SPELL_HEAL" and spellID == 157503 then -- Cloudburst Totem Heal
				if Cloudburst_Announced == true then return end
				Cloudburst_Announced = true
				spellinfo = GetSpellInfo(157153) spelllinkinfo = GetSpellLink(157153)
				RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[AMOUNT]"] = missType + overheal}
				local messagemax = #RSA.db.profile.Shaman.Spells.Cloudburst.Messages.Heal
				if messagemax == 0 then return end
				local messagerandom = math.random(messagemax)
				local message = RSA.db.profile.Shaman.Spells.Cloudburst.Messages.Heal[messagerandom]
				local full_destName,dest = RSA.RemoveServerNames(dest)
				if message ~= "" then
					if RSA.db.profile.Shaman.Spells.Cloudburst.Local == true then
						RSA.Print_LibSink(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.Cloudburst.Yell == true then
						RSA.Print_Yell(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.Cloudburst.Whisper == true and dest ~= pName then
						RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
						RSA.Print_Whisper(string.gsub(message, ".%a+.", RSA.String_Replace), full_destName)
						RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					end
					if RSA.db.profile.Shaman.Spells.Cloudburst.CustomChannel.Enabled == true then
						RSA.Print_Channel(string.gsub(message, ".%a+.", RSA.String_Replace), RSA.db.profile.Shaman.Spells.Cloudburst.CustomChannel.Channel)
					end
					if RSA.db.profile.Shaman.Spells.Cloudburst.Say == true then
						RSA.Print_Say(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.Cloudburst.SmartGroup == true then
						RSA.Print_SmartGroup(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.Cloudburst.Party == true then
						if RSA.db.profile.Shaman.Spells.Cloudburst.SmartGroup == true and GetNumGroupMembers() == 0 then return end
							RSA.Print_Party(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.Cloudburst.Raid == true then
						if RSA.db.profile.Shaman.Spells.Cloudburst.SmartGroup == true and GetNumGroupMembers() > 0 then return end
						RSA.Print_Raid(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
				end
			end
			MonitorAndAnnounce(self, timestamp, event, hideCaster, sourceGUID, source, sourceFlags, sourceRaidFlag, destGUID, dest, destFlags, destRaidFlags, spellID, spellName, spellSchool, missType, overheal, ex3, ex4)
		end -- IF SOURCE IS PLAYER		
		if event == "SPELL_CAST_SUCCESS" and Protection_Cast == true and spellID == 207553 then -- Ancestral Protection Totem
			for i=1,4 do
				local totemname = select(2, GetTotemInfo(i))
				if totemname == GetSpellInfo(207399) then -- If our totem exists then the resurrection cannot be from our totem.
					return
				end
			end
			Protection_Cast = false
			spellinfo = GetSpellInfo(207399) spelllinkinfo = GetSpellLink(207399)
			RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = source,}
			local messagemax = #RSA.db.profile.Shaman.Spells.AncestralProtection.Messages.Start
			if messagemax == 0 then return end
			local messagerandom = math.random(messagemax)
			local message = RSA.db.profile.Shaman.Spells.AncestralProtection.Messages.Start[messagerandom]
			if message ~= "" then
				if RSA.db.profile.Shaman.Spells.AncestralProtection.Local == true then
					RSA.Print_LibSink(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.AncestralProtection.Yell == true then
					RSA.Print_Yell(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.AncestralProtection.CustomChannel.Enabled == true then
					RSA.Print_Channel(string.gsub(message, ".%a+.", RSA.String_Replace), RSA.db.profile.Shaman.Spells.AncestralProtection.CustomChannel.Channel)
				end
				if RSA.db.profile.Shaman.Spells.AncestralProtection.Say == true then
					RSA.Print_Say(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.AncestralProtection.SmartGroup == true then
					RSA.Print_SmartGroup(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.AncestralProtection.Party == true then
					if RSA.db.profile.Shaman.Spells.AncestralProtection.SmartGroup == true and GetNumGroupMembers() == 0 then return end
						RSA.Print_Party(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.AncestralProtection.Raid == true then
					if RSA.db.profile.Shaman.Spells.AncestralProtection.SmartGroup == true and GetNumGroupMembers() > 0 then return end
					RSA.Print_Raid(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
			end
		end
		if event == "SPELL_CAST_SUCCESS" and sourceGUID == LightningSurge_GUID and spellID == 118905 then -- Lightning Surge Totem
			spellinfo = GetSpellInfo(118905) spelllinkinfo = GetSpellLink(118905)
			RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
			local messagemax = #RSA.db.profile.Shaman.Spells.LightningSurge.Messages.Start
			if messagemax == 0 then return end
			local messagerandom = math.random(messagemax)
			local message = RSA.db.profile.Shaman.Spells.LightningSurge.Messages.Start[messagerandom]
			if message ~= "" and LightningCounter == 0 then
				if RSA.db.profile.Shaman.Spells.LightningSurge.Local == true then
					RSA.Print_LibSink(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.LightningSurge.Yell == true then
					RSA.Print_Yell(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.LightningSurge.CustomChannel.Enabled == true then
					RSA.Print_Channel(string.gsub(message, ".%a+.", RSA.String_Replace), RSA.db.profile.Shaman.Spells.LightningSurge.CustomChannel.Channel)
				end
				if RSA.db.profile.Shaman.Spells.LightningSurge.Say == true then
					RSA.Print_Say(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.LightningSurge.SmartGroup == true then
					RSA.Print_SmartGroup(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.LightningSurge.Party == true then
					if RSA.db.profile.Shaman.Spells.LightningSurge.SmartGroup == true and GetNumGroupMembers() == 0 then return end
						RSA.Print_Party(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.LightningSurge.Raid == true then
					if RSA.db.profile.Shaman.Spells.LightningSurge.SmartGroup == true and GetNumGroupMembers() > 0 then return end
					RSA.Print_Raid(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
			end
			LightningCounter = LightningCounter +1
		end
		if event == "SPELL_AURA_REMOVED" and sourceGUID == LightningSurge_GUID and spellID == 118905 then -- Lightning Surge Totem
			spellinfo = GetSpellInfo(118905) spelllinkinfo = GetSpellLink(118905)
			RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
			LightningCounter = LightningCounter -1
			local messagemax = #RSA.db.profile.Shaman.Spells.LightningSurge.Messages.End
			if messagemax == 0 then return end
			local messagerandom = math.random(messagemax)
			local message = RSA.db.profile.Shaman.Spells.LightningSurge.Messages.End[messagerandom]
			local full_destName,dest = RSA.RemoveServerNames(dest)
			if message ~= "" and LightningCounter == 0 then
				if RSA.db.profile.Shaman.Spells.LightningSurge.Local == true then
					RSA.Print_LibSink(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.LightningSurge.Yell == true then
					RSA.Print_Yell(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.LightningSurge.Whisper == true and dest ~= pName then
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
					RSA.Print_Whisper(string.gsub(message, ".%a+.", RSA.String_Replace), full_destName)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
				end
				if RSA.db.profile.Shaman.Spells.LightningSurge.CustomChannel.Enabled == true then
					RSA.Print_Channel(string.gsub(message, ".%a+.", RSA.String_Replace), RSA.db.profile.Shaman.Spells.LightningSurge.CustomChannel.Channel)
				end
				if RSA.db.profile.Shaman.Spells.LightningSurge.Say == true then
					RSA.Print_Say(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.LightningSurge.SmartGroup == true then
					RSA.Print_SmartGroup(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.LightningSurge.Party == true then
					if RSA.db.profile.Shaman.Spells.LightningSurge.SmartGroup == true and GetNumGroupMembers() == 0 then return end
						RSA.Print_Party(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
				if RSA.db.profile.Shaman.Spells.LightningSurge.Raid == true then
					if RSA.db.profile.Shaman.Spells.LightningSurge.SmartGroup == true and GetNumGroupMembers() > 0 then return end
					RSA.Print_Raid(string.gsub(message, ".%a+.", RSA.String_Replace))
				end
			end
		end
		if event == "UNIT_DIED" then -- Unit source isn't player. GUID tracking used to ensure we only announce our own. 
			if destGUID == SpiritLink_GUID then -- Spirit Link Totem UNIT_DIED
				spellinfo = GetSpellInfo(98008) spelllinkinfo = GetSpellLink(98008)
				RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
				local messagemax = #RSA.db.profile.Shaman.Spells.SpiritLink.Messages.End
				if messagemax == 0 then return end
				local messagerandom = math.random(messagemax)
				local message = RSA.db.profile.Shaman.Spells.SpiritLink.Messages.End[messagerandom]
				if message ~= "" then
					if RSA.db.profile.Shaman.Spells.SpiritLink.Local == true then
						RSA.Print_LibSink(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.SpiritLink.Yell == true then
						RSA.Print_Yell(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.SpiritLink.CustomChannel.Enabled == true then
						RSA.Print_Channel(string.gsub(message, ".%a+.", RSA.String_Replace), RSA.db.profile.Shaman.Spells.SpiritLink.CustomChannel.Channel)
					end
					if RSA.db.profile.Shaman.Spells.SpiritLink.Say == true then
						RSA.Print_Say(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.SpiritLink.SmartGroup == true then
						RSA.Print_SmartGroup(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.SpiritLink.Party == true then
						if RSA.db.profile.Shaman.Spells.SpiritLink.SmartGroup == true and GetNumGroupMembers() == 0 then return end
							RSA.Print_Party(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.SpiritLink.Raid == true then
						if RSA.db.profile.Shaman.Spells.SpiritLink.SmartGroup == true and GetNumGroupMembers() > 0 then return end
						RSA.Print_Raid(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
				end
			end
			if destGUID == TremorTotem_GUID then -- Tremor Totem UNIT_DIED
				spellinfo = GetSpellInfo(8143) spelllinkinfo = GetSpellLink(8143)
				RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
				local messagemax = #RSA.db.profile.Shaman.Spells.TremorTotem.Messages.End
				if messagemax == 0 then return end
				local messagerandom = math.random(messagemax)
				local message = RSA.db.profile.Shaman.Spells.TremorTotem.Messages.End[messagerandom]
				if message ~= "" then
					if RSA.db.profile.Shaman.Spells.TremorTotem.Local == true then
						RSA.Print_LibSink(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.TremorTotem.Yell == true then
						RSA.Print_Yell(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.TremorTotem.CustomChannel.Enabled == true then
						RSA.Print_Channel(string.gsub(message, ".%a+.", RSA.String_Replace), RSA.db.profile.Shaman.Spells.TremorTotem.CustomChannel.Channel)
					end
					if RSA.db.profile.Shaman.Spells.TremorTotem.Say == true then
						RSA.Print_Say(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.TremorTotem.SmartGroup == true then
						RSA.Print_SmartGroup(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.TremorTotem.Party == true then
						if RSA.db.profile.Shaman.Spells.TremorTotem.SmartGroup == true and GetNumGroupMembers() == 0 then return end
							RSA.Print_Party(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.TremorTotem.Raid == true then
						if RSA.db.profile.Shaman.Spells.TremorTotem.SmartGroup == true and GetNumGroupMembers() > 0 then return end
						RSA.Print_Raid(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
				end
			end
			if destGUID == WindRush_GUID then -- WindRushTotem UNIT_DIED
				spellinfo = GetSpellInfo(192077) spelllinkinfo = GetSpellLink(192077)
				RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
				local messagemax = #RSA.db.profile.Shaman.Spells.WindRushTotem.Messages.End
				if messagemax == 0 then return end
				local messagerandom = math.random(messagemax)
				local message = RSA.db.profile.Shaman.Spells.WindRushTotem.Messages.End[messagerandom]
				if message ~= "" then
					if RSA.db.profile.Shaman.Spells.WindRushTotem.Local == true then
						RSA.Print_LibSink(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.WindRushTotem.Yell == true then
						RSA.Print_Yell(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.WindRushTotem.CustomChannel.Enabled == true then
						RSA.Print_Channel(string.gsub(message, ".%a+.", RSA.String_Replace), RSA.db.profile.Shaman.Spells.WindRushTotem.CustomChannel.Channel)
					end
					if RSA.db.profile.Shaman.Spells.WindRushTotem.Say == true then
						RSA.Print_Say(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.WindRushTotem.SmartGroup == true then
						RSA.Print_SmartGroup(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.WindRushTotem.Party == true then
						if RSA.db.profile.Shaman.Spells.WindRushTotem.SmartGroup == true and GetNumGroupMembers() == 0 then return end
							RSA.Print_Party(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.WindRushTotem.Raid == true then
						if RSA.db.profile.Shaman.Spells.WindRushTotem.SmartGroup == true and GetNumGroupMembers() > 0 then return end
						RSA.Print_Raid(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
				end
			end
			if destGUID == Protection_GUID then -- Ancestral Protection Totem
				Protection_Cast = false
				spellinfo = GetSpellInfo(207495) spelllinkinfo = GetSpellLink(207495)
				RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
				local messagemax = #RSA.db.profile.Shaman.Spells.AncestralProtection.Messages.End
				if messagemax == 0 then return end
				local messagerandom = math.random(messagemax)
				local message = RSA.db.profile.Shaman.Spells.AncestralProtection.Messages.End[messagerandom]
				local full_destName,dest = RSA.RemoveServerNames(dest)
				if message ~= "" then
					if RSA.db.profile.Shaman.Spells.AncestralProtection.Local == true then
						RSA.Print_LibSink(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.AncestralProtection.Yell == true then
						RSA.Print_Yell(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.AncestralProtection.Whisper == true and dest ~= pName then
						RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
						RSA.Print_Whisper(string.gsub(message, ".%a+.", RSA.String_Replace), full_destName)
						RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					end
					if RSA.db.profile.Shaman.Spells.AncestralProtection.CustomChannel.Enabled == true then
						RSA.Print_Channel(string.gsub(message, ".%a+.", RSA.String_Replace), RSA.db.profile.Shaman.Spells.AncestralProtection.CustomChannel.Channel)
					end
					if RSA.db.profile.Shaman.Spells.AncestralProtection.Say == true then
						RSA.Print_Say(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.AncestralProtection.SmartGroup == true then
						RSA.Print_SmartGroup(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.AncestralProtection.Party == true then
						if RSA.db.profile.Shaman.Spells.AncestralProtection.SmartGroup == true and GetNumGroupMembers() == 0 then return end
							RSA.Print_Party(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.AncestralProtection.Raid == true then
						if RSA.db.profile.Shaman.Spells.AncestralProtection.SmartGroup == true and GetNumGroupMembers() > 0 then return end
						RSA.Print_Raid(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
				end
			end -- Ancestral Protection Totem
			if destGUID == EarthenShield_GUID then -- Earthen Shield Totem
				spellinfo = GetSpellInfo(198838) spelllinkinfo = GetSpellLink(198838)
				RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
				local messagemax = #RSA.db.profile.Shaman.Spells.EarthenShieldTotem.Messages.End
				if messagemax == 0 then return end
				local messagerandom = math.random(messagemax)
				local message = RSA.db.profile.Shaman.Spells.EarthenShieldTotem.Messages.End[messagerandom]
				if message ~= "" then
					if RSA.db.profile.Shaman.Spells.EarthenShieldTotem.Local == true then
						RSA.Print_LibSink(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.EarthenShieldTotem.Yell == true then
						RSA.Print_Yell(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.EarthenShieldTotem.CustomChannel.Enabled == true then
						RSA.Print_Channel(string.gsub(message, ".%a+.", RSA.String_Replace), RSA.db.profile.Shaman.Spells.EarthenShieldTotem.CustomChannel.Channel)
					end
					if RSA.db.profile.Shaman.Spells.EarthenShieldTotem.Say == true then
						RSA.Print_Say(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.EarthenShieldTotem.SmartGroup == true then
						RSA.Print_SmartGroup(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.EarthenShieldTotem.Party == true then
						if RSA.db.profile.Shaman.Spells.EarthenShieldTotem.SmartGroup == true and GetNumGroupMembers() == 0 then return end
							RSA.Print_Party(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.EarthenShieldTotem.Raid == true then
						if RSA.db.profile.Shaman.Spells.EarthenShieldTotem.SmartGroup == true and GetNumGroupMembers() > 0 then return end
						RSA.Print_Raid(string.gsub(message, ".%a+.", RSA.String_Replace))
					end
				end
			end -- Earthen Shield Totem
		end -- IF EVENT IS UNIT_DIED		
	end -- END ENTIRELY
	RSA.CombatLogMonitor:SetScript("OnEvent", Shaman_Spells)
end

function RSA_Shaman:OnDisable()
	RSA.CombatLogMonitor:SetScript("OnEvent", nil)
	if LRI then LRI.UnregisterAllCallbacks(RSA) end
end
