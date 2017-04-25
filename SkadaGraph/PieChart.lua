--[[

A pie chart display.

--]]

local Skada = Skada
if Skada == nil then
	return
end
local L = LibStub("AceLocale-3.0"):GetLocale("Skada", false)

local mod = Skada:NewModule("PieDisplay")
local libwindow = LibStub("LibWindow-1.1")
local graph = LibStub("LibGraph-2.0")
local media = LibStub("LibSharedMedia-3.0")

-- Add to Skada's enormous list of display providers.
mod.name = "Pie display"
Skada.displays["pie"] = mod

-- Useful var to generate pretty colors
local saturation = 0.3
local value = 0.95
local goldenRatio  = 0.618033988749895
local hue

function mod:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("SkadaGraphsDB")
end

function mod:HandlePieSelection(win, num)
	if num then
		--Skada:Print(win.db.name.." click on "..num)
	end
end

-- Called when a Skada window starts using this display provider.
function mod:Create(window)
	-- Skada "windows" are only logical windows. We need to create a frame.
	if not window.frame then
		-- init colors
		hue = math.random() -- math.random() to add some more ...randomness
		if self.db.global.piesaturation then
			saturation = self.db.global.piesaturation
		end
		window.colorcache = {} -- Persistent color cache
		window.frame = CreateFrame("Frame", window.db.name.."PieChartFrame", UIParent)
		window.frame.win = window -- Whee
		window.frame:SetMovable(true)
		window.frame:SetClampedToScreen(true)
		window.frame:SetWidth(window.db.width or 300)
		window.frame:SetHeight(window.db.height or 180)
		window.frame:SetBackdrop( {bgFile = media:Fetch("background", "Solid"), tile = false, edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0} } )
		-- window.frame:SetBackdropColor(0, 0, 1, 0.2)
		-- Background color
		if self.db.global.piebgcolor then 
			window.frame:SetBackdropColor(self.db.global.piebgcolor.r or 0, self.db.global.piebgcolor.g or 0, self.db.global.piebgcolor.b or 0, self.db.global.piebgcolor.a or 0.83)
		else
			self.db.global.piebgcolor = {r,g,b,a}
			window.frame:SetBackdropColor(0, 0, 0, 0.83)
		end
		window.frame:SetBackdropColor(0, 0, 0, 0.83)
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
		window.frame.OnResizingInProgress = function(self) window.chart:SetWidth(min(window.frame:GetWidth()-140, window.frame:GetHeight())); window.chart:SetHeight(min(window.frame:GetWidth()-140,window.frame:GetHeight())); window:UpdateDisplay(); window.frame.legendframe:AdjustLegends() end
		window.frame.OnResizingDone = function(self) window.db.width = window.frame:GetWidth(); window.db.height = window.frame:GetHeight() end
		window.frame:MakeResizable()
		window.frame:SetMinResize(140,40)
		
		-- Add a header.
		window.header = CreateFrame("Button", nil, window.frame)
		window.header:SetHeight(20)
		window.header:SetPoint("BOTTOMLEFT", window.frame, "TOPLEFT", 0, 0)
		window.header:SetPoint("BOTTOMRIGHT", window.frame, "TOPRIGHT", 0, 0)
		window.header:SetScript("OnMouseDown", function() window.frame:StartMoving() end)
		window.header:SetScript("OnMouseUp", function() window.frame:StopMovingOrSizing(); libwindow.SavePosition(window.frame) end)
		window.header:SetBackdrop( {bgFile = media:Fetch("statusbar", "Aluminium"), tile = false, edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0} } )	
		if self.db.global.pieheaderbg then 
			window.header:SetBackdropColor(self.db.global.pieheaderbg.r or 0.1, self.db.global.pieheaderbg.g or 0.1, self.db.global.pieheaderbg.b or 0.3, self.db.global.pieheaderbg.a or 0.8)
		else
			self.db.global.pieheaderbg = {r,g,b,a}
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
		window.header:AddButton(L["Reset"], "Interface\\Buttons\\UI-StopButton", "Interface\\Buttons\\UI-StopButton", function() StaticPopup_Show("ResetSkadaDialog") end)
		window.header:AddButton(L["Segment"], "Interface\\Buttons\\UI-GuildButton-PublicNote-Up", "Interface\\Buttons\\UI-GuildButton-PublicNote-Up", function() Skada:SegmentMenu(window) end)
		window.header:AddButton(L["Mode"], "Interface\\Buttons\\UI-GuildButton-PublicNote-Up", "Interface\\Buttons\\UI-GuildButton-PublicNote-Up", function() Skada:ModeMenu(window) end)
		window.header:AddButton(L["Report"], "Interface\\Buttons\\UI-GuildButton-MOTD-Up", "Interface\\Buttons\\UI-GuildButton-MOTD-Up", function() Skada:OpenReportWindow(window) end)
		if not(self.db.global.pieenableheader) then self.db.global.pieenableheader = true end --set default to True if not set
		
		-- Add the actual graph. The pie chart does not function correctly unless width=height.
		local size = min(window.frame:GetWidth()-140, window.frame:GetHeight())
		local g=graph:CreateGraphPieChart("TestLineGraph",window.frame,"TOPLEFT","TOPLEFT",0,0,size,size)
		g:SetSelectionFunc(function(f, n) self:HandlePieSelection(window, n) end)
		window.chart = g
		
		--DEFAULT_CHAT_FRAME:AddMessage("Testing Line Graph")
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
end

