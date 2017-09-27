local AddOn = ...
local C = _G[AddOn]
local L = AleaUI_GUI.GetLocale("FeralDotDamage")

local COOLDOWN_TAG 		= "COOLDOWN"
local AURA_TAG 			= "AURA"
local COOLDOWN_AURA_TAG = "COOLDOWN_AURA"

local options

local initialDBUpdate = 3

local GetSpellCooldownCharges
local perSpellMethids

local cooldownsParent = CreateFrame("Frame", AddOn.."cooldownsParent", UIParent)
cooldownsParent:SetScale(1)
cooldownsParent:SetSize(1,1)
cooldownsParent:SetPoint("TOP", C.movingFrame, "BOTTOM", 0, 0)
cooldownsParent:Hide()

C.cooldownsParent = cooldownsParent

-- 145152 

C.berserk_spid = 106951
C.berserk_name = GetSpellInfo(C.berserk_spid)

C.skullbuch_spid = 106839
C.skillbuch_name = GetSpellInfo(C.skullbuch_spid)

C.dash_spid = 1850
C.dash_name = GetSpellInfo(C.dash_spid)

C.survival_spid = 61336
C.survival_name = GetSpellInfo(C.survival_spid)

C.predator_spid = 69369
C.predator_name = GetSpellInfo(C.predator_spid)

C.trollberserk_spid = 26297
C.trollberserk_name = GetSpellInfo(C.trollberserk_spid)

--C.silaprirodi_spid = 102703
--C.silaprirodi_name = GetSpellInfo(C.silaprirodi_spid)

--C.serdcedikoy_spid = 108292
--C.serdcedikoy_name = GetSpellInfo(C.serdcedikoy_spid)

C.prirodnaya_spid = 124974
C.prirodnaya_name = GetSpellInfo(C.prirodnaya_spid)

C.sremit_rivok_spid = 102401
C.sremit_rivok_name = GetSpellInfo(C.sremit_rivok_spid)

C.astralskachek_spid = 102280
C.astralskachek_name = GetSpellInfo(C.astralskachek_spid)

C.trevogniyrev_spid = 77764
C.trevogniyrev_name = GetSpellInfo(C.trevogniyrev_spid)

C.eluneguid_spid = 202060
C.eluneguid_name = GetSpellInfo(C.eluneguid_spid)

C.ashamane_spid = 210722
C.ashamane_name = GetSpellInfo(C.ashamane_spid) 

C.ydarkogtiami_spid = 202028
C.ydarkogtiami_name = GetSpellInfo(C.ydarkogtiami_spid)

C.maim_spid = 22570
C.maim_name = GetSpellInfo(C.maim_spid)

local maimLegProcID = 236757

local format = format
local math_fmod = math.fmod
	
local formatList = {
	[1] = function(numb)
		if numb > 60 then
			return format(" %dm ", ceil(numb / 60))
		elseif numb > 3 then
			return format(" %.0f ", numb)
		elseif numb > 0 then
			return format(" %.0f ", numb)
		end
		
		return ''
	end,
	[2] = function(numb)
		if numb > 60 then
			return format(" %dm ", ceil(numb / 60))
		elseif numb > 3 then
			return format(" %.0f ", numb)
		elseif numb > 0 then
			return format(" %.1f ", numb)
		end
		
		return ''
	end,
	[3] = function(numb)
		if numb > 60 then
			return format("%d:%0.2d", numb/60, math_fmod(numb, 60))
		elseif numb > 3 then
			return format(" %.0f ", numb)
		elseif numb > 0 then
			return format(" %.0f ", numb)
		end	
		
		return ''
	end,
	[4] = function(numb)
		if numb > 60 then
			return format("%d:%0.2d", numb/60, math_fmod(numb, 60))
		elseif numb > 3 then
			return format(" %.0f ", numb)
		elseif numb > 0 then
			return format(" %.1f ", numb)
		end
		
		return ''
	end,
}

local function updateGlow(self, elapsed)
	self.elapsed = ( self.elapsed or 0 ) + ( elapsed * self.dir )
	if self.elapsed > 1 then
		self.dir = -1.7
	elseif self.elapsed <= 0 then
		self.dir = 1.7
	end

	self:SetAlpha(self.elapsed)
end

perSpellMethids = {
	["Predator"] = function(parent, timer)
		if C.db.profile.cooldowns.specificSpell[C.predator_spid].predatorIconRed and timer < 2 then
			local c = C.db.profile.cooldowns.specificSpell[C.predator_spid].color
			parent.icon:SetVertexColor(c[1], c[2], c[3], c[4])
		else
			parent.icon:SetVertexColor(1, 1, 1, 1)
		end
	end,
	['TF_ShowGlow'] = function(parent)
		if UnitBuff('player', (GetSpellInfo(5217))) then
			local start, duration = GetSpellCooldownCharges(5217)
			if start == 0 and duration == 0 then
				if parent._tfGlow ~= true then
					parent._tfGlow = true
					
					if not parent.glow:GetScript("OnUpdate") then
						parent.glow.elapsed = 0
						parent.glow:SetAlpha(0)
						parent.glow:SetScript("OnUpdate", updateGlow)
					end

					parent.glow:Show()
				end
			else
				if parent._tfGlow ~= false then
					parent._tfGlow = false
					
					parent.glow.elapsed = 0
					parent.glow:Hide()
					parent.glow:SetAlpha(0)
				end
			end
		else
			if parent._tfGlow ~= false then
				parent._tfGlow = false
				
				parent.glow.elapsed = 0
				parent.glow:Hide()
				parent.glow:SetAlpha(0)
			end
		end
	end,
	['Art_Regen'] = function(parent, timer)
	--	perSpellMethids['TF_ShowGlow'](parent)
		
		if C.db.profile.cooldowns.specificSpell[C.tigrinoe_spid].artRegen then	
			local name = UnitBuff('player', (GetSpellInfo(210583)))			
			if name then
				local c = C.db.profile.cooldowns.specificSpell[C.tigrinoe_spid].color
				parent.icon:SetVertexColor(c[1], c[2], c[3], c[4])
			else
				parent.icon:SetVertexColor(1, 1, 1, 1)
			end
		end
	end,
	["CP_ShowGlow"] = function()
		return C.db.profile.cooldowns.specificSpell[C.predator_spid].ShowGlow
	end,
	["CP_ShowPandemia"] = function(parent, timer)
	
		if C.db.profile.cooldowns.specificSpell[C.dikiyrev_spid].CP_Pandemia then
			
			if timer < 12.5  then
				if C.db.profile.cooldowns.specificSpell[C.dikiyrev_spid].CP_Pandemia_anim then			
					if not parent.glow:GetScript("OnUpdate") then
						parent.glow.elapsed = 0
						parent.glow:SetAlpha(0)
						parent.glow:SetScript("OnUpdate", updateGlow)
					end

					parent.glow:Show()
				else
					if parent.glow:GetScript("OnUpdate") then
						parent.glow:SetScript("OnUpdate", nil)
					end

					parent.glow:Show()
					parent.glow:SetAlpha(1)
				end
			else 
				parent.glow.elapsed = 0
				parent.glow:Hide()
				parent.glow:SetAlpha(0)
			end
		else
			parent.glow:Hide()
		end
	end,
	
	['Maim_LegendaryProc'] = function(parent, start, duration, stacks, status, maxstacks, reset)
		local name = UnitBuff('player', (GetSpellInfo(maimLegProcID)))		-- 212875
		
		if name and status == 3 then
			FeralDotDamage.ShowOverlayGlow(parent)
		else
			FeralDotDamage.HideOverlayGlow(parent)
		end
	end,
}

local placeholder = {
	[C.dikiyrev_glyph_spid] = C.dikiyrev_spid,
}

