--[[
Author: Massiner of Nathrezim
Date: 03-May-2009

Hacks and other notes:
1. The fade effect for the bar background is a good canidate to move into the new animation model (I've done a prototype but it didn't work as the onupdate implementation here). - Not applicable since the ui for this has been altered
2. This file could do with some more commenting and general cleanup before reaching v1
3. When we change from vertical to horizontal layout we don't have a fixed pivot point.
	a. This is because the anchor point does not stay fixed when the player drags the bar.
	b. It is possible to code around that issue and correct the position - unfortunately this buggers up positioning between sessions (I tried several different ways to resolve this without luck)
]]

local AddonName, AddonTable = ...;
local ButtonEngineAPI = AddonTable.ButtonEngine.API_V2;
local ButtonEngineC = AddonTable.ButtonEngine.Constants;

-- Todo - tidy this later;
BFEngine = ButtonEngineAPI;
local EBCore = CreateFrame("FRAME"); -- Needs to be a frame to respond to events
EBCore:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
EBCore:RegisterEvent("PLAYER_ENTERING_WORLD");
EBCore:RegisterEvent("VARIABLES_LOADED");
EBCore:RegisterEvent("UPDATE_BINDINGS");
EBCore:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
EBCore:RegisterEvent("PLAYER_REGEN_ENABLED");
EBCore.WorldEntered = false;
EBCore.VariablesLoaded = false;
function EBCore:OnEventInit(event, arg1)
	if (event == "ADDON_LOADED" and arg1 == "ExtraBars") then

	elseif (event == "PLAYER_ENTERING_WORLD") then
		EBCore.WorldEntered = true;
	elseif (event == "VARIABLES_LOADED") then
		EBCore.VariablesLoaded = true;
	end
	
	if (EBCore.WorldEntered and EBCore.VariablesLoaded) then
		EBCore.MasqueGroupSetup();
		EBCore:UnregisterEvent("PLAYER_ENTERING_WORLD");
		EBCore:UnregisterEvent("VARIABLES_LOADED");
		EBCore:SetScript("OnEvent", EBCore.OnEvent);
		EBCore:Init();
	end
end
EBCore:SetScript("OnEvent", EBCore.OnEventInit);

function EBCore:MasqueCallback(Addon, Group, SkinID, Gloss, Backdrop, Colors, Disabled)
	if (Addon == "Extra Bars") then
		
	end
end

function EBCore.MasqueGroupSetup()
	if (LibStub) then
		EBCore.MSQ = LibStub("Masque", true);
		if (EBCore.MSQ) then
			--EBCore.MSQMasterGroup = EBCore.MSQ:Group("Extra Bars");
			EBCore.MSQBar1Group = EBCore.MSQ:Group("Extra Bars", "Bar 1");
			EBCore.MSQBar2Group = EBCore.MSQ:Group("Extra Bars", "Bar 2");
			EBCore.MSQBar3Group = EBCore.MSQ:Group("Extra Bars", "Bar 3");
			EBCore.MSQBar4Group = EBCore.MSQ:Group("Extra Bars", "Bar 4");
			--EBCore.MSQ:Register("Extra Bars", EBCore.MasqueCallback, EBCore)
		end
	end
end



function EBCore:OnEvent(event, arg1)
	if (event == "UPDATE_BINDINGS") then
		EBCore:UpdateKeyBindings();
	elseif (event == "ACTIVE_TALENT_GROUP_CHANGED") then
		EBCore.SwitchSpecActions();
	elseif (event == "PLAYER_REGEN_ENABLED") then
		EBCore.AdjustBarStrata(ButtonEngineAPI.GetCursorInfo());
	end
end

function EBCore.SwitchSpecActions()
	for b = 1, 4 do
		local CurrentSpec = GetSpecialization();
		local BarFrame = _G["ExtraBar"..b];
		local Name = BarFrame:GetName();
		local Buttons = ExtraBarsSave.Bars[b].Specializations[CurrentSpec].Buttons;
		for i = 1, 12 do
			ButtonEngineAPI.SetAction(_G[Name.."Button"..i], Buttons[i], true);
		end
	end
end

function EBCore:UpdateKeyBindings()
	for i = 1, 4 do
		local Bar = _G["ExtraBar"..i];
		local Name = Bar:GetName();
		for j = 1, 12 do
			local Button = _G[Name.."Button"..j];
			local Key = GetBindingKey("CLICK "..Button:GetName()..":LeftButton");
			local Text = GetBindingText(Key, 1); --"KEY_", 1);
			ButtonEngineAPI.SetKeyBindText(Button, Text);
		end
	end
end

