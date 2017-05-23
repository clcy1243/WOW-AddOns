local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local table_insert = table.insert

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local select_sup = {}
local results_table = {}

local tank_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:0:19:22:41|t"
local healer_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:1:20|t"
local damager_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:22:41|t"

local LFG_LIST_SEARCH_RESULTS_RECEIVED

function LookingForGroup_Options.do_wq_search()
	local quest_id = LookingForGroup_Options.db.profile.start_a_group_quest_id
	if quest_id ~= nil then
		local activityID, categoryID, filters, questName = LFGListUtil_GetQuestCategoryData(quest_id)
		if activityID ~= nil then
			LookingForGroup_Options:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED",LFG_LIST_SEARCH_RESULTS_RECEIVED)
			C_LFGList.Search(categoryID,questName,filters,C_LFGList.GetLanguageSearchFilter())
		end
	end
end

local function do_start()
	local quest_id = LookingForGroup_Options.db.profile.start_a_group_quest_id
	if quest_id ~= nil then
		local funcListing = C_LFGList.CreateListing
		if C_LFGList.GetActiveEntryInfo() then
			funcListing = C_LFGList.UpdateListing
		end
		local activityID = LFGListUtil_GetQuestCategoryData(quest_id)
		if activityID ~= nil then
			funcListing(activityID,
					"",
					0,
					0,
					"",
					"",
					true,
					false,
					quest_id)
			AceConfigDialog:SelectGroup("LookingForGroup","requests")
		end
	end
end

local wq_sr =
{
	name = KBASE_SEARCH_RESULTS,
	type = "group",
	childGroups = "tab",
	args =
	{
		Results =
		{
			name = KBASE_SEARCH_RESULTS,
			desc = LFG_LIST_SELECT_A_SEARCH_RESULT,
			type = "group",
			order = get_order(),
			args =
			{
				apply =
				{
					order = get_order(),
					name = " ",
					type = "multiselect",
					dialogControl = "LookingForGroup_Options_WQ_Multiselect",
					values = results_table,
					get = function(info,val)	return select_sup[val] end,
					width = "full",
				},
			}
		},
		Role =
		{
			name = ROLE,
			type = "group",
			order = get_order(),
			args =
			{
				tank = 
				{
					order = get_order(),
					name = tank_icon,
					desc = TANK,
					type = "toggle",
					get = function(info)
						return select(2,GetLFGRoles())
					end,
					set = function(info,val)
						local leader,tank,healer,damage = GetLFGRoles()
						SetLFGRoles(leader,val,healer,damage)
					end,
					width = "full",
				},
				healer = 
				{
					order = get_order(),
					name = healer_icon,
					desc = HEALER,
					type = "toggle",
					get = function(info)
						return select(3,GetLFGRoles())
					end,
					set = function(info,val)
						local leader,tank,healer,damage = GetLFGRoles()
						SetLFGRoles(leader,tank,val,damage)
					end,
					width = "full",
				},
				damage = 
				{
					order = get_order(),
					name = damager_icon,
					desc = DAMAGER,
					type = "toggle",
					get = function(info)
						return select(4,GetLFGRoles())
					end,
					set = function(info,val)
						local leader,tank,healer,damage = GetLFGRoles()
						SetLFGRoles(leader,tank,healer,val)
					end,
					width = "full",
				},
			}
		},
		sign_up =
		{
			order = get_order(),
			name = SIGN_UP,
			type = "execute",
			func = function()
				local k,v
				local apply_to_group = C_LFGList.ApplyToGroup
				local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
				local GetLFGRoles = GetLFGRoles
				local string_match = string.match
				local ApplyToGroup = LookingForGroup_Options.ApplyToGroup
				local tonumber = tonumber
				for k,v in pairs(select_sup) do
					if v then
						local id, activityID, name, comment, voiceChat, iLvl, honorLevel,
							age, numBNetFriends, numCharFriends, numGuildMates,
							isDelisted, leaderName, numMembers, autoaccept = C_LFGList_GetSearchResultInfo(k)
						ApplyToGroup(k, "", select(2,GetLFGRoles()))
					end
				end
			end
		},
		search_again = 
		{
			order = get_order(),
			name = LFG_LIST_SEARCH_AGAIN,
			type = "execute",
			func = LookingForGroup_Options.do_wq_search
		},
		back = 
		{
			order = get_order(),
			name = BACK,
			type = "execute",
			func = function()
				C_LFGList.ClearSearchResults()
				wipe(select_sup)
				LookingForGroup_Options.reset_search_result()
				AceConfigDialog:SelectGroup("LookingForGroup","wq")
			end
		},
		start = 
		{
			order = get_order(),
			name = START,
			type = "execute",
			func = do_start,
		},
	}
}

local get_search_result

LFG_LIST_SEARCH_RESULTS_RECEIVED = function()
	LookingForGroup_Options:UnregisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
	get_search_result()
	LookingForGroup_Options.set_search_result(wq_sr)
	AceConfigDialog:SelectGroup("LookingForGroup","search_result","Results")
