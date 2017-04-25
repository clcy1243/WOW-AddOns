--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2014
	
	Desc:	Custom Cursor Implementation
]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local CursorCustom = Engine.CursorCustom;

local C = Engine.Constants;

local CursorOverlay = CreateFrame("FRAME", "ButtonForgeCursorOverlay", UIParent, "SecureHandlerStateTemplate");
local CursorIcon = CreateFrame("FRAME", nil, CursorOverlay);
local CustomCommand = nil;
local CustomData = nil;
local CustomSubvalue = nil;
local CustomSubSubvalue = nil;


--[[------------------------------------------------
	Configure the Overlay
--------------------------------------------------]]
CursorOverlay:EnableMouse(true);
CursorOverlay:SetPoint("TOPLEFT", UIParent, "TOPLEFT");
CursorOverlay:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT");
CursorOverlay:SetFrameStrata("LOW");


CursorOverlay:SetScript("OnEnter", function () SetCursor("ITEM_CURSOR"); end);
CursorOverlay:SetScript("OnEvent", function () CursorCustom.ClearCustomCursor(); end);
tinsert(UISpecialFrames, CursorOverlay:GetName());
RegisterStateDriver(CursorOverlay, "state-combat", "[combat] true; false");
CursorOverlay:SetAttribute("_onstate-combat", [[if (newstate == "true") then self:Hide(); end]]);
-- More Script Handlers further down


--[[------------------------------------------------
	Configure the Icon
--------------------------------------------------]]
CursorIcon:SetPoint("TOPLEFT", CursorOverlay, "TOPLEFT");
CursorIcon:SetFrameStrata("FULLSCREEN_DIALOG");
CursorIcon:SetMovable(true);

CursorIcon.Texture = CursorIcon:CreateTexture();
CursorIcon.Texture:SetPoint("TOPLEFT", CursorIcon, "TOPLEFT");
CursorIcon.Texture:SetPoint("BOTTOMRIGHT", CursorIcon, "BOTTOMRIGHT");

CursorIcon.CornerTexture = CursorIcon:CreateTexture();
CursorIcon.CornerTexture:SetPoint("TOPLEFT", CursorIcon, "TOPLEFT");
CursorIcon.CornerTexture:SetPoint("BOTTOMRIGHT", CursorIcon, "BOTTOMRIGHT");
CursorIcon.CornerTexture:SetTexture(C.ImagesDir.."Pickup.tga");
CursorIcon.CornerTexture:SetDrawLayer("OVERLAY");


--[[------------------------------------------------
	SetCustomCursor
--------------------------------------------------]]
function CursorCustom.GetCustomCursor()
	return CustomCommand, CustomData, CustomSubvalue, CustomSubSubvalue;
end 

--[[------------------------------------------------
	SetCustomCursor
--------------------------------------------------]]
function CursorCustom.SetCustomCursor(Command, Data, Subvalue, SubSubvalue, Icon, Width, Height, TexCoords)	
	CursorIcon.Texture:SetTexture(Icon);
	SetCursor("ITEM_CURSOR");	
	CursorIcon:SetSize(Width or 23, Height or 23);
	if (TexCoords ~= nil) then
		CursorIcon.Texture:SetTexCoord(unpack(TexCoords));
	else
		CursorIcon.Texture:SetTexCoord(0, 1, 0, 1);
	end
	CustomCommand = Command;
	CustomData = Data;
	CustomSubvalue = Subvalue;
	CustomSubSubvalue = SubSubvalue;
	PlaySoundFile(C.PICKUP_SPELL_SOUND);

	CursorOverlay:RegisterEvent("CURSOR_UPDATE");
	CursorOverlay:SetScript("OnUpdate", CursorOverlay.OnUpdate);

	CursorOverlay:Show();
end


--[[------------------------------------------------
	OnUpdate
--------------------------------------------------]]
function CursorOverlay:OnUpdate()
	local Left, Top = GetCursorPosition();
	local Scale = UIParent:GetEffectiveScale();

	--if (DragIcon.Started) then
	--	SetCursor("ITEM_CURSOR");
	--	DragIcon.Started = false;
	--	DragIcon:RegisterEvent("CURSOR_UPDATE");
	--end
	if (CursorIcon.Left ~= Left or CursorIcon.Top ~= Top) then	
		CursorIcon.Left = Left;
		CursorIcon.Top = Top;
		CursorIcon:ClearAllPoints();
		CursorIcon:SetPoint("TOPLEFT", CursorOverlay, "BOTTOMLEFT", Left / Scale, Top / Scale);
	end
end


--[[------------------------------------------------
	ClearCustomCursor
--------------------------------------------------]]
function CursorCustom.ClearCustomCursor()
	if (CustomCommand ~= nil) then
		CustomCommand = nil;
		CustomData = nil;
		CustomSubvalue = nil;
		CustomSubSubvalue = nil;
		PlaySoundFile(C.DROP_SPELL_SOUND);
		SetCursor(nil);

		CursorOverlay:UnregisterEvent("CURSOR_UPDATE");
		CursorOverlay:SetScript("OnUpdate", nil);
		if (CursorOverlay:IsShown() and not InCombatLockdown()) then
			CursorOverlay:Hide();
		end
	end
end
CursorOverlay:SetScript("OnMouseDown", CursorCustom.ClearCustomCursor);
CursorOverlay:SetScript("OnHide", CursorCustom.ClearCustomCursor);

