--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014
	
	Desc:	Monitor and respond to events that alter the visuals for Buttons
			As a general rule updating of Buttons will route through the
			Updater.OnUpdate
]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local Events = Engine.Events;

local Core = Engine.Core;
local Cursor = Engine.Cursor;
local C = Engine.Constants;
local Util = Engine.Util;


local Checked 	= CreateFrame("FRAME");
local Usable 	= CreateFrame("FRAME");
local Cooldown 	= CreateFrame("FRAME");
local Equipped 	= CreateFrame("FRAME");
local Text 		= CreateFrame("FRAME");
local Glow 		= CreateFrame("FRAME");
local Macro 	= CreateFrame("FRAME");
local Flash		= CreateFrame("FRAME");
local Range		= CreateFrame("FRAME");
local Misc 		= CreateFrame("FRAME");		--, nil, nil, "SecureHandlerStateTemplate");
Macro:SetFrameStrata("BACKGROUND");
Macro:SetFrameLevel(1);
Misc:SetFrameStrata("BACKGROUND");
Misc:SetFrameLevel(2);


--[[------------------------------------------------
	Updater
	Desc:	Primarily an OnUpdate is used to coordinate
			The updating of the Buttons
--------------------------------------------------]]
Events.Updater = CreateFrame("FRAME");
local Updater = Events.Updater;
Updater:SetFrameStrata("BACKGROUND");
Updater:SetFrameLevel(3);

function Updater:OnUpdate(Elapsed)
	if (self.DoRefresh) then
		if (self.UpdateMacro) then
			Core.UpdateMacroAll();
			self.UpdateMacro = false;
		end
		Core.UpdateIconAll();			-- This might be heavy handed, hopefully the cost isn't really an issue though, otherwise specific events need to be determined
		if (self.UpdateChecked) then
			Core.UpdateCheckedAll();
			self.UpdateChecked = false;
		end
		if (self.UpdateUsable) then
			Core.UpdateUsableAll();
			self.UpdateUsable = false;
		end
		if (self.UpdateCooldown) then
			Core.UpdateCooldownAll();
			self.UpdateCooldown = false;
		end
		if (self.UpdateEquipped) then
			Core.UpdateEquippedAll();
			self.UpdateEquipped = false;
		end
		if (self.UpdateText) then
			Core.UpdateTextAll();
			self.UpdateText = false;
		end
		if (self.UpdateGlow) then
			Core.UpdateGlowAll();
			self.UpdateGlow = false;
		end
		if (self.UpdateFlyout) then
			Core.UpdateFlyoutAll();
			self.UpdateFlyout = false;
		end	
		if (self.UpdateFlashRegistration) then
			Core.UpdateFlashRegistrationAll();
			self.UpdateFlash = false;
		end
		if (self.UpdateRangeRegistration) then
			Core.UpdateRangeRegistrationAll();
			self.UpdateRange = false;
		end
		self.DoRefresh = false;
	end
end
Updater:SetScript("OnUpdate", Updater.OnUpdate);


--[[------------------------------------------------------------------------
	Checked Events
--------------------------------------------------------------------------]]
Checked:RegisterEvent("TRADE_SKILL_SHOW");
Checked:RegisterEvent("TRADE_SKILL_CLOSE");
Checked:RegisterEvent("ARCHAEOLOGY_TOGGLE");
Checked:RegisterEvent("ARCHAEOLOGY_CLOSED");
Checked:RegisterEvent("COMPANION_UPDATE");
Checked:RegisterEvent("PET_BATTLE_PET_CHANGED");
Checked:RegisterEvent("PET_ATTACK_START");
Checked:RegisterEvent("PET_ATTACK_STOP");
Checked:RegisterEvent("PET_BAR_UPDATE");
Checked:RegisterEvent("PET_BATTLE_PET_CHANGED");
Checked:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");
Checked:RegisterEvent("ACTIONBAR_UPDATE_STATE");		--I am not certain how excessive this event is yet, it may not be needed and is a canidate to remove
Checked:RegisterEvent("PLAYER_ENTER_COMBAT");
Checked:RegisterEvent("PLAYER_LEAVE_COMBAT");
Checked:RegisterEvent("START_AUTOREPEAT_SPELL");
Checked:RegisterEvent("STOP_AUTOREPEAT_SPELL");
Checked:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR");
Checked:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR");
Checked:RegisterEvent("ACTIONBAR_PAGE_CHANGED");

