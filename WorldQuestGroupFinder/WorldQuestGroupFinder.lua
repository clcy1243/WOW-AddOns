local WorldQuestGroupFinderAddon = CreateFrame("Frame", "WorldQuestGroupFinderAddon", UIParent)

local L = LibStub ("AceLocale-3.0"):GetLocale ("WorldQuestGroupFinder", true)

WorldQuestGroupFinder = {}

local RegisteredEvents = {}
WorldQuestGroupFinderAddon:SetScript("OnEvent", function (self, event, ...) if (RegisteredEvents[event]) then return RegisteredEvents[event](self, event, ...) end end)

function RegisteredEvents:PLAYER_LOGIN(event)
	WorldQuestGroupFinder.SetHooks()	
	print("|c00bfffffWorld Quest Group Finder v"..GetAddOnMetadata("WorldQuestGroupFinder", "Version").." BETA. "..L["WQGF_INIT_MSG"])
 	WorldQuestGroupFinder.prefixedPrint("As of April 28th, Blizzard has blocked several Group Finder functions from addons. This unfortunately means that WQGF is now permanently broken. You can still use the in-game group finding tool to search for groups, by right-clicking on a World Quest in the objective tracker. Thanks you all for your support. It was fun. Robou (EU-Hyjal)")
end

for k, v in pairs(RegisteredEvents) do
	WorldQuestGroupFinderAddon:RegisterEvent(k)
end

function WorldQuestGroupFinder.SetHooks()	
	hooksecurefunc("BonusObjectiveTracker_OnBlockClick", function(self, button)
		if (button == "MiddleButton") then
			WorldQuestGroupFinder.HandleBlockClick(self.TrackedQuest.questID)
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
	
end

function WorldQuestGroupFinder.HandleBlockClick(questID, forceCreate)
 	WorldQuestGroupFinder.prefixedPrint("As of April 28th, Blizzard has restricted several Group Finder functions from being called by addons. This unfortunately means that WQGF is now permanently broken. You can still use the in-game group finding tool to search for groups, by right-clicking on a World Quest in the objective tracker. Thanks you all for your support. It was fun. Robou (EU-Hyjal)")
end

function WorldQuestGroupFinder.prefixedPrint(text, verbose)
	if (not (verbose and WorldQuestGroupFinderConf.GetConfigValue("silent"))) then	
		print("|c00bfffff[WQGF]|c00ffffff "..text)
	end
end 
