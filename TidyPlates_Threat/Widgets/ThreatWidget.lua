--------------------------------------------------------------------------------------------------------
--                                            Threat Widget                                           --
--------------------------------------------------------------------------------------------------------
local _, ns = ...
local t = ns.TidyPlates_Threat

local path = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\ThreatWidget\\"
local DB

local function enabled()
	DB = TidyPlatesThreat.db.profile.threat
	return DB.art.ON
end

local function UpdateThreatWidget(frame, unit)
	if not InCombatLockdown() then frame:Hide() end;
	local threatLevel

	threatLevel = unit.threatSituation
	-- Tanking uses swapped textures for default theme
	if TidyPlatesThreat:isTank() and DB.art.theme == "default" then
		if unit.threatSituation == "HIGH" then
			threatLevel = "LOW"
		elseif unit.threatSituation == "LOW" then
			threatLevel = "HIGH"
		end
	end

	if enabled() then
		if unit.isMarked and DB.marked.art then
			frame:Hide()
		else
			local style = TidyPlatesThreat.SetStyle(unit)
			if (style == "dps" or style == "tank" or style == "unique") and InCombatLockdown() and unit.type == "NPC" and unit.isInCombat then
				frame.Texture:SetTexture(path..DB.art.theme.."\\"..threatLevel)
				frame:SetFrameLevel(frame:GetParent():GetFrameLevel() + 2)
				frame:Show()
			end
		end
	else
		frame:Hide()
	end
end

local function CreateThreatArtWidget(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(256, 64)
	frame:SetPoint("CENTER", parent, "CENTER")
	frame.Texture = frame:CreateTexture(nil, "OVERLAY")
	frame.Texture:SetAllPoints(frame)

	frame:Hide()
	frame.Update = UpdateThreatWidget

	return frame
end

ThreatPlatesWidgets.RegisterWidget("ThreatArtWidget", CreateThreatArtWidget, false, enabled)
