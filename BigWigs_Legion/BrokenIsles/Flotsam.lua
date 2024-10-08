
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Flotsam", -650, 1795)
if not mod then return end
mod:RegisterEnableMob(99929)
mod.otherMenu = -619
mod.worldBoss = 99929

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{220295, "SAY"}, -- Jetsam
		223317, -- Breaksam
		{220340, "FLASH"}, -- Getsam
		223373, -- Yaksam
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "Jetsam")
	self:Log("SPELL_CAST_START", "Breaksam", 223317)
	self:Log("SPELL_CAST_START", "Getsam", 220340)
	self:Log("SPELL_CAST_START", "Yaksam", 223373)

	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()
	self:CDBar(220340, 50) -- Getsam
	self:CDBar(223373, 45) -- Yaksam
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(220295, nil, nil, "Jetsam")
		end
		self:TargetMessageOld(220295, player, "green", "alarm")
	end

	local prev = nil
	function mod:Jetsam(_, unit, castGUID, spellId)
		if spellId == 220295 and castGUID ~= prev then -- Jetsam
			prev = castGUID
			self:GetUnitTarget(printTarget, 0.3, self:UnitGUID(unit))
		end
	end
end

function mod:Breaksam(args)
	self:MessageOld(args.spellId, "red", self:Melee() and "alert")
end

function mod:Getsam(args)
	self:MessageOld(args.spellId, "yellow", "warning", CL.incoming:format(args.spellName))
	self:CDBar(args.spellId, 53)
	self:Flash(args.spellId)
end

function mod:Yaksam(args)
	self:MessageOld(args.spellId, "orange", "long", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 50)
end

function mod:BOSS_KILL(_, id)
	if id == 1951 then
		self:Win()
	end
end
