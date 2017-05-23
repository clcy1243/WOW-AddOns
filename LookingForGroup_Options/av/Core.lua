local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")
local C_LFGList_ClearSearchResults = C_LFGList.ClearSearchResults
local C_LFGList_Search = C_LFGList.Search
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local string_find = string.find
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local string_gsub = string.gsub
local string_lower = string.lower
local table_insert = table.insert

local order = 0
local function get_order()
	local temp = order
	order = order + 1
	return temp
end


local select_sup = {}
local results_table = {}

local tank_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:0:19:22:41|t"
local healer_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:1:20|t"
local damager_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:22:41|t"

local LFG_LIST_SEARCH_RESULTS_RECEIVED

local function do_search()
	C_LFGList_ClearSearchResults()
	LookingForGroup_Options:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED",LFG_LIST_SEARCH_RESULTS_RECEIVED)
	C_LFGList_Search(3,"#AV#",C_LFGList.GetLanguageSearchFilter())
end

local function do_start()
	local profile = LookingForGroup_Options.db.profile
	local name = profile.start_a_group_title
	if name ~="" then
		local lfgav = LookingForGroup_Options.GetLFG_AV()
		local funcListing = lfgav.CreateListing
		if C_LFGList.GetActiveEntryInfo() then
			funcListing = lfgav.UpdateListing
		end
		funcListing(name,
					profile.start_a_group_minimum_item_level,
					0,
					profile.start_a_group_voice_chat,
					profile.start_a_group_details,
					profile.start_a_group_auto_accept,
					profile.start_a_group_private)
		AceConfigDialog:SelectGroup("LookingForGroup","requests")
	end
end

local av_sr =
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
					dialogControl = "LookingForGroup_Options_AV_Multiselect",
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
				local apply_to_group = LookingForGroup_Options.ApplyToGroup
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
			func = do_search
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
				AceConfigDialog:SelectGroup("LookingForGroup","av")
			end
		},
	}
}

local get_search_result

LFG_LIST_SEARCH_RESULTS_RECEIVED = function()
	LookingForGroup_Options:UnregisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
	get_search_result()
	LookingForGroup_Options.set_search_result(av_sr)
	AceConfigDialog:SelectGroup("LookingForGroup","search_result","Results")
end


local party_tb = {}
local concat_tb = {}

