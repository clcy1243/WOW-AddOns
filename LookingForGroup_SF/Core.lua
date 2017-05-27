local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_SF = AceAddon:NewAddon("LookingForGroup_SF")

LookingForGroup_SF.addon_filters =
{
	"%[WQGF%]",
	"大脚任务进度提示:",
	"进度:",
	"<大脚团队提示>",
	"<大脚组队提示>",
	"PS 死亡:"
}

local function system_filter()
	return true
end

function LookingForGroup_SF:OnInitialize()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM",system_filter)
end

local function addon_filter(_, _, msg)
	local filters = LookingForGroup_SF.addon_filters
	local i
	local n = #filters
	local string_find = string.find
	for i=1,n do
		local ele = filters[i]
		if string_find(msg,ele) then
			return true
		end
	end
	return false
end

local function msg_filter(_, _, msg, player, _, _, _, _, _, _, _, _, _, guid)
	if addon_filter(_, _, msg) then
		return true
	end
	if guid and (IsGuildMember(guid) or IsCharacterFriend(guid) or UnitInRaid(player) or UnitInParty(player) or guid == UnitGUID("player") or select(2,BNGetGameAccountInfoByGUID(guid))) then
		return false
	end
	msg = msg:gsub("[ /]",""):lower()
	local filters = LookingForGroup.db.profile.spam_filter_keywords
	local string_find = string.find
	local n = #filters
	for i=1,n do
		local ele = filters[i]
		if string_find(msg,ele) then
			return true
		end
	end
	return false
end


function LookingForGroup_SF:OnEnable()
	local api = ChatFrame_RemoveMessageEventFilter
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM",system_filter)
	if LookingForGroup.db.profile.enable_sf then
		api = ChatFrame_AddMessageEventFilter
	end
	api("CHAT_MSG_WHISPER",msg_filter)
	api("CHAT_MSG_SAY",msg_filter)
	api("CHAT_MSG_DND",msg_filter)
	api("CHAT_MSG_YELL",msg_filter)
	api("CHAT_MSG_AFK",msg_filter)
	api("CHAT_MSG_SYSTEM",msg_filter)
	api("CHAT_MSG_CHANNEL",msg_filter)
	api("CHAT_MSG_RAID",addon_filter)
	api("CHAT_MSG_RAID_LEADER",addon_filter)
	api("CHAT_MSG_PARTY",addon_filter)
	api("CHAT_MSG_PARTY_LEADER",addon_filter)
	api("CHAT_MSG_INSTANCE_CHAT",addon_filter)
	api("CHAT_MSG_INSTANCE_CHAT_LEADER",addon_filter)
	api("CHAT_MSG_RAID_WARNING",addon_filter)
end
