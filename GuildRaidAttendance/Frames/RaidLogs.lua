local GRA, gra = unpack(select(2, ...))
local L = select(2, ...).L
local LPP = LibStub:GetLibrary("LibPixelPerfect")

local dates, sortedDates, details = {}, {}, {}
local selected = 1
-----------------------------------------
-- raid logs frame
-----------------------------------------
local raidLogsFrame = CreateFrame("Frame", "GRA_RaidLogsFrame", gra.mainFrame)
raidLogsFrame:SetPoint("TOPLEFT", gra.mainFrame, 8, -30)
raidLogsFrame:SetPoint("TOPRIGHT", gra.mainFrame, -8, -30)
raidLogsFrame:SetHeight(341)
raidLogsFrame:Hide()
gra.raidLogsFrame = raidLogsFrame

-----------------------------------------
-- title
-----------------------------------------
local titleFrame = CreateFrame("Frame", nil, raidLogsFrame)
titleFrame:SetPoint("TOPLEFT")
titleFrame:SetPoint("BOTTOMRIGHT", raidLogsFrame, "TOPRIGHT", 0, -16)

local titleText = titleFrame:CreateFontString(nil, "OVERLAY", "GRA_FONT_SMALL")
titleText:SetPoint("LEFT", 5, 0)

local attendanceEditorBtn = GRA:CreateButton(titleFrame, L["Attendance Editor"], "green", {100, 18})
attendanceEditorBtn:SetPoint("RIGHT")
attendanceEditorBtn:Hide()
attendanceEditorBtn:SetScript("OnClick", function()
	gra.configFrame:Hide()
	gra.importFrame:Hide()
	gra.epgpOptionsFrame:Hide()
	gra.dkpOptionsFrame:Hide()
	gra.rosterEditorFrame:Hide()
	gra.appearanceFrame:Hide()
	GRA:ShowAttendanceEditor(sortedDates[selected], dates[sortedDates[selected]])
end)

-----------------------------------------
-- date list
-----------------------------------------
local listFrame = CreateFrame("Frame", nil, raidLogsFrame)
GRA:StylizeFrame(listFrame, {.5, .5, .5, .1})
listFrame:SetPoint("TOPLEFT", 0, -16)
listFrame:SetPoint("BOTTOMRIGHT", raidLogsFrame, "BOTTOMLEFT", 70, 24)
-- listFrame:SetPoint("TOPRIGHT", raidLogsFrame, "TOPLEFT", 100, 0)
-- listFrame:SetHeight(300)
GRA:CreateScrollFrame(listFrame, 0, 0)
listFrame.scrollFrame:SetScrollStep(15)

-----------------------------------------
-- summary
-----------------------------------------
local attendeesFrame = CreateFrame("Frame", nil, raidLogsFrame)
GRA:StylizeFrame(attendeesFrame, {.5, .5, .5, .1})
attendeesFrame:SetPoint("TOPLEFT", listFrame, "TOPRIGHT", 5, 0)
attendeesFrame:SetPoint("RIGHT")
attendeesFrame:SetHeight(46)

local attendeesText = attendeesFrame:CreateFontString(nil, "OVERLAY", "GRA_FONT_SMALL")
attendeesText:SetPoint("TOPLEFT", 5, -5)
attendeesText:SetPoint("TOPRIGHT", -5, -5)
attendeesText:SetSpacing(2)
attendeesText:SetWordWrap(true)
attendeesText:SetMaxLines(3)
attendeesText:SetJustifyH("LEFT")
attendeesText:SetJustifyV("TOP")

local absenteesFrame = CreateFrame("Frame", nil, raidLogsFrame)
GRA:StylizeFrame(absenteesFrame, {.5, .5, .5, .1})
absenteesFrame:SetPoint("TOPLEFT", attendeesFrame, "BOTTOMLEFT", 0, 1)
absenteesFrame:SetPoint("RIGHT")
absenteesFrame:SetHeight(46)

