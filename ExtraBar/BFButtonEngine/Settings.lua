--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local S = Engine.Settings;

S.ButtonDefaults = {};
S.ButtonDefaults.Action = {};
S.ButtonDefaults.Action.Type 		= "empty";
S.ButtonDefaults.FlyoutDirection	= "UP";
S.ButtonDefaults.KeyBindText		= "";
S.ButtonDefaults.Enabled			= true;
S.ButtonDefaults.RespondsToMouse	= true;
S.ButtonDefaults.Alpha				= 1.0;
S.ButtonDefaults.Locked				= false;
S.ButtonDefaults.AlwaysShowGrid		= true;
S.ButtonDefaults.ShowTooltip		= true;
S.ButtonDefaults.ShowKeyBindText	= true;
S.ButtonDefaults.ShowCounts			= true;
S.ButtonDefaults.ShowMacroName		= true;

S.OriginalButtonGroupDefaults = {};
S.OriginalButtonDefaults = {};

S.ActionKeyFunction	= _G["IsShiftKeyDown"];

S.DefaultButtonFrameNameFormat = "ButtonForge_Button_%i";
S.DefaultButtonSeq = 1;