function Checked:OnEvent()
	Updater.UpdateChecked = true;
	Updater.DoRefresh = true;
end
Checked:SetScript("OnEvent", Checked.OnEvent);


--[[------------------------------------------------------------------------
	Usable Events
--------------------------------------------------------------------------]]
Usable:RegisterEvent("SPELL_UPDATE_USABLE");
Usable:RegisterEvent("PLAYER_CONTROL_LOST");
Usable:RegisterEvent("PLAYER_CONTROL_GAINED");
Usable:RegisterEvent("BAG_UPDATE");
Usable:RegisterEvent("MINIMAP_UPDATE_ZOOM");
Usable:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR");
Usable:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR");
Usable:RegisterEvent("ACTIONBAR_UPDATE_USABLE");	--Use this as a backup...
Usable:RegisterEvent("VEHICLE_UPDATE");
Usable:RegisterEvent("ACTIONBAR_PAGE_CHANGED");	
Usable:RegisterEvent("UPDATE_WORLD_STATES");	

function Usable:OnEvent()
	Updater.UpdateUsable = true;
	Updater.DoRefresh = true;
end
Usable:SetScript("OnEvent", Usable.OnEvent);


--[[------------------------------------------------------------------------
	Cooldown Events
--------------------------------------------------------------------------]]
Cooldown:RegisterEvent("SPELL_UPDATE_COOLDOWN");
Cooldown:RegisterEvent("BAG_UPDATE_COOLDOWN");
Cooldown:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
Cooldown:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN");

function Cooldown:OnEvent()
	Updater.UpdateCooldown = true;
	Updater.DoRefresh = true;
end
Cooldown:SetScript("OnEvent", Cooldown.OnEvent);


--[[------------------------------------------------------------------------
	Equipped Events
--------------------------------------------------------------------------]]
Equipped:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");

function Equipped:OnEvent()
	Updater.UpdateEquipped = true;
	Updater.DoRefresh = true;
end
Equipped:SetScript("OnEvent", Equipped.OnEvent);


--[[------------------------------------------------------------------------
	Text Events
--------------------------------------------------------------------------]]
Text:RegisterEvent("BAG_UPDATE");
Text:RegisterEvent("SPELL_UPDATE_CHARGES");
Text:RegisterEvent("UNIT_AURA");

function Text:OnEvent()
	Updater.UpdateText = true;
	Updater.DoRefresh = true;
end
Text:SetScript("OnEvent", Text.OnEvent);


--[[------------------------------------------------------------------------
	Glow Events
--------------------------------------------------------------------------]]
Glow:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW");
Glow:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE");

function Glow:OnEvent(Event, Arg1)
	Updater.UpdateGlow = true;
	Updater.DoRefresh = true;
end
Glow:SetScript("OnEvent", Glow.OnEvent);


--[[------------------------------------------------------------------------
	Flash Events
--------------------------------------------------------------------------]]
Flash:RegisterEvent("PLAYER_ENTER_COMBAT");
Flash:RegisterEvent("PLAYER_LEAVE_COMBAT");
Flash:RegisterEvent("START_AUTOREPEAT_SPELL");
Flash:RegisterEvent("STOP_AUTOREPEAT_SPELL");
Flash:RegisterEvent("PET_ATTACK_START");
Flash:RegisterEvent("PET_ATTACK_STOP");

function Flash:OnEvent()
	Updater.UpdateFlashRegistration = true;
	Updater.DoRefresh = true;
end
Flash:SetScript("OnEvent", Flash.OnEvent);


--[[------------------------------------------------------------------------
	Range Events
--------------------------------------------------------------------------]]
Range:RegisterEvent("PLAYER_TARGET_CHANGED");
Range:RegisterEvent("UNIT_FACTION");

function Range:OnEvent()
	Updater.UpdateRangeRegistration = true;
	Updater.DoRefresh = true;
end
Range:SetScript("OnEvent", Range.OnEvent);


