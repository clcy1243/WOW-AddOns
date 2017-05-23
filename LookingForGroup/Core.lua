local LookingForGroup = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup")
--------------------------------------------------------------------------------------

function LookingForGroup:OnEnable()
	local profile = self.db.profile
	if profile.enable_wq then
		LoadAddOn("LookingForGroup_WQ")
	end
	if profile.enable_icon then
		LoadAddOn("LookingForGroup_Icon")
	end
	if profile.enable_hook then
		LoadAddOn("LookingForGroup_Hook")
	end
	if profile.enable_event then
		LoadAddOn("LookingForGroup_Event")
	end
	if profile.enable_av then
		LoadAddOn("LookingForGroup_AV")
	end
end