function EBCore.AdjustBarStrata(Command)

	if (InCombatLockdown()) then
		return;
	end
	
	if (Command and ExtraBar1:GetFrameStrata() == "LOW") then
		ExtraBar1:SetFrameStrata("DIALOG");
		ExtraBar2:SetFrameStrata("DIALOG");
		ExtraBar3:SetFrameStrata("DIALOG");
		ExtraBar4:SetFrameStrata("DIALOG");
	elseif (not Command and ExtraBar1:GetFrameStrata() == "DIALOG") then
		ExtraBar1:SetFrameStrata("LOW");
		ExtraBar2:SetFrameStrata("LOW");
		ExtraBar3:SetFrameStrata("LOW");
		ExtraBar4:SetFrameStrata("LOW");
	end
end

function EBCore.SetupOnCombatRules()
	local SecureCombatFrame = CreateFrame("FRAME", nil, nil, "SecureHandlerStateTemplate");
	SecureCombatFrame:Hide();

	RegisterStateDriver(SecureCombatFrame, "combat", "[combat] true; false");
	SecureCombatFrame:SetAttribute("_onstate-combat",
		[[
			if (newstate == "true") then
				for k in pairs(BarFrames) do
					k:SetFrameStrata("LOW");
				end
			end
		]]
	);
	SecureCombatFrame:Execute(
		[[
			BarFrames = newtable();
		]]
	);
	
	for i = 1, 4 do
		SecureCombatFrame:SetFrameRef("Frame", _G["ExtraBar"..i]);
		SecureCombatFrame:Execute(
			[[
				Frame = owner:GetFrameRef("Frame");
				BarFrames[Frame] = true;
			]]
		);
	end
end

function EBCore.BFButtonEvents(Event, ...)

	if (Event == ButtonEngineC.EVENT_CURSORCHANGE) then
		EBCore.AdjustBarStrata(...);
	elseif (Event == ButtonEngineC.EVENT_SETACTION) then
		local ActionButton = ...;
		local BarNum, ButtonNum = ActionButton.BarNumber, ActionButton.ButtonNumber;
		local IsFlyout = select(2, ...).Type == "flyout";
		if (tonumber(BarNum) and tonumber(ButtonNum)) then
			ButtonEngineAPI.MouseOverFlyoutDirectionUI(ActionButton, EBCore.GetEnableMoveBar(BarNum) and IsFlyout);
		end
	elseif (Event == ButtonEngineC.EVENT_FLYOUTDIRECTION) then
		local ActionButton = ...;
		local BarNum, ButtonNum = ActionButton.BarNumber, ActionButton.ButtonNumber;
		if (tonumber(BarNum) and tonumber(ButtonNum)) then
			ExtraBarsSave.Bars[BarNum].FlyoutDirections[ButtonNum] = select(2, ...);
		end
	end

end

function EBCore:Init()
	self.UpdateSavedData();
	self:InitBar(ExtraBar1, 1);
	self:InitBar(ExtraBar2, 2);
	self:InitBar(ExtraBar3, 3);
	self:InitBar(ExtraBar4, 4);
	EBCore.SetupOnCombatRules();
	EBCore:UpdateKeyBindings();
	
	-- So we can handle raising and lowering the bar strata
	ButtonEngineAPI.RegisterForEvents(nil, EBCore.BFButtonEvents);
	--ButtonEngineAPI.RegisterForCursorChanges(EBCore.AdjustBarStrata);
	--EBCore.ApplyNonActionSettings();
	--ABTMethods_LoadAll(ExtraBar_ButtonEntries, ExtraBar_ButtonSettings);
end

