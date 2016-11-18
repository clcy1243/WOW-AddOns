-----------------------------------------------
---- Raeli's Spell Announcer Shaman Module ----
-----------------------------------------------
local RSA = LibStub("AceAddon-3.0"):GetAddon("RSA")
local L = LibStub("AceLocale-3.0"):GetLocale("RSA")
local RSA_Shaman = RSA:NewModule("Shaman")
function RSA_Shaman:OnInitialize()
	if RSA.db.profile.General.Class == "SHAMAN" then
		RSA_Shaman:SetEnabledState(true)
	else
		RSA_Shaman:SetEnabledState(false)
	end
end -- End OnInitialize
local spellinfo,spelllinkinfo,extraspellinfo,extraspellinfolink,missinfo
local SpiritLink_GUID,WindRush_GUID,Protection_GUID,Protection_Cast,LightningSurge_GUID,LightningCounter,Cloudburst_GUID,EarthenShield_GUID,Cloudburst_Announced
local ShamanSpells = RSA.db.profile.Shaman.Spells
function RSA_Shaman:OnEnable()
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
		SPELL_CAST_START = {
			[212048] = { -- ANCESTRAL VISION
				profile = 'AncestralVision'
			},
		},
		SPELL_CAST_SUCCESS = {
			[212048] = { -- ANCESTRAL VISION
				profile = 'AncestralVision',
				section = 'End'
			},
			[198103] = { -- EARTH ELEMENTAL
				profile = 'EarthElemental'
			},
			[98008] = { -- SPIRIT LINK TOTEM
				profile = 'SpiritLink'
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
				profile = 'Thunderstorm'
			},
			[108281] = { -- ANCESTRAL GUIDANCE
				profile = 'AncestralGuidance'
			},
			[108271] = { -- ASTRAL SHIFT
				profile = 'AstralShift'
			},
			[51533] = { -- FERAL SPIRIT
				profile = 'FeralSpirit'
			},
			[21169] = { -- REINCARNATION
				profile = 'Reincarnation'
			},
			[207399] = { -- Ancestral Protection Totem
				profile = 'AncestralProtection'
			},
		--[[	[207553] = { -- Ancestral Protection Totem
				profile = 'AncestralProtection',
				linkID = 207399,
				replacements = { SOURCE = 1},
				section = 'Success'
			},]]--
			[192058] = { -- Lightning Surge Totem
				profile = 'LightningSurge'
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
			[118291] = { -- FIRE ELEMENTAL
				profile = 'FireElemental',
				linkID = 198067,
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
				replacements = { TARGET = 1, extraSpellName = "[AURA]", extraSpellLink = "[AURALINK]" }
			},
			[51886] = { -- CLEANSE SPIRIT
				profile = 'CleanseSpirit',
				replacements = { TARGET = 1, extraSpellName = "[AURA]", extraSpellLink = "[AURALINK]" }
			},
			[77130] = { -- PURIFY SPIRIT
				profile = 'CleanseSpirit',
				replacements = { TARGET = 1, extraSpellName = "[AURA]", extraSpellLink = "[AURALINK]" }
			},
		},
		SPELL_DISPEL_FAILED = {
			[370] = { -- PURGE
				profile = 'Purge',
				section = 'End',
				replacements = { TARGET = 1, extraSpellName = "[AURA]", extraSpellLink = "[AURALINK]" }
			},
		},
		SPELL_INTERRUPT = {
			[57994] = { -- WIND SHEAR
				profile = 'WindShear',
				replacements = { TARGET = 1, extraSpellName = "[TARSPELL]", extraSpellLink = "[TARLINK]" }
			},
		},
		SPELL_MISSED = {
			[57994] = {-- WIND SHEAR
				profile = 'WindShear',
				section = 'End',
				immuneSection = "Immune",
				replacements = { TARGET = 1, MISSTYPE = 1 },
			},
		},
	}
	RSA.MonitorConfig(MonitorConfig_Shaman, UnitGUID("player"))
	local MonitorAndAnnounce = RSA.MonitorAndAnnounce
	local ResTarget = L["Unknown"]
	local Ressed
	local function Shaman_Spells(self, _, timestamp, event, hideCaster, sourceGUID, source, sourceFlags, sourceRaidFlag, destGUID, dest, destFlags, destRaidFlags, spellID, spellName, spellSchool, missType, ex2, ex3, ex4)
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
					Cloudburst_GUID = destGUID return
				end
				if spellID == 198838 then -- Earthen Shield Totem
					EarthenShield_GUID = destGUID return
				end
			end -- IF EVENT IS SPELL_SUMMON
			if event == "SPELL_CAST_SUCCESS" and spellID == 201764 then -- Recall Cloudburst Totem
				Cloudburst_Announced = true
			end
			if event == "SPELL_HEAL" and spellID == 157503 then -- Cloudburst Totem Heal
				if Cloudburst_Announced == true then return end
				spellinfo = GetSpellInfo(157153) spelllinkinfo = GetSpellLink(157153)
				RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
				if ShamanSpells.Cloudburst.Messages.End ~= "" then
					if ShamanSpells.Cloudburst.Local == true then
						RSA.Print_LibSink(string.gsub(ShamanSpells.Cloudburst.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.Cloudburst.Yell == true then
						RSA.Print_Yell(string.gsub(ShamanSpells.Cloudburst.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.Cloudburst.CustomChannel.Enabled == true then
						RSA.Print_Channel(string.gsub(ShamanSpells.Cloudburst.Messages.End, ".%a+.", RSA.String_Replace), ShamanSpells.Cloudburst.CustomChannel.Channel)
					end
					if ShamanSpells.Cloudburst.Say == true then
						RSA.Print_Say(string.gsub(ShamanSpells.Cloudburst.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.Cloudburst.SmartGroup == true then
						RSA.Print_SmartGroup(string.gsub(ShamanSpells.Cloudburst.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.Cloudburst.Party == true then
						if ShamanSpells.Cloudburst.SmartGroup == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
						RSA.Print_Party(string.gsub(ShamanSpells.Cloudburst.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.Cloudburst.Raid == true then
						if ShamanSpells.Cloudburst.SmartGroup == true and GetNumGroupMembers() > 0 then return end
						RSA.Print_Raid(string.gsub(ShamanSpells.Cloudburst.Messages.End, ".%a+.", RSA.String_Replace))
					end
				end
			end
			MonitorAndAnnounce(self, _, timestamp, event, hideCaster, sourceGUID, source, sourceFlags, sourceRaidFlag, destGUID, dest, destFlags, destRaidFlags, spellID, spellName, spellSchool, missType, ex2, ex3, ex4)
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
			if ShamanSpells.AncestralProtection.Messages.Success ~= "" then
				if ShamanSpells.AncestralProtection.Local == true then
					RSA.Print_LibSink(string.gsub(ShamanSpells.AncestralProtection.Messages.Success, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.AncestralProtection.Yell == true then
					RSA.Print_Yell(string.gsub(ShamanSpells.AncestralProtection.Messages.Success, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.AncestralProtection.CustomChannel.Enabled == true then
					RSA.Print_Channel(string.gsub(ShamanSpells.AncestralProtection.Messages.Success, ".%a+.", RSA.String_Replace), ShamanSpells.AncestralProtection.CustomChannel.Channel)
				end
				if ShamanSpells.AncestralProtection.Say == true then
					RSA.Print_Say(string.gsub(ShamanSpells.AncestralProtection.Messages.Success, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.AncestralProtection.SmartGroup == true then
					RSA.Print_SmartGroup(string.gsub(ShamanSpells.AncestralProtection.Messages.Success, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.AncestralProtection.Party == true then
					if ShamanSpells.AncestralProtection.SmartGroup == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
					RSA.Print_Party(string.gsub(ShamanSpells.AncestralProtection.Messages.Success, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.AncestralProtection.Raid == true then
					if ShamanSpells.AncestralProtection.SmartGroup == true and GetNumGroupMembers() > 0 then return end
					RSA.Print_Raid(string.gsub(ShamanSpells.AncestralProtection.Messages.Success, ".%a+.", RSA.String_Replace))
				end
			end
		end
		if event == "SPELL_CAST_SUCCESS" and sourceGUID == LightningSurge_GUID and spellID == 118905 then -- Lightning Surge Totem
			spellinfo = GetSpellInfo(118905) spelllinkinfo = GetSpellLink(118905)
			RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
			if ShamanSpells.LightningSurge.Messages.Success ~= "" and LightningCounter == 0 then
				if ShamanSpells.LightningSurge.Local == true then
					RSA.Print_LibSink(string.gsub(ShamanSpells.LightningSurge.Messages.Success, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.LightningSurge.Yell == true then
					RSA.Print_Yell(string.gsub(ShamanSpells.LightningSurge.Messages.Success, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.LightningSurge.CustomChannel.Enabled == true then
					RSA.Print_Channel(string.gsub(ShamanSpells.LightningSurge.Messages.Success, ".%a+.", RSA.String_Replace), ShamanSpells.LightningSurge.CustomChannel.Channel)
				end
				if ShamanSpells.LightningSurge.Say == true then
					RSA.Print_Say(string.gsub(ShamanSpells.LightningSurge.Messages.Success, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.LightningSurge.SmartGroup == true then
					RSA.Print_SmartGroup(string.gsub(ShamanSpells.LightningSurge.Messages.Success, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.LightningSurge.Party == true then
					if ShamanSpells.LightningSurge.SmartGroup == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
					RSA.Print_Party(string.gsub(ShamanSpells.LightningSurge.Messages.Success, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.LightningSurge.Raid == true then
					if ShamanSpells.LightningSurge.SmartGroup == true and GetNumGroupMembers() > 0 then return end
					RSA.Print_Raid(string.gsub(ShamanSpells.LightningSurge.Messages.Success, ".%a+.", RSA.String_Replace))
				end
			end
			LightningCounter = LightningCounter +1
		end
		if event == "SPELL_AURA_REMOVED" and sourceGUID == LightningSurge_GUID and spellID == 118905 then -- Lightning Surge Totem
			spellinfo = GetSpellInfo(118905) spelllinkinfo = GetSpellLink(118905)
			RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
			LightningCounter = LightningCounter -1
			if ShamanSpells.LightningSurge.Messages.End ~= "" and LightningCounter == 0 then
				if ShamanSpells.LightningSurge.Local == true then
					RSA.Print_LibSink(string.gsub(ShamanSpells.LightningSurge.Messages.End, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.LightningSurge.Yell == true then
					RSA.Print_Yell(string.gsub(ShamanSpells.LightningSurge.Messages.End, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.LightningSurge.CustomChannel.Enabled == true then
					RSA.Print_Channel(string.gsub(ShamanSpells.LightningSurge.Messages.End, ".%a+.", RSA.String_Replace), ShamanSpells.LightningSurge.CustomChannel.Channel)
				end
				if ShamanSpells.LightningSurge.Say == true then
					RSA.Print_Say(string.gsub(ShamanSpells.LightningSurge.Messages.End, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.LightningSurge.SmartGroup == true then
					RSA.Print_SmartGroup(string.gsub(ShamanSpells.LightningSurge.Messages.End, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.LightningSurge.Party == true then
					if ShamanSpells.LightningSurge.SmartGroup == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
					RSA.Print_Party(string.gsub(ShamanSpells.LightningSurge.Messages.End, ".%a+.", RSA.String_Replace))
				end
				if ShamanSpells.LightningSurge.Raid == true then
					if ShamanSpells.LightningSurge.SmartGroup == true and GetNumGroupMembers() > 0 then return end
					RSA.Print_Raid(string.gsub(ShamanSpells.LightningSurge.Messages.End, ".%a+.", RSA.String_Replace))
				end
			end
		end
		if event == "UNIT_DIED" then -- Unit source isn't player. GUID tracking used to ensure we only announce our own. 
			if destGUID == SpiritLink_GUID then -- SPIRIT LINK TOTEM
				spellinfo = GetSpellInfo(98008) spelllinkinfo = GetSpellLink(98008)
				RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
				if RSA.db.profile.Shaman.Spells.SpiritLink.Messages.End ~= "" then
					if RSA.db.profile.Shaman.Spells.SpiritLink.Local == true then
						RSA.Print_LibSink(string.gsub(RSA.db.profile.Shaman.Spells.SpiritLink.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.SpiritLink.Yell == true then
						RSA.Print_Yell(string.gsub(RSA.db.profile.Shaman.Spells.SpiritLink.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.SpiritLink.CustomChannel.Enabled == true then
						RSA.Print_Channel(string.gsub(RSA.db.profile.Shaman.Spells.SpiritLink.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Shaman.Spells.SpiritLink.CustomChannel.Channel)
					end
					if RSA.db.profile.Shaman.Spells.SpiritLink.Say == true then
						RSA.Print_Say(string.gsub(RSA.db.profile.Shaman.Spells.SpiritLink.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.SpiritLink.SmartGroup == true then
						RSA.Print_SmartGroup(string.gsub(RSA.db.profile.Shaman.Spells.SpiritLink.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.SpiritLink.Party == true then
						if RSA.db.profile.Shaman.Spells.SpiritLink.SmartGroup == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
						RSA.Print_Party(string.gsub(RSA.db.profile.Shaman.Spells.SpiritLink.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.SpiritLink.Raid == true then
						if RSA.db.profile.Shaman.Spells.SpiritLink.SmartGroup == true and GetNumGroupMembers() > 0 then return end
						RSA.Print_Raid(string.gsub(RSA.db.profile.Shaman.Spells.SpiritLink.Messages.End, ".%a+.", RSA.String_Replace))
					end
				end
			end -- SPIRIT LINK TOTEM
			if destGUID == WindRush_GUID then -- WINDRUSH TOTEM
				spellinfo = GetSpellInfo(192077) spelllinkinfo = GetSpellLink(192077)
				RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
				if RSA.db.profile.Shaman.Spells.WindRushTotem.Messages.End ~= "" then
					if RSA.db.profile.Shaman.Spells.WindRushTotem.Local == true then
						RSA.Print_LibSink(string.gsub(RSA.db.profile.Shaman.Spells.WindRushTotem.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.WindRushTotem.Yell == true then
						RSA.Print_Yell(string.gsub(RSA.db.profile.Shaman.Spells.WindRushTotem.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.WindRushTotem.CustomChannel.Enabled == true then
						RSA.Print_Channel(string.gsub(RSA.db.profile.Shaman.Spells.WindRushTotem.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Shaman.Spells.WindRushTotem.CustomChannel.Channel)
					end
					if RSA.db.profile.Shaman.Spells.WindRushTotem.Say == true then
						RSA.Print_Say(string.gsub(RSA.db.profile.Shaman.Spells.WindRushTotem.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.WindRushTotem.SmartGroup == true then
						RSA.Print_SmartGroup(string.gsub(RSA.db.profile.Shaman.Spells.WindRushTotem.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.WindRushTotem.Party == true then
						if RSA.db.profile.Shaman.Spells.WindRushTotem.SmartGroup == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
						RSA.Print_Party(string.gsub(RSA.db.profile.Shaman.Spells.WindRushTotem.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Shaman.Spells.WindRushTotem.Raid == true then
						if RSA.db.profile.Shaman.Spells.WindRushTotem.SmartGroup == true and GetNumGroupMembers() > 0 then return end
						RSA.Print_Raid(string.gsub(RSA.db.profile.Shaman.Spells.WindRushTotem.Messages.End, ".%a+.", RSA.String_Replace))
					end
				end
			end -- WINDRUSH TOTEM
			if destGUID == Protection_GUID then -- Ancestral Protection Totem
				Protection_Cast = false
				--print("died, cast = false")
				spellinfo = GetSpellInfo(207495) spelllinkinfo = GetSpellLink(207495)
				RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
				if ShamanSpells.AncestralProtection.Messages.End ~= "" then
					if ShamanSpells.AncestralProtection.Local == true then
						RSA.Print_LibSink(string.gsub(ShamanSpells.AncestralProtection.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.AncestralProtection.Yell == true then
						RSA.Print_Yell(string.gsub(ShamanSpells.AncestralProtection.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.AncestralProtection.CustomChannel.Enabled == true then
						RSA.Print_Channel(string.gsub(ShamanSpells.AncestralProtection.Messages.End, ".%a+.", RSA.String_Replace), ShamanSpells.AncestralProtection.CustomChannel.Channel)
					end
					if ShamanSpells.AncestralProtection.Say == true then
						RSA.Print_Say(string.gsub(ShamanSpells.AncestralProtection.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.AncestralProtection.SmartGroup == true then
						RSA.Print_SmartGroup(string.gsub(ShamanSpells.AncestralProtection.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.AncestralProtection.Party == true then
						if ShamanSpells.AncestralProtection.SmartGroup == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
						RSA.Print_Party(string.gsub(ShamanSpells.AncestralProtection.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.AncestralProtection.Raid == true then
						if ShamanSpells.AncestralProtection.SmartGroup == true and GetNumGroupMembers() > 0 then return end
						RSA.Print_Raid(string.gsub(ShamanSpells.AncestralProtection.Messages.End, ".%a+.", RSA.String_Replace))
					end
				end
			end -- Ancestral Protection Totem
			if destGUID == Cloudburst_GUID then -- Cloudburst Totem
				if Cloudburst_Announced == true then return end
				Cloudburst_Announced = true
				spellinfo = GetSpellInfo(157153) spelllinkinfo = GetSpellLink(157153)
				RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
				if ShamanSpells.Cloudburst.Messages.End ~= "" then
					if ShamanSpells.Cloudburst.Local == true then
						RSA.Print_LibSink(string.gsub(ShamanSpells.Cloudburst.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.Cloudburst.Yell == true then
						RSA.Print_Yell(string.gsub(ShamanSpells.Cloudburst.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.Cloudburst.CustomChannel.Enabled == true then
						RSA.Print_Channel(string.gsub(ShamanSpells.Cloudburst.Messages.End, ".%a+.", RSA.String_Replace), ShamanSpells.Cloudburst.CustomChannel.Channel)
					end
					if ShamanSpells.Cloudburst.Say == true then
						RSA.Print_Say(string.gsub(ShamanSpells.Cloudburst.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.Cloudburst.SmartGroup == true then
						RSA.Print_SmartGroup(string.gsub(ShamanSpells.Cloudburst.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.Cloudburst.Party == true then
						if ShamanSpells.Cloudburst.SmartGroup == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
						RSA.Print_Party(string.gsub(ShamanSpells.Cloudburst.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.Cloudburst.Raid == true then
						if ShamanSpells.Cloudburst.SmartGroup == true and GetNumGroupMembers() > 0 then return end
						RSA.Print_Raid(string.gsub(ShamanSpells.Cloudburst.Messages.End, ".%a+.", RSA.String_Replace))
					end
				end
			end -- Cloudburst Totem
			if destGUID == EarthenShield_GUID then -- Earthen Shield Totem
				spellinfo = GetSpellInfo(198838) spelllinkinfo = GetSpellLink(198838)
				RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
				if ShamanSpells.EarthenShieldTotem.Messages.End ~= "" then
					if ShamanSpells.EarthenShieldTotem.Local == true then
						RSA.Print_LibSink(string.gsub(ShamanSpells.EarthenShieldTotem.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.EarthenShieldTotem.Yell == true then
						RSA.Print_Yell(string.gsub(ShamanSpells.EarthenShieldTotem.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.EarthenShieldTotem.CustomChannel.Enabled == true then
						RSA.Print_Channel(string.gsub(ShamanSpells.EarthenShieldTotem.Messages.End, ".%a+.", RSA.String_Replace), ShamanSpells.EarthenShieldTotem.CustomChannel.Channel)
					end
					if ShamanSpells.EarthenShieldTotem.Say == true then
						RSA.Print_Say(string.gsub(ShamanSpells.EarthenShieldTotem.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.EarthenShieldTotem.SmartGroup == true then
						RSA.Print_SmartGroup(string.gsub(ShamanSpells.EarthenShieldTotem.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.EarthenShieldTotem.Party == true then
						if ShamanSpells.EarthenShieldTotem.SmartGroup == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
						RSA.Print_Party(string.gsub(ShamanSpells.EarthenShieldTotem.Messages.End, ".%a+.", RSA.String_Replace))
					end
					if ShamanSpells.EarthenShieldTotem.Raid == true then
						if ShamanSpells.EarthenShieldTotem.SmartGroup == true and GetNumGroupMembers() > 0 then return end
						RSA.Print_Raid(string.gsub(ShamanSpells.EarthenShieldTotem.Messages.End, ".%a+.", RSA.String_Replace))
					end
				end
			end -- Earthen Shield Totem
		end -- IF EVENT IS UNIT_DIED		
	end -- END ENTIRELY
	RSA.CombatLogMonitor:SetScript("OnEvent", Shaman_Spells)
	------------------------------
	---- Resurrection Monitor ----
	------------------------------
	local function Shaman_AncestralSpirit(_, event, source, spell, rank, dest, _)
		if UnitName(source) == pName then
			if spell == GetSpellInfo(2008) and RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.Start ~= "" then -- ANCESTRAL SPIRIT
				if event == "UNIT_SPELLCAST_SENT" then
					Ressed = false
					if (dest == L["Unknown"] or dest == nil) then
						if UnitExists("target") ~= 1 or (UnitHealth("target") > 1 and UnitIsDeadOrGhost("target") ~= 1) then
							if GameTooltipTextLeft1:GetText() == nil then
								dest = L["Unknown"]
								ResTarget = L["Unknown"]
							else
								dest = string.gsub(GameTooltipTextLeft1:GetText(), L["Corpse of "], "")
								ResTarget = string.gsub(GameTooltipTextLeft1:GetText(), L["Corpse of "], "")
							end
						else
							dest = UnitName("target")
							ResTarget = UnitName("target")
						end
					else
						ResTarget = dest
					end
					local full_destName,dest = RSA.RemoveServerNames(ResTarget)
					spellinfo = GetSpellInfo(spell) spelllinkinfo = GetSpellLink(spell)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.Start ~= "" then
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.Whisper == true and dest ~= pName then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.Start, ".%a+.", RSA.String_Replace), full_destName)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Shaman.Spells.AncestralSpirit.CustomChannel.Channel)
						end
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.SmartGroup == true then
							RSA.Print_SmartGroup(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.Party == true then
							if RSA.db.profile.Shaman.Spells.AncestralSpirit.SmartGroup == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
							RSA.Print_Party(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.Raid == true then
							if RSA.db.profile.Shaman.Spells.AncestralSpirit.SmartGroup == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				elseif event == "UNIT_SPELLCAST_SUCCEEDED" and Ressed ~= true then
					dest = ResTarget
					Ressed = true
					local full_destName,dest = RSA.RemoveServerNames(dest)		
					if RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.End ~= "" then
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.Whisper == true and dest ~= pName then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.End, ".%a+.", RSA.String_Replace), full_destName)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Shaman.Spells.AncestralSpirit.CustomChannel.Channel)
						end
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.SmartGroup == true then
							RSA.Print_SmartGroup(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.Party == true then
							if RSA.db.profile.Shaman.Spells.AncestralSpirit.SmartGroup == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
							RSA.Print_Party(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Shaman.Spells.AncestralSpirit.Raid == true then
							if RSA.db.profile.Shaman.Spells.AncestralSpirit.SmartGroup == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Shaman.Spells.AncestralSpirit.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end
			end -- ANCESTRAL SPIRIT
		end
	end -- END FUNCTION
	RSA.ResMon = RSA.ResMon or CreateFrame("Frame", "RSA:RM")
	RSA.ResMon:RegisterEvent("UNIT_SPELLCAST_SENT")
	RSA.ResMon:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	RSA.ResMon:SetScript("OnEvent", Shaman_AncestralSpirit)
end -- END ON ENABLED
function RSA_Shaman:OnDisable()
	RSA.CombatLogMonitor:SetScript("OnEvent", nil)
	RSA.ResMon:SetScript("OnEvent", nil)
end