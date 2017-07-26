--------------------------------------------------------------------------------------------------------
--                                             Aura Widget                                            --
--------------------------------------------------------------------------------------------------------
local _, ns = ...
local t = ns.TidyPlates_Threat

local path = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\AuraWidget\\"

local WidgetList = {}

local AuraType_Index = {
	["Buff"] = 1,
	["Curse"] = 2,
	["Disease"] = 3,
	["Magic"] = 4,
	["Poison"] = 5,
	["Debuff"] = 6,
}

local DB
local PollUntil = t.PollUntil

local AuraFont = GameFontHighlightSmall:GetFont()

-- Get a clean version of the function...  Avoid OmniCC interference
local CooldownNative = CreateFrame("Cooldown", nil, WorldFrame)
local SetCooldown = CooldownNative.SetCooldown

--------------------------------------------------------------------------------------------------------
--                                         General functions                                          --
--------------------------------------------------------------------------------------------------------
local function ShowUnitAuras(unitid, guid)
	if (DB.targetOnly and guid ~= UnitGUID("target")) then
		return false
	end

	local isFriend = t.IsFriend(unitid)
	if (isFriend and (not DB.showFriendly)) or ((not isFriend) and (not DB.showEnemy)) then
		return false
	end

	return true
end

local function AuraFilterFunction(aura)
	if aura.type == nil or DB.displays[AuraType_Index[aura.type]] then
		local mode = DB.mode

		local spellfound = tContains(DB.allow, aura.name)
		if spellfound then
			return true
		end

		local spellfound = tContains(DB.filter, aura.name)
		local spellFiltered = false
		if spellfound then spellFiltered = true end
		local isMine = (aura.caster == 'player' or aura.caster == 'pet')
		if mode == "whitelist" then
			return spellFiltered
		elseif mode == "whitelistMine" then
			if isMine then
				return spellFiltered
			end
		elseif mode == "all" then
			return true
		elseif mode == "allMine" then
			if isMine then
				return true
			end
		elseif mode == "blacklist" then
			return not spellFiltered
		elseif mode == "blacklistMine" then
			if isMine then
				return not spellFiltered
			end
		end
	end
end

local function GetUnitAuras(unitid, auraFilter, storedAuras, storedAuraCount)
	local auraIndex = 0
	while true do
		auraIndex = auraIndex + 1
		local name, _, icon, stacks, dispelType, duration, expiration, caster, _, _, spellid = UnitAura(unitid, auraIndex, auraFilter)

		if not name then
			break
		end

		local aura = {}
		aura.name = name
		aura.texture = icon
		aura.stacks = stacks
		aura.type = dispelType
		aura.effect = auraFilter
		aura.duration = duration
		aura.expiration = expiration
		aura.caster = caster
		aura.spellid = spellid

		if AuraFilterFunction(aura) then
			storedAuraCount = storedAuraCount + 1
			storedAuras[storedAuraCount] = aura
		end
	end

	return storedAuraCount
end

local function GetIconTexCoords(iconWidth, iconHeight)
	local size = max(iconWidth, iconHeight)

	local left = (size - iconWidth) / size / 2
	if left == 0 then left = 0.05 end
	local right = 1 - left

	local top = (size - iconHeight) / size / 2
	if top == 0 then top = 0.05 end
	local bottom = 1 - top

	return left, right, top, bottom
end

local function UpdateWidgetTime(frame, expiration)
	if expiration == 0 then
		frame.TimeLeft:SetText("")
	else
		local timeleft = expiration - GetTime()
		if timeleft > 60 then
			frame.TimeLeft:SetText(floor(timeleft/60).."m")
		else
			frame.TimeLeft:SetText(floor(timeleft))
		end
	end
end

local function UpdateIcon(frame, texture, duration, expiration, stacks)
	if not frame then
		return
	end

	if texture then
		-- Icon
		frame.Icon:SetTexture(texture)

		-- Stacks
		if stacks and stacks > 1 then
			frame.Stacks:SetText(stacks)
		else
			frame.Stacks:SetText("")
		end

		-- Cooldown
		if DB.radialCooldown and expiration > 0 then
			SetCooldown(frame.Cooldown, expiration - duration, duration + .25)
		else
			SetCooldown(frame.Cooldown, 0, 0)
		end

		-- Expiration
		UpdateWidgetTime(frame, expiration)
		PollUntil(frame, expiration)

		frame:Show()
	else
		PollUntil(frame, 0)
		frame:Hide()
	end
end

local function UpdateWidgetFrame(frame)
	if not ShowUnitAuras(frame.unitid, frame.guid) then
		WidgetList[frame.unitid] = nil
		frame.unitid = nil
		frame:Hide()
		return
	else
		WidgetList[frame.unitid] = frame
	end

	local storedAuras = {}
	local storedAuraCount = 0

	storedAuraCount = GetUnitAuras(frame.unitid, "HARMFUL", storedAuras, storedAuraCount)
	storedAuraCount = GetUnitAuras(frame.unitid, "HELPFUL", storedAuras, storedAuraCount)

	-- display auras
	local auraSlotCount = 1
	if storedAuraCount > 0 then
		frame:Show()

		for index = 1, storedAuraCount do
			if auraSlotCount > DB.rows * DB.columns then
				break
			end
			local aura = storedAuras[index]
			if aura.spellid then
				UpdateIcon(frame.AuraIconFrames[auraSlotCount], aura.texture, aura.duration, aura.expiration, aura.stacks)
				auraSlotCount = auraSlotCount + 1
			end
		end
	end

	-- clear extra slots
	for index = auraSlotCount, DB.rows * DB.columns do
		UpdateIcon(frame.AuraIconFrames[index])
	end
