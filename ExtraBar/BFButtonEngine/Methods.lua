--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local Methods = Engine.Methods;

local C = Engine.Constants;
local S = Engine.Settings;
local Core = Engine.Core;
local Util = Engine.Util;
local SecureManagement = Engine.SecureManagement;
local FlyoutUI = Engine.FlyoutUI;
local Scripts = Engine.Scripts;
local ScriptsSpell = Engine.ScriptsSpell;
local ScriptsItem = Engine.ScriptsItem;
local ScriptsMacro = Engine.ScriptsMacro;
local ScriptsMount = Engine.ScriptsMount;
local ScriptsMountFavorite = Engine.ScriptsMountFavorite;
local ScriptsBattlePet = Engine.ScriptsBattlePet;
local ScriptsFlyout = Engine.ScriptsFlyout;
local ScriptsEquipmentSet = Engine.ScriptsEquipmentSet;



--[[------------------------------------------------
	SetAction
--------------------------------------------------
function Methods.SetStoredState(BFButton, StoredState)
	if (StoredState == nil) then
		StoredState = {};
	end
	Util.TableAddUnsetKeys(StoredState, S.ButtonDefaults);
	BFButton.StoredState = StoredState;
	
	Core.ReportEvent(BFButton, C.EVENT_STOREDSTATE);
	
	Methods.SetAction(BFButton, StoredState.Action);
	Methods.SetFlyoutDirection(BFButton, StoredState.FlyoutDirection);
	Methods.SetKeyBindText(BFButton, StoredState.KeyBindText);
	Methods.SetEnabled(BFButton, StoredState.Enabled);
	Methods.SetRespondsToMouse(BFButton, StoredState.RespondsToMouse);
	Methods.SetAlpha(BFButton, StoredState.Alpha);
	Methods.SetLocked(BFButton, StoredState.Locked);
	Methods.SetAlwaysShowGrid(BFButton, StoredState.AlwaysShowGrid);
	Methods.SetShowTooltip(BFButton, StoredState.ShowTooltip);
	Methods.SetShowKeyBindText(BFButton, StoredState.ShowKeyBindText);
	Methods.SetShowCounts(BFButton, StoredState.ShowCounts);
	Methods.SetShowMacroName(BFButton, StoredState.ShowMacroName);

end
function Methods.GetStoredState(BFButton)
	return BFButton.StoredState;
end
]]

--[[------------------------------------------------
	Set/GetFlyoutDirection
	Notes:
		* Non Combat Only
--------------------------------------------------]]
function Methods.SetFlyoutDirection(BFButton, Direction)
	BFButton.FlyoutDirection = Direction;
	if (BFButton.ABW:GetAttribute("flyoutDirection") ~= Direction) then
		BFButton.ABW:SetAttribute("flyoutDirection", Direction);
		SpellFlyout:Hide();
		if (BFButton.Type == "flyout") then
			BFButton:FullUpdate();
		end
	end

	Core.ReportEvent(BFButton, C.EVENT_FLYOUTDIRECTION, Direction);
end
function Methods.GetFlyoutDirection(BFButton)
	return BFButton.FlyoutDirection;
end


--[[------------------------------------------------
	MouseOverFlyoutDirectionUI
	Notes:
		* Non Combat Only
--------------------------------------------------]]
function Methods.MouseOverFlyoutDirectionUI(BFButton, Enable)
	BFButton.MouseOverFlyoutDirectionUI = Enable or false;
	--Core.SetupEnterLeaveHandlers(BFButton);
	FlyoutUI.DetachFlyoutUI();
	if (Enable and GetMouseFocus() == BFButton.ABW) then
		FlyoutUI.AttachFlyoutUI(BFButton);
	end
end


--[[------------------------------------------------
	Set/GetKeyBindText
--------------------------------------------------]]
function Methods.SetKeyBindText(BFButton, KeyBindText)
	local HotKey = BFButton.ABWHotKey;
	BFButton.KeyBindText = KeyBindText;
	if (KeyBindText == "" or KeyBindText == nil) then
		HotKey:SetText(RANGE_INDICATOR);
		HotKey:Hide();
	else
		HotKey:SetText(KeyBindText);
		HotKey:Show();
	end
	
	BFButton:UpdateRangeRegistration();

	Core.ReportEvent(BFButton, C.EVENT_KEYBINDTEXT, KeyBindText);
	
end
function Methods.GetKeyBindText(BFButton)
	return BFButton.KeyBindText;
end


