local AddOn = ...
local C = _G[AddOn]

local frames = {}

local textures = {
	[1] = GetSpellTexture(1079),   -- 1079 ����
	[2] = GetSpellTexture(155722), -- 155722 �������� ����
	[3] = GetSpellTexture(155625), -- 155625 ������ �����
	[4] = GetSpellTexture(106830), -- 106830 �������
	[5] = GetSpellTexture(339), -- �����
--	[6] = GetSpellTexture(210705), -- ���� ����
}

local hidenotexists = false

local multi_icon_time_format = 1
local num_auras = 5

local function FortatTimer(duration)
	
	if multi_icon_time_format == 1 then
		if duration > 3 then
			return format(" %.0f ", ceil(duration))
		else
			return format(" %.0f ", ceil( duration >= 0 and duration or 0.0))
		end
	else
		if duration > 3 then
			return format(" %.0f ", duration)
		else
			return format(" %.1f ", ( duration >= 0 and duration or 0.0))
		end
	end
end

for i=1, 10 do
	
	local f = CreateFrame("Frame", nil, UIParent)
	f:SetSize(1, 25)
	f.spells = {}
	f:SetScale(1)
	
	for k=1, num_auras do
		local backdrop = CreateFrame("Frame", 'FDDGroup'..i..'Icon'..k, f)
		local s = backdrop:CreateTexture(nil, "ARTWORK")
		s:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		s:SetTexture(textures[k])
		s:SetSize(25, 25)
		
		if k==1 then
			s:SetPoint("RIGHT", f, "RIGHT")
		else
			s:SetPoint("RIGHT", f.spells[k-1], "LEFT", 1, 0)
		end

		local t = backdrop:CreateFontString(nil, "OVERLAY")
		t:SetPoint("BOTTOMRIGHT", s, "BOTTOMRIGHT", 0, 0)
		t:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
		t:SetJustifyH("RIGHT")
		t:SetJustifyV("BOTTOM")
		backdrop:SetBackdrop({
			edgeFile = C.SharedMedia:Fetch("border", "Default"),
			edgeSize = 1,
		})
		backdrop:SetBackdropBorderColor(0, 0, 0, 1)
		backdrop:SetPoint("TOPLEFT", s, "TOPLEFT", -1, 1)
		backdrop:SetPoint("BOTTOMRIGHT", s, "BOTTOMRIGHT" , 1, -1)
		
		local bg = f:CreateTexture(nil, "BACKGROUND", nil, 0)
		bg:SetPoint("TOPLEFT", s, "TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", s, "BOTTOMRIGHT", 1, -1)
		bg:SetColorTexture(0,0,0,1)
		
		s.bg = bg
		s.backdrop = backdrop
		
		s.timer = t
		
		f.spells[k] = s
	end
	
	local name = f:CreateFontString()
	name:SetPoint("RIGHT", f.spells[num_auras], "LEFT")
	name:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
	name:SetJustifyH("RIGHT")
	name:SetHeight(14)
	name:SetWidth(200)
	
	f.name = name
	
	frames[i] = f
end

local order = {}

