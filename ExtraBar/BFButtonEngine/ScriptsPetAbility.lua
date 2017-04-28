--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local ScriptsPetAbility = Engine.ScriptsPetAbility;

local Core = Engine.Core;
local Cursor = Engine.Cursor;
local Scripts = Engine.Scripts;
local Util = Engine.Util;
local UtilPet = Engine.UtilPet;


--[[------------------------------------------------
	UpdateAction
--------------------------------------------------]]
function ScriptsPetAbility.UpdateAction(BFButton)
	local PetAbilities = BFButton.PetAbilities;
	local MacroText = "";
	
	-- We give primacy to the Active Pet
	local ActiveCreature = UnitCreatureFamily("pet");
	local SpellID, SpellName;
	if (ActiveCreature ~= nil) then
		SpellID = PetAbilities[ActiveCreature];
		if (SpellID ~= nil) then
			SpellName = GetSpellInfo(SpellID);
			MacroText = string.format("%s; [pet:%s] %s", MacroText, ActiveCreature, SpellName);
		end
	end

	for k, v in pairs(PetAbilities) do
		if (k ~= ActiveCreature) then
			SpellID = PetAbilities[k];
			if (SpellID ~= nil) then
				SpellName = GetSpellInfo(SpellID);
				MacroText = string.format("%s; [pet:%s] %s", MacroText, k, SpellName);
			end
		end
	end

	BFButton.ABW:SetAttribute("type", "macro");
	BFButton.ABW:SetAttribute("macrotext", "/cast "..string.sub(MacroText, 3));
	BFButton.ABW:SetAttribute("type2", "macro");
	BFButton.ABW:SetAttribute("macrotext2", "/petautocasttoggle "..string.sub(MacroText, 3));
end


--[[------------------------------------------------
	Full Update
--------------------------------------------------]]
function ScriptsPetAbility.FullUpdate(BFButton)
	local SpellName = SecureCmdOptionParse(BFButton.ABW:GetAttribute("macrotext"));
	local SpellID = select(7, GetSpellInfo(SpellName));
	if (not SpellID) then
		if (BFButton.PetSpellID and Util.FindInPairs(BFButton.PetAbilities, BFButton.PetSpellID)) then
			-- Use the last set one provided it still is part of the Button
			SpellID = BFButton.PetSpellID;
			SpellName = BFButton.PetSpellName;
		else
			-- Grab the very first one
			SpellID = select(2, next(BFButton.PetAbilities));
			SpellName = GetSpellInfo(SpellID);
		end
		BFButton.PetSpellActive = false;
	else
		BFButton.PetSpellActive = true;
	end
	BFButton.PetSpellID = SpellID;
	BFButton.PetSpellName = SpellName;
	BFButton.IconTexture = GetSpellTexture(SpellID);
	BFButton.ABWIcon:SetTexture(BFButton.IconTexture);

	if (GetSpellAutocast(SpellName)) then
		BFButton.ABWAutoCastableTexture:Show();
	else
		BFButton.ABWAutoCastableTexture:Hide();
	end
	BFButton:UpdateIcon();
	BFButton:UpdateChecked();
	BFButton:UpdateUsable();
	BFButton:UpdateCooldown();
	BFButton:UpdateShine();
	BFButton:UpdateFlashRegistration();
	BFButton:UpdateRangeRegistration();

	if (GetMouseFocus() == BFButton.ABW) then
		BFButton.ABW:UpdateTooltip();
	end
end


--[[------------------------------------------------
	Icon
--------------------------------------------------]]
function ScriptsPetAbility.UpdateIcon(BFButton)

end


--[[------------------------------------------------
	Checked
--------------------------------------------------]]
function ScriptsPetAbility.UpdateChecked(BFButton)
	if (IsCurrentSpell(BFButton.PetSpellID) or IsAutoRepeatSpell(BFButton.PetSpellID)) then
		BFButton.ABW:SetChecked(true);
	else
		BFButton.ABW:SetChecked(false);
	end
end


--[[------------------------------------------------
	Usable
--------------------------------------------------]]
function ScriptsPetAbility.UpdateUsable(BFButton)
	local Usable, NoMana = IsUsableSpell(BFButton.PetSpellID);
	Core.UpdateButtonUsable(BFButton, Usable and BFButton.PetSpellActive, NoMana);
end