--[[------------------------------------------------
	Set/GetEnabled
	Notes:
		* Non Combat Only
--------------------------------------------------]]
function Methods.SetEnabled(BFButton, Enabled)
	BFButton.Enabled = Enabled;
	
	if (Enabled) then
		Core.UpdateButtonShowHide(BFButton);
		BFButton:FullUpdate();
	else
		Core.ReleaseTempButtonResources(BFButton);
		BFButton.ABW:Hide();
	end
	--[[
	if (BFButton.Enabled and (BFButton.AlwaysShowGrid or BFButton.Type == "empty")) then
		BFButton.ABW:Show();
		BFButton:FullUpdate();
	else
		Core.ReleaseTempButtonResources(BFButton);
		BFButton.ABW:Hide();
	end
	]]
	
	Core.ReportEvent(BFButton, C.EVENT_ENABLED, Enabled);

end
function Methods.GetEnabled(BFButton)
	return BFButton.Enabled;
end


--[[------------------------------------------------
	Set/GetRespondsToMouse
	Notes:
		* Non Combat Only
--------------------------------------------------]]
function Methods.SetRespondsToMouse(BFButton, RespondsToMouse)
	BFButton.RespondsToMouse = RespondsToMouse;
	BFButton.ABW:EnableMouse(RespondsToMouse);
	
	Core.ReportEvent(BFButton, C.EVENT_RESPONDSTOMOUSE, RespondsToMouse);
	
end
function Methods.SetRespondsToMouse(BFButton)
	return BFButton.RespondsToMouse;
end


--[[------------------------------------------------
	Set/GetAlpha
--------------------------------------------------]]
function Methods.SetAlpha(BFButton, Alpha)
	BFButton.Alpha = Alpha;	
	BFButton.ABW:SetAlpha(Alpha);
	Core.ReportEvent(BFButton, C.EVENT_ALPHA, Alpha);

end
function Methods.GetAlpha(BFButton)
	return BFButton.Alpha;
end


--[[------------------------------------------------
	Set/GetLocked
--------------------------------------------------]]
function Methods.SetLocked(BFButton, Locked)
	BFButton.Locked = Locked;
	Core.ReportEvent(BFButton, C.EVENT_LOCKED, Locked);
end
function Methods.GetLocked(BFButton)
	return BFButton.Locked;
end
	

--[[------------------------------------------------
	Set/GetAlwaysShowGrid
	Notes:
		* Non Combat Only
--------------------------------------------------]]
function Methods.SetAlwaysShowGrid(BFButton, AlwaysShowGrid)
	BFButton.AlwaysShowGrid = AlwaysShowGrid;
	
	Core.UpdateButtonShowHide(BFButton);
	
	--[[
	if (BFButton.Enabled and (AlwaysShowGrid or BFButton.Type ~= "empty")) then
		BFButton.ABW:Show();
	else
		BFButton.ABW:Hide();
	end
	Core.UpdateOnCombatHideRegistration(BFButton);
	]]
	Core.ReportEvent(BFButton, C.EVENT_ALWAYSSHOWGRID, AlwaysShowGrid);
end
function Methods.GetAlwaysShowGrid(BFButton)
	return BFButton.AlwaysShowGrid;
end


--[[------------------------------------------------
	Set/GetShowTooltip
--------------------------------------------------]]
function Methods.SetShowTooltip(BFButton, ShowTooltip)
	BFButton.ShowTooltip = ShowTooltip;
	Core.ReportEvent(BFButton, C.EVENT_SHOWTOOLTIP, ShowTooltip);
end
function Methods.GetShowTooltip(BFButton)
	return BFButton.ShowTooltip;
end


--[[------------------------------------------------
	Set/GetShowKeyBindText
--------------------------------------------------]]
function Methods.SetShowKeyBindText(BFButton, ShowKeyBindText)
	BFButton.ShowKeyBindText = ShowKeyBindText;
	Core.ReportEvent(BFButton, C.EVENT_SHOWKEYBINDTEXT, ShowKeyBindText);
end
function Methods.GetShowKeyBindText(BFButton)
	return BFButton.ShowKeyBindText;
end


--[[------------------------------------------------
	Set/GetShowCounts
--------------------------------------------------]]
function Methods.SetShowCounts(BFButton, ShowCounts)
	BFButton.ShowCounts = ShowCounts;
	Core.ReportEvent(BFButton, C.EVENT_SHOWCOUNTS, ShowCounts);
end
function Methods.GetShowCounts(BFButton)
	return BFButton.ShowCounts;
