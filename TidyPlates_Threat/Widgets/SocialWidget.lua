--------------------------------------------------------------------------------------------------------
--                                         Social Icon Widget                                         --
--------------------------------------------------------------------------------------------------------
-- This widget is designed to show a single icon to display the relationship of a player's nameplate by name (regardless of faction if a bnet friend).
-- To-Do:
-- Possibly change the method to show 3 icons.
-- Change the 'guildicon' to use the emblem and border method used by blizzard frames.

local _, ns = ...
local t = ns.TidyPlates_Threat

local path = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\SocialWidget\\"
local DB

ListTable = {
	g = {},
	b = {},
	f = {}
}

--------------------------------------------------------------------------------------------------------
--                                         General functions                                          --
--------------------------------------------------------------------------------------------------------
local function ParseRealm(input)
	local output, _
	if type(input) == "string" then
		output, _ = strsplit("-", input, 2)
	else
		output = ""
	end
	return output
end

local function UpdateGlist()
	wipe(ListTable.g)
	for i = 1, GetNumGuildMembers() do
		local name = select(1, GetGuildRosterInfo(i))
		tinsert(ListTable.g, ParseRealm(name))
	end
end

local function UpdateFlist()
	wipe(ListTable.f)
	local friendsTotal, friendsOnline = GetNumFriends()
	for i = 1, friendsOnline do
		local name, level, class, area, connected, status, note = GetFriendInfo(i)
		tinsert(ListTable.f, ParseRealm(name))
	end
end

local function UpdateBnetList()
	wipe(ListTable.b)
	local BnetTotal, BnetOnline = BNGetNumFriends()
	for i = 1, BnetOnline do
		local presenceID, givenName, surname, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, broadcastText, noteText, isFriend, broadcastTime  = BNGetFriendInfo(i)
		if isOnline and toonID and client == "WoW" then
			local _, name, _, realmName, faction, race, class, guild, area, lvl = BNGetToonInfo(toonID)
			tinsert(ListTable.b, ParseRealm(name))
		end
	end
end

local function UpdateSettings(frame)
	frame:SetSize(DB.scale, DB.scale)
	frame:SetPoint("CENTER", frame:GetParent(), DB.anchor, DB.x, DB.y)
end

--------------------------------------------------------------------------------------------------------
--                                           Events watcher                                           --
--------------------------------------------------------------------------------------------------------
local WatcherFrame = CreateFrame("frame")
local isEnabled = false

local function EnableWatcherFrame()
	if not isEnabled then
		isEnabled = true

		UpdateGlist()
		UpdateFlist()
		UpdateBnetList()

		WatcherFrame:RegisterEvent("FRIENDLIST_UPDATE")
		WatcherFrame:RegisterEvent("GUILD_ROSTER_UPDATE")
		WatcherFrame:RegisterEvent("BN_CONNECTED")
		WatcherFrame:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
		WatcherFrame:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
		WatcherFrame:RegisterEvent("BN_FRIEND_LIST_SIZE_CHANGED")
	end
end

local function DisableWatcherFrame()
	if isEnabled then
		isEnabled = false
		WatcherFrame:UnregisterAllEvents()
	end
end

WatcherFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "GUILD_ROSTER_UPDATE" then
		UpdateGlist()
	elseif event == "FRIENDLIST_UPDATE" then
		UpdateFlist()
	elseif event == "BN_FRIEND_LIST_SIZE_CHANGED" or event == "BN_CONNECTED" or event == "BN_FRIEND_ACCOUNT_ONLINE" or event == "BN_FRIEND_ACCOUNT_OFFLINE" then
		UpdateBnetList()
	end
	t.Update()
end)

local function enabled()
	DB = TidyPlatesThreat.db.profile.socialWidget
	if DB.ON then
		EnableWatcherFrame()
	else
		DisableWatcherFrame()
	end
	return DB.ON
end

--------------------------------------------------------------------------------------------------------
--                                          Widget functions                                          --
--------------------------------------------------------------------------------------------------------
local UpdateSocialWidget = function(frame, unit)
	if enabled() then
		-- I will probably expand this to a table with 'friend = true', 'guild = true', and 'bnet = true' and have 3 textuers show.
		local texture
		if tContains(ListTable.f, unit.name) then
			texture = path.."friendicon"
		elseif tContains(ListTable.b, unit.name) then
			texture = "Interface\\FriendsFrame\\PlusManz-BattleNet"
		elseif tContains(ListTable.g, unit.name) then
			texture = path.."guildicon"
		end

		if texture then
			UpdateSettings(frame)
			frame:SetFrameLevel(frame:GetParent():GetFrameLevel() + 2)
			frame.Icon:SetTexture(texture)
			frame:Show()
		else
			frame:Hide()
		end

	else
		frame:Hide()
	end
end

local function CreateSocialWidget(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(32, 32)
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetAllPoints(frame)

	frame:Hide()
	frame.Update = UpdateSocialWidget
	return frame
end

ThreatPlatesWidgets.RegisterWidget("SocialWidget", CreateSocialWidget, false, enabled)
