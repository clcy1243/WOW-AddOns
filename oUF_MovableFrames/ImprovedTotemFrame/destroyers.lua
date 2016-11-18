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

local destroyers = { }
local totemSlot  = { 2, 1, 3, 4 }
local backdrop   = { bgFile = "Interface\\BUTTONS\\WHITE8X8", tile = false }

local function Button_OnClick(self, button)
	DestroyTotem(self.slot)
end

local function Button_OnEvent(self, event, key)
	if key ~= "LSHIFT" and key ~= "RSHIFT" then return end

	local _, _, start, duration = GetTotemInfo(self.slot)

	if IsShiftKeyDown() and duration > 0 then
		self:Show()
		self:SetAlpha(ImprovedTotemFrameDB and ImprovedTotemFrameDB.dA or 0.5)
	else
		self:Hide()
	end
end

for i = 1, 4 do
	local mcab = _G["MultiCastActionButton" .. i]

	local b = CreateFrame("Button", nil, UIParent)
	b:SetFrameStrata(mcab:GetFrameStrata())
	b:SetFrameLevel(mcab:GetFrameLevel() + 3)
	b:SetPoint("TOPLEFT", mcab, -1, 1)
	b:SetPoint("BOTTOMRIGHT", mcab, 1, -1)

	b:SetBackdrop(backdrop)
	b:SetBackdropColor(1, 0, 0)

	b:Hide()
	b:RegisterEvent("MODIFIER_STATE_CHANGED")
	b:SetScript("OnEvent", Button_OnEvent)

	b:RegisterForClicks("RightButtonUp")
	b:SetScript("OnClick", Button_OnClick)

	b.id = i
	b.slot = totemSlot[i]

	destroyers[b.slot] = b
	mcab.destroyer = b
end