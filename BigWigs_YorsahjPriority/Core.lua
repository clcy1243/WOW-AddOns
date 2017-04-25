--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Yor'sahj Priority", 824)
if not mod then return end
mod:RegisterEnableMob(55312)
mod.toggleOptions = {"blobs"}

local YL = BigWigs:GetBossModule("Yor'sahj the Unsleeping"):GetLocale()
local chatPrefix = "|cFF33FF99BigWigs_YorsahjPriority|r: "

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.modname = "Yor'sahj Priority"

	L.blobs = "Blobs"
	L.blobs_desc = "Open the main config for more options /bwyp"
	L.blobs_icon = "achievement_doublerainbow"
	L.blobs_message = "KILL >>%s<<"

	L.warn = "Raid Warn"
	L.warn_desc = "Tell your raid which blob to kill with a Raid Warning, requires Raid Leader or Raid Officer."

	L.update = "Priority for blobs '%s' updated to %s by %s."
	L.denied = "You must be Raid Leader or Raid Officer to do that!"
	L.allowed = "Raid members have been updated."
	L.loaded = "Loaded. To configure type /bwyp"
	L.button = "Big Red Button"
	L.button_header = "Fellow raid members using BigWigs Yor'sahj Priority? Need to update them with the latest priority list? Are you a Raid Leader or Raid Officer? Then the Big Red Button is for you!"
