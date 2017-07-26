--------------------------------------------------------------------------------------------------------
--                                         Class Icon Widget                                          --
--------------------------------------------------------------------------------------------------------
local _, ns = ...
local t = ns.TidyPlates_Threat

local path = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\ClassIconWidget\\"
local DB

--------------------------------------------------------------------------------------------------------
--                                         General functions                                          --
--------------------------------------------------------------------------------------------------------
local function enabled()
	DB = TidyPlatesThreat.db.profile.classWidget
	return DB.ON
end

local function UpdateSettings(frame)
	frame:SetHeight(DB.scale)
	frame:SetWidth(DB.scale)
	frame:SetPoint((DB.anchor), frame:GetParent(), (DB.x), (DB.y))
end

--------------------------------------------------------------------------------------------------------
--                                          Widget functions                                          --
--------------------------------------------------------------------------------------------------------
local function UpdateClassIconWidget(frame, unit)
	if not enabled() then
		frame:Hide()
		return
	end

	local db = TidyPlatesThreat.db.profile
	local class
	local isFriend
	if unit.unitid then
		isFriend = t.IsFriend(unitid)
	end
	if (db.friendlyClassIcon and isFriend) or (not isFriend) then
		if unit.class and unit.class ~= "" then
			class = unit.class
		elseif unit.guid then
			local _
			_, class = GetPlayerInfoByGUID(unit.guid)
		end
	end

	if class then
		UpdateSettings(frame)
		frame:SetFrameLevel(frame:GetParent():GetFrameLevel() + 2)
		frame.Icon:SetTexture(path..DB.theme.."\\"..class)
		frame:Show()
	else
		frame:Hide()
	end
end

local function CreateClassIconWidget(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(64, 64)
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetAllPoints(frame)

	frame:Hide()
	frame.Update = UpdateClassIconWidget

	return frame
end

ThreatPlatesWidgets.RegisterWidget("ClassIconWidget", CreateClassIconWidget, false, enabled)
