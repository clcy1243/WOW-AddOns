--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local Scripts = Engine.Scripts;

local S = Engine.Settings;
local Core = Engine.Core;
local Cursor = Engine.Cursor;
local FlyoutUI = Engine.FlyoutUI;


--[[------------------------------------------------
	Handler:	OnReceiveDrag
--------------------------------------------------]]
function Scripts.OnReceiveDrag(ABW)
	if (InCombatLockdown()) then
		return;
	end

	local Command, Data, Subvalue, SubSubvalue = Cursor.GetCursor();
	if (Command) then
		ABW.BFButton:SwapActionWithButtonAction(Command, Data, Subvalue, SubSubvalue);
	end
end


--[[------------------------------------------------
	Handler:	OnDragStart
--------------------------------------------------]]
function Scripts.OnDragStart(ABW)
	if (InCombatLockdown()) then
		return;
	end
	local BFButton = ABW.BFButton;
	if (BFButton.Locked and not IsModifiedClick("PICKUPACTION")) then
		return;
	end

	BFButton:SwapActionWithButtonAction(Cursor.GetCursor());

end


--[[------------------------------------------------
	Handler:	PreClick (+ secure snippets)
--------------------------------------------------]]
Scripts.SecurePreClickUseKeyDownSnippet = [[
	if (down and button == "KeyBind") then
		return "LeftButton";
	end
	if ((not down) and button ~= "KeyBind") then
		return;
	end
	return false;
]];
Scripts.SecurePreClickOnUpSnippet = [[
	if (button == "KeyBind") then
		return "LeftButton";
	end
]];
local SwapAtPostClick;
local BackupType;
function Scripts.PreClick(ABW, Button, Down)
	if (InCombatLockdown() or Button == "KeyBind" or Down) then
		return;
	end
	
	local Command, Data, Subvalue, SubSubvalue = Cursor.GetCursor();
	if (Command) then
		-- We note that we might be swapping an action to the button in the post click
		-- Store the cursor in case SABT clears in between now and PostClick
		-- Temporarily clear the ABW type, so that SABT cant trigger it
		SwapAtPostClick = true;
		Cursor.StoreCursor(Command, Data, Subvalue, SubSubvalue);
		BackupType = ABW:GetAttribute("type");
		ABW:SetAttribute("type", "");
	end
end


--[[------------------------------------------------
	Handler:	PostClick
--------------------------------------------------]]
function Scripts.PostClick(ABW, Button, Down)
	local BFButton = ABW.BFButton;
	BFButton:UpdateChecked();
	--Core.UpdateFlyout(BFButton);
	if (InCombatLockdown() or Button == "KeyBind" or Down) then
		return;
	end
	
	if (SwapAtPostClick) then
		SwapAtPostClick = false;
		ABW:SetAttribute("type", BackupType);
		BFButton:SwapActionWithButtonAction(Cursor.GetStoredCursor());
	end
end



--[[------------------------------------------------
	Handler:	OnEnter Standard
--------------------------------------------------]]
function Scripts.OnEnterStandard(ABW)
	ABW:UpdateTooltip();
	Core.UpdateFlyout(ABW.BFButton);
end


--[[------------------------------------------------
	Handler:	OnLeave Standard
--------------------------------------------------]]
function Scripts.OnLeaveStandard(ABW)
	GameTooltip:Hide();
	Core.UpdateFlyout(ABW.BFButton);
end


--[[------------------------------------------------
	Handler:	OnEnter Complete
		Notes:
			* The complete handlers will run processing
			to respond to extra effects that may not
			often run
--------------------------------------------------]]
function Scripts.OnEnterComplete(ABW)
	local BFButton = ABW.BFButton;
	if (BFButton.ShowTooltip) then
		ABW:UpdateTooltip();
	end
	if (BFButton.MouseOverFlyoutDirectionUI) then
		FlyoutUI.AttachFlyoutUI(BFButton);
	end
	Core.UpdateFlyout(BFButton);
	
end


--[[------------------------------------------------
	Handler:	OnLeave Complete
--------------------------------------------------]]
function Scripts.OnLeaveComplete(ABW)
	GameTooltip:Hide();
	--FlyoutUI.DetachFlyoutUI(ABW.BFButton);
	Core.UpdateFlyout(ABW.BFButton);
end


--[[------------------------------------------------
	EmptyF
--------------------------------------------------]]
function Scripts.EmptyF()

end


--[[------------------------------------------------
	EmptyChecked
--------------------------------------------------]]
function Scripts.EmptyChecked(BFButton)
	BFButton.ABW:SetChecked(false);
end


--[[------------------------------------------------
	* This is the generic swap action function
	* There is some tomfoolery due to a subtle drag issue
		- Basically there is a short window where the Button goes empty
		- If it is a Grid not shown then it will also hide (before the cursor registers the action)
		- It seems the hide func call mucks up dragging (meaning a drag release wont actually  drop the action, instead a click is required)
		- To resolve during the swap action we set a flag that asks the UpdateButtonShowHide to not hide just yet, instead we allow this to happen
		- after the cursor is set (when our state is properly in order)
--------------------------------------------------]]
function Scripts.SwapActionWithButtonAction(BFButton, ...)
	SpellFlyout:Hide();
	Cursor.StoreCursor(BFButton:GetCursor(...));

	Core.PreventGridHide(true);
	if (Cursor.SetActionFromCursorValues(BFButton, ...)) then
		Cursor.SetCursor(Cursor.GetStoredCursor());
	end
	Core.PreventGridHide(false);
	Core.UpdateButtonShowHide(BFButton);
end

