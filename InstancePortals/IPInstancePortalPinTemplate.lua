IPInstancePortalMapDataProviderMixin = CreateFromMixins(MapCanvasDataProviderMixin);

function IPInstancePortalMapDataProviderMixin:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate("IPInstancePortalPinTemplate");
end

function IPInstancePortalMapDataProviderMixin:OnLoad()
	BaseMapPoiPinMixin.OnLoad(self);

	self:SetNudgeSourceRadius(1);
	self:SetNudgeSourceMagnitude(2, 2);
end

function IPInstancePortalMapDataProviderMixin:OnShow()
	CVarMapCanvasDataProviderMixin.OnShow(self);
	self:RegisterEvent("CVAR_UPDATE");
end

function IPInstancePortalMapDataProviderMixin:OnHide()
	CVarMapCanvasDataProviderMixin.OnHide(self);
	self:UnregisterEvent("CVAR_UPDATE");
end

function IPInstancePortalMapDataProviderMixin:OnEvent(event, ...)
	if event == "CVAR_UPDATE" then
		local eventName, value = ...;
		if eventName == "INSTANCE_PORTAL_REFRESH" then
			self:RefreshAllData();
		end
	end
end

function IPInstancePortalMapDataProviderMixin:RefreshAllData(fromOnShow)
	self:RemoveAllData();
	IPUIPrintDebug("IPInstancePortalMapDataProviderMixin:RefreshAllData")

	local trackOnZones = IPUITrackInstancePortals
	local trackOnContinents = IPUITrackInstancePortalsOnContinents

	local mapID = self:GetMap():GetMapID();
	IPUIPrintDebug("Map ID = "..mapID)

	local dungeonEntrances = C_EncounterJournal.GetDungeonEntrancesForMap(mapID)

	for i, dungeonEntranceInfo in ipairs(dungeonEntrances) do
		IPUIPrintDebug("Atlas = ("..dungeonEntranceInfo["position"]["x"]..","..dungeonEntranceInfo["position"]["y"]..")")
	end

	if IPUIPinDB[mapID] then
		local count = #IPUIPinDB[mapID]
		local isContinent = false;
		for i = 1, #IPUIContinentMapDB do
			if IPUIContinentMapDB[i] == mapID then
				isContinent = true;
			end
		end
  
        if not (isContinent) then
            return
        end
		
		IPUIPrintDebug("Map is continent = "..(isContinent and 'true' or 'false'))
		local playerFaction = UnitFactionGroup("player")

		for i = 1, count do
			local entranceInfo = IPUIGetEntranceInfoForMapID(mapID, i);
			
			if entranceInfo then
				local factionWhitelist = entranceInfo["factionWhitelist"];
				
				local isWhitelisted = true;
				
				if factionWhitelist and not (factionWhitelist == playerFaction) then
					isWhitelisted = false
				end

				if (isContinent and trackOnContinents) or (not isContinent and trackOnZones) then
					if (isWhitelisted) then
						self:GetMap():AcquirePin("IPInstancePortalPinTemplate", entranceInfo);
					end
				end
			end
		end
	end

end

--[[ Pin ]]--
IPInstancePortalProviderPinMixin = BaseMapPoiPinMixin:CreateSubPin("PIN_FRAME_LEVEL_DUNGEON_ENTRANCE");

function IPInstancePortalProviderPinMixin:OnAcquired(dungeonEntranceInfo) -- override
	BaseMapPoiPinMixin.OnAcquired(self, dungeonEntranceInfo);

	self.hub = dungeonEntranceInfo.hub
	self.tier = dungeonEntranceInfo.tier;
	self.journalInstanceID = dungeonEntranceInfo.journalInstanceID;
end

function IPInstancePortalProviderPinMixin:OnMouseClickAction(button)
	IPUIPrintDebug(button)

	if button == "LeftButton" then
		
		--local mapPoiVector = CreateVector2D(0,0)
		--local mapPoiMap = 0
		--if C_Map.CanSetUserWaypointOnMap() then
		--	local pt = UiMapPoint.CreateFromVector2D(mapPoiMap, mapPoiVector)
		--	C_Map.SetUserWaypoint(pt)
		--end
	else
		if self.hub == 0 then
			EncounterJournal_LoadUI();
			EncounterJournal_OpenJournal(nil, self.journalInstanceID)
		end
	end
end

function IPInstancePortalProviderPinMixin:ShouldMouseButtonBePassthrough(button)
	return false
end

function IPInstancePortalProviderPinMixin:UseTooltip()
	return true
end

function IPInstancePortalProviderPinMixin:GetTooltipInstructions()
	if self.hub == 1 then
		return ""
	else
		return "<Right click to open Adventure Guide>"
	end
end