local spells_to_show = {
	{ id = C.berserk_spid, 		cd = 180 ,	default = true,  tip = COOLDOWN_AURA_TAG	},
	{ id = C.tigrinoe_spid, 	cd = 30 ,	default = true,  tip = COOLDOWN_AURA_TAG, onTimeIcon = 'Art_Regen' },
--	{ id = C.pererogdenie_spid,	cd = 180 ,	default = true,  tip = COOLDOWN_AURA_TAG, talent = C.pererogdenie_spid },
	{ id = C.skullbuch_spid, 	cd = 15	,	default = false, tip = COOLDOWN_AURA_TAG	},
	{ id = C.dash_spid,			cd = 180,	default = false, tip = COOLDOWN_AURA_TAG	},
	{ id = C.survival_spid,		cd = 120,	default = false, tip = COOLDOWN_AURA_TAG	},
	{ id = C.predator_spid,		cd = 12,	default = true,  tip = AURA_TAG			 , onTimeIcon = "Predator" },
	{ id = C.trollberserk_spid,	cd = 12,	default = true,  tip = COOLDOWN_AURA_TAG	},
	{ id = C.krovaviekogti_spid,cd = 30,	default = true,  tip = AURA_TAG			 , talent = 155672 },
--	{ id = C.silaprirodi_spid,	cd = 20,	default = true,  tip = COOLDOWN_TAG 	 , talent = 102703 },
--	{ id = C.serdcedikoy_spid,	cd = 360,	default = true,  tip = COOLDOWN_AURA_TAG , talent = 108292 },
--	{ id = C.prirodnaya_spid,	cd = 90,	default = true,  tip = COOLDOWN_AURA_TAG , talent = 124974 },
	{ id = C.sremit_rivok_spid,	cd = 15,	default = false, tip = COOLDOWN_TAG 	 , talent = 102401 },
	{ id = C.astralskachek_spid,cd = 30,	default = false, tip = COOLDOWN_TAG 	 , talent = 102280 },	
	{ id = C.trevogniyrev_spid,	cd = 120,	default = false, tip = COOLDOWN_AURA_TAG},
	{ id = C.clearcast_id,		cd = 15,	default = false, tip = AURA_TAG, },
	{ id = C.dikiyrev_spid,		cd = 40,	default = false, tip = AURA_TAG, onTimeIcon = "CP_ShowPandemia", onShowGlow = "CP_ShowGlow", talent = 52610 },
	{ id = C.eluneguid_spid,    cd = 45,	default = true,	 tip = COOLDOWN_TAG,       talent = 202060 },
	{ id = C.ashamane_spid,		cd = 75,	default = true,  tip = COOLDOWN_TAG,	   spellKnown = 210722 },
	{ id = C.ydarkogtiami_spid, cd = 16, 	default = true,  tip = COOLDOWN_TAG,	   talent = C.ydarkogtiami_spid },
	
	{ id = C.maim_spid,			cd = 1,		default = true,  tip = COOLDOWN_TAG,  onUpdate = 'Maim_LegendaryProc', item = 144354	},
}

local id_to_spell = {}
for i=1, #spells_to_show do
	id_to_spell[spells_to_show[i].id] = i
end

local order_spell = {}
local order_spell_to_id = {}