end


--[[------------------------------------------------
	Set/GetShowMacroName
--------------------------------------------------]]
function Methods.SetShowMacroName(BFButton, ShowMacroName)
	BFButton.ShowMacroName = ShowMacroName;
	Core.ReportEvent(BFButton, C.EVENT_SHOWMACRONAME, ShowMacroName);
end
function Methods.GetShowMacroName(BFButton)
	return BFButton.ShowMacroName;
end

	
--[[------------------------------------------------
	SetAction
--------------------------------------------------]]
function Methods.SetAction(BFButton, Action, LinkActionTable)
	local Type = Action.Type;
	if (LinkActionTable) then
		BFButton.Action = Action;
	end
	
	if		(Type == "spell")				then return Methods.SetActionSpell(			BFButton, Action.SpellID);
	elseif	(Type == "item")				then return Methods.SetActionItem(				BFButton, Action.ItemID);
	elseif	(Type == "macro")				then return Methods.SetActionMacro(			BFButton, Action.MacroIndex, Action.MacroName, Action.MacroBody);
	elseif	(Type == "mount")				then return Methods.SetActionMount(			BFButton, Action.MountID);
	elseif	(Type == "favoritemount")		then return Methods.SetActionMountFavorite(			BFButton);
	elseif	(Type == "battlepet")			then return Methods.SetActionBattlePet(		BFButton, Action.BattlePetGUID, Action.BattlePetSpeciesName, Action.BattlePetName);
	elseif	(Type == "flyout")				then return Methods.SetActionFlyout(			BFButton, Action.FlyoutID);
	elseif	(Type == "equipmentset")		then return Methods.SetActionEquipmentSet(		BFButton, Action.EquipmentSetName, Action.EquipmentSetID);
	elseif	(Type == "empty")				then return Methods.SetActionEmpty(			BFButton);
	elseif	(Type == nil)					then return Methods.SetActionEmpty(			BFButton);
	else										 return C.ERROR_UNRECOGNISED_ACTION;
	end
end
function Methods.GetAction(BFButton)
	return BFButton.Action;
end


--[[------------------------------------------------
	SetActionEmpty
--------------------------------------------------]]
function Methods.SetActionEmpty(BFButton)

	if (BFButton.Type ~= "empty") then

		BFButton.UpdateAction				= Scripts.EmptyF;
		BFButton.FullUpdate					= Scripts.EmptyF;
		BFButton.UpdateIcon					= Scripts.EmptyF;
		BFButton.UpdateChecked				= Scripts.EmptyChecked;
		BFButton.UpdateUsable				= Scripts.EmptyF;
		BFButton.UpdateCooldown				= Scripts.EmptyF;
		BFButton.UpdateEquipped				= Scripts.EmptyF;
		BFButton.UpdateText					= Scripts.EmptyF;
		BFButton.UpdateGlow					= Scripts.EmptyF;
		BFButton.UpdateShine				= Scripts.EmptyF;
		BFButton.UpdateMacro				= Scripts.EmptyF;
		BFButton.GetCursor					= Scripts.EmptyF;
		BFButton.UpdateFlashRegistration	= Scripts.EmptyF;
		BFButton.UpdateRangeRegistration	= Scripts.EmptyF;
		BFButton.CheckRange					= Scripts.EmptyF;
		BFButton.SwapActionWithButtonAction	= Scripts.SwapActionWithButtonAction;
		BFButton.ABW.UpdateTooltip			= Scripts.EmptyF;
		
		Core.ScrubActionValues(BFButton);
		Core.ScrubActionAttributeValues(BFButton);
		BFButton.Type = "empty";
		
		Core.ResetDisplayState(BFButton);
		Core.UpdateButtonShowHide(BFButton);
		--Core.UpdateOnCombatHideRegistration(BFButton);
		
	end
	
	local Action = BFButton.Action;
	Util.ClearTable(Action);
	Action.Type = "empty";
	Core.ReportEvent(BFButton, C.EVENT_SETACTION, Action);
	
end


