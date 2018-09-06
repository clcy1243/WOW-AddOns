local AddOn = ...
local C = _G[AddOn]
local L = AleaUI_GUI.GetLocale("FeralDotDamage")
local selectedspell = nil

local disabled = false

local iconFrames = {}
local statusBarsFrames = {}
local active_aura = 0

local spellName_to_Widget = {}
local spellName_ICD = {}

local function GetIcon()
	for i=1, #iconFrames do		
		if iconFrames[i].free then
			return iconFrames[i]
		end
	end
	
	
	local f = CreateFrame("Frame", nil, UIParent)
	f:SetSize(40, 40)
	f.free = true
	f:Hide()
	
	local icon = f:CreateTexture(nil, "BACKGROUND")
	icon:SetAllPoints()
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	f.backdrop = CreateFrame("Frame", nil, f)
	f.backdrop:SetFrameStrata("LOW")
	
	f.bg = f.backdrop:CreateTexture(nil, "BACKGROUND", nil, -2)
	f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -1, 1)
	f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 1, -1)
	f.bg:SetColorTexture(0,0,0,1)

	local cd = CreateFrame("Cooldown", nil, f, "CooldownFrameTemplate")
	cd.parent = f
	cd:SetAllPoints()
	cd:SetReverse(true)
	cd.noCooldownCount = true
	cd:SetScript("OnUpdate", function(self, elapsed)
	--	local numb = ( (self:GetCooldownTimes()*0.001 + self:GetCooldownDuration()* 0.001) - GetTime())
		local numb = ((self._start + self._duration) - GetTime())
		
		if self._start == 0 and self._duration == 0 then
			self.parent.timer:SetText('')
			return 
		end
		
		if numb > 60 then
			self.parent.timer:SetText(format(" %dm ", ceil(numb / 60)))
		elseif numb > 3 then
			self.parent.timer:SetText(format(" %.0f ", numb))
		elseif numb > 0 then
			if C.db.profile.aurawidgets.spelllist[self.parent.spellName].time_format == 2 then
				self.parent.timer:SetText(format(" %.1f ", numb))
			else
				self.parent.timer:SetText(format(" %.0f ", numb))
			end
		elseif numb < 0.1 then
			self.parent.timer:SetText('')
			self.parent:Hide()
		else
			self.parent.timer:SetText('')
		end
	end)
	
	local textparent = CreateFrame("Frame", nil, cd)
	textparent:SetFrameLevel(cd:GetFrameLevel()+4)
	textparent:SetSize(1,1)
	textparent:Show()
	textparent:SetPoint("CENTER")
	
	
	local timer = textparent:CreateFontString(nil, "OVERLAY")
	timer:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
	timer:SetPoint("TOPLEFT", cd, "TOPLEFT", -5, 0)
	timer:SetPoint("BOTTOMRIGHT", cd, "BOTTOMRIGHT", 5, 0)
	timer:SetJustifyH("CENTER")
	timer:SetJustifyV("BOTTOM")
	timer:SetText("")
	
	local stack = textparent:CreateFontString(nil, "OVERLAY")
	stack:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
	stack:SetPoint("TOPLEFT", cd, "TOPLEFT", -5, 0)
	stack:SetPoint("BOTTOMRIGHT", cd, "BOTTOMRIGHT", 5, 0)
	stack:SetJustifyH("CENTER")
	stack:SetJustifyV("BOTTOM")
	stack:SetText("")
	
	if false then		
		cd:SetSwipeColor(0, 0, 0, 0)
		cd:SetDrawEdge(false)
	else
		cd:SetSwipeColor(0, 0, 0, 0.7)
		cd:SetDrawEdge(false)
	end
	
	f._curtime = 0
	f.timer = timer
	f.stack = stack
	f.icon = icon
	f.cooldown = cd

	f.SetTimer = function(self, start, duration, stacks, status, maxstacks) -- status 1 buff; 2 icd; 3 forceshow
	
		if status == 1 then
			self:Show()
			self.icon:SetDesaturated(false)
			if self.cooldown._start ~= start or
				self.cooldown._duration ~= duration then
				
				self.cooldown:SetCooldown(start, duration)
				self.cooldown._start = start
				self.cooldown._duration = duration
			end
		elseif status == 2 then
			self:Show()
			self.icon:SetDesaturated(true)
			
			if self.cooldown._start ~= start or
				self.cooldown._duration ~= duration then
				
				self.cooldown:SetCooldown(start, duration)
				self.cooldown._start = start
				self.cooldown._duration = duration
			end
		end
	end
	
	f.EndTimer = function(self)
		self.timer:SetText('')
		self.cooldown:Clear()
		self:Hide()
		
	end
	
	iconFrames[#iconFrames+1] = f
	
	return f
end

local agiLTPSpellName = GetSpellInfo(187620)
local intLTPSpellName = GetSpellInfo(187616)
local strLTPSpellName = GetSpellInfo(187619)
local healLTPSpellName = GetSpellInfo(187618)

local function GetLTP(spellID, unit, duration, endTime)
	if spellID == 187616 or spellID == 187620 or spellID == 187619 then
		if duration == 0 and endTime == 0 then		
			local _, _, _, _, _, duration, endTime = UnitBuff(unit, agiLTPSpellName)						
			if duration and duration > 0 and endTime and endTime > 0 then
				return true, duration, endTime
			end				
			local _, _, _, _, _, duration, endTime = UnitBuff(unit, intLTPSpellName)						
			if duration and duration > 0 and endTime and endTime > 0 then
				return true, duration, endTime
			end
			
			local _, _, _, _, _, duration, endTime = UnitBuff(unit, strLTPSpellName)						
			if duration and duration > 0 and endTime and endTime > 0 then
				return true, duration, endTime
			end
		end
	elseif spellID == 187618 then
		if duration == 0 and endTime == 0 then	
			local _, _, _, _, _, duration, endTime = UnitBuff(unit, healLTPSpellName)
			if duration and duration > 0 and endTime and endTime > 0 then
				return true, duration, endTime
			end	
		
		end
		
	end
	
	return false
end

local function UpdateIcons(self, event, unit)
	if unit ~= "player" then return end
	local i = 1
	local curtime = GetTime()
	
	while ( true ) do
	
		local name, icon, count, debuffType, duration2, expirationTime, unitCaster, isStealable, _, spellID2 = UnitAura("player", i, "HELPFUL")
	
		
		if not name then
			break
		end
	
		local realLTP, durationLTP, endTimeLTP = GetLTP(spellID2, unitCaster, duration2, expirationTime)
		if realLTP then
			duration2, expirationTime = durationLTP, endTimeLTP
		end
			
		i = i + 1
		local opts = C.db.profile.aurawidgets.spelllist[name]
		
		if name then
		
			local opts = C.db.profile.aurawidgets.spelllist[name]
				
			if opts and opts.show then
				if opts.checkID and opts.spellID == spellID2 then				
					if opts.showICD then					
						spellName_ICD[name] = spellName_ICD[name] or {}
						spellName_ICD[name][1] = expirationTime
						spellName_ICD[name][2] = duration2
						spellName_ICD[name][3] = opts.ICD or 0
					end
					spellName_to_Widget[name]._curtime = curtime
					spellName_to_Widget[name]:SetTimer(expirationTime-duration2, duration2, count, 1)
				elseif not opts.checkID then
					if opts.showICD then
						spellName_ICD[name] = spellName_ICD[name] or {}
						spellName_ICD[name][1] = expirationTime
						spellName_ICD[name][2] = duration2
						spellName_ICD[name][3] = opts.ICD or 0						
					end
					spellName_to_Widget[name]._curtime = curtime
					spellName_to_Widget[name]:SetTimer(expirationTime-duration2, duration2, count, 1)
				end
			end
		end
	end
	
	for name, widget in pairs(spellName_to_Widget) do
		if spellName_ICD[name] and widget._curtime ~= curtime then
			-- убиваем виджет
			local params = spellName_ICD[name]

			if params and params[3] > 0 and ( params[1]-params[2]+params[3] ) > GetTime() then
				-- показываем икд
				widget:SetTimer(params[1]-params[2], params[3], 0, 2)
			else
				widget:EndTimer()
			end
		end
	end
	--[[
	for spellName, params in pairs(spellName_ICD) do
		if params[3] > 0 then
			if params[1] < GetTime() and ( params[1]-params[2] + params[3] > GetTime() ) then		
				spellName_to_Widget[spellName]:SetTimer(params[1]-params[2], params[3], 0, 2)
			end
		end
	end
	]]
end

local eventFrame = CreateFrame("Frame")
eventFrame:Hide()
eventFrame:SetScript("OnEvent", UpdateIcons)
eventFrame:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = ( self.elapsed or 0 ) + elapsed
	if self.elapsed < 0.1 then return end
	self.elapsed = 0
	UpdateIcons(self, "UNIT_AURA", "player")
end)


