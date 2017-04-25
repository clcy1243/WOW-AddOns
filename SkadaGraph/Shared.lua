--[[

Useful routines for the graph displays. Most of it is just copied straight from Skada and generalized.

AdjustButtons	Adjust button anchoring according to their visibility.
AddButton		Adds a button to a frame.
AddLegend		Adds a legend to a frame.
ClearLegends	Clears all legends for a frame.
AdjustLegends	Adjust a frame's legends (anchoring and visibility) according to frame size.
EnterRow		
LeaveRow		
ClickRow		
MakeResizable	Adds resizing routine to a frame. Has several callbacks.

--]]
local s = Skada
if s == nil then
	return
end
local L = LibStub("AceLocale-3.0"):GetLocale("Skada", false)


-- This function generate colors in HSV space. The point is to use a fixed saturation value to ensure colors are easily readable.
-- Shall limit the re-use of colors. Plus, it's pretty !
-- Inspired by http://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/
local function GenerateColor(hue, saturation, value)
	local hue_int    = math.floor(hue * 6)
	local f    = hue * 6 - hue_int
	local p    = value * (1 - saturation)
	local q    = value * (1 - f * saturation)
	local t    = value * (1 - (1 - f) * saturation)
	local r,g,b    = 255, 255, 255
	if hue_int and hue_int==0 then
		r = value
		g = t
		b = p
	end
	if hue_int and hue_int==1 then
		r = q
		g = value
		b = p
	end
	if hue_int and hue_int==2 then
		r = p
		g = value
		b = t
	end
	if hue_int and hue_int==3 then
		r = p
		g = q
		b = value
	end
	if hue_int and hue_int==4 then
		r = t
		g = p
		b = value
	end
	if hue_int and hue_int==5 then
		r = value
		g = p
		b = q
	end
	return {r,g,b};
end

local function AddButton(self, title, normaltex, highlighttex, clickfunc)
	if not self.buttons then
		self.buttons = {}
	end
	
	-- Create button frame.
	local btn = CreateFrame("Button", nil, self)
	btn.title = title
	btn:SetFrameLevel(5)
	btn:ClearAllPoints()
	btn:SetHeight(12)
	btn:SetWidth(12)
	btn:SetNormalTexture(normaltex)
	btn:SetHighlightTexture(highlighttex, 1.0)
	btn:SetAlpha(0.5)
	btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	btn:SetScript("OnClick", clickfunc)
	btn:SetScript("OnEnter", 
		function(this) 
			GameTooltip_SetDefaultAnchor(GameTooltip, this)
			GameTooltip:SetText(title)
			GameTooltip:Show()
		end)
	btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
	btn:Show()
	
	-- Add to our list of buttons.
	table.insert(self.buttons, btn)
	
	self:AdjustButtons()
end

local function AdjustButtons(self)
	local nr = 0
	local lastbtn = nil
	for i, btn in ipairs(self.buttons) do
		btn:ClearAllPoints()
		
		if btn:IsShown() then
			if nr == 0 then
				btn:SetPoint("TOPRIGHT", self, "TOPRIGHT", -5, 0 - (math.max(self:GetHeight() - btn:GetHeight(), 0) / 2))
			else
				btn:SetPoint("TOPRIGHT", lastbtn, "TOPLEFT", 0, 0)
			end
			lastbtn = btn
			nr = nr + 1
		end
	end
end

local function ClearLegends(self)
	if not self.legends then
		self.legends = {}
	end
	for i, legend in ipairs(self.legends) do
		legend.id = nil
		legend:Hide()
	end
	self.legendoffset = 0
end