--[[------------------------------------------------
	Set Spell
	Notes:
		* WoW v7 (13-Aug-2016)
			* Some Spells can share the same name
				* E.g. Shaman Hex's
			* Talents do not seem to be castable from SpellID
--------------------------------------------------]]
function Methods.SetActionSpell(BFButton, SpellID)

	if (not SpellID) then
		return Methods.SetActionEmpty(BFButton);
	end

	if (BFButton.Type ~= "spell") then
	
		BFButton.UpdateAction				= ScriptsSpell.UpdateAction;
		BFButton.FullUpdate					= ScriptsSpell.FullUpdate;
		BFButton.UpdateIcon					= ScriptsSpell.UpdateIcon;
		BFButton.UpdateChecked				= ScriptsSpell.UpdateChecked;
		BFButton.UpdateUsable				= ScriptsSpell.UpdateUsable;
		BFButton.UpdateCooldown 			= ScriptsSpell.UpdateCooldown;
		BFButton.UpdateEquipped 			= Scripts.EmptyF;
		BFButton.UpdateText					= ScriptsSpell.UpdateText;
		BFButton.UpdateGlow					= ScriptsSpell.UpdateGlow;
		BFButton.UpdateShine				= Scripts.EmptyF;
		BFButton.UpdateMacro				= Scripts.EmptyF;
		BFButton.GetCursor					= ScriptsSpell.GetCursor;
		BFButton.UpdateFlashRegistration	= ScriptsSpell.UpdateFlashRegistration;
		BFButton.UpdateRangeRegistration	= ScriptsSpell.UpdateRangeRegistration;
		BFButton.CheckRange					= ScriptsSpell.CheckRange;
		BFButton.ABW.UpdateTooltip			= ScriptsSpell.UpdateTooltip;
		BFButton.SwapActionWithButtonAction	= Scripts.SwapActionWithButtonAction;
		
		Core.ScrubActionValues(BFButton);
		Core.ScrubActionAttributeValues(BFButton);
		BFButton.Type = "spell";
		Core.UpdateButtonShowHide(BFButton);
		--Core.UpdateOnCombatHideRegistration(BFButton);
		
	end
	
	BFButton.SpellID		= SpellID;
	BFButton.SpellFullName	= Util.SpellFullName(SpellID);
	BFButton.Target			= "target";

	BFButton.ABW:SetAttribute("type", "spell");
	if (Util.IsSpellTalent(SpellID)) then
		BFButton.ABW:SetAttribute("spell", BFButton.SpellFullName);
	else
		BFButton.ABW:SetAttribute("spell", SpellID);
	end
	Core.ResetDisplayState(BFButton);
	
	local Action = BFButton.Action;
	Util.ClearTable(Action);
	Action.Type = "spell";
	Action.SpellID = SpellID;
	Action.SpellFullName = BFButton.SpellFullName;
	Core.ReportEvent(BFButton, C.EVENT_SETACTION, Action);
	BFButton:UpdateAction();
	BFButton:FullUpdate();
	
end


--[[------------------------------------------------
	Set Item
--------------------------------------------------]]
function Methods.SetActionItem(BFButton, ItemID)
	
	if (not ItemID) then
		return Methods.SetActionEmpty(BFButton);
	end
	
	if (BFButton.Type ~= "item") then
	
		BFButton.UpdateAction				= ScriptsItem.UpdateAction;
		BFButton.FullUpdate					= ScriptsItem.FullUpdate;
		BFButton.UpdateIcon					= Scripts.EmptyF;
		BFButton.UpdateChecked				= ScriptsItem.UpdateChecked;
		BFButton.UpdateUsable				= ScriptsItem.UpdateUsable;
		BFButton.UpdateCooldown				= ScriptsItem.UpdateCooldown;
		BFButton.UpdateEquipped				= ScriptsItem.UpdateEquipped;
		BFButton.UpdateText					= ScriptsItem.UpdateText;
		BFButton.UpdateGlow					= Scripts.EmptyF;
		BFButton.UpdateShine				= Scripts.EmptyF;
		BFButton.UpdateMacro				= Scripts.EmptyF;
		BFButton.GetCursor					= ScriptsItem.GetCursor;
		BFButton.UpdateFlashRegistration	= Scripts.EmptyF;
		BFButton.UpdateRangeRegistration	= ScriptsItem.UpdateRangeRegistration;
		BFButton.CheckRange					= ScriptsItem.CheckRange;
		BFButton.ABW.UpdateTooltip			= ScriptsItem.UpdateTooltip;
		BFButton.SwapActionWithButtonAction	= Scripts.SwapActionWithButtonAction;
			
		Core.ScrubActionValues(BFButton);
		Core.ScrubActionAttributeValues(BFButton);
		BFButton.Type = "item";
		Core.UpdateButtonShowHide(BFButton);
		--Core.UpdateOnCombatHideRegistration(BFButton);
		
	end
	
	local ItemName, ItemLink = GetItemInfo(ItemID);
	BFButton.ItemID		= ItemID;
	BFButton.ItemName	= ItemName;
	BFButton.ItemLink	= ItemLink;

	BFButton.ABW:SetAttribute("type", "item");
	BFButton.ABW:SetAttribute("item", ItemName);
	Core.ResetDisplayState(BFButton);

	local Action = BFButton.Action;
	Util.ClearTable(Action);
	Action.Type = "item";
	Action.ItemID = ItemID;
	Action.ItemName = BFButton.ItemName;
	Action.ItemLink = BFButton.ItemLink;
	Core.ReportEvent(BFButton, C.EVENT_SETACTION, Action);
	BFButton:UpdateAction();
	BFButton:FullUpdate();

