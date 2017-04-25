--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local ScriptsMacro = Engine.ScriptsMacro;

local Core = Engine.Core;
local Methods = Engine.Methods;
local C = Engine.Constants;
local Util = Engine.Util;
local ScriptsItem = Engine.ScriptsItem;
local ScriptsSpell = Engine.ScriptsSpell;


--[[------------------------------------------------
	UpdateAction
--------------------------------------------------]]
function ScriptsMacro.UpdateAction(BFButton)
	local Changed, UpdatedIndex = ScriptsMacro.LocateMacro(BFButton.MacroIndex, BFButton.MacroName, BFButton.MacroBody);
	local MacroName, MacroTexture, MacroBody;
	BFButton.MacroUnknown = false;
	if (not Changed) then
		return;
	end
	
	if (UpdatedIndex) then
		MacroName, MacroTexture, MacroBody = GetMacroInfo(UpdatedIndex);
		BFButton.MacroIndex = UpdatedIndex;
		BFButton.MacroName = MacroName;
		BFButton.MacroBody = MacroBody;
		BFButton.ABW:SetAttribute("macro", BFButton.MacroIndex);
		
		local Action = BFButton.Action;
		Action.Type = "macro";
		Action.MacroIndex = BFButton.MacroIndex;
		Action.MacroName = BFButton.MacroName;
		Action.MacroBody = BFButton.MacroBody;
		Core.ReportEvent(BFButton, C.EVENT_UPDATEACTION, Action);
	else
		Methods.SetActionEmpty(BFButton);
	end
end


--[[------------------------------------------------
	LocateMacro
	Macros are a pain, this is a heuristic to try and relocate them
	Returns ChangeDetected, MacroIndex
--------------------------------------------------]]
function ScriptsMacro.LocateMacro(MacroIndex, MacroName, MacroBody)
	local AccMacros, CharMacros = GetNumMacros();
	local FirstMacro, LastMacro;
	if (MacroIndex > MAX_ACCOUNT_MACROS) then
		FirstMacro = MAX_ACCOUNT_MACROS + 1;
		LastMacro = MAX_ACCOUNT_MACROS + CharMacros;
	else
		FirstMacro = 1;
		LastMacro = AccMacros;
	end
	
	
	-- 1) Check it hasn't moved or changed
	local Name, Icon, Body = GetMacroInfo(MacroIndex);
	if (Name == MacroName and Body == MacroBody) then
		return false, MacroIndex;
	end
	
	-- 2) Perhaps it has shifted down by 1
	if (MacroIndex - 1 >= FirstMacro) then
		Name, Icon, Body = GetMacroInfo(MacroIndex - 1);
		if (Name == MacroName and Body == MacroBody) then
			return true, MacroIndex - 1;
		end
	end
	
	-- 3) Perhaps it has shifted up by 1 then
	if (MacroIndex + 1 <= LastMacro) then
		Name, Icon, Body = GetMacroInfo(MacroIndex + 1);
		if (Name == MacroName and Body == MacroBody) then
			return true, MacroIndex + 1;
		end
	end
	
	-- 4) Special case, Assume if the macro at current index has the same name, then it was a body change
	Name, Icon, Body = GetMacroInfo(MacroIndex);
	if (Name == MacroName) then
		return true, MacroIndex;
	end
	
	-- 5) Scan for the macro,
	local BodyMatch, NameMatch;
	for i = FirstMacro, LastMacro do
		Name, Icon, Body = GetMacroInfo(i);
		if (Name == MacroName and Body == MacroBody) then
			-- Our best match so just go with
			return true, i;
		
		elseif (Body == MacroBody) then
			BodyMatch = i;
		
		elseif (Name == MacroName) then
			NameMatch = i;
		end
	end
	
	-- We have an option, Body match is preferred over name, so go with that index
	if (BodyMatch or NameMatch) then
		return true, BodyMatch or NameMatch;
	end
	
	-- No match, It has possibly been deleted... Our rule is that we only clear it if there is at least 1 macro in the section, this is in case of a caching issue early in the load phase
	if (LastMacro >= FirstMacro) then
		-- Our test here shows there is at least one macro in the section, so delete the sucker
		return true, nil;
	end
	
	-- Ok, we're not confident enough to do a delete, it will be up to the player to decide how to handle the situation, but we wont change the macro here
	return false, MacroIndex;
