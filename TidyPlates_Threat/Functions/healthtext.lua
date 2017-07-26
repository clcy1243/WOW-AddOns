local function Truncate(value)
	local db = TidyPlatesThreat.db.profile.text
	local numberformat = '%.' .. db.decimals .. 'f'

	if db.truncate then
		if value >= 1e6 then
			return format(numberformat .. 'm', value / 1e6)
		elseif value >= 1e4 then
			return format(numberformat .. 'k', value / 1e3)
		else
			return format(numberformat, value)
		end
	else
		return format(numberformat, value)
	end
end

local function GetPercent(unit)
	local db = TidyPlatesThreat.db.profile.text
	local numberformat = '%.' .. db.decimals .. 'f'

	local multiplier = math.pow(10, db.decimals)
	local value = ceil(100 * (unit.health / unit.healthmax) * multiplier) / multiplier

	if value >= 100 then
		return format('%.0f', value) .. '%'
	else
		return format(numberformat, value) .. '%'
	end
end

local function GetHpText(unit)
	local db = TidyPlatesThreat.db.profile.text
	if (not db.full and unit.health == unit.healthmax) then
		return ""
	end

	local HpPct = ""
	local HpAmt = ""
	local HpMax = ""

	if db.amount then
		if db.deficit and unit.health ~= unit.healthmax then
			HpAmt = "-" .. Truncate(unit.healthmax - unit.health)
		else
			HpAmt = Truncate(unit.health)
		end

		if db.max then
			if HpAmt ~= "" then
				HpMax = " / "
			end
			HpMax = HpMax .. Truncate(unit.healthmax)
		end
	end

	if db.percent then
		if HpMax ~= "" or HpAmt ~= "" then
			HpPct = " - "
		end
		HpPct = HpPct .. GetPercent(unit)
	end

	return HpAmt .. HpMax .. HpPct
end

local function GetTextSubtitle(unit)
	local DB = TidyPlatesThreat.db.profile.textOnly.customtext

	local text
	if unit.type == "NPC" and DB.showRole then
		text = TidyPlatesUtility.GetUnitSubtitle(unit)
		if text == "UNKNOWN" then text = "" end
	end
	if unit.type == "PLAYER" and DB.showGuild then
		text = GetGuildInfo(unit.unitid)
	end

	local c = DB.color

	return text, c.r, c.g, c.b
end

local function SetCustomText(unit)
	local style = TidyPlatesThreat.SetStyle(unit)
	if style == "text" then
		return GetTextSubtitle(unit)

	else
		return GetHpText(unit)
	end
end

TidyPlatesThreat.SetCustomText = SetCustomText