end


--[[------------------------------------------------
	Set Macro
--------------------------------------------------]]
function Methods.SetActionMacro(BFButton, MacroIndex, MacroName, MacroBody)
	
	if (not (MacroIndex and MacroName and MacroBody)) then
		return Methods.SetActionEmpty(BFButton);
	end
	
	if (BFButton.Type ~= "macro") then
	
		BFButton.UpdateAction				= ScriptsMacro.UpdateAction;
		BFButton.FullUpdate					= ScriptsMacro.FullUpdate;
		BFButton.UpdateIcon					= ScriptsMacro.UpdateIcon;
		BFButton.UpdateChecked				= ScriptsMacro.UpdateChecked;
		BFButton.UpdateUsable				= ScriptsMacro.UpdateUsable;
		BFButton.UpdateCooldown				= ScriptsMacro.UpdateCooldown;
		BFButton.UpdateEquipped				= ScriptsMacro.UpdateEquipped;
		BFButton.UpdateText					= ScriptsMacro.UpdateText;
		BFButton.UpdateGlow					= ScriptsMacro.UpdateGlow;
		BFButton.UpdateShine				= Scripts.EmptyF;
		BFButton.UpdateMacro				= ScriptsMacro.UpdateMacro;
		BFButton.GetCursor					= ScriptsMacro.GetCursor;
		BFButton.UpdateFlashRegistration	= ScriptsMacro.UpdateFlashRegistration;
		BFButton.UpdateRangeRegistration	= ScriptsMacro.UpdateRangeRegistration;
		BFButton.CheckRange					= ScriptsMacro.CheckRange;
		BFButton.ABW.UpdateTooltip			= ScriptsMacro.UpdateTooltip;
		BFButton.SwapActionWithButtonAction	= Scripts.SwapActionWithButtonAction;
		
		Core.ScrubActionValues(BFButton);
		Core.ScrubActionAttributeValues(BFButton);
		BFButton.Type = "macro";
		Core.UpdateButtonShowHide(BFButton);
		--Core.UpdateOnCombatHideRegistration(BFButton);
		
	end

	BFButton.MacroIndex	= MacroIndex;
	BFButton.MacroName	= MacroName;
	BFButton.MacroBody	= MacroBody;
	
	BFButton.ABW:SetAttribute("type", "macro");
	BFButton.ABW:SetAttribute("macro", MacroIndex);
	Core.ResetDisplayState(BFButton);
	
	local Action = BFButton.Action;
	Util.ClearTable(Action);
	Action.Type = "macro";
	Action.MacroIndex = MacroIndex;
	Action.MacroName = BFButton.MacroName;
	Action.MacroBody = BFButton.MacroBody;
	Core.ReportEvent(BFButton, C.EVENT_SETACTION, Action);
	BFButton:UpdateAction();
	BFButton:FullUpdate();

end


