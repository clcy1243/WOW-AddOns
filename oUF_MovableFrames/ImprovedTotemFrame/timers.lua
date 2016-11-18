--[[--------------------------------------------------------------------
	Improved Totem Frame
	by Phanx <addons@phanx.net>
	Improves the totem frame in the default UI.
	http://www.wowinterface.com/downloads/info-ImprovedTotemFrame.html
	http://wow.curse.com/downloads/wow-addons/details/improvedtotemframe.aspx

	Copyright © 2010–2011 Phanx
	I, the copyright holder of this work, hereby release it into the public
	domain. This applies worldwide. In case this is not legally possible:
	I grant anyone the right to use this work for any purpose, without any
	conditions, unless such conditions are required by law.
----------------------------------------------------------------------]]

if select(2, UnitClass("player")) ~= "SHAMAN" then return end

local totemSlot = { 2, 1, 3, 4 }

local function ColorGradient(percent)
	local r1, r2, g1, g2, b1, b2

	if percent <= 0.5 then
		percent = percent * 2
		r1, g1, b1 = 1, 0, 0
		r2, g2, b2 = 1, 1, 0
	else
		percent = percent * 2 - 1
		r1, g1, b1 = 1, 1, 0
		r2, g2, b2 = 0, 1, 0
	end

	return r1 + (r2 - r1) * percent, g1 + (g2 - g1) * percent, b1 + (b2 - b1) * percent
end

local function OnEvent(self, event, slot)
	if event == "PLAYER_ENTERING_WORLD" then
		slot = self.slot
	elseif slot ~= self.slot then
		return
	end

	local _, _, start, duration = GetTotemInfo(slot)
	if duration > 0 then
		self.start = start
		self.duration = duration
	--	self:SetCooldown(start, duration)
		self:Show()
	else
	--	self:SetCooldown(0, 0)
		self:Hide()
	end
end

local function OnHide(self)
	self.start = nil
	self.duration = nil
end

local function OnShow(self)
	if not self.start or not self.duration then return self:Hide() end
	self.elapsed = 1000
end

local function OnUpdate(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed > 0.2 then
		local timeLeft = self.start + self.duration - GetTime()
		if timeLeft > 0 then
			self.text:SetFormattedText(SecondsToTimeAbbrev(timeLeft))
			self.text:SetTextColor(ColorGradient(timeLeft / self.duration))
			self.elapsed = 0
		else
			self.text:SetText()
			self:Hide()
		end
	end
end

for i = 1, #totemSlot do
	local button = _G["MultiCastActionButton"..i]

	local timerFrame = CreateFrame("Frame", nil, button)
	button.timerFrame = timerFrame

	timerFrame:SetAllPoints(button)
	timerFrame:Hide()

	timerFrame.text = timerFrame:CreateFontString(nil, "OVERLAY")
	timerFrame.text:SetPoint("BOTTOMLEFT", timerFrame, "TOPLEFT", 0, 0)
	timerFrame.text:SetPoint("BOTTOMRIGHT", timerFrame, "TOPRIGHT", 0, 0)
	timerFrame.text:SetFontObject(GameFontNormal)
	timerFrame.text:SetJustifyH("CENTER")

	timerFrame.id = i
	timerFrame.slot = totemSlot[i]

	timerFrame.noCooldownCount = true -- disable OmniCC

	timerFrame:SetScript("OnEvent", OnEvent)
	timerFrame:SetScript("OnHide", OnHide)
	timerFrame:SetScript("OnShow", OnShow)
	timerFrame:SetScript("OnUpdate", OnUpdate)

	timerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	timerFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")

	OnEvent(timerFrame, "PLAYER_TOTEM_UPDATE", timerFrame.slot)
end

--[[--------------------------------------------------------------------
	FIRE_TOTEM_SLOT  = 1 = MultiCastActionButton2
	EARTH_TOTEM_SLOT = 2 = MultiCastActionButton1
	WATER_TOTEM_SLOT = 3 = MultiCastActionButton3
	AIR_TOTEM_SLOT   = 4 = MultiCastActionButton4
----------------------------------------------------------------------]]