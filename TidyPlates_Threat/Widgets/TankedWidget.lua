--------------------------------------------------------------------------------------------------------
--                                            Tanked Widget                                           --
--------------------------------------------------------------------------------------------------------
local _, ns = ...
local t = ns.TidyPlates_Threat

local path = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\TankedWidget\\"
local WidgetList = {}
local DB

--------------------------------------------------------------------------------------------------------
--                                         General functions                                          --
--------------------------------------------------------------------------------------------------------
local function UpdateSettings(frame)
	frame:SetSize(DB.scale, DB.scale)
	frame:SetPoint("CENTER", frame:GetParent(), DB.anchor, DB.x, DB.y)
end

local function UpdateWidgetFrame(frame)
	local unit = frame.unit

	if (not InCombatLockdown()) or (not unit.isInCombat) or (unit.threatValue > 2) then
		WidgetList[unit.unitid] = nil
		frame:Hide()
		return
	end

	WidgetList[unit.unitid] = frame

	if TidyPlatesWidgets.IsEnemyTanked(unit) then
		frame.Icon:SetTexture(path .. "tank")
	else
		frame.Icon:SetTexture(path .. "dps")
	end

	frame:SetFrameLevel(frame:GetParent():GetFrameLevel() + 2)
	frame:Show()
end

local function enabled()
	DB = TidyPlatesThreat.db.profile.tankedWidget
	if not DB.ON then
		wipe(WidgetList)
	end
	return DB.ON
end

--------------------------------------------------------------------------------------------------------
--                                          Widget functions                                          --
--------------------------------------------------------------------------------------------------------
local function UpdateTankedWidget(frame, unit)
	if (not enabled()) or (not unit.unitid) or t.IsFriend(unit.unitid) or unit.type == "PLAYER" then
		frame:Hide()
		return
	end

	UpdateSettings(frame)
	frame.unit = unit

	UpdateWidgetFrame(frame)
end

local function CreateTankedWidget(parent)
	local frame = CreateFrame("frame", nil, parent)
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetAllPoints(frame)

	frame:Show()
	frame:Hide()
	frame.Update = UpdateTankedWidget

	return frame
end

ThreatPlatesWidgets.RegisterWidget("TankedWidget", CreateTankedWidget, false, enabled)
