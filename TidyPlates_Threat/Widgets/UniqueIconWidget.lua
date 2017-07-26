--------------------------------------------------------------------------------------------------------
--                                         Unique Icon Widget                                         --
--------------------------------------------------------------------------------------------------------
local DB

local function enabled()
	DB = TidyPlatesThreat.db.profile.uniqueWidget
	return DB.ON
end

local function UpdateSettings(frame)
	frame:SetSize(DB.scale, DB.scale)
	frame:SetPoint(DB.anchor, frame:GetParent(), DB.x, DB.y)
end

local function UpdateUniqueIconWidget(frame, unit)
	local db = TidyPlatesThreat.db.profile.uniqueSettings

	local isShown = false
	if enabled then
		if tContains(db.list, unit.name) then
			local s
			for k, v in pairs(db.list) do
				if v == unit.name then
					s = db[k]
					break
				end
			end
			if s and s.showIcon then
				frame.Icon:SetTexture(s.icon)
				isShown = true
			end
		end
	end

	if isShown then
		UpdateSettings(frame)
		frame:Show()
	else
		frame:Hide()
	end
end

local function CreateUniqueIconWidget(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(64, 64)
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetPoint("CENTER", frame)
	frame.Icon:SetAllPoints(frame)

	frame:Hide()
	frame.Update = UpdateUniqueIconWidget

	return frame
end

ThreatPlatesWidgets.RegisterWidget("UniqueIconWidget", CreateUniqueIconWidget, false, enabled)
