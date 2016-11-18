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

local SIZE, GAP = 32, 8

local colors = {
	{ 74/255, 142/255, 41/255 },
	{ 181/255, 73/255, 33/255 },
	{ 57/255, 146/255, 181/255 },
	{ 132/255, 56/255, 231/255 },
}

local actionButtons = {
	MultiCastActionButton1,
	MultiCastActionButton2,
	MultiCastActionButton3,
	MultiCastActionButton4,
}

local slotButtons = {
	MultiCastSlotButton1,
	MultiCastSlotButton2,
	MultiCastSlotButton3,
	MultiCastSlotButton4,
}

------------------------------------------------------------------------

local eventFrame, pending, stop, reparented

local function ImproveTotemFrame()
	if stop then return end

	if InCombatLockdown() then
		-- print("Totem frame cannot be modified in combat.")
		pending = true
		eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	stop = true

	for i = 1, 4 do
		local button = actionButtons[i]
		local slot = slotButtons[i]

		button:ClearAllPoints()
		button:SetWidth(SIZE)
		button:SetHeight(SIZE)
		if i == 1 then
			button:SetPoint("LEFT", MultiCastActionBarFrame, "LEFT", GAP, 0)
		else
			button:SetPoint("LEFT", actionButtons[i - 1], "RIGHT", GAP, 0)
		end

		button:SetNormalTexture("")
		button:GetNormalTexture():Hide()

		slot:ClearAllPoints()
		slot:SetAllPoints(button)
	end

	MultiCastSummonSpellButton:Hide()
	MultiCastRecallSpellButton:Hide()

	MultiCastActionBarFrame:ClearAllPoints()
	MultiCastActionBarFrame:SetWidth((SIZE * 4) + (GAP * 5))
	MultiCastActionBarFrame:SetHeight(SIZE + (GAP * 2))

	if reparented then
		MultiCastActionBarFrame:SetParent(MultiCastActionBarFrame.mover)
		MultiCastActionBarFrame:SetPoint("CENTER", MultiCastActionBarFrame.mover)
	else
		MultiCastActionBarFrame:SetParent(UIParent)
		MultiCastActionBarFrame:SetPoint("TOP", UIParent, "CENTER", 0, -175)
	end

	MultiCastActionBarFrame:EnableMouse(false)

	UIPARENT_MANAGED_FRAME_POSITIONS["MultiCastActionBarFrame"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["MULTICASTACTIONBAR_YPOS"] = nil

	MultiCastActionBarFrame.ignoreFramePositionManager = true

	stop = nil
end

hooksecurefunc(MultiCastActionBarFrame, "SetParent", ImproveTotemFrame)
hooksecurefunc(MultiCastActionBarFrame, "SetPoint", ImproveTotemFrame)

hooksecurefunc("MultiCastRecallSpellButton_Update", ImproveTotemFrame)
hooksecurefunc("MultiCastSummonSpellButton_Update", ImproveTotemFrame)

do
	local stop
	local function UnsetNormalTexture(button)
		if stop then return end
		stop = true
		button:SetNormalTexture("")
		button:GetNormalTexture():Hide()
		stop = nil
	end
	for i = 1, 4 do
		hooksecurefunc(actionButtons[i], "SetNormalTexture", UnsetNormalTexture)
	end
end

eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	if event == "PLAYER_REGEN_DISABLED" then
		MultiCastActionBarFrame.mover:Lock()
	elseif pending then
		ImproveTotemFrame()
	end
end)

------------------------------------------------------------------------

local mover = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
mover.actionButtons = actionButtons
mover.slotButtons = slotButtons
MultiCastActionBarFrame.mover = mover

mover:EnableMouse(true)
mover:SetFrameStrata("LOW")
mover:SetMovable(true)
mover:SetWidth((SIZE * 4) + (GAP * 5))
mover:SetHeight(SIZE + (GAP * 2))

local overlay = CreateFrame("Button", nil, mover)
mover.overlay = overlay

