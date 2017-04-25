--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2016


]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;
local SecureManagement = Engine.SecureManagement;



local SecureCombatFrame = CreateFrame("FRAME", nil, nil, "SecureHandlerStateTemplate");
SecureCombatFrame:Hide();

RegisterStateDriver(SecureCombatFrame, "combat", "[combat] true; false");
SecureCombatFrame:SetAttribute("_onstate-combat",
	[[
		if (newstate == "true") then
			for k in pairs(Frames) do
				k:Hide();
			end
		end
	]]
);
SecureCombatFrame:Execute(
	[[
		Frames = newtable();
	]]
);

--[[------------------------------------------------
	RegisterForOnCombatHide
		* A secure method of forcing a frame hidden when combat occurs
		* It is up to the frame itself to reshow itself
--------------------------------------------------]]
function SecureManagement.RegisterForOnCombatHide(Frame)
	SecureCombatFrame:SetFrameRef("Frame", Frame);
	SecureCombatFrame:Execute(
		[[
			Frame = owner:GetFrameRef("Frame");
			Frames[Frame] = true;
		]]
	);
end

--[[------------------------------------------------
	DeregisterForOnCombatHide
--------------------------------------------------]]
function SecureManagement.DeregisterForOnCombatHide(Frame)
	SecureCombatFrame:SetFrameRef("Frame", Frame);
	SecureCombatFrame:Execute(
		[[
			Frame = owner:GetFrameRef("Frame");
			Frames[Frame] = nil;
		]]
	);
end