local loop = CreateFrame("Frame")
loop:SetScript("OnUpdate", function(self, elapsed)
	
	local closeme = 0
	local doupdate = false
	
	for i=1, 10 do

		
		if frames[i].show then
			closeme = i
			frames[i]:Show()			
			frames[i].name:SetText(frames[i]._name)
			
			for ii=1,num_auras do
				
		--		print("T1", ii, frames[i]["_spell"..ii], frames[i].spells[ii].enabled, frames[i].spells[ii]._spellID)
				
				if frames[i]["_spell"..ii] and frames[i].spells[ii].enabled then
					frames[i].spells[ii]:Show()			
					frames[i].spells[ii].bg:Show(); frames[i].spells[ii].bg:SetAlpha(1);
					frames[i].spells[ii].backdrop:Show(); frames[i].spells[ii].backdrop:SetAlpha(1);
					
					if frames[i]["_spell"..ii][2] < GetTime() then
						frames[i].spells[ii]:SetDesaturated(true)
						frames[i].spells[ii].timer:SetText('')
						frames[i].spells[ii]:SetAlpha(0.6)
					else
						frames[i].spells[ii]:SetDesaturated(false)
						frames[i].spells[ii].timer:SetText(FortatTimer(frames[i]["_spell"..ii][2]-GetTime()))
						frames[i].spells[ii]:SetAlpha(1)	
					end
	
					if not doupdate then
						if frames[i]["_spell"..ii][2] < GetTime() then
							doupdate = true
						end
					end
				else					
					if hidenotexists then
						frames[i].spells[ii]:Hide()
						frames[i].spells[ii].bg:Hide(); frames[i].spells[ii].bg:SetAlpha(0.6);
						frames[i].spells[ii].backdrop:Hide(); frames[i].spells[ii].backdrop:SetAlpha(0.6);
					else
						if frames[i].spells[ii].enabled then
						
							if frames[i].spells[ii]._spellID == 155625 and not IsSpellKnown(155580) then
								frames[i].spells[ii]:Hide()
								frames[i].spells[ii].bg:Hide(); frames[i].spells[ii].bg:SetAlpha(0.6);
								frames[i].spells[ii].backdrop:Hide(); frames[i].spells[ii].backdrop:SetAlpha(0.6);
							elseif frames[i].spells[ii]._spellID == 210705 and not C.ashamaneBite then
								frames[i].spells[ii]:Hide()
								frames[i].spells[ii].bg:Hide(); frames[i].spells[ii].bg:SetAlpha(0.6);
								frames[i].spells[ii].backdrop:Hide(); frames[i].spells[ii].backdrop:SetAlpha(0.6);
							else
								frames[i].spells[ii]:Show()
								frames[i].spells[ii].bg:Show(); frames[i].spells[ii].bg:SetAlpha(0.6);
								frames[i].spells[ii].backdrop:Show(); frames[i].spells[ii].backdrop:SetAlpha(0.6);
							end
						else
							frames[i].spells[ii]:Hide()
							frames[i].spells[ii].bg:Hide(); frames[i].spells[ii].bg:SetAlpha(0.6);
							frames[i].spells[ii].backdrop:Hide(); frames[i].spells[ii].backdrop:SetAlpha(0.6);
						end
					end
					frames[i].spells[ii]:SetAlpha(0.6)
					frames[i].spells[ii]:SetDesaturated(true)
					frames[i].spells[ii].timer:SetText("")
				end
			end
		end
	end
	
	if closeme == 0 then
		self:Hide()
	end
	
	if doupdate then
		doupdate = false
		C:UpdateMultiDot()
	end
end)

function C:MultitargetFontUpdate()
	for i=1, 10 do
		frames[i].name:SetFont(C.SharedMedia:Fetch("font", C.db.profile.font), C.db.profile.multi_font_size, C.db.profile.fontflag)
		
		if C.db.profile.multi_hide_names then
			frames[i].name:Hide()
		else
			frames[i].name:Show()
		end
		
		for f = 1, num_auras do			
			frames[i].spells[f].timer:SetFont(C.SharedMedia:Fetch("font", C.db.profile.font), C.db.profile.multi_font_icon_size, C.db.profile.fontflag)
			
			frames[i].spells[f].timer:SetSize(C.db.profile.multi_font_size*4, C.db.profile.multi_font_size*2)
			frames[i].spells[f].timer:SetPoint("BOTTOMRIGHT", frames[i].spells[f], "BOTTOMRIGHT", C.db.profile.multi_font_size*0.4, 0)
		end
	end
end

function C:UpdateMultiDotBorders()
	for i=1, 10 do
		
		for f=1, num_auras do
	
			frames[i].spells[f].backdrop:SetBackdrop({
				edgeFile = C.SharedMedia:Fetch("border", C.db.profile.multi_border.texture),
				edgeSize = C.db.profile.multi_border.size,
			})
			frames[i].spells[f].backdrop:SetBackdropBorderColor(C.db.profile.multi_border.color[1], C.db.profile.multi_border.color[2], C.db.profile.multi_border.color[3], C.db.profile.multi_border.color[4])
			frames[i].spells[f].backdrop:SetPoint("TOPLEFT", frames[i].spells[f], "TOPLEFT", -C.db.profile.multi_border.inset, C.db.profile.multi_border.inset)
			frames[i].spells[f].backdrop:SetPoint("BOTTOMRIGHT", frames[i].spells[f], "BOTTOMRIGHT", C.db.profile.multi_border.inset, -C.db.profile.multi_border.inset)
			
			frames[i].spells[f].bg:SetPoint("TOPLEFT", frames[i].spells[f], "TOPLEFT", -C.db.profile.multi_border.bg_inset, C.db.profile.multi_border.bg_inset)
			frames[i].spells[f].bg:SetPoint("BOTTOMRIGHT", frames[i].spells[f], "BOTTOMRIGHT", C.db.profile.multi_border.bg_inset, -C.db.profile.multi_border.bg_inset)
			frames[i].spells[f].bg:SetColorTexture(C.db.profile.multi_border.background[1], C.db.profile.multi_border.background[2], C.db.profile.multi_border.background[3], C.db.profile.multi_border.background[4])
		end
	end
end

