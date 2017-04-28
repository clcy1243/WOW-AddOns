--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014
	
	Desc:	Util type functionality for the Button Engine

]]

--[[
	Line 75: function Util.SpellFullName(NameOrID)
	Line 100: function Util.IsSpellPrimary(SpellID)
	Line 108: function Util.IsSpellTalent(SpellID)
	Line 116: function Util.IsSpellSpecialization(SpellID)
	
	Line 131: function Util.LookupBaseSpellID(SpellID)
	Line 139: function Util.LookupSpellIndex(SpellID)
	Line 147: function Util.LookupFlyoutIndex(FlyoutID)
	Line 155: function Util.LookupFlyoutTexture(FlyoutID)
	Line 170: function Util.LookupTalentSpellID(Name, Specialization)
	Line 190: function Util.LookupSpecializationSpellID(Name, Specialization)
	
	Line 232: function Util.CacheKnownSpells()
	Line 264: function Util.CacheTalentSpellIDs()
	Line 310: function Util.CacheSpecializationSpellIDs()
	
	Line 336: function Util.GetItemIDFromHyperlink(link)
	Line 344: function Util.LookupItemInventorySlot(ItemID)
	Line 352: function Util.LookupItemBagSlot(ItemID)
	
	Line 368: function Util.CacheInventoryItems()
	Line 390: function Util.CacheBagItems()
	
	Line 409: function Util.LookupMountIndex(MountID)
	Line 425: function Util.LookupEquipmentSetIndex(EquipmentSetID)
	
	Line 439: function Util.GetLocaleString(Value)
	Line 447: function Util.GetDefaultButtonFrameName()
	Line 460: function Util.NoCombatAndValidButtonTest(ActionButton)
	
	Line 472: function Util.FindInTable(Table, Value, Start)
	Line 485: function Util.FindInTableWhere(Table, Delegate)
	Line 497: function Util.RemoveFromTable(Table, Value, Start)
	Line 510: function Util.ClearTable(Table)
	Line 520: function Util.FindInPairs(Table, Value)
	Line 533: function Util.TableAddUnsetKeys(Table, AddTable)
	Line 545: function Util.Count(Table)
	Line 560: function DeepCopy(orig)
]]


local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local Util = Engine.Util;

local S = Engine.Settings;
local C = Engine.Constants;
local SR = Engine.SpellReplacements;



local L = Engine.Locales[GetLocale()] or {};
if (GetLocale() ~= "enUS") then
	setmetatable(L, Engine.Locales["enUS"]);
end


-- local Cache tables
local SpellIDToIndex;
local FlyoutIDToIndex;
local FlyoutTextures;
local TalentSpellIDs;
local TalentNameSpellIDs;
local SpecializationSpellIDs;
local SpecializationNameSpellIDs;
local ItemBagSlot;
local ItemInventorySlot;



function Util.SpellFullName(NameOrID)

	local Name, Rank = GetSpellInfo(NameOrID);
	if (Name and Rank) then
		return Name.."("..Rank..")";
	end
	return nil;
	
end



--[[------------------------------------------------
	* Should only be called if it's a Known Spell (use LookupSpellIndex)
	
	Wow v7.0.3
		* There are cases where the player has multiple spells with the same name
		* This will identify the non-primaries by testing the SpellID returned
		  when using the SpellFullName
		 * Expectation is that the SpellID returned by name is the primary

		* e.g.
			- Modified Shaman Hex(s)
			- Death Knight Obliterate (Frost specialization) and Obliteration (Frost Talent), when language is Russian the same name is used
--------------------------------------------------]]
function Util.IsSpellPrimary(SpellID)

	return select(7, GetSpellInfo(Util.SpellFullName(SpellID))) == SpellID;
	
end



function Util.IsSpellTalent(SpellID)

	return TalentSpellIDs[SpellID] or false;
	
end



function Util.IsSpellSpecialization(SpellID)

	return SpecializationSpellIDs[SpellID] or false;
	
end



--[[------------------------------------------------
	Wow v7.0.3
		* Some Talents replace a Spell
		* Those replaced Spells actually need to be upgraded (and or downgraded)
		* The only way to manage this is with a hardcoded list :/
		* Returns nothing if it doesn't have a base spell
--------------------------------------------------]]
function Util.LookupBaseSpellID(SpellID)

	return SR[SpellID];
	
end



function Util.LookupSpellIndex(SpellID)

	return SpellIDToIndex[SpellID];
	
end



function Util.LookupFlyoutIndex(FlyoutID)

	return FlyoutIDToIndex[FlyoutID];

end



function Util.LookupFlyoutTexture(FlyoutID)

	return FlyoutTextures[FlyoutID];

end



