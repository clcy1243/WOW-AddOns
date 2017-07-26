local _, ns = ...
local t = ns.TidyPlates_Threat

local function GetMarkedColor(unit, allowMarked, defaultColor)
	local db = TidyPlatesThreat.db.profile.settings.raidicon
	local c
	if ((allowMarked ~= nil and allowMarked == false) or (not db.hpColor)) then
		c = defaultColor
	else
		c = db.hpMarked[unit.raidIcon]
	end
	return c
end

local function GetClassColor(unit)
	local db = TidyPlatesThreat.db.profile
	local c, class

	local isFriend = t.IsFriend(unit.unitid)
	if (db.friendlyClass and isFriend) or (db.allowClass and not isFriend) then
		if unit.class and unit.class ~= "" then
			class = unit.class
		elseif unit.guid then
			local _
			_, class = GetPlayerInfoByGUID(unit.guid)
		end
		if class then
			c = RAID_CLASS_COLORS[class]
		end
	end

	return c
end

local function GetThreatColor(unit, style)
	local db = TidyPlatesThreat.db.profile
	local c

	if db.threat.ON and db.threat.useHPColor and InCombatLockdown() and (style == "dps" or style == "tank") then
		local nonCombatOverride = not (db.threat.toggle.nonCombat or unit.isInCombat)
		local isFriend = t.IsFriend(unit.unitid)
		if (not nonCombatOverride) and (not isFriend) then
			local threatSituation = unit.threatSituation
			if unit.threatValue < 3 and unit.unitid ~= nil and TidyPlatesWidgets.IsEnemyTanked(unit) and style == "tank" then
				threatSituation = "OTHERTANK"
			end
			c = db.settings[style].threatcolor[threatSituation]
		end
	end

	return c
end

local CS = CreateFrame("ColorSelect")

function CS:GetSmudgeColorRGB(colorA, colorB, perc)
	self:SetColorRGB(colorA.r, colorA.g, colorA.b)
	local h1, s1, v1 = self:GetColorHSV()
	self:SetColorRGB(colorB.r, colorB.g, colorB.b)
	local h2, s2, v2 = self:GetColorHSV()
	local h3 = floor(h1-(h1-h2)*perc)
	if abs(h1-h2) > 180 then
		local radius = (360-abs(h1-h2))*perc/100
		if h1 < h2 then
			h3 = floor(h1-radius)
			if h3 < 0 then
				h3 = 360+h3
			end
		else
			h3 = floor(h1+radius)
			if h3 > 360 then
				h3 = h3-360
			end
		end
	end
	local s3 = s1-(s1-s2)*perc
	local v3 = v1-(v1-v2)*perc
	self:SetColorHSV(h3, s3, v3)

	local c = {
		r = 0,
		g = 0,
		b = 0,
	}
	c.r, c.g, c.b = self:GetColorRGB()
	return c
end

local function SetHealthbarColor(unit)
	local db = TidyPlatesThreat.db.profile
	local style = TidyPlatesThreat.SetStyle(unit)
	local c, allowMarked

	if style == "totem" then
		local tS = db.totemSettings[t.Totems[unit.name]]
		if tS[2] then
			c = tS.color
		end
	elseif style == "unique" then
		for k_c, k_v in pairs(db.uniqueSettings.list) do
			if k_v == unit.name then
				local u = db.uniqueSettings[k_c]
				allowMarked = u.allowMarked
				if u.useColor then
					c = u.color
				end
			end
		end
	end

	if unit.isMarked then
		c = GetMarkedColor(unit, allowMarked, c)
	end

	if not c then
		if db.healthColorChange then
			local pct = unit.health / unit.healthmax
			c = CS:GetSmudgeColorRGB(db.aHPbarColor, db.bHPbarColor, pct)
		else
			c = GetThreatColor(unit, style)
			if not c then
				c = GetClassColor(unit)
			end
			if not c then
				c = t.GetReactionColor(unit)
			end
		end
	end

	if c then
		return c.r, c.g, c.b
	else
		return unit.red, unit.green, unit.blue
	end
end

TidyPlatesThreat.SetHealthbarColor = SetHealthbarColor
