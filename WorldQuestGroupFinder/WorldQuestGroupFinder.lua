local WorldQuestGroupFinderAddon = CreateFrame("Frame", "WorldQuestGroupFinderAddon", UIParent)

local L = LibStub ("AceLocale-3.0"):GetLocale ("WorldQuestGroupFinder", true)

WorldQuestGroupFinder = {}

local RegisteredEvents = {}
WorldQuestGroupFinderAddon:SetScript("OnEvent", function (self, event, ...) if (RegisteredEvents[event]) then return RegisteredEvents[event](self, event, ...) end end)

local name = "WorldQuestGroupCurrentWQFrame"
local currentWQFrame = CreateFrame("frame",name,UIParent)
currentWQFrame.KickButton = CreateFrame("button", currentWQFrame:GetName().."KickButton", currentWQFrame)
currentWQFrame.RefreshButton = CreateFrame("button", currentWQFrame:GetName().."RefreshButton", currentWQFrame)
currentWQFrame.StopButton = CreateFrame("button", currentWQFrame:GetName().."StopButton", currentWQFrame)
			
local currentWQ = nil
local tempWQ = nil
local popupWQ = nil
local recentlyTimedOut = false
local recentlyInvited = false
local upToDateGroupMembersCount = 0
local currentlyApplying = false
local INVITE_TIMEOUT_DELAY = 8
local BROADCAST_PREFIX = "WQGF"
local playerRealmType = "PVE"
local pendingInvites = 0
local recentlyInvitedPlayers = false
local autoInviteRunning = false
local autoInviteQueued = false

local activityIDs = {
	[1015] = 419,
	[1018] = 420, 
	[1024] = 421, 
	[1017] = 422, 
	[1033] = 423,
	[1022] = 422, -- Create Helheim WQ in Stormheim
	[1096] = 419 -- Create Eye of Azshara WQs in Aszuna
}

local blacklistedQuests = { 
	[45379] = true, -- Treasure Master Iks'reeged  
	[45988] = true, -- Ancient Bones  
	[43943] = true, -- Withered Army Training
	[42725] = true, -- Sharing the Wealth
	[42880] = true, -- Meeting their Quota
	[42178] = true, -- Shock Absorber
	[42173] = true, -- Electrosnack  
	[44011] = true, -- Lost Wisp
	[43774] = true, -- Ley Race
	[43764] = true, -- Ley Race
	[43753] = true, -- Ley Race
	[43325] = true, -- Ley Race
	[43769] = true, -- Ley Race
	[43772] = true, -- Enigmatic
	[43767] = true, -- Enigmatic
	[43756] = true, -- Enigmatic
	[45032] = true, -- Like the Wind
	[45046] = true, -- Like the Wind
	[45047] = true, -- Like the Wind
	[45048] = true, -- Like the Wind
	[45049] = true, -- Like the Wind
	[45068] = true, -- Barrels o' fun
	[45069] = true, -- Barrels o' fun
	[45070] = true, -- Barrels o' fun
	[45071] = true, -- Barrels o' fun
	[45072] = true, -- Barrels o' fun
	[44786] = true, -- Midterm: Rune Aptitude
	[41327] = true, -- Supplies Needed: Stormscales
	[41345] = true, -- Supplies Needed: Stormscales
	[41318] = true, -- Supplies Needed: Felslate
	[41237] = true, -- Supplies Needed: Stonehide Leather
	[41339] = true, -- Supplies Needed: Stonehide Leather
	[41351] = true, -- Supplies Needed: Stonehide Leather
	[41207] = true, -- Supplies Needed: Leystone
	[41298] = true, -- Supplies Needed: Fjarnskaggl
	[41315] = true, -- Supplies Needed: Leystone
	[41316] = true, -- Supplies Needed: Leystone
	[41317] = true, -- Supplies Needed: Leystone
	[41303] = true, -- Supplies Needed: Starlight Roses
	[41288] = true, -- Supplies Needed: Aethril
	[44932] = true, -- The Nighthold: Ettin Your Foot In The Door
	[44937] = true, -- The Nighthold: Focused Power
	[44934] = true, -- The Nighthold: Creepy Crawlers
	[44935] = true, -- The Nighthold: Gilded Guardian
	[44938] = true, -- The Nighthold: Love Tap
	[44939] = true, -- The Nighthold: Seeds of Destruction
	[44936] = true, -- The Nighthold: Supply Routes
	[44933] = true, -- The Nighthold: Wailing In The Night
}

-- Quests you can complete while in a raid
local raidQuests = { 
	[42820] = true, -- DANGER: Aegir Wavecrusher
	[41685] = true, -- DANGER: Ala'washte
	[44113] = true, -- DANGER: Anachronos
	[43091] = true, -- DANGER: Arcanor Prime
	[44118] = true, -- DANGER: Auditor Esiel
	[44121] = true, -- DANGER: Az'jatar
	[44189] = true, -- DANGER: Bestrix
	[42861] = true, -- DANGER: Boulderfall, the Eroded
	[42864] = true, -- DANGER: Captain Dargun
	[43121] = true, -- DANGER: Chief Treasurer Jabrill
	[41697] = true, -- DANGER: Colerian, Alteria, and Selenyi
	[43175] = true, -- DANGER: Deepclaw
	[41695] = true, -- DANGER: Defilia
	[42785] = true, -- DANGER: Den Mother Ylva
	[41093] = true, -- DANGER: Durguth
	[43346] = true, -- DANGER: Ealdis
	[43059] = true, -- DANGER: Fjordun
	[42806] = true, -- DANGER: Fjorlag, the Grave's Chill
	[43345] = true, -- DANGER: Harbinger of Screams
	[43079] = true, -- DANGER: Immolian
	[44190] = true, -- DANGER: Jade Darkhaven
	[44191] = true, -- DANGER: Karthax
	[43798] = true, -- DANGER: Kosumoth the Hungering
	[42964] = true, -- DANGER: Lagertha
	[44192] = true, -- DANGER: Lysanis Shadesoul
	[43152] = true, -- DANGER: Lytheron
	[44114] = true, -- DANGER: Magistrix Vilessa
	[42927] = true, -- DANGER: Malisandra
	[43098] = true, -- DANGER: Marblub the Massive
	[41696] = true, -- DANGER: Mawat'aki
	[43027] = true, -- DANGER: Mortiferous
	[43333] = true, -- DANGER: Nylaathria the Forgotten
	[41703] = true, -- DANGER: Ormagrogg
	[41816] = true, -- DANGER: Oubdob da Smasher
	[43347] = true, -- DANGER: Rabxach
	[42963] = true, -- DANGER: Rulf Bonesnapper
	[42991] = true, -- DANGER: Runeseer Sigvid
	[42797] = true, -- DANGER: Scythemaster Cil'raman
	[44193] = true, -- DANGER: Sea King Tidross
	[41700] = true, -- DANGER: Shalas'aman
	[44122] = true, -- DANGER: Sorallus
	[42953] = true, -- DANGER: Soulbinder Halldora
	[43072] = true, -- DANGER: The Whisperer
	[44194] = true, -- DANGER: Torrentius
	[43040] = true, -- DANGER: Valakar the Thirsty
	[44119] = true, -- DANGER: Volshax, Breaker of Will
	[43101] = true, -- DANGER: Withdoctor Grgl-Brgl
	[41779] = true, -- DANGER: Xavrix
	[44017] = true, -- WANTED: Apothecary Faldren
	[44032] = true, -- WANTED: Apothecary Faldren
	[42636] = true, -- WANTED: Arcanist Shal'iman
	[43605] = true, -- WANTED: Arcanist Shal'iman
	[42620] = true, -- WANTED: Arcavellus
	[43606] = true, -- WANTED: Arcavellus
	[41824] = true, -- WANTED: Arru
	[44289] = true, -- WANTED: Arru
	[44301] = true, -- WANTED: Bahagar
	[44305] = true, -- WANTED: Bahagar
	[41836] = true, -- WANTED: Bodash the Hoarder
	[43616] = true, -- WANTED: Bodash the Hoarder
	[41828] = true, -- WANTED: Bristlemaul
	[44290] = true, -- WANTED: Bristlemaul
	[43426] = true, -- WANTED: Brogozog
	[43607] = true, -- WANTED: Brogozog
	[42796] = true, -- WANTED: Broodmother Shu'malis
	[44016] = true, -- WANTED: Cadraeus
	[44031] = true, -- WANTED: Cadraeus
	[43430] = true, -- WANTED: Captain Volo'ren
	[43608] = true, -- WANTED: Captain Volo'ren
	[41826] = true, -- WANTED: Crawshuk the Hungry
	[44291] = true, -- WANTED: Crawshuk the Hungry
	[44299] = true, -- WANTED: Darkshade
	[44304] = true, -- WANTED: Darkshade
	[43455] = true, -- WANTED: Devouring Darkness
	[43617] = true, -- WANTED: Devouring Darkness
	[43428] = true, -- WANTED: Doomlord Kazrok
	[43609] = true, -- WANTED: Doomlord Kazrok
	[44298] = true, -- WANTED: Dreadbog
	[44303] = true, -- WANTED: Dreadbog
	[43454] = true, -- WANTED: Egyl the Enduring
	[43620] = true, -- WANTED: Egyl the Enduring
	[43434] = true, -- WANTED: Fathnyr
	[43621] = true, -- WANTED: Fathnyr
	[43436] = true, -- WANTED: Glimar Ironfist
	[43622] = true, -- WANTED: Glimar Ironfist
	[44030] = true, -- WANTED: Guardian Thor'el
	[44013] = true, -- WANTED: Guardian Thor'el
	[41819] = true, -- WANTED: Gurbog da Basher
	[43618] = true, -- WANTED: Gurbog da Basher
	[43453] = true, -- WANTED: Hannval the Butcher
	[43623] = true, -- WANTED: Hannval the Butcher
	[44021] = true, -- WANTED: Hertha Grimdottir
	[44029] = true, -- WANTED: Hertha Grimdottir
	[43427] = true, -- WANTED: Infernal Lord
	[43610] = true, -- WANTED: Infernal Lord
	[43611] = true, -- WANTED: Inquisitor Tivos
	[42631] = true, -- WANTED: Inquisitor Tivos
	[43452] = true, -- WANTED: Isel the Hammer
	[43624] = true, -- WANTED: Isel the Hammer
	[43460] = true, -- WANTED: Kiranys Duskwhisper
	[43629] = true, -- WANTED: Kiranys Duskwhisper
	[44028] = true, -- WANTED: Lieutenant Strathmar
	[44019] = true, -- WANTED: Lieutenant Strathmar
	[44018] = true, -- WANTED: Magister Phaedris
	[44027] = true, -- WANTED: Magister Phaedris
	[41818] = true, -- WANTED: Majestic Elderhorn
	[44292] = true, -- WANTED: Majestic Elderhorn
	[44015] = true, -- WANTED: Mal'Dreth the Corruptor
	[44026] = true, -- WANTED: Mal'Dreth the Corruptor
	[43438] = true, -- WANTED: Nameless King
	[43625] = true, -- WANTED: Nameless King
	[43432] = true, -- WANTED: Normantis the Deposed
	[43612] = true, -- WANTED: Normantis the Deposed
	[41686] = true, -- WANTED: Olokk the Shipbreaker
	[44010] = true, -- WANTED: Oreth the Vile
	[43458] = true, -- WANTED: Perrexx
	[43630] = true, -- WANTED: Perrexx
	[42795] = true, -- WANTED: Sanaar
	[44300] = true, -- WANTED: Seersei
	[44302] = true, -- WANTED: Seersei
	[41844] = true, -- WANTED: Sekhan
	[44294] = true, -- WANTED: Sekhan
	[44022] = true, -- WANTED: Shal'an
	[41821] = true, -- WANTED: Shara Felbreath
	[43619] = true, -- WANTED: Shara Felbreath
	[44012] = true, -- WANTED: Siegemaster Aedrin
	[44023] = true, -- WANTED: Siegemaster Aedrin
	[43456] = true, -- WANTED: Skul'vrax
	[43631] = true, -- WANTED: Skul'vrax
	[41838] = true, -- WANTED: Slumber
	[44293] = true, -- WANTED: Slumber
	[43429] = true, -- WANTED: Syphonus
	[43613] = true, -- WANTED: Syphonus
	[43437] = true, -- WANTED: Thane Irglov
	[43626] = true, -- WANTED: Thane Irglov
	[43457] = true, -- WANTED: Theryssia
	[43632] = true, -- WANTED: Theryssia
	[43459] = true, -- WANTED: Thondrax
	[43633] = true, -- WANTED: Thondrax
	[43450] = true, -- WANTED: Tiptog the Lost
	[43627] = true, -- WANTED: Tiptog the Lost
	[43451] = true, -- WANTED: Urgev the Flayer
	[43628] = true, -- WANTED: Urgev the Flayer
	[42633] = true, -- WANTED: Vorthax
	[43614] = true, -- WANTED: Vorthax
	[43431] = true, -- WANTED: Warbringer Mox'na
}