end

local function CreateIconFrame(parent)
	local frame = CreateFrame("frame", nil, parent)
	frame:SetSize(DB.iconWidth, DB.iconHeight)

	if DB.iconBorder then
		frame.Border = frame:CreateTexture(nil, "BORDER")
		frame.Border:SetAllPoints(frame)
		frame.Border:SetTexture(path .. "border")
	end

	frame.Icon = frame:CreateTexture(nil, "ARTWORK")
	local iconWidth = DB.iconWidth
	local iconHeight = DB.iconHeight
	if DB.iconBorder then
		iconWidth = iconWidth - 2
		iconHeight = iconHeight - 2
		frame.Icon:SetPoint("CENTER", 0, 0)
		frame.Icon:SetSize(iconWidth, iconHeight)
	else
		frame.Icon:SetAllPoints(frame)
	end
	frame.Icon:SetTexCoord(GetIconTexCoords(iconWidth, iconHeight))

	frame.Cooldown = CreateFrame("cooldown", nil, frame, "CooldownFrameTemplate")
	frame.Cooldown:SetAllPoints(frame.Icon)
	frame.Cooldown:SetEdgeTexture("Interface\\Cooldown\\edge")
	frame.Cooldown:SetSwipeColor(0, 0, 0, 0.8)
	frame.Cooldown:SetReverse(true)
	frame.Cooldown:SetHideCountdownNumbers(true)

	frame.Texts = CreateFrame("frame", nil, frame)
	frame.Texts:SetAllPoints(frame)

	frame.TimeLeft = frame.Texts:CreateFontString(nil, "OVERLAY")
	frame.TimeLeft:SetFont(AuraFont, 8, "OUTLINE")
	frame.TimeLeft:SetShadowOffset(1, -1)
	frame.TimeLeft:SetShadowColor(0, 0, 0, 1)
	frame.TimeLeft:SetPoint("BOTTOMRIGHT", 0, 8)
	frame.TimeLeft:SetWidth(28)
	frame.TimeLeft:SetHeight(DB.iconHeight)
	frame.TimeLeft:SetJustifyH("RIGHT")

	frame.Stacks = frame.Texts:CreateFontString(nil, "OVERLAY")
	frame.Stacks:SetFont(AuraFont, 9, "OUTLINE")
	frame.Stacks:SetShadowOffset(1, -1)
	frame.Stacks:SetShadowColor(0, 0, 0, 1)
	frame.Stacks:SetPoint("RIGHT", 0, -6)
	frame.Stacks:SetWidth(DB.iconWidth)
	frame.Stacks:SetHeight(DB.iconHeight)
	frame.Stacks:SetJustifyH("RIGHT")

	frame.Poll = UpdateWidgetTime

	frame:Hide()
	return frame
end

--------------------------------------------------------------------------------------------------------
--                                           Events watcher                                           --
--------------------------------------------------------------------------------------------------------
local WatcherFrame = CreateFrame("frame")
local isEnabled = false

local function EnableWatcherFrame()
	if not isEnabled then
		isEnabled = true
		WatcherFrame:RegisterEvent("UNIT_AURA")
	end
end

local function DisableWatcherFrame()
	if isEnabled then
		isEnabled = false
		WatcherFrame:UnregisterAllEvents()
		for unitid, frame in pairs(WidgetList) do
			WidgetList[unitid] = nil
			frame.unitid = nil
		end
		wipe(WidgetList)
	end
end

local function enabled()
	DB = TidyPlatesThreat.db.profile.auraWidget
	if DB.ON and TidyPlates.GetThemeName() == "Threat" then
		EnableWatcherFrame()
	else
		DisableWatcherFrame()
	end
	return DB.ON
end

WatcherFrame:SetScript("OnEvent", function(this, event, ...)
	local unitid = ...

	if not enabled() or not unitid then
		frame:Hide()
		return
	end

	local frame = WidgetList[unitid]
	if frame then
		frame.unitid = unitid
		UpdateWidgetFrame(frame)
	end
end)

--------------------------------------------------------------------------------------------------------
--                                          Widget functions                                          --
--------------------------------------------------------------------------------------------------------
local function UpdateAuraWidget(frame, unit)
	local unitid = unit.unitid
	if not enabled() or not unitid then
		frame:Hide()
		return
	end

	frame:SetScale(DB.scale)
	frame:SetPoint("BOTTOM", frame:GetParent(), "TOP", DB.x, DB.y)
	frame.unitid = unit.unitid
	frame.guid = unit.guid

	UpdateWidgetFrame(frame)
end

local function CreateAuraWidget(parent)
	local frame = CreateFrame("frame", nil, parent)
	frame:SetSize(128, 32)

	frame.AuraIconFrames = {}
	for r = 0, DB.rows - 1 do
		for c = 0, DB.columns - 1 do
			local iconIndex = r * DB.columns + c + 1
			frame.AuraIconFrames[iconIndex] = CreateIconFrame(frame)
			local x = c * (DB.iconWidth + DB.iconOffsetX)
			local y = r * (DB.iconHeight + DB.iconOffsetY)
			frame.AuraIconFrames[iconIndex]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", x, y)
		end
	end

	frame:Hide()
	frame.Update = UpdateAuraWidget
	return frame
end

ThreatPlatesWidgets.RegisterWidget("AuraWidget", CreateAuraWidget, false, enabled)