local frames = {}
local statusbars = {}
--[==[
local unusedOverlayGlows = {}
local numOverlayGlows = 0

local function OverlayGlowAnimOutFinished(animGroup)
  local overlay = animGroup:GetParent()
  local frame = overlay:GetParent()
  overlay:Hide()
  tinsert(unusedOverlayGlows, overlay)
  frame.overlay = nil
end

--FeralDotDamage.OverlayGlowAnimOutFinished = OverlayGlowAnimOutFinished

local function OverlayGlow_OnHide(self)
  if self.animOut:IsPlaying() then
    self.animOut:Stop()
    OverlayGlowAnimOutFinished(self.animOut)
  end
end

local function GetOverlayGlow()
  local overlay = tremove(unusedOverlayGlows)
  if not overlay then
   numOverlayGlows = numOverlayGlows + 1
    overlay = CreateFrame("Frame", "FDDGlowOverlay"..numOverlayGlows, UIParent, "FeralDotDamageSpellActivationAlert")
    overlay.animOut:SetScript("OnFinished", OverlayGlowAnimOutFinished)
    overlay:SetScript("OnHide", OverlayGlow_OnHide)
  end
  return overlay
end

local glow_spacing = 0.4

local function ShowOverlayGlow(frame)
  if frame.overlay then
    if frame.overlay.animOut:IsPlaying() then
      frame.overlay.animOut:Stop()
      frame.overlay.animIn:Play()
    end
  else
    frame.overlay = GetOverlayGlow()
    local frameWidth, frameHeight = frame:GetSize()
    frame.overlay:SetParent(frame)
    frame.overlay:ClearAllPoints()
    --Make the height/width available before the next frame:
    frame.overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4)
    frame.overlay:SetPoint("TOPLEFT", frame, "TOPLEFT", -frameWidth * glow_spacing, frameHeight * glow_spacing)
    frame.overlay:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", frameWidth * glow_spacing, -frameHeight * glow_spacing)
    frame.overlay.animIn:Play()
  end
end

--FeralDotDamage.ShowOverlayGlow = ShowOverlayGlow

local function HideOverlayGlow(frame)
  if frame.overlay then
    if frame.overlay.animIn:IsPlaying() then
      frame.overlay.animIn:Stop()
    end
    if frame:IsVisible() then
      frame.overlay.animOut:Play()
    else
      OverlayGlowAnimOutFinished(frame.overlay.animOut)
    end
  end
end

--FeralDotDamage.HideOverlayGlow = HideOverlayGlow
]==]
function C:UpdateCooldownsFrames()
	
	if C.db.profile.cooldowns.isvertical == 2 then
		C:Mover(cooldownsParent, "CooldownsFrames", 20, 220, "CENTER")
	else
		C:Mover(cooldownsParent, "CooldownsFrames", 220, 20, "CENTER")
	end
	
	options = C.db.profile

	local numicons = #order_spell
	local partial_1 = numicons%2  -- если 0 то середина между иконками 1 то середина иконки
	local numIconStep = floor(#order_spell*0.5)
	local width = C.db.profile.cooldowns.width-(C.db.profile.cooldowns.gap*(numicons-1))

	local rwidth = width/numicons
	
	if rwidth > C.db.profile.cooldowns.max_width then
		rwidth = C.db.profile.cooldowns.max_width 
	end
	
	local iconOffset = 0
	
	if partial_1 == 1 then
		-- Середина иконки			
		iconOffset = ( numIconStep * ( rwidth + C.db.profile.cooldowns.gap ) ) --+  ( swidth * 0.5 )
	else
		-- Середина отступа				
		iconOffset = ( numIconStep * rwidth ) + (( numIconStep - 1 ) * C.db.profile.cooldowns.gap) + ( C.db.profile.cooldowns.gap * 0.5 ) - ( rwidth * 0.5 )
	end
	
	for i=1, #order_spell do
		
		local spellID = order_spell[i]
		
		frames[i] = frames[i] or C:AddCooldownIcon(order_spell[i], cooldownsParent)
		
		frames[i].spellID2 = nil
		
		if spellID == 106951 and C.IsTalentKnown(102543) then
			frames[i].spellID2 = 102543
		end
		
		frames[i].spellID = spellID
		frames[i].spellName = GetSpellInfo(spellID)
		
		frames[i].disabled = false
		frames[i]:Show()
		frames[i]:SetWidth(rwidth)
		frames[i]:SetHeight(rwidth)
		frames[i]:ClearAllPoints()
		
		frames[i].icon:SetTexture(GetSpellTexture(spellID))
		
		if C.db.profile.cooldowns.isvertical == 2 then -- 1 Горизонт 2 - Вертикально			
			if i == 1 then
				if C.db.profile.cooldowns.anchoring == 1 then
					frames[i]:SetPoint("LEFT", cooldownsParent, "LEFT", 0, iconOffset)
				else
					frames[i]:SetPoint("RIGHT", cooldownsParent, "RIGHT", 0, iconOffset)
				end
			else
				frames[i]:SetPoint("TOP", frames[i-1], "BOTTOM", 0, -C.db.profile.cooldowns.gap)
			end		
		else		
			if i == 1 then
				if C.db.profile.cooldowns.anchoring == 1 then
					frames[i]:SetPoint("BOTTOM", cooldownsParent, "BOTTOM", -iconOffset, 0)
				else
					frames[i]:SetPoint("TOP", cooldownsParent, "TOP", -iconOffset, 0)
				end
			else
				frames[i]:SetPoint("LEFT", frames[i-1], "RIGHT", C.db.profile.cooldowns.gap, 0)
			end
		end
	end
	--[==[
	for i=1, #order_spell do
		if partial_1 == 1 then
			if partial_frame == i then
			
				if C.db.profile.cooldowns.anchoring == 1 then
					frames[i]:SetPoint("BOTTOM", cooldownsParent, "BOTTOM", 0, 0)
				else
					frames[i]:SetPoint("TOP", cooldownsParent, "TOP", 0, 0)
				end
				
			elseif i < partial_frame then
				frames[i]:SetPoint("RIGHT", frames[i+1], "LEFT", -C.db.profile.cooldowns.gap, 0)
			elseif i > partial_frame then
				frames[i]:SetPoint("LEFT", frames[i-1], "RIGHT", C.db.profile.cooldowns.gap, 0)
			end
		else
			if i == partial_frame_1 then
			
				if C.db.profile.cooldowns.anchoring == 1 then
					frames[i]:SetPoint("BOTTOMRIGHT", cooldownsParent, "BOTTOM", -C.db.profile.cooldowns.gap*0.5, 0)
				else
					frames[i]:SetPoint("TOPRIGHT", cooldownsParent, "TOP", -C.db.profile.cooldowns.gap*0.5, 0)
				end
			elseif i == partial_frame_1+1 then
				if C.db.profile.cooldowns.anchoring == 1 then
					frames[i]:SetPoint("BOTTOMLEFT", cooldownsParent, "BOTTOM", C.db.profile.cooldowns.gap*0.5, 0)
				else
					frames[i]:SetPoint("TOPLEFT", cooldownsParent, "TOP", C.db.profile.cooldowns.gap*0.5, 0)
				end
			elseif i < partial_frame_1 then
				frames[i]:SetPoint("RIGHT", frames[i+1], "LEFT", -C.db.profile.cooldowns.gap, 0)
			elseif i > partial_frame_1+1 then
				frames[i]:SetPoint("LEFT", frames[i-1], "RIGHT", C.db.profile.cooldowns.gap, 0)
			end	
		end	
	end
	]==]
end

local function GetSpellNameGUI(spellID)
	local name, _, icon = GetSpellInfo(spellID)
	
	return "\124T"..( icon or '' )..":14\124t "..( name or 'InvalidID:'..spellID )
end

function C:UpdateStatusBarOrder()
--	cooldownsParent:SetPoint("TOP", C.movingFrame, "BOTTOM", 0, self.db.profile.cooldowns.spacing_v)
	
	C:Mover(cooldownsParent, "CooldownsFrames", 220, 20, "CENTER")
	
	options = C.db.profile
	
	local width = C.db.profile.cooldowns.width
	
	for i=1, #order_spell do
		
		local spellID = order_spell[i]
		
		statusbars[i] = statusbars[i] or C:AddStatusBar(order_spell[i], cooldownsParent)
	
		statusbars[i].spellID = spellID
		
		statusbars[i].spellID2 = nil
		
		if spellID == 106951 and C.IsTalentKnown(102543) then
			statusbars[i].spellID2 = 102543
		end
		
		statusbars[i].spellName = GetSpellInfo(spellID)
		
		statusbars[i].disabled = false
		statusbars[i]:SetWidth(width)
		statusbars[i]:SetHeight(16)
		statusbars[i]:ClearAllPoints()
		
		statusbars[i].icon:SetTexture(GetSpellTexture(spellID))
		statusbars[i].icon:SetSize(16, 16)
	end
	
	C:PostupdateOrdering()
end

function C:PostupdateOrdering()

	if C.db.profile.cooldowns.showmissing then
		for i=1, #order_spell do
			if i == 1 then		
				if C.db.profile.cooldowns.anchoring == 1 then
					statusbars[i]:SetPoint("BOTTOM", cooldownsParent, "BOTTOM", 0, 0)
				else
					statusbars[i]:SetPoint("TOP", cooldownsParent, "TOP", 0, 0)
				end
			else
				if C.db.profile.cooldowns.anchoring == 1 then
					statusbars[i]:SetPoint("BOTTOM", statusbars[i-1], "TOP", 0, C.db.profile.cooldowns.gap)
				else
					statusbars[i]:SetPoint("TOP", statusbars[i-1], "BOTTOM", 0, -C.db.profile.cooldowns.gap)
				end
			end	
			
			statusbars[i]:Show()
		end
	else
		local prev = nil
		for i=1, #order_spell do
			statusbars[i]:ClearAllPoints()
	
			if statusbars[i].statusbar._status == 1 or statusbars[i].statusbar._status == 2 or statusbars[i].statusbar._status == 3 then
				statusbars[i]:Show()

				if prev == nil then		
					if C.db.profile.cooldowns.anchoring == 1 then
						statusbars[i]:SetPoint("BOTTOM", cooldownsParent, "BOTTOM", 0, 0)
					else
						statusbars[i]:SetPoint("TOP", cooldownsParent, "TOP", 0, 0)
					end
					
					prev = statusbars[i]
				else
					if C.db.profile.cooldowns.anchoring == 1 then
						statusbars[i]:SetPoint("BOTTOM", prev, "TOP", 0, C.db.profile.cooldowns.gap)
					else
						statusbars[i]:SetPoint("TOP", prev, "BOTTOM", 0, -C.db.profile.cooldowns.gap)
					end
					prev = statusbars[i]
				end
			else
				statusbars[i]:Hide()
			end
		end
	end
end

function C:AddCooldownIcon(spellid, parent)
	local f = CreateFrame("Frame", nil, parent)
	f:SetSize(1, 1)
	local spellName, _, spellIcon = GetSpellInfo(spellid)

	local icon = f:CreateTexture(nil, "BACKGROUND")
	icon:SetAllPoints()
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	icon:SetTexture(spellIcon)
	
	f.icon2 = f:CreateTexture(nil, "BACKGROUND", nil, 1)
	f.icon2:SetAllPoints()
	f.icon2:SetColorTexture(0, 0, 0, 1)
	
	f.backdrop = CreateFrame("Frame", nil, f)
	f.backdrop:SetFrameStrata("LOW")
	
	f.bg = f.backdrop:CreateTexture(nil, "BACKGROUND", nil, -2)
	f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -1, 1)
	f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 1, -1)
	f.bg:SetColorTexture(0,0,0,1)

	local cd = CreateFrame("Cooldown", parent:GetName().."Cooldown", f, "CooldownFrameTemplate")
	cd.parent = f
	cd:SetAllPoints()
	cd:SetReverse(true)
	
	if false then		
		cd:SetSwipeColor(0, 0, 0, 0)
		cd:SetDrawEdge(false)
	else
		cd:SetSwipeColor(0, 0, 0, 0.7)
		cd:SetDrawEdge(false)
	end
		
	cd.noCooldownCount = true
	cd:SetHideCountdownNumbers(true)
	
	cd:SetScript("OnUpdate", function(self, elapsed)
		local numb = ((self.parent._start + self.parent._duration) - GetTime())

		self.parent.timer:SetText(formatList[C.db.profile.cooldowns.time_format or 1](numb))

		if spells_to_show[id_to_spell[self.parent.spellID]].onTimeIcon then
			perSpellMethids[spells_to_show[id_to_spell[self.parent.spellID]].onTimeIcon](self.parent, numb)
		end
	end)
	
	local textparent = CreateFrame("Frame", nil, parent)
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

	f.glow = CreateFrame("Frame", nil, cd)
	f.glow:SetFrameLevel(cd:GetFrameLevel()+2)
	f.glow:SetBackdrop({
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeSize = 1,
	})
	f.glow:SetBackdropBorderColor(1, 1, 0, 1)
	f.glow:SetPoint("TOPLEFT", 1, -1)
	f.glow:SetPoint("BOTTOMRIGHT", -1, 1)	
	f.glow.dir = -1.7
	f.glow:Hide()

	f.icon = icon
	f.cooldown = cd
	f.timer = timer
	f.stack = stack
	
	f.SetTimer = function(self, start, duration, stacks, status, maxstacks, reset) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
		self.stack:SetText( ( stacks and stacks > 0 ) and stacks or '')

		self.icon:SetTexture(GetSpellTexture(self.spellID))
		
		if spells_to_show[id_to_spell[self.spellID]].onUpdate then
			perSpellMethids[spells_to_show[id_to_spell[self.spellID]].onUpdate](self, start, duration, stacks, status, maxstacks, reset)
		end
		
		if self._start == start and
			self._duration == duration and
			self._status == status and
			self._stacks == stacks then
			return
		end
		
		self._start = start
		self._duration = duration
		self._status = status
		self._stacks = stacks
	
		if status == 1 then
			self.icon:SetDesaturated(false)
			
			if not self.cooldown:IsShown() then
				self.cooldown:Show()
			end
			self.cooldown:SetSwipeColor(0, 0, 0, 0.7)
			self.cooldown:SetDrawEdge(false)	
			self.cooldown:SetReverse(true)
			self.cooldown:SetCooldown(start, duration)
			
			self.icon:SetVertexColor(1, 1, 1, 1)
			self.icon2:SetColorTexture(0, 0, 0, C.db.profile.cooldowns.icon_dark)
			
			self:SetAlpha(1)
			
			if C.db.profile.cooldowns.glowAnim then
				
				if spells_to_show[id_to_spell[self.spellID]].onShowGlow then
					if perSpellMethids[spells_to_show[id_to_spell[self.spellID]].onShowGlow]() then
						FeralDotDamage.ShowOverlayGlow(self.cooldown)
					end
				else
					FeralDotDamage.ShowOverlayGlow(self.cooldown) 
				end
			end
		elseif status == 2 then
			if maxstacks and maxstacks > 0 then
				self.icon:SetDesaturated(stacks == 0 and true or false)
				
				if stacks == 0 then
					self.cooldown:SetSwipeColor(0, 0, 0, 0.7)
					self.cooldown:SetDrawEdge(false)		
				else
					self.cooldown:SetSwipeColor(0, 0, 0, 0)	
					self.cooldown:SetDrawEdge(true)					
				end
				
				if not self.cooldown:IsShown() then
					self.cooldown:Show()
				end
				self.cooldown:SetReverse(false)
				self.cooldown:SetCooldown(start, duration)
			
				self:SetAlpha(1)
				self.icon:SetVertexColor(1, 1, 1, 1)
				self.icon2:SetColorTexture(0, 0, 0, 0)
			else
				self.icon:SetDesaturated(C.db.profile.cooldowns.blackwhite)
				if not self.cooldown:IsShown() then
					self.cooldown:Show()
				end
				self.cooldown:SetReverse(false)
				self.cooldown:SetCooldown(start, duration)

				self:SetAlpha(C.db.profile.cooldowns.nonactivealpha)
				self.icon:SetVertexColor(1, 1, 1, 1)
				self.icon2:SetColorTexture(0, 0, 0, C.db.profile.cooldowns.icon_dark)
			end

			FeralDotDamage.HideOverlayGlow(self.cooldown)
		elseif status == 3 then
			self.icon:SetDesaturated(false)
			self.cooldown:Hide()
			self.cooldown:SetSwipeColor(0, 0, 0, 0.7)
			self.cooldown:SetDrawEdge(false)	
			self.cooldown:SetReverse(true)
			self.cooldown:Clear()
			self.icon:SetVertexColor(1, 1, 1, 1)
			self.icon2:SetColorTexture(0, 0, 0, 0)
			
			self:SetAlpha(1)
			 
			self.timer:SetText('')

			FeralDotDamage.HideOverlayGlow(self.cooldown)
		elseif status == 4 then	
			self.icon:SetDesaturated(C.db.profile.cooldowns.blackwhite)
			self.cooldown:Hide()
			self.cooldown:SetSwipeColor(0, 0, 0, 0.7)
			self.cooldown:SetDrawEdge(false)	
			self.cooldown:SetReverse(true)
			self.cooldown:Clear()
			
			self:SetAlpha(C.db.profile.cooldowns.nonactivealpha)
			self.icon:SetVertexColor(1, 1, 1, 1)
			self.icon2:SetColorTexture(0, 0, 0, C.db.profile.cooldowns.icon_dark)
			
			self.timer:SetText('')
			FeralDotDamage.HideOverlayGlow(self.cooldown)
		end
	end
	
	return f