--[[------------------------------------------------
	WoW v7.0.3
		* Sometimes two talents can have the same name but be slightly different
		  based on which specilization ergo the specialization should ideally be specified
		* e.g. Of Talent Name repeat
			- Priest MindBender, Discipline and Holy
--------------------------------------------------]]
function Util.LookupTalentSpellID(Name, Specialization)
	
	Name = string.gsub(Name or "", "%([^%(%)]*%)$", "");	-- Strip off end bracketing
	
	if (Specialization) then
		return TalentNameSpellIDs[Specialization][Name];
	end
	
	for i = 1, GetNumSpecializations() do
		local SpellID = TalentNameSpellIDs[i][Name];
		if (SpellID) then
			return SpellID;
		end
	end
	return nil;
	
end



function Util.LookupSpecializationSpellID(Name, Specialization)
	
	Name = string.gsub(Name or "", "%([^%(%)]*%)$", "");	-- Strip off end bracketing
	
	if (Specialization) then
		return SpecializationNameSpellIDs[Specialization][Name];
	end
	
	for i = 1, GetNumSpecializations() do
		local SpellID = SpecializationNameSpellIDs[i][Name];
		if (SpellID) then
			return SpellID;
		end
	end
	return nil;
	
end



--[[------------------------------------------------
	WoW v7.0.3
		* The first two tabs contain spells we can currently use
		* It turns out that in addition there is also hidden space
		  Between some tabs that contain additional spells we might be interested in
		  e.g. spells that appear ON the flyouts
		* Ergo We Cache upto the start of Tab 3
		
		* Not sure how hunter traps behave as some that appear on the flyout can also be replaced
		  by a talent version (and I have yet to level my hunter to 60, close though...)
		
		* There is some tomfoolery with Revive / Mend pet (perhaps others)
			- They replace each other dependant on dead/alive pet
			- They exist between tabs 2 and 3 in the spellbook
			- They swap index places dependant on which is the active ability...
			- This particular scenario does not require special handling fortunately as we can keep pointing to the same index
			- In essence it really is just some behaviour to observe rather than respond to.
			
		* This will need re-caching each time our talents and or spec changes
		
		* Note we also capture Flyout textures
--------------------------------------------------]]
function Util.CacheKnownSpells()

	SpellIDToIndex = {};
	FlyoutIDToIndex = {};
	FlyoutTextures = {};
	
	local TabThreeStart = select(3, GetSpellTabInfo(3));
	for i = 1, TabThreeStart - 1 do
	
		local Type, SpellID = GetSpellBookItemInfo(i, BOOKTYPE_SPELL);
		if (Type == "SPELL" and not SpellIDToIndex[SpellID]) then
			SpellIDToIndex[SpellID] = i;
		elseif (Type == "FLYOUT") then
			FlyoutIDToIndex[SpellID] = i;
			FlyoutTextures[SpellID] = GetSpellBookItemTexture(i, BOOKTYPE_SPELL);
		end
		
	end
	
end
Util.CacheKnownSpells();



--[[------------------------------------------------
	WoW v7.0.3
		* Get all Talents for all specs
		* Also collect up PvP Talents, I have yet to
		  Test those :S
		
		* Only needs to be cached once
--------------------------------------------------]]
function Util.CacheTalentSpellIDs()

	TalentSpellIDs = {};
	TalentNameSpellIDs = {};
	local TalentInfoFuncs = {GetTalentInfoBySpecialization, GetPvpTalentInfoBySpecialization};

	-- Scan both normal and PvP talents for all specs
	-- Note rather than assume number of talents, we just scan till the rows and columns till we hit a nil
	for s = 1, GetNumSpecializations() do
		TalentNameSpellIDs[s] = {};
		for _, TalentInfoFunc in ipairs(TalentInfoFuncs) do
			local r = 1;
			local c = 1;
			local _, TalentName, _, _, _, TalentSpellID = TalentInfoFunc(s, r, c);
			while (TalentSpellID) do
				while (TalentSpellID) do
					TalentSpellIDs[TalentSpellID] = true;
					TalentNameSpellIDs[s][TalentName] = TalentSpellID;		-- seriously if we have name collisions within a spec... well blast!!
					c = c + 1;
					_, TalentName, _, _, _, TalentSpellID = TalentInfoFunc(s, r, c);
				end
				r = r + 1;
				c = 1;
				_, TalentName, _, _, _, TalentSpellID = TalentInfoFunc(s, r, c);
			end
		end
	end
	
	--for i = 1, 3 do
	--	for k, v in pairs(TalentNameSpellIDs[i]) do
	--		print(i, k, v);
	--	end
	--end
	
end
Util.CacheTalentSpellIDs();



--[[------------------------------------------------
	WoW v7.0.3
		* GetSpecializationSpells returns a table
		  where the odd indice is the SpellID
		  and the next indice is level learned
		* Ergo we skip every second indice
--------------------------------------------------]]
function Util.CacheSpecializationSpellIDs()

	SpecializationSpellIDs = {};
	SpecializationNameSpellIDs = {};
	
	for s = 1, GetNumSpecializations() do
		SpecializationNameSpellIDs[s] = {};
		local t = {GetSpecializationSpells(s)};
		for i = 1, #t, 2 do
			local SpellID = t[i];
			SpecializationSpellIDs[SpellID] = true;
			local SpellName = GetSpellInfo(t[i]);
			if (SpellName) then
				SpecializationNameSpellIDs[s][SpellName] = SpellID;
			end
		end
	end
	