-- Adjust legend visibility and anchoring (when resizing for example)
local function AdjustLegends(self)
	if self.legends then
	
		-- Can be shortened to one loop, really.
		local used  = {}
		for i, legend in ipairs(self.legends) do
			if legend.id then
				tinsert(used, legend)
			else
				-- Hide unused legends, just in case.
				legend:Hide()
			end
		end
		
		--[[
		-- Adjust slider if present.
		if self.legendslider then
			self.legendslider:SetMinMaxValues(0, #used)
			
			-- Adjust offset.
			--if #used < (self:GetHeight())
		end
		--]]
		
		local last_legend = nil
		for i, legend in ipairs(used) do
			-- Hide if slider offset.
			if self.legendoffset and self.legendoffset > i then
				legend:Hide()
			else
		
				-- Anchoring
				legend:ClearAllPoints()
				if last_legend then
					legend:SetPoint("TOPLEFT", last_legend, "BOTTOMLEFT", 0, -2)
				else
					legend:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -2)
				end
				
				-- Visibility
				if (legend:GetTop() - legend:GetHeight()) > (self:GetTop() - self:GetHeight()) then
					legend:Show()
				else
					legend:Hide()
				end
			
				last_legend = legend
			end
		end
		
	end
end

local function SetupLegendScrolling(self)
	if not self.legends then
		self.legends = {}
	end
	--[[
	local slider = CreateFrame("Slider", nil, self)
	
	slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	slider:SetBackdrop(	{
				bgFile = "Interface\\Buttons\\UI-SliderBar-Background",	
				edgeFile = "Interface\\Buttons\\UI-SliderBar-Border", 
				tile = true, 
				tileSize = 8, 
				edgeSize = 2, 
				insets = { left = 2, right = 2, top = 2, bottom = 2 }
			}
		)
	slider:SetBackdropColor(0,0,0,0.5)
	slider:SetOrientation("VERTICAL")
	slider:SetWidth(12)
	slider:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
	slider:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 20)
	slider:SetMinMaxValues(0, #self.legends)
	slider:SetValue(0)
	slider:Show()
	slider:EnableMouse(true)
	slider:SetScript("OnValueChanged", 
			function(f) 
				self.legendoffset = slider:GetValue()
				AdjustLegends(self)
			end)
	self.legendslider = slider
	--]]
	self.legendoffset = 0
	self:EnableMouse(true)
	self:SetScript("OnMouseWheel", 
				function(f, direction)
					if direction == 1 and self.legendoffset > 0 then
						self.legendoffset = self.legendoffset - 1
						--slider:SetValue(self.legendoffset)
					elseif direction == -1 then
						self.legendoffset = self.legendoffset + 1
						--slider:SetValue(self.legendoffset)
					end
					AdjustLegends(self)
				end
			)
end

-- Add a legend to self unless it already exists.
local function AddLegend(self, legend_id, legend_label, legend_color)
	if not self.legends then
		self.legends = {}
	end
	local has_legend = nil
	local free_legend = nil
	for i, legend in ipairs(self.legends) do
		if legend.id == legend_id then
			has_legend = legend
		end
		if free_legend == nil and legend.id == nil then
			free_legend = legend
		end
	end
	if not has_legend then
		local l
		if free_legend then
			l = free_legend
--			Skada:Print("reusing legend for "..legend_label)
		else
--			Skada:Print("creating legend for "..legend_label)
			l = CreateFrame("Frame", nil, self)
			l:SetFrameLevel(5)
			l:SetHeight(16)
			l:SetWidth(16)
			l:SetBackdrop( {bgFile = "Interface\\Buttons\\WHITE8X8", tile = false, edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 1, insets = {left = 1, right = 1, top = 1, bottom = 1} } )
			tinsert(self.legends, l)
			
			local f = l:CreateFontString(nil, "OVERLAY", "ChatFontNormal")
			f:SetWidth(self:GetWidth() - 12)
			f:SetHeight(16)
			f:SetJustifyH("LEFT")
			f:SetPoint("TOPLEFT", l, "TOPRIGHT", 3, 0)
			l.text = f
		end
		l.id = legend_id
		l:SetBackdropColor(legend_color[1], legend_color[2], legend_color[3])
		l:ClearAllPoints()
		l.label = legend_label
		l.text:SetText(legend_label)
		l:EnableMouse()
		if self.EnterLegend then
			l:SetScript("OnEnter", function(f) self.EnterLegend(legend_id, legend_label) end)
		end
		if self.LeaveLegend then
			l:SetScript("OnLeave", function(f) self.LeaveLegend(legend_id, legend_label) end)
		end
		if self.ClickLegend then  
			l:SetScript("OnMousedown", function(f, button) self.ClickLegend(legend_id, legend_label, button) end)
		end
	elseif has_legend then
		has_legend:Show()
	end
