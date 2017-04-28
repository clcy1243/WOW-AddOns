--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014
	
	Desc:	Util type functionality for Pets inthe Button Engine
			This is mostly hack type stuff to work with pets

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local UtilPet = Engine.UtilPet;

local S = Engine.Settings;
local C = Engine.Constants;
local Core = Engine.Core;
local ScriptsPetAbilityHunter = Engine.ScriptsPetAbilityHunter;


--[[------------------------------------------------
	Local Private
--------------------------------------------------]]
local PetActionBarActions = {};
local PetCommandTextures = {};
PetCommandTextures.PET_MODE_DEFENSIVE = PET_DEFENSIVE_TEXTURE;
--Priv.PetCommandTextures.PET_MODE_AGGRESSIVE = PET_AGGRESSIVE_TEXTURE;
PetCommandTextures.PET_MODE_PASSIVE = PET_PASSIVE_TEXTURE;
PetCommandTextures.PET_MODE_ASSIST = PET_ASSIST_TEXTURE;
PetCommandTextures.PET_ACTION_ATTACK = PET_ATTACK_TEXTURE;
PetCommandTextures.PET_ACTION_FOLLOW = PET_FOLLOW_TEXTURE;
PetCommandTextures.PET_ACTION_WAIT = PET_WAIT_TEXTURE;
--Priv.PetCommandTextures.PET_MODE_DISMISS_TEXTURE = PET_DISMISS_TEXTURE;
PetCommandTextures.PET_ACTION_MOVE_TO = PET_MOVE_TO_TEXTURE;

local PetCommandMacros = {};
PetCommandMacros.PET_MODE_DEFENSIVE = "/petdefensive";
--Priv.PetCommandTextures.PET_MODE_AGGRESSIVE = PET_AGGRESSIVE_TEXTURE;
PetCommandMacros.PET_MODE_PASSIVE = "/petpassive";
PetCommandMacros.PET_MODE_ASSIST = "/petassist";
PetCommandMacros.PET_ACTION_ATTACK = "/petattack";
PetCommandMacros.PET_ACTION_FOLLOW = "/petfollow";
PetCommandMacros.PET_ACTION_WAIT = "/petstay";
--Priv.PetCommandTextures.PET_MODE_DISMISS_TEXTURE = PET_DISMISS_TEXTURE;
PetCommandMacros.PET_ACTION_MOVE_TO = "/petmoveto";



local CALL_PET_SPELL_IDS = {
	0883,
	83242,
	83243,
	83244,
	83245,
};
local Pets = {};

local CursorPetCommand = nil;
local CursorPetData = nil;


--[[------------------------------------------------
	GetPetCommandMacro
--------------------------------------------------]]
function UtilPet.GetPetCommandMacro(PetCommand)
	return PetCommandMacros[PetCommand];
end


--[[------------------------------------------------
	PetCommandIcon
--------------------------------------------------]]
function UtilPet.GetPetCommandIcon(PetCommand)
	return PetCommandTextures[PetCommand];
end



--[[------------------------------------------------
	Find which pet slot has the active pet (hunter)
--------------------------------------------------]]
function UtilPet.GetActivePetSlot()
	local Spells = CALL_PET_SPELL_IDS;
	for i = 1, #Spells do
		if (IsCurrentSpell(Spells[i])) then
			return i;
		end
	end
end


--[[------------------------------------------------
	GetPetCommandSpellBookIndex
--------------------------------------------------]]
function UtilPet.GetPetCommandSpellBookIndex(PetCommand)
	local PetSpellCount = HasPetSpells();
	-- check to see if we have a pet
	if ( PetSpellCount and PetHasSpellbook() ) then	
		for i = 1, PetSpellCount do
			if (PetCommandTextures[PetCommand] == GetSpellBookItemTexture(i, BOOKTYPE_PET)) then
				return i, BOOKTYPE_PET;
			end
		end
	end
	return 0;
end


--[[------------------------------------------------
	GetPetAbilitySpellBookIndex
--------------------------------------------------]]
function UtilPet.GetPetAbilitySpellBookIndex(PetAbilitySpellID)
	local PetSpellCount = HasPetSpells();
	-- check to see if we have a pet
	if ( PetSpellCount and PetHasSpellbook() ) then	
		for i = 1, PetSpellCount do
			local SkillType, SpellID = GetSpellBookItemInfo(i, BOOKTYPE_PET);
			if (SpellID == PetAbilitySpellID) then
				return i, BOOKTYPE_PET;
			end
		end
	end
	return 0;
end


--[[------------------------------------------------
	Check Spec for a Spell
--------------------------------------------------]]
function UtilPet.PetSpecializationHasSpell(Spec, SpellID)
	local t = {GetSpecializationSpells(Spec, false, true)}
	for i = 1, #t, 2 do
		if (t[i] == SpellID) then
			return true;
		end
	end
	return false;
end