--[[------------------------------------------------------------------------
	Macro Events (Events that signal a macro conditional may have changed)
--------------------------------------------------------------------------]]
Macro:RegisterEvent("MODIFIER_STATE_CHANGED");	--mod:
Macro:RegisterEvent("PLAYER_TARGET_CHANGED");		--harm, help, etc
Macro:RegisterEvent("PLAYER_FOCUS_CHANGED");		--harm, help, etc
Macro:RegisterEvent("ACTIONBAR_PAGE_CHANGED");	--actionbar
Macro:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR");
Macro:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR");
Macro:RegisterEvent("PLAYER_REGEN_ENABLED");		--nocombat
Macro:RegisterEvent("PLAYER_REGEN_DISABLED");		--combat
Macro:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");	--channel:
Macro:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");	--channel:
Macro:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");	--equipped:
Macro:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");	--spec:
Macro:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN");	--stance/form:
Macro:RegisterEvent("UPDATE_SHAPESHIFT_FORM");	--stance/form:
Macro:RegisterEvent("UPDATE_STEALTH");			--stealth
Macro:RegisterEvent("UNIT_ENTERED_VEHICLE");		--vehicleui
Macro:RegisterEvent("UNIT_EXITED_VEHICLE");		--vehicleui
Macro:RegisterEvent("MINIMAP_UPDATE_ZOOM");		--indoors/outdoors
Macro:RegisterEvent("ACTIONBAR_SLOT_CHANGED");	--This event is excessive, the system is designed not to need it; although at times it may provide slightly (very slightly) faster macro refreshes

--these following conditionals and targets are via the dynamic OnUpdate (yuck!)
--flyable
--flying
--mounted
--pet
--swimming
--group??part/raid
--mouseover	(help,harm etc)
function Macro:OnUpdate()
	if (UnitName("mouseover") ~= self.MOUnit or UnitIsDead("mouseover") ~= self.MOUnitDead) then
		self.MOUnit = UnitName("mouseover");
		self.MOUnitDead = UnitIsDead("mouseover");
		Updater.UpdateMacro = true;
		Updater.DoRefresh = true;
	end
	if (IsFlying() ~= self.IsFlying) then
		self.IsFlying = IsFlying();
		Updater.UpdateMacro = true;
		Updater.DoRefresh = true;
	end
	if (IsMounted() ~= self.IsMounted) then
		self.IsMounted = IsMounted();
		Updater.UpdateMacro = true;
		Updater.DoRefresh = true;
	end
	if (IsFlyableArea() ~= self.IsFlyableArea) then
		self.IsFlyableArea = IsFlyableArea();
		Updater.UpdateMacro = true;
		Updater.DoRefresh = true;
	end
end
--Macro:SetScript("OnUpdate", Macro.OnUpdate);



function Macro:OnEvent()
	Updater.UpdateMacro = true;
	Updater.DoRefresh = true;
end
Macro:SetScript("OnEvent", Macro.OnEvent);


--[[-------------------------------------------------------------------------
	Misc
	Desc: These are left over events that we still want to respond to, however
			they're expected less frequently and considered to not warrant an individual
			frame, in this case the event handler will inspect the event and determine
			what flags need to be set for the Updater to then process.
			OR
			In some cases the Misc Frame itself may temporarily active its Own
			OnUpdate to perform some functions - the Misc OnUpdate should fire before
			the Updater one by virtue of it's strata/level
---------------------------------------------------------------------------]]
Misc:RegisterEvent("BAG_UPDATE");
Misc:RegisterEvent("UNIT_INVENTORY_CHANGED");
Misc:RegisterEvent("PET_JOURNAL_LIST_UPDATE");
Misc:RegisterEvent("PET_SPECIALIZATION_CHANGED");
Misc:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
Misc:RegisterEvent("PLAYER_TALENT_UPDATE");
Misc:RegisterEvent("LOCALPLAYER_PET_RENAMED");
Misc:RegisterEvent("PET_BAR_UPDATE");
Misc:RegisterEvent("ADDON_ACTION_FORBIDDEN");
Misc:RegisterEvent("UNIT_PET");
Misc:RegisterEvent("UPDATE_MACROS");
Misc:RegisterEvent("EQUIPMENT_SETS_CHANGED");
Misc:RegisterEvent("PLAYER_REGEN_ENABLED");
Misc:RegisterEvent("CURSOR_UPDATE");
Misc:RegisterEvent("ACTIONBAR_SHOWGRID");
Misc:RegisterEvent("ACTIONBAR_HIDEGRID");
Misc:RegisterEvent("LEARNED_SPELL_IN_TAB");


