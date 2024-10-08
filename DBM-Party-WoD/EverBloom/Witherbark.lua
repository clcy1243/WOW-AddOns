local mod	= DBM:NewMod(1214, "DBM-Party-WoD", 5, 556)
local L		= mod:GetLocalizedStrings()
local wowToc = DBM:GetTOC()

mod.statTypes = "normal,heroic,mythic,challenge,timewalker"

if (wowToc >= 100200) then
	mod.upgradedMPlus = true
	mod.sendMainBossGUID = true
end

mod:SetRevision("20240714045506")
mod:SetCreatureID(81522)
mod:SetEncounterID(1746)
mod:SetHotfixNoticeRev(20231020000000)
--mod:SetMinSyncRevision(20211203000000)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 164357",
--	"SPELL_CAST_SUCCESS 164302",
	"SPELL_SUMMON 164556",
	"SPELL_AURA_APPLIED 164275 164302",
	"SPELL_AURA_REMOVED 164275",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
--	"CHAT_MSG_MONSTER_EMOTE",
--	"RAID_BOSS_WHISPER"
)

--[[
ability.id = 164357 and type = "begincast"
 or ability.id = 164302 and type = "cast"
 or ability.id = 164275 and (type = "applybuff" or type = "removebuff")
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
 or ability.id = 181113 and type = "cast"
 or (source.type = "NPC" and source.firstSeen = timestamp) or (target.type = "NPC" and target.firstSeen = timestamp)
--]]
--NOTE: Mod is just using 10.2 values, since fight wasn't reworked i'm not making a hybrid mod for timers that have slight differences
local warnBrittleBark				= mod:NewSpellAnnounce(164275, 1)
local warnBrittleBarkOver			= mod:NewEndAnnounce(164275, 2)
local warnUncheckedGrowth			= mod:NewTargetAnnounce(164294, 2)
local warnUncheckedGrowthSpawn		= mod:NewSpellAnnounce(164556, 3)--Add Spawn

local specWarnUncheckedGrowthYou	= mod:NewSpecialWarningYou(164294, nil, nil, nil, 1, 2)--The add fixate is on you
local specWarnUncheckedGrowth		= mod:NewSpecialWarningGTFO(164294, nil, nil, nil, 1, 8)--GTFO
local specWarnUncheckedGrowthAdd	= mod:NewSpecialWarningSwitch(164556, false, nil, nil, 1, 2)--Spawn
local specWarnParchedGrasp			= mod:NewSpecialWarningSpell(164357, "Tank", nil, nil, 1, 2)

local timerParchedGrasp				= mod:NewCDTimer(16, 164357, nil, "Tank", 2, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerBrittleBarkCD			= mod:NewCDTimer(40, 164275, nil, nil, nil, 6)--30 seconds pre 10.2 https://www.warcraftlogs.com/reports/y2cYmZVWKqGkAHbn#fight=last&pins=2%24Off%24%23244F4B%24expression%24ability.id%20%3D%20164275%20or%20ability.id%20%3D%20164556&view=events&translate=true
local timerUncheckedGrowthCD		= mod:NewCDTimer(12, 164294, nil, nil, nil, 3)--LW uses spellid and not joural ID for timer, so we have to match it for WAs

--mod:GroupSpells(164294, -10098)--No longer combined since each needs a diff WA key in UI now

function mod:OnCombatStart(delay)
	timerUncheckedGrowthCD:Start(6-delay)
	timerParchedGrasp:Start(9.6-delay)
	timerBrittleBarkCD:Start(39.9-delay)
	if not self:IsTrivial() then
		self:RegisterShortTermEvents(
			"SPELL_PERIODIC_DAMAGE 169495 164294",
			"SPELL_PERIODIC_MISSED 169495 164294"
		)
	end
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 164357 then
		specWarnParchedGrasp:Show()
		specWarnParchedGrasp:Play("breathsoon")
		timerParchedGrasp:Start()
	end
end

--[[
function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 164302 then
		timerUncheckedGrowthCD:Start()
	end
end
--]]

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 164556 and self:AntiSpam(4, 1) then
		if self.Options.SpecWarn164556switch then
			specWarnUncheckedGrowthAdd:Show()
			specWarnUncheckedGrowthAdd:Play("killmob")
		else
			warnUncheckedGrowthSpawn:Show()
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 164275 then
		warnBrittleBark:Show()
		timerParchedGrasp:Cancel()
		if self:IsNormal() then--Heroic and above CD continues without reset
			timerUncheckedGrowthCD:Stop()
		end
	elseif spellId == 164302 then
		if args:IsPlayer() then
			specWarnUncheckedGrowthYou:Show()
			specWarnUncheckedGrowthYou:Play("targetyou")
		else
			warnUncheckedGrowth:Show(args.destName)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 164275 then
		warnBrittleBarkOver:Show()
		timerParchedGrasp:Start(3.6)
		timerBrittleBarkCD:Start(39.9)
		timerUncheckedGrowthCD:Stop()
		timerUncheckedGrowthCD:Start(3.6)--Needs more review to verify
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, destName, _, _, spellId, spellName)
	if (spellId == 169495 or spellId == 164294) and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then--Deprecated?
		specWarnUncheckedGrowth:Show(spellName)
		specWarnUncheckedGrowth:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 164306 then
		timerUncheckedGrowthCD:Start()
	end
end

--[[
function mod:CHAT_MSG_MONSTER_EMOTE(msg)--Message doesn't matter, it occurs only for one thing during this fight (assumption may be invalid in rework)
	if self.Options["SpecWarn-10098switch"] then
		specWarnUncheckedGrowthAdd:Show()
		specWarnUncheckedGrowthAdd:Play("killmob")
	else
		warnUncheckedGrowth:Show()
	end
end

function mod:RAID_BOSS_WHISPER()
	specWarnUncheckedGrowthYou:Show()
	specWarnUncheckedGrowthYou:Play("targetyou")
end
--]]
