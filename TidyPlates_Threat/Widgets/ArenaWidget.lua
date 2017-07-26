--------------------------------------------------------------------------------------------------------
--                                            Arena Widget                                            --
--------------------------------------------------------------------------------------------------------
local _, ns = ...
local t = ns.TidyPlates_Threat

local path = "Interface\\AddOns\\TidyPlates_Threat\\Widgets\\ArenaWidget\\"
local ArenaID = {}
local DB

--------------------------------------------------------------------------------------------------------
--                                         General functions                                          --
--------------------------------------------------------------------------------------------------------

-- ArenaId[unit name] = ArenaID #
local function BuildTable()
	for i = 1, GetNumArenaOpponents() do
		local name = UnitGUID("arena"..i)
		local petname = UnitGUID("arenapet"..i)
		if name and not ArenaID[name] then
			ArenaID[name] = i
		end
		if petname and not ArenaID[petname] then
			ArenaID[petname] = i
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Events watcher                                           --
--------------------------------------------------------------------------------------------------------
local WatcherFrame = CreateFrame("frame")
local isEnabled = false

local function EnableWatcherFrame()
	if not isEnabled then
		isEnabled = true
		WatcherFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	end
end

local function DisableWatcherFrame()
	if isEnabled then
		isEnabled = false
		WatcherFrame:UnregisterAllEvents()
		wipe(ArenaID)
	end
end

WatcherFrame:SetScript("OnEvent", function(this, event, ...)
	if IsActiveBattlefieldArena() and GetNumArenaOpponents() > 0 then
		-- we are in arena
		BuildTable()
	else
		wipe(ArenaID)
	end
	t.Update()
end)

local function enabled()
	DB = TidyPlatesThreat.db.profile.arenaWidget
	if DB.ON then
		EnableWatcherFrame()
	else
		DisableWatcherFrame()
	end
	return DB.ON
end

local function UpdateSettings(frame)
	frame:SetSize(DB.scale, DB.scale)
	frame.Overlay:SetSize(DB.scale, DB.scale)
	frame:SetPoint("CENTER", frame:GetParent(), DB.anchor, DB.x, DB.y)
end

--------------------------------------------------------------------------------------------------------
--                                          Widget functions                                          --
--------------------------------------------------------------------------------------------------------
local UpdateArenaWidget = function(frame, unit)
	if enabled() then
		BuildTable()
		UpdateSettings(frame)
		if unit.guid and ArenaID[unit.guid] then
			local c = DB.colors[ArenaID[unit.guid]]
			local c2 = DB.numColors[ArenaID[unit.guid]]
			frame:SetFrameLevel(frame:GetParent():GetFrameLevel() + 2)
			frame.Icon:SetTexture(path.."BG")
			frame.Icon:SetVertexColor(c.r, c.g, c.b, c.a)
			frame.Overlay.Num:SetTexture(path..ArenaID[unit.guid])
			frame.Overlay.Num:SetVertexColor(c2.r, c2.g, c2.b, c2.a)
			frame:Show()
		else
			frame.Icon:SetTexture(nil)
			frame.Overlay.Num:SetTexture(nil)
			frame:Hide()
		end
	else
		frame:Hide()
	end
end

local function CreateArenaWidget(parent)
	local frame = CreateFrame("frame", nil, parent)
	frame:SetSize(32, 32)
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetAllPoints(frame)

	frame.Overlay = CreateFrame("frame", nil, frame)
	frame.Overlay:SetAllPoints(frame)
	frame.Overlay.Num = frame.Overlay:CreateTexture(nil, "OVERLAY")
	frame.Overlay.Num:SetAllPoints(frame.Overlay)

	frame:Hide()
	frame.Update = UpdateArenaWidget

	return frame
end

ThreatPlatesWidgets.RegisterWidget("ArenaWidget", CreateArenaWidget, false, enabled)