--[[------------------------------------------------
	LookUpSpellIDInPetAbilities 
--------------------------------------------------]]
function UtilPet.LookUpSpellIDInPetAbilities(PetAbilities, MyPetID, PetSpec)
	local PetAbility = PetAbilities[MyPetID];
	if (PetAbility ~= nil) then
		return PetAbility[string.format("PetSpec-%i-SpellID", PetSpec)];
	end
	return nil;
end


--[[------------------------------------------------
	PetAbilitiesHasSpell
--------------------------------------------------]]
function UtilPet.PetAbilitiesHasSpell(PetAbilities, SpellID)
	for MyPetID, PetAbility in pairs(PetAbilities) do
		for PetSpec = 1, 3 do
			if (PetAbility[string.format("PetSpec-%i-SpellID", PetSpec)] == SpellID) then
				return MyPetID, PetSpec;
			end
		end
	end
end


--[[------------------------------------------------
	GetFirstSpellID
--------------------------------------------------]]
function UtilPet.GetFirstSpellIDInPetAbilities(PetAbilities)
	local MyPetID, PetAbility = next(PetAbilities);
	for PetSpec = 1, 3 do
		local SpellID = PetAbility[string.format("PetSpec-%i-SpellID", PetSpec)];
		if (SpellID) then
			return SpellID;
		end
	end
end


--[[------------------------------------------------
	CountPetAbilities
--------------------------------------------------]]
function UtilPet.CountPetAbilities(PetAbilities)
	local Count = 0;
	for MyPetID, PetAbility in pairs(PetAbilities) do
		for PetSpec = 1, 3 do
			Count = Count + (PetAbility[string.format("PetSpec-%i-SpellID", PetSpec)] and 1 or 0);
		end
	end
	return Count;
end


--[[------------------------------------------------
	ApplyHunterPetAbility (note this is only for the active pet and PetSpec for Hunters)
--------------------------------------------------]]
function UtilPet.ApplyHunterPetAbility(BFButton, SpellID)
	local MyPetID, PetName, PetType, PetSpec = UtilPet.GetPetState(UtilPet.GetActivePetSlot(), GetActiveSpecGroup());
	local PetAbility = BFButton.PetAbilities[MyPetID] or {};
	
	PetAbility.PetName = PetName;
	PetAbility.PetType = PetType;
	PetAbility[string.format("PetSpec-%i-SpellID", PetSpec)] = SpellID;
	local NotEmpty;
	for i = 1, 3 do
		NotEmpty = NotEmpty or PetAbility[string.format("PetSpec-%i-SpellID", i)];
	end
	if (not NotEmpty) then
		BFButton.PetAbilities[MyPetID] = nil;
	else
		BFButton.PetAbilities[MyPetID] = PetAbility;
	end
	if (next(BFButton.PetAbilities) == nil) then
		Core.SetEmpty(BFButton);
		return;
	end
	--ScriptsPetAbilityHunter.ReportAction(BFButton);
end


--[[------------------------------------------------
	Track what pet is in each slot
	CachePetState, capture info about the current pet
	under the active spec group
--------------------------------------------------]]
function UtilPet.CachePetState()
	if (select(2, UnitClass("player")) ~= "HUNTER") then
		return;
	end
	local PetSlot = UtilPet.GetActivePetSlot();
	if (PetSlot == nil) then
		return;
	end
	local PlayerSpecGroup = GetActiveSpecGroup();
	local OtherSpecGroup = 2 - 3 % PlayerSpecGroup;
	local ps = Pets[PetSlot] or {};
	
	if (ps.MyPetID == nil) then
		ps.MyPetID = S.PetIDSeq;
		S.PetIDSeq = S.PetIDSeq + 1;
	end
	
	ps.PetName = GetUnitName("pet");
	ps.PetType = UnitCreatureFamily("pet");
	ps["PetSpecializationSpecGroup-"..PlayerSpecGroup] = GetSpecialization(false, true) or 1;
	ps["PetSpecializationSpecGroup-"..OtherSpecGroup] = ps["PetSpecializationSpecGroup-"..OtherSpecGroup] or ps["PetSpecializationSpecGroup-"..PlayerSpecGroup];
	Pets[PetSlot] = ps;
end


--[[------------------------------------------------
	GetPetState
--------------------------------------------------]]
function UtilPet.GetPetState(PetSlot, SpecGroup)
	PetSlot = PetSlot or UtilPet.GetActivePetSlot();
	if (PetSlot == nil) then
		return;
	end
	
	local ps = Pets[PetSlot];
	if (ps) then
		return ps.MyPetID, ps.PetName, ps.PetType, ps["PetSpecializationSpecGroup-"..(SpecGroup or GetActiveSpecGroup())]
	end
end


--[[------------------------------------------------
	GetPetCursor
--------------------------------------------------]]
local CursorPetCommand, CursorPetData;
function UtilPet.GetPetCursor()
	if (select(2, UnitClass("player")) == "HUNTER" and CursorPetCommand == "petability") then
		return "petabilityhunter", CursorPetData;
	else
		return CursorPetCommand, CursorPetData;
	end