overlay:Hide()
overlay:EnableMouse(true)
overlay:RegisterForDrag("LeftButton")
overlay:RegisterForClicks("LeftButtonUp")
overlay:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16 })
overlay:SetFrameLevel(mover:GetFrameLevel() + 10)
overlay:SetAllPoints(true)

overlay:SetScript("OnDragStart", function(self)
	local parent = self:GetParent()
	parent:StartMoving()
	parent.isMoving = true
end)

overlay:SetScript("OnDragStop", function(self)
	local parent = self:GetParent()
	parent:StopMovingOrSizing()

	local x = floor( (UIParent:GetWidth() / 2) - (parent:GetLeft() + (parent:GetWidth() / 2)) + 0.5 )
	local y = floor( ((UIParent:GetHeight() / 2) - parent:GetTop()) + 0.5 )

	ImprovedTotemFrameDB.pX, ImprovedTotemFrameDB.pY = -x, -y

	parent:ClearAllPoints()
	parent:SetPoint("TOP", UIParent, "CENTER", -x, -y)

	parent.isMoving = nil
end)

function mover:Lock()
	eventFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
	self.overlay:Hide()
	self.isUnlocked = nil
end

function mover:Unlock()
	if InCombatLockdown() then return end
	eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	self.overlay:Show()
	self.overlay:SetBackdropColor(0, 0, 0, ImprovedTotemFrameDB.mA)
	self.isUnlocked = true
end

mover:SetAttribute("_onstate-vis", [[
	if not newstate then return end
	if newstate == "show" then
		self:Show()
	elseif newstate == "hide" then
		self:Hide()
	end
]])

RegisterStateDriver(mover, "vis", "[bonusbar:5][@player,dead][flying][mounted][stance]hide;show")

------------------------------------------------------------------------

local ADDON_NAME = ...

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" and addon ~= ADDON_NAME then return end
	if not IsLoggedIn() then return end

	local defaults = {
		dA = 0.5,
		mA = 0.5,
		pX = 0,
		pY = -175,
	}

	ImprovedTotemFrameDB = ImprovedTotemFrameDB or { }

	for k, v in pairs(defaults) do
		if type(ImprovedTotemFrameDB[k]) ~= type(v) then
			ImprovedTotemFrameDB[k] = v
		end
	end

	mover:ClearAllPoints()
	mover:SetPoint("TOP", UIParent, "CENTER", ImprovedTotemFrameDB.pX, ImprovedTotemFrameDB.pY)

	reparented = true

	ImproveTotemFrame()

	if PhanxBorder then
		for i = 1, 4 do
			local button = actionButtons[i]
			local slot = slotButtons[i]

			PhanxBorder.AddBorder(button)
			button:SetBorderColor(unpack(colors[i]))
			button.overlayTex:SetTexture(nil)

			PhanxBorder.AddBorder(slot)
			slot:SetBorderColor(unpack(colors[i]))
			slot.overlayTex:SetTexture(nil)

			slot.background:ClearAllPoints()
			slot.background:SetAllPoints(slot)

			button:GetNormalTexture():SetAlpha(0)
		end
	end


	local CMD_FIX
	if GetLocale() == "esES" or GetLocale() == "esMX" then
		CMD_FIX = "arreglar"
	end
	SLASH_IMPROVEDTOTEMFRAME1 = "/totems"
	SlashCmdList.IMPROVEDTOTEMFRAME = function(cmd)
		cmd = (cmd or ""):trim():lower()
		if cmd == "fix" or cmd == CMD_FIX then
			ImproveTotemFrame()
		elseif mover.isUnlocked then
			mover:Lock()
		else
			mover:Unlock()
		end
	end

	self:UnregisterAllEvents()
	self:SetScript("OnEvent", nil)
	loader = nil
end)

--[[--------------------------------------------------------------------
	MultiCastActionBarFrame
		MultiCastActionPage1
			MultiCastSlotButton1
			MultiCastSlotButton2
			MultiCastSlotButton3
			MultiCastSlotButton4
			MultiCastSummonSpellButton
			MultiCastActionButton1
			MultiCastActionButton2
			MultiCastActionButton3
			MultiCastActionButton4
			MultiCastRecallSpellButton
----------------------------------------------------------------------]]