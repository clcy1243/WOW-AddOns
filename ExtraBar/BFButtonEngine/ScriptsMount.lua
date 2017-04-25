--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local ScriptsMount = Engine.ScriptsMount;

local C = Engine.Constants;
local Core = Engine.Core;
local Util = Engine.Util;


--[[------------------------------------------------
	UpdateAction
--------------------------------------------------]]
function ScriptsMount.UpdateAction(BFButton)

end


--[[------------------------------------------------
	Full Update
--------------------------------------------------]]
function ScriptsMount.FullUpdate(BFButton)
	BFButton.IconTexture = GetSpellTexture(BFButton.MountSpellID);
	BFButton.ABWIcon:SetTexture(BFButton.IconTexture);
	BFButton:UpdateIcon();
	BFButton:UpdateChecked();
	BFButton:UpdateUsable();
	
	if (GetMouseFocus() == BFButton.ABW) then
		BFButton.ABW:UpdateTooltip();
	end
end


--[[------------------------------------------------
	Icon
--------------------------------------------------]]
function ScriptsMount.UpdateIcon(BFButton)

end


--[[------------------------------------------------
	Checked
--------------------------------------------------]]
function ScriptsMount.UpdateChecked(BFButton)
	if (IsCurrentSpell(BFButton.MountSpellID)) then
		BFButton.ABW:SetChecked(true);
	else
		BFButton.ABW:SetChecked(false);
	end
end


--[[------------------------------------------------
	Usable
--------------------------------------------------]]
function ScriptsMount.UpdateUsable(BFButton)
	Core.UpdateButtonUsable(BFButton, IsUsableSpell(BFButton.MountSpellID) and (select(5, C_MountJournal.GetMountInfoByID(BFButton.MountID)) or BFButton.MountID == C.SUMMON_RANDOM_FAVORITE_MOUNT_ID));
end


--[[------------------------------------------------
	Tooltip
--------------------------------------------------]]
function ScriptsMount.UpdateTooltip(ABW)
	GameTooltip_SetDefaultAnchor(GameTooltip, ABW);
	GameTooltip:SetMountBySpellID(ABW.BFButton.MountSpellID);
end


--[[------------------------------------------------
	Cursor
--------------------------------------------------]]
function ScriptsMount.GetCursor(BFButton)
	return "mount", BFButton.MountID, nil, nil;
end