function EBCore:InitBar(BarFrame, Num)
	
	--Init the bar itself
	local Name = BarFrame:GetName();
	_G["BINDING_HEADER_"..Name] = "Extra Bar "..Num;
	for i = 1, 12 do
	end
	
	local CurrentSpec = GetSpecialization();
	local Buttons = ExtraBarsSave.Bars[Num].Specializations[CurrentSpec].Buttons;
	for i = 1, 12 do
		local ButtonName = string.format("%sButton%d", Name, i);
		local b = ButtonEngineAPI.CreateButton(ButtonName, Buttons[i], true);
		b:SetParent(BarFrame);
		b:SetPoint("TOPLEFT", BarFrame, "TOPLEFT", 16 + ((b:GetWidth() + 6) * (i - 1)), -16);
		_G[string.format("BINDING_NAME_CLICK %s:LeftButton", ButtonName, i)] = string.format("%sButton %d", Name, i);
		ButtonEngineAPI.SetFlyoutDirection(b, ExtraBarsSave.Bars[Num].FlyoutDirections[i]);
		b.BarNumber = Num;
		b.ButtonNumber = i;
	end

	if (EBCore["MSQBar"..Num.."Group"]) then
		local Children = {BarFrame:GetChildren()};
		for i,v in ipairs(Children) do
			if (v:GetObjectType() == "CheckButton") then
				EBCore["MSQBar"..Num.."Group"]:AddButton(v);
			end
		end
		EBCore["MSQBar"..Num.."Group"]:ReSkin();
	end

	
	BarFrame.Number = Num;
	_G[Name.."Number"]:SetAlpha(0);
	_G[Name.."Number"]:SetText(Num);
	_G[Name.."ConfigNumber"]:SetAlpha(0);
	_G[Name.."ConfigNumber"]:SetText(Num);


	BarFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", 
					tile = true, tileSize = 16, edgeSize = 16, 
					insets = nil});
	BarFrame:SetBackdropColor(0.1, 0.1, 0.3, 0);
	
	--This will allow the bar to be dragged, note that EnableMouse must be true for this to work, and is toggled off to lock the bar
	BarFrame:SetMovable(true);

	local Left = ExtraBarsSave.Bars[Num].Left;
	local Top = ExtraBarsSave.Bars[Num].Top;

	if (Left ~= nil and Top ~= nil) then
		BarFrame:ClearAllPoints();
		BarFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", Left, Top);
	end
	BarFrame.OnUpdate = EBCore.OnUpdate;
	--This will setup dragging for the bar.
	BarFrame:SetScript("OnMouseDown", BarFrame.StartMoving);
	BarFrame:SetScript("OnMouseUp",
		function ()
			BarFrame:StopMovingOrSizing();
			ExtraBarsSave.Bars[Num].Left = BarFrame:GetLeft();
			ExtraBarsSave.Bars[Num].Top = BarFrame:GetTop();
		end
		);

	BarFrame:SetScript("OnSizeChanged", EBCore.OnSizeChangedNum);
	
	--Setup secure handlers for enabling and disabling the bar, the main driver for doing this is for vehicles where the user stands a good chance of entering/exiting a vehicle while in combat
	BarFrame:Execute([[ebButtons = newtable(); owner:GetChildList(ebButtons);]]);		--Get secure references to the buttons on this bar
	BarFrame:SetAttribute("_onshow", [[for k, v in ipairs(ebButtons) do v:Enable(); end]]);	--When the bar is shown enable the buttons
	BarFrame:SetAttribute("_onhide", [[for k, v in ipairs(ebButtons) do v:Disable(); end]]);	--When the bar is hidden disable them

	local adjustNumber = ExtraBarConfigLib:CreateIcon("ExtraBar"..Num.."AdjustNumber", BarFrame, "Interface\\Addons\\"..AddonName.."\\Images\\Handle.tga", 16, 32);
	adjustNumber:AddState("bottom", "Interface\\Addons\\"..AddonName.."\\Images\\HandleRot.tga", 32, 16);
	adjustNumber:SetPoint("RIGHT", BarFrame, "RIGHT", 2, 0);
	adjustNumber:EnableMouse(true);
	adjustNumber:SetScript("OnMouseDown",
		function ()
			BarFrame:SetResizable(true);
			BarFrame:SetScript("OnUpdate", BarFrame.OnUpdate);
			BarFrame:StartSizing();
		end);
	adjustNumber:SetScript("OnMouseUp",
		function ()
			BarFrame:StopMovingOrSizing();
			BarFrame:SetResizable(false);
			BarFrame:SetScript("OnUpdate", nil);
			EBCore.SetNumberOfButtons(EBCore.GetNumberOfButtons(Num), Num);
		end);

	local gui = ExtraBarConfigLib:CreateIconButton("ExtraBar"..Num.."Lock", BarFrame, "Interface\\Addons\\"..AddonName.."\\Images\\Gui.tga", "Interface\\Addons\\"..AddonName.."\\Images\\Gui.tga", 12, 12, EBCore.GetEnableMoveBar, EBCore.SetEnableMoveBar, Num);
	gui:SetPoint("TOPRIGHT", BarFrame, "TOPRIGHT", -14, 0);
	
	local orient = ExtraBarConfigLib:CreateIconButton("ExtraBar"..Num.."Orientation", BarFrame, "Interface\\Addons\\"..AddonName.."\\Images\\Horizontal.tga", "Interface\\Addons\\"..AddonName.."\\Images\\Vertical.tga", 12, 12, EBCore.GetUseVerticalLayout, EBCore.SetUseVerticalLayout, Num);
	orient:SetPoint("TOPRIGHT", gui, "TOPLEFT", -2, 0);

	local menu = ExtraBarConfigLib:CreateIcon("ExtraBar"..Num.."Menu", BarFrame, "Interface\\Addons\\"..AddonName.."\\Images\\Menu.tga", 12, 12);
	menu:SetPoint("TOPRIGHT", orient, "TOPLEFT", -2, 0);
	menu:EnableMouse(true);
	menu:SetScript("OnMouseUp", function () EBCore.OpenConfig(Num); end);

	EBCore.RefreshBar(Num);

	--Create the config pages	
	EBCore:InitBarConfig(BarFrame, Num);
	BarFrame:SetClampRectInsets(14, -14, -14, 14);	--I've adjusted the border subsequently so these may be slightly off,
	BarFrame:SetClampedToScreen(true);
end