end

local function showmode(win, id, label, mode)
	-- Add current mode to window traversal history.
	if win.selectedmode then
		tinsert(win.history, win.selectedmode)
	end
	-- Call the Enter function on the mode.
	if mode.Enter then
		mode:Enter(win, id, label)
	end
	-- Display mode.
	win:DisplayMode(mode)
end

local function ClickRow(self, win, id, label, button)
	local click1 = win.metadata.click1
	local click2 = win.metadata.click2
	local click3 = win.metadata.click3
	
	if button == "RightButton" and IsShiftKeyDown() then
		Skada:OpenMenu(win)
	elseif win.metadata.click then
		win.metadata.click(win, id, label, button)
	elseif button == "RightButton" then
		win:RightClick()
	elseif click2 and IsShiftKeyDown() then
		showmode(win, id, label, click2)
	elseif click3 and IsControlKeyDown() then
		showmode(win, id, label, click3)
	elseif click1 then
		showmode(win, id, label, click1)
	end
end

local function EnterRow(self, win, id, label)
	win.ttactive = false
    Skada:ShowTooltip(win, id, label)
end

local function LeaveRow(self, win, id, label)
	if win.ttactive then
		GameTooltip:Hide()
		ttactive = false
	end
end

-- Handy function for making a window resizable.
-- Adds a resizing button to the given frame.
-- Note that the frame's OnUpdate will be temporariy hijacked. Todo: restore previous onupdate after resizing.
local function MakeResizable(self, growup)
	local f
	if self.resizebutton then
		f = self.resizebutton
	else
		f = CreateFrame("Button", "BarGroupResizeButton", self)
		self.resizebutton = f
		f:Show()
		f:SetFrameLevel(11)
		f:SetWidth(16)
		f:SetHeight(16)
		f:EnableMouse(true)
		self:SetResizable(true)
		self:SetMinResize(60,40)
		self:SetMaxResize(800,800)
	end
	f:SetScript("OnMouseDown", 
		function(frame, button)
			if(button == "LeftButton") then 
				self.isResizing = true
				if growup then 
					self:StartSizing("TOPRIGHT")
				else 
					self:StartSizing("BOTTOMRIGHT")
				end
				
				if self.OnResizingInProgress then
					self:SetScript("OnUpdate", function()
							if self.isResizing then
								self:OnResizingInProgress()
							else
								self:SetScript("OnUpdate", nil)
							end
						end)
				end
			end 
		end)
	f:SetScript("OnMouseUp", 
		function(frame,button)
			if self.isResizing == true then
				self:StopMovingOrSizing()
				self.isResizing = false
				if self.OnResizingDone then
					self:OnResizingDone()
				end
			end
		end)
		
	f:ClearAllPoints()
	f:SetNormalTexture("Interface\\CHATFRAME\\UI-ChatIM-SizeGrabber-Down")
	f:SetHighlightTexture("Interface\\CHATFRAME\\UI-ChatIM-SizeGrabber-Down")
	if growup then
		f:SetPoint("TOPRIGHT", self, "TOPRIGHT", 2, 2)
	else
		f:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, -2)
	end
		
end

Skada.GenerateColor = GenerateColor
Skada.AdjustButtons = AdjustButtons
Skada.AddButton = AddButton
Skada.ClearLegends = ClearLegends
Skada.AddLegend = AddLegend
Skada.EnterRow = EnterRow
Skada.LeaveRow = LeaveRow
Skada.ClickRow = ClickRow
Skada.MakeResizable = MakeResizable
Skada.AdjustLegends = AdjustLegends
Skada.SetupLegendScrolling = SetupLegendScrolling