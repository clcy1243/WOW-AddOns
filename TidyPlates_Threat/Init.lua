--------------------------------------------------------------------------------------------------------
--                                          Localized global                                          --
--------------------------------------------------------------------------------------------------------
local _G = getfenv(0)

--------------------------------------------------------------------------------------------------------
--                                           AceAddon init                                            --
--------------------------------------------------------------------------------------------------------
local MODNAME, ns = ...
local t = LibStub("AceAddon-3.0"):NewAddon(MODNAME, "AceConsole-3.0", "AceEvent-3.0")
ns.TidyPlates_Threat = t

local L = LibStub("AceLocale-3.0"):GetLocale(MODNAME)
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDB = LibStub("AceDB-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")

t.L = L
t.Media = LibStub("LibSharedMedia-3.0")
t.MediaWidgets = Media and LibStub("AceGUISharedMediaWidgets-1.0", false)

-- Totems
local function tL(number)
	local name = GetSpellInfo(number)
	if not name then
		print("Missing totem spell ID " .. number)
		return ""
	end
	return name
end

local function sort_by_key(hash)
	local a = {}
	local ordered = {}
	for n in pairs(hash) do table.insert(a, n) end
	table.sort(a)
	for i, n in ipairs(a) do ordered[n] = i end
	return ordered
end

t.Totems = {
	[tL(  5394)] =  "T1", -- Healing Stream Totem
	[tL( 51485)] =  "T2", -- Earthgrab Totem
	[tL( 61882)] =  "T3", -- Earthquake Totem
	[tL( 98008)] =  "T4", -- Spirit Link Totem
	[tL(108280)] =  "T5", -- Healing Tide Totem
	[tL(157153)] =  "T6", -- Cloudburst Totem - Talent
	[tL(192058)] =  "T7", -- Lightning Surge Totem
	[tL(192077)] =  "T8", -- Wind Rush Totem
	[tL(192222)] =  "T9", -- Liquid Magma Totem - Talent
	[tL(196932)] = "T10", -- Voodoo Totem
	[tL(198838)] = "T11", -- Earthen Shield Totem - Talent
	[tL(204330)] = "T12", -- Skyfury Totem - PVP
	[tL(204331)] = "T13", -- Counterstrike Totem - PVP
	[tL(204332)] = "T14", -- Windfury Totem - PVP
	[tL(204336)] = "T15", -- Grounding Totem - PVP
	[tL(207399)] = "T16", -- Ancestral Protection Totem - Talent
--	[tL(210643)] = "", -- Totem Mastery - Talent
	[tL(202188)] = "T11", -- Resonance Totem - Talent
	[tL(210651)] = "T17", -- Storm Totem - Talent
	[tL(210657)] = "T18", -- Ember Totem - Talent
	[tL(210660)] = "T19", -- Tailwind Totem - Talent
}
t.TotemsOrder = sort_by_key(t.Totems)

-- Schedule a function to run later
do
	local OnUpdateDelay = 0
	local ScheduledList = {}

	local function OnUpdate(this, delay)
		OnUpdateDelay = OnUpdateDelay + delay
		if OnUpdateDelay < 0.08 then
			return
		end
		OnUpdateDelay = 0

		local now = GetTime()
		for func, expiration in pairs(ScheduledList) do
			if expiration < now then
				func()
				ScheduledList[func] = nil
			end
		end
	end

	local Watcherframe = CreateFrame("frame")
	Watcherframe:SetScript("OnUpdate", OnUpdate)

	function Schedule(func, expiration)
		ScheduledList[func] = expiration
	end

	t.Schedule = Schedule
end

-- Returns a function, that, as long as it continues to be invoked, will not
-- be triggered until `wait` has passed since last trigger.
local function Debounce(func, wait)
	local last = 0
	return function ()
		local now = GetTime()
		local triggerAt = last + wait

		if (triggerAt < now) then
			last = now
			return func()
		else
			t.Schedule(func, triggerAt)
		end
	end