end

LookingForGroup_Options:push("wq",{
	name = TRACKER_HEADER_WORLD_QUESTS,
	type = "group",
	args =
	{
		enable =
		{
			order = get_order(),
			name = ENABLE,
			type = "toggle",
			get = function(info)
				return LookingForGroup.db.profile.enable_wq
			end,
			set = function(info,val)
				LookingForGroup.db.profile.enable_wq = val
				if val then
					LoadAddOn("LookingForGroup_WQ")
				end
				local LookingForGroup_WQ = AceAddon:GetAddon("LookingForGroup_WQ")
				LookingForGroup_WQ:OnEnable()
			end,
		},
		quest_id =
		{
			order = get_order(),
			name = BATTLE_PET_SOURCE_2..ID,
			type = "input",
			get = function(info)
				local quest_id = LookingForGroup_Options.db.profile.start_a_group_quest_id
				if quest_id ~= nil then
					return tostring(quest_id)
				end
			end,
			pattern = "^[0-9]*$",
			set = function(info,val)
				local profile = LookingForGroup_Options.db.profile
				if val == "" then
					profile.start_a_group_quest_id = nil
				else
					profile.start_a_group_quest_id = val
				end
			end,
			width = "full"
		},
		quest_name =
		{
			order = get_order(),
			type = "description",
			name = function(info)
				local quest_id = LookingForGroup_Options.db.profile.start_a_group_quest_id
				if quest_id ~= nil then
					local activityID, categoryID, filters, questName = LFGListUtil_GetQuestCategoryData(quest_id)
					return questName
				end
			end,
		},
		search =
		{
			order = get_order(),
			name = SEARCH,
			type = "execute",
			func = LookingForGroup_Options.do_wq_search
		},
		cancel =
		{
			order = get_order(),
			name = CANCEL,
			type = "execute",
			func = function()
				LookingForGroup_Options:RestoreDBVariable("start_a_group_quest_id")
			end
		},
		start = 
		{
			order = get_order(),
			name = START,
			type = "execute",
			func = do_start,
		},
	}
})

get_search_result = function()
	wipe(results_table)
	local groups, groupsIDs = C_LFGList.GetSearchResults()
	local i
	for i=1,#groupsIDs do
		table_insert(results_table,groupsIDs[i])
	end
end

local AceGUI = LibStub("AceGUI-3.0")
local GameTooltip = GameTooltip

local function tooltip_feedback()
	local owner = GameTooltip:GetOwner()
	local obj = owner.obj
	local users = obj:GetUserDataTable()
	local val = users.val
	local ok,name,srinfo = LookingForGroup.GetAddon("LookingForGroup_Core").GetQuestSearchResultInfo(val)
	if ok then
		GameTooltip:GetOwner().obj:SetLabel(name)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(srinfo, 0.5, 0.5, 0.8, true)
		GameTooltip:Show()
	else
		select_sup[val] = nil
		obj:SetValue(false)
		obj:SetDisabled(true)
		if LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer ~= nil then
			LookingForGroup_Options:CancelTimer(LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer)
			LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer = nil
		end
	end
end

AceGUI:RegisterWidgetType("LookingForGroup_Options_WQ_Multiselect", function()
	local control = AceGUI:Create("InlineGroup")
	control:SetLayout("Flow")
	control:SetTitle(name)
	control.width = "fill"
	control.SetList = function(self,values)
		self.values = values
	end
	control.SetLabel = function(self,value)
		self:SetTitle(value)
	end
	control.SetDisabled = function(self,disabled)
		self.disabled = disabled
	end
	control.SetMultiselect = function()end
	control.SetItemValue = function(self,key)
		local val = self.values[key]
		local ok, name,desc = LookingForGroup.GetAddon("LookingForGroup_Core").GetQuestSearchResultInfo(val)
		if not ok then
			return
		end
		local check = AceGUI:Create("LookingForGroup_search_result_checkbox")
		check:SetUserData("key", key)
		check:SetLabel(name)
		check:SetUserData("val", val)
		check:SetValue(select_sup[val])
		check:SetCallback("OnValueChanged",function(self,...)
			local user = self:GetUserDataTable()
			local v = user.val
			if select_sup[v] then
				select_sup[v] = nil
			else
				select_sup[v] = true
			end
			check:SetValue(select_sup[v])
		end)
		check:SetCallback("OnLeave", function(self,...)
			if LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer ~= nil then
				LookingForGroup_Options:CancelTimer(LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer)
			end
			GameTooltip:Hide()
		end)
		check:SetCallback("OnEnter", function(self,...)
			GameTooltip:SetOwner(self.frame,"ANCHOR_TOPRIGHT")
			if LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer ~= nil then
				LookingForGroup_Options:CancelTimer(LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer)
			end
			LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer = LookingForGroup_Options:ScheduleRepeatingTimer(tooltip_feedback, 1)
			tooltip_feedback()
		end)
		self:AddChild(check)
	end
	return AceGUI:RegisterAsContainer(control)
end , 1)
