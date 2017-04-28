--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2016

]]


local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local BGMethods = Engine.ButtonGroupMethods;

local C = Engine.Constants;
local S = Engine.Settings;
local Core = Engine.Core;
local ButtonMethods = Engine.ButtonMethods;
local Util = Engine.Util;

local InCombatLockdown = InCombatLockdown;


--[[------------------------------------------------
	Create
--------------------------------------------------]]
function BGMethods.Create(Name)
	local BG = {};
	
	BG.Name = Name;
	BG.BFButtons = {};
	
	return BG;
end


--[[------------------------------------------------
	SetStoredState
	* NoCombat Only
--------------------------------------------------]]
function BGMethods.SetStoredState(BG, StoredState)

	if (StoredState == nil) then
		StoredState = {};
	end
	Util.TableAddUnsetKeys(StoredState, S.ButtonGroupDefaults);
	BG.StoredState = StoredState;
	
	--ReportChange();
	
	BGMethods.SetEnabled(BG, StoredState.Enabled);
	BGMethods.SetRespondsToMouse(BG, StoredState.RespondsToMouse);
	BGMethods.SetAlpha(BG, StoredState.Alpha);
	BGMethods.SetLocked(BG, StoredState.Locked);
	
	
	
	BGMethods.SetAlwaysShowGrid(BG, StoredState.AlwaysShowGrid);
	BGMethods.SetShowTooltip(BG, StoredState.ShowTooltip);
	BGMethods.SetShowKeyBindText(BG, StoredState.ShowKeyBindText);
	BGMethods.SetShowCounts(BG, StoredState.ShowCounts);
	BGMethods.SetShowMacroName(BG, StoredState.ShowMacroName);
	
end
function BGMethods.GetStoredState(BG)
	return BG.StoredState;
end


--[[------------------------------------------------
	SetEnabled
	* NoCombat Only
--------------------------------------------------]]
function BGMethods.SetEnabled(BG, Enabled)

	if (BG.Enabled ~= Enabled) then
		BG.Enabled = Enabled;
		local BFButtons = BG.BFButtons;
		if (BG.Enabled) then
			for i = 1, #BFButtons do
				local BFButton = BFButtons[i];
				if (BG.AlwaysShowGrid or BFButton.Type ~= "empty") then
					BFButton.ABW:Show();
					BFButton.FullRefresh();
				end
			end
		else
			for i = 1, #BFButtons do
				local BFButton = BFButtons[i];
				BFButton.ABW:Hide();
				-- detach BFButton.FullRefresh();
			end
		end
	end
	
	if (BG.StoredState.Enabled ~= Enabled) then
		BG.StoredState.Enabled = Enabled;
		--Core.ReportChange(BG, C.EVENT_ENABLED, Enabled);
	end
	
end
function BGMethods.GetEnabled(BG)
	return BG.StoredState.Enabled;
end



--[[------------------------------------------------
	SetRespondsToMouse
	* NoCombat Only
--------------------------------------------------]]
function BGMethods.SetRespondsToMouse(BG, RespondsToMouse)
	if (BG.RespondsToMouse ~= RespondsToMouse) then
		BG.RespondsToMouse = RespondsToMouse;
		local BFButtons = BG.BFButtons;
		for i = 1, #BFButtons do
			local BFButton = BFButtons[i];
			BFButton.ABW:EnableMouse(RespondsToMouse);
		end
	end
	
	if (BG.StoredState.RespondsToMouse ~= RespondsToMouse) then
		BG.StoredState.RespondsToMouse = RespondsToMouse;
		--Core.ReportEvent(BG, C.EVENT_RESPONDSTOMOUSE, RespondsToMouse);
	end
end
function BGMethods.GetRespondsToMouse(BG)
	return BG.StoredState.RespondsToMouse;
end


--[[------------------------------------------------
	SetAlpha
--------------------------------------------------]]
function BGMethods.SetAlpha(BG, Alpha)
	if (BG.Alpha ~= Alpha) then
		BG.Alpha = Alpha;
		local BFButtons = BG.BFButtons;
		for i = 1, #BFButtons do
			local BFButton = BFButtons[i];
			BFButton.ABW:SetAlpha(Alpha);
		end
	end
	
	if (BG.StoredState.Alpha ~= Alpha) then
		BG.StoredState.Alpha = Alpha;
		--Core.ReportEvent(BG, C.EVENT_RESPONDSTOMOUSE, RespondsToMouse);
	end
