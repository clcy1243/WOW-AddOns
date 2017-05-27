local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")
local wipe = wipe
local string_format = string.format
local string_find = string.find
local string_match = string.match
local string_lower = string.lower
local string_gsub = string.gsub
local tonumber = tonumber
local tostring = tostring
local select = select
local GetAverageItemLevel = GetAverageItemLevel
local GetNumSavedInstances = GetNumSavedInstances
local GetSavedInstanceEncounterInfo = GetSavedInstanceEncounterInfo
local math_floor = math.floor
local table_concat = table.concat
local next = next
local results_table = {}
local select_sup = {}
local comment_text = ""
local mbnm = 0
--local error = error
--local pcall = pcall
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetSearchResultEncounterInfo = C_LFGList.GetSearchResultEncounterInfo
local table_insert = table.insert

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local C_LFGList_Search = C_LFGList.Search
local C_LFGList_GetActivityInfo = C_LFGList.GetActivityInfo
local C_LFGList_GetAvailableCategories = C_LFGList.GetAvailableCategories
local C_LFGList_GetCategoryInfo = C_LFGList.GetCategoryInfo
local C_LFGList_GetAvailableActivityGroups = C_LFGList.GetAvailableActivityGroups
local C_LFGList_GetActivityGroupInfo = C_LFGList.GetActivityGroupInfo
local C_LFGList_GetAvailableActivities = C_LFGList.GetAvailableActivities
local C_LFGList_GetActiveEntryInfo = C_LFGList.GetActiveEntryInfo
local C_LFGList_CreateListing = C_LFGList.CreateListing
local C_LFGList_UpdateListing = C_LFGList.UpdateListing
local C_LFGList_ClearSearchResults = C_LFGList.ClearSearchResults

local function lfg_get_available_activities(...)
	local res = C_LFGList_GetAvailableActivities(...)
	local ret = {}
	local i
	for i=1,#res do
		local res_i = res[i]
		ret[res_i] = C_LFGList_GetActivityInfo(res_i)
	end
	return ret
end

local activities_tb0 
local activities_tb1 = {}
local activities_tb2 = {}

local function get_activities(category,group)
	if category == nil then
		category = 0
	end
	if group == nil then
		group = 0
	end
	if category == 0 then
		if activities_tb0 == nil then
			activities_tb0 = lfg_get_available_activities()
		end
		return activities_tb0
	end
	if group == 0 then
		if activities_tb1[category] == nil then
			activities_tb1[category] = lfg_get_available_activities(category)	
		end
		return activities_tb1[category]
	end
	if activities_tb2[category] == nil then
		activities_tb2[category]  = {}
	end
	if activities_tb2[category][group] == nil then
		activities_tb2[category][group]  = lfg_get_available_activities(category,group)
	end
	return activities_tb2[category][group]
end

local nulltb = {}

local categorys_tb

local function categorys_values()
	if categorys_tb == nil then
		local categorys = C_LFGList_GetAvailableCategories()
		categorys_tb = {}
		local i
		for i=1,#categorys do
			categorys_tb[categorys[i]]=C_LFGList_GetCategoryInfo(categorys[i])
		end
	end
	return categorys_tb
end

LookingForGroup_Options.categorys_values = categorys_values

local groups_tb = {}

local function groups_values()
	local a_group_category = LookingForGroup_Options.db.profile.a_group_category
	if a_group_category == 0 then
		return nulltb
	end
	if groups_tb[a_group_category] == nil then
		local groups = C_LFGList_GetAvailableActivityGroups(a_group_category)
		groups_tb[a_group_category] = {}
		local gtbs = groups_tb[a_group_category]
		local i
		for i = 1,#groups do
			local groups_i = groups[i]
			gtbs[groups_i] = C_LFGList_GetActivityGroupInfo(groups_i)
		end
	end
	return groups_tb[a_group_category]
end

local function activities_values()
	local profile = LookingForGroup_Options.db.profile
	return get_activities(profile.a_group_category,profile.a_group_group)
end

local encounters_tb = {}
local encounters_check = {0," (",0,")"}