--[[------------------------------------------------
	Cooldown
--------------------------------------------------]]
function ScriptsPetAbility.UpdateCooldown(BFButton)
	Core.SetCooldownType(BFButton, COOLDOWN_TYPE_NORMAL);
	CooldownFrame_SetTimer(BFButton.ABWCooldown, GetSpellCooldown(BFButton.PetSpellID or -1));	-- WIll it give me grief?
end


--[[------------------------------------------------
	Shine
--------------------------------------------------]]
function ScriptsPetAbility.UpdateShine(BFButton)
	local _, AutoCastEnabled = GetSpellAutocast(BFButton.PetSpellID);
	if (AutoCastEnabled) then
		Core.StartAutoCastShine(BFButton);
	else
		Core.ReleaseAutoCastShine(BFButton);
	end
end


--[[------------------------------------------------
	Tooltip
--------------------------------------------------]]
function ScriptsPetAbility.UpdateTooltip(ABW)
	if (ABW.BFButton.PetSpellID ~= -1) then
		GameTooltip_SetDefaultAnchor(GameTooltip, ABW);
		GameTooltip:SetSpellByID(ABW.BFButton.PetSpellID);
	else
		GameTooltip:Hide();
	end
end


--[[------------------------------------------------
	Flash	(registers and Deregisters for flash)
--------------------------------------------------]]
function ScriptsPetAbility.UpdateFlashRegistration(BFButton)
	local IsFlashing = (IsAttackSpell(BFButton.PetSpellID) and IsCurrentSpell(BFButton.PetSpellID)) or IsAutoRepeatSpell(BFButton.PetSpellID);
	Core.UpdateButtonFlashRegistration(BFButton, IsFlashing);
end


--[[------------------------------------------------
	Range Registration
--------------------------------------------------]]
function ScriptsPetAbility.UpdateRangeRegistration(BFButton)
	Core.UpdateButtonRangeRegistration(BFButton, IsSpellInRange(BFButton.PetSpellID, BFButton.Target));
end


--[[------------------------------------------------
	Range Check
--------------------------------------------------]]
function ScriptsPetAbility.CheckRange(BFButton)
	Core.UpdateButtonRangeIndicator(BFButton, IsSpellInRange(BFButton.PetSpellID, BFButton.Target));
end


--[[------------------------------------------------
	Cursor
		Scenarios
		Cursor		Button		Action
			Nothing		ActPetAb+	Pickup just active			 
		Nothing		PetAbs		Pickup all
			ActPetAb	ActPetAb+	Pickup just active
			ActPetAb	PetAbs		Pickup nothing
		PetAbs		ActPetAb+	Pickup all or last
		PetAbs		PetAbs		Pickup all
		Other		ActPetAb+	Pickup all or last
		Other		PetAbs		Pickup all
--------------------------------------------------]]
--[[------------------------------------------------
	SwapActionWithButtonAction
--------------------------------------------------]]
function ScriptsPetAbility.SwapActionWithButtonAction(BFButton, Command, Data, ...)
	local ActiveCreature = UnitCreatureFamily("pet");
	local SpellID = BFButton.PetAbilities[ActiveCreature];
	SpellFlyout:Hide();
	if (Command == "petability" and type(Data) ~= "table") then
		BFButton.PetAbilities[ActiveCreature] = Data;
		BFButton:UpdateAction();
		BFButton:FullUpdate();
		if (SpellID) then
			Cursor.SetCursor("petability", SpellID);
		else
			Cursor.ClearCursor();
		end
		ScriptsPetAbility.ReportAction(BFButton);
	elseif (Command == nil and SpellID) then
		BFButton.PetAbilities[ActiveCreature] = nil;
		if (next(BFButton.PetAbilities) == nil) then
			Core.SetEmpty(BFButton);
		else
			BFButton:UpdateAction();
			BFButton:FullUpdate();
			ScriptsPetAbility.ReportAction(BFButton);
		end
		Cursor.SetCursor("petability", SpellID);
	elseif (SpellID and Util.Count(BFButton.PetAbilities) == 1) then
		if (Cursor.SetActionFromCursorValues(BFButton, Command, Data, ...)) then
			Cursor.SetCursor("petability", SpellID);
		end
	else
		Scripts.SwapActionWithButtonAction(BFButton, Command, Data, ...);
	end
end


function ScriptsPetAbility.GetCursor(BFButton)
	return "petability", BFButton.PetAbilities, nil, nil;
end