local movingFrameMulti = CreateFrame("Frame", nil, UIParent)
movingFrameMulti:SetSize(220, 20)
movingFrameMulti:SetMovable(true)
movingFrameMulti:RegisterForDrag("LeftButton")
movingFrameMulti:SetScript("OnDragStart", function(self) 
	frames[1]:StartMoving() 
end)
movingFrameMulti:SetScript("OnDragStop", function(self) 
	frames[1]:StopMovingOrSizing()
	local x, y = frames[1]:GetCenter()
	local ux, uy = UIParent:GetCenter()

	C.db.profile.multi_xpos = floor(x - ux + 0.5)
	C.db.profile.multi_ypos = floor(y - uy + 0.5)
	
	frames[1]:SetPoint("CENTER", UIParent, "CENTER", C.db.profile.multi_xpos, C.db.profile.multi_ypos)	
end)
		
movingFrameMulti.bg = movingFrameMulti:CreateTexture()
movingFrameMulti.bg:SetAllPoints()
movingFrameMulti.bg:SetColorTexture(1, 1, 1, 0.6)
movingFrameMulti:Hide()

function C:ShowMovingFrame()
	C:UpdateMultiDot()
	
	C:UnlockMover("MultiTargetFrames")
end

-- 1079 ����
-- 155722 �������� ����
-- 106830 �������
-- 155625 ������ �����
local spellOrder = { 155722, 1079, 106830, 339, 155625 } --210705

local unitList = { "target", "focus", "boss1", "boss2", "boss3", "boss4", "boss5" }

local function GetGUIDName(guid)
	
	for i=1, 7 do
		if UnitGUID(unitList[i]) == guid then 
			return UnitName(unitList[i])
		end
	end
	
	for i=1, 30 do
		local unut = 'nameplate'..i
		if UnitGUID(unut) == guid then 
			return UnitName(unut)
		end
	end
end

local function IsEnabled(spellID)

	if spellID == 339 or spellID == 155625 then
		return C.db.profile.multi_spells_[339][1] or C.db.profile.multi_spells_[155625][1]
	end
	--[==[
	if spellID == 210705 then
		return C.db.profile.multi_spells_[210705][1]
	end
	]==]
	return C.db.profile.multi_spells_[spellID][1]
end