local function GetStatusbar()
	for i=1, #statusBarsFrames do		
		if statusBarsFrames[i].free then
			return statusBarsFrames[i]
		end
	end
	
	
	local f = CreateFrame("Frame", nil, UIParent)
	f:SetSize(200, 20)
	f.free = true
	f:Hide()
	
	local icon = f:CreateTexture(nil, "BACKGROUND")
	icon:SetPoint("TOPLEFT", f, "TOPLEFT")
	icon:SetSize(20, 20)
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	f.icon_backdrop = CreateFrame("Frame", nil, f)
	f.icon_backdrop:SetFrameStrata("LOW")
	
	f.icon_bg = f.icon_backdrop:CreateTexture(nil, "BACKGROUND", nil, -2)
	f.icon_bg:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
	f.icon_bg:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
	f.icon_bg:SetColorTexture(0,0,0,1)
	
	f.icon = icon
	
	local statusbar = CreateFrame("Statusbar", nil, f)
	statusbar:SetPoint("TOPLEFT", icon, "TOPRIGHT", 1, 0)
	statusbar:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
	statusbar:SetStatusBarTexture("Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar")
	statusbar:SetStatusBarColor(1, 1, 0, 1)
	statusbar:SetMinMaxValues(0,1)
	statusbar:SetValue(2)
	statusbar:GetStatusBarTexture():SetDrawLayer("ARTWORK", 1)
	statusbar.parent = f
	statusbar._start = 0
	statusbar._duration = -2
	statusbar._status = 3
	
	statusbar:SetScript("OnUpdate", function(self, elapsed)
		local numb = 0 
		
		if self._start == 0 and self._duration == 0 then
			self.parent.rightText:SetText('')
			return 
		end
		
		if self._status == 3 then
			self.parent.rightText:SetText('')
			return
		else
			numb = ( self._start+self._duration - GetTime() )
			self:SetValue(numb)
			
			if numb > 60 then
				self.parent.rightText:SetText(format(" %dm ", ceil(numb / 60)))
			elseif numb > 3 then
				self.parent.rightText:SetText(format(" %.0f ", numb))
			elseif numb > 0 then
				if C.db.profile.aurawidgets.spelllist[self.parent.spellName].time_format == 2 then
					self.parent.rightText:SetText(format(" %.1f ", numb))
				else
					self.parent.rightText:SetText(format(" %.0f ", numb))
				end
			elseif numb < 0.2 then
				self.parent.rightText:SetText('')
				self.parent:Hide()
			else
				self.parent.rightText:SetText('')
			end
		end
	end)
	
	f.statusbar_backdrop = CreateFrame("Frame", nil, statusbar)
	f.statusbar_backdrop:SetFrameStrata("LOW")
	
	f.statusbar_bg = f.statusbar_backdrop:CreateTexture(nil, "BACKGROUND", nil, -2)
	f.statusbar_bg:SetPoint("TOPLEFT", statusbar, "TOPLEFT", -1, 1)
	f.statusbar_bg:SetPoint("BOTTOMRIGHT", statusbar, "BOTTOMRIGHT", 1, -1)
	f.statusbar_bg:SetColorTexture(0,0,0,1)

	local text1 = statusbar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	text1:SetPoint("LEFT", statusbar, "LEFT", 2, 0)
	text1:SetJustifyH("LEFT")
	text1:SetJustifyV("CENTER")
	text1:SetText("TEST1")
	text1:SetTextColor(1, 1, 1)
	
	local text2 = statusbar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	text2:SetPoint("RIGHT", statusbar, "RIGHT", -2, 0)
	text2:SetJustifyH("RIGHT")
	text2:SetJustifyV("CENTER")
	text2:SetText("TEST2")
	text2:SetTextColor(1, 1, 1)
	
	f._curtime = 0
	f.statusbar = statusbar
	f.leftText = text1
	f.rightText = text2
	
	f.SetTimer = function(self, start, duration, stacks, status, maxstacks) -- status 1 buff; 2 icd; 3 forceshow	
		
		if status == 1 then
			self.statusbar._start = start
			self.statusbar._duration = duration
			self.statusbar._status = status
			self.statusbar:SetMinMaxValues(0,duration)
			self:Show()
		elseif status == 2 then
			self.statusbar._start = start
			self.statusbar._duration = duration
			self.statusbar._status = status	
			self.statusbar:SetMinMaxValues(0,duration)
			self:Show()			
		end
	end
	
	f.EndTimer = function(self)
		self.rightText:SetText('')
		self:Hide()
	end
	
	statusBarsFrames[#statusBarsFrames+1] = f
	return f
end

function C:UpdateAuraWidgets()
	wipe(spellName_to_Widget)	
	if disabled then return end
	
	for i=1, #iconFrames do
		iconFrames[i]:Hide()
		iconFrames[i].free = true
		iconFrames[i].spellName = nil
	end
	for i=1, #statusBarsFrames do
		statusBarsFrames[i]:Hide()
		statusBarsFrames[i].free = true
		statusBarsFrames[i].spellName = nil
	end

	eventFrame:UnregisterAllEvents()
	eventFrame:Hide()
	
	for spellName, params in pairs(C.db.profile.aurawidgets.spelllist) do		
		if params.show then
			if params.style == 1 then				
				local f = GetIcon()
				f.free = false
				
				f.icon:SetTexture(GetSpellTexture(params.spellID))
				
				f:SetSize(params.size or 20, params.size or 20)
				C:Mover(f, spellName)				
				spellName_to_Widget[spellName] = f
			--	f:Show()
				f.spellName = spellName
				active_aura = active_aura + 1
				
				C:UpdateIconStyle(spellName, true)
			else
				local f = GetStatusbar()
				f.free = false
				
				f.icon:SetTexture(GetSpellTexture(params.spellID))
				
				f:SetSize(params.width or 20, params.height or 20)
				f.icon:SetSize(params.height or 20, params.height or 20)
				f.statusbar:SetPoint("TOPLEFT", f.icon, "TOPRIGHT", params.iconGap, 0)

				
				C:Mover(f, spellName)
				spellName_to_Widget[spellName] = f
				
				f.leftText:SetText(spellName)
				f.spellName = spellName
			--	f:Show()
				
				active_aura = active_aura + 1
				
				C:UpdateStatusBarStyle_Aura(spellName, true)
			end
		end
	end	
	
	if active_aura ~= 0 then
		eventFrame:RegisterEvent("UNIT_AURA")
		eventFrame:Show()
	end
end

function C:UpdateStatusBarStyle_Aura(spellName, skiptest)
	
	local f = spellName_to_Widget[spellName]
	if f then
		local opts = C.db.profile.aurawidgets.spelllist[spellName]	
		
		f.leftText:SetFont(C.SharedMedia:Fetch("font", opts.fonts.font), opts.fonts.timer.fontsize, opts.fonts.fontflag)
		f.leftText:SetShadowColor(
			opts.fonts.timer.shadow_color[1],
			opts.fonts.timer.shadow_color[2],
			opts.fonts.timer.shadow_color[3],
			opts.fonts.timer.shadow_color[4])
			
		f.leftText:SetShadowOffset(opts.fonts.shadow_pos[1],opts.fonts.shadow_pos[2])
		f.leftText:SetTextColor(
			opts.fonts.timer.color[1],
			opts.fonts.timer.color[2],
			opts.fonts.timer.color[3],
			1)
		
		f.rightText:SetFont(C.SharedMedia:Fetch("font", opts.fonts.font), opts.fonts.stack.fontsize, opts.fonts.fontflag)
		f.rightText:SetShadowColor(
			opts.fonts.stack.shadow_color[1],
			opts.fonts.stack.shadow_color[2],
			opts.fonts.stack.shadow_color[3],
			opts.fonts.stack.shadow_color[4])
		f.rightText:SetShadowOffset(opts.fonts.shadow_pos[1],opts.fonts.shadow_pos[2])
		f.rightText:SetTextColor(opts.fonts.stack.color[1],opts.fonts.stack.color[2],opts.fonts.stack.color[3],1)
	
		
		f.icon_backdrop:SetBackdrop({
			edgeFile = C.SharedMedia:Fetch("border", opts.border.texture),
			edgeSize = opts.border.size,
		})
		f.icon_backdrop:SetBackdropBorderColor(opts.border.color[1], opts.border.color[2], opts.border.color[3], opts.border.color[4])
		f.icon_backdrop:SetPoint("TOPLEFT", -opts.border.inset, opts.border.inset)
		f.icon_backdrop:SetPoint("BOTTOMRIGHT", opts.border.inset, -opts.border.inset)
		
		f.icon_bg:SetPoint("TOPLEFT", f.icon, "TOPLEFT", -opts.border.bg_inset, opts.border.bg_inset)
		f.icon_bg:SetPoint("BOTTOMRIGHT", f.icon, "BOTTOMRIGHT", opts.border.bg_inset, -opts.border.bg_inset)
		f.icon_bg:SetColorTexture(opts.border.background[1], opts.border.background[2], opts.border.background[3], opts.border.background[4])
		
		
		
		f.statusbar_backdrop:SetBackdrop({
			edgeFile = C.SharedMedia:Fetch("border", opts.border.texture),
			edgeSize = opts.border.size,
		})
		f.statusbar_backdrop:SetBackdropBorderColor(opts.border.color[1], opts.border.color[2], opts.border.color[3], opts.border.color[4])
		f.statusbar_backdrop:SetPoint("TOPLEFT", -opts.border.inset, opts.border.inset)
		f.statusbar_backdrop:SetPoint("BOTTOMRIGHT", opts.border.inset, -opts.border.inset)
		
		f.statusbar_bg:SetPoint("TOPLEFT", f.statusbar, "TOPLEFT", -opts.border.bg_inset, opts.border.bg_inset)
		f.statusbar_bg:SetPoint("BOTTOMRIGHT", f.statusbar, "BOTTOMRIGHT", opts.border.bg_inset, -opts.border.bg_inset)
		f.statusbar_bg:SetColorTexture(opts.border.background[1], opts.border.background[2], opts.border.background[3], opts.border.background[4])
		
		
		f.statusbar:SetStatusBarTexture(C.SharedMedia:Fetch("statusbar", opts.bartexture))
		f.statusbar:SetStatusBarColor(opts.color[1][1], opts.color[1][2], opts.color[1][3], opts.color[1][4])

		--C.db.profile.aurawidgets.spelllist[selectedspell].color[2][1],
		--C.db.profile.aurawidgets.spelllist[selectedspell].spelllist[selectedspell].bartexturebg
		--C.db.profile.aurawidgets.spelllist[selectedspell].bartexture
		
		if skiptest == nil then
		--	f:SetTimer(GetTime(), 30, nil, 1) -- status 1 buff; 2 icd; 3 forceshow
		end
	end
end

function C:UpdateIconStyle(spellName, skiptest)
	
	local f = spellName_to_Widget[spellName]
	if f then
		local opts = C.db.profile.aurawidgets.spelllist[spellName]
		
		local justifyV, justifyH = strsplit(";", opts.fonts.timer.text_point) -- = "BOTTOM;CENTER",
		
		if opts.hide_timer_text then
			f.timer:Show()
		else
			f.timer:Hide()
		end
		
		f.timer:SetFont(C.SharedMedia:Fetch("font", opts.fonts.font), opts.fonts.timer.fontsize, opts.fonts.fontflag)
		f.timer:SetJustifyH(justifyH)
		f.timer:SetJustifyV(justifyV)
		f.timer:SetShadowColor(
			opts.fonts.timer.shadow_color[1],
			opts.fonts.timer.shadow_color[2],
			opts.fonts.timer.shadow_color[3],
			opts.fonts.timer.shadow_color[4])
			
		f.timer:SetShadowOffset(opts.fonts.shadow_pos[1],opts.fonts.shadow_pos[2])
		f.timer:SetTextColor(
			opts.fonts.timer.color[1],
			opts.fonts.timer.color[2],
			opts.fonts.timer.color[3],
			1)
		
		
		f.timer:SetPoint("TOPLEFT", f.cooldown, "TOPLEFT", -5+opts.fonts.timer.spacing_h, opts.fonts.timer.spacing_v)
		f.timer:SetPoint("BOTTOMRIGHT", f.cooldown, "BOTTOMRIGHT", 5+opts.fonts.timer.spacing_h, opts.fonts.timer.spacing_v)

		
		justifyV, justifyH = strsplit(";", opts.fonts.stack.text_point) -- = "BOTTOM;CENTER",
		
		f.stack:SetFont(C.SharedMedia:Fetch("font", opts.fonts.font), opts.fonts.stack.fontsize, opts.fonts.fontflag)
		f.stack:SetJustifyH(justifyH)
		f.stack:SetJustifyV(justifyV)
		f.stack:SetShadowColor(
			opts.fonts.stack.shadow_color[1],
			opts.fonts.stack.shadow_color[2],
			opts.fonts.stack.shadow_color[3],
			opts.fonts.stack.shadow_color[4])
		f.stack:SetShadowOffset(opts.fonts.shadow_pos[1],opts.fonts.shadow_pos[2])
		f.stack:SetTextColor(opts.fonts.stack.color[1],opts.fonts.stack.color[2],opts.fonts.stack.color[3],1)
		
		f.stack:SetPoint("TOPLEFT", f.cooldown, "TOPLEFT", -5+opts.fonts.stack.spacing_h, opts.fonts.stack.spacing_v)
		f.stack:SetPoint("BOTTOMRIGHT", f.cooldown, "BOTTOMRIGHT", 5+opts.fonts.stack.spacing_h, opts.fonts.stack.spacing_v)
		
		
		f.backdrop:SetBackdrop({
			edgeFile = C.SharedMedia:Fetch("border", opts.border.texture),
			edgeSize = opts.border.size,
		})
		f.backdrop:SetBackdropBorderColor(opts.border.color[1], opts.border.color[2], opts.border.color[3], opts.border.color[4])
		f.backdrop:SetPoint("TOPLEFT", -opts.border.inset, opts.border.inset)
		f.backdrop:SetPoint("BOTTOMRIGHT", opts.border.inset, -opts.border.inset)
		
		f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -opts.border.bg_inset, opts.border.bg_inset)
		f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", opts.border.bg_inset, -opts.border.bg_inset)
		f.bg:SetColorTexture(opts.border.background[1], opts.border.background[2], opts.border.background[3], opts.border.background[4])
		
		if skiptest == nil then
		--	f:SetTimer(GetTime(), 30, nil, 1) -- status 1 buff; 2 icd; 3 forceshow
		end
	end
