local _, ns = ...
local t = ns.TidyPlates_Threat

local function GetClassColor(unit)
	local c, class
	if unit.class and unit.class ~= "" then
		class = unit.class
	elseif unit.guid then
		local _
		_, class = GetPlayerInfoByGUID(unit.guid)
	end
	if class then
		c = RAID_CLASS_COLORS[class]
	end
	return c
end

local function GetNameColor(unit)
	local DB = TidyPlatesThreat.db.profile.settings.name
	local c

	if unit.unitid then
		local isFriend = t.IsFriend(unit.unitid)
		if (DB.colorFriendlyClass and isFriend) or (DB.colorEnemyClass and not isFriend) then
			c = GetClassColor(unit)
		end
		if not c and DB.colorByReaction then
			c = t.GetReactionColor(unit)
		end
	end

	if not c then
		c = DB.color
	end

	return c
end

local function GetTextNameColor(unit)
	local DB = TidyPlatesThreat.db.profile.textOnly.name
	local c

	if unit.unitid then
		if DB.classColor then
			c = GetClassColor(unit)
		end
		if not c and DB.colorByReaction then
			c = t.GetReactionColor(unit)
		end
	end

	if not c then
		c = DB.color
	end

	return c
end

local function SetNameColor(unit)
	local c

	local style = TidyPlatesThreat.SetStyle(unit)
	if style == "text" then
		c = GetTextNameColor(unit)
	else
		c = GetNameColor(unit)
	end

	return c.r, c.g, c.b
end

TidyPlatesThreat.SetNameColor = SetNameColor
