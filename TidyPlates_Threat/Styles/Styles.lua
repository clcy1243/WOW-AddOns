local _, ns = ...
local t = ns.TidyPlates_Threat

local function GetGeneral(unit)
	if unit.isTapped then
		return "Tapped"
	elseif unit.reaction == "NEUTRAL" then
		return "Neutral"
	else
		if unit.isDangerous and unit.isElite then
			return "Boss"
		elseif not unit.isDangerous and unit.isElite then
			return "Elite"
		elseif not unit.isDangerous and not unit.isElite then
			return "Normal"
		end
	end
end

local function GetType(unit)
	local db = TidyPlatesThreat.db.profile
	local unitRank
	local totem = t.Totems[unit.name]
	local unique = tContains(db.uniqueSettings.list, unit.name)
	local isFriend = t.IsFriend(unit.unitid)
	local isPet = UnitIsOtherPlayersPet(unit.unitid)
	local isGuardian = (not isPet) and unit.type == "NPC" and UnitPlayerControlled(unit.unitid)

	if totem then
		unitRank = "Totem"
	elseif unique then
		for k_c, k_v in pairs(db.uniqueSettings.list) do
			if k_v == unit.name then
				if db.uniqueSettings[k_c].useStyle then
					unitRank = "Unique"
				else
					unitRank = GetGeneral(unit)
				end
			end
		end
	elseif isPet then
		unitRank = "Pet"
	elseif isGuardian then
		unitRank = "Guardian"
	elseif isFriend then
		unitRank = "Allied"
	else
		unitRank = GetGeneral(unit)
	end

	return unitRank
end

local function SetStyle(unit)
	local db = TidyPlatesThreat.db.profile

	local T = GetType(unit)
	local style
	if T == "Totem" then
		local tS = db.totemSettings[t.Totems[unit.name]]
		if tS[1] then
			if db.totemSettings.hideHealthbar then
				style = "etotem"
			else
				style = "totem"
			end
		end
	elseif T == "Unique" then
		for k_c, k_v in pairs(db.uniqueSettings.list) do
			if k_v == unit.name then
				if db.uniqueSettings[k_c].showNameplate then
					style = "unique"
				end
			end
		end
	elseif T == "Pet" or T == "Guardian" then
		if db.textOnly.ON and db.textOnly.friendlyPlayer and t.IsFriend(unit.unitid) then
			style = "text"
		else
			style = "normal"
		end
	elseif T == "Allied" then
		local isTextOnly = (db.textOnly.friendlyPlayer and unit.type == "PLAYER") or (db.textOnly.friendlyNPC and unit.type == "NPC")
		if db.textOnly.ON and isTextOnly then
			style = "text"
		else
			style = "normal"
		end
	elseif T then
		if db.nameplate.toggle[T] then
			if InCombatLockdown() and unit.type == "NPC" and db.threat.ON then
				if db.threat.toggle[T] then
					if TidyPlatesThreat:isTank() then
						style = "tank"
					else
						style = "dps"
					end
				end
			end
			if not style then
				style = "normal"
			end
		end
	end

	if db.textOnly.ON and unit.threatValue < 2 then
		if db.textOnly.neutralUnit and unit.reaction == "NEUTRAL" then
			style = "text"
		end
		if db.textOnly.miniMobsUnit and unit.isMini then
			style = "text"
		end
	end

	if style then
		return style
	else
		return "empty"
	end
end

TidyPlatesThreat.GetGeneral = GetGeneral
TidyPlatesThreat.GetType = GetType
TidyPlatesThreat.SetStyle = SetStyle
