--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local API = Engine.API_V2;

local C = Engine.Constants;
local S = Engine.Settings;
local Core = Engine.Core;
local Cursor = Engine.Cursor;
local Methods = Engine.Methods;
local Util = Engine.Util;

local InCombatLockdown = InCombatLockdown;


--[[------------------------------------------------
	CreateButton
	ActionButtonName:	The requested name for the frame, nil means an auto generated name will be used
		Mainly the only reason to specify a specific frame name is when there is a setting that is reliant
		on that exact name; e.g. properly WoW managed KeyBindings need a fixed frame name
		
		Important to note, if necessary the ActionButtonName will be forcibly obtained (maining if the global key
			is already allocated this will overwrite it (it really is best to allow an auto generated name
			as those names test the key for existance first)
	
	Action: This table defines what the action for the Button should be set to
	
	LinkActionTable: True/False, if true the Action table will be linked to the button so that when other operations
					occur the action table will be updated with those actions (to make it easy to save out state to
					the main addon)
					Note only one action store will ever be remembered for the button
		
	Returns ActionButton Widget (that is a BF Action Button)
	Tests
	- ActionButtonName = null, inactive buttons, (repeat x 3 so that none are left)
	- ActionButtonName = null, no inactive buttons	(test on fresh, and after test 1 leaves none)
	- ActionButtonName = non button global
	- ActionButtonName = active button
	- ActionButtonName = inactive button
	- ActionButtonName = unused
	
--------------------------------------------------]]
function API.CreateButton(ActionButtonName, Action, LinkActionTable)
	if (InCombatLockdown()) then
		return nil, C.ERROR_IN_COMBAT_LOCKDOWN;
	end
	local BFButton = Core.GetBFButton(ActionButtonName);
	Methods.SetAction(BFButton, Action, LinkActionTable);
	Methods.SetFlyoutDirection(BFButton	, S.ButtonDefaults.FlyoutDirection);
	Methods.SetKeyBindText(BFButton		, S.ButtonDefaults.KeyBindText);
	Methods.SetEnabled(BFButton			, S.ButtonDefaults.Enabled);
	Methods.SetRespondsToMouse(BFButton	, S.ButtonDefaults.RespondsToMouse);
	Methods.SetAlpha(BFButton			, S.ButtonDefaults.Alpha);
	Methods.SetLocked(BFButton			, S.ButtonDefaults.Locked);
	Methods.SetAlwaysShowGrid(BFButton	, S.ButtonDefaults.AlwaysShowGrid);
	Methods.SetShowTooltip(BFButton		, S.ButtonDefaults.ShowTooltip);
	Methods.SetShowKeyBindText(BFButton	, S.ButtonDefaults.ShowKeyBindText);
	Methods.SetShowCounts(BFButton		, S.ButtonDefaults.ShowCounts);
	Methods.SetShowMacroName(BFButton	, S.ButtonDefaults.ShowMacroName);
		
	return BFButton.ABW;
end


--[[------------------------------------------------
	RemoveButton
	Tests
	- BFButton is null
	- BFButton is not a Button
	- BFButton is an Active Button
	- BFButton is an Inactive Button
--------------------------------------------------]]
function API.RemoveButton(ActionButton)
	if (InCombatLockdown()) then
		return C.ERROR_IN_COMBAT_LOCKDOWN;
	end
	
	return Core.RemoveBFButton(ActionButton.BFButton);
end

--[[------------------------------------------------
	ApplySettings
--------------------------------------------------
function API.ApplySettings(BFButton, ButtonSettings)
	if (InCombatLockdown()) then
		return C.ERROR_IN_COMBAT_LOCKDOWN;
	end
	
	Methods.SetAction(BFButton, ButtonSettings.Action);
	Methods.SetKeyBindText(BFButton, ButtonSettings.KeyBindText);
end]]


--[[------------------------------------------------
	SetAction
--------------------------------------------------]]
function API.SetAction(ActionButton, Action, LinkActionTable)
	return InCombatLockdown() and C.ERROR_IN_COMBAT_LOCKDOWN or Methods.SetAction(ActionButton.BFButton, Action, LinkActionTable);
end

function API.SetActionEmpty(ActionButton)
	return InCombatLockdown() and C.ERROR_IN_COMBAT_LOCKDOWN or Methods.SetActionEmpty(ActionButton.BFButton);
end


--[[------------------------------------------------
	Set Spell
--------------------------------------------------]]
function API.SetActionSpell(ActionButton, SpellID)
	return InCombatLockdown() and C.ERROR_IN_COMBAT_LOCKDOWN or Methods.SetActionSpell(ActionButton.BFButton, SpellID);
end


--[[------------------------------------------------
	Set Item
--------------------------------------------------]]
function API.SetActionItem(ActionButton, ItemID)
	return InCombatLockdown() and C.ERROR_IN_COMBAT_LOCKDOWN or Methods.SetActionItem(ActionButton.BFButton, ItemID);
end


--[[------------------------------------------------
	Set Macro
--------------------------------------------------]]
function API.SetActionMacro(ActionButton, MacroIndex, MacroName, MacroBody)
	return InCombatLockdown() and C.ERROR_IN_COMBAT_LOCKDOWN or Methods.SetActionMacro(ActionButton.BFButton, MacroIndex, MacroName, MacroBody);
end


--[[------------------------------------------------
	Set Mount
--------------------------------------------------]]
function API.SetActionMount(ActionButton, MountID)
	return InCombatLockdown() and C.ERROR_IN_COMBAT_LOCKDOWN or Methods.SetActionMount(ActionButton.BFButton, MountID);
end


--[[------------------------------------------------
	Set Mount Favorite
--------------------------------------------------]]
function API.SetActionMountFavorite(ActionButton)
	return InCombatLockdown() and C.ERROR_IN_COMBAT_LOCKDOWN or Methods.SetActionMountFavorite(ActionButton.BFButton);
end


--[[------------------------------------------------
	Set Battle Pet
--------------------------------------------------]]
function API.SetActionBattlePet(ActionButton, GUID)
	return InCombatLockdown() and C.ERROR_IN_COMBAT_LOCKDOWN or Methods.SetActionBattlePet(ActionButton.BFButton, GUID);
end


--[[------------------------------------------------
	Set Flyout
--------------------------------------------------]]
function API.SetActionFlyout(ActionButton, FlyoutID)
	return InCombatLockdown() and C.ERROR_IN_COMBAT_LOCKDOWN or Methods.SetActionFlyout(ActionButton.BFButton, FlyoutID);
end


--[[------------------------------------------------
	Set EquipmentSet
--------------------------------------------------]]
function API.SetActionEquipmentSet(ActionButton, NameOrID)
	return InCombatLockdown() and C.ERROR_IN_COMBAT_LOCKDOWN or Methods.SetActionEquipmentSet(ActionButton.BFButton, NameOrID);
end



--[[------------------------------------------------
	Set Flyout Direction
--------------------------------------------------]]
function API.SetFlyoutDirection(ActionButton, Direction)
	return Util.NoCombatAndValidButtonTest(ActionButton) or Methods.SetFlyoutDirection(ActionButton.BFButton, Direction);
end


--[[------------------------------------------------
	MouseOverFlyoutDirectionUI
		Enable or Disable for the Button
--------------------------------------------------]]
function API.MouseOverFlyoutDirectionUI(ActionButton, Enable)
	return Util.NoCombatAndValidButtonTest(ActionButton) or Methods.MouseOverFlyoutDirectionUI(ActionButton.BFButton, Enable);
end





function API.SetKeyBindText(ActionButton, KeyBindText)
	if (not ActionButton.BFButton) then
		return C.ERROR_NOT_BUTTONFORGE_ACTIONBUTTON;
	end
	return Methods.SetKeyBindText(ActionButton.BFButton, KeyBindText);
end


function API.SetAlwaysShowGrid(ActionButton, AlwaysShowGrid)
	return Util.NoCombatAndValidButtonTest(ActionButton) or Methods.SetAlwaysShowGrid(ActionButton.BFButton, AlwaysShowGrid);
end

function API.SetLocked(ActionButton, Locked)
	return Methods.SetLocked(ActionButton.BFButton, Locked);
end

function API.SetShowTooltip(ActionButton, ShowTooltip)
	return Methods.SetShowTooltip(ActionButton.BFButton, ShowTooltip);
end

function API.SetEnabled(ActionButton, Enabled)
	return Util.NoCombatAndValidButtonTest(ActionButton) or Methods.SetEnabled(ActionButton.BFButton, Enabled);
end


--[[------------------------------------------------
	RegisterForChanges
--------------------------------------------------]]
function API.RegisterForEvents(Value, CallbackFunction, Object)
	Core.RegisterForEvents(Value, CallbackFunction, Object);
end


--[[------------------------------------------------
	DeregisterForChanges
--------------------------------------------------]]
function API.DeregisterForEvents(Value, CallbackFunction)
	Core.DeregisterForEvents(Value, CallbackFunction);
end

function API.RegisterForCursorChanges(CallbackFunction)
	Core.RegisterForCursorChanges(CallbackFunction);
end

function API.GetCursorInfo()
	return Cursor.GetCursor();
end

--[[------------------------------------------------
	LookupSpellID
	* Name of the Spell, Talent, or Specialization Spell
	* [Specialization] (optional)
--------------------------------------------------]]
function API.LookupSpellID(Name, Specialization)
	local SpellID = Util.LookupSpecializationSpellID(Name, Specialization) or Util.LookupTalentSpellID(Name, Specialization) or select(7, GetSpellInfo(Name));
	return SpellID;
end

