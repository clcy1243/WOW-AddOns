--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local ScriptsBattlePet = Engine.ScriptsBattlePet;

local C = Engine.Constants;
local Core = Engine.Core;
local Util = Engine.Util;


--[[------------------------------------------------
	UpdateAction
--------------------------------------------------]]
function ScriptsBattlePet.UpdateAction(BFButton)

end


--[[------------------------------------------------
	Full Update
--------------------------------------------------]]
function ScriptsBattlePet.FullUpdate(BFButton)
	local speciesID, customName, level, xp, maxXp, displayID, isFavorite
		, name, icon = C_PetJournal.GetPetInfoByPetID(BFButton.BattlePetGUID);
		
	BFButton.BattlePetSpeciesName = name;
	if (BFButton.BattlePetName ~= customName or name) then
		BFButton.BattlePetName = customName or name;
		
		local Action = BFButton.Action;
		Action.BattlePetName = BFButton.BattlePetName;
		Core.ReportEvent(BFButton, C.EVENT_UPDATEACTION, Action);
	end

	BFButton.IconTexture = icon;
	BFButton.ABWIcon:SetTexture(BFButton.IconTexture);
	BFButton:UpdateChecked();
	BFButton:UpdateUsable();
	BFButton:UpdateCooldown();
	
	if (GetMouseFocus() == BFButton.ABW) then
		BFButton.ABW:UpdateTooltip();
	end
end


--[[------------------------------------------------
	Icon
--------------------------------------------------]]
function ScriptsBattlePet.UpdateIcon(BFButton)

end


--[[------------------------------------------------
	Checked
--------------------------------------------------]]
function ScriptsBattlePet.UpdateChecked(BFButton)
	if (BFButton.BattlePetGUID == C_PetJournal.GetSummonedPetGUID()) then
		BFButton.ABW:SetChecked(true);
	else
		BFButton.ABW:SetChecked(false);
	end
end


--[[------------------------------------------------
	Usable
--------------------------------------------------]]
function ScriptsBattlePet.UpdateUsable(BFButton)
	Core.UpdateButtonUsable(BFButton, C_PetJournal.PetIsSummonable(BFButton.BattlePetGUID));
end


--[[------------------------------------------------
	Cooldown
--------------------------------------------------]]
function ScriptsBattlePet.UpdateCooldown(BFButton)
	CooldownFrame_Set(BFButton.ABWCooldown, C_PetJournal.GetPetCooldownByGUID(BFButton.BattlePetGUID));
end


--[[------------------------------------------------
	Tooltip	(Copied from how the Pet Journal Shows the Tooltip)
--------------------------------------------------]]
function ScriptsBattlePet.UpdateTooltip(ABW)
	local BFButton = ABW.BFButton;
	GameTooltip_SetDefaultAnchor(GameTooltip, ABW);

	if ( BFButton.BattlePetName and BFButton.BattlePetName ~= "" ) then
		GameTooltip:SetText(BFButton.BattlePetName, 1, 1, 1);
		GameTooltip:AddLine(SPELL_CAST_TIME_INSTANT, 1, 1, 1, true);
		GameTooltip:AddLine(string.format(BATTLE_PET_TOOLTIP_SUMMON, BFButton.BattlePetSpeciesName), nil, nil, nil, true);
		GameTooltip:Show();
	end
end


--[[------------------------------------------------
	Cursor
--------------------------------------------------]]
function ScriptsBattlePet.GetCursor(BFButton)
	return "battlepet", BFButton.BattlePetGUID, nil, nil;
end