end

function C:AddStatusBar(spellid, parent)
	
	local f = CreateFrame("Frame", nil, parent)
	f:SetSize(1, 1)

	local icon = f:CreateTexture(nil, "BACKGROUND")
	icon:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
	icon:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)
	icon:SetSize(20, 20)
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	
	icon.backdrop = CreateFrame("Frame", nil, f)
	icon.backdrop:SetFrameStrata("LOW")
	
	icon.bg = icon.backdrop:CreateTexture(nil, "BACKGROUND", nil, -2)
	icon.bg:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
	icon.bg:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
	icon.bg:SetColorTexture(0,0,0,1)
	
	local statusbar = CreateFrame("StatusBar", nil, f)
	statusbar.parent = f
	statusbar:SetSize(5, 9)
	statusbar:SetPoint("TOPLEFT", icon, "TOPRIGHT", 0, 0)
	statusbar:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
	statusbar:SetStatusBarTexture("Interface\\ChatFrame\\ChatFrameBackground")
	statusbar:SetStatusBarColor(.6, 0, 0, 1)
	statusbar:SetMinMaxValues(0,1)
	statusbar:SetValue(2)
	
	statusbar:GetStatusBarTexture():SetDrawLayer("ARTWORK", 1)
	
	statusbar.backdrop = CreateFrame("Frame", nil, statusbar)
	statusbar.backdrop:SetFrameStrata("LOW")
	
	statusbar.bg = statusbar.backdrop:CreateTexture(nil, "BACKGROUND")
	statusbar.bg:SetPoint("TOPLEFT", statusbar, "TOPLEFT", -1, 1)
	statusbar.bg:SetPoint("BOTTOMRIGHT", statusbar, "BOTTOMRIGHT", 1, -1)
	statusbar.bg:SetColorTexture(0,0,0,1)
	
	statusbar.background = statusbar:CreateTexture(nil, "ARTWORK")
	statusbar.background:SetPoint("TOPLEFT", statusbar, "TOPLEFT", 0, 0)
	statusbar.background:SetPoint("BOTTOMRIGHT", statusbar, "BOTTOMRIGHT", 0, 0)
	statusbar.background:SetColorTexture(0,0,0,1)
	
	statusbar:Show()
	statusbar._start = 0
	statusbar._duration = -2
	statusbar._status = 3
	
	statusbar:SetScript("OnUpdate", function(self, elapsed)
		local numb = 0 
		
		if self._status == 3 or self._status == 4 then
			return
		else
			numb = ( self._start+self._duration - GetTime() )
			self:SetValue(numb)
			
			self.parent.timer:SetText(formatList[C.db.profile.cooldowns.time_format or 1](numb))
		end

	end)

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
	
	f.statusbar = statusbar
	f.icon = icon
	f.leftText = text1
	f.rightText = text2
	
	f.SetTimer = function(self, start, duration, stacks, status)  -- status 1 active aura buff status 2 cooldown status 3 active timer
		self.statusbar._start = start
		self.statusbar._duration = duration	
		
		self.icon:SetTexture(GetSpellTexture(self.spellID))
		
		if self.statusbar._status ~= status then
			self.statusbar._status = status
			C:PostupdateOrdering()
		end
		self.statusbar._status = status
		
		self.leftText:SetText(self.spellName .. ( ( stacks and stacks > 0 ) and " x"..stacks or "" ))
		
		if status == 1 then
			self.statusbar:SetMinMaxValues(0, duration)
			local color = C.db.profile.cooldowns.colors[1]			
			self.statusbar:SetStatusBarColor(color[1],color[2],color[3],color[4])
		elseif status == 2 then
			self.statusbar:SetMinMaxValues(0, duration)
			local color = C.db.profile.cooldowns.colors[2]			
			self.statusbar:SetStatusBarColor(color[1],color[2],color[3],color[4])
		elseif status == 3 then
			self.statusbar:SetMinMaxValues(0, 1)
			self.statusbar:SetValue(1)
			self.rightText:SetText('')
			local color = C.db.profile.cooldowns.colors[3]			
			self.statusbar:SetStatusBarColor(color[1],color[2],color[3],color[4])
		elseif status == 4 then
			self.statusbar:SetMinMaxValues(0, 1)
			self.statusbar:SetValue(1)
			self.rightText:SetText('')
			local color = C.db.profile.cooldowns.colors[4]			
			self.statusbar:SetStatusBarColor(color[1],color[2],color[3],color[4])
		end
	end
	
	return f
end

local UpdateCooldownSortings_SortFunc = function(x, y)
	if x.on == y.on then
        if x.sort == y.sort then
			return x.name > y.name
        else
			return x.sort < y.sort
        end
    else
        return x.on
    end
      
    return true
end
	
local function ResetCorruptedSettings()
	wipe(C.db.profile.cooldowns.ordering_spells.spellList)
	for index, data in pairs(spells_to_show) do	
		C.db.profile.cooldowns.ordering_spells.spellList[data.id] = { sort = index, on = data.default }
	end
end

local function CheckForCorruptedSettigns()	

	if C.db.profile.cooldowns.ordering_spells.initialReset ~= initialDBUpdate then
		print('FDD: Update SpellSorting cuz of init update', C.db.profile.cooldowns.ordering_spells.initialReset)
		C.db.profile.cooldowns.ordering_spells.initialReset = initialDBUpdate
		ResetCorruptedSettings()
		return
	end
	
	for index, data in pairs(spells_to_show) do	
		if not C.db.profile.cooldowns.ordering_spells.spellList[data.id] then
			print('FDD: Update SpellSorting cuz of invalid spells_to_show', data.id, GetSpellInfo(data.id))
			ResetCorruptedSettings()
			return
		end
	end
	
	for spellID in pairs(C.db.profile.cooldowns.ordering_spells.spellList) do
		if not id_to_spell[ spellID ] then
			print('FDD: Update SpellSorting cuz of invalid spellidtoid', spellID, GetSpellInfo(spellID))
			ResetCorruptedSettings()
			return
		end
	end	
end

FDD_ResetCorruptedSettings = ResetCorruptedSettings

