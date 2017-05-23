local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")
local C_LFGList_ClearSearchResults = C_LFGList.ClearSearchResults

function LookingForGroup_Options:OnInitialize()
	local options = LookingForGroup_Options : get_table()
--	LookingForGroup_Options.option_table = nil
	self.db = LibStub("AceDB-3.0"):New("LookingForGroup_OptionsDB",
	{
		profile = 
		{
			spam_filter_keywords = {},
			cr_category = 1,
			a_group_category = 0,
			a_group_group = 0,
			a_group_activity = 0,
			start_a_group_title = "",
			start_a_group_details = "",
			start_a_group_minimum_item_level = 0,
			start_a_group_voice_chat = "",
			start_a_group_auto_accept = false,
			start_a_group_private = false,
			find_a_group_filter = "",
			find_a_group_encounters = {}
		}
	})
	options.args.profile = AceDBOptions:GetOptionsTable(self.db)
	AceConfig:RegisterOptionsTable("LookingForGroup", options, nil)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnEnable")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnEnable")
	self.db.RegisterCallback(self, "OnProfileReset", "OnEnable")
	self:RegisterEvent("LFG_LIST_SEARCH_FAILED")
	self:RegisterEvent("LFG_LIST_APPLICANT_UPDATED")
end

function LookingForGroup_Options:OnEnable()
	if LookingForGroup.db.profile.enable_qj then
		self:RegisterEvent("SOCIAL_QUEUE_UPDATE")
	else
		self:UnregisterEvent("SOCIAL_QUEUE_UPDATE")
	end
end

function LookingForGroup_Options:LFG_LIST_SEARCH_FAILED(...)
	LookingForGroup_Options:UnregisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
	C_LFGList_ClearSearchResults()
end

function LookingForGroup_Options:SOCIAL_QUEUE_UPDATE()
	AceConfigRegistry:NotifyChange("LookingForGroup")
end

function LookingForGroup_Options:RestoreDBVariable(key)
	self.db.profile[key] = self.db.defaults.profile[key]
end
