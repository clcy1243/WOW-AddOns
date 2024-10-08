
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Pit Lord Vilemus", 1779, 2015)
if not mod then return end
mod:RegisterEnableMob(124719)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{247739, "FLASH"}, -- Drain
		{247733, "CASTBAR"}, -- Stomp
		247731, -- Fel Breath
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)


	self:Log("SPELL_CAST_SUCCESS", "DrainSuccess", 247739)
	self:Log("SPELL_AURA_APPLIED", "Drain", 247739)
	self:Log("SPELL_AURA_APPLIED", "DrainStacks", 247742)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DrainStacks", 247742)

	self:Log("SPELL_CAST_START", "Stomp", 247733)
	self:Log("SPELL_CAST_START", "FelBreath", 247731)

	self:Death("Win", 124719)
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:DrainSuccess(args)
	self:CDBar(args.spellId, 17)
end

do
	local playerList = mod:NewTargetList()
	function mod:Drain(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
		end
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessageOld", 0.3, args.spellId, playerList, "yellow", "alert")
		end
	end
end

function mod:DrainStacks(args)
	if self:Me(args.destGUID) or (self:Tank() and self:Tank(args.destName)) then
		local amount = args.amount or 1
		self:StackMessageOld(247739, args.destName, amount, "cyan", amount % 2 == 0 and "alarm", args.spellId)
	end
end

function mod:Stomp(args)
	self:MessageOld(args.spellId, "orange", "warning")
	self:CastBar(args.spellId, 2)
	self:CDBar(args.spellId, 17)
end

function mod:FelBreath(args)
	self:MessageOld(args.spellId, "red", "long")
	self:CDBar(args.spellId, 15.5)
end