--[[------------------------------------------------
	Set Mount
--------------------------------------------------]]
function Methods.SetActionMount(BFButton, MountID)
	
	if (not MountID) then
		return Methods.SetActionEmpty(BFButton);
	end
	
	if (MountID == C.SUMMON_RANDOM_FAVORITE_MOUNT_ID) then
		-- It's the random favorite button, use a different code path
		return Methods.SetActionMountFavorite(BFButton);
	end

	if (BFButton.Type ~= "mount") then
	
		BFButton.UpdateAction				= Scripts.EmptyF;
		BFButton.FullUpdate					= ScriptsMount.FullUpdate;
		BFButton.UpdateIcon					= ScriptsMount.UpdateIcon;
		BFButton.UpdateChecked				= ScriptsMount.UpdateChecked;
		BFButton.UpdateUsable				= ScriptsMount.UpdateUsable;
		BFButton.UpdateCooldown				= Scripts.EmptyF;
		BFButton.UpdateEquipped				= Scripts.EmptyF;
		BFButton.UpdateText					= Scripts.EmptyF;
		BFButton.UpdateGlow					= Scripts.EmptyF;
		BFButton.UpdateShine				= Scripts.EmptyF;
		BFButton.UpdateMacro				= Scripts.EmptyF;
		BFButton.GetCursor					= ScriptsMount.GetCursor;
		BFButton.UpdateFlashRegistration	= Scripts.EmptyF;
		BFButton.UpdateRangeRegistration	= Scripts.EmptyF;
		BFButton.CheckRange					= Scripts.EmptyF;
		BFButton.ABW.UpdateTooltip			= ScriptsMount.UpdateTooltip;
		BFButton.SwapActionWithButtonAction	= Scripts.SwapActionWithButtonAction;
		
		Core.ScrubActionValues(BFButton);
		Core.ScrubActionAttributeValues(BFButton);
		BFButton.Type = "mount";
		Core.UpdateButtonShowHide(BFButton);
		--Core.UpdateOnCombatHideRegistration(BFButton);
		
	end
	
	BFButton.MountID		= MountID;
	BFButton.MountSpellID	= select(2, C_MountJournal.GetMountInfoByID(MountID));
	BFButton.MountName		= C_MountJournal.GetMountInfoByID(MountID);
	
	local SpellFullName = Util.SpellFullName(BFButton.MountSpellID);
	BFButton.ABW:SetAttribute("type", "spell");
	BFButton.ABW:SetAttribute("spell", SpellFullName);
	Core.ResetDisplayState(BFButton);
	
	local Action = BFButton.Action;
	Util.ClearTable(Action);
	Action.Type = "mount";
	Action.MountID = MountID;
	Action.MountSpellID = BFButton.MountSpellID;
	Action.MountName = BFButton.MountName;
	Core.ReportEvent(BFButton, C.EVENT_SETACTION, Action);
	BFButton:UpdateAction();
	BFButton:FullUpdate();

end


--[[------------------------------------------------
	Set Mount Favorite
--------------------------------------------------]]
function Methods.SetActionMountFavorite(BFButton)

	if (BFButton.Type ~= "favoritemount") then
	
		BFButton.UpdateAction				= Scripts.EmptyF;
		BFButton.FullUpdate					= ScriptsMountFavorite.FullUpdate;
		BFButton.UpdateIcon					= ScriptsMountFavorite.UpdateIcon;
		BFButton.UpdateChecked				= ScriptsMountFavorite.UpdateChecked;
		BFButton.UpdateUsable				= ScriptsMountFavorite.UpdateUsable;
		BFButton.UpdateCooldown				= Scripts.EmptyF;
		BFButton.UpdateEquipped				= Scripts.EmptyF;
		BFButton.UpdateText					= Scripts.EmptyF;
		BFButton.UpdateGlow					= Scripts.EmptyF;
		BFButton.UpdateShine				= Scripts.EmptyF;
		BFButton.UpdateMacro				= Scripts.EmptyF;
		BFButton.GetCursor					= ScriptsMountFavorite.GetCursor;
		BFButton.UpdateFlashRegistration	= Scripts.EmptyF;
		BFButton.UpdateRangeRegistration	= Scripts.EmptyF;
		BFButton.CheckRange					= Scripts.EmptyF;
		BFButton.ABW.UpdateTooltip			= ScriptsMountFavorite.UpdateTooltip;
		BFButton.SwapActionWithButtonAction	= Scripts.SwapActionWithButtonAction;
	
		Core.ScrubActionValues(BFButton);
		Core.ScrubActionAttributeValues(BFButton);
		BFButton.Type = "favoritemount";
		Core.UpdateButtonShowHide(BFButton);
		--Core.UpdateOnCombatHideRegistration(BFButton);
		
		BFButton.MountID		= C.SUMMON_RANDOM_FAVORITE_MOUNT_ID;
		BFButton.MountSpellID	= C.SUMMON_RANDOM_FAVORITE_MOUNT_SPELL;
		BFButton.MountName		= GetSpellInfo(BFButton.MountSpellID);
		if (IsAddOnLoaded("Blizzard_Collections")) then
			LoadAddOn("Blizzard_Collections");
		end
		BFButton.ABW:SetAttribute("type", "click");
		BFButton.ABW:SetAttribute("clickbutton", MountJournalSummonRandomFavoriteButton);
		Core.ResetDisplayState(BFButton);

	end
	
	local Action = BFButton.Action;
	Util.ClearTable(Action);
	Action.Type = "favoritemount";
	Action.MountID = MountID;
	Action.MountSpellID = BFButton.MountSpellID;
	Action.MountName = BFButton.MountName;
	Core.ReportEvent(BFButton, C.EVENT_SETACTION, Action);
	BFButton:UpdateAction();
	BFButton:FullUpdate();
	
