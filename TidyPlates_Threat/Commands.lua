local _,ns = ...
local t = ns.TidyPlates_Threat
local L = t.L

local function TPTPOVERLAP()
	local _, build = GetBuildInfo()
	if tonumber(build) > 13623 then
		if GetCVar("nameplateMotion") == "3" then
			if InCombatLockdown() then
				t.Print("We're unable to change this while in combat")
			else
				SetCVar("nameplateMotion", 1)
				t.Print(L["-->>Nameplate Overlapping is now |cffff0000OFF!|r<<--"])
			end
		else
			if InCombatLockdown() then
				t.Print("We're unable to change this while in combat")
			else
				SetCVar("nameplateMotion", 3)
				t.Print(L["-->>Nameplate Overlapping is now |cff00ff00ON!|r<<--"])
			end
		end
	else
		if GetCVar("spreadnameplates") == "0" then
			t.Print(L["-->>Nameplate Overlapping is now |cff00ff00ON!|r<<--"])
		else
			t.Print(L["-->>Nameplate Overlapping is now |cffff0000OFF!|r<<--"])
		end
	end
end
SLASH_TPTPOVERLAP1 = "/tptpol"
SlashCmdList["TPTPOVERLAP"] = TPTPOVERLAP
local function TPTPVERBOSE()
	if TidyPlatesThreat.db.profile.verbose then
		t.Print(L["-->>Verbose is now |cffff0000OFF!|r<<-- shhh!!"])
	else
		t.Print(L["-->>Verbose is now |cff00ff00ON!|r<<--"], true)
	end
	TidyPlatesThreat.db.profile.verbose = not TidyPlatesThreat.db.profile.verbose
end
SLASH_TPTPVERBOSE1 = "/tptpverbose"
SlashCmdList["TPTPVERBOSE"] = TPTPVERBOSE
