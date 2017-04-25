--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local ScriptsPetCommand = Engine.ScriptsPetCommand;

local Core = Engine.Core;
local Cursor = Engine.Cursor;
local Scripts = Engine.Scripts;
local Util = Engine.Util;
local UtilPet = Engine.UtilPet;

--[[------------------------------------------------
	UpdateAction
--------------------------------------------------]]
function ScriptsPetCommand.UpdateAction(BFButton)

end


--[[------------------------------------------------
	Full Update
--------------------------------------------------]]
function ScriptsPetCommand.FullUpdate(BFButton)
	BFButton.PetCommandIndex = UtilPet.GetPetCommandSpellBookIndex(BFButton.PetCommand);

	BFButton:UpdateIcon();
	BFButton:UpdateChecked();
	BFButton:UpdateUsable();
	BFButton:UpdateFlashRegistration();

	if (GetMouseFocus() == BFButton.ABW) then
		BFButton.ABW:UpdateTooltip();
	end
end


--[[------------------------------------------------
	Checked
--------------------------------------------------]]
function ScriptsPetCommand.UpdateChecked(BFButton)
	if (IsSelectedSpellBookItem(BFButton.PetCommandIndex, BOOKTYPE_PET) or (BFButton.PetCommand == "PET_ACTION_ATTACK" and IsPetAttackActive())) then
		BFButton.ABW:SetChecked(true);
	else
		BFButton.ABW:SetChecked(false);		
	end
end


--[[------------------------------------------------
	Usable
--------------------------------------------------]]
function ScriptsPetCommand.UpdateUsable(BFButton)
	Core.UpdateButtonUsable(BFButton, HasPetSpells() and PetHasSpellbook());
end


--[[------------------------------------------------
	Tooltip
--------------------------------------------------]]
function ScriptsPetCommand.UpdateTooltip(ABW)
	local BFButton = ABW.BFButton;
	GameTooltip_SetDefaultAnchor(GameTooltip, ABW);
	GameTooltip:SetText(_G[BFButton.PetCommand], 1, 1, 1);
	GameTooltip:AddLine(_G[BFButton.PetCommand.."_TOOLTIP"], nil, nil, nil, true);
	GameTooltip:Show();
end


--[[------------------------------------------------
	Flash	(registers and Deregisters for flash)
--------------------------------------------------]]
function ScriptsPetCommand.UpdateFlashRegistration(BFButton)
	local IsFlashing = BFButton.PetCommand == "PET_ACTION_ATTACK" and IsPetAttackActive();
	Core.UpdateButtonFlashRegistration(BFButton, IsFlashing);
end


function ScriptsPetCommand.GetCursor(BFButton)
	return "petcommand", BFButton.PetCommand, nil, nil;
end