local WorldBosses = {
	[46945] = true, -- Si'vash
	[47061] = true, -- Apocron
	[46948] = true, -- Malificus
	[42270] = true, -- Scourge of the Skies
	[44287] = true, -- DEADLY: Withered J'im
	[43192] = true, -- Terror of the Deep
	[43448] = true, -- The Frozen King
	[43193] = true, -- Calamitous Intent
	[42779] = true, -- The Sleeping Corruption
	[42269] = true, -- The Soultakers
	[42819] = true, -- Pocket Wizard
	[42270] = true, -- Scourge of the Skies
	[43512] = true, -- Ana-Mouz
	[43985] = true -- A Dark Tide
}

local pendingApplications = {}
local blacklistedLeaders = {}
local blacklistedRealmHoppers = {}
local seenWorldQuests = {}

local function chsize(char)
    if not char then
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end
 
function RegisteredEvents:ADDON_LOADED(event, addon, ...)
	if (addon == "WorldQuestGroupFinder") then
		RegisterAddonMessagePrefix(BROADCAST_PREFIX)
		SLASH_WQGF1 = '/wqgf'
		SlashCmdList["WQGF"] = function (msg, editbox)
			WorldQuestGroupFinder.handleCMD(msg, editbox)	
		end
		setmetatable(WorldQuestGroupFinderConfig, {__index = WorldQuestGroupFinderConf.DefaultConfig})
	end
end

function RegisteredEvents:PLAYER_LOGIN(event)
	if (not WorldQuestGroupFinderConf.GetConfigValue("silent")) then
		print("|c00bfffffWorld Quest Group Finder v"..GetAddOnMetadata("WorldQuestGroupFinder", "Version").." BETA. "..L["WQGF_INIT_MSG"])
	end
	WorldQuestGroupFinder.SetHooks()
	WorldQuestGroupFinderConf.CreateConfigMenu()
	WorldQuestGroupFinder.dprint("World Quest Group Finder - "..L["WQGF_DEBUG_MODE_ENABLED"])
	C_Timer.After(1, function()
		local playerRealmInfo = select(4, LibStub("LibRealmInfo"):GetRealmInfoByUnit("player"))
		if (playerRealmInfo == "PVP" or playerRealmInfo == "RPPVP") then
			playerRealmType = "PVP"
		end
		if (WorldQuestGroupFinderConf.GetConfigValue("savedCurrentWQ", "CHAR") ~= nil and currentWQ == nil) then
			if (IsInGroup() and C_LFGList.GetActiveEntryInfo()) then
				WorldQuestGroupFinder.dprint("Retrieved saved current world quest info. Still in group. Restoring...")
				WorldQuestGroupFinder.HandleWorldQuestStart(WorldQuestGroupFinderConf.GetConfigValue("savedCurrentWQ", "CHAR"))
			else
				WorldQuestGroupFinder.dprint("Retrieved saved current world quest info. No longer in group. Deleting...")
				WorldQuestGroupFinderConf.SetConfigValue("savedCurrentWQ", nil, "CHAR")
			end
		end
		-- Load WQs list
		SetMapToCurrentZone()
	end)
end

function RegisteredEvents:LFG_LIST_APPLICANT_LIST_UPDATED(event, hasNewPending, hasNewPendingWithData)
	if ( currentWQ ~= nil and hasNewPending and hasNewPendingWithData and LFGListUtil_IsEntryEmpowered()) then
		WorldQuestGroupFinder.HandleCustomAutoInvite()
	end
end

function RegisteredEvents:LFG_LIST_APPLICANT_UPDATED(event, applicantID)
	pendingInvites = C_LFGList.GetNumInvitedApplicantMembers()
	local id, status, pendingStatus, numMembers, isNew, comment = C_LFGList.GetApplicantInfo(applicantID)
	if (currentWQ and status == "inviteaccepted" and comment == "WorldQuestGroupFinderUser-"..currentWQ) then
		if (numMembers > 1) then
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_USERS_JOINED"], true)
		else
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_USER_JOINED"], true)
		end
	end
end

function RegisteredEvents:CHAT_MSG_ADDON(event, prefix, message, channel, sender)
	local cutPlayerName = (string.gsub(sender, "(.*)-(.*)", "%1"))
	if (prefix == BROADCAST_PREFIX and cutPlayerName ~= UnitName("player")) then
		WorldQuestGroupFinder.dprint(string.format("Received addon message. Sender: %s. Message: %s.", sender, message))
		if (string.find(message, "#WQS:")) then
			local tmpMsgWQ = string.gsub(message, "#WQS:(.*)#", "%1")
			tempWQ = tonumber(tmpMsgWQ)
			local isWQ = true
			if not QuestUtils_IsQuestWorldQuest(tempWQ) then
				isWQ = false
			end
			if (tempWQ ~= currentWQ) then
				if(IsQuestFlaggedCompleted(tempWQ)) then
					if isWQ then
						WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NOW_DOING_WQ_ALREADY_COMPLETE"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
					else
						WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NOW_DOING_QUEST_ALREADY_COMPLETE"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
					end
				else
					if (WorldQuestGroupFinder.HandleWorldQuestStart(tempWQ)) then						
						if isWQ then
							WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NOW_DOING_WQ"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
						else
							WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NOW_DOING_QUEST"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
						end
					else 					
						if isWQ then
							WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NOW_DOING_WQ_NOT_ELIGIBLE"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
						else
							WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NOW_DOING_QUEST_NOT_ELIGIBLE"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
						end
						
					end
				end	
			end
		elseif (string.find(message, "#WQE:")) then
			local tmpMsgWQ = string.gsub(message, "#WQE:(.*)#", "%1")
			tempWQ = tonumber(tmpMsgWQ)
			local isWQ = true
			if not QuestUtils_IsQuestWorldQuest(tempWQ) then
				isWQ = false
			end
			if isWQ then
				WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NO_LONGER_DOING_WQ"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
			else
				WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_NO_LONGER_DOING_QUEST"], WorldQuestGroupFinder.GetQuestInfo(tempWQ)), true)
			end
			if (currentWQ == tempWQ) then
				WorldQuestGroupFinder.HandleWorldQuestEnd(tempWQ)
			end
		end
	end
	CheckDistances()
end

