--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local Core = Engine.Core;

local C = Engine.Constants;
local S = Engine.Settings;
local Util = Engine.Util;
local SecureManagement = Engine.SecureManagement;
local Cursor = Engine.Cursor;
local Scripts = Engine.Scripts;
local Methods = Engine.Methods;

local ActiveBFButtons = {};
local InactiveBFButtons = {};
local Callbacks = {};
local CombatQueuedFunctions = {};
local CursorChangeCallbacks = {};

local FlashButtons = {};
local RangeButtons = {};
local FlashTimerFrame = CreateFrame("FRAME");
FlashTimerFrame.CountDown = 0;
FlashTimerFrame.FlashOn = false;
local RangeTimerFrame = CreateFrame("FRAME");
RangeTimerFrame.CountDown = 0;

local PreventGridHide = false;


--[[------------------------------------------------
	Create Button
--------------------------------------------------]]
function Core.GetBFButton(ActionButtonName)
	local BFButton;
	
	-- Try acquire from inactive buttons
	if (not ActionButtonName) then
		BFButton = table.remove(InactiveBFButtons);
	elseif (_G[ActionButtonName]) then
		BFButton = Util.RemoveFromTable(InactiveBFButtons, type(_G[ActionButtonName]) == "table" and _G[ActionButtonName].BFButton);
		if (not BFButton) then
			return nil, C.ERROR_BUTTON_NAME_IN_USE;
		end
	end
	
	-- If not aquired then create a new BFButton
	if (not BFButton) then
		ActionButtonName = ActionButtonName or Util.GetDefaultButtonFrameName();
		BFButton = Core.CreateBFButton(ActionButtonName);
	end
	--BFButton.ABW:Show();
	
	table.insert(ActiveBFButtons, BFButton);
	return BFButton;
end


--[[------------------------------------------------
	Create Button
--------------------------------------------------]]
function Core.CreateBFButton(ActionButtonName)
	local BFButton = {};
	local ABW = CreateFrame("CheckButton", ActionButtonName, nil, "SecureActionButtonTemplate, ActionButtonTemplate");
	
	ABW:SetAttribute("checkselfcast", true);
	ABW:SetAttribute("checkfocuscast", true);
	--ABW:SetAttribute("useparent-unit", true);				
	--ABW:SetAttribute("useparent-actionpage", true);
	ABW:RegisterForDrag("LeftButton", "RightButton");
	ABW.action = 10000;	-- Hack so Flyout will work

	-- Handlers to manage swapping actions in/out of the ABW --
	ABW:SetScript("OnReceiveDrag"	, Scripts.OnReceiveDrag);
	ABW:SetScript("OnDragStart"		, Scripts.OnDragStart);
	ABW:SetScript("PostClick"		, Scripts.PostClick);
	ABW:SetScript("PreClick"		, Scripts.PreClick);
	--ABW:SetScript("OnEnter"			, Scripts.OnEnterStandard);	-- Set by a function lower down
	--ABW:SetScript("OnLeave"			, Scripts.OnLeaveStandard);
	
	-- Add the additional ABW elements not found in the ABT
	-- FloatingBG (MultiBarButtonTemplate)
	local FloatingBG = ABW:CreateTexture(ActionButtonName.."FloatingBG", "BACKGROUND", nil, -1);
	FloatingBG:SetTexture("Interface\\Buttons\\UI-Quickslot");
	FloatingBG:SetAlpha(0.4);
	FloatingBG:SetPoint("TOPLEFT", -15, 15);
	FloatingBG:SetPoint("BOTTOMRIGHT", 15, -15);
	
	-- AutoCastable (PetActionButtonTemplate)
	local AutoCastable = ABW:CreateTexture(ActionButtonName.."AutoCastable", "OVERLAY");
	AutoCastable:SetTexture("Interface\\Buttons\\UI-AutoCastableOverlay");
	AutoCastable:SetSize(70, 70);
	AutoCastable:SetPoint("CENTER", 0, 0);
	AutoCastable:Hide();

	-- Set bidirectional references
	ABW.BFButton = BFButton;
	BFButton.ABW = ABW;
	
	-- Get easy reference to the Action Button Widgets	(not all will be used), be careful of inconsistent character case!
	BFButton.ABWIcon				= ABW.icon;
	BFButton.ABWFlash				= ABW.Flash;
	BFButton.ABWFlyoutBorder		= ABW.FlyoutBorder;
	BFButton.ABWFlyoutBorderShadow	= ABW.FlyoutBorderShadow;
	BFButton.ABWFlyoutArrow			= ABW.FlyoutArrow;
	BFButton.ABWHotKey				= ABW.HotKey;
	BFButton.ABWCount				= ABW.Count;
	BFButton.ABWName				= ABW.Name;
	BFButton.ABWBorder				= ABW.Border;
	BFButton.ABWNewActionTexture	= ABW.NewActionTexture;
	BFButton.ABWCooldown			= ABW.cooldown;
	BFButton.ABWNormalTexture		= ABW.NormalTexture;
	BFButton.ABWFloatingBG			= FloatingBG;

	BFButton.Callbacks				= {};
	Core.SetupActionButtonClick(BFButton);
	Core.SetCooldownType(BFButton, COOLDOWN_TYPE_NORMAL);
	
	Core.SetupEnterLeaveHandlers(BFButton);
	return BFButton;