end
Util.CacheSpecializationSpellIDs();



--[[------------------------------------------------
	* Copied from Blizz code
--------------------------------------------------]]
function Util.GetItemIDFromHyperlink(link)

	return tonumber(link:match("|Hitem:(%d+)"));
	
end



function Util.LookupItemInventorySlot(ItemID)

	return ItemInventorySlot[ItemID];
	
end



function Util.LookupItemBagSlot(ItemID)
	local Result = ItemBagSlot[ItemID];
	if (Result) then
		return Result[1], Result[2];
	end
	return nil, nil;
end



--[[------------------------------------------------
	WoW v???
		* note that reverse order matches how Bliz
		  Default operates if same item type is in
		  multiple slots
--------------------------------------------------]]
function Util.CacheInventoryItems()

	ItemInventorySlot = {};
	
	for Slot = INVSLOT_LAST_EQUIPPED, INVSLOT_FIRST_EQUIPPED, -1 do
		ItemID = GetInventoryItemID("player", Slot);
		if (ItemID) then
			ItemInventorySlot[ItemID] = Slot;
		end
	end
	
end
Util.CacheInventoryItems();



--[[------------------------------------------------
	WoW v???
		* note that reverse order matches how Bliz
		  Default operates if same item type is in
		  multiple slots
--------------------------------------------------]]
function Util.CacheBagItems()

	ItemBagSlot = {};

	for Bag = NUM_BAG_SLOTS, 0, -1 do
		NumSlots = GetContainerNumSlots(Bag);
		for Slot = GetContainerNumSlots(Bag), 1, -1 do
			ItemID = GetContainerItemID(Bag, Slot);
			if (ItemID) then
				ItemBagSlot[ItemID] = {Bag, Slot};
			end
		end
	end

end
Util.CacheBagItems();



function Util.LookupMountIndex(MountID)

	local Num = C_MountJournal.GetNumMounts();
	if (MountID == C.SUMMON_RANDOM_FAVORITE_MOUNT_ID) then
		return 0;
	end
	for i = 1, Num do
		if (select(12, C_MountJournal.GetDisplayedMountInfo(i)) == MountID) then
			return i;
		end
	end
	
end



function Util.LookupEquipmentSetIndex(EquipmentSetID)

	local Total = GetNumEquipmentSets();
	for i = 1, Total do
		if (select(3, GetEquipmentSetInfo(i)) == EquipmentSetID) then
			return i;
		end
	end
	return nil;
	
end



function Util.GetLocaleString(Value)

	return L[Value];
	
end



function Util.GetDefaultButtonFrameName()

	local FrameName;
	repeat
		FrameName = string.format(S.DefaultButtonFrameNameFormat, S.DefaultButtonSeq);
		S.DefaultButtonSeq = S.DefaultButtonSeq + 1;
	until _G[FrameName] == nil;
	return FrameName;
	
end



function Util.NoCombatAndValidButtonTest(ActionButton)

	if (InCombatLockdown()) then
		return C.ERROR_IN_COMBAT_LOCKDOWN;
	elseif (not ActionButton.BFButton) then				-- If not a table, tough!
		return C.ERROR_NOT_BUTTONFORGE_ACTIONBUTTON;
	end
	
end



function Util.FindInTable(Table, Value, Start)

	for i = Start or 1, #Table do
		if (Table[i] == Value) then
			return i;
		end
	end
	return nil;
	
end



function Util.FindInTableWhere(Table, Delegate)

	for i = 1, #Table do
		if (Delegate(Table[i])) then
			return Table[i];
		end
	end
	
end



function Util.RemoveFromTable(Table, Value, Start)

	for i = Start or 1, #Table do
		if (Table[i] == Value) then
			return table.remove(Table, i);
		end
	end
	return nil;
	
end



function Util.ClearTable(Table)

	for k, v in pairs(Table) do
		Table[k] = nil;
	end
	
end



function Util.FindInPairs(Table, Value)

	for k, v in pairs(Table) do
		if (v == Value) then
			return k;
		end
	end
	return nil;
	
end



function Util.TableAddUnsetKeys(Table, AddTable)

	for k, v in pairs(AddTable) do
		if (Table[k] == nil) then
			Table[k] = v;
		end
	end
	
end



function Util.Count(Table)

	local Count = 0;
	for k, v in pairs(Table) do
		Count = Count + 1;
	end
	return Count;
	
end



--[[------------------------------------------------
	* Copy Pasta from http://lua-users.org/wiki/CopyTable
--------------------------------------------------]]
local function DeepCopy(orig)

    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[DeepCopy(orig_key)] = DeepCopy(orig_value)
        end
        setmetatable(copy, DeepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
	
end
Util.DeepCopy = DeepCopy;


