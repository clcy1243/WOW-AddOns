--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local ScriptsPetAbilityHunter = Engine.ScriptsPetAbilityHunter;

local Core = Engine.Core;
local Cursor = Engine.Cursor;
local Scripts = Engine.Scripts;
local Util = Engine.Util;
local UtilPet = Engine.UtilPet;


--[[------------------------------------------------
	UpdateAction
--------------------------------------------------]]
function ScriptsPetAbilityHunter.UpdateAction(BFButton)
	local PetAbilities = BFButton.PetAbilities;
	local MacroText = "";
	
	-- We give primacy to the Active Pet
	local ActivePetSlot = UtilPet.GetActivePetSlot();
	local SpecGroup = GetActiveSpecGroup();
	local MyPetID, PetName, PetType, PetSpec = UtilPet.GetPetState(ActivePetSlot, SpecGroup);
	local SpellID, SpellName;
	if (MyPetID ~= nil) then
		SpellID = UtilPet.LookUpSpellIDInPetAbilities(PetAbilities, MyPetID, PetSpec);
		if (SpellID ~= nil) then
			if (UtilPet.GetPetAbilitySpellBookIndex(SpellID) == 0) then
				-- The pet does not know this ability, which means things are unstuck some what??
				-- It probably means MyPetID is wrong, though for all intents and purposes at this stage whatever
				-- pet now has the ID can keep it.
				UtilPet.ApplyHunterPetAbility(BFButton, nil);
				print("I want to know about this - Pet ID has un matched");
				if (BFButton.Type == "empty") then
					return;
				end
			else
				SpellName = GetSpellInfo(SpellID);
				MacroText = string.format("%s; [pet:%s, pet:%s] %s", MacroText, PetName, PetType, SpellName);
			end
		end
	end

	for i = 1, NUM_PET_ACTIVE_SLOTS do
		if (i ~= ActivePetSlot) then
			MyPetID, PetName, PetType, PetSpec = UtilPet.GetPetState(i, SpecGroup);
			if (MyPetID ~= nil) then
				SpellID = UtilPet.LookUpSpellIDInPetAbilities(PetAbilities, MyPetID, PetSpec);
				if (SpellID ~= nil) then
					SpellName = GetSpellInfo(SpellID);
					MacroText = string.format("%s; [pet:%s, pet:%s] %s", MacroText, PetName, PetType, SpellName);
				end
			end
		end
	end

	BFButton.ABW:SetAttribute("type", "macro");
	BFButton.ABW:SetAttribute("macrotext", "/cast "..string.sub(MacroText, 3));
	BFButton.ABW:SetAttribute("type2", "macro");
	BFButton.ABW:SetAttribute("macrotext2", "/petautocasttoggle "..string.sub(MacroText, 3));
	--ScriptsPetAbility.FullUpdate(BFButton);
end


--[[------------------------------------------------
	Full Update
--------------------------------------------------]]
function ScriptsPetAbilityHunter.FullUpdate(BFButton)
	local SpellName = SecureCmdOptionParse(BFButton.ABW:GetAttribute("macrotext"));
	local SpellID = select(7, GetSpellInfo(SpellName));
	if (not SpellID) then
		if (BFButton.PetSpellID and UtilPet.PetAbilitiesHasSpell(BFButton.PetAbilities, BFButton.PetSpellID)) then
			-- Use the last set one provided it still is part of the Button
			SpellID = BFButton.PetSpellID;
			SpellName = BFButton.PetSpellName;
		else
			-- Grab the very first one
			SpellID = UtilPet.GetFirstSpellIDInPetAbilities(BFButton.PetAbilities);
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
function ScriptsPetAbilityHunter.UpdateIcon(BFButton)

end


--[[------------------------------------------------
	Checked
--------------------------------------------------]]
function ScriptsPetAbilityHunter.UpdateChecked(BFButton)
	if (IsCurrentSpell(BFButton.PetSpellID) or IsAutoRepeatSpell(BFButton.PetSpellID)) then
		BFButton.ABW:SetChecked(true);
	else
		BFButton.ABW:SetChecked(false);
	end
end


--[[------------------------------------------------
	Usable
--------------------------------------------------]]
function ScriptsPetAbilityHunter.UpdateUsable(BFButton)
	local Usable, NoMana = IsUsableSpell(BFButton.PetSpellID);
	Core.UpdateButtonUsable(BFButton, Usable and BFButton.PetSpellActive, NoMana);
end


--[[------------------------------------------------
	Cooldown
--------------------------------------------------]]
function ScriptsPetAbilityHunter.UpdateCooldown(BFButton)
	Core.SetCooldownType(BFButton, COOLDOWN_TYPE_NORMAL);
	CooldownFrame_SetTimer(BFButton.ABWCooldown, GetSpellCooldown(BFButton.PetSpellID or -1));	-- WIll it give me grief?
end


--[[------------------------------------------------
	Shine
--------------------------------------------------]]
function ScriptsPetAbilityHunter.UpdateShine(BFButton)
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
function ScriptsPetAbilityHunter.UpdateTooltip(ABW)
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
function ScriptsPetAbilityHunter.UpdateFlashRegistration(BFButton)
	local IsFlashing = (IsAttackSpell(BFButton.PetSpellID) and IsCurrentSpell(BFButton.PetSpellID)) or IsAutoRepeatSpell(BFButton.PetSpellID);
	Core.UpdateButtonFlashRegistration(BFButton, IsFlashing);
end


--[[------------------------------------------------
	Range Registration
--------------------------------------------------]]
function ScriptsPetAbilityHunter.UpdateRangeRegistration(BFButton)
	Core.UpdateButtonRangeRegistration(BFButton, IsSpellInRange(BFButton.PetSpellID, BFButton.Target));
end


--[[------------------------------------------------
	Range Check
--------------------------------------------------]]
function ScriptsPetAbilityHunter.CheckRange(BFButton)
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
function ScriptsPetAbilityHunter.SwapActionWithButtonAction(BFButton, Command, Data, ...)
	local ActivePetSlot = UtilPet.GetActivePetSlot();
	local SpecGroup = GetActiveSpecGroup();
	local MyPetID, PetName, PetType, PetSpec = UtilPet.GetPetState(ActivePetSlot, SpecGroup);
	local SpellID = UtilPet.LookUpSpellIDInPetAbilities(BFButton.PetAbilities, MyPetID, PetSpec);
	SpellFlyout:Hide();
	if (Command == "petabilityhunter" and type(Data) ~= "table") then
		UtilPet.ApplyHunterPetAbility(BFButton, Data);
		BFButton:UpdateAction();
		BFButton:FullUpdate();
		if (SpellID) then
			Cursor.SetCursor("petabilityhunter", SpellID);
		else
			Cursor.ClearCursor();
		end
	elseif (Command == nil and SpellID) then
		UtilPet.ApplyHunterPetAbility(BFButton, nil);
		BFButton:UpdateAction();
		BFButton:FullUpdate();
		Cursor.SetCursor("petabilityhunter", SpellID);
	elseif (SpellID and UtilPet.CountPetAbilities(BFButton.PetAbilities) == 1) then
		if (Cursor.SetActionFromCursorValues(BFButton, Command, Data, ...)) then
			Cursor.SetCursor("petabilityhunter", SpellID);
		end
	else
		Scripts.SwapActionWithButtonAction(BFButton, Command, Data, ...);
	end
end


function ScriptsPetAbilityHunter.GetCursor(BFButton)
	return "petabilityhunter", BFButton.PetAbilities, nil, nil;
end