function EBCore:InitBarConfig(BarFrame, Num)

	local page = ExtraBarConfigLib:CreateConfigPage("EBConfig"..Num, UIParent, "Extra Bar "..Num, "Configure Extra Bar "..Num, "SecureHandlerShowHideTemplate");

	local Desc = {};
	Desc["enabled"] 	= "Enable bar "..Num;
	Desc["HideEmp"] 	= "Hide buttons when they are empty";
	Desc["lockButtons"]	= "Check this option to prevent\nactions being dragged from the bar\n(you will still be able to drop actions on the bar)";
	Desc["MoveBar"] 	= "Move the bar and config ui, including change flyout direction";
	Desc["hideV"] 		= "Check this option to hide the bar\nwhen the player is in a vehicle";
	Desc["vert"] 		= "Lay the bar out vertically\nrather than horizontally";
	Desc["tooltips"] 	= "Show tooltips";
	Desc["NumButtons"] 	= "Adjust the number of buttons\non the bar";
	Desc["size"] 		= "Adjust the button size";

	local enabled = 	ExtraBarConfigLib:CreateCheckBox("EBConfig"..Num.."BEnabled", page				, "Enable Bar", Desc["enabled"]			, true, EBCore.GetEnabled, EBCore.SetEnabled, Num);
	local showGrid = 	ExtraBarConfigLib:CreateCheckBox("EBConfig"..Num.."BHideEmptyButtons", page		, "Hide Empty Buttons", Desc["HideEmp"]	, false, EBCore.GetHideEmptyButtons, EBCore.SetHideEmptyButtons, Num);
	local lockButtons = ExtraBarConfigLib:CreateCheckBox("EBConfig"..Num.."BLockButtons", page			, "Lock Buttons", Desc["lockButtons"]	, false, EBCore.GetLockButtons, EBCore.SetLockButtons, Num);
	local lockBar = 	ExtraBarConfigLib:CreateCheckBox("EBConfig"..Num.."BEnableMoveBar", page		, "Configure Bar", Desc["MoveBar"]	, true, EBCore.GetEnableMoveBar, EBCore.SetEnableMoveBar, Num);
	local hideV = 		ExtraBarConfigLib:CreateCheckBox("EBConfig"..Num.."BHideV", page				, "Hide When in Vehicle", Desc["hideV"]	, true, EBCore.GetHideWhenInVehicle, EBCore.SetHideWhenInVehicle, Num);
	local vert = 		ExtraBarConfigLib:CreateCheckBox("EBConfig"..Num.."BVertical", page				, "Vertical Layout", Desc["vert"]		, false, EBCore.GetUseVerticalLayout, EBCore.SetUseVerticalLayout, Num);
	local tooltips = 	ExtraBarConfigLib:CreateCheckBox("EBConfig"..Num.."BNoTooltips", page			, "Show Tooltips", Desc["tooltips"]		, true, EBCore.GetShowTooltips, EBCore.SetShowTooltips, Num);
	local NumButtons = 	ExtraBarConfigLib:CreateSlider("EBConfig"..Num.."SNumber", page					, "Number of Buttons", Desc["NumButtons"]	, 1, 12, 1, 12, EBCore.GetNumberOfButtons, EBCore.SetNumberOfButtons, Num);
	local size = 		ExtraBarConfigLib:CreateSlider("EBConfig"..Num.."SSize", page					, "Button Size", Desc["size"]				, .1, 2, .05, 1, EBCore.GetScale, EBCore.SetScale, Num);
	
	local textObject = _G["EBConfig"..Num.."Text"];
	local RowHeight = NumButtons:GetHeight() + 12;
	local ColumnWidth = 224; --hideB:GetWidth() + ?;
	
	
	enabled:SetPoint("TOPLEFT", textObject, "BOTTOMLEFT", 0, -0 * RowHeight - 12);
	showGrid:SetPoint("TOPLEFT", textObject, "BOTTOMLEFT", 0, -1 * RowHeight - 12);
	lockButtons:SetPoint("TOPLEFT", textObject, "BOTTOMLEFT", 0, -2* RowHeight - 12);
	tooltips:SetPoint("TOPLEFT", textObject, "BOTTOMLEFT", 0, -3 * RowHeight - 12);
	
	lockBar:SetPoint("TOPLEFT", textObject, "BOTTOMLEFT", ColumnWidth, -0 * RowHeight - 12);
	vert:SetPoint("TOPLEFT", textObject, "BOTTOMLEFT", ColumnWidth, -1 * RowHeight - 12);
	hideV:SetPoint("TOPLEFT", textObject, "BOTTOMLEFT", ColumnWidth, -2 * RowHeight - 12);
	
	NumButtons:SetPoint("TOPLEFT", textObject, "BOTTOMLEFT", 0, -4 * RowHeight - 12 - 24);
	size:SetPoint("TOPLEFT", textObject, "BOTTOMLEFT", 0, -5 * RowHeight - 12 - 48);
	
	--[[
	showGrid:SetPoint("TOPLEFT", enabled, "BOTTOMLEFT", 0, -8);
	hideV:SetPoint("TOPLEFT", showGrid, "BOTTOMLEFT", 0, -8);
	tooltips:SetPoint("TOPLEFT", hideV, "BOTTOMLEFT", 0, -8);
	
	lockBar:SetPoint("TOPLEFT", _G["EBConfig"..Num.."Text"], "BOTTOMLEFT", 224, -8);
	
	
	lockButtons:SetPoint("TOPLEFT", lockButtons, "BOTTOMLEFT", 0, -8);

	vert:SetPoint("TOPLEFT", lockBar, "BOTTOMLEFT", 0, -8);

	NumButtons:SetPoint("TOPLEFT", tooltips, "BOTTOMLEFT", 0, -24);
	size:SetPoint("TOPLEFT", NumButtons, "BOTTOMLEFT", 0, -32);
]]	
	page.bar = BarFrame;

	page.ShowBarNums = EBCore.ShowBarNums;
	page:SetAttribute("_onshow", [[control:CallMethod("ShowBarNums", 1);]]);
	page:SetAttribute("_onhide", [[control:CallMethod("ShowBarNums", 0);]]);
	page:Hide();