function RegisteredEvents:QUEST_TURNED_IN(event, questID, experience, money)
	-- Hide join WQ prompts
	local isWQ = true
	if not QuestUtils_IsQuestWorldQuest(questID) then
		isWQ = false
	end
	WorldQuestGroupFinder.HideDialog ("WORLD_QUEST_ENTERED_PROMPT")
	WorldQuestGroupFinder.HideDialog ("WORLD_QUEST_ENTERED_SWITCH_PROMPT")
	WorldQuestGroupFinder.dprint(string.format("Quest complete. (ID: %d)", questID))
	if (currentWQ ~= nil and questID == currentWQ) then
		if (WorldQuestGroupFinderConf.GetConfigValue("notifyParty") and IsInGroup()) then
			WorldQuestGroupFinder.SendWQCompletionPartyNotification(questID)
		end
		if (WorldQuestGroupFinderConf.GetConfigValue("askToLeave")) then
			if (WorldQuestGroupFinderConf.GetConfigValue("autoLeaveGroup")) then
				if isWQ then
					WorldQuestGroupFinder.ShowDialog ("WORLD_QUEST_COMPLETED_LEAVE_GROUP_DIALOG")
				else
					WorldQuestGroupFinder.ShowDialog ("QUEST_COMPLETED_LEAVE_GROUP_DIALOG")
				end
			else
				WorldQuestGroupFinder.ShowLeavePrompt(isWQ)
			end
		end
		WorldQuestGroupFinder.HandleWorldQuestEnd(currentWQ)
	end
end

function RegisteredEvents:LFG_LIST_APPLICATION_STATUS_UPDATED(event, applicationID, status)
	if (currentlyApplying) then
		local _,_,name,description,_,ilvl,_,_,_,_,_,_,author,members,autoinv = C_LFGList.GetSearchResultInfo(applicationID)
		WorldQuestGroupFinder.dprint(string.format("Application has changed status. ID: %d. New status: %s.", applicationID, status))
		if (status == "applied") then
			pendingApplications[applicationID] = tempWQ
		end
		if (status == "invited") then
			-- Set as recently invited, to avoid the cancelled status for other applied groups
			if (WorldQuestGroupFinderConf.GetConfigValue("autoAcceptInvites") and not recentlyInvited) then
				if (not InCombatLockdown()) then
					WorldQuestGroupFinder.dprint(string.format("Auto-accepting group invite (ID: %d)", applicationID))
					C_LFGList.AcceptInvite(applicationID)
				else
					WorldQuestGroupFinder.dprint("Not auto-accepting invite (in combat)")
				end
			end
			recentlyInvited = true
			WorldQuestGroupFinder.StopTimeoutTimer()
		end
		if (status == "declined") then
			if (author) then
				blacklistedLeaders[author] = true
			end
			-- If all applications have been declined, restart process. A new group will be created if nothing else is found.
			if ((C_LFGList.GetNumApplications() - 1 == 0) and not (recentlyInvited or currentWQ)) then
				WorldQuestGroupFinder.InitWQGroup(pendingApplications[applicationID], true)
			end
			table.remove(pendingApplications, applicationID)
		end
		if (status == "failed" or status == "timedout") then
			if (pendingApplications[applicationID]) then
				table.remove(pendingApplications, applicationID)
			end
		end
		if (status == "invitedeclined") then
			blacklistedLeaders[author] = true
			--WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_WQ_GROUP_APPLY_CANCELLED"], author, WorldQuestGroupFinder.GetQuestInfo(pendingApplications[applicationID])), true)
			table.remove(pendingApplications, applicationID)
			if (C_LFGList.GetNumApplications() == 0) then
				WorldQuestGroupFinder.StopTimeoutTimer()
			end
		end
		if (status == "cancelled") then
			-- If cancelled status was caused by the addon
			if (recentlyTimedOut or recentlyInvited or currentWQ) then
				C_Timer.After(1, function()
					recentlyTimedOut = false
				end)
			else
				if (author) then
					blacklistedLeaders[author] = true
					WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_WQ_GROUP_APPLY_CANCELLED"], author, WorldQuestGroupFinder.GetQuestInfo(pendingApplications[applicationID])), true)
				end
				table.remove(pendingApplications, applicationID)
				if (C_LFGList.GetNumApplications() == 0) then
					WorldQuestGroupFinder.StopTimeoutTimer()
				end
			end
			C_Timer.After(1, function()
				recentlyInvited = false
			end)
		end
		if (status == "inviteaccepted") then
			recentlyInvited = false
			local savedWQID = pendingApplications[applicationID]
			if (author) then
				WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_JOINED_WQ_GROUP"], author, WorldQuestGroupFinder.GetQuestInfo(savedWQID)), true)
			end
			WorldQuestGroupFinder.HandleWorldQuestStart(savedWQID)
			C_Timer.After(1, function()
				if (IsInRaid()) then
					if (not raidQuests[savedWQID]) then
						WorldQuestGroupFinder.prefixedPrint(L["WQGF_RAID_MODE_WARNING"])
					end
				end
			end)
		end
		
		if (C_LFGList.GetNumApplications() <= 0) then
			currentlyApplying = false
		end
	end
end

function GetUnitID(RosterIndex)
	if IsInRaid() then
		return "raid"..RosterIndex
	end
	if RosterIndex == 1 then
		return "player"
	end
	return "party" .. (RosterIndex - 1)
end

function KickHoppers()
	if (currentWQ ~= nil) then
		if (UnitIsGroupLeader("player")) then
			for i=1, GetNumGroupMembers() do 
				local unitName, unitRank = GetRaidRosterInfo(i)
				if (unitRank ~= 2 and blacklistedRealmHoppers[unitName] == true) then
					WorldQuestGroupFinder.dprint(string.format("Kicking %s for being too far away...", unitName))
					UninviteUnit(unitName)
				end
			end
		end
	end
	currentWQFrame.KickButton:Hide()
end

function CheckDistances()
	if (currentWQ ~= nil) then
		if (UnitIsGroupLeader("player")) then
			-- Auto-kick all realm hoppers (players that are more than 650 yards away)
			for i=1, GetNumGroupMembers() do
				local unitName, unitRank = GetRaidRosterInfo(i)
				if unitName == GetUnitName(GetUnitID(i), true) then		-- make sure we don't kick the wrong players
					if (unitRank ~= 2 and blacklistedRealmHoppers[unitName] == nil) then
						distanceSquared, checkedDistance = UnitDistanceSquared(GetUnitID(i))
						if checkedDistance then
							if distanceSquared ^ 0.5 >= 650 then
								WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_MEMBER_TOO_FAR_AWAY"], unitName, floor(distanceSquared ^ 0.5 + 0.5)))
								blacklistedRealmHoppers[unitName] = true
								currentWQFrame.KickButton:Show()
							end
						else
							-- distance could not be determined, check again after 1 second
							C_Timer.After(1, CheckDistances)
						end
					end
				else
					WorldQuestGroupFinder.dprint(string.format("WARNING! Unit name of %s mismatch: %s != %s", GetUnitID(i), unitName, GetUnitName(GetUnitID(i), true)))
				end						
			end
		end
	end
end

function RegisteredEvents:GROUP_ROSTER_UPDATE(event)
	-- Remember that this event is often triggered multiple times
	if (currentWQ ~= nil) then
		-- Leaving the group.
		if (not IsInGroup()) then
			WorldQuestGroupFinder.HideDialog ("WORLD_QUEST_COMPLETED_LEAVE_GROUP_DIALOG")
			WorldQuestGroupFinder.HandleWorldQuestEnd(currentWQ)
			pendingInvites = 0
		end
		if (UnitIsGroupLeader("player")) then
			CheckDistances()
			-- If doing a world quest, group is not full and applicants are waiting, we will try to invite them
			C_Timer.After(1, function()
				if (((GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) + C_LFGList.GetNumInvitedApplicantMembers() < (MAX_PARTY_MEMBERS+1)) or raidQuests[currentWQ]) and C_LFGList.GetNumApplicants() > 0) then
					WorldQuestGroupFinder.HandleCustomAutoInvite()
				end
			end)
			-- You don't want to  be in raid mode, unless it is an elite quest
			if (IsInRaid() and GetNumGroupMembers() <= MAX_PARTY_MEMBERS+1 and not raidQuests[currentWQ]) then
				ConvertToParty()
			end			
			-- Check for auto-invite. We don't like that!
			local autoInviteStatus = select(9, C_LFGList.GetActiveEntryInfo())
			if (autoInviteStatus) then
				LFGListUtil_SetAutoAccept(false)
				LFGListFrame.ApplicationViewer.AutoAcceptButton:SetChecked(false)
			end
			-- Check if realm type has changed
			local descRealmType = WorldQuestGroupFinder.getRealmTypeFromDescription()
			if (descRealmType) then
				local currentRealmType = WorldQuestGroupFinder.getCurrentRealmType()
				if (currentRealmType ~= descRealmType) then
					WorldQuestGroupFinder.dprint(string.format("Changing current realm type in comment to %s", currentRealmType))
					WorldQuestGroupFinder.updateRealmTypeInComment(currentRealmType)
				end
			end
			-- Avoid raid mode
			recentlyInvitedPlayers = true
		end
	end
	-- GetPlayerMapPosition("party1")
end

for k, v in pairs(RegisteredEvents) do
	WorldQuestGroupFinderAddon:RegisterEvent(k)
end

function WorldQuestGroupFinder.GetQuestInfo (questID)
	local activityID, categoryID, filters, questName = LFGListUtil_GetQuestCategoryData(questID);
	if QuestUtils_IsQuestWorldQuest(questID) then
		local tagID, tagName, worldQuestType, rarity, elite, tradeskillLineIndex = GetQuestTagInfo (questID)
		if (not questName or questName == "") then
			questName, _ = C_TaskQuest.GetQuestInfoByQuestID (questID)
			if  (not questName or questName == "") then
				questName = select(4, GetTaskInfo(questID));
			end
		end
		
		return questName, tagID, tagName, worldQuestType, rarity, elite, tradeskillLineIndex, activityID, categoryID, filters
	else 
		if (not questName or questName == "") then
			questName, _ = C_TaskQuest.GetQuestInfoByQuestID (questID)
			if (not questName or questName == "") then
				questName = select(4, GetTaskInfo(questID));
			end
		end
		return questName, activityID, categoryID, filters
	end
end

function WorldQuestGroupFinder.resetTmpWQ ()
	tempWQ = nil
	WorldQuestGroupFinder.dprint("Resetting tempWQ")
end