local absenteesText = absenteesFrame:CreateFontString(nil, "OVERLAY", "GRA_FONT_SMALL")
absenteesText:SetPoint("TOPLEFT", 5, -5)
absenteesText:SetPoint("TOPRIGHT", -5, -5)
absenteesText:SetSpacing(2)
absenteesText:SetWordWrap(true)
absenteesText:SetMaxLines(3)
absenteesText:SetJustifyH("LEFT")
absenteesText:SetJustifyV("TOP")

-----------------------------------------
-- details
-----------------------------------------
local detailsFrame = CreateFrame("Frame", nil, raidLogsFrame)
GRA:StylizeFrame(detailsFrame, {.5, .5, .5, .1})
detailsFrame:SetPoint("TOPLEFT", absenteesFrame, "BOTTOMLEFT", 0, -5)
detailsFrame:SetPoint("BOTTOMRIGHT", 0, 24)
GRA:CreateScrollFrame(detailsFrame, -5, 5)
-- detailsFrame.scrollFrame:SetScrollStep(19)

-----------------------------------------
-- status & buttons
-----------------------------------------
local statusFrame = CreateFrame("Frame", nil, raidLogsFrame)
statusFrame:SetPoint("TOPLEFT", raidLogsFrame, "BOTTOMLEFT", 0, 20)
statusFrame:SetPoint("BOTTOMRIGHT")

local sendToRaidBtn = GRA:CreateButton(statusFrame, L["Send To Raid"], "blue", {100, 20}, nil, false,
	L["Send selected logs to raid members"],
	L["GRA must be installed to receive data."],
	L["Attendance rate data will be sent ATST."],
	L["Select multiple logs with the Ctrl and Shift keys."])
sendToRaidBtn:SetPoint("BOTTOMLEFT")
sendToRaidBtn:Hide()
sendToRaidBtn:SetScript("OnClick", function()
	local confirm = GRA:CreateConfirmBox(raidLogsFrame, 180, L["Send selected raid logs data to raid/party members?"], function()
		local selectedDates = {}
		for d, b in pairs(dates) do
			if b.isSelected then
				table.insert(selectedDates, d)
			end
		end
		GRA:SendLogsToRaid(selectedDates)
	end, true)
	confirm:SetPoint("CENTER")
end)
-- disabled while sending
sendToRaidBtn:SetScript("OnUpdate", function()
	sendToRaidBtn:SetEnabled(IsInGroup("LE_PARTY_CATEGORY_HOME") and not gra.sending)
end)

local newRaidLogBtn = GRA:CreateButton(statusFrame, L["New Raid Log"], "blue", {100, 20}, nil, false,
	L["Create a new raid log"], L["After creating it, you can manually edit attendance."])
newRaidLogBtn:SetPoint("LEFT", sendToRaidBtn, "RIGHT", 5, 0)
newRaidLogBtn:Hide()
newRaidLogBtn:SetScript("OnClick", function()
	GRA:NewRaidLog(newRaidLogBtn)
end)

local deleteRaidLogBtn = GRA:CreateButton(statusFrame, L["Delete Raid Log"], "blue", {100, 20}, nil, false,
	L["Delete Raid Log"],
	L["Delete selected raid logs."],
	L["Select multiple logs with the Ctrl and Shift keys."])
deleteRaidLogBtn:SetScript("OnClick", function()
	local text = L["Delete selected raid logs?"]
	if gra.isAdmin then
		text = text .. "\n|cffFFFFFF" .. L["This will affect attendance rate!"]
	end
	local confirm = GRA:CreateConfirmBox(raidLogsFrame, 180, gra.colors.firebrick.s .. text, function()
		local selectedDates = {}
		for d, b in pairs(dates) do
			if b.isSelected then
				table.insert(selectedDates, d)
			end
		end
		_G[GRA_R_RaidLogs] = GRA:RemoveElementsByKeys(_G[GRA_R_RaidLogs], selectedDates)
		GRA:Print(L["Deleted raid logs: "] .. GRA:TableToString(selectedDates))
		GRA:FireEvent("GRA_LOGS_DEL", selectedDates)
	end, true)
	confirm:SetPoint("CENTER")
end)

