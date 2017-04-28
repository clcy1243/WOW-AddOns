--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local ScriptsFlyout = Engine.ScriptsFlyout;

local Core = Engine.Core;
local Util = Engine.Util;
local C = Engine.Constants;


--[[------------------------------------------------
	UpdateAction
--------------------------------------------------]]
function ScriptsFlyout.UpdateAction(BFButton)

end


--[[------------------------------------------------
	Full Update
--------------------------------------------------]]
function ScriptsFlyout.FullUpdate(BFButton)
	BFButton.IconTexture = Util.LookupFlyoutTexture(BFButton.FlyoutID);
	BFButton.FlyoutName, BFButton.FlyoutDescription = GetFlyoutInfo(BFButton.FlyoutID);
	BFButton.ABWIcon:SetTexture(BFButton.IconTexture);
	--BFButton:UpdateIcon();
	BFButton:UpdateChecked();
	Core.UpdateFlyout(BFButton);
	
	if (GetMouseFocus() == BFButton.ABW) then
		BFButton.ABW:UpdateTooltip();
	end
end


--[[------------------------------------------------
	Checked
--------------------------------------------------]]
function ScriptsFlyout.UpdateChecked(BFButton)
	BFButton.ABW:SetChecked(false);
end


--[[------------------------------------------------
	Tooltip
--------------------------------------------------]]
function ScriptsFlyout.UpdateTooltip(ABW)
	local BFButton = ABW.BFButton;
	GameTooltip_SetDefaultAnchor(GameTooltip, ABW);

	if ( BFButton.FlyoutName and BFButton.FlyoutName ~= "" ) then
		GameTooltip:SetText(BFButton.FlyoutName, 1, 1, 1);
		GameTooltip:AddLine(BFButton.FlyoutDescription, nil, nil, nil, true);
		GameTooltip:Show();
	end
end


--[[------------------------------------------------
	Cursor
--------------------------------------------------]]
function ScriptsFlyout.GetCursor(BFButton)
	return "flyout", BFButton.FlyoutID, nil, nil;
end