function WorldQuestGroupFinder.SetHooks()	
	hooksecurefunc("BonusObjectiveTracker_OnBlockClick", function(self, button)
		if (button == "MiddleButton") then
			WorldQuestGroupFinder.HandleBlockClick(self.TrackedQuest.questID)
		end
	end)
	
	hooksecurefunc("QuestObjectiveSetupBlockButton_FindGroup", function(block, questID)
		if block.hasGroupFinderButton then
			local groupFinderButton = block.groupFinderButton;
			groupFinderButton:Hide()
		end
		local canFindGroup = false
		if QuestUtils_IsQuestWorldQuest(questID) then
			local _, _, _, worldQuestType, _, _, _, _, _, _ = WorldQuestGroupFinder.GetQuestInfo(questID)
			canFindGroup = true
			if (blacklistedQuests[questID] or worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE or worldQuestType == LE_QUEST_TAG_TYPE_DUNGEON or worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION) then
				canFindGroup = false
			end
		else 
			canFindGroup = (QuestUtils_CanUseAutoGroupFinder(questID, true) and WorldQuestGroupFinderConf.GetConfigValue("regularQuests")) or block.hasGroupFinderButton
		end
		if (canFindGroup and not block.WQGFButton) then
			block.WQGFButton = WorldQuestGroupFinder.CreateWQGFButton(block, questID, block.itemButton)
		end
		if (block.itemButton and block.WQGFButton) then
			block.WQGFButton:SetPoint("TOPRIGHT", block, 5, -26)
		end
	end)
	
	hooksecurefunc("TaskPOI_OnClick", function(self, button)
		if (self.worldQuest and (button == "MiddleButton"  or (button == "LeftButton" and IsControlKeyDown()))) then
			WorldQuestGroupFinder.HandleBlockClick(self.questID)
		end
	end)
	
	hooksecurefunc("WorldMap_GetOrCreateTaskPOI", function(index)
		-- Bind mouse button on POIs
		local existingButton = _G["WorldMapFrameTaskPOI"..index];
		existingButton:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp");
		WorldMap_ResetPOI(existingButton, true, false);
		return existingButton
	end)
	
	hooksecurefunc("ObjectiveTracker_Update", function(reason, questID)
		if (reason == OBJECTIVE_TRACKER_UPDATE_WORLD_QUEST_ADDED and WorldQuestGroupFinderConf.GetConfigValue("askZoning") and GetCurrentMapAreaID() ~= 978) then
			local title, tagID, tagName, worldQuestType, rarity, elite, tradeskillLineIndex, activityID, categoryID, filters = WorldQuestGroupFinder.GetQuestInfo(questID)
			popupWQ = questID
			-- If already queued for something or if the quest is in blacklist, do not prompt
			if (not WorldQuestGroupFinder.IsAlreadyQueued(false) and not blacklistedQuests[popupWQ] and not WorldBosses[popupWQ]) then
				-- Ignore pet battle and dungeon quests
				if (worldQuestType ~= LE_QUEST_TAG_TYPE_PET_BATTLE and worldQuestType ~= LE_QUEST_TAG_TYPE_DUNGEON and worldQuestType ~= LE_QUEST_TAG_TYPE_PROFESSION) then
					if (not IsInGroup() and WorldQuestGroupFinderConf.GetConfigValue("askZoningAuto")) then
						if not seenWorldQuests[questID] then
							WorldQuestGroupFinder.InitWQGroup(popupWQ)
							seenWorldQuests[questID] = true
						end
					else
						if not currentlyApplying then
							-- Check if the world quest zone has already been entered during this session
							if not seenWorldQuests[questID] then
								-- No current WQ. 
								if (currentWQ == nil) then
									seenWorldQuests[questID] = true
									WorldQuestGroupFinder.ShowDialog ("WORLD_QUEST_ENTERED_PROMPT", title)
								-- Already doing another WQ
								elseif (currentWQ ~= nil and popupWQ ~= currentWQ) then
									if not WorldQuestGroupFinderConf.GetConfigValue("askZoningBusy") then
										WorldQuestGroupFinder.FlagWQAsSeen(questID)
										WorldQuestGroupFinder.ShowDialog ("WORLD_QUEST_ENTERED_SWITCH_PROMPT", title)
									end
								end
							else 
								WorldQuestGroupFinder.dprint(string.format("World quest #%d zone has already been visited. Dialog will not be shown.", questID))
							end
						else
							WorldQuestGroupFinder.dprint(string.format("Already applying for WQ #%d. Not showing dialog", questID))
						end
					end
				else 
					WorldQuestGroupFinder.dprint(string.format("World quest #%d zone entered. WQ type is not supported. Dialog will not be shown.", questID))
				end
			else 
				WorldQuestGroupFinder.dprint(string.format("World quest #%d zone entered. WQ is blacklisted. Dialog will not be shown.", questID))
			end
		end
	end)
	
	hooksecurefunc("BonusObjectiveTracker_OnBlockAnimOutFinished", function(self) 
		WorldQuestGroupFinder.HideDialog ("WORLD_QUEST_ENTERED_PROMPT")
		WorldQuestGroupFinder.HideDialog ("WORLD_QUEST_ENTERED_SWITCH_PROMPT")
	end)
			
	hooksecurefunc("ObjectiveTracker_Update", function(reason, id)
		if (reason and reason == OBJECTIVE_TRACKER_UPDATE_QUEST and currentWQ) then
			WorldQuestGroupFinder.AttachBorderToWQ(currentWQ, true)
		end
	end)
	
	hooksecurefunc("LFGListUtil_SetAutoAccept", function(autoAccept)
		if (autoAccept and currentWQ) then
			LFGListUtil_SetAutoAccept(false)
			LFGListFrame.ApplicationViewer.AutoAcceptButton:SetChecked(false)
		end
	end)
			
	hooksecurefunc(C_LFGList, "RemoveListing", function(self)
		if (currentWQ ~= nil) then
			WorldQuestGroupFinder.HandleWorldQuestEnd(currentWQ, true)
		end
	end)
end

function WorldQuestGroupFinder.AddWorldQuestToTracker(questID)
	AddWorldQuestWatch(questID, true) 
end

function WorldQuestGroupFinder.IsAlreadyQueued(verbose)
	mode, subMode = GetLFGMode(LE_LFG_CATEGORY_LFD);
	if ( mode == "queued" or mode == "listed" or mode == "rolecheck" or mode == "proposal" or mode == "suspended" ) then
		if verbose then	WorldQuestGroupFinder.prefixedPrint(L["WQGF_ALREADY_QUEUED_DF"]) end
		return true
	end
	mode, subMode = GetLFGMode(LE_LFG_CATEGORY_LFR);
	if ( mode == "queued" or mode == "listed" or mode == "rolecheck" or mode == "proposal" or mode == "suspended" ) then
		if verbose then	WorldQuestGroupFinder.prefixedPrint(L["WQGF_ALREADY_QUEUED_RF"]) end
		return true
	end	
	mode, subMode = GetLFGMode(LE_LFG_CATEGORY_RF, RaidFinderQueueFrame.raid);
	if ( mode == "queued" or mode == "listed" or mode == "rolecheck" or mode == "proposal" or mode == "suspended" ) then
		if verbose then	WorldQuestGroupFinder.prefixedPrint(L["WQGF_ALREADY_QUEUED_RF"]) end
		return true
	end
	for i=1, GetMaxBattlefieldID() do
		local status, mapName, teamSize, registeredMatch, suspend = GetBattlefieldStatus(i);
		if ( status and status ~= "none" ) then
			if verbose then	WorldQuestGroupFinder.prefixedPrint(L["WQGF_ALREADY_QUEUED_BG"]) end
			return true
		end
	end
	return false
end

