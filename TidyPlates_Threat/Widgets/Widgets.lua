local _, ns = ...
local t = ns.TidyPlates_Threat

--------------------------------------------------------------------------------------------------------
--                                       Healer Tracking Widget                                       --
--------------------------------------------------------------------------------------------------------
local healerTrackerEnabled
local function HealerTrackerEnable()
	local DB = TidyPlatesThreat.db.profile.healerTracker
	if DB.ON then
		if not healerTrackerEnabled then
			TidyPlatesUtility.EnableHealerTrack()
		end
	else
		if healerTrackerEnabled then
			TidyPlatesUtility.DisableHealerTrack()
		end
	end
	return DB.ON
end

local function CustomHealerTrackerUpdate(frame, unit)
	local DB = TidyPlatesThreat.db.profile.healerTracker
	frame.OldUpdate(frame, unit)
	frame:SetScale(DB.scale)
	frame:SetPoint(DB.anchor, frame:GetParent(), DB.x, DB.y)
	frame:Show()
end

local function CreateHealerTrackerWidget(plate)
	local frame
	frame = TidyPlatesWidgets.CreateHealerWidget(plate)
	frame.OldUpdate = frame.Update
	frame.Update = CustomHealerTrackerUpdate
	frame.Filter = AuraFilter
	return frame
end

ThreatPlatesWidgets.RegisterWidget("HealerTracker", CreateHealerTrackerWidget, true, HealerTrackerEnable)

--------------------------------------------------------------------------------------------------------
--                                             Poll Until                                             --
--------------------------------------------------------------------------------------------------------
do
	local updateInterval = .5
	local Framelist = {}
	local Watcherframe = CreateFrame("frame")
	local WatcherframeActive = false
	local timeToUpdate = 0

	local function CheckFramelist(self)
		local curTime = GetTime()
		if curTime < timeToUpdate then
			return
		end
		local framecount = 0
		timeToUpdate = curTime + updateInterval

		-- Cycle through the watchlist
		for frame, expiration in pairs(Framelist) do
			if expiration < curTime then
				if frame.Expire then
					frame:Expire()
				end
				Framelist[frame] = nil
			else
				if frame.Poll then
					frame:Poll(expiration)
				end
				framecount = framecount + 1
			end
		end

		-- If no more frames to watch, unregister the OnUpdate script
		if framecount == 0 then
			Watcherframe:SetScript("OnUpdate", nil)
			WatcherframeActive = false
		end
	end

	function PollUntil(frame, expiration)
		if expiration == 0 then
			Framelist[frame] = nil
		else
			Framelist[frame] = expiration
			if not WatcherframeActive then
				Watcherframe:SetScript("OnUpdate", CheckFramelist)
				WatcherframeActive = true
			end
		end
	end

	t.PollUntil = PollUntil
end