end

function EBCore.OpenConfig(Num)
	if (InCombatLockdown()) then
		UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, 1.0, 0.1, 0.1, 1.0);
		return false;
	end

	InterfaceOptionsFrame_OpenToCategory("Extra Bar "..Num);
	InterfaceOptionsFrame_OpenToCategory("Extra Bar "..Num);
end

function EBCore:ShowBarNums(value)
	ExtraBar1ConfigNumber:SetAlpha(value);
	ExtraBar2ConfigNumber:SetAlpha(value);
	ExtraBar3ConfigNumber:SetAlpha(value);
	ExtraBar4ConfigNumber:SetAlpha(value);
end


function EBCore.CalcSize(vertical, Num)
	local sizeA = Num * 42 + 26;
	
	if (vertical) then
		return 68, Num * 42 + 26;
	else
		return Num * 42 + 26, 68;
	end
end

function EBCore:OnUpdate()
	if (InCombatLockdown()) then
		self:StopMovingOrSizing(); self:SetResizable(false);
	end

end


function EBCore.OnSizeChangedNum(self, width, height)

	local Bar = ExtraBarsSave.Bars[self.Number];
	local vertical = Bar.UseVerticalLayout;
	local NumButtons = Bar.NumberOfButtons;
	local bSize = NumButtons * 42 + 26;
	local newNum;
	
	if (InCombatLockdown()) then
		--width, height = EBCore.CalcSize(vertical, NumButtons);
		--self:SetHeight(height);
		--self:SetWidth(width);
		self:StopMovingOrSizing(); self:SetResizable(false);
		return false;
	end
	
	if (vertical) then
		width = 68;
		newNum = math.floor((height - 26) / 42 + .00001);
		if (newNum >= 12) then
			newNum = 12;
			height = 42 * 12 + 26;
		elseif (newNum < 1) then
			newNum = 1;
			height = 42 + 26;
		end
	else
		height = 68;
		newNum = math.floor((width - 26) / 42 + .00001);
		if (newNum >= 12) then
			newNum = 12;
			width = 42 * 12 + 26;
		elseif (newNum < 1) then
			newNum = 1;
			width = 42 + 26;
		end
	end
	
	if (newNum ~= NumButtons) then
		EBCore.SetNumberOfButtons(newNum, self.Number);
	end
	self:SetHeight(height);		--Do this to override what the setNumberOfButtons function does so that we have a smooth gui during manipulation
	self:SetWidth(width);
	Bar.Left = self:GetLeft();
	Bar.Top = self:GetTop();
end

function EBCore.UpdateVisibilityStateDriver(Num)
	if (InCombatLockdown()) then
		return false;
	end
	local barWidget = _G["ExtraBar"..Num];
	local Bar = ExtraBarsSave.Bars[Num];
	if (not Bar.Enabled) then
		UnregisterStateDriver(barWidget, "visibility");
		barWidget:Hide();
	elseif (Bar.HideWhenInVehicle) then
		UnregisterStateDriver(barWidget, "visibility");
		RegisterStateDriver(barWidget, "visibility", "[petbattle][target=vehicle, exists][overridebar] hide; show" );
	else
		UnregisterStateDriver(barWidget, "visibility");
		RegisterStateDriver(barWidget, "visibility", "[petbattle] hide; show" );
		barWidget:Show();
	end
	
	return true;
end


