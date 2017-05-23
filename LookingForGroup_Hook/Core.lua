local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Hook = AceAddon:NewAddon("LookingForGroup_Hook","AceHook-3.0")

--------------------------------------------------------------------------------------
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

function LookingForGroup_Hook:OnInitialize()
end

function LookingForGroup_Hook:OnEnable()
	if LookingForGroup.db.profile.enable_hook then
		self:RawHook("LFGListCategorySelection_StartFindGroup",true)
		self:RawHook("LFGListEntryCreation_Show",true)
		self:RawHook("QueueStatusDropDown_AddLFGListButtons",true)
		self:RawHook("LFGListUtil_OpenBestWindow",true)
		self:RawHook("QueueStatusDropDown_AddLFGListApplicationButtons",true)
		self:RawHook("QueueStatusEntry_SetUpLFGListApplication",true)
		self:RawHook("QueueStatusEntry_SetUpLFGListActiveEntry",true)
		self:RawHook("LFGListSearchEntry_Update",function()end,true)
--		self:RawHook("LFGListFrame_OnEvent",function(...) print(...); end,true)
--		LFGListFrame:UnregisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED")
--		LFGListFrame:UnregisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED")
--		LFGListFrame:UnregisterEvent("LFG_LIST_APPLICANT_UPDATED")
		self:RawHook(QuickJoinFrame,"Show",function()end,true)
		self:RawHookScript(LFGListFrame,"OnEvent",function()end)
--		self:RawHookScript(QuickJoinMixin,"OnEvent",function() print("here") ;end,true)
	else
		self:UnhookAll()
	end
end

function LookingForGroup_Hook:LFGListCategorySelection_StartFindGroup(panel,b,questID)
	PVEFrame:Hide()
	if questID ~= nil then
		if LookingForGroup.db.profile.enable_wq then
			LookingForGroup.GetAddon("LookingForGroup_WQ"):QUEST_ACCEPTED(LookingForGroup,0,questID)
			return
		end
		local LookingForGroup_Options = LookingForGroup.GetAddon("LookingForGroup_Options")
		LookingForGroup_Options.db.profile.start_a_group_quest_id = questID
		LookingForGroup_Options.do_wq_search()
	else
		LookingForGroup.GetAddon("LookingForGroup_Options")
		AceConfigDialog:SelectGroup("LookingForGroup","find","f")
	end
	AceConfigDialog:Open("LookingForGroup")
end

function LookingForGroup_Hook:LFGListEntryCreation_Show(_,_,category)
	local option = LookingForGroup.GetAddon("LookingForGroup_Options")
	PVEFrame:Hide()
	option.SetCategory(_,category)
	AceConfigDialog:SelectGroup("LookingForGroup","find","s")
	AceConfigDialog:Open("LookingForGroup")
end

function LookingForGroup_Hook:LFGListUtil_OpenBestWindow()
	local option = LookingForGroup.GetAddon("LookingForGroup_Options")
	AceConfigDialog:SelectGroup("LookingForGroup","requests")
	AceConfigDialog:Open("LookingForGroup")
end

function LookingForGroup_Hook:QueueStatusDropDown_AddLFGListApplicationButtons(info, resultID)
	wipe(info)
	info.text = LookingForGroup.GetAddon("LookingForGroup_Core").GetSearchResultName(resultID)
	info.isTitle = 1
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info)
	wipe(info)
	info.text = CANCEL_SIGN_UP
	info.func = function(_,id) C_LFGList.CancelApplication(id)  end
	info.arg1 = resultID
	info.leftPadding = 10
	info.disabled = IsInGroup() and not UnitIsGroupLeader("player")
	UIDropDownMenu_AddButton(info)
end

function LookingForGroup_Hook:QueueStatusDropDown_AddLFGListButtons(info)
	wipe(info)
	if UnitIsGroupLeader("player") then
		info.text = EDIT
	else
		info.text = VIEW
	end
	info.func = function()
		LookingForGroup.GetAddon("LookingForGroup_Options").UpdateEditing()
		PVEFrame:Hide()
		AceConfigDialog:SelectGroup("LookingForGroup","find","s")
		AceConfigDialog:Open("LookingForGroup")
	end
	UIDropDownMenu_AddButton(info)
	info.text = LFG_LIST_VIEW_GROUP
	info.func = LFGListUtil_OpenBestWindow
	UIDropDownMenu_AddButton(info)
	if UnitIsGroupLeader("player") then
		info.text = UNLIST_MY_GROUP
		info.func = C_LFGList.RemoveListing
		UIDropDownMenu_AddButton(info)
	else
		local questID = select(11,C_LFGList.GetActiveEntryInfo())
		if questID ~= nil then
			info.text = START_A_GROUP
			info.arg1 = questID
			info.func = function(_,arg1) LookingForGroup.GetAddon("LookingForGroup_WQ"):START_A_GROUP(arg1) end
			UIDropDownMenu_AddButton(info)
		end
	end
end

function LookingForGroup_Hook:QueueStatusEntry_SetUpLFGListApplication(entry,resultID)
	local name , comment = LookingForGroup.GetAddon("LookingForGroup_Core").GetSearchResultName(resultID)
	QueueStatusEntry_SetMinimalDisplay(entry,name,QUEUE_STATUS_SIGNED_UP,comment)
end

function LookingForGroup_Hook:QueueStatusEntry_SetUpLFGListActiveEntry(entry)
	local name, info = LookingForGroup.GetAddon("LookingForGroup_Core").GetActiveEntryInfo()
	QueueStatusEntry_SetMinimalDisplay(entry,name,QUEUE_STATUS_LISTED,info)
end