local sortedSpellList = {}
function C:UpdateCooldownSortings()
	CheckForCorruptedSettigns()	
	
	wipe(order_spell)
	
	local framecount = 0
	
	wipe(sortedSpellList)

	for spellID, data in pairs(C.db.profile.cooldowns.ordering_spells.spellList) do	
		sortedSpellList[data.sort] = spellID
	end
	
	for i, spellID in ipairs(sortedSpellList) do
		local data = C.db.profile.cooldowns.ordering_spells.spellList[spellID]
	
		if spellID == C.trollberserk_spid then		
			if select(2, UnitRace("player")) == "Troll" and data.on then
				framecount = framecount + 1			
				order_spell[framecount] = spellID
				order_spell_to_id[spellID] = framecount
			end
		elseif spells_to_show[id_to_spell[spellID]].talent then
			if data.on and C.IsTalentKnown(spells_to_show[id_to_spell[spellID]].talent) then
				framecount = framecount + 1
				order_spell[framecount] = spellID			
				order_spell_to_id[spellID] = framecount
			end
		elseif spells_to_show[id_to_spell[spellID]].spellKnown then
			if data.on and IsSpellKnown(spells_to_show[id_to_spell[spellID]].spellKnown) then
				framecount = framecount + 1
				order_spell[framecount] = spellID			
				order_spell_to_id[spellID] = framecount
			end
		elseif spells_to_show[id_to_spell[spellID]].item then
			if data.on and C.IsItemEqupped(spells_to_show[id_to_spell[spellID]].item) then
				framecount = framecount + 1
				order_spell[framecount] = spellID			
				order_spell_to_id[spellID] = framecount
			end
		elseif data.on then
			framecount = framecount + 1
			order_spell[framecount] = spellID		
			order_spell_to_id[spellID] = framecount
		end
	end
	
end

function C:CooldownFontUpdate()
	
	for i=1, #frames do
		
		local f = frames[i]
		local justifyV, justifyH = strsplit(";", options.cooldowns.fonts.timer.text_point) -- = "BOTTOM;CENTER",
		
		if C.db.profile.cooldowns.hide_timer_text then
			f.timer:Show()
		else
			f.timer:Hide()
		end
		
		f.cooldown:SetHideCountdownNumbers(C.db.profile.cooldowns.hide_timer_text)	
		
		f.timer:SetFont(C.SharedMedia:Fetch("font", options.cooldowns.fonts.font), options.cooldowns.fonts.timer.fontsize, options.cooldowns.fonts.fontflag)
		f.timer:SetJustifyH(justifyH)
		f.timer:SetJustifyV(justifyV)
		f.timer:SetShadowColor(
			options.cooldowns.fonts.timer.shadow_color[1],
			options.cooldowns.fonts.timer.shadow_color[2],
			options.cooldowns.fonts.timer.shadow_color[3],
			options.cooldowns.fonts.timer.shadow_color[4])
			
		f.timer:SetShadowOffset(options.cooldowns.fonts.shadow_pos[1],options.cooldowns.fonts.shadow_pos[2])
		f.timer:SetTextColor(
			options.cooldowns.fonts.timer.color[1],
			options.cooldowns.fonts.timer.color[2],
			options.cooldowns.fonts.timer.color[3],
			1)
		
		
		f.timer:SetPoint("TOPLEFT", f.cooldown, "TOPLEFT", -5+options.cooldowns.fonts.timer.spacing_h, options.cooldowns.fonts.timer.spacing_v)
		f.timer:SetPoint("BOTTOMRIGHT", f.cooldown, "BOTTOMRIGHT", 5+options.cooldowns.fonts.timer.spacing_h, options.cooldowns.fonts.timer.spacing_v)

		
		justifyV, justifyH = strsplit(";", options.cooldowns.fonts.stack.text_point) -- = "BOTTOM;CENTER",
		
		f.stack:SetFont(C.SharedMedia:Fetch("font", options.cooldowns.fonts.font), options.cooldowns.fonts.stack.fontsize, options.cooldowns.fonts.fontflag)
		f.stack:SetJustifyH(justifyH)
		f.stack:SetJustifyV(justifyV)
		f.stack:SetShadowColor(
			options.cooldowns.fonts.stack.shadow_color[1],
			options.cooldowns.fonts.stack.shadow_color[2],
			options.cooldowns.fonts.stack.shadow_color[3],
			options.cooldowns.fonts.stack.shadow_color[4])
		f.stack:SetShadowOffset(options.cooldowns.fonts.shadow_pos[1],options.cooldowns.fonts.shadow_pos[2])
		f.stack:SetTextColor(options.cooldowns.fonts.stack.color[1],options.cooldowns.fonts.stack.color[2],options.cooldowns.fonts.stack.color[3],1)
		
		f.stack:SetPoint("TOPLEFT", f.cooldown, "TOPLEFT", -5+options.cooldowns.fonts.stack.spacing_h, options.cooldowns.fonts.stack.spacing_v)
		f.stack:SetPoint("BOTTOMRIGHT", f.cooldown, "BOTTOMRIGHT", 5+options.cooldowns.fonts.stack.spacing_h, options.cooldowns.fonts.stack.spacing_v)
	end
	
	for i=1, #statusbars do
		local f = statusbars[i]

		f.leftText:SetFont(C.SharedMedia:Fetch("font", options.cooldowns.fonts.font), options.cooldowns.fonts.timer.fontsize, options.cooldowns.fonts.fontflag)
		f.leftText:SetShadowColor(options.cooldowns.fonts.timer.shadow_color[1],options.cooldowns.fonts.timer.shadow_color[2],options.cooldowns.fonts.timer.shadow_color[3],options.cooldowns.fonts.timer.shadow_color[4])
		f.leftText:SetShadowOffset(options.cooldowns.fonts.shadow_pos[1],options.cooldowns.fonts.timer.shadow_pos[2])
		f.leftText:SetTextColor(options.cooldowns.fonts.timer.color[1],options.cooldowns.fonts.timer.color[2],options.cooldowns.fonts.timer.color[3],1)
		
		f.rightText:SetFont(C.SharedMedia:Fetch("font", options.cooldowns.fonts.font), options.cooldowns.fonts.timer.fontsize, options.cooldowns.fonts.fontflag)
		f.rightText:SetShadowColor(options.cooldowns.fonts.timer.shadow_color[1],options.cooldowns.fonts.timer.shadow_color[2],options.cooldowns.fonts.timer.shadow_color[3],options.cooldowns.fonts.timer.shadow_color[4])
		f.rightText:SetShadowOffset(options.cooldowns.fonts.shadow_pos[1],options.cooldowns.fonts.timer.shadow_pos[2])
		f.rightText:SetTextColor(options.cooldowns.fonts.timer.color[1],options.cooldowns.fonts.timer.color[2],options.cooldowns.fonts.timer.color[3],1)
	end
end

function C:CooldownBorderUpdate()
	for i=1, #frames do
		
		local f = frames[i]
		
		f.backdrop:SetBackdrop({
			edgeFile = C.SharedMedia:Fetch("border", options.cooldowns.border.texture),
			edgeSize = options.cooldowns.border.size,
		})
		f.backdrop:SetBackdropBorderColor(options.cooldowns.border.color[1], options.cooldowns.border.color[2], options.cooldowns.border.color[3], options.cooldowns.border.color[4])
		f.backdrop:SetPoint("TOPLEFT", -options.cooldowns.border.inset, options.cooldowns.border.inset)
		f.backdrop:SetPoint("BOTTOMRIGHT", options.cooldowns.border.inset, -options.cooldowns.border.inset)
		
		f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -options.cooldowns.border.bg_inset, options.cooldowns.border.bg_inset)
		f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", options.cooldowns.border.bg_inset, -options.cooldowns.border.bg_inset)
		f.bg:SetColorTexture(options.cooldowns.border.background[1], options.cooldowns.border.background[2], options.cooldowns.border.background[3], options.cooldowns.border.background[4])
	
	end
	
	for i=1, #statusbars do
		local f = statusbars[i].statusbar
		
		f.backdrop:SetBackdrop({
			edgeFile = C.SharedMedia:Fetch("border", options.cooldowns.border.texture),
			edgeSize = options.cooldowns.border.size,
		})
		f.backdrop:SetBackdropBorderColor(options.cooldowns.border.color[1], options.cooldowns.border.color[2], options.cooldowns.border.color[3], options.cooldowns.border.color[4])
		f.backdrop:SetPoint("TOPLEFT", -options.cooldowns.border.inset, options.cooldowns.border.inset)
		f.backdrop:SetPoint("BOTTOMRIGHT", options.cooldowns.border.inset, -options.cooldowns.border.inset)
		
		f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -options.cooldowns.border.bg_inset, options.cooldowns.border.bg_inset)
		f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", options.cooldowns.border.bg_inset, -options.cooldowns.border.bg_inset)
		f.bg:SetColorTexture(options.cooldowns.border.background[1], options.cooldowns.border.background[2], options.cooldowns.border.background[3], options.cooldowns.border.background[4])
	
		f:SetStatusBarTexture(C.SharedMedia:Fetch("statusbar", self.db.profile.cooldowns.bartexture1))
		f.background:SetTexture(C.SharedMedia:Fetch("statusbar", self.db.profile.cooldowns.bartexturebg))
		f.background:SetVertexColor(options.cooldowns.bg_color[1], options.cooldowns.bg_color[2], options.cooldowns.bg_color[3], options.cooldowns.bg_color[4])
		
		f:SetPoint("TOPLEFT", statusbars[i].icon, "TOPRIGHT", options.cooldowns.icon_spacing, 0)
		
		f = statusbars[i].icon
		
		f.backdrop:SetBackdrop({
			edgeFile = C.SharedMedia:Fetch("border", options.cooldowns.border.texture),
			edgeSize = options.cooldowns.border.size,
		})
		f.backdrop:SetBackdropBorderColor(options.cooldowns.border.color[1], options.cooldowns.border.color[2], options.cooldowns.border.color[3], options.cooldowns.border.color[4])
		f.backdrop:SetPoint("TOPLEFT", f, "TOPLEFT", -options.cooldowns.border.inset, options.cooldowns.border.inset)
		f.backdrop:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", options.cooldowns.border.inset, -options.cooldowns.border.inset)
		
		f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -options.cooldowns.border.bg_inset, options.cooldowns.border.bg_inset)
		f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", options.cooldowns.border.bg_inset, -options.cooldowns.border.bg_inset)
		f.bg:SetColorTexture(options.cooldowns.border.background[1], options.cooldowns.border.background[2], options.cooldowns.border.background[3], options.cooldowns.border.background[4])
		
	end