function EBCore.RefreshBar(Num)

	EBCore.SetEnabled(EBCore.GetEnabled(Num), Num);
	EBCore.SetHideEmptyButtons(EBCore.GetHideEmptyButtons(Num), Num);
	EBCore.SetLockButtons(EBCore.GetLockButtons(Num), Num);
	EBCore.SetEnableMoveBar(EBCore.GetEnableMoveBar(Num), Num);
	EBCore.SetHideWhenInVehicle(EBCore.GetHideWhenInVehicle(Num), Num);
	EBCore.SetUseVerticalLayout(EBCore.GetUseVerticalLayout(Num), Num);	
	EBCore.SetShowTooltips(EBCore.GetShowTooltips(Num), Num);
	EBCore.SetNumberOfButtons(EBCore.GetNumberOfButtons(Num), Num);
	EBCore.SetScale(EBCore.GetScale(Num), Num);

end

function EBCore.GetEnabled(Num)
	return ExtraBarsSave.Bars[Num].Enabled;
end

function EBCore.SetEnabled(value, Num)
	if (InCombatLockdown()) then
		return false;
	end
	ExtraBarsSave.Bars[Num].Enabled = value;
	return EBCore.UpdateVisibilityStateDriver(Num);
end


function EBCore.GetHideEmptyButtons(Num)
	return ExtraBarsSave.Bars[Num].HideEmptyButtons;
end

function EBCore.SetHideEmptyButtons(value, Num)
	value = value or false;
	ExtraBarsSave.Bars[Num].HideEmptyButtons = value;

	local buttons = {_G["ExtraBar"..Num]:GetChildren()};
	for i,v in ipairs(buttons) do
		if (v:GetObjectType() == "CheckButton") then
			ButtonEngineAPI.SetAlwaysShowGrid(v, not value);
		end
	end
	return true;
end


function EBCore.GetLockButtons(Num)
	return ExtraBarsSave.Bars[Num].LockButtons;
end

function EBCore.SetLockButtons(value, Num)
	ExtraBarsSave.Bars[Num].LockButtons = value;
		
	local buttons = {_G["ExtraBar"..Num]:GetChildren()};
	for i,v in ipairs(buttons) do
		if (v:GetObjectType() == "CheckButton") then
			ButtonEngineAPI.SetLocked(v, value);
		end
	end

	return true;
end



function EBCore.GetEnableMoveBar(Num)
	return ExtraBarsSave.Bars[Num].EnableMoveBar;
end

function EBCore.SetEnableMoveBar(value, Num)
	if (InCombatLockdown()) then
		return false;
	end
	ExtraBarsSave.Bars[Num].EnableMoveBar = value;
		
	_G["ExtraBar"..Num]:EnableMouse(value);
	if (value) then
		_G["ExtraBar"..Num.."AdjustNumber"]:Show();
		_G["ExtraBar"..Num.."Orientation"]:Show();
		_G["ExtraBar"..Num.."Menu"]:Show();
		_G["ExtraBar"..Num.."Lock"]:SetAlpha(1);
		_G["ExtraBar"..Num.."Lock"]:EnableMouse(true);
		_G["ExtraBar"..Num.."Number"]:SetAlpha(1);
		_G["ExtraBar"..Num]:SetBackdropColor(0.1, 0.1, 0.3, 0.7);
		local buttons = {_G["ExtraBar"..Num]:GetChildren()};
		
		for i,v in ipairs(buttons) do
		if (v:GetObjectType() == "CheckButton" and v:GetAttribute("type") == "flyout") then
			ButtonEngineAPI.MouseOverFlyoutDirectionUI(v, true);
		end
	end
	else
		_G["ExtraBar"..Num.."AdjustNumber"]:Hide();
		_G["ExtraBar"..Num.."Orientation"]:Hide();
		_G["ExtraBar"..Num.."Menu"]:Hide();
		_G["ExtraBar"..Num.."Lock"]:SetAlpha(0);
		_G["ExtraBar"..Num.."Lock"]:EnableMouse(false);
		_G["ExtraBar"..Num.."Number"]:SetAlpha(0);
		_G["ExtraBar"..Num]:SetBackdropColor(0.1, 0.1, 0.3, 0);
			local buttons = {_G["ExtraBar"..Num]:GetChildren()};
		for i,v in ipairs(buttons) do
		if (v:GetObjectType() == "CheckButton") then
			ButtonEngineAPI.MouseOverFlyoutDirectionUI(v, false);
		end
	end
	end
	_G["ExtraBar"..Num.."Lock"]:Refresh();
	return true;
end



function EBCore.GetHideWhenInVehicle(Num)
	return ExtraBarsSave.Bars[Num].HideWhenInVehicle;
end

function EBCore.SetHideWhenInVehicle(value, Num)
	if (InCombatLockdown()) then
		return false;
	end
	ExtraBarsSave.Bars[Num].HideWhenInVehicle = value;
	
	return EBCore.UpdateVisibilityStateDriver(Num);
end



function EBCore.GetUseVerticalLayout(Num)
	return ExtraBarsSave.Bars[Num].UseVerticalLayout;
end