local function encounters_values()
	local profile = LookingForGroup_Options.db.profile
	local activity = profile.a_group_activity
	if activity == 0 then
		return nulltb
	end
	if next(encounters_tb) == nil then
		local find_a_group_encounters = profile.find_a_group_encounters
		local fullName, shortName, categoryID, groupID, itemLevel, filters, minLevel, maxPlayers, displayType, activityOrder = C_LFGList_GetActivityInfo(activity)
		if groupID == 0 then
			return nulltb
		end
		local name = C_LFGList_GetActivityGroupInfo(groupID)
		local num = GetNumSavedInstances()
		local i
		for i=1,num do
			local instanceName, instanceID, _, instanceDifficulty, locked, _, instanceIDMostSig, isRaid, maxPlayers, difficultyName, maxBosses, _ = GetSavedInstanceInfo(i)
			if (string_find(name,instanceName) or string_find(instanceName,name)) and shortName == difficultyName then
				if locked then
					local j
					for j = 1, maxBosses do
						local enm,_,iskilled = GetSavedInstanceEncounterInfo(i,j)
						encounters_tb[j] = enm
						if iskilled then
							find_a_group_encounters[enm] = true
						end
					end
				else
					local j
					for j = 1, maxBosses do
						encounters_tb[j] = GetSavedInstanceEncounterInfo(i,j)
					end
				end
				break
			end
		end
	end
	return encounters_tb
end

local tank_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:0:19:22:41|t"
local healer_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:1:20|t"
local damager_icon = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:22:41|t"

local get_search_result

local select_sup = {}

local normal_sr = {
	name = KBASE_SEARCH_RESULTS,
	type = "group",
	childGroups = "tab",
}

function LookingForGroup_Options:LFG_LIST_SEARCH_RESULTS_RECEIVED()
	LookingForGroup_Options:UnregisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
	get_search_result()
	LookingForGroup_Options.set_search_result(normal_sr)
	AceConfigDialog:SelectGroup("LookingForGroup","search_result","Results")
end

local function do_search()
	C_LFGList_ClearSearchResults()
	local profile = LookingForGroup_Options.db.profile
	local a_group_category = profile.a_group_category	
	if a_group_category == 0 then
		return
	end
	local languages = C_LFGList.GetLanguageSearchFilter()
	local a_group_activity = profile.a_group_activity
	LookingForGroup_Options:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
	if a_group_activity == 0 then
		local a_group_group = profile.a_group_group
		if a_group_group == 0 then
			local a_group_filter = profile.find_a_group_filter
			if a_group_filter == nil then
				a_group_filter = ""
			end
			C_LFGList_Search(a_group_category,a_group_filter,languages)
		else
			local name = C_LFGList_GetActivityGroupInfo(a_group_group,languages)
			C_LFGList_Search(a_group_category,name,languages)
		end
	else
		local name = C_LFGList_GetActivityInfo(a_group_activity)
		C_LFGList_Search(a_group_category,name,languages)
	end
end

function LookingForGroup_Options.SetCategory(_,val)
	local profile = LookingForGroup_Options.db.profile
	profile.a_group_category = val
	LookingForGroup_Options:RestoreDBVariable("a_group_group")
	LookingForGroup_Options:RestoreDBVariable("a_group_activity")
	wipe(encounters_tb)
	wipe(profile.find_a_group_encounters)
end

