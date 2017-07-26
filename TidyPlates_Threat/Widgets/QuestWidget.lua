--------------------------------------------------------------------------------------------------------
--                                            Quest Widget                                            --
--------------------------------------------------------------------------------------------------------
local _, ns = ...
local t = ns.TidyPlates_Threat

local path = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\QuestWidget\\"
local DB

local playerName = UnitName("player")
local tooltipFrame = CreateFrame("GameTooltip", "TidyPlates_Threat_Unit", nil, "GameTooltipTemplate")
tooltipFrame:SetOwner(WorldFrame, "ANCHOR_NONE")

--------------------------------------------------------------------------------------------------------
--                                         General functions                                          --
--------------------------------------------------------------------------------------------------------

local function UpdateSettings(frame)
	frame:SetSize(DB.scale, DB.scale)
	frame:SetPoint("CENTER", frame:GetParent(), DB.anchor, DB.x, DB.y)
end

local function UpdateWidgetFrame(frame)
	local unitid = frame.unitid
	local questObjective = false
	local questNoObjective = false

	tooltipFrame:SetUnit(unitid)
	for i = 3, tooltipFrame:NumLines() do
		local line = _G["TidyPlates_Threat_UnitTextLeft" .. i]
		local text = line:GetText()
		local text_r, text_g, text_b = line:GetTextColor()

		if text_r > 0.99 and text_g > 0.82 and text_b == 0 then
			questNoObjective = true
		else
			local unitName, progress = string.match(text, "^ ([^ ]-) ?%- (.+)$")

			if unitName and (unitName == "" or unitName == playerName) then
				if progress then
					local current, goal = string.match(progress, "(%d+)/(%d+)")

					if current and goal and current ~= goal then
						questObjective = true
					end
				end
			end
		end
	end

	if questObjective or questNoObjective then
		frame.Icon:SetTexture(path .. "quest")
		frame:SetFrameLevel(frame:GetParent():GetFrameLevel() + 2)
		frame:Show()
	else
		frame:Hide()
	end
end

local function enabled()
	DB = TidyPlatesThreat.db.profile.questWidget
	return DB.ON
end

--------------------------------------------------------------------------------------------------------
--                                          Widget functions                                          --
--------------------------------------------------------------------------------------------------------
local UpdateQuestWidget = function(frame, unit)
	local unitid = unit.unitid
	if not enabled() or not unitid then
		frame:Hide()
		return
	end

	UpdateSettings(frame)
	frame.unitid = unitid

	UpdateWidgetFrame(frame)
end

local function CreateQuestWidget(parent)
	local frame = CreateFrame("frame", nil, parent)
	frame:SetSize(32, 32)
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetAllPoints(frame)

	frame:Show()
	frame:Hide()
	frame.Update = UpdateQuestWidget

	return frame
end

ThreatPlatesWidgets.RegisterWidget("QuestWidget", CreateQuestWidget, false, enabled)