function WorldQuestGroupFinder.InitWQGroup(questID, retry, forceCreate) 
	WorldQuestGroupFinder.dprint(string.format("Looking for a group for a world quest. ID: %d", questID))
	local title, tagID, tagName, worldQuestType, rarity, elite, tradeskillLineIndex, activityID, categoryID, filters
	if (QuestUtils_IsQuestWorldQuest(questID)) then
		title, tagID, tagName, worldQuestType, rarity, elite, tradeskillLineIndex, activityID, categoryID, filters = WorldQuestGroupFinder.GetQuestInfo(questID)
		-- Ignore pet battle and dungeon quests
		if (worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE or worldQuestType == LE_QUEST_TAG_TYPE_DUNGEON or worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION) then
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_CANNOT_DO_WQ_TYPE_IN_GROUP"])
			return false
		end
	else 
		title, activityID, categoryID, filters = WorldQuestGroupFinder.GetQuestInfo(questID)
		--if not LFGListUtil_CanSearchForGroup(questID) then
		--	WorldQuestGroupFinder.prefixedPrint(L["WQGF_CANNOT_DO_WQ_IN_GROUP"])
		--	return false
		--end
	end
	local foundZone = false
	local foundGroup = false
	local retry = retry or false
	local forceCreate = forceCreate or false
	if (IsInGroup() and not UnitIsGroupLeader("player")) then
		WorldQuestGroupFinder.prefixedPrint(L["WQGF_PLAYER_IS_NOT_LEADER"])
		return false
	end
	-- Ignore blacklisted quests
	if (blacklistedQuests[questID]) then
		WorldQuestGroupFinder.prefixedPrint(L["WQGF_CANNOT_DO_WQ_IN_GROUP"])
		return false
	end
	-- Check if already queued
	if (WorldQuestGroupFinder.IsAlreadyQueued(true)) then
		return false
	end
	if not activityID then
		-- Get location ID
		local tmpCurrentMapID = GetCurrentMapAreaID()
		SetMapToCurrentZone()
		local mapAreaID = GetCurrentMapAreaID()
		SetMapByID(tmpCurrentMapID)
		foundZone = WorldQuestGroupFinder.IsWQInZone(questID, mapAreaID)
		if (foundZone) then
			activityID = activityIDs[mapAreaID]
		else
			-- Maybe the player is in a subzone
			SetMapToCurrentZone()
			ZoomOut()
			mapAreaID = GetCurrentMapAreaID()
			SetMapByID(tmpCurrentMapID)
			foundZone = WorldQuestGroupFinder.IsWQInZone(questID, mapAreaID)
			-- Temp fix for location not found, there will be a new way to deal with this in 7.1.5
			if (foundZone) then
				activityID = activityIDs[mapAreaID]
			else
				SetMapToCurrentZone()
				if (GetCurrentMapContinent() == 8) then
					foundZone = true
					mapAreaID = 1015
					activityID = activityIDs[mapAreaID]
				end
				SetMapByID(tmpCurrentMapID)
			end
		end
	end
	if (activityID) then
		tempWQ = questID
		C_LFGList.RemoveListing()
		-- Clear existing applications
		if (C_LFGList.GetNumApplications() > 0) then
			for k,v in pairs( C_LFGList.GetApplications() ) do
				-- If this is retry and some applications didnt get confirmed, put group in BL
				if (retry) then
					local _,_,_,_,_,_,_,_,_,_,_,_,groupAuthor,_ = C_LFGList.GetSearchResultInfo(v)
					pendingApplications = {}
					if (groupAuthor) then
						blacklistedLeaders[groupAuthor] = true
					end
				end
				C_LFGList.CancelApplication(v)
			end
		end
		if (raidQuests[questID]) then
			WorldQuestGroupFinder.dprint("This WQ can be completed in a raid")
		end
		if (not forceCreate) then
			if (worldQuestType) then
				WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_SEARCHING_FOR_GROUP"], title))
			else
				WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_SEARCHING_FOR_GROUP_QUEST"], title))
			end
		end
		-- Search for existing groups
		C_LFGList.ClearSearchResults()
		local selectedLanguages = {}
		if (WorldQuestGroupFinderConf.GetConfigValue("allLanguages")) then
			for k,v in pairs( C_LFGList.GetAvailableLanguageSearchFilter() ) do
				selectedLanguages[v] = true
			end
		else
			selectedLanguages = C_LFGList.GetLanguageSearchFilter()
		end		
		--C_LFGList.Search(1, "#WQ:"..questID.."#", 0, 4, selectedLanguages);
		C_LFGList.Search(1, title, 0, 4, selectedLanguages)
		-- Delay to let the search finish
		C_Timer.After(1.5, function()
			local applicationsCount = 0
			local blacklistedApplicationsCount = 0
			local searchCount, searchResults = C_LFGList.GetSearchResults()
			local currentPlayers = 1;
			if (IsInGroup()) then
				currentPlayers = GetNumGroupMembers()
			end
			if (not forceCreate) then
				for k, v in pairs( searchResults ) do
					local id,_,name,description,_,ilvl,_,_,_,_,_,_,author,members,autoinv = C_LFGList.GetSearchResultInfo(v)
					-- Check group is correct
					if (name == title and GetAverageItemLevel() > ilvl and (members + currentPlayers <= MAX_PARTY_MEMBERS+1 or raidQuests[questID]) and author ~= UnitName("player") and not autoinv) then
						if (blacklistedLeaders[author] == true or (retry and not author)) then
							if (author) then
								WorldQuestGroupFinder.dprint(string.format("Ignoring group because leader is blacklisted. ID: %d, Name: %s, Leader: %s", id, name, author))
							end
							blacklistedApplicationsCount = blacklistedApplicationsCount + 1
						else 
							local avoidPVPGroup = false
							if (playerRealmType == "PVE" and WorldQuestGroupFinderConf.GetConfigValue("avoidPVP") and worldQuestType ~= LE_QUEST_TAG_TYPE_PVP) then
								if (string.find(description, "#WQ:"..questID.."#PV")) then
									-- Created by WQGF 0.13+, server type in description
									if (string.find(description, "#WQ:"..questID.."#PVP#")) then
										avoidPVPGroup = true
									end
								else
									-- Created by an outdated version, lookup for leader's realm type 
									local authorRealmType = nil
									if (author) then
										local _, authorRealm = strsplit("-", author)
										_, _, _, authorRealmType = LibStub("LibRealmInfo"):GetRealmInfo(authorRealm)
										if (authorRealmType == "PVP" or authorRealmType == "RPPVP") then
											avoidPVPGroup = true
										end
										WorldQuestGroupFinder.dprint(string.format("Current leader's realm type: %s", authorRealmType))
									end
								end
							end
							if (avoidPVPGroup) then
								WorldQuestGroupFinder.dprint("Not applying to a PVP realm.")
							else 
								foundGroup = true
								currentlyApplying = true
								local canBeTank = LFDQueueFrameRoleButtonTank.checkButton:GetChecked()
								local canBeHealer = LFDQueueFrameRoleButtonHealer.checkButton:GetChecked()
								local canBeDamager = LFDQueueFrameRoleButtonDPS.checkButton:GetChecked()
								if ((canBeTank or canBeHealer or canBeDamager) == false) then
									canBeTank, canBeHealer, canBeDamager = UnitGetAvailableRoles("player")
								end
								if (applicationsCount < 5) then
									if (author) then
										WorldQuestGroupFinder.dprint(string.format("Applying to group. ID: %d, Name: %s, Leader: %s", id, name, author))
									else
										WorldQuestGroupFinder.dprint(string.format("Applying to group. ID: %d, Name: %s", id, name))
									end
									C_LFGList.ApplyToGroup(v, "WorldQuestGroupFinderUser-"..questID, canBeTank, canBeHealer, canBeDamager)
									applicationsCount = applicationsCount + 1
								else
									WorldQuestGroupFinder.dprint(string.format("Too many applications, ignoring. ID: %d, Name: %s", id, name))
								end
							end
						end
					end
				end
				C_LFGList.ClearSearchResults()
			end
			-- No group found, creating a new one
			if (foundGroup == false or forceCreate) then
				local currentRealmType = WorldQuestGroupFinder.getCurrentRealmType()
				local descriptionFormat = AUTO_GROUP_CREATION_NORMAL_QUEST;
				if QuestUtils_IsQuestWorldQuest(questID) then
					descriptionFormat = AUTO_GROUP_CREATION_WORLD_QUEST;
				end
				local completeDescription = string.format(descriptionFormat .. " " .. L["WQGF_WQ_GROUP_DESCRIPTION"], title, GetAddOnMetadata("WorldQuestGroupFinder", "Version")).." #WQ:"..questID.."#"..currentRealmType.."#"
				if (C_LFGList.CreateListing(activityID, "", 0, 0, "", completeDescription, false, false, questID)) then
					WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_NEW_ENTRY_CREATED"], title), true)
					WorldQuestGroupFinder.HandleWorldQuestStart(questID)
				else
					WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_GROUP_CREATION_ERROR"]))
					WorldQuestGroupFinder.dprint(string.format("Failed group data: activityID: %d", activityID))
				end
			else 
				if (worldQuestType) then
					WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_APPLIED_TO_GROUPS"], applicationsCount, title), true)
				else
					WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_APPLIED_TO_GROUPS_QUEST"], applicationsCount, title), true)
				end
				TIMEOUT_TIMER = C_Timer.NewTicker(INVITE_TIMEOUT_DELAY, function() 
					WorldQuestGroupFinder.HandleRequestTimeout(questID) 
					WorldQuestGroupFinder.dprint(string.format("The timeout timer has ended (%d seconds)", INVITE_TIMEOUT_DELAY))
				end, 1)
			end
			return true
		end)
	else
		WorldQuestGroupFinder.prefixedPrint(L["WQGF_WRONG_LOCATION_FOR_WQ"])
		return false
	end
end

function WorldQuestGroupFinder.HandleWorldQuestStart(questID)
	WorldQuestGroupFinder.dprint(string.format("World quest starting process. ID: %d", questID))
	currentlyApplying = false
	if (TIMEOUT_TIMER) then	WorldQuestGroupFinder.StopTimeoutTimer() end
	WorldQuestGroupFinder.AddWorldQuestToTracker(questID)	
	if (WorldQuestGroupFinder.AttachBorderToWQ(questID)) then
		currentWQFrame:Show()
		pendingApplications = {}
		currentWQ = questID
		WorldQuestGroupFinderConf.SetConfigValue("savedCurrentWQ", currentWQ, "CHAR")
		if (IsInGroup() and UnitIsGroupLeader("player")) then
			WorldQuestGroupFinder.BroadcastMessage("#WQS:"..questID.."#")
		end
		LFGListFrame.ApplicationViewer.AutoAcceptButton:Hide()
		WorldQuestGroupFinder.resetTmpWQ()
		return true
	else
		WorldQuestGroupFinder.dprint(string.format("World quest start process failed. ID: %d", questID))
		return false
	end
end
	
function WorldQuestGroupFinder.HandleWorldQuestEnd(wqID, broadcast)
	local broadcast = broadcast or false
	currentWQ = nil
	local targetBlock = WorldQuestGroupFinder.FindWQBlock(wqID)
	if (targetBlock) then
		targetBlock.WQGFButton:Show()
	end
	WorldQuestGroupFinder.resetTmpWQ()
	WorldQuestGroupFinder.dprint(string.format("World quest ending process. ID: %d", wqID))
	WorldQuestGroupFinderConf.SetConfigValue("savedCurrentWQ", nil, "CHAR")
	--BonusObjectiveTracker_UntrackWorldQuest(wqID)
	LFGListFrame.ApplicationViewer.AutoAcceptButton:Show()
	if (IsInGroup() and UnitIsGroupLeader("player") and broadcast) then
		WorldQuestGroupFinder.BroadcastMessage("#WQE:"..wqID.."#")
	end
	blacklistedLeaders = {}
	currentWQFrame:Hide()
end

function WorldQuestGroupFinder.FlagWQAsSeen(wqID)
	seenWorldQuests[wqID] = true
	WorldQuestGroupFinder.dprint(string.format("Setting quest #%d as visited", wqID))
