--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local ScriptsItem = Engine.ScriptsItem;

local Core = Engine.Core;
local Util = Engine.Util;
local C = Engine.Constants;
local Events = Engine.Events


--[[------------------------------------------------
	UpdateAction
--------------------------------------------------]]
function ScriptsItem.UpdateAction(BFButton)
	local ItemName, ItemLink = GetItemInfo(BFButton.ItemID);

	if (not ItemName) then
		-- Ironically this test does not help, but I will leave it in just in case!
		Events.WatchForItemInfoEvent();
	end
	if (BFButton.ItemName ~= ItemName) then
		local Action = BFButton.Action;
		BFButton.ItemName	= ItemName;
		BFButton.ItemLink	= ItemLink;
		Action.ItemName = BFButton.ItemName;
		Action.ItemLink = BFButton.ItemLink;
		BFButton.ABW:SetAttribute("item", ItemName);
		Core.ReportEvent(BFButton, C.EVENT_UPDATEACTION, Action);
	end
end


--[[------------------------------------------------
	Full Update
--------------------------------------------------]]
function ScriptsItem.FullUpdate(BFButton)
	BFButton.IconTexture = GetItemIcon(BFButton.ItemID) or C.QUESTION_MARK;				--safe no matter what
	BFButton.ABWIcon:SetTexture(BFButton.IconTexture);
	BFButton:UpdateChecked();
	BFButton:UpdateUsable();
	BFButton:UpdateCooldown();
	BFButton:UpdateText();
	BFButton:UpdateRangeRegistration();
	
	if (GetMouseFocus() == BFButton.ABW) then
		BFButton.ABW:UpdateTooltip();
	end
end


--[[------------------------------------------------
	Checked
--------------------------------------------------]]
function ScriptsItem.UpdateChecked(BFButton)
    if (IsCurrentItem(BFButton.ItemID)) then
		BFButton.ABW:SetChecked(true);
	else
		BFButton.ABW:SetChecked(false);
	end
end


--[[------------------------------------------------
	Equipped
--------------------------------------------------]]
function ScriptsItem.UpdateEquipped(BFButton)
	if (IsEquippedItem(BFButton.ItemID)) then
		BFButton.ABWBorder:SetVertexColor(0, 1.0, 0, 0.35);
		BFButton.ABWBorder:Show();
	else
		BFButton.ABWBorder:Hide();
	end
end


--[[------------------------------------------------
	Usable
--------------------------------------------------]]
function ScriptsItem.UpdateUsable(BFButton)
	Core.UpdateButtonUsable(BFButton, IsUsableItem(BFButton.ItemID));
end


--[[------------------------------------------------
	Cooldown
--------------------------------------------------]]
function ScriptsItem.UpdateCooldown(BFButton)
	CooldownFrame_Set(BFButton.ABWCooldown, GetItemCooldown(BFButton.ItemID));
end


--[[------------------------------------------------
	Text	(Charges, or Counts)
--------------------------------------------------]]
function ScriptsItem.UpdateText(BFButton)
	local Count = GetItemCount(BFButton.ItemID, false, true);
	if (Count > 1 or IsConsumableItem(BFButton.ItemID)) then
		BFButton.ABWCount:SetText(Count);
		return;
	end
	BFButton.ABWCount:SetText(nil);
end


--[[------------------------------------------------
	Tooltip
--------------------------------------------------]]
function ScriptsItem.UpdateTooltip(ABW)
	local InventorySlot = Util.LookupItemInventorySlot(ABW.BFButton.ItemID);
	if (InventorySlot) then
		GameTooltip_SetDefaultAnchor(GameTooltip, ABW);
		GameTooltip:SetInventoryItem("player", InventorySlot);
	else
		local Bag, Slot = Util.LookupItemBagSlot(ABW.BFButton.ItemID);
		if (Bag) then
			GameTooltip_SetDefaultAnchor(GameTooltip, ABW);
			GameTooltip:SetBagItem(Bag, Slot);
		elseif (ABW.BFButton.ItemLink) then
			GameTooltip_SetDefaultAnchor(GameTooltip, ABW);	--It appears that the sethyperlink (specifically this one) requires that the anchor be constantly refreshed!?
			GameTooltip:SetHyperlink(ABW.BFButton.ItemLink);
		end
	end
end


--[[------------------------------------------------
	Range Registration
--------------------------------------------------]]
function ScriptsItem.UpdateRangeRegistration(BFButton)
	Core.UpdateButtonRangeRegistration(BFButton, IsItemInRange(BFButton.ItemID, BFButton.Target));
end

	
--[[------------------------------------------------
	Range Check
--------------------------------------------------]]
function ScriptsItem.CheckRange(BFButton)
	Core.UpdateButtonRangeIndicator(BFButton, IsItemInRange(BFButton.ItemID, BFButton.Target));
end


--[[------------------------------------------------
	Cursor
--------------------------------------------------]]
function ScriptsItem.GetCursor(BFButton)
	return "item", BFButton.ItemID, nil, nil;
end