end

function C:UpdateCooldownOrders()
	options = C.db.profile
	
	C:ToggleCooldownBar("Show")
	
	self:UpdateCooldownSortings()
	
		
	for i=1, #frames do
		frames[i].disabled = true
		frames[i]:Hide()
		frames[i].timer:SetText('')
		frames[i].stack:SetText('')
		
	--	print("T", frames[i].timer)
	end
	
	for i=1, #statusbars do
		statusbars[i].disabled = true
		statusbars[i]:Hide()
	end
	
	if C.db.profile.cooldowns.visual == 1 then self:UpdateCooldownsFrames() end
	if C.db.profile.cooldowns.visual == 2 then self:UpdateStatusBarOrder() end
	
	self:CooldownFontUpdate()
	self:CooldownBorderUpdate()
end

function C:ToggleCooldownBar(status)
	
	if not C.db.profile.cooldowns.enable then
		cooldownsParent:Hide()
		cooldownsParent:UnregisterEvent("UNIT_AURA")
		cooldownsParent:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
		return
	end
	
	cooldownsParent:RegisterEvent("UNIT_AURA")
	cooldownsParent:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	
	cooldownsParent:GetScript("OnEvent")(cooldownsParent,"SPELL_UPDATE_COOLDOWN")
	
	if status == "Show" then
		cooldownsParent:Show()
	else
		cooldownsParent:Hide()
	end
end

function GetSpellCooldownCharges(spellID)
	local startTime, duration, enabled = GetSpellCooldown(spellID)
	local charges, maxCharges, chargeStart, chargeDuration = GetSpellCharges(spellID)
	local charger = false

	if charges and charges ~= maxCharges then
		charger = true
	end

	return ( charger and chargeStart or startTime ), ( charger and chargeDuration or duration ), enabled, charges, maxCharges
end
	
cooldownsParent:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = ( self.elapsed or 0 ) + elapsed
	if self.elapsed < 0.1 then return end
	self.elapsed = 0
	
	C:RefreshCooldownFrames()	
end)

cooldownsParent:SetScript("OnEvent", function(self, event, unit)
	
	if event == "UNIT_AURA" and unit == "player" then
		C:RefreshCooldownFrames()	
	elseif event == "SPELL_UPDATE_COOLDOWN" then
		C:RefreshCooldownFrames()	
	end
end)

local function GetAuras(spellID)
	local i = 1

	while ( true ) do
	
		local name, rank, icon, count, debuffType, duration2, expirationTime, unitCaster, isStealable, _, spellID2 = UnitAura("player", i, "HELPFUL")
	
		
		if not name then
			return false
		end
		
		i = i + 1
		
		if name and ( ( spellID == spellID2 ) or ( placeholder[spellID2] == spellID ) ) then
			return name, count, duration2, expirationTime
		end
	end
end

function C:RefreshCooldownFrames()
	
	cooldownsParent.elapsed = 0
	
	local _frames = C.db.profile.cooldowns.visual == 1 and frames or statusbars
	for i=1, #_frames do
		
		local f = _frames[i]
		
		if not f.disabled then
			local spellID = f.spellID
		
			local tip = spells_to_show[id_to_spell[spellID]].tip

			if tip == COOLDOWN_AURA_TAG then
				local start, duration, enable, currentCharges, maxCharges, oldstart = GetSpellCooldownCharges(f.spellID2 or spellID)
			--	local rname = GetSpellInfo(f.spellID2 or spellID)
		
				local name, count, duration2, expirationTime = GetAuras(f.spellID2 or spellID)
				
				if spellID == 5217 and start == 0 and duration == 0 then
					f:SetTimer(0, 0, count, 3) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer		
			--[==[	elseif spellID == 22570 then
					local legProc = GetAuras(maimLegProcID)
				
					if duration > 1.5 then
						f:SetTimer(start, duration, currentCharges, legProc and 1 or 2, maxCharges)
					else
						f:SetTimer(0, 0, count, legProc and 1 or 3)
					end]==]
				elseif name then
					f:SetTimer(expirationTime-duration2, duration2, currentCharges, 1) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
				elseif duration > 0 and duration ~= C.GetGCD() then
					f:SetTimer(start, duration, currentCharges, 2, maxCharges) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
				else
					f:SetTimer(0, 0, count, 3) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
				end
			elseif tip == COOLDOWN_TAG then
				local start, duration, enable, currentCharges, maxCharges, oldstart = GetSpellCooldownCharges(f.spellID2 or spellID)
				
				if duration > 0 and duration ~= C.GetGCD() then
					f:SetTimer(start, duration, currentCharges, 2, maxCharges) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
				else
					f:SetTimer(0, 0, currentCharges, 3, maxCharges) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
				end
			elseif tip == AURA_TAG then

				local name, count, duration2, expirationTime = GetAuras(f.spellID2 or spellID)
				
				if name then
					f:SetTimer(expirationTime-duration2, duration2, count, 1) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
				else
					f:SetTimer(0, 0, count, 4) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
				end
			end
		end
	end
end

