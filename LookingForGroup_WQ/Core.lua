local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_WQ = AceAddon:NewAddon("LookingForGroup_WQ","AceEvent-3.0","AceTimer-3.0")

function LookingForGroup_WQ:OnInitialize()
end

function LookingForGroup_WQ:OnEnable()
	if LookingForGroup.db.profile.enable_wq then
		self:RegisterEvent("QUEST_ACCEPTED")
		self:RegisterEvent("QUEST_REMOVED")
		local t = {}
		t.text = PARTY_LEAVE
		t.button1 = ACCEPT
		t.button2 = CANCEL
		t.preferredIndex = STATICPOPUP_NUMDIALOGS
		t.OnAccept = LeaveParty
		StaticPopupDialogs.LookingForGroup_WQ_LeaveParty = t
	else
		StaticPopupDialogs.LookingForGroup_WQ_LeaveParty = nil
		self:UnregisterEvent("QUEST_ACCEPTED")
		self:UnregisterEvent("QUEST_REMOVED")
	end
end

local doing_wq = nil

--local con cat_tb = {"#LookingForGroup_WQ# [",0,"] #WQ:",0,"#PVE#"}
local wq_id = 0

local function createlist()
--	local id = con cat_tb[4]
	local activityID = LFGListUtil_GetQuestCategoryData(wq_id)
	C_LFGList.CreateListing(activityID,
						"",
						0,
						0,
						"",
						"",
						true,
						false,
						wq_id)
end

local function create_or_join()
	local groupmembers = GetNumGroupMembers()
	if not UnitInRaid("player") and groupmembers == 5 then
		doing_wq = nil
		return
	end
	if C_LFGList.GetActiveEntryInfo() then
		return
	end
	local activityID, categoryID, filters, questName = LFGListUtil_GetQuestCategoryData(wq_id)
	if activityID ~= nil then
--		con cat_tb[2] = questName
		if UnitInParty("player") then
			if UnitIsGroupLeader("player") then
				createlist()
				doing_wq = nil
			end
		else
			doing_wq = wq_id
			LookingForGroup_WQ:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
--			local activityID, categoryID, filters, questName = LFGListUtil_GetQuestCategoryData(id)
			C_LFGList.Search(categoryID,questName,filters,C_LFGList.GetLanguageSearchFilter())
		end
	end
end

local function is_group_wq(id)
	if id == 43943 or id == 45379 then
		return false
	end
	local wq_type = select(3,GetQuestTagInfo(id))
	if wq_type == nil or wq_type == LE_QUEST_TAG_TYPE_PET_BATTLE or wq_type == LE_QUEST_TAG_TYPE_PROFESSION or wq_type == LE_QUEST_TAG_TYPE_DUNGEON or wq_type == LE_QUEST_TAG_TYPE_RAID then
		return false
	end
	if select(2,C_TaskQuest.GetQuestInfoByQuestID(id)) == 1090 then
		return false
	end
	return true
end

function LookingForGroup_WQ:QUEST_ACCEPTED(info,index,id)
	if id and (info == LookingForGroup or is_group_wq(id)) then
		wq_id = id
--[[		if doing_wq == id then
			LeaveParty()
			LookingForGroup_WQ:ScheduleTimer(create_or_join,1)
		else]]
			create_or_join()
--		end
	end
end

local function wqgf_apply()
	if not UnitInParty("player") then
		local applications =  C_LFGList.GetApplications()
		if applications == nil or #applications == 0 then	
			createlist()
		else
			local C_LFGList_GetApplicationInfo = C_LFGList.GetApplicationInfo
			local C_LFGList_CancelApplication = C_LFGList.CancelApplication
			local ok = false
			local i
			for i = 1,#applications do
				local id = applications[i]
				local groupID, status, unknown, timeRemaining, role = C_LFGList_GetApplicationInfo(id)
				if status == "invited" then
					ok = true
				else
					C_LFGList_CancelApplication(id)
				end
			end
			if not ok then
				LookingForGroup_WQ:ScheduleTimer(createlist,1)
			end
		end
	end
end

function LookingForGroup_WQ:LFG_LIST_SEARCH_RESULTS_RECEIVED()
	self:UnregisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
	local count,results = C_LFGList.GetSearchResults()
	local string_find = string.find
	if results == nil then
		if count == 0 then
			createlist()
		end
	else
		local C_LFGList_ApplyToGroup = C_LFGList.ApplyToGroup
		local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
		local GetLFGRoles = GetLFGRoles
		local i
		local b = false
		for i=1,#results do
			local v = results[i]
			local id, activityID, name, comment, voiceChat, iLvl, honorLevel,
				age, numBNetFriends, numCharFriends, numGuildMates,
				isDelisted, leaderName, numMembers, autoaccept = C_LFGList_GetSearchResultInfo(v)
			if autoaccept then
				C_LFGList_ApplyToGroup(v, "", select(2,GetLFGRoles()))
				b = true
			else
				if string_find(comment, "#WQ:"..wq_id.."#") then
					C_LFGList_ApplyToGroup(v, "WorldQuestGroupFinderUser-"..wq_id, select(2,GetLFGRoles()))
					b = true
				end
			end
		end
		if b then
			LookingForGroup_WQ:ScheduleTimer(wqgf_apply,5)
		else
			createlist()
		end
	end
end

function LookingForGroup_WQ:QUEST_REMOVED(info,id)
	if doing_wq == id  then
		self:CancelAllTimers()
		self:UnregisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
		local numgm = GetNumGroupMembers()
		if numgm == 1 then
			LeaveParty()
		elseif numgm ~= 0 then
			StaticPopup_Show("LookingForGroup_WQ_LeaveParty")
		end
		doing_wq = nil
	end
end

function LookingForGroup_WQ:GROUP_ROSTER_UPDATE(...)
	self:UnregisterEvent("GROUP_ROSTER_UPDATE")
	createlist()
end

function LookingForGroup_WQ:START_A_GROUP(id)
	wq_id = id
	if doing_wq then
		doing_wq = id
		self:RegisterEvent("GROUP_ROSTER_UPDATE")
		LeaveParty()
	else
		createlist()
	end
end