-- Called by Skada windows when title of window should change.
function mod:SetTitle(win, title)
	-- Set title.
	win.header:SetText(title)
end

local function round(num)
  local mult = 10^(0)
  return math.floor(num * mult + 0.5) / mult
end

-- Called by Skada windows when the display should be updated to match the dataset.
function mod:Update(win)
	-- Some modes may alter title continously.
	win.header:SetText(win.metadata.title)

	-- Find total value.
	local total = 0
	for i, data in ipairs(win.dataset) do
		if data.id and not data.ignore then	-- Ignore Total data.
			if data.value > 0 then
				total = total + data.value
			end
		end
	end
	
	win.chart:ResetPie()
	for i, data in ipairs(win.dataset) do
		if data.id and not data.ignore then	-- Total bar makes no sense for this display.
			local color
			if win.colorcache[data.id] then
				color = win.colorcache[data.id]
			else
				hue = hue + goldenRatio
				hue = hue - (math.floor(hue)); -- modulo 1
				color = Skada.GenerateColor(hue,saturation,value)
				win.colorcache[data.id] = color
			end
			if data.value > 0 then
				-- Skada:Print("adding "..data.label.." with "..((data.value / total) * 100))
				win.chart:AddPie(round((data.value / math.max(0.000001, total)) * 100),{color[1], color[2], color[3]})
			end
			
			win.frame.legendframe:AddLegend(data.id, data.label, color)
		end
	end
	win.frame.legendframe:AdjustLegends()
	win.chart:CompletePie({0.2,0.2,0.4})
end

-- Called by Skada windows when the window is to be completely cleared and prepared for new data.
function mod:Wipe(win)
	win.chart:ResetPie()
	win.frame.legendframe:ClearLegends()
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
	if win.db.barslocked then
		win.header:EnableMouse(false)
		win.frame.resizebutton:Hide()
	else
		win.header:EnableMouse(true)
		win.frame.resizebutton:Show()
	end
	if self.db.global.pieenableheader then
		win.header:Show()
	else
		win.header:Hide()
	end
	if self.db.global.piebgcolor then
		if not self.db.global.piebgcolor.r then
			self.db.global.piebgcolor.r =0
		end
		if not self.db.global.piebgcolor.g then
			self.db.global.piebgcolor.g =0
		end
		if not self.db.global.piebgcolor.b then
			self.db.global.piebgcolor.b =0
		end
		if not self.db.global.piebgcolor.a then
			self.db.global.piebgcolor.a =0.83
		end
		win.frame:SetBackdropColor(self.db.global.piebgcolor.r or 0, self.db.global.piebgcolor.g or 0, self.db.global.piebgcolor.b or 0, self.db.global.piebgcolor.a or 0.83)
	end
	if self.db.global.pieheaderbg then
		if not self.db.global.pieheaderbg.r then
			self.db.global.pieheaderbg.r =0.1
		end
		if not self.db.global.pieheaderbg.g then
			self.db.global.pieheaderbg.g =0.1
		end
		if not self.db.global.pieheaderbg.b then
			self.db.global.pieheaderbg.b =0.3
		end
		if not self.db.global.pieheaderbg.a then
			self.db.global.pieheaderbg.a =0.8
		end
		win.header:SetBackdropColor(self.db.global.pieheaderbg.r or 0.1, self.db.global.pieheaderbg.g or 0.1, self.db.global.pieheaderbg.b or 0.3, self.db.global.pieheaderbg.a or 0.8)
	end	
	local fo_h = CreateFont("MyTitleFont")	-- header font
	if not self.db.global.pieheaderfont then
		self.db.global.pieheaderfont = "Accidental Presidency"
	end
	if not self.db.global.pieheaderfontsize then
		self.db.global.pieheaderfontsize = 12
	end
	if not self.db.global.pieheaderfontflags then
		self.db.global.pieheaderfontflags = ""
	end
	fo_h:SetFont(media:Fetch('font', self.db.global.pieheaderfont), self.db.global.pieheaderfontsize, self.db.global.pieheaderfontflags)
	win.header:SetNormalFontObject(fo_h)
	if self.db.global.piesaturation then
		saturation = self.db.global.piesaturation
		wipe(win.colorcache)
	end
	
