--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2016

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local C = Engine.Constants;

local FlyoutUI = Engine.FlyoutUI;
local Methods = Engine.Methods;
local SecureManagement = Engine.SecureManagement;
local Priv = {}

local AttachedBFButton;


function Priv:OnClick()
	Methods.SetFlyoutDirection(AttachedBFButton, self.Direction);
	FlyoutUI.SetDirection(self.Direction);
end

function Priv.SetupButton(Direction, Rotation, Width, Height)
	local Button = CreateFrame("CheckButton", nil, nil, "SecureHandlerBaseTemplate");
	
	Button:SetNormalTexture("Interface\\Addons\\"..AddonName.."\\BFButtonEngine\\Images\\FlyoutArrowSmallUnselected.tga");	
	local Texture = Button:GetNormalTexture();
	Texture:SetTexCoord(0.0, 0.71875, 0.0, 0.6875);
	Texture:SetBlendMode("BLEND");
	SetClampedTextureRotation(Texture, Rotation);

	
	Button:SetHighlightTexture("Interface\\Addons\\"..AddonName.."\\BFButtonEngine\\Images\\FlyoutArrowSmallHiLight.tga");
	Texture = Button:GetHighlightTexture();
	Texture:SetTexCoord(0.0, 0.71875, 0.0, 0.6875);
	Texture:SetBlendMode("ADD");
	SetClampedTextureRotation(Texture, Rotation);
	
	Button:SetPushedTexture("Interface\\Buttons\\ActionBarFlyoutButton");
	Texture = Button:GetPushedTexture(Texture);
	Texture:SetTexCoord(0.62500000, 0.98437500, 0.74218750, 0.82812500);
	Texture:SetBlendMode("BLEND");
	SetClampedTextureRotation(Texture, Rotation);
	
	Button:SetCheckedTexture("Interface\\Buttons\\ActionBarFlyoutButton");
	Texture = Button:GetCheckedTexture();
	Texture:SetTexCoord(0.62500000, 0.98437500, 0.74218750, 0.82812500);
	Texture:SetBlendMode("BLEND");
	SetClampedTextureRotation(Texture, Rotation)

	
	Button:SetSize(Width, Height);
	Button.Direction = Direction;
	Button:SetScript("OnClick", Priv.OnClick);
	SecureManagement.RegisterForOnCombatHide(Button);
	return Button;
end

local UPButton = Priv.SetupButton("UP", 0, 23, 11);
local RIGHTButton = Priv.SetupButton("RIGHT", 90, 11, 23);
local DOWNButton = Priv.SetupButton("DOWN", 180, 23, 11);
local LEFTButton = Priv.SetupButton("LEFT", 270, 11, 23);

local Buttons = {UPButton, RIGHTButton, DOWNButton, LEFTButton};


function FlyoutUI.AttachFlyoutUI(BFButton)
	if (InCombatLockdown()) then
		return;
	end
	AttachedBFButton = BFButton;
	local Inset = 2;
	local ABW = BFButton.ABW;
	UPButton:ClearAllPoints();
	RIGHTButton:ClearAllPoints();
	DOWNButton:ClearAllPoints();
	LEFTButton:ClearAllPoints();

	UPButton:SetParent(ABW);
	RIGHTButton:SetParent(ABW);
	DOWNButton:SetParent(ABW);
	LEFTButton:SetParent(ABW);

	UPButton:SetPoint("TOP", ABW, "TOP", 0, Inset);
	RIGHTButton:SetPoint("RIGHT", ABW, "RIGHT", Inset, 0);
	DOWNButton:SetPoint("BOTTOM", ABW, "BOTTOM", 0, -Inset);
	LEFTButton:SetPoint("LEFT", ABW, "LEFT", -Inset, 0);
	
	UPButton:Show();
	RIGHTButton:Show();
	DOWNButton:Show();
	LEFTButton:Show();
	FlyoutUI.SetDirection(Methods.GetFlyoutDirection(BFButton));
end

function FlyoutUI.DetachFlyoutUI()
	if (AttachedBFButton == nil) then
		return;
	end
	
	UPButton:ClearAllPoints();
	RIGHTButton:ClearAllPoints();
	DOWNButton:ClearAllPoints();
	LEFTButton:ClearAllPoints();

	UPButton:SetParent(nil);
	RIGHTButton:SetParent(nil);
	DOWNButton:SetParent(nil);
	LEFTButton:SetParent(nil);
	
	UPButton:Hide();
	RIGHTButton:Hide();
	DOWNButton:Hide();
	LEFTButton:Hide();
	AttachedBFButton = nil;
end

-- TODO: perhaps change this to use Methods to determine button Type? Maybe?
function FlyoutUI.SetDirection(Direction)
	for i, b in ipairs(Buttons) do
		if (b.Direction == Direction) then
			b:SetChecked(true);
			if (AttachedBFButton.Type == "flyout") then
				b:Hide();
			else
				b:Show();
			end
		else
			b:Show();
			b:SetChecked(false);
		end
	end
end

function FlyoutUI.GetAttachedBFButton()
	return AttachedBFButton;
end