function LookingForGroup_Options.UpdateEditing()
	local active, activityID, iLevel, honorLevel, name, comment, voiceChat, expiration, oldAutoAccept, privateGroup, questID = C_LFGList_GetActiveEntryInfo()
	if active then
		local profile = LookingForGroup_Options.db.profile
		profile.start_a_group_minimum_item_level,profile.start_a_group_title,profile.start_a_group_details,profile.start_a_group_voice_chat,profile.start_a_group_auto_accept,profile.start_a_group_private,profile.start_a_group_quest_id =
		iLevel,  name, comment, voiceChat, oldAutoAccept, privateGroup, questID
		local fullName, shortName, categoryID, groupID, itemLevel, filters, minLevel, maxPlayers, displayType, activityOrder = C_LFGList_GetActivityInfo(activityID)
		local summary,data = string_match(comment,'^(.*)%((^1^.+^^)%)$')
		if data ~= nil then
			profile.start_a_group_details = summary
			profile.start_a_group_title = fullName
		end
		profile.a_group_category,profile.a_group_group,profile.a_group_activity = categoryID,groupID,activityID
		wipe(encounters_tb)
		wipe(profile.find_a_group_encounters)
	else
		LookingForGroup_Options:RestoreDBVariable("start_a_group_title")
		LookingForGroup_Options:RestoreDBVariable("start_a_group_minimum_item_level")
		LookingForGroup_Options:RestoreDBVariable("start_a_group_voice_chat")
		LookingForGroup_Options:RestoreDBVariable("start_a_group_details")
		LookingForGroup_Options:RestoreDBVariable("start_a_group_auto_accept")
		LookingForGroup_Options:RestoreDBVariable("start_a_group_private")
		LookingForGroup_Options:RestoreDBVariable("start_a_group_quest_id")
	end						
end

normal_sr.args =
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
				dialogControl = "LookingForGroup_Options_Search_Result_Multiselect",
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
	Comment =
	{
		name = COMMENT,
		type = "group",
		order = get_order(),
		args =
		{
			Comment =
			{
				order = get_order(),
				name = COMMENT,
				type = "input",
				multiline = true,
				width = "full",
				set = function(info,val)
					comment_text = val
				end,
				get = function(info) return comment_text end,
			}
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
			local tankok,healerok,dpsok = select(2,GetLFGRoles())
			for k,v in pairs(select_sup) do
				if v then
					apply_to_group(k,comment_text,tankok,healerok,dpsok)
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
			C_LFGList_ClearSearchResults()
			wipe(select_sup)
			LookingForGroup_Options.reset_search_result()
			AceConfigDialog:SelectGroup("LookingForGroup","find")
		end
	}
}