end

function mod:AddDisplayOptions(win, options)
-- local db = win.db
local db = self.db

	options.pieoptions = {
		type = "group",
		name = "Pie",
		order=1,
		args = {
			pieenableheader = {
				type="toggle",
				name="Enable header",
				desc="Enables / disables the header bar.",
				get=function() return db.global.pieenableheader end,
				set=function(win, showtotal)
							db.global.pieenableheader = not db.global.pieenableheader
		         			Skada:ApplySettings()
						end,
				order=1,
			},
			piebg = {
				type="color",
				name="Pie background color",
				desc="Choose the background color for the pie chart.",
				hasAlpha=true,
				get=function(i) return db.global.piebgcolor.r, db.global.piebgcolor.g, db.global.piebgcolor.b, db.global.piebgcolor.a end,
				set=function(i, r,g,b,a) db.global.piebgcolor = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}; Skada:ApplySettings() end,
				order=2,
			},
			headerbg = {
				type="color",
				name="Header background color",
				desc="Choose the background color for the header.",
				hasAlpha=true,
				get=function(i) return db.global.pieheaderbg.r, db.global.pieheaderbg.g, db.global.pieheaderbg.b, db.global.pieheaderbg.a end,
				set=function(i, r,g,b,a) db.global.pieheaderbg = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}; Skada:ApplySettings() end,
				order=3,
			},
			pieheaderfont = {
		         type = 'select',
		         dialogControl = 'LSM30_Font',
		         name = "Header font",
		         desc = "The font used by header.",
		         values = AceGUIWidgetLSMlists.font,
		         get = function() return db.global.pieheaderfont or 12 end,
		         set = function(win,key)
		         			db.global.pieheaderfont = key
		         			Skada:ApplySettings()
						end,
				order=4,
		    },
			pieheaderfontsize = {
				type="range",
				name="Header font size",
				desc="The font size of header.",
				min=7,
				max=40,
				step=1,
				get=function() return db.global.pieheaderfontsize end,
				set=function(win, size)
							db.global.pieheaderfontsize = size
		         			Skada:ApplySettings()
						end,
				order=5,
			},
		    pieheaderfontflags = {
		         type = 'select',
		         name = "Header font flags",
		         desc = "Sets the font flags for the header.",
		         values = {[""] = L["None"], ["OUTLINE"] = L["Outline"], ["THICKOUTLINE"] = L["Thick outline"], ["MONOCHROME"] = L["Monochrome"], ["OUTLINEMONOCHROME"] = L["Outlined monochrome"]},
		         get = function() return db.global.pieheaderfontflags end,
		         set = function(win,key)
		         			db.global.pieheaderfontflags = key
		         			Skada:ApplySettings()
						end,
				order=6,
		    },
			piebg = {
				type="range",
				name="Pie color saturation",
				desc="Choose the color saturation value used by the pie chart.",
				min=0,
				max=1,
				step=0.05,
				get=function() return db.global.piesaturation end,
				set=function(win, saturation)
							db.global.piesaturation = saturation
		         			Skada:ApplySettings()
						end,
				order=7,
			},
		}
	}
end