end
t.Debounce = Debounce

-- General Functions
t.Update = Debounce(function()
	TidyPlates:ForceUpdate()
	TidyPlates:ResetWidgets()
end, 0.4)
t.Meta = function(value)
	local meta
	if value == "titleColored" then
		meta = "Tidy Plates: |cff89f559Threat|r"
	else
		meta = GetAddOnMetadata(MODNAME, value)
	end
	return meta or ""
end
t.Class = function()
	local _,class = UnitClass("Player")
	return class
end
t.Active = function()
	local val = GetSpecialization()
	return val
end
t.ActiveText = function()
	local specIndex = t.Active()
	local id, name, description, texture, role, class = GetSpecializationInfo(specIndex)
	if (id) then
		return name
	else
		return L["unknown"]
	end
end
t.ActiveInfo = function()
	local specIndex = t.Active()
	local id, name, description, texture, role, class = GetSpecializationInfo(specIndex)
	if (id) then
		return specIndex, id, name, role
	else
		return specIndex, nil, '', ''
	end
end
t.IsFriend = function(unitid)
	if unitid then
		return not UnitCanAttack("player", unitid)
	else
		return false
	end
end

do
	t.HCC = {}
	for i=1,#CLASS_SORT_ORDER do
		local str = RAID_CLASS_COLORS[CLASS_SORT_ORDER[i]].colorStr;
		local str = gsub(str,"(ff)","",1)
		t.HCC[CLASS_SORT_ORDER[i]] = str;
	end
end
-- Helper Functions
t.STT = function(...)
	local s = {}
	local i, l
	for i = 1, select("#", ...) do
		l = select(i, ...)
		if l ~= "" then
			s[l] = true
		end
	end
	return s
end
t.TTS = function(s)
	local list
	for i=1,#s do
		if not list then
			list = tostring(s[i]).."\n"
		else
			local nL = s[i]
			if nL ~= "" then
				list = list..tostring(nL).."\n"
			else
				list = list..tostring(nL)
			end
		end
	end
	return list
end
t.CopyTable = function(input)
	local output = {}
	for k,v in pairs(input) do
		if type(v) == "table" then
			output[k] = t.CopyTable(v)
		else
			output[k] = v
		end
	end
	return output
end
-- Constants
t.Art = "Interface\\Addons\\TidyPlates_Threat\\Artwork\\"
t.Widgets = "Interface\\Addons\\TidyPlates_Threat\\Artwork\\Widgets\\"
t.FullAlign = {TOPLEFT = "TOPLEFT",TOP = "TOP",TOPRIGHT = "TOPRIGHT",LEFT = "LEFT",CENTER = "CENTER",RIGHT = "RIGHT",BOTTOMLEFT = "BOTTOMLEFT",BOTTOM = "BOTTOM",BOTTOMRIGHT = "BOTTOMRIGHT"}
t.AlignH = {LEFT = "LEFT", CENTER = "CENTER", RIGHT = "RIGHT"}
t.AlignV = {BOTTOM = "BOTTOM", CENTER = "CENTER", TOP = "TOP"}
t.FontStyle = {
	NONE = L["None"],
	OUTLINE = L["Outline"],
	THICKOUTLINE = L["Thick Outline"],
	["NONE, MONOCHROME"] = L["No Outline, Monochrome"],
	["OUTLINE, MONOCHROME"] = L["Outline, Monochrome"],
	["THICKOUTLINE, MONOCHROME"] = L["Thick Outline, Monochrome"]
}
t.DebuffMode = {
	["whitelist"] = L["White List"],
	["blacklist"] = L["Black List"],
	["whitelistMine"] = L["White List (Mine)"],
	["blacklistMine"] = L["Black List (Mine)"],
	["all"] = L["All Auras"],
	["allMine"] = L["All Auras (Mine)"]
}