end

function WorldQuestGroupFinder.BroadcastMessage(msg) 
	SendAddonMessage(BROADCAST_PREFIX, msg, "PARTY")
	WorldQuestGroupFinder.dprint(string.format("Sending broadcast. Message: %s", msg))
end

function WorldQuestGroupFinder.ShowDialog(...)
	local dialog = ...
	local dialogObject = StaticPopup_Show(...)
	if (dialogObject) then
		WorldQuestGroupFinder.dprint(string.format("Showing dialog %s", dialog))
		dialogObject.data = popupWQ
	else
		WorldQuestGroupFinder.dprint(string.format("Failed to show dialog %s", dialog))
	end
end

function WorldQuestGroupFinder.HideDialog(dialog) 
	if (StaticPopup_Visible(dialog)) then
		StaticPopup_Hide(dialog)
		WorldQuestGroupFinder.dprint(string.format("Hiding dialog %s", dialog))
	end
end

function WorldQuestGroupFinder.StopTimeoutTimer()
	TIMEOUT_TIMER:Cancel()
	WorldQuestGroupFinder.dprint("The timeout timer has been stopped.")
end	
	
function WorldQuestGroupFinder.HandleCustomAutoInvite()
	if (WorldQuestGroupFinderConf.GetConfigValue("autoinviteUsers")) then
		if (not autoInviteRunning) then
			autoInviteRunning = true
			WorldQuestGroupFinder.dprint('Called Auto-Invite')
			--local autoAccept = select(9, C_LFGList.GetActiveEntryInfo());
			if (UnitIsGroupLeader("player") and ((GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) + C_LFGList.GetNumInvitedApplicantMembers() < (MAX_PARTY_MEMBERS+1)) or raidQuests[currentWQ])) then 
				local invTimer = 0
				-- If another instance of the custom auto invite has been run recently we'll wait till the pending invites count gets refreshed
				if (recentlyInvitedPlayers) then
					invTimer = 1
				end
				C_Timer.After(invTimer, function()
					local applicants = C_LFGList.GetApplicants();
					local applicantsWQGF = {}
					local applicantsNonWQGF = {}
					if (applicants) then
						for i=1, #applicants do
							local id, status, pendingStatus, numMembers, isNew, comment = C_LFGList.GetApplicantInfo(applicants[i]);
							if (status == "applied") then
								local applicantName, _, _, applicantLevel, _, _, _, _, _ = C_LFGList.GetApplicantMemberInfo(applicants[i], numMembers)
								WorldQuestGroupFinder.dprint('[' .. id .. '] ' .. applicantName .. " (" .. applicantLevel ..")")
								if (currentWQ) then
									local questTag = GetQuestTagInfo(currentWQ)
									if (applicantName and (not QuestUtils_IsQuestWorldQuest(currentWQ) or (QuestUtils_IsQuestWorldQuest(currentWQ) and (applicantLevel >= 110 or ((questTag == 139 or questTag == 142) and applicantLevel >= 98))))) then
										if (blacklistedRealmHoppers[applicantName] == nil) then
											if (comment == "WorldQuestGroupFinderUser-"..currentWQ) then
												applicantsWQGF[id] = numMembers
											else
												applicantsNonWQGF[id] = numMembers
											end
										end
									end
								end
							end			
						end
						-- Get current group members count, including pending invites
						upToDateGroupMembersCount = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) + C_LFGList.GetNumInvitedApplicantMembers()
						-- If we're here then the addon is at least set to invite WQGF users
						for aid, numMembers in pairs(applicantsWQGF) do
							if ((upToDateGroupMembersCount + numMembers) <= 5 or raidQuests[currentWQ]) then
								C_LFGList.InviteApplicant(aid)
								recentlyInvitedPlayers = true
								upToDateGroupMembersCount = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) + C_LFGList.GetNumInvitedApplicantMembers()
								WorldQuestGroupFinder.dprint(string.format("Auto-inviting WQGF user(s). Group ID: %d. New member(s): %d. Current members count: %d. In Group: %d. Invited: %d.", aid, numMembers, upToDateGroupMembersCount, GetNumGroupMembers(LE_PARTY_CATEGORY_HOME), C_LFGList.GetNumInvitedApplicantMembers()))
							end
						end
						-- If set to invite everyone
						if (WorldQuestGroupFinderConf.GetConfigValue("autoinvite")) then
							for aid, numMembers in pairs(applicantsNonWQGF) do
								if ((upToDateGroupMembersCount + numMembers) <= 5 or raidQuests[currentWQ]) then
									C_LFGList.InviteApplicant(aid)
									recentlyInvitedPlayers = true
									upToDateGroupMembersCount = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) + C_LFGList.GetNumInvitedApplicantMembers()
									WorldQuestGroupFinder.dprint(string.format("Auto-inviting NON-WQGF user(s). Group ID: %d. New member(s): %d. Current members count: %d. In Group: %d. Invited: %d.", aid, numMembers, upToDateGroupMembersCount, GetNumGroupMembers(LE_PARTY_CATEGORY_HOME), C_LFGList.GetNumInvitedApplicantMembers()))
								end
							end
						end
					else
						WorldQuestGroupFinder.dprint("Tried to invite but there were no applicants")
					end
				end)
				-- Check for groups dropping error
				C_Timer.After(3, function()
					if (not C_LFGList.GetActiveEntryInfo()) then
						WorldQuestGroupFinder.dprint("Group finder entry has disappeared!")
						if (currentWQ) then
							WorldQuestGroupFinder.dprint("Creating queue again")
							local title, tagID, tagName, worldQuestType, rarity, elite, tradeskillLineIndex, activityID, categoryID, filters
							if (QuestUtils_IsQuestWorldQuest(currentWQ)) then
								title, tagID, tagName, worldQuestType, rarity, elite, tradeskillLineIndex, activityID, categoryID, filters = WorldQuestGroupFinder.GetQuestInfo(currentWQ)
							else 
								title, activityID, categoryID, filters = WorldQuestGroupFinder.GetQuestInfo(currentWQ)
							end
						
							local tmpCurrentMapID = GetCurrentMapAreaID()
							SetMapToCurrentZone()
							local mapAreaID = GetCurrentMapAreaID()
							local foundZone = false
							SetMapByID(tmpCurrentMapID)
							foundZone = WorldQuestGroupFinder.IsWQInZone(currentWQ, mapAreaID)
							if not activityID then
								-- Get location ID
								local tmpCurrentMapID = GetCurrentMapAreaID()
								SetMapToCurrentZone()
								local mapAreaID = GetCurrentMapAreaID()
								SetMapByID(tmpCurrentMapID)
								foundZone = WorldQuestGroupFinder.IsWQInZone(currentWQ, mapAreaID)
								if (foundZone) then
									activityID = activityIDs[mapAreaID]
								else
									-- Maybe the player is in a subzone
									SetMapToCurrentZone()
									ZoomOut()
									mapAreaID = GetCurrentMapAreaID()
									SetMapByID(tmpCurrentMapID)
									foundZone = WorldQuestGroupFinder.IsWQInZone(currentWQ, mapAreaID)
									-- Temp fix for location not found, there will be a new way to deal with this in 7.1.5
									if (foundZone) then
										activityID = activityIDs[mapAreaID]
									else
										SetMapToCurrentZone()
										if (GetCurrentMapContinent() == 8) then
											foundZone = true
											mapAreaID = 1015
											activityID = activityIDs[mapAreaID]
										end
										SetMapByID(tmpCurrentMapID)
									end
								end
							end
							if (activityID) then
								local currentRealmType = WorldQuestGroupFinder.getCurrentRealmType()
								local descriptionFormat = AUTO_GROUP_CREATION_NORMAL_QUEST;
								if QuestUtils_IsQuestWorldQuest(currentWQ) then
									descriptionFormat = AUTO_GROUP_CREATION_WORLD_QUEST;
								end
								local completeDescription = string.format(descriptionFormat .. " " .. L["WQGF_WQ_GROUP_DESCRIPTION"], title, GetAddOnMetadata("WorldQuestGroupFinder", "Version")).." #WQ:"..currentWQ.."#"..currentRealmType.."#"
								C_LFGList.CreateListing(activityID, "", 0, 0, "", completeDescription, false, false, currentWQ);
							end
						end
					end
					recentlyInvitedPlayers = false
				end)
			end
			C_Timer.After(2, function()
				autoInviteRunning = false
			end)
			-- Disable minimap button animation
			QueueStatusMinimapButton_SetGlowLock(QueueStatusMinimapButton, "lfglist-applicant", false)
		else
			if autoInviteQueued then
				WorldQuestGroupFinder.dprint("Throwing Auto-Invite")
			else
				WorldQuestGroupFinder.dprint("Queueing Auto-Invite")
				autoInviteQueued = true
				C_Timer.After(2, function()
					WorldQuestGroupFinder.dprint("Calling Auto-Invite (queued)")
					WorldQuestGroupFinder.HandleCustomAutoInvite()
				autoInviteQueued = false
				end)
			end
		end
	end
end	
	
function WorldQuestGroupFinder.HandleRequestTimeout(wqID)
	WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_NO_APPLICATIONS_ANSWERED"], WorldQuestGroupFinder.GetQuestInfo(wqID)), true)
	recentlyTimedOut = true
	WorldQuestGroupFinder.InitWQGroup(wqID, true)
end

