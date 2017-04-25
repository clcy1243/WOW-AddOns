--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014
	
	Desc:	Functions for working with the cursor and its contents
			This exists to allow me to go beyond the standard actions
			that can be picked up
]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local Cursor = Engine.Cursor;

local Methods = Engine.Methods;
local CursorCustom = Engine.CursorCustom;
local Core = Engine.Core;
local Util = Engine.Util;
local C = Engine.Constants;


--[[------------------------------------------------
	GetCursor
--------------------------------------------------]]
function Cursor.GetCursor()
	local Command, Data, Subvalue, SubSubvalue = GetCursorInfo();
	if (Command) then
		return Command, Data, Subvalue, SubSubvalue;
	else
		return CursorCustom.GetCustomCursor();
	end
end


--[[------------------------------------------------
	HasValidAction
	* Currently doesn't actually check the action type
--------------------------------------------------]]
function Cursor.HasValidAction()
	local Command = GetCursorInfo() or CursorCustom.GetCustomCursor();
	if (Command) then
		return true;
	else
		return false;
	end
end


--[[------------------------------------------------
	ClearCursor
--------------------------------------------------]]
function Cursor.ClearCursor()
	ClearCursor();
	CursorCustom.ClearCustomCursor();
end


--[[------------------------------------------------
	SetCursor
--------------------------------------------------]]
function Cursor.SetCursor(Command, Data, Subvalue, SubSubvalue, Icon, Width, Height, TexCoords)
	if (InCombatLockdown()) then
		return C.ERROR_IN_COMBAT_LOCKDOWN;
	end
	Cursor.ClearCursor();	
	if (Command == "spell") then
		PickupSpell(SubSubvalue);
	elseif (Command == "item") then
		PickupItem(Data);
	elseif (Command == "macro") then
		PickupMacro(Data);
	elseif (Command == "mount") then
		C_MountJournal.Pickup(Util.LookupMountIndex(Data));
	elseif (Command == "battlepet") then
		C_PetJournal.PickupPet(Data);
	elseif (Command == "flyout") then
		PickupSpellBookItem(Util.LookupFlyoutIndex(Data), BOOKTYPE_SPELL);
	elseif (Command == "equipmentset") then
		PickupEquipmentSetByName(Data);
	elseif (Command == "custom") then
		CursorCustom.SetCustomCursor(Command, Data, Subvalue, SubSubvalue, Icon, Width, Height, TexCoords);
	end
end


--[[------------------------------------------------
	Set Action From Cursor Values
--------------------------------------------------]]
function Cursor.SetActionFromCursorValues(BFButton, Command, Data, Subvalue, SubSubvalue)
	if (InCombatLockdown()) then
		return false, C.ERROR_IN_COMBAT_LOCKDOWN;
	end

	if (Command == "spell") then
		Methods.SetActionSpell(BFButton, SubSubvalue);	--Data = Index, Subvalue = Book (spell/pet), SubSubvalue = spell ID
	elseif (Command == "item") then
		Methods.SetActionItem(BFButton, Data);			--Data = ID, Subvalue = Link
	elseif (Command == "macro") then
		local name, iconTexture, body, isLocal = GetMacroInfo(Data);
		Methods.SetActionMacro(BFButton, Data, name, body);				--Data = Index
	elseif (Command == "mount") then
		Methods.SetActionMount(BFButton, Data);			-- Data = MountID
	elseif (Command == "battlepet") then
		Methods.SetActionBattlePet(BFButton, Data);			-- Data = GUID
	elseif (Command == "flyout") then
		Methods.SetActionFlyout(BFButton, Data);	-- Data = ID, Subvalue = Icon
	elseif (Command == "equipmentset") then
		Methods.SetActionEquipmentSet(BFButton, Data);		-- Data = Name
	elseif (Command == nil) then
		Methods.SetActionEmpty(BFButton);
	else
		return false;
	end
	return true;
end


--[[------------------------------------------------
	Store/Get Cursor
--------------------------------------------------]]
local StoredCommand, StoredData, StoredSubvalue, StoredSubSubvalue;
function Cursor.StoreCursor(...)
	StoredCommand, StoredData, StoredSubvalue, StoredSubSubvalue = ...;
end
function Cursor.GetStoredCursor()
	return StoredCommand, StoredData, StoredSubvalue, StoredSubSubvalue;
end