--[[-------------------------------------------------------------------------
	* In reality this event doesn't seem to do much for things
	* The problem I was trying to solve is at first login GetItemInfo(ID) does not return info
	* I assuming this event would help, but it does not seem to fire even when the above call fails to retrieve info
	* That said, one of the other events that causes an ActionUpdate appears to happen after the info we need is available so in that regard the problem appears managed for now
---------------------------------------------------------------------------]]
function Events.WatchForItemInfoEvent()
	Misc:RegisterEvent("GET_ITEM_INFO_RECEIVED");
end

function Misc:OnEvent(Event, Arg1, ...)
	if (Event == "BAG_UPDATE") then
		Misc.UpdateBagCache = true;
	elseif (Event == "CURSOR_UPDATE") then
		if (GetCursorInfo() == "item") then
			Misc.CursorItemFlag = true;
			Misc.UpdateGrid = true;
		elseif (Misc.CursorItemFlag) then
			Misc.CursorItemFlag = false;
			Misc.UpdateGrid = true;
		end
	elseif (Event == "ACTIONBAR_SHOWGRID"
			or Event == "ACTIONBAR_HIDEGRID") then
		Misc.UpdateGrid = true;
	elseif (Event == "UNIT_INVENTORY_CHANGED") then
		Misc.UpdateInventoryCache = true;
	elseif (Event == "PET_JOURNAL_LIST_UPDATE") then
		Misc.FullUpdate = true;
	elseif ((Event == "UNIT_PET" and Arg1 == "player")
			or Event == "PET_SPECIALIZATION_CHANGED"
			or Event == "LOCALPLAYER_PET_RENAMED") then
		Misc.UpdateAction = true;
		Misc.FullUpdate = true;
	elseif (Event == "PET_BAR_UPDATE") then
		Misc.UpdateShine = true;
	elseif (Event == "UPDATE_MACROS") then
		Misc.UpdateAction = true;
		Misc.FullUpdate = true;
		-- Note the updater is theoretically setup to run after the Misc OnUpdate
		Updater.UpdateMacro = true;
		Updater.DoRefresh = true;
	elseif (Event == "PLAYER_TALENT_UPDATE"
			or Event == "ACTIVE_TALENT_GROUP_CHANGED") then
		Misc.UpdateAction = true;
		Misc.UpdateSpellIndexCache = true;
		Misc.FullUpdate = true;
	elseif (Event == "EQUIPMENT_SETS_CHANGED") then
		Misc.UpdateAction = true;
		Misc.FullUpdate = true;
	elseif (Event == "PLAYER_REGEN_ENABLED") then
		Misc.OutOfCombat = true;
	elseif (Event == "LEARNED_SPELL_IN_TAB") then
		Misc.UpdateSpellIndexCache = true;
		Misc.FullUpdate = true;
	elseif (event == "GET_ITEM_INFO_RECEIVED") then
		Misc.UpdateAction = true;
		Misc.FullUpdate = true;
		Misc:UnregisterEvent("GET_ITEM_INFO_RECEIVED");
	elseif (Event == "ADDON_ACTION_FORBIDDEN") then
		print(Event, Arg1, ...);
	end
	Misc:SetScript("OnUpdate", Misc.OnUpdate);
end
Misc:SetScript("OnEvent", Misc.OnEvent);


function Misc:OnUpdate()
	if (self.OutOfCombat) then
		self.OutOfCombat = false;
		Core.LeaveCombatUpdate();
	end
	if (self.UpdateBagCache) then
		self.UpdateBagCache = false;
		Util.CacheBagItems();
	end
	if (self.UpdateInventoryCache) then
		self.UpdateInventoryCache = false;
		Util.CacheInventoryItems();
	end
	if (self.UpdateSpellIndexCache) then
		self.UpdateSpellIndexCache = false;
		Util.CacheKnownSpells();
	end
	if (self.UpdateAction) then
		self.UpdateAction = false;
		Core.UpdateActionAll();
	end
	if (self.UpdateShine) then
		self.UpdateShine = false;
		Core.UpdateShineAll();
	end
	if (self.UpdateGrid) then
		self.UpdateGrid = false;
		Core.UpdateButtonShowHideAll();
		Core.ReportEvent(nil, C.EVENT_CURSORCHANGE, Cursor.GetCursor());
	end
	if (self.FullUpdate) then
		self.FullUpdate = false;
		Core.FullUpdateAll();
	end
	self:SetScript("OnUpdate", nil);
end