function EBCore.SetUseVerticalLayout(value, Num)
	if (InCombatLockdown()) then
		return false;
	end
	ExtraBarsSave.Bars[Num].UseVerticalLayout = value;
	
	
	local bar = _G["ExtraBar"..Num];
	local buttons ={bar:GetChildren()};
	local prev;
	local left = bar:GetLeft();
	local top = bar:GetTop();

	bar:ClearAllPoints();
	bar:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top);
	if (value) then
		bar:SetWidth(68);
		bar:SetHeight(ExtraBarsSave.Bars[Num].NumberOfButtons * 42 + 26);
		_G[bar:GetName().."AdjustNumber"]:ClearAllPoints();
		_G[bar:GetName().."AdjustNumber"]:SetPoint("BOTTOM", bar, "BOTTOM", 0, -2);
		_G[bar:GetName().."AdjustNumber"]:SetState("bottom");
		
	else
		bar:SetHeight(68);
		bar:SetWidth(ExtraBarsSave.Bars[Num].NumberOfButtons * 42 + 26);
		_G[bar:GetName().."AdjustNumber"]:ClearAllPoints();
		_G[bar:GetName().."AdjustNumber"]:SetPoint("RIGHT", bar, "RIGHT", 2, 0);
		_G[bar:GetName().."AdjustNumber"]:SetState("original");
	end

	for i,v in ipairs(buttons) do
		if (i ~= 1 and v:GetObjectType() == "CheckButton") then
			if (value) then
				v:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -6);
			else
				v:SetPoint("TOPLEFT", prev, "TOPRIGHT", 6, 0);
			end
		end
		prev = v;
	end
	
	_G["ExtraBar"..Num.."Orientation"]:Refresh();
	ExtraBarsSave.Bars[Num].Left = bar:GetLeft();
	ExtraBarsSave.Bars[Num].Top = bar:GetTop();
	return true;
end



function EBCore.GetShowTooltips(Num)
	return ExtraBarsSave.Bars[Num].ShowTooltips;
end

function EBCore.SetShowTooltips(value, Num)
	ExtraBarsSave.Bars[Num].ShowTooltips = value;
	
	local buttons = {_G["ExtraBar"..Num]:GetChildren()};
	for i,v in ipairs(buttons) do
		if (v:GetObjectType() == "CheckButton") then
			ButtonEngineAPI.SetShowTooltip(v, value);
		end
	end
	return true;
end



function EBCore.GetNumberOfButtons(Num)
	return ExtraBarsSave.Bars[Num].NumberOfButtons;	
end

function EBCore.SetNumberOfButtons(value, Num)
	if (InCombatLockdown()) then
		return false;
	end
	ExtraBarsSave.Bars[Num].NumberOfButtons = value;
	
	local bar = _G["ExtraBar"..Num];
	local buttons ={bar:GetChildren()};
	for i,v in ipairs(buttons) do
		if (v:GetObjectType() == "CheckButton") then
			ButtonEngineAPI.SetEnabled(v, i <= value);
		end
	end
	
	local left = bar:GetLeft();
	local top = bar:GetTop();
	
	bar:ClearAllPoints();
	bar:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top);
	if (ExtraBarsSave.Bars[Num].UseVerticalLayout) then
		bar:SetWidth(68);
		bar:SetHeight(value * 42 + 26);
	else
		bar:SetHeight(68);
		bar:SetWidth(value * 42 + 26);
	end
	
	ExtraBarsSave.Bars[Num].Left = bar:GetLeft();
	ExtraBarsSave.Bars[Num].Top = bar:GetTop();
	return true;
end



function EBCore.GetScale(Num)
	return ExtraBarsSave.Bars[Num].Scale;
end

function EBCore.SetScale(value, Num)
	if (InCombatLockdown()) then
		return false;
	end
	local bar = _G["ExtraBar"..Num];
	local scale = ExtraBarsSave.Bars[Num].Scale;
	local left = bar:GetLeft() * scale;
	local top = bar:GetTop() * scale;
	
	ExtraBarsSave.Bars[Num].Scale = value;

	bar:ClearAllPoints();
	bar:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left / value, top / value);
	bar:SetScale(value);
	
	ExtraBarsSave.Bars[Num].Left = bar:GetLeft();
	ExtraBarsSave.Bars[Num].Top = bar:GetTop();
	return true;
end


function EBCore.CreateInitialBars()
	if (not ExtraBarsSave) then
		ExtraBarsSave = {};
		ExtraBarsSave.VersionMajor = 2;
		ExtraBarsSave.VersionMinor = 0;
		ExtraBarsSave.Bars = {};
		
		for i = 1, 4 do
			local Bar = {};
			ExtraBarsSave.Bars[i] = Bar;
			
			-- Default settings
			Bar.LockButtons			= false;
			Bar.HideEmptyButtons	= false;
			Bar.UseVerticalLayout	= false;
			Bar.NumberOfButtons		= 12;
			Bar.Enabled				= true;
			Bar.HideWhenInVehicle	= true;
			Bar.EnableMoveBar		= true;
			Bar.ShowTooltips	= true;
			Bar.Scale			= 1;
			
			local FlyoutDirections = {};
			for b = 1, 12 do
				FlyoutDirections[b] = "UP";
			end
			Bar.FlyoutDirections = FlyoutDirections;
			
			Bar.Specializations = {};
			for s = 1, GetNumSpecializations() do
				Bar.Specializations[s] = {};
				local Buttons = {};
				Bar.Specializations[s].Buttons = Buttons;
				
				for b = 1, 12 do
					Buttons[b] = {};
				end
			end
		end
	end