end


--[[------------------------------------------------
	Set Battle Pet
--------------------------------------------------]]
function Methods.SetActionBattlePet(BFButton, BattlePetGUID)
	
	if (not BattlePetGUID) then
		return Methods.SetActionEmpty(BFButton);
	end
	
	if (BFButton.Type ~= "battlepet") then
	
		BFButton.UpdateAction				= ScriptsBattlePet.UpdateAction;
		BFButton.FullUpdate					= ScriptsBattlePet.FullUpdate;
		BFButton.UpdateIcon					= ScriptsBattlePet.UpdateIcon;
		BFButton.UpdateChecked				= ScriptsBattlePet.UpdateChecked;
		BFButton.UpdateUsable				= ScriptsBattlePet.UpdateUsable;
		BFButton.UpdateCooldown				= ScriptsBattlePet.UpdateCooldown;
		BFButton.UpdateEquipped				= Scripts.EmptyF;
		BFButton.UpdateText					= Scripts.EmptyF;
		BFButton.UpdateGlow					= Scripts.EmptyF;
		BFButton.UpdateShine				= Scripts.EmptyF;
		BFButton.UpdateMacro				= Scripts.EmptyF;
		BFButton.GetCursor					= ScriptsBattlePet.GetCursor;
		BFButton.UpdateFlashRegistration	= Scripts.EmptyF;
		BFButton.UpdateRangeRegistration	= Scripts.EmptyF;
		BFButton.CheckRange					= Scripts.EmptyF;
		BFButton.ABW.UpdateTooltip			= ScriptsBattlePet.UpdateTooltip;
		BFButton.SwapActionWithButtonAction	= Scripts.SwapActionWithButtonAction;
	
		Core.ScrubActionValues(BFButton);
		Core.ScrubActionAttributeValues(BFButton);
		BFButton.Type = "battlepet";
		Core.UpdateButtonShowHide(BFButton);
		--Core.UpdateOnCombatHideRegistration(BFButton);
		
	end
	
	local speciesID, customName, level, xp, maxXp
		, displayID, isFavorite, name = C_PetJournal.GetPetInfoByPetID(BattlePetGUID);
	BFButton.BattlePetGUID	= BattlePetGUID;
	BFButton.BattlePetSpeciesName = name;
	BFButton.BattlePetName = customName or name;
	
	BFButton.ABW:SetAttribute("type", "macro");
	BFButton.ABW:SetAttribute("macrotext", "/summonpet "..BattlePetGUID);
	Core.ResetDisplayState(BFButton);
	
	local Action = BFButton.Action;
	Util.ClearTable(Action);
	Action.Type = "battlepet";
	Action.BattlePetGUID = BattlePetGUID;
	Action.BattlePetName = BFButton.BattlePetName;
	Action.BattlePetSpeciesName = BFButton.BattlePetSpeciesName;
	Core.ReportEvent(BFButton, C.EVENT_SETACTION, Action);		
	BFButton:UpdateAction();
	BFButton:FullUpdate();

end


