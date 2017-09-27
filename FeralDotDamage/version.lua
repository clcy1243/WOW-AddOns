local addon, C = ...
local addonChannel = "FDDAlea"
local remindMeagain = true
local name
local string_match = string.match
local format = format
local SendAddonMessage = SendAddonMessage
local tonumber = tonumber
local sendmessagethottle = 20
local versioncheck = 0
local versioncheck_guild = 0

if not IsAddonMessagePrefixRegistered(addonChannel) then
	RegisterAddonMessagePrefix(addonChannel)
end

function C:AddonMessage(msg, channel)

	if channel == "GUILD" and IsInGuild() then
		SendAddonMessage(addonChannel, msg, "GUILD")
	else
		local chatType = "PRINT"
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
			chatType = "INSTANCE_CHAT"
		elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
			chatType = "RAID"
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			chatType = "PARTY"
		end
			
		if chatType == "PRINT" then
			
		else
			SendAddonMessage(addonChannel, msg, chatType)
		end
	end
end

local function constructVersion(ver)
	local d1, d2, d3 = strsplit(".", ver)
	
	d1 = d1 or "0"
	d2 = d2 or "0"
	d3 = d3 or "0"
	
	if #d2 == 1 then
	   d2 = "00"..d2
	end
	if #d2 == 2 then
	   d2 = "0"..d2
	end
	if #d3 == 1 then
	   d3 = "00"..d3
	end
	if #d3 == 2 then
	   d3 = "0"..d3
	end
	
	return tonumber(d1..d2..d3)
end

local events = CreateFrame("Frame")
events:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

function events:CHAT_MSG_ADDON(event, prefix, message, channel, sender)
	if prefix ~= addonChannel then return end
	if sender == name then return end
	if not remindMeagain then return end

	local version, source = strsplit(":", message)
	
	if version and source then
		local cntrV = constructVersion(version)
		local cntrmV = constructVersion(C.myVersionT)
	
		if cntrV > cntrmV then
			remindMeagain = false
			C_Timer.After(10, function() print("FeralDotDamage: New version".." "..version.." ".." is availible!") end)
		end
	end
end

function events:SendAddonIndo()
	if GetTime() < versioncheck then return end
	versioncheck = GetTime() + sendmessagethottle
	C:AddonMessage(format("%s:%s", C.myVersionT, C.VersionSource))
end

function events:SendAddonIndo2(event)
	if GetTime() < versioncheck_guild then return end
	versioncheck_guild = GetTime() + sendmessagethottle
	C:AddonMessage(format("%s:%s", C.myVersionT, C.VersionSource) , "GUILD")
end

events.GROUP_ROSTER_UPDATE = events.SendAddonIndo
events.PLAYER_ENTERING_WORLD = events.SendAddonIndo2
events.PLAYER_ENTERING_BATTLEGROUND = events.SendAddonIndo
events.GROUP_JOINED = events.SendAddonIndo
events.RAID_INSTANCE_WELCOME = events.SendAddonIndo
events.ZONE_CHANGED_NEW_AREA = events.SendAddonIndo

events.GUILD_MOTD = events.SendAddonIndo2
events.GUILD_NEWS_UPDATE = events.SendAddonIndo2
events.GUILD_ROSTER_UPDATE = events.SendAddonIndo2

events:RegisterEvent("PLAYER_LOGIN")

function events:PLAYER_LOGIN()
	local version = GetAddOnMetadata(addon, "Version") or "0"
	local version_c = version:gsub("%.", "")
	
	name = UnitName("player").."-"..GetRealmName()
	
	C.myVersionT = version
	C.myVersion = tonumber(version_c) or 0
	C.VersionSource = GetAddOnMetadata(addon, "VersionType") or "curse"

	events:RegisterEvent("CHAT_MSG_ADDON")
	events:RegisterEvent("GROUP_ROSTER_UPDATE")
	events:RegisterEvent("PLAYER_ENTERING_WORLD")
	events:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
	events:RegisterEvent("GROUP_JOINED")
	events:RegisterEvent("RAID_INSTANCE_WELCOME")
	events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	events:RegisterEvent("GUILD_MOTD")
	events:RegisterEvent("GUILD_NEWS_UPDATE")
	events:RegisterEvent("GUILD_ROSTER_UPDATE")
	
	events:SendAddonIndo()
	events:SendAddonIndo2()
end
