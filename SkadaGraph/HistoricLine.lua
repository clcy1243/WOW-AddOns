--[[

A line graph display showing historic data. It is only meant as an example of a very
different display system, and it is highly inefficient.

Does not add anything to Skada's memory usage permanently; only keeps a local cache
of the last 30 entries (of whatever is being shown) for each player.

TODO : Using per windows/per char config and not global

--]]

local Skada = Skada
if Skada == nil then
	return
end
local L = LibStub("AceLocale-3.0"):GetLocale("Skada", false)

local mod = Skada:NewModule("HistoricLineDisplay")
local libwindow = LibStub("LibWindow-1.1")
local graph = LibStub:GetLibrary("LibGraph-2.0")
local media = LibStub("LibSharedMedia-3.0")

-- Add to Skada's enormous list of display providers.
mod.name = "Historic line display"
Skada.displays["line"] = mod

-- Useful var to generate pretty colors
local hue 
local saturation = 0.5
local value = 0.95
local goldenRatio  = 0.618033988749895

function mod:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("SkadaGraphsDB")
end

-- Called when a Skada window starts using this display provider.
function mod:Create(window)
	-- Skada "windows" are only logical windows. We need to create a frame.
	if not window.frame then
		hue = math.random() -- math.random() to add some more ...randomness
		-- Our local cache of historic data.
		window.historycache = {}

		-- Our cache of colors, which persists on mode changes etc.
		window.colorcache = {}

		-- X value for next entry in history.
		window.num = 0
		
		window.frame = CreateFrame("Frame", window.db.name.."LineChartFrame", UIParent)
		window.frame.win = window
		window.frame:SetMovable(true)
		window.frame:SetClampedToScreen(true)
		window.frame:SetWidth(window.db.barwidth or 300)
		window.frame:SetHeight(window.db.height or 180)
		window.frame:SetBackdrop( {bgFile = media:Fetch("background", "Solid"), tile = false, edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0} } )
		-- Background color
		if self.db.global.graphbgcolor then 
			window.frame:SetBackdropColor(self.db.global.graphbgcolor.r or 0, self.db.global.graphbgcolor.g or 0, self.db.global.graphbgcolor.b or 0, self.db.global.graphbgcolor.a or 0.83)
		else
			self.db.global.graphbgcolor = {r,g,b,a}
			window.frame:SetBackdropColor(0, 0, 0, 0.83)
		end
		window.frame:SetPoint("TOPLEFT", UIParent, "CENTER", 0, 0)
		window.frame:EnableMouse()
		window.frame:SetScript("OnMousedown", function(f, button) if button == "RightButton" then window:RightClick() end end)

		window.frame.legendframe = CreateFrame("Frame", nil, window.frame)
		window.frame.legendframe:SetWidth(140)
		window.frame.legendframe:SetPoint("TOPRIGHT", window.frame, "TOPRIGHT", 0, 0)
		window.frame.legendframe:SetPoint("BOTTOMRIGHT", window.frame, "BOTTOMRIGHT", 0, 0)
		window.frame.legendframe.AddLegend = Skada.AddLegend
		window.frame.legendframe.ClearLegends = Skada.ClearLegends
		window.frame.legendframe.ClickLegend = function(id, label, button) Skada.ClickRow(window.frame, window, id, label, button) end
		window.frame.legendframe.EnterLegend = function(id, label) Skada.EnterRow(window.frame, window, id, label) end
		window.frame.legendframe.LeaveLegend = function(id, label) Skada.LeaveRow(window.frame, window, id, label) end
		window.frame.legendframe.AdjustLegends = Skada.AdjustLegends
		Skada.SetupLegendScrolling(window.frame.legendframe)

		window.frame.MakeResizable = Skada.MakeResizable
		window.frame.OnResizingInProgress = function(self) 
												window.chart:SetWidth(window.frame:GetWidth()-145); 
												window.chart:SetHeight(window.frame:GetHeight()-2); 
												window:UpdateDisplay(); 
												window.frame.legendframe:AdjustLegends()			
												-- save size.
												window.db.height = window.frame:GetHeight()
												window.db.barwidth = window.frame:GetWidth()
											end
		window.frame:MakeResizable()
		window.frame:SetMinResize(140,40)

		-- Add a header and some snazzy buttons.
		window.header = CreateFrame("Button", nil, window.frame)
		window.header:SetHeight(20)
		window.header:SetPoint("BOTTOMLEFT", window.frame, "TOPLEFT", 0, 0)
		window.header:SetPoint("BOTTOMRIGHT", window.frame, "TOPRIGHT", 0, 0)
		window.header:SetScript("OnMouseDown", function() window.frame:StartMoving() end)
		window.header:SetScript("OnMouseUp", function() window.frame:StopMovingOrSizing(); libwindow.SavePosition(window.frame) end)
		window.header:SetBackdrop( {bgFile = media:Fetch("statusbar", "Aluminium"), tile = false, edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0} } )
		if self.db.global.graphheaderbg then 
			window.header:SetBackdropColor(self.db.global.graphheaderbg.r or 0.1, self.db.global.graphheaderbg.g or 0.1, self.db.global.graphheaderbg.b or 0.3, self.db.global.graphheaderbg.a or 0.8)
		else
			self.db.global.graphheaderbg = {r,g,b,a}
			window.header:SetBackdropColor(0.1, 0.1, 0.3, 0.8)	
		end
		window.header:SetText(window.db.name)
		window.header:GetFontString():SetPoint("LEFT", window.header, "LEFT", 5, 1)
		window.header:GetFontString():SetJustifyH("LEFT")
		local myfont = CreateFont("MyTitleFont")
		myfont:SetFont(media:Fetch('font', "Accidental Presidency"), 12)
		window.header:SetNormalFontObject(myfont)

		window.header.AddButton = Skada.AddButton
		window.header.AdjustButtons = Skada.AdjustButtons

		-- Add window buttons.
		window.header:AddButton(L["Configure"], "Interface\\Buttons\\UI-OptionsButton", "Interface\\Buttons\\UI-OptionsButton", function() Skada:OpenMenu(window) end)
		window.header:AddButton(L["Reset"], "Interface\\Buttons\\UI-StopButton", "Interface\\Buttons\\UI-StopButton", function() Skada:ShowPopup() end)
		-- window.header:AddButton(L["Segment"], "Interface\\Buttons\\UI-GuildButton-PublicNote-Up", "Interface\\Buttons\\UI-GuildButton-PublicNote-Up", function() Skada:SegmentMenu(window) end)
		window.header:AddButton(L["Mode"], "Interface\\Buttons\\UI-GuildButton-PublicNote-Up", "Interface\\Buttons\\UI-GuildButton-PublicNote-Up", function() Skada:ModeMenu(window) end)
		-- window.header:AddButton(L["Report"], "Interface\\Buttons\\UI-GuildButton-MOTD-Up", "Interface\\Buttons\\UI-GuildButton-MOTD-Up", function() Skada:OpenReportWindow(window) end)
		if not(self.db.global.enableheader) then self.db.global.enableheader = true end --set default to True if not set
		
		-- Add the actual graph.
		local g=graph:CreateGraphLine("TestLineGraph",window.frame,"TOPLEFT","TOPLEFT",2,0,window.frame:GetWidth()-145,window.frame:GetHeight()-2)
		g:SetGridColor({0,0,0,0.0})
		g:SetAxisDrawing(true,true)
		g:SetAxisColor({1.0,1.0,1.0,1.0})
		g:SetYLabels(true, false)
		g:SetAutoScale(false)
		window.chart = g

		-- DEFAULT_CHAT_FRAME:AddMessage("Testing Line Graph")
	end
	window.frame:Show()

	-- Register with LibWindow-1.0.
	libwindow.RegisterConfig(window.frame, window.db)

	-- Restore window position.
	libwindow.RestorePosition(window.frame)

