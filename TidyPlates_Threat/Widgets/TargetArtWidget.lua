--------------------------------------------------------------------------------------------------------
--                                          Target Art Widget                                         --
--------------------------------------------------------------------------------------------------------
local path = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\TargetArtWidget\\"
local DB

local function enabled()
	DB = TidyPlatesThreat.db.profile.targetWidget
	return DB.ON
end

local function UpdateTargetFrameArt(frame, unit)
	local S = TidyPlatesThreat.SetStyle(unit)
	if unit.isTarget and S ~= "etotem" and S ~= "empty" and S~= "text" then
		frame.Icon:SetTexture(path..DB.theme)
		frame.Icon:SetVertexColor(DB.r, DB.g, DB.b, DB.a)
		frame:Show()
	else
		frame:Hide()
	end
end

local function CreateTargetFrameArt(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(256, 64)
	frame:SetPoint("CENTER", parent, "CENTER")
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetAllPoints(frame)

	frame:Hide()
	frame.Update = UpdateTargetFrameArt

	return frame
end

ThreatPlatesWidgets.RegisterWidget("TargetArtWidget", CreateTargetFrameArt, false, enabled)
