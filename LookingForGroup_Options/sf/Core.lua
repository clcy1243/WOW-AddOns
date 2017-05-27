local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")
local wipe = wipe
local pairs = pairs
local string_lower = string.lower
local string_gsub = string.gsub

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local select_tb = {}

LookingForGroup_Options:push("filter",{
	name = SPAM_FILTER,
	type = "group",
	args =
	{
		add =
		{
			name = ADD,
			type = "input",
			order = get_order(),
			set = function(_,val)
				local tb = LookingForGroup.db.profile.spam_filter_keywords
				tb[#tb+1] = string_lower(string_gsub(val," ",""))
			end,
			get = function()end,
			width = "full"
		},
		rmv =
		{
			name = REMOVE,
			type = "execute",
			order = get_order(),
			func = function()
				local profile = LookingForGroup.db.profile
				local spkt = profile.spam_filter_keywords
				local cp = {}
				local i
				local n = #spkt
				for i = 1,n do
					if select_tb[i]~=true then
						cp[#cp+1] = spkt[i]
					end
				end
				wipe(select_tb)
				profile.spam_filter_keywords = cp
			end
		},
		cancel =
		{
			name = CANCEL,
			type = "execute",
			order = get_order(),
			func = function() wipe(select_tb) end
		},
		filters_s =
		{
			name = FILTERS,
			type = "multiselect",
			order = get_order(),
			values = function() return LookingForGroup.db.profile.spam_filter_keywords end,
			set = function(_,key,val)
				if val then
					select_tb[key] = true
				else
					select_tb[key] = nil
				end
			end,
			get = function(_,key)
				return select_tb[key]
			end,
			width = "full",
		},
	}
})