end
function BGMethods.GetAlpha(BG)
	return BG.StoredState.Alpha;
end


--[[------------------------------------------------
	SetLocked
--------------------------------------------------]]
function BGMethods.SetLocked(BG, Locked)
	if (BG.Locked ~= Locked) then
		BG.Locked = Locked;
		local BFButtons = BG.BFButtons;
		for i = 1, #BFButtons do
			local BFButton = BFButtons[i];
			BFButton.Locked = Locked;
		end
	end
	
	if (BG.StoredState.Locked ~= Locked) then
		BG.StoredState.Locked = Locked;
		--Core.ReportEvent(BG, C.EVENT_RESPONDSTOMOUSE, RespondsToMouse);
	end
end
function BGMethods.GetLocked(BG)
	return BG.StoredState.Locked;
end


--[[------------------------------------------------
	SetEnabled
	* NoCombat Only
--------------------------------------------------]]
function BGMethods.SetAlwaysShowGrid(BG, AlwaysShowGrid)

	if (BG.AlwaysShowGrid ~= AlwaysShowGrid) then
		BG.AlwaysShowGrid = AlwaysShowGrid;
		local BFButtons = BG.BFButtons;
		if (BG.Enabled and BG.AlwaysShowGrid) then
			for i = 1, #BFButtons do
				local BFButton = BFButtons[i];
				BFButton.ABW:Show();
				BFButton.FullRefresh();
			end
		elseif (BG.Enabled and not BG.AlwaysShowGrid) then
			for i = 1, #BFButtons do
				local BFButton = BFButtons[i];
				if (BFButton.Type == "empty") then
					BFButton.ABW:Hide();
				end
			end
		end
	end
	
	if (BG.StoredState.AlwaysShowGrid ~= AlwaysShowGrid) then
		BG.StoredState.AlwaysShowGrid = AlwaysShowGrid;
		--Core.ReportChange(BG, C.EVENT_ENABLED, Enabled);
	end
	
end
function BGMethods.GetAlwaysShowGrid(BG)
	return BG.StoredState.AlwaysShowGrid;
end








--[[------------------------------------------------
	TemporaryOverride
	* NoCombat Only
	* Queues if in combat
--------------------------------------------------]]
function BGMethods.TemporaryInteractionOverride(BG)

	local BFButtons = BG.BFButtons;
	local Enabled = BG.Enabled;
	local 
	local AlwaysShowGrid = BG.AlwaysShowGrid;
	local CursorHasAction = Cursor.HasValidAction();
	local ActionKeyFunctionDown = S.ActionKeyFunction();
	local ForceAvailable = S.ForceAvailable;
	
	-- 
	
	
	-- Force everything on
	if (ForceAvailable) then
		
		for i = 1, #BFButtons do
			local ABW = BFButtons[i].ABW;
			ABW:Show();
			ABW:EnableMouse(true);
			ABW:SetAlpha(1);
		end
		
	-- Group is disabled, so make sure Buttons are hidden
	elseif (not Enabled) then
		
		for i = 1, #BFButtons do
			local ABW = BFButtons[i].ABW;
			ABW:Hide();
		end
	
	-- Temporarily Enable Mouse and show all
	elseif (CursorHasAction and ActionKeyFunctionDown) then
		
		for i = 1, #BFButtons do
			local ABW = BFButtons[i].ABW;
			ABW:Show();
			ABW:EnableMouse(true);
			ABW:SetAlpha(1);
		end
		
	elseif (CursorHasAction) then
	
	elseif (AlwaysShowGrid
	
	
	if (ForceShow or (Enabled and (CursorHasAction or AlwaysShowGrid))) then
		for i = 1, #BFButtons do
			local BFButton = BFButtons[i];
			BFButton:ABW:Show();
		end
	elseif (not Enabled) then
		for i = 1, #BFButtons do
			local BFButton = BFButtons[i];
			BFButton:ABW:Hide();
		end
	else
		for i = 1, #BFButtons do
			local BFButton = BFButtons[i];
			if (BFButton.Type == "empty") then
				BFButton.ABW:Hide();
			else
				BFButton.ABW:Show();
			end
		end
	end
	
end


--[[------------------------------------------------
	UpdateButtonShowHide
	* NoCombat Only
--------------------------------------------------]]
function BGMethods.UpdateMouseResponse(BG)
	
	local BFButtons = BG.BFButtons;
	local CursorHasAction = Cursor.HasValidAction();
	local ForceShow = S.ForceShow;
	
end

