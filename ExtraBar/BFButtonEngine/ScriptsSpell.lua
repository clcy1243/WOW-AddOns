--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014
	
	Scripts for Spell buttons
	Some Notes about the scripts in general (for all types):
	* Method SetActionType
		The set function that preps the Button type (such as functions), as much is done here as possible
		though some things that can change for the button are handled in the UpdateAction function
		
	* UpdateAction
		Some actions (not spells) may need to adjust their action info and also attribute commands, i.e. macros when the
		name or static icon is changed
		Needless to say this is not possible while in combat, so will schedule such updates till post combat
		
	* FullUpdate
		This will take care of updating any values for the button that aren't needed for the attributes as above
		This will also trigger all update functions for the button to get it's display correct

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local ScriptsSpell = Engine.ScriptsSpell;

local Core = Engine.Core;
local Util = Engine.Util;
local C = Engine.Constants;


--[[------------------------------------------------
	UpdateAction
	* Wow v7.0
		* Spells are hard again *sigh*
		
		* Observed Behaviours
			- Talents can only be triggered by SpellName (not ID)
			- Specialization spells and normal spells can trigger from both name and ID
			- Some Spell API calls also do not work with ID when it is a Talent or Specialization
			- Can we just always use SpellName - NO
				- Some spells share the same name e.g:
				- Shaman Hexes
				- Obliterate and Obliteration (with Russian Locale)
			- Can we just always use Spell Index - Sometimes
				- Spell Index is quite reliable with most API calls, though it's a pain to track the index (though
				  thats how things will be done when ID wont cut it
				- Unfortunately Index cannot be used by addons to trigger the spell (which is how the Spellbook casts spells
				  and avoids the issue with casting talents)
				
			- Some spells get replaced e.g.
				- Mend Pet / Revive Pet
				- A Talent upgraded Spell
				- If a Spell gets upgraded by a Talent we really need to update the button to the new ID etc (or downgrade)
			- For normal spells though it seems nothing extra needs to be done
			- How to detect an upgrade to a spell from a talent
				- The base Spellname into GetSpellInfo does not return the same named spell
				- We can then use the returned SpellID to check if it is one of our spell upgrades (via a static list... :S)
			- How to detect a downgrade from the talent version back to the original
				- Not fool proof, but does the GetSpellInfo with name passed return anything
				- Is the SpellID in our list of talent upgrades
				- If we had a spec switch, then it isn't exactly a downgrade, but it's still allowable
				  to downgrade the spell, as it will upgrade again when relevant to do so
			- An extra note here, sometimes different talents might have the same base spell
				- There are certain cases where a downgrade should be checked for an upgrade again
		
		* Actual rules used
			- Check for upgrades and downgrades to get the correct spell/talent/specialization spell
			- If Talent use the name for casting and hope for the best
			- If other use SpellID to cast
			
			- Where the API functions properly work with SpellID use that
			- For slightly temperamental API functions try the index
			- It's worth noting, that only available spells will work off of Index (same applies with using Name)
		
--------------------------------------------------]]
function ScriptsSpell.UpdateAction(BFButton, Reprocessed)
	
	local Update = false;
	local SpellFullName = Util.SpellFullName(BFButton.SpellFullName);
	local BaseSpellID = Util.LookupBaseSpellID(BFButton.SpellID);
	
	-- Do we need to upgrade the spell
	if (SpellFullName and BFButton.SpellFullName ~= SpellFullName) then
		
		local ReplacementSpellID = select(7, GetSpellInfo(SpellFullName));
		if (BFButton.SpellID == Util.LookupBaseSpellID(ReplacementSpellID)) then
			Update = true;
			BFButton.SpellID = ReplacementSpellID;
			BFButton.SpellFullName = SpellFullName;
		end
	
	-- Do we need to downgrade the spell instead
	elseif (SpellFullName == nil and BaseSpellID and not Reprocessed) then

		Update = true;
		BFButton.SpellID = BaseSpellID;
		BFButton.SpellFullName = Util.SpellFullName(BaseSpellID);
		
		-- Reprocess to check if we need to reupgrade it (perhaps that should instead be turned into a local block??)
		-- Note that Base spell would not drop down into this code block again! but just in case I added a flag...
		return ScriptsSpell.UpdateAction(BFButton, true)
	end
	
	if (Util.IsSpellTalent(BFButton.SpellID)) then
		BFButton.ABW:SetAttribute("spell", BFButton.SpellFullName);
	else
		BFButton.ABW:SetAttribute("spell", BFButton.SpellID);
	end
	
	if (Update and not Reprocessed) then
		local Action = BFButton.Action;
		Action.SpellID = BFButton.SpellID;
		Action.SpellFullName = BFButton.SpellFullName;
		Core.ReportEvent(BFButton, C.EVENT_UPDATEACTION, Action);
	end
	