end


--[[------------------------------------------------
	SetupActionButtonClick
--------------------------------------------------]]
local SecureClickWrapperFrame = CreateFrame("FRAME", nil, nil, "SecureHandlerBaseTemplate");
function Core.SetupActionButtonClick(BFButton)
	if (GetCVarBool("ActionButtonUseKeyDown")) then
		BFButton.ABW:RegisterForClicks("AnyUp", "AnyDown");
		SecureClickWrapperFrame:WrapScript(BFButton.ABW, "OnClick", Scripts.SecurePreClickUseKeyDownSnippet);
	else
		BFButton.ABW:RegisterForClicks("AnyUp");
		SecureClickWrapperFrame:WrapScript(BFButton.ABW, "OnClick", Scripts.SecurePreClickOnUpSnippet);
	end
end


--[[------------------------------------------------
	RemoveBFButton
--------------------------------------------------]]
function Core.RemoveBFButton(BFButton)
	if (Util.RemoveFromTable(ActiveBFButtons, BFButton) == nil) then
		return C.ERROR_BUTTON_NOT_FOUND;
	end
	Core.ResetBFButton(BFButton);
	BFButton.ABW:Hide();
	table.insert(InactiveBFButtons, BFButton);
end


--[[------------------------------------------------
	ScrubActionValues
	Note:
		* This makes no assumption on whether it's a BFButton
			or just a saved action table structure
		* This will also scrub a few random values not specifically
			part of a stored action, e.g. IconTexture
--------------------------------------------------]]
function Core.ScrubActionValues(Table)

	-- Misc
	Table.Type			= nil;
	Table.IconTexture	= nil;
	Table.Target		= nil;
	
	-- Spell
	Table.SpellID		= nil;
	Table.SpellFullName	= nil;
	
	-- Item
	Table.ItemID		= nil;
	Table.ItemName		= nil;
	Table.ItemLink		= nil;
	
	-- Macro
	Table.MacroIndex	= nil;
	Table.MacroName		= nil;
	Table.MacroBody		= nil;
	Table.MacroMode		= nil;
	Table.MacroAction	= nil;
	
	-- Mount
	Table.MountID		= nil;
	Table.MountName		= nil;
	
	-- BattlePet
	Table.BattlePetGUID	= nil;
	Table.BattlePetName	= nil;
	Table.BattlePetSpeciesName = nil;
	
	-- Flyout
	Table.FlyoutID			= nil;
	Table.FlyoutName		= nil;
	Table.FlyoutDescription = nil;
	
	-- EquipmentSet
	Table.EquipmentSetName = nil;
	
end


--[[------------------------------------------------
	ResetDisplayState
	Notes:
		* Not secure due to ReleaseTempButtonResources
--------------------------------------------------]]
function Core.ResetDisplayState(BFButton)
	
	-- Icon
	BFButton.ABWIcon:SetTexture(nil);
	
	-- Checked
	BFButton.ABW:SetChecked(false);
	BFButton.ABW:GetCheckedTexture():SetAlpha(1);
	
	-- Usable
	Core.UpdateButtonUsable(BFButton, true);
	
	-- Equipped
	BFButton.ABWBorder:Hide();
	
	-- Count
	BFButton.ABWCount:SetText(nil);
	
	-- Name
	BFButton.ABWName:SetText(nil);
	
	-- Flyout (for the Arrow)
	Core.UpdateFlyout(BFButton);
	
	-- Display State that also holds resource
	Core.ReleaseTempButtonResources(BFButton);
end