LookingForGroup_Options:push("find",{
	name = FIND_A_GROUP,
	desc = LFG_LIST_SELECT_A_CATEGORY,
	type = "group",
	childGroups = "tab",
	args =
	{
		Category =
		{
			order = get_order(),
			name = CATEGORY,
			type = "select",
			values = categorys_values,
			set = LookingForGroup_Options.SetCategory,
			get = function(info) return LookingForGroup_Options.db.profile.a_group_category end,
			width = "full",
		},
		Group =
		{
			order = get_order(),
			name = GROUP,
			type = "select",
			values = groups_values,
			set = function(info,val)
				local profile = LookingForGroup_Options.db.profile
				profile.a_group_group = val
				LookingForGroup_Options:RestoreDBVariable("a_group_activity")
				wipe(encounters_tb)
				wipe(profile.find_a_group_encounters)
			end,
			get = function(info) return LookingForGroup_Options.db.profile.a_group_group end,
			width = "full",
			control = "LookingForGroup_Options_groups_dropdown"
		},
		Activity =
		{
			order = get_order(),
			name = LFG_LIST_ACTIVITY,
			type = "select",
			values = activities_values,
			set = function(info,val)
				local profile = LookingForGroup_Options.db.profile
				profile.a_group_activity = val
				_,_,profile.a_group_category,profile.a_group_group = C_LFGList_GetActivityInfo(val)
				wipe(encounters_tb)
				wipe(profile.find_a_group_encounters)
			end,
			get = function(info) return LookingForGroup_Options.db.profile.a_group_activity end,
			width = "full",
			control = "LookingForGroup_Options_activities_dropdown"
		},

		cancel = 
		{
			name = CANCEL,
			type = "execute",
			func = function()
				LookingForGroup_Options:RestoreDBVariable("a_group_category")
				LookingForGroup_Options:RestoreDBVariable("a_group_activity")
				LookingForGroup_Options:RestoreDBVariable("a_group_group")
				wipe(encounters_tb)
				wipe(LookingForGroup_Options.db.profile.find_a_group_encounters)
			end
		},
		f =
		{
			name = LFG_LIST_FIND_A_GROUP,
			order = get_order(),
			type = "group",
			args =
			{
				filter =
				{
					order = get_order(),
					name = FILTER,
					type = "input",
					get = function(info) return LookingForGroup_Options.db.profile.find_a_group_filter end,
					set = function(info,val) LookingForGroup_Options.db.profile.find_a_group_filter = val end,
					width = "full"
				},
				encounters =
				{
					order = get_order(),
					name = RAID_ENCOUNTERS,
					type = "multiselect",
					width = "full",
					values = encounters_values,
					tristate = true,
					get = function(info,val)
						local v = LookingForGroup_Options.db.profile.find_a_group_encounters[encounters_tb[val]]
						if v then
							return true
						elseif v == false then
							return nil
						end
						return false
					end,
					set = function(info,key,val)
						local k = false
						if val then
							k = true
						elseif val == false then
							k = nil
						end
						LookingForGroup_Options.db.profile.find_a_group_encounters[encounters_tb[key]] = k
					end
				},
				search =
				{
					order = get_order(),
					name = SEARCH,
					type = "execute",
					func = do_search
				},
				cancel = 
				{
					order = get_order(),
					name = CANCEL,
					type = "execute",
					func = function()
						LookingForGroup_Options:RestoreDBVariable("find_a_group_filter")
						wipe(encounters_tb)
						wipe(LookingForGroup_Options.db.profile.find_a_group_encounters)
					end
				},
			}
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
					get = function(info)
						local profile = LookingForGroup_Options.db.profile
						local quest_id = profile.start_a_group_quest_id
						if quest_id ~= nil then
							return select(4,LFGListUtil_GetQuestCategoryData(quest_id))
						end
						return profile.start_a_group_title
					end,
					set = function(info,val)
						LookingForGroup_Options.db.profile.start_a_group_title = val
						LookingForGroup_Options.db.profile.start_a_group_quest_id = nil
					end,
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
						if val == "" then
							LookingForGroup_Options.db.profile.start_a_group_quest_id = nil
						else
							local activityID, categoryID, filters, questName = LFGListUtil_GetQuestCategoryData(val)
							if questName ~= nil then
								local profile = LookingForGroup_Options.db.profile
								profile.a_group_category = categoryID
								profile.a_group_activity = activityID
								profile.start_a_group_auto_accept = true
								profile.start_a_group_quest_id = val
							end
						end
					end,
					width = "full"
				},
				start =
				{
					order = get_order(),
					name = START,
					type = "execute",
					func = function()
						local profile = LookingForGroup_Options.db.profile
						if profile.a_group_activity ~= 0 and profile.start_a_group_title~="" then
							local funcListing = C_LFGList_CreateListing
							if C_LFGList_GetActiveEntryInfo() then
								funcListing = C_LFGList_UpdateListing
							end
							local quest_id = profile.start_a_group_quest_id
							if quest_id == nil then
								funcListing(profile.a_group_activity,
										profile.start_a_group_title,
										profile.start_a_group_minimum_item_level,
										0,
										profile.start_a_group_voice_chat,
										profile.start_a_group_details,
										profile.start_a_group_auto_accept,
										profile.start_a_group_private)
							else
								local activityID = LFGListUtil_GetQuestCategoryData(quest_id)
								funcListing(activityID,
										"",
										profile.start_a_group_minimum_item_level,
										0,
										profile.start_a_group_voice_chat,
										profile.start_a_group_details,
										profile.start_a_group_auto_accept,
										profile.start_a_group_private,
										quest_id)
							end
							AceConfigDialog:SelectGroup("LookingForGroup","requests")
						end
					end
				},
				cancel = 
				{
					order = get_order(),
					name = CANCEL,
					type = "execute",
					func = LookingForGroup_Options.UpdateEditing
				},
			}
		},
	}
})