function C:UpdateMultiDot()

	wipe(order)

	local growup = C.db.profile.growing or false
	
	local xpos, ypos = C.db.profile.multi_xpos, C.db.profile.multi_ypos
	local scale = C.db.profile.multi_scale or 1
	local size = C.db.profile.multi_icon_size or 25
	local gap = C.db.profile.multi_icon_gap or 1
	local spacing = C.db.profile.multi_spacing or 2
	
	multi_icon_time_format = C.db.profile.multi_icon_time_format or 1
	
	hidenotexists = C.db.profile.multi_icon_hide_not_exists or false
	
	C:Mover(frames[1], "MultiTargetFrames", 220, 20, "RIGHT")
	
	frames[1]:Hide()
	frames[1].show = false
	frames[1]:SetScale(scale)
	frames[1]:SetHeight(size)
	
	for f=1, num_auras do
		if f == 1 then
			frames[1].spells[f]:SetSize(size,size)
		else
			frames[1].spells[f]:SetPoint("RIGHT", frames[1].spells[f-1], "LEFT", -gap, 0)	
			frames[1].spells[f]:SetSize(size,size)
		end
	end

	if growup then
		for i=2, 10 do
			frames[i]:ClearAllPoints()
			frames[i]:SetPoint("BOTTOM", frames[i-1] ,"TOP", 0, spacing)
			frames[i]:Hide()
			frames[i].show = false
			frames[i]:SetScale(scale)
			frames[i]:SetHeight(size)
			frames[i].spells[1]:SetSize(size,size)
	
			for d = 2, num_auras do
				frames[i].spells[d]:SetSize(size,size)
				frames[i].spells[d]:SetPoint("RIGHT", frames[i].spells[d-1], "LEFT", -gap, 0)	
			end
		end
	else
		for i=2, 10 do
			frames[i]:ClearAllPoints()
			frames[i]:SetPoint("TOP", frames[i-1] ,"BOTTOM", 0, -spacing)
			frames[i]:Hide()
			frames[i].show = false
			frames[i]:SetScale(scale)
			frames[i]:SetHeight(size)
			frames[i].spells[1]:SetSize(size,size)
			
			for d = 2, num_auras do
				frames[i].spells[d]:SetSize(size,size)
				frames[i].spells[d]:SetPoint("RIGHT", frames[i].spells[d-1], "LEFT", -gap, 0)
			end
		end
	end
	
	if not self.db.profile.multi_enable then
		return
	end
	
	if C.only_in_cantForm and ( GetShapeshiftFormID() ~= CAT_FORM ) then
		return
	end
	
	
	for guidspellid, data in pairs(self.dot_store) do
		
		if not self.db.profile.multi_show_target then
			if UnitGUID('target') ~= data[13] then
				if data[2] > GetTime()  and not order[data[13]] and data then
					order[data[13]] = true
				end
			end
		else
			if data[2] > GetTime()  and not order[data[13]] and data then
				order[data[13]] = true
			end
		end
	end
	
	local index = 1
	for guid in pairs(order) do
		if index > 10 then 
			break 
		end

		
		local index2 = num_auras
		local name = nil
		local showing = false
		
		frames[index]._spell1, frames[index]._spell2, frames[index]._spell3, frames[index]._spell4, frames[index]._spell5 = false, false, false, false, false
	
		if hidenotexists then
			for i = 1, num_auras do
				local spellID = spellOrder[i]
				local spell = self.dot_store[guid..spellID]
				
				if spellID == 339 and not spell then
					spellID = 102359
					spell = self.dot_store[guid..'102359']
				end
				--[==[
				if spellID == 210705 and not spell then
					spell = self.dot_store[guid..'210705']
				end
				]==]
				
				frames[index].spells[index2].enabled = false
				frames[index].spells[index2]._spellID = -1
				frames[index]._guid = nil
				
				if IsEnabled(spellID) and spell and spell[2] > GetTime() then
					
					
					frames[index]["_spell"..index2] = spell
					frames[index].spells[index2]._spellID = spellID
					
					if spellID == C.razorvat_spid then
						if C:IsAshamaneBiteAvailible(guid) then
							frames[index].spells[index2]:SetTexture(C.customAshamaneBiteTexture)
						else
							frames[index].spells[index2]:SetTexture(GetSpellTexture(spellID))
						end
					else
						frames[index].spells[index2]:SetTexture(GetSpellTexture(spellID))
					end
					frames[index].spells[index2].enabled = true
					frames[index]._guid = guid
					
					if not name then
						name = spell[18]
					end
					
					showing = true
					index2 = index2 - 1
				end
			end		
		else
		
			-- 1079 ���������
			-- 155722 �������� ����
			-- 106830 �������
			-- 339 �����
			-- 155625 ������ �����
			-- local spellOrder = { 155722, 1079, 106830, 339, 155625 }
			-- 5 4 3 2 1
			
			for i=1, #frames[index].spells do
				frames[index].spells[i].enabled = false
				frames[index].spells[i]._spellID = -1
				frames[index]._guid = nil				
			end
			
			local index3 = num_auras
			for i = 1, num_auras do
				
				local spellID = spellOrder[i]
				local spell = self.dot_store[guid..spellID]
				
				if spellID == 339 and not spell then
					spellID = 102359
					spell = self.dot_store[guid..'102359']
				end
				--[==[
				if spellID == 210705 and not spell then
					spell = self.dot_store[guid..'210705']
				end
				]==]
			--	print('T2', 'num_auras', i, 'index3', index3, 'spellID', spellID, 'reset')
				frames[index]._guid = guid
				
				if IsEnabled(spellID) and spell and spell[2] > GetTime() then			
				
			--		print('T3', 'num_auras', i, 'index3', index3, 'spellID', spellID, spell)
					
					frames[index]["_spell"..index3] = spell
					frames[index].spells[index3].enabled = true
					
					if not name then
						name = spell[18]
					end
					
					showing = true
					frames[index].spells[index3]._spellID = spellID
					
					if spellID == C.razorvat_spid then
						if C:IsAshamaneBiteAvailible(guid) then
							frames[index].spells[index3]:SetTexture(C.customAshamaneBiteTexture)
						else
							frames[index].spells[index3]:SetTexture(GetSpellTexture(spellID))
						end
					else						
						frames[index].spells[index3]:SetTexture(GetSpellTexture(spellID))
					end
					
					index3 = index3 - 1
				elseif C.db.profile.multi_spells_[spellID][1] then		

				--	print('T4', 'num_auras', i, 'index3', index3, 'spellID', spellID, spell)
					
					frames[index].spells[index3]._spellID = spellID
					frames[index].spells[index3]:SetTexture(GetSpellTexture(spellID))
					frames[index].spells[index3].enabled = true
					index3 = index3 - 1
				end
				
				
			end
		end
		
		if showing then		
			frames[index].show = showing
			frames[index]._name = name or GetGUIDName(guid) or UNKNOWN
		
			if UnitGUID("target") == guid then			
				frames[index].name:SetTextColor(C.db.profile.multi_target_color[1], C.db.profile.multi_target_color[2], C.db.profile.multi_target_color[3], 1)
			else
				frames[index].name:SetTextColor(1, 1, 1, 1)
			end

			frames[index]:Show()

			index = index + 1
			
			loop:Show()
		end
	end
end