end


--[[------------------------------------------------
	Full Update
--------------------------------------------------]]
function ScriptsMacro.FullUpdate(BFButton)
	ScriptsMacro.HasMacroActionChanged(BFButton);
	ScriptsMacro.UpdateMacroMode(BFButton);
	BFButton:UpdateIcon();
	BFButton:UpdateChecked();
	BFButton:UpdateUsable();
	BFButton:UpdateCooldown();
	BFButton:UpdateEquipped();
	BFButton:UpdateText();
	BFButton:UpdateGlow();
	BFButton:UpdateFlashRegistration();
	BFButton:UpdateRangeRegistration();
	
	if (GetMouseFocus() == BFButton.ABW) then
		BFButton.ABW:UpdateTooltip();
	end
end


--[[------------------------------------------------
	Update Macro
	Note:
		This is a bit untidy and could've been better organised to work in
		and utilise full update, but hey. It might ekk out a bit of
		performance??!
--------------------------------------------------]]
function ScriptsMacro.UpdateMacro(BFButton)
	if (ScriptsMacro.HasMacroActionChanged(BFButton)) then
		ScriptsMacro.UpdateMacroMode(BFButton);
		BFButton:UpdateIcon();
		BFButton:UpdateChecked();
		BFButton:UpdateUsable();
		BFButton:UpdateCooldown();
		BFButton:UpdateEquipped();
		BFButton:UpdateText();
		BFButton:UpdateGlow();
		BFButton:UpdateFlashRegistration();
		BFButton:UpdateRangeRegistration();
		
		if (GetMouseFocus() == BFButton.ABW) then
			BFButton.ABW:UpdateTooltip();
		end
	end
end

function ScriptsMacro.HasMacroActionChanged(BFButton)
	local Name, Texture, Body = GetMacroInfo(BFButton.MacroIndex);
	local Action, Target = SecureCmdOptionParse(Body or '');
	BFButton.Target = Target or "target";
	local TargetAlive = not UnitIsDead(BFButton.Target);
	local TargetHarm = UnitCanAttack("player", BFButton.Target) and TargetAlive;
	local TargetHelp = UnitCanAssist("player", BFButton.Target) and TargetAlive;
	
	if (BFButton.IconTexture ~= Texture	or BFButton.MacroAction ~= Action or BFButton.MacroTargetHarm ~= TargetHarm	or BFButton.MacroTargetHelp ~= TargetHelp) then
		BFButton.MacroAction = Action;
		BFButton.MacroTargetHarm = TargetHarm;
		BFButton.MacroTargetHelp = TargetHelp;
		return true;
	end
	return false;
end

function ScriptsMacro.UpdateMacroMode(BFButton)

	local SpellName, SpellRank, SpellID = GetMacroSpell(BFButton.MacroIndex);
	if (SpellID) then
		BFButton.MacroMode = "spell";
		BFButton.SpellFullName = Util.SpellFullName(SpellID);
		BFButton.SpellID = SpellID;
		BFButton.SpellIndex = Util.LookupSpellIndex(SpellID) or 0;
	else
		local ItemName, ItemLink = GetMacroItem(BFButton.MacroIndex);
		if (ItemName) then
			BFButton.MacroMode = "item";
			BFButton.ItemName = ItemName;
			BFButton.ItemLink = ItemLink;
			BFButton.ItemID = Util.GetItemIDFromHyperlink(ItemLink);
		else
			BFButton.MacroMode = "";
		end
	end
end




--[[------------------------------------------------
	Icon
--------------------------------------------------]]
function ScriptsMacro.UpdateIcon(BFButton)
	local Texture = select(2, GetMacroInfo(BFButton.MacroIndex)) or C.QUESTION_MARK;
	BFButton.ABWIcon:SetTexture(Texture);		

end


--[[------------------------------------------------
	Checked
--------------------------------------------------]]
function ScriptsMacro.UpdateChecked(BFButton)
	if (BFButton.MacroMode == "spell") then
		ScriptsSpell.UpdateChecked(BFButton);
	elseif (BFButton.MacroMode == "item") then
		ScriptsItem.UpdateChecked(BFButton);
	else
		BFButton.ABW:SetChecked(false);
	end
