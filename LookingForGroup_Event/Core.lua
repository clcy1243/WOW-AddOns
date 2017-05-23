local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Event = AceAddon:NewAddon("LookingForGroup_Event","AceEvent-3.0")

--------------------------------------------------------------------------------------

function LookingForGroup_Event:OnInitialize()
end

function LookingForGroup_Event:OnEnable()
	if LookingForGroup.db.profile.enable_event then
		self:RegisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED")
		self:RegisterEvent("GROUP_ROSTER_UPDATE")
	else
		self:UnregisterAllEvents()
	end
end

function LookingForGroup_Event:LFG_LIST_APPLICANT_LIST_UPDATED()
	if UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME) and not IsInRaid(LE_PARTY_CATEGORY_HOME) and MAX_PARTY_MEMBERS + 1 < GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) + C_LFGList.GetNumInvitedApplicantMembers() + C_LFGList.GetNumPendingApplicantMembers()then
		local active, activityID, iLevel, honorLevel, name, comment, voiceChat, expiration, autoAccept, privateGroup, questID = C_LFGList.GetActiveEntryInfo()
		if autoAccept then
			local categoryID = select(3,C_LFGList.GetActivityInfo(activityID))
			if categoryID == 3 or categoryID == 9 then
				ConvertToRaid()
			elseif categoryID == 6 then
				StaticPopup_Show("LFG_LIST_AUTO_ACCEPT_CONVERT_TO_RAID")
			end
		end
	end
end

function LookingForGroup_Event:GROUP_ROSTER_UPDATE(...)
	if UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME) and IsInRaid(LE_PARTY_CATEGORY_HOME) and GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) + C_LFGList.GetNumInvitedApplicantMembers() + C_LFGList.GetNumPendingApplicantMembers() < MAX_PARTY_MEMBERS + 2 then
		ConvertToParty()
	end
end