LookingForGroup_Options:push("av",{
	name = GetMapNameByID(401),
	type = "group",
	args =
	{
		enable =
		{
			order = get_order(),
			name = ENABLE,
			type = "toggle",
			get = function(info)
				return LookingForGroup.db.profile.enable_av
			end,
			set = function(info,val)
				LookingForGroup.db.profile.enable_av = val
				if val then
					LoadAddOn("LookingForGroup_AV")
				end
				local LookingForGroup_AV = AceAddon:GetAddon("LookingForGroup_AV")
				LookingForGroup_AV:OnEnable()
			end,
			width = "full"
		},
		search =
		{
			order = get_order(),
			name = LFG_LIST_FIND_A_GROUP,
			type = "execute",
			func = do_search,
		},
		start =
		{
			order = get_order(),
			name = START_A_GROUP,
			type = "execute",
			func = function() 	AceConfigDialog:SelectGroup("LookingForGroup","av","s") end,
		},
		disban =
		{
			order = get_order(),
			name = TEAM_DISBAND,
			type = "execute",
			confirm = true,
			func = function() LookingForGroup.GetAddon("LookingForGroup_AV").rl_disban() end,
		},
		s =
		{
			name = START_A_GROUP,
			order = get_order(),
			type = "group",
			args =
			{
				title =
				{
					order = get_order(),
					name = LFG_LIST_TITLE,
					desc = LFG_LIST_ENTER_NAME,
					type = "input",
					get = function(info) return LookingForGroup_Options.db.profile.start_a_group_title end,
					set = function(info,val) LookingForGroup_Options.db.profile.start_a_group_title = val end,
					width = "full"
				},
				details =
				{
					order = get_order(),
					name = LFG_LIST_DETAILS,
					desc = DESCRIPTION_OF_YOUR_GROUP,
					type = "input",
					multiline = true,
					get = function(info) return LookingForGroup_Options.db.profile.start_a_group_details end,
					set = function(info,val) LookingForGroup_Options.db.profile.start_a_group_details = val end,
					width = "full"
				},
				minitemlvr =
				{
					order = get_order(),
					name = LFG_LIST_ITEM_LEVEL_REQ,
					type = "input",
					get = function(info)
						local sminilv = LookingForGroup_Options.db.profile.start_a_group_minimum_item_level
						if sminilv == 0 then
							return ""
						else
							return tostring(sminilv)
						end
					end,
					pattern = "^[0-9]*$",
					set = function(info,val)
						if val == nil or val == "" then
							LookingForGroup_Options.db.profile.start_a_group_minimum_item_level = 0
						else
							local player_ilv = math_floor(GetAverageItemLevel())
							val = tonumber(val)
							if player_ilv < val then
								LookingForGroup_Options.db.profile.start_a_group_minimum_item_level = player_ilv
							else
								LookingForGroup_Options.db.profile.start_a_group_minimum_item_level = val
							end
						end
					end
				},
				vc =
				{
					order = get_order(),
					name = VOICE_CHAT,
					desc = LFG_LIST_VOICE_CHAT_INSTR,
					type = "input",
					get = function(info)
						return LookingForGroup_Options.db.profile.start_a_group_voice_chat
					end,
					set = function(info,val)
						LookingForGroup_Options.db.profile.start_a_group_voice_chat = val
					end
				},
				auto_acc =
				{
					order = get_order(),
					name = LFG_LIST_AUTO_ACCEPT,
					type = "toggle",
					get = function(info)
						return LookingForGroup_Options.db.profile.start_a_group_auto_accept
					end,
					set = function(info,val)
						LookingForGroup_Options.db.profile.start_a_group_auto_accept = val
					end
				},
				prv =
				{
					order = get_order(),
					name = LFG_LIST_PRIVATE,
					desc = LFG_LIST_PRIVATE_TOOLTIP,
					type = "toggle",
					get = function(info)
						return LookingForGroup_Options.db.profile.start_a_group_private
					end,
					set = function(info,val)
						LookingForGroup_Options.db.profile.start_a_group_private = val
					end
				},
				start =
				{
					order = get_order(),
					name = START,
					type = "execute",
					func = do_start
				},
				cancel = 
				{
					order = get_order(),
					name = CANCEL,
					type = "execute",
					func = LookingForGroup_Options.UpdateEditing
				},
				back = 
				{
					order = get_order(),
					name = BACK,
					type = "execute",
					func = function() AceConfigDialog:SelectGroup("LookingForGroup","av") end
				},
			}
		},
		
		parties =
		{
			name = PARTY_MEMBERS,
			order = get_order(),
			type = "group",
			args =
			{
				roleconfirm =
				{
					order = get_order(),
					name = ROLE_POLL,
					type = "execute",
					func = function() LookingForGroup.GetAddon("LookingForGroup_AV").rl_roleconfirm() end,
					width = "full"
				},
				parties =
				{
					name = PARTY,
					type = "multiselect",
					order = get_order(),
					values = function()
						wipe(party_tb)
						local parties = LookingForGroup.GetAddon("LookingForGroup_AV").db.profile.parties
						local table_insert = table.insert
						local k,v
						for k,v in pairs(parties) do
							wipe(concat_tb)
							table_insert(concat_tb,k)
							table_insert(concat_tb,' (')
							table_insert(concat_tb,#v+1)
							table_insert(concat_tb,')')
							local i
							for i = 1,#v do
								table_insert(concat_tb,'\n')
								table_insert(concat_tb,v[i])
							end
							party_tb[k] = table.concat(concat_tb)
						end
						return party_tb
					end,
					width = "full",
					set = function()end,
					get = function()end,
				}
			}
		}
	}
})

local function filter_search_results(resultID,filters)
	local id, activityID, name, comment, voiceChat, iLvl, honorLevel,
			age, numBNetFriends, numCharFriends, numGuildMates,
			isDelisted, leaderName, numMembers = C_LFGList_GetSearchResultInfo(resultID)
	if id == nil or isDelisted then
		return false
	end
	if filters ~= nil then
		local lower_case_name = string_lower(string_gsub(name," ",""))
		local lower_case_comment = string_lower(string_gsub(comment," ",""))
		local i
		local n = #filters
		for i=1,n do
			local ele = filters[i]
			if string_find(lower_case_name,ele) or string_find(lower_case_comment,ele) then
				return false
			end
		end
	end
	return true
end

get_search_result = function()
	wipe(results_table)
	local filters = LookingForGroup_Options.db.profile.spam_filter_keywords
	local groups, groupsIDs = C_LFGList.GetSearchResults()
	local i
	for i=1,#groupsIDs do
		local number = groupsIDs[i]
		if filter_search_results(number,filters) then
			table_insert(results_table,number)
		end
	end
end

local AceGUI = LibStub("AceGUI-3.0")
local GameTooltip = GameTooltip

local function tooltip_feedback()
	local owner = GameTooltip:GetOwner()
	local obj = owner.obj
	local users = obj:GetUserDataTable()
	local val = users.val
	local ok,name,srinfo = LookingForGroup.GetAddon("LookingForGroup_Core").GetSearchResultInfo(val)
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

AceGUI:RegisterWidgetType("LookingForGroup_Options_AV_Multiselect", function()
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
		local ok, name,desc = LookingForGroup.GetAddon("LookingForGroup_Core").GetSearchResultInfo(val)
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