function WorldQuestGroupFinder.HandleBlockClick(wqID, forceCreate)
	if (tempWQ ~= wqID or (C_LFGList.GetNumApplications() == 0 and not C_LFGList.GetActiveEntryInfo())) then
		if WorldBosses[wqID] then
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_DROPPED_WB_SUPPORT"])
		else
			WorldQuestGroupFinder.dprint(string.format("World quest has been clicked. ID: %d", wqID))
			if (IsInGroup() and not UnitIsGroupLeader("player")) then
				WorldQuestGroupFinder.prefixedPrint(L["WQGF_PLAYER_IS_NOT_LEADER"])
				return false
			end
			if (currentWQ ~= nil and wqID ~= currentWQ) then
				WorldQuestGroupFinder.dprint(string.format("Clicked world quest is not the same is current (%d). Showing NEW_WORLD_QUEST_PROMPT.", currentWQ))
				if QuestUtils_IsQuestWorldQuest(currentWQ) then
					WorldQuestGroupFinder.ShowDialog ("NEW_WORLD_QUEST_PROMPT")
				else
					WorldQuestGroupFinder.ShowDialog ("NEW_QUEST_PROMPT")
				end
			else 
				-- No current WQ. 
				if (currentWQ == nil or (C_LFGList.GetNumApplications() == 0 and not C_LFGList.GetActiveEntryInfo())) then
					-- Hide join WQ prompts
					WorldQuestGroupFinder.HideDialog ("WORLD_QUEST_ENTERED_PROMPT")
					WorldQuestGroupFinder.HideDialog ("WORLD_QUEST_ENTERED_SWITCH_PROMPT")
					WorldQuestGroupFinder.InitWQGroup(wqID, false, forceCreate)
				else
					WorldQuestGroupFinder.prefixedPrint(L["WQGF_ALREADY_IS_GROUP_FOR_WQ"])
				end
			end
		end
	else
		WorldQuestGroupFinder.dprint("Already applying for this WQ")
	end
end

function WorldQuestGroupFinder.AttachBorderToWQ(wqID, update)
	update = update or false
	local targetBlock = WorldQuestGroupFinder.FindWQBlock(wqID)
	if (targetBlock) then
		-- Move item button
		if (targetBlock.itemButton) then
			targetBlock.itemButton:SetPoint("TOPRIGHT", targetBlock, -2, -18)
		end
	
		local xOffset = -12
		local yOffset = 10
		
		local trackerWidth, trackerHeight = ObjectiveTrackerFrame:GetSize()
		local blockWidth, blockHeight = targetBlock:GetSize()
			
		currentWQFrame:SetClampedToScreen(true)
		currentWQFrame:SetFrameStrata("MEDIUM")
		currentWQFrame:SetToplevel(false) 
		
		currentWQFrame:SetSize(blockWidth+18,blockHeight+18)
		currentWQFrame:SetMovable(false)
		currentWQFrame:EnableMouse(false)
		
		currentWQFrame:SetPoint("TOPLEFT", targetBlock,"TOPLEFT", xOffset, yOffset)
		currentWQFrame:SetParent(targetBlock)
			
		currentWQFrame:SetFrameStrata("LOW")
		currentWQFrame:SetFrameLevel(0)

		currentWQFrame:SetBackdrop({
		  bgFile="Interface\\MINIMAP\\TooltipBackdrop-Background", 
		  edgeFile="Interface\\DialogFrame\\UI-DialogBox-Gold-Border", 
		  tile=false, edgeSize=16, --tileSize=16,
		  insets={left=5, right=5, top=5, bottom=5}
		})		
				
		if (not update) then
			currentWQFrame.KickButton:SetFlattensRenderLayers(true)
			currentWQFrame.KickButton:SetPoint("TOPRIGHT", -46, -6)
			currentWQFrame.KickButton:SetFrameLevel(10)
			currentWQFrame.KickButton:RegisterForClicks("LeftButtonUp")
			currentWQFrame.KickButton:SetScript("OnClick", WorldQuestGroupFinder.KickButton_OnClick)
			currentWQFrame.KickButton:SetScript("OnEnter", KickButton_OnEnter)
			currentWQFrame.KickButton:SetSize(20, 20);

			currentWQFrame.KickButton.Icon = currentWQFrame.KickButton:CreateTexture(currentWQFrame.KickButton:GetName().."Texture", "OVERLAY")
			currentWQFrame.KickButton.Icon:SetSize(12, 12)
			currentWQFrame.KickButton.Icon:SetPoint("CENTER", 0, 0)
			currentWQFrame.KickButton.Icon:SetTexture([[Interface\AddOns\WorldQuestGroupFinder\img\autokick.blp]])
			
			currentWQFrame.KickButton:Hide()

			currentWQFrame.RefreshButton:SetFlattensRenderLayers(true)
			currentWQFrame.RefreshButton:SetPoint("TOPRIGHT", -26, -6)
			currentWQFrame.RefreshButton:SetFrameLevel(10)
			currentWQFrame.RefreshButton:RegisterForClicks("LeftButtonUp")
			currentWQFrame.RefreshButton:SetScript("OnClick", WorldQuestGroupFinder.RefreshButton_OnClick)
			currentWQFrame.RefreshButton:SetScript("OnEnter", RefreshButton_OnEnter)
			currentWQFrame.RefreshButton:SetSize(20, 20);

			currentWQFrame.RefreshButton.Icon = currentWQFrame.RefreshButton:CreateTexture(currentWQFrame.RefreshButton:GetName().."Texture", "OVERLAY")
			currentWQFrame.RefreshButton.Icon:SetSize(12, 12)
			currentWQFrame.RefreshButton.Icon:SetPoint("CENTER", 0, 0)
			currentWQFrame.RefreshButton.Icon:SetTexture([[Interface\AddOns\WorldQuestGroupFinder\img\refresh.blp]])

			currentWQFrame.StopButton:SetFlattensRenderLayers(true)
			currentWQFrame.StopButton:SetPoint("TOPRIGHT", -6, -6)
			currentWQFrame.StopButton:SetFrameLevel(10)
			currentWQFrame.StopButton:RegisterForClicks("LeftButtonUp")
			currentWQFrame.StopButton:SetScript("OnClick", WorldQuestGroupFinder.StopButton_OnClick)
			currentWQFrame.StopButton:SetScript("OnEnter", StopButton_OnEnter)
			currentWQFrame.StopButton:SetSize(20, 20);

			currentWQFrame.StopButton.Icon = currentWQFrame.StopButton:CreateTexture(currentWQFrame.StopButton:GetName().."Texture", "OVERLAY")
			currentWQFrame.StopButton.Icon:SetSize(12, 12)
			currentWQFrame.StopButton.Icon:SetPoint("CENTER", 0, 0)
			currentWQFrame.StopButton.Icon:SetTexture([[Interface\AddOns\WorldQuestGroupFinder\img\stop.blp]])

			WorldQuestGroupFinder.AssignButtonTextures(currentWQFrame.KickButton)
			WorldQuestGroupFinder.AssignButtonTextures(currentWQFrame.RefreshButton)
			WorldQuestGroupFinder.AssignButtonTextures(currentWQFrame.StopButton)
		end
		
		if (targetBlock.WQGFButton) then
			targetBlock.WQGFButton:Hide()
		end
		
		return currentWQFrame
	else 
		return false
	end
end

function WorldQuestGroupFinder.CreateWQGFButton(block, questID) 
	local groupFinderButton = CreateFrame("button", questID.."GroupFinderButton", block)
	groupFinderButton:SetFlattensRenderLayers(true)
	groupFinderButton:SetPoint("TOPRIGHT", 5, 0)
	groupFinderButton:SetFrameLevel(10)
	groupFinderButton:RegisterForClicks("LeftButtonUp", "MiddleButtonUp", "RightButtonUp")
	groupFinderButton:SetScript("OnClick", function(self, button, down)
		if (button == "RightButton" or WorldBosses[questID]) then
			LFGListUtil_FindQuestGroup(self:GetParent().id)
		elseif (button == "MiddleButton") then
			WorldQuestGroupFinder.HandleBlockClick(self:GetParent().id, true)
		else
			WorldQuestGroupFinder.HandleBlockClick(self:GetParent().id)
		end
	end)
	groupFinderButton:SetScript("OnEnter", WQGFButton_OnEnter)
	groupFinderButton:SetSize(20, 20)
	groupFinderButton:SetFrameLevel(500)
	
	groupFinderButton.Icon = groupFinderButton:CreateTexture(groupFinderButton:GetName().."Texture", "OVERLAY")
	groupFinderButton.Icon:SetSize(12, 12)
	groupFinderButton.Icon:SetPoint("CENTER", 0, 0)
	groupFinderButton.Icon:SetAtlas("socialqueuing-icon-eye")
	WorldQuestGroupFinder.AssignButtonTextures(groupFinderButton)
	return groupFinderButton
end

function WorldQuestGroupFinder.SendWQCompletionPartyNotification (wqID)
	if QuestUtils_IsQuestWorldQuest(wqID) then
		SendChatMessage(string.format("[WQGF] %s: %s :)", WorldQuestGroupFinder.GetQuestInfo(wqID), WORLD_QUEST_COMPLETE), "PARTY", "", "");
	else
		SendChatMessage(string.format("[WQGF] %s: %s :)", WorldQuestGroupFinder.GetQuestInfo(wqID), QUEST_COMPLETE), "PARTY", "", "");
	end
end

function WorldQuestGroupFinder.AssignButtonTextures(button)
	button:SetNormalTexture("Interface/WorldMap/UI-QuestPoi-NumberIcons")
	button:GetNormalTexture():ClearAllPoints()
	button:GetNormalTexture():SetPoint("CENTER", button:GetNormalTexture():GetParent())
	button:GetNormalTexture():SetSize(32, 32)
	button:GetNormalTexture():SetTexCoord(0.500, 0.625, 0.375, 0.5)
	button:SetHighlightTexture("Interface/WorldMap/UI-QuestPoi-NumberIcons")
	button:GetHighlightTexture():ClearAllPoints()
	button:GetHighlightTexture():SetPoint("CENTER", button:GetHighlightTexture():GetParent())
	button:GetHighlightTexture():SetSize(32, 32)
	button:GetHighlightTexture():SetTexCoord(0.625, 0.750, 0.875, 1)
	button:SetPushedTexture("Interface/WorldMap/UI-QuestPoi-NumberIcons")
	button:GetPushedTexture():ClearAllPoints()
	button:GetPushedTexture():SetPoint("CENTER", button:GetPushedTexture():GetParent())
	button:GetPushedTexture():SetSize(32, 32)
	button:GetPushedTexture():SetTexCoord(0.375, 0.500, 0.375, 0.5)