--[[------------------------------------------------
	ReleaseTempButtonResources
	Notes:
		* Unsecure due to SpellFlyout Hide
		* intended to be called out of combat for enabled
			or for changing the button action
--------------------------------------------------]]
function Core.ReleaseTempButtonResources(BFButton)
	-- Cooldown resources
	ClearChargeCooldown(BFButton.ABW);	--Blizzard Function
	BFButton.ABWCooldown:Clear();
	
	-- Glow
	ActionButton_HideOverlayGlow(BFButton.ABW);	-- Blizzard Function
	
	-- Flash
	Core.UpdateButtonFlashRegistration(BFButton)
	
	-- Range
	Core.UpdateButtonRangeRegistration(BFButton)
	
	-- Flyout
	if (SpellFlyout:GetParent() == BFButton.ABW) then
		SpellFlyout:Hide();
	end
	
	-- Tooltip
	if (GetMouseFocus() == BFButton.ABW) then
		GameTooltip:Hide();
	end	
end


--[[------------------------------------------------
	ScrubActionAttributeValues
--------------------------------------------------]]
function Core.ScrubActionAttributeValues(BFButton)
	local ABW = BFButton.ABW;
	ABW:SetAttribute("type"		, nil);
	ABW:SetAttribute("type2"	, nil);
	ABW:SetAttribute("spell"	, nil);
	ABW:SetAttribute("item"		, nil);
	ABW:SetAttribute("macro"	, nil);
	ABW:SetAttribute("macrotext", nil);
	ABW:SetAttribute("macrotext2", nil);
	ABW:SetAttribute("action"	, nil);
	ABW:SetAttribute("id"		, nil);
end


--[[------------------------------------------------
	* Register for events, either all events
	* or just those for a single button
--------------------------------------------------]]
function Core.RegisterForEvents(ActionButton, CallbackFunction, Object)
	assert(type(CallbackFunction) == "function", C.ERROR_REGISTERFOREVENTS_PARAMETERS);
	if (not ActionButton) then
		Callbacks[CallbackFunction] = Object or true;	
	elseif (ActionButton.BFButton) then
		ActionButton.BFButton.Callbacks[CallbackFunction] = Object or true;
	end
end


--[[------------------------------------------------
	Deregister For Button Events
	Either for a specific button or for all events
--------------------------------------------------]]
function Core.DeregisterForEvents(ActionButton, CallbackFunction)
	assert(type(CallbackFunction) == "function", C.ERROR_DEREGISTERFOREVENTS_PARAMETERS);
	if (not ActionButton) then		
		Callbacks[CallbackFunction] = nil;
	elseif (ActionButton.BFButton) then
		ActionButton.BFButton.Callbacks[CallbackFunction] = nil;
	end
end


--[[------------------------------------------------
	ReportEvent
	All changes to the buttons will get reported through this function
--------------------------------------------------]]
local function LoopThroughCallbacks(Callbacks, Event, ...)
	for Callback, Object in pairs(Callbacks) do
		local Status, Message;
		if (Object == true) then
			Status, Message = pcall(Callback, Event, ...);
		else
			Status, Message = pcall(Callback, Object, Event, ...);
		end
		if (not Status) then
			-- Do Something with the Error?!
		end
	end
end
function Core.ReportEvent(BFButton, Event, ...)
	if (BFButton) then
		LoopThroughCallbacks(BFButton.Callbacks, Event, BFButton.ABW, ...);
		LoopThroughCallbacks(Callbacks, Event, BFButton.ABW, ...);
	else
		LoopThroughCallbacks(Callbacks, Event, ...);
	end
end


function Core.RegisterForCursorChanges(CallbackFunction)
	assert(type(CallbackFunction) == "function", C.ERROR_REGISTERFOREVENTS_PARAMETERS);
	CursorChangeCallbacks[CallbackFunction] = true;
end


function Core.ReportCursorActionChange()
	for Callback, v in pairs(CursorChangeCallbacks) do
		local Status, Message = pcall(Callback, Cursor.GetCursor());
		if (not Status) then
			-- Do Something with the Error?!
		end
	end
end


--[[------------------------------------------------
	Update Button Functions
--------------------------------------------------]]
function Core.LeaveCombatUpdate()
	for k, v in pairs(CombatQueuedFunctions) do
		k();
		CombatQueuedFunctions[k] = nil;
	end
	
	-- Make sure we're otherwise all up to date
	Core.FullUpdateAll();
end

function Core.LeaveCombatQueueUpFunction(f)
	CombatQueuedFunctions[f] = true;
