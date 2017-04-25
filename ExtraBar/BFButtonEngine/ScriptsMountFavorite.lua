--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local ScriptsMountFavorite = Engine.ScriptsMountFavorite;

local C = Engine.Constants;
local Core = Engine.Core;
local Util = Engine.Util;


--[[------------------------------------------------
	UpdateAction
--------------------------------------------------]]
function ScriptsMountFavorite.UpdateAction(BFButton)

end


--[[------------------------------------------------
	Full Update
--------------------------------------------------]]
function ScriptsMountFavorite.FullUpdate(BFButton)
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
function ScriptsMountFavorite.UpdateIcon(BFButton)

end


--[[------------------------------------------------
	Checked
	Notes:
		* WoW v7 (13-Aug-2016)
			* summoning any mount should check summon favorite
			* It's not possible to simply test if the player is in
			process of summoning a mount (not cheaply anyway)
--------------------------------------------------]]
function ScriptsMountFavorite.UpdateChecked(BFButton)
	if (IsMounted()) then
		BFButton.ABW:SetChecked(true);
	else
		BFButton.ABW:SetChecked(false);
	end
end


--[[------------------------------------------------
	Usable
--------------------------------------------------]]
function ScriptsMountFavorite.UpdateUsable(BFButton)
	Core.UpdateButtonUsable(BFButton, IsUsableSpell(BFButton.MountSpellID));
end


--[[------------------------------------------------
	Tooltip
--------------------------------------------------]]
function ScriptsMountFavorite.UpdateTooltip(ABW)
	GameTooltip_SetDefaultAnchor(GameTooltip, ABW);
	GameTooltip:SetMountBySpellID(ABW.BFButton.MountSpellID);
end


--[[------------------------------------------------
	Cursor
--------------------------------------------------]]
function ScriptsMountFavorite.GetCursor(BFButton)
	return "mount", BFButton.MountID, nil, nil;
end

