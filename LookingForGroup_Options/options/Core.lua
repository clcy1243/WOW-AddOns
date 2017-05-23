local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

LookingForGroup_Options:push("options",{
	name = OPTIONS,
	type = "group",
	args =
	{
		icon =
		{
			order = get_order(),
			name = EMBLEM_SYMBOL,
			type = "toggle",
			get = function(info)
				return LookingForGroup.db.profile.enable_icon
			end,
			set = function(info,val)
				LookingForGroup.db.profile.enable_icon = val
				if val then
					LoadAddOn("LookingForGroup_Icon")
				end
				local LookingForGroup_Icon = AceAddon:GetAddon("LookingForGroup_Icon")
				LookingForGroup_Icon:OnEnable()
			end
		},
		hook =
		{
			order = get_order(),
			name = "Hook",
			type = "toggle",
			get = function(info)
				return LookingForGroup.db.profile.enable_hook
			end,
			set = function(info,val)
				LookingForGroup.db.profile.enable_hook = val
				if val then
					LoadAddOn("LookingForGroup_Hook")
				end
				local LookingForGroup_Hook = AceAddon:GetAddon("LookingForGroup_Hook")
				LookingForGroup_Hook:OnEnable()
			end
		},
		event =
		{
			order = get_order(),
			name = "Event",
			type = "toggle",
			get = function(info)
				return LookingForGroup.db.profile.enable_event
			end,
			set = function(info,val)
				LookingForGroup.db.profile.enable_event = val
				if val then
					LoadAddOn("LookingForGroup_Event")
				end
				local LookingForGroup_Event = AceAddon:GetAddon("LookingForGroup_Event")
				LookingForGroup_Event:OnEnable()
			end
		},
	}
})