end


--[[------------------------------------------------
	Full Update
--------------------------------------------------]]
function ScriptsSpell.FullUpdate(BFButton)
	BFButton.SpellIndex = Util.LookupSpellIndex(BFButton.SpellID) or 0;
	BFButton:UpdateIcon();
	BFButton:UpdateChecked();
	BFButton:UpdateUsable();
	BFButton:UpdateCooldown();
	BFButton:UpdateText();
	BFButton:UpdateGlow();
	BFButton:UpdateFlashRegistration();
	BFButton:UpdateRangeRegistration();
	
	if (GetMouseFocus() == BFButton.ABW) then
		BFButton.ABW:UpdateTooltip();
	end
end


--[[------------------------------------------------
	Icon
	Notes:
		* v6 of WoW
			* SpellBookItemTexture was used to get the modified texture (some spells changed texture during play)
			
		* v7 of WoW
			* Switched to using just the SpellID with GetSpellTexture, this is more reliable
				It remains to be seen if spells still modify textures (I'm no longer aware of any, Warlock used to have some in v6)
--------------------------------------------------]]
function ScriptsSpell.UpdateIcon(BFButton)
	--local Texture = GetSpellBookItemTexture(BFButton.SpellFullName or "") or GetSpellTexture(BFButton.SpellID) or C.QUESTION_MARK;
	local Texture = GetSpellTexture(BFButton.SpellID) or C.QUESTION_MARK;
	BFButton.ABWIcon:SetTexture(Texture);
end


--[[------------------------------------------------
	Checked
	Notes:
		* WoW v7
			* Tidy up
				* Removed check for AutoRepeatSpells (I dont believe they are still a thing)
--------------------------------------------------]]
function ScriptsSpell.UpdateChecked(BFButton)
	if (IsCurrentSpell(BFButton.SpellID)) then
		BFButton.ABW:SetChecked(true);
	else
		BFButton.ABW:SetChecked(false);
	end
end


--[[------------------------------------------------
	Usable
	* WoW v7
		* Use SpellFullName
			Talents even when not selected will still report usable if SpellID is used here
--------------------------------------------------]]
function ScriptsSpell.UpdateUsable(BFButton)
	--Core.UpdateButtonUsable(BFButton, IsUsableSpell(BFButton.SpellFullName));
	Core.UpdateButtonUsable(BFButton, IsUsableSpell(BFButton.SpellID));
end


--[[------------------------------------------------
	Cooldown
	Notes:
		* v7 of WoW
			* Does not do Loss Of Control effect (this effect seemed to annoy players)
--------------------------------------------------]]
function ScriptsSpell.UpdateCooldown(BFButton)
	local Cooldown = BFButton.ABWCooldown;
	local Start, Duration, Enable = GetSpellCooldown(BFButton.SpellID);
	local Charges, MaxCharges, ChargeStart, ChargeDuration = GetSpellCharges(BFButton.SpellID);
	local Alpha = Cooldown:SetSwipeColor(0, 0, 0, Alpha);	-- eventually I may need to make this obey the current color!!!
	local DrawSwipe, DrawBling, DrawEdge = true, false, false;
	
	if (Charges and MaxCharges and MaxCharges > 1 and Charges < MaxCharges) then
		StartChargeCooldown(BFButton.ABW, ChargeStart, ChargeDuration);	-- A Blizz ActionButton function
	else
		ClearChargeCooldown(BFButton.ABW);								-- A Blizz ActionButton function
	end
	
	CooldownFrame_Set(Cooldown, Start, Duration, Enable);				-- A Blizz function
end


--[[------------------------------------------------
	Text	(Charges, or Counts)
	Notes:
		* WoW v7
			* Tidy up
				* Removed IsConsumableSpell check (does not appear to be a thing anymore?)
			* Example
				* Arcane Missiles (Mage) of a Spell with SpellCount
--------------------------------------------------]]
function ScriptsSpell.UpdateText(BFButton)
	local Count = GetSpellCount(BFButton.SpellID);
	if (Count ~= 0) then
		BFButton.ABWCount:SetText(Count);
		return;
	end

	local Charges, MaxCharges = GetSpellCharges(BFButton.SpellID);
	if (Charges ~= nil and MaxCharges > 1) then
		BFButton.ABWCount:SetText(Charges);
		return;
	end
	BFButton.ABWCount:SetText(nil);
end


--[[------------------------------------------------
	Glow
	Notes:
		* WoW v7
			* Example
				* Arcane Missiles (Mage)
--------------------------------------------------]]
function ScriptsSpell.UpdateGlow(BFButton)
	if (IsSpellOverlayed(BFButton.SpellID)) then
		ActionButton_ShowOverlayGlow(BFButton.ABW);
	else
		ActionButton_HideOverlayGlow(BFButton.ABW);
	end
end


--[[------------------------------------------------
	Tooltip
--------------------------------------------------]]
function ScriptsSpell.UpdateTooltip(ABW)
	GameTooltip_SetDefaultAnchor(GameTooltip, ABW);
	GameTooltip:SetSpellByID(ABW.BFButton.SpellID);
end


--[[------------------------------------------------
	Flash	(registers and Deregisters for flash)
	Notes:
		* WoW v7
			* IsAttackSpell does not work with SpellID, so we need to use SpellFullName here
			* Tidy up
				* Removed check for AutoRepeatSpells (I dont believe they are still a thing)
--------------------------------------------------]]
function ScriptsSpell.UpdateFlashRegistration(BFButton)
	local IsFlashing = IsAttackSpell(BFButton.SpellIndex, BOOKTYPE_SPELL) and IsCurrentSpell(BFButton.SpellID);
	Core.UpdateButtonFlashRegistration(BFButton, IsFlashing);
end


--[[------------------------------------------------
	Range Registration
	Notes:
		* WoW v7
			* IsSpellInRange does not work with SpellID, so we need to use SpellFullName here
--------------------------------------------------]]
function ScriptsSpell.UpdateRangeRegistration(BFButton)
	Core.UpdateButtonRangeRegistration(BFButton, IsSpellInRange(BFButton.SpellIndex, BOOKTYPE_SPELL, BFButton.Target));
end


--[[------------------------------------------------
	Range Check
	Notes:
		* WoW v7
			* IsSpellInRange does not work with SpellID, so we need to use SpellFullName here
--------------------------------------------------]]
function ScriptsSpell.CheckRange(BFButton)
	Core.UpdateButtonRangeIndicator(BFButton, IsSpellInRange(BFButton.SpellIndex, BOOKTYPE_SPELL, BFButton.Target));
end


--[[------------------------------------------------
	Cursor
--------------------------------------------------]]
function ScriptsSpell.GetCursor(BFButton)
	return "spell", nil, nil, BFButton.SpellID;
end