end




function EBCore.UpdateToV2()
	if (ExtraBar_Config) then
		for b = 1, 4 do
			local Bar = ExtraBarsSave.Bars[b];
			Bar.Left			= ExtraBar_Config["ExtraBar"..b.."Left"];
			Bar.Top				= ExtraBar_Config["ExtraBar"..b.."Top"];
			Bar.LockButtons		= EBCore.NVL(ExtraBar_Config["EB"..b.."CfgLockButtons"]			, false);
			Bar.HideEmptyButtons	= not EBCore.NVL(ExtraBar_Config["EB"..b.."CfgAlwaysShowGrid"]		, true);
			Bar.UseVerticalLayout	= EBCore.NVL(ExtraBar_Config["EB"..b.."CfgVertical"]			, false);
			Bar.NumberOfButtons		= EBCore.NVL(ExtraBar_Config["EB"..b.."CfgNumberOFButtons"]		, 12);
			Bar.Enabled				= EBCore.NVL(ExtraBar_Config["EB"..b.."CfgEnabled"]				, true);
			Bar.HideWhenInVehicle	= EBCore.NVL(ExtraBar_Config["EB"..b.."CfgHideInVehicle"]		, true);
			Bar.EnableMoveBar		= not EBCore.NVL(ExtraBar_Config["EB"..b.."CfgLockBar"]				, false);
			Bar.ShowTooltips	= not EBCore.NVL(ExtraBar_Config["EB"..b.."CfgDisableTooltips"]	, true);
			Bar.Scale			= EBCore.NVL(ExtraBar_Config["EB"..b.."CfgSize"]				, 1);
		end
	end
	
	if (ExtraBar_ButtonSettings) then
		for k, v in pairs(ExtraBar_ButtonSettings) do

			if (string.find(k, "ActualType") and tonumber(string.match(k, "ExtraBar%d+Button%d+Set(%d+)")) <= GetNumSpecializations()) then
				local BarNum, ButtonNum, SpecNum	= string.match(k, "ExtraBar(%d+)Button(%d+)Set(%d+)")
				local Type = v;
				local Value = ExtraBar_ButtonSettings[string.format("ExtraBar%dButton%dSet%dValue", BarNum, ButtonNum, SpecNum)];
				local Name = ExtraBar_ButtonSettings[string.format("ExtraBar%dButton%dSet%dName", BarNum, ButtonNum, SpecNum)];
				local ID = tonumber(ExtraBar_ButtonSettings[string.format("ExtraBar%dButton%dSet%dId", BarNum, ButtonNum, SpecNum)]);
				
				BarNum = tonumber(BarNum);
				ButtonNum = tonumber(ButtonNum);
				SpecNum = tonumber(SpecNum);

				local Button = ExtraBarsSave.Bars[BarNum].Specializations[SpecNum].Buttons[ButtonNum];
				if (Type == "spell") then
					ID = ID or ButtonEngineAPI.LookupSpellID(Name, SpecNum);
					if (ID) then
						Button.SpellID = ID;
						Button.Type = "spell";
					end
										
				elseif (Type == "item") then
					if (ID) then
						Button.ItemID = ID;
						Button.Type = "item";
					end
					
				elseif (Type == "macro") then
					Button.MacroIndex = Value;
					Button.MacroName = Name;
					Button.MacroBody = GetMacroBody(Value);
					Button.Type = "macro";
					
				elseif (Type == "mount") then
					Button.MountID = Value;
					Button.Type = "mount";
				
				elseif (Type == "battlepet") then
					local speciesID, customName, level, xp, maxXp
						, displayID, isFavorite, name = C_PetJournal.GetPetInfoByPetID(Value);
					Button.BattlePetGUID = Value;
					Button.BattlePetSpeciesName = name;
					Button.BattlePetName = customName or name;
					Button.Type = "battlepet";
				end
			end
		end
	end
	ExtraBar_Config = nil;
	ExtraBar_ButtonSettings = nil;
end



--[[This function will iteratively upgrade saved data from old versions to the current
it is also used to init data]]
function EBCore.UpdateSavedData()

	-- First make sure we have the bars
	EBCore.CreateInitialBars();
	
	-- Update from prior to ExtraBars v2
	EBCore.UpdateToV2();
	
end

function EBCore.NVL(v1, v2)
	if (type(v1) == "nil") then
		return v2;
	else
		return v1;
	end
end