end
L = mod:GetLocale()
mod.displayName = L.modname

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	if not self.db.profile.blobNorm then
		self.db.profile.blobNorm = {
			[105420] = "green",
			[105435] = "green",
			[105436] = "green",
			[105437] = "purple",
			[105439] = "blue",
			[105440] = "purple",
		}
	end
	if not self.db.profile.blobHC then
		self.db.profile.blobHC = {
			[105420] = "green",
			[105435] = "green",
			[105436] = "green",
			[105437] = "yellow",
			[105439] = "yellow",
			[105440] = "yellow",
		}
	end
	if not self.db.profile.blobLFR then
		self.db.profile.blobLFR = {
			[105420] = "purple",
			[105435] = "green",
			[105436] = "green",
			[105437] = "purple",
			[105439] = "yellow",
			[105440] = "purple",
		}
	end

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Blobs", "boss1", "boss2", "boss3", "boss4", "boss5")
	self:RegisterMessage("BigWigs_BossComm")
	self:Death("Disable", 55312)

	if YorsahjPriority then return end
	local yp = CreateFrame("Frame", "YorsahjPriority", InterfaceOptionsFramePanelContainer)
	yp.name = "BigWigs ".. L.modname
	InterfaceOptions_AddCategory(yp)
	local ypTitle = yp:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
	ypTitle:SetPoint("CENTER", yp, "TOP", 0, -30)
	ypTitle:SetText(yp.name.." r71-release") --packager magic, replaced with tag version

	local raidwarnBtn = CreateFrame("CheckButton", "ypRaidWarnBtn", yp, "OptionsBaseCheckButtonTemplate")
	raidwarnBtn:SetScript("OnClick", function(frame)
		if frame:GetChecked() then
			PlaySound("igMainMenuOptionCheckBoxOn")
			self.db.profile.disableWarn = nil
		else
			PlaySound("igMainMenuOptionCheckBoxOff")
			self.db.profile.disableWarn = true
		end
	end)
	raidwarnBtn:SetPoint("TOPLEFT", 20, -70)
	if self.db.profile.disableWarn then
		raidwarnBtn:SetChecked(false)
	else
		raidwarnBtn:SetChecked(true)
	end
	local raidwarnBtnText = raidwarnBtn:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	raidwarnBtnText:SetPoint("LEFT", raidwarnBtn, "RIGHT")
	raidwarnBtnText:SetText(L.warn_desc)
	raidwarnBtnText:SetWordWrap(true)
	raidwarnBtnText:SetWidth(560)

	local blobText = yp:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	blobText:SetPoint("TOPLEFT", 20, -120)
	blobText:SetText(PLAYER_DIFFICULTY1..PLAYER_DIFFICULTY1..PLAYER_DIFFICULTY1..PLAYER_DIFFICULTY2)

	local blobSliderText = yp:CreateFontString("ypSliderText", "ARTWORK", "GameFontNormal")
	blobSliderText:SetPoint("TOPLEFT", 300, -120)
	local diff
	if mod:LFR() then
		diff = PLAYER_DIFFICULTY3
	elseif mod:Heroic() then
		diff = PLAYER_DIFFICULTY2
	else
		diff = PLAYER_DIFFICULTY1
	end
	blobSliderText:SetText(RAID_DIFFICULTY..": "..diff)

	local function updateBlob(frame, value)
		if mod:LFR() then
			mod.db.profile.blobLFR[frame.spell] = frame.values[value]
		elseif mod:Heroic() then
			mod.db.profile.blobHC[frame.spell] = frame.values[value]
		else
			mod.db.profile.blobNorm[frame.spell] = frame.values[value]
		end
		_G[frame:GetName().."Text"]:SetText(YL[frame.values[value]])
	end

	local function onShowBlob(frame)
		if not IsInInstance() then
			frame:Disable()
			ypSliderText:SetText(RAID_DIFFICULTY..": ??")
		else
			frame:Enable()
			frame:SetMinMaxValues(1, mod:Heroic() and 4 or 3)
			local options, diff
			if mod:LFR() then
				options = mod.db.profile.blobLFR
				diff = PLAYER_DIFFICULTY3
			elseif mod:Heroic() then
				options = mod.db.profile.blobHC
				diff = PLAYER_DIFFICULTY2
			else
				options = mod.db.profile.blobNorm
				diff = PLAYER_DIFFICULTY1
			end
			ypSliderText:SetText(RAID_DIFFICULTY..": "..diff)
			for i=1, #frame.values do
				if frame.values[i] == options[frame.spell] then
					frame:SetValue(i)
					_G[frame:GetName().."Text"]:SetText(YL[frame.values[i]])
				end
			end
		end
	end

	local blobSlider1 = CreateFrame("Slider", "ypSlider1", yp, "OptionsSliderTemplate")
	blobSlider1:SetMinMaxValues(1, self:Heroic() and 4 or 3)
	blobSlider1:SetValueStep(1)
	blobSlider1.values = {"purple", "green", "blue", "black"}
	blobSlider1.spell = 105420
	blobSlider1:SetScript("OnValueChanged", updateBlob)
	blobSlider1:SetScript("OnShow", onShowBlob)
	ypSlider1High:SetText("")
	ypSlider1Low:SetText("")
	blobSlider1:SetPoint("TOPLEFT", 300, -150)
	onShowBlob(blobSlider1)

	local blobSlider2 = CreateFrame("Slider", "ypSlider2", yp, "OptionsSliderTemplate")
	blobSlider2:SetMinMaxValues(1, self:Heroic() and 4 or 3)
	blobSlider2:SetValueStep(1)
	blobSlider2.values = {"green", "red", "black", "blue"}
	blobSlider2.spell = 105435
	blobSlider2:SetScript("OnValueChanged", updateBlob)
	blobSlider2:SetScript("OnShow", onShowBlob)
	ypSlider2High:SetText("")
	ypSlider2Low:SetText("")
	blobSlider2:SetPoint("TOPLEFT", 300, -200)
	onShowBlob(blobSlider2)

	local blobSlider3 = CreateFrame("Slider", "ypSlider3", yp, "OptionsSliderTemplate")
	blobSlider3:SetMinMaxValues(1, self:Heroic() and 4 or 3)
	blobSlider3:SetValueStep(1)
	blobSlider3.values = {"green", "yellow", "red", "black"}
	blobSlider3.spell = 105436
	blobSlider3:SetScript("OnValueChanged", updateBlob)
	blobSlider3:SetScript("OnShow", onShowBlob)
	ypSlider3High:SetText("")
	ypSlider3Low:SetText("")
	blobSlider3:SetPoint("TOPLEFT", 300, -250)
	onShowBlob(blobSlider3)

	local blobSlider4 = CreateFrame("Slider", "ypSlider4", yp, "OptionsSliderTemplate")
	blobSlider4:SetMinMaxValues(1, self:Heroic() and 4 or 3)
	blobSlider4:SetValueStep(1)
	blobSlider4.values = {"blue", "purple", "yellow", "green"}
	blobSlider4.spell = 105437
	blobSlider4:SetScript("OnValueChanged", updateBlob)
	blobSlider4:SetScript("OnShow", onShowBlob)
	ypSlider4High:SetText("")
	ypSlider4Low:SetText("")
	blobSlider4:SetPoint("TOPLEFT", 300, -300)
	onShowBlob(blobSlider4)

	local blobSlider5 = CreateFrame("Slider", "ypSlider5", yp, "OptionsSliderTemplate")
	blobSlider5:SetMinMaxValues(1, self:Heroic() and 4 or 3)
	blobSlider5:SetValueStep(1)
	blobSlider5.values = {"blue", "black", "yellow", "purple"}
	blobSlider5.spell = 105439
	blobSlider5:SetScript("OnValueChanged", updateBlob)
	blobSlider5:SetScript("OnShow", onShowBlob)
	ypSlider5High:SetText("")
	ypSlider5Low:SetText("")
	blobSlider5:SetPoint("TOPLEFT", 300, -350)
	onShowBlob(blobSlider5)

	local blobSlider6 = CreateFrame("Slider", "ypSlider6", yp, "OptionsSliderTemplate")
	blobSlider6:SetMinMaxValues(1, self:Heroic() and 4 or 3)
	blobSlider6:SetValueStep(1)
	blobSlider6.values = {"purple", "red", "black", "yellow"}
	blobSlider6.spell = 105440
	blobSlider6:SetScript("OnValueChanged", updateBlob)
	blobSlider6:SetScript("OnShow", onShowBlob)
	ypSlider6High:SetText("")
	ypSlider6Low:SetText("")
	blobSlider6:SetPoint("TOPLEFT", 300, -400)
	onShowBlob(blobSlider6)

	local blobText1 = yp:CreateFontString("ypText1", "ARTWORK", "GameFontNormal")
	blobText1:SetPoint("TOPLEFT", 20, -150)
	blobText1.spell = 105420
	blobText1:SetText(YL.purple..YL.green..YL.blue..YL.black)

	local blobText2 = yp:CreateFontString("ypText2", "ARTWORK", "GameFontNormal")
	blobText2:SetPoint("TOPLEFT", 20, -200)
	blobText2.spell = 105435
	blobText2:SetText(YL.green..YL.red..YL.black..YL.blue)

	local blobText3 = yp:CreateFontString("ypText3", "ARTWORK", "GameFontNormal")
	blobText3:SetPoint("TOPLEFT", 20, -250)
	blobText3.spell = 105436
	blobText3:SetText(YL.green..YL.yellow..YL.red..YL.black)

	local blobText4 = yp:CreateFontString("ypText4", "ARTWORK", "GameFontNormal")
	blobText4:SetPoint("TOPLEFT", 20, -300)
	blobText4.spell = 105437
	blobText4:SetText(YL.blue..YL.purple..YL.yellow..YL.green)

	local blobText5 = yp:CreateFontString("ypText5", "ARTWORK", "GameFontNormal")
	blobText5:SetPoint("TOPLEFT", 20, -350)
	blobText5.spell = 105439
	blobText5:SetText(YL.blue..YL.black..YL.yellow..YL.purple)

	local blobText6 = yp:CreateFontString("ypText6", "ARTWORK", "GameFontNormal")
	blobText6:SetPoint("TOPLEFT", 20, -400)
	blobText6.spell = 105440
	blobText6:SetText(YL.purple..YL.red..YL.black..YL.yellow)

	local blobButtonText = yp:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	blobButtonText:SetPoint("TOPLEFT", 20, -450)
	blobButtonText:SetWordWrap(true)
	blobButtonText:SetWidth(570)
	blobButtonText:SetText(L.button_header)

	local blobUpdate = CreateFrame("Button", "ypUpdateButton", yp, "UIPanelButtonTemplate")
	blobUpdate:SetWidth(180)
	blobUpdate:SetHeight(30)
	blobUpdate:SetPoint("TOPLEFT", 200, -490)
	blobUpdate:SetText(L.button)
	blobUpdate:SetScript("OnClick", function(frame)
		if mod:LFR() then return end
		if not UnitIsGroupLeader("player") and not UnitIsGroupAssistant("player") then
			print(chatPrefix.. L.denied)
			return
		end
		local tbl = self:Heroic() and mod.db.profile.blobHC or mod.db.profile.blobNorm
		mod:Sync("105420", tbl[105420])
		mod:Sync("105435", tbl[105435])
		mod:Sync("105436", tbl[105436])
		mod:Sync("105437", tbl[105437])
		mod:Sync("105439", tbl[105439])
		mod:Sync("105440", tbl[105440])
		print(chatPrefix.. L.allowed)
	end)
	local function buttonShow(frame)
		if not IsInInstance() or mod:LFR() then
			frame:Disable()
		else
			frame:Enable()
		end
	end
	blobUpdate:SetScript("OnShow", buttonShow)
	buttonShow(blobUpdate)

	SlashCmdList["BWYP"] = function() InterfaceOptionsFrame_OpenToCategory(yp) end
	SLASH_BWYP1 = "/bwyp"
	print(chatPrefix.. L.loaded)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Blobs(unit, spellName, _, _, spellId)
	if self.db.profile.blobNorm[spellId] then
		if self:LFR() then
			for i=1, 2 do
				self:Message("blobs", "Important", nil, L.blobs_message:format(YL[self.db.profile.blobLFR[spellId]]), L.blobs_icon)
			end
			if not self.db.profile.disableWarn and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
				local msg = gsub(YL[self.db.profile.blobLFR[spellId]], "^|cFF%x%x%x%x%x%x(.-)|r$", "%1")
				SendChatMessage(L.blobs_message:format(msg), "RAID_WARNING")
			end
			return
		end
		if self:Heroic() then
			for i=1, 2 do
				self:Message("blobs", "Important", nil, L.blobs_message:format(YL[self.db.profile.blobHC[spellId]]), L.blobs_icon)
			end
			if not self.db.profile.disableWarn and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
				local msg = gsub(YL[self.db.profile.blobHC[spellId]], "^|cFF%x%x%x%x%x%x(.-)|r$", "%1")
				SendChatMessage(L.blobs_message:format(msg), "RAID_WARNING")
			end
		else
			for i=1, 2 do
				self:Message("blobs", "Important", nil, L.blobs_message:format(YL[self.db.profile.blobNorm[spellId]]), L.blobs_icon)
			end
			if not self.db.profile.disableWarn and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
				local msg = gsub(YL[self.db.profile.blobNorm[spellId]], "^|cFF%x%x%x%x%x%x(.-)|r$", "%1")
				SendChatMessage(L.blobs_message:format(msg), "RAID_WARNING")
			end
		end
	end
end

function mod:BigWigs_BossComm(_, msg, extra)
	if not IsInInstance() or self:LFR() or not self.db.profile.blobNorm[msg] then return end

	local num = tonumber(msg)
	if num and self.db.profile.blobNorm[num] and extra then
		if self:Heroic() then
			if self.db.profile.blobHC[num] ~= extra then
				self.db.profile.blobHC[num] = extra
				local text
				for i=1, 6 do
					local f = _G[("ypText%d"):format(i)]
					if f.spell == num then
						text = f:GetText()
					end
				end
				print(chatPrefix.. L.update:format(text, YL[extra], nick))
			end
		else
			if self.db.profile.blobNorm[num] ~= extra then
				self.db.profile.blobNorm[num] = extra
				local text
				for i=1, 6 do
					local f = _G[("ypText%d"):format(i)]
					if f.spell == num then
						text = f:GetText()
					end
				end
				print(chatPrefix.. L.update:format(text, YL[extra], nick))
			end
		end
	end
end