end

function Core.UpdateActionAll()
	if (InCombatLockdown()) then
		Core.LeaveCombatQueueUpFunction(Core.UpdateActionAll);
		return C.INFO_QUEUED_FOR_AFTER_COMBAT;
	end
	local b = ActiveBFButtons;
	for i = 1, #b do
		b[i]:UpdateAction();
	end
end

function Core.FullUpdateAll()
	local b = ActiveBFButtons;
	for i = 1, #b do
		b[i]:FullUpdate();
	end
end

function Core.UpdateIconAll()
	local b = ActiveBFButtons;
	for i = 1, #b do
		b[i]:UpdateIcon();
	end
end

function Core.UpdateCheckedAll()
	local b = ActiveBFButtons;
	for i = 1, #b do
		b[i]:UpdateChecked();
	end
end

function Core.UpdateUsableAll()
	local b = ActiveBFButtons;
	for i = 1, #b do
		b[i]:UpdateUsable();
	end
end

function Core.UpdateCooldownAll()
	local b = ActiveBFButtons;
	for i = 1, #b do
		b[i]:UpdateCooldown();
	end
end

function Core.UpdateEquippedAll()
	local b = ActiveBFButtons;
	for i = 1, #b do
		b[i]:UpdateEquipped();
	end
end

function Core.UpdateTextAll()
	local b = ActiveBFButtons;
	for i = 1, #b do
		b[i]:UpdateText();
	end
end

function Core.UpdateGlowAll()
	local b = ActiveBFButtons;
	for i = 1, #b do
		b[i]:UpdateGlow();
	end
end

function Core.UpdateShineAll()
	local b = ActiveBFButtons;
	for i = 1, #b do
		b[i]:UpdateShine();
	end
end

function Core.UpdateMacroAll()
	local b = ActiveBFButtons;
	for i = 1, #b do
		b[i]:UpdateMacro();
	end
end

function Core.UpdateFlashRegistrationAll()
	local b = ActiveBFButtons;
	for i = 1, #b do
		b[i]:UpdateFlashRegistration();
	end
end

function Core.UpdateRangeRegistrationAll()
	local b = ActiveBFButtons;
	for i = 1, #b do
		b[i]:UpdateRangeRegistration();
	end
end


--[[------------------------------------------------
	* This is a central place to route errors to
	* It's not intended for basic events that are expected
	* it is for occurences not expected
	* These are cleanly handled errors (more or less)
		- Meaning the addon should still be able to operate
		- The player does not necessarily need to know (though they may see odd behaviour)
		- Mostly I intend for the primary addon to log them so that such can be reviewed
--------------------------------------------------]]
function Core.ErrorOccurred(BFButton, Error, ...)
	Core.ReportEvent(BFButton, Error, ...);
	return Error;
end


--[[------------------------------------------------
	Flash updating
--------------------------------------------------]]
function Core.UpdateButtonFlashRegistration(BFButton, Register)
	if (Register) then
		FlashButtons[BFButton] = true;
		if (FlashTimerFrame.FlashOn) then
			BFButton.ABWFlash:Show();
		end
	else
		FlashButtons[BFButton] = nil;
		BFButton.ABWFlash:Hide();
	end
end

function FlashTimerFrame:OnUpdate(Elapsed)
	local CountDown = self.CountDown - Elapsed;
	if (CountDown <= 0) then
		if (-CountDown >= ATTACK_BUTTON_FLASH_TIME) then
			CountDown = ATTACK_BUTTON_FLASH_TIME;
		else
			CountDown = ATTACK_BUTTON_FLASH_TIME + CountDown;
		end
		
		if (self.FlashOn) then
			self.FlashOn = false;
			for k, v in pairs(FlashButtons) do
				k.ABWFlash:Hide();
			end
		else
			self.FlashOn = true;
			for k, v in pairs(FlashButtons) do
				k.ABWFlash:Show();
			end
		end
	end
	self.CountDown = CountDown;
end
FlashTimerFrame:SetScript("OnUpdate", FlashTimerFrame.OnUpdate);


--[[------------------------------------------------
	Range updating	Register should be 1, 0, or nil as per the WoW API
--------------------------------------------------]]
function Core.UpdateButtonRangeRegistration(BFButton, Register)
	local HotKey = BFButton.ABWHotKey;
	if (Register) then
		RangeButtons[BFButton] = true;
		if (HotKey:GetText() == RANGE_INDICATOR) then
			HotKey:Show();
		end	
		Core.UpdateButtonRangeIndicator(BFButton, Register);
	else
		RangeButtons[BFButton] = nil;
		if (HotKey:GetText() == RANGE_INDICATOR) then
			HotKey:Hide();
		end	
		Core.UpdateButtonRangeIndicator(BFButton);
	end
