--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local ScriptsEquipmentSet = Engine.ScriptsEquipmentSet;

local C = Engine.Constants;
local Core = Engine.Core;
local Util = Engine.Util;
local Methods = Engine.Methods;


--[[------------------------------------------------
	UpdateAction
--------------------------------------------------]]
function ScriptsEquipmentSet.UpdateAction(BFButton)
	local Index = Util.LookupEquipmentSetIndex(BFButton.EquipmentSetID);
	if (Index == nil) then
		-- This equip set is gone so clear it from the button
		return Methods.SetActionEmpty(BFButton);
	end
	
	local EquipmentSetName, IconTexture = GetEquipmentSetInfo(Index);
	BFButton.IconTexture = IconTexture;
	if (BFButton.EquipmentSetName ~= EquipmentSetName) then
		BFButton.EquipmentSetName = EquipmentSetName;
		if (string.match(BFButton.EquipmentSetName, "^%s") or string.match(BFButton.EquipmentSetName, "%s$")) then
			UIErrorsFrame:AddMessage(Util.GetLocaleString(C.WARNING_EQUIPMENTSET_NAME), 1.0, 0.1, 0.1, 1.0);
			--BFButton.EquipmentSetUsable = false;
		else
			--BFButton.EquipmentSetUsable = true;
		end
		BFButton.ABW:SetAttribute("type", "macro");
		BFButton.ABW:SetAttribute("macrotext", "/equipset "..BFButton.EquipmentSetName);
	
		local Action = BFButton.Action;
		Action.EquipmentSetName = EquipmentSetName;
		Core.ReportEvent(BFButton, C.EVENT_UPDATEACTION, Action);
	end
end


--[[------------------------------------------------
	Full Update
--------------------------------------------------]]
function ScriptsEquipmentSet.FullUpdate(BFButton)

	BFButton.ABWIcon:SetTexture(BFButton.IconTexture);
	BFButton:UpdateChecked();
	BFButton:UpdateText();
	
	if (GetMouseFocus() == BFButton.ABW) then
		BFButton.ABW:UpdateTooltip();
	end
end


--[[------------------------------------------------
	Checked
--------------------------------------------------]]
function ScriptsEquipmentSet.UpdateChecked(BFButton)
	BFButton.ABW:SetChecked(false);
end


--[[------------------------------------------------
	Usable
--------------------------------------------------]]
function ScriptsEquipmentSet.UpdateUsable(BFButton)
	Core.UpdateButtonUsable(BFButton, true);
end


--[[------------------------------------------------
	Text
--------------------------------------------------]]
function ScriptsEquipmentSet.UpdateText(BFButton)
	BFButton.ABWName:SetText(BFButton.EquipmentSetName);

end


--[[------------------------------------------------
	Tooltip
--------------------------------------------------]]
function ScriptsEquipmentSet.UpdateTooltip(ABW)
	GameTooltip_SetDefaultAnchor(GameTooltip, ABW);
	GameTooltip:SetEquipmentSet(ABW.BFButton.EquipmentSetName);
end


--[[------------------------------------------------
	Cursor
--------------------------------------------------]]
function ScriptsEquipmentSet.GetCursor(BFButton)
	return "equipmentset", BFButton.EquipmentSetName, nil, nil;
end

