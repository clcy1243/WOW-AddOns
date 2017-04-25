--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local Locales = Engine.Locales;

local C = Engine.Constants;
Locales["enUS"] = {};

local L = Locales["enUS"];
L.__index = L;				-- This line is only needed for the enUS (primary) locale

L[C.WARNING_EQUIPMENTSET_NAME]	= "Button Forge: Equipment set name cannot start/end with space.";