end

local function GetSpellNameGUI(spellID)
	local name, _, icon = GetSpellInfo(spellID)
	
	return "\124T"..icon..":14\124t "..name
end

function C:AddAuraWatcherGUI()
	if disabled then return nil end
	
	local o = {
		order = 8,name = L["Ауры"],type = "group",
		args={
		
		},
	}
	
	
	o.args.create = {
		name = "",
		type = "group",
		order = 1,
		embend = true,
		args = {},	
	}
	
	o.args.settings = {
		name = "",
		type = "group",
		order = 2,
		embend = true,
		args = {},	
	}
	
	o.args.create.args.spellid = {
		name = L["ID Заклинания"], desc = L["Введите номер нужного заклинания"],
		type = "editbox",
		order = 1,
		set = function(self, value)
			local num = tonumber(value)			
			if num and GetSpellInfo(num) then
				local spellName = GetSpellInfo(num)
				if not C.db.profile.aurawidgets.spelllist[spellName] then				
					C.db.profile.aurawidgets.spelllist[spellName] = {}
					C.db.profile.aurawidgets.spelllist[spellName].show = true
					C.db.profile.aurawidgets.spelllist[spellName].style = 1
					C.db.profile.aurawidgets.spelllist[spellName].checkID = false
					C.db.profile.aurawidgets.spelllist[spellName].spellID = num
					C.db.profile.aurawidgets.spelllist[spellName].ICD = 0
					C.db.profile.aurawidgets.spelllist[spellName].showICD = false
					C.db.profile.aurawidgets.spelllist[spellName].size = 20
					C.db.profile.aurawidgets.spelllist[spellName].iconGap = 3
					
					C.db.profile.aurawidgets.spelllist[spellName].width = 200
					C.db.profile.aurawidgets.spelllist[spellName].height = 20

					C.db.profile.aurawidgets.spelllist[spellName].time_format = 1
			
			
			
					C.db.profile.aurawidgets.spelllist[spellName].bartexture = "Blizzard Raid Bar"
					C.db.profile.aurawidgets.spelllist[spellName].bartexturebg = "Blizzard Raid Bar"
					C.db.profile.aurawidgets.spelllist[spellName].color = { { 1, 1, 0, 1 }, { 0, 0, 0, 1} }
			
					C.db.profile.aurawidgets.spelllist[spellName].border = {
						texture = "WHITE8x8",
						size = 1,
						inset = 1,
						color = { 0.749019607843137, 0.749019607843137, 0.749019607843137, 0.427710175514221},
						background = { 0, 0, 0, 1},
						bg_inset = 0,
					}					
					C.db.profile.aurawidgets.spelllist[spellName].fonts = {
						font = "Arial Narrow",
						fontflag = "OUTLINE",
						shadow_pos = { 1, -1 },

						timer = {
							font = "Arial Narrow",
							fontsize = 10,
							fontflag = "OUTLINE",
							shadow_color = { 0, 0, 0, 1 },
							color = { 1, 0.972549019607843, 0, 1},
							shadow_pos = { 1, -1 },
							spacing_v = 0,
							spacing_h = 1,
							text_point = "TOP;CENTER",
						},
					
						stack = {
							font = "Arial Narrow",
							fontsize = 14,
							fontflag = "OUTLINE",
							shadow_color = { 0, 0, 0, 1 },	
							color = { 1, 1, 1, 1},
							shadow_pos = { 1, -1 },
							spacing_v = 0,
							spacing_h = -5,
							text_point = "BOTTOM;RIGHT",
						},
					}
					
				else
					C.db.profile.aurawidgets.spelllist[spellName].show = true
				end
				
				selectedspell = spellName
				C:UpdateAuraWidgets()
				
				if C.db.profile.aurawidgets.spelllist[selectedspell].style == 1 then
					C.GUI.args.aurawidgets.args.settings.args.styleGroup = C:BuildIconStyleSetup()
				elseif C.db.profile.aurawidgets.spelllist[selectedspell].style == 2 then
					C.GUI.args.aurawidgets.args.settings.args.styleGroup = C:BuildBarStyleSetup()
				else
					C.GUI.args.aurawidgets.args.settings.args.styleGroup = nil
				end
			end
		end,
		get = function(self)
			return ''
		end,
	
	}
	
	o.args.create.args.spelllist = {
		name = L["Выбрать заклинание"],
		type = "dropdown",
		order = 2,
		showSpellTooltip = true,
		values = function()
			local t = {}
			
			for spellName,params in pairs(C.db.profile.aurawidgets.spelllist) do		
				t[spellName] = GetSpellNameGUI(params.spellID).. " #"..params.spellID
			end
			
			return t
		end,
		set = function(self, value)			
			selectedspell = value
			C:UpdateAuraWidgets()
			
			if not C.db.profile.aurawidgets.spelllist[selectedspell].iconGap then
				C.db.profile.aurawidgets.spelllist[selectedspell].iconGap = 3
			end
			
			if not C.db.profile.aurawidgets.spelllist[selectedspell].border then
				C.db.profile.aurawidgets.spelllist[selectedspell].border = {
					texture = "WHITE8x8",
					size = 1,
					inset = 1,
					color = { 0.749019607843137, 0.749019607843137, 0.749019607843137, 0.427710175514221},
					background = { 0, 0, 0, 1},
					bg_inset = 0,
				}
			end
			
			if not C.db.profile.aurawidgets.spelllist[selectedspell].time_format then
				C.db.profile.aurawidgets.spelllist[selectedspell].time_format = 1
			end
			
			if not C.db.profile.aurawidgets.spelllist[selectedspell].fonts then
				C.db.profile.aurawidgets.spelllist[selectedspell].fonts = {
					font = "Arial Narrow",
					fontflag = "OUTLINE",
					shadow_pos = { 1, -1 },

					timer = {
						font = "Arial Narrow",
						fontsize = 10,
						fontflag = "OUTLINE",
						shadow_color = { 0, 0, 0, 1 },
						color = { 1, 0.972549019607843, 0, 1},
						shadow_pos = { 1, -1 },
						spacing_v = 0,
						spacing_h = 1,
						text_point = "TOP;CENTER",
					},
				
					stack = {
						font = "Arial Narrow",
						fontsize = 14,
						fontflag = "OUTLINE",
						shadow_color = { 0, 0, 0, 1 },	
						color = { 1, 1, 1, 1},
						shadow_pos = { 1, -1 },
						spacing_v = 0,
						spacing_h = -5,
						text_point = "BOTTOM;RIGHT",
					},
				}
			end
			
			if not C.db.profile.aurawidgets.spelllist[selectedspell].width then
				C.db.profile.aurawidgets.spelllist[selectedspell].width = 200
			end
		
			if not C.db.profile.aurawidgets.spelllist[selectedspell].height then
				C.db.profile.aurawidgets.spelllist[selectedspell].height = 20
			end
			
			if not C.db.profile.aurawidgets.spelllist[selectedspell].bartexture then
				C.db.profile.aurawidgets.spelllist[selectedspell].bartexture = "Blizzard Raid Bar"
			end
			
			if not C.db.profile.aurawidgets.spelllist[selectedspell].bartexturebg then
				C.db.profile.aurawidgets.spelllist[selectedspell].bartexturebg = "Blizzard Raid Bar"
			end
			if not C.db.profile.aurawidgets.spelllist[selectedspell].color then
				C.db.profile.aurawidgets.spelllist[selectedspell].color = { { 1, 1, 0, 1 }, { 0, 0, 0, 1} }
			end
			
			if C.db.profile.aurawidgets.spelllist[selectedspell].style == 1 then
				C.GUI.args.aurawidgets.args.settings.args.styleGroup = C:BuildIconStyleSetup()
			elseif C.db.profile.aurawidgets.spelllist[selectedspell].style == 2 then
				C.GUI.args.aurawidgets.args.settings.args.styleGroup = C:BuildBarStyleSetup()
			else
				C.GUI.args.aurawidgets.args.settings.args.styleGroup = nil
			end
				
		end,
		get = function(self)
			return selectedspell
		end,	
	}
	
	
	o.args.settings.args.enableGroup = {
		name = "",
		type = "group",
		order = 1,
		embend = true,
		args = {},	
	}
	
	o.args.settings.args.enableGroup.args.enable = {
		name = L["Включить"],
		type = "toggle",
		order = 1,
		set = function(self, value)
			if selectedspell then
				C.db.profile.aurawidgets.spelllist[selectedspell].show = not C.db.profile.aurawidgets.spelllist[selectedspell].show
				C:UpdateAuraWidgets()
			end
		end,
		get = function(self)
			if selectedspell then
				return C.db.profile.aurawidgets.spelllist[selectedspell].show or false
			else
				return false
			end
		end,
	}
	
	o.args.settings.args.enableGroup.args.unlock = {
		name = L["Двигать"],
		type = "execute",
		order = 3,
		set = function(self, value)
			if selectedspell then
				C:UnlockMover(selectedspell)
			end
		end,
		get = function(self)
			return false
		end,
	}
	
	o.args.settings.args.enableGroup.args.style = {
		name = L["Вид отображения"],
		type = "dropdown",
		order = 2,
		values = {		
			L["Иконка"],
			L["Полоса"],
		},
		set = function(self, value)
			if selectedspell then
				C.db.profile.aurawidgets.spelllist[selectedspell].style = value
				C:UpdateAuraWidgets()
			
				if C.db.profile.aurawidgets.spelllist[selectedspell].style == 1 then
					C.GUI.args.aurawidgets.args.settings.args.styleGroup = C:BuildIconStyleSetup()
				elseif C.db.profile.aurawidgets.spelllist[selectedspell].style == 2 then
					C.GUI.args.aurawidgets.args.settings.args.styleGroup = C:BuildBarStyleSetup()
				else
					C.GUI.args.aurawidgets.args.settings.args.styleGroup = nil
				end
		
			end
		end,
		get = function(self)
			if selectedspell then
				return C.db.profile.aurawidgets.spelllist[selectedspell].style or 1
			else
				return 1
			end
		end,	
	}
	
	if selectedspell then
		if C.db.profile.aurawidgets.spelllist[selectedspell].style == 1 then
			o.args.settings.args.styleGroup = C:BuildIconStyleSetup()
		elseif C.db.profile.aurawidgets.spelllist[selectedspell].style == 2 then
			o.args.settings.args.styleGroup = C:BuildBarStyleSetup()
		else
			o.args.settings.args.styleGroup = nil
		end
	else
		o.args.settings.args.styleGroup = nil
	end
	
	o.args.settings.args.spellIDGroup = {
		name = "",
		type = "group",
		order = 3,
		embend = true,
		args = {},	
	}
	
	o.args.settings.args.spellIDGroup.args.checkID = {
		name = L["Проверять ID"], desc = L['Показывать ауру только с соответствующим "ID Заклинания"'],
		type = "toggle",
		order = 2,
		set = function(self, value)
			if selectedspell then
				C.db.profile.aurawidgets.spelllist[selectedspell].checkID = not C.db.profile.aurawidgets.spelllist[selectedspell].checkID
				C:UpdateAuraWidgets()
			end
		end,
		get = function(self)
			if selectedspell then
				return C.db.profile.aurawidgets.spelllist[selectedspell].checkID or false
			else
				return false
			end
		end,	
	}
	o.args.settings.args.spellIDGroup.args.spellID = {
		name = L["ID Заклинания"],
		type = "editbox",
		order = 1,
		set = function(self, value)
			local num = tonumber(value)
			
			if selectedspell and num then
				C.db.profile.aurawidgets.spelllist[selectedspell].spellID = num
				C:UpdateAuraWidgets()
			end
		end,
		get = function(self)
			if selectedspell then
				return C.db.profile.aurawidgets.spelllist[selectedspell].spellID or ''
			else
				return ''
			end
		end,
	}
	
	o.args.settings.args.ICDGroup = {
		name = "",
		type = "group",
		order = 3,
		embend = true,
		args = {},	
	}
	
	o.args.settings.args.ICDGroup.args.ICD = {
		name = L["Скрытый КД"], desc = L["Укажите скрытую перезарядку ауры."],
		type = "editbox",
		order = 1,
		set = function(self, value)
			local num = tonumber(value)
			
			if selectedspell and num then
				C.db.profile.aurawidgets.spelllist[selectedspell].ICD = num
				C:UpdateAuraWidgets()
			end
		end,
		get = function(self)
			if selectedspell then
				return C.db.profile.aurawidgets.spelllist[selectedspell].ICD or ''
			else
				return ''
			end
		end,
	}
	
	o.args.settings.args.ICDGroup.args.showICD = {
		name = L["Включить"], desc = L["Показывать скрытую перезаряюку"],
		type = "toggle",
		order = 2,
		set = function(self, value)
			if selectedspell then
				C.db.profile.aurawidgets.spelllist[selectedspell].showICD = not C.db.profile.aurawidgets.spelllist[selectedspell].showICD
				C:UpdateAuraWidgets()
			end
		end,
		get = function(self)
			if selectedspell then
				return C.db.profile.aurawidgets.spelllist[selectedspell].showICD or false
			else
				return false
			end
		end,	
	}
	
	return o
