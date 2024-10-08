local mod = DBM:NewMod(563, "DBM-Party-BC", 13, 258)
local L = mod:GetLocalizedStrings()

mod:SetRevision("20240616044034")

mod:SetCreatureID(19219)
mod:SetEncounterID(1932)

if not mod:IsRetail() then
	mod:SetModelID(19162)
end

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 35158 35159",
	"SPELL_CAST_START 39096"
)

local warnPolarity          = mod:NewCastAnnounce(39096, 4)
local warnMagicShield       = mod:NewTargetNoFilterAnnounce(35158, 3)
local warnDamageShield      = mod:NewTargetNoFilterAnnounce(35159, 3)

local timerMagicShield      = mod:NewBuffActiveTimer(10, 35158, nil, nil, nil, 5)
local timerDamageShield     = mod:NewBuffActiveTimer(10, 35159, nil, nil, nil, 5)

local enrageTimer			= mod:NewBerserkTimer(180)

function mod:OnCombatStart(delay)
	if not self:IsDifficulty("normal5") then
        enrageTimer:Start(-delay)
    end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 39096 then          --Robo Thaddius AMG!
		warnPolarity:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 35158 then          --Magic Shield
		warnMagicShield:Show(args.destName)
		timerMagicShield:Start()
	elseif args.spellId == 35159 then      --Damage Shield
		warnDamageShield:Show(args.destName)
		timerDamageShield:Start()
	end
end