end

-- Called by Skada windows when the window is to be destroyed/cleared.
function mod:Destroy(win)
	wipe(win.colorcache)
	win.colorcache = nil
	win.frame.legendframe:ClearLegends()
	hue = math.random()
	win.frame:Hide()
	win.frame = nil
	win.chart = nil
	win.header = nil
	win.historycache = nil
	win.num = nil
end

-- Called by Skada windows when the window is to be completely cleared and prepared for new data.
function mod:Wipe(win)
	-- print('wipe')
	win.chart:ResetData()
	wipe(win.historycache)
	win.num = 0
	win.frame.legendframe:ClearLegends()
	-- hue = math.random()
end

-- Called by Skada windows when title of window should change.
function mod:SetTitle(win, title)
	-- Set title.
	win.header:SetText(title)
end

-- Called by Skada windows when the display should be updated to match the dataset.
-- We keep a table of historic entries and redraw the entire frame every update. Sayonara fps, hello fpm!
-- Funny, it seems a frame hovering on another skada windows is doing funny things with the data input
-- I can't figure out why for now :(
function mod:Update(win)
	if not InCombatLockdown() then -- force a GC if not in combat 
		collectgarbage("collect")
		-- print('GC')
	end
	-- Some modes may alter title continously.
	win.header:SetText(win.metadata.title)
	--Data type check
	if not(self.db.global.graphRealTimeValues) then self.db.global.graphRealTimeValues = "RealTime" end
	-- Number of points showing in the graph. Everything above it should be discarded
	local maxPoints = 30
	if self.db.global.graphmaxpoints and self.db.global.graphmaxpoints >= 10 then -- Keeping less than 10 points doesn't make any sense
		maxPoints = self.db.global.graphmaxpoints
	else 
		self.db.global.graphmaxpoints = maxPoints
	end
	for i, data in ipairs(win.dataset) do
		if data.id then
			if(self.db.global.graphshowtotal or (not self.db.global.graphshowtotal and data.label  ~= "Total")) then --Discard "Total" data if needed
				-- Add this row to our history.
				if win.historycache[data.id] then
					tinsert(win.historycache[data.id].values, {x = win.num, y = data.value})
					-- Trim history
					if #win.historycache[data.id].values > maxPoints then
						table.remove(win.historycache[data.id].values, 1)
					end
				else
					local color
					if win.colorcache[data.id] then
						color = win.colorcache[data.id]
					else
						hue = hue + goldenRatio
						hue = hue - (math.floor(hue)); -- modulo 1
						color = Skada.GenerateColor(hue,saturation,value)
						win.colorcache[data.id] = color
					end

					win.historycache[data.id] = {num = win.num, values = {x = win.num, y = data.value}, color = color}

					-- Legend
					win.frame.legendframe:AddLegend(data.id, data.label, color)
				end
			end
		end
	end
	win.frame.legendframe:AdjustLegends()

	win.chart:ResetData()
	local min_x, max_x = 0, maxPoints
	local min_y, max_y = 0, 0
	local count1 = 0
	local count2 = 0
	local cache = {}
	for id, data in pairs(win.historycache) do
		count1 = count1 + 1
		if count1 > 5 then
			break
		end
		local points = {}
		local y_points_tmpTable = {}
		local calculatedValueY
		for i, value in ipairs(data.values) do
			if (self.db.global.graphRealTimeValues == "RealTime") then
				-- We do a diff between each point in the history to guess realtime values.
				calculatedValueY = data.values[i].y - data.values[max(1,i - 1)].y
			else 
				-- Total values.
				calculatedValueY = value.y
			end
			if calculatedValueY >=0 then --We're not supposed to have negative values
				tinsert(points, {maxPoints, calculatedValueY}) -- x,y coord
			end
			-- We decrement the x coord, to be sure the graph moves to the left as the data arrives
			for idx, valuePoint in ipairs(points) do
				points[idx][1] = points[idx][1] -1
			end
			-- Delete old points, so we don't keep too much data
			if #points > maxPoints then
				table.remove(points, 1)
			end
		end
		
		-- Update min/max coords. We can't have <0 values and min_x/max_x are already set. So we really only need to update max_y	
		count2 = count2 + 1
		for k, val in ipairs(points) do
			tinsert(y_points_tmpTable, points[k][2]) -- We do a copy of Y coords data in a new table to avoid tempering with points table. Bad workaround is bad.
		end
		table.sort(y_points_tmpTable)
		if y_points_tmpTable[#y_points_tmpTable] and y_points_tmpTable[#y_points_tmpTable] > 0 then
			if max_y > y_points_tmpTable[#y_points_tmpTable] then
				if count2 > maxPoints then -- We don't let max_y shrink if old max_y 's corresponding data is still in the graph display.
					max_y = y_points_tmpTable[#y_points_tmpTable]
				end
			else 
				max_y = y_points_tmpTable[#y_points_tmpTable] -- max_y is always allowed to grow
			end
		end
		y_points_tmpTable = nil -- Deleting the tmp table right afterwards. We don't want to keep that thing in memory.

		
		tinsert(cache, {p = points, c = data.color})
	end
	win.chart.NeedsUpdate = true
	win.chart:SetXAxis(max(0, min_x), max(1, max_x))
	win.chart:SetYAxis(max(0, min_y), max(1, max_y))
	win.chart:SetGridSpacing(max(1,math.floor(max_x / 4)), max(1,math.floor(max_y / 4)))
	for i, stuff in ipairs(cache) do
		win.chart:AddDataSeries(stuff.p, stuff.c)
	end
	win.chart:OnUpdate()

	win.num = win.num + 1
end

function mod:Show(win)
	win.frame:Show()
end

function mod:Hide(win)
	win.frame:Hide()
end

function mod:IsShown(win)
	return win.frame:IsShown()
end

-- Called by Skada windows when window settings have changed.
function mod:ApplySettings(win)
	if win.db.barslocked then -- this comes from SkadaDB
		win.header:EnableMouse(false)
		win.frame.resizebutton:Hide()
	else
		win.header:EnableMouse(true)
		win.frame.resizebutton:Show()
	end
	if self.db.global.enableheader then
		win.header:Show()
	else
		win.header:Hide()
	end
	if self.db.global.graphbgcolor then
		if not self.db.global.graphbgcolor.r then
			self.db.global.graphbgcolor.r =0
		end
		if not self.db.global.graphbgcolor.g then
			self.db.global.graphbgcolor.g =0
		end
		if not self.db.global.graphbgcolor.b then
			self.db.global.graphbgcolor.b =0
		end
		if not self.db.global.graphbgcolor.a then
			self.db.global.graphbgcolor.a =0.83
		end
		win.frame:SetBackdropColor(self.db.global.graphbgcolor.r or 0, self.db.global.graphbgcolor.g or 0, self.db.global.graphbgcolor.b or 0, self.db.global.graphbgcolor.a or 0.83)
	end
	if self.db.global.graphheaderbg then
		if not self.db.global.graphheaderbg.r then
			self.db.global.graphheaderbg.r =0.1
		end
		if not self.db.global.graphheaderbg.g then
			self.db.global.graphheaderbg.g =0.1
		end
		if not self.db.global.graphheaderbg.b then
			self.db.global.graphheaderbg.b =0.3
		end
		if not self.db.global.graphheaderbg.a then
			self.db.global.graphheaderbg.a =0.8
		end
		win.header:SetBackdropColor(self.db.global.graphheaderbg.r or 0.1, self.db.global.graphheaderbg.g or 0.1, self.db.global.graphheaderbg.b or 0.3, self.db.global.graphheaderbg.a or 0.8)
	end
	if self.db.global.graphmaxpoints and self.db.global.graphmaxpoints >= 10 then
		maxPoints = self.db.global.graphmaxpoints
	else self.db.global.graphmaxpoints = maxPoints
	end
	
	local fo_h = CreateFont("MyTitleFont")	-- header font
	if not self.db.global.graphheaderfont then
		self.db.global.graphheaderfont = "Accidental Presidency"
	end
	if not self.db.global.graphheaderfontsize then
		self.db.global.graphheaderfontsize = 12
	end
	if not self.db.global.graphheaderfontflags then
		self.db.global.graphheaderfontflags = ""
	end
	fo_h:SetFont(media:Fetch('font', self.db.global.graphheaderfont), self.db.global.graphheaderfontsize, self.db.global.graphheaderfontflags)
	win.header:SetNormalFontObject(fo_h)
end

function mod:AddDisplayOptions(win, options)
-- local db = win.db
local db = self.db

	options.graphoptions = {
		type = "group",
		name = "Graph",
		order=1,
		args = {		
			enableheader = {
				type="toggle",
				name="Enable header",
				desc="Enables / disables the header bar.",
				get=function() return db.global.enableheader end,
				set=function(win, showtotal)
							db.global.enableheader = not db.global.enableheader
		         			Skada:ApplySettings()
						end,
				order=1,
			},
			headerbg = {
				type="color",
				name="Header background color",
				desc="Choose the background color for the header.",
				hasAlpha=true,
				get=function(i) return db.global.graphheaderbg.r, db.global.graphheaderbg.g, db.global.graphheaderbg.b, db.global.graphheaderbg.a end,
				set=function(i, r,g,b,a) db.global.graphheaderbg = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}; Skada:ApplySettings() end,
				order=2,
			},
			graphbg = {
				type="color",
				name="Graph background color",
				desc="Choose the background color for the graph.",
				hasAlpha=true,
				get=function(i) return db.global.graphbgcolor.r, db.global.graphbgcolor.g, db.global.graphbgcolor.b, db.global.graphbgcolor.a end,
				set=function(i, r,g,b,a) db.global.graphbgcolor = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}; Skada:ApplySettings() end,
				order=3,
			},
			graphmaxpoints = {
				type="range",
				name="Graph max points",
				desc="Select a number of points for the graph.",
				min=10,
				max=120, -- limiting to 120 to avoid too much impact on perf. Have to improve memory management before augmenting it.
				step=1,
				get=function() return db.global.graphmaxpoints end,
				set=function(win, maxpoints)
							db.global.graphmaxpoints = maxpoints
		         			Skada:ApplySettings()
						end,
				order=4,
			},
			graphheaderfont = {
		         type = 'select',
		         dialogControl = 'LSM30_Font',
		         name = "Header font",
		         desc = "The font used by header.",
		         values = AceGUIWidgetLSMlists.font,
		         get = function() return db.global.graphheaderfont or 12 end,
		         set = function(win,key)
		         			db.global.graphheaderfont = key
		         			Skada:ApplySettings()
						end,
				order=5,
		    },
			graphheaderfontsize = {
				type="range",
				name="Header font size",
				desc="The font size of header.",
				min=7,
				max=40,
				step=1,
				get=function() return db.global.graphheaderfontsize end,
				set=function(win, size)
							db.global.graphheaderfontsize = size
		         			Skada:ApplySettings()
						end,
				order=6,
			},
		    graphheaderfontflags = {
		         type = 'select',
		         name = "Header font flags",
		         desc = "Sets the font flags for the header.",
		         values = {[""] = L["None"], ["OUTLINE"] = L["Outline"], ["THICKOUTLINE"] = L["Thick outline"], ["MONOCHROME"] = L["Monochrome"], ["OUTLINEMONOCHROME"] = L["Outlined monochrome"]},
		         get = function() return db.global.graphheaderfontflags end,
		         set = function(win,key)
		         			db.global.graphheaderfontflags = key
		         			Skada:ApplySettings()
						end,
				order=7,
		    },
			graphRealTimeValues = {
				type='select',
				name="Select data type",
				desc="Select the type of data to record.",
				values = {["RealTime"] = "RealTime", ["Total"] = "Total"},
				get=function() return db.global.graphRealTimeValues end,
				set=function(win, key)
							db.global.graphRealTimeValues = key
		         			Skada:ApplySettings()
						end,
				order=8,
			},
			graphshowtotal = {
				type="toggle",
				name="Show total",
				desc="Show total data when applicable.",
				get=function() return db.global.graphshowtotal end,
				set=function(win, showtotal)
							db.global.graphshowtotal = not db.global.graphshowtotal
		         			Skada:ApplySettings()
						end,
				order=9,
			},			
		}
	}
end