end

function RangeTimerFrame:OnUpdate(Elapsed)
	local CountDown = self.CountDown - Elapsed;
	if (CountDown <= 0) then
		for k, v in pairs(RangeButtons) do
			k:CheckRange();
		end
		CountDown = TOOLTIP_UPDATE_TIME;
	end
	self.CountDown = CountDown;
end
RangeTimerFrame:SetScript("OnUpdate", RangeTimerFrame.OnUpdate);

function Core.UpdateButtonRangeIndicator(BFButton, InRange)
	if (InRange == 0) then
		BFButton.ABWHotKey:SetVertexColor(1.0, 0.1, 0.1);
	else
		BFButton.ABWHotKey:SetVertexColor(0.6, 0.6, 0.6);
	end
end



-- Note unlike the individual version below - this function will not perform other updates or resource release
-- This is because the purpose of this function is to deal with a temporary display toggle
function Core.UpdateButtonShowHideAll()
	if (InCombatLockdown()) then
		Core.LeaveCombatQueueUpFunction(Core.UpdateButtonShowHideAll);
		return;
	end
	
	local b = ActiveBFButtons;
	local CursorHasAction = Cursor.HasValidAction();

	for i = 1, #b do
		local BFButton = b[i];
		if (BFButton.Enabled) then
			if (BFButton.Type == "empty"
				and BFButton.AlwaysShowGrid == false
				and CursorHasAction == false) then
				BFButton.ABW:Hide();
			else
				BFButton.ABW:Show();
			end
		end
	end
end


function Core.PreventGridHide(Prevent)
	PreventGridHide = Prevent;
end

function Core.UpdateButtonShowHide(BFButton)
	-- do not call while in Combat - ok, ok!

	Core.UpdateOnCombatHideRegistration(BFButton);

	if (BFButton.Enabled) then
		if (BFButton.Type == "empty"
			and (BFButton.AlwaysShowGrid == false and not PreventGridHide)
			and Cursor.HasValidAction() == false) then
			
			Core.ReleaseTempButtonResources(BFButton);
			BFButton.ABW:Hide();
			
		else
			BFButton.ABW:Show();
		end
	end


end


--[[------------------------------------------------
	UpdateOnCombatHideRegistration
	Notes:
		* For allocated buttons this function will decide
			whether or not the button should be registered
			to hide on combat based on a variety of state
			values
--------------------------------------------------]]
function Core.UpdateOnCombatHideRegistration(BFButton)

	if (BFButton.Type == "empty"
		and BFButton.AlwaysShowGrid == false
		and BFButton.Enabled) then
		SecureManagement.RegisterForOnCombatHide(BFButton.ABW);
	else
		SecureManagement.DeregisterForOnCombatHide(BFButton.ABW);
	end

end


--[[------------------------------------------------
	SetCooldownType
--------------------------------------------------]]
function Core.SetCooldownType(BFButton, Type)
	local Cooldown = BFButton.ABWCooldown;
	if (Cooldown.currentCooldownType ~= Type) then
		if (Type == COOLDOWN_TYPE_LOSS_OF_CONTROL) then
			Cooldown:SetEdgeTexture("Interface\\Cooldown\\edge-LoC");
			Cooldown:SetSwipeColor(0.17, 0, 0);
			Cooldown:SetHideCountdownNumbers(true);
			Cooldown.currentCooldownType = COOLDOWN_TYPE_LOSS_OF_CONTROL;
		else
			Cooldown:SetEdgeTexture("Interface\\Cooldown\\edge");
			Cooldown:SetSwipeColor(0, 0, 0);
			Cooldown:SetHideCountdownNumbers(false);
			Cooldown.currentCooldownType = COOLDOWN_TYPE_NORMAL;
		end
	end
end