function C:UpdateCooldownStyleOpts(o)
	local o = o or self.GUI.args.cooldowns
	if C.db.profile.cooldowns.visual == 1 then
		
			
		o.args.isvertical = {
			order = 1.2, name = L["Расположение"],
			type = "dropdown",
			values = { L['Горизонтально'], L['Вертикально'] },
			set = function(self, value)
				C.db.profile.cooldowns.isvertical = value;
				C:UpdateCooldownOrders()
			end,
			get = function(self)		
				return C.db.profile.cooldowns.isvertical
			end	
		}
	
	
		o.args.blackwhite = {
			order = 1.3, name = L["Черно-белая"],
			type = "toggle", 
			set = function(self)
				C.db.profile.cooldowns.blackwhite = not C.db.profile.cooldowns.blackwhite;
			end,
			get = function(self)
				return C.db.profile.cooldowns.blackwhite;
			end
		}
		
		o.args.glowAnim = {
			order = 1.4, name = L["Свечение"],
			type = "toggle", 
			set = function(self)
				C.db.profile.cooldowns.glowAnim = not C.db.profile.cooldowns.glowAnim;
			end,
			get = function(self)
				return C.db.profile.cooldowns.glowAnim;
			end
		}
		
		
		o.args.font.args.timer.args.hide_timer_text = {
			order = 1,name = L["Показать текст таймера"],type = "toggle",
			desc = L["Показать текст таймера"],
			set = function(info,val) self.db.profile.cooldowns.hide_timer_text = not self.db.profile.cooldowns.hide_timer_text; C:CooldownFontUpdate(); end,
			get = function(info) return self.db.profile.cooldowns.hide_timer_text end
		}
		
		o.args.icon_darkness = {
			order = 2, name = L["Затемнение"],
			type = "slider", min = 0, max = 1, step = 0.1,
			set = function(self, value)
				C.db.profile.cooldowns.icon_dark = value;
				C:UpdateCooldownOrders()
			end,
			get = function(self)		
				return C.db.profile.cooldowns.icon_dark
			end	
		}
	
		o.args.font.args.stacks ={
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
						self.db.profile.cooldowns.fonts.stack.fontsize = val
						C:CooldownFontUpdate()
					end,
					get =function(info)
						return self.db.profile.cooldowns.fonts.stack.fontsize
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
						self.db.profile.cooldowns.fonts.stack.text_point = val
						C:CooldownFontUpdate()
					end,
					get = function(info) return self.db.profile.cooldowns.fonts.stack.text_point end
				},
				color = {
					order = 7,name = L["Цвет"], type = "color", hasAlpha = false,
					set = function(info,r,g,b,a) 
						self.db.profile.cooldowns.fonts.stack.color ={r,g,b,1};
						C:CooldownFontUpdate()
					end,
					get = function(info) 
						return self.db.profile.cooldowns.fonts.stack.color[1], self.db.profile.cooldowns.fonts.stack.color[2], self.db.profile.cooldowns.fonts.stack.color[3], 1
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
						self.db.profile.cooldowns.fonts.stack.spacing_h = val
						C:CooldownFontUpdate()
					end,
					get =function(info)
						return self.db.profile.cooldowns.fonts.stack.spacing_h
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
						self.db.profile.cooldowns.fonts.stack.spacing_v = val
						C:CooldownFontUpdate()
					end,
					get =function(info)
						return self.db.profile.cooldowns.fonts.stack.spacing_v
					end,
				},
			},
		}
		
		o.args.nonactivealpha = {
			order = 3.2, name = L["Прозрачность"],
			desc = L["Если заклинание на перезарядке и аура отсутствует"],
			type = "slider", min = 0, max = 1, step = 0.1,
			set = function(self, value)
				C.db.profile.cooldowns.nonactivealpha = value;
				C:UpdateCooldownOrders()
			end,
			get = function(self)		
				return C.db.profile.cooldowns.nonactivealpha
			end	
		}
		
		o.args.max_width = {
			order = 3.3, name = L["Максимальный размер"],
			desc = L["Размер иконки не будет превышать максимального значения при изменении колличества иконок"],
			type = "slider", min = 1, max = 60, step = 1,
			set = function(self, value)
				C.db.profile.cooldowns.max_width = value;
				C:UpdateCooldownOrders()
			end,
			get = function(self)		
				return C.db.profile.cooldowns.max_width
			end	
		}
		
		o.args.showmissing = nil
		o.args.statusbargrp = nil
		o.args.barscolor = nil
		o.args.icon_gap = nil
	else
		o.args.isvertical = nil
		o.args.icon_darkness = nil
		o.args.blackwhite = nil
		o.args.glowAnim = nil
		o.args.font.args.timer.args.hide_timer_text = nil
		o.args.font.args.stacks = nil
		o.args.nonactivealpha = nil
		o.args.max_width = nil
		
		o.args.showmissing = {
			order = 1, name = L["Показать отсутствующие ауры"], desc = L["Только для полос"],
			type = "toggle", 
			set = function(self)
				C.db.profile.cooldowns.showmissing = not C.db.profile.cooldowns.showmissing;
				C:UpdateCooldownOrders()
			end,
			get = function(self)
				return C.db.profile.cooldowns.showmissing;
			end
		}
	
		o.args.icon_gap = {
			order = 3.1, name = L["Отступ иконки"],
			type = "slider", min = 0, max = 50, step = 1,
			set = function(self, value)
				C.db.profile.cooldowns.icon_spacing = value;
				C:UpdateCooldownOrders()
			end,
			get = function(self)		
				return C.db.profile.cooldowns.icon_spacing
			end	
		}
	
		o.args.statusbargrp ={
			order = 5.1, name = L["Текстуры полосы"],type = "group", embend = true,
			args={
			
			},
		}

		o.args.statusbargrp.args.statusbar1 = {
			order = 1,type = 'statusbar',name = L["Основная текстура"], 
			values = C.SharedMedia:HashTable("statusbar"),
			set = function(info,value) self.db.profile.cooldowns.bartexture1 = value; C:UpdateCooldownOrders();end,
			get = function(info) return self.db.profile.cooldowns.bartexture1 end,
		}

		o.args.statusbargrp.args.statusbarbg = {
			order = 2,type = 'statusbar',name = L["Текстура фона"], 
			values = C.SharedMedia:HashTable("statusbar"),
			set = function(info,value) self.db.profile.cooldowns.bartexturebg = value; C:UpdateCooldownOrders();end,
			get = function(info) return self.db.profile.cooldowns.bartexturebg end,
		}

		o.args.barscolor ={
			order = 5,name = L["Цвет полосы"],type = "group", embend = true,
			args={
			
			},
		}

		for i=1, 4 do	
			o.args.barscolor.args["color"..i]	= {
				order = i,name = L["statusbar_color"..i], type = "color", hasAlpha = true,
				set = function(info,r,g,b,a) 
					self.db.profile.cooldowns.colors[i]={r,g,b,a};
				end,
				get = function(info) 
					return self.db.profile.cooldowns.colors[i][1],
					self.db.profile.cooldowns.colors[i][2],
					self.db.profile.cooldowns.colors[i][3],
					self.db.profile.cooldowns.colors[i][4]
				end
			}	
		end

		o.args.barscolor.args["background"]	= {
			order = 5,name = L["Фон"], type = "color", hasAlpha = true,
			set = function(info,r,g,b,a) 
				self.db.profile.cooldowns.bg_color={r,g,b,a};
			end,
			get = function(info) 
				return self.db.profile.cooldowns.bg_color[1],
				self.db.profile.cooldowns.bg_color[2],
				self.db.profile.cooldowns.bg_color[3],
				self.db.profile.cooldowns.bg_color[4]
			end
		}
	end
end