end


--[[------------------------------------------------
	Equipped
--------------------------------------------------]]
function ScriptsMacro.UpdateEquipped(BFButton)
	if (BFButton.MacroMode == "item") then
		ScriptsItem.UpdateEquipped(BFButton);
	else
		BFButton.ABWBorder:Hide();
	end
end


--[[------------------------------------------------
	Usable
--------------------------------------------------]]
function ScriptsMacro.UpdateUsable(BFButton)
	if (BFButton.MacroMode == "spell") then
		ScriptsSpell.UpdateUsable(BFButton);
	elseif (BFButton.MacroMode == "item") then
		ScriptsItem.UpdateUsable(BFButton);
	else
		Core.UpdateButtonUsable(BFButton, true);
	end
end


--[[------------------------------------------------
	Cooldown
--------------------------------------------------]]
function ScriptsMacro.UpdateCooldown(BFButton)
	if (BFButton.MacroMode == "spell") then
		ScriptsSpell.UpdateCooldown(BFButton);
	elseif (BFButton.MacroMode == "item") then
		ScriptsItem.UpdateCooldown(BFButton);
	else
		CooldownFrame_Set(BFButton.ABWCooldown, 0, 0, 0);
		BFButton.ABWCooldown:Hide();
	end
end


--[[------------------------------------------------
	Text	(Charges, or Counts)
--------------------------------------------------]]
function ScriptsMacro.UpdateText(BFButton)
	if (BFButton.MacroMode == "spell") then
		ScriptsSpell.UpdateText(BFButton);
	elseif (BFButton.MacroMode == "item") then
		ScriptsItem.UpdateText(BFButton);
	else
		BFButton.ABWCount:SetText(nil);
	end
	
	if (BFButton.ABWCount:GetText() == nil) then
		BFButton.ABWName:SetText(BFButton.MacroName);
	else
		BFButton.ABWName:SetText(nil);
	end
end


--[[------------------------------------------------
	Glow
--------------------------------------------------]]
function ScriptsMacro.UpdateGlow(BFButton)
	if (BFButton.MacroMode == "spell") then
		ScriptsSpell.UpdateGlow(BFButton);
	else
		ActionButton_HideOverlayGlow(BFButton.ABW);
	end
end


--[[------------------------------------------------
	Tooltip
--------------------------------------------------]]
function ScriptsMacro.UpdateTooltip(ABW)
	if (ABW.BFButton.MacroMode == "spell") then
		ScriptsSpell.UpdateTooltip(ABW);
	elseif (ABW.BFButton.MacroMode == "item") then
		ScriptsItem.UpdateTooltip(ABW);
	else
		GameTooltip_SetDefaultAnchor(GameTooltip, ABW);
		GameTooltip:SetText(ABW.BFButton.MacroName, 1, 1, 1, 1);
	end
end


--[[------------------------------------------------
	Flash Registration
--------------------------------------------------]]
function ScriptsMacro.UpdateFlashRegistration(BFButton)
	if (BFButton.MacroMode == "spell") then
		ScriptsSpell.UpdateFlashRegistration(BFButton);
	else
		Core.UpdateButtonFlashRegistration(BFButton);
	end
end


--[[------------------------------------------------
	Range Registration
--------------------------------------------------]]
function ScriptsMacro.UpdateRangeRegistration(BFButton)
	if (BFButton.MacroMode == "spell") then
		ScriptsSpell.UpdateRangeRegistration(BFButton);
	elseif (BFButton.MacroMode == "item") then
		ScriptsItem.UpdateRangeRegistration(BFButton);
	else
		Core.UpdateButtonRangeRegistration(BFButton);
	end
end


--[[------------------------------------------------
	Range Check
--------------------------------------------------]]
function ScriptsMacro.CheckRange(BFButton)
	if (BFButton.MacroMode == "spell") then
		ScriptsSpell.CheckRange(BFButton);
	elseif (BFButton.MacroMode == "item") then
		ScriptsItem.CheckRange(BFButton);
	end
end


--[[------------------------------------------------
	Cursor
--------------------------------------------------]]
function ScriptsMacro.GetCursor(BFButton)
	return "macro", BFButton.MacroIndex, nil, nil;
end

