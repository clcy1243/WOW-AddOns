local _, ns = ...
local t = ns.TidyPlates_Threat

local function GetGeneralScale(unit)
	local unitType = TidyPlatesThreat.GetType(unit)
	local db = TidyPlatesThreat.db.profile.nameplate
	local scale = 0

	if unitType and unitType ~="empty" then
		scale = db.scale[unitType] or 1 -- This should also return for totems.
	end

	-- Do checks for target settings, must be spelled out to avoid issues
	if (UnitExists("target") and unit.isTarget) and db.toggle.TargetS then
		scale = db.scale.Target
	elseif not UnitExists("target") and db.toggle.NoTargetS then
		if unit.isMarked and db.toggle.MarkedS then
			scale = db.scale.Marked
		else
			scale = db.scale.NoTarget
		end
	else -- Marked units will always be set to this scale
		if unit.isMarked and db.toggle.MarkedS then
			scale = db.scale.Marked
		end
	end

	return scale
end

local function GetThreatScale(unit)
	local db = TidyPlatesThreat.db.profile
	if InCombatLockdown() and db.threat.ON and db.threat.useScale then
		local markedOverride = unit.isMarked and db.nameplate.toggle.MarkedS
		local targetOverride = unit.isTarget and db.nameplate.toggle.TargetS
		local nonCombatOverride = not (db.threat.toggle.nonCombat or unit.isInCombat)
		local isFriend = t.IsFriend(unit.unitid)
		if markedOverride or targetOverride or nonCombatOverride or isFriend then
			return GetGeneralScale(unit)
		else
			local style = "dps"
			local threatSituation = unit.threatSituation
			if TidyPlatesThreat:isTank() then
				if unit.threatValue < 3 and unit.unitid ~= nil and TidyPlatesWidgets.IsEnemyTanked(unit) then
					threatSituation = "OTHERTANK"
				end
				style = "tank"
			end
			return db.threat[style].scale[threatSituation]
		end
	else
		return GetGeneralScale(unit)
	end
end

local function SetScale(unit)
	local db = TidyPlatesThreat.db.profile
	local style = TidyPlatesThreat.SetStyle(unit)
	local scale = 0
	local nonTargetScale = 0

	if style == "unique" then
		for k,v in pairs(db.uniqueSettings.list) do
			if v == unit.name then
				if not db.uniqueSettings[k].overrideScale then
					scale = db.uniqueSettings[k].scale
				else
					scale = GetThreatScale(unit)
				end
			end
		end
	elseif style == "empty" then
		-- etotem scale will still be at totem level
		scale = 0
	else
		scale = GetThreatScale(unit)
	end

	if scale <= 0 then
		scale = 0.01
	end

	return scale
end

TidyPlatesThreat.SetScale = SetScale
