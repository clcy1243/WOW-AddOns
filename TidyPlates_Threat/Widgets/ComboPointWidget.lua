--------------------------------------------------------------------------------------------------------
--                                         Combo Point Widget                                         --
--------------------------------------------------------------------------------------------------------
local _, ns = ...
local t = ns.TidyPlates_Threat

local path = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\ComboPointWidget\\"
local WidgetList = {}
local DB
local playerClass = select(2, UnitClassBase("player"))

--------------------------------------------------------------------------------------------------------
--                                         General functions                                          --
--------------------------------------------------------------------------------------------------------
local function UpdateWidgetFrame(frame)
	local points
	if UnitExists("target") then
		if playerClass == "MONK" and (not t.IsFriend("target")) then
			points = UnitPower("player", SPELL_POWER_CHI)
		else
			points = GetComboPoints("player", "target")
		end
	end
	if points and points > 0 then
		frame:SetFrameLevel(frame:GetParent():GetFrameLevel() + 2)
		frame.Icon:SetTexture(path..points)
		frame:SetScale(DB.scale)
		frame:SetPoint("CENTER", frame:GetParent(), "CENTER", DB.x, DB.y)
		frame:Show()
	else
		frame:_Hide()
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Events watcher                                           --
--------------------------------------------------------------------------------------------------------
local WatcherFrame = CreateFrame("frame")
local isEnabled = false

local function EnableWatcherFrame()
	if not isEnabled then
		isEnabled = true
		WatcherFrame:RegisterEvent("UNIT_POWER")
	end
end

local function DisableWatcherFrame()
	if isEnabled then
		isEnabled = false
		WatcherFrame:UnregisterAllEvents()
		wipe(WidgetList)
	end
end

WatcherFrame:SetScript("OnEvent", function(this, event, ...)
	local guid = UnitGUID("target")
	if guid then
		local widget = WidgetList[guid]
		if widget then
			UpdateWidgetFrame(widget)
		end
	end
end)

local function enabled()
	DB = TidyPlatesThreat.db.profile.comboWidget
	if DB.ON then
		EnableWatcherFrame()
	else
		DisableWatcherFrame()
	end
	return DB.ON
end

--------------------------------------------------------------------------------------------------------
--                                          Widget functions                                          --
--------------------------------------------------------------------------------------------------------
local function UpdateWidgetContext(frame, unit)
	if enabled() then
		local guid = unit.guid
		frame.guid = guid

		-- Add to Widget List
		if guid then
			WidgetList[guid] = frame
		end

		-- Update Widget
		if UnitGUID("target") == guid then
			UpdateWidgetFrame(frame)
		else
			frame:_Hide()
		end
	else
		frame:_Hide()
	end
end

local function ClearWidgetContext(frame)
	local guid = frame.guid
	if guid then
		WidgetList[guid] = nil
		frame.guid = nil
	end
	frame:_Hide()
end

local function CreateWidgetFrame(parent)
	local frame = CreateFrame("frame", nil, parent)
	frame:SetSize(64, 64)

	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetAllPoints(frame)

	frame:Hide()
	frame.UpdateContext = UpdateWidgetContext
	frame.Update = UpdateWidgetContext
	frame._Hide = frame.Hide
	frame.Hide = ClearWidgetContext

	return frame
end

ThreatPlatesWidgets.RegisterWidget("ComboPointWidget", CreateWidgetFrame, true, enabled)
