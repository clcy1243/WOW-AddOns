local RSA = LibStub("AceAddon-3.0"):GetAddon("RSA")
local L = LibStub("AceLocale-3.0"):GetLocale("RSA")

local gsub = string.gsub

local config, playerGUID

local cache_SpellInfo = {}
local cache_SpellLink = {}

local function MonitorConfig(new_config, new_playerGUID)
	config = new_config
	playerGUID = new_playerGUID
end

local empty = {}
local replacements = {}
local running = {}

local function WipeCache()
	wipe(cache_SpellInfo)
	wipe(cache_SpellLink)
end

local function MonitorAndAnnounce(self, _, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlag, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool, ex1, ex2, ex3, ex4)
	local extraSpellID, extraSpellName, extraSchool = ex1, ex2, ex3
	local missType = ex1
	local full_destName = destName

	if RSA.db.profile.General.GlobalAnnouncements.RemoveServerNames == true then
		if destName then
			destName = gsub(destName, "-.*", "")
		end
	end

	local event_data = config[event]

	if not event_data then return end

	local spell_data = event_data[spellID]

	if event == 'SPELL_DISPEL' or event == 'SPELL_STOLEN' then
		if not spell_data then
			spellID, extraSpellID = extraSpellID, spellID
			spellName, extraSpellName = extraSpellName, spellName
			spellSchool, extraSchool = extraSchool, spellSchool
			spell_data = event_data[spellID]
		end
	end

	if not spell_data then return end

	if spell_data.targetIsMe and not RSA.IsMe(destFlags) then return end
	if spell_data.targetNotMe and RSA.IsMe(destFlags) then return end

	if false --[[detect player/pet]] then return end
	
	local spell_tracker = spell_data.profile
	local tracker = spell_data.tracker or -1	-- Tracks spells like AoE Taunts to prevent multiple messages playing.
	if tracker == 1 and running[spell_tracker] == nil then return end -- Prevent announcement if we didn't start the tracker (i.e Tank Metamorphosis random procs from Artifact)
	if tracker == 1 and running[spell_tracker] >= 500 then return end -- Prevent second announcement of buff/debuff removal.

	if tracker == 2 then -- [31850].tracker = 2
		if running[spell_tracker] ~= nil then
			if running[spell_tracker] >= 0 and running[spell_tracker] < 500 then -- Prevent second announcement of buff/debuff application.				
				running[spell_tracker] = running[spell_tracker] + 1
				--print(spell_tracker .. "+1:" .. running[spell_tracker])
				return 
			end
		end		
		running[spell_tracker] = 0 -- running[ArdentDefender] = 1
		--print(spell_tracker .. " SET:" .. running[spell_tracker])
	end	
	if tracker == 1 and running[spell_tracker] == 0 then
		running[spell_tracker] = running[spell_tracker] + 500
		--print(spell_tracker .. "+500:" .. running[spell_tracker])
	end
	if tracker == 1 and running[spell_tracker] > 0 and running[spell_tracker] < 500 then
		running[spell_tracker] = running[spell_tracker] - 1
		--print(spell_tracker .. "-1:" .. running[spell_tracker])
		return 
	end		

	if spell_data.linkID ~= nil then
		spellinfo = GetSpellInfo(spell_data.linkID)
		cache_SpellInfo[spellID] = spellinfo 
		
		spelllink = GetSpellLink(spell_data.linkID)
		cache_SpellLink[spellID] = spelllink 	
	end
	
	local spellinfo = cache_SpellInfo[spellID]	
	if not spellinfo then 
		if not spell_data.linkID then
			spellinfo = GetSpellInfo(spellID)
			cache_SpellInfo[spellID] = spellinfo
		else
			spellinfo = GetSpellInfo(spell_data.linkID)
			cache_SpellInfo[spellID] = spellinfo 
		end	
	end
	
	local spelllink = cache_SpellLink[spellID]
	if not spelllink then
		if not spell_data.linkID then
			spelllink = GetSpellLink(spellID)
			cache_SpellLink[spellID] = spelllink
		else
			spelllink = GetSpellLink(spell_data.linkID)
			cache_SpellLink[spellID] = spelllink 
		end
	end

	wipe(replacements)

	replacements["[SPELL]"] = spellinfo
	replacements["[LINK]"] = spelllink

	local spell_replacements = spell_data.replacements or empty
	if spell_replacements.TARGET then replacements["[TARGET]"] = destName end
	if spell_replacements.SOURCE then replacements["[TARGET]"] = sourceName end

	local extraSpellNameTarget = spell_replacements.extraSpellName
	if extraSpellNameTarget then
		local spellinfo = cache_SpellInfo[extraSpellID] if not spellinfo then spellinfo = GetSpellInfo(extraSpellID) cache_SpellInfo[extraSpellID] = spellinfo end
		replacements[extraSpellNameTarget] = spellinfo
	end

	local extraSpellLinkTarget = spell_replacements.extraSpellLink
	if extraSpellLinkTarget then
		local spelllink = cache_SpellLink[extraSpellID] if not spelllink then spelllink = GetSpellLink(extraSpellID) cache_SpellLink[extraSpellID] = spelllink end
		replacements[extraSpellLinkTarget] = spelllink
	end

	local spell_profile = config.player_profile.Spells[spell_data.profile]

	local message = spell_profile.Messages[spell_data.section or 'Start']
	if spell_replacements.MISSTYPE then
		if missType == "IMMUNE" then
			replacements["[MISSTYPE]"] = L["Immune"]
			if spell_profile.Messages[spell_data.immuneSection] then
				message = spell_profile.Messages[spell_data.immuneSection]
			end
		elseif missType == "MISS" then
			replacements["[MISSTYPE]"] = L["missed"]
		elseif missType == "RESIST" then
			replacements["[MISSTYPE]"] = L["was resisted by"]
		elseif missType == "ABSORB" then
			replacements["[MISSTYPE]"] = L["was absorbed by"]
		elseif missType == "BLOCK" then
			replacements["[MISSTYPE]"] = L["was blocked by"]
		elseif missType == "DEFLECT" then
			replacements["[MISSTYPE]"] = L["was deflected by"]
		elseif missType == "DODGE" then
			replacements["[MISSTYPE]"] = L["was dodged by"]
		elseif missType == "EVADE" then
			replacements["[MISSTYPE]"] = L["was evaded by"]
		elseif missType == "PARRY" then
			replacements["[MISSTYPE]"] = L["was parried by"]
		end
	end

	if spell_replacements.AMOUNT then
		replacements["[AMOUNT]"] = ex1 -- ex1 is also missType
	end
	
	if message ~= "" then
		if spell_profile.Local == true then
			RSA.Print_LibSink(gsub(message, ".%a+.", replacements))
		end
		if spell_profile.Yell == true then
			RSA.Print_Yell(gsub(message, ".%a+.", replacements))
		end
		if spell_profile.Whisper == true and UnitExists(full_destName) and RSA.Whisperable(destFlags) then
			replacements["[TARGET]"] = L["You"]
			RSA.Print_Whisper(gsub(message, ".%a+.", replacements), full_destName)
			replacements["[TARGET]"] = destName
		end
		if spell_profile.CustomChannel and spell_profile.CustomChannel.Enabled == true then
			RSA.Print_Channel(gsub(message, ".%a+.", replacements), spell_profile.CustomChannel.Channel)
		end
		if spell_profile.Say == true then
				RSA.Print_Say(gsub(message, ".%a+.", replacements))			
		end
		if spell_profile.SmartGroup == true then
			RSA.Print_SmartGroup(gsub(message, ".%a+.", replacements))
		end
		if spell_profile.Party == true then
			if spell_profile.SmartGroup == true and GetNumGroupMembers() > 0 and InstanceType ~= "arena" then return end
			RSA.Print_Party(gsub(message, ".%a+.", replacements))
		end
		if spell_profile.Raid == true then
			if spell_profile.SmartGroup == true and GetNumGroupMembers() > 0 then return end
			RSA.Print_Raid(gsub(message, ".%a+.", replacements))
		end
		if spell_profile.BossBars == true then
			RSA.BossBars(gsub(message, ".%a+.", replacements))
		end
	end

end

RSA.MonitorConfig = MonitorConfig
RSA.MonitorAndAnnounce = MonitorAndAnnounce
RSA.WipeCache = WipeCache