local ADDON_NAME, namespace = ...
local L = namespace.L
local LOCALE = GetLocale()

-- TODO: Just an example of how this works...
-- Will add localized strings if users provide them
if LOCALE == "deDE" then
	L["Can Learn"] = "Can Learn"
	L["Transmog appearances that can be unlocked by the current toon"] = "Transmog appearances that can be unlocked by the current toon"
	L["Can Learn Other"] = "Can Learn Other"
return end