end

function C:BuildIconStyleSetup()
	local st = {
		name = "Стиль",
		type = "group",
		order = 2,
		embend = true,
		args = {},		
	}
	
	st.args.icon_size = {
		order = 1, name = L["Размер"],
		type = "slider", min = 1, max = 300, step = 1,
		set = function(self, value)
			if selectedspell then
				C.db.profile.aurawidgets.spelllist[selectedspell].size = value
			end
			C:UpdateAuraWidgets()
			C:UpdateIconStyle(selectedspell)
		end,
		get = function(self)		
			if selectedspell then
				return C.db.profile.aurawidgets.spelllist[selectedspell].size or 20
			else
				return 20
			end
		end	
	}
	
	st.args.borders ={
		order = 10,name = L["Граница"],type = "group", embend = true,
		args={
		
		},
	}
	
	st.args.borders.args.border = {
		order = 19.1,type = 'border',name = L["Текстура"],
		values = C.SharedMedia:HashTable("border"),
		set = function(info,value) C.db.profile.aurawidgets.spelllist[selectedspell].border.texture = value; C:UpdateIconStyle(selectedspell)end,
		get = function(info) return C.db.profile.aurawidgets.spelllist[selectedspell].border.texture end,
	}
					
	st.args.borders.args.bordercolor = {
		order = 19.2,name = L["Цвет"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) 
			C.db.profile.aurawidgets.spelllist[selectedspell].border.color={r,g,b,a};
			C:UpdateIconStyle(selectedspell)
		end,
		get = function(info) 
			return C.db.profile.aurawidgets.spelllist[selectedspell].border.color[1],
			C.db.profile.aurawidgets.spelllist[selectedspell].border.color[2],
			C.db.profile.aurawidgets.spelllist[selectedspell].border.color[3],
			C.db.profile.aurawidgets.spelllist[selectedspell].border.color[4]
		end
	}
					
	st.args.borders.args.bordersize = {
		name = L["Размер"],
		type = "slider",
		order	= 19.3,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			C.db.profile.aurawidgets.spelllist[selectedspell].border.size = val
			C:UpdateIconStyle(selectedspell)
		end,
		get =function(info)
			return C.db.profile.aurawidgets.spelllist[selectedspell].border.size
		end,
	}
	st.args.borders.args.borderinset = {
		name = L["Отступ границ"],
		type = "slider",
		order	= 19.4,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			C.db.profile.aurawidgets.spelllist[selectedspell].border.inset = val
			C:UpdateIconStyle(selectedspell)
		end,
		get =function(info)
			return C.db.profile.aurawidgets.spelllist[selectedspell].border.inset
		end,
	}
	
	st.args.borders.args.bgcolor = {
		order = 19.2,name = L["Фон"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) 
			C.db.profile.aurawidgets.spelllist[selectedspell].border.background={r,g,b,a};
			C:UpdateIconStyle(selectedspell)
		end,
		get = function(info) 
			return C.db.profile.aurawidgets.spelllist[selectedspell].border.background[1],
			C.db.profile.aurawidgets.spelllist[selectedspell].border.background[2],
			C.db.profile.aurawidgets.spelllist[selectedspell].border.background[3],
			C.db.profile.aurawidgets.spelllist[selectedspell].border.background[4]
		end
	}
	st.args.borders.args.bginset = {
		name = L["Отступ фона"],
		type = "slider",
		order	= 19.4,
		min		= -50,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			C.db.profile.aurawidgets.spelllist[selectedspell].border.bg_inset = val
			C:UpdateIconStyle(selectedspell)
		end,
		get =function(info)
			return C.db.profile.aurawidgets.spelllist[selectedspell].border.bg_inset
		end,
	}
	
	st.args.font ={
		order = 3,name = L["Шрифт"],type = "group", embend = true,
		args={
			font = {
				order = 4,name = L["Шрифт"],type = 'font',
				values = C.SharedMedia:HashTable("font"),
				set = function(info,key) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.font = key
					C:UpdateIconStyle(selectedspell)
				end,
				get = function(info) return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.font end,
			},
			time_format = {
				name = L["Формат времени"],
				type = "dropdown",
				order	= 4.1,
				values = {
					"1 3 10 20 50",
					"0.1 1 1.5 3"
				},
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].time_format = val
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].time_format
				end,
			},
			fontflag = {
				type = "dropdown",	order = 4.2,
				name = L["Обводка шрифта"],
				values = {
					["NONE"] = NO,
					["OUTLINE"] = "OUTLINE",
					["THICKOUTLINE"] = "THICKOUTLINE",
					["MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
				},
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.fontflag = val
					C:UpdateIconStyle(selectedspell)
				end,
				get = function(info) return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.fontflag end
			},
			--[[
			shadow_pos1 = {
				name = L["Тень текста X"], disabled = false,
				type = "slider",
				order	= 5,
				min		= -5,
				max		= 5,
				step	= 0.1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.shadow_pos[1] = val
					C:UpdateIconStyle(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.shadow_pos[1]
				end,
			},
			shadow_pos2 = {
				name = L["Тень текста Y"], disabled = false,
				type = "slider",
				order	= 5.1,
				min		= -5,
				max		= 5,
				step	= 0.1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.shadow_pos[2] = val
					C:UpdateIconStyle(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.shadow_pos[2]
				end,
			},
			]]
		},
	}
	
	st.args.timer ={
		order = 10,name = L["Таймер"],type = "group", embend = true,
		args={
			hide_timer_text = {
				order = 1,name = L["Показать текст таймера"],type = "toggle",
				desc = L["Показать текст таймера"],
				set = function(info,val) C.db.profile.aurawidgets.spelllist[selectedspell].hide_timer_text = not C.db.profile.aurawidgets.spelllist[selectedspell].hide_timer_text; C:UpdateIconStyle(selectedspell);end,
				get = function(info) return C.db.profile.aurawidgets.spelllist[selectedspell].hide_timer_text end
			},
			fontisize_stack = {
				name = L["Размер шрифта"], disabled = false,
				type = "slider",
				order	= 1,
				min		= 1,
				max		= 32,
				step	= 1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.fontsize = val
					C:UpdateIconStyle(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.fontsize
				end,
			},
			textposition_stack = {	
				type = "dropdown",order = 6,
				name = L["Выравнивание текста"],
				desc = L["Выравнивание текста"],
				values = {
					["TOP;CENTER"] = L["Сверху"],
					["TOP;LEFT"] = L["Слева вверху"],
					["TOP;RIGHT"] = L["Справа вверху"],
					["CENTER;CENTER"] = L["Центр"],
					["BOTTOM;CENTER"] = L["Снизу"],
					["BOTTOM;LEFT"] = L["Слева внизу"],
					["BOTTOM;RIGHT"] = L["Справа внизу"],
					["CENTER;LEFT"] = L["По центру слева"],
					["CENTER;RIGHT"] = L["По центру справа"],
				},
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.text_point = val
					C:UpdateIconStyle(selectedspell)
				end,
				get = function(info) return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.text_point end
			},
			color = {
				order = 7,name = L["Цвет"], type = "color", hasAlpha = false,
				set = function(info,r,g,b,a) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.color ={r,g,b,1};
					C:UpdateIconStyle(selectedspell)
				end,
				get = function(info) 
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.color[1], C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.color[2], C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.color[3], 1
				end
			},
			font_pos_x = {
				name = L["Смещение по горизонтали"], disabled = false,
				type = "slider",
				order	= 10,
				min		= -50,
				max		= 50,
				step	= 1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.spacing_h = val
					C:UpdateIconStyle(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.spacing_h
				end,
			},
			font_pos_7 = {
				name = L["Смещение по вертикали"], disabled = false,
				type = "slider",
				order	= 15,
				min		= -50,
				max		= 50,
				step	= 1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.spacing_v = val
					C:UpdateIconStyle(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.spacing_v
				end,
			},
		},
	}
	
	st.args.stacks ={
		order = 20,name = L["Стаки"],type = "group", embend = true,
		args={
			fontisize_stack = {
				name = L["Размер шрифта"], disabled = false,
				type = "slider",
				order	= 1,
				min		= 1,
				max		= 32,
				step	= 1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.fontsize = val
					C:UpdateIconStyle(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.fontsize
				end,
			},
			textposition_stack = {	
				type = "dropdown",order = 6,
				name = L["Выравнивание текста"],
				desc = L["Выравнивание текста"],
				values = {
					["TOP;CENTER"] = L["Сверху"],
					["TOP;LEFT"] = L["Слева вверху"],
					["TOP;RIGHT"] = L["Справа вверху"],
					["CENTER;CENTER"] = L["Центр"],
					["BOTTOM;CENTER"] = L["Снизу"],
					["BOTTOM;LEFT"] = L["Слева внизу"],
					["BOTTOM;RIGHT"] = L["Справа внизу"],
					["CENTER;LEFT"] = L["По центру слева"],
					["CENTER;RIGHT"] = L["По центру справа"],
				},
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.text_point = val
					C:UpdateIconStyle(selectedspell)
				end,
				get = function(info) return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.text_point end
			},
			color = {
				order = 7,name = L["Цвет"], type = "color", hasAlpha = false,
				set = function(info,r,g,b,a) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.color ={r,g,b,1};					
					C:UpdateIconStyle(selectedspell)
				end,
				get = function(info) 
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.color[1], C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.color[2], C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.color[3], 1
				end
			},
			font_pos_x = {
				name = L["Смещение по горизонтали"], disabled = false,
				type = "slider",
				order	= 10,
				min		= -50,
				max		= 50,
				step	= 1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.spacing_h = val
					C:UpdateIconStyle(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.spacing_h
				end,
			},
			font_pos_7 = {
				name = L["Смещение по вертикали"], disabled = false,
				type = "slider",
				order	= 15,
				min		= -50,
				max		= 50,
				step	= 1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.spacing_v = val
					C:UpdateIconStyle(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.spacing_v
				end,
			},
		},
	}
	
	return st
end

function C:BuildBarStyleSetup()
	local st = {
		name = "Стиль",
		type = "group",
		order = 2,
		embend = true,
		args = {},		
	}
	
	st.args.width = {
		order = 1, name = L["Ширина"],
		type = "slider", min = 1, max = 500, step = 1,
		set = function(self, value)
			if selectedspell then
				C.db.profile.aurawidgets.spelllist[selectedspell].width = value
			end
			C:UpdateAuraWidgets()
			C:UpdateStatusBarStyle_Aura(selectedspell)
		end,
		get = function(self)		
			if selectedspell then
				return C.db.profile.aurawidgets.spelllist[selectedspell].width or 200
			else
				return 200
			end
		end	
	}
	
	st.args.height = {
		order = 1, name = L["Высота"],
		type = "slider", min = 1, max = 60, step = 1,
		set = function(self, value)
			if selectedspell then
				C.db.profile.aurawidgets.spelllist[selectedspell].height = value
			end
			C:UpdateAuraWidgets()
			C:UpdateStatusBarStyle_Aura(selectedspell)
		end,
		get = function(self)		
			if selectedspell then
				return C.db.profile.aurawidgets.spelllist[selectedspell].height or 20
			else
				return 20
			end
		end	
	}
	
	st.args.iconGap = {
		order = 1, name = L["Отступ иконки"],
		type = "slider", min = 1, max = 60, step = 1,
		set = function(self, value)
			if selectedspell then
				C.db.profile.aurawidgets.spelllist[selectedspell].iconGap = value
			end
			C:UpdateAuraWidgets()
			C:UpdateStatusBarStyle_Aura(selectedspell)
		end,
		get = function(self)		
			if selectedspell then
				return C.db.profile.aurawidgets.spelllist[selectedspell].iconGap or 3
			else
				return 3
			end
		end	
	}
	
	st.args.borders ={
		order = 10,name = L["Граница"],type = "group", embend = true,
		args={
		
		},
	}
	
	st.args.borders.args.border = {
		order = 19.1,type = 'border',name = L["Текстура"],
		values = C.SharedMedia:HashTable("border"),
		set = function(info,value) C.db.profile.aurawidgets.spelllist[selectedspell].border.texture = value; C:UpdateStatusBarStyle_Aura(selectedspell) end,
		get = function(info) return C.db.profile.aurawidgets.spelllist[selectedspell].border.texture end,
	}
					
	st.args.borders.args.bordercolor = {
		order = 19.2,name = L["Цвет"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) 
			C.db.profile.aurawidgets.spelllist[selectedspell].border.color={r,g,b,a};
			C:UpdateStatusBarStyle_Aura(selectedspell)
		end,
		get = function(info) 
			return C.db.profile.aurawidgets.spelllist[selectedspell].border.color[1],
			C.db.profile.aurawidgets.spelllist[selectedspell].border.color[2],
			C.db.profile.aurawidgets.spelllist[selectedspell].border.color[3],
			C.db.profile.aurawidgets.spelllist[selectedspell].border.color[4]
		end
	}
					
	st.args.borders.args.bordersize = {
		name = L["Размер"],
		type = "slider",
		order	= 19.3,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			C.db.profile.aurawidgets.spelllist[selectedspell].border.size = val
			C:UpdateStatusBarStyle_Aura(selectedspell)
		end,
		get =function(info)
			return C.db.profile.aurawidgets.spelllist[selectedspell].border.size
		end,
	}
	st.args.borders.args.borderinset = {
		name = L["Отступ границ"],
		type = "slider",
		order	= 19.4,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			C.db.profile.aurawidgets.spelllist[selectedspell].border.inset = val
			C:UpdateStatusBarStyle_Aura(selectedspell)
		end,
		get =function(info)
			return C.db.profile.aurawidgets.spelllist[selectedspell].border.inset
		end,
	}
	
	st.args.borders.args.bgcolor = {
		order = 19.2,name = L["Фон"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) 
			C.db.profile.aurawidgets.spelllist[selectedspell].border.background={r,g,b,a};
			C:UpdateStatusBarStyle_Aura(selectedspell)
		end,
		get = function(info) 
			return C.db.profile.aurawidgets.spelllist[selectedspell].border.background[1],
			C.db.profile.aurawidgets.spelllist[selectedspell].border.background[2],
			C.db.profile.aurawidgets.spelllist[selectedspell].border.background[3],
			C.db.profile.aurawidgets.spelllist[selectedspell].border.background[4]
		end
	}
	st.args.borders.args.bginset = {
		name = L["Отступ фона"],
		type = "slider",
		order	= 19.4,
		min		= -50,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			C.db.profile.aurawidgets.spelllist[selectedspell].border.bg_inset = val
			C:UpdateStatusBarStyle_Aura(selectedspell)
		end,
		get =function(info)
			return C.db.profile.aurawidgets.spelllist[selectedspell].border.bg_inset
		end,
	}
	
	st.args.font ={
		order = 3,name = L["Шрифт"],type = "group", embend = true,
		args={
			font = {
				order = 4,name = L["Шрифт"],type = 'font',
				values = C.SharedMedia:HashTable("font"),
				set = function(info,key) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.font = key
					C:UpdateStatusBarStyle_Aura(selectedspell)
				end,
				get = function(info) return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.font end,
			},
			time_format = {
				name = L["Формат времени"],
				type = "dropdown",
				order	= 4.1,
				values = {
					"1 3 10 20 50",
					"0.1 1 1.5 3"
				},
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].time_format = val;
					C:UpdateStatusBarStyle_Aura(selectedspell);
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].time_format
				end,
			},
			fontflag = {
				type = "dropdown",	order = 4.2,
				name = L["Обводка шрифта"],
				values = {
					["NONE"] = NO,
					["OUTLINE"] = "OUTLINE",
					["THICKOUTLINE"] = "THICKOUTLINE",
					["MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
				},
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.fontflag = val
					C:UpdateStatusBarStyle_Aura(selectedspell)
				end,
				get = function(info) return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.fontflag end
			},
			--[[
			shadow_pos1 = {
				name = L["Тень текста X"], disabled = false,
				type = "slider",
				order	= 5,
				min		= -5,
				max		= 5,
				step	= 0.1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.shadow_pos[1] = val
					C:UpdateStatusBarStyle_Aura(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.shadow_pos[1]
				end,
			},
			shadow_pos2 = {
				name = L["Тень текста Y"], disabled = false,
				type = "slider",
				order	= 5.1,
				min		= -5,
				max		= 5,
				step	= 0.1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.shadow_pos[2] = val
					C:UpdateStatusBarStyle_Aura(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.shadow_pos[2]
				end,
			},
			]]
		},
	}
	
	st.args.statusbargrp ={
		order = 5.1, name = L["Текстуры полосы"],type = "group", embend = true,
		args={
		
		},
	}
	
	st.args.statusbargrp.args.statusbar1 = {
		order = 1,type = 'statusbar',name = L["Основная текстура"], 
		values = C.SharedMedia:HashTable("statusbar"),
		set = function(info,value) C.db.profile.aurawidgets.spelllist[selectedspell].bartexture = value; C:UpdateStatusBarStyle_Aura(selectedspell);end,
		get = function(info) return C.db.profile.aurawidgets.spelllist[selectedspell].bartexture end,
	}
	--[[
	st.args.statusbargrp.args.statusbarbg = {
		order = 3,type = 'statusbar',name = L["Текстура фона"], 
		values = C.SharedMedia:HashTable("statusbar"),
		set = function(info,value) C.db.profile.aurawidgets.spelllist[selectedspell].spelllist[selectedspell].bartexturebg = value; C:UpdateStatusBarStyle_Aura(selectedspell);end,
		get = function(info) return C.db.profile.aurawidgets.spelllist[selectedspell].bartexturebg end,
	}
	]]
	st.args.statusbargrp.args.statusbar1_color = {
		order = 2,name = L["Цвет"], type = "color", hasAlpha = false,
		set = function(info,r,g,b,a) 
			C.db.profile.aurawidgets.spelllist[selectedspell].color[1] ={r,g,b,1};					
			C:UpdateStatusBarStyle_Aura(selectedspell)
		end,
		get = function(info) 
			return C.db.profile.aurawidgets.spelllist[selectedspell].color[1][1], 
			C.db.profile.aurawidgets.spelllist[selectedspell].color[1][2], 
			C.db.profile.aurawidgets.spelllist[selectedspell].color[1][3], 1
		end
	}
	--[[
	st.args.statusbargrp.args.statusbarbg_color = {
		order = 4,name = L["Цвет фона"], type = "color", hasAlpha = false,
		set = function(info,r,g,b,a) 
			C.db.profile.aurawidgets.spelllist[selectedspell].color[2] ={r,g,b,1};					
			C:UpdateStatusBarStyle_Aura(selectedspell)
		end,
		get = function(info) 
			return C.db.profile.aurawidgets.spelllist[selectedspell].color[2][1], 
			C.db.profile.aurawidgets.spelllist[selectedspell].color[2][2], 
			C.db.profile.aurawidgets.spelllist[selectedspell].color[2][3], 1
		end
	}
	]]
	st.args.timer ={
		order = 10,name = L["Текст"],type = "group", embend = true,
		args={
			--[[
			hide_timer_text = {
				order = 1,name = L["Показать текст таймера"],type = "toggle",
				desc = L["Показать текст таймера"],
				set = function(info,val) C.db.profile.aurawidgets.spelllist[selectedspell].hide_timer_text = not C.db.profile.aurawidgets.spelllist[selectedspell].hide_timer_text; C:UpdateIconStyle(selectedspell);end,
				get = function(info) return C.db.profile.aurawidgets.spelllist[selectedspell].hide_timer_text end
			},
			]]
			fontisize_stack = {
				name = L["Размер шрифта"], disabled = false,
				type = "slider",
				order	= 1,
				min		= 1,
				max		= 32,
				step	= 1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.fontsize = val
					C:UpdateStatusBarStyle_Aura(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.fontsize
				end,
			},
			--[[
			textposition_stack = {	
				type = "dropdown",order = 6,
				name = L["Выравнивание текста"],
				desc = L["Выравнивание текста"],
				values = {
					["TOP;CENTER"] = L["Сверху"],
					["TOP;LEFT"] = L["Слева вверху"],
					["TOP;RIGHT"] = L["Справа вверху"],
					["CENTER;CENTER"] = L["Центр"],
					["BOTTOM;CENTER"] = L["Снизу"],
					["BOTTOM;LEFT"] = L["Слева внизу"],
					["BOTTOM;RIGHT"] = L["Справа внизу"],
					["CENTER;LEFT"] = L["По центру слева"],
					["CENTER;RIGHT"] = L["По центру справа"],
				},
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.text_point = val
					C:UpdateIconStyle(selectedspell)
				end,
				get = function(info) return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.text_point end
			},
			]]
			color = {
				order = 7,name = L["Цвет"], type = "color", hasAlpha = false,
				set = function(info,r,g,b,a) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.color ={r,g,b,1};
					C:UpdateStatusBarStyle_Aura(selectedspell)
				end,
				get = function(info) 
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.color[1], C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.color[2], C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.color[3], 1
				end
			},
			--[[
			font_pos_x = {
				name = L["Смещение по горизонтали"], disabled = false,
				type = "slider",
				order	= 10,
				min		= -50,
				max		= 50,
				step	= 1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.spacing_h = val
					C:UpdateIconStyle(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.spacing_h
				end,
			},
			font_pos_7 = {
				name = L["Смещение по вертикали"], disabled = false,
				type = "slider",
				order	= 15,
				min		= -50,
				max		= 50,
				step	= 1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.spacing_v = val
					C:UpdateIconStyle(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.timer.spacing_v
				end,
			},
			]]
		},
	}
	--[[
	st.args.stacks ={
		order = 20,name = L["Стаки"],type = "group", embend = true,
		args={
			fontisize_stack = {
				name = L["Размер шрифта"], disabled = false,
				type = "slider",
				order	= 1,
				min		= 1,
				max		= 32,
				step	= 1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.fontsize = val
					C:UpdateIconStyle(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.fontsize
				end,
			},
			textposition_stack = {	
				type = "dropdown",order = 6,
				name = L["Выравнивание текста"],
				desc = L["Выравнивание текста"],
				values = {
					["TOP;CENTER"] = L["Сверху"],
					["TOP;LEFT"] = L["Слева вверху"],
					["TOP;RIGHT"] = L["Справа вверху"],
					["CENTER;CENTER"] = L["Центр"],
					["BOTTOM;CENTER"] = L["Снизу"],
					["BOTTOM;LEFT"] = L["Слева внизу"],
					["BOTTOM;RIGHT"] = L["Справа внизу"],
					["CENTER;LEFT"] = L["По центру слева"],
					["CENTER;RIGHT"] = L["По центру справа"],
				},
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.text_point = val
					C:UpdateIconStyle(selectedspell)
				end,
				get = function(info) return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.text_point end
			},
			color = {
				order = 7,name = L["Цвет"], type = "color", hasAlpha = false,
				set = function(info,r,g,b,a) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.color ={r,g,b,1};					
					C:UpdateIconStyle(selectedspell)
				end,
				get = function(info) 
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.color[1], C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.color[2], C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.color[3], 1
				end
			},
			font_pos_x = {
				name = L["Смещение по горизонтали"], disabled = false,
				type = "slider",
				order	= 10,
				min		= -50,
				max		= 50,
				step	= 1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.spacing_h = val
					C:UpdateIconStyle(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.spacing_h
				end,
			},
			font_pos_7 = {
				name = L["Смещение по вертикали"], disabled = false,
				type = "slider",
				order	= 15,
				min		= -50,
				max		= 50,
				step	= 1,
				set = function(info,val) 
					C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.spacing_v = val
					C:UpdateIconStyle(selectedspell)
				end,
				get =function(info)
					return C.db.profile.aurawidgets.spelllist[selectedspell].fonts.stack.spacing_v
				end,
			},
		},
	}
	]]

	return st	
end
