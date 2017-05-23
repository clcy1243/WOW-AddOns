local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")
local AceGUI = LibStub("AceGUI-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("LookingForGroup_Options")
local wipe = wipe
local table_insert = table.insert
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_ApplyToGroup = C_LFGList.ApplyToGroup
local pairs = pairs

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local party_tb = {}
local select_sup = {}

local cr_sr =
{
	name = KBASE_SEARCH_RESULTS,
	desc = LFG_LIST_SELECT_A_SEARCH_RESULT,
	type = "group",
	args =
	{
		sign_up =
		{
			order = get_order(),
			name = SIGN_UP,
			type = "execute",
			func = function()
				local k,v
				local string_find = string.find
				local tankOK, healerOK, damageOK = select(2,GetLFGRoles())
				for k,v in pairs(select_sup) do
					if v then
						local party = party_tb[k]
						local i
						local n = #party
						for i=1,n do
							local pi = party[i]
							local id, activityID, name, comment, voiceChat, iLvl, honorLevel,
									age, numBNetFriends, numCharFriends, numGuildMates,
									isDelisted, leaderName, numMembers, isAutoAccept = C_LFGList_GetSearchResultInfo(pi)
							if isAutoAccept then
								C_LFGList_ApplyToGroup(pi, "", tankOK, healerOK, damageOK)
							else
								local questid = string_find(comment,"#([%w]+)#")
								if questid ~= nil then
									C_LFGList_ApplyToGroup(pi, "WorldQuestGroupFinderUser-"..questid, tankOK, healerOK, damageOK)
								end
							end
						end
					end
				end
			end
		},
		search_again = 
		{
			order = get_order(),
			name = LFG_LIST_SEARCH_AGAIN,
			type = "execute",
			func = function() LookingForGroup_Options.DoCRSearch() end
		},
		back = 
		{
			order = get_order(),
			name = BACK,
			type = "execute",
			func = function()
				C_LFGList.ClearSearchResults()
				wipe(party_tb)
				wipe(select_sup)
				LookingForGroup_Options.reset_search_result()
				AceConfigDialog:SelectGroup("LookingForGroup","cr")
			end
		},
		s =
		{
			name = FRIENDS_LIST_REALM,
			order = get_order(),
			values = party_tb,
			dialogControl = "LookingForGroup_Options_Cross_Realm_Multiselect",
			type = "multiselect",
		}
	}
}

local function LFG_LIST_SEARCH_RESULTS_RECEIVED(...)
	LookingForGroup_Options:UnregisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
	LookingForGroup_Options:ScheduleTimer(function()
		wipe(party_tb)
		wipe(select_sup)
		local counts,results = C_LFGList.GetSearchResults()
		local player_realm = GetRealmName()
		local string_find = string.find
		local string_match = string.match
		local i
		for i=1,#results do
			local ri = results[i]
			local id, activityID, name, comment, voiceChat, iLvl, honorLevel,
					age, numBNetFriends, numCharFriends, numGuildMates,
					isDelisted, leaderName, numMembers, isAutoAccept = C_LFGList_GetSearchResultInfo(ri)
			if (isAutoAccept or string_find(comment,"#([%w]+)#")) and leaderName ~= nil then
				local realm = string_match(leaderName,"-(.*)$")
				if realm == nil then
					realm = player_realm
				end
				if party_tb[realm] == nil then
					party_tb[realm] = {}
				end
				table_insert(party_tb[realm],ri)
			end
		end
		LookingForGroup_Options.set_search_result(cr_sr)
		AceConfigDialog:SelectGroup("LookingForGroup","search_result")
	end,0.1)
end

function LookingForGroup_Options.DoCRSearch()
	LookingForGroup_Options:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED",LFG_LIST_SEARCH_RESULTS_RECEIVED)
	C_LFGList.Search(LookingForGroup_Options.db.profile.cr_category,"",C_LFGList.GetLanguageSearchFilter())
end



LookingForGroup_Options:push("cr",{
	name = L["Cross Realm"],
	type = "group",
	args =
	{
		scan =
		{
			order = get_order(),
			name = ENABLE,
			type = "execute",
			func = function()
				LookingForGroup.GetAddon("LookingForGroup_CR").do_scan()
			end,
			width = "full"
		},
		search =
		{
			order = get_order(),
			name = SEARCH,
			type = "execute",
			func = LookingForGroup_Options.DoCRSearch,
		},
		cancel =
		{
			order = get_order(),
			name = CANCEL,
			type = "execute",
			func = function()
				LookingForGroup_Options:RestoreDBVariable("cr_category")
			end
		},
		category =
		{
			order = get_order(),
			name = CATEGORY,
			type = "select",
			values = LookingForGroup_Options.categorys_values,
			get = function(info) return LookingForGroup_Options.db.profile.cr_category end,
			set = function(info,key) LookingForGroup_Options.db.profile.cr_category = key end,
		},
	}
})

local function tooltip_feedback()
	GameTooltip:ClearLines()
	local owner = GameTooltip:GetOwner()
	local obj = owner.obj
	local users = obj:GetUserDataTable()
	local key = users.key
	local val = users.val
	local i
	local q = {}
	for i=1,#val do
		local ri = val[i]
		local isDelisted = select(12,C_LFGList_GetSearchResultInfo(ri))
		if isDelisted == false then
			table_insert(q,ri)
		end
	end
	
	if next(q) == nil then
		obj:SetDisabled(true)
		if LookingForGroup_Options.CR_Tooltip_Feedback_timer ~= nil then
			LookingForGroup_Options:CancelTimer(LookingForGroup_Options.CR_Tooltip_Feedback_timer)
			LookingForGroup_Options.CR_Tooltip_Feedback_timer = nil
		end
		party_tb[key] = nil
	else
		party_tb[key] = q
	end
	
	local tm = "|cff8080cc("..#q..")|r"
	obj:SetLabel(key.." "..tm)
	GameTooltip:AddDoubleLine(key,#q)
	GameTooltip:Show()
end

AceGUI:RegisterWidgetType("LookingForGroup_Options_Cross_Realm_Multiselect", function()
	local control = AceGUI:Create("InlineGroup")
	control:SetLayout("Flow")
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
		local check = AceGUI:Create("CheckBox")
		check:SetUserData("key", key)
		check:SetUserData("val", val)
		check:SetLabel(key.." |cff8080cc("..#val..")|r")
		check:SetCallback("OnValueChanged",function(self,event,val)
			local user = self:GetUserDataTable()
			local key = user.key
			select_sup[key] = val
			check:SetValue(select_sup[key])
		end)
		check:SetCallback("OnLeave", function(self,...)
			if LookingForGroup_Options.CR_Tooltip_Feedback_timer ~= nil then
				LookingForGroup_Options:CancelTimer(LookingForGroup_Options.CR_Tooltip_Feedback_timer)
				LookingForGroup_Options.CR_Tooltip_Feedback_timer = nil
			end
			GameTooltip:Hide()
		end)
		check:SetCallback("OnEnter", function(self,...)
			if LookingForGroup_Options.CR_Tooltip_Feedback_timer ~= nil then
				LookingForGroup_Options:CancelTimer(LookingForGroup_Options.CR_Tooltip_Feedback_timer)
			end
			GameTooltip:SetOwner(self.frame,"ANCHOR_TOPRIGHT")
			LookingForGroup_Options.CR_Tooltip_Feedback_timer = LookingForGroup_Options:ScheduleRepeatingTimer(tooltip_feedback,1)
			tooltip_feedback()
		end)
		self:AddChild(check)
	end
	return AceGUI:RegisterAsContainer(control)
end , 1)