--[[------------------------------------------------
	UpdateButtonUsable
--------------------------------------------------]]
function Core.UpdateButtonUsable(BFButton, IsUsable, NotEnoughMana)
	if (IsUsable) then
		BFButton.ABWIcon:SetVertexColor(1.0, 1.0, 1.0);
		BFButton.ABWNormalTexture:SetVertexColor(1.0, 1.0, 1.0);
	elseif (NotEnoughMana) then
		BFButton.ABWIcon:SetVertexColor(0.5, 0.5, 1.0);
		BFButton.ABWNormalTexture:SetVertexColor(0.5, 0.5, 1.0);
	else
		BFButton.ABWIcon:SetVertexColor(0.4, 0.4, 0.4);
		BFButton.ABWNormalTexture:SetVertexColor(1.0, 1.0, 1.0);
	end
end


--[[------------------------------------------------
	UpdateFlyout
	Notes:
		* WoW v7 (and older...)
		* We use hooks here in order to stay graphically consistent with Flyout Border/Arrows
			* BF Buttons can't work directly with the ActionButton_UpdateFlyout function sadly
			* The Flyouts can update display without generating events leaving not many options
--------------------------------------------------]]
local FlyoutOldParent;
function HookSecureFunc_SpellFlyout_Toggle(SpellFlyout, flyoutID, parent, direction, distance, isActionBar, specID, showFullTooltip)
	if (FlyoutOldParent) then
		Core.UpdateFlyout(FlyoutOldParent.BFButton);
		FlyoutOldParent = nil;
	end
	if (parent and parent.BFButton) then
		Core.UpdateFlyout(parent.BFButton);
		FlyoutOldParent = parent;
	end
end
hooksecurefunc(SpellFlyout, "Toggle", HookSecureFunc_SpellFlyout_Toggle);

function HookSecureFunc_SpellFlyout_Hide(SpellFlyout)
	if (SpellFlyout) then 
		local Parent = SpellFlyout:GetParent();
		if (Parent and Parent.BFButton) then
			Core.UpdateFlyout(Parent.BFButton);
		end
	end
end
hooksecurefunc(SpellFlyout, "Hide", HookSecureFunc_SpellFlyout_Hide);

function Core.UpdateFlyout(BFButton)
	if (BFButton.Type == "flyout") then
		-- Update border and determine arrow position
		local ABW = BFButton.ABW;
		local arrowDistance;
		if ((SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == ABW) or GetMouseFocus() == ABW) then
			BFButton.ABWFlyoutBorder:Show();
			BFButton.ABWFlyoutBorderShadow:Show();
			arrowDistance = 5;
		else
			BFButton.ABWFlyoutBorder:Hide();
			BFButton.ABWFlyoutBorderShadow:Hide();
			arrowDistance = 2;
		end
			
		-- Update arrow
		BFButton.ABWFlyoutArrow:Show();
		BFButton.ABWFlyoutArrow:ClearAllPoints();
		local FlyoutDirection = ABW:GetAttribute("flyoutdirection");
		if (FlyoutDirection == "UP") then
			BFButton.ABWFlyoutArrow:SetPoint("TOP", ABW, "TOP", 0, arrowDistance);
			SetClampedTextureRotation(BFButton.ABWFlyoutArrow, 0);
		elseif (FlyoutDirection == "LEFT") then
			BFButton.ABWFlyoutArrow:SetPoint("LEFT", ABW, "LEFT", -arrowDistance, 0);
			SetClampedTextureRotation(BFButton.ABWFlyoutArrow, 270);
		elseif (FlyoutDirection == "RIGHT") then
			BFButton.ABWFlyoutArrow:SetPoint("RIGHT", ABW, "RIGHT", arrowDistance, 0);
			SetClampedTextureRotation(BFButton.ABWFlyoutArrow, 90);
		elseif (FlyoutDirection == "DOWN") then
			BFButton.ABWFlyoutArrow:SetPoint("BOTTOM", ABW, "BOTTOM", 0, -arrowDistance);
			SetClampedTextureRotation(BFButton.ABWFlyoutArrow, 180);
		end
	else
		BFButton.ABWFlyoutBorder:Hide();
		BFButton.ABWFlyoutBorderShadow:Hide();
		BFButton.ABWFlyoutArrow:Hide();
	end
end


function Core.SetupEnterLeaveHandlers(BFButton)
	local ABW = BFButton.ABW;
	--if (BFButton.MouseOverFlyoutDirectionUIEnabled) then
		ABW:SetScript("OnEnter", Scripts.OnEnterComplete);
		ABW:SetScript("OnLeave", Scripts.OnLeaveComplete);
	--else
	--	ABW:SetScript("OnEnter", Scripts.OnEnterStandard);
	--	ABW:SetScript("OnLeave", Scripts.OnLeaveStandard);
	--end
end