-- non-EPGP
local recordLootBtn = GRA:CreateButton(statusFrame, L["Record Loot"], "blue", {100, 20})
recordLootBtn:SetPoint("BOTTOMRIGHT")
recordLootBtn:Hide()
recordLootBtn:SetScript("OnClick", function()
	if gra.recordLootFrame:IsShown() then
		gra.recordLootFrame:Hide()
	else
		local d = sortedDates[selected]
		if not d then return end
		GRA:ShowRecordLootFrame(d, nil, nil, nil)
	end
end)

-- EPGP/DKP penalize
local penalizeBtn = GRA:CreateButton(statusFrame, L["Penalize"], "Penalize", {70, 20})
penalizeBtn:SetPoint("BOTTOMRIGHT")
penalizeBtn:SetScript("OnClick", function()
	if gra.penalizeFrame:IsShown() then
		gra.penalizeFrame:Hide()
	else
		local d = sortedDates[selected]
		if not d then return end
		GRA:ShowPenalizeFrame(d, nil, nil, nil, nil)
	end
end)
penalizeBtn:Hide()

local creditBtn = GRA:CreateButton(statusFrame, "XX Credit", "Credit", {70, 20})
creditBtn:SetPoint("RIGHT", penalizeBtn, "LEFT", 1, 0)
creditBtn:SetScript("OnClick", function()
	if gra.creditFrame:IsShown() then
		gra.creditFrame:Hide()
	else
		local d = sortedDates[selected]
		if not d then return end
		GRA:ShowCreditFrame(d, nil, nil, nil, nil)
	end
end)
creditBtn:Hide()

local awardBtn = GRA:CreateButton(statusFrame, "XX Award", "Award", {70, 20})
awardBtn:SetPoint("RIGHT", creditBtn, "LEFT", 1, 0)
awardBtn:SetScript("OnClick", function()
	if gra.awardFrame:IsShown() then
		gra.awardFrame:Hide()
	else
		local d = sortedDates[selected]
		if not d then return end
		GRA:ShowAwardFrame(d, nil, nil, nil)
	end
end)
awardBtn:Hide()

-----------------------------------------
-- show raid info
-----------------------------------------
local function SortByClass(a, b)
	local classA = _G[GRA_R_Roster][a] and GRA:GetIndex(gra.CLASS_ORDER, _G[GRA_R_Roster][a]["class"]) or "99"
	local classB = _G[GRA_R_Roster][b] and GRA:GetIndex(gra.CLASS_ORDER, _G[GRA_R_Roster][b]["class"]) or "99"
	if classA ~= classB then
		return 	classA < classB
	else
		return a < b
	end
end

local function ShowRaidSummary(d)
	local t = _G[GRA_R_RaidLogs][d]
	local attendeesString, absenteesString = "", ""

	-- fill table
	local attendees, absentees = GRA:GetAttendeesAndAbsentees(d, true)
	-- sort by class
	table.sort(attendees, function(a, b) return SortByClass(a, b) end)
	table.sort(absentees, function(a, b) return SortByClass(a, b) end)

	for _, n in pairs(attendees) do
		attendeesString = attendeesString .. GRA:GetClassColoredName(n) .. " "
	end
	for _, n in pairs(absentees) do
		absenteesString = absenteesString .. GRA:GetClassColoredName(n) .. " "
	end
	attendeesText:SetText("|cff80FF00" .. L["Attendees"] .. "(" .. GRA:Getn(attendees) .. "): " .. attendeesString)
	absenteesText:SetText("|cff80FF00" .. L["Absentees"] .. "(" .. GRA:Getn(absentees) .. "): " .. absenteesString)

	wipe(attendees)
	wipe(absentees)