--[[------------------------------------------------
	Set Flyout
--------------------------------------------------]]
function Methods.SetActionFlyout(BFButton, FlyoutID)
	
	if (not FlyoutID) then
		return Methods.SetActionEmpty(BFButton);
	end
	
	if (BFButton.Type ~= "flyout") then
	
		BFButton.UpdateAction				= ScriptsFlyout.UpdateAction;	
		BFButton.FullUpdate					= ScriptsFlyout.FullUpdate;
		BFButton.UpdateIcon					= Scripts.EmptyF;
		BFButton.UpdateChecked				= Scripts.EmptyChecked;
		BFButton.UpdateUsable				= Scripts.EmptyF;
		BFButton.UpdateCooldown				= Scripts.EmptyF;
		BFButton.UpdateEquipped				= Scripts.EmptyF;
		BFButton.UpdateText					= Scripts.EmptyF;
		BFButton.UpdateGlow					= Scripts.EmptyF;
		BFButton.UpdateShine				= Scripts.EmptyF;
		BFButton.UpdateMacro				= Scripts.EmptyF;
		BFButton.GetCursor					= ScriptsFlyout.GetCursor;
		BFButton.UpdateFlashRegistration	= Scripts.EmptyF;
		BFButton.UpdateRangeRegistration	= Scripts.EmptyF;
		BFButton.CheckRange					= Scripts.EmptyF;
		BFButton.ABW.UpdateTooltip			= ScriptsFlyout.UpdateTooltip;
		BFButton.SwapActionWithButtonAction	= Scripts.SwapActionWithButtonAction;	
	
		Core.ScrubActionValues(BFButton);
		Core.ScrubActionAttributeValues(BFButton);
		BFButton.Type = "flyout";
		Core.UpdateButtonShowHide(BFButton);
		--Core.UpdateOnCombatHideRegistration(BFButton);
		
	end
	
	BFButton.FlyoutID = FlyoutID;
	BFButton.FlyoutName, BFButton.FlyoutDescription = GetFlyoutInfo(FlyoutID);

	BFButton.ABW:SetAttribute("type", "flyout");
	BFButton.ABW:SetAttribute("spell", BFButton.FlyoutID);
	Core.ResetDisplayState(BFButton);
	
	local Action = BFButton.Action;
	Util.ClearTable(Action);
	Action.Type = "flyout";
	Action.FlyoutID = FlyoutID;
	Action.FlyoutName = BFButton.FlyoutName;
	Action.FlyoutDescription = BFButton.FlyoutDescription;
	Core.ReportEvent(BFButton, C.EVENT_SETACTION, Action);
	BFButton:UpdateAction();
	BFButton:FullUpdate();
	
end


--[[------------------------------------------------
	Set EquipmentSet
	Notes:
		* EquipmentSetID is optional (will be there probably when
			set from Action structure
--------------------------------------------------]]
function Methods.SetActionEquipmentSet(BFButton, EquipmentSetName)

	if (not EquipmentSetName) then
		return Methods.SetActionEmpty(BFButton);
	end
	
	if (BFButton.Type ~= "equipmentset") then
	
		BFButton.UpdateAction				= ScriptsEquipmentSet.UpdateAction;
		BFButton.FullUpdate					= ScriptsEquipmentSet.FullUpdate;
		BFButton.UpdateIcon					= Scripts.EmptyF;
		BFButton.UpdateChecked				= Scripts.EmptyChecked;
		BFButton.UpdateUsable				= ScriptsEquipmentSet.UpdateUsable;
		BFButton.UpdateCooldown				= Scripts.EmptyF;
		BFButton.UpdateEquipped				= Scripts.EmptyF;
		BFButton.UpdateText					= ScriptsEquipmentSet.UpdateText;
		BFButton.UpdateGlow					= Scripts.EmptyF;
		BFButton.UpdateShine				= Scripts.EmptyF;
		BFButton.UpdateMacro				= Scripts.EmptyF;
		BFButton.GetCursor					= ScriptsEquipmentSet.GetCursor;
		BFButton.UpdateFlashRegistration	= Scripts.EmptyF;
		BFButton.UpdateRangeRegistration	= Scripts.EmptyF;
		BFButton.CheckRange					= Scripts.EmptyF;
		BFButton.ABW.UpdateTooltip			= ScriptsEquipmentSet.UpdateTooltip;
		BFButton.SwapActionWithButtonAction	= Scripts.SwapActionWithButtonAction;
	
		Core.ScrubActionValues(BFButton);
		Core.ScrubActionAttributeValues(BFButton);
		BFButton.Type = "equipmentset";
		Core.UpdateButtonShowHide(BFButton);
		--Core.UpdateOnCombatHideRegistration(BFButton);
		
	end

	BFButton.EquipmentSetName = EquipmentSetName;
	BFButton.EquipmentSetID = select(2, GetEquipmentSetInfoByName(EquipmentSetName));
	--BFButton.EquipmentSetUsable = true;
	BFButton.ABW:SetAttribute("type", "macro");
	BFButton.ABW:SetAttribute("macrotext", "/equipset "..EquipmentSetName);
	Core.ResetDisplayState(BFButton);	

	local Action = BFButton.Action;
	Util.ClearTable(Action);
	Action.Type = "equipmentset";
	Action.EquipmentSetName = EquipmentSetName;
	Action.EquipmentSetID = BFButton.EquipmentSetID;

	Core.ReportEvent(BFButton, C.EVENT_SETACTION, Action);
	BFButton:UpdateAction();
	BFButton:FullUpdate();
	
end

