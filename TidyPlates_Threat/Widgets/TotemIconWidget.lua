--------------------------------------------------------------------------------------------------------
--                                          Totem Icon Widget                                         --
--------------------------------------------------------------------------------------------------------
local _, ns = ...
local t = ns.TidyPlates_Threat

local path = "Interface\\Addons\\TidyPlates_Threat\\Widgets\\TotemIconWidget\\"
local DB

local function enabled()
	DB = TidyPlatesThreat.db.profile.totemWidget
	return DB.ON
end

local function GetTotemInfo(name)
	local totem = t.Totems[name]
	local db = TidyPlatesThreat.db.profile.totemSettings
	if totem then
		local texture =  path..db[totem][7].."\\"..totem
		return db[totem][3], texture
	else
		return false, nil
	end
end

local function UpdateSettings(frame)
	frame:SetSize(DB.scale, DB.scale)
	frame:SetPoint(DB.anchor, frame:GetParent(), DB.x, DB.y)
end

local function UpdateTotemIconWidget(frame, unit)
	local isActive, texture = GetTotemInfo(unit.name)
	if isActive then
		UpdateSettings(frame)
		frame.Icon:SetTexture(texture)
		frame:Show()
	else
		frame:Hide()
	end
end

local function CreateTotemIconWidget(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(64, 64)
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetPoint("CENTER", frame)
	frame.Icon:SetAllPoints(frame)

	frame:Hide()
	frame.Update = UpdateTotemIconWidget

	return frame
end

ThreatPlatesWidgets.RegisterWidget("TotemIconWidget", CreateTotemIconWidget, false, enabled)