end

local function ShowRaidDetails(d)
	detailsFrame.scrollFrame:ClearContent()
	
	details = {}
	local t = _G[GRA_R_RaidLogs][d]

	local last
	for k, detail in pairs(t["details"]) do
		local b
		
		if _G[GRA_R_Config]["raidInfo"]["system"] == "EPGP" then
			b = GRA:CreateDetailButton(detailsFrame.scrollFrame.content, detail)
		elseif _G[GRA_R_Config]["raidInfo"]["system"] == "DKP" then
			b = GRA:CreateDetailButton_DKP(detailsFrame.scrollFrame.content, detail)
		else -- loot council
			b = GRA:CreateDetailButton_LC(detailsFrame.scrollFrame.content, detail)
		end
		
		if b then
			b:SetPoint("LEFT", 5, 0)
			b:SetPoint("RIGHT", -5, 0)
			if last then
				b:SetPoint("TOP", last, "BOTTOM", 0, -5)
			else
				b:SetPoint("TOP")
			end
			last = b
			table.insert(details, b)

			-- GRA_Tooltip
			b:HookScript("OnEnter", function()
				if detail[1] == "GP" or detail[1] == "DKP_C" then
					if string.find(detail[3], "|Hitem") then
						GRA_Tooltip:SetOwner(b, "ANCHOR_NONE")
						GRA_Tooltip:SetPoint("RIGHT", b, "LEFT", -2, 0)
						GRA_Tooltip:SetHyperlink(detail[3])
					else
						GRA_Tooltip:Hide()
					end
				else -- EP or DKP_A or Penalize
					if b.playerText:IsTruncated() then
						GRA_Tooltip:SetOwner(b, "ANCHOR_NONE")
						GRA_Tooltip:SetPoint("RIGHT", b, "LEFT", -2, 0)
						if detail[1] == "EP" then
							GRA_Tooltip:AddLine(L["EP Award"] .. " (" .. #detail[4] .. ")")
						elseif detail[1] == "DKP_A" then
							GRA_Tooltip:AddLine(L["DKP Award"] .. " (" .. #detail[4] .. ")")
						else
							GRA_Tooltip:AddLine(L["Penalize"] .. " (" .. #detail[4] .. ")")
						end
						for i = 1, #detail[4], 2 do
							GRA_Tooltip:AddDoubleLine(GRA:GetClassColoredName(detail[4][i]), GRA:GetClassColoredName(detail[4][i+1]))
						end
						GRA_Tooltip:Show()
					end
				end
			end)

			b:HookScript("OnLeave", function()
				GRA_Tooltip:Hide()
			end)

			if gra.isAdmin then
				b.deleteBtn:Show()
				if _G[GRA_R_Config]["raidInfo"]["system"] == "EPGP" then
					if detail[1] == "GP" then
						b.noteText:SetPoint("RIGHT", -25, 0)
					else
						b.playerText:SetPoint("RIGHT", -25, 0)
					end

					-- delete detail entry
					b.deleteBtn:SetScript("OnClick", function()
						local confirm = GRA:CreateConfirmBox(detailsFrame, 200, gra.colors.firebrick.s .. L["Delete this entry and undo changes to %s?"]:format("EP/GP") .. "|r\n" 
						.. detail[3] .. ": " .. detail[2] .. " " .. (string.find(detail[1], "EP") and "EP" or "GP")
						, function()
							if string.find(detail[1], "P") == 1 then
								GRA:UndoPenalizeEPGP(d, k)
							else
								GRA:UndoEPGP(d, k)
							end
							ShowRaidDetails(d)
							detailsFrame.scrollFrame:ResetScroll()
						end, true)
						confirm:SetPoint("CENTER")
					end)

					-- modify detail entry
					b:SetScript("OnClick", function()
						if detail[1] == "EP" then
							GRA:ShowAwardFrame(d, detail[3], detail[2], detail[4], k)
						elseif detail[1] == "GP" then
							GRA:ShowCreditFrame(d, detail[3], detail[2], detail[4], detail[5], k)
						else -- PGP/PEP
							GRA:ShowPenalizeFrame(d, detail[1], detail[3], detail[2], detail[4], k)
						end
					end)
				elseif _G[GRA_R_Config]["raidInfo"]["system"] == "DKP" then
					if detail[1] == "DKP_C" then
						b.noteText:SetPoint("RIGHT", -25, 0)
					else
						b.playerText:SetPoint("RIGHT", -25, 0)
					end

					-- delete detail entry
					b.deleteBtn:SetScript("OnClick", function()
						local confirm = GRA:CreateConfirmBox(detailsFrame, 200, gra.colors.firebrick.s .. L["Delete this entry and undo changes to %s?"]:format("DKP") .. "|r\n" 
						.. detail[3] .. ": " .. detail[2] .. " DKP"
						, function()
							if detail[1] == "DKP_P" then
								GRA:UndoPenalizeDKP(d, k)
							else
								GRA:UndoDKP(d, k)
							end
							ShowRaidDetails(d)
							detailsFrame.scrollFrame:ResetScroll()
						end, true)
						confirm:SetPoint("CENTER")
					end)

					-- modify detail entry
					b:SetScript("OnClick", function()
						if detail[1] == "DKP_A" then
							GRA:ShowAwardFrame(d, detail[3], detail[2], detail[4], k)
						elseif detail[1] == "DKP_C" then
							GRA:ShowCreditFrame(d, detail[3], -detail[2], detail[4], detail[5], k)
						else -- DKP_P
							GRA:ShowPenalizeFrame(d, detail[1], detail[3], detail[2], detail[4], k)
						end
					end)
				else -- loot council
					b.noteText:SetPoint("RIGHT", -25, 0)
					-- delete detail entry
					b.deleteBtn:SetScript("OnClick", function()
						local confirm = GRA:CreateConfirmBox(detailsFrame, 200, gra.colors.firebrick.s .. L["Delete this entry?"] .. "|r\n" 
						.. detail[3] .. " " .. GRA:GetClassColoredName(detail[4])
						, function()
							-- delete from logs
							table.remove(_G[GRA_R_RaidLogs][d]["details"], k)
							-- fake GRA_ENTRY_UNDO event, refresh sheet by date
							GRA:FireEvent("GRA_ENTRY_UNDO", d)
							ShowRaidDetails(d)
							detailsFrame.scrollFrame:ResetScroll()
						end, true)
						confirm:SetPoint("CENTER")
					end)

					-- modify detail entry
					b:SetScript("OnClick", function()
						GRA:ShowRecordLootFrame(d, detail[3], detail[5], detail[4], k)
					end)
				end
			end
		end
	end
end

local function Refresh()
	if sortedDates[selected] then
		ShowRaidDetails(sortedDates[selected])
	end
end

local function RefreshAndScroll()
	Refresh()
	C_Timer.After(.1, function()
		detailsFrame.scrollFrame:SetVerticalScroll(detailsFrame.scrollFrame:GetVerticalScrollRange())
	end)
end

GRA:RegisterEvent("GRA_ENTRY", "RaidLogs_EPGPRefresh", RefreshAndScroll)
GRA:RegisterEvent("GRA_ENTRY_MODIFY", "RaidLogs_EPGPRefresh", Refresh)
GRA:RegisterEvent("GRA_SYSTEM", "RaidLogs_EPGPRefresh", Refresh)

-----------------------------------------
-- load date list
-----------------------------------------
local function LoadDateList()
	GRA:Debug("|cffFFC0CBLoading date list...|r ")
	-- clear data
	-- listFrame.scrollFrame:Reset()

	wipe(sortedDates)
	for d, t in pairs(_G[GRA_R_RaidLogs]) do
		table.insert(sortedDates, d)
	end
	table.sort(sortedDates, function(a, b) return a < b end)

	for i = 1, #sortedDates do
		local d = sortedDates[i]
		if not dates[d] then
			dates[d] = GRA:CreateListButton(listFrame.scrollFrame.content, date("%x", GRA:DateToTime(d)), "transparent-light", {listFrame.scrollFrame.content:GetWidth(), gra.size.height-4})
			listFrame.scrollFrame:SetWidgetAutoWidth(dates[d])

			-- highlight selected, dehighlight others
			dates[d]:HookScript("OnClick", function(self)
				if IsShiftKeyDown() then
					if selected then
						-- print("selected: " .. selected .. " current:" .. self.index)
						for i = 1, #sortedDates do
							if selected < self.index then -- ... selected ... clicked ...
								if  i < selected or i > self.index then
									dates[sortedDates[i]]:Deselect()
								else
									dates[sortedDates[i]]:Select()
								end
							elseif selected > self.index then -- ... clicked ... selected ...
								if  i > selected or i < self.index then
									dates[sortedDates[i]]:Deselect()
								else
									dates[sortedDates[i]]:Select()
								end
							else -- ... clicked(selected) ...
								if  i ~= self.index then
									dates[sortedDates[i]]:Deselect()
								end
							end
						end
					end
				elseif IsControlKeyDown() then
					if dates[sortedDates[self.index]].isSelected then
						dates[sortedDates[self.index]]:Deselect()
					else
						dates[sortedDates[self.index]]:Select()
					end
				else
					selected = self.index
					for i = 1, #sortedDates do
						if dates[sortedDates[i]].index ~= selected then
							dates[sortedDates[i]]:Deselect()
						end
					end
					
					ShowRaidSummary(d)
					ShowRaidDetails(d)
					detailsFrame.scrollFrame:ResetScroll()

					titleText:SetText("|cff80FF00" .. L["Raids: "] .. "|r" .. GRA:Getn(_G[GRA_R_RaidLogs])
						.. "    |cff80FF00" .. L["Current: "] .. "|r" .. date("%x", GRA:DateToTime(sortedDates[selected]))
						.. "    |cff80FF00" .. L["Raid Hours"] .. ":|r " .. GRA:GetRaidStartTime(d) .. " - " ..  GRA:GetRaidEndTime(d))
				end
			end)
		end
		-- update index, used for multi-selection
		dates[d].index = i
	end

	-- set point
	local last = nil
	for _, d in pairs(sortedDates) do
		dates[d]:ClearAllPoints()
		if last then
			dates[d]:SetPoint("TOP", last, "BOTTOM", 0, 1)
		else
			dates[d]:SetPoint("TOPLEFT")
		end
		dates[d]:Show()
		last = dates[d]
	end
end

local function PrepareRaidLogs()
	if GRA:Getn(_G[GRA_R_RaidLogs]) == 0 then
		GRA:CreateMask(raidLogsFrame, L["No raid log"], {-1, 1, 1, -1})
		attendeesText:SetText("")
		absenteesText:SetText("")
		detailsFrame.scrollFrame:Reset()
		newRaidLogBtn:SetFrameLevel(127)
	else
		if raidLogsFrame.mask then raidLogsFrame.mask:Hide() end
		newRaidLogBtn:SetFrameLevel(4)
		LoadDateList()
		-- if not sortedDates[selected] then selected = #sortedDates end
	end
end

-- update list and scroll
local function UpdateList(dateToShow)
	listFrame.scrollFrame:ResetScroll()
	PrepareRaidLogs()
	-- show last log by default
	if not dateToShow then dateToShow = sortedDates[#sortedDates] end
	GRA:Debug("|cffFFC0CBRefreshing current log: |r" .. (dateToShow or "nil"))
	if dates[dateToShow] then
		dates[dateToShow]:Click()
		-- scroll list
		C_Timer.After(.1, function()
			if not dates[dateToShow]:IsVisible() then
				if dates[dateToShow].index > 20 then
					listFrame.scrollFrame:SetVerticalScroll((gra.size.height-5) * (dates[dateToShow].index - 20))
				else
					listFrame.scrollFrame:SetVerticalScroll(0)
				end
			end
		end)
	end
end

local init, updateRequired = false, nil
raidLogsFrame:SetScript("OnShow", function()
	LPP:PixelPerfectPoint(gra.mainFrame)
	gra.mainFrame:SetWidth(gra.size.mainFrame[1])

	if updateRequired ~= nil then
		init = true
		UpdateList(updateRequired)
		updateRequired = nil
	end

	if not init then
		init = true
		UpdateList()
	end
end)

-- for other frames, refresh current shown log!
function GRA:RefreshCurrentLog()
	if not init or updateRequired then return end
	if raidLogsFrame:IsVisible() then
		if dates[sortedDates[selected]] then dates[sortedDates[selected]]:Click() end
	else
		updateRequired = sortedDates[selected]
	end
end

-----------------------------------------
-- events
-----------------------------------------
GRA:RegisterEvent("GRA_LOGS_DONE", "RaidLogsFrame_LogsReceived", function(count, dateStrings)
	GRA:Print(L["%d raid logs have been received: %s"]:format(count, GRA:TableToString(dateStrings)))
	-- show last of received dates
	if raidLogsFrame:IsVisible() then
		UpdateList(dateStrings[#dateStrings])
	else
		updateRequired = dateStrings[#dateStrings]
	end
end)

-- show new log (details), 不可见不刷新
GRA:RegisterEvent("GRA_RAIDLOGS", "RaidLogsFrame_RaidLogsUpdated", function(d)
	if raidLogsFrame:IsVisible() then
		UpdateList(d)
	else
		updateRequired = d
	end
end)

GRA:RegisterEvent("GRA_LOGS_DEL", "RaidLogsFrame_RaidLogsDeleted", function(deletedDates)
	-- hide
	for _, d in pairs(deletedDates) do
		dates[d]:SetParent(nil)
		dates[d]:ClearAllPoints()
		dates[d]:Hide()
	end
	-- delete
	dates = GRA:RemoveElementsByKeys(dates, deletedDates)
	-- reset scroll
	listFrame.scrollFrame:ResetScroll()
	listFrame.scrollFrame:ResetHeight()
	-- show last
	UpdateList()
end)

GRA:RegisterEvent("GRA_RH_UPDATE", "RaidLogsFrame_RaidHoursUpdate", function(d)
	if not init then return end

	d = sortedDates[selected] -- set to current selected
	titleText:SetText("|cff80FF00" .. L["Raids: "] .. "|r" .. GRA:Getn(_G[GRA_R_RaidLogs])
		.. "    |cff80FF00" .. L["Current: "] .. "|r" .. date("%x", GRA:DateToTime(d))
		.. "    |cff80FF00" .. L["Raid Hours"] .. ":|r " .. GRA:GetRaidStartTime(d) .. " - " ..  GRA:GetRaidEndTime(d))
end)

-----------------------------------------
-- permission
-----------------------------------------
GRA:RegisterEvent("GRA_PERMISSION", "RaidLogsFrame_CheckPermissions", function(isAdmin)
	if isAdmin then
		sendToRaidBtn:Show()
		newRaidLogBtn:Show()
		-- deleteRaidLogBtn:Show()
		deleteRaidLogBtn:SetPoint("LEFT", newRaidLogBtn, "RIGHT", 5, 0)
		attendanceEditorBtn:Show()

		if _G[GRA_R_Config]["raidInfo"]["system"] == "EPGP" then
			creditBtn:SetText(L["GP Credit"])
			creditBtn:Show()
			awardBtn:SetText(L["EP Award"])
			awardBtn:Show()
			penalizeBtn:Show()
		elseif _G[GRA_R_Config]["raidInfo"]["system"] == "DKP" then
			creditBtn:SetText(L["DKP Credit"])
			creditBtn:Show()
			awardBtn:SetText(L["DKP Award"])
			awardBtn:Show()
			penalizeBtn:Show()
		else
			recordLootBtn:Show()
		end

		-- 重新加载当前详情，以显示删除按钮或修改
		if GRA:Getn(dates) ~= 0 then
			ShowRaidDetails(sortedDates[selected])
		end
	else
		deleteRaidLogBtn:SetPoint("BOTTOMLEFT")
	end
end)

GRA:RegisterEvent("GRA_SYSTEM", "RaidLogsFrame_SystemChanged", function(system)
	-- admin only
	if not gra.isAdmin then return end
	if system == "EPGP" then
		creditBtn:SetText(L["GP Credit"])
		creditBtn:Show()
		awardBtn:SetText(L["EP Award"])
		awardBtn:Show()
		penalizeBtn:Show()
		recordLootBtn:Hide()
	elseif system == "DKP" then
		creditBtn:SetText(L["DKP Credit"])
		creditBtn:Show()
		awardBtn:SetText(L["DKP Award"])
		awardBtn:Show()
		penalizeBtn:Show()
		recordLootBtn:Hide()
	else
		recordLootBtn:Show()
		creditBtn:Hide()
		awardBtn:Hide()
		penalizeBtn:Hide()
	end
end)

if GRA:Debug() then
	-- GRA:StylizeFrame(raidLogsFrame, {0, 0, 0, 0}, {0, 0, 0, 1})
	-- GRA:StylizeFrame(titleFrame, {0, .5, 0, .1}, {0, 0, 0, 1})
	-- GRA:StylizeFrame(statusFrame, {0, .5, 0, .1}, {0, 0, 0, 1})
end

-----------------------------------------
-- resize
-----------------------------------------
function raidLogsFrame:Resize()
	raidLogsFrame:ClearAllPoints()
	raidLogsFrame:SetPoint("TOPLEFT", gra.mainFrame, 8, gra.size.raidLogsFrame[1])
	raidLogsFrame:SetPoint("TOPRIGHT", gra.mainFrame, -8, gra.size.raidLogsFrame[1])
	raidLogsFrame:SetHeight(gra.size.raidLogsFrame[2])
	titleFrame:SetPoint("BOTTOMRIGHT", raidLogsFrame, "TOPRIGHT", 0, 3-gra.size.height)
	-- buttons
	attendanceEditorBtn:SetSize(unpack(gra.size.button_attendanceEditor))
	sendToRaidBtn:SetSize(unpack(gra.size.button_main))
	newRaidLogBtn:SetSize(unpack(gra.size.button_main))
	deleteRaidLogBtn:SetSize(unpack(gra.size.button_main))
	awardBtn:SetSize(unpack(gra.size.button_raidLogs))
	creditBtn:SetSize(unpack(gra.size.button_raidLogs))
	penalizeBtn:SetSize(unpack(gra.size.button_raidLogs))
	recordLootBtn:SetSize(unpack(gra.size.button_raidLogs))
	-- list
	listFrame:SetPoint("TOPLEFT", 0, gra.size.raidLogsFrame_list[1])
	listFrame:SetPoint("BOTTOMRIGHT", raidLogsFrame, "BOTTOMLEFT", gra.size.raidLogsFrame_list[3], gra.size.raidLogsFrame_list[2])
	listFrame.scrollFrame:SetScrollStep(gra.size.height-5)
	-- summary
	attendeesFrame:SetHeight(gra.size.height+32)
	absenteesFrame:SetHeight(gra.size.height+31)
	attendeesText:SetSpacing(gra.size.fontSize-9)
	absenteesText:SetSpacing(gra.size.fontSize-9)
	-- details
	detailsFrame:SetPoint("BOTTOMRIGHT", 0, gra.size.raidLogsFrame_list[2])
	detailsFrame.scrollFrame:SetScrollStep(gra.size.height+5)
end