end


--[[------------------------------------------------
	SetPetCursor	UNFINISHED (nvm)
--------------------------------------------------]]
function UtilPet.SetPetCursor(Command, Data)
	--if (Command == "petability" or ) then
		PickupSpellBookItem(UtilPet.GetPetAbilitySpellBookIndex(Data));
	--else
		--return Priv.CursorPetCommand, Priv.CursorPetData;
	--end
end


--[[------------------------------------------------
	Detect What Pet has been put onto the cursor
	hooksecurefunc several times
	
	* Pickup From SpellBook (PickupSpellBookItem)
		Get SpellID for PetAbility
		Get Texture and Reverse lookup for PetCommand
		
	* Pickup From Pet Spec Panel (PickupPetSpell)
		Get SpellID for PetAbility
	
	* Pickup From Pet Action Bar (PickupPetAction, and also CastPetAction)
		We need to know what is on the Button before the above funcs are called...
			Wrap Pet Button Click, 	DragStart, ReceiveDrag
		Get SpellID for PetAbility
		Get PetCommand otherwise
		
	* For Bonus points! We can actually wrap the SpellFlyouts (Yuck and maybe)
		We can then determine 1 - 5 which flyout gets invoked
		Provided we can match this up to the call pet ability (I think we can, we can spot which pet is summoned)
		That means we could then securely fix the pet ability with in the secure env)
		DAMN WILL NOT WORK (cause macros)
--------------------------------------------------]]
-- Pickup From SpellBook (PickupSpellBookItem)
local function HookSecureFunc_PickupSpellBookItem(Index, Type)
	if (Type ~= "pet") then
		return;
	end
	
	local ActionType, SpellID = GetSpellBookItemInfo(Index, Type);
	if (ActionType == "PETACTION") then
		local Texture = GetSpellBookItemTexture(Index, Type);
		for k, v in pairs(PetCommandTextures) do
			if (v == Texture) then
				CursorPetCommand = "petcommand";
				CursorPetData = k;
				break;
			end
		end
	else
		CursorPetCommand = "petability";
		CursorPetData = SpellID;
	end
end
hooksecurefunc("PickupSpellBookItem", HookSecureFunc_PickupSpellBookItem);

-- Pickup From Pet Spec Panel (PickupPetSpell)
local function HookSecureFunc_PickupPetSpell(SpellID)
	CursorPetCommand = "petability";
	CursorPetData = SpellID;
end
hooksecurefunc("PickupPetSpell", HookSecureFunc_PickupPetSpell);

-- Pickup From Pet Action Bar (PickupPetAction, and also CastPetAction)
local function HookSecureFunc_PickupPetAction(Index)
	local Action = PetActionBarActions[Index];
	if (Action == nil) then
		return;
	end
	if (PetCommandTextures[Action]) then
		CursorPetCommand = "petcommand";
		CursorPetData = Action;
	else
		CursorPetCommand = "petability";
		CursorPetData = Action;
	end
end
hooksecurefunc("PickupPetAction", HookSecureFunc_PickupPetAction);

local function HookSecureFunc_CastPetAction(Index)
	if (GetCursorInfo() == "petaction") then
		HookSecureFunc_PickupPetAction(Index);
	end
end
hooksecurefunc("CastPetAction", HookSecureFunc_CastPetAction);


--[[------------------------------------------------
	Detect and Cache what Pet actions are on the Pet Action bar
	This is done in a just in time fashion.
	We do this by using a wrapper on each off the pet action
	buttons.
--------------------------------------------------]]
local SecurePetWrapper = CreateFrame("FRAME", nil, nil, "SecureHandlerBaseTemplate");
function SecurePetWrapper:CachePetButton(Index)
	local PetCommand, _, _, IsToken, _, _, _, SpellID = GetPetActionInfo(Index);
	if (IsToken) then
		PetActionBarActions[Index] = PetCommand;
	else
		PetActionBarActions[Index] = SpellID;
	end
end

local WrapPetActionButton = [[
	owner:CallMethod("CachePetButton", self:GetID());
]];

for i = 1, 10 do
	SecurePetWrapper:WrapScript(_G["PetActionButton"..i], "OnClick", WrapPetActionButton);
	SecurePetWrapper:WrapScript(_G["PetActionButton"..i], "OnDragStart", WrapPetActionButton);
	SecurePetWrapper:WrapScript(_G["PetActionButton"..i], "OnReceiveDrag", WrapPetActionButton);
end


--[[------------------------------------------------
	We need to hooksecurefunc to keep our pet mapping
	up to date
--------------------------------------------------]]
local function HookSecureFunc_SetPetSlot(SlotA, SlotB)
	if (IsAtStableMaster()) then
		local t = Pets[SlotA];
		Pets[SlotA] = Pets[SlotB];
		Pets[SlotB] = t;
	end
end
hooksecurefunc("SetPetSlot", HookSecureFunc_SetPetSlot);







