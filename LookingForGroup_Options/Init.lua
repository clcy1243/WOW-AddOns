local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup_Options = AceAddon:NewAddon("LookingForGroup_Options","AceEvent-3.0","AceTimer-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")

LookingForGroup_Options.option_table =
{
	type = "group",
	name = "LookingForGroup",
	args = {}
}

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

function LookingForGroup_Options.GetRoleIcon(role)
	if role == "DAMAGER" then
		return "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:22:41|t"
	elseif role == "HEALER" then
		return "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:1:20|t"
	elseif role == "TANK" then
		return "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:0:19:22:41|t"
	end
end

function LookingForGroup_Options : push(key,val)
	val.order = get_order()
	self.option_table.args[key] = val
end

function LookingForGroup_Options.set_search_result(tb)
	LookingForGroup_Options.option_table.args.search_result = tb
end

function LookingForGroup_Options.reset_search_result()
	LookingForGroup_Options.option_table.args.search_result = nil
end

function LookingForGroup_Options : get_table()
	return self.option_table
end

local LookingForGroup_AV
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_ApplyToGroup = C_LFGList.ApplyToGroup

local string_find = string.find
local tonumber = tonumber
local string_match = string.match

function LookingForGroup_Options.GetLFG_AV()
	if LookingForGroup_AV == nil then
		LookingForGroup_AV = LookingForGroup.GetAddon("LookingForGroup_AV")
	end
	return LookingForGroup_AV
end

local function is_ms(comment)
	if comment == nil then
		return false
	end
	local summary,data = string_match(comment,'^(.*)%((^1^.+^^)%)$')
	if data ~= nil then
		return true,summary
	else
		return false,comment
	end
end

function LookingForGroup_Options.ApplyToGroup(lfgid,cmt,...)
	local id, activityID, name, comment, voiceChat, iLvl, honorLevel,
		age, numBNetFriends, numCharFriends, numGuildMates,
		isDelisted, leaderName, numMembers, autoaccept = C_LFGList_GetSearchResultInfo(lfgid)
	if activityID == 44 and string_find(name,"#AV#") then
		if LookingForGroup_AV == nil then
			LookingForGroup_AV = LookingForGroup.GetAddon("LookingForGroup_AV")
		end
		LookingForGroup_AV.ApplyToGroup(lfgid,cmt,...)
		return
	end
	if comment ~= nil then
		local wq_id = tonumber(string_match(comment,"#WQ:([%d]+)#"))
		if wq_id ~= nil then
			C_LFGList_ApplyToGroup(lfgid, "WorldQuestGroupFinderUser-"..wq_id, ...)
			return
		end
		if string_find(comment,'^(.*)%((^1^.+^^)%)$') then
			if cmt == nil then
				cmt = ""
			end
			cmt = cmt.."^(^1^N18446744073709551615^^)"
		end
	end
	C_LFGList_ApplyToGroup(lfgid, cmt, ...)
end