function C:AddCooldownsGUI()
	local o = {
		order = 7,name = L["Перезарядки"],type = "group",
		args={
		
		},
	}
	
	o.args.enable = {
		order = 0.1, name = L["Включить"],
		type = "toggle", 
		set = function(self)
			C.db.profile.cooldowns.enable = not C.db.profile.cooldowns.enable;
			C:UpdateCooldownOrders()
		end,
		get = function(self)
			return C.db.profile.cooldowns.enable;
		end
	}
	
	o.args.movingme = {
		order = 0.2,name = L["Передвинь меня!"], type = "execute",
		set = function(info,val) C:UnlockMover("CooldownsFrames"); end,
		get = function(info) return false end
	}
	
	o.args.visual = {
		order = 1.1, name = L["Тип"],
		type = "dropdown",
		values = { L['Иконки'], L['Полоски'] },
		set = function(self, value)
			C.db.profile.cooldowns.visual = value;
			C:UpdateCooldownStyleOpts()
			C:UpdateCooldownOrders()
		end,
		get = function(self)		
			return C.db.profile.cooldowns.visual
		end	
	}
	
	o.args.width = {
		order = 2, name = L["Ширина"],
		type = "slider", min = 1, max = 1500, step = 1,
		set = function(self, value)
			C.db.profile.cooldowns.width = value;
			C:UpdateCooldownOrders()
		end,
		get = function(self)		
			return C.db.profile.cooldowns.width
		end	
	}
	
	o.args.gap = {
		order = 3, name = L["Отступ"],
		type = "slider", min = 0, max = 50, step = 1,
		set = function(self, value)
			C.db.profile.cooldowns.gap = value;
			C:UpdateCooldownOrders()
		end,
		get = function(self)		
			return C.db.profile.cooldowns.gap
		end	
	}
	
	
	--[[
	o.args.spacing_v = {
		name = L["Отступ по вертикали"], disabled = false,
		type = "slider",
		order	= 1.5,
		min		= -1500,
		max		= 1500,
		step	= 1,
		set = function(info,val) 
			self.db.profile.cooldowns.spacing_v = val
			C:UpdateCooldownOrders()
		end,
		get =function(info)
			return self.db.profile.cooldowns.spacing_v
		end,
	}
	]]
	o.args.anchoring = {
		order = 3.4, name = L["Точка привязки"],
		type = "dropdown",
		values = function()
			return ( C.db.profile.cooldowns.isvertical == 2 and { L['Справа'], L['Слева'] } or { L['Снизу'], L['Сверху'] } )
		end,
		set = function(self, value)
			C.db.profile.cooldowns.anchoring = value;
			C:UpdateCooldownOrders()
		end,
		get = function(self)		
			return C.db.profile.cooldowns.anchoring
		end	
	}
	
	o.args.font ={
		order = 2,name = L["Шрифт"],type = "group", embend = true,
		args={
			font = {
				order = 4,name = L["Шрифт"],type = 'font',
				values = C.SharedMedia:HashTable("font"),
				set = function(info,key) 
					self.db.profile.cooldowns.fonts.font = key
					C:UpdateCooldownOrders()
				end,
				get = function(info) return self.db.profile.cooldowns.fonts.font end,
			},
			time_format = {
				name = L["Формат времени"],
				type = "dropdown",
				order	= 4.1,
				values = {
					"1 3 10 20 50 2m",
					"0.1 1 1.5 3 2m",
					"1 3 10 20 50 2:00",
					"0.1 1 1.5 3 2:00",
				},
				set = function(info,val) 
					self.db.profile.cooldowns.time_format = val
				end,
				get =function(info)
					return self.db.profile.cooldowns.time_format
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
					self.db.profile.cooldowns.fonts.fontflag = val
					C:UpdateFramesStyle()
					C:MultitargetFontUpdate()
					C:UpdateCooldownOrders()
				end,
				get = function(info) return self.db.profile.cooldowns.fonts.fontflag end
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
					self.db.profile.cooldowns.fonts.shadow_pos[1] = val
					C:UpdateCooldownOrders()
				end,
				get =function(info)
					return self.db.profile.cooldowns.fonts.shadow_pos[1]
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
					self.db.profile.cooldowns.fonts.shadow_pos[2] = val
					C:UpdateCooldownOrders()
				end,
				get =function(info)
					return self.db.profile.cooldowns.fonts.shadow_pos[2]
				end,
			},
			]]
		},
	}
	
	o.args.font.args.timer ={
		order = 10,name = L["Таймер"],type = "group", embend = true,
		args={
			fontisize_stack = {
				name = L["Размер шрифта"], disabled = false,
				type = "slider",
				order	= 1,
				min		= 1,
				max		= 32,
				step	= 1,
				set = function(info,val) 
					self.db.profile.cooldowns.fonts.timer.fontsize = val
					C:CooldownFontUpdate()
				end,
				get =function(info)
					return self.db.profile.cooldowns.fonts.timer.fontsize
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
					self.db.profile.cooldowns.fonts.timer.text_point = val
					C:CooldownFontUpdate()
				end,
				get = function(info) return self.db.profile.cooldowns.fonts.timer.text_point end
			},
			color = {
				order = 7,name = L["Цвет"], type = "color", hasAlpha = false,
				set = function(info,r,g,b,a) 
					self.db.profile.cooldowns.fonts.timer.color ={r,g,b,1};
					C:CooldownFontUpdate()
				end,
				get = function(info) 
					return self.db.profile.cooldowns.fonts.timer.color[1], self.db.profile.cooldowns.fonts.timer.color[2], self.db.profile.cooldowns.fonts.timer.color[3], 1
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
					self.db.profile.cooldowns.fonts.timer.spacing_h = val
					C:CooldownFontUpdate()
				end,
				get =function(info)
					return self.db.profile.cooldowns.fonts.timer.spacing_h
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
					self.db.profile.cooldowns.fonts.timer.spacing_v = val
					C:CooldownFontUpdate()
				end,
				get =function(info)
					return self.db.profile.cooldowns.fonts.timer.spacing_v
				end,
			},
		},
	}
	
	
	o.args.borders ={
		order = 10,name = L["Граница"],type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.borders.args.border = {
		order = 19.1,type = 'border',name = L["Текстура"],
		values = C.SharedMedia:HashTable("border"),
		set = function(info,value) self.db.profile.cooldowns.border.texture = value;C:CooldownBorderUpdate();end,
		get = function(info) return self.db.profile.cooldowns.border.texture end,
	}
					
	o.args.borders.args.bordercolor = {
		order = 19.2,name = L["Цвет"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) 
			self.db.profile.cooldowns.border.color={r,g,b,a};
			C:CooldownBorderUpdate();end,
		get = function(info) 
			return self.db.profile.cooldowns.border.color[1],
			self.db.profile.cooldowns.border.color[2],
			self.db.profile.cooldowns.border.color[3],
			self.db.profile.cooldowns.border.color[4]
		end
	}
					
	o.args.borders.args.bordersize = {
		name = L["Размер"],
		type = "slider",
		order	= 19.3,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			self.db.profile.cooldowns.border.size = val
			C:CooldownBorderUpdate();
		end,
		get =function(info)
			return self.db.profile.cooldowns.border.size
		end,
	}
	o.args.borders.args.borderinset = {
		name = L["Отступ границ"],
		type = "slider",
		order	= 19.4,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			self.db.profile.cooldowns.border.inset = val
			C:CooldownBorderUpdate();
		end,
		get =function(info)
			return self.db.profile.cooldowns.border.inset
		end,
	}
	
	o.args.borders.args.bgcolor = {
		order = 19.2,name = L["Фон"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) 
			self.db.profile.cooldowns.border.background={r,g,b,a};
			C:CooldownBorderUpdate();
		end,
		get = function(info) 
			return self.db.profile.cooldowns.border.background[1],
			self.db.profile.cooldowns.border.background[2],
			self.db.profile.cooldowns.border.background[3],
			self.db.profile.cooldowns.border.background[4]
		end
	}
	o.args.borders.args.bginset = {
		name = L["Отступ фона"],
		type = "slider",
		order	= 19.4,
		min		= -50,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			self.db.profile.cooldowns.border.bg_inset = val
			C:CooldownBorderUpdate();
		end,
		get =function(info)
			return self.db.profile.cooldowns.border.bg_inset
		end,
	}
	
	o.args.spells = {
		order = 7,name = L["Заклинания"],type = "group",
		args={
		
		},
	}
	
	for i=1, #spells_to_show do
		
		o.args.spells.args["ordergroup"..i] ={
			order = i,name = GetSpellNameGUI(spells_to_show[i].id) ,type = "group", embend = true,
			args={
			
			},
		}
		
		if self.db.profile.cooldowns.specificSpell[spells_to_show[i].id] then
		
			o.args.spells.args["ordergroup"..i].args.enable = {
				name = L["Показывать"],
				type = "toggle",
				order	= 1,
				set = function(info,val)
					options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].on = 
						not options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].on				
					C:UpdateCooldownOrders()
				end,
				get =function(info)
					return options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].on
				end,
			}	
		
			for k,v in pairs(self.db.profile.cooldowns.specificSpell[spells_to_show[i].id]) do
				
				if k == 'color' then
						o.args.spells.args["ordergroup"..i].args[k] = {
						order = 7,name = L["Цвет"],type = "color", hasAlpha = true,
						set = function(info,r,g,b,a) options.cooldowns.specificSpell[spells_to_show[i].id][k] ={r,g,b,a};end,
						get = function(info) 
							return options.cooldowns.specificSpell[spells_to_show[i].id][k][1],
							options.cooldowns.specificSpell[spells_to_show[i].id][k][2],
							options.cooldowns.specificSpell[spells_to_show[i].id][k][3],
							options.cooldowns.specificSpell[spells_to_show[i].id][k][4] 
						end
					}
				else
					o.args.spells.args["ordergroup"..i].args[k] = {
						name = L[k],
						desc = L[k.."Desc"],
						type = "toggle",
						order	= 6,
						set = function(info,val)
							options.cooldowns.specificSpell[spells_to_show[i].id][k] = 
								not options.cooldowns.specificSpell[spells_to_show[i].id][k]
						end,
						get = function(info)
							return options.cooldowns.specificSpell[spells_to_show[i].id][k]
						end,
					}
				end
			end
		else
			o.args.spells.args["ordergroup"..i].args.enable = {
				name = L["Показывать"],
				type = "toggle",
				order	= 1,
				set = function(info,val)			
					options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].on = 
						not options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].on				
					C:UpdateCooldownOrders()
				end,
				get =function(info)
					return options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].on
				end,
			}		
		end
		o.args.spells.args["ordergroup"..i].args.order = {
			name = L["Позиция"], disabled = false,
			type = "dropdown",
			order	= 2,
			values = function()
				local t = {}
			
				for spellID, data in pairs(options.cooldowns.ordering_spells.spellList) do
					if spellID == spells_to_show[i].id then
						t[data.sort] = '#'..data.sort--..' |cFF00FF00'..GetSpellNameGUI(spells_to_show[i].id)..'|r'
					else
						t[data.sort] = '#'..data.sort..' '..GetSpellNameGUI(spellID)..'|r'
					end
				end
				
				return t
			end,
			set = function(info,val)
				local oldSort = options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].sort
					
				for spellID, data in pairs( options.cooldowns.ordering_spells.spellList ) do
					if data.sort == val then
						options.cooldowns.ordering_spells.spellList[spellID].sort = oldSort
					end
				end
				
				options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].sort = val
					
				C:UpdateCooldownOrders()
			end,
			get =function(info)
				return options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].sort
			end,
		}
	
	end
	
	C:UpdateCooldownStyleOpts(o)
	
	return o
end