end
	
function KickButton_OnEnter(self)
	GameTooltip:SetOwner(self);
	GameTooltip:AddLine(L["WQGF_KICK_TOOLTIP"], HIGHLIGHT_FONT_COLOR:GetRGB());
	if not self:IsEnabled() and C_LFGList.GetActiveEntryInfo() then
		local r, g, b = RED_FONT_COLOR:GetRGB();
		GameTooltip:AddLine(CANNOT_DO_THIS_WHILE_LFGLIST_LISTED, r, g, b, true);
	end
	GameTooltip:Show();
end

function RefreshButton_OnEnter(self)
	GameTooltip:SetOwner(self);
	GameTooltip:AddLine(L["WQGF_REFRESH_TOOLTIP"], HIGHLIGHT_FONT_COLOR:GetRGB());
	if not self:IsEnabled() and C_LFGList.GetActiveEntryInfo() then
		local r, g, b = RED_FONT_COLOR:GetRGB();
		GameTooltip:AddLine(CANNOT_DO_THIS_WHILE_LFGLIST_LISTED, r, g, b, true);
	end
	GameTooltip:Show();
end

function StopButton_OnEnter(self)
	GameTooltip:SetOwner(self);
	GameTooltip:AddLine(L["WQGF_STOP_TOOLTIP"], HIGHLIGHT_FONT_COLOR:GetRGB());
	if not self:IsEnabled() and C_LFGList.GetActiveEntryInfo() then
		local r, g, b = RED_FONT_COLOR:GetRGB();
		GameTooltip:AddLine(CANNOT_DO_THIS_WHILE_LFGLIST_LISTED, r, g, b, true);
	end
	GameTooltip:Show();
end

function WQGFButton_OnEnter(self)
	GameTooltip:SetOwner(self);
	GameTooltip:AddLine(L["WQGF_FIND_GROUP_TOOLTIP"], YELLOW_FONT_COLOR:GetRGB());
	GameTooltip:AddLine(L["WQGF_FIND_GROUP_TOOLTIP_2"], HIGHLIGHT_FONT_COLOR:GetRGB());
	if not self:IsEnabled() and C_LFGList.GetActiveEntryInfo() then
		local r, g, b = RED_FONT_COLOR:GetRGB();
		GameTooltip:AddLine(CANNOT_DO_THIS_WHILE_LFGLIST_LISTED, r, g, b, true);
	end
	GameTooltip:Show();
end

function WorldQuestGroupFinder.KickButton_OnClick()
	CheckDistances()
	KickHoppers()
end

function WorldQuestGroupFinder.RefreshButton_OnClick()
	if (IsInGroup() and not UnitIsGroupLeader("player")) then
		for i=1, GetNumGroupMembers() do 
			if (UnitIsGroupLeader(IsInRaid() and ("raid"..i) or ("party"..i))) then
				local leaderName = GetRaidRosterInfo(i)
				WorldQuestGroupFinder.dprint(string.format("Adding %s to blacklisted leaders...", leaderName))
				blacklistedLeaders[leaderName] = true
			end						
		end
	end
	local currentWQtmp = currentWQ
	LeaveParty()
	C_Timer.After(2, function()
		tempWQ = currentWQ
		WorldQuestGroupFinder.InitWQGroup(currentWQtmp)
	end)
end

function WorldQuestGroupFinder.StopButton_OnClick()
	if (IsInGroup() and not UnitIsGroupLeader("player")) then
		WorldQuestGroupFinder.prefixedPrint(L["WQGF_PLAYER_IS_NOT_LEADER"])
	else
		C_LFGList.RemoveListing()
	end
end

function WorldQuestGroupFinder.ShowLeavePrompt(isWQ)
	if (UnitIsGroupLeader("player")) then
		if isWQ then
			WorldQuestGroupFinder.ShowDialog ("WORLD_QUEST_FINISHED_LEADER_PROMPT")
		else
			WorldQuestGroupFinder.ShowDialog ("QUEST_FINISHED_LEADER_PROMPT")
		end
	else 
		if isWQ then
			WorldQuestGroupFinder.ShowDialog ("WORLD_QUEST_FINISHED_PROMPT")
		else
			WorldQuestGroupFinder.ShowDialog ("QUEST_FINISHED_PROMPT")
		end
	end
end

function WorldQuestGroupFinder.handleCMD(msg, editbox)
	if (string.lower(msg) == "config") then
		InterfaceOptionsFrame_OpenToCategory("WorldQuestGroupFinder")
	elseif (string.lower(msg) == "data") then
		if (currentWQ ~= nil) then
			WorldQuestGroupFinder.prefixedPrint(string.format(L["WQGF_DEBUG_CURRENT_WQ_ID"], currentWQ))
		else 
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_DEBUG_NO_CURRENT_WQ_ID"])
		end
		print(L["WQGF_DEBUG_WQ_ZONES_ENTERED"])
		WorldQuestGroupFinder.dumpTable(seenWorldQuests)
	elseif (string.lower(msg) == "debug") then
		if (WorldQuestGroupFinderConf.GetConfigValue("printDebug")) then
			WorldQuestGroupFinderConf.SetConfigValue("printDebug", false)
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_DEBUG_MODE_DISABLED"])
		else
			WorldQuestGroupFinderConf.SetConfigValue("printDebug", true)
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_DEBUG_MODE_ENABLED"])
		end
	elseif (string.lower(msg) == "showconfig") then
		print(L["WQGF_GLOBAL_CONFIGURATION"])
		WorldQuestGroupFinder.dumpTable(WorldQuestGroupFinderConfig)
		print(L["WQGF_DEBUG_CONFIGURATION_DUMP"])
		WorldQuestGroupFinder.dumpTable(WorldQuestGroupFinderCharacterConfig)
	elseif (string.lower(msg) == "unbl") then
		blacklistedLeaders = {}
		blacklistedRealmHoppers = {}
		WorldQuestGroupFinder.prefixedPrint(L["WQGF_LEADERS_BL_CLEARED"])
	elseif (string.lower(msg) == "toggle") then
		local currentValue = WorldQuestGroupFinderConf.GetConfigValue("askZoning")
		if (currentValue) then
			WorldQuestGroupFinderConf.SetConfigValue("askZoning", false)
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_ZONE_DETECTION_DISABLED"])
		else
			WorldQuestGroupFinderConf.SetConfigValue("askZoning", true)
			WorldQuestGroupFinder.prefixedPrint(L["WQGF_ZONE_DETECTION_ENABLED"])
		end
	elseif (string.lower(msg) == "autokick") then
		CheckDistances()
		KickHoppers()
	else
		WorldQuestGroupFinder.help()
	end
end

function WorldQuestGroupFinder.help()
	print(L["WQGF_SLASH_COMMANDS_1"])
	print(L["WQGF_SLASH_COMMANDS_2"])
	print(L["WQGF_SLASH_COMMANDS_3"])
	print(L["WQGF_SLASH_COMMANDS_4"])
end

function WorldQuestGroupFinder.prefixedPrint(text, verbose)
	if (not (verbose and WorldQuestGroupFinderConf.GetConfigValue("silent"))) then	
		print("|c00bfffff[WQGF]|c00ffffff "..text)
	end
end 

function WorldQuestGroupFinder.dprint(text)
	if (WorldQuestGroupFinderConf.GetConfigValue("printDebug")) then
		print("|c00ffbfff[DEBUG]|c00ffffff "..text)
	end
end 

function WorldQuestGroupFinder.dumpTable(t)
	if type(t) == "table" then
		for k, v in pairs( t ) do
			print(k, v)
		end
	else 
		print(t)
	end
end

function WorldQuestGroupFinder.IsWQInZone(wqID, mapAreaID)
	local correctZone = false
	local taskInfo = C_TaskQuest.GetQuestsForPlayerByMapID(mapAreaID);
	local numTaskPOIs = 0;
	if(taskInfo ~= nil) then
		numTaskPOIs = #taskInfo;
	end
	if ( numTaskPOIs > 0 ) then
		for i, info  in ipairs(taskInfo) do
			if (info.questId == wqID) then
				correctZone = true
			end
		end
	end
	return correctZone
end

function WorldQuestGroupFinder.FindWQBlock(wqID)
	local tracker = ObjectiveTrackerFrame
	wqID = tonumber(wqID)
	
	if (not tracker.initialized) then
		return
	end
	for i = 1, #tracker.MODULES do
		local module = tracker.MODULES [i]
		for blockName, usedBlock in pairs (module.usedBlocks) do
			if (usedBlock.id) then
				if (wqID == usedBlock.id) then
					return usedBlock
				end
			end
		end
	end
	return false
end

function WorldQuestGroupFinder.getCurrentRealmType()
	local realmType = ""
	if (UnitIsPVP("player")) then
		if (GetPVPTimer() == 301000) then
			realmType = "PVP"
		else 
			realmType = "PVE"
		end
	else
		realmType = "PVE"
	end
	return realmType
end

function WorldQuestGroupFinder.getRealmTypeFromDescription()
	local description = select(6, C_LFGList.GetActiveEntryInfo())
	if (description) then
		return string.match(description, "#WQ:[%d]+#([%w]+)#")
	else
		return nil
	end
end

function WorldQuestGroupFinder.updateRealmTypeInComment(newType)
	local active, activityID, iLevel, honorLevel, name, comment, voiceChat, expiration, oldAutoAccept = C_LFGList.GetActiveEntryInfo();
	if ( not active ) then
		--If we're not listed, we can't change the value.
		return;
	end
	comment = string.gsub(comment, "#([%w]+)#", "#"..newType.."#")
	C_LFGList.UpdateListing(activityID, "", iLevel, honorLevel, voiceChat, comment, autoAccept, false, currentWQ);
end