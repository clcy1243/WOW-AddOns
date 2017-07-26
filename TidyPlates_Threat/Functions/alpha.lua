local _, ns = ...
local t = ns.TidyPlates_Threat

local function GetGeneralAlpha(unit)
	local unitType = TidyPlatesThreat.GetType(unit)
	local db = TidyPlatesThreat.db.profile.nameplate
	local alpha = 0

	if unitType and unitType ~="empty" then
		alpha = db.alpha[unitType] or 1
	end

	if db.toggle.TargetA and (UnitExists("target") and unit.isTarget) then
		alpha = db.alpha.Target
	elseif db.toggle.MarkedA and unit.isMarked then
		alpha = db.alpha.Marked
	elseif db.toggle.NoTargetA and (not UnitExists("target")) then
		alpha = db.alpha.NoTarget
	end

	return alpha
end

local function GetThreatAlpha(unit)
	local db = TidyPlatesThreat.db.profile

	if InCombatLockdown() and (db.threat.ON and db.threat.useAlpha) then
		local markedOverride = unit.isMarked and db.nameplate.toggle.MarkedA
		local targetOverride = unit.isTarget and db.nameplate.toggle.TargetA
		local nonCombatOverride = not (db.threat.toggle.nonCombat or unit.isInCombat)
		local isFriend = t.IsFriend(unit.unitid)
		if markedOverride or targetOverride or nonCombatOverride or isFriend then
			return GetGeneralAlpha(unit)
		else
			local style = "dps"
			local threatSituation = unit.threatSituation
			if TidyPlatesThreat:isTank() then
				if unit.threatValue < 3 and unit.unitid ~= nil and TidyPlatesWidgets.IsEnemyTanked(unit) then
					threatSituation = "OTHERTANK"
				end
				style = "tank"
			end
			return db.threat[style].alpha[threatSituation]
		end
	else
		return GetGeneralAlpha(unit)
	end
end

local function SetAlpha(unit)
	local db = TidyPlatesThreat.db.profile
	local style = TidyPlatesThreat.SetStyle(unit)
	local alpha = 0
	local nonTargetAlpha = 0

	if db.blizzFadeA.toggle and not unit.isTarget and UnitExists("Target") and (style ~= "text" or db.textOnly.blizzFadeA) then
		nonTargetAlpha = db.blizzFadeA.amount
	end

	if style == "unique" then
		for k,v in pairs(db.uniqueSettings.list) do
			if v == unit.name then
				if not db.uniqueSettings[k].overrideAlpha then
					alpha = db.uniqueSettings[k].alpha
				else
					alpha = GetThreatAlpha(unit)
				end
			end
		end
	elseif style == "empty" then
		alpha = 0
	elseif style == "text" and db.textOnly.overrideAlpha then
		alpha = db.textOnly.alpha
	else
		alpha = GetThreatAlpha(unit)
	end

	if not alpha then
		alpha = 0
	end

	return alpha + nonTargetAlpha
end

TidyPlatesThreat.SetAlpha = SetAlpha