local function filter_search_results(resultID,activity,filters,encounters,mbnm,filter)
	local id, activityID, name, comment, voiceChat, iLvl, honorLevel,
			age, numBNetFriends, numCharFriends, numGuildMates,
			isDelisted, leaderName, numMembers = C_LFGList_GetSearchResultInfo(resultID)
	if id == nil or isDelisted then
		return false
	end
	if activity ~= nil and activity ~= activityID then
		error({LFG_Core_ReSearch_code=1})
	end
	local lower_case_name = string_lower(string_gsub(name," ",""))
	local lower_case_comment = string_lower(string_gsub(comment," ",""))
	if filter ~= nil then
		if not string_find(lower_case_name,filter) and not string_find(lower_case_comment,filter) then
			return false
		end
	end
	if filters ~= nil then
		local i
		local n = #filters
		for i=1,n do
			local ele = filters[i]
			if string_find(lower_case_name,ele) or string_find(lower_case_comment,ele) then
				return false
			end
		end
	end
	local rse = C_LFGList_GetSearchResultEncounterInfo(id)
	if encounters ~= nil then
		local mct = 0
		if rse ~= nil then
			local k,v
			for k,v in pairs(rse) do
				local gt = encounters[v]
				if gt then
					mct = mct +1
				elseif gt == false then
					return false
				end
			end
		end
		if mct < mbnm then
			return false
		end
	end
	return true
end


get_search_result = function()
	wipe(results_table)
	local groups, groupsIDs = C_LFGList.GetSearchResults()
	local profile = LookingForGroup_Options.db.profile
	local find_a_group_filter = profile.find_a_group_filter
	local encounters = profile.find_a_group_encounters
	local activity = profile.a_group_activity
	if activity == 0 then
		activity = nil
	end
	if find_a_group_filter == "" then
		find_a_group_filter = nil
	end
	local filters = LookingForGroup.db.profile.spam_filter_keywords
	local mbnm = 0
	local k,v
	for k,v in pairs(encounters) do
		if v then
			mbnm = mbnm + 1
		end
	end
	local i
	for i=1,#groupsIDs do
		local number = groupsIDs[i]
		if filter_search_results(number,activity,filters,encounters,mbnm,find_a_group_filter) then
			table_insert(results_table,number)
		end
	end
end

local AceGUI = LibStub("AceGUI-3.0")
local GameTooltip = GameTooltip

function LookingForGroup_Options:SearchResult_Tooltip_Feedback()
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
		if val ~= nil then
			select_sup[val] = nil
		end
		obj:SetValue(false)
		obj:SetDisabled(true)
		if LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer ~= nil then
			LookingForGroup_Options:CancelTimer(LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer)
			LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer = nil
		end
	end
end

AceGUI:RegisterWidgetType("LookingForGroup_Options_Search_Result_Multiselect", function()
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
			LookingForGroup_Options.SearchResult_Tooltip_Feedback_timer = LookingForGroup_Options:ScheduleRepeatingTimer("SearchResult_Tooltip_Feedback", 1)
			LookingForGroup_Options:SearchResult_Tooltip_Feedback()
		end)
		self:AddChild(check)
	end
	return AceGUI:RegisterAsContainer(control)
end , 1)

local order_tb = {}

AceGUI:RegisterWidgetType("LookingForGroup_Options_activities_dropdown",function()
	local widget = AceGUI:Create("Dropdown")
	local SetList = widget.SetList
	widget.SetList = function(self, list, order, itemType)
		wipe(order_tb)
		local k
		for k,_ in pairs(list) do
			table_insert(order_tb,k)
		end
		LFGListUtil_SortActivitiesByRelevancy(order_tb)
		SetList(self, list, order_tb, itemType)
	end
	return widget
end , 1)

AceGUI:RegisterWidgetType("LookingForGroup_Options_groups_dropdown",function()
	local widget = AceGUI:Create("Dropdown")
	local SetList = widget.SetList
	widget.SetList = function(self, list, order, itemType)
		wipe(order_tb)
		local k
		for k,_ in pairs(list) do
			table_insert(order_tb,k)
		end
		table.sort(order_tb,function(g1,g2)
			local category = LookingForGroup_Options.db.profile.a_group_category
			local c1 = C_LFGList_GetAvailableActivities(category,g1)
			local c2 = C_LFGList_GetAvailableActivities(category,g2)
			return LFGListUtil_SortActivitiesByRelevancyCB(c1[#c1],c2[#c2])
		end)
		SetList(self, list, order_tb, itemType)
	end
	return widget
end , 1)
