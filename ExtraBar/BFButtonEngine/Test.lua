--[[
	Author: Alternator (Massiner of Nathrezim)
	Date:	2015

]]

local AddonName, AddonTable = ...;
local Engine = AddonTable.ButtonEngine;

local API_V2 = Engine.API_V2;


--[[------------------------------------------------
	CreateButton
	Tests
	- FrameName = null, no inactive buttons	(test on fresh, and after test 2 leaves none)
	- FrameName = null, inactive buttons, (repeat x 3 so that none are left)
	- FrameName = non button global
	- FrameName = active button
	- FrameName = inactive button
	- FrameName = unused
--------------------------------------------------]]
function BF_TEST_CreateButton()
	local b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, e;
	
	
	print("Fresh, create a button, not named");
	b1, e = API_V2.CreateButton();
	if (e) then
		print(e);
	else
		print("Pass - Button created, Check!");
		b1.ABW:SetParent(UIParent);
		b1.ABW:SetPoint("CENTER", UIParent, "CENTER", 100, 100);
	end
	
	
	print("Create a button, global name already in use by non BFButton ('UIParent')");
	b2, e = API_V2.CreateButton("UIParent");
	if (e) then	print("Pass", e); else print("Fail!"); end
	
	
	print("Create a button, Name already in use by BFButton", b1.ABW:GetName());
	b3, e = API_V2.CreateButton(b1.ABW:GetName());
	if (e) then	print("Pass", e); else print("Fail!"); end
	
	
	print("Create a button, Name free ('BFButton_CreateTest_1')");
	b4, e = API_V2.CreateButton("BFButton_CreateTest_1");
	if (e) then
		print("Fail!", e);
	else
		print("Pass - Button created, Check!"); 
		b4.ABW:SetParent(UIParent);
		b4.ABW:SetPoint("CENTER", UIParent, "CENTER", 150, 100);
	end
	
	
	print("Create a button, Name in inactive buttons list ('BFButton_CreateTest_2b')");
	b5, e = API_V2.CreateButton();
	b6, e = API_V2.CreateButton("BFButton_CreateTest_2a");
	b7, e = API_V2.CreateButton("BFButton_CreateTest_2b");
	b8, e = API_V2.CreateButton("BFButton_CreateTest_2c");	

	if (API_V2.RemoveButton(b5)) then print("Fail!"); end
	if (API_V2.RemoveButton(b6)) then print("Fail!"); end
	if (API_V2.RemoveButton(b7)) then print("Fail!"); end
	if (API_V2.RemoveButton(b8)) then print("Fail!"); end

	b9, e = API_V2.CreateButton("BFButton_CreateTest_2b");
	if (e) then
		print("Fail!", e);
	else
		print("Pass - Button created, Check name!", b9.ABW:GetName()); 
		b9.ABW:SetParent(UIParent);
		b9.ABW:SetPoint("CENTER", UIParent, "CENTER", 200, 100);
	end

	b5, e = API_V2.CreateButton();
		b5.ABW:SetParent(UIParent);
		b5.ABW:SetPoint("CENTER", UIParent, "CENTER", 250, 100);
	b6, e = API_V2.CreateButton();
		b6.ABW:SetParent(UIParent);
		b6.ABW:SetPoint("CENTER", UIParent, "CENTER", 300, 100);
	b7, e = API_V2.CreateButton();
		b7.ABW:SetParent(UIParent);
		b7.ABW:SetPoint("CENTER", UIParent, "CENTER", 350, 100);
	b8, e = API_V2.CreateButton();
		b8.ABW:SetParent(UIParent);
		b8.ABW:SetPoint("CENTER", UIParent, "CENTER", 400, 100);
	
	print(b5.ABW:GetName());
	print(b6.ABW:GetName());
	print(b7.ABW:GetName());
	print(b8.ABW:GetName());
	print("Pass, if above names have two generic buttons, and two createtest2 buttons");
	
	print("Confirm that there are 7 buttons visible");
	
